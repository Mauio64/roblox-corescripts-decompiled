local function createFrameModel(p1, p2) -- line: 3
	return {
		offset = p1,
		size = p2
	}
end

local t1 = {}
local t2 = {}
local vector2 = Vector2.new(2, 19)
local vector2_2 = Vector2.new(24, 24)

t2.back = {
	offset = vector2,
	size = vector2_2
}

local vector2_3 = Vector2.new(6, 51)
local vector2_4 = Vector2.new(16, 16)

t2.clear = {
	offset = vector2_3,
	size = vector2_4
}

local vector2_5 = Vector2.new(2, 75)
local vector2_6 = Vector2.new(24, 24)

t2.invite = {
	offset = vector2_5,
	size = vector2_6
}

local vector2_7 = Vector2.new(11, 1)
local vector2_8 = Vector2.new(7, 7)

t2.search_border = {
	offset = vector2_7,
	size = vector2_8
}

local vector2_9 = Vector2.new(3, 132)
local vector2_10 = Vector2.new(22, 22)

t2.search_large = {
	offset = vector2_9,
	size = vector2_10
}

local vector2_11 = Vector2.new(6, 106)
local vector2_12 = Vector2.new(16, 16)

t2.search_small = {
	offset = vector2_11,
	size = vector2_12
}

local vector2_13 = Vector2.new(0, 159)
local vector2_14 = Vector2.new(72, 72)

t2.friends = {
	offset = vector2_13,
	size = vector2_14
}

local vector2_15 = Vector2.new(4, 231)
local vector2_16 = Vector2.new(24, 24)

t2.cross = {
	offset = vector2_15,
	size = vector2_16
}

local vector2_17 = Vector2.new(0, 255)
local vector2_18 = Vector2.new(7, 7)

t2.modal_border = {
	offset = vector2_17,
	size = vector2_18
}
t1.frames = t2

return {
	GetFrame = function(_, p4) -- line: 26
		-- upvalues: t1 (copy)
		return t1.frames[p4]
	end,
	GetImagePath = function(_) -- line: 30
		return "rbxasset://textures/ui/Settings/ShareGame/icons.png"
	end,
	ApplyImage = function(p6, p7, p8) -- line: 34
		local Frame = p6:GetFrame(p8)

		p7.Image = "rbxasset://textures/ui/Settings/ShareGame/icons.png"
		p7.ImageRectOffset = Frame.offset
		p7.ImageRectSize = Frame.size
	end
}
