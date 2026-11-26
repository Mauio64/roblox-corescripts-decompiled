local ixpServiceWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IxpServiceWrapper").IXPServiceWrapper

return {
	new = function()
		local v5 = {}

		setmetatable(v5, {
			__tostring = function(): string
				return "Service(ABTest)"
			end
		})

		function v5.getLayerData(p2)
			return ixpServiceWrapper:GetLayerData(p2)
		end

		function v5.logUserLayerExposure(p2)
			ixpServiceWrapper:LogUserLayerExposure(p2)
		end

		return v5
	end
}
