local parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType
local CentralOverlay = require(parent.CentralOverlay)
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local CentralOverlay2 = require(parent.CentralOverlay)
local SetCentralOverlay = CentralOverlay2.Actions.SetCentralOverlay
local RobloxAppEnums = require(parent.RobloxAppEnums)
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local DataHydration = require(parent.DataHydration)
local Localization = require(parent.Localization)
local localizeStrings = Localization.localizeStrings

return function(p, _, p2, _)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.RemoveBadgeFromInventory, message = "Missing action params" },
			p2.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")

	if actionParams.assetId == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.RemoveBadgeFromInventory,
				message = "Missing actionParam: assetId"
			},
			p2.appPage
		)
		return
	end

	local assetId = actionParams.assetId

	local v = localizeStrings(p2.dependencies.localization, {
		RemoveBadgeTitle = "Feature.Item.Label.DeleteItemUndercase",
		RemoveBadgeBody = "Feature.Item.Label.DeleteFromInventoryConfirmUndercaseDelete"
	})

	local dispatch = p2.dependencies.dispatch
	dispatch(SetCentralOverlay(CentralOverlayType.ConfirmationDialog, {
		title = v.RemoveBadgeTitle,
		body = v.RemoveBadgeBody,
		disablePortal = false,
		onConfirm = function()
			DataHydration.Badges.getBadgeInfoStore(false).removeBadge((tostring(assetId)))
			dispatch(CloseCentralOverlay())
		end,
		onCancel = function()
			dispatch(CloseCentralOverlay())
		end
	}))
end
