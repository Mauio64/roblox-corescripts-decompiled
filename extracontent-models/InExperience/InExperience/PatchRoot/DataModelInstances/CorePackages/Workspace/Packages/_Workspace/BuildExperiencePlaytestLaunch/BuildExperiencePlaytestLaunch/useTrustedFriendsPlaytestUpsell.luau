local parent = script:FindFirstAncestor("BuildExperiencePlaytestLaunch").Parent
local CentralOverlay = require(parent.CentralOverlay)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local Navigation = require(parent.Navigation)
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local SharedFlags = require(parent.SharedFlags)

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useNavigation = Navigation.useNavigation
local useLocalization = Localization.Hooks.useLocalization

local AppPage = RobloxAppEnums.AppPage
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay

local DialogSize = Foundation.Enums.DialogSize

local FFlagLuaAppPlaytestTrustedFriendsRefetchPlayability = SharedFlags.FFlagLuaAppPlaytestTrustedFriendsRefetchPlayability

local function useTrustedFriendsPlaytestUpsell(userId: string?, callback)
	local v = useDispatch()
	local v2 = useNavigation()

	local v3 = useLocalization({
		title = "Feature.Friends.TrustedFriend.Label.AddTrustedFriend",
		body = "Feature.Build.Message.TrustedFriendsRequiredForPlaytest",
		add = "Feature.Friends.Action.Add",
		cancel = "Feature.Build.Action.Cancel",
		ok = "CommonUI.Controls.Action.OK"
	})
	local v4

	if v2 == nil then
		v4 = false
	else
		v4 = userId ~= nil
	end

	local useCallback = React.useCallback
	local function fn()
		local confirmationDialog = CentralOverlayType.ConfirmationDialog
		local v5 = {
			title = v3.title,
			body = v3.body,
			confirmButtonText = v3.add,
			cancelButtonText = 0,
			hideConfirmButton = 0,
			showCloseButton = false,
			size = 0,
			orientButtonsVertically = true,
			onConfirm = 0,
			onCancel = 0
		}

		local cancelButtonText = if v4 then v3.cancel else v3.ok
		v5.cancelButtonText = cancelButtonText
		v5.hideConfirmButton = not v4

		v5.size = DialogSize.Small

		function v5.onConfirm()
			v(CloseCentralOverlay())

			if v4 then
				local push = v2.push
				local trustedContactsModal = AppPage.TrustedContactsModal
				local props = { userId = userId, onRequestAccepted = nil }
				local onRequestAccepted

				if FFlagLuaAppPlaytestTrustedFriendsRefetchPlayability then
					onRequestAccepted = callback
				end

				props.onRequestAccepted = onRequestAccepted
				push(trustedContactsModal, { props = props })
			end
		end
		function v5.onCancel()
			v(CloseCentralOverlay())
		end

		v(SetCentralOverlay(confirmationDialog, v5))
	end

	local v5

	if FFlagLuaAppPlaytestTrustedFriendsRefetchPlayability then
		v5 = callback
	end

	return (useCallback(fn, {
		v,
		v2,
		userId,
		v5,
		v4,
		v3.title,
		v3.body,
		v3.add,
		v3.cancel,
		v3.ok
	}))
end

return useTrustedFriendsPlaytestUpsell
