local LocalizationService = game:GetService("LocalizationService")
local UserInputService = game:GetService("UserInputService")

local module = require("@luauforge/bundled/hwN")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceShop/React")
local module3 = require("@luauforge/bundled/hwG")

local module4 = require("@luauforge/bundled/hwC")
local module5 = require("@luauforge/bundled/hwH")
local module6 = require("@luauforge/bundled/hyb")
require("@luauforge/bundled/hxY")
require("@luauforge/bundled/hyc")
local module7 = require("@luauforge/bundled/hyd")
require("@luauforge/bundled/hye")
local module8 = require("@luauforge/bundled/hyg")
local module9 = require("@luauforge/bundled/hyj")
local module10 = require("@luauforge/bundled/hwS")
local module11 = require("@luauforge/bundled/hwU")

local useLocalization = module.Hooks.useLocalization
local numberLocalization = module.NumberLocalization

local function stripWhitespace(value)
	return (string.gsub(value, "%s", ""))
end

local function releaseKeyboard()
	local focusedTextBox = UserInputService:GetFocusedTextBox()

	if focusedTextBox then
		focusedTextBox:ReleaseFocus()
	end
end

local function toRows(items, profiles, p2)
	local rows = {}

	for k, item in items do
		local v5 = profiles[item.userId]
		local v6 = {
			userId = item.userId,
			displayName = item.displayName,
			username = 0,
			hasVerifiedBadge = 0,
			isRobloxPlus = 0
		}
		local v7 = if p2 then item.username else nil
		v6.username = v7
		v6.hasVerifiedBadge = item.hasVerifiedBadge
		v6.isRobloxPlus = v5 ~= nil and v5.isRobloxPlus
		table.insert(rows, v6)
	end

	return rows
end

local function useSendRobuxSheetViewModel(p2)
	local onClosed = p2.onClosed
	local friends = p2.friends

	local state, setState = React.useState(true)
	local state2, setState2 = React.useState("")
	local ref = React.useRef(nil)

	local v5 = module3.useSignalState(module11().getSignal(module4.PageScopeFieldRobuxBalance))

	local v6 = module9(state2)
	local v7 = module7({
		query = state2,
		friends = friends.friends,
		isLoadingFriends = friends.isLoading,
		search = v6
	})

	local v8 = useLocalization({
		title = "Features.Transfers.RobuxTransfer.Heading.SendRobux",
		search = "Feature.BuyRobux.Label.Search",
		noResults = "CommonUI.Controls.NoResultsFound",
		friendsHeading = {
			"Feature.BuyRobux.Label.MyFriendsWithCount",
			count = #v7.friends
		},
		peopleHeading = {
			"Feature.BuyRobux.Label.PeopleWithCount",
			count = #v7.people
		}
	})

	local v9 = React.useMemo(function()
		local userIds = {}

		for k, person in v7.people do
			table.insert(userIds, person.userId)
		end

		return userIds
	end, { v7.people })
	local profiles = module8(v9).profiles

	local v10 = React.useCallback(function()
		local focusedTextBox = UserInputService:GetFocusedTextBox()

		if focusedTextBox then
			focusedTextBox:ReleaseFocus()
		end

		setState(false)
	end, {})

	local v11 = React.useCallback(function(p3)
		local v12 = table.find(v9, p3) and "search" or "friends_list"

		if v12 == "search" then
			module5.trackCounter("UserSearchUserSelected")
		end

		ref.current = { userId = p3, source = v12 }
		v10()
	end, { v10, v9 })

	local v12 = React.useCallback(function()
		local current = ref.current

		if current then
			onClosed(current.userId, current.source)
		else
			onClosed(nil)
		end
	end, { onClosed })

	local v13 = React.useCallback(function(value)
		setState2((string.sub(string.gsub(value, "%s", ""), 1, module6.SearchMaxCharacters)))
	end, {})

	local v14 = {
		isOpen = state,
		onSheetClosed = v12,
		focusRef = module10(v10),
		title = v8.title,
		balanceText = 0,
		searchText = 0,
		searchPlaceholder = 0,
		onSearchChanged = 0,
		onClose = 0,
		friends = 0,
		people = 0,
		noResultsText = 0,
		onRecipientSelected = 0
	}

	local v15 = if v5 ~= nil then numberLocalization.localize(v5, LocalizationService.RobloxLocaleId) else nil
	v14.balanceText = v15

	v14.searchText = state2
	v14.searchPlaceholder = v8.search
	v14.onSearchChanged = v13
	v14.onClose = v10
	v14.friends = v7.showFriends and {
		heading = v8.friendsHeading,
		rows = toRows(v7.friends, friends.profiles, false),
		showSkeleton = friends.isLoading and #v7.friends == 0
	} or nil

	v14.people = v7.showPeople
		and {
			heading = v8.peopleHeading,
			rows = toRows(v7.people, profiles, true),
			showSkeleton = false
		}
		or nil

	local v16 = if v7.showNoResults then v8.noResults else nil
	v14.noResultsText = v16
	v14.onRecipientSelected = v11
	return v14
end

return useSendRobuxSheetViewModel
