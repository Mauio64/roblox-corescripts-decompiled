local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/Signals")

local view = Foundation.View

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/MediaTypes")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/mediaNodeRegistry")
local preloadFastInts = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/Preload/preloadFastInts")
local FFlagMomentsPreloadScreenshotImageLabel = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/FFlagMomentsPreloadScreenshotImageLabel")

local function renderCorner(p2)
	if p2 == nil then
		return nil
	end

	return (React.createElement("UICorner", { CornerRadius = p2 }))
end

local function createScreenshotNode(data, p2)
	local image = data.image
	assert(image ~= nil or data.imageContent ~= nil, "createScreenshotNode: screenshot content is required")
	local poster = data.poster
	local durationSeconds = data.durationSeconds or preloadFastInts.getScreenshotDurationSeconds()

	local imageContent = data.imageContent or Content.fromUri(image)
	local v5 = data.posterContent

	if not v5 then
		v5 = if poster ~= nil then Content.fromUri(poster) else nil
	end

	local signal, v6 = Signals.createSignal(0)
	local signal2, v7 = Signals.createSignal(false)
	local signal3, v8 = Signals.createSignal(nil)

	local v9 = false
	local flag = false

	local heartbeatConnection = p2.runService.Heartbeat:Connect(function(dt)
		if flag or not v9 then
			return
		end

		local v10 = signal(false) + dt

		if durationSeconds <= v10 then
			v10 %= durationSeconds
		end

		v6(v10)
	end)

	local function refreshLoaded()
		local assetFetchStatus = p2.contentProvider:GetAssetFetchStatus(image)
		v7(assetFetchStatus == Enum.AssetFetchStatus.Success)

		local v11 = if assetFetchStatus == Enum.AssetFetchStatus.Failure then `screenshot load failed: {assetFetchStatus.Name}` else nil
		v8(v11)
	end
	local connection = nil

	if image == nil then
		v7(true)
	else
		connection = p2.contentProvider:GetAssetFetchStatusChangedSignal(image):Connect(refreshLoaded)
		local assetFetchStatus = p2.contentProvider:GetAssetFetchStatus(image)
		v7(assetFetchStatus == Enum.AssetFetchStatus.Success)

		local v10 = if assetFetchStatus == Enum.AssetFetchStatus.Failure then `screenshot load failed: {assetFetchStatus.Name}` else nil
		v8(v10)
	end

	local function download()
		if flag then
			return
		end

		if FFlagMomentsPreloadScreenshotImageLabel then
			local v10 = {}
			local imageLabel

			if imageContent.Uri ~= nil then
				imageLabel = Instance.new("ImageLabel")
				imageLabel.Image = imageContent.Uri

				table.insert(v10, imageLabel)
			end

			if v5 ~= nil and v5.Uri ~= nil then
				table.insert(v10, v5.Uri)
			end

			if #v10 > 0 then
				p2.contentProvider:PreloadAsync(v10)
			end

			if imageLabel ~= nil then
				imageLabel:Destroy()
			end
		else
			local uris = {}
			local v10

			if v5 == nil then
				v10 = { imageContent }
			else
				v10 = { imageContent, v5 }
			end

			for k, v13 in v10 do
				if v13.Uri ~= nil then
					table.insert(uris, v13.Uri)
				end
			end

			if #uris > 0 then
				p2.contentProvider:PreloadAsync(uris)
			end
		end
	end

	local function play()
		v9 = true
	end

	local function pause()
		v9 = false
	end

	local function dispose()
		if flag then
			return
		end

		flag = true
		v9 = false
		heartbeatConnection:Disconnect()

		if connection ~= nil then
			connection:Disconnect()
		end
	end

	return {
		id = data.id,
		kind = "screenshot",
		assets = function()
			if v5 == nil then
				return { imageContent }
			end

			return { imageContent, v5 }
		end,
		download = download,
		usesDecoder = false,
		zIndex = 0,
		render = function(props)
			local createElement = React.createElement
			local v13

			if v5 ~= nil then
				local createElement2 = React.createElement
				local v15 = {
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					ScaleType = props.scaleType or Enum.ScaleType.Crop,
					ImageContent = v5,
					ZIndex = 1
				}

				local cornerRadius = props.cornerRadius
				local v17 = if cornerRadius ~= nil then React.createElement("UICorner", {
					CornerRadius = cornerRadius
				}) else nil

				v13 = createElement2("ImageLabel", v15, { Corner = v17 })
			end

			local createElement2 = React.createElement
			local v15 = {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				ScaleType = props.scaleType or Enum.ScaleType.Crop,
				ImageContent = imageContent,
				ZIndex = 2,
				ref = props.setSurface
			}

			local cornerRadius = props.cornerRadius
			local v17 = if cornerRadius ~= nil then React.createElement("UICorner", {
				CornerRadius = cornerRadius
			}) else nil

			return createElement(view, { tag = "size-full", ZIndex = 0 }, {
				Poster = v13,
				Base = createElement2("ImageLabel", v15, { Corner = v17 })
			})
		end,
		play = play,
		pause = pause,
		seek = function(value)
			v6((math.clamp(value, 0, durationSeconds)))
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
