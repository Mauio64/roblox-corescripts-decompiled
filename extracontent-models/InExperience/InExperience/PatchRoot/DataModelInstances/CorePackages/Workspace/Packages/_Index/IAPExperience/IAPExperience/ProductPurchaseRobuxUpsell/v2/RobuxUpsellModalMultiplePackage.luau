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
local YellowBadge = require(ParentParent.Generic.YellowBadge)
local RobuxUpsellModalTitle = require(script.Parent.RobuxUpsellModalTitle)
local RobuxUpsellModalFooter = require(script.Parent.RobuxUpsellModalFooter)
local formatNumber = require(ParentParent.Utility.formatNumber)
local logger = require(ParentParent.Utility.logger)
local getAppContext = require(ParentParent.Utility.getAppContext)
local default = require(ParentParentParent.LoggingProtocol).default
local MultiplePackageUpsellCounter = require(ParentParent.Generic.Events.MultiplePackageUpsellCounter)
local MultiplePackageUpsellShownCounter = MultiplePackageUpsellCounter.MultiplePackageUpsellShownCounter
local MultiplePackageUpsellSelectedCounter = MultiplePackageUpsellCounter.MultiplePackageUpsellSelectedCounter
local MultiplePackageUpsellModalClosedCounter = MultiplePackageUpsellCounter.MultiplePackageUpsellModalClosedCounter
local MultiplePackageUpsellModalBuyClickedCounter = MultiplePackageUpsellCounter.MultiplePackageUpsellModalBuyClickedCounter

require(ParentParent.Api.PaymentsGateway.GetUpsellSuggestionsTypes)

local BadgeType = require(ParentParent.Enums.BadgeType)

require(ParentParent.Enums.VirtualItemBadgeType)

local useDefaultFocusBehavior = require(ParentParentParent.ReactFocusNavigation).useDefaultFocusBehavior
local FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt = require(ParentParent.Flags.FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt)

local function UpsellProductDetails(t1: {[any]: any}) -- line: 64
	-- upvalues: useLocalization (copy), BadgeType (copy), React (copy), View (copy), FoundationText (copy), formatNumber (copy), LocalizationService (copy), YellowBadge (copy)
	local v37 = useLocalization({
		Popular = "IAPExperience.RobuxUpsell.Text.PopularItem",
		LastPurchased = "IAPExperience.RobuxUpsell.Text.LastPurchased"
	})
	local v38 = if t1.badgeType ~= BadgeType.Popular then if t1.badgeType ~= BadgeType.LastPurchased then nil else v37.LastPurchased else v37.Popular
	local v39 = if t1.badgeType ~= BadgeType.Popular then nil else "icons/menu/fire_fill"
	local s1 = "size-full-1400 radius-medium padding-x-large row"
	local v41 = if not t1.selected then s1 .. " bg-surface-300 stroke-emphasis stroke-standard" else s1 .. " bg-surface-200 stroke-system-contrast stroke-thick"

	return React.createElement(View, {
		LayoutOrder = t1.layoutOrder,
		onActivated = t1.onSelected,
		tag = v41
	}, {
		LeftSide = React.createElement(View, {
			LayoutOrder = 1,
			tag = "row gap-small align-y-center align-x-start",
			Size = UDim2.new(0.5, 0, 1, 0)
		}, {
			RobuxAmount = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "auto-xy text-title-large content-emphasis text-align-x-left",
				Text = utf8.char(57346) .. " " .. formatNumber(LocalizationService.RobloxLocaleId, t1.product.robuxAmount)
			}),
			RobuxAmountBonus = t1.product.robuxAmountBeforeBonus and React.createElement(FoundationText, {
				LayoutOrder = 2,
				RichText = true,
				tag = "auto-xy text-title-large content-muted text-align-x-left",
				Text = "<s>" .. utf8.char(57346) .. formatNumber(LocalizationService.RobloxLocaleId, t1.product.robuxAmountBeforeBonus) .. "</s>"
			})
		}),
		RightSide = React.createElement(View, {
			LayoutOrder = 2,
			tag = "row align-y-center align-x-right gap-large",
			Size = UDim2.new(0.5, 0, 1, 0)
		}, {
			Badge = if not v38 then nil else React.createElement(YellowBadge, {
				LayoutOrder = 1,
				Text = v38,
				Icon = v39
			}),
			RobuxPrice = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "auto-xy text-title-large content-emphasis text-align-x-right",
				Text = t1.product.price or ""
			})
		})
	})
end
local function MiddleContent(t2: {[any]: any}) -- line: 149
	-- upvalues: React (copy), View (copy), ProductDetails (copy), UpsellProductDetails (copy)
	return React.createElement(View, {
		tag = "col gap-xxlarge auto-y size-full-0 align-x-center align-y-center"
	}, {
		ProductDetails = React.createElement(ProductDetails, {
			layoutOrder = 1,
			isPortrait = t2.isPortrait and #t2.upsellSuggestions == 1,
			model = t2.product.model,
			itemIcon = t2.product.itemIcon,
			itemName = t2.product.itemName,
			itemRobuxCost = t2.product.itemRobuxCost,
			badgeType = t2.product.badgeType
		}),
		UpsellSuggestions = React.createElement(View, {
			LayoutOrder = 2,
			tag = "col gap-medium auto-y size-full-0 align-x-center align-y-center"
		}, {
			UpsellPackage1 = React.createElement(UpsellProductDetails, {
				layoutOrder = 1,
				product = t2.upsellSuggestions[1],
				selected = t2.selectedUpsellIndex == 1,
				onSelected = function() -- line: 170
					-- upvalues: t2 (copy)
					t2.onUpsellSuggestionsSelected(1)
				end
			}),
			UpsellPackage2 = if not (#t2.upsellSuggestions > 1) then nil else React.createElement(UpsellProductDetails, {
				layoutOrder = 2,
				product = t2.upsellSuggestions[2],
				selected = t2.selectedUpsellIndex == 2,
				onSelected = function() -- line: 179
					-- upvalues: t2 (copy)
					t2.onUpsellSuggestionsSelected(2)
				end,
				badgeType = t2.upsellSuggestions[2].badgeType
			})
		})
	})
end
local function ButtonStackInfo(t3: {[any]: any}) -- line: 204
	-- upvalues: useLocalization (copy), FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt (copy), ButtonType (copy)
	local v44 = useLocalization({
		BuyRobuxButton = "IAPExperience.RobuxUpsell.Action.BuyRobuxAndItem",
		ButtonCancel = "IAPExperience.RobuxUpsell.Action.Cancel",
		LoadingText = "IAPExperience.RobuxUpsell.Text.Loading"
	})

	return {
		forcedFillDirection = Enum.FillDirection.Vertical,
		disableGamepadRefs = not not FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt or nil,
		buttons = if not t3.isQuest then {{
			buttonType = ButtonType.PrimaryContextual,
			props = {
				isDelayedInput = t3.buttons.buyItemisDelayedInput,
				enableInputDelayed = t3.buttons.buyItemEnableInputDelayed,
				onActivated = t3.buttons.buyItemActivated,
				text = v44.BuyRobuxButton,
				inputIcon = t3.buttons.buyItemControllerIcon,
				buttonRef = if not FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then nil else t3.buttons.buttonRef
			}
		}} else {{
			props = {
				onActivated = t3.buttons.cancelPurchaseActivated,
				text = v44.ButtonCancel,
				inputIcon = t3.buttons.cancelControllerIcon
			}
		}}
	}
end
local function RobuxUpsellModal(t4: {[any]: any}) -- line: 253
	-- upvalues: FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt (copy), useDefaultFocusBehavior (copy), React (copy), logger (copy), default (copy), MultiplePackageUpsellShownCounter (copy), MultiplePackageUpsellSelectedCounter (copy), MultiplePackageUpsellModalClosedCounter (copy), getAppContext (copy), MultiplePackageUpsellModalBuyClickedCounter (copy), InteractiveAlert (copy), RobuxUpsellModalTitle (copy), MiddleContent (copy), ButtonStackInfo (copy), RobuxUpsellModalFooter (copy)
	local v46 = nil
	local v47 = nil

	if FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then
		v46, v47 = useDefaultFocusBehavior()
	end

	React.useEffect(function() -- line: 260
		-- upvalues: logger (copy), t4 (copy), default (copy), MultiplePackageUpsellShownCounter (copy)
		logger.debug({
			message = "Multiple Package Upsell Modal Shown",
			suggestionCount = #t4.upsellSuggestions,
			screenHeight = t4.screenSize.Y,
			screenWidth = t4.screenSize.X,
			portrait = t4.screenSize.X < t4.screenSize.Y
		})
		default:logRobloxTelemetryCounter(MultiplePackageUpsellShownCounter, 1, {
			suggestionCount = #t4.upsellSuggestions,
			screenHeight = t4.screenSize.Y,
			screenWidth = t4.screenSize.X,
			portrait = t4.screenSize.X < t4.screenSize.Y
		})
	end, { t4.upsellSuggestions })

	local function v48(n1: number) -- line: 277
		-- upvalues: logger (copy), t4 (copy), default (copy), MultiplePackageUpsellSelectedCounter (copy)
		logger.debug({
			message = "Multiple Package Upsell Option Selected",
			suggestionCount = #t4.upsellSuggestions,
			previousIndex = t4.selectedUpsellIndex,
			selectedIndex = n1
		})
		default:logRobloxTelemetryCounter(MultiplePackageUpsellSelectedCounter, 1, {
			suggestionCount = #t4.upsellSuggestions,
			previousIndex = t4.selectedUpsellIndex,
			selectedIndex = n1
		})
		t4.onUpsellSuggestionsSelected(n1)
	end
	local function v49() -- line: 293
		-- upvalues: logger (copy), t4 (copy), default (copy), MultiplePackageUpsellModalClosedCounter (copy)
		logger.debug({
			message = "Multiple Package Upsell Modal Closed",
			suggestionCount = #t4.upsellSuggestions
		})
		default:logRobloxTelemetryCounter(MultiplePackageUpsellModalClosedCounter, 1, {
			suggestionCount = #t4.upsellSuggestions
		})
		t4.buttons.cancelPurchaseActivated()
	end

	local buyItemActivated = t4.buttons.buyItemActivated

	function t4.buttons.buyItemActivated() -- line: 306
		-- upvalues: logger (copy), getAppContext (copy), t4 (copy), default (copy), MultiplePackageUpsellModalBuyClickedCounter (copy), buyItemActivated (copy)
		logger.debug({
			message = "Multiple Package Upsell Modal Buy Clicked",
			appContext = getAppContext(),
			suggestionCount = #t4.upsellSuggestions,
			selectedIndex = t4.selectedUpsellIndex
		})
		default:logRobloxTelemetryCounter(MultiplePackageUpsellModalBuyClickedCounter, 1, {
			appContext = getAppContext(),
			suggestionCount = #t4.upsellSuggestions,
			selectedIndex = t4.selectedUpsellIndex
		})
		buyItemActivated()
	end

	if FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then
		t4.buttons.buttonRef = v46
	end

	return React.createElement(InteractiveAlert, {
		title = "",
		defaultChildRef = if not FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then nil else v47,
		screenSize = t4.screenSize,
		anchorPoint = Vector2.new(0.5, 0.5),
		position = UDim2.new(0.5, 0, 0.5, 0),
		titleContent = function() -- line: 331
			-- upvalues: React (copy), RobuxUpsellModalTitle (copy), t4 (copy), v49 (copy)
			return React.createElement(RobuxUpsellModalTitle, {
				balanceAmount = t4.userBalance,
				cancelPurchaseActivated = v49
			})
		end,
		middleContent = function() -- line: 337
			-- upvalues: React (copy), MiddleContent (copy), t4 (copy), v48 (copy)
			return React.createElement(MiddleContent, {
				product = t4.product,
				upsellSuggestions = t4.upsellSuggestions,
				selectedUpsellIndex = t4.selectedUpsellIndex,
				onUpsellSuggestionsSelected = v48,
				isPortrait = t4.screenSize.X < t4.screenSize.Y
			})
		end,
		buttonStackInfo = ButtonStackInfo({
			buttons = t4.buttons,
			isQuest = t4.isQuest
		}),
		footerContent = function() -- line: 350
			-- upvalues: React (copy), RobuxUpsellModalFooter (copy)
			return React.createElement(RobuxUpsellModalFooter)
		end
	})
end
local function RobuxUpsellModalContainer(t5: {[any]: any}) -- line: 356
	-- upvalues: React (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), RobuxUpsellModal (copy)
	return React.createElement(LocalizationProvider, {
		localization = Localization.new(LocalizationService.RobloxLocaleId)
	}, {
		RobuxUpsellModal = React.createElement(RobuxUpsellModal, t5)
	})
end

return RobuxUpsellModalContainer
