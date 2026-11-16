local ScriptContext = game:GetService("ScriptContext")
local engineFeature = game:GetEngineFeature("LuaAppCompression")

local signal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStartup/AppCommonLib").Signal

local class = {}

class.__index = class

function class.new()
	local v5 = { changed = signal.new(), isInteractive = false }

	setmetatable(v5, class)
	return v5
end

function class:setInteractive()
	if self.isInteractive then
		return
	end

	self.isInteractive = true

	if engineFeature then
		ScriptContext:CompressLuaApp()
	end

	self.changed:fire()
end

class.default = class.new()

return class
