local module = require("@luauforge/deferred/efb")

local module2 = require("@luauforge/deferred/eeZ")
local supportedTelemetryBackends = module2.Analytics.Enums.SupportedTelemetryBackends
local eventTypes = module2.Analytics.Enums.EventTypes
local contexts = module2.Analytics.Enums.Contexts

local fFlagAddFriendsPageFAEUpsell = require("@luauforge/deferred/efc").FFlagAddFriendsPageFAEUpsell
local fFlagEnableSchoolEntry = require("@luauforge/deferred/efc").FFlagEnableSchoolEntry

return {
	defaults = {
		throttlingThousandths = game:DefineFastInt("AddFriendsPageAnalyticsThrottlingThousandths", 1000),
		links = ""
	},
	[module.AddFriendsPageLoadingTime] = {
		description = "Add friends page requests and recommendation promise loading time",
		lastUpdated = { 24, 6, 7 },
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					status = function(p2)
						return p2
					end
				}
			},
			{
				type = supportedTelemetryBackends.RobloxTelemetryStat,
				dynamicCustomFields = {
					status = function(p2)
						return p2
					end
				}
			}
		}
	},
	[module.AFPUserTileLoadFromHomeCarousel] = {
		description = "Time from home-carousel Add Friends tile click to first user tile rendered on AFP",
		lastUpdated = { 26, 5, 6 },
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter },
			{ type = supportedTelemetryBackends.RobloxTelemetryStat }
		}
	},
	[module.FAEModalImpression] = fFlagAddFriendsPageFAEUpsell and {
		description = "FAE upsell modal seen on Add Friends Page",
		lastUpdated = { 26, 5, 14 },
		backendsList = {
			{
				type = supportedTelemetryBackends.EventIngest,
				overrideName = function()
					return eventTypes.UserSeen
				end,
				staticCustomFields = {
					eventContext = contexts.AddFriends,
					action = "FAEmodal"
				}
			},
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				overrideName = function(): string
					return "FAEModalImpressionOnAFP"
				end
			}
		}
	} or nil,
	[module.PlayerTileClick] = {
		description = "Add friends page clicks on user tiles",
		lastUpdated = { 24, 11, 13 },
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					namespace = function(p2)
						return p2
					end,
					entityType = function(p2)
						return p2
					end
				}
			}
		}
	},
	[module.RequestFriendshipBtnClick] = {
		description = "Add friends page clicks on Request Friendship button on user tile",
		lastUpdated = { 24, 11, 13 },
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					namespace = function(p2)
						return p2
					end,
					entityType = function(p2)
						return p2
					end
				}
			}
		}
	},
	[module.AcceptFriendshipBtnClick] = {
		description = "Add friends page clicks on Accept Friendship button on user tile",
		lastUpdated = { 24, 11, 13 },
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					namespace = function(p2)
						return p2
					end,
					entityType = function(p2)
						return p2
					end
				}
			}
		}
	},
	[module.DeclineFriendshipBtnClick] = {
		description = "Add friends page clicks on Decline Friendship button on user tile",
		lastUpdated = { 24, 11, 13 },
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					namespace = function(p2)
						return p2
					end,
					entityType = function(p2)
						return p2
					end
				}
			}
		}
	},
	[module.UserSearchClick] = {
		description = "Add friends page clicks on user search input",
		lastUpdated = { 24, 11, 13 },
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[module.CIBtnClick] = {
		description = "Add friends page clicks on contact importer banner",
		lastUpdated = { 24, 11, 13 },
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[module.QRCodeBtnClick] = {
		description = "Add friends page clicks on QRcode banner",
		lastUpdated = { 24, 11, 13 },
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[module.CIBtnImpression] = {
		description = "Add friends page impressions for contact importer banner",
		lastUpdated = { 24, 11, 13 },
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[module.QRCodeBtnImpression] = {
		description = "Add friends page impressions for QRcode banner",
		lastUpdated = { 24, 11, 13 },
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[module.SchoolBtnClick] = fFlagEnableSchoolEntry and {
		description = "Add friends page clicks on school entry tile",
		lastUpdated = { 26, 6, 8 },
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	} or nil,
	[module.SchoolBtnImpression] = fFlagEnableSchoolEntry and {
		description = "Add friends page impressions for school entry tile",
		lastUpdated = { 26, 6, 8 },
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	} or nil,
	[module.ShowMoreBtnClick] = {
		description = "Add friends page clicks on Show More button",
		lastUpdated = { 24, 11, 13 },
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[module.IgnoreAllBtnClick] = {
		description = "Add friends page clicks on Ignore All button",
		lastUpdated = { 24, 11, 13 },
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[module.FriendingOSAEducationSubtitleImpression] = {
		description = "Friending OSA Education subtitle impression",
		lastUpdated = { 25, 6, 11 },
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[module.TrustedContactsEducationalBannerClick] = {
		description = "Trusted Contacts Educational Banner Click",
		lastUpdated = { 25, 6, 11 },
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[module.TrustedContactsEducationalBannerClose] = {
		description = "Trusted Contacts Educational Banner Close",
		lastUpdated = { 25, 6, 11 },
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[module.TrustedContactsEducationalBannerImpression] = {
		description = "Trusted Contacts Educational Banner Impression",
		lastUpdated = { 25, 6, 11 },
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[module.FAEEligibleBannerClick] = {
		description = "FAE Eligible Banner Click on Add Friends Page",
		lastUpdated = { 26, 5, 15 },
		backendsList = {
			{
				type = supportedTelemetryBackends.EventIngest,
				overrideName = function()
					return eventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = contexts.AddFriends,
					action = "FAEEligibleBanner",
					btn = "Unlock"
				}
			},
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[module.FAEEligibleBannerClose] = {
		description = "FAE Eligible Banner Close on Add Friends Page",
		lastUpdated = { 26, 5, 15 },
		backendsList = {
			{
				type = supportedTelemetryBackends.EventIngest,
				overrideName = function()
					return eventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = contexts.AddFriends,
					action = "FAEEligibleBanner",
					btn = "Close"
				}
			},
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[module.FAEEligibleBannerImpression] = {
		description = "FAE Eligible Banner Impression on Add Friends Page",
		lastUpdated = { 26, 5, 15 },
		backendsList = {
			{
				type = supportedTelemetryBackends.EventIngest,
				overrideName = function()
					return eventTypes.UserSeen
				end,
				staticCustomFields = {
					eventContext = contexts.AddFriends,
					action = "FAEEligibleBanner"
				}
			},
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	}
}
