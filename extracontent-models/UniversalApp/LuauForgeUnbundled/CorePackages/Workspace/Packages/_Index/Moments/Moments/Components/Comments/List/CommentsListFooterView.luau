local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local useLocalization = Localization.Hooks.useLocalization

local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize
local progressShape = Foundation.Enums.ProgressShape
local progressSize = Foundation.Enums.ProgressSize

local v5 = { retry = "Feature.Moments.Action.RetryLoadingComments" }

local function CommentsListFooterView(props)
	local v6 = useLocalization(v5)

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
					shape = progressShape.Circle,
					size = progressSize.Medium,
					testId = "moments-comments-load-more-spinner"
				})
			}
		)
	end

	if props.status == "Failed" then
		return React.createElement(Foundation.Button, {
			LayoutOrder = props.LayoutOrder,
			text = v6.retry,
			onActivated = props.onRetry,
			size = inputSize.Small,
			variant = buttonVariant.Standard,
			testId = "moments-comments-load-more-retry"
		})
	end

	return nil
end

return CommentsListFooterView
