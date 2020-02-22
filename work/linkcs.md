# 放单平台流程说明
[TOC]

## 需求说明
  * 规范出货信息，帮助CS填写准确的出货资料
  * 减少邮件沟通
  * 实现实时状态可查询

## 实现步骤

### 状态流程图
``` mermaid
graph TD
  start(start) --> sended
  sended --> pre_send
  sended --> cancel
  pre_send --> sended
  pre_send --> cancel
  sended -.-> lock
  lock -.-> reject
  lock -.-> pass
  pass -.-> finish(finish)
  reject --> cancel(cancel)
  reject --> resend(resend)
```

虚线: Shipping 操作流
实线: CS 操作流

|状态名|描述|
|-|-|
|pre_send|草稿|
|sended|已发送|
|lock|锁定|
|pass|通过|
|reject|拒绝|
|finish|完成|
|cancel|取消|
|resend|已重发|

### 功能细节
#### 订单管理

1. 新建订单
    * 解析订单信息结构树加载界面
        1. 加载用户临时文件夹的附件列表
        2. 解析结构树加载界面,结构描述如下
    ``` js
    [{
      /**
        * 控件类型
        *
        * 可选参数:
        *
        * combobox: 组合框,list为下拉选项列表
        * checkbox: 复选框
        * textbox: 文本框
        * areatext: 文本区域
        * date: 日期选择器
        * upload: 文件上传
        */
      type: 'combobox',
      /**
        * 提交数据的字段名称
        */
      id: 'level',
      /**
        * 表单提示字符
        */
      title: '紧急程度',
      /**
        * 组合框下拉选项
        *
        * id:value
        */
      list: {
        'normal': 'Normal',
        'grade_a': 'Grade A',
        'grade_b': 'Grade B',
        'grade_c': 'Grade C'
      },
      /**
        * 标识必填字段,默认为true
        */
      required: true,
      /**
        * 文本框提示文字
        */
      tip: '',
      /**
        * 使用URI转码,默认为false
        * 处理特殊字符
        */
      encoding:true,
      /**
        * 子控件加载选项
        */
      options: {
        // checkbox 选中为 true
        'true': [{
          // ...控件配置
        }, {
          // ...控件配置2
        }],
        'normal': [{
          // ...控件配置3
        }]
      }
    }]
    ```

    * 通过拖拽方式上传附件
        1. 在服务端创建以用户工号命名的文件夹
        2. 将上传的文件临时存档至上述文件夹
        3. 在提交订单时将附件归档并清空临时用户文件夹

2. 更新订单
    * 在状态为草稿(pre_send)的订单可以跳转到编辑界面(复制填写的订单信息及附件信息)
    * 提交后状态变更为已发送状态(sended)
3. 复制订单

4. 状态更新
    * 根据状态流程图进行状态变更

5. 订单列表
    * 列表显示
      1. 在列表显示 ID,DN/EI,紧急程度,状态,创建人/时间,受理人/时间 字段
    * 操作命令
      2. 根据状态流程显示相应的操作按钮
        * pre_send: 编辑,取消
        * sended: 撤销,锁定,取消
        * lock: 通过,拒绝
        * pass: 完成
        * reject: 重发,取消
        * cancel,resend,finish: 无操作
    * 筛选条件/数据分页
        <b>筛选语法结构:</b> 字段名称 , 操作符 , 值
        字段名称: 结构树里的字段名称
        操作符: = , > , < , >= , <= , != , in , like
        值: 筛选的值
        <br>
        <i>以AND组合各个条件</i>
        
        <b>分页</b>
        index: 页码 从0开始
        count: 每页行数

#### 消息通知

通知触发条件: 新订单生成，拒绝状态

使用Websocket作为通讯载体,在提交订单时由php完成消息发送
客户端在使用token验证登陆信息

消息汇总10分钟后分发到用户

数据结构

``` json
  "src":"8020507",//通知发起人
  //目标群体
  // {type:"group","data":"groupname"}
  "target":"8123456",
  "app":"linkcs",//应用名称
  "priority":3, //优先级 1 < 2 < 3 < 4 < 5 < 6
  "data":{},//传输数据
  //发送时间
  "time":"2019/05/21"
```

新建订单数据包结构
``` json
{
  "src":"8020507",
  "target":{
    "data":"shipping",
    "type":"group"
  },
  "app":"linkcs",
  "priority":"3",
  "data":{
    "icon":"url",
    "orderid":123,
    "status":"sended"
  },
  "time":"2019/05/21"
}
```

订单状态更新数据包结构
```json
{
  "src":"8020507",
  "target":"8123456",
  "app":"linkcs",
  "priority":"3",
  "data":{
    "icon":"url",
    "orderid":123,
    "status":"reject"
  },
  "time":"2019/05/21"
}
```