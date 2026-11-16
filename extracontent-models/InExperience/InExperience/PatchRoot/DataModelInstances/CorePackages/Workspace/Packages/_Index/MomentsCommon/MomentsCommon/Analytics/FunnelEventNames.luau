local funnelTypes = {
	AppNavigation = "App Navigation",
	CreationFlow = "Creation Flow",
	MusicEnhancement = "Music Enhancement",
	TextOverlayEnhancement = "Text Enhancement",
	StickerOverlayEnhancement = "Sticker Enhancement",
	TrimEnhancement = "Trim Enhancement",
	VoiceEnhancement = "Voice Enhancement",
	DraftRecovery = "Draft Recovery"
}

local appNavigationSteps = {
	AppLaunched = "AppLaunched",
	TrendingScreenView = "TrendingScreenView",
	MyMomentsScreenView = "MyMomentsScreenView",
	UserProfileScreenView = "UserProfileScreenView"
}

local creationFlowSteps = {
	CreateIntent = "CreateIntent",
	GalleryItemSelected = "GalleryItemSelected",
	GalleryItemSelectedContinuePressed = "GalleryItemSelectedContinuePressed",
	EditingScreenContinuePressed = "EditingScreenContinuePressed",
	Published = "Published"
}

local musicEnhancementSteps = {
	MusicButtonPressed = "MusicButtonPressed",
	MusicSelected = "MusicSelected",
	MusicApplied = "MusicApplied"
}

local textOverlayEnhancementSteps = {
	TextOverlayButtonPressed = "TextOverlayButtonPressed",
	TextOverlayCompleted = "TextOverlayCompleted"
}

local stickerOverlayEnhancementSteps = {
	StickerOverlayButtonPressed = "StickerOverlayButtonPressed",
	StickerOverlaySelected = "StickerOverlaySelected",
	StickerOverlayCompleted = "StickerOverlayCompleted"
}

local trimEnhancementSteps = {
	TrimButtonPressed = "TrimButtonPressed",
	TrimCompleted = "TrimCompleted"
}

local voiceEnhancementSteps = {
	VoiceButtonPressed = "VoiceButtonPressed",
	VoiceTextEntered = "VoiceTextEntered",
	VoiceGeneratePressed = "VoiceGeneratePressed",
	VoiceGenerateSucceeded = "VoiceGenerateSucceeded",
	VoiceApplied = "VoiceApplied"
}

local draftRecoverySteps = { DraftRestored = "DraftRestored", DraftPublished = "DraftPublished" }

local funnelSteps = {
	[funnelTypes.AppNavigation] = {
		[appNavigationSteps.AppLaunched] = { stepNumber = 1, stepName = "App Launched" },
		[appNavigationSteps.TrendingScreenView] = {
			stepNumber = 2,
			stepName = "Trending Screen View"
		},
		[appNavigationSteps.MyMomentsScreenView] = {
			stepNumber = 3,
			stepName = "My Moments Screen View"
		},
		[appNavigationSteps.UserProfileScreenView] = {
			stepNumber = 4,
			stepName = "User Profile Screen View"
		}
	}
}

local creationFlow = funnelTypes.CreationFlow
funnelSteps[creationFlow] = {
	[creationFlowSteps.CreateIntent] = { stepNumber = 1, stepName = "Create Intent" },
	[creationFlowSteps.GalleryItemSelected] = { stepNumber = 2, stepName = "Gallery Item Selected" },
	[creationFlowSteps.GalleryItemSelectedContinuePressed] = {
		stepNumber = 3,
		stepName = "Gallery Item Selected Continue Pressed"
	},
	[creationFlowSteps.EditingScreenContinuePressed] = {
		stepNumber = 4,
		stepName = "Editing Screen Continue Pressed"
	},
	[creationFlowSteps.Published] = { stepNumber = 5, stepName = "Published" }
}

local musicEnhancement = funnelTypes.MusicEnhancement
funnelSteps[musicEnhancement] = {
	[musicEnhancementSteps.MusicButtonPressed] = {
		stepNumber = 1,
		stepName = "Music Button Pressed"
	},
	[musicEnhancementSteps.MusicSelected] = { stepNumber = 2, stepName = "Music Selected" },
	[musicEnhancementSteps.MusicApplied] = { stepNumber = 3, stepName = "Music Applied" }
}

local trimEnhancement = funnelTypes.TrimEnhancement
funnelSteps[trimEnhancement] = {
	[trimEnhancementSteps.TrimButtonPressed] = { stepNumber = 1, stepName = "Trim Button Pressed" },
	[trimEnhancementSteps.TrimCompleted] = { stepNumber = 2, stepName = "Trim Completed" }
}

local textOverlayEnhancement = funnelTypes.TextOverlayEnhancement
funnelSteps[textOverlayEnhancement] = {
	[textOverlayEnhancementSteps.TextOverlayButtonPressed] = {
		stepNumber = 1,
		stepName = "Text Overlay Button Pressed"
	},
	[textOverlayEnhancementSteps.TextOverlayCompleted] = {
		stepNumber = 2,
		stepName = "Text Overlay Completed"
	}
}

local stickerOverlayEnhancement = funnelTypes.StickerOverlayEnhancement
funnelSteps[stickerOverlayEnhancement] = {
	[stickerOverlayEnhancementSteps.StickerOverlayButtonPressed] = {
		stepNumber = 1,
		stepName = "Sticker Overlay Button Pressed"
	},
	[stickerOverlayEnhancementSteps.StickerOverlaySelected] = {
		stepNumber = 2,
		stepName = "Sticker Overlay Selected"
	},
	[stickerOverlayEnhancementSteps.StickerOverlayCompleted] = {
		stepNumber = 3,
		stepName = "Sticker Overlay Completed"
	}
}

local voiceEnhancement = funnelTypes.VoiceEnhancement
funnelSteps[voiceEnhancement] = {
	[voiceEnhancementSteps.VoiceButtonPressed] = {
		stepNumber = 1,
		stepName = "Voice Button Pressed"
	},
	[voiceEnhancementSteps.VoiceTextEntered] = { stepNumber = 2, stepName = "Voice Text Entered" },
	[voiceEnhancementSteps.VoiceGeneratePressed] = {
		stepNumber = 3,
		stepName = "Voice Generate Pressed"
	},
	[voiceEnhancementSteps.VoiceGenerateSucceeded] = {
		stepNumber = 4,
		stepName = "Voice Generate Succeeded"
	},
	[voiceEnhancementSteps.VoiceApplied] = { stepNumber = 5, stepName = "Voice Applied" }
}

local draftRecovery = funnelTypes.DraftRecovery
funnelSteps[draftRecovery] = {
	[draftRecoverySteps.DraftRestored] = { stepNumber = 1, stepName = "Draft Restored" },
	[draftRecoverySteps.DraftPublished] = { stepNumber = 2, stepName = "Draft Published" }
}
return {
	FunnelTypes = funnelTypes,
	FunnelSteps = funnelSteps,
	CreationIntentSource = { Captures = "Captures", TopBar = "TopBar" },
	AppNavigationSteps = appNavigationSteps,
	CreationFlowSteps = creationFlowSteps,
	MusicEnhancementSteps = musicEnhancementSteps,
	TrimEnhancementSteps = trimEnhancementSteps,
	TextOverlayEnhancementSteps = textOverlayEnhancementSteps,
	StickerOverlayEnhancementSteps = stickerOverlayEnhancementSteps,
	VoiceEnhancementSteps = voiceEnhancementSteps,
	DraftRecoverySteps = draftRecoverySteps
}
