local parent = script.Parent.Parent
local parent2 = parent.Parent

local Networking = require(parent.Networking)
local CapturesCommonNetworking = Networking.CapturesCommonNetworking
local React = require(parent2.React)
local RoactUtils = require(parent2.RoactUtils)

local AssetType = require(parent.Enums.AssetType)
local ThumbnailState = require(parent.Enums.ThumbnailState)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useState = React.useState

local defineFastInt = game:DefineFastInt("ContentPostsThumbnailsInitialDelayTimeMs", 100)
local defineFastInt2 = game:DefineFastInt("ContentPostsThumbnailsMaxRetries", 10)

local function makeThumbnailRequest(callback, assetId: number, size: string)
	return callback(CapturesCommonNetworking.GetThumbnailByAssetId.API({
		assetId = assetId,
		assetType = AssetType.Screenshot,
		size = size
	})):andThen(function(p)
		local v = p.responseBody.data[1]

		if v.imageUrl and v.imageUrl ~= "" and v.state == ThumbnailState.Completed then
			return v.imageUrl
		end

		return nil
	end):catch(function(_): nil
		return nil
	end):await()
end

return function(p: number?, p2: number, p3: number)
	local v = useDispatch()

	local state, setState = useState("")
	local state2, setState2 = useState(false)

	local v2 = tostring(p2) .. "x" .. tostring(p3)

	useEffect(function()
		local flag = false
		local v3 = defineFastInt
		local v4 = defineFastInt2

		setState2(false)
		setState("")

		if not p then
			return
		end

		task.spawn(function()
			while not flag and v4 > 0 do
				local thumbnailRequest, v5 = makeThumbnailRequest(v, p, v2)

				if flag then
					break
				end

				if thumbnailRequest and v5 then
					setState(v5)
					setState2(true)
					break
				end

				task.wait(v3 / 1000)
				v3 *= 2
				v4 -= 1
			end
		end)

		return function()
			flag = true
		end
	end, { p, v2 })

	return state, state2
end
