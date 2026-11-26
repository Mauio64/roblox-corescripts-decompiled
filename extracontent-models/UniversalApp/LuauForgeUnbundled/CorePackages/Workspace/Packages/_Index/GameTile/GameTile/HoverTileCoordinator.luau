local signal = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/AppCommonLib").Signal

local class = {}
class.__index = class

function class.new()
	local v5 = { changed = signal.new(), hoveredKey = nil, waitingForHover = nil }

	setmetatable(v5, class)
	return v5
end

function class:requestHover(p2)
	if not (self.hoveredKey ~= p2 and self.waitingForHover ~= p2) then
		return
	end

	if self.hoveredKey ~= nil and self.waitingForHover == nil then
		self.waitingForHover = p2

		return
	end

	self.hoveredKey = p2
	self.waitingForHover = nil
	self.changed:fire(self.hoveredKey)
end

function class:cancelHover(p2)
	if self.hoveredKey == p2 then
		if self.waitingForHover == nil then
			self.hoveredKey = nil
		else
			self.hoveredKey = self.waitingForHover
			self.waitingForHover = nil
		end

		self.changed:fire(self.hoveredKey)
	elseif self.waitingForHover == p2 then
		self.waitingForHover = nil
	end
end

function class:reset()
	local hoveredKey = self.hoveredKey
	self.waitingForHover = nil
	self.hoveredKey = nil

	if hoveredKey ~= nil then
		self.changed:fire(self.hoveredKey)
	end
end

class.default = class.new()

return class
