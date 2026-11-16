local LifecycleEvents = {}
LifecycleEvents.ToastEvents = {
	AttemptDisplay = "ToastNotifications.displayToastNotification",
	Display = "ToastNotifications.displayedToastNotification",
	Update = "ToastNotifications.updatedToastNotification",
	UserAction = "ToastNotifications.UserActionOnToastNotification"
}

LifecycleEvents.RegisteredCallbacks = {}

function LifecycleEvents.DispatchEvent(p, p2: string, p3: string, p4)
	local v = p.RegisteredCallbacks[p3] and p.RegisteredCallbacks[p3][p2]

	if v then
		for callback in v do
			task.spawn(callback, p4)
		end
	end
end

function LifecycleEvents:RemoveCallback(p: string, p2: string, callback)
	local v = self.RegisteredCallbacks[p2] and self.RegisteredCallbacks[p2][p]

	if not v then
		return
	end

	v[callback] = nil

	if not next(v) then
		self.RegisteredCallbacks[p2][p] = nil

		if not next(self.RegisteredCallbacks[p2]) then
			self.RegisteredCallbacks[p2] = nil
		end
	end
end

function LifecycleEvents:RegisterCallback(p: string, p2: string, callback)
	if not self.RegisteredCallbacks[p2] then
		self.RegisteredCallbacks[p2] = {}
	end

	if not self.RegisteredCallbacks[p2][p] then
		self.RegisteredCallbacks[p2][p] = {}
	end

	self.RegisteredCallbacks[p2][p][callback] = true
	return function()
		self:RemoveCallback(p, p2, callback)
	end
end

return LifecycleEvents
