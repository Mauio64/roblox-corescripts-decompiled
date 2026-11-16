local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")

local getMusicStore = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCreation").Stores.GetMusicStore

local function useMusicInfo(p2)
	local musicStore = getMusicStore()

	local state, setState = React.useState(musicStore.getInfoMap(false))
	React.useEffect(function()
		return Signals.createEffect(function(p3)
			setState(musicStore.getInfoMap(p3))
		end)
	end, { musicStore })

	local v5 = if p2 ~= nil then state[p2] else nil

	React.useEffect(function()
		if p2 ~= nil and v5 == nil then
			musicStore.fetchInfo(p2)
		end
	end, { p2, v5, musicStore })

	return v5
end

return useMusicInfo
