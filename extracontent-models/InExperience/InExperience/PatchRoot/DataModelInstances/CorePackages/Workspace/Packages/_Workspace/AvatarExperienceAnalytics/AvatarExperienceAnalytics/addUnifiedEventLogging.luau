local CollectionService = game:GetService("CollectionService")
local parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent

local UnifiedEventLogConstants = require(script.Parent.UnifiedEventLogConstants)
require(script.Parent.Generated.UnifiedEventTypes)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents
local FFlagAXSkipTapDetection = AvatarExperienceFlags.FFlagAXSkipTapDetection
local FFlagAXUnifiedImpressionsOnThumbnail = AvatarExperienceFlags.FFlagAXUnifiedImpressionsOnThumbnail

local v = { table = true, string = true, number = true, boolean = true }

return function(p, items, data)
	if not p.current then
		return
	end

	CollectionService:AddTag(p.current, UnifiedEventLogConstants.TAG_NAME)

	if data and data.hasDeferredActions then
		p.current:SetAttribute(UnifiedEventLogConstants.HAS_DEFERRED_ACTION, true)
	end

	if FFlagAXMISEnableMultiShoppingUnifiedEvents and data and data.isSelected ~= nil then
		p.current:SetAttribute(UnifiedEventLogConstants.IS_SELECTED, data.isSelected)
	end

	if data and data.sessionTagName then
		p.current:SetAttribute(UnifiedEventLogConstants.SESSION_TAG_NAME, data.sessionTagName)
	end

	if FFlagAXUnifiedImpressionsOnThumbnail and data and data.skipImpressionDetection then
		p.current:SetAttribute(UnifiedEventLogConstants.SKIP_IMPRESSION_DETECTION, true)
	end

	if FFlagAXSkipTapDetection then
		p.current:SetAttribute(
			UnifiedEventLogConstants.SKIP_TAP_DETECTION,
			data and data.skipTapDetection and true or nil
		)
	end

	if items then
		for k, _ in items do
			if not v[type(items[k])] then
				continue
			end

			local v2

			if type(items[k]) == "table" then
				v2 = table.concat(items[k], ",")
			else
				v2 = items[k]
			end

			p.current:SetAttribute(UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. k, v2)
		end
	end
end
