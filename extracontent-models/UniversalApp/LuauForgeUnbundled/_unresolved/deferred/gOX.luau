local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Foundation = require(CorePackages.Packages.Foundation)

local module = require("@luauforge/bundled/cgr")
local constants = module.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = module.Utils.getRbxthumbWithTypeSizeAndOptions

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
require("@luauforge/bundled/dMc")

local useTokens = Foundation.Hooks.useTokens
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
require("@luauforge/deferred/gOY")

local module4 = require("@luauforge/bundled/dMx")

local catalogItemCard = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCard
local itemCardThumbnail = require("@luauforge/deferred/gkN").ItemCardComponents.ItemCardThumbnail

local fFlagAXSlotAvatarThumbnailPromptFix = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXSlotAvatarThumbnailPromptFix

local module5 = require("@luauforge/deferred/gPd")

local module6 = require("@luauforge/deferred/gPb")

local fFlagAXEditorEnableThumbnailLatencyStore = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXEditorEnableThumbnailLatencyStore
local fFlagAXOutfitPageRevamp = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXOutfitPageRevamp

local function getAvatarTileOutfitThumbnailUrlFromBuilder(p2, p3)
	return `{getRbxthumbWithTypeSizeAndOptions(p2, constants.RbxthumbTypes.Outfit, 150)}&filters={not fFlagAXSlotAvatarThumbnailPromptFix and 0 or p3}`
end

local function selectDeviceOrientation(p2)
	return p2.DeviceOrientation
end

local function AvatarTile(props, ref)
	local v5 = useTokens()
	local v6 = useSelector(selectDeviceOrientation) == Responsive.Keys.Portrait
	local v7

	if fFlagAXOutfitPageRevamp then
		v7 = useLocalization({ details = "Feature.Avatar.Label.DetailsButton" })
	end

	local v8

	if module5 then
		local itemId = props.itemId
		local outfitUpdateCounter = props.outfitUpdateCounter
		v8 = `{getRbxthumbWithTypeSizeAndOptions(itemId, constants.RbxthumbTypes.Outfit, 150)}&filters={not fFlagAXSlotAvatarThumbnailPromptFix and 0 or outfitUpdateCounter}`
	elseif fFlagAXSlotAvatarThumbnailPromptFix then
		v8 = `rbxthumb://type=Outfit&id={props.itemId}&w={150}&h={150}&filters={props.outfitUpdateCounter}`
	else
		v8 = `rbxthumb://type=Outfit&id={props.itemId}&w={150}&h={150}&filters=0`
	end

	local createElement = React.createElement
	local v10 = {
		onActivated = props.onActivated,
		presentationSlot = 0,
		title = 0,
		titleTextSize = 0,
		isSelected = 0,
		Size = 0,
		AutomaticSize = 0,
		ref = 0,
		headerAspectRatio = 0,
		LayoutOrder = 0,
		tag = 0,
		itemStatus = 0,
		overlayButtonText = 0,
		onOverlayButtonActivated = 0
	}
	local createElement2 = React.createElement
	local frame = RoactGamepad.Focusable.Frame
	local v11 = {
		Size = UDim2.fromScale(1, 1),
		ClipsDescendants = true,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}

	local v12 = {
		CornerRadius = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v5.Radius.Medium)
		}),
		AvatarTileThumbnail = 0
	}

	local createElement3 = React.createElement

	local v15 = if fFlagAXEditorEnableThumbnailLatencyStore then props.onThumbnailLoaded else nil
	v12.AvatarTileThumbnail = createElement3(itemCardThumbnail, {
		url = v8,
		onLoaded = v15
	})
	v10.presentationSlot = createElement2(frame, v11, v12)

	local v16 = if module6 then props.item and props.item.name else props.item.name
	v10.title = v16
	local v17 = if v6 then v5.Typography.BodySmall else nil
	v10.titleTextSize = v17
	v10.isSelected = props.isSelected
	v10.Size = UDim2.fromOffset(props.itemWidth, 0)
	v10.AutomaticSize = Enum.AutomaticSize.Y
	v10.ref = ref
	local v18 = if props.squareAspectRatio then module4.ItemTileSquareAspectRatio else module4.ItemTileTallAspectRatio
	v10.headerAspectRatio = v18

	v10.LayoutOrder = props.index
	v10.tag = props.impressionsTag

	v10.itemStatus = props.itemStatus
	local v19 = if fFlagAXOutfitPageRevamp then v7.details else nil
	v10.overlayButtonText = v19
	local v20 = if fFlagAXOutfitPageRevamp then props.onDetailsButtonActivated else nil
	v10.onOverlayButtonActivated = v20
	return createElement(catalogItemCard, v10)
end

return React.forwardRef(AvatarTile)
