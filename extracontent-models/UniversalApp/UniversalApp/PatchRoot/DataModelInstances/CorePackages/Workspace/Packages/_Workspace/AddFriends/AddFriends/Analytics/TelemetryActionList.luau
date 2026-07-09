local AddFriends = script:FindFirstAncestor("AddFriends")
local EventNames = require(script.Parent.EventNames)
local AddFriendsParent = AddFriends.Parent
local SocialLuaAnalytics = require(AddFriendsParent.SocialLuaAnalytics)
local SupportedTelemetryBackends = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends
local EventTypes = SocialLuaAnalytics.Analytics.Enums.EventTypes
local Contexts = SocialLuaAnalytics.Analytics.Enums.Contexts
local FFlagAddFriendsTileLoadFromHomeCarouselAnalytics = require(AddFriendsParent.SharedFlags).FFlagAddFriendsTileLoadFromHomeCarouselAnalytics
local FFlagAddFriendsPageFAEUpsell = require(AddFriendsParent.SharedFlags).FFlagAddFriendsPageFAEUpsell
local FFlagEnableSchoolEntry = require(AddFriendsParent.SharedFlags).FFlagEnableSchoolEntry

return {
	defaults = {
		links = "",
		throttlingThousandths = game:DefineFastInt("AddFriendsPageAnalyticsThrottlingThousandths", 1000)
	},
	[EventNames.AddFriendsPageLoadingTime] = {
		description = "Add friends page requests and recommendation promise loading time",
		lastUpdated = {
			24,
			6,
			7
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					status = function(p1) -- line: 27
						return p1
					end
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryStat,
				dynamicCustomFields = {
					status = function(p2) -- line: 35
						return p2
					end
				}
			}
		}
	},
	[EventNames.AFPUserTileLoadFromHomeCarousel] = if not FFlagAddFriendsTileLoadFromHomeCarouselAnalytics then nil else {
		description = "Time from home-carousel Add Friends tile click to first user tile rendered on AFP",
		lastUpdated = {
			26,
			5,
			6
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryStat
			}
		}
	},
	[EventNames.FAEModalImpression] = if not FFlagAddFriendsPageFAEUpsell then nil else {
		description = "FAE upsell modal seen on Add Friends Page",
		lastUpdated = {
			26,
			5,
			14
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function() -- line: 63
					-- upvalues: EventTypes (copy)
					return EventTypes.UserSeen
				end,
				staticCustomFields = {
					action = "FAEmodal",
					eventContext = Contexts.AddFriends
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				overrideName = function() -- line: 73
					return "FAEModalImpressionOnAFP"
				end
			}
		}
	},
	[EventNames.PlayerTileClick] = {
		description = "Add friends page clicks on user tiles",
		lastUpdated = {
			24,
			11,
			13
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter,
			dynamicCustomFields = {
				namespace = function(p3) -- line: 87
					return p3
				end,
				entityType = function(p4) -- line: 90
					return p4
				end
			}
		}}
	},
	[EventNames.RequestFriendshipBtnClick] = {
		description = "Add friends page clicks on Request Friendship button on user tile",
		lastUpdated = {
			24,
			11,
			13
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter,
			dynamicCustomFields = {
				namespace = function(p5) -- line: 104
					return p5
				end,
				entityType = function(p6) -- line: 107
					return p6
				end
			}
		}}
	},
	[EventNames.AcceptFriendshipBtnClick] = {
		description = "Add friends page clicks on Accept Friendship button on user tile",
		lastUpdated = {
			24,
			11,
			13
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter,
			dynamicCustomFields = {
				namespace = function(p7) -- line: 121
					return p7
				end,
				entityType = function(p8) -- line: 124
					return p8
				end
			}
		}}
	},
	[EventNames.DeclineFriendshipBtnClick] = {
		description = "Add friends page clicks on Decline Friendship button on user tile",
		lastUpdated = {
			24,
			11,
			13
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter,
			dynamicCustomFields = {
				namespace = function(p9) -- line: 138
					return p9
				end,
				entityType = function(p10) -- line: 141
					return p10
				end
			}
		}}
	},
	[EventNames.UserSearchClick] = {
		description = "Add friends page clicks on user search input",
		lastUpdated = {
			24,
			11,
			13
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.CIBtnClick] = {
		description = "Add friends page clicks on contact importer banner",
		lastUpdated = {
			24,
			11,
			13
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.QRCodeBtnClick] = {
		description = "Add friends page clicks on QRcode banner",
		lastUpdated = {
			24,
			11,
			13
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.CIBtnImpression] = {
		description = "Add friends page impressions for contact importer banner",
		lastUpdated = {
			24,
			11,
			13
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.QRCodeBtnImpression] = {
		description = "Add friends page impressions for QRcode banner",
		lastUpdated = {
			24,
			11,
			13
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.SchoolBtnClick] = if not FFlagEnableSchoolEntry then nil else {
		description = "Add friends page clicks on school entry tile",
		lastUpdated = {
			26,
			6,
			8
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.SchoolBtnImpression] = if not FFlagEnableSchoolEntry then nil else {
		description = "Add friends page impressions for school entry tile",
		lastUpdated = {
			26,
			6,
			8
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.ShowMoreBtnClick] = {
		description = "Add friends page clicks on Show More button",
		lastUpdated = {
			24,
			11,
			13
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.IgnoreAllBtnClick] = {
		description = "Add friends page clicks on Ignore All button",
		lastUpdated = {
			24,
			11,
			13
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.FriendingOSAEducationSubtitleImpression] = {
		description = "Friending OSA Education subtitle impression",
		lastUpdated = {
			25,
			6,
			11
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.TrustedContactsEducationalBannerClick] = {
		description = "Trusted Contacts Educational Banner Click",
		lastUpdated = {
			25,
			6,
			11
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.TrustedContactsEducationalBannerClose] = {
		description = "Trusted Contacts Educational Banner Close",
		lastUpdated = {
			25,
			6,
			11
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.TrustedContactsEducationalBannerImpression] = {
		description = "Trusted Contacts Educational Banner Impression",
		lastUpdated = {
			25,
			6,
			11
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.FAEEligibleBannerClick] = {
		description = "FAE Eligible Banner Click on Add Friends Page",
		lastUpdated = {
			26,
			5,
			15
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function() -- line: 275
					-- upvalues: EventTypes (copy)
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					action = "FAEEligibleBanner",
					btn = "Unlock",
					eventContext = Contexts.AddFriends
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter
			}
		}
	},
	[EventNames.FAEEligibleBannerClose] = {
		description = "FAE Eligible Banner Close on Add Friends Page",
		lastUpdated = {
			26,
			5,
			15
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function() -- line: 295
					-- upvalues: EventTypes (copy)
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					action = "FAEEligibleBanner",
					btn = "Close",
					eventContext = Contexts.AddFriends
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter
			}
		}
	},
	[EventNames.FAEEligibleBannerImpression] = {
		description = "FAE Eligible Banner Impression on Add Friends Page",
		lastUpdated = {
			26,
			5,
			15
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function() -- line: 315
					-- upvalues: EventTypes (copy)
					return EventTypes.UserSeen
				end,
				staticCustomFields = {
					action = "FAEEligibleBanner",
					eventContext = Contexts.AddFriends
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter
			}
		}
	}
}
