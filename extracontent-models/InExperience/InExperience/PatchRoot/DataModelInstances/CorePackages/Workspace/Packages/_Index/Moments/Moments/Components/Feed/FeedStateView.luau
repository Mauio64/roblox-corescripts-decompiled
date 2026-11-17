local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)

local useLocalization = Localization.Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens

require(script.Parent.FeedTypes)
local FeedMessageView = require(script.Parent.FeedMessageView)
local FFlagMomentsFeedErrorStateRedesign = require(Moments.Flags.FFlagMomentsFeedErrorStateRedesign)
local FFlagMomentsParentTimeLimit = MomentsCommon.Flags.FFlagMomentsParentTimeLimit

local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local Button = Foundation.Button
local Text = Foundation.Text
local View = Foundation.View
local IconName = Foundation.Enums.IconName

local v = {
	failedTitle = "Feature.Moments.Label.FeedFailedToLoad",
	failedMessage = "Feature.Moments.Label.Error",
	retryLabel = "Feature.Moments.Action.Retry"
}

if FFlagMomentsFeedErrorStateRedesign then
	v.couldNotLoadTitle = "Feature.Moments.Label.FeedCouldNotLoad"
	v.somethingWentWrong = "CommonUI.Messages.Response.SomethingWentWrong"
end

local function resolveLocalized(p: string?, p2: string)
	return if p == nil or p == "" then p2 else p
end

local function CenteredOverlay(p)
	return React.createElement(FocusRoot, {
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay,
		isAutoFocusRoot = true,
		frameProps = p.zIndex ~= nil and { ZIndex = p.zIndex } or nil
	}, {
		Content = React.createElement(
			View,
			{
				tag = "col align-x-center align-y-center gap-medium size-full padding-xlarge bg-surface-0"
			},
			p.children
		)
	})
end

local function FeedErrorMessage(p)
	local v2 = useTokens()
	local localized = p.localized

	local createElement = React.createElement
	local v3 = {
		iconName = IconName.TriangleExclamation,
		iconSize = v2.Size.Size_1600,
		tilted = false,
		title = 0,
		description = 0,
		primaryAction = 0,
		testId = "--moments-feed-error"
	}

	local couldNotLoadTitle = localized.couldNotLoadTitle
	v3.title = (couldNotLoadTitle == nil or couldNotLoadTitle == "") and "Moments couldn't load" or couldNotLoadTitle
	v3.description = localized.somethingWentWrong
	v3.primaryAction = {
		text = localized.retryLabel,
		onActivated = p.onRetry,
		testId = "--moments-feed-error--retry"
	}
	return createElement(FeedMessageView, v3)
end

local function FeedStateView(props)
	local localized = useLocalization(v)
	local status = props.status

	if FFlagMomentsFeedErrorStateRedesign and status == "Failed" then
		return React.createElement(CenteredOverlay, { zIndex = props.zIndex }, {
			Message = React.createElement(FeedErrorMessage, {
				localized = localized,
				onRetry = props.onRetry
			})
		})
	end

	if status == "Failed" then
		return React.createElement(CenteredOverlay, { zIndex = props.zIndex }, {
			Title = React.createElement(Text, {
				LayoutOrder = 1,
				tag = "size-full-0 auto-y text-heading-medium text-wrap text-align-x-center content-emphasis",
				Text = localized.failedTitle
			}),
			Description = React.createElement(Text, {
				LayoutOrder = 2,
				tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-center content-default",
				Text = localized.failedMessage
			})
		})
	end

	if status == "Empty" and props.emptyState ~= nil then
		return React.createElement(CenteredOverlay, { zIndex = props.zIndex }, {
			EmptyState = props.emptyState
		})
	end

	if status == "Empty" then
		return React.createElement(CenteredOverlay, { zIndex = props.zIndex }, {
			Message = React.createElement(Text, {
				LayoutOrder = 1,
				tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-center content-emphasis",
				Text = "No moments yet"
			}),
			Cta = props.emptyContent
		})
	end

	if FFlagMomentsParentTimeLimit and status == "LimitReached" then
		return React.createElement(
			View,
			{
				tag = "col align-x-center align-y-center gap-medium size-full padding-xlarge bg-surface-0",
				ZIndex = props.zIndex
			},
			{
				TimeLimit = React.createElement(require(script.Parent.Items.TimeLimit.MomentsTimeLimitContainer))
			}
		)
	end

	if props.loadMoreFailed then
		return React.createElement(
			View,
			{
				tag = "col align-x-center align-y-bottom size-full padding-large",
				ZIndex = props.zIndex
			},
			{
				RetryButton = React.createElement(Button, {
					onActivated = props.onRetry,
					size = Foundation.Enums.InputSize.Small,
					text = localized.retryLabel,
					variant = Foundation.Enums.ButtonVariant.Standard
				})
			}
		)
	end

	return nil
end

return FeedStateView
