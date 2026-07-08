local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local BuilderIcons = require(MomentsCreationParent.BuilderIcons)
local MomentsCommon = require(MomentsCreationParent.MomentsCommon)
local React = require(MomentsCreationParent.React)
local CreationFlowState = require(MomentsCreation.Enums.CreationFlowState)

require(MomentsCreation.Types.CreationFlowTypes)

local createEditSession = require(MomentsCreation.Stores.createEditSession)
local MusicOverlay = require(MomentsCreation.Components.MusicOverlay)
local EventNames = MomentsCommon.Analytics.EventNames

return {
	kind = "music",
	presentation = "Overlay",
	zIndex = 2,
	step = CreationFlowState.Music,
	cta = {
		localizationKey = "Feature.Moments.Action.AddMusic",
		order = 2,
		icon = BuilderIcons.Icon.MusicNote,
		analyticsEvent = EventNames.EditingFlowMusicButtonPressed,
		commitAnalyticsEvent = EventNames.EditingFlowMusicDoneButtonPressed,
		cancelAnalyticsEvent = EventNames.EditingFlowMusicBackButtonPressed
	},
	supportedCaptureTypes = {
		Enum.CaptureType.Video,
		Enum.CaptureType.Screenshot
	},
	createSession = function() -- line: 39
		-- upvalues: createEditSession (copy)
		return createEditSession()
	end,
	renderEditor = function(p1) -- line: 42
		-- upvalues: React (copy), MusicOverlay (copy)
		return React.createElement(MusicOverlay, {
			controller = p1
		})
	end,
	toEdits = function(p2) -- line: 45
		return {
			music = p2
		}
	end
}
