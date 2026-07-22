local Parent = script:FindFirstAncestor("BuildExperience").Parent
local React = require(Parent.React)
local Promise = require(Parent.Promise)
local getAssetUserAuthStore = require(Parent.DataHydration.AssetUserAuth).getAssetUserAuthStore
local debug = require(Parent.DataHydration.CreatorAgentChat).debug

local function formatError(p1) -- line: 33
	if typeof(p1) == "string" then
		return p1
	end

	if typeof(p1) == "table" and p1.errorMessage then
		return `HTTP { tostring(p1.responseCode) }: { p1.errorMessage }`
	end

	return (tostring(p1))
end
local function useMediaUpdater(t1: {[any]: any}?) -- line: 42
	-- upvalues: React (copy), Promise (copy), debug (copy), getAssetUserAuthStore (copy)
	local v10 = React.useRef(Promise.resolve())
	local v11 = t1 and t1.onSuccess
	local v12 = t1 and t1.onError
	local v13 = React.useCallback(function(p2: ((...any) -> ...any), s1: string) -- line: 47
		-- upvalues: debug (copy), v10 (copy), getAssetUserAuthStore (copy), Promise (copy), v11 (copy), v12 (copy)
		debug.log("info", `media_updater { s1 } enqueued`)

		local v20 = v10.current:catch(function() -- line: 50
			return nil
		end):andThen(p2):andThen(function(p3) -- line: 54
			-- upvalues: getAssetUserAuthStore (copy)
			return getAssetUserAuthStore().pollUntilDone(p3)
		end):andThen(function(p4) -- line: 57
			-- upvalues: Promise (copy)
			if typeof(p4) == "table" and p4.status == "timed_out" then
				return Promise.reject("Operation did not complete in time")
			end

			if p4.status == "done" then
				return p4.operation
			end

			return p4
		end)

		v10.current = v20:catch(function() -- line: 64
			return nil
		end)

		return v20:andThen(function(p5) -- line: 69
			-- upvalues: debug (copy), s1 (copy), v11 (copy)
			debug.log("info", `media_updater { s1 } succeeded`)

			if v11 then
				v11()
			end

			return p5
		end):catch(function(p6) -- line: 76
			-- upvalues: debug (copy), s1 (copy), v12 (copy), Promise (copy)
			local v34 = if typeof(p6) ~= "string" then if typeof(p6) ~= "table" or not p6.errorMessage then tostring(p6) else `HTTP { tostring(p6.responseCode) }: { p6.errorMessage }` else p6

			debug.log("warn", `media_updater { s1 } failed`, {
				error = v34
			})

			if v12 then
				v12(v34)
			end

			return Promise.reject(p6)
		end)
	end, {
		v11,
		v12
	})
	local v14 = React.useCallback(function(s2: string, p7) -- line: 86
		-- upvalues: v13 (copy), Promise (copy), getAssetUserAuthStore (copy)
		return v13(function() -- line: 87
			-- upvalues: Promise (copy), p7 (copy), getAssetUserAuthStore (copy), s2 (copy)
			return Promise.resolve(p7):andThen(function(s3: string) -- line: 88
				-- upvalues: getAssetUserAuthStore (copy), s2 (copy)
				return getAssetUserAuthStore().updateIcon(s2, s3)
			end)
		end, "setIcon")
	end, { v13 })
	local v15 = React.useCallback(function(s4: string, p8) -- line: 95
		-- upvalues: v13 (copy), getAssetUserAuthStore (copy), Promise (copy)
		return v13(function() -- line: 96
			-- upvalues: getAssetUserAuthStore (copy), Promise (copy), p8 (copy), s4 (copy)
			local v35 = getAssetUserAuthStore()

			return Promise.resolve(p8):andThen(function(s5: string) -- line: 98
				-- upvalues: v35 (copy), s4 (copy)
				return v35.getPreviews(s4):andThen(function(t2: {[any]: any}) -- line: 99
					-- upvalues: s5 (copy), v35 (copy), s4 (copy)
					local v47 = table.clone(t2)

					table.insert(v47, {
						asset = `assets/{ s5 }`
					})

					return v35.updatePreviews(s4, v47)
				end)
			end)
		end, "addPreview")
	end, { v13 })
	local v16 = React.useCallback(function(s6: string, p9, s7: string) -- line: 111
		-- upvalues: v13 (copy), getAssetUserAuthStore (copy), Promise (copy)
		return v13(function() -- line: 112
			-- upvalues: getAssetUserAuthStore (copy), Promise (copy), p9 (copy), s6 (copy), s7 (copy)
			local v36 = getAssetUserAuthStore()

			return Promise.resolve(p9):andThen(function(s8: string) -- line: 114
				-- upvalues: v36 (copy), s6 (copy), s7 (copy), Promise (copy)
				return v36.getPreviews(s6):andThen(function(t3: {[any]: any}) -- line: 115
					-- upvalues: s7 (copy), Promise (copy), s8 (copy), v36 (copy), s6 (copy)
					local v49 = nil

					for v50, v51 in t3 do
						if v51.asset == s7 then
							v49 = v50

							break
						end
					end

					if v49 == nil then
						return Promise.reject(`Preview "{ s7 }" not found`)
					end

					local v52 = table.clone(t3)
					local v53 = table.clone(t3[v49])

					v53.asset = `assets/{ s8 }`
					v52[v49] = v53

					return v36.updatePreviews(s6, v52)
				end)
			end)
		end, "replacePreview")
	end, { v13 })
	local v17 = React.useCallback(function(s9: string, s10: string) -- line: 138
		-- upvalues: v13 (copy), getAssetUserAuthStore (copy), Promise (copy)
		return v13(function() -- line: 139
			-- upvalues: getAssetUserAuthStore (copy), s9 (copy), s10 (copy), Promise (copy)
			local v37 = getAssetUserAuthStore()

			return v37.getPreviews(s9):andThen(function(t4: {[any]: any}) -- line: 141
				-- upvalues: s10 (copy), Promise (copy), v37 (copy), s9 (copy)
				local v42 = nil

				for v43, v44 in t4 do
					if v44.asset == s10 then
						v42 = v43

						break
					end
				end

				if v42 == nil then
					return Promise.reject(`Preview "{ s10 }" not found`)
				end

				local v45 = table.clone(t4)

				table.remove(v45, v42)

				return v37.updatePreviews(s9, v45)
			end)
		end, "removePreview")
	end, { v13 })

	return {
		setIcon = v14,
		addPreview = v15,
		replacePreview = v16,
		removePreview = v17
	}
end

return useMediaUpdater
