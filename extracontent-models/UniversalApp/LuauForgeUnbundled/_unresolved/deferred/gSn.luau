local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)

local fitFrameVertical = AvatarExperienceDeps.RoactFitComponents.FitFrameVertical

local withStyle = UIBlox.Style.withStyle
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local images = UIBlox.App.ImageSet.Images
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local v5

if require("@luauforge/bundled/gSi") then
	v5 = require("@luauforge/deferred/gSo")
else
	v5 = require("@luauforge/deferred/gSp")
end

local iconsmenubody_tall = images["icons/menu/body_tall"]
local iconsmenubody_thin = images["icons/menu/body_thin"]
local iconsmenubody_heavy = images["icons/menu/body_heavy"]
local iconsmenubody_short = images["icons/menu/body_short"]

local extended = Roact.PureComponent:extend("BodySizeRadar")

function extended.render(p2)
	return withStyle(function(data)
		return withLocalization({ bodySize = "Feature.Avatar.Label.BodySize" })(function(p3)
			local lockNavigationCallback = p2.props.lockNavigationCallback
			local unlockNavigationCallback = p2.props.unlockNavigationCallback
			local layoutOrder = p2.props.layoutOrder
			local isDisabled = p2.props.isDisabled
			local font = data.Font
			local theme = data.Theme
			local font2 = font.Header2.Font
			local v6 = font.BaseSize * font.Header2.RelativeSize

			local forwardRef = p2.props.forwardRef

			local createElement = Roact.createElement
			local v8 = {
				width = UDim.new(1, 0),
				contentPadding = UDim.new(0, 24),
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				BackgroundTransparency = 1,
				LayoutOrder = layoutOrder
			}

			local createElement2 = Roact.createElement
			local v10 = {
				Size = UDim2.new(1, 0, 0, v6),
				BackgroundTransparency = 1,
				Text = p3.bodySize,
				TextSize = v6,
				TextColor3 = theme.TextDefault.Color,
				TextTransparency = theme.TextDefault.TextTransparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = 1,
				Font = 0,
				FontFace = 0
			}

			if foundationFontFaceMigration then
				font2 = nil
			end

			v10.Font = font2

			local v11 = if foundationFontFaceMigration then normalizeFontFace(data.Tokens.Typography.TitleLarge.Font) else nil
			v10.FontFace = v11
			return createElement(fitFrameVertical, v8, {
				BodySizeLabel = createElement2("TextLabel", v10),
				BodySizeContainer = Roact.createElement(fitFrameVertical, {
					width = UDim.new(1, 0),
					contentPadding = UDim.new(0, 8),
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					BackgroundTransparency = 1,
					LayoutOrder = 2
				}, {
					TallIcon = Roact.createElement(imageSetLabel, {
						AnchorPoint = Vector2.new(0, 0.5),
						LayoutOrder = 1,
						Size = UDim2.new(0, 36, 0, 36),
						BackgroundTransparency = 1,
						ImageColor3 = theme.IconEmphasis.Color,
						ImageTransparency = isDisabled and 0.5 or theme.IconEmphasis.Transparency,
						Image = iconsmenubody_tall
					}),
					Wrapper = Roact.createElement(fitFrameVertical, {
						width = UDim.new(1, 0),
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						BackgroundTransparency = 1,
						LayoutOrder = 2
					}, {
						ThinIcon = Roact.createElement(imageSetLabel, {
							AnchorPoint = Vector2.new(0, 0.5),
							LayoutOrder = 1,
							Size = UDim2.new(0, 36, 0, 36),
							BackgroundTransparency = 1,
							ImageColor3 = theme.IconEmphasis.Color,
							ImageTransparency = isDisabled and 0.5 or theme.IconEmphasis.Transparency,
							Image = iconsmenubody_thin
						}),
						BodySize = Roact.createElement(v5, {
							LayoutOrder = 2,
							lockNavigationCallback = lockNavigationCallback,
							unlockNavigationCallback = unlockNavigationCallback,
							isDisabled = isDisabled,
							NextSelectionLeft = p2.props.NextSelectionLeft,
							NextSelectionRight = p2.props.NextSelectionRight,
							NextSelectionUp = p2.props.NextSelectionUp,
							NextSelectionDown = p2.props.NextSelectionDown,
							[Roact.Ref] = forwardRef
						}),
						HeavyIcon = Roact.createElement(imageSetLabel, {
							AnchorPoint = Vector2.new(0, 0.5),
							LayoutOrder = 3,
							Size = UDim2.new(0, 36, 0, 36),
							ImageColor3 = theme.IconEmphasis.Color,
							ImageTransparency = isDisabled and 0.5 or theme.IconEmphasis.Transparency,
							BackgroundTransparency = 1,
							Image = iconsmenubody_heavy
						})
					}),
					ShortIcon = Roact.createElement(imageSetLabel, {
						AnchorPoint = Vector2.new(0, 0.5),
						LayoutOrder = 3,
						Size = UDim2.new(0, 36, 0, 36),
						BackgroundTransparency = 1,
						ImageColor3 = theme.IconEmphasis.Color,
						ImageTransparency = isDisabled and 0.5 or theme.IconEmphasis.Transparency,
						Image = iconsmenubody_short
					})
				})
			})
		end)
	end)
end

return Roact.forwardRef(function(p2, p3)
	return Roact.createElement(extended, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
