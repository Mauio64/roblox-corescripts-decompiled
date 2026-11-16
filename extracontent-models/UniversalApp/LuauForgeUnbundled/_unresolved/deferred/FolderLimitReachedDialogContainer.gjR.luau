local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/deferred/giM")
local module2 = require("@luauforge/deferred/gjS")

local function FolderLimitReachedDialogContainer()
	local v5 = module2()
	return React.createElement(module, v5)
end

return FolderLimitReachedDialogContainer
