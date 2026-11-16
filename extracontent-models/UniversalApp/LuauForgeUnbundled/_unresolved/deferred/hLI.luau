local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local functional = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Functional
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/Http").Enum.RetrievalStatus
local module = require("@luauforge/bundled/dwC")
local toastType = module.Enums.ToastType
local setCurrentToastMessage = module.Actions.SetCurrentToastMessage

local fetchGamePlayabilityAndProductInfo = require("@luauforge/bundled/dyi").FetchGamePlayabilityAndProductInfo
local closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/CentralOverlay").Thunks.CloseCentralOverlay
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors

local module2 = require("@luauforge/bundled/dwA")
local module3 = require("@luauforge/bundled/edB")
local module4 = require("@luauforge/deferred/fva")
local module5 = require("@luauforge/bundled/fNP")
local module6 = require("@luauforge/bundled/fNO")
local module7 = require("@luauforge/deferred/fvb")
local module8 = require("@luauforge/deferred/hLH")

local module9 = require("@luauforge/deferred/hLJ")
local module10 = require("@luauforge/deferred/hLK")
local module11 = require("@luauforge/deferred/fuZ")

local module12 = require("@luauforge/bundled/edD")
local fFlagUseNavigationSelectors = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseNavigationSelectors
local fFlagSignalsNavP3fGameDetails = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3fGameDetails
local getLegacyNavigationStore

if fFlagSignalsNavP3fGameDetails then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local extended = Roact.PureComponent:extend("PurchaseGamePrompt")

extended.defaultProps = { expectedCurrency = module2.Currency.Robux }

function extended:init()
	function self.onPurchaseFailedWithRobuxShortfall(p2)
		local gameName = self.props.gameName
		local shortfallPrice = p2.shortfallPrice
		local appTheme = self.props.appTheme

		local v5 = if fFlagSignalsNavP3fGameDetails then getLegacyNavigationStore(false).getCurrentPage(false).name else self.props.currentPage
		self.props.openPurchaseGameRobuxShortfallPrompt(gameName, shortfallPrice, appTheme, { v5 })
	end

	function self.onPurchaseFailedWhenOwned(p2)
		self.props.fetchPlayabilityAndProductInfo(self.props.networking, self.props.universeId)

		self.props.setPurchaseErrorToast(p2)

		self.props.closePrompt()
	end

	function self.customPurchaseErrorHandler(p2)
		local v5 = module4(p2)
		local v6

		if v5 == module7.NotEnoughRobux then
			self.onPurchaseFailedWithRobuxShortfall(p2)
			v6 = true
		else
			v6 = false
		end

		if v5 == module7.AlreadyOwn then
			self.onPurchaseFailedWhenOwned(p2)
			v6 = true
		end

		return v6
	end

	function self.purchaseGame()
		local networking = self.props.networking
		local productId = self.props.productId

		local v5 = {
			expectedCurreny = self.props.expectedCurrency,
			expectedPrice = self.props.price,
			expectedSellerId = self.props.sellerId
		}

		self.props.purchaseGame(networking, productId, v5, self.customPurchaseErrorHandler):andThen(function()
			self.props.fetchPlayabilityAndProductInfo(networking, self.props.universeId)

			if module12() then
				local v6 = {
					"Feature.Toast.Message.PurchaseMessage.SuccessV3",
					{ gameName = self.props.gameName, price = self.props.price }
				}

				self.props.setCurrentToastMessage(
					toastType.PurchaseMessage,
					"Feature.Toast.Heading.PurchaseMessage.Success",
					v6,
					false
				)
			else
				local localization = self.props.localization
				local formatted = localization:Format("Feature.Toast.Heading.PurchaseMessage.Success")
				local formatted2 = localization:Format("Feature.Toast.Message.PurchaseMessage.SuccessV3", {
					gameName = self.props.gameName,
					price = self.props.price
				})

				self.props.setCurrentToastMessage(toastType.PurchaseMessage, formatted, formatted2, true)
			end

			self.props.closePrompt()
		end)
	end
end

function extended.didMount(p2)
	local pageFilter = p2.props.pageFilter
	local v5

	if fFlagSignalsNavP3fGameDetails then
		v5 = getLegacyNavigationStore(false).getCurrentPage(false).name
	else
		v5 = p2.props.currentPage
	end

	local closePrompt = p2.props.closePrompt

	if pageFilter and not functional.Find(pageFilter, v5) then
		closePrompt()
	end
end

function extended.render(p2)
	local appTheme = p2.props.appTheme
	local containerWidth = p2.props.containerWidth
	local purchaseStatus = p2.props.purchaseStatus
	local closePrompt = p2.props.closePrompt
	local localization = p2.props.localization
	local gameName = p2.props.gameName
	local price = p2.props.price
	local v5 = purchaseStatus == retrievalStatus.Fetching

	local function fn(props)
		return Roact.createElement(module5.Provider, { value = appTheme }, {
			AlertWindow = Roact.createElement(module8, {
				containerWidth = containerWidth,
				titleText = props.titleText,
				titleFont = appTheme.GameDetails.Text.BoldFont,
				messageText = props.messageText,
				messageFont = appTheme.GameDetails.Text.Font,
				buttonFont = appTheme.GameDetails.Text.Font,
				confirmButtonText = props.confirmButtonText,
				onConfirm = p2.purchaseGame,
				isConfirming = v5,
				hasCancelButton = true,
				onCancel = closePrompt
			})
		})
	end

	if module12() then
		return withLocalization({
			titleText = "Feature.GameDetails.Heading.PurchaseGame",
			messageText = {
				"Feature.GameDetails.Message.PurchaseGameV2",
				gameName = gameName,
				X = price
			},
			confirmButtonText = "Feature.GameDetails.Action.Unlock"
		})(fn)
	end

	return fn({
		titleText = localization:Format("Feature.GameDetails.Heading.PurchaseGame"),
		messageText = localization:Format("Feature.GameDetails.Message.PurchaseGameV2", {
			gameName = gameName,
			X = price
		}),
		confirmButtonText = localization:Format("Feature.GameDetails.Action.Unlock")
	})
end

local v5 = module6((RoactRodux.connect(function(p2, p3)
	local v6

	if not fFlagSignalsNavP3fGameDetails then
		if fFlagUseNavigationSelectors then
			v6 = selectors.selectCurrentLegacyRoute(p2)
		else
			v6 = p2.Navigation.history[#p2.Navigation.history]
		end
	end

	local v7 = {
		purchaseStatus = module10.GetPostingStatus(p2, p3.productId),
		currentPage = 0
	}
	local v8 = if not fFlagSignalsNavP3fGameDetails then v6[#v6].name else nil
	v7.currentPage = v8
	return v7
end, function(callback)
	return {
		setCurrentToastMessage = function(p2, p3, p4, p5)
			return callback(setCurrentToastMessage({
				toastType = p2,
				toastMessage = p3,
				toastSubMessage = p4,
				isLocalized = p5
			}))
		end,
		openPurchaseGameRobuxShortfallPrompt = function(p2, p3, p4, p5)
			return callback(module9(p2, p3, p4, p5))
		end,
		purchaseGame = function(p2, p3, p4, p5)
			return callback(module10.Post(p2, p3, p4, p5))
		end,
		closePrompt = function()
			return callback(closeCentralOverlay())
		end,
		fetchPlayabilityAndProductInfo = function(p2, p3)
			return callback(fetchGamePlayabilityAndProductInfo.Fetch(p2, p3))
		end,
		setPurchaseErrorToast = function(p2)
			return callback(module11(p2))
		end
	}
end)(extended)))

return (roactServices.connect({ networking = roactNetworking, localization = module3 })(v5))
