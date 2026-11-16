local Utils = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/VrSpatialUi/Utils")

local v5 = { Hovering = "Hovering", Dragging = "Dragging", Idle = "Idle" }

local class = {}

class.__index = class

function class:getCFrame()
	return self.part.CFrame
end

function class:setCFrame(cframe)
	self.part.CFrame = cframe
end

function class:updateTransparency()
	if self.dragBarState == "Hovering" then
		self.dragBarImage.ImageTransparency = 0.2
	elseif self.dragBarState == "Dragging" then
		self.dragBarImage.ImageTransparency = 0
	else
		self.dragBarImage.ImageTransparency = 0.6
	end
end

function class:updateState()
	if self.dragging then
		self.dragBarState = "Dragging"
	elseif self.hovering and not self.dragging then
		self.dragBarState = "Hovering"
	else
		self.dragBarState = "Idle"
	end

	self:updateTransparency()
end

function class:startDrag(uiGroupOffSet)
	self.everDragged = true
	self.dragging = true
	self.uiGroupOffSet = uiGroupOffSet
	self:updateState()
end

function class:isEverDragged()
	return self.everDragged
end

function class:dragEnd()
	self.dragging = false
	self:updateState()
end

function class:startHover()
	self.hovering = true
	self:updateState()
end

function class:hoverEnd()
	self.hovering = false
	self:updateState()
end

function class.show(p2)
	p2.part.Parent = p2.partsParent
end

function class.hide(p2)
	p2.part.Parent = nil
end

function class:rescale(p2)
	self.part.Size = self.part.Size * p2

	if self.uiGroupOffSet then
		self.uiGroupOffSet = Utils.rescaleCFramePosition(self.uiGroupOffSet, p2)
	end
end

function class.new(p2, p3)
	local v6 = {
		part = p2,
		dragBarImage = p3,
		hovering = false,
		dragging = false,
		everDragged = false,
		dragBarState = "Idle",
		partsParent = p2.Parent,
		uiGroupOffSet = nil
	}

	setmetatable(v6, class)
	v6.dragBarImage.ImageTransparency = 0.6
	return v6
end

return class
