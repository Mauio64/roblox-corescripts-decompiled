local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local t = InGameMenuDependencies.t
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local Images = UIBlox.App.ImageSet.Images
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local Image = require(CorePackages.Packages.Foundation).Image
local FFlagCoreUiMigrateUIBloxToFoundation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCoreUiMigrateUIBloxToFoundation
local v12 = if not FFlagCoreUiMigrateUIBloxToFoundation then Images["icons/menu/home_on"] else "icons/menu/home_on"
local v13 = if not FFlagCoreUiMigrateUIBloxToFoundation then Images["icons/menu/home_off"] else "icons/menu/home_off"
local v14 = Roact.PureComponent:extend("HomeButton")

v14.validateProps = t.strictInterface({
	on = t.optional(t.boolean),
	anchorPoint = t.optional(t.Vector2),
	position = t.optional(t.UDim2),
	layoutOrder = t.optional(t.integer),
	onActivated = t.callback
})
v14.defaultProps = {
	on = false
}

function v14.renderWithSelectionCursor(p1, p2) -- line: 43
	-- upvalues: v12 (copy), v13 (copy), Roact (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), Image (copy), CursorKind (copy), ImageSetButton (copy)
	local v17 = p1.props.on and v12 or v13

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		AnchorPoint = p1.props.anchorPoint,
		Position = p1.props.position,
		Size = UDim2.fromOffset(64, 64),
		LayoutOrder = p1.props.layoutOrder
	}, {
		HomeButton = if not FFlagCoreUiMigrateUIBloxToFoundation then Roact.createElement(ImageSetButton, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = v17,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(32, 32),
			SelectionImageObject = p2(CursorKind.RoundedRect),
			[Roact.Event.Activated] = p1.props.onActivated
		}) else Roact.createElement(Image, {
			tag = "position-center-center anchor-center-center size-800",
			Image = v17,
			selection = {
				SelectionImageObject = p2(CursorKind.RoundedRect)
			},
			onActivated = p1.props.onActivated
		})
	})
end
function v14.render(p3) -- line: 71
	-- upvalues: withSelectionCursorProvider (copy)
	return withSelectionCursorProvider(function(p4) -- line: 72
		-- upvalues: p3 (copy)
		return p3:renderWithSelectionCursor(p4)
	end)
end

return v14
