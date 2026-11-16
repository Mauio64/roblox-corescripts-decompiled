local CollectionService = game:GetService("CollectionService")

local module = require("@luauforge/deferred/gQM")
local module2 = require("@luauforge/deferred/gRk")
local module3 = require("@luauforge/deferred/gQK")

local unifiedEventLogConstants = module2.UnifiedEventLogConstants
local unifiedEventLogEnums = module2.UnifiedEventLogEnums
local fFlagAXSkipTapDetection = module3.FFlagAXSkipTapDetection

local function useTaggedImpressionTarget(p2, p3, callback)
	local ref = module.useRef(nil)

	return module.useCallback(function(current)
		local current2 = ref.current

		if current2 then
			current2:SetAttribute(unifiedEventLogConstants.ATTRIBUTE_PREFIX .. "action", nil)
			current2:SetAttribute(unifiedEventLogConstants.SKIP_TAP_DETECTION, nil)
			callback(current2, false)
			CollectionService:RemoveTag(current2, unifiedEventLogConstants.TAG_NAME)
			ref.current = nil
		end

		if not (current and p2) then
			return
		end

		CollectionService:AddTag(current, unifiedEventLogConstants.TAG_NAME)
		current:SetAttribute(
			unifiedEventLogConstants.SESSION_TAG_NAME,
			unifiedEventLogConstants.L2_SESSION_TAG_NAME
		)
		current:SetAttribute(
			unifiedEventLogConstants.ATTRIBUTE_PREFIX .. "action",
			unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK
		)

		current:SetAttribute(
			unifiedEventLogConstants.SKIP_TAP_DETECTION,
			fFlagAXSkipTapDetection and p3 and true or nil
		)

		callback(current, true)
		ref.current = current
	end, { p2, callback, p3 })
end

return useTaggedImpressionTarget
