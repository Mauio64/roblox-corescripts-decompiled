local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local Players = game:GetService("Players")
local React = require(ServerDrivenUiParent.React)
local Foundation = require(ServerDrivenUiParent.Foundation)
local SignalsReact = require(ServerDrivenUiParent.SignalsReact)
local Game = require(ServerDrivenUiParent.DataHydration).Game
local RoactUtils = require(ServerDrivenUiParent.RoactUtils)
local Localization = require(ServerDrivenUiParent.Localization)
local SduiChip = require(ServerDrivenUiParent.SduiSharedContent).SduiChip
local ToastRodux = require(ServerDrivenUiParent.ToastRodux)
local ToastType = ToastRodux.Enums.ToastType
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local gameFavorite = require(ServerDrivenUiParent.DiscoveryAnalytics).Events.gameFavorite
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = Localization.Hooks.useLocalization
local useOptimisticUpdateStatus = require(ServerDrivenUi.Content.ExperienceDetails.Hooks.useOptimisticUpdateStatus)
local FFlagSduiFavoritesHydrationStructured = require(ServerDrivenUiParent.SharedFlags).FFlagSduiFavoritesHydrationStructured

local function ExperienceDetailsFavoriteChip(t1: {[any]: any}) -- line: 37
	-- upvalues: useDispatch (copy), Game (copy), SignalsReact (copy), FFlagSduiFavoritesHydrationStructured (copy), useLocalization (copy), React (copy), Players (copy), gameFavorite (copy), SetCurrentToastMessage (copy), ToastType (copy), useOptimisticUpdateStatus (copy), SduiChip (copy), Foundation (copy)
	local layoutOrder = t1.layoutOrder
	local universeId = t1.universeId
	local v23 = useDispatch()
	local v24 = Game.getFavoritesStore(false).getAndFetchFavorite(universeId)
	local v25 = SignalsReact.useSignalState(function(p1) -- line: 43
		-- upvalues: v24 (copy), FFlagSduiFavoritesHydrationStructured (copy)
		local v33 = v24.data(p1)

		if FFlagSduiFavoritesHydrationStructured then
			return v33 ~= nil and v33.isFavorited
		end

		return v33 == true
	end)
	local v26 = SignalsReact.useSignalState(Game.getGameInfoStore(false).getAndFetchGameInfo(universeId).data)
	local v27 = v26 and v26.rootPlaceId or nil
	local v28 = useLocalization({
		favorite = "Feature.Favorites.Label.Favorite"
	})
	local v29 = React.useCallback(function() -- line: 60
		-- upvalues: v25 (copy), v27 (copy), Players (copy), gameFavorite (copy), Game (copy), universeId (copy)
		local v34 = not v25

		if v27 then
			local v35 = Players.LocalPlayer and Players.LocalPlayer.UserId

			gameFavorite({
				ctx = "ExperienceDetailsFavoriteChip",
				uid = tostring(v35),
				placeId = v27,
				state = not v34 and "off" or "on"
			}, "ExperienceDetailsFavoriteChip")
		end

		return Game.getFavoritesStore(false).updateFavorite(universeId, v34)
	end, {
		universeId,
		v27,
		v25
	})
	local v30 = React.useCallback(function(p2) -- line: 76
		-- upvalues: v23 (copy), SetCurrentToastMessage (copy), ToastType (copy)
		if p2 and p2.type == "error" then
			v23(SetCurrentToastMessage({
				toastMessage = "Feature.Toast.NetworkingError.SomethingIsWrong",
				toastType = ToastType.NetworkingError
			}))
		end
	end, { v23 })
	local v31 = useOptimisticUpdateStatus(v29, v30)

	return React.createElement(SduiChip, {
		text = v28.favorite,
		leadingIconName = Foundation.Enums.IconName.Star,
		leadingIconVariant = if not v25 then nil else Foundation.Enums.IconVariant.Filled,
		onActivated = v31,
		layoutOrder = layoutOrder
	})
end

return React.memo(ExperienceDetailsFavoriteChip)
