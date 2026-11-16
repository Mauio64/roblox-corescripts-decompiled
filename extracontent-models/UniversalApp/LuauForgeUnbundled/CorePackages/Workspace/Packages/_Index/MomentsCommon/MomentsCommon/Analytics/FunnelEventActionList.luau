local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Analytics/EventNames")
local FunnelEventNames = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Analytics/FunnelEventNames")
local GetFFlagMomentsCreationSaveDraft = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/GetFFlagMomentsCreationSaveDraft")

local funnelTypes = FunnelEventNames.FunnelTypes
local creationFlowSteps = FunnelEventNames.CreationFlowSteps
local musicEnhancementSteps = FunnelEventNames.MusicEnhancementSteps
local trimEnhancementSteps = FunnelEventNames.TrimEnhancementSteps
local textOverlayEnhancementSteps = FunnelEventNames.TextOverlayEnhancementSteps
local stickerOverlayEnhancementSteps = FunnelEventNames.StickerOverlayEnhancementSteps
local voiceEnhancementSteps = FunnelEventNames.VoiceEnhancementSteps
local draftRecoverySteps = FunnelEventNames.DraftRecoverySteps

local v5 = {
	[EventNames.EditingFlowGalleryItemSelected] = {
		{
			funnelType = funnelTypes.CreationFlow,
			stepKey = creationFlowSteps.GalleryItemSelected
		}
	},
	[EventNames.MomentsEditingFlowContinueToEditButtonPressed] = {
		{
			funnelType = funnelTypes.CreationFlow,
			stepKey = creationFlowSteps.GalleryItemSelectedContinuePressed
		}
	},
	[EventNames.MomentsEditingFlowContinueToDescriptionButtonPressed] = {
		{
			funnelType = funnelTypes.CreationFlow,
			stepKey = creationFlowSteps.EditingScreenContinuePressed
		}
	}
}

local momentsEditingFlowPublished = EventNames.MomentsEditingFlowPublished
local v6 = if GetFFlagMomentsCreationSaveDraft() then {
	{
		funnelType = funnelTypes.CreationFlow,
		stepKey = creationFlowSteps.Published,
		endSession = true
	},
	{
		funnelType = funnelTypes.DraftRecovery,
		stepKey = draftRecoverySteps.DraftPublished,
		endSession = true,
		onlyIfSessionOpen = true
	}
} else {
	{
		funnelType = funnelTypes.CreationFlow,
		stepKey = creationFlowSteps.Published,
		endSession = true
	}
}
v5[momentsEditingFlowPublished] = v6

v5[EventNames.EditingFlowMusicButtonPressed] = {
	{
		funnelType = funnelTypes.MusicEnhancement,
		stepKey = musicEnhancementSteps.MusicButtonPressed
	}
}

v5[EventNames.EditingFlowMusicSelected] = {
	{
		funnelType = funnelTypes.MusicEnhancement,
		stepKey = musicEnhancementSteps.MusicSelected
	}
}

v5[EventNames.EditingFlowMusicDoneButtonPressed] = {
	{
		funnelType = funnelTypes.MusicEnhancement,
		stepKey = musicEnhancementSteps.MusicApplied,
		endSession = true
	}
}

v5[EventNames.EditingFlowMusicBackButtonPressed] = {
	{ funnelType = funnelTypes.MusicEnhancement, endSession = true }
}

v5[EventNames.EditingFlowTextOverlayButtonPressed] = {
	{
		funnelType = funnelTypes.TextOverlayEnhancement,
		stepKey = textOverlayEnhancementSteps.TextOverlayButtonPressed
	}
}

v5[EventNames.EditingFlowTextOverlayDoneButtonPressed] = {
	{
		funnelType = funnelTypes.TextOverlayEnhancement,
		stepKey = textOverlayEnhancementSteps.TextOverlayCompleted,
		endSession = true
	}
}

v5[EventNames.EditingFlowTextOverlayBackButtonPressed] = {
	{ funnelType = funnelTypes.TextOverlayEnhancement, endSession = true }
}

v5[EventNames.EditingFlowStickerOverlayButtonPressed] = {
	{
		funnelType = funnelTypes.StickerOverlayEnhancement,
		stepKey = stickerOverlayEnhancementSteps.StickerOverlayButtonPressed
	}
}

v5[EventNames.EditingFlowStickerSelected] = {
	{
		funnelType = funnelTypes.StickerOverlayEnhancement,
		stepKey = stickerOverlayEnhancementSteps.StickerOverlaySelected
	}
}

v5[EventNames.EditingFlowStickerOverlayDoneButtonPressed] = {
	{
		funnelType = funnelTypes.StickerOverlayEnhancement,
		stepKey = stickerOverlayEnhancementSteps.StickerOverlayCompleted,
		endSession = true
	}
}

v5[EventNames.EditingFlowStickerOverlayBackButtonPressed] = {
	{ funnelType = funnelTypes.StickerOverlayEnhancement, endSession = true }
}

v5[EventNames.EditingFlowTrimButtonPressed] = {
	{
		funnelType = funnelTypes.TrimEnhancement,
		stepKey = trimEnhancementSteps.TrimButtonPressed
	}
}

v5[EventNames.EditingFlowTrimDoneButtonPressed] = {
	{
		funnelType = funnelTypes.TrimEnhancement,
		stepKey = trimEnhancementSteps.TrimCompleted,
		endSession = true
	}
}

v5[EventNames.EditingFlowTrimBackButtonPressed] = {
	{ funnelType = funnelTypes.TrimEnhancement, endSession = true }
}

v5[EventNames.EditingFlowVoiceButtonPressed] = {
	{
		funnelType = funnelTypes.VoiceEnhancement,
		stepKey = voiceEnhancementSteps.VoiceButtonPressed
	}
}

v5[EventNames.EditingFlowVoiceTextEntered] = {
	{
		funnelType = funnelTypes.VoiceEnhancement,
		stepKey = voiceEnhancementSteps.VoiceTextEntered
	}
}

v5[EventNames.EditingFlowVoiceGeneratePressed] = {
	{
		funnelType = funnelTypes.VoiceEnhancement,
		stepKey = voiceEnhancementSteps.VoiceGeneratePressed
	}
}

v5[EventNames.EditingFlowVoiceGenerateSucceeded] = {
	{
		funnelType = funnelTypes.VoiceEnhancement,
		stepKey = voiceEnhancementSteps.VoiceGenerateSucceeded
	}
}

v5[EventNames.EditingFlowVoiceDoneButtonPressed] = {
	{
		funnelType = funnelTypes.VoiceEnhancement,
		stepKey = voiceEnhancementSteps.VoiceApplied,
		endSession = true
	}
}

v5[EventNames.EditingFlowVoiceDeleteChangePressed] = {
	{ funnelType = funnelTypes.VoiceEnhancement, endSession = true }
}

local momentsEditingFlowExited = EventNames.MomentsEditingFlowExited
local v7

if GetFFlagMomentsCreationSaveDraft() then
	v7 = {
		{ funnelType = funnelTypes.CreationFlow, endSession = true },
		{ funnelType = funnelTypes.MusicEnhancement, endSession = true },
		{ funnelType = funnelTypes.TextOverlayEnhancement, endSession = true },
		{ funnelType = funnelTypes.StickerOverlayEnhancement, endSession = true },
		{ funnelType = funnelTypes.TrimEnhancement, endSession = true },
		{ funnelType = funnelTypes.VoiceEnhancement, endSession = true },
		{
			funnelType = funnelTypes.DraftRecovery,
			endSession = true,
			onlyIfSessionOpen = true
		}
	}
else
	v7 = {
		{ funnelType = funnelTypes.CreationFlow, endSession = true },
		{ funnelType = funnelTypes.MusicEnhancement, endSession = true },
		{ funnelType = funnelTypes.TextOverlayEnhancement, endSession = true },
		{ funnelType = funnelTypes.StickerOverlayEnhancement, endSession = true },
		{ funnelType = funnelTypes.TrimEnhancement, endSession = true },
		{ funnelType = funnelTypes.VoiceEnhancement, endSession = true }
	}
end

v5[momentsEditingFlowExited] = v7

v5[EventNames.DraftRestoreSucceededEvent] = {
	{
		funnelType = funnelTypes.DraftRecovery,
		stepKey = draftRecoverySteps.DraftRestored
	}
}

v5[EventNames.MomentsReturnToGallery] = GetFFlagMomentsCreationSaveDraft() and {
	{
		funnelType = funnelTypes.DraftRecovery,
		endSession = true,
		onlyIfSessionOpen = true
	}
} or {}

return v5
