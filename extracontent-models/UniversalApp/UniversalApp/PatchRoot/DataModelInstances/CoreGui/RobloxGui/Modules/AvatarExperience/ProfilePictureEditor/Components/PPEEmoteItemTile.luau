local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local useTableWrappedCallbackRef = AvatarExperienceCommon.Utils.RoactGamepadMigration.useTableWrappedCallbackRef
local CatalogItemCard = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCard
local ItemCardThumbnail = require(CorePackages.Workspace.Packages.AvatarExperienceUIKit).ItemCardComponents.ItemCardThumbnail
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)

require(Modules.AvatarExperience.Common.AvatarExperienceState)
require(CorePackages.Packages.Foundation)

local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local SetEmoteAssetId = require(Modules.AvatarExperience.ProfilePictureEditor.Thunks.SetEmoteAssetId)
local logOnOverlayClosed = AvatarExperienceNavigation.Debug.logOnOverlayClosed
local NavigateWithLock = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Thunks.NavigateWithLock
local OpenItemDetails = require(Modules.AvatarExperience.Common.Thunks.OpenItemDetails)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local wasLastInputGamepad = require(CorePackages.Workspace.Packages.RoactUtils).wasLastInputGamepad
local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local Constants2 = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local usePPEEmoteItemTileBindings = require(Modules.AvatarExperience.ProfilePictureEditor.Components.usePPEEmoteItemTileBindings)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useAdaptiveScrolling = AvatarExperienceCommon.Hooks.useAdaptiveScrolling
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService

function shouldProvideControlsToViewItemDetails(t1: {[any]: any}) -- line: 70
	if not t1.itemId then
		return false
	end

	if not t1.isSelected then
		return false
	end

	return true
end

local function PPEEmoteItemTile(t2: {[any]: any}) -- line: 86
	-- upvalues: useAdaptiveScrolling (copy), Roact (copy), useDispatch (copy), useFocusGuiObject (copy), useNavigation (copy), useAvatarRoute (copy), useRoactService (copy), Analytics (copy), wasLastInputGamepad (copy), useLocalization (copy), React (copy), CatalogUtils (copy), Constants (copy), OpenItemDetails (copy), AvatarScreen (copy), logOnOverlayClosed (copy), usePPEEmoteItemTileBindings (copy), useTableWrappedCallbackRef (copy), CatalogItemCard (copy), ItemCardThumbnail (copy)
	local v39 = useAdaptiveScrolling()
	local v40 = Roact.createRef()
	local v41 = useDispatch()
	local v42 = useFocusGuiObject()
	local v43 = useNavigation()
	local v44 = useAvatarRoute()
	local v45 = useRoactService(Analytics)
	local v46 = wasLastInputGamepad()
	local v47 = useLocalization({
		details = "Feature.Avatar.Label.DetailsButton"
	})
	local v48 = React.useCallback(function() -- line: 100
		-- upvalues: CatalogUtils (copy), t2 (copy), Constants (copy), v45 (copy), v44 (copy), v43 (copy), v41 (copy), OpenItemDetails (copy)
		local v62 = CatalogUtils.GetItemSubType(t2.itemType, t2.itemData)
		local v63 = if not t2.itemData then nil else t2.itemData.priceInRobux
		local t3 = {
			mountAsFullView = true,
			closePreviousItemDetails = true,
			itemId = not t2.itemId and "" or t2.itemId,
			itemType = Constants.ItemType.Asset,
			itemSubType = v62,
			priceInRobux = v63,
			catalogAnalytics = v45,
			avatarRoute = v44,
			navigation = v43,
			itemDetailsPeekViewRefs = t2.itemDetailsPeekViewRefs,
			resultsListRef = t2.resultsListRef
		}

		v41(OpenItemDetails(t3))
	end, {
		t2.itemType,
		t2.itemData,
		t2.itemId,
		t2.itemDetailsPeekViewRefs,
		t2.resultsListRef,
		v43,
		v44,
		v45,
		v41
	})
	local v49 = React.useCallback(function(b1: boolean?) -- line: 131
		-- upvalues: v39 (copy), v40 (copy)
		if not v39 then
			return
		end

		if b1 then
			v39.setSelectedItemInstance(nil)

			return
		end

		if v40.current then
			v39.setSelectedItemInstance(v40.current)
		end
	end, { v40.current })
	local v50 = React.useCallback(function() -- line: 143
		-- upvalues: t2 (copy), v43 (copy), v49 (copy), Constants (copy), AvatarScreen (copy), logOnOverlayClosed (copy), v46 (copy), v42 (copy), v40 (copy)
		if t2.itemId == t2.emoteAssetId then
			t2.setEmoteAssetId(nil, v43)
			v49(true)

			return
		end

		if t2.avatarType == Constants.AvatarType.R6 then
			v43.navigate(AvatarScreen.R15UpgradePrompt, {
				bodyTextKey = "Feature.Avatar.Label.PPEEmoteR15Warning",
				onSwitchSelected = function() -- line: 153
					-- upvalues: t2 (copy), v43 (copy), v49 (copy)
					t2.setEmoteAssetId(t2.itemId, v43)
					v49(false)
				end,
				onOverlayClosed = function() -- line: 157
					-- upvalues: logOnOverlayClosed (copy), v46 (copy), v42 (copy), v40 (copy)
					logOnOverlayClosed("EmotesScrollView", v46)

					if v46 then
						v42(v40.current)
					end
				end
			})

			return
		end

		t2.setEmoteAssetId(t2.itemId, v43)
		v49(false)
	end, {
		t2.itemId,
		t2.emoteAssetId,
		t2.setEmoteAssetId,
		t2.avatarType,
		v43,
		v49,
		v46,
		v42
	})
	local v51 = usePPEEmoteItemTileBindings({
		onSelectItem = v50,
		onOpenItemDetailsPage = if not shouldProvideControlsToViewItemDetails(t2) then nil else v48
	})
	local v52 = useTableWrappedCallbackRef(v51)

	return React.createElement(CatalogItemCard, {
		ref = v52,
		onActivated = v50,
		isSelected = t2.isSelected,
		onOverlayButtonActivated = v48,
		overlayButtonText = v47.details,
		presentationSlot = if not t2.thumbnail then nil else React.createElement(ItemCardThumbnail, {
			url = t2.thumbnail
		}),
		title = t2.name,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	})
end
local function mapStateToProps(p1, p2) -- line: 206
	-- upvalues: ItemData (copy), Constants (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants2 (copy)
	local emoteAssetId = p1.AvatarExperience.ProfilePictureEditor.ProfilePictureParams.emoteAssetId
	local AvatarType = p1.AvatarExperience.AvatarEditor.Character.AvatarType
	local itemId = p2.itemId
	local v58 = nil
	local v59 = nil
	local v60 = nil

	if itemId then
		v58 = ItemData(p1.AvatarExperience.Common, itemId, Constants.ItemType.Asset)
		v59 = v58 and v58.name or nil
		v60 = getRbxthumbWithTypeSizeAndOptions(itemId, Constants2.RbxthumbTypes.Asset, 150)
	end

	return {
		itemData = v58,
		emoteAssetId = emoteAssetId,
		name = v59,
		thumbnail = v60,
		avatarType = AvatarType
	}
end
local function mapDispatchToProps(p3) -- line: 229
	-- upvalues: SetEmoteAssetId (copy), NavigateWithLock (copy)
	return {
		setEmoteAssetId = function(p4, p5) -- line: 231
			-- upvalues: p3 (copy), SetEmoteAssetId (copy)
			return p3(SetEmoteAssetId(p4, p5))
		end,
		navigateWithLock = function(p6) -- line: 234
			-- upvalues: p3 (copy), NavigateWithLock (copy)
			p3(NavigateWithLock(p6))
		end
	}
end

return (RoactRodux.connect(mapStateToProps, mapDispatchToProps)(PPEEmoteItemTile))
