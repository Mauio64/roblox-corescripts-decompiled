local v = {}

local function createListener(id, callback) -- 1 equivalent call inferred from this helper
	return { id = id, callback = callback }
end

local EventHub = {}

function EventHub.addEventListener(_, p, id, callback)
	if v[p] == nil then
		v[p] = {}
	end

	table.insert(v[p], createListener(id, callback)) -- inferred equivalent call
end

function EventHub.removeEventListener(_, p, p2)
	if v[p] == nil then
		return
	end

	for i, v2 in ipairs(v[p]) do
		if v2 ~= nil and v2.id == p2 then
			table.remove(v[p], i)
		end
	end
end

function EventHub.removeCallbackFromEvent(_, p, p2, p3)
	if v[p] == nil then
		return
	end

	for i, v2 in ipairs(v[p]) do
		if v2 ~= nil and v2.id == p2 and v2.callback == p3 then
			table.remove(v[p], i)
			break
		end
	end
end

function EventHub.dispatchEvent(_, p, ...)
	if v[p] == nil then
		return
	end

	for _, v2 in ipairs(v[p]) do
		v2.callback(...)
	end
end

EventHub.Notifications = {
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
return EventHub
