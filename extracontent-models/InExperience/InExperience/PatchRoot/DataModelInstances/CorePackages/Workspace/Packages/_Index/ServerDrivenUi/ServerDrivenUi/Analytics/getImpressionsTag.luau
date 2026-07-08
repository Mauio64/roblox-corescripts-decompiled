local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent

require(Parent.UnifiedLogging)

local SduiErrors = require(Parent.SduiCoreSystem).SduiErrors

local function getImpressionsTag(n1: number, p1, p2, s1: string?) -- line: 13
	-- upvalues: SduiErrors (copy)
	local collectionId = nil
	local collectionComponentType = nil

	if p1 then
		collectionId = p1.collectionId
		collectionComponentType = p1.collectionComponentType

		if not collectionComponentType then
			p2.dependencies.logger.reportError(SduiErrors.SduiErrorType.GetImpressionsTagMissingCollectionComponentType, {
				name = s1
			}, p2.appPage)
		end

		if not collectionId then
			p2.dependencies.logger.reportError(SduiErrors.SduiErrorType.GetImpressionsTagMissingCollectionId, {
				name = s1
			}, p2.appPage)
		end
	else
		p2.dependencies.logger.reportError(SduiErrors.SduiErrorType.GetImpressionsTagMissingCollectionData, {
			name = s1
		}, p2.appPage)
	end

	local v10 = collectionId or -1

	return `{ s1 }_{ collectionComponentType }_{ p2.routeName or p2.appPage }_{ v10 }_{ n1 }`
end

return getImpressionsTag
