local parent = script.Parent.Parent
local parent2 = parent.Parent

local LocalizationService = game:GetService("LocalizationService")
local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")

local Roact = require(parent2.Roact)
local React = require(parent2.React)

local UIBlox = require(parent2.UIBlox)
local Foundation = require(parent2.Foundation)
local Skeleton = Foundation.Skeleton
local useTokens = Foundation.Hooks.useTokens

local useStyleMetadata = UIBlox.Core.Style.useStyleMetadata
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Core.Style.withStyle
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local useCursor = UIBlox.App.SelectionCursor.useCursor

local RoactGamepad = require(parent2.RoactGamepad)

local RoactFitComponents = require(parent2.RoactFitComponents)
local FitFrameHorizontal = RoactFitComponents.FitFrameHorizontal
local FitTextLabel = RoactFitComponents.FitTextLabel

local MultiTextLocalizer = require(parent.Locale.MultiTextLocalizer)
local FFlagBuyRobuxPageFitToViewport = require(parent.Flags.FFlagBuyRobuxPageFitToViewport)
local formatNumber = require(parent.Utility.formatNumber)

local iconscommonrobux = Images["icons/common/robux"]

local vector2 = Vector2.new(397, 440)

local v = {}
local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function renderWithProviders(props, p, p2, selectionImageObject, _, p3, ref)
	local fitToViewport = FFlagBuyRobuxPageFitToViewport and props.fitToViewport

	if props.robuxAmount == nil then
		local createElement = Roact.createElement
		local size

		if fitToViewport then
			size = UDim2.fromScale(0, 0.9)
		else
			size = UDim2.new(0, props.scale * 404, 0, props.scale * 448)
		end

		local layoutOrder

		if fitToViewport then
			layoutOrder = props.layoutOrder
		end

		local aspectRatio

		if fitToViewport then
			aspectRatio = Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = 101 / 112,
				AspectType = Enum.AspectType.ScaleWithParentSize,
				DominantAxis = Enum.DominantAxis.Height
			})
		end

		return createElement("Frame", {
			BackgroundTransparency = 1,
			Size = size,
			LayoutOrder = layoutOrder
		}, {
			AspectRatio = aspectRatio,
			SizeConstraint = fitToViewport and Roact.createElement("UISizeConstraint", {
				MaxSize = vector2
			}),
			ShimmerPanel = Roact.createElement(Skeleton, { Size = UDim2.new(1, 0, 1, 0) })
		})
	else
		local theme = p2.Theme
		local font = p2.Font

		local textSize = props.scale * 64
		local text = formatNumber(LocalizationService.RobloxLocaleId, props.robuxAmount)
		local v2

		if fitToViewport then
			local formatted = `{text}|{textSize}`
			v2 = v[formatted]

			if v2 == nil then
				v2 = TextService:GetTextSize(text, textSize, font.Title.Font, Vector2.new(10000, 10000)).X
				v[formatted] = v2
			end
		else
			v2 = 0
		end

		local color3 = p3.Color.Surface.Surface_100.Color3

		if props.selected then
			color3 = color3:Lerp(p3.Color.Surface.Surface_200.Color3, 0.5)
		end

		local createElement = Roact.createElement
		local v3 = RoactGamepad.Focusable[ImageSetButton]
		local v4 = {
			["LayoutOrder"] = nil,
			["LayoutOrder"] = nil,
			["LayoutOrder"] = nil,
			["LayoutOrder"] = nil,
			["LayoutOrder"] = nil,
			["LayoutOrder"] = nil,
			["LayoutOrder"] = nil,
			["LayoutOrder"] = nil,
			["LayoutOrder"] = nil,
			["LayoutOrder"] = nil,
			["LayoutOrder"] = nil,
			["LayoutOrder"] = nil,
			["LayoutOrder"] = nil,
			["LayoutOrder"] = nil,
			LayoutOrder = props.layoutOrder,
			BackgroundColor3 = theme.UIEmphasis.Color,
			BackgroundTransparency = theme.UIEmphasis.Transparency
		}
		local size

		if fitToViewport then
			size = UDim2.fromScale(0, 0.9)
		else
			size = UDim2.new(0, props.scale * 404, 0, props.scale * 448)
		end

		v4.Size = size

		v4.Image = nil

		v4.SelectionImageObject = selectionImageObject

		v4[Roact.Ref] = props.forwardRef

		v4.NextSelectionUp = nil
		v4.NextSelectionDown = nil
		v4.NextSelectionLeft = props.nextSelectionLeft
		v4.NextSelectionRight = props.nextSelectionRight
		local activated

		if props.onActivated ~= nil then
			activated = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, function()
				props.onActivated(props.packageId)
			end)
		end

		v4.inputBindings = { Activated = activated }

		v4[Roact.Event.Activated] = function()
			props.onActivated(props.packageId)
		end
		v4[Roact.Event.MouseMoved] = function()
			props.onHover(props.forwardRef, true)
		end
		v4[Roact.Event.MouseEnter] = function()
			props.onHover(props.forwardRef, true)
		end
		v4[Roact.Event.MouseLeave] = function()
			props.onHover(props.forwardRef, false)
		end
		v4[Roact.Event.SelectionGained] = function()
			props.onSelect(props.forwardRef)
		end

		local aspectRatio

		if fitToViewport then
			aspectRatio = Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = 101 / 112,
				AspectType = Enum.AspectType.ScaleWithParentSize,
				DominantAxis = Enum.DominantAxis.Height
			})
		end

		local children = {
			AspectRatio = aspectRatio,
			SizeConstraint = fitToViewport and Roact.createElement("UISizeConstraint", {
				MaxSize = vector2
			}),
			Corner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
			Outline = 0
		}

		local createElement2 = Roact.createElement
		local v5 = {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundColor3 = color3,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Size = UDim2.new(1, -3, 1, -3)
		}
		local v6 = {
			Corner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
			MiddleContent = 0
		}

		local createElement3 = Roact.createElement
		local v7 = { BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.new(1, 0, 1, 0) }

		local createElement4 = Roact.createElement
		local paddingTop

		if fitToViewport then
			paddingTop = UDim.new(0.05, 0)
		else
			paddingTop = UDim.new(0, props.scale * 24)
		end

		local paddingBottom

		if fitToViewport then
			paddingBottom = UDim.new(0.05, 0)
		end

		local children2 = {
			[1] = nil,
			[1] = nil,
			[1] = nil,
			[1] = nil,
			Padding = createElement4("UIPadding", {
				PaddingTop = paddingTop,
				PaddingBottom = paddingBottom
			}),
			(Roact.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, fitToViewport and 10 or props.scale * 17.5)
			}))
		}

		local createElement5 = Roact.createElement
		local size2

		if fitToViewport then
			size2 = UDim2.fromScale(1, 0.5)
		else
			size2 = UDim2.fromOffset(props.scale * 192, props.scale * 192)
		end

		local v8 = {
			LayoutOrder = 1,
			Size = size2,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1
		}

		local v9 = {
			AspectRatio = fitToViewport and Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = 1,
				AspectType = Enum.AspectType.FitWithinMaxSize,
				DominantAxis = Enum.DominantAxis.Width
			}),
			FlexItem = fitToViewport and Roact.createElement("UIFlexItem", {
				FlexMode = Enum.UIFlexMode.Fill
			}),
			RobuxImage = 0
		}

		local createElement6 = Roact.createElement
		local udim

		if fitToViewport then
			udim = UDim2.fromScale(1, 1)
		elseif props.selected then
			udim = UDim2.fromOffset(props.scale * 192 * 1.6, props.scale * 192 * 1.6)
		else
			udim = UDim2.fromOffset(props.scale * 192, props.scale * 192)
		end

		local ref2 = Roact.Ref

		if not fitToViewport then
			ref = nil
		end

		local v10 = {
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			Size = udim,
			[ref2] = ref
		}
		local position

		if props.selected and not fitToViewport then
			position = UDim2.new(0.5, 0, 0.3, 0)
		else
			position = UDim2.new(0.5, 0, 0.5, 0)
		end

		v10.Position = position

		v10.AnchorPoint = Vector2.new(0.5, 0.5)

		v10.BackgroundTransparency = 1
		v10.Image = props.robuxImage
		v10.ImageTransparency = 0
		v9.RobuxImage = createElement6(ImageSetLabel, v10)
		children2.RobuxImageFrame = createElement5("Frame", v8, v9)

		local createElement7 = Roact.createElement
		local v11 = {
			LayoutOrder = 2,
			AnchorPoint = Vector2.new(0.5, 0.5),
			height = 0,
			Size = 0,
			contentPadding = 0,
			FillDirection = 0,
			VerticalAlignment = 0,
			BackgroundTransparency = 1
		}
		local height

		if not fitToViewport then
			height = UDim.new(0, textSize)
		end

		v11.height = height
		local size3

		if fitToViewport then
			size3 = UDim2.fromScale(1, 0.18)
		end

		v11.Size = size3
		local contentPadding

		if not fitToViewport then
			contentPadding = UDim.new(0, 0)
		end

		v11.contentPadding = contentPadding
		local fillDirection

		if not fitToViewport then
			fillDirection = Enum.FillDirection.Horizontal
		end

		v11.FillDirection = fillDirection
		local verticalAlignment

		if not fitToViewport then
			verticalAlignment = Enum.VerticalAlignment.Center
		end

		v11.VerticalAlignment = verticalAlignment

		local children3 = {
			SizeConstraint = fitToViewport and Roact.createElement("UISizeConstraint", {
				MinSize = Vector2.new(0, 40),
				MaxSize = Vector2.new(1e999, 64)
			}),
			Layout = fitToViewport and Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Icon = 0,
			RobuxAmountText = 0
		}

		local createElement8 = Roact.createElement
		local size4

		if fitToViewport then
			size4 = UDim2.fromScale(0, 1)
		else
			size4 = UDim2.new(0, textSize, 0, textSize)
		end

		children3.Icon = createElement8(ImageSetLabel, {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = size4,
			Image = iconscommonrobux,
			ImageColor3 = theme.TextEmphasis.Color,
			ImageTransparency = theme.TextEmphasis.Transparency
		}, fitToViewport and {
			AspectRatio = Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = 1,
				AspectType = Enum.AspectType.ScaleWithParentSize,
				DominantAxis = Enum.DominantAxis.Height
			})
		} or nil)

		local createElement9 = Roact.createElement
		local width

		if not fitToViewport then
			width = FitTextLabel.Width.FitToText
		end

		local size5

		if fitToViewport then
			size5 = UDim2.fromScale(0, 1)
		end

		local v12 = {
			LayoutOrder = 2,
			width = width,
			Size = size5,
			TextScaled = fitToViewport and true or nil,
			Text = 0,
			Font = 0,
			TextColor3 = 0,
			TextTransparency = 0,
			TextSize = 0,
			BackgroundTransparency = 1
		}

		if fitToViewport then
			text = string.gsub(text, " ", " ")
		end

		v12.Text = text

		v12.Font = font.Title.Font
		v12.TextColor3 = theme.TextEmphasis.Color
		v12.TextTransparency = theme.TextEmphasis.Transparency
		v12.TextSize = textSize
		children3.RobuxAmountText = createElement9(fitToViewport and "TextLabel" or FitTextLabel, v12, {
			AspectRatio = fitToViewport and Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = v2 * 1.04 / textSize,
				AspectType = Enum.AspectType.ScaleWithParentSize,
				DominantAxis = Enum.DominantAxis.Height
			})
		})
		children2.RobuxAmount = createElement7(fitToViewport and "Frame" or FitFrameHorizontal, v11, children3)

		local createElement10 = Roact.createElement
		local v13 = {
			LayoutOrder = 3,
			AnchorPoint = Vector2.new(0.5, 0.5),
			width = 0,
			Size = 0,
			TextScaled = 0,
			TextWrapped = 0,
			Text = 0,
			Font = 0,
			TextColor3 = 0,
			TextTransparency = 0,
			TextSize = 0,
			BackgroundTransparency = 1
		}
		local width2

		if not fitToViewport then
			width2 = FitTextLabel.Width.FitToText
		end

		v13.width = width2
		local size6

		if fitToViewport then
			size6 = UDim2.fromScale(1, 0.18)
		end

		v13.Size = size6
		v13.TextScaled = fitToViewport and true or nil
		v13.TextWrapped = fitToViewport and true or nil

		v13.Text = props.currencyAmountStr

		v13.Font = font.Header1.Font
		v13.TextColor3 = theme.TextEmphasis.Color
		v13.TextTransparency = theme.TextEmphasis.Transparency
		v13.TextSize = props.scale * 32
		children2.CurrencyAmmountText = createElement10(fitToViewport and "TextLabel" or FitTextLabel, v13, {
			SizeConstraint = fitToViewport and Roact.createElement("UISizeConstraint", {
				MinSize = Vector2.new(0, 40),
				MaxSize = Vector2.new(1e999, 64)
			}),
			Padding = fitToViewport and Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0.25, 0),
				PaddingBottom = UDim.new(0.25, 0)
			})
		})
		local moreText

		if fitToViewport or props.robuxMoreAmount then
			local createElement11 = Roact.createElement
			local v14 = {
				LayoutOrder = 4,
				AnchorPoint = Vector2.new(0.5, 0.5),
				width = 0,
				Size = 0,
				TextScaled = 0,
				TextWrapped = 0,
				Text = 0,
				Font = 0,
				TextColor3 = 0,
				TextTransparency = 0,
				TextSize = 0,
				BackgroundTransparency = 1
			}
			local width3

			if not fitToViewport then
				width3 = FitTextLabel.Width.FitToText
			end

			v14.width = width3
			local size7

			if fitToViewport then
				size7 = UDim2.fromScale(1, 0.09)
			end

			v14.Size = size7
			v14.TextScaled = fitToViewport and true or nil
			v14.TextWrapped = fitToViewport and true or nil

			v14.Text = fitToViewport and props.robuxMoreAmount == nil and "" or p.moreRobux

			v14.Font = font.Header2.Font
			v14.TextColor3 = theme.TextEmphasis.Color
			v14.TextTransparency = theme.TextEmphasis.Transparency
			v14.TextSize = props.scale * 32
			moreText = createElement11(fitToViewport and "TextLabel" or FitTextLabel, v14, {
				SizeConstraint = fitToViewport and Roact.createElement("UISizeConstraint", {
					MinSize = Vector2.new(0, 22),
					MaxSize = Vector2.new(1e999, 40)
				}),
				Padding = fitToViewport and Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0.1, 0),
					PaddingBottom = UDim.new(0.1, 0)
				}),
				Gradient = Roact.createElement("UIGradient", {
					Rotation = 0,
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 251, 103)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(243, 185, 34))
					})
				})
			}) or nil
		end

		children2.MoreText = moreText
		v6.MiddleContent = createElement3("Frame", v7, children2)
		children.Outline = createElement2("Frame", v5, v6)
		return createElement(v3, v4, children)
	end
end

return function(state)
	local v2 = useCursor(UDim.new(0, 8))
	local v3 = useTokens()

	local themeName = useStyleMetadata().ThemeName

	local ref = React.useRef(nil)
	local fitToViewport = FFlagBuyRobuxPageFitToViewport and state.fitToViewport
	React.useEffect(function()
		local current = ref.current

		if not fitToViewport or current == nil then
			return nil
		end

		local v4 = state.selected and 1.2 or 1
		local udim = UDim2.fromScale(v4, v4)

		if current.Size == udim then
			return nil
		end

		local tween = TweenService:Create(current, tweenInfo, { Size = udim })
		tween:Play()
		return function()
			tween:Cancel()
		end
	end, { state.selected, fitToViewport, state.robuxAmount ~= nil })

	return Roact.createElement(MultiTextLocalizer, {
		keys = {
			moreRobux = {
				key = "IAPExperience.BuyRobux.Text.MoreRobux2",
				params = {
					robux = formatNumber(LocalizationService.RobloxLocaleId, state.robuxMoreAmount or 0)
				}
			}
		},
		render = function(p)
			return withStyle(function(p2)
				if state.scale == nil then
					state.scale = 0.65
				end

				return renderWithProviders(state, p, p2, v2, themeName, v3, ref)
			end)
		end
	})
end
