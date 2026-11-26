local v5 = {
	AppNavigation = "App Navigation",
	CreationFlow = "Creation Flow",
	MusicEnhancement = "Music Enhancement",
	TextOverlayEnhancement = "Text Enhancement",
	StickerOverlayEnhancement = "Sticker Enhancement",
	TrimEnhancement = "Trim Enhancement",
	VoiceEnhancement = "Voice Enhancement",
	DraftRecovery = "Draft Recovery"
}

local v6 = {
	AppLaunched = "AppLaunched",
	TrendingScreenView = "TrendingScreenView",
	MyMomentsScreenView = "MyMomentsScreenView",
	UserProfileScreenView = "UserProfileScreenView"
}

local v7 = {
	CreateIntent = "CreateIntent",
	GalleryItemSelected = "GalleryItemSelected",
	GalleryItemSelectedContinuePressed = "GalleryItemSelectedContinuePressed",
	EditingScreenContinuePressed = "EditingScreenContinuePressed",
	Published = "Published"
}

local v8 = {
	MusicButtonPressed = "MusicButtonPressed",
	MusicSelected = "MusicSelected",
	MusicApplied = "MusicApplied"
}

local v9 = {
	TextOverlayButtonPressed = "TextOverlayButtonPressed",
	TextOverlayCompleted = "TextOverlayCompleted"
}

local v10 = {
	StickerOverlayButtonPressed = "StickerOverlayButtonPressed",
	StickerOverlaySelected = "StickerOverlaySelected",
	StickerOverlayCompleted = "StickerOverlayCompleted"
}

local v11 = { TrimButtonPressed = "TrimButtonPressed", TrimCompleted = "TrimCompleted" }

local v12 = {
	VoiceButtonPressed = "VoiceButtonPressed",
	VoiceTextEntered = "VoiceTextEntered",
	VoiceGeneratePressed = "VoiceGeneratePressed",
	VoiceGenerateSucceeded = "VoiceGenerateSucceeded",
	VoiceApplied = "VoiceApplied"
}

local v13 = { DraftRestored = "DraftRestored", DraftPublished = "DraftPublished" }

local v14 = {
	[v5.AppNavigation] = {
		[v6.AppLaunched] = { stepNumber = 1, stepName = "App Launched" },
		[v6.TrendingScreenView] = { stepNumber = 2, stepName = "Trending Screen View" },
		[v6.MyMomentsScreenView] = {
			stepNumber = 3,
			stepName = "My Moments Screen View"
		},
		[v6.UserProfileScreenView] = {
			stepNumber = 4,
			stepName = "User Profile Screen View"
		}
	}
}

local creationFlow = v5.CreationFlow
v14[creationFlow] = {
	[v7.CreateIntent] = { stepNumber = 1, stepName = "Create Intent" },
	[v7.GalleryItemSelected] = { stepNumber = 2, stepName = "Gallery Item Selected" },
	[v7.GalleryItemSelectedContinuePressed] = {
		stepNumber = 3,
		stepName = "Gallery Item Selected Continue Pressed"
	},
	[v7.EditingScreenContinuePressed] = {
		stepNumber = 4,
		stepName = "Editing Screen Continue Pressed"
	},
	[v7.Published] = { stepNumber = 5, stepName = "Published" }
}

local musicEnhancement = v5.MusicEnhancement
v14[musicEnhancement] = {
	[v8.MusicButtonPressed] = { stepNumber = 1, stepName = "Music Button Pressed" },
	[v8.MusicSelected] = { stepNumber = 2, stepName = "Music Selected" },
	[v8.MusicApplied] = { stepNumber = 3, stepName = "Music Applied" }
}

local trimEnhancement = v5.TrimEnhancement
v14[trimEnhancement] = {
	[v11.TrimButtonPressed] = { stepNumber = 1, stepName = "Trim Button Pressed" },
	[v11.TrimCompleted] = { stepNumber = 2, stepName = "Trim Completed" }
}

local textOverlayEnhancement = v5.TextOverlayEnhancement
v14[textOverlayEnhancement] = {
	[v9.TextOverlayButtonPressed] = {
		stepNumber = 1,
		stepName = "Text Overlay Button Pressed"
	},
	[v9.TextOverlayCompleted] = { stepNumber = 2, stepName = "Text Overlay Completed" }
}

local stickerOverlayEnhancement = v5.StickerOverlayEnhancement
v14[stickerOverlayEnhancement] = {
	[v10.StickerOverlayButtonPressed] = {
		stepNumber = 1,
		stepName = "Sticker Overlay Button Pressed"
	},
	[v10.StickerOverlaySelected] = {
		stepNumber = 2,
		stepName = "Sticker Overlay Selected"
	},
	[v10.StickerOverlayCompleted] = {
		stepNumber = 3,
		stepName = "Sticker Overlay Completed"
	}
}

local voiceEnhancement = v5.VoiceEnhancement
v14[voiceEnhancement] = {
	[v12.VoiceButtonPressed] = { stepNumber = 1, stepName = "Voice Button Pressed" },
	[v12.VoiceTextEntered] = { stepNumber = 2, stepName = "Voice Text Entered" },
	[v12.VoiceGeneratePressed] = { stepNumber = 3, stepName = "Voice Generate Pressed" },
	[v12.VoiceGenerateSucceeded] = {
		stepNumber = 4,
		stepName = "Voice Generate Succeeded"
	},
	[v12.VoiceApplied] = { stepNumber = 5, stepName = "Voice Applied" }
}

local draftRecovery = v5.DraftRecovery
v14[draftRecovery] = {
	[v13.DraftRestored] = { stepNumber = 1, stepName = "Draft Restored" },
	[v13.DraftPublished] = { stepNumber = 2, stepName = "Draft Published" }
}
return {
	FunnelTypes = v5,
	FunnelSteps = v14,
	CreationIntentSource = { Captures = "Captures", TopBar = "TopBar" },
	AppNavigationSteps = v6,
	CreationFlowSteps = v7,
	MusicEnhancementSteps = v8,
	TrimEnhancementSteps = v11,
	TextOverlayEnhancementSteps = v9,
	StickerOverlayEnhancementSteps = v10,
	VoiceEnhancementSteps = v12,
	DraftRecoverySteps = v13
}
