local parent = script:FindFirstAncestor("Moments").Parent

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)

local CommentRowView = require(script.Parent.CommentRow.CommentRowView)

local useLocalization = Localization.Hooks.useLocalization

local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

local v = {
	retry = "Feature.Moments.Action.Retry",
	edit = "Feature.Moments.Action.Edit",
	sending = "Feature.Moments.Label.CommentSending",
	sendStatusUnknown = "Feature.Moments.Label.CommentSendStatusUnknown"
}

local function PendingCommentRowView(props)
	local v2 = useLocalization(v)
	local v3 = props.status == "Sending" and 0.5 or 0
	local groupTransparency, v4 = React.useBinding(v3)
	React.useEffect(function()
		v4(v3)
	end, { v3 })
	local headerAction

	if props.status == "OutcomeUnknown" and props.onEdit ~= nil then
		local createElement = React.createElement
		local view = Foundation.View
		local retry

		if props.onRetry ~= nil then
			retry = React.createElement(Foundation.Button, {
				LayoutOrder = 1,
				text = v2.retry,
				size = InputSize.XSmall,
				variant = ButtonVariant.Link,
				onActivated = props.onRetry,
				testId = `moments-comment-retry-{props.rowKey}`
			})
		end

		headerAction = createElement(view, { tag = "row align-y-center gap-small auto-xy" }, {
			Retry = retry,
			Edit = React.createElement(Foundation.Button, {
				LayoutOrder = 2,
				text = v2.edit,
				size = InputSize.XSmall,
				variant = ButtonVariant.Link,
				onActivated = props.onEdit,
				testId = `moments-comment-edit-{props.rowKey}`
			})
		})
	end

	local createElement = React.createElement
	local v5 = {
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
	local metadataLabel

	if props.status == "Sending" then
		metadataLabel = v2.sending
	else
		metadataLabel = v2.sendStatusUnknown
	end

	v5.metadataLabel = metadataLabel
	v5.avatarBackgroundStyle = props.avatarBackgroundStyle
	v5.GroupTransparency = groupTransparency

	if headerAction == nil then
		if props.status == "OutcomeUnknown" and props.onRetry ~= nil then
			headerAction = React.createElement(Foundation.Button, {
				text = v2.retry,
				size = InputSize.XSmall,
				variant = ButtonVariant.Link,
				onActivated = props.onRetry,
				testId = `moments-comment-retry-{props.rowKey}`
			})
		else
			headerAction = nil
		end
	end

	v5.headerAction = headerAction
	return createElement(CommentRowView, v5)
end

return PendingCommentRowView
