local HttpService = game:GetService("HttpService")
local AvatarExperienceSlotBasedEditor = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor")
local AvatarExperienceSlotBasedEditorParent = AvatarExperienceSlotBasedEditor.Parent
local Signals = require(AvatarExperienceSlotBasedEditorParent.Signals)
local mutedError = require(AvatarExperienceSlotBasedEditorParent.Loggers).mutedError
local InventoryItemType = require(AvatarExperienceSlotBasedEditor.Enums.InventoryItemType)

require(AvatarExperienceSlotBasedEditor.Enums.InventoryItemAvailability)
require(script.Parent.Parent.Types)

local FFlagAXModeratedItemsFlow = require(AvatarExperienceSlotBasedEditorParent.AvatarExperienceFlags).FFlagAXModeratedItemsFlow
local FFlagAXInventoryDurablesSupport = require(AvatarExperienceSlotBasedEditorParent.AvatarExperienceFlags).FFlagAXInventoryDurablesSupport
local FFlagAXEnableModeratedItemsFlowForDurables = require(AvatarExperienceSlotBasedEditorParent.AvatarExperienceFlags).FFlagAXEnableModeratedItemsFlowForDurables

local function createCategoryInventoryStore() -- line: 46
	-- upvalues: Signals (copy), HttpService (copy), InventoryItemType (copy), mutedError (copy), FFlagAXModeratedItemsFlow (copy), FFlagAXEnableModeratedItemsFlowForDurables (copy), FFlagAXInventoryDurablesSupport (copy)
	local t1 = nil
	local v12, v13 = Signals.createSignal(nil)
	local v14, v15 = Signals.createSignal(false)
	local v16, v17 = Signals.createSignal(HttpService:GenerateGUID(true))

	t1 = {
		nextPageCursor = nil,
		getItems = v12,
		getHasReachedLastPage = v14,
		getSearchUuid = v16,
		startNewSearch = function() -- line: 55
			-- upvalues: t1 (ref), v13 (copy), v15 (copy), v17 (copy), HttpService (copy)
			t1.nextPageCursor = nil
			v13(nil)
			v15(false)
			v17(HttpService:GenerateGUID(true))
		end,
		addResultsPage = function(p1) -- line: 63
			-- upvalues: v12 (copy), InventoryItemType (copy), mutedError (copy), FFlagAXModeratedItemsFlow (copy), FFlagAXEnableModeratedItemsFlowForDurables (copy), FFlagAXInventoryDurablesSupport (copy), v13 (copy), t1 (ref), v15 (copy)
			local v19 = v12(false)
			local v20 = if not v19 then {} else table.clone(v19)

			for _, v22 in p1.avatarInventoryItems do
				local v23 = if v22.itemCategory.itemType ~= Enum.AvatarItemType.Asset.Value then if v22.itemCategory.itemType ~= Enum.AvatarItemType.Bundle.Value then InventoryItemType.Unknown else InventoryItemType.Outfit else InventoryItemType.Asset

				if v23 == InventoryItemType.Unknown then
					mutedError(`Unknown item type received from user inventory endpoint: { v22.itemCategory.itemType }`)
				else
					table.insert(v20, {
						itemId = tostring(v22.itemId),
						inventoryItemType = v23,
						availabilityStatus = if not FFlagAXModeratedItemsFlow and not FFlagAXEnableModeratedItemsFlowForDurables then nil else v22.availabilityStatus,
						expirationTime = if not FFlagAXInventoryDurablesSupport then nil else v22.expirationTime
					})
				end
			end

			v13(v20)

			local nextPageToken = p1.nextPageToken

			t1.nextPageCursor = nextPageToken

			if nextPageToken == nil or nextPageToken == "" then
				v15(true)
			end
		end
	}

	return t1
end

return createCategoryInventoryStore
