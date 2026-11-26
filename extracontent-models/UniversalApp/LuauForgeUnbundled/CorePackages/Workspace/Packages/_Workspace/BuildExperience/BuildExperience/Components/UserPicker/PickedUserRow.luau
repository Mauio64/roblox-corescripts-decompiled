local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization

local useUserProfileInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/UserPicker/useUserProfileInfo")
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local iconButton = Foundation.IconButton
local list = Foundation.List
local loading = Foundation.Loading
local view = Foundation.View

local useTokens = Foundation.Hooks.useTokens

local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local accessoryType = Foundation.Enums.AccessoryType

local function PickedUserRow(props)
	local v5 = useUserProfileInfo(props.userId)
	local v6 = useLocalization({
		unknownUser = LocalizationStrings.PRIVATE_INVITES_UNKNOWN_USER,
		username = {
			LocalizationStrings.USER_PICKER_USERNAME,
			USERNAME = v5.username
		}
	})

	local v7 = v6.unknownUser
	local username = v6.username
	local size_1000 = useTokens().Size.Size_1000
	local v8

	if props.isRemoving then
		v8 = React.createElement(
			view,
			{
				Size = UDim2.fromOffset(size_1000, size_1000),
				tag = "align-x-center align-y-center",
				testId = `{props.testId}-removing`
			},
			{
				Spinner = React.createElement(loading, { size = iconSize.Small })
			}
		)
	else
		v8 = React.createElement(iconButton, {
			icon = iconName.TrashCan,
			onActivated = function()
				props.onRemove(props.userId)
			end,
			testId = `{props.testId}-remove`
		})
	end

	local createElement = React.createElement
	local item = list.Item
	local v9 = {
		LayoutOrder = props.LayoutOrder,
		leading = { type = accessoryType.Avatar, userId = props.userId },
		title = 0,
		description = 0,
		trailing = 0,
		testId = 0
	}

	if v5.displayName ~= "" then
		v7 = v5.displayName
	end

	v9.title = v7
	v9.description = username
	v9.trailing = v8
	v9.testId = props.testId
	return createElement(item, v9)
end

return PickedUserRow
