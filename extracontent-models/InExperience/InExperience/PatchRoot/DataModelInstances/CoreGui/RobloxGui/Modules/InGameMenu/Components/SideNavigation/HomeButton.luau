local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local t = InGameMenuDependencies.t
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox

local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local Images = UIBlox.App.ImageSet.Images
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

local Image = Foundation.Image

local v3 = FFlagCoreUiMigrateUIBloxToFoundation and "icons/menu/home_on" or Images["icons/menu/home_on"]

local v4 = FFlagCoreUiMigrateUIBloxToFoundation and "icons/menu/home_off" or Images["icons/menu/home_off"]

local extended = Roact.PureComponent:extend("HomeButton")

extended.validateProps = t.strictInterface({
	on = t.optional(t.boolean),
	anchorPoint = t.optional(t.Vector2),
	position = t.optional(t.UDim2),
	layoutOrder = t.optional(t.integer),
	onActivated = t.callback
})

extended.defaultProps = { on = false }

function extended:renderWithSelectionCursor(callback)
	local image = self.props.on and v3 or v4
	local createElement = Roact.createElement
	local v5 = {
		AnchorPoint = self.props.anchorPoint,
		BackgroundTransparency = 1,
		Position = self.props.position,
		Size = UDim2.fromOffset(64, 64),
		LayoutOrder = self.props.layoutOrder
	}
	local homeButton

	if FFlagCoreUiMigrateUIBloxToFoundation then
		homeButton = Roact.createElement(Image, {
			Image = image,
			tag = "position-center-center anchor-center-center size-800",
			backgroundStyle = { Transparency = 1 },
			selection = { SelectionImageObject = callback(v2.RoundedRect) },
			onActivated = self.props.onActivated
		})
	else
		homeButton = Roact.createElement(ImageSetButton, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = image,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(32, 32),
			SelectionImageObject = callback(v2.RoundedRect),
			[Roact.Event.Activated] = self.props.onActivated
		})
	end

	return createElement("Frame", v5, { HomeButton = homeButton })
end

function extended:render()
	return v(function(p)
		return self:renderWithSelectionCursor(p)
	end)
end

return extended
