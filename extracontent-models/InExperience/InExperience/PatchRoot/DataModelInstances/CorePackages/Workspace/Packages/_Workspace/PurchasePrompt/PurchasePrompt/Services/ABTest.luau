local Parent = script:FindFirstAncestor("PurchasePrompt").Parent
local IXPServiceWrapper = require(Parent.IxpServiceWrapper).IXPServiceWrapper

return {
	new = function() -- line: 15
		-- upvalues: IXPServiceWrapper (copy)
		local t1 = {}

		setmetatable(t1, {
			__tostring = function() -- line: 19
				return "Service(ABTest)"
			end
		})

		function t1.getLayerData(p1) -- line: 24
			-- upvalues: IXPServiceWrapper (copy)
			return IXPServiceWrapper:GetLayerData(p1)
		end
		function t1.logUserLayerExposure(p2) -- line: 28
			-- upvalues: IXPServiceWrapper (copy)
			IXPServiceWrapper:LogUserLayerExposure(p2)
		end

		return t1
	end
}
