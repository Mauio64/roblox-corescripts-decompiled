local ParentParent = script.Parent.Parent.Parent
local SocialLuaAnalytics = require(ParentParent.SocialLuaAnalytics)
local SupportedTelemetryBackends = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends
local EventTypes = SocialLuaAnalytics.Analytics.Enums.EventTypes
local Contexts = SocialLuaAnalytics.Analytics.Enums.Contexts
local EventNames = require(script.Parent.EventNames)

return {
	defaults = {
		links = "",
		throttlingThousandths = game:DefineFastInt("CapturesTelemetryThrottlingThousandths", 1000)
	},
	[EventNames.CapturesActivatedInGameMenu] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.CapturesActivatedChrome] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.CapturesCarouselOpened] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.CapturesCarouselVideoExpanded] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.CapturesCarouselVideoMuteButtonActivated] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.CapturesCarouselVideoShrank] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.CapturesDeactivatedInGameMenu] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.CapturesDeactivatedChrome] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.CapturesEntrypointActivated] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter,
			dynamicCustomFields = {
				entrypointType = function(p1) -- line: 77
					return p1
				end
			}
		}}
	},
	[EventNames.CapturesEntrypointLatency] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryStat
		}}
	},
	[EventNames.CapturesLegacyVideoRecordingDuration] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryStat
		}}
	},
	[EventNames.CapturesPageOpenedInGameMenu] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.CapturesShareFromNonStandardServer] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.CapturesShareLatency] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryStat,
			dynamicCustomFields = {
				externalShareSource = function(p2) -- line: 117
					return p2
				end
			}
		}}
	},
	[EventNames.CapturesShareToastButtonActivated] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.CapturesVideoCaptureStarted] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter,
			dynamicCustomFields = {
				triggerType = function(p3) -- line: 136
					return p3
				end
			}
		}}
	},
	[EventNames.CapturesVideoCaptureStopped] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter,
			dynamicCustomFields = {
				triggerType = function(p4) -- line: 148
					return p4
				end
			}
		}}
	},
	[EventNames.ShareCaptureGenerateLinkFailed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.ShareCapturePromptAccepted] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.ShareCapturePromptRejected] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.CapturePermissionsPromptAccepted] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.CapturePermissionsPromptRejected] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.CapturePermissionsPromptViewed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.XExpEditingFlowDescriptionEdited] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 201
				-- upvalues: EventTypes (copy)
				return EventTypes.ButtonClick
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpEditingFlowDescriptionEdited
			}
		}}
	},
	[EventNames.XExpEditingFlowGalleryItemSelected] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 215
				-- upvalues: EventTypes (copy)
				return EventTypes.ButtonClick
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpEditingFlowGalleryItemSelected
			}
		}}
	},
	[EventNames.XExpEditingFlowGalleryNoCapturesAvailable] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 229
				-- upvalues: EventTypes (copy)
				return EventTypes.UserSeen
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpEditingFlowGalleryNoCapturesAvailable
			}
		}}
	},
	[EventNames.XExpEditingFlowMusicBackButtonPressed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 243
				-- upvalues: EventTypes (copy)
				return EventTypes.ButtonClick
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpEditingFlowMusicBackButtonPressed
			}
		}}
	},
	[EventNames.XExpEditingFlowMusicButtonPressed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 257
				-- upvalues: EventTypes (copy)
				return EventTypes.ButtonClick
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpEditingFlowMusicButtonPressed
			}
		}}
	},
	[EventNames.XExpEditingFlowMusicDoneButtonPressed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 271
				-- upvalues: EventTypes (copy)
				return EventTypes.ButtonClick
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpEditingFlowMusicDoneButtonPressed
			}
		}}
	},
	[EventNames.XExpEditingFlowMusicSelected] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 285
				-- upvalues: EventTypes (copy)
				return EventTypes.ButtonClick
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpEditingFlowMusicSelected
			},
			dynamicCustomFields = {
				musicAssetId = function(p5) -- line: 293
					return p5.musicAssetId
				end
			}
		}}
	},
	[EventNames.XExpEditingFlowNextButtonPressed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 304
				-- upvalues: EventTypes (copy)
				return EventTypes.ButtonClick
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpEditingFlowNextButtonPressed
			},
			dynamicCustomFields = {
				editFlowState = function(p6) -- line: 312
					return p6.editFlowState
				end
			}
		}}
	},
	[EventNames.XExpEditingFlowReturnButtonPressed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 323
				-- upvalues: EventTypes (copy)
				return EventTypes.ButtonClick
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpEditingFlowReturnButtonPressed
			},
			dynamicCustomFields = {
				editFlowState = function(p7) -- line: 331
					return p7.editFlowState
				end
			}
		}}
	},
	[EventNames.XExpEditingFlowTextOverlayBackButtonPressed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 342
				-- upvalues: EventTypes (copy)
				return EventTypes.ButtonClick
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpEditingFlowTextOverlayBackButtonPressed
			}
		}}
	},
	[EventNames.XExpEditingFlowTextOverlayButtonPressed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 356
				-- upvalues: EventTypes (copy)
				return EventTypes.ButtonClick
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpEditingFlowTextOverlayButtonPressed
			}
		}}
	},
	[EventNames.XExpEditingFlowTextOverlayDoneButtonPressed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 370
				-- upvalues: EventTypes (copy)
				return EventTypes.ButtonClick
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpEditingFlowTextOverlayDoneButtonPressed
			}
		}}
	},
	[EventNames.XExpEditingFlowTrimBackButtonPressed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 384
				-- upvalues: EventTypes (copy)
				return EventTypes.ButtonClick
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpEditingFlowTrimBackButtonPressed
			}
		}}
	},
	[EventNames.XExpEditingFlowTrimButtonPressed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 398
				-- upvalues: EventTypes (copy)
				return EventTypes.ButtonClick
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpEditingFlowTrimButtonPressed
			}
		}}
	},
	[EventNames.XExpEditingFlowTrimDoneButtonPressed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 412
				-- upvalues: EventTypes (copy)
				return EventTypes.ButtonClick
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpEditingFlowTrimDoneButtonPressed
			}
		}}
	},
	[EventNames.XExpMomentsEditingFlowContinueToDescriptionButtonPressed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 426
				-- upvalues: EventTypes (copy)
				return EventTypes.ButtonClick
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpMomentsEditingFlowContinueToDescriptionButtonPressed
			}
		}}
	},
	[EventNames.XExpMomentsEditingFlowContinueToEditButtonPressed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 440
				-- upvalues: EventTypes (copy)
				return EventTypes.ButtonClick
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpMomentsEditingFlowContinueToEditButtonPressed
			}
		}}
	},
	[EventNames.XExpMomentsEditingFlowExited] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 454
				-- upvalues: EventTypes (copy)
				return EventTypes.UserSeen
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpMomentsEditingFlowExited
			}
		}}
	},
	[EventNames.XExpMomentsEditingFlowPublished] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 468
				-- upvalues: EventTypes (copy)
				return EventTypes.UserSeen
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpMomentsEditingFlowPublished
			}
		}}
	},
	[EventNames.CapturesCreateMomentToastViewed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 482
				-- upvalues: EventTypes (copy)
				return EventTypes.UserSeen
			end,
			staticCustomFields = {
				eventContext = Contexts.Captures,
				btn = EventNames.CapturesCreateMomentToastViewed
			}
		}}
	},
	[EventNames.CapturesCreateMomentToastButtonActivated] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 496
				-- upvalues: EventTypes (copy)
				return EventTypes.ButtonClick
			end,
			staticCustomFields = {
				eventContext = Contexts.Captures,
				btn = EventNames.CapturesCreateMomentToastButtonActivated
			}
		}}
	}
}
