local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Immutable = require(Modules.Common.Immutable)
local SetGameSocialLinks = require(Modules.LuaApp.Actions.Games.SetGameSocialLinks)

return function(t1: {[any]: any}?, p1) -- line: 11
	-- upvalues: SetGameSocialLinks (copy), Immutable (copy)
	local v6 = t1 or {}

	assert(v6, "")

	if p1.type == SetGameSocialLinks.name then
		v6 = Immutable.Set(v6, p1.universeId, p1.socialLinks)
	end

	return v6
end
