local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)

local Foundation = require(CorePackages.Packages.Foundation)
local IconName = Foundation.Enums.IconName
local IconVariant = Foundation.Enums.IconVariant
local IconSize = Foundation.Enums.IconSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local useLayoutValues = PlayerList.Common.useLayoutValues

local withStyle = UIBlox.Style.withStyle

local parent = script.Parent.Parent
local connection = parent.Connection
local LayoutValues = require(connection.LayoutValues)
local WithLayoutValues = LayoutValues.WithLayoutValues

local IconButton = require(parent.PresentationCommon.IconButton)

local Style = require(CorePackages.Workspace.Packages.Style)
local Colors = Style.Colors

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images

local FFlagEnableMobilePlayerListOnConsole = PlayerList.Flags.FFlagEnableMobilePlayerListOnConsole

local parent2 = parent.Parent
local FFlagAllowDisplayingFoundationIconsForDropdown = require(parent2.Flags.FFlagAllowDisplayingFoundationIconsForDropdown)

local function isFoundationIconName(icon): boolean -- 1 equivalent call inferred from this helper
	return IconName[icon] ~= nil
end

local extended = Roact.PureComponent:extend("DropDownButton")

extended.validateProps = t.strictInterface({
	contentVisible = t.boolean,
	buttonTransparency = t.any,
	text = t.string,
	layoutOrder = t.optional(t.integer),
	icon = t.union(t.string, t.table),
	lastButton = t.boolean,
	forceShowOptions = t.boolean,
	screenSizeX = t.number,
	screenSizeY = t.number,
	onActivated = t.optional(t.callback),
	onDecline = t.optional(t.callback),
	onDismiss = t.optional(t.callback),
	animatingAccept = t.optional(t.boolean),
	animatingDecline = t.optional(t.boolean),
	animatingPercentage = t.optional(t.number),
	layoutValues = t.optional(t.table)
})

function extended:init()
	self.state = {
		isHovered = false,
		isPressed = false,
		sizeX = 100,
		absolutePosX = 0,
		absolutePosY = 0
	}
end

function extended:getColorBackgroundAnimation(p)
	if self.props.animatingPercentage == nil then
		return 0, 0
	end

	local v = self.state.sizeX - p.DropDownRightOptionSize
	local dropDownRightOptionSize = p.DropDownRightOptionSize

	if self.props.animatingDecline then
		v -= p.DropDownRightOptionSize
	end

	local v2 = self.state.sizeX - p.DropDownRightOptionSize
	local v3 = dropDownRightOptionSize + v2 * self.props.animatingPercentage
	local v4 = v - v2 * self.props.animatingPercentage * 0.5

	if v4 + v3 > self.state.sizeX then
		v4 -= v4 + v3 - self.state.sizeX
	end

	return v4, v3
end

function extended:render()
	return WithLayoutValues(function(data)
		return withStyle(function(props)
			data = self.props.layoutValues

			local v = { Transparency = 1, Color = Color3.new(1, 1, 1) }

			if self.state.isPressed then
				v = props.Theme.BackgroundOnPress
			elseif self.state.isHovered then
				v = props.Theme.BackgroundOnHover
			end

			local image = self.props.lastButton and "rbxasset://textures/ui/BottomRoundedRect8px.png" or ""

			local v2 = self.props.onActivated ~= nil or self.props.animatingAccept
			local v3 = self.props.onDecline ~= nil or self.props.animatingDecline
			local visible = self.props.onDecline ~= nil
				or self.props.animatingPercentage ~= nil
				or self.props.forceShowOptions

			local colorBackgroundAnimation, v4 = self:getColorBackgroundAnimation(data)
			local v5 = Colors.Green

			if self.props.animatingDecline then
				v5 = Colors.Red
			elseif self.props.forceShowOptions then
				v5 = Colors.White
			end

			local v6 = data.DropDownPadding * 2 + data.DropDownIconSize
			local v7 = data.DropDownRightOptionSize * 2

			if visible then
				v6 += v7
			end

			local icon = self.props.icon
			local icon2

			if FFlagAllowDisplayingFoundationIconsForDropdown and isFoundationIconName(icon) then -- inferred equivalent call
				icon2 = Roact.createElement(
					"Frame",
					{
						LayoutOrder = 1,
						Size = UDim2.new(0, data.DropDownIconSize, 0, data.DropDownIconSize),
						BackgroundTransparency = 1
					},
					{
						Icon = Roact.createElement(Foundation.Icon, {
							name = IconName[icon],
							variant = IconVariant.Regular,
							size = IconSize.Large,
							style = {
								Color3 = props.Theme.IconEmphasis.Color,
								Transparency = props.Theme.IconEmphasis.Transparency
							},
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.new(0.5, 0, 0.5, 0)
						})
					}
				)
			else
				icon2 = Roact.createElement(ImageSetLabel, {
					LayoutOrder = 1,
					Size = UDim2.new(0, data.DropDownIconSize, 0, data.DropDownIconSize),
					ImageColor3 = props.Theme.IconEmphasis.Color,
					Image = self.props.icon,
					BackgroundTransparency = 1
				})
			end

			local function onMouseButton1Down()
				if not visible then
					self:setState({ isPressed = true })
				end
			end

			local function onMouseButton1Up()
				self:setState({ isPressed = false })
			end

			local createElement = Roact.createElement
			local v8 = {
				["LayoutOrder"] = nil,
				["LayoutOrder"] = nil,
				["LayoutOrder"] = nil,
				["LayoutOrder"] = nil,
				LayoutOrder = self.props.layoutOrder,
				Image = image,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(8, 8, 24, 16),
				SliceScale = 0.5,
				ImageTransparency = self.props.lastButton and self.props.buttonTransparency or 1,
				ImageColor3 = Color3.fromRGB(0, 0, 0),
				Size = UDim2.new(1, 0, 0, data.DropDownButtonSizeY),
				BackgroundTransparency = self.props.lastButton and 1 or self.props.buttonTransparency,
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				AutoButtonColor = false,
				BorderSizePixel = 0,
				Selectable = not visible
			}

			local activated = Roact.Event.Activated
			local v9

			if not visible then
				v9 = self.props.onActivated or nil
			end

			v8[activated] = v9

			v8[Roact.Event.MouseEnter] = function()
				if not visible then
					self:setState({ isHovered = true })
				end
			end

			v8[Roact.Event.MouseLeave] = function()
				self:setState({ isHovered = false, isPressed = false })
			end

			v8[Roact.Change.AbsoluteSize] = function(p)
				self:setState({ sizeX = p.AbsoluteSize.X })
			end

			v8[Roact.Change.AbsolutePosition] = function(p)
				self:setState({
					absolutePosX = p.AbsolutePosition.X,
					absolutePosY = p.AbsolutePosition.Y
				})
			end

			v8[Roact.Event.MouseButton1Down] = onMouseButton1Down
			v8[Roact.Event.MouseButton1Up] = onMouseButton1Up
			local children = {
				ColorBackground = Roact.createElement("ImageLabel", {
					Visible = self.props.animatingPercentage ~= nil and self.props.contentVisible,
					ZIndex = 1,
					Size = UDim2.new(0, v4, 1, 0),
					Position = UDim2.fromOffset(colorBackgroundAnimation, 0),
					Image = image,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(8, 8, 24, 16),
					SliceScale = 0.5,
					ImageTransparency = self.props.lastButton and data.IconButtonBackgroundTransparency or 1,
					ImageColor3 = v5,
					BackgroundTransparency = self.props.lastButton and 1 or data.IconButtonBackgroundTransparency,
					BackgroundColor3 = v5,
					BorderSizePixel = 0
				}),
				HoverBackground = 0,
				DismissInputHandler = 0,
				Divider = 0
			}

			local createElement2 = Roact.createElement
			local v10 = {
				ZIndex = 2,
				Size = UDim2.fromScale(1, 1),
				Visible = self.props.contentVisible,
				Image = image,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(8, 8, 24, 16),
				SliceScale = 0.5,
				ImageTransparency = self.props.lastButton and v.Transparency or 1,
				ImageColor3 = v.Color,
				BackgroundTransparency = self.props.lastButton and 1 or v.Transparency,
				BackgroundColor3 = v.Color,
				BorderSizePixel = 0
			}

			local children2 = {
				InitalPadding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, data.DropDownPadding)
				}),
				ListLayout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, data.DropDownPadding)
				}),
				Icon = icon2,
				Text = 0,
				ButtonContainer = 0
			}

			local createElement3 = Roact.createElement
			local v11 = {
				LayoutOrder = 2,
				Size = UDim2.new(1, -v6, 1, 0),
				Text = self.props.text,
				Font = 0,
				FontFace = 0,
				TextSize = 0,
				TextColor3 = 0,
				TextTransparency = 0,
				TextXAlignment = 0,
				TextTruncate = 0,
				BackgroundTransparency = 1
			}
			local font

			if not FoundationFontFaceMigration then
				font = props.Font.Header2.Font
			end

			v11.Font = font
			local fontFace

			if FoundationFontFaceMigration then
				fontFace = normalizeFontFace(props.Tokens.Typography.TitleLarge.Font)
			end

			v11.FontFace = fontFace
			local textSize

			if FFlagEnableMobilePlayerListOnConsole then
				textSize = data.DropDownButtonTextSize
			else
				textSize = props.Font.BaseSize * props.Font.Header2.RelativeSize
			end

			v11.TextSize = textSize
			v11.TextColor3 = props.Theme.TextEmphasis.Color
			v11.TextTransparency = props.Theme.TextEmphasis.Transparency
			v11.TextXAlignment = Enum.TextXAlignment.Left
			v11.TextTruncate = Enum.TextTruncate.AtEnd
			children2.Text = createElement3("TextLabel", v11)

			local createElement4 = Roact.createElement
			local v12 = {
				LayoutOrder = 3,
				Visible = visible,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, v7, 1, 0)
			}
			local confirmButton

			if v2 then
				confirmButton = Roact.createElement(IconButton, {
					size = UDim2.fromScale(0.5, 1),
					position = UDim2.fromScale(0.5, 0),
					backgroundColor = self.props.onDecline and Colors.Green or Colors.White,
					icon = Images["icons/actions/accept"],
					showBackground = self.props.animatingPercentage == nil,
					onActivated = self.props.onActivated
				}) or nil
			end

			local declineButton

			if v3 then
				declineButton = Roact.createElement(IconButton, {
					size = UDim2.fromScale(0.5, 1),
					position = UDim2.new(0, 0, 0, 0),
					backgroundColor = Colors.Red,
					icon = Images["icons/actions/reject"],
					showBackground = self.props.animatingPercentage == nil,
					onActivated = self.props.onDecline
				}) or nil
			end

			children2.ButtonContainer = createElement4("Frame", v12, {
				ConfirmButton = confirmButton,
				DeclineButton = declineButton
			})
			children.HoverBackground = createElement2("ImageLabel", v10, children2)

			children.DismissInputHandler = Roact.createElement("ImageButton", {
				Image = "",
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(self.props.screenSizeX, self.props.screenSizeY),
				Position = UDim2.fromOffset(-self.state.absolutePosX, -self.state.absolutePosY),
				Visible = self.props.onDismiss ~= nil and self.props.contentVisible,
				[Roact.Event.Activated] = self.props.onDismiss
			})

			children.Divider = not self.props.lastButton and Roact.createElement("Frame", {
				Visible = self.props.contentVisible,
				ZIndex = 3,
				Size = UDim2.new(1, 0, 0, 1),
				Position = UDim2.fromScale(0, 1),
				AnchorPoint = Vector2.new(0, 1),
				BackgroundTransparency = props.Theme.Divider.Transparency,
				BackgroundColor3 = props.Theme.Divider.Color,
				BorderSizePixel = 0
			})
			return createElement("ImageButton", v8, children)
		end)
	end)
end

local function mapStateToProps(p)
	return { screenSizeX = p.screenSize.X, screenSizeY = p.screenSize.Y }
end

return RoactRodux.connect(mapStateToProps, nil)(function(p)
	local layoutValues = useLayoutValues()

	return Roact.createElement(extended, Cryo.Dictionary.join(p, { layoutValues = layoutValues }))
end)
