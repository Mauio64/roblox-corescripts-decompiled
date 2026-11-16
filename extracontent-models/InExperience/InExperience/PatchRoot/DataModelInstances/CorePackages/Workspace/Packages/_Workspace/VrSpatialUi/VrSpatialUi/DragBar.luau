local VrSpatialUi = script:FindFirstAncestor("VrSpatialUi")
local Utils = require(VrSpatialUi.Utils)

local _ = { Hovering = "Hovering", Dragging = "Dragging", Idle = "Idle" }

local DragBar = {}

DragBar.__index = DragBar

function DragBar.getCFrame(p)
	return p.part.CFrame
end

function DragBar.setCFrame(p, cframe: CFrame)
	p.part.CFrame = cframe
end

function DragBar:updateTransparency()
	if self.dragBarState == "Hovering" then
		self.dragBarImage.ImageTransparency = 0.2
	elseif self.dragBarState == "Dragging" then
		self.dragBarImage.ImageTransparency = 0
	else
		self.dragBarImage.ImageTransparency = 0.6
	end
end

function DragBar:updateState()
	if self.dragging then
		self.dragBarState = "Dragging"
	elseif self.hovering and not self.dragging then
		self.dragBarState = "Hovering"
	else
		self.dragBarState = "Idle"
	end

	self:updateTransparency()
end

function DragBar:startDrag(uiGroupOffSet: CFrame)
	self.everDragged = true
	self.dragging = true
	self.uiGroupOffSet = uiGroupOffSet
	self:updateState()
end

function DragBar.isEverDragged(p)
	return p.everDragged
end

function DragBar:dragEnd()
	self.dragging = false
	self:updateState()
end

function DragBar:startHover()
	self.hovering = true
	self:updateState()
end

function DragBar:hoverEnd()
	self.hovering = false
	self:updateState()
end

function DragBar.show(p)
	p.part.Parent = p.partsParent
end

function DragBar.hide(p)
	p.part.Parent = nil
end

function DragBar:rescale(p: number)
	self.part.Size = self.part.Size * p

	if self.uiGroupOffSet then
		self.uiGroupOffSet = Utils.rescaleCFramePosition(self.uiGroupOffSet, p)
	end
end

function DragBar.new(part, dragBarImage)
	local v = {
		part = part,
		dragBarImage = dragBarImage,
		hovering = false,
		dragging = false,
		everDragged = false,
		dragBarState = "Idle",
		partsParent = part.Parent,
		uiGroupOffSet = nil
	}

	setmetatable(v, DragBar)
	v.dragBarImage.ImageTransparency = 0.6
	return v
end

return DragBar
