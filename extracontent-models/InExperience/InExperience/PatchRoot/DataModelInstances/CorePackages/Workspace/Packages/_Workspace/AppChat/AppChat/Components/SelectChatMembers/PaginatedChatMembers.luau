local parent = script:FindFirstAncestor("AppChat").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)

local VirtualizedList = require(parent.VirtualizedList)
local FlatList = VirtualizedList.FlatList

local defineFastInt = game:DefineFastInt("AppChatPerfChatMembersPaginationWindowSize", 2)

local defineFastInt2 = game:DefineFastInt("AppChatPerfChatMembersPaginationInitialRender", 8)

local defineFastInt3 = game:DefineFastInt("AppChatPerfChatMembersPaginationOnEndReachedUnits", 1)

local function fn(p, p2)
	return (tostring(p or p2))
end

local paginatedChatMembers = {
	ScrollBarThickness = 0,
	Name = "PaginatedChatMembers",
	BackgroundTransparency = 1
}

local contentContainerStyle = { BackgroundTransparency = 1 }

local function PaginatedChatMembers(props)
	local ref = React.useRef(nil)

	React.useEffect(function()
		if ref.current then
			local nativeScrollRef = ref.current:getNativeScrollRef()

			if nativeScrollRef and nativeScrollRef._nativeRef and nativeScrollRef._nativeRef.current then
				nativeScrollRef._nativeRef.current.Selectable = false
			end
		end
	end, {})

	local onEndReached = React.useCallback(function()
		if props.fetchMoreFriends then
			props.fetchMoreFriends()
		end
	end, { props.fetchMoreFriends })

	local createElement = React.createElement
	local view = Foundation.View
	local header

	if props.headerText then
		header = React.createElement(Foundation.Text, {
			tag = "size-full-0 auto-y text-align-x-left text-align-y-bottom text-title-large padding-x-medium",
			Text = props.headerText,
			LayoutOrder = 1
		})
	end

	return createElement(view, { tag = "size-full col gap-small" }, {
		Header = header,
		ListContainer = React.createElement(Foundation.View, {
			LayoutOrder = 2,
			tag = "size-full-0 fill"
		}, {
			List = React.createElement(FlatList, {
				style = paginatedChatMembers,
				contentContainerStyle = contentContainerStyle,
				renderItem = props.renderItem,
				data = props.userIds,
				windowSize = defineFastInt,
				initialNumToRender = defineFastInt2,
				onEndReachedThreshold = defineFastInt3,
				onEndReached = onEndReached,
				keyExtractor = fn,
				ref = ref
			})
		})
	})
end

return React.memo(PaginatedChatMembers)
