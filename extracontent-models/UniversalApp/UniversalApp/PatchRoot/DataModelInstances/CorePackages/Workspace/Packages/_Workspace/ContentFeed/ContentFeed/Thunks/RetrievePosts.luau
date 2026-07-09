local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local getDeepValue = require(ParentParentParent.LuaSocialLibrariesDeps).SocialLibraries.config({}).Dictionary.getDeepValue
local GetExperiencesDetails = require(ParentParent.App.Networking).NetworkingGames.GetExperiencesDetails
local getUniverseIds = require(ParentParent.Utils.getUniverseIds)
local Networking = require(ParentParent.App.Networking)

require(ParentParent.Types)

return function(s1: string, n1: number, n2: number) -- line: 12
	-- upvalues: Networking (copy), getDeepValue (copy), getUniverseIds (copy), GetExperiencesDetails (copy)
	return function(p1) -- line: 13
		-- upvalues: Networking (copy), n1 (copy), n2 (copy), s1 (copy), getDeepValue (copy), getUniverseIds (copy), GetExperiencesDetails (copy)
		p1:dispatch(Networking.ContentSharingNetworking.GetPostsByCursor.API({
			cursor = n1,
			sortOrder = n2,
			userId = s1
		})):andThen(function() -- line: 20
			-- upvalues: getDeepValue (copy), p1 (copy), s1 (copy), getUniverseIds (copy), GetExperiencesDetails (copy)
			local v11 = getDeepValue(p1:getState(), "ContentSharing.byUserId." .. s1 .. ".posts") or {}
			local v12 = getUniverseIds(v11)

			p1:dispatch(GetExperiencesDetails.API(v12))
		end):catch(function() -- line: 28
		end)
	end
end
