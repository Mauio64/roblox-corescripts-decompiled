local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t
local UIBlox = InGameMenuDependencies.UIBlox
local Foundation = require(CorePackages.Packages.Foundation)
local FFlagCoreUiMigrateUIBloxToFoundation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCoreUiMigrateUIBloxToFoundation
local v9 = if not FFlagCoreUiMigrateUIBloxToFoundation then UIBlox.App.SelectionImage.withSelectionCursorProvider else Foundation.UNSTABLE.withCursorMigration
local v10 = if not FFlagCoreUiMigrateUIBloxToFoundation then UIBlox.App.SelectionImage.CursorKind else Foundation.Enums.CursorType
local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Resources.Constants)
local Direction = require(ParentParent.Enums.Direction)
local SetCurrentZone = require(ParentParent.Actions.SetCurrentZone)
local PortalSize = Constants.Zone.PortalSize
local t1 = {
	[Direction.Up] = {
		size = UDim2.new(1, 0, 0, PortalSize),
		position = UDim2.new(0, 0, 0, 0)
	},
	[Direction.Down] = {
		size = UDim2.new(1, 0, 0, PortalSize),
		position = UDim2.new(0, 0, 1, -PortalSize)
	},
	[Direction.Left] = {
		size = UDim2.new(0, PortalSize, 1, 0),
		position = UDim2.new(0, 0, 0, 0)
	},
	[Direction.Right] = {
		size = UDim2.new(0, PortalSize, 1, 0),
		position = UDim2.new(1, -PortalSize, 0, 0)
	}
}
local v17 = Roact.PureComponent:extend("ZonePortal")

v17.validateProps = t.strictInterface({
	targetZone = t.number,
	direction = Direction.isEnumValue,
	setCurrentZone = t.optional(t.callback)
})

function v17.render(p1) -- line: 56
	-- upvalues: t1 (copy), v9 (copy), Roact (copy), v10 (copy)
	local v19 = t1[p1.props.direction]

	return v9(function(p2) -- line: 60
		-- upvalues: Roact (copy), v19 (copy), v10 (copy), p1 (copy)
		return Roact.createElement("Frame", {
			Size = v19.size,
			Position = v19.position,
			BackgroundTransparency = 1,
			Selectable = true,
			ZIndex = 2147483647,
			SelectionImageObject = p2(v10.Invisible),
			[Roact.Event.SelectionGained] = function() -- line: 68
				-- upvalues: p1 (copy)
				p1.props.setCurrentZone(p1.props.targetZone)
			end
		})
	end)
end

return (RoactRodux.UNSTABLE_connect2(nil, function(p3) -- line: 75
	-- upvalues: SetCurrentZone (copy)
	return {
		setCurrentZone = function(p4) -- line: 77
			-- upvalues: p3 (copy), SetCurrentZone (copy)
			return p3(SetCurrentZone(p4))
		end
	}
end)(v17))
