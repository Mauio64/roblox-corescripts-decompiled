local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent

require(scriptParent.Types)

local TooltipOrientation = require(scriptParentParent.Tooltip.Enum.TooltipOrientation)
local Images = require(scriptParentParentParent.ImageSet.Images)
local uDim2 = UDim2.fromOffset(16, 8)
local v7 = uDim2.Y.Offset - 1
local t1 = {
	distanceOffset = -4,
	transparency = 1
}
local t2 = {
	distanceOffset = 0,
	transparency = 0
}
local t3 = {
	IMAGE = Images["component_assets/dropshadow_17_4"],
	SLICE_CENTER = Rect.new(12, 12, 13, 13),
	OFFSET = {
		[TooltipOrientation.Top] = 2,
		[TooltipOrientation.Bottom] = 6,
		[TooltipOrientation.Right] = 4,
		[TooltipOrientation.Left] = 4
	}
}
local t4 = {
	IMAGE = Images["component_assets/dropshadow_17_16"],
	SLICE_CENTER = Rect.new(36, 36, 37, 37),
	OFFSET = {
		[TooltipOrientation.Top] = 28,
		[TooltipOrientation.Bottom] = 28,
		[TooltipOrientation.Right] = 28,
		[TooltipOrientation.Left] = 28
	}
}
local t5 = {
	DEFAULT_PADDING = 12,
	DEFAULT_LIST_PADDING = 8,
	CARET_DISTANCE = 4,
	MAX_WIDTH = 240,
	HOTKEY_PADDING = 6,
	CLOSE_BUTTON_SIZE = 24,
	CLOSE_BUTTON_PADDING = 4,
	SCREEN_MARGIN = 12,
	DEFAULT_DELAY_TIME = 0.4,
	CORNER_RADIUS = UDim.new(0, 8),
	CONTENT_TO_CARET_TIP = v7,
	CONTENT_TO_CARET_CENTER = v7 - uDim2.Y.Offset / 2,
	CARET_IMAGE = Images["component_assets/triangleDown_16"],
	CARET_ROTATION = {
		[TooltipOrientation.Top] = 0,
		[TooltipOrientation.Bottom] = 180,
		[TooltipOrientation.Right] = 90,
		[TooltipOrientation.Left] = 270
	},
	CARET_SIZE = uDim2,
	DropShadow = {
		Small = t3,
		Large = t4
	},
	ORIENTATION_VECTOR = {
		[TooltipOrientation.Top] = Vector2.new(0, -1),
		[TooltipOrientation.Bottom] = Vector2.new(0, 1),
		[TooltipOrientation.Left] = Vector2.new(-1, 0),
		[TooltipOrientation.Right] = Vector2.new(1, 0)
	},
	OPPOSITE_ORIENTATION = {
		[TooltipOrientation.Top] = TooltipOrientation.Bottom,
		[TooltipOrientation.Bottom] = TooltipOrientation.Top,
		[TooltipOrientation.Right] = TooltipOrientation.Left,
		[TooltipOrientation.Left] = TooltipOrientation.Right
	},
	DISTANCE_TO_CONTENT = 4 + v7,
	MIN_DISTANCE_TO_CARET_MIDDLE = 12 + uDim2.X.Offset / 2,
	INACTIVE_ANIMATION_TARGETS = t1,
	ACTIVE_ANIMATION_TARGETS = t2,
	ANIMATION_OPTIONS = {
		frequency = 5
	}
}

return table.freeze(t5)
