local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local React = require(MomentsCreationParent.React)
local Signals = require(MomentsCreationParent.Signals)
local GetMusicStore = require(MomentsCreation.Stores.GetMusicStore)

require(MomentsCreation.Stores.createMusicStore)

local function useMusicInfo(n1: number?) -- line: 18
	-- upvalues: GetMusicStore (copy), React (copy), Signals (copy)
	local v8 = GetMusicStore()
	local v9, v10 = React.useState(v8.getInfoMap(false))

	React.useEffect(function() -- line: 22
		-- upvalues: Signals (copy), v10 (copy), v8 (copy)
		return Signals.createEffect(function(p1) -- line: 23
			-- upvalues: v10 (copy), v8 (copy)
			v10(v8.getInfoMap(p1))
		end)
	end, { v8 })

	local v11 = if n1 == nil then nil else v9[n1]

	React.useEffect(function() -- line: 29
		-- upvalues: n1 (copy), v11 (copy), v8 (copy)
		if n1 ~= nil and v11 == nil then
			v8.fetchInfo(n1)
		end
	end, {
		n1,
		v11,
		v8
	})

	return v11
end

return useMusicInfo
