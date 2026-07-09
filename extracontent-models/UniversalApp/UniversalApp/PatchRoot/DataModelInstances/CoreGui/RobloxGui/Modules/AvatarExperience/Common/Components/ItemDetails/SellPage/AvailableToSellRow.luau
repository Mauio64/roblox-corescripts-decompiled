local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local withStyle = UIBlox.Style.withStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local FFlagAXRemoveSellPageAndChildrenGamepadBindings = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXRemoveSellPageAndChildrenGamepadBindings
local v13 = Images["icons/actions/edit/add"]
local v14 = Roact.PureComponent:extend("AvailableToSellRow")

v14.defaultProps = {
	horizontalPadding = 24,
	onActivated = function() -- line: 36
	end
}

function v14.render(p1) -- line: 39
	-- upvalues: withStyle (copy), withSelectionCursorProvider (copy), Roact (copy), Focusable (copy), CursorKind (copy), FFlagAXRemoveSellPageAndChildrenGamepadBindings (copy), RoactGamepad (copy), ImageSetLabel (copy), v13 (copy)
	return withStyle(function(p2) -- line: 40
		-- upvalues: p1 (copy), withSelectionCursorProvider (copy), Roact (copy), Focusable (copy), CursorKind (copy), FFlagAXRemoveSellPageAndChildrenGamepadBindings (copy), RoactGamepad (copy), ImageSetLabel (copy), v13 (copy)
		local p2Font = p2.Font
		local Theme = p2.Theme
		local propsPosition = p1.props.Position
		local propsLayoutOrder = p1.props.LayoutOrder
		local horizontalPadding = p1.props.horizontalPadding
		local onActivated = p1.props.onActivated
		local v25 = p2Font.BaseSize * p2Font.Body.RelativeSize
		local propsText = p1.props.Text
		local forwardRef = p1.props.forwardRef

		return withSelectionCursorProvider(function(p3) -- line: 54
			-- upvalues: Roact (copy), Focusable (copy), propsLayoutOrder (copy), propsPosition (copy), p1 (copy), forwardRef (copy), CursorKind (copy), FFlagAXRemoveSellPageAndChildrenGamepadBindings (copy), RoactGamepad (copy), onActivated (copy), horizontalPadding (copy), p2Font (copy), propsText (copy), Theme (copy), v25 (copy), ImageSetLabel (copy), v13 (copy)
			return Roact.createElement(Focusable.Frame, {
				BackgroundTransparency = 1,
				LayoutOrder = propsLayoutOrder,
				Position = propsPosition,
				Size = UDim2.new(1, 0, 0, 70),
				NextSelectionLeft = p1.props.NextSelectionLeft,
				NextSelectionRight = p1.props.NextSelectionRight,
				NextSelectionUp = p1.props.NextSelectionUp,
				NextSelectionDown = p1.props.NextSelectionDown,
				[Roact.Ref] = forwardRef,
				SelectionImageObject = p3(CursorKind.RoundedRectNoInset),
				inputBindings = if not FFlagAXRemoveSellPageAndChildrenGamepadBindings then {
					SellItem = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, onActivated)
				} else nil
			}, {
				Paddding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, horizontalPadding),
					PaddingRight = UDim.new(0, horizontalPadding)
				}),
				TextLabel = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 1,
					AnchorPoint = Vector2.new(0, 0.5),
					Font = p2Font.Body.Font,
					Position = UDim2.new(0, 0, 0.5, 0),
					Size = UDim2.new(1, -50, 1, 0),
					Text = propsText,
					TextColor3 = Theme.TextDefault.Color,
					TextSize = v25,
					TextTransparency = Theme.TextDefault.Transparency,
					TextXAlignment = Enum.TextXAlignment.Left
				}),
				PressableButton = Roact.createElement("TextButton", {
					AnchorPoint = Vector2.new(0, 0.5),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Position = UDim2.new(1, -50, 0.5, 0),
					Size = UDim2.new(0, 50, 0, 50),
					Text = "",
					[Roact.Event.Activated] = onActivated
				}, {
					RemoveButton = Roact.createElement(ImageSetLabel, {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						LayoutOrder = 2,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Image = v13,
						ImageColor3 = Theme.IconEmphasis.Color,
						ImageTransparency = Theme.IconEmphasis.Transparency,
						Position = UDim2.new(0.5, 0, 0.5, 0),
						Size = UDim2.new(0, 40, 0, 40)
					})
				})
			})
		end)
	end)
end

return Roact.forwardRef(function(p4, p5) -- line: 118
	-- upvalues: Roact (copy), v14 (copy), Cryo (copy)
	return Roact.createElement(v14, Cryo.Dictionary.join(p4, {
		forwardRef = p5
	}))
end)
