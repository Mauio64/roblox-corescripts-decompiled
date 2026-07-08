local MediaPlayback = script:FindFirstAncestor("MediaPlayback")
local CoreGui = game:GetService("CoreGui")
local assetIdAsContent = require(MediaPlayback.Common.assetIdAsContent)
local getFFlagAudioPreviewLua = require(MediaPlayback.Flags.getFFlagAudioPreviewLua)

local function getOrCreateInstances(p1) -- line: 15
	local AudioPlayback = p1:FindFirstChild("AudioPlayback")
	local v9 = if not AudioPlayback then nil else AudioPlayback:FindFirstChildWhichIsA("AudioDeviceOutput")

	if AudioPlayback and v9 then
		return {
			container = AudioPlayback,
			audioOutput = v9
		}
	end

	local Folder = Instance.new("Folder")

	Folder.Name = "AudioPlayback"

	local AudioDeviceOutput = Instance.new("AudioDeviceOutput")

	AudioDeviceOutput.Parent = Folder
	Folder.Parent = p1

	return {
		container = Folder,
		audioOutput = AudioDeviceOutput
	}
end
local function createAudioSystem(p2, b1: boolean?) -- line: 43
	-- upvalues: getOrCreateInstances (copy), CoreGui (copy), assetIdAsContent (copy), getFFlagAudioPreviewLua (copy)
	local v14 = getOrCreateInstances(CoreGui)
	local AudioPlayer = Instance.new("AudioPlayer")

	AudioPlayer.Asset = assetIdAsContent(p2)
	AudioPlayer.Name = `AudioPlayer_{ AudioPlayer.Asset }`

	if getFFlagAudioPreviewLua() and b1 then
		AudioPlayer.AssetRepresentation = Enum.AssetRepresentation.ShortPreview
	end

	AudioPlayer.Parent = v14.container
	AudioPlayer.PlaybackSpeed = 0
	AudioPlayer:Play()

	local Wire = Instance.new("Wire")

	Wire.SourceInstance = AudioPlayer
	Wire.TargetInstance = v14.audioOutput
	Wire.Parent = AudioPlayer

	return {
		audioPlayer = AudioPlayer,
		destroy = function() -- line: 78
			-- upvalues: AudioPlayer (copy), v14 (copy)
			AudioPlayer:Destroy()

			if not v14.container:FindFirstChildWhichIsA("AudioPlayer") then
				v14.container:Destroy()
			end
		end
	}
end

return createAudioSystem
