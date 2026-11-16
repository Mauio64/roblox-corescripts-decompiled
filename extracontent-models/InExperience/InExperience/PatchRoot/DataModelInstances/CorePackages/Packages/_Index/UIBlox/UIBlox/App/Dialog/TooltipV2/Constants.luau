local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

require(parent.Types)
local TooltipOrientation = require(parent2.Tooltip.Enum.TooltipOrientation)
local Images = require(parent3.ImageSet.Images)

local udim = UDim2.fromOffset(16, 8)

local v = udim.Y.Offset - 1

local small = {
	IMAGE = Images["component_assets/dropshadow_17_4"],
	SLICE_CENTER = Rect.new(12, 12, 13, 13),
	OFFSET = {
		[TooltipOrientation.Top] = 2,
		[TooltipOrientation.Bottom] = 6,
		[TooltipOrientation.Right] = 4,
		[TooltipOrientation.Left] = 4
	}
}

local large = {
	IMAGE = Images["component_assets/dropshadow_17_16"],
	SLICE_CENTER = Rect.new(36, 36, 37, 37),
	OFFSET = {
		[TooltipOrientation.Top] = 28,
		[TooltipOrientation.Bottom] = 28,
		[TooltipOrientation.Right] = 28,
		[TooltipOrientation.Left] = 28
	}
}

local v2 = {
	DEFAULT_PADDING = 12,
	DEFAULT_LIST_PADDING = 8,
	CORNER_RADIUS = UDim.new(0, 8),
	CARET_DISTANCE = 4,
	CONTENT_TO_CARET_TIP = v,
	CONTENT_TO_CARET_CENTER = v - udim.Y.Offset / 2,
	MAX_WIDTH = 240,
	HOTKEY_PADDING = 6,
	CARET_IMAGE = Images["component_assets/triangleDown_16"],
	CARET_ROTATION = {
		[TooltipOrientation.Top] = 0,
		[TooltipOrientation.Bottom] = 180,
		[TooltipOrientation.Right] = 90,
		[TooltipOrientation.Left] = 270
	},
	CARET_SIZE = udim,
	CLOSE_BUTTON_SIZE = 24,
	CLOSE_BUTTON_PADDING = 4,
	DropShadow = { Small = small, Large = large },
	ORIENTATION_VECTOR = 0,
	OPPOSITE_ORIENTATION = 0,
	DISTANCE_TO_CONTENT = 0,
	SCREEN_MARGIN = 12,
	MIN_DISTANCE_TO_CARET_MIDDLE = 0,
	INACTIVE_ANIMATION_TARGETS = 0,
	ACTIVE_ANIMATION_TARGETS = 0,
	ANIMATION_OPTIONS = 0,
	DEFAULT_DELAY_TIME = 0.4
}

local vector2s = {
	[TooltipOrientation.Top] = Vector2.new(0, -1),
	[TooltipOrientation.Bottom] = Vector2.new(0, 1),
	[TooltipOrientation.Left] = Vector2.new(-1, 0),
	[TooltipOrientation.Right] = Vector2.new(1, 0)
}
v2.ORIENTATION_VECTOR = vector2s

v2.OPPOSITE_ORIENTATION = {
	[TooltipOrientation.Top] = TooltipOrientation.Bottom,
	[TooltipOrientation.Bottom] = TooltipOrientation.Top,
	[TooltipOrientation.Right] = TooltipOrientation.Left,
	[TooltipOrientation.Left] = TooltipOrientation.Right
}

v2.DISTANCE_TO_CONTENT = 4 + v

v2.MIN_DISTANCE_TO_CARET_MIDDLE = 12 + udim.X.Offset / 2
v2.INACTIVE_ANIMATION_TARGETS = { distanceOffset = -4, transparency = 1 }
v2.ACTIVE_ANIMATION_TARGETS = { distanceOffset = 0, transparency = 0 }

v2.ANIMATION_OPTIONS = { frequency = 5 }

return table.freeze(v2)
