local IXPService = game:GetService("IXPService")
local IxpHelper = {}

function IxpHelper.getIxpLayerData(p: string)
	local success, result = pcall(function()
		return IXPService:GetUserLayerVariables(p)
	end)

	return success and result or nil
end

function IxpHelper.logUserLayerExposure(p: string)
	pcall(function()
		IXPService:LogUserLayerExposure(p)
	end)
end

return IxpHelper
