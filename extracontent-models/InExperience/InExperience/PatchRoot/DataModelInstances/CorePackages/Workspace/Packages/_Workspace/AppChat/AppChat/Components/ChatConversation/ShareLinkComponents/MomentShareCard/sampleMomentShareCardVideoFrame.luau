local VideoService = game:GetService("VideoService")

local Full = Enum.VideoSampleSize.Full

local function sampleMomentShareCardVideoFrame(p, p2)
	local v = p2 or VideoService
	local v2 = nil
	local success, result = pcall(function()
		v2 = v:CreateVideoSamplerAsync(p, { Size = Full })

		return v2:GetSamplesAtTimesAsync({ 0 })
	end)

	if v2 ~= nil then
		pcall(function()
			v2:Destroy()
		end)
	end

	if not success then
		return nil
	end

	local v3 = result[1]
	local v4
	return if v3 ~= nil then v3.Image else v4
end

return sampleMomentShareCardVideoFrame
