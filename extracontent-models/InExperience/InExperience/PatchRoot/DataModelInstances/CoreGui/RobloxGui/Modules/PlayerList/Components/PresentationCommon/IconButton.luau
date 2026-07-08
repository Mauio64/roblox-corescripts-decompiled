local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local IconSize = Foundation.Enums.IconSize
local withFoundationOrUIBloxStyle = require(CorePackages.Workspace.Packages.CoreGuiCommon).withFoundationOrUIBloxStyle
local FFlagCoreUiMigrateUIBloxToFoundation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCoreUiMigrateUIBloxToFoundation
local Connection = script.Parent.Parent.Connection
local WithLayoutValues = require(Connection.LayoutValues).WithLayoutValues
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local v12 = Roact.PureComponent:extend("IconButton")

v12.validateProps = t.strictInterface({
	size = t.UDim2,
	position = t.UDim2,
	backgroundColor = t.Color3,
	icon = t.union(t.string, t.table),
	showBackground = t.boolean,
	onActivated = t.optional(t.callback)
})

function v12.init(p1) -- line: 32
	p1.state = {
		isHovered = false,
		isPressed = false
	}
end
function v12.render(p2) -- line: 39
	-- upvalues: WithLayoutValues (copy), withFoundationOrUIBloxStyle (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), Roact (copy), Foundation (copy), IconSize (copy), ImageSetLabel (copy)
	return WithLayoutValues(function(p3) -- line: 40
		-- upvalues: withFoundationOrUIBloxStyle (copy), p2 (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), Roact (copy), Foundation (copy), IconSize (copy), ImageSetLabel (copy)
		return withFoundationOrUIBloxStyle(function(p4) -- line: 41
			return {
				Theme = {
					BackgroundOnHover = {
						Color = p4.Color.State.Hover.Color3,
						Transparency = p4.Color.State.Hover.Transparency
					},
					BackgroundOnPress = {
						Color = p4.Color.State.Press.Color3,
						Transparency = p4.Color.State.Press.Transparency
					},
					IconEmphasis = {
						Color = p4.Color.Content.Emphasis.Color3,
						Transparency = p4.Color.Content.Emphasis.Transparency
					}
				}
			}
		end, function(p5) -- line: 58
			-- upvalues: p2 (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), Roact (copy), p3 (copy), Foundation (copy), IconSize (copy), ImageSetLabel (copy)
			local t1 = {
				Transparency = 1,
				Color = Color3.new(1, 1, 1)
			}

			if p2.props.onActivated then
				if p2.state.isPressed then
					t1 = p5.Theme.BackgroundOnPress
				elseif p2.state.isHovered then
					t1 = p5.Theme.BackgroundOnHover
				end
			end

			local v20

			if FFlagCoreUiMigrateUIBloxToFoundation then
				local icon = p2.props.icon

				v20 = if typeof(icon) ~= "string" then Roact.createElement(Foundation.Image, {
					BackgroundTransparency = 1,
					ZIndex = 2,
					Image = icon.Image,
					imageRect = {
						offset = icon.ImageRectOffset,
						size = icon.ImageRectSize
					},
					Size = UDim2.new(0, p3.DropDownIconSize, 0, p3.DropDownIconSize),
					imageStyle = {
						Color3 = p5.Theme.IconEmphasis.Color,
						Transparency = p5.Theme.IconEmphasis.Transparency
					},
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0)
				}) else Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					ZIndex = 2,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(0, p3.DropDownIconSize, 0, p3.DropDownIconSize),
					AnchorPoint = Vector2.new(0.5, 0.5)
				}, {
					Icon = Roact.createElement(Foundation.Icon, {
						name = icon,
						size = IconSize.Medium,
						style = {
							Color3 = p5.Theme.IconEmphasis.Color,
							Transparency = p5.Theme.IconEmphasis.Transparency
						},
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 0, 0.5, 0)
					})
				})
			else
				v20 = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					ZIndex = 2,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(0, p3.DropDownIconSize, 0, p3.DropDownIconSize),
					Image = p2.props.icon,
					AnchorPoint = Vector2.new(0.5, 0.5)
				})
			end

			return Roact.createElement("TextButton", {
				Text = "",
				BorderSizePixel = 0,
				BackgroundTransparency = p2.props.showBackground and p3.IconButtonBackgroundTransparency or 1,
				BackgroundColor3 = p2.props.backgroundColor,
				Position = p2.props.position,
				Size = p2.props.size,
				[Roact.Event.Activated] = p2.props.onActivated,
				[Roact.Event.MouseButton1Down] = function() -- line: 130
					-- upvalues: p2 (copy)
					p2:setState({
						isPressed = true
					})
				end,
				[Roact.Event.MouseButton1Up] = function() -- line: 135
					-- upvalues: p2 (copy)
					p2:setState({
						isPressed = false
					})
				end,
				[Roact.Event.MouseEnter] = function() -- line: 141
					-- upvalues: p2 (copy)
					p2:setState({
						isHovered = true
					})
				end,
				[Roact.Event.MouseLeave] = function() -- line: 147
					-- upvalues: p2 (copy)
					p2:setState({
						isHovered = false,
						isPressed = false
					})
				end
			}, {
				HoverBackground = Roact.createElement("Frame", {
					ZIndex = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = t1.Transparency,
					BackgroundColor3 = t1.Color
				}),
				ImageButton = v20
			})
		end)
	end)
end

return v12
