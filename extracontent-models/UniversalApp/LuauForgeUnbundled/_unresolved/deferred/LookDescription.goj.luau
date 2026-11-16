local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)

local skeleton = Foundation.Skeleton

local t = require(CorePackages.Packages.t)
local module = require("@luauforge/bundled/dwM")

local expandableTextArea = UIBlox.App.Text.ExpandableTextArea
local useStyle = UIBlox.Core.Style.useStyle
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local cursorKind = UIBlox.App.SelectionImage.CursorKind

local wrapped = module.wrap(t.strictInterface({
	compactNumberOfLines = t.optional(t.integer),
	isLoading = t.boolean,
	descriptionText = t.optional(t.string),
	width = t.optional(t.integer),
	Position = t.optional(t.UDim2),
	LayoutOrder = t.optional(t.integer)
}))

local function LookDescription(props)
	assert(wrapped(props))

	local layoutOrder = props.LayoutOrder

	local v5 = useStyle()
	local v6 = useSelectionCursor(cursorKind.RoundedRect)

	local compactNumberOfLines = props.compactNumberOfLines or 3
	local descriptionText = props.descriptionText
	local isLoading = props.isLoading
	local position = props.Position

	local size_150 = v5.Tokens.Size.Size_150
	local size_0 = v5.Tokens.Size.Size_0

	local font = v5.Font
	local v7 = compactNumberOfLines * (font.BaseSize * font.Body.RelativeSize) + size_150
	local v8 = v7 + size_0

	local createElement = Roact.createElement
	local frame = focusable.Frame
	local v9 = {
		LayoutOrder = layoutOrder,
		Position = UDim2.fromScale(0, 0),
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		SelectionImageObject = v6
	}

	local v11 = if isLoading then Roact.createElement(
		"Frame",
		{ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, v8) },
		{
			ShimmerPanel = Roact.createElement(skeleton, {
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0, 0, 1, 0),
				Size = UDim2.new(1, 0, 0, v7)
			})
		}
	) else nil

	local v12 = if descriptionText and descriptionText ~= "" then Roact.createElement(expandableTextArea, {
		LayoutOrder = layoutOrder,
		Position = position,
		Text = descriptionText,
		compactNumberOfLines = compactNumberOfLines,
		padding = Vector2.new(0, 0)
	}) else nil
	return createElement(frame, v9, {
		DescriptionShimmer = v11,
		DescriptionExpandable = v12
	})
end

return LookDescription
