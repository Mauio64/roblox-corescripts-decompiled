local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local useUserProfileInfo = require(script.Parent.useUserProfileInfo)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local IconButton = Foundation.IconButton
local List = Foundation.List
local Loading = Foundation.Loading
local View = Foundation.View

local useTokens = Foundation.Hooks.useTokens

local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local AccessoryType = Foundation.Enums.AccessoryType

local function PickedUserRow(props)
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
	local size_1000 = useTokens().Size.Size_1000
	local trailing

	if props.isRemoving then
		trailing = React.createElement(
			View,
			{
				Size = UDim2.fromOffset(size_1000, size_1000),
				tag = "align-x-center align-y-center",
				testId = `{props.testId}-removing`
			},
			{
				Spinner = React.createElement(Loading, { size = IconSize.Small })
			}
		)
	else
		trailing = React.createElement(IconButton, {
			icon = IconName.TrashCan,
			onActivated = function()
				props.onRemove(props.userId)
			end,
			testId = `{props.testId}-remove`
		})
	end

	local createElement = React.createElement
	local item = List.Item
	local v3 = {
		LayoutOrder = props.LayoutOrder,
		leading = { type = AccessoryType.Avatar, userId = props.userId },
		title = 0,
		description = 0,
		trailing = 0,
		testId = 0
	}

	if v.displayName ~= "" then
		title = v.displayName
	end

	v3.title = title
	v3.description = username
	v3.trailing = trailing
	v3.testId = props.testId
	return createElement(item, v3)
end

return PickedUserRow
