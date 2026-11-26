local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Foundation")
local FriendsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/FriendsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")
local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/SocialCommon")

require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/PeoplePicker/PeoplePickerList/PeoplePickerListView")

local icon = Foundation.Icon
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local useGetPresenceByUserId = FriendsCommon.Hooks.useGetPresenceByUserId
local convertToFoundationPresenceEnum = SocialCommon.Utils.convertToFoundationPresenceEnum

local function usePeoplePickerListItemViewModel(data)
	local v5 = useTokens()
	local v6

	if not (data.primaryUserId == "" or data.secondUserId ~= nil) then
		v6 = data.primaryUserId
	end

	local v7 = useGetPresenceByUserId(v6)
	local v8

	if v7 and v7.userPresenceType then
		v8 = convertToFoundationPresenceEnum(v7.userPresenceType)
	else
		v8 = Foundation.Enums.UserPresence.None
	end

	local isLoading = data.isLoading == true

	local testId = data.testId or "people-picker-list-item"
	local isSelected = data.isSelected

	local v9 = React.useMemo(function()
		if isSelected then
			return React.createElement(icon, {
				name = iconName.Check,
				size = iconSize.Large,
				style = v5.Color.Content.Emphasis,
				testId = `{testId}--selected-check`
			})
		end

		return nil
	end, { isSelected, testId, v5 })

	return {
		leading = {
			type = "Avatar",
			userId = data.primaryUserId,
			secondUserId = data.secondUserId,
			userPresence = v8
		},
		trailing = v9,
		title = data.title,
		description = data.description,
		isLoading = isLoading,
		onActivated = data.onActivated,
		testId = testId
	}
end

return usePeoplePickerListItemViewModel
