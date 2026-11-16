local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local useTokens = Foundation.Hooks.useTokens

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization

local v5, v6 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/loadFoundationCloudAsset")("pictograms/alert")

function LUAUFORGE_MODULE_GLOBALS_hlY_GameCardError()
	local v7 = useTokens()
	local v8 = useLocalization({
		contentLoadingFailed = "Feature.Chat.Label.ContentLoadingFailed"
	})

	return React.createElement(
		Foundation.View,
		{
			tag = "size-full-0 auto-xy bg-action-subtle align-x-center col padding-xxlarge"
		},
		{
			LoadingFailedImage = React.createElement(Foundation.Image, {
				Image = v5,
				imageStyle = v7.Color.System.Contrast,
				tag = "size-1600",
				ScaleType = Enum.ScaleType.Fit
			}),
			LoadingFailedText = React.createElement(Foundation.Text, {
				tag = "auto-xy text-wrap",
				Text = v8.contentLoadingFailed,
				textStyle = v7.Color.System.Contrast,
				fontStyle = v7.Typography.BodyLarge,
				LayoutOrder = 2
			})
		}
	)
end

return React.memo(LUAUFORGE_MODULE_GLOBALS_hlY_GameCardError)
