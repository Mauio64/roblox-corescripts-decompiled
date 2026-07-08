local invariant = require(script.Parent.invariant)
local t1 = {}

t1.__index = t1

function t1.new(p1, p2) -- line: 6
	-- upvalues: invariant (copy), t1 (copy)
	invariant(type(p1) == "string", "pageName should be string")
	invariant(typeof(p2) == "userdata", "event should be RoactNavigation.Event")

	local t2 = {
		event = p2,
		pageName = p1
	}

	setmetatable(t2, t1)

	return t2
end
function t1.isPageNavigationEvent(p3) -- line: 19
	-- upvalues: t1 (copy)
	return getmetatable(p3).__index == t1
end
function t1.__tostring(p4) -- line: 23
	return string.format("%-15s - %s", tostring(p4.event), p4.pageName)
end
function t1.equalTo(p5, p6) -- line: 27
	-- upvalues: invariant (copy), t1 (copy)
	invariant(t1.isPageNavigationEvent(p6), "should be PageNavigationEvent")

	return p5.pageName == p6.pageName and p5.event == p6.event
end

return t1
