local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local Cryo = require(CorePackages.Packages.Cryo)

local roactFitComponents = AvatarExperienceDeps.RoactFitComponents
local fitFrameOnAxis = roactFitComponents.FitFrameOnAxis
local fitFrameVertical = roactFitComponents.FitFrameVertical

local withStyle = UIBlox.Style.withStyle
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local images = UIBlox.App.ImageSet.Images
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization

local module = require("@luauforge/deferred/hev")

local iconsmenubody_female = images["icons/menu/body_female"]
local iconsmenubody_male = images["icons/menu/body_male"]
local iconsmenubody_neutral = images["icons/menu/body_neutral"]

local extended = Roact.PureComponent:extend("BodyTypeRadar")

function extended.render(p2)
	return withStyle(function(data)
		return withLocalization({ bodyType = "Feature.Avatar.Label.BodyType" })(function(p3)
			local lockNavigationCallback = p2.props.lockNavigationCallback
			local unlockNavigationCallback = p2.props.unlockNavigationCallback
			local layoutOrder = p2.props.layoutOrder
			local isDisabled = p2.props.isDisabled
			local font = data.Font
			local theme = data.Theme
			local v5 = font.BaseSize * font.Header2.RelativeSize
			local forwardRef = p2.props.forwardRef

			return Roact.createElement(fitFrameVertical, {
				width = UDim.new(1, 0),
				contentPadding = UDim.new(0, 36),
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				BackgroundTransparency = 1,
				LayoutOrder = layoutOrder
			}, {
				BodyTypeLabel = Roact.createElement("TextLabel", {
					Size = UDim2.new(1, 0, 0, v5),
					BackgroundTransparency = 1,
					Text = p3.bodyType,
					TextSize = v5,
					TextColor3 = theme.TextDefault.Color,
					TextTransparency = theme.TextDefault.TextTransparency,
					TextXAlignment = Enum.TextXAlignment.Left,
					LayoutOrder = 1,
					FontFace = normalizeFontFace(data.Tokens.Typography.TitleLarge.Font)
				}),
				Container = Roact.createElement(fitFrameVertical, {
					width = UDim.new(1, 0),
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					BackgroundTransparency = 1,
					LayoutOrder = 2
				}, {
					UpperRow = Roact.createElement(fitFrameVertical, {
						width = UDim.new(1, 0),
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Top,
						BackgroundTransparency = 1,
						LayoutOrder = 1
					}, {
						RthroWomanIcon = Roact.createElement(imageSetLabel, {
							AnchorPoint = Vector2.new(0, 0.5),
							Size = UDim2.new(0, 36, 0, 36),
							BackgroundTransparency = 1,
							ImageColor3 = theme.IconEmphasis.Color,
							ImageTransparency = isDisabled and 0.5 or theme.IconEmphasis.Transparency,
							Image = iconsmenubody_female,
							LayoutOrder = 1
						}),
						BodyType = Roact.createElement(module, {
							lockNavigationCallback = lockNavigationCallback,
							unlockNavigationCallback = unlockNavigationCallback,
							LayoutOrder = 2,
							isDisabled = isDisabled,
							NextSelectionLeft = p2.props.NextSelectionLeft,
							NextSelectionRight = p2.props.NextSelectionRight,
							NextSelectionUp = p2.props.NextSelectionUp,
							NextSelectionDown = p2.props.NextSelectionDown,
							[Roact.Ref] = forwardRef
						}),
						RthroManIcon = Roact.createElement(imageSetLabel, {
							AnchorPoint = Vector2.new(0, 0.5),
							Size = UDim2.new(0, 36, 0, 36),
							BackgroundTransparency = 1,
							Position = UDim2.new(1, -36, 0, 0),
							ImageColor3 = theme.IconEmphasis.Color,
							ImageTransparency = isDisabled and 0.5 or theme.IconEmphasis.Transparency,
							Image = iconsmenubody_male,
							LayoutOrder = 3
						})
					}),
					LowerRow = Roact.createElement(
						fitFrameOnAxis,
						{
							axis = fitFrameOnAxis.Axis.Both,
							margin = roactFitComponents.Rect.quad(8, 0, 0, 0),
							BackgroundTransparency = 1,
							LayoutOrder = 2
						},
						{
							MiniFigIcon = Roact.createElement(imageSetLabel, {
								AnchorPoint = Vector2.new(0.5, 0),
								Size = UDim2.new(0, 36, 0, 36),
								Position = UDim2.new(0.5, 0, 0, 0),
								BackgroundTransparency = 1,
								ImageColor3 = theme.IconEmphasis.Color,
								ImageTransparency = isDisabled and 0.5 or theme.IconEmphasis.Transparency,
								Image = iconsmenubody_neutral
							})
						}
					)
				})
			})
		end)
	end)
end

return Roact.forwardRef(function(p2, p3)
	return Roact.createElement(extended, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
