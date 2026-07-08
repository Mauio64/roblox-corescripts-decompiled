local ScriptContext = game:GetService("ScriptContext")
local EngineFeature = game:GetEngineFeature("LuaAppCompression")
local Parent = script:FindFirstAncestor("AppStartup").Parent
local Signal = require(Parent.AppCommonLib).Signal
local t1 = {}

t1.__index = t1

function t1.new() -- line: 22
	-- upvalues: Signal (copy), t1 (copy)
	local t2 = {
		isInteractive = false,
		changed = Signal.new()
	}

	setmetatable(t2, t1)

	return t2
end
function t1.setInteractive(p1) -- line: 31
	-- upvalues: EngineFeature (copy), ScriptContext (copy)
	if p1.isInteractive then
		return
	end

	p1.isInteractive = true

	if EngineFeature then
		ScriptContext:CompressLuaApp()
	end

	p1.changed:fire()
end

t1.default = t1.new()

return t1
