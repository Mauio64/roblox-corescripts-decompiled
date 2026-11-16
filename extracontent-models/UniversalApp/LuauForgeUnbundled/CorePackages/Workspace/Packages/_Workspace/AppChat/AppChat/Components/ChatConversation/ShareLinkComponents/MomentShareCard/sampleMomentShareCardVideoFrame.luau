local VideoService = game:GetService("VideoService")

local full = Enum.VideoSampleSize.Full

local function sampleMomentShareCardVideoFrame(p2, p3)
	local v5 = p3 or VideoService
	local v6 = nil
	local success, result = pcall(function()
		v6 = v5:CreateVideoSamplerAsync(p2, { Size = full })

		return v6:GetSamplesAtTimesAsync({ 0 })
	end)

	if v6 ~= nil then
		pcall(function()
			v6:Destroy()
		end)
	end

	if not success then
		return nil
	end

	local v7 = result[1]
	return if v7 ~= nil then v7.Image else nil
end

return sampleMomentShareCardVideoFrame
