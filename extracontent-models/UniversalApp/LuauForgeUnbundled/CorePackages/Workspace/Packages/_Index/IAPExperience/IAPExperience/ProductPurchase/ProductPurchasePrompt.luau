local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Roact")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/t")

local FitFrame = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/FitFrame")
local fitFrameVertical = FitFrame.FitFrameVertical
local fitTextLabel = FitFrame.FitTextLabel

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Core.Style.withStyle
local useDefaultFocusBehavior = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/ReactFocusNavigation").useDefaultFocusBehavior
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Cryo")

local ModelViewport = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/ModelViewport")
local MultiTextLocalizer = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Locale/MultiTextLocalizer")

local shouldShowNewUpsellModalExperiment = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/Experiments/shouldShowNewUpsellModalExperiment")
local DesktopUpsellExperiment = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/Experiments/DesktopUpsellExperiment")

local ProductPurchaseModal = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v2/ProductPurchaseModal")

local iconscommonrobux = images["icons/common/robux"]
local v5 = utf8.char(57346)

local default = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/LoggingProtocol").default
local purchaseModalV1ShownCounter = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Events/PurchaseModalCounter").PurchaseModalV1ShownCounter

local logger = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/logger")
local getAppContext = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/getAppContext")

local FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt")

local extended = Roact.Component:extend("ProductPurchasePrompt")

local strictInterface = t.strictInterface
local v6 = {
	anchorPoint = t.optional(t.Vector2),
	position = t.optional(t.UDim2),
	screenSize = t.Vector2,
	isLoading = t.optional(t.boolean),
	isDisabled = t.optional(t.boolean),
	isDelayedInput = t.optional(t.boolean),
	enableInputDelayed = t.optional(t.boolean),
	itemIcon = t.union(t.string, t.table),
	model = t.optional(t.table),
	itemName = t.string,
	itemRobuxCost = t.number,
	currentBalance = t.number,
	currentBalanceValid = t.optional(t.boolean),
	isGamePass = t.optional(t.boolean),
	testPurchase = t.optional(t.boolean),
	buyItemControllerIcon = t.optional(t.table),
	cancelControllerIcon = t.optional(t.table),
	buyItemActivated = t.callback,
	cancelPurchaseActivated = t.callback,
	isLuobu = t.optional(t.boolean),
	defaultFocusRef = 0,
	containerRef = 0
}

local v7 = if FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then t.callback else nil
v6.defaultFocusRef = v7
local v8 = if FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then t.callback else nil
v6.containerRef = v8
extended.validateProps = strictInterface(v6)

extended.defaultProps = {
	anchorPoint = Vector2.new(0.5, 0.5),
	position = UDim2.new(0.5, 0, 0.5, 0),
	isLoading = false,
	isDisabled = false,
	testPurchase = false,
	isDelayedInput = false,
	enableInputDelayed = false,
	isLuobu = false,
	isGamePass = false,
	currentBalanceValid = true
}

function extended:init()
	self.contentRef = Roact.createRef()
	self.footerRef = Roact.createRef()
	self.state = { contentSize = Vector2.new(0, 0), footerSize = Vector2.new(0, 0) }

	function self.changeContentSize(p2)
		if self.state.contentSize ~= p2.AbsoluteSize then
			self:setState({ contentSize = p2.AbsoluteSize })
		end
	end

	function self.changeFooterSize(p2)
		if self.state.footerSize ~= p2.AbsoluteSize then
			self:setState({ footerSize = p2.AbsoluteSize })
		end
	end
end

function extended:render()
	local v9 = self.props.isLuobu and "IAPExperience.PurchasePrompt.Text.BuyItemQuestionIncludingWarning"
		or "IAPExperience.PurchasePrompt.Text.BuyItemQuestion"

	local isGamePass = self.props.isGamePass

	if shouldShowNewUpsellModalExperiment() or DesktopUpsellExperiment.shouldShowNewModal() then
		return Roact.createElement(ProductPurchaseModal, {
			product = {
				itemIcon = self.props.itemIcon,
				itemName = self.props.itemName,
				itemRobuxCost = self.props.itemRobuxCost
			},
			balanceAmount = self.props.currentBalance,
			balanceAmountValid = self.props.currentBalanceValid,
			buttons = {
				buyItemActivated = self.props.buyItemActivated,
				buyItemControllerIcon = self.props.buyItemControllerIcon,
				buyItemIsDelayedInput = self.props.isDelayedInput,
				buyItemEnableInputDelayed = self.props.enableInputDelayed,
				cancelActivated = self.props.cancelPurchaseActivated,
				isDisabled = self.props.isDisabled
			},
			screenSize = self.props.screenSize
		})
	end

	return Roact.createElement(MultiTextLocalizer, {
		keys = {
			BuyItemTitle = {
				key = isGamePass and "IAPExperience.PurchasePrompt.Title.BuyGamepass" or "IAPExperience.PurchasePrompt.Title.BuyItem"
			},
			BuyItemQuestion = {
				key = v9,
				params = { name = self.props.itemName }
			},
			RemainingBalance = {
				key = "IAPExperience.PurchasePrompt.Text.RemainingBalance"
			},
			TestPurchaseText = {
				key = "IAPExperience.PurchasePrompt.Text.TestPurchase"
			},
			ButtonCancel = { key = "IAPExperience.PurchasePrompt.Action.Cancel" },
			LoadingText = { key = "IAPExperience.PurchasePrompt.Text.Loading" }
		},
		render = function(p2)
			return self:renderAlert(p2)
		end
	})
end

function extended:renderAlert(data2)
	local props = self.props
	logger.debug({
		message = "Purchase Modal V1 Shown",
		screenHeight = props.screenSize.Y,
		screenWidth = props.screenSize.X,
		portrait = props.screenSize.X < props.screenSize.Y,
		appContext = getAppContext()
	})

	default:logRobloxTelemetryCounter(purchaseModalV1ShownCounter, 1, {
		screenHeight = props.screenSize.Y,
		screenWidth = props.screenSize.X,
		portrait = props.screenSize.X < props.screenSize.Y,
		appContext = getAppContext()
	})

	return withStyle(function(props2)
		local theme = props2.Theme
		local font = props2.Font
		local color = theme.IconEmphasis.Color

		local v9 = math.round(color.R * 255)
		local v10 = math.round(color.G * 255)
		local v11 = math.round(color.B * 255)
		local v12 = string.format("rgb(%d,%d,%d)", v9, v10, v11)
		local v13 = self.state.contentSize.X * 0.85

		local v14 = string.format(
			"%s <font color=\"%s\">%s</font>%d",
			data2.RemainingBalance,
			v12,
			v5,
			self.props.currentBalance - self.props.itemRobuxCost
		)
		local v15

		if self.props.model then
			v15 = Roact.createElement(ModelViewport, {
				model = self.props.model,
				LayoutOrder = 1,
				Size = UDim2.fromOffset(85, 85),
				Position = UDim2.fromOffset(5, 5)
			})
		else
			v15 = Roact.createElement(imageSetLabel, {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 5, 0, 5),
				Size = UDim2.new(0, 85, 0, 85),
				ScaleType = Enum.ScaleType.Stretch,
				Image = self.props.itemIcon,
				ImageTransparency = 0
			})
		end

		local createElement = Roact.createElement

		local v18 = if FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then self.props.containerRef else nil
		local v17 = {
			defaultChildRef = v18,
			screenSize = self.props.screenSize,
			position = self.props.position,
			anchorPoint = self.props.anchorPoint,
			title = data2.BuyItemTitle,
			middleContent = function()
				return Roact.createElement(fitFrameVertical, {
					BackgroundTransparency = 1,
					width = UDim.new(1, 0),
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					contentPadding = UDim.new(0, 24),
					[Roact.Ref] = self.contentRef,
					[Roact.Change.AbsoluteSize] = self.changeContentSize
				}, {
					ItemIcon = v15,
					ItemName = Roact.createElement(fitTextLabel, {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						TextWrapped = true,
						width = fitTextLabel.Width.FitToText,
						maximumWidth = self.state.contentSize.X,
						Font = font.Footer.Font,
						Text = data2.BuyItemQuestion,
						TextSize = font.BaseSize * font.Body.RelativeSize,
						TextColor3 = theme.TextDefault.Color
					})
				})
			end,
			buttonStackInfo = 0,
			footerContent = 0
		}

		local v19 = {
			disableGamepadRefs = FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt and true or nil,
			buttons = 0
		}

		local v21 = {
			props = {
				isDisabled = self.props.isDisabled or self.props.isLoading,
				onActivated = self.props.cancelPurchaseActivated,
				text = data2.ButtonCancel,
				inputIcon = self.props.cancelControllerIcon
			}
		}

		local v22 = { buttonType = buttonType.PrimarySystem, props = 0 }
		local v23 = {
			isLoading = self.props.isLoading,
			isDisabled = self.props.isDisabled,
			isDelayedInput = self.props.isDelayedInput,
			enableInputDelayed = self.props.enableInputDelayed,
			delayInputSeconds = 3,
			onActivated = self.props.buyItemActivated,
			icon = iconscommonrobux,
			text = tostring(self.props.itemRobuxCost),
			inputIcon = self.props.buyItemControllerIcon,
			buttonRef = 0
		}

		local v24 = if FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then self.props.defaultFocusRef else nil
		v23.buttonRef = v24
		v22.props = v23
		v19.buttons = { v21, v22 }
		v17.buttonStackInfo = v19

		function v17.footerContent()
			if not self.props.currentBalanceValid then
				return Roact.None
			end

			if self.props.testPurchase then
				return Roact.createElement(fitFrameVertical, {
					BackgroundTransparency = 1,
					width = UDim.new(1, 0),
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					contentPadding = UDim.new(0, 2),
					[Roact.Ref] = self.footerRef,
					[Roact.Change.AbsoluteSize] = self.changeFooterSize
				}, {
					TestPurchaseTest = Roact.createElement(fitTextLabel, {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						width = fitTextLabel.Width.FitToText,
						Font = font.Footer.Font,
						Text = data2.TestPurchaseText,
						TextSize = font.BaseSize * font.Footer.RelativeSize,
						TextColor3 = theme.TextDefault.Color
					})
				})
			else
				local createElement2 = Roact.createElement
				local v26 = {
					BackgroundTransparency = 1,
					width = UDim.new(1, 0),
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					contentPadding = UDim.new(0, 2),
					[Roact.Ref] = self.footerRef,
					[Roact.Change.AbsoluteSize] = self.changeFooterSize
				}

				local createElement3 = Roact.createElement
				local v29 = {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					RichText = true,
					Position = UDim2.fromScale(0, 0.5),
					Size = UDim2.fromOffset(v13, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					TextWrapped = true,
					Font = 0,
					FontFace = 0,
					Text = 0,
					TextSize = 0,
					TextColor3 = 0
				}

				local v30 = if not foundationFontFaceMigration then font.Footer.Font else nil
				v29.Font = v30

				local v31 = if foundationFontFaceMigration then normalizeFontFace(props2.Tokens.Typography.CaptionSmall.Font) else nil
				v29.FontFace = v31

				v29.Text = v14
				v29.TextSize = font.BaseSize * font.Footer.RelativeSize
				v29.TextColor3 = theme.TextDefault.Color
				return createElement2(fitFrameVertical, v26, {
					RemainingBalanceText = createElement3("TextLabel", v29)
				})
			end
		end

		return createElement(interactiveAlert, v17)
	end)
end

return FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt and function(p2)
	local v9, v10 = useDefaultFocusBehavior()

	return Roact.createElement(
		extended,
		Cryo.Dictionary.join(p2, { defaultFocusRef = v9, containerRef = v10 })
	)
end or extended
