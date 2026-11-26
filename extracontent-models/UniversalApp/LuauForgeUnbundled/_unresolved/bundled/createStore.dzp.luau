local RunService = game:GetService("RunService")

local module = require("@luauforge/bundled/dzn")

require("@luauforge/bundled/dzm")

local module2 = require("@luauforge/bundled/dzq")

local function createStore(callback, p2, list, p3, object)
	local v5 = p2

	local flag = false
	local v6 = { nil }
	v6[1] = { type = "@@INIT" }

	local function processActions(p4)
		local v7 = v6
		v6 = {}

		local count = #v7

		for k, v8 in v7 do
			local thread = coroutine.create(function()
				if k == count then
					return callback(v5, v8, p4)
				end

				return callback(v5, v8, nil)
			end)

			local v9, v10 = coroutine.resume(thread)

			if v9 and coroutine.status(thread) == "dead" then
				v5 = v10
			elseif p3 ~= nil then
				local v11 = v9 and "attempted to yield in reducer" or "caught error in reducer"
				local reportReducerError = p3.reportReducerError
				local v12 = v5
				local v13 = { message = v11, thrownValue = 0 }

				local traceback = debug.traceback

				if not v9 then
					v11 = tostring(v10)
				end

				v13.thrownValue = traceback(thread, v11)
				reportReducerError(v12, v8, v13)
			end
		end
	end

	local signal, v7 = module.createSignal(nil, function(): boolean
		return false
	end)

	local computed = module.createComputed(function(p4)
		signal(p4)

		if #v6 == 0 then
			table.insert(v6, { type = "@@RECONCILE" })
		end

		flag = true
		processActions(p4)
		flag = false

		return v5
	end)

	local v8, v9 = module2()

	local v10 = computed()

	local function flushHandler()
		local v11 = computed()

		if v11 ~= v10 then
			local v12 = v10
			v10 = v11

			local thread = coroutine.create(function()
				v9(v11, v12)
			end)

			local v13, v14 = coroutine.resume(thread)

			if (not v13 or coroutine.status(thread) ~= "dead") and p3 ~= nil then
				local v15 = v13 and "attempted to yield flushing store updates"
					or "caught error flushing store updates"
				local reportUpdateError = p3.reportUpdateError
				local v17 = { message = v15, thrownValue = 0 }

				local traceback = debug.traceback

				if not v13 then
					v15 = tostring(v14)
				end

				v17.thrownValue = traceback(thread, v15)
				reportUpdateError(v12, v11, {}, v17)
			end
		end
	end

	local heartbeatConnection = RunService.Heartbeat:Connect(flushHandler)

	local flag2 = false

	local function fn(p4)
		if typeof(p4) ~= "table" or p4.type == nil then
			error("actions must be a table with a 'type' field")
		end

		table.insert(v6, p4)
		v7()
	end

	local store = {
		changed = {
			connect = function(p4, p5)
				return { disconnect = v8(p5) }
			end
		},
		destruct = function(p4)
			if flag2 then
				return
			end

			flag2 = true
			heartbeatConnection:Disconnect()
		end,
		dispatch = function(p4, p5)
			if flag then
				error("reducers cannot dispatch actions")
			elseif flag2 then
				error("cannot dispatch to a destroyed store")
			end

			return fn(p5)
		end,
		getState = function(p4, p5)
			if flag then
				error("reducers cannot call getState()")
			end

			return computed(p5)
		end,
		flush = function(p4)
			if flag then
				error("reducers cannot flush the store")
			elseif flag2 then
				error("cannot flush a destroyed store")
			end

			flushHandler()
		end
	}

	if object ~= nil then
		object:_hookIntoStore(store)
	end

	if list ~= nil and #list > 0 then
		for i = #list, 1, -1 do
			fn = list[i](fn, store)
		end
	end

	return store
end

return createStore
