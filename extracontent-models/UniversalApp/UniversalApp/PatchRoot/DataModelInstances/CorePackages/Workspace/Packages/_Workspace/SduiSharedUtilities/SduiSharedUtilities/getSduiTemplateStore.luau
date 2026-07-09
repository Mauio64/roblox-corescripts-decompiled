local Parent = script:FindFirstAncestor("SduiSharedUtilities").Parent
local Cryo = require(Parent.Cryo)

local function createSduiTemplateStore() -- line: 38
	-- upvalues: Cryo (copy)
	local t1 = {}
	local t2 = {}

	return {
		getTemplate = function(s1: string) -- line: 49
			-- upvalues: t1 (ref)
			return t1[s1]
		end,
		addTemplates = function(t3: {[any]: any}) -- line: 55
			-- upvalues: t1 (ref), Cryo (copy)
			t1 = Cryo.Dictionary.join(t1, t3)
		end,
		recordSurfaceTemplates = function(s2: string, t4: {[any]: any}) -- line: 62
			-- upvalues: t2 (ref)
			if t4 == nil then
				return
			end

			local v12 = t2[s2]

			if v12 == nil then
				v12 = {}
				t2[s2] = v12
			end

			for v13, v14 in t4 do
				v12[v13] = v14
			end
		end,
		getCachedRobloxComponentToTemplateId = function(s3: string) -- line: 80
			-- upvalues: t2 (ref)
			local v16 = t2[s3]

			if v16 == nil then
				return {}
			end

			return v16
		end,
		getTemplateForRobloxComponent = function(s4: string, s5: string) -- line: 90
			-- upvalues: t2 (ref), t1 (ref)
			local v19 = t2[s4]

			if v19 == nil then
				return nil
			end

			local v20 = v19[s5]

			if v20 == nil then
				return nil
			end

			return t1[v20]
		end,
		clear = function() -- line: 102
			-- upvalues: t1 (ref), t2 (ref)
			t1 = {}
			t2 = {}
		end
	}
end

local u4 = nil

local function getSduiTemplateStore() -- line: 122
	-- upvalues: u4 (ref), createSduiTemplateStore (copy)
	if u4 == nil then
		u4 = createSduiTemplateStore()
	end

	return u4
end

return getSduiTemplateStore
