local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent

require(DataHydrationParent.HttpClient)

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)

require(DataHydration.DataHydrationTypes)

local Promise = require(DataHydrationParent.Promise)
local fetchAssetUserAuth = require(script.Parent.fetchAssetUserAuth)

require(script.Parent.AssetUserAuthStoreTypes)

local function ALWAYS_REFRESH() -- line: 28
	return true
end
local function createAssetUserAuthStore(t1: {[any]: any}?) -- line: 34
	-- upvalues: createDataCache (copy), createDataResolver (copy), fetchAssetUserAuth (copy), Promise (copy), ALWAYS_REFRESH (copy)
	local v10 = t1 or {}
	local t2 = {
		network = v10.network,
		baseUrl = v10.baseUrl
	}
	local v12 = createDataCache()
	local v13 = createDataResolver({
		supportsMultiGet = false,
		cache = v12,
		fetchFn = function(s1: string, _) -- line: 42
			-- upvalues: fetchAssetUserAuth (copy), t2 (copy)
			return fetchAssetUserAuth.fetchOperation(s1, t2)
		end
	})

	local function seedAndReturn(p2) -- line: 65
		-- upvalues: v12 (copy)
		local path = p2.path

		if typeof(path) == "string" and #path > 0 then
			local v22 = string.match(path, "operations/(.+)$") or path

			v12.updateItem(v22, p2)
		end

		return p2
	end

	return {
		patchAssetIcon = function(s2: string, p3) -- line: 47
			-- upvalues: fetchAssetUserAuth (copy), t2 (copy), v12 (copy)
			return fetchAssetUserAuth.patchAssetIcon(s2, p3, t2):andThen(function(p4) -- line: 48
				-- upvalues: v12 (copy)
				local path = p4.path

				if typeof(path) == "string" and #path > 0 then
					local v37 = string.match(path, "operations/(.+)$") or path

					v12.updateItem(v37, p4)
				end

				return p4
			end)
		end,
		updateIcon = function(s3: string, s4: string) -- line: 74
			-- upvalues: fetchAssetUserAuth (copy), t2 (copy), seedAndReturn (copy)
			return fetchAssetUserAuth.updateIcon(s3, s4, t2):andThen(seedAndReturn)
		end,
		getPreviews = function(s5: string) -- line: 78
			-- upvalues: fetchAssetUserAuth (copy), t2 (copy)
			return fetchAssetUserAuth.getPreviews(s5, t2)
		end,
		updatePreviews = function(s6: string, t3: {[any]: any}) -- line: 82
			-- upvalues: fetchAssetUserAuth (copy), t2 (copy), seedAndReturn (copy)
			return fetchAssetUserAuth.updatePreviews(s6, t3, t2):andThen(seedAndReturn)
		end,
		createImageAsset = function(s7: string, s8: string, p5) -- line: 86
			-- upvalues: fetchAssetUserAuth (copy), t2 (copy), seedAndReturn (copy)
			return fetchAssetUserAuth.createImageAsset(s7, s8, p5, t2):andThen(seedAndReturn)
		end,
		pollUntilDone = function(p6) -- line: 94
			-- upvalues: Promise (copy), fetchAssetUserAuth (copy), t2 (copy), v12 (copy)
			local u32

			if typeof(p6) == "string" then
				u32 = p6
			else
				local v33 = p6.path or ""

				u32 = string.match(v33, "operations/(.+)$") or (p6.operationId or v33)
			end

			return Promise.new(function(resolve, reject) -- line: 102
				-- upvalues: u32 (ref), fetchAssetUserAuth (copy), t2 (copy), v12 (copy)
				local n1 = 0
				local n2 = 0

				local function poll() -- line: 106
					-- upvalues: n1 (ref), u32 (ref), fetchAssetUserAuth (copy), t2 (copy), v12 (copy), n2 (ref), reject (copy), resolve (copy), poll (copy)
					n1 += 1

					local v44 = u32

					fetchAssetUserAuth.fetchOperation(v44, t2):andThen(function(p7) -- line: 59
						-- upvalues: v12 (copy), v44 (copy)
						v12.updateItem(v44, p7)

						return p7
					end):andThen(function(p8) -- line: 109
						-- upvalues: n2 (ref), reject (copy), resolve (copy), n1 (ref), u32 (ref), poll (copy)
						n2 = 0

						if p8.done then
							if p8.error then
								reject(p8.error.message or "Operation failed")

								return
							end

							resolve({
								status = "done",
								operation = p8
							})

							return
						end

						if n1 >= 30 then
							resolve({
								status = "timed_out",
								operationId = u32
							})

							return
						end

						task.delay(2, poll)
					end):catch(function(p9) -- line: 123
						-- upvalues: n2 (ref), poll (copy), reject (copy)
						n2 += 1

						if n2 <= 3 then
							local v48 = math.pow(2, n2 - 1) * 2

							task.delay(v48, poll)

							return
						end

						reject(p9)
					end)
				end

				poll()
			end)
		end,
		getOperation = v13.getCachedItem,
		fetchOperation = v13.fetchItem,
		getAndFetchOperation = function(s9: string) -- line: 148
			-- upvalues: v13 (copy), ALWAYS_REFRESH (copy)
			return v13.getAndFetchItem(s9, ALWAYS_REFRESH)
		end,
		refreshOperation = function(s10: string) -- line: 58
			-- upvalues: fetchAssetUserAuth (copy), t2 (copy), v12 (copy)
			return fetchAssetUserAuth.fetchOperation(s10, t2):andThen(function(p10) -- line: 59
				-- upvalues: v12 (copy), s10 (copy)
				v12.updateItem(s10, p10)

				return p10
			end)
		end,
		updateOperation = v12.updateItem,
		clear = v13.clear,
		dispose = v13.dispose
	}
end

return createAssetUserAuthStore
