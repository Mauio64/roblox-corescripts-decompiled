local Parent = script:FindFirstAncestor("GameDetailRodux").Parent
local DateTime = require(Parent.Time).DateTime
local getZendeskUrl = require(Parent.DiscoveryUtils).getZendeskUrl
local t1 = {
	new = function() -- line: 52
		return {}
	end
}

function t1.mock(p1, p2, p3) -- line: 58
	-- upvalues: t1 (copy), DateTime (copy)
	local v8 = t1.new()
	local v9 = DateTime.new()
	local v10 = DateTime.fromUnixTimestamp(v9:GetUnixTimestamp() + 60)

	v8.id = p1
	v8.rootPlaceId = "370731277"
	v8.name = p2
	v8.description = "This is MeepCity"
	v8.creator = {
		id = 123247,
		name = "alexnewtron",
		type = "User",
		isRNVAccount = false,
		hasVerifiedBadge = false
	}
	v8.price = nil
	v8.isExperimental = false
	v8.allowedGearGenres = { "TownAndCity" }
	v8.allowedGearCategories = {}
	v8.playing = 49252
	v8.visits = 2358954901
	v8.maxPlayers = p3 or 110
	v8.created = v9:GetIsoDate()
	v8.updated = v10:GetIsoDate()
	v8.studioAccessToApisAllowed = true
	v8.universeAvatarType = "MorphToR15"
	v8.genre = "Town and City"
	v8.genre_l1 = "Test Genre"
	v8.genre_l2 = "Test Subgenre"

	return v8
end
function t1.fromJsonData(p4) -- line: 92
	-- upvalues: t1 (copy), getZendeskUrl (copy)
	local v12 = t1.new()

	v12.id = tostring(p4.id)
	v12.rootPlaceId = tostring(p4.rootPlaceId)
	v12.name = p4.name
	v12.description = p4.description
	v12.creator = {
		id = p4.creator.id,
		name = p4.creator.name,
		type = p4.creator.type,
		isRNVAccount = p4.creator.isRNVAccount,
		hasVerifiedBadge = p4.creator.hasVerifiedBadge
	}
	v12.price = p4.price
	v12.isExperimental = p4.isExperimental
	v12.allowedGearGenres = p4.allowedGearGenres
	v12.allowedGearCategories = p4.allowedGearCategories
	v12.playing = p4.playing
	v12.visits = p4.visits
	v12.maxPlayers = p4.maxPlayers
	v12.created = p4.created
	v12.updated = p4.updated
	v12.studioAccessToApisAllowed = p4.studioAccessToApisAllowed
	v12.universeAvatarType = p4.universeAvatarType
	v12.genre = p4.genre
	v12.genre_l1 = p4.genre_l1
	v12.genre_l2 = p4.genre_l2
	v12.licenseDescription = p4.licenseDescription
	v12.localizedFiatPrice = p4.localizedFiatPrice
	v12.refundLink = p4.refundLink

	if p4.refundPolicy then
		v12.refundPolicy = {
			policyText = p4.refundPolicy.policyText,
			learnMoreUrl = getZendeskUrl(p4.refundPolicy.learnMoreBaseUrl, p4.refundPolicy.locale, p4.refundPolicy.articleId)
		}
	end

	return v12
end

return t1
