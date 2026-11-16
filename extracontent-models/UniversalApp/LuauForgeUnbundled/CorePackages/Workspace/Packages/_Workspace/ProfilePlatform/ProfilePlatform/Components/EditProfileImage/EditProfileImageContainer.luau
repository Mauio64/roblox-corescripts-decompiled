local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils")
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/NavigationRodux")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppEnums")
local AvatarExperienceProfilePictureEditor = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/AvatarExperienceProfilePictureEditor")
local editProfileImage = AvatarExperienceProfilePictureEditor.EditProfileImage
local enums = AvatarExperienceProfilePictureEditor.Enums
local closeProfilePictureEditor = AvatarExperienceProfilePictureEditor.closeProfilePictureEditor
local showEditProfileImageToast = AvatarExperienceProfilePictureEditor.showEditProfileImageToast
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks")
local fFlagEditProfileImageR15UpgradePrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagEditProfileImageR15UpgradePrompt
local fFlagEditProfileFramesEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagEditProfileFramesEnabled
local fFlagEditProfileFramesImpression = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/EditProfile").Flags.FFlagEditProfileFramesImpression
local fFlagSignalsNavP3hMisc = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagSignalsNavP3hMisc
local fFlagSplitPaneProfileEditFillPane = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagSplitPaneProfileEditFillPane
local v5 = if fFlagSplitPaneProfileEditFillPane then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SplitPane") else nil

local useReportFramesImpression = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useReportFramesImpression")

local view = Foundation.View
local useScreenSize = RobloxAppHooks.useScreenSize
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SignalsReact").useSignalState
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Signals")
local selectors = NavigationRodux.Selectors
local getLegacyNavigationStore = NavigationRodux.GetLegacyNavigationStore
local appPage = RobloxAppEnums.AppPage

local defineFastFlag = game:DefineFastFlag("AXEditProfileImageFillCardHeight", false)

local function isAppItemDetailsPage(p2): boolean
	return p2 == appPage.AvatarExperienceWrapper or p2 == appPage.AvatarExperienceWrapperTransparent
end

local function EditProfileImageContainer(p2)
	local v6 = useProfileWrapperContext()
	local renderRecommendedEmotePurchaseFooter = v6.renderRecommendedEmotePurchaseFooter
	assert(
		renderRecommendedEmotePurchaseFooter,
		"Edit Profile Image requires a host purchase-footer renderer"
	)
	local v7 = useScreenSize()
	local v8 = useSelector(function(p3)
		return p3.GlobalGuiInset
	end)
	local v9

	if fFlagSignalsNavP3hMisc then
		v9 = useSignalState((React.useMemo(function()
			return Signals.createComputed(function(p3): boolean
				local currentPageName = getLegacyNavigationStore(false).getCurrentPageName(p3)
				return currentPageName == appPage.AvatarExperienceWrapper
					or currentPageName == appPage.AvatarExperienceWrapperTransparent
			end)
		end, {})))
	else
		local v10 = useSelector(selectors.selectCurrentPageName)
		v9 = v10 == appPage.AvatarExperienceWrapper or v10 == appPage.AvatarExperienceWrapperTransparent
	end

	local v10 = useDispatch()
	local v11 = math.max(0, v7.X - v8.left - v8.right)

	local vector2 = nil
	local v12

	if fFlagSplitPaneProfileEditFillPane then
		local store = v5.SplitPaneStore.getStore()
		local v13 = useSignalState(store.getSupportPaneModeIfActive)
		local v14 = useSignalState(store.getSupportWidthFraction)
		v12 = not (v13 == nil) and v5.SplitPaneVariant.getProfileSplitPaneEligibility(v13) ~= nil

		if v12 then
			local v15 = if v13 == v5.SupportPaneMode.Expanded then v11 else v7.X * v14
			vector2 = Vector2.new(v15, v7.Y)
		end
	else
		v12 = false
	end

	local v13 = React.useCallback(function()
		closeProfilePictureEditor(p2.navigation)
	end, { p2.navigation })

	local v14 = React.useCallback(function()
		showEditProfileImageToast.showSaveSuccessToast(v10)
		closeProfilePictureEditor(p2.navigation)
	end, { v10, p2.navigation })

	local v15 = React.useCallback(function(p3)
		local navigateTo = v6.navigateTo

		local v16 = { mountAnimation = true }

		if navigateTo.itemOrBundleDetails then
			navigateTo.itemOrBundleDetails(p3, Enums.ItemTypes.Asset, v16)
		else
			navigateTo.itemDetails(p3, v16)
		end
	end, { v6.navigateTo })

	local v16 = React.useCallback(function(p3)
		local preparePurchaseItem = v6.navigateTo.preparePurchaseItem

		if preparePurchaseItem then
			preparePurchaseItem(p3, Enums.ItemTypes.Asset)
		end
	end, { v6.navigateTo })

	local v17 = React.useCallback(function()
		local shopForMoreEmotes = v6.navigateTo.shopForMoreEmotes

		if shopForMoreEmotes then
			shopForMoreEmotes()
		end
	end, { v6.navigateTo })
	local v18

	if fFlagEditProfileImageR15UpgradePrompt then
		v18 = React.useCallback(function(p3)
			local promptR15Upgrade = v6.navigateTo.promptR15Upgrade

			if promptR15Upgrade then
				promptR15Upgrade(p3)
			end
		end, { v6.navigateTo })
	end

	if fFlagEditProfileFramesImpression and fFlagEditProfileFramesEnabled then
		useReportFramesImpression()
	end

	local v19

	if p2.navigation.getParam then
		v19 = p2.navigation.getParam("mode", enums.EditProfileImageMode.Default)
	else
		v19 = enums.EditProfileImageMode.Default
	end

	local createElement = React.createElement
	local udim

	if fFlagSplitPaneProfileEditFillPane and v12 then
		udim = UDim2.fromScale(1, 1)
	else
		udim = if defineFastFlag then UDim2.new(0, v11, 1, 0) else UDim2.fromOffset(v11, v7.Y)
	end

	local v21 = {
		Size = udim,
		padding = { bottom = UDim.new(0, v8.bottom) },
		tag = "bg-surface-0"
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement

	local v28 = if fFlagEditProfileImageR15UpgradePrompt then v6.accountRigType else nil

	if not (fFlagSplitPaneProfileEditFillPane and v12) then
		vector2 = nil
	end

	local v22 = {
		Content = createElement2(view, { tag = "size-full-full" }, {
			EditProfileImage = createElement3(editProfileImage, {
				mode = v19,
				onClose = v13,
				onSaveSuccess = v14,
				onOpenEmoteDetails = v15,
				onPrepareRecommendedEmotePurchase = v16,
				onShopForMoreEmotes = v17,
				onPromptR15Upgrade = v18,
				accountRigType = v28,
				renderRecommendedEmotePurchaseFooter = renderRecommendedEmotePurchaseFooter,
				containerSize = vector2
			})
		}),
		DetailsInputBlocker = 0
	}

	local v29 = if v9 then React.createElement(view, {
		tag = "position-top-left size-full",
		ZIndex = 10,
		Active = true
	}) else nil
	v22.DetailsInputBlocker = v29
	return createElement(view, v21, v22)
end

return EditProfileImageContainer
