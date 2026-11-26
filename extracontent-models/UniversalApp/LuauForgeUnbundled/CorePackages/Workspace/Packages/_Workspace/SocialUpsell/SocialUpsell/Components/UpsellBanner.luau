local HttpService = game:GetService("HttpService")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/React")
local useEffect = React.useEffect
local AppBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/AppBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/Foundation")
local useCallback = React.useCallback

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Types")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Constants")
require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Enum/SocialUpsellType")
local isCompactUpsellBanner = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Utils/isCompactUpsellBanner")
local getUpsellSignalStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/SignalStores/getUpsellSignalStore")

local SocialUpsellAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Analytics/SocialUpsellAnalytics")
local UpsellComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Analytics/Enum/UpsellComponent")
local eventTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialLuaAnalytics").Analytics.Enums.EventTypes

local fFlagAgeBasedUXHomepageVerificationBannerGreyButton = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SharedFlags").FFlagAgeBasedUXHomepageVerificationBannerGreyButton

local UPSELL_BUTTON_ACTION = Constants.UPSELL_BUTTON_ACTION
local buttonVariant = Foundation.Enums.ButtonVariant

local banner = AppBlox.Banner

local v5 = { isContained = true }

local function getButtonVariant(p2, p3)
	if fFlagAgeBasedUXHomepageVerificationBannerGreyButton and p2.variantOverride then
		return p2.variantOverride
	end

	local v6 = isCompactUpsellBanner(p3)

	if not p2.action then
		return nil
	end

	if p2.action == UPSELL_BUTTON_ACTION.Primary then
		if v6 then
			return buttonVariant.SoftEmphasis
		end

		return buttonVariant.Emphasis
	elseif p2.action == UPSELL_BUTTON_ACTION.Secondary then
		return buttonVariant.Utility
	end

	return nil
end

local function getBannerPropsFromConfig(data, p2)
	local v6 = {}
	local v7 = {}

	if data.buttons then
		for k, button in data.buttons do
			local v8 = { text = button.text, variant = 0, onActivated = 0 }
			local v9

			if fFlagAgeBasedUXHomepageVerificationBannerGreyButton and button.variantOverride then
				v9 = button.variantOverride
			else
				local v10 = isCompactUpsellBanner(data)

				if button.action then
					if button.action == UPSELL_BUTTON_ACTION.Primary then
						v9 = if v10 then buttonVariant.SoftEmphasis else buttonVariant.Emphasis
					elseif button.action == UPSELL_BUTTON_ACTION.Secondary then
						v9 = buttonVariant.Utility
					end
				end
			end

			v8.variant = v9
			v8.onActivated = p2[button.action]
			table.insert(v7, v8)
		end
	end

	if data.labelItems then
		for k, labelItem in data.labelItems do
			if labelItem.type == Constants.UPSELL_LABEL_ITEM_TYPE_COUNTDOWN then
				table.insert(v6, {
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
		title = data.title,
		body = data.body,
		badges = v6,
		buttons = v7,
		onDismiss = 0,
		image = 0,
		icon = 0
	}

	local v8 = if data.isDismissable then p2[UPSELL_BUTTON_ACTION.Dismiss] else nil
	bannerProps.onDismiss = v8
	bannerProps.image = data.image
	local v9 = if not data.image then data.icon else nil
	bannerProps.icon = v9
	return bannerProps
end

local function UpsellBanner(p2)
	local union = Cryo.Dictionary.union(v5, p2)

	local v6 = React.useMemo(function()
		return union.impressionId or HttpService:GenerateGUID(false)
	end, { union.impressionId, union.config.type })

	local ref = React.useRef(nil)
	local v7 = getUpsellSignalStore()

	local v8 = React.useMemo(function()
		return SocialUpsellAnalytics.evaluateUpsellStage(
			union.upsellEntrySurface,
			UpsellComponent.Banner,
			union.upsellEntryComponent
		)
	end, { union.upsellEntrySurface, union.upsellEntryComponent })

	useEffect(function()
		if v6 and ref.current ~= v6 then
			SocialUpsellAnalytics.logUpsellEvent(eventTypes.SocialUpsellShown, {
				upsellPurpose = union.config.type,
				upsellEntrySurface = union.upsellEntrySurface,
				upsellStage = v8,
				upsellImpressionId = v6,
				upsellComponent = UpsellComponent.Banner,
				conversationId = union.conversationId,
				upsellEntryComponent = union.upsellEntryComponent
			})

			ref.current = v6
		end
	end, {
		union.config.type,
		union.upsellEntrySurface,
		v8,
		v6,
		union.upsellEntryComponent
	})

	useEffect(function()
		local kind = union.config.type
		local upsellEntrySurface = union.upsellEntrySurface
		v7.setUpsellBannerData(kind, upsellEntrySurface, union.config)

		return function()
			v7.setUpsellBannerData(kind, upsellEntrySurface, nil)
		end
	end, { union.upsellEntrySurface, union.config, v7 })

	local v9 = useCallback(function(callback, p3)
		return function()
			SocialUpsellAnalytics.logUpsellEvent(eventTypes.SocialUpsellButtonClick, {
				upsellPurpose = union.config.type,
				upsellEntrySurface = union.upsellEntrySurface,
				upsellStage = v8,
				upsellImpressionId = v6,
				upsellComponent = UpsellComponent.Banner,
				btn = p3,
				conversationId = union.conversationId,
				upsellEntryComponent = union.upsellEntryComponent
			})

			callback(v6)
		end
	end, {
		union.upsellEntrySurface,
		union.config.type,
		v8,
		v6,
		union.upsellEntryComponent
	})

	local v10 = useCallback(v9(union.onPrimaryAction, UPSELL_BUTTON_ACTION.Primary), {
		v9,
		union.onPrimaryAction
	})

	local v11 = useCallback(v9(union.onSecondaryAction, UPSELL_BUTTON_ACTION.Secondary), {
		v9,
		union.onSecondaryAction
	})

	local v12 = useCallback(v9(union.onDismiss, "Dismiss"), { v9, union.onDismiss })

	local v13 = React.useMemo(function()
		return getBannerPropsFromConfig(union.config, {
			[UPSELL_BUTTON_ACTION.Primary] = v10,
			[UPSELL_BUTTON_ACTION.Secondary] = v11,
			[UPSELL_BUTTON_ACTION.Dismiss] = v12
		})
	end, { union.config, v10, v11, v12 })

	return React.createElement(banner, Cryo.Dictionary.join(v13, {
		isContained = union.isContained
	}))
end

return UpsellBanner
