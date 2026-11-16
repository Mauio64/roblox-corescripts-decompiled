local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local react = dependencies.React
local uiBlox = dependencies.UIBlox
local object = dependencies.LuauPolyfill.Object

local rect = Rect.new(10, 10, 11, 11)

local v = {
	isIncoming = false,
	hasTail = false,
	padding = 12,
	LayoutOrder = 0,
	isPending = false,
	[react.Change.AbsoluteSize] = function(_) end,
	overrideImageColor = false
}

local function ChatBubbleContainer(data)
	local state, setState = react.useState(0)
	local v2 = data[react.Change.AbsoluteSize] or v[react.Change.AbsoluteSize]

	return uiBlox.Style.withStyle(function(p)
		local children = data.children or {}
		local hasTail = data.hasTail or v.hasTail
		local isIncoming = data.isIncoming or v.isIncoming
		local isPending = data.isPending or v.isPending
		local v3

		if isIncoming then
			v3 = p.Theme.UIDefault
		elseif isPending then
			v3 = p.Theme.UIMuted
		else
			v3 = p.Theme.UIEmphasis
		end

		local color = v3.Color
		local transparency = v3.Transparency

		if data.overrideImageColor or v.overrideImageColor then
			color = nil

			if not isPending then
				transparency = nil
			end
		end

		local udim = isIncoming and UDim2.new(0, 6, 0, 0) or UDim2.new(1, -6, 0, 0)

		local udim2 = isIncoming and UDim2.new(0, 0, 0, 0) or UDim2.new(1, 0, 0, 0)
		local udim3 = UDim.new(0, data.padding or v.padding)

		return react.createElement("Frame", {
			AutomaticSize = Enum.AutomaticSize.XY,
			Size = UDim2.new(0, state + 6, 0, 0),
			LayoutOrder = data.LayoutOrder or v.LayoutOrder,
			BackgroundTransparency = 1
		}, {
			bubble = react.createElement("ImageLabel", {
				AutomaticSize = Enum.AutomaticSize.XY,
				Size = UDim2.new(0, state, 0, 0),
				AnchorPoint = isIncoming and Vector2.new(0, 0) or Vector2.new(1, 0),
				BackgroundTransparency = 1,
				ImageColor3 = color,
				Image = hasTail and (isIncoming and "rbxasset://textures/ui/LuaChat/9-slice/chat-bubble.png" or "rbxasset://textures/ui/LuaChat/9-slice/chat-bubble-self.png") or "rbxasset://textures/ui/LuaChat/9-slice/chat-bubble-self2.png",
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = rect,
				ImageTransparency = transparency,
				Position = udim,
				[react.Change.AbsoluteSize] = function(p2)
					v2(p2)
				end
			}, object.assign(table.clone(children), {
				["$margin"] = react.createElement("UIPadding", {
					PaddingBottom = udim3,
					PaddingTop = udim3,
					PaddingRight = udim3,
					PaddingLeft = udim3
				}),
				["$layout"] = react.createElement("UIListLayout", {
					[react.Change.AbsoluteContentSize] = function(p2)
						setState(p2.AbsoluteContentSize.X + udim3.Offset * 2)
					end
				})
			})),
			tail = react.createElement("ImageLabel", {
				AnchorPoint = isIncoming and Vector2.new(0, 0) or Vector2.new(1, 0),
				Size = UDim2.new(0, 6, 0, 6),
				BackgroundTransparency = 1,
				ImageColor3 = color,
				Position = udim2,
				Image = isIncoming and "rbxasset://textures/ui/LuaChat/9-slice/chat-bubble-tip.png" or "rbxasset://textures/ui/LuaChat/9-slice/chat-bubble-self-tip.png",
				ImageTransparency = transparency,
				Visible = hasTail
			})
		})
	end)
end

return ChatBubbleContainer
