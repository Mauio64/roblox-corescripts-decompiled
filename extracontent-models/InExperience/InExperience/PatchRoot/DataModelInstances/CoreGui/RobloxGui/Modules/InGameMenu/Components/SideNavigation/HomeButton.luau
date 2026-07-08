local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local t = InGameMenuDependencies.t
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local Images = UIBlox.App.ImageSet.Images
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local v10 = Images["icons/menu/home_on"]
local v11 = Images["icons/menu/home_off"]
local v12 = Roact.PureComponent:extend("HomeButton")

v12.validateProps = t.strictInterface({
	on = t.optional(t.boolean),
	anchorPoint = t.optional(t.Vector2),
	position = t.optional(t.UDim2),
	layoutOrder = t.optional(t.integer),
	onActivated = t.callback
})
v12.defaultProps = {
	on = false
}

function v12.renderWithSelectionCursor(p1, p2) -- line: 34
	-- upvalues: v10 (copy), v11 (copy), Roact (copy), ImageSetButton (copy), CursorKind (copy)
	local v15 = p1.props.on and v10 or v11

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		AnchorPoint = p1.props.anchorPoint,
		Position = p1.props.position,
		Size = UDim2.fromOffset(64, 64),
		LayoutOrder = p1.props.layoutOrder
	}, {
		HomeButton = Roact.createElement(ImageSetButton, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = v15,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(32, 32),
			SelectionImageObject = p2(CursorKind.RoundedRect),
			[Roact.Event.Activated] = p1.props.onActivated
		})
	})
end
function v12.render(p3) -- line: 55
	-- upvalues: withSelectionCursorProvider (copy)
	return withSelectionCursorProvider(function(p4) -- line: 56
		-- upvalues: p3 (copy)
		return p3:renderWithSelectionCursor(p4)
	end)
end

return v12
