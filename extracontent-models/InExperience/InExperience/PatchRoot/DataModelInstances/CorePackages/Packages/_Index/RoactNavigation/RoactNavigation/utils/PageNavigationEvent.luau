local invariant = require(script.Parent.invariant)

local PageNavigationEvent = {}
PageNavigationEvent.__index = PageNavigationEvent

function PageNavigationEvent.new(pageName, event)
	invariant(type(pageName) == "string", "pageName should be string")
	invariant(typeof(event) == "userdata", "event should be RoactNavigation.Event")
	local v = { event = event, pageName = pageName }

	setmetatable(v, PageNavigationEvent)

	return v
end

function PageNavigationEvent.isPageNavigationEvent(p): boolean
	return getmetatable(p).__index == PageNavigationEvent
end

function PageNavigationEvent.__tostring(p)
	return string.format("%-15s - %s", tostring(p.event), p.pageName)
end

function PageNavigationEvent.equalTo(p, p2): boolean
	invariant(PageNavigationEvent.isPageNavigationEvent(p2), "should be PageNavigationEvent")
	return p.pageName == p2.pageName and p.event == p2.event
end

return PageNavigationEvent
