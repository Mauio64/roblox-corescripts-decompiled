local MomentsCommon = script:FindFirstAncestor("MomentsCommon")

require(MomentsCommon.Media.MediaTypes)
require(MomentsCommon.Media.mediaNodeRegistry)

local function toAssetUri(p1) -- line: 76
	if typeof(p1) == "string" and string.find(p1, "://") ~= nil then
		return p1
	end

	return `rbxassetid://{ p1 }`
end
local function createMusicNode(p2, p3) -- line: 83
	local parent = p2.parent

	assert(parent ~= nil, "createMusicNode: spec.parent (the item media folder) is required")

	local assetId = p2.assetId
	local v9 = if typeof(assetId) ~= "string" or string.find(assetId, "://") == nil then `rbxassetid://{ assetId }` else assetId
	local v10 = Content.fromUri(v9)
	local v11 = p2.startTime or 0
	local trimmedLen = p2.trimmedLen
	local t1 = {
		startTime = v11,
		endTime = if trimmedLen == nil then nil else v11 + trimmedLen
	}
	local v14 = p2.volume or 1
	local AudioPlayer = Instance.new("AudioPlayer")

	AudioPlayer.Name = `Music_{ p2.id }`
	AudioPlayer.AudioContent = v10
	AudioPlayer.PlaybackSpeed = 0
	AudioPlayer.TimePosition = v11
	AudioPlayer.Parent = parent

	local u16 = false

	return {
		kind = "music",
		usesDecoder = false,
		id = p2.id,
		assets = function() -- line: 109
			-- upvalues: v10 (copy)
			return { v10 }
		end,
		download = function() -- line: 113
			-- upvalues: u16 (ref), p3 (copy), v10 (copy)
			if u16 then
				return
			end

			p3.contentProvider:PreloadAsync({ v10.Uri })
		end,
		getAudioSource = function() -- line: 123
			-- upvalues: AudioPlayer (copy)
			return AudioPlayer
		end,
		audioStem = {
			stemId = p2.id,
			defaultVolume = v14
		},
		play = function() -- line: 127
			-- upvalues: u16 (ref), AudioPlayer (copy)
			if u16 then
				return
			end

			AudioPlayer.PlaybackSpeed = 1

			if not AudioPlayer.IsPlaying then
				AudioPlayer:Play()
			end
		end,
		pause = function() -- line: 137
			-- upvalues: u16 (ref), AudioPlayer (copy)
			if u16 then
				return
			end

			AudioPlayer.PlaybackSpeed = 0
		end,
		seek = function(n1: number) -- line: 146
			-- upvalues: u16 (ref), v11 (copy), AudioPlayer (copy)
			if u16 then
				return
			end

			local v18 = v11 + n1
			local TimeLength = AudioPlayer.TimeLength

			if TimeLength > 0 then
				v18 = math.clamp(v18, 0, TimeLength)
			end

			AudioPlayer.TimePosition = v18
		end,
		realignToRegionStart = function() -- line: 158
			-- upvalues: u16 (ref), AudioPlayer (copy), v11 (copy)
			if u16 then
				return
			end

			AudioPlayer.TimePosition = v11
		end,
		getRegion = function() -- line: 165
			-- upvalues: t1 (copy)
			return t1
		end,
		dispose = function() -- line: 169
			-- upvalues: u16 (ref), AudioPlayer (copy)
			if u16 then
				return
			end

			u16 = true
			AudioPlayer:Destroy()
		end
	}
end

return {
	kind = "music",
	create = createMusicNode
}
