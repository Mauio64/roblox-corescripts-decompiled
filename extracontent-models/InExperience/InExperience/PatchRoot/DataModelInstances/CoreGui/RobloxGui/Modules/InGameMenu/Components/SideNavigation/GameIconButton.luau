local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local t = InGameMenuDependencies.t
local Roact = InGameMenuDependencies.Roact
local Cryo = InGameMenuDependencies.Cryo
local UIBlox = InGameMenuDependencies.UIBlox
local Foundation = require(CorePackages.Packages.Foundation)
local FFlagCoreUiMigrateUIBloxToFoundation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCoreUiMigrateUIBloxToFoundation
local v9 = if not FFlagCoreUiMigrateUIBloxToFoundation then UIBlox.App.SelectionImage.withSelectionCursorProvider else Foundation.UNSTABLE.withCursorMigration
local v10 = if not FFlagCoreUiMigrateUIBloxToFoundation then UIBlox.App.SelectionImage.CursorKind else Foundation.Enums.CursorType
local ParentParent = script.Parent.Parent.Parent
local GameIcon = require(ParentParent.Components.GameIcon)
local uDim = UDim.new(0, 8)
local v14 = Roact.PureComponent:extend("GameIconButton")

v14.validateProps = t.strictInterface({
	anchorPoint = t.optional(t.Vector2),
	position = t.optional(t.UDim2),
	layoutOrder = t.optional(t.integer),
	onActivated = t.callback,
	onSelectionGained = t.optional(t.callback),
	onSelectionLost = t.optional(t.callback),
	forwardRef = t.optional(t.table)
})

function v14.renderWithSelectionCursor(p1, p2) -- line: 37
	-- upvalues: Roact (copy), v10 (copy), GameIcon (copy), uDim (copy)
	return Roact.createElement("TextButton", {
		Text = "",
		AnchorPoint = p1.props.anchorPoint,
		BackgroundTransparency = 1,
		Position = p1.props.position,
		Size = UDim2.fromOffset(32, 32),
		LayoutOrder = p1.props.layoutOrder,
		SelectionImageObject = p2(v10.RoundedRect),
		[Roact.Event.Activated] = p1.props.onActivated,
		[Roact.Event.SelectionGained] = p1.props.onSelectionGained,
		[Roact.Event.SelectionLost] = p1.props.onSelectionLost,
		[Roact.Ref] = p1.props.forwardRef
	}, {
		GameIconButton = Roact.createElement(GameIcon, {
			iconSize = 32,
			gameId = game.GameId,
			cornerRadius = uDim
		})
	})
end
function v14.render(p3) -- line: 60
	-- upvalues: v9 (copy)
	return v9(function(p4) -- line: 61
		-- upvalues: p3 (copy)
		return p3:renderWithSelectionCursor(p4)
	end)
end

return Roact.forwardRef(function(p5, p6) -- line: 66
	-- upvalues: Roact (copy), v14 (copy), Cryo (copy)
	return Roact.createElement(v14, Cryo.Dictionary.join(p5, {
		forwardRef = p6
	}))
end)
