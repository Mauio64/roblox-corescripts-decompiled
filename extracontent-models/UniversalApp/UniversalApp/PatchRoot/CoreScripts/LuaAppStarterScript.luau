_G.LUAUFORGE_SENTRY_DEBUG_IDS = _G.LUAUFORGE_SENTRY_DEBUG_IDS or {}

local v1 = debug.info(1, "s")

if v1 and type(v1) == "string" then
	_G.LUAUFORGE_SENTRY_DEBUG_IDS[v1] = "86e3272c-20d8-5058-a38a-21dd97d689ba"
end

local __ = _G.LUAUFORGE_SENTRY_DEBUG_IDS

_ = "apps/UniversalApp/build/app/bootstrap.luau"

local t1 = nil

t1 = {
	cache = {},
	load = function(p1) -- line: 6
		-- upvalues: t1 (ref)
		if not t1.cache[p1] then
			t1.cache[p1] = {
				c = t1[p1]()
			}
		end

		return t1.cache[p1].c
	end
}

local function createModuleLoader(__) -- line: 16
	local t2 = {}

	local function loadModule(p3, p4) -- line: 18
		-- upvalues: t2 (copy)
		local v27 = t2[p3]

		if v27 ~= nil then
			return v27.c
		end

		local v28 = p4()

		t2[p3] = {
			c = v28
		}

		return v28
	end

	return loadModule
end
local function createChunkLoader(p5) -- line: 30
	local t3 = {}

	local function resolveChunk(p6) -- line: 32
		-- upvalues: t3 (copy), p5 (copy), resolveChunk (copy)
		local v30 = t3[p6]

		if v30 then
			return v30
		end

		local mount = p5(p6).mount
		local freeze = table.freeze
		local t4 = {
			resolveChunk = resolveChunk
		}
		local t5 = {}

		local function loadModule(p7, p8) -- line: 18
			-- upvalues: t5 (copy)
			local v43 = t5[p7]

			if v43 ~= nil then
				return v43.c
			end

			local v44 = p8()

			t5[p7] = {
				c = v44
			}

			return v44
		end

		t4.loadModule = loadModule

		local v36 = mount(freeze(t4))

		t3[p6] = v36

		return v36
	end

	return resolveChunk
end
local function requireChunk(p9) -- line: 48
	return require(`@game/CorePackages/LuauForgeChunks/{ p9 }`)
end

local t6 = {}

local function resolveChunk(p10) -- line: 32
	-- upvalues: t6 (copy), requireChunk (copy), resolveChunk (copy)
	local v18 = t6[p10]

	if v18 then
		return v18
	end

	local mount = requireChunk(p10).mount
	local freeze = table.freeze
	local t7 = {
		resolveChunk = resolveChunk
	}
	local t8 = {}

	local function loadModule(p11, p12) -- line: 18
		-- upvalues: t8 (copy)
		local v39 = t8[p11]

		if v39 ~= nil then
			return v39.c
		end

		local v40 = p12()

		t8[p11] = {
			c = v40
		}

		return v40
	end

	t7.loadModule = loadModule

	local v24 = mount(freeze(t7))

	t6[p10] = v24

	return v24
end

resolveChunk("bundled").loadModule("LUAUFORGE_MAIN")
