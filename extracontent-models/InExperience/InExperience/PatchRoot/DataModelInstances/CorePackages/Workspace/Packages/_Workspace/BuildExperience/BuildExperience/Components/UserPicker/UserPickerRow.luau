local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local useUserProfileInfo = require(script.Parent.useUserProfileInfo)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local Icon = Foundation.Icon
local List = Foundation.List
local View = Foundation.View

local useTokens = Foundation.Hooks.useTokens

local AccessoryType = Foundation.Enums.AccessoryType
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize

local function UserPickerRow(props)
	local v = useUserProfileInfo(props.userId)
	local v2 = useLocalization({
		unknownUser = LocalizationStrings.PRIVATE_INVITES_UNKNOWN_USER,
		username = {
			LocalizationStrings.USER_PICKER_USERNAME,
			USERNAME = v.username
		}
	})

	local title = v2.unknownUser
	local username = v2.username
	local v3 = useTokens()
	local trailing

	if props.isSelected then
		trailing = React.createElement(Icon, {
			name = IconName.CheckLarge,
			size = IconSize.Medium,
			style = v3.Color.Content.Emphasis
		})
	end

	local createElement = React.createElement
	local item = List.Item
	local v4 = {
		leading = { type = AccessoryType.Avatar, userId = props.userId },
		title = 0,
		description = 0,
		trailing = 0
	}

	if v.displayName ~= "" then
		title = v.displayName
	end

	v4.title = title
	v4.description = username
	v4.trailing = trailing
	local element = createElement(item, v4)

	local createElement2 = React.createElement
	local v5 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}
	local scrim

	if props.isDisabled then
		scrim = React.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = v3.Color.Surface.Surface_100.Color3,
			BackgroundTransparency = 0.5,
			BorderSizePixel = 0,
			ZIndex = 2
		})
	end

	local element2 = createElement2("Frame", v5, { Item = element, Scrim = scrim })

	return React.createElement(View, {
		LayoutOrder = props.layoutOrder,
		onActivated = props.onToggle,
		stateLayer = {},
		isDisabled = props.isDisabled,
		tag = "size-full-0 auto-y",
		testId = props.testId
	}, { Item = element2 })
end

return UserPickerRow
