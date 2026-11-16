local StarterGui = game:GetService("StarterGui")

local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local Signals = require(parent.Signals)
local SharedFlags = require(parent.SharedFlags)
local InExperienceOffers = require(parent.InExperienceOffers)
local FFlagEnableExperienceShopGlobalIcon = require(InExperienceShop.Flags.FFlagEnableExperienceShopGlobalIcon)
local FFlagExperienceShopGlobalIconSkipCoreGuiCheck = require(InExperienceShop.Flags.FFlagExperienceShopGlobalIconSkipCoreGuiCheck)
local FFlagOfferNotifyOnGlobalIcon = SharedFlags.FFlagOfferNotifyOnGlobalIcon
local FFlagEnableFreeTrialBlueDot = require(InExperienceShop.Flags.FFlagEnableFreeTrialBlueDot)
local getInExperienceShopStore = require(InExperienceShop.Stores.getInExperienceShopStore)
local GetShopGlobalIconStore = require(InExperienceShop.Stores.GetShopGlobalIconStore)

local function initShopGlobalIcon()
	if not FFlagEnableExperienceShopGlobalIcon then
		return nil
	end

	local shopGlobalIconStore = GetShopGlobalIconStore(false)

	local v = FFlagExperienceShopGlobalIconSkipCoreGuiCheck and true
		or StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.All)
		or StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.ExperienceShop)

	local v2 = false

	local function updateEnabled() -- 2 equivalent calls inferred from this helper
		local v3 = v and v2
		shopGlobalIconStore.setEnabled(v3)

		if FFlagOfferNotifyOnGlobalIcon then
			InExperienceOffers.getOffersStore(false).setInExperienceShopGlobalIconAvailable(v3)
		end
	end

	local coreGuiChangedSignalConnection

	if FFlagExperienceShopGlobalIconSkipCoreGuiCheck then
		coreGuiChangedSignalConnection = nil
	else
		coreGuiChangedSignalConnection = StarterGui.CoreGuiChangedSignal:Connect(function(p, p2)
			if p == Enum.CoreGuiType.ExperienceShop or p == Enum.CoreGuiType.All then
				v = p2
				updateEnabled() -- inferred equivalent call
			end
		end)
	end

	local v3 = nil
	v3 = Signals.createEffect(function(p)
		local v4 = getInExperienceShopStore(false)

		if v4.getLoading(p) or not v4.getGlobalIconBackendEnabled(p) then
			return
		end

		v2 = true
		updateEnabled() -- inferred equivalent call

		if not FFlagOfferNotifyOnGlobalIcon then
			shopGlobalIconStore.setStatusIndicatorEnabled(v4.getGlobalIconHasNewOffers(p))
		end

		task.defer(function()
			if v3 then
				v3()
				v3 = nil
			end
		end)
	end)
	local v4

	if FFlagOfferNotifyOnGlobalIcon then
		v4 = Signals.createEffect(function(p)
			local offerNotificationShownWithEnum = InExperienceOffers.getOffersStore(p).getOfferNotificationShownWithEnum(p)
			shopGlobalIconStore.setStatusIndicatorEnabled(offerNotificationShownWithEnum == InExperienceOffers.NotificationLocation.GlobalIcon)
		end)
	else
		v4 = nil
	end

	local v5

	if FFlagEnableFreeTrialBlueDot then
		local submitFreeTrialBlueDot = require(InExperienceShop.submitFreeTrialBlueDot)
		v5 = Signals.createEffect(function(p)
			local shopIconBlueDotShowing = submitFreeTrialBlueDot.isShopIconBlueDotShowing(p)
			shopGlobalIconStore.setFreeTrialStatusIndicatorEnabled(shopIconBlueDotShowing)

			if shopIconBlueDotShowing then
				submitFreeTrialBlueDot.reportMounted()
				submitFreeTrialBlueDot.reportViewed()
			end
		end)
	else
		v5 = nil
	end

	return function()
		if not FFlagExperienceShopGlobalIconSkipCoreGuiCheck and coreGuiChangedSignalConnection then
			coreGuiChangedSignalConnection:Disconnect()
		end

		if v3 then
			v3()
			v3 = nil
		end

		if v4 then
			v4()
			v4 = nil
		end

		if v5 then
			v5()
			v5 = nil
			shopGlobalIconStore.setFreeTrialStatusIndicatorEnabled(false)
		end

		if FFlagOfferNotifyOnGlobalIcon then
			InExperienceOffers.getOffersStore(false).setInExperienceShopGlobalIconAvailable(false)
		end
	end
end

return initShopGlobalIcon
