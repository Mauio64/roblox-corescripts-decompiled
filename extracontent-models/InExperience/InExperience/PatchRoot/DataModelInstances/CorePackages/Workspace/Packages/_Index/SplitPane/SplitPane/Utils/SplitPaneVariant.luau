local parent = script:FindFirstAncestor("SplitPane").Parent

local SharedFlags = require(parent.SharedFlags)
local AppSplitView = require(parent.AppSplitView)

local SplitPaneSlot = AppSplitView.Enums.SplitPaneSlot

local FFlagSplitPaneExperimentVariants = SharedFlags.FFlagSplitPaneExperimentVariants
local FFlagSplitPaneVariantDefaultCollapsed = SharedFlags.FFlagSplitPaneVariantDefaultCollapsed
local FFlagSplitPaneVariantAvatarOnHomeOnly = SharedFlags.FFlagSplitPaneVariantAvatarOnHomeOnly
local FFlagSplitPaneVariantCollapsedAutoOpen = SharedFlags.FFlagSplitPaneVariantCollapsedAutoOpen
local FFlagSplitPaneAvatarOnlyAlwaysExpanded = SharedFlags.FFlagSplitPaneAvatarOnlyAlwaysExpanded

local v = {
	name = "DefaultOpen",
	defaultOpen = true,
	autoExpandOnSupportOpen = true,
	avatarOnHome = true,
	supportSlotEligible = true,
	profileSupportSlotEligibleWhenCollapsed = true,
	educationModal = true
}

local v2 = {
	name = "DefaultCollapsed",
	defaultOpen = false,
	autoExpandOnSupportOpen = false,
	avatarOnHome = true,
	supportSlotEligible = true,
	profileSupportSlotEligibleWhenCollapsed = false,
	educationModal = true
}

local v3 = {
	name = "AvatarOnHomeOnly",
	defaultOpen = true,
	autoExpandOnSupportOpen = true,
	avatarOnHome = true,
	supportSlotEligible = false,
	profileSupportSlotEligibleWhenCollapsed = true,
	educationModal = true
}

local v4 = {
	name = "CollapsedAutoOpen",
	defaultOpen = false,
	autoExpandOnSupportOpen = true,
	avatarOnHome = false,
	supportSlotEligible = true,
	profileSupportSlotEligibleWhenCollapsed = true,
	educationModal = false
}

local v5 = false
local variantConfig = v

local function resolveVariant() -- 1 equivalent call inferred from this helper
	local variant = v

	if FFlagSplitPaneVariantCollapsedAutoOpen then
		variant = v4
	elseif FFlagSplitPaneVariantAvatarOnHomeOnly then
		variant = v3
	elseif FFlagSplitPaneVariantDefaultCollapsed then
		variant = v2
	end

	v5 = true
	variantConfig = variant
	return variant
end

local function getVariantConfig() -- 12 equivalent calls inferred from this helper
	if not v5 then
		resolveVariant() -- inferred equivalent call
	end

	return variantConfig
end

local function isPaneCollapsedByDefault(): boolean -- 1 equivalent call inferred from this helper
	return not getVariantConfig().defaultOpen -- inferred equivalent call
end

local function shouldAutoExpandOnSupportOpen() -- 1 equivalent call inferred from this helper
	return getVariantConfig().autoExpandOnSupportOpen -- inferred equivalent call
end

local function isSupportPaneAlwaysExpanded(): boolean
	return not getVariantConfig().supportSlotEligible -- inferred equivalent call
end

local function shouldCollapseOnSupportClose(): boolean
	return not getVariantConfig().avatarOnHome -- inferred equivalent call
end

local function shouldShowAvatarOnHome()
	return getVariantConfig().avatarOnHome -- inferred equivalent call
end

local function isEducationModalEnabled()
	return getVariantConfig().educationModal -- inferred equivalent call
end

local function getGameDetailsSplitPaneEligibility()
	if FFlagSplitPaneExperimentVariants and not getVariantConfig().supportSlotEligible then -- inferred equivalent call
		return nil
	end

	return SplitPaneSlot.Support
end

local function getProfileSplitPaneEligibility(p: string?)
	if not FFlagSplitPaneExperimentVariants then
		return SplitPaneSlot.Support
	end

	local variantConfig2 = getVariantConfig() -- inferred equivalent call

	if
		not variantConfig2.supportSlotEligible
		or p == AppSplitView.Enums.SupportPaneMode.Collapsed
		and not variantConfig2.profileSupportSlotEligibleWhenCollapsed
	then
		return nil
	end

	return SplitPaneSlot.Support
end

local function getProfileRoutePresentation(p: string?)
	if FFlagSplitPaneExperimentVariants then
		local support

		if p ~= nil then
			if FFlagSplitPaneExperimentVariants then
				local variantConfig2 = getVariantConfig() -- inferred equivalent call

				if
					variantConfig2.supportSlotEligible
					and (p ~= AppSplitView.Enums.SupportPaneMode.Collapsed or variantConfig2.profileSupportSlotEligibleWhenCollapsed)
				then
					support = SplitPaneSlot.Support
				end
			else
				support = SplitPaneSlot.Support
			end
		end

		local v6 = support ~= nil
		local rendersOverlay = not v6

		if rendersOverlay then
			if p == nil then
				rendersOverlay = true
			else
				rendersOverlay = isPaneCollapsedByDefault() and not shouldAutoExpandOnSupportOpen() -- inferred equivalent call
			end
		end

		return {
			splitPaneEligibility = support,
			rendersOverlay = rendersOverlay,
			rendersAboveSplitPane = not (v6 or rendersOverlay)
		}
	else
		local splitPaneEligibility

		if p ~= nil then
			splitPaneEligibility = SplitPaneSlot.Support
		end

		return {
			splitPaneEligibility = splitPaneEligibility,
			rendersOverlay = p == nil,
			rendersAboveSplitPane = false
		}
	end
end

local function getExperienceDetailSplitPaneEligibility()
	if
		FFlagSplitPaneExperimentVariants
		and not FFlagSplitPaneAvatarOnlyAlwaysExpanded
		and not getVariantConfig().supportSlotEligible -- inferred equivalent call
	then
		return nil
	end

	return SplitPaneSlot.Support
end

local function getDevStoreSeeAllSplitPaneEligibility()
	if FFlagSplitPaneExperimentVariants and not getVariantConfig().supportSlotEligible then -- inferred equivalent call
		return nil
	end

	return SplitPaneSlot.Support
end

local function getBadgesSeeAllSplitPaneEligibility()
	if FFlagSplitPaneExperimentVariants and not getVariantConfig().supportSlotEligible then -- inferred equivalent call
		return nil
	end

	return SplitPaneSlot.Support
end

return {
	getVariantConfig = getVariantConfig,
	isPaneCollapsedByDefault = isPaneCollapsedByDefault,
	shouldAutoExpandOnSupportOpen = shouldAutoExpandOnSupportOpen,
	isSupportPaneAlwaysExpanded = isSupportPaneAlwaysExpanded,
	shouldCollapseOnSupportClose = shouldCollapseOnSupportClose,
	shouldShowAvatarOnHome = shouldShowAvatarOnHome,
	isEducationModalEnabled = isEducationModalEnabled,
	getGameDetailsSplitPaneEligibility = getGameDetailsSplitPaneEligibility,
	getProfileSplitPaneEligibility = getProfileSplitPaneEligibility,
	getProfileRoutePresentation = getProfileRoutePresentation,
	getExperienceDetailSplitPaneEligibility = getExperienceDetailSplitPaneEligibility,
	getDevStoreSeeAllSplitPaneEligibility = getDevStoreSeeAllSplitPaneEligibility,
	getBadgesSeeAllSplitPaneEligibility = getBadgesSeeAllSplitPaneEligibility,
	variantConfigs = { v, v2, v3, v4 }
}
