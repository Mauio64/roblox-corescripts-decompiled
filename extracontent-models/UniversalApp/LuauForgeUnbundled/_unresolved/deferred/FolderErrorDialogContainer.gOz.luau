local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/deferred/gNs")
local module2 = require("@luauforge/deferred/gOA")

local function FolderErrorDialogContainer()
	local v5 = module2()
	return React.createElement(module, v5)
end

return FolderErrorDialogContainer
