local GetFFlagMomentsTTSAudioOverlay = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/GetFFlagMomentsTTSAudioOverlay")

local function sampleVideoFrames(p2, p3, callback, value, p4)
	task.spawn(function()
		local success, result = pcall(function()
			local videoSamplerAsync = (p4 or game:GetService("VideoService")):CreateVideoSamplerAsync(p2)
			local v5 = value or 0
			local v6 = {}

			local v7 = if GetFFlagMomentsTTSAudioOverlay then math.max(1, (math.floor(p3))) else math.floor(p3)

			for i = 0, v7 - 1 do
				table.insert(v6, v5 + i)
			end

			return videoSamplerAsync:GetSamplesAtTimesAsync(v6)
		end)

		if success then
			callback(result)
		else
			callback({})
		end
	end)
end

return sampleVideoFrames
