local Players = game:GetService("Players")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SignalsReact")

local Game = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DataHydration").Game
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RoactUtils")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Localization")

local sduiChip = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedContent").SduiChip

local ToastRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ToastRodux")
local toastType = ToastRodux.Enums.ToastType
local setCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage

local gameFavorite = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryAnalytics").Events.gameFavorite

local fFlagLuaAppAddUniverseIdToEngagementEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppAddUniverseIdToEngagementEvents

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = Localization.Hooks.useLocalization

local useOptimisticUpdateStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/ExperienceDetails/Hooks/useOptimisticUpdateStatus")

local function ExperienceDetailsFavoriteChip(p2)
	local layoutOrder = p2.layoutOrder
	local universeId = p2.universeId
	local v5 = useDispatch()

	local fetchFavorite = Game.getFavoritesStore(false).getAndFetchFavorite(universeId)
	local v6 = SignalsReact.useSignalState(function(p3)
		local data = fetchFavorite.data(p3)
		return data ~= nil and data.isFavorited
	end)

	local v7 = SignalsReact.useSignalState(Game.getGameInfoStore(false).getAndFetchGameInfo(universeId).data)
	local rootPlaceId = v7 and v7.rootPlaceId or nil

	local v8 = useLocalization({ favorite = "Feature.Favorites.Label.Favorite" })

	local v11 = useOptimisticUpdateStatus(React.useCallback(function()
		local v10 = not v6

		if rootPlaceId then
			local userId = Players.LocalPlayer and Players.LocalPlayer.UserId
			gameFavorite({
				uid = tostring(userId),
				ctx = "ExperienceDetailsFavoriteChip",
				placeId = rootPlaceId,
				state = v10 and "on" or "off",
				targetId = if fFlagLuaAppAddUniverseIdToEngagementEvents then universeId else nil
			}, "ExperienceDetailsFavoriteChip")
		end

		return Game.getFavoritesStore(false).updateFavorite(universeId, v10)
	end, { universeId, rootPlaceId, v6 }), (React.useCallback(function(p3)
		if p3 and p3.type == "error" then
			v5(setCurrentToastMessage({
				toastType = toastType.NetworkingError,
				toastMessage = "Feature.Toast.NetworkingError.SomethingIsWrong"
			}))
		end
	end, { v5 })))

	local createElement = React.createElement
	local v13 = {
		text = v8.favorite,
		leadingIconName = Foundation.Enums.IconName.Star,
		leadingIconVariant = 0,
		onActivated = 0,
		layoutOrder = 0
	}
	local v14 = if v6 then Foundation.Enums.IconVariant.Filled else nil
	v13.leadingIconVariant = v14
	v13.onActivated = v11
	v13.layoutOrder = layoutOrder
	return createElement(sduiChip, v13)
end

return React.memo(ExperienceDetailsFavoriteChip)
