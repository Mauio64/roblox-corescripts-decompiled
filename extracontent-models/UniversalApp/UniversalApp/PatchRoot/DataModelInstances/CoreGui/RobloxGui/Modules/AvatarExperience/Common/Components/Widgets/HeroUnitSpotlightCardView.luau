local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local BackgroundLayers = require(CorePackages.Workspace.Packages.AvatarExperienceUIKit).BackgroundLayersComponents.BackgroundLayers
local View = Foundation.View
local Button = Foundation.Button
local HeroUnitHeader = require(Modules.AvatarExperience.Common.Components.Widgets.HeroUnitHeader)

local function HeroUnitSpotlightCardView(t1: {[any]: any}) -- line: 44
	-- upvalues: React (copy), View (copy), BackgroundLayers (copy), HeroUnitHeader (copy), Button (copy)
	return React.createElement(View, {
		Size = UDim2.new(1, 0, 0, t1.cardHeight),
		onActivated = t1.onTryOn,
		tag = {
			["radius-large clip"] = true,
			["stroke-thick stroke-system-contrast"] = t1.isSelected
		},
		ref = t1.cardRef
	}, {
		Backgrounds = if not t1.backgroundLayers or not (#t1.backgroundLayers > 0) then nil else React.createElement(View, {
			ZIndex = 0,
			tag = "size-full radius-large clip"
		}, {
			Layers = React.createElement(BackgroundLayers, {
				ZIndex = 0,
				backgroundLayers = t1.backgroundLayers,
				cornerRadius = t1.cornerRadius,
				imageScaleType = Enum.ScaleType.Crop
			})
		}),
		ContentColumn = React.createElement(View, {
			ZIndex = 2,
			tag = `col align-x-left size-full { t1.cardPaddingTag }`
		}, {
			Header = React.createElement(HeroUnitHeader, {
				centerTitleGroup = true,
				titleText = t1.titleText,
				titleTag = t1.titleTag,
				descriptionText = t1.descriptionText,
				descriptionTag = t1.descriptionTag,
				titleGroupGapTag = t1.titleGroupGapTag,
				priceInRobux = t1.priceInRobux,
				availableUntil = t1.availableUntil,
				bottomSlot = React.createElement(Button, {
					text = t1.detailsButtonText,
					size = t1.buttonSize,
					onActivated = t1.onOpenDetails
				})
			})
		})
	})
end

if AvatarExperienceFlags.FFlagAXFixCatalogTileThumbnailFlash then
	return (React.memo(HeroUnitSpotlightCardView))
end

return HeroUnitSpotlightCardView
