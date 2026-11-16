local CorePackages = game:GetService("CorePackages")
local Http = require(CorePackages.Workspace.Packages.Http)
local FetchingStatus = Http.Reducers.FetchingStatus
local parent = script.Parent
local Rodux = require(CorePackages.Packages.Rodux)
local View = require(parent.View)
local PlayerId = require(parent.PlayerId)
local PlayerName = require(parent.PlayerName)
local Assets = require(parent.Assets)
local AssetBundles = require(parent.AssetBundles)
local Bundles = require(parent.Bundles)
local EquippedAssets = require(parent.EquippedAssets)
local DetailsInformation = require(parent.DetailsInformation)
local TryingOnInfo = require(parent.TryingOnInfo)
local Favorites = require(parent.Favorites)
local Locale = require(parent.Locale)
local Visible = require(parent.Visible)
local ItemBeingPurchased = require(parent.ItemBeingPurchased)
local IsLoaded = require(parent.IsLoaded)
local IsSubjectToChinaPolicies = require(parent.IsSubjectToChinaPolicies)
local GamepadEnabled = require(parent.GamepadEnabled)
local StoreId = require(parent.StoreId)
local CollectibleResellableInstances = require(parent.CollectibleResellableInstances)
local CreatingExperiences = require(parent.CreatingExperiences)
local Overlay = require(parent.Overlay)
local parent2 = script.Parent.Parent
local FFlagAXEnableFetchAvatarPreview = require(parent2.Flags.FFlagAXEnableFetchAvatarPreview)
local AvatarPreviewDetails = require(parent.AvatarPreviewDetails)

local combineReducers = Rodux.combineReducers

if not FFlagAXEnableFetchAvatarPreview then
	AvatarPreviewDetails = nil
end

return combineReducers({
	view = View,
	playerId = PlayerId,
	playerName = PlayerName,
	assets = Assets,
	avatarPreviewDetails = AvatarPreviewDetails,
	bundles = Bundles,
	assetBundles = AssetBundles,
	equippedAssets = EquippedAssets,
	detailsInformation = DetailsInformation,
	tryingOnInfo = TryingOnInfo,
	favorites = Favorites,
	locale = Locale,
	visible = Visible,
	itemBeingPurchased = ItemBeingPurchased,
	gamepadEnabled = GamepadEnabled,
	isLoaded = IsLoaded,
	isSubjectToChinaPolicies = IsSubjectToChinaPolicies,
	FetchingStatus = FetchingStatus,
	storeId = StoreId,
	collectibleResellableInstances = CollectibleResellableInstances,
	creatingExperiences = CreatingExperiences,
	overlay = Overlay
})
