local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent

local SduiErrors = require(SduiCoreSystem.SduiErrors)
local SduiLogger = require(SduiCoreSystem.SduiLogger)

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiHostedDependencies = SharedFlags.FFlagSduiHostedDependencies

require(SduiCoreSystem.SduiBuilderTypes)

local function createSduiServiceDependenciesStore()
	local v = nil

	local v2 = FFlagSduiHostedDependencies and {} or nil

	local v3 = FFlagSduiHostedDependencies and {
		__index = function(_, p)
			if v then
				return v[p]
			end

			return nil
		end
	} or nil

	local function setScopedDependencies(p: string, p2)
		local v4 = v2[p]

		if v4 == nil then
			v4 = {}
			v2[p] = v4
		end

		local object = setmetatable(table.clone(p2), v3)
		table.insert(v4, object)
		return function()
			local index = table.find(v4, object)

			if index then
				table.remove(v4, index)
			end

			if #v4 == 0 and v2[p] == v4 then
				v2[p] = nil
			end
		end
	end

	local sduiServiceDependenciesStore = {
		getDependencies = function(p: string)
			local dependencies = v

			if FFlagSduiHostedDependencies then
				local v4 = v2[p]

				if v4 then
					dependencies = v4[#v4]
				else
					dependencies = v
				end
			end

			if dependencies == nil then
				SduiLogger.reportError(
					SduiErrors.SduiErrorType.GetNilDependencies,
					{ message = "Getting dependencies before they were set" },
					p
				)
			end

			return dependencies
		end,
		setDependencies = function(p)
			v = p
		end,
		setScopedDependencies = 0
	}

	if not FFlagSduiHostedDependencies then
		setScopedDependencies = nil
	end

	sduiServiceDependenciesStore.setScopedDependencies = setScopedDependencies
	return sduiServiceDependenciesStore
end

local sduiServiceDependenciesStore = nil

local function getSduiServiceDependenciesStore()
	if sduiServiceDependenciesStore == nil then
		sduiServiceDependenciesStore = createSduiServiceDependenciesStore()
	end

	return sduiServiceDependenciesStore
end

return getSduiServiceDependenciesStore
