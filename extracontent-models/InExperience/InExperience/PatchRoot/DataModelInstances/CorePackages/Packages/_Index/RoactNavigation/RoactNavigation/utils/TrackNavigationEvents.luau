local parent = script.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array

local React = require(parent2.React)
local ReactRoblox = require(parent2.Dev.ReactRoblox)
local NavigationEvents = require(parent.views.NavigationEvents)
local Events = require(parent.Events)
local invariant = require(script.Parent.invariant)
local PageNavigationEvent = require(script.Parent.PageNavigationEvent)

local TrackNavigationEvents = {}
TrackNavigationEvents.__index = TrackNavigationEvents

function TrackNavigationEvents.new()
	local v = { navigationEvents = {} }

	setmetatable(v, TrackNavigationEvents)

	return v
end

function TrackNavigationEvents.getNavigationEvents(p)
	return p.navigationEvents
end

function TrackNavigationEvents.printNavigationEvents(p)
	print("Total Events: ", #p.navigationEvents)

	for _, navigationEvent in p.navigationEvents do
		print(navigationEvent)
	end
end

function TrackNavigationEvents.waitForNumberEventsMaxWaitTime(p, p2, p3)
	local total = 0

	while #p.navigationEvents < p2 and total <= p3 do
		ReactRoblox.act(function()
			total += task.wait()
		end)
	end
end

function TrackNavigationEvents:resetNavigationEvents()
	self.navigationEvents = {}
end

local v = {
	onWillFocus = Events.WillFocus,
	onDidFocus = Events.DidFocus,
	onWillBlur = Events.WillBlur,
	onDidBlur = Events.DidBlur
}

function TrackNavigationEvents.createNavigationAdapter(p, p2)
	local v2 = {}

	for k, v3 in v do
		v2[k] = function()
			PageNavigationEvent.new(p2, v3)
			table.insert(p.navigationEvents, PageNavigationEvent.new(p2, v3))
		end
	end

	return React.createElement(NavigationEvents, v2)
end

function TrackNavigationEvents:equalTo(list)
	invariant(type(list) == "table", "should be a list")
	local count = #self.navigationEvents

	if count ~= #list then
		return false, "different amount of events"
	end

	for i = 1, count do
		if not self.navigationEvents[i]:equalTo(list[i]) then
			return false, ("events at position %d do not match"):format(i)
		end
	end

	return true
end

function TrackNavigationEvents:expect(list)
	local equalTo, v2 = self:equalTo(list)

	if not equalTo then
		local v3 = not (#self.navigationEvents > 0) and "{}"
			or ("{\n  %s,\n}"):format(table.concat(Array.map(self.navigationEvents, tostring), ",\n  "))

		local v4 = not (#list > 0) and "{}" or ("{\n  %s,\n}"):format(table.concat(Array.map(list, tostring), ",\n  "))

		error(("%s\nGot events: %s\n\nExpected events: %s"):format(v2, v3, v4))
	end
end

return TrackNavigationEvents
