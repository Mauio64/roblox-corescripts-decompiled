require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/UnifiedLogging")
local sduiErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem").SduiErrors

local function getImpressionsTag(p2, p3, data, p4)
	local collectionId = nil
	local collectionComponentType = nil

	if p3 then
		collectionId = p3.collectionId
		collectionComponentType = p3.collectionComponentType

		if not collectionComponentType then
			data.dependencies.logger.reportError(
				sduiErrors.SduiErrorType.GetImpressionsTagMissingCollectionComponentType,
				{ name = p4 },
				data.appPage
			)
		end

		if not collectionId then
			data.dependencies.logger.reportError(
				sduiErrors.SduiErrorType.GetImpressionsTagMissingCollectionId,
				{ name = p4 },
				data.appPage
			)
		end
	else
		data.dependencies.logger.reportError(
			sduiErrors.SduiErrorType.GetImpressionsTagMissingCollectionData,
			{ name = p4 },
			data.appPage
		)
	end

	return `{p4}_{collectionComponentType}_{data.routeName or data.appPage}_{collectionId or -1}_{p2}`
end

return getImpressionsTag
