local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/BuilderIcons")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local CreationFlowState = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Enums/CreationFlowState")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")
local createEditSession = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Stores/createEditSession")
local StickerOverlayControls = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/StickerOverlay/StickerOverlayControls")
local StickerOverlayLayer = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/StickerOverlay/StickerOverlayLayer")

local eventNames = MomentsCommon.Analytics.EventNames

return {
	kind = "sticker",
	presentation = "Step",
	step = CreationFlowState.StickerOverlay,
	zIndex = 3,
	cta = {
		icon = BuilderIcons.Icon.SquareFaceEmoji,
		localizationKey = "Feature.Moments.Action.AddSticker",
		analyticsEvent = eventNames.EditingFlowStickerOverlayButtonPressed,
		commitAnalyticsEvent = eventNames.EditingFlowStickerOverlayDoneButtonPressed,
		cancelAnalyticsEvent = eventNames.EditingFlowStickerOverlayBackButtonPressed,
		order = 4
	},
	supportedCaptureTypes = { Enum.CaptureType.Video },
	createSession = function()
		return createEditSession()
	end,
	renderEditor = function(p2)
		return React.createElement(StickerOverlayControls, { controller = p2, layoutOrder = 2 })
	end,
	renderPreviewLayer = function(p2, p3)
		return React.createElement(StickerOverlayLayer, { controller = p2, ctx = p3, zIndex = 3 })
	end,
	toEdits = function(list)
		local v5 = list and list[1]

		if v5 == nil or v5.stickerURI == nil or v5.stickerURI == "" then
			return {}
		end

		return { stickerOverlays = list }
	end
}
