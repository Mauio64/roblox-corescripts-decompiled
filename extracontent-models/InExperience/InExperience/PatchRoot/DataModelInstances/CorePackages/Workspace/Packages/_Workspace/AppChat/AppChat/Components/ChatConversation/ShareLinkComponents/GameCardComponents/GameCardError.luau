local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local useTokens = Foundation.Hooks.useTokens

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local loadFoundationCloudAsset = require(AppChat.Utils.loadFoundationCloudAsset)

local image, _ = loadFoundationCloudAsset("pictograms/alert")

function GameCardError()
	local v = useTokens()
	local v2 = useLocalization({ contentLoadingFailed = "Feature.Chat.Label.ContentLoadingFailed" })

	return React.createElement(
		Foundation.View,
		{ tag = "size-full-0 auto-xy bg-action-subtle align-x-center col padding-xxlarge" },
		{
			LoadingFailedImage = React.createElement(Foundation.Image, {
				Image = image,
				imageStyle = v.Color.System.Contrast,
				tag = "size-1600",
				ScaleType = Enum.ScaleType.Fit
			}),
			LoadingFailedText = React.createElement(Foundation.Text, {
				tag = "auto-xy text-wrap",
				Text = v2.contentLoadingFailed,
				textStyle = v.Color.System.Contrast,
				fontStyle = v.Typography.BodyLarge,
				LayoutOrder = 2
			})
		}
	)
end

return React.memo(GameCardError)
