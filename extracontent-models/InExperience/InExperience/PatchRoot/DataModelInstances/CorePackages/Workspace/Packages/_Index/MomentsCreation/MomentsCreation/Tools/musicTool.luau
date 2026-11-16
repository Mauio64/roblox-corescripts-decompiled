local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local CreationFlowState = require(MomentsCreation.Enums.CreationFlowState)
local MomentType = require(MomentsCreation.Enums.MomentType)
require(MomentsCreation.Types.CreationFlowTypes)
local createEditSession = require(MomentsCreation.Stores.createEditSession)
local MusicOverlay = require(MomentsCreation.Components.MusicOverlay)
local MusicPickerV2Container = require(MomentsCreation.Components.MusicPickerV2Container)
local FFlagMomentsCreationMusicPickerV2 = require(MomentsCreation.Flags.FFlagMomentsCreationMusicPickerV2)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsCreateAvatarPosts = SharedFlags.FFlagMomentsCreateAvatarPosts

local EventNames = MomentsCommon.Analytics.EventNames
local MusicTool = {}
MusicTool.kind = "music"
MusicTool.presentation = "Overlay"
MusicTool.step = CreationFlowState.Music
MusicTool.zIndex = 2
MusicTool.cta = {
	icon = BuilderIcons.Icon.MusicNote,
	localizationKey = "Feature.Moments.Action.AddMusic",
	analyticsEvent = EventNames.EditingFlowMusicButtonPressed,
	commitAnalyticsEvent = EventNames.EditingFlowMusicDoneButtonPressed,
	cancelAnalyticsEvent = EventNames.EditingFlowMusicBackButtonPressed,
	order = 2
}

MusicTool.supportedCaptureTypes = { Enum.CaptureType.Video, Enum.CaptureType.Screenshot }
MusicTool.supportedMomentTypes = FFlagMomentsCreateAvatarPosts and { MomentType.Avatar } or nil
function MusicTool.createSession()
	return createEditSession()
end

function MusicTool.renderEditor(controller)
	if FFlagMomentsCreationMusicPickerV2 then
		return React.createElement(MusicPickerV2Container, { controller = controller })
	end

	return React.createElement(MusicOverlay, { controller = controller })
end

function MusicTool.toEdits(music)
	return { music = music }
end

return MusicTool
