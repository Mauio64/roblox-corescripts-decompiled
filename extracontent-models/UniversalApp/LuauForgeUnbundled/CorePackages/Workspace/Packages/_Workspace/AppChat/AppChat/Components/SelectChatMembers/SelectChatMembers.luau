local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local useStyle = UIBlox.Core.Style.useStyle
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization

local useDebouncedUserSearch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/SelectChatMembers/Utils/useDebouncedUserSearch")
local UserCellWithCheckbox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/SelectChatMembers/UserCellWithCheckbox")
local PaginatedChatMembers = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/SelectChatMembers/PaginatedChatMembers")
local SelectedMembersBar = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/SelectChatMembers/SelectedMembersBar")
local FFlagDebugAppChatEnableDomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagDebugAppChatEnableDomLocators")
local DomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/DomLocators")

local function renderUserEntry(item, p2, p3, p4, p5)
	local v5 = if p2 then "search_" .. item else item

	return React.createElement(Foundation.View, { tag = "size-full-0 auto-y", key = v5 }, {
		cellContent = React.createElement(UserCellWithCheckbox, { style = p4, userId = item }),
		debugId = p3.isDebugEnabled and React.createElement(Foundation.Text, {
			tag = "auto-xy position-bottom-right anchor-bottom-right",
			Text = item
		}) or nil
	})
end

local function SelectChatMembers(props)
	local v5 = useLocalization({ suggested = "Feature.Friends.Label.Suggested" })

	local v6 = useStyle()
	local v7 = useTextSizeOffset()
	local v8, v9, v10 = useDebouncedUserSearch(props.conversation)
	local ref = React.useRef(nil)
	local v11 = React.useCallback(function()
		v9("")

		if ref and ref.current then
			ref.current.focus()
		end
	end, { v9 })
	local v12 = v10 ~= ""
	local v13 = React.useCallback(function(p2)
		return renderUserEntry(p2.item, v12, { isDebugEnabled = props.isDebugEnabled }, v6, v7)
	end, { props.isDebugEnabled, v12, v6, v7 })

	local shouldShowSelectChatMembersBar = props.shouldShowSelectChatMembersBar
	local createElement = React.createElement
	local view = Foundation.View

	local createElement2 = React.createElement
	local view2 = Foundation.View

	local v16 = {
		selectedMembersBar = shouldShowSelectChatMembersBar and React.createElement(SelectedMembersBar, {
			LayoutOrder = 1
		}) or nil,
		searchBar = 0
	}

	local createElement3 = React.createElement
	local textInput = Foundation.TextInput
	local v17 = {
		tag = "size-full-0 auto-y",
		LayoutOrder = 2,
		label = "",
		text = v10,
		width = UDim.new(1, 0),
		placeholder = props.searchFriendsText,
		leadingIcon = "icons/actions/friend_sort/search_people",
		onChanged = v9,
		iconTrailing = v12 and {
			name = Foundation.Enums.IconName.CircleX,
			onActivated = v11
		} or nil,
		textBoxRef = ref,
		testId = 0
	}

	local v18 = if FFlagDebugAppChatEnableDomLocators then DomLocators.selectChatMembersSearchInput(v10) else nil
	v17.testId = v18
	v16.searchBar = createElement3(textInput, v17)
	local children = {
		TopSection = createElement2(
			view2,
			{
				tag = "col size-full-0 auto-y gap-small padding-x-medium",
				LayoutOrder = 1
			},
			v16
		),
		friendsList = 0
	}

	local createElement4 = React.createElement
	local view3 = Foundation.View

	local createElement5 = React.createElement

	if not v12 then
		v8 = props.friendIds
	end

	local v23 = if not v12 then props.fetchMoreFriends else nil
	local v24 = if not v12 then v5.suggested else nil
	children.friendsList = createElement4(view3, {
		LayoutOrder = 3,
		tag = "size-full-0 fill"
	}, {
		paginatedFriendsList = createElement5(PaginatedChatMembers, {
			userIds = v8,
			renderItem = v13,
			fetchMoreFriends = v23,
			headerText = v24
		})
	})
	return createElement(view, { tag = "size-full col gap-small bg-surface-0" }, children)
end

return React.memo(SelectChatMembers)
