local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local backgroundLayers = require("@luauforge/deferred/gPt").BackgroundLayersComponents.BackgroundLayers

local view = Foundation.View
local button = Foundation.Button
local module2 = require("@luauforge/deferred/hcb")
local module3 = require("@luauforge/deferred/hcc")

local fFlagAXFixCatalogTileThumbnailFlash = AvatarExperienceFlags.FFlagAXFixCatalogTileThumbnailFlash
local fFlagAXHeroSpotlightReportsThumbnailLoaded = AvatarExperienceFlags.FFlagAXHeroSpotlightReportsThumbnailLoaded
local fFlagAXHeroUnitActionButton = AvatarExperienceFlags.FFlagAXHeroUnitActionButton

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

	local createElement2 = React.createElement
	local v10 = {
		ZIndex = 2,
		tag = `col align-x-left size-full {props.cardPaddingTag}`
	}

	local createElement3 = React.createElement
	local v13 = {
		titleText = props.titleText,
		titleTag = props.titleTag,
		descriptionText = props.descriptionText,
		descriptionTag = props.descriptionTag,
		titleGroupGapTag = props.titleGroupGapTag,
		priceInRobux = props.priceInRobux,
		availableUntil = props.availableUntil,
		centerTitleGroup = true,
		bottomSlot = 0,
		bottomSlotTrailing = 0
	}

	local createElement4 = React.createElement
	local v15 = {
		text = props.detailsButtonText,
		size = props.buttonSize,
		onActivated = props.onOpenDetails,
		testId = 0
	}
	local v16 = if fFlagAXHeroUnitActionButton then props.detailsButtonTestId else nil
	v15.testId = v16
	v13.bottomSlot = createElement4(button, v15)

	local v17 = if fFlagAXHeroUnitActionButton and props.heroUnitButtonAction then React.createElement(module3, {
		LayoutOrder = 1,
		size = props.buttonSize,
		action = props.heroUnitButtonAction,
		testId = props.actionButtonTestId
	}) else nil
	v13.bottomSlotTrailing = v17
	return createElement(view, v6, {
		Backgrounds = v8,
		ContentColumn = createElement2(view, v10, {
			Header = createElement3(module2, v13)
		})
	})
end

if fFlagAXFixCatalogTileThumbnailFlash then
	return (React.memo(HeroUnitSpotlightCardView))
end

return HeroUnitSpotlightCardView
