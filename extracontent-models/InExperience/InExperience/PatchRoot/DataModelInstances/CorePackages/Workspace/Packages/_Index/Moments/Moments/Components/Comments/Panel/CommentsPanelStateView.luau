local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Foundation = require(parent.Foundation)
local FoundationCloudAssets = require(parent.FoundationCloudAssets)
local Localization = require(parent.Localization)
local React = require(parent.React)

local CommentsListSkeletonView = require(Moments.Components.Comments.List.CommentsListSkeletonView)

local useLocalization = Localization.Hooks.useLocalization

local Button = Foundation.Button
local Empty = Foundation.Empty
local Text = Foundation.Text
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize

local v = {
	empty = "Feature.Moments.Label.NoCommentsYet",
	emptyInvite = "Feature.Moments.Label.FirstCommentInvite",
	disabled = "Feature.Moments.Label.CommentsDisabled",
	unavailable = "Feature.Moments.Label.CommentsUnavailable",
	retry = "Feature.Moments.Action.Retry"
}

FoundationCloudAssets.preloadAsset("pictograms/chat")

local function CommentsPanelStateView(props)
	local v2 = useLocalization(v)

	if props.state == "loading" then
		return React.createElement(CommentsListSkeletonView, {
			testId = `moments-comments-state-{props.state}`
		})
	end

	if props.state == "empty" then
		local createElement = React.createElement
		local v3 = {
			icon = { name = "pictograms/chat", size = IconSize.XXLarge },
			text = 0,
			testId = 0
		}
		local text

		if props.isReadOnly then
			text = v2.empty
		else
			text = v2.emptyInvite
		end

		v3.text = text
		v3.testId = `moments-comments-state-{props.state}`
		return createElement(Empty, v3)
	else
		local createElement = React.createElement
		local v3 = {
			tag = "col gap-medium size-full-0 auto-y",
			testId = `moments-comments-state-{props.state}`
		}
		local v4 = {
			Message = React.createElement(Text, {
				Text = v2[props.state],
				tag = "auto-xy text-body-medium content-emphasis"
			}),
			Retry = 0
		}
		local retry

		if props.onRetry ~= nil then
			retry = React.createElement(Button, {
				text = v2.retry,
				onActivated = props.onRetry,
				size = InputSize.Small,
				variant = ButtonVariant.Standard
			})
		end

		v4.Retry = retry
		return createElement(View, v3, v4)
	end
end

return CommentsPanelStateView
