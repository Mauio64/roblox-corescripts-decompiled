return function(object, p2)
	object:sendEventDeferred("StreamNotification", "StreamNotificationClientEvent", p2)
end
