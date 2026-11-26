local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local useChatPagePadding = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPagePadding/useChatPagePadding")

local FFlagAppChatExtendConversationListRowDividers = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatExtendConversationListRowDividers")
local FFlagAppChatRemoveConversationListDivider = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatRemoveConversationListDivider")

local view = Foundation.View
local skeleton = Foundation.Skeleton
local radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local udim = UDim2.fromOffset(94, 12)
local udim2 = UDim2.fromOffset(169, 12)

local function SearchLoading(p2)
	local v5 = useChatPagePadding()
	local v6 = useTokens()

	local children = {}

	for i = 1, 3 do
		local formatted = `PlaceholderRow{i}`
		local createElement = React.createElement
		local v8 = {
			tag = "row align-y-center gap-small",
			Size = UDim2.new(1, 0, 0, p2.entryHeight),
			LayoutOrder = i,
			padding = 0
		}

		local v9 = { left = UDim.new(0, v5.left), right = 0 }
		local v10 = if not FFlagAppChatExtendConversationListRowDividers then UDim.new(0, v5.right) else nil
		v9.right = v10
		v8.padding = v9

		local children2 = {
			Avatar = React.createElement(skeleton, {
				Size = UDim2.fromOffset(v6.Size.Size_1000, v6.Size.Size_1000),
				radius = radius.Circle,
				LayoutOrder = 1
			}),
			Body = 0
		}

		local createElement2 = React.createElement

		local v13 = {
			Lines = React.createElement(view, {
				tag = "col align-y-center fill gap-small size-full-0",
				LayoutOrder = 1,
				padding = FFlagAppChatExtendConversationListRowDividers and { right = UDim.new(0, v5.right) } or nil
			}, {
				Title = React.createElement(skeleton, { Size = udim, LayoutOrder = 1 }),
				Subtitle = React.createElement(skeleton, {
					Size = udim2,
					LayoutOrder = 2
				})
			}),
			Divider = 0
		}

		local v14 = if i < 3 and not FFlagAppChatRemoveConversationListDivider then React.createElement(
			view,
			{ tag = "size-full-0 auto-y", LayoutOrder = 2 },
			{
				Line = React.createElement(Foundation.Divider)
			}
		) else nil
		v13.Divider = v14
		children2.Body = createElement2(view, {
			tag = "col fill size-0-full",
			LayoutOrder = 2
		}, v13)
		children[formatted] = createElement(view, v8, children2)
	end

	return React.createElement(view, {
		tag = "col size-full",
		padding = {
			top = UDim.new(0, p2.topPadding or 0)
		}
	}, {
		ChatLoadingFrame = React.createElement(view, {
			tag = "col size-full-0 auto-y"
		}, children)
	})
end

return SearchLoading
