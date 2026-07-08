local ProfileShareLinks = script:FindFirstAncestor("ProfileShareLinks")
local ProfileShareLinksParent = ProfileShareLinks.Parent
local React = require(ProfileShareLinksParent.React)
local useDispatch = require(ProfileShareLinksParent.RoactUtils).Hooks.RoactRodux.useDispatch
local Networking = require(ProfileShareLinks.Networking.Networking)

return function() -- line: 12
	-- upvalues: useDispatch (copy), React (copy), Networking (copy)
	local v6 = useDispatch()

	return (React.useCallback(function() -- line: 15
		-- upvalues: v6 (copy), Networking (copy)
		return v6(Networking.ShareLinksNetworking.GetOrGenerateLink.API({
			linkType = "Profile"
		})):catch(function() -- line: 17
		end)
	end, { v6 }))
end
