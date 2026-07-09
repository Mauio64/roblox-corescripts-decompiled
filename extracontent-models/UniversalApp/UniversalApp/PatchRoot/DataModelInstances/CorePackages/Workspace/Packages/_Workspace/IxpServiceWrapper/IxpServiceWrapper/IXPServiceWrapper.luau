local RunService = game:GetService("RunService")
local IXPService = game:GetService("IXPService")

return {
	InitializeAsync = function(_, p2, p3) -- line: 30
		-- upvalues: RunService (copy), IXPService (copy)
		local ok, result = pcall(function() -- line: 31
			-- upvalues: RunService (copy), IXPService (copy), p3 (copy), p2 (copy)
			if RunService:IsStudio() then
				IXPService:ClearUserLayers()
			end

			IXPService:RegisterUserLayers(p3)
			IXPService:InitializeUserLayers(p2)

			local UserLayerLoadingStatus = IXPService:GetUserLayerLoadingStatus()

			while UserLayerLoadingStatus == Enum.IXPLoadingStatus.None or UserLayerLoadingStatus == Enum.IXPLoadingStatus.Pending do
				IXPService.OnUserLayerLoadingStatusChanged:Wait()
				UserLayerLoadingStatus = IXPService:GetUserLayerLoadingStatus()
			end

			return UserLayerLoadingStatus
		end)

		return ok, result
	end,
	WaitForInitialization = function(_) -- line: 55
		-- upvalues: IXPService (copy)
		local UserLayerLoadingStatus = IXPService:GetUserLayerLoadingStatus()

		while UserLayerLoadingStatus == Enum.IXPLoadingStatus.None or UserLayerLoadingStatus == Enum.IXPLoadingStatus.Pending do
			IXPService.OnUserLayerLoadingStatusChanged:Wait()
			UserLayerLoadingStatus = IXPService:GetUserLayerLoadingStatus()
		end

		return UserLayerLoadingStatus
	end,
	GetLayerData = function(_, p6) -- line: 73
		-- upvalues: IXPService (copy)
		local ok, result = pcall(function() -- line: 74
			-- upvalues: IXPService (copy), p6 (copy)
			return IXPService:GetUserLayerVariables(p6)
		end)

		return ok and result or nil
	end,
	GetBTIDLayerData = function(_, p8) -- line: 89
		-- upvalues: IXPService (copy)
		local ok, result = pcall(function() -- line: 90
			-- upvalues: IXPService (copy), p8 (copy)
			return IXPService:GetBrowserTrackerLayerVariables(p8)
		end)

		return ok and result or nil
	end,
	LogUserLayerExposure = function(_, p10) -- line: 102
		-- upvalues: IXPService (copy)
		pcall(function() -- line: 103
			-- upvalues: IXPService (copy), p10 (copy)
			IXPService:LogUserLayerExposure(p10)
		end)
	end,
	LogBrowserTrackerLayerExposure = function(_, p12) -- line: 113
		-- upvalues: IXPService (copy)
		pcall(function() -- line: 114
			-- upvalues: IXPService (copy), p12 (copy)
			IXPService:LogBrowserTrackerLayerExposure(p12)
		end)
	end,
	LogFlagLinkedUserLayerExposure = function(_, p14) -- line: 124
		-- upvalues: IXPService (copy)
		if game:GetEngineFeature("EnableLogFlagLinkedUserLayerExposure") then
			pcall(function() -- line: 126
				-- upvalues: IXPService (copy), p14 (copy)
				IXPService:LogFlagLinkedUserLayerExposure(p14)
			end)
		end
	end
}
