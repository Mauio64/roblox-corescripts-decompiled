local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)

local roactFitComponents = AvatarExperienceDeps.RoactFitComponents
local fitFrameVertical = roactFitComponents.FitFrameVertical

local withStyle = UIBlox.Style.withStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local images = UIBlox.App.ImageSet.Images

local fitTextLabel = roactFitComponents.FitTextLabel

local iconscommonrobux = images["icons/common/robux"]
local iconsactionseditremove = images["icons/actions/edit/remove"]

local extended = Roact.PureComponent:extend("CurrentlySellingRow")

extended.defaultProps = {
	horizontalPadding = 0,
	onActivated = function() end
}

function extended.render(p2)
	local userAssetInfo = p2.props.userAssetInfo

	if userAssetInfo then
		return withStyle(function(p3)
			local font = p3.Font
			local theme = p3.Theme

			local position = p2.props.Position
			local layoutOrder = p2.props.LayoutOrder
			local horizontalPadding = p2.props.horizontalPadding
			local onActivated = p2.props.onActivated
			local isLimitedUnique = p2.props.isLimitedUnique

			local v5 = font.BaseSize * font.Body.RelativeSize

			local v6 = "# " .. tostring(userAssetInfo.serialNumber)
			local priceInRobux = userAssetInfo.priceInRobux

			local forwardRef = p2.props.forwardRef

			return withSelectionCursorProvider(function(callback)
				return Roact.createElement(focusable.Frame, {
					BackgroundTransparency = 1,
					LayoutOrder = layoutOrder,
					Position = position,
					Size = UDim2.new(1, 0, 0, 70),
					NextSelectionLeft = p2.props.NextSelectionLeft,
					NextSelectionRight = p2.props.NextSelectionRight,
					NextSelectionUp = p2.props.NextSelectionUp,
					NextSelectionDown = p2.props.NextSelectionDown,
					[Roact.Ref] = forwardRef,
					onFocusGained = p2.props.onFocusGained,
					SelectionImageObject = callback(cursorKind.RoundedRectNoInset)
				}, {
					Padding = Roact.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, horizontalPadding),
						PaddingRight = UDim.new(0, horizontalPadding)
					}),
					SerialAndPriceContainer = Roact.createElement(fitFrameVertical, {
						width = UDim.new(1, 0),
						contentPadding = UDim.new(0, 6),
						FillDirection = Enum.FillDirection.Vertical,
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(0, 0, 0.5, 0),
						BackgroundTransparency = 1,
						LayoutOrder = 1
					}, {
						SerialNumberTextLabel = isLimitedUnique and Roact.createElement(fitTextLabel, {
							width = UDim.new(1, 0),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Font = font.Body.Font,
							LayoutOrder = 1,
							Position = UDim2.new(0, 0, 0, -v5),
							Size = UDim2.new(1, 0, 0, 0),
							Text = v6,
							TextColor3 = theme.TextEmphasis.Color,
							TextSize = v5,
							TextTransparency = theme.TextEmphasis.Transparency,
							TextXAlignment = Enum.TextXAlignment.Left
						}),
						RobuxContainer = Roact.createElement(fitFrameVertical, {
							width = UDim.new(1, -40),
							contentPadding = UDim.new(0, 6),
							FillDirection = Enum.FillDirection.Horizontal,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							LayoutOrder = 2
						}, {
							Image = Roact.createElement(imageSetLabel, {
								LayoutOrder = 1,
								BackgroundTransparency = 1,
								Size = UDim2.new(0, v5, 0, v5),
								Image = iconscommonrobux,
								ImageColor3 = theme.TextDefault.Color,
								ImageTransparency = theme.TextDefault.Transparency
							}),
							Text = Roact.createElement(fitTextLabel, {
								width = UDim.new(1, 0),
								LayoutOrder = 2,
								Size = UDim2.new(1, -v5, 0, v5),
								BackgroundTransparency = 1,
								Text = tostring(priceInRobux),
								Font = font.Body.Font,
								TextColor3 = theme.TextDefault.Color,
								TextTransparency = theme.TextDefault.Transparency,
								TextSize = v5,
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
						RemoveIcon = Roact.createElement(imageSetLabel, {
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Image = iconsactionseditremove,
							ImageColor3 = theme.IconEmphasis.Color,
							ImageTransparency = theme.IconEmphasis.Transparency,
							LayoutOrder = 2,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							Size = UDim2.new(0, 40, 0, 40)
						})
					})
				})
			end)
		end)
	end
end

local v5 = RoactRodux.connect(function(p2, p3)
	return { userAssetInfo = p2.AvatarExperience.Catalog.UserAssets[p3.userAssetId] }
end)(extended)

return Roact.forwardRef(function(p2, p3)
	return Roact.createElement(v5, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
