local AvatarExperienceAnalytics = script:FindFirstAncestor("AvatarExperienceAnalytics")
local AvatarExperienceAnalyticsParent = AvatarExperienceAnalytics.Parent
local Cryo = require(AvatarExperienceAnalyticsParent.Cryo)
local UnifiedEventLogConstants = require(script.Parent.UnifiedEventLogConstants)
local UnifiedEventLoggingUtils = require(AvatarExperienceAnalytics.Utils.UnifiedEventLoggingUtils)
local sendUnifiedEventLog = require(script.Parent.sendUnifiedEventLog)
local UnifiedSelectionListStore = require(script.Parent.Store.UnifiedSelectionListStore)

return function(p1, p2) -- line: 10
	-- upvalues: UnifiedSelectionListStore (copy), UnifiedEventLogConstants (copy), UnifiedEventLoggingUtils (copy), Cryo (copy), sendUnifiedEventLog (copy)
	local v10 = UnifiedSelectionListStore.getSelectionList()
	local v11 = UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemId"
	local v12 = UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemType"

	for _, v14 in p1 do
		local v15 = nil

		for _, v17 in v10 do
			if tostring(v17[v11]) == tostring(v14.itemId) and tostring(v17[v12]) == tostring(v14.itemType) then
				v15 = v17

				break
			end
		end

		local v18 = UnifiedEventLoggingUtils.getFieldsToSendFromInstanceAttributes(v15)
		local v19 = Cryo.Dictionary.join(v18, v14)
		local v20 = Cryo.Dictionary.join(v19, {
			surface = p2
		})

		sendUnifiedEventLog(v20)
	end
end
