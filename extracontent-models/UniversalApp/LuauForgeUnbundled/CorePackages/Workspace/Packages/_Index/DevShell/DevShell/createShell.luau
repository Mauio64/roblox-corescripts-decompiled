local HttpService = game:GetService("HttpService")

local function toError(p2)
	if typeof(p2) ~= "table" or typeof(p2.message) ~= "string" then
		return {
			message = debug.traceback((tostring(p2)))
		}
	end

	local result = {}

	for k, v5 in p2 do
		if typeof(k) == "string" then
			result[k] = v5
		end
	end

	return result
end

local function createShell(data)
	local reconnectInterval = data.reconnectInterval or 2
	local v5 = data.webSocketService
	local v6 = {}

	local v7 = {}
	local contexts = {}
	local v8 = nil
	local v9 = false
	local v10 = false

	local shell = {}

	local function methodNames()
		local result = {}

		for k in v6 do
			table.insert(result, k)
		end

		table.sort(result)
		return result
	end

	function shell.hello()
		local v11 = { contexts = table.clone(contexts), methods = 0 }
		local v12 = {}

		for k in v6 do
			table.insert(v12, k)
		end

		table.sort(v12)

		v11.methods = v12
		return v11
	end

	local function sendHello()
		local v11 = v8

		if v11 == nil then
			return
		end

		pcall(function()
			v11:Send(HttpService:JSONEncode({
				jsonrpc = "2.0",
				method = "shell.hello",
				params = shell.hello()
			}))
		end)
	end

	v6["shell.methods"] = function()
		return shell.hello()
	end

	function shell.registerMethods(value, items)
		if value == "" or string.find(value, ".", 1, true) then
			error(`DevShell: namespace "{value}" must be non-empty and contain no "."`, 2)
		end

		if value == "shell" then
			error("DevShell: namespace \"shell\" is reserved", 2)
		end

		local v11 = v7[value] and v7[value][items]

		if v11 then
			return v11
		end

		local v12 = {}

		for k, item in items do
			local formatted = `{value}.{k}`

			if v6[formatted] ~= nil then
				error(`DevShell: method "{formatted}" is already registered`, 2)
			end

			v12[formatted] = item
		end

		for k, v13 in v12 do
			v6[k] = v13
		end

		local v13 = v8

		if v13 ~= nil then
			pcall(function()
				v13:Send(HttpService:JSONEncode({
					jsonrpc = "2.0",
					method = "shell.hello",
					params = shell.hello()
				}))
			end)
		end

		local function unregister()
			for k, v14 in v12 do
				if v6[k] == v14 then
					v6[k] = nil
				end
			end

			v12 = {}
			local v14 = v7[value]

			if v14 and v14[items] == unregister then
				v14[items] = nil
			end

			local v15 = v8

			if v15 == nil then
				return
			end

			pcall(function()
				v15:Send(HttpService:JSONEncode({
					jsonrpc = "2.0",
					method = "shell.hello",
					params = shell.hello()
				}))
			end)
		end
		v7[value] = v7[value] or {}
		v7[value][items] = unregister
		return unregister
	end

	function shell.handleRequest(data2)
		local v11 = typeof(data2) == "table"

		local v13 = if v11 then data2.id else nil
		local v14 = if v11 then data2.jsonrpc else nil
		local v12 = { id = v13, jsonrpc = v14, result = nil, error = nil }

		if not v11 or typeof(data2.method) ~= "string" then
			v12.error = { message = "Invalid JSON-RPC request" }
			return v12
		end

		local v15 = v6[data2.method]

		if v15 == nil and not string.find(data2.method, ".", 1, true) then
			v15 = v6[`memory.{data2.method}`]
		end

		if v15 == nil then
			v12.error = {
				message = string.format("Unknown method \"%s\"", data2.method)
			}
			return v12
		end

		local success, result = xpcall(function()
			return v15(data2.params)
		end, toError)

		if success then
			v12.result = result
		else
			v12.error = result
		end

		return v12
	end

	function shell.isConnected(): boolean
		return v8 ~= nil
	end

	local connectWithRetry

	local function tryConnect(): boolean
		if v8 ~= nil then
			return true
		end

		local v11 = v5

		if v11 == nil then
			return false
		end

		local success, result = pcall(function()
			return v11:CreateClient(data.host)
		end)

		if not (success and result) then
			return false
		end

		v8 = result

		result.Closed:Connect(function()
			if v8 ~= result then
				return
			end

			v8 = nil

			if not v9 then
				return
			end

			task.delay(reconnectInterval, connectWithRetry)
		end)

		result.MessageReceived:Connect(function(json)
			pcall(function()
				local jsonDecode = HttpService:JSONDecode(json)

				if typeof(jsonDecode) == "table" and jsonDecode.id == nil then
					return
				end

				result:Send(HttpService:JSONEncode(shell.handleRequest(jsonDecode)))
			end)
		end)
		local v12 = v8

		if v12 ~= nil then
			pcall(function()
				v12:Send(HttpService:JSONEncode({
					jsonrpc = "2.0",
					method = "shell.hello",
					params = shell.hello()
				}))
			end)
		end

		return true
	end

	connectWithRetry = function()
		if v10 or not v9 then
			return
		end

		v10 = true
		task.spawn(function()
			while v9 and v8 == nil and not tryConnect() do
				task.wait(reconnectInterval)
			end

			v10 = false
		end)
	end

	function shell.start(p2)
		if not table.find(contexts, p2.context) then
			table.insert(contexts, p2.context)
			local v11 = v8

			if v11 ~= nil then
				pcall(function()
					v11:Send(HttpService:JSONEncode({
						jsonrpc = "2.0",
						method = "shell.hello",
						params = shell.hello()
					}))
				end)
			end
		end

		if v9 or not data.enabled then
			return
		end

		if v5 == nil then
			local success, result = pcall(function()
				return game:GetService("WebSocketService")
			end)

			if not success or result == nil then
				return
			end

			v5 = result
		end

		v9 = true
		connectWithRetry()
	end

	function shell.stop()
		v9 = false
		local v11 = v8
		v8 = nil

		if v11 then
			pcall(function()
				v11:Close()
			end)
		end
	end

	return shell
end

return createShell
