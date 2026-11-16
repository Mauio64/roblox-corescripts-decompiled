local ReactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/ReactUtils")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/types")
local getAudioMetadataAsync = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Requests/getAudioMetadataAsync")

local useAsync = ReactUtils.useAsync
local useState = React.useState
local useEffect = React.useEffect
local useCallback = React.useCallback

local function useAudioMetadata(list)
	local state, setState = useState({})

	local v5 = useAsync(function()
		if #list > 0 then
			return getAudioMetadataAsync(list)
		end

		return {}
	end, { table.unpack(list) })

	local v6 = useCallback(function()
		return state
	end, { state })

	local v7 = useCallback(function(p2)
		return state[tostring(p2)]
	end, { state })

	useEffect(function()
		if v5.status == "ok" and #v5.value > 0 then
			setState(function(p2)
				local clone = table.clone(p2)

				for k, v8 in v5.value do
					clone[v8.AssetId] = v8
				end

				return clone
			end)
		end
	end, { v5 })

	return { getAll = v6, getByAssetId = v7 }
end

return useAudioMetadata
