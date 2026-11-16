local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local backgroundLayers = require("@luauforge/deferred/gkN").BackgroundLayersComponents.BackgroundLayers

local view = Foundation.View
local button = Foundation.Button
local module2 = require("@luauforge/deferred/gPY")

local fFlagAXFixCatalogTileThumbnailFlash = AvatarExperienceFlags.FFlagAXFixCatalogTileThumbnailFlash
local fFlagAXHeroSpotlightReportsThumbnailLoaded = AvatarExperienceFlags.FFlagAXHeroSpotlightReportsThumbnailLoaded

local function HeroUnitSpotlightCardView(props)
	local createElement = React.createElement
	local v6 = {
		Size = UDim2.new(1, 0, 0, props.cardHeight),
		onActivated = props.onTryOn,
		tag = {
			["radius-large clip"] = true,
			["stroke-thick stroke-system-contrast"] = props.isSelected
		},
		ref = props.cardRef
	}
	local v8

	if props.backgroundLayers and #props.backgroundLayers > 0 then
		local createElement2 = React.createElement

		local createElement3 = React.createElement
		local v13 = {
			backgroundLayers = props.backgroundLayers,
			cornerRadius = props.cornerRadius,
			ZIndex = 0,
			imageScaleType = Enum.ScaleType.Crop,
			onImageLoaded = 0
		}

		local v14 = if fFlagAXHeroSpotlightReportsThumbnailLoaded then props.onBackgroundImageLoaded else nil
		v13.onImageLoaded = v14
		v8 = createElement2(view, { ZIndex = 0, tag = "size-full radius-large clip" }, {
			Layers = createElement3(backgroundLayers, v13)
		})
	end

	return createElement(view, v6, {
		Backgrounds = v8,
		ContentColumn = React.createElement(
			view,
			{
				ZIndex = 2,
				tag = `col align-x-left size-full {props.cardPaddingTag}`
			},
			{
				Header = React.createElement(module2, {
					titleText = props.titleText,
					titleTag = props.titleTag,
					descriptionText = props.descriptionText,
					descriptionTag = props.descriptionTag,
					titleGroupGapTag = props.titleGroupGapTag,
					priceInRobux = props.priceInRobux,
					availableUntil = props.availableUntil,
					centerTitleGroup = true,
					bottomSlot = React.createElement(button, {
						text = props.detailsButtonText,
						size = props.buttonSize,
						onActivated = props.onOpenDetails
					})
				})
			}
		)
	})
end

if fFlagAXFixCatalogTileThumbnailFlash then
	return (React.memo(HeroUnitSpotlightCardView))
end

return HeroUnitSpotlightCardView
