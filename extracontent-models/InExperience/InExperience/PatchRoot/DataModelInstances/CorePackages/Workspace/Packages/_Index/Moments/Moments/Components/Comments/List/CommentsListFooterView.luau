local parent = script:FindFirstAncestor("Moments").Parent

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)

local useLocalization = Localization.Hooks.useLocalization

local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local ProgressShape = Foundation.Enums.ProgressShape
local ProgressSize = Foundation.Enums.ProgressSize

local v = { retry = "Feature.Moments.Action.RetryLoadingComments" }

local function CommentsListFooterView(props)
	local v2 = useLocalization(v)

	if props.status == "Loading" then
		return React.createElement(
			Foundation.View,
			{
				LayoutOrder = props.LayoutOrder,
				tag = "col align-x-center size-full-0 auto-y padding-y-medium",
				testId = "moments-comments-load-more-loading"
			},
			{
				Spinner = React.createElement(Foundation.Progress, {
					shape = ProgressShape.Circle,
					size = ProgressSize.Medium,
					testId = "moments-comments-load-more-spinner"
				})
			}
		)
	end

	if props.status == "Failed" then
		return React.createElement(Foundation.Button, {
			LayoutOrder = props.LayoutOrder,
			text = v2.retry,
			onActivated = props.onRetry,
			size = InputSize.Small,
			variant = ButtonVariant.Standard,
			testId = "moments-comments-load-more-retry"
		})
	end

	return nil
end

return CommentsListFooterView
