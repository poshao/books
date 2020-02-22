# Notification消息通知

## 权限
  Notification.permission

* denied — 用户拒绝显示通知.
* granted — 用户允许通知.
* default — 在不确定用户选择前，默认表现为拒绝显示.

## 配置选项

* <b>Notification.actions</b> <i>只读</i>

The actions array of the notification as specified in the constructor's options parameter.

* <b>Notification.badge</b> <i>只读</i>

The URL of the image used to represent the notification when there is not enough space to display the notification itself.

* <b>Notification.body</b> <i>只读</i>

The body string of the notification as specified in the constructor's options parameter.

* <b>Notification.data</b> <i>只读</i>

Returns a structured clone of the notification’s data.

* <b>Notification.dir</b> <i>只读</i>

The text direction of the notification as specified in the constructor's options parameter.

* <b>Notification.lang</b> <i>只读</i>

The language code of the notification as specified in the constructor's options parameter.

* <b>Notification.tag</b> <i>只读</i>

The ID of the notification (if any) as specified in the constructor's options parameter.

* <b>Notification.icon</b> <i>只读</i>

The URL of the image used as an icon of the notification as specified in the constructor's options parameter.

* <b>Notification.image</b> <i>只读</i>

The URL of an image to be displayed as part of the notification, as specified in the constructor's options parameter.

* <b>Notification.renotify</b> <i>只读</i>

Specifies whether the user should be notified after a new notification replaces an old one.

* <b>Notification.requireInteraction</b> <i>只读</i>

直到用户点击才关闭通知

* <b>Notification.silent</b> <i>只读</i>

Specifies whether the notification should be silent — i.e., no sounds or vibrations should be issued, regardless of the device settings.

* <b>Notification.timestamp</b> <i>只读</i>

Specifies the time at which a notification is created or applicable (past, present, or future).

* <b>Notification.title</b> <i>只读</i>

The title of the notification as specified in the first parameter of the constructor.

* <b>Notification.vibrate</b> <i>只读</i>

Specifies a vibration pattern for devices with vibration hardware to emit.

## 案例
``` javascript
function notifyMe() {
  // Let's check if the browser supports notifications
  if (!("Notification" in window)) {
    alert("This browser does not support desktop notification");
  }

  // Let's check whether notification permissions have already been granted
  else if (Notification.permission === "granted") {
    // If it's okay let's create a notification
    var notification = new Notification("Hi there!");
  }

  // Otherwise, we need to ask the user for permission
  else if (Notification.permission !== "denied") {
    Notification.requestPermission().then(function (permission) {
      // If the user accepts, let's create a notification
      if (permission === "granted") {
        var notification = new Notification("Hi there!");
      }
    });
  }

  // At last, if the user has denied notifications, and you 
  // want to be respectful there is no need to bother them any more.
}
```