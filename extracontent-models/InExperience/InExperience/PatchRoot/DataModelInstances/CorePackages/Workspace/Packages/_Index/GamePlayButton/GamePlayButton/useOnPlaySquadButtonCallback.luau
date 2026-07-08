local GamePlayButton = script:FindFirstAncestor("GamePlayButton")
local OpenCentralOverlayForGameDetailsSquad = require(GamePlayButton.OpenCentralOverlayForGameDetailsSquad)
local PlayButtonStates = require(GamePlayButton.PlayButtonStates)
local GamePlayButtonParent = GamePlayButton.Parent
local React = require(GamePlayButtonParent.React)
local useDispatch = require(GamePlayButtonParent.RoactUtils).Hooks.RoactRodux.useDispatch
local GetFFlagIsSquadEnabled = require(GamePlayButtonParent.SharedFlags).GetFFlagIsSquadEnabled

return function(p1, p2, p3, p4) -- line: 12
	-- upvalues: useDispatch (copy), React (copy), GetFFlagIsSquadEnabled (copy), PlayButtonStates (copy), OpenCentralOverlayForGameDetailsSquad (copy)
	local v12 = useDispatch()

	return React.useCallback(function(p5) -- line: 15
		-- upvalues: GetFFlagIsSquadEnabled (copy), p2 (copy), PlayButtonStates (copy), v12 (copy), OpenCentralOverlayForGameDetailsSquad (copy), p1 (copy), p3 (copy), p4 (copy)
		if GetFFlagIsSquadEnabled() and p2 == PlayButtonStates.PlayableWithParty then
			v12(OpenCentralOverlayForGameDetailsSquad(p1, p5.AbsolutePosition, p5.AbsoluteSize, p3, p4))
		end
	end, {
		v12,
		p1,
		p3,
		p2,
		p4
	})
end
