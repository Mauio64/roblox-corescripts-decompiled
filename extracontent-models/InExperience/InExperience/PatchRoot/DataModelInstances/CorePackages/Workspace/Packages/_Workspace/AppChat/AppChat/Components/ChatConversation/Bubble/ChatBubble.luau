local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local Object = require(Parent.LuauPolyfill).Object
local Cryo = require(Parent.Cryo)
local ChatBubbleEnum = require(script.Parent.ChatBubbleEnum)
local Foundation = require(Parent.Foundation)
local useCursor = Foundation.Hooks.useCursor
local t1 = {
	contentWidth = 0,
	isIncoming = false,
	isRepliedTo = false,
	imageTransparency = 0,
	padding = 0,
	hasTail = false,
	imageColor = Color3.new(0, 0, 0),
	onAbsoluteSizeChanged = function(_) -- line: 35
	end,
	setContentWidth = function(_: number) -- line: 36
	end,
	handleEvent = function(_) -- line: 37
	end,
	containerChildren = {}
}

function ChatBubble(t2: {[any]: any}) -- line: 49
	-- upvalues: useCursor (copy), Foundation (copy), Cryo (copy), t1 (copy), ChatBubbleEnum (copy), React (copy), Object (copy)
	local v13 = useCursor(Foundation.Enums.CursorType.RoundedRect)
	local v14 = Cryo.Dictionary.union(t1, t2)
	local uDim = UDim.new(0, v14.padding or t1.padding)
	local v16 = ChatBubbleEnum.TAIL_WIDTH + (not v14.isRepliedTo and 0 or ChatBubbleEnum.REPLIED_TO_MARKER_WIDTH + ChatBubbleEnum.REPLIED_TO_MARKER_GAP)
	local v17 = if not v14.isIncoming then UDim2.new(1, -v16, 0, 0) else UDim2.new(0, v16, 0, 0)
	local BUBBLE = ChatBubbleEnum.BUBBLE

	if v14.hasTail then
		BUBBLE = if not v14.isIncoming then ChatBubbleEnum.SENT_BUBBLE_WITH_TAIL else ChatBubbleEnum.RECEIVED_BUBBLE_WITH_TAIL
	end

	local v19 = React.useCallback(function(p3) -- line: 70
		-- upvalues: v14 (copy)
		v14.onAbsoluteSizeChanged(p3)
	end, { v14.onAbsoluteSizeChanged })
	local v20 = React.useCallback(function(p4) -- line: 74
		-- upvalues: v14 (copy), uDim (copy)
		v14.setContentWidth(p4.AbsoluteContentSize.X + uDim.Offset * 2)
	end, { v14.setContentWidth })

	return React.createElement("ImageLabel", {
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.new(0, v14.contentWidth, 0, 0),
		AnchorPoint = v14.isIncoming and Vector2.new(0, 0) or Vector2.new(1, 0),
		BackgroundTransparency = 1,
		ImageColor3 = v14.imageColor,
		Image = BUBBLE,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = ChatBubbleEnum.SLIDE_CENTER,
		ImageTransparency = v14.imageTransparency,
		Position = v17,
		Selectable = not v14.hasTail,
		SelectionImageObject = v13,
		[React.Change.AbsoluteSize] = v19
	}, Object.assign(table.clone(v14.containerChildren), {
		["$margin"] = React.createElement("UIPadding", {
			PaddingBottom = uDim,
			PaddingTop = uDim,
			PaddingRight = uDim,
			PaddingLeft = uDim
		}),
		["$layout"] = React.createElement("UIListLayout", {
			[React.Change.AbsoluteContentSize] = v20
		})
	}))
end

return React.memo(ChatBubble)
