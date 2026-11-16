local RunService = game:GetService("RunService")
local IXPService = game:GetService("IXPService")

game:DefineFastFlag("IXPServiceWrapperWaitRefactor", false)

local function fn() -- 1 equivalent call inferred from this helper
	return game:GetFastFlag("IXPServiceWrapperWaitRefactor")
end

local IXPServiceWrapper = {}

function IXPServiceWrapper:InitializeAsync(p, p2)
	local success, result = pcall(function()
		if RunService:IsStudio() then
			IXPService:ClearUserLayers()
		end

		IXPService:RegisterUserLayers(p2)
		IXPService:InitializeUserLayers(p)

		if fn() then -- inferred equivalent call
			return self:WaitForInitialization()
		end

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

function IXPServiceWrapper:WaitForInitialization()
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

return IXPServiceWrapper
