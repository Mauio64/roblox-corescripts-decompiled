local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
RobloxGui:WaitForChild("Modules")
local CorePackages = game:GetService("CorePackages")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")
local gameSettings = UserSettings().GameSettings

local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local Url = CoreScriptsCommon.Url
local FFlagInExperienceUserProfileSettingsEnabled = require(RobloxGui.Modules.Common.Flags.FFlagInExperienceUserProfileSettingsEnabled)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagBadgeVisibilitySettingEnabled = SharedFlags.FFlagBadgeVisibilitySettingEnabled
local FFlagInExperienceRequestProfileSettings = require(RobloxGui.Modules.Common.Flags.FFlagInExperienceRequestProfileSettings)

local UserProfiles = require(CorePackages.Workspace.Packages.UserProfiles)
local VerifiedBadgeDisplayStore = UserProfiles.Stores.VerifiedBadgeDisplayStore
local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableVerifiedBadgeStore = SharedFlags2.FFlagEnableVerifiedBadgeStore

local class = {}
class.__index = class

function class.new(player)
	local self = setmetatable({}, class)
	self.player = player
	self.pendingGroupData = {}
	self.pendingCanManage = {}
	self.pendingProfileSettings = {}
	self.groupData = nil
	self.canManage = nil
	self.profileSettings = nil
	return self
end

function class:getGroupDataAsync()
	if self.groupData then
		return self.groupData
	end

	local thread = coroutine.running()
	table.insert(self.pendingGroupData, thread)
	coroutine.yield()
	return self.groupData
end

function class:getCanManageAsync()
	if self.canManage ~= nil then
		return self.canManage
	end

	local thread = coroutine.running()
	table.insert(self.pendingCanManage, thread)
	coroutine.yield()
	return self.canManage
end

function class:getProfileSettingsAsync()
	if self.profileSettings ~= nil then
		return self.profileSettings
	end

	local thread = coroutine.running()
	table.insert(self.pendingProfileSettings, thread)
	coroutine.yield()
	return self.profileSettings
end

function class:setGroupData(groupData)
	self.groupData = groupData
	local pendingGroupData = self.pendingGroupData
	self.pendingGroupData = {}

	for _, v in pairs(pendingGroupData) do
		coroutine.resume(v)
	end
end

function class:setCanManage(p)
	self.canManage = p and true or false
	local pendingCanManage = self.pendingCanManage
	self.pendingCanManage = {}

	for _, v in pairs(pendingCanManage) do
		coroutine.resume(v)
	end
end

function class:setProfileSettings(profileSettings)
	self.profileSettings = profileSettings
	local pendingProfileSettings = self.pendingProfileSettings
	self.pendingProfileSettings = {}

	for _, pendingProfileSetting in pairs(pendingProfileSettings) do
		coroutine.resume(pendingProfileSetting)
	end
end

function class:destroy()
	for _, v in pairs(self.pendingGroupData) do
		coroutine.resume(v)
	end

	for _, v in pairs(self.pendingCanManage) do
		coroutine.resume(v)
	end

	if FFlagInExperienceUserProfileSettingsEnabled then
		for _, pendingProfileSetting in pairs(self.pendingProfileSettings) do
			coroutine.resume(pendingProfileSetting)
		end
	end
end

local v = {}

local function getPlayerInfo(p) -- 7 equivalent calls inferred from this helper
	local playerInfo = v[p]

	if not playerInfo and p.Parent ~= nil then
		playerInfo = class.new(p)
		v[p] = playerInfo
	end

	return playerInfo
end

spawn(function()
	local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
	RobloxReplicatedStorage:WaitForChild("NewPlayerGroupDetails", 1e999).OnClientEvent:Connect(function(...)
		local v2 = { ... }

		if #v2 == 1 then
			local v3 = v2[1]

			for k, v4 in pairs(v3) do
				local playerByUserId = Players:GetPlayerByUserId((tonumber(k)))

				if not playerByUserId then
					continue
				end

				local playerInfo = getPlayerInfo(playerByUserId) -- inferred equivalent call

				if playerInfo then
					playerInfo:setGroupData(v4)
				end
			end
		else
			local v3 = v2[1]
			local v4 = v2[2]

			local playerByUserId = Players:GetPlayerByUserId((tonumber(v3)))

			if playerByUserId then
				local playerInfo = getPlayerInfo(playerByUserId) -- inferred equivalent call

				if playerInfo then
					playerInfo:setGroupData(v4)
				end
			end
		end
	end)
end)

coroutine.wrap(function()
	local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
	RobloxReplicatedStorage:WaitForChild("NewPlayerCanManageDetails", 1e999).OnClientEvent:Connect(function(p, p2)
		local playerByUserId = Players:GetPlayerByUserId((tonumber(p)))

		if playerByUserId then
			local playerInfo = getPlayerInfo(playerByUserId) -- inferred equivalent call

			if playerInfo then
				playerInfo:setCanManage(p2)
			end
		end
	end)
end)()

if FFlagInExperienceUserProfileSettingsEnabled then
	coroutine.wrap(function()
		local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
		RobloxReplicatedStorage:WaitForChild("SendPlayerProfileSettings", 1e999).OnClientEvent:Connect(function(p, p2)
			local playerByUserId = Players:GetPlayerByUserId((tonumber(p)))

			if playerByUserId then
				local playerInfo = getPlayerInfo(playerByUserId) -- inferred equivalent call

				if playerInfo then
					playerInfo:setProfileSettings(p2)
				end

				if FFlagEnableVerifiedBadgeStore and p2.isInExperienceNameEnabled ~= nil then
					VerifiedBadgeDisplayStore.get().setBadgeVisibility(
						playerByUserId.UserId,
						not p2.isInExperienceNameEnabled
					)
				end
			end
		end)

		if FFlagInExperienceRequestProfileSettings then
			RobloxReplicatedStorage:WaitForChild("RequestPlayerProfileSettings", 1e999):FireServer()
		end
	end)()
end

Players.PlayerRemoving:Connect(function(player)
	if v[player] then
		local v2 = v[player]
		v[player] = nil
		v2:destroy()
	end
end)

local function NewInGroupFunctionFactory(p) -- 9 equivalent calls inferred from this helper
	return function(p2): boolean
		local playerInfo = getPlayerInfo(p2) -- inferred equivalent call

		if playerInfo then
			local groupDataAsync = playerInfo:getGroupDataAsync()

			if groupDataAsync and groupDataAsync[p] then
				return true
			end
		end

		return false
	end
end

local v2 = {
	NewInGroupFunctionFactory("SpanishLocalizationExpert"), -- inferred equivalent call
	NewInGroupFunctionFactory("BrazilianLocalizationExpert"), -- inferred equivalent call
	NewInGroupFunctionFactory("FrenchLocalizationExpert"), -- inferred equivalent call
	NewInGroupFunctionFactory("GermanLocalizationExpert") -- inferred equivalent call
}

local function NewIsLocalizationExpertFunctionFactory()
	return function(p): boolean
		for i = 1, #v2 do
			if v2[i](p) then
				return true
			end
		end

		return false
	end
end

local function IsPlaceOwnerFunctionFactory()
	if game.CreatorType ~= Enum.CreatorType.Group then
		return function(p): boolean
			return p.UserId == game.CreatorId
		end
	end

	return NewInGroupFunctionFactory("PlaceCreator") -- inferred equivalent call
end

local function CanPlayerManagePlace(p)
	local playerInfo = getPlayerInfo(p) -- inferred equivalent call

	if playerInfo then
		return playerInfo:getCanManageAsync() or false
	end

	return false
end

local function IsPlayerInExperienceNameEnabled(p)
	local playerInfo = getPlayerInfo(p) -- inferred equivalent call
	local v3 = playerInfo and playerInfo:getProfileSettingsAsync()

	return if v3 then v3.isInExperienceNameEnabled else false
end

local function SetPlayerInExperienceNameEnabled(_, isInExperienceNameEnabled)
	pcall(function()
		local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
		local updatePlayerProfileSettings = RobloxReplicatedStorage:WaitForChild("UpdatePlayerProfileSettings", 1e999)

		HttpRbxApiService:PostAsyncFullUrl(
			Url.APIS_URL .. "user-profile-api/v1/user/profiles/settings",
			HttpService:JSONEncode({
				userProfileSettings = { isInExperienceNameEnabled = isInExperienceNameEnabled }
			}),
			Enum.ThrottlingPriority.Default,
			Enum.HttpContentType.ApplicationJson,
			Enum.HttpRequestType.Players
		)
		updatePlayerProfileSettings:FireServer({
			isInExperienceNameEnabled = isInExperienceNameEnabled
		})
	end)
end

local PlayerPermissionsModule = {}
PlayerPermissionsModule.IsPlayerAdminAsync = NewInGroupFunctionFactory("Admin") -- inferred equivalent call
PlayerPermissionsModule.IsPlayerInternAsync = NewInGroupFunctionFactory("Intern") -- inferred equivalent call
PlayerPermissionsModule.IsPlayerStarAsync = NewInGroupFunctionFactory("Star") -- inferred equivalent call

function PlayerPermissionsModule.IsPlayerLocalizationExpertAsync(p): boolean
	for i = 1, #v2 do
		if v2[i](p) then
			return true
		end
	end

	return false
end

local isPlayerPlaceOwnerAsync

if game.CreatorType == Enum.CreatorType.Group then
	isPlayerPlaceOwnerAsync = NewInGroupFunctionFactory("PlaceCreator") -- inferred equivalent call
else
	isPlayerPlaceOwnerAsync = function(p): boolean
		return p.UserId == game.CreatorId
	end
end

PlayerPermissionsModule.IsPlayerPlaceOwnerAsync = isPlayerPlaceOwnerAsync
PlayerPermissionsModule.CanPlayerManagePlaceAsync = CanPlayerManagePlace

if FFlagInExperienceUserProfileSettingsEnabled then
	PlayerPermissionsModule.IsPlayerInExperienceNameEnabledAsync = IsPlayerInExperienceNameEnabled
end

if FFlagBadgeVisibilitySettingEnabled then
	PlayerPermissionsModule.SetPlayerInExperienceNameEnabled = SetPlayerInExperienceNameEnabled
end

return PlayerPermissionsModule
