local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local Signals = require(parent.Signals)
local NotificationsOrchestrator = require(parent.NotificationsOrchestrator)

local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local MarketplaceUnifiedItemType = AvatarExperienceAnalytics.UnifiedEventLogEnums.MarketplaceUnifiedItemType
local InExperienceOffers = require(parent.InExperienceOffers)

local getInExperienceShopStore = require(InExperienceShop.Stores.getInExperienceShopStore)
local GetShopGlobalIconStore = require(InExperienceShop.Stores.GetShopGlobalIconStore)
local FFlagEnableExperienceShopGlobalIcon = require(InExperienceShop.Flags.FFlagEnableExperienceShopGlobalIcon)
local hasRedeemedTrialWithinWindow = require(InExperienceShop.Utils.hasRedeemedTrialWithinWindow)

require(InExperienceShop.Types)

local defineFastInt = game:DefineFastInt("MaxTrialAvailableTooltipImpressions", 5)

local defineFastString = game:DefineFastString("TrialAvailableTooltipLifecycleKey", "trial-available-tooltip")
local defineFastInt2 = game:DefineFastInt("TrialAvailableTooltipCooldownSeconds", 86400)
local defineFastInt3 = game:DefineFastInt("TrialAvailableTooltipDelayMs", 500)
local defineFastInt4 = game:DefineFastInt("TrialAvailableTooltipDurationMs", 7000)

local FFlagEnableRedeemedFreeTrialTooltip = require(InExperienceShop.Flags.FFlagEnableRedeemedFreeTrialTooltip)
local FFlagEnableActiveFreeTrialTooltip = require(InExperienceShop.Flags.FFlagEnableActiveFreeTrialTooltip)
local defineFastFlag = game:DefineFastFlag("TrialNotificationTooltipOnStudio", false)
local defineFastInt5 = game:DefineFastInt("MaxRecentlyRedeemedTooltipImpressions", 5)

local v = {
	lifecycleKey = defineFastString,
	maxImpressions = defineFastInt,
	cooldownSeconds = defineFastInt2,
	delayMs = defineFastInt3,
	durationMs = defineFastInt4,
	titleKey = "Feature.InExperienceShop.Label.HaveTrial",
	actionTextKey = "Feature.InExperienceShop.Label.TryNow",
	source = "GamePassTrialAvailableTooltip",
	action = "openShop"
}
local v2 = {
	lifecycleKey = game:DefineFastString("TrialRecentlyRedeemedTooltipLifecycleKey", "trial-recently-redeemed-tooltip"),
	maxImpressions = defineFastInt5,
	cooldownSeconds = game:DefineFastInt("RecentlyRedeemedTooltipCooldownSeconds", 86400),
	delayMs = game:DefineFastInt("TrialRecentlyRedeemedTooltipDelayMs", 500),
	durationMs = game:DefineFastInt("TrialRecentlyRedeemedTooltipDurationMs", 7000),
	titleKey = "Feature.InExperienceShop.Tooltip.RecentlyRedeemed",
	actionTextKey = "Feature.InExperienceShop.Label.BuyGamePass",
	source = "GamePassTrialRecentlyRedeemedTooltip",
	action = "promptGamePassPurchase"
}

local function asTooltipSlot(p: string) -- 2 equivalent calls inferred from this helper
	return p
end

local v3 = nil
local v4 = nil
local v5 = nil

local signal, v6 = Signals.createSignal(nil)

local v7 = nil
local v8 = nil

local delayMs = 0
local durationMs = 0
local action = "openShop"

local gamePassId = nil

local function hasAvailableTrial(p): boolean -- 1 equivalent call inferred from this helper
	local _, v9 = next(p.available)
	return v9 == true
end

local function hasActiveTrial(p): boolean -- 3 equivalent calls inferred from this helper
	local _, v9 = next(p.active)
	return v9 == true
end

local function firstRedeemedGamePassId(trialAvailabilities)
	for k, v9 in trialAvailabilities.redeemed do
		if hasRedeemedTrialWithinWindow({ [k] = v9 }) then
			return v9.gamePassId
		end
	end

	return nil
end

local function firstActiveGamePassId(p)
	local v9, v10 = next(p.active)
	return if v10 == true then v9 else nil
end

local function selectCampaign(p)
	if
		FFlagEnableActiveFreeTrialTooltip and hasActiveTrial(p) -- inferred equivalent call
		or FFlagEnableRedeemedFreeTrialTooltip and hasRedeemedTrialWithinWindow(p.redeemed)
	then
		return v2
	end

	if hasAvailableTrial(p) then -- inferred equivalent call
		return v
	end

	return nil
end

local function chooseSlot(p): nil | string
	local isShopAvailable = InExperienceOffers.getOffersStore(false).getIsShopAvailable(p)

	if FFlagEnableExperienceShopGlobalIcon then
		if GetShopGlobalIconStore(false).getEnabled(p) then
			return "EducationTooltipOnShopIcon"
		end

		local v9 = getInExperienceShopStore(false)

		if v9.getLoading(p) or v9.getGlobalIconBackendEnabled(p) then
			return nil
		end

		if isShopAvailable then
			return "EducationTooltipOnHamburger"
		end

		return nil
	elseif isShopAvailable then
		return "EducationTooltipOnHamburger"
	else
		return nil
	end
end

local function submitTooltip(slotId: string, data, itemId: string?)
	local slotDisplayPayload

	if slotId == "EducationTooltipOnShopIcon" then
		slotDisplayPayload = {
			slot = "EducationTooltipOnShopIcon",
			title = data.titleKey,
			actionText = data.actionTextKey
		}
	else
		slotDisplayPayload = {
			slot = "EducationTooltipOnHamburger",
			title = data.titleKey,
			actionText = data.actionTextKey
		}
	end

	local v9 = {
		slotId = slotId,
		priority = 0,
		lifecycleKey = data.lifecycleKey,
		lifecyclePolicy = {
			frequency = {
				maxImpressions = data.maxImpressions,
				window = "forever",
				cooldownSeconds = data.cooldownSeconds
			},
			visibility = { delayMs = data.delayMs, autoDismissAfterMs = data.durationMs }
		},
		source = data.source,
		slotDisplayPayload = slotDisplayPayload,
		itemId = itemId,
		itemType = 0
	}
	local itemType

	if itemId ~= nil then
		itemType = MarketplaceUnifiedItemType.GAME_PASS
	end

	v9.itemType = itemType

	if defineFastFlag then
		v9.enableOnStudio = true
	end

	v9.suppressWhileInExperienceShopOpen = true
	return NotificationsOrchestrator.submit(v9)
end

local function readActiveTooltip(slot: string, p)
	local v9 = NotificationsOrchestrator.getActiveForSlot(slot)(p)

	local v10 = signal(p)

	if v9 == nil or v9.handle ~= v10 or v9.payload.slot ~= slot then
		return nil
	end

	local payload = v9.payload
	return {
		slot = slot,
		title = payload.title or "",
		actionText = payload.actionText or "",
		delayMs = delayMs,
		durationMs = durationMs,
		action = action,
		gamePassId = gamePassId
	}
end

local function activeHandle() -- 1 equivalent call inferred from this helper
	if v5 == nil or readActiveTooltip(v5, false) == nil then
		return nil
	end

	return signal(false)
end

local function isTrialTooltipShowing(p): boolean
	local slot = v5

	if slot ~= nil then
		return readActiveTooltip(slot, p) ~= nil
	end

	signal(p)
	return false
end

local function getActiveTooltip(p)
	local slot = v5

	if slot ~= nil then
		return readActiveTooltip(slot, p)
	end

	signal(p)
	return nil
end

local function isShowingOnSlot(slot: string, p) -- 2 equivalent calls inferred from this helper
	local v9 = readActiveTooltip(slot, p) ~= nil
	return v5 == slot and v9
end

local function isHamburgerTooltipShowing(p)
	return isShowingOnSlot("EducationTooltipOnHamburger", p) -- inferred equivalent call
end

local function isShopIconTooltipShowing(p)
	return isShowingOnSlot("EducationTooltipOnShopIcon", p) -- inferred equivalent call
end

local function report(p)
	local v9 = v5
	local tooltipSlot = asTooltipSlot(asTooltipSlot(activeHandle())) -- inferred equivalent call

	if v9 == nil or tooltipSlot == nil then
		return
	end

	if p.type == "mounted" then
		if v7 == tooltipSlot then
			return
		end

		v7 = tooltipSlot
	elseif p.type == "viewed" then
		if v8 == tooltipSlot then
			return
		end

		v8 = tooltipSlot
	end

	NotificationsOrchestrator.report(v9, tooltipSlot, p)
end

local v9 = false

local function dismiss(p)
	v9 = true
	report({
		type = "dismissed",
		reason = p == nil and "activated" or p
	})
end

local function submitFreeTrialTooltips() -- 1 equivalent call inferred from this helper
	local v10 = v4

	if v10 ~= nil then
		return v10
	end

	local v11 = false
	local v12 = getInExperienceShopStore(false)
	v3 = Signals.createEffect(function(p)
		local trialAvailabilities = v12.getTrialAvailabilities(p)
		local v13, _, v14

		if FFlagEnableActiveFreeTrialTooltip then
			if hasActiveTrial(trialAvailabilities) then -- inferred equivalent call
				v13 = v2
			elseif
				FFlagEnableRedeemedFreeTrialTooltip
				and hasRedeemedTrialWithinWindow(trialAvailabilities.redeemed)
			then
				v13 = v2
			else
				_, v14 = next(trialAvailabilities.available)

				if v14 == true then
					v13 = v
				end
			end
		elseif FFlagEnableRedeemedFreeTrialTooltip and hasRedeemedTrialWithinWindow(trialAvailabilities.redeemed) then
			v13 = v2
		else
			_, v14 = next(trialAvailabilities.available)

			if v14 == true then
				v13 = v
			end
		end

		if v9 or v11 or v13 == nil then
			return
		end

		local slotId = chooseSlot(p)

		if slotId == nil then
			return
		end

		v11 = true

		v5 = slotId

		delayMs = v13.delayMs
		durationMs = v13.durationMs
		action = v13.action
		local v15

		if v13.action == "promptGamePassPurchase" then
			if FFlagEnableActiveFreeTrialTooltip then
				if hasActiveTrial(trialAvailabilities) then -- inferred equivalent call
					local v16
					v15, v16 = next(trialAvailabilities.active)

					if v16 ~= true then
						v15 = nil
					end
				else
					v15 = firstRedeemedGamePassId(trialAvailabilities)
				end
			else
				v15 = firstRedeemedGamePassId(trialAvailabilities)
			end
		end

		gamePassId = v15

		v6(submitTooltip(slotId, v13, gamePassId))
	end)

	v4 = isTrialTooltipShowing
	return isTrialTooltipShowing
end

return (setmetatable({
	reportMounted = function()
		report({ type = "mounted" })
	end,
	reportViewed = function()
		report({ type = "viewed" })
	end,
	reportActivated = function()
		report({ type = "activated" })
	end,
	dismiss = dismiss,
	getActiveTooltip = getActiveTooltip,
	isHamburgerTooltipShowing = isHamburgerTooltipShowing,
	isShopIconTooltipShowing = isShopIconTooltipShowing
}, {
	__call = function(_)
		return submitFreeTrialTooltips() -- inferred equivalent call
	end
}))
