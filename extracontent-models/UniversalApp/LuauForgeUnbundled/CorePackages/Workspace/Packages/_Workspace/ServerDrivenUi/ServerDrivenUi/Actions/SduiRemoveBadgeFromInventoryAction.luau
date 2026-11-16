local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local sduiActionType = SduiCoreSystem.SduiActionType
local closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/CentralOverlay").Thunks.CloseCentralOverlay
local setCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/CentralOverlay").Actions.SetCentralOverlay
local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppEnums").CentralOverlayType
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DataHydration")
local localizeStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Localization").localizeStrings

return function(p2, p3, p4, p5)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.RemoveBadgeFromInventory,
				message = "Missing action params"
			},
			p4.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")

	if actionParams.assetId == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.RemoveBadgeFromInventory,
				message = "Missing actionParam: assetId"
			},
			p4.appPage
		)
		return
	end

	local assetId = actionParams.assetId

	local v5 = localizeStrings(p4.dependencies.localization, {
		RemoveBadgeTitle = "Feature.Item.Label.DeleteItemUndercase",
		RemoveBadgeBody = "Feature.Item.Label.DeleteFromInventoryConfirmUndercaseDelete"
	})

	local dispatch = p4.dependencies.dispatch
	dispatch(setCentralOverlay(centralOverlayType.ConfirmationDialog, {
		title = v5.RemoveBadgeTitle,
		body = v5.RemoveBadgeBody,
		disablePortal = false,
		onConfirm = function()
			DataHydration.Badges.getBadgeInfoStore(false).removeBadge((tostring(assetId)))
			dispatch(closeCentralOverlay())
		end,
		onCancel = function()
			dispatch(closeCentralOverlay())
		end
	}))
end
