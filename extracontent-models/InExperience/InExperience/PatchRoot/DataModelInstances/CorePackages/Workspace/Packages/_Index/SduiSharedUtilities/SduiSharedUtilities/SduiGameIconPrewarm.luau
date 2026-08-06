local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local SduiSharedUtilitiesParent = SduiSharedUtilities.Parent
local DataHydration = require(SduiSharedUtilitiesParent.DataHydration)

require(SduiSharedUtilities.SduiIntegrationTypes)

local function collectUniverseIds(p1, t1: {[any]: any}) -- line: 16
	-- upvalues: collectUniverseIds (copy)
	if type(p1) ~= "table" then
		return
	end

	for v8, v9 in p1 do
		if v8 == "universe_id" and (type(v9) == "string" or type(v9) == "number") then
			t1[tostring(v9)] = true
		elseif type(v9) == "table" then
			collectUniverseIds(v9, t1)
		end
	end
end
local function prewarmIcons(t2: {[any]: any}, p2) -- line: 41
	-- upvalues: collectUniverseIds (copy), DataHydration (copy)
	local t3 = {}

	for _, v14 in t2 do
		collectUniverseIds(v14, t3)
	end

	local t4 = {}

	for v16 in t3 do
		table.insert(t4, v16)
	end

	if #t4 > 0 then
		DataHydration.Game.getGameIconStore(false).getAndFetchGameIcons(t4, p2)
	end
end

return {
	collectUniverseIds = collectUniverseIds,
	prewarmSmallIcons = function(t5: {[any]: any}) -- line: 56
		-- upvalues: prewarmIcons (copy), DataHydration (copy)
		prewarmIcons(t5, DataHydration.Game.GameIconSize.Small)
	end,
	prewarmLargeIcons = function(t6: {[any]: any}) -- line: 60
		-- upvalues: prewarmIcons (copy), DataHydration (copy)
		prewarmIcons(t6, DataHydration.Game.GameIconSize.Large)
	end
}
