local IXPService = game:GetService("IXPService")

return {
	getIxpLayerData = function(p2)
		local success, result = pcall(function()
			return IXPService:GetUserLayerVariables(p2)
		end)

		return success and result or nil
	end,
	logUserLayerExposure = function(p2)
		pcall(function()
			IXPService:LogUserLayerExposure(p2)
		end)
	end
}
