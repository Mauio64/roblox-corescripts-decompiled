local ParentParent = script.Parent.Parent.Parent
local console = require(ParentParent.LuauPolyfill).console

local function infoLog(...) -- line: 18
	-- upvalues: console (copy)
	return console.log(...)
end

return infoLog
