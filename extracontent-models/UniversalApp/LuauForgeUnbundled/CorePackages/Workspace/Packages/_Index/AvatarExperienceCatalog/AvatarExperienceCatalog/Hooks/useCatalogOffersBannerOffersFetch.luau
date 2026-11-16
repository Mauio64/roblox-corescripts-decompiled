local Players = game:GetService("Players")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local useAvatarRoute = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceNavigation").AvatarRoute.Hooks.useAvatarRoute

local fFlagAXCatalogOffersClearOnLogout = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags").FFlagAXCatalogOffersClearOnLogout

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Stores/createCatalogOffersBannerStore")
local catalogOffersBannerImpressionsStore = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Stores/catalogOffersBannerImpressionsStore")
local getLocalUserId = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/getLocalUserId")

local function useCatalogOffersBannerOffersFetch(data, p2)
	if fFlagAXCatalogOffersClearOnLogout then
		React.useEffect(function()
			local v5

			if data.getHasCompletedOffersFetch(false) or data.getOffersFetchInProgress(false) then
				v5 = nil
			else
				v5 = data.fetchOffers(p2)
			end

			local v6 = getLocalUserId(Players)

			local function handle()
				local v7 = getLocalUserId(Players)

				if v7 == v6 then
					return
				end

				v6 = v7

				if v5 then
					v5()
					v5 = nil
				end

				data.setPayload(nil)
				data.setDismissed(false)

				catalogOffersBannerImpressionsStore.clearOfferIds()

				if v7 ~= nil and v7 ~= "-1" then
					v5 = data.fetchOffers(p2)
				end
			end

			local userIdChangedConnection = nil
			local function bindUserIdSignal()
				if userIdChangedConnection then
					userIdChangedConnection:Disconnect()
					userIdChangedConnection = nil
				end

				local localPlayer = Players.LocalPlayer

				if localPlayer ~= nil then
					userIdChangedConnection = localPlayer:GetPropertyChangedSignal("UserId"):Connect(handle)
				end
			end

			if userIdChangedConnection then
				userIdChangedConnection:Disconnect()
				userIdChangedConnection = nil
			end

			local localPlayer = Players.LocalPlayer

			if localPlayer ~= nil then
				userIdChangedConnection = localPlayer:GetPropertyChangedSignal("UserId"):Connect(handle)
			end

			local localPlayerChangedConnection = Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function()
				if userIdChangedConnection then
					userIdChangedConnection:Disconnect()
					userIdChangedConnection = nil
				end

				local localPlayer2 = Players.LocalPlayer

				if localPlayer2 ~= nil then
					userIdChangedConnection = localPlayer2:GetPropertyChangedSignal("UserId"):Connect(handle)
				end

				handle()
			end)

			return function()
				if v5 then
					v5()
					v5 = nil
				end

				if userIdChangedConnection then
					userIdChangedConnection:Disconnect()
					userIdChangedConnection = nil
				end

				localPlayerChangedConnection:Disconnect()
			end
		end, { data, p2 })
	else
		React.useEffect(function()
			if data.getHasCompletedOffersFetch(false) or data.getOffersFetchInProgress(false) then
				return function() end
			end

			return data.fetchOffers(p2)
		end, { p2, data })
	end

	local ref = React.useRef(true)
	local v5 = useAvatarRoute()
	React.useEffect(function()
		local v6 = not (v5 == nil) and v5.isVisible

		if v6 and not ref.current then
			data.fetchOffers(p2)
		end

		ref.current = v6
	end, { p2, data, v5 })
end

return useCatalogOffersBannerOffersFetch
