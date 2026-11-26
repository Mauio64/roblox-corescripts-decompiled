local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local FoundationCloudAssets = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/FoundationCloudAssets")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local CommentsListSkeletonView = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/CommentsListSkeletonView")

local useLocalization = Localization.Hooks.useLocalization

local button = Foundation.Button
local empty = Foundation.Empty
local text = Foundation.Text
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local iconSize = Foundation.Enums.IconSize
local inputSize = Foundation.Enums.InputSize

local v5 = {
	empty = "Feature.Moments.Label.NoCommentsYet",
	emptyInvite = "Feature.Moments.Label.FirstCommentInvite",
	disabled = "Feature.Moments.Label.CommentsDisabled",
	unavailable = "Feature.Moments.Label.CommentsUnavailable",
	retry = "Feature.Moments.Action.Retry"
}

FoundationCloudAssets.preloadAsset("pictograms/chat")

local function CommentsPanelStateView(props)
	local v6 = useLocalization(v5)

	if props.state == "loading" then
		return React.createElement(CommentsListSkeletonView, {
			testId = `moments-comments-state-{props.state}`
		})
	end

	if props.state == "empty" then
		local createElement = React.createElement
		local v8 = {
			icon = { name = "pictograms/chat", size = iconSize.XXLarge },
			text = 0,
			testId = 0
		}

		local v9 = if props.isReadOnly then v6.empty else v6.emptyInvite
		v8.text = v9
		v8.testId = `moments-comments-state-{props.state}`
		return createElement(empty, v8)
	else
		local createElement = React.createElement
		local v8 = {
			tag = "col gap-medium size-full-0 auto-y",
			testId = `moments-comments-state-{props.state}`
		}
		local v9 = {
			Message = React.createElement(text, {
				Text = v6[props.state],
				tag = "auto-xy text-body-medium content-emphasis"
			}),
			Retry = 0
		}

		local v10 = if props.onRetry ~= nil then React.createElement(button, {
			text = v6.retry,
			onActivated = props.onRetry,
			size = inputSize.Small,
			variant = buttonVariant.Standard
		}) else nil
		v9.Retry = v10
		return createElement(view, v8, v9)
	end
end

return CommentsPanelStateView
