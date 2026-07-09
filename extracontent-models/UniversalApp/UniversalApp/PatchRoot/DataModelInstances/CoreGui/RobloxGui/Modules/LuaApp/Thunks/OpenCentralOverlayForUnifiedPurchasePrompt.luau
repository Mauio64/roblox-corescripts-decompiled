local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local OverlayType = require(Modules.LuaApp.Enum.OverlayType)
local SetCentralOverlay = require(Modules.LuaApp.Actions.SetCentralOverlay)

require(CorePackages.Workspace.Packages.PurchasePrompt)

local TimeToInteractiveTracker = require(CorePackages.Workspace.Packages.TimeToInteractiveTracker).TimeToInteractiveTracker
local getTTIEventName = require(CorePackages.Workspace.Packages.PurchasePromptLite).getTTIEventName

return function(p1, b1: boolean?) -- line: 12
	-- upvalues: getTTIEventName (copy), TimeToInteractiveTracker (copy), SetCentralOverlay (copy), OverlayType (copy)
	if b1 and (p1 and p1.purchaseAnalyticsMetadata and p1.purchaseAnalyticsMetadata.surface) then
		local v9 = getTTIEventName(p1.purchaseAnalyticsMetadata.surface)

		TimeToInteractiveTracker.trackStart(v9)
		TimeToInteractiveTracker.updateMetadata(v9, {
			category = "unified_purchase_modal",
			page = p1.purchaseAnalyticsMetadata.surface
		})
	end

	return function(p2) -- line: 22
		-- upvalues: SetCentralOverlay (copy), OverlayType (copy), p1 (copy)
		p2:dispatch(SetCentralOverlay(OverlayType.UnifiedProductPurchaseModal, p1))
	end
end
