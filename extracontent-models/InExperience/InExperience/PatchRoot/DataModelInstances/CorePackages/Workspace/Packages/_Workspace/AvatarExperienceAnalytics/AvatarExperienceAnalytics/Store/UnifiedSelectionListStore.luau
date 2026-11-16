local UnifiedEventLogConstants = require(script.Parent.Parent.UnifiedEventLogConstants)

local selectionList = {}
local UnifiedSelectionListStore = {}

function UnifiedSelectionListStore.addToSelectionList(p)
	table.insert(selectionList, p)
end

function UnifiedSelectionListStore.removeFromSelectionList(p)
	local v = UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemId"
	local v2 = UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemType"

	for k, v3 in selectionList do
		if v3[v] == p[v] and v3[v2] == p[v2] then
			table.remove(selectionList, k)
			break
		end
	end
end

function UnifiedSelectionListStore.getSelectionList()
	return selectionList
end

function UnifiedSelectionListStore.clearSelectionList()
	selectionList = {}
end

return UnifiedSelectionListStore
