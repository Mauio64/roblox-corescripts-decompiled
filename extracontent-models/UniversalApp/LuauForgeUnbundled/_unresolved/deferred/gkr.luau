local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local skeleton = Foundation.Skeleton

local t = require(CorePackages.Packages.t)
local module = require("@luauforge/bundled/dwM")

local expandableTextArea = UIBlox.App.Text.ExpandableTextArea
local useStyle = UIBlox.Core.Style.useStyle
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local cursorKind = UIBlox.App.SelectionImage.CursorKind

local module2 = require("@luauforge/deferred/gks")
local fFlagAXFixItemDetailsDescriptionSpacing = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXFixItemDetailsDescriptionSpacing

local vector2 = Vector2.new(5, 0)

local wrap = module.wrap
local strictInterface = t.strictInterface
local v5 = {
	compactNumberOfLines = t.optional(t.integer),
	descriptionText = t.optional(t.string),
	width = t.optional(t.integer),
	Position = t.optional(t.UDim2),
	LayoutOrder = t.optional(t.integer),
	forwardRef = t.optional(t.table),
	NextSelectionUp = 0,
	NextSelectionDown = 0
}
local v6 = if module2() then t.optional(t.table) else nil
v5.NextSelectionUp = v6
v5.NextSelectionDown = t.optional(t.table)
local wrapped = wrap(strictInterface(v5))

local function renderItemDescription(p2, p3, props)
	local compactNumberOfLines = props.compactNumberOfLines or 3
	local descriptionText = props.descriptionText
	local position = props.Position
	local layoutOrder = props.LayoutOrder

	if descriptionText then
		return Roact.createElement(expandableTextArea, {
			LayoutOrder = layoutOrder,
			Position = position,
			Text = descriptionText,
			compactNumberOfLines = compactNumberOfLines,
			padding = if fFlagAXFixItemDetailsDescriptionSpacing then vector2 else nil
		})
	else
		local font = p2.Font
		local v7 = compactNumberOfLines * (font.BaseSize * font.Body.RelativeSize) + 5

		local v8 = if fFlagAXFixItemDetailsDescriptionSpacing then v7 else v7 + 30

		return Roact.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, v8),
				SelectionImageObject = p3
			},
			{
				ShimmerPanel = Roact.createElement(skeleton, {
					AnchorPoint = Vector2.new(0, 1),
					Position = UDim2.new(0, 0, 1, 0),
					Size = UDim2.new(1, 0, 0, v7)
				})
			}
		)
	end
end

local function ItemDescription(p2)
	assert(wrapped(p2))

	local layoutOrder = p2.LayoutOrder
	local forwardRef = p2.forwardRef

	local v7 = useStyle()
	local v8 = useSelectionCursor(cursorKind.RoundedRect)

	return Roact.createElement("Frame", {
		LayoutOrder = layoutOrder,
		Position = UDim2.fromScale(0, 0),
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		[Roact.Ref] = forwardRef,
		SelectionImageObject = v8
	}, { renderItemDescription(v7, v8, p2) })
end

return Roact.forwardRef(function(p2, p3)
	return Roact.createElement(ItemDescription, Cryo.Dictionary.join(p2, {
		forwardRef = p3
	}))
end)
