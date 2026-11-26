return {
	ToastEvents = {
		AttemptDisplay = "ToastNotifications.displayToastNotification",
		Display = "ToastNotifications.displayedToastNotification",
		Update = "ToastNotifications.updatedToastNotification",
		UserAction = "ToastNotifications.UserActionOnToastNotification"
	},
	RegisteredCallbacks = {},
	DispatchEvent = function(self, p3, p4, p5)
		local v5 = self.RegisteredCallbacks[p4] and self.RegisteredCallbacks[p4][p3]

		if v5 then
			for callback in v5 do
				task.spawn(callback, p5)
			end
		end
	end,
	RemoveCallback = function(self, p3, p4, p5)
		local v5 = self.RegisteredCallbacks[p4] and self.RegisteredCallbacks[p4][p3]

		if not v5 then
			return
		end

		v5[p5] = nil

		if not next(v5) then
			self.RegisteredCallbacks[p4][p3] = nil

			if not next(self.RegisteredCallbacks[p4]) then
				self.RegisteredCallbacks[p4] = nil
			end
		end
	end,
	RegisterCallback = function(self, p2, p3, p4)
		if not self.RegisteredCallbacks[p3] then
			self.RegisteredCallbacks[p3] = {}
		end

		if not self.RegisteredCallbacks[p3][p2] then
			self.RegisteredCallbacks[p3][p2] = {}
		end

		self.RegisteredCallbacks[p3][p2][p4] = true
		return function()
			self:RemoveCallback(p2, p3, p4)
		end
	end
}
