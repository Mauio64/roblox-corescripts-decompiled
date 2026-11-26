local CollectionService = game:GetService("CollectionService")

local UnifiedEventLogConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/UnifiedEventLogConstants")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Generated/UnifiedEventTypes")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceFlags")
local fFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents
local fFlagAXSkipTapDetection = AvatarExperienceFlags.FFlagAXSkipTapDetection
local fFlagAXUnifiedImpressionsOnThumbnail = AvatarExperienceFlags.FFlagAXUnifiedImpressionsOnThumbnail

local v5 = { table = true, string = true, number = true, boolean = true }

return function(p2, items, data)
	if not p2.current then
		return
	end

	CollectionService:AddTag(p2.current, UnifiedEventLogConstants.TAG_NAME)

	if data and data.hasDeferredActions then
		p2.current:SetAttribute(UnifiedEventLogConstants.HAS_DEFERRED_ACTION, true)
	end

	if fFlagAXMISEnableMultiShoppingUnifiedEvents and data and data.isSelected ~= nil then
		p2.current:SetAttribute(UnifiedEventLogConstants.IS_SELECTED, data.isSelected)
	end

	if data and data.sessionTagName then
		p2.current:SetAttribute(UnifiedEventLogConstants.SESSION_TAG_NAME, data.sessionTagName)
	end

	if fFlagAXUnifiedImpressionsOnThumbnail and data and data.skipImpressionDetection then
		p2.current:SetAttribute(UnifiedEventLogConstants.SKIP_IMPRESSION_DETECTION, true)
	end

	if fFlagAXSkipTapDetection then
		p2.current:SetAttribute(UnifiedEventLogConstants.SKIP_TAP_DETECTION, data and data.skipTapDetection and true or nil)
	end

	if items then
		for k, item in items do
			if not v5[type(items[k])] then
				continue
			end

			local v6 = if type(items[k]) == "table" then table.concat(items[k], ",") else items[k]

			p2.current:SetAttribute(UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. k, v6)
		end
	end
end
