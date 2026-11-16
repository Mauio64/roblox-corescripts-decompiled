local MomentsCreation = script:FindFirstAncestor("MomentsCreation")

local GetFFlagMomentsTTSAudioOverlay = require(MomentsCreation.Flags.GetFFlagMomentsTTSAudioOverlay)

local function sampleVideoFrames(p, p2: number, callback, value: number?, p3)
	task.spawn(function()
		local success, result = pcall(function()
			local videoSamplerAsync = (p3 or game:GetService("VideoService")):CreateVideoSamplerAsync(p)
			local v = value or 0
			local v2 = {}
			local v3

			if GetFFlagMomentsTTSAudioOverlay then
				v3 = math.max(1, (math.floor(p2)))
			else
				v3 = math.floor(p2)
			end

			for i = 0, v3 - 1 do
				table.insert(v2, v + i)
			end

			return videoSamplerAsync:GetSamplesAtTimesAsync(v2)
		end)

		if success then
			callback(result)
		else
			callback({})
		end
	end)
end

return sampleVideoFrames
