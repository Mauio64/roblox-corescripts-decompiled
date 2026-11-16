local module = require("@luauforge/deferred/gjp")

local module2 = require("@luauforge/deferred/gjz")
local module3 = require("@luauforge/deferred/gjB")

local function FolderNavigationBarContainer(p2)
	local v5 = module3(p2)
	return module.createElement(module2, v5)
end

return FolderNavigationBarContainer
