local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local EventNames = require(MomentsCommon.Analytics.EventNames)
local FunnelEventNames = require(MomentsCommon.Analytics.FunnelEventNames)
local FunnelTypes = FunnelEventNames.FunnelTypes
local CreationFlowSteps = FunnelEventNames.CreationFlowSteps
local MusicEnhancementSteps = FunnelEventNames.MusicEnhancementSteps
local TrimEnhancementSteps = FunnelEventNames.TrimEnhancementSteps
local TextOverlayEnhancementSteps = FunnelEventNames.TextOverlayEnhancementSteps
local StickerOverlayEnhancementSteps = FunnelEventNames.StickerOverlayEnhancementSteps

return {
	[EventNames.EditingFlowGalleryItemSelected] = {{
		funnelType = FunnelTypes.CreationFlow,
		stepKey = CreationFlowSteps.GalleryItemSelected
	}},
	[EventNames.MomentsEditingFlowContinueToEditButtonPressed] = {{
		funnelType = FunnelTypes.CreationFlow,
		stepKey = CreationFlowSteps.GalleryItemSelectedContinuePressed
	}},
	[EventNames.MomentsEditingFlowContinueToDescriptionButtonPressed] = {{
		funnelType = FunnelTypes.CreationFlow,
		stepKey = CreationFlowSteps.EditingScreenContinuePressed
	}},
	[EventNames.MomentsEditingFlowPublished] = {{
		endSession = true,
		funnelType = FunnelTypes.CreationFlow,
		stepKey = CreationFlowSteps.Published
	}},
	[EventNames.EditingFlowMusicButtonPressed] = {{
		funnelType = FunnelTypes.MusicEnhancement,
		stepKey = MusicEnhancementSteps.MusicButtonPressed
	}},
	[EventNames.EditingFlowMusicSelected] = {{
		funnelType = FunnelTypes.MusicEnhancement,
		stepKey = MusicEnhancementSteps.MusicSelected
	}},
	[EventNames.EditingFlowMusicDoneButtonPressed] = {{
		endSession = true,
		funnelType = FunnelTypes.MusicEnhancement,
		stepKey = MusicEnhancementSteps.MusicApplied
	}},
	[EventNames.EditingFlowMusicBackButtonPressed] = {{
		endSession = true,
		funnelType = FunnelTypes.MusicEnhancement
	}},
	[EventNames.EditingFlowTextOverlayButtonPressed] = {{
		funnelType = FunnelTypes.TextOverlayEnhancement,
		stepKey = TextOverlayEnhancementSteps.TextOverlayButtonPressed
	}},
	[EventNames.EditingFlowTextOverlayDoneButtonPressed] = {{
		endSession = true,
		funnelType = FunnelTypes.TextOverlayEnhancement,
		stepKey = TextOverlayEnhancementSteps.TextOverlayCompleted
	}},
	[EventNames.EditingFlowTextOverlayBackButtonPressed] = {{
		endSession = true,
		funnelType = FunnelTypes.TextOverlayEnhancement
	}},
	[EventNames.EditingFlowStickerOverlayButtonPressed] = {{
		funnelType = FunnelTypes.StickerOverlayEnhancement,
		stepKey = StickerOverlayEnhancementSteps.StickerOverlayButtonPressed
	}},
	[EventNames.EditingFlowStickerOverlayDoneButtonPressed] = {{
		endSession = true,
		funnelType = FunnelTypes.StickerOverlayEnhancement,
		stepKey = StickerOverlayEnhancementSteps.StickerOverlayCompleted
	}},
	[EventNames.EditingFlowStickerOverlayBackButtonPressed] = {{
		endSession = true,
		funnelType = FunnelTypes.StickerOverlayEnhancement
	}},
	[EventNames.EditingFlowTrimButtonPressed] = {{
		funnelType = FunnelTypes.TrimEnhancement,
		stepKey = TrimEnhancementSteps.TrimButtonPressed
	}},
	[EventNames.EditingFlowTrimDoneButtonPressed] = {{
		endSession = true,
		funnelType = FunnelTypes.TrimEnhancement,
		stepKey = TrimEnhancementSteps.TrimCompleted
	}},
	[EventNames.EditingFlowTrimBackButtonPressed] = {{
		endSession = true,
		funnelType = FunnelTypes.TrimEnhancement
	}},
	[EventNames.MomentsEditingFlowExited] = {
		{
			endSession = true,
			funnelType = FunnelTypes.CreationFlow
		},
		{
			endSession = true,
			funnelType = FunnelTypes.MusicEnhancement
		},
		{
			endSession = true,
			funnelType = FunnelTypes.TextOverlayEnhancement
		},
		{
			endSession = true,
			funnelType = FunnelTypes.StickerOverlayEnhancement
		},
		{
			endSession = true,
			funnelType = FunnelTypes.TrimEnhancement
		}
	}
}
