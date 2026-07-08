local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local Cryo = require(Parent.Cryo)
local SendGameImpressions = require(Parent.GameCollections).SendGameImpressions

require(Parent.UnifiedLogging)

local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiBuilder = SduiCoreSystem.SduiBuilder
local SduiErrors = SduiCoreSystem.SduiErrors
local SduiParsers = SduiCoreSystem.SduiParsers
local SduiParseHelpers = SduiCoreSystem.SduiParseHelpers
local findAnalyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors
local AppPage = require(Parent.RobloxAppEnums).AppPage

require(Parent.DiscoveryTypes)

local FFlagLuaAppAddComponentTypeToSearchImpressions = require(Parent.SharedFlags).FFlagLuaAppAddComponentTypeToSearchImpressions
local FFlagSduiExperienceDetailsSupport = require(Parent.SharedFlags).FFlagSduiExperienceDetailsSupport
local t1 = {}

local function sendLegacyGameImpressionsForSdui(t2: {[any]: any}, t3: {[any]: any}, t4: {[any]: any}, p1, p2, n1: number?, p3, p4: ((...any) -> ...any)?, n2: number?, s1: string?) -- line: 30
	-- upvalues: t1 (copy), Cryo (copy), SduiParsers (copy), SduiBuilder (copy), AppPage (copy), findAnalyticsFieldInAncestors (copy), SendGameImpressions (copy), FFlagLuaAppAddComponentTypeToSearchImpressions (copy), FFlagSduiExperienceDetailsSupport (copy), SduiParseHelpers (copy), SduiErrors (copy)
	local t5 = {}

	for _, v27 in t3 or t1 do
		table.insert(t5, (Cryo.Dictionary.join(v27, {
			isSponsored = SduiParsers.safeParseBoolean(v27.adFlag or false, p3, p1)
		})))
	end

	if #t5 > 0 and #t2 > 0 then
		local v28 = t5[t2[1]] and t5[t2[1]].itemComponentType or "unknown"
		local v29 = nil
		local v30 = t4[t2[1]]

		if v30 then
			local v31 = SduiBuilder.getComponentType(v30, p3)
			local v32 = v31 == "Tile" or v31 == "GameTile"
			local v33 = v30.props and (v30.props.imageAspectRatio or 0) > 1

			v29 = v32 and v33
		end

		if p4 then
			p4(t2, t5, p2.itemsPerRow, n1, v29)

			return
		end

		if p3.appPage == AppPage.SearchPage then
			local v34 = findAnalyticsFieldInAncestors("searchUuid", p1)
			local t6 = {
				emphasisFlag = 0,
				seeAllFlag = 0,
				searchUuid = v34,
				sortPos = p2.collectionPosition,
				gameSetTypeId = tostring(p2.collectionId)
			}

			SendGameImpressions.sendFromSearch(p3.dependencies.eventIngest, p3.dependencies.appAnalytics, t2, t5, p3.appPage, t6, n2, n1, if not FFlagLuaAppAddComponentTypeToSearchImpressions then nil else v29 or false, if not FFlagLuaAppAddComponentTypeToSearchImpressions then nil else v28)

			return
		end

		if FFlagSduiExperienceDetailsSupport and (p3.appPage == AppPage.ExperienceDetail or p3.appPage == AppPage.GameDetail) then
			local refId = p2.refId

			SendGameImpressions.sendFromGameDetails(p3.dependencies.eventIngest, p3.dependencies.appAnalytics, t2, t5, (tostring(refId)))

			return
		end

		SendGameImpressions.sendFromTopicContents(p3.dependencies.eventIngest, p3.dependencies.appAnalytics, t2, t5, p3.appPage, tostring(p2.collectionId), p2.collectionPosition, n1, nil, nil, n2, v29 or false, v28, nil, nil, function(s2: string) -- line: 135
			-- upvalues: p1 (copy), SduiParseHelpers (copy), p3 (copy), SduiErrors (copy), v28 (copy), s1 (copy)
			local v38 = if not p1 then nil else SduiParseHelpers.stringifyValue(p1.analyticsData)

			p3.dependencies.logger.reportError(SduiErrors.SduiErrorType.FailedToLogGameImpressions, {
				componentType = v28,
				name = s1,
				message = `Failed to log game impressions. reason: { s2 }. analyticsContext: { v38 }`
			}, p3.appPage)
		end, nil)
	end
end

return sendLegacyGameImpressionsForSdui
