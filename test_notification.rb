#!/usr/bin/env ruby

# https://developer.gnome.org/notification-spec/

require "dbus"

bus = DBus::SessionBus.instance
notification_object = bus.service("org.freedesktop.Notifications").object("/org/freedesktop/Notifications")
notification_object.introspect

notifier = notification_object["org.freedesktop.Notifications"]

notification_id, = notifier.Notify(
  $0, 0, "file://" + File.join(__dir__, 'geeko.png'),
  "Geeko says hi!",
  "This is a test notification. <i>It's very cool!</i>\nThe button doesn't do anything.",
  ["test", "I'm a button!"],
  {},
  -1
)

notifier.on_signal("ActionInvoked") do |notification_id, action|
  puts "Action '#{action}' was taken"
end

notifier.on_signal("NotificationClosed") do |notification_id, reason|
  puts "Notification closed (reason: #{reason})"
  exit
end

loop = DBus::Main.new
loop << bus
loop.run
