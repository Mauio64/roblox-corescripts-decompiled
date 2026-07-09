local BindableEvent = Instance.new("BindableEvent")

return {
	BindableEvent = BindableEvent,
	setAppChatVisible = function(b1: boolean) -- line: 3
		-- upvalues: BindableEvent (copy)
		BindableEvent:Fire(b1)
	end
}
