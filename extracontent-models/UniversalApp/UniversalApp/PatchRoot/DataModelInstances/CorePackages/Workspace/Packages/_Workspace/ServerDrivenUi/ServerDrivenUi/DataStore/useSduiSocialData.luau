local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local React = require(Parent.React)
local Signals = require(Parent.Signals)
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector

require(Parent.SduiCoreSystem)

local function useFriendsInGame() -- line: 16
	-- upvalues: useSelector (copy), React (copy)
	local v7 = useSelector(function(p1) -- line: 17
		return p1.LocalUserId
	end)
	local v8 = useSelector(function(p2) -- line: 21
		return p2.InGameUsersByGame
	end)

	return React.useMemo(function() -- line: 25
		-- upvalues: v8 (copy), v7 (copy)
		local t1 = {}

		for v14, v15 in v8 do
			local t2 = {}

			for v17, _ in v15 do
				if v17 ~= tostring(v7) then
					t2[v17] = v17
				end
			end

			if next(t2) then
				t1[tostring(v14)] = t2
			end
		end

		return t1
	end, {
		v7,
		v8
	})
end
local function useSduiSocialData() -- line: 43
	-- upvalues: React (copy), Signals (copy), useFriendsInGame (copy)
	local v9, v10 = React.useMemo(function() -- line: 44
		-- upvalues: Signals (copy)
		return Signals.createSignal({})
	end, {})

	v10((useFriendsInGame()))

	return React.useMemo(function() -- line: 50
		-- upvalues: v9 (copy)
		return {
			getInGameFriendsByGame = v9
		}
	end, { v9 })
end

return useSduiSocialData
