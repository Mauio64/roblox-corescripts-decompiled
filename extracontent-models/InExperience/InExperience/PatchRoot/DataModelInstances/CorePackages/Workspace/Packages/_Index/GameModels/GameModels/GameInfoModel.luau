local parent = script:FindFirstAncestor("GameModels").Parent
local Result = require(parent.Result)
local LuauPolyfill = require(parent.LuauPolyfill)
local trim = LuauPolyfill.String.trim
require(parent.DiscoveryTypes)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableTopSongsSort = SharedFlags.FFlagEnableTopSongsSort

local GameInfoModel = {}

function GameInfoModel.new(universeId: string, placeId: string, p: string)
	return { universeId = universeId, placeId = placeId, name = trim(p) }
end

function GameInfoModel._fromSharedJson(p, data)
	p.ageRecommendationDisplayName = data.ageRecommendationDisplayName
	p.minimumAge = data.minimumAge
	p.contentMaturity = data.contentMaturity
	p.playerCount = data.playerCount
	local primaryWideAssetId

	if data.primaryMediaAsset and data.primaryMediaAsset.wideImageAssetId then
		primaryWideAssetId = tostring(data.primaryMediaAsset.wideImageAssetId)
	end

	p.primaryWideAssetId = primaryWideAssetId
	local primaryWideListId

	if data.primaryMediaAsset and data.primaryMediaAsset.wideImageListId then
		primaryWideListId = tostring(data.primaryMediaAsset.wideImageListId)
	end

	p.primaryWideListId = primaryWideListId

	p.totalDownVotes = data.totalDownVotes
	p.totalUpVotes = data.totalUpVotes
	p.defaultLayoutData = data.defaultLayoutData
	p.layoutDataBySort = data.layoutDataBySort
end

function GameInfoModel.mock()
	local _149757 = GameInfoModel.new("149757", "10395446", "test")

	GameInfoModel._fromSharedJson(_149757, {
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

function GameInfoModel.fromGamesApi(data)
	if type(data.universeId) ~= "number" and type(data.universeId) ~= "string" then
		return Result.error("GameInfoModel.fromGamesApi expects universeId to be a number or a string")
	end

	if type(data.placeId) ~= "number" and type(data.placeId) ~= "string" then
		return Result.error("GameInfoModel.fromGamesApi expects placeId to be a number or a string")
	end

	if type(data.creatorId) ~= "number" and type(data.creatorId) ~= "string" then
		return Result.error("GameInfoModel.fromGamesApi expects creatorId to be a number or a string")
	end

	local v = GameInfoModel.new(tostring(data.universeId), tostring(data.placeId), data.name)
	GameInfoModel._fromSharedJson(v, data)
	v.creatorId = tostring(data.creatorId)
	v.creatorName = data.creatorName

	return Result.success(v)
end

function GameInfoModel.fromExperienceApi(data)
	if type(data.universeId) ~= "number" and type(data.universeId) ~= "string" then
		return Result.error("Game.fromJsonData expects universeId to be a number or a string")
	end

	if type(data.rootPlaceId) ~= "number" and type(data.rootPlaceId) ~= "string" then
		return Result.error("Game.fromJsonData expects placeId to be a number or a string")
	end

	local v = GameInfoModel.new(tostring(data.universeId), tostring(data.rootPlaceId), data.name)
	GameInfoModel._fromSharedJson(v, data)

	return Result.success(v)
end

function GameInfoModel.fromOmniApi(data)
	if type(data.universeId) ~= "number" and type(data.universeId) ~= "string" then
		return Result.error("DiscoveryGame.fromJsonData expects universeId to be a number or a string")
	end

	if type(data.rootPlaceId) ~= "number" and type(data.rootPlaceId) ~= "string" then
		return Result.error("DiscoveryGame.fromJsonData expects rootPlaceId to be a number or a string")
	end

	local v = GameInfoModel.new(tostring(data.universeId), tostring(data.rootPlaceId), data.name)
	GameInfoModel._fromSharedJson(v, data)
	v.friendActivityTitle = data.friendActivityTitle
	v.friendVisitedString = data.friendVisitedString
	v.friendVisits = data.friendVisits
	local navigationUniverseId

	if data.navigationUid then
		navigationUniverseId = tostring(data.navigationUid)
	end

	v.navigationUniverseId = navigationUniverseId

	return Result.success(v)
end

function GameInfoModel.fromOmniAutocompleteApi(data)
	if type(data.universeId) ~= "number" and type(data.universeId) ~= "string" then
		return Result.error("GameInfoModel.fromOmniAutocompleteApi expects universeId to be a number or a string")
	end

	if type(data.rootPlaceId) ~= "number" and type(data.rootPlaceId) ~= "string" then
		return Result.error("GameInfoModel.fromOmniAutocompleteApi expects placeId to be a number or a string")
	end

	local v = GameInfoModel.new(tostring(data.universeId), tostring(data.rootPlaceId), data.name)
	GameInfoModel._fromSharedJson(v, data)

	return Result.success(v)
end

function GameInfoModel.fromSearchApi(data)
	if type(data.universeId) ~= "number" and type(data.universeId) ~= "string" then
		return Result.error("GameInfoModel.fromSearchApi expects universeId to be a number or a string")
	end

	if type(data.rootPlaceId) ~= "number" and type(data.rootPlaceId) ~= "string" then
		return Result.error("GameInfoModel.fromSearchApi expects rootPlaceId to be a number or a string")
	end

	if type(data.creatorId) ~= "number" and type(data.creatorId) ~= "string" then
		return Result.error("GameInfoModel.fromSearchApi expects creatorId to be a number or a string")
	end

	local v = GameInfoModel.new(tostring(data.universeId), tostring(data.rootPlaceId), data.name)
	GameInfoModel._fromSharedJson(v, data)
	v.creatorId = tostring(data.creatorId)
	v.creatorName = data.creatorName

	return Result.success(v)
end

if FFlagEnableTopSongsSort then
	function GameInfoModel.fromMusicDiscoveryApi(data)
		if type(data.universeId) ~= "number" and type(data.universeId) ~= "string" then
			return Result.error("GameInfoModel.fromMusicDiscoveryApi expects universeId to be a number or a string")
		end

		if type(data.rootPlaceId) ~= "number" and type(data.rootPlaceId) ~= "string" then
			return Result.error("GameInfoModel.fromMusicDiscoveryApi expects rootPlaceId to be a number or a string")
		end

		local v = GameInfoModel.new(tostring(data.universeId), tostring(data.rootPlaceId), data.name)
		v.playerCount = data.playerCount
		v.totalDownVotes = data.downVotes
		v.totalUpVotes = data.upVotes

		return Result.success(v)
	end
end

return GameInfoModel
