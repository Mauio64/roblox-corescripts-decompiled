local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local Modules = game:GetService("CoreGui").RobloxGui.Modules

require(Modules.AvatarExperience.Common.Types)

local useCatalogItemCardViewModel = require(script.Parent.useCatalogItemCardViewModel)
local CatalogItemCard = require(script.Parent.CatalogItemCard)
local tutils = require(CorePackages.Packages.tutils)

return (React.memo(function(t1: {[any]: any}) -- line: 64
	-- upvalues: useCatalogItemCardViewModel (copy), React (copy), CatalogItemCard (copy)
	local v8 = useCatalogItemCardViewModel(t1)

	return React.createElement(CatalogItemCard, v8)
end, tutils.deepEqual))
