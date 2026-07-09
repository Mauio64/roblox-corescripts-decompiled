local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local UIBlox = require(ParentParentParent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Foundation = require(ParentParentParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local LocalizationService = game:GetService("LocalizationService")
local Localization = require(ParentParentParent.AppLocales).Localization
local Localization2 = require(ParentParentParent.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local useLocalization = Localization2.Hooks.useLocalization
local ProductDetails = require(ParentParent.Generic.ProductDetails)
local RobuxUpsellModalTitle = require(script.Parent.RobuxUpsellModalTitle)
local RobuxUpsellModalFooter = require(script.Parent.RobuxUpsellModalFooter)
local RobuxUpsellModalUpsellDetailsWithBonus = require(script.Parent.RobuxUpsellModalUpsellDetailsWithBonus)
local formatNumber = require(ParentParent.Utility.formatNumber)
local logger = require(ParentParent.Utility.logger)
local getAppContext = require(ParentParent.Utility.getAppContext)
local default = require(ParentParentParent.LoggingProtocol).default
local SinglePackageUpsellCounter = require(ParentParent.Generic.Events.SinglePackageUpsellCounter)
local SinglePackageUpsellShownCounter = SinglePackageUpsellCounter.SinglePackageUpsellShownCounter
local SinglePackageUpsellModalClosedCounter = SinglePackageUpsellCounter.SinglePackageUpsellModalClosedCounter
local SinglePackageUpsellModalBuyClickedCounter = SinglePackageUpsellCounter.SinglePackageUpsellModalBuyClickedCounter

require(ParentParent.Enums.VirtualItemBadgeType)

local useDefaultFocusBehavior = require(ParentParentParent.ReactFocusNavigation).useDefaultFocusBehavior
local FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt = require(ParentParent.Flags.FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt)

local function MiddleContent(t1: {[any]: any}) -- line: 72
	-- upvalues: React (copy), View (copy), ProductDetails (copy), RobuxUpsellModalUpsellDetailsWithBonus (copy), FoundationText (copy), formatNumber (copy), LocalizationService (copy)
	return React.createElement(View, {
		tag = "col gap-xxlarge auto-y size-full-0 align-x-center align-y-center"
	}, {
		ProductDetails = React.createElement(ProductDetails, {
			layoutOrder = 1,
			isPortrait = t1.isPortrait,
			model = t1.product.model,
			itemIcon = t1.product.itemIcon,
			itemName = t1.product.itemName,
			itemRobuxCost = t1.product.itemRobuxCost,
			badgeType = t1.product.badgeType
		}),
		UpsellPackageDetails = if not t1.upsell.robuxPurchaseAmountBeforeBonus then React.createElement(View, {
			LayoutOrder = 2,
			tag = "row flex-between size-full-1400 align-y-center bg-surface-300 radius-medium padding-large stroke-system-contrast stroke-thick"
		}, {
			RobuxAmountContainer = React.createElement(View, {
				tag = "auto-xy row gap-small"
			}, {
				RobuxAmount = React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = "auto-xy text-title-large content-emphasis text-align-x-left",
					Text = utf8.char(57346) .. " " .. formatNumber(LocalizationService.RobloxLocaleId, t1.upsell.robuxPurchaseAmount)
				})
			}),
			RobuxPrice = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "auto-xy text-title-large content-emphasis text-align-x-right",
				Text = t1.upsell.robuxPurchaseCost or ""
			})
		}) else React.createElement(RobuxUpsellModalUpsellDetailsWithBonus, {
			layoutOrder = 2,
			priceString = t1.upsell.robuxPurchaseCost or "",
			robuxAmount = t1.upsell.robuxPurchaseAmountBeforeBonus,
			bonusAmount = t1.upsell.robuxPurchaseAmount - t1.upsell.robuxPurchaseAmountBeforeBonus
		})
	})
end
local function ButtonStackInfo(t2: {[any]: any}) -- line: 133
	-- upvalues: useLocalization (copy), FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt (copy), ButtonType (copy)
	local v35 = useLocalization({
		ButtonCancel = "IAPExperience.RobuxUpsell.Action.Cancel",
		LoadingText = "IAPExperience.RobuxUpsell.Text.Loading",
		BuyRobuxButton = not t2.buttons.opensBuyRobuxPage and "IAPExperience.RobuxUpsell.Action.BuyRobuxAndItem" or "IAPExperience.RobuxUpsell.Action.BuyRobux"
	})

	return {
		forcedFillDirection = Enum.FillDirection.Vertical,
		disableGamepadRefs = not not FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt or nil,
		buttons = if not t2.isQuest then {{
			buttonType = ButtonType.PrimaryContextual,
			props = {
				isDisabled = t2.buttons.buyItemDisabled,
				isDelayedInput = t2.buttons.buyItemisDelayedInput,
				enableInputDelayed = t2.buttons.buyItemEnableInputDelayed,
				onActivated = t2.buttons.buyItemActivated,
				text = v35.BuyRobuxButton,
				inputIcon = t2.buttons.buyItemControllerIcon,
				buttonRef = if not FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then nil else t2.buttons.buttonRef
			}
		}} else {{
			props = {
				onActivated = t2.buttons.cancelPurchaseActivated,
				text = v35.ButtonCancel,
				inputIcon = t2.buttons.cancelControllerIcon
			}
		}}
	}
end
local function RobuxUpsellModal(t3: {[any]: any}) -- line: 180
	-- upvalues: FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt (copy), useDefaultFocusBehavior (copy), React (copy), logger (copy), getAppContext (copy), default (copy), SinglePackageUpsellShownCounter (copy), SinglePackageUpsellModalClosedCounter (copy), SinglePackageUpsellModalBuyClickedCounter (copy), InteractiveAlert (copy), RobuxUpsellModalTitle (copy), MiddleContent (copy), ButtonStackInfo (copy), RobuxUpsellModalFooter (copy)
	local v37 = nil
	local v38 = nil

	if FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then
		v37, v38 = useDefaultFocusBehavior()
	end

	React.useEffect(function() -- line: 186
		-- upvalues: logger (copy), t3 (copy), getAppContext (copy), default (copy), SinglePackageUpsellShownCounter (copy)
		logger.debug({
			message = "Single Package Upsell Modal Shown",
			screenHeight = t3.screenSize.Y,
			screenWidth = t3.screenSize.X,
			portrait = t3.screenSize.X < t3.screenSize.Y,
			appContext = getAppContext(),
			buyRobuxVariant = if t3.buttons.opensBuyRobuxPage ~= nil then not t3.buttons.opensBuyRobuxPage and 2 or 1 else 0
		})
		default:logRobloxTelemetryCounter(SinglePackageUpsellShownCounter, 1, {
			screenHeight = t3.screenSize.Y,
			screenWidth = t3.screenSize.X,
			portrait = t3.screenSize.X < t3.screenSize.Y,
			appContext = getAppContext(),
			buyRobuxVariant = if t3.buttons.opensBuyRobuxPage ~= nil then not t3.buttons.opensBuyRobuxPage and 2 or 1 else 0
		})
	end, {})

	local function v39() -- line: 209
		-- upvalues: logger (copy), default (copy), SinglePackageUpsellModalClosedCounter (copy), getAppContext (copy), t3 (copy)
		logger.debug({
			message = "Single Package Upsell Modal Closed"
		})
		default:logRobloxTelemetryCounter(SinglePackageUpsellModalClosedCounter, 1, {
			appContext = getAppContext()
		})
		t3.buttons.cancelPurchaseActivated()
	end

	local buyItemActivated = t3.buttons.buyItemActivated

	function t3.buttons.buyItemActivated() -- line: 219
		-- upvalues: logger (copy), default (copy), SinglePackageUpsellModalBuyClickedCounter (copy), getAppContext (copy), buyItemActivated (copy)
		logger.debug({
			message = "Single Package Upsell Modal Buy Clicked"
		})
		default:logRobloxTelemetryCounter(SinglePackageUpsellModalBuyClickedCounter, 1, {
			appContext = getAppContext()
		})
		buyItemActivated()
	end

	if FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then
		t3.buttons.buttonRef = v37
	end

	return React.createElement(InteractiveAlert, {
		title = "",
		defaultChildRef = if not FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then nil else v38,
		screenSize = t3.screenSize,
		anchorPoint = Vector2.new(0.5, 0.5),
		position = UDim2.new(0.5, 0, 0.5, 0),
		titleContent = function() -- line: 237
			-- upvalues: React (copy), RobuxUpsellModalTitle (copy), t3 (copy), v39 (copy)
			return React.createElement(RobuxUpsellModalTitle, {
				balanceAmount = t3.upsell.balanceAmount,
				cancelPurchaseActivated = v39
			})
		end,
		middleContent = function() -- line: 243
			-- upvalues: React (copy), MiddleContent (copy), t3 (copy)
			return React.createElement(MiddleContent, {
				product = t3.product,
				upsell = t3.upsell,
				isPortrait = t3.screenSize.X < t3.screenSize.Y
			})
		end,
		buttonStackInfo = ButtonStackInfo({
			buttons = t3.buttons,
			isQuest = t3.isQuest
		}),
		footerContent = function() -- line: 254
			-- upvalues: React (copy), RobuxUpsellModalFooter (copy)
			return React.createElement(RobuxUpsellModalFooter)
		end
	})
end
local function RobuxUpsellModalContainer(t4: {[any]: any}) -- line: 260
	-- upvalues: React (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), RobuxUpsellModal (copy)
	return React.createElement(LocalizationProvider, {
		localization = Localization.new(LocalizationService.RobloxLocaleId)
	}, {
		RobuxUpsellModal = React.createElement(RobuxUpsellModal, t4)
	})
end

return RobuxUpsellModalContainer
