local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local BuilderIcons = require(MomentsCreationParent.BuilderIcons)
local MomentsCommon = require(MomentsCreationParent.MomentsCommon)
local React = require(MomentsCreationParent.React)
local CreationFlowState = require(MomentsCreation.Enums.CreationFlowState)

require(MomentsCreation.Types.CreationFlowTypes)

local createEditSession = require(MomentsCreation.Stores.createEditSession)
local StickerOverlayControls = require(MomentsCreation.Components.StickerOverlay.StickerOverlayControls)
local StickerOverlayLayer = require(MomentsCreation.Components.StickerOverlay.StickerOverlayLayer)
local EventNames = MomentsCommon.Analytics.EventNames

return {
	kind = "sticker",
	presentation = "Step",
	zIndex = 3,
	step = CreationFlowState.StickerOverlay,
	cta = {
		localizationKey = "Feature.Moments.Action.AddSticker",
		order = 4,
		icon = BuilderIcons.Icon.SquareFaceEmoji,
		analyticsEvent = EventNames.EditingFlowStickerOverlayButtonPressed,
		commitAnalyticsEvent = EventNames.EditingFlowStickerOverlayDoneButtonPressed,
		cancelAnalyticsEvent = EventNames.EditingFlowStickerOverlayBackButtonPressed
	},
	supportedCaptureTypes = { Enum.CaptureType.Video },
	createSession = function() -- line: 40
		-- upvalues: createEditSession (copy)
		return createEditSession()
	end,
	renderEditor = function(p1) -- line: 43
		-- upvalues: React (copy), StickerOverlayControls (copy)
		return React.createElement(StickerOverlayControls, {
			layoutOrder = 2,
			controller = p1
		})
	end,
	renderPreviewLayer = function(p2, p3) -- line: 48
		-- upvalues: React (copy), StickerOverlayLayer (copy)
		return React.createElement(StickerOverlayLayer, {
			zIndex = 3,
			controller = p2,
			ctx = p3
		})
	end,
	toEdits = function(p4) -- line: 51
		local v15 = p4 and p4[1]

		if v15 == nil or (v15.stickerURI == nil or v15.stickerURI == "") then
			return {}
		end

		return {
			stickerOverlays = p4
		}
	end
}
