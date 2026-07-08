local t1 = {
	AppNavigation = "App Navigation",
	CreationFlow = "Creation Flow",
	MusicEnhancement = "Music Enhancement",
	TextOverlayEnhancement = "Text Enhancement",
	TrimEnhancement = "Trim Enhancement"
}
local t2 = {
	AppLaunched = "AppLaunched",
	TrendingScreenView = "TrendingScreenView",
	MyMomentsScreenView = "MyMomentsScreenView",
	UserProfileScreenView = "UserProfileScreenView"
}
local t3 = {
	TopBar = "TopBar"
}
local t4 = {
	CreateIntent = "CreateIntent",
	GalleryItemSelected = "GalleryItemSelected",
	GalleryItemSelectedContinuePressed = "GalleryItemSelectedContinuePressed",
	EditingScreenContinuePressed = "EditingScreenContinuePressed",
	Published = "Published"
}
local t5 = {
	MusicButtonPressed = "MusicButtonPressed",
	MusicSelected = "MusicSelected",
	MusicApplied = "MusicApplied"
}
local t6 = {
	TextOverlayButtonPressed = "TextOverlayButtonPressed",
	TextOverlayCompleted = "TextOverlayCompleted"
}
local t7 = {
	TrimButtonPressed = "TrimButtonPressed",
	TrimCompleted = "TrimCompleted"
}
local t8 = {
	[t1.AppNavigation] = {
		[t2.AppLaunched] = {
			stepNumber = 1,
			stepName = "App Launched"
		},
		[t2.TrendingScreenView] = {
			stepNumber = 2,
			stepName = "Trending Screen View"
		},
		[t2.MyMomentsScreenView] = {
			stepNumber = 3,
			stepName = "My Moments Screen View"
		},
		[t2.UserProfileScreenView] = {
			stepNumber = 4,
			stepName = "User Profile Screen View"
		}
	},
	[t1.CreationFlow] = {
		[t4.CreateIntent] = {
			stepNumber = 1,
			stepName = "Create Intent"
		},
		[t4.GalleryItemSelected] = {
			stepNumber = 2,
			stepName = "Gallery Item Selected"
		},
		[t4.GalleryItemSelectedContinuePressed] = {
			stepNumber = 3,
			stepName = "Gallery Item Selected Continue Pressed"
		},
		[t4.EditingScreenContinuePressed] = {
			stepNumber = 4,
			stepName = "Editing Screen Continue Pressed"
		},
		[t4.Published] = {
			stepNumber = 5,
			stepName = "Published"
		}
	},
	[t1.MusicEnhancement] = {
		[t5.MusicButtonPressed] = {
			stepNumber = 1,
			stepName = "Music Button Pressed"
		},
		[t5.MusicSelected] = {
			stepNumber = 2,
			stepName = "Music Selected"
		},
		[t5.MusicApplied] = {
			stepNumber = 3,
			stepName = "Music Applied"
		}
	},
	[t1.TrimEnhancement] = {
		[t7.TrimButtonPressed] = {
			stepNumber = 1,
			stepName = "Trim Button Pressed"
		},
		[t7.TrimCompleted] = {
			stepNumber = 2,
			stepName = "Trim Completed"
		}
	},
	[t1.TextOverlayEnhancement] = {
		[t6.TextOverlayButtonPressed] = {
			stepNumber = 1,
			stepName = "Text Overlay Button Pressed"
		},
		[t6.TextOverlayCompleted] = {
			stepNumber = 2,
			stepName = "Text Overlay Completed"
		}
	}
}

return {
	FunnelTypes = t1,
	FunnelSteps = t8,
	CreationIntentSource = t3,
	AppNavigationSteps = t2,
	CreationFlowSteps = t4,
	MusicEnhancementSteps = t5,
	TrimEnhancementSteps = t7,
	TextOverlayEnhancementSteps = t6
}
