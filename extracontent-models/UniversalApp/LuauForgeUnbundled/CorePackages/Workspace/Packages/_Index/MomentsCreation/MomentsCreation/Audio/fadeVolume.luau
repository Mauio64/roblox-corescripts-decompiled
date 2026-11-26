local TweenService = game:GetService("TweenService")

local audioDuckingFastInts = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon").Media.audioDuckingFastInts

local object = setmetatable({}, { __mode = "k" })

local function fadeVolume(instance, volume, p2)
	local v5 = object[instance]

	if v5 ~= nil then
		v5:Cancel()
		object[instance] = nil
	end

	local compressorParams = audioDuckingFastInts.getCompressorParams()
	local v6

	if p2 then
		v6 = 0
	else
		v6 = if volume < instance.Volume then compressorParams.attack else compressorParams.release
	end

	if v6 <= 0 then
		instance.Volume = volume
		return
	end

	local tween = TweenService:Create(instance, TweenInfo.new(v6, Enum.EasingStyle.Linear), {
		Volume = volume
	})
	object[instance] = tween
	tween:Play()
end

return fadeVolume
