local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local RoactUtils = require(parent.RoactUtils)
local NavigationRodux = require(parent.NavigationRodux)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AvatarExperienceProfilePictureEditor = require(parent.AvatarExperienceProfilePictureEditor)
local EditProfileImage = AvatarExperienceProfilePictureEditor.EditProfileImage
local Enums = AvatarExperienceProfilePictureEditor.Enums
local closeProfilePictureEditor = AvatarExperienceProfilePictureEditor.closeProfilePictureEditor
local showEditProfileImageToast = AvatarExperienceProfilePictureEditor.showEditProfileImageToast
local Enums2 = require(ProfilePlatform.Common.Enums)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local SharedFlags = require(parent.SharedFlags)
local FFlagEditProfileImageR15UpgradePrompt = SharedFlags.FFlagEditProfileImageR15UpgradePrompt
local SharedFlags2 = require(parent.SharedFlags)
local FFlagEditProfileFramesEnabled = SharedFlags2.FFlagEditProfileFramesEnabled
local EditProfile = require(parent.EditProfile)
local FFlagEditProfileFramesImpression = EditProfile.Flags.FFlagEditProfileFramesImpression
local SharedFlags3 = require(parent.SharedFlags)
local FFlagSignalsNavP3hMisc = SharedFlags3.FFlagSignalsNavP3hMisc
local SharedFlags4 = require(parent.SharedFlags)
local FFlagSplitPaneProfileEditFillPane = SharedFlags4.FFlagSplitPaneProfileEditFillPane
local SplitPane

if FFlagSplitPaneProfileEditFillPane then
	SplitPane = require(parent.SplitPane)
else
	SplitPane = nil
end

local useReportFramesImpression = require(ProfilePlatform.Hooks.useReportFramesImpression)

local View = Foundation.View
local useScreenSize = RobloxAppHooks.useScreenSize
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local Signals = require(parent.Signals)
local Selectors = NavigationRodux.Selectors
local GetLegacyNavigationStore = NavigationRodux.GetLegacyNavigationStore
local AppPage = RobloxAppEnums.AppPage

local defineFastFlag = game:DefineFastFlag("AXEditProfileImageFillCardHeight", false)

local function isAppItemDetailsPage(p: string): boolean -- 2 equivalent calls inferred from this helper
	return p == AppPage.AvatarExperienceWrapper or p == AppPage.AvatarExperienceWrapperTransparent
end

local function EditProfileImageContainer(p)
	local v = useProfileWrapperContext()
	local renderRecommendedEmotePurchaseFooter = v.renderRecommendedEmotePurchaseFooter
	assert(renderRecommendedEmotePurchaseFooter, "Edit Profile Image requires a host purchase-footer renderer")
	local v2 = useScreenSize()
	local v3 = useSelector(function(p2)
		return p2.GlobalGuiInset
	end)
	local v4

	if FFlagSignalsNavP3hMisc then
		v4 = useSignalState((React.useMemo(function()
			return Signals.createComputed(function(p2)
				return isAppItemDetailsPage(GetLegacyNavigationStore(false).getCurrentPageName(p2)) -- inferred equivalent call
			end)
		end, {})))
	else
		v4 = isAppItemDetailsPage(useSelector(Selectors.selectCurrentPageName)) -- inferred equivalent call
	end

	local v5 = useDispatch()
	local v6 = math.max(0, v2.X - v3.left - v3.right)

	local vector2 = nil
	local v7

	if FFlagSplitPaneProfileEditFillPane then
		local store = SplitPane.SplitPaneStore.getStore()
		local v8 = useSignalState(store.getSupportPaneModeIfActive)
		local v9 = useSignalState(store.getSupportWidthFraction)

		if v8 == nil then
			v7 = false
		else
			v7 = SplitPane.SplitPaneVariant.getProfileSplitPaneEligibility(v8) ~= nil
		end

		if v7 then
			local v10

			if v8 == SplitPane.SupportPaneMode.Expanded then
				v10 = v6
			else
				v10 = v2.X * v9
			end

			vector2 = Vector2.new(v10, v2.Y)
		end
	else
		v7 = false
	end

	local onClose = React.useCallback(function()
		closeProfilePictureEditor(p.navigation)
	end, { p.navigation })

	local onSaveSuccess = React.useCallback(function()
		showEditProfileImageToast.showSaveSuccessToast(v5)
		closeProfilePictureEditor(p.navigation)
	end, { v5, p.navigation })

	local onOpenEmoteDetails = React.useCallback(function(p2: string)
		local navigateTo = v.navigateTo

		local v8 = { mountAnimation = true }

		if navigateTo.itemOrBundleDetails then
			navigateTo.itemOrBundleDetails(p2, Enums2.ItemTypes.Asset, v8)
		else
			navigateTo.itemDetails(p2, v8)
		end
	end, { v.navigateTo })

	local onPrepareRecommendedEmotePurchase = React.useCallback(function(p2: string)
		local preparePurchaseItem = v.navigateTo.preparePurchaseItem

		if preparePurchaseItem then
			preparePurchaseItem(p2, Enums2.ItemTypes.Asset)
		end
	end, { v.navigateTo })

	local onShopForMoreEmotes = React.useCallback(function()
		local shopForMoreEmotes = v.navigateTo.shopForMoreEmotes

		if shopForMoreEmotes then
			shopForMoreEmotes()
		end
	end, { v.navigateTo })
	local onPromptR15Upgrade

	if FFlagEditProfileImageR15UpgradePrompt then
		onPromptR15Upgrade = React.useCallback(function(callback)
			local promptR15Upgrade = v.navigateTo.promptR15Upgrade

			if promptR15Upgrade then
				promptR15Upgrade(callback)
			end
		end, { v.navigateTo })
	end

	if FFlagEditProfileFramesImpression and FFlagEditProfileFramesEnabled then
		useReportFramesImpression()
	end

	local mode

	if p.navigation.getParam then
		mode = p.navigation.getParam("mode", Enums.EditProfileImageMode.Default)
	else
		mode = Enums.EditProfileImageMode.Default
	end

	local createElement = React.createElement
	local udim

	if FFlagSplitPaneProfileEditFillPane and v7 then
		udim = UDim2.fromScale(1, 1)
	elseif defineFastFlag then
		udim = UDim2.new(0, v6, 1, 0)
	else
		udim = UDim2.fromOffset(v6, v2.Y)
	end

	local v8 = {
		Size = udim,
		padding = { bottom = UDim.new(0, v3.bottom) },
		tag = "bg-surface-0"
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local accountRigType

	if FFlagEditProfileImageR15UpgradePrompt then
		accountRigType = v.accountRigType
	end

	if not (FFlagSplitPaneProfileEditFillPane and v7) then
		vector2 = nil
	end

	local v9 = {
		Content = createElement2(View, { tag = "size-full-full" }, {
			EditProfileImage = createElement3(EditProfileImage, {
				mode = mode,
				onClose = onClose,
				onSaveSuccess = onSaveSuccess,
				onOpenEmoteDetails = onOpenEmoteDetails,
				onPrepareRecommendedEmotePurchase = onPrepareRecommendedEmotePurchase,
				onShopForMoreEmotes = onShopForMoreEmotes,
				onPromptR15Upgrade = onPromptR15Upgrade,
				accountRigType = accountRigType,
				renderRecommendedEmotePurchaseFooter = renderRecommendedEmotePurchaseFooter,
				containerSize = vector2
			})
		}),
		DetailsInputBlocker = 0
	}
	local detailsInputBlocker

	if v4 then
		detailsInputBlocker = React.createElement(View, {
			tag = "position-top-left size-full",
			ZIndex = 10,
			Active = true
		})
	end

	v9.DetailsInputBlocker = detailsInputBlocker
	return createElement(View, v8, v9)
end

return EditProfileImageContainer
