local parent = script:FindFirstAncestor("GameTile").Parent
local AppCommonLib = require(parent.AppCommonLib)
local Signal = AppCommonLib.Signal

local HoverTileCoordinator = {}
HoverTileCoordinator.__index = HoverTileCoordinator

function HoverTileCoordinator.new()
	local v = { changed = Signal.new(), hoveredKey = nil, waitingForHover = nil }

	setmetatable(v, HoverTileCoordinator)
	return v
end

function HoverTileCoordinator:requestHover(p: string)
	if not (self.hoveredKey ~= p and self.waitingForHover ~= p) then
		return
	end

	if self.hoveredKey ~= nil and self.waitingForHover == nil then
		self.waitingForHover = p

		return
	end

	self.hoveredKey = p
	self.waitingForHover = nil
	self.changed:fire(self.hoveredKey)
end

function HoverTileCoordinator:cancelHover(p: string)
	if self.hoveredKey == p then
		if self.waitingForHover == nil then
			self.hoveredKey = nil
		else
			self.hoveredKey = self.waitingForHover
			self.waitingForHover = nil
		end

		self.changed:fire(self.hoveredKey)
	elseif self.waitingForHover == p then
		self.waitingForHover = nil
	end
end

function HoverTileCoordinator:reset()
	local hoveredKey = self.hoveredKey
	self.waitingForHover = nil
	self.hoveredKey = nil

	if hoveredKey ~= nil then
		self.changed:fire(self.hoveredKey)
	end
end

HoverTileCoordinator.default = HoverTileCoordinator.new()

return HoverTileCoordinator
