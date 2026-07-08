local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiConditionKey = require(SduiCoreSystem.ConditionalProps.SduiConditionalPropTypes).SduiConditionKey

local function checkPresenceConditions(t1: {[any]: any}?, t2: {[any]: any}) -- line: 10
	-- upvalues: SduiConditionKey (copy)
	local t3 = {}

	if not t1 then
		return t3
	end

	assert(t1, "allConditionalProps must exist")

	for v7, v8 in t1 do
		local v9 = nil

		if v8.conditions then
			for v10, v11 in v8.conditions do
				if v10 == SduiConditionKey.friendInGame then
					v9 = true

					local v12 = t2[tostring(v11)]

					if v12 then
						for _ in v12 do
							v9 = false

							break
						end
					end

					if v9 then
						break
					end
				end
			end
		end

		t3[v7] = v9
	end

	return t3
end

return checkPresenceConditions
