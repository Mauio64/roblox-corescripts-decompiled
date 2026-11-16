local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local getTextSize = require("@game/CorePackages/Workspace/Packages/Style").GetTextSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local v5 = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagFontFaceAX and foundationFontFaceMigration

local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local text = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Text

local roactFitComponents = AvatarExperienceDeps.RoactFitComponents
local fitTextLabel = roactFitComponents.FitTextLabel
local withStyle = UIBlox.Style.withStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local cursorKind = UIBlox.App.SelectionImage.CursorKind

local extended = Roact.PureComponent:extend("BulletListEntry")

extended.validateProps = t.strictInterface({
	text = t.string,
	layoutOrder = t.integer,
	positionChangedCallback = t.optional(t.callback),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	forwardRef = t.optional(t.table)
})

function extended:renderWithProviders(props, callback)
	local font = props.Font
	local theme = props.Theme

	local v6 = font.CaptionBody.Font
	local v7 = font.BaseSize * font.CaptionBody.RelativeSize
	local v8

	if foundationFontFaceMigration then
		v8 = getTextSize("• ", v7, props.Tokens.Typography.BodySmall.Font, Vector2.new(10000, 10000)).X
	else
		v8 = text.GetTextWidth("• ", v6, v7)
	end

	local forwardRef = self.props.forwardRef

	local createElement = Roact.createElement
	local fitFrameVertical = roactFitComponents.FitFrameVertical
	local v9 = {
		width = UDim.new(1, 0),
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		BackgroundTransparency = 1,
		LayoutOrder = self.props.layoutOrder,
		[Roact.Change.AbsolutePosition] = self.props.positionChangedCallback,
		SelectionImageObject = callback(cursorKind.RoundedRect),
		NextSelectionLeft = self.props.NextSelectionLeft,
		NextSelectionRight = self.props.NextSelectionRight,
		NextSelectionUp = self.props.NextSelectionUp,
		NextSelectionDown = self.props.NextSelectionDown,
		[Roact.Ref] = forwardRef
	}

	local createElement2 = Roact.createElement
	local v11 = {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(v8, v7),
		Text = "• ",
		Font = if not foundationFontFaceMigration then v6 else nil,
		FontFace = 0,
		TextSize = 0,
		TextColor3 = 0,
		TextTransparency = 0,
		TextXAlignment = 0,
		LayoutOrder = 1
	}

	local v13 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodySmall.Font) else nil
	v11.FontFace = v13

	v11.TextSize = v7
	v11.TextColor3 = theme.TextDefault.Color
	v11.TextTransparency = theme.TextDefault.Transparency
	v11.TextXAlignment = Enum.TextXAlignment.Left
	local children = {
		Bullet = createElement2("TextLabel", v11),
		Text = 0
	}

	local createElement3 = Roact.createElement
	local v15 = {
		width = UDim.new(1, -v8),
		BackgroundTransparency = 1,
		Text = self.props.text,
		Font = 0,
		TextSize = 0,
		TextColor3 = 0,
		TextTransparency = 0,
		TextXAlignment = 0,
		LayoutOrder = 2
	}

	if v5 then
		v6 = normalizeFontFace(props.Tokens.Typography.BodySmall.Font)
	end

	v15.Font = v6
	v15.TextSize = v7
	v15.TextColor3 = theme.TextDefault.Color
	v15.TextTransparency = theme.TextDefault.Transparency
	v15.TextXAlignment = Enum.TextXAlignment.Left
	children.Text = createElement3(fitTextLabel, v15)
	return createElement(fitFrameVertical, v9, children)
end

function extended:render()
	return withStyle(function(p2)
		return withSelectionCursorProvider(function(p3)
			return self:renderWithProviders(p2, p3)
		end)
	end)
end

return Roact.forwardRef(function(p2, p3)
	return Roact.createElement(extended, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
