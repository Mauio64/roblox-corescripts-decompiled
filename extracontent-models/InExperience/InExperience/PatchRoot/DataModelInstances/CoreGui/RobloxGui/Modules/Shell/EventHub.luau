local t1 = {}

local function createListener(p1, p2) -- line: 6
	return {
		id = p1,
		callback = p2
	}
end

return {
	addEventListener = function(_, p4, p5, p6) -- line: 18
		-- upvalues: t1 (copy)
		if t1[p4] == nil then
			t1[p4] = {}
		end

		table.insert(t1[p4], {
			id = p5,
			callback = p6
		})
	end,
	removeEventListener = function(_, p8, p9) -- line: 26
		-- upvalues: t1 (copy)
		if t1[p8] == nil then
			return
		end

		for i, v in ipairs(t1[p8]) do
			if v ~= nil and p9 == v.id then
				table.remove(t1[p8], i)
			end
		end
	end,
	removeCallbackFromEvent = function(_, p11, p12, p13) -- line: 40
		-- upvalues: t1 (copy)
		if t1[p11] == nil then
			return
		end

		for i, v in ipairs(t1[p11]) do
			if v ~= nil and p12 == v.id and p13 == v.callback then
				table.remove(t1[p11], i)

				return
			end
		end
	end,
	dispatchEvent = function(_, p15, ...) -- line: 56
		-- upvalues: t1 (copy)
		if t1[p15] == nil then
			return
		end

		for _, v in ipairs(t1[p15]) do
			v.callback(...)
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
