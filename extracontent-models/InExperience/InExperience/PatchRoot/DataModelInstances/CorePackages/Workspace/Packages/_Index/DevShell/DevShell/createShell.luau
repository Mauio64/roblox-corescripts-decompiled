local HttpService = game:GetService("HttpService")

local function toError(p)
	if typeof(p) ~= "table" or typeof(p.message) ~= "string" then
		return { message = debug.traceback((tostring(p))) }
	end

	local result = {}

	for k, v in p do
		if typeof(k) == "string" then
			result[k] = v
		end
	end

	return result
end

local function createShell(data)
	local reconnectInterval = data.reconnectInterval or 2
	local v = data.webSocketService
	local v2 = {}

	local v3 = {}
	local contexts = {}
	local v4 = nil
	local v5 = false
	local v6 = false

	local shell = {}

	local function methodNames() -- 1 equivalent call inferred from this helper
		local result = {}

		for k in v2 do
			table.insert(result, k)
		end

		table.sort(result)
		return result
	end

	function shell.hello()
		return { contexts = table.clone(contexts), methods = methodNames() } -- inferred equivalent call
	end

	local function sendHello() -- 4 equivalent calls inferred from this helper
		local v7 = v4

		if v7 == nil then
			return
		end

		pcall(function()
			v7:Send(HttpService:JSONEncode({
				jsonrpc = "2.0",
				method = "shell.hello",
				params = shell.hello()
			}))
		end)
	end

	v2["shell.methods"] = function()
		return shell.hello()
	end

	function shell.registerMethods(value: string, items)
		if value == "" or string.find(value, ".", 1, true) then
			error(`DevShell: namespace "{value}" must be non-empty and contain no "."`, 2)
		end

		if value == "shell" then
			error("DevShell: namespace \"shell\" is reserved", 2)
		end

		local selected = v3[value] and v3[value][items]

		if selected then
			return selected
		end

		local v7 = {}

		for k, item in items do
			local formatted = `{value}.{k}`

			if v2[formatted] ~= nil then
				error(`DevShell: method "{formatted}" is already registered`, 2)
			end

			v7[formatted] = item
		end

		for k, v8 in v7 do
			v2[k] = v8
		end

		sendHello() -- inferred equivalent call
		local function unregister()
			for k, v8 in v7 do
				if v2[k] == v8 then
					v2[k] = nil
				end
			end

			v7 = {}
			local v8 = v3[value]

			if v8 and v8[items] == unregister then
				v8[items] = nil
			end

			sendHello() -- inferred equivalent call
		end
		v3[value] = v3[value] or {}
		v3[value][items] = unregister
		return unregister
	end

	function shell.handleRequest(data2)
		local v7 = typeof(data2) == "table"
		local id

		if v7 then
			id = data2.id
		end

		local jsonrpc

		if v7 then
			jsonrpc = data2.jsonrpc
		end

		local v8 = { id = id, jsonrpc = jsonrpc, result = nil, error = nil }

		if not v7 or typeof(data2.method) ~= "string" then
			v8.error = { message = "Invalid JSON-RPC request" }
			return v8
		end

		local v9 = v2[data2.method]

		if v9 == nil and not string.find(data2.method, ".", 1, true) then
			v9 = v2[`memory.{data2.method}`]
		end

		if v9 == nil then
			v8.error = {
				message = string.format("Unknown method \"%s\"", data2.method)
			}
			return v8
		end

		local success, result = xpcall(function()
			return v9(data2.params)
		end, toError)

		if success then
			v8.result = result
		else
			v8.error = result
		end

		return v8
	end

	function shell.isConnected(): boolean
		return v4 ~= nil
	end

	local connectWithRetry

	local function tryConnect(): boolean
		if v4 ~= nil then
			return true
		end

		local v7 = v

		if v7 == nil then
			return false
		end

		local success, result = pcall(function()
			return v7:CreateClient(data.host)
		end)

		if not (success and result) then
			return false
		end

		v4 = result

		result.Closed:Connect(function()
			if v4 ~= result then
				return
			end

			v4 = nil

			if not v5 then
				return
			end

			task.delay(reconnectInterval, connectWithRetry)
		end)

		result.MessageReceived:Connect(function(json: string)
			pcall(function()
				local jsonDecode = HttpService:JSONDecode(json)

				if typeof(jsonDecode) == "table" and jsonDecode.id == nil then
					return
				end

				result:Send(HttpService:JSONEncode(shell.handleRequest(jsonDecode)))
			end)
		end)
		sendHello() -- inferred equivalent call
		return true
	end

	connectWithRetry = function()
		if v6 or not v5 then
			return
		end

		v6 = true
		task.spawn(function()
			while v5 and v4 == nil and not tryConnect() do
				task.wait(reconnectInterval)
			end

			v6 = false
		end)
	end

	function shell.start(p)
		if not table.find(contexts, p.context) then
			table.insert(contexts, p.context)
			sendHello() -- inferred equivalent call
		end

		if v5 or not data.enabled then
			return
		end

		if v == nil then
			local success, result = pcall(function()
				return game:GetService("WebSocketService")
			end)

			if not success or result == nil then
				return
			end

			v = result
		end

		v5 = true
		connectWithRetry()
	end

	function shell.stop()
		v5 = false
		local v7 = v4
		v4 = nil

		if v7 then
			pcall(function()
				v7:Close()
			end)
		end
	end

	return shell
end

return createShell
