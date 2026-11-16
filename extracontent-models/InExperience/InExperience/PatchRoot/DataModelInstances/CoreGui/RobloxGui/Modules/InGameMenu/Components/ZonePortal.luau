local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t

local UIBlox = InGameMenuDependencies.UIBlox
local Foundation = require(CorePackages.Packages.Foundation)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation
local v

if FFlagCoreUiMigrateUIBloxToFoundation then
	v = Foundation.UNSTABLE.withCursorMigration
else
	v = UIBlox.App.SelectionImage.withSelectionCursorProvider
end

local v2

if FFlagCoreUiMigrateUIBloxToFoundation then
	v2 = Foundation.Enums.CursorType
else
	v2 = UIBlox.App.SelectionImage.CursorKind
end

local parent = script.Parent.Parent
local Constants = require(parent.Resources.Constants)
local Direction = require(parent.Enums.Direction)
local SetCurrentZone = require(parent.Actions.SetCurrentZone)

local PortalSize = Constants.Zone.PortalSize

local v3 = {
	[Direction.Up] = { size = UDim2.new(1, 0, 0, PortalSize), position = UDim2.new(0, 0, 0, 0) },
	[Direction.Down] = {
		size = UDim2.new(1, 0, 0, PortalSize),
		position = UDim2.new(0, 0, 1, -PortalSize)
	},
	[Direction.Left] = { size = UDim2.new(0, PortalSize, 1, 0), position = UDim2.new(0, 0, 0, 0) },
	[Direction.Right] = {
		size = UDim2.new(0, PortalSize, 1, 0),
		position = UDim2.new(1, -PortalSize, 0, 0)
	}
}

local extended = Roact.PureComponent:extend("ZonePortal")

extended.validateProps = t.strictInterface({
	targetZone = t.number,
	direction = Direction.isEnumValue,
	setCurrentZone = t.optional(t.callback)
})

function extended.render(p)
	local v4 = v3[p.props.direction]

	return v(function(callback)
		return Roact.createElement("Frame", {
			Size = v4.size,
			Position = v4.position,
			BackgroundTransparency = 1,
			Selectable = true,
			ZIndex = 2147483647,
			SelectionImageObject = callback(v2.Invisible),
			[Roact.Event.SelectionGained] = function()
				p.props.setCurrentZone(p.props.targetZone)
			end
		})
	end)
end

return (RoactRodux.UNSTABLE_connect2(nil, function(callback)
	return {
		setCurrentZone = function(p)
			return callback(SetCurrentZone(p))
		end
	}
end)(extended))
