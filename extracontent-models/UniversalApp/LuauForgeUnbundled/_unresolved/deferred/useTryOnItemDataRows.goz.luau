local CorePackages = game:GetService("CorePackages")

local tutils = require(CorePackages.Packages.tutils)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local module = require("@luauforge/deferred/gox")
require("@luauforge/bundled/dHL")
require("@luauforge/bundled/dHK")

local selectItemDataForTryOnItems = module.Utils.selectItemDataForTryOnItems

local function selectTryOnItemDataRows(p2)
	return selectItemDataForTryOnItems(
		p2.AvatarExperience.Common,
		p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
	)
end

local function useTryOnItemDataRows()
	return useSelector(selectTryOnItemDataRows, tutils.deepEqual)
end

return useTryOnItemDataRows
