local Songbird = script:FindFirstAncestor("Songbird")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(Songbird.Parent.React)
local getFFlagDebugMusicSampleSounds = require(Songbird.Flags.getFFlagDebugMusicSampleSounds)

local useEffect = React.useEffect

local v = {
	{
		className = "Sound",
		title = "Beach Morning LoFi",
		assetId = "rbxassetid://83784623771159",
		position = Vector3.new(50, 0, 0)
	},
	{
		className = "AudioPlayer",
		title = "Mirage Portal",
		assetId = "rbxassetid://75793628822368",
		position = Vector3.new(-50, 0, 0)
	},
	{
		className = "Sound",
		title = "Altogether Elsewhere",
		assetId = "rbxassetid://73856926671353",
		position = Vector3.new(0, 0, 50)
	},
	{
		className = "Sound",
		title = "Shiawase",
		assetId = "rbxassetid://5409360995",
		position = Vector3.new(0, 0, -50)
	},
	{
		className = "Sound",
		title = "Life in an Elevator",
		assetId = "rbxassetid://1841647093",
		position = Vector3.new(100, 0, 0),
		shouldSurfaceToUser = false
	},
	{
		className = "Sound",
		title = "Explosion",
		assetId = "rbxassetid://157878578",
		position = Vector3.new(0, 0, 100),
		shouldSurfaceToUser = false
	}
}

local function spawnAudioEmitter(data)
	local part = Instance.new("Part")
	part.Position = data.position
	part.Anchored = true
	part.Name = data.title

	if data.className == "Sound" then
		local sound = Instance.new("Sound")
		sound.SoundId = data.assetId
		sound.Looped = true
		sound.RollOffMinDistance = 10
		sound.RollOffMaxDistance = 40
		sound.Parent = part
		sound:Play()
	else
		local audioPlayer = Instance.new("AudioPlayer")

		audioPlayer.Asset = data.assetId

		audioPlayer.Looping = true
		audioPlayer.Parent = part

		local audioEmitter = Instance.new("AudioEmitter")
		audioEmitter.Parent = part

		local wire = Instance.new("Wire")
		wire.SourceInstance = audioPlayer
		wire.TargetInstance = audioEmitter
		wire.Parent = audioPlayer

		audioPlayer:Play()
	end

	part.Parent = workspace

	return part
end

local function DebugAudioEmitters(): nil
	if getFFlagDebugMusicSampleSounds() then
		useEffect(function()
			local audioListener = Instance.new("AudioListener")

			local audioDeviceOutput = Instance.new("AudioDeviceOutput")
			audioDeviceOutput.Parent = audioListener

			local wire = Instance.new("Wire")
			wire.SourceInstance = audioListener
			wire.TargetInstance = audioDeviceOutput
			wire.Parent = audioListener

			audioListener.Parent = workspace.CurrentCamera
		end, {})

		useEffect(function()
			local v2 = {}

			for _, v3 in v do
				local v4 = spawnAudioEmitter(v3)

				local billboardGui = Instance.new("BillboardGui")
				billboardGui.ExtentsOffsetWorldSpace = Vector3.new(0, 10, 0)
				billboardGui.Size = UDim2.fromScale(10, 2)
				billboardGui.Adornee = v4

				local textLabel = Instance.new("TextLabel")
				textLabel.Text = v3.title
				textLabel.Size = UDim2.fromScale(1, 1)
				textLabel.Font = Enum.Font.BuilderSansBold
				textLabel.TextScaled = true
				local textColor

				if v3.shouldSurfaceToUser == false then
					textColor = Color3.fromHex("#c4474f")
				else
					textColor = Color3.fromHex("#fff")
				end

				textLabel.TextColor3 = textColor

				textLabel.BackgroundTransparency = 1
				textLabel.Parent = billboardGui

				local uiStroke = Instance.new("UIStroke")
				uiStroke.Color = Color3.fromHex("#202020")
				uiStroke.Thickness = 2
				uiStroke.Parent = textLabel

				billboardGui.Parent = v4

				table.insert(v2, v4)
			end

			local sound = Instance.new("Sound")
			sound.SoundId = "rbxassetid://9048375035"
			sound.Volume = 0.05
			sound.Looped = true
			sound.Parent = ReplicatedStorage
			sound:Play()

			return function()
				sound:Destroy()

				for _, v3 in v2 do
					v3:Destroy()
				end
			end
		end, {})
	end

	return nil
end

return DebugAudioEmitters
