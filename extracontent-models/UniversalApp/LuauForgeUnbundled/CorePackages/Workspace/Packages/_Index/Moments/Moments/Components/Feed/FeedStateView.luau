local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/FocusNavigationUtils")

local useLocalization = Localization.Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")
local FeedMessageView = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedMessageView")
local FFlagMomentsFeedErrorStateRedesign = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsFeedErrorStateRedesign")

local focusRoot = FocusNavigationUtils.FocusRoot
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local button = Foundation.Button
local text = Foundation.Text
local view = Foundation.View
local iconName = Foundation.Enums.IconName

local v5 = {
	failedTitle = "Feature.Moments.Label.FeedFailedToLoad",
	failedMessage = "Feature.Moments.Label.Error",
	retryLabel = "Feature.Moments.Action.Retry"
}

if FFlagMomentsFeedErrorStateRedesign then
	v5.couldNotLoadTitle = "Feature.Moments.Label.FeedCouldNotLoad"
	v5.somethingWentWrong = "CommonUI.Messages.Response.SomethingWentWrong"
end

local function resolveLocalized(p2, p3)
	if p2 == nil or p2 == "" then
		return p3
	end

	return p2
end

local function CenteredOverlay(p2)
	return React.createElement(focusRoot, {
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.CentralOverlay,
		isAutoFocusRoot = true,
		frameProps = p2.zIndex ~= nil and { ZIndex = p2.zIndex } or nil
	}, {
		Content = React.createElement(
			view,
			{
				tag = "col align-x-center align-y-center gap-medium size-full padding-xlarge bg-surface-0"
			},
			p2.children
		)
	})
end

local function FeedErrorMessage(p2)
	local v6 = useTokens()
	local localized = p2.localized

	local createElement = React.createElement
	local v8 = {
		iconName = iconName.TriangleExclamation,
		iconSize = v6.Size.Size_1600,
		tilted = false,
		title = 0,
		description = 0,
		primaryAction = 0,
		testId = "--moments-feed-error"
	}

	local couldNotLoadTitle = localized.couldNotLoadTitle
	v8.title = (couldNotLoadTitle == nil or couldNotLoadTitle == "") and "Moments couldn't load"
		or couldNotLoadTitle
	v8.description = localized.somethingWentWrong
	v8.primaryAction = {
		text = localized.retryLabel,
		onActivated = p2.onRetry,
		testId = "--moments-feed-error--retry"
	}
	return createElement(FeedMessageView, v8)
end

local function FeedStateView(props)
	local v6 = useLocalization(v5)
	local status = props.status

	if FFlagMomentsFeedErrorStateRedesign and status == "Failed" then
		return React.createElement(CenteredOverlay, { zIndex = props.zIndex }, {
			Message = React.createElement(FeedErrorMessage, {
				localized = v6,
				onRetry = props.onRetry
			})
		})
	end

	if status == "Failed" then
		return React.createElement(CenteredOverlay, { zIndex = props.zIndex }, {
			Title = React.createElement(text, {
				LayoutOrder = 1,
				tag = "size-full-0 auto-y text-heading-medium text-wrap text-align-x-center content-emphasis",
				Text = v6.failedTitle
			}),
			Description = React.createElement(text, {
				LayoutOrder = 2,
				tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-center content-default",
				Text = v6.failedMessage
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
			Message = React.createElement(text, {
				LayoutOrder = 1,
				tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-center content-emphasis",
				Text = "No moments yet"
			}),
			Cta = props.emptyContent
		})
	end

	if props.loadMoreFailed then
		return React.createElement(
			view,
			{
				tag = "col align-x-center align-y-bottom size-full padding-large",
				ZIndex = props.zIndex
			},
			{
				RetryButton = React.createElement(button, {
					onActivated = props.onRetry,
					size = Foundation.Enums.InputSize.Small,
					text = v6.retryLabel,
					variant = Foundation.Enums.ButtonVariant.Standard
				})
			}
		)
	end

	return nil
end

return FeedStateView
