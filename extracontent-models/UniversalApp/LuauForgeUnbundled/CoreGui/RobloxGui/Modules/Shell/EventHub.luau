local v5 = {}

local function createListener(p2, p3)
	return { id = p2, callback = p3 }
end

return {
	addEventListener = function(p2, p3, p4, p5)
		if v5[p3] == nil then
			v5[p3] = {}
		end

		table.insert(v5[p3], { id = p4, callback = p5 })
	end,
	removeEventListener = function(p2, p3, p4)
		if v5[p3] == nil then
			return
		end

		for i, v6 in ipairs(v5[p3]) do
			if v6 ~= nil and v6.id == p4 then
				table.remove(v5[p3], i)
			end
		end
	end,
	removeCallbackFromEvent = function(p2, p3, p4, p5)
		if v5[p3] == nil then
			return
		end

		for i, v6 in ipairs(v5[p3]) do
			if v6 ~= nil and v6.id == p4 and v6.callback == p5 then
				table.remove(v5[p3], i)
				break
			end
		end
	end,
	dispatchEvent = function(self, p3, ...)
		if v5[p3] == nil then
			return
		end

		for i, v6 in ipairs(v5[p3]) do
			v6.callback(...)
		end
	end,
	Notifications = {
		AuthenticationSuccess = "rbxNotificationAuthenticationSuccess",
		GameJoin = "rbxNotificationGameJoin",
		OpenGames = "rbxNotificationOpenGames",
		OpenGameDetail = "rbxNotificationOpenGameDetail",
		OpenGameGenre = "rbxNotificationOpenGameGenre",
		OpenBadgeScreen = "rbxNotificationOpenBadgeScreen",
		OpenSettingsScreen = "rbxNotificationOpenSettingsScreen",
		OpenSearchScreen = "rbxNotificationOpenSearchScreen",
		OpenStoreScreen = "rbxNotificationOpenStoreScreen",
		OpenAvatarEditorScreen = "rbxNotificationOpenAvatarEditorScreen",
		OpenAccountSettingsScreen = "rbxNotificationOpenAccountSettingsScreen",
		NavigateToEquippedAvatar = "rbxNotificationNavigateToEquippedAvatar",
		NavigateToRobuxScreen = "rbxNotificationNavigateToRobuxScreen",
		RobuxCatalogPurchaseInitiated = "rbxRobuxCatalogPurchaseInitiated",
		DonnedDifferentPackage = "rbxDonnedDifferentPackage",
		VotedOnPlace = "rbxVotedOnPlace",
		AvatarEquipBegin = "rbxAvatarEquipBegin",
		DonnedDifferentOutfit = "rbxDonnedDifferentOutfit",
		AvatarEquipSuccess = "rbxAvatarEquipSuccess",
		AvatarPurchaseBegin = "rbxAvatarPurchaseBegin",
		AvatarPurchaseSuccess = "rbxAvatarPurchaseSuccess",
		FavoriteToggle = "rbxFavoriteToggle",
		PlayedGamesChanged = "rbxPlayedGamesChanged",
		UnlockedUGC = "rbxNotificationUnlockedUGC",
		SetGamesHints = "rbxNotificationSetGamesHints",
		CharacterEquipped = "CharacterEquipped",
		CharacterUpdated = "CharacterUpdated",
		HardwareBundleGranted = "HardwareBundleGranted"
	}
}
