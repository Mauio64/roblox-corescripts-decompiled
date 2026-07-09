local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local AppPage = require(Modules.LuaApp.AppPage)
local ClearNativePurchaseResult = require(Modules.LuaApp.Actions.ClearNativePurchaseResult)
local ApiFetchRobuxProduct = require(Modules.LuaApp.Thunks.Economy.ApiFetchRobuxProduct)
local ApiFetchRobuxProductWithItemInfo = require(Modules.LuaApp.Thunks.Economy.ApiFetchRobuxProductWithItemInfo)
local ApiFetchIAPPurchaseWarning = require(Modules.LuaApp.Thunks.ApiFetchIAPPurchaseWarning)
local ApiPostAckPurchaseWarning = require(Modules.LuaApp.Thunks.ApiPostAckPurchaseWarning)
local OpenNativePurchase = require(Modules.LuaApp.Thunks.Economy.OpenNativePurchase)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local NavigateDownToSecuritySettings = require(Modules.LuaApp.Thunks.NavigateDownToSecuritySettings)
local RenderChallenge = require(Modules.LuaApp.Thunks.Challenge.RenderChallenge)
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)
local SetCentralOverlay = require(Modules.LuaApp.Actions.SetCentralOverlay)
local ApiPostCheckUserPurchaseSettings = require(Modules.LuaApp.Thunks.ApiPostCheckUserPurchaseSettings)
local OpenPurchaseRobuxPage = require(Modules.LuaApp.Thunks.Economy.OpenPurchaseRobuxPage)
local GetFStringVNGTosUrl = require(CorePackages.Workspace.Packages.SharedFlags).GetFStringVNGTosUrl
local GetFFlagOpenVngTosForVngRobuxUpsell = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagOpenVngTosForVngRobuxUpsell
local getAppFeaturePolicies = require(CorePackages.Workspace.Packages.UniversalAppPolicy).getAppFeaturePolicies
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v21 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands

return function(p1) -- line: 32
	-- upvalues: ApiFetchRobuxProductWithItemInfo (copy), ApiFetchRobuxProduct (copy), ApiFetchIAPPurchaseWarning (copy), ApiPostAckPurchaseWarning (copy), SetCentralOverlay (copy), ClearNativePurchaseResult (copy), OpenNativePurchase (copy), GetFFlagOpenVngTosForVngRobuxUpsell (copy), getAppFeaturePolicies (copy), AppPage (copy), GetFStringVNGTosUrl (copy), UrlBuilder (copy), FFlagSignalsNavP3Dispatch (copy), v21 (copy), NavigateDown (copy), NavigateDownToSecuritySettings (copy), OpenPurchaseRobuxPage (copy), RenderChallenge (copy), ApiPostCheckUserPurchaseSettings (copy)
	return {
		dispatchFetchRobuxProduct = function(p2, n1: number, n2: number, n3: number?, s1: string?, n4: number?) -- line: 34
			-- upvalues: p1 (copy), ApiFetchRobuxProductWithItemInfo (copy), ApiFetchRobuxProduct (copy)
			if n4 ~= nil and (n3 ~= nil and s1 ~= nil) then
				return p1(ApiFetchRobuxProductWithItemInfo(p2, n1, n2, n3, s1, n4))
			end

			return p1(ApiFetchRobuxProduct(p2, n1, n2))
		end,
		dispatchFetchIAPPurchaseWarning = function(p3, s2: string, n5: number, b1: boolean) -- line: 57
			-- upvalues: p1 (copy), ApiFetchIAPPurchaseWarning (copy)
			return p1(ApiFetchIAPPurchaseWarning.Fetch(p3, s2, n5, b1))
		end,
		dispatchPostAckPurchaseWarning = function(p4, p5) -- line: 65
			-- upvalues: p1 (copy), ApiPostAckPurchaseWarning (copy)
			return p1(ApiPostAckPurchaseWarning.Post(p4, p5))
		end,
		dispatchCentralOverlay = function(p6, p7) -- line: 68
			-- upvalues: p1 (copy), SetCentralOverlay (copy)
			return p1(SetCentralOverlay(p6, p7))
		end,
		endPurchase = function() -- line: 71
			-- upvalues: p1 (copy), ClearNativePurchaseResult (copy)
			p1(ClearNativePurchaseResult())
		end,
		promptRobux = function(p8, s3: string, n6: number, s4: string?) -- line: 74
			-- upvalues: p1 (copy), OpenNativePurchase (copy)
			p1(OpenNativePurchase(p8, s3, n6, s4))
		end,
		openTermsOfUse = function() -- line: 77
			-- upvalues: GetFFlagOpenVngTosForVngRobuxUpsell (copy), getAppFeaturePolicies (copy), AppPage (copy), GetFStringVNGTosUrl (copy), UrlBuilder (copy), FFlagSignalsNavP3Dispatch (copy), v21 (copy), p1 (copy), NavigateDown (copy)
			local v41 = GetFFlagOpenVngTosForVngRobuxUpsell() and getAppFeaturePolicies().getShowVNGTosForRobuxUpsell()
			local t1 = {
				name = AppPage.GenericWebPage,
				detail = if not v41 then UrlBuilder.static.about.terms() else GetFStringVNGTosUrl(),
				extraProps = {
					title = ""
				}
			}

			if FFlagSignalsNavP3Dispatch then
				v21.down(v21.fromLegacyPage(t1))

				return
			end

			p1(NavigateDown(t1))
		end,
		openSecuritySettings = function() -- line: 93
			-- upvalues: p1 (copy), NavigateDownToSecuritySettings (copy)
			p1(NavigateDownToSecuritySettings())
		end,
		openBuyRobux = function(p9) -- line: 96
			-- upvalues: p1 (copy), OpenPurchaseRobuxPage (copy)
			return p1(OpenPurchaseRobuxPage(nil, p9))
		end,
		renderChallenge = function(p10, p11) -- line: 99
			-- upvalues: p1 (copy), RenderChallenge (copy)
			return p1(RenderChallenge(p10, p11))
		end,
		dispatchCheckUserPurchaseSettings = function(p12) -- line: 102
			-- upvalues: p1 (copy), ApiPostCheckUserPurchaseSettings (copy)
			return p1(ApiPostCheckUserPurchaseSettings.Post(p12))
		end,
		openSettingsPage = function() -- line: 105
			-- upvalues: AppPage (copy), UrlBuilder (copy), FFlagSignalsNavP3Dispatch (copy), v21 (copy), p1 (copy), NavigateDown (copy)
			local t2 = {
				name = AppPage.SettingsSubPage,
				detail = UrlBuilder.static.settings.billing(),
				extraProps = {
					titleKey = "Feature.AccountSettings.Heading.Tab.Spending"
				}
			}

			if FFlagSignalsNavP3Dispatch then
				return v21.down(v21.fromLegacyPage(t2))
			end

			return p1(NavigateDown(t2))
		end
	}
end
