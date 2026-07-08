local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Shell = CoreGui:FindFirstChild("RobloxGui"):FindFirstChild("Modules"):FindFirstChild("Shell")
local Utility = require(Shell:FindFirstChild("Utility"))
local t1 = {
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
local t2 = {}

local function EaseOutCirc(p1, p2, p3, p4) -- line: 33
	local v14 = p1 / p4 - 1

	return p3 * math.sqrt(1 - v14 * v14) + p2
end
local function IsGameRunning() -- line: 39
	-- upvalues: RunService (copy)
	if not UserSettings().GameSettings:InStudioMode() or game:GetService("UserInputService"):GetPlatform() == Enum.Platform.Windows then
		return true
	end

	return RunService:IsRunning()
end

function GetSoundManager() -- line: 46
	-- upvalues: t2 (copy), t1 (copy), IsGameRunning (copy), Utility (copy), CoreGui (copy), GuiService (copy)
	local t3 = {
		SoundHolder = nil
	}
	local t4 = {}

	local function FindSoundObjectForName(p5) -- line: 53
		-- upvalues: t2 (copy)
		if t2[p5] then
			local v20 = table.remove(t2[p5], 1)

			if v20 then
				table.insert(t2[p5], v20)

				return v20
			end
		end
	end

	function t3.CreateSound(_, p7) -- line: 63
		-- upvalues: t1 (copy)
		local v23 = "rbxasset://sounds/ui/Shell/" .. t1[p7]
		local Sound = Instance.new("Sound")

		Sound.Name = p7
		Sound.SoundId = v23

		return Sound
	end
	function t3.Play(_, p9, p10, p11, p12, ...) -- line: 74
		-- upvalues: t1 (copy), t2 (copy), t4 (copy), IsGameRunning (copy)
		if not t1[p9] then
			spawn(function() -- line: 95
				-- upvalues: p9 (copy)
				error("Unable to find sound: " .. tostring(p9))
			end)

			return nil
		end

		local g30 = nil
		local v31 = nil

		repeat
			if g30 or t2[p9] then
				if not g30 then
					v31 = table.remove(t2[p9], 1)
				end

				if g30 or v31 then
					if not g30 then
						table.insert(t2[p9], v31)
					end

					g30 = false

					if v31 then
						v31.Volume = p10 or 1
						v31.Looped = p11 or false
						v31.Pitch = p12 or 1
						v31:Play(...)
						t4[v31] = v31.Volume

						if not IsGameRunning() then
							v31.Volume = 0
						end

						return v31
					end

					return nil
				end
			end

			v31 = nil
			g30 = true
		until not g30
	end
	function t3.IsPlaying(_, p14) -- line: 103
		-- upvalues: t3 (copy)
		local p14_2 = t3.SoundHolder:FindFirstChild(p14)

		if p14_2 then
			return p14_2.IsPlaying
		end

		return false
	end
	function t3.Stop(_, p16, ...) -- line: 111
		-- upvalues: t3 (copy), t1 (copy)
		if t3.SoundHolder and t1[p16] then
			local p16_2 = t3.SoundHolder:FindFirstChild(p16)

			if p16_2 then
				p16_2:Stop()
			end
		end
	end
	function t3.TweenSound(_, p18, p19, p20) -- line: 120
		-- upvalues: t4 (copy), Utility (copy), IsGameRunning (copy)
		t4[p18] = nil
		Utility.PropertyTweener(p18, "Volume", p18.Volume, p19, p20, function(...) -- line: 123
			-- upvalues: IsGameRunning (copy), Utility (copy)
			return IsGameRunning() and Utility.EaseInOutQuad(...) or 0
		end, true, function() -- line: 127
			-- upvalues: t4 (copy), p18 (copy), p19 (copy)
			t4[p18] = p19
		end)
	end

	local function Initialize() -- line: 138
		-- upvalues: CoreGui (copy), t3 (copy), t1 (copy), t2 (copy), GuiService (copy), IsGameRunning (copy), t4 (copy)
		local Folder = Instance.new("Folder")

		Folder.Name = "AppShellSounds"
		Folder.Parent = CoreGui
		t3.SoundHolder = Folder

		for k, _ in pairs(t1) do
			local Folder2 = Instance.new("Folder")

			Folder2.Name = k
			Folder2.Parent = t3.SoundHolder
			t2[k] = {}

			local v46 = t3:CreateSound(k)

			v46.Parent = Folder2
			table.insert(t2[k], v46)

			local v47 = t3:CreateSound(k)

			v47.Parent = Folder2
			table.insert(t2[k], v47)

			local v48 = t3:CreateSound(k)

			v48.Parent = Folder2
			table.insert(t2[k], v48)
		end

		local u49 = nil

		GuiService:GetPropertyChangedSignal("SelectedCoreObject"):connect(function() -- line: 159
			-- upvalues: GuiService (copy), u49 (ref)
			local SelectedCoreObject = GuiService.SelectedCoreObject

			if SelectedCoreObject and u49 then
				local MoveSelection = SelectedCoreObject:FindFirstChild("MoveSelection")

				if MoveSelection and MoveSelection:IsA("Sound") then
					MoveSelection.Volume = 0.35
					MoveSelection:Play()
				end
			end

			u49 = SelectedCoreObject
		end)

		if not IsGameRunning() then
			spawn(function() -- line: 172
				-- upvalues: IsGameRunning (copy), t4 (copy)
				while not IsGameRunning() do
					wait(0.1)
				end

				for k, v in pairs(t4) do
					k.Volume = v
				end
			end)
		end
	end

	Initialize()

	return t3
end

return GetSoundManager()
