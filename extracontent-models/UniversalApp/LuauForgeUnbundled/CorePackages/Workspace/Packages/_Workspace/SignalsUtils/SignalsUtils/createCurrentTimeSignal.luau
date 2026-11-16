local RunService = game:GetService("RunService")

local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SignalsUtils/Signals")

local object = setmetatable({}, { __mode = "v" })
local heartbeatConnection = nil

local function maybeDisconnect()
	if next(object) == nil and heartbeatConnection then
		heartbeatConnection:Disconnect()
		heartbeatConnection = nil
	end
end

local function onHeartbeat()
	if next(object) == nil and heartbeatConnection then
		heartbeatConnection:Disconnect()
		heartbeatConnection = nil
	end

	if not heartbeatConnection then
		return
	end

	local now = os.clock()

	for k, v5 in object do
		if not (k <= now - v5.lastTick) then
			continue
		end

		v5.lastTick = now
		v5.setter(DateTime.now().UnixTimestamp)
	end
end

local function ensureConnection()
	if not heartbeatConnection then
		heartbeatConnection = RunService.Heartbeat:Connect(onHeartbeat)
	end
end

local function createCurrentTimeSignal(value)
	local v5 = value or 30

	if not object[v5] then
		local signal, v6 = Signals.createSignal(DateTime.now().UnixTimestamp)
		object[v5] = { getter = signal, setter = v6, lastTick = os.clock() }

		if not heartbeatConnection then
			heartbeatConnection = RunService.Heartbeat:Connect(onHeartbeat)
		end
	end

	local v6 = object[v5]

	return function(p2)
		return v6.getter(p2)
	end
end

return createCurrentTimeSignal
