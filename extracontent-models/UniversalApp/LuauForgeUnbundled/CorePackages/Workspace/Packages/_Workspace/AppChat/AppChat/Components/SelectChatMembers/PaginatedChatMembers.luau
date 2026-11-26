local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")

local flatList = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/VirtualizedList").FlatList

local defineFastInt = game:DefineFastInt("AppChatPerfChatMembersPaginationWindowSize", 2)

local defineFastInt2 = game:DefineFastInt("AppChatPerfChatMembersPaginationInitialRender", 8)

local defineFastInt3 = game:DefineFastInt("AppChatPerfChatMembersPaginationOnEndReachedUnits", 1)

local function fn(p2, p3)
	return (tostring(p2 or p3))
end

local paginatedChatMembers = {
	ScrollBarThickness = 0,
	Name = "PaginatedChatMembers",
	BackgroundTransparency = 1
}

local v5 = { BackgroundTransparency = 1 }

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

	local v9 = React.useCallback(function()
		if props.fetchMoreFriends then
			props.fetchMoreFriends()
		end
	end, { props.fetchMoreFriends })

	local createElement = React.createElement
	local view = Foundation.View

	local v12 = if props.headerText then React.createElement(Foundation.Text, {
		tag = "size-full-0 auto-y text-align-x-left text-align-y-bottom text-title-large padding-x-medium",
		Text = props.headerText,
		LayoutOrder = 1
	}) else nil
	return createElement(view, { tag = "size-full col gap-small" }, {
		Header = v12,
		ListContainer = React.createElement(Foundation.View, {
			LayoutOrder = 2,
			tag = "size-full-0 fill"
		}, {
			List = React.createElement(flatList, {
				style = paginatedChatMembers,
				contentContainerStyle = v5,
				renderItem = props.renderItem,
				data = props.userIds,
				windowSize = defineFastInt,
				initialNumToRender = defineFastInt2,
				onEndReachedThreshold = defineFastInt3,
				onEndReached = v9,
				keyExtractor = fn,
				ref = ref
			})
		})
	})
end

return React.memo(PaginatedChatMembers)
