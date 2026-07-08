local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local FlatList = require(Parent.VirtualizedList).FlatList
local v5 = game:DefineFastInt("AppChatPerfChatMembersPaginationWindowSize", 2)
local v6 = game:DefineFastInt("AppChatPerfChatMembersPaginationInitialRender", 8)
local v7 = game:DefineFastInt("AppChatPerfChatMembersPaginationOnEndReachedUnits", 1)

local function v8(p1, p2) -- line: 22
	return (tostring(p1 or p2))
end

local t1 = {
	ScrollBarThickness = 0,
	Name = "PaginatedChatMembers",
	BackgroundTransparency = 1
}
local t2 = {
	BackgroundTransparency = 1
}

local function PaginatedChatMembers(t3: {[any]: any}) -- line: 35
	-- upvalues: React (copy), v5 (copy), v6 (copy), v7 (copy), Foundation (copy), FlatList (copy), t1 (copy), t2 (copy), v8 (copy)
	local v15 = React.useRef(nil)

	React.useEffect(function() -- line: 38
		-- upvalues: v15 (copy)
		if v15.current then
			local v20 = v15.current:getNativeScrollRef()

			if v20 and v20._nativeRef and v20._nativeRef.current then
				v20._nativeRef.current.Selectable = false
			end
		end
	end, {})

	local v16 = v5
	local v17 = v6
	local v18 = v7
	local v19 = React.useCallback(function() -- line: 51
		-- upvalues: t3 (copy)
		if t3.fetchMoreFriends then
			t3.fetchMoreFriends()
		end
	end, { t3.fetchMoreFriends })

	return React.createElement(Foundation.View, {
		tag = "size-full col gap-small"
	}, {
		Header = if not t3.headerText then nil else React.createElement(Foundation.Text, {
			tag = "size-full-0 auto-y text-align-x-left text-align-y-bottom text-title-large padding-x-medium",
			LayoutOrder = 1,
			Text = t3.headerText
		}),
		ListContainer = React.createElement(Foundation.View, {
			LayoutOrder = 2,
			tag = "size-full-0 fill"
		}, {
			List = React.createElement(FlatList, {
				style = t1,
				contentContainerStyle = t2,
				renderItem = t3.renderItem,
				data = t3.userIds,
				windowSize = v16,
				initialNumToRender = v17,
				onEndReachedThreshold = v18,
				onEndReached = v19,
				keyExtractor = v8,
				ref = v15
			})
		})
	})
end

return React.memo(PaginatedChatMembers)
