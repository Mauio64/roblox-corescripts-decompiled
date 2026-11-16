local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local parent = SduiSharedUtilities.Parent
local Cryo = require(parent.Cryo)
require(SduiSharedUtilities.SduiIntegrationTypes)

local function createSduiTemplateStore()
	local v = {}

	local v2 = {}
	local v3 = {}

	return {
		getTemplate = function(p: string)
			return v[p]
		end,
		addTemplates = function(p)
			v = Cryo.Dictionary.join(v, p)
		end,
		recordSurfaceTemplates = function(p: string, items)
			if items == nil then
				return
			end

			local v4 = v2[p]

			if v4 == nil then
				v4 = {}
				v2[p] = v4
			end

			for k, item in items do
				v4[k] = item
			end
		end,
		getCachedRobloxComponentToTemplateId = function(p: string)
			local v4 = v2[p]

			if v4 == nil then
				return {}
			end

			return v4
		end,
		getTemplateForRobloxComponent = function(p: string, p2: string)
			local v4 = v2[p]

			if v4 == nil then
				return nil
			end

			local v5 = v4[p2]

			if v5 == nil then
				return nil
			end

			return v[v5]
		end,
		getSurfaceTemplateMaps = function(p: string)
			local result = {}
			local result2 = {}
			local v4 = v2[p]

			if v4 == nil then
				return result, result2
			end

			for k, v5 in v4 do
				local v6 = v[v5]

				if not v6 then
					continue
				end

				result2[k] = v6
				result[v5] = v6
			end

			return result, result2
		end,
		addLocalizedLiterals = function(items)
			v3 = v3 or {}
			assert(v3, "localizedLiterals is nil")

			for k, item in items do
				v3[k] = item
			end
		end,
		getLocalizedLiterals = function()
			return v3 or {}
		end,
		clear = function()
			v = {}
			v2 = {}
			v3 = {}
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
