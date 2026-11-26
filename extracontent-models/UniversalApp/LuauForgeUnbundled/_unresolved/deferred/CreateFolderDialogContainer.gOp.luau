local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/deferred/gNn")
local module2 = require("@luauforge/deferred/gOq")

local function CreateFolderDialogContainer()
	local v5 = module2()
	return React.createElement(module, v5)
end

return CreateFolderDialogContainer
