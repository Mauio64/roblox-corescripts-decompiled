local HttpService = game:GetService("HttpService")

local MemoryTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/Memory/Memory/Common/MemoryTracker")
local GarbageCollector = require("@game/CorePackages/Workspace/Packages/_Workspace/Memory/Memory/Common/GarbageCollector")

local defineFastString = game:DefineFastString("MemoryShellHost", "ws://localhost:5013")

local class = {}
class.__index = class

local function getMemoryTracker()
	return MemoryTracker()
end

local v5 = {
	getLuaHeap = function()
		GarbageCollector.collect()
		local v6 = MemoryTracker()

		if v6 then
			return v6.getLuaHeapOnly()
		end

		return { luaHeapMb = "-1" }
	end,
	getSnapshot = function()
		GarbageCollector.collect()
		local v6 = MemoryTracker()

		if v6 then
			return v6.getSnapshot()
		end

		return { luaHeapMb = "-1" }
	end,
	forceGC = function(): string
		GarbageCollector.collect()
		return "ok"
	end
}

local function handleRequest(data)
	local v6 = { id = data.id, jsonrpc = data.jsonrpc, result = nil, error = nil }

	local v7 = v5[data.method]

	if v7 == nil then
		v6.error = {
			message = string.format("Unknown method \"%s\"", (tostring(data.method)))
		}
		return v6
	end

	local success, result = xpcall(v7, function(p2)
		return debug.traceback(p2)
	end)

	if success then
		v6.result = result
		return v6
	end

	v6.error = { message = result }

	return v6
end

local function tryConnect(object): boolean
	if not object._WebSocketService then
		return false
	end

	if object._connected then
		return true
	end

	local v6 = defineFastString
	local v7 = nil

	if not (pcall(function()
		v7 = object._WebSocketService:CreateClient(v6)
	end) and v7) then
		return false
	end

	object._connected = true

	v7.Closed:Connect(function()
		object._connected = false
		object:_connectWithRetry()
	end)

	v7.MessageReceived:Connect(function(json)
		xpcall(function()
			local v8 = handleRequest(HttpService:JSONDecode(json))
			v7:Send(HttpService:JSONEncode(v8))
		end, function() end)
	end)

	return true
end

function class:_connectWithRetry()
	if self._retrying then
		return
	end

	task.spawn(function()
		self._retrying = true

		while not (self._connected or tryConnect(self)) do
			task.wait(5)
		end

		self._retrying = false
	end)
end

function class.new()
	return (setmetatable({
		_connected = false,
		_retrying = false,
		_WebSocketService = nil
	}, class))
end

function class:start()
	if not self._WebSocketService then
		local v6 = nil

		if pcall(function()
			local WebSocketService = game:GetService("WebSocketService")
			v6 = WebSocketService
		end) and v6 then
			self._WebSocketService = v6
		else
			return
		end
	end

	self:_connectWithRetry()
end

function class:reconnect()
	self._connected = false
	self._retrying = false
	self:_connectWithRetry()
end

return class.new()
