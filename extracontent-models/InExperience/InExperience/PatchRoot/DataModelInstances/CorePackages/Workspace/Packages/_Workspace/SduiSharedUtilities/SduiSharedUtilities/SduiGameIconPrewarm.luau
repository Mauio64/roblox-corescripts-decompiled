local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local parent = SduiSharedUtilities.Parent
local DataHydration = require(parent.DataHydration)
require(SduiSharedUtilities.SduiIntegrationTypes)
local function collectUniverseIds(item, p)
	if type(item) ~= "table" then
		return
	end

	for k, item2 in item do
		if k == "universe_id" and (type(item2) == "string" or type(item2) == "number") then
			p[tostring(item2)] = true
		elseif type(item2) == "table" then
			collectUniverseIds(item2, p)
		end
	end
end

local function prewarmIcons(items, p)
	local v = {}

	for _, item in items do
		collectUniverseIds(item, v)
	end

	local v2 = {}

	for k in v do
		table.insert(v2, k)
	end

	if #v2 > 0 then
		DataHydration.Game.getGameIconStore(false).getAndFetchGameIcons(v2, p)
	end
end

local SduiGameIconPrewarm = {}
SduiGameIconPrewarm.collectUniverseIds = collectUniverseIds

function SduiGameIconPrewarm.prewarmSmallIcons(p)
	prewarmIcons(p, DataHydration.Game.GameIconSize.Small)
end

function SduiGameIconPrewarm.prewarmLargeIcons(p)
	prewarmIcons(p, DataHydration.Game.GameIconSize.Large)
end

return SduiGameIconPrewarm
