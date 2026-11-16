local UserInputService = game:GetService("UserInputService")

local module = require("@luauforge/bundled/ftr")
local module2 = require("@luauforge/bundled/fts")
local PlatformIconMap = require("@game/CorePackages/Packages/_Index/BuilderIcons/BuilderIcons/builderIconPlatformUtils/PlatformIconMap")

return function()
	return PlatformIconMap(UserInputService:GetPlatform(), module(), (module2()))
end
