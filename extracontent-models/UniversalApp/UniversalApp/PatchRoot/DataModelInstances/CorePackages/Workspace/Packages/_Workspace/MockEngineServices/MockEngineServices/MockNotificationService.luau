local t1 = {}

t1.__index = t1

function t1.ScheduleNotification(_, _, _, _) -- line: 8
end
function t1.CancelNotification(_, _) -- line: 10
end
function t1.CancelAllNotification(_) -- line: 12
end
function t1.GetScheduledNotifications(_) -- line: 14
end
function t1.ActionEnabled(_) -- line: 16
end
function t1.ActionTaken(_) -- line: 18
end
function t1.GetPropertyChangedSignal(p11, p12) -- line: 20
	if p12 == "SelectedTheme" then
		return p11._selectedThemeChanged.Event
	end

	error(("%s is not a valid property name"):format((tostring(p12))))
end
function t1.new() -- line: 27
	-- upvalues: t1 (copy)
	local t2 = {
		SelectedTheme = "",
		_selectedThemeChanged = Instance.new("BindableEvent")
	}

	setmetatable(t2, t1)
	t2.RobloxEventReceived = {
		BindableEvent = Instance.new("BindableEvent")
	}
	t2.RobloxConnectionChanged = {
		BindableEvent = Instance.new("BindableEvent")
	}
	t2.RccEventReceived = {
		BindableEvent = Instance.new("BindableEvent")
	}
	t2.RccConnectionChanged = {
		BindableEvent = Instance.new("BindableEvent")
	}

	function t2.RobloxEventReceived.Connect(_, p14) -- line: 50
		-- upvalues: t2 (copy)
		return t2.RobloxEventReceived.BindableEvent.Event:Connect(p14)
	end
	function t2.RobloxEventReceived.Fire(_, p16) -- line: 54
		-- upvalues: t2 (copy)
		t2.RobloxEventReceived.BindableEvent:Fire(p16)
	end
	function t2.RobloxConnectionChanged.Connect(_, p18) -- line: 58
		-- upvalues: t2 (copy)
		return t2.RobloxConnectionChanged.BindableEvent.Event:Connect(p18)
	end
	function t2.RobloxConnectionChanged.Fire(_, p20, p21, p22, p23) -- line: 62
		-- upvalues: t2 (copy)
		t2.RobloxConnectionChanged.BindableEvent:Fire(p20, p21, p22, p23)
	end
	function t2.RccEventReceived.Connect(_, p25) -- line: 71
		-- upvalues: t2 (copy)
		return t2.RccEventReceived.BindableEvent.Event:Connect(p25)
	end
	function t2.RccEventReceived.Fire(_, p27, p28) -- line: 75
		-- upvalues: t2 (copy)
		t2.RccEventReceived.BindableEvent:Fire(p27, p28)
	end
	function t2.RccConnectionChanged.Connect(_, p30) -- line: 79
		-- upvalues: t2 (copy)
		return t2.RccConnectionChanged.BindableEvent.Event:Connect(p30)
	end
	function t2.RccConnectionChanged.Fire(_, p32, p33, p34, p35) -- line: 83
		-- upvalues: t2 (copy)
		t2.RccConnectionChanged.BindableEvent:Fire(p32, p33, p34, p35)
	end

	t2._subscribeToRccEventNamespaceCalls = {}

	function t2.SubscribeToRccEventNamespace(p36, p37) -- line: 89
		table.insert(p36._subscribeToRccEventNamespaceCalls, p37)
	end

	return t2
end

return t1
