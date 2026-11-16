local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiIntegrationTypes")

local function createSduiTemplateStore()
	local v5 = {}

	local v6 = {}
	local v7 = {}

	return {
		getTemplate = function(p2)
			return v5[p2]
		end,
		addTemplates = function(p2)
			v5 = Cryo.Dictionary.join(v5, p2)
		end,
		recordSurfaceTemplates = function(p2, items)
			if items == nil then
				return
			end

			local v8 = v6[p2]

			if v8 == nil then
				v8 = {}
				v6[p2] = v8
			end

			for k, item in items do
				v8[k] = item
			end
		end,
		getCachedRobloxComponentToTemplateId = function(p2)
			local v8 = v6[p2]

			if v8 == nil then
				return {}
			end

			return v8
		end,
		getTemplateForRobloxComponent = function(p2, p3)
			local v8 = v6[p2]

			if v8 == nil then
				return nil
			end

			local v9 = v8[p3]

			if v9 == nil then
				return nil
			end

			return v5[v9]
		end,
		getSurfaceTemplateMaps = function(p2)
			local result = {}
			local result2 = {}
			local v8 = v6[p2]

			if v8 == nil then
				return result, result2
			end

			for k, v9 in v8 do
				local v10 = v5[v9]

				if not v10 then
					continue
				end

				result2[k] = v10
				result[v9] = v10
			end

			return result, result2
		end,
		addLocalizedLiterals = function(items)
			v7 = v7 or {}
			assert(v7, "localizedLiterals is nil")

			for k, item in items do
				v7[k] = item
			end
		end,
		getLocalizedLiterals = function()
			return v7 or {}
		end,
		clear = function()
			v5 = {}
			v6 = {}
			v7 = {}
		end
	}
end

local sduiTemplateStore = nil

local function getSduiTemplateStore()
	if sduiTemplateStore == nil then
		sduiTemplateStore = createSduiTemplateStore()
	end

	return sduiTemplateStore
end

return getSduiTemplateStore
