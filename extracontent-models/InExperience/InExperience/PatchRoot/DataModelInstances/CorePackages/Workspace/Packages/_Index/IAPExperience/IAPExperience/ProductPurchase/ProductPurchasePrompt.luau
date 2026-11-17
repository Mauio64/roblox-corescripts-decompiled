local parent = script.Parent.Parent
local parent2 = parent.Parent

local Roact = require(parent2.Roact)
local t = require(parent2.t)

local RoactFitComponents = require(parent2.RoactFitComponents)
local FitFrameVertical = RoactFitComponents.FitFrameVertical
local FitTextLabel = RoactFitComponents.FitTextLabel

local UIBlox = require(parent2.UIBlox)
local Foundation = require(parent2.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Core.Style.withStyle
local ReactFocusNavigation = require(parent2.ReactFocusNavigation)
local useDefaultFocusBehavior = ReactFocusNavigation.useDefaultFocusBehavior
local Cryo = require(parent2.Cryo)

local ModelViewport = require(script.Parent.Parent.Generic.ModelViewport)
local MultiTextLocalizer = require(parent.Locale.MultiTextLocalizer)

local shouldShowNewUpsellModalExperiment = require(parent.Utility.Experiments.shouldShowNewUpsellModalExperiment)
local DesktopUpsellExperiment = require(parent.Utility.Experiments.DesktopUpsellExperiment)

local ProductPurchaseModal = require(script.Parent.v2.ProductPurchaseModal)

local iconscommonrobux = Images["icons/common/robux"]
local v = utf8.char(57346)

local LoggingProtocol = require(parent2.LoggingProtocol)
local default = LoggingProtocol.default
local PurchaseModalCounter = require(parent.Generic.Events.PurchaseModalCounter)
local PurchaseModalV1ShownCounter = PurchaseModalCounter.PurchaseModalV1ShownCounter

local logger = require(parent.Utility.logger)
local getAppContext = require(parent.Utility.getAppContext)

local FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt = require(parent.Flags.FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt)

local extended = Roact.Component:extend(script.Name)

local strictInterface = t.strictInterface
local v2 = {
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
local defaultFocusRef

if FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then
	defaultFocusRef = t.callback
end

v2.defaultFocusRef = defaultFocusRef
local containerRef

if FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then
	containerRef = t.callback
end

v2.containerRef = containerRef
extended.validateProps = strictInterface(v2)

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

	function self.changeContentSize(p)
		if self.state.contentSize ~= p.AbsoluteSize then
			self:setState({ contentSize = p.AbsoluteSize })
		end
	end

	function self.changeFooterSize(p)
		if self.state.footerSize ~= p.AbsoluteSize then
			self:setState({ footerSize = p.AbsoluteSize })
		end
	end
end

function extended:render()
	local v3 = self.props.isLuobu and "IAPExperience.PurchasePrompt.Text.BuyItemQuestionIncludingWarning"
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
				key = v3,
				params = { name = self.props.itemName }
			},
			RemainingBalance = { key = "IAPExperience.PurchasePrompt.Text.RemainingBalance" },
			TestPurchaseText = { key = "IAPExperience.PurchasePrompt.Text.TestPurchase" },
			ButtonCancel = { key = "IAPExperience.PurchasePrompt.Action.Cancel" },
			LoadingText = { key = "IAPExperience.PurchasePrompt.Text.Loading" }
		},
		render = function(p)
			return self:renderAlert(p)
		end
	})
end

function extended:renderAlert(data)
	local props = self.props
	logger.debug({
		message = "Purchase Modal V1 Shown",
		screenHeight = props.screenSize.Y,
		screenWidth = props.screenSize.X,
		portrait = props.screenSize.X < props.screenSize.Y,
		appContext = getAppContext()
	})

	default:logRobloxTelemetryCounter(PurchaseModalV1ShownCounter, 1, {
		screenHeight = props.screenSize.Y,
		screenWidth = props.screenSize.X,
		portrait = props.screenSize.X < props.screenSize.Y,
		appContext = getAppContext()
	})

	return withStyle(function(props2)
		local theme = props2.Theme
		local font = props2.Font
		local color = theme.IconEmphasis.Color

		local v3 = math.round(color.R * 255)
		local v4 = math.round(color.G * 255)
		local v5 = math.round(color.B * 255)
		local v6 = string.format("rgb(%d,%d,%d)", v3, v4, v5)
		local v7 = self.state.contentSize.X * 0.85

		local text = string.format(
			"%s <font color=\"%s\">%s</font>%d",
			data.RemainingBalance,
			v6,
			v,
			self.props.currentBalance - self.props.itemRobuxCost
		)
		local itemIcon

		if self.props.model then
			itemIcon = Roact.createElement(ModelViewport, {
				model = self.props.model,
				LayoutOrder = 1,
				Size = UDim2.fromOffset(85, 85),
				Position = UDim2.fromOffset(5, 5)
			})
		else
			itemIcon = Roact.createElement(ImageSetLabel, {
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
		local defaultChildRef

		if FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then
			defaultChildRef = self.props.containerRef
		end

		local v8 = {
			defaultChildRef = defaultChildRef,
			screenSize = self.props.screenSize,
			position = self.props.position,
			anchorPoint = self.props.anchorPoint,
			title = data.BuyItemTitle,
			middleContent = function()
				return Roact.createElement(FitFrameVertical, {
					BackgroundTransparency = 1,
					width = UDim.new(1, 0),
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					contentPadding = UDim.new(0, 24),
					[Roact.Ref] = self.contentRef,
					[Roact.Change.AbsoluteSize] = self.changeContentSize
				}, {
					ItemIcon = itemIcon,
					ItemName = Roact.createElement(FitTextLabel, {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						TextWrapped = true,
						width = FitTextLabel.Width.FitToText,
						maximumWidth = self.state.contentSize.X,
						Font = font.Footer.Font,
						Text = data.BuyItemQuestion,
						TextSize = font.BaseSize * font.Body.RelativeSize,
						TextColor3 = theme.TextDefault.Color
					})
				})
			end,
			buttonStackInfo = 0,
			footerContent = 0
		}

		local buttonStackInfo = {
			disableGamepadRefs = FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt and true or nil,
			buttons = 0
		}

		local v9 = {
			props = {
				isDisabled = self.props.isDisabled or self.props.isLoading,
				onActivated = self.props.cancelPurchaseActivated,
				text = data.ButtonCancel,
				inputIcon = self.props.cancelControllerIcon
			}
		}

		local v10 = { buttonType = ButtonType.PrimarySystem, props = 0 }
		local props3 = {
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
		local buttonRef

		if FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then
			buttonRef = self.props.defaultFocusRef
		end

		props3.buttonRef = buttonRef
		v10.props = props3
		buttonStackInfo.buttons = { v9, v10 }
		v8.buttonStackInfo = buttonStackInfo

		function v8.footerContent()
			if not self.props.currentBalanceValid then
				return Roact.None
			end

			if self.props.testPurchase then
				return Roact.createElement(FitFrameVertical, {
					BackgroundTransparency = 1,
					width = UDim.new(1, 0),
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					contentPadding = UDim.new(0, 2),
					[Roact.Ref] = self.footerRef,
					[Roact.Change.AbsoluteSize] = self.changeFooterSize
				}, {
					TestPurchaseTest = Roact.createElement(FitTextLabel, {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						width = FitTextLabel.Width.FitToText,
						Font = font.Footer.Font,
						Text = data.TestPurchaseText,
						TextSize = font.BaseSize * font.Footer.RelativeSize,
						TextColor3 = theme.TextDefault.Color
					})
				})
			end

			return Roact.createElement(FitFrameVertical, {
				BackgroundTransparency = 1,
				width = UDim.new(1, 0),
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				contentPadding = UDim.new(0, 2),
				[Roact.Ref] = self.footerRef,
				[Roact.Change.AbsoluteSize] = self.changeFooterSize
			}, {
				RemainingBalanceText = Roact.createElement("TextLabel", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					RichText = true,
					Position = UDim2.fromScale(0, 0.5),
					Size = UDim2.fromOffset(v7, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					TextWrapped = true,
					FontFace = normalizeFontFace(props2.Tokens.Typography.CaptionSmall.Font),
					Text = text,
					TextSize = font.BaseSize * font.Footer.RelativeSize,
					TextColor3 = theme.TextDefault.Color
				})
			})
		end

		return createElement(InteractiveAlert, v8)
	end)
end

return FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt and function(p)
	local defaultFocusRef2, containerRef2 = useDefaultFocusBehavior()

	return Roact.createElement(
		extended,
		Cryo.Dictionary.join(p, { defaultFocusRef = defaultFocusRef2, containerRef = containerRef2 })
	)
end or extended
