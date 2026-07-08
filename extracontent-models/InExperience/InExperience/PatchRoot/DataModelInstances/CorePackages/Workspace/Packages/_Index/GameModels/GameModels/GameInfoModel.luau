local Parent = script:FindFirstAncestor("GameModels").Parent
local Result = require(Parent.Result)
local trim = require(Parent.LuauPolyfill).String.trim

require(Parent.DiscoveryTypes)

local FFlagSearchOmniAutocompletePage = require(Parent.SharedFlags).FFlagSearchOmniAutocompletePage
local FFlagEnableTopSongsSort = require(Parent.SharedFlags).FFlagEnableTopSongsSort
local t1 = {
	new = function(s1: string, s2: string, s3: string) -- line: 14
		-- upvalues: trim (copy)
		return {
			universeId = s1,
			placeId = s2,
			name = trim(s3)
		}
	end,
	_fromSharedJson = function(p1, p2) -- line: 24
		p1.ageRecommendationDisplayName = p2.ageRecommendationDisplayName
		p1.minimumAge = p2.minimumAge
		p1.contentMaturity = p2.contentMaturity
		p1.playerCount = p2.playerCount
		p1.primaryWideAssetId = if not p2.primaryMediaAsset or not p2.primaryMediaAsset.wideImageAssetId then nil else tostring(p2.primaryMediaAsset.wideImageAssetId)
		p1.primaryWideListId = if not p2.primaryMediaAsset or not p2.primaryMediaAsset.wideImageListId then nil else tostring(p2.primaryMediaAsset.wideImageListId)
		p1.totalDownVotes = p2.totalDownVotes
		p1.totalUpVotes = p2.totalUpVotes
		p1.defaultLayoutData = p2.defaultLayoutData
		p1.layoutDataBySort = p2.layoutDataBySort
	end
}

function t1.mock() -- line: 41
	-- upvalues: t1 (copy)
	local v12 = t1.new("149757", "10395446", "test")

	t1._fromSharedJson(v12, {
		ageRecommendationDisplayName = "Ages 13+",
		minimumAge = 13,
		contentMaturity = "moderate",
		playerCount = 5,
		totalDownVotes = 2564,
		totalUpVotes = 10970,
		primaryMediaAsset = {
			wideImageAssetId = "12046435434"
		}
	})
	v12.creatorId = "22915773"
	v12.creatorName = "Jaegerblox"
	v12.defaultLayoutData = {}
	v12.friendActivityTitle = "Friend Activity"
	v12.friendVisitedString = "1 Friend visited"
	v12.friendVisits = {{
		userId = "1894536079"
	}}
	v12.layoutDataBySort = {}

	return v12
end
function t1.fromGamesApi(p3) -- line: 73
	-- upvalues: Result (copy), t1 (copy)
	if type(p3.universeId) ~= "number" and type(p3.universeId) ~= "string" then
		return Result.error("GameInfoModel.fromGamesApi expects universeId to be a number or a string")
	end

	if type(p3.placeId) ~= "number" and type(p3.placeId) ~= "string" then
		return Result.error("GameInfoModel.fromGamesApi expects placeId to be a number or a string")
	end

	if type(p3.creatorId) ~= "number" and type(p3.creatorId) ~= "string" then
		return Result.error("GameInfoModel.fromGamesApi expects creatorId to be a number or a string")
	end

	local v14 = t1.new(tostring(p3.universeId), tostring(p3.placeId), p3.name)

	t1._fromSharedJson(v14, p3)
	v14.creatorId = tostring(p3.creatorId)
	v14.creatorName = p3.creatorName

	return Result.success(v14)
end
function t1.fromExperienceApi(p4) -- line: 92
	-- upvalues: Result (copy), t1 (copy)
	if type(p4.universeId) ~= "number" and type(p4.universeId) ~= "string" then
		return Result.error("Game.fromJsonData expects universeId to be a number or a string")
	end

	if type(p4.rootPlaceId) ~= "number" and type(p4.rootPlaceId) ~= "string" then
		return Result.error("Game.fromJsonData expects placeId to be a number or a string")
	end

	local v16 = t1.new(tostring(p4.universeId), tostring(p4.rootPlaceId), p4.name)

	t1._fromSharedJson(v16, p4)

	return Result.success(v16)
end
function t1.fromOmniApi(p5) -- line: 106
	-- upvalues: Result (copy), t1 (copy)
	if type(p5.universeId) ~= "number" and type(p5.universeId) ~= "string" then
		return Result.error("DiscoveryGame.fromJsonData expects universeId to be a number or a string")
	end

	if type(p5.rootPlaceId) ~= "number" and type(p5.rootPlaceId) ~= "string" then
		return Result.error("DiscoveryGame.fromJsonData expects rootPlaceId to be a number or a string")
	end

	local v18 = t1.new(tostring(p5.universeId), tostring(p5.rootPlaceId), p5.name)

	t1._fromSharedJson(v18, p5)
	v18.friendActivityTitle = p5.friendActivityTitle
	v18.friendVisitedString = p5.friendVisitedString
	v18.friendVisits = p5.friendVisits
	v18.navigationUniverseId = if not p5.navigationUid then nil else tostring(p5.navigationUid)

	return Result.success(v18)
end

if FFlagSearchOmniAutocompletePage then
	function t1.fromOmniAutocompleteApi(p6) -- line: 125
		-- upvalues: Result (copy), t1 (copy)
		if type(p6.universeId) ~= "number" and type(p6.universeId) ~= "string" then
			return Result.error("GameInfoModel.fromOmniAutocompleteApi expects universeId to be a number or a string")
		end

		if type(p6.rootPlaceId) ~= "number" and type(p6.rootPlaceId) ~= "string" then
			return Result.error("GameInfoModel.fromOmniAutocompleteApi expects placeId to be a number or a string")
		end

		local v20 = t1.new(tostring(p6.universeId), tostring(p6.rootPlaceId), p6.name)

		t1._fromSharedJson(v20, p6)

		return Result.success(v20)
	end
end

function t1.fromSearchApi(p7) -- line: 140
	-- upvalues: Result (copy), t1 (copy)
	if type(p7.universeId) ~= "number" and type(p7.universeId) ~= "string" then
		return Result.error("GameInfoModel.fromSearchApi expects universeId to be a number or a string")
	end

	if type(p7.rootPlaceId) ~= "number" and type(p7.rootPlaceId) ~= "string" then
		return Result.error("GameInfoModel.fromSearchApi expects rootPlaceId to be a number or a string")
	end

	if type(p7.creatorId) ~= "number" and type(p7.creatorId) ~= "string" then
		return Result.error("GameInfoModel.fromSearchApi expects creatorId to be a number or a string")
	end

	local v22 = t1.new(tostring(p7.universeId), tostring(p7.rootPlaceId), p7.name)

	t1._fromSharedJson(v22, p7)
	v22.creatorId = tostring(p7.creatorId)
	v22.creatorName = p7.creatorName

	return Result.success(v22)
end

if FFlagEnableTopSongsSort then
	function t1.fromMusicDiscoveryApi(p8) -- line: 160
		-- upvalues: Result (copy), t1 (copy)
		if type(p8.universeId) ~= "number" and type(p8.universeId) ~= "string" then
			return Result.error("GameInfoModel.fromMusicDiscoveryApi expects universeId to be a number or a string")
		end

		if type(p8.rootPlaceId) ~= "number" and type(p8.rootPlaceId) ~= "string" then
			return Result.error("GameInfoModel.fromMusicDiscoveryApi expects rootPlaceId to be a number or a string")
		end

		local v24 = t1.new(tostring(p8.universeId), tostring(p8.rootPlaceId), p8.name)

		v24.playerCount = p8.playerCount
		v24.totalDownVotes = p8.downVotes
		v24.totalUpVotes = p8.upVotes

		return Result.success(v24)
	end
end

return t1
