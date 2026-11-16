local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Cryo = require(parent2.Cryo)
local Foundation = require(parent2.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local UIBloxConfig = require(parent.UIBloxConfig)
local Logger = require(parent.Logger)

local ControlState = require(parent.Core.Control.Enum.ControlState)
local StateLayer = require(parent.Core.Control.StateLayer)
local useStyle = require(parent.Core.Style.useStyle)
local ImageSetComponent = require(parent.Core.ImageSet.ImageSetComponent)
local Label = ImageSetComponent.Label
local NavigationTabLayout = require(parent.App.Navigation.Enum.NavigationTabLayout)
require(parent.App.ImageSet.ImagesTypes)
require(parent.App.Style.StyleTypes)
local GetTextSize = require(parent.Core.Text.GetTextSize)

local isBuilderIcon = Foundation.Utility.isBuilderIcon
local InputSize = Foundation.Enums.InputSize
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide
local Radius = Foundation.Enums.Radius
local Icon = Foundation.Icon
local Popover = Foundation.Popover
local StatusIndicator = Foundation.StatusIndicator
local Text = Foundation.Text
local View = Foundation.View

local migrateBadgeVariant = require(parent.Utility.migrateBadgeVariant)

local vector2 = Vector2.new(1e999, 1e999)

local v = {
	hasLabel = false,
	isChecked = false,
	badgeValue = nil,
	layout = NavigationTabLayout.Stacked,
	tooltipSide = PopoverSide.Right,
	tooltipAlign = PopoverAlign.Center
}

local function NavigationTabTooltip(props)
	local tokens = useStyle().Tokens

	return React.createElement(Popover.Root, { isOpen = props.isOpen }, {
		Anchor = React.createElement(Popover.Anchor, { anchorRef = props.anchorRef }),
		Content = React.createElement(Popover.Content, {
			hasArrow = false,
			align = props.align,
			side = {
				position = props.side,
				offset = props.offset or tokens.Size.Size_200
			},
			radius = Radius.Small,
			backgroundStyle = tokens.Inverse.Surface.Surface_0,
			selectionGroup = false
		}, React.createElement(View, { tag = "auto-xy padding-x-small padding-y-xsmall" }, {
			Title = React.createElement(Text, {
				Text = props.labelText,
				tag = "auto-xy text-body-small content-inverse-emphasis"
			})
		}))
	})
end

return (React.forwardRef(function(p, ref3)
	local joined = Cryo.Dictionary.join(v, p)
	local tokens = useStyle().Tokens

	local v2 = UIBloxConfig.addNavigationTabTooltipAndTruncation

	if v2 then
		if joined.layout == NavigationTabLayout.Stacked then
			v2 = joined.width ~= nil or joined.fillWidth == true
		else
			v2 = false
		end
	end

	local v3 = not joined.width and 0 or joined.width.Scale
	local v4 = not joined.width and 0 or joined.width.Offset

	local v5, v6 = React.useBinding(Vector2.zero)
	local v7 = React.useCallback(function(p2)
		local absoluteSize = p2.AbsoluteSize
		local value = v5:getValue()
		local v7

		if v2 then
			v7 = value.Y ~= absoluteSize.Y
		else
			v7 = value ~= absoluteSize
		end

		if v7 then
			v6(absoluteSize)
		end
	end, { v2 })

	local size = React.useMemo(function()
		return v5:map(function(vector2_2: Vector2)
			if v2 then
				return UDim2.new(v3, v4, 0, vector2_2.Y)
			end

			return UDim2.fromOffset(vector2_2.X, vector2_2.Y)
		end)
	end, { v2, v3, v4 })

	local ref = React.useRef(nil)

	local state, setState = React.useState(false)

	local v8 = UIBloxConfig.addNavigationTabTooltipAndTruncation and joined.enableTooltip

	if v8 then
		if joined.layout == NavigationTabLayout.Stacked then
			v8 = joined.hasLabel and joined.labelText ~= nil
		else
			v8 = false
		end
	end

	if
		UIBloxConfig.addNavigationTabTooltipAndTruncation
		and joined.enableTooltip
		and (not joined.hasLabel or joined.labelText == nil)
	then
		Logger:warning("NavigationTab enableTooltip requires hasLabel and labelText")
	end

	local ref2 = React.useRef(nil)

	local v9 = React.useCallback(function()
		if ref2.current then
			task.cancel(ref2.current)
			ref2.current = nil
		end
	end, {})

	React.useEffect(function()
		return v9
	end, { v9 })

	local onStateChanged = React.useCallback(function(p2, p3)
		if joined.onStateChanged then
			joined.onStateChanged(p2, p3)
		end

		if not v8 then
			return
		end

		v9()

		if p3 ~= ControlState.Hover and p3 ~= ControlState.Selected and p3 ~= ControlState.SelectedPressed then
			setState(false)
			return
		end

		local thread = nil
		thread = task.delay(tokens.Time.Time_500, function()
			if ref2.current ~= thread then
				return
			end

			ref2.current = nil
			setState(true)
		end)
		ref2.current = thread
	end, { joined.onStateChanged, v8, v9, tokens.Time.Time_500 })
	local fontSize

	if joined.labelTypography then
		fontSize = joined.labelTypography.FontSize

		if fontSize ~= nil and typeof(fontSize) ~= "number" then
			fontSize = fontSize:getValue()
		end
	else
		fontSize = nil
	end

	local size2 = React.useMemo(function()
		if joined.hasLabel and joined.labelText and joined.labelTypography then
			local textSize = GetTextSize(joined.labelText, fontSize, joined.labelTypography.Font, vector2)
			return UDim2.new(0, textSize.X + 2, 0, textSize.Y + 2)
		end

		return nil
	end, { joined.hasLabel, joined.labelText, joined.labelTypography, fontSize })

	local udim = UDim2.fromOffset(tokens.Size.Size_700, tokens.Size.Size_700)
	local icon

	if joined.renderIcon then
		icon = joined.renderIcon(joined.isChecked)
	else
		local image

		if joined.isChecked and joined.iconCheckedImage then
			image = joined.iconCheckedImage
		else
			image = joined.iconImage
		end

		local style

		if joined.isChecked then
			style = tokens.Color.Content.Emphasis
		else
			style = tokens.Color.Content.Default
		end

		local name = nil
		local variant = nil

		if UIBloxConfig.addFoundationNavigationTabIcon then
			if typeof(image) == "string" then
				if isBuilderIcon(image) then
					name = image
				end
			elseif typeof(image) == "table" and image.name ~= nil and isBuilderIcon(image.name) then
				name = image.name
				variant = image.variant
			end
		end

		if UIBloxConfig.addFoundationNavigationTabIcon and name ~= nil then
			icon = React.createElement(View, { tag = "size-0-0 auto-xy padding-xxsmall" }, {
				Icon = React.createElement(Icon, {
					name = name,
					size = InputSize.Large,
					variant = variant,
					style = style
				})
			})
		else
			icon = React.createElement(Label, {
				BackgroundTransparency = 1,
				Size = udim,
				Image = image,
				ScaleType = Enum.ScaleType.Fit,
				ImageColor3 = style.Color3,
				ImageTransparency = style.Transparency
			})
		end
	end

	if joined.layout == NavigationTabLayout.Stacked and joined.badgeValue ~= nil then
		icon = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = udim,
			LayoutOrder = 1
		}, {
			Icon = icon,
			Badge = React.createElement(StatusIndicator, {
				Position = UDim2.fromScale(1, 0),
				AnchorPoint = Vector2.new(0.6, 0.35),
				value = tonumber(joined.badgeValue),
				variant = migrateBadgeVariant(joined.badgeVariant),
				max = tonumber(joined.badgeValue) and 99 or nil
			})
		})
	end

	local label

	if joined.hasLabel and joined.labelText then
		local v10

		if joined.isChecked then
			v10 = tokens.Color.Content.Emphasis
		else
			v10 = tokens.Color.Content.Default
		end

		local createElement = React.createElement
		local automaticSize

		if v2 then
			automaticSize = Enum.AutomaticSize.Y
		elseif not size2 then
			automaticSize = Enum.AutomaticSize.XY
		end

		if v2 then
			size2 = UDim2.fromScale(1, 0)
		end

		local v11 = {
			AutomaticSize = automaticSize,
			Size = size2,
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextWrapped = false,
			TextTruncate = 0,
			Text = 0,
			FontFace = 0,
			TextSize = 0,
			LineHeight = 0,
			TextColor3 = 0,
			TextTransparency = 0
		}
		local textTruncate

		if v2 then
			textTruncate = Enum.TextTruncate.AtEnd
		end

		v11.TextTruncate = textTruncate
		v11.Text = joined.labelText
		local fontFace

		if joined.labelTypography then
			fontFace = normalizeFontFace(joined.labelTypography.Font)
		end

		v11.FontFace = fontFace
		local textSize

		if joined.labelTypography then
			textSize = joined.labelTypography.FontSize
		end

		v11.TextSize = textSize
		local lineHeight

		if joined.labelTypography then
			lineHeight = joined.labelTypography.LineHeight
		end

		v11.LineHeight = lineHeight
		v11.TextColor3 = v10.Color3
		v11.TextTransparency = v10.Transparency
		local uiTextSizeConstraint

		if UIBloxConfig.addNavigationTabTooltipAndTruncation and joined.labelMaxTextSize then
			uiTextSizeConstraint = React.createElement("UITextSizeConstraint", {
				MaxTextSize = joined.labelMaxTextSize
			})
		end

		label = createElement("TextLabel", v11, { UITextSizeConstraint = uiTextSizeConstraint })
	end

	local contents = nil
	local udim2 = nil

	if joined.layout == NavigationTabLayout.Stacked then
		udim2 = UDim.new(0, tokens.Radius.Medium)
		local size_1200 = tokens.Size.Size_1200
		local createElement = React.createElement
		local automaticSize

		if v2 then
			automaticSize = Enum.AutomaticSize.Y
		else
			automaticSize = Enum.AutomaticSize.XY
		end

		local size3

		if v2 then
			size3 = UDim2.new(1, 0, 0, size_1200)
		else
			size3 = UDim2.fromOffset(size_1200, size_1200)
		end

		local ref4

		if UIBloxConfig.addNavigationTabTooltipAndTruncation then
			ref4 = ref
		end

		local v10 = {
			AutomaticSize = automaticSize,
			BackgroundTransparency = 1,
			Size = size3,
			ref = ref4,
			[React.Change.AbsoluteSize] = v7
		}
		local v11 = {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, tokens.Size.Size_200),
				PaddingBottom = UDim.new(0, tokens.Size.Size_200)
			}),
			UIListLayout = 0,
			Icon = 0,
			Label = 0
		}

		local createElement2 = React.createElement
		local v12 = {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = 0
		}
		local padding

		if not UIBloxConfig.removeStackedNavigationTabIconLabelSpacing then
			padding = UDim.new(0, tokens.Size.Size_100)
		end

		v12.Padding = padding
		v11.UIListLayout = createElement2("UIListLayout", v12)

		v11.Icon = icon
		v11.Label = label
		contents = createElement("Frame", v10, v11)
	elseif joined.layout == NavigationTabLayout.Inline then
		udim2 = UDim.new(0, tokens.Size.Size_300)
		local v10 = not joined.isChecked and { Transparency = 1, Color3 = nil } or tokens.Color.State.Press

		local createElement = React.createElement
		local v11 = {
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = v10.Transparency,
			BackgroundColor3 = v10.Color3,
			Size = UDim2.fromOffset(tokens.Size.Size_1200, tokens.Size.Size_1000),
			[React.Change.AbsoluteSize] = v7
		}
		local v12 = {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, tokens.Size.Size_100),
				PaddingBottom = UDim.new(0, tokens.Size.Size_100),
				PaddingLeft = UDim.new(0, tokens.Size.Size_300),
				PaddingRight = UDim.new(0, tokens.Size.Size_300)
			}),
			UIListLayout = React.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, tokens.Size.Size_300)
			}),
			UICorner = React.createElement("UICorner", { CornerRadius = udim2 }),
			Icon = icon,
			Label = label,
			Badge = 0
		}
		local badge

		if joined.badgeValue ~= nil then
			badge = React.createElement(StatusIndicator, {
				LayoutOrder = 3,
				value = tonumber(joined.badgeValue),
				variant = migrateBadgeVariant(joined.badgeVariant),
				max = tonumber(joined.badgeValue) and 99 or nil
			})
		end

		v12.Badge = badge
		contents = createElement("Frame", v11, v12)
	end

	local createElement = React.createElement
	local v10 = {
		ref = ref3,
		Size = size,
		BackgroundTransparency = 1,
		AnchorPoint = joined.anchorPoint,
		Position = joined.position,
		LayoutOrder = joined.layoutOrder
	}
	local uiFlexItem

	if
		UIBloxConfig.addNavigationTabTooltipAndTruncation
		and joined.layout == NavigationTabLayout.Stacked
		and joined.fillWidth
	then
		uiFlexItem = React.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill })
	end

	local createElement2 = React.createElement
	local v11 = {
		affordance = "Background",
		cornerRadius = udim2,
		zIndex = 10,
		onActivated = joined.onActivated,
		onStateChanged = 0
	}

	if not UIBloxConfig.addNavigationTabTooltipAndTruncation then
		onStateChanged = joined.onStateChanged
	end

	v11.onStateChanged = onStateChanged
	local v12 = {
		UIFlexItem = uiFlexItem,
		Contents = contents,
		StateLayer = createElement2(StateLayer, v11),
		Tooltip = 0
	}
	local tooltip

	if UIBloxConfig.addNavigationTabTooltipAndTruncation and v8 then
		tooltip = React.createElement(NavigationTabTooltip, {
			isOpen = state,
			anchorRef = ref,
			labelText = joined.labelText,
			side = joined.tooltipSide,
			align = joined.tooltipAlign,
			offset = joined.tooltipOffset
		})
	end

	v12.Tooltip = tooltip
	return createElement("Frame", v10, v12)
end))
