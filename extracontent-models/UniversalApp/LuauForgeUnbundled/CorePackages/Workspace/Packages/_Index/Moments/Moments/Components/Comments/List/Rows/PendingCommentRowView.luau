local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local CommentRowView = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/Rows/CommentRow/CommentRowView")

local useLocalization = Localization.Hooks.useLocalization

local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize

local v5 = {
	retry = "Feature.Moments.Action.Retry",
	edit = "Feature.Moments.Action.Edit",
	sending = "Feature.Moments.Label.CommentSending",
	sendStatusUnknown = "Feature.Moments.Label.CommentSendStatusUnknown"
}

local function PendingCommentRowView(props)
	local v6 = useLocalization(v5)
	local v7 = props.status == "Sending" and 0.5 or 0
	local v8, v9 = React.useBinding(v7)
	React.useEffect(function()
		v9(v7)
	end, { v7 })
	local v10

	if props.status == "OutcomeUnknown" and props.onEdit ~= nil then
		local createElement = React.createElement
		local view = Foundation.View

		local v13 = if props.onRetry ~= nil then React.createElement(Foundation.Button, {
			LayoutOrder = 1,
			text = v6.retry,
			size = inputSize.XSmall,
			variant = buttonVariant.Link,
			onActivated = props.onRetry,
			testId = `moments-comment-retry-{props.rowKey}`
		}) else nil
		v10 = createElement(view, { tag = "row align-y-center gap-small auto-xy" }, {
			Retry = v13,
			Edit = React.createElement(Foundation.Button, {
				LayoutOrder = 2,
				text = v6.edit,
				size = inputSize.XSmall,
				variant = buttonVariant.Link,
				onActivated = props.onEdit,
				testId = `moments-comment-edit-{props.rowKey}`
			})
		})
	end

	local createElement = React.createElement
	local v12 = {
		LayoutOrder = props.LayoutOrder,
		commentId = props.rowKey,
		avatarUserId = nil,
		authorLabel = props.viewerUsername,
		isAuthorLoading = false,
		text = props.text,
		metadataLabel = 0,
		avatarBackgroundStyle = 0,
		GroupTransparency = 0,
		headerAction = 0
	}
	local v13 = if props.status == "Sending" then v6.sending else v6.sendStatusUnknown
	v12.metadataLabel = v13
	v12.avatarBackgroundStyle = props.avatarBackgroundStyle
	v12.GroupTransparency = v8

	if v10 == nil then
		if props.status == "OutcomeUnknown" and props.onRetry ~= nil then
			v10 = React.createElement(Foundation.Button, {
				text = v6.retry,
				size = inputSize.XSmall,
				variant = buttonVariant.Link,
				onActivated = props.onRetry,
				testId = `moments-comment-retry-{props.rowKey}`
			})
		else
			v10 = nil
		end
	end

	v12.headerAction = v10
	return createElement(CommentRowView, v12)
end

return PendingCommentRowView
