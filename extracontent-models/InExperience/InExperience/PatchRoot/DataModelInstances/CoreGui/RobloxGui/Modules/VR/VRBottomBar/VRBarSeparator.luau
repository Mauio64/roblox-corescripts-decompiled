local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local t = InGameMenuDependencies.t
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local Cryo = InGameMenuDependencies.Cryo
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind

local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton

game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
CoreGui:WaitForChild("RobloxGui")
game:GetService("StarterPlayer")

t.strictInterface({
	AnchorPoint = t.optional(t.Vector2),
	Position = t.optional(t.UDim2),
	layoutOrder = t.optional(t.integer),
	onActivated = t.callback,
	onSelectionGained = t.optional(t.callback),
	onSelectionLost = t.optional(t.callback),
	forwardRef = t.optional(t.table)
})

local function renderWithSelectionCursor(props, callback)
	return Roact.createElement(ImageSetButton, {
		Visible = true,
		AnchorPoint = props.AnchorPoint,
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/MenuBar/divider.png",
		Position = UDim2.new(0, 1, 0, 1),
		Size = UDim2.new(0, 28, 0, 36),
		LayoutOrder = props.layoutOrder,
		SelectionImageObject = callback(CursorKind.RoundedRect),
		[Roact.Event.Activated] = function() end,
		[Roact.Event.SelectionGained] = props.onSelectionGained,
		[Roact.Event.SelectionLost] = props.onSelectionLost,
		[Roact.Ref] = props.forwardRef
	})
end

local function VRBarSeparator(p)
	return withSelectionCursorProvider(function(p2)
		return renderWithSelectionCursor(p, p2)
	end)
end

return Roact.forwardRef(function(p, forwardRef)
	return Roact.createElement(VRBarSeparator, Cryo.Dictionary.join(p, { forwardRef = forwardRef }))
end)
