local CorePackages = game:GetService("CorePackages")

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local Foundation = require(CorePackages.Packages.Foundation)
local getTextSize = require("@game/CorePackages/Workspace/Packages/Style").GetTextSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagFontFacePlayerList
	and Foundation.Utility.Flags.FoundationFontFaceMigration

local module = require("@luauforge/bundled/ecR")
local module2 = require("@luauforge/bundled/fpF")

local module3 = require("@luauforge/bundled/edi")
local colorSystem = UIBlox.Common.Style.ColorSystem

local rect = Rect.new(12, 12, 13, 13)

local extended = module.PureComponent:extend("NumericalBadge")

extended.defaultProps = {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(1, 0, 0, 0),
	badgeCount = 0,
	inAppChrome = false,
	redBadgeVariant = false
}

function extended.render(p2)
	local anchorPoint = p2.props.AnchorPoint
	local position = p2.props.Position
	local layoutOrder = p2.props.LayoutOrder

	local badgeCount = p2.props.badgeCount

	if type(badgeCount) ~= "number" or badgeCount <= 0 then
		return nil
	end

	local function renderBadge(backgroundDefault, badge, props)
		local v5 = badgeCount > 99 and "99+" or tostring(badgeCount)
		local v6

		if foundationFontFaceMigration then
			v6 = getTextSize(v5, props.TextSize, props.FontFace, Vector2.new(10000, 10000)).X
		else
			v6 = module2.GetTextWidth(v5, props.Font, props.TextSize)
		end

		local v7 = math.max(24, v6 + 6 + 4)

		local v8 = badge.Color
		local v9 = props.TextColor3

		if p2.props.redBadgeVariant then
			v8 = colorSystem.Red[60]
			v9 = colorSystem.White
		end

		local createElement = module.createElement
		local v11 = {
			AnchorPoint = anchorPoint,
			Position = position,
			Size = UDim2.new(0, v7, 0, 24),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Image = "LuaApp/9-slice/notification_badge",
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = rect,
			ImageColor3 = backgroundDefault.Color,
			ImageTransparency = backgroundDefault.Transparency,
			LayoutOrder = layoutOrder
		}

		local createElement2 = module.createElement
		local v14 = {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(1, -4, 1, -4),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Image = "LuaApp/9-slice/notification_badge",
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = rect,
			ImageColor3 = v8,
			ImageTransparency = badge.Transparency
		}

		local createElement3 = module.createElement
		local v17 = {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, v6, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Font = 0,
			FontFace = 0,
			Text = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextTransparency = 0
		}

		local v18 = if not foundationFontFaceMigration then props.Font else nil
		v17.Font = v18
		local v19 = if foundationFontFaceMigration then normalizeFontFace(props.FontFace) else nil
		v17.FontFace = v19
		v17.Text = v5
		v17.TextSize = props.TextSize
		v17.TextColor3 = v9
		v17.TextTransparency = props.TextTransparency
		return createElement(module3, v11, {
			InnerBadge = createElement2(module3, v14, {
				Count = createElement3("TextLabel", v17)
			})
		})
	end

	return withStyle(function(data)
		local v6 = if not foundationFontFaceMigration then data.Font.CaptionHeader.Font else nil
		local v7 = if foundationFontFaceMigration then data.Tokens.Typography.CaptionLarge.Font else nil
		local v5 = {
			Font = v6,
			FontFace = v7,
			TextSize = data.Font.CaptionHeader.RelativeSize * data.Font.BaseSize,
			TextColor3 = data.Theme.BadgeContent.Color,
			TextTransparency = data.Theme.BadgeContent.Transparency
		}

		return renderBadge(data.Theme.BackgroundDefault, data.Theme.Badge, v5)
	end)
end

return extended
