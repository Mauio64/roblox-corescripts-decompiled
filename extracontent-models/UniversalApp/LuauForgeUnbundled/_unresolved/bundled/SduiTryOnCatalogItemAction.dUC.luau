local module = require("@luauforge/bundled/dTF")
local itemDetailsSduiHost = module.ItemDetailsSduiHost
local getItemDetailsEntryContext = module.getItemDetailsEntryContext
local module2 = require("@luauforge/bundled/dTs")
local avatarScreen = module2.Enums.AvatarScreen
local navigateDownToAvatarScreen = module2.Thunks.NavigateDownToAvatarScreen
local reportBackgroundUserActionCounter = require("@luauforge/bundled/dTw").reportBackgroundUserActionCounter

local fFlagAXBackgroundsEquipTryOnCounters = require("@luauforge/bundled/dTp").FFlagAXBackgroundsEquipTryOnCounters

local sduiActionType = require("@luauforge/bundled/dTq").SduiActionType

local module3 = require("@luauforge/bundled/dUi")

local tryOnCatalogItem = sduiActionType.TryOnCatalogItem

local function SduiTryOnCatalogItemAction(p2, p3, p4, p5)
	local actionParams = module3.readActionParams(tryOnCatalogItem, p2, p4)

	if actionParams == nil then
		return
	end

	local catalogItem = module3.readCatalogItem(tryOnCatalogItem, actionParams, p4)

	if catalogItem == nil then
		return
	end

	local optionalId = module3.readOptionalId(actionParams.itemSubType)
	local v5

	if optionalId ~= nil then
		v5 = module3.getItemSubTypeId(optionalId, catalogItem.itemType)
	end

	if optionalId ~= nil and v5 == nil then
		module3.reportInvalidParams(
			tryOnCatalogItem,
			p4,
			`Unrecognized itemSubType: {optionalId}`,
			"itemSubType"
		)
	end

	local v6 = itemDetailsSduiHost.get(p4.configKey)
	local tryOnHandlers = if v6 then v6.tryOnHandlers else nil
	local getScreenNavigation = if v6 then v6.getScreenNavigation else nil
	local isInAvatarExperience = if v6 then v6.isInAvatarExperience else nil

	if tryOnHandlers == nil or getScreenNavigation == nil or isInAvatarExperience == nil then
		module3.reportFailedToExecute(
			tryOnCatalogItem,
			p4,
			"No Item Details page that offers this control is mounted for this configKey"
		)

		return
	end

	local inAvatarExperience = isInAvatarExperience()

	if getItemDetailsEntryContext(getScreenNavigation(), inAvatarExperience) == nil then
		module3.reportFailedToExecute(
			tryOnCatalogItem,
			p4,
			"The mounted Item Details page offers no Try On from where it was opened"
		)

		return
	end

	local itemId = catalogItem.itemId
	local itemType = catalogItem.itemType

	if v5 == nil and tryOnHandlers.getShownItemSubType ~= nil then
		v5 = tryOnHandlers.getShownItemSubType(itemId, itemType)
	end

	if fFlagAXBackgroundsEquipTryOnCounters then
		reportBackgroundUserActionCounter.reportIfAvatarBackgroundAsset("TryOn", itemType, v5)
	end

	if inAvatarExperience then
		tryOnHandlers.toggleTryOn({
			itemId = itemId,
			itemType = itemType,
			itemSubType = v5
		})
		tryOnHandlers.closeMatchingScreens({ avatarScreen.Checkout, avatarScreen.ItemDetails })
	else
		if v5 == nil then
			tryOnHandlers.toggleTryOn({
				itemId = itemId,
				itemType = itemType,
				itemSubType = nil
			})
		end

		local dispatch = p4.dependencies.dispatch
		local tryOnItem = avatarScreen.TryOnItem
		local v8 = itemType .. itemId

		if v5 ~= nil then
			optionalId = nil
		end

		dispatch(navigateDownToAvatarScreen(tryOnItem, v8, {
			itemId = itemId,
			itemType = itemType,
			itemSubType = v5,
			itemSubTypeName = optionalId,
			mountAsFullView = false,
			mountAnimation = false,
			itemDetailsPeekViewRefs = {}
		}))
	end
end

return SduiTryOnCatalogItemAction
