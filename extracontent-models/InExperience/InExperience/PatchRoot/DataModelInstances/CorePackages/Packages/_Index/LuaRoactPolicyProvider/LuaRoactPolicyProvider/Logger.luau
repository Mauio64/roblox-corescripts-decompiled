local parent = script.Parent.Parent
local Lumberyak = require(parent.Lumberyak)

if game:DefineFastFlag("RoactPolicyLoggerName", false) then
	return (Lumberyak.Logger.new(nil, "LuaRoactPolicyProvider"))
end

return (Lumberyak.Logger.new())
