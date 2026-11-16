local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")

local SduiConditionalPropTypes = require(SduiCoreSystem.ConditionalProps.SduiConditionalPropTypes)
local SduiConditionKey = SduiConditionalPropTypes.SduiConditionKey

local function checkPresenceConditions(items, p)
	local result = {}

	if not items then
		return result
	end

	assert(items, "allConditionalProps must exist")

	for k, item in items do
		local flag = nil

		if item.conditions then
			for k2, condition in item.conditions do
				if k2 ~= SduiConditionKey.friendInGame then
					continue
				end

				flag = true

				local v = p[tostring(condition)]

				if v then
					for _ in v do
						flag = false
						break
					end
				end

				if flag then
					break
				end
			end
		end

		result[k] = flag
	end

	return result
end

return checkPresenceConditions
