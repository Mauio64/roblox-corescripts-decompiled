local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local parent = TrustedContacts.Parent

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local SupportedTelemetryBackends = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends
local EventTypes = SocialLuaAnalytics.Analytics.Enums.EventTypes
local Contexts = SocialLuaAnalytics.Analytics.Enums.Contexts

local EventNames = require(script.Parent.EventNames)
local ButtonNames = require(script.Parent.ButtonNames)
local FFlagTCLearnMoreLink = require(TrustedContacts.Flags.FFlagTCLearnMoreLink)
local FFlagTFUpdateAnalytics = require(TrustedContacts.Flags.FFlagTFUpdateAnalytics)

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
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.UserSeen
				end,
				staticCustomFields = { eventContext = Contexts.FriendsRenameInfoModal }
			},
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.TCUpsellModalSeen] = {
		description = "TC Upsell modal mounted",
		lastUpdated = { 25, 6, 4 },
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.UserSeen
				end,
				staticCustomFields = { eventContext = Contexts.TCUpsellModal },
				dynamicCustomFields = {
					modalVariant = function(p)
						return p
					end,
					source = function(p)
						return p
					end
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					modalVariant = function(p)
						return p
					end,
					source = function(p)
						return p
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
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.UserSeen
				end,
				staticCustomFields = { eventContext = Contexts.TCEducationModal }
			},
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.FriendsRenameLearnMoreClicked] = {
		description = "Friends rename info modal learn more text clicked",
		lastUpdated = { 25, 6, 4 },
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.FriendsRenameInfoModal,
					btn = ButtonNames.LearnMore
				}
			},
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.TrustedFriendsModalOkClicked] = {
		description = "Trusted friends info modal ok button clicked",
		lastUpdated = { 26, 3, 20 },
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = { eventContext = Contexts.TCUpsellModal, btn = ButtonNames.Ok }
			},
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.TCUpsellCloseClicked] = {
		description = "TC Upsell modal close button clicked",
		lastUpdated = { 25, 6, 4 },
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.TCUpsellModal,
					btn = ButtonNames.Close
				},
				dynamicCustomFields = {
					modalVariant = function(p)
						return p
					end,
					source = function(p)
						return p
					end
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					modalVariant = function(p)
						return p
					end,
					source = function(p)
						return p
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
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.TCUpsellModal,
					btn = ButtonNames.AcceptTrustedConnection
				}
			},
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.TCUpsellAddTrustedConnectionClicked] = {
		description = "TC Upsell modal add trusted connection button clicked",
		lastUpdated = { 25, 9, 17 },
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.TCUpsellModal,
					btn = ButtonNames.AddTrustedConnection
				}
			},
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.TCEducationGotItClicked] = {
		description = "TC Education modal got it button clicked",
		lastUpdated = { 25, 6, 4 },
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.TCEducationModal,
					btn = ButtonNames.GotIt
				}
			},
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.TCEducationCloseClicked] = {
		description = "TC Education modal close button clicked",
		lastUpdated = { 25, 6, 4 },
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.TCEducationModal,
					btn = ButtonNames.Close
				}
			},
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.TCUpsellCancelClicked] = {
		description = "TC Upsell modal cancel button clicked",
		lastUpdated = { 25, 9, 17 },
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.TCUpsellModal,
					btn = ButtonNames.Cancel
				},
				dynamicCustomFields = {
					modalVariant = function(p)
						return p
					end,
					source = function(p)
						return p
					end
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					modalVariant = function(p)
						return p
					end,
					source = function(p)
						return p
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
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.TCUpsellModal,
					btn = ButtonNames.AddViaLink
				},
				dynamicCustomFields = {
					modalVariant = function(p)
						return p
					end,
					source = function(p)
						return p
					end
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					modalVariant = function(p)
						return p
					end,
					source = function(p)
						return p
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
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.TCUpsellModal,
					btn = ButtonNames.OpenVPCPrologue
				},
				dynamicCustomFields = {
					modalVariant = function(p)
						return p
					end,
					source = function(p)
						return p
					end
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					modalVariant = function(p)
						return p
					end,
					source = function(p)
						return p
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
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.TrustedFriendsVPCPrologue,
					btn = ButtonNames.Ask
				}
			},
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.TrustedFriendsVPCCancelClicked] = {
		description = "Trusted Friends VPC Prologue Cancel button clicked",
		lastUpdated = { 26, 2, 26 },
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.TrustedFriendsVPCPrologue,
					btn = ButtonNames.Cancel
				}
			},
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.TCEducationManageConnectionsClicked] = {
		description = "TC Education modal manage connections button clicked",
		lastUpdated = { 25, 6, 4 },
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.TCEducationModal,
					btn = ButtonNames.ManageConnections
				}
			},
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.TCStreamNotificationAcceptClicked] = {
		description = "TC stream notification accept CTA clicked",
		lastUpdated = { 26, 1, 16 },
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.StreamNotification,
					btn = ButtonNames.AcceptTrustedConnection
				}
			},
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.TCToastNotificationAcceptClicked] = {
		description = "TC toast notification accept CTA clicked",
		lastUpdated = { 26, 1, 16 },
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.ToastNotification,
					btn = ButtonNames.AcceptTrustedConnection
				}
			},
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.TCUpsellIsATrustedConnectionNowToastShown] = FFlagTFUpdateAnalytics and {
		description = "TC Upsell modal 'is a trusted connection now' success toast shown",
		lastUpdated = { 26, 6, 5 },
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.UserSeen
				end,
				staticCustomFields = { eventContext = Contexts.TCUpsellModal },
				dynamicCustomFields = {
					modalVariant = function(p)
						return p
					end,
					source = function(p)
						return p
					end
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					modalVariant = function(p)
						return p
					end,
					source = function(p)
						return p
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
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.UserSeen
				end,
				staticCustomFields = { eventContext = Contexts.TCUpsellModal },
				dynamicCustomFields = {
					modalVariant = function(p)
						return p
					end,
					source = function(p)
						return p
					end,
					tfActionsEnum = function(p)
						return p
					end
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					modalVariant = function(p)
						return p
					end,
					source = function(p)
						return p
					end,
					tfActionsEnum = function(p)
						return p
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
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.UserSeen
				end,
				staticCustomFields = { eventContext = Contexts.TCUpsellModal },
				dynamicCustomFields = {
					source = function(p)
						return p
					end,
					tfActionsEnum = function(p)
						return p
					end
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					source = function(p)
						return p
					end,
					tfActionsEnum = function(p)
						return p
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
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.UserSeen
				end,
				staticCustomFields = { eventContext = Contexts.TCUpsellModal },
				dynamicCustomFields = {
					source = function(p)
						return p
					end,
					tfActionsEnum = function(p)
						return p
					end
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					source = function(p)
						return p
					end,
					tfActionsEnum = function(p)
						return p
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
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.UserSeen
				end,
				staticCustomFields = { eventContext = Contexts.TCUpsellModal },
				dynamicCustomFields = {
					source = function(p)
						return p
					end,
					tfActionsEnum = function(p)
						return p
					end
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					source = function(p)
						return p
					end,
					tfActionsEnum = function(p)
						return p
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
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.TCUpsellModal,
					btn = "LearnMoreLink"
				}
			},
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	} or nil
}
