local capturesCommonNetworking = require("@game/CorePackages/Workspace/Packages/_Index/CapturesCommon/CapturesCommon/Networking").CapturesCommonNetworking
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesCommon/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesCommon/RoactUtils")

local AssetType = require("@game/CorePackages/Workspace/Packages/_Index/CapturesCommon/CapturesCommon/Enums/AssetType")
local ThumbnailState = require("@game/CorePackages/Workspace/Packages/_Index/CapturesCommon/CapturesCommon/Enums/ThumbnailState")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useState = React.useState

local defineFastInt = game:DefineFastInt("ContentPostsThumbnailsInitialDelayTimeMs", 100)
local defineFastInt2 = game:DefineFastInt("ContentPostsThumbnailsMaxRetries", 10)

local function makeThumbnailRequest(callback, p2, p3)
	return callback(capturesCommonNetworking.GetThumbnailByAssetId.API({
		assetId = p2,
		assetType = AssetType.Screenshot,
		size = p3
	})):andThen(function(p4)
		local v5 = p4.responseBody.data[1]

		if v5.imageUrl and v5.imageUrl ~= "" and v5.state == ThumbnailState.Completed then
			return v5.imageUrl
		end

		return nil
	end):catch(function(p4): nil
		return nil
	end):await()
end

return function(p2, p3, p4)
	local v5 = useDispatch()

	local state, setState = useState("")
	local state2, setState2 = useState(false)

	local v6 = tostring(p3) .. "x" .. tostring(p4)

	useEffect(function()
		local flag = false
		local v7 = defineFastInt
		local v8 = defineFastInt2

		setState2(false)
		setState("")

		if not p2 then
			return
		end

		task.spawn(function()
			while not flag and v8 > 0 do
				local thumbnailRequest, v9 = makeThumbnailRequest(v5, p2, v6)

				if flag then
					break
				end

				if thumbnailRequest and v9 then
					setState(v9)
					setState2(true)
					break
				end

				task.wait(v7 / 1000)
				v7 *= 2
				v8 -= 1
			end
		end)

		return function()
			flag = true
		end
	end, { p2, v6 })

	return state, state2
end
