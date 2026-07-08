local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local badge_data = require(script.Parent.badge_data)
local universe_data = require(script.Parent.universe_data)
local universe_user_favorite_data = require(script.Parent.universe_user_favorite_data)
local universe_user_follow_data = require(script.Parent.universe_user_follow_data)
local universe_user_follow_limit_data = require(script.Parent.universe_user_follow_limit_data)
local universe_user_vote_data = require(script.Parent.universe_user_vote_data)
local universe_user_vote_feedback_metadata_data = require(script.Parent.universe_user_vote_feedback_metadata_data)
local creator_data = require(script.Parent.creator_data)
local event_data = require(script.Parent.event_data)
local song_data = require(script.Parent.song_data)
local game_pass_data = require(script.Parent.game_pass_data)
local playability_data = require(script.Parent.playability_data)
local media_asset_data = require(script.Parent.media_asset_data)
local social_link_data = require(script.Parent.social_link_data)
local marketplace_catalog_category_data = require(script.Parent.marketplace_catalog_category_data)
local marketplace_asset_data = require(script.Parent.marketplace_asset_data)
local marketplace_bundle_data = require(script.Parent.marketplace_bundle_data)
local marketplace_look_data = require(script.Parent.marketplace_look_data)
local catalog_sort_data = require(script.Parent.catalog_sort_data)
local game_developer_product_data = require(script.Parent.game_developer_product_data)
local game_subscription_data = require(script.Parent.game_subscription_data)
local age_recommendation_data = require(script.Parent.age_recommendation_data)
local user_profile_data = require(script.Parent.user_profile_data)
local moment_data = require(script.Parent.moment_data)
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 894
	-- upvalues: t2 (copy)
	return (setmetatable({
		badge = if t3 ~= nil and t3.badge ~= nil then t3.badge else {},
		universe = if t3 ~= nil and t3.universe ~= nil then t3.universe else {},
		creator = if t3 ~= nil and t3.creator ~= nil then t3.creator else {},
		event = if t3 ~= nil and t3.event ~= nil then t3.event else {},
		song = if t3 ~= nil and t3.song ~= nil then t3.song else {},
		game_pass = if t3 ~= nil and t3.game_pass ~= nil then t3.game_pass else {},
		media_asset = if t3 ~= nil and t3.media_asset ~= nil then t3.media_asset else {},
		social_link = if t3 ~= nil and t3.social_link ~= nil then t3.social_link else {},
		game_developer_product = if t3 ~= nil and t3.game_developer_product ~= nil then t3.game_developer_product else {},
		game_subscription = if t3 ~= nil and t3.game_subscription ~= nil then t3.game_subscription else {},
		marketplace_catalog_category = if t3 ~= nil and t3.marketplace_catalog_category ~= nil then t3.marketplace_catalog_category else {},
		marketplace_asset = if t3 ~= nil and t3.marketplace_asset ~= nil then t3.marketplace_asset else {},
		marketplace_bundle = if t3 ~= nil and t3.marketplace_bundle ~= nil then t3.marketplace_bundle else {},
		marketplace_look = if t3 ~= nil and t3.marketplace_look ~= nil then t3.marketplace_look else {},
		catalog_sort = if t3 ~= nil and t3.catalog_sort ~= nil then t3.catalog_sort else {},
		age_recommendation = if t3 ~= nil and t3.age_recommendation ~= nil then t3.age_recommendation else {},
		universe_user_follow = if t3 ~= nil and t3.universe_user_follow ~= nil then t3.universe_user_follow else {},
		universe_user_vote = if t3 ~= nil and t3.universe_user_vote ~= nil then t3.universe_user_vote else {},
		user_profile = if t3 ~= nil and t3.user_profile ~= nil then t3.user_profile else {},
		universe_user_favorite = if t3 ~= nil and t3.universe_user_favorite ~= nil then t3.universe_user_favorite else {},
		playability = if t3 ~= nil and t3.playability ~= nil then t3.playability else {},
		universe_user_follow_limit = if t3 ~= nil and t3.universe_user_follow_limit ~= nil then t3.universe_user_follow_limit else {},
		universe_user_vote_feedback_metadata = if t3 ~= nil and t3.universe_user_vote_feedback_metadata ~= nil then t3.universe_user_vote_feedback_metadata else {},
		moment = if t3 ~= nil and t3.moment ~= nil then t3.moment else {}
	}, t2))
end
function t2.encode(p1) -- line: 936
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.badge ~= nil and next(p1.badge) ~= nil then
		for v57, v58 in p1.badge do
			local buf2 = buffer.create(0)
			local v60, v61 = proto.writeTag(buf2, 0, 1, proto.wireTypes.lengthDelimited)
			local v62, v63 = proto.writeString(v60, v61, v57)
			local v64 = v58:encode()
			local v65, v66 = proto.writeTag(v62, v63, 2, proto.wireTypes.lengthDelimited)
			local v67, v68 = proto.writeBuffer(v65, v66, v64, buffer.len(v64))
			local v69, v70 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v69, v70, v67, v68)
		end
	end

	if p1.universe ~= nil and next(p1.universe) ~= nil then
		for v71, v72 in p1.universe do
			local buf3 = buffer.create(0)
			local v74, v75 = proto.writeTag(buf3, 0, 1, proto.wireTypes.lengthDelimited)
			local v76, v77 = proto.writeString(v74, v75, v71)
			local v78 = v72:encode()
			local v79, v80 = proto.writeTag(v76, v77, 2, proto.wireTypes.lengthDelimited)
			local v81, v82 = proto.writeBuffer(v79, v80, v78, buffer.len(v78))
			local v83, v84 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v83, v84, v81, v82)
		end
	end

	if p1.creator ~= nil and next(p1.creator) ~= nil then
		for v85, v86 in p1.creator do
			local buf4 = buffer.create(0)
			local v88, v89 = proto.writeTag(buf4, 0, 1, proto.wireTypes.lengthDelimited)
			local v90, v91 = proto.writeString(v88, v89, v85)
			local v92 = v86:encode()
			local v93, v94 = proto.writeTag(v90, v91, 2, proto.wireTypes.lengthDelimited)
			local v95, v96 = proto.writeBuffer(v93, v94, v92, buffer.len(v92))
			local v97, v98 = proto.writeTag(buf, n1, 3, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v97, v98, v95, v96)
		end
	end

	if p1.event ~= nil and next(p1.event) ~= nil then
		for v99, v100 in p1.event do
			local buf5 = buffer.create(0)
			local v102, v103 = proto.writeTag(buf5, 0, 1, proto.wireTypes.lengthDelimited)
			local v104, v105 = proto.writeString(v102, v103, v99)
			local v106 = v100:encode()
			local v107, v108 = proto.writeTag(v104, v105, 2, proto.wireTypes.lengthDelimited)
			local v109, v110 = proto.writeBuffer(v107, v108, v106, buffer.len(v106))
			local v111, v112 = proto.writeTag(buf, n1, 4, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v111, v112, v109, v110)
		end
	end

	if p1.song ~= nil and next(p1.song) ~= nil then
		for v113, v114 in p1.song do
			local buf6 = buffer.create(0)
			local v116, v117 = proto.writeTag(buf6, 0, 1, proto.wireTypes.lengthDelimited)
			local v118, v119 = proto.writeString(v116, v117, v113)
			local v120 = v114:encode()
			local v121, v122 = proto.writeTag(v118, v119, 2, proto.wireTypes.lengthDelimited)
			local v123, v124 = proto.writeBuffer(v121, v122, v120, buffer.len(v120))
			local v125, v126 = proto.writeTag(buf, n1, 5, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v125, v126, v123, v124)
		end
	end

	if p1.game_pass ~= nil and next(p1.game_pass) ~= nil then
		for v127, v128 in p1.game_pass do
			local buf7 = buffer.create(0)
			local v130, v131 = proto.writeTag(buf7, 0, 1, proto.wireTypes.lengthDelimited)
			local v132, v133 = proto.writeString(v130, v131, v127)
			local v134 = v128:encode()
			local v135, v136 = proto.writeTag(v132, v133, 2, proto.wireTypes.lengthDelimited)
			local v137, v138 = proto.writeBuffer(v135, v136, v134, buffer.len(v134))
			local v139, v140 = proto.writeTag(buf, n1, 6, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v139, v140, v137, v138)
		end
	end

	if p1.media_asset ~= nil and next(p1.media_asset) ~= nil then
		for v141, v142 in p1.media_asset do
			local buf8 = buffer.create(0)
			local v144, v145 = proto.writeTag(buf8, 0, 1, proto.wireTypes.lengthDelimited)
			local v146, v147 = proto.writeString(v144, v145, v141)
			local v148 = v142:encode()
			local v149, v150 = proto.writeTag(v146, v147, 2, proto.wireTypes.lengthDelimited)
			local v151, v152 = proto.writeBuffer(v149, v150, v148, buffer.len(v148))
			local v153, v154 = proto.writeTag(buf, n1, 7, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v153, v154, v151, v152)
		end
	end

	if p1.social_link ~= nil and next(p1.social_link) ~= nil then
		for v155, v156 in p1.social_link do
			local buf9 = buffer.create(0)
			local v158, v159 = proto.writeTag(buf9, 0, 1, proto.wireTypes.lengthDelimited)
			local v160, v161 = proto.writeString(v158, v159, v155)
			local v162 = v156:encode()
			local v163, v164 = proto.writeTag(v160, v161, 2, proto.wireTypes.lengthDelimited)
			local v165, v166 = proto.writeBuffer(v163, v164, v162, buffer.len(v162))
			local v167, v168 = proto.writeTag(buf, n1, 8, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v167, v168, v165, v166)
		end
	end

	if p1.game_developer_product ~= nil and next(p1.game_developer_product) ~= nil then
		for v169, v170 in p1.game_developer_product do
			local buf10 = buffer.create(0)
			local v172, v173 = proto.writeTag(buf10, 0, 1, proto.wireTypes.lengthDelimited)
			local v174, v175 = proto.writeString(v172, v173, v169)
			local v176 = v170:encode()
			local v177, v178 = proto.writeTag(v174, v175, 2, proto.wireTypes.lengthDelimited)
			local v179, v180 = proto.writeBuffer(v177, v178, v176, buffer.len(v176))
			local v181, v182 = proto.writeTag(buf, n1, 9, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v181, v182, v179, v180)
		end
	end

	if p1.game_subscription ~= nil and next(p1.game_subscription) ~= nil then
		for v183, v184 in p1.game_subscription do
			local buf11 = buffer.create(0)
			local v186, v187 = proto.writeTag(buf11, 0, 1, proto.wireTypes.lengthDelimited)
			local v188, v189 = proto.writeString(v186, v187, v183)
			local v190 = v184:encode()
			local v191, v192 = proto.writeTag(v188, v189, 2, proto.wireTypes.lengthDelimited)
			local v193, v194 = proto.writeBuffer(v191, v192, v190, buffer.len(v190))
			local v195, v196 = proto.writeTag(buf, n1, 10, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v195, v196, v193, v194)
		end
	end

	if p1.marketplace_catalog_category ~= nil and next(p1.marketplace_catalog_category) ~= nil then
		for v197, v198 in p1.marketplace_catalog_category do
			local buf12 = buffer.create(0)
			local v200, v201 = proto.writeTag(buf12, 0, 1, proto.wireTypes.lengthDelimited)
			local v202, v203 = proto.writeString(v200, v201, v197)
			local v204 = v198:encode()
			local v205, v206 = proto.writeTag(v202, v203, 2, proto.wireTypes.lengthDelimited)
			local v207, v208 = proto.writeBuffer(v205, v206, v204, buffer.len(v204))
			local v209, v210 = proto.writeTag(buf, n1, 11, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v209, v210, v207, v208)
		end
	end

	if p1.marketplace_asset ~= nil and next(p1.marketplace_asset) ~= nil then
		for v211, v212 in p1.marketplace_asset do
			local buf13 = buffer.create(0)
			local v214, v215 = proto.writeTag(buf13, 0, 1, proto.wireTypes.lengthDelimited)
			local v216, v217 = proto.writeString(v214, v215, v211)
			local v218 = v212:encode()
			local v219, v220 = proto.writeTag(v216, v217, 2, proto.wireTypes.lengthDelimited)
			local v221, v222 = proto.writeBuffer(v219, v220, v218, buffer.len(v218))
			local v223, v224 = proto.writeTag(buf, n1, 12, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v223, v224, v221, v222)
		end
	end

	if p1.marketplace_bundle ~= nil and next(p1.marketplace_bundle) ~= nil then
		for v225, v226 in p1.marketplace_bundle do
			local buf14 = buffer.create(0)
			local v228, v229 = proto.writeTag(buf14, 0, 1, proto.wireTypes.lengthDelimited)
			local v230, v231 = proto.writeString(v228, v229, v225)
			local v232 = v226:encode()
			local v233, v234 = proto.writeTag(v230, v231, 2, proto.wireTypes.lengthDelimited)
			local v235, v236 = proto.writeBuffer(v233, v234, v232, buffer.len(v232))
			local v237, v238 = proto.writeTag(buf, n1, 13, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v237, v238, v235, v236)
		end
	end

	if p1.marketplace_look ~= nil and next(p1.marketplace_look) ~= nil then
		for v239, v240 in p1.marketplace_look do
			local buf15 = buffer.create(0)
			local v242, v243 = proto.writeTag(buf15, 0, 1, proto.wireTypes.lengthDelimited)
			local v244, v245 = proto.writeString(v242, v243, v239)
			local v246 = v240:encode()
			local v247, v248 = proto.writeTag(v244, v245, 2, proto.wireTypes.lengthDelimited)
			local v249, v250 = proto.writeBuffer(v247, v248, v246, buffer.len(v246))
			local v251, v252 = proto.writeTag(buf, n1, 14, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v251, v252, v249, v250)
		end
	end

	if p1.catalog_sort ~= nil and next(p1.catalog_sort) ~= nil then
		for v253, v254 in p1.catalog_sort do
			local buf16 = buffer.create(0)
			local v256, v257 = proto.writeTag(buf16, 0, 1, proto.wireTypes.lengthDelimited)
			local v258, v259 = proto.writeString(v256, v257, v253)
			local v260 = v254:encode()
			local v261, v262 = proto.writeTag(v258, v259, 2, proto.wireTypes.lengthDelimited)
			local v263, v264 = proto.writeBuffer(v261, v262, v260, buffer.len(v260))
			local v265, v266 = proto.writeTag(buf, n1, 15, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v265, v266, v263, v264)
		end
	end

	if p1.age_recommendation ~= nil and next(p1.age_recommendation) ~= nil then
		for v267, v268 in p1.age_recommendation do
			local buf17 = buffer.create(0)
			local v270, v271 = proto.writeTag(buf17, 0, 1, proto.wireTypes.lengthDelimited)
			local v272, v273 = proto.writeString(v270, v271, v267)
			local v274 = v268:encode()
			local v275, v276 = proto.writeTag(v272, v273, 2, proto.wireTypes.lengthDelimited)
			local v277, v278 = proto.writeBuffer(v275, v276, v274, buffer.len(v274))
			local v279, v280 = proto.writeTag(buf, n1, 16, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v279, v280, v277, v278)
		end
	end

	if p1.universe_user_follow ~= nil and next(p1.universe_user_follow) ~= nil then
		for v281, v282 in p1.universe_user_follow do
			local buf18 = buffer.create(0)
			local v284, v285 = proto.writeTag(buf18, 0, 1, proto.wireTypes.lengthDelimited)
			local v286, v287 = proto.writeString(v284, v285, v281)
			local v288 = v282:encode()
			local v289, v290 = proto.writeTag(v286, v287, 2, proto.wireTypes.lengthDelimited)
			local v291, v292 = proto.writeBuffer(v289, v290, v288, buffer.len(v288))
			local v293, v294 = proto.writeTag(buf, n1, 17, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v293, v294, v291, v292)
		end
	end

	if p1.universe_user_vote ~= nil and next(p1.universe_user_vote) ~= nil then
		for v295, v296 in p1.universe_user_vote do
			local buf19 = buffer.create(0)
			local v298, v299 = proto.writeTag(buf19, 0, 1, proto.wireTypes.lengthDelimited)
			local v300, v301 = proto.writeString(v298, v299, v295)
			local v302 = v296:encode()
			local v303, v304 = proto.writeTag(v300, v301, 2, proto.wireTypes.lengthDelimited)
			local v305, v306 = proto.writeBuffer(v303, v304, v302, buffer.len(v302))
			local v307, v308 = proto.writeTag(buf, n1, 18, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v307, v308, v305, v306)
		end
	end

	if p1.user_profile ~= nil and next(p1.user_profile) ~= nil then
		for v309, v310 in p1.user_profile do
			local buf20 = buffer.create(0)
			local v312, v313 = proto.writeTag(buf20, 0, 1, proto.wireTypes.lengthDelimited)
			local v314, v315 = proto.writeString(v312, v313, v309)
			local v316 = v310:encode()
			local v317, v318 = proto.writeTag(v314, v315, 2, proto.wireTypes.lengthDelimited)
			local v319, v320 = proto.writeBuffer(v317, v318, v316, buffer.len(v316))
			local v321, v322 = proto.writeTag(buf, n1, 19, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v321, v322, v319, v320)
		end
	end

	if p1.universe_user_favorite ~= nil and next(p1.universe_user_favorite) ~= nil then
		for v323, v324 in p1.universe_user_favorite do
			local buf21 = buffer.create(0)
			local v326, v327 = proto.writeTag(buf21, 0, 1, proto.wireTypes.lengthDelimited)
			local v328, v329 = proto.writeString(v326, v327, v323)
			local v330 = v324:encode()
			local v331, v332 = proto.writeTag(v328, v329, 2, proto.wireTypes.lengthDelimited)
			local v333, v334 = proto.writeBuffer(v331, v332, v330, buffer.len(v330))
			local v335, v336 = proto.writeTag(buf, n1, 20, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v335, v336, v333, v334)
		end
	end

	if p1.playability ~= nil and next(p1.playability) ~= nil then
		for v337, v338 in p1.playability do
			local buf22 = buffer.create(0)
			local v340, v341 = proto.writeTag(buf22, 0, 1, proto.wireTypes.lengthDelimited)
			local v342, v343 = proto.writeString(v340, v341, v337)
			local v344 = v338:encode()
			local v345, v346 = proto.writeTag(v342, v343, 2, proto.wireTypes.lengthDelimited)
			local v347, v348 = proto.writeBuffer(v345, v346, v344, buffer.len(v344))
			local v349, v350 = proto.writeTag(buf, n1, 21, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v349, v350, v347, v348)
		end
	end

	if p1.universe_user_follow_limit ~= nil and next(p1.universe_user_follow_limit) ~= nil then
		for v351, v352 in p1.universe_user_follow_limit do
			local buf23 = buffer.create(0)
			local v354, v355 = proto.writeTag(buf23, 0, 1, proto.wireTypes.lengthDelimited)
			local v356, v357 = proto.writeString(v354, v355, v351)
			local v358 = v352:encode()
			local v359, v360 = proto.writeTag(v356, v357, 2, proto.wireTypes.lengthDelimited)
			local v361, v362 = proto.writeBuffer(v359, v360, v358, buffer.len(v358))
			local v363, v364 = proto.writeTag(buf, n1, 22, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v363, v364, v361, v362)
		end
	end

	if p1.universe_user_vote_feedback_metadata ~= nil and next(p1.universe_user_vote_feedback_metadata) ~= nil then
		for v365, v366 in p1.universe_user_vote_feedback_metadata do
			local buf24 = buffer.create(0)
			local v368, v369 = proto.writeTag(buf24, 0, 1, proto.wireTypes.lengthDelimited)
			local v370, v371 = proto.writeString(v368, v369, v365)
			local v372 = v366:encode()
			local v373, v374 = proto.writeTag(v370, v371, 2, proto.wireTypes.lengthDelimited)
			local v375, v376 = proto.writeBuffer(v373, v374, v372, buffer.len(v372))
			local v377, v378 = proto.writeTag(buf, n1, 23, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v377, v378, v375, v376)
		end
	end

	if p1.moment ~= nil and next(p1.moment) ~= nil then
		for v379, v380 in p1.moment do
			local buf25 = buffer.create(0)
			local v382, v383 = proto.writeTag(buf25, 0, 1, proto.wireTypes.lengthDelimited)
			local v384, v385 = proto.writeString(v382, v383, v379)
			local v386 = v380:encode()
			local v387, v388 = proto.writeTag(v384, v385, 2, proto.wireTypes.lengthDelimited)
			local v389, v390 = proto.writeBuffer(v387, v388, v386, buffer.len(v386))
			local v391, v392 = proto.writeTag(buf, n1, 24, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v391, v392, v389, v390)
		end
	end

	local buf26 = buffer.create(n1)

	buffer.copy(buf26, 0, buf, 0, n1)

	return buf26
end
function t2.decode(p2: buffer) -- line: 1284
	-- upvalues: t2 (copy), proto (copy), t1 (copy), badge_data (copy), universe_data (copy), creator_data (copy), event_data (copy), song_data (copy), game_pass_data (copy), media_asset_data (copy), social_link_data (copy), game_developer_product_data (copy), game_subscription_data (copy), marketplace_catalog_category_data (copy), marketplace_asset_data (copy), marketplace_bundle_data (copy), marketplace_look_data (copy), catalog_sort_data (copy), age_recommendation_data (copy), universe_user_follow_data (copy), universe_user_vote_data (copy), user_profile_data (copy), universe_user_favorite_data (copy), playability_data (copy), universe_user_follow_limit_data (copy), universe_user_vote_feedback_metadata_data (copy), moment_data (copy)
	local v395 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v397, v398

		v397, v398, n2 = proto.readTag(p2, n2)

		if v398 == proto.wireTypes.varint then
			local v399

			v399, n2 = proto.readVarInt(p2, n2)
		elseif v398 == proto.wireTypes.lengthDelimited then
			if v397 == 1 then
				local v400

				v400, n2 = proto.readBuffer(p2, n2)

				local v401 = t1.HydrationContent_BadgeEntry.decode(v400)
				local v402 = badge_data.BadgeData.new()

				v395.badge[v401.key or ""] = v401.value or v402
			elseif v397 == 2 then
				local v403

				v403, n2 = proto.readBuffer(p2, n2)

				local v404 = t1.HydrationContent_UniverseEntry.decode(v403)
				local v405 = universe_data.UniverseData.new()

				v395.universe[v404.key or ""] = v404.value or v405
			elseif v397 == 3 then
				local v406

				v406, n2 = proto.readBuffer(p2, n2)

				local v407 = t1.HydrationContent_CreatorEntry.decode(v406)
				local v408 = creator_data.CreatorData.new()

				v395.creator[v407.key or ""] = v407.value or v408
			elseif v397 == 4 then
				local v409

				v409, n2 = proto.readBuffer(p2, n2)

				local v410 = t1.HydrationContent_EventEntry.decode(v409)
				local v411 = event_data.EventData.new()

				v395.event[v410.key or ""] = v410.value or v411
			elseif v397 == 5 then
				local v412

				v412, n2 = proto.readBuffer(p2, n2)

				local v413 = t1.HydrationContent_SongEntry.decode(v412)
				local v414 = song_data.SongData.new()

				v395.song[v413.key or ""] = v413.value or v414
			elseif v397 == 6 then
				local v415

				v415, n2 = proto.readBuffer(p2, n2)

				local v416 = t1.HydrationContent_GamePassEntry.decode(v415)
				local v417 = game_pass_data.GamePassData.new()

				v395.game_pass[v416.key or ""] = v416.value or v417
			elseif v397 == 7 then
				local v418

				v418, n2 = proto.readBuffer(p2, n2)

				local v419 = t1.HydrationContent_MediaAssetEntry.decode(v418)
				local v420 = media_asset_data.MediaAssetData.new()

				v395.media_asset[v419.key or ""] = v419.value or v420
			elseif v397 == 8 then
				local v421

				v421, n2 = proto.readBuffer(p2, n2)

				local v422 = t1.HydrationContent_SocialLinkEntry.decode(v421)
				local v423 = social_link_data.SocialLinkData.new()

				v395.social_link[v422.key or ""] = v422.value or v423
			elseif v397 == 9 then
				local v424

				v424, n2 = proto.readBuffer(p2, n2)

				local v425 = t1.HydrationContent_GameDeveloperProductEntry.decode(v424)
				local v426 = game_developer_product_data.GameDeveloperProductData.new()

				v395.game_developer_product[v425.key or ""] = v425.value or v426
			elseif v397 == 10 then
				local v427

				v427, n2 = proto.readBuffer(p2, n2)

				local v428 = t1.HydrationContent_GameSubscriptionEntry.decode(v427)
				local v429 = game_subscription_data.GameSubscriptionData.new()

				v395.game_subscription[v428.key or ""] = v428.value or v429
			elseif v397 == 11 then
				local v430

				v430, n2 = proto.readBuffer(p2, n2)

				local v431 = t1.HydrationContent_MarketplaceCatalogCategoryEntry.decode(v430)
				local v432 = marketplace_catalog_category_data.MarketplaceCatalogCategoryData.new()

				v395.marketplace_catalog_category[v431.key or ""] = v431.value or v432
			elseif v397 == 12 then
				local v433

				v433, n2 = proto.readBuffer(p2, n2)

				local v434 = t1.HydrationContent_MarketplaceAssetEntry.decode(v433)
				local v435 = marketplace_asset_data.MarketplaceAssetData.new()

				v395.marketplace_asset[v434.key or ""] = v434.value or v435
			elseif v397 == 13 then
				local v436

				v436, n2 = proto.readBuffer(p2, n2)

				local v437 = t1.HydrationContent_MarketplaceBundleEntry.decode(v436)
				local v438 = marketplace_bundle_data.MarketplaceBundleData.new()

				v395.marketplace_bundle[v437.key or ""] = v437.value or v438
			elseif v397 == 14 then
				local v439

				v439, n2 = proto.readBuffer(p2, n2)

				local v440 = t1.HydrationContent_MarketplaceLookEntry.decode(v439)
				local v441 = marketplace_look_data.MarketplaceLookData.new()

				v395.marketplace_look[v440.key or ""] = v440.value or v441
			elseif v397 == 15 then
				local v442

				v442, n2 = proto.readBuffer(p2, n2)

				local v443 = t1.HydrationContent_CatalogSortEntry.decode(v442)
				local v444 = catalog_sort_data.CatalogSortData.new()

				v395.catalog_sort[v443.key or ""] = v443.value or v444
			elseif v397 == 16 then
				local v445

				v445, n2 = proto.readBuffer(p2, n2)

				local v446 = t1.HydrationContent_AgeRecommendationEntry.decode(v445)
				local v447 = age_recommendation_data.AgeRecommendationData.new()

				v395.age_recommendation[v446.key or ""] = v446.value or v447
			elseif v397 == 17 then
				local v448

				v448, n2 = proto.readBuffer(p2, n2)

				local v449 = t1.HydrationContent_UniverseUserFollowEntry.decode(v448)
				local v450 = universe_user_follow_data.UniverseUserFollowData.new()

				v395.universe_user_follow[v449.key or ""] = v449.value or v450
			elseif v397 == 18 then
				local v451

				v451, n2 = proto.readBuffer(p2, n2)

				local v452 = t1.HydrationContent_UniverseUserVoteEntry.decode(v451)
				local v453 = universe_user_vote_data.UniverseUserVoteData.new()

				v395.universe_user_vote[v452.key or ""] = v452.value or v453
			elseif v397 == 19 then
				local v454

				v454, n2 = proto.readBuffer(p2, n2)

				local v455 = t1.HydrationContent_UserProfileEntry.decode(v454)
				local v456 = user_profile_data.UserProfileData.new()

				v395.user_profile[v455.key or ""] = v455.value or v456
			elseif v397 == 20 then
				local v457

				v457, n2 = proto.readBuffer(p2, n2)

				local v458 = t1.HydrationContent_UniverseUserFavoriteEntry.decode(v457)
				local v459 = universe_user_favorite_data.UniverseUserFavoriteData.new()

				v395.universe_user_favorite[v458.key or ""] = v458.value or v459
			elseif v397 == 21 then
				local v460

				v460, n2 = proto.readBuffer(p2, n2)

				local v461 = t1.HydrationContent_PlayabilityEntry.decode(v460)
				local v462 = playability_data.PlayabilityData.new()

				v395.playability[v461.key or ""] = v461.value or v462
			elseif v397 == 22 then
				local v463

				v463, n2 = proto.readBuffer(p2, n2)

				local v464 = t1.HydrationContent_UniverseUserFollowLimitEntry.decode(v463)
				local v465 = universe_user_follow_limit_data.UniverseUserFollowLimitData.new()

				v395.universe_user_follow_limit[v464.key or ""] = v464.value or v465
			elseif v397 == 23 then
				local v466

				v466, n2 = proto.readBuffer(p2, n2)

				local v467 = t1.HydrationContent_UniverseUserVoteFeedbackMetadataEntry.decode(v466)
				local v468 = universe_user_vote_feedback_metadata_data.UniverseUserVoteFeedbackMetadataData.new()

				v395.universe_user_vote_feedback_metadata[v467.key or ""] = v467.value or v468
			elseif v397 == 24 then
				local v469

				v469, n2 = proto.readBuffer(p2, n2)

				local v470 = t1.HydrationContent_MomentEntry.decode(v469)
				local v471 = moment_data.MomentData.new()

				v395.moment[v470.key or ""] = v470.value or v471
			else
				local v472, v473 = proto.readVarInt(p2, n2)

				n2 = v473 + v472
			end
		elseif v398 == proto.wireTypes.i32 then
			local v474

			v474, n2 = proto.readFixed32(p2, n2)
		elseif v398 == proto.wireTypes.i64 then
			local v475

			v475, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v398)
		end
	end

	return v395
end
function t2.jsonEncode(p3) -- line: 1623
	local t4 = {}

	if p3.badge ~= nil and next(p3.badge) ~= nil then
		local t5 = {}

		for v479, v480 in p3.badge do
			t5[v479] = v480:jsonEncode()
		end

		t4.badge = t5
	end

	if p3.universe ~= nil and next(p3.universe) ~= nil then
		local t6 = {}

		for v482, v483 in p3.universe do
			t6[v482] = v483:jsonEncode()
		end

		t4.universe = t6
	end

	if p3.creator ~= nil and next(p3.creator) ~= nil then
		local t7 = {}

		for v485, v486 in p3.creator do
			t7[v485] = v486:jsonEncode()
		end

		t4.creator = t7
	end

	if p3.event ~= nil and next(p3.event) ~= nil then
		local t8 = {}

		for v488, v489 in p3.event do
			t8[v488] = v489:jsonEncode()
		end

		t4.event = t8
	end

	if p3.song ~= nil and next(p3.song) ~= nil then
		local t9 = {}

		for v491, v492 in p3.song do
			t9[v491] = v492:jsonEncode()
		end

		t4.song = t9
	end

	if p3.game_pass ~= nil and next(p3.game_pass) ~= nil then
		local t10 = {}

		for v494, v495 in p3.game_pass do
			t10[v494] = v495:jsonEncode()
		end

		t4.gamePass = t10
	end

	if p3.media_asset ~= nil and next(p3.media_asset) ~= nil then
		local t11 = {}

		for v497, v498 in p3.media_asset do
			t11[v497] = v498:jsonEncode()
		end

		t4.mediaAsset = t11
	end

	if p3.social_link ~= nil and next(p3.social_link) ~= nil then
		local t12 = {}

		for v500, v501 in p3.social_link do
			t12[v500] = v501:jsonEncode()
		end

		t4.socialLink = t12
	end

	if p3.game_developer_product ~= nil and next(p3.game_developer_product) ~= nil then
		local t13 = {}

		for v503, v504 in p3.game_developer_product do
			t13[v503] = v504:jsonEncode()
		end

		t4.gameDeveloperProduct = t13
	end

	if p3.game_subscription ~= nil and next(p3.game_subscription) ~= nil then
		local t14 = {}

		for v506, v507 in p3.game_subscription do
			t14[v506] = v507:jsonEncode()
		end

		t4.gameSubscription = t14
	end

	if p3.marketplace_catalog_category ~= nil and next(p3.marketplace_catalog_category) ~= nil then
		local t15 = {}

		for v509, v510 in p3.marketplace_catalog_category do
			t15[v509] = v510:jsonEncode()
		end

		t4.marketplaceCatalogCategory = t15
	end

	if p3.marketplace_asset ~= nil and next(p3.marketplace_asset) ~= nil then
		local t16 = {}

		for v512, v513 in p3.marketplace_asset do
			t16[v512] = v513:jsonEncode()
		end

		t4.marketplaceAsset = t16
	end

	if p3.marketplace_bundle ~= nil and next(p3.marketplace_bundle) ~= nil then
		local t17 = {}

		for v515, v516 in p3.marketplace_bundle do
			t17[v515] = v516:jsonEncode()
		end

		t4.marketplaceBundle = t17
	end

	if p3.marketplace_look ~= nil and next(p3.marketplace_look) ~= nil then
		local t18 = {}

		for v518, v519 in p3.marketplace_look do
			t18[v518] = v519:jsonEncode()
		end

		t4.marketplaceLook = t18
	end

	if p3.catalog_sort ~= nil and next(p3.catalog_sort) ~= nil then
		local t19 = {}

		for v521, v522 in p3.catalog_sort do
			t19[v521] = v522:jsonEncode()
		end

		t4.catalogSort = t19
	end

	if p3.age_recommendation ~= nil and next(p3.age_recommendation) ~= nil then
		local t20 = {}

		for v524, v525 in p3.age_recommendation do
			t20[v524] = v525:jsonEncode()
		end

		t4.ageRecommendation = t20
	end

	if p3.universe_user_follow ~= nil and next(p3.universe_user_follow) ~= nil then
		local t21 = {}

		for v527, v528 in p3.universe_user_follow do
			t21[v527] = v528:jsonEncode()
		end

		t4.universeUserFollow = t21
	end

	if p3.universe_user_vote ~= nil and next(p3.universe_user_vote) ~= nil then
		local t22 = {}

		for v530, v531 in p3.universe_user_vote do
			t22[v530] = v531:jsonEncode()
		end

		t4.universeUserVote = t22
	end

	if p3.user_profile ~= nil and next(p3.user_profile) ~= nil then
		local t23 = {}

		for v533, v534 in p3.user_profile do
			t23[v533] = v534:jsonEncode()
		end

		t4.userProfile = t23
	end

	if p3.universe_user_favorite ~= nil and next(p3.universe_user_favorite) ~= nil then
		local t24 = {}

		for v536, v537 in p3.universe_user_favorite do
			t24[v536] = v537:jsonEncode()
		end

		t4.universeUserFavorite = t24
	end

	if p3.playability ~= nil and next(p3.playability) ~= nil then
		local t25 = {}

		for v539, v540 in p3.playability do
			t25[v539] = v540:jsonEncode()
		end

		t4.playability = t25
	end

	if p3.universe_user_follow_limit ~= nil and next(p3.universe_user_follow_limit) ~= nil then
		local t26 = {}

		for v542, v543 in p3.universe_user_follow_limit do
			t26[v542] = v543:jsonEncode()
		end

		t4.universeUserFollowLimit = t26
	end

	if p3.universe_user_vote_feedback_metadata ~= nil and next(p3.universe_user_vote_feedback_metadata) ~= nil then
		local t27 = {}

		for v545, v546 in p3.universe_user_vote_feedback_metadata do
			t27[v545] = v546:jsonEncode()
		end

		t4.universeUserVoteFeedbackMetadata = t27
	end

	if p3.moment ~= nil and next(p3.moment) ~= nil then
		local t28 = {}

		for v548, v549 in p3.moment do
			t28[v548] = v549:jsonEncode()
		end

		t4.moment = t28
	end

	return t4
end
function t2.jsonDecode(t29: {[any]: any}) -- line: 1824
	-- upvalues: t2 (copy), badge_data (copy), universe_data (copy), creator_data (copy), event_data (copy), song_data (copy), game_pass_data (copy), media_asset_data (copy), social_link_data (copy), game_developer_product_data (copy), game_subscription_data (copy), marketplace_catalog_category_data (copy), marketplace_asset_data (copy), marketplace_bundle_data (copy), marketplace_look_data (copy), catalog_sort_data (copy), age_recommendation_data (copy), universe_user_follow_data (copy), universe_user_vote_data (copy), user_profile_data (copy), universe_user_favorite_data (copy), playability_data (copy), universe_user_follow_limit_data (copy), universe_user_vote_feedback_metadata_data (copy), moment_data (copy)
	local v551 = t2.new()

	if t29.badge ~= nil then
		local t30 = {}

		for v553, v554 in t29.badge do
			t30[v553] = badge_data.BadgeData.jsonDecode(v554)
		end

		v551.badge = t30
	end

	if t29.universe ~= nil then
		local t31 = {}

		for v556, v557 in t29.universe do
			t31[v556] = universe_data.UniverseData.jsonDecode(v557)
		end

		v551.universe = t31
	end

	if t29.creator ~= nil then
		local t32 = {}

		for v559, v560 in t29.creator do
			t32[v559] = creator_data.CreatorData.jsonDecode(v560)
		end

		v551.creator = t32
	end

	if t29.event ~= nil then
		local t33 = {}

		for v562, v563 in t29.event do
			t33[v562] = event_data.EventData.jsonDecode(v563)
		end

		v551.event = t33
	end

	if t29.song ~= nil then
		local t34 = {}

		for v565, v566 in t29.song do
			t34[v565] = song_data.SongData.jsonDecode(v566)
		end

		v551.song = t34
	end

	if t29.game_pass ~= nil then
		local t35 = {}

		for v568, v569 in t29.game_pass do
			t35[v568] = game_pass_data.GamePassData.jsonDecode(v569)
		end

		v551.game_pass = t35
	end

	if t29.gamePass ~= nil then
		local t36 = {}

		for v571, v572 in t29.gamePass do
			t36[v571] = game_pass_data.GamePassData.jsonDecode(v572)
		end

		v551.game_pass = t36
	end

	if t29.media_asset ~= nil then
		local t37 = {}

		for v574, v575 in t29.media_asset do
			t37[v574] = media_asset_data.MediaAssetData.jsonDecode(v575)
		end

		v551.media_asset = t37
	end

	if t29.mediaAsset ~= nil then
		local t38 = {}

		for v577, v578 in t29.mediaAsset do
			t38[v577] = media_asset_data.MediaAssetData.jsonDecode(v578)
		end

		v551.media_asset = t38
	end

	if t29.social_link ~= nil then
		local t39 = {}

		for v580, v581 in t29.social_link do
			t39[v580] = social_link_data.SocialLinkData.jsonDecode(v581)
		end

		v551.social_link = t39
	end

	if t29.socialLink ~= nil then
		local t40 = {}

		for v583, v584 in t29.socialLink do
			t40[v583] = social_link_data.SocialLinkData.jsonDecode(v584)
		end

		v551.social_link = t40
	end

	if t29.game_developer_product ~= nil then
		local t41 = {}

		for v586, v587 in t29.game_developer_product do
			t41[v586] = game_developer_product_data.GameDeveloperProductData.jsonDecode(v587)
		end

		v551.game_developer_product = t41
	end

	if t29.gameDeveloperProduct ~= nil then
		local t42 = {}

		for v589, v590 in t29.gameDeveloperProduct do
			t42[v589] = game_developer_product_data.GameDeveloperProductData.jsonDecode(v590)
		end

		v551.game_developer_product = t42
	end

	if t29.game_subscription ~= nil then
		local t43 = {}

		for v592, v593 in t29.game_subscription do
			t43[v592] = game_subscription_data.GameSubscriptionData.jsonDecode(v593)
		end

		v551.game_subscription = t43
	end

	if t29.gameSubscription ~= nil then
		local t44 = {}

		for v595, v596 in t29.gameSubscription do
			t44[v595] = game_subscription_data.GameSubscriptionData.jsonDecode(v596)
		end

		v551.game_subscription = t44
	end

	if t29.marketplace_catalog_category ~= nil then
		local t45 = {}

		for v598, v599 in t29.marketplace_catalog_category do
			t45[v598] = marketplace_catalog_category_data.MarketplaceCatalogCategoryData.jsonDecode(v599)
		end

		v551.marketplace_catalog_category = t45
	end

	if t29.marketplaceCatalogCategory ~= nil then
		local t46 = {}

		for v601, v602 in t29.marketplaceCatalogCategory do
			t46[v601] = marketplace_catalog_category_data.MarketplaceCatalogCategoryData.jsonDecode(v602)
		end

		v551.marketplace_catalog_category = t46
	end

	if t29.marketplace_asset ~= nil then
		local t47 = {}

		for v604, v605 in t29.marketplace_asset do
			t47[v604] = marketplace_asset_data.MarketplaceAssetData.jsonDecode(v605)
		end

		v551.marketplace_asset = t47
	end

	if t29.marketplaceAsset ~= nil then
		local t48 = {}

		for v607, v608 in t29.marketplaceAsset do
			t48[v607] = marketplace_asset_data.MarketplaceAssetData.jsonDecode(v608)
		end

		v551.marketplace_asset = t48
	end

	if t29.marketplace_bundle ~= nil then
		local t49 = {}

		for v610, v611 in t29.marketplace_bundle do
			t49[v610] = marketplace_bundle_data.MarketplaceBundleData.jsonDecode(v611)
		end

		v551.marketplace_bundle = t49
	end

	if t29.marketplaceBundle ~= nil then
		local t50 = {}

		for v613, v614 in t29.marketplaceBundle do
			t50[v613] = marketplace_bundle_data.MarketplaceBundleData.jsonDecode(v614)
		end

		v551.marketplace_bundle = t50
	end

	if t29.marketplace_look ~= nil then
		local t51 = {}

		for v616, v617 in t29.marketplace_look do
			t51[v616] = marketplace_look_data.MarketplaceLookData.jsonDecode(v617)
		end

		v551.marketplace_look = t51
	end

	if t29.marketplaceLook ~= nil then
		local t52 = {}

		for v619, v620 in t29.marketplaceLook do
			t52[v619] = marketplace_look_data.MarketplaceLookData.jsonDecode(v620)
		end

		v551.marketplace_look = t52
	end

	if t29.catalog_sort ~= nil then
		local t53 = {}

		for v622, v623 in t29.catalog_sort do
			t53[v622] = catalog_sort_data.CatalogSortData.jsonDecode(v623)
		end

		v551.catalog_sort = t53
	end

	if t29.catalogSort ~= nil then
		local t54 = {}

		for v625, v626 in t29.catalogSort do
			t54[v625] = catalog_sort_data.CatalogSortData.jsonDecode(v626)
		end

		v551.catalog_sort = t54
	end

	if t29.age_recommendation ~= nil then
		local t55 = {}

		for v628, v629 in t29.age_recommendation do
			t55[v628] = age_recommendation_data.AgeRecommendationData.jsonDecode(v629)
		end

		v551.age_recommendation = t55
	end

	if t29.ageRecommendation ~= nil then
		local t56 = {}

		for v631, v632 in t29.ageRecommendation do
			t56[v631] = age_recommendation_data.AgeRecommendationData.jsonDecode(v632)
		end

		v551.age_recommendation = t56
	end

	if t29.universe_user_follow ~= nil then
		local t57 = {}

		for v634, v635 in t29.universe_user_follow do
			t57[v634] = universe_user_follow_data.UniverseUserFollowData.jsonDecode(v635)
		end

		v551.universe_user_follow = t57
	end

	if t29.universeUserFollow ~= nil then
		local t58 = {}

		for v637, v638 in t29.universeUserFollow do
			t58[v637] = universe_user_follow_data.UniverseUserFollowData.jsonDecode(v638)
		end

		v551.universe_user_follow = t58
	end

	if t29.universe_user_vote ~= nil then
		local t59 = {}

		for v640, v641 in t29.universe_user_vote do
			t59[v640] = universe_user_vote_data.UniverseUserVoteData.jsonDecode(v641)
		end

		v551.universe_user_vote = t59
	end

	if t29.universeUserVote ~= nil then
		local t60 = {}

		for v643, v644 in t29.universeUserVote do
			t60[v643] = universe_user_vote_data.UniverseUserVoteData.jsonDecode(v644)
		end

		v551.universe_user_vote = t60
	end

	if t29.user_profile ~= nil then
		local t61 = {}

		for v646, v647 in t29.user_profile do
			t61[v646] = user_profile_data.UserProfileData.jsonDecode(v647)
		end

		v551.user_profile = t61
	end

	if t29.userProfile ~= nil then
		local t62 = {}

		for v649, v650 in t29.userProfile do
			t62[v649] = user_profile_data.UserProfileData.jsonDecode(v650)
		end

		v551.user_profile = t62
	end

	if t29.universe_user_favorite ~= nil then
		local t63 = {}

		for v652, v653 in t29.universe_user_favorite do
			t63[v652] = universe_user_favorite_data.UniverseUserFavoriteData.jsonDecode(v653)
		end

		v551.universe_user_favorite = t63
	end

	if t29.universeUserFavorite ~= nil then
		local t64 = {}

		for v655, v656 in t29.universeUserFavorite do
			t64[v655] = universe_user_favorite_data.UniverseUserFavoriteData.jsonDecode(v656)
		end

		v551.universe_user_favorite = t64
	end

	if t29.playability ~= nil then
		local t65 = {}

		for v658, v659 in t29.playability do
			t65[v658] = playability_data.PlayabilityData.jsonDecode(v659)
		end

		v551.playability = t65
	end

	if t29.universe_user_follow_limit ~= nil then
		local t66 = {}

		for v661, v662 in t29.universe_user_follow_limit do
			t66[v661] = universe_user_follow_limit_data.UniverseUserFollowLimitData.jsonDecode(v662)
		end

		v551.universe_user_follow_limit = t66
	end

	if t29.universeUserFollowLimit ~= nil then
		local t67 = {}

		for v664, v665 in t29.universeUserFollowLimit do
			t67[v664] = universe_user_follow_limit_data.UniverseUserFollowLimitData.jsonDecode(v665)
		end

		v551.universe_user_follow_limit = t67
	end

	if t29.universe_user_vote_feedback_metadata ~= nil then
		local t68 = {}

		for v667, v668 in t29.universe_user_vote_feedback_metadata do
			t68[v667] = universe_user_vote_feedback_metadata_data.UniverseUserVoteFeedbackMetadataData.jsonDecode(v668)
		end

		v551.universe_user_vote_feedback_metadata = t68
	end

	if t29.universeUserVoteFeedbackMetadata ~= nil then
		local t69 = {}

		for v670, v671 in t29.universeUserVoteFeedbackMetadata do
			t69[v670] = universe_user_vote_feedback_metadata_data.UniverseUserVoteFeedbackMetadataData.jsonDecode(v671)
		end

		v551.universe_user_vote_feedback_metadata = t69
	end

	if t29.moment ~= nil then
		local t70 = {}

		for v673, v674 in t29.moment do
			t70[v673] = moment_data.MomentData.jsonDecode(v674)
		end

		v551.moment = t70
	end

	return v551
end

t2.descriptor = {
	name = "HydrationContent",
	fullName = "roblox.apppageplatform.shared.v1beta1.HydrationContent"
}
t1.HydrationContent = t2
typeRegistry.default:register(t1.HydrationContent)

local t71 = {}

t71.__index = t71

function t71.new(t72: {[any]: any}?) -- line: 2318
	-- upvalues: t71 (copy)
	return (setmetatable({
		key = if t72 ~= nil and t72.key ~= nil then t72.key else "",
		value = if t72 ~= nil and t72.value ~= nil then t72.value else nil
	}, t71))
end
function t71.encode(p4) -- line: 2327
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n3 = 0

	if p4.key ~= nil and p4.key ~= "" then
		local v679, v680 = proto.writeTag(buf, n3, 1, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeString(v679, v680, p4.key)
	end

	if p4.value ~= nil then
		local v681 = p4.value:encode()
		local v682, v683 = proto.writeTag(buf, n3, 2, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeBuffer(v682, v683, v681, buffer.len(v681))
	end

	local buf27 = buffer.create(n3)

	buffer.copy(buf27, 0, buf, 0, n3)

	return buf27
end
function t71.decode(p5: buffer) -- line: 2347
	-- upvalues: t71 (copy), proto (copy), badge_data (copy)
	local v686 = t71.new()
	local n4 = 0

	while n4 < buffer.len(p5) do
		local v688, v689

		v688, v689, n4 = proto.readTag(p5, n4)

		if v689 == proto.wireTypes.varint then
			local v690

			v690, n4 = proto.readVarInt(p5, n4)
		elseif v689 == proto.wireTypes.lengthDelimited then
			if v688 == 1 then
				local v691

				v691, n4 = proto.readBuffer(p5, n4)
				v686.key = buffer.tostring(v691)
			elseif v688 == 2 then
				local v692

				v692, n4 = proto.readBuffer(p5, n4)
				v686.value = badge_data.BadgeData.decode(v692)
			else
				local v693, v694 = proto.readVarInt(p5, n4)

				n4 = v694 + v693
			end
		elseif v689 == proto.wireTypes.i32 then
			local v695

			v695, n4 = proto.readFixed32(p5, n4)
		elseif v689 == proto.wireTypes.i64 then
			local v696

			v696, n4 = proto.readFixed64(p5, n4)
		else
			error("Unsupported wire type: " .. v689)
		end
	end

	return v686
end
function t71.jsonEncode(p6) -- line: 2395
	local t73 = {}

	if p6.key ~= nil and p6.key ~= "" then
		t73.key = p6.key
	end

	if p6.value ~= nil then
		t73.value = p6.value:jsonEncode()
	end

	return t73
end
function t71.jsonDecode(t74: {[any]: any}) -- line: 2409
	-- upvalues: t71 (copy), badge_data (copy)
	local v700 = t71.new()

	if t74.key ~= nil then
		v700.key = t74.key
	end

	if t74.value ~= nil then
		v700.value = badge_data.BadgeData.jsonDecode(t74.value)
	end

	return v700
end

t71.descriptor = {
	name = "HydrationContent_BadgeEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.BadgeEntry"
}
t1.HydrationContent_BadgeEntry = t71
typeRegistry.default:register(t1.HydrationContent_BadgeEntry)

local t75 = {}

t75.__index = t75

function t75.new(t76: {[any]: any}?) -- line: 2437
	-- upvalues: t75 (copy)
	return (setmetatable({
		key = if t76 ~= nil and t76.key ~= nil then t76.key else "",
		value = if t76 ~= nil and t76.value ~= nil then t76.value else nil
	}, t75))
end
function t75.encode(p7) -- line: 2446
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n5 = 0

	if p7.key ~= nil and p7.key ~= "" then
		local v705, v706 = proto.writeTag(buf, n5, 1, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeString(v705, v706, p7.key)
	end

	if p7.value ~= nil then
		local v707 = p7.value:encode()
		local v708, v709 = proto.writeTag(buf, n5, 2, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeBuffer(v708, v709, v707, buffer.len(v707))
	end

	local buf28 = buffer.create(n5)

	buffer.copy(buf28, 0, buf, 0, n5)

	return buf28
end
function t75.decode(p8: buffer) -- line: 2466
	-- upvalues: t75 (copy), proto (copy), universe_data (copy)
	local v712 = t75.new()
	local n6 = 0

	while n6 < buffer.len(p8) do
		local v714, v715

		v714, v715, n6 = proto.readTag(p8, n6)

		if v715 == proto.wireTypes.varint then
			local v716

			v716, n6 = proto.readVarInt(p8, n6)
		elseif v715 == proto.wireTypes.lengthDelimited then
			if v714 == 1 then
				local v717

				v717, n6 = proto.readBuffer(p8, n6)
				v712.key = buffer.tostring(v717)
			elseif v714 == 2 then
				local v718

				v718, n6 = proto.readBuffer(p8, n6)
				v712.value = universe_data.UniverseData.decode(v718)
			else
				local v719, v720 = proto.readVarInt(p8, n6)

				n6 = v720 + v719
			end
		elseif v715 == proto.wireTypes.i32 then
			local v721

			v721, n6 = proto.readFixed32(p8, n6)
		elseif v715 == proto.wireTypes.i64 then
			local v722

			v722, n6 = proto.readFixed64(p8, n6)
		else
			error("Unsupported wire type: " .. v715)
		end
	end

	return v712
end
function t75.jsonEncode(p9) -- line: 2514
	local t77 = {}

	if p9.key ~= nil and p9.key ~= "" then
		t77.key = p9.key
	end

	if p9.value ~= nil then
		t77.value = p9.value:jsonEncode()
	end

	return t77
end
function t75.jsonDecode(t78: {[any]: any}) -- line: 2528
	-- upvalues: t75 (copy), universe_data (copy)
	local v726 = t75.new()

	if t78.key ~= nil then
		v726.key = t78.key
	end

	if t78.value ~= nil then
		v726.value = universe_data.UniverseData.jsonDecode(t78.value)
	end

	return v726
end

t75.descriptor = {
	name = "HydrationContent_UniverseEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniverseEntry"
}
t1.HydrationContent_UniverseEntry = t75
typeRegistry.default:register(t1.HydrationContent_UniverseEntry)

local t79 = {}

t79.__index = t79

function t79.new(t80: {[any]: any}?) -- line: 2556
	-- upvalues: t79 (copy)
	return (setmetatable({
		key = if t80 ~= nil and t80.key ~= nil then t80.key else "",
		value = if t80 ~= nil and t80.value ~= nil then t80.value else nil
	}, t79))
end
function t79.encode(p10) -- line: 2565
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n7 = 0

	if p10.key ~= nil and p10.key ~= "" then
		local v731, v732 = proto.writeTag(buf, n7, 1, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeString(v731, v732, p10.key)
	end

	if p10.value ~= nil then
		local v733 = p10.value:encode()
		local v734, v735 = proto.writeTag(buf, n7, 2, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeBuffer(v734, v735, v733, buffer.len(v733))
	end

	local buf29 = buffer.create(n7)

	buffer.copy(buf29, 0, buf, 0, n7)

	return buf29
end
function t79.decode(p11: buffer) -- line: 2585
	-- upvalues: t79 (copy), proto (copy), creator_data (copy)
	local v738 = t79.new()
	local n8 = 0

	while n8 < buffer.len(p11) do
		local v740, v741

		v740, v741, n8 = proto.readTag(p11, n8)

		if v741 == proto.wireTypes.varint then
			local v742

			v742, n8 = proto.readVarInt(p11, n8)
		elseif v741 == proto.wireTypes.lengthDelimited then
			if v740 == 1 then
				local v743

				v743, n8 = proto.readBuffer(p11, n8)
				v738.key = buffer.tostring(v743)
			elseif v740 == 2 then
				local v744

				v744, n8 = proto.readBuffer(p11, n8)
				v738.value = creator_data.CreatorData.decode(v744)
			else
				local v745, v746 = proto.readVarInt(p11, n8)

				n8 = v746 + v745
			end
		elseif v741 == proto.wireTypes.i32 then
			local v747

			v747, n8 = proto.readFixed32(p11, n8)
		elseif v741 == proto.wireTypes.i64 then
			local v748

			v748, n8 = proto.readFixed64(p11, n8)
		else
			error("Unsupported wire type: " .. v741)
		end
	end

	return v738
end
function t79.jsonEncode(p12) -- line: 2633
	local t81 = {}

	if p12.key ~= nil and p12.key ~= "" then
		t81.key = p12.key
	end

	if p12.value ~= nil then
		t81.value = p12.value:jsonEncode()
	end

	return t81
end
function t79.jsonDecode(t82: {[any]: any}) -- line: 2647
	-- upvalues: t79 (copy), creator_data (copy)
	local v752 = t79.new()

	if t82.key ~= nil then
		v752.key = t82.key
	end

	if t82.value ~= nil then
		v752.value = creator_data.CreatorData.jsonDecode(t82.value)
	end

	return v752
end

t79.descriptor = {
	name = "HydrationContent_CreatorEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.CreatorEntry"
}
t1.HydrationContent_CreatorEntry = t79
typeRegistry.default:register(t1.HydrationContent_CreatorEntry)

local t83 = {}

t83.__index = t83

function t83.new(t84: {[any]: any}?) -- line: 2675
	-- upvalues: t83 (copy)
	return (setmetatable({
		key = if t84 ~= nil and t84.key ~= nil then t84.key else "",
		value = if t84 ~= nil and t84.value ~= nil then t84.value else nil
	}, t83))
end
function t83.encode(p13) -- line: 2684
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n9 = 0

	if p13.key ~= nil and p13.key ~= "" then
		local v757, v758 = proto.writeTag(buf, n9, 1, proto.wireTypes.lengthDelimited)

		buf, n9 = proto.writeString(v757, v758, p13.key)
	end

	if p13.value ~= nil then
		local v759 = p13.value:encode()
		local v760, v761 = proto.writeTag(buf, n9, 2, proto.wireTypes.lengthDelimited)

		buf, n9 = proto.writeBuffer(v760, v761, v759, buffer.len(v759))
	end

	local buf30 = buffer.create(n9)

	buffer.copy(buf30, 0, buf, 0, n9)

	return buf30
end
function t83.decode(p14: buffer) -- line: 2704
	-- upvalues: t83 (copy), proto (copy), event_data (copy)
	local v764 = t83.new()
	local n10 = 0

	while n10 < buffer.len(p14) do
		local v766, v767

		v766, v767, n10 = proto.readTag(p14, n10)

		if v767 == proto.wireTypes.varint then
			local v768

			v768, n10 = proto.readVarInt(p14, n10)
		elseif v767 == proto.wireTypes.lengthDelimited then
			if v766 == 1 then
				local v769

				v769, n10 = proto.readBuffer(p14, n10)
				v764.key = buffer.tostring(v769)
			elseif v766 == 2 then
				local v770

				v770, n10 = proto.readBuffer(p14, n10)
				v764.value = event_data.EventData.decode(v770)
			else
				local v771, v772 = proto.readVarInt(p14, n10)

				n10 = v772 + v771
			end
		elseif v767 == proto.wireTypes.i32 then
			local v773

			v773, n10 = proto.readFixed32(p14, n10)
		elseif v767 == proto.wireTypes.i64 then
			local v774

			v774, n10 = proto.readFixed64(p14, n10)
		else
			error("Unsupported wire type: " .. v767)
		end
	end

	return v764
end
function t83.jsonEncode(p15) -- line: 2752
	local t85 = {}

	if p15.key ~= nil and p15.key ~= "" then
		t85.key = p15.key
	end

	if p15.value ~= nil then
		t85.value = p15.value:jsonEncode()
	end

	return t85
end
function t83.jsonDecode(t86: {[any]: any}) -- line: 2766
	-- upvalues: t83 (copy), event_data (copy)
	local v778 = t83.new()

	if t86.key ~= nil then
		v778.key = t86.key
	end

	if t86.value ~= nil then
		v778.value = event_data.EventData.jsonDecode(t86.value)
	end

	return v778
end

t83.descriptor = {
	name = "HydrationContent_EventEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventEntry"
}
t1.HydrationContent_EventEntry = t83
typeRegistry.default:register(t1.HydrationContent_EventEntry)

local t87 = {}

t87.__index = t87

function t87.new(t88: {[any]: any}?) -- line: 2794
	-- upvalues: t87 (copy)
	return (setmetatable({
		key = if t88 ~= nil and t88.key ~= nil then t88.key else "",
		value = if t88 ~= nil and t88.value ~= nil then t88.value else nil
	}, t87))
end
function t87.encode(p16) -- line: 2803
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n11 = 0

	if p16.key ~= nil and p16.key ~= "" then
		local v783, v784 = proto.writeTag(buf, n11, 1, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeString(v783, v784, p16.key)
	end

	if p16.value ~= nil then
		local v785 = p16.value:encode()
		local v786, v787 = proto.writeTag(buf, n11, 2, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeBuffer(v786, v787, v785, buffer.len(v785))
	end

	local buf31 = buffer.create(n11)

	buffer.copy(buf31, 0, buf, 0, n11)

	return buf31
end
function t87.decode(p17: buffer) -- line: 2823
	-- upvalues: t87 (copy), proto (copy), song_data (copy)
	local v790 = t87.new()
	local n12 = 0

	while n12 < buffer.len(p17) do
		local v792, v793

		v792, v793, n12 = proto.readTag(p17, n12)

		if v793 == proto.wireTypes.varint then
			local v794

			v794, n12 = proto.readVarInt(p17, n12)
		elseif v793 == proto.wireTypes.lengthDelimited then
			if v792 == 1 then
				local v795

				v795, n12 = proto.readBuffer(p17, n12)
				v790.key = buffer.tostring(v795)
			elseif v792 == 2 then
				local v796

				v796, n12 = proto.readBuffer(p17, n12)
				v790.value = song_data.SongData.decode(v796)
			else
				local v797, v798 = proto.readVarInt(p17, n12)

				n12 = v798 + v797
			end
		elseif v793 == proto.wireTypes.i32 then
			local v799

			v799, n12 = proto.readFixed32(p17, n12)
		elseif v793 == proto.wireTypes.i64 then
			local v800

			v800, n12 = proto.readFixed64(p17, n12)
		else
			error("Unsupported wire type: " .. v793)
		end
	end

	return v790
end
function t87.jsonEncode(p18) -- line: 2871
	local t89 = {}

	if p18.key ~= nil and p18.key ~= "" then
		t89.key = p18.key
	end

	if p18.value ~= nil then
		t89.value = p18.value:jsonEncode()
	end

	return t89
end
function t87.jsonDecode(t90: {[any]: any}) -- line: 2885
	-- upvalues: t87 (copy), song_data (copy)
	local v804 = t87.new()

	if t90.key ~= nil then
		v804.key = t90.key
	end

	if t90.value ~= nil then
		v804.value = song_data.SongData.jsonDecode(t90.value)
	end

	return v804
end

t87.descriptor = {
	name = "HydrationContent_SongEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.SongEntry"
}
t1.HydrationContent_SongEntry = t87
typeRegistry.default:register(t1.HydrationContent_SongEntry)

local t91 = {}

t91.__index = t91

function t91.new(t92: {[any]: any}?) -- line: 2913
	-- upvalues: t91 (copy)
	return (setmetatable({
		key = if t92 ~= nil and t92.key ~= nil then t92.key else "",
		value = if t92 ~= nil and t92.value ~= nil then t92.value else nil
	}, t91))
end
function t91.encode(p19) -- line: 2922
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n13 = 0

	if p19.key ~= nil and p19.key ~= "" then
		local v809, v810 = proto.writeTag(buf, n13, 1, proto.wireTypes.lengthDelimited)

		buf, n13 = proto.writeString(v809, v810, p19.key)
	end

	if p19.value ~= nil then
		local v811 = p19.value:encode()
		local v812, v813 = proto.writeTag(buf, n13, 2, proto.wireTypes.lengthDelimited)

		buf, n13 = proto.writeBuffer(v812, v813, v811, buffer.len(v811))
	end

	local buf32 = buffer.create(n13)

	buffer.copy(buf32, 0, buf, 0, n13)

	return buf32
end
function t91.decode(p20: buffer) -- line: 2942
	-- upvalues: t91 (copy), proto (copy), game_pass_data (copy)
	local v816 = t91.new()
	local n14 = 0

	while n14 < buffer.len(p20) do
		local v818, v819

		v818, v819, n14 = proto.readTag(p20, n14)

		if v819 == proto.wireTypes.varint then
			local v820

			v820, n14 = proto.readVarInt(p20, n14)
		elseif v819 == proto.wireTypes.lengthDelimited then
			if v818 == 1 then
				local v821

				v821, n14 = proto.readBuffer(p20, n14)
				v816.key = buffer.tostring(v821)
			elseif v818 == 2 then
				local v822

				v822, n14 = proto.readBuffer(p20, n14)
				v816.value = game_pass_data.GamePassData.decode(v822)
			else
				local v823, v824 = proto.readVarInt(p20, n14)

				n14 = v824 + v823
			end
		elseif v819 == proto.wireTypes.i32 then
			local v825

			v825, n14 = proto.readFixed32(p20, n14)
		elseif v819 == proto.wireTypes.i64 then
			local v826

			v826, n14 = proto.readFixed64(p20, n14)
		else
			error("Unsupported wire type: " .. v819)
		end
	end

	return v816
end
function t91.jsonEncode(p21) -- line: 2990
	local t93 = {}

	if p21.key ~= nil and p21.key ~= "" then
		t93.key = p21.key
	end

	if p21.value ~= nil then
		t93.value = p21.value:jsonEncode()
	end

	return t93
end
function t91.jsonDecode(t94: {[any]: any}) -- line: 3004
	-- upvalues: t91 (copy), game_pass_data (copy)
	local v830 = t91.new()

	if t94.key ~= nil then
		v830.key = t94.key
	end

	if t94.value ~= nil then
		v830.value = game_pass_data.GamePassData.jsonDecode(t94.value)
	end

	return v830
end

t91.descriptor = {
	name = "HydrationContent_GamePassEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.GamePassEntry"
}
t1.HydrationContent_GamePassEntry = t91
typeRegistry.default:register(t1.HydrationContent_GamePassEntry)

local t95 = {}

t95.__index = t95

function t95.new(t96: {[any]: any}?) -- line: 3032
	-- upvalues: t95 (copy)
	return (setmetatable({
		key = if t96 ~= nil and t96.key ~= nil then t96.key else "",
		value = if t96 ~= nil and t96.value ~= nil then t96.value else nil
	}, t95))
end
function t95.encode(p22) -- line: 3041
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n15 = 0

	if p22.key ~= nil and p22.key ~= "" then
		local v835, v836 = proto.writeTag(buf, n15, 1, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeString(v835, v836, p22.key)
	end

	if p22.value ~= nil then
		local v837 = p22.value:encode()
		local v838, v839 = proto.writeTag(buf, n15, 2, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeBuffer(v838, v839, v837, buffer.len(v837))
	end

	local buf33 = buffer.create(n15)

	buffer.copy(buf33, 0, buf, 0, n15)

	return buf33
end
function t95.decode(p23: buffer) -- line: 3061
	-- upvalues: t95 (copy), proto (copy), media_asset_data (copy)
	local v842 = t95.new()
	local n16 = 0

	while n16 < buffer.len(p23) do
		local v844, v845

		v844, v845, n16 = proto.readTag(p23, n16)

		if v845 == proto.wireTypes.varint then
			local v846

			v846, n16 = proto.readVarInt(p23, n16)
		elseif v845 == proto.wireTypes.lengthDelimited then
			if v844 == 1 then
				local v847

				v847, n16 = proto.readBuffer(p23, n16)
				v842.key = buffer.tostring(v847)
			elseif v844 == 2 then
				local v848

				v848, n16 = proto.readBuffer(p23, n16)
				v842.value = media_asset_data.MediaAssetData.decode(v848)
			else
				local v849, v850 = proto.readVarInt(p23, n16)

				n16 = v850 + v849
			end
		elseif v845 == proto.wireTypes.i32 then
			local v851

			v851, n16 = proto.readFixed32(p23, n16)
		elseif v845 == proto.wireTypes.i64 then
			local v852

			v852, n16 = proto.readFixed64(p23, n16)
		else
			error("Unsupported wire type: " .. v845)
		end
	end

	return v842
end
function t95.jsonEncode(p24) -- line: 3109
	local t97 = {}

	if p24.key ~= nil and p24.key ~= "" then
		t97.key = p24.key
	end

	if p24.value ~= nil then
		t97.value = p24.value:jsonEncode()
	end

	return t97
end
function t95.jsonDecode(t98: {[any]: any}) -- line: 3123
	-- upvalues: t95 (copy), media_asset_data (copy)
	local v856 = t95.new()

	if t98.key ~= nil then
		v856.key = t98.key
	end

	if t98.value ~= nil then
		v856.value = media_asset_data.MediaAssetData.jsonDecode(t98.value)
	end

	return v856
end

t95.descriptor = {
	name = "HydrationContent_MediaAssetEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.MediaAssetEntry"
}
t1.HydrationContent_MediaAssetEntry = t95
typeRegistry.default:register(t1.HydrationContent_MediaAssetEntry)

local t99 = {}

t99.__index = t99

function t99.new(t100: {[any]: any}?) -- line: 3153
	-- upvalues: t99 (copy)
	return (setmetatable({
		key = if t100 ~= nil and t100.key ~= nil then t100.key else "",
		value = if t100 ~= nil and t100.value ~= nil then t100.value else nil
	}, t99))
end
function t99.encode(p25) -- line: 3162
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n17 = 0

	if p25.key ~= nil and p25.key ~= "" then
		local v861, v862 = proto.writeTag(buf, n17, 1, proto.wireTypes.lengthDelimited)

		buf, n17 = proto.writeString(v861, v862, p25.key)
	end

	if p25.value ~= nil then
		local v863 = p25.value:encode()
		local v864, v865 = proto.writeTag(buf, n17, 2, proto.wireTypes.lengthDelimited)

		buf, n17 = proto.writeBuffer(v864, v865, v863, buffer.len(v863))
	end

	local buf34 = buffer.create(n17)

	buffer.copy(buf34, 0, buf, 0, n17)

	return buf34
end
function t99.decode(p26: buffer) -- line: 3182
	-- upvalues: t99 (copy), proto (copy), social_link_data (copy)
	local v868 = t99.new()
	local n18 = 0

	while n18 < buffer.len(p26) do
		local v870, v871

		v870, v871, n18 = proto.readTag(p26, n18)

		if v871 == proto.wireTypes.varint then
			local v872

			v872, n18 = proto.readVarInt(p26, n18)
		elseif v871 == proto.wireTypes.lengthDelimited then
			if v870 == 1 then
				local v873

				v873, n18 = proto.readBuffer(p26, n18)
				v868.key = buffer.tostring(v873)
			elseif v870 == 2 then
				local v874

				v874, n18 = proto.readBuffer(p26, n18)
				v868.value = social_link_data.SocialLinkData.decode(v874)
			else
				local v875, v876 = proto.readVarInt(p26, n18)

				n18 = v876 + v875
			end
		elseif v871 == proto.wireTypes.i32 then
			local v877

			v877, n18 = proto.readFixed32(p26, n18)
		elseif v871 == proto.wireTypes.i64 then
			local v878

			v878, n18 = proto.readFixed64(p26, n18)
		else
			error("Unsupported wire type: " .. v871)
		end
	end

	return v868
end
function t99.jsonEncode(p27) -- line: 3230
	local t101 = {}

	if p27.key ~= nil and p27.key ~= "" then
		t101.key = p27.key
	end

	if p27.value ~= nil then
		t101.value = p27.value:jsonEncode()
	end

	return t101
end
function t99.jsonDecode(t102: {[any]: any}) -- line: 3244
	-- upvalues: t99 (copy), social_link_data (copy)
	local v882 = t99.new()

	if t102.key ~= nil then
		v882.key = t102.key
	end

	if t102.value ~= nil then
		v882.value = social_link_data.SocialLinkData.jsonDecode(t102.value)
	end

	return v882
end

t99.descriptor = {
	name = "HydrationContent_SocialLinkEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.SocialLinkEntry"
}
t1.HydrationContent_SocialLinkEntry = t99
typeRegistry.default:register(t1.HydrationContent_SocialLinkEntry)

local t103 = {}

t103.__index = t103

function t103.new(t104: {[any]: any}?) -- line: 3274
	-- upvalues: t103 (copy)
	return (setmetatable({
		key = if t104 ~= nil and t104.key ~= nil then t104.key else "",
		value = if t104 ~= nil and t104.value ~= nil then t104.value else nil
	}, t103))
end
function t103.encode(p28) -- line: 3283
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n19 = 0

	if p28.key ~= nil and p28.key ~= "" then
		local v887, v888 = proto.writeTag(buf, n19, 1, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeString(v887, v888, p28.key)
	end

	if p28.value ~= nil then
		local v889 = p28.value:encode()
		local v890, v891 = proto.writeTag(buf, n19, 2, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeBuffer(v890, v891, v889, buffer.len(v889))
	end

	local buf35 = buffer.create(n19)

	buffer.copy(buf35, 0, buf, 0, n19)

	return buf35
end
function t103.decode(p29: buffer) -- line: 3305
	-- upvalues: t103 (copy), proto (copy), game_developer_product_data (copy)
	local v894 = t103.new()
	local n20 = 0

	while n20 < buffer.len(p29) do
		local v896, v897

		v896, v897, n20 = proto.readTag(p29, n20)

		if v897 == proto.wireTypes.varint then
			local v898

			v898, n20 = proto.readVarInt(p29, n20)
		elseif v897 == proto.wireTypes.lengthDelimited then
			if v896 == 1 then
				local v899

				v899, n20 = proto.readBuffer(p29, n20)
				v894.key = buffer.tostring(v899)
			elseif v896 == 2 then
				local v900

				v900, n20 = proto.readBuffer(p29, n20)
				v894.value = game_developer_product_data.GameDeveloperProductData.decode(v900)
			else
				local v901, v902 = proto.readVarInt(p29, n20)

				n20 = v902 + v901
			end
		elseif v897 == proto.wireTypes.i32 then
			local v903

			v903, n20 = proto.readFixed32(p29, n20)
		elseif v897 == proto.wireTypes.i64 then
			local v904

			v904, n20 = proto.readFixed64(p29, n20)
		else
			error("Unsupported wire type: " .. v897)
		end
	end

	return v894
end
function t103.jsonEncode(p30) -- line: 3358
	local t105 = {}

	if p30.key ~= nil and p30.key ~= "" then
		t105.key = p30.key
	end

	if p30.value ~= nil then
		t105.value = p30.value:jsonEncode()
	end

	return t105
end
function t103.jsonDecode(t106: {[any]: any}) -- line: 3374
	-- upvalues: t103 (copy), game_developer_product_data (copy)
	local v908 = t103.new()

	if t106.key ~= nil then
		v908.key = t106.key
	end

	if t106.value ~= nil then
		v908.value = game_developer_product_data.GameDeveloperProductData.jsonDecode(t106.value)
	end

	return v908
end

t103.descriptor = {
	name = "HydrationContent_GameDeveloperProductEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.GameDeveloperProductEntry"
}
t1.HydrationContent_GameDeveloperProductEntry = t103
typeRegistry.default:register(t1.HydrationContent_GameDeveloperProductEntry)

local t107 = {}

t107.__index = t107

function t107.new(t108: {[any]: any}?) -- line: 3407
	-- upvalues: t107 (copy)
	return (setmetatable({
		key = if t108 ~= nil and t108.key ~= nil then t108.key else "",
		value = if t108 ~= nil and t108.value ~= nil then t108.value else nil
	}, t107))
end
function t107.encode(p31) -- line: 3416
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n21 = 0

	if p31.key ~= nil and p31.key ~= "" then
		local v913, v914 = proto.writeTag(buf, n21, 1, proto.wireTypes.lengthDelimited)

		buf, n21 = proto.writeString(v913, v914, p31.key)
	end

	if p31.value ~= nil then
		local v915 = p31.value:encode()
		local v916, v917 = proto.writeTag(buf, n21, 2, proto.wireTypes.lengthDelimited)

		buf, n21 = proto.writeBuffer(v916, v917, v915, buffer.len(v915))
	end

	local buf36 = buffer.create(n21)

	buffer.copy(buf36, 0, buf, 0, n21)

	return buf36
end
function t107.decode(p32: buffer) -- line: 3436
	-- upvalues: t107 (copy), proto (copy), game_subscription_data (copy)
	local v920 = t107.new()
	local n22 = 0

	while n22 < buffer.len(p32) do
		local v922, v923

		v922, v923, n22 = proto.readTag(p32, n22)

		if v923 == proto.wireTypes.varint then
			local v924

			v924, n22 = proto.readVarInt(p32, n22)
		elseif v923 == proto.wireTypes.lengthDelimited then
			if v922 == 1 then
				local v925

				v925, n22 = proto.readBuffer(p32, n22)
				v920.key = buffer.tostring(v925)
			elseif v922 == 2 then
				local v926

				v926, n22 = proto.readBuffer(p32, n22)
				v920.value = game_subscription_data.GameSubscriptionData.decode(v926)
			else
				local v927, v928 = proto.readVarInt(p32, n22)

				n22 = v928 + v927
			end
		elseif v923 == proto.wireTypes.i32 then
			local v929

			v929, n22 = proto.readFixed32(p32, n22)
		elseif v923 == proto.wireTypes.i64 then
			local v930

			v930, n22 = proto.readFixed64(p32, n22)
		else
			error("Unsupported wire type: " .. v923)
		end
	end

	return v920
end
function t107.jsonEncode(p33) -- line: 3485
	local t109 = {}

	if p33.key ~= nil and p33.key ~= "" then
		t109.key = p33.key
	end

	if p33.value ~= nil then
		t109.value = p33.value:jsonEncode()
	end

	return t109
end
function t107.jsonDecode(t110: {[any]: any}) -- line: 3499
	-- upvalues: t107 (copy), game_subscription_data (copy)
	local v934 = t107.new()

	if t110.key ~= nil then
		v934.key = t110.key
	end

	if t110.value ~= nil then
		v934.value = game_subscription_data.GameSubscriptionData.jsonDecode(t110.value)
	end

	return v934
end

t107.descriptor = {
	name = "HydrationContent_GameSubscriptionEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.GameSubscriptionEntry"
}
t1.HydrationContent_GameSubscriptionEntry = t107
typeRegistry.default:register(t1.HydrationContent_GameSubscriptionEntry)

local t111 = {}

t111.__index = t111

function t111.new(t112: {[any]: any}?) -- line: 3532
	-- upvalues: t111 (copy)
	return (setmetatable({
		key = if t112 ~= nil and t112.key ~= nil then t112.key else "",
		value = if t112 ~= nil and t112.value ~= nil then t112.value else nil
	}, t111))
end
function t111.encode(p34) -- line: 3544
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n23 = 0

	if p34.key ~= nil and p34.key ~= "" then
		local v939, v940 = proto.writeTag(buf, n23, 1, proto.wireTypes.lengthDelimited)

		buf, n23 = proto.writeString(v939, v940, p34.key)
	end

	if p34.value ~= nil then
		local v941 = p34.value:encode()
		local v942, v943 = proto.writeTag(buf, n23, 2, proto.wireTypes.lengthDelimited)

		buf, n23 = proto.writeBuffer(v942, v943, v941, buffer.len(v941))
	end

	local buf37 = buffer.create(n23)

	buffer.copy(buf37, 0, buf, 0, n23)

	return buf37
end
function t111.decode(p35: buffer) -- line: 3566
	-- upvalues: t111 (copy), proto (copy), marketplace_catalog_category_data (copy)
	local v946 = t111.new()
	local n24 = 0

	while n24 < buffer.len(p35) do
		local v948, v949

		v948, v949, n24 = proto.readTag(p35, n24)

		if v949 == proto.wireTypes.varint then
			local v950

			v950, n24 = proto.readVarInt(p35, n24)
		elseif v949 == proto.wireTypes.lengthDelimited then
			if v948 == 1 then
				local v951

				v951, n24 = proto.readBuffer(p35, n24)
				v946.key = buffer.tostring(v951)
			elseif v948 == 2 then
				local v952

				v952, n24 = proto.readBuffer(p35, n24)
				v946.value = marketplace_catalog_category_data.MarketplaceCatalogCategoryData.decode(v952)
			else
				local v953, v954 = proto.readVarInt(p35, n24)

				n24 = v954 + v953
			end
		elseif v949 == proto.wireTypes.i32 then
			local v955

			v955, n24 = proto.readFixed32(p35, n24)
		elseif v949 == proto.wireTypes.i64 then
			local v956

			v956, n24 = proto.readFixed64(p35, n24)
		else
			error("Unsupported wire type: " .. v949)
		end
	end

	return v946
end
function t111.jsonEncode(p36) -- line: 3619
	local t113 = {}

	if p36.key ~= nil and p36.key ~= "" then
		t113.key = p36.key
	end

	if p36.value ~= nil then
		t113.value = p36.value:jsonEncode()
	end

	return t113
end
function t111.jsonDecode(t114: {[any]: any}) -- line: 3635
	-- upvalues: t111 (copy), marketplace_catalog_category_data (copy)
	local v960 = t111.new()

	if t114.key ~= nil then
		v960.key = t114.key
	end

	if t114.value ~= nil then
		v960.value = marketplace_catalog_category_data.MarketplaceCatalogCategoryData.jsonDecode(t114.value)
	end

	return v960
end

t111.descriptor = {
	name = "HydrationContent_MarketplaceCatalogCategoryEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.MarketplaceCatalogCategoryEntry"
}
t1.HydrationContent_MarketplaceCatalogCategoryEntry = t111
typeRegistry.default:register(t1.HydrationContent_MarketplaceCatalogCategoryEntry)

local t115 = {}

t115.__index = t115

function t115.new(t116: {[any]: any}?) -- line: 3669
	-- upvalues: t115 (copy)
	return (setmetatable({
		key = if t116 ~= nil and t116.key ~= nil then t116.key else "",
		value = if t116 ~= nil and t116.value ~= nil then t116.value else nil
	}, t115))
end
function t115.encode(p37) -- line: 3678
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n25 = 0

	if p37.key ~= nil and p37.key ~= "" then
		local v965, v966 = proto.writeTag(buf, n25, 1, proto.wireTypes.lengthDelimited)

		buf, n25 = proto.writeString(v965, v966, p37.key)
	end

	if p37.value ~= nil then
		local v967 = p37.value:encode()
		local v968, v969 = proto.writeTag(buf, n25, 2, proto.wireTypes.lengthDelimited)

		buf, n25 = proto.writeBuffer(v968, v969, v967, buffer.len(v967))
	end

	local buf38 = buffer.create(n25)

	buffer.copy(buf38, 0, buf, 0, n25)

	return buf38
end
function t115.decode(p38: buffer) -- line: 3698
	-- upvalues: t115 (copy), proto (copy), marketplace_asset_data (copy)
	local v972 = t115.new()
	local n26 = 0

	while n26 < buffer.len(p38) do
		local v974, v975

		v974, v975, n26 = proto.readTag(p38, n26)

		if v975 == proto.wireTypes.varint then
			local v976

			v976, n26 = proto.readVarInt(p38, n26)
		elseif v975 == proto.wireTypes.lengthDelimited then
			if v974 == 1 then
				local v977

				v977, n26 = proto.readBuffer(p38, n26)
				v972.key = buffer.tostring(v977)
			elseif v974 == 2 then
				local v978

				v978, n26 = proto.readBuffer(p38, n26)
				v972.value = marketplace_asset_data.MarketplaceAssetData.decode(v978)
			else
				local v979, v980 = proto.readVarInt(p38, n26)

				n26 = v980 + v979
			end
		elseif v975 == proto.wireTypes.i32 then
			local v981

			v981, n26 = proto.readFixed32(p38, n26)
		elseif v975 == proto.wireTypes.i64 then
			local v982

			v982, n26 = proto.readFixed64(p38, n26)
		else
			error("Unsupported wire type: " .. v975)
		end
	end

	return v972
end
function t115.jsonEncode(p39) -- line: 3747
	local t117 = {}

	if p39.key ~= nil and p39.key ~= "" then
		t117.key = p39.key
	end

	if p39.value ~= nil then
		t117.value = p39.value:jsonEncode()
	end

	return t117
end
function t115.jsonDecode(t118: {[any]: any}) -- line: 3761
	-- upvalues: t115 (copy), marketplace_asset_data (copy)
	local v986 = t115.new()

	if t118.key ~= nil then
		v986.key = t118.key
	end

	if t118.value ~= nil then
		v986.value = marketplace_asset_data.MarketplaceAssetData.jsonDecode(t118.value)
	end

	return v986
end

t115.descriptor = {
	name = "HydrationContent_MarketplaceAssetEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.MarketplaceAssetEntry"
}
t1.HydrationContent_MarketplaceAssetEntry = t115
typeRegistry.default:register(t1.HydrationContent_MarketplaceAssetEntry)

local t119 = {}

t119.__index = t119

function t119.new(t120: {[any]: any}?) -- line: 3793
	-- upvalues: t119 (copy)
	return (setmetatable({
		key = if t120 ~= nil and t120.key ~= nil then t120.key else "",
		value = if t120 ~= nil and t120.value ~= nil then t120.value else nil
	}, t119))
end
function t119.encode(p40) -- line: 3802
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n27 = 0

	if p40.key ~= nil and p40.key ~= "" then
		local v991, v992 = proto.writeTag(buf, n27, 1, proto.wireTypes.lengthDelimited)

		buf, n27 = proto.writeString(v991, v992, p40.key)
	end

	if p40.value ~= nil then
		local v993 = p40.value:encode()
		local v994, v995 = proto.writeTag(buf, n27, 2, proto.wireTypes.lengthDelimited)

		buf, n27 = proto.writeBuffer(v994, v995, v993, buffer.len(v993))
	end

	local buf39 = buffer.create(n27)

	buffer.copy(buf39, 0, buf, 0, n27)

	return buf39
end
function t119.decode(p41: buffer) -- line: 3822
	-- upvalues: t119 (copy), proto (copy), marketplace_bundle_data (copy)
	local v998 = t119.new()
	local n28 = 0

	while n28 < buffer.len(p41) do
		local v1000, v1001

		v1000, v1001, n28 = proto.readTag(p41, n28)

		if v1001 == proto.wireTypes.varint then
			local v1002

			v1002, n28 = proto.readVarInt(p41, n28)
		elseif v1001 == proto.wireTypes.lengthDelimited then
			if v1000 == 1 then
				local v1003

				v1003, n28 = proto.readBuffer(p41, n28)
				v998.key = buffer.tostring(v1003)
			elseif v1000 == 2 then
				local v1004

				v1004, n28 = proto.readBuffer(p41, n28)
				v998.value = marketplace_bundle_data.MarketplaceBundleData.decode(v1004)
			else
				local v1005, v1006 = proto.readVarInt(p41, n28)

				n28 = v1006 + v1005
			end
		elseif v1001 == proto.wireTypes.i32 then
			local v1007

			v1007, n28 = proto.readFixed32(p41, n28)
		elseif v1001 == proto.wireTypes.i64 then
			local v1008

			v1008, n28 = proto.readFixed64(p41, n28)
		else
			error("Unsupported wire type: " .. v1001)
		end
	end

	return v998
end
function t119.jsonEncode(p42) -- line: 3873
	local t121 = {}

	if p42.key ~= nil and p42.key ~= "" then
		t121.key = p42.key
	end

	if p42.value ~= nil then
		t121.value = p42.value:jsonEncode()
	end

	return t121
end
function t119.jsonDecode(t122: {[any]: any}) -- line: 3887
	-- upvalues: t119 (copy), marketplace_bundle_data (copy)
	local v1012 = t119.new()

	if t122.key ~= nil then
		v1012.key = t122.key
	end

	if t122.value ~= nil then
		v1012.value = marketplace_bundle_data.MarketplaceBundleData.jsonDecode(t122.value)
	end

	return v1012
end

t119.descriptor = {
	name = "HydrationContent_MarketplaceBundleEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.MarketplaceBundleEntry"
}
t1.HydrationContent_MarketplaceBundleEntry = t119
typeRegistry.default:register(t1.HydrationContent_MarketplaceBundleEntry)

local t123 = {}

t123.__index = t123

function t123.new(t124: {[any]: any}?) -- line: 3920
	-- upvalues: t123 (copy)
	return (setmetatable({
		key = if t124 ~= nil and t124.key ~= nil then t124.key else "",
		value = if t124 ~= nil and t124.value ~= nil then t124.value else nil
	}, t123))
end
function t123.encode(p43) -- line: 3929
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n29 = 0

	if p43.key ~= nil and p43.key ~= "" then
		local v1017, v1018 = proto.writeTag(buf, n29, 1, proto.wireTypes.lengthDelimited)

		buf, n29 = proto.writeString(v1017, v1018, p43.key)
	end

	if p43.value ~= nil then
		local v1019 = p43.value:encode()
		local v1020, v1021 = proto.writeTag(buf, n29, 2, proto.wireTypes.lengthDelimited)

		buf, n29 = proto.writeBuffer(v1020, v1021, v1019, buffer.len(v1019))
	end

	local buf40 = buffer.create(n29)

	buffer.copy(buf40, 0, buf, 0, n29)

	return buf40
end
function t123.decode(p44: buffer) -- line: 3949
	-- upvalues: t123 (copy), proto (copy), marketplace_look_data (copy)
	local v1024 = t123.new()
	local n30 = 0

	while n30 < buffer.len(p44) do
		local v1026, v1027

		v1026, v1027, n30 = proto.readTag(p44, n30)

		if v1027 == proto.wireTypes.varint then
			local v1028

			v1028, n30 = proto.readVarInt(p44, n30)
		elseif v1027 == proto.wireTypes.lengthDelimited then
			if v1026 == 1 then
				local v1029

				v1029, n30 = proto.readBuffer(p44, n30)
				v1024.key = buffer.tostring(v1029)
			elseif v1026 == 2 then
				local v1030

				v1030, n30 = proto.readBuffer(p44, n30)
				v1024.value = marketplace_look_data.MarketplaceLookData.decode(v1030)
			else
				local v1031, v1032 = proto.readVarInt(p44, n30)

				n30 = v1032 + v1031
			end
		elseif v1027 == proto.wireTypes.i32 then
			local v1033

			v1033, n30 = proto.readFixed32(p44, n30)
		elseif v1027 == proto.wireTypes.i64 then
			local v1034

			v1034, n30 = proto.readFixed64(p44, n30)
		else
			error("Unsupported wire type: " .. v1027)
		end
	end

	return v1024
end
function t123.jsonEncode(p45) -- line: 3998
	local t125 = {}

	if p45.key ~= nil and p45.key ~= "" then
		t125.key = p45.key
	end

	if p45.value ~= nil then
		t125.value = p45.value:jsonEncode()
	end

	return t125
end
function t123.jsonDecode(t126: {[any]: any}) -- line: 4012
	-- upvalues: t123 (copy), marketplace_look_data (copy)
	local v1038 = t123.new()

	if t126.key ~= nil then
		v1038.key = t126.key
	end

	if t126.value ~= nil then
		v1038.value = marketplace_look_data.MarketplaceLookData.jsonDecode(t126.value)
	end

	return v1038
end

t123.descriptor = {
	name = "HydrationContent_MarketplaceLookEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.MarketplaceLookEntry"
}
t1.HydrationContent_MarketplaceLookEntry = t123
typeRegistry.default:register(t1.HydrationContent_MarketplaceLookEntry)

local t127 = {}

t127.__index = t127

function t127.new(t128: {[any]: any}?) -- line: 4043
	-- upvalues: t127 (copy)
	return (setmetatable({
		key = if t128 ~= nil and t128.key ~= nil then t128.key else "",
		value = if t128 ~= nil and t128.value ~= nil then t128.value else nil
	}, t127))
end
function t127.encode(p46) -- line: 4052
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n31 = 0

	if p46.key ~= nil and p46.key ~= "" then
		local v1043, v1044 = proto.writeTag(buf, n31, 1, proto.wireTypes.lengthDelimited)

		buf, n31 = proto.writeString(v1043, v1044, p46.key)
	end

	if p46.value ~= nil then
		local v1045 = p46.value:encode()
		local v1046, v1047 = proto.writeTag(buf, n31, 2, proto.wireTypes.lengthDelimited)

		buf, n31 = proto.writeBuffer(v1046, v1047, v1045, buffer.len(v1045))
	end

	local buf41 = buffer.create(n31)

	buffer.copy(buf41, 0, buf, 0, n31)

	return buf41
end
function t127.decode(p47: buffer) -- line: 4072
	-- upvalues: t127 (copy), proto (copy), catalog_sort_data (copy)
	local v1050 = t127.new()
	local n32 = 0

	while n32 < buffer.len(p47) do
		local v1052, v1053

		v1052, v1053, n32 = proto.readTag(p47, n32)

		if v1053 == proto.wireTypes.varint then
			local v1054

			v1054, n32 = proto.readVarInt(p47, n32)
		elseif v1053 == proto.wireTypes.lengthDelimited then
			if v1052 == 1 then
				local v1055

				v1055, n32 = proto.readBuffer(p47, n32)
				v1050.key = buffer.tostring(v1055)
			elseif v1052 == 2 then
				local v1056

				v1056, n32 = proto.readBuffer(p47, n32)
				v1050.value = catalog_sort_data.CatalogSortData.decode(v1056)
			else
				local v1057, v1058 = proto.readVarInt(p47, n32)

				n32 = v1058 + v1057
			end
		elseif v1053 == proto.wireTypes.i32 then
			local v1059

			v1059, n32 = proto.readFixed32(p47, n32)
		elseif v1053 == proto.wireTypes.i64 then
			local v1060

			v1060, n32 = proto.readFixed64(p47, n32)
		else
			error("Unsupported wire type: " .. v1053)
		end
	end

	return v1050
end
function t127.jsonEncode(p48) -- line: 4120
	local t129 = {}

	if p48.key ~= nil and p48.key ~= "" then
		t129.key = p48.key
	end

	if p48.value ~= nil then
		t129.value = p48.value:jsonEncode()
	end

	return t129
end
function t127.jsonDecode(t130: {[any]: any}) -- line: 4134
	-- upvalues: t127 (copy), catalog_sort_data (copy)
	local v1064 = t127.new()

	if t130.key ~= nil then
		v1064.key = t130.key
	end

	if t130.value ~= nil then
		v1064.value = catalog_sort_data.CatalogSortData.jsonDecode(t130.value)
	end

	return v1064
end

t127.descriptor = {
	name = "HydrationContent_CatalogSortEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.CatalogSortEntry"
}
t1.HydrationContent_CatalogSortEntry = t127
typeRegistry.default:register(t1.HydrationContent_CatalogSortEntry)

local t131 = {}

t131.__index = t131

function t131.new(t132: {[any]: any}?) -- line: 4165
	-- upvalues: t131 (copy)
	return (setmetatable({
		key = if t132 ~= nil and t132.key ~= nil then t132.key else "",
		value = if t132 ~= nil and t132.value ~= nil then t132.value else nil
	}, t131))
end
function t131.encode(p49) -- line: 4174
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n33 = 0

	if p49.key ~= nil and p49.key ~= "" then
		local v1069, v1070 = proto.writeTag(buf, n33, 1, proto.wireTypes.lengthDelimited)

		buf, n33 = proto.writeString(v1069, v1070, p49.key)
	end

	if p49.value ~= nil then
		local v1071 = p49.value:encode()
		local v1072, v1073 = proto.writeTag(buf, n33, 2, proto.wireTypes.lengthDelimited)

		buf, n33 = proto.writeBuffer(v1072, v1073, v1071, buffer.len(v1071))
	end

	local buf42 = buffer.create(n33)

	buffer.copy(buf42, 0, buf, 0, n33)

	return buf42
end
function t131.decode(p50: buffer) -- line: 4194
	-- upvalues: t131 (copy), proto (copy), age_recommendation_data (copy)
	local v1076 = t131.new()
	local n34 = 0

	while n34 < buffer.len(p50) do
		local v1078, v1079

		v1078, v1079, n34 = proto.readTag(p50, n34)

		if v1079 == proto.wireTypes.varint then
			local v1080

			v1080, n34 = proto.readVarInt(p50, n34)
		elseif v1079 == proto.wireTypes.lengthDelimited then
			if v1078 == 1 then
				local v1081

				v1081, n34 = proto.readBuffer(p50, n34)
				v1076.key = buffer.tostring(v1081)
			elseif v1078 == 2 then
				local v1082

				v1082, n34 = proto.readBuffer(p50, n34)
				v1076.value = age_recommendation_data.AgeRecommendationData.decode(v1082)
			else
				local v1083, v1084 = proto.readVarInt(p50, n34)

				n34 = v1084 + v1083
			end
		elseif v1079 == proto.wireTypes.i32 then
			local v1085

			v1085, n34 = proto.readFixed32(p50, n34)
		elseif v1079 == proto.wireTypes.i64 then
			local v1086

			v1086, n34 = proto.readFixed64(p50, n34)
		else
			error("Unsupported wire type: " .. v1079)
		end
	end

	return v1076
end
function t131.jsonEncode(p51) -- line: 4245
	local t133 = {}

	if p51.key ~= nil and p51.key ~= "" then
		t133.key = p51.key
	end

	if p51.value ~= nil then
		t133.value = p51.value:jsonEncode()
	end

	return t133
end
function t131.jsonDecode(t134: {[any]: any}) -- line: 4259
	-- upvalues: t131 (copy), age_recommendation_data (copy)
	local v1090 = t131.new()

	if t134.key ~= nil then
		v1090.key = t134.key
	end

	if t134.value ~= nil then
		v1090.value = age_recommendation_data.AgeRecommendationData.jsonDecode(t134.value)
	end

	return v1090
end

t131.descriptor = {
	name = "HydrationContent_AgeRecommendationEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.AgeRecommendationEntry"
}
t1.HydrationContent_AgeRecommendationEntry = t131
typeRegistry.default:register(t1.HydrationContent_AgeRecommendationEntry)

local t135 = {}

t135.__index = t135

function t135.new(t136: {[any]: any}?) -- line: 4292
	-- upvalues: t135 (copy)
	return (setmetatable({
		key = if t136 ~= nil and t136.key ~= nil then t136.key else "",
		value = if t136 ~= nil and t136.value ~= nil then t136.value else nil
	}, t135))
end
function t135.encode(p52) -- line: 4301
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n35 = 0

	if p52.key ~= nil and p52.key ~= "" then
		local v1095, v1096 = proto.writeTag(buf, n35, 1, proto.wireTypes.lengthDelimited)

		buf, n35 = proto.writeString(v1095, v1096, p52.key)
	end

	if p52.value ~= nil then
		local v1097 = p52.value:encode()
		local v1098, v1099 = proto.writeTag(buf, n35, 2, proto.wireTypes.lengthDelimited)

		buf, n35 = proto.writeBuffer(v1098, v1099, v1097, buffer.len(v1097))
	end

	local buf43 = buffer.create(n35)

	buffer.copy(buf43, 0, buf, 0, n35)

	return buf43
end
function t135.decode(p53: buffer) -- line: 4323
	-- upvalues: t135 (copy), proto (copy), universe_user_follow_data (copy)
	local v1102 = t135.new()
	local n36 = 0

	while n36 < buffer.len(p53) do
		local v1104, v1105

		v1104, v1105, n36 = proto.readTag(p53, n36)

		if v1105 == proto.wireTypes.varint then
			local v1106

			v1106, n36 = proto.readVarInt(p53, n36)
		elseif v1105 == proto.wireTypes.lengthDelimited then
			if v1104 == 1 then
				local v1107

				v1107, n36 = proto.readBuffer(p53, n36)
				v1102.key = buffer.tostring(v1107)
			elseif v1104 == 2 then
				local v1108

				v1108, n36 = proto.readBuffer(p53, n36)
				v1102.value = universe_user_follow_data.UniverseUserFollowData.decode(v1108)
			else
				local v1109, v1110 = proto.readVarInt(p53, n36)

				n36 = v1110 + v1109
			end
		elseif v1105 == proto.wireTypes.i32 then
			local v1111

			v1111, n36 = proto.readFixed32(p53, n36)
		elseif v1105 == proto.wireTypes.i64 then
			local v1112

			v1112, n36 = proto.readFixed64(p53, n36)
		else
			error("Unsupported wire type: " .. v1105)
		end
	end

	return v1102
end
function t135.jsonEncode(p54) -- line: 4376
	local t137 = {}

	if p54.key ~= nil and p54.key ~= "" then
		t137.key = p54.key
	end

	if p54.value ~= nil then
		t137.value = p54.value:jsonEncode()
	end

	return t137
end
function t135.jsonDecode(t138: {[any]: any}) -- line: 4392
	-- upvalues: t135 (copy), universe_user_follow_data (copy)
	local v1116 = t135.new()

	if t138.key ~= nil then
		v1116.key = t138.key
	end

	if t138.value ~= nil then
		v1116.value = universe_user_follow_data.UniverseUserFollowData.jsonDecode(t138.value)
	end

	return v1116
end

t135.descriptor = {
	name = "HydrationContent_UniverseUserFollowEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniverseUserFollowEntry"
}
t1.HydrationContent_UniverseUserFollowEntry = t135
typeRegistry.default:register(t1.HydrationContent_UniverseUserFollowEntry)

local t139 = {}

t139.__index = t139

function t139.new(t140: {[any]: any}?) -- line: 4425
	-- upvalues: t139 (copy)
	return (setmetatable({
		key = if t140 ~= nil and t140.key ~= nil then t140.key else "",
		value = if t140 ~= nil and t140.value ~= nil then t140.value else nil
	}, t139))
end
function t139.encode(p55) -- line: 4434
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n37 = 0

	if p55.key ~= nil and p55.key ~= "" then
		local v1121, v1122 = proto.writeTag(buf, n37, 1, proto.wireTypes.lengthDelimited)

		buf, n37 = proto.writeString(v1121, v1122, p55.key)
	end

	if p55.value ~= nil then
		local v1123 = p55.value:encode()
		local v1124, v1125 = proto.writeTag(buf, n37, 2, proto.wireTypes.lengthDelimited)

		buf, n37 = proto.writeBuffer(v1124, v1125, v1123, buffer.len(v1123))
	end

	local buf44 = buffer.create(n37)

	buffer.copy(buf44, 0, buf, 0, n37)

	return buf44
end
function t139.decode(p56: buffer) -- line: 4454
	-- upvalues: t139 (copy), proto (copy), universe_user_vote_data (copy)
	local v1128 = t139.new()
	local n38 = 0

	while n38 < buffer.len(p56) do
		local v1130, v1131

		v1130, v1131, n38 = proto.readTag(p56, n38)

		if v1131 == proto.wireTypes.varint then
			local v1132

			v1132, n38 = proto.readVarInt(p56, n38)
		elseif v1131 == proto.wireTypes.lengthDelimited then
			if v1130 == 1 then
				local v1133

				v1133, n38 = proto.readBuffer(p56, n38)
				v1128.key = buffer.tostring(v1133)
			elseif v1130 == 2 then
				local v1134

				v1134, n38 = proto.readBuffer(p56, n38)
				v1128.value = universe_user_vote_data.UniverseUserVoteData.decode(v1134)
			else
				local v1135, v1136 = proto.readVarInt(p56, n38)

				n38 = v1136 + v1135
			end
		elseif v1131 == proto.wireTypes.i32 then
			local v1137

			v1137, n38 = proto.readFixed32(p56, n38)
		elseif v1131 == proto.wireTypes.i64 then
			local v1138

			v1138, n38 = proto.readFixed64(p56, n38)
		else
			error("Unsupported wire type: " .. v1131)
		end
	end

	return v1128
end
function t139.jsonEncode(p57) -- line: 4505
	local t141 = {}

	if p57.key ~= nil and p57.key ~= "" then
		t141.key = p57.key
	end

	if p57.value ~= nil then
		t141.value = p57.value:jsonEncode()
	end

	return t141
end
function t139.jsonDecode(t142: {[any]: any}) -- line: 4519
	-- upvalues: t139 (copy), universe_user_vote_data (copy)
	local v1142 = t139.new()

	if t142.key ~= nil then
		v1142.key = t142.key
	end

	if t142.value ~= nil then
		v1142.value = universe_user_vote_data.UniverseUserVoteData.jsonDecode(t142.value)
	end

	return v1142
end

t139.descriptor = {
	name = "HydrationContent_UniverseUserVoteEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniverseUserVoteEntry"
}
t1.HydrationContent_UniverseUserVoteEntry = t139
typeRegistry.default:register(t1.HydrationContent_UniverseUserVoteEntry)

local t143 = {}

t143.__index = t143

function t143.new(t144: {[any]: any}?) -- line: 4551
	-- upvalues: t143 (copy)
	return (setmetatable({
		key = if t144 ~= nil and t144.key ~= nil then t144.key else "",
		value = if t144 ~= nil and t144.value ~= nil then t144.value else nil
	}, t143))
end
function t143.encode(p58) -- line: 4560
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n39 = 0

	if p58.key ~= nil and p58.key ~= "" then
		local v1147, v1148 = proto.writeTag(buf, n39, 1, proto.wireTypes.lengthDelimited)

		buf, n39 = proto.writeString(v1147, v1148, p58.key)
	end

	if p58.value ~= nil then
		local v1149 = p58.value:encode()
		local v1150, v1151 = proto.writeTag(buf, n39, 2, proto.wireTypes.lengthDelimited)

		buf, n39 = proto.writeBuffer(v1150, v1151, v1149, buffer.len(v1149))
	end

	local buf45 = buffer.create(n39)

	buffer.copy(buf45, 0, buf, 0, n39)

	return buf45
end
function t143.decode(p59: buffer) -- line: 4580
	-- upvalues: t143 (copy), proto (copy), user_profile_data (copy)
	local v1154 = t143.new()
	local n40 = 0

	while n40 < buffer.len(p59) do
		local v1156, v1157

		v1156, v1157, n40 = proto.readTag(p59, n40)

		if v1157 == proto.wireTypes.varint then
			local v1158

			v1158, n40 = proto.readVarInt(p59, n40)
		elseif v1157 == proto.wireTypes.lengthDelimited then
			if v1156 == 1 then
				local v1159

				v1159, n40 = proto.readBuffer(p59, n40)
				v1154.key = buffer.tostring(v1159)
			elseif v1156 == 2 then
				local v1160

				v1160, n40 = proto.readBuffer(p59, n40)
				v1154.value = user_profile_data.UserProfileData.decode(v1160)
			else
				local v1161, v1162 = proto.readVarInt(p59, n40)

				n40 = v1162 + v1161
			end
		elseif v1157 == proto.wireTypes.i32 then
			local v1163

			v1163, n40 = proto.readFixed32(p59, n40)
		elseif v1157 == proto.wireTypes.i64 then
			local v1164

			v1164, n40 = proto.readFixed64(p59, n40)
		else
			error("Unsupported wire type: " .. v1157)
		end
	end

	return v1154
end
function t143.jsonEncode(p60) -- line: 4628
	local t145 = {}

	if p60.key ~= nil and p60.key ~= "" then
		t145.key = p60.key
	end

	if p60.value ~= nil then
		t145.value = p60.value:jsonEncode()
	end

	return t145
end
function t143.jsonDecode(t146: {[any]: any}) -- line: 4642
	-- upvalues: t143 (copy), user_profile_data (copy)
	local v1168 = t143.new()

	if t146.key ~= nil then
		v1168.key = t146.key
	end

	if t146.value ~= nil then
		v1168.value = user_profile_data.UserProfileData.jsonDecode(t146.value)
	end

	return v1168
end

t143.descriptor = {
	name = "HydrationContent_UserProfileEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.UserProfileEntry"
}
t1.HydrationContent_UserProfileEntry = t143
typeRegistry.default:register(t1.HydrationContent_UserProfileEntry)

local t147 = {}

t147.__index = t147

function t147.new(t148: {[any]: any}?) -- line: 4673
	-- upvalues: t147 (copy)
	return (setmetatable({
		key = if t148 ~= nil and t148.key ~= nil then t148.key else "",
		value = if t148 ~= nil and t148.value ~= nil then t148.value else nil
	}, t147))
end
function t147.encode(p61) -- line: 4682
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n41 = 0

	if p61.key ~= nil and p61.key ~= "" then
		local v1173, v1174 = proto.writeTag(buf, n41, 1, proto.wireTypes.lengthDelimited)

		buf, n41 = proto.writeString(v1173, v1174, p61.key)
	end

	if p61.value ~= nil then
		local v1175 = p61.value:encode()
		local v1176, v1177 = proto.writeTag(buf, n41, 2, proto.wireTypes.lengthDelimited)

		buf, n41 = proto.writeBuffer(v1176, v1177, v1175, buffer.len(v1175))
	end

	local buf46 = buffer.create(n41)

	buffer.copy(buf46, 0, buf, 0, n41)

	return buf46
end
function t147.decode(p62: buffer) -- line: 4704
	-- upvalues: t147 (copy), proto (copy), universe_user_favorite_data (copy)
	local v1180 = t147.new()
	local n42 = 0

	while n42 < buffer.len(p62) do
		local v1182, v1183

		v1182, v1183, n42 = proto.readTag(p62, n42)

		if v1183 == proto.wireTypes.varint then
			local v1184

			v1184, n42 = proto.readVarInt(p62, n42)
		elseif v1183 == proto.wireTypes.lengthDelimited then
			if v1182 == 1 then
				local v1185

				v1185, n42 = proto.readBuffer(p62, n42)
				v1180.key = buffer.tostring(v1185)
			elseif v1182 == 2 then
				local v1186

				v1186, n42 = proto.readBuffer(p62, n42)
				v1180.value = universe_user_favorite_data.UniverseUserFavoriteData.decode(v1186)
			else
				local v1187, v1188 = proto.readVarInt(p62, n42)

				n42 = v1188 + v1187
			end
		elseif v1183 == proto.wireTypes.i32 then
			local v1189

			v1189, n42 = proto.readFixed32(p62, n42)
		elseif v1183 == proto.wireTypes.i64 then
			local v1190

			v1190, n42 = proto.readFixed64(p62, n42)
		else
			error("Unsupported wire type: " .. v1183)
		end
	end

	return v1180
end
function t147.jsonEncode(p63) -- line: 4757
	local t149 = {}

	if p63.key ~= nil and p63.key ~= "" then
		t149.key = p63.key
	end

	if p63.value ~= nil then
		t149.value = p63.value:jsonEncode()
	end

	return t149
end
function t147.jsonDecode(t150: {[any]: any}) -- line: 4773
	-- upvalues: t147 (copy), universe_user_favorite_data (copy)
	local v1194 = t147.new()

	if t150.key ~= nil then
		v1194.key = t150.key
	end

	if t150.value ~= nil then
		v1194.value = universe_user_favorite_data.UniverseUserFavoriteData.jsonDecode(t150.value)
	end

	return v1194
end

t147.descriptor = {
	name = "HydrationContent_UniverseUserFavoriteEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniverseUserFavoriteEntry"
}
t1.HydrationContent_UniverseUserFavoriteEntry = t147
typeRegistry.default:register(t1.HydrationContent_UniverseUserFavoriteEntry)

local t151 = {}

t151.__index = t151

function t151.new(t152: {[any]: any}?) -- line: 4806
	-- upvalues: t151 (copy)
	return (setmetatable({
		key = if t152 ~= nil and t152.key ~= nil then t152.key else "",
		value = if t152 ~= nil and t152.value ~= nil then t152.value else nil
	}, t151))
end
function t151.encode(p64) -- line: 4815
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n43 = 0

	if p64.key ~= nil and p64.key ~= "" then
		local v1199, v1200 = proto.writeTag(buf, n43, 1, proto.wireTypes.lengthDelimited)

		buf, n43 = proto.writeString(v1199, v1200, p64.key)
	end

	if p64.value ~= nil then
		local v1201 = p64.value:encode()
		local v1202, v1203 = proto.writeTag(buf, n43, 2, proto.wireTypes.lengthDelimited)

		buf, n43 = proto.writeBuffer(v1202, v1203, v1201, buffer.len(v1201))
	end

	local buf47 = buffer.create(n43)

	buffer.copy(buf47, 0, buf, 0, n43)

	return buf47
end
function t151.decode(p65: buffer) -- line: 4835
	-- upvalues: t151 (copy), proto (copy), playability_data (copy)
	local v1206 = t151.new()
	local n44 = 0

	while n44 < buffer.len(p65) do
		local v1208, v1209

		v1208, v1209, n44 = proto.readTag(p65, n44)

		if v1209 == proto.wireTypes.varint then
			local v1210

			v1210, n44 = proto.readVarInt(p65, n44)
		elseif v1209 == proto.wireTypes.lengthDelimited then
			if v1208 == 1 then
				local v1211

				v1211, n44 = proto.readBuffer(p65, n44)
				v1206.key = buffer.tostring(v1211)
			elseif v1208 == 2 then
				local v1212

				v1212, n44 = proto.readBuffer(p65, n44)
				v1206.value = playability_data.PlayabilityData.decode(v1212)
			else
				local v1213, v1214 = proto.readVarInt(p65, n44)

				n44 = v1214 + v1213
			end
		elseif v1209 == proto.wireTypes.i32 then
			local v1215

			v1215, n44 = proto.readFixed32(p65, n44)
		elseif v1209 == proto.wireTypes.i64 then
			local v1216

			v1216, n44 = proto.readFixed64(p65, n44)
		else
			error("Unsupported wire type: " .. v1209)
		end
	end

	return v1206
end
function t151.jsonEncode(p66) -- line: 4883
	local t153 = {}

	if p66.key ~= nil and p66.key ~= "" then
		t153.key = p66.key
	end

	if p66.value ~= nil then
		t153.value = p66.value:jsonEncode()
	end

	return t153
end
function t151.jsonDecode(t154: {[any]: any}) -- line: 4897
	-- upvalues: t151 (copy), playability_data (copy)
	local v1220 = t151.new()

	if t154.key ~= nil then
		v1220.key = t154.key
	end

	if t154.value ~= nil then
		v1220.value = playability_data.PlayabilityData.jsonDecode(t154.value)
	end

	return v1220
end

t151.descriptor = {
	name = "HydrationContent_PlayabilityEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.PlayabilityEntry"
}
t1.HydrationContent_PlayabilityEntry = t151
typeRegistry.default:register(t1.HydrationContent_PlayabilityEntry)

local t155 = {}

t155.__index = t155

function t155.new(t156: {[any]: any}?) -- line: 4927
	-- upvalues: t155 (copy)
	return (setmetatable({
		key = if t156 ~= nil and t156.key ~= nil then t156.key else "",
		value = if t156 ~= nil and t156.value ~= nil then t156.value else nil
	}, t155))
end
function t155.encode(p67) -- line: 4936
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n45 = 0

	if p67.key ~= nil and p67.key ~= "" then
		local v1225, v1226 = proto.writeTag(buf, n45, 1, proto.wireTypes.lengthDelimited)

		buf, n45 = proto.writeString(v1225, v1226, p67.key)
	end

	if p67.value ~= nil then
		local v1227 = p67.value:encode()
		local v1228, v1229 = proto.writeTag(buf, n45, 2, proto.wireTypes.lengthDelimited)

		buf, n45 = proto.writeBuffer(v1228, v1229, v1227, buffer.len(v1227))
	end

	local buf48 = buffer.create(n45)

	buffer.copy(buf48, 0, buf, 0, n45)

	return buf48
end
function t155.decode(p68: buffer) -- line: 4958
	-- upvalues: t155 (copy), proto (copy), universe_user_follow_limit_data (copy)
	local v1232 = t155.new()
	local n46 = 0

	while n46 < buffer.len(p68) do
		local v1234, v1235

		v1234, v1235, n46 = proto.readTag(p68, n46)

		if v1235 == proto.wireTypes.varint then
			local v1236

			v1236, n46 = proto.readVarInt(p68, n46)
		elseif v1235 == proto.wireTypes.lengthDelimited then
			if v1234 == 1 then
				local v1237

				v1237, n46 = proto.readBuffer(p68, n46)
				v1232.key = buffer.tostring(v1237)
			elseif v1234 == 2 then
				local v1238

				v1238, n46 = proto.readBuffer(p68, n46)
				v1232.value = universe_user_follow_limit_data.UniverseUserFollowLimitData.decode(v1238)
			else
				local v1239, v1240 = proto.readVarInt(p68, n46)

				n46 = v1240 + v1239
			end
		elseif v1235 == proto.wireTypes.i32 then
			local v1241

			v1241, n46 = proto.readFixed32(p68, n46)
		elseif v1235 == proto.wireTypes.i64 then
			local v1242

			v1242, n46 = proto.readFixed64(p68, n46)
		else
			error("Unsupported wire type: " .. v1235)
		end
	end

	return v1232
end
function t155.jsonEncode(p69) -- line: 5011
	local t157 = {}

	if p69.key ~= nil and p69.key ~= "" then
		t157.key = p69.key
	end

	if p69.value ~= nil then
		t157.value = p69.value:jsonEncode()
	end

	return t157
end
function t155.jsonDecode(t158: {[any]: any}) -- line: 5027
	-- upvalues: t155 (copy), universe_user_follow_limit_data (copy)
	local v1246 = t155.new()

	if t158.key ~= nil then
		v1246.key = t158.key
	end

	if t158.value ~= nil then
		v1246.value = universe_user_follow_limit_data.UniverseUserFollowLimitData.jsonDecode(t158.value)
	end

	return v1246
end

t155.descriptor = {
	name = "HydrationContent_UniverseUserFollowLimitEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniverseUserFollowLimitEntry"
}
t1.HydrationContent_UniverseUserFollowLimitEntry = t155
typeRegistry.default:register(t1.HydrationContent_UniverseUserFollowLimitEntry)

local t159 = {}

t159.__index = t159

function t159.new(t160: {[any]: any}?) -- line: 5061
	-- upvalues: t159 (copy)
	return (setmetatable({
		key = if t160 ~= nil and t160.key ~= nil then t160.key else "",
		value = if t160 ~= nil and t160.value ~= nil then t160.value else nil
	}, t159))
end
function t159.encode(p70) -- line: 5073
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n47 = 0

	if p70.key ~= nil and p70.key ~= "" then
		local v1251, v1252 = proto.writeTag(buf, n47, 1, proto.wireTypes.lengthDelimited)

		buf, n47 = proto.writeString(v1251, v1252, p70.key)
	end

	if p70.value ~= nil then
		local v1253 = p70.value:encode()
		local v1254, v1255 = proto.writeTag(buf, n47, 2, proto.wireTypes.lengthDelimited)

		buf, n47 = proto.writeBuffer(v1254, v1255, v1253, buffer.len(v1253))
	end

	local buf49 = buffer.create(n47)

	buffer.copy(buf49, 0, buf, 0, n47)

	return buf49
end
function t159.decode(p71: buffer) -- line: 5095
	-- upvalues: t159 (copy), proto (copy), universe_user_vote_feedback_metadata_data (copy)
	local v1258 = t159.new()
	local n48 = 0

	while n48 < buffer.len(p71) do
		local v1260, v1261

		v1260, v1261, n48 = proto.readTag(p71, n48)

		if v1261 == proto.wireTypes.varint then
			local v1262

			v1262, n48 = proto.readVarInt(p71, n48)
		elseif v1261 == proto.wireTypes.lengthDelimited then
			if v1260 == 1 then
				local v1263

				v1263, n48 = proto.readBuffer(p71, n48)
				v1258.key = buffer.tostring(v1263)
			elseif v1260 == 2 then
				local v1264

				v1264, n48 = proto.readBuffer(p71, n48)
				v1258.value = universe_user_vote_feedback_metadata_data.UniverseUserVoteFeedbackMetadataData.decode(v1264)
			else
				local v1265, v1266 = proto.readVarInt(p71, n48)

				n48 = v1266 + v1265
			end
		elseif v1261 == proto.wireTypes.i32 then
			local v1267

			v1267, n48 = proto.readFixed32(p71, n48)
		elseif v1261 == proto.wireTypes.i64 then
			local v1268

			v1268, n48 = proto.readFixed64(p71, n48)
		else
			error("Unsupported wire type: " .. v1261)
		end
	end

	return v1258
end
function t159.jsonEncode(p72) -- line: 5148
	local t161 = {}

	if p72.key ~= nil and p72.key ~= "" then
		t161.key = p72.key
	end

	if p72.value ~= nil then
		t161.value = p72.value:jsonEncode()
	end

	return t161
end
function t159.jsonDecode(t162: {[any]: any}) -- line: 5164
	-- upvalues: t159 (copy), universe_user_vote_feedback_metadata_data (copy)
	local v1272 = t159.new()

	if t162.key ~= nil then
		v1272.key = t162.key
	end

	if t162.value ~= nil then
		v1272.value = universe_user_vote_feedback_metadata_data.UniverseUserVoteFeedbackMetadataData.jsonDecode(t162.value)
	end

	return v1272
end

t159.descriptor = {
	name = "HydrationContent_UniverseUserVoteFeedbackMetadataEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniverseUserVoteFeedbackMetadataEntry"
}
t1.HydrationContent_UniverseUserVoteFeedbackMetadataEntry = t159
typeRegistry.default:register(t1.HydrationContent_UniverseUserVoteFeedbackMetadataEntry)

local t163 = {}

t163.__index = t163

function t163.new(t164: {[any]: any}?) -- line: 5198
	-- upvalues: t163 (copy)
	return (setmetatable({
		key = if t164 ~= nil and t164.key ~= nil then t164.key else "",
		value = if t164 ~= nil and t164.value ~= nil then t164.value else nil
	}, t163))
end
function t163.encode(p73) -- line: 5207
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n49 = 0

	if p73.key ~= nil and p73.key ~= "" then
		local v1277, v1278 = proto.writeTag(buf, n49, 1, proto.wireTypes.lengthDelimited)

		buf, n49 = proto.writeString(v1277, v1278, p73.key)
	end

	if p73.value ~= nil then
		local v1279 = p73.value:encode()
		local v1280, v1281 = proto.writeTag(buf, n49, 2, proto.wireTypes.lengthDelimited)

		buf, n49 = proto.writeBuffer(v1280, v1281, v1279, buffer.len(v1279))
	end

	local buf50 = buffer.create(n49)

	buffer.copy(buf50, 0, buf, 0, n49)

	return buf50
end
function t163.decode(p74: buffer) -- line: 5227
	-- upvalues: t163 (copy), proto (copy), moment_data (copy)
	local v1284 = t163.new()
	local n50 = 0

	while n50 < buffer.len(p74) do
		local v1286, v1287

		v1286, v1287, n50 = proto.readTag(p74, n50)

		if v1287 == proto.wireTypes.varint then
			local v1288

			v1288, n50 = proto.readVarInt(p74, n50)
		elseif v1287 == proto.wireTypes.lengthDelimited then
			if v1286 == 1 then
				local v1289

				v1289, n50 = proto.readBuffer(p74, n50)
				v1284.key = buffer.tostring(v1289)
			elseif v1286 == 2 then
				local v1290

				v1290, n50 = proto.readBuffer(p74, n50)
				v1284.value = moment_data.MomentData.decode(v1290)
			else
				local v1291, v1292 = proto.readVarInt(p74, n50)

				n50 = v1292 + v1291
			end
		elseif v1287 == proto.wireTypes.i32 then
			local v1293

			v1293, n50 = proto.readFixed32(p74, n50)
		elseif v1287 == proto.wireTypes.i64 then
			local v1294

			v1294, n50 = proto.readFixed64(p74, n50)
		else
			error("Unsupported wire type: " .. v1287)
		end
	end

	return v1284
end
function t163.jsonEncode(p75) -- line: 5275
	local t165 = {}

	if p75.key ~= nil and p75.key ~= "" then
		t165.key = p75.key
	end

	if p75.value ~= nil then
		t165.value = p75.value:jsonEncode()
	end

	return t165
end
function t163.jsonDecode(t166: {[any]: any}) -- line: 5289
	-- upvalues: t163 (copy), moment_data (copy)
	local v1298 = t163.new()

	if t166.key ~= nil then
		v1298.key = t166.key
	end

	if t166.value ~= nil then
		v1298.value = moment_data.MomentData.jsonDecode(t166.value)
	end

	return v1298
end

t163.descriptor = {
	name = "HydrationContent_MomentEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.MomentEntry"
}
t1.HydrationContent_MomentEntry = t163
typeRegistry.default:register(t1.HydrationContent_MomentEntry)

return {
	HydrationContent = t1.HydrationContent
}
