local Parent = script:FindFirstAncestor("Moments").Parent
local Foundation = require(Parent.Foundation)
local Localization = require(Parent.Localization)
local React = require(Parent.React)
local FocusNavigationUtils = require(Parent.FocusNavigationUtils)
local useLocalization = Localization.Hooks.useLocalization

require(script.Parent.FeedTypes)

local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local Button = Foundation.Button
local FoundationText = Foundation.Text
local View = Foundation.View
local t1 = {
	failedTitle = "Feature.Moments.Label.FeedFailedToLoad",
	failedMessage = "Feature.Moments.Label.Error",
	retryLabel = "Feature.Moments.Action.Retry"
}

local function CenteredOverlay(t2: {[any]: any}) -- line: 60
	-- upvalues: React (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), View (copy)
	return React.createElement(FocusRoot, {
		isAutoFocusRoot = true,
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay,
		frameProps = if t2.zIndex == nil then nil else {
			ZIndex = t2.zIndex
		}
	}, {
		Content = React.createElement(View, {
			tag = "col align-x-center align-y-center gap-medium size-full padding-xlarge bg-surface-0"
		}, t2.children)
	})
end
local function FeedStateView(t3: {[any]: any}) -- line: 74
	-- upvalues: useLocalization (copy), t1 (copy), React (copy), CenteredOverlay (copy), FoundationText (copy), View (copy), Button (copy), Foundation (copy)
	local v17 = useLocalization(t1)
	local status = t3.status

	if status == "Failed" then
		return React.createElement(CenteredOverlay, {
			zIndex = t3.zIndex
		}, {
			Title = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "size-full-0 auto-y text-heading-medium text-wrap text-align-x-center content-emphasis",
				Text = v17.failedTitle
			}),
			Description = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-center content-default",
				Text = v17.failedMessage
			})
		})
	end

	if status == "Empty" then
		return React.createElement(CenteredOverlay, {
			zIndex = t3.zIndex
		}, {
			Message = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-center content-emphasis",
				Text = "No moments yet"
			}),
			Cta = t3.emptyContent
		})
	end

	if t3.loadMoreFailed then
		return React.createElement(View, {
			tag = "col align-x-center align-y-bottom size-full padding-large",
			ZIndex = t3.zIndex
		}, {
			RetryButton = React.createElement(Button, {
				onActivated = t3.onRetry,
				size = Foundation.Enums.InputSize.Small,
				text = v17.retryLabel,
				variant = Foundation.Enums.ButtonVariant.Standard
			})
		})
	end

	return nil
end

return FeedStateView
