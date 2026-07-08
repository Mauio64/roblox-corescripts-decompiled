local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local t = require(ParentParentParent.t)
local withStyle = require(ParentParent.Core.Style.withStyle)
local validateColorInfo = require(ParentParent.Core.Style.Validator.validateColorInfo)
local withSelectionCursorProvider = require(ParentParent.App.SelectionImage.withSelectionCursorProvider)
local CursorKind = require(ParentParent.App.SelectionImage.CursorKind)

require(ParentParent.App.Style.StyleTypes)

local Object = require(ParentParentParent.LuauPolyfill).Object
local ImageSetComponent = require(ParentParentParent.UIBlox.Core.ImageSet.ImageSetComponent)
local Images = require(ParentParentParent.UIBlox.App.ImageSet.Images)
local GenericTextLabel = require(ParentParent.Core.Text.GenericTextLabel.GenericTextLabel)
local divideTransparency = require(ParentParent.Utility.divideTransparency)
local validateFontInfo = require(ParentParentParent.UIBlox.Core.Style.Validator.validateFontInfo)
local ControlState = require(ParentParentParent.UIBlox.Core.Control.Enum.ControlState)
local KeyLabel = require(script.Parent.KeyLabel.KeyLabel)
local RoundedFrame = require(script.Parent.RoundedFrame)
local Interactable = require(ParentParent.Core.Control.Interactable)
local v19 = Images["component_assets/circle_17"]
local v20 = Roact.PureComponent:extend("Cell")

v20.validateProps = t.strictInterface({
	icon = t.optional(t.union(t.table, t.string)),
	text = t.string,
	onActivated = t.callback,
	keyCodeLabel = t.optional(t.union(t.enum(Enum.KeyCode), t.strictInterface({
		key = t.enum(Enum.KeyCode),
		axis = t.optional(t.string)
	}))),
	selected = t.optional(t.boolean),
	iconColorOverride = t.optional(t.Color3),
	textColorOverride = t.optional(t.Color3),
	elementHeight = t.integer,
	hasRoundTop = t.boolean,
	hasRoundBottom = t.boolean,
	hasDivider = t.boolean,
	disabled = t.optional(t.boolean),
	stayOnActivated = t.optional(t.boolean),
	renderRightSideGadget = t.optional(t.callback),
	rightSideGadgetSize = t.optional(t.Vector2),
	leftPaddingOffset = t.optional(t.number),
	layoutOrder = t.integer,
	setButtonRef = t.optional(t.union(t.callback, t.table)),
	cursorKind = t.optional(CursorKind.isEnumValue),
	isElementBackgroundVisible = t.optional(t.boolean),
	dividerOffset = t.optional(t.number),
	dividerSize = t.optional(t.number),
	fontStyle = t.optional(t.union(t.string, validateFontInfo)),
	iconSize = t.optional(t.integer),
	selectedIconSize = t.optional(t.integer),
	iconPaddingLeft = t.optional(t.integer),
	textPadding = t.optional(t.strictInterface({
		left = t.integer,
		right = t.integer
	})),
	selectedIconPaddingRight = t.optional(t.integer),
	keyLabelPaddingRight = t.optional(t.integer),
	textOnlyPadding = t.optional(t.integer),
	borderCornerRadius = t.optional(t.integer),
	background = t.optional(validateColorInfo),
	selectionOrder = t.optional(t.number),
	selectionCursor = t.optional(t.table)
})
v20.defaultProps = {
	selected = false,
	disabled = false,
	rightSideGadgetSize = nil,
	leftPaddingOffset = 0,
	isElementBackgroundVisible = true,
	dividerOffset = 0,
	dividerSize = 1,
	iconSize = 36,
	selectedIconSize = 16,
	iconPaddingLeft = 12,
	selectedIconPaddingRight = 24,
	textOnlyPadding = 24,
	keyLabelPaddingRight = 16,
	borderCornerRadius = 4,
	textPadding = {
		left = 12,
		right = 12
	}
}

function v20.init(p1) -- line: 134
	-- upvalues: ControlState (copy)
	p1.state = {
		keyLabelWidth = 0,
		controlState = ControlState.Default
	}

	function p1.keyLabelSizeChanged(p2) -- line: 141
		-- upvalues: p1 (copy)
		p1:setState({
			keyLabelWidth = p2.AbsoluteSize.X
		})
	end
	function p1.setControlState(p3) -- line: 147
		-- upvalues: p1 (copy)
		p1:setState({
			controlState = p3
		})
	end
	function p1.onStateChanged(_, p5) -- line: 153
		-- upvalues: p1 (copy)
		p1.setControlState(p5)
	end
end
function v20.getImageProperties(p6) -- line: 158
	-- upvalues: v19 (copy), Images (copy)
	local ImageRectSize = v19.ImageRectSize
	local ImageRectOffset = v19.ImageRectOffset
	local v25 = 8 * Images.ImagesResolutionScale
	local v26 = 8 * Images.ImagesResolutionScale
	local rect = Rect.new(v25, v26, ImageRectSize.x - v25, ImageRectSize.y - v26)
	local ImageRectSizeX = ImageRectSize.X
	local v29 = math.floor(ImageRectSizeX / 2)

	if p6.props.hasRoundTop and p6.props.hasRoundBottom then
		return ImageRectSize, ImageRectOffset, rect
	end

	if p6.props.hasRoundTop then
		return Vector2.new(ImageRectSizeX, v29), ImageRectOffset, (Rect.new(v29 - 1, v29 - 1, v29 + 1, v29))
	end

	if p6.props.hasRoundBottom then
		return Vector2.new(ImageRectSizeX, v29), ImageRectOffset + Vector2.new(0, v29), (Rect.new(v29 - 1, 0, v29 + 1, 1))
	end

	return Vector2.new(1, 1), ImageRectOffset + Vector2.new(v29, v29), (Rect.new(0, 0, 0, 0))
end
function v20.renderRoundedBackground(t1: {[any]: any}, n1: number, p7) -- line: 192
	-- upvalues: Roact (copy), RoundedFrame (copy)
	local uDim = UDim.new(0, t1.props.borderCornerRadius)

	return Roact.createElement(RoundedFrame, {
		zIndex = n1,
		background = p7,
		topCornerRadius = if not t1.props.hasRoundTop then nil else uDim,
		bottomCornerRadius = if not t1.props.hasRoundBottom then nil else uDim
	})
end
function v20.renderWithSelectionCursor(p8, _) -- line: 202
	-- upvalues: withStyle (copy), ControlState (copy), divideTransparency (copy), Object (copy), Roact (copy), ImageSetComponent (copy), GenericTextLabel (copy), KeyLabel (copy), Images (copy), Interactable (copy)
	return withStyle(function(p10) -- line: 203
		-- upvalues: p8 (copy), ControlState (copy), divideTransparency (copy), Object (copy), Roact (copy), ImageSetComponent (copy), GenericTextLabel (copy), KeyLabel (copy), Images (copy), Interactable (copy)
		local Theme = p10.Theme
		local p10Font = p10.Font
		local Settings = p10.Settings
		local textOnlyPadding = p8.props.textOnlyPadding

		if p8.props.icon then
			textOnlyPadding = p8.props.iconPaddingLeft
		end

		local v46 = textOnlyPadding + p8.props.leftPaddingOffset
		local n2 = 0

		if p8.props.keyCodeLabel then
			n2 = p8.props.keyLabelPaddingRight
		elseif p8.props.selected then
			n2 = p8.props.selectedIconPaddingRight
		end

		local t2 = {
			Transparency = 1,
			Color = Color3.new(1, 1, 1)
		}

		if p8.state.controlState == ControlState.Pressed then
			t2 = Theme.BackgroundOnPress
		elseif p8.state.controlState == ControlState.Hover then
			t2 = Theme.BackgroundOnHover
		end

		local v49, v50, v51 = p8:getImageProperties()
		local n3 = 0
		local v53 = true
		local v54

		if p8.props.rightSideGadgetSize ~= nil then
			v54 = p8.props.rightSideGadgetSize.X + p8.props.iconPaddingLeft + p8.props.iconSize + p8.props.textPadding.left
		else
			if p8.props.icon then
				v53 = false
				v46 = p8.props.iconPaddingLeft
				n3 = p8.props.iconPaddingLeft + p8.props.iconSize
			end

			if p8.props.selected then
				v53 = false
				n3 = n3 + p8.props.selectedIconSize + p8.props.selectedIconPaddingRight
			end

			if p8.props.keyCodeLabel then
				v53 = false
				n3 = n3 + p8.props.keyLabelPaddingRight + p8.state.keyLabelWidth
			end

			v54 = if not v53 then n3 + p8.props.textPadding.left + p8.props.textPadding.right else n3 + p8.props.textOnlyPadding * 2
		end

		local TextEmphasis = Theme.TextEmphasis

		if p8.props.textColorOverride then
			TextEmphasis = {
				Color = p8.props.textColorOverride,
				Transparency = Theme.TextEmphasis.Transparency
			}
		end

		if p8.state.controlState == ControlState.Pressed or p8.props.disabled then
			TextEmphasis = {
				Color = TextEmphasis.Color,
				Transparency = divideTransparency(Theme.TextEmphasis.Transparency, 2)
			}
		end

		local BackgroundUIDefault = Theme.BackgroundUIDefault
		local v57 = Object.assign({}, {
			Color = BackgroundUIDefault.Color,
			Transparency = BackgroundUIDefault.Transparency
		}, p8.props.background)

		v57.Transparency = v57.Transparency * Settings.PreferredTransparency

		local t3 = {
			Background = if not p8.props.isElementBackgroundVisible then nil else p8:renderRoundedBackground(-1, v57),
			Divider = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundColor3 = Theme.Divider.Color,
				BackgroundTransparency = Theme.Divider.Transparency,
				Size = UDim2.new(1, -p8.props.dividerOffset, 0, p8.props.dividerSize),
				Position = UDim2.new(0, p8.props.dividerOffset, 1, 0),
				AnchorPoint = Vector2.new(0, 1),
				Visible = p8.props.hasDivider
			}),
			StateOverlay = p8:renderRoundedBackground(2, t2),
			LeftAlignedContent = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1)
			}, {
				Layout = Roact.createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, p8.props.textPadding.left)
				}),
				LeftPadding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v46)
				}),
				Icon = p8.props.icon and Roact.createElement(ImageSetComponent.Label, {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Image = p8.props.icon,
					Size = UDim2.fromOffset(p8.props.iconSize, p8.props.iconSize),
					ImageColor3 = p8.props.iconColorOverride or Theme.IconEmphasis.Color,
					ImageTransparency = divideTransparency(Theme.IconEmphasis.Transparency, not p8.props.disabled and 1 or 2)
				}),
				Text = Roact.createElement(GenericTextLabel, {
					BackgroundTransparency = 1,
					TextWrapped = false,
					LayoutOrder = 2,
					fontStyle = p8.props.fontStyle or p10Font.Header2,
					colorStyle = TextEmphasis,
					Size = UDim2.new(1, -v54, 1, 0),
					Text = p8.props.text,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextXAlignment = Enum.TextXAlignment.Left
				})
			}),
			RightAlignedContent = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1)
			}, {
				Layout = Roact.createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, p8.props.textPadding.right)
				}),
				RightPadding = Roact.createElement("UIPadding", {
					PaddingRight = UDim.new(0, n2)
				}),
				RightSideContent = p8.props.renderRightSideGadget and (not not p8.props.rightSideGadgetSize and Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 3,
					Size = UDim2.fromOffset(p8.props.rightSideGadgetSize.X, p8.props.rightSideGadgetSize.Y)
				}, p8.props.renderRightSideGadget())) or Roact.createFragment({
					KeyLabel = p8.props.keyCodeLabel and Roact.createElement(KeyLabel, {
						keyCode = p8.props.keyCodeLabel,
						LayoutOrder = 2,
						[Roact.Change.AbsoluteSize] = p8.keyLabelSizeChanged
					}),
					SelectedIcon = Roact.createElement(ImageSetComponent.Label, {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						Image = Images["icons/status/success_small"],
						Size = UDim2.fromOffset(p8.props.selectedIconSize, p8.props.selectedIconSize),
						ImageColor3 = Theme.IconEmphasis.Color,
						ImageTransparency = Theme.IconEmphasis.Transparency,
						Visible = p8.props.selected
					})
				})
			})
		}

		return Roact.createElement(Interactable, {
			Size = UDim2.new(1, 0, 0, p8.props.elementHeight),
			BackgroundTransparency = 1,
			Image = nil,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = v51,
			ImageRectSize = v49,
			ImageRectOffset = v50,
			SliceScale = 1 / Images.ImagesResolutionScale,
			ImageTransparency = 1,
			ImageColor3 = v57.Color,
			AutoButtonColor = false,
			LayoutOrder = p8.props.layoutOrder,
			BorderSizePixel = 0,
			[Roact.Ref] = p8.props.setButtonRef,
			SelectionImageObject = p8.props.selectionCursor,
			SelectionOrder = p8.props.selectionOrder,
			onStateChanged = p8.onStateChanged,
			[Roact.Event.Activated] = p8.props.onActivated,
			isDisabled = p8.props.disabled
		}, t3)
	end)
end
function v20.render(p11) -- line: 417
	-- upvalues: withSelectionCursorProvider (copy)
	return withSelectionCursorProvider(function(p12) -- line: 418
		-- upvalues: p11 (copy)
		return p11:renderWithSelectionCursor(p12)
	end)
end

return v20
