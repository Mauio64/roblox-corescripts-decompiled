local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local Foundation = require(AppChatParent.Foundation)
local UIBlox = require(AppChatParent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local useLocalization = require(AppChatParent.Localization).Hooks.useLocalization
local useDebouncedUserSearch = require(script.Parent.Utils.useDebouncedUserSearch)
local UserCellWithCheckbox = require(script.Parent.UserCellWithCheckbox)
local PaginatedChatMembers = require(script.Parent.PaginatedChatMembers)
local SelectedMembersBar = require(script.Parent.SelectedMembersBar)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local DomLocators = require(AppChat.Utils.DomLocators)

local function renderUserEntry(s1: string, b1: boolean, t1: {[any]: any}, p1, _) -- line: 32
	-- upvalues: React (copy), Foundation (copy), UserCellWithCheckbox (copy)
	local v22 = if not b1 then s1 else "search_" .. s1

	return React.createElement(Foundation.View, {
		tag = "size-full-0 auto-y",
		key = v22
	}, {
		cellContent = React.createElement(UserCellWithCheckbox, {
			style = p1,
			userId = s1
		}),
		debugId = t1.isDebugEnabled and React.createElement(Foundation.Text, {
			tag = "auto-xy position-bottom-right anchor-bottom-right",
			Text = s1
		}) or nil
	})
end
local function SelectChatMembers(t2: {[any]: any}) -- line: 58
	-- upvalues: useLocalization (copy), useStyle (copy), useTextSizeOffset (copy), useDebouncedUserSearch (copy), React (copy), renderUserEntry (copy), Foundation (copy), SelectedMembersBar (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy), PaginatedChatMembers (copy)
	local v24 = useLocalization({
		suggested = "Feature.Friends.Label.Suggested"
	})
	local v25 = useStyle()
	local v26 = useTextSizeOffset()
	local v27, v28, v29 = useDebouncedUserSearch(t2.conversation)
	local v30 = React.useRef(nil)
	local v31 = React.useCallback(function() -- line: 66
		-- upvalues: v28 (copy), v30 (copy)
		v28("")

		if v30 and v30.current then
			v30.current.focus()
		end
	end, { v28 })
	local v32 = v29 ~= ""
	local v33 = React.useCallback(function(t3: {[any]: any}) -- line: 76
		-- upvalues: renderUserEntry (copy), v32 (copy), t2 (copy), v25 (copy), v26 (copy)
		local item = t3.item

		return renderUserEntry(item, v32, {
			isDebugEnabled = t2.isDebugEnabled
		}, v25, v26)
	end, {
		t2.isDebugEnabled,
		v32,
		v25,
		v26
	})
	local shouldShowSelectChatMembersBar = t2.shouldShowSelectChatMembersBar

	return React.createElement(Foundation.View, {
		tag = "size-full col gap-small bg-surface-0"
	}, {
		TopSection = React.createElement(Foundation.View, {
			tag = "col size-full-0 auto-y gap-small padding-x-medium",
			LayoutOrder = 1
		}, {
			selectedMembersBar = shouldShowSelectChatMembersBar and React.createElement(SelectedMembersBar, {
				LayoutOrder = 1
			}) or nil,
			searchBar = React.createElement(Foundation.TextInput, {
				tag = "size-full-0 auto-y",
				LayoutOrder = 2,
				label = "",
				leadingIcon = "icons/actions/friend_sort/search_people",
				text = v29,
				width = UDim.new(1, 0),
				placeholder = t2.searchFriendsText,
				onChanged = v28,
				iconTrailing = if not v32 then nil else {
					name = Foundation.Enums.IconName.CircleX,
					onActivated = v31
				},
				textBoxRef = v30,
				testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.selectChatMembersSearchInput(v29)
			})
		}),
		friendsList = React.createElement(Foundation.View, {
			LayoutOrder = 3,
			tag = "size-full-0 fill"
		}, {
			paginatedFriendsList = React.createElement(PaginatedChatMembers, {
				userIds = if not v32 then t2.friendIds else v27,
				renderItem = v33,
				fetchMoreFriends = if not v32 then t2.fetchMoreFriends else nil,
				headerText = if not v32 then v24.suggested else nil
			})
		})
	})
end

return React.memo(SelectChatMembers)
