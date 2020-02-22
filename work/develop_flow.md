# 软件开发流程控制

## 流程说明
``` mermaid
  graph TD

  start(开始) --> request[需求提出]
  request --> audit{主管审批}
  audit -- yes --> avaliable{可行性判定}
  audit -- no --> exit(结束)
  avaliable -- yes --> plan[排期]
  avaliable -- no --> reason[说明原因]
  
  plan --> process[开发进行中]
  process --> test[系统测试]
  process --> modify[需求变更]
  modify --> avaliable
  test --> finish[提交完成]
  finish --> exit
  reason --> exit
```

## 状态流程

``` mermaid
graph TD
  start(start) --> request
  request{request} -.-> pass
  pass ==> check{check}
  check ==> process
  check ==> pending(pending)
  pending --> check
  pending --> cancel(cancel)
  request -.-> cancel
  process --> finish(finish)
  process ==> pending
```