local OpenCentralOverlayForGameDetailsSquad = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/OpenCentralOverlayForGameDetailsSquad")
local PlayButtonStates = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonStates")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/React")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RoactUtils").Hooks.RoactRodux.useDispatch

local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").GetFFlagIsSquadEnabled

return function(p2, p3, p4, p5)
	local v5 = useDispatch()

	return React.useCallback(function(p6)
		if getFFlagIsSquadEnabled() and p3 == PlayButtonStates.PlayableWithParty then
			v5(OpenCentralOverlayForGameDetailsSquad(p2, p6.AbsolutePosition, p6.AbsoluteSize, p4, p5))
		end
	end, { v5, p2, p4, p3, p5 })
end
