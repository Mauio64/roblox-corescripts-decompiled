local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local loadFoundationCloudAsset = require(AppChat.Utils.loadFoundationCloudAsset)

local image, _ = loadFoundationCloudAsset("pictograms/alert")

local function MomentShareCardUnavailable()
	local v = useLocalization({
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
				Image = image,
				tag = "size-1600 content-system-contrast",
				ScaleType = Enum.ScaleType.Fit,
				testId = "MomentShareCardUnavailableImage",
				LayoutOrder = 1
			}),
			UnavailableText = React.createElement(Foundation.Text, {
				tag = "auto-xy text-body-large text-wrap text-align-x-center content-system-contrast",
				Text = v.momentUnavailable,
				LayoutOrder = 2
			})
		}
	)
end

return React.memo(MomentShareCardUnavailable)
