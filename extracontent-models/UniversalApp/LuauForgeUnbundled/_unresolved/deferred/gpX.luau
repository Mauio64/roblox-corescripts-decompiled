local HttpService = game:GetService("HttpService")

local module = require("@luauforge/deferred/gpw")
local module2 = require("@luauforge/deferred/gpv")
local module3 = require("@luauforge/deferred/gpF")
local sendUnifiedEventLog = module.sendUnifiedEventLog
local unifiedEventLogEnums = module.UnifiedEventLogEnums
local unifiedLoggingElementNameEnums = module.Enums.UnifiedLoggingElementNameEnums
local unifiedLoggingSurface = module2.Enums.UnifiedLoggingSurface

local PHOTOBOOTH_MOMENTS = unifiedLoggingElementNameEnums.PHOTOBOOTH_MOMENTS

local frozen = table.freeze({ Open = "open", Close = "close" })

local v5 = {
	[module3.PhotoboothMoments.MyAvatars] = PHOTOBOOTH_MOMENTS.MY_AVATARS_MENU_BUTTON,
	[module3.PhotoboothMoments.Emotes] = PHOTOBOOTH_MOMENTS.EMOTES_MENU_BUTTON,
	[module3.PhotoboothMoments.Backgrounds] = PHOTOBOOTH_MOMENTS.BACKGROUNDS_MENU_BUTTON
}

local function nonEmpty(p2)
	if p2 == "" then
		return nil
	end

	return p2
end

local function sendClick(p2, items)
	local v7 = {
		action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
		surface = unifiedLoggingSurface.PHOTOBOOTH_MOMENTS,
		elementName = p2,
		elementMetadata = 0
	}

	local v8 = if items and next(items) ~= nil then HttpService:JSONEncode(items) else nil
	v7.elementMetadata = v8
	sendUnifiedEventLog(v7)
end

return {
	MenuState = frozen,
	sendMenuItemClick = function(p2, p3, previous_menu)
		local v6 = v5[p2]

		if v6 == nil then
			return
		end

		if previous_menu == "" then
			previous_menu = nil
		end

		sendClick(v6, { menu_state = p3, previous_menu = previous_menu })
	end,
	sendContinueClick = function(data)
		local CONTINUE_BUTTON = PHOTOBOOTH_MOMENTS.CONTINUE_BUTTON
		local outfitId = data.outfitId

		if outfitId == "" then
			outfitId = nil
		end

		local emoteAssetId = data.emoteAssetId

		if emoteAssetId == "" then
			emoteAssetId = nil
		end

		local backgroundAssetId = data.backgroundAssetId

		if backgroundAssetId == "" then
			backgroundAssetId = nil
		end

		sendClick(CONTINUE_BUTTON, {
			outfit_id = outfitId,
			emote_asset_id = emoteAssetId,
			background_asset_id = backgroundAssetId,
			is_r6 = data.isEmotesDisabled
		})
	end,
	sendBackClick = function(open_menu)
		local BACK_BUTTON = PHOTOBOOTH_MOMENTS.BACK_BUTTON

		if open_menu == "" then
			open_menu = nil
		end

		sendClick(BACK_BUTTON, { open_menu = open_menu })
	end,
	sendPanelDismissClick = function(open_menu)
		local PANEL_DISMISS_AREA = PHOTOBOOTH_MOMENTS.PANEL_DISMISS_AREA

		if open_menu == "" then
			open_menu = nil
		end

		sendClick(PANEL_DISMISS_AREA, { open_menu = open_menu })
	end
}
