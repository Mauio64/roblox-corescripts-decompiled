local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/SocialLuaAnalytics")
local supportedTelemetryBackends = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends
local eventTypes = SocialLuaAnalytics.Analytics.Enums.EventTypes
local contexts = SocialLuaAnalytics.Analytics.Enums.Contexts

local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Analytics/EventNames")
local ButtonNames = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Analytics/ButtonNames")
local FFlagTCLearnMoreLink = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Flags/FFlagTCLearnMoreLink")
local FFlagTFUpdateAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Flags/FFlagTFUpdateAnalytics")

return {
	defaults = {
		throttlingThousandths = game:DefineFastInt("TrustedContactsAnalyticsThrottlingThousandths", 10000),
		links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/social/trusted_connections.proto"
	},
	[EventNames.FriendsRenameInfoModalSeen] = {
		description = "Friends rename info modal mounted",
		lastUpdated = { 25, 6, 4 },
		backendsList = {
			{
				type = supportedTelemetryBackends.EventIngest,
				overrideName = function()
					return eventTypes.UserSeen
				end,
				staticCustomFields = { eventContext = contexts.FriendsRenameInfoModal }
			},
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.TCUpsellModalSeen] = {
		description = "TC Upsell modal mounted",
		lastUpdated = { 25, 6, 4 },
		backendsList = {
			{
				type = supportedTelemetryBackends.EventIngest,
				overrideName = function()
					return eventTypes.UserSeen
				end,
				staticCustomFields = { eventContext = contexts.TCUpsellModal },
				dynamicCustomFields = {
					modalVariant = function(p2)
						return p2
					end,
					source = function(p2)
						return p2
					end
				}
			},
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					modalVariant = function(p2)
						return p2
					end,
					source = function(p2)
						return p2
					end
				}
			}
		}
	},
	[EventNames.TCEducationModalSeen] = {
		description = "TC Education modal mounted",
		lastUpdated = { 25, 6, 4 },
		backendsList = {
			{
				type = supportedTelemetryBackends.EventIngest,
				overrideName = function()
					return eventTypes.UserSeen
				end,
				staticCustomFields = { eventContext = contexts.TCEducationModal }
			},
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.FriendsRenameLearnMoreClicked] = {
		description = "Friends rename info modal learn more text clicked",
		lastUpdated = { 25, 6, 4 },
		backendsList = {
			{
				type = supportedTelemetryBackends.EventIngest,
				overrideName = function()
					return eventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = contexts.FriendsRenameInfoModal,
					btn = ButtonNames.LearnMore
				}
			},
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.TrustedFriendsModalOkClicked] = {
		description = "Trusted friends info modal ok button clicked",
		lastUpdated = { 26, 3, 20 },
		backendsList = {
			{
				type = supportedTelemetryBackends.EventIngest,
				overrideName = function()
					return eventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = contexts.TCUpsellModal,
					btn = ButtonNames.Ok
				}
			},
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.TCUpsellCloseClicked] = {
		description = "TC Upsell modal close button clicked",
		lastUpdated = { 25, 6, 4 },
		backendsList = {
			{
				type = supportedTelemetryBackends.EventIngest,
				overrideName = function()
					return eventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = contexts.TCUpsellModal,
					btn = ButtonNames.Close
				},
				dynamicCustomFields = {
					modalVariant = function(p2)
						return p2
					end,
					source = function(p2)
						return p2
					end
				}
			},
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					modalVariant = function(p2)
						return p2
					end,
					source = function(p2)
						return p2
					end
				}
			}
		}
	},
	[EventNames.TCUpsellAcceptTrustedConnectionClicked] = {
		description = "TC Upsell modal accept trusted connection button clicked",
		lastUpdated = { 25, 9, 17 },
		backendsList = {
			{
				type = supportedTelemetryBackends.EventIngest,
				overrideName = function()
					return eventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = contexts.TCUpsellModal,
					btn = ButtonNames.AcceptTrustedConnection
				}
			},
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.TCUpsellAddTrustedConnectionClicked] = {
		description = "TC Upsell modal add trusted connection button clicked",
		lastUpdated = { 25, 9, 17 },
		backendsList = {
			{
				type = supportedTelemetryBackends.EventIngest,
				overrideName = function()
					return eventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = contexts.TCUpsellModal,
					btn = ButtonNames.AddTrustedConnection
				}
			},
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.TCEducationGotItClicked] = {
		description = "TC Education modal got it button clicked",
		lastUpdated = { 25, 6, 4 },
		backendsList = {
			{
				type = supportedTelemetryBackends.EventIngest,
				overrideName = function()
					return eventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = contexts.TCEducationModal,
					btn = ButtonNames.GotIt
				}
			},
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.TCEducationCloseClicked] = {
		description = "TC Education modal close button clicked",
		lastUpdated = { 25, 6, 4 },
		backendsList = {
			{
				type = supportedTelemetryBackends.EventIngest,
				overrideName = function()
					return eventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = contexts.TCEducationModal,
					btn = ButtonNames.Close
				}
			},
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.TCUpsellCancelClicked] = {
		description = "TC Upsell modal cancel button clicked",
		lastUpdated = { 25, 9, 17 },
		backendsList = {
			{
				type = supportedTelemetryBackends.EventIngest,
				overrideName = function()
					return eventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = contexts.TCUpsellModal,
					btn = ButtonNames.Cancel
				},
				dynamicCustomFields = {
					modalVariant = function(p2)
						return p2
					end,
					source = function(p2)
						return p2
					end
				}
			},
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					modalVariant = function(p2)
						return p2
					end,
					source = function(p2)
						return p2
					end
				}
			}
		}
	},
	[EventNames.TCUpsellAddViaLinkClicked] = {
		description = "TC Upsell modal 'Add via link' button clicked",
		lastUpdated = { 26, 1, 28 },
		backendsList = {
			{
				type = supportedTelemetryBackends.EventIngest,
				overrideName = function()
					return eventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = contexts.TCUpsellModal,
					btn = ButtonNames.AddViaLink
				},
				dynamicCustomFields = {
					modalVariant = function(p2)
						return p2
					end,
					source = function(p2)
						return p2
					end
				}
			},
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					modalVariant = function(p2)
						return p2
					end,
					source = function(p2)
						return p2
					end
				}
			}
		}
	},
	[EventNames.TrustedFriendsVPCPrologueOpened] = {
		description = "Trusted Friends VPC Prologue open button clicked in TC modal",
		lastUpdated = { 26, 2, 26 },
		backendsList = {
			{
				type = supportedTelemetryBackends.EventIngest,
				overrideName = function()
					return eventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = contexts.TCUpsellModal,
					btn = ButtonNames.OpenVPCPrologue
				},
				dynamicCustomFields = {
					modalVariant = function(p2)
						return p2
					end,
					source = function(p2)
						return p2
					end
				}
			},
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					modalVariant = function(p2)
						return p2
					end,
					source = function(p2)
						return p2
					end
				}
			}
		}
	},
	[EventNames.TrustedFriendsVPCAskClicked] = {
		description = "Trusted Friends VPC Prologue Ask button clicked",
		lastUpdated = { 26, 2, 26 },
		backendsList = {
			{
				type = supportedTelemetryBackends.EventIngest,
				overrideName = function()
					return eventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = contexts.TrustedFriendsVPCPrologue,
					btn = ButtonNames.Ask
				}
			},
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.TrustedFriendsVPCCancelClicked] = {
		description = "Trusted Friends VPC Prologue Cancel button clicked",
		lastUpdated = { 26, 2, 26 },
		backendsList = {
			{
				type = supportedTelemetryBackends.EventIngest,
				overrideName = function()
					return eventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = contexts.TrustedFriendsVPCPrologue,
					btn = ButtonNames.Cancel
				}
			},
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.TCEducationManageConnectionsClicked] = {
		description = "TC Education modal manage connections button clicked",
		lastUpdated = { 25, 6, 4 },
		backendsList = {
			{
				type = supportedTelemetryBackends.EventIngest,
				overrideName = function()
					return eventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = contexts.TCEducationModal,
					btn = ButtonNames.ManageConnections
				}
			},
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.TCStreamNotificationAcceptClicked] = {
		description = "TC stream notification accept CTA clicked",
		lastUpdated = { 26, 1, 16 },
		backendsList = {
			{
				type = supportedTelemetryBackends.EventIngest,
				overrideName = function()
					return eventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = contexts.StreamNotification,
					btn = ButtonNames.AcceptTrustedConnection
				}
			},
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.TCToastNotificationAcceptClicked] = {
		description = "TC toast notification accept CTA clicked",
		lastUpdated = { 26, 1, 16 },
		backendsList = {
			{
				type = supportedTelemetryBackends.EventIngest,
				overrideName = function()
					return eventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = contexts.ToastNotification,
					btn = ButtonNames.AcceptTrustedConnection
				}
			},
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.TCUpsellIsATrustedConnectionNowToastShown] = FFlagTFUpdateAnalytics and {
		description = "TC Upsell modal 'is a trusted connection now' success toast shown",
		lastUpdated = { 26, 6, 5 },
		backendsList = {
			{
				type = supportedTelemetryBackends.EventIngest,
				overrideName = function()
					return eventTypes.UserSeen
				end,
				staticCustomFields = { eventContext = contexts.TCUpsellModal },
				dynamicCustomFields = {
					modalVariant = function(p2)
						return p2
					end,
					source = function(p2)
						return p2
					end
				}
			},
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					modalVariant = function(p2)
						return p2
					end,
					source = function(p2)
						return p2
					end
				}
			}
		}
	} or nil,
	[EventNames.TCUpsellInvalidTrustedFriendState] = FFlagTFUpdateAnalytics and {
		description = "TC Upsell modal encountered an invalid trusted friend state",
		lastUpdated = { 26, 6, 5 },
		backendsList = {
			{
				type = supportedTelemetryBackends.EventIngest,
				overrideName = function()
					return eventTypes.UserSeen
				end,
				staticCustomFields = { eventContext = contexts.TCUpsellModal },
				dynamicCustomFields = {
					modalVariant = function(p2)
						return p2
					end,
					source = function(p2)
						return p2
					end,
					tfActionsEnum = function(p2)
						return p2
					end
				}
			},
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					modalVariant = function(p2)
						return p2
					end,
					source = function(p2)
						return p2
					end,
					tfActionsEnum = function(p2)
						return p2
					end
				}
			}
		}
	} or nil,
	[EventNames.TCUpsellAgePrecheckTriggered] = FFlagTFUpdateAnalytics and {
		description = "TC Upsell facial age estimation precheck triggered",
		lastUpdated = { 26, 6, 5 },
		backendsList = {
			{
				type = supportedTelemetryBackends.EventIngest,
				overrideName = function()
					return eventTypes.UserSeen
				end,
				staticCustomFields = { eventContext = contexts.TCUpsellModal },
				dynamicCustomFields = {
					source = function(p2)
						return p2
					end,
					tfActionsEnum = function(p2)
						return p2
					end
				}
			},
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					source = function(p2)
						return p2
					end,
					tfActionsEnum = function(p2)
						return p2
					end
				}
			}
		}
	} or nil,
	[EventNames.TCUpsellAgePrecheckSucceeded] = FFlagTFUpdateAnalytics and {
		description = "TC Upsell facial age estimation precheck succeeded",
		lastUpdated = { 26, 6, 5 },
		backendsList = {
			{
				type = supportedTelemetryBackends.EventIngest,
				overrideName = function()
					return eventTypes.UserSeen
				end,
				staticCustomFields = { eventContext = contexts.TCUpsellModal },
				dynamicCustomFields = {
					source = function(p2)
						return p2
					end,
					tfActionsEnum = function(p2)
						return p2
					end
				}
			},
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					source = function(p2)
						return p2
					end,
					tfActionsEnum = function(p2)
						return p2
					end
				}
			}
		}
	} or nil,
	[EventNames.TCUpsellAgePrecheckFailed] = FFlagTFUpdateAnalytics and {
		description = "TC Upsell facial age estimation precheck failed",
		lastUpdated = { 26, 6, 5 },
		backendsList = {
			{
				type = supportedTelemetryBackends.EventIngest,
				overrideName = function()
					return eventTypes.UserSeen
				end,
				staticCustomFields = { eventContext = contexts.TCUpsellModal },
				dynamicCustomFields = {
					source = function(p2)
						return p2
					end,
					tfActionsEnum = function(p2)
						return p2
					end
				}
			},
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					source = function(p2)
						return p2
					end,
					tfActionsEnum = function(p2)
						return p2
					end
				}
			}
		}
	} or nil,
	[EventNames.TCUpsellLearnMoreClicked] = FFlagTCLearnMoreLink and {
		description = "Learn more link clicked",
		lastUpdated = { 12, 3, 26 },
		backendsList = {
			{
				type = supportedTelemetryBackends.EventIngest,
				overrideName = function()
					return eventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = contexts.TCUpsellModal,
					btn = "LearnMoreLink"
				}
			},
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	} or nil
}
