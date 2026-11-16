local Chrome = script:FindFirstAncestor("Chrome")

local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local InExperienceOffers = require(CorePackages.Workspace.Packages.InExperienceOffers)
local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local useMappedSignal = Chrome2.Hooks.useMappedSignal

local Service = require(Chrome.Service)
local Constants = require(Chrome.ChromeShared.Unibar.Constants)

local getOffersStore = InExperienceOffers.getOffersStore

local function usePublishShopAvailability()
	local v = Service:integrations()[Constants.IN_EXPERIENCE_SHOP_ID]
	local v2

	if v then
		v2 = v.availability
	end

	local v3 = useMappedSignal(v2) == Service.AvailabilitySignal.Available

	React.useEffect(function()
		getOffersStore(false).setIsShopAvailable(v3)
	end, { v3 })
end

return usePublishShopAvailability
