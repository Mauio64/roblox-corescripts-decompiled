local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent
local tutils = require(SduiCoreSystemParent.tutils)

require(SduiCoreSystem.SduiBuilderTypes)

local FFlagSduiPoolBackedFeed = require(SduiCoreSystemParent.SharedFlags).FFlagSduiPoolBackedFeed
local t1 = {
	extraLocalProps = true,
	localAnalyticsData = true,
	parentAnalyticsContext = true,
	conditionalProps = true
}

if FFlagSduiPoolBackedFeed then
	t1.extraLocalPropSignals = true
end

return function(p1, p2) -- line: 25
	-- upvalues: t1 (copy), tutils (copy)
	if p1 == p2 then
		return true
	end

	for v8 in t1 do
		local v9 = p1[v8]
		local v10 = p2[v8]

		if typeof(v9) ~= "table" or typeof(v10) ~= "table" then
			if (not v9 or v10) and (not v10 or v9) then
				continue
			end

			return false
		end

		if not tutils.shallowEqual(v9, v10) then
			return false
		end
	end

	return tutils.shallowEqual(p1, p2, t1)
end
