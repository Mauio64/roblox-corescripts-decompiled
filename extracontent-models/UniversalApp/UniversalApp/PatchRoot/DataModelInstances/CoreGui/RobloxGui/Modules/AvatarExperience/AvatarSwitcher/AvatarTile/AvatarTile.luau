local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Foundation = require(CorePackages.Packages.Foundation)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local Constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local Responsive = require(CorePackages.Workspace.Packages.Responsive)

require(Modules.AvatarExperience.Common.Types)

local useTokens = Foundation.Hooks.useTokens

require(Modules.AvatarExperience.AvatarSwitcher.AvatarTile.useAvatarTileProps)

local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local CatalogItemCard = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCard
local ItemCardThumbnail = require(CorePackages.Workspace.Packages.AvatarExperienceUIKit).ItemCardComponents.ItemCardThumbnail
local FFlagAXSlotAvatarThumbnailPromptFix = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXSlotAvatarThumbnailPromptFix
local FFlagAXAvatarTileOutfitThumbnailUrlBuilder = require(Modules.AvatarExperience.Flags.FFlagAXAvatarTileOutfitThumbnailUrlBuilder)
local FFlagAXAvatarTileNoDefaultOutfitInfo = require(Modules.AvatarExperience.Flags.FFlagAXAvatarTileNoDefaultOutfitInfo)
local FFlagAXModeratedItemsFlow = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXModeratedItemsFlow
local FFlagAXEnableModeratedItemsFlowForDurables = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXEnableModeratedItemsFlowForDurables

local function getAvatarTileOutfitThumbnailUrlFromBuilder(s1: string, n1: number?) -- line: 42
	-- upvalues: getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy), FFlagAXSlotAvatarThumbnailPromptFix (copy)
	return `{ getRbxthumbWithTypeSizeAndOptions(s1, Constants.RbxthumbTypes.Outfit, 150) }&filters={ not FFlagAXSlotAvatarThumbnailPromptFix and 0 or n1 }`
end
local function selectDeviceOrientation(p1) -- line: 63
	return p1.DeviceOrientation
end
local function AvatarTile(p2, p3) -- line: 67
	-- upvalues: useTokens (copy), useSelector (copy), selectDeviceOrientation (copy), Responsive (copy), FFlagAXAvatarTileOutfitThumbnailUrlBuilder (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy), FFlagAXSlotAvatarThumbnailPromptFix (copy), React (copy), CatalogItemCard (copy), RoactGamepad (copy), FFlagRenameDeprecatedUIBloxTokens (copy), ItemCardThumbnail (copy), FFlagAXAvatarTileNoDefaultOutfitInfo (copy), Constants2 (copy), FFlagAXModeratedItemsFlow (copy), FFlagAXEnableModeratedItemsFlowForDurables (copy)
	local v30 = useTokens()
	local v31 = useSelector(selectDeviceOrientation) == Responsive.Keys.Portrait
	local v34

	if FFlagAXAvatarTileOutfitThumbnailUrlBuilder then
		local itemId = p2.itemId
		local outfitUpdateCounter = p2.outfitUpdateCounter

		v34 = `{ getRbxthumbWithTypeSizeAndOptions(itemId, Constants.RbxthumbTypes.Outfit, 150) }&filters={ not FFlagAXSlotAvatarThumbnailPromptFix and 0 or outfitUpdateCounter }`
	else
		v34 = if not FFlagAXSlotAvatarThumbnailPromptFix then `rbxthumb://type=Outfit&id={ p2.itemId }&w={ 150 }&h={ 150 }&filters=0` else `rbxthumb://type=Outfit&id={ p2.itemId }&w={ 150 }&h={ 150 }&filters={ p2.outfitUpdateCounter }`
	end

	return React.createElement(CatalogItemCard, {
		onActivated = p2.onActivated,
		presentationSlot = React.createElement(RoactGamepad.Focusable.Frame, {
			ClipsDescendants = true,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1)
		}, {
			CornerRadius = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v30.Semantic.Radius.Medium else v30.Radius.Medium)
			}),
			AvatarTileThumbnail = React.createElement(ItemCardThumbnail, {
				url = v34
			})
		}),
		title = if not FFlagAXAvatarTileNoDefaultOutfitInfo then p2.item.name else p2.item and p2.item.name,
		titleTextSize = if not v31 then nil else v30.Typography.BodySmall,
		isSelected = p2.isSelected,
		Size = UDim2.fromOffset(p2.itemWidth, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ref = p3,
		headerAspectRatio = if not p2.squareAspectRatio then Constants2.ItemTileTallAspectRatio else Constants2.ItemTileSquareAspectRatio,
		LayoutOrder = p2.index,
		tag = p2.impressionsTag,
		itemStatus = if not FFlagAXModeratedItemsFlow and not FFlagAXEnableModeratedItemsFlowForDurables then nil else p2.itemStatus
	})
end

return React.forwardRef(AvatarTile)
