local AssetFavorites = script:FindFirstAncestor("AssetFavorites")
local Cryo = require(AssetFavorites.Parent.Cryo)
local React = require(AssetFavorites.Parent.React)
local StatusCodes = require(AssetFavorites.Parent.Http).StatusCodes
local HttpRequest = require(AssetFavorites.Parent.HttpRequest)
local FFlagLuaAppDefaultHttpRetry = require(AssetFavorites.Parent.SharedFlags).FFlagLuaAppDefaultHttpRetry
local useLocalUserId = require(AssetFavorites.Hooks.useLocalUserId)
local GetFavoriteForAsset = require(AssetFavorites.Requests.GetFavoriteForAsset)
local PostFavoriteForAsset = require(AssetFavorites.Requests.PostFavoriteForAsset)
local DeleteFavoriteForAsset = require(AssetFavorites.Requests.DeleteFavoriteForAsset)

require(AssetFavorites.Parent.LuauPolyfill)

local Promise = require(AssetFavorites.Parent.Promise)
local logger = require(AssetFavorites.logger)
local useCallback = React.useCallback
local useEffect = React.useEffect
local useState = React.useState
local useRef = React.useRef
local useMemo = React.useMemo
local v18 = HttpRequest.config({
	requestFunction = HttpRequest.requestFunctions.RequestInternal,
	maxRetryCount = if not FFlagLuaAppDefaultHttpRetry then nil else game:DefineFastInt("UseAssetFavoritingHttpRetryCount", 4)
})

local function useAssetFavoriting(t1: {[any]: any}) -- line: 32
	-- upvalues: useLocalUserId (copy), useState (copy), useRef (copy), useCallback (copy), logger (copy), Promise (copy), DeleteFavoriteForAsset (copy), v18 (copy), PostFavoriteForAsset (copy), useMemo (copy), Cryo (copy), useEffect (copy), GetFavoriteForAsset (copy), StatusCodes (copy)
	local v21 = useLocalUserId()
	local v22, v23 = useState({})
	local v24 = useRef({})
	local v25 = useCallback(function(n1: number?) -- line: 42
		-- upvalues: logger (copy), v21 (copy)
		if not n1 then
			return false
		end

		if n1 <= 0 or n1 % 1 ~= 0 then
			logger:warning(`validation failed (assetId must be a positive int, got { n1 })`)

			return false
		end

		if not v21 or v21 <= 0 then
			logger:warning(`validation failed (userId must be a positive int, got { v21 })`)

			return false
		end

		return true
	end, { v21 })
	local v26 = useCallback(function() -- line: 62
		-- upvalues: v22 (copy)
		return v22
	end, { v22 })
	local v27 = useCallback(function(n2: number) -- line: 66
		-- upvalues: v22 (copy)
		local v35 = v22[tostring(n2)]

		if v35 ~= nil then
			return v35
		end

		return false
	end, { v22 })
	local v28 = useCallback(function(n3: number) -- line: 71
		-- upvalues: v22 (copy)
		return v22[tostring(n3)] ~= nil
	end, { v22 })
	local v29 = useCallback(function(n4: number) -- line: 75
		-- upvalues: v24 (copy)
		return v24.current[tostring(n4)] ~= nil
	end, {})
	local v30 = useCallback(function(n5: number, b1: boolean) -- line: 79
		-- upvalues: v23 (copy)
		v23(function(p1) -- line: 80
			-- upvalues: n5 (copy), b1 (copy)
			local v46 = table.clone(p1)

			v46[tostring(n5)] = b1

			return v46
		end)
	end, {})
	local v31 = useCallback(function(n6: number) -- line: 87
		-- upvalues: v25 (copy), Promise (copy), v27 (copy), v30 (copy), DeleteFavoriteForAsset (copy), v18 (copy), v21 (copy), PostFavoriteForAsset (copy), logger (copy)
		if not v25(n6) then
			return Promise.resolve(nil)
		end

		local v41 = v27(n6)

		v30(n6, not v41)

		return ((if not v41 then PostFavoriteForAsset(v18, tostring(v21), (tostring(n6))) else DeleteFavoriteForAsset(v18, tostring(v21), (tostring(n6))))):catch(function(p2) -- line: 106
			-- upvalues: v30 (copy), n6 (copy), v41 (copy), logger (copy)
			v30(n6, v41)
			logger:warning(p2.StatusMessage)
		end):andThenReturn(not v41)
	end, {
		v21,
		v25,
		v27
	})
	local v32 = useMemo(function() -- line: 114
		-- upvalues: Cryo (copy), t1 (copy), v25 (copy), v28 (copy), v29 (copy)
		return Cryo.List.filter(t1, function(n7: number) -- line: 115
			-- upvalues: v25 (copy), v28 (copy), v29 (copy)
			return v25(n7) and (not v28(n7) and not v29(n7))
		end)
	end, Cryo.List.join(t1, {
		v28,
		v29,
		v25
	}))

	useEffect(function() -- line: 120
		-- upvalues: v32 (copy), v24 (copy), v30 (copy), logger (copy), GetFavoriteForAsset (copy), v18 (copy), v21 (copy), StatusCodes (copy)
		for _, v43 in v32 do
			local str = tostring(v43)

			v24.current[str] = true
			v30(v43, false)
			logger:debug(`fetching initial favorite status for asset { v43 }`)
			GetFavoriteForAsset(v18, tostring(v21), str):andThen(function(p3) -- line: 129
				-- upvalues: StatusCodes (copy), v30 (copy), v43 (copy)
				if p3.responseCode == StatusCodes.OK and p3.responseBody then
					v30(v43, true)
				end
			end):catch(function(p4) -- line: 138
				-- upvalues: logger (copy)
				logger:warning(p4.StatusMessage)
			end):finally(function() -- line: 141
				-- upvalues: v24 (copy), str (copy)
				v24.current[str] = nil
			end)
		end
	end, {
		v32,
		v21
	})

	return {
		getAll = v26,
		getByAssetId = v27,
		toggleFavorite = v31,
		isLoading = v29
	}
end

return useAssetFavoriting
