local parent = script.Parent.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
local core = parent2.Core

local Roact = require(parent3.Roact)
local t = require(parent3.t)
local Cryo = require(parent3.Cryo)
local Foundation = require(parent3.Foundation)

local Interactable = require(core.Control.Interactable)

local ControlState = require(core.Control.Enum.ControlState)

local withStyle = require(core.Style.withStyle)
local useStyle = require(parent2.Core.Style.useStyle)
local withSelectionCursorProvider = require(parent.SelectionImage.withSelectionCursorProvider)
local useCursorByType = require(parent.SelectionCursor.useCursorByType)
local CursorType = require(parent.SelectionCursor.CursorType)
local CursorKind = require(parent.SelectionImage.CursorKind)
local ImageSetComponent = require(core.ImageSet.ImageSetComponent)
local Skeleton = Foundation.Skeleton
local IconSize = require(parent.Constant.IconSize)
local GenericTextLabel = require(core.Text.GenericTextLabel.GenericTextLabel)

local validateImage = require(core.ImageSet.Validator.validateImage)
local getContentStyle = require(core.Button.getContentStyle)
local validateTypographyInfo = require(core.Style.Validator.validateTypographyInfo)
local validateColorInfo = require(core.Style.Validator.validateColorInfo)

local StyleDefaults = require(script.Parent.StyleDefaults)

local extended = Roact.PureComponent:extend("DropdownMenuCell")

local function getColorFromMap(p, p2)
	local v = p[p2] or p[ControlState.Default]
	return { Color = v.Color, Transparency = v.Transparency }
end

local function getButtonStyle(callback, buttonStateColorMap, controlState, p, isActivated) -- 1 equivalent call inferred from this helper
	local buttonStyle = callback(buttonStateColorMap, controlState, p)

	if controlState ~= ControlState.Disabled and controlState ~= ControlState.Pressed and isActivated then
		buttonStyle.Transparency = 0.5 * buttonStyle.Transparency + 0.5
	end

	return buttonStyle
end

local function getButtonContentStyle(callback, p, p2, p3, p4, p5)
	local buttonContentStyle = callback(p, p2, p3)

	if p2 ~= ControlState.Disabled and p2 ~= ControlState.Pressed and (p4 or not p5) then
		buttonContentStyle.Transparency = 0.5 * buttonContentStyle.Transparency + 0.5
	end

	return buttonContentStyle
end

function extended:init()
	self:setState({ controlState = ControlState.Initialize })

	function self.onStateChanged(p, controlState)
		self:setState({ controlState = controlState })

		if self.props.onStateChanged then
			self.props.onStateChanged(p, controlState)
		end
	end
end

local v = t.union(
	t.interface({ [ControlState.Default] = t.string }),
	t.interface({ [ControlState.Default] = validateColorInfo })
)

extended.validateProps = t.interface({
	icon = t.optional(validateImage),
	text = t.optional(t.string),
	textFont = t.optional(validateTypographyInfo),
	buttonImage = validateImage,
	buttonStateColorMap = v,
	contentStateColorMap = v,
	textStateColorMap = t.optional(v),
	iconStateColorMap = t.optional(v),
	isDisabled = t.optional(t.boolean),
	isActivated = t.optional(t.boolean),
	hasContent = t.optional(t.boolean),
	isLoading = t.optional(t.boolean),
	onActivated = t.callback,
	onStateChanged = t.optional(t.callback),
	userInteractionEnabled = t.optional(t.boolean),
	iconSize = t.optional(t.number),
	containerPadding = t.optional(t.strictInterface({ left = t.number, right = t.number })),
	iconTextSpacing = t.optional(t.number),
	border = t.optional(t.strictInterface({ cornerRadius = t.number, size = t.number })),
	enableTokenOverride = t.optional(t.boolean),
	selectionOrder = t.optional(t.number),
	selectionCursor = t.optional(t.any)
})

extended.defaultProps = {
	isDisabled = false,
	isLoading = false,
	SliceCenter = Rect.new(8, 8, 9, 9),
	iconSize = IconSize.Regular,
	containerPadding = { left = 12, right = 20 },
	iconTextSpacing = 5,
	border = { cornerRadius = 8, size = 1 },
	enableTokenOverride = false
}

function extended.render(data)
	return withStyle(function(p)
		return withSelectionCursorProvider(function(callback)
			assert(t.table(p), "Style provider is missing.")

			local controlState = data.state.controlState

			local text = data.props.text
			local icon = data.props.icon
			local iconSize = data.props.iconSize
			local containerPadding = data.props.containerPadding
			local iconTextSpacing = data.props.iconTextSpacing
			local isLoading = data.props.isLoading
			local isDisabled = data.props.isDisabled

			local buttonStateColorMap = data.props.buttonStateColorMap
			local contentStateColorMap = data.props.contentStateColorMap
			local textStateColorMap = data.props.textStateColorMap or contentStateColorMap
			local iconStateColorMap = data.props.iconStateColorMap or contentStateColorMap

			local selectionCursor = data.props.selectionCursor or callback and callback(CursorKind.RoundedRectNoInset)
			local v2

			if data.props.enableTokenOverride then
				v2 = getColorFromMap
			else
				v2 = getContentStyle
			end

			local colorStyle
			local buttonStyle = getButtonStyle(v2, buttonStateColorMap, controlState, p, data.props.isActivated) -- inferred equivalent call

			if text then
				local isActivated = data.props.isActivated
				local hasContent = data.props.hasContent
				colorStyle = v2(textStateColorMap, controlState, p)

				if
					controlState ~= ControlState.Disabled
					and controlState ~= ControlState.Pressed
					and (isActivated or not hasContent)
				then
					colorStyle.Transparency = 0.5 * colorStyle.Transparency + 0.5
				end
			else
				colorStyle = text
			end

			local v3

			if icon then
				local isActivated = data.props.isActivated
				v3 = v2(iconStateColorMap, controlState, p)

				if controlState ~= ControlState.Disabled and controlState ~= ControlState.Pressed and isActivated then
					v3.Transparency = 0.5 * v3.Transparency + 0.5
				end
			else
				v3 = icon
			end

			local buttonImage = data.props.buttonImage
			local fontStyle

			if data.props.enableTokenOverride then
				fontStyle = data.props.textFont
			else
				fontStyle = p.Font.Header2
			end

			local v4

			if icon == nil then
				v4 = containerPadding.right
			else
				v4 = iconSize + iconTextSpacing + containerPadding.right
			end

			local children

			if isLoading then
				children = {
					isLoadingShimmer = Roact.createElement(Skeleton, {
						Size = UDim2.fromScale(1, 1)
					})
				}
			else
				children = data.props[Roact.Children]

				if not children then
					children = { TextContainer = 0, IconContainer = 0 }
					local createElement = Roact.createElement
					local v5 = { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 }

					local v6 = {
						UIListLayout = Roact.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Horizontal,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							HorizontalAlignment = Enum.HorizontalAlignment.Left,
							SortOrder = Enum.SortOrder.LayoutOrder
						}),
						Padding = Roact.createElement("UIPadding", {
							PaddingLeft = UDim.new(0, containerPadding.left)
						}),
						Text = 0
					}
					local text2

					if text then
						text2 = Roact.createElement(GenericTextLabel, {
							BackgroundTransparency = 1,
							Text = text,
							fontStyle = fontStyle,
							colorStyle = colorStyle,
							LayoutOrder = 1,
							Size = UDim2.new(1, -v4, 1, 0),
							TextTruncate = Enum.TextTruncate.AtEnd,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextWrapped = false
						})
					end

					v6.Text = text2
					children.TextContainer = createElement("Frame", v5, v6)

					children.IconContainer = Roact.createElement(
						"Frame",
						{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 },
						{
							UIListLayout = Roact.createElement("UIListLayout", {
								FillDirection = Enum.FillDirection.Horizontal,
								VerticalAlignment = Enum.VerticalAlignment.Center,
								HorizontalAlignment = Enum.HorizontalAlignment.Right,
								SortOrder = Enum.SortOrder.LayoutOrder
							}),
							Padding = Roact.createElement("UIPadding", {
								PaddingRight = UDim.new(0, containerPadding.right)
							}),
							Icon = icon and Roact.createElement(ImageSetComponent.Label, {
								Size = UDim2.fromOffset(iconSize, iconSize),
								BackgroundTransparency = 1,
								Image = icon,
								ImageColor3 = v3.Color,
								ImageTransparency = v3.Transparency,
								LayoutOrder = 2
							}) or nil
						}
					)
				end
			end

			local v5 = {
				isActivated = Cryo.None,
				hasContent = Cryo.None,
				icon = Cryo.None,
				text = Cryo.None,
				textFont = Cryo.None,
				buttonImage = Cryo.None,
				buttonStateColorMap = Cryo.None,
				contentStateColorMap = Cryo.None,
				textStateColorMap = Cryo.None,
				iconStateColorMap = Cryo.None,
				iconSize = Cryo.None,
				containerPadding = Cryo.None,
				iconTextSpacing = Cryo.None,
				border = Cryo.None,
				enableTokenOverride = Cryo.None,
				onActivated = Cryo.None,
				isLoading = Cryo.None,
				[Roact.Children] = Cryo.None,
				isDisabled = isLoading and true or isDisabled,
				onStateChanged = data.onStateChanged,
				userInteractionEnabled = data.props.userInteractionEnabled,
				ScaleType = Enum.ScaleType.Slice,
				BackgroundTransparency = 1,
				AutoButtonColor = false,
				selectionCursor = Cryo.None,
				SelectionImageObject = selectionCursor,
				SelectionOrder = data.props.selectionOrder,
				[Roact.Event.Activated] = data.props.onActivated
			}
			local udim, v6, joined

			if data.props.enableTokenOverride then
				local size = data.props.border.size
				udim = UDim2.new(1, -2 * size, 1, -2 * size)
				v6 = {
					UIStroke = Roact.createElement("UIStroke", {
						Color = buttonStyle.Color,
						Transparency = buttonStyle.Transparency,
						Thickness = size
					}),
					UICorner = Roact.createElement("UICorner", {
						CornerRadius = UDim.new(0, data.props.border.cornerRadius)
					})
				}

				joined = Cryo.Dictionary.join(data.props, v5)
			else
				udim = UDim2.new(1, 0, 1, 0)

				joined = Cryo.Dictionary.join(
					data.props,
					{
						Image = buttonImage,
						ImageColor3 = buttonStyle.Color,
						ImageTransparency = buttonStyle.Transparency
					},
					v5
				)
				v6 = {}
			end

			return Roact.createElement(Interactable, joined, {
				ButtonContent = Roact.createElement(
					"Frame",
					{ Size = udim, BackgroundTransparency = 1 },
					Cryo.Dictionary.join(v6, children)
				)
			})
		end)
	end)
end

return function(p)
	local selectionCursor = useCursorByType(CursorType.RoundedRectNoInset)
	local joined = Cryo.Dictionary.join(p, { selectionCursor = selectionCursor })

	if p.enableTokenOverride then
		local v2 = useStyle()
		joined = Cryo.Dictionary.join(StyleDefaults.getDropdownMenuCellDefaultTokens(v2), p)
	end

	return Roact.createElement(extended, joined)
end
