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
local community_data = require(script.Parent.community_data)
local community_user_membership_data = require(script.Parent.community_user_membership_data)
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 967
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
		moment = if t3 ~= nil and t3.moment ~= nil then t3.moment else {},
		community = if t3 ~= nil and t3.community ~= nil then t3.community else {},
		community_user_membership = if t3 ~= nil and t3.community_user_membership ~= nil then t3.community_user_membership else {}
	}, t2))
end
function t2.encode(p1) -- line: 1013
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.badge ~= nil and next(p1.badge) ~= nil then
		for v61, v62 in p1.badge do
			local buf2 = buffer.create(0)
			local v64, v65 = proto.writeTag(buf2, 0, 1, proto.wireTypes.lengthDelimited)
			local v66, v67 = proto.writeString(v64, v65, v61)
			local v68 = v62:encode()
			local v69, v70 = proto.writeTag(v66, v67, 2, proto.wireTypes.lengthDelimited)
			local v71, v72 = proto.writeBuffer(v69, v70, v68, buffer.len(v68))
			local v73, v74 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v73, v74, v71, v72)
		end
	end

	if p1.universe ~= nil and next(p1.universe) ~= nil then
		for v75, v76 in p1.universe do
			local buf3 = buffer.create(0)
			local v78, v79 = proto.writeTag(buf3, 0, 1, proto.wireTypes.lengthDelimited)
			local v80, v81 = proto.writeString(v78, v79, v75)
			local v82 = v76:encode()
			local v83, v84 = proto.writeTag(v80, v81, 2, proto.wireTypes.lengthDelimited)
			local v85, v86 = proto.writeBuffer(v83, v84, v82, buffer.len(v82))
			local v87, v88 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v87, v88, v85, v86)
		end
	end

	if p1.creator ~= nil and next(p1.creator) ~= nil then
		for v89, v90 in p1.creator do
			local buf4 = buffer.create(0)
			local v92, v93 = proto.writeTag(buf4, 0, 1, proto.wireTypes.lengthDelimited)
			local v94, v95 = proto.writeString(v92, v93, v89)
			local v96 = v90:encode()
			local v97, v98 = proto.writeTag(v94, v95, 2, proto.wireTypes.lengthDelimited)
			local v99, v100 = proto.writeBuffer(v97, v98, v96, buffer.len(v96))
			local v101, v102 = proto.writeTag(buf, n1, 3, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v101, v102, v99, v100)
		end
	end

	if p1.event ~= nil and next(p1.event) ~= nil then
		for v103, v104 in p1.event do
			local buf5 = buffer.create(0)
			local v106, v107 = proto.writeTag(buf5, 0, 1, proto.wireTypes.lengthDelimited)
			local v108, v109 = proto.writeString(v106, v107, v103)
			local v110 = v104:encode()
			local v111, v112 = proto.writeTag(v108, v109, 2, proto.wireTypes.lengthDelimited)
			local v113, v114 = proto.writeBuffer(v111, v112, v110, buffer.len(v110))
			local v115, v116 = proto.writeTag(buf, n1, 4, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v115, v116, v113, v114)
		end
	end

	if p1.song ~= nil and next(p1.song) ~= nil then
		for v117, v118 in p1.song do
			local buf6 = buffer.create(0)
			local v120, v121 = proto.writeTag(buf6, 0, 1, proto.wireTypes.lengthDelimited)
			local v122, v123 = proto.writeString(v120, v121, v117)
			local v124 = v118:encode()
			local v125, v126 = proto.writeTag(v122, v123, 2, proto.wireTypes.lengthDelimited)
			local v127, v128 = proto.writeBuffer(v125, v126, v124, buffer.len(v124))
			local v129, v130 = proto.writeTag(buf, n1, 5, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v129, v130, v127, v128)
		end
	end

	if p1.game_pass ~= nil and next(p1.game_pass) ~= nil then
		for v131, v132 in p1.game_pass do
			local buf7 = buffer.create(0)
			local v134, v135 = proto.writeTag(buf7, 0, 1, proto.wireTypes.lengthDelimited)
			local v136, v137 = proto.writeString(v134, v135, v131)
			local v138 = v132:encode()
			local v139, v140 = proto.writeTag(v136, v137, 2, proto.wireTypes.lengthDelimited)
			local v141, v142 = proto.writeBuffer(v139, v140, v138, buffer.len(v138))
			local v143, v144 = proto.writeTag(buf, n1, 6, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v143, v144, v141, v142)
		end
	end

	if p1.media_asset ~= nil and next(p1.media_asset) ~= nil then
		for v145, v146 in p1.media_asset do
			local buf8 = buffer.create(0)
			local v148, v149 = proto.writeTag(buf8, 0, 1, proto.wireTypes.lengthDelimited)
			local v150, v151 = proto.writeString(v148, v149, v145)
			local v152 = v146:encode()
			local v153, v154 = proto.writeTag(v150, v151, 2, proto.wireTypes.lengthDelimited)
			local v155, v156 = proto.writeBuffer(v153, v154, v152, buffer.len(v152))
			local v157, v158 = proto.writeTag(buf, n1, 7, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v157, v158, v155, v156)
		end
	end

	if p1.social_link ~= nil and next(p1.social_link) ~= nil then
		for v159, v160 in p1.social_link do
			local buf9 = buffer.create(0)
			local v162, v163 = proto.writeTag(buf9, 0, 1, proto.wireTypes.lengthDelimited)
			local v164, v165 = proto.writeString(v162, v163, v159)
			local v166 = v160:encode()
			local v167, v168 = proto.writeTag(v164, v165, 2, proto.wireTypes.lengthDelimited)
			local v169, v170 = proto.writeBuffer(v167, v168, v166, buffer.len(v166))
			local v171, v172 = proto.writeTag(buf, n1, 8, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v171, v172, v169, v170)
		end
	end

	if p1.game_developer_product ~= nil and next(p1.game_developer_product) ~= nil then
		for v173, v174 in p1.game_developer_product do
			local buf10 = buffer.create(0)
			local v176, v177 = proto.writeTag(buf10, 0, 1, proto.wireTypes.lengthDelimited)
			local v178, v179 = proto.writeString(v176, v177, v173)
			local v180 = v174:encode()
			local v181, v182 = proto.writeTag(v178, v179, 2, proto.wireTypes.lengthDelimited)
			local v183, v184 = proto.writeBuffer(v181, v182, v180, buffer.len(v180))
			local v185, v186 = proto.writeTag(buf, n1, 9, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v185, v186, v183, v184)
		end
	end

	if p1.game_subscription ~= nil and next(p1.game_subscription) ~= nil then
		for v187, v188 in p1.game_subscription do
			local buf11 = buffer.create(0)
			local v190, v191 = proto.writeTag(buf11, 0, 1, proto.wireTypes.lengthDelimited)
			local v192, v193 = proto.writeString(v190, v191, v187)
			local v194 = v188:encode()
			local v195, v196 = proto.writeTag(v192, v193, 2, proto.wireTypes.lengthDelimited)
			local v197, v198 = proto.writeBuffer(v195, v196, v194, buffer.len(v194))
			local v199, v200 = proto.writeTag(buf, n1, 10, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v199, v200, v197, v198)
		end
	end

	if p1.marketplace_catalog_category ~= nil and next(p1.marketplace_catalog_category) ~= nil then
		for v201, v202 in p1.marketplace_catalog_category do
			local buf12 = buffer.create(0)
			local v204, v205 = proto.writeTag(buf12, 0, 1, proto.wireTypes.lengthDelimited)
			local v206, v207 = proto.writeString(v204, v205, v201)
			local v208 = v202:encode()
			local v209, v210 = proto.writeTag(v206, v207, 2, proto.wireTypes.lengthDelimited)
			local v211, v212 = proto.writeBuffer(v209, v210, v208, buffer.len(v208))
			local v213, v214 = proto.writeTag(buf, n1, 11, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v213, v214, v211, v212)
		end
	end

	if p1.marketplace_asset ~= nil and next(p1.marketplace_asset) ~= nil then
		for v215, v216 in p1.marketplace_asset do
			local buf13 = buffer.create(0)
			local v218, v219 = proto.writeTag(buf13, 0, 1, proto.wireTypes.lengthDelimited)
			local v220, v221 = proto.writeString(v218, v219, v215)
			local v222 = v216:encode()
			local v223, v224 = proto.writeTag(v220, v221, 2, proto.wireTypes.lengthDelimited)
			local v225, v226 = proto.writeBuffer(v223, v224, v222, buffer.len(v222))
			local v227, v228 = proto.writeTag(buf, n1, 12, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v227, v228, v225, v226)
		end
	end

	if p1.marketplace_bundle ~= nil and next(p1.marketplace_bundle) ~= nil then
		for v229, v230 in p1.marketplace_bundle do
			local buf14 = buffer.create(0)
			local v232, v233 = proto.writeTag(buf14, 0, 1, proto.wireTypes.lengthDelimited)
			local v234, v235 = proto.writeString(v232, v233, v229)
			local v236 = v230:encode()
			local v237, v238 = proto.writeTag(v234, v235, 2, proto.wireTypes.lengthDelimited)
			local v239, v240 = proto.writeBuffer(v237, v238, v236, buffer.len(v236))
			local v241, v242 = proto.writeTag(buf, n1, 13, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v241, v242, v239, v240)
		end
	end

	if p1.marketplace_look ~= nil and next(p1.marketplace_look) ~= nil then
		for v243, v244 in p1.marketplace_look do
			local buf15 = buffer.create(0)
			local v246, v247 = proto.writeTag(buf15, 0, 1, proto.wireTypes.lengthDelimited)
			local v248, v249 = proto.writeString(v246, v247, v243)
			local v250 = v244:encode()
			local v251, v252 = proto.writeTag(v248, v249, 2, proto.wireTypes.lengthDelimited)
			local v253, v254 = proto.writeBuffer(v251, v252, v250, buffer.len(v250))
			local v255, v256 = proto.writeTag(buf, n1, 14, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v255, v256, v253, v254)
		end
	end

	if p1.catalog_sort ~= nil and next(p1.catalog_sort) ~= nil then
		for v257, v258 in p1.catalog_sort do
			local buf16 = buffer.create(0)
			local v260, v261 = proto.writeTag(buf16, 0, 1, proto.wireTypes.lengthDelimited)
			local v262, v263 = proto.writeString(v260, v261, v257)
			local v264 = v258:encode()
			local v265, v266 = proto.writeTag(v262, v263, 2, proto.wireTypes.lengthDelimited)
			local v267, v268 = proto.writeBuffer(v265, v266, v264, buffer.len(v264))
			local v269, v270 = proto.writeTag(buf, n1, 15, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v269, v270, v267, v268)
		end
	end

	if p1.age_recommendation ~= nil and next(p1.age_recommendation) ~= nil then
		for v271, v272 in p1.age_recommendation do
			local buf17 = buffer.create(0)
			local v274, v275 = proto.writeTag(buf17, 0, 1, proto.wireTypes.lengthDelimited)
			local v276, v277 = proto.writeString(v274, v275, v271)
			local v278 = v272:encode()
			local v279, v280 = proto.writeTag(v276, v277, 2, proto.wireTypes.lengthDelimited)
			local v281, v282 = proto.writeBuffer(v279, v280, v278, buffer.len(v278))
			local v283, v284 = proto.writeTag(buf, n1, 16, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v283, v284, v281, v282)
		end
	end

	if p1.universe_user_follow ~= nil and next(p1.universe_user_follow) ~= nil then
		for v285, v286 in p1.universe_user_follow do
			local buf18 = buffer.create(0)
			local v288, v289 = proto.writeTag(buf18, 0, 1, proto.wireTypes.lengthDelimited)
			local v290, v291 = proto.writeString(v288, v289, v285)
			local v292 = v286:encode()
			local v293, v294 = proto.writeTag(v290, v291, 2, proto.wireTypes.lengthDelimited)
			local v295, v296 = proto.writeBuffer(v293, v294, v292, buffer.len(v292))
			local v297, v298 = proto.writeTag(buf, n1, 17, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v297, v298, v295, v296)
		end
	end

	if p1.universe_user_vote ~= nil and next(p1.universe_user_vote) ~= nil then
		for v299, v300 in p1.universe_user_vote do
			local buf19 = buffer.create(0)
			local v302, v303 = proto.writeTag(buf19, 0, 1, proto.wireTypes.lengthDelimited)
			local v304, v305 = proto.writeString(v302, v303, v299)
			local v306 = v300:encode()
			local v307, v308 = proto.writeTag(v304, v305, 2, proto.wireTypes.lengthDelimited)
			local v309, v310 = proto.writeBuffer(v307, v308, v306, buffer.len(v306))
			local v311, v312 = proto.writeTag(buf, n1, 18, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v311, v312, v309, v310)
		end
	end

	if p1.user_profile ~= nil and next(p1.user_profile) ~= nil then
		for v313, v314 in p1.user_profile do
			local buf20 = buffer.create(0)
			local v316, v317 = proto.writeTag(buf20, 0, 1, proto.wireTypes.lengthDelimited)
			local v318, v319 = proto.writeString(v316, v317, v313)
			local v320 = v314:encode()
			local v321, v322 = proto.writeTag(v318, v319, 2, proto.wireTypes.lengthDelimited)
			local v323, v324 = proto.writeBuffer(v321, v322, v320, buffer.len(v320))
			local v325, v326 = proto.writeTag(buf, n1, 19, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v325, v326, v323, v324)
		end
	end

	if p1.universe_user_favorite ~= nil and next(p1.universe_user_favorite) ~= nil then
		for v327, v328 in p1.universe_user_favorite do
			local buf21 = buffer.create(0)
			local v330, v331 = proto.writeTag(buf21, 0, 1, proto.wireTypes.lengthDelimited)
			local v332, v333 = proto.writeString(v330, v331, v327)
			local v334 = v328:encode()
			local v335, v336 = proto.writeTag(v332, v333, 2, proto.wireTypes.lengthDelimited)
			local v337, v338 = proto.writeBuffer(v335, v336, v334, buffer.len(v334))
			local v339, v340 = proto.writeTag(buf, n1, 20, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v339, v340, v337, v338)
		end
	end

	if p1.playability ~= nil and next(p1.playability) ~= nil then
		for v341, v342 in p1.playability do
			local buf22 = buffer.create(0)
			local v344, v345 = proto.writeTag(buf22, 0, 1, proto.wireTypes.lengthDelimited)
			local v346, v347 = proto.writeString(v344, v345, v341)
			local v348 = v342:encode()
			local v349, v350 = proto.writeTag(v346, v347, 2, proto.wireTypes.lengthDelimited)
			local v351, v352 = proto.writeBuffer(v349, v350, v348, buffer.len(v348))
			local v353, v354 = proto.writeTag(buf, n1, 21, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v353, v354, v351, v352)
		end
	end

	if p1.universe_user_follow_limit ~= nil and next(p1.universe_user_follow_limit) ~= nil then
		for v355, v356 in p1.universe_user_follow_limit do
			local buf23 = buffer.create(0)
			local v358, v359 = proto.writeTag(buf23, 0, 1, proto.wireTypes.lengthDelimited)
			local v360, v361 = proto.writeString(v358, v359, v355)
			local v362 = v356:encode()
			local v363, v364 = proto.writeTag(v360, v361, 2, proto.wireTypes.lengthDelimited)
			local v365, v366 = proto.writeBuffer(v363, v364, v362, buffer.len(v362))
			local v367, v368 = proto.writeTag(buf, n1, 22, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v367, v368, v365, v366)
		end
	end

	if p1.universe_user_vote_feedback_metadata ~= nil and next(p1.universe_user_vote_feedback_metadata) ~= nil then
		for v369, v370 in p1.universe_user_vote_feedback_metadata do
			local buf24 = buffer.create(0)
			local v372, v373 = proto.writeTag(buf24, 0, 1, proto.wireTypes.lengthDelimited)
			local v374, v375 = proto.writeString(v372, v373, v369)
			local v376 = v370:encode()
			local v377, v378 = proto.writeTag(v374, v375, 2, proto.wireTypes.lengthDelimited)
			local v379, v380 = proto.writeBuffer(v377, v378, v376, buffer.len(v376))
			local v381, v382 = proto.writeTag(buf, n1, 23, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v381, v382, v379, v380)
		end
	end

	if p1.moment ~= nil and next(p1.moment) ~= nil then
		for v383, v384 in p1.moment do
			local buf25 = buffer.create(0)
			local v386, v387 = proto.writeTag(buf25, 0, 1, proto.wireTypes.lengthDelimited)
			local v388, v389 = proto.writeString(v386, v387, v383)
			local v390 = v384:encode()
			local v391, v392 = proto.writeTag(v388, v389, 2, proto.wireTypes.lengthDelimited)
			local v393, v394 = proto.writeBuffer(v391, v392, v390, buffer.len(v390))
			local v395, v396 = proto.writeTag(buf, n1, 24, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v395, v396, v393, v394)
		end
	end

	if p1.community ~= nil and next(p1.community) ~= nil then
		for v397, v398 in p1.community do
			local buf26 = buffer.create(0)
			local v400, v401 = proto.writeTag(buf26, 0, 1, proto.wireTypes.lengthDelimited)
			local v402, v403 = proto.writeString(v400, v401, v397)
			local v404 = v398:encode()
			local v405, v406 = proto.writeTag(v402, v403, 2, proto.wireTypes.lengthDelimited)
			local v407, v408 = proto.writeBuffer(v405, v406, v404, buffer.len(v404))
			local v409, v410 = proto.writeTag(buf, n1, 25, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v409, v410, v407, v408)
		end
	end

	if p1.community_user_membership ~= nil and next(p1.community_user_membership) ~= nil then
		for v411, v412 in p1.community_user_membership do
			local buf27 = buffer.create(0)
			local v414, v415 = proto.writeTag(buf27, 0, 1, proto.wireTypes.lengthDelimited)
			local v416, v417 = proto.writeString(v414, v415, v411)
			local v418 = v412:encode()
			local v419, v420 = proto.writeTag(v416, v417, 2, proto.wireTypes.lengthDelimited)
			local v421, v422 = proto.writeBuffer(v419, v420, v418, buffer.len(v418))
			local v423, v424 = proto.writeTag(buf, n1, 26, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v423, v424, v421, v422)
		end
	end

	local buf28 = buffer.create(n1)

	buffer.copy(buf28, 0, buf, 0, n1)

	return buf28
end
function t2.decode(p2: buffer) -- line: 1389
	-- upvalues: t2 (copy), proto (copy), t1 (copy), badge_data (copy), universe_data (copy), creator_data (copy), event_data (copy), song_data (copy), game_pass_data (copy), media_asset_data (copy), social_link_data (copy), game_developer_product_data (copy), game_subscription_data (copy), marketplace_catalog_category_data (copy), marketplace_asset_data (copy), marketplace_bundle_data (copy), marketplace_look_data (copy), catalog_sort_data (copy), age_recommendation_data (copy), universe_user_follow_data (copy), universe_user_vote_data (copy), user_profile_data (copy), universe_user_favorite_data (copy), playability_data (copy), universe_user_follow_limit_data (copy), universe_user_vote_feedback_metadata_data (copy), moment_data (copy), community_data (copy), community_user_membership_data (copy)
	local v427 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v429, v430

		v429, v430, n2 = proto.readTag(p2, n2)

		if v430 == proto.wireTypes.varint then
			local v431

			v431, n2 = proto.readVarInt(p2, n2)
		elseif v430 == proto.wireTypes.lengthDelimited then
			if v429 == 1 then
				local v432

				v432, n2 = proto.readBuffer(p2, n2)

				local v433 = t1.HydrationContent_BadgeEntry.decode(v432)
				local v434 = badge_data.BadgeData.new()

				v427.badge[v433.key or ""] = v433.value or v434
			elseif v429 == 2 then
				local v435

				v435, n2 = proto.readBuffer(p2, n2)

				local v436 = t1.HydrationContent_UniverseEntry.decode(v435)
				local v437 = universe_data.UniverseData.new()

				v427.universe[v436.key or ""] = v436.value or v437
			elseif v429 == 3 then
				local v438

				v438, n2 = proto.readBuffer(p2, n2)

				local v439 = t1.HydrationContent_CreatorEntry.decode(v438)
				local v440 = creator_data.CreatorData.new()

				v427.creator[v439.key or ""] = v439.value or v440
			elseif v429 == 4 then
				local v441

				v441, n2 = proto.readBuffer(p2, n2)

				local v442 = t1.HydrationContent_EventEntry.decode(v441)
				local v443 = event_data.EventData.new()

				v427.event[v442.key or ""] = v442.value or v443
			elseif v429 == 5 then
				local v444

				v444, n2 = proto.readBuffer(p2, n2)

				local v445 = t1.HydrationContent_SongEntry.decode(v444)
				local v446 = song_data.SongData.new()

				v427.song[v445.key or ""] = v445.value or v446
			elseif v429 == 6 then
				local v447

				v447, n2 = proto.readBuffer(p2, n2)

				local v448 = t1.HydrationContent_GamePassEntry.decode(v447)
				local v449 = game_pass_data.GamePassData.new()

				v427.game_pass[v448.key or ""] = v448.value or v449
			elseif v429 == 7 then
				local v450

				v450, n2 = proto.readBuffer(p2, n2)

				local v451 = t1.HydrationContent_MediaAssetEntry.decode(v450)
				local v452 = media_asset_data.MediaAssetData.new()

				v427.media_asset[v451.key or ""] = v451.value or v452
			elseif v429 == 8 then
				local v453

				v453, n2 = proto.readBuffer(p2, n2)

				local v454 = t1.HydrationContent_SocialLinkEntry.decode(v453)
				local v455 = social_link_data.SocialLinkData.new()

				v427.social_link[v454.key or ""] = v454.value or v455
			elseif v429 == 9 then
				local v456

				v456, n2 = proto.readBuffer(p2, n2)

				local v457 = t1.HydrationContent_GameDeveloperProductEntry.decode(v456)
				local v458 = game_developer_product_data.GameDeveloperProductData.new()

				v427.game_developer_product[v457.key or ""] = v457.value or v458
			elseif v429 == 10 then
				local v459

				v459, n2 = proto.readBuffer(p2, n2)

				local v460 = t1.HydrationContent_GameSubscriptionEntry.decode(v459)
				local v461 = game_subscription_data.GameSubscriptionData.new()

				v427.game_subscription[v460.key or ""] = v460.value or v461
			elseif v429 == 11 then
				local v462

				v462, n2 = proto.readBuffer(p2, n2)

				local v463 = t1.HydrationContent_MarketplaceCatalogCategoryEntry.decode(v462)
				local v464 = marketplace_catalog_category_data.MarketplaceCatalogCategoryData.new()

				v427.marketplace_catalog_category[v463.key or ""] = v463.value or v464
			elseif v429 == 12 then
				local v465

				v465, n2 = proto.readBuffer(p2, n2)

				local v466 = t1.HydrationContent_MarketplaceAssetEntry.decode(v465)
				local v467 = marketplace_asset_data.MarketplaceAssetData.new()

				v427.marketplace_asset[v466.key or ""] = v466.value or v467
			elseif v429 == 13 then
				local v468

				v468, n2 = proto.readBuffer(p2, n2)

				local v469 = t1.HydrationContent_MarketplaceBundleEntry.decode(v468)
				local v470 = marketplace_bundle_data.MarketplaceBundleData.new()

				v427.marketplace_bundle[v469.key or ""] = v469.value or v470
			elseif v429 == 14 then
				local v471

				v471, n2 = proto.readBuffer(p2, n2)

				local v472 = t1.HydrationContent_MarketplaceLookEntry.decode(v471)
				local v473 = marketplace_look_data.MarketplaceLookData.new()

				v427.marketplace_look[v472.key or ""] = v472.value or v473
			elseif v429 == 15 then
				local v474

				v474, n2 = proto.readBuffer(p2, n2)

				local v475 = t1.HydrationContent_CatalogSortEntry.decode(v474)
				local v476 = catalog_sort_data.CatalogSortData.new()

				v427.catalog_sort[v475.key or ""] = v475.value or v476
			elseif v429 == 16 then
				local v477

				v477, n2 = proto.readBuffer(p2, n2)

				local v478 = t1.HydrationContent_AgeRecommendationEntry.decode(v477)
				local v479 = age_recommendation_data.AgeRecommendationData.new()

				v427.age_recommendation[v478.key or ""] = v478.value or v479
			elseif v429 == 17 then
				local v480

				v480, n2 = proto.readBuffer(p2, n2)

				local v481 = t1.HydrationContent_UniverseUserFollowEntry.decode(v480)
				local v482 = universe_user_follow_data.UniverseUserFollowData.new()

				v427.universe_user_follow[v481.key or ""] = v481.value or v482
			elseif v429 == 18 then
				local v483

				v483, n2 = proto.readBuffer(p2, n2)

				local v484 = t1.HydrationContent_UniverseUserVoteEntry.decode(v483)
				local v485 = universe_user_vote_data.UniverseUserVoteData.new()

				v427.universe_user_vote[v484.key or ""] = v484.value or v485
			elseif v429 == 19 then
				local v486

				v486, n2 = proto.readBuffer(p2, n2)

				local v487 = t1.HydrationContent_UserProfileEntry.decode(v486)
				local v488 = user_profile_data.UserProfileData.new()

				v427.user_profile[v487.key or ""] = v487.value or v488
			elseif v429 == 20 then
				local v489

				v489, n2 = proto.readBuffer(p2, n2)

				local v490 = t1.HydrationContent_UniverseUserFavoriteEntry.decode(v489)
				local v491 = universe_user_favorite_data.UniverseUserFavoriteData.new()

				v427.universe_user_favorite[v490.key or ""] = v490.value or v491
			elseif v429 == 21 then
				local v492

				v492, n2 = proto.readBuffer(p2, n2)

				local v493 = t1.HydrationContent_PlayabilityEntry.decode(v492)
				local v494 = playability_data.PlayabilityData.new()

				v427.playability[v493.key or ""] = v493.value or v494
			elseif v429 == 22 then
				local v495

				v495, n2 = proto.readBuffer(p2, n2)

				local v496 = t1.HydrationContent_UniverseUserFollowLimitEntry.decode(v495)
				local v497 = universe_user_follow_limit_data.UniverseUserFollowLimitData.new()

				v427.universe_user_follow_limit[v496.key or ""] = v496.value or v497
			elseif v429 == 23 then
				local v498

				v498, n2 = proto.readBuffer(p2, n2)

				local v499 = t1.HydrationContent_UniverseUserVoteFeedbackMetadataEntry.decode(v498)
				local v500 = universe_user_vote_feedback_metadata_data.UniverseUserVoteFeedbackMetadataData.new()

				v427.universe_user_vote_feedback_metadata[v499.key or ""] = v499.value or v500
			elseif v429 == 24 then
				local v501

				v501, n2 = proto.readBuffer(p2, n2)

				local v502 = t1.HydrationContent_MomentEntry.decode(v501)
				local v503 = moment_data.MomentData.new()

				v427.moment[v502.key or ""] = v502.value or v503
			elseif v429 == 25 then
				local v504

				v504, n2 = proto.readBuffer(p2, n2)

				local v505 = t1.HydrationContent_CommunityEntry.decode(v504)
				local v506 = community_data.CommunityData.new()

				v427.community[v505.key or ""] = v505.value or v506
			elseif v429 == 26 then
				local v507

				v507, n2 = proto.readBuffer(p2, n2)

				local v508 = t1.HydrationContent_CommunityUserMembershipEntry.decode(v507)
				local v509 = community_user_membership_data.CommunityUserMembershipData.new()

				v427.community_user_membership[v508.key or ""] = v508.value or v509
			else
				local v510, v511 = proto.readVarInt(p2, n2)

				n2 = v511 + v510
			end
		elseif v430 == proto.wireTypes.i32 then
			local v512

			v512, n2 = proto.readFixed32(p2, n2)
		elseif v430 == proto.wireTypes.i64 then
			local v513

			v513, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v430)
		end
	end

	return v427
end
function t2.jsonEncode(p3) -- line: 1753
	local t4 = {}

	if p3.badge ~= nil and next(p3.badge) ~= nil then
		local t5 = {}

		for v517, v518 in p3.badge do
			t5[v517] = v518:jsonEncode()
		end

		t4.badge = t5
	end

	if p3.universe ~= nil and next(p3.universe) ~= nil then
		local t6 = {}

		for v520, v521 in p3.universe do
			t6[v520] = v521:jsonEncode()
		end

		t4.universe = t6
	end

	if p3.creator ~= nil and next(p3.creator) ~= nil then
		local t7 = {}

		for v523, v524 in p3.creator do
			t7[v523] = v524:jsonEncode()
		end

		t4.creator = t7
	end

	if p3.event ~= nil and next(p3.event) ~= nil then
		local t8 = {}

		for v526, v527 in p3.event do
			t8[v526] = v527:jsonEncode()
		end

		t4.event = t8
	end

	if p3.song ~= nil and next(p3.song) ~= nil then
		local t9 = {}

		for v529, v530 in p3.song do
			t9[v529] = v530:jsonEncode()
		end

		t4.song = t9
	end

	if p3.game_pass ~= nil and next(p3.game_pass) ~= nil then
		local t10 = {}

		for v532, v533 in p3.game_pass do
			t10[v532] = v533:jsonEncode()
		end

		t4.gamePass = t10
	end

	if p3.media_asset ~= nil and next(p3.media_asset) ~= nil then
		local t11 = {}

		for v535, v536 in p3.media_asset do
			t11[v535] = v536:jsonEncode()
		end

		t4.mediaAsset = t11
	end

	if p3.social_link ~= nil and next(p3.social_link) ~= nil then
		local t12 = {}

		for v538, v539 in p3.social_link do
			t12[v538] = v539:jsonEncode()
		end

		t4.socialLink = t12
	end

	if p3.game_developer_product ~= nil and next(p3.game_developer_product) ~= nil then
		local t13 = {}

		for v541, v542 in p3.game_developer_product do
			t13[v541] = v542:jsonEncode()
		end

		t4.gameDeveloperProduct = t13
	end

	if p3.game_subscription ~= nil and next(p3.game_subscription) ~= nil then
		local t14 = {}

		for v544, v545 in p3.game_subscription do
			t14[v544] = v545:jsonEncode()
		end

		t4.gameSubscription = t14
	end

	if p3.marketplace_catalog_category ~= nil and next(p3.marketplace_catalog_category) ~= nil then
		local t15 = {}

		for v547, v548 in p3.marketplace_catalog_category do
			t15[v547] = v548:jsonEncode()
		end

		t4.marketplaceCatalogCategory = t15
	end

	if p3.marketplace_asset ~= nil and next(p3.marketplace_asset) ~= nil then
		local t16 = {}

		for v550, v551 in p3.marketplace_asset do
			t16[v550] = v551:jsonEncode()
		end

		t4.marketplaceAsset = t16
	end

	if p3.marketplace_bundle ~= nil and next(p3.marketplace_bundle) ~= nil then
		local t17 = {}

		for v553, v554 in p3.marketplace_bundle do
			t17[v553] = v554:jsonEncode()
		end

		t4.marketplaceBundle = t17
	end

	if p3.marketplace_look ~= nil and next(p3.marketplace_look) ~= nil then
		local t18 = {}

		for v556, v557 in p3.marketplace_look do
			t18[v556] = v557:jsonEncode()
		end

		t4.marketplaceLook = t18
	end

	if p3.catalog_sort ~= nil and next(p3.catalog_sort) ~= nil then
		local t19 = {}

		for v559, v560 in p3.catalog_sort do
			t19[v559] = v560:jsonEncode()
		end

		t4.catalogSort = t19
	end

	if p3.age_recommendation ~= nil and next(p3.age_recommendation) ~= nil then
		local t20 = {}

		for v562, v563 in p3.age_recommendation do
			t20[v562] = v563:jsonEncode()
		end

		t4.ageRecommendation = t20
	end

	if p3.universe_user_follow ~= nil and next(p3.universe_user_follow) ~= nil then
		local t21 = {}

		for v565, v566 in p3.universe_user_follow do
			t21[v565] = v566:jsonEncode()
		end

		t4.universeUserFollow = t21
	end

	if p3.universe_user_vote ~= nil and next(p3.universe_user_vote) ~= nil then
		local t22 = {}

		for v568, v569 in p3.universe_user_vote do
			t22[v568] = v569:jsonEncode()
		end

		t4.universeUserVote = t22
	end

	if p3.user_profile ~= nil and next(p3.user_profile) ~= nil then
		local t23 = {}

		for v571, v572 in p3.user_profile do
			t23[v571] = v572:jsonEncode()
		end

		t4.userProfile = t23
	end

	if p3.universe_user_favorite ~= nil and next(p3.universe_user_favorite) ~= nil then
		local t24 = {}

		for v574, v575 in p3.universe_user_favorite do
			t24[v574] = v575:jsonEncode()
		end

		t4.universeUserFavorite = t24
	end

	if p3.playability ~= nil and next(p3.playability) ~= nil then
		local t25 = {}

		for v577, v578 in p3.playability do
			t25[v577] = v578:jsonEncode()
		end

		t4.playability = t25
	end

	if p3.universe_user_follow_limit ~= nil and next(p3.universe_user_follow_limit) ~= nil then
		local t26 = {}

		for v580, v581 in p3.universe_user_follow_limit do
			t26[v580] = v581:jsonEncode()
		end

		t4.universeUserFollowLimit = t26
	end

	if p3.universe_user_vote_feedback_metadata ~= nil and next(p3.universe_user_vote_feedback_metadata) ~= nil then
		local t27 = {}

		for v583, v584 in p3.universe_user_vote_feedback_metadata do
			t27[v583] = v584:jsonEncode()
		end

		t4.universeUserVoteFeedbackMetadata = t27
	end

	if p3.moment ~= nil and next(p3.moment) ~= nil then
		local t28 = {}

		for v586, v587 in p3.moment do
			t28[v586] = v587:jsonEncode()
		end

		t4.moment = t28
	end

	if p3.community ~= nil and next(p3.community) ~= nil then
		local t29 = {}

		for v589, v590 in p3.community do
			t29[v589] = v590:jsonEncode()
		end

		t4.community = t29
	end

	if p3.community_user_membership ~= nil and next(p3.community_user_membership) ~= nil then
		local t30 = {}

		for v592, v593 in p3.community_user_membership do
			t30[v592] = v593:jsonEncode()
		end

		t4.communityUserMembership = t30
	end

	return t4
end
function t2.jsonDecode(t31: {[any]: any}) -- line: 1970
	-- upvalues: t2 (copy), badge_data (copy), universe_data (copy), creator_data (copy), event_data (copy), song_data (copy), game_pass_data (copy), media_asset_data (copy), social_link_data (copy), game_developer_product_data (copy), game_subscription_data (copy), marketplace_catalog_category_data (copy), marketplace_asset_data (copy), marketplace_bundle_data (copy), marketplace_look_data (copy), catalog_sort_data (copy), age_recommendation_data (copy), universe_user_follow_data (copy), universe_user_vote_data (copy), user_profile_data (copy), universe_user_favorite_data (copy), playability_data (copy), universe_user_follow_limit_data (copy), universe_user_vote_feedback_metadata_data (copy), moment_data (copy), community_data (copy), community_user_membership_data (copy)
	local v595 = t2.new()

	if t31.badge ~= nil then
		local t32 = {}

		for v597, v598 in t31.badge do
			t32[v597] = badge_data.BadgeData.jsonDecode(v598)
		end

		v595.badge = t32
	end

	if t31.universe ~= nil then
		local t33 = {}

		for v600, v601 in t31.universe do
			t33[v600] = universe_data.UniverseData.jsonDecode(v601)
		end

		v595.universe = t33
	end

	if t31.creator ~= nil then
		local t34 = {}

		for v603, v604 in t31.creator do
			t34[v603] = creator_data.CreatorData.jsonDecode(v604)
		end

		v595.creator = t34
	end

	if t31.event ~= nil then
		local t35 = {}

		for v606, v607 in t31.event do
			t35[v606] = event_data.EventData.jsonDecode(v607)
		end

		v595.event = t35
	end

	if t31.song ~= nil then
		local t36 = {}

		for v609, v610 in t31.song do
			t36[v609] = song_data.SongData.jsonDecode(v610)
		end

		v595.song = t36
	end

	if t31.game_pass ~= nil then
		local t37 = {}

		for v612, v613 in t31.game_pass do
			t37[v612] = game_pass_data.GamePassData.jsonDecode(v613)
		end

		v595.game_pass = t37
	end

	if t31.gamePass ~= nil then
		local t38 = {}

		for v615, v616 in t31.gamePass do
			t38[v615] = game_pass_data.GamePassData.jsonDecode(v616)
		end

		v595.game_pass = t38
	end

	if t31.media_asset ~= nil then
		local t39 = {}

		for v618, v619 in t31.media_asset do
			t39[v618] = media_asset_data.MediaAssetData.jsonDecode(v619)
		end

		v595.media_asset = t39
	end

	if t31.mediaAsset ~= nil then
		local t40 = {}

		for v621, v622 in t31.mediaAsset do
			t40[v621] = media_asset_data.MediaAssetData.jsonDecode(v622)
		end

		v595.media_asset = t40
	end

	if t31.social_link ~= nil then
		local t41 = {}

		for v624, v625 in t31.social_link do
			t41[v624] = social_link_data.SocialLinkData.jsonDecode(v625)
		end

		v595.social_link = t41
	end

	if t31.socialLink ~= nil then
		local t42 = {}

		for v627, v628 in t31.socialLink do
			t42[v627] = social_link_data.SocialLinkData.jsonDecode(v628)
		end

		v595.social_link = t42
	end

	if t31.game_developer_product ~= nil then
		local t43 = {}

		for v630, v631 in t31.game_developer_product do
			t43[v630] = game_developer_product_data.GameDeveloperProductData.jsonDecode(v631)
		end

		v595.game_developer_product = t43
	end

	if t31.gameDeveloperProduct ~= nil then
		local t44 = {}

		for v633, v634 in t31.gameDeveloperProduct do
			t44[v633] = game_developer_product_data.GameDeveloperProductData.jsonDecode(v634)
		end

		v595.game_developer_product = t44
	end

	if t31.game_subscription ~= nil then
		local t45 = {}

		for v636, v637 in t31.game_subscription do
			t45[v636] = game_subscription_data.GameSubscriptionData.jsonDecode(v637)
		end

		v595.game_subscription = t45
	end

	if t31.gameSubscription ~= nil then
		local t46 = {}

		for v639, v640 in t31.gameSubscription do
			t46[v639] = game_subscription_data.GameSubscriptionData.jsonDecode(v640)
		end

		v595.game_subscription = t46
	end

	if t31.marketplace_catalog_category ~= nil then
		local t47 = {}

		for v642, v643 in t31.marketplace_catalog_category do
			t47[v642] = marketplace_catalog_category_data.MarketplaceCatalogCategoryData.jsonDecode(v643)
		end

		v595.marketplace_catalog_category = t47
	end

	if t31.marketplaceCatalogCategory ~= nil then
		local t48 = {}

		for v645, v646 in t31.marketplaceCatalogCategory do
			t48[v645] = marketplace_catalog_category_data.MarketplaceCatalogCategoryData.jsonDecode(v646)
		end

		v595.marketplace_catalog_category = t48
	end

	if t31.marketplace_asset ~= nil then
		local t49 = {}

		for v648, v649 in t31.marketplace_asset do
			t49[v648] = marketplace_asset_data.MarketplaceAssetData.jsonDecode(v649)
		end

		v595.marketplace_asset = t49
	end

	if t31.marketplaceAsset ~= nil then
		local t50 = {}

		for v651, v652 in t31.marketplaceAsset do
			t50[v651] = marketplace_asset_data.MarketplaceAssetData.jsonDecode(v652)
		end

		v595.marketplace_asset = t50
	end

	if t31.marketplace_bundle ~= nil then
		local t51 = {}

		for v654, v655 in t31.marketplace_bundle do
			t51[v654] = marketplace_bundle_data.MarketplaceBundleData.jsonDecode(v655)
		end

		v595.marketplace_bundle = t51
	end

	if t31.marketplaceBundle ~= nil then
		local t52 = {}

		for v657, v658 in t31.marketplaceBundle do
			t52[v657] = marketplace_bundle_data.MarketplaceBundleData.jsonDecode(v658)
		end

		v595.marketplace_bundle = t52
	end

	if t31.marketplace_look ~= nil then
		local t53 = {}

		for v660, v661 in t31.marketplace_look do
			t53[v660] = marketplace_look_data.MarketplaceLookData.jsonDecode(v661)
		end

		v595.marketplace_look = t53
	end

	if t31.marketplaceLook ~= nil then
		local t54 = {}

		for v663, v664 in t31.marketplaceLook do
			t54[v663] = marketplace_look_data.MarketplaceLookData.jsonDecode(v664)
		end

		v595.marketplace_look = t54
	end

	if t31.catalog_sort ~= nil then
		local t55 = {}

		for v666, v667 in t31.catalog_sort do
			t55[v666] = catalog_sort_data.CatalogSortData.jsonDecode(v667)
		end

		v595.catalog_sort = t55
	end

	if t31.catalogSort ~= nil then
		local t56 = {}

		for v669, v670 in t31.catalogSort do
			t56[v669] = catalog_sort_data.CatalogSortData.jsonDecode(v670)
		end

		v595.catalog_sort = t56
	end

	if t31.age_recommendation ~= nil then
		local t57 = {}

		for v672, v673 in t31.age_recommendation do
			t57[v672] = age_recommendation_data.AgeRecommendationData.jsonDecode(v673)
		end

		v595.age_recommendation = t57
	end

	if t31.ageRecommendation ~= nil then
		local t58 = {}

		for v675, v676 in t31.ageRecommendation do
			t58[v675] = age_recommendation_data.AgeRecommendationData.jsonDecode(v676)
		end

		v595.age_recommendation = t58
	end

	if t31.universe_user_follow ~= nil then
		local t59 = {}

		for v678, v679 in t31.universe_user_follow do
			t59[v678] = universe_user_follow_data.UniverseUserFollowData.jsonDecode(v679)
		end

		v595.universe_user_follow = t59
	end

	if t31.universeUserFollow ~= nil then
		local t60 = {}

		for v681, v682 in t31.universeUserFollow do
			t60[v681] = universe_user_follow_data.UniverseUserFollowData.jsonDecode(v682)
		end

		v595.universe_user_follow = t60
	end

	if t31.universe_user_vote ~= nil then
		local t61 = {}

		for v684, v685 in t31.universe_user_vote do
			t61[v684] = universe_user_vote_data.UniverseUserVoteData.jsonDecode(v685)
		end

		v595.universe_user_vote = t61
	end

	if t31.universeUserVote ~= nil then
		local t62 = {}

		for v687, v688 in t31.universeUserVote do
			t62[v687] = universe_user_vote_data.UniverseUserVoteData.jsonDecode(v688)
		end

		v595.universe_user_vote = t62
	end

	if t31.user_profile ~= nil then
		local t63 = {}

		for v690, v691 in t31.user_profile do
			t63[v690] = user_profile_data.UserProfileData.jsonDecode(v691)
		end

		v595.user_profile = t63
	end

	if t31.userProfile ~= nil then
		local t64 = {}

		for v693, v694 in t31.userProfile do
			t64[v693] = user_profile_data.UserProfileData.jsonDecode(v694)
		end

		v595.user_profile = t64
	end

	if t31.universe_user_favorite ~= nil then
		local t65 = {}

		for v696, v697 in t31.universe_user_favorite do
			t65[v696] = universe_user_favorite_data.UniverseUserFavoriteData.jsonDecode(v697)
		end

		v595.universe_user_favorite = t65
	end

	if t31.universeUserFavorite ~= nil then
		local t66 = {}

		for v699, v700 in t31.universeUserFavorite do
			t66[v699] = universe_user_favorite_data.UniverseUserFavoriteData.jsonDecode(v700)
		end

		v595.universe_user_favorite = t66
	end

	if t31.playability ~= nil then
		local t67 = {}

		for v702, v703 in t31.playability do
			t67[v702] = playability_data.PlayabilityData.jsonDecode(v703)
		end

		v595.playability = t67
	end

	if t31.universe_user_follow_limit ~= nil then
		local t68 = {}

		for v705, v706 in t31.universe_user_follow_limit do
			t68[v705] = universe_user_follow_limit_data.UniverseUserFollowLimitData.jsonDecode(v706)
		end

		v595.universe_user_follow_limit = t68
	end

	if t31.universeUserFollowLimit ~= nil then
		local t69 = {}

		for v708, v709 in t31.universeUserFollowLimit do
			t69[v708] = universe_user_follow_limit_data.UniverseUserFollowLimitData.jsonDecode(v709)
		end

		v595.universe_user_follow_limit = t69
	end

	if t31.universe_user_vote_feedback_metadata ~= nil then
		local t70 = {}

		for v711, v712 in t31.universe_user_vote_feedback_metadata do
			t70[v711] = universe_user_vote_feedback_metadata_data.UniverseUserVoteFeedbackMetadataData.jsonDecode(v712)
		end

		v595.universe_user_vote_feedback_metadata = t70
	end

	if t31.universeUserVoteFeedbackMetadata ~= nil then
		local t71 = {}

		for v714, v715 in t31.universeUserVoteFeedbackMetadata do
			t71[v714] = universe_user_vote_feedback_metadata_data.UniverseUserVoteFeedbackMetadataData.jsonDecode(v715)
		end

		v595.universe_user_vote_feedback_metadata = t71
	end

	if t31.moment ~= nil then
		local t72 = {}

		for v717, v718 in t31.moment do
			t72[v717] = moment_data.MomentData.jsonDecode(v718)
		end

		v595.moment = t72
	end

	if t31.community ~= nil then
		local t73 = {}

		for v720, v721 in t31.community do
			t73[v720] = community_data.CommunityData.jsonDecode(v721)
		end

		v595.community = t73
	end

	if t31.community_user_membership ~= nil then
		local t74 = {}

		for v723, v724 in t31.community_user_membership do
			t74[v723] = community_user_membership_data.CommunityUserMembershipData.jsonDecode(v724)
		end

		v595.community_user_membership = t74
	end

	if t31.communityUserMembership ~= nil then
		local t75 = {}

		for v726, v727 in t31.communityUserMembership do
			t75[v726] = community_user_membership_data.CommunityUserMembershipData.jsonDecode(v727)
		end

		v595.community_user_membership = t75
	end

	return v595
end

t2.descriptor = {
	name = "HydrationContent",
	fullName = "roblox.apppageplatform.shared.v1beta1.HydrationContent"
}
t1.HydrationContent = t2
typeRegistry.default:register(t1.HydrationContent)

local t76 = {}

t76.__index = t76

function t76.new(t77: {[any]: any}?) -- line: 2503
	-- upvalues: t76 (copy)
	return (setmetatable({
		key = if t77 ~= nil and t77.key ~= nil then t77.key else "",
		value = if t77 ~= nil and t77.value ~= nil then t77.value else nil
	}, t76))
end
function t76.encode(p4) -- line: 2512
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n3 = 0

	if p4.key ~= nil and p4.key ~= "" then
		local v732, v733 = proto.writeTag(buf, n3, 1, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeString(v732, v733, p4.key)
	end

	if p4.value ~= nil then
		local v734 = p4.value:encode()
		local v735, v736 = proto.writeTag(buf, n3, 2, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeBuffer(v735, v736, v734, buffer.len(v734))
	end

	local buf29 = buffer.create(n3)

	buffer.copy(buf29, 0, buf, 0, n3)

	return buf29
end
function t76.decode(p5: buffer) -- line: 2532
	-- upvalues: t76 (copy), proto (copy), badge_data (copy)
	local v739 = t76.new()
	local n4 = 0

	while n4 < buffer.len(p5) do
		local v741, v742

		v741, v742, n4 = proto.readTag(p5, n4)

		if v742 == proto.wireTypes.varint then
			local v743

			v743, n4 = proto.readVarInt(p5, n4)
		elseif v742 == proto.wireTypes.lengthDelimited then
			if v741 == 1 then
				local v744

				v744, n4 = proto.readBuffer(p5, n4)
				v739.key = buffer.tostring(v744)
			elseif v741 == 2 then
				local v745

				v745, n4 = proto.readBuffer(p5, n4)
				v739.value = badge_data.BadgeData.decode(v745)
			else
				local v746, v747 = proto.readVarInt(p5, n4)

				n4 = v747 + v746
			end
		elseif v742 == proto.wireTypes.i32 then
			local v748

			v748, n4 = proto.readFixed32(p5, n4)
		elseif v742 == proto.wireTypes.i64 then
			local v749

			v749, n4 = proto.readFixed64(p5, n4)
		else
			error("Unsupported wire type: " .. v742)
		end
	end

	return v739
end
function t76.jsonEncode(p6) -- line: 2580
	local t78 = {}

	if p6.key ~= nil and p6.key ~= "" then
		t78.key = p6.key
	end

	if p6.value ~= nil then
		t78.value = p6.value:jsonEncode()
	end

	return t78
end
function t76.jsonDecode(t79: {[any]: any}) -- line: 2594
	-- upvalues: t76 (copy), badge_data (copy)
	local v753 = t76.new()

	if t79.key ~= nil then
		v753.key = t79.key
	end

	if t79.value ~= nil then
		v753.value = badge_data.BadgeData.jsonDecode(t79.value)
	end

	return v753
end

t76.descriptor = {
	name = "HydrationContent_BadgeEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.BadgeEntry"
}
t1.HydrationContent_BadgeEntry = t76
typeRegistry.default:register(t1.HydrationContent_BadgeEntry)

local t80 = {}

t80.__index = t80

function t80.new(t81: {[any]: any}?) -- line: 2622
	-- upvalues: t80 (copy)
	return (setmetatable({
		key = if t81 ~= nil and t81.key ~= nil then t81.key else "",
		value = if t81 ~= nil and t81.value ~= nil then t81.value else nil
	}, t80))
end
function t80.encode(p7) -- line: 2631
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n5 = 0

	if p7.key ~= nil and p7.key ~= "" then
		local v758, v759 = proto.writeTag(buf, n5, 1, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeString(v758, v759, p7.key)
	end

	if p7.value ~= nil then
		local v760 = p7.value:encode()
		local v761, v762 = proto.writeTag(buf, n5, 2, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeBuffer(v761, v762, v760, buffer.len(v760))
	end

	local buf30 = buffer.create(n5)

	buffer.copy(buf30, 0, buf, 0, n5)

	return buf30
end
function t80.decode(p8: buffer) -- line: 2651
	-- upvalues: t80 (copy), proto (copy), universe_data (copy)
	local v765 = t80.new()
	local n6 = 0

	while n6 < buffer.len(p8) do
		local v767, v768

		v767, v768, n6 = proto.readTag(p8, n6)

		if v768 == proto.wireTypes.varint then
			local v769

			v769, n6 = proto.readVarInt(p8, n6)
		elseif v768 == proto.wireTypes.lengthDelimited then
			if v767 == 1 then
				local v770

				v770, n6 = proto.readBuffer(p8, n6)
				v765.key = buffer.tostring(v770)
			elseif v767 == 2 then
				local v771

				v771, n6 = proto.readBuffer(p8, n6)
				v765.value = universe_data.UniverseData.decode(v771)
			else
				local v772, v773 = proto.readVarInt(p8, n6)

				n6 = v773 + v772
			end
		elseif v768 == proto.wireTypes.i32 then
			local v774

			v774, n6 = proto.readFixed32(p8, n6)
		elseif v768 == proto.wireTypes.i64 then
			local v775

			v775, n6 = proto.readFixed64(p8, n6)
		else
			error("Unsupported wire type: " .. v768)
		end
	end

	return v765
end
function t80.jsonEncode(p9) -- line: 2699
	local t82 = {}

	if p9.key ~= nil and p9.key ~= "" then
		t82.key = p9.key
	end

	if p9.value ~= nil then
		t82.value = p9.value:jsonEncode()
	end

	return t82
end
function t80.jsonDecode(t83: {[any]: any}) -- line: 2713
	-- upvalues: t80 (copy), universe_data (copy)
	local v779 = t80.new()

	if t83.key ~= nil then
		v779.key = t83.key
	end

	if t83.value ~= nil then
		v779.value = universe_data.UniverseData.jsonDecode(t83.value)
	end

	return v779
end

t80.descriptor = {
	name = "HydrationContent_UniverseEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniverseEntry"
}
t1.HydrationContent_UniverseEntry = t80
typeRegistry.default:register(t1.HydrationContent_UniverseEntry)

local t84 = {}

t84.__index = t84

function t84.new(t85: {[any]: any}?) -- line: 2741
	-- upvalues: t84 (copy)
	return (setmetatable({
		key = if t85 ~= nil and t85.key ~= nil then t85.key else "",
		value = if t85 ~= nil and t85.value ~= nil then t85.value else nil
	}, t84))
end
function t84.encode(p10) -- line: 2750
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n7 = 0

	if p10.key ~= nil and p10.key ~= "" then
		local v784, v785 = proto.writeTag(buf, n7, 1, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeString(v784, v785, p10.key)
	end

	if p10.value ~= nil then
		local v786 = p10.value:encode()
		local v787, v788 = proto.writeTag(buf, n7, 2, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeBuffer(v787, v788, v786, buffer.len(v786))
	end

	local buf31 = buffer.create(n7)

	buffer.copy(buf31, 0, buf, 0, n7)

	return buf31
end
function t84.decode(p11: buffer) -- line: 2770
	-- upvalues: t84 (copy), proto (copy), creator_data (copy)
	local v791 = t84.new()
	local n8 = 0

	while n8 < buffer.len(p11) do
		local v793, v794

		v793, v794, n8 = proto.readTag(p11, n8)

		if v794 == proto.wireTypes.varint then
			local v795

			v795, n8 = proto.readVarInt(p11, n8)
		elseif v794 == proto.wireTypes.lengthDelimited then
			if v793 == 1 then
				local v796

				v796, n8 = proto.readBuffer(p11, n8)
				v791.key = buffer.tostring(v796)
			elseif v793 == 2 then
				local v797

				v797, n8 = proto.readBuffer(p11, n8)
				v791.value = creator_data.CreatorData.decode(v797)
			else
				local v798, v799 = proto.readVarInt(p11, n8)

				n8 = v799 + v798
			end
		elseif v794 == proto.wireTypes.i32 then
			local v800

			v800, n8 = proto.readFixed32(p11, n8)
		elseif v794 == proto.wireTypes.i64 then
			local v801

			v801, n8 = proto.readFixed64(p11, n8)
		else
			error("Unsupported wire type: " .. v794)
		end
	end

	return v791
end
function t84.jsonEncode(p12) -- line: 2818
	local t86 = {}

	if p12.key ~= nil and p12.key ~= "" then
		t86.key = p12.key
	end

	if p12.value ~= nil then
		t86.value = p12.value:jsonEncode()
	end

	return t86
end
function t84.jsonDecode(t87: {[any]: any}) -- line: 2832
	-- upvalues: t84 (copy), creator_data (copy)
	local v805 = t84.new()

	if t87.key ~= nil then
		v805.key = t87.key
	end

	if t87.value ~= nil then
		v805.value = creator_data.CreatorData.jsonDecode(t87.value)
	end

	return v805
end

t84.descriptor = {
	name = "HydrationContent_CreatorEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.CreatorEntry"
}
t1.HydrationContent_CreatorEntry = t84
typeRegistry.default:register(t1.HydrationContent_CreatorEntry)

local t88 = {}

t88.__index = t88

function t88.new(t89: {[any]: any}?) -- line: 2860
	-- upvalues: t88 (copy)
	return (setmetatable({
		key = if t89 ~= nil and t89.key ~= nil then t89.key else "",
		value = if t89 ~= nil and t89.value ~= nil then t89.value else nil
	}, t88))
end
function t88.encode(p13) -- line: 2869
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n9 = 0

	if p13.key ~= nil and p13.key ~= "" then
		local v810, v811 = proto.writeTag(buf, n9, 1, proto.wireTypes.lengthDelimited)

		buf, n9 = proto.writeString(v810, v811, p13.key)
	end

	if p13.value ~= nil then
		local v812 = p13.value:encode()
		local v813, v814 = proto.writeTag(buf, n9, 2, proto.wireTypes.lengthDelimited)

		buf, n9 = proto.writeBuffer(v813, v814, v812, buffer.len(v812))
	end

	local buf32 = buffer.create(n9)

	buffer.copy(buf32, 0, buf, 0, n9)

	return buf32
end
function t88.decode(p14: buffer) -- line: 2889
	-- upvalues: t88 (copy), proto (copy), event_data (copy)
	local v817 = t88.new()
	local n10 = 0

	while n10 < buffer.len(p14) do
		local v819, v820

		v819, v820, n10 = proto.readTag(p14, n10)

		if v820 == proto.wireTypes.varint then
			local v821

			v821, n10 = proto.readVarInt(p14, n10)
		elseif v820 == proto.wireTypes.lengthDelimited then
			if v819 == 1 then
				local v822

				v822, n10 = proto.readBuffer(p14, n10)
				v817.key = buffer.tostring(v822)
			elseif v819 == 2 then
				local v823

				v823, n10 = proto.readBuffer(p14, n10)
				v817.value = event_data.EventData.decode(v823)
			else
				local v824, v825 = proto.readVarInt(p14, n10)

				n10 = v825 + v824
			end
		elseif v820 == proto.wireTypes.i32 then
			local v826

			v826, n10 = proto.readFixed32(p14, n10)
		elseif v820 == proto.wireTypes.i64 then
			local v827

			v827, n10 = proto.readFixed64(p14, n10)
		else
			error("Unsupported wire type: " .. v820)
		end
	end

	return v817
end
function t88.jsonEncode(p15) -- line: 2937
	local t90 = {}

	if p15.key ~= nil and p15.key ~= "" then
		t90.key = p15.key
	end

	if p15.value ~= nil then
		t90.value = p15.value:jsonEncode()
	end

	return t90
end
function t88.jsonDecode(t91: {[any]: any}) -- line: 2951
	-- upvalues: t88 (copy), event_data (copy)
	local v831 = t88.new()

	if t91.key ~= nil then
		v831.key = t91.key
	end

	if t91.value ~= nil then
		v831.value = event_data.EventData.jsonDecode(t91.value)
	end

	return v831
end

t88.descriptor = {
	name = "HydrationContent_EventEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventEntry"
}
t1.HydrationContent_EventEntry = t88
typeRegistry.default:register(t1.HydrationContent_EventEntry)

local t92 = {}

t92.__index = t92

function t92.new(t93: {[any]: any}?) -- line: 2979
	-- upvalues: t92 (copy)
	return (setmetatable({
		key = if t93 ~= nil and t93.key ~= nil then t93.key else "",
		value = if t93 ~= nil and t93.value ~= nil then t93.value else nil
	}, t92))
end
function t92.encode(p16) -- line: 2988
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n11 = 0

	if p16.key ~= nil and p16.key ~= "" then
		local v836, v837 = proto.writeTag(buf, n11, 1, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeString(v836, v837, p16.key)
	end

	if p16.value ~= nil then
		local v838 = p16.value:encode()
		local v839, v840 = proto.writeTag(buf, n11, 2, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeBuffer(v839, v840, v838, buffer.len(v838))
	end

	local buf33 = buffer.create(n11)

	buffer.copy(buf33, 0, buf, 0, n11)

	return buf33
end
function t92.decode(p17: buffer) -- line: 3008
	-- upvalues: t92 (copy), proto (copy), song_data (copy)
	local v843 = t92.new()
	local n12 = 0

	while n12 < buffer.len(p17) do
		local v845, v846

		v845, v846, n12 = proto.readTag(p17, n12)

		if v846 == proto.wireTypes.varint then
			local v847

			v847, n12 = proto.readVarInt(p17, n12)
		elseif v846 == proto.wireTypes.lengthDelimited then
			if v845 == 1 then
				local v848

				v848, n12 = proto.readBuffer(p17, n12)
				v843.key = buffer.tostring(v848)
			elseif v845 == 2 then
				local v849

				v849, n12 = proto.readBuffer(p17, n12)
				v843.value = song_data.SongData.decode(v849)
			else
				local v850, v851 = proto.readVarInt(p17, n12)

				n12 = v851 + v850
			end
		elseif v846 == proto.wireTypes.i32 then
			local v852

			v852, n12 = proto.readFixed32(p17, n12)
		elseif v846 == proto.wireTypes.i64 then
			local v853

			v853, n12 = proto.readFixed64(p17, n12)
		else
			error("Unsupported wire type: " .. v846)
		end
	end

	return v843
end
function t92.jsonEncode(p18) -- line: 3056
	local t94 = {}

	if p18.key ~= nil and p18.key ~= "" then
		t94.key = p18.key
	end

	if p18.value ~= nil then
		t94.value = p18.value:jsonEncode()
	end

	return t94
end
function t92.jsonDecode(t95: {[any]: any}) -- line: 3070
	-- upvalues: t92 (copy), song_data (copy)
	local v857 = t92.new()

	if t95.key ~= nil then
		v857.key = t95.key
	end

	if t95.value ~= nil then
		v857.value = song_data.SongData.jsonDecode(t95.value)
	end

	return v857
end

t92.descriptor = {
	name = "HydrationContent_SongEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.SongEntry"
}
t1.HydrationContent_SongEntry = t92
typeRegistry.default:register(t1.HydrationContent_SongEntry)

local t96 = {}

t96.__index = t96

function t96.new(t97: {[any]: any}?) -- line: 3098
	-- upvalues: t96 (copy)
	return (setmetatable({
		key = if t97 ~= nil and t97.key ~= nil then t97.key else "",
		value = if t97 ~= nil and t97.value ~= nil then t97.value else nil
	}, t96))
end
function t96.encode(p19) -- line: 3107
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n13 = 0

	if p19.key ~= nil and p19.key ~= "" then
		local v862, v863 = proto.writeTag(buf, n13, 1, proto.wireTypes.lengthDelimited)

		buf, n13 = proto.writeString(v862, v863, p19.key)
	end

	if p19.value ~= nil then
		local v864 = p19.value:encode()
		local v865, v866 = proto.writeTag(buf, n13, 2, proto.wireTypes.lengthDelimited)

		buf, n13 = proto.writeBuffer(v865, v866, v864, buffer.len(v864))
	end

	local buf34 = buffer.create(n13)

	buffer.copy(buf34, 0, buf, 0, n13)

	return buf34
end
function t96.decode(p20: buffer) -- line: 3127
	-- upvalues: t96 (copy), proto (copy), game_pass_data (copy)
	local v869 = t96.new()
	local n14 = 0

	while n14 < buffer.len(p20) do
		local v871, v872

		v871, v872, n14 = proto.readTag(p20, n14)

		if v872 == proto.wireTypes.varint then
			local v873

			v873, n14 = proto.readVarInt(p20, n14)
		elseif v872 == proto.wireTypes.lengthDelimited then
			if v871 == 1 then
				local v874

				v874, n14 = proto.readBuffer(p20, n14)
				v869.key = buffer.tostring(v874)
			elseif v871 == 2 then
				local v875

				v875, n14 = proto.readBuffer(p20, n14)
				v869.value = game_pass_data.GamePassData.decode(v875)
			else
				local v876, v877 = proto.readVarInt(p20, n14)

				n14 = v877 + v876
			end
		elseif v872 == proto.wireTypes.i32 then
			local v878

			v878, n14 = proto.readFixed32(p20, n14)
		elseif v872 == proto.wireTypes.i64 then
			local v879

			v879, n14 = proto.readFixed64(p20, n14)
		else
			error("Unsupported wire type: " .. v872)
		end
	end

	return v869
end
function t96.jsonEncode(p21) -- line: 3175
	local t98 = {}

	if p21.key ~= nil and p21.key ~= "" then
		t98.key = p21.key
	end

	if p21.value ~= nil then
		t98.value = p21.value:jsonEncode()
	end

	return t98
end
function t96.jsonDecode(t99: {[any]: any}) -- line: 3189
	-- upvalues: t96 (copy), game_pass_data (copy)
	local v883 = t96.new()

	if t99.key ~= nil then
		v883.key = t99.key
	end

	if t99.value ~= nil then
		v883.value = game_pass_data.GamePassData.jsonDecode(t99.value)
	end

	return v883
end

t96.descriptor = {
	name = "HydrationContent_GamePassEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.GamePassEntry"
}
t1.HydrationContent_GamePassEntry = t96
typeRegistry.default:register(t1.HydrationContent_GamePassEntry)

local t100 = {}

t100.__index = t100

function t100.new(t101: {[any]: any}?) -- line: 3217
	-- upvalues: t100 (copy)
	return (setmetatable({
		key = if t101 ~= nil and t101.key ~= nil then t101.key else "",
		value = if t101 ~= nil and t101.value ~= nil then t101.value else nil
	}, t100))
end
function t100.encode(p22) -- line: 3226
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n15 = 0

	if p22.key ~= nil and p22.key ~= "" then
		local v888, v889 = proto.writeTag(buf, n15, 1, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeString(v888, v889, p22.key)
	end

	if p22.value ~= nil then
		local v890 = p22.value:encode()
		local v891, v892 = proto.writeTag(buf, n15, 2, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeBuffer(v891, v892, v890, buffer.len(v890))
	end

	local buf35 = buffer.create(n15)

	buffer.copy(buf35, 0, buf, 0, n15)

	return buf35
end
function t100.decode(p23: buffer) -- line: 3246
	-- upvalues: t100 (copy), proto (copy), media_asset_data (copy)
	local v895 = t100.new()
	local n16 = 0

	while n16 < buffer.len(p23) do
		local v897, v898

		v897, v898, n16 = proto.readTag(p23, n16)

		if v898 == proto.wireTypes.varint then
			local v899

			v899, n16 = proto.readVarInt(p23, n16)
		elseif v898 == proto.wireTypes.lengthDelimited then
			if v897 == 1 then
				local v900

				v900, n16 = proto.readBuffer(p23, n16)
				v895.key = buffer.tostring(v900)
			elseif v897 == 2 then
				local v901

				v901, n16 = proto.readBuffer(p23, n16)
				v895.value = media_asset_data.MediaAssetData.decode(v901)
			else
				local v902, v903 = proto.readVarInt(p23, n16)

				n16 = v903 + v902
			end
		elseif v898 == proto.wireTypes.i32 then
			local v904

			v904, n16 = proto.readFixed32(p23, n16)
		elseif v898 == proto.wireTypes.i64 then
			local v905

			v905, n16 = proto.readFixed64(p23, n16)
		else
			error("Unsupported wire type: " .. v898)
		end
	end

	return v895
end
function t100.jsonEncode(p24) -- line: 3294
	local t102 = {}

	if p24.key ~= nil and p24.key ~= "" then
		t102.key = p24.key
	end

	if p24.value ~= nil then
		t102.value = p24.value:jsonEncode()
	end

	return t102
end
function t100.jsonDecode(t103: {[any]: any}) -- line: 3308
	-- upvalues: t100 (copy), media_asset_data (copy)
	local v909 = t100.new()

	if t103.key ~= nil then
		v909.key = t103.key
	end

	if t103.value ~= nil then
		v909.value = media_asset_data.MediaAssetData.jsonDecode(t103.value)
	end

	return v909
end

t100.descriptor = {
	name = "HydrationContent_MediaAssetEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.MediaAssetEntry"
}
t1.HydrationContent_MediaAssetEntry = t100
typeRegistry.default:register(t1.HydrationContent_MediaAssetEntry)

local t104 = {}

t104.__index = t104

function t104.new(t105: {[any]: any}?) -- line: 3338
	-- upvalues: t104 (copy)
	return (setmetatable({
		key = if t105 ~= nil and t105.key ~= nil then t105.key else "",
		value = if t105 ~= nil and t105.value ~= nil then t105.value else nil
	}, t104))
end
function t104.encode(p25) -- line: 3347
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n17 = 0

	if p25.key ~= nil and p25.key ~= "" then
		local v914, v915 = proto.writeTag(buf, n17, 1, proto.wireTypes.lengthDelimited)

		buf, n17 = proto.writeString(v914, v915, p25.key)
	end

	if p25.value ~= nil then
		local v916 = p25.value:encode()
		local v917, v918 = proto.writeTag(buf, n17, 2, proto.wireTypes.lengthDelimited)

		buf, n17 = proto.writeBuffer(v917, v918, v916, buffer.len(v916))
	end

	local buf36 = buffer.create(n17)

	buffer.copy(buf36, 0, buf, 0, n17)

	return buf36
end
function t104.decode(p26: buffer) -- line: 3367
	-- upvalues: t104 (copy), proto (copy), social_link_data (copy)
	local v921 = t104.new()
	local n18 = 0

	while n18 < buffer.len(p26) do
		local v923, v924

		v923, v924, n18 = proto.readTag(p26, n18)

		if v924 == proto.wireTypes.varint then
			local v925

			v925, n18 = proto.readVarInt(p26, n18)
		elseif v924 == proto.wireTypes.lengthDelimited then
			if v923 == 1 then
				local v926

				v926, n18 = proto.readBuffer(p26, n18)
				v921.key = buffer.tostring(v926)
			elseif v923 == 2 then
				local v927

				v927, n18 = proto.readBuffer(p26, n18)
				v921.value = social_link_data.SocialLinkData.decode(v927)
			else
				local v928, v929 = proto.readVarInt(p26, n18)

				n18 = v929 + v928
			end
		elseif v924 == proto.wireTypes.i32 then
			local v930

			v930, n18 = proto.readFixed32(p26, n18)
		elseif v924 == proto.wireTypes.i64 then
			local v931

			v931, n18 = proto.readFixed64(p26, n18)
		else
			error("Unsupported wire type: " .. v924)
		end
	end

	return v921
end
function t104.jsonEncode(p27) -- line: 3415
	local t106 = {}

	if p27.key ~= nil and p27.key ~= "" then
		t106.key = p27.key
	end

	if p27.value ~= nil then
		t106.value = p27.value:jsonEncode()
	end

	return t106
end
function t104.jsonDecode(t107: {[any]: any}) -- line: 3429
	-- upvalues: t104 (copy), social_link_data (copy)
	local v935 = t104.new()

	if t107.key ~= nil then
		v935.key = t107.key
	end

	if t107.value ~= nil then
		v935.value = social_link_data.SocialLinkData.jsonDecode(t107.value)
	end

	return v935
end

t104.descriptor = {
	name = "HydrationContent_SocialLinkEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.SocialLinkEntry"
}
t1.HydrationContent_SocialLinkEntry = t104
typeRegistry.default:register(t1.HydrationContent_SocialLinkEntry)

local t108 = {}

t108.__index = t108

function t108.new(t109: {[any]: any}?) -- line: 3459
	-- upvalues: t108 (copy)
	return (setmetatable({
		key = if t109 ~= nil and t109.key ~= nil then t109.key else "",
		value = if t109 ~= nil and t109.value ~= nil then t109.value else nil
	}, t108))
end
function t108.encode(p28) -- line: 3468
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n19 = 0

	if p28.key ~= nil and p28.key ~= "" then
		local v940, v941 = proto.writeTag(buf, n19, 1, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeString(v940, v941, p28.key)
	end

	if p28.value ~= nil then
		local v942 = p28.value:encode()
		local v943, v944 = proto.writeTag(buf, n19, 2, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeBuffer(v943, v944, v942, buffer.len(v942))
	end

	local buf37 = buffer.create(n19)

	buffer.copy(buf37, 0, buf, 0, n19)

	return buf37
end
function t108.decode(p29: buffer) -- line: 3490
	-- upvalues: t108 (copy), proto (copy), game_developer_product_data (copy)
	local v947 = t108.new()
	local n20 = 0

	while n20 < buffer.len(p29) do
		local v949, v950

		v949, v950, n20 = proto.readTag(p29, n20)

		if v950 == proto.wireTypes.varint then
			local v951

			v951, n20 = proto.readVarInt(p29, n20)
		elseif v950 == proto.wireTypes.lengthDelimited then
			if v949 == 1 then
				local v952

				v952, n20 = proto.readBuffer(p29, n20)
				v947.key = buffer.tostring(v952)
			elseif v949 == 2 then
				local v953

				v953, n20 = proto.readBuffer(p29, n20)
				v947.value = game_developer_product_data.GameDeveloperProductData.decode(v953)
			else
				local v954, v955 = proto.readVarInt(p29, n20)

				n20 = v955 + v954
			end
		elseif v950 == proto.wireTypes.i32 then
			local v956

			v956, n20 = proto.readFixed32(p29, n20)
		elseif v950 == proto.wireTypes.i64 then
			local v957

			v957, n20 = proto.readFixed64(p29, n20)
		else
			error("Unsupported wire type: " .. v950)
		end
	end

	return v947
end
function t108.jsonEncode(p30) -- line: 3543
	local t110 = {}

	if p30.key ~= nil and p30.key ~= "" then
		t110.key = p30.key
	end

	if p30.value ~= nil then
		t110.value = p30.value:jsonEncode()
	end

	return t110
end
function t108.jsonDecode(t111: {[any]: any}) -- line: 3559
	-- upvalues: t108 (copy), game_developer_product_data (copy)
	local v961 = t108.new()

	if t111.key ~= nil then
		v961.key = t111.key
	end

	if t111.value ~= nil then
		v961.value = game_developer_product_data.GameDeveloperProductData.jsonDecode(t111.value)
	end

	return v961
end

t108.descriptor = {
	name = "HydrationContent_GameDeveloperProductEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.GameDeveloperProductEntry"
}
t1.HydrationContent_GameDeveloperProductEntry = t108
typeRegistry.default:register(t1.HydrationContent_GameDeveloperProductEntry)

local t112 = {}

t112.__index = t112

function t112.new(t113: {[any]: any}?) -- line: 3592
	-- upvalues: t112 (copy)
	return (setmetatable({
		key = if t113 ~= nil and t113.key ~= nil then t113.key else "",
		value = if t113 ~= nil and t113.value ~= nil then t113.value else nil
	}, t112))
end
function t112.encode(p31) -- line: 3601
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n21 = 0

	if p31.key ~= nil and p31.key ~= "" then
		local v966, v967 = proto.writeTag(buf, n21, 1, proto.wireTypes.lengthDelimited)

		buf, n21 = proto.writeString(v966, v967, p31.key)
	end

	if p31.value ~= nil then
		local v968 = p31.value:encode()
		local v969, v970 = proto.writeTag(buf, n21, 2, proto.wireTypes.lengthDelimited)

		buf, n21 = proto.writeBuffer(v969, v970, v968, buffer.len(v968))
	end

	local buf38 = buffer.create(n21)

	buffer.copy(buf38, 0, buf, 0, n21)

	return buf38
end
function t112.decode(p32: buffer) -- line: 3621
	-- upvalues: t112 (copy), proto (copy), game_subscription_data (copy)
	local v973 = t112.new()
	local n22 = 0

	while n22 < buffer.len(p32) do
		local v975, v976

		v975, v976, n22 = proto.readTag(p32, n22)

		if v976 == proto.wireTypes.varint then
			local v977

			v977, n22 = proto.readVarInt(p32, n22)
		elseif v976 == proto.wireTypes.lengthDelimited then
			if v975 == 1 then
				local v978

				v978, n22 = proto.readBuffer(p32, n22)
				v973.key = buffer.tostring(v978)
			elseif v975 == 2 then
				local v979

				v979, n22 = proto.readBuffer(p32, n22)
				v973.value = game_subscription_data.GameSubscriptionData.decode(v979)
			else
				local v980, v981 = proto.readVarInt(p32, n22)

				n22 = v981 + v980
			end
		elseif v976 == proto.wireTypes.i32 then
			local v982

			v982, n22 = proto.readFixed32(p32, n22)
		elseif v976 == proto.wireTypes.i64 then
			local v983

			v983, n22 = proto.readFixed64(p32, n22)
		else
			error("Unsupported wire type: " .. v976)
		end
	end

	return v973
end
function t112.jsonEncode(p33) -- line: 3670
	local t114 = {}

	if p33.key ~= nil and p33.key ~= "" then
		t114.key = p33.key
	end

	if p33.value ~= nil then
		t114.value = p33.value:jsonEncode()
	end

	return t114
end
function t112.jsonDecode(t115: {[any]: any}) -- line: 3684
	-- upvalues: t112 (copy), game_subscription_data (copy)
	local v987 = t112.new()

	if t115.key ~= nil then
		v987.key = t115.key
	end

	if t115.value ~= nil then
		v987.value = game_subscription_data.GameSubscriptionData.jsonDecode(t115.value)
	end

	return v987
end

t112.descriptor = {
	name = "HydrationContent_GameSubscriptionEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.GameSubscriptionEntry"
}
t1.HydrationContent_GameSubscriptionEntry = t112
typeRegistry.default:register(t1.HydrationContent_GameSubscriptionEntry)

local t116 = {}

t116.__index = t116

function t116.new(t117: {[any]: any}?) -- line: 3717
	-- upvalues: t116 (copy)
	return (setmetatable({
		key = if t117 ~= nil and t117.key ~= nil then t117.key else "",
		value = if t117 ~= nil and t117.value ~= nil then t117.value else nil
	}, t116))
end
function t116.encode(p34) -- line: 3729
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n23 = 0

	if p34.key ~= nil and p34.key ~= "" then
		local v992, v993 = proto.writeTag(buf, n23, 1, proto.wireTypes.lengthDelimited)

		buf, n23 = proto.writeString(v992, v993, p34.key)
	end

	if p34.value ~= nil then
		local v994 = p34.value:encode()
		local v995, v996 = proto.writeTag(buf, n23, 2, proto.wireTypes.lengthDelimited)

		buf, n23 = proto.writeBuffer(v995, v996, v994, buffer.len(v994))
	end

	local buf39 = buffer.create(n23)

	buffer.copy(buf39, 0, buf, 0, n23)

	return buf39
end
function t116.decode(p35: buffer) -- line: 3751
	-- upvalues: t116 (copy), proto (copy), marketplace_catalog_category_data (copy)
	local v999 = t116.new()
	local n24 = 0

	while n24 < buffer.len(p35) do
		local v1001, v1002

		v1001, v1002, n24 = proto.readTag(p35, n24)

		if v1002 == proto.wireTypes.varint then
			local v1003

			v1003, n24 = proto.readVarInt(p35, n24)
		elseif v1002 == proto.wireTypes.lengthDelimited then
			if v1001 == 1 then
				local v1004

				v1004, n24 = proto.readBuffer(p35, n24)
				v999.key = buffer.tostring(v1004)
			elseif v1001 == 2 then
				local v1005

				v1005, n24 = proto.readBuffer(p35, n24)
				v999.value = marketplace_catalog_category_data.MarketplaceCatalogCategoryData.decode(v1005)
			else
				local v1006, v1007 = proto.readVarInt(p35, n24)

				n24 = v1007 + v1006
			end
		elseif v1002 == proto.wireTypes.i32 then
			local v1008

			v1008, n24 = proto.readFixed32(p35, n24)
		elseif v1002 == proto.wireTypes.i64 then
			local v1009

			v1009, n24 = proto.readFixed64(p35, n24)
		else
			error("Unsupported wire type: " .. v1002)
		end
	end

	return v999
end
function t116.jsonEncode(p36) -- line: 3804
	local t118 = {}

	if p36.key ~= nil and p36.key ~= "" then
		t118.key = p36.key
	end

	if p36.value ~= nil then
		t118.value = p36.value:jsonEncode()
	end

	return t118
end
function t116.jsonDecode(t119: {[any]: any}) -- line: 3820
	-- upvalues: t116 (copy), marketplace_catalog_category_data (copy)
	local v1013 = t116.new()

	if t119.key ~= nil then
		v1013.key = t119.key
	end

	if t119.value ~= nil then
		v1013.value = marketplace_catalog_category_data.MarketplaceCatalogCategoryData.jsonDecode(t119.value)
	end

	return v1013
end

t116.descriptor = {
	name = "HydrationContent_MarketplaceCatalogCategoryEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.MarketplaceCatalogCategoryEntry"
}
t1.HydrationContent_MarketplaceCatalogCategoryEntry = t116
typeRegistry.default:register(t1.HydrationContent_MarketplaceCatalogCategoryEntry)

local t120 = {}

t120.__index = t120

function t120.new(t121: {[any]: any}?) -- line: 3854
	-- upvalues: t120 (copy)
	return (setmetatable({
		key = if t121 ~= nil and t121.key ~= nil then t121.key else "",
		value = if t121 ~= nil and t121.value ~= nil then t121.value else nil
	}, t120))
end
function t120.encode(p37) -- line: 3863
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n25 = 0

	if p37.key ~= nil and p37.key ~= "" then
		local v1018, v1019 = proto.writeTag(buf, n25, 1, proto.wireTypes.lengthDelimited)

		buf, n25 = proto.writeString(v1018, v1019, p37.key)
	end

	if p37.value ~= nil then
		local v1020 = p37.value:encode()
		local v1021, v1022 = proto.writeTag(buf, n25, 2, proto.wireTypes.lengthDelimited)

		buf, n25 = proto.writeBuffer(v1021, v1022, v1020, buffer.len(v1020))
	end

	local buf40 = buffer.create(n25)

	buffer.copy(buf40, 0, buf, 0, n25)

	return buf40
end
function t120.decode(p38: buffer) -- line: 3883
	-- upvalues: t120 (copy), proto (copy), marketplace_asset_data (copy)
	local v1025 = t120.new()
	local n26 = 0

	while n26 < buffer.len(p38) do
		local v1027, v1028

		v1027, v1028, n26 = proto.readTag(p38, n26)

		if v1028 == proto.wireTypes.varint then
			local v1029

			v1029, n26 = proto.readVarInt(p38, n26)
		elseif v1028 == proto.wireTypes.lengthDelimited then
			if v1027 == 1 then
				local v1030

				v1030, n26 = proto.readBuffer(p38, n26)
				v1025.key = buffer.tostring(v1030)
			elseif v1027 == 2 then
				local v1031

				v1031, n26 = proto.readBuffer(p38, n26)
				v1025.value = marketplace_asset_data.MarketplaceAssetData.decode(v1031)
			else
				local v1032, v1033 = proto.readVarInt(p38, n26)

				n26 = v1033 + v1032
			end
		elseif v1028 == proto.wireTypes.i32 then
			local v1034

			v1034, n26 = proto.readFixed32(p38, n26)
		elseif v1028 == proto.wireTypes.i64 then
			local v1035

			v1035, n26 = proto.readFixed64(p38, n26)
		else
			error("Unsupported wire type: " .. v1028)
		end
	end

	return v1025
end
function t120.jsonEncode(p39) -- line: 3932
	local t122 = {}

	if p39.key ~= nil and p39.key ~= "" then
		t122.key = p39.key
	end

	if p39.value ~= nil then
		t122.value = p39.value:jsonEncode()
	end

	return t122
end
function t120.jsonDecode(t123: {[any]: any}) -- line: 3946
	-- upvalues: t120 (copy), marketplace_asset_data (copy)
	local v1039 = t120.new()

	if t123.key ~= nil then
		v1039.key = t123.key
	end

	if t123.value ~= nil then
		v1039.value = marketplace_asset_data.MarketplaceAssetData.jsonDecode(t123.value)
	end

	return v1039
end

t120.descriptor = {
	name = "HydrationContent_MarketplaceAssetEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.MarketplaceAssetEntry"
}
t1.HydrationContent_MarketplaceAssetEntry = t120
typeRegistry.default:register(t1.HydrationContent_MarketplaceAssetEntry)

local t124 = {}

t124.__index = t124

function t124.new(t125: {[any]: any}?) -- line: 3978
	-- upvalues: t124 (copy)
	return (setmetatable({
		key = if t125 ~= nil and t125.key ~= nil then t125.key else "",
		value = if t125 ~= nil and t125.value ~= nil then t125.value else nil
	}, t124))
end
function t124.encode(p40) -- line: 3987
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n27 = 0

	if p40.key ~= nil and p40.key ~= "" then
		local v1044, v1045 = proto.writeTag(buf, n27, 1, proto.wireTypes.lengthDelimited)

		buf, n27 = proto.writeString(v1044, v1045, p40.key)
	end

	if p40.value ~= nil then
		local v1046 = p40.value:encode()
		local v1047, v1048 = proto.writeTag(buf, n27, 2, proto.wireTypes.lengthDelimited)

		buf, n27 = proto.writeBuffer(v1047, v1048, v1046, buffer.len(v1046))
	end

	local buf41 = buffer.create(n27)

	buffer.copy(buf41, 0, buf, 0, n27)

	return buf41
end
function t124.decode(p41: buffer) -- line: 4007
	-- upvalues: t124 (copy), proto (copy), marketplace_bundle_data (copy)
	local v1051 = t124.new()
	local n28 = 0

	while n28 < buffer.len(p41) do
		local v1053, v1054

		v1053, v1054, n28 = proto.readTag(p41, n28)

		if v1054 == proto.wireTypes.varint then
			local v1055

			v1055, n28 = proto.readVarInt(p41, n28)
		elseif v1054 == proto.wireTypes.lengthDelimited then
			if v1053 == 1 then
				local v1056

				v1056, n28 = proto.readBuffer(p41, n28)
				v1051.key = buffer.tostring(v1056)
			elseif v1053 == 2 then
				local v1057

				v1057, n28 = proto.readBuffer(p41, n28)
				v1051.value = marketplace_bundle_data.MarketplaceBundleData.decode(v1057)
			else
				local v1058, v1059 = proto.readVarInt(p41, n28)

				n28 = v1059 + v1058
			end
		elseif v1054 == proto.wireTypes.i32 then
			local v1060

			v1060, n28 = proto.readFixed32(p41, n28)
		elseif v1054 == proto.wireTypes.i64 then
			local v1061

			v1061, n28 = proto.readFixed64(p41, n28)
		else
			error("Unsupported wire type: " .. v1054)
		end
	end

	return v1051
end
function t124.jsonEncode(p42) -- line: 4058
	local t126 = {}

	if p42.key ~= nil and p42.key ~= "" then
		t126.key = p42.key
	end

	if p42.value ~= nil then
		t126.value = p42.value:jsonEncode()
	end

	return t126
end
function t124.jsonDecode(t127: {[any]: any}) -- line: 4072
	-- upvalues: t124 (copy), marketplace_bundle_data (copy)
	local v1065 = t124.new()

	if t127.key ~= nil then
		v1065.key = t127.key
	end

	if t127.value ~= nil then
		v1065.value = marketplace_bundle_data.MarketplaceBundleData.jsonDecode(t127.value)
	end

	return v1065
end

t124.descriptor = {
	name = "HydrationContent_MarketplaceBundleEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.MarketplaceBundleEntry"
}
t1.HydrationContent_MarketplaceBundleEntry = t124
typeRegistry.default:register(t1.HydrationContent_MarketplaceBundleEntry)

local t128 = {}

t128.__index = t128

function t128.new(t129: {[any]: any}?) -- line: 4105
	-- upvalues: t128 (copy)
	return (setmetatable({
		key = if t129 ~= nil and t129.key ~= nil then t129.key else "",
		value = if t129 ~= nil and t129.value ~= nil then t129.value else nil
	}, t128))
end
function t128.encode(p43) -- line: 4114
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n29 = 0

	if p43.key ~= nil and p43.key ~= "" then
		local v1070, v1071 = proto.writeTag(buf, n29, 1, proto.wireTypes.lengthDelimited)

		buf, n29 = proto.writeString(v1070, v1071, p43.key)
	end

	if p43.value ~= nil then
		local v1072 = p43.value:encode()
		local v1073, v1074 = proto.writeTag(buf, n29, 2, proto.wireTypes.lengthDelimited)

		buf, n29 = proto.writeBuffer(v1073, v1074, v1072, buffer.len(v1072))
	end

	local buf42 = buffer.create(n29)

	buffer.copy(buf42, 0, buf, 0, n29)

	return buf42
end
function t128.decode(p44: buffer) -- line: 4134
	-- upvalues: t128 (copy), proto (copy), marketplace_look_data (copy)
	local v1077 = t128.new()
	local n30 = 0

	while n30 < buffer.len(p44) do
		local v1079, v1080

		v1079, v1080, n30 = proto.readTag(p44, n30)

		if v1080 == proto.wireTypes.varint then
			local v1081

			v1081, n30 = proto.readVarInt(p44, n30)
		elseif v1080 == proto.wireTypes.lengthDelimited then
			if v1079 == 1 then
				local v1082

				v1082, n30 = proto.readBuffer(p44, n30)
				v1077.key = buffer.tostring(v1082)
			elseif v1079 == 2 then
				local v1083

				v1083, n30 = proto.readBuffer(p44, n30)
				v1077.value = marketplace_look_data.MarketplaceLookData.decode(v1083)
			else
				local v1084, v1085 = proto.readVarInt(p44, n30)

				n30 = v1085 + v1084
			end
		elseif v1080 == proto.wireTypes.i32 then
			local v1086

			v1086, n30 = proto.readFixed32(p44, n30)
		elseif v1080 == proto.wireTypes.i64 then
			local v1087

			v1087, n30 = proto.readFixed64(p44, n30)
		else
			error("Unsupported wire type: " .. v1080)
		end
	end

	return v1077
end
function t128.jsonEncode(p45) -- line: 4183
	local t130 = {}

	if p45.key ~= nil and p45.key ~= "" then
		t130.key = p45.key
	end

	if p45.value ~= nil then
		t130.value = p45.value:jsonEncode()
	end

	return t130
end
function t128.jsonDecode(t131: {[any]: any}) -- line: 4197
	-- upvalues: t128 (copy), marketplace_look_data (copy)
	local v1091 = t128.new()

	if t131.key ~= nil then
		v1091.key = t131.key
	end

	if t131.value ~= nil then
		v1091.value = marketplace_look_data.MarketplaceLookData.jsonDecode(t131.value)
	end

	return v1091
end

t128.descriptor = {
	name = "HydrationContent_MarketplaceLookEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.MarketplaceLookEntry"
}
t1.HydrationContent_MarketplaceLookEntry = t128
typeRegistry.default:register(t1.HydrationContent_MarketplaceLookEntry)

local t132 = {}

t132.__index = t132

function t132.new(t133: {[any]: any}?) -- line: 4228
	-- upvalues: t132 (copy)
	return (setmetatable({
		key = if t133 ~= nil and t133.key ~= nil then t133.key else "",
		value = if t133 ~= nil and t133.value ~= nil then t133.value else nil
	}, t132))
end
function t132.encode(p46) -- line: 4237
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n31 = 0

	if p46.key ~= nil and p46.key ~= "" then
		local v1096, v1097 = proto.writeTag(buf, n31, 1, proto.wireTypes.lengthDelimited)

		buf, n31 = proto.writeString(v1096, v1097, p46.key)
	end

	if p46.value ~= nil then
		local v1098 = p46.value:encode()
		local v1099, v1100 = proto.writeTag(buf, n31, 2, proto.wireTypes.lengthDelimited)

		buf, n31 = proto.writeBuffer(v1099, v1100, v1098, buffer.len(v1098))
	end

	local buf43 = buffer.create(n31)

	buffer.copy(buf43, 0, buf, 0, n31)

	return buf43
end
function t132.decode(p47: buffer) -- line: 4257
	-- upvalues: t132 (copy), proto (copy), catalog_sort_data (copy)
	local v1103 = t132.new()
	local n32 = 0

	while n32 < buffer.len(p47) do
		local v1105, v1106

		v1105, v1106, n32 = proto.readTag(p47, n32)

		if v1106 == proto.wireTypes.varint then
			local v1107

			v1107, n32 = proto.readVarInt(p47, n32)
		elseif v1106 == proto.wireTypes.lengthDelimited then
			if v1105 == 1 then
				local v1108

				v1108, n32 = proto.readBuffer(p47, n32)
				v1103.key = buffer.tostring(v1108)
			elseif v1105 == 2 then
				local v1109

				v1109, n32 = proto.readBuffer(p47, n32)
				v1103.value = catalog_sort_data.CatalogSortData.decode(v1109)
			else
				local v1110, v1111 = proto.readVarInt(p47, n32)

				n32 = v1111 + v1110
			end
		elseif v1106 == proto.wireTypes.i32 then
			local v1112

			v1112, n32 = proto.readFixed32(p47, n32)
		elseif v1106 == proto.wireTypes.i64 then
			local v1113

			v1113, n32 = proto.readFixed64(p47, n32)
		else
			error("Unsupported wire type: " .. v1106)
		end
	end

	return v1103
end
function t132.jsonEncode(p48) -- line: 4305
	local t134 = {}

	if p48.key ~= nil and p48.key ~= "" then
		t134.key = p48.key
	end

	if p48.value ~= nil then
		t134.value = p48.value:jsonEncode()
	end

	return t134
end
function t132.jsonDecode(t135: {[any]: any}) -- line: 4319
	-- upvalues: t132 (copy), catalog_sort_data (copy)
	local v1117 = t132.new()

	if t135.key ~= nil then
		v1117.key = t135.key
	end

	if t135.value ~= nil then
		v1117.value = catalog_sort_data.CatalogSortData.jsonDecode(t135.value)
	end

	return v1117
end

t132.descriptor = {
	name = "HydrationContent_CatalogSortEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.CatalogSortEntry"
}
t1.HydrationContent_CatalogSortEntry = t132
typeRegistry.default:register(t1.HydrationContent_CatalogSortEntry)

local t136 = {}

t136.__index = t136

function t136.new(t137: {[any]: any}?) -- line: 4350
	-- upvalues: t136 (copy)
	return (setmetatable({
		key = if t137 ~= nil and t137.key ~= nil then t137.key else "",
		value = if t137 ~= nil and t137.value ~= nil then t137.value else nil
	}, t136))
end
function t136.encode(p49) -- line: 4359
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n33 = 0

	if p49.key ~= nil and p49.key ~= "" then
		local v1122, v1123 = proto.writeTag(buf, n33, 1, proto.wireTypes.lengthDelimited)

		buf, n33 = proto.writeString(v1122, v1123, p49.key)
	end

	if p49.value ~= nil then
		local v1124 = p49.value:encode()
		local v1125, v1126 = proto.writeTag(buf, n33, 2, proto.wireTypes.lengthDelimited)

		buf, n33 = proto.writeBuffer(v1125, v1126, v1124, buffer.len(v1124))
	end

	local buf44 = buffer.create(n33)

	buffer.copy(buf44, 0, buf, 0, n33)

	return buf44
end
function t136.decode(p50: buffer) -- line: 4379
	-- upvalues: t136 (copy), proto (copy), age_recommendation_data (copy)
	local v1129 = t136.new()
	local n34 = 0

	while n34 < buffer.len(p50) do
		local v1131, v1132

		v1131, v1132, n34 = proto.readTag(p50, n34)

		if v1132 == proto.wireTypes.varint then
			local v1133

			v1133, n34 = proto.readVarInt(p50, n34)
		elseif v1132 == proto.wireTypes.lengthDelimited then
			if v1131 == 1 then
				local v1134

				v1134, n34 = proto.readBuffer(p50, n34)
				v1129.key = buffer.tostring(v1134)
			elseif v1131 == 2 then
				local v1135

				v1135, n34 = proto.readBuffer(p50, n34)
				v1129.value = age_recommendation_data.AgeRecommendationData.decode(v1135)
			else
				local v1136, v1137 = proto.readVarInt(p50, n34)

				n34 = v1137 + v1136
			end
		elseif v1132 == proto.wireTypes.i32 then
			local v1138

			v1138, n34 = proto.readFixed32(p50, n34)
		elseif v1132 == proto.wireTypes.i64 then
			local v1139

			v1139, n34 = proto.readFixed64(p50, n34)
		else
			error("Unsupported wire type: " .. v1132)
		end
	end

	return v1129
end
function t136.jsonEncode(p51) -- line: 4430
	local t138 = {}

	if p51.key ~= nil and p51.key ~= "" then
		t138.key = p51.key
	end

	if p51.value ~= nil then
		t138.value = p51.value:jsonEncode()
	end

	return t138
end
function t136.jsonDecode(t139: {[any]: any}) -- line: 4444
	-- upvalues: t136 (copy), age_recommendation_data (copy)
	local v1143 = t136.new()

	if t139.key ~= nil then
		v1143.key = t139.key
	end

	if t139.value ~= nil then
		v1143.value = age_recommendation_data.AgeRecommendationData.jsonDecode(t139.value)
	end

	return v1143
end

t136.descriptor = {
	name = "HydrationContent_AgeRecommendationEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.AgeRecommendationEntry"
}
t1.HydrationContent_AgeRecommendationEntry = t136
typeRegistry.default:register(t1.HydrationContent_AgeRecommendationEntry)

local t140 = {}

t140.__index = t140

function t140.new(t141: {[any]: any}?) -- line: 4477
	-- upvalues: t140 (copy)
	return (setmetatable({
		key = if t141 ~= nil and t141.key ~= nil then t141.key else "",
		value = if t141 ~= nil and t141.value ~= nil then t141.value else nil
	}, t140))
end
function t140.encode(p52) -- line: 4486
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n35 = 0

	if p52.key ~= nil and p52.key ~= "" then
		local v1148, v1149 = proto.writeTag(buf, n35, 1, proto.wireTypes.lengthDelimited)

		buf, n35 = proto.writeString(v1148, v1149, p52.key)
	end

	if p52.value ~= nil then
		local v1150 = p52.value:encode()
		local v1151, v1152 = proto.writeTag(buf, n35, 2, proto.wireTypes.lengthDelimited)

		buf, n35 = proto.writeBuffer(v1151, v1152, v1150, buffer.len(v1150))
	end

	local buf45 = buffer.create(n35)

	buffer.copy(buf45, 0, buf, 0, n35)

	return buf45
end
function t140.decode(p53: buffer) -- line: 4508
	-- upvalues: t140 (copy), proto (copy), universe_user_follow_data (copy)
	local v1155 = t140.new()
	local n36 = 0

	while n36 < buffer.len(p53) do
		local v1157, v1158

		v1157, v1158, n36 = proto.readTag(p53, n36)

		if v1158 == proto.wireTypes.varint then
			local v1159

			v1159, n36 = proto.readVarInt(p53, n36)
		elseif v1158 == proto.wireTypes.lengthDelimited then
			if v1157 == 1 then
				local v1160

				v1160, n36 = proto.readBuffer(p53, n36)
				v1155.key = buffer.tostring(v1160)
			elseif v1157 == 2 then
				local v1161

				v1161, n36 = proto.readBuffer(p53, n36)
				v1155.value = universe_user_follow_data.UniverseUserFollowData.decode(v1161)
			else
				local v1162, v1163 = proto.readVarInt(p53, n36)

				n36 = v1163 + v1162
			end
		elseif v1158 == proto.wireTypes.i32 then
			local v1164

			v1164, n36 = proto.readFixed32(p53, n36)
		elseif v1158 == proto.wireTypes.i64 then
			local v1165

			v1165, n36 = proto.readFixed64(p53, n36)
		else
			error("Unsupported wire type: " .. v1158)
		end
	end

	return v1155
end
function t140.jsonEncode(p54) -- line: 4561
	local t142 = {}

	if p54.key ~= nil and p54.key ~= "" then
		t142.key = p54.key
	end

	if p54.value ~= nil then
		t142.value = p54.value:jsonEncode()
	end

	return t142
end
function t140.jsonDecode(t143: {[any]: any}) -- line: 4577
	-- upvalues: t140 (copy), universe_user_follow_data (copy)
	local v1169 = t140.new()

	if t143.key ~= nil then
		v1169.key = t143.key
	end

	if t143.value ~= nil then
		v1169.value = universe_user_follow_data.UniverseUserFollowData.jsonDecode(t143.value)
	end

	return v1169
end

t140.descriptor = {
	name = "HydrationContent_UniverseUserFollowEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniverseUserFollowEntry"
}
t1.HydrationContent_UniverseUserFollowEntry = t140
typeRegistry.default:register(t1.HydrationContent_UniverseUserFollowEntry)

local t144 = {}

t144.__index = t144

function t144.new(t145: {[any]: any}?) -- line: 4610
	-- upvalues: t144 (copy)
	return (setmetatable({
		key = if t145 ~= nil and t145.key ~= nil then t145.key else "",
		value = if t145 ~= nil and t145.value ~= nil then t145.value else nil
	}, t144))
end
function t144.encode(p55) -- line: 4619
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n37 = 0

	if p55.key ~= nil and p55.key ~= "" then
		local v1174, v1175 = proto.writeTag(buf, n37, 1, proto.wireTypes.lengthDelimited)

		buf, n37 = proto.writeString(v1174, v1175, p55.key)
	end

	if p55.value ~= nil then
		local v1176 = p55.value:encode()
		local v1177, v1178 = proto.writeTag(buf, n37, 2, proto.wireTypes.lengthDelimited)

		buf, n37 = proto.writeBuffer(v1177, v1178, v1176, buffer.len(v1176))
	end

	local buf46 = buffer.create(n37)

	buffer.copy(buf46, 0, buf, 0, n37)

	return buf46
end
function t144.decode(p56: buffer) -- line: 4639
	-- upvalues: t144 (copy), proto (copy), universe_user_vote_data (copy)
	local v1181 = t144.new()
	local n38 = 0

	while n38 < buffer.len(p56) do
		local v1183, v1184

		v1183, v1184, n38 = proto.readTag(p56, n38)

		if v1184 == proto.wireTypes.varint then
			local v1185

			v1185, n38 = proto.readVarInt(p56, n38)
		elseif v1184 == proto.wireTypes.lengthDelimited then
			if v1183 == 1 then
				local v1186

				v1186, n38 = proto.readBuffer(p56, n38)
				v1181.key = buffer.tostring(v1186)
			elseif v1183 == 2 then
				local v1187

				v1187, n38 = proto.readBuffer(p56, n38)
				v1181.value = universe_user_vote_data.UniverseUserVoteData.decode(v1187)
			else
				local v1188, v1189 = proto.readVarInt(p56, n38)

				n38 = v1189 + v1188
			end
		elseif v1184 == proto.wireTypes.i32 then
			local v1190

			v1190, n38 = proto.readFixed32(p56, n38)
		elseif v1184 == proto.wireTypes.i64 then
			local v1191

			v1191, n38 = proto.readFixed64(p56, n38)
		else
			error("Unsupported wire type: " .. v1184)
		end
	end

	return v1181
end
function t144.jsonEncode(p57) -- line: 4690
	local t146 = {}

	if p57.key ~= nil and p57.key ~= "" then
		t146.key = p57.key
	end

	if p57.value ~= nil then
		t146.value = p57.value:jsonEncode()
	end

	return t146
end
function t144.jsonDecode(t147: {[any]: any}) -- line: 4704
	-- upvalues: t144 (copy), universe_user_vote_data (copy)
	local v1195 = t144.new()

	if t147.key ~= nil then
		v1195.key = t147.key
	end

	if t147.value ~= nil then
		v1195.value = universe_user_vote_data.UniverseUserVoteData.jsonDecode(t147.value)
	end

	return v1195
end

t144.descriptor = {
	name = "HydrationContent_UniverseUserVoteEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniverseUserVoteEntry"
}
t1.HydrationContent_UniverseUserVoteEntry = t144
typeRegistry.default:register(t1.HydrationContent_UniverseUserVoteEntry)

local t148 = {}

t148.__index = t148

function t148.new(t149: {[any]: any}?) -- line: 4736
	-- upvalues: t148 (copy)
	return (setmetatable({
		key = if t149 ~= nil and t149.key ~= nil then t149.key else "",
		value = if t149 ~= nil and t149.value ~= nil then t149.value else nil
	}, t148))
end
function t148.encode(p58) -- line: 4745
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n39 = 0

	if p58.key ~= nil and p58.key ~= "" then
		local v1200, v1201 = proto.writeTag(buf, n39, 1, proto.wireTypes.lengthDelimited)

		buf, n39 = proto.writeString(v1200, v1201, p58.key)
	end

	if p58.value ~= nil then
		local v1202 = p58.value:encode()
		local v1203, v1204 = proto.writeTag(buf, n39, 2, proto.wireTypes.lengthDelimited)

		buf, n39 = proto.writeBuffer(v1203, v1204, v1202, buffer.len(v1202))
	end

	local buf47 = buffer.create(n39)

	buffer.copy(buf47, 0, buf, 0, n39)

	return buf47
end
function t148.decode(p59: buffer) -- line: 4765
	-- upvalues: t148 (copy), proto (copy), user_profile_data (copy)
	local v1207 = t148.new()
	local n40 = 0

	while n40 < buffer.len(p59) do
		local v1209, v1210

		v1209, v1210, n40 = proto.readTag(p59, n40)

		if v1210 == proto.wireTypes.varint then
			local v1211

			v1211, n40 = proto.readVarInt(p59, n40)
		elseif v1210 == proto.wireTypes.lengthDelimited then
			if v1209 == 1 then
				local v1212

				v1212, n40 = proto.readBuffer(p59, n40)
				v1207.key = buffer.tostring(v1212)
			elseif v1209 == 2 then
				local v1213

				v1213, n40 = proto.readBuffer(p59, n40)
				v1207.value = user_profile_data.UserProfileData.decode(v1213)
			else
				local v1214, v1215 = proto.readVarInt(p59, n40)

				n40 = v1215 + v1214
			end
		elseif v1210 == proto.wireTypes.i32 then
			local v1216

			v1216, n40 = proto.readFixed32(p59, n40)
		elseif v1210 == proto.wireTypes.i64 then
			local v1217

			v1217, n40 = proto.readFixed64(p59, n40)
		else
			error("Unsupported wire type: " .. v1210)
		end
	end

	return v1207
end
function t148.jsonEncode(p60) -- line: 4813
	local t150 = {}

	if p60.key ~= nil and p60.key ~= "" then
		t150.key = p60.key
	end

	if p60.value ~= nil then
		t150.value = p60.value:jsonEncode()
	end

	return t150
end
function t148.jsonDecode(t151: {[any]: any}) -- line: 4827
	-- upvalues: t148 (copy), user_profile_data (copy)
	local v1221 = t148.new()

	if t151.key ~= nil then
		v1221.key = t151.key
	end

	if t151.value ~= nil then
		v1221.value = user_profile_data.UserProfileData.jsonDecode(t151.value)
	end

	return v1221
end

t148.descriptor = {
	name = "HydrationContent_UserProfileEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.UserProfileEntry"
}
t1.HydrationContent_UserProfileEntry = t148
typeRegistry.default:register(t1.HydrationContent_UserProfileEntry)

local t152 = {}

t152.__index = t152

function t152.new(t153: {[any]: any}?) -- line: 4858
	-- upvalues: t152 (copy)
	return (setmetatable({
		key = if t153 ~= nil and t153.key ~= nil then t153.key else "",
		value = if t153 ~= nil and t153.value ~= nil then t153.value else nil
	}, t152))
end
function t152.encode(p61) -- line: 4867
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n41 = 0

	if p61.key ~= nil and p61.key ~= "" then
		local v1226, v1227 = proto.writeTag(buf, n41, 1, proto.wireTypes.lengthDelimited)

		buf, n41 = proto.writeString(v1226, v1227, p61.key)
	end

	if p61.value ~= nil then
		local v1228 = p61.value:encode()
		local v1229, v1230 = proto.writeTag(buf, n41, 2, proto.wireTypes.lengthDelimited)

		buf, n41 = proto.writeBuffer(v1229, v1230, v1228, buffer.len(v1228))
	end

	local buf48 = buffer.create(n41)

	buffer.copy(buf48, 0, buf, 0, n41)

	return buf48
end
function t152.decode(p62: buffer) -- line: 4889
	-- upvalues: t152 (copy), proto (copy), universe_user_favorite_data (copy)
	local v1233 = t152.new()
	local n42 = 0

	while n42 < buffer.len(p62) do
		local v1235, v1236

		v1235, v1236, n42 = proto.readTag(p62, n42)

		if v1236 == proto.wireTypes.varint then
			local v1237

			v1237, n42 = proto.readVarInt(p62, n42)
		elseif v1236 == proto.wireTypes.lengthDelimited then
			if v1235 == 1 then
				local v1238

				v1238, n42 = proto.readBuffer(p62, n42)
				v1233.key = buffer.tostring(v1238)
			elseif v1235 == 2 then
				local v1239

				v1239, n42 = proto.readBuffer(p62, n42)
				v1233.value = universe_user_favorite_data.UniverseUserFavoriteData.decode(v1239)
			else
				local v1240, v1241 = proto.readVarInt(p62, n42)

				n42 = v1241 + v1240
			end
		elseif v1236 == proto.wireTypes.i32 then
			local v1242

			v1242, n42 = proto.readFixed32(p62, n42)
		elseif v1236 == proto.wireTypes.i64 then
			local v1243

			v1243, n42 = proto.readFixed64(p62, n42)
		else
			error("Unsupported wire type: " .. v1236)
		end
	end

	return v1233
end
function t152.jsonEncode(p63) -- line: 4942
	local t154 = {}

	if p63.key ~= nil and p63.key ~= "" then
		t154.key = p63.key
	end

	if p63.value ~= nil then
		t154.value = p63.value:jsonEncode()
	end

	return t154
end
function t152.jsonDecode(t155: {[any]: any}) -- line: 4958
	-- upvalues: t152 (copy), universe_user_favorite_data (copy)
	local v1247 = t152.new()

	if t155.key ~= nil then
		v1247.key = t155.key
	end

	if t155.value ~= nil then
		v1247.value = universe_user_favorite_data.UniverseUserFavoriteData.jsonDecode(t155.value)
	end

	return v1247
end

t152.descriptor = {
	name = "HydrationContent_UniverseUserFavoriteEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniverseUserFavoriteEntry"
}
t1.HydrationContent_UniverseUserFavoriteEntry = t152
typeRegistry.default:register(t1.HydrationContent_UniverseUserFavoriteEntry)

local t156 = {}

t156.__index = t156

function t156.new(t157: {[any]: any}?) -- line: 4991
	-- upvalues: t156 (copy)
	return (setmetatable({
		key = if t157 ~= nil and t157.key ~= nil then t157.key else "",
		value = if t157 ~= nil and t157.value ~= nil then t157.value else nil
	}, t156))
end
function t156.encode(p64) -- line: 5000
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n43 = 0

	if p64.key ~= nil and p64.key ~= "" then
		local v1252, v1253 = proto.writeTag(buf, n43, 1, proto.wireTypes.lengthDelimited)

		buf, n43 = proto.writeString(v1252, v1253, p64.key)
	end

	if p64.value ~= nil then
		local v1254 = p64.value:encode()
		local v1255, v1256 = proto.writeTag(buf, n43, 2, proto.wireTypes.lengthDelimited)

		buf, n43 = proto.writeBuffer(v1255, v1256, v1254, buffer.len(v1254))
	end

	local buf49 = buffer.create(n43)

	buffer.copy(buf49, 0, buf, 0, n43)

	return buf49
end
function t156.decode(p65: buffer) -- line: 5020
	-- upvalues: t156 (copy), proto (copy), playability_data (copy)
	local v1259 = t156.new()
	local n44 = 0

	while n44 < buffer.len(p65) do
		local v1261, v1262

		v1261, v1262, n44 = proto.readTag(p65, n44)

		if v1262 == proto.wireTypes.varint then
			local v1263

			v1263, n44 = proto.readVarInt(p65, n44)
		elseif v1262 == proto.wireTypes.lengthDelimited then
			if v1261 == 1 then
				local v1264

				v1264, n44 = proto.readBuffer(p65, n44)
				v1259.key = buffer.tostring(v1264)
			elseif v1261 == 2 then
				local v1265

				v1265, n44 = proto.readBuffer(p65, n44)
				v1259.value = playability_data.PlayabilityData.decode(v1265)
			else
				local v1266, v1267 = proto.readVarInt(p65, n44)

				n44 = v1267 + v1266
			end
		elseif v1262 == proto.wireTypes.i32 then
			local v1268

			v1268, n44 = proto.readFixed32(p65, n44)
		elseif v1262 == proto.wireTypes.i64 then
			local v1269

			v1269, n44 = proto.readFixed64(p65, n44)
		else
			error("Unsupported wire type: " .. v1262)
		end
	end

	return v1259
end
function t156.jsonEncode(p66) -- line: 5068
	local t158 = {}

	if p66.key ~= nil and p66.key ~= "" then
		t158.key = p66.key
	end

	if p66.value ~= nil then
		t158.value = p66.value:jsonEncode()
	end

	return t158
end
function t156.jsonDecode(t159: {[any]: any}) -- line: 5082
	-- upvalues: t156 (copy), playability_data (copy)
	local v1273 = t156.new()

	if t159.key ~= nil then
		v1273.key = t159.key
	end

	if t159.value ~= nil then
		v1273.value = playability_data.PlayabilityData.jsonDecode(t159.value)
	end

	return v1273
end

t156.descriptor = {
	name = "HydrationContent_PlayabilityEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.PlayabilityEntry"
}
t1.HydrationContent_PlayabilityEntry = t156
typeRegistry.default:register(t1.HydrationContent_PlayabilityEntry)

local t160 = {}

t160.__index = t160

function t160.new(t161: {[any]: any}?) -- line: 5112
	-- upvalues: t160 (copy)
	return (setmetatable({
		key = if t161 ~= nil and t161.key ~= nil then t161.key else "",
		value = if t161 ~= nil and t161.value ~= nil then t161.value else nil
	}, t160))
end
function t160.encode(p67) -- line: 5121
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n45 = 0

	if p67.key ~= nil and p67.key ~= "" then
		local v1278, v1279 = proto.writeTag(buf, n45, 1, proto.wireTypes.lengthDelimited)

		buf, n45 = proto.writeString(v1278, v1279, p67.key)
	end

	if p67.value ~= nil then
		local v1280 = p67.value:encode()
		local v1281, v1282 = proto.writeTag(buf, n45, 2, proto.wireTypes.lengthDelimited)

		buf, n45 = proto.writeBuffer(v1281, v1282, v1280, buffer.len(v1280))
	end

	local buf50 = buffer.create(n45)

	buffer.copy(buf50, 0, buf, 0, n45)

	return buf50
end
function t160.decode(p68: buffer) -- line: 5143
	-- upvalues: t160 (copy), proto (copy), universe_user_follow_limit_data (copy)
	local v1285 = t160.new()
	local n46 = 0

	while n46 < buffer.len(p68) do
		local v1287, v1288

		v1287, v1288, n46 = proto.readTag(p68, n46)

		if v1288 == proto.wireTypes.varint then
			local v1289

			v1289, n46 = proto.readVarInt(p68, n46)
		elseif v1288 == proto.wireTypes.lengthDelimited then
			if v1287 == 1 then
				local v1290

				v1290, n46 = proto.readBuffer(p68, n46)
				v1285.key = buffer.tostring(v1290)
			elseif v1287 == 2 then
				local v1291

				v1291, n46 = proto.readBuffer(p68, n46)
				v1285.value = universe_user_follow_limit_data.UniverseUserFollowLimitData.decode(v1291)
			else
				local v1292, v1293 = proto.readVarInt(p68, n46)

				n46 = v1293 + v1292
			end
		elseif v1288 == proto.wireTypes.i32 then
			local v1294

			v1294, n46 = proto.readFixed32(p68, n46)
		elseif v1288 == proto.wireTypes.i64 then
			local v1295

			v1295, n46 = proto.readFixed64(p68, n46)
		else
			error("Unsupported wire type: " .. v1288)
		end
	end

	return v1285
end
function t160.jsonEncode(p69) -- line: 5196
	local t162 = {}

	if p69.key ~= nil and p69.key ~= "" then
		t162.key = p69.key
	end

	if p69.value ~= nil then
		t162.value = p69.value:jsonEncode()
	end

	return t162
end
function t160.jsonDecode(t163: {[any]: any}) -- line: 5212
	-- upvalues: t160 (copy), universe_user_follow_limit_data (copy)
	local v1299 = t160.new()

	if t163.key ~= nil then
		v1299.key = t163.key
	end

	if t163.value ~= nil then
		v1299.value = universe_user_follow_limit_data.UniverseUserFollowLimitData.jsonDecode(t163.value)
	end

	return v1299
end

t160.descriptor = {
	name = "HydrationContent_UniverseUserFollowLimitEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniverseUserFollowLimitEntry"
}
t1.HydrationContent_UniverseUserFollowLimitEntry = t160
typeRegistry.default:register(t1.HydrationContent_UniverseUserFollowLimitEntry)

local t164 = {}

t164.__index = t164

function t164.new(t165: {[any]: any}?) -- line: 5246
	-- upvalues: t164 (copy)
	return (setmetatable({
		key = if t165 ~= nil and t165.key ~= nil then t165.key else "",
		value = if t165 ~= nil and t165.value ~= nil then t165.value else nil
	}, t164))
end
function t164.encode(p70) -- line: 5258
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n47 = 0

	if p70.key ~= nil and p70.key ~= "" then
		local v1304, v1305 = proto.writeTag(buf, n47, 1, proto.wireTypes.lengthDelimited)

		buf, n47 = proto.writeString(v1304, v1305, p70.key)
	end

	if p70.value ~= nil then
		local v1306 = p70.value:encode()
		local v1307, v1308 = proto.writeTag(buf, n47, 2, proto.wireTypes.lengthDelimited)

		buf, n47 = proto.writeBuffer(v1307, v1308, v1306, buffer.len(v1306))
	end

	local buf51 = buffer.create(n47)

	buffer.copy(buf51, 0, buf, 0, n47)

	return buf51
end
function t164.decode(p71: buffer) -- line: 5280
	-- upvalues: t164 (copy), proto (copy), universe_user_vote_feedback_metadata_data (copy)
	local v1311 = t164.new()
	local n48 = 0

	while n48 < buffer.len(p71) do
		local v1313, v1314

		v1313, v1314, n48 = proto.readTag(p71, n48)

		if v1314 == proto.wireTypes.varint then
			local v1315

			v1315, n48 = proto.readVarInt(p71, n48)
		elseif v1314 == proto.wireTypes.lengthDelimited then
			if v1313 == 1 then
				local v1316

				v1316, n48 = proto.readBuffer(p71, n48)
				v1311.key = buffer.tostring(v1316)
			elseif v1313 == 2 then
				local v1317

				v1317, n48 = proto.readBuffer(p71, n48)
				v1311.value = universe_user_vote_feedback_metadata_data.UniverseUserVoteFeedbackMetadataData.decode(v1317)
			else
				local v1318, v1319 = proto.readVarInt(p71, n48)

				n48 = v1319 + v1318
			end
		elseif v1314 == proto.wireTypes.i32 then
			local v1320

			v1320, n48 = proto.readFixed32(p71, n48)
		elseif v1314 == proto.wireTypes.i64 then
			local v1321

			v1321, n48 = proto.readFixed64(p71, n48)
		else
			error("Unsupported wire type: " .. v1314)
		end
	end

	return v1311
end
function t164.jsonEncode(p72) -- line: 5333
	local t166 = {}

	if p72.key ~= nil and p72.key ~= "" then
		t166.key = p72.key
	end

	if p72.value ~= nil then
		t166.value = p72.value:jsonEncode()
	end

	return t166
end
function t164.jsonDecode(t167: {[any]: any}) -- line: 5349
	-- upvalues: t164 (copy), universe_user_vote_feedback_metadata_data (copy)
	local v1325 = t164.new()

	if t167.key ~= nil then
		v1325.key = t167.key
	end

	if t167.value ~= nil then
		v1325.value = universe_user_vote_feedback_metadata_data.UniverseUserVoteFeedbackMetadataData.jsonDecode(t167.value)
	end

	return v1325
end

t164.descriptor = {
	name = "HydrationContent_UniverseUserVoteFeedbackMetadataEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniverseUserVoteFeedbackMetadataEntry"
}
t1.HydrationContent_UniverseUserVoteFeedbackMetadataEntry = t164
typeRegistry.default:register(t1.HydrationContent_UniverseUserVoteFeedbackMetadataEntry)

local t168 = {}

t168.__index = t168

function t168.new(t169: {[any]: any}?) -- line: 5383
	-- upvalues: t168 (copy)
	return (setmetatable({
		key = if t169 ~= nil and t169.key ~= nil then t169.key else "",
		value = if t169 ~= nil and t169.value ~= nil then t169.value else nil
	}, t168))
end
function t168.encode(p73) -- line: 5392
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n49 = 0

	if p73.key ~= nil and p73.key ~= "" then
		local v1330, v1331 = proto.writeTag(buf, n49, 1, proto.wireTypes.lengthDelimited)

		buf, n49 = proto.writeString(v1330, v1331, p73.key)
	end

	if p73.value ~= nil then
		local v1332 = p73.value:encode()
		local v1333, v1334 = proto.writeTag(buf, n49, 2, proto.wireTypes.lengthDelimited)

		buf, n49 = proto.writeBuffer(v1333, v1334, v1332, buffer.len(v1332))
	end

	local buf52 = buffer.create(n49)

	buffer.copy(buf52, 0, buf, 0, n49)

	return buf52
end
function t168.decode(p74: buffer) -- line: 5412
	-- upvalues: t168 (copy), proto (copy), moment_data (copy)
	local v1337 = t168.new()
	local n50 = 0

	while n50 < buffer.len(p74) do
		local v1339, v1340

		v1339, v1340, n50 = proto.readTag(p74, n50)

		if v1340 == proto.wireTypes.varint then
			local v1341

			v1341, n50 = proto.readVarInt(p74, n50)
		elseif v1340 == proto.wireTypes.lengthDelimited then
			if v1339 == 1 then
				local v1342

				v1342, n50 = proto.readBuffer(p74, n50)
				v1337.key = buffer.tostring(v1342)
			elseif v1339 == 2 then
				local v1343

				v1343, n50 = proto.readBuffer(p74, n50)
				v1337.value = moment_data.MomentData.decode(v1343)
			else
				local v1344, v1345 = proto.readVarInt(p74, n50)

				n50 = v1345 + v1344
			end
		elseif v1340 == proto.wireTypes.i32 then
			local v1346

			v1346, n50 = proto.readFixed32(p74, n50)
		elseif v1340 == proto.wireTypes.i64 then
			local v1347

			v1347, n50 = proto.readFixed64(p74, n50)
		else
			error("Unsupported wire type: " .. v1340)
		end
	end

	return v1337
end
function t168.jsonEncode(p75) -- line: 5460
	local t170 = {}

	if p75.key ~= nil and p75.key ~= "" then
		t170.key = p75.key
	end

	if p75.value ~= nil then
		t170.value = p75.value:jsonEncode()
	end

	return t170
end
function t168.jsonDecode(t171: {[any]: any}) -- line: 5474
	-- upvalues: t168 (copy), moment_data (copy)
	local v1351 = t168.new()

	if t171.key ~= nil then
		v1351.key = t171.key
	end

	if t171.value ~= nil then
		v1351.value = moment_data.MomentData.jsonDecode(t171.value)
	end

	return v1351
end

t168.descriptor = {
	name = "HydrationContent_MomentEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.MomentEntry"
}
t1.HydrationContent_MomentEntry = t168
typeRegistry.default:register(t1.HydrationContent_MomentEntry)

local t172 = {}

t172.__index = t172

function t172.new(t173: {[any]: any}?) -- line: 5502
	-- upvalues: t172 (copy)
	return (setmetatable({
		key = if t173 ~= nil and t173.key ~= nil then t173.key else "",
		value = if t173 ~= nil and t173.value ~= nil then t173.value else nil
	}, t172))
end
function t172.encode(p76) -- line: 5511
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n51 = 0

	if p76.key ~= nil and p76.key ~= "" then
		local v1356, v1357 = proto.writeTag(buf, n51, 1, proto.wireTypes.lengthDelimited)

		buf, n51 = proto.writeString(v1356, v1357, p76.key)
	end

	if p76.value ~= nil then
		local v1358 = p76.value:encode()
		local v1359, v1360 = proto.writeTag(buf, n51, 2, proto.wireTypes.lengthDelimited)

		buf, n51 = proto.writeBuffer(v1359, v1360, v1358, buffer.len(v1358))
	end

	local buf53 = buffer.create(n51)

	buffer.copy(buf53, 0, buf, 0, n51)

	return buf53
end
function t172.decode(p77: buffer) -- line: 5531
	-- upvalues: t172 (copy), proto (copy), community_data (copy)
	local v1363 = t172.new()
	local n52 = 0

	while n52 < buffer.len(p77) do
		local v1365, v1366

		v1365, v1366, n52 = proto.readTag(p77, n52)

		if v1366 == proto.wireTypes.varint then
			local v1367

			v1367, n52 = proto.readVarInt(p77, n52)
		elseif v1366 == proto.wireTypes.lengthDelimited then
			if v1365 == 1 then
				local v1368

				v1368, n52 = proto.readBuffer(p77, n52)
				v1363.key = buffer.tostring(v1368)
			elseif v1365 == 2 then
				local v1369

				v1369, n52 = proto.readBuffer(p77, n52)
				v1363.value = community_data.CommunityData.decode(v1369)
			else
				local v1370, v1371 = proto.readVarInt(p77, n52)

				n52 = v1371 + v1370
			end
		elseif v1366 == proto.wireTypes.i32 then
			local v1372

			v1372, n52 = proto.readFixed32(p77, n52)
		elseif v1366 == proto.wireTypes.i64 then
			local v1373

			v1373, n52 = proto.readFixed64(p77, n52)
		else
			error("Unsupported wire type: " .. v1366)
		end
	end

	return v1363
end
function t172.jsonEncode(p78) -- line: 5579
	local t174 = {}

	if p78.key ~= nil and p78.key ~= "" then
		t174.key = p78.key
	end

	if p78.value ~= nil then
		t174.value = p78.value:jsonEncode()
	end

	return t174
end
function t172.jsonDecode(t175: {[any]: any}) -- line: 5593
	-- upvalues: t172 (copy), community_data (copy)
	local v1377 = t172.new()

	if t175.key ~= nil then
		v1377.key = t175.key
	end

	if t175.value ~= nil then
		v1377.value = community_data.CommunityData.jsonDecode(t175.value)
	end

	return v1377
end

t172.descriptor = {
	name = "HydrationContent_CommunityEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.CommunityEntry"
}
t1.HydrationContent_CommunityEntry = t172
typeRegistry.default:register(t1.HydrationContent_CommunityEntry)

local t176 = {}

t176.__index = t176

function t176.new(t177: {[any]: any}?) -- line: 5621
	-- upvalues: t176 (copy)
	return (setmetatable({
		key = if t177 ~= nil and t177.key ~= nil then t177.key else "",
		value = if t177 ~= nil and t177.value ~= nil then t177.value else nil
	}, t176))
end
function t176.encode(p79) -- line: 5630
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n53 = 0

	if p79.key ~= nil and p79.key ~= "" then
		local v1382, v1383 = proto.writeTag(buf, n53, 1, proto.wireTypes.lengthDelimited)

		buf, n53 = proto.writeString(v1382, v1383, p79.key)
	end

	if p79.value ~= nil then
		local v1384 = p79.value:encode()
		local v1385, v1386 = proto.writeTag(buf, n53, 2, proto.wireTypes.lengthDelimited)

		buf, n53 = proto.writeBuffer(v1385, v1386, v1384, buffer.len(v1384))
	end

	local buf54 = buffer.create(n53)

	buffer.copy(buf54, 0, buf, 0, n53)

	return buf54
end
function t176.decode(p80: buffer) -- line: 5652
	-- upvalues: t176 (copy), proto (copy), community_user_membership_data (copy)
	local v1389 = t176.new()
	local n54 = 0

	while n54 < buffer.len(p80) do
		local v1391, v1392

		v1391, v1392, n54 = proto.readTag(p80, n54)

		if v1392 == proto.wireTypes.varint then
			local v1393

			v1393, n54 = proto.readVarInt(p80, n54)
		elseif v1392 == proto.wireTypes.lengthDelimited then
			if v1391 == 1 then
				local v1394

				v1394, n54 = proto.readBuffer(p80, n54)
				v1389.key = buffer.tostring(v1394)
			elseif v1391 == 2 then
				local v1395

				v1395, n54 = proto.readBuffer(p80, n54)
				v1389.value = community_user_membership_data.CommunityUserMembershipData.decode(v1395)
			else
				local v1396, v1397 = proto.readVarInt(p80, n54)

				n54 = v1397 + v1396
			end
		elseif v1392 == proto.wireTypes.i32 then
			local v1398

			v1398, n54 = proto.readFixed32(p80, n54)
		elseif v1392 == proto.wireTypes.i64 then
			local v1399

			v1399, n54 = proto.readFixed64(p80, n54)
		else
			error("Unsupported wire type: " .. v1392)
		end
	end

	return v1389
end
function t176.jsonEncode(p81) -- line: 5705
	local t178 = {}

	if p81.key ~= nil and p81.key ~= "" then
		t178.key = p81.key
	end

	if p81.value ~= nil then
		t178.value = p81.value:jsonEncode()
	end

	return t178
end
function t176.jsonDecode(t179: {[any]: any}) -- line: 5721
	-- upvalues: t176 (copy), community_user_membership_data (copy)
	local v1403 = t176.new()

	if t179.key ~= nil then
		v1403.key = t179.key
	end

	if t179.value ~= nil then
		v1403.value = community_user_membership_data.CommunityUserMembershipData.jsonDecode(t179.value)
	end

	return v1403
end

t176.descriptor = {
	name = "HydrationContent_CommunityUserMembershipEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.CommunityUserMembershipEntry"
}
t1.HydrationContent_CommunityUserMembershipEntry = t176
typeRegistry.default:register(t1.HydrationContent_CommunityUserMembershipEntry)

return {
	HydrationContent = t1.HydrationContent
}
