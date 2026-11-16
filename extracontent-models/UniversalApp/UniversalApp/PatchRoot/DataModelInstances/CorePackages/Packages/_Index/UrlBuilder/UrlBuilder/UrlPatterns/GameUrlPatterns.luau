local AppsFlyerUtil = require(script.Parent.utils.AppsFlyerUtil)

return function(p)
	local v = {}

	v.info = {
		webpage = p.fromString("www:games/{placeId}"),
		store = p.fromString("www:games/store-section/{universeId}"),
		badges = p.fromString("www:games/badges-section/{universeId}"),
		servers = p.fromString("www:games/servers-section/{universeId}"),
		serversPreopenCreateVip = p.fromString("www:games/servers-section-preopen-create-vip/{universeId}"),
		group = p.fromString("www:communities/{creatorId}"),
		user = p.fromString("www:users/{creatorId}/profile"),
		pass = p.fromString("www:game-pass/{passId}"),
		creator = function(p2)
			if p2.creatorType == "Group" then
				return v.info.group(p2)
			end

			if p2.creatorType == "User" then
				return v.info.user(p2)
			end

			warn(string.format("%s - unknown creatorType of %s", tostring(script.name), (tostring(p2.creatorType))))
			return nil
		end,
		appsflyer = function(data)
			local description = data.description
			local image = data.image
			local title = data.title

			if description and image and title then
				return p.fromString("appsflyer:Ebh5?pid=share&is_retargeting=true&af_og_title={title}&af_og_image={image}&af_og_description={description}&af_dp={mobileUrl}&af_web_dp={webUrl}")({
					image = image,
					title = title,
					description = AppsFlyerUtil.sanitizeDescription(description),
					mobileUrl = p.fromString("mobilenav:game_details?gameId={universeId}")(data),
					webUrl = v.info.webpage(data)
				})
			end

			return p.fromString("appsflyer:Ebh5?pid=share&is_retargeting=true&af_dp={mobileUrl}&af_web_dp={webUrl}")({
				mobileUrl = p.fromString("mobilenav:game_details?gameId={universeId}")(data),
				webUrl = v.info.webpage(data)
			})
		end
	}

	v.details = p.fromString("games:games?{universeIds}")
	v.playability = p.fromString("games:games/multiget-playability-status?{universeIds}")
	v.media = p.fromString("games:games/{universeId}/media")
	v.favorite = p.fromString("games:games/{universeId}/favorites")
	v.social = p.fromString("games:games/{universeId}/social-links/list")
	v.recommended = p.fromString("games:games/recommendations/game/{universeId}?{paginationKey|}&{maxRows|6}")
	v.thumbnail = p.fromString("games:games/game-thumbnails?{height|150}&{width|150}&{imageTokens}")
	v.vote = {
		all = p.fromString("games:games/{universeId}/votes"),
		get = p.fromString("games:games/{universeId}/votes/user"),
		set = p.fromString("games:games/{universeId}/user-votes")
	}

	v.follow = {
		get = p.fromString("followings:users/{userId}/universes/{universeId}/status"),
		set = p.fromString("followings:users/{userId}/universes/{universeId}")
	}

	v.report = p.fromString("www:abusereport/asset?id={placeId}")

	v.place = p.fromString("games:games/multiget-place-details?{placeIds}")

	return v
end
