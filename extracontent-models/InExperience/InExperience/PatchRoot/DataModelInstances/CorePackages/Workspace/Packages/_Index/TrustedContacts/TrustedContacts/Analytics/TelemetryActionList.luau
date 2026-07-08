local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local TrustedContactsParent = TrustedContacts.Parent
local SocialLuaAnalytics = require(TrustedContactsParent.SocialLuaAnalytics)
local SupportedTelemetryBackends = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends
local EventTypes = SocialLuaAnalytics.Analytics.Enums.EventTypes
local Contexts = SocialLuaAnalytics.Analytics.Enums.Contexts
local EventNames = require(script.Parent.EventNames)
local ButtonNames = require(script.Parent.ButtonNames)
local FFlagTCStreamNotifEventReceiver = require(TrustedContactsParent.SharedFlags).FFlagTCStreamNotifEventReceiver
local FFlagTCLearnMoreLink = require(TrustedContacts.Flags.FFlagTCLearnMoreLink)
local FFlagTFUpdateAnalytics = require(TrustedContacts.Flags.FFlagTFUpdateAnalytics)

return {
	defaults = {
		links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/social/trusted_connections.proto",
		throttlingThousandths = game:DefineFastInt("TrustedContactsAnalyticsThrottlingThousandths", 10000)
	},
	[EventNames.FriendsRenameInfoModalSeen] = {
		description = "Friends rename info modal mounted",
		lastUpdated = {
			25,
			6,
			4
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function() -- line: 27
					-- upvalues: EventTypes (copy)
					return EventTypes.UserSeen
				end,
				staticCustomFields = {
					eventContext = Contexts.FriendsRenameInfoModal
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter
			}
		}
	},
	[EventNames.TCUpsellModalSeen] = {
		description = "TC Upsell modal mounted",
		lastUpdated = {
			25,
			6,
			4
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function() -- line: 45
					-- upvalues: EventTypes (copy)
					return EventTypes.UserSeen
				end,
				staticCustomFields = {
					eventContext = Contexts.TCUpsellModal
				},
				dynamicCustomFields = {
					modalVariant = function(p1) -- line: 52
						return p1
					end,
					source = function(p2) -- line: 55
						return p2
					end
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					modalVariant = function(p3) -- line: 63
						return p3
					end,
					source = function(p4) -- line: 66
						return p4
					end
				}
			}
		}
	},
	[EventNames.TCEducationModalSeen] = {
		description = "TC Education modal mounted",
		lastUpdated = {
			25,
			6,
			4
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function() -- line: 79
					-- upvalues: EventTypes (copy)
					return EventTypes.UserSeen
				end,
				staticCustomFields = {
					eventContext = Contexts.TCEducationModal
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter
			}
		}
	},
	[EventNames.FriendsRenameLearnMoreClicked] = {
		description = "Friends rename info modal learn more text clicked",
		lastUpdated = {
			25,
			6,
			4
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function() -- line: 97
					-- upvalues: EventTypes (copy)
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.FriendsRenameInfoModal,
					btn = ButtonNames.LearnMore
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter
			}
		}
	},
	[EventNames.TrustedFriendsModalOkClicked] = {
		description = "Trusted friends info modal ok button clicked",
		lastUpdated = {
			26,
			3,
			20
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function() -- line: 116
					-- upvalues: EventTypes (copy)
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.TCUpsellModal,
					btn = ButtonNames.Ok
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter
			}
		}
	},
	[EventNames.TCUpsellCloseClicked] = {
		description = "TC Upsell modal close button clicked",
		lastUpdated = {
			25,
			6,
			4
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function() -- line: 135
					-- upvalues: EventTypes (copy)
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.TCUpsellModal,
					btn = ButtonNames.Close
				},
				dynamicCustomFields = {
					modalVariant = function(p5) -- line: 143
						return p5
					end,
					source = function(p6) -- line: 146
						return p6
					end
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					modalVariant = function(p7) -- line: 154
						return p7
					end,
					source = function(p8) -- line: 157
						return p8
					end
				}
			}
		}
	},
	[EventNames.TCUpsellAcceptTrustedConnectionClicked] = {
		description = "TC Upsell modal accept trusted connection button clicked",
		lastUpdated = {
			25,
			9,
			17
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function() -- line: 170
					-- upvalues: EventTypes (copy)
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.TCUpsellModal,
					btn = ButtonNames.AcceptTrustedConnection
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter
			}
		}
	},
	[EventNames.TCUpsellAddTrustedConnectionClicked] = {
		description = "TC Upsell modal add trusted connection button clicked",
		lastUpdated = {
			25,
			9,
			17
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function() -- line: 189
					-- upvalues: EventTypes (copy)
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.TCUpsellModal,
					btn = ButtonNames.AddTrustedConnection
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter
			}
		}
	},
	[EventNames.TCEducationGotItClicked] = {
		description = "TC Education modal got it button clicked",
		lastUpdated = {
			25,
			6,
			4
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function() -- line: 208
					-- upvalues: EventTypes (copy)
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.TCEducationModal,
					btn = ButtonNames.GotIt
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter
			}
		}
	},
	[EventNames.TCEducationCloseClicked] = {
		description = "TC Education modal close button clicked",
		lastUpdated = {
			25,
			6,
			4
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function() -- line: 227
					-- upvalues: EventTypes (copy)
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.TCEducationModal,
					btn = ButtonNames.Close
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter
			}
		}
	},
	[EventNames.TCUpsellCancelClicked] = {
		description = "TC Upsell modal cancel button clicked",
		lastUpdated = {
			25,
			9,
			17
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function() -- line: 246
					-- upvalues: EventTypes (copy)
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.TCUpsellModal,
					btn = ButtonNames.Cancel
				},
				dynamicCustomFields = {
					modalVariant = function(p9) -- line: 254
						return p9
					end,
					source = function(p10) -- line: 257
						return p10
					end
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					modalVariant = function(p11) -- line: 265
						return p11
					end,
					source = function(p12) -- line: 268
						return p12
					end
				}
			}
		}
	},
	[EventNames.TCUpsellAddViaLinkClicked] = {
		description = "TC Upsell modal 'Add via link' button clicked",
		lastUpdated = {
			26,
			1,
			28
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function() -- line: 281
					-- upvalues: EventTypes (copy)
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.TCUpsellModal,
					btn = ButtonNames.AddViaLink
				},
				dynamicCustomFields = {
					modalVariant = function(p13) -- line: 289
						return p13
					end,
					source = function(p14) -- line: 292
						return p14
					end
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					modalVariant = function(p15) -- line: 300
						return p15
					end,
					source = function(p16) -- line: 303
						return p16
					end
				}
			}
		}
	},
	[EventNames.TrustedFriendsVPCPrologueOpened] = {
		description = "Trusted Friends VPC Prologue open button clicked in TC modal",
		lastUpdated = {
			26,
			2,
			26
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function() -- line: 316
					-- upvalues: EventTypes (copy)
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.TCUpsellModal,
					btn = ButtonNames.OpenVPCPrologue
				},
				dynamicCustomFields = {
					modalVariant = function(p17) -- line: 324
						return p17
					end,
					source = function(p18) -- line: 327
						return p18
					end
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					modalVariant = function(p19) -- line: 335
						return p19
					end,
					source = function(p20) -- line: 338
						return p20
					end
				}
			}
		}
	},
	[EventNames.TrustedFriendsVPCAskClicked] = {
		description = "Trusted Friends VPC Prologue Ask button clicked",
		lastUpdated = {
			26,
			2,
			26
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function() -- line: 351
					-- upvalues: EventTypes (copy)
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.TrustedFriendsVPCPrologue,
					btn = ButtonNames.Ask
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter
			}
		}
	},
	[EventNames.TrustedFriendsVPCCancelClicked] = {
		description = "Trusted Friends VPC Prologue Cancel button clicked",
		lastUpdated = {
			26,
			2,
			26
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function() -- line: 370
					-- upvalues: EventTypes (copy)
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.TrustedFriendsVPCPrologue,
					btn = ButtonNames.Cancel
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter
			}
		}
	},
	[EventNames.TCEducationManageConnectionsClicked] = {
		description = "TC Education modal manage connections button clicked",
		lastUpdated = {
			25,
			6,
			4
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function() -- line: 389
					-- upvalues: EventTypes (copy)
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.TCEducationModal,
					btn = ButtonNames.ManageConnections
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter
			}
		}
	},
	[EventNames.TCStreamNotificationAcceptClicked] = if not FFlagTCStreamNotifEventReceiver then nil else {
		description = "TC stream notification accept CTA clicked",
		lastUpdated = {
			26,
			1,
			16
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function() -- line: 409
					-- upvalues: EventTypes (copy)
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.StreamNotification,
					btn = ButtonNames.AcceptTrustedConnection
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter
			}
		}
	},
	[EventNames.TCToastNotificationAcceptClicked] = {
		description = "TC toast notification accept CTA clicked",
		lastUpdated = {
			26,
			1,
			16
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function() -- line: 429
					-- upvalues: EventTypes (copy)
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.ToastNotification,
					btn = ButtonNames.AcceptTrustedConnection
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter
			}
		}
	},
	[EventNames.TCUpsellIsATrustedConnectionNowToastShown] = if not FFlagTFUpdateAnalytics then nil else {
		description = "TC Upsell modal 'is a trusted connection now' success toast shown",
		lastUpdated = {
			26,
			6,
			5
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function() -- line: 449
					-- upvalues: EventTypes (copy)
					return EventTypes.UserSeen
				end,
				staticCustomFields = {
					eventContext = Contexts.TCUpsellModal
				},
				dynamicCustomFields = {
					modalVariant = function(p21) -- line: 456
						return p21
					end,
					source = function(p22) -- line: 459
						return p22
					end
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					modalVariant = function(p23) -- line: 467
						return p23
					end,
					source = function(p24) -- line: 470
						return p24
					end
				}
			}
		}
	},
	[EventNames.TCUpsellInvalidTrustedFriendState] = if not FFlagTFUpdateAnalytics then nil else {
		description = "TC Upsell modal encountered an invalid trusted friend state",
		lastUpdated = {
			26,
			6,
			5
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function() -- line: 485
					-- upvalues: EventTypes (copy)
					return EventTypes.UserSeen
				end,
				staticCustomFields = {
					eventContext = Contexts.TCUpsellModal
				},
				dynamicCustomFields = {
					modalVariant = function(p25) -- line: 492
						return p25
					end,
					source = function(p26) -- line: 495
						return p26
					end,
					tfActionsEnum = function(p27) -- line: 498
						return p27
					end
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					modalVariant = function(p28) -- line: 506
						return p28
					end,
					source = function(p29) -- line: 509
						return p29
					end,
					tfActionsEnum = function(p30) -- line: 512
						return p30
					end
				}
			}
		}
	},
	[EventNames.TCUpsellAgePrecheckTriggered] = if not FFlagTFUpdateAnalytics then nil else {
		description = "TC Upsell facial age estimation precheck triggered",
		lastUpdated = {
			26,
			6,
			5
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function() -- line: 527
					-- upvalues: EventTypes (copy)
					return EventTypes.UserSeen
				end,
				staticCustomFields = {
					eventContext = Contexts.TCUpsellModal
				},
				dynamicCustomFields = {
					source = function(p31) -- line: 534
						return p31
					end,
					tfActionsEnum = function(p32) -- line: 537
						return p32
					end
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					source = function(p33) -- line: 545
						return p33
					end,
					tfActionsEnum = function(p34) -- line: 548
						return p34
					end
				}
			}
		}
	},
	[EventNames.TCUpsellAgePrecheckSucceeded] = if not FFlagTFUpdateAnalytics then nil else {
		description = "TC Upsell facial age estimation precheck succeeded",
		lastUpdated = {
			26,
			6,
			5
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function() -- line: 563
					-- upvalues: EventTypes (copy)
					return EventTypes.UserSeen
				end,
				staticCustomFields = {
					eventContext = Contexts.TCUpsellModal
				},
				dynamicCustomFields = {
					source = function(p35) -- line: 570
						return p35
					end,
					tfActionsEnum = function(p36) -- line: 573
						return p36
					end
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					source = function(p37) -- line: 581
						return p37
					end,
					tfActionsEnum = function(p38) -- line: 584
						return p38
					end
				}
			}
		}
	},
	[EventNames.TCUpsellAgePrecheckFailed] = if not FFlagTFUpdateAnalytics then nil else {
		description = "TC Upsell facial age estimation precheck failed",
		lastUpdated = {
			26,
			6,
			5
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function() -- line: 599
					-- upvalues: EventTypes (copy)
					return EventTypes.UserSeen
				end,
				staticCustomFields = {
					eventContext = Contexts.TCUpsellModal
				},
				dynamicCustomFields = {
					source = function(p39) -- line: 606
						return p39
					end,
					tfActionsEnum = function(p40) -- line: 609
						return p40
					end
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					source = function(p41) -- line: 617
						return p41
					end,
					tfActionsEnum = function(p42) -- line: 620
						return p42
					end
				}
			}
		}
	},
	[EventNames.TCUpsellLearnMoreClicked] = if not FFlagTCLearnMoreLink then nil else {
		description = "Learn more link clicked",
		lastUpdated = {
			12,
			3,
			26
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function() -- line: 635
					-- upvalues: EventTypes (copy)
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					btn = "LearnMoreLink",
					eventContext = Contexts.TCUpsellModal
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter
			}
		}
	}
}
