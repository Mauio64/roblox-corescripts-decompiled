local AppsFlyerUtil = require(script.Parent.utils.AppsFlyerUtil)

return function(p1) -- line: 4
	-- upvalues: AppsFlyerUtil (copy)
	local t1 = {}

	t1.info = {
		webpage = p1.fromString("www:games/{placeId}"),
		store = p1.fromString("www:games/store-section/{universeId}"),
		badges = p1.fromString("www:games/badges-section/{universeId}"),
		servers = p1.fromString("www:games/servers-section/{universeId}"),
		serversPreopenCreateVip = p1.fromString("www:games/servers-section-preopen-create-vip/{universeId}"),
		group = p1.fromString("www:communities/{creatorId}"),
		user = p1.fromString("www:users/{creatorId}/profile"),
		pass = p1.fromString("www:game-pass/{passId}"),
		creator = function(p2) -- line: 19
			-- upvalues: t1 (copy)
			if p2.creatorType == "Group" then
				return t1.info.group(p2)
			end

			if p2.creatorType == "User" then
				return t1.info.user(p2)
			end

			warn(string.format("%s - unknown creatorType of %s", tostring(script.name), (tostring(p2.creatorType))))

			return nil
		end,
		appsflyer = function(p3) -- line: 28
			-- upvalues: p1 (copy), AppsFlyerUtil (copy), t1 (copy)
			local description = p3.description
			local image = p3.image
			local title = p3.title

			if description and (image and title) then
				return p1.fromString("appsflyer:Ebh5?pid=share&is_retargeting=true&af_og_title={title}&af_og_image={image}&af_og_description={description}&af_dp={mobileUrl}&af_web_dp={webUrl}")({
					image = image,
					title = title,
					description = AppsFlyerUtil.sanitizeDescription(description),
					mobileUrl = p1.fromString("mobilenav:game_details?gameId={universeId}")(p3),
					webUrl = t1.info.webpage(p3)
				})
			end

			return p1.fromString("appsflyer:Ebh5?pid=share&is_retargeting=true&af_dp={mobileUrl}&af_web_dp={webUrl}")({
				mobileUrl = p1.fromString("mobilenav:game_details?gameId={universeId}")(p3),
				webUrl = t1.info.webpage(p3)
			})
		end
	}
	t1.details = p1.fromString("games:games?{universeIds}")
	t1.playability = p1.fromString("games:games/multiget-playability-status?{universeIds}")
	t1.media = p1.fromString("games:games/{universeId}/media")
	t1.favorite = p1.fromString("games:games/{universeId}/favorites")
	t1.social = p1.fromString("games:games/{universeId}/social-links/list")
	t1.recommended = p1.fromString("games:games/recommendations/game/{universeId}?{paginationKey|}&{maxRows|6}")
	t1.thumbnail = p1.fromString("games:games/game-thumbnails?{height|150}&{width|150}&{imageTokens}")
	t1.vote = {
		all = p1.fromString("games:games/{universeId}/votes"),
		get = p1.fromString("games:games/{universeId}/votes/user"),
		set = p1.fromString("games:games/{universeId}/user-votes")
	}
	t1.follow = {
		get = p1.fromString("followings:users/{userId}/universes/{universeId}/status"),
		set = p1.fromString("followings:users/{userId}/universes/{universeId}")
	}
	t1.report = p1.fromString("www:abusereport/asset?id={placeId}")
	t1.place = p1.fromString("games:games/multiget-place-details?{placeIds}")

	return t1
end
