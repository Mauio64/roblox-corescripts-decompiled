local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Cryo = require(ProfilePlatformParent.Cryo)
local Enums = require(ProfilePlatform.Common.Enums)
local RoactUtils = require(ProfilePlatformParent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local getDeepValue = require(ProfilePlatformParent.LuaSocialLibrariesDeps).SocialLibraries.config({}).Dictionary.getDeepValue
local NetworkingGames = require(ProfilePlatform.Networking.NetworkingGames)
local Experiences = require(ProfilePlatform.Components.Experiences.Experiences)
local ExperiencesSkeleton = require(ProfilePlatform.Components.Experiences.ExperiencesSkeleton)
local FetchGameVotes = require(ProfilePlatformParent.GameVotesRodux).GameVotes.FetchGameVotes
local myRoduxNetworkingImpl = require(ProfilePlatform.Networking.myRoduxNetworkingImpl)
local FFlagEnableCommunityProfileLoadingSkeletons = require(ProfilePlatform.Flags.FFlagEnableCommunityProfileLoadingSkeletons)
local t1 = {}

local function ExperiencesContainer(t2: {[any]: any}) -- line: 38
	-- upvalues: useProfileJsonComponent (copy), Enums (copy), React (copy), FFlagEnableCommunityProfileLoadingSkeletons (copy), t1 (copy), Cryo (copy), useDispatch (copy), NetworkingGames (copy), FetchGameVotes (copy), myRoduxNetworkingImpl (copy), useSelector (copy), getDeepValue (copy), ExperiencesSkeleton (copy), Experiences (copy)
	local v20 = useProfileJsonComponent(Enums.Components.Experiences)
	local v21, v22 = React.useState(not not FFlagEnableCommunityProfileLoadingSkeletons)
	local v23 = v20.experiences or t1
	local v24 = React.useMemo(function() -- line: 44
		-- upvalues: Cryo (copy), v23 (copy)
		return Cryo.List.map(v23, function(p1, _) -- line: 45
			return (tostring(p1.universeId))
		end)
	end, { v23 })
	local v25 = useDispatch()

	React.useEffect(function() -- line: 52
		-- upvalues: Cryo (copy), v24 (copy), v25 (copy), NetworkingGames (copy), FFlagEnableCommunityProfileLoadingSkeletons (copy), v22 (copy), FetchGameVotes (copy), myRoduxNetworkingImpl (copy)
		if not Cryo.isEmpty(v24) then
			v25(NetworkingGames.GetExperiencesDetails.API(v24)):catch(function(_) -- line: 55
			end):finally(function() -- line: 58
				-- upvalues: FFlagEnableCommunityProfileLoadingSkeletons (copy), v22 (copy)
				if FFlagEnableCommunityProfileLoadingSkeletons then
					v22(false)
				end
			end)

			for _, v29 in v24 do
				v25(FetchGameVotes.Fetch(myRoduxNetworkingImpl, v29)):catch(function(_) -- line: 64
				end)
			end

			return
		end

		if FFlagEnableCommunityProfileLoadingSkeletons then
			v22(false)
		end
	end, { v24 })

	local v26 = useSelector(function(p5) -- line: 74
		-- upvalues: getDeepValue (copy), t1 (copy)
		return getDeepValue(p5, "ProfilePlatform.Games.byGameId") or t1
	end)
	local v27 = React.useMemo(function() -- line: 78
		-- upvalues: v24 (copy), v26 (copy)
		local t3 = {}

		for _, v33 in v24 do
			if v26[v33] then
				table.insert(t3, v26[v33])
			end
		end

		return t3
	end, {
		v24,
		v26
	})

	if FFlagEnableCommunityProfileLoadingSkeletons and v21 then
		return React.createElement(ExperiencesSkeleton, {
			layoutOrder = t2.layoutOrder,
			numSkeletons = #v23
		})
	end

	if #v27 == 0 then
		return nil
	end

	return React.createElement(Experiences, {
		layoutOrder = t2.layoutOrder,
		experienceDetails = v27
	})
end

return ExperiencesContainer
