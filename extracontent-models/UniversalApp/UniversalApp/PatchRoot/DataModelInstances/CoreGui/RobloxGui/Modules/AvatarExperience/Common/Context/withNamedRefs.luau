local Modules = game:GetService("CoreGui").RobloxGui.Modules
local NamedRefsContext = require(Modules.AvatarExperience.Common.Context.NamedRefsContext)
local withContextValue = require(Modules.AvatarExperience.Common.withContextValue)

local function withNamedRefs(p1) -- line: 12
	-- upvalues: withContextValue (copy), NamedRefsContext (copy)
	return withContextValue(p1, NamedRefsContext.Consumer, "namedRefs")
end

return withNamedRefs
