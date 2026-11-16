local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AssetFavorites/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AssetFavorites/React")
local statusCodes = require("@game/CorePackages/Workspace/Packages/_Workspace/AssetFavorites/Http").StatusCodes
local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/AssetFavorites/HttpRequest")

local fFlagLuaAppDefaultHttpRetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AssetFavorites/SharedFlags").FFlagLuaAppDefaultHttpRetry
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Index/AssetFavorites/AssetFavorites/Hooks/useLocalUserId")
local GetFavoriteForAsset = require("@game/CorePackages/Workspace/Packages/_Index/AssetFavorites/AssetFavorites/Requests/GetFavoriteForAsset")
local PostFavoriteForAsset = require("@game/CorePackages/Workspace/Packages/_Index/AssetFavorites/AssetFavorites/Requests/PostFavoriteForAsset")
local DeleteFavoriteForAsset = require("@game/CorePackages/Workspace/Packages/_Index/AssetFavorites/AssetFavorites/Requests/DeleteFavoriteForAsset")
require("@game/CorePackages/Workspace/Packages/_Workspace/AssetFavorites/LuauPolyfill")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AssetFavorites/Promise")
local logger = require("@game/CorePackages/Workspace/Packages/_Index/AssetFavorites/AssetFavorites/logger")

local useCallback = React.useCallback
local useEffect = React.useEffect
local useState = React.useState
local useRef = React.useRef
local useMemo = React.useMemo

local config = HttpRequest.config
local v5 = {
	requestFunction = HttpRequest.requestFunctions.RequestInternal,
	maxRetryCount = 0
}

local v6 = if fFlagLuaAppDefaultHttpRetry then game:DefineFastInt("UseAssetFavoritingHttpRetryCount", 4) else nil
v5.maxRetryCount = v6
local v7 = config(v5)

local function useAssetFavoriting(p2)
	local v8 = useLocalUserId()
	local state, setState = useState({})
	local v9 = useRef({})

	local v10 = useCallback(function(p3): boolean
		if not p3 then
			return false
		end

		if p3 <= 0 or p3 % 1 ~= 0 then
			logger:warning(`validation failed (assetId must be a positive int, got {p3})`)
			return false
		end

		if v8 and not (v8 <= 0) then
			return true
		end

		logger:warning(`validation failed (userId must be a positive int, got {v8})`)
		return false
	end, { v8 })

	local v11 = useCallback(function()
		return state
	end, { state })

	local v12 = useCallback(function(p3)
		local v13 = state[tostring(p3)]

		if v13 == nil then
			return false
		end

		return v13
	end, { state })

	local v13 = useCallback(function(p3): boolean
		return state[tostring(p3)] ~= nil
	end, { state })

	local v14 = useCallback(function(p3): boolean
		return v9.current[tostring(p3)] ~= nil
	end, {})

	local v15 = useCallback(function(p3, p4)
		setState(function(p5)
			local clone = table.clone(p5)
			clone[tostring(p3)] = p4
			return clone
		end)
	end, {})

	local v16 = useCallback(function(p3)
		if not v10(p3) then
			return Promise.resolve(nil)
		end

		local v17 = v12(p3)

		v15(p3, not v17)
		local v18

		if v17 then
			v18 = DeleteFavoriteForAsset(v7, tostring(v8), (tostring(p3)))
		else
			v18 = PostFavoriteForAsset(v7, tostring(v8), (tostring(p3)))
		end

		return v18:catch(function(p4)
			v15(p3, v17)
			logger:warning(p4.StatusMessage)
		end):andThenReturn(not v17)
	end, { v8, v10, v12 })

	local v17 = useMemo(function()
		return Cryo.List.filter(p2, function(p3)
			return v10(p3) and not (v13(p3) or v14(p3))
		end)
	end, Cryo.List.join(p2, { v13, v14, v10 }))

	useEffect(function()
		for k, v18 in v17 do
			local v19 = tostring(v18)

			v9.current[v19] = true
			v15(v18, false)
			logger:debug(`fetching initial favorite status for asset {v18}`)

			GetFavoriteForAsset(v7, tostring(v8), v19):andThen(function(p3)
				if p3.responseCode == statusCodes.OK and p3.responseBody then
					v15(v18, true)
				end
			end):catch(function(p3)
				logger:warning(p3.StatusMessage)
			end):finally(function()
				v9.current[v19] = nil
			end)
		end
	end, { v17, v8 })

	return { getAll = v11, getByAssetId = v12, toggleFavorite = v16, isLoading = v14 }
end

return useAssetFavoriting
