local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local fFlagAXFixPrefetchMarketplaceStartupCrash = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXFixPrefetchMarketplaceStartupCrash

local module2 = require("@luauforge/bundled/fIl")
require("@luauforge/bundled/dPz")

local module3 = require("@luauforge/bundled/dPD")

local module4 = require("@luauforge/deferred/gVo")

local v5 = {}

local function selectExternalNavigationRequest(p2)
	local avatarExperience = p2.AvatarExperience
	return (if avatarExperience then avatarExperience.ExternalNavigationRequest else nil) or v5
end

local function useProcessCatalogDeepLinkEffect()
	local v6 = useDispatch()
	local v7 = useSelector(selectExternalNavigationRequest)

	React.useEffect(function()
		local params = v7.params or {}

		if params.keyword == nil and module2.catalogDeepLinkExists(v7) then
			local catalogFilterFromDeepLinkParams = module2.buildCatalogFilterFromDeepLinkParams(params)

			if fFlagAXFixPrefetchMarketplaceStartupCrash then
				v6(module4(catalogFilterFromDeepLinkParams))
			else
				v6(module3(catalogFilterFromDeepLinkParams))
			end
		end
	end, { v7, v6 })
end

return useProcessCatalogDeepLinkEffect
