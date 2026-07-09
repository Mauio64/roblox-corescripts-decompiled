local MusicTestingUtils = script:FindFirstAncestor("MusicTestingUtils")

require(MusicTestingUtils.Parent.Songbird)

local function createSoundAndMetadata(n1: number, p1) -- line: 7
	local Sound = Instance.new("Sound")

	Sound.SoundId = `rbxassetid://{ n1 }`

	local t1 = {
		Title = "Sample Title",
		Artist = "Sample Artist",
		Duration = 120,
		AssetId = `{ n1 }`,
		RecordingCode = `recording-code-{ n1 }`,
		AudioType = p1
	}

	return {
		sound = Sound,
		metadata = t1
	}
end

return createSoundAndMetadata
