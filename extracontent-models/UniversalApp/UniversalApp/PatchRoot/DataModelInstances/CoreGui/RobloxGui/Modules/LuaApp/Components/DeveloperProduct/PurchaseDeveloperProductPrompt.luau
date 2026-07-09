local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(Modules.Common.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local Constants = require(Modules.LuaApp.Constants)
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local withLocalization = require(Modules.LuaApp.withLocalization)
local withStyle = UIBlox.Style.withStyle
local t = require(CorePackages.Packages.t)
local Promise = require(CorePackages.Packages.Promise)
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local NumberLocalization = require(CorePackages.Workspace.Packages.Localization).NumberLocalization
local IAPExperience = require(CorePackages.Workspace.Packages.IAPExperience)
local UniversalEconomicRestrictionsCounter = IAPExperience.Counters.EconomicRestrictionsCounter.UniversalEconomicRestrictionsCounter
local EconomicRestrictionsSurface = IAPExperience.Counters.EconomicRestrictionsCounter.EconomicRestrictionsSurface
local parseEconomicRestrictionsFailureReason = IAPExperience.Utility.parseEconomicRestrictionsFailureReason
local parseEconomicRestrictionsExpirationTimeInMinutes = IAPExperience.Utility.parseEconomicRestrictionsExpirationTimeInMinutes
local default = require(CorePackages.Workspace.Packages.LoggingProtocol).default
local AlertWindow = require(Modules.LuaApp.Components.AlertWindow)
local ApiFetchGameDeveloperProducts = require(Modules.LuaApp.Thunks.DeveloperProduct.ApiFetchGameDeveloperProducts)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local PurchaseDeveloperProduct = require(Modules.LuaApp.Thunks.DeveloperProduct.PurchaseDeveloperProduct)
local OpenCentralOverlayForPurchaseDeveloperProductPendingProductsLimitExceeded = require(Modules.LuaApp.Thunks.DeveloperProduct.OpenCentralOverlayForPurchaseDeveloperProductPendingProductsLimitExceeded)
local OpenCentralOverlayForPurchaseDeveloperProductSuccess = require(Modules.LuaApp.Thunks.DeveloperProduct.OpenCentralOverlayForPurchaseDeveloperProductSuccess)
local OpenCentralOverlayForEconomicRestrictionPrompt = require(Modules.LuaApp.Thunks.Fraud.OpenCentralOverlayForEconomicRestrictionPrompt)
local v29 = Roact.PureComponent:extend("PurchaseDeveloperProductPrompt")

v29.validateProps = t.strictInterface({
	universeId = t.string,
	developerProduct = t.table,
	containerWidth = t.number,
	defaultChildRef = t.optional(t.any),
	focusController = t.optional(t.any),
	closeCentralOverlayThunk = t.optional(t.callback),
	localization = t.any,
	networking = t.callback,
	purchaseStatus = t.optional(t.any),
	creatorName = t.optional(t.string),
	rootPlaceId = t.optional(t.string),
	localUserId = t.optional(t.string),
	openPendingProductsLimitExceededPrompt = t.callback,
	openPurchaseDeveloperProductSuccessPrompt = t.callback,
	purchaseDeveloperProduct = t.callback,
	closePrompt = t.callback,
	apiFetchGameDeveloperProducts = t.callback,
	economicRestrictionErrorHandler = t.callback
})

function v29.init(p1) -- line: 72
	-- upvalues: Constants (copy), Promise (copy)
	function p1.customPurchaseErrorHandler(p2) -- line: 73
		-- upvalues: p1 (copy)
		if p2.errorCode == "PendingProductsLimitExceeded" then
			p1.props.openPendingProductsLimitExceededPrompt()
		end
	end
	function p1.purchaseDeveloperProduct() -- line: 79
		-- upvalues: p1 (copy), Constants (copy), Promise (copy)
		local networking = p1.props.networking
		local developerProduct = p1.props.developerProduct
		local productId = developerProduct.productId
		local universeId = p1.props.universeId
		local t1 = {
			expectedCurrency = Constants.Currency.Robux,
			expectedPrice = developerProduct.priceInRobux,
			saleLocationId = universeId
		}

		p1.props.purchaseDeveloperProduct(networking, productId, t1, p1.customPurchaseErrorHandler, p1.props.economicRestrictionErrorHandler):finally(function(p3) -- line: 99
			-- upvalues: Promise (copy), p1 (copy), networking (copy), universeId (copy), developerProduct (copy)
			if p3 ~= Promise.Status.Rejected and p1.isMounted then
				p1.props.apiFetchGameDeveloperProducts(networking, universeId, p1.props.rootPlaceId, p1.props.localUserId)
				p1.props.closePrompt()
				p1.props.openPurchaseDeveloperProductSuccessPrompt(developerProduct.name)
			end
		end)
	end
end
function v29.render(p4) -- line: 117
	-- upvalues: RetrievalStatus (copy), withStyle (copy), withLocalization (copy), NumberLocalization (copy), Roact (copy), AlertWindow (copy)
	local containerWidth = p4.props.containerWidth
	local purchaseStatus = p4.props.purchaseStatus
	local closePrompt = p4.props.closePrompt
	local localization = p4.props.localization
	local developerProduct = p4.props.developerProduct
	local name = developerProduct.name
	local creatorName = p4.props.creatorName
	local priceInRobux = developerProduct.priceInRobux
	local v41 = purchaseStatus == RetrievalStatus.Fetching

	return withStyle(function(p5) -- line: 128
		-- upvalues: withLocalization (copy), name (copy), creatorName (copy), NumberLocalization (copy), priceInRobux (copy), localization (copy), Roact (copy), AlertWindow (copy), containerWidth (copy), p4 (copy), v41 (copy), closePrompt (copy)
		return withLocalization({
			buyItem = "IAPExperience.PurchasePrompt.Title.BuyItem",
			buy = "Feature.Catalog.Action.Buy",
			message = {
				"Feature.Catalog.Label.PurchaseConfirmation",
				itemName = name,
				creatorName = creatorName,
				itemPrice = NumberLocalization.localize(priceInRobux, localization:GetLocale())
			}
		})(function(p6) -- line: 138
			-- upvalues: Roact (copy), AlertWindow (copy), containerWidth (copy), p5 (copy), p4 (copy), v41 (copy), closePrompt (copy)
			return Roact.createElement(AlertWindow, {
				hasCancelButton = true,
				containerWidth = containerWidth,
				titleText = p6.buyItem,
				titleFont = p5.Font.Header1.Font,
				messageText = p6.message,
				messageFont = p5.Font.Body.Font,
				buttonFont = p5.Font.Header2.Font,
				confirmButtonText = p6.buy,
				onConfirm = p4.purchaseDeveloperProduct,
				isConfirming = v41,
				onCancel = closePrompt
			})
		end)
	end)
end
function v29.didMount(p7) -- line: 156
	p7.isMounted = true
end
function v29.willUnmount(p8) -- line: 160
	p8.isMounted = false
end

local v30 = RoactRodux.connect(function(p9, p10) -- line: 164
	-- upvalues: PurchaseDeveloperProduct (copy)
	return {
		purchaseStatus = PurchaseDeveloperProduct.GetPostingStatus(p9, p10.developerProduct.productId),
		creatorName = p9.GameDetails[p10.universeId].creator.name,
		rootPlaceId = p9.GameDetails[p10.universeId].rootPlaceId,
		localUserId = p9.LocalUserId
	}
end, function(p11) -- line: 171
	-- upvalues: OpenCentralOverlayForPurchaseDeveloperProductPendingProductsLimitExceeded (copy), OpenCentralOverlayForPurchaseDeveloperProductSuccess (copy), PurchaseDeveloperProduct (copy), CloseCentralOverlay (copy), ApiFetchGameDeveloperProducts (copy), parseEconomicRestrictionsFailureReason (copy), parseEconomicRestrictionsExpirationTimeInMinutes (copy), default (copy), UniversalEconomicRestrictionsCounter (copy), EconomicRestrictionsSurface (copy), OpenCentralOverlayForEconomicRestrictionPrompt (copy)
	return {
		openPendingProductsLimitExceededPrompt = function() -- line: 173
			-- upvalues: p11 (copy), OpenCentralOverlayForPurchaseDeveloperProductPendingProductsLimitExceeded (copy)
			return p11(OpenCentralOverlayForPurchaseDeveloperProductPendingProductsLimitExceeded())
		end,
		openPurchaseDeveloperProductSuccessPrompt = function(p12) -- line: 176
			-- upvalues: p11 (copy), OpenCentralOverlayForPurchaseDeveloperProductSuccess (copy)
			return p11(OpenCentralOverlayForPurchaseDeveloperProductSuccess(p12))
		end,
		purchaseDeveloperProduct = function(p13, p14, p15, p16, p17) -- line: 179
			-- upvalues: p11 (copy), PurchaseDeveloperProduct (copy)
			return p11(PurchaseDeveloperProduct.Post(p13, p14, p15, p16, p17))
		end,
		closePrompt = function() -- line: 196
			-- upvalues: p11 (copy), CloseCentralOverlay (copy)
			return p11(CloseCentralOverlay())
		end,
		apiFetchGameDeveloperProducts = function(p18, p19, p20, p21) -- line: 199
			-- upvalues: p11 (copy), ApiFetchGameDeveloperProducts (copy)
			return p11(ApiFetchGameDeveloperProducts(p18, p19, p20, p21))
		end,
		economicRestrictionErrorHandler = function(p22) -- line: 202
			-- upvalues: parseEconomicRestrictionsFailureReason (copy), parseEconomicRestrictionsExpirationTimeInMinutes (copy), default (copy), UniversalEconomicRestrictionsCounter (copy), EconomicRestrictionsSurface (copy), p11 (copy), CloseCentralOverlay (copy), OpenCentralOverlayForEconomicRestrictionPrompt (copy)
			local v65 = parseEconomicRestrictionsFailureReason(p22)
			local v66 = parseEconomicRestrictionsExpirationTimeInMinutes(p22)

			default:logRobloxTelemetryCounter(UniversalEconomicRestrictionsCounter, 1, {
				surface = EconomicRestrictionsSurface.DeveloperProduct,
				failureReason = v65
			})
			p11(CloseCentralOverlay())

			return p11(OpenCentralOverlayForEconomicRestrictionPrompt(v65, v66))
		end
	}
end)(v29)

return (RoactServices.connect({
	networking = RoactNetworking,
	localization = RoactLocalization
})(v30))
