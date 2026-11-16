local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local UIBlox = require(parent.UIBlox)

local View = Foundation.View
local useLocalization = Localization.Hooks.useLocalization
local EmptyState = UIBlox.App.Indicator.EmptyState

local TextKeys = require(AvatarExperienceProfilePictureEditor.Common.TextKeys)

local function AssetPickerErrorBody(p)
	local v = useLocalization({ failedMessage = TextKeys.SomethingWentWrong })

	return React.createElement(
		View,
		{ tag = "size-full-0 auto-y padding-bottom-xxlarge", LayoutOrder = p.layoutOrder },
		{
			EmptyState = React.createElement(EmptyState, {
				text = v.failedMessage,
				onActivated = p.onRetry,
				size = UDim2.new(1, 0, 0, 187),
				position = UDim2.fromOffset(0, 0),
				anchorPoint = Vector2.new(0, 0)
			})
		}
	)
end

return AssetPickerErrorBody
