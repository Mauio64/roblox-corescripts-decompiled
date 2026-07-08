local Songbird = script:FindFirstAncestor("Songbird")
local ReactUtils = require(Songbird.Parent.ReactUtils)
local React = require(Songbird.Parent.React)

require(Songbird.types)

local getAudioMetadataAsync = require(Songbird.Requests.getAudioMetadataAsync)
local useAsync = ReactUtils.useAsync
local useState = React.useState
local useEffect = React.useEffect
local useCallback = React.useCallback

local function useAudioMetadata(t1: {[any]: any}) -- line: 19
	-- upvalues: useState (copy), useAsync (copy), getAudioMetadataAsync (copy), useCallback (copy), useEffect (copy)
	local v11, v12 = useState({})
	local v13 = useAsync(function() -- line: 25
		-- upvalues: t1 (copy), getAudioMetadataAsync (copy)
		if #t1 > 0 then
			return getAudioMetadataAsync(t1)
		end

		return {}
	end, { table.unpack(t1) })
	local v14 = useCallback(function() -- line: 33
		-- upvalues: v11 (copy)
		return v11
	end, { v11 })
	local v15 = useCallback(function(p1) -- line: 37
		-- upvalues: v11 (copy)
		return v11[tostring(p1)]
	end, { v11 })

	useEffect(function() -- line: 41
		-- upvalues: v13 (copy), v12 (copy)
		if v13.status == "ok" and #v13.value > 0 then
			v12(function(p2) -- line: 43
				-- upvalues: v13 (copy)
				local v18 = table.clone(p2)

				for _, v20 in v13.value do
					v18[v20.AssetId] = v20
				end

				return v18
			end)
		end
	end, { v13 })

	return {
		getAll = v14,
		getByAssetId = v15
	}
end

return useAudioMetadata
