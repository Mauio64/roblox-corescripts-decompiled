local parent = script.Parent.Parent.Parent

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local SupportedTelemetryBackends = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends
local EventTypes = SocialLuaAnalytics.Analytics.Enums.EventTypes
local Contexts = SocialLuaAnalytics.Analytics.Enums.Contexts

local EventNames = require(script.Parent.EventNames)

return {
	defaults = {
		throttlingThousandths = game:DefineFastInt("CapturesTelemetryThrottlingThousandths", 1000),
		links = ""
	},
	[EventNames.CapturesActivatedInGameMenu] = {
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.CapturesActivatedChrome] = {
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.CapturesCarouselOpened] = {
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.CapturesCarouselVideoExpanded] = {
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.CapturesCarouselVideoMuteButtonActivated] = {
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.CapturesCarouselVideoShrank] = {
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.CapturesDeactivatedInGameMenu] = {
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.CapturesDeactivatedChrome] = {
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.CapturesEntrypointActivated] = {
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					entrypointType = function(p)
						return p
					end
				}
			}
		}
	},
	[EventNames.CapturesEntrypointLatency] = {
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryStat }
		}
	},
	[EventNames.CapturesLegacyVideoRecordingDuration] = {
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryStat }
		}
	},
	[EventNames.CapturesPageOpenedInGameMenu] = {
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.CapturesShareFromNonStandardServer] = {
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.CapturesShareLatency] = {
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryStat,
				dynamicCustomFields = {
					externalShareSource = function(p)
						return p
					end
				}
			}
		}
	},
	[EventNames.CapturesShareToastButtonActivated] = {
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.CapturesVideoCaptureStarted] = {
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					triggerType = function(p)
						return p
					end
				}
			}
		}
	},
	[EventNames.CapturesVideoCaptureStopped] = {
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					triggerType = function(p)
						return p
					end
				}
			}
		}
	},
	[EventNames.ShareCaptureGenerateLinkFailed] = {
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.ShareCapturePromptAccepted] = {
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.ShareCapturePromptRejected] = {
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.CapturePermissionsPromptAccepted] = {
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.CapturePermissionsPromptRejected] = {
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.CapturePermissionsPromptViewed] = {
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.XExpEditingFlowDescriptionEdited] = {
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.Moments,
					action = EventNames.XExpEditingFlowDescriptionEdited
				},
				dynamicCustomFields = {
					creationSessionId = function(p)
						return p
					end
				}
			}
		}
	},
	[EventNames.XExpEditingFlowGalleryItemSelected] = {
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.Moments,
					action = EventNames.XExpEditingFlowGalleryItemSelected
				},
				dynamicCustomFields = {
					creationSessionId = function(p)
						return p
					end
				}
			}
		}
	},
	[EventNames.XExpEditingFlowGalleryNoCapturesAvailable] = {
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.UserSeen
				end,
				staticCustomFields = {
					eventContext = Contexts.Moments,
					action = EventNames.XExpEditingFlowGalleryNoCapturesAvailable
				},
				dynamicCustomFields = {
					creationSessionId = function(p)
						return p
					end
				}
			}
		}
	},
	[EventNames.XExpEditingFlowMusicBackButtonPressed] = {
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.Moments,
					action = EventNames.XExpEditingFlowMusicBackButtonPressed
				},
				dynamicCustomFields = {
					creationSessionId = function(p)
						return p
					end
				}
			}
		}
	},
	[EventNames.XExpEditingFlowMusicButtonPressed] = {
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.Moments,
					action = EventNames.XExpEditingFlowMusicButtonPressed
				},
				dynamicCustomFields = {
					creationSessionId = function(p)
						return p
					end
				}
			}
		}
	},
	[EventNames.XExpEditingFlowMusicDoneButtonPressed] = {
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.Moments,
					action = EventNames.XExpEditingFlowMusicDoneButtonPressed
				},
				dynamicCustomFields = {
					creationSessionId = function(p)
						return p
					end
				}
			}
		}
	},
	[EventNames.XExpEditingFlowMusicSelected] = {
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.Moments,
					action = EventNames.XExpEditingFlowMusicSelected
				},
				dynamicCustomFields = {
					creationSessionId = function(p)
						return p
					end,
					musicAssetId = function(p)
						return p
					end
				}
			}
		}
	},
	[EventNames.XExpEditingFlowNextButtonPressed] = {
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.Moments,
					action = EventNames.XExpEditingFlowNextButtonPressed
				},
				dynamicCustomFields = {
					creationSessionId = function(p)
						return p
					end,
					editFlowState = function(p)
						return p
					end
				}
			}
		}
	},
	[EventNames.XExpEditingFlowReturnButtonPressed] = {
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.Moments,
					action = EventNames.XExpEditingFlowReturnButtonPressed
				},
				dynamicCustomFields = {
					creationSessionId = function(p)
						return p
					end,
					editFlowState = function(p)
						return p
					end
				}
			}
		}
	},
	[EventNames.XExpEditingFlowTextOverlayBackButtonPressed] = {
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.Moments,
					action = EventNames.XExpEditingFlowTextOverlayBackButtonPressed
				},
				dynamicCustomFields = {
					creationSessionId = function(p)
						return p
					end
				}
			}
		}
	},
	[EventNames.XExpEditingFlowTextOverlayButtonPressed] = {
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.Moments,
					action = EventNames.XExpEditingFlowTextOverlayButtonPressed
				},
				dynamicCustomFields = {
					creationSessionId = function(p)
						return p
					end
				}
			}
		}
	},
	[EventNames.XExpEditingFlowTextOverlayDoneButtonPressed] = {
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.Moments,
					action = EventNames.XExpEditingFlowTextOverlayDoneButtonPressed
				},
				dynamicCustomFields = {
					creationSessionId = function(p)
						return p
					end
				}
			}
		}
	},
	[EventNames.XExpEditingFlowTrimBackButtonPressed] = {
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.Moments,
					action = EventNames.XExpEditingFlowTrimBackButtonPressed
				},
				dynamicCustomFields = {
					creationSessionId = function(p)
						return p
					end
				}
			}
		}
	},
	[EventNames.XExpEditingFlowTrimButtonPressed] = {
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.Moments,
					action = EventNames.XExpEditingFlowTrimButtonPressed
				},
				dynamicCustomFields = {
					creationSessionId = function(p)
						return p
					end
				}
			}
		}
	},
	[EventNames.XExpEditingFlowTrimDoneButtonPressed] = {
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.Moments,
					action = EventNames.XExpEditingFlowTrimDoneButtonPressed
				},
				dynamicCustomFields = {
					creationSessionId = function(p)
						return p
					end
				}
			}
		}
	},
	[EventNames.XExpMomentCreationStarted] = {
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.Moments,
					action = EventNames.XExpMomentCreationStarted
				},
				dynamicCustomFields = {
					creationSessionId = function(p)
						return p
					end
				}
			}
		}
	},
	[EventNames.XExpMomentsEditingFlowContinueToDescriptionButtonPressed] = {
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.Moments,
					action = EventNames.XExpMomentsEditingFlowContinueToDescriptionButtonPressed
				},
				dynamicCustomFields = {
					creationSessionId = function(p)
						return p
					end
				}
			}
		}
	},
	[EventNames.XExpMomentsEditingFlowContinueToEditButtonPressed] = {
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.Moments,
					action = EventNames.XExpMomentsEditingFlowContinueToEditButtonPressed
				},
				dynamicCustomFields = {
					creationSessionId = function(p)
						return p
					end
				}
			}
		}
	},
	[EventNames.XExpMomentsEditingFlowExited] = {
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.UserSeen
				end,
				staticCustomFields = {
					eventContext = Contexts.Moments,
					action = EventNames.XExpMomentsEditingFlowExited
				},
				dynamicCustomFields = {
					creationSessionId = function(p)
						return p
					end
				}
			}
		}
	},
	[EventNames.XExpMomentsEditingFlowPublished] = {
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.UserSeen
				end,
				staticCustomFields = {
					eventContext = Contexts.Moments,
					action = EventNames.XExpMomentsEditingFlowPublished
				},
				dynamicCustomFields = {
					creationSessionId = function(p)
						return p
					end
				}
			}
		}
	},
	[EventNames.CapturesCreateMomentToastViewed] = {
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.UserSeen
				end,
				staticCustomFields = {
					eventContext = Contexts.Captures,
					btn = EventNames.CapturesCreateMomentToastViewed
				}
			}
		}
	},
	[EventNames.CapturesCreateMomentToastButtonActivated] = {
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.Captures,
					btn = EventNames.CapturesCreateMomentToastButtonActivated
				}
			}
		}
	},
	[EventNames.CapturesCreateMomentToastDownloadActivated] = {
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.Captures,
					btn = EventNames.CapturesCreateMomentToastDownloadActivated
				}
			}
		}
	}
}
