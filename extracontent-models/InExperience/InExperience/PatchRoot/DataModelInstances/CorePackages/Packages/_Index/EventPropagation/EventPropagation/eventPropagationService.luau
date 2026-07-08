local ParentParent = script.Parent.Parent
local FocusNavigationUtils = require(ParentParent.FocusNavigationUtils)
local getAncestors = FocusNavigationUtils.getAncestors
local mockableWarn = FocusNavigationUtils.mockableWarn
local eventPropagationEvent = require(script.Parent.eventPropagationEvent)
local __DEBUG_EVENT_PROPAGATION__ = _G.__DEBUG_EVENT_PROPAGATION__

local function describeFunction(p1: ((...any) -> ...any)) -- line: 113
	return table.concat(table.pack(debug.info(p1, "sln")), " ")
end
local function getEventsFromRegistry(t1: {[any]: any}, p2) -- line: 117
	return t1[p2]
end
local function getEventPhasesFromRegistry(t2: {[any]: any}, p3, s1: string) -- line: 121
	local v18 = t2[p3]

	if v18 then
		return v18[s1]
	end

	return nil
end
local function getEventHandler(t3: {[any]: any}, p4, s2: string, p5) -- line: 130
	local v23 = t3[p4]
	local v24 = if not v23 then nil else v23[s2]

	if v24 ~= nil then
		return v24[p5]
	end

	return nil
end

local t4 = {}

t4.__index = t4

function t4.registerEventHandler(t5: {[any]: any}, p6, s3: string, p7: ((...any) -> ...any), p8) -- line: 143
	-- upvalues: __DEBUG_EVENT_PROPAGATION__ (copy), mockableWarn (copy), describeFunction (copy)
	if __DEBUG_EVENT_PROPAGATION__ then
		print("+++ register handler", s3, tostring(p6), p8 or "Bubble")
	end

	local v30 = p8 or "Bubble"

	t5.eventHandlerRegistry[p6] = t5.eventHandlerRegistry[p6] or {}
	t5.eventHandlerRegistry[p6][s3] = t5.eventHandlerRegistry[p6][s3] or {}

	if _G.__DEV__ then
		local v31 = t5.eventHandlerRegistry[p6][s3][v30]

		if v31 then
			mockableWarn(string.format("New handler bound to the %s phase of '%s' will override an existing handler:\n\tprevious handler: %s\n\t     new handler: %s", v30, s3, table.concat(table.pack(debug.info(p7, "sln")), " "), describeFunction(v31)))
		end
	end

	t5.eventHandlerRegistry[p6][s3][v30] = p7
end
function t4.registerEventHandlers(t6: {[any]: any}, p9, t7: {[any]: any}) -- line: 174
	if not t6.eventHandlerRegistry[p9] then
		t6.eventHandlerRegistry[p9] = {}
	end

	for v35, v36 in t7 do
		t6:registerEventHandler(p9, v35, v36.handler, v36.phase)
	end
end
function t4.deregisterEventHandlers(t8: {[any]: any}, p10, t9: {[any]: any}) -- line: 183
	if not t8.eventHandlerRegistry[p10] then
		return
	end

	for v40, v41 in t9 do
		t8:deregisterEventHandler(p10, v40, v41.handler, v41.phase)
	end
end
function t4.deregisterEventHandler(t10: {[any]: any}, p11, s4: string, p12: ((...any) -> ...any), p13) -- line: 192
	-- upvalues: __DEBUG_EVENT_PROPAGATION__ (copy), mockableWarn (copy)
	if __DEBUG_EVENT_PROPAGATION__ then
		print("--- deregister handler", s4, tostring(p11), p13 or "Bubble")
	end

	local v47 = p13 or "Bubble"
	local v48 = t10.eventHandlerRegistry[p11]
	local v49 = if not v48 then nil else v48[s4]

	if v49 and v49[v47] then
		if _G.__DEV__ then
			local v50 = v49[v47]

			if v50 ~= p12 then
				mockableWarn(string.format("Deregistering non-matching event handler bound to the %s phase of '%s':\n\tprevious handler: %s\n\t     new handler: %s", v47, s4, if type(p12) ~= "function" then tostring(p12) else table.concat(table.pack(debug.info(p12, "sln")), " "), if type(v50) ~= "function" then tostring(v50) else table.concat(table.pack(debug.info(v50, "sln")), " ")))
			end
		end

		v49[v47] = nil

		return
	end

	if _G.__DEV__ then
		mockableWarn(string.format("Cannot deregister unregistered event handler bound to the %s phase of '%s'", v47, s4))
	end
end
function t4.getRegisteredEventHandlers(t11: {[any]: any}, p14) -- line: 233
	local v53 = t11.eventHandlerRegistry[p14]

	if v53 then
		local t12 = {}

		for v55, v56 in v53 do
			t12[v55] = next(v56) ~= nil
		end

		return t12
	end

	return nil
end
function t4.propagateEvent(t13: {[any]: any}, p15, s5: string, p16, t14: {[any]: any}?) -- line: 247
	-- upvalues: eventPropagationEvent (copy), getAncestors (copy), __DEBUG_EVENT_PROPAGATION__ (copy)
	local v62 = t14 or {}
	local v63 = v62.synthetic or false

	local function runEventHandler(p17, p18) -- line: 257
		-- upvalues: t13 (copy), s5 (copy), eventPropagationEvent (copy), p15 (copy), v63 (copy), p16 (copy)
		local eventHandlerRegistry = t13.eventHandlerRegistry
		local v89 = s5
		local v90 = eventHandlerRegistry[p17]
		local v91 = if not v90 then nil else v90[v89]
		local v92 = if v91 == nil then nil else v91[p18]

		if v92 then
			local v93 = eventPropagationEvent.new(p15, p17, s5, p18, v63, p16)

			v92(v93)

			return v93.cancelled
		end

		return false
	end

	local v65 = if not (v62.silent or false) then getAncestors(p15) else { p15 }

	if __DEBUG_EVENT_PROPAGATION__ then
		print(">>> capture event", s5, "for", (tostring(p15)))
	end

	for i = #v65, 1, -1 do
		local v67 = v65[i]
		local v68 = t13.eventHandlerRegistry[v67]
		local v69 = if not v68 then nil else v68[s5]
		local v70 = if v69 == nil then nil else v69.Capture
		local cancelled

		if v70 then
			local v71 = eventPropagationEvent.new(p15, v67, s5, "Capture", v63, p16)

			v70(v71)
			cancelled = v71.cancelled
		else
			cancelled = false
		end

		if cancelled then
			return
		end
	end

	local v73 = t13.eventHandlerRegistry[p15]
	local v74 = if not v73 then nil else v73[s5]
	local v75 = if v74 == nil then nil else v74.Target
	local cancelled

	if v75 then
		local v76 = eventPropagationEvent.new(p15, p15, s5, "Target", v63, p16)

		v75(v76)
		cancelled = v76.cancelled
	else
		cancelled = false
	end

	if cancelled then
		return
	end

	if __DEBUG_EVENT_PROPAGATION__ then
		print("<<< bubble event", s5, "from", (tostring(p15)))
	end

	for i = 1, #v65 do
		local v79 = v65[i]
		local v80 = t13.eventHandlerRegistry[v79]
		local v81 = if not v80 then nil else v80[s5]
		local v82 = if v81 == nil then nil else v81.Bubble
		local cancelled2

		if v82 then
			local v83 = eventPropagationEvent.new(p15, v79, s5, "Bubble", v63, p16)

			v82(v83)
			cancelled2 = v83.cancelled
		else
			cancelled2 = false
		end

		if cancelled2 then
			return
		end
	end
end
function t4.new() -- line: 304
	-- upvalues: t4 (copy)
	local t15 = {
		eventHandlerRegistry = setmetatable({}, {
			__mode = "k"
		})
	}

	setmetatable(t15, t4)

	return t15
end

return t4
