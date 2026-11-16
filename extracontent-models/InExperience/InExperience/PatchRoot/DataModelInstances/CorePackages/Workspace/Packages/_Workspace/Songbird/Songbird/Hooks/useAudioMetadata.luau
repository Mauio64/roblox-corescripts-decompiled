local Songbird = script:FindFirstAncestor("Songbird")

local ReactUtils = require(Songbird.Parent.ReactUtils)
local React = require(Songbird.Parent.React)

require(Songbird.types)
local getAudioMetadataAsync = require(Songbird.Requests.getAudioMetadataAsync)

local useAsync = ReactUtils.useAsync
local useState = React.useState
local useEffect = React.useEffect
local useCallback = React.useCallback

local function useAudioMetadata(list)
	local state, setState = useState({})

	local v = useAsync(function()
		if #list > 0 then
			return getAudioMetadataAsync(list)
		end

		return {}
	end, { table.unpack(list) })

	local getAll = useCallback(function()
		return state
	end, { state })

	local getByAssetId = useCallback(function(p)
		return state[tostring(p)]
	end, { state })

	useEffect(function()
		if v.status == "ok" and #v.value > 0 then
			setState(function(p)
				local clone = table.clone(p)

				for _, v2 in v.value do
					clone[v2.AssetId] = v2
				end

				return clone
			end)
		end
	end, { v })

	return { getAll = getAll, getByAssetId = getByAssetId }
end

return useAudioMetadata
