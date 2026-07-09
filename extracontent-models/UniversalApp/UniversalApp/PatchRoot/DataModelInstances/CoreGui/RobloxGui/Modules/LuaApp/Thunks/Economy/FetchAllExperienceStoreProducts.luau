local Modules = game:GetService("CoreGui").RobloxGui.Modules
local FetchExperienceStoreProducts = require(Modules.LuaApp.Thunks.Economy.FetchExperienceStoreProducts)

local function collectUniverseIdsFromState(p1) -- line: 10
	local t1 = {}
	local t2 = {}

	local function addUniverseId(p2) -- line: 14
		-- upvalues: t1 (copy), t2 (copy)
		if type(p2) == "string" and (p2 ~= "" and not t1[p2]) then
			t1[p2] = true
			table.insert(t2, p2)
		end
	end

	if p1.GameDetailsV2 then
		for k in pairs(p1.GameDetailsV2) do
			if type(k) == "string" and k ~= "" and not t1[k] then
				t1[k] = true
				table.insert(t2, k)
			end
		end
	end

	if p1.GameDetails then
		for k in pairs(p1.GameDetails) do
			if type(k) == "string" and k ~= "" and not t1[k] then
				t1[k] = true
				table.insert(t2, k)
			end
		end
	end

	return t2
end

return function(p3) -- line: 35
	-- upvalues: collectUniverseIdsFromState (copy), FetchExperienceStoreProducts (copy)
	return function(p4) -- line: 36
		-- upvalues: collectUniverseIdsFromState (copy), FetchExperienceStoreProducts (copy), p3 (copy)
		local v13 = collectUniverseIdsFromState(p4:getState())

		for _, v in ipairs(v13) do
			p4:dispatch(FetchExperienceStoreProducts(p3, v))
		end
	end
end
