local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
local tutils = require(parent.tutils)

require(SduiCoreSystem.SduiBuilderTypes)

local v = {
	extraLocalProps = true,
	localAnalyticsData = true,
	parentAnalyticsContext = true,
	conditionalProps = true,
	extraLocalPropSignals = true
}

return function(p, p2)
	if p == p2 then
		return true
	end

	for k in v do
		local v2 = p[k]
		local v3 = p2[k]

		if typeof(v2) == "table" and typeof(v3) == "table" then
			if not tutils.shallowEqual(v2, v3) then
				return false
			end
		elseif v2 and not v3 or v3 and not v2 then
			return false
		end
	end

	return tutils.shallowEqual(p, p2, v)
end
