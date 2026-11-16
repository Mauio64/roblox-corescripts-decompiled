local HttpService = game:GetService("HttpService")

local MemoryTracker = require(script.Parent.Parent.Common.MemoryTracker)
local GarbageCollector = require(script.Parent.Parent.Common.GarbageCollector)

local defineFastString = game:DefineFastString("MemoryShellHost", "ws://localhost:5013")

local class = {}
class.__index = class

local function getMemoryTracker() -- 2 equivalent calls inferred from this helper
	return MemoryTracker()
end

local v = {
	getLuaHeap = function()
		GarbageCollector.collect()
		local memoryTracker = getMemoryTracker() -- inferred equivalent call

		if memoryTracker then
			return memoryTracker.getLuaHeapOnly()
		end

		return { luaHeapMb = "-1" }
	end,
	getSnapshot = function()
		GarbageCollector.collect()
		local memoryTracker = getMemoryTracker() -- inferred equivalent call

		if memoryTracker then
			return memoryTracker.getSnapshot()
		end

		return { luaHeapMb = "-1" }
	end,
	forceGC = function(): string
		GarbageCollector.collect()
		return "ok"
	end
}

local function handleRequest(data)
	local v2 = { id = data.id, jsonrpc = data.jsonrpc, result = nil, error = nil }

	local v3 = v[data.method]

	if v3 == nil then
		v2.error = {
			message = string.format("Unknown method \"%s\"", (tostring(data.method)))
		}
		return v2
	end

	local success, result = xpcall(v3, function(p)
		return debug.traceback(p)
	end)

	if success then
		v2.result = result
		return v2
	end

	v2.error = { message = result }

	return v2
end

local function tryConnect(object): boolean
	if not object._WebSocketService then
		return false
	end

	if object._connected then
		return true
	end

	local v2 = defineFastString
	local v3 = nil

	if not (pcall(function()
		v3 = object._WebSocketService:CreateClient(v2)
	end) and v3) then
		return false
	end

	object._connected = true

	v3.Closed:Connect(function()
		object._connected = false
		object:_connectWithRetry()
	end)

	v3.MessageReceived:Connect(function(json)
		xpcall(function()
			local v4 = handleRequest(HttpService:JSONDecode(json))
			v3:Send(HttpService:JSONEncode(v4))
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
	return (setmetatable({ _connected = false, _retrying = false, _WebSocketService = nil }, class))
end

function class:start()
	if not self._WebSocketService then
		local webSocketService = nil

		if pcall(function()
			local WebSocketService = game:GetService("WebSocketService")
			webSocketService = WebSocketService
		end) and webSocketService then
			self._WebSocketService = webSocketService
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
