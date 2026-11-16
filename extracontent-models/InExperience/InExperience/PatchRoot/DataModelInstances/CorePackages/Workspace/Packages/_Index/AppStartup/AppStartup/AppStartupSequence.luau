local ScriptContext = game:GetService("ScriptContext")
local engineFeature = game:GetEngineFeature("LuaAppCompression")
local parent = script:FindFirstAncestor("AppStartup").Parent
local AppCommonLib = require(parent.AppCommonLib)
local Signal = AppCommonLib.Signal

local AppStartupSequence = {}

AppStartupSequence.__index = AppStartupSequence

function AppStartupSequence.new()
	local v = { changed = Signal.new(), isInteractive = false }

	setmetatable(v, AppStartupSequence)
	return v
end

function AppStartupSequence:setInteractive()
	if self.isInteractive then
		return
	end

	self.isInteractive = true

	if engineFeature then
		ScriptContext:CompressLuaApp()
	end

	self.changed:fire()
end

AppStartupSequence.default = AppStartupSequence.new()

return AppStartupSequence
