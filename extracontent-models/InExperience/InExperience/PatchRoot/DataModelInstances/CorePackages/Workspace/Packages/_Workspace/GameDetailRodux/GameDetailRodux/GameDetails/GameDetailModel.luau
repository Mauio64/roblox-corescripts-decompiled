local parent = script:FindFirstAncestor("GameDetailRodux").Parent

local Time = require(parent.Time)
local DateTime = Time.DateTime

local DiscoveryUtils = require(parent.DiscoveryUtils)
local getZendeskUrl = DiscoveryUtils.getZendeskUrl
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppEdpNonSduiBuildAttribution = SharedFlags.FFlagLuaAppEdpNonSduiBuildAttribution

local GameDetailModel = {}

function GameDetailModel.new()
	return {}
end

function GameDetailModel.mock(id, name, value)
	local v = GameDetailModel.new()

	local v2 = DateTime.new()
	local v3 = DateTime.fromUnixTimestamp(v2:GetUnixTimestamp() + 60)

	v.id = id
	v.rootPlaceId = "370731277"
	v.name = name
	v.description = "This is MeepCity"
	v.creator = {
		id = 123247,
		name = "alexnewtron",
		type = "User",
		isRNVAccount = false,
		hasVerifiedBadge = false
	}

	v.price = nil
	v.isExperimental = false
	v.allowedGearGenres = { "TownAndCity" }
	v.allowedGearCategories = {}
	v.playing = 49252
	v.visits = 2358954901
	v.maxPlayers = value or 110
	v.created = v2:GetIsoDate()
	v.updated = v3:GetIsoDate()
	v.studioAccessToApisAllowed = true
	v.universeAvatarType = "MorphToR15"
	v.genre = "Town and City"
	v.genre_l1 = "Test Genre"
	v.genre_l2 = "Test Subgenre"
	return v
end

function GameDetailModel.fromJsonData(data)
	local v = GameDetailModel.new()

	v.id = tostring(data.id)
	v.rootPlaceId = tostring(data.rootPlaceId)
	v.name = data.name
	v.description = data.description
	v.creator = {
		id = data.creator.id,
		name = data.creator.name,
		type = data.creator.type,
		isRNVAccount = data.creator.isRNVAccount,
		hasVerifiedBadge = data.creator.hasVerifiedBadge
	}

	v.price = data.price
	v.isExperimental = data.isExperimental
	v.allowedGearGenres = data.allowedGearGenres
	v.allowedGearCategories = data.allowedGearCategories
	v.playing = data.playing
	v.visits = data.visits
	v.maxPlayers = data.maxPlayers
	v.created = data.created
	v.updated = data.updated
	v.studioAccessToApisAllowed = data.studioAccessToApisAllowed
	v.universeAvatarType = data.universeAvatarType
	v.genre = data.genre
	v.genre_l1 = data.genre_l1
	v.genre_l2 = data.genre_l2
	v.licenseDescription = data.licenseDescription

	v.localizedFiatPrice = data.localizedFiatPrice

	v.refundLink = data.refundLink

	if data.refundPolicy then
		v.refundPolicy = {
			policyText = data.refundPolicy.policyText,
			learnMoreUrl = getZendeskUrl(
				data.refundPolicy.learnMoreBaseUrl,
				data.refundPolicy.locale,
				data.refundPolicy.articleId
			)
		}
	end

	if FFlagLuaAppEdpNonSduiBuildAttribution then
		v.creationSource = data.creationSource
	end

	return v
end

return GameDetailModel
