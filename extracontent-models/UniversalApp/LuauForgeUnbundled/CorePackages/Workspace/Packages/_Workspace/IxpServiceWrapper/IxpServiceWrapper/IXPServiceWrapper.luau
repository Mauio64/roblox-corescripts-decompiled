local RunService = game:GetService("RunService")
local IXPService = game:GetService("IXPService")

return {
	InitializeAsync = function(p2, p3, p4)
		local success, result = pcall(function()
			if RunService:IsStudio() then
				IXPService:ClearUserLayers()
			end

			IXPService:RegisterUserLayers(p4)
			IXPService:InitializeUserLayers(p3)
			local userLayerLoadingStatus = IXPService:GetUserLayerLoadingStatus()

			while
				userLayerLoadingStatus == Enum.IXPLoadingStatus.None
				or userLayerLoadingStatus == Enum.IXPLoadingStatus.Pending
			do
				IXPService.OnUserLayerLoadingStatusChanged:Wait()
				userLayerLoadingStatus = IXPService:GetUserLayerLoadingStatus()
			end

			return userLayerLoadingStatus
		end)

		return success, result
	end,
	WaitForInitialization = function(self)
		local userLayerLoadingStatus = IXPService:GetUserLayerLoadingStatus()

		while
			userLayerLoadingStatus == Enum.IXPLoadingStatus.None
			or userLayerLoadingStatus == Enum.IXPLoadingStatus.Pending
		do
			IXPService.OnUserLayerLoadingStatusChanged:Wait()
			userLayerLoadingStatus = IXPService:GetUserLayerLoadingStatus()
		end

		return userLayerLoadingStatus
	end,
	GetLayerData = function(self, p3)
		local success, result = pcall(function()
			return IXPService:GetUserLayerVariables(p3)
		end)

		return success and result or nil
	end,
	GetBTIDLayerData = function(self, p3)
		local success, result = pcall(function()
			return IXPService:GetBrowserTrackerLayerVariables(p3)
		end)

		return success and result or nil
	end,
	LogUserLayerExposure = function(self, p3)
		pcall(function()
			IXPService:LogUserLayerExposure(p3)
		end)
	end,
	LogBrowserTrackerLayerExposure = function(self, p3)
		pcall(function()
			IXPService:LogBrowserTrackerLayerExposure(p3)
		end)
	end,
	LogFlagLinkedUserLayerExposure = function(self, p3)
		if game:GetEngineFeature("EnableLogFlagLinkedUserLayerExposure") then
			pcall(function()
				IXPService:LogFlagLinkedUserLayerExposure(p3)
			end)
		end
	end
}
