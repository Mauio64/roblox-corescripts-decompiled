local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/hWU")
local sounds = require("@luauforge/bundled/fyK").Sounds
local soundManager = require("@luauforge/bundled/fyK").SoundManager
local v5 = module.new()

local v6 = game:DefineFastInt("AppMusicVolumePercentage", 25) / 100

return function()
	React.useEffect(function()
		soundManager:PlaySound(sounds.VRAppLobbySound.Name, {
			Volume = v6,
			Looped = true,
			FadeInTime = 3
		})

		local v7 = v5:onLaunched(function()
			soundManager:StopSound(sounds.VRAppLobbySound.Name)
		end)

		local v8 = v5:onLeft(function()
			soundManager:PlaySound(sounds.VRAppLobbySound.Name, {
				Volume = v6,
				Looped = true,
				FadeInTime = 3
			})
		end)

		return function()
			v7:disconnect()
			v8:disconnect()
		end
	end, {})
end
