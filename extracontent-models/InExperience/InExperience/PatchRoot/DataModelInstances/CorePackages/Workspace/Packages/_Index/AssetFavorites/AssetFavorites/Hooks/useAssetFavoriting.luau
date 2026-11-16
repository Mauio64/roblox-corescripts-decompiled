local AssetFavorites = script:FindFirstAncestor("AssetFavorites")

local Cryo = require(AssetFavorites.Parent.Cryo)
local React = require(AssetFavorites.Parent.React)
local Http = require(AssetFavorites.Parent.Http)
local StatusCodes = Http.StatusCodes
local HttpRequest = require(AssetFavorites.Parent.HttpRequest)

local SharedFlags = require(AssetFavorites.Parent.SharedFlags)
local FFlagLuaAppDefaultHttpRetry = SharedFlags.FFlagLuaAppDefaultHttpRetry
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

local config = HttpRequest.config
local v = { requestFunction = HttpRequest.requestFunctions.RequestInternal, maxRetryCount = 0 }
local maxRetryCount

if FFlagLuaAppDefaultHttpRetry then
	maxRetryCount = game:DefineFastInt("UseAssetFavoritingHttpRetryCount", 4)
end

v.maxRetryCount = maxRetryCount
local v2 = config(v)

local function useAssetFavoriting(p)
	local v3 = useLocalUserId()
	local state, setState = useState({})
	local v4 = useRef({})

	local v5 = useCallback(function(p2: number?): boolean
		if not p2 then
			return false
		end

		if p2 <= 0 or p2 % 1 ~= 0 then
			logger:warning(`validation failed (assetId must be a positive int, got {p2})`)
			return false
		end

		if v3 and not (v3 <= 0) then
			return true
		end

		logger:warning(`validation failed (userId must be a positive int, got {v3})`)
		return false
	end, { v3 })

	local getAll = useCallback(function()
		return state
	end, { state })

	local getByAssetId = useCallback(function(p2: number)
		local v6 = state[tostring(p2)]
		return v6 ~= nil and v6
	end, { state })

	local v6 = useCallback(function(p2: number): boolean
		return state[tostring(p2)] ~= nil
	end, { state })

	local isLoading = useCallback(function(p2: number): boolean
		return v4.current[tostring(p2)] ~= nil
	end, {})

	local v7 = useCallback(function(p2: number, flag: boolean)
		setState(function(p3)
			local clone = table.clone(p3)
			clone[tostring(p2)] = flag
			return clone
		end)
	end, {})

	local toggleFavorite = useCallback(function(p2: number)
		if not v5(p2) then
			return Promise.resolve(nil)
		end

		local v8 = getByAssetId(p2)

		v7(p2, not v8)
		local v9

		if v8 then
			v9 = DeleteFavoriteForAsset(v2, tostring(v3), (tostring(p2)))
		else
			v9 = PostFavoriteForAsset(v2, tostring(v3), (tostring(p2)))
		end

		return v9:catch(function(p3)
			v7(p2, v8)
			logger:warning(p3.StatusMessage)
		end):andThenReturn(not v8)
	end, { v3, v5, getByAssetId })

	local v8 = useMemo(function()
		return Cryo.List.filter(p, function(p2: number)
			return v5(p2) and not (v6(p2) or isLoading(p2))
		end)
	end, Cryo.List.join(p, { v6, isLoading, v5 }))

	useEffect(function()
		for _, v9 in v8 do
			local v10 = tostring(v9)

			v4.current[v10] = true
			v7(v9, false)
			logger:debug(`fetching initial favorite status for asset {v9}`)

			GetFavoriteForAsset(v2, tostring(v3), v10):andThen(function(p2)
				if p2.responseCode == StatusCodes.OK and p2.responseBody then
					v7(v9, true)
				end
			end):catch(function(p2)
				logger:warning(p2.StatusMessage)
			end):finally(function()
				v4.current[v10] = nil
			end)
		end
	end, { v8, v3 })

	return {
		getAll = getAll,
		getByAssetId = getByAssetId,
		toggleFavorite = toggleFavorite,
		isLoading = isLoading
	}
end

return useAssetFavoriting
