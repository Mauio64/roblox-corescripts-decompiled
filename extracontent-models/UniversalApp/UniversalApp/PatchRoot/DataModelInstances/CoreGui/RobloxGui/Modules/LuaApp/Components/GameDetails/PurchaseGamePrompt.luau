local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Functional = require(CorePackages.Workspace.Packages.AppCommonLib).Functional
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactNetworking
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local RetrievalStatus = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus
local ToastRodux = require(CorePackages.Workspace.Packages.ToastRodux)
local ToastType = ToastRodux.Enums.ToastType
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local FetchGamePlayabilityAndProductInfo = require(CorePackages.Workspace.Packages.GameDetailRodux).FetchGamePlayabilityAndProductInfo
local CloseCentralOverlay = require(CorePackages.Workspace.Packages.CentralOverlay).Thunks.CloseCentralOverlay
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Constants = require(Modules.LuaApp.Constants)
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local getPurchaseErrorTypeFromErrorResponse = require(Modules.LuaApp.getPurchaseErrorTypeFromErrorResponse)
local ThemeContext_DEPRECATED = require(Modules.LuaApp.ThemeContext_DEPRECATED)
local withTheme_DEPRECATED = require(Modules.LuaApp.withTheme_DEPRECATED)
local PurchaseErrors = require(Modules.LuaApp.Enum.PurchaseErrors)
local AlertWindow = require(Modules.LuaApp.Components.AlertWindow)
local OpenCentralOverlayForPurchaseGameRobuxShortfall = require(Modules.LuaApp.Thunks.OpenCentralOverlayForPurchaseGameRobuxShortfall)
local PurchaseProduct = require(Modules.LuaApp.Thunks.PurchaseProduct)
local SetPurchaseErrorToast = require(Modules.LuaApp.Thunks.SetPurchaseErrorToast)
local GetFFlagLuaAppUseWithLocalization = require(Modules.LuaApp.Flags.GetFFlagLuaAppUseWithLocalization)
local FFlagUseNavigationSelectors = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseNavigationSelectors
local FFlagSignalsNavP3fGameDetails = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3fGameDetails
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v31 = if not FFlagSignalsNavP3fGameDetails then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local v32 = Roact.PureComponent:extend("PurchaseGamePrompt")

v32.defaultProps = {
	expectedCurrency = Constants.Currency.Robux
}

function v32.init(p1) -- line: 48
	-- upvalues: getPurchaseErrorTypeFromErrorResponse (copy), PurchaseErrors (copy), GetFFlagLuaAppUseWithLocalization (copy), ToastType (copy)
	function p1.onPurchaseFailedWithRobuxShortfall(p2) -- line: 49
		-- upvalues: p1 (copy)
		local gameName = p1.props.gameName
		local shortfallPrice = p2.shortfallPrice
		local appTheme = p1.props.appTheme
		local currentPage = p1.props.currentPage

		p1.props.openPurchaseGameRobuxShortfallPrompt(gameName, shortfallPrice, appTheme, { currentPage })
	end
	function p1.onPurchaseFailedWhenOwned(p3) -- line: 59
		-- upvalues: p1 (copy)
		p1.props.fetchPlayabilityAndProductInfo(p1.props.networking, p1.props.universeId)
		p1.props.setPurchaseErrorToast(p3)
		p1.props.closePrompt()
	end
	function p1.customPurchaseErrorHandler(p4) -- line: 71
		-- upvalues: getPurchaseErrorTypeFromErrorResponse (copy), PurchaseErrors (copy), p1 (copy)
		local v65 = false
		local v66 = getPurchaseErrorTypeFromErrorResponse(p4)

		if v66 == PurchaseErrors.NotEnoughRobux then
			p1.onPurchaseFailedWithRobuxShortfall(p4)
			v65 = true
		end

		if v66 == PurchaseErrors.AlreadyOwn then
			p1.onPurchaseFailedWhenOwned(p4)
			v65 = true
		end

		return v65
	end
	function p1.purchaseGame() -- line: 87
		-- upvalues: p1 (copy), GetFFlagLuaAppUseWithLocalization (copy), ToastType (copy)
		local networking = p1.props.networking
		local productId = p1.props.productId
		local t1 = {
			expectedCurreny = p1.props.expectedCurrency,
			expectedPrice = p1.props.price,
			expectedSellerId = p1.props.sellerId
		}

		p1.props.purchaseGame(networking, productId, t1, p1.customPurchaseErrorHandler):andThen(function() -- line: 106
			-- upvalues: p1 (copy), networking (copy), GetFFlagLuaAppUseWithLocalization (copy), ToastType (copy)
			p1.props.fetchPlayabilityAndProductInfo(networking, p1.props.universeId)

			if GetFFlagLuaAppUseWithLocalization() then
				local t2 = {
					"Feature.Toast.Message.PurchaseMessage.SuccessV3",
					{
						gameName = p1.props.gameName,
						price = p1.props.price
					}
				}

				p1.props.setCurrentToastMessage(ToastType.PurchaseMessage, "Feature.Toast.Heading.PurchaseMessage.Success", t2, false)
			else
				local localization = p1.props.localization
				local v88 = localization:Format("Feature.Toast.Heading.PurchaseMessage.Success")
				local v89 = localization:Format("Feature.Toast.Message.PurchaseMessage.SuccessV3", {
					gameName = p1.props.gameName,
					price = p1.props.price
				})

				p1.props.setCurrentToastMessage(ToastType.PurchaseMessage, v88, v89, true)
			end

			p1.props.closePrompt()
		end)
	end
end
function v32.didMount(p5) -- line: 134
	-- upvalues: Functional (copy)
	local pageFilter = p5.props.pageFilter
	local currentPage = p5.props.currentPage
	local closePrompt = p5.props.closePrompt

	if pageFilter and not Functional.Find(pageFilter, currentPage) then
		closePrompt()
	end
end
function v32.render(p6) -- line: 144
	-- upvalues: RetrievalStatus (copy), Roact (copy), ThemeContext_DEPRECATED (copy), AlertWindow (copy), GetFFlagLuaAppUseWithLocalization (copy), withLocalization (copy)
	local appTheme = p6.props.appTheme
	local containerWidth = p6.props.containerWidth
	local purchaseStatus = p6.props.purchaseStatus
	local closePrompt = p6.props.closePrompt
	local localization = p6.props.localization
	local gameName = p6.props.gameName
	local price = p6.props.price
	local v49 = purchaseStatus == RetrievalStatus.Fetching

	local function v50(p7) -- line: 154
		-- upvalues: Roact (copy), ThemeContext_DEPRECATED (copy), appTheme (copy), AlertWindow (copy), containerWidth (copy), p6 (copy), v49 (copy), closePrompt (copy)
		return Roact.createElement(ThemeContext_DEPRECATED.Provider, {
			value = appTheme
		}, {
			AlertWindow = Roact.createElement(AlertWindow, {
				hasCancelButton = true,
				containerWidth = containerWidth,
				titleText = p7.titleText,
				titleFont = appTheme.GameDetails.Text.BoldFont,
				messageText = p7.messageText,
				messageFont = appTheme.GameDetails.Text.Font,
				buttonFont = appTheme.GameDetails.Text.Font,
				confirmButtonText = p7.confirmButtonText,
				onConfirm = p6.purchaseGame,
				isConfirming = v49,
				onCancel = closePrompt
			})
		})
	end

	if GetFFlagLuaAppUseWithLocalization() then
		return withLocalization({
			titleText = "Feature.GameDetails.Heading.PurchaseGame",
			confirmButtonText = "Feature.GameDetails.Action.Unlock",
			messageText = {
				"Feature.GameDetails.Message.PurchaseGameV2",
				gameName = gameName,
				X = price
			}
		})(v50)
	end

	return v50({
		titleText = localization:Format("Feature.GameDetails.Heading.PurchaseGame"),
		messageText = localization:Format("Feature.GameDetails.Message.PurchaseGameV2", {
			gameName = gameName,
			X = price
		}),
		confirmButtonText = localization:Format("Feature.GameDetails.Action.Unlock")
	})
end

local v33 = RoactRodux.connect(function(p8, p9) -- line: 194
	-- upvalues: FFlagSignalsNavP3fGameDetails (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), PurchaseProduct (copy)
	local v53 = if not FFlagSignalsNavP3fGameDetails then if not FFlagUseNavigationSelectors then p8.Navigation.history[#p8.Navigation.history] else Selectors.selectCurrentLegacyRoute(p8) else nil

	return {
		purchaseStatus = PurchaseProduct.GetPostingStatus(p8, p9.productId),
		currentPage = if not FFlagSignalsNavP3fGameDetails then v53[#v53].name else nil
	}
end, function(p10) -- line: 203
	-- upvalues: SetCurrentToastMessage (copy), OpenCentralOverlayForPurchaseGameRobuxShortfall (copy), PurchaseProduct (copy), CloseCentralOverlay (copy), FetchGamePlayabilityAndProductInfo (copy), SetPurchaseErrorToast (copy)
	return {
		setCurrentToastMessage = function(p11, p12, p13, p14) -- line: 205
			-- upvalues: p10 (copy), SetCurrentToastMessage (copy)
			return p10(SetCurrentToastMessage({
				toastType = p11,
				toastMessage = p12,
				toastSubMessage = p13,
				isLocalized = p14
			}))
		end,
		openPurchaseGameRobuxShortfallPrompt = function(p15, p16, p17, p18) -- line: 213
			-- upvalues: p10 (copy), OpenCentralOverlayForPurchaseGameRobuxShortfall (copy)
			return p10(OpenCentralOverlayForPurchaseGameRobuxShortfall(p15, p16, p17, p18))
		end,
		purchaseGame = function(p19, p20, p21, p22) -- line: 218
			-- upvalues: p10 (copy), PurchaseProduct (copy)
			return p10(PurchaseProduct.Post(p19, p20, p21, p22))
		end,
		closePrompt = function() -- line: 221
			-- upvalues: p10 (copy), CloseCentralOverlay (copy)
			return p10(CloseCentralOverlay())
		end,
		fetchPlayabilityAndProductInfo = function(p23, p24) -- line: 224
			-- upvalues: p10 (copy), FetchGamePlayabilityAndProductInfo (copy)
			return p10(FetchGamePlayabilityAndProductInfo.Fetch(p23, p24))
		end,
		setPurchaseErrorToast = function(p25) -- line: 227
			-- upvalues: p10 (copy), SetPurchaseErrorToast (copy)
			return p10(SetPurchaseErrorToast(p25))
		end
	}
end)(v32)

if FFlagSignalsNavP3fGameDetails then
	local v34 = v33

	function v33(p26) -- line: 235
		-- upvalues: v31 (copy), useSignalState (copy), Roact (copy), v34 (copy), Cryo (copy)
		local v56 = v31(false)
		local v57 = useSignalState(v56.getCurrentPage)

		return Roact.createElement(v34, Cryo.Dictionary.union(p26, {
			currentPage = v57.name
		}))
	end
end

local v35 = withTheme_DEPRECATED(v33)

return (RoactServices.connect({
	networking = RoactNetworking,
	localization = RoactLocalization
})(v35))
