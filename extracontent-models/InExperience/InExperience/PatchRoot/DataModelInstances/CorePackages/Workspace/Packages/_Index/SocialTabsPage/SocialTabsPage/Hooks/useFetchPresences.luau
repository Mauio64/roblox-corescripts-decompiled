local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local SocialTabsPageParent = SocialTabsPage.Parent
local Cryo = require(SocialTabsPageParent.Cryo)
local React = require(SocialTabsPageParent.React)
local useDispatch = require(SocialTabsPageParent.RoactUtils).Hooks.RoactRodux.useDispatch
local GetPresencesFromUserIds = require(SocialTabsPage.Networking.NetworkingPresence).GetPresencesFromUserIds

local function useFetchPresences(t1: {[any]: any}) -- line: 12
	-- upvalues: useDispatch (copy), React (copy), Cryo (copy), GetPresencesFromUserIds (copy)
	local v9 = useDispatch()
	local v10 = React.useRef({})

	React.useEffect(function() -- line: 16
		-- upvalues: Cryo (copy), v10 (copy), t1 (copy), v9 (copy), GetPresencesFromUserIds (copy)
		local v11 = Cryo.List.toSet(v10.current)
		local v12 = Cryo.List.filter(t1, function(p1) -- line: 18
			-- upvalues: v11 (copy)
			return not v11[p1]
		end)

		if #v12 > 0 then
			v9(GetPresencesFromUserIds.API(v12))
			v10.current = Cryo.List.join(v10.current, v12)
		end
	end, {
		t1,
		v9
	})
end

return useFetchPresences
