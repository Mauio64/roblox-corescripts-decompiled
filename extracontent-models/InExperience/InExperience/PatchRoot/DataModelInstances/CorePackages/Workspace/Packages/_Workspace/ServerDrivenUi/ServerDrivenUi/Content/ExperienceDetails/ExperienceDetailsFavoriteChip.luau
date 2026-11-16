local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent

local Players = game:GetService("Players")

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local SignalsReact = require(parent.SignalsReact)

local DataHydration = require(parent.DataHydration)
local Game = DataHydration.Game
local RoactUtils = require(parent.RoactUtils)
local Localization = require(parent.Localization)

local SduiSharedContent = require(parent.SduiSharedContent)
local SduiChip = SduiSharedContent.SduiChip

local ToastRodux = require(parent.ToastRodux)
local ToastType = ToastRodux.Enums.ToastType
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage

local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local gameFavorite = DiscoveryAnalytics.Events.gameFavorite

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppAddUniverseIdToEngagementEvents = SharedFlags.FFlagLuaAppAddUniverseIdToEngagementEvents

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = Localization.Hooks.useLocalization

local useOptimisticUpdateStatus = require(ServerDrivenUi.Content.ExperienceDetails.Hooks.useOptimisticUpdateStatus)

local function ExperienceDetailsFavoriteChip(p)
	local layoutOrder = p.layoutOrder
	local universeId = p.universeId
	local v = useDispatch()

	local fetchFavorite = Game.getFavoritesStore(false).getAndFetchFavorite(universeId)
	local v2 = SignalsReact.useSignalState(function(p2)
		local data = fetchFavorite.data(p2)
		return data ~= nil and data.isFavorited
	end)

	local v3 = SignalsReact.useSignalState(Game.getGameInfoStore(false).getAndFetchGameInfo(universeId).data)
	local rootPlaceId = v3 and v3.rootPlaceId or nil

	local v4 = useLocalization({ favorite = "Feature.Favorites.Label.Favorite" })

	local onActivated = useOptimisticUpdateStatus(React.useCallback(function()
		local v5 = not v2

		if rootPlaceId then
			local v6 = {
				uid = tostring(Players.LocalPlayer and Players.LocalPlayer.UserId),
				ctx = "ExperienceDetailsFavoriteChip",
				placeId = rootPlaceId,
				state = v5 and "on" or "off",
				targetId = 0
			}
			local targetId

			if FFlagLuaAppAddUniverseIdToEngagementEvents then
				targetId = universeId
			end

			v6.targetId = targetId
			gameFavorite(v6, "ExperienceDetailsFavoriteChip")
		end

		return Game.getFavoritesStore(false).updateFavorite(universeId, v5)
	end, { universeId, rootPlaceId, v2 }), (React.useCallback(function(p2)
		if p2 and p2.type == "error" then
			v(SetCurrentToastMessage({
				toastType = ToastType.NetworkingError,
				toastMessage = "Feature.Toast.NetworkingError.SomethingIsWrong"
			}))
		end
	end, { v })))

	local createElement = React.createElement
	local v5 = {
		text = v4.favorite,
		leadingIconName = Foundation.Enums.IconName.Star,
		leadingIconVariant = 0,
		onActivated = 0,
		layoutOrder = 0
	}
	local leadingIconVariant

	if v2 then
		leadingIconVariant = Foundation.Enums.IconVariant.Filled
	end

	v5.leadingIconVariant = leadingIconVariant
	v5.onActivated = onActivated
	v5.layoutOrder = layoutOrder
	return createElement(SduiChip, v5)
end

return React.memo(ExperienceDetailsFavoriteChip)
