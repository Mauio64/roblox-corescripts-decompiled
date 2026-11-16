local GamePlayButton = script:FindFirstAncestor("GamePlayButton")

local OpenCentralOverlayForGameDetailsSquad = require(GamePlayButton.OpenCentralOverlayForGameDetailsSquad)
local PlayButtonStates = require(GamePlayButton.PlayButtonStates)

local parent = GamePlayButton.Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local SharedFlags = require(parent.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled

return function(p, p2, p3, p4)
	local v = useDispatch()

	return React.useCallback(function(p5)
		if GetFFlagIsSquadEnabled() and p2 == PlayButtonStates.PlayableWithParty then
			v(OpenCentralOverlayForGameDetailsSquad(p, p5.AbsolutePosition, p5.AbsoluteSize, p3, p4))
		end
	end, { v, p, p3, p2, p4 })
end
