local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local SduiSharedUtilitiesParent = SduiSharedUtilities.Parent
local Cryo = require(SduiSharedUtilitiesParent.Cryo)

require(SduiSharedUtilities.SduiIntegrationTypes)

local function createSduiTemplateStore() -- line: 24
	-- upvalues: Cryo (copy)
	local t1 = {}
	local t2 = {}

	return {
		getTemplate = function(s1: string) -- line: 35
			-- upvalues: t1 (ref)
			return t1[s1]
		end,
		addTemplates = function(t3: {[any]: any}) -- line: 41
			-- upvalues: t1 (ref), Cryo (copy)
			t1 = Cryo.Dictionary.join(t1, t3)
		end,
		recordSurfaceTemplates = function(s2: string, t4: {[any]: any}) -- line: 48
			-- upvalues: t2 (ref)
			if t4 == nil then
				return
			end

			local v13 = t2[s2]

			if v13 == nil then
				v13 = {}
				t2[s2] = v13
			end

			for v14, v15 in t4 do
				v13[v14] = v15
			end
		end,
		getCachedRobloxComponentToTemplateId = function(s3: string) -- line: 66
			-- upvalues: t2 (ref)
			local v17 = t2[s3]

			if v17 == nil then
				return {}
			end

			return v17
		end,
		getTemplateForRobloxComponent = function(s4: string, s5: string) -- line: 76
			-- upvalues: t2 (ref), t1 (ref)
			local v20 = t2[s4]

			if v20 == nil then
				return nil
			end

			local v21 = v20[s5]

			if v21 == nil then
				return nil
			end

			return t1[v21]
		end,
		clear = function() -- line: 88
			-- upvalues: t1 (ref), t2 (ref)
			t1 = {}
			t2 = {}
		end
	}
end

local u5 = nil

local function getSduiTemplateStore() -- line: 108
	-- upvalues: u5 (ref), createSduiTemplateStore (copy)
	if u5 == nil then
		u5 = createSduiTemplateStore()
	end

	return u5
end

return getSduiTemplateStore
