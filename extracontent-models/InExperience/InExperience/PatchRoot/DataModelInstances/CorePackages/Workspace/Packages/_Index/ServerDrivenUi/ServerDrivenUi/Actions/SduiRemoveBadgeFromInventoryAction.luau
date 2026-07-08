local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType
local CloseCentralOverlay = require(Parent.CentralOverlay).Thunks.CloseCentralOverlay
local SetCentralOverlay = require(Parent.CentralOverlay).Actions.SetCentralOverlay
local CentralOverlayType = require(Parent.RobloxAppEnums).CentralOverlayType
local DataHydration = require(Parent.DataHydration)
local localizeStrings = require(Parent.Localization).localizeStrings

return function(p1, _, p3, _) -- line: 16
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), localizeStrings (copy), SetCentralOverlay (copy), CentralOverlayType (copy), DataHydration (copy), CloseCentralOverlay (copy)
	local v14 = p1 and p1.actionParams or nil

	if v14 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing action params",
			name = SduiActionType.RemoveBadgeFromInventory
		}, p3.appPage)

		return
	end

	assert(v14, "actionParams must exist")

	if v14.assetId == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParam: assetId",
			name = SduiActionType.RemoveBadgeFromInventory
		}, p3.appPage)

		return
	end

	local assetId = v14.assetId
	local localization = p3.dependencies.localization
	local v17 = localizeStrings(localization, {
		RemoveBadgeTitle = "Feature.Item.Label.DeleteItemUndercase",
		RemoveBadgeBody = "Feature.Item.Label.DeleteFromInventoryConfirmUndercaseDelete"
	})
	local dispatch = p3.dependencies.dispatch

	dispatch(SetCentralOverlay(CentralOverlayType.ConfirmationDialog, {
		disablePortal = false,
		title = v17.RemoveBadgeTitle,
		body = v17.RemoveBadgeBody,
		onConfirm = function() -- line: 53
			-- upvalues: DataHydration (copy), assetId (copy), dispatch (copy), CloseCentralOverlay (copy)
			DataHydration.Badges.getBadgeInfoStore(false).removeBadge((tostring(assetId)))
			dispatch(CloseCentralOverlay())
		end,
		onCancel = function() -- line: 58
			-- upvalues: dispatch (copy), CloseCentralOverlay (copy)
			dispatch(CloseCentralOverlay())
		end
	}))
end
