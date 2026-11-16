local function createFrameModel(offset, size) -- 9 equivalent calls inferred from this helper
	return { offset = offset, size = size }
end

local v = {
	frames = {
		back = createFrameModel(Vector2.new(2, 19), Vector2.new(24, 24)), -- inferred equivalent call
		clear = createFrameModel(Vector2.new(6, 51), Vector2.new(16, 16)), -- inferred equivalent call
		invite = createFrameModel(Vector2.new(2, 75), Vector2.new(24, 24)), -- inferred equivalent call
		search_border = createFrameModel(Vector2.new(11, 1), Vector2.new(7, 7)), -- inferred equivalent call
		search_large = createFrameModel(Vector2.new(3, 132), Vector2.new(22, 22)), -- inferred equivalent call
		search_small = createFrameModel(Vector2.new(6, 106), Vector2.new(16, 16)), -- inferred equivalent call
		friends = createFrameModel(Vector2.new(0, 159), Vector2.new(72, 72)), -- inferred equivalent call
		cross = createFrameModel(Vector2.new(4, 231), Vector2.new(24, 24)), -- inferred equivalent call
		modal_border = createFrameModel(Vector2.new(0, 255), Vector2.new(7, 7)) -- inferred equivalent call
	}
}
local ShareGameIcons = {}

function ShareGameIcons:GetFrame(p)
	return v.frames[p]
end

function ShareGameIcons.GetImagePath(_): string
	return "rbxasset://textures/ui/Settings/ShareGame/icons.png"
end

function ShareGameIcons:ApplyImage(p, p2)
	local frame = self:GetFrame(p2)

	p.Image = "rbxasset://textures/ui/Settings/ShareGame/icons.png"
	p.ImageRectOffset = frame.offset
	p.ImageRectSize = frame.size
end

return ShareGameIcons
