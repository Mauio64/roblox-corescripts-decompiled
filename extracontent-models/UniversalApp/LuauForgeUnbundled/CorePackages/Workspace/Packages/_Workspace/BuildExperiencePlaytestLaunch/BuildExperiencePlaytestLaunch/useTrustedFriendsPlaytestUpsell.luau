local CentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/CentralOverlay")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/Localization")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/Navigation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/RoactUtils")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/RobloxAppEnums")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/SharedFlags")

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useNavigation = Navigation.useNavigation
local useLocalization = Localization.Hooks.useLocalization

local appPage = RobloxAppEnums.AppPage
local centralOverlayType = RobloxAppEnums.CentralOverlayType
local setCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local closeCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay

local dialogSize = Foundation.Enums.DialogSize

local fFlagLuaAppPlaytestTrustedFriendsRefetchPlayability = SharedFlags.FFlagLuaAppPlaytestTrustedFriendsRefetchPlayability

local function useTrustedFriendsPlaytestUpsell(p2, p3)
	local v5 = useDispatch()
	local v6 = useNavigation()

	local v7 = useLocalization({
		title = "Feature.Friends.TrustedFriend.Label.AddTrustedFriend",
		body = "Feature.Build.Message.TrustedFriendsRequiredForPlaytest",
		add = "Feature.Friends.Action.Add",
		cancel = "Feature.Build.Action.Cancel",
		ok = "CommonUI.Controls.Action.OK"
	})

	local v8 = not (v6 == nil) and p2 ~= nil

	local function fn()
		local confirmationDialog = centralOverlayType.ConfirmationDialog
		local v11 = {
			title = v7.title,
			body = v7.body,
			confirmButtonText = v7.add,
			cancelButtonText = 0,
			hideConfirmButton = 0,
			showCloseButton = false,
			size = 0,
			orientButtonsVertically = true,
			onConfirm = 0,
			onCancel = 0
		}

		local v12 = if v8 then v7.cancel else v7.ok
		v11.cancelButtonText = v12
		v11.hideConfirmButton = not v8

		v11.size = dialogSize.Small

		function v11.onConfirm()
			v5(closeCentralOverlay())

			if v8 then
				v6.push(appPage.TrustedContactsModal, {
					props = {
						userId = p2,
						onRequestAccepted = if fFlagLuaAppPlaytestTrustedFriendsRefetchPlayability then p3 else nil
					}
				})
			end
		end
		function v11.onCancel()
			v5(closeCentralOverlay())
		end

		v5(setCentralOverlay(confirmationDialog, v11))
	end

	return (React.useCallback(fn, {
		v5,
		v6,
		p2,
		if fFlagLuaAppPlaytestTrustedFriendsRefetchPlayability then p3 else nil,
		v8,
		v7.title,
		v7.body,
		v7.add,
		v7.cancel,
		v7.ok
	}))
end

return useTrustedFriendsPlaytestUpsell
