local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t
local UIBlox = InGameMenuDependencies.UIBlox
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
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
local v15 = Roact.PureComponent:extend("ZonePortal")

v15.validateProps = t.strictInterface({
	targetZone = t.number,
	direction = Direction.isEnumValue,
	setCurrentZone = t.optional(t.callback)
})

function v15.render(p1) -- line: 49
	-- upvalues: t1 (copy), withSelectionCursorProvider (copy), Roact (copy), CursorKind (copy)
	local v17 = t1[p1.props.direction]

	return withSelectionCursorProvider(function(p2) -- line: 53
		-- upvalues: Roact (copy), v17 (copy), CursorKind (copy), p1 (copy)
		return Roact.createElement("Frame", {
			Size = v17.size,
			Position = v17.position,
			BackgroundTransparency = 1,
			Selectable = true,
			ZIndex = 2147483647,
			SelectionImageObject = p2(CursorKind.Invisible),
			[Roact.Event.SelectionGained] = function() -- line: 61
				-- upvalues: p1 (copy)
				p1.props.setCurrentZone(p1.props.targetZone)
			end
		})
	end)
end

return (RoactRodux.UNSTABLE_connect2(nil, function(p3) -- line: 68
	-- upvalues: SetCurrentZone (copy)
	return {
		setCurrentZone = function(p4) -- line: 70
			-- upvalues: p3 (copy), SetCurrentZone (copy)
			return p3(SetCurrentZone(p4))
		end
	}
end)(v15))
