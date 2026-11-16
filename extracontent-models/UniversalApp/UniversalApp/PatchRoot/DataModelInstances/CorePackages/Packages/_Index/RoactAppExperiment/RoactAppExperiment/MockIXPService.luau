local MockIXPService = {}
MockIXPService.__index = MockIXPService

function MockIXPService.new(browserTrackerLayerData, userLayerData, p, value, value2: number?)
	local v = {
		_browserTrackerLoadingStatus = Enum.IXPLoadingStatus.Initialized,
		_userLoadingStatus = p and Enum.IXPLoadingStatus.Initialized or Enum.IXPLoadingStatus.None,
		_userId = value2 or 0,
		_browserTrackerLayerData = browserTrackerLayerData,
		_userLayerData = userLayerData,
		_initializeDelay = value or 0.1,
		_exposureEventsFired = {}
	}

	v._browserTrackerBindableEvent = Instance.new("BindableEvent")
	v.OnBrowserTrackerLayerLoadingStatusChanged = v._browserTrackerBindableEvent.Event

	v._userBindableEvent = Instance.new("BindableEvent")
	v.OnUserLayerLoadingStatusChanged = v._userBindableEvent.Event

	setmetatable(v, MockIXPService)
	return v
end

function MockIXPService:_SetBrowserTrackerIXPLoadingStatus(browserTrackerLoadingStatus)
	if self._browserTrackerLoadingStatus ~= browserTrackerLoadingStatus then
		self._browserTrackerLoadingStatus = browserTrackerLoadingStatus
		self._browserTrackerBindableEvent:Fire(browserTrackerLoadingStatus)
	end
end

function MockIXPService:_SetUserIXPLoadingStatus(userLoadingStatus, userId)
	if self._userLoadingStatus ~= userLoadingStatus or self._userId ~= userId then
		self._userLoadingStatus = userLoadingStatus
		self._userId = userId
		self._userBindableEvent:Fire(self._userLoadingStatus, self._userId)
	end
end

function MockIXPService.RegisterUserLayers(_, _) end

function MockIXPService:InitializeUserLayers(p)
	if self._userLoadingStatus ~= Enum.IXPLoadingStatus.Initialized or self._userId ~= 0 and p ~= self._userId then
		self:_SetUserIXPLoadingStatus(Enum.IXPLoadingStatus.Pending, p)
		spawn(function()
			wait(self._initializeDelay)
			self:_SetUserIXPLoadingStatus(Enum.IXPLoadingStatus.Initialized, p)
		end)
	end
end

function MockIXPService:GetBrowserTrackerLayerVariables(p)
	if self._browserTrackerLoadingStatus == Enum.IXPLoadingStatus.Initialized then
		return self._browserTrackerLayerData[p]
	end

	return {}
end

function MockIXPService:GetUserLayerVariables(p)
	if self._userLoadingStatus == Enum.IXPLoadingStatus.Initialized then
		return self._userLayerData[p]
	end

	return {}
end

function MockIXPService:ClearUserLayers()
	self._userLoadingStatus = Enum.IXPLoadingStatus.None
	self._userId = 0
	self._userBindableEvent:Fire(self._userLoadingStatus, self._userId)
end

function MockIXPService:GetBrowserTrackerLayerLoadingStatus()
	return self._browserTrackerLoadingStatus
end

function MockIXPService:GetUserLayerLoadingStatus()
	return self._userLoadingStatus
end

function MockIXPService:GetBrowserTrackerStatusForLayer(_)
	return self._browserTrackerLoadingStatus
end

function MockIXPService:GetUserStatusForLayer(_)
	return self._userLoadingStatus
end

function MockIXPService:LogUserLayerExposure(p)
	table.insert(self._exposureEventsFired, p)
end

function MockIXPService:LogBrowserTrackerLayerExposure(p)
	table.insert(self._exposureEventsFired, p)
end

return MockIXPService
