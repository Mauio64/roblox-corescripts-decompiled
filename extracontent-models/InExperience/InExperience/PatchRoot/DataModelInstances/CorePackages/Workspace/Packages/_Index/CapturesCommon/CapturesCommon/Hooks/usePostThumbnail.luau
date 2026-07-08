local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local CapturesCommonNetworking = require(ParentParent.Networking).CapturesCommonNetworking
local React = require(ParentParentParent.React)
local RoactUtils = require(ParentParentParent.RoactUtils)
local AssetType = require(ParentParent.Enums.AssetType)
local ThumbnailState = require(ParentParent.Enums.ThumbnailState)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useState = React.useState
local v11 = game:DefineFastInt("ContentPostsThumbnailsInitialDelayTimeMs", 100)
local v12 = game:DefineFastInt("ContentPostsThumbnailsMaxRetries", 10)

local function makeThumbnailRequest(p1, n1: number, s1: string) -- line: 20
	-- upvalues: CapturesCommonNetworking (copy), AssetType (copy), ThumbnailState (copy)
	return p1(CapturesCommonNetworking.GetThumbnailByAssetId.API({
		assetId = n1,
		assetType = AssetType.Screenshot,
		size = s1
	})):andThen(function(p2) -- line: 26
		-- upvalues: ThumbnailState (copy)
		local v27 = p2.responseBody.data[1]

		if v27.imageUrl and (v27.imageUrl ~= "" and v27.state == ThumbnailState.Completed) then
			return v27.imageUrl
		end

		return nil
	end):catch(function(_) -- line: 38
		return nil
	end):await()
end

return function(n2: number?, n3: number, n4: number) -- line: 44
	-- upvalues: useDispatch (copy), useState (copy), useEffect (copy), v11 (copy), v12 (copy), makeThumbnailRequest (copy)
	local v20 = useDispatch()
	local v21, v22 = useState("")
	local v23, v24 = useState(false)
	local v25 = tostring(n3) .. "x" .. tostring(n4)

	useEffect(function() -- line: 52
		-- upvalues: v11 (copy), v12 (copy), v24 (copy), v22 (copy), n2 (copy), makeThumbnailRequest (copy), v20 (copy), v25 (copy)
		local u29 = false
		local u30 = v11
		local u31 = v12

		v24(false)
		v22("")

		if not n2 then
			return
		end

		task.spawn(function() -- line: 64
			-- upvalues: u29 (ref), u31 (ref), makeThumbnailRequest (copy), v20 (copy), n2 (copy), v25 (copy), v22 (copy), v24 (copy), u30 (ref)
			while not u29 and u31 > 0 do
				local v32, v33 = makeThumbnailRequest(v20, n2, v25)

				if u29 then
					return
				end

				if v32 and v33 then
					v22(v33)
					v24(true)

					return
				end

				task.wait(u30 / 1000)
				u30 *= 2
				u31 -= 1
			end
		end)

		return function() -- line: 84
			-- upvalues: u29 (ref)
			u29 = true
		end
	end, {
		n2,
		v25
	})

	return v21, v23
end
