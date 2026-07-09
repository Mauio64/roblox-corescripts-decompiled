local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiErrors = require(SduiCoreSystem.SduiErrors)
local SduiLogger = require(SduiCoreSystem.SduiLogger)

require(SduiCoreSystem.SduiBuilderTypes)

local function createSduiServiceDependenciesStore() -- line: 20
	-- upvalues: SduiLogger (copy), SduiErrors (copy)
	local u7 = nil

	return {
		getDependencies = function(s1: string) -- line: 27
			-- upvalues: u7 (ref), SduiLogger (copy), SduiErrors (copy)
			if u7 == nil then
				SduiLogger.reportError(SduiErrors.SduiErrorType.GetNilDependencies, {
					message = "Getting dependencies before they were set"
				}, s1)
			end

			return u7
		end,
		setDependencies = function(p1) -- line: 23
			-- upvalues: u7 (ref)
			u7 = p1
		end
	}
end

local u5 = nil

local function getSduiServiceDependenciesStore() -- line: 44
	-- upvalues: u5 (ref), createSduiServiceDependenciesStore (copy)
	if u5 == nil then
		u5 = createSduiServiceDependenciesStore()
	end

	return u5
end

return getSduiServiceDependenciesStore
