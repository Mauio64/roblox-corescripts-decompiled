local RunService = game:GetService("RunService")
local IXPService = game:GetService("IXPService")

game:DefineFastFlag("IXPServiceWrapperWaitRefactor", false)

return {
	InitializeAsync = function(p1, p2, p3) -- line: 35
		-- upvalues: RunService (copy), IXPService (copy)
		local ok, result = pcall(function() -- line: 36
			-- upvalues: RunService (copy), IXPService (copy), p3 (copy), p2 (copy), p1 (copy)
			if RunService:IsStudio() then
				IXPService:ClearUserLayers()
			end

			IXPService:RegisterUserLayers(p3)
			IXPService:InitializeUserLayers(p2)

			if game:GetFastFlag("IXPServiceWrapperWaitRefactor") then
				return p1:WaitForInitialization()
			end

			local UserLayerLoadingStatus = IXPService:GetUserLayerLoadingStatus()

			while UserLayerLoadingStatus == Enum.IXPLoadingStatus.None or UserLayerLoadingStatus == Enum.IXPLoadingStatus.Pending do
				IXPService.OnUserLayerLoadingStatusChanged:Wait()
				UserLayerLoadingStatus = IXPService:GetUserLayerLoadingStatus()
			end

			return UserLayerLoadingStatus
		end)

		return ok, result
	end,
	WaitForInitialization = function(_) -- line: 64
		-- upvalues: IXPService (copy)
		local UserLayerLoadingStatus = IXPService:GetUserLayerLoadingStatus()

		while UserLayerLoadingStatus == Enum.IXPLoadingStatus.None or UserLayerLoadingStatus == Enum.IXPLoadingStatus.Pending do
			IXPService.OnUserLayerLoadingStatusChanged:Wait()
			UserLayerLoadingStatus = IXPService:GetUserLayerLoadingStatus()
		end

		return UserLayerLoadingStatus
	end,
	GetLayerData = function(_, p6) -- line: 82
		-- upvalues: IXPService (copy)
		local ok, result = pcall(function() -- line: 83
			-- upvalues: IXPService (copy), p6 (copy)
			return IXPService:GetUserLayerVariables(p6)
		end)

		return ok and result or nil
	end,
	LogUserLayerExposure = function(_, p8) -- line: 95
		-- upvalues: IXPService (copy)
		pcall(function() -- line: 96
			-- upvalues: IXPService (copy), p8 (copy)
			IXPService:LogUserLayerExposure(p8)
		end)
	end,
	LogBrowserTrackerLayerExposure = function(_, p10) -- line: 106
		-- upvalues: IXPService (copy)
		pcall(function() -- line: 107
			-- upvalues: IXPService (copy), p10 (copy)
			IXPService:LogBrowserTrackerLayerExposure(p10)
		end)
	end
}
