local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Signals")

local GetMusicStore = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Stores/GetMusicStore")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/Music")

local function useMusicInfo(p2)
	local v5 = GetMusicStore()

	local state, setState = React.useState(v5.getInfoMap(false))
	React.useEffect(function()
		return Signals.createEffect(function(p3)
			setState(v5.getInfoMap(p3))
		end)
	end, { v5 })
	local v6 = if p2 ~= nil then state[p2] else nil

	React.useEffect(function()
		if p2 ~= nil and v6 == nil then
			v5.fetchInfo(p2)
		end
	end, { p2, v6, v5 })

	return v6
end

return useMusicInfo
