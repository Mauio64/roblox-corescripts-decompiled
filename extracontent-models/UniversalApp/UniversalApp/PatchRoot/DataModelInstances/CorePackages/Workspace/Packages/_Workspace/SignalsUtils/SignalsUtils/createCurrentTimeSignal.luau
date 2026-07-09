local RunService = game:GetService("RunService")
local Parent = script:FindFirstAncestor("SignalsUtils").Parent
local Signals = require(Parent.Signals)
local self = setmetatable({}, {
	__mode = "v"
})
local u5 = nil

local function maybeDisconnect() -- line: 18
	-- upvalues: self (copy), u5 (ref)
	if next(self) == nil and u5 then
		u5:Disconnect()
		u5 = nil
	end
end
local function onHeartbeat() -- line: 25
	-- upvalues: self (copy), u5 (ref)
	if next(self) == nil and u5 then
		u5:Disconnect()
		u5 = nil
	end

	if not u5 then
		return
	end

	local elapsed = os.clock()

	for v11, v12 in self do
		if v11 <= elapsed - v12.lastTick then
			v12.lastTick = elapsed
			v12.setter(DateTime.now().UnixTimestamp)
		end
	end
end
local function ensureConnection() -- line: 40
	-- upvalues: u5 (ref), RunService (copy), onHeartbeat (copy)
	if not u5 then
		u5 = RunService.Heartbeat:Connect(onHeartbeat)
	end
end
local function createCurrentTimeSignal(n1: number?) -- line: 46
	-- upvalues: self (copy), Signals (copy), u5 (ref), RunService (copy), onHeartbeat (copy)
	local v14 = n1 or 30

	if not self[v14] then
		local v15, v16 = Signals.createSignal(DateTime.now().UnixTimestamp)

		self[v14] = {
			getter = v15,
			setter = v16,
			lastTick = os.clock()
		}

		if not u5 then
			u5 = RunService.Heartbeat:Connect(onHeartbeat)
		end
	end

	local v17 = self[v14]

	return function(p1) -- line: 63
		-- upvalues: v17 (copy)
		return v17.getter(p1)
	end
end

return createCurrentTimeSignal
