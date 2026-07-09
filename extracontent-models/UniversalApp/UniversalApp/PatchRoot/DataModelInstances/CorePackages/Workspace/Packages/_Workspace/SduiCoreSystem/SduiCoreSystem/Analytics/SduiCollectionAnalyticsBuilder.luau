local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent
local Cryo = require(SduiCoreSystemParent.Cryo)
local UnifiedLogging = require(SduiCoreSystemParent.UnifiedLogging)

require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.SduiComponentType)
require(SduiCoreSystem.SduiConfigTypes)

local SduiErrors = require(SduiCoreSystem.SduiErrors)
local validateInterface = require(SduiCoreSystem.validateInterface)
local FFlagSduiExperienceDetailsSupport = require(SduiCoreSystemParent.SharedFlags).FFlagSduiExperienceDetailsSupport
local t1 = {}
local t2 = {
	index = -1,
	id = "unknown",
	itemComponentType = "unknown"
}
local t3 = {
	collectionId = -1,
	contentType = "unknown",
	itemsPerRow = -1,
	collectionPosition = -1,
	totalNumberOfItems = -1,
	startRowNumber = -1,
	collectionComponentType = "unknown",
	refId = if not FFlagSduiExperienceDetailsSupport then nil else "unknown"
}

return {
	buildAndValidateCollectionAnalyticsData = function(p1, t4: {[any]: any}?, t5: {[any]: any}?, p2, n1: number, n2: number, _: number?, s1: string, n4: number?) -- line: 41
		-- upvalues: Cryo (copy), t1 (copy), UnifiedLogging (copy), validateInterface (copy), SduiErrors (copy), t3 (copy)
		local v20 = Cryo.Dictionary.join(t4 or t1, t5 or t1)

		v20.collectionId = tonumber(v20.collectionId) or v20.collectionId
		v20.collectionPosition = tonumber(v20.collectionPosition)
		v20.itemsPerRow = n1
		v20.startRowNumber = n4
		v20.totalNumberOfItems = n2
		v20.collectionComponentType = p2

		local CollectionAnalyticsDataInterface = UnifiedLogging.SduiAnalyticsTypes.CollectionAnalyticsDataInterface
		local v22, v23 = validateInterface(v20, CollectionAnalyticsDataInterface, true)

		if not v22 then
			p1.dependencies.logger.reportError(SduiErrors.SduiErrorType.InvalidCollectionAnalyticsData, {
				componentType = p2,
				name = s1,
				message = v23
			}, p1.appPage)
			v20 = Cryo.Dictionary.join(t3, v20)
		end

		return v20
	end,
	buildAndValidateItemAnalyticsData = function(p3, t6: {[any]: any}?, t7: {[any]: any}?, t8: {[any]: any}?, s2: string, p4: ((...any) -> ...any)?) -- line: 74
		-- upvalues: Cryo (copy), t1 (copy), UnifiedLogging (copy), validateInterface (copy), SduiErrors (copy), t2 (copy)
		local v30 = Cryo.Dictionary.join(t7 or t1, t6 or t1, t8 or t1)
		local ItemAnalyticsDataInterface = UnifiedLogging.SduiAnalyticsTypes.ItemAnalyticsDataInterface
		local v32, v33 = validateInterface(v30, ItemAnalyticsDataInterface, true)

		if not v32 then
			if p4 then
				p4(v33)
			else
				p3.dependencies.logger.reportError(SduiErrors.SduiErrorType.InvalidItemAnalyticsData, {
					name = s2,
					message = v33
				}, p3.appPage)
			end

			v30 = Cryo.Dictionary.join(t2, v30)
		end

		return v30
	end,
	DUMMY_COLLECTION_DATA = t3,
	DUMMY_ITEM_DATA = t2
}
