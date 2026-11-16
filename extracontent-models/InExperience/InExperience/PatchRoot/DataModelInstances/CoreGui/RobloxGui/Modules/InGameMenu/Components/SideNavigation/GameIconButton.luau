local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local t = InGameMenuDependencies.t
local Roact = InGameMenuDependencies.Roact
local Cryo = InGameMenuDependencies.Cryo
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

local parent = script.Parent.Parent.Parent
local GameIcon = require(parent.Components.GameIcon)

local udim = UDim.new(0, 8)

local extended = Roact.PureComponent:extend("GameIconButton")

extended.validateProps = t.strictInterface({
	anchorPoint = t.optional(t.Vector2),
	position = t.optional(t.UDim2),
	layoutOrder = t.optional(t.integer),
	onActivated = t.callback,
	onSelectionGained = t.optional(t.callback),
	onSelectionLost = t.optional(t.callback),
	forwardRef = t.optional(t.table)
})

function extended:renderWithSelectionCursor(callback)
	return Roact.createElement("TextButton", {
		Text = "",
		AnchorPoint = self.props.anchorPoint,
		BackgroundTransparency = 1,
		Position = self.props.position,
		Size = UDim2.fromOffset(32, 32),
		LayoutOrder = self.props.layoutOrder,
		SelectionImageObject = callback(v2.RoundedRect),
		[Roact.Event.Activated] = self.props.onActivated,
		[Roact.Event.SelectionGained] = self.props.onSelectionGained,
		[Roact.Event.SelectionLost] = self.props.onSelectionLost,
		[Roact.Ref] = self.props.forwardRef
	}, {
		GameIconButton = Roact.createElement(GameIcon, {
			gameId = game.GameId,
			iconSize = 32,
			cornerRadius = udim
		})
	})
end

function extended:render()
	return v(function(p)
		return self:renderWithSelectionCursor(p)
	end)
end

return Roact.forwardRef(function(p, forwardRef)
	return Roact.createElement(extended, Cryo.Dictionary.join(p, { forwardRef = forwardRef }))
end)
