local bindableEvent = Instance.new("BindableEvent")

return {
	BindableEvent = bindableEvent,
	setAppChatVisible = function(p2)
		bindableEvent:Fire(p2)
	end
}
