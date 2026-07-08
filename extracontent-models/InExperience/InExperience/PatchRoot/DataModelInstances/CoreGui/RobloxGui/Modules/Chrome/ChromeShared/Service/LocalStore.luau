local ChromeShared = script:FindFirstAncestor("ChromeShared")
local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Constants = require(ChromeShared.Unibar.Constants)
local EngineFeature = game:GetEngineFeature("InGameMenuStateStorageKey")
local u7 = nil
local u8 = false
local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = Players.LocalPlayer
end

local v10 = "player_" .. tostring(not LocalPlayer and 0 or LocalPlayer.UserId)

local function initStore() -- line: 25
	-- upvalues: u7 (ref), v10 (copy)
	if u7.LocalPlayer == nil then
		u7.LocalPlayer = {}
	end

	if u7.LocalPlayer[v10] == nil then
		u7.LocalPlayer[v10] = {}
	end

	if u7.AnyPlayer == nil then
		u7.AnyPlayer = {}
	end
end
local function localPlayerSelector(p1) -- line: 37
	-- upvalues: v10 (copy)
	if p1 and (p1.LocalPlayer and p1.LocalPlayer[v10]) then
		return p1.LocalPlayer[v10]
	end

	return p1
end
local function anyPlayerSelector(p2) -- line: 44
	if p2 and p2.AnyPlayer then
		return p2.AnyPlayer
	end

	return p2
end
local function loadStore() -- line: 51
	-- upvalues: EngineFeature (copy), AppStorageService (copy), u8 (ref), HttpService (copy), u7 (ref), initStore (copy)
	if not EngineFeature then
		return
	end

	local ok, result = pcall(function() -- line: 55
		-- upvalues: AppStorageService (copy)
		return AppStorageService:GetItem("InGameMenuState")
	end)

	if ok then
		u8 = true

		if #result > 0 then
			local ok2, result2 = pcall(function() -- line: 61
				-- upvalues: HttpService (copy), result (copy)
				return HttpService:JSONDecode(result)
			end)

			if ok2 then
				u7 = result2
			else
				u7 = {}
			end
		else
			u7 = {}
		end

		initStore()
	end
end
local function saveStore() -- line: 76
	-- upvalues: EngineFeature (copy), u8 (ref), HttpService (copy), u7 (ref), AppStorageService (copy)
	if not EngineFeature then
		return
	end

	if u8 then
		local ok, result = pcall(function() -- line: 81
			-- upvalues: HttpService (copy), u7 (ref)
			return HttpService:JSONEncode(u7)
		end)

		if ok then
			local ok3, result3 = pcall(function() -- line: 85
				-- upvalues: AppStorageService (copy), result (copy)
				AppStorageService:SetItem("InGameMenuState", result)
				AppStorageService:Flush()
			end)

			if not ok3 then
				print(result3)
				error("Failed to write JSON to AppStorageService", 0)

				return
			end
		else
			error("Failed to encode JSON", 0)
		end
	end
end
local function deepCopy(p3) -- line: 99
	-- upvalues: deepCopy (copy)
	if type(p3) ~= "table" then
		return p3
	end

	local t1 = {}

	for k, v in pairs(p3) do
		t1[k] = deepCopy(v)
	end

	return t1
end
local function store(s1: string, p4, p5) -- line: 111
	-- upvalues: u8 (ref), loadStore (copy), u7 (ref), deepCopy (copy), saveStore (copy)
	if not u8 then
		loadStore()
	end

	if u8 then
		local v36 = p5 and p5(u7) or u7
		local v37 = v36[s1]

		v36[s1] = deepCopy(p4)

		if v37 ~= v36[s1] then
			saveStore()
		end
	end
end
local function load(s2: string, p6) -- line: 125
	-- upvalues: u8 (ref), loadStore (copy), u7 (ref), deepCopy (copy)
	if not u8 then
		loadStore()
	end

	if u8 then
		local v40 = p6 and p6(u7) or u7

		if v40 then
			return (deepCopy(v40[s2]))
		end
	end

	return nil
end

return {
	isEnabled = function() -- line: 166
		-- upvalues: EngineFeature (copy)
		return EngineFeature
	end,
	storeForLocalPlayer = function(p7, p8) -- line: 169
		-- upvalues: localPlayerSelector (copy), u8 (ref), loadStore (copy), u7 (ref), v10 (copy), deepCopy (copy), saveStore (copy)
		local v78 = localPlayerSelector
		local g81 = nil
		local v80 = nil

		if not u8 then
			loadStore()
		end

		if not u8 then
			return
		end

		if v78 then
			local v79 = u7

			v80 = if not v79 or (not v79.LocalPlayer or not v79.LocalPlayer[v10]) then v79 else v79.LocalPlayer[v10]

			if v80 then
				g81 = true
			end
		end

		if not g81 then
			v80 = u7
		end

		g81 = false

		local v82 = v80[p7]

		v80[p7] = deepCopy(p8)

		if v82 ~= v80[p7] then
			saveStore()
		end
	end,
	loadForLocalPlayer = function(p9) -- line: 172
		-- upvalues: localPlayerSelector (copy), u8 (ref), loadStore (copy), u7 (ref), v10 (copy), deepCopy (copy)
		local v84 = localPlayerSelector
		local g87 = nil
		local v86 = nil

		if not u8 then
			loadStore()
		end

		if not u8 then
			return nil
		end

		if v84 then
			local v85 = u7

			v86 = if not v85 or (not v85.LocalPlayer or not v85.LocalPlayer[v10]) then v85 else v85.LocalPlayer[v10]

			if v86 then
				g87 = true
			end
		end

		if not g87 then
			v86 = u7
		end

		g87 = false

		if v86 then
			return (deepCopy(v86[p9]))
		end

		return nil
	end,
	storeForAnyPlayer = function(p10, p11) -- line: 176
		-- upvalues: anyPlayerSelector (copy), u8 (ref), loadStore (copy), u7 (ref), deepCopy (copy), saveStore (copy)
		local v90 = anyPlayerSelector
		local g93 = nil
		local v92 = nil

		if not u8 then
			loadStore()
		end

		if not u8 then
			return
		end

		if v90 then
			local v91 = u7

			v92 = if not v91 or not v91.AnyPlayer then v91 else v91.AnyPlayer

			if v92 then
				g93 = true
			end
		end

		if not g93 then
			v92 = u7
		end

		g93 = false

		local v94 = v92[p10]

		v92[p10] = deepCopy(p11)

		if v94 ~= v92[p10] then
			saveStore()
		end
	end,
	loadForAnyPlayer = function(p12) -- line: 179
		-- upvalues: anyPlayerSelector (copy), u8 (ref), loadStore (copy), u7 (ref), deepCopy (copy)
		local v96 = anyPlayerSelector
		local g99 = nil
		local v98 = nil

		if not u8 then
			loadStore()
		end

		if not u8 then
			return nil
		end

		if v96 then
			local v97 = u7

			v98 = if not v97 or not v97.AnyPlayer then v97 else v97.AnyPlayer

			if v98 then
				g99 = true
			end
		end

		if not g99 then
			v98 = u7
		end

		g99 = false

		if v98 then
			return (deepCopy(v98[p12]))
		end

		return nil
	end,
	clearCache = function() -- line: 183
		-- upvalues: u8 (ref), u7 (ref)
		u8 = false
		u7 = nil
	end,
	getValue = function(s3: string) -- line: 138
		-- upvalues: localPlayerSelector (copy), u8 (ref), loadStore (copy), u7 (ref), v10 (copy), deepCopy (copy)
		local v42 = localPlayerSelector
		local g45 = nil
		local v44 = nil

		if not u8 then
			loadStore()
		end

		if not u8 then
			return nil
		end

		if v42 then
			local v43 = u7

			v44 = if not v43 or (not v43.LocalPlayer or not v43.LocalPlayer[v10]) then v43 else v43.LocalPlayer[v10]

			if v44 then
				g45 = true
			end
		end

		if not g45 then
			v44 = u7
		end

		g45 = false

		if v44 then
			return (deepCopy(v44[s3]))
		end

		return nil
	end,
	getUniversesExposedTo = function(s4: string) -- line: 143
		-- upvalues: localPlayerSelector (copy), u8 (ref), loadStore (copy), u7 (ref), v10 (copy), deepCopy (copy)
		local v47 = localPlayerSelector
		local g48 = nil
		local g50 = nil
		local g53 = nil
		local v52 = nil
		local v49 = nil

		if not u8 then
			loadStore()
		end

		repeat
			if g48 or not u8 then
				g48 = false
				v49 = nil
				g50 = true
			end

			if not g50 then
				if v47 then
					local v51 = u7

					v52 = if not v51 or (not v51.LocalPlayer or not v51.LocalPlayer[v10]) then v51 else v51.LocalPlayer[v10]

					if v52 then
						g53 = true
					end
				end

				if not g53 then
					v52 = u7
				end

				g53 = false
			end

			if g50 or v52 then
				if not g50 then
					v49 = deepCopy(v52[s4])
				end

				g50 = false

				if not v49 then
					return {}
				end

				return v49
			end

			g48 = true
		until not g48
	end,
	getNumUniversesExposedTo = function(p13) -- line: 160
		-- upvalues: localPlayerSelector (copy), u8 (ref), loadStore (copy), u7 (ref), v10 (copy), deepCopy (copy)
		local v70 = localPlayerSelector
		local g71 = nil
		local g75 = nil
		local v74 = nil

		if not u8 then
			loadStore()
		end

		repeat
			local v72

			if g71 or not u8 then
				g71 = false
				v72 = nil

				return #(v72 or {})
			end

			if v70 then
				local v73 = u7

				v74 = if not v73 or (not v73.LocalPlayer or not v73.LocalPlayer[v10]) then v73 else v73.LocalPlayer[v10]

				if v74 then
					g75 = true
				end
			end

			if not g75 then
				v74 = u7
			end

			g75 = false

			if v74 then
				v72 = deepCopy(v74[p13])

				return #(v72 or {})
			end

			g71 = true
		until not g71
	end,
	addUniverseToExposureList = function(s5: string, n1: number) -- line: 151
		-- upvalues: localPlayerSelector (copy), u8 (ref), loadStore (copy), u7 (ref), v10 (copy), deepCopy (copy), Constants (copy), saveStore (copy)
		local v56 = localPlayerSelector
		local g57 = nil
		local g59 = nil
		local g62 = nil
		local v61 = nil
		local v58 = nil
		local g67 = nil
		local v66 = nil

		if not u8 then
			loadStore()
		end

		repeat
			if g57 or not u8 then
				g57 = false
				v58 = nil
				g59 = true
			end

			if not g59 then
				if v56 then
					local v60 = u7

					v61 = if not v60 or (not v60.LocalPlayer or not v60.LocalPlayer[v10]) then v60 else v60.LocalPlayer[v10]

					if v61 then
						g62 = true
					end
				end

				if not g62 then
					v61 = u7
				end

				g62 = false
			end

			if g59 or v61 then
				if not g59 then
					v58 = deepCopy(v61[s5])
				end

				g59 = false

				local v63 = v58 or {}

				if not table.find(v63, n1) and #v63 < Constants.MAX_NUM_UNIVERSES_SHOWN then
					table.insert(v63, n1)

					local v64 = localPlayerSelector

					if not u8 then
						loadStore()
					end

					if u8 then
						if v64 then
							local v65 = u7

							v66 = if not v65 or (not v65.LocalPlayer or not v65.LocalPlayer[v10]) then v65 else v65.LocalPlayer[v10]

							if v66 then
								g67 = true
							end
						end

						if not g67 then
							v66 = u7
						end

						g67 = false

						local v68 = v66[s5]

						v66[s5] = deepCopy(v63)

						if v68 ~= v66[s5] then
							saveStore()
						end

						return
					end
				end

				return
			end

			g57 = true
		until not g57
	end
}
