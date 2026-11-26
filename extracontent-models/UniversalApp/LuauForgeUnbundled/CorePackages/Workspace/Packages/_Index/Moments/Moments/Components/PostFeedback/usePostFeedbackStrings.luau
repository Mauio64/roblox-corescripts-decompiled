local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization").Hooks.useLocalization

local v5 = {
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
	local v6 = useLocalization(v5)
	return {
		postingSnackbar = v6.postingSnackbar,
		postingTitle = v6.postingTitle,
		postingBody = v6.postingBody,
		moderatedTitle = v6.moderatedTitle,
		moderatedBody = v6.moderatedBody,
		postingBadge = v6.postingBadge,
		moderatedBadge = v6.moderatedBadge,
		liveTitle = v6.liveTitle,
		liveBody = v6.liveBody,
		failedTitle = v6.failedTitle,
		failedBody = v6.failedBody,
		share = v6.share,
		dismiss = v6.dismiss
	}
end

return usePostFeedbackStrings
