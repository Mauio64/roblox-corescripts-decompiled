local LocalizationService = game:GetService("LocalizationService")
local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")

local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Roact")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local skeleton = Foundation.Skeleton
local useTokens = Foundation.Hooks.useTokens

local useStyleMetadata = UIBlox.Core.Style.useStyleMetadata
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Core.Style.withStyle
local imageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local useCursor = UIBlox.App.SelectionCursor.useCursor

local RoactGamepad = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/RoactGamepad")

local FitFrame = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/FitFrame")
local fitFrameHorizontal = FitFrame.FitFrameHorizontal
local fitTextLabel = FitFrame.FitTextLabel

local MultiTextLocalizer = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Locale/MultiTextLocalizer")
local FFlagBuyRobuxPageFitToViewport = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/FFlagBuyRobuxPageFitToViewport")
local formatNumber = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/formatNumber")

local iconscommonrobux = images["icons/common/robux"]

local vector2 = Vector2.new(397, 440)

local v5 = {}
local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function renderWithProviders(props, p2, p3, selectionImageObject, themeName, p4, ref)
	local fitToViewport = FFlagBuyRobuxPageFitToViewport and props.fitToViewport

	if props.robuxAmount == nil then
		local createElement = Roact.createElement

		local v8 = if fitToViewport then UDim2.fromScale(0, 0.9) else UDim2.new(0, 404 * props.scale, 0, 448 * props.scale)
		local v9 = if fitToViewport then props.layoutOrder else nil

		local v11 = if fitToViewport then Roact.createElement("UIAspectRatioConstraint", {
			AspectRatio = 101 / 112,
			AspectType = Enum.AspectType.ScaleWithParentSize,
			DominantAxis = Enum.DominantAxis.Height
		}) else nil
		return createElement("Frame", {
			BackgroundTransparency = 1,
			Size = v8,
			LayoutOrder = v9
		}, {
			AspectRatio = v11,
			SizeConstraint = fitToViewport and Roact.createElement("UISizeConstraint", {
				MaxSize = vector2
			}),
			ShimmerPanel = Roact.createElement(skeleton, {
				Size = UDim2.new(1, 0, 1, 0)
			})
		})
	else
		local theme = p3.Theme
		local font = p3.Font

		local v6 = 64 * props.scale
		local v7 = formatNumber(LocalizationService.RobloxLocaleId, props.robuxAmount)
		local v8

		if fitToViewport then
			local formatted = `{v7}|{v6}`
			v8 = v5[formatted]

			if v8 == nil then
				v8 = TextService:GetTextSize(v7, v6, font.Title.Font, Vector2.new(10000, 10000)).X
				v5[formatted] = v8
			end
		else
			v8 = 0
		end

		local color3 = p4.Color.Surface.Surface_100.Color3

		if props.selected then
			color3 = color3:Lerp(p4.Color.Surface.Surface_200.Color3, 0.5)
		end

		local createElement = Roact.createElement
		local v9 = RoactGamepad.Focusable[imageSetButton]
		local v10 = {
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

		local v11 = if fitToViewport then UDim2.fromScale(0, 0.9) else UDim2.new(0, 404 * props.scale, 0, 448 * props.scale)
		v10.Size = v11

		v10.Image = nil

		v10.SelectionImageObject = selectionImageObject

		v10[Roact.Ref] = props.forwardRef

		v10.NextSelectionUp = nil
		v10.NextSelectionDown = nil
		v10.NextSelectionLeft = props.nextSelectionLeft
		v10.NextSelectionRight = props.nextSelectionRight
		local v13

		if props.onActivated ~= nil then
			v13 = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, function()
				props.onActivated(props.packageId)
			end)
		end

		v10.inputBindings = { Activated = v13 }

		v10[Roact.Event.Activated] = function()
			props.onActivated(props.packageId)
		end
		v10[Roact.Event.MouseMoved] = function()
			props.onHover(props.forwardRef, true)
		end
		v10[Roact.Event.MouseEnter] = function()
			props.onHover(props.forwardRef, true)
		end
		v10[Roact.Event.MouseLeave] = function()
			props.onHover(props.forwardRef, false)
		end
		v10[Roact.Event.SelectionGained] = function()
			props.onSelect(props.forwardRef)
		end

		local v14 = if fitToViewport then Roact.createElement("UIAspectRatioConstraint", {
			AspectRatio = 101 / 112,
			AspectType = Enum.AspectType.ScaleWithParentSize,
			DominantAxis = Enum.DominantAxis.Height
		}) else nil
		local children = {
			AspectRatio = v14,
			SizeConstraint = fitToViewport and Roact.createElement("UISizeConstraint", {
				MaxSize = vector2
			}),
			Corner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
			Outline = 0
		}

		local createElement2 = Roact.createElement
		local v16 = {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundColor3 = color3,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Size = UDim2.new(1, -3, 1, -3)
		}
		local v17 = {
			Corner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
			MiddleContent = 0
		}

		local createElement3 = Roact.createElement
		local v19 = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0)
		}

		local createElement4 = Roact.createElement
		local v22 = if fitToViewport then UDim.new(0.05, 0) else UDim.new(0, 24 * props.scale)
		local v23 = if fitToViewport then UDim.new(0.05, 0) else nil
		local children2 = {
			[1] = nil,
			[1] = nil,
			[1] = nil,
			[1] = nil,
			Padding = createElement4("UIPadding", {
				PaddingTop = v22,
				PaddingBottom = v23
			}),
			(Roact.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, fitToViewport and 10 or 17.5 * props.scale)
			}))
		}

		local createElement5 = Roact.createElement

		local v26 = if fitToViewport then UDim2.fromScale(1, 0.5) else UDim2.fromOffset(192 * props.scale, 192 * props.scale)
		local v25 = {
			LayoutOrder = 1,
			Size = v26,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1
		}

		local v27 = {
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
			udim = UDim2.fromOffset(192 * props.scale * 1.6, 192 * props.scale * 1.6)
		else
			udim = UDim2.fromOffset(192 * props.scale, 192 * props.scale)
		end

		local ref2 = Roact.Ref

		if not fitToViewport then
			ref = nil
		end

		local v29 = {
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			Size = udim,
			[ref2] = ref
		}

		local v30 = if props.selected and not fitToViewport then UDim2.new(0.5, 0, 0.3, 0) else UDim2.new(0.5, 0, 0.5, 0)
		v29.Position = v30

		v29.AnchorPoint = Vector2.new(0.5, 0.5)

		v29.BackgroundTransparency = 1
		v29.Image = props.robuxImage
		v29.ImageTransparency = 0
		v27.RobuxImage = createElement6(imageSetLabel, v29)
		children2.RobuxImageFrame = createElement5("Frame", v25, v27)

		local createElement7 = Roact.createElement
		local v32 = {
			LayoutOrder = 2,
			AnchorPoint = Vector2.new(0.5, 0.5),
			height = 0,
			Size = 0,
			contentPadding = 0,
			FillDirection = 0,
			VerticalAlignment = 0,
			BackgroundTransparency = 1
		}

		local v33 = if not fitToViewport then UDim.new(0, v6) else nil
		v32.height = v33
		local v34 = if fitToViewport then UDim2.fromScale(1, 0.18) else nil
		v32.Size = v34
		local v35 = if not fitToViewport then UDim.new(0, 0) else nil
		v32.contentPadding = v35

		local v36 = if not fitToViewport then Enum.FillDirection.Horizontal else nil
		v32.FillDirection = v36
		local v37 = if not fitToViewport then Enum.VerticalAlignment.Center else nil
		v32.VerticalAlignment = v37

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

		local v40 = if fitToViewport then UDim2.fromScale(0, 1) else UDim2.new(0, v6, 0, v6)
		children3.Icon = createElement8(imageSetLabel, {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = v40,
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

		local v43 = if not fitToViewport then fitTextLabel.Width.FitToText else nil
		local v44 = if fitToViewport then UDim2.fromScale(0, 1) else nil
		local v42 = {
			LayoutOrder = 2,
			width = v43,
			Size = v44,
			TextScaled = fitToViewport and true or nil,
			Text = 0,
			Font = 0,
			TextColor3 = 0,
			TextTransparency = 0,
			TextSize = 0,
			BackgroundTransparency = 1
		}

		if fitToViewport then
			v7 = string.gsub(v7, " ", " ")
		end

		v42.Text = v7

		v42.Font = font.Title.Font
		v42.TextColor3 = theme.TextEmphasis.Color
		v42.TextTransparency = theme.TextEmphasis.Transparency
		v42.TextSize = v6
		children3.RobuxAmountText = createElement9(fitToViewport and "TextLabel" or fitTextLabel, v42, {
			AspectRatio = fitToViewport and Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = v8 * 1.04 / v6,
				AspectType = Enum.AspectType.ScaleWithParentSize,
				DominantAxis = Enum.DominantAxis.Height
			})
		})
		children2.RobuxAmount = createElement7(
			fitToViewport and "Frame" or fitFrameHorizontal,
			v32,
			children3
		)

		local createElement10 = Roact.createElement
		local v46 = {
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

		local v47 = if not fitToViewport then fitTextLabel.Width.FitToText else nil
		v46.width = v47
		local v48 = if fitToViewport then UDim2.fromScale(1, 0.18) else nil
		v46.Size = v48
		v46.TextScaled = fitToViewport and true or nil
		v46.TextWrapped = fitToViewport and true or nil

		v46.Text = props.currencyAmountStr

		v46.Font = font.Header1.Font
		v46.TextColor3 = theme.TextEmphasis.Color
		v46.TextTransparency = theme.TextEmphasis.Transparency
		v46.TextSize = 32 * props.scale
		children2.CurrencyAmmountText = createElement10(
			fitToViewport and "TextLabel" or fitTextLabel,
			v46,
			{
				SizeConstraint = fitToViewport and Roact.createElement("UISizeConstraint", {
					MinSize = Vector2.new(0, 40),
					MaxSize = Vector2.new(1e999, 64)
				}),
				Padding = fitToViewport and Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0.25, 0),
					PaddingBottom = UDim.new(0.25, 0)
				})
			}
		)
		local v49

		if fitToViewport or props.robuxMoreAmount then
			local createElement11 = Roact.createElement
			local v51 = {
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

			local v52 = if not fitToViewport then fitTextLabel.Width.FitToText else nil
			v51.width = v52
			local v53 = if fitToViewport then UDim2.fromScale(1, 0.09) else nil
			v51.Size = v53
			v51.TextScaled = fitToViewport and true or nil
			v51.TextWrapped = fitToViewport and true or nil

			v51.Text = fitToViewport and props.robuxMoreAmount == nil and "" or p2.moreRobux

			v51.Font = font.Header2.Font
			v51.TextColor3 = theme.TextEmphasis.Color
			v51.TextTransparency = theme.TextEmphasis.Transparency
			v51.TextSize = 32 * props.scale
			v49 = createElement11(fitToViewport and "TextLabel" or fitTextLabel, v51, {
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

		children2.MoreText = v49
		v17.MiddleContent = createElement3("Frame", v19, children2)
		children.Outline = createElement2("Frame", v16, v17)
		return createElement(v9, v10, children)
	end
end

return function(state)
	local v6 = useCursor(UDim.new(0, 8))
	local v7 = useTokens()

	local themeName = useStyleMetadata().ThemeName

	local ref = React.useRef(nil)
	local fitToViewport = FFlagBuyRobuxPageFitToViewport and state.fitToViewport
	React.useEffect(function()
		local current = ref.current

		if not fitToViewport or current == nil then
			return nil
		end

		local v8 = state.selected and 1.2 or 1
		local udim = UDim2.fromScale(v8, v8)

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
		render = function(p2)
			return withStyle(function(p3)
				if state.scale == nil then
					state.scale = 0.65
				end

				return renderWithProviders(state, p2, p3, v6, themeName, v7, ref)
			end)
		end
	})
end
