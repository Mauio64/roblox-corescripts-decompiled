local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)

local Foundation = require(CorePackages.Packages.Foundation)
local IconName = Foundation.Enums.IconName
local IconVariant = Foundation.Enums.IconVariant
local IconSize = Foundation.Enums.IconSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local parent = script.Parent.Parent
local connection = parent.Connection
local LayoutValues = require(connection.LayoutValues)
local WithLayoutValues = LayoutValues.WithLayoutValues

local IconButton = require(parent.PresentationCommon.IconButton)

local Style = require(CorePackages.Workspace.Packages.Style)
local Colors = Style.Colors

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local Chrome = require(CorePackages.Workspace.Packages.Chrome)
local Enabled = Chrome.Enabled

local parent2 = parent.Parent

local FFlagAllowDisplayingFoundationIconsForDropdown = require(parent2.Flags.FFlagAllowDisplayingFoundationIconsForDropdown)

local function isFoundationIconName(icon): boolean -- 2 equivalent calls inferred from this helper
	return IconName[icon] ~= nil
end

local extended = Roact.PureComponent:extend("DropDownButton")

extended.validateProps = t.strictInterface({
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
	animatingPercentage = t.optional(t.number)
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
		return withFoundationOrUIBloxStyle(function(p, p2)
			local tokens

			if FoundationFontFaceMigration then
				tokens = p
			end

			return {
				Tokens = tokens,
				Theme = {
					BackgroundContrast = {
						Color = p.Color.Surface.Surface_100.Color3,
						Transparency = p.Color.Surface.Surface_100.Transparency
					},
					BackgroundOnHover = {
						Color = p.Color.State.Hover.Color3,
						Transparency = p.Color.State.Hover.Transparency
					},
					BackgroundOnPress = {
						Color = p.Color.State.Press.Color3,
						Transparency = p.Color.State.Press.Transparency
					},
					BackgroundUIContrast = {
						Color = p.Color.OverMedia.OverMedia_0.Color3,
						Transparency = p.Color.OverMedia.OverMedia_0.Transparency
					},
					Divider = {
						Color = p.Color.Stroke.Emphasis.Color3,
						Transparency = p.Color.Stroke.Emphasis.Transparency
					},
					IconEmphasis = {
						Color = p.Color.Content.Emphasis.Color3,
						Transparency = p.Color.Content.Emphasis.Transparency
					},
					TextEmphasis = {
						Color = p.Color.Content.Emphasis.Color3,
						Transparency = p.Color.Content.Emphasis.Transparency
					}
				},
				Font = {
					BaseSize = 1,
					Header2 = {
						Font = p.Typography.TitleLarge.Font,
						RelativeSize = p.Typography.TitleLarge.FontSize
					}
				},
				Settings = { PreferredTransparency = p2.preferredTransparency }
			}
		end, function(props)
			local color

			if Enabled() then
				color = props.Theme.BackgroundUIContrast.Color
			else
				color = props.Theme.BackgroundContrast.Color
			end

			local v = {
				Color = color,
				Transparency = data.OverrideBackgroundTransparency * props.Settings.PreferredTransparency
			}

			local v2 = { Transparency = 1, Color = Color3.new(1, 1, 1) }

			if self.state.isPressed then
				v2 = props.Theme.BackgroundOnPress
			elseif self.state.isHovered then
				v2 = props.Theme.BackgroundOnHover
			end

			local image = self.props.lastButton and "rbxasset://textures/ui/BottomRoundedRect8px.png" or ""

			local v3 = self.props.onActivated ~= nil or self.props.animatingAccept
			local v4 = self.props.onDecline ~= nil or self.props.animatingDecline
			local visible = self.props.onDecline ~= nil
				or self.props.animatingPercentage ~= nil
				or self.props.forceShowOptions

			local colorBackgroundAnimation, v5 = self:getColorBackgroundAnimation(data)
			local v6 = Colors.Green

			if self.props.animatingDecline then
				v6 = Colors.Red
			elseif self.props.forceShowOptions then
				v6 = Colors.White
			end

			local v7 = data.DropDownPadding * 2 + data.DropDownIconSize
			local v8 = data.DropDownRightOptionSize * 2

			if visible then
				v7 += v8
			end

			local function onMouseButton1Down()
				if not visible then
					self:setState({ isPressed = true })
				end
			end

			local function onMouseButton1Up()
				self:setState({ isPressed = false })
			end

			local icon = self.props.icon
			local icon2

			if
				FFlagAllowDisplayingFoundationIconsForDropdown and isFoundationIconName(icon) -- inferred equivalent call
				or FFlagCoreUiMigrateUIBloxToFoundation
			then
				local name = nil
				local size = nil

				if isFoundationIconName(icon) then -- inferred equivalent call
					name = IconName[icon]
					size = IconSize.Large
				elseif FFlagCoreUiMigrateUIBloxToFoundation then
					if typeof(icon) == "string" then
						name = icon
					end

					size = IconSize.Medium
				end

				if name then
					icon2 = Roact.createElement(
						"Frame",
						{
							LayoutOrder = 1,
							Size = UDim2.new(0, data.DropDownIconSize, 0, data.DropDownIconSize),
							BackgroundTransparency = 1
						},
						{
							Icon = Roact.createElement(Foundation.Icon, {
								name = name,
								variant = IconVariant.Regular,
								size = size,
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
					icon2 = Roact.createElement(Foundation.Image, {
						Image = icon.Image,
						imageRect = { offset = icon.ImageRectOffset, size = icon.ImageRectSize },
						Size = UDim2.new(0, data.DropDownIconSize, 0, data.DropDownIconSize),
						imageStyle = {
							Color3 = props.Theme.IconEmphasis.Color,
							Transparency = props.Theme.IconEmphasis.Transparency
						},
						BackgroundTransparency = 1,
						LayoutOrder = 1
					})
				end
			else
				icon2 = Roact.createElement(ImageSetLabel, {
					LayoutOrder = 1,
					Size = UDim2.new(0, data.DropDownIconSize, 0, data.DropDownIconSize),
					ImageColor3 = props.Theme.IconEmphasis.Color,
					Image = self.props.icon,
					BackgroundTransparency = 1
				})
			end

			local createElement = Roact.createElement
			local v9 = {
				["LayoutOrder"] = nil,
				["LayoutOrder"] = nil,
				["LayoutOrder"] = nil,
				["LayoutOrder"] = nil,
				["LayoutOrder"] = nil,
				LayoutOrder = self.props.layoutOrder,
				Image = image,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(8, 8, 24, 16),
				SliceScale = 0.5,
				ImageTransparency = self.props.lastButton and v.Transparency or 1,
				ImageColor3 = v.Color,
				Size = UDim2.new(1, 0, 0, data.DropDownButtonSizeY),
				BackgroundTransparency = self.props.lastButton and 1 or v.Transparency,
				BackgroundColor3 = v.Color,
				AutoButtonColor = false,
				BorderSizePixel = 0
			}

			local activated = Roact.Event.Activated
			local v10

			if not visible then
				v10 = self.props.onActivated or nil
			end

			v9[activated] = v10

			v9[Roact.Event.MouseEnter] = function()
				if not visible then
					self:setState({ isHovered = true })
				end
			end

			v9[Roact.Event.MouseLeave] = function()
				self:setState({ isHovered = false, isPressed = false })
			end

			v9[Roact.Change.AbsoluteSize] = function(p)
				self:setState({ sizeX = p.AbsoluteSize.X })
			end

			v9[Roact.Change.AbsolutePosition] = function(p)
				self:setState({
					absolutePosX = p.AbsolutePosition.X,
					absolutePosY = p.AbsolutePosition.Y
				})
			end

			v9[Roact.Event.MouseButton1Down] = onMouseButton1Down
			v9[Roact.Event.MouseButton1Up] = onMouseButton1Up
			local children = {
				ColorBackground = Roact.createElement("ImageLabel", {
					Visible = self.props.animatingPercentage ~= nil,
					ZIndex = 1,
					Size = UDim2.new(0, v5, 1, 0),
					Position = UDim2.new(0, colorBackgroundAnimation, 0, 0),
					Image = image,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(8, 8, 24, 16),
					SliceScale = 0.5,
					ImageTransparency = self.props.lastButton and data.IconButtonBackgroundTransparency or 1,
					ImageColor3 = v6,
					BackgroundTransparency = self.props.lastButton and 1 or data.IconButtonBackgroundTransparency,
					BackgroundColor3 = v6,
					BorderSizePixel = 0
				}),
				HoverBackground = 0,
				DismissInputHandler = 0,
				Divider = 0
			}

			local createElement2 = Roact.createElement
			local v11 = {
				ZIndex = 2,
				Size = UDim2.new(1, 0, 1, 0),
				Image = image,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(8, 8, 24, 16),
				SliceScale = 0.5,
				ImageTransparency = self.props.lastButton and v2.Transparency or 1,
				ImageColor3 = v2.Color,
				BackgroundTransparency = self.props.lastButton and 1 or v2.Transparency,
				BackgroundColor3 = v2.Color,
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
			local v12 = {
				LayoutOrder = 2,
				Size = UDim2.new(1, -v7, 1, 0),
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

			v12.Font = font
			local fontFace

			if FoundationFontFaceMigration then
				fontFace = normalizeFontFace(props.Tokens.Typography.TitleLarge.Font)
			end

			v12.FontFace = fontFace

			v12.TextSize = props.Font.BaseSize * props.Font.Header2.RelativeSize
			v12.TextColor3 = props.Theme.TextEmphasis.Color
			v12.TextTransparency = props.Theme.TextEmphasis.Transparency
			v12.TextXAlignment = Enum.TextXAlignment.Left
			v12.TextTruncate = Enum.TextTruncate.AtEnd
			children2.Text = createElement3("TextLabel", v12)

			local createElement4 = Roact.createElement
			local v13 = {
				LayoutOrder = 3,
				Visible = visible,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, v8, 1, 0)
			}
			local confirmButton

			if v3 then
				confirmButton = Roact.createElement(IconButton, {
					size = UDim2.new(0.5, 0, 1, 0),
					position = UDim2.new(0.5, 0, 0, 0),
					backgroundColor = self.props.onDecline and Colors.Green or Colors.White,
					icon = FFlagCoreUiMigrateUIBloxToFoundation and "icons/actions/accept" or Images["icons/actions/accept"],
					showBackground = self.props.animatingPercentage == nil,
					onActivated = self.props.onActivated
				}) or nil
			end

			local declineButton

			if v4 then
				declineButton = Roact.createElement(IconButton, {
					size = UDim2.new(0.5, 0, 1, 0),
					position = UDim2.new(0, 0, 0, 0),
					backgroundColor = Colors.Red,
					icon = FFlagCoreUiMigrateUIBloxToFoundation and "icons/actions/reject" or Images["icons/actions/reject"],
					showBackground = self.props.animatingPercentage == nil,
					onActivated = self.props.onDecline
				}) or nil
			end

			children2.ButtonContainer = createElement4("Frame", v13, {
				ConfirmButton = confirmButton,
				DeclineButton = declineButton
			})
			children.HoverBackground = createElement2("ImageLabel", v11, children2)

			children.DismissInputHandler = Roact.createElement("ImageButton", {
				Image = "",
				BackgroundTransparency = 1,
				Size = UDim2.new(0, self.props.screenSizeX, 0, self.props.screenSizeY),
				Position = UDim2.new(0, -self.state.absolutePosX, 0, -self.state.absolutePosY),
				Visible = self.props.onDismiss ~= nil,
				[Roact.Event.Activated] = self.props.onDismiss
			})

			children.Divider = not self.props.lastButton and Roact.createElement("Frame", {
				ZIndex = 3,
				Size = UDim2.new(1, 0, 0, 1),
				Position = UDim2.new(0, 0, 1, 0),
				AnchorPoint = Vector2.new(0, 1),
				BackgroundTransparency = props.Theme.Divider.Transparency,
				BackgroundColor3 = props.Theme.Divider.Color,
				BorderSizePixel = 0
			})
			return createElement("ImageButton", v9, children)
		end)
	end)
end

local function mapStateToProps(p)
	return { screenSizeX = p.screenSize.X, screenSizeY = p.screenSize.Y }
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, nil)(extended)
