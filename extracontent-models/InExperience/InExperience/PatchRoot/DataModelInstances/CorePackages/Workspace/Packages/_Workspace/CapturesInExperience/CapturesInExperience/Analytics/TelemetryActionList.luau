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
			},
			dynamicCustomFields = {
				creationSessionId = function(p5) -- line: 209
					return p5
				end
			}
		}}
	},
	[EventNames.XExpEditingFlowGalleryItemSelected] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 220
				-- upvalues: EventTypes (copy)
				return EventTypes.ButtonClick
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpEditingFlowGalleryItemSelected
			},
			dynamicCustomFields = {
				creationSessionId = function(p6) -- line: 228
					return p6
				end
			}
		}}
	},
	[EventNames.XExpEditingFlowGalleryNoCapturesAvailable] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 239
				-- upvalues: EventTypes (copy)
				return EventTypes.UserSeen
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpEditingFlowGalleryNoCapturesAvailable
			},
			dynamicCustomFields = {
				creationSessionId = function(p7) -- line: 247
					return p7
				end
			}
		}}
	},
	[EventNames.XExpEditingFlowMusicBackButtonPressed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 258
				-- upvalues: EventTypes (copy)
				return EventTypes.ButtonClick
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpEditingFlowMusicBackButtonPressed
			},
			dynamicCustomFields = {
				creationSessionId = function(p8) -- line: 266
					return p8
				end
			}
		}}
	},
	[EventNames.XExpEditingFlowMusicButtonPressed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 277
				-- upvalues: EventTypes (copy)
				return EventTypes.ButtonClick
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpEditingFlowMusicButtonPressed
			},
			dynamicCustomFields = {
				creationSessionId = function(p9) -- line: 285
					return p9
				end
			}
		}}
	},
	[EventNames.XExpEditingFlowMusicDoneButtonPressed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 296
				-- upvalues: EventTypes (copy)
				return EventTypes.ButtonClick
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpEditingFlowMusicDoneButtonPressed
			},
			dynamicCustomFields = {
				creationSessionId = function(p10) -- line: 304
					return p10
				end
			}
		}}
	},
	[EventNames.XExpEditingFlowMusicSelected] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 315
				-- upvalues: EventTypes (copy)
				return EventTypes.ButtonClick
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpEditingFlowMusicSelected
			},
			dynamicCustomFields = {
				creationSessionId = function(p11) -- line: 323
					return p11
				end,
				musicAssetId = function(p12) -- line: 326
					return p12
				end
			}
		}}
	},
	[EventNames.XExpEditingFlowNextButtonPressed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 337
				-- upvalues: EventTypes (copy)
				return EventTypes.ButtonClick
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpEditingFlowNextButtonPressed
			},
			dynamicCustomFields = {
				creationSessionId = function(p13) -- line: 345
					return p13
				end,
				editFlowState = function(p14) -- line: 348
					return p14
				end
			}
		}}
	},
	[EventNames.XExpEditingFlowReturnButtonPressed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 359
				-- upvalues: EventTypes (copy)
				return EventTypes.ButtonClick
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpEditingFlowReturnButtonPressed
			},
			dynamicCustomFields = {
				creationSessionId = function(p15) -- line: 367
					return p15
				end,
				editFlowState = function(p16) -- line: 370
					return p16
				end
			}
		}}
	},
	[EventNames.XExpEditingFlowTextOverlayBackButtonPressed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 381
				-- upvalues: EventTypes (copy)
				return EventTypes.ButtonClick
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpEditingFlowTextOverlayBackButtonPressed
			},
			dynamicCustomFields = {
				creationSessionId = function(p17) -- line: 389
					return p17
				end
			}
		}}
	},
	[EventNames.XExpEditingFlowTextOverlayButtonPressed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 400
				-- upvalues: EventTypes (copy)
				return EventTypes.ButtonClick
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpEditingFlowTextOverlayButtonPressed
			},
			dynamicCustomFields = {
				creationSessionId = function(p18) -- line: 408
					return p18
				end
			}
		}}
	},
	[EventNames.XExpEditingFlowTextOverlayDoneButtonPressed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 419
				-- upvalues: EventTypes (copy)
				return EventTypes.ButtonClick
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpEditingFlowTextOverlayDoneButtonPressed
			},
			dynamicCustomFields = {
				creationSessionId = function(p19) -- line: 427
					return p19
				end
			}
		}}
	},
	[EventNames.XExpEditingFlowTrimBackButtonPressed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 438
				-- upvalues: EventTypes (copy)
				return EventTypes.ButtonClick
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpEditingFlowTrimBackButtonPressed
			},
			dynamicCustomFields = {
				creationSessionId = function(p20) -- line: 446
					return p20
				end
			}
		}}
	},
	[EventNames.XExpEditingFlowTrimButtonPressed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 457
				-- upvalues: EventTypes (copy)
				return EventTypes.ButtonClick
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpEditingFlowTrimButtonPressed
			},
			dynamicCustomFields = {
				creationSessionId = function(p21) -- line: 465
					return p21
				end
			}
		}}
	},
	[EventNames.XExpEditingFlowTrimDoneButtonPressed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 476
				-- upvalues: EventTypes (copy)
				return EventTypes.ButtonClick
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpEditingFlowTrimDoneButtonPressed
			},
			dynamicCustomFields = {
				creationSessionId = function(p22) -- line: 484
					return p22
				end
			}
		}}
	},
	[EventNames.XExpMomentCreationStarted] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 495
				-- upvalues: EventTypes (copy)
				return EventTypes.ButtonClick
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpMomentCreationStarted
			},
			dynamicCustomFields = {
				creationSessionId = function(p23) -- line: 503
					return p23
				end
			}
		}}
	},
	[EventNames.XExpMomentsEditingFlowContinueToDescriptionButtonPressed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 514
				-- upvalues: EventTypes (copy)
				return EventTypes.ButtonClick
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpMomentsEditingFlowContinueToDescriptionButtonPressed
			},
			dynamicCustomFields = {
				creationSessionId = function(p24) -- line: 522
					return p24
				end
			}
		}}
	},
	[EventNames.XExpMomentsEditingFlowContinueToEditButtonPressed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 533
				-- upvalues: EventTypes (copy)
				return EventTypes.ButtonClick
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpMomentsEditingFlowContinueToEditButtonPressed
			},
			dynamicCustomFields = {
				creationSessionId = function(p25) -- line: 541
					return p25
				end
			}
		}}
	},
	[EventNames.XExpMomentsEditingFlowExited] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 552
				-- upvalues: EventTypes (copy)
				return EventTypes.UserSeen
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpMomentsEditingFlowExited
			},
			dynamicCustomFields = {
				creationSessionId = function(p26) -- line: 560
					return p26
				end
			}
		}}
	},
	[EventNames.XExpMomentsEditingFlowPublished] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 571
				-- upvalues: EventTypes (copy)
				return EventTypes.UserSeen
			end,
			staticCustomFields = {
				eventContext = Contexts.Moments,
				action = EventNames.XExpMomentsEditingFlowPublished
			},
			dynamicCustomFields = {
				creationSessionId = function(p27) -- line: 579
					return p27
				end
			}
		}}
	},
	[EventNames.CapturesCreateMomentToastViewed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.EventIngest,
			overrideName = function() -- line: 590
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
			overrideName = function() -- line: 604
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
