local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Modules = CoreGui.RobloxGui.Modules

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local Style = require(CorePackages.Workspace.Packages.Style)
local GetTextSize = Style.GetTextSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local v = SharedFlags.FFlagFontFaceAX and FoundationFontFaceMigration

local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Text = AppCommonLib.Text

local RoactFitComponents = AvatarExperienceDeps.RoactFitComponents
local FitTextLabel = RoactFitComponents.FitTextLabel
local withStyle = UIBlox.Style.withStyle

local extended = Roact.PureComponent:extend("ListEntry")

extended.validateProps = t.strictInterface({
	text = t.string,
	hasBullet = t.boolean,
	layoutOrder = t.integer,
	positionChangedCallback = t.optional(t.callback),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	forwardRef = t.optional(t.table)
})

function extended.render(p)
	return withStyle(function(props)
		local font = props.Font
		local theme = props.Theme

		local font2 = font.CaptionBody.Font
		local textSize = font.BaseSize * font.CaptionBody.RelativeSize
		local v2

		if FoundationFontFaceMigration then
			v2 = GetTextSize("• ", textSize, props.Tokens.Typography.BodySmall.Font, Vector2.new(10000, 10000)).X
		else
			v2 = Text.GetTextWidth("• ", font2, textSize)
		end

		local forwardRef = p.props.forwardRef

		local createElement = Roact.createElement
		local fitFrameVertical = RoactFitComponents.FitFrameVertical
		local v3 = {
			width = UDim.new(1, 0),
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			BackgroundTransparency = 1,
			LayoutOrder = p.props.layoutOrder,
			[Roact.Change.AbsolutePosition] = p.props.positionChangedCallback,
			NextSelectionLeft = p.props.NextSelectionLeft,
			NextSelectionRight = p.props.NextSelectionRight,
			NextSelectionUp = p.props.NextSelectionUp,
			NextSelectionDown = p.props.NextSelectionDown,
			[Roact.Ref] = forwardRef
		}

		local bullet = p.props.hasBullet

		if bullet then
			local createElement2 = Roact.createElement
			local v4 = {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(v2, textSize),
				Text = "• ",
				Font = 0,
				FontFace = 0,
				TextSize = 0,
				TextColor3 = 0,
				TextTransparency = 0,
				TextXAlignment = 0,
				LayoutOrder = 1
			}
			local font3

			if not FoundationFontFaceMigration then
				font3 = font2
			end

			v4.Font = font3
			local fontFace

			if FoundationFontFaceMigration then
				fontFace = normalizeFontFace(props.Tokens.Typography.BodySmall.Font)
			end

			v4.FontFace = fontFace

			v4.TextSize = textSize
			v4.TextColor3 = theme.TextDefault.Color
			v4.TextTransparency = theme.TextDefault.Transparency
			v4.TextXAlignment = Enum.TextXAlignment.Left
			bullet = createElement2("TextLabel", v4)
		end

		local createElement2 = Roact.createElement
		local v4 = {
			width = UDim.new(1, p.props.hasBullet and -v2 or 0),
			BackgroundTransparency = 1,
			Text = p.props.text,
			Font = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextTransparency = 0,
			TextXAlignment = 0,
			LayoutOrder = 2
		}

		if v then
			font2 = normalizeFontFace(props.Tokens.Typography.BodySmall.Font)
		end

		v4.Font = font2

		v4.TextSize = textSize
		v4.TextColor3 = theme.TextDefault.Color
		v4.TextTransparency = theme.TextDefault.Transparency
		v4.TextXAlignment = Enum.TextXAlignment.Left
		return createElement(fitFrameVertical, v3, {
			Bullet = bullet,
			Text = createElement2(FitTextLabel, v4)
		})
	end)
end

return Roact.forwardRef(function(p, forwardRef)
	return Roact.createElement(extended, Cryo.Dictionary.join(p, { forwardRef = forwardRef }))
end)
