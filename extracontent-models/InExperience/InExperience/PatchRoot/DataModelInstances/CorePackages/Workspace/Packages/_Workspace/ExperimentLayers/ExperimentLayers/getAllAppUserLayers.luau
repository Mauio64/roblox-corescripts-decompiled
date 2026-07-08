local Parent = script:FindFirstAncestor("ExperimentLayers").Parent
local Dash = require(Parent.Dash)
local AppUserLayers = require(script.Parent.AppUserLayers)
local v4 = game:DefineFastString("IxpNewLayersForRegistration", "")

local function findNextKey(t1: {[any]: any}, s1: string) -- line: 21
	if not t1[s1] then
		t1[s1] = true

		return s1
	end

	for i = 2, 100 do
		local v10 = s1 .. "_" .. i

		if not t1[v10] then
			t1[v10] = true

			return v10
		end
	end

	error("Exceeded max index for next key search: " .. s1)
end
local function getAllAppUserLayers(s2: string?) -- line: 37
	-- upvalues: v4 (copy), AppUserLayers (copy), Dash (copy), findNextKey (copy)
	local v12 = s2 or v4

	if #v12 == 0 then
		return AppUserLayers
	end

	local v13 = Dash.copy(AppUserLayers)
	local t2 = {}
	local t3 = {}

	for v16, v17 in v13 do
		t2[v16] = true
		t3[v17] = true
	end

	local parts = string.split(v12, ",")

	for _, v20 in (Dash.map(parts, Dash.trim)) do
		if not t3[v20] then
			t3[v20] = true
			v13[findNextKey(t2, v20)] = v20
		end
	end

	return v13
end

return getAllAppUserLayers
