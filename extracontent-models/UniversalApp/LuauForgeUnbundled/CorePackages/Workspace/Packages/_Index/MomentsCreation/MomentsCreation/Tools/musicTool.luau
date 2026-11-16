local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/BuilderIcons")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local CreationFlowState = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Enums/CreationFlowState")
local MomentType = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Enums/MomentType")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")
local createEditSession = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Stores/createEditSession")
local MusicOverlay = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/MusicOverlay")
local MusicPickerV2Container = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/MusicPickerV2Container")
local FFlagMomentsCreationMusicPickerV2 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsCreationMusicPickerV2")
local fFlagMomentsCreateAvatarPosts = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/SharedFlags").FFlagMomentsCreateAvatarPosts

local eventNames = MomentsCommon.Analytics.EventNames

return {
	kind = "music",
	presentation = "Overlay",
	step = CreationFlowState.Music,
	zIndex = 2,
	cta = {
		icon = BuilderIcons.Icon.MusicNote,
		localizationKey = "Feature.Moments.Action.AddMusic",
		analyticsEvent = eventNames.EditingFlowMusicButtonPressed,
		commitAnalyticsEvent = eventNames.EditingFlowMusicDoneButtonPressed,
		cancelAnalyticsEvent = eventNames.EditingFlowMusicBackButtonPressed,
		order = 2
	},
	supportedCaptureTypes = { Enum.CaptureType.Video, Enum.CaptureType.Screenshot },
	supportedMomentTypes = fFlagMomentsCreateAvatarPosts and { MomentType.Avatar } or nil,
	createSession = function()
		return createEditSession()
	end,
	renderEditor = function(p2)
		if FFlagMomentsCreationMusicPickerV2 then
			return React.createElement(MusicPickerV2Container, { controller = p2 })
		end

		return React.createElement(MusicOverlay, { controller = p2 })
	end,
	toEdits = function(p2)
		return { music = p2 }
	end
}
