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
local v14 = game:DefineFastFlag("EnableBadgeCheckForUserCreator", false)
local PlayerIconInfoStore = require(CorePackages.Workspace.Packages.PlayerIconInfoStore).PlayerIconInfoStore
local Images = require(CorePackages.Packages.UIBlox).App.ImageSet.Images
local ParentParent = script.Parent.Parent
local t1 = {
	Admin = Images["icons/status/player/admin"],
	Intern = Images["icons/status/player/intern"],
	Star = Images["icons/status/player/videostar"]
}
local SetPlayerSpecialGroupIcon = require(ParentParent.Actions.SetPlayerSpecialGroupIcon)
local SetPlayerIsCreator = require(ParentParent.Actions.SetPlayerIsCreator)
local SetPlayerAvatarIcon = require(ParentParent.Actions.SetPlayerAvatarIcon)
local SetPlayerIsBlocked = require(ParentParent.Actions.SetPlayerIsBlocked)
local SetPlayerFriendStatus = require(ParentParent.Actions.SetPlayerFriendStatus)

local function dispatchIfPlayerExists(p1, p2, p3) -- line: 47
	local players = p1:getState().players
	local v36 = false

	for _, v in ipairs(players) do
		if p2 == v then
			v36 = true

			break
		end
	end

	if v36 then
		p1:dispatch(p3)
	end
end
local function isInExperienceNameEnabled(p4) -- line: 61
	-- upvalues: FFlagInExperienceUserProfileSettingsEnabled (copy), PlayerPermissionsModule (copy)
	if FFlagInExperienceUserProfileSettingsEnabled and PlayerPermissionsModule.IsPlayerInExperienceNameEnabledAsync(p4) then
		return true
	end

	return false
end
local function getGroupsPermissionsInfo(p5, p6) -- line: 70
	-- upvalues: FFlagBadgeVisibilitySettingEnabled (copy), PlayerPermissionsModule (copy), t1 (copy), FFlagReplacePlayerIconRoduxWithSignal (copy), PlayerIconInfoStore (copy), FFlagInExperienceUserProfileSettingsEnabled (copy), dispatchIfPlayerExists (copy), SetPlayerSpecialGroupIcon (copy)
	if FFlagBadgeVisibilitySettingEnabled then
		local Admin = nil

		if PlayerPermissionsModule.IsPlayerAdminAsync(p6) then
			Admin = t1.Admin
		elseif PlayerPermissionsModule.IsPlayerStarAsync(p6) then
			Admin = t1.Star
		elseif PlayerPermissionsModule.IsPlayerInternAsync(p6) then
			Admin = t1.Intern
		end

		if Admin then
			if FFlagReplacePlayerIconRoduxWithSignal then
				local v43 = PlayerIconInfoStore.getPlayerIconInfoReactive(p6.UserId)(false)

				PlayerIconInfoStore.setPlayerIconInfo(p6.UserId, {
					isPlaceOwner = v43.isPlaceOwner,
					avatarIcon = v43.avatarIcon,
					specialGroupIcon = Admin
				})

				return
			end

			local v44 = not (not not FFlagInExperienceUserProfileSettingsEnabled and not not PlayerPermissionsModule.IsPlayerInExperienceNameEnabledAsync(p6)) and Admin or nil

			dispatchIfPlayerExists(p5, p6, SetPlayerSpecialGroupIcon(p6, v44))

			return
		end
	elseif PlayerPermissionsModule.IsPlayerAdminAsync(p6) then
		if FFlagReplacePlayerIconRoduxWithSignal then
			local v45 = PlayerIconInfoStore.getPlayerIconInfoReactive(p6.UserId)(false)

			PlayerIconInfoStore.setPlayerIconInfo(p6.UserId, {
				isPlaceOwner = v45.isPlaceOwner,
				avatarIcon = v45.avatarIcon,
				specialGroupIcon = t1.Admin
			})

			return
		end

		if not FFlagInExperienceUserProfileSettingsEnabled or not PlayerPermissionsModule.IsPlayerInExperienceNameEnabledAsync(p6) then
			dispatchIfPlayerExists(p5, p6, SetPlayerSpecialGroupIcon(p6, t1.Admin))

			return
		end
	elseif PlayerPermissionsModule.IsPlayerStarAsync(p6) then
		if FFlagReplacePlayerIconRoduxWithSignal then
			local v46 = PlayerIconInfoStore.getPlayerIconInfoReactive(p6.UserId)(false)

			PlayerIconInfoStore.setPlayerIconInfo(p6.UserId, {
				isPlaceOwner = v46.isPlaceOwner,
				avatarIcon = v46.avatarIcon,
				specialGroupIcon = t1.Star
			})

			return
		end

		if not FFlagInExperienceUserProfileSettingsEnabled or not PlayerPermissionsModule.IsPlayerInExperienceNameEnabledAsync(p6) then
			dispatchIfPlayerExists(p5, p6, SetPlayerSpecialGroupIcon(p6, t1.Star))

			return
		end
	elseif PlayerPermissionsModule.IsPlayerInternAsync(p6) then
		if FFlagReplacePlayerIconRoduxWithSignal then
			local v47 = PlayerIconInfoStore.getPlayerIconInfoReactive(p6.UserId)(false)

			PlayerIconInfoStore.setPlayerIconInfo(p6.UserId, {
				isPlaceOwner = v47.isPlaceOwner,
				avatarIcon = v47.avatarIcon,
				specialGroupIcon = t1.Intern
			})

			return
		end

		if not FFlagInExperienceUserProfileSettingsEnabled or not PlayerPermissionsModule.IsPlayerInExperienceNameEnabledAsync(p6) then
			dispatchIfPlayerExists(p5, p6, SetPlayerSpecialGroupIcon(p6, t1.Intern))
		end
	end
end
local function getGameCreator(p7, p8) -- line: 142
	-- upvalues: v14 (copy), PlayerPermissionsModule (copy), FFlagReplacePlayerIconRoduxWithSignal (copy), PlayerIconInfoStore (copy), FFlagInExperienceUserProfileSettingsEnabled (copy), dispatchIfPlayerExists (copy), SetPlayerIsCreator (copy)
	if not v14 and game.CreatorType ~= Enum.CreatorType.Group then
		return
	end

	if PlayerPermissionsModule.CanPlayerManagePlaceAsync(p8) then
		if FFlagReplacePlayerIconRoduxWithSignal then
			local v50 = PlayerIconInfoStore.getPlayerIconInfoReactive(p8.UserId)(false)

			PlayerIconInfoStore.setPlayerIconInfo(p8.UserId, {
				isPlaceOwner = true,
				avatarIcon = v50.avatarIcon,
				specialGroupIcon = v50.specialGroupIcon
			})

			return
		end

		if not FFlagInExperienceUserProfileSettingsEnabled or not PlayerPermissionsModule.IsPlayerInExperienceNameEnabledAsync(p8) then
			dispatchIfPlayerExists(p7, p8, SetPlayerIsCreator(p8, true))
		end
	end
end
local function getPlayerAvatarIcon(p9, p10) -- line: 164
	-- upvalues: FFlagEnableMobilePlayerListOnConsole (copy), TenFootInterface (copy), FFlagReplacePlayerIconRoduxWithSignal (copy), PlayerIconInfoStore (copy), dispatchIfPlayerExists (copy), SetPlayerAvatarIcon (copy)
	if FFlagEnableMobilePlayerListOnConsole or not TenFootInterface:IsEnabled() then
		return
	end

	local v53 = "rbxthumb://type=Avatar&id=" .. p10.UserId .. "&w=100&h=100"

	if FFlagReplacePlayerIconRoduxWithSignal then
		local v54 = PlayerIconInfoStore.getPlayerIconInfoReactive(p10.UserId)(false)

		PlayerIconInfoStore.setPlayerIconInfo(p10.UserId, {
			isPlaceOwner = v54.isPlaceOwner,
			avatarIcon = v53,
			specialGroupIcon = v54.specialGroupIcon
		})

		return
	end

	dispatchIfPlayerExists(p9, p10, SetPlayerAvatarIcon(p10, v53))
end
local function getPlayerIsBlocked(p11, p12) -- line: 183
	-- upvalues: BlockingUtility (copy), dispatchIfPlayerExists (copy), SetPlayerIsBlocked (copy)
	if BlockingUtility:IsPlayerBlockedByUserId(p12.UserId) then
		dispatchIfPlayerExists(p11, p12, SetPlayerIsBlocked(p12, true))
	end
end
local function getPlayerFriendStatus(p13, p14) -- line: 189
	-- upvalues: Players (copy), dispatchIfPlayerExists (copy), SetPlayerFriendStatus (copy)
	if p14 ~= Players.LocalPlayer and (p14.Parent == Players and Players.LocalPlayer.Parent == Players) then
		dispatchIfPlayerExists(p13, p14, SetPlayerFriendStatus(p14, Players.LocalPlayer:GetFriendStatus(p14)))
	end
end
local function MakePlayerInfoRequests(p15) -- line: 199
	-- upvalues: FFlagReplacePlayerIconRoduxWithSignal (copy), FFlagInExperienceUserProfileSettingsEnabled (copy), PlayerPermissionsModule (copy), PlayerIconInfoStore (copy), getGroupsPermissionsInfo (copy), getGameCreator (copy), getPlayerAvatarIcon (copy), getPlayerIsBlocked (copy), getPlayerFriendStatus (copy)
	return function(p16) -- line: 200
		-- upvalues: FFlagReplacePlayerIconRoduxWithSignal (copy), p15 (copy), FFlagInExperienceUserProfileSettingsEnabled (copy), PlayerPermissionsModule (copy), PlayerIconInfoStore (copy), getGroupsPermissionsInfo (copy), getGameCreator (copy), getPlayerAvatarIcon (copy), getPlayerIsBlocked (copy), getPlayerFriendStatus (copy)
		if FFlagReplacePlayerIconRoduxWithSignal then
			coroutine.wrap(function() -- line: 202
				-- upvalues: p15 (copy), FFlagInExperienceUserProfileSettingsEnabled (copy), PlayerPermissionsModule (copy), PlayerIconInfoStore (copy), getGroupsPermissionsInfo (copy), p16 (copy), getGameCreator (copy), getPlayerAvatarIcon (copy)
				local v61 = p15

				if not not FFlagInExperienceUserProfileSettingsEnabled and not not PlayerPermissionsModule.IsPlayerInExperienceNameEnabledAsync(v61) then
					PlayerIconInfoStore.setPlayerIconInfo(p15.UserId, {
						isPlaceOwner = false,
						avatarIcon = nil,
						specialGroupIcon = nil
					})

					return
				end

				coroutine.wrap(getGroupsPermissionsInfo)(p16, p15)
				coroutine.wrap(getGameCreator)(p16, p15)
				coroutine.wrap(getPlayerAvatarIcon)(p16, p15)
			end)()
		else
			coroutine.wrap(getGroupsPermissionsInfo)(p16, p15)
			coroutine.wrap(getGameCreator)(p16, p15)
			coroutine.wrap(getPlayerAvatarIcon)(p16, p15)
		end

		coroutine.wrap(getPlayerIsBlocked)(p16, p15)
		coroutine.wrap(getPlayerFriendStatus)(p16, p15)
	end
end

return MakePlayerInfoRequests
