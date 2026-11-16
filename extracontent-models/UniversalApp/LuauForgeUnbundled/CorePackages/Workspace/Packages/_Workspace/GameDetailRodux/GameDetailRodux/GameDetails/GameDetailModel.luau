local dateTime = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/Time").DateTime

local getZendeskUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/DiscoveryUtils").getZendeskUrl
local fFlagLuaAppEdpNonSduiBuildAttribution = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/SharedFlags").FFlagLuaAppEdpNonSduiBuildAttribution

local v5 = {}

function v5.new()
	return {}
end

function v5.mock(id, name, value)
	local v6 = v5.new()

	local v7 = dateTime.new()
	local v8 = dateTime.fromUnixTimestamp(v7:GetUnixTimestamp() + 60)

	v6.id = id
	v6.rootPlaceId = "370731277"
	v6.name = name
	v6.description = "This is MeepCity"
	v6.creator = {
		id = 123247,
		name = "alexnewtron",
		type = "User",
		isRNVAccount = false,
		hasVerifiedBadge = false
	}

	v6.price = nil
	v6.isExperimental = false
	v6.allowedGearGenres = { "TownAndCity" }
	v6.allowedGearCategories = {}
	v6.playing = 49252
	v6.visits = 2358954901
	v6.maxPlayers = value or 110
	v6.created = v7:GetIsoDate()
	v6.updated = v8:GetIsoDate()
	v6.studioAccessToApisAllowed = true
	v6.universeAvatarType = "MorphToR15"
	v6.genre = "Town and City"
	v6.genre_l1 = "Test Genre"
	v6.genre_l2 = "Test Subgenre"
	return v6
end

function v5.fromJsonData(data)
	local v6 = v5.new()

	v6.id = tostring(data.id)
	v6.rootPlaceId = tostring(data.rootPlaceId)
	v6.name = data.name
	v6.description = data.description
	v6.creator = {
		id = data.creator.id,
		name = data.creator.name,
		type = data.creator.type,
		isRNVAccount = data.creator.isRNVAccount,
		hasVerifiedBadge = data.creator.hasVerifiedBadge
	}

	v6.price = data.price
	v6.isExperimental = data.isExperimental
	v6.allowedGearGenres = data.allowedGearGenres
	v6.allowedGearCategories = data.allowedGearCategories
	v6.playing = data.playing
	v6.visits = data.visits
	v6.maxPlayers = data.maxPlayers
	v6.created = data.created
	v6.updated = data.updated
	v6.studioAccessToApisAllowed = data.studioAccessToApisAllowed
	v6.universeAvatarType = data.universeAvatarType
	v6.genre = data.genre
	v6.genre_l1 = data.genre_l1
	v6.genre_l2 = data.genre_l2
	v6.licenseDescription = data.licenseDescription

	v6.localizedFiatPrice = data.localizedFiatPrice

	v6.refundLink = data.refundLink

	if data.refundPolicy then
		v6.refundPolicy = {
			policyText = data.refundPolicy.policyText,
			learnMoreUrl = getZendeskUrl(
				data.refundPolicy.learnMoreBaseUrl,
				data.refundPolicy.locale,
				data.refundPolicy.articleId
			)
		}
	end

	if fFlagLuaAppEdpNonSduiBuildAttribution then
		v6.creationSource = data.creationSource
	end

	return v6
end

return v5
