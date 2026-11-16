local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local useStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox").Core.Style.useStyle

local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact").useSignalState

local FriendCountLabel = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/SelectChatMembers/FriendCountLabel")
local MemberEntry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/SelectChatMembers/MemberEntry")
local GetSelectedUsersStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetSelectedUsersStore")

local function SelectedMembersBar(p2)
	local v5 = useStyle()
	local ref = React.useRef(nil)

	local v7 = useSignalState(GetSelectedUsersStore(false).getMaxSize())

	local v8 = React.useMemo(function()
		local children = {}

		for i = 1, v7 do
			children[`user-{i}`] = React.createElement(MemberEntry, {
				index = i,
				style = v5
			})
		end

		return children
	end, { v7 })

	React.useEffect(function()
		if ref.current then
			ref.current.ScrollBarThickness = 0
			ref.current.Selectable = false
		end
	end, { ref })

	return React.createElement(
		Foundation.View,
		{
			LayoutOrder = p2.LayoutOrder,
			tag = "row size-full-0 auto-y flex-y-fill padding-x-small gap-medium"
		},
		{
			FriendCountContainer = React.createElement(
				Foundation.View,
				{ tag = "auto-xy padding-y-small", LayoutOrder = 1 },
				{ FriendCount = React.createElement(FriendCountLabel) }
			),
			UserScrollBar = React.createElement(Foundation.ScrollView, {
				tag = "fill auto-y",
				LayoutOrder = 2,
				scroll = {
					scrollBarVisibility = Foundation.Enums.ScrollBarVisibility.None,
					ScrollingDirection = Enum.ScrollingDirection.X,
					AutomaticCanvasSize = Enum.AutomaticSize.XY
				},
				scrollingFrameRef = ref
			}, React.createElement(
				Foundation.View,
				{ tag = "row size-full padding-x-xsmall gap-medium align-y-center" },
				v8
			))
		}
	)
end

return React.memo(SelectedMembersBar)
