local LocalizationService = game:GetService("LocalizationService")
local GuiService = game:GetService("GuiService")

local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Roact")

local RoactGamepad = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/RoactGamepad")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Cryo")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/UIBlox")
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local images = UIBlox.App.ImageSet.Images
local imageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Core.Style.withStyle
local useStyleMetadata = UIBlox.Core.Style.useStyleMetadata
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local colorMode = Foundation.Enums.ColorMode
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local FitFrame = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/FitFrame")
local fitFrameHorizontal = FitFrame.FitFrameHorizontal
local fitTextLabel = FitFrame.FitTextLabel
local fullscreenFrame = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/AppBlox").FullscreenFrame

local MultiTextLocalizer = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Locale/MultiTextLocalizer")
local formatNumber = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/formatNumber")
local Animator = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Animator")

local getEnableCompensatingScrollingFrame = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/getEnableCompensatingScrollingFrame")

local getUserInputEventData = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/getUserInputEventData")

local RobuxPackage = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/BuyRobux/RobuxPackage")
local FFlagBuyRobuxPageFitToViewport = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/FFlagBuyRobuxPageFitToViewport")

local extended = Roact.Component:extend("BuyRobuxPage")

local iconscommongoldrobux = images["icons/common/goldrobux"]
local iconslogoblock = images["icons/logo/block"]
local v5 = {
	images["icons/graphic/robuxcoin1_xxlarge"],
	images["icons/graphic/robuxcoin2_xxlarge"],
	images["icons/graphic/robuxcoin3_xxlarge"],
	images["icons/graphic/robuxcoin4_xxlarge"],
	images["icons/graphic/robuxcoin5_xxlarge"],
	images["icons/graphic/robuxcoin6_xxlarge"]
}

local iconsnavigationclose = images["icons/navigation/close"]

function extended:init()
	self.state = { selectedPackage = nil, showMessageBanner = false }

	self.buttonRefs = RoactGamepad.createRefCache()
	self.scrollingFrameRef = Roact.createRef()

	if FFlagBuyRobuxPageFitToViewport then
		self.packageLayoutRef = Roact.createRef()
		local binding, v6 = Roact.createBinding(UDim2.new())
		self.canvasSize = binding
		self.setCanvasSize = v6
		function self.updateCanvasSize()
			local current = self.scrollingFrameRef.current
			local current2 = self.packageLayoutRef.current

			if current and current2 and current.AbsoluteSize.X > 0 then
				self.setCanvasSize(UDim2.fromScale(
					current2.AbsoluteContentSize.X / current.AbsoluteSize.X,
					0
				))
			end
		end
	end

	function self.getGamepadNextSelectionLeft(p2)
		return p2 > 1 and self.buttonRefs[p2 - 1] or nil
	end

	function self.getGamepadNextSelectionRight(p2)
		return p2 < #self.buttonRefs and self.buttonRefs[p2 + 1] or nil
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

function extended.didUpdate(object, p2, p3)
	local props = object.props

	if
		p2.hasNativePurchaseSucceeded ~= props.hasNativePurchaseSucceeded
		and props.hasNativePurchaseSucceeded
	then
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
	if self.props.isConsoleSize then
		return 1
	end

	return 0.65
end

function extended:render()
	return Roact.createElement(MultiTextLocalizer, {
		keys = {
			BannerText = { key = "IAPExperience.BuyRobux.Banner.Text" },
			BannerTitle = { key = "IAPExperience.BuyRobux.Banner.Title" },
			SuccessfulMessage = {
				key = "IAPExperience.BuyRobux.Alert.SuccessfulMessage"
			}
		},
		render = function(p2)
			return withSelectionCursorProvider(function(p3)
				return self:renderWithLocale(p2, p3)
			end)
		end
	})
end

function extended:movePackageToAttentionArea(p2)
	if not getEnableCompensatingScrollingFrame() then
		return
	end

	local current = self.scrollingFrameRef.current

	if current == nil or p2 == nil then
		return
	end

	local x = current.AbsoluteSize.X
	local v6 = 48 * self:getScale()

	if FFlagBuyRobuxPageFitToViewport and self.props.isConsoleSize then
		local v7 = p2.AbsolutePosition.X - current.AbsolutePosition.X - v6
		local v8 = v7 + p2.AbsoluteSize.X + 2 * v6
		local x2 = current.CanvasPosition.X

		if v7 < 0 then
			current.CanvasPosition = Vector2.new(x2 + v7, 0)
			self:reportScrollingFrameCompensationHappened()
		elseif x < v8 then
			current.CanvasPosition = Vector2.new(x2 + v8 - x, 0)
			self:reportScrollingFrameCompensationHappened()
		end
	else
		local v7 = p2.AbsolutePosition.X - v6

		if v7 < 0 then
			current.CanvasPosition = Vector2.new(v7, 0)
			self:reportScrollingFrameCompensationHappened()
		elseif x < p2.AbsolutePosition.X + p2.AbsoluteSize.X + v6 then
			current.CanvasPosition = Vector2.new(v7, 0)
			self:reportScrollingFrameCompensationHappened()
		end
	end
end

function extended:reportScrollingFrameCompensationHappened()
	local props = self.props

	if not props.onAnalyticEvent then
		return
	end

	local v6 = getUserInputEventData(props.analyticId, "", "BuyRobux", "ScrollingFrame", "Compensated")

	props.onAnalyticEvent("UserPurchaseFlow", v6)
end

function extended:renderWithLocale(data, callback)
	local props = self.props
	local isConsoleSize = FFlagBuyRobuxPageFitToViewport and props.isConsoleSize

	return withStyle(function(props2)
		local theme = props2.Theme
		local font = props2.Font

		local v6 = props.robuxPackages ~= nil
		local v7 = props.robuxPackages == nil and 6 or #props.robuxPackages

		local v8 = 32 * self:getScale()

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
		local v11 = if isConsoleSize then self.packageLayoutRef else nil
		local v10 = { [ref] = v11 }

		local absoluteContentSize = Roact.Change.AbsoluteContentSize
		local v12 = if isConsoleSize then self.updateCanvasSize else nil
		v10[absoluteContentSize] = v12
		v10.HorizontalAlignment = Enum.HorizontalAlignment.Left
		local v13 = if isConsoleSize then Enum.VerticalAlignment.Top else Enum.VerticalAlignment.Center
		v10.VerticalAlignment = v13
		v10.FillDirection = Enum.FillDirection.Horizontal
		v10.SortOrder = Enum.SortOrder.LayoutOrder
		v10.Padding = UDim.new(0, 16 * self:getScale())
		children.RobuxPackageChildren = createElement("UIListLayout", v10)

		children.TrailingPadding = not isConsoleSize and Roact.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = v7 + 1,
			Size = UDim2.new(0, 80 * self:getScale(), 0, 1)
		})

		for i = 1, v7 do
			local v14 = i + 1
			local createElement2 = Roact.createElement
			local v16 = {
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

			local v18 = if v6 then props.robuxPackages[i].packageId else tostring(i)
			v16.packageId = v18
			local v19 = if v6 then props.robuxPackages[i].robuxAmount else nil
			v16.robuxAmount = v19
			local v20 = if v6 then props.robuxPackages[i].currencyAmountStr else nil
			v16.currencyAmountStr = v20
			local v21 = if v6 then props.robuxPackages[i].robuxMoreAmount else nil
			v16.robuxMoreAmount = v21
			v16.robuxImage = v5[i]

			v16.forwardRef = self.buttonRefs[i]

			v16.nextSelectionLeft = self.getGamepadNextSelectionLeft(i)
			v16.nextSelectionRight = self.getGamepadNextSelectionRight(i)

			function v16.onActivated(p2)
				props.robuxPackageActivated(p2)
			end
			function v16.onSelect(object2)
				self:movePackageToAttentionArea(object2:getValue())
			end
			function v16.onHover(object2, p2)
				if p2 then
					if self.state.selectedPackage ~= object2:getValue() then
						self:setState({ selectedPackage = object2:getValue() })
					end
				else
					self:setState({ selectedPackage = "" })
				end
			end

			children[v14] = createElement2(RobuxPackage, v16)
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
					Image = props.themeName == colorMode.Dark and "rbxasset://textures/AvatarEditorImages/AvatarEditor.png" or "rbxasset://textures/AvatarEditorImages/AvatarEditor_LightTheme.png",
					Size = UDim2.new(1, 0, 1, 0)
				}),
				Backdrop = Roact.createElement("Frame", {
					BackgroundTransparency = props.themeName == colorMode.Dark and 0.5 or 0.7,
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

		local v15 = if isConsoleSize then UDim2.new(0, 48, 1, -36) else UDim2.new(0, 48 * self:getScale(), 0, 48 * self:getScale())
		children2.CloseButton = createElement2(imageSetButton, {
			Position = v15,
			AnchorPoint = Vector2.new(0, 0),
			Size = UDim2.new(0, 36, 0, 36),
			Image = iconsnavigationclose,
			BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 0.7,
			BorderSizePixel = 0,
			SelectionImageObject = callback(cursorKind.RoundedRect),
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
				local v17 = {
					AnchorPoint = Vector2.new(0, 0),
					BackgroundTransparency = 0,
					BackgroundColor3 = 0,
					Position = 0,
					Size = 0
				}

				local v18 = if props.themeName == colorMode.Dark then Color3.fromRGB(17, 18, 20) else Color3.fromRGB(198, 203, 206)
				v17.BackgroundColor3 = v18

				v17.Position = UDim2.fromOffset(48 * self:getScale(), 40 * self:getScale())
				v17.Size = UDim2.new(1, -96 * self:getScale(), 0, v8 * 2)
				return createElement3("Frame", v17, {
					UICorner = Roact.createElement("UICorner", {
						CornerRadius = UDim.new(0, 16 * self:getScale())
					}),
					Icon = Roact.createElement(imageSetLabel, {
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						Image = iconslogoblock,
						ImageColor3 = theme.TextEmphasis.Color,
						ImageTransparency = 0,
						Position = UDim2.fromOffset(24 * self:getScale(), v8),
						Size = UDim2.fromOffset(36 * self:getScale(), 36 * self:getScale())
					}),
					AlertMessage = Roact.createElement(fitTextLabel, {
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.fromOffset(80 * self:getScale(), v8),
						LayoutOrder = 2,
						width = fitTextLabel.Width.FitToText,
						Text = data.SuccessfulMessage,
						Font = font.Header1.Font,
						TextColor3 = theme.TextEmphasis.Color,
						TextTransparency = theme.TextEmphasis.Transparency,
						TextSize = v8,
						TextXAlignment = Enum.TextXAlignment.Left,
						BackgroundTransparency = 1
					})
				})
			end
		})

		local createElement3 = Roact.createElement

		local v18 = if isConsoleSize then UDim2.new(0.95, 0, 1, -v8) else UDim2.new(1, -96 * self:getScale(), 0, 48 * self:getScale())
		local v17 = {
			Position = v18,
			AnchorPoint = Vector2.new(1, 0),
			height = UDim.new(0, v8),
			contentPadding = UDim.new(0, 4),
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			BackgroundTransparency = 1
		}

		local v19 = {
			Icon = Roact.createElement(imageSetLabel, {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(v8 + 15 * self:getScale(), v8 + 15 * self:getScale()),
				Image = iconscommongoldrobux,
				ImageTransparency = 0
			}),
			BalanceText = 0
		}

		local createElement4 = Roact.createElement
		local v21 = {
			LayoutOrder = 2,
			width = fitTextLabel.Width.FitToText,
			Text = not props.robuxBalance and "" or formatNumber(
				LocalizationService.RobloxLocaleId,
				props.robuxBalance
			),
			Font = font.Header1.Font,
			TextColor3 = 0,
			TextTransparency = 0,
			TextSize = 0,
			BackgroundTransparency = 1
		}

		local v22 = if props.showBackground then Color3.new(255, 255, 255) else theme.TextEmphasis.Color
		v21.TextColor3 = v22
		v21.TextTransparency = theme.TextEmphasis.Transparency
		v21.TextSize = v8
		v19.BalanceText = createElement4(fitTextLabel, v21)
		children2.RobuxBalanceFrame = createElement3(fitFrameHorizontal, v17, v19)

		local createElement5 = Roact.createElement

		local v25 = if not isConsoleSize then UDim2.fromOffset(96 * self:getScale(), 146 * self:getScale()) else nil
		local v24 = {
			Position = v25,
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
		local v27 = {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextXAlignment = Enum.TextXAlignment.Left,
			Font = 0,
			FontFace = 0,
			Text = 0,
			TextSize = 0,
			TextColor3 = 0
		}

		local v28 = if not foundationFontFaceMigration then font.Title.Font else nil
		v27.Font = v28

		local v29 = if foundationFontFaceMigration then normalizeFontFace(props2.Tokens.Typography.HeadingLarge.Font) else nil
		v27.FontFace = v29

		v27.Text = data.BannerTitle
		v27.TextSize = 46 * self:getScale()

		local v30 = if props.showBackground then Color3.new(255, 255, 255) else theme.TextEmphasis.Color
		v27.TextColor3 = v30
		children3.BannerTitle = createElement6("TextLabel", v27)

		local createElement7 = Roact.createElement
		local v32 = {
			LayoutOrder = isConsoleSize and 2 or 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = isConsoleSize and true or nil,
			Font = 0,
			FontFace = 0,
			Text = 0,
			TextSize = 0,
			TextColor3 = 0
		}

		local v33 = if not foundationFontFaceMigration then font.Header1.Font else nil
		v32.Font = v33

		local v34 = if foundationFontFaceMigration then normalizeFontFace(props2.Tokens.Typography.HeadingSmall.Font) else nil
		v32.FontFace = v34

		v32.Text = data.BannerText
		v32.TextSize = 38 * self:getScale()

		local v35 = if props.showBackground then Color3.new(255, 255, 255) else theme.TextEmphasis.Color
		v32.TextColor3 = v35
		children3.BannerText = createElement7("TextLabel", v32)
		children2.BannerFrame = createElement5("Frame", v24, children3)

		local createElement8 = Roact.createElement
		local v38 = if not isConsoleSize then UDim2.new(0, 0, 0, 310 * self:getScale()) else nil
		local v39 = if isConsoleSize then UDim2.fromScale(1, 0.85) else UDim2.new(1, 0, 0, 615 * self:getScale())
		local v37 = {}
		v37.Position = v38
		v37.Size = v39
		v37.LayoutOrder = isConsoleSize and 1 or nil
		v37.AutomaticSize = Enum.AutomaticSize.None

		local v40 = if isConsoleSize then self.canvasSize else UDim2.new(0, 0, 0, 0)
		v37.CanvasSize = v40
		local v41 = if isConsoleSize then Enum.AutomaticSize.None else Enum.AutomaticSize.X
		v37.AutomaticCanvasSize = v41
		v37.ScrollingEnabled = v6
		v37.ScrollingDirection = Enum.ScrollingDirection.X
		v37.ScrollBarImageTransparency = 1
		v37.ScrollBarThickness = 0
		v37.Selectable = false
		v37.BackgroundTransparency = 1

		v37[Roact.Ref] = self.scrollingFrameRef
		local absoluteSize = Roact.Change.AbsoluteSize
		local v42 = if isConsoleSize then self.updateCanvasSize else nil
		v37[absoluteSize] = v42
		children2.RobuxPackageTilesFrame = createElement8("ScrollingFrame", v37, children)

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
			fullscreenFrame,
			{
				BackgroundColor3 = theme.BackgroundDefault.Color,
				BackgroundTransparency = 0
			},
			children2
		)
	end)
end

return function(p2)
	local themeName = useStyleMetadata().ThemeName

	return Roact.createElement(extended, Cryo.Dictionary.join(p2, {
		themeName = themeName
	}))
end
