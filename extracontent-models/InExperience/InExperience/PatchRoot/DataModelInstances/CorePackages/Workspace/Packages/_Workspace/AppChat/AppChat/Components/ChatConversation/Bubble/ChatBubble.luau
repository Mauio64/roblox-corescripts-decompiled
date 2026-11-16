local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)
local LuauPolyfill = require(parent.LuauPolyfill)
local Object = LuauPolyfill.Object
local Cryo = require(parent.Cryo)
local ChatBubbleEnum = require(script.Parent.ChatBubbleEnum)

local Foundation = require(parent.Foundation)
local useCursor = Foundation.Hooks.useCursor

local v = {
	contentWidth = 0,
	isIncoming = false,
	isRepliedTo = false,
	imageColor = Color3.new(0, 0, 0),
	imageTransparency = 0,
	padding = 0,
	hasTail = false,
	onAbsoluteSizeChanged = function(_) end,
	setContentWidth = function(_: number) end,
	handleEvent = function(_) end,
	containerChildren = {}
}

function ChatBubble(p)
	local selectionImageObject = useCursor(Foundation.Enums.CursorType.RoundedRect)
	local union = Cryo.Dictionary.union(v, p)
	local udim = UDim.new(0, union.padding or v.padding)

	local v2 = ChatBubbleEnum.TAIL_WIDTH + (not union.isRepliedTo and 0 or ChatBubbleEnum.REPLIED_TO_MARKER_WIDTH + ChatBubbleEnum.REPLIED_TO_MARKER_GAP)
	local udim2

	if union.isIncoming then
		udim2 = UDim2.new(0, v2, 0, 0)
	else
		udim2 = UDim2.new(1, -v2, 0, 0)
	end

	local image = ChatBubbleEnum.BUBBLE

	if union.hasTail then
		if union.isIncoming then
			image = ChatBubbleEnum.RECEIVED_BUBBLE_WITH_TAIL
		else
			image = ChatBubbleEnum.SENT_BUBBLE_WITH_TAIL
		end
	end

	local v3 = React.useCallback(function(p2)
		union.onAbsoluteSizeChanged(p2)
	end, { union.onAbsoluteSizeChanged })

	local v4 = React.useCallback(function(p2)
		union.setContentWidth(p2.AbsoluteContentSize.X + udim.Offset * 2)
	end, { union.setContentWidth })

	return React.createElement("ImageLabel", {
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.new(0, union.contentWidth, 0, 0),
		AnchorPoint = union.isIncoming and Vector2.new(0, 0) or Vector2.new(1, 0),
		BackgroundTransparency = 1,
		ImageColor3 = union.imageColor,
		Image = image,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = ChatBubbleEnum.SLIDE_CENTER,
		ImageTransparency = union.imageTransparency,
		Position = udim2,
		Selectable = not union.hasTail,
		SelectionImageObject = selectionImageObject,
		[React.Change.AbsoluteSize] = v3
	}, Object.assign(table.clone(union.containerChildren), {
		["$margin"] = React.createElement("UIPadding", {
			PaddingBottom = udim,
			PaddingTop = udim,
			PaddingRight = udim,
			PaddingLeft = udim
		}),
		["$layout"] = React.createElement("UIListLayout", {
			[React.Change.AbsoluteContentSize] = v4
		})
	}))
end

return React.memo(ChatBubble)
