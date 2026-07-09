local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local AnalyticsService = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).AnalyticsService
local ImpressionEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).Enums.ImpressionEnums
local Modules = CoreGui.RobloxGui.Modules
local FFlagAXImproveSlotBasedEditorPerformance = require(Modules.AvatarExperience.Flags.FFlagAXImproveSlotBasedEditorPerformance)
local t1 = {}
local u8 = nil

local function getSlotBasedEditorAnalyticsInner(p1) -- line: 15
	-- upvalues: ImpressionEnums (copy), FFlagAXImproveSlotBasedEditorPerformance (copy), u8 (ref)
	local t3 = {
		slotClick = function(p2) -- line: 18
			-- upvalues: ImpressionEnums (copy), p1 (copy)
			local t2 = {
				actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
				subcategory = p2.editorSubcategory,
				surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY,
				event_sender_api = ImpressionEnums.MarketplaceEventSenderAPI.SEND_ROBLOX_TELEMETRY_EVENT
			}

			p1.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", t2)
		end
	}

	if FFlagAXImproveSlotBasedEditorPerformance then
		u8 = t3
	end

	return t3
end

function t1.get(_) -- line: 38
	-- upvalues: FFlagAXImproveSlotBasedEditorPerformance (copy), u8 (ref), AnalyticsService (copy), ImpressionEnums (copy)
	if FFlagAXImproveSlotBasedEditorPerformance and u8 then
		return u8
	end

	local v13 = AnalyticsService
	local t5 = {
		slotClick = function(p4) -- line: 18
			-- upvalues: ImpressionEnums (copy), v13 (copy)
			local t4 = {
				actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
				subcategory = p4.editorSubcategory,
				surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY,
				event_sender_api = ImpressionEnums.MarketplaceEventSenderAPI.SEND_ROBLOX_TELEMETRY_EVENT
			}

			v13.EventStream:sendTelemetryEvent("SlotBasedEditor", "marketplaceOrganicFELog", t4)
		end
	}

	if FFlagAXImproveSlotBasedEditorPerformance then
		u8 = t5
	end

	return t5
end

return t1
