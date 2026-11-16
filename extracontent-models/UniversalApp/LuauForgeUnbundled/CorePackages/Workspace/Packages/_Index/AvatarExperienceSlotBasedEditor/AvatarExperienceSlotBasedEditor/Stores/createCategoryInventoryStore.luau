local HttpService = game:GetService("HttpService")

local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/Signals")
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/Loggers").mutedError

local InventoryItemType = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Enums/InventoryItemType")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Enums/InventoryItemAvailability")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Types")

local fFlagAXInventoryDurablesSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/AvatarExperienceFlags").FFlagAXInventoryDurablesSupport
local fFlagAXBackgroundGeneration = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/AvatarExperienceFlags").FFlagAXBackgroundGeneration
local fFlagAXRefetchInventoryOnUpdate = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/AvatarExperienceFlags").FFlagAXRefetchInventoryOnUpdate

local function createCategoryInventoryStore()
	local categoryInventoryStore = nil

	local signal, v5 = Signals.createSignal(nil)
	local signal2, v6 = Signals.createSignal(false)
	local signal3, v7 = Signals.createSignal(HttpService:GenerateGUID(true))
	local v8 = if fFlagAXRefetchInventoryOnUpdate then false else nil
	categoryInventoryStore = {
		getItems = signal,
		getHasReachedLastPage = signal2,
		getSearchUuid = signal3,
		nextPageCursor = nil,
		isRefreshPending = function(): boolean
			return v8 == true
		end,
		startNewSearch = function()
			categoryInventoryStore.nextPageCursor = nil

			if fFlagAXRefetchInventoryOnUpdate then
				v8 = false
			end

			v5(nil)
			v6(false)
			v7(HttpService:GenerateGUID(true))
		end,
		startRefresh = function()
			categoryInventoryStore.nextPageCursor = nil
			v8 = true
			v6(false)
			v7(HttpService:GenerateGUID(true))
		end,
		removeItems = function(items)
			local v9 = signal(false)

			if not v9 then
				return
			end

			local set = {}

			for k, item in items do
				set[item] = true
			end

			local v10 = {}

			for k, v11 in v9 do
				if not set[v11.itemId] then
					v10[#v10 + 1] = v11
				end
			end

			if #v10 == #v9 then
				return
			end

			if not (#v10 > 0) then
				v10 = nil
			end

			v5(v10)
		end,
		addResultsPage = function(p2, p3)
			if fFlagAXRefetchInventoryOnUpdate and p3 ~= nil and p3 ~= signal3(false) then
				return
			end

			local v9 = fFlagAXRefetchInventoryOnUpdate and v8 == true

			if fFlagAXRefetchInventoryOnUpdate then
				v8 = false
			end

			local v10 = if not v9 then signal(false) else nil
			local v11 = not v10 and {} or table.clone(v10)

			for k, avatarInventoryItem in p2.avatarInventoryItems do
				local v12

				if avatarInventoryItem.itemCategory.itemType == Enum.AvatarItemType.Asset.Value then
					v12 = InventoryItemType.Asset
				elseif avatarInventoryItem.itemCategory.itemType == Enum.AvatarItemType.Bundle.Value then
					v12 = InventoryItemType.Outfit
				else
					v12 = InventoryItemType.Unknown
				end

				if v12 == InventoryItemType.Unknown then
					mutedError(`Unknown item type received from user inventory endpoint: {avatarInventoryItem.itemCategory.itemType}`)
				else
					local v13 = {
						itemId = tostring(avatarInventoryItem.itemId),
						inventoryItemType = v12,
						availabilityStatus = avatarInventoryItem.availabilityStatus,
						expirationTime = 0,
						isPlusExclusive = 0
					}
					local v14 = if fFlagAXInventoryDurablesSupport then avatarInventoryItem.expirationTime else nil
					v13.expirationTime = v14
					local v15 = if fFlagAXBackgroundGeneration then avatarInventoryItem.isPlusExclusive else nil
					v13.isPlusExclusive = v15
					table.insert(v11, v13)
				end
			end

			v5(v11)

			local nextPageToken = p2.nextPageToken
			categoryInventoryStore.nextPageCursor = nextPageToken

			if nextPageToken == nil or nextPageToken == "" then
				v6(true)
			end
		end
	}

	return categoryInventoryStore
end

return createCategoryInventoryStore
