local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local Skeleton = Foundation.Skeleton
local t = require(CorePackages.Packages.t)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local ExpandableTextArea = UIBlox.App.Text.ExpandableTextArea
local useStyle = UIBlox.Core.Style.useStyle
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local v14 = ArgCheck.wrap(t.strictInterface({
	compactNumberOfLines = t.optional(t.integer),
	isLoading = t.boolean,
	descriptionText = t.optional(t.string),
	width = t.optional(t.integer),
	Position = t.optional(t.UDim2),
	LayoutOrder = t.optional(t.integer)
}))

local function LookDescription(t1: {[any]: any}) -- line: 41
	-- upvalues: v14 (copy), useStyle (copy), useSelectionCursor (copy), CursorKind (copy), FFlagRenameDeprecatedUIBloxTokens (copy), Roact (copy), Focusable (copy), Skeleton (copy), ExpandableTextArea (copy)
	assert(v14(t1))

	local t1LayoutOrder = t1.LayoutOrder
	local v18 = useStyle()
	local v19 = useSelectionCursor(CursorKind.RoundedRect)
	local v20 = t1.compactNumberOfLines or 3
	local descriptionText = t1.descriptionText
	local isLoading = t1.isLoading
	local t1Position = t1.Position
	local v24 = if not FFlagRenameDeprecatedUIBloxTokens then v18.Tokens.Global.Space_75 else v18.Tokens.Size.Size_150
	local v25 = if not FFlagRenameDeprecatedUIBloxTokens then v18.Tokens.Global.Space_0 else v18.Tokens.Size.Size_0
	local Font = v18.Font
	local v27 = v20 * (Font.BaseSize * Font.Body.RelativeSize) + v24
	local v28 = v27 + v25

	return Roact.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		LayoutOrder = t1LayoutOrder,
		Position = UDim2.fromScale(0, 0),
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		SelectionImageObject = v19
	}, {
		DescriptionShimmer = if not isLoading then nil else Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, v28)
		}, {
			ShimmerPanel = Roact.createElement(Skeleton, {
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0, 0, 1, 0),
				Size = UDim2.new(1, 0, 0, v27)
			})
		}),
		DescriptionExpandable = if not descriptionText or descriptionText == "" then nil else Roact.createElement(ExpandableTextArea, {
			LayoutOrder = t1LayoutOrder,
			Position = t1Position,
			Text = descriptionText,
			compactNumberOfLines = v20,
			padding = Vector2.new(0, 0)
		})
	})
end

return LookDescription
