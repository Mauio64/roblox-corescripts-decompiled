local RunService = game:GetService("RunService")

local parent = script:FindFirstAncestor("SignalsUtils").Parent
local Signals = require(parent.Signals)

local object = setmetatable({}, { __mode = "v" })
local heartbeatConnection = nil

local function maybeDisconnect() -- 1 equivalent call inferred from this helper
	if next(object) == nil and heartbeatConnection then
		heartbeatConnection:Disconnect()
		heartbeatConnection = nil
	end
end

local function onHeartbeat()
	maybeDisconnect() -- inferred equivalent call

	if not heartbeatConnection then
		return
	end

	local now = os.clock()

	for k, v in object do
		if not (k <= now - v.lastTick) then
			continue
		end

		v.lastTick = now
		v.setter(DateTime.now().UnixTimestamp)
	end
end

local function ensureConnection() -- 1 equivalent call inferred from this helper
	if not heartbeatConnection then
		heartbeatConnection = RunService.Heartbeat:Connect(onHeartbeat)
	end
end

local function createCurrentTimeSignal(value: number?)
	local v = value or 30

	if not object[v] then
		local signal, setter = Signals.createSignal(DateTime.now().UnixTimestamp)
		object[v] = { getter = signal, setter = setter, lastTick = os.clock() }
		ensureConnection() -- inferred equivalent call
	end

	local v2 = object[v]

	return function(p)
		return v2.getter(p)
	end
end

return createCurrentTimeSignal
