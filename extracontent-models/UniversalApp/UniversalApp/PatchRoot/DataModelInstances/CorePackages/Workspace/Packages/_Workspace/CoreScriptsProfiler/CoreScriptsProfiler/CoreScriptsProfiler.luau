local ScriptProfilerService = game:GetService("ScriptProfilerService")
local Players = game:GetService("Players")
local t1 = {}

t1.__index = t1

function t1.new(p1: ((...any) -> ...any)?) -- line: 37
	-- upvalues: t1 (copy), Players (copy), ScriptProfilerService (copy)
	local self = setmetatable({}, t1)

	self._isProfiling = false
	self._isClient = false
	self._player = Players.LocalPlayer
	self._connection = if not p1 then nil else ScriptProfilerService.OnNewData:Connect(function(p2, s1: string) -- line: 45
		-- upvalues: p1 (copy)
		local v18 = p2 ~= nil

		if p1 then
			p1(v18, s1)
		end
	end)

	return self
end
function t1.ClientStart(t2: {[any]: any}, n1: number?) -- line: 58
	-- upvalues: ScriptProfilerService (copy)
	if t2._isProfiling then
		return
	end

	local v8 = n1 or 1000

	ScriptProfilerService:ClientStart(t2._player, v8)
	t2._isProfiling = true
	t2._isClient = true
end
function t1.ClientStop(p3) -- line: 70
	-- upvalues: ScriptProfilerService (copy)
	if not p3._isProfiling or not p3._isClient then
		return
	end

	ScriptProfilerService:ClientStop(p3._player)
	ScriptProfilerService:ClientRequestData(p3._player)
	p3._isProfiling = false
	p3._isClient = false
end
function t1.ServerStart(t3: {[any]: any}, n2: number?) -- line: 82
	-- upvalues: ScriptProfilerService (copy)
	if t3._isProfiling then
		return
	end

	local v12 = n2 or 1000

	ScriptProfilerService:ServerStart(v12)
	t3._isProfiling = true
	t3._isClient = false
end
function t1.ServerStop(p4) -- line: 94
	-- upvalues: ScriptProfilerService (copy)
	if not p4._isProfiling or p4._isClient then
		return
	end

	ScriptProfilerService:ServerStop()
	ScriptProfilerService:ServerRequestData()
	p4._isProfiling = false
end
function t1.IsProfiling(p5) -- line: 105
	return p5._isProfiling
end
function t1.Disconnect(p6) -- line: 109
	if p6._connection then
		p6._connection:Disconnect()
		p6._connection = nil
	end
end

return t1
