local UnifiedEventLogConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/UnifiedEventLogConstants")

local selectionList = {}

return {
	addToSelectionList = function(p2)
		table.insert(selectionList, p2)
	end,
	removeFromSelectionList = function(p2)
		local v5 = UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemId"
		local v6 = UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemType"

		for k, v7 in selectionList do
			if v7[v5] == p2[v5] and v7[v6] == p2[v6] then
				table.remove(selectionList, k)
				break
			end
		end
	end,
	getSelectionList = function()
		return selectionList
	end,
	clearSelectionList = function()
		selectionList = {}
	end
}
