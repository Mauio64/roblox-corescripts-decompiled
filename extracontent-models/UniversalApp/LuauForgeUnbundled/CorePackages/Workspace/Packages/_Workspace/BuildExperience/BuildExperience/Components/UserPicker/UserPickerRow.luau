local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization

local useUserProfileInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/UserPicker/useUserProfileInfo")
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local icon = Foundation.Icon
local list = Foundation.List
local view = Foundation.View

local useTokens = Foundation.Hooks.useTokens

local accessoryType = Foundation.Enums.AccessoryType
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize

local function UserPickerRow(props)
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
	local v8 = useTokens()
	local v9

	if props.isSelected then
		v9 = React.createElement(icon, {
			name = iconName.CheckLarge,
			size = iconSize.Medium,
			style = v8.Color.Content.Emphasis
		})
	end

	local createElement = React.createElement
	local item = list.Item
	local v10 = {
		leading = { type = accessoryType.Avatar, userId = props.userId },
		title = 0,
		description = 0,
		trailing = 0
	}

	if v5.displayName ~= "" then
		v7 = v5.displayName
	end

	v10.title = v7
	v10.description = username
	v10.trailing = v9
	local element = createElement(item, v10)

	local createElement2 = React.createElement
	local v12 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}

	local v14 = if props.isDisabled then React.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = v8.Color.Surface.Surface_100.Color3,
		BackgroundTransparency = 0.5,
		BorderSizePixel = 0,
		ZIndex = 2
	}) else nil
	local element2 = createElement2("Frame", v12, { Item = element, Scrim = v14 })

	return React.createElement(view, {
		LayoutOrder = props.layoutOrder,
		onActivated = props.onToggle,
		stateLayer = {},
		isDisabled = props.isDisabled,
		tag = "size-full-0 auto-y",
		testId = props.testId
	}, { Item = element2 })
end

return UserPickerRow
