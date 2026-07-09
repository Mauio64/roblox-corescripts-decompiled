local RunService = game:GetService("RunService")
local ParentParent = script.Parent.Parent
local Signals = require(ParentParent.Signals)

require(script.Parent.types)

local createEvent = require(script.Parent.createEvent)

local function createStore(p1, p2, t1: {[any]: any}?, p3, p4) -- line: 18
	-- upvalues: Signals (copy), createEvent (copy), RunService (copy)
	local u12 = false
	local t2 = {{
		type = "@@INIT"
	}}

	local function processActions(p5) -- line: 30
		-- upvalues: t2 (ref), p1 (copy), p2 (ref), p3 (copy)
		local v28 = t2

		t2 = {}

		local v29 = #v28

		for v30, v31 in v28 do
			local co = coroutine.create(function() -- line: 37
				-- upvalues: v30 (copy), v29 (copy), p1 (copy), p2 (ref), v31 (copy), p5 (copy)
				if v30 == v29 then
					return p1(p2, v31, p5)
				end

				return p1(p2, v31, nil)
			end)
			local ok, result = coroutine.resume(co)

			if ok and coroutine.status(co) == "dead" then
				p2 = result
			elseif p3 ~= nil then
				local v35 = ok and "attempted to yield in reducer" or "caught error in reducer"

				p3.reportReducerError(p2, v31, {
					message = v35,
					thrownValue = debug.traceback(co, if ok then v35 else tostring(result))
				})
			end
		end
	end

	local v15, v16 = Signals.createSignal(nil, function() -- line: 61
		return false
	end)
	local v17 = Signals.createComputed(function(p6) -- line: 65
		-- upvalues: v15 (copy), t2 (ref), u12 (ref), processActions (copy), p2 (ref)
		v15(p6)

		if #t2 == 0 then
			table.insert(t2, {
				type = "@@RECONCILE"
			})
		end

		u12 = true
		processActions(p6)
		u12 = false

		return p2
	end)
	local v18, v19 = createEvent()
	local u20 = v17()

	local function flushHandler() -- line: 83
		-- upvalues: v17 (copy), u20 (ref), v19 (copy), p3 (copy)
		local v37 = v17()

		if v37 ~= u20 then
			local v38 = u20

			u20 = v37

			local co = coroutine.create(function() -- line: 89
				-- upvalues: v19 (copy), v37 (copy), v38 (copy)
				v19(v37, v38)
			end)
			local ok, result = coroutine.resume(co)

			if (not ok or coroutine.status(co) ~= "dead") and p3 ~= nil then
				local v42 = ok and "attempted to yield flushing store updates" or "caught error flushing store updates"

				p3.reportUpdateError(v38, v37, {}, {
					message = v42,
					thrownValue = debug.traceback(co, if ok then v42 else tostring(result))
				})
			end
		end
	end

	local connection = RunService.Heartbeat:Connect(flushHandler)
	local u23 = false

	local function u24(p7) -- line: 113
		-- upvalues: t2 (ref), v16 (copy)
		if typeof(p7) ~= "table" or p7.type == nil then
			error("actions must be a table with a 'type' field")
		end

		table.insert(t2, p7)
		v16()
	end

	local t3 = {
		changed = {
			connect = function(_, p9: ((...any) -> ...any)) -- line: 123
				-- upvalues: v18 (copy)
				return {
					disconnect = v18(p9)
				}
			end
		},
		destruct = function(_) -- line: 128
			-- upvalues: u23 (ref), connection (copy)
			if u23 then
				return
			end

			u23 = true
			connection:Disconnect()
		end,
		dispatch = function(_, p12) -- line: 135
			-- upvalues: u12 (ref), u23 (ref), u24 (ref)
			if u12 then
				error("reducers cannot dispatch actions")
			elseif u23 then
				error("cannot dispatch to a destroyed store")
			end

			return u24(p12)
		end,
		getState = function(_, p14) -- line: 143
			-- upvalues: u12 (ref), v17 (copy)
			if u12 then
				error("reducers cannot call getState()")
			end

			return v17(p14)
		end,
		flush = function(_) -- line: 149
			-- upvalues: u12 (ref), u23 (ref), flushHandler (copy)
			if u12 then
				error("reducers cannot flush the store")
			elseif u23 then
				error("cannot flush a destroyed store")
			end

			flushHandler()
		end
	}

	if p4 ~= nil then
		p4:_hookIntoStore(t3)
	end

	if t1 ~= nil and #t1 > 0 then
		for i = #t1, 1, -1 do
			u24 = t1[i](u24, t3)
		end
	end

	return t3
end

return createStore
