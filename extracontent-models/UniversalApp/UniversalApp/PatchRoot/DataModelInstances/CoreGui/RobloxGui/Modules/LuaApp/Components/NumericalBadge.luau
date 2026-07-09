local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local Roact = require(Modules.Common.Roact)
local Text = require(Modules.Common.Text)
local DEPRECATED_ImageSetLabel = require(Modules.LuaApp.Components.DEPRECATED_ImageSetLabel)
local ColorSystem = UIBlox.Common.Style.ColorSystem
local rect = Rect.new(12, 12, 13, 13)
local v10 = Roact.PureComponent:extend("NumericalBadge")

v10.defaultProps = {
	badgeCount = 0,
	inAppChrome = false,
	redBadgeVariant = false,
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(1, 0, 0, 0)
}

function v10.render(p1) -- line: 34
	-- upvalues: Text (copy), ColorSystem (copy), Roact (copy), DEPRECATED_ImageSetLabel (copy), rect (copy), withStyle (copy)
	local propsAnchorPoint = p1.props.AnchorPoint
	local propsPosition = p1.props.Position
	local propsLayoutOrder = p1.props.LayoutOrder
	local badgeCount = p1.props.badgeCount

	if type(badgeCount) ~= "number" or badgeCount <= 0 then
		return nil
	end

	local function renderBadge(p2, p3, p4) -- line: 45
		-- upvalues: badgeCount (copy), Text (copy), p1 (copy), ColorSystem (copy), Roact (copy), DEPRECATED_ImageSetLabel (copy), propsAnchorPoint (copy), propsPosition (copy), rect (copy), propsLayoutOrder (copy)
		local v20 = if not (badgeCount > 99) then tostring(badgeCount) else "99+"
		local v21 = Text.GetTextWidth(v20, p4.Font, p4.TextSize)
		local v22 = math.max(24, v21 + 6 + 4)
		local p3Color = p3.Color
		local p4TextColor3 = p4.TextColor3

		if p1.props.redBadgeVariant then
			p3Color = ColorSystem.Red[60]
			p4TextColor3 = ColorSystem.White
		end

		return Roact.createElement(DEPRECATED_ImageSetLabel, {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Image = "LuaApp/9-slice/notification_badge",
			AnchorPoint = propsAnchorPoint,
			Position = propsPosition,
			Size = UDim2.new(0, v22, 0, 24),
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = rect,
			ImageColor3 = p2.Color,
			ImageTransparency = p2.Transparency,
			LayoutOrder = propsLayoutOrder
		}, {
			InnerBadge = Roact.createElement(DEPRECATED_ImageSetLabel, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Image = "LuaApp/9-slice/notification_badge",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(1, -4, 1, -4),
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = rect,
				ImageColor3 = p3Color,
				ImageTransparency = p3.Transparency
			}, {
				Count = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(0, v21, 1, 0),
					Font = p4.Font,
					Text = v20,
					TextSize = p4.TextSize,
					TextColor3 = p4TextColor3,
					TextTransparency = p4.TextTransparency
				})
			})
		})
	end

	return withStyle(function(p5) -- line: 100
		-- upvalues: renderBadge (copy)
		local t1 = {
			Font = p5.Font.CaptionHeader.Font,
			TextSize = p5.Font.CaptionHeader.RelativeSize * p5.Font.BaseSize,
			TextColor3 = p5.Theme.BadgeContent.Color,
			TextTransparency = p5.Theme.BadgeContent.Transparency
		}

		return renderBadge(p5.Theme.BackgroundDefault, p5.Theme.Badge, t1)
	end)
end

return v10
