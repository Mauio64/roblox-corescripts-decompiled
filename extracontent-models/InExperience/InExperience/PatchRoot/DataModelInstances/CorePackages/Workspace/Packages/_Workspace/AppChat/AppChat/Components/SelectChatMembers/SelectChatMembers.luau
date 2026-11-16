local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local useDebouncedUserSearch = require(script.Parent.Utils.useDebouncedUserSearch)
local UserCellWithCheckbox = require(script.Parent.UserCellWithCheckbox)
local PaginatedChatMembers = require(script.Parent.PaginatedChatMembers)
local SelectedMembersBar = require(script.Parent.SelectedMembersBar)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local DomLocators = require(AppChat.Utils.DomLocators)

local function renderUserEntry(item: string, flag: boolean, p, style, _)
	local v

	if flag then
		v = "search_" .. item
	else
		v = item
	end

	return React.createElement(Foundation.View, { tag = "size-full-0 auto-y", key = v }, {
		cellContent = React.createElement(UserCellWithCheckbox, { style = style, userId = item }),
		debugId = p.isDebugEnabled and React.createElement(Foundation.Text, {
			tag = "auto-xy position-bottom-right anchor-bottom-right",
			Text = item
		}) or nil
	})
end

local function SelectChatMembers(props)
	local v = useLocalization({ suggested = "Feature.Friends.Label.Suggested" })

	local style = useStyle()
	local v2 = useTextSizeOffset()
	local userIds, onChanged, text = useDebouncedUserSearch(props.conversation)
	local ref = React.useRef(nil)
	local onActivated = React.useCallback(function()
		onChanged("")

		if ref and ref.current then
			ref.current.focus()
		end
	end, { onChanged })
	local v3 = text ~= ""
	local renderItem = React.useCallback(function(p)
		return renderUserEntry(p.item, v3, { isDebugEnabled = props.isDebugEnabled }, style, v2)
	end, { props.isDebugEnabled, v3, style, v2 })

	local shouldShowSelectChatMembersBar = props.shouldShowSelectChatMembersBar
	local createElement = React.createElement
	local view = Foundation.View

	local createElement2 = React.createElement
	local view2 = Foundation.View

	local v4 = {
		selectedMembersBar = shouldShowSelectChatMembersBar and React.createElement(SelectedMembersBar, {
			LayoutOrder = 1
		}) or nil,
		searchBar = 0
	}

	local createElement3 = React.createElement
	local textInput = Foundation.TextInput
	local v5 = {
		tag = "size-full-0 auto-y",
		LayoutOrder = 2,
		label = "",
		text = text,
		width = UDim.new(1, 0),
		placeholder = props.searchFriendsText,
		leadingIcon = "icons/actions/friend_sort/search_people",
		onChanged = onChanged,
		iconTrailing = v3 and {
			name = Foundation.Enums.IconName.CircleX,
			onActivated = onActivated
		} or nil,
		textBoxRef = ref,
		testId = 0
	}
	local testId

	if FFlagDebugAppChatEnableDomLocators then
		testId = DomLocators.selectChatMembersSearchInput(text)
	end

	v5.testId = testId
	v4.searchBar = createElement3(textInput, v5)
	local children = {
		TopSection = createElement2(
			view2,
			{ tag = "col size-full-0 auto-y gap-small padding-x-medium", LayoutOrder = 1 },
			v4
		),
		friendsList = 0
	}

	local createElement4 = React.createElement
	local view3 = Foundation.View

	local createElement5 = React.createElement

	if not v3 then
		userIds = props.friendIds
	end

	local fetchMoreFriends

	if not v3 then
		fetchMoreFriends = props.fetchMoreFriends
	end

	local headerText

	if not v3 then
		headerText = v.suggested
	end

	children.friendsList = createElement4(view3, { LayoutOrder = 3, tag = "size-full-0 fill" }, {
		paginatedFriendsList = createElement5(PaginatedChatMembers, {
			userIds = userIds,
			renderItem = renderItem,
			fetchMoreFriends = fetchMoreFriends,
			headerText = headerText
		})
	})
	return createElement(view, { tag = "size-full col gap-small bg-surface-0" }, children)
end

return React.memo(SelectChatMembers)
