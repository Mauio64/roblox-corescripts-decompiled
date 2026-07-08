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
game:GetService("CoreGui"):WaitForChild("RobloxGui")
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

local function renderWithSelectionCursor(p1, p2) -- line: 44
	-- upvalues: Roact (copy), ImageSetButton (copy), CursorKind (copy)
	return Roact.createElement(ImageSetButton, {
		Visible = true,
		AnchorPoint = p1.AnchorPoint,
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/MenuBar/divider.png",
		Position = UDim2.new(0, 1, 0, 1),
		Size = UDim2.new(0, 28, 0, 36),
		LayoutOrder = p1.layoutOrder,
		SelectionImageObject = p2(CursorKind.RoundedRect),
		[Roact.Event.Activated] = function() -- line: 55
		end,
		[Roact.Event.SelectionGained] = p1.onSelectionGained,
		[Roact.Event.SelectionLost] = p1.onSelectionLost,
		[Roact.Ref] = p1.forwardRef
	})
end
local function VRBarSeparator(p3) -- line: 64
	-- upvalues: withSelectionCursorProvider (copy), renderWithSelectionCursor (copy)
	return withSelectionCursorProvider(function(p4) -- line: 65
		-- upvalues: renderWithSelectionCursor (copy), p3 (copy)
		return renderWithSelectionCursor(p3, p4)
	end)
end

return Roact.forwardRef(function(p5, p6) -- line: 70
	-- upvalues: Roact (copy), VRBarSeparator (copy), Cryo (copy)
	return Roact.createElement(VRBarSeparator, Cryo.Dictionary.join(p5, {
		forwardRef = p6
	}))
end)
