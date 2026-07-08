local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local React = dependencies.React
local UIBlox = dependencies.UIBlox
local Object = dependencies.LuauPolyfill.Object
local rect = Rect.new(10, 10, 11, 11)
local t1 = {
	isIncoming = false,
	hasTail = false,
	padding = 12,
	LayoutOrder = 0,
	isPending = false,
	[React.Change.AbsoluteSize] = function(_) -- line: 21
	end,
	overrideImageColor = false
}

local function ChatBubbleContainer(p2) -- line: 26
	-- upvalues: React (copy), t1 (copy), UIBlox (copy), rect (copy), Object (copy)
	local v11, v12 = React.useState(0)
	local v13 = p2[React.Change.AbsoluteSize] or t1[React.Change.AbsoluteSize]

	return UIBlox.Style.withStyle(function(p3) -- line: 30
		-- upvalues: p2 (copy), t1 (copy), React (copy), v11 (copy), rect (copy), v13 (copy), Object (copy), v12 (copy)
		local v15 = p2.children or {}
		local v16 = p2.hasTail or t1.hasTail
		local v17 = p2.isIncoming or t1.isIncoming
		local v18 = p2.isPending or t1.isPending
		local v19 = if not v17 then if not v18 then p3.Theme.UIEmphasis else p3.Theme.UIMuted else p3.Theme.UIDefault
		local Color = v19.Color
		local Transparency = v19.Transparency

		if p2.overrideImageColor or t1.overrideImageColor then
			Color = nil

			if not v18 then
				Transparency = nil
			end
		end

		local s1 = "rbxasset://textures/ui/LuaChat/9-slice/chat-bubble-self2.png"

		if v16 then
			s1 = not v17 and "rbxasset://textures/ui/LuaChat/9-slice/chat-bubble-self.png" or "rbxasset://textures/ui/LuaChat/9-slice/chat-bubble.png"
		end

		local v23 = v17 and UDim2.new(0, 6, 0, 0) or UDim2.new(1, -6, 0, 0)
		local v24 = not v17 and "rbxasset://textures/ui/LuaChat/9-slice/chat-bubble-self-tip.png" or "rbxasset://textures/ui/LuaChat/9-slice/chat-bubble-tip.png"
		local v25 = v17 and UDim2.new(0, 0, 0, 0) or UDim2.new(1, 0, 0, 0)
		local uDim = UDim.new(0, p2.padding or t1.padding)

		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			Size = UDim2.new(0, v11 + 6, 0, 0),
			LayoutOrder = p2.LayoutOrder or t1.LayoutOrder
		}, {
			bubble = React.createElement("ImageLabel", {
				AutomaticSize = Enum.AutomaticSize.XY,
				Size = UDim2.new(0, v11, 0, 0),
				AnchorPoint = v17 and Vector2.new(0, 0) or Vector2.new(1, 0),
				BackgroundTransparency = 1,
				ImageColor3 = Color,
				Image = s1,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = rect,
				ImageTransparency = Transparency,
				Position = v23,
				[React.Change.AbsoluteSize] = function(p4) -- line: 82
					-- upvalues: v13 (copy)
					v13(p4)
				end
			}, Object.assign(table.clone(v15), {
				["$margin"] = React.createElement("UIPadding", {
					PaddingBottom = uDim,
					PaddingTop = uDim,
					PaddingRight = uDim,
					PaddingLeft = uDim
				}),
				["$layout"] = React.createElement("UIListLayout", {
					[React.Change.AbsoluteContentSize] = function(p5) -- line: 93
						-- upvalues: v12 (copy), uDim (copy)
						v12(p5.AbsoluteContentSize.X + uDim.Offset * 2)
					end
				})
			})),
			tail = React.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				AnchorPoint = v17 and Vector2.new(0, 0) or Vector2.new(1, 0),
				Size = UDim2.new(0, 6, 0, 6),
				ImageColor3 = Color,
				Position = v25,
				Image = v24,
				ImageTransparency = Transparency,
				Visible = v16
			})
		})
	end)
end

return ChatBubbleContainer
