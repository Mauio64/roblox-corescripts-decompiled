local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Modules = CoreGui.RobloxGui.Modules

local React = require(CorePackages.Packages.React)
local Localization = require(CorePackages.Workspace.Packages.Localization)
local useLocalization = Localization.Hooks.useLocalization

local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)
local isNewInGameMenuEnabled = require(Modules.isNewInGameMenuEnabled)

local UIBlox = require(CorePackages.Packages.UIBlox)
local Toast = UIBlox.App.Dialog.Toast

local ActionModal = require(script.Parent.ActionModal)

local function BlockingModalContainer(props)
	local player = props.player
	local closeModal = props.closeModal
	local blockingUtility = props.blockingUtility or BlockingUtility
	local analytics = props.analytics
	local source = props.source
	local onBlockingSuccess = props.onBlockingSuccess

	local state, setState = React.useState(Vector2.new(1000, 1000))
	local state2, setState2 = React.useState(false)

	local block = React.useCallback(function()
		if not blockingUtility:BlockPlayerAsync(player) then
			setState2(true)

			return
		end

		analytics:action("SettingsHub", "blockUser", {
			blockeeUserId = player.UserId,
			source = source
		})

		if onBlockingSuccess then
			onBlockingSuccess()
		end

		closeModal()
	end, { closeModal, player, analytics, source, onBlockingSuccess })

	local blockAndReport = React.useCallback(function()
		block()

		local v = source or "BlockingModal"

		if isNewInGameMenuEnabled() then
			local InGameMenuInit = require(Modules.InGameMenuInit)
			InGameMenuInit.openReportDialog(player, v)
		else
			local ReportAbuseMenuContainerPage = require(Modules.Settings.Pages.ReportAbuseMenuContainerPage)
			ReportAbuseMenuContainerPage:ReportPlayer(player, v)
		end
	end, { block, player, source })

	local v = useLocalization({
		titleKey = {
			"Feature.BlockingModal.Heading.BlockUser",
			DisplayName = player.DisplayName
		},
		bodyKey = "Feature.BlockingModal.Message.BlockConfirmation.FriendsRename",
		cancelTextKey = "Feature.BlockingModal.Action.Cancel",
		blockTextKey = "Feature.BlockingModal.Action.Block",
		blockAndReportTextKey = "Feature.BlockingModal.Action.BlockAndReport",
		blockingFailed = "Feature.Toast.NetworkingError.SomethingIsWrong"
	})

	if state2 then
		return React.createElement(Toast, {
			duration = 3,
			show = state2,
			toastContent = { toastTitle = v.blockingFailed, onDismissed = closeModal }
		})
	end

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ZIndex = 2,
		[React.Change.AbsoluteSize] = function(p)
			setState(p.AbsoluteSize)
		end
	}, {
		BlockingModal = React.createElement(ActionModal, {
			screenSize = state,
			title = v.titleKey,
			body = v.bodyKey,
			blockText = v.blockTextKey,
			blockAndReportText = v.blockAndReportTextKey,
			cancelText = v.cancelTextKey,
			cancel = closeModal,
			block = block,
			blockAndReport = blockAndReport
		})
	})
end

return BlockingModalContainer
