local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/DataHydration")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiIntegrationTypes")
local function collectUniverseIds(item, p2)
	if type(item) ~= "table" then
		return
	end

	for k, item2 in item do
		if k == "universe_id" and (type(item2) == "string" or type(item2) == "number") then
			p2[tostring(item2)] = true
		elseif type(item2) == "table" then
			collectUniverseIds(item2, p2)
		end
	end
end

local function prewarmIcons(items, p2)
	local v5 = {}

	for k, item in items do
		collectUniverseIds(item, v5)
	end

	local v6 = {}

	for k in v5 do
		table.insert(v6, k)
	end

	if #v6 > 0 then
		DataHydration.Game.getGameIconStore(false).getAndFetchGameIcons(v6, p2)
	end
end

return {
	collectUniverseIds = collectUniverseIds,
	prewarmSmallIcons = function(p2)
		prewarmIcons(p2, DataHydration.Game.GameIconSize.Small)
	end,
	prewarmLargeIcons = function(p2)
		prewarmIcons(p2, DataHydration.Game.GameIconSize.Large)
	end
}
