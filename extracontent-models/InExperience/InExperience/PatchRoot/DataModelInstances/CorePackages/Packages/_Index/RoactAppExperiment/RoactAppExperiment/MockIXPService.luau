local t1 = {}

t1.__index = t1

function t1.new(p1, p2, p3, p4, n1: number?) -- line: 4
	-- upvalues: t1 (copy)
	local t2 = {
		_browserTrackerLoadingStatus = Enum.IXPLoadingStatus.Initialized,
		_userLoadingStatus = p3 and Enum.IXPLoadingStatus.Initialized or Enum.IXPLoadingStatus.None,
		_userId = n1 or 0,
		_browserTrackerLayerData = p1,
		_userLayerData = p2,
		_initializeDelay = p4 or 0.1,
		_exposureEventsFired = {},
		_browserTrackerBindableEvent = Instance.new("BindableEvent")
	}

	t2.OnBrowserTrackerLayerLoadingStatusChanged = t2._browserTrackerBindableEvent.Event
	t2._userBindableEvent = Instance.new("BindableEvent")
	t2.OnUserLayerLoadingStatusChanged = t2._userBindableEvent.Event
	setmetatable(t2, t1)

	return t2
end
function t1._SetBrowserTrackerIXPLoadingStatus(p5, p6) -- line: 32
	if p6 ~= p5._browserTrackerLoadingStatus then
		p5._browserTrackerLoadingStatus = p6
		p5._browserTrackerBindableEvent:Fire(p6)
	end
end
function t1._SetUserIXPLoadingStatus(p7, p8, p9) -- line: 39
	if p8 ~= p7._userLoadingStatus or p9 ~= p7._userId then
		p7._userLoadingStatus = p8
		p7._userId = p9
		p7._userBindableEvent:Fire(p7._userLoadingStatus, p7._userId)
	end
end
function t1.RegisterUserLayers(_, _) -- line: 47
end
function t1.InitializeUserLayers(p12, p13) -- line: 49
	if p12._userLoadingStatus ~= Enum.IXPLoadingStatus.Initialized or p12._userId ~= 0 and p13 ~= p12._userId then
		p12:_SetUserIXPLoadingStatus(Enum.IXPLoadingStatus.Pending, p13)
		spawn(function() -- line: 56
			-- upvalues: p12 (copy), p13 (copy)
			wait(p12._initializeDelay)
			p12:_SetUserIXPLoadingStatus(Enum.IXPLoadingStatus.Initialized, p13)
		end)
	end
end
function t1.GetBrowserTrackerLayerVariables(p14, p15) -- line: 63
	if p14._browserTrackerLoadingStatus == Enum.IXPLoadingStatus.Initialized then
		return p14._browserTrackerLayerData[p15]
	end

	return {}
end
function t1.GetUserLayerVariables(p16, p17) -- line: 70
	if p16._userLoadingStatus == Enum.IXPLoadingStatus.Initialized then
		return p16._userLayerData[p17]
	end

	return {}
end
function t1.ClearUserLayers(p18) -- line: 77
	p18._userLoadingStatus = Enum.IXPLoadingStatus.None
	p18._userId = 0
	p18._userBindableEvent:Fire(p18._userLoadingStatus, p18._userId)
end
function t1.GetBrowserTrackerLayerLoadingStatus(p19) -- line: 83
	return p19._browserTrackerLoadingStatus
end
function t1.GetUserLayerLoadingStatus(p20) -- line: 87
	return p20._userLoadingStatus
end
function t1.GetBrowserTrackerStatusForLayer(p21, _) -- line: 91
	return p21._browserTrackerLoadingStatus
end
function t1.GetUserStatusForLayer(p23, _) -- line: 95
	return p23._userLoadingStatus
end
function t1.LogUserLayerExposure(p25, p26) -- line: 99
	table.insert(p25._exposureEventsFired, p26)
end
function t1.LogBrowserTrackerLayerExposure(p27, p28) -- line: 103
	table.insert(p27._exposureEventsFired, p28)
end

return t1
