local AvatarEditorService = game:GetService("AvatarEditorService")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local AvatarSwitcher = script:FindFirstAncestor("AvatarSwitcher")
local parent = AvatarSwitcher.Parent

local Signals = require(parent.Signals)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local Http = require(parent.Http)
local Url = Http.Url
local Cryo = require(parent.Cryo)
local AvatarExperienceSlotBasedEditor = require(parent.AvatarExperienceSlotBasedEditor)
local InventoryItemAvailability = AvatarExperienceSlotBasedEditor.Enums.InventoryItemAvailability
local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local sendAXCounterV2 = AvatarExperienceAnalytics.sendAXCounterV2

local applyOutfit = require(AvatarSwitcher.Utils.applyOutfit)
local ExperienceAvatarSupportType = require(AvatarSwitcher.Enums.ExperienceAvatarSupportType)
local Constants = require(AvatarSwitcher.Constants)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAvatarSwitcherUseAvatarInventoryEndpoint = AvatarExperienceFlags.FFlagAvatarSwitcherUseAvatarInventoryEndpoint

local AvatarExperienceFlags2 = require(parent.AvatarExperienceFlags)
local FFlagAvatarSwitcherAccurateAvatarWarning = AvatarExperienceFlags2.FFlagAvatarSwitcherAccurateAvatarWarning
local AvatarExperienceFlags3 = require(parent.AvatarExperienceFlags)
local FFlagAvatarSwitcherCounters = AvatarExperienceFlags3.FFlagAvatarSwitcherCounters

local AvatarExperienceFlags4 = require(parent.AvatarExperienceFlags)
local FFlagAvatarSwitcherExpiredItemsWarning = AvatarExperienceFlags4.FFlagAvatarSwitcherExpiredItemsWarning

local AvatarExperienceFlags5 = require(parent.AvatarExperienceFlags)
local FFlagAXInventoryIncludeUnavailableItems = AvatarExperienceFlags5.FFlagAXInventoryIncludeUnavailableItems
local defineFastFlag = game:DefineFastFlag("AvatarSwitcherPcallApplyOutfit", false)

require(AvatarSwitcher.types)

local v = Url.AVATAR_URL .. "v1/avatar-inventory?"
local v2 = Url.AVATAR_URL .. "v2/avatar/experience/get-experience-avatar-support"

local function createAvatarSwitcherStore()
	local signal, v3 = createSignal({})
	local signal2, v4 = createSignal({})
	local signal3, v5 = createSignal(false)
	local signal4, v6 = createSignal(nil)
	local signal5, v7 = createSignal(false)
	local signal6, v8 = createSignal(false)

	local signal7, v9 = createSignal(nil)
	local signal8, v10 = createSignal(nil)
	local signal9, v11 = createSignal(nil)

	local getIsEmpty = createComputed(function(p)
		return signal3(p) and #signal(p) == 0
	end)

	local getSelectedOutfitDetails = createComputed(function(p)
		local v12 = signal4(p)

		if v12 == nil then
			return nil
		end

		return signal2(p)[v12]
	end)

	local function toggleRespawnPrompt(flag: boolean)
		v7(flag)
	end

	local function fetchOutfitDetails(p: number)
		local success, result = pcall(function()
			return AvatarEditorService:GetOutfitDetailsAsync(p)
		end)

		if not success then
			warn(`Avatar Switcher: failed to fetch outfit details for outfitId {p}.`, result)

			return
		end

		local ids

		if FFlagAvatarSwitcherAccurateAvatarWarning then
			ids = {}

			if result.Assets then
				for _, asset in result.Assets do
					table.insert(ids, asset.Id)
				end
			end
		end

		local v12 = { id = result.Id, name = result.Name, rigType = 0, assetIds = 0 }
		local rigType

		if result.PlayerAvatarType == "R6" then
			rigType = Enum.HumanoidRigType.R6
		else
			rigType = Enum.HumanoidRigType.R15
		end

		v12.rigType = rigType

		if not FFlagAvatarSwitcherAccurateAvatarWarning then
			ids = nil
		end

		v12.assetIds = ids

		v4(function(p2)
			return Cryo.Dictionary.join(p2, { [p] = v12 })
		end)
	end

	local function selectOutfit(p: number?)
		v6(p)

		if
			not FFlagAvatarSwitcherUseAvatarInventoryEndpoint
			and p ~= nil
			and getSelectedOutfitDetails(false) == nil
		then
			fetchOutfitDetails(p)
		end
	end

	local v12 = nil
	local v13 = false
	local function fetchNextOutfitsPage_DEPRECATED()
		if v13 or signal3(false) then
			return
		end

		v13 = true

		if v12 then
			if v12.IsFinished then
				return
			end

			local success, result = pcall(function()
				v12:AdvanceToNextPageAsync()
			end)

			if not success then
				warn("Avatar Switcher: failed to fetch next page of user outfits.", result)
				v5(true)
			end
		else
			local success, result = pcall(function()
				return AvatarEditorService:GetOutfitsAsync(Enum.OutfitSource.Created, Enum.OutfitType.Avatar)
			end)

			if success then
				v12 = result
			else
				warn("Avatar Switcher: failed to fetch first page of user outfits.", result)
				v5(true)
			end
		end

		if v12 then
			local currentPage = v12:GetCurrentPage()
			v3(function(p)
				local clone = table.clone(p)

				for _, v14 in currentPage do
					table.insert(clone, { id = v14.Id, name = v14.Name })
				end

				return clone
			end)

			if v12.IsFinished then
				v5(true)
			end
		end

		v13 = false
	end

	local nextPageToken = nil
	local function fetchNextOutfitsPage()
		if v13 or signal3(false) then
			return
		end

		v13 = true

		local v14 = v .. Url:makeQueryString({
			pageToken = nextPageToken,
			pageLimit = 25,
			sortOption = "recentAdded",
			["itemCategories[0].itemType"] = "outfit",
			["itemCategories[0].itemSubType"] = 3,
			includeUnavailableItems = FFlagAXInventoryIncludeUnavailableItems and true or nil
		})

		local success, result = pcall(function()
			return HttpService:JSONDecode((HttpRbxApiService:GetAsyncFullUrl(v14)))
		end)

		if success then
			if result.nextPageToken then
				nextPageToken = result.nextPageToken
			else
				v5(true)
			end

			local avatarInventoryItems = result.avatarInventoryItems or {}

			local v15 = signal8(false)
			local v16 = {}
			local v17 = {}

			for _, avatarInventoryItem in avatarInventoryItems do
				if avatarInventoryItem.availabilityStatus == InventoryItemAvailability.PartiallyAvailableWithUnavailableSubitems then
					continue
				end

				local rigType

				if avatarInventoryItem.outfitDetail and avatarInventoryItem.outfitDetail.playerAvatarType == "R6" then
					rigType = Enum.HumanoidRigType.R6
				else
					rigType = Enum.HumanoidRigType.R15
				end

				local hasWarning

				if v15 == Enum.HumanoidRigType.R6 then
					hasWarning = rigType == Enum.HumanoidRigType.R15
				else
					hasWarning = false
				end

				local v18

				if FFlagAvatarSwitcherExpiredItemsWarning then
					v18 = avatarInventoryItem.availabilityStatus == InventoryItemAvailability.PartiallyAvailableWithExpiredSubitems
				end

				local ids

				if FFlagAvatarSwitcherAccurateAvatarWarning then
					ids = {}

					if avatarInventoryItem.outfitDetail and avatarInventoryItem.outfitDetail.assets then
						for _, asset in avatarInventoryItem.outfitDetail.assets do
							table.insert(ids, asset.id)
						end
					end
				end

				local v19 = {
					id = avatarInventoryItem.itemId,
					name = avatarInventoryItem.itemName,
					hasWarning = 0
				}

				if FFlagAvatarSwitcherExpiredItemsWarning then
					hasWarning = hasWarning or v18
				end

				v19.hasWarning = hasWarning
				table.insert(v16, v19)

				local itemId = avatarInventoryItem.itemId
				local v20 = {
					id = avatarInventoryItem.itemId,
					name = avatarInventoryItem.itemName,
					rigType = rigType,
					availabilityStatus = 0,
					assetIds = 0
				}
				local availabilityStatus

				if FFlagAvatarSwitcherExpiredItemsWarning then
					availabilityStatus = avatarInventoryItem.availabilityStatus
				end

				v20.availabilityStatus = availabilityStatus

				if not FFlagAvatarSwitcherAccurateAvatarWarning then
					ids = nil
				end

				v20.assetIds = ids
				v17[itemId] = v20
			end

			v3(function(p)
				return Cryo.List.join(p, v16)
			end)

			v4(function(p)
				return Cryo.Dictionary.join(p, v17)
			end)

			v13 = false
		else
			warn("Avatar Switcher: failed to fetch user outfits.", result)

			if FFlagAvatarSwitcherCounters then
				sendAXCounterV2(Constants.Counters.OutfitFetchFailed)
			end

			v5(true)
			v13 = false
		end
	end

	local function clearPendingAvatarName() -- 1 equivalent call inferred from this helper
		v11(nil)
	end

	if Players.LocalPlayer then
		Players.LocalPlayer.CharacterAdded:Connect(function()
			clearPendingAvatarName() -- inferred equivalent call
		end)
	end

	local avatarSwitcherStore = {
		getOutfits = signal,
		getLastPageReached = signal3,
		getSelectedOutfitId = signal4,
		getSelectedOutfitDetails = getSelectedOutfitDetails,
		getRespawnPromptShown = signal5,
		getIsSwitching = signal6,
		getIsEmpty = getIsEmpty,
		getExperienceAvatarSupportType = signal7,
		getExperienceAvatarType = signal8,
		getPendingAvatarName = signal9,
		toggleRespawnPrompt = toggleRespawnPrompt,
		selectOutfit = selectOutfit,
		fetchNextOutfitsPage = nil,
		switchAvatar = nil,
		fetchExperienceAvatarSupportType = nil,
		clearPendingAvatarName = nil
	}

	if FFlagAvatarSwitcherUseAvatarInventoryEndpoint then
		fetchNextOutfitsPage_DEPRECATED = fetchNextOutfitsPage
	end

	avatarSwitcherStore.fetchNextOutfitsPage = fetchNextOutfitsPage_DEPRECATED

	function avatarSwitcherStore.switchAvatar()
		local v14 = getSelectedOutfitDetails(false)

		if not v14 then
			return
		end

		v8(true)

		if FFlagAvatarSwitcherCounters then
			sendAXCounterV2(Constants.Counters.SwitchAvatar)
		end

		if defineFastFlag then
			local success, result = pcall(function()
				applyOutfit(v14.id, v14.rigType)
			end)

			if not success then
				sendAXCounterV2(Constants.Counters.ApplyOutfitFailed, {
					errorMessage = tostring(result)
				})
			end
		else
			applyOutfit(v14.id, v14.rigType)
		end

		v11(v14.name)
		v8(false)
	end

	function avatarSwitcherStore.fetchExperienceAvatarSupportType()
		local success, result = pcall(function()
			return HttpService:JSONDecode((HttpRbxApiService:GetAsyncFullUrl(v2)))
		end)

		if success then
			local experienceAvatarSupportType = result.experienceAvatarSupportType
			local v14

			if experienceAvatarSupportType == 0 then
				v14 = ExperienceAvatarSupportType.NoSupport
			elseif experienceAvatarSupportType == 2 then
				v14 = ExperienceAvatarSupportType.FullSupport
			else
				v14 = ExperienceAvatarSupportType.UnknownSupport
			end

			v9(v14)

			local experienceAvatarType = result.experienceAvatarType
			local v15

			if experienceAvatarType == 1 then
				v15 = Enum.HumanoidRigType.R6
			elseif experienceAvatarType == 3 then
				v15 = Enum.HumanoidRigType.R15
			end

			v10(v15)

			if FFlagAvatarSwitcherCounters then
				sendAXCounterV2(Constants.Counters.AvatarSupportTypeFetched, {
					supportType = tostring(experienceAvatarSupportType),
					avatarType = tostring(experienceAvatarType)
				})
			end
		else
			v9(ExperienceAvatarSupportType.UnknownSupport)
			v10(nil)

			if FFlagAvatarSwitcherCounters then
				sendAXCounterV2(Constants.Counters.AvatarSupportTypeFetchFailed)
			end
		end
	end
	avatarSwitcherStore.clearPendingAvatarName = clearPendingAvatarName
	return avatarSwitcherStore
end

return createAvatarSwitcherStore
