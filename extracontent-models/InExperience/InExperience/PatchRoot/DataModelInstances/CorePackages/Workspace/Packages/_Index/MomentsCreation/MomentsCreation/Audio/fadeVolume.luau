local TweenService = game:GetService("TweenService")

local parent = script:FindFirstAncestor("MomentsCreation").Parent

local MomentsCommon = require(parent.MomentsCommon)
local audioDuckingFastInts = MomentsCommon.Media.audioDuckingFastInts

local object = setmetatable({}, { __mode = "k" })

local function fadeVolume(instance, volume: number, flag: boolean?)
	local v = object[instance]

	if v ~= nil then
		v:Cancel()
		object[instance] = nil
	end

	local compressorParams = audioDuckingFastInts.getCompressorParams()
	local v2

	if flag then
		v2 = 0
	elseif volume < instance.Volume then
		v2 = compressorParams.attack
	else
		v2 = compressorParams.release
	end

	if v2 <= 0 then
		instance.Volume = volume
		return
	end

	local tween = TweenService:Create(instance, TweenInfo.new(v2, Enum.EasingStyle.Linear), {
		Volume = volume
	})
	object[instance] = tween
	tween:Play()
end

return fadeVolume
