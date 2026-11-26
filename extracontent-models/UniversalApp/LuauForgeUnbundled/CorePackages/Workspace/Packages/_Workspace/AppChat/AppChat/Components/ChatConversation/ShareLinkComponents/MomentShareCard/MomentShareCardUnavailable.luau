local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization

local v5, v6 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/loadFoundationCloudAsset")("pictograms/alert")

local function MomentShareCardUnavailable()
	local v7 = useLocalization({
		momentUnavailable = "Feature.Moments.Label.MomentUnavailableDefault"
	})

	return React.createElement(
		Foundation.View,
		{
			tag = "col align-x-center size-full-0 auto-xy padding-xxlarge bg-action-subtle",
			testId = "MomentShareCardUnavailable"
		},
		{
			UnavailableImage = React.createElement(Foundation.Image, {
				Image = v5,
				tag = "size-1600 content-system-contrast",
				ScaleType = Enum.ScaleType.Fit,
				testId = "MomentShareCardUnavailableImage",
				LayoutOrder = 1
			}),
			UnavailableText = React.createElement(Foundation.Text, {
				tag = "auto-xy text-body-large text-wrap text-align-x-center content-system-contrast",
				Text = v7.momentUnavailable,
				LayoutOrder = 2
			})
		}
	)
end

return React.memo(MomentShareCardUnavailable)
