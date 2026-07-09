local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local initiateRobloxSubscriptionPurchaseInternal = require(RobloxSubscriptionPurchaseApp.Actions.initiateRobloxSubscriptionPurchaseInternal)
local RobloxSubscriptionOverlayController = require(RobloxSubscriptionPurchaseApp.Flows.RobloxSubscriptionOverlayController)
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
local SurfaceContext = require(RobloxSubscriptionPurchaseApp.Enums.SurfaceContext)
local SurfaceName = require(RobloxSubscriptionPurchaseApp.Enums.SurfaceName)

require(RobloxSubscriptionPurchaseApp.types)

local FFlagRobloxPlusFAEFreeTrial = require(RobloxSubscriptionPurchaseApp.Flags.FFlagRobloxPlusFAEFreeTrial)

local function initiateRobloxSubscriptionPurchase(p1, p2, n1: number?, p3, p4, p5, p6) -- line: 18
	-- upvalues: RobloxSubscriptionStore (copy), FFlagRobloxPlusFAEFreeTrial (copy), SurfaceContext (copy), SurfaceName (copy), initiateRobloxSubscriptionPurchaseInternal (copy), RobloxSubscriptionOverlayController (copy)
	local v16 = RobloxSubscriptionStore.get()

	if p2 then
		if p2.onFlowComplete then
			v16.setOnFlowComplete(p2.onFlowComplete)
		end

		if p2.onBackButtonActivated then
			v16.setOnBackButtonActivated(p2.onBackButtonActivated)
		end

		if FFlagRobloxPlusFAEFreeTrial and p2.onCtaOverride then
			v16.setOnCtaOverride(p2.onCtaOverride)
		end
	end

	if p1 then
		v16.setPurchaseUIOptions(p1)
	end

	if p5 then
		v16.setPurchaseFlowOptions(p5)
	end

	local t1 = {}

	if n1 ~= nil then
		t1.universeId = n1
	end

	local v18 = if not p6 then nil else p6.clientSessionId
	local t2 = {
		context = p4 or SurfaceContext.Unspecified,
		surfaceName = p3 or SurfaceName.Unspecified,
		metadata = t1,
		clientSessionId = v18
	}

	v16.setEntryContext(t2)
	initiateRobloxSubscriptionPurchaseInternal(t2)

	return RobloxSubscriptionOverlayController.render()
end

return initiateRobloxSubscriptionPurchase
