local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local t = InGameMenuDependencies.t
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local Images = UIBlox.App.ImageSet.Images
local Foundation = require(CorePackages.Packages.Foundation)
local FFlagCoreUiMigrateUIBloxToFoundation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCoreUiMigrateUIBloxToFoundation
local v10 = if not FFlagCoreUiMigrateUIBloxToFoundation then UIBlox.App.SelectionImage.withSelectionCursorProvider else Foundation.UNSTABLE.withCursorMigration
local v11 = if not FFlagCoreUiMigrateUIBloxToFoundation then UIBlox.App.SelectionImage.CursorKind else Foundation.Enums.CursorType
local FoundationImage = Foundation.Image
local v13 = if not FFlagCoreUiMigrateUIBloxToFoundation then Images["icons/menu/home_on"] else "icons/menu/home_on"
local v14 = if not FFlagCoreUiMigrateUIBloxToFoundation then Images["icons/menu/home_off"] else "icons/menu/home_off"
local v15 = Roact.PureComponent:extend("HomeButton")

v15.validateProps = t.strictInterface({
	on = t.optional(t.boolean),
	anchorPoint = t.optional(t.Vector2),
	position = t.optional(t.UDim2),
	layoutOrder = t.optional(t.integer),
	onActivated = t.callback
})
v15.defaultProps = {
	on = false
}

function v15.renderWithSelectionCursor(p1, p2) -- line: 45
	-- upvalues: v13 (copy), v14 (copy), Roact (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), FoundationImage (copy), v11 (copy), ImageSetButton (copy)
	local v18 = p1.props.on and v13 or v14

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
			Image = v18,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(32, 32),
			SelectionImageObject = p2(v11.RoundedRect),
			[Roact.Event.Activated] = p1.props.onActivated
		}) else Roact.createElement(FoundationImage, {
			tag = "position-center-center anchor-center-center size-800",
			Image = v18,
			backgroundStyle = {
				Transparency = 1
			},
			selection = {
				SelectionImageObject = p2(v11.RoundedRect)
			},
			onActivated = p1.props.onActivated
		})
	})
end
function v15.render(p3) -- line: 74
	-- upvalues: v10 (copy)
	return v10(function(p4) -- line: 75
		-- upvalues: p3 (copy)
		return p3:renderWithSelectionCursor(p4)
	end)
end

return v15
