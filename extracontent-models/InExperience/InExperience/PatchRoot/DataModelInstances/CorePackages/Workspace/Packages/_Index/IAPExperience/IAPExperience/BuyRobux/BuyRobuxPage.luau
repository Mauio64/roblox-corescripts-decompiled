local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local LocalizationService = game:GetService("LocalizationService")
local GuiService = game:GetService("GuiService")

local Roact = require(parent3.Roact)

local RoactGamepad = require(parent3.RoactGamepad)
local Cryo = require(parent3.Cryo)

local UIBlox = require(parent3.UIBlox)
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local Images = UIBlox.App.ImageSet.Images
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Core.Style.withStyle
local useStyleMetadata = UIBlox.Core.Style.useStyleMetadata
local Foundation = require(parent3.Foundation)
local ColorMode = Foundation.Enums.ColorMode
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local RoactFitComponents = require(parent3.RoactFitComponents)
local FitFrameHorizontal = RoactFitComponents.FitFrameHorizontal
local FitTextLabel = RoactFitComponents.FitTextLabel
local AppBlox = require(parent3.AppBlox)
local FullscreenFrame = AppBlox.FullscreenFrame

local MultiTextLocalizer = require(parent2.Locale.MultiTextLocalizer)
local formatNumber = require(parent2.Utility.formatNumber)
local Animator = require(parent2.Generic.Animator)

local getEnableCompensatingScrollingFrame = require(parent2.Flags.getEnableCompensatingScrollingFrame)

local getUserInputEventData = require(parent2.Utility.getUserInputEventData)

local RobuxPackage = require(parent.RobuxPackage)
local FFlagBuyRobuxPageFitToViewport = require(parent2.Flags.FFlagBuyRobuxPageFitToViewport)

local extended = Roact.Component:extend(script.Name)

local iconscommongoldrobux = Images["icons/common/goldrobux"]
local iconslogoblock = Images["icons/logo/block"]
local v = {
	Images["icons/graphic/robuxcoin1_xxlarge"],
	Images["icons/graphic/robuxcoin2_xxlarge"],
	Images["icons/graphic/robuxcoin3_xxlarge"],
	Images["icons/graphic/robuxcoin4_xxlarge"],
	Images["icons/graphic/robuxcoin5_xxlarge"],
	Images["icons/graphic/robuxcoin6_xxlarge"]
}

local iconsnavigationclose = Images["icons/navigation/close"]

function extended:init()
	self.state = { selectedPackage = nil, showMessageBanner = false }

	self.buttonRefs = RoactGamepad.createRefCache()
	self.scrollingFrameRef = Roact.createRef()

	if FFlagBuyRobuxPageFitToViewport then
		self.packageLayoutRef = Roact.createRef()
		local binding, setCanvasSize = Roact.createBinding(UDim2.new())
		self.canvasSize = binding
		self.setCanvasSize = setCanvasSize
		function self.updateCanvasSize()
			local current = self.scrollingFrameRef.current
			local current2 = self.packageLayoutRef.current

			if current and current2 and current.AbsoluteSize.X > 0 then
				self.setCanvasSize(UDim2.fromScale(current2.AbsoluteContentSize.X / current.AbsoluteSize.X, 0))
			end
		end
	end

	function self.getGamepadNextSelectionLeft(p)
		return p > 1 and self.buttonRefs[p - 1] or nil
	end

	function self.getGamepadNextSelectionRight(p)
		return p < #self.buttonRefs and self.buttonRefs[p + 1] or nil
	end

	function self.initSelectionChangedListener()
		if self.selectionListener ~= nil then
			self.selectionListener:Disconnect()
			self.selectionListener = nil
		end

		if self.selectionListener ~= nil then
			self.selectionListener:Disconnect()
			self.selectionListener = nil
		end

		self.selectionListener = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function()
			if
				self.state.selectedPackage == nil
				or GuiService.SelectedCoreObject == nil
				or self.state.selectedPackage ~= GuiService.SelectedCoreObject
			then
				self:setState({ selectedPackage = GuiService.SelectedCoreObject })
			end
		end)
	end
end

function extended.didMount(data)
	data.initSelectionChangedListener()

	if FFlagBuyRobuxPageFitToViewport and data.props.isConsoleSize then
		data.updateCanvasSize()
	end
end

function extended.didUpdate(object, p, _)
	local props = object.props

	if p.hasNativePurchaseSucceeded ~= props.hasNativePurchaseSucceeded and props.hasNativePurchaseSucceeded then
		object:setState({ showMessageBanner = true })
		task.delay(3, function()
			object:setState({ showMessageBanner = false })
		end)
	end
end

function extended:willUnmount()
	if self.selectionListener ~= nil then
		self.selectionListener:Disconnect()
		self.selectionListener = nil
	end
end

function extended:getScale(): number
	return if self.props.isConsoleSize then 1 else 0.65
end

function extended:render()
	return Roact.createElement(MultiTextLocalizer, {
		keys = {
			BannerText = { key = "IAPExperience.BuyRobux.Banner.Text" },
			BannerTitle = { key = "IAPExperience.BuyRobux.Banner.Title" },
			SuccessfulMessage = { key = "IAPExperience.BuyRobux.Alert.SuccessfulMessage" }
		},
		render = function(p)
			return withSelectionCursorProvider(function(p2)
				return self:renderWithLocale(p, p2)
			end)
		end
	})
end

function extended:movePackageToAttentionArea(p)
	if not getEnableCompensatingScrollingFrame() then
		return
	end

	local current = self.scrollingFrameRef.current

	if current == nil or p == nil then
		return
	end

	local x = current.AbsoluteSize.X
	local v2 = 48 * self:getScale()

	if FFlagBuyRobuxPageFitToViewport and self.props.isConsoleSize then
		local v3 = p.AbsolutePosition.X - current.AbsolutePosition.X - v2
		local v4 = v3 + p.AbsoluteSize.X + 2 * v2
		local x2 = current.CanvasPosition.X

		if v3 < 0 then
			current.CanvasPosition = Vector2.new(x2 + v3, 0)
			self:reportScrollingFrameCompensationHappened()
		elseif x < v4 then
			current.CanvasPosition = Vector2.new(x2 + v4 - x, 0)
			self:reportScrollingFrameCompensationHappened()
		end
	else
		local v3 = p.AbsolutePosition.X - v2

		if v3 < 0 then
			current.CanvasPosition = Vector2.new(v3, 0)
			self:reportScrollingFrameCompensationHappened()
		elseif x < p.AbsolutePosition.X + p.AbsoluteSize.X + v2 then
			current.CanvasPosition = Vector2.new(v3, 0)
			self:reportScrollingFrameCompensationHappened()
		end
	end
end

function extended:reportScrollingFrameCompensationHappened()
	local props = self.props

	if not props.onAnalyticEvent then
		return
	end

	local userInputEventData = getUserInputEventData(props.analyticId, "", "BuyRobux", "ScrollingFrame", "Compensated")

	props.onAnalyticEvent("UserPurchaseFlow", userInputEventData)
end

function extended:renderWithLocale(data, callback)
	local props = self.props
	local isConsoleSize = FFlagBuyRobuxPageFitToViewport and props.isConsoleSize

	return withStyle(function(props2)
		local theme = props2.Theme
		local font = props2.Font

		local scrollingEnabled = props.robuxPackages ~= nil
		local v2 = props.robuxPackages == nil and 6 or #props.robuxPackages

		local textSize = 32 * self:getScale()

		local children = {
			LeadingPadding = not isConsoleSize and Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				LayoutOrder = 0,
				Size = UDim2.new(0, 80 * self:getScale(), 0, 1)
			}),
			RobuxPackageChildren = 0,
			TrailingPadding = 0
		}

		local createElement = Roact.createElement
		local ref = Roact.Ref
		local v3

		if isConsoleSize then
			v3 = self.packageLayoutRef
		end

		local v4 = { [ref] = v3 }

		local absoluteContentSize = Roact.Change.AbsoluteContentSize
		local v5

		if isConsoleSize then
			v5 = self.updateCanvasSize
		end

		v4[absoluteContentSize] = v5
		v4.HorizontalAlignment = Enum.HorizontalAlignment.Left
		local verticalAlignment

		if isConsoleSize then
			verticalAlignment = Enum.VerticalAlignment.Top
		else
			verticalAlignment = Enum.VerticalAlignment.Center
		end

		v4.VerticalAlignment = verticalAlignment
		v4.FillDirection = Enum.FillDirection.Horizontal
		v4.SortOrder = Enum.SortOrder.LayoutOrder
		v4.Padding = UDim.new(0, 16 * self:getScale())
		children.RobuxPackageChildren = createElement("UIListLayout", v4)

		children.TrailingPadding = not isConsoleSize and Roact.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = v2 + 1,
			Size = UDim2.new(0, 80 * self:getScale(), 0, 1)
		})

		for i = 1, v2 do
			local v6 = i + 1
			local createElement2 = Roact.createElement
			local v7 = {
				layoutOrder = i,
				scale = self:getScale(),
				fitToViewport = isConsoleSize and true or nil,
				selected = self.state.selectedPackage ~= nil and self.state.selectedPackage == self.buttonRefs[i]:getValue(),
				packageId = 0,
				robuxAmount = 0,
				currencyAmountStr = 0,
				robuxMoreAmount = 0,
				robuxImage = 0,
				forwardRef = 0,
				nextSelectionLeft = 0,
				nextSelectionRight = 0,
				onActivated = 0,
				onSelect = 0,
				onHover = 0
			}
			local packageId

			if scrollingEnabled then
				packageId = props.robuxPackages[i].packageId
			else
				packageId = tostring(i)
			end

			v7.packageId = packageId
			local robuxAmount

			if scrollingEnabled then
				robuxAmount = props.robuxPackages[i].robuxAmount
			end

			v7.robuxAmount = robuxAmount
			local currencyAmountStr

			if scrollingEnabled then
				currencyAmountStr = props.robuxPackages[i].currencyAmountStr
			end

			v7.currencyAmountStr = currencyAmountStr
			local robuxMoreAmount

			if scrollingEnabled then
				robuxMoreAmount = props.robuxPackages[i].robuxMoreAmount
			end

			v7.robuxMoreAmount = robuxMoreAmount
			v7.robuxImage = v[i]

			v7.forwardRef = self.buttonRefs[i]

			v7.nextSelectionLeft = self.getGamepadNextSelectionLeft(i)
			v7.nextSelectionRight = self.getGamepadNextSelectionRight(i)

			function v7.onActivated(p: string?)
				props.robuxPackageActivated(p)
			end
			function v7.onSelect(object)
				self:movePackageToAttentionArea(object:getValue())
			end
			function v7.onHover(object, flag: boolean)
				if flag then
					if self.state.selectedPackage ~= object:getValue() then
						self:setState({ selectedPackage = object:getValue() })
					end
				else
					self:setState({ selectedPackage = "" })
				end
			end

			children[v6] = createElement2(RobuxPackage, v7)
		end

		local children2 = {
			BuyRobuxPageBackground = Roact.createElement("Frame", {
				BackgroundTransparency = 0,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 1, 0),
				Visible = self.props.showBackground,
				ZIndex = 0
			}, {
				BackgroundImage = Roact.createElement("ImageLabel", {
					BackgroundTransparency = 1,
					ImageTransparency = 0,
					Image = props.themeName == ColorMode.Dark and "rbxasset://textures/AvatarEditorImages/AvatarEditor.png" or "rbxasset://textures/AvatarEditorImages/AvatarEditor_LightTheme.png",
					Size = UDim2.new(1, 0, 1, 0)
				}),
				Backdrop = Roact.createElement("Frame", {
					BackgroundTransparency = props.themeName == ColorMode.Dark and 0.5 or 0.7,
					BackgroundColor3 = Color3.new(0, 0, 0),
					Size = UDim2.new(1, 0, 1, 0)
				})
			}),
			CloseButton = 0,
			MessageBannerAnimator = 0,
			RobuxBalanceFrame = 0,
			BannerFrame = 0,
			RobuxPackageTilesFrame = 0
		}

		local createElement2 = Roact.createElement
		local position

		if isConsoleSize then
			position = UDim2.new(0, 48, 1, -36)
		else
			position = UDim2.new(0, 48 * self:getScale(), 0, 48 * self:getScale())
		end

		children2.CloseButton = createElement2(ImageSetButton, {
			Position = position,
			AnchorPoint = Vector2.new(0, 0),
			Size = UDim2.new(0, 36, 0, 36),
			Image = iconsnavigationclose,
			BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 0.7,
			BorderSizePixel = 0,
			SelectionImageObject = callback(CursorKind.RoundedRect),
			Visible = self.props.showCloseButton,
			[Roact.Event.Activated] = props.onPageClose
		}, {
			UICorner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 16 * self:getScale())
			})
		})

		children2.MessageBannerAnimator = Roact.createElement(Animator, {
			shouldAnimate = props.shouldAnimate,
			shouldShow = self.state.showMessageBanner,
			animateDown = true,
			ZIndex = 10,
			renderChildren = function()
				local createElement3 = Roact.createElement
				local v6 = {
					AnchorPoint = Vector2.new(0, 0),
					BackgroundTransparency = 0,
					BackgroundColor3 = 0,
					Position = 0,
					Size = 0
				}
				local backgroundColor

				if props.themeName == ColorMode.Dark then
					backgroundColor = Color3.fromRGB(17, 18, 20)
				else
					backgroundColor = Color3.fromRGB(198, 203, 206)
				end

				v6.BackgroundColor3 = backgroundColor

				v6.Position = UDim2.fromOffset(48 * self:getScale(), 40 * self:getScale())
				v6.Size = UDim2.new(1, -96 * self:getScale(), 0, textSize * 2)
				return createElement3("Frame", v6, {
					UICorner = Roact.createElement("UICorner", {
						CornerRadius = UDim.new(0, 16 * self:getScale())
					}),
					Icon = Roact.createElement(ImageSetLabel, {
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						Image = iconslogoblock,
						ImageColor3 = theme.TextEmphasis.Color,
						ImageTransparency = 0,
						Position = UDim2.fromOffset(24 * self:getScale(), textSize),
						Size = UDim2.fromOffset(36 * self:getScale(), 36 * self:getScale())
					}),
					AlertMessage = Roact.createElement(FitTextLabel, {
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.fromOffset(80 * self:getScale(), textSize),
						LayoutOrder = 2,
						width = FitTextLabel.Width.FitToText,
						Text = data.SuccessfulMessage,
						Font = font.Header1.Font,
						TextColor3 = theme.TextEmphasis.Color,
						TextTransparency = theme.TextEmphasis.Transparency,
						TextSize = textSize,
						TextXAlignment = Enum.TextXAlignment.Left,
						BackgroundTransparency = 1
					})
				})
			end
		})

		local createElement3 = Roact.createElement
		local position2

		if isConsoleSize then
			position2 = UDim2.new(0.95, 0, 1, -textSize)
		else
			position2 = UDim2.new(1, -96 * self:getScale(), 0, 48 * self:getScale())
		end

		local v6 = {
			Position = position2,
			AnchorPoint = Vector2.new(1, 0),
			height = UDim.new(0, textSize),
			contentPadding = UDim.new(0, 4),
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			BackgroundTransparency = 1
		}

		local v7 = {
			Icon = Roact.createElement(ImageSetLabel, {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(textSize + 15 * self:getScale(), textSize + 15 * self:getScale()),
				Image = iconscommongoldrobux,
				ImageTransparency = 0
			}),
			BalanceText = 0
		}

		local createElement4 = Roact.createElement
		local v8 = {
			LayoutOrder = 2,
			width = FitTextLabel.Width.FitToText,
			Text = not props.robuxBalance and "" or formatNumber(LocalizationService.RobloxLocaleId, props.robuxBalance),
			Font = font.Header1.Font,
			TextColor3 = 0,
			TextTransparency = 0,
			TextSize = 0,
			BackgroundTransparency = 1
		}
		local textColor

		if props.showBackground then
			textColor = Color3.new(255, 255, 255)
		else
			textColor = theme.TextEmphasis.Color
		end

		v8.TextColor3 = textColor
		v8.TextTransparency = theme.TextEmphasis.Transparency
		v8.TextSize = textSize
		v7.BalanceText = createElement4(FitTextLabel, v8)
		children2.RobuxBalanceFrame = createElement3(FitFrameHorizontal, v6, v7)

		local createElement5 = Roact.createElement
		local position3

		if not isConsoleSize then
			position3 = UDim2.fromOffset(96 * self:getScale(), 146 * self:getScale())
		end

		local v9 = {
			Position = position3,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = isConsoleSize and 1 or nil,
			BackgroundTransparency = 1
		}

		local children3 = {
			[1] = nil,
			[1] = nil,
			UIPadding = isConsoleSize and Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0.05, 0),
				PaddingRight = UDim.new(0.05, 0)
			}),
			(Roact.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 36 * self:getScale())
			}))
		}

		local createElement6 = Roact.createElement
		local v10 = {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextXAlignment = Enum.TextXAlignment.Left,
			FontFace = normalizeFontFace(props2.Tokens.Typography.HeadingLarge.Font),
			Text = data.BannerTitle,
			TextSize = 46 * self:getScale(),
			TextColor3 = 0
		}
		local textColor2

		if props.showBackground then
			textColor2 = Color3.new(255, 255, 255)
		else
			textColor2 = theme.TextEmphasis.Color
		end

		v10.TextColor3 = textColor2
		children3.BannerTitle = createElement6("TextLabel", v10)

		local createElement7 = Roact.createElement
		local v11 = {
			LayoutOrder = isConsoleSize and 2 or 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = isConsoleSize and true or nil,
			FontFace = normalizeFontFace(props2.Tokens.Typography.HeadingSmall.Font),
			Text = data.BannerText,
			TextSize = 38 * self:getScale(),
			TextColor3 = 0
		}
		local textColor3

		if props.showBackground then
			textColor3 = Color3.new(255, 255, 255)
		else
			textColor3 = theme.TextEmphasis.Color
		end

		v11.TextColor3 = textColor3
		children3.BannerText = createElement7("TextLabel", v11)
		children2.BannerFrame = createElement5("Frame", v9, children3)

		local createElement8 = Roact.createElement
		local position4

		if not isConsoleSize then
			position4 = UDim2.new(0, 0, 0, 310 * self:getScale())
		end

		local size

		if isConsoleSize then
			size = UDim2.fromScale(1, 0.85)
		else
			size = UDim2.new(1, 0, 0, 615 * self:getScale())
		end

		local v12 = {}
		v12.Position = position4
		v12.Size = size
		v12.LayoutOrder = isConsoleSize and 1 or nil
		v12.AutomaticSize = Enum.AutomaticSize.None
		local canvasSize

		if isConsoleSize then
			canvasSize = self.canvasSize
		else
			canvasSize = UDim2.new(0, 0, 0, 0)
		end

		v12.CanvasSize = canvasSize
		local automaticCanvasSize

		if isConsoleSize then
			automaticCanvasSize = Enum.AutomaticSize.None
		else
			automaticCanvasSize = Enum.AutomaticSize.X
		end

		v12.AutomaticCanvasSize = automaticCanvasSize
		v12.ScrollingEnabled = scrollingEnabled
		v12.ScrollingDirection = Enum.ScrollingDirection.X
		v12.ScrollBarImageTransparency = 1
		v12.ScrollBarThickness = 0
		v12.Selectable = false
		v12.BackgroundTransparency = 1

		v12[Roact.Ref] = self.scrollingFrameRef
		local absoluteSize = Roact.Change.AbsoluteSize
		local v13

		if isConsoleSize then
			v13 = self.updateCanvasSize
		end

		v12[absoluteSize] = v13
		children2.RobuxPackageTilesFrame = createElement8("ScrollingFrame", v12, children)

		if isConsoleSize then
			children2.Content = Roact.createElement(
				"Frame",
				{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 },
				{
					BottomPadding = Roact.createElement("UIPadding", {
						PaddingBottom = UDim.new(0.07, 0)
					}),
					UIListLayout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 10)
					}),
					TopBar = Roact.createElement(
						"Frame",
						{
							Size = UDim2.fromScale(1, 0.1),
							BackgroundTransparency = 1,
							LayoutOrder = 0
						},
						{
							CloseButton = children2.CloseButton,
							RobuxBalanceFrame = children2.RobuxBalanceFrame
						}
					),
					BannerFrame = children2.BannerFrame,
					RobuxList = Roact.createElement(
						"Frame",
						{
							Size = UDim2.fromScale(1, 0),
							LayoutOrder = 3,
							BackgroundTransparency = 1
						},
						{
							UIFlexItem = Roact.createElement("UIFlexItem", {
								FlexMode = Enum.UIFlexMode.Fill
							}),
							UIListLayout = Roact.createElement("UIListLayout", {
								FillDirection = Enum.FillDirection.Vertical,
								SortOrder = Enum.SortOrder.LayoutOrder
							}),
							UIPadding = Roact.createElement("UIPadding", {
								PaddingLeft = UDim.new(0.05, 0),
								PaddingRight = UDim.new(0.05, 0)
							}),
							TopPadding = Roact.createElement("Frame", {
								Size = UDim2.fromScale(0, 0.1),
								LayoutOrder = 0,
								BackgroundTransparency = 1
							}),
							RobuxPackageTilesFrame = children2.RobuxPackageTilesFrame
						}
					)
				}
			)

			children2.CloseButton = nil
			children2.RobuxBalanceFrame = nil
			children2.BannerFrame = nil
			children2.RobuxPackageTilesFrame = nil
		end

		return Roact.createElement(
			FullscreenFrame,
			{ BackgroundColor3 = theme.BackgroundDefault.Color, BackgroundTransparency = 0 },
			children2
		)
	end)
end

return function(p)
	local themeName = useStyleMetadata().ThemeName

	return Roact.createElement(extended, Cryo.Dictionary.join(p, { themeName = themeName }))
end
