local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local IXPService = game:GetService("IXPService")
local Players = game:GetService("Players")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")

local defineFastInt = game:DefineFastInt("PlatformLeaderboardPushWaitTimeoutSeconds", 30)
local defineFastFlag = game:DefineFastFlag("PlatformLeaderboardsExposure2Enabled_V2", false)

local defineFastString = game:DefineFastString(
	"PlatformLeaderboardsExposure2Layer",
	"Social.PlatformLeaderboardsExposure2"
)

local defineFastFlag2 = game:DefineFastFlag("PlatformLeaderboardLocalizedUnitEnabled", false)

local defineFastFlag3 = game:DefineFastFlag("PlatformLeaderboardBadgeMetadataEnabled", false)

local defineFastFlag4 = game:DefineFastFlag("PlatformLeaderboardsIXPNoLeaderboardsShown_V3", false)

local parent = script.Parent.Parent
local Signals = require(parent.Signals)
local CoreScriptsCommon = require(parent.CoreScriptsCommon)
local Url = CoreScriptsCommon.Url

local CoreScriptsRoactCommon = require(parent.CoreScriptsRoactCommon)
local createSignalMap = CoreScriptsRoactCommon.Utilities.createSignalMap

local function getPlayerPermissionsModule()
	local success, result = pcall(function()
		local robloxGui = CoreGui:WaitForChild("RobloxGui")
		return require(robloxGui.Modules.PlayerPermissionsModule)
	end)
	return if success then result else nil
end

local function resolveIsLocalPlayerCreator()
	local localPlayer = Players.LocalPlayer

	if not localPlayer then
		return false
	end

	local success, result = pcall(function()
		local robloxGui = CoreGui:WaitForChild("RobloxGui")
		return require(robloxGui.Modules.PlayerPermissionsModule)
	end)

	if not success then
		result = nil
	end

	if not result then
		return false
	end

	local success2, result2 = pcall(function()
		return result.CanPlayerManagePlaceAsync(localPlayer)
	end)

	return success2 and result2 == true
end

local PlatformLeaderboardClientStore = {}
PlatformLeaderboardClientStore.__index = PlatformLeaderboardClientStore

function PlatformLeaderboardClientStore.new()
	local signal, setHasActiveLeaderboard = Signals.createSignal(false)
	local signal2, setGlobalLastRefreshedAt = Signals.createSignal(nil)
	local signal3, setFriendsLastRefreshedAt = Signals.createSignal(nil)
	local signal4, setUserScore = Signals.createSignal(nil)
	local signal5, setUserRank = Signals.createSignal(nil)
	local signal6, setUnit = Signals.createSignal(nil)
	local signal7, setUserFriendRank = Signals.createSignal(nil)
	local signal8, setUserFriendScore = Signals.createSignal(nil)
	local getUserIsVerified, setUserIsVerified, getUserHasRobloxSubscription, setUserHasRobloxSubscription

	if defineFastFlag3 then
		getUserIsVerified, setUserIsVerified = Signals.createSignal(nil)
		getUserHasRobloxSubscription, setUserHasRobloxSubscription = Signals.createSignal(nil)
	end

	local object = setmetatable({
		getHasActiveLeaderboard = signal,
		globalEntries = createSignalMap(),
		friendsEntries = createSignalMap(),
		getGlobalLastRefreshedAt = signal2,
		getFriendsLastRefreshedAt = signal3,
		getUserScore = signal4,
		getUserRank = signal5,
		getUnit = signal6,
		getUserFriendRank = signal7,
		getUserFriendScore = signal8,
		getUserIsVerified = getUserIsVerified,
		getUserHasRobloxSubscription = getUserHasRobloxSubscription,
		_setHasActiveLeaderboard = setHasActiveLeaderboard,
		_setGlobalLastRefreshedAt = setGlobalLastRefreshedAt,
		_setFriendsLastRefreshedAt = setFriendsLastRefreshedAt,
		_setUserScore = setUserScore,
		_setUserRank = setUserRank,
		_setUnit = setUnit,
		_setUserFriendRank = setUserFriendRank,
		_setUserFriendScore = setUserFriendScore,
		_setUserIsVerified = setUserIsVerified,
		_setUserHasRobloxSubscription = setUserHasRobloxSubscription,
		_globalEntrySetters = {},
		_friendsEntrySetters = {},
		_conn = nil
	}, PlatformLeaderboardClientStore)

	task.spawn(function()
		local platformLeaderboardPush = RobloxReplicatedStorage:WaitForChild("PlatformLeaderboardPush", defineFastInt)

		if not platformLeaderboardPush then
			return
		end

		object._conn = platformLeaderboardPush.OnClientEvent:Connect(function(p)
			object:_handleEvent(p)
		end)
	end)

	return object
end

function PlatformLeaderboardClientStore:_updateEntries(data, p, list)
	local userIdSet = {}

	for _, item in ipairs(list) do
		local userId = item.userId
		userIdSet[userId] = true

		local v = p[userId]

		if v then
			v.setScore(item.score)
			v.setRank(item.rank)
			local data2 = data.getData(userId, false)

			if
				data2
				and (data2.displayName ~= item.displayName or defineFastFlag3 and (data2.isVerified ~= item.isVerified or data2.hasRobloxSubscription ~= item.hasRobloxSubscription))
			then
				local setData = data.setData
				local v2 = {
					getScore = data2.getScore,
					getRank = data2.getRank,
					displayName = item.displayName,
					isVerified = 0,
					hasRobloxSubscription = 0
				}
				local isVerified

				if defineFastFlag3 then
					isVerified = item.isVerified
				end

				v2.isVerified = isVerified
				local hasRobloxSubscription

				if defineFastFlag3 then
					hasRobloxSubscription = item.hasRobloxSubscription
				end

				v2.hasRobloxSubscription = hasRobloxSubscription
				setData(userId, v2, false)
			end
		else
			local signal, setScore = Signals.createSignal(item.score)
			local signal2, setRank = Signals.createSignal(item.rank)

			p[userId] = { setScore = setScore, setRank = setRank }

			local setData = data.setData
			local v2 = {
				getScore = signal,
				getRank = signal2,
				displayName = item.displayName,
				isVerified = 0,
				hasRobloxSubscription = 0
			}
			local isVerified

			if defineFastFlag3 then
				isVerified = item.isVerified
			end

			v2.isVerified = isVerified
			local hasRobloxSubscription

			if defineFastFlag3 then
				hasRobloxSubscription = item.hasRobloxSubscription
			end

			v2.hasRobloxSubscription = hasRobloxSubscription
			setData(userId, v2, false)
		end
	end

	local allData = data.getAllData(false)

	for k, _ in pairs(allData) do
		if userIdSet[k] then
			continue
		end

		data.removeData(k, false)
		p[k] = nil
	end
end

function PlatformLeaderboardClientStore:_handleEvent(data)
	if defineFastFlag and data.config ~= nil then
		IXPService:LogFlagLinkedUserLayerExposure(defineFastString)
	end

	if defineFastFlag4 then
		local localPlayer = Players.LocalPlayer
		local v

		if localPlayer then
			local success, result = pcall(function()
				local robloxGui = CoreGui:WaitForChild("RobloxGui")
				return require(robloxGui.Modules.PlayerPermissionsModule)
			end)

			if not success then
				result = nil
			end

			if result then
				local success2, result2 = pcall(function()
					return result.CanPlayerManagePlaceAsync(localPlayer)
				end)
				v = success2 and result2 == true
			else
				v = false
			end
		else
			v = false
		end

		if not v then
			return
		end
	end

	if data.type == "CONFIG_UPDATE" then
		self._setHasActiveLeaderboard(data.config ~= nil)
		local setUnit = self._setUnit
		local v

		if data.config then
			v = data.config.unit
		end

		setUnit(v)

		if defineFastFlag2 and data.config then
			self:_fetchLocalizedUnit()
		end
	elseif data.type == "GLOBAL_LEADERBOARD_DATA" then
		if data.data then
			self:_updateEntries(self.globalEntries, self._globalEntrySetters, data.data.entries)
			self._setGlobalLastRefreshedAt(data.data.lastRefreshedAt)
		end
	elseif data.type == "FRIENDS_LEADERBOARD_DATA" then
		if data.data then
			self:_updateEntries(self.friendsEntries, self._friendsEntrySetters, data.data.entries)
			self._setFriendsLastRefreshedAt(data.data.lastRefreshedAt)

			if defineFastFlag2 then
				self:_updateUserFriendRankAndScore(data.data.entries)
			end
		end
	elseif data.type == "USER_SCORE" then
		if data.entry then
			self._setUserScore(data.entry.score)
			self._setUserRank(data.entry.rank)

			if defineFastFlag3 then
				self._setUserIsVerified(data.entry.isVerified)
				self._setUserHasRobloxSubscription(data.entry.hasRobloxSubscription)
			end
		else
			self._setUserScore(nil)
			self._setUserRank(nil)

			if defineFastFlag3 then
				self._setUserIsVerified(nil)
				self._setUserHasRobloxSubscription(nil)
			end
		end
	end
end

function PlatformLeaderboardClientStore:_updateUserFriendRankAndScore(list)
	local localPlayer = Players.LocalPlayer

	if not localPlayer then
		return
	end

	local userId = localPlayer.UserId

	for _, item in ipairs(list) do
		if item.userId == userId then
			self._setUserFriendRank(item.rank)
			self._setUserFriendScore(item.score)
			return
		end
	end

	self._setUserFriendRank(nil)
	self._setUserFriendScore(nil)
end

function PlatformLeaderboardClientStore:_fetchLocalizedUnit()
	task.spawn(function()
		local gameId = game.GameId
		local formatted = `{Url.APIS_URL}platform-leaderboards-api/v1/universes/{gameId}/leaderboard/localized`

		local success, result = pcall(function()
			return HttpRbxApiService:GetAsyncFullUrl(formatted)
		end)

		if not success then
			warn("[PlatformLeaderboard] Failed to fetch localized unit:", (tostring(result)))
			return
		end

		local success2, result2 = pcall(function()
			return HttpService:JSONDecode(result)
		end)

		if not success2 or typeof(result2) ~= "table" then
			warn("[PlatformLeaderboard] Failed to decode localized unit response")
			return
		end

		local localizedUnit = result2.localizedUnit

		if typeof(localizedUnit) == "string" then
			self._setUnit(localizedUnit)
		end
	end)
end

function PlatformLeaderboardClientStore.fireTabOpened(_, tabType: string)
	local platformLeaderboardTabOpened = RobloxReplicatedStorage:FindFirstChild("PlatformLeaderboardTabOpened")

	if platformLeaderboardTabOpened then
		platformLeaderboardTabOpened:FireServer({ tabType = tabType })
	end
end

function PlatformLeaderboardClientStore.fireTabClosed(_, tabType: string)
	local platformLeaderboardTabClosed = RobloxReplicatedStorage:FindFirstChild("PlatformLeaderboardTabClosed")

	if platformLeaderboardTabClosed then
		platformLeaderboardTabClosed:FireServer({ tabType = tabType })
	end
end

function PlatformLeaderboardClientStore:destroy()
	if self._conn then
		self._conn:Disconnect()
		self._conn = nil
	end
end

return PlatformLeaderboardClientStore
