local fFlagSduiErrorPaths = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiErrorPaths
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Signals")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/UnifiedLogging")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")
local SduiErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiErrors")
local addSduiErrorContextFields = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/addSduiErrorContextFields")
local SduiLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiLogger")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiClientBindingTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiComponentType")

local v5 = {}

local v6 = {
	__index = function(p2, p3)
		if p3 == "analyticsData" then
			return p2.getAnalyticsDataSnapshot()
		elseif p3 == "ancestorAnalyticsData" then
			return p2.getAncestorAnalyticsDataSnapshot()
		end

		return nil
	end
}

local function buildAnalyticsContextForClientBinding(p2, items, data, data2)
	local currentComponentType = data2.currentComponentType
	local currentParserName = data2.currentParserName

	local v7 = nil

	local analyticsContextForClientBinding = {
		getAnalyticsDataSnapshot = function()
			local clone = table.clone(p2 or v5)

			if items then
				xpcall(function()
					for k, item in items do
						clone[k] = item(false).data
					end
				end, function(p3)
					local v8 = {
						message = p3,
						name = data2.debugName,
						componentType = currentComponentType,
						parserName = currentParserName
					}

					if fFlagSduiErrorPaths then
						addSduiErrorContextFields(v8, data2.errorContext)
					end

					SduiLogger.reportError(
						SduiErrors.SduiErrorType.FailedToComputeAnalyticsData,
						v8,
						data2.appPage
					)
				end)
			end

			if v7 then
				return (Cryo.Dictionary.join(clone, v7))
			end

			return clone
		end,
		getAncestorAnalyticsDataSnapshot = function()
			if not data then
				return v5
			end

			local ancestorAnalyticsData = data.ancestorAnalyticsData or v5
			local analyticsData = data.analyticsData or v5
			return Cryo.Dictionary.join(ancestorAnalyticsData, analyticsData)
		end,
		setLocalAnalyticsData = function(p3)
			v7 = p3
		end,
		getCollectionData = function()
			if data and data.getCollectionData then
				return data.getCollectionData()
			end

			return nil
		end
	}

	setmetatable(analyticsContextForClientBinding, v6)
	return analyticsContextForClientBinding
end

return buildAnalyticsContextForClientBinding
