local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local Signals = require(parent.Signals)
local NotificationsOrchestrator = require(parent.NotificationsOrchestrator)

local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local MarketplaceUnifiedItemType = AvatarExperienceAnalytics.UnifiedEventLogEnums.MarketplaceUnifiedItemType

local getInExperienceShopStore = require(InExperienceShop.Stores.getInExperienceShopStore)
local FFlagFreeTrialChipBuyAnimation = require(InExperienceShop.Flags.FFlagFreeTrialChipBuyAnimation)
local FFlagTrialNotificationTopBarChipOnStudio = require(InExperienceShop.Flags.FFlagTrialNotificationTopBarChipOnStudio)
local FIntFreeTrialUpsellTimerSecs = require(InExperienceShop.Flags.FIntFreeTrialUpsellTimerSecs)
local FIntFreeTrialUpsellAutoDismissAfterSecs = require(InExperienceShop.Flags.FIntFreeTrialUpsellAutoDismissAfterSecs)

local FreeTrialTopBarChip = NotificationsOrchestrator.SlotId.FreeTrialTopBarChip

local fn
local flag = false
local v = nil
local v2 = nil
local signal, v3 = Signals.createSignal(nil)
local signal2, v4 = Signals.createSignal("active")
local v5, v6, v7, v8

if FFlagFreeTrialChipBuyAnimation then
	v5, v6 = Signals.createSignal(false)
	v7, v8 = Signals.createSignal(nil)
else
	v5 = function(_): boolean
		return false
	end

	v7 = function(_): nil
		return nil
	end

	v6 = function(_) end

	v8 = function(_) end
end

local thread = nil
local thread2 = nil
local count = 0

local v9 = nil
local v10 = nil
local gamePassId = nil

local function cancelUpsellTimer() -- 2 equivalent calls inferred from this helper
	local v11 = thread

	if v11 ~= nil then
		task.cancel(v11)
		thread = nil
	end
end

local function cancelBuyDismissTimer() -- 1 equivalent call inferred from this helper
	local v11 = thread2

	if v11 ~= nil then
		task.cancel(v11)
		thread2 = nil
	end
end

local function isChipShowing(p): boolean -- 8 equivalent calls inferred from this helper
	local v11 = signal(p)

	if v11 == nil then
		return false
	end

	local v12 = NotificationsOrchestrator.getActiveForSlot(FreeTrialTopBarChip)(p)
	return v12 ~= nil and v12.payload.slot == "FreeTrialTopBarChip" and v12.handle == v11
end

local function isPresented(p)
	if isChipShowing(p) then -- inferred equivalent call
		return true
	end

	return v5(p or false)
end

local function chipImage(p)
	if isChipShowing(p) then -- inferred equivalent call
		local v11 = NotificationsOrchestrator.getActiveForSlot(FreeTrialTopBarChip)(p)

		if v11 == nil or v11.payload.slot ~= "FreeTrialTopBarChip" then
			return nil
		end

		return v11.payload.image
	elseif FFlagFreeTrialChipBuyAnimation and v5(p) then
		return v7(p)
	else
		return nil
	end
end

local function report(p)
	if not isChipShowing(false) then -- inferred equivalent call
		return
	end

	local v11 = signal(false)

	if v11 == nil then
		return
	end

	if p.type == "mounted" then
		if v == v11 then
			return
		end

		v = v11
	elseif p.type == "viewed" then
		if v2 == v11 then
			return
		end

		v2 = v11
	end

	NotificationsOrchestrator.report(FreeTrialTopBarChip, v11, p)
end

local function dismiss()
	if FFlagFreeTrialChipBuyAnimation then
		v6(false)
	end

	report({ type = "dismissed", reason = "user" })
end

local function dismissActiveForPurchasedGamePass(gamePassId2: string, flag2: boolean)
	if not flag2 or gamePassId ~= gamePassId2 or signal2(false) ~= "active" then
		return
	end

	if v9 == nil or v9 ~= count then
		if not isChipShowing(false) then -- inferred equivalent call
			return
		end

		cancelUpsellTimer() -- inferred equivalent call

		if FFlagFreeTrialChipBuyAnimation then
			v6(false)
		end

		report({ type = "dismissed", reason = "other" })
	else
		v9 = nil
		count += 1

		if FFlagFreeTrialChipBuyAnimation then
			v6(false)
		end
	end
end

local function buyAutoDismissAfterMs()
	if FIntFreeTrialUpsellAutoDismissAfterSecs <= 0 then
		return nil
	end

	return FIntFreeTrialUpsellAutoDismissAfterSecs * 1000
end

local function scheduleBuyAutoDismiss(p: string) -- 1 equivalent call inferred from this helper
	cancelBuyDismissTimer() -- inferred equivalent call
	local v11 = FIntFreeTrialUpsellAutoDismissAfterSecs

	if v11 <= 0 then
		return
	end

	thread2 = task.delay(v11, function()
		thread2 = nil

		if signal(false) == p and isChipShowing(false) then -- inferred equivalent call
			report({ type = "dismissed", reason = "timeout" })
		end
	end)
end

local function submitNotification(p: string, p2)
	if not getInExperienceShopStore(false).getNotificationFreeTrialTopBarChip(false) then
		NotificationsOrchestrator.report(
			FreeTrialTopBarChip,
			p == "upsell" and "free-trial-top-bar-upsell-chip" or "free-trial-top-bar-chip",
			{ type = "suppressed" }
		)

		return nil
	end

	v4(p)

	if p == "active" then
		gamePassId = p2.gamePassId
	end

	local v11

	if p == "upsell" then
		v11 = p2.gamePassId
	end

	v10 = v11
	local autoDismissAfterMs

	if p == "upsell" and not (FIntFreeTrialUpsellAutoDismissAfterSecs <= 0) then
		autoDismissAfterMs = FIntFreeTrialUpsellAutoDismissAfterSecs * 1000
	end

	local submit = NotificationsOrchestrator.submit
	local v12 = {
		slotId = FreeTrialTopBarChip,
		priority = 0,
		enableOnStudio = FFlagTrialNotificationTopBarChipOnStudio,
		lifecycleKey = p == "upsell" and "free-trial-top-bar-upsell-chip" or "free-trial-top-bar-chip",
		lifecyclePolicy = {
			frequency = {},
			visibility = autoDismissAfterMs ~= nil and { autoDismissAfterMs = autoDismissAfterMs } or nil
		},
		source = p == "upsell" and "GamePassFreeTrialUpsellTopBarChip" or "GamePassFreeTrialActiveTopBarChip",
		itemId = p2.gamePassId,
		itemType = MarketplaceUnifiedItemType.GAME_PASS,
		slotDisplayPayload = 0
	}
	local image

	if p2.image ~= "" then
		image = p2.image
	end

	v12.slotDisplayPayload = { slot = "FreeTrialTopBarChip", image = image }
	local v13 = submit(v12)

	v3(v13)
	return v13
end

local function submitUpsell(p) -- 1 equivalent call inferred from this helper
	local v11 = submitNotification("upsell", p)

	if v11 ~= nil then
		scheduleBuyAutoDismiss(v11) -- inferred equivalent call
	end
end

local function promptPurchase()
	report({ type = "activated" })
	local v11 = v10
	report({ type = "dismissed", reason = "activated" })

	if v11 == nil or v11 == "" then
		return
	end

	local initiateShopItemPurchase = require(InExperienceShop.initiateShopItemPurchase)
	initiateShopItemPurchase(v11, "GamePass")
end

local function scheduleUpsellTimer(p: string, p2) -- 1 equivalent call inferred from this helper
	cancelUpsellTimer() -- inferred equivalent call
	count += 1
	local v11 = count
	thread = task.delay(FIntFreeTrialUpsellTimerSecs, function()
		thread = nil

		if v11 ~= count or signal(false) ~= p and isChipShowing(false) then -- inferred equivalent call
			return
		end

		if signal(false) == p and isChipShowing(false) then -- inferred equivalent call
			if FFlagFreeTrialChipBuyAnimation then
				v8(chipImage(false))
				v6(true)
			end

			report({ type = "dismissed", reason = "timeout" })
		end

		local v12 = getInExperienceShopStore(false)
		local function submitBuyUnlessReplaced(flag2: boolean) -- 1 equivalent call inferred from this helper
			if v11 ~= count then
				return
			end

			v9 = nil

			if not flag2 then
				submitUpsell(p2) -- inferred equivalent call
			end

			if FFlagFreeTrialChipBuyAnimation then
				v6(false)
			end
		end
		v9 = v11
		v12.currentlyOwnsGamePass(p2.gamePassId):andThen(submitBuyUnlessReplaced):catch(function()
			submitBuyUnlessReplaced(false) -- inferred equivalent call
		end)
	end)
end

local function start()
	if flag then
		return
	end

	flag = true

	local v11 = nil
	local v12 = getInExperienceShopStore(false)
	local effect = Signals.createEffect(function(p)
		local trialRedeemThumbnail = v12.getTrialRedeemThumbnail(p)

		if trialRedeemThumbnail == nil or trialRedeemThumbnail == v11 then
			return
		end

		v11 = trialRedeemThumbnail

		if isChipShowing(false) then -- inferred equivalent call
			return
		end

		local v13 = {
			image = trialRedeemThumbnail.image,
			gamePassId = trialRedeemThumbnail.gamePassId
		}

		local v14 = submitNotification("active", v13)

		if v14 ~= nil and FIntFreeTrialUpsellTimerSecs > 0 then
			scheduleUpsellTimer(v14, v13) -- inferred equivalent call
		end
	end)

	local effect2 = Signals.createEffect(function(p)
		local purchasedOwnedGamePass = v12.getPurchasedOwnedGamePass(p)

		if purchasedOwnedGamePass == nil then
			return
		end

		dismissActiveForPurchasedGamePass(purchasedOwnedGamePass.gamePassId, true)
	end)
	fn = function()
		effect()
		effect2()
	end
end

return (setmetatable({
	isShowing = isChipShowing,
	isPresented = isPresented,
	handle = signal,
	image = chipImage,
	textKey = function(p): string
		if signal2(p) == "upsell" then
			return "Feature.Catalog.Action.Buy"
		end

		return "Feature.InExperienceShop.Label.Active"
	end,
	isEmphasis = function(p): boolean
		return signal2(p) == "upsell"
	end,
	promptsPurchase = function(p): boolean
		return signal2(p) == "upsell"
	end,
	promptPurchase = promptPurchase,
	dismissActiveForPurchasedGamePass = dismissActiveForPurchasedGamePass,
	reportMounted = function()
		report({ type = "mounted" })
	end,
	reportViewed = function()
		report({ type = "viewed" })
	end,
	reportActivated = function()
		report({ type = "activated" })
	end,
	dismiss = dismiss
}, {
	__call = function(_)
		start()
		return isChipShowing
	end
}))
