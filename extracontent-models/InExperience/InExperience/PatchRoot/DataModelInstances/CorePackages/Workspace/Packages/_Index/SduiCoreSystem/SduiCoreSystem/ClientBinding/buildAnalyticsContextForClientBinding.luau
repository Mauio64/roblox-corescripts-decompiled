local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent
local Cryo = require(SduiCoreSystemParent.Cryo)

require(SduiCoreSystemParent.Signals)
require(SduiCoreSystemParent.UnifiedLogging)
require(SduiCoreSystem.SduiBuilderTypes)

local SduiErrors = require(SduiCoreSystem.SduiErrors)
local SduiLogger = require(SduiCoreSystem.SduiLogger)

require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)
require(SduiCoreSystem.SduiComponentType)

local FFlagSduiImprovedErrorDimensions = require(SduiCoreSystemParent.SharedFlags).FFlagSduiImprovedErrorDimensions
local t1 = {}
local t2 = {
	__index = function(p1, p2) -- line: 33
		if p2 == "analyticsData" then
			return p1.getAnalyticsDataSnapshot()
		end

		if p2 == "ancestorAnalyticsData" then
			return p1.getAncestorAnalyticsDataSnapshot()
		end

		return nil
	end
}

local function buildAnalyticsContextForClientBinding(p3, t3: {[any]: any}?, p4, p5) -- line: 66
	-- upvalues: FFlagSduiImprovedErrorDimensions (copy), t1 (copy), SduiLogger (copy), SduiErrors (copy), Cryo (copy), t2 (copy)
	local currentComponentType = nil
	local currentParserName = nil

	if FFlagSduiImprovedErrorDimensions then
		currentComponentType = p5.currentComponentType
		currentParserName = p5.currentParserName
	end

	local u18 = nil
	local t4 = {
		getAnalyticsDataSnapshot = function() -- line: 91
			-- upvalues: p3 (copy), t1 (copy), t3 (copy), SduiLogger (copy), SduiErrors (copy), p5 (copy), FFlagSduiImprovedErrorDimensions (copy), currentComponentType (ref), currentParserName (ref), u18 (ref), Cryo (copy)
			local v20 = table.clone(p3 or t1)

			if t3 then
				xpcall(function() -- line: 94
					-- upvalues: t3 (copy), v20 (copy)
					for v24, v25 in t3 do
						v20[v24] = v25(false).data
					end
				end, function(err) -- line: 98
					-- upvalues: SduiLogger (copy), SduiErrors (copy), p5 (copy), FFlagSduiImprovedErrorDimensions (copy), currentComponentType (ref), currentParserName (ref)
					SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToComputeAnalyticsData, {
						message = err,
						name = p5.debugName,
						componentType = if not FFlagSduiImprovedErrorDimensions then nil else currentComponentType,
						parserName = if not FFlagSduiImprovedErrorDimensions then nil else currentParserName
					}, p5.appPage)
				end)
			end

			if u18 then
				return (Cryo.Dictionary.join(v20, u18))
			end

			return v20
		end,
		getAncestorAnalyticsDataSnapshot = function() -- line: 118
			-- upvalues: p4 (copy), t1 (copy), Cryo (copy)
			if p4 then
				local v21 = p4.ancestorAnalyticsData or t1
				local v22 = p4.analyticsData or t1

				return Cryo.Dictionary.join(v21, v22)
			end

			return t1
		end,
		setLocalAnalyticsData = function(p6) -- line: 135
			-- upvalues: u18 (ref)
			u18 = p6
		end,
		getCollectionData = function() -- line: 147
			-- upvalues: p4 (copy)
			if p4 and p4.getCollectionData then
				return p4.getCollectionData()
			end

			return nil
		end
	}

	setmetatable(t4, t2)

	return t4
end

return buildAnalyticsContextForClientBinding
