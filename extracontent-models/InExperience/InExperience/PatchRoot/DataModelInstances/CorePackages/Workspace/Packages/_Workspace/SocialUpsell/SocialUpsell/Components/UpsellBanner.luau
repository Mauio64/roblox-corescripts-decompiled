local SocialUpsell = script:FindFirstAncestor("SocialUpsell")
local parent = SocialUpsell.Parent
local HttpService = game:GetService("HttpService")
local React = require(parent.React)
local useEffect = React.useEffect
local AppBlox = require(parent.AppBlox)
local Foundation = require(parent.Foundation)
local useCallback = React.useCallback

local Cryo = require(parent.Cryo)
require(SocialUpsell.Types)
local Constants = require(SocialUpsell.Constants)
require(SocialUpsell.Enum.SocialUpsellType)
local isCompactUpsellBanner = require(SocialUpsell.Utils.isCompactUpsellBanner)
local getUpsellSignalStore = require(SocialUpsell.SignalStores.getUpsellSignalStore)

local SocialUpsellAnalytics = require(SocialUpsell.Analytics.SocialUpsellAnalytics)
local UpsellComponent = require(SocialUpsell.Analytics.Enum.UpsellComponent)
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local EventTypes = SocialLuaAnalytics.Analytics.Enums.EventTypes

local SharedFlags = require(parent.SharedFlags)
local FFlagAgeBasedUXHomepageVerificationBannerGreyButton = SharedFlags.FFlagAgeBasedUXHomepageVerificationBannerGreyButton

local UPSELL_BUTTON_ACTION = Constants.UPSELL_BUTTON_ACTION
local ButtonVariant = Foundation.Enums.ButtonVariant

local Banner = AppBlox.Banner

local v = { isContained = true }

local function getButtonVariant(button, data) -- 1 equivalent call inferred from this helper
	if FFlagAgeBasedUXHomepageVerificationBannerGreyButton and button.variantOverride then
		return button.variantOverride
	end

	local compactUpsellBanner = isCompactUpsellBanner(data)

	if not button.action then
		return nil
	end

	if button.action == UPSELL_BUTTON_ACTION.Primary then
		if compactUpsellBanner then
			return ButtonVariant.SoftEmphasis
		end

		return ButtonVariant.Emphasis
	elseif button.action == UPSELL_BUTTON_ACTION.Secondary then
		return ButtonVariant.Utility
	end

	return nil
end

local function getBannerPropsFromConfig(config, p)
	local badges = {}
	local buttons = {}

	if config.buttons then
		for _, button in config.buttons do
			local v2 = {
				text = button.text,
				variant = getButtonVariant(button, config), -- inferred equivalent call
				onActivated = p[button.action]
			}
			table.insert(buttons, v2)
		end
	end

	if config.labelItems then
		for _, labelItem in config.labelItems do
			if labelItem.type == Constants.UPSELL_LABEL_ITEM_TYPE_COUNTDOWN then
				table.insert(badges, {
					text = labelItem.text,
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

	local bannerProps = {
		title = config.title,
		body = config.body,
		badges = badges,
		buttons = buttons,
		onDismiss = 0,
		image = 0,
		icon = 0
	}
	local onDismiss

	if config.isDismissable then
		onDismiss = p[UPSELL_BUTTON_ACTION.Dismiss]
	end

	bannerProps.onDismiss = onDismiss
	bannerProps.image = config.image
	local icon

	if not config.image then
		icon = config.icon
	end

	bannerProps.icon = icon
	return bannerProps
end

local function UpsellBanner(p)
	local union = Cryo.Dictionary.union(v, p)

	local v2 = React.useMemo(function()
		return union.impressionId or HttpService:GenerateGUID(false)
	end, { union.impressionId, union.config.type })

	local ref = React.useRef(nil)
	local upsellSignalStore = getUpsellSignalStore()

	local upsellStage = React.useMemo(function()
		return SocialUpsellAnalytics.evaluateUpsellStage(
			union.upsellEntrySurface,
			UpsellComponent.Banner,
			union.upsellEntryComponent
		)
	end, { union.upsellEntrySurface, union.upsellEntryComponent })

	useEffect(function()
		if v2 and ref.current ~= v2 then
			SocialUpsellAnalytics.logUpsellEvent(EventTypes.SocialUpsellShown, {
				upsellPurpose = union.config.type,
				upsellEntrySurface = union.upsellEntrySurface,
				upsellStage = upsellStage,
				upsellImpressionId = v2,
				upsellComponent = UpsellComponent.Banner,
				conversationId = union.conversationId,
				upsellEntryComponent = union.upsellEntryComponent
			})

			ref.current = v2
		end
	end, {
		union.config.type,
		union.upsellEntrySurface,
		upsellStage,
		v2,
		union.upsellEntryComponent
	})

	useEffect(function()
		local kind = union.config.type
		local upsellEntrySurface = union.upsellEntrySurface
		upsellSignalStore.setUpsellBannerData(kind, upsellEntrySurface, union.config)

		return function()
			upsellSignalStore.setUpsellBannerData(kind, upsellEntrySurface, nil)
		end
	end, { union.upsellEntrySurface, union.config, upsellSignalStore })

	local v3 = useCallback(function(callback, btn)
		return function()
			SocialUpsellAnalytics.logUpsellEvent(EventTypes.SocialUpsellButtonClick, {
				upsellPurpose = union.config.type,
				upsellEntrySurface = union.upsellEntrySurface,
				upsellStage = upsellStage,
				upsellImpressionId = v2,
				upsellComponent = UpsellComponent.Banner,
				btn = btn,
				conversationId = union.conversationId,
				upsellEntryComponent = union.upsellEntryComponent
			})

			callback(v2)
		end
	end, {
		union.upsellEntrySurface,
		union.config.type,
		upsellStage,
		v2,
		union.upsellEntryComponent
	})

	local v4 = useCallback(v3(union.onPrimaryAction, UPSELL_BUTTON_ACTION.Primary), { v3, union.onPrimaryAction })

	local v5 = useCallback(v3(union.onSecondaryAction, UPSELL_BUTTON_ACTION.Secondary), { v3, union.onSecondaryAction })

	local v6 = useCallback(v3(union.onDismiss, "Dismiss"), { v3, union.onDismiss })

	local v7 = React.useMemo(function()
		return getBannerPropsFromConfig(union.config, {
			[UPSELL_BUTTON_ACTION.Primary] = v4,
			[UPSELL_BUTTON_ACTION.Secondary] = v5,
			[UPSELL_BUTTON_ACTION.Dismiss] = v6
		})
	end, { union.config, v4, v5, v6 })

	return React.createElement(Banner, Cryo.Dictionary.join(v7, { isContained = union.isContained }))
end

return UpsellBanner
