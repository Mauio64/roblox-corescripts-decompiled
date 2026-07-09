local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local FitFrameVertical = require(CorePackages.Packages.AvatarExperienceDeps).RoactFitComponents.FitFrameVertical
local withStyle = UIBlox.Style.withStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local v11 = if not require(Modules.AvatarExperience.Flags.FFlagAXFixBodyScaleReduxUpdates) then require(Modules.AvatarExperience.AvatarEditor.Components.BodySizeSlider_DEPRECATED) else require(Modules.AvatarExperience.AvatarEditor.Components.BodySizeSlider)
local v12 = Images["icons/menu/body_tall"]
local v13 = Images["icons/menu/body_thin"]
local v14 = Images["icons/menu/body_heavy"]
local v15 = Images["icons/menu/body_short"]
local v16 = Roact.PureComponent:extend("BodySizeRadar")

function v16.render(p1) -- line: 32
	-- upvalues: withStyle (copy), withLocalization (copy), Roact (copy), FitFrameVertical (copy), ImageSetLabel (copy), v12 (copy), v13 (copy), v11 (copy), v14 (copy), v15 (copy)
	return withStyle(function(p2) -- line: 33
		-- upvalues: withLocalization (copy), p1 (copy), Roact (copy), FitFrameVertical (copy), ImageSetLabel (copy), v12 (copy), v13 (copy), v11 (copy), v14 (copy), v15 (copy)
		return withLocalization({
			bodySize = "Feature.Avatar.Label.BodySize"
		})(function(p3) -- line: 36
			-- upvalues: p1 (copy), p2 (copy), Roact (copy), FitFrameVertical (copy), ImageSetLabel (copy), v12 (copy), v13 (copy), v11 (copy), v14 (copy), v15 (copy)
			local lockNavigationCallback = p1.props.lockNavigationCallback
			local unlockNavigationCallback = p1.props.unlockNavigationCallback
			local layoutOrder = p1.props.layoutOrder
			local isDisabled = p1.props.isDisabled
			local p2Font = p2.Font
			local Theme = p2.Theme
			local Header2Font = p2Font.Header2.Font
			local v29 = p2Font.BaseSize * p2Font.Header2.RelativeSize
			local forwardRef = p1.props.forwardRef

			return Roact.createElement(FitFrameVertical, {
				BackgroundTransparency = 1,
				width = UDim.new(1, 0),
				contentPadding = UDim.new(0, 24),
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				LayoutOrder = layoutOrder
			}, {
				BodySizeLabel = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, v29),
					Text = p3.bodySize,
					TextSize = v29,
					TextColor3 = Theme.TextDefault.Color,
					TextTransparency = Theme.TextDefault.TextTransparency,
					TextXAlignment = Enum.TextXAlignment.Left,
					Font = Header2Font
				}),
				BodySizeContainer = Roact.createElement(FitFrameVertical, {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					width = UDim.new(1, 0),
					contentPadding = UDim.new(0, 8),
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}, {
					TallIcon = Roact.createElement(ImageSetLabel, {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(0, 0.5),
						Size = UDim2.new(0, 36, 0, 36),
						ImageColor3 = Theme.IconEmphasis.Color,
						ImageTransparency = if not isDisabled then Theme.IconEmphasis.Transparency else 0.5,
						Image = v12
					}),
					Wrapper = Roact.createElement(FitFrameVertical, {
						BackgroundTransparency = 1,
						LayoutOrder = 2,
						width = UDim.new(1, 0),
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center
					}, {
						ThinIcon = Roact.createElement(ImageSetLabel, {
							LayoutOrder = 1,
							BackgroundTransparency = 1,
							AnchorPoint = Vector2.new(0, 0.5),
							Size = UDim2.new(0, 36, 0, 36),
							ImageColor3 = Theme.IconEmphasis.Color,
							ImageTransparency = if not isDisabled then Theme.IconEmphasis.Transparency else 0.5,
							Image = v13
						}),
						BodySize = Roact.createElement(v11, {
							LayoutOrder = 2,
							lockNavigationCallback = lockNavigationCallback,
							unlockNavigationCallback = unlockNavigationCallback,
							isDisabled = isDisabled,
							NextSelectionLeft = p1.props.NextSelectionLeft,
							NextSelectionRight = p1.props.NextSelectionRight,
							NextSelectionUp = p1.props.NextSelectionUp,
							NextSelectionDown = p1.props.NextSelectionDown,
							[Roact.Ref] = forwardRef
						}),
						HeavyIcon = Roact.createElement(ImageSetLabel, {
							LayoutOrder = 3,
							BackgroundTransparency = 1,
							AnchorPoint = Vector2.new(0, 0.5),
							Size = UDim2.new(0, 36, 0, 36),
							ImageColor3 = Theme.IconEmphasis.Color,
							ImageTransparency = if not isDisabled then Theme.IconEmphasis.Transparency else 0.5,
							Image = v14
						})
					}),
					ShortIcon = Roact.createElement(ImageSetLabel, {
						LayoutOrder = 3,
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(0, 0.5),
						Size = UDim2.new(0, 36, 0, 36),
						ImageColor3 = Theme.IconEmphasis.Color,
						ImageTransparency = if not isDisabled then Theme.IconEmphasis.Transparency else 0.5,
						Image = v15
					})
				})
			})
		end)
	end)
end

return Roact.forwardRef(function(p4, p5) -- line: 144
	-- upvalues: Roact (copy), v16 (copy), Cryo (copy)
	return Roact.createElement(v16, Cryo.Dictionary.join(p4, {
		forwardRef = p5
	}))
end)
