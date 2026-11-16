local analyticsService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").AnalyticsService
local impressionEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").Enums.ImpressionEnums

local module = require("@luauforge/bundled/gfa")

local v6 = nil

local function getSlotBasedEditorAnalyticsInner(p2)
	local slotBasedEditorAnalyticsInner = {
		slotClick = function(p3)
			local v7 = {
				actionType = impressionEnums.ActionType.UI_BUTTON_CLICK,
				subcategory = p3.editorSubcategory,
				surface = impressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
			}

			v7.event_sender_api = impressionEnums.MarketplaceEventSenderAPI.SEND_ROBLOX_TELEMETRY_EVENT
			p2.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v7)
		end
	}

	if module then
		v6 = slotBasedEditorAnalyticsInner
	end

	return slotBasedEditorAnalyticsInner
end

return {
	get = function(p2)
		if module and v6 then
			return v6
		end

		local v7 = analyticsService
		local v8 = {
			slotClick = function(p3)
				local v9 = {
					actionType = impressionEnums.ActionType.UI_BUTTON_CLICK,
					subcategory = p3.editorSubcategory,
					surface = impressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
				}

				v9.event_sender_api = impressionEnums.MarketplaceEventSenderAPI.SEND_ROBLOX_TELEMETRY_EVENT
				v7.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", v9)
			end
		}

		if module then
			v6 = v8
		end

		return v8
	end
}
