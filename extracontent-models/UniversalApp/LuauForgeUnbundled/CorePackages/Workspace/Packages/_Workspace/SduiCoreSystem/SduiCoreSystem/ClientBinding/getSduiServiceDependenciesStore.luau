local SduiErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiErrors")
local SduiLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiLogger")

local fFlagSduiHostedDependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiHostedDependencies

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")

local function createSduiServiceDependenciesStore()
	local v5 = nil

	local v6 = fFlagSduiHostedDependencies and {} or nil

	local v7 = fFlagSduiHostedDependencies and {
		__index = function(p2, p3)
			if v5 then
				return v5[p3]
			end

			return nil
		end
	} or nil

	local function setScopedDependencies(p2, p3)
		local v8 = v6[p2]

		if v8 == nil then
			v8 = {}
			v6[p2] = v8
		end

		local object = setmetatable(table.clone(p3), v7)
		table.insert(v8, object)
		return function()
			local index = table.find(v8, object)

			if index then
				table.remove(v8, index)
			end

			if #v8 == 0 and v6[p2] == v8 then
				v6[p2] = nil
			end
		end
	end

	local sduiServiceDependenciesStore = {
		getDependencies = function(p2)
			local dependencies = v5

			if fFlagSduiHostedDependencies then
				local v8 = v6[p2]
				dependencies = if v8 then v8[#v8] else v5
			end

			if dependencies == nil then
				SduiLogger.reportError(
					SduiErrors.SduiErrorType.GetNilDependencies,
					{ message = "Getting dependencies before they were set" },
					p2
				)
			end

			return dependencies
		end,
		setDependencies = function(p2)
			v5 = p2
		end,
		setScopedDependencies = 0
	}

	if not fFlagSduiHostedDependencies then
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
