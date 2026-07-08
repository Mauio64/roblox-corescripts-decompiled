local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local scriptParentParentParentParent = scriptParentParentParent.Parent
local scriptParentParentParentParentParent = scriptParentParentParentParent.Parent
local React = require(scriptParentParentParentParentParent.React)
local LuauPolyfill = require(scriptParentParentParentParentParent.LuauPolyfill)

require(scriptParent.Types)

local StyledTextLabel = require(scriptParentParentParent.Text.StyledTextLabel)
local Label = require(scriptParentParentParentParent.Core.ImageSet.ImageSetComponent).Label
local Button = require(scriptParentParentParent.Button.Button)
local ButtonType = require(scriptParentParentParent.Button.Enum.ButtonType)
local StandardButtonSize = require(scriptParentParentParentParent.Core.Button.Enum.StandardButtonSize)
local KeyLabel = scriptParentParentParent.Menu.KeyLabel
local KeyLabel2 = require(KeyLabel.KeyLabel)

require(KeyLabel.Types)

local getKeyLabelWidth = require(KeyLabel.Utilities).getKeyLabelWidth
local useStyle = require(scriptParentParentParentParent.Core.Style.useStyle)
local Constants = require(scriptParent.Constants)
local GetTextSize = require(scriptParentParentParentParent.Core.Text.GetTextSize)
local TooltipOrientation = require(scriptParentParent.Tooltip.Enum.TooltipOrientation)
local IconButton = require(scriptParentParentParentParent.App.Button.IconButton)
local IconSize = require(scriptParentParentParentParent.App.ImageSet.Enum.IconSize)
local Images = require(scriptParentParentParentParent.App.ImageSet.Images)
local UIBloxConfig = require(scriptParentParentParentParent.UIBloxConfig)

local function product(vector2: Vector2, vector2_2: Vector2) -- line: 32
	return Vector2.new(vector2.X * vector2_2.X, vector2.Y * vector2_2.Y)
end

function getOffsetPosition(vector2: Vector2, vector2_3: Vector2, p1, n1: number) -- line: 37
	-- upvalues: Constants (copy)
	local v37 = Constants.ORIENTATION_VECTOR[p1]
	local v38 = vector2_3 + Vector2.new(n1, n1)

	return vector2 + Vector2.new(v37.X * v38.X, v37.Y * v38.Y)
end

local function vectorToPosition(vector2: Vector2) -- line: 44
	return UDim2.fromOffset(vector2.X, vector2.Y)
end
local function getContentAnchorPoint(p2) -- line: 50
	-- upvalues: Constants (copy)
	return Vector2.new(0.5, 0.5) - 0.5 * Constants.ORIENTATION_VECTOR[p2]
end
local function convertPadding(n2: number?, n3: number) -- line: 55
	return UDim.new(0, n2 or n3)
end
local function addOffsets(vector2: Vector2, t1: {[any]: any}) -- line: 60
	-- upvalues: TooltipOrientation (copy)
	return vector2 + Vector2.new(t1[TooltipOrientation.Left] + t1[TooltipOrientation.Right], t1[TooltipOrientation.Top] + t1[TooltipOrientation.Bottom])
end
local function getHotkeysAndWidth(t2: {[any]: any}?, p3, p4) -- line: 68
	-- upvalues: React (copy), KeyLabel2 (copy), getKeyLabelWidth (copy), Constants (copy)
	if not t2 or #t2 == 0 then
		return nil, p3
	end

	local t3 = {}
	local n4 = 0

	for i, v in ipairs(t2) do
		t3[i] = React.createElement(KeyLabel2, {
			keyCode = v,
			LayoutOrder = i
		})
		n4 += getKeyLabelWidth(v, p4)
	end

	local v52 = math.max(n4 + Constants.HOTKEY_PADDING * (#t2 - 1), p3)

	t3.Layout = React.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, Constants.HOTKEY_PADDING)
	})

	return React.createElement("Frame", {
		Name = "Hotkeys",
		BackgroundTransparency = 1,
		LayoutOrder = 3,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromOffset(v52, 0)
	}, t3), v52
end
local function TooltipWithRef(p5, p6) -- line: 104
	-- upvalues: React (copy), useStyle (copy), Constants (copy), GetTextSize (copy), UIBloxConfig (copy), getHotkeysAndWidth (copy), LuauPolyfill (copy), ButtonType (copy), StandardButtonSize (copy), Button (copy), TooltipOrientation (copy), Label (copy), StyledTextLabel (copy), IconButton (copy), Images (copy), IconSize (copy)
	assert(p5.headerText or p5.bodyText, "Must supply either header or body")
	assert(not (p5.renderCustomComponents and p5.buttonProps), "renderCustomComponents and buttonProps are not compatible")

	local v55, v56 = React.useState(Vector2.zero)
	local v57 = useStyle()
	local v58 = p5.textAlignment or Enum.TextXAlignment.Left
	local v59 = Enum.HorizontalAlignment[v58.Name]
	local Theme = v57.Theme
	local Font = v57.Font
	local Settings = v57.Settings
	local BaseSize = Font.BaseSize
	local CaptionHeader = Font.CaptionHeader
	local v65 = BaseSize * CaptionHeader.RelativeSize
	local v66 = Constants.MAX_WIDTH - (p5.PaddingLeft or Constants.DEFAULT_PADDING) - (p5.PaddingRight or Constants.DEFAULT_PADDING)
	local vector2 = Vector2.new(v66, 1e999)
	local n5 = 0
	local v69 = nil

	if p5.headerText then
		local vector2_4 = Vector2.new(v66, 2 * v65)
		local v71 = vector2_4

		if p5.onClose then
			v71 -= Vector2.new(Constants.CLOSE_BUTTON_SIZE, 0)
		end

		v69 = GetTextSize(p5.headerText, v65, CaptionHeader.Font, v71):Min(vector2_4)
		n5 = math.max(n5, v69.X)
	end

	local v72 = if not UIBloxConfig.enableTooltipV2BodyFontFix then Font.CaptionBody else Font.BodySmall
	local v73 = nil

	if p5.bodyText then
		v73 = GetTextSize(p5.bodyText, BaseSize * v72.RelativeSize, v72.Font, vector2)
		n5 = math.max(n5, v73.X)
	end

	if p5.minContentWidth then
		n5 = math.max(n5, p5.minContentWidth)
	end

	local v74, v75 = getHotkeysAndWidth(p5.hotkeyCodes, n5, Font)
	local t4 = nil

	if p5.renderCustomComponents then
		t4 = {
			Content = p5.renderCustomComponents(v75),
			SizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = vector2
			})
		}
	elseif p5.buttonProps then
		local v77 = LuauPolyfill.Object.assign({}, p5.buttonProps, {
			buttonType = ButtonType.PrimarySystem,
			standardSize = StandardButtonSize.XSmall,
			fontStyle = CaptionHeader
		})

		t4 = {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Right
			}),
			SizeContraint = React.createElement("UISizeConstraint", {
				MinSize = Vector2.new(0, 28)
			}),
			Button = React.createElement(Button, v77)
		}
	end

	local v78 = t4 and React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 4,
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.new(0, v75, 0, 0),
		Name = not p5.renderCustomComponents and "ButtonFrame" or "CustomComponents"
	}, t4)
	local v86

	if v74 and v78 then
		local createElement = React.createElement
		local t5 = {
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			AutomaticSize = Enum.AutomaticSize.XY,
			Size = UDim2.new(0, v75, 0, 0)
		}
		local t6 = {}
		local createElement2 = React.createElement
		local t7 = {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}
		local listPadding = p5.listPadding
		local DEFAULT_LIST_PADDING = Constants.DEFAULT_LIST_PADDING

		t7.Padding = UDim.new(0, listPadding or DEFAULT_LIST_PADDING)
		t7.SortOrder = Enum.SortOrder.LayoutOrder
		t6.Layout = createElement2("UIListLayout", t7)
		t6.Hotkeys = v74
		t6.CustomContent = v78
		v86 = createElement("Frame", t5, t6)
	else
		v86 = v74 or v78
	end

	local v87 = if not p5.useLargeDropShadow then Constants.DropShadow.Small else Constants.DropShadow.Large
	local v88 = Constants.OPPOSITE_ORIENTATION[p5.orientation]
	local OFFSET = v87.OFFSET
	local v90 = v55 + Vector2.new(OFFSET[TooltipOrientation.Left] + OFFSET[TooltipOrientation.Right], OFFSET[TooltipOrientation.Top] + OFFSET[TooltipOrientation.Bottom])
	local v91 = table.clone(v87.OFFSET)
	local v92 = Constants.CONTENT_TO_CARET_TIP - v91[v88]
	local v93 = math.max(0, v92)

	v91[v88] = v91[v88] + v93

	local vector2_5 = Vector2.new(v91[TooltipOrientation.Left], v91[TooltipOrientation.Top])
	local v95 = Vector2.zero:Max(Constants.ORIENTATION_VECTOR[p5.orientation] * v93)
	local orientation = p5.orientation
	local v97 = Vector2.new(0.5, 0.5) - 0.5 * Constants.ORIENTATION_VECTOR[orientation]
	local v98 = vector2_5 + Vector2.new(v55.X * v97.X, v55.Y * v97.Y) - p5.contentOffsetVector + Constants.ORIENTATION_VECTOR[v88] * Constants.CONTENT_TO_CARET_CENTER
	local v99 = v55 + Vector2.new(v91[TooltipOrientation.Left] + v91[TooltipOrientation.Right], v91[TooltipOrientation.Top] + v91[TooltipOrientation.Bottom])
	local v100 = math.floor(p5.distanceOffset + 0.5)
	local v101 = getOffsetPosition(p5.triggerPointCenter, p5.triggerPointRadius, p5.orientation, Constants.CARET_DISTANCE + math.min(0, v92) + v100) + p5.contentOffsetVector
	local BackgroundUIDefault = Theme.BackgroundUIDefault
	local v103 = p5.backgroundColor or BackgroundUIDefault.Color
	local v104 = (p5.backgroundTransparency or BackgroundUIDefault.Transparency) * Settings.PreferredTransparency
	local createElement = React.createElement
	local t8 = {
		BorderSizePixel = 0,
		GroupTransparency = p5.transparency,
		Position = UDim2.fromOffset(v101.X, v101.Y),
		Size = UDim2.fromOffset(v99.X, v99.Y)
	}
	local orientation2 = p5.orientation

	t8.AnchorPoint = Vector2.new(0.5, 0.5) - 0.5 * Constants.ORIENTATION_VECTOR[orientation2]
	t8.BackgroundTransparency = not p5.canvasBackground and 1 or p5.canvasBackground.Transparency
	t8.BackgroundColor3 = if not p5.canvasBackground then nil else p5.canvasBackground.Color

	local t9 = {
		Caret = React.createElement(Label, {
			BackgroundTransparency = 1,
			ZIndex = 2,
			Image = Constants.CARET_IMAGE,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromOffset(v98.X, v98.Y),
			Size = Constants.CARET_SIZE,
			Rotation = Constants.CARET_ROTATION[p5.orientation],
			ImageColor3 = v103,
			ImageTransparency = v104
		}),
		DropShadow = React.createElement(Label, {
			BackgroundTransparency = 1,
			ZIndex = 1,
			Image = v87.IMAGE,
			ImageColor3 = Theme.DropShadow.Color,
			ImageTransparency = Theme.DropShadow.Transparency,
			Position = UDim2.fromOffset(v95.X, v95.Y),
			Size = UDim2.fromOffset(v90.X, v90.Y),
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = v87.SLICE_CENTER
		})
	}
	local createElement3 = React.createElement
	local t10 = {
		AutomaticSize = Enum.AutomaticSize.XY,
		Position = UDim2.fromOffset(vector2_5.X, vector2_5.Y),
		BackgroundColor3 = v103,
		BackgroundTransparency = v104,
		[React.Change.AbsoluteSize] = function(p7) -- line: 293
			-- upvalues: v56 (copy), p5 (copy)
			v56(p7.AbsoluteSize)

			if p5.onContentSizeChanged then
				p5.onContentSizeChanged(p7.AbsoluteSize)
			end
		end,
		ref = p6,
		ZIndex = 2
	}
	local t11 = {}
	local createElement4 = React.createElement
	local t12 = {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = v59,
		SortOrder = Enum.SortOrder.LayoutOrder
	}
	local listPadding = p5.listPadding
	local DEFAULT_LIST_PADDING = Constants.DEFAULT_LIST_PADDING

	t12.Padding = UDim.new(0, listPadding or DEFAULT_LIST_PADDING)
	t11.Layout = createElement4("UIListLayout", t12)

	local createElement5 = React.createElement
	local t13 = {}
	local PaddingTop = p5.PaddingTop
	local DEFAULT_PADDING = Constants.DEFAULT_PADDING

	t13.PaddingTop = UDim.new(0, PaddingTop or DEFAULT_PADDING)

	local PaddingBottom = p5.PaddingBottom
	local DEFAULT_PADDING2 = Constants.DEFAULT_PADDING

	t13.PaddingBottom = UDim.new(0, PaddingBottom or DEFAULT_PADDING2)

	local PaddingLeft = p5.PaddingLeft
	local DEFAULT_PADDING3 = Constants.DEFAULT_PADDING

	t13.PaddingLeft = UDim.new(0, PaddingLeft or DEFAULT_PADDING3)

	local PaddingRight = p5.PaddingRight
	local DEFAULT_PADDING4 = Constants.DEFAULT_PADDING

	t13.PaddingRight = UDim.new(0, PaddingRight or DEFAULT_PADDING4)
	t11.Padding = createElement5("UIPadding", t13)
	t11.Corner = React.createElement("UICorner", {
		CornerRadius = Constants.CORNER_RADIUS
	})

	local headerText = p5.headerText

	if headerText then
		local createElement6 = React.createElement
		local v128 = StyledTextLabel
		local t14 = {
			layoutOrder = 1,
			fluidSizing = false,
			lineHeight = 1,
			text = p5.headerText,
			fontStyle = CaptionHeader,
			colorStyle = Theme.TextEmphasis,
			textYAlignment = Enum.TextYAlignment.Center,
			textXAlignment = v58,
			textTruncate = Enum.TextTruncate.AtEnd
		}

		t14.size = UDim2.fromOffset(v69.X, v69.Y)
		t14.richText = p5.enableHeaderRichText
		headerText = createElement6(v128, t14)
	end

	t11.Header = headerText

	local bodyText = p5.bodyText

	if bodyText then
		local createElement7 = React.createElement
		local v132 = StyledTextLabel
		local t15 = {
			layoutOrder = 2,
			fluidSizing = false,
			lineHeight = 1,
			text = p5.bodyText,
			fontStyle = v72,
			colorStyle = Theme.TextEmphasis,
			textYAlignment = Enum.TextYAlignment.Center,
			textXAlignment = v58,
			textTruncate = Enum.TextTruncate.None
		}

		t15.size = UDim2.fromOffset(v73.X, v73.Y)
		t15.richText = p5.enableBodyRichText
		bodyText = createElement7(v132, t15)
	end

	t11.Body = bodyText
	t11.Additional = v86
	t9.Box = createElement3("Frame", t10, t11)
	t9.CloseButton = p5.onClose ~= nil and React.createElement("Frame", {
		BackgroundTransparency = 1,
		ZIndex = 3,
		Size = UDim2.fromOffset(Constants.CLOSE_BUTTON_SIZE, Constants.CLOSE_BUTTON_SIZE),
		Position = UDim2.new(1, -(Constants.CLOSE_BUTTON_SIZE + Constants.CLOSE_BUTTON_PADDING * 2), 0, Constants.CLOSE_BUTTON_SIZE / 2)
	}, {
		Button = React.createElement(IconButton, {
			backgroundTransparency = 1,
			icon = Images["icons/navigation/close"],
			iconSize = IconSize.Small,
			size = UDim2.new(1, 0, 1, 0),
			onActivated = p5.onClose
		})
	})

	return createElement("CanvasGroup", t8, t9)
end

return React.forwardRef(TooltipWithRef)
