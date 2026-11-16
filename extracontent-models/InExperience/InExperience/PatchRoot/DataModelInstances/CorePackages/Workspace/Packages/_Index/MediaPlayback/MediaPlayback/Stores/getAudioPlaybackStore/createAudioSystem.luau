local MediaPlayback = script:FindFirstAncestor("MediaPlayback")

local CoreGui = game:GetService("CoreGui")

local assetIdAsContent = require(MediaPlayback.Common.assetIdAsContent)
local getFFlagAudioPreviewLua = require(MediaPlayback.Flags.getFFlagAudioPreviewLua)

local function getOrCreateInstances(CoreGui2)
	local audioPlayback = CoreGui2:FindFirstChild("AudioPlayback")
	local audioDeviceOutput

	if audioPlayback then
		audioDeviceOutput = audioPlayback:FindFirstChildWhichIsA("AudioDeviceOutput")
	end

	if audioPlayback and audioDeviceOutput then
		return { container = audioPlayback, audioOutput = audioDeviceOutput }
	end

	local audioPlayback2 = Instance.new("Folder")
	audioPlayback2.Name = "AudioPlayback"

	local audioDeviceOutput2 = Instance.new("AudioDeviceOutput")

	audioDeviceOutput2.Parent = audioPlayback2

	audioPlayback2.Parent = CoreGui2

	return { container = audioPlayback2, audioOutput = audioDeviceOutput2 }
end

local function createAudioSystem(p, flag: boolean?)
	local instances = getOrCreateInstances(CoreGui)

	local audioPlayer = Instance.new("AudioPlayer")

	audioPlayer.Asset = assetIdAsContent(p)
	audioPlayer.Name = `AudioPlayer_{audioPlayer.Asset}`

	if getFFlagAudioPreviewLua() and flag then
		audioPlayer.AssetRepresentation = Enum.AssetRepresentation.ShortPreview
	end

	audioPlayer.Parent = instances.container

	audioPlayer.PlaybackSpeed = 0
	audioPlayer:Play()

	local wire = Instance.new("Wire")
	wire.SourceInstance = audioPlayer
	wire.TargetInstance = instances.audioOutput
	wire.Parent = audioPlayer
	return {
		audioPlayer = audioPlayer,
		destroy = function()
			audioPlayer:Destroy()

			if not instances.container:FindFirstChildWhichIsA("AudioPlayer") then
				instances.container:Destroy()
			end
		end
	}
end

return createAudioSystem
