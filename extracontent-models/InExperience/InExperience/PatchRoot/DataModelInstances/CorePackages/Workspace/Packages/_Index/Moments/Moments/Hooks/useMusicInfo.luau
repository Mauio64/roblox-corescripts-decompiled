local parent = script:FindFirstAncestor("Moments").Parent

local React = require(parent.React)
local Signals = require(parent.Signals)

local MomentsCreation = require(parent.MomentsCreation)
local GetMusicStore = MomentsCreation.Stores.GetMusicStore

local function useMusicInfo(p: number?)
	local musicStore = GetMusicStore()

	local state, setState = React.useState(musicStore.getInfoMap(false))
	React.useEffect(function()
		return Signals.createEffect(function(p2)
			setState(musicStore.getInfoMap(p2))
		end)
	end, { musicStore })
	local selected

	if p == nil then
		selected = nil
	else
		selected = state[p]
	end

	React.useEffect(function()
		if p ~= nil and selected == nil then
			musicStore.fetchInfo(p)
		end
	end, { p, selected, musicStore })

	return selected
end

return useMusicInfo
