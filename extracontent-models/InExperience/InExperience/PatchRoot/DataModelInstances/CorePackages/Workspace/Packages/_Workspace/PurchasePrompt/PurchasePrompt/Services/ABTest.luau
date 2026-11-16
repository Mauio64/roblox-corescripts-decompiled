local parent = script:FindFirstAncestor("PurchasePrompt").Parent

local IxpServiceWrapper = require(parent.IxpServiceWrapper)
local IXPServiceWrapper = IxpServiceWrapper.IXPServiceWrapper

return {
	new = function()
		local v = {}

		setmetatable(v, {
			__tostring = function(): string
				return "Service(ABTest)"
			end
		})

		function v.getLayerData(p)
			return IXPServiceWrapper:GetLayerData(p)
		end

		function v.logUserLayerExposure(p)
			IXPServiceWrapper:LogUserLayerExposure(p)
		end

		return v
	end
}
