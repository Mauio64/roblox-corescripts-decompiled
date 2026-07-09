local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local Text = require(CorePackages.Workspace.Packages.AppCommonLib).Text
local RoactFitComponents = AvatarExperienceDeps.RoactFitComponents
local FitTextLabel = RoactFitComponents.FitTextLabel
local withStyle = UIBlox.Style.withStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local v13 = Roact.PureComponent:extend("BulletListEntry")

v13.validateProps = t.strictInterface({
	text = t.string,
	layoutOrder = t.integer,
	positionChangedCallback = t.optional(t.callback),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	forwardRef = t.optional(t.table)
})

function v13.renderWithProviders(p1, p2, p3) -- line: 36
	-- upvalues: Text (copy), Roact (copy), RoactFitComponents (copy), CursorKind (copy), FitTextLabel (copy)
	local p2Font = p2.Font
	local Theme = p2.Theme
	local CaptionBodyFont = p2Font.CaptionBody.Font
	local v20 = p2Font.BaseSize * p2Font.CaptionBody.RelativeSize
	local v21 = Text.GetTextWidth("• ", CaptionBodyFont, v20)
	local forwardRef = p1.props.forwardRef

	return Roact.createElement(RoactFitComponents.FitFrameVertical, {
		width = UDim.new(1, 0),
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		BackgroundTransparency = 1,
		LayoutOrder = p1.props.layoutOrder,
		[Roact.Change.AbsolutePosition] = p1.props.positionChangedCallback,
		SelectionImageObject = p3(CursorKind.RoundedRect),
		NextSelectionLeft = p1.props.NextSelectionLeft,
		NextSelectionRight = p1.props.NextSelectionRight,
		NextSelectionUp = p1.props.NextSelectionUp,
		NextSelectionDown = p1.props.NextSelectionDown,
		[Roact.Ref] = forwardRef
	}, {
		Bullet = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Text = "• ",
			LayoutOrder = 1,
			Size = UDim2.fromOffset(v21, v20),
			Font = CaptionBodyFont,
			TextSize = v20,
			TextColor3 = Theme.TextDefault.Color,
			TextTransparency = Theme.TextDefault.Transparency,
			TextXAlignment = Enum.TextXAlignment.Left
		}),
		Text = Roact.createElement(FitTextLabel, {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			width = UDim.new(1, -v21),
			Text = p1.props.text,
			Font = CaptionBodyFont,
			TextSize = v20,
			TextColor3 = Theme.TextDefault.Color,
			TextTransparency = Theme.TextDefault.Transparency,
			TextXAlignment = Enum.TextXAlignment.Left
		})
	})
end
function v13.render(p4) -- line: 92
	-- upvalues: withStyle (copy), withSelectionCursorProvider (copy)
	return withStyle(function(p5) -- line: 93
		-- upvalues: withSelectionCursorProvider (copy), p4 (copy)
		return withSelectionCursorProvider(function(p6) -- line: 94
			-- upvalues: p4 (copy), p5 (copy)
			return p4:renderWithProviders(p5, p6)
		end)
	end)
end

return Roact.forwardRef(function(p7, p8) -- line: 100
	-- upvalues: Roact (copy), v13 (copy), Cryo (copy)
	return Roact.createElement(v13, Cryo.Dictionary.join(p7, {
		forwardRef = p8
	}))
end)
