local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ExperienceEventReceiver = require(Modules.LuaApp.ExperienceEventReceiver)
local Sounds = require(CorePackages.Workspace.Packages.SoundManager).Sounds
local SoundManager = require(CorePackages.Workspace.Packages.SoundManager).SoundManager
local v7 = ExperienceEventReceiver.new()
local v8 = game:DefineFastInt("AppMusicVolumePercentage", 25) / 100

return function() -- line: 13
	-- upvalues: React (copy), SoundManager (copy), Sounds (copy), v8 (copy), v7 (copy)
	React.useEffect(function() -- line: 14
		-- upvalues: SoundManager (copy), Sounds (copy), v8 (copy), v7 (copy)
		SoundManager:PlaySound(Sounds.VRAppLobbySound.Name, {
			Looped = true,
			FadeInTime = 3,
			Volume = v8
		})

		local v9 = v7:onLaunched(function() -- line: 21
			-- upvalues: SoundManager (copy), Sounds (copy)
			SoundManager:StopSound(Sounds.VRAppLobbySound.Name)
		end)
		local v10 = v7:onLeft(function() -- line: 25
			-- upvalues: SoundManager (copy), Sounds (copy), v8 (copy)
			SoundManager:PlaySound(Sounds.VRAppLobbySound.Name, {
				Looped = true,
				FadeInTime = 3,
				Volume = v8
			})
		end)

		return function() -- line: 33
			-- upvalues: v9 (copy), v10 (copy)
			v9:disconnect()
			v10:disconnect()
		end
	end, {})
end
