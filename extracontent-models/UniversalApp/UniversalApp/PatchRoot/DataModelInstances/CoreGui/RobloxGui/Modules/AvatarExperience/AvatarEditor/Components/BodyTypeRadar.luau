local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactFitComponents = AvatarExperienceDeps.RoactFitComponents
local FitFrameOnAxis = RoactFitComponents.FitFrameOnAxis
local FitFrameVertical = RoactFitComponents.FitFrameVertical
local withStyle = UIBlox.Style.withStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local v14 = if not require(Modules.AvatarExperience.Flags.FFlagAXFixBodyScaleReduxUpdates) then require(Modules.AvatarExperience.AvatarEditor.Components.BodyTypeSlider_DEPRECATED) else require(Modules.AvatarExperience.AvatarEditor.Components.BodyTypeSlider)
local v15 = Images["icons/menu/body_female"]
local v16 = Images["icons/menu/body_male"]
local v17 = Images["icons/menu/body_neutral"]
local v18 = Roact.PureComponent:extend("BodyTypeRadar")

function v18.render(p1) -- line: 33
	-- upvalues: withStyle (copy), withLocalization (copy), Roact (copy), FitFrameVertical (copy), ImageSetLabel (copy), v15 (copy), v14 (copy), v16 (copy), FitFrameOnAxis (copy), RoactFitComponents (copy), v17 (copy)
	return withStyle(function(p2) -- line: 34
		-- upvalues: withLocalization (copy), p1 (copy), Roact (copy), FitFrameVertical (copy), ImageSetLabel (copy), v15 (copy), v14 (copy), v16 (copy), FitFrameOnAxis (copy), RoactFitComponents (copy), v17 (copy)
		return withLocalization({
			bodyType = "Feature.Avatar.Label.BodyType"
		})(function(p3) -- line: 37
			-- upvalues: p1 (copy), p2 (copy), Roact (copy), FitFrameVertical (copy), ImageSetLabel (copy), v15 (copy), v14 (copy), v16 (copy), FitFrameOnAxis (copy), RoactFitComponents (copy), v17 (copy)
			local lockNavigationCallback = p1.props.lockNavigationCallback
			local unlockNavigationCallback = p1.props.unlockNavigationCallback
			local layoutOrder = p1.props.layoutOrder
			local isDisabled = p1.props.isDisabled
			local p2Font = p2.Font
			local Theme = p2.Theme
			local Header2Font = p2Font.Header2.Font
			local v31 = p2Font.BaseSize * p2Font.Header2.RelativeSize
			local forwardRef = p1.props.forwardRef

			return Roact.createElement(FitFrameVertical, {
				BackgroundTransparency = 1,
				width = UDim.new(1, 0),
				contentPadding = UDim.new(0, 36),
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				LayoutOrder = layoutOrder
			}, {
				BodyTypeLabel = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, v31),
					Text = p3.bodyType,
					TextSize = v31,
					TextColor3 = Theme.TextDefault.Color,
					TextTransparency = Theme.TextDefault.TextTransparency,
					TextXAlignment = Enum.TextXAlignment.Left,
					Font = Header2Font
				}),
				Container = Roact.createElement(FitFrameVertical, {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					width = UDim.new(1, 0),
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}, {
					UpperRow = Roact.createElement(FitFrameVertical, {
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						width = UDim.new(1, 0),
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Top
					}, {
						RthroWomanIcon = Roact.createElement(ImageSetLabel, {
							BackgroundTransparency = 1,
							LayoutOrder = 1,
							AnchorPoint = Vector2.new(0, 0.5),
							Size = UDim2.new(0, 36, 0, 36),
							ImageColor3 = Theme.IconEmphasis.Color,
							ImageTransparency = if not isDisabled then Theme.IconEmphasis.Transparency else 0.5,
							Image = v15
						}),
						BodyType = Roact.createElement(v14, {
							lockNavigationCallback = lockNavigationCallback,
							unlockNavigationCallback = unlockNavigationCallback,
							LayoutOrder = 2,
							isDisabled = isDisabled,
							NextSelectionLeft = p1.props.NextSelectionLeft,
							NextSelectionRight = p1.props.NextSelectionRight,
							NextSelectionUp = p1.props.NextSelectionUp,
							NextSelectionDown = p1.props.NextSelectionDown,
							[Roact.Ref] = forwardRef
						}),
						RthroManIcon = Roact.createElement(ImageSetLabel, {
							BackgroundTransparency = 1,
							LayoutOrder = 3,
							AnchorPoint = Vector2.new(0, 0.5),
							Size = UDim2.new(0, 36, 0, 36),
							Position = UDim2.new(1, -36, 0, 0),
							ImageColor3 = Theme.IconEmphasis.Color,
							ImageTransparency = if not isDisabled then Theme.IconEmphasis.Transparency else 0.5,
							Image = v16
						})
					}),
					LowerRow = Roact.createElement(FitFrameOnAxis, {
						BackgroundTransparency = 1,
						LayoutOrder = 2,
						axis = FitFrameOnAxis.Axis.Both,
						margin = RoactFitComponents.Rect.quad(8, 0, 0, 0)
					}, {
						MiniFigIcon = Roact.createElement(ImageSetLabel, {
							BackgroundTransparency = 1,
							AnchorPoint = Vector2.new(0.5, 0),
							Size = UDim2.new(0, 36, 0, 36),
							Position = UDim2.new(0.5, 0, 0, 0),
							ImageColor3 = Theme.IconEmphasis.Color,
							ImageTransparency = if not isDisabled then Theme.IconEmphasis.Transparency else 0.5,
							Image = v17
						})
					})
				})
			})
		end)
	end)
end

return Roact.forwardRef(function(p4, p5) -- line: 145
	-- upvalues: Roact (copy), v18 (copy), Cryo (copy)
	return Roact.createElement(v18, Cryo.Dictionary.join(p4, {
		forwardRef = p5
	}))
end)
