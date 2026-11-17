local parent = script:FindFirstAncestor("Moments").Parent

local Localization = require(parent.Localization)

local useLocalization = Localization.Hooks.useLocalization

local v = {
	postingSnackbar = "Feature.Moments.Label.PostFeedbackPostingSnackbar",
	postingTitle = "Feature.Moments.Label.PostFeedbackPostingTitle",
	postingBody = "Feature.Moments.Label.PostFeedbackPostingBody",
	postingBadge = "Feature.Moments.Label.PostFeedbackPostingBadge",
	moderatedBadge = "Feature.Moments.Label.PostFeedbackModeratedBadge",
	liveTitle = "Notifications.Moments.Title.MomentPostSuccess",
	liveBody = "Notifications.Moments.Body.MomentPostSuccess",
	failedTitle = "Notifications.Moments.Title.MomentPostFailed",
	failedBody = "Notifications.Moments.Body.MomentPostFailed",
	moderatedTitle = "Notifications.Moments.Title.MomentPostModerated",
	moderatedBody = "Notifications.Moments.Body.MomentPostModerated",
	share = "Feature.SocialShare.Action.Share",
	dismiss = "CommonUI.Messages.Action.Dismiss"
}

local function usePostFeedbackStrings()
	local v2 = useLocalization(v)
	return {
		postingSnackbar = v2.postingSnackbar,
		postingTitle = v2.postingTitle,
		postingBody = v2.postingBody,
		moderatedTitle = v2.moderatedTitle,
		moderatedBody = v2.moderatedBody,
		postingBadge = v2.postingBadge,
		moderatedBadge = v2.moderatedBadge,
		liveTitle = v2.liveTitle,
		liveBody = v2.liveBody,
		failedTitle = v2.failedTitle,
		failedBody = v2.failedBody,
		share = v2.share,
		dismiss = v2.dismiss
	}
end

return usePostFeedbackStrings
