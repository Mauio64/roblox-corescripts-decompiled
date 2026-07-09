local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local Foundation = require(MomentsCommonParent.Foundation)
local React = require(MomentsCommonParent.React)
local Signals = require(MomentsCommonParent.Signals)
local View = Foundation.View

require(MomentsCommon.Media.MediaTypes)
require(MomentsCommon.Media.mediaNodeRegistry)

local preloadConstants = require(MomentsCommon.Media.Preload.preloadConstants)

local function createScreenshotNode(p1, p2) -- line: 72
	-- upvalues: preloadConstants (copy), Signals (copy), React (copy), View (copy)
	local image = p1.image

	assert(image ~= nil, "createScreenshotNode: spec.image (the screenshot content URI) is required")

	local poster = p1.poster
	local v13 = p1.durationSeconds or preloadConstants.screenshotDurationSeconds
	local v14 = Content.fromUri(image)
	local v15 = if poster == nil then nil else Content.fromUri(poster)
	local v16, v17 = Signals.createSignal(0)
	local v18, v19 = Signals.createSignal(false)
	local v20, v21 = Signals.createSignal(nil)
	local u22 = false
	local u23 = false
	local connection = p2.runService.Heartbeat:Connect(function(dt: number) -- line: 89
		-- upvalues: u23 (ref), u22 (ref), v16 (copy), v13 (copy), v17 (copy)
		if u23 or not u22 then
			return
		end

		local v29 = v16(false) + dt

		if v29 >= v13 then
			v29 %= v13
		end

		v17(v29)
	end)

	local function refreshLoaded() -- line: 104
		-- upvalues: p2 (copy), image (copy), v19 (copy), v21 (copy)
		local AssetFetchStatus = p2.contentProvider:GetAssetFetchStatus(image)

		v19(AssetFetchStatus == Enum.AssetFetchStatus.Success)
		v21(if AssetFetchStatus ~= Enum.AssetFetchStatus.Failure then nil else `screenshot load failed: { AssetFetchStatus.Name }`)
	end

	local connection2 = p2.contentProvider:GetAssetFetchStatusChangedSignal(image):Connect(refreshLoaded)
	local AssetFetchStatus = p2.contentProvider:GetAssetFetchStatus(image)

	v19(AssetFetchStatus == Enum.AssetFetchStatus.Success)
	v21(if AssetFetchStatus ~= Enum.AssetFetchStatus.Failure then nil else `screenshot load failed: { AssetFetchStatus.Name }`)

	return {
		kind = "screenshot",
		usesDecoder = false,
		zIndex = 0,
		id = p1.id,
		assets = function() -- line: 114
			-- upvalues: v15 (copy), v14 (copy)
			if v15 ~= nil then
				return {
					v14,
					v15
				}
			end

			return { v14 }
		end,
		download = function() -- line: 121
			-- upvalues: u23 (ref), v15 (copy), v14 (copy), p2 (copy)
			if u23 then
				return
			end

			local t1 = {}
			local t2, v33, v34

			if v15 ~= nil then
				t2 = {
					v14,
					v15
				}
				v33 = nil
				v34 = nil
			else
				t2 = { v14 }
				v33 = nil
				v34 = nil
			end

			for _, v36 in t2, v33, v34 do
				table.insert(t1, v36.Uri)
			end

			p2.contentProvider:PreloadAsync(t1)
		end,
		render = function(p3) -- line: 154
			-- upvalues: React (copy), View (copy), v15 (copy), v14 (copy)
			return React.createElement(View, {
				tag = "size-full",
				ZIndex = 0
			}, {
				Poster = if v15 == nil then nil else React.createElement("ImageLabel", {
					BackgroundTransparency = 1,
					ZIndex = 1,
					Size = UDim2.fromScale(1, 1),
					ScaleType = p3.scaleType or Enum.ScaleType.Crop,
					ImageContent = v15
				}),
				Base = React.createElement("ImageLabel", {
					BackgroundTransparency = 1,
					ZIndex = 2,
					Size = UDim2.fromScale(1, 1),
					ScaleType = p3.scaleType or Enum.ScaleType.Crop,
					ImageContent = v14,
					ref = p3.setSurface
				})
			})
		end,
		play = function() -- line: 137
			-- upvalues: u22 (ref)
			u22 = true
		end,
		pause = function() -- line: 141
			-- upvalues: u22 (ref)
			u22 = false
		end,
		seek = function(n1: number) -- line: 146
			-- upvalues: v17 (copy), v13 (copy)
			v17((math.clamp(n1, 0, v13)))
		end,
		dispose = function() -- line: 181
			-- upvalues: u23 (ref), u22 (ref), connection (copy), connection2 (copy)
			if u23 then
				return
			end

			u23 = true
			u22 = false
			connection:Disconnect()
			connection2:Disconnect()
		end,
		getPosition = v16,
		getDuration = function() -- line: 150
			-- upvalues: v13 (copy)
			return v13
		end,
		getIsImageLoaded = v18,
		getFailureReason = v20
	}
end

return {
	kind = "screenshot",
	create = createScreenshotNode
}
