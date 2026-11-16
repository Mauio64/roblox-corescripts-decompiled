local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

require(parent.UnifiedLogging)
local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrors = SduiCoreSystem.SduiErrors

local function getImpressionsTag(p: number, p2, data, name: string?)
	local collectionId = nil
	local collectionComponentType = nil

	if p2 then
		collectionId = p2.collectionId
		collectionComponentType = p2.collectionComponentType

		if not collectionComponentType then
			data.dependencies.logger.reportError(
				SduiErrors.SduiErrorType.GetImpressionsTagMissingCollectionComponentType,
				{ name = name },
				data.appPage
			)
		end

		if not collectionId then
			data.dependencies.logger.reportError(
				SduiErrors.SduiErrorType.GetImpressionsTagMissingCollectionId,
				{ name = name },
				data.appPage
			)
		end
	else
		data.dependencies.logger.reportError(
			SduiErrors.SduiErrorType.GetImpressionsTagMissingCollectionData,
			{ name = name },
			data.appPage
		)
	end

	return `{name}_{collectionComponentType}_{data.routeName or data.appPage}_{collectionId or -1}_{p}`
end

return getImpressionsTag
