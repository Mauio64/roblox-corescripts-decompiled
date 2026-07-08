local SocialUpsell = script:FindFirstAncestor("SocialUpsell")
local SocialUpsellParent = SocialUpsell.Parent
local HttpService = game:GetService("HttpService")
local React = require(SocialUpsellParent.React)
local useEffect = React.useEffect
local AppBlox = require(SocialUpsellParent.AppBlox)
local Foundation = require(SocialUpsellParent.Foundation)
local useCallback = React.useCallback
local Cryo = require(SocialUpsellParent.Cryo)

require(SocialUpsell.Types)

local Constants = require(SocialUpsell.Constants)

require(SocialUpsell.Enum.SocialUpsellType)

local isCompactUpsellBanner = require(SocialUpsell.Utils.isCompactUpsellBanner)
local getUpsellSignalStore = require(SocialUpsell.SignalStores.getUpsellSignalStore)
local SocialUpsellAnalytics = require(SocialUpsell.Analytics.SocialUpsellAnalytics)
local UpsellComponent = require(SocialUpsell.Analytics.Enum.UpsellComponent)
local EventTypes = require(SocialUpsellParent.SocialLuaAnalytics).Analytics.Enums.EventTypes
local FFlagAddUpsellEntryComponentToAnalytics = require(SocialUpsell.Flag.FFlagAddUpsellEntryComponentToAnalytics)
local FFlagAgeBasedUXHomepageVerificationBannerGreyButton = require(SocialUpsellParent.SharedFlags).FFlagAgeBasedUXHomepageVerificationBannerGreyButton
local UPSELL_BUTTON_ACTION = Constants.UPSELL_BUTTON_ACTION
local ButtonVariant = Foundation.Enums.ButtonVariant
local Banner = AppBlox.Banner
local t1 = {
	isContained = true
}

local function getButtonVariant(p1, p2) -- line: 66
	-- upvalues: FFlagAgeBasedUXHomepageVerificationBannerGreyButton (copy), isCompactUpsellBanner (copy), UPSELL_BUTTON_ACTION (copy), ButtonVariant (copy)
	if FFlagAgeBasedUXHomepageVerificationBannerGreyButton and p1.variantOverride then
		return p1.variantOverride
	end

	local v27 = isCompactUpsellBanner(p2)

	if p1.action then
		if p1.action == UPSELL_BUTTON_ACTION.Primary then
			if v27 then
				return ButtonVariant.SoftEmphasis
			end

			return ButtonVariant.Emphasis
		end

		if p1.action == UPSELL_BUTTON_ACTION.Secondary then
			return ButtonVariant.Utility
		end
	end

	return nil
end
local function getBannerPropsFromConfig(p3, t2: {[any]: any}) -- line: 83
	-- upvalues: FFlagAgeBasedUXHomepageVerificationBannerGreyButton (copy), isCompactUpsellBanner (copy), UPSELL_BUTTON_ACTION (copy), ButtonVariant (copy), Constants (copy), Foundation (copy)
	local t3 = {}
	local t4 = {}

	if p3.buttons then
		for _, v33 in p3.buttons do
			local t5 = {
				text = v33.text
			}
			local variantOverride

			if FFlagAgeBasedUXHomepageVerificationBannerGreyButton and v33.variantOverride then
				variantOverride = v33.variantOverride
			else
				local v36 = isCompactUpsellBanner(p3)

				variantOverride = if not v33.action then nil else if v33.action ~= UPSELL_BUTTON_ACTION.Primary then if v33.action ~= UPSELL_BUTTON_ACTION.Secondary then nil else ButtonVariant.Utility else if not v36 then ButtonVariant.Emphasis else ButtonVariant.SoftEmphasis
			end

			t5.variant = variantOverride
			t5.onActivated = t2[v33.action]
			table.insert(t4, t5)
		end
	end

	if p3.labelItems then
		for _, v38 in p3.labelItems do
			if v38.type == Constants.UPSELL_LABEL_ITEM_TYPE_COUNTDOWN then
				table.insert(t3, {
					text = v38.text,
					icon = {
						variant = Foundation.Enums.IconVariant.Filled,
						position = Foundation.Enums.IconPosition.Left,
						name = Foundation.Enums.IconName.Clock
					},
					variant = Foundation.Enums.BadgeVariant.Neutral
				})
			end
		end
	end

	return {
		title = p3.title,
		body = p3.body,
		badges = t3,
		buttons = t4,
		onDismiss = if not p3.isDismissable then nil else t2[UPSELL_BUTTON_ACTION.Dismiss],
		image = p3.image,
		icon = if not p3.image then p3.icon else nil
	}
end
local function UpsellBanner(t6: {[any]: any}) -- line: 124
	-- upvalues: Cryo (copy), t1 (copy), React (copy), HttpService (copy), getUpsellSignalStore (copy), SocialUpsellAnalytics (copy), UpsellComponent (copy), useEffect (copy), EventTypes (copy), FFlagAddUpsellEntryComponentToAnalytics (copy), useCallback (copy), UPSELL_BUTTON_ACTION (copy), getBannerPropsFromConfig (copy), Banner (copy)
	local v40 = Cryo.Dictionary.union(t1, t6)
	local v41 = React.useMemo(function() -- line: 127
		-- upvalues: v40 (copy), HttpService (copy)
		return v40.impressionId or HttpService:GenerateGUID(false)
	end, {
		v40.impressionId,
		v40.config.type
	})
	local v42 = React.useRef(nil)
	local v43 = getUpsellSignalStore()
	local v44 = React.useMemo(function() -- line: 134
		-- upvalues: SocialUpsellAnalytics (copy), v40 (copy), UpsellComponent (copy)
		return SocialUpsellAnalytics.evaluateUpsellStage(v40.upsellEntrySurface, UpsellComponent.Banner, v40.upsellEntryComponent)
	end, {
		v40.upsellEntrySurface,
		v40.upsellEntryComponent
	})

	useEffect(function() -- line: 143
		-- upvalues: v41 (copy), v42 (copy), SocialUpsellAnalytics (copy), EventTypes (copy), v40 (copy), v44 (copy), UpsellComponent (copy), FFlagAddUpsellEntryComponentToAnalytics (copy)
		if v41 and v42.current ~= v41 then
			SocialUpsellAnalytics.logUpsellEvent(EventTypes.SocialUpsellShown, {
				upsellPurpose = v40.config.type,
				upsellEntrySurface = v40.upsellEntrySurface,
				upsellStage = v44,
				upsellImpressionId = v41,
				upsellComponent = UpsellComponent.Banner,
				conversationId = v40.conversationId,
				upsellEntryComponent = if not FFlagAddUpsellEntryComponentToAnalytics then nil else v40.upsellEntryComponent
			})
			v42.current = v41
		end
	end, {
		v40.config.type,
		v40.upsellEntrySurface,
		v44,
		v41,
		if not FFlagAddUpsellEntryComponentToAnalytics then nil else v40.upsellEntryComponent
	})
	useEffect(function() -- line: 169
		-- upvalues: v40 (copy), v43 (copy)
		local type = v40.config.type
		local upsellEntrySurface = v40.upsellEntrySurface

		v43.setUpsellBannerData(type, upsellEntrySurface, v40.config)

		return function() -- line: 174
			-- upvalues: v43 (copy), type (copy), upsellEntrySurface (copy)
			v43.setUpsellBannerData(type, upsellEntrySurface, nil)
		end
	end, {
		v40.upsellEntrySurface,
		v40.config,
		v43
	})

	local v45 = useCallback(function(p4: ((...any) -> ...any), p5) -- line: 181
		-- upvalues: SocialUpsellAnalytics (copy), EventTypes (copy), v40 (copy), v44 (copy), v41 (copy), UpsellComponent (copy), FFlagAddUpsellEntryComponentToAnalytics (copy)
		return function() -- line: 182
			-- upvalues: SocialUpsellAnalytics (copy), EventTypes (copy), v40 (copy), v44 (copy), v41 (copy), UpsellComponent (copy), p5 (copy), FFlagAddUpsellEntryComponentToAnalytics (copy), p4 (copy)
			SocialUpsellAnalytics.logUpsellEvent(EventTypes.SocialUpsellButtonClick, {
				upsellPurpose = v40.config.type,
				upsellEntrySurface = v40.upsellEntrySurface,
				upsellStage = v44,
				upsellImpressionId = v41,
				upsellComponent = UpsellComponent.Banner,
				btn = p5,
				conversationId = v40.conversationId,
				upsellEntryComponent = if not FFlagAddUpsellEntryComponentToAnalytics then nil else v40.upsellEntryComponent
			})
			p4(v41)
		end
	end, {
		v40.upsellEntrySurface,
		v40.config.type,
		v44,
		v41,
		if not FFlagAddUpsellEntryComponentToAnalytics then nil else v40.upsellEntryComponent
	})
	local v46 = useCallback(v45(v40.onPrimaryAction, UPSELL_BUTTON_ACTION.Primary), {
		v45,
		v40.onPrimaryAction
	})
	local v47 = useCallback(v45(v40.onSecondaryAction, UPSELL_BUTTON_ACTION.Secondary), {
		v45,
		v40.onSecondaryAction
	})
	local v48 = useCallback(v45(v40.onDismiss, "Dismiss"), {
		v45,
		v40.onDismiss
	})
	local v49 = React.useMemo(function() -- line: 224
		-- upvalues: getBannerPropsFromConfig (copy), v40 (copy), UPSELL_BUTTON_ACTION (copy), v46 (copy), v47 (copy), v48 (copy)
		return (getBannerPropsFromConfig(v40.config, {
			[UPSELL_BUTTON_ACTION.Primary] = v46,
			[UPSELL_BUTTON_ACTION.Secondary] = v47,
			[UPSELL_BUTTON_ACTION.Dismiss] = v48
		}))
	end, {
		v40.config,
		v46,
		v47,
		v48
	})

	return React.createElement(Banner, Cryo.Dictionary.join(v49, {
		isContained = v40.isContained
	}))
end

return UpsellBanner
