local bindableEvent = Instance.new("BindableEvent")

return {
	BindableEvent = bindableEvent,
	setAppChatVisible = function(flag: boolean)
		bindableEvent:Fire(flag)
	end
}
