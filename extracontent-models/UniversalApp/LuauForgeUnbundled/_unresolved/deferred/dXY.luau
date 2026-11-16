local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/Dash")
local enums = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/SocialLuaAnalytics").Analytics.Enums

local contexts = enums.Contexts
local eventTypes = enums.EventTypes

local module2 = require("@luauforge/deferred/dXZ")
local module3 = require("@luauforge/deferred/dWP")

return {
	[module3.ContentFeedDeleteCtaPressed] = {
		additionalInfo = {
			action = module2.action.DeleteCtaPressed,
			namespace = module2.namespace.ContentFeed
		},
		context = contexts.SocialContentFeed,
		eventType = eventTypes.ButtonClick,
		formatRulesForAdditionalInfo = { postId = Dash.identity }
	},
	[module3.ContentFeedExitCtaPressed] = {
		additionalInfo = {
			action = module2.action.ExitCtaPressed,
			namespace = module2.namespace.ContentFeed
		},
		context = contexts.SocialContentFeed,
		eventType = eventTypes.ButtonClick,
		formatRulesForAdditionalInfo = { postId = Dash.identity }
	},
	[module3.ContentFeedInspectCtaPressed] = {
		additionalInfo = {
			action = module2.action.InspectCtaPressed,
			namespace = module2.namespace.ContentFeed
		},
		context = contexts.SocialContentFeed,
		eventType = eventTypes.ButtonClick,
		formatRulesForAdditionalInfo = { postId = Dash.identity }
	},
	[module3.ContentFeedInspectItemPressed] = {
		additionalInfo = {
			action = module2.action.InspectItemPressed,
			namespace = module2.namespace.ContentFeed
		},
		context = contexts.SocialContentFeed,
		eventType = eventTypes.ButtonClick,
		formatRulesForAdditionalInfo = {
			itemId = Dash.identity,
			postId = Dash.identity
		}
	},
	[module3.ContentFeedMoreMenuButtonPressed] = {
		additionalInfo = {
			action = module2.action.MoreMenuButtonPressed,
			namespace = module2.namespace.ContentFeed
		},
		context = contexts.SocialContentFeed,
		eventType = eventTypes.ButtonClick,
		formatRulesForAdditionalInfo = { postId = Dash.identity }
	},
	[module3.ContentFeedPlayButtonPressed] = {
		additionalInfo = {
			action = module2.action.PlayButtonPressed,
			namespace = module2.namespace.ContentFeed
		},
		context = contexts.SocialContentFeed,
		eventType = eventTypes.ButtonClick,
		formatRulesForAdditionalInfo = { postId = Dash.identity }
	},
	[module3.ContentFeedPostViewed] = {
		additionalInfo = {
			action = module2.action.PostViewed,
			namespace = module2.namespace.ContentFeed
		},
		context = contexts.SocialContentFeed,
		eventType = eventTypes.ButtonClick,
		formatRulesForAdditionalInfo = { postId = Dash.identity }
	},
	[module3.ContentFeedReportCtaPressed] = {
		additionalInfo = {
			action = module2.action.ReportCtaPressed,
			namespace = module2.namespace.ContentFeed
		},
		context = contexts.SocialContentFeed,
		eventType = eventTypes.ButtonClick,
		formatRulesForAdditionalInfo = { postId = Dash.identity }
	},
	[module3.ContentFeedShareCtaPressed] = {
		additionalInfo = {
			action = module2.action.ShareCtaPressed,
			namespace = module2.namespace.ContentFeed
		},
		context = contexts.SocialContentFeed,
		eventType = eventTypes.ButtonClick,
		formatRulesForAdditionalInfo = { postId = Dash.identity }
	},
	[module3.ContentFeedZoomOccurred] = {
		additionalInfo = {
			action = module2.action.ZoomOccurred,
			namespace = module2.namespace.ContentFeed
		},
		context = contexts.SocialContentFeed,
		eventType = eventTypes.ButtonClick,
		formatRulesForAdditionalInfo = { postId = Dash.identity }
	}
}
