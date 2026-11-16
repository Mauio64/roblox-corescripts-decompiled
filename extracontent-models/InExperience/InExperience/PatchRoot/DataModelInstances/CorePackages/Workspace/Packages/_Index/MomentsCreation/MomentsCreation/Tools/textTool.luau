local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local CreationFlowState = require(MomentsCreation.Enums.CreationFlowState)
local MomentType = require(MomentsCreation.Enums.MomentType)
require(MomentsCreation.Types.CreationFlowTypes)
local createEditSession = require(MomentsCreation.Stores.createEditSession)
local TextOverlayControls = require(MomentsCreation.Components.TextOverlay.TextOverlayControls)
local TextOverlayLayer = require(MomentsCreation.Components.TextOverlay.TextOverlayLayer)
local FFlagMomentsTextOverlayOnPhotos = require(MomentsCreation.Flags.FFlagMomentsTextOverlayOnPhotos)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsCreateAvatarPosts = SharedFlags.FFlagMomentsCreateAvatarPosts

local EventNames = MomentsCommon.Analytics.EventNames

local TextTool = {
	kind = "text",
	presentation = "Step",
	step = CreationFlowState.TextOverlay,
	zIndex = 3,
	cta = {
		icon = BuilderIcons.Icon.TextUppercaseALowercaseA,
		localizationKey = "Feature.Moments.Action.AddText",
		analyticsEvent = EventNames.EditingFlowTextOverlayButtonPressed,
		commitAnalyticsEvent = EventNames.EditingFlowTextOverlayDoneButtonPressed,
		cancelAnalyticsEvent = EventNames.EditingFlowTextOverlayBackButtonPressed,
		order = 3
	},
	supportedCaptureTypes = 0,
	supportedMomentTypes = 0,
	createSession = 0,
	renderEditor = 0,
	renderPreviewLayer = 0,
	toEdits = 0
}
local supportedCaptureTypes

if FFlagMomentsTextOverlayOnPhotos then
	supportedCaptureTypes = { Enum.CaptureType.Video, Enum.CaptureType.Screenshot }
else
	supportedCaptureTypes = { Enum.CaptureType.Video }
end

TextTool.supportedCaptureTypes = supportedCaptureTypes

TextTool.supportedMomentTypes = FFlagMomentsCreateAvatarPosts and { MomentType.Avatar } or nil
function TextTool.createSession()
	return createEditSession()
end

function TextTool.renderEditor(controller)
	return React.createElement(TextOverlayControls, { controller = controller, layoutOrder = 2 })
end

function TextTool.renderPreviewLayer(controller, ctx)
	return React.createElement(TextOverlayLayer, { controller = controller, ctx = ctx, zIndex = 3 })
end

function TextTool.toEdits(textOverlays)
	local v = textOverlays and textOverlays[1]

	if v == nil or v.text == "" then
		return {}
	end

	return { textOverlays = textOverlays }
end

return TextTool
