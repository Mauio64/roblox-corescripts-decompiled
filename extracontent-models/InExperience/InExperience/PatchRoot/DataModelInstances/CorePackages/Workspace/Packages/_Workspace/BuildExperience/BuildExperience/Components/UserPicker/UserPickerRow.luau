local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local useUserProfileInfo = require(script.Parent.useUserProfileInfo)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local Icon = Foundation.Icon
local List = Foundation.List
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local AccessoryType = Foundation.Enums.AccessoryType
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize

local function UserPickerRow(t1: {[any]: any}) -- line: 35
	-- upvalues: useTokens (copy), useUserProfileInfo (copy), React (copy), Icon (copy), IconName (copy), IconSize (copy), List (copy), AccessoryType (copy), LocalizationStrings (copy), View (copy)
	local v16 = useTokens()
	local v17 = useUserProfileInfo(t1.userId)
	local v18 = if not t1.isSelected then nil else React.createElement(Icon, {
		name = IconName.CheckLarge,
		size = IconSize.Medium,
		style = v16.Color.Content.Emphasis
	})
	local v19 = React.createElement(List.Item, {
		leading = {
			type = AccessoryType.Avatar,
			userId = t1.userId
		},
		title = if v17.displayName == "" then LocalizationStrings.PRIVATE_INVITES_UNKNOWN_USER else v17.displayName,
		description = LocalizationStrings.formatUserPickerUsername(v17.username),
		trailing = v18
	})
	local v20 = React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		Item = v19,
		Scrim = if not t1.isDisabled then nil else React.createElement("Frame", {
			BackgroundTransparency = 0.5,
			BorderSizePixel = 0,
			ZIndex = 2,
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = v16.Color.Surface.Surface_100.Color3
		})
	})

	return React.createElement(View, {
		tag = "size-full-0 auto-y",
		LayoutOrder = t1.layoutOrder,
		onActivated = t1.onToggle,
		stateLayer = {},
		isDisabled = t1.isDisabled,
		testId = t1.testId
	}, {
		Item = v20
	})
end

return UserPickerRow
