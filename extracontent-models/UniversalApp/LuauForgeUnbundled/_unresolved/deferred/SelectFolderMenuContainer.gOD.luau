local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/deferred/gOE")
local module2 = require("@luauforge/deferred/gOF")

local function SelectFolderMenuContainer()
	local v5 = module2()
	return React.createElement(module, v5)
end

return SelectFolderMenuContainer
