local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local parent = MomentsCommon.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Signals = require(parent.Signals)

local View = Foundation.View

require(MomentsCommon.Media.MediaTypes)
require(MomentsCommon.Media.mediaNodeRegistry)
local preloadFastInts = require(MomentsCommon.Media.Preload.preloadFastInts)
local FFlagMomentsPreloadScreenshotImageLabel = require(MomentsCommon.Flags.FFlagMomentsPreloadScreenshotImageLabel)

local function renderCorner(cornerRadius) -- 2 equivalent calls inferred from this helper
	if cornerRadius == nil then
		return nil
	end

	return (React.createElement("UICorner", { CornerRadius = cornerRadius }))
end

local function createScreenshotNode(data, p)
	local image = data.image
	assert(image ~= nil or data.imageContent ~= nil, "createScreenshotNode: screenshot content is required")
	local poster = data.poster
	local durationSeconds = data.durationSeconds or preloadFastInts.getScreenshotDurationSeconds()

	local imageContent = data.imageContent or Content.fromUri(image)
	local imageContent2 = data.posterContent

	if not imageContent2 then
		if poster == nil then
			imageContent2 = nil
		else
			imageContent2 = Content.fromUri(poster)
		end
	end

	local signal, v = Signals.createSignal(0)
	local signal2, v2 = Signals.createSignal(false)
	local signal3, v3 = Signals.createSignal(nil)

	local v4 = false
	local flag = false

	local heartbeatConnection = p.runService.Heartbeat:Connect(function(dt: number)
		if flag or not v4 then
			return
		end

		local v5 = signal(false) + dt

		if durationSeconds <= v5 then
			v5 %= durationSeconds
		end

		v(v5)
	end)

	local function refreshLoaded() -- 1 equivalent call inferred from this helper
		local assetFetchStatus = p.contentProvider:GetAssetFetchStatus(image)
		v2(assetFetchStatus == Enum.AssetFetchStatus.Success)
		local v5

		if assetFetchStatus == Enum.AssetFetchStatus.Failure then
			v5 = `screenshot load failed: {assetFetchStatus.Name}`
		end

		v3(v5)
	end
	local connection = nil

	if image == nil then
		v2(true)
	else
		connection = p.contentProvider:GetAssetFetchStatusChangedSignal(image):Connect(refreshLoaded)
		refreshLoaded() -- inferred equivalent call
	end

	local function assets() -- 1 equivalent call inferred from this helper
		if imageContent2 == nil then
			return { imageContent }
		end

		return { imageContent, imageContent2 }
	end

	local function download()
		if flag then
			return
		end

		if FFlagMomentsPreloadScreenshotImageLabel then
			local v5 = {}
			local imageLabel

			if imageContent.Uri ~= nil then
				imageLabel = Instance.new("ImageLabel")
				imageLabel.Image = imageContent.Uri

				table.insert(v5, imageLabel)
			end

			if imageContent2 ~= nil and imageContent2.Uri ~= nil then
				table.insert(v5, imageContent2.Uri)
			end

			if #v5 > 0 then
				p.contentProvider:PreloadAsync(v5)
			end

			if imageLabel ~= nil then
				imageLabel:Destroy()
			end
		else
			local uris = {}
			local v5 = assets() -- inferred equivalent call

			for _, v6 in v5 do
				if v6.Uri ~= nil then
					table.insert(uris, v6.Uri)
				end
			end

			if #uris > 0 then
				p.contentProvider:PreloadAsync(uris)
			end
		end
	end

	local function play()
		v4 = true
	end

	local function pause()
		v4 = false
	end

	local function dispose()
		if flag then
			return
		end

		flag = true
		v4 = false
		heartbeatConnection:Disconnect()

		if connection ~= nil then
			connection:Disconnect()
		end
	end

	return {
		id = data.id,
		kind = "screenshot",
		assets = assets,
		download = download,
		usesDecoder = false,
		zIndex = 0,
		render = function(props)
			local createElement = React.createElement
			local poster2

			if imageContent2 ~= nil then
				poster2 = React.createElement("ImageLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					ScaleType = props.scaleType or Enum.ScaleType.Crop,
					ImageContent = imageContent2,
					ZIndex = 1
				}, {
					Corner = renderCorner(props.cornerRadius) -- inferred equivalent call
				})
			end

			return createElement(View, { tag = "size-full", ZIndex = 0 }, {
				Poster = poster2,
				Base = React.createElement("ImageLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					ScaleType = props.scaleType or Enum.ScaleType.Crop,
					ImageContent = imageContent,
					ZIndex = 2,
					ref = props.setSurface
				}, {
					Corner = renderCorner(props.cornerRadius) -- inferred equivalent call
				})
			})
		end,
		play = play,
		pause = pause,
		seek = function(value: number)
			v((math.clamp(value, 0, durationSeconds)))
		end,
		dispose = dispose,
		getPosition = signal,
		getDuration = function()
			return durationSeconds
		end,
		getIsImageLoaded = signal2,
		getFailureReason = signal3
	}
end

return { kind = "screenshot", create = createScreenshotNode }
