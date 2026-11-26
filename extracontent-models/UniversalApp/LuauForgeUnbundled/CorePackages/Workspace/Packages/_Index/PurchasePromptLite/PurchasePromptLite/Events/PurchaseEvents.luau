local bindableEvent = Instance.new("BindableEvent")

return {
	purchaseCompletedEvent = bindableEvent.Event,
	firePurchaseCompleted = function()
		bindableEvent:Fire()
	end
}
