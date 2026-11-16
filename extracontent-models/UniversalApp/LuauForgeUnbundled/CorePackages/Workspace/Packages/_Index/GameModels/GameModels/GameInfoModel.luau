local Result = require("@game/CorePackages/Workspace/Packages/_Workspace/GameModels/Result")
local trim = require("@game/CorePackages/Workspace/Packages/_Workspace/GameModels/LuauPolyfill").String.trim
require("@game/CorePackages/Workspace/Packages/_Workspace/GameModels/DiscoveryTypes")

local fFlagEnableTopSongsSort = require("@game/CorePackages/Workspace/Packages/_Workspace/GameModels/SharedFlags").FFlagEnableTopSongsSort

local v5 = {}

function v5.new(p2, p3, p4)
	return { universeId = p2, placeId = p3, name = trim(p4) }
end

function v5._fromSharedJson(p2, data)
	p2.ageRecommendationDisplayName = data.ageRecommendationDisplayName
	p2.minimumAge = data.minimumAge
	p2.contentMaturity = data.contentMaturity
	p2.playerCount = data.playerCount
	local v6 = if data.primaryMediaAsset and data.primaryMediaAsset.wideImageAssetId then tostring(data.primaryMediaAsset.wideImageAssetId) else nil
	p2.primaryWideAssetId = v6

	local v7 = if data.primaryMediaAsset and data.primaryMediaAsset.wideImageListId then tostring(data.primaryMediaAsset.wideImageListId) else nil
	p2.primaryWideListId = v7

	p2.totalDownVotes = data.totalDownVotes
	p2.totalUpVotes = data.totalUpVotes
	p2.defaultLayoutData = data.defaultLayoutData
	p2.layoutDataBySort = data.layoutDataBySort
end

function v5.mock()
	local _149757 = v5.new("149757", "10395446", "test")

	v5._fromSharedJson(_149757, {
		ageRecommendationDisplayName = "Ages 13+",
		minimumAge = 13,
		contentMaturity = "moderate",
		playerCount = 5,
		primaryMediaAsset = { wideImageAssetId = "12046435434" },
		totalDownVotes = 2564,
		totalUpVotes = 10970
	})

	_149757.creatorId = "22915773"
	_149757.creatorName = "Jaegerblox"

	_149757.defaultLayoutData = {}
	_149757.friendActivityTitle = "Friend Activity"
	_149757.friendVisitedString = "1 Friend visited"
	_149757.friendVisits = {
		{ userId = "1894536079" }
	}

	_149757.layoutDataBySort = {}

	return _149757
end

function v5.fromGamesApi(data)
	if type(data.universeId) ~= "number" and type(data.universeId) ~= "string" then
		return Result.error("GameInfoModel.fromGamesApi expects universeId to be a number or a string")
	end

	if type(data.placeId) ~= "number" and type(data.placeId) ~= "string" then
		return Result.error("GameInfoModel.fromGamesApi expects placeId to be a number or a string")
	end

	if type(data.creatorId) ~= "number" and type(data.creatorId) ~= "string" then
		return Result.error("GameInfoModel.fromGamesApi expects creatorId to be a number or a string")
	end

	local v6 = v5.new(tostring(data.universeId), tostring(data.placeId), data.name)
	v5._fromSharedJson(v6, data)
	v6.creatorId = tostring(data.creatorId)
	v6.creatorName = data.creatorName

	return Result.success(v6)
end

function v5.fromExperienceApi(data)
	if type(data.universeId) ~= "number" and type(data.universeId) ~= "string" then
		return Result.error("Game.fromJsonData expects universeId to be a number or a string")
	end

	if type(data.rootPlaceId) ~= "number" and type(data.rootPlaceId) ~= "string" then
		return Result.error("Game.fromJsonData expects placeId to be a number or a string")
	end

	local v6 = v5.new(tostring(data.universeId), tostring(data.rootPlaceId), data.name)
	v5._fromSharedJson(v6, data)

	return Result.success(v6)
end

function v5.fromOmniApi(data)
	if type(data.universeId) ~= "number" and type(data.universeId) ~= "string" then
		return Result.error("DiscoveryGame.fromJsonData expects universeId to be a number or a string")
	end

	if type(data.rootPlaceId) ~= "number" and type(data.rootPlaceId) ~= "string" then
		return Result.error("DiscoveryGame.fromJsonData expects rootPlaceId to be a number or a string")
	end

	local v6 = v5.new(tostring(data.universeId), tostring(data.rootPlaceId), data.name)
	v5._fromSharedJson(v6, data)
	v6.friendActivityTitle = data.friendActivityTitle
	v6.friendVisitedString = data.friendVisitedString
	v6.friendVisits = data.friendVisits
	local v7 = if data.navigationUid then tostring(data.navigationUid) else nil
	v6.navigationUniverseId = v7

	return Result.success(v6)
end

function v5.fromOmniAutocompleteApi(data)
	if type(data.universeId) ~= "number" and type(data.universeId) ~= "string" then
		return Result.error("GameInfoModel.fromOmniAutocompleteApi expects universeId to be a number or a string")
	end

	if type(data.rootPlaceId) ~= "number" and type(data.rootPlaceId) ~= "string" then
		return Result.error("GameInfoModel.fromOmniAutocompleteApi expects placeId to be a number or a string")
	end

	local v6 = v5.new(tostring(data.universeId), tostring(data.rootPlaceId), data.name)
	v5._fromSharedJson(v6, data)

	return Result.success(v6)
end

function v5.fromSearchApi(data)
	if type(data.universeId) ~= "number" and type(data.universeId) ~= "string" then
		return Result.error("GameInfoModel.fromSearchApi expects universeId to be a number or a string")
	end

	if type(data.rootPlaceId) ~= "number" and type(data.rootPlaceId) ~= "string" then
		return Result.error("GameInfoModel.fromSearchApi expects rootPlaceId to be a number or a string")
	end

	if type(data.creatorId) ~= "number" and type(data.creatorId) ~= "string" then
		return Result.error("GameInfoModel.fromSearchApi expects creatorId to be a number or a string")
	end

	local v6 = v5.new(tostring(data.universeId), tostring(data.rootPlaceId), data.name)
	v5._fromSharedJson(v6, data)
	v6.creatorId = tostring(data.creatorId)
	v6.creatorName = data.creatorName

	return Result.success(v6)
end

if fFlagEnableTopSongsSort then
	function v5.fromMusicDiscoveryApi(data)
		if type(data.universeId) ~= "number" and type(data.universeId) ~= "string" then
			return Result.error("GameInfoModel.fromMusicDiscoveryApi expects universeId to be a number or a string")
		end

		if type(data.rootPlaceId) ~= "number" and type(data.rootPlaceId) ~= "string" then
			return Result.error("GameInfoModel.fromMusicDiscoveryApi expects rootPlaceId to be a number or a string")
		end

		local v6 = v5.new(tostring(data.universeId), tostring(data.rootPlaceId), data.name)
		v6.playerCount = data.playerCount
		v6.totalDownVotes = data.downVotes
		v6.totalUpVotes = data.upVotes

		return Result.success(v6)
	end
end

return v5
