local ScriptProfilerService = game:GetService("ScriptProfilerService")
local Players = game:GetService("Players")

local CoreScriptsProfiler = {}
CoreScriptsProfiler.__index = CoreScriptsProfiler

function CoreScriptsProfiler.new(callback)
	local self = setmetatable({}, CoreScriptsProfiler)

	self._isProfiling = false
	self._isClient = false
	self._player = Players.LocalPlayer
	local connection

	if callback then
		connection = ScriptProfilerService.OnNewData:Connect(function(p, p2: string)
			local v = p ~= nil

			if callback then
				callback(v, p2)
			end
		end)
	end

	self._connection = connection

	return self
end

function CoreScriptsProfiler:ClientStart(value: number?)
	if self._isProfiling then
		return
	end

	ScriptProfilerService:ClientStart(self._player, value or 1000)

	self._isProfiling = true
	self._isClient = true
end

function CoreScriptsProfiler:ClientStop()
	if not (self._isProfiling and self._isClient) then
		return
	end

	ScriptProfilerService:ClientStop(self._player)
	ScriptProfilerService:ClientRequestData(self._player)

	self._isProfiling = false
	self._isClient = false
end

function CoreScriptsProfiler:ServerStart(value: number?)
	if self._isProfiling then
		return
	end

	ScriptProfilerService:ServerStart(value or 1000)

	self._isProfiling = true
	self._isClient = false
end

function CoreScriptsProfiler:ServerStop()
	if not self._isProfiling or self._isClient then
		return
	end

	ScriptProfilerService:ServerStop()
	ScriptProfilerService:ServerRequestData()

	self._isProfiling = false
end

function CoreScriptsProfiler:IsProfiling()
	return self._isProfiling
end

function CoreScriptsProfiler:Disconnect()
	if self._connection then
		self._connection:Disconnect()
		self._connection = nil
	end
end

return CoreScriptsProfiler
