local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local module2 = require("@luauforge/bundled/eie")
local module3 = require("@luauforge/deferred/fCa")

local module4 = require("@luauforge/deferred/fCc")
local module5 = require("@luauforge/deferred/fCU")
local module6 = require("@luauforge/deferred/fCY")
local module7 = require("@luauforge/bundled/fCe")
require("@luauforge/bundled/dKT")

local module8 = require("@luauforge/bundled/fDf")
local module9 = require("@luauforge/deferred/fDS")
local module10 = require("@luauforge/bundled/egx")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local navigateWithLock = AvatarExperienceNavigation.Thunks.NavigateWithLock
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local fFlagEditProfileImageR15UpgradePrompt = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEditProfileImageR15UpgradePrompt
local fFlagNavigationCallbackParam = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagNavigationCallbackParam

local function runNavigationCallback(p2)
	return require("@luauforge/bundled/fHW").run(p2)
end

local module12 = require("@luauforge/deferred/fCZ")
local editProfileImageScreen = module12.EditProfileImageScreen
local textKeys = module12.TextKeys
local module13 = require("@luauforge/bundled/fJr")

local function selectExternalNavigationRequest(p2)
	return p2.AvatarExperience.ExternalNavigationRequest
end

local recommendedEmotePurchaseFooter = nil

local function selectAvatarType(p2)
	if p2.AvatarExperience.AvatarEditor.HasAvatarData then
		return p2.AvatarExperience.AvatarEditor.Character.AvatarType
	end

	return nil
end

local function getRecommendedEmotePurchaseFooter()
	if recommendedEmotePurchaseFooter == nil then
		recommendedEmotePurchaseFooter = require("@luauforge/deferred/fDa")
	end

	return recommendedEmotePurchaseFooter
end

local function EditProfileImagePage(p2)
	local v5 = useDispatch()
	local v6 = useSelector(selectExternalNavigationRequest)
	local v7 = module2(module10)
	local v8 = module2(module8)
	local v9 = module2(module9)
	local v10 = useAvatarRoute()

	local params = v6.params
	local initialFrameAssetId

	if module13 and v6.screen == avatarScreen.EditProfileImage and params ~= nil then
		initialFrameAssetId = params.initialFrameAssetId
	end

	local requestId = if initialFrameAssetId ~= nil then v6.requestId else nil
	local v11

	if fFlagEditProfileImageR15UpgradePrompt then
		v11 = useLocalization({
			title = textKeys.SwitchToR15,
			body = textKeys.PPEEmoteR15Warning,
			confirm = textKeys.Switch,
			cancel = textKeys.Cancel
		})
	else
		v11 = nil
	end

	local v12 = React.useCallback(function(p3)
		v5(module3(p2.navigation, {
			itemId = p3,
			itemType = "Asset",
			mountAsFullView = true,
			isFirstItemDetails = true,
			itemDetailsPeekViewRefs = {}
		}))
	end, { v5, p2.navigation })

	local v13 = React.useCallback(function(p3)
		v5(module4(v7, v8, p2.navigation, v10, p3, nil, nil, false))
	end, { v5, v7, v8, p2.navigation, v10 })

	local v14 = React.useCallback(function()
		v5(module5(p2.navigation, v8, v9))
	end, { v5, p2.navigation, v8, v9 })
	local v15, v16

	if fFlagEditProfileImageR15UpgradePrompt then
		v15 = React.useCallback(function(p3)
			v5(module6(v11, p3))
		end, { v5, v11 })

		local v17 = useSelector(selectAvatarType)
		v16 = module7.resolveHumanoidRigType(v17)
	end

	local v17 = React.useCallback(function(p3)
		v5(navigateWithLock(function()
			p2.navigation.navigate(avatarScreen.CatalogContextMenu, {
				itemId = p3,
				itemType = "Asset"
			})
		end))
	end, { v5, p2.navigation })

	local v18 = React.useCallback(function(p3)
		local createElement = React.createElement

		if recommendedEmotePurchaseFooter == nil then
			recommendedEmotePurchaseFooter = require("@luauforge/deferred/fDa")
		end

		return createElement(recommendedEmotePurchaseFooter, {
			emoteAssetId = p3,
			avatarRoute = v10,
			onOpenCatalogContextMenu = function()
				v17(p3)
			end
		})
	end, { v10, v17 })

	return React.createElement(editProfileImageScreen, {
		navigation = p2.navigation,
		initialFrameAssetId = initialFrameAssetId,
		initialFrameSelectionRequestId = requestId,
		onOpenEmoteDetails = v12,
		onPrepareRecommendedEmotePurchase = v13,
		onShopForMoreEmotes = v14,
		onPromptR15Upgrade = v15,
		accountRigType = v16,
		renderRecommendedEmotePurchaseFooter = v18,
		onReturn = if fFlagNavigationCallbackParam then runNavigationCallback else nil
	})
end

return EditProfileImagePage
