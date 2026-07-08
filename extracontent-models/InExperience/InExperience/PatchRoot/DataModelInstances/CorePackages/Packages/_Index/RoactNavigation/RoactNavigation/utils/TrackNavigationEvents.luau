local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Array = require(ParentParentParent.LuauPolyfill).Array
local React = require(ParentParentParent.React)
local ReactRoblox = require(ParentParentParent.Dev.ReactRoblox)
local NavigationEvents = require(ParentParent.views.NavigationEvents)
local Events = require(ParentParent.Events)
local invariant = require(script.Parent.invariant)
local PageNavigationEvent = require(script.Parent.PageNavigationEvent)
local t1 = {}

t1.__index = t1

function t1.new() -- line: 16
	-- upvalues: t1 (copy)
	local t2 = {
		navigationEvents = {}
	}

	setmetatable(t2, t1)

	return t2
end
function t1.getNavigationEvents(p1) -- line: 26
	return p1.navigationEvents
end
function t1.printNavigationEvents(p2) -- line: 30
	print("Total Events: ", #p2.navigationEvents)

	for _, v16 in p2.navigationEvents do
		print(v16)
	end
end
function t1.waitForNumberEventsMaxWaitTime(p3, p4, p5) -- line: 37
	-- upvalues: ReactRoblox (copy)
	local n1 = 0

	while p4 > #p3.navigationEvents and p5 >= n1 do
		ReactRoblox.act(function() -- line: 40
			-- upvalues: n1 (ref)
			n1 += task.wait()
		end)
	end
end
function t1.resetNavigationEvents(p6) -- line: 46
	p6.navigationEvents = {}
end

local t3 = {
	onWillFocus = Events.WillFocus,
	onDidFocus = Events.DidFocus,
	onWillBlur = Events.WillBlur,
	onDidBlur = Events.DidBlur
}

function t1.createNavigationAdapter(p7, p8) -- line: 57
	-- upvalues: t3 (copy), PageNavigationEvent (copy), React (copy), NavigationEvents (copy)
	local t4 = {}

	for v25, v26 in t3 do
		t4[v25] = function() -- line: 60
			-- upvalues: PageNavigationEvent (copy), p8 (copy), v26 (copy), p7 (copy)
			PageNavigationEvent.new(p8, v26)
			table.insert(p7.navigationEvents, PageNavigationEvent.new(p8, v26))
		end
	end

	return React.createElement(NavigationEvents, t4)
end
function t1.equalTo(p9, p10) -- line: 69
	-- upvalues: invariant (copy)
	invariant(type(p10) == "table", "should be a list")

	local v29 = #p9.navigationEvents

	if v29 ~= #p10 then
		return false, "different amount of events"
	end

	for i = 1, v29 do
		if not p9.navigationEvents[i]:equalTo(p10[i]) then
			return false, ("events at position %d do not match"):format(i)
		end
	end

	return true
end
function t1.expect(p11, p12) -- line: 86
	-- upvalues: Array (copy)
	local v33, v34 = p11:equalTo(p12)

	if not v33 then
		local s1 = "{}"
		local s2 = "{}"

		if #p11.navigationEvents > 0 then
			s1 = ("{\n  %s,\n}"):format(table.concat(Array.map(p11.navigationEvents, tostring), ",\n  "))
		end

		if #p12 > 0 then
			s2 = ("{\n  %s,\n}"):format(table.concat(Array.map(p12, tostring), ",\n  "))
		end

		error(("%s\nGot events: %s\n\nExpected events: %s"):format(v34, s1, s2))
	end
end

return t1
