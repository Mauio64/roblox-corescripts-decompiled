local scriptParent = script.Parent
local Utils = require(scriptParent.Utils)
local _ = {
	Hovering = "Hovering",
	Dragging = "Dragging",
	Idle = "Idle"
}
local t1 = {}

t1.__index = t1

function t1.getCFrame(p1) -- line: 33
	return p1.part.CFrame
end
function t1.setCFrame(p2, cFrame: CFrame) -- line: 37
	p2.part.CFrame = cFrame
end
function t1.updateTransparency(p3) -- line: 41
	if p3.dragBarState == "Hovering" then
		p3.dragBarImage.ImageTransparency = 0.2

		return
	end

	if p3.dragBarState == "Dragging" then
		p3.dragBarImage.ImageTransparency = 0

		return
	end

	p3.dragBarImage.ImageTransparency = 0.6
end
function t1.updateState(p4) -- line: 51
	if p4.dragging then
		p4.dragBarState = "Dragging"
	elseif p4.hovering and not p4.dragging then
		p4.dragBarState = "Hovering"
	else
		p4.dragBarState = "Idle"
	end

	p4:updateTransparency()
end
function t1.startDrag(p5, cFrame: CFrame) -- line: 62
	p5.dragging = true
	p5.uiGroupOffSet = cFrame
	p5:updateState()
end
function t1.dragEnd(p6) -- line: 68
	p6.dragging = false
	p6:updateState()
end
function t1.startHover(p7) -- line: 73
	p7.hovering = true
	p7:updateState()
end
function t1.hoverEnd(p8) -- line: 78
	p8.hovering = false
	p8:updateState()
end
function t1.show(p9) -- line: 83
	p9.part.Parent = p9.partsParent
end
function t1.hide(p10) -- line: 87
	p10.part.Parent = nil
end
function t1.rescale(p11, n1: number) -- line: 91
	-- upvalues: Utils (copy)
	p11.part.Size = p11.part.Size * n1

	if p11.uiGroupOffSet then
		p11.uiGroupOffSet = Utils.rescaleCFramePosition(p11.uiGroupOffSet, n1)
	end
end
function t1.new(p12, p13) -- line: 98
	-- upvalues: t1 (copy)
	local t2 = {
		hovering = false,
		dragging = false,
		dragBarState = "Idle",
		uiGroupOffSet = nil,
		part = p12,
		dragBarImage = p13,
		partsParent = p12.Parent
	}

	setmetatable(t2, t1)
	t2.dragBarImage.ImageTransparency = 0.6

	return t2
end

return t1
