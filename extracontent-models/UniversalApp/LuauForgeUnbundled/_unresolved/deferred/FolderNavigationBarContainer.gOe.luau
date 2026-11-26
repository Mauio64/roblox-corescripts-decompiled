local module = require("@luauforge/deferred/gNV")

local module2 = require("@luauforge/deferred/gOf")
local module3 = require("@luauforge/deferred/gOh")

local function FolderNavigationBarContainer(p2)
	local v5 = module3(p2)
	return module.createElement(module2, v5)
end

return FolderNavigationBarContainer
