local AvatarExperienceHeadRefinement = script:FindFirstAncestor("AvatarExperienceHeadRefinement")
local AvatarExperienceHeadRefinementParent = AvatarExperienceHeadRefinement.Parent
local Promise = require(AvatarExperienceHeadRefinementParent.Promise)
local Http = require(AvatarExperienceHeadRefinementParent.Http)
local HeadShape = require(AvatarExperienceHeadRefinement.Enums.HeadShape)
local HeadShapePropertiesByAssetId = require(AvatarExperienceHeadRefinement.Enums.HeadShapePropertiesByAssetId)
local SetAvailableHeadShapes = require(AvatarExperienceHeadRefinement.Actions.SetAvailableHeadShapes)
local Counters = require(AvatarExperienceHeadRefinement.Counters)
local requestUserOwnedClassicHeads = require(AvatarExperienceHeadRefinement.Requests.requestUserOwnedClassicHeads)

local function fetchHelper(t1: {[any]: any}) -- line: 29
	-- upvalues: requestUserOwnedClassicHeads (copy), Promise (copy)
	local networkImpl = t1.networkImpl
	local userId = t1.userId
	local t2 = {}
	local s1 = ""

	while s1 ~= nil do
		local v16, v17 = requestUserOwnedClassicHeads(networkImpl, userId, s1):await()

		if not v16 then
			return Promise.reject(v17)
		end

		local responseBody = v17.responseBody

		for _, v20 in responseBody.data or {} do
			table.insert(t2, v20)
		end

		s1 = responseBody.nextPageCursor
	end

	return Promise.resolve({
		responseBody = {
			data = t2
		}
	})
end

return function(p1, s2: string, p2: ((...any) -> ...any)?) -- line: 64
	-- upvalues: Http (copy), Counters (copy), fetchHelper (copy), SetAvailableHeadShapes (copy), HeadShape (copy), Promise (copy), HeadShapePropertiesByAssetId (copy)
	return Http.PerformFetch.Single("HeadRefinement_UserOwnedClassicHead_Request", function(p3) -- line: 69
		-- upvalues: p2 (copy), Counters (copy), fetchHelper (copy), p1 (copy), s2 (copy), SetAvailableHeadShapes (copy), HeadShape (copy), Promise (copy), HeadShapePropertiesByAssetId (copy)
		if p2 then
			p2(Counters.OwnedClassicHeadsRequest.Start)
		end

		local v25, v26 = fetchHelper({
			networkImpl = p1,
			userId = s2
		}):await()

		if not v25 then
			if p2 then
				p2(Counters.OwnedClassicHeadsRequest.Failure)
			end

			p3:dispatch(SetAvailableHeadShapes({ HeadShape.Default }))

			return Promise.reject(v26)
		end

		local v27 = v26.responseBody or {
			data = {}
		}
		local t3 = { HeadShape.Default }

		for _, v30 in v27.data do
			local v31 = HeadShapePropertiesByAssetId[tostring(v30.assetId)]

			if v31 then
				table.insert(t3, v31.name)
			end
		end

		if p2 then
			p2(Counters.OwnedClassicHeadsRequest.Success, {
				headShapeCount = tostring(#t3)
			})
		end

		p3:dispatch(SetAvailableHeadShapes(t3))

		return Promise.resolve(t3)
	end)
end
