local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local Signals = require(Parent.Signals)

local function createCatalogPageRequestIdStore() -- line: 23
	-- upvalues: Signals (copy), HttpService (copy)
	local v5, v6 = Signals.createSignal({})

	return {
		getPageRequestIdMap = v5,
		getOrCreatePageRequestId = function(s1: string) -- line: 26
			-- upvalues: v5 (copy), HttpService (copy), v6 (copy)
			local v8 = v5(false)
			local v9 = v8[s1]

			if v9 ~= nil then
				return v9
			end

			local guid = HttpService:GenerateGUID(false)
			local v11 = table.clone(v8)

			v11[s1] = guid
			v6(v11)

			return guid
		end,
		resetPageRequestId = function(s2: string) -- line: 40
			-- upvalues: v5 (copy), v6 (copy)
			local v13 = v5(false)

			if v13[s2] == nil then
				return
			end

			local t1 = {}

			for v15, v16 in v13 do
				if v15 ~= s2 then
					t1[v15] = v16
				end
			end

			v6(t1)
		end
	}
end

return createCatalogPageRequestIdStore
