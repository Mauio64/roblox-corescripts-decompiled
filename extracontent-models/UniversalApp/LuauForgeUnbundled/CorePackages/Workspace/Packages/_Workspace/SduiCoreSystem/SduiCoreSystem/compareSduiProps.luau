local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/tutils")

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")

local v5 = {
	extraLocalProps = true,
	localAnalyticsData = true,
	parentAnalyticsContext = true,
	conditionalProps = true,
	extraLocalPropSignals = true
}

return function(p2, p3)
	if p2 == p3 then
		return true
	end

	for k in v5 do
		local v6 = p2[k]
		local v7 = p3[k]

		if typeof(v6) == "table" and typeof(v7) == "table" then
			if not tutils.shallowEqual(v6, v7) then
				return false
			end
		elseif v6 and not v7 or v7 and not v6 then
			return false
		end
	end

	return tutils.shallowEqual(p2, p3, v5)
end
