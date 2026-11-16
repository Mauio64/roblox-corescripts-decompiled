local RunService = game:GetService("RunService")
local IXPService = game:GetService("IXPService")
local IXPServiceWrapper = {}

function IXPServiceWrapper.InitializeAsync(_, p, p2)
	local success, result = pcall(function()
		if RunService:IsStudio() then
			IXPService:ClearUserLayers()
		end

		IXPService:RegisterUserLayers(p2)
		IXPService:InitializeUserLayers(p)
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
end

function IXPServiceWrapper.WaitForInitialization(_)
	local userLayerLoadingStatus = IXPService:GetUserLayerLoadingStatus()

	while
		userLayerLoadingStatus == Enum.IXPLoadingStatus.None
		or userLayerLoadingStatus == Enum.IXPLoadingStatus.Pending
	do
		IXPService.OnUserLayerLoadingStatusChanged:Wait()
		userLayerLoadingStatus = IXPService:GetUserLayerLoadingStatus()
	end

	return userLayerLoadingStatus
end

function IXPServiceWrapper.GetLayerData(_, p)
	local success, result = pcall(function()
		return IXPService:GetUserLayerVariables(p)
	end)

	return success and result or nil
end

function IXPServiceWrapper.GetBTIDLayerData(_, p)
	local success, result = pcall(function()
		return IXPService:GetBrowserTrackerLayerVariables(p)
	end)

	return success and result or nil
end

function IXPServiceWrapper:LogUserLayerExposure(p)
	pcall(function()
		IXPService:LogUserLayerExposure(p)
	end)
end

function IXPServiceWrapper:LogBrowserTrackerLayerExposure(p)
	pcall(function()
		IXPService:LogBrowserTrackerLayerExposure(p)
	end)
end

function IXPServiceWrapper:LogFlagLinkedUserLayerExposure(p)
	if game:GetEngineFeature("EnableLogFlagLinkedUserLayerExposure") then
		pcall(function()
			IXPService:LogFlagLinkedUserLayerExposure(p)
		end)
	end
end

return IXPServiceWrapper
