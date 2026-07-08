return {
	ToastEvents = {
		AttemptDisplay = "ToastNotifications.displayToastNotification",
		Display = "ToastNotifications.displayedToastNotification",
		Update = "ToastNotifications.updatedToastNotification",
		UserAction = "ToastNotifications.UserActionOnToastNotification"
	},
	RegisteredCallbacks = {},
	DispatchEvent = function(t1: {[any]: any}, s1: string, s2: string, t2: {[any]: any}) -- line: 12
		local v5 = t1.RegisteredCallbacks[s2] and t1.RegisteredCallbacks[s2][s1]

		if v5 then
			for v6 in v5 do
				task.spawn(v6, t2)
			end
		end
	end,
	RemoveCallback = function(t3: {[any]: any}, s3: string, s4: string, p1: ((...any) -> ...any)) -- line: 22
		local v11 = t3.RegisteredCallbacks[s4] and t3.RegisteredCallbacks[s4][s3]

		if not v11 then
			return
		end

		v11[p1] = nil

		if not next(v11) then
			t3.RegisteredCallbacks[s4][s3] = nil

			if not next(t3.RegisteredCallbacks[s4]) then
				t3.RegisteredCallbacks[s4] = nil
			end
		end
	end,
	RegisterCallback = function(t4: {[any]: any}, s5: string, s6: string, p2: ((...any) -> ...any)) -- line: 37
		if not t4.RegisteredCallbacks[s6] then
			t4.RegisteredCallbacks[s6] = {}
		end

		if not t4.RegisteredCallbacks[s6][s5] then
			t4.RegisteredCallbacks[s6][s5] = {}
		end

		t4.RegisteredCallbacks[s6][s5][p2] = true

		return function() -- line: 45
			-- upvalues: t4 (copy), s5 (copy), s6 (copy), p2 (copy)
			t4:RemoveCallback(s5, s6, p2)
		end
	end
}
