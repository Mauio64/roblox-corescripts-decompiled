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
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagFontFaceAX = SharedFlags.FFlagFontFaceAX
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)

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

		local x = GetTextSize("• ", textSize, props.Tokens.Typography.BodySmall.Font, Vector2.new(10000, 10000)).X
		local forwardRef = p.props.forwardRef

		local createElement = Roact.createElement
		local fitFrameVertical = RoactFitComponents.FitFrameVertical
		local v = {
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
		local v2 = {
			Bullet = p.props.hasBullet and Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(x, textSize),
				Text = "• ",
				FontFace = normalizeFontFace(props.Tokens.Typography.BodySmall.Font),
				TextSize = textSize,
				TextColor3 = theme.TextDefault.Color,
				TextTransparency = theme.TextDefault.Transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = 1
			}),
			Text = 0
		}

		local createElement2 = Roact.createElement
		local v3 = {
			width = UDim.new(1, p.props.hasBullet and -x or 0),
			BackgroundTransparency = 1,
			Text = p.props.text,
			Font = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextTransparency = 0,
			TextXAlignment = 0,
			LayoutOrder = 2
		}

		if FFlagFontFaceAX then
			font2 = normalizeFontFace(props.Tokens.Typography.BodySmall.Font)
		end

		v3.Font = font2

		v3.TextSize = textSize
		v3.TextColor3 = theme.TextDefault.Color
		v3.TextTransparency = theme.TextDefault.Transparency
		v3.TextXAlignment = Enum.TextXAlignment.Left
		v2.Text = createElement2(FitTextLabel, v3)
		return createElement(fitFrameVertical, v, v2)
	end)
end

return Roact.forwardRef(function(p, forwardRef)
	return Roact.createElement(extended, Cryo.Dictionary.join(p, { forwardRef = forwardRef }))
end)
