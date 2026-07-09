local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local useDispatch = require(ProfilePlatformParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useNavigation = require(ProfilePlatformParent.Navigation).useNavigation
local OpenGameDetails = require(ProfilePlatformParent.GameDetail).OpenGameDetails
local ExperienceTile = require(ProfilePlatform.BaseComponents.Tiles.ExperienceTile)

require(ProfilePlatform.Common.Types)

local function useRenderExperienceTile(s1: string, s2: string?, p1: ((...any) -> ...any)?, b1: boolean?) -- line: 19
	-- upvalues: useDispatch (copy), useNavigation (copy), React (copy), OpenGameDetails (copy), ExperienceTile (copy)
	local v13 = useDispatch()
	local v14 = useNavigation()
	local u15 = s2 or "ProfileExperienceTile_"
	local v16 = React.useCallback(function(p2, p3, p4) -- line: 29
		-- upvalues: p1 (copy), v13 (copy), OpenGameDetails (copy), v14 (copy)
		return function() -- line: 30
			-- upvalues: p1 (copy), p2 (copy), p3 (copy), p4 (copy), v13 (copy), OpenGameDetails (copy), v14 (copy)
			if p1 then
				p1(p2, p3, p4)
			end

			v13(OpenGameDetails(p2.experienceId, v14, {
				mountAsFullView = false,
				showBackButton = true
			}))
		end
	end, {
		p1,
		v13,
		v14
	})

	return (React.useCallback(function(p5, n1: number, _, n2: number?) -- line: 51
		-- upvalues: React (copy), ExperienceTile (copy), v16 (copy), s1 (copy), b1 (copy), u15 (ref)
		return React.createElement(ExperienceTile, {
			item = p5,
			index = n1,
			onActivated = v16(p5, n1, n2),
			impressionsTag = s1,
			showFooter = b1
		}), `{ u15 }{ p5.experienceId }_`
	end, {
		s1,
		v16,
		u15
	}))
end

return useRenderExperienceTile
