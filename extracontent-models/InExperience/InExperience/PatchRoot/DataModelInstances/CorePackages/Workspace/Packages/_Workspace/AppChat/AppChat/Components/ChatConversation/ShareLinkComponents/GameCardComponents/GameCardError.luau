local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Foundation = require(AppChatParent.Foundation)
local React = require(AppChatParent.React)
local useTokens = Foundation.Hooks.useTokens
local useLocalization = require(AppChatParent.Localization).Hooks.useLocalization
local v7, _ = require(AppChat.Utils.loadFoundationCloudAsset)("pictograms/alert")

function GameCardError() -- line: 14
	-- upvalues: useTokens (copy), useLocalization (copy), React (copy), Foundation (copy), v7 (copy)
	local v9 = useTokens()
	local v10 = useLocalization({
		contentLoadingFailed = "Feature.Chat.Label.ContentLoadingFailed"
	})

	return React.createElement(Foundation.View, {
		tag = "size-full-0 auto-xy bg-action-subtle align-x-center col padding-xxlarge"
	}, {
		LoadingFailedImage = React.createElement(Foundation.Image, {
			tag = "size-1600",
			Image = v7,
			imageStyle = v9.Color.System.Contrast,
			ScaleType = Enum.ScaleType.Fit
		}),
		LoadingFailedText = React.createElement(Foundation.Text, {
			tag = "auto-xy text-wrap",
			LayoutOrder = 2,
			Text = v10.contentLoadingFailed,
			textStyle = v9.Color.System.Contrast,
			fontStyle = v9.Typography.BodyLarge
		})
	})
end

return React.memo(GameCardError)
