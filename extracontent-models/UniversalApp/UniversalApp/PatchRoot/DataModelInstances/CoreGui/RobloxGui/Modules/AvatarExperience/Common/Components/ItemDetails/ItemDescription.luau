local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local Skeleton = require(CorePackages.Packages.Foundation).Skeleton
local t = require(CorePackages.Packages.t)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local ExpandableTextArea = UIBlox.App.Text.ExpandableTextArea
local useStyle = UIBlox.Core.Style.useStyle
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local GetFFlagL2ControllerSupport = require(Modules.AvatarExperience.Flags.GetFFlagL2ControllerSupport)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local v16 = ArgCheck.wrap(t.strictInterface({
	compactNumberOfLines = t.optional(t.integer),
	descriptionText = t.optional(t.string),
	width = t.optional(t.integer),
	Position = t.optional(t.UDim2),
	LayoutOrder = t.optional(t.integer),
	forwardRef = t.optional(t.table),
	NextSelectionUp = if not GetFFlagL2ControllerSupport() then nil else t.optional(t.table),
	NextSelectionDown = t.optional(t.table)
}))

local function renderItemDescription(p1, p2, t1: {[any]: any}) -- line: 55
	-- upvalues: GetFFlagL2ControllerSupport (copy), Roact (copy), ExpandableTextArea (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Focusable (copy), Skeleton (copy)
	local v22 = t1.compactNumberOfLines or 3
	local descriptionText = t1.descriptionText
	local t1Position = t1.Position
	local t1LayoutOrder = t1.LayoutOrder
	local v26 = if not GetFFlagL2ControllerSupport() then nil else t1.NextSelectionUp
	local NextSelectionDown = t1.NextSelectionDown

	if descriptionText then
		return Roact.createElement(ExpandableTextArea, {
			LayoutOrder = t1LayoutOrder,
			Position = t1Position,
			Text = descriptionText,
			compactNumberOfLines = v22,
			NextSelectionUp = if not FFlagAXMigrateAXToGlobalAutofocus then v26 else nil,
			NextSelectionDown = if not FFlagAXMigrateAXToGlobalAutofocus then NextSelectionDown else nil
		})
	end

	local p1Font = p1.Font
	local v29 = v22 * (p1Font.BaseSize * p1Font.Body.RelativeSize) + 5
	local v30 = v29 + 30

	return Roact.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then Focusable.Frame else "Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, v30),
		NextSelectionUp = if not FFlagAXMigrateAXToGlobalAutofocus then v26 else nil,
		NextSelectionDown = if not FFlagAXMigrateAXToGlobalAutofocus then NextSelectionDown else nil,
		SelectionImageObject = p2
	}, {
		ShimmerPanel = Roact.createElement(Skeleton, {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			Size = UDim2.new(1, 0, 0, v29)
		})
	})
end
local function ItemDescription(t2: {[any]: any}) -- line: 96
	-- upvalues: v16 (copy), useStyle (copy), useSelectionCursor (copy), CursorKind (copy), Roact (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Focusable (copy), renderItemDescription (copy)
	assert(v16(t2))

	local t2LayoutOrder = t2.LayoutOrder
	local forwardRef = t2.forwardRef
	local v34 = useStyle()
	local v35 = useSelectionCursor(CursorKind.RoundedRect)

	return Roact.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then Focusable.Frame else "Frame", {
		LayoutOrder = t2LayoutOrder,
		Position = UDim2.fromScale(0, 0),
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		[Roact.Ref] = forwardRef,
		NextSelectionDown = if not FFlagAXMigrateAXToGlobalAutofocus then t2.NextSelectionDown else nil,
		SelectionImageObject = v35
	}, { renderItemDescription(v34, v35, t2) })
end

return Roact.forwardRef(function(p3, p4) -- line: 120
	-- upvalues: Roact (copy), ItemDescription (copy), Cryo (copy)
	return Roact.createElement(ItemDescription, Cryo.Dictionary.join(p3, {
		forwardRef = p4
	}))
end)
