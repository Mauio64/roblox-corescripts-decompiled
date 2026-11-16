local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/deferred/giH")
local module2 = require("@luauforge/deferred/giS")

local function RenameOutfitDialogContainer()
	local v5 = module2()
	return React.createElement(module, v5)
end

return RenameOutfitDialogContainer
