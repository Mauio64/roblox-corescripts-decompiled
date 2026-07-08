local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)
local isNewInGameMenuEnabled = require(Modules.isNewInGameMenuEnabled)
local Toast = require(CorePackages.Packages.UIBlox).App.Dialog.Toast
local ActionModal = require(script.Parent.ActionModal)
local FFlagConnectionsToFriendsRename = require(CorePackages.Workspace.Packages.SharedFlags).FFlagConnectionsToFriendsRename

local function BlockingModalContainer(t1: {[any]: any}) -- line: 33
	-- upvalues: BlockingUtility (copy), React (copy), isNewInGameMenuEnabled (copy), Modules (copy), useLocalization (copy), FFlagConnectionsToFriendsRename (copy), Toast (copy), ActionModal (copy)
	local player = t1.player
	local closeModal = t1.closeModal
	local v14 = t1.blockingUtility or BlockingUtility
	local analytics = t1.analytics
	local source = t1.source
	local onBlockingSuccess = t1.onBlockingSuccess
	local v18, v19 = React.useState(Vector2.new(1000, 1000))
	local v20, v21 = React.useState(false)
	local v22 = React.useCallback(function() -- line: 45
		-- upvalues: v14 (copy), player (copy), analytics (copy), source (copy), onBlockingSuccess (copy), closeModal (copy), v21 (copy)
		if v14:BlockPlayerAsync(player) then
			analytics:action("SettingsHub", "blockUser", {
				blockeeUserId = player.UserId,
				source = source
			})

			if onBlockingSuccess then
				onBlockingSuccess()
			end

			closeModal()

			return
		end

		v21(true)
	end, {
		closeModal,
		player,
		analytics,
		source,
		onBlockingSuccess
	})
	local v23 = React.useCallback(function() -- line: 62
		-- upvalues: v22 (copy), source (copy), isNewInGameMenuEnabled (copy), Modules (copy), player (copy)
		v22()

		local v25 = source or "BlockingModal"

		if isNewInGameMenuEnabled() then
			require(Modules.InGameMenuInit).openReportDialog(player, v25)

			return
		end

		require(Modules.Settings.Pages.ReportAbuseMenuNewContainerPage):ReportPlayer(player, v25)
	end, {
		v22,
		player,
		source
	})
	local v24 = useLocalization({
		cancelTextKey = "Feature.BlockingModal.Action.Cancel",
		blockTextKey = "Feature.BlockingModal.Action.Block",
		blockAndReportTextKey = "Feature.BlockingModal.Action.BlockAndReport",
		blockingFailed = "Feature.Toast.NetworkingError.SomethingIsWrong",
		titleKey = {
			"Feature.BlockingModal.Heading.BlockUser",
			DisplayName = player.DisplayName
		},
		bodyKey = not FFlagConnectionsToFriendsRename and "Feature.BlockingModal.Message.BlockConfirmation" or "Feature.BlockingModal.Message.BlockConfirmation.FriendsRename"
	})

	if v20 then
		return React.createElement(Toast, {
			duration = 3,
			show = v20,
			toastContent = {
				toastTitle = v24.blockingFailed,
				onDismissed = closeModal
			}
		})
	end

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ZIndex = 2,
		[React.Change.AbsoluteSize] = function(p1) -- line: 105
			-- upvalues: v19 (copy)
			v19(p1.AbsoluteSize)
		end
	}, {
		BlockingModal = React.createElement(ActionModal, {
			screenSize = v18,
			title = v24.titleKey,
			body = v24.bodyKey,
			blockText = v24.blockTextKey,
			blockAndReportText = v24.blockAndReportTextKey,
			cancelText = v24.cancelTextKey,
			cancel = closeModal,
			block = v22,
			blockAndReport = v23
		})
	})
end

return BlockingModalContainer
