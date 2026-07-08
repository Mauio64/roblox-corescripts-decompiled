local AvatarEditorService = game:GetService("AvatarEditorService")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local AvatarSwitcher = script:FindFirstAncestor("AvatarSwitcher")
local AvatarSwitcherParent = AvatarSwitcher.Parent
local Signals = require(AvatarSwitcherParent.Signals)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local Url = require(AvatarSwitcherParent.Http).Url
local Cryo = require(AvatarSwitcherParent.Cryo)
local InventoryItemAvailability = require(AvatarSwitcherParent.AvatarExperienceSlotBasedEditor).Enums.InventoryItemAvailability
local sendAXCounterV2 = require(AvatarSwitcherParent.AvatarExperienceAnalytics).sendAXCounterV2
local applyOutfit = require(AvatarSwitcher.Utils.applyOutfit)
local ExperienceAvatarSupportType = require(AvatarSwitcher.Enums.ExperienceAvatarSupportType)
local Constants = require(AvatarSwitcher.Constants)
local FFlagAvatarSwitcherUseAvatarInventoryEndpoint = require(AvatarSwitcherParent.AvatarExperienceFlags).FFlagAvatarSwitcherUseAvatarInventoryEndpoint
local FFlagAvatarSwitcherAccurateAvatarWarning = require(AvatarSwitcherParent.AvatarExperienceFlags).FFlagAvatarSwitcherAccurateAvatarWarning
local FFlagAvatarSwitcherCounters = require(AvatarSwitcherParent.AvatarExperienceFlags).FFlagAvatarSwitcherCounters
local FFlagAvatarSwitcherExpiredItemsWarning = require(AvatarSwitcherParent.AvatarExperienceFlags).FFlagAvatarSwitcherExpiredItemsWarning
local FFlagAXInventoryIncludeUnavailableItems = require(AvatarSwitcherParent.AvatarExperienceFlags).FFlagAXInventoryIncludeUnavailableItems
local v22 = game:DefineFastFlag("AvatarSwitcherPcallApplyOutfit", false)

require(AvatarSwitcher.types)

local v23 = Url.AVATAR_URL .. "v1/avatar-inventory?"
local v24 = Url.AVATAR_URL .. "v2/avatar/experience/get-experience-avatar-support"

local function createAvatarSwitcherStore() -- line: 42
	-- upvalues: createSignal (copy), createComputed (copy), AvatarEditorService (copy), FFlagAvatarSwitcherAccurateAvatarWarning (copy), Cryo (copy), FFlagAvatarSwitcherUseAvatarInventoryEndpoint (copy), FFlagAXInventoryIncludeUnavailableItems (copy), v23 (copy), Url (copy), HttpRbxApiService (copy), HttpService (copy), FFlagAvatarSwitcherCounters (copy), sendAXCounterV2 (copy), Constants (copy), InventoryItemAvailability (copy), FFlagAvatarSwitcherExpiredItemsWarning (copy), v22 (copy), applyOutfit (copy), v24 (copy), ExperienceAvatarSupportType (copy), Players (copy)
	local v26, v27 = createSignal({})
	local v28, v29 = createSignal({})
	local v30, v31 = createSignal(false)
	local v32, v33 = createSignal(nil)
	local v34, v35 = createSignal(false)
	local v36, v37 = createSignal(false)
	local v38, v39 = createSignal(nil)
	local v40, v41 = createSignal(nil)
	local v42, v43 = createSignal(nil)
	local v44 = createComputed(function(p1) -- line: 54
		-- upvalues: v30 (copy), v26 (copy)
		return v30(p1) and #v26(p1) == 0
	end)
	local v45 = createComputed(function(p2) -- line: 58
		-- upvalues: v32 (copy), v28 (copy)
		local v54 = v32(p2)

		if v54 == nil then
			return nil
		end

		return v28(p2)[v54]
	end)

	local function fetchOutfitDetails(n1: number) -- line: 71
		-- upvalues: AvatarEditorService (copy), FFlagAvatarSwitcherAccurateAvatarWarning (copy), v29 (copy), Cryo (copy)
		local ok, result = pcall(function() -- line: 72
			-- upvalues: AvatarEditorService (copy), n1 (copy)
			if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
				return AvatarEditorService:GetOutfitDetailsAsync(n1)
			end

			return AvatarEditorService:GetOutfitDetails(n1)
		end)

		if ok then
			local t1 = nil

			if FFlagAvatarSwitcherAccurateAvatarWarning then
				t1 = {}

				if result.Assets then
					for _, v61 in result.Assets do
						table.insert(t1, v61.Id)
					end
				end
			end

			local t2 = {
				id = result.Id,
				name = result.Name,
				rigType = if result.PlayerAvatarType ~= "R6" then Enum.HumanoidRigType.R15 else Enum.HumanoidRigType.R6,
				assetIds = if not FFlagAvatarSwitcherAccurateAvatarWarning then nil else t1
			}

			v29(function(p3) -- line: 96
				-- upvalues: Cryo (copy), n1 (copy), t2 (copy)
				return Cryo.Dictionary.join(p3, {
					[n1] = t2
				})
			end)

			return
		end

		warn(`Avatar Switcher: failed to fetch outfit details for outfitId { n1 }.`, result)
	end

	local u47 = nil
	local u48 = false

	local function fetchNextOutfitsPage_DEPRECATED() -- line: 122
		-- upvalues: u48 (ref), v30 (copy), u47 (ref), v31 (copy), AvatarEditorService (copy), v27 (copy)
		if u48 or v30(false) then
			return
		end

		u48 = true

		if u47 then
			if u47.IsFinished then
				return
			end

			local ok, result = pcall(function() -- line: 132
				-- upvalues: u47 (ref)
				u47:AdvanceToNextPageAsync()
			end)

			if not ok then
				warn("Avatar Switcher: failed to fetch next page of user outfits.", result)
				v31(true)
			end
		else
			local ok, result = pcall(function() -- line: 140
				-- upvalues: AvatarEditorService (copy)
				if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
					return AvatarEditorService:GetOutfitsAsync(Enum.OutfitSource.Created, Enum.OutfitType.Avatar)
				end

				return AvatarEditorService:GetOutfits(Enum.OutfitSource.Created, Enum.OutfitType.Avatar)
			end)

			if ok then
				u47 = result
			else
				warn("Avatar Switcher: failed to fetch first page of user outfits.", result)
				v31(true)
			end
		end

		if u47 then
			local CurrentPage = u47:GetCurrentPage()

			v27(function(p4) -- line: 157
				-- upvalues: CurrentPage (copy)
				local v96 = table.clone(p4)

				for _, v98 in CurrentPage do
					table.insert(v96, {
						id = v98.Id,
						name = v98.Name
					})
				end

				return v96
			end)

			if u47.IsFinished then
				v31(true)
			end
		end

		u48 = false
	end

	local nextPageToken = nil

	local function fetchNextOutfitsPage() -- line: 176
		-- upvalues: u48 (ref), v30 (copy), nextPageToken (ref), FFlagAXInventoryIncludeUnavailableItems (copy), v23 (copy), Url (copy), HttpRbxApiService (copy), HttpService (copy), FFlagAvatarSwitcherCounters (copy), sendAXCounterV2 (copy), Constants (copy), v31 (copy), v40 (copy), InventoryItemAvailability (copy), FFlagAvatarSwitcherExpiredItemsWarning (copy), FFlagAvatarSwitcherAccurateAvatarWarning (copy), v27 (copy), Cryo (copy), v29 (copy)
		if u48 or v30(false) then
			return
		end

		u48 = true

		local t3 = {
			pageToken = nextPageToken,
			pageLimit = 25,
			sortOption = "recentAdded",
			["itemCategories[0].itemType"] = "outfit",
			["itemCategories[0].itemSubType"] = 3,
			includeUnavailableItems = not not FFlagAXInventoryIncludeUnavailableItems or nil
		}
		local v70 = v23 .. Url:makeQueryString(t3)
		local ok, result = pcall(function() -- line: 192
			-- upvalues: HttpRbxApiService (copy), v70 (copy), HttpService (copy)
			local AsyncFullUrl = HttpRbxApiService:GetAsyncFullUrl(v70)

			return HttpService:JSONDecode(AsyncFullUrl)
		end)

		if not ok then
			warn("Avatar Switcher: failed to fetch user outfits.", result)

			if FFlagAvatarSwitcherCounters then
				sendAXCounterV2(Constants.Counters.OutfitFetchFailed)
			end

			v31(true)
			u48 = false

			return
		end

		if result.nextPageToken then
			nextPageToken = result.nextPageToken
		else
			v31(true)
		end

		local v73 = result.avatarInventoryItems or {}
		local t4 = {}
		local t5 = {}
		local v76 = v40(false)

		for _, v78 in v73 do
			if v78.availabilityStatus ~= InventoryItemAvailability.PartiallyAvailableWithUnavailableSubitems then
				local v79 = if not v78.outfitDetail or v78.outfitDetail.playerAvatarType ~= "R6" then Enum.HumanoidRigType.R15 else Enum.HumanoidRigType.R6
				local v80 = v76 == Enum.HumanoidRigType.R6 and v79 == Enum.HumanoidRigType.R15
				local v81 = nil

				if FFlagAvatarSwitcherExpiredItemsWarning then
					v81 = v78.availabilityStatus == InventoryItemAvailability.PartiallyAvailableWithExpiredSubitems
				end

				local t6 = nil

				if FFlagAvatarSwitcherAccurateAvatarWarning then
					t6 = {}

					if v78.outfitDetail and v78.outfitDetail.assets then
						for _, v84 in v78.outfitDetail.assets do
							table.insert(t6, v84.id)
						end
					end
				end

				table.insert(t4, {
					id = v78.itemId,
					name = v78.itemName,
					hasWarning = if not FFlagAvatarSwitcherExpiredItemsWarning then v80 else v80 or v81
				})
				t5[v78.itemId] = {
					id = v78.itemId,
					name = v78.itemName,
					rigType = v79,
					availabilityStatus = if not FFlagAvatarSwitcherExpiredItemsWarning then nil else v78.availabilityStatus,
					assetIds = if not FFlagAvatarSwitcherAccurateAvatarWarning then nil else t6
				}
			end
		end

		v27(function(p5) -- line: 262
			-- upvalues: Cryo (copy), t4 (copy)
			return Cryo.List.join(p5, t4)
		end)
		v29(function(p6) -- line: 265
			-- upvalues: Cryo (copy), t5 (copy)
			return Cryo.Dictionary.join(p6, t5)
		end)
		u48 = false
	end

	if Players.LocalPlayer then
		Players.LocalPlayer.CharacterAdded:Connect(function() -- line: 340
			-- upvalues: v43 (copy)
			v43(nil)
		end)
	end

	return {
		getOutfits = v26,
		getLastPageReached = v30,
		getSelectedOutfitId = v32,
		getSelectedOutfitDetails = v45,
		getRespawnPromptShown = v34,
		getIsSwitching = v36,
		getIsEmpty = v44,
		getExperienceAvatarSupportType = v38,
		getExperienceAvatarType = v40,
		getPendingAvatarName = v42,
		toggleRespawnPrompt = function(b1: boolean) -- line: 67
			-- upvalues: v35 (copy)
			v35(b1)
		end,
		selectOutfit = function(n2: number?) -- line: 105
			-- upvalues: v33 (copy), FFlagAvatarSwitcherUseAvatarInventoryEndpoint (copy), v45 (copy), fetchOutfitDetails (copy)
			v33(n2)

			if not FFlagAvatarSwitcherUseAvatarInventoryEndpoint and (n2 ~= nil and v45(false) == nil) then
				fetchOutfitDetails(n2)
			end
		end,
		fetchNextOutfitsPage = if not FFlagAvatarSwitcherUseAvatarInventoryEndpoint then fetchNextOutfitsPage_DEPRECATED else fetchNextOutfitsPage,
		switchAvatar = function() -- line: 273
			-- upvalues: v45 (copy), v37 (copy), FFlagAvatarSwitcherCounters (copy), sendAXCounterV2 (copy), Constants (copy), v22 (copy), applyOutfit (copy), v43 (copy)
			local v85 = v45(false)

			if not v85 then
				return
			end

			v37(true)

			if FFlagAvatarSwitcherCounters then
				sendAXCounterV2(Constants.Counters.SwitchAvatar)
			end

			if v22 then
				local ok, result = pcall(function() -- line: 285
					-- upvalues: applyOutfit (copy), v85 (copy)
					applyOutfit(v85.id, v85.rigType)
				end)

				if not ok then
					sendAXCounterV2(Constants.Counters.ApplyOutfitFailed, {
						errorMessage = tostring(result)
					})
				end
			else
				applyOutfit(v85.id, v85.rigType)
			end

			v43(v85.name)
			v37(false)
		end,
		fetchExperienceAvatarSupportType = function() -- line: 299
			-- upvalues: HttpRbxApiService (copy), v24 (copy), HttpService (copy), ExperienceAvatarSupportType (copy), v39 (copy), v41 (copy), FFlagAvatarSwitcherCounters (copy), sendAXCounterV2 (copy), Constants (copy)
			local ok, result = pcall(function() -- line: 300
				-- upvalues: HttpRbxApiService (copy), v24 (copy), HttpService (copy)
				local AsyncFullUrl = HttpRbxApiService:GetAsyncFullUrl(v24)

				return HttpService:JSONDecode(AsyncFullUrl)
			end)

			if ok then
				local experienceAvatarSupportType = result.experienceAvatarSupportType
				local v91 = if experienceAvatarSupportType ~= 0 then if experienceAvatarSupportType ~= 2 then ExperienceAvatarSupportType.UnknownSupport else ExperienceAvatarSupportType.FullSupport else ExperienceAvatarSupportType.NoSupport

				v39(v91)

				local experienceAvatarType = result.experienceAvatarType
				local v93 = if experienceAvatarType ~= 1 then if experienceAvatarType ~= 3 then nil else Enum.HumanoidRigType.R15 else Enum.HumanoidRigType.R6

				v41(v93)

				if FFlagAvatarSwitcherCounters then
					sendAXCounterV2(Constants.Counters.AvatarSupportTypeFetched, {
						supportType = tostring(experienceAvatarSupportType),
						avatarType = tostring(experienceAvatarType)
					})

					return
				end
			else
				v39(ExperienceAvatarSupportType.UnknownSupport)
				v41(nil)

				if FFlagAvatarSwitcherCounters then
					sendAXCounterV2(Constants.Counters.AvatarSupportTypeFetchFailed)
				end
			end
		end,
		clearPendingAvatarName = function() -- line: 335
			-- upvalues: v43 (copy)
			v43(nil)
		end
	}
end

return createAvatarSwitcherStore
