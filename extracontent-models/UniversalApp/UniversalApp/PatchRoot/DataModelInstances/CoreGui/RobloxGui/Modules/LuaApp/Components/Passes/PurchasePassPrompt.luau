local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local IXPService = game:GetService("IXPService")
local Roact = require(Modules.Common.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local Constants = require(Modules.LuaApp.Constants)
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local getPurchaseErrorTypeFromErrorResponse = require(Modules.LuaApp.getPurchaseErrorTypeFromErrorResponse)
local withLocalization = require(Modules.LuaApp.withLocalization)
local withStyle = UIBlox.Style.withStyle
local t = require(CorePackages.Packages.t)
local IAPExperience = require(CorePackages.Workspace.Packages.IAPExperience)
local EconomicRestrictionsCounter = IAPExperience.Counters.EconomicRestrictionsCounter
local UniversalEconomicRestrictionsCounter = EconomicRestrictionsCounter.UniversalEconomicRestrictionsCounter
local EconomicRestrictionsSurface = EconomicRestrictionsCounter.EconomicRestrictionsSurface
local default = require(CorePackages.Workspace.Packages.LoggingProtocol).default
local parseEconomicRestrictionsFailureReason = IAPExperience.Utility.parseEconomicRestrictionsFailureReason
local parseEconomicRestrictionsExpirationTimeInMinutes = IAPExperience.Utility.parseEconomicRestrictionsExpirationTimeInMinutes
local FFlagAddUnifiedPurchaseFlowTTIToEDP = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAddUnifiedPurchaseFlowTTIToEDP
local PurchasePromptLite = require(CorePackages.Workspace.Packages.PurchasePromptLite)
local getTTIEventName = PurchasePromptLite.getTTIEventName
local TimeToInteractiveTracker = require(CorePackages.Workspace.Packages.TimeToInteractiveTracker).TimeToInteractiveTracker
local ProductPurchaseSurface = PurchasePromptLite.Enums.ProductPurchaseSurface
local Promise = require(CorePackages.Packages.Promise)
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local PurchaseErrors = require(Modules.LuaApp.Enum.PurchaseErrors)
local NumberLocalization = require(CorePackages.Workspace.Packages.Localization).NumberLocalization
local DataHydration = require(CorePackages.Workspace.Packages.DataHydration)
local AlertWindow = require(Modules.LuaApp.Components.AlertWindow)
local ApiFetchGamePasses = require(Modules.LuaApp.Thunks.Games.ApiFetchGamePasses)
local FFlagLuaAppGamePassesDataHydrationMigrationEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppGamePassesDataHydrationMigrationEnabled
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local OpenCentralOverlayForPurchasePassInsufficientRobux = require(Modules.LuaApp.Thunks.OpenCentralOverlayForPurchasePassInsufficientRobux)
local OpenCentralOverlayForEconomicRestrictionPrompt = require(Modules.LuaApp.Thunks.Fraud.OpenCentralOverlayForEconomicRestrictionPrompt)
local NavigateDownToRobuxUpsell = require(Modules.LuaApp.Thunks.Economy.NavigateDownToRobuxUpsell)
local RobuxUpsellTriggerContext = require(Modules.LuaApp.Components.RobuxUpsell.Enum.RobuxUpsellTriggerContext)
local PurchaseGamePass = require(Modules.LuaApp.Thunks.Games.PurchaseGamePass)
local SetPurchaseErrorToast = require(Modules.LuaApp.Thunks.SetPurchaseErrorToast)
local GamepassRobuxUpsellIXPTest = require(Modules.LuaApp.Flags.GamepassRobuxUpsellIXPTest)
local v48 = Roact.PureComponent:extend("PurchasePassPrompt")

v48.validateProps = t.strictInterface({
	universeId = t.string,
	pass = t.table,
	containerWidth = t.number,
	defaultChildRef = t.optional(t.any),
	focusController = t.optional(t.any),
	localization = t.any,
	networking = t.callback,
	analytics = t.any,
	gamepassRobuxUpsellEnabled = t.optional(t.boolean),
	purchaseStatus = t.optional(t.any),
	userRobux = t.optional(t.number),
	setCurrentToastMessage = t.callback,
	navigateDownToRobuxUpsell = t.callback,
	openPurchasePassInsufficientRobux = t.callback,
	purchasePass = t.callback,
	economicRestrictionErrorHandler = t.callback,
	closePrompt = t.callback,
	apiFetchGamePasses = if not FFlagLuaAppGamePassesDataHydrationMigrationEnabled then t.callback else nil,
	setPurchaseErrorToast = t.callback
})

function v48.init(p1) -- line: 97
	-- upvalues: GamepassRobuxUpsellIXPTest (copy), IXPService (copy), AppUserLayers (copy), Constants (copy), FFlagLuaAppGamePassesDataHydrationMigrationEnabled (copy), DataHydration (copy), getPurchaseErrorTypeFromErrorResponse (copy), PurchaseErrors (copy), Promise (copy), ToastType (copy)
	function p1.onPurchaseFailedWithRobuxShortfall(_) -- line: 98
		-- upvalues: GamepassRobuxUpsellIXPTest (copy), IXPService (copy), AppUserLayers (copy), p1 (copy), Constants (copy)
		if GamepassRobuxUpsellIXPTest.isEnabled() then
			IXPService:LogUserLayerExposure(AppUserLayers.GamepassRobuxUpsellLayer)

			local Diag = p1.props.analytics.Diag

			p1.props.analytics.EventStream:setRBXEventStream("ua", "GamepassRobuxUpsellIXP", {
				isVariant = p1.props.gamepassRobuxUpsellEnabled
			})

			if p1.props.gamepassRobuxUpsellEnabled then
				Diag:reportCounter("UAGamepassRobuxUpsellVariant", 1)
			else
				Diag:reportCounter("UAGamepassRobuxUpsellControl", 1)
			end
		end

		if p1.props.gamepassRobuxUpsellEnabled then
			local networking = p1.props.networking
			local pass = p1.props.pass
			local userRobux = p1.props.userRobux
			local purchasePass = p1.props.purchasePass
			local t1 = {
				expectedCurrency = Constants.Currency.Robux,
				expectedPrice = pass.price
			}

			p1.props.navigateDownToRobuxUpsell(pass.price, userRobux, pass.displayName, nil, function() -- line: 128
				-- upvalues: purchasePass (copy), networking (copy), pass (copy), t1 (copy)
				return purchasePass(networking, pass.productId, t1)
			end, pass.productId)

			return
		end

		p1.props.openPurchasePassInsufficientRobux()
	end
	function p1.onPurchaseFailedWhenOwned(p3) -- line: 136
		-- upvalues: FFlagLuaAppGamePassesDataHydrationMigrationEnabled (copy), DataHydration (copy), p1 (copy)
		if FFlagLuaAppGamePassesDataHydrationMigrationEnabled then
			DataHydration.Game.getGamePassStore(false).fetchPassesForUniverse(p1.props.universeId)
		else
			p1.props.apiFetchGamePasses(p1.props.networking, p1.props.universeId)
		end

		p1.props.setPurchaseErrorToast(p3)
		p1.props.closePrompt()
	end
	function p1.customPurchaseErrorHandler(p4) -- line: 151
		-- upvalues: p1 (copy), getPurchaseErrorTypeFromErrorResponse (copy), PurchaseErrors (copy)
		local v79 = false

		if p1.isMounted then
			local v80 = getPurchaseErrorTypeFromErrorResponse(p4)

			if v80 == PurchaseErrors.NotEnoughRobux then
				p1.onPurchaseFailedWithRobuxShortfall(p4)
				v79 = true
			end

			if v80 == PurchaseErrors.AlreadyOwn then
				p1.onPurchaseFailedWhenOwned(p4)
				v79 = true
			end
		end

		return v79
	end
	function p1.purchasePass() -- line: 168
		-- upvalues: p1 (copy), Constants (copy), Promise (copy), ToastType (copy)
		local networking = p1.props.networking
		local pass = p1.props.pass
		local productId = pass.productId
		local universeId = p1.props.universeId
		local t2 = {
			expectedCurrency = Constants.Currency.Robux,
			expectedPrice = pass.price
		}

		p1.props.purchasePass(networking, productId, t2, p1.customPurchaseErrorHandler, p1.props.economicRestrictionErrorHandler):finally(function(p5) -- line: 187
			-- upvalues: Promise (copy), p1 (copy), networking (copy), universeId (copy), ToastType (copy)
			if p5 ~= Promise.Status.Rejected and p1.isMounted then
				p1.props.apiFetchGamePasses(networking, universeId)

				local localization = p1.props.localization
				local v110 = localization:Format("Feature.AccountSecurityPrompt.Header.Success")
				local v111 = localization:Format("Feature.Catalog.Label.Purchased")

				p1.props.setCurrentToastMessage(ToastType.PurchaseMessage, v110, v111, true)
				p1.props.closePrompt()
			end
		end)
	end
end
function v48.render(p6) -- line: 210
	-- upvalues: RetrievalStatus (copy), withStyle (copy), withLocalization (copy), NumberLocalization (copy), Roact (copy), AlertWindow (copy)
	local containerWidth = p6.props.containerWidth
	local purchaseStatus = p6.props.purchaseStatus
	local closePrompt = p6.props.closePrompt
	local localization = p6.props.localization
	local pass = p6.props.pass
	local displayName = pass.displayName
	local name = pass.creator.name
	local price = pass.price
	local v61 = purchaseStatus == RetrievalStatus.Fetching

	return withStyle(function(p7) -- line: 221
		-- upvalues: withLocalization (copy), displayName (copy), name (copy), NumberLocalization (copy), price (copy), localization (copy), Roact (copy), AlertWindow (copy), containerWidth (copy), p6 (copy), v61 (copy), closePrompt (copy)
		return withLocalization({
			buyItem = "IAPExperience.PurchasePrompt.Title.BuyItem",
			buy = "Feature.Catalog.Action.Buy",
			message = {
				"Feature.Catalog.Label.PurchaseConfirmation",
				itemName = displayName,
				creatorName = name,
				itemPrice = NumberLocalization.localize(price, localization:GetLocale())
			}
		})(function(p8) -- line: 231
			-- upvalues: Roact (copy), AlertWindow (copy), containerWidth (copy), p7 (copy), p6 (copy), v61 (copy), closePrompt (copy)
			return Roact.createElement(AlertWindow, {
				hasCancelButton = true,
				containerWidth = containerWidth,
				titleText = p8.buyItem,
				titleFont = p7.Font.Header1.Font,
				messageText = p8.message,
				messageFont = p7.Font.Body.Font,
				buttonFont = p7.Font.Header2.Font,
				confirmButtonText = p8.buy,
				onConfirm = p6.purchasePass,
				isConfirming = v61,
				onCancel = closePrompt
			})
		end)
	end)
end
function v48.didMount(p9) -- line: 249
	-- upvalues: FFlagAddUnifiedPurchaseFlowTTIToEDP (copy), getTTIEventName (copy), ProductPurchaseSurface (copy), TimeToInteractiveTracker (copy)
	p9.isMounted = true

	if FFlagAddUnifiedPurchaseFlowTTIToEDP then
		local v63 = getTTIEventName(ProductPurchaseSurface.EDP)

		TimeToInteractiveTracker.trackEnd(v63)
	end
end
function v48.willUnmount(p10) -- line: 257
	p10.isMounted = false
end

local v49 = RoactRodux.connect(function(p11, p12) -- line: 261
	-- upvalues: PurchaseGamePass (copy)
	return {
		purchaseStatus = PurchaseGamePass.GetPostingStatus(p11, p12.pass.productId),
		userRobux = p11.UserRobux[p11.LocalUserId]
	}
end, function(p13) -- line: 266
	-- upvalues: SetCurrentToastMessage (copy), OpenCentralOverlayForPurchasePassInsufficientRobux (copy), CloseCentralOverlay (copy), NavigateDownToRobuxUpsell (copy), RobuxUpsellTriggerContext (copy), PurchaseGamePass (copy), parseEconomicRestrictionsFailureReason (copy), parseEconomicRestrictionsExpirationTimeInMinutes (copy), default (copy), UniversalEconomicRestrictionsCounter (copy), EconomicRestrictionsSurface (copy), OpenCentralOverlayForEconomicRestrictionPrompt (copy), FFlagLuaAppGamePassesDataHydrationMigrationEnabled (copy), ApiFetchGamePasses (copy), SetPurchaseErrorToast (copy)
	return {
		setCurrentToastMessage = function(p14, p15, p16, p17) -- line: 268
			-- upvalues: p13 (copy), SetCurrentToastMessage (copy)
			return p13(SetCurrentToastMessage({
				toastType = p14,
				toastMessage = p15,
				toastSubMessage = p16,
				isLocalized = p17
			}))
		end,
		openPurchasePassInsufficientRobux = function() -- line: 276
			-- upvalues: p13 (copy), OpenCentralOverlayForPurchasePassInsufficientRobux (copy)
			return p13(OpenCentralOverlayForPurchasePassInsufficientRobux())
		end,
		navigateDownToRobuxUpsell = function(n1: number, n2: number, s1: string, s2: string, p18: ((...any) -> ...any), s3: string?) -- line: 279
			-- upvalues: p13 (copy), CloseCentralOverlay (copy), NavigateDownToRobuxUpsell (copy), RobuxUpsellTriggerContext (copy)
			p13(CloseCentralOverlay())

			return p13(NavigateDownToRobuxUpsell(RobuxUpsellTriggerContext.UAGamepass, n1, n2, s1, s2, p18, s3))
		end,
		purchasePass = function(p19, p20, p21, p22, p23) -- line: 300
			-- upvalues: p13 (copy), PurchaseGamePass (copy)
			return p13(PurchaseGamePass.Post(p19, p20, p21, p22, p23))
		end,
		economicRestrictionErrorHandler = function(p24) -- line: 317
			-- upvalues: parseEconomicRestrictionsFailureReason (copy), parseEconomicRestrictionsExpirationTimeInMinutes (copy), default (copy), UniversalEconomicRestrictionsCounter (copy), EconomicRestrictionsSurface (copy), p13 (copy), CloseCentralOverlay (copy), OpenCentralOverlayForEconomicRestrictionPrompt (copy)
			local v103 = parseEconomicRestrictionsFailureReason(p24)
			local v104 = parseEconomicRestrictionsExpirationTimeInMinutes(p24)

			default:logRobloxTelemetryCounter(UniversalEconomicRestrictionsCounter, 1, {
				surface = EconomicRestrictionsSurface.Gamepass,
				failureReason = v103
			})
			p13(CloseCentralOverlay())

			return p13(OpenCentralOverlayForEconomicRestrictionPrompt(v103, v104))
		end,
		closePrompt = function() -- line: 327
			-- upvalues: p13 (copy), CloseCentralOverlay (copy)
			return p13(CloseCentralOverlay())
		end,
		apiFetchGamePasses = not FFlagLuaAppGamePassesDataHydrationMigrationEnabled and function(p25, p26) -- line: 332
			-- upvalues: p13 (copy), ApiFetchGamePasses (copy)
			return p13(ApiFetchGamePasses(p25, p26))
		end or nil,
		setPurchaseErrorToast = function(p27) -- line: 335
			-- upvalues: p13 (copy), SetPurchaseErrorToast (copy)
			return p13(SetPurchaseErrorToast(p27))
		end
	}
end)(v48)
local v50 = RoactServices.connect({
	networking = RoactNetworking,
	localization = RoactLocalization,
	analytics = RoactAnalytics
})(v49)

if GamepassRobuxUpsellIXPTest.isEnabled() then
	v50 = RoactAppExperiment.connectUserLayer({ AppUserLayers.GamepassRobuxUpsellLayer }, function(p28, _) -- line: 350
		-- upvalues: GamepassRobuxUpsellIXPTest (copy)
		return {
			gamepassRobuxUpsellEnabled = GamepassRobuxUpsellIXPTest.isUserEnrolled(p28)
		}
	end, false)(v50)
end

return v50
