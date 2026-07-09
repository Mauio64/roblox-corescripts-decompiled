local Modules = game:GetService("CoreGui").RobloxGui.Modules
local User = require(Modules.LuaApp.Models.User)

return {
	[User.PresenceType.OFFLINE] = nil,
	[User.PresenceType.ONLINE] = "component_assets/circle_16",
	[User.PresenceType.IN_GAME] = "icons/menu/games_small",
	[User.PresenceType.IN_STUDIO] = "icons/logo/studiologo_small"
}
