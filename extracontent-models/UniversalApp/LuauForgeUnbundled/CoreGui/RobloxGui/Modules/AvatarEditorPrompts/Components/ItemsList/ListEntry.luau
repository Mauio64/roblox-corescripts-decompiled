local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local getTextSize = require("@game/CorePackages/Workspace/Packages/Style").GetTextSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local fFlagFontFaceAX = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagFontFaceAX
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)

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

	local v5 = font.CaptionBody.Font
	local v6 = font.BaseSize * font.CaptionBody.RelativeSize

	local x = getTextSize("• ", v6, props.Tokens.Typography.BodySmall.Font, Vector2.new(10000, 10000)).X

	local forwardRef = self.props.forwardRef

	local createElement = Roact.createElement
	local fitFrameVertical = roactFitComponents.FitFrameVertical
	local v7 = {
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
	local v8 = {
		Bullet = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(x, v6),
			Text = "• ",
			FontFace = normalizeFontFace(props.Tokens.Typography.BodySmall.Font),
			TextSize = v6,
			TextColor3 = theme.TextDefault.Color,
			TextTransparency = theme.TextDefault.Transparency,
			TextXAlignment = Enum.TextXAlignment.Left,
			LayoutOrder = 1
		}),
		Text = 0
	}

	local createElement2 = Roact.createElement
	local v10 = {
		width = UDim.new(1, -x),
		BackgroundTransparency = 1,
		Text = self.props.text,
		Font = 0,
		TextSize = 0,
		TextColor3 = 0,
		TextTransparency = 0,
		TextXAlignment = 0,
		LayoutOrder = 2
	}

	if fFlagFontFaceAX then
		v5 = normalizeFontFace(props.Tokens.Typography.BodySmall.Font)
	end

	v10.Font = v5
	v10.TextSize = v6
	v10.TextColor3 = theme.TextDefault.Color
	v10.TextTransparency = theme.TextDefault.Transparency
	v10.TextXAlignment = Enum.TextXAlignment.Left
	v8.Text = createElement2(fitTextLabel, v10)
	return createElement(fitFrameVertical, v7, v8)
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
