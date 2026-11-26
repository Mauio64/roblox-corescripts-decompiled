_G.LUAUFORGE_SENTRY_DEBUG_IDS = _G.LUAUFORGE_SENTRY_DEBUG_IDS or {}
local v = debug.info(1, "s")

if v and type(v) == "string" then
	_G.LUAUFORGE_SENTRY_DEBUG_IDS[v] = "7b0e8c3d-1bed-5787-ada9-f13f0435e64f"
end

local LUAUFORGE_SENTRY_DEBUG_IDS = _G.LUAUFORGE_SENTRY_DEBUG_IDS

_G.ENVIRONMENT = "PRODUCTION"

_ = "apps/UniversalApp/build/app/bootstrap.luau"
local v2 = nil
v2 = {
	cache = {},
	load = function(p)
		if not v2.cache[p] then
			v2.cache[p] = { c = v2[p]() }
		end

		return v2.cache[p].c
	end
}

function v2.b()
	return {}
end

function v2.c()
	return {
		chunkMounted = function(callback, chunkName, loadingMs)
			if callback ~= nil then
				pcall(callback, table.freeze({ chunkName = chunkName, loadingMs = loadingMs }))
			end
		end,
		chunkError = function(callback, chunkName, err, loadingMs)
			if callback ~= nil then
				pcall(callback, table.freeze({
					chunkName = chunkName,
					loadingMs = loadingMs,
					error = err
				}))
			end
		end,
		moduleLoaded = function(callback, chunkName, moduleId, loadingMs)
			if callback ~= nil then
				pcall(callback, table.freeze({
					chunkName = chunkName,
					moduleId = moduleId,
					loadingMs = loadingMs
				}))
			end
		end,
		moduleError = function(callback, chunkName, moduleId, err, loadingMs)
			if callback ~= nil then
				pcall(
					callback,
					table.freeze({
						chunkName = chunkName,
						moduleId = moduleId,
						loadingMs = loadingMs,
						error = err
					})
				)
			end
		end
	}
end

function v2.a()
	v2.load("b")
	local loaded = v2.load("c")

	local function newSlot()
		return {
			state = "loading",
			value = nil,
			error = nil,
			waiters = {},
			loadingThread = coroutine.running()
		}
	end

	local frozen = table.freeze({})

	local function wakeWaiters(list)
		local waiters = table.freeze(list.waiters)

		list.waiters = frozen
		table.freeze(list)

		for k, waiter in waiters do
			coroutine.resume(waiter)
		end
	end

	local function waitForSlot(data, p)
		if data.state == "ready" then
			return data.value
		end

		if data.state == "errored" then
			error(data.error)
		elseif data.loadingThread == coroutine.running() then
			error(`circular require: {p}`)
		elseif not coroutine.isyieldable() then
			error("cannot yield from non-yieldable coroutine")
		end

		table.insert(data.waiters, coroutine.running())
		coroutine.yield()

		if data.state == "ready" then
			return data.value
		end

		if data.state == "errored" then
			error(data.error)
		end

		error(`unexpected slot state: {data.state}`)
	end

	local function fillSlot(p, callback)
		local lastTime = os.clock()
		local success, result = pcall(callback)
		local v3 = os.clock() - lastTime
		p.loadingThread = nil

		if success then
			p.state = "ready"
			p.value = result
		else
			p.state = "errored"
			p.error = result
		end

		wakeWaiters(p)
		return success, result, v3 * 1000
	end

	return {
		createContainer = function(data)
			local v3 = {}

			local function makeChunkLoadModule(p) -- 1 equivalent call inferred from this helper
				local v4 = {}
				return function(p2, p3)
					local v5 = v4[p2]

					if v5 then
						return waitForSlot(v5, `{p}:{p2}`)
					end

					local v6 = newSlot()
					v4[p2] = v6
					local v7, v8, v9 = fillSlot(v6, p3)

					if v7 then
						loaded.moduleLoaded(data.onModuleLoaded, p, p2, v9)
						return v8
					end

					loaded.moduleError(data.onModuleError, p, p2, v8, v9)
					error(v8)
				end
			end

			local function resolveChunk(p)
				local v4 = v3[p]

				if v4 then
					return waitForSlot(v4, `chunk {p}`)
				end

				local v5 = newSlot()
				v3[p] = v5
				local v6, v7, v8 = fillSlot(v5, function()
					return data.loadChunk(p).mount(table.freeze({
						resolveChunk = resolveChunk,
						loadModule = makeChunkLoadModule(p) -- inferred equivalent call
					}))
				end)

				if v6 then
					loaded.chunkMounted(data.onChunkMounted, p, v8)
					return v7
				end

				loaded.chunkError(data.onChunkError, p, v7, v8)
				error(v7)
			end

			return table.freeze({
				resolveChunk = resolveChunk,
				preloadChunk = function(p, p2)
					local thread = coroutine.create(function()
						local chunk = resolveChunk(p)

						if p2 then
							chunk.loadModule(p2)
						end
					end)
					coroutine.resume(thread)
				end
			})
		end
	}
end

local defineFastFlag = game:DefineFastFlag("LuaAppLoadChunksFromManifest", false)
local defineFastFlag2 = game:DefineFastFlag("LuaAppLoadChunksFallbackToEmbedded", false)

if defineFastFlag then
	local loaded = v2.load("a")

	local InsertService = game:GetService("InsertService")
	local TelemetryService = game:GetService("TelemetryService")

	local frozen = table.freeze({
		eventName = "LuauForgeChunkError",
		backends = { "EventIngest" },
		throttlingPercentage = 10000,
		lastUpdated = { 2026, 8, 24 },
		description = "Fired when a LuauForge container chunk fails to mount."
	})

	local frozen2 = table.freeze({
		eventName = "LuauForgeModuleError",
		backends = { "EventIngest" },
		throttlingPercentage = 10000,
		lastUpdated = { 2026, 8, 24 },
		description = "Fired when a module factory inside a LuauForge chunk errors."
	})

	local function onChunkError(data)
		TelemetryService:LogEvent(frozen, {
			customFields = {
				chunkName = data.chunkName,
				loadingMs = data.loadingMs,
				error = tostring(data.error)
			}
		})
	end

	local function getContentManifest() -- 1 equivalent call inferred from this helper
		return require("@game/CorePackages/LuauForgeContentManifest")
	end

	local function resolveEmbeddedChunk(p)
		return require(`@game/CorePackages/LuauForgeChunks/{p}`)
	end

	local function unpackChunk(instance)
		local bundle = instance:FindFirstChild("bundle")

		if bundle ~= nil and bundle:IsA("ModuleScript") then
			return require(bundle)
		end

		error("Chunk is not a ModuleScript named bundle")
	end

	local function resolveContentChunk(p)
		return unpackChunk(InsertService:LoadAssetWithBytecodeAsync(p))
	end

	loaded.createContainer(table.freeze({
		loadChunk = function(chunkName)
			print(`Loading chunk {chunkName}`)
			local v3 = getContentManifest()[chunkName] -- inferred equivalent call

			if v3 ~= nil then
				print(`Loading content chunk {v3}`)

				if not defineFastFlag2 then
					return resolveContentChunk(v3)
				end

				local lastTime = os.clock()
				local success, result = pcall(resolveContentChunk, v3)

				if success then
					return result
				end

				onChunkError({
					chunkName = chunkName,
					loadingMs = (os.clock() - lastTime) * 1000,
					error = result
				})
			end

			print(`Loading embedded chunk {chunkName}`)
			return resolveEmbeddedChunk(chunkName)
		end,
		onChunkError = onChunkError,
		onModuleError = function(data)
			TelemetryService:LogEvent(frozen2, {
				customFields = {
					chunkName = data.chunkName,
					moduleId = data.moduleId,
					loadingMs = data.loadingMs,
					error = tostring(data.error)
				}
			})
		end
	})).resolveChunk("bundled").loadModule("LUAUFORGE_MAIN")
else
	local function createModuleLoader(p)
		local v3 = {}
		local function loadModule(p2, callback)
			local v4 = v3[p2]

			if v4 ~= nil then
				return v4.c
			end

			local v5 = callback()
			v3[p2] = { c = v5 }
			return v5
		end

		return loadModule
	end

	local function createChunkLoader(requireChunk) -- 1 equivalent call inferred from this helper
		local v3 = {}
		local function resolveChunk(p)
			local v4 = v3[p]

			if v4 then
				return v4
			end

			local mount = requireChunk(p).mount
			local v5 = { resolveChunk = resolveChunk, loadModule = 0 }
			local v6 = {}
			function v5.loadModule(p2, callback)
				local v7 = v6[p2]

				if v7 ~= nil then
					return v7.c
				end

				local v8 = callback()
				v6[p2] = { c = v8 }
				return v8
			end

			local v7 = mount(table.freeze(v5))

			v3[p] = v7
			return v7
		end

		return resolveChunk
	end

	local function requireChunk(p)
		return require(`@game/CorePackages/LuauForgeChunks/{p}`)
	end

	createChunkLoader(requireChunk)("bundled").loadModule("LUAUFORGE_MAIN") -- inferred equivalent call
end
