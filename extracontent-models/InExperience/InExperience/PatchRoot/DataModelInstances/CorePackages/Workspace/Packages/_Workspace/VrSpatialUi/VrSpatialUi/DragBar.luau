local VrSpatialUi = script:FindFirstAncestor("VrSpatialUi")
local Utils = require(VrSpatialUi.Utils)
local _ = {
	Hovering = "Hovering",
	Dragging = "Dragging",
	Idle = "Idle"
}
local t1 = {}

t1.__index = t1

function t1.getCFrame(p1) -- line: 34
	return p1.part.CFrame
end
function t1.setCFrame(p2, cFrame: CFrame) -- line: 38
	p2.part.CFrame = cFrame
end
function t1.updateTransparency(p3) -- line: 42
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
function t1.updateState(p4) -- line: 52
	if p4.dragging then
		p4.dragBarState = "Dragging"
	elseif p4.hovering and not p4.dragging then
		p4.dragBarState = "Hovering"
	else
		p4.dragBarState = "Idle"
	end

	p4:updateTransparency()
end
function t1.startDrag(p5, cFrame: CFrame) -- line: 63
	p5.everDragged = true
	p5.dragging = true
	p5.uiGroupOffSet = cFrame
	p5:updateState()
end
function t1.isEverDragged(p6) -- line: 70
	return p6.everDragged
end
function t1.dragEnd(p7) -- line: 74
	p7.dragging = false
	p7:updateState()
end
function t1.startHover(p8) -- line: 79
	p8.hovering = true
	p8:updateState()
end
function t1.hoverEnd(p9) -- line: 84
	p9.hovering = false
	p9:updateState()
end
function t1.show(p10) -- line: 89
	p10.part.Parent = p10.partsParent
end
function t1.hide(p11) -- line: 93
	p11.part.Parent = nil
end
function t1.rescale(p12, n1: number) -- line: 97
	-- upvalues: Utils (copy)
	p12.part.Size = p12.part.Size * n1

	if p12.uiGroupOffSet then
		p12.uiGroupOffSet = Utils.rescaleCFramePosition(p12.uiGroupOffSet, n1)
	end
end
function t1.new(p13, p14) -- line: 104
	-- upvalues: t1 (copy)
	local t2 = {
		hovering = false,
		dragging = false,
		everDragged = false,
		dragBarState = "Idle",
		uiGroupOffSet = nil,
		part = p13,
		dragBarImage = p14,
		partsParent = p13.Parent
	}

	setmetatable(t2, t1)
	t2.dragBarImage.ImageTransparency = 0.6

	return t2
end

return t1
