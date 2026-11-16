local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local CreationFlowState = require(MomentsCreation.Enums.CreationFlowState)
require(MomentsCreation.Types.CreationFlowTypes)
local createEditSession = require(MomentsCreation.Stores.createEditSession)
local StickerOverlayControls = require(MomentsCreation.Components.StickerOverlay.StickerOverlayControls)
local StickerOverlayLayer = require(MomentsCreation.Components.StickerOverlay.StickerOverlayLayer)

local EventNames = MomentsCommon.Analytics.EventNames
local StickerTool = {}
StickerTool.kind = "sticker"
StickerTool.presentation = "Step"
StickerTool.step = CreationFlowState.StickerOverlay
StickerTool.zIndex = 3
StickerTool.cta = {
	icon = BuilderIcons.Icon.SquareFaceEmoji,
	localizationKey = "Feature.Moments.Action.AddSticker",
	analyticsEvent = EventNames.EditingFlowStickerOverlayButtonPressed,
	commitAnalyticsEvent = EventNames.EditingFlowStickerOverlayDoneButtonPressed,
	cancelAnalyticsEvent = EventNames.EditingFlowStickerOverlayBackButtonPressed,
	order = 4
}

StickerTool.supportedCaptureTypes = { Enum.CaptureType.Video }
function StickerTool.createSession()
	return createEditSession()
end

function StickerTool.renderEditor(controller)
	return React.createElement(StickerOverlayControls, { controller = controller, layoutOrder = 2 })
end

function StickerTool.renderPreviewLayer(controller, ctx)
	return React.createElement(StickerOverlayLayer, {
		controller = controller,
		ctx = ctx,
		zIndex = 3
	})
end

function StickerTool.toEdits(stickerOverlays)
	local v = stickerOverlays and stickerOverlays[1]

	if v == nil or v.stickerURI == nil or v.stickerURI == "" then
		return {}
	end

	return { stickerOverlays = stickerOverlays }
end

return StickerTool
