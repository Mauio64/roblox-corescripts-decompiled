local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local Foundation = require(AppChatParent.Foundation)
local useStyle = require(AppChatParent.UIBlox).Core.Style.useStyle
local useSignalState = require(AppChatParent.SignalsReact).useSignalState
local FriendCountLabel = require(script.Parent.FriendCountLabel)
local MemberEntry = require(script.Parent.MemberEntry)
local GetSelectedUsersStore = require(AppChat.Stores.GetSelectedUsersStore)

local function SelectedMembersBar(t1: {[any]: any}) -- line: 20
	-- upvalues: useStyle (copy), React (copy), GetSelectedUsersStore (copy), useSignalState (copy), MemberEntry (copy), Foundation (copy), FriendCountLabel (copy)
	local v12 = useStyle()
	local v13 = React.useRef(nil)
	local v14 = GetSelectedUsersStore(false)
	local v15 = useSignalState(v14.getMaxSize())
	local v16 = React.useMemo(function() -- line: 27
		-- upvalues: v15 (copy), React (copy), MemberEntry (copy), v12 (copy)
		local t2 = {}

		for i = 1, v15 do
			t2[`user-{ i }`] = React.createElement(MemberEntry, {
				index = i,
				style = v12
			})
		end

		return t2
	end, { v15 })

	React.useEffect(function() -- line: 39
		-- upvalues: v13 (copy)
		if v13.current then
			v13.current.ScrollBarThickness = 0
			v13.current.Selectable = false
		end
	end, { v13 })

	return React.createElement(Foundation.View, {
		tag = "row size-full-0 auto-y flex-y-fill padding-x-small gap-medium",
		LayoutOrder = t1.LayoutOrder
	}, {
		FriendCountContainer = React.createElement(Foundation.View, {
			tag = "auto-xy padding-y-small",
			LayoutOrder = 1
		}, {
			FriendCount = React.createElement(FriendCountLabel)
		}),
		UserScrollBar = React.createElement(Foundation.ScrollView, {
			tag = "fill auto-y",
			LayoutOrder = 2,
			scroll = {
				scrollBarVisibility = Foundation.Enums.ScrollBarVisibility.None,
				ScrollingDirection = Enum.ScrollingDirection.X,
				AutomaticCanvasSize = Enum.AutomaticSize.XY
			},
			scrollingFrameRef = v13
		}, React.createElement(Foundation.View, {
			tag = "row size-full padding-x-xsmall gap-medium align-y-center"
		}, v16))
	})
end

return React.memo(SelectedMembersBar)
