local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local AppLinking = require(CorePackages.Workspace.Packages.RoactServiceTags).AppLinking
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local withNavigation = RoactNavigation.withNavigation
local LocaleProvider = require(CorePackages.Workspace.Packages.IAPExperience).Locale.LocaleProvider

require(script.Parent.RobuxPackage)

local BuyRobuxOverlay = require(script.Parent.BuyRobuxOverlay)
local mapStateToProps = require(script.Parent.mapStateToProps)
local mapDispatchToProps = require(script.Parent.mapDispatchToProps)
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local BuyRobuxCounter = require(script.Parent.Enum.BuyRobuxCounter)
local v19 = Roact.PureComponent:extend(script.Name)
local default = require(CorePackages.Workspace.Packages.PaymentsProtocol).PaymentsProtocol.default
local GetFFlagUseEnablePremiumUserFeaturesAppPolicy = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagUseEnablePremiumUserFeaturesAppPolicy
local GetFFlagFixRobuxBalanceUpdateOnBuyRobuxPage = require(Modules.LuaApp.Flags.GetFFlagFixRobuxBalanceUpdateOnBuyRobuxPage)
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole

function v19.init(p1) -- line: 65
	-- upvalues: FFlagEnableLeftNavOnConsole (copy), default (copy)
	function p1.endPurchase() -- line: 66
		-- upvalues: p1 (copy)
		p1.props.dispatchClearNativePurchaseResult()
	end
	function p1.sendAnalyticEvent(s1: string, s2: string, t1: {[any]: any}) -- line: 70
		-- upvalues: p1 (copy)
		p1.props.analytics.EventStream:setRBXEventStream(s1, s2, t1)
	end
	function p1.sendCounter(s3: string) -- line: 75
		-- upvalues: p1 (copy)
		p1.props.analytics.Diag:reportCounter(s3, 1)
	end
	function p1.dispatchFetchIAPPurchaseWarning(s4: string, n1: number) -- line: 80
		-- upvalues: p1 (copy)
		return p1.props.dispatchFetchIAPPurchaseWarning(p1.props.networking, s4, n1, p1.props.isPremium)
	end
	function p1.dispatchPostAckPurchaseWarning(p2) -- line: 88
		-- upvalues: p1 (copy)
		return p1.props.dispatchPostAckPurchaseWarning(p1.props.networking, p2)
	end
	function p1.dispatchCheckUserPurchaseSettings() -- line: 91
		-- upvalues: p1 (copy)
		return p1.props.dispatchCheckUserPurchaseSettings(p1.props.networking)
	end
	function p1.onWillBlur() -- line: 94
		-- upvalues: FFlagEnableLeftNavOnConsole (copy), default (copy)
		if FFlagEnableLeftNavOnConsole then
			return
		end

		default:isAvailable():andThen(function(p3) -- line: 98
			-- upvalues: default (copy)
			if p3 then
				default:sendIAPEvent("BrowseProductEnd")
			end
		end)
	end
	function p1.onWillUnmount() -- line: 106
		-- upvalues: FFlagEnableLeftNavOnConsole (copy), default (copy)
		if not FFlagEnableLeftNavOnConsole then
			return
		end

		default:isAvailable():andThen(function(p4) -- line: 110
			-- upvalues: default (copy)
			if p4 then
				default:sendIAPEvent("BrowseProductEnd")
			end
		end)
	end
end
function v19.didMount(p5) -- line: 119
	-- upvalues: RetrievalStatus (copy), default (copy), GetFFlagFixRobuxBalanceUpdateOnBuyRobuxPage (copy)
	local props = p5.props

	if p5.props.iapProductsFetchingStatus == RetrievalStatus.NotStarted or p5.props.iapProductsFetchingStatus == RetrievalStatus.Failed then
		p5.props.dispatchFetchIAPProducts(p5.props.networking)
	end

	if p5.props.nativeProductsFetchingStatus == RetrievalStatus.NotStarted or p5.props.nativeProductsFetchingStatus == RetrievalStatus.Failed then
		p5.props.dispatchFetchNativeIAPProducts()
	end

	default:isAvailable():andThen(function(p6) -- line: 138
		-- upvalues: default (copy)
		if p6 then
			default:sendIAPEvent("BrowseProductStart")
		end
	end)

	if GetFFlagFixRobuxBalanceUpdateOnBuyRobuxPage() then
		props.dispatchFetchUserBalance(p5.props.networking, (tostring(p5.props.userId)))
	end
end
function v19.didUpdate(t2: {[any]: any}, t3: {[any]: any}) -- line: 150
	-- upvalues: RetrievalStatus (copy), BuyRobuxCounter (copy), default (copy)
	local props = t2.props

	if props.iapProductsFetchingStatus ~= t3.iapProductsFetchingStatus and props.iapProductsFetchingStatus == RetrievalStatus.Failed then
		t2.sendCounter(BuyRobuxCounter.toRawValue(BuyRobuxCounter.InvalidProducts))
	end

	if props.iapProductsFetchingStatus == RetrievalStatus.Done and props.nativeProductsFetchingStatus == RetrievalStatus.Done and #props.robuxPackages == 0 then
		default:isAvailable():andThen(function(p7) -- line: 163
			-- upvalues: default (copy)
			if p7 then
				default:sendIAPEvent("ProductNotAvailable")
			end
		end)
		t2.props.dispatchNavigateBack()
	end
end
function v19.render(p8) -- line: 173
	-- upvalues: FFlagEnableLeftNavOnConsole (copy), Roact (copy), RoactNavigation (copy), LocaleProvider (copy), LocalizationService (copy), BuyRobuxOverlay (copy)
	local v32 = if not FFlagEnableLeftNavOnConsole then Roact.createElement(RoactNavigation.NavigationEvents, {
		onWillBlur = p8.onWillBlur
	}) else nil

	return Roact.createElement(LocaleProvider, {
		locale = LocalizationService.RobloxLocaleId
	}, {
		navigationEvents = if not FFlagEnableLeftNavOnConsole then v32 else nil,
		BuyRobuxOverlay = Roact.createElement(BuyRobuxOverlay, {
			eventPrefix = "",
			screenSize = p8.props.screenSize,
			networking = p8.props.networking,
			robuxBalance = p8.props.robuxBalance,
			robuxPackages = p8.props.robuxPackages,
			analyticId = p8.props.analyticId,
			iapPurchase = p8.props.iapPurchase,
			iapProductsFetchingStatus = p8.props.iapProductsFetchingStatus,
			nativeProductsFetchingStatus = p8.props.nativeProductsFetchingStatus,
			dispatchFetchIAPPurchaseWarning = p8.dispatchFetchIAPPurchaseWarning,
			dispatchPostAckPurchaseWarning = p8.dispatchPostAckPurchaseWarning,
			dispatchCentralOverlay = p8.props.dispatchCentralOverlay,
			dispatchCheckUserPurchaseSettings = p8.dispatchCheckUserPurchaseSettings,
			endPurchase = p8.endPurchase,
			promptRobux = p8.props.promptRobux,
			sendAnalyticEvent = p8.sendAnalyticEvent,
			sendCounter = p8.sendCounter,
			onPageClose = p8.props.dispatchNavigateBack
		})
	})
end
function v19.willUnmount(p9) -- line: 214
	-- upvalues: FFlagEnableLeftNavOnConsole (copy)
	if FFlagEnableLeftNavOnConsole then
		p9.onWillUnmount()
	end
end

local v24 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v19)

if GetFFlagUseEnablePremiumUserFeaturesAppPolicy() then
	v24 = RoactAppPolicy.connect(function(p10, _) -- line: 223
		return {
			enablePremiumUserFeatures = p10.getEnablePremiumUserFeatures()
		}
	end)(v24)
end

return (withNavigation((RoactServices.connect({
	networking = RoactNetworking,
	analytics = RoactAnalytics,
	linking = AppLinking
})(v24))))
