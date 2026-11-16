local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
local parent4 = parent3.Parent
local parent5 = parent4.Parent

local React = require(parent5.React)
local LuauPolyfill = require(parent5.LuauPolyfill)

require(parent.Types)
local StyledTextLabel = require(parent3.Text.StyledTextLabel)
local ImageSetComponent = require(parent4.Core.ImageSet.ImageSetComponent)
local Label = ImageSetComponent.Label
local Button = require(parent3.Button.Button)
local ButtonType = require(parent3.Button.Enum.ButtonType)
local StandardButtonSize = require(parent4.Core.Button.Enum.StandardButtonSize)

local keyLabel = parent3.Menu.KeyLabel
local KeyLabel = require(keyLabel.KeyLabel)
require(keyLabel.Types)
local Utilities = require(keyLabel.Utilities)
local getKeyLabelWidth = Utilities.getKeyLabelWidth

local useStyle = require(parent4.Core.Style.useStyle)
local Constants = require(parent.Constants)
local GetTextSize = require(parent4.Core.Text.GetTextSize)
local TooltipOrientation = require(parent2.Tooltip.Enum.TooltipOrientation)
local IconButton = require(parent4.App.Button.IconButton)
local IconSize = require(parent4.App.ImageSet.Enum.IconSize)
local Images = require(parent4.App.ImageSet.Images)
local UIBloxConfig = require(parent4.UIBloxConfig)

local function product(vector2: Vector2, vector2_2: Vector2) -- 2 equivalent calls inferred from this helper
	return Vector2.new(vector2.X * vector2_2.X, vector2.Y * vector2_2.Y)
end

function getOffsetPosition(vector2: Vector2, vector2_2: Vector2, p, p2: number)
	return vector2 + product(Constants.ORIENTATION_VECTOR[p], vector2_2 + Vector2.new(p2, p2)) -- inferred equivalent call
end

local function vectorToPosition(vector2: Vector2) -- 8 equivalent calls inferred from this helper
	return UDim2.fromOffset(vector2.X, vector2.Y)
end

local function getContentAnchorPoint(orientation) -- 2 equivalent calls inferred from this helper
	return Vector2.new(0.5, 0.5) - 0.5 * Constants.ORIENTATION_VECTOR[orientation]
end

local function convertPadding(p: number?, p2: number) -- 6 equivalent calls inferred from this helper
	return UDim.new(0, p or p2)
end

local function addOffsets(state: Vector2, p) -- 2 equivalent calls inferred from this helper
	return state + Vector2.new(
		p[TooltipOrientation.Left] + p[TooltipOrientation.Right],
		p[TooltipOrientation.Top] + p[TooltipOrientation.Bottom]
	)
end

local function getHotkeysAndWidth(hotkeyCodes, maxValue, font)
	if not hotkeyCodes or #hotkeyCodes == 0 then
		return nil, maxValue
	end

	local children = {}
	local total = 0

	for i, item in ipairs(hotkeyCodes) do
		children[i] = React.createElement(KeyLabel, { keyCode = item, LayoutOrder = i })

		total += getKeyLabelWidth(item, font)
	end

	local v = math.max(total + Constants.HOTKEY_PADDING * (#hotkeyCodes - 1), maxValue)
	children.Layout = React.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, Constants.HOTKEY_PADDING)
	})

	return React.createElement("Frame", {
		Name = "Hotkeys",
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromOffset(v, 0),
		LayoutOrder = 3
	}, children), v
end

local function TooltipWithRef(props, ref)
	assert(props.headerText or props.bodyText, "Must supply either header or body")
	assert(
		not (props.renderCustomComponents and props.buttonProps),
		"renderCustomComponents and buttonProps are not compatible"
	)

	local state, setState = React.useState(Vector2.zero)
	local v = useStyle()

	local textAlignment = props.textAlignment or Enum.TextXAlignment.Left
	local horizontalAlignment = Enum.HorizontalAlignment[textAlignment.Name]

	local theme = v.Theme
	local font = v.Font
	local settings = v.Settings

	local baseSize = font.BaseSize
	local captionHeader = font.CaptionHeader
	local v2 = baseSize * captionHeader.RelativeSize

	local v3 = Constants.MAX_WIDTH - (props.PaddingLeft or Constants.DEFAULT_PADDING) - (props.PaddingRight or Constants.DEFAULT_PADDING)
	local vector2 = Vector2.new(v3, 1e999)

	local maxValue = 0
	local v4

	if props.headerText then
		local vector2_2 = Vector2.new(v3, 2 * v2)
		local v5

		if props.onClose then
			v5 = vector2_2 - Vector2.new(Constants.CLOSE_BUTTON_SIZE, 0)
		else
			v5 = vector2_2
		end

		v4 = GetTextSize(props.headerText, v2, captionHeader.Font, v5):Min(vector2_2)
		maxValue = math.max(maxValue, v4.X)
	end

	local fontStyle

	if UIBloxConfig.enableTooltipV2BodyFontFix then
		fontStyle = font.BodySmall
	else
		fontStyle = font.CaptionBody
	end

	local v5

	if props.bodyText then
		v5 = GetTextSize(props.bodyText, baseSize * fontStyle.RelativeSize, fontStyle.Font, vector2)
		maxValue = math.max(maxValue, v5.X)
	end

	if props.minContentWidth then
		maxValue = math.max(maxValue, props.minContentWidth)
	end

	local hotkeysAndWidth, v6 = getHotkeysAndWidth(props.hotkeyCodes, maxValue, font)

	local v7 = nil

	if props.renderCustomComponents then
		v7 = {
			Content = props.renderCustomComponents(v6),
			SizeConstraint = React.createElement("UISizeConstraint", { MaxSize = vector2 })
		}
	elseif props.buttonProps then
		local v8 = LuauPolyfill.Object.assign({}, props.buttonProps, {
			buttonType = ButtonType.PrimarySystem,
			standardSize = StandardButtonSize.XSmall,
			fontStyle = captionHeader
		})

		v7 = {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Right
			}),
			SizeContraint = React.createElement("UISizeConstraint", { MinSize = Vector2.new(0, 28) }),
			Button = React.createElement(Button, v8)
		}
	end

	local customContent = v7 and React.createElement("Frame", {
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.new(0, v6, 0, 0),
		BackgroundTransparency = 1,
		LayoutOrder = 4,
		Name = props.renderCustomComponents and "CustomComponents" or "ButtonFrame"
	}, v7)
	local additional

	if hotkeysAndWidth and customContent then
		additional = React.createElement(
			"Frame",
			{
				AutomaticSize = Enum.AutomaticSize.XY,
				Size = UDim2.new(0, v6, 0, 0),
				BackgroundTransparency = 1,
				LayoutOrder = 3
			},
			{
				Layout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = convertPadding(props.listPadding, Constants.DEFAULT_LIST_PADDING), -- inferred equivalent call
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Hotkeys = hotkeysAndWidth,
				CustomContent = customContent
			}
		)
	else
		additional = hotkeysAndWidth or customContent
	end

	local v8

	if props.useLargeDropShadow then
		v8 = Constants.DropShadow.Large
	else
		v8 = Constants.DropShadow.Small
	end

	local v9 = Constants.OPPOSITE_ORIENTATION[props.orientation]
	local v10 = addOffsets(state, v8.OFFSET) -- inferred equivalent call

	local clone = table.clone(v8.OFFSET)

	local v11 = Constants.CONTENT_TO_CARET_TIP - clone[v9]
	local v12 = math.max(0, v11)

	clone[v9] += v12
	local vector2_2 = Vector2.new(clone[TooltipOrientation.Left], clone[TooltipOrientation.Top])

	local max = Vector2.zero:Max(Constants.ORIENTATION_VECTOR[props.orientation] * v12)
	local v13 = vector2_2 + product(state, getContentAnchorPoint(props.orientation)) - props.contentOffsetVector + Constants.ORIENTATION_VECTOR[v9] * Constants.CONTENT_TO_CARET_CENTER -- inferred equivalent call
	local v14 = addOffsets(state, clone) -- inferred equivalent call
	local v15 = math.floor(props.distanceOffset + 0.5)
	local v16 = getOffsetPosition(
		props.triggerPointCenter,
		props.triggerPointRadius,
		props.orientation,
		Constants.CARET_DISTANCE + math.min(0, v11) + v15
	) + props.contentOffsetVector

	local backgroundUIDefault = theme.BackgroundUIDefault
	local backgroundColor = props.backgroundColor or backgroundUIDefault.Color
	local v17 = (props.backgroundTransparency or backgroundUIDefault.Transparency) * settings.PreferredTransparency

	local createElement = React.createElement
	local v18 = {
		GroupTransparency = props.transparency,
		Position = vectorToPosition(v16), -- inferred equivalent call
		Size = vectorToPosition(v14), -- inferred equivalent call
		AnchorPoint = getContentAnchorPoint(props.orientation), -- inferred equivalent call
		BackgroundTransparency = not props.canvasBackground and 1 or props.canvasBackground.Transparency,
		BackgroundColor3 = 0,
		BorderSizePixel = 0
	}
	local backgroundColor2

	if props.canvasBackground then
		backgroundColor2 = props.canvasBackground.Color
	end

	v18.BackgroundColor3 = backgroundColor2

	local v19 = {
		Caret = React.createElement(Label, {
			Image = Constants.CARET_IMAGE,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = vectorToPosition(v13), -- inferred equivalent call
			BackgroundTransparency = 1,
			Size = Constants.CARET_SIZE,
			Rotation = Constants.CARET_ROTATION[props.orientation],
			ImageColor3 = backgroundColor,
			ImageTransparency = v17,
			ZIndex = 2
		}),
		DropShadow = React.createElement(Label, {
			Image = v8.IMAGE,
			ImageColor3 = theme.DropShadow.Color,
			ImageTransparency = theme.DropShadow.Transparency,
			BackgroundTransparency = 1,
			Position = vectorToPosition(max), -- inferred equivalent call
			Size = vectorToPosition(v10), -- inferred equivalent call
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = v8.SLICE_CENTER,
			ZIndex = 1
		}),
		Box = React.createElement("Frame", {
			AutomaticSize = Enum.AutomaticSize.XY,
			Position = vectorToPosition(vector2_2), -- inferred equivalent call
			BackgroundColor3 = backgroundColor,
			BackgroundTransparency = v17,
			[React.Change.AbsoluteSize] = function(p)
				setState(p.AbsoluteSize)

				if props.onContentSizeChanged then
					props.onContentSizeChanged(p.AbsoluteSize)
				end
			end,
			ref = ref,
			ZIndex = 2
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = horizontalAlignment,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = convertPadding(props.listPadding, Constants.DEFAULT_LIST_PADDING) -- inferred equivalent call
			}),
			Padding = React.createElement("UIPadding", {
				PaddingTop = convertPadding(props.PaddingTop, Constants.DEFAULT_PADDING), -- inferred equivalent call
				PaddingBottom = convertPadding(props.PaddingBottom, Constants.DEFAULT_PADDING), -- inferred equivalent call
				PaddingLeft = convertPadding(props.PaddingLeft, Constants.DEFAULT_PADDING), -- inferred equivalent call
				PaddingRight = convertPadding(props.PaddingRight, Constants.DEFAULT_PADDING) -- inferred equivalent call
			}),
			Corner = React.createElement("UICorner", { CornerRadius = Constants.CORNER_RADIUS }),
			Header = props.headerText and React.createElement(StyledTextLabel, {
				text = props.headerText,
				fontStyle = captionHeader,
				colorStyle = theme.TextEmphasis,
				textYAlignment = Enum.TextYAlignment.Center,
				textXAlignment = textAlignment,
				textTruncate = Enum.TextTruncate.AtEnd,
				layoutOrder = 1,
				size = vectorToPosition(v4), -- inferred equivalent call
				fluidSizing = false,
				richText = props.enableHeaderRichText,
				lineHeight = 1
			}),
			Body = props.bodyText and React.createElement(StyledTextLabel, {
				text = props.bodyText,
				fontStyle = fontStyle,
				colorStyle = theme.TextEmphasis,
				textYAlignment = Enum.TextYAlignment.Center,
				textXAlignment = textAlignment,
				textTruncate = Enum.TextTruncate.None,
				layoutOrder = 2,
				size = vectorToPosition(v5), -- inferred equivalent call
				fluidSizing = false,
				richText = props.enableBodyRichText,
				lineHeight = 1
			}),
			Additional = additional
		}),
		CloseButton = 0
	}
	local closeButton

	if props.onClose == nil then
		closeButton = false
	else
		closeButton = React.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 3,
			Size = UDim2.fromOffset(Constants.CLOSE_BUTTON_SIZE, Constants.CLOSE_BUTTON_SIZE),
			Position = UDim2.new(
				1,
				-(Constants.CLOSE_BUTTON_SIZE + Constants.CLOSE_BUTTON_PADDING * 2),
				0,
				Constants.CLOSE_BUTTON_SIZE / 2
			)
		}, {
			Button = React.createElement(IconButton, {
				backgroundTransparency = 1,
				icon = Images["icons/navigation/close"],
				iconSize = IconSize.Small,
				size = UDim2.new(1, 0, 1, 0),
				onActivated = props.onClose
			})
		})
	end

	v19.CloseButton = closeButton
	return createElement("CanvasGroup", v18, v19)
end

return React.forwardRef(TooltipWithRef)
