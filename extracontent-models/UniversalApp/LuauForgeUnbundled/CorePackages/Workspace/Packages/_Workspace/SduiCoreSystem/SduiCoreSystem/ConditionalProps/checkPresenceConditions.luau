local sduiConditionKey = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ConditionalProps/SduiConditionalPropTypes").SduiConditionKey

local function checkPresenceConditions(items, p2)
	local result = {}

	if not items then
		return result
	end

	assert(items, "allConditionalProps must exist")

	for k, item in items do
		local flag = nil

		if item.conditions then
			for k2, condition in item.conditions do
				if k2 ~= sduiConditionKey.friendInGame then
					continue
				end

				flag = true

				local v6 = p2[tostring(condition)]

				if v6 then
					for k3 in v6 do
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
