local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local parent = ProfilePlatform.Parent
local React = require(parent.React)
local Cryo = require(parent.Cryo)
local Enums = require(ProfilePlatform.Common.Enums)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue
local NetworkingGames = require(ProfilePlatform.Networking.NetworkingGames)

local Experiences = require(ProfilePlatform.Components.Experiences.Experiences)
local ExperiencesSkeleton = require(ProfilePlatform.Components.Experiences.ExperiencesSkeleton)
local GameVotesRodux = require(parent.GameVotesRodux)
local FetchGameVotes = GameVotesRodux.GameVotes.FetchGameVotes
local myRoduxNetworkingImpl = require(ProfilePlatform.Networking.myRoduxNetworkingImpl)

local FFlagEnableCommunityProfileLoadingSkeletons = require(ProfilePlatform.Flags.FFlagEnableCommunityProfileLoadingSkeletons)

local v = {}

local function ExperiencesContainer(p)
	local v2 = useProfileJsonComponent(Enums.Components.Experiences)
	local state, setState = React.useState(FFlagEnableCommunityProfileLoadingSkeletons and true or false)

	local experiences = v2.experiences or v

	local v3 = React.useMemo(function()
		return Cryo.List.map(experiences, function(p2, _)
			return (tostring(p2.universeId))
		end)
	end, { experiences })

	local v4 = useDispatch()

	React.useEffect(function()
		if Cryo.isEmpty(v3) then
			if FFlagEnableCommunityProfileLoadingSkeletons then
				setState(false)
			end
		else
			v4(NetworkingGames.GetExperiencesDetails.API(v3)):catch(function(_) end):finally(function()
				if FFlagEnableCommunityProfileLoadingSkeletons then
					setState(false)
				end
			end)

			for _, v5 in v3 do
				v4(FetchGameVotes.Fetch(myRoduxNetworkingImpl, v5)):catch(function(_) end)
			end
		end
	end, { v3 })
	local v5 = useSelector(function(p2)
		return getDeepValue(p2, "ProfilePlatform.Games.byGameId") or v
	end)

	local experienceDetails = React.useMemo(function()
		local result = {}

		for _, v6 in v3 do
			if v5[v6] then
				table.insert(result, v5[v6])
			end
		end

		return result
	end, { v3, v5 })

	if FFlagEnableCommunityProfileLoadingSkeletons and state then
		return React.createElement(ExperiencesSkeleton, {
			layoutOrder = p.layoutOrder,
			numSkeletons = #experiences
		})
	end

	if #experienceDetails == 0 then
		return nil
	end

	return React.createElement(Experiences, {
		layoutOrder = p.layoutOrder,
		experienceDetails = experienceDetails
	})
end

return ExperiencesContainer
