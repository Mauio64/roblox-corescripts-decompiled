local parent = script:FindFirstAncestor("ShareSheet").Parent

local Foundation = require(parent.Foundation)
local FriendsCommon = require(parent.FriendsCommon)
local React = require(parent.React)
local SocialCommon = require(parent.SocialCommon)

require(script.Parent.PeoplePickerListView)

local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local useGetPresenceByUserId = FriendsCommon.Hooks.useGetPresenceByUserId
local convertToFoundationPresenceEnum = SocialCommon.Utils.convertToFoundationPresenceEnum

local function usePeoplePickerListItemViewModel(data)
	local v = useTokens()
	local v2

	if not (data.primaryUserId == "" or data.secondUserId ~= nil) then
		v2 = data.primaryUserId
	end

	local v3 = useGetPresenceByUserId(v2)
	local userPresence

	if v3 and v3.userPresenceType then
		userPresence = convertToFoundationPresenceEnum(v3.userPresenceType)
	else
		userPresence = Foundation.Enums.UserPresence.None
	end

	local isLoading = data.isLoading == true

	local testId = data.testId or "people-picker-list-item"
	local isSelected = data.isSelected

	local trailing = React.useMemo(function()
		if isSelected then
			return React.createElement(Icon, {
				name = IconName.Check,
				size = IconSize.Large,
				style = v.Color.Content.Emphasis,
				testId = `{testId}--selected-check`
			})
		end

		return nil
	end, { isSelected, testId, v })

	return {
		leading = {
			type = "Avatar",
			userId = data.primaryUserId,
			secondUserId = data.secondUserId,
			userPresence = userPresence
		},
		trailing = trailing,
		title = data.title,
		description = data.description,
		isLoading = isLoading,
		onActivated = data.onActivated,
		testId = testId
	}
end

return usePeoplePickerListItemViewModel
