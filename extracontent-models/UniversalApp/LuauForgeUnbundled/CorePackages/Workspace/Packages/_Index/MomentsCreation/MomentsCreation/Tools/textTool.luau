local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/BuilderIcons")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local CreationFlowState = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Enums/CreationFlowState")
local MomentType = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Enums/MomentType")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")
local createEditSession = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Stores/createEditSession")
local TextOverlayControls = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/TextOverlay/TextOverlayControls")
local TextOverlayLayer = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/TextOverlay/TextOverlayLayer")
local FFlagMomentsTextOverlayOnPhotos = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsTextOverlayOnPhotos")
local fFlagMomentsCreateAvatarPosts = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/SharedFlags").FFlagMomentsCreateAvatarPosts

local eventNames = MomentsCommon.Analytics.EventNames

local v5 = {
	kind = "text",
	presentation = "Step",
	step = CreationFlowState.TextOverlay,
	zIndex = 3,
	cta = {
		icon = BuilderIcons.Icon.TextUppercaseALowercaseA,
		localizationKey = "Feature.Moments.Action.AddText",
		analyticsEvent = eventNames.EditingFlowTextOverlayButtonPressed,
		commitAnalyticsEvent = eventNames.EditingFlowTextOverlayDoneButtonPressed,
		cancelAnalyticsEvent = eventNames.EditingFlowTextOverlayBackButtonPressed,
		order = 3
	},
	supportedCaptureTypes = 0,
	supportedMomentTypes = 0,
	createSession = 0,
	renderEditor = 0,
	renderPreviewLayer = 0,
	toEdits = 0
}

local v6 = if FFlagMomentsTextOverlayOnPhotos then { Enum.CaptureType.Video, Enum.CaptureType.Screenshot } else { Enum.CaptureType.Video }
v5.supportedCaptureTypes = v6

v5.supportedMomentTypes = fFlagMomentsCreateAvatarPosts and { MomentType.Avatar } or nil
function v5.createSession()
	return createEditSession()
end

function v5.renderEditor(p2)
	return React.createElement(TextOverlayControls, { controller = p2, layoutOrder = 2 })
end

function v5.renderPreviewLayer(p2, p3)
	return React.createElement(TextOverlayLayer, { controller = p2, ctx = p3, zIndex = 3 })
end

function v5.toEdits(list)
	local v7 = list and list[1]

	if v7 == nil or v7.text == "" then
		return {}
	end

	return { textOverlays = list }
end

return v5
