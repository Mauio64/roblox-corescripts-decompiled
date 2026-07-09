local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Packages = CorePackages.Workspace.Packages
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local useStyle = UIBlox.Core.Style.useStyle
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local SocialUpsell = require(CorePackages.Workspace.Packages.SocialUpsell)
local useResponsiveLayout = UIBlox.Core.Layout.Responsive.useResponsiveLayout
local useAppPolicy = require(Packages.UniversalAppPolicy).useAppPolicy
local isSubjectToDesktopPolicies = require(CorePackages.Workspace.Packages.SharedFlags).isSubjectToDesktopPolicies
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local DiscoveryTypes = require(CorePackages.Workspace.Packages.DiscoveryTypes)
local Modules2 = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules
local OmniFeedProps = Modules2.Personalization.OmniFeed.OmniFeedProps
local RoactNetworking = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactNetworking
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local CollectionViews = require(CorePackages.Workspace.Packages.CollectionViews)
local SocialExperiments = require(CorePackages.Workspace.Packages.SocialExperiments)
local FFlagTestDeviceForFAEUpsell = SocialExperiments.FFlagTestDeviceForFAEUpsell
local deviceMeetsRequirementsForFAE = SocialExperiments.deviceMeetsRequirementsForFAE
local usePageSideMargin = CollectionViews.usePageSideMargin
local HomePageUpsellCardWithIcon = require(Modules.LuaApp.Components.Home.HomePageUpsellCardWithIcon)
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local UpsellBanner = SocialUpsell.UpsellBanner
local createBannerConfigFromUpsellCardVariation = SocialUpsell.Utils.createBannerConfigFromUpsellCardVariation
local PostHomePageContactMethodModuleVariationDismiss = Modules2.LuaApp.Thunks.PostHomePageContactMethodModuleVariationDismiss
local UpsellEntrySurfaceType = SocialUpsell.Analytics.Enum.UpsellEntrySurfaceType
local SocialUpsellType = SocialUpsell.Enums.SocialUpsellType
local UpsellComponent = SocialUpsell.Analytics.Enum.UpsellComponent
local startFacialAgeEstimation = SocialUpsell.Thunks.startFacialAgeEstimation
local useSocialUpsellOverlayController = SocialUpsell.Hooks.useSocialUpsellOverlayController
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagLuaAppCompositionAlways = SharedFlags.FFlagLuaAppCompositionAlways
local FFlagAgeBasedUXHomepageVerificationBannerLockIcon = SharedFlags.FFlagAgeBasedUXHomepageVerificationBannerLockIcon
local FFlagAgeBasedUXHomepageVerificationBannerGreyButton = SharedFlags.FFlagAgeBasedUXHomepageVerificationBannerGreyButton
local GAME_CAROUSEL_SIDE_COMPACT_PADDING = DiscoveryTypes.Constants.GAME_CAROUSEL_SIDE_COMPACT_PADDING
local GAME_CAROUSEL_SIDE_WIDE_PADDING = DiscoveryTypes.Constants.GAME_CAROUSEL_SIDE_WIDE_PADDING

return function(t1: {[any]: any}) -- line: 52
	-- upvalues: FFlagLuaAppCompositionAlways (copy), OmniFeedProps (copy), useSelector (copy), useAppPolicy (copy), React (copy), FFlagAgeBasedUXHomepageVerificationBannerLockIcon (copy), FFlagAgeBasedUXHomepageVerificationBannerGreyButton (copy), Foundation (copy), useDispatch (copy), useSocialUpsellOverlayController (copy), useRoactService (copy), RoactNetworking (copy), startFacialAgeEstimation (copy), SocialUpsellType (copy), UpsellEntrySurfaceType (copy), SocialUpsell (copy), UpsellComponent (copy), PostHomePageContactMethodModuleVariationDismiss (copy), useStyle (copy), useResponsiveLayout (copy), FormFactor (copy), GAME_CAROUSEL_SIDE_COMPACT_PADDING (copy), GAME_CAROUSEL_SIDE_WIDE_PADDING (copy), usePageSideMargin (copy), FFlagTestDeviceForFAEUpsell (copy), deviceMeetsRequirementsForFAE (copy), Roact (copy), HomePageUpsellCardWithIcon (copy), isSubjectToDesktopPolicies (copy), IsVRAppBuild (copy), UpsellBanner (copy), createBannerConfigFromUpsellCardVariation (copy)
	local v43 = not not FFlagLuaAppCompositionAlways or t1[OmniFeedProps.key].appCompositionEnabled
	local v44 = useSelector(function(p1) -- line: 57
		return p1.HomePageUpsellCardVariation
	end)
	local v45 = useAppPolicy(function(p2) -- line: 60
		return p2.useGridPageLayout()
	end)
	local v46 = React.useRef(nil)
	local v47 = v44 and (v44.upsellCardType and v44.upsellCardV2Config)
	local v48 = if not ((FFlagAgeBasedUXHomepageVerificationBannerLockIcon or FFlagAgeBasedUXHomepageVerificationBannerGreyButton) and (v47 and v44.upsellCardType == "Fae")) then nil else {
		iconOverride = if not FFlagAgeBasedUXHomepageVerificationBannerLockIcon then nil else Foundation.Enums.IconName.LockClosed,
		primaryButtonVariantOverride = if not FFlagAgeBasedUXHomepageVerificationBannerGreyButton then nil else Foundation.Enums.ButtonVariant.Standard
	}
	local v49 = useDispatch()
	local v50 = useSocialUpsellOverlayController(false)
	local v51 = useRoactService(RoactNetworking)
	local v52 = React.useCallback(function(_: string) -- line: 88
		-- upvalues: v44 (copy), v49 (copy), startFacialAgeEstimation (copy), SocialUpsellType (copy), UpsellEntrySurfaceType (copy)
		if v44 and v44.upsellCardType == "Fae" then
			v49(startFacialAgeEstimation(SocialUpsellType.FacialAgeEstimation .. UpsellEntrySurfaceType.Homepage, nil, nil, UpsellEntrySurfaceType.Homepage))
		end
	end, {
		v49,
		v44
	})
	local v53 = React.useCallback(function(s2: string) -- line: 100
		-- upvalues: v44 (copy), v50 (copy), SocialUpsell (copy), UpsellEntrySurfaceType (copy), UpsellComponent (copy)
		if v44 and v44.upsellCardType == "Fae" then
			v50.openSocialOverlay(SocialUpsell.Enums.SocialUpsellType.FacialAgeEstimation, {
				upsellEntrySurface = UpsellEntrySurfaceType.Homepage,
				upsellEntryComponent = UpsellComponent.Banner,
				impressionId = s2
			})
		end
	end, {
		v44,
		v50.openSocialOverlay
	})
	local v54 = React.useCallback(function(_: string) -- line: 109
		-- upvalues: v49 (copy), v44 (copy), PostHomePageContactMethodModuleVariationDismiss (copy), v51 (copy)
		if v49 and v44 then
			v49(PostHomePageContactMethodModuleVariationDismiss(v51, v44.upsellCardType))
		end
	end, {
		v44,
		v51
	})
	local Theme = useStyle().Theme
	local v56 = useSelector(function(p3) -- line: 118
		return p3.FormFactor
	end)
	local v57 = if FFlagLuaAppCompositionAlways then nil else useResponsiveLayout("margin")
	local v58 = if not v43 then if not v45 then if v56 ~= FormFactor.COMPACT then GAME_CAROUSEL_SIDE_WIDE_PADDING else GAME_CAROUSEL_SIDE_COMPACT_PADDING else v57 else nil

	if not FFlagLuaAppCompositionAlways then
		local v59 = usePageSideMargin(v46.current)

		if v47 then
			v58 = v59
		end
	end

	if FFlagTestDeviceForFAEUpsell and v47 and not deviceMeetsRequirementsForFAE() then
		return nil
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundColor3 = Theme.BackgroundUIDefault.Color,
		AutomaticSize = Enum.AutomaticSize.Y,
		ref = v46
	}, {
		UIPadding = Roact.createElement("UIPadding", {
			PaddingLeft = if not v43 then UDim.new(0, v58) else nil,
			PaddingRight = if not v43 then UDim.new(0, v58) else nil,
			PaddingTop = UDim.new(0, 1)
		}),
		HomePageUpsellCard = if v47 then nil else Roact.createElement(HomePageUpsellCardWithIcon, {
			upsellCardVariation = v44,
			isCentered = isSubjectToDesktopPolicies() or IsVRAppBuild()
		}),
		HomePageUpsellBannerV2 = if not v47 or v44.upsellCardType == "" then nil else Roact.createElement(UpsellBanner, {
			config = createBannerConfigFromUpsellCardVariation(v44, v48),
			onPrimaryAction = v52,
			onSecondaryAction = v53,
			onDismiss = v54,
			upsellEntrySurface = UpsellEntrySurfaceType.Homepage,
			upsellEntryComponent = UpsellComponent.Banner
		})
	})
end
