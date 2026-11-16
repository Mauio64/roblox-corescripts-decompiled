local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")

local CoreGui = game:GetService("CoreGui")
local shell = CoreGui:FindFirstChild("RobloxGui"):FindFirstChild("Modules"):FindFirstChild("Shell")

local Utility = require(shell:FindFirstChild("Utility"))

local v = {
	BackgroundLoop = "RobloxMusic.ogg",
	Error = "Error.mp3",
	ButtonPress = "ButtonPress.mp3",
	MoveSelection = "MoveSelection.mp3",
	OverlayOpen = "OverlayOpen.mp3",
	PopUp = "PopUp.mp3",
	PurchaseSuccess = "PurchaseSuccess.mp3",
	ScreenChange = "ScreenChange.mp3",
	SideMenuSlideIn = "SideMenuSlideIn.mp3"
}

local v2 = {}

local function EaseOutCirc(p, p2, p3, p4)
	local v3 = p / p4 - 1
	return p3 * math.sqrt(1 - v3 * v3) + p2
end

local function IsGameRunning()
	if UserSettings().GameSettings:InStudioMode() then
		local UserInputService = game:GetService("UserInputService")

		if UserInputService:GetPlatform() ~= Enum.Platform.Windows then
			return RunService:IsRunning()
		end
	end

	return true
end

function GetSoundManager()
	local v3 = {}
	v3.SoundHolder = nil
	local v4 = {}

	local function FindSoundObjectForName(p) -- 1 equivalent call inferred from this helper
		local v5 = v2[p] and table.remove(v2[p], 1)

		if not v5 then
			return
		end

		table.insert(v2[p], v5)
		return v5
	end

	function v3:CreateSound(name)
		local soundId = "rbxasset://sounds/ui/Shell/" .. v[name]

		local sound = Instance.new("Sound")
		sound.Name = name
		sound.SoundId = soundId

		return sound
	end

	function v3:Play(p, value, p2, value2, ...)
		if v[p] then
			local soundObjectForName = FindSoundObjectForName(p) -- inferred equivalent call

			if soundObjectForName then
				soundObjectForName.Volume = value or 1

				soundObjectForName.Looped = p2 or false
				soundObjectForName.Pitch = value2 or 1

				soundObjectForName:Play(...)

				v4[soundObjectForName] = soundObjectForName.Volume

				if not IsGameRunning() then
					soundObjectForName.Volume = 0
				end

				return soundObjectForName
			end
		else
			spawn(function()
				error("Unable to find sound: " .. tostring(p))
			end)
		end

		return nil
	end

	function v3.IsPlaying(_, childName)
		local child = v3.SoundHolder:FindFirstChild(childName)

		return if child then child.IsPlaying else false
	end

	function v3:Stop(childName, ...)
		local child = v3.SoundHolder and v[childName] and v3.SoundHolder:FindFirstChild(childName)

		if child then
			child:Stop()
		end
	end

	function v3.TweenSound(_, p, p2, p3)
		v4[p] = nil
		Utility.PropertyTweener(p, "Volume", p.Volume, p2, p3, function(...)
			return IsGameRunning() and Utility.EaseInOutQuad(...) or 0
		end, true, function()
			v4[p] = p2
		end)
	end

	local function Initialize()
		local appShellSounds = Instance.new("Folder")
		appShellSounds.Name = "AppShellSounds"
		appShellSounds.Parent = CoreGui

		v3.SoundHolder = appShellSounds

		for k, _ in pairs(v) do
			local folder = Instance.new("Folder")
			folder.Name = k
			folder.Parent = v3.SoundHolder

			v2[k] = {}

			local sound = v3:CreateSound(k)
			sound.Parent = folder
			table.insert(v2[k], sound)
			local sound2 = v3:CreateSound(k)
			sound2.Parent = folder
			table.insert(v2[k], sound2)
			local sound3 = v3:CreateSound(k)
			sound3.Parent = folder
			table.insert(v2[k], sound3)
		end

		local v5 = nil
		GuiService:GetPropertyChangedSignal("SelectedCoreObject"):connect(function()
			local selectedCoreObject = GuiService.SelectedCoreObject

			if selectedCoreObject and v5 then
				local moveSelection = selectedCoreObject:FindFirstChild("MoveSelection")

				if moveSelection and moveSelection:IsA("Sound") then
					moveSelection.Volume = 0.35
					moveSelection:Play()
				end
			end

			v5 = selectedCoreObject
		end)

		if not IsGameRunning() then
			spawn(function()
				while not IsGameRunning() do
					wait(0.1)
				end

				for k, volume in pairs(v4) do
					k.Volume = volume
				end
			end)
		end
	end

	Initialize()

	return v3
end

return GetSoundManager()
