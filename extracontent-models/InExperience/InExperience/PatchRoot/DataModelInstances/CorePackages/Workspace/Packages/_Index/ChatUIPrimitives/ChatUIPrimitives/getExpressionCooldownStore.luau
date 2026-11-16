local createExpressionCooldownStore = require(script.Parent.createExpressionCooldownStore)
local expressionCooldownStore = require(script.Parent.expressionCooldownStore)

local v = {}
local GetExpressionCooldownStore = {}

function GetExpressionCooldownStore.getExpressionCooldownStore(p: string?)
	if p == nil then
		return expressionCooldownStore
	end

	local v2 = v[p]

	if v2 == nil then
		v2 = createExpressionCooldownStore()
		v[p] = v2
	end

	return v2
end

function GetExpressionCooldownStore._resetForTesting()
	expressionCooldownStore._resetForTesting()
	table.clear(v)
end

return GetExpressionCooldownStore
