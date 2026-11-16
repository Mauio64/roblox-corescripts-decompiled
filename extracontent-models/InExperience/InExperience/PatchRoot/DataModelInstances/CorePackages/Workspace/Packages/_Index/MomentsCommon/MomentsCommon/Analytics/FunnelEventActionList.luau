local MomentsCommon = script:FindFirstAncestor("MomentsCommon")

local EventNames = require(MomentsCommon.Analytics.EventNames)
local FunnelEventNames = require(MomentsCommon.Analytics.FunnelEventNames)
local GetFFlagMomentsCreationSaveDraft = require(MomentsCommon.Flags.GetFFlagMomentsCreationSaveDraft)

local FunnelTypes = FunnelEventNames.FunnelTypes
local CreationFlowSteps = FunnelEventNames.CreationFlowSteps
local MusicEnhancementSteps = FunnelEventNames.MusicEnhancementSteps
local TrimEnhancementSteps = FunnelEventNames.TrimEnhancementSteps
local TextOverlayEnhancementSteps = FunnelEventNames.TextOverlayEnhancementSteps
local StickerOverlayEnhancementSteps = FunnelEventNames.StickerOverlayEnhancementSteps
local VoiceEnhancementSteps = FunnelEventNames.VoiceEnhancementSteps
local DraftRecoverySteps = FunnelEventNames.DraftRecoverySteps

local FunnelEventActionList = {
	[EventNames.EditingFlowGalleryItemSelected] = {
		{ funnelType = FunnelTypes.CreationFlow, stepKey = CreationFlowSteps.GalleryItemSelected }
	},
	[EventNames.MomentsEditingFlowContinueToEditButtonPressed] = {
		{
			funnelType = FunnelTypes.CreationFlow,
			stepKey = CreationFlowSteps.GalleryItemSelectedContinuePressed
		}
	},
	[EventNames.MomentsEditingFlowContinueToDescriptionButtonPressed] = {
		{
			funnelType = FunnelTypes.CreationFlow,
			stepKey = CreationFlowSteps.EditingScreenContinuePressed
		}
	}
}

local MomentsEditingFlowPublished = EventNames.MomentsEditingFlowPublished
local v

if GetFFlagMomentsCreationSaveDraft() then
	v = {
		{
			funnelType = FunnelTypes.CreationFlow,
			stepKey = CreationFlowSteps.Published,
			endSession = true
		},
		{
			funnelType = FunnelTypes.DraftRecovery,
			stepKey = DraftRecoverySteps.DraftPublished,
			endSession = true,
			onlyIfSessionOpen = true
		}
	}
else
	v = {
		{
			funnelType = FunnelTypes.CreationFlow,
			stepKey = CreationFlowSteps.Published,
			endSession = true
		}
	}
end

FunnelEventActionList[MomentsEditingFlowPublished] = v

FunnelEventActionList[EventNames.EditingFlowMusicButtonPressed] = {
	{
		funnelType = FunnelTypes.MusicEnhancement,
		stepKey = MusicEnhancementSteps.MusicButtonPressed
	}
}

FunnelEventActionList[EventNames.EditingFlowMusicSelected] = {
	{ funnelType = FunnelTypes.MusicEnhancement, stepKey = MusicEnhancementSteps.MusicSelected }
}

FunnelEventActionList[EventNames.EditingFlowMusicDoneButtonPressed] = {
	{
		funnelType = FunnelTypes.MusicEnhancement,
		stepKey = MusicEnhancementSteps.MusicApplied,
		endSession = true
	}
}

FunnelEventActionList[EventNames.EditingFlowMusicBackButtonPressed] = {
	{ funnelType = FunnelTypes.MusicEnhancement, endSession = true }
}

FunnelEventActionList[EventNames.EditingFlowTextOverlayButtonPressed] = {
	{
		funnelType = FunnelTypes.TextOverlayEnhancement,
		stepKey = TextOverlayEnhancementSteps.TextOverlayButtonPressed
	}
}

FunnelEventActionList[EventNames.EditingFlowTextOverlayDoneButtonPressed] = {
	{
		funnelType = FunnelTypes.TextOverlayEnhancement,
		stepKey = TextOverlayEnhancementSteps.TextOverlayCompleted,
		endSession = true
	}
}

FunnelEventActionList[EventNames.EditingFlowTextOverlayBackButtonPressed] = {
	{ funnelType = FunnelTypes.TextOverlayEnhancement, endSession = true }
}

FunnelEventActionList[EventNames.EditingFlowStickerOverlayButtonPressed] = {
	{
		funnelType = FunnelTypes.StickerOverlayEnhancement,
		stepKey = StickerOverlayEnhancementSteps.StickerOverlayButtonPressed
	}
}

FunnelEventActionList[EventNames.EditingFlowStickerSelected] = {
	{
		funnelType = FunnelTypes.StickerOverlayEnhancement,
		stepKey = StickerOverlayEnhancementSteps.StickerOverlaySelected
	}
}

FunnelEventActionList[EventNames.EditingFlowStickerOverlayDoneButtonPressed] = {
	{
		funnelType = FunnelTypes.StickerOverlayEnhancement,
		stepKey = StickerOverlayEnhancementSteps.StickerOverlayCompleted,
		endSession = true
	}
}

FunnelEventActionList[EventNames.EditingFlowStickerOverlayBackButtonPressed] = {
	{ funnelType = FunnelTypes.StickerOverlayEnhancement, endSession = true }
}

FunnelEventActionList[EventNames.EditingFlowTrimButtonPressed] = {
	{ funnelType = FunnelTypes.TrimEnhancement, stepKey = TrimEnhancementSteps.TrimButtonPressed }
}

FunnelEventActionList[EventNames.EditingFlowTrimDoneButtonPressed] = {
	{
		funnelType = FunnelTypes.TrimEnhancement,
		stepKey = TrimEnhancementSteps.TrimCompleted,
		endSession = true
	}
}

FunnelEventActionList[EventNames.EditingFlowTrimBackButtonPressed] = {
	{ funnelType = FunnelTypes.TrimEnhancement, endSession = true }
}

FunnelEventActionList[EventNames.EditingFlowVoiceButtonPressed] = {
	{
		funnelType = FunnelTypes.VoiceEnhancement,
		stepKey = VoiceEnhancementSteps.VoiceButtonPressed
	}
}

FunnelEventActionList[EventNames.EditingFlowVoiceTextEntered] = {
	{ funnelType = FunnelTypes.VoiceEnhancement, stepKey = VoiceEnhancementSteps.VoiceTextEntered }
}

FunnelEventActionList[EventNames.EditingFlowVoiceGeneratePressed] = {
	{
		funnelType = FunnelTypes.VoiceEnhancement,
		stepKey = VoiceEnhancementSteps.VoiceGeneratePressed
	}
}

FunnelEventActionList[EventNames.EditingFlowVoiceGenerateSucceeded] = {
	{
		funnelType = FunnelTypes.VoiceEnhancement,
		stepKey = VoiceEnhancementSteps.VoiceGenerateSucceeded
	}
}

FunnelEventActionList[EventNames.EditingFlowVoiceDoneButtonPressed] = {
	{
		funnelType = FunnelTypes.VoiceEnhancement,
		stepKey = VoiceEnhancementSteps.VoiceApplied,
		endSession = true
	}
}

FunnelEventActionList[EventNames.EditingFlowVoiceDeleteChangePressed] = {
	{ funnelType = FunnelTypes.VoiceEnhancement, endSession = true }
}

local MomentsEditingFlowExited = EventNames.MomentsEditingFlowExited
local v2

if GetFFlagMomentsCreationSaveDraft() then
	v2 = {
		{ funnelType = FunnelTypes.CreationFlow, endSession = true },
		{ funnelType = FunnelTypes.MusicEnhancement, endSession = true },
		{ funnelType = FunnelTypes.TextOverlayEnhancement, endSession = true },
		{ funnelType = FunnelTypes.StickerOverlayEnhancement, endSession = true },
		{ funnelType = FunnelTypes.TrimEnhancement, endSession = true },
		{ funnelType = FunnelTypes.VoiceEnhancement, endSession = true },
		{ funnelType = FunnelTypes.DraftRecovery, endSession = true, onlyIfSessionOpen = true }
	}
else
	v2 = {
		{ funnelType = FunnelTypes.CreationFlow, endSession = true },
		{ funnelType = FunnelTypes.MusicEnhancement, endSession = true },
		{ funnelType = FunnelTypes.TextOverlayEnhancement, endSession = true },
		{ funnelType = FunnelTypes.StickerOverlayEnhancement, endSession = true },
		{ funnelType = FunnelTypes.TrimEnhancement, endSession = true },
		{ funnelType = FunnelTypes.VoiceEnhancement, endSession = true }
	}
end

FunnelEventActionList[MomentsEditingFlowExited] = v2

FunnelEventActionList[EventNames.DraftRestoreSucceededEvent] = {
	{ funnelType = FunnelTypes.DraftRecovery, stepKey = DraftRecoverySteps.DraftRestored }
}

FunnelEventActionList[EventNames.MomentsReturnToGallery] = GetFFlagMomentsCreationSaveDraft() and {
	{ funnelType = FunnelTypes.DraftRecovery, endSession = true, onlyIfSessionOpen = true }
} or {}

return FunnelEventActionList
