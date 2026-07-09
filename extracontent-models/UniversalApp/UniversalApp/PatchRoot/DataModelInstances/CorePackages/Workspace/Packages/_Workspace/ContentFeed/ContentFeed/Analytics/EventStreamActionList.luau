local ParentParent = script.Parent.Parent.Parent
local Dash = require(ParentParent.Dash)
local Enums = require(ParentParent.SocialLuaAnalytics).Analytics.Enums
local Contexts = Enums.Contexts
local EventTypes = Enums.EventTypes
local EventConstants = require(script.Parent.EventConstants)
local EventNames = require(script.Parent.EventNames)

return {
	[EventNames.ContentFeedDeleteCtaPressed] = {
		additionalInfo = {
			action = EventConstants.action.DeleteCtaPressed,
			namespace = EventConstants.namespace.ContentFeed
		},
		context = Contexts.SocialContentFeed,
		eventType = EventTypes.ButtonClick,
		formatRulesForAdditionalInfo = {
			postId = Dash.identity
		}
	},
	[EventNames.ContentFeedExitCtaPressed] = {
		additionalInfo = {
			action = EventConstants.action.ExitCtaPressed,
			namespace = EventConstants.namespace.ContentFeed
		},
		context = Contexts.SocialContentFeed,
		eventType = EventTypes.ButtonClick,
		formatRulesForAdditionalInfo = {
			postId = Dash.identity
		}
	},
	[EventNames.ContentFeedInspectCtaPressed] = {
		additionalInfo = {
			action = EventConstants.action.InspectCtaPressed,
			namespace = EventConstants.namespace.ContentFeed
		},
		context = Contexts.SocialContentFeed,
		eventType = EventTypes.ButtonClick,
		formatRulesForAdditionalInfo = {
			postId = Dash.identity
		}
	},
	[EventNames.ContentFeedInspectItemPressed] = {
		additionalInfo = {
			action = EventConstants.action.InspectItemPressed,
			namespace = EventConstants.namespace.ContentFeed
		},
		context = Contexts.SocialContentFeed,
		eventType = EventTypes.ButtonClick,
		formatRulesForAdditionalInfo = {
			itemId = Dash.identity,
			postId = Dash.identity
		}
	},
	[EventNames.ContentFeedMoreMenuButtonPressed] = {
		additionalInfo = {
			action = EventConstants.action.MoreMenuButtonPressed,
			namespace = EventConstants.namespace.ContentFeed
		},
		context = Contexts.SocialContentFeed,
		eventType = EventTypes.ButtonClick,
		formatRulesForAdditionalInfo = {
			postId = Dash.identity
		}
	},
	[EventNames.ContentFeedPlayButtonPressed] = {
		additionalInfo = {
			action = EventConstants.action.PlayButtonPressed,
			namespace = EventConstants.namespace.ContentFeed
		},
		context = Contexts.SocialContentFeed,
		eventType = EventTypes.ButtonClick,
		formatRulesForAdditionalInfo = {
			postId = Dash.identity
		}
	},
	[EventNames.ContentFeedPostViewed] = {
		additionalInfo = {
			action = EventConstants.action.PostViewed,
			namespace = EventConstants.namespace.ContentFeed
		},
		context = Contexts.SocialContentFeed,
		eventType = EventTypes.ButtonClick,
		formatRulesForAdditionalInfo = {
			postId = Dash.identity
		}
	},
	[EventNames.ContentFeedReportCtaPressed] = {
		additionalInfo = {
			action = EventConstants.action.ReportCtaPressed,
			namespace = EventConstants.namespace.ContentFeed
		},
		context = Contexts.SocialContentFeed,
		eventType = EventTypes.ButtonClick,
		formatRulesForAdditionalInfo = {
			postId = Dash.identity
		}
	},
	[EventNames.ContentFeedShareCtaPressed] = {
		additionalInfo = {
			action = EventConstants.action.ShareCtaPressed,
			namespace = EventConstants.namespace.ContentFeed
		},
		context = Contexts.SocialContentFeed,
		eventType = EventTypes.ButtonClick,
		formatRulesForAdditionalInfo = {
			postId = Dash.identity
		}
	},
	[EventNames.ContentFeedZoomOccurred] = {
		additionalInfo = {
			action = EventConstants.action.ZoomOccurred,
			namespace = EventConstants.namespace.ContentFeed
		},
		context = Contexts.SocialContentFeed,
		eventType = EventTypes.ButtonClick,
		formatRulesForAdditionalInfo = {
			postId = Dash.identity
		}
	}
}
