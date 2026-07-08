local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent
local tutils = require(SduiCoreSystemParent.tutils)

require(SduiCoreSystem.SduiBuilderTypes)

local t1 = {
	analyticsData = true,
	ancestorAnalyticsData = true
}

return function(p1, p2) -- line: 17
	-- upvalues: t1 (copy), tutils (copy)
	if p1 == p2 then
		return true
	end

	for v7 in t1 do
		local v8 = p1[v7]
		local v9 = p2[v7]

		if typeof(v8) ~= "table" or typeof(v9) ~= "table" then
			if (not v8 or v9) and (not v9 or v8) then
				continue
			end

			return false
		end

		if not tutils.shallowEqual(v8, v9) then
			return false
		end
	end

	return tutils.shallowEqual(p1, p2, t1)
end
