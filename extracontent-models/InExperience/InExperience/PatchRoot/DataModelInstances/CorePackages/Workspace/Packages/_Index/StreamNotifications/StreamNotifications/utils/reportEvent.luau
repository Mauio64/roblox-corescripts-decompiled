return function(object, p)
	object:sendEventDeferred("StreamNotification", "StreamNotificationClientEvent", p)
end
