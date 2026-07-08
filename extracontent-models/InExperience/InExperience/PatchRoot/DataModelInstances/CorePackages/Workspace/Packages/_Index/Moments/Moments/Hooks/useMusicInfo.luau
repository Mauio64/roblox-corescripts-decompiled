local Parent = script:FindFirstAncestor("Moments").Parent
local React = require(Parent.React)
local Signals = require(Parent.Signals)
local GetMusicStore = require(Parent.MomentsCreation).Stores.GetMusicStore

local function useMusicInfo(n1: number?) -- line: 24
	-- upvalues: GetMusicStore (copy), React (copy), Signals (copy)
	local v7 = GetMusicStore()
	local v8, v9 = React.useState(v7.getInfoMap(false))

	React.useEffect(function() -- line: 28
		-- upvalues: Signals (copy), v9 (copy), v7 (copy)
		return Signals.createEffect(function(p1) -- line: 29
			-- upvalues: v9 (copy), v7 (copy)
			v9(v7.getInfoMap(p1))
		end)
	end, { v7 })

	local v10 = if n1 == nil then nil else v8[n1]

	React.useEffect(function() -- line: 36
		-- upvalues: n1 (copy), v10 (copy), v7 (copy)
		if n1 ~= nil and v10 == nil then
			v7.fetchInfo(n1)
		end
	end, {
		n1,
		v10,
		v7
	})

	return v10
end

return useMusicInfo
