local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/deferred/gNs")
local module2 = require("@luauforge/deferred/gOw")

local function FolderNameNotAllowedDialogContainer()
	local v5 = module2()
	return React.createElement(module, v5)
end

return FolderNameNotAllowedDialogContainer
