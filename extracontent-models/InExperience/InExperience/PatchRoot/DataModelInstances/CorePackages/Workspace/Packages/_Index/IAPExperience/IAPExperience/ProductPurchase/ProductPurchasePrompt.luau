local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local t = require(ParentParentParent.t)
local RoactFitComponents = require(ParentParentParent.RoactFitComponents)
local FitFrameVertical = RoactFitComponents.FitFrameVertical
local FitTextLabel = RoactFitComponents.FitTextLabel
local UIBlox = require(ParentParentParent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Core.Style.withStyle
local useDefaultFocusBehavior = require(ParentParentParent.ReactFocusNavigation).useDefaultFocusBehavior
local Cryo = require(ParentParentParent.Cryo)
local ModelViewport = require(script.Parent.Parent.Generic.ModelViewport)
local MultiTextLocalizer = require(ParentParent.Locale.MultiTextLocalizer)
local shouldShowNewUpsellModalExperiment = require(ParentParent.Utility.Experiments.shouldShowNewUpsellModalExperiment)
local DesktopUpsellExperiment = require(ParentParent.Utility.Experiments.DesktopUpsellExperiment)
local ProductPurchaseModal = require(script.Parent.v2.ProductPurchaseModal)
local v21 = Images["icons/common/robux"]
local v22 = utf8.char(57346)
local default = require(ParentParentParent.LoggingProtocol).default
local PurchaseModalV1ShownCounter = require(ParentParent.Generic.Events.PurchaseModalCounter).PurchaseModalV1ShownCounter
local logger = require(ParentParent.Utility.logger)
local getAppContext = require(ParentParent.Utility.getAppContext)
local FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt = require(ParentParent.Flags.FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt)
local v28 = Roact.Component:extend(script.Name)

v28.validateProps = t.strictInterface({
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
	defaultFocusRef = if not FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then nil else t.callback,
	containerRef = if not FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then nil else t.callback
})
v28.defaultProps = {
	isLoading = false,
	isDisabled = false,
	testPurchase = false,
	isDelayedInput = false,
	enableInputDelayed = false,
	isLuobu = false,
	isGamePass = false,
	currentBalanceValid = true,
	anchorPoint = Vector2.new(0.5, 0.5),
	position = UDim2.new(0.5, 0, 0.5, 0)
}

function v28.init(p1) -- line: 99
	-- upvalues: Roact (copy)
	p1.contentRef = Roact.createRef()
	p1.footerRef = Roact.createRef()
	p1.state = {
		contentSize = Vector2.new(0, 0),
		footerSize = Vector2.new(0, 0)
	}

	function p1.changeContentSize(p2) -- line: 107
		-- upvalues: p1 (copy)
		if p1.state.contentSize ~= p2.AbsoluteSize then
			p1:setState({
				contentSize = p2.AbsoluteSize
			})
		end
	end
	function p1.changeFooterSize(p3) -- line: 115
		-- upvalues: p1 (copy)
		if p1.state.footerSize ~= p3.AbsoluteSize then
			p1:setState({
				footerSize = p3.AbsoluteSize
			})
		end
	end
end
function v28.render(p4) -- line: 124
	-- upvalues: shouldShowNewUpsellModalExperiment (copy), DesktopUpsellExperiment (copy), Roact (copy), ProductPurchaseModal (copy), MultiTextLocalizer (copy)
	local v32 = not p4.props.isLuobu and "IAPExperience.PurchasePrompt.Text.BuyItemQuestion" or "IAPExperience.PurchasePrompt.Text.BuyItemQuestionIncludingWarning"
	local isGamePass = p4.props.isGamePass

	if shouldShowNewUpsellModalExperiment() or DesktopUpsellExperiment.shouldShowNewModal() then
		return Roact.createElement(ProductPurchaseModal, {
			product = {
				itemIcon = p4.props.itemIcon,
				itemName = p4.props.itemName,
				itemRobuxCost = p4.props.itemRobuxCost
			},
			balanceAmount = p4.props.currentBalance,
			balanceAmountValid = p4.props.currentBalanceValid,
			buttons = {
				buyItemActivated = p4.props.buyItemActivated,
				buyItemControllerIcon = p4.props.buyItemControllerIcon,
				buyItemIsDelayedInput = p4.props.isDelayedInput,
				buyItemEnableInputDelayed = p4.props.enableInputDelayed,
				cancelActivated = p4.props.cancelPurchaseActivated,
				isDisabled = p4.props.isDisabled
			},
			screenSize = p4.props.screenSize
		})
	end

	return Roact.createElement(MultiTextLocalizer, {
		keys = {
			BuyItemTitle = {
				key = not isGamePass and "IAPExperience.PurchasePrompt.Title.BuyItem" or "IAPExperience.PurchasePrompt.Title.BuyGamepass"
			},
			BuyItemQuestion = {
				key = v32,
				params = {
					name = p4.props.itemName
				}
			},
			RemainingBalance = {
				key = "IAPExperience.PurchasePrompt.Text.RemainingBalance"
			},
			TestPurchaseText = {
				key = "IAPExperience.PurchasePrompt.Text.TestPurchase"
			},
			ButtonCancel = {
				key = "IAPExperience.PurchasePrompt.Action.Cancel"
			},
			LoadingText = {
				key = "IAPExperience.PurchasePrompt.Text.Loading"
			}
		},
		render = function(p5) -- line: 177
			-- upvalues: p4 (copy)
			return p4:renderAlert(p5)
		end
	})
end
function v28.renderAlert(p6, p7) -- line: 183
	-- upvalues: logger (copy), getAppContext (copy), default (copy), PurchaseModalV1ShownCounter (copy), withStyle (copy), v22 (copy), Roact (copy), ModelViewport (copy), ImageSetLabel (copy), InteractiveAlert (copy), FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt (copy), FitFrameVertical (copy), FitTextLabel (copy), ButtonType (copy), v21 (copy)
	local props = p6.props

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

	return withStyle(function(p8) -- line: 200
		-- upvalues: p6 (copy), p7 (copy), v22 (copy), Roact (copy), ModelViewport (copy), ImageSetLabel (copy), InteractiveAlert (copy), FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt (copy), FitFrameVertical (copy), FitTextLabel (copy), ButtonType (copy), v21 (copy)
		local Theme = p8.Theme
		local p8Font = p8.Font
		local IconEmphasisColor = Theme.IconEmphasis.Color
		local v47 = math.round(IconEmphasisColor.R * 255)
		local v48 = math.round(IconEmphasisColor.G * 255)
		local v49 = math.round(IconEmphasisColor.B * 255)
		local v50 = string.format("rgb(%d,%d,%d)", v47, v48, v49)
		local v51 = p6.state.contentSize.X * 0.85
		local v52 = string.format("%s <font color=\"%s\">%s</font>%d", p7.RemainingBalance, v50, v22, p6.props.currentBalance - p6.props.itemRobuxCost)
		local v53 = if not p6.props.model then Roact.createElement(ImageSetLabel, {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			ImageTransparency = 0,
			Position = UDim2.new(0, 5, 0, 5),
			Size = UDim2.new(0, 85, 0, 85),
			ScaleType = Enum.ScaleType.Stretch,
			Image = p6.props.itemIcon
		}) else Roact.createElement(ModelViewport, {
			LayoutOrder = 1,
			model = p6.props.model,
			Size = UDim2.fromOffset(85, 85),
			Position = UDim2.fromOffset(5, 5)
		})

		return Roact.createElement(InteractiveAlert, {
			defaultChildRef = if not FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then nil else p6.props.containerRef,
			screenSize = p6.props.screenSize,
			position = p6.props.position,
			anchorPoint = p6.props.anchorPoint,
			title = p7.BuyItemTitle,
			middleContent = function() -- line: 244
				-- upvalues: Roact (copy), FitFrameVertical (copy), p6 (copy), v53 (copy), FitTextLabel (copy), p8Font (copy), p7 (copy), Theme (copy)
				return Roact.createElement(FitFrameVertical, {
					BackgroundTransparency = 1,
					width = UDim.new(1, 0),
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					contentPadding = UDim.new(0, 24),
					[Roact.Ref] = p6.contentRef,
					[Roact.Change.AbsoluteSize] = p6.changeContentSize
				}, {
					ItemIcon = v53,
					ItemName = Roact.createElement(FitTextLabel, {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						TextWrapped = true,
						width = FitTextLabel.Width.FitToText,
						maximumWidth = p6.state.contentSize.X,
						Font = p8Font.Footer.Font,
						Text = p7.BuyItemQuestion,
						TextSize = p8Font.BaseSize * p8Font.Body.RelativeSize,
						TextColor3 = Theme.TextDefault.Color
					})
				})
			end,
			buttonStackInfo = {
				disableGamepadRefs = not not FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt or nil,
				buttons = {
					{
						props = {
							isDisabled = p6.props.isDisabled or p6.props.isLoading,
							onActivated = p6.props.cancelPurchaseActivated,
							text = p7.ButtonCancel,
							inputIcon = p6.props.cancelControllerIcon
						}
					},
					{
						buttonType = ButtonType.PrimarySystem,
						props = {
							delayInputSeconds = 3,
							isLoading = p6.props.isLoading,
							isDisabled = p6.props.isDisabled,
							isDelayedInput = p6.props.isDelayedInput,
							enableInputDelayed = p6.props.enableInputDelayed,
							onActivated = p6.props.buyItemActivated,
							icon = v21,
							text = tostring(p6.props.itemRobuxCost),
							inputIcon = p6.props.buyItemControllerIcon,
							buttonRef = if not FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then nil else p6.props.defaultFocusRef
						}
					}
				}
			},
			footerContent = function() -- line: 302
				-- upvalues: p6 (copy), Roact (copy), FitFrameVertical (copy), v51 (copy), p8Font (copy), v52 (copy), Theme (copy), FitTextLabel (copy), p7 (copy)
				if not p6.props.currentBalanceValid then
					return Roact.None
				end

				if not p6.props.testPurchase then
					return Roact.createElement(FitFrameVertical, {
						BackgroundTransparency = 1,
						width = UDim.new(1, 0),
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						contentPadding = UDim.new(0, 2),
						[Roact.Ref] = p6.footerRef,
						[Roact.Change.AbsoluteSize] = p6.changeFooterSize
					}, {
						RemainingBalanceText = Roact.createElement("TextLabel", {
							LayoutOrder = 1,
							BackgroundTransparency = 1,
							RichText = true,
							TextWrapped = true,
							Position = UDim2.fromScale(0, 0.5),
							Size = UDim2.fromOffset(v51, 0),
							AutomaticSize = Enum.AutomaticSize.Y,
							Font = p8Font.Footer.Font,
							Text = v52,
							TextSize = p8Font.BaseSize * p8Font.Footer.RelativeSize,
							TextColor3 = Theme.TextDefault.Color
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
					[Roact.Ref] = p6.footerRef,
					[Roact.Change.AbsoluteSize] = p6.changeFooterSize
				}, {
					TestPurchaseTest = Roact.createElement(FitTextLabel, {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						width = FitTextLabel.Width.FitToText,
						Font = p8Font.Footer.Font,
						Text = p7.TestPurchaseText,
						TextSize = p8Font.BaseSize * p8Font.Footer.RelativeSize,
						TextColor3 = Theme.TextDefault.Color
					})
				})
			end
		})
	end)
end

if FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then
	local v29 = v28

	function v28(p9) -- line: 363
		-- upvalues: useDefaultFocusBehavior (copy), Roact (copy), v29 (copy), Cryo (copy)
		local v38, v39 = useDefaultFocusBehavior()

		return Roact.createElement(v29, Cryo.Dictionary.join(p9, {
			defaultFocusRef = v38,
			containerRef = v39
		}))
	end
end

return v28
