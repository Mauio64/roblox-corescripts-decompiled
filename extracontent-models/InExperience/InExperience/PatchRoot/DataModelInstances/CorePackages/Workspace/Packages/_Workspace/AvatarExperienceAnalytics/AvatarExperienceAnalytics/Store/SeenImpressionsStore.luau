local v = {}

local function getOrCreateCategory(p: string) -- 1 equivalent call inferred from this helper
	if not v[p] then
		v[p] = {}
	end

	return v[p]
end

local SeenImpressionsStore = {}
SeenImpressionsStore.Category = {
	WidgetItems = "WidgetItems",
	UnifiedImpressions = "UnifiedImpressions"
}

function SeenImpressionsStore.hasSeen(p: string, p2: string): boolean
	local v2 = v[p]
	return v2 ~= nil and v2[p2] == true
end

function SeenImpressionsStore.markSeen(p: string, p2: string)
	local category = getOrCreateCategory(p) -- inferred equivalent call
	category[p2] = true
end

function SeenImpressionsStore.clearCategory(p: string)
	v[p] = nil
end

function SeenImpressionsStore.clear()
	table.clear(v)
end

return SeenImpressionsStore
