local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")

local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local PlayerPermissionsModule = require(RobloxGui.Modules.PlayerPermissionsModule)
local TenFootInterface = require(RobloxGui.Modules.TenFootInterface)

local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)

local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)

local FFlagInExperienceUserProfileSettingsEnabled = require(RobloxGui.Modules.Common.Flags.FFlagInExperienceUserProfileSettingsEnabled)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagBadgeVisibilitySettingEnabled = SharedFlags.FFlagBadgeVisibilitySettingEnabled
local FFlagReplacePlayerIconRoduxWithSignal = SharedFlags.FFlagReplacePlayerIconRoduxWithSignal
local FFlagEnableMobilePlayerListOnConsole = PlayerList.Flags.FFlagEnableMobilePlayerListOnConsole
local defineFastFlag = game:DefineFastFlag("EnableBadgeCheckForUserCreator", false)

local PlayerIconInfoStore = require(CorePackages.Workspace.Packages.PlayerIconInfoStore)

local playerIconInfoStore = PlayerIconInfoStore.PlayerIconInfoStore

local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images

local parent = script.Parent.Parent

local v = {
	Admin = Images["icons/status/player/admin"],
	Intern = Images["icons/status/player/intern"],
	Star = Images["icons/status/player/videostar"]
}

local SetPlayerSpecialGroupIcon = require(parent.Actions.SetPlayerSpecialGroupIcon)
local SetPlayerIsCreator = require(parent.Actions.SetPlayerIsCreator)
local SetPlayerAvatarIcon = require(parent.Actions.SetPlayerAvatarIcon)
local SetPlayerIsBlocked = require(parent.Actions.SetPlayerIsBlocked)
local SetPlayerFriendStatus = require(parent.Actions.SetPlayerFriendStatus)

local function dispatchIfPlayerExists(object, p, p2)
	local players = object:getState().players
	local flag = false

	for _, player in ipairs(players) do
		if p == player then
			flag = true
			break
		end
	end

	if flag then
		object:dispatch(p2)
	end
end

local function isInExperienceNameEnabled(p): boolean -- 2 equivalent calls inferred from this helper
	if
		FFlagInExperienceUserProfileSettingsEnabled
		and PlayerPermissionsModule.IsPlayerInExperienceNameEnabledAsync(p)
	then
		return true
	end

	return false
end

local function getGroupsPermissionsInfo(p, p2)
	if FFlagBadgeVisibilitySettingEnabled then
		local specialGroupIcon = nil

		if PlayerPermissionsModule.IsPlayerAdminAsync(p2) then
			specialGroupIcon = v.Admin
		elseif PlayerPermissionsModule.IsPlayerStarAsync(p2) then
			specialGroupIcon = v.Star
		elseif PlayerPermissionsModule.IsPlayerInternAsync(p2) then
			specialGroupIcon = v.Intern
		end

		if specialGroupIcon then
			if FFlagReplacePlayerIconRoduxWithSignal then
				local v2 = playerIconInfoStore.getPlayerIconInfoReactive(p2.UserId)(false)
				playerIconInfoStore.setPlayerIconInfo(p2.UserId, {
					isPlaceOwner = v2.isPlaceOwner,
					avatarIcon = v2.avatarIcon,
					specialGroupIcon = specialGroupIcon
				})
			else
				if isInExperienceNameEnabled(p2) or not specialGroupIcon then -- inferred equivalent call
					specialGroupIcon = nil
				end

				dispatchIfPlayerExists(p, p2, SetPlayerSpecialGroupIcon(p2, specialGroupIcon))
			end
		end
	elseif PlayerPermissionsModule.IsPlayerAdminAsync(p2) then
		if FFlagReplacePlayerIconRoduxWithSignal then
			local v2 = playerIconInfoStore.getPlayerIconInfoReactive(p2.UserId)(false)
			playerIconInfoStore.setPlayerIconInfo(p2.UserId, {
				isPlaceOwner = v2.isPlaceOwner,
				avatarIcon = v2.avatarIcon,
				specialGroupIcon = v.Admin
			})
		elseif not (FFlagInExperienceUserProfileSettingsEnabled and PlayerPermissionsModule.IsPlayerInExperienceNameEnabledAsync(p2)) then
			dispatchIfPlayerExists(p, p2, SetPlayerSpecialGroupIcon(p2, v.Admin))
		end
	elseif PlayerPermissionsModule.IsPlayerStarAsync(p2) then
		if FFlagReplacePlayerIconRoduxWithSignal then
			local v2 = playerIconInfoStore.getPlayerIconInfoReactive(p2.UserId)(false)
			playerIconInfoStore.setPlayerIconInfo(p2.UserId, {
				isPlaceOwner = v2.isPlaceOwner,
				avatarIcon = v2.avatarIcon,
				specialGroupIcon = v.Star
			})
		elseif not (FFlagInExperienceUserProfileSettingsEnabled and PlayerPermissionsModule.IsPlayerInExperienceNameEnabledAsync(p2)) then
			dispatchIfPlayerExists(p, p2, SetPlayerSpecialGroupIcon(p2, v.Star))
		end
	elseif PlayerPermissionsModule.IsPlayerInternAsync(p2) then
		if FFlagReplacePlayerIconRoduxWithSignal then
			local v2 = playerIconInfoStore.getPlayerIconInfoReactive(p2.UserId)(false)
			playerIconInfoStore.setPlayerIconInfo(p2.UserId, {
				isPlaceOwner = v2.isPlaceOwner,
				avatarIcon = v2.avatarIcon,
				specialGroupIcon = v.Intern
			})
		elseif not (FFlagInExperienceUserProfileSettingsEnabled and PlayerPermissionsModule.IsPlayerInExperienceNameEnabledAsync(p2)) then
			dispatchIfPlayerExists(p, p2, SetPlayerSpecialGroupIcon(p2, v.Intern))
		end
	end
end

local function getGameCreator(p, p2)
	if not defineFastFlag and game.CreatorType ~= Enum.CreatorType.Group then
		return
	end

	if PlayerPermissionsModule.CanPlayerManagePlaceAsync(p2) then
		if FFlagReplacePlayerIconRoduxWithSignal then
			local v2 = playerIconInfoStore.getPlayerIconInfoReactive(p2.UserId)(false)
			playerIconInfoStore.setPlayerIconInfo(p2.UserId, {
				isPlaceOwner = true,
				avatarIcon = v2.avatarIcon,
				specialGroupIcon = v2.specialGroupIcon
			})
		elseif not (FFlagInExperienceUserProfileSettingsEnabled and PlayerPermissionsModule.IsPlayerInExperienceNameEnabledAsync(p2)) then
			dispatchIfPlayerExists(p, p2, SetPlayerIsCreator(p2, true))
		end
	end
end

local function getPlayerAvatarIcon(p, p2)
	if FFlagEnableMobilePlayerListOnConsole or not TenFootInterface:IsEnabled() then
		return
	end

	local avatarIcon = "rbxthumb://type=Avatar&id=" .. p2.UserId .. "&w=100&h=100"

	if not FFlagReplacePlayerIconRoduxWithSignal then
		dispatchIfPlayerExists(p, p2, SetPlayerAvatarIcon(p2, avatarIcon))

		return
	end

	local v2 = playerIconInfoStore.getPlayerIconInfoReactive(p2.UserId)(false)
	playerIconInfoStore.setPlayerIconInfo(p2.UserId, {
		isPlaceOwner = v2.isPlaceOwner,
		avatarIcon = avatarIcon,
		specialGroupIcon = v2.specialGroupIcon
	})
end

local function getPlayerIsBlocked(p, p2)
	if BlockingUtility:IsPlayerBlockedByUserId(p2.UserId) then
		dispatchIfPlayerExists(p, p2, SetPlayerIsBlocked(p2, true))
	end
end

local function getPlayerFriendStatus(p, p2)
	if p2 ~= Players.LocalPlayer and p2.Parent == Players and Players.LocalPlayer.Parent == Players then
		dispatchIfPlayerExists(p, p2, SetPlayerFriendStatus(p2, Players.LocalPlayer:GetFriendStatus(p2)))
	end
end

local function MakePlayerInfoRequests(p)
	return function(p2)
		if FFlagReplacePlayerIconRoduxWithSignal then
			coroutine.wrap(function()
				if isInExperienceNameEnabled(p) then -- inferred equivalent call
					playerIconInfoStore.setPlayerIconInfo(p.UserId, {
						isPlaceOwner = false,
						avatarIcon = nil,
						specialGroupIcon = nil
					})
					return
				end

				coroutine.wrap(getGroupsPermissionsInfo)(p2, p)
				coroutine.wrap(getGameCreator)(p2, p)
				coroutine.wrap(getPlayerAvatarIcon)(p2, p)
			end)()
		else
			coroutine.wrap(getGroupsPermissionsInfo)(p2, p)
			coroutine.wrap(getGameCreator)(p2, p)
			coroutine.wrap(getPlayerAvatarIcon)(p2, p)
		end

		coroutine.wrap(getPlayerIsBlocked)(p2, p)
		coroutine.wrap(getPlayerFriendStatus)(p2, p)
	end
end

return MakePlayerInfoRequests
