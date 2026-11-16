local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle

local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local FriendCountLabel = require(script.Parent.FriendCountLabel)
local MemberEntry = require(script.Parent.MemberEntry)
local GetSelectedUsersStore = require(AppChat.Stores.GetSelectedUsersStore)

local function SelectedMembersBar(p)
	local style = useStyle()
	local ref = React.useRef(nil)

	local v = useSignalState(GetSelectedUsersStore(false).getMaxSize())

	local v2 = React.useMemo(function()
		local children = {}

		for i = 1, v do
			children[`user-{i}`] = React.createElement(MemberEntry, { index = i, style = style })
		end

		return children
	end, { v })

	React.useEffect(function()
		if ref.current then
			ref.current.ScrollBarThickness = 0
			ref.current.Selectable = false
		end
	end, { ref })

	return React.createElement(
		Foundation.View,
		{
			LayoutOrder = p.LayoutOrder,
			tag = "row size-full-0 auto-y flex-y-fill padding-x-small gap-medium"
		},
		{
			FriendCountContainer = React.createElement(
				Foundation.View,
				{ tag = "auto-xy padding-y-small", LayoutOrder = 1 },
				{
					FriendCount = React.createElement(FriendCountLabel)
				}
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
				v2
			))
		}
	)
end

return React.memo(SelectedMembersBar)
