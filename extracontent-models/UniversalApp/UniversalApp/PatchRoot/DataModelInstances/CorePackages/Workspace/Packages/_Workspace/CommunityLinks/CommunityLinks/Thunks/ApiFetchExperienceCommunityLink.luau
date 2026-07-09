local Parent = script:FindFirstAncestor("CommunityLinks").Parent
local Promise = require(Parent.Promise)
local StatusCodes = require(Parent.Http).StatusCodes
local SetExperienceCommunityLink = require(script.Parent.Parent.Actions.SetExperienceCommunityLink)
local GetCommunityLink = require(script.Parent.Parent.Requests.GetCommunityLink)
local CommunityInfo = require(script.Parent.Parent.Models.CommunityInfo)
local CommunityVisibility = require(script.Parent.Parent.Enums.CommunityVisibility)

return function(p1, p2) -- line: 12
	-- upvalues: GetCommunityLink (copy), CommunityInfo (copy), CommunityVisibility (copy), SetExperienceCommunityLink (copy), StatusCodes (copy), Promise (copy)
	return function(p3) -- line: 13
		-- upvalues: GetCommunityLink (copy), p1 (copy), p2 (copy), CommunityInfo (copy), CommunityVisibility (copy), SetExperienceCommunityLink (copy), StatusCodes (copy), Promise (copy)
		return GetCommunityLink(p1, p2):andThen(function(p4) -- line: 14
			-- upvalues: CommunityInfo (copy), CommunityVisibility (copy), p3 (copy), SetExperienceCommunityLink (copy), p2 (copy)
			if p4.responseBody ~= nil and p4.responseBody.communityId ~= nil then
				local v12 = CommunityInfo.fromJsonData(p4.responseBody)

				if v12.visibility == CommunityVisibility.Public then
					p3:dispatch(SetExperienceCommunityLink(p2, v12))

					return
				end
			end

			p3:dispatch(SetExperienceCommunityLink(p2, false))
		end, function(p5) -- line: 25
			-- upvalues: StatusCodes (copy), p3 (copy), SetExperienceCommunityLink (copy), p2 (copy), Promise (copy)
			if p5.StatusCode == StatusCodes.NOT_FOUND then
				p3:dispatch(SetExperienceCommunityLink(p2, false))
			end

			return Promise.resolve()
		end)
	end
end
