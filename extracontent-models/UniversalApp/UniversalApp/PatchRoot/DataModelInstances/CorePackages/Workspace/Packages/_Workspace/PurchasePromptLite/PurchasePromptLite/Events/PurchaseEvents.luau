local BindableEvent = Instance.new("BindableEvent")

return {
	purchaseCompletedEvent = BindableEvent.Event,
	firePurchaseCompleted = function() -- line: 15
		-- upvalues: BindableEvent (copy)
		BindableEvent:Fire()
	end
}
