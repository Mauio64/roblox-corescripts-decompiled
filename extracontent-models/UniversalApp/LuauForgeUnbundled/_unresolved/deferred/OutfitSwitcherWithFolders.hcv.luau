local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local module = require("@luauforge/deferred/gNB")

local module2 = require("@luauforge/deferred/haQ")
local module3 = require("@luauforge/deferred/haX")

local useFolderItemIdsFilter = module.Hooks.useFolderItemIdsFilter
local useRefreshFolders = module.Hooks.useRefreshFolders

local function OutfitSwitcherWithFolders(p2)
	useRefreshFolders()

	local clone = table.clone(p2)

	clone.folderFilter = useFolderItemIdsFilter()

	local v5 = module2(clone)
	return React.createElement(module3, v5)
end

return OutfitSwitcherWithFolders
