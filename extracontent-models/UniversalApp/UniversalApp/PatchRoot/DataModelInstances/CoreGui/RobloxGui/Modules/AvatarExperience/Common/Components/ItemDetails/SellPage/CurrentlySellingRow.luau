local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactFitComponents = require(CorePackages.Packages.AvatarExperienceDeps).RoactFitComponents
local FitFrameVertical = RoactFitComponents.FitFrameVertical
local withStyle = UIBlox.Style.withStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local FitTextLabel = RoactFitComponents.FitTextLabel
local FFlagAXRemoveSellPageAndChildrenGamepadBindings = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXRemoveSellPageAndChildrenGamepadBindings
local v17 = Images["icons/common/robux"]
local v18 = Images["icons/actions/edit/remove"]
local v19 = Roact.PureComponent:extend("CurrentlySellingRow")

v19.defaultProps = {
	horizontalPadding = 0,
	onActivated = function() -- line: 47
	end
}

function v19.render(p1) -- line: 50
	-- upvalues: withStyle (copy), withSelectionCursorProvider (copy), Roact (copy), Focusable (copy), CursorKind (copy), FFlagAXRemoveSellPageAndChildrenGamepadBindings (copy), RoactGamepad (copy), FitFrameVertical (copy), FitTextLabel (copy), ImageSetLabel (copy), v17 (copy), v18 (copy)
	local userAssetInfo = p1.props.userAssetInfo

	if not userAssetInfo then
		return
	end

	return withStyle(function(p2) -- line: 55
		-- upvalues: p1 (copy), userAssetInfo (copy), withSelectionCursorProvider (copy), Roact (copy), Focusable (copy), CursorKind (copy), FFlagAXRemoveSellPageAndChildrenGamepadBindings (copy), RoactGamepad (copy), FitFrameVertical (copy), FitTextLabel (copy), ImageSetLabel (copy), v17 (copy), v18 (copy)
		local p2Font = p2.Font
		local Theme = p2.Theme
		local propsPosition = p1.props.Position
		local propsLayoutOrder = p1.props.LayoutOrder
		local horizontalPadding = p1.props.horizontalPadding
		local onActivated = p1.props.onActivated
		local isLimitedUnique = p1.props.isLimitedUnique
		local v35 = p2Font.BaseSize * p2Font.Body.RelativeSize
		local v36 = "# " .. tostring(userAssetInfo.serialNumber)
		local priceInRobux = userAssetInfo.priceInRobux
		local forwardRef = p1.props.forwardRef

		return withSelectionCursorProvider(function(p3) -- line: 72
			-- upvalues: Roact (copy), Focusable (copy), propsLayoutOrder (copy), propsPosition (copy), p1 (copy), forwardRef (copy), CursorKind (copy), FFlagAXRemoveSellPageAndChildrenGamepadBindings (copy), RoactGamepad (copy), onActivated (copy), horizontalPadding (copy), FitFrameVertical (copy), isLimitedUnique (copy), FitTextLabel (copy), p2Font (copy), v35 (copy), v36 (copy), Theme (copy), ImageSetLabel (copy), v17 (copy), priceInRobux (copy), v18 (copy)
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
				onFocusGained = p1.props.onFocusGained,
				SelectionImageObject = p3(CursorKind.RoundedRectNoInset),
				inputBindings = if not FFlagAXRemoveSellPageAndChildrenGamepadBindings then {
					RemoveItemFromSale = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, onActivated)
				} else nil
			}, {
				Padding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, horizontalPadding),
					PaddingRight = UDim.new(0, horizontalPadding)
				}),
				SerialAndPriceContainer = Roact.createElement(FitFrameVertical, {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					width = UDim.new(1, 0),
					contentPadding = UDim.new(0, 6),
					FillDirection = Enum.FillDirection.Vertical,
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, 0, 0.5, 0)
				}, {
					SerialNumberTextLabel = isLimitedUnique and Roact.createElement(FitTextLabel, {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						LayoutOrder = 1,
						width = UDim.new(1, 0),
						Font = p2Font.Body.Font,
						Position = UDim2.new(0, 0, 0, -v35),
						Size = UDim2.new(1, 0, 0, 0),
						Text = v36,
						TextColor3 = Theme.TextEmphasis.Color,
						TextSize = v35,
						TextTransparency = Theme.TextEmphasis.Transparency,
						TextXAlignment = Enum.TextXAlignment.Left
					}),
					RobuxContainer = Roact.createElement(FitFrameVertical, {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						LayoutOrder = 2,
						width = UDim.new(1, -40),
						contentPadding = UDim.new(0, 6),
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center
					}, {
						Image = Roact.createElement(ImageSetLabel, {
							LayoutOrder = 1,
							BackgroundTransparency = 1,
							Size = UDim2.new(0, v35, 0, v35),
							Image = v17,
							ImageColor3 = Theme.TextDefault.Color,
							ImageTransparency = Theme.TextDefault.Transparency
						}),
						Text = Roact.createElement(FitTextLabel, {
							LayoutOrder = 2,
							BackgroundTransparency = 1,
							width = UDim.new(1, 0),
							Size = UDim2.new(1, -v35, 0, v35),
							Text = tostring(priceInRobux),
							Font = p2Font.Body.Font,
							TextColor3 = Theme.TextDefault.Color,
							TextTransparency = Theme.TextDefault.Transparency,
							TextSize = v35,
							TextXAlignment = Enum.TextXAlignment.Left
						})
					})
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
					RemoveIcon = Roact.createElement(ImageSetLabel, {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						LayoutOrder = 2,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Image = v18,
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

local u20 = RoactRodux.connect(function(p4, p5) -- line: 183
	return {
		userAssetInfo = p4.AvatarExperience.Catalog.UserAssets[p5.userAssetId]
	}
end)(v19)

return Roact.forwardRef(function(p6, p7) -- line: 190
	-- upvalues: Roact (copy), u20 (ref), Cryo (copy)
	return Roact.createElement(u20, Cryo.Dictionary.join(p6, {
		forwardRef = p7
	}))
end)
