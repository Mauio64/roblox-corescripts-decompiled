local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local catalogCategories = require("@luauforge/bundled/dMd").Enums.CatalogCategories
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local module2 = require("@luauforge/deferred/gQI")
local module3 = require("@luauforge/bundled/dMx")
require("@luauforge/bundled/dMc")
local module4 = require("@luauforge/deferred/gTT")
local fFlagAXCatalogBackgroundsSupport = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXCatalogBackgroundsSupport

local function useBackgroundsPlusBannerLocalWidget(p2, p3, p4)
	local v5 = useSelector(function(p5)
		return p5.SearchesParameters[p2]
	end, getUseSelectorDeepEquals())
	local v6 = module2.useBackgroundsPlusAccess()

	local v7 = React.useMemo(function()
		if not (fFlagAXCatalogBackgroundsSupport and v6.backgroundVariants.showMarketplaceExclusiveSection) then
			return false
		end

		local v8 = if v5 and v5.categoryInfo and not Cryo.isEmpty(v5.categoryInfo) then v5.categoryInfo.Id == catalogCategories.Backgrounds:rawValue() else false

		return p3 and v8 and not p4
	end, { v5, p3, p4, v6.backgroundVariants.showMarketplaceExclusiveSection })

	return {
		row = module3.BackgroundsPlusUpsellRow,
		component = module4,
		isEnabled = v7
	}
end

return useBackgroundsPlusBannerLocalWidget
