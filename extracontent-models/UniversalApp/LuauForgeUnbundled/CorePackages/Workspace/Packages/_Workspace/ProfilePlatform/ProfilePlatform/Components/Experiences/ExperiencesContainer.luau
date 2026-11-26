local useProfileJsonComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJsonComponent")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Cryo")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local getDeepValue = require("@luauforge/bundled/fbc").SocialLibraries.config({}).Dictionary.getDeepValue
local module6 = require("@luauforge/bundled/fkN")

local Experiences = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/Experiences/Experiences")
local ExperiencesSkeleton = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/Experiences/ExperiencesSkeleton")
local fetchGameVotes = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/GameVotesRodux").GameVotes.FetchGameVotes
local myRoduxNetworkingImpl = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/myRoduxNetworkingImpl")

local FFlagEnableCommunityProfileLoadingSkeletons = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagEnableCommunityProfileLoadingSkeletons")

local v5 = {}

local function ExperiencesContainer(p2)
	local v6 = useProfileJsonComponent(Enums.Components.Experiences)
	local state, setState = React.useState(FFlagEnableCommunityProfileLoadingSkeletons and true or false)

	local experiences = v6.experiences or v5

	local v7 = React.useMemo(function()
		return Cryo.List.map(experiences, function(p3, p4)
			return (tostring(p3.universeId))
		end)
	end, { experiences })

	local v8 = useDispatch()

	React.useEffect(function()
		if Cryo.isEmpty(v7) then
			if FFlagEnableCommunityProfileLoadingSkeletons then
				setState(false)
			end
		else
			v8(module6.GetExperiencesDetails.API(v7)):catch(function(p3) end):finally(function()
				if FFlagEnableCommunityProfileLoadingSkeletons then
					setState(false)
				end
			end)

			for k, v9 in v7 do
				v8(fetchGameVotes.Fetch(myRoduxNetworkingImpl, v9)):catch(function(p3) end)
			end
		end
	end, { v7 })
	local v9 = useSelector(function(p3)
		return getDeepValue(p3, "ProfilePlatform.Games.byGameId") or v5
	end)

	local v10 = React.useMemo(function()
		local result = {}

		for k, v11 in v7 do
			if v9[v11] then
				table.insert(result, v9[v11])
			end
		end

		return result
	end, { v7, v9 })

	if FFlagEnableCommunityProfileLoadingSkeletons and state then
		return React.createElement(ExperiencesSkeleton, {
			layoutOrder = p2.layoutOrder,
			numSkeletons = #experiences
		})
	end

	if #v10 == 0 then
		return nil
	end

	return React.createElement(Experiences, {
		layoutOrder = p2.layoutOrder,
		experienceDetails = v10
	})
end

return ExperiencesContainer
