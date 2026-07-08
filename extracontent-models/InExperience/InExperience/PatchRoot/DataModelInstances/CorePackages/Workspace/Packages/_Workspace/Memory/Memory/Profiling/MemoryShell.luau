local HttpService = game:GetService("HttpService")
local MemoryTracker = require(script.Parent.Parent.Common.MemoryTracker)
local GarbageCollector = require(script.Parent.Parent.Common.GarbageCollector)
local v4 = game:DefineFastString("MemoryShellHost", "ws://localhost:5013")
local t1 = {}

t1.__index = t1

local function getMemoryTracker() -- line: 23
	-- upvalues: MemoryTracker (copy)
	return MemoryTracker()
end

local t2 = {
	getLuaHeap = function() -- line: 28
		-- upvalues: GarbageCollector (copy), MemoryTracker (copy)
		GarbageCollector.collect()

		local v10 = MemoryTracker()

		if v10 then
			return v10.getLuaHeapOnly()
		end

		return {
			luaHeapMb = "-1"
		}
	end,
	getSnapshot = function() -- line: 36
		-- upvalues: GarbageCollector (copy), MemoryTracker (copy)
		GarbageCollector.collect()

		local v11 = MemoryTracker()

		if v11 then
			return v11.getSnapshot()
		end

		return {
			luaHeapMb = "-1"
		}
	end,
	forceGC = function() -- line: 44
		-- upvalues: GarbageCollector (copy)
		GarbageCollector.collect()

		return "ok"
	end
}

local function handleRequest(p1) -- line: 50
	-- upvalues: t2 (copy)
	local t3 = {
		result = nil,
		error = nil,
		id = p1.id,
		jsonrpc = p1.jsonrpc
	}
	local v14 = t2[p1.method]

	if v14 == nil then
		t3.error = {
			message = string.format("Unknown method \"%s\"", (tostring(p1.method)))
		}

		return t3
	end

	local ok, result = xpcall(v14, function(err) -- line: 62
		return debug.traceback(err)
	end)

	if ok then
		t3.result = result

		return t3
	end

	t3.error = {
		message = result
	}

	return t3
end
local function tryConnect(p2) -- line: 75
	-- upvalues: v4 (copy), HttpService (copy), handleRequest (copy)
	if not p2._WebSocketService then
		return false
	end

	if p2._connected then
		return true
	end

	local v18 = v4
	local u19 = nil

	if not pcall(function() -- line: 86
		-- upvalues: u19 (ref), p2 (copy), v18 (copy)
		u19 = p2._WebSocketService:CreateClient(v18)
	end) or not u19 then
		return false
	end

	p2._connected = true
	u19.Closed:Connect(function() -- line: 95
		-- upvalues: p2 (copy)
		p2._connected = false
		p2:_connectWithRetry()
	end)
	u19.MessageReceived:Connect(function(p3) -- line: 100
		-- upvalues: HttpService (copy), handleRequest (copy), u19 (ref)
		xpcall(function() -- line: 101
			-- upvalues: HttpService (copy), p3 (copy), handleRequest (copy), u19 (ref)
			local data = HttpService:JSONDecode(p3)
			local v27 = handleRequest(data)

			u19:Send(HttpService:JSONEncode(v27))
		end, function() -- line: 105
		end)
	end)

	return true
end

function t1._connectWithRetry(p4) -- line: 111
	-- upvalues: tryConnect (copy)
	if p4._retrying then
		return
	end

	task.spawn(function() -- line: 115
		-- upvalues: p4 (copy), tryConnect (copy)
		p4._retrying = true

		while not p4._connected and not tryConnect(p4) do
			task.wait(5)
		end

		p4._retrying = false
	end)
end
function t1.new() -- line: 127
	-- upvalues: t1 (copy)
	return (setmetatable({
		_connected = false,
		_retrying = false,
		_WebSocketService = nil
	}, t1))
end
function t1.start(p5) -- line: 136
	if not p5._WebSocketService then
		local WebSocketService = nil

		if not pcall(function() -- line: 139
			-- upvalues: WebSocketService (ref)
			WebSocketService = game:GetService("WebSocketService")
		end) or not WebSocketService then
			return
		end

		p5._WebSocketService = WebSocketService
	end

	p5:_connectWithRetry()
end
function t1.reconnect(p6) -- line: 151
	p6._connected = false
	p6._retrying = false
	p6:_connectWithRetry()
end

return t1.new()
