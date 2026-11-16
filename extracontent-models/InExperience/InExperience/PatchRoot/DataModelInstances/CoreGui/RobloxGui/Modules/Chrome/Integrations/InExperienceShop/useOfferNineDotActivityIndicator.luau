local Chrome = script:FindFirstAncestor("Chrome")

local CorePackages = game:GetService("CorePackages")

local SignalsReact = require(CorePackages.Packages.SignalsReact)

local InExperienceOffers = require(CorePackages.Workspace.Packages.InExperienceOffers)

local useNineDotActivityIndicator = require(Chrome.ChromeShared.Hooks.useNineDotActivityIndicator)

local getOffersStore = InExperienceOffers.getOffersStore
local NotificationLocation = InExperienceOffers.NotificationLocation

local function useOfferNineDotActivityIndicator()
	useNineDotActivityIndicator(
		"in_experience_offers",
		SignalsReact.useSignalState(getOffersStore(false).getOfferNotificationShownWithEnum) == NotificationLocation.Hamburger
	)
end

return useOfferNineDotActivityIndicator
