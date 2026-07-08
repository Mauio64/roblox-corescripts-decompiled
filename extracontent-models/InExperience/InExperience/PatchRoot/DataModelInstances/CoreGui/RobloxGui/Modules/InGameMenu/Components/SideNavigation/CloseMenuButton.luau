local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local t = InGameMenuDependencies.t
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local Cryo = InGameMenuDependencies.Cryo
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local ParentParent = script.Parent.Parent.Parent
local Assets = require(ParentParent.Resources.Assets)
local GlobalConfig = require(ParentParent.GlobalConfig)
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local v13 = t.strictInterface({
	AnchorPoint = t.optional(t.Vector2),
	Position = t.optional(t.UDim2),
	layoutOrder = t.optional(t.integer),
	onActivated = t.callback,
	onSelectionGained = t.optional(t.callback),
	onSelectionLost = t.optional(t.callback),
	forwardRef = t.optional(t.table)
})

local function renderWithSelectionCursor(p1, p2) -- line: 29
	-- upvalues: GlobalConfig (copy), v13 (copy), Roact (copy), ImageSetButton (copy), Assets (copy), CursorKind (copy)
	if GlobalConfig.propValidation then
		assert(v13(p1))
	end

	return Roact.createElement(ImageSetButton, {
		AnchorPoint = p1.AnchorPoint,
		BackgroundTransparency = 1,
		Image = Assets.Images.CloseButton,
		Position = p1.Position,
		Size = UDim2.new(0, 32, 0, 32),
		LayoutOrder = p1.layoutOrder,
		SelectionImageObject = p2(CursorKind.RoundedRect),
		[Roact.Event.Activated] = p1.onActivated,
		[Roact.Event.SelectionGained] = p1.onSelectionGained,
		[Roact.Event.SelectionLost] = p1.onSelectionLost,
		[Roact.Ref] = p1.forwardRef
	})
end
local function CloseMenuButton(p3) -- line: 50
	-- upvalues: withSelectionCursorProvider (copy), renderWithSelectionCursor (copy)
	return withSelectionCursorProvider(function(p4) -- line: 51
		-- upvalues: renderWithSelectionCursor (copy), p3 (copy)
		return renderWithSelectionCursor(p3, p4)
	end)
end

return Roact.forwardRef(function(p5, p6) -- line: 56
	-- upvalues: Roact (copy), CloseMenuButton (copy), Cryo (copy)
	return Roact.createElement(CloseMenuButton, Cryo.Dictionary.join(p5, {
		forwardRef = p6
	}))
end)
