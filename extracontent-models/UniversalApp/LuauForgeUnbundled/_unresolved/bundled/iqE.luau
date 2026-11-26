local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local useStyle = UIBlox.Core.Style.useStyle
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local module = require("@luauforge/bundled/fDy")
local useResponsiveLayout = UIBlox.Core.Layout.Responsive.useResponsiveLayout
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy
local isSubjectToDesktopPolicies = require("@game/CorePackages/Workspace/Packages/SharedFlags").isSubjectToDesktopPolicies
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild
local module2 = require("@luauforge/bundled/cBc")
local modules = require("@luauforge/bundled/dtb").Modules
local omniFeedProps = modules.Personalization.OmniFeed.OmniFeedProps
local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local module3 = require("@luauforge/bundled/ehg")
local module4 = require("@luauforge/bundled/iqF")
local fFlagTestDeviceForFAEUpsell = module4.FFlagTestDeviceForFAEUpsell
local deviceMeetsRequirementsForFAE = module4.deviceMeetsRequirementsForFAE
local usePageSideMargin = module3.usePageSideMargin

local module5 = require("@luauforge/bundled/iqG")
local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor

local upsellBanner = module.UpsellBanner
local createBannerConfigFromUpsellCardVariation = module.Utils.createBannerConfigFromUpsellCardVariation

local postHomePageContactMethodModuleVariationDismiss = modules.LuaApp.Thunks.PostHomePageContactMethodModuleVariationDismiss
local upsellEntrySurfaceType = module.Analytics.Enum.UpsellEntrySurfaceType
local socialUpsellType = module.Enums.SocialUpsellType
local upsellComponent = module.Analytics.Enum.UpsellComponent
local startFacialAgeEstimation = module.Thunks.startFacialAgeEstimation
local useSocialUpsellOverlayController = module.Hooks.useSocialUpsellOverlayController
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagLuaAppCompositionAlways = SharedFlags.FFlagLuaAppCompositionAlways
local fFlagAgeBasedUXHomepageVerificationBannerLockIcon = SharedFlags.FFlagAgeBasedUXHomepageVerificationBannerLockIcon

local fFlagAgeBasedUXHomepageVerificationBannerGreyButton = SharedFlags.FFlagAgeBasedUXHomepageVerificationBannerGreyButton

local GAME_CAROUSEL_SIDE_COMPACT_PADDING = module2.Constants.GAME_CAROUSEL_SIDE_COMPACT_PADDING
local GAME_CAROUSEL_SIDE_WIDE_PADDING = module2.Constants.GAME_CAROUSEL_SIDE_WIDE_PADDING

return function(p2)
	local v5 = fFlagLuaAppCompositionAlways and true or p2[omniFeedProps.key].appCompositionEnabled

	local v6 = useSelector(function(p3)
		return p3.HomePageUpsellCardVariation
	end)

	local v7 = useAppPolicy(function(p3)
		return p3.useGridPageLayout()
	end)

	local ref = React.useRef(nil)

	local upsellCardV2Config = v6 and v6.upsellCardType and v6.upsellCardV2Config
	local v8

	if
		(fFlagAgeBasedUXHomepageVerificationBannerLockIcon or fFlagAgeBasedUXHomepageVerificationBannerGreyButton)
		and upsellCardV2Config
		and v6.upsellCardType == "Fae"
	then
		v8 = { iconOverride = 0, primaryButtonVariantOverride = 0 }

		local v9 = if fFlagAgeBasedUXHomepageVerificationBannerLockIcon then Foundation.Enums.IconName.LockClosed else nil
		v8.iconOverride = v9

		local v10 = if fFlagAgeBasedUXHomepageVerificationBannerGreyButton then Foundation.Enums.ButtonVariant.Standard else nil
		v8.primaryButtonVariantOverride = v10
	end

	local v9 = useDispatch()
	local v10 = useSocialUpsellOverlayController(false)
	local v11 = useRoactService(roactNetworking)
	local v12 = React.useCallback(function(p3)
		if v6 and v6.upsellCardType == "Fae" then
			v9(startFacialAgeEstimation(
				socialUpsellType.FacialAgeEstimation .. upsellEntrySurfaceType.Homepage,
				nil,
				nil,
				upsellEntrySurfaceType.Homepage
			))
		end
	end, { v9, v6 })
	local v13 = React.useCallback(function(p3)
		if v6 and v6.upsellCardType == "Fae" then
			v10.openSocialOverlay(module.Enums.SocialUpsellType.FacialAgeEstimation, {
				upsellEntrySurface = upsellEntrySurfaceType.Homepage,
				upsellEntryComponent = upsellComponent.Banner,
				impressionId = p3
			})
		end
	end, { v6, v10.openSocialOverlay })
	local v14 = React.useCallback(function(p3)
		if v9 and v6 then
			v9(postHomePageContactMethodModuleVariationDismiss(v11, v6.upsellCardType))
		end
	end, { v6, v11 })

	local theme = useStyle().Theme

	local v15 = useSelector(function(p3)
		return p3.FormFactor
	end)

	local v16 = if not fFlagLuaAppCompositionAlways then useResponsiveLayout("margin") else nil

	if v5 then
		v16 = nil
	elseif not v7 then
		if v15 == formFactor.COMPACT then
			v16 = GAME_CAROUSEL_SIDE_COMPACT_PADDING
		else
			v16 = GAME_CAROUSEL_SIDE_WIDE_PADDING
		end
	end

	if not fFlagLuaAppCompositionAlways then
		local v17 = usePageSideMargin(ref.current)

		if upsellCardV2Config then
			v16 = v17
		end
	end

	if fFlagTestDeviceForFAEUpsell and upsellCardV2Config and not deviceMeetsRequirementsForFAE() then
		return nil
	end

	local createElement = Roact.createElement
	local v18 = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundColor3 = theme.BackgroundUIDefault.Color,
		AutomaticSize = Enum.AutomaticSize.Y,
		ref = ref
	}

	local createElement2 = Roact.createElement
	local v22 = if not v5 then UDim.new(0, v16) else nil
	local v23 = if not v5 then UDim.new(0, v16) else nil
	local v19 = {
		UIPadding = createElement2("UIPadding", {
			PaddingLeft = v22,
			PaddingRight = v23,
			PaddingTop = UDim.new(0, 1)
		}),
		HomePageUpsellCard = 0,
		HomePageUpsellBannerV2 = 0
	}

	local v24 = if not upsellCardV2Config then Roact.createElement(module5, {
		upsellCardVariation = v6,
		isCentered = isSubjectToDesktopPolicies() or isVRAppBuild()
	}) else nil
	v19.HomePageUpsellCard = v24

	local v25 = if upsellCardV2Config and v6.upsellCardType ~= "" then Roact.createElement(upsellBanner, {
		config = createBannerConfigFromUpsellCardVariation(v6, v8),
		onPrimaryAction = v12,
		onSecondaryAction = v13,
		onDismiss = v14,
		upsellEntrySurface = upsellEntrySurfaceType.Homepage,
		upsellEntryComponent = upsellComponent.Banner
	}) else nil
	v19.HomePageUpsellBannerV2 = v25
	return createElement("Frame", v18, v19)
end
