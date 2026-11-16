local HttpService = game:GetService("HttpService")
local AvatarExperienceSlotBasedEditor = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor")
local parent = AvatarExperienceSlotBasedEditor.Parent

local Signals = require(parent.Signals)
local Loggers = require(parent.Loggers)
local mutedError = Loggers.mutedError

local InventoryItemType = require(AvatarExperienceSlotBasedEditor.Enums.InventoryItemType)
require(AvatarExperienceSlotBasedEditor.Enums.InventoryItemAvailability)
require(script.Parent.Parent.Types)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local AvatarExperienceFlags2 = require(parent.AvatarExperienceFlags)
local FFlagAXBackgroundGeneration = AvatarExperienceFlags2.FFlagAXBackgroundGeneration
local AvatarExperienceFlags3 = require(parent.AvatarExperienceFlags)
local FFlagAXRefetchInventoryOnUpdate = AvatarExperienceFlags3.FFlagAXRefetchInventoryOnUpdate

local function createCategoryInventoryStore()
	local categoryInventoryStore = nil

	local signal, v = Signals.createSignal(nil)
	local signal2, v2 = Signals.createSignal(false)
	local signal3, v3 = Signals.createSignal(HttpService:GenerateGUID(true))
	local v4

	if FFlagAXRefetchInventoryOnUpdate then
		v4 = false
	else
		v4 = nil
	end

	categoryInventoryStore = {
		getItems = signal,
		getHasReachedLastPage = signal2,
		getSearchUuid = signal3,
		nextPageCursor = nil,
		isRefreshPending = function(): boolean
			return v4 == true
		end,
		startNewSearch = function()
			categoryInventoryStore.nextPageCursor = nil

			if FFlagAXRefetchInventoryOnUpdate then
				v4 = false
			end

			v(nil)
			v2(false)
			v3(HttpService:GenerateGUID(true))
		end,
		startRefresh = function()
			categoryInventoryStore.nextPageCursor = nil
			v4 = true
			v2(false)
			v3(HttpService:GenerateGUID(true))
		end,
		removeItems = function(items)
			local v5 = signal(false)

			if not v5 then
				return
			end

			local set = {}

			for _, item in items do
				set[item] = true
			end

			local v6 = {}

			for _, v7 in v5 do
				if not set[v7.itemId] then
					v6[#v6 + 1] = v7
				end
			end

			if #v6 == #v5 then
				return
			end

			if not (#v6 > 0) then
				v6 = nil
			end

			v(v6)
		end,
		addResultsPage = function(p, p2: string?)
			if FFlagAXRefetchInventoryOnUpdate and p2 ~= nil and p2 ~= signal3(false) then
				return
			end

			local v5 = FFlagAXRefetchInventoryOnUpdate and v4 == true

			if FFlagAXRefetchInventoryOnUpdate then
				v4 = false
			end

			local v6

			if not v5 then
				v6 = signal(false)
			end

			local v7 = not v6 and {} or table.clone(v6)

			for _, avatarInventoryItem in p.avatarInventoryItems do
				local inventoryItemType

				if avatarInventoryItem.itemCategory.itemType == Enum.AvatarItemType.Asset.Value then
					inventoryItemType = InventoryItemType.Asset
				elseif avatarInventoryItem.itemCategory.itemType == Enum.AvatarItemType.Bundle.Value then
					inventoryItemType = InventoryItemType.Outfit
				else
					inventoryItemType = InventoryItemType.Unknown
				end

				if inventoryItemType == InventoryItemType.Unknown then
					mutedError(`Unknown item type received from user inventory endpoint: {avatarInventoryItem.itemCategory.itemType}`)
				else
					local v8 = {
						itemId = tostring(avatarInventoryItem.itemId),
						inventoryItemType = inventoryItemType,
						availabilityStatus = avatarInventoryItem.availabilityStatus,
						expirationTime = 0,
						isPlusExclusive = 0
					}
					local expirationTime

					if FFlagAXInventoryDurablesSupport then
						expirationTime = avatarInventoryItem.expirationTime
					end

					v8.expirationTime = expirationTime
					local isPlusExclusive

					if FFlagAXBackgroundGeneration then
						isPlusExclusive = avatarInventoryItem.isPlusExclusive
					end

					v8.isPlusExclusive = isPlusExclusive
					table.insert(v7, v8)
				end
			end

			v(v7)

			local nextPageToken = p.nextPageToken
			categoryInventoryStore.nextPageCursor = nextPageToken

			if nextPageToken == nil or nextPageToken == "" then
				v2(true)
			end
		end
	}

	return categoryInventoryStore
end

return createCategoryInventoryStore
