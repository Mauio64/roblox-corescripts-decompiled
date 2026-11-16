local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local IconSize = Foundation.Enums.IconSize

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation

local Connection = script.Parent.Parent.Connection
local LayoutValues = require(Connection.LayoutValues)
local WithLayoutValues = LayoutValues.WithLayoutValues

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local extended = Roact.PureComponent:extend("IconButton")

extended.validateProps = t.strictInterface({
	size = t.UDim2,
	position = t.UDim2,
	backgroundColor = t.Color3,
	icon = t.union(t.string, t.table),
	showBackground = t.boolean,
	onActivated = t.optional(t.callback)
})

function extended:init()
	self.state = { isHovered = false, isPressed = false }
end

function extended.render(object)
	return WithLayoutValues(function(p)
		return withFoundationOrUIBloxStyle(function(p2)
			return {
				Theme = {
					BackgroundOnHover = {
						Color = p2.Color.State.Hover.Color3,
						Transparency = p2.Color.State.Hover.Transparency
					},
					BackgroundOnPress = {
						Color = p2.Color.State.Press.Color3,
						Transparency = p2.Color.State.Press.Transparency
					},
					IconEmphasis = {
						Color = p2.Color.Content.Emphasis.Color3,
						Transparency = p2.Color.Content.Emphasis.Transparency
					}
				}
			}
		end, function(p2)
			local v = { Transparency = 1, Color = Color3.new(1, 1, 1) }

			if object.props.onActivated then
				if object.state.isPressed then
					v = p2.Theme.BackgroundOnPress
				elseif object.state.isHovered then
					v = p2.Theme.BackgroundOnHover
				end
			end

			local imageButton

			if FFlagCoreUiMigrateUIBloxToFoundation then
				local icon = object.props.icon

				if typeof(icon) == "string" then
					imageButton = Roact.createElement("Frame", {
						Position = UDim2.new(0.5, 0, 0.5, 0),
						Size = UDim2.new(0, p.DropDownIconSize, 0, p.DropDownIconSize),
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						ZIndex = 2
					}, {
						Icon = Roact.createElement(Foundation.Icon, {
							name = icon,
							size = IconSize.Medium,
							style = {
								Color3 = p2.Theme.IconEmphasis.Color,
								Transparency = p2.Theme.IconEmphasis.Transparency
							},
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.new(0.5, 0, 0.5, 0)
						})
					})
				else
					imageButton = Roact.createElement(Foundation.Image, {
						Image = icon.Image,
						imageRect = { offset = icon.ImageRectOffset, size = icon.ImageRectSize },
						Size = UDim2.new(0, p.DropDownIconSize, 0, p.DropDownIconSize),
						imageStyle = {
							Color3 = p2.Theme.IconEmphasis.Color,
							Transparency = p2.Theme.IconEmphasis.Transparency
						},
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 0, 0.5, 0),
						BackgroundTransparency = 1,
						ZIndex = 2
					})
				end
			else
				imageButton = Roact.createElement(ImageSetLabel, {
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(0, p.DropDownIconSize, 0, p.DropDownIconSize),
					Image = object.props.icon,
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					ZIndex = 2
				})
			end

			return Roact.createElement("TextButton", {
				Text = "",
				BorderSizePixel = 0,
				BackgroundTransparency = object.props.showBackground and p.IconButtonBackgroundTransparency or 1,
				BackgroundColor3 = object.props.backgroundColor,
				Position = object.props.position,
				Size = object.props.size,
				[Roact.Event.Activated] = object.props.onActivated,
				[Roact.Event.MouseButton1Down] = function()
					object:setState({ isPressed = true })
				end,
				[Roact.Event.MouseButton1Up] = function()
					object:setState({ isPressed = false })
				end,
				[Roact.Event.MouseEnter] = function()
					object:setState({ isHovered = true })
				end,
				[Roact.Event.MouseLeave] = function()
					object:setState({ isHovered = false, isPressed = false })
				end
			}, {
				HoverBackground = Roact.createElement("Frame", {
					ZIndex = 1,
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = v.Transparency,
					BackgroundColor3 = v.Color,
					BorderSizePixel = 0
				}),
				ImageButton = imageButton
			})
		end)
	end)
end

return extended
