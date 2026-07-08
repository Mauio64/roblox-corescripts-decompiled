local Songbird = script:FindFirstAncestor("Songbird")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(Songbird.Parent.React)
local getFFlagDebugMusicSampleSounds = require(Songbird.Flags.getFFlagDebugMusicSampleSounds)
local useEffect = React.useEffect
local t1 = {
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

local function spawnAudioEmitter(t2: {[any]: any}) -- line: 68
	local Part = Instance.new("Part")

	Part.Position = t2.position
	Part.Anchored = true
	Part.Name = t2.title

	if t2.className == "Sound" then
		local Sound = Instance.new("Sound")

		Sound.SoundId = t2.assetId
		Sound.Looped = true
		Sound.RollOffMinDistance = 10
		Sound.RollOffMaxDistance = 40
		Sound.Parent = Part
		Sound:Play()
	else
		local AudioPlayer = Instance.new("AudioPlayer")

		AudioPlayer.Asset = t2.assetId
		AudioPlayer.Looping = true
		AudioPlayer.Parent = Part

		local AudioEmitter = Instance.new("AudioEmitter")

		AudioEmitter.Parent = Part

		local Wire = Instance.new("Wire")

		Wire.SourceInstance = AudioPlayer
		Wire.TargetInstance = AudioEmitter
		Wire.Parent = AudioPlayer
		AudioPlayer:Play()
	end

	Part.Parent = workspace

	return Part
end
local function DebugAudioEmitters() -- line: 106
	-- upvalues: getFFlagDebugMusicSampleSounds (copy), useEffect (copy), t1 (copy), spawnAudioEmitter (copy), ReplicatedStorage (copy)
	if getFFlagDebugMusicSampleSounds() then
		useEffect(function() -- line: 108
			local AudioListener = Instance.new("AudioListener")
			local AudioDeviceOutput = Instance.new("AudioDeviceOutput")

			AudioDeviceOutput.Parent = AudioListener

			local Wire = Instance.new("Wire")

			Wire.SourceInstance = AudioListener
			Wire.TargetInstance = AudioDeviceOutput
			Wire.Parent = AudioListener
			AudioListener.Parent = workspace.CurrentCamera
		end, {})
		useEffect(function() -- line: 122
			-- upvalues: t1 (copy), spawnAudioEmitter (copy), ReplicatedStorage (copy)
			local t3 = {}

			for _, v20 in t1 do
				local v21 = spawnAudioEmitter(v20)
				local BillboardGui = Instance.new("BillboardGui")

				BillboardGui.ExtentsOffsetWorldSpace = Vector3.new(0, 10, 0)
				BillboardGui.Size = UDim2.fromScale(10, 2)
				BillboardGui.Adornee = v21

				local TextLabel = Instance.new("TextLabel")

				TextLabel.Text = v20.title
				TextLabel.Size = UDim2.fromScale(1, 1)
				TextLabel.Font = Enum.Font.BuilderSansBold
				TextLabel.TextScaled = true
				TextLabel.TextColor3 = if v20.shouldSurfaceToUser ~= false then Color3.fromHex("#fff") else Color3.fromHex("#c4474f")
				TextLabel.BackgroundTransparency = 1
				TextLabel.Parent = BillboardGui

				local UIStroke = Instance.new("UIStroke")

				UIStroke.Color = Color3.fromHex("#202020")
				UIStroke.Thickness = 2
				UIStroke.Parent = TextLabel
				BillboardGui.Parent = v21
				table.insert(t3, v21)
			end

			local Sound = Instance.new("Sound")

			Sound.SoundId = "rbxassetid://9048375035"
			Sound.Volume = 0.05
			Sound.Looped = true
			Sound.Parent = ReplicatedStorage
			Sound:Play()

			return function() -- line: 161
				-- upvalues: Sound (copy), t3 (copy)
				Sound:Destroy()

				for _, v27 in t3 do
					v27:Destroy()
				end
			end
		end, {})
	end

	return nil
end

return DebugAudioEmitters
