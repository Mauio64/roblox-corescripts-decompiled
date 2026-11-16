local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Localization")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/UIBlox")

local view = Foundation.View
local useLocalization = Localization.Hooks.useLocalization
local emptyState = UIBlox.App.Indicator.EmptyState

local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Common/TextKeys")

local function AssetPickerErrorBody(p2)
	local v5 = useLocalization({ failedMessage = TextKeys.SomethingWentWrong })

	return React.createElement(
		view,
		{
			tag = "size-full-0 auto-y padding-bottom-xxlarge",
			LayoutOrder = p2.layoutOrder
		},
		{
			EmptyState = React.createElement(emptyState, {
				text = v5.failedMessage,
				onActivated = p2.onRetry,
				size = UDim2.new(1, 0, 0, 187),
				position = UDim2.fromOffset(0, 0),
				anchorPoint = Vector2.new(0, 0)
			})
		}
	)
end

return AssetPickerErrorBody
