local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local SocialTabsPageParent = SocialTabsPage.Parent
local Cryo = require(SocialTabsPageParent.Cryo)
local React = require(SocialTabsPageParent.React)
local useDispatch = require(SocialTabsPageParent.RoactUtils).Hooks.RoactRodux.useDispatch
local FFlagSocialTabsPagePresenceSignalsMigration = require(SocialTabsPage.Flags.FFlagSocialTabsPagePresenceSignalsMigration)
local v7 = if FFlagSocialTabsPagePresenceSignalsMigration then nil else require(SocialTabsPage.Networking.NetworkingPresence).GetPresencesFromUserIds

if FFlagSocialTabsPagePresenceSignalsMigration then
	return nil
end

return function(t1: {[any]: any}) -- line: 18
	-- upvalues: useDispatch (copy), React (copy), Cryo (copy), v7 (copy)
	local v9 = useDispatch()
	local v10 = React.useRef({})

	React.useEffect(function() -- line: 22
		-- upvalues: Cryo (copy), v10 (copy), t1 (copy), v9 (copy), v7 (copy)
		local v11 = Cryo.List.toSet(v10.current)
		local v12 = Cryo.List.filter(t1, function(p1) -- line: 24
			-- upvalues: v11 (copy)
			return not v11[p1]
		end)

		if #v12 > 0 then
			v9(v7.API(v12))
			v10.current = Cryo.List.join(v10.current, v12)
		end
	end, {
		t1,
		v9
	})
end
