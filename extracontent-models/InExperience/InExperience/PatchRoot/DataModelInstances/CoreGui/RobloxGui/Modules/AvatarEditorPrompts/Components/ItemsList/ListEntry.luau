local CorePackages = game:GetService("CorePackages")
local _ = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local Text = require(CorePackages.Workspace.Packages.AppCommonLib).Text
local RoactFitComponents = AvatarExperienceDeps.RoactFitComponents
local FitTextLabel = RoactFitComponents.FitTextLabel
local withStyle = UIBlox.Style.withStyle
local v12 = Roact.PureComponent:extend("ListEntry")

v12.validateProps = t.strictInterface({
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

function v12.render(p1) -- line: 34
	-- upvalues: withStyle (copy), Text (copy), Roact (copy), RoactFitComponents (copy), FitTextLabel (copy)
	return withStyle(function(p2) -- line: 35
		-- upvalues: Text (copy), p1 (copy), Roact (copy), RoactFitComponents (copy), FitTextLabel (copy)
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
			NextSelectionLeft = p1.props.NextSelectionLeft,
			NextSelectionRight = p1.props.NextSelectionRight,
			NextSelectionUp = p1.props.NextSelectionUp,
			NextSelectionDown = p1.props.NextSelectionDown,
			[Roact.Ref] = forwardRef
		}, {
			Bullet = p1.props.hasBullet and Roact.createElement("TextLabel", {
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
				width = UDim.new(1, p1.props.hasBullet and -v21 or 0),
				Text = p1.props.text,
				Font = CaptionBodyFont,
				TextSize = v20,
				TextColor3 = Theme.TextDefault.Color,
				TextTransparency = Theme.TextDefault.Transparency,
				TextXAlignment = Enum.TextXAlignment.Left
			})
		})
	end)
end

return Roact.forwardRef(function(p3, p4) -- line: 91
	-- upvalues: Roact (copy), v12 (copy), Cryo (copy)
	return Roact.createElement(v12, Cryo.Dictionary.join(p3, {
		forwardRef = p4
	}))
end)
