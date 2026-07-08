local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local makeActionCreator = require(PurchasePromptParent.Rodux).makeActionCreator

require(PurchasePrompt.Models.RobuxUpsell)

local v4 = makeActionCreator(script.Name, function(t1: {[any]: any}, n1: number, s1: string) -- line: 10
	return {
		products = t1,
		selection = n1,
		virtualItemBadgeType = s1
	}
end)
local t3 = {
	name = v4.name,
	__call = function(_, t2: {[any]: any}, n2: number, s2: string) -- line: 23
		-- upvalues: v4 (copy)
		return v4(t2, n2, s2)
	end
}

setmetatable(t3, t3)

return t3
