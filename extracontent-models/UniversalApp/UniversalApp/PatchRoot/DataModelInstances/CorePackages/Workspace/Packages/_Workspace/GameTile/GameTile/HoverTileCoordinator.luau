local Parent = script:FindFirstAncestor("GameTile").Parent
local Signal = require(Parent.AppCommonLib).Signal
local t1 = {}

t1.__index = t1

function t1.new() -- line: 24
	-- upvalues: Signal (copy), t1 (copy)
	local t2 = {
		hoveredKey = nil,
		waitingForHover = nil,
		changed = Signal.new()
	}

	setmetatable(t2, t1)

	return t2
end
function t1.requestHover(p1, s1: string) -- line: 34
	if s1 == p1.hoveredKey then
		return
	end

	if s1 == p1.waitingForHover then
		return
	end

	if p1.hoveredKey == nil or p1.waitingForHover ~= nil then
		p1.hoveredKey = s1
		p1.waitingForHover = nil
		p1.changed:fire(p1.hoveredKey)

		return
	end

	p1.waitingForHover = s1
end
function t1.cancelHover(p2, s2: string) -- line: 57
	if s2 == p2.hoveredKey then
		if p2.waitingForHover ~= nil then
			p2.hoveredKey = p2.waitingForHover
			p2.waitingForHover = nil
		else
			p2.hoveredKey = nil
		end

		p2.changed:fire(p2.hoveredKey)

		return
	end

	if s2 == p2.waitingForHover then
		p2.waitingForHover = nil
	end
end
function t1.reset(p3) -- line: 72
	local hoveredKey = p3.hoveredKey

	p3.waitingForHover = nil
	p3.hoveredKey = nil

	if hoveredKey ~= nil then
		p3.changed:fire(p3.hoveredKey)
	end
end

t1.default = t1.new()

return t1
