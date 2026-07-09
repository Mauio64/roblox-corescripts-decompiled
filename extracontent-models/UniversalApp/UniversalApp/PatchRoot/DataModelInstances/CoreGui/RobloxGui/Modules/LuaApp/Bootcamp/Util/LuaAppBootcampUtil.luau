local CorePackages = game:GetService("CorePackages")
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging

Logging.warn("Lua App Bootcamp Enabled")

local t1 = {}
local LuaAppIntroBootcamp = require(script.Parent.Parent.LuaAppIntroBootcamp)

function t1.runBootcamp(_) -- line: 8
	-- upvalues: LuaAppIntroBootcamp (copy), Logging (copy)
	for _, v in ipairs(LuaAppIntroBootcamp) do
		Logging.warn(v)
	end
end

return t1
