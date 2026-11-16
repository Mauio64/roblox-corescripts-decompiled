local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent

local Players = game:GetService("Players")

local React = require(parent.React)
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXCatalogOffersClearOnLogout = AvatarExperienceFlags.FFlagAXCatalogOffersClearOnLogout

require(AvatarExperienceCatalog.Stores.createCatalogOffersBannerStore)
local catalogOffersBannerImpressionsStore = require(AvatarExperienceCatalog.Stores.catalogOffersBannerImpressionsStore)
local getLocalUserId = require(AvatarExperienceCatalog.Utils.getLocalUserId)

local function useCatalogOffersBannerOffersFetch(data, p)
	if FFlagAXCatalogOffersClearOnLogout then
		React.useEffect(function()
			local v

			if data.getHasCompletedOffersFetch(false) or data.getOffersFetchInProgress(false) then
				v = nil
			else
				v = data.fetchOffers(p)
			end

			local v2 = getLocalUserId(Players)

			local function handle()
				local localUserId = getLocalUserId(Players)

				if localUserId == v2 then
					return
				end

				v2 = localUserId

				if v then
					v()
					v = nil
				end

				data.setPayload(nil)
				data.setDismissed(false)

				catalogOffersBannerImpressionsStore.clearOfferIds()

				if localUserId ~= nil and localUserId ~= "-1" then
					v = data.fetchOffers(p)
				end
			end

			local userIdChangedConnection = nil
			local function bindUserIdSignal() -- 2 equivalent calls inferred from this helper
				if userIdChangedConnection then
					userIdChangedConnection:Disconnect()
					userIdChangedConnection = nil
				end

				local localPlayer = Players.LocalPlayer

				if localPlayer ~= nil then
					userIdChangedConnection = localPlayer:GetPropertyChangedSignal("UserId"):Connect(handle)
				end
			end

			bindUserIdSignal() -- inferred equivalent call
			local localPlayerChangedConnection = Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function()
				bindUserIdSignal() -- inferred equivalent call
				handle()
			end)

			return function()
				if v then
					v()
					v = nil
				end

				if userIdChangedConnection then
					userIdChangedConnection:Disconnect()
					userIdChangedConnection = nil
				end

				localPlayerChangedConnection:Disconnect()
			end
		end, { data, p })
	else
		React.useEffect(function()
			if data.getHasCompletedOffersFetch(false) or data.getOffersFetchInProgress(false) then
				return function() end
			end

			return data.fetchOffers(p)
		end, { p, data })
	end

	local ref = React.useRef(true)
	local v = useAvatarRoute()
	React.useEffect(function()
		local current = not (v == nil) and v.isVisible

		if current and not ref.current then
			data.fetchOffers(p)
		end

		ref.current = current
	end, { p, data, v })
end

return useCatalogOffersBannerOffersFetch
