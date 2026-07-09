local ParentParent = script.Parent.Parent.Parent
local Dash = require(ParentParent.Dash)
local Enums = require(ParentParent.SocialLuaAnalytics).Analytics.Enums
local Contexts = Enums.Contexts
local EventTypes = Enums.EventTypes
local EventNames = require(script.Parent.EventNames)

return {
	[EventNames.CapturesActivatedChrome] = {
		additionalInfo = {
			btn = EventNames.CapturesActivatedChrome
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesActivatedInGameMenu] = {
		additionalInfo = {
			btn = EventNames.CapturesActivatedInGameMenu
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesCarouselClosed] = {
		additionalInfo = {
			btn = EventNames.CapturesCarouselClosed
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesCarouselClosedByKeyboard] = {
		additionalInfo = {
			btn = EventNames.CapturesCarouselClosedByKeyboard
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesCarouselNavigated] = {
		additionalInfo = {
			btn = EventNames.CapturesCarouselNavigated
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick,
		formatRulesForAdditionalInfo = {
			direction = Dash.identity
		}
	},
	[EventNames.CapturesCarouselNavigatedByKeyboard] = {
		additionalInfo = {
			btn = EventNames.CapturesCarouselNavigatedByKeyboard
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick,
		formatRulesForAdditionalInfo = {
			direction = Dash.identity
		}
	},
	[EventNames.CapturesCarouselOpened] = {
		additionalInfo = {
			btn = EventNames.CapturesCarouselOpened
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesCarouselSaveToExternalStorageActivated] = {
		additionalInfo = {
			btn = EventNames.CapturesCarouselSaveToExternalStorageActivated
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesCarouselScrolled] = {
		additionalInfo = {
			btn = EventNames.CapturesCarouselScrolled
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick,
		formatRulesForAdditionalInfo = {
			direction = Dash.identity
		}
	},
	[EventNames.CapturesCarouselVideoExpanded] = {
		additionalInfo = {
			btn = EventNames.CapturesCarouselVideoExpanded
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesCarouselVideoMuteButtonActivated] = {
		additionalInfo = {
			btn = EventNames.CapturesCarouselVideoMuteButtonActivated
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesCarouselVideoSaveToExternalStorageActivated] = {
		additionalInfo = {
			btn = EventNames.CapturesCarouselVideoSaveToExternalStorageActivated
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesCarouselVideoShareActivated] = {
		additionalInfo = {
			btn = EventNames.CapturesCarouselVideoShareActivated
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesCarouselVideoShrank] = {
		additionalInfo = {
			btn = EventNames.CapturesCarouselVideoShrank
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesCarouselShareActivated] = {
		additionalInfo = {
			btn = EventNames.CapturesCarouselShareActivated
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesCoreGuiDisabled] = {
		additionalInfo = {
			btn = EventNames.CapturesCoreGuiDisabled
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick,
		formatRulesForAdditionalInfo = {
			allTypeChanged = Dash.identity
		}
	},
	[EventNames.CapturesCoreGuiEnabled] = {
		additionalInfo = {
			btn = EventNames.CapturesCoreGuiEnabled
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick,
		formatRulesForAdditionalInfo = {
			allTypeChanged = Dash.identity
		}
	},
	[EventNames.CapturesDeactivatedChrome] = {
		additionalInfo = {
			btn = EventNames.CapturesDeactivatedChrome
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesDeactivatedInGameMenu] = {
		additionalInfo = {
			btn = EventNames.CapturesDeactivatedInGameMenu
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesDeleteActivatedInCaptureManager] = {
		additionalInfo = {
			btn = EventNames.CapturesDeleteActivatedInCaptureManager
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesDeleteActivatedInCarousel] = {
		additionalInfo = {
			btn = EventNames.CapturesDeleteActivatedInCarousel
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesVideoDeleteActivatedInCarousel] = {
		additionalInfo = {
			btn = EventNames.CapturesVideoDeleteActivatedInCarousel
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesDeleteWarningModalCancelPressed] = {
		additionalInfo = {
			btn = EventNames.CapturesDeleteWarningModalCancelPressed
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesDeleteWarningModalDeletePressed] = {
		additionalInfo = {
			btn = EventNames.CapturesDeleteWarningModalDeletePressed
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesDeleteWarningModalOptedOut] = {
		additionalInfo = {
			btn = EventNames.CapturesDeleteWarningModalOptedOut
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesDesktopHotkeyCaptureTriggered] = {
		additionalInfo = {
			btn = EventNames.CapturesDesktopHotkeyCaptureTriggered
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesEntrypointActivated] = {
		additionalInfo = {
			btn = EventNames.CapturesEntrypointActivated
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesEntrypointVideoActivated] = {
		additionalInfo = {
			btn = EventNames.CapturesEntrypointVideoActivated
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesEntrypointVideoDeactivated] = {
		additionalInfo = {
			btn = EventNames.CapturesEntrypointVideoDeactivated
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesEntrypointVideoDeactivatedAutomatically] = {
		additionalInfo = {
			btn = EventNames.CapturesEntrypointVideoDeactivatedAutomatically
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesEntrypointDragged] = {
		additionalInfo = {
			btn = EventNames.CapturesEntrypointDragged
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesEntrypointHotkeyTooltipActivated] = {
		additionalInfo = {
			btn = EventNames.CapturesEntrypointHotkeyTooltipActivated
		},
		context = Contexts.Captures,
		eventType = EventTypes.UserSeen
	},
	[EventNames.CapturesEntrypointViewed] = {
		additionalInfo = {
			btn = EventNames.CapturesEntrypointViewed
		},
		context = Contexts.Captures,
		eventType = EventTypes.UserSeen
	},
	[EventNames.CapturesManagerBulkSaveToExternalStorageActivated] = {
		additionalInfo = {
			btn = EventNames.CapturesManagerBulkSaveToExternalStorageActivated
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesManagerShareVideoActivated] = {
		additionalInfo = {
			btn = EventNames.CapturesManagerShareVideoActivated
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesManagerItemActivated] = {
		additionalInfo = {
			btn = EventNames.CapturesManagerItemActivated
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesManagerOpened] = {
		additionalInfo = {
			btn = EventNames.CapturesManagerOpened
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesManagerSaveToExternalStorageActivated] = {
		additionalInfo = {
			btn = EventNames.CapturesManagerSaveToExternalStorageActivated
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesManagerSelectAllActivated] = {
		additionalInfo = {
			btn = EventNames.CapturesManagerSelectAllActivated
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesManagerShareActivated] = {
		additionalInfo = {
			btn = EventNames.CapturesManagerShareActivated
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesMigratedLegacyVideoRecordActivated] = {
		additionalInfo = {
			btn = EventNames.CapturesMigratedLegacyVideoRecordActivated
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesMigratedLegacyVideoRecordDeactivated] = {
		additionalInfo = {
			btn = EventNames.CapturesMigratedLegacyVideoRecordDeactivated
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesPageOpenedInGameMenu] = {
		context = Contexts.Captures,
		eventType = EventTypes.PageLoad
	},
	[EventNames.CapturesSavedToDeviceToastOpenButtonActivated] = {
		additionalInfo = {
			btn = EventNames.CapturesSavedToDeviceToastOpenButtonActivated
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesSavePermissionModalAllowPressed] = {
		additionalInfo = {
			btn = EventNames.CapturesSavePermissionModalAllowPressed
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesSavePermissionModalCancelPressed] = {
		additionalInfo = {
			btn = EventNames.CapturesSavePermissionModalCancelPressed
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesShareFromNonStandardServer] = {
		additionalInfo = {
			btn = EventNames.CapturesShareFromNonStandardServer
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesShareToastButtonActivated] = {
		additionalInfo = {
			btn = EventNames.CapturesShareToastButtonActivated
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesVideoShareToastButtonActivated] = {
		additionalInfo = {
			btn = EventNames.CapturesVideoShareToastButtonActivated
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesShareToastViewed] = {
		additionalInfo = {
			btn = EventNames.CapturesShareToastViewed
		},
		context = Contexts.Captures,
		eventType = EventTypes.UserSeen
	},
	[EventNames.CapturesVideoShareToastViewed] = {
		additionalInfo = {
			btn = EventNames.CapturesVideoShareToastViewed
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesShowMoreInGameMenu] = {
		additionalInfo = {
			btn = EventNames.CapturesShowMoreInGameMenu
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesVideoCaptureDevApiStarted] = {
		additionalInfo = {
			btn = EventNames.CapturesVideoCaptureDevApiStarted
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesVideoCaptureDevApiEnded] = {
		additionalInfo = {
			btn = EventNames.CapturesVideoCaptureDevApiEnded
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturesViewToastButtonActivated] = {
		additionalInfo = {
			btn = EventNames.CapturesViewToastButtonActivated
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.SaveCapturesPromptVideoAccepted] = {
		additionalInfo = {
			btn = EventNames.SaveCapturesPromptVideoAccepted
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.SaveCapturesPromptVideoPrompted] = {
		additionalInfo = {
			btn = EventNames.SaveCapturesPromptVideoPrompted
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.SaveCapturesPromptVideoRejected] = {
		additionalInfo = {
			btn = EventNames.SaveCapturesPromptVideoRejected
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.SaveCapturesPromptAccepted] = {
		additionalInfo = {
			btn = EventNames.SaveCapturesPromptAccepted
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick,
		formatRulesForAdditionalInfo = {
			savedCaptures = Dash.identity,
			totalCaptures = Dash.identity
		}
	},
	[EventNames.SaveCapturesPromptRejected] = {
		additionalInfo = {
			btn = EventNames.SaveCapturesPromptRejected
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.SaveCapturesPromptViewed] = {
		additionalInfo = {
			btn = EventNames.SaveCapturesPromptViewed
		},
		context = Contexts.Captures,
		eventType = EventTypes.UserSeen
	},
	[EventNames.ShareCaptureGenerateLinkFailed] = {
		additionalInfo = {
			btn = EventNames.ShareCaptureGenerateLinkFailed
		},
		context = Contexts.Captures,
		eventType = EventTypes.GenerateLinkFailed,
		formatRulesForAdditionalInfo = {
			httpError = Dash.identity
		}
	},
	[EventNames.ShareCapturePromptAccepted] = {
		additionalInfo = {
			btn = EventNames.ShareCapturePromptAccepted
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.ShareCapturePromptRejected] = {
		additionalInfo = {
			btn = EventNames.ShareCapturePromptRejected
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.ShareCapturePromptVideoAccepted] = {
		additionalInfo = {
			btn = EventNames.ShareCapturePromptVideoAccepted
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.ShareCapturePromptVideoPrompted] = {
		additionalInfo = {
			btn = EventNames.ShareCapturePromptVideoPrompted
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.ShareCapturePromptVideoRejected] = {
		additionalInfo = {
			btn = EventNames.ShareCapturePromptVideoRejected
		},
		context = Contexts.Captures,
		eventType = EventTypes.UserSeen
	},
	[EventNames.ShareCapturePromptViewed] = {
		additionalInfo = {
			btn = EventNames.ShareCapturePromptViewed
		},
		context = Contexts.Captures,
		eventType = EventTypes.UserSeen
	},
	[EventNames.CapturePermissionsPromptAccepted] = {
		additionalInfo = {
			btn = EventNames.CapturePermissionsPromptAccepted
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturePermissionsPromptRejected] = {
		additionalInfo = {
			btn = EventNames.CapturePermissionsPromptRejected
		},
		context = Contexts.Captures,
		eventType = EventTypes.ButtonClick
	},
	[EventNames.CapturePermissionsPromptViewed] = {
		additionalInfo = {
			btn = EventNames.CapturePermissionsPromptViewed
		},
		context = Contexts.Captures,
		eventType = EventTypes.UserSeen
	}
}
