local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiErrorPaths = SharedFlags.FFlagSduiErrorPaths
local Cryo = require(parent.Cryo)
require(parent.Signals)
require(parent.UnifiedLogging)
require(SduiCoreSystem.SduiBuilderTypes)
local SduiErrors = require(SduiCoreSystem.SduiErrors)
local addSduiErrorContextFields = require(SduiCoreSystem.addSduiErrorContextFields)
local SduiLogger = require(SduiCoreSystem.SduiLogger)
require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)
require(SduiCoreSystem.SduiComponentType)

local v = {}

local v2 = {
	__index = function(p, p2)
		if p2 == "analyticsData" then
			return p.getAnalyticsDataSnapshot()
		elseif p2 == "ancestorAnalyticsData" then
			return p.getAncestorAnalyticsDataSnapshot()
		end

		return nil
	end
}

local function buildAnalyticsContextForClientBinding(p, items, data, data2)
	local currentComponentType = data2.currentComponentType
	local currentParserName = data2.currentParserName

	local v3 = nil

	local analyticsContextForClientBinding = {
		getAnalyticsDataSnapshot = function()
			local clone = table.clone(p or v)

			if items then
				xpcall(function()
					for k, item in items do
						clone[k] = item(false).data
					end
				end, function(message)
					local v4 = {
						message = message,
						name = data2.debugName,
						componentType = currentComponentType,
						parserName = currentParserName
					}

					if FFlagSduiErrorPaths then
						addSduiErrorContextFields(v4, data2.errorContext)
					end

					SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToComputeAnalyticsData, v4, data2.appPage)
				end)
			end

			if v3 then
				return (Cryo.Dictionary.join(clone, v3))
			end

			return clone
		end,
		getAncestorAnalyticsDataSnapshot = function()
			if not data then
				return v
			end

			local ancestorAnalyticsData = data.ancestorAnalyticsData or v
			local analyticsData = data.analyticsData or v
			return Cryo.Dictionary.join(ancestorAnalyticsData, analyticsData)
		end,
		setLocalAnalyticsData = function(p2)
			v3 = p2
		end,
		getCollectionData = function()
			if data and data.getCollectionData then
				return data.getCollectionData()
			end

			return nil
		end
	}

	setmetatable(analyticsContextForClientBinding, v2)
	return analyticsContextForClientBinding
end

return buildAnalyticsContextForClientBinding
