local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AppPage = require(Modules.LuaApp.AppPage)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local NavigateDownToExternalVngShop = require(Modules.LuaApp.Thunks.Economy.NavigateDownToExternalVngShop)
local getAppFeaturePolicies = require(CorePackages.Workspace.Packages.UniversalAppPolicy).getAppFeaturePolicies
local OpenCentralOverlayForLeaveRobloxAlert = require(Modules.LuaApp.Thunks.OpenCentralOverlayForLeaveRobloxAlert)
local getPaymentPlatform = require(Modules.LuaApp.Util.getPaymentPlatform)
local PaymentPlatform = require(Modules.LuaApp.Enum.PaymentPlatform)
local PurchasingPerformance = require(CorePackages.Workspace.Packages.PurchasingPerformance)
local BuyRobuxPageTTIManager = PurchasingPerformance.BuyRobuxPageTTIManager
local FFlagEnableBuyRobuxPageTTI = PurchasingPerformance.Flags.FFlagEnableBuyRobuxPageTTI
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v14 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands

return function(p1, p2, s1: string?) -- line: 23
	-- upvalues: getPaymentPlatform (copy), getAppFeaturePolicies (copy), PaymentPlatform (copy), OpenCentralOverlayForLeaveRobloxAlert (copy), NavigateDownToExternalVngShop (copy), FFlagEnableBuyRobuxPageTTI (copy), BuyRobuxPageTTIManager (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v14 (copy), NavigateDown (copy)
	return function(p3) -- line: 24
		-- upvalues: getPaymentPlatform (copy), getAppFeaturePolicies (copy), PaymentPlatform (copy), OpenCentralOverlayForLeaveRobloxAlert (copy), NavigateDownToExternalVngShop (copy), p1 (copy), p2 (copy), FFlagEnableBuyRobuxPageTTI (copy), BuyRobuxPageTTIManager (copy), AppPage (copy), s1 (copy), FFlagSignalsNavP3Dispatch (copy), v14 (copy), NavigateDown (copy)
		local v19 = getPaymentPlatform()

		if getAppFeaturePolicies().getRedirectBuyRobuxToVNG() and v19 == PaymentPlatform.Web then
			p3:dispatch(OpenCentralOverlayForLeaveRobloxAlert(function() -- line: 28
				-- upvalues: p3 (copy), NavigateDownToExternalVngShop (copy), p1 (copy), p2 (copy)
				p3:dispatch(NavigateDownToExternalVngShop(p1, p2))
			end))

			return
		end

		if FFlagEnableBuyRobuxPageTTI then
			BuyRobuxPageTTIManager.startTracking()
		end

		local t1 = {
			name = AppPage.PurchaseRobux,
			extraProps = {
				analyticId = s1
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v14.down(v14.fromLegacyPage(t1))

			return
		end

		p3:dispatch(NavigateDown(t1))
	end
end
