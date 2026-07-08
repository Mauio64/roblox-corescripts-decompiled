local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local background_layer = require(script.Parent.background_layer)
local page_entry = require(script.Parent.page_entry)
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 3409
	-- upvalues: t2 (copy)
	return (setmetatable({
		page_entry = if t3 ~= nil and t3.page_entry ~= nil then t3.page_entry else nil,
		input_data = if t3 ~= nil and t3.input_data ~= nil then t3.input_data else nil
	}, t2))
end
function t2.encode(p1) -- line: 3416
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.page_entry ~= nil then
		local v117 = p1.page_entry:encode()
		local v118, v119 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeBuffer(v118, v119, v117, buffer.len(v117))
	end

	if p1.input_data ~= nil then
		local v120 = p1.input_data:encode()
		local v121, v122 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeBuffer(v121, v122, v120, buffer.len(v120))
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 3437
	-- upvalues: t2 (copy), proto (copy), page_entry (copy), t1 (copy)
	local v125 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v127, v128

		v127, v128, n2 = proto.readTag(p2, n2)

		if v128 == proto.wireTypes.varint then
			local v129

			v129, n2 = proto.readVarInt(p2, n2)
		elseif v128 == proto.wireTypes.lengthDelimited then
			if v127 == 1 then
				local v130

				v130, n2 = proto.readBuffer(p2, n2)
				v125.page_entry = page_entry.PageEntry.decode(v130)
			elseif v127 == 2 then
				local v131

				v131, n2 = proto.readBuffer(p2, n2)
				v125.input_data = t1.PageEntryInputData.decode(v131)
			else
				local v132, v133 = proto.readVarInt(p2, n2)

				n2 = v133 + v132
			end
		elseif v128 == proto.wireTypes.i32 then
			local v134

			v134, n2 = proto.readFixed32(p2, n2)
		elseif v128 == proto.wireTypes.i64 then
			local v135

			v135, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v128)
		end
	end

	return v125
end
function t2.jsonEncode(p3) -- line: 3485
	local t4 = {}

	if p3.page_entry ~= nil then
		t4.pageEntry = p3.page_entry:jsonEncode()
	end

	if p3.input_data ~= nil then
		t4.inputData = p3.input_data:jsonEncode()
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 3499
	-- upvalues: t2 (copy), page_entry (copy), t1 (copy)
	local v139 = t2.new()

	if t5.page_entry ~= nil then
		v139.page_entry = page_entry.PageEntry.jsonDecode(t5.page_entry)
	end

	if t5.pageEntry ~= nil then
		v139.page_entry = page_entry.PageEntry.jsonDecode(t5.pageEntry)
	end

	if t5.input_data ~= nil then
		v139.input_data = t1.PageEntryInputData.jsonDecode(t5.input_data)
	end

	if t5.inputData ~= nil then
		v139.input_data = t1.PageEntryInputData.jsonDecode(t5.inputData)
	end

	return v139
end

t2.descriptor = {
	name = "UniversalPageEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniversalPageEntry"
}
t1.UniversalPageEntry = t2
typeRegistry.default:register(t1.UniversalPageEntry)

local t6 = {}

t6.__index = t6

function t6.new(t7: {[any]: any}?) -- line: 3535
	-- upvalues: t6 (copy)
	return (setmetatable({
		input_data = if t7 ~= nil and t7.input_data ~= nil then t7.input_data else nil,
		roblox_component = if t7 ~= nil and t7.roblox_component ~= nil then t7.roblox_component else ""
	}, t6))
end
function t6.encode(p4) -- line: 3542
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n3 = 0

	if p4.input_data ~= nil then
		local v144 = p4.input_data:encode()
		local v145, v146 = proto.writeTag(buf, n3, 1, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeBuffer(v145, v146, v144, buffer.len(v144))
	end

	if p4.roblox_component ~= nil and p4.roblox_component ~= "" then
		local v147, v148 = proto.writeTag(buf, n3, 2, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeString(v147, v148, p4.roblox_component)
	end

	local buf3 = buffer.create(n3)

	buffer.copy(buf3, 0, buf, 0, n3)

	return buf3
end
function t6.decode(p5: buffer) -- line: 3562
	-- upvalues: t6 (copy), proto (copy), t1 (copy)
	local v151 = t6.new()
	local n4 = 0

	while n4 < buffer.len(p5) do
		local v153, v154

		v153, v154, n4 = proto.readTag(p5, n4)

		if v154 == proto.wireTypes.varint then
			local v155

			v155, n4 = proto.readVarInt(p5, n4)
		elseif v154 == proto.wireTypes.lengthDelimited then
			if v153 == 1 then
				local v156

				v156, n4 = proto.readBuffer(p5, n4)
				v151.input_data = t1.PageEntryInputData.decode(v156)
			elseif v153 == 2 then
				local v157

				v157, n4 = proto.readBuffer(p5, n4)
				v151.roblox_component = buffer.tostring(v157)
			else
				local v158, v159 = proto.readVarInt(p5, n4)

				n4 = v159 + v158
			end
		elseif v154 == proto.wireTypes.i32 then
			local v160

			v160, n4 = proto.readFixed32(p5, n4)
		elseif v154 == proto.wireTypes.i64 then
			local v161

			v161, n4 = proto.readFixed64(p5, n4)
		else
			error("Unsupported wire type: " .. v154)
		end
	end

	return v151
end
function t6.jsonEncode(p6) -- line: 3610
	local t8 = {}

	if p6.input_data ~= nil then
		t8.inputData = p6.input_data:jsonEncode()
	end

	if p6.roblox_component ~= nil and p6.roblox_component ~= "" then
		t8.robloxComponent = p6.roblox_component
	end

	return t8
end
function t6.jsonDecode(t9: {[any]: any}) -- line: 3624
	-- upvalues: t6 (copy), t1 (copy)
	local v165 = t6.new()

	if t9.input_data ~= nil then
		v165.input_data = t1.PageEntryInputData.jsonDecode(t9.input_data)
	end

	if t9.inputData ~= nil then
		v165.input_data = t1.PageEntryInputData.jsonDecode(t9.inputData)
	end

	if t9.roblox_component ~= nil then
		v165.roblox_component = t9.roblox_component
	end

	if t9.robloxComponent ~= nil then
		v165.roblox_component = t9.robloxComponent
	end

	return v165
end

t6.descriptor = {
	name = "FeedEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.FeedEntry"
}
t1.FeedEntry = t6
typeRegistry.default:register(t1.FeedEntry)

local t10 = {}

t10.__index = t10

function t10.new(t11: {[any]: any}?) -- line: 3660
	-- upvalues: t10 (copy)
	return (setmetatable({
		roblox_component = if t11 ~= nil and t11.roblox_component ~= nil then t11.roblox_component else "",
		input_data = if t11 ~= nil and t11.input_data ~= nil then t11.input_data else nil
	}, t10))
end
function t10.encode(p7) -- line: 3667
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n5 = 0

	if p7.roblox_component ~= nil and p7.roblox_component ~= "" then
		local v170, v171 = proto.writeTag(buf, n5, 1, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeString(v170, v171, p7.roblox_component)
	end

	if p7.input_data ~= nil and p7.input_data.type == "attribution_row" then
		local v172 = p7.input_data.value:encode()
		local v173, v174 = proto.writeTag(buf, n5, 2, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeBuffer(v173, v174, v172, buffer.len(v172))
	end

	local buf4 = buffer.create(n5)

	buffer.copy(buf4, 0, buf, 0, n5)

	return buf4
end
function t10.decode(p8: buffer) -- line: 3689
	-- upvalues: t10 (copy), proto (copy), t1 (copy)
	local v177 = t10.new()
	local n6 = 0

	while n6 < buffer.len(p8) do
		local v179, v180

		v179, v180, n6 = proto.readTag(p8, n6)

		if v180 == proto.wireTypes.varint then
			local v181

			v181, n6 = proto.readVarInt(p8, n6)
		elseif v180 == proto.wireTypes.lengthDelimited then
			if v179 == 1 then
				local v182

				v182, n6 = proto.readBuffer(p8, n6)
				v177.roblox_component = buffer.tostring(v182)
			elseif v179 == 2 then
				local v183

				v183, n6 = proto.readBuffer(p8, n6)
				v177.input_data = {
					type = "attribution_row",
					value = t1.AttributionRowInputData.decode(v183)
				}
			else
				local v184, v185 = proto.readVarInt(p8, n6)

				n6 = v185 + v184
			end
		elseif v180 == proto.wireTypes.i32 then
			local v186

			v186, n6 = proto.readFixed32(p8, n6)
		elseif v180 == proto.wireTypes.i64 then
			local v187

			v187, n6 = proto.readFixed64(p8, n6)
		else
			error("Unsupported wire type: " .. v180)
		end
	end

	return v177
end
function t10.jsonEncode(p9) -- line: 3738
	local t12 = {}

	if p9.roblox_component ~= nil and p9.roblox_component ~= "" then
		t12.robloxComponent = p9.roblox_component
	end

	if p9.input_data ~= nil and p9.input_data.type == "attribution_row" then
		t12.attributionRow = p9.input_data.value:jsonEncode()
	end

	return t12
end
function t10.jsonDecode(t13: {[any]: any}) -- line: 3754
	-- upvalues: t10 (copy), t1 (copy)
	local v191 = t10.new()

	if t13.roblox_component ~= nil then
		v191.roblox_component = t13.roblox_component
	end

	if t13.robloxComponent ~= nil then
		v191.roblox_component = t13.robloxComponent
	end

	if t13.attribution_row ~= nil then
		v191.input_data = {
			type = "attribution_row",
			value = t1.AttributionRowInputData.jsonDecode(t13.attribution_row)
		}
	end

	if t13.attributionRow ~= nil then
		v191.input_data = {
			type = "attribution_row",
			value = t1.AttributionRowInputData.jsonDecode(t13.attributionRow)
		}
	end

	return v191
end

t10.descriptor = {
	name = "ForegroundHeaderEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.ForegroundHeaderEntry"
}
t1.ForegroundHeaderEntry = t10
typeRegistry.default:register(t1.ForegroundHeaderEntry)

local t14 = {}

t14.__index = t14

function t14.new(t15: {[any]: any}?) -- line: 3792
	-- upvalues: t14 (copy)
	return (setmetatable({
		roblox_component = if t15 ~= nil and t15.roblox_component ~= nil then t15.roblox_component else "",
		input_data = if t15 ~= nil and t15.input_data ~= nil then t15.input_data else nil
	}, t14))
end
function t14.encode(p10) -- line: 3799
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n7 = 0

	if p10.roblox_component ~= nil and p10.roblox_component ~= "" then
		local v196, v197 = proto.writeTag(buf, n7, 1, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeString(v196, v197, p10.roblox_component)
	end

	if p10.input_data ~= nil and p10.input_data.type == "image" then
		local v198 = p10.input_data.value:encode()
		local v199, v200 = proto.writeTag(buf, n7, 2, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeBuffer(v199, v200, v198, buffer.len(v198))
	end

	local buf5 = buffer.create(n7)

	buffer.copy(buf5, 0, buf, 0, n7)

	return buf5
end
function t14.decode(p11: buffer) -- line: 3821
	-- upvalues: t14 (copy), proto (copy), t1 (copy)
	local v203 = t14.new()
	local n8 = 0

	while n8 < buffer.len(p11) do
		local v205, v206

		v205, v206, n8 = proto.readTag(p11, n8)

		if v206 == proto.wireTypes.varint then
			local v207

			v207, n8 = proto.readVarInt(p11, n8)
		elseif v206 == proto.wireTypes.lengthDelimited then
			if v205 == 1 then
				local v208

				v208, n8 = proto.readBuffer(p11, n8)
				v203.roblox_component = buffer.tostring(v208)
			elseif v205 == 2 then
				local v209

				v209, n8 = proto.readBuffer(p11, n8)
				v203.input_data = {
					type = "image",
					value = t1.ImageInputData.decode(v209)
				}
			else
				local v210, v211 = proto.readVarInt(p11, n8)

				n8 = v211 + v210
			end
		elseif v206 == proto.wireTypes.i32 then
			local v212

			v212, n8 = proto.readFixed32(p11, n8)
		elseif v206 == proto.wireTypes.i64 then
			local v213

			v213, n8 = proto.readFixed64(p11, n8)
		else
			error("Unsupported wire type: " .. v206)
		end
	end

	return v203
end
function t14.jsonEncode(p12) -- line: 3869
	local t16 = {}

	if p12.roblox_component ~= nil and p12.roblox_component ~= "" then
		t16.robloxComponent = p12.roblox_component
	end

	if p12.input_data ~= nil and p12.input_data.type == "image" then
		t16.image = p12.input_data.value:jsonEncode()
	end

	return t16
end
function t14.jsonDecode(t17: {[any]: any}) -- line: 3885
	-- upvalues: t14 (copy), t1 (copy)
	local v217 = t14.new()

	if t17.roblox_component ~= nil then
		v217.roblox_component = t17.roblox_component
	end

	if t17.robloxComponent ~= nil then
		v217.roblox_component = t17.robloxComponent
	end

	if t17.image ~= nil then
		v217.input_data = {
			type = "image",
			value = t1.ImageInputData.jsonDecode(t17.image)
		}
	end

	return v217
end

t14.descriptor = {
	name = "BackgroundHeaderEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.BackgroundHeaderEntry"
}
t1.BackgroundHeaderEntry = t14
typeRegistry.default:register(t1.BackgroundHeaderEntry)

local t18 = {}

t18.__index = t18

function t18.new(t19: {[any]: any}?) -- line: 3917
	-- upvalues: t18 (copy)
	return (setmetatable({
		kind = if t19 ~= nil and t19.kind ~= nil then t19.kind else nil
	}, t18))
end
function t18.encode(p13) -- line: 3923
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n9 = 0

	if p13.kind ~= nil then
		if p13.kind.type == "badges_grid" then
			local v222 = p13.kind.value:encode()
			local v223, v224 = proto.writeTag(buf, n9, 1, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v223, v224, v222, buffer.len(v222))
		elseif p13.kind.type == "badge_details" then
			local v225 = p13.kind.value:encode()
			local v226, v227 = proto.writeTag(buf, n9, 2, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v226, v227, v225, buffer.len(v225))
		elseif p13.kind.type == "static_content" then
			local v228 = p13.kind.value:encode()
			local v229, v230 = proto.writeTag(buf, n9, 3, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v229, v230, v228, buffer.len(v228))
		elseif p13.kind.type == "experience_attribution_row" then
			local v231 = p13.kind.value:encode()
			local v232, v233 = proto.writeTag(buf, n9, 4, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v232, v233, v231, buffer.len(v231))
		elseif p13.kind.type == "experience_action_module" then
			local v234 = p13.kind.value:encode()
			local v235, v236 = proto.writeTag(buf, n9, 5, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v235, v236, v234, buffer.len(v234))
		elseif p13.kind.type == "experience_media_gallery" then
			local v237 = p13.kind.value:encode()
			local v238, v239 = proto.writeTag(buf, n9, 6, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v238, v239, v237, buffer.len(v237))
		elseif p13.kind.type == "experience_description" then
			local v240 = p13.kind.value:encode()
			local v241, v242 = proto.writeTag(buf, n9, 7, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v241, v242, v240, buffer.len(v240))
		elseif p13.kind.type == "experience_stat_row" then
			local v243 = p13.kind.value:encode()
			local v244, v245 = proto.writeTag(buf, n9, 8, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v244, v245, v243, buffer.len(v243))
		elseif p13.kind.type == "experience_info_table" then
			local v246 = p13.kind.value:encode()
			local v247, v248 = proto.writeTag(buf, n9, 9, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v247, v248, v246, buffer.len(v246))
		elseif p13.kind.type == "social_link_row" then
			local v249 = p13.kind.value:encode()
			local v250, v251 = proto.writeTag(buf, n9, 10, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v250, v251, v249, buffer.len(v249))
		elseif p13.kind.type == "experience_carousel" then
			local v252 = p13.kind.value:encode()
			local v253, v254 = proto.writeTag(buf, n9, 11, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v253, v254, v252, buffer.len(v252))
		elseif p13.kind.type == "song_carousel" then
			local v255 = p13.kind.value:encode()
			local v256, v257 = proto.writeTag(buf, n9, 12, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v256, v257, v255, buffer.len(v255))
		elseif p13.kind.type == "events_carousel" then
			local v258 = p13.kind.value:encode()
			local v259, v260 = proto.writeTag(buf, n9, 13, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v259, v260, v258, buffer.len(v258))
		elseif p13.kind.type == "game_pass_collection" then
			local v261 = p13.kind.value:encode()
			local v262, v263 = proto.writeTag(buf, n9, 14, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v262, v263, v261, buffer.len(v261))
		elseif p13.kind.type == "developer_product_collection" then
			local v264 = p13.kind.value:encode()
			local v265, v266 = proto.writeTag(buf, n9, 15, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v265, v266, v264, buffer.len(v264))
		elseif p13.kind.type == "subscription_collection" then
			local v267 = p13.kind.value:encode()
			local v268, v269 = proto.writeTag(buf, n9, 16, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v268, v269, v267, buffer.len(v267))
		elseif p13.kind.type == "card_container" then
			local v270 = p13.kind.value:encode()
			local v271, v272 = proto.writeTag(buf, n9, 20, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v271, v272, v270, buffer.len(v270))
		elseif p13.kind.type == "card" then
			local v273 = p13.kind.value:encode()
			local v274, v275 = proto.writeTag(buf, n9, 21, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v274, v275, v273, buffer.len(v273))
		elseif p13.kind.type == "dialog" then
			local v276 = p13.kind.value:encode()
			local v277, v278 = proto.writeTag(buf, n9, 22, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v277, v278, v276, buffer.len(v276))
		elseif p13.kind.type == "banner" then
			local v279 = p13.kind.value:encode()
			local v280, v281 = proto.writeTag(buf, n9, 23, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v280, v281, v279, buffer.len(v279))
		elseif p13.kind.type == "tooltip" then
			local v282 = p13.kind.value:encode()
			local v283, v284 = proto.writeTag(buf, n9, 24, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v283, v284, v282, buffer.len(v282))
		elseif p13.kind.type == "coachmark" then
			local v285 = p13.kind.value:encode()
			local v286, v287 = proto.writeTag(buf, n9, 25, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v286, v287, v285, buffer.len(v285))
		elseif p13.kind.type == "system_banner_prompt" then
			local v288 = p13.kind.value:encode()
			local v289, v290 = proto.writeTag(buf, n9, 28, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v289, v290, v288, buffer.len(v288))
		elseif p13.kind.type == "age_check_upsell" then
			local v291 = p13.kind.value:encode()
			local v292, v293 = proto.writeTag(buf, n9, 29, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v292, v293, v291, buffer.len(v291))
		elseif p13.kind.type == "catalog_item_list" then
			local v294 = p13.kind.value:encode()
			local v295, v296 = proto.writeTag(buf, n9, 26, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v295, v296, v294, buffer.len(v294))
		elseif p13.kind.type == "user_list" then
			local v297 = p13.kind.value:encode()
			local v298, v299 = proto.writeTag(buf, n9, 27, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v298, v299, v297, buffer.len(v297))
		elseif p13.kind.type == "experience_content_rating_label" then
			local v300 = p13.kind.value:encode()
			local v301, v302 = proto.writeTag(buf, n9, 30, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v301, v302, v300, buffer.len(v300))
		elseif p13.kind.type == "experience_refund_policy" then
			local v303 = p13.kind.value:encode()
			local v304, v305 = proto.writeTag(buf, n9, 31, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v304, v305, v303, buffer.len(v303))
		elseif p13.kind.type == "experience_play_with_reward" then
			local v306 = p13.kind.value:encode()
			local v307, v308 = proto.writeTag(buf, n9, 32, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v307, v308, v306, buffer.len(v306))
		elseif p13.kind.type == "experience_guidelines_dialog" then
			local v309 = p13.kind.value:encode()
			local v310, v311 = proto.writeTag(buf, n9, 33, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v310, v311, v309, buffer.len(v309))
		elseif p13.kind.type == "moments_carousel" then
			local v312 = p13.kind.value:encode()
			local v313, v314 = proto.writeTag(buf, n9, 34, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v313, v314, v312, buffer.len(v312))
		elseif p13.kind.type == "text" then
			local v315 = p13.kind.value:encode()
			local v316, v317 = proto.writeTag(buf, n9, 40, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v316, v317, v315, buffer.len(v315))
		elseif p13.kind.type == "vertical_feed" then
			local v318 = p13.kind.value:encode()
			local v319, v320 = proto.writeTag(buf, n9, 41, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v319, v320, v318, buffer.len(v318))
		elseif p13.kind.type == "page_header" then
			local v321 = p13.kind.value:encode()
			local v322, v323 = proto.writeTag(buf, n9, 42, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v322, v323, v321, buffer.len(v321))
		elseif p13.kind.type == "experience_details_feed" then
			local v324 = p13.kind.value:encode()
			local v325, v326 = proto.writeTag(buf, n9, 500, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v325, v326, v324, buffer.len(v324))
		elseif p13.kind.type == "experience_details_action_bar" then
			local v327 = p13.kind.value:encode()
			local v328, v329 = proto.writeTag(buf, n9, 501, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v328, v329, v327, buffer.len(v327))
		elseif p13.kind.type == "experience_details_banner_image" then
			local v330 = p13.kind.value:encode()
			local v331, v332 = proto.writeTag(buf, n9, 502, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v331, v332, v330, buffer.len(v330))
		elseif p13.kind.type == "experience_details_sticky_header" then
			local v333 = p13.kind.value:encode()
			local v334, v335 = proto.writeTag(buf, n9, 503, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v334, v335, v333, buffer.len(v333))
		elseif p13.kind.type == "event_details_feed" then
			local v336 = p13.kind.value:encode()
			local v337, v338 = proto.writeTag(buf, n9, 600, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v337, v338, v336, buffer.len(v336))
		elseif p13.kind.type == "event_details_action_bar" then
			local v339 = p13.kind.value:encode()
			local v340, v341 = proto.writeTag(buf, n9, 601, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v340, v341, v339, buffer.len(v339))
		elseif p13.kind.type == "event_attribution_row" then
			local v342 = p13.kind.value:encode()
			local v343, v344 = proto.writeTag(buf, n9, 602, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v343, v344, v342, buffer.len(v342))
		elseif p13.kind.type == "event_description" then
			local v345 = p13.kind.value:encode()
			local v346, v347 = proto.writeTag(buf, n9, 603, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v346, v347, v345, buffer.len(v345))
		elseif p13.kind.type == "event_info_table" then
			local v348 = p13.kind.value:encode()
			local v349, v350 = proto.writeTag(buf, n9, 604, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v349, v350, v348, buffer.len(v348))
		elseif p13.kind.type == "event_details_sheet_full_bleed" then
			local v351 = p13.kind.value:encode()
			local v352, v353 = proto.writeTag(buf, n9, 605, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v352, v353, v351, buffer.len(v351))
		elseif p13.kind.type == "event_notifications_modal" then
			local v354 = p13.kind.value:encode()
			local v355, v356 = proto.writeTag(buf, n9, 606, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v355, v356, v354, buffer.len(v354))
		elseif p13.kind.type == "dev_store_feed" then
			local v357 = p13.kind.value:encode()
			local v358, v359 = proto.writeTag(buf, n9, 700, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v358, v359, v357, buffer.len(v357))
		elseif p13.kind.type == "charts_feed" then
			local v360 = p13.kind.value:encode()
			local v361, v362 = proto.writeTag(buf, n9, 800, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v361, v362, v360, buffer.len(v360))
		elseif p13.kind.type == "filter_pills" then
			local v363 = p13.kind.value:encode()
			local v364, v365 = proto.writeTag(buf, n9, 801, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v364, v365, v363, buffer.len(v363))
		elseif p13.kind.type == "sort_selector" then
			local v366 = p13.kind.value:encode()
			local v367, v368 = proto.writeTag(buf, n9, 802, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v367, v368, v366, buffer.len(v366))
		elseif p13.kind.type == "marketplace_catalog_feed" then
			local v369 = p13.kind.value:encode()
			local v370, v371 = proto.writeTag(buf, n9, 900, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v370, v371, v369, buffer.len(v369))
		elseif p13.kind.type == "marketplace_catalog_category_menu" then
			local v372 = p13.kind.value:encode()
			local v373, v374 = proto.writeTag(buf, n9, 901, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v373, v374, v372, buffer.len(v372))
		elseif p13.kind.type == "marketplace_catalog_item_group" then
			local v375 = p13.kind.value:encode()
			local v376, v377 = proto.writeTag(buf, n9, 902, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v376, v377, v375, buffer.len(v375))
		elseif p13.kind.type == "marketplace_catalog_item_carousel" then
			local v378 = p13.kind.value:encode()
			local v379, v380 = proto.writeTag(buf, n9, 903, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v379, v380, v378, buffer.len(v378))
		elseif p13.kind.type == "marketplace_catalog_hero_unit" then
			local v381 = p13.kind.value:encode()
			local v382, v383 = proto.writeTag(buf, n9, 904, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v382, v383, v381, buffer.len(v381))
		elseif p13.kind.type == "catalog_item_grid" then
			local v384 = p13.kind.value:encode()
			local v385, v386 = proto.writeTag(buf, n9, 905, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v385, v386, v384, buffer.len(v384))
		elseif p13.kind.type == "search_results_feed" then
			local v387 = p13.kind.value:encode()
			local v388, v389 = proto.writeTag(buf, n9, 1000, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v388, v389, v387, buffer.len(v387))
		elseif p13.kind.type == "power_search_ai_overview" then
			local v390 = p13.kind.value:encode()
			local v391, v392 = proto.writeTag(buf, n9, 1001, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v391, v392, v390, buffer.len(v390))
		elseif p13.kind.type == "experience_emphasis_tile" then
			local v393 = p13.kind.value:encode()
			local v394, v395 = proto.writeTag(buf, n9, 1002, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v394, v395, v393, buffer.len(v393))
		elseif p13.kind.type == "option_selector_carousel" then
			local v396 = p13.kind.value:encode()
			local v397, v398 = proto.writeTag(buf, n9, 1100, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v397, v398, v396, buffer.len(v396))
		elseif p13.kind.type == "party_chat_conversation_upsell" then
			local v399 = p13.kind.value:encode()
			local v400, v401 = proto.writeTag(buf, n9, 1200, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v400, v401, v399, buffer.len(v399))
		end
	end

	local buf6 = buffer.create(n9)

	buffer.copy(buf6, 0, buf, 0, n9)

	return buf6
end
function t18.decode(p14: buffer) -- line: 4176
	-- upvalues: t18 (copy), proto (copy), t1 (copy)
	local v404 = t18.new()
	local n10 = 0

	while n10 < buffer.len(p14) do
		local v406, v407

		v406, v407, n10 = proto.readTag(p14, n10)

		if v407 == proto.wireTypes.varint then
			local v408

			v408, n10 = proto.readVarInt(p14, n10)
		elseif v407 == proto.wireTypes.lengthDelimited then
			if v406 == 1 then
				local v409

				v409, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "badges_grid",
					value = t1.BadgesGridInputData.decode(v409)
				}
			elseif v406 == 2 then
				local v410

				v410, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "badge_details",
					value = t1.BadgeDetailsInputData.decode(v410)
				}
			elseif v406 == 3 then
				local v411

				v411, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "static_content",
					value = t1.StaticInputData.decode(v411)
				}
			elseif v406 == 4 then
				local v412

				v412, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "experience_attribution_row",
					value = t1.ExperienceAttributionRowInputData.decode(v412)
				}
			elseif v406 == 5 then
				local v413

				v413, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "experience_action_module",
					value = t1.ExperienceActionModuleInputData.decode(v413)
				}
			elseif v406 == 6 then
				local v414

				v414, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "experience_media_gallery",
					value = t1.ExperienceMediaGalleryInputData.decode(v414)
				}
			elseif v406 == 7 then
				local v415

				v415, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "experience_description",
					value = t1.ExperienceDescriptionInputData.decode(v415)
				}
			elseif v406 == 8 then
				local v416

				v416, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "experience_stat_row",
					value = t1.ExperienceStatRowInputData.decode(v416)
				}
			elseif v406 == 9 then
				local v417

				v417, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "experience_info_table",
					value = t1.ExperienceInfoTableInputData.decode(v417)
				}
			elseif v406 == 10 then
				local v418

				v418, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "social_link_row",
					value = t1.SocialLinkRowInputData.decode(v418)
				}
			elseif v406 == 11 then
				local v419

				v419, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "experience_carousel",
					value = t1.ExperienceCarouselInputData.decode(v419)
				}
			elseif v406 == 12 then
				local v420

				v420, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "song_carousel",
					value = t1.SongCarouselInputData.decode(v420)
				}
			elseif v406 == 13 then
				local v421

				v421, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "events_carousel",
					value = t1.EventsCarouselInputData.decode(v421)
				}
			elseif v406 == 14 then
				local v422

				v422, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "game_pass_collection",
					value = t1.GamePassCollectionInputData.decode(v422)
				}
			elseif v406 == 15 then
				local v423

				v423, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "developer_product_collection",
					value = t1.DeveloperProductCollectionInputData.decode(v423)
				}
			elseif v406 == 16 then
				local v424

				v424, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "subscription_collection",
					value = t1.SubscriptionCollectionInputData.decode(v424)
				}
			elseif v406 == 20 then
				local v425

				v425, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "card_container",
					value = t1.CardContainerInputData.decode(v425)
				}
			elseif v406 == 21 then
				local v426

				v426, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "card",
					value = t1.CardInputData.decode(v426)
				}
			elseif v406 == 22 then
				local v427

				v427, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "dialog",
					value = t1.DialogInputData.decode(v427)
				}
			elseif v406 == 23 then
				local v428

				v428, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "banner",
					value = t1.BannerInputData.decode(v428)
				}
			elseif v406 == 24 then
				local v429

				v429, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "tooltip",
					value = t1.TooltipInputData.decode(v429)
				}
			elseif v406 == 25 then
				local v430

				v430, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "coachmark",
					value = t1.CoachmarkInputData.decode(v430)
				}
			elseif v406 == 26 then
				local v431

				v431, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "catalog_item_list",
					value = t1.CatalogItemListInputData.decode(v431)
				}
			elseif v406 == 27 then
				local v432

				v432, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "user_list",
					value = t1.UserListInputData.decode(v432)
				}
			elseif v406 == 28 then
				local v433

				v433, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "system_banner_prompt",
					value = t1.SystemBannerInputData.decode(v433)
				}
			elseif v406 == 29 then
				local v434

				v434, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "age_check_upsell",
					value = t1.AgeCheckUpsellInputData.decode(v434)
				}
			elseif v406 == 30 then
				local v435

				v435, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "experience_content_rating_label",
					value = t1.ExperienceContentRatingLabelInputData.decode(v435)
				}
			elseif v406 == 31 then
				local v436

				v436, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "experience_refund_policy",
					value = t1.ExperienceRefundPolicyInputData.decode(v436)
				}
			elseif v406 == 32 then
				local v437

				v437, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "experience_play_with_reward",
					value = t1.ExperiencePlayWithRewardInputData.decode(v437)
				}
			elseif v406 == 33 then
				local v438

				v438, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "experience_guidelines_dialog",
					value = t1.ExperienceGuidelinesDialogInputData.decode(v438)
				}
			elseif v406 == 34 then
				local v439

				v439, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "moments_carousel",
					value = t1.MomentsCarouselInputData.decode(v439)
				}
			elseif v406 == 40 then
				local v440

				v440, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "text",
					value = t1.TextInputData.decode(v440)
				}
			elseif v406 == 41 then
				local v441

				v441, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "vertical_feed",
					value = t1.VerticalFeedInputData.decode(v441)
				}
			elseif v406 == 42 then
				local v442

				v442, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "page_header",
					value = t1.PageHeaderInputData.decode(v442)
				}
			elseif v406 == 500 then
				local v443

				v443, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "experience_details_feed",
					value = t1.ExperienceDetailsFeedInputData.decode(v443)
				}
			elseif v406 == 501 then
				local v444

				v444, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "experience_details_action_bar",
					value = t1.ExperienceDetailsActionBarInputData.decode(v444)
				}
			elseif v406 == 502 then
				local v445

				v445, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "experience_details_banner_image",
					value = t1.ExperienceDetailsBannerImageInputData.decode(v445)
				}
			elseif v406 == 503 then
				local v446

				v446, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "experience_details_sticky_header",
					value = t1.ExperienceDetailsStickyHeaderInputData.decode(v446)
				}
			elseif v406 == 600 then
				local v447

				v447, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "event_details_feed",
					value = t1.EventDetailsFeedInputData.decode(v447)
				}
			elseif v406 == 601 then
				local v448

				v448, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "event_details_action_bar",
					value = t1.EventDetailsActionBarInputData.decode(v448)
				}
			elseif v406 == 602 then
				local v449

				v449, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "event_attribution_row",
					value = t1.EventAttributionRowInputData.decode(v449)
				}
			elseif v406 == 603 then
				local v450

				v450, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "event_description",
					value = t1.EventDescriptionInputData.decode(v450)
				}
			elseif v406 == 604 then
				local v451

				v451, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "event_info_table",
					value = t1.EventInfoTableInputData.decode(v451)
				}
			elseif v406 == 605 then
				local v452

				v452, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "event_details_sheet_full_bleed",
					value = t1.EventDetailsSheetFullBleedInputData.decode(v452)
				}
			elseif v406 == 606 then
				local v453

				v453, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "event_notifications_modal",
					value = t1.EventNotificationsModalInputData.decode(v453)
				}
			elseif v406 == 700 then
				local v454

				v454, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "dev_store_feed",
					value = t1.DevStoreFeedInputData.decode(v454)
				}
			elseif v406 == 800 then
				local v455

				v455, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "charts_feed",
					value = t1.ChartsFeedInputData.decode(v455)
				}
			elseif v406 == 801 then
				local v456

				v456, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "filter_pills",
					value = t1.FilterPillsInputData.decode(v456)
				}
			elseif v406 == 802 then
				local v457

				v457, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "sort_selector",
					value = t1.SortSelectorInputData.decode(v457)
				}
			elseif v406 == 900 then
				local v458

				v458, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "marketplace_catalog_feed",
					value = t1.UAMarketplaceCatalogFeedInputData.decode(v458)
				}
			elseif v406 == 901 then
				local v459

				v459, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "marketplace_catalog_category_menu",
					value = t1.UAMarketplaceCatalogCategoryMenuInputData.decode(v459)
				}
			elseif v406 == 902 then
				local v460

				v460, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "marketplace_catalog_item_group",
					value = t1.UAMarketplaceCatalogItemGroupInputData.decode(v460)
				}
			elseif v406 == 903 then
				local v461

				v461, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "marketplace_catalog_item_carousel",
					value = t1.UAMarketplaceCatalogItemCarouselInputData.decode(v461)
				}
			elseif v406 == 904 then
				local v462

				v462, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "marketplace_catalog_hero_unit",
					value = t1.UAMarketplaceCatalogHeroUnitInputData.decode(v462)
				}
			elseif v406 == 905 then
				local v463

				v463, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "catalog_item_grid",
					value = t1.CatalogItemGridInputData.decode(v463)
				}
			elseif v406 == 1000 then
				local v464

				v464, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "search_results_feed",
					value = t1.SearchResultsFeedInputData.decode(v464)
				}
			elseif v406 == 1001 then
				local v465

				v465, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "power_search_ai_overview",
					value = t1.PowerSearchAIOverviewInputData.decode(v465)
				}
			elseif v406 == 1002 then
				local v466

				v466, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "experience_emphasis_tile",
					value = t1.ExperienceEmphasisTileInputData.decode(v466)
				}
			elseif v406 == 1100 then
				local v467

				v467, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "option_selector_carousel",
					value = t1.OptionSelectorCarouselInputData.decode(v467)
				}
			elseif v406 == 1200 then
				local v468

				v468, n10 = proto.readBuffer(p14, n10)
				v404.kind = {
					type = "party_chat_conversation_upsell",
					value = t1.PartyChatConversationUpsellInputData.decode(v468)
				}
			else
				local v469, v470 = proto.readVarInt(p14, n10)

				n10 = v470 + v469
			end
		elseif v407 == proto.wireTypes.i32 then
			local v471

			v471, n10 = proto.readFixed32(p14, n10)
		elseif v407 == proto.wireTypes.i64 then
			local v472

			v472, n10 = proto.readFixed64(p14, n10)
		else
			error("Unsupported wire type: " .. v407)
		end
	end

	return v404
end
function t18.jsonEncode(p15) -- line: 4599
	local t20 = {}

	if p15.kind ~= nil then
		if p15.kind.type == "badges_grid" then
			t20.badgesGrid = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "badge_details" then
			t20.badgeDetails = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "static_content" then
			t20.staticContent = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "experience_attribution_row" then
			t20.experienceAttributionRow = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "experience_action_module" then
			t20.experienceActionModule = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "experience_media_gallery" then
			t20.experienceMediaGallery = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "experience_description" then
			t20.experienceDescription = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "experience_stat_row" then
			t20.experienceStatRow = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "experience_info_table" then
			t20.experienceInfoTable = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "social_link_row" then
			t20.socialLinkRow = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "experience_carousel" then
			t20.experienceCarousel = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "song_carousel" then
			t20.songCarousel = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "events_carousel" then
			t20.eventsCarousel = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "game_pass_collection" then
			t20.gamePassCollection = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "developer_product_collection" then
			t20.developerProductCollection = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "subscription_collection" then
			t20.subscriptionCollection = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "card_container" then
			t20.cardContainer = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "card" then
			t20.card = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "dialog" then
			t20.dialog = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "banner" then
			t20.banner = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "tooltip" then
			t20.tooltip = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "coachmark" then
			t20.coachmark = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "system_banner_prompt" then
			t20.systemBannerPrompt = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "age_check_upsell" then
			t20.ageCheckUpsell = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "catalog_item_list" then
			t20.catalogItemList = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "user_list" then
			t20.userList = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "experience_content_rating_label" then
			t20.experienceContentRatingLabel = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "experience_refund_policy" then
			t20.experienceRefundPolicy = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "experience_play_with_reward" then
			t20.experiencePlayWithReward = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "experience_guidelines_dialog" then
			t20.experienceGuidelinesDialog = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "moments_carousel" then
			t20.momentsCarousel = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "text" then
			t20.text = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "vertical_feed" then
			t20.verticalFeed = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "page_header" then
			t20.pageHeader = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "experience_details_feed" then
			t20.experienceDetailsFeed = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "experience_details_action_bar" then
			t20.experienceDetailsActionBar = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "experience_details_banner_image" then
			t20.experienceDetailsBannerImage = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "experience_details_sticky_header" then
			t20.experienceDetailsStickyHeader = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "event_details_feed" then
			t20.eventDetailsFeed = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "event_details_action_bar" then
			t20.eventDetailsActionBar = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "event_attribution_row" then
			t20.eventAttributionRow = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "event_description" then
			t20.eventDescription = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "event_info_table" then
			t20.eventInfoTable = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "event_details_sheet_full_bleed" then
			t20.eventDetailsSheetFullBleed = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "event_notifications_modal" then
			t20.eventNotificationsModal = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "dev_store_feed" then
			t20.devStoreFeed = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "charts_feed" then
			t20.chartsFeed = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "filter_pills" then
			t20.filterPills = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "sort_selector" then
			t20.sortSelector = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "marketplace_catalog_feed" then
			t20.marketplaceCatalogFeed = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "marketplace_catalog_category_menu" then
			t20.marketplaceCatalogCategoryMenu = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "marketplace_catalog_item_group" then
			t20.marketplaceCatalogItemGroup = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "marketplace_catalog_item_carousel" then
			t20.marketplaceCatalogItemCarousel = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "marketplace_catalog_hero_unit" then
			t20.marketplaceCatalogHeroUnit = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "catalog_item_grid" then
			t20.catalogItemGrid = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "search_results_feed" then
			t20.searchResultsFeed = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "power_search_ai_overview" then
			t20.powerSearchAiOverview = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "experience_emphasis_tile" then
			t20.experienceEmphasisTile = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "option_selector_carousel" then
			t20.optionSelectorCarousel = p15.kind.value:jsonEncode()

			return t20
		end

		if p15.kind.type == "party_chat_conversation_upsell" then
			t20.partyChatConversationUpsell = p15.kind.value:jsonEncode()
		end
	end

	return t20
end
function t18.jsonDecode(t21: {[any]: any}) -- line: 4729
	-- upvalues: t18 (copy), t1 (copy)
	local v476 = t18.new()

	if t21.badges_grid ~= nil then
		v476.kind = {
			type = "badges_grid",
			value = t1.BadgesGridInputData.jsonDecode(t21.badges_grid)
		}
	end

	if t21.badgesGrid ~= nil then
		v476.kind = {
			type = "badges_grid",
			value = t1.BadgesGridInputData.jsonDecode(t21.badgesGrid)
		}
	end

	if t21.badge_details ~= nil then
		v476.kind = {
			type = "badge_details",
			value = t1.BadgeDetailsInputData.jsonDecode(t21.badge_details)
		}
	end

	if t21.badgeDetails ~= nil then
		v476.kind = {
			type = "badge_details",
			value = t1.BadgeDetailsInputData.jsonDecode(t21.badgeDetails)
		}
	end

	if t21.static_content ~= nil then
		v476.kind = {
			type = "static_content",
			value = t1.StaticInputData.jsonDecode(t21.static_content)
		}
	end

	if t21.staticContent ~= nil then
		v476.kind = {
			type = "static_content",
			value = t1.StaticInputData.jsonDecode(t21.staticContent)
		}
	end

	if t21.experience_attribution_row ~= nil then
		v476.kind = {
			type = "experience_attribution_row",
			value = t1.ExperienceAttributionRowInputData.jsonDecode(t21.experience_attribution_row)
		}
	end

	if t21.experienceAttributionRow ~= nil then
		v476.kind = {
			type = "experience_attribution_row",
			value = t1.ExperienceAttributionRowInputData.jsonDecode(t21.experienceAttributionRow)
		}
	end

	if t21.experience_action_module ~= nil then
		v476.kind = {
			type = "experience_action_module",
			value = t1.ExperienceActionModuleInputData.jsonDecode(t21.experience_action_module)
		}
	end

	if t21.experienceActionModule ~= nil then
		v476.kind = {
			type = "experience_action_module",
			value = t1.ExperienceActionModuleInputData.jsonDecode(t21.experienceActionModule)
		}
	end

	if t21.experience_media_gallery ~= nil then
		v476.kind = {
			type = "experience_media_gallery",
			value = t1.ExperienceMediaGalleryInputData.jsonDecode(t21.experience_media_gallery)
		}
	end

	if t21.experienceMediaGallery ~= nil then
		v476.kind = {
			type = "experience_media_gallery",
			value = t1.ExperienceMediaGalleryInputData.jsonDecode(t21.experienceMediaGallery)
		}
	end

	if t21.experience_description ~= nil then
		v476.kind = {
			type = "experience_description",
			value = t1.ExperienceDescriptionInputData.jsonDecode(t21.experience_description)
		}
	end

	if t21.experienceDescription ~= nil then
		v476.kind = {
			type = "experience_description",
			value = t1.ExperienceDescriptionInputData.jsonDecode(t21.experienceDescription)
		}
	end

	if t21.experience_stat_row ~= nil then
		v476.kind = {
			type = "experience_stat_row",
			value = t1.ExperienceStatRowInputData.jsonDecode(t21.experience_stat_row)
		}
	end

	if t21.experienceStatRow ~= nil then
		v476.kind = {
			type = "experience_stat_row",
			value = t1.ExperienceStatRowInputData.jsonDecode(t21.experienceStatRow)
		}
	end

	if t21.experience_info_table ~= nil then
		v476.kind = {
			type = "experience_info_table",
			value = t1.ExperienceInfoTableInputData.jsonDecode(t21.experience_info_table)
		}
	end

	if t21.experienceInfoTable ~= nil then
		v476.kind = {
			type = "experience_info_table",
			value = t1.ExperienceInfoTableInputData.jsonDecode(t21.experienceInfoTable)
		}
	end

	if t21.social_link_row ~= nil then
		v476.kind = {
			type = "social_link_row",
			value = t1.SocialLinkRowInputData.jsonDecode(t21.social_link_row)
		}
	end

	if t21.socialLinkRow ~= nil then
		v476.kind = {
			type = "social_link_row",
			value = t1.SocialLinkRowInputData.jsonDecode(t21.socialLinkRow)
		}
	end

	if t21.experience_carousel ~= nil then
		v476.kind = {
			type = "experience_carousel",
			value = t1.ExperienceCarouselInputData.jsonDecode(t21.experience_carousel)
		}
	end

	if t21.experienceCarousel ~= nil then
		v476.kind = {
			type = "experience_carousel",
			value = t1.ExperienceCarouselInputData.jsonDecode(t21.experienceCarousel)
		}
	end

	if t21.song_carousel ~= nil then
		v476.kind = {
			type = "song_carousel",
			value = t1.SongCarouselInputData.jsonDecode(t21.song_carousel)
		}
	end

	if t21.songCarousel ~= nil then
		v476.kind = {
			type = "song_carousel",
			value = t1.SongCarouselInputData.jsonDecode(t21.songCarousel)
		}
	end

	if t21.events_carousel ~= nil then
		v476.kind = {
			type = "events_carousel",
			value = t1.EventsCarouselInputData.jsonDecode(t21.events_carousel)
		}
	end

	if t21.eventsCarousel ~= nil then
		v476.kind = {
			type = "events_carousel",
			value = t1.EventsCarouselInputData.jsonDecode(t21.eventsCarousel)
		}
	end

	if t21.game_pass_collection ~= nil then
		v476.kind = {
			type = "game_pass_collection",
			value = t1.GamePassCollectionInputData.jsonDecode(t21.game_pass_collection)
		}
	end

	if t21.gamePassCollection ~= nil then
		v476.kind = {
			type = "game_pass_collection",
			value = t1.GamePassCollectionInputData.jsonDecode(t21.gamePassCollection)
		}
	end

	if t21.developer_product_collection ~= nil then
		v476.kind = {
			type = "developer_product_collection",
			value = t1.DeveloperProductCollectionInputData.jsonDecode(t21.developer_product_collection)
		}
	end

	if t21.developerProductCollection ~= nil then
		v476.kind = {
			type = "developer_product_collection",
			value = t1.DeveloperProductCollectionInputData.jsonDecode(t21.developerProductCollection)
		}
	end

	if t21.subscription_collection ~= nil then
		v476.kind = {
			type = "subscription_collection",
			value = t1.SubscriptionCollectionInputData.jsonDecode(t21.subscription_collection)
		}
	end

	if t21.subscriptionCollection ~= nil then
		v476.kind = {
			type = "subscription_collection",
			value = t1.SubscriptionCollectionInputData.jsonDecode(t21.subscriptionCollection)
		}
	end

	if t21.card_container ~= nil then
		v476.kind = {
			type = "card_container",
			value = t1.CardContainerInputData.jsonDecode(t21.card_container)
		}
	end

	if t21.cardContainer ~= nil then
		v476.kind = {
			type = "card_container",
			value = t1.CardContainerInputData.jsonDecode(t21.cardContainer)
		}
	end

	if t21.card ~= nil then
		v476.kind = {
			type = "card",
			value = t1.CardInputData.jsonDecode(t21.card)
		}
	end

	if t21.dialog ~= nil then
		v476.kind = {
			type = "dialog",
			value = t1.DialogInputData.jsonDecode(t21.dialog)
		}
	end

	if t21.banner ~= nil then
		v476.kind = {
			type = "banner",
			value = t1.BannerInputData.jsonDecode(t21.banner)
		}
	end

	if t21.tooltip ~= nil then
		v476.kind = {
			type = "tooltip",
			value = t1.TooltipInputData.jsonDecode(t21.tooltip)
		}
	end

	if t21.coachmark ~= nil then
		v476.kind = {
			type = "coachmark",
			value = t1.CoachmarkInputData.jsonDecode(t21.coachmark)
		}
	end

	if t21.system_banner_prompt ~= nil then
		v476.kind = {
			type = "system_banner_prompt",
			value = t1.SystemBannerInputData.jsonDecode(t21.system_banner_prompt)
		}
	end

	if t21.systemBannerPrompt ~= nil then
		v476.kind = {
			type = "system_banner_prompt",
			value = t1.SystemBannerInputData.jsonDecode(t21.systemBannerPrompt)
		}
	end

	if t21.age_check_upsell ~= nil then
		v476.kind = {
			type = "age_check_upsell",
			value = t1.AgeCheckUpsellInputData.jsonDecode(t21.age_check_upsell)
		}
	end

	if t21.ageCheckUpsell ~= nil then
		v476.kind = {
			type = "age_check_upsell",
			value = t1.AgeCheckUpsellInputData.jsonDecode(t21.ageCheckUpsell)
		}
	end

	if t21.catalog_item_list ~= nil then
		v476.kind = {
			type = "catalog_item_list",
			value = t1.CatalogItemListInputData.jsonDecode(t21.catalog_item_list)
		}
	end

	if t21.catalogItemList ~= nil then
		v476.kind = {
			type = "catalog_item_list",
			value = t1.CatalogItemListInputData.jsonDecode(t21.catalogItemList)
		}
	end

	if t21.user_list ~= nil then
		v476.kind = {
			type = "user_list",
			value = t1.UserListInputData.jsonDecode(t21.user_list)
		}
	end

	if t21.userList ~= nil then
		v476.kind = {
			type = "user_list",
			value = t1.UserListInputData.jsonDecode(t21.userList)
		}
	end

	if t21.experience_content_rating_label ~= nil then
		v476.kind = {
			type = "experience_content_rating_label",
			value = t1.ExperienceContentRatingLabelInputData.jsonDecode(t21.experience_content_rating_label)
		}
	end

	if t21.experienceContentRatingLabel ~= nil then
		v476.kind = {
			type = "experience_content_rating_label",
			value = t1.ExperienceContentRatingLabelInputData.jsonDecode(t21.experienceContentRatingLabel)
		}
	end

	if t21.experience_refund_policy ~= nil then
		v476.kind = {
			type = "experience_refund_policy",
			value = t1.ExperienceRefundPolicyInputData.jsonDecode(t21.experience_refund_policy)
		}
	end

	if t21.experienceRefundPolicy ~= nil then
		v476.kind = {
			type = "experience_refund_policy",
			value = t1.ExperienceRefundPolicyInputData.jsonDecode(t21.experienceRefundPolicy)
		}
	end

	if t21.experience_play_with_reward ~= nil then
		v476.kind = {
			type = "experience_play_with_reward",
			value = t1.ExperiencePlayWithRewardInputData.jsonDecode(t21.experience_play_with_reward)
		}
	end

	if t21.experiencePlayWithReward ~= nil then
		v476.kind = {
			type = "experience_play_with_reward",
			value = t1.ExperiencePlayWithRewardInputData.jsonDecode(t21.experiencePlayWithReward)
		}
	end

	if t21.experience_guidelines_dialog ~= nil then
		v476.kind = {
			type = "experience_guidelines_dialog",
			value = t1.ExperienceGuidelinesDialogInputData.jsonDecode(t21.experience_guidelines_dialog)
		}
	end

	if t21.experienceGuidelinesDialog ~= nil then
		v476.kind = {
			type = "experience_guidelines_dialog",
			value = t1.ExperienceGuidelinesDialogInputData.jsonDecode(t21.experienceGuidelinesDialog)
		}
	end

	if t21.moments_carousel ~= nil then
		v476.kind = {
			type = "moments_carousel",
			value = t1.MomentsCarouselInputData.jsonDecode(t21.moments_carousel)
		}
	end

	if t21.momentsCarousel ~= nil then
		v476.kind = {
			type = "moments_carousel",
			value = t1.MomentsCarouselInputData.jsonDecode(t21.momentsCarousel)
		}
	end

	if t21.text ~= nil then
		v476.kind = {
			type = "text",
			value = t1.TextInputData.jsonDecode(t21.text)
		}
	end

	if t21.vertical_feed ~= nil then
		v476.kind = {
			type = "vertical_feed",
			value = t1.VerticalFeedInputData.jsonDecode(t21.vertical_feed)
		}
	end

	if t21.verticalFeed ~= nil then
		v476.kind = {
			type = "vertical_feed",
			value = t1.VerticalFeedInputData.jsonDecode(t21.verticalFeed)
		}
	end

	if t21.page_header ~= nil then
		v476.kind = {
			type = "page_header",
			value = t1.PageHeaderInputData.jsonDecode(t21.page_header)
		}
	end

	if t21.pageHeader ~= nil then
		v476.kind = {
			type = "page_header",
			value = t1.PageHeaderInputData.jsonDecode(t21.pageHeader)
		}
	end

	if t21.experience_details_feed ~= nil then
		v476.kind = {
			type = "experience_details_feed",
			value = t1.ExperienceDetailsFeedInputData.jsonDecode(t21.experience_details_feed)
		}
	end

	if t21.experienceDetailsFeed ~= nil then
		v476.kind = {
			type = "experience_details_feed",
			value = t1.ExperienceDetailsFeedInputData.jsonDecode(t21.experienceDetailsFeed)
		}
	end

	if t21.experience_details_action_bar ~= nil then
		v476.kind = {
			type = "experience_details_action_bar",
			value = t1.ExperienceDetailsActionBarInputData.jsonDecode(t21.experience_details_action_bar)
		}
	end

	if t21.experienceDetailsActionBar ~= nil then
		v476.kind = {
			type = "experience_details_action_bar",
			value = t1.ExperienceDetailsActionBarInputData.jsonDecode(t21.experienceDetailsActionBar)
		}
	end

	if t21.experience_details_banner_image ~= nil then
		v476.kind = {
			type = "experience_details_banner_image",
			value = t1.ExperienceDetailsBannerImageInputData.jsonDecode(t21.experience_details_banner_image)
		}
	end

	if t21.experienceDetailsBannerImage ~= nil then
		v476.kind = {
			type = "experience_details_banner_image",
			value = t1.ExperienceDetailsBannerImageInputData.jsonDecode(t21.experienceDetailsBannerImage)
		}
	end

	if t21.experience_details_sticky_header ~= nil then
		v476.kind = {
			type = "experience_details_sticky_header",
			value = t1.ExperienceDetailsStickyHeaderInputData.jsonDecode(t21.experience_details_sticky_header)
		}
	end

	if t21.experienceDetailsStickyHeader ~= nil then
		v476.kind = {
			type = "experience_details_sticky_header",
			value = t1.ExperienceDetailsStickyHeaderInputData.jsonDecode(t21.experienceDetailsStickyHeader)
		}
	end

	if t21.event_details_feed ~= nil then
		v476.kind = {
			type = "event_details_feed",
			value = t1.EventDetailsFeedInputData.jsonDecode(t21.event_details_feed)
		}
	end

	if t21.eventDetailsFeed ~= nil then
		v476.kind = {
			type = "event_details_feed",
			value = t1.EventDetailsFeedInputData.jsonDecode(t21.eventDetailsFeed)
		}
	end

	if t21.event_details_action_bar ~= nil then
		v476.kind = {
			type = "event_details_action_bar",
			value = t1.EventDetailsActionBarInputData.jsonDecode(t21.event_details_action_bar)
		}
	end

	if t21.eventDetailsActionBar ~= nil then
		v476.kind = {
			type = "event_details_action_bar",
			value = t1.EventDetailsActionBarInputData.jsonDecode(t21.eventDetailsActionBar)
		}
	end

	if t21.event_attribution_row ~= nil then
		v476.kind = {
			type = "event_attribution_row",
			value = t1.EventAttributionRowInputData.jsonDecode(t21.event_attribution_row)
		}
	end

	if t21.eventAttributionRow ~= nil then
		v476.kind = {
			type = "event_attribution_row",
			value = t1.EventAttributionRowInputData.jsonDecode(t21.eventAttributionRow)
		}
	end

	if t21.event_description ~= nil then
		v476.kind = {
			type = "event_description",
			value = t1.EventDescriptionInputData.jsonDecode(t21.event_description)
		}
	end

	if t21.eventDescription ~= nil then
		v476.kind = {
			type = "event_description",
			value = t1.EventDescriptionInputData.jsonDecode(t21.eventDescription)
		}
	end

	if t21.event_info_table ~= nil then
		v476.kind = {
			type = "event_info_table",
			value = t1.EventInfoTableInputData.jsonDecode(t21.event_info_table)
		}
	end

	if t21.eventInfoTable ~= nil then
		v476.kind = {
			type = "event_info_table",
			value = t1.EventInfoTableInputData.jsonDecode(t21.eventInfoTable)
		}
	end

	if t21.event_details_sheet_full_bleed ~= nil then
		v476.kind = {
			type = "event_details_sheet_full_bleed",
			value = t1.EventDetailsSheetFullBleedInputData.jsonDecode(t21.event_details_sheet_full_bleed)
		}
	end

	if t21.eventDetailsSheetFullBleed ~= nil then
		v476.kind = {
			type = "event_details_sheet_full_bleed",
			value = t1.EventDetailsSheetFullBleedInputData.jsonDecode(t21.eventDetailsSheetFullBleed)
		}
	end

	if t21.event_notifications_modal ~= nil then
		v476.kind = {
			type = "event_notifications_modal",
			value = t1.EventNotificationsModalInputData.jsonDecode(t21.event_notifications_modal)
		}
	end

	if t21.eventNotificationsModal ~= nil then
		v476.kind = {
			type = "event_notifications_modal",
			value = t1.EventNotificationsModalInputData.jsonDecode(t21.eventNotificationsModal)
		}
	end

	if t21.dev_store_feed ~= nil then
		v476.kind = {
			type = "dev_store_feed",
			value = t1.DevStoreFeedInputData.jsonDecode(t21.dev_store_feed)
		}
	end

	if t21.devStoreFeed ~= nil then
		v476.kind = {
			type = "dev_store_feed",
			value = t1.DevStoreFeedInputData.jsonDecode(t21.devStoreFeed)
		}
	end

	if t21.charts_feed ~= nil then
		v476.kind = {
			type = "charts_feed",
			value = t1.ChartsFeedInputData.jsonDecode(t21.charts_feed)
		}
	end

	if t21.chartsFeed ~= nil then
		v476.kind = {
			type = "charts_feed",
			value = t1.ChartsFeedInputData.jsonDecode(t21.chartsFeed)
		}
	end

	if t21.filter_pills ~= nil then
		v476.kind = {
			type = "filter_pills",
			value = t1.FilterPillsInputData.jsonDecode(t21.filter_pills)
		}
	end

	if t21.filterPills ~= nil then
		v476.kind = {
			type = "filter_pills",
			value = t1.FilterPillsInputData.jsonDecode(t21.filterPills)
		}
	end

	if t21.sort_selector ~= nil then
		v476.kind = {
			type = "sort_selector",
			value = t1.SortSelectorInputData.jsonDecode(t21.sort_selector)
		}
	end

	if t21.sortSelector ~= nil then
		v476.kind = {
			type = "sort_selector",
			value = t1.SortSelectorInputData.jsonDecode(t21.sortSelector)
		}
	end

	if t21.marketplace_catalog_feed ~= nil then
		v476.kind = {
			type = "marketplace_catalog_feed",
			value = t1.UAMarketplaceCatalogFeedInputData.jsonDecode(t21.marketplace_catalog_feed)
		}
	end

	if t21.marketplaceCatalogFeed ~= nil then
		v476.kind = {
			type = "marketplace_catalog_feed",
			value = t1.UAMarketplaceCatalogFeedInputData.jsonDecode(t21.marketplaceCatalogFeed)
		}
	end

	if t21.marketplace_catalog_category_menu ~= nil then
		v476.kind = {
			type = "marketplace_catalog_category_menu",
			value = t1.UAMarketplaceCatalogCategoryMenuInputData.jsonDecode(t21.marketplace_catalog_category_menu)
		}
	end

	if t21.marketplaceCatalogCategoryMenu ~= nil then
		v476.kind = {
			type = "marketplace_catalog_category_menu",
			value = t1.UAMarketplaceCatalogCategoryMenuInputData.jsonDecode(t21.marketplaceCatalogCategoryMenu)
		}
	end

	if t21.marketplace_catalog_item_group ~= nil then
		v476.kind = {
			type = "marketplace_catalog_item_group",
			value = t1.UAMarketplaceCatalogItemGroupInputData.jsonDecode(t21.marketplace_catalog_item_group)
		}
	end

	if t21.marketplaceCatalogItemGroup ~= nil then
		v476.kind = {
			type = "marketplace_catalog_item_group",
			value = t1.UAMarketplaceCatalogItemGroupInputData.jsonDecode(t21.marketplaceCatalogItemGroup)
		}
	end

	if t21.marketplace_catalog_item_carousel ~= nil then
		v476.kind = {
			type = "marketplace_catalog_item_carousel",
			value = t1.UAMarketplaceCatalogItemCarouselInputData.jsonDecode(t21.marketplace_catalog_item_carousel)
		}
	end

	if t21.marketplaceCatalogItemCarousel ~= nil then
		v476.kind = {
			type = "marketplace_catalog_item_carousel",
			value = t1.UAMarketplaceCatalogItemCarouselInputData.jsonDecode(t21.marketplaceCatalogItemCarousel)
		}
	end

	if t21.marketplace_catalog_hero_unit ~= nil then
		v476.kind = {
			type = "marketplace_catalog_hero_unit",
			value = t1.UAMarketplaceCatalogHeroUnitInputData.jsonDecode(t21.marketplace_catalog_hero_unit)
		}
	end

	if t21.marketplaceCatalogHeroUnit ~= nil then
		v476.kind = {
			type = "marketplace_catalog_hero_unit",
			value = t1.UAMarketplaceCatalogHeroUnitInputData.jsonDecode(t21.marketplaceCatalogHeroUnit)
		}
	end

	if t21.catalog_item_grid ~= nil then
		v476.kind = {
			type = "catalog_item_grid",
			value = t1.CatalogItemGridInputData.jsonDecode(t21.catalog_item_grid)
		}
	end

	if t21.catalogItemGrid ~= nil then
		v476.kind = {
			type = "catalog_item_grid",
			value = t1.CatalogItemGridInputData.jsonDecode(t21.catalogItemGrid)
		}
	end

	if t21.search_results_feed ~= nil then
		v476.kind = {
			type = "search_results_feed",
			value = t1.SearchResultsFeedInputData.jsonDecode(t21.search_results_feed)
		}
	end

	if t21.searchResultsFeed ~= nil then
		v476.kind = {
			type = "search_results_feed",
			value = t1.SearchResultsFeedInputData.jsonDecode(t21.searchResultsFeed)
		}
	end

	if t21.power_search_ai_overview ~= nil then
		v476.kind = {
			type = "power_search_ai_overview",
			value = t1.PowerSearchAIOverviewInputData.jsonDecode(t21.power_search_ai_overview)
		}
	end

	if t21.powerSearchAiOverview ~= nil then
		v476.kind = {
			type = "power_search_ai_overview",
			value = t1.PowerSearchAIOverviewInputData.jsonDecode(t21.powerSearchAiOverview)
		}
	end

	if t21.experience_emphasis_tile ~= nil then
		v476.kind = {
			type = "experience_emphasis_tile",
			value = t1.ExperienceEmphasisTileInputData.jsonDecode(t21.experience_emphasis_tile)
		}
	end

	if t21.experienceEmphasisTile ~= nil then
		v476.kind = {
			type = "experience_emphasis_tile",
			value = t1.ExperienceEmphasisTileInputData.jsonDecode(t21.experienceEmphasisTile)
		}
	end

	if t21.option_selector_carousel ~= nil then
		v476.kind = {
			type = "option_selector_carousel",
			value = t1.OptionSelectorCarouselInputData.jsonDecode(t21.option_selector_carousel)
		}
	end

	if t21.optionSelectorCarousel ~= nil then
		v476.kind = {
			type = "option_selector_carousel",
			value = t1.OptionSelectorCarouselInputData.jsonDecode(t21.optionSelectorCarousel)
		}
	end

	if t21.party_chat_conversation_upsell ~= nil then
		v476.kind = {
			type = "party_chat_conversation_upsell",
			value = t1.PartyChatConversationUpsellInputData.jsonDecode(t21.party_chat_conversation_upsell)
		}
	end

	if t21.partyChatConversationUpsell ~= nil then
		v476.kind = {
			type = "party_chat_conversation_upsell",
			value = t1.PartyChatConversationUpsellInputData.jsonDecode(t21.partyChatConversationUpsell)
		}
	end

	return v476
end

t18.descriptor = {
	name = "PageEntryInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.PageEntryInputData"
}
t1.PageEntryInputData = t18
typeRegistry.default:register(t1.PageEntryInputData)

local t22 = {}

t22.__index = t22

function t22.new(t23: {[any]: any}?) -- line: 5473
	-- upvalues: t22 (copy)
	return (setmetatable({
		section_title = if t23 ~= nil and t23.section_title ~= nil then t23.section_title else "",
		badges = if t23 ~= nil and t23.badges ~= nil then t23.badges else {},
		collection_id = if t23 ~= nil and t23.collection_id ~= nil then t23.collection_id else "",
		collection_position = if t23 ~= nil and t23.collection_position ~= nil then t23.collection_position else "",
		universe_id = if t23 ~= nil and t23.universe_id ~= nil then t23.universe_id else ""
	}, t22))
end
function t22.encode(p16) -- line: 5485
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n11 = 0

	if p16.section_title ~= nil and p16.section_title ~= "" then
		local v481, v482 = proto.writeTag(buf, n11, 1, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeString(v481, v482, p16.section_title)
	end

	if p16.badges ~= nil and #p16.badges > 0 then
		for _, v484 in p16.badges do
			local v485 = v484:encode()
			local v486, v487 = proto.writeTag(buf, n11, 2, proto.wireTypes.lengthDelimited)

			buf, n11 = proto.writeBuffer(v486, v487, v485, buffer.len(v485))
		end
	end

	if p16.collection_id ~= nil and p16.collection_id ~= "" then
		local v488, v489 = proto.writeTag(buf, n11, 3, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeString(v488, v489, p16.collection_id)
	end

	if p16.collection_position ~= nil and p16.collection_position ~= "" then
		local v490, v491 = proto.writeTag(buf, n11, 4, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeString(v490, v491, p16.collection_position)
	end

	if p16.universe_id ~= nil and p16.universe_id ~= "" then
		local v492, v493 = proto.writeTag(buf, n11, 5, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeString(v492, v493, p16.universe_id)
	end

	local buf7 = buffer.create(n11)

	buffer.copy(buf7, 0, buf, 0, n11)

	return buf7
end
function t22.decode(p17: buffer) -- line: 5522
	-- upvalues: t22 (copy), proto (copy), t1 (copy)
	local v496 = t22.new()
	local n12 = 0

	while n12 < buffer.len(p17) do
		local v498, v499

		v498, v499, n12 = proto.readTag(p17, n12)

		if v499 == proto.wireTypes.varint then
			local v500

			v500, n12 = proto.readVarInt(p17, n12)
		elseif v499 == proto.wireTypes.lengthDelimited then
			if v498 == 1 then
				local v501

				v501, n12 = proto.readBuffer(p17, n12)
				v496.section_title = buffer.tostring(v501)
			elseif v498 == 2 then
				local v502

				v502, n12 = proto.readBuffer(p17, n12)
				table.insert(v496.badges, t1.BadgesGridInputData_BadgeInputData.decode(v502))
			elseif v498 == 3 then
				local v503

				v503, n12 = proto.readBuffer(p17, n12)
				v496.collection_id = buffer.tostring(v503)
			elseif v498 == 4 then
				local v504

				v504, n12 = proto.readBuffer(p17, n12)
				v496.collection_position = buffer.tostring(v504)
			elseif v498 == 5 then
				local v505

				v505, n12 = proto.readBuffer(p17, n12)
				v496.universe_id = buffer.tostring(v505)
			else
				local v506, v507 = proto.readVarInt(p17, n12)

				n12 = v507 + v506
			end
		elseif v499 == proto.wireTypes.i32 then
			local v508

			v508, n12 = proto.readFixed32(p17, n12)
		elseif v499 == proto.wireTypes.i64 then
			local v509

			v509, n12 = proto.readFixed64(p17, n12)
		else
			error("Unsupported wire type: " .. v499)
		end
	end

	return v496
end
function t22.jsonEncode(p18) -- line: 5585
	local t24 = {}

	if p18.section_title ~= nil and p18.section_title ~= "" then
		t24.sectionTitle = p18.section_title
	end

	if p18.badges ~= nil and #p18.badges > 0 then
		local t25 = {}

		for _, v514 in p18.badges do
			table.insert(t25, v514:jsonEncode())
		end

		t24.badges = t25
	end

	if p18.collection_id ~= nil and p18.collection_id ~= "" then
		t24.collectionId = p18.collection_id
	end

	if p18.collection_position ~= nil and p18.collection_position ~= "" then
		t24.collectionPosition = p18.collection_position
	end

	if p18.universe_id ~= nil and p18.universe_id ~= "" then
		t24.universeId = p18.universe_id
	end

	return t24
end
function t22.jsonDecode(t26: {[any]: any}) -- line: 5615
	-- upvalues: t22 (copy), t1 (copy)
	local v516 = t22.new()

	if t26.section_title ~= nil then
		v516.section_title = t26.section_title
	end

	if t26.sectionTitle ~= nil then
		v516.section_title = t26.sectionTitle
	end

	if t26.badges ~= nil then
		local t27 = {}

		for _, v519 in t26.badges do
			table.insert(t27, t1.BadgesGridInputData_BadgeInputData.jsonDecode(v519))
		end

		v516.badges = t27
	end

	if t26.collection_id ~= nil then
		v516.collection_id = t26.collection_id
	end

	if t26.collectionId ~= nil then
		v516.collection_id = t26.collectionId
	end

	if t26.collection_position ~= nil then
		v516.collection_position = t26.collection_position
	end

	if t26.collectionPosition ~= nil then
		v516.collection_position = t26.collectionPosition
	end

	if t26.universe_id ~= nil then
		v516.universe_id = t26.universe_id
	end

	if t26.universeId ~= nil then
		v516.universe_id = t26.universeId
	end

	return v516
end

t22.descriptor = {
	name = "BadgesGridInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.BadgesGridInputData"
}
t1.BadgesGridInputData = t22
typeRegistry.default:register(t1.BadgesGridInputData)

local t28 = {}

t28.__index = t28

function t28.new(t29: {[any]: any}?) -- line: 5676
	-- upvalues: t28 (copy)
	return (setmetatable({
		badge_id = if t29 ~= nil and t29.badge_id ~= nil then t29.badge_id else ""
	}, t28))
end
function t28.encode(p19) -- line: 5684
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n13 = 0

	if p19.badge_id ~= nil and p19.badge_id ~= "" then
		local v524, v525 = proto.writeTag(buf, n13, 1, proto.wireTypes.lengthDelimited)

		buf, n13 = proto.writeString(v524, v525, p19.badge_id)
	end

	local buf8 = buffer.create(n13)

	buffer.copy(buf8, 0, buf, 0, n13)

	return buf8
end
function t28.decode(p20: buffer) -- line: 5698
	-- upvalues: t28 (copy), proto (copy)
	local v528 = t28.new()
	local n14 = 0

	while n14 < buffer.len(p20) do
		local v530, v531

		v530, v531, n14 = proto.readTag(p20, n14)

		if v531 == proto.wireTypes.varint then
			local v532

			v532, n14 = proto.readVarInt(p20, n14)
		elseif v531 == proto.wireTypes.lengthDelimited then
			if v530 == 1 then
				local v533

				v533, n14 = proto.readBuffer(p20, n14)
				v528.badge_id = buffer.tostring(v533)
			else
				local v534, v535 = proto.readVarInt(p20, n14)

				n14 = v535 + v534
			end
		elseif v531 == proto.wireTypes.i32 then
			local v536

			v536, n14 = proto.readFixed32(p20, n14)
		elseif v531 == proto.wireTypes.i64 then
			local v537

			v537, n14 = proto.readFixed64(p20, n14)
		else
			error("Unsupported wire type: " .. v531)
		end
	end

	return v528
end
function t28.jsonEncode(p21) -- line: 5741
	local t30 = {}

	if p21.badge_id ~= nil and p21.badge_id ~= "" then
		t30.badgeId = p21.badge_id
	end

	return t30
end
function t28.jsonDecode(t31: {[any]: any}) -- line: 5751
	-- upvalues: t28 (copy)
	local v541 = t28.new()

	if t31.badge_id ~= nil then
		v541.badge_id = t31.badge_id
	end

	if t31.badgeId ~= nil then
		v541.badge_id = t31.badgeId
	end

	return v541
end

t28.descriptor = {
	name = "BadgesGridInputData_BadgeInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.BadgeInputData"
}
t1.BadgesGridInputData_BadgeInputData = t28
typeRegistry.default:register(t1.BadgesGridInputData_BadgeInputData)

local t32 = {}

t32.__index = t32

function t32.new(t33: {[any]: any}?) -- line: 5781
	-- upvalues: t32 (copy)
	return (setmetatable({
		badge_id = if t33 ~= nil and t33.badge_id ~= nil then t33.badge_id else "",
		universe_id = if t33 ~= nil and t33.universe_id ~= nil then t33.universe_id else "",
		localized_literals = if t33 ~= nil and t33.localized_literals ~= nil then t33.localized_literals else nil,
		creator_key = if t33 ~= nil and t33.creator_key ~= nil then t33.creator_key else ""
	}, t32))
end
function t32.encode(p22) -- line: 5790
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n15 = 0

	if p22.badge_id ~= nil and p22.badge_id ~= "" then
		local v546, v547 = proto.writeTag(buf, n15, 1, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeString(v546, v547, p22.badge_id)
	end

	if p22.universe_id ~= nil and p22.universe_id ~= "" then
		local v548, v549 = proto.writeTag(buf, n15, 2, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeString(v548, v549, p22.universe_id)
	end

	if p22.localized_literals ~= nil then
		local v550 = p22.localized_literals:encode()
		local v551, v552 = proto.writeTag(buf, n15, 3, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeBuffer(v551, v552, v550, buffer.len(v550))
	end

	if p22.creator_key ~= nil and p22.creator_key ~= "" then
		local v553, v554 = proto.writeTag(buf, n15, 4, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeString(v553, v554, p22.creator_key)
	end

	local buf9 = buffer.create(n15)

	buffer.copy(buf9, 0, buf, 0, n15)

	return buf9
end
function t32.decode(p23: buffer) -- line: 5820
	-- upvalues: t32 (copy), proto (copy), t1 (copy)
	local v557 = t32.new()
	local n16 = 0

	while n16 < buffer.len(p23) do
		local v559, v560

		v559, v560, n16 = proto.readTag(p23, n16)

		if v560 == proto.wireTypes.varint then
			local v561

			v561, n16 = proto.readVarInt(p23, n16)
		elseif v560 == proto.wireTypes.lengthDelimited then
			if v559 == 1 then
				local v562

				v562, n16 = proto.readBuffer(p23, n16)
				v557.badge_id = buffer.tostring(v562)
			elseif v559 == 2 then
				local v563

				v563, n16 = proto.readBuffer(p23, n16)
				v557.universe_id = buffer.tostring(v563)
			elseif v559 == 3 then
				local v564

				v564, n16 = proto.readBuffer(p23, n16)
				v557.localized_literals = t1.BadgeDetailsInputData_LocalizedLiterals.decode(v564)
			elseif v559 == 4 then
				local v565

				v565, n16 = proto.readBuffer(p23, n16)
				v557.creator_key = buffer.tostring(v565)
			else
				local v566, v567 = proto.readVarInt(p23, n16)

				n16 = v567 + v566
			end
		elseif v560 == proto.wireTypes.i32 then
			local v568

			v568, n16 = proto.readFixed32(p23, n16)
		elseif v560 == proto.wireTypes.i64 then
			local v569

			v569, n16 = proto.readFixed64(p23, n16)
		else
			error("Unsupported wire type: " .. v560)
		end
	end

	return v557
end
function t32.jsonEncode(p24) -- line: 5878
	local t34 = {}

	if p24.badge_id ~= nil and p24.badge_id ~= "" then
		t34.badgeId = p24.badge_id
	end

	if p24.universe_id ~= nil and p24.universe_id ~= "" then
		t34.universeId = p24.universe_id
	end

	if p24.localized_literals ~= nil then
		t34.localizedLiterals = p24.localized_literals:jsonEncode()
	end

	if p24.creator_key ~= nil and p24.creator_key ~= "" then
		t34.creatorKey = p24.creator_key
	end

	return t34
end
function t32.jsonDecode(t35: {[any]: any}) -- line: 5900
	-- upvalues: t32 (copy), t1 (copy)
	local v573 = t32.new()

	if t35.badge_id ~= nil then
		v573.badge_id = t35.badge_id
	end

	if t35.badgeId ~= nil then
		v573.badge_id = t35.badgeId
	end

	if t35.universe_id ~= nil then
		v573.universe_id = t35.universe_id
	end

	if t35.universeId ~= nil then
		v573.universe_id = t35.universeId
	end

	if t35.localized_literals ~= nil then
		v573.localized_literals = t1.BadgeDetailsInputData_LocalizedLiterals.jsonDecode(t35.localized_literals)
	end

	if t35.localizedLiterals ~= nil then
		v573.localized_literals = t1.BadgeDetailsInputData_LocalizedLiterals.jsonDecode(t35.localizedLiterals)
	end

	if t35.creator_key ~= nil then
		v573.creator_key = t35.creator_key
	end

	if t35.creatorKey ~= nil then
		v573.creator_key = t35.creatorKey
	end

	return v573
end

t32.descriptor = {
	name = "BadgeDetailsInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.BadgeDetailsInputData"
}
t1.BadgeDetailsInputData = t32
typeRegistry.default:register(t1.BadgeDetailsInputData)

local t36 = {}

t36.__index = t36

function t36.new(t37: {[any]: any}?) -- line: 5954
	-- upvalues: t36 (copy)
	return (setmetatable({
		info_table = if t37 ~= nil and t37.info_table ~= nil then t37.info_table else nil,
		action_module = if t37 ~= nil and t37.action_module ~= nil then t37.action_module else nil,
		overflow_menu = if t37 ~= nil and t37.overflow_menu ~= nil then t37.overflow_menu else nil
	}, t36))
end
function t36.encode(p25) -- line: 5964
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n17 = 0

	if p25.info_table ~= nil then
		local v578 = p25.info_table:encode()
		local v579, v580 = proto.writeTag(buf, n17, 1, proto.wireTypes.lengthDelimited)

		buf, n17 = proto.writeBuffer(v579, v580, v578, buffer.len(v578))
	end

	if p25.action_module ~= nil then
		local v581 = p25.action_module:encode()
		local v582, v583 = proto.writeTag(buf, n17, 2, proto.wireTypes.lengthDelimited)

		buf, n17 = proto.writeBuffer(v582, v583, v581, buffer.len(v581))
	end

	if p25.overflow_menu ~= nil then
		local v584 = p25.overflow_menu:encode()
		local v585, v586 = proto.writeTag(buf, n17, 3, proto.wireTypes.lengthDelimited)

		buf, n17 = proto.writeBuffer(v585, v586, v584, buffer.len(v584))
	end

	local buf10 = buffer.create(n17)

	buffer.copy(buf10, 0, buf, 0, n17)

	return buf10
end
function t36.decode(p26: buffer) -- line: 5991
	-- upvalues: t36 (copy), proto (copy), t1 (copy)
	local v589 = t36.new()
	local n18 = 0

	while n18 < buffer.len(p26) do
		local v591, v592

		v591, v592, n18 = proto.readTag(p26, n18)

		if v592 == proto.wireTypes.varint then
			local v593

			v593, n18 = proto.readVarInt(p26, n18)
		elseif v592 == proto.wireTypes.lengthDelimited then
			if v591 == 1 then
				local v594

				v594, n18 = proto.readBuffer(p26, n18)
				v589.info_table = t1.BadgeDetailsInputData_LocalizedLiterals_InfoTable.decode(v594)
			elseif v591 == 2 then
				local v595

				v595, n18 = proto.readBuffer(p26, n18)
				v589.action_module = t1.BadgeDetailsInputData_LocalizedLiterals_ActionModule.decode(v595)
			elseif v591 == 3 then
				local v596

				v596, n18 = proto.readBuffer(p26, n18)
				v589.overflow_menu = t1.BadgeDetailsInputData_LocalizedLiterals_OverflowMenu.decode(v596)
			else
				local v597, v598 = proto.readVarInt(p26, n18)

				n18 = v598 + v597
			end
		elseif v592 == proto.wireTypes.i32 then
			local v599

			v599, n18 = proto.readFixed32(p26, n18)
		elseif v592 == proto.wireTypes.i64 then
			local v600

			v600, n18 = proto.readFixed64(p26, n18)
		else
			error("Unsupported wire type: " .. v592)
		end
	end

	return v589
end
function t36.jsonEncode(p27) -- line: 6044
	local t38 = {}

	if p27.info_table ~= nil then
		t38.infoTable = p27.info_table:jsonEncode()
	end

	if p27.action_module ~= nil then
		t38.actionModule = p27.action_module:jsonEncode()
	end

	if p27.overflow_menu ~= nil then
		t38.overflowMenu = p27.overflow_menu:jsonEncode()
	end

	return t38
end
function t36.jsonDecode(t39: {[any]: any}) -- line: 6062
	-- upvalues: t36 (copy), t1 (copy)
	local v604 = t36.new()

	if t39.info_table ~= nil then
		v604.info_table = t1.BadgeDetailsInputData_LocalizedLiterals_InfoTable.jsonDecode(t39.info_table)
	end

	if t39.infoTable ~= nil then
		v604.info_table = t1.BadgeDetailsInputData_LocalizedLiterals_InfoTable.jsonDecode(t39.infoTable)
	end

	if t39.action_module ~= nil then
		v604.action_module = t1.BadgeDetailsInputData_LocalizedLiterals_ActionModule.jsonDecode(t39.action_module)
	end

	if t39.actionModule ~= nil then
		v604.action_module = t1.BadgeDetailsInputData_LocalizedLiterals_ActionModule.jsonDecode(t39.actionModule)
	end

	if t39.overflow_menu ~= nil then
		v604.overflow_menu = t1.BadgeDetailsInputData_LocalizedLiterals_OverflowMenu.jsonDecode(t39.overflow_menu)
	end

	if t39.overflowMenu ~= nil then
		v604.overflow_menu = t1.BadgeDetailsInputData_LocalizedLiterals_OverflowMenu.jsonDecode(t39.overflowMenu)
	end

	return v604
end

t36.descriptor = {
	name = "BadgeDetailsInputData_LocalizedLiterals",
	fullName = "roblox.apppageplatform.shared.v1beta1.LocalizedLiterals"
}
t1.BadgeDetailsInputData_LocalizedLiterals = t36
typeRegistry.default:register(t1.BadgeDetailsInputData_LocalizedLiterals)

local t40 = {}

t40.__index = t40

function t40.new(t41: {[any]: any}?) -- line: 6113
	-- upvalues: t40 (copy)
	return (setmetatable({
		type_label = if t41 ~= nil and t41.type_label ~= nil then t41.type_label else "",
		earned_label = if t41 ~= nil and t41.earned_label ~= nil then t41.earned_label else "",
		updated_label = if t41 ~= nil and t41.updated_label ~= nil then t41.updated_label else "",
		experience_label = if t41 ~= nil and t41.experience_label ~= nil then t41.experience_label else "",
		rarity_label = if t41 ~= nil and t41.rarity_label ~= nil then t41.rarity_label else "",
		won_yesterday_label = if t41 ~= nil and t41.won_yesterday_label ~= nil then t41.won_yesterday_label else "",
		won_ever_label = if t41 ~= nil and t41.won_ever_label ~= nil then t41.won_ever_label else ""
	}, t40))
end
function t40.encode(p28) -- line: 6132
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n19 = 0

	if p28.type_label ~= nil and p28.type_label ~= "" then
		local v609, v610 = proto.writeTag(buf, n19, 1, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeString(v609, v610, p28.type_label)
	end

	if p28.earned_label ~= nil and p28.earned_label ~= "" then
		local v611, v612 = proto.writeTag(buf, n19, 2, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeString(v611, v612, p28.earned_label)
	end

	if p28.updated_label ~= nil and p28.updated_label ~= "" then
		local v613, v614 = proto.writeTag(buf, n19, 3, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeString(v613, v614, p28.updated_label)
	end

	if p28.experience_label ~= nil and p28.experience_label ~= "" then
		local v615, v616 = proto.writeTag(buf, n19, 4, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeString(v615, v616, p28.experience_label)
	end

	if p28.rarity_label ~= nil and p28.rarity_label ~= "" then
		local v617, v618 = proto.writeTag(buf, n19, 5, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeString(v617, v618, p28.rarity_label)
	end

	if p28.won_yesterday_label ~= nil and p28.won_yesterday_label ~= "" then
		local v619, v620 = proto.writeTag(buf, n19, 6, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeString(v619, v620, p28.won_yesterday_label)
	end

	if p28.won_ever_label ~= nil and p28.won_ever_label ~= "" then
		local v621, v622 = proto.writeTag(buf, n19, 7, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeString(v621, v622, p28.won_ever_label)
	end

	local buf11 = buffer.create(n19)

	buffer.copy(buf11, 0, buf, 0, n19)

	return buf11
end
function t40.decode(p29: buffer) -- line: 6178
	-- upvalues: t40 (copy), proto (copy)
	local v625 = t40.new()
	local n20 = 0

	while n20 < buffer.len(p29) do
		local v627, v628

		v627, v628, n20 = proto.readTag(p29, n20)

		if v628 == proto.wireTypes.varint then
			local v629

			v629, n20 = proto.readVarInt(p29, n20)
		elseif v628 == proto.wireTypes.lengthDelimited then
			if v627 == 1 then
				local v630

				v630, n20 = proto.readBuffer(p29, n20)
				v625.type_label = buffer.tostring(v630)
			elseif v627 == 2 then
				local v631

				v631, n20 = proto.readBuffer(p29, n20)
				v625.earned_label = buffer.tostring(v631)
			elseif v627 == 3 then
				local v632

				v632, n20 = proto.readBuffer(p29, n20)
				v625.updated_label = buffer.tostring(v632)
			elseif v627 == 4 then
				local v633

				v633, n20 = proto.readBuffer(p29, n20)
				v625.experience_label = buffer.tostring(v633)
			elseif v627 == 5 then
				local v634

				v634, n20 = proto.readBuffer(p29, n20)
				v625.rarity_label = buffer.tostring(v634)
			elseif v627 == 6 then
				local v635

				v635, n20 = proto.readBuffer(p29, n20)
				v625.won_yesterday_label = buffer.tostring(v635)
			elseif v627 == 7 then
				local v636

				v636, n20 = proto.readBuffer(p29, n20)
				v625.won_ever_label = buffer.tostring(v636)
			else
				local v637, v638 = proto.readVarInt(p29, n20)

				n20 = v638 + v637
			end
		elseif v628 == proto.wireTypes.i32 then
			local v639

			v639, n20 = proto.readFixed32(p29, n20)
		elseif v628 == proto.wireTypes.i64 then
			local v640

			v640, n20 = proto.readFixed64(p29, n20)
		else
			error("Unsupported wire type: " .. v628)
		end
	end

	return v625
end
function t40.jsonEncode(p30) -- line: 6253
	local t42 = {}

	if p30.type_label ~= nil and p30.type_label ~= "" then
		t42.typeLabel = p30.type_label
	end

	if p30.earned_label ~= nil and p30.earned_label ~= "" then
		t42.earnedLabel = p30.earned_label
	end

	if p30.updated_label ~= nil and p30.updated_label ~= "" then
		t42.updatedLabel = p30.updated_label
	end

	if p30.experience_label ~= nil and p30.experience_label ~= "" then
		t42.experienceLabel = p30.experience_label
	end

	if p30.rarity_label ~= nil and p30.rarity_label ~= "" then
		t42.rarityLabel = p30.rarity_label
	end

	if p30.won_yesterday_label ~= nil and p30.won_yesterday_label ~= "" then
		t42.wonYesterdayLabel = p30.won_yesterday_label
	end

	if p30.won_ever_label ~= nil and p30.won_ever_label ~= "" then
		t42.wonEverLabel = p30.won_ever_label
	end

	return t42
end
function t40.jsonDecode(t43: {[any]: any}) -- line: 6289
	-- upvalues: t40 (copy)
	local v644 = t40.new()

	if t43.type_label ~= nil then
		v644.type_label = t43.type_label
	end

	if t43.typeLabel ~= nil then
		v644.type_label = t43.typeLabel
	end

	if t43.earned_label ~= nil then
		v644.earned_label = t43.earned_label
	end

	if t43.earnedLabel ~= nil then
		v644.earned_label = t43.earnedLabel
	end

	if t43.updated_label ~= nil then
		v644.updated_label = t43.updated_label
	end

	if t43.updatedLabel ~= nil then
		v644.updated_label = t43.updatedLabel
	end

	if t43.experience_label ~= nil then
		v644.experience_label = t43.experience_label
	end

	if t43.experienceLabel ~= nil then
		v644.experience_label = t43.experienceLabel
	end

	if t43.rarity_label ~= nil then
		v644.rarity_label = t43.rarity_label
	end

	if t43.rarityLabel ~= nil then
		v644.rarity_label = t43.rarityLabel
	end

	if t43.won_yesterday_label ~= nil then
		v644.won_yesterday_label = t43.won_yesterday_label
	end

	if t43.wonYesterdayLabel ~= nil then
		v644.won_yesterday_label = t43.wonYesterdayLabel
	end

	if t43.won_ever_label ~= nil then
		v644.won_ever_label = t43.won_ever_label
	end

	if t43.wonEverLabel ~= nil then
		v644.won_ever_label = t43.wonEverLabel
	end

	return v644
end

t40.descriptor = {
	name = "BadgeDetailsInputData_LocalizedLiterals_InfoTable",
	fullName = "roblox.apppageplatform.shared.v1beta1.InfoTable"
}
t1.BadgeDetailsInputData_LocalizedLiterals_InfoTable = t40
typeRegistry.default:register(t1.BadgeDetailsInputData_LocalizedLiterals_InfoTable)

local t44 = {}

t44.__index = t44

function t44.new(t45: {[any]: any}?) -- line: 6369
	-- upvalues: t44 (copy)
	return (setmetatable({
		share = if t45 ~= nil and t45.share ~= nil then t45.share else "",
		report = if t45 ~= nil and t45.report ~= nil then t45.report else ""
	}, t44))
end
function t44.encode(p31) -- line: 6381
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n21 = 0

	if p31.share ~= nil and p31.share ~= "" then
		local v649, v650 = proto.writeTag(buf, n21, 1, proto.wireTypes.lengthDelimited)

		buf, n21 = proto.writeString(v649, v650, p31.share)
	end

	if p31.report ~= nil and p31.report ~= "" then
		local v651, v652 = proto.writeTag(buf, n21, 2, proto.wireTypes.lengthDelimited)

		buf, n21 = proto.writeString(v651, v652, p31.report)
	end

	local buf12 = buffer.create(n21)

	buffer.copy(buf12, 0, buf, 0, n21)

	return buf12
end
function t44.decode(p32: buffer) -- line: 6402
	-- upvalues: t44 (copy), proto (copy)
	local v655 = t44.new()
	local n22 = 0

	while n22 < buffer.len(p32) do
		local v657, v658

		v657, v658, n22 = proto.readTag(p32, n22)

		if v658 == proto.wireTypes.varint then
			local v659

			v659, n22 = proto.readVarInt(p32, n22)
		elseif v658 == proto.wireTypes.lengthDelimited then
			if v657 == 1 then
				local v660

				v660, n22 = proto.readBuffer(p32, n22)
				v655.share = buffer.tostring(v660)
			elseif v657 == 2 then
				local v661

				v661, n22 = proto.readBuffer(p32, n22)
				v655.report = buffer.tostring(v661)
			else
				local v662, v663 = proto.readVarInt(p32, n22)

				n22 = v663 + v662
			end
		elseif v658 == proto.wireTypes.i32 then
			local v664

			v664, n22 = proto.readFixed32(p32, n22)
		elseif v658 == proto.wireTypes.i64 then
			local v665

			v665, n22 = proto.readFixed64(p32, n22)
		else
			error("Unsupported wire type: " .. v658)
		end
	end

	return v655
end
function t44.jsonEncode(p33) -- line: 6452
	local t46 = {}

	if p33.share ~= nil and p33.share ~= "" then
		t46.share = p33.share
	end

	if p33.report ~= nil and p33.report ~= "" then
		t46.report = p33.report
	end

	return t46
end
function t44.jsonDecode(t47: {[any]: any}) -- line: 6468
	-- upvalues: t44 (copy)
	local v669 = t44.new()

	if t47.share ~= nil then
		v669.share = t47.share
	end

	if t47.report ~= nil then
		v669.report = t47.report
	end

	return v669
end

t44.descriptor = {
	name = "BadgeDetailsInputData_LocalizedLiterals_ActionModule",
	fullName = "roblox.apppageplatform.shared.v1beta1.ActionModule"
}
t1.BadgeDetailsInputData_LocalizedLiterals_ActionModule = t44
typeRegistry.default:register(t1.BadgeDetailsInputData_LocalizedLiterals_ActionModule)

local t48 = {}

t48.__index = t48

function t48.new(t49: {[any]: any}?) -- line: 6500
	-- upvalues: t48 (copy)
	return (setmetatable({
		report = if t49 ~= nil and t49.report ~= nil then t49.report else "",
		remove = if t49 ~= nil and t49.remove ~= nil then t49.remove else ""
	}, t48))
end
function t48.encode(p34) -- line: 6512
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n23 = 0

	if p34.report ~= nil and p34.report ~= "" then
		local v674, v675 = proto.writeTag(buf, n23, 1, proto.wireTypes.lengthDelimited)

		buf, n23 = proto.writeString(v674, v675, p34.report)
	end

	if p34.remove ~= nil and p34.remove ~= "" then
		local v676, v677 = proto.writeTag(buf, n23, 2, proto.wireTypes.lengthDelimited)

		buf, n23 = proto.writeString(v676, v677, p34.remove)
	end

	local buf13 = buffer.create(n23)

	buffer.copy(buf13, 0, buf, 0, n23)

	return buf13
end
function t48.decode(p35: buffer) -- line: 6533
	-- upvalues: t48 (copy), proto (copy)
	local v680 = t48.new()
	local n24 = 0

	while n24 < buffer.len(p35) do
		local v682, v683

		v682, v683, n24 = proto.readTag(p35, n24)

		if v683 == proto.wireTypes.varint then
			local v684

			v684, n24 = proto.readVarInt(p35, n24)
		elseif v683 == proto.wireTypes.lengthDelimited then
			if v682 == 1 then
				local v685

				v685, n24 = proto.readBuffer(p35, n24)
				v680.report = buffer.tostring(v685)
			elseif v682 == 2 then
				local v686

				v686, n24 = proto.readBuffer(p35, n24)
				v680.remove = buffer.tostring(v686)
			else
				local v687, v688 = proto.readVarInt(p35, n24)

				n24 = v688 + v687
			end
		elseif v683 == proto.wireTypes.i32 then
			local v689

			v689, n24 = proto.readFixed32(p35, n24)
		elseif v683 == proto.wireTypes.i64 then
			local v690

			v690, n24 = proto.readFixed64(p35, n24)
		else
			error("Unsupported wire type: " .. v683)
		end
	end

	return v680
end
function t48.jsonEncode(p36) -- line: 6583
	local t50 = {}

	if p36.report ~= nil and p36.report ~= "" then
		t50.report = p36.report
	end

	if p36.remove ~= nil and p36.remove ~= "" then
		t50.remove = p36.remove
	end

	return t50
end
function t48.jsonDecode(t51: {[any]: any}) -- line: 6599
	-- upvalues: t48 (copy)
	local v694 = t48.new()

	if t51.report ~= nil then
		v694.report = t51.report
	end

	if t51.remove ~= nil then
		v694.remove = t51.remove
	end

	return v694
end

t48.descriptor = {
	name = "BadgeDetailsInputData_LocalizedLiterals_OverflowMenu",
	fullName = "roblox.apppageplatform.shared.v1beta1.OverflowMenu"
}
t1.BadgeDetailsInputData_LocalizedLiterals_OverflowMenu = t48
typeRegistry.default:register(t1.BadgeDetailsInputData_LocalizedLiterals_OverflowMenu)

local t52 = {}

t52.__index = t52

function t52.new(_: {[any]: any}?) -- line: 6630
	-- upvalues: t52 (copy)
	return (setmetatable({}, t52))
end
function t52.encode(_) -- line: 6634
	local buf = buffer.create(0)
	local buf14 = buffer.create(0)

	buffer.copy(buf14, 0, buf, 0, 0)

	return buf14
end
function t52.decode(p38: buffer) -- line: 6643
	-- upvalues: t52 (copy), proto (copy)
	local v700 = t52.new()
	local n25 = 0

	while n25 < buffer.len(p38) do
		local v702, v703

		v702, v703, n25 = proto.readTag(p38, n25)

		if v703 == proto.wireTypes.varint then
			local v704

			v704, n25 = proto.readVarInt(p38, n25)
		elseif v703 == proto.wireTypes.lengthDelimited then
			local v705, v706 = proto.readVarInt(p38, n25)

			n25 = v706 + v705
		elseif v703 == proto.wireTypes.i32 then
			local v707

			v707, n25 = proto.readFixed32(p38, n25)
		elseif v703 == proto.wireTypes.i64 then
			local v708

			v708, n25 = proto.readFixed64(p38, n25)
		else
			error("Unsupported wire type: " .. v703)
		end
	end

	return v700
end
function t52.jsonEncode(_) -- line: 6681
	return {}
end
function t52.jsonDecode(_: {[any]: any}) -- line: 6687
	-- upvalues: t52 (copy)
	return (t52.new())
end

t52.descriptor = {
	name = "StaticInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.StaticInputData"
}
t1.StaticInputData = t52
typeRegistry.default:register(t1.StaticInputData)

local t55 = {}

t55.__index = t55

function t55.new(t56: {[any]: any}?) -- line: 6707
	-- upvalues: t55 (copy)
	return (setmetatable({
		universe_id = if t56 ~= nil and t56.universe_id ~= nil then t56.universe_id else "",
		creator_key = if t56 ~= nil and t56.creator_key ~= nil then t56.creator_key else "",
		entry_map = if t56 ~= nil and t56.entry_map ~= nil then t56.entry_map else {},
		entry_order = if t56 ~= nil and t56.entry_order ~= nil then t56.entry_order else {},
		entry_order_map = if t56 ~= nil and t56.entry_order_map ~= nil then t56.entry_order_map else {}
	}, t55))
end
function t55.encode(p40) -- line: 6719
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n26 = 0

	if p40.universe_id ~= nil and p40.universe_id ~= "" then
		local v715, v716 = proto.writeTag(buf, n26, 1, proto.wireTypes.lengthDelimited)

		buf, n26 = proto.writeString(v715, v716, p40.universe_id)
	end

	if p40.creator_key ~= nil and p40.creator_key ~= "" then
		local v717, v718 = proto.writeTag(buf, n26, 2, proto.wireTypes.lengthDelimited)

		buf, n26 = proto.writeString(v717, v718, p40.creator_key)
	end

	if p40.entry_map ~= nil and next(p40.entry_map) ~= nil then
		for v719, v720 in p40.entry_map do
			local buf15 = buffer.create(0)
			local v722, v723 = proto.writeTag(buf15, 0, 1, proto.wireTypes.lengthDelimited)
			local v724, v725 = proto.writeString(v722, v723, v719)
			local v726 = v720:encode()
			local v727, v728 = proto.writeTag(v724, v725, 2, proto.wireTypes.lengthDelimited)
			local v729, v730 = proto.writeBuffer(v727, v728, v726, buffer.len(v726))
			local v731, v732 = proto.writeTag(buf, n26, 3, proto.wireTypes.lengthDelimited)

			buf, n26 = proto.writeBuffer(v731, v732, v729, v730)
		end
	end

	if p40.entry_order ~= nil and #p40.entry_order > 0 then
		for _, v734 in p40.entry_order do
			local v735, v736 = proto.writeTag(buf, n26, 4, proto.wireTypes.lengthDelimited)

			buf, n26 = proto.writeString(v735, v736, v734)
		end
	end

	if p40.entry_order_map ~= nil and next(p40.entry_order_map) ~= nil then
		for v737, v738 in p40.entry_order_map do
			local buf16 = buffer.create(0)
			local v740, v741 = proto.writeTag(buf16, 0, 1, proto.wireTypes.lengthDelimited)
			local v742, v743 = proto.writeString(v740, v741, v737)
			local v744 = v738:encode()
			local v745, v746 = proto.writeTag(v742, v743, 2, proto.wireTypes.lengthDelimited)
			local v747, v748 = proto.writeBuffer(v745, v746, v744, buffer.len(v744))
			local v749, v750 = proto.writeTag(buf, n26, 5, proto.wireTypes.lengthDelimited)

			buf, n26 = proto.writeBuffer(v749, v750, v747, v748)
		end
	end

	local buf17 = buffer.create(n26)

	buffer.copy(buf17, 0, buf, 0, n26)

	return buf17
end
function t55.decode(p41: buffer) -- line: 6773
	-- upvalues: t55 (copy), proto (copy), t1 (copy)
	local v753 = t55.new()
	local n27 = 0

	while n27 < buffer.len(p41) do
		local v755, v756

		v755, v756, n27 = proto.readTag(p41, n27)

		if v756 == proto.wireTypes.varint then
			local v757

			v757, n27 = proto.readVarInt(p41, n27)
		elseif v756 == proto.wireTypes.lengthDelimited then
			if v755 == 1 then
				local v758

				v758, n27 = proto.readBuffer(p41, n27)
				v753.universe_id = buffer.tostring(v758)
			elseif v755 == 2 then
				local v759

				v759, n27 = proto.readBuffer(p41, n27)
				v753.creator_key = buffer.tostring(v759)
			elseif v755 == 3 then
				local v760

				v760, n27 = proto.readBuffer(p41, n27)

				local v761 = t1.ExperienceDetailsFeedInputData_EntryMapEntry.decode(v760)
				local v762 = t1.FeedEntry.new()

				v753.entry_map[v761.key or ""] = v761.value or v762
			elseif v755 == 4 then
				local v763

				v763, n27 = proto.readBuffer(p41, n27)
				table.insert(v753.entry_order, buffer.tostring(v763))
			elseif v755 == 5 then
				local v764

				v764, n27 = proto.readBuffer(p41, n27)

				local v765 = t1.ExperienceDetailsFeedInputData_EntryOrderMapEntry.decode(v764)
				local v766 = t1.EntryOrder.new()

				v753.entry_order_map[v765.key or ""] = v765.value or v766
			else
				local v767, v768 = proto.readVarInt(p41, n27)

				n27 = v768 + v767
			end
		elseif v756 == proto.wireTypes.i32 then
			local v769

			v769, n27 = proto.readFixed32(p41, n27)
		elseif v756 == proto.wireTypes.i64 then
			local v770

			v770, n27 = proto.readFixed64(p41, n27)
		else
			error("Unsupported wire type: " .. v756)
		end
	end

	return v753
end
function t55.jsonEncode(p42) -- line: 6850
	local t57 = {}

	if p42.universe_id ~= nil and p42.universe_id ~= "" then
		t57.universeId = p42.universe_id
	end

	if p42.creator_key ~= nil and p42.creator_key ~= "" then
		t57.creatorKey = p42.creator_key
	end

	if p42.entry_map ~= nil and next(p42.entry_map) ~= nil then
		local t58 = {}

		for v774, v775 in p42.entry_map do
			t58[v774] = v775:jsonEncode()
		end

		t57.entryMap = t58
	end

	if p42.entry_order ~= nil and #p42.entry_order > 0 then
		local t59 = {}

		for _, v778 in p42.entry_order do
			table.insert(t59, v778)
		end

		t57.entryOrder = t59
	end

	if p42.entry_order_map ~= nil and next(p42.entry_order_map) ~= nil then
		local t60 = {}

		for v780, v781 in p42.entry_order_map do
			t60[v780] = v781:jsonEncode()
		end

		t57.entryOrderMap = t60
	end

	return t57
end
function t55.jsonDecode(t61: {[any]: any}) -- line: 6888
	-- upvalues: t55 (copy), t1 (copy)
	local v783 = t55.new()

	if t61.universe_id ~= nil then
		v783.universe_id = t61.universe_id
	end

	if t61.universeId ~= nil then
		v783.universe_id = t61.universeId
	end

	if t61.creator_key ~= nil then
		v783.creator_key = t61.creator_key
	end

	if t61.creatorKey ~= nil then
		v783.creator_key = t61.creatorKey
	end

	if t61.entry_map ~= nil then
		local t62 = {}

		for v785, v786 in t61.entry_map do
			t62[v785] = t1.FeedEntry.jsonDecode(v786)
		end

		v783.entry_map = t62
	end

	if t61.entryMap ~= nil then
		local t63 = {}

		for v788, v789 in t61.entryMap do
			t63[v788] = t1.FeedEntry.jsonDecode(v789)
		end

		v783.entry_map = t63
	end

	if t61.entry_order ~= nil then
		local t64 = {}

		for _, v792 in t61.entry_order do
			table.insert(t64, v792)
		end

		v783.entry_order = t64
	end

	if t61.entryOrder ~= nil then
		local t65 = {}

		for _, v795 in t61.entryOrder do
			table.insert(t65, v795)
		end

		v783.entry_order = t65
	end

	if t61.entry_order_map ~= nil then
		local t66 = {}

		for v797, v798 in t61.entry_order_map do
			t66[v797] = t1.EntryOrder.jsonDecode(v798)
		end

		v783.entry_order_map = t66
	end

	if t61.entryOrderMap ~= nil then
		local t67 = {}

		for v800, v801 in t61.entryOrderMap do
			t67[v800] = t1.EntryOrder.jsonDecode(v801)
		end

		v783.entry_order_map = t67
	end

	return v783
end

t55.descriptor = {
	name = "ExperienceDetailsFeedInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceDetailsFeedInputData"
}
t1.ExperienceDetailsFeedInputData = t55
typeRegistry.default:register(t1.ExperienceDetailsFeedInputData)

local t68 = {}

t68.__index = t68

function t68.new(t69: {[any]: any}?) -- line: 6978
	-- upvalues: t68 (copy)
	return (setmetatable({
		key = if t69 ~= nil and t69.key ~= nil then t69.key else "",
		value = if t69 ~= nil and t69.value ~= nil then t69.value else nil
	}, t68))
end
function t68.encode(p43) -- line: 6987
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n28 = 0

	if p43.key ~= nil and p43.key ~= "" then
		local v806, v807 = proto.writeTag(buf, n28, 1, proto.wireTypes.lengthDelimited)

		buf, n28 = proto.writeString(v806, v807, p43.key)
	end

	if p43.value ~= nil then
		local v808 = p43.value:encode()
		local v809, v810 = proto.writeTag(buf, n28, 2, proto.wireTypes.lengthDelimited)

		buf, n28 = proto.writeBuffer(v809, v810, v808, buffer.len(v808))
	end

	local buf18 = buffer.create(n28)

	buffer.copy(buf18, 0, buf, 0, n28)

	return buf18
end
function t68.decode(p44: buffer) -- line: 7009
	-- upvalues: t68 (copy), proto (copy), t1 (copy)
	local v813 = t68.new()
	local n29 = 0

	while n29 < buffer.len(p44) do
		local v815, v816

		v815, v816, n29 = proto.readTag(p44, n29)

		if v816 == proto.wireTypes.varint then
			local v817

			v817, n29 = proto.readVarInt(p44, n29)
		elseif v816 == proto.wireTypes.lengthDelimited then
			if v815 == 1 then
				local v818

				v818, n29 = proto.readBuffer(p44, n29)
				v813.key = buffer.tostring(v818)
			elseif v815 == 2 then
				local v819

				v819, n29 = proto.readBuffer(p44, n29)
				v813.value = t1.FeedEntry.decode(v819)
			else
				local v820, v821 = proto.readVarInt(p44, n29)

				n29 = v821 + v820
			end
		elseif v816 == proto.wireTypes.i32 then
			local v822

			v822, n29 = proto.readFixed32(p44, n29)
		elseif v816 == proto.wireTypes.i64 then
			local v823

			v823, n29 = proto.readFixed64(p44, n29)
		else
			error("Unsupported wire type: " .. v816)
		end
	end

	return v813
end
function t68.jsonEncode(p45) -- line: 7059
	local t70 = {}

	if p45.key ~= nil and p45.key ~= "" then
		t70.key = p45.key
	end

	if p45.value ~= nil then
		t70.value = p45.value:jsonEncode()
	end

	return t70
end
function t68.jsonDecode(t71: {[any]: any}) -- line: 7075
	-- upvalues: t68 (copy), t1 (copy)
	local v827 = t68.new()

	if t71.key ~= nil then
		v827.key = t71.key
	end

	if t71.value ~= nil then
		v827.value = t1.FeedEntry.jsonDecode(t71.value)
	end

	return v827
end

t68.descriptor = {
	name = "ExperienceDetailsFeedInputData_EntryMapEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryMapEntry"
}
t1.ExperienceDetailsFeedInputData_EntryMapEntry = t68
typeRegistry.default:register(t1.ExperienceDetailsFeedInputData_EntryMapEntry)

local t72 = {}

t72.__index = t72

function t72.new(t73: {[any]: any}?) -- line: 7106
	-- upvalues: t72 (copy)
	return (setmetatable({
		key = if t73 ~= nil and t73.key ~= nil then t73.key else "",
		value = if t73 ~= nil and t73.value ~= nil then t73.value else nil
	}, t72))
end
function t72.encode(p46) -- line: 7118
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n30 = 0

	if p46.key ~= nil and p46.key ~= "" then
		local v832, v833 = proto.writeTag(buf, n30, 1, proto.wireTypes.lengthDelimited)

		buf, n30 = proto.writeString(v832, v833, p46.key)
	end

	if p46.value ~= nil then
		local v834 = p46.value:encode()
		local v835, v836 = proto.writeTag(buf, n30, 2, proto.wireTypes.lengthDelimited)

		buf, n30 = proto.writeBuffer(v835, v836, v834, buffer.len(v834))
	end

	local buf19 = buffer.create(n30)

	buffer.copy(buf19, 0, buf, 0, n30)

	return buf19
end
function t72.decode(p47: buffer) -- line: 7140
	-- upvalues: t72 (copy), proto (copy), t1 (copy)
	local v839 = t72.new()
	local n31 = 0

	while n31 < buffer.len(p47) do
		local v841, v842

		v841, v842, n31 = proto.readTag(p47, n31)

		if v842 == proto.wireTypes.varint then
			local v843

			v843, n31 = proto.readVarInt(p47, n31)
		elseif v842 == proto.wireTypes.lengthDelimited then
			if v841 == 1 then
				local v844

				v844, n31 = proto.readBuffer(p47, n31)
				v839.key = buffer.tostring(v844)
			elseif v841 == 2 then
				local v845

				v845, n31 = proto.readBuffer(p47, n31)
				v839.value = t1.EntryOrder.decode(v845)
			else
				local v846, v847 = proto.readVarInt(p47, n31)

				n31 = v847 + v846
			end
		elseif v842 == proto.wireTypes.i32 then
			local v848

			v848, n31 = proto.readFixed32(p47, n31)
		elseif v842 == proto.wireTypes.i64 then
			local v849

			v849, n31 = proto.readFixed64(p47, n31)
		else
			error("Unsupported wire type: " .. v842)
		end
	end

	return v839
end
function t72.jsonEncode(p48) -- line: 7190
	local t74 = {}

	if p48.key ~= nil and p48.key ~= "" then
		t74.key = p48.key
	end

	if p48.value ~= nil then
		t74.value = p48.value:jsonEncode()
	end

	return t74
end
function t72.jsonDecode(t75: {[any]: any}) -- line: 7206
	-- upvalues: t72 (copy), t1 (copy)
	local v853 = t72.new()

	if t75.key ~= nil then
		v853.key = t75.key
	end

	if t75.value ~= nil then
		v853.value = t1.EntryOrder.jsonDecode(t75.value)
	end

	return v853
end

t72.descriptor = {
	name = "ExperienceDetailsFeedInputData_EntryOrderMapEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryOrderMapEntry"
}
t1.ExperienceDetailsFeedInputData_EntryOrderMapEntry = t72
typeRegistry.default:register(t1.ExperienceDetailsFeedInputData_EntryOrderMapEntry)

local t76 = {}

t76.__index = t76

function t76.new(t77: {[any]: any}?) -- line: 7237
	-- upvalues: t76 (copy)
	return (setmetatable({
		items = if t77 ~= nil and t77.items ~= nil then t77.items else {}
	}, t76))
end
function t76.encode(p49) -- line: 7243
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n32 = 0

	if p49.items ~= nil and #p49.items > 0 then
		for _, v859 in p49.items do
			local v860, v861 = proto.writeTag(buf, n32, 1, proto.wireTypes.lengthDelimited)

			buf, n32 = proto.writeString(v860, v861, v859)
		end
	end

	local buf20 = buffer.create(n32)

	buffer.copy(buf20, 0, buf, 0, n32)

	return buf20
end
function t76.decode(p50: buffer) -- line: 7259
	-- upvalues: t76 (copy), proto (copy)
	local v864 = t76.new()
	local n33 = 0

	while n33 < buffer.len(p50) do
		local v866, v867

		v866, v867, n33 = proto.readTag(p50, n33)

		if v867 == proto.wireTypes.varint then
			local v868

			v868, n33 = proto.readVarInt(p50, n33)
		elseif v867 == proto.wireTypes.lengthDelimited then
			if v866 == 1 then
				local v869

				v869, n33 = proto.readBuffer(p50, n33)
				table.insert(v864.items, buffer.tostring(v869))
			else
				local v870, v871 = proto.readVarInt(p50, n33)

				n33 = v871 + v870
			end
		elseif v867 == proto.wireTypes.i32 then
			local v872

			v872, n33 = proto.readFixed32(p50, n33)
		elseif v867 == proto.wireTypes.i64 then
			local v873

			v873, n33 = proto.readFixed64(p50, n33)
		else
			error("Unsupported wire type: " .. v867)
		end
	end

	return v864
end
function t76.jsonEncode(p51) -- line: 7302
	local t78 = {}

	if p51.items ~= nil and #p51.items > 0 then
		local t79 = {}

		for _, v878 in p51.items do
			table.insert(t79, v878)
		end

		t78.items = t79
	end

	return t78
end
function t76.jsonDecode(t80: {[any]: any}) -- line: 7316
	-- upvalues: t76 (copy)
	local v880 = t76.new()

	if t80.items ~= nil then
		local t81 = {}

		for _, v883 in t80.items do
			table.insert(t81, v883)
		end

		v880.items = t81
	end

	return v880
end

t76.descriptor = {
	name = "EntryOrder",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryOrder"
}
t1.EntryOrder = t76
typeRegistry.default:register(t1.EntryOrder)

local t82 = {}

t82.__index = t82

function t82.new(t83: {[any]: any}?) -- line: 7345
	-- upvalues: t82 (copy)
	return (setmetatable({
		universe_id = if t83 ~= nil and t83.universe_id ~= nil then t83.universe_id else "",
		user_owns_experience = t83 ~= nil and (t83.user_owns_experience ~= nil and t83.user_owns_experience)
	}, t82))
end
function t82.encode(p52) -- line: 7356
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n34 = 0

	if p52.universe_id ~= nil and p52.universe_id ~= "" then
		local v888, v889 = proto.writeTag(buf, n34, 1, proto.wireTypes.lengthDelimited)

		buf, n34 = proto.writeString(v888, v889, p52.universe_id)
	end

	if p52.user_owns_experience then
		local v890, v891 = proto.writeTag(buf, n34, 2, proto.wireTypes.varint)

		buf, n34 = proto.writeVarInt(v890, v891, not p52.user_owns_experience and 0 or 1)
	end

	local buf21 = buffer.create(n34)

	buffer.copy(buf21, 0, buf, 0, n34)

	return buf21
end
function t82.decode(p53: buffer) -- line: 7375
	-- upvalues: t82 (copy), proto (copy)
	local v894 = t82.new()
	local n35 = 0

	while n35 < buffer.len(p53) do
		local v896, v897

		v896, v897, n35 = proto.readTag(p53, n35)

		if v897 == proto.wireTypes.varint then
			if v896 == 2 then
				local v898

				v898, n35 = proto.readVarInt(p53, n35)
				v894.user_owns_experience = v898 ~= 0
			else
				local v899

				v899, n35 = proto.readVarInt(p53, n35)
			end
		elseif v897 == proto.wireTypes.lengthDelimited then
			if v896 == 1 then
				local v900

				v900, n35 = proto.readBuffer(p53, n35)
				v894.universe_id = buffer.tostring(v900)
			else
				local v901, v902 = proto.readVarInt(p53, n35)

				n35 = v902 + v901
			end
		elseif v897 == proto.wireTypes.i32 then
			local v903

			v903, n35 = proto.readFixed32(p53, n35)
		elseif v897 == proto.wireTypes.i64 then
			local v904

			v904, n35 = proto.readFixed64(p53, n35)
		else
			error("Unsupported wire type: " .. v897)
		end
	end

	return v894
end
function t82.jsonEncode(p54) -- line: 7423
	local t84 = {}

	if p54.universe_id ~= nil and p54.universe_id ~= "" then
		t84.universeId = p54.universe_id
	end

	if p54.user_owns_experience then
		t84.userOwnsExperience = p54.user_owns_experience
	end

	return t84
end
function t82.jsonDecode(t85: {[any]: any}) -- line: 7437
	-- upvalues: t82 (copy)
	local v908 = t82.new()

	if t85.universe_id ~= nil then
		v908.universe_id = t85.universe_id
	end

	if t85.universeId ~= nil then
		v908.universe_id = t85.universeId
	end

	if t85.user_owns_experience ~= nil then
		v908.user_owns_experience = t85.user_owns_experience
	end

	if t85.userOwnsExperience ~= nil then
		v908.user_owns_experience = t85.userOwnsExperience
	end

	return v908
end

t82.descriptor = {
	name = "ExperienceDetailsActionBarInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceDetailsActionBarInputData"
}
t1.ExperienceDetailsActionBarInputData = t82
typeRegistry.default:register(t1.ExperienceDetailsActionBarInputData)

local t86 = {}

t86.__index = t86

function t86.new(t87: {[any]: any}?) -- line: 7475
	-- upvalues: t86 (copy)
	return (setmetatable({
		media_asset_id = if t87 ~= nil and t87.media_asset_id ~= nil then t87.media_asset_id else ""
	}, t86))
end
function t86.encode(p55) -- line: 7483
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n36 = 0

	if p55.media_asset_id ~= nil and p55.media_asset_id ~= "" then
		local v913, v914 = proto.writeTag(buf, n36, 1, proto.wireTypes.lengthDelimited)

		buf, n36 = proto.writeString(v913, v914, p55.media_asset_id)
	end

	local buf22 = buffer.create(n36)

	buffer.copy(buf22, 0, buf, 0, n36)

	return buf22
end
function t86.decode(p56: buffer) -- line: 7497
	-- upvalues: t86 (copy), proto (copy)
	local v917 = t86.new()
	local n37 = 0

	while n37 < buffer.len(p56) do
		local v919, v920

		v919, v920, n37 = proto.readTag(p56, n37)

		if v920 == proto.wireTypes.varint then
			local v921

			v921, n37 = proto.readVarInt(p56, n37)
		elseif v920 == proto.wireTypes.lengthDelimited then
			if v919 == 1 then
				local v922

				v922, n37 = proto.readBuffer(p56, n37)
				v917.media_asset_id = buffer.tostring(v922)
			else
				local v923, v924 = proto.readVarInt(p56, n37)

				n37 = v924 + v923
			end
		elseif v920 == proto.wireTypes.i32 then
			local v925

			v925, n37 = proto.readFixed32(p56, n37)
		elseif v920 == proto.wireTypes.i64 then
			local v926

			v926, n37 = proto.readFixed64(p56, n37)
		else
			error("Unsupported wire type: " .. v920)
		end
	end

	return v917
end
function t86.jsonEncode(p57) -- line: 7540
	local t88 = {}

	if p57.media_asset_id ~= nil and p57.media_asset_id ~= "" then
		t88.mediaAssetId = p57.media_asset_id
	end

	return t88
end
function t86.jsonDecode(t89: {[any]: any}) -- line: 7550
	-- upvalues: t86 (copy)
	local v930 = t86.new()

	if t89.media_asset_id ~= nil then
		v930.media_asset_id = t89.media_asset_id
	end

	if t89.mediaAssetId ~= nil then
		v930.media_asset_id = t89.mediaAssetId
	end

	return v930
end

t86.descriptor = {
	name = "ExperienceDetailsBannerImageInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceDetailsBannerImageInputData"
}
t1.ExperienceDetailsBannerImageInputData = t86
typeRegistry.default:register(t1.ExperienceDetailsBannerImageInputData)

local t90 = {}

t90.__index = t90

function t90.new(t91: {[any]: any}?) -- line: 7580
	-- upvalues: t90 (copy)
	return (setmetatable({
		universe_id = if t91 ~= nil and t91.universe_id ~= nil then t91.universe_id else ""
	}, t90))
end
function t90.encode(p58) -- line: 7588
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n38 = 0

	if p58.universe_id ~= nil and p58.universe_id ~= "" then
		local v935, v936 = proto.writeTag(buf, n38, 1, proto.wireTypes.lengthDelimited)

		buf, n38 = proto.writeString(v935, v936, p58.universe_id)
	end

	local buf23 = buffer.create(n38)

	buffer.copy(buf23, 0, buf, 0, n38)

	return buf23
end
function t90.decode(p59: buffer) -- line: 7602
	-- upvalues: t90 (copy), proto (copy)
	local v939 = t90.new()
	local n39 = 0

	while n39 < buffer.len(p59) do
		local v941, v942

		v941, v942, n39 = proto.readTag(p59, n39)

		if v942 == proto.wireTypes.varint then
			local v943

			v943, n39 = proto.readVarInt(p59, n39)
		elseif v942 == proto.wireTypes.lengthDelimited then
			if v941 == 1 then
				local v944

				v944, n39 = proto.readBuffer(p59, n39)
				v939.universe_id = buffer.tostring(v944)
			else
				local v945, v946 = proto.readVarInt(p59, n39)

				n39 = v946 + v945
			end
		elseif v942 == proto.wireTypes.i32 then
			local v947

			v947, n39 = proto.readFixed32(p59, n39)
		elseif v942 == proto.wireTypes.i64 then
			local v948

			v948, n39 = proto.readFixed64(p59, n39)
		else
			error("Unsupported wire type: " .. v942)
		end
	end

	return v939
end
function t90.jsonEncode(p60) -- line: 7645
	local t92 = {}

	if p60.universe_id ~= nil and p60.universe_id ~= "" then
		t92.universeId = p60.universe_id
	end

	return t92
end
function t90.jsonDecode(t93: {[any]: any}) -- line: 7655
	-- upvalues: t90 (copy)
	local v952 = t90.new()

	if t93.universe_id ~= nil then
		v952.universe_id = t93.universe_id
	end

	if t93.universeId ~= nil then
		v952.universe_id = t93.universeId
	end

	return v952
end

t90.descriptor = {
	name = "ExperienceDetailsStickyHeaderInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceDetailsStickyHeaderInputData"
}
t1.ExperienceDetailsStickyHeaderInputData = t90
typeRegistry.default:register(t1.ExperienceDetailsStickyHeaderInputData)

local t94 = {}

t94.__index = t94

function t94.new(t95: {[any]: any}?) -- line: 7685
	-- upvalues: t94 (copy)
	return (setmetatable({
		universe_id = if t95 ~= nil and t95.universe_id ~= nil then t95.universe_id else "",
		creator_key = if t95 ~= nil and t95.creator_key ~= nil then t95.creator_key else ""
	}, t94))
end
function t94.encode(p61) -- line: 7694
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n40 = 0

	if p61.universe_id ~= nil and p61.universe_id ~= "" then
		local v957, v958 = proto.writeTag(buf, n40, 1, proto.wireTypes.lengthDelimited)

		buf, n40 = proto.writeString(v957, v958, p61.universe_id)
	end

	if p61.creator_key ~= nil and p61.creator_key ~= "" then
		local v959, v960 = proto.writeTag(buf, n40, 2, proto.wireTypes.lengthDelimited)

		buf, n40 = proto.writeString(v959, v960, p61.creator_key)
	end

	local buf24 = buffer.create(n40)

	buffer.copy(buf24, 0, buf, 0, n40)

	return buf24
end
function t94.decode(p62: buffer) -- line: 7713
	-- upvalues: t94 (copy), proto (copy)
	local v963 = t94.new()
	local n41 = 0

	while n41 < buffer.len(p62) do
		local v965, v966

		v965, v966, n41 = proto.readTag(p62, n41)

		if v966 == proto.wireTypes.varint then
			local v967

			v967, n41 = proto.readVarInt(p62, n41)
		elseif v966 == proto.wireTypes.lengthDelimited then
			if v965 == 1 then
				local v968

				v968, n41 = proto.readBuffer(p62, n41)
				v963.universe_id = buffer.tostring(v968)
			elseif v965 == 2 then
				local v969

				v969, n41 = proto.readBuffer(p62, n41)
				v963.creator_key = buffer.tostring(v969)
			else
				local v970, v971 = proto.readVarInt(p62, n41)

				n41 = v971 + v970
			end
		elseif v966 == proto.wireTypes.i32 then
			local v972

			v972, n41 = proto.readFixed32(p62, n41)
		elseif v966 == proto.wireTypes.i64 then
			local v973

			v973, n41 = proto.readFixed64(p62, n41)
		else
			error("Unsupported wire type: " .. v966)
		end
	end

	return v963
end
function t94.jsonEncode(p63) -- line: 7761
	local t96 = {}

	if p63.universe_id ~= nil and p63.universe_id ~= "" then
		t96.universeId = p63.universe_id
	end

	if p63.creator_key ~= nil and p63.creator_key ~= "" then
		t96.creatorKey = p63.creator_key
	end

	return t96
end
function t94.jsonDecode(t97: {[any]: any}) -- line: 7775
	-- upvalues: t94 (copy)
	local v977 = t94.new()

	if t97.universe_id ~= nil then
		v977.universe_id = t97.universe_id
	end

	if t97.universeId ~= nil then
		v977.universe_id = t97.universeId
	end

	if t97.creator_key ~= nil then
		v977.creator_key = t97.creator_key
	end

	if t97.creatorKey ~= nil then
		v977.creator_key = t97.creatorKey
	end

	return v977
end

t94.descriptor = {
	name = "ExperienceAttributionRowInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceAttributionRowInputData"
}
t1.ExperienceAttributionRowInputData = t94
typeRegistry.default:register(t1.ExperienceAttributionRowInputData)

local t98 = {}

t98.__index = t98

function t98.new(t99: {[any]: any}?) -- line: 7813
	-- upvalues: t98 (copy)
	return (setmetatable({
		universe_id = if t99 ~= nil and t99.universe_id ~= nil then t99.universe_id else "",
		root_place_id = if t99 ~= nil and t99.root_place_id ~= nil then t99.root_place_id else "",
		connection_played_display_name = if t99 ~= nil and t99.connection_played_display_name ~= nil then t99.connection_played_display_name else "",
		upsell_prompt = if t99 ~= nil and t99.upsell_prompt ~= nil then t99.upsell_prompt else "",
		connection_played_users = if t99 ~= nil and t99.connection_played_users ~= nil then t99.connection_played_users else {},
		connection_played_num_others = if t99 ~= nil and t99.connection_played_num_others ~= nil then t99.connection_played_num_others else 0,
		connection_played_total_count = if t99 ~= nil and t99.connection_played_total_count ~= nil then t99.connection_played_total_count else 0
	}, t98))
end
function t98.encode(p64) -- line: 7835
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n42 = 0

	if p64.universe_id ~= nil and p64.universe_id ~= "" then
		local v982, v983 = proto.writeTag(buf, n42, 1, proto.wireTypes.lengthDelimited)

		buf, n42 = proto.writeString(v982, v983, p64.universe_id)
	end

	if p64.root_place_id ~= nil and p64.root_place_id ~= "" then
		local v984, v985 = proto.writeTag(buf, n42, 2, proto.wireTypes.lengthDelimited)

		buf, n42 = proto.writeString(v984, v985, p64.root_place_id)
	end

	if p64.connection_played_display_name ~= nil and p64.connection_played_display_name ~= "" then
		local v986, v987 = proto.writeTag(buf, n42, 3, proto.wireTypes.lengthDelimited)

		buf, n42 = proto.writeString(v986, v987, p64.connection_played_display_name)
	end

	if p64.upsell_prompt ~= nil and p64.upsell_prompt ~= "" then
		local v988, v989 = proto.writeTag(buf, n42, 4, proto.wireTypes.lengthDelimited)

		buf, n42 = proto.writeString(v988, v989, p64.upsell_prompt)
	end

	if p64.connection_played_users ~= nil and #p64.connection_played_users > 0 then
		for _, v991 in p64.connection_played_users do
			local v992 = v991:encode()
			local v993, v994 = proto.writeTag(buf, n42, 5, proto.wireTypes.lengthDelimited)

			buf, n42 = proto.writeBuffer(v993, v994, v992, buffer.len(v992))
		end
	end

	if p64.connection_played_num_others ~= nil and p64.connection_played_num_others ~= 0 then
		local v995, v996 = proto.writeTag(buf, n42, 6, proto.wireTypes.varint)

		buf, n42 = proto.writeVarInt(v995, v996, p64.connection_played_num_others)
	end

	if p64.connection_played_total_count ~= nil and p64.connection_played_total_count ~= 0 then
		local v997, v998 = proto.writeTag(buf, n42, 7, proto.wireTypes.varint)

		buf, n42 = proto.writeVarInt(v997, v998, p64.connection_played_total_count)
	end

	local buf25 = buffer.create(n42)

	buffer.copy(buf25, 0, buf, 0, n42)

	return buf25
end
function t98.decode(p65: buffer) -- line: 7882
	-- upvalues: t98 (copy), proto (copy), t1 (copy)
	local v1001 = t98.new()
	local n43 = 0

	while n43 < buffer.len(p65) do
		local v1003, v1004

		v1003, v1004, n43 = proto.readTag(p65, n43)

		if v1004 == proto.wireTypes.varint then
			if v1003 == 6 then
				local v1005

				v1005, n43 = proto.readVarIntI32(p65, n43)
				v1001.connection_played_num_others = v1005
			elseif v1003 == 7 then
				local v1006

				v1006, n43 = proto.readVarIntI32(p65, n43)
				v1001.connection_played_total_count = v1006
			else
				local v1007

				v1007, n43 = proto.readVarInt(p65, n43)
			end
		elseif v1004 == proto.wireTypes.lengthDelimited then
			if v1003 == 1 then
				local v1008

				v1008, n43 = proto.readBuffer(p65, n43)
				v1001.universe_id = buffer.tostring(v1008)
			elseif v1003 == 2 then
				local v1009

				v1009, n43 = proto.readBuffer(p65, n43)
				v1001.root_place_id = buffer.tostring(v1009)
			elseif v1003 == 3 then
				local v1010

				v1010, n43 = proto.readBuffer(p65, n43)
				v1001.connection_played_display_name = buffer.tostring(v1010)
			elseif v1003 == 4 then
				local v1011

				v1011, n43 = proto.readBuffer(p65, n43)
				v1001.upsell_prompt = buffer.tostring(v1011)
			elseif v1003 == 5 then
				local v1012

				v1012, n43 = proto.readBuffer(p65, n43)
				table.insert(v1001.connection_played_users, t1.ExperienceActionModuleInputData_ConnectionPlayedUser.decode(v1012))
			else
				local v1013, v1014 = proto.readVarInt(p65, n43)

				n43 = v1014 + v1013
			end
		elseif v1004 == proto.wireTypes.i32 then
			local v1015

			v1015, n43 = proto.readFixed32(p65, n43)
		elseif v1004 == proto.wireTypes.i64 then
			local v1016

			v1016, n43 = proto.readFixed64(p65, n43)
		else
			error("Unsupported wire type: " .. v1004)
		end
	end

	return v1001
end
function t98.jsonEncode(p66) -- line: 7958
	local t100 = {}

	if p66.universe_id ~= nil and p66.universe_id ~= "" then
		t100.universeId = p66.universe_id
	end

	if p66.root_place_id ~= nil and p66.root_place_id ~= "" then
		t100.rootPlaceId = p66.root_place_id
	end

	if p66.connection_played_display_name ~= nil and p66.connection_played_display_name ~= "" then
		t100.connectionPlayedDisplayName = p66.connection_played_display_name
	end

	if p66.upsell_prompt ~= nil and p66.upsell_prompt ~= "" then
		t100.upsellPrompt = p66.upsell_prompt
	end

	if p66.connection_played_users ~= nil and #p66.connection_played_users > 0 then
		local t101 = {}

		for _, v1021 in p66.connection_played_users do
			table.insert(t101, v1021:jsonEncode())
		end

		t100.connectionPlayedUsers = t101
	end

	if p66.connection_played_num_others ~= nil and p66.connection_played_num_others ~= 0 then
		t100.connectionPlayedNumOthers = p66.connection_played_num_others
	end

	if p66.connection_played_total_count ~= nil and p66.connection_played_total_count ~= 0 then
		t100.connectionPlayedTotalCount = p66.connection_played_total_count
	end

	return t100
end
function t98.jsonDecode(t102: {[any]: any}) -- line: 7996
	-- upvalues: t98 (copy), t1 (copy)
	local v1023 = t98.new()

	if t102.universe_id ~= nil then
		v1023.universe_id = t102.universe_id
	end

	if t102.universeId ~= nil then
		v1023.universe_id = t102.universeId
	end

	if t102.root_place_id ~= nil then
		v1023.root_place_id = t102.root_place_id
	end

	if t102.rootPlaceId ~= nil then
		v1023.root_place_id = t102.rootPlaceId
	end

	if t102.connection_played_display_name ~= nil then
		v1023.connection_played_display_name = t102.connection_played_display_name
	end

	if t102.connectionPlayedDisplayName ~= nil then
		v1023.connection_played_display_name = t102.connectionPlayedDisplayName
	end

	if t102.upsell_prompt ~= nil then
		v1023.upsell_prompt = t102.upsell_prompt
	end

	if t102.upsellPrompt ~= nil then
		v1023.upsell_prompt = t102.upsellPrompt
	end

	if t102.connection_played_users ~= nil then
		local t103 = {}

		for _, v1026 in t102.connection_played_users do
			table.insert(t103, t1.ExperienceActionModuleInputData_ConnectionPlayedUser.jsonDecode(v1026))
		end

		v1023.connection_played_users = t103
	end

	if t102.connectionPlayedUsers ~= nil then
		local t104 = {}

		for _, v1029 in t102.connectionPlayedUsers do
			table.insert(t104, t1.ExperienceActionModuleInputData_ConnectionPlayedUser.jsonDecode(v1029))
		end

		v1023.connection_played_users = t104
	end

	if t102.connection_played_num_others ~= nil then
		v1023.connection_played_num_others = t102.connection_played_num_others
	end

	if t102.connectionPlayedNumOthers ~= nil then
		v1023.connection_played_num_others = t102.connectionPlayedNumOthers
	end

	if t102.connection_played_total_count ~= nil then
		v1023.connection_played_total_count = t102.connection_played_total_count
	end

	if t102.connectionPlayedTotalCount ~= nil then
		v1023.connection_played_total_count = t102.connectionPlayedTotalCount
	end

	return v1023
end

t98.descriptor = {
	name = "ExperienceActionModuleInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceActionModuleInputData"
}
t1.ExperienceActionModuleInputData = t98
typeRegistry.default:register(t1.ExperienceActionModuleInputData)

local t105 = {}

t105.__index = t105

function t105.new(t106: {[any]: any}?) -- line: 8083
	-- upvalues: t105 (copy)
	return (setmetatable({
		user_id = if t106 ~= nil and t106.user_id ~= nil then t106.user_id else ""
	}, t105))
end
function t105.encode(p67) -- line: 8094
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n44 = 0

	if p67.user_id ~= nil and p67.user_id ~= "" then
		local v1034, v1035 = proto.writeTag(buf, n44, 1, proto.wireTypes.lengthDelimited)

		buf, n44 = proto.writeString(v1034, v1035, p67.user_id)
	end

	local buf26 = buffer.create(n44)

	buffer.copy(buf26, 0, buf, 0, n44)

	return buf26
end
function t105.decode(p68: buffer) -- line: 8110
	-- upvalues: t105 (copy), proto (copy)
	local v1038 = t105.new()
	local n45 = 0

	while n45 < buffer.len(p68) do
		local v1040, v1041

		v1040, v1041, n45 = proto.readTag(p68, n45)

		if v1041 == proto.wireTypes.varint then
			local v1042

			v1042, n45 = proto.readVarInt(p68, n45)
		elseif v1041 == proto.wireTypes.lengthDelimited then
			if v1040 == 1 then
				local v1043

				v1043, n45 = proto.readBuffer(p68, n45)
				v1038.user_id = buffer.tostring(v1043)
			else
				local v1044, v1045 = proto.readVarInt(p68, n45)

				n45 = v1045 + v1044
			end
		elseif v1041 == proto.wireTypes.i32 then
			local v1046

			v1046, n45 = proto.readFixed32(p68, n45)
		elseif v1041 == proto.wireTypes.i64 then
			local v1047

			v1047, n45 = proto.readFixed64(p68, n45)
		else
			error("Unsupported wire type: " .. v1041)
		end
	end

	return v1038
end
function t105.jsonEncode(p69) -- line: 8155
	local t107 = {}

	if p69.user_id ~= nil and p69.user_id ~= "" then
		t107.userId = p69.user_id
	end

	return t107
end
function t105.jsonDecode(t108: {[any]: any}) -- line: 8167
	-- upvalues: t105 (copy)
	local v1051 = t105.new()

	if t108.user_id ~= nil then
		v1051.user_id = t108.user_id
	end

	if t108.userId ~= nil then
		v1051.user_id = t108.userId
	end

	return v1051
end

t105.descriptor = {
	name = "ExperienceActionModuleInputData_ConnectionPlayedUser",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConnectionPlayedUser"
}
t1.ExperienceActionModuleInputData_ConnectionPlayedUser = t105
typeRegistry.default:register(t1.ExperienceActionModuleInputData_ConnectionPlayedUser)

local t109 = {}

t109.__index = t109

function t109.new(t110: {[any]: any}?) -- line: 8198
	-- upvalues: t109 (copy)
	return (setmetatable({
		media_items = if t110 ~= nil and t110.media_items ~= nil then t110.media_items else {},
		universe_id = if t110 ~= nil and t110.universe_id ~= nil then t110.universe_id else "",
		place_id = if t110 ~= nil and t110.place_id ~= nil then t110.place_id else ""
	}, t109))
end
function t109.encode(p70) -- line: 8208
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n46 = 0

	if p70.media_items ~= nil and #p70.media_items > 0 then
		for _, v1057 in p70.media_items do
			local v1058 = v1057:encode()
			local v1059, v1060 = proto.writeTag(buf, n46, 1, proto.wireTypes.lengthDelimited)

			buf, n46 = proto.writeBuffer(v1059, v1060, v1058, buffer.len(v1058))
		end
	end

	if p70.universe_id ~= nil and p70.universe_id ~= "" then
		local v1061, v1062 = proto.writeTag(buf, n46, 2, proto.wireTypes.lengthDelimited)

		buf, n46 = proto.writeString(v1061, v1062, p70.universe_id)
	end

	if p70.place_id ~= nil and p70.place_id ~= "" then
		local v1063, v1064 = proto.writeTag(buf, n46, 3, proto.wireTypes.lengthDelimited)

		buf, n46 = proto.writeString(v1063, v1064, p70.place_id)
	end

	local buf27 = buffer.create(n46)

	buffer.copy(buf27, 0, buf, 0, n46)

	return buf27
end
function t109.decode(p71: buffer) -- line: 8235
	-- upvalues: t109 (copy), proto (copy), t1 (copy)
	local v1067 = t109.new()
	local n47 = 0

	while n47 < buffer.len(p71) do
		local v1069, v1070

		v1069, v1070, n47 = proto.readTag(p71, n47)

		if v1070 == proto.wireTypes.varint then
			local v1071

			v1071, n47 = proto.readVarInt(p71, n47)
		elseif v1070 == proto.wireTypes.lengthDelimited then
			if v1069 == 1 then
				local v1072

				v1072, n47 = proto.readBuffer(p71, n47)
				table.insert(v1067.media_items, t1.ExperienceMediaGalleryInputData_MediaItem.decode(v1072))
			elseif v1069 == 2 then
				local v1073

				v1073, n47 = proto.readBuffer(p71, n47)
				v1067.universe_id = buffer.tostring(v1073)
			elseif v1069 == 3 then
				local v1074

				v1074, n47 = proto.readBuffer(p71, n47)
				v1067.place_id = buffer.tostring(v1074)
			else
				local v1075, v1076 = proto.readVarInt(p71, n47)

				n47 = v1076 + v1075
			end
		elseif v1070 == proto.wireTypes.i32 then
			local v1077

			v1077, n47 = proto.readFixed32(p71, n47)
		elseif v1070 == proto.wireTypes.i64 then
			local v1078

			v1078, n47 = proto.readFixed64(p71, n47)
		else
			error("Unsupported wire type: " .. v1070)
		end
	end

	return v1067
end
function t109.jsonEncode(p72) -- line: 8288
	local t111 = {}

	if p72.media_items ~= nil and #p72.media_items > 0 then
		local t112 = {}

		for _, v1083 in p72.media_items do
			table.insert(t112, v1083:jsonEncode())
		end

		t111.mediaItems = t112
	end

	if p72.universe_id ~= nil and p72.universe_id ~= "" then
		t111.universeId = p72.universe_id
	end

	if p72.place_id ~= nil and p72.place_id ~= "" then
		t111.placeId = p72.place_id
	end

	return t111
end
function t109.jsonDecode(t113: {[any]: any}) -- line: 8310
	-- upvalues: t109 (copy), t1 (copy)
	local v1085 = t109.new()

	if t113.media_items ~= nil then
		local t114 = {}

		for _, v1088 in t113.media_items do
			table.insert(t114, t1.ExperienceMediaGalleryInputData_MediaItem.jsonDecode(v1088))
		end

		v1085.media_items = t114
	end

	if t113.mediaItems ~= nil then
		local t115 = {}

		for _, v1091 in t113.mediaItems do
			table.insert(t115, t1.ExperienceMediaGalleryInputData_MediaItem.jsonDecode(v1091))
		end

		v1085.media_items = t115
	end

	if t113.universe_id ~= nil then
		v1085.universe_id = t113.universe_id
	end

	if t113.universeId ~= nil then
		v1085.universe_id = t113.universeId
	end

	if t113.place_id ~= nil then
		v1085.place_id = t113.place_id
	end

	if t113.placeId ~= nil then
		v1085.place_id = t113.placeId
	end

	return v1085
end

t109.descriptor = {
	name = "ExperienceMediaGalleryInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceMediaGalleryInputData"
}
t1.ExperienceMediaGalleryInputData = t109
typeRegistry.default:register(t1.ExperienceMediaGalleryInputData)

local t116 = {}

t116.__index = t116

function t116.new(t117: {[any]: any}?) -- line: 8364
	-- upvalues: t116 (copy)
	return (setmetatable({
		media_asset_id = if t117 ~= nil and t117.media_asset_id ~= nil then t117.media_asset_id else ""
	}, t116))
end
function t116.encode(p73) -- line: 8372
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n48 = 0

	if p73.media_asset_id ~= nil and p73.media_asset_id ~= "" then
		local v1096, v1097 = proto.writeTag(buf, n48, 1, proto.wireTypes.lengthDelimited)

		buf, n48 = proto.writeString(v1096, v1097, p73.media_asset_id)
	end

	local buf28 = buffer.create(n48)

	buffer.copy(buf28, 0, buf, 0, n48)

	return buf28
end
function t116.decode(p74: buffer) -- line: 8388
	-- upvalues: t116 (copy), proto (copy)
	local v1100 = t116.new()
	local n49 = 0

	while n49 < buffer.len(p74) do
		local v1102, v1103

		v1102, v1103, n49 = proto.readTag(p74, n49)

		if v1103 == proto.wireTypes.varint then
			local v1104

			v1104, n49 = proto.readVarInt(p74, n49)
		elseif v1103 == proto.wireTypes.lengthDelimited then
			if v1102 == 1 then
				local v1105

				v1105, n49 = proto.readBuffer(p74, n49)
				v1100.media_asset_id = buffer.tostring(v1105)
			else
				local v1106, v1107 = proto.readVarInt(p74, n49)

				n49 = v1107 + v1106
			end
		elseif v1103 == proto.wireTypes.i32 then
			local v1108

			v1108, n49 = proto.readFixed32(p74, n49)
		elseif v1103 == proto.wireTypes.i64 then
			local v1109

			v1109, n49 = proto.readFixed64(p74, n49)
		else
			error("Unsupported wire type: " .. v1103)
		end
	end

	return v1100
end
function t116.jsonEncode(p75) -- line: 8433
	local t118 = {}

	if p75.media_asset_id ~= nil and p75.media_asset_id ~= "" then
		t118.mediaAssetId = p75.media_asset_id
	end

	return t118
end
function t116.jsonDecode(t119: {[any]: any}) -- line: 8445
	-- upvalues: t116 (copy)
	local v1113 = t116.new()

	if t119.media_asset_id ~= nil then
		v1113.media_asset_id = t119.media_asset_id
	end

	if t119.mediaAssetId ~= nil then
		v1113.media_asset_id = t119.mediaAssetId
	end

	return v1113
end

t116.descriptor = {
	name = "ExperienceMediaGalleryInputData_MediaItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.MediaItem"
}
t1.ExperienceMediaGalleryInputData_MediaItem = t116
typeRegistry.default:register(t1.ExperienceMediaGalleryInputData_MediaItem)

local t120 = {}

t120.__index = t120

function t120.new(t121: {[any]: any}?) -- line: 8475
	-- upvalues: t120 (copy)
	return (setmetatable({
		universe_id = if t121 ~= nil and t121.universe_id ~= nil then t121.universe_id else ""
	}, t120))
end
function t120.encode(p76) -- line: 8483
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n50 = 0

	if p76.universe_id ~= nil and p76.universe_id ~= "" then
		local v1118, v1119 = proto.writeTag(buf, n50, 1, proto.wireTypes.lengthDelimited)

		buf, n50 = proto.writeString(v1118, v1119, p76.universe_id)
	end

	local buf29 = buffer.create(n50)

	buffer.copy(buf29, 0, buf, 0, n50)

	return buf29
end
function t120.decode(p77: buffer) -- line: 8497
	-- upvalues: t120 (copy), proto (copy)
	local v1122 = t120.new()
	local n51 = 0

	while n51 < buffer.len(p77) do
		local v1124, v1125

		v1124, v1125, n51 = proto.readTag(p77, n51)

		if v1125 == proto.wireTypes.varint then
			local v1126

			v1126, n51 = proto.readVarInt(p77, n51)
		elseif v1125 == proto.wireTypes.lengthDelimited then
			if v1124 == 1 then
				local v1127

				v1127, n51 = proto.readBuffer(p77, n51)
				v1122.universe_id = buffer.tostring(v1127)
			else
				local v1128, v1129 = proto.readVarInt(p77, n51)

				n51 = v1129 + v1128
			end
		elseif v1125 == proto.wireTypes.i32 then
			local v1130

			v1130, n51 = proto.readFixed32(p77, n51)
		elseif v1125 == proto.wireTypes.i64 then
			local v1131

			v1131, n51 = proto.readFixed64(p77, n51)
		else
			error("Unsupported wire type: " .. v1125)
		end
	end

	return v1122
end
function t120.jsonEncode(p78) -- line: 8540
	local t122 = {}

	if p78.universe_id ~= nil and p78.universe_id ~= "" then
		t122.universeId = p78.universe_id
	end

	return t122
end
function t120.jsonDecode(t123: {[any]: any}) -- line: 8550
	-- upvalues: t120 (copy)
	local v1135 = t120.new()

	if t123.universe_id ~= nil then
		v1135.universe_id = t123.universe_id
	end

	if t123.universeId ~= nil then
		v1135.universe_id = t123.universeId
	end

	return v1135
end

t120.descriptor = {
	name = "ExperienceDescriptionInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceDescriptionInputData"
}
t1.ExperienceDescriptionInputData = t120
typeRegistry.default:register(t1.ExperienceDescriptionInputData)

local t124 = {}

t124.__index = t124

function t124.new(t125: {[any]: any}?) -- line: 8578
	-- upvalues: t124 (copy)
	return (setmetatable({
		universe_id = if t125 ~= nil and t125.universe_id ~= nil then t125.universe_id else ""
	}, t124))
end
function t124.encode(p79) -- line: 8586
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n52 = 0

	if p79.universe_id ~= nil and p79.universe_id ~= "" then
		local v1140, v1141 = proto.writeTag(buf, n52, 1, proto.wireTypes.lengthDelimited)

		buf, n52 = proto.writeString(v1140, v1141, p79.universe_id)
	end

	local buf30 = buffer.create(n52)

	buffer.copy(buf30, 0, buf, 0, n52)

	return buf30
end
function t124.decode(p80: buffer) -- line: 8600
	-- upvalues: t124 (copy), proto (copy)
	local v1144 = t124.new()
	local n53 = 0

	while n53 < buffer.len(p80) do
		local v1146, v1147

		v1146, v1147, n53 = proto.readTag(p80, n53)

		if v1147 == proto.wireTypes.varint then
			local v1148

			v1148, n53 = proto.readVarInt(p80, n53)
		elseif v1147 == proto.wireTypes.lengthDelimited then
			if v1146 == 1 then
				local v1149

				v1149, n53 = proto.readBuffer(p80, n53)
				v1144.universe_id = buffer.tostring(v1149)
			else
				local v1150, v1151 = proto.readVarInt(p80, n53)

				n53 = v1151 + v1150
			end
		elseif v1147 == proto.wireTypes.i32 then
			local v1152

			v1152, n53 = proto.readFixed32(p80, n53)
		elseif v1147 == proto.wireTypes.i64 then
			local v1153

			v1153, n53 = proto.readFixed64(p80, n53)
		else
			error("Unsupported wire type: " .. v1147)
		end
	end

	return v1144
end
function t124.jsonEncode(p81) -- line: 8643
	local t126 = {}

	if p81.universe_id ~= nil and p81.universe_id ~= "" then
		t126.universeId = p81.universe_id
	end

	return t126
end
function t124.jsonDecode(t127: {[any]: any}) -- line: 8653
	-- upvalues: t124 (copy)
	local v1157 = t124.new()

	if t127.universe_id ~= nil then
		v1157.universe_id = t127.universe_id
	end

	if t127.universeId ~= nil then
		v1157.universe_id = t127.universeId
	end

	return v1157
end

t124.descriptor = {
	name = "ExperienceStatRowInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceStatRowInputData"
}
t1.ExperienceStatRowInputData = t124
typeRegistry.default:register(t1.ExperienceStatRowInputData)

local t128 = {}

t128.__index = t128

function t128.new(t129: {[any]: any}?) -- line: 8681
	-- upvalues: t128 (copy)
	return (setmetatable({
		universe_id = if t129 ~= nil and t129.universe_id ~= nil then t129.universe_id else "",
		has_store_items = t129 ~= nil and (t129.has_store_items ~= nil and t129.has_store_items),
		has_badges = t129 ~= nil and (t129.has_badges ~= nil and t129.has_badges),
		has_game_passes = t129 ~= nil and (t129.has_game_passes ~= nil and t129.has_game_passes)
	}, t128))
end
function t128.encode(p82) -- line: 8692
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n54 = 0

	if p82.universe_id ~= nil and p82.universe_id ~= "" then
		local v1162, v1163 = proto.writeTag(buf, n54, 1, proto.wireTypes.lengthDelimited)

		buf, n54 = proto.writeString(v1162, v1163, p82.universe_id)
	end

	if p82.has_store_items then
		local v1164, v1165 = proto.writeTag(buf, n54, 2, proto.wireTypes.varint)

		buf, n54 = proto.writeVarInt(v1164, v1165, not p82.has_store_items and 0 or 1)
	end

	if p82.has_badges then
		local v1166, v1167 = proto.writeTag(buf, n54, 3, proto.wireTypes.varint)

		buf, n54 = proto.writeVarInt(v1166, v1167, not p82.has_badges and 0 or 1)
	end

	if p82.has_game_passes then
		local v1168, v1169 = proto.writeTag(buf, n54, 4, proto.wireTypes.varint)

		buf, n54 = proto.writeVarInt(v1168, v1169, not p82.has_game_passes and 0 or 1)
	end

	local buf31 = buffer.create(n54)

	buffer.copy(buf31, 0, buf, 0, n54)

	return buf31
end
function t128.decode(p83: buffer) -- line: 8721
	-- upvalues: t128 (copy), proto (copy)
	local v1172 = t128.new()
	local n55 = 0

	while n55 < buffer.len(p83) do
		local v1174, v1175

		v1174, v1175, n55 = proto.readTag(p83, n55)

		if v1175 == proto.wireTypes.varint then
			if v1174 == 2 then
				local v1176

				v1176, n55 = proto.readVarInt(p83, n55)
				v1172.has_store_items = v1176 ~= 0
			elseif v1174 == 3 then
				local v1177

				v1177, n55 = proto.readVarInt(p83, n55)
				v1172.has_badges = v1177 ~= 0
			elseif v1174 == 4 then
				local v1178

				v1178, n55 = proto.readVarInt(p83, n55)
				v1172.has_game_passes = v1178 ~= 0
			else
				local v1179

				v1179, n55 = proto.readVarInt(p83, n55)
			end
		elseif v1175 == proto.wireTypes.lengthDelimited then
			if v1174 == 1 then
				local v1180

				v1180, n55 = proto.readBuffer(p83, n55)
				v1172.universe_id = buffer.tostring(v1180)
			else
				local v1181, v1182 = proto.readVarInt(p83, n55)

				n55 = v1182 + v1181
			end
		elseif v1175 == proto.wireTypes.i32 then
			local v1183

			v1183, n55 = proto.readFixed32(p83, n55)
		elseif v1175 == proto.wireTypes.i64 then
			local v1184

			v1184, n55 = proto.readFixed64(p83, n55)
		else
			error("Unsupported wire type: " .. v1175)
		end
	end

	return v1172
end
function t128.jsonEncode(p84) -- line: 8779
	local t130 = {}

	if p84.universe_id ~= nil and p84.universe_id ~= "" then
		t130.universeId = p84.universe_id
	end

	if p84.has_store_items then
		t130.hasStoreItems = p84.has_store_items
	end

	if p84.has_badges then
		t130.hasBadges = p84.has_badges
	end

	if p84.has_game_passes then
		t130.hasGamePasses = p84.has_game_passes
	end

	return t130
end
function t128.jsonDecode(t131: {[any]: any}) -- line: 8801
	-- upvalues: t128 (copy)
	local v1188 = t128.new()

	if t131.universe_id ~= nil then
		v1188.universe_id = t131.universe_id
	end

	if t131.universeId ~= nil then
		v1188.universe_id = t131.universeId
	end

	if t131.has_store_items ~= nil then
		v1188.has_store_items = t131.has_store_items
	end

	if t131.hasStoreItems ~= nil then
		v1188.has_store_items = t131.hasStoreItems
	end

	if t131.has_badges ~= nil then
		v1188.has_badges = t131.has_badges
	end

	if t131.hasBadges ~= nil then
		v1188.has_badges = t131.hasBadges
	end

	if t131.has_game_passes ~= nil then
		v1188.has_game_passes = t131.has_game_passes
	end

	if t131.hasGamePasses ~= nil then
		v1188.has_game_passes = t131.hasGamePasses
	end

	return v1188
end

t128.descriptor = {
	name = "ExperienceInfoTableInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceInfoTableInputData"
}
t1.ExperienceInfoTableInputData = t128
typeRegistry.default:register(t1.ExperienceInfoTableInputData)

local t132 = {}

t132.__index = t132

function t132.new(t133: {[any]: any}?) -- line: 8853
	-- upvalues: t132 (copy)
	return (setmetatable({
		universe_id = if t133 ~= nil and t133.universe_id ~= nil then t133.universe_id else ""
	}, t132))
end
function t132.encode(p85) -- line: 8861
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n56 = 0

	if p85.universe_id ~= nil and p85.universe_id ~= "" then
		local v1193, v1194 = proto.writeTag(buf, n56, 1, proto.wireTypes.lengthDelimited)

		buf, n56 = proto.writeString(v1193, v1194, p85.universe_id)
	end

	local buf32 = buffer.create(n56)

	buffer.copy(buf32, 0, buf, 0, n56)

	return buf32
end
function t132.decode(p86: buffer) -- line: 8875
	-- upvalues: t132 (copy), proto (copy)
	local v1197 = t132.new()
	local n57 = 0

	while n57 < buffer.len(p86) do
		local v1199, v1200

		v1199, v1200, n57 = proto.readTag(p86, n57)

		if v1200 == proto.wireTypes.varint then
			local v1201

			v1201, n57 = proto.readVarInt(p86, n57)
		elseif v1200 == proto.wireTypes.lengthDelimited then
			if v1199 == 1 then
				local v1202

				v1202, n57 = proto.readBuffer(p86, n57)
				v1197.universe_id = buffer.tostring(v1202)
			else
				local v1203, v1204 = proto.readVarInt(p86, n57)

				n57 = v1204 + v1203
			end
		elseif v1200 == proto.wireTypes.i32 then
			local v1205

			v1205, n57 = proto.readFixed32(p86, n57)
		elseif v1200 == proto.wireTypes.i64 then
			local v1206

			v1206, n57 = proto.readFixed64(p86, n57)
		else
			error("Unsupported wire type: " .. v1200)
		end
	end

	return v1197
end
function t132.jsonEncode(p87) -- line: 8918
	local t134 = {}

	if p87.universe_id ~= nil and p87.universe_id ~= "" then
		t134.universeId = p87.universe_id
	end

	return t134
end
function t132.jsonDecode(t135: {[any]: any}) -- line: 8928
	-- upvalues: t132 (copy)
	local v1210 = t132.new()

	if t135.universe_id ~= nil then
		v1210.universe_id = t135.universe_id
	end

	if t135.universeId ~= nil then
		v1210.universe_id = t135.universeId
	end

	return v1210
end

t132.descriptor = {
	name = "ExperienceContentRatingLabelInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceContentRatingLabelInputData"
}
t1.ExperienceContentRatingLabelInputData = t132
typeRegistry.default:register(t1.ExperienceContentRatingLabelInputData)

local t136 = {}

t136.__index = t136

function t136.new(t137: {[any]: any}?) -- line: 8958
	-- upvalues: t136 (copy)
	return (setmetatable({
		universe_id = if t137 ~= nil and t137.universe_id ~= nil then t137.universe_id else "",
		user_owns_experience = t137 ~= nil and (t137.user_owns_experience ~= nil and t137.user_owns_experience)
	}, t136))
end
function t136.encode(p88) -- line: 8969
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n58 = 0

	if p88.universe_id ~= nil and p88.universe_id ~= "" then
		local v1215, v1216 = proto.writeTag(buf, n58, 1, proto.wireTypes.lengthDelimited)

		buf, n58 = proto.writeString(v1215, v1216, p88.universe_id)
	end

	if p88.user_owns_experience then
		local v1217, v1218 = proto.writeTag(buf, n58, 2, proto.wireTypes.varint)

		buf, n58 = proto.writeVarInt(v1217, v1218, not p88.user_owns_experience and 0 or 1)
	end

	local buf33 = buffer.create(n58)

	buffer.copy(buf33, 0, buf, 0, n58)

	return buf33
end
function t136.decode(p89: buffer) -- line: 8988
	-- upvalues: t136 (copy), proto (copy)
	local v1221 = t136.new()
	local n59 = 0

	while n59 < buffer.len(p89) do
		local v1223, v1224

		v1223, v1224, n59 = proto.readTag(p89, n59)

		if v1224 == proto.wireTypes.varint then
			if v1223 == 2 then
				local v1225

				v1225, n59 = proto.readVarInt(p89, n59)
				v1221.user_owns_experience = v1225 ~= 0
			else
				local v1226

				v1226, n59 = proto.readVarInt(p89, n59)
			end
		elseif v1224 == proto.wireTypes.lengthDelimited then
			if v1223 == 1 then
				local v1227

				v1227, n59 = proto.readBuffer(p89, n59)
				v1221.universe_id = buffer.tostring(v1227)
			else
				local v1228, v1229 = proto.readVarInt(p89, n59)

				n59 = v1229 + v1228
			end
		elseif v1224 == proto.wireTypes.i32 then
			local v1230

			v1230, n59 = proto.readFixed32(p89, n59)
		elseif v1224 == proto.wireTypes.i64 then
			local v1231

			v1231, n59 = proto.readFixed64(p89, n59)
		else
			error("Unsupported wire type: " .. v1224)
		end
	end

	return v1221
end
function t136.jsonEncode(p90) -- line: 9036
	local t138 = {}

	if p90.universe_id ~= nil and p90.universe_id ~= "" then
		t138.universeId = p90.universe_id
	end

	if p90.user_owns_experience then
		t138.userOwnsExperience = p90.user_owns_experience
	end

	return t138
end
function t136.jsonDecode(t139: {[any]: any}) -- line: 9050
	-- upvalues: t136 (copy)
	local v1235 = t136.new()

	if t139.universe_id ~= nil then
		v1235.universe_id = t139.universe_id
	end

	if t139.universeId ~= nil then
		v1235.universe_id = t139.universeId
	end

	if t139.user_owns_experience ~= nil then
		v1235.user_owns_experience = t139.user_owns_experience
	end

	if t139.userOwnsExperience ~= nil then
		v1235.user_owns_experience = t139.userOwnsExperience
	end

	return v1235
end

t136.descriptor = {
	name = "ExperienceRefundPolicyInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceRefundPolicyInputData"
}
t1.ExperienceRefundPolicyInputData = t136
typeRegistry.default:register(t1.ExperienceRefundPolicyInputData)

local t140 = {}

t140.__index = t140

function t140.new(t141: {[any]: any}?) -- line: 9086
	-- upvalues: t140 (copy)
	return (setmetatable({
		universe_id = if t141 ~= nil and t141.universe_id ~= nil then t141.universe_id else "",
		place_id = if t141 ~= nil and t141.place_id ~= nil then t141.place_id else ""
	}, t140))
end
function t140.encode(p91) -- line: 9095
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n60 = 0

	if p91.universe_id ~= nil and p91.universe_id ~= "" then
		local v1240, v1241 = proto.writeTag(buf, n60, 1, proto.wireTypes.lengthDelimited)

		buf, n60 = proto.writeString(v1240, v1241, p91.universe_id)
	end

	if p91.place_id ~= nil and p91.place_id ~= "" then
		local v1242, v1243 = proto.writeTag(buf, n60, 2, proto.wireTypes.lengthDelimited)

		buf, n60 = proto.writeString(v1242, v1243, p91.place_id)
	end

	local buf34 = buffer.create(n60)

	buffer.copy(buf34, 0, buf, 0, n60)

	return buf34
end
function t140.decode(p92: buffer) -- line: 9114
	-- upvalues: t140 (copy), proto (copy)
	local v1246 = t140.new()
	local n61 = 0

	while n61 < buffer.len(p92) do
		local v1248, v1249

		v1248, v1249, n61 = proto.readTag(p92, n61)

		if v1249 == proto.wireTypes.varint then
			local v1250

			v1250, n61 = proto.readVarInt(p92, n61)
		elseif v1249 == proto.wireTypes.lengthDelimited then
			if v1248 == 1 then
				local v1251

				v1251, n61 = proto.readBuffer(p92, n61)
				v1246.universe_id = buffer.tostring(v1251)
			elseif v1248 == 2 then
				local v1252

				v1252, n61 = proto.readBuffer(p92, n61)
				v1246.place_id = buffer.tostring(v1252)
			else
				local v1253, v1254 = proto.readVarInt(p92, n61)

				n61 = v1254 + v1253
			end
		elseif v1249 == proto.wireTypes.i32 then
			local v1255

			v1255, n61 = proto.readFixed32(p92, n61)
		elseif v1249 == proto.wireTypes.i64 then
			local v1256

			v1256, n61 = proto.readFixed64(p92, n61)
		else
			error("Unsupported wire type: " .. v1249)
		end
	end

	return v1246
end
function t140.jsonEncode(p93) -- line: 9162
	local t142 = {}

	if p93.universe_id ~= nil and p93.universe_id ~= "" then
		t142.universeId = p93.universe_id
	end

	if p93.place_id ~= nil and p93.place_id ~= "" then
		t142.placeId = p93.place_id
	end

	return t142
end
function t140.jsonDecode(t143: {[any]: any}) -- line: 9176
	-- upvalues: t140 (copy)
	local v1260 = t140.new()

	if t143.universe_id ~= nil then
		v1260.universe_id = t143.universe_id
	end

	if t143.universeId ~= nil then
		v1260.universe_id = t143.universeId
	end

	if t143.place_id ~= nil then
		v1260.place_id = t143.place_id
	end

	if t143.placeId ~= nil then
		v1260.place_id = t143.placeId
	end

	return v1260
end

t140.descriptor = {
	name = "ExperiencePlayWithRewardInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperiencePlayWithRewardInputData"
}
t1.ExperiencePlayWithRewardInputData = t140
typeRegistry.default:register(t1.ExperiencePlayWithRewardInputData)

local t144 = {}

t144.__index = t144

function t144.new(t145: {[any]: any}?) -- line: 9214
	-- upvalues: t144 (copy)
	return (setmetatable({
		social_link_items = if t145 ~= nil and t145.social_link_items ~= nil then t145.social_link_items else {}
	}, t144))
end
function t144.encode(p94) -- line: 9220
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n62 = 0

	if p94.social_link_items ~= nil and #p94.social_link_items > 0 then
		for _, v1266 in p94.social_link_items do
			local v1267 = v1266:encode()
			local v1268, v1269 = proto.writeTag(buf, n62, 1, proto.wireTypes.lengthDelimited)

			buf, n62 = proto.writeBuffer(v1268, v1269, v1267, buffer.len(v1267))
		end
	end

	local buf35 = buffer.create(n62)

	buffer.copy(buf35, 0, buf, 0, n62)

	return buf35
end
function t144.decode(p95: buffer) -- line: 9237
	-- upvalues: t144 (copy), proto (copy), t1 (copy)
	local v1272 = t144.new()
	local n63 = 0

	while n63 < buffer.len(p95) do
		local v1274, v1275

		v1274, v1275, n63 = proto.readTag(p95, n63)

		if v1275 == proto.wireTypes.varint then
			local v1276

			v1276, n63 = proto.readVarInt(p95, n63)
		elseif v1275 == proto.wireTypes.lengthDelimited then
			if v1274 == 1 then
				local v1277

				v1277, n63 = proto.readBuffer(p95, n63)
				table.insert(v1272.social_link_items, t1.SocialLinkRowInputData_SocialLinkItem.decode(v1277))
			else
				local v1278, v1279 = proto.readVarInt(p95, n63)

				n63 = v1279 + v1278
			end
		elseif v1275 == proto.wireTypes.i32 then
			local v1280

			v1280, n63 = proto.readFixed32(p95, n63)
		elseif v1275 == proto.wireTypes.i64 then
			local v1281

			v1281, n63 = proto.readFixed64(p95, n63)
		else
			error("Unsupported wire type: " .. v1275)
		end
	end

	return v1272
end
function t144.jsonEncode(p96) -- line: 9280
	local t146 = {}

	if p96.social_link_items ~= nil and #p96.social_link_items > 0 then
		local t147 = {}

		for _, v1286 in p96.social_link_items do
			table.insert(t147, v1286:jsonEncode())
		end

		t146.socialLinkItems = t147
	end

	return t146
end
function t144.jsonDecode(t148: {[any]: any}) -- line: 9294
	-- upvalues: t144 (copy), t1 (copy)
	local v1288 = t144.new()

	if t148.social_link_items ~= nil then
		local t149 = {}

		for _, v1291 in t148.social_link_items do
			table.insert(t149, t1.SocialLinkRowInputData_SocialLinkItem.jsonDecode(v1291))
		end

		v1288.social_link_items = t149
	end

	if t148.socialLinkItems ~= nil then
		local t150 = {}

		for _, v1294 in t148.socialLinkItems do
			table.insert(t150, t1.SocialLinkRowInputData_SocialLinkItem.jsonDecode(v1294))
		end

		v1288.social_link_items = t150
	end

	return v1288
end

t144.descriptor = {
	name = "SocialLinkRowInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.SocialLinkRowInputData"
}
t1.SocialLinkRowInputData = t144
typeRegistry.default:register(t1.SocialLinkRowInputData)

local t151 = {}

t151.__index = t151

function t151.new(t152: {[any]: any}?) -- line: 9332
	-- upvalues: t151 (copy)
	return (setmetatable({
		social_link_id = if t152 ~= nil and t152.social_link_id ~= nil then t152.social_link_id else ""
	}, t151))
end
function t151.encode(p97) -- line: 9340
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n64 = 0

	if p97.social_link_id ~= nil and p97.social_link_id ~= "" then
		local v1299, v1300 = proto.writeTag(buf, n64, 1, proto.wireTypes.lengthDelimited)

		buf, n64 = proto.writeString(v1299, v1300, p97.social_link_id)
	end

	local buf36 = buffer.create(n64)

	buffer.copy(buf36, 0, buf, 0, n64)

	return buf36
end
function t151.decode(p98: buffer) -- line: 9354
	-- upvalues: t151 (copy), proto (copy)
	local v1303 = t151.new()
	local n65 = 0

	while n65 < buffer.len(p98) do
		local v1305, v1306

		v1305, v1306, n65 = proto.readTag(p98, n65)

		if v1306 == proto.wireTypes.varint then
			local v1307

			v1307, n65 = proto.readVarInt(p98, n65)
		elseif v1306 == proto.wireTypes.lengthDelimited then
			if v1305 == 1 then
				local v1308

				v1308, n65 = proto.readBuffer(p98, n65)
				v1303.social_link_id = buffer.tostring(v1308)
			else
				local v1309, v1310 = proto.readVarInt(p98, n65)

				n65 = v1310 + v1309
			end
		elseif v1306 == proto.wireTypes.i32 then
			local v1311

			v1311, n65 = proto.readFixed32(p98, n65)
		elseif v1306 == proto.wireTypes.i64 then
			local v1312

			v1312, n65 = proto.readFixed64(p98, n65)
		else
			error("Unsupported wire type: " .. v1306)
		end
	end

	return v1303
end
function t151.jsonEncode(p99) -- line: 9397
	local t153 = {}

	if p99.social_link_id ~= nil and p99.social_link_id ~= "" then
		t153.socialLinkId = p99.social_link_id
	end

	return t153
end
function t151.jsonDecode(t154: {[any]: any}) -- line: 9407
	-- upvalues: t151 (copy)
	local v1316 = t151.new()

	if t154.social_link_id ~= nil then
		v1316.social_link_id = t154.social_link_id
	end

	if t154.socialLinkId ~= nil then
		v1316.social_link_id = t154.socialLinkId
	end

	return v1316
end

t151.descriptor = {
	name = "SocialLinkRowInputData_SocialLinkItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.SocialLinkItem"
}
t1.SocialLinkRowInputData_SocialLinkItem = t151
typeRegistry.default:register(t1.SocialLinkRowInputData_SocialLinkItem)

local t155 = {}

t155.__index = t155

function t155.new(t156: {[any]: any}?) -- line: 9437
	-- upvalues: t155 (copy)
	return (setmetatable({
		title = if t156 ~= nil and t156.title ~= nil then t156.title else "",
		universe_items = if t156 ~= nil and t156.universe_items ~= nil then t156.universe_items else {},
		next_page_token = if t156 ~= nil and t156.next_page_token ~= nil then t156.next_page_token else "",
		sort_id = if t156 ~= nil and t156.sort_id ~= nil then t156.sort_id else "",
		secondary_sort_id = if t156 ~= nil and t156.secondary_sort_id ~= nil then t156.secondary_sort_id else 0,
		max_visible_rows = if t156 ~= nil and t156.max_visible_rows ~= nil then t156.max_visible_rows else 0,
		subtitle = if t156 ~= nil and t156.subtitle ~= nil then t156.subtitle else "",
		info_text = if t156 ~= nil and t156.info_text ~= nil then t156.info_text else "",
		subtitle_link_path = if t156 ~= nil and t156.subtitle_link_path ~= nil then t156.subtitle_link_path else "",
		is_placeholder = if t156 ~= nil and t156.is_placeholder ~= nil then t156.is_placeholder else nil,
		primary_sort_id = if t156 ~= nil and t156.primary_sort_id ~= nil then t156.primary_sort_id else nil,
		applied_filters = if t156 ~= nil and t156.applied_filters ~= nil then t156.applied_filters else nil,
		pool_id = if t156 ~= nil and t156.pool_id ~= nil then t156.pool_id else nil
	}, t155))
end
function t155.encode(p100) -- line: 9457
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n66 = 0

	if p100.title ~= nil and p100.title ~= "" then
		local v1321, v1322 = proto.writeTag(buf, n66, 1, proto.wireTypes.lengthDelimited)

		buf, n66 = proto.writeString(v1321, v1322, p100.title)
	end

	if p100.universe_items ~= nil and #p100.universe_items > 0 then
		for _, v1324 in p100.universe_items do
			local v1325 = v1324:encode()
			local v1326, v1327 = proto.writeTag(buf, n66, 2, proto.wireTypes.lengthDelimited)

			buf, n66 = proto.writeBuffer(v1326, v1327, v1325, buffer.len(v1325))
		end
	end

	if p100.next_page_token ~= nil and p100.next_page_token ~= "" then
		local v1328, v1329 = proto.writeTag(buf, n66, 3, proto.wireTypes.lengthDelimited)

		buf, n66 = proto.writeString(v1328, v1329, p100.next_page_token)
	end

	if p100.sort_id ~= nil and p100.sort_id ~= "" then
		local v1330, v1331 = proto.writeTag(buf, n66, 4, proto.wireTypes.lengthDelimited)

		buf, n66 = proto.writeString(v1330, v1331, p100.sort_id)
	end

	if p100.secondary_sort_id ~= nil and p100.secondary_sort_id ~= 0 then
		local v1332, v1333 = proto.writeTag(buf, n66, 5, proto.wireTypes.varint)

		buf, n66 = proto.writeVarInt(v1332, v1333, p100.secondary_sort_id)
	end

	if p100.max_visible_rows ~= nil and p100.max_visible_rows ~= 0 then
		local v1334, v1335 = proto.writeTag(buf, n66, 6, proto.wireTypes.varint)

		buf, n66 = proto.writeVarInt(v1334, v1335, p100.max_visible_rows)
	end

	if p100.subtitle ~= nil and p100.subtitle ~= "" then
		local v1336, v1337 = proto.writeTag(buf, n66, 7, proto.wireTypes.lengthDelimited)

		buf, n66 = proto.writeString(v1336, v1337, p100.subtitle)
	end

	if p100.info_text ~= nil and p100.info_text ~= "" then
		local v1338, v1339 = proto.writeTag(buf, n66, 8, proto.wireTypes.lengthDelimited)

		buf, n66 = proto.writeString(v1338, v1339, p100.info_text)
	end

	if p100.subtitle_link_path ~= nil and p100.subtitle_link_path ~= "" then
		local v1340, v1341 = proto.writeTag(buf, n66, 9, proto.wireTypes.lengthDelimited)

		buf, n66 = proto.writeString(v1340, v1341, p100.subtitle_link_path)
	end

	if p100.is_placeholder ~= nil then
		local v1342, v1343 = proto.writeTag(buf, n66, 10, proto.wireTypes.varint)

		buf, n66 = proto.writeVarInt(v1342, v1343, not p100.is_placeholder and 0 or 1)
	end

	if p100.primary_sort_id ~= nil then
		local v1344, v1345 = proto.writeTag(buf, n66, 11, proto.wireTypes.varint)

		buf, n66 = proto.writeVarInt(v1344, v1345, p100.primary_sort_id)
	end

	if p100.applied_filters ~= nil then
		local v1346, v1347 = proto.writeTag(buf, n66, 12, proto.wireTypes.lengthDelimited)

		buf, n66 = proto.writeString(v1346, v1347, p100.applied_filters)
	end

	if p100.pool_id ~= nil then
		local v1348, v1349 = proto.writeTag(buf, n66, 13, proto.wireTypes.lengthDelimited)

		buf, n66 = proto.writeString(v1348, v1349, p100.pool_id)
	end

	local buf37 = buffer.create(n66)

	buffer.copy(buf37, 0, buf, 0, n66)

	return buf37
end
function t155.decode(p101: buffer) -- line: 9534
	-- upvalues: t155 (copy), proto (copy), t1 (copy)
	local v1352 = t155.new()
	local n67 = 0

	while n67 < buffer.len(p101) do
		local v1354, v1355

		v1354, v1355, n67 = proto.readTag(p101, n67)

		if v1355 == proto.wireTypes.varint then
			if v1354 == 5 then
				local v1356

				v1356, n67 = proto.readVarIntI32(p101, n67)
				v1352.secondary_sort_id = v1356
			elseif v1354 == 6 then
				local v1357

				v1357, n67 = proto.readVarIntI32(p101, n67)
				v1352.max_visible_rows = v1357
			elseif v1354 == 10 then
				local v1358

				v1358, n67 = proto.readVarInt(p101, n67)
				v1352.is_placeholder = v1358 ~= 0
			elseif v1354 == 11 then
				local v1359

				v1359, n67 = proto.readVarIntI32(p101, n67)
				v1352.primary_sort_id = v1359
			else
				local v1360

				v1360, n67 = proto.readVarInt(p101, n67)
			end
		elseif v1355 == proto.wireTypes.lengthDelimited then
			if v1354 == 1 then
				local v1361

				v1361, n67 = proto.readBuffer(p101, n67)
				v1352.title = buffer.tostring(v1361)
			elseif v1354 == 2 then
				local v1362

				v1362, n67 = proto.readBuffer(p101, n67)
				table.insert(v1352.universe_items, t1.ExperienceCarouselInputData_UniverseItem.decode(v1362))
			elseif v1354 == 3 then
				local v1363

				v1363, n67 = proto.readBuffer(p101, n67)
				v1352.next_page_token = buffer.tostring(v1363)
			elseif v1354 == 4 then
				local v1364

				v1364, n67 = proto.readBuffer(p101, n67)
				v1352.sort_id = buffer.tostring(v1364)
			elseif v1354 == 7 then
				local v1365

				v1365, n67 = proto.readBuffer(p101, n67)
				v1352.subtitle = buffer.tostring(v1365)
			elseif v1354 == 8 then
				local v1366

				v1366, n67 = proto.readBuffer(p101, n67)
				v1352.info_text = buffer.tostring(v1366)
			elseif v1354 == 9 then
				local v1367

				v1367, n67 = proto.readBuffer(p101, n67)
				v1352.subtitle_link_path = buffer.tostring(v1367)
			elseif v1354 == 12 then
				local v1368

				v1368, n67 = proto.readBuffer(p101, n67)
				v1352.applied_filters = buffer.tostring(v1368)
			elseif v1354 == 13 then
				local v1369

				v1369, n67 = proto.readBuffer(p101, n67)
				v1352.pool_id = buffer.tostring(v1369)
			else
				local v1370, v1371 = proto.readVarInt(p101, n67)

				n67 = v1371 + v1370
			end
		elseif v1355 == proto.wireTypes.i32 then
			local v1372

			v1372, n67 = proto.readFixed32(p101, n67)
		elseif v1355 == proto.wireTypes.i64 then
			local v1373

			v1373, n67 = proto.readFixed64(p101, n67)
		else
			error("Unsupported wire type: " .. v1355)
		end
	end

	return v1352
end
function t155.jsonEncode(p102) -- line: 9637
	local t157 = {}

	if p102.title ~= nil and p102.title ~= "" then
		t157.title = p102.title
	end

	if p102.universe_items ~= nil and #p102.universe_items > 0 then
		local t158 = {}

		for _, v1378 in p102.universe_items do
			table.insert(t158, v1378:jsonEncode())
		end

		t157.universeItems = t158
	end

	if p102.next_page_token ~= nil and p102.next_page_token ~= "" then
		t157.nextPageToken = p102.next_page_token
	end

	if p102.sort_id ~= nil and p102.sort_id ~= "" then
		t157.sortId = p102.sort_id
	end

	if p102.secondary_sort_id ~= nil and p102.secondary_sort_id ~= 0 then
		t157.secondarySortId = p102.secondary_sort_id
	end

	if p102.max_visible_rows ~= nil and p102.max_visible_rows ~= 0 then
		t157.maxVisibleRows = p102.max_visible_rows
	end

	if p102.subtitle ~= nil and p102.subtitle ~= "" then
		t157.subtitle = p102.subtitle
	end

	if p102.info_text ~= nil and p102.info_text ~= "" then
		t157.infoText = p102.info_text
	end

	if p102.subtitle_link_path ~= nil and p102.subtitle_link_path ~= "" then
		t157.subtitleLinkPath = p102.subtitle_link_path
	end

	if p102.is_placeholder ~= nil then
		t157.isPlaceholder = p102.is_placeholder
	end

	if p102.primary_sort_id ~= nil then
		t157.primarySortId = p102.primary_sort_id
	end

	if p102.applied_filters ~= nil then
		t157.appliedFilters = p102.applied_filters
	end

	if p102.pool_id ~= nil then
		t157.poolId = p102.pool_id
	end

	return t157
end
function t155.jsonDecode(t159: {[any]: any}) -- line: 9699
	-- upvalues: t155 (copy), t1 (copy)
	local v1380 = t155.new()

	if t159.title ~= nil then
		v1380.title = t159.title
	end

	if t159.universe_items ~= nil then
		local t160 = {}

		for _, v1383 in t159.universe_items do
			table.insert(t160, t1.ExperienceCarouselInputData_UniverseItem.jsonDecode(v1383))
		end

		v1380.universe_items = t160
	end

	if t159.universeItems ~= nil then
		local t161 = {}

		for _, v1386 in t159.universeItems do
			table.insert(t161, t1.ExperienceCarouselInputData_UniverseItem.jsonDecode(v1386))
		end

		v1380.universe_items = t161
	end

	if t159.next_page_token ~= nil then
		v1380.next_page_token = t159.next_page_token
	end

	if t159.nextPageToken ~= nil then
		v1380.next_page_token = t159.nextPageToken
	end

	if t159.sort_id ~= nil then
		v1380.sort_id = t159.sort_id
	end

	if t159.sortId ~= nil then
		v1380.sort_id = t159.sortId
	end

	if t159.secondary_sort_id ~= nil then
		v1380.secondary_sort_id = t159.secondary_sort_id
	end

	if t159.secondarySortId ~= nil then
		v1380.secondary_sort_id = t159.secondarySortId
	end

	if t159.max_visible_rows ~= nil then
		v1380.max_visible_rows = t159.max_visible_rows
	end

	if t159.maxVisibleRows ~= nil then
		v1380.max_visible_rows = t159.maxVisibleRows
	end

	if t159.subtitle ~= nil then
		v1380.subtitle = t159.subtitle
	end

	if t159.info_text ~= nil then
		v1380.info_text = t159.info_text
	end

	if t159.infoText ~= nil then
		v1380.info_text = t159.infoText
	end

	if t159.subtitle_link_path ~= nil then
		v1380.subtitle_link_path = t159.subtitle_link_path
	end

	if t159.subtitleLinkPath ~= nil then
		v1380.subtitle_link_path = t159.subtitleLinkPath
	end

	if t159.is_placeholder ~= nil then
		v1380.is_placeholder = t159.is_placeholder
	end

	if t159.isPlaceholder ~= nil then
		v1380.is_placeholder = t159.isPlaceholder
	end

	if t159.primary_sort_id ~= nil then
		v1380.primary_sort_id = t159.primary_sort_id
	end

	if t159.primarySortId ~= nil then
		v1380.primary_sort_id = t159.primarySortId
	end

	if t159.applied_filters ~= nil then
		v1380.applied_filters = t159.applied_filters
	end

	if t159.appliedFilters ~= nil then
		v1380.applied_filters = t159.appliedFilters
	end

	if t159.pool_id ~= nil then
		v1380.pool_id = t159.pool_id
	end

	if t159.poolId ~= nil then
		v1380.pool_id = t159.poolId
	end

	return v1380
end

t155.descriptor = {
	name = "ExperienceCarouselInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceCarouselInputData"
}
t1.ExperienceCarouselInputData = t155
typeRegistry.default:register(t1.ExperienceCarouselInputData)

local t162 = {}

t162.__index = t162

function t162.new(t163: {[any]: any}?) -- line: 9825
	-- upvalues: t162 (copy)
	return (setmetatable({
		universe_id = if t163 ~= nil and t163.universe_id ~= nil then t163.universe_id else "",
		is_sponsored = t163 ~= nil and (t163.is_sponsored ~= nil and t163.is_sponsored),
		roblox_component = if t163 ~= nil and t163.roblox_component ~= nil then t163.roblox_component else "",
		native_ad_data = if t163 ~= nil and t163.native_ad_data ~= nil then t163.native_ad_data else "",
		is_content_locked = t163 ~= nil and (t163.is_content_locked ~= nil and t163.is_content_locked),
		title = if t163 ~= nil and t163.title ~= nil then t163.title else "",
		subtitle = if t163 ~= nil and t163.subtitle ~= nil then t163.subtitle else "",
		image_asset_id = if t163 ~= nil and t163.image_asset_id ~= nil then t163.image_asset_id else "",
		video_asset_id = if t163 ~= nil and t163.video_asset_id ~= nil then t163.video_asset_id else "",
		badge_text = if t163 ~= nil and t163.badge_text ~= nil then t163.badge_text else "",
		player_count = if t163 ~= nil and t163.player_count ~= nil then t163.player_count else nil,
		creator_key = if t163 ~= nil and t163.creator_key ~= nil then t163.creator_key else ""
	}, t162))
end
function t162.encode(p103) -- line: 9844
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n68 = 0

	if p103.universe_id ~= nil and p103.universe_id ~= "" then
		local v1391, v1392 = proto.writeTag(buf, n68, 1, proto.wireTypes.lengthDelimited)

		buf, n68 = proto.writeString(v1391, v1392, p103.universe_id)
	end

	if p103.is_sponsored then
		local v1393, v1394 = proto.writeTag(buf, n68, 2, proto.wireTypes.varint)

		buf, n68 = proto.writeVarInt(v1393, v1394, not p103.is_sponsored and 0 or 1)
	end

	if p103.roblox_component ~= nil and p103.roblox_component ~= "" then
		local v1395, v1396 = proto.writeTag(buf, n68, 3, proto.wireTypes.lengthDelimited)

		buf, n68 = proto.writeString(v1395, v1396, p103.roblox_component)
	end

	if p103.native_ad_data ~= nil and p103.native_ad_data ~= "" then
		local v1397, v1398 = proto.writeTag(buf, n68, 4, proto.wireTypes.lengthDelimited)

		buf, n68 = proto.writeString(v1397, v1398, p103.native_ad_data)
	end

	if p103.is_content_locked then
		local v1399, v1400 = proto.writeTag(buf, n68, 5, proto.wireTypes.varint)

		buf, n68 = proto.writeVarInt(v1399, v1400, not p103.is_content_locked and 0 or 1)
	end

	if p103.title ~= nil and p103.title ~= "" then
		local v1401, v1402 = proto.writeTag(buf, n68, 6, proto.wireTypes.lengthDelimited)

		buf, n68 = proto.writeString(v1401, v1402, p103.title)
	end

	if p103.subtitle ~= nil and p103.subtitle ~= "" then
		local v1403, v1404 = proto.writeTag(buf, n68, 7, proto.wireTypes.lengthDelimited)

		buf, n68 = proto.writeString(v1403, v1404, p103.subtitle)
	end

	if p103.image_asset_id ~= nil and p103.image_asset_id ~= "" then
		local v1405, v1406 = proto.writeTag(buf, n68, 8, proto.wireTypes.lengthDelimited)

		buf, n68 = proto.writeString(v1405, v1406, p103.image_asset_id)
	end

	if p103.video_asset_id ~= nil and p103.video_asset_id ~= "" then
		local v1407, v1408 = proto.writeTag(buf, n68, 9, proto.wireTypes.lengthDelimited)

		buf, n68 = proto.writeString(v1407, v1408, p103.video_asset_id)
	end

	if p103.badge_text ~= nil and p103.badge_text ~= "" then
		local v1409, v1410 = proto.writeTag(buf, n68, 10, proto.wireTypes.lengthDelimited)

		buf, n68 = proto.writeString(v1409, v1410, p103.badge_text)
	end

	if p103.player_count ~= nil then
		local v1411, v1412 = proto.writeTag(buf, n68, 11, proto.wireTypes.varint)

		buf, n68 = proto.writeVarInt(v1411, v1412, p103.player_count)
	end

	if p103.creator_key ~= nil and p103.creator_key ~= "" then
		local v1413, v1414 = proto.writeTag(buf, n68, 12, proto.wireTypes.lengthDelimited)

		buf, n68 = proto.writeString(v1413, v1414, p103.creator_key)
	end

	local buf38 = buffer.create(n68)

	buffer.copy(buf38, 0, buf, 0, n68)

	return buf38
end
function t162.decode(p104: buffer) -- line: 9915
	-- upvalues: t162 (copy), proto (copy)
	local v1417 = t162.new()
	local n69 = 0

	while n69 < buffer.len(p104) do
		local v1419, v1420

		v1419, v1420, n69 = proto.readTag(p104, n69)

		if v1420 == proto.wireTypes.varint then
			if v1419 == 2 then
				local v1421

				v1421, n69 = proto.readVarInt(p104, n69)
				v1417.is_sponsored = v1421 ~= 0
			elseif v1419 == 5 then
				local v1422

				v1422, n69 = proto.readVarInt(p104, n69)
				v1417.is_content_locked = v1422 ~= 0
			elseif v1419 == 11 then
				local v1423

				v1423, n69 = proto.readVarIntI64(p104, n69)
				v1417.player_count = v1423
			else
				local v1424

				v1424, n69 = proto.readVarInt(p104, n69)
			end
		elseif v1420 == proto.wireTypes.lengthDelimited then
			if v1419 == 1 then
				local v1425

				v1425, n69 = proto.readBuffer(p104, n69)
				v1417.universe_id = buffer.tostring(v1425)
			elseif v1419 == 3 then
				local v1426

				v1426, n69 = proto.readBuffer(p104, n69)
				v1417.roblox_component = buffer.tostring(v1426)
			elseif v1419 == 4 then
				local v1427

				v1427, n69 = proto.readBuffer(p104, n69)
				v1417.native_ad_data = buffer.tostring(v1427)
			elseif v1419 == 6 then
				local v1428

				v1428, n69 = proto.readBuffer(p104, n69)
				v1417.title = buffer.tostring(v1428)
			elseif v1419 == 7 then
				local v1429

				v1429, n69 = proto.readBuffer(p104, n69)
				v1417.subtitle = buffer.tostring(v1429)
			elseif v1419 == 8 then
				local v1430

				v1430, n69 = proto.readBuffer(p104, n69)
				v1417.image_asset_id = buffer.tostring(v1430)
			elseif v1419 == 9 then
				local v1431

				v1431, n69 = proto.readBuffer(p104, n69)
				v1417.video_asset_id = buffer.tostring(v1431)
			elseif v1419 == 10 then
				local v1432

				v1432, n69 = proto.readBuffer(p104, n69)
				v1417.badge_text = buffer.tostring(v1432)
			elseif v1419 == 12 then
				local v1433

				v1433, n69 = proto.readBuffer(p104, n69)
				v1417.creator_key = buffer.tostring(v1433)
			else
				local v1434, v1435 = proto.readVarInt(p104, n69)

				n69 = v1435 + v1434
			end
		elseif v1420 == proto.wireTypes.i32 then
			local v1436

			v1436, n69 = proto.readFixed32(p104, n69)
		elseif v1420 == proto.wireTypes.i64 then
			local v1437

			v1437, n69 = proto.readFixed64(p104, n69)
		else
			error("Unsupported wire type: " .. v1420)
		end
	end

	return v1417
end
function t162.jsonEncode(p105) -- line: 10015
	local t164 = {}

	if p105.universe_id ~= nil and p105.universe_id ~= "" then
		t164.universeId = p105.universe_id
	end

	if p105.is_sponsored then
		t164.isSponsored = p105.is_sponsored
	end

	if p105.roblox_component ~= nil and p105.roblox_component ~= "" then
		t164.robloxComponent = p105.roblox_component
	end

	if p105.native_ad_data ~= nil and p105.native_ad_data ~= "" then
		t164.nativeAdData = p105.native_ad_data
	end

	if p105.is_content_locked then
		t164.isContentLocked = p105.is_content_locked
	end

	if p105.title ~= nil and p105.title ~= "" then
		t164.title = p105.title
	end

	if p105.subtitle ~= nil and p105.subtitle ~= "" then
		t164.subtitle = p105.subtitle
	end

	if p105.image_asset_id ~= nil and p105.image_asset_id ~= "" then
		t164.imageAssetId = p105.image_asset_id
	end

	if p105.video_asset_id ~= nil and p105.video_asset_id ~= "" then
		t164.videoAssetId = p105.video_asset_id
	end

	if p105.badge_text ~= nil and p105.badge_text ~= "" then
		t164.badgeText = p105.badge_text
	end

	if p105.player_count ~= nil then
		t164.playerCount = p105.player_count
	end

	if p105.creator_key ~= nil and p105.creator_key ~= "" then
		t164.creatorKey = p105.creator_key
	end

	return t164
end
function t162.jsonDecode(t165: {[any]: any}) -- line: 10071
	-- upvalues: t162 (copy)
	local v1441 = t162.new()

	if t165.universe_id ~= nil then
		v1441.universe_id = t165.universe_id
	end

	if t165.universeId ~= nil then
		v1441.universe_id = t165.universeId
	end

	if t165.is_sponsored ~= nil then
		v1441.is_sponsored = t165.is_sponsored
	end

	if t165.isSponsored ~= nil then
		v1441.is_sponsored = t165.isSponsored
	end

	if t165.roblox_component ~= nil then
		v1441.roblox_component = t165.roblox_component
	end

	if t165.robloxComponent ~= nil then
		v1441.roblox_component = t165.robloxComponent
	end

	if t165.native_ad_data ~= nil then
		v1441.native_ad_data = t165.native_ad_data
	end

	if t165.nativeAdData ~= nil then
		v1441.native_ad_data = t165.nativeAdData
	end

	if t165.is_content_locked ~= nil then
		v1441.is_content_locked = t165.is_content_locked
	end

	if t165.isContentLocked ~= nil then
		v1441.is_content_locked = t165.isContentLocked
	end

	if t165.title ~= nil then
		v1441.title = t165.title
	end

	if t165.subtitle ~= nil then
		v1441.subtitle = t165.subtitle
	end

	if t165.image_asset_id ~= nil then
		v1441.image_asset_id = t165.image_asset_id
	end

	if t165.imageAssetId ~= nil then
		v1441.image_asset_id = t165.imageAssetId
	end

	if t165.video_asset_id ~= nil then
		v1441.video_asset_id = t165.video_asset_id
	end

	if t165.videoAssetId ~= nil then
		v1441.video_asset_id = t165.videoAssetId
	end

	if t165.badge_text ~= nil then
		v1441.badge_text = t165.badge_text
	end

	if t165.badgeText ~= nil then
		v1441.badge_text = t165.badgeText
	end

	if t165.player_count ~= nil then
		v1441.player_count = t165.player_count
	end

	if t165.playerCount ~= nil then
		v1441.player_count = t165.playerCount
	end

	if t165.creator_key ~= nil then
		v1441.creator_key = t165.creator_key
	end

	if t165.creatorKey ~= nil then
		v1441.creator_key = t165.creatorKey
	end

	return v1441
end

t162.descriptor = {
	name = "ExperienceCarouselInputData_UniverseItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniverseItem"
}
t1.ExperienceCarouselInputData_UniverseItem = t162
typeRegistry.default:register(t1.ExperienceCarouselInputData_UniverseItem)

local t166 = {}

t166.__index = t166

function t166.new(t167: {[any]: any}?) -- line: 10181
	-- upvalues: t166 (copy)
	return (setmetatable({
		title = if t167 ~= nil and t167.title ~= nil then t167.title else "",
		song_items = if t167 ~= nil and t167.song_items ~= nil then t167.song_items else {},
		next_page_token = if t167 ~= nil and t167.next_page_token ~= nil then t167.next_page_token else "",
		sort_id = if t167 ~= nil and t167.sort_id ~= nil then t167.sort_id else "",
		secondary_sort_id = if t167 ~= nil and t167.secondary_sort_id ~= nil then t167.secondary_sort_id else 0,
		subtitle = if t167 ~= nil and t167.subtitle ~= nil then t167.subtitle else "",
		info_text = if t167 ~= nil and t167.info_text ~= nil then t167.info_text else "",
		subtitle_link_path = if t167 ~= nil and t167.subtitle_link_path ~= nil then t167.subtitle_link_path else "",
		is_placeholder = if t167 ~= nil and t167.is_placeholder ~= nil then t167.is_placeholder else nil,
		primary_sort_id = if t167 ~= nil and t167.primary_sort_id ~= nil then t167.primary_sort_id else nil,
		applied_filters = if t167 ~= nil and t167.applied_filters ~= nil then t167.applied_filters else nil
	}, t166))
end
function t166.encode(p106) -- line: 10197
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n70 = 0

	if p106.title ~= nil and p106.title ~= "" then
		local v1446, v1447 = proto.writeTag(buf, n70, 1, proto.wireTypes.lengthDelimited)

		buf, n70 = proto.writeString(v1446, v1447, p106.title)
	end

	if p106.song_items ~= nil and #p106.song_items > 0 then
		for _, v1449 in p106.song_items do
			local v1450 = v1449:encode()
			local v1451, v1452 = proto.writeTag(buf, n70, 2, proto.wireTypes.lengthDelimited)

			buf, n70 = proto.writeBuffer(v1451, v1452, v1450, buffer.len(v1450))
		end
	end

	if p106.next_page_token ~= nil and p106.next_page_token ~= "" then
		local v1453, v1454 = proto.writeTag(buf, n70, 3, proto.wireTypes.lengthDelimited)

		buf, n70 = proto.writeString(v1453, v1454, p106.next_page_token)
	end

	if p106.sort_id ~= nil and p106.sort_id ~= "" then
		local v1455, v1456 = proto.writeTag(buf, n70, 4, proto.wireTypes.lengthDelimited)

		buf, n70 = proto.writeString(v1455, v1456, p106.sort_id)
	end

	if p106.secondary_sort_id ~= nil and p106.secondary_sort_id ~= 0 then
		local v1457, v1458 = proto.writeTag(buf, n70, 5, proto.wireTypes.varint)

		buf, n70 = proto.writeVarInt(v1457, v1458, p106.secondary_sort_id)
	end

	if p106.subtitle ~= nil and p106.subtitle ~= "" then
		local v1459, v1460 = proto.writeTag(buf, n70, 6, proto.wireTypes.lengthDelimited)

		buf, n70 = proto.writeString(v1459, v1460, p106.subtitle)
	end

	if p106.info_text ~= nil and p106.info_text ~= "" then
		local v1461, v1462 = proto.writeTag(buf, n70, 7, proto.wireTypes.lengthDelimited)

		buf, n70 = proto.writeString(v1461, v1462, p106.info_text)
	end

	if p106.subtitle_link_path ~= nil and p106.subtitle_link_path ~= "" then
		local v1463, v1464 = proto.writeTag(buf, n70, 8, proto.wireTypes.lengthDelimited)

		buf, n70 = proto.writeString(v1463, v1464, p106.subtitle_link_path)
	end

	if p106.is_placeholder ~= nil then
		local v1465, v1466 = proto.writeTag(buf, n70, 9, proto.wireTypes.varint)

		buf, n70 = proto.writeVarInt(v1465, v1466, not p106.is_placeholder and 0 or 1)
	end

	if p106.primary_sort_id ~= nil then
		local v1467, v1468 = proto.writeTag(buf, n70, 10, proto.wireTypes.varint)

		buf, n70 = proto.writeVarInt(v1467, v1468, p106.primary_sort_id)
	end

	if p106.applied_filters ~= nil then
		local v1469, v1470 = proto.writeTag(buf, n70, 11, proto.wireTypes.lengthDelimited)

		buf, n70 = proto.writeString(v1469, v1470, p106.applied_filters)
	end

	local buf39 = buffer.create(n70)

	buffer.copy(buf39, 0, buf, 0, n70)

	return buf39
end
function t166.decode(p107: buffer) -- line: 10264
	-- upvalues: t166 (copy), proto (copy), t1 (copy)
	local v1473 = t166.new()
	local n71 = 0

	while n71 < buffer.len(p107) do
		local v1475, v1476

		v1475, v1476, n71 = proto.readTag(p107, n71)

		if v1476 == proto.wireTypes.varint then
			if v1475 == 5 then
				local v1477

				v1477, n71 = proto.readVarIntI32(p107, n71)
				v1473.secondary_sort_id = v1477
			elseif v1475 == 9 then
				local v1478

				v1478, n71 = proto.readVarInt(p107, n71)
				v1473.is_placeholder = v1478 ~= 0
			elseif v1475 == 10 then
				local v1479

				v1479, n71 = proto.readVarIntI32(p107, n71)
				v1473.primary_sort_id = v1479
			else
				local v1480

				v1480, n71 = proto.readVarInt(p107, n71)
			end
		elseif v1476 == proto.wireTypes.lengthDelimited then
			if v1475 == 1 then
				local v1481

				v1481, n71 = proto.readBuffer(p107, n71)
				v1473.title = buffer.tostring(v1481)
			elseif v1475 == 2 then
				local v1482

				v1482, n71 = proto.readBuffer(p107, n71)
				table.insert(v1473.song_items, t1.SongCarouselInputData_SongItem.decode(v1482))
			elseif v1475 == 3 then
				local v1483

				v1483, n71 = proto.readBuffer(p107, n71)
				v1473.next_page_token = buffer.tostring(v1483)
			elseif v1475 == 4 then
				local v1484

				v1484, n71 = proto.readBuffer(p107, n71)
				v1473.sort_id = buffer.tostring(v1484)
			elseif v1475 == 6 then
				local v1485

				v1485, n71 = proto.readBuffer(p107, n71)
				v1473.subtitle = buffer.tostring(v1485)
			elseif v1475 == 7 then
				local v1486

				v1486, n71 = proto.readBuffer(p107, n71)
				v1473.info_text = buffer.tostring(v1486)
			elseif v1475 == 8 then
				local v1487

				v1487, n71 = proto.readBuffer(p107, n71)
				v1473.subtitle_link_path = buffer.tostring(v1487)
			elseif v1475 == 11 then
				local v1488

				v1488, n71 = proto.readBuffer(p107, n71)
				v1473.applied_filters = buffer.tostring(v1488)
			else
				local v1489, v1490 = proto.readVarInt(p107, n71)

				n71 = v1490 + v1489
			end
		elseif v1476 == proto.wireTypes.i32 then
			local v1491

			v1491, n71 = proto.readFixed32(p107, n71)
		elseif v1476 == proto.wireTypes.i64 then
			local v1492

			v1492, n71 = proto.readFixed64(p107, n71)
		else
			error("Unsupported wire type: " .. v1476)
		end
	end

	return v1473
end
function t166.jsonEncode(p108) -- line: 10357
	local t168 = {}

	if p108.title ~= nil and p108.title ~= "" then
		t168.title = p108.title
	end

	if p108.song_items ~= nil and #p108.song_items > 0 then
		local t169 = {}

		for _, v1497 in p108.song_items do
			table.insert(t169, v1497:jsonEncode())
		end

		t168.songItems = t169
	end

	if p108.next_page_token ~= nil and p108.next_page_token ~= "" then
		t168.nextPageToken = p108.next_page_token
	end

	if p108.sort_id ~= nil and p108.sort_id ~= "" then
		t168.sortId = p108.sort_id
	end

	if p108.secondary_sort_id ~= nil and p108.secondary_sort_id ~= 0 then
		t168.secondarySortId = p108.secondary_sort_id
	end

	if p108.subtitle ~= nil and p108.subtitle ~= "" then
		t168.subtitle = p108.subtitle
	end

	if p108.info_text ~= nil and p108.info_text ~= "" then
		t168.infoText = p108.info_text
	end

	if p108.subtitle_link_path ~= nil and p108.subtitle_link_path ~= "" then
		t168.subtitleLinkPath = p108.subtitle_link_path
	end

	if p108.is_placeholder ~= nil then
		t168.isPlaceholder = p108.is_placeholder
	end

	if p108.primary_sort_id ~= nil then
		t168.primarySortId = p108.primary_sort_id
	end

	if p108.applied_filters ~= nil then
		t168.appliedFilters = p108.applied_filters
	end

	return t168
end
function t166.jsonDecode(t170: {[any]: any}) -- line: 10411
	-- upvalues: t166 (copy), t1 (copy)
	local v1499 = t166.new()

	if t170.title ~= nil then
		v1499.title = t170.title
	end

	if t170.song_items ~= nil then
		local t171 = {}

		for _, v1502 in t170.song_items do
			table.insert(t171, t1.SongCarouselInputData_SongItem.jsonDecode(v1502))
		end

		v1499.song_items = t171
	end

	if t170.songItems ~= nil then
		local t172 = {}

		for _, v1505 in t170.songItems do
			table.insert(t172, t1.SongCarouselInputData_SongItem.jsonDecode(v1505))
		end

		v1499.song_items = t172
	end

	if t170.next_page_token ~= nil then
		v1499.next_page_token = t170.next_page_token
	end

	if t170.nextPageToken ~= nil then
		v1499.next_page_token = t170.nextPageToken
	end

	if t170.sort_id ~= nil then
		v1499.sort_id = t170.sort_id
	end

	if t170.sortId ~= nil then
		v1499.sort_id = t170.sortId
	end

	if t170.secondary_sort_id ~= nil then
		v1499.secondary_sort_id = t170.secondary_sort_id
	end

	if t170.secondarySortId ~= nil then
		v1499.secondary_sort_id = t170.secondarySortId
	end

	if t170.subtitle ~= nil then
		v1499.subtitle = t170.subtitle
	end

	if t170.info_text ~= nil then
		v1499.info_text = t170.info_text
	end

	if t170.infoText ~= nil then
		v1499.info_text = t170.infoText
	end

	if t170.subtitle_link_path ~= nil then
		v1499.subtitle_link_path = t170.subtitle_link_path
	end

	if t170.subtitleLinkPath ~= nil then
		v1499.subtitle_link_path = t170.subtitleLinkPath
	end

	if t170.is_placeholder ~= nil then
		v1499.is_placeholder = t170.is_placeholder
	end

	if t170.isPlaceholder ~= nil then
		v1499.is_placeholder = t170.isPlaceholder
	end

	if t170.primary_sort_id ~= nil then
		v1499.primary_sort_id = t170.primary_sort_id
	end

	if t170.primarySortId ~= nil then
		v1499.primary_sort_id = t170.primarySortId
	end

	if t170.applied_filters ~= nil then
		v1499.applied_filters = t170.applied_filters
	end

	if t170.appliedFilters ~= nil then
		v1499.applied_filters = t170.appliedFilters
	end

	return v1499
end

t166.descriptor = {
	name = "SongCarouselInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.SongCarouselInputData"
}
t1.SongCarouselInputData = t166
typeRegistry.default:register(t1.SongCarouselInputData)

local t173 = {}

t173.__index = t173

function t173.new(t174: {[any]: any}?) -- line: 10521
	-- upvalues: t173 (copy)
	return (setmetatable({
		song_id = if t174 ~= nil and t174.song_id ~= nil then t174.song_id else ""
	}, t173))
end
function t173.encode(p109) -- line: 10529
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n72 = 0

	if p109.song_id ~= nil and p109.song_id ~= "" then
		local v1510, v1511 = proto.writeTag(buf, n72, 1, proto.wireTypes.lengthDelimited)

		buf, n72 = proto.writeString(v1510, v1511, p109.song_id)
	end

	local buf40 = buffer.create(n72)

	buffer.copy(buf40, 0, buf, 0, n72)

	return buf40
end
function t173.decode(p110: buffer) -- line: 10543
	-- upvalues: t173 (copy), proto (copy)
	local v1514 = t173.new()
	local n73 = 0

	while n73 < buffer.len(p110) do
		local v1516, v1517

		v1516, v1517, n73 = proto.readTag(p110, n73)

		if v1517 == proto.wireTypes.varint then
			local v1518

			v1518, n73 = proto.readVarInt(p110, n73)
		elseif v1517 == proto.wireTypes.lengthDelimited then
			if v1516 == 1 then
				local v1519

				v1519, n73 = proto.readBuffer(p110, n73)
				v1514.song_id = buffer.tostring(v1519)
			else
				local v1520, v1521 = proto.readVarInt(p110, n73)

				n73 = v1521 + v1520
			end
		elseif v1517 == proto.wireTypes.i32 then
			local v1522

			v1522, n73 = proto.readFixed32(p110, n73)
		elseif v1517 == proto.wireTypes.i64 then
			local v1523

			v1523, n73 = proto.readFixed64(p110, n73)
		else
			error("Unsupported wire type: " .. v1517)
		end
	end

	return v1514
end
function t173.jsonEncode(p111) -- line: 10586
	local t175 = {}

	if p111.song_id ~= nil and p111.song_id ~= "" then
		t175.songId = p111.song_id
	end

	return t175
end
function t173.jsonDecode(t176: {[any]: any}) -- line: 10596
	-- upvalues: t173 (copy)
	local v1527 = t173.new()

	if t176.song_id ~= nil then
		v1527.song_id = t176.song_id
	end

	if t176.songId ~= nil then
		v1527.song_id = t176.songId
	end

	return v1527
end

t173.descriptor = {
	name = "SongCarouselInputData_SongItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.SongItem"
}
t1.SongCarouselInputData_SongItem = t173
typeRegistry.default:register(t1.SongCarouselInputData_SongItem)

local t177 = {}

t177.__index = t177

function t177.new(t178: {[any]: any}?) -- line: 10624
	-- upvalues: t177 (copy)
	return (setmetatable({
		title = if t178 ~= nil and t178.title ~= nil then t178.title else "",
		event_items = if t178 ~= nil and t178.event_items ~= nil then t178.event_items else {},
		universe_id = if t178 ~= nil and t178.universe_id ~= nil then t178.universe_id else "",
		sort_id = if t178 ~= nil and t178.sort_id ~= nil then t178.sort_id else "",
		subtitle = if t178 ~= nil and t178.subtitle ~= nil then t178.subtitle else "",
		info_text = if t178 ~= nil and t178.info_text ~= nil then t178.info_text else ""
	}, t177))
end
function t177.encode(p112) -- line: 10635
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n74 = 0

	if p112.title ~= nil and p112.title ~= "" then
		local v1532, v1533 = proto.writeTag(buf, n74, 1, proto.wireTypes.lengthDelimited)

		buf, n74 = proto.writeString(v1532, v1533, p112.title)
	end

	if p112.event_items ~= nil and #p112.event_items > 0 then
		for _, v1535 in p112.event_items do
			local v1536 = v1535:encode()
			local v1537, v1538 = proto.writeTag(buf, n74, 2, proto.wireTypes.lengthDelimited)

			buf, n74 = proto.writeBuffer(v1537, v1538, v1536, buffer.len(v1536))
		end
	end

	if p112.universe_id ~= nil and p112.universe_id ~= "" then
		local v1539, v1540 = proto.writeTag(buf, n74, 3, proto.wireTypes.lengthDelimited)

		buf, n74 = proto.writeString(v1539, v1540, p112.universe_id)
	end

	if p112.sort_id ~= nil and p112.sort_id ~= "" then
		local v1541, v1542 = proto.writeTag(buf, n74, 4, proto.wireTypes.lengthDelimited)

		buf, n74 = proto.writeString(v1541, v1542, p112.sort_id)
	end

	if p112.subtitle ~= nil and p112.subtitle ~= "" then
		local v1543, v1544 = proto.writeTag(buf, n74, 5, proto.wireTypes.lengthDelimited)

		buf, n74 = proto.writeString(v1543, v1544, p112.subtitle)
	end

	if p112.info_text ~= nil and p112.info_text ~= "" then
		local v1545, v1546 = proto.writeTag(buf, n74, 6, proto.wireTypes.lengthDelimited)

		buf, n74 = proto.writeString(v1545, v1546, p112.info_text)
	end

	local buf41 = buffer.create(n74)

	buffer.copy(buf41, 0, buf, 0, n74)

	return buf41
end
function t177.decode(p113: buffer) -- line: 10677
	-- upvalues: t177 (copy), proto (copy), t1 (copy)
	local v1549 = t177.new()
	local n75 = 0

	while n75 < buffer.len(p113) do
		local v1551, v1552

		v1551, v1552, n75 = proto.readTag(p113, n75)

		if v1552 == proto.wireTypes.varint then
			local v1553

			v1553, n75 = proto.readVarInt(p113, n75)
		elseif v1552 == proto.wireTypes.lengthDelimited then
			if v1551 == 1 then
				local v1554

				v1554, n75 = proto.readBuffer(p113, n75)
				v1549.title = buffer.tostring(v1554)
			elseif v1551 == 2 then
				local v1555

				v1555, n75 = proto.readBuffer(p113, n75)
				table.insert(v1549.event_items, t1.EventsCarouselInputData_EventItem.decode(v1555))
			elseif v1551 == 3 then
				local v1556

				v1556, n75 = proto.readBuffer(p113, n75)
				v1549.universe_id = buffer.tostring(v1556)
			elseif v1551 == 4 then
				local v1557

				v1557, n75 = proto.readBuffer(p113, n75)
				v1549.sort_id = buffer.tostring(v1557)
			elseif v1551 == 5 then
				local v1558

				v1558, n75 = proto.readBuffer(p113, n75)
				v1549.subtitle = buffer.tostring(v1558)
			elseif v1551 == 6 then
				local v1559

				v1559, n75 = proto.readBuffer(p113, n75)
				v1549.info_text = buffer.tostring(v1559)
			else
				local v1560, v1561 = proto.readVarInt(p113, n75)

				n75 = v1561 + v1560
			end
		elseif v1552 == proto.wireTypes.i32 then
			local v1562

			v1562, n75 = proto.readFixed32(p113, n75)
		elseif v1552 == proto.wireTypes.i64 then
			local v1563

			v1563, n75 = proto.readFixed64(p113, n75)
		else
			error("Unsupported wire type: " .. v1552)
		end
	end

	return v1549
end
function t177.jsonEncode(p114) -- line: 10745
	local t179 = {}

	if p114.title ~= nil and p114.title ~= "" then
		t179.title = p114.title
	end

	if p114.event_items ~= nil and #p114.event_items > 0 then
		local t180 = {}

		for _, v1568 in p114.event_items do
			table.insert(t180, v1568:jsonEncode())
		end

		t179.eventItems = t180
	end

	if p114.universe_id ~= nil and p114.universe_id ~= "" then
		t179.universeId = p114.universe_id
	end

	if p114.sort_id ~= nil and p114.sort_id ~= "" then
		t179.sortId = p114.sort_id
	end

	if p114.subtitle ~= nil and p114.subtitle ~= "" then
		t179.subtitle = p114.subtitle
	end

	if p114.info_text ~= nil and p114.info_text ~= "" then
		t179.infoText = p114.info_text
	end

	return t179
end
function t177.jsonDecode(t181: {[any]: any}) -- line: 10779
	-- upvalues: t177 (copy), t1 (copy)
	local v1570 = t177.new()

	if t181.title ~= nil then
		v1570.title = t181.title
	end

	if t181.event_items ~= nil then
		local t182 = {}

		for _, v1573 in t181.event_items do
			table.insert(t182, t1.EventsCarouselInputData_EventItem.jsonDecode(v1573))
		end

		v1570.event_items = t182
	end

	if t181.eventItems ~= nil then
		local t183 = {}

		for _, v1576 in t181.eventItems do
			table.insert(t183, t1.EventsCarouselInputData_EventItem.jsonDecode(v1576))
		end

		v1570.event_items = t183
	end

	if t181.universe_id ~= nil then
		v1570.universe_id = t181.universe_id
	end

	if t181.universeId ~= nil then
		v1570.universe_id = t181.universeId
	end

	if t181.sort_id ~= nil then
		v1570.sort_id = t181.sort_id
	end

	if t181.sortId ~= nil then
		v1570.sort_id = t181.sortId
	end

	if t181.subtitle ~= nil then
		v1570.subtitle = t181.subtitle
	end

	if t181.info_text ~= nil then
		v1570.info_text = t181.info_text
	end

	if t181.infoText ~= nil then
		v1570.info_text = t181.infoText
	end

	return v1570
end

t177.descriptor = {
	name = "EventsCarouselInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventsCarouselInputData"
}
t1.EventsCarouselInputData = t177
typeRegistry.default:register(t1.EventsCarouselInputData)

local t184 = {}

t184.__index = t184

function t184.new(t185: {[any]: any}?) -- line: 10849
	-- upvalues: t184 (copy)
	return (setmetatable({
		event_id = if t185 ~= nil and t185.event_id ~= nil then t185.event_id else ""
	}, t184))
end
function t184.encode(p115) -- line: 10857
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n76 = 0

	if p115.event_id ~= nil and p115.event_id ~= "" then
		local v1581, v1582 = proto.writeTag(buf, n76, 1, proto.wireTypes.lengthDelimited)

		buf, n76 = proto.writeString(v1581, v1582, p115.event_id)
	end

	local buf42 = buffer.create(n76)

	buffer.copy(buf42, 0, buf, 0, n76)

	return buf42
end
function t184.decode(p116: buffer) -- line: 10871
	-- upvalues: t184 (copy), proto (copy)
	local v1585 = t184.new()
	local n77 = 0

	while n77 < buffer.len(p116) do
		local v1587, v1588

		v1587, v1588, n77 = proto.readTag(p116, n77)

		if v1588 == proto.wireTypes.varint then
			local v1589

			v1589, n77 = proto.readVarInt(p116, n77)
		elseif v1588 == proto.wireTypes.lengthDelimited then
			if v1587 == 1 then
				local v1590

				v1590, n77 = proto.readBuffer(p116, n77)
				v1585.event_id = buffer.tostring(v1590)
			else
				local v1591, v1592 = proto.readVarInt(p116, n77)

				n77 = v1592 + v1591
			end
		elseif v1588 == proto.wireTypes.i32 then
			local v1593

			v1593, n77 = proto.readFixed32(p116, n77)
		elseif v1588 == proto.wireTypes.i64 then
			local v1594

			v1594, n77 = proto.readFixed64(p116, n77)
		else
			error("Unsupported wire type: " .. v1588)
		end
	end

	return v1585
end
function t184.jsonEncode(p117) -- line: 10914
	local t186 = {}

	if p117.event_id ~= nil and p117.event_id ~= "" then
		t186.eventId = p117.event_id
	end

	return t186
end
function t184.jsonDecode(t187: {[any]: any}) -- line: 10924
	-- upvalues: t184 (copy)
	local v1598 = t184.new()

	if t187.event_id ~= nil then
		v1598.event_id = t187.event_id
	end

	if t187.eventId ~= nil then
		v1598.event_id = t187.eventId
	end

	return v1598
end

t184.descriptor = {
	name = "EventsCarouselInputData_EventItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventItem"
}
t1.EventsCarouselInputData_EventItem = t184
typeRegistry.default:register(t1.EventsCarouselInputData_EventItem)

local t188 = {}

t188.__index = t188

function t188.new(t189: {[any]: any}?) -- line: 10954
	-- upvalues: t188 (copy)
	return (setmetatable({
		universe_id = if t189 ~= nil and t189.universe_id ~= nil then t189.universe_id else "",
		entry_map = if t189 ~= nil and t189.entry_map ~= nil then t189.entry_map else {},
		entry_order = if t189 ~= nil and t189.entry_order ~= nil then t189.entry_order else {},
		creator_key = if t189 ~= nil and t189.creator_key ~= nil then t189.creator_key else ""
	}, t188))
end
function t188.encode(p118) -- line: 10963
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n78 = 0

	if p118.universe_id ~= nil and p118.universe_id ~= "" then
		local v1603, v1604 = proto.writeTag(buf, n78, 1, proto.wireTypes.lengthDelimited)

		buf, n78 = proto.writeString(v1603, v1604, p118.universe_id)
	end

	if p118.entry_map ~= nil and next(p118.entry_map) ~= nil then
		for v1605, v1606 in p118.entry_map do
			local buf43 = buffer.create(0)
			local v1608, v1609 = proto.writeTag(buf43, 0, 1, proto.wireTypes.lengthDelimited)
			local v1610, v1611 = proto.writeString(v1608, v1609, v1605)
			local v1612 = v1606:encode()
			local v1613, v1614 = proto.writeTag(v1610, v1611, 2, proto.wireTypes.lengthDelimited)
			local v1615, v1616 = proto.writeBuffer(v1613, v1614, v1612, buffer.len(v1612))
			local v1617, v1618 = proto.writeTag(buf, n78, 2, proto.wireTypes.lengthDelimited)

			buf, n78 = proto.writeBuffer(v1617, v1618, v1615, v1616)
		end
	end

	if p118.entry_order ~= nil and #p118.entry_order > 0 then
		for _, v1620 in p118.entry_order do
			local v1621, v1622 = proto.writeTag(buf, n78, 3, proto.wireTypes.lengthDelimited)

			buf, n78 = proto.writeString(v1621, v1622, v1620)
		end
	end

	if p118.creator_key ~= nil and p118.creator_key ~= "" then
		local v1623, v1624 = proto.writeTag(buf, n78, 4, proto.wireTypes.lengthDelimited)

		buf, n78 = proto.writeString(v1623, v1624, p118.creator_key)
	end

	local buf44 = buffer.create(n78)

	buffer.copy(buf44, 0, buf, 0, n78)

	return buf44
end
function t188.decode(p119: buffer) -- line: 11003
	-- upvalues: t188 (copy), proto (copy), t1 (copy)
	local v1627 = t188.new()
	local n79 = 0

	while n79 < buffer.len(p119) do
		local v1629, v1630

		v1629, v1630, n79 = proto.readTag(p119, n79)

		if v1630 == proto.wireTypes.varint then
			local v1631

			v1631, n79 = proto.readVarInt(p119, n79)
		elseif v1630 == proto.wireTypes.lengthDelimited then
			if v1629 == 1 then
				local v1632

				v1632, n79 = proto.readBuffer(p119, n79)
				v1627.universe_id = buffer.tostring(v1632)
			elseif v1629 == 2 then
				local v1633

				v1633, n79 = proto.readBuffer(p119, n79)

				local v1634 = t1.DevStoreFeedInputData_EntryMapEntry.decode(v1633)
				local v1635 = t1.FeedEntry.new()

				v1627.entry_map[v1634.key or ""] = v1634.value or v1635
			elseif v1629 == 3 then
				local v1636

				v1636, n79 = proto.readBuffer(p119, n79)
				table.insert(v1627.entry_order, buffer.tostring(v1636))
			elseif v1629 == 4 then
				local v1637

				v1637, n79 = proto.readBuffer(p119, n79)
				v1627.creator_key = buffer.tostring(v1637)
			else
				local v1638, v1639 = proto.readVarInt(p119, n79)

				n79 = v1639 + v1638
			end
		elseif v1630 == proto.wireTypes.i32 then
			local v1640

			v1640, n79 = proto.readFixed32(p119, n79)
		elseif v1630 == proto.wireTypes.i64 then
			local v1641

			v1641, n79 = proto.readFixed64(p119, n79)
		else
			error("Unsupported wire type: " .. v1630)
		end
	end

	return v1627
end
function t188.jsonEncode(p120) -- line: 11068
	local t190 = {}

	if p120.universe_id ~= nil and p120.universe_id ~= "" then
		t190.universeId = p120.universe_id
	end

	if p120.entry_map ~= nil and next(p120.entry_map) ~= nil then
		local t191 = {}

		for v1645, v1646 in p120.entry_map do
			t191[v1645] = v1646:jsonEncode()
		end

		t190.entryMap = t191
	end

	if p120.entry_order ~= nil and #p120.entry_order > 0 then
		local t192 = {}

		for _, v1649 in p120.entry_order do
			table.insert(t192, v1649)
		end

		t190.entryOrder = t192
	end

	if p120.creator_key ~= nil and p120.creator_key ~= "" then
		t190.creatorKey = p120.creator_key
	end

	return t190
end
function t188.jsonDecode(t193: {[any]: any}) -- line: 11098
	-- upvalues: t188 (copy), t1 (copy)
	local v1651 = t188.new()

	if t193.universe_id ~= nil then
		v1651.universe_id = t193.universe_id
	end

	if t193.universeId ~= nil then
		v1651.universe_id = t193.universeId
	end

	if t193.entry_map ~= nil then
		local t194 = {}

		for v1653, v1654 in t193.entry_map do
			t194[v1653] = t1.FeedEntry.jsonDecode(v1654)
		end

		v1651.entry_map = t194
	end

	if t193.entryMap ~= nil then
		local t195 = {}

		for v1656, v1657 in t193.entryMap do
			t195[v1656] = t1.FeedEntry.jsonDecode(v1657)
		end

		v1651.entry_map = t195
	end

	if t193.entry_order ~= nil then
		local t196 = {}

		for _, v1660 in t193.entry_order do
			table.insert(t196, v1660)
		end

		v1651.entry_order = t196
	end

	if t193.entryOrder ~= nil then
		local t197 = {}

		for _, v1663 in t193.entryOrder do
			table.insert(t197, v1663)
		end

		v1651.entry_order = t197
	end

	if t193.creator_key ~= nil then
		v1651.creator_key = t193.creator_key
	end

	if t193.creatorKey ~= nil then
		v1651.creator_key = t193.creatorKey
	end

	return v1651
end

t188.descriptor = {
	name = "DevStoreFeedInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.DevStoreFeedInputData"
}
t1.DevStoreFeedInputData = t188
typeRegistry.default:register(t1.DevStoreFeedInputData)

local t198 = {}

t198.__index = t198

function t198.new(t199: {[any]: any}?) -- line: 11170
	-- upvalues: t198 (copy)
	return (setmetatable({
		key = if t199 ~= nil and t199.key ~= nil then t199.key else "",
		value = if t199 ~= nil and t199.value ~= nil then t199.value else nil
	}, t198))
end
function t198.encode(p121) -- line: 11179
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n80 = 0

	if p121.key ~= nil and p121.key ~= "" then
		local v1668, v1669 = proto.writeTag(buf, n80, 1, proto.wireTypes.lengthDelimited)

		buf, n80 = proto.writeString(v1668, v1669, p121.key)
	end

	if p121.value ~= nil then
		local v1670 = p121.value:encode()
		local v1671, v1672 = proto.writeTag(buf, n80, 2, proto.wireTypes.lengthDelimited)

		buf, n80 = proto.writeBuffer(v1671, v1672, v1670, buffer.len(v1670))
	end

	local buf45 = buffer.create(n80)

	buffer.copy(buf45, 0, buf, 0, n80)

	return buf45
end
function t198.decode(p122: buffer) -- line: 11199
	-- upvalues: t198 (copy), proto (copy), t1 (copy)
	local v1675 = t198.new()
	local n81 = 0

	while n81 < buffer.len(p122) do
		local v1677, v1678

		v1677, v1678, n81 = proto.readTag(p122, n81)

		if v1678 == proto.wireTypes.varint then
			local v1679

			v1679, n81 = proto.readVarInt(p122, n81)
		elseif v1678 == proto.wireTypes.lengthDelimited then
			if v1677 == 1 then
				local v1680

				v1680, n81 = proto.readBuffer(p122, n81)
				v1675.key = buffer.tostring(v1680)
			elseif v1677 == 2 then
				local v1681

				v1681, n81 = proto.readBuffer(p122, n81)
				v1675.value = t1.FeedEntry.decode(v1681)
			else
				local v1682, v1683 = proto.readVarInt(p122, n81)

				n81 = v1683 + v1682
			end
		elseif v1678 == proto.wireTypes.i32 then
			local v1684

			v1684, n81 = proto.readFixed32(p122, n81)
		elseif v1678 == proto.wireTypes.i64 then
			local v1685

			v1685, n81 = proto.readFixed64(p122, n81)
		else
			error("Unsupported wire type: " .. v1678)
		end
	end

	return v1675
end
function t198.jsonEncode(p123) -- line: 11247
	local t200 = {}

	if p123.key ~= nil and p123.key ~= "" then
		t200.key = p123.key
	end

	if p123.value ~= nil then
		t200.value = p123.value:jsonEncode()
	end

	return t200
end
function t198.jsonDecode(t201: {[any]: any}) -- line: 11261
	-- upvalues: t198 (copy), t1 (copy)
	local v1689 = t198.new()

	if t201.key ~= nil then
		v1689.key = t201.key
	end

	if t201.value ~= nil then
		v1689.value = t1.FeedEntry.jsonDecode(t201.value)
	end

	return v1689
end

t198.descriptor = {
	name = "DevStoreFeedInputData_EntryMapEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryMapEntry"
}
t1.DevStoreFeedInputData_EntryMapEntry = t198
typeRegistry.default:register(t1.DevStoreFeedInputData_EntryMapEntry)

local t202 = {}

t202.__index = t202

function t202.new(t203: {[any]: any}?) -- line: 11291
	-- upvalues: t202 (copy)
	return (setmetatable({
		game_passes = if t203 ~= nil and t203.game_passes ~= nil then t203.game_passes else {}
	}, t202))
end
function t202.encode(p124) -- line: 11299
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n82 = 0

	if p124.game_passes ~= nil and #p124.game_passes > 0 then
		for _, v1695 in p124.game_passes do
			local v1696 = v1695:encode()
			local v1697, v1698 = proto.writeTag(buf, n82, 1, proto.wireTypes.lengthDelimited)

			buf, n82 = proto.writeBuffer(v1697, v1698, v1696, buffer.len(v1696))
		end
	end

	local buf46 = buffer.create(n82)

	buffer.copy(buf46, 0, buf, 0, n82)

	return buf46
end
function t202.decode(p125: buffer) -- line: 11316
	-- upvalues: t202 (copy), proto (copy), t1 (copy)
	local v1701 = t202.new()
	local n83 = 0

	while n83 < buffer.len(p125) do
		local v1703, v1704

		v1703, v1704, n83 = proto.readTag(p125, n83)

		if v1704 == proto.wireTypes.varint then
			local v1705

			v1705, n83 = proto.readVarInt(p125, n83)
		elseif v1704 == proto.wireTypes.lengthDelimited then
			if v1703 == 1 then
				local v1706

				v1706, n83 = proto.readBuffer(p125, n83)
				table.insert(v1701.game_passes, t1.GamePassCollectionInputData_GamePassItem.decode(v1706))
			else
				local v1707, v1708 = proto.readVarInt(p125, n83)

				n83 = v1708 + v1707
			end
		elseif v1704 == proto.wireTypes.i32 then
			local v1709

			v1709, n83 = proto.readFixed32(p125, n83)
		elseif v1704 == proto.wireTypes.i64 then
			local v1710

			v1710, n83 = proto.readFixed64(p125, n83)
		else
			error("Unsupported wire type: " .. v1704)
		end
	end

	return v1701
end
function t202.jsonEncode(p126) -- line: 11359
	local t204 = {}

	if p126.game_passes ~= nil and #p126.game_passes > 0 then
		local t205 = {}

		for _, v1715 in p126.game_passes do
			table.insert(t205, v1715:jsonEncode())
		end

		t204.gamePasses = t205
	end

	return t204
end
function t202.jsonDecode(t206: {[any]: any}) -- line: 11373
	-- upvalues: t202 (copy), t1 (copy)
	local v1717 = t202.new()

	if t206.game_passes ~= nil then
		local t207 = {}

		for _, v1720 in t206.game_passes do
			table.insert(t207, t1.GamePassCollectionInputData_GamePassItem.jsonDecode(v1720))
		end

		v1717.game_passes = t207
	end

	if t206.gamePasses ~= nil then
		local t208 = {}

		for _, v1723 in t206.gamePasses do
			table.insert(t208, t1.GamePassCollectionInputData_GamePassItem.jsonDecode(v1723))
		end

		v1717.game_passes = t208
	end

	return v1717
end

t202.descriptor = {
	name = "GamePassCollectionInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.GamePassCollectionInputData"
}
t1.GamePassCollectionInputData = t202
typeRegistry.default:register(t1.GamePassCollectionInputData)

local t209 = {}

t209.__index = t209

function t209.new(t210: {[any]: any}?) -- line: 11411
	-- upvalues: t209 (copy)
	return (setmetatable({
		game_pass_id = if t210 ~= nil and t210.game_pass_id ~= nil then t210.game_pass_id else ""
	}, t209))
end
function t209.encode(p127) -- line: 11419
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n84 = 0

	if p127.game_pass_id ~= nil and p127.game_pass_id ~= "" then
		local v1728, v1729 = proto.writeTag(buf, n84, 1, proto.wireTypes.lengthDelimited)

		buf, n84 = proto.writeString(v1728, v1729, p127.game_pass_id)
	end

	local buf47 = buffer.create(n84)

	buffer.copy(buf47, 0, buf, 0, n84)

	return buf47
end
function t209.decode(p128: buffer) -- line: 11435
	-- upvalues: t209 (copy), proto (copy)
	local v1732 = t209.new()
	local n85 = 0

	while n85 < buffer.len(p128) do
		local v1734, v1735

		v1734, v1735, n85 = proto.readTag(p128, n85)

		if v1735 == proto.wireTypes.varint then
			local v1736

			v1736, n85 = proto.readVarInt(p128, n85)
		elseif v1735 == proto.wireTypes.lengthDelimited then
			if v1734 == 1 then
				local v1737

				v1737, n85 = proto.readBuffer(p128, n85)
				v1732.game_pass_id = buffer.tostring(v1737)
			else
				local v1738, v1739 = proto.readVarInt(p128, n85)

				n85 = v1739 + v1738
			end
		elseif v1735 == proto.wireTypes.i32 then
			local v1740

			v1740, n85 = proto.readFixed32(p128, n85)
		elseif v1735 == proto.wireTypes.i64 then
			local v1741

			v1741, n85 = proto.readFixed64(p128, n85)
		else
			error("Unsupported wire type: " .. v1735)
		end
	end

	return v1732
end
function t209.jsonEncode(p129) -- line: 11480
	local t211 = {}

	if p129.game_pass_id ~= nil and p129.game_pass_id ~= "" then
		t211.gamePassId = p129.game_pass_id
	end

	return t211
end
function t209.jsonDecode(t212: {[any]: any}) -- line: 11492
	-- upvalues: t209 (copy)
	local v1745 = t209.new()

	if t212.game_pass_id ~= nil then
		v1745.game_pass_id = t212.game_pass_id
	end

	if t212.gamePassId ~= nil then
		v1745.game_pass_id = t212.gamePassId
	end

	return v1745
end

t209.descriptor = {
	name = "GamePassCollectionInputData_GamePassItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.GamePassItem"
}
t1.GamePassCollectionInputData_GamePassItem = t209
typeRegistry.default:register(t1.GamePassCollectionInputData_GamePassItem)

local t213 = {}

t213.__index = t213

function t213.new(t214: {[any]: any}?) -- line: 11522
	-- upvalues: t213 (copy)
	return (setmetatable({
		developer_products = if t214 ~= nil and t214.developer_products ~= nil then t214.developer_products else {}
	}, t213))
end
function t213.encode(p130) -- line: 11530
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n86 = 0

	if p130.developer_products ~= nil and #p130.developer_products > 0 then
		for _, v1751 in p130.developer_products do
			local v1752 = v1751:encode()
			local v1753, v1754 = proto.writeTag(buf, n86, 1, proto.wireTypes.lengthDelimited)

			buf, n86 = proto.writeBuffer(v1753, v1754, v1752, buffer.len(v1752))
		end
	end

	local buf48 = buffer.create(n86)

	buffer.copy(buf48, 0, buf, 0, n86)

	return buf48
end
function t213.decode(p131: buffer) -- line: 11547
	-- upvalues: t213 (copy), proto (copy), t1 (copy)
	local v1757 = t213.new()
	local n87 = 0

	while n87 < buffer.len(p131) do
		local v1759, v1760

		v1759, v1760, n87 = proto.readTag(p131, n87)

		if v1760 == proto.wireTypes.varint then
			local v1761

			v1761, n87 = proto.readVarInt(p131, n87)
		elseif v1760 == proto.wireTypes.lengthDelimited then
			if v1759 == 1 then
				local v1762

				v1762, n87 = proto.readBuffer(p131, n87)
				table.insert(v1757.developer_products, t1.DeveloperProductCollectionInputData_DeveloperProductItem.decode(v1762))
			else
				local v1763, v1764 = proto.readVarInt(p131, n87)

				n87 = v1764 + v1763
			end
		elseif v1760 == proto.wireTypes.i32 then
			local v1765

			v1765, n87 = proto.readFixed32(p131, n87)
		elseif v1760 == proto.wireTypes.i64 then
			local v1766

			v1766, n87 = proto.readFixed64(p131, n87)
		else
			error("Unsupported wire type: " .. v1760)
		end
	end

	return v1757
end
function t213.jsonEncode(p132) -- line: 11593
	local t215 = {}

	if p132.developer_products ~= nil and #p132.developer_products > 0 then
		local t216 = {}

		for _, v1771 in p132.developer_products do
			table.insert(t216, v1771:jsonEncode())
		end

		t215.developerProducts = t216
	end

	return t215
end
function t213.jsonDecode(t217: {[any]: any}) -- line: 11607
	-- upvalues: t213 (copy), t1 (copy)
	local v1773 = t213.new()

	if t217.developer_products ~= nil then
		local t218 = {}

		for _, v1776 in t217.developer_products do
			table.insert(t218, t1.DeveloperProductCollectionInputData_DeveloperProductItem.jsonDecode(v1776))
		end

		v1773.developer_products = t218
	end

	if t217.developerProducts ~= nil then
		local t219 = {}

		for _, v1779 in t217.developerProducts do
			table.insert(t219, t1.DeveloperProductCollectionInputData_DeveloperProductItem.jsonDecode(v1779))
		end

		v1773.developer_products = t219
	end

	return v1773
end

t213.descriptor = {
	name = "DeveloperProductCollectionInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.DeveloperProductCollectionInputData"
}
t1.DeveloperProductCollectionInputData = t213
typeRegistry.default:register(t1.DeveloperProductCollectionInputData)

local t220 = {}

t220.__index = t220

function t220.new(t221: {[any]: any}?) -- line: 11654
	-- upvalues: t220 (copy)
	return (setmetatable({
		developer_product_id = if t221 ~= nil and t221.developer_product_id ~= nil then t221.developer_product_id else ""
	}, t220))
end
function t220.encode(p133) -- line: 11667
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n88 = 0

	if p133.developer_product_id ~= nil and p133.developer_product_id ~= "" then
		local v1784, v1785 = proto.writeTag(buf, n88, 1, proto.wireTypes.lengthDelimited)

		buf, n88 = proto.writeString(v1784, v1785, p133.developer_product_id)
	end

	local buf49 = buffer.create(n88)

	buffer.copy(buf49, 0, buf, 0, n88)

	return buf49
end
function t220.decode(p134: buffer) -- line: 11683
	-- upvalues: t220 (copy), proto (copy)
	local v1788 = t220.new()
	local n89 = 0

	while n89 < buffer.len(p134) do
		local v1790, v1791

		v1790, v1791, n89 = proto.readTag(p134, n89)

		if v1791 == proto.wireTypes.varint then
			local v1792

			v1792, n89 = proto.readVarInt(p134, n89)
		elseif v1791 == proto.wireTypes.lengthDelimited then
			if v1790 == 1 then
				local v1793

				v1793, n89 = proto.readBuffer(p134, n89)
				v1788.developer_product_id = buffer.tostring(v1793)
			else
				local v1794, v1795 = proto.readVarInt(p134, n89)

				n89 = v1795 + v1794
			end
		elseif v1791 == proto.wireTypes.i32 then
			local v1796

			v1796, n89 = proto.readFixed32(p134, n89)
		elseif v1791 == proto.wireTypes.i64 then
			local v1797

			v1797, n89 = proto.readFixed64(p134, n89)
		else
			error("Unsupported wire type: " .. v1791)
		end
	end

	return v1788
end
function t220.jsonEncode(p135) -- line: 11728
	local t222 = {}

	if p135.developer_product_id ~= nil and p135.developer_product_id ~= "" then
		t222.developerProductId = p135.developer_product_id
	end

	return t222
end
function t220.jsonDecode(t223: {[any]: any}) -- line: 11740
	-- upvalues: t220 (copy)
	local v1801 = t220.new()

	if t223.developer_product_id ~= nil then
		v1801.developer_product_id = t223.developer_product_id
	end

	if t223.developerProductId ~= nil then
		v1801.developer_product_id = t223.developerProductId
	end

	return v1801
end

t220.descriptor = {
	name = "DeveloperProductCollectionInputData_DeveloperProductItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.DeveloperProductItem"
}
t1.DeveloperProductCollectionInputData_DeveloperProductItem = t220
typeRegistry.default:register(t1.DeveloperProductCollectionInputData_DeveloperProductItem)

local t224 = {}

t224.__index = t224

function t224.new(t225: {[any]: any}?) -- line: 11771
	-- upvalues: t224 (copy)
	return (setmetatable({
		subscriptions = if t225 ~= nil and t225.subscriptions ~= nil then t225.subscriptions else {}
	}, t224))
end
function t224.encode(p136) -- line: 11779
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n90 = 0

	if p136.subscriptions ~= nil and #p136.subscriptions > 0 then
		for _, v1807 in p136.subscriptions do
			local v1808 = v1807:encode()
			local v1809, v1810 = proto.writeTag(buf, n90, 1, proto.wireTypes.lengthDelimited)

			buf, n90 = proto.writeBuffer(v1809, v1810, v1808, buffer.len(v1808))
		end
	end

	local buf50 = buffer.create(n90)

	buffer.copy(buf50, 0, buf, 0, n90)

	return buf50
end
function t224.decode(p137: buffer) -- line: 11796
	-- upvalues: t224 (copy), proto (copy), t1 (copy)
	local v1813 = t224.new()
	local n91 = 0

	while n91 < buffer.len(p137) do
		local v1815, v1816

		v1815, v1816, n91 = proto.readTag(p137, n91)

		if v1816 == proto.wireTypes.varint then
			local v1817

			v1817, n91 = proto.readVarInt(p137, n91)
		elseif v1816 == proto.wireTypes.lengthDelimited then
			if v1815 == 1 then
				local v1818

				v1818, n91 = proto.readBuffer(p137, n91)
				table.insert(v1813.subscriptions, t1.SubscriptionCollectionInputData_SubscriptionItem.decode(v1818))
			else
				local v1819, v1820 = proto.readVarInt(p137, n91)

				n91 = v1820 + v1819
			end
		elseif v1816 == proto.wireTypes.i32 then
			local v1821

			v1821, n91 = proto.readFixed32(p137, n91)
		elseif v1816 == proto.wireTypes.i64 then
			local v1822

			v1822, n91 = proto.readFixed64(p137, n91)
		else
			error("Unsupported wire type: " .. v1816)
		end
	end

	return v1813
end
function t224.jsonEncode(p138) -- line: 11842
	local t226 = {}

	if p138.subscriptions ~= nil and #p138.subscriptions > 0 then
		local t227 = {}

		for _, v1827 in p138.subscriptions do
			table.insert(t227, v1827:jsonEncode())
		end

		t226.subscriptions = t227
	end

	return t226
end
function t224.jsonDecode(t228: {[any]: any}) -- line: 11856
	-- upvalues: t224 (copy), t1 (copy)
	local v1829 = t224.new()

	if t228.subscriptions ~= nil then
		local t229 = {}

		for _, v1832 in t228.subscriptions do
			table.insert(t229, t1.SubscriptionCollectionInputData_SubscriptionItem.jsonDecode(v1832))
		end

		v1829.subscriptions = t229
	end

	return v1829
end

t224.descriptor = {
	name = "SubscriptionCollectionInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.SubscriptionCollectionInputData"
}
t1.SubscriptionCollectionInputData = t224
typeRegistry.default:register(t1.SubscriptionCollectionInputData)

local t230 = {}

t230.__index = t230

function t230.new(t231: {[any]: any}?) -- line: 11886
	-- upvalues: t230 (copy)
	return (setmetatable({
		subscription_id = if t231 ~= nil and t231.subscription_id ~= nil then t231.subscription_id else ""
	}, t230))
end
function t230.encode(p139) -- line: 11897
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n92 = 0

	if p139.subscription_id ~= nil and p139.subscription_id ~= "" then
		local v1837, v1838 = proto.writeTag(buf, n92, 1, proto.wireTypes.lengthDelimited)

		buf, n92 = proto.writeString(v1837, v1838, p139.subscription_id)
	end

	local buf51 = buffer.create(n92)

	buffer.copy(buf51, 0, buf, 0, n92)

	return buf51
end
function t230.decode(p140: buffer) -- line: 11913
	-- upvalues: t230 (copy), proto (copy)
	local v1841 = t230.new()
	local n93 = 0

	while n93 < buffer.len(p140) do
		local v1843, v1844

		v1843, v1844, n93 = proto.readTag(p140, n93)

		if v1844 == proto.wireTypes.varint then
			local v1845

			v1845, n93 = proto.readVarInt(p140, n93)
		elseif v1844 == proto.wireTypes.lengthDelimited then
			if v1843 == 1 then
				local v1846

				v1846, n93 = proto.readBuffer(p140, n93)
				v1841.subscription_id = buffer.tostring(v1846)
			else
				local v1847, v1848 = proto.readVarInt(p140, n93)

				n93 = v1848 + v1847
			end
		elseif v1844 == proto.wireTypes.i32 then
			local v1849

			v1849, n93 = proto.readFixed32(p140, n93)
		elseif v1844 == proto.wireTypes.i64 then
			local v1850

			v1850, n93 = proto.readFixed64(p140, n93)
		else
			error("Unsupported wire type: " .. v1844)
		end
	end

	return v1841
end
function t230.jsonEncode(p141) -- line: 11958
	local t232 = {}

	if p141.subscription_id ~= nil and p141.subscription_id ~= "" then
		t232.subscriptionId = p141.subscription_id
	end

	return t232
end
function t230.jsonDecode(t233: {[any]: any}) -- line: 11970
	-- upvalues: t230 (copy)
	local v1854 = t230.new()

	if t233.subscription_id ~= nil then
		v1854.subscription_id = t233.subscription_id
	end

	if t233.subscriptionId ~= nil then
		v1854.subscription_id = t233.subscriptionId
	end

	return v1854
end

t230.descriptor = {
	name = "SubscriptionCollectionInputData_SubscriptionItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.SubscriptionItem"
}
t1.SubscriptionCollectionInputData_SubscriptionItem = t230
typeRegistry.default:register(t1.SubscriptionCollectionInputData_SubscriptionItem)

local t234 = {}

t234.__index = t234

function t234.new(t235: {[any]: any}?) -- line: 12001
	-- upvalues: t234 (copy)
	return (setmetatable({
		roblox_component = if t235 ~= nil and t235.roblox_component ~= nil then t235.roblox_component else "",
		identifier = if t235 ~= nil and t235.identifier ~= nil then t235.identifier else "",
		title = if t235 ~= nil and t235.title ~= nil then t235.title else "",
		user_id = if t235 ~= nil and t235.user_id ~= nil then t235.user_id else "",
		description = if t235 ~= nil and t235.description ~= nil then t235.description else "",
		cta_text = if t235 ~= nil and t235.cta_text ~= nil then t235.cta_text else "",
		prompt_id = if t235 ~= nil and t235.prompt_id ~= nil then t235.prompt_id else "",
		prompt_type = if t235 ~= nil and t235.prompt_type ~= nil then t235.prompt_type else ""
	}, t234))
end
function t234.encode(p142) -- line: 12016
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n94 = 0

	if p142.roblox_component ~= nil and p142.roblox_component ~= "" then
		local v1859, v1860 = proto.writeTag(buf, n94, 1, proto.wireTypes.lengthDelimited)

		buf, n94 = proto.writeString(v1859, v1860, p142.roblox_component)
	end

	if p142.identifier ~= nil and p142.identifier ~= "" then
		local v1861, v1862 = proto.writeTag(buf, n94, 2, proto.wireTypes.lengthDelimited)

		buf, n94 = proto.writeString(v1861, v1862, p142.identifier)
	end

	if p142.title ~= nil and p142.title ~= "" then
		local v1863, v1864 = proto.writeTag(buf, n94, 3, proto.wireTypes.lengthDelimited)

		buf, n94 = proto.writeString(v1863, v1864, p142.title)
	end

	if p142.user_id ~= nil and p142.user_id ~= "" then
		local v1865, v1866 = proto.writeTag(buf, n94, 4, proto.wireTypes.lengthDelimited)

		buf, n94 = proto.writeString(v1865, v1866, p142.user_id)
	end

	if p142.description ~= nil and p142.description ~= "" then
		local v1867, v1868 = proto.writeTag(buf, n94, 5, proto.wireTypes.lengthDelimited)

		buf, n94 = proto.writeString(v1867, v1868, p142.description)
	end

	if p142.cta_text ~= nil and p142.cta_text ~= "" then
		local v1869, v1870 = proto.writeTag(buf, n94, 6, proto.wireTypes.lengthDelimited)

		buf, n94 = proto.writeString(v1869, v1870, p142.cta_text)
	end

	if p142.prompt_id ~= nil and p142.prompt_id ~= "" then
		local v1871, v1872 = proto.writeTag(buf, n94, 7, proto.wireTypes.lengthDelimited)

		buf, n94 = proto.writeString(v1871, v1872, p142.prompt_id)
	end

	if p142.prompt_type ~= nil and p142.prompt_type ~= "" then
		local v1873, v1874 = proto.writeTag(buf, n94, 8, proto.wireTypes.lengthDelimited)

		buf, n94 = proto.writeString(v1873, v1874, p142.prompt_type)
	end

	local buf52 = buffer.create(n94)

	buffer.copy(buf52, 0, buf, 0, n94)

	return buf52
end
function t234.decode(p143: buffer) -- line: 12065
	-- upvalues: t234 (copy), proto (copy)
	local v1877 = t234.new()
	local n95 = 0

	while n95 < buffer.len(p143) do
		local v1879, v1880

		v1879, v1880, n95 = proto.readTag(p143, n95)

		if v1880 == proto.wireTypes.varint then
			local v1881

			v1881, n95 = proto.readVarInt(p143, n95)
		elseif v1880 == proto.wireTypes.lengthDelimited then
			if v1879 == 1 then
				local v1882

				v1882, n95 = proto.readBuffer(p143, n95)
				v1877.roblox_component = buffer.tostring(v1882)
			elseif v1879 == 2 then
				local v1883

				v1883, n95 = proto.readBuffer(p143, n95)
				v1877.identifier = buffer.tostring(v1883)
			elseif v1879 == 3 then
				local v1884

				v1884, n95 = proto.readBuffer(p143, n95)
				v1877.title = buffer.tostring(v1884)
			elseif v1879 == 4 then
				local v1885

				v1885, n95 = proto.readBuffer(p143, n95)
				v1877.user_id = buffer.tostring(v1885)
			elseif v1879 == 5 then
				local v1886

				v1886, n95 = proto.readBuffer(p143, n95)
				v1877.description = buffer.tostring(v1886)
			elseif v1879 == 6 then
				local v1887

				v1887, n95 = proto.readBuffer(p143, n95)
				v1877.cta_text = buffer.tostring(v1887)
			elseif v1879 == 7 then
				local v1888

				v1888, n95 = proto.readBuffer(p143, n95)
				v1877.prompt_id = buffer.tostring(v1888)
			elseif v1879 == 8 then
				local v1889

				v1889, n95 = proto.readBuffer(p143, n95)
				v1877.prompt_type = buffer.tostring(v1889)
			else
				local v1890, v1891 = proto.readVarInt(p143, n95)

				n95 = v1891 + v1890
			end
		elseif v1880 == proto.wireTypes.i32 then
			local v1892

			v1892, n95 = proto.readFixed32(p143, n95)
		elseif v1880 == proto.wireTypes.i64 then
			local v1893

			v1893, n95 = proto.readFixed64(p143, n95)
		else
			error("Unsupported wire type: " .. v1880)
		end
	end

	return v1877
end
function t234.jsonEncode(p144) -- line: 12143
	local t236 = {}

	if p144.roblox_component ~= nil and p144.roblox_component ~= "" then
		t236.robloxComponent = p144.roblox_component
	end

	if p144.identifier ~= nil and p144.identifier ~= "" then
		t236.identifier = p144.identifier
	end

	if p144.title ~= nil and p144.title ~= "" then
		t236.title = p144.title
	end

	if p144.user_id ~= nil and p144.user_id ~= "" then
		t236.userId = p144.user_id
	end

	if p144.description ~= nil and p144.description ~= "" then
		t236.description = p144.description
	end

	if p144.cta_text ~= nil and p144.cta_text ~= "" then
		t236.ctaText = p144.cta_text
	end

	if p144.prompt_id ~= nil and p144.prompt_id ~= "" then
		t236.promptId = p144.prompt_id
	end

	if p144.prompt_type ~= nil and p144.prompt_type ~= "" then
		t236.promptType = p144.prompt_type
	end

	return t236
end
function t234.jsonDecode(t237: {[any]: any}) -- line: 12181
	-- upvalues: t234 (copy)
	local v1897 = t234.new()

	if t237.roblox_component ~= nil then
		v1897.roblox_component = t237.roblox_component
	end

	if t237.robloxComponent ~= nil then
		v1897.roblox_component = t237.robloxComponent
	end

	if t237.identifier ~= nil then
		v1897.identifier = t237.identifier
	end

	if t237.title ~= nil then
		v1897.title = t237.title
	end

	if t237.user_id ~= nil then
		v1897.user_id = t237.user_id
	end

	if t237.userId ~= nil then
		v1897.user_id = t237.userId
	end

	if t237.description ~= nil then
		v1897.description = t237.description
	end

	if t237.cta_text ~= nil then
		v1897.cta_text = t237.cta_text
	end

	if t237.ctaText ~= nil then
		v1897.cta_text = t237.ctaText
	end

	if t237.prompt_id ~= nil then
		v1897.prompt_id = t237.prompt_id
	end

	if t237.promptId ~= nil then
		v1897.prompt_id = t237.promptId
	end

	if t237.prompt_type ~= nil then
		v1897.prompt_type = t237.prompt_type
	end

	if t237.promptType ~= nil then
		v1897.prompt_type = t237.promptType
	end

	return v1897
end

t234.descriptor = {
	name = "CardContainerCardInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CardContainerCardInputData"
}
t1.CardContainerCardInputData = t234
typeRegistry.default:register(t1.CardContainerCardInputData)

local t238 = {}

t238.__index = t238

function t238.new(t239: {[any]: any}?) -- line: 12253
	-- upvalues: t238 (copy)
	return (setmetatable({
		title = if t239 ~= nil and t239.title ~= nil then t239.title else "",
		dismiss_text = if t239 ~= nil and t239.dismiss_text ~= nil then t239.dismiss_text else "",
		user_id = if t239 ~= nil and t239.user_id ~= nil then t239.user_id else "",
		cards = if t239 ~= nil and t239.cards ~= nil then t239.cards else {},
		prompt_id = if t239 ~= nil and t239.prompt_id ~= nil then t239.prompt_id else "",
		prompt_type = if t239 ~= nil and t239.prompt_type ~= nil then t239.prompt_type else ""
	}, t238))
end
function t238.encode(p145) -- line: 12264
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n96 = 0

	if p145.title ~= nil and p145.title ~= "" then
		local v1902, v1903 = proto.writeTag(buf, n96, 1, proto.wireTypes.lengthDelimited)

		buf, n96 = proto.writeString(v1902, v1903, p145.title)
	end

	if p145.dismiss_text ~= nil and p145.dismiss_text ~= "" then
		local v1904, v1905 = proto.writeTag(buf, n96, 2, proto.wireTypes.lengthDelimited)

		buf, n96 = proto.writeString(v1904, v1905, p145.dismiss_text)
	end

	if p145.user_id ~= nil and p145.user_id ~= "" then
		local v1906, v1907 = proto.writeTag(buf, n96, 3, proto.wireTypes.lengthDelimited)

		buf, n96 = proto.writeString(v1906, v1907, p145.user_id)
	end

	if p145.cards ~= nil and #p145.cards > 0 then
		for _, v1909 in p145.cards do
			local v1910 = v1909:encode()
			local v1911, v1912 = proto.writeTag(buf, n96, 4, proto.wireTypes.lengthDelimited)

			buf, n96 = proto.writeBuffer(v1911, v1912, v1910, buffer.len(v1910))
		end
	end

	if p145.prompt_id ~= nil and p145.prompt_id ~= "" then
		local v1913, v1914 = proto.writeTag(buf, n96, 5, proto.wireTypes.lengthDelimited)

		buf, n96 = proto.writeString(v1913, v1914, p145.prompt_id)
	end

	if p145.prompt_type ~= nil and p145.prompt_type ~= "" then
		local v1915, v1916 = proto.writeTag(buf, n96, 6, proto.wireTypes.lengthDelimited)

		buf, n96 = proto.writeString(v1915, v1916, p145.prompt_type)
	end

	local buf53 = buffer.create(n96)

	buffer.copy(buf53, 0, buf, 0, n96)

	return buf53
end
function t238.decode(p146: buffer) -- line: 12306
	-- upvalues: t238 (copy), proto (copy), t1 (copy)
	local v1919 = t238.new()
	local n97 = 0

	while n97 < buffer.len(p146) do
		local v1921, v1922

		v1921, v1922, n97 = proto.readTag(p146, n97)

		if v1922 == proto.wireTypes.varint then
			local v1923

			v1923, n97 = proto.readVarInt(p146, n97)
		elseif v1922 == proto.wireTypes.lengthDelimited then
			if v1921 == 1 then
				local v1924

				v1924, n97 = proto.readBuffer(p146, n97)
				v1919.title = buffer.tostring(v1924)
			elseif v1921 == 2 then
				local v1925

				v1925, n97 = proto.readBuffer(p146, n97)
				v1919.dismiss_text = buffer.tostring(v1925)
			elseif v1921 == 3 then
				local v1926

				v1926, n97 = proto.readBuffer(p146, n97)
				v1919.user_id = buffer.tostring(v1926)
			elseif v1921 == 4 then
				local v1927

				v1927, n97 = proto.readBuffer(p146, n97)
				table.insert(v1919.cards, t1.CardContainerCardInputData.decode(v1927))
			elseif v1921 == 5 then
				local v1928

				v1928, n97 = proto.readBuffer(p146, n97)
				v1919.prompt_id = buffer.tostring(v1928)
			elseif v1921 == 6 then
				local v1929

				v1929, n97 = proto.readBuffer(p146, n97)
				v1919.prompt_type = buffer.tostring(v1929)
			else
				local v1930, v1931 = proto.readVarInt(p146, n97)

				n97 = v1931 + v1930
			end
		elseif v1922 == proto.wireTypes.i32 then
			local v1932

			v1932, n97 = proto.readFixed32(p146, n97)
		elseif v1922 == proto.wireTypes.i64 then
			local v1933

			v1933, n97 = proto.readFixed64(p146, n97)
		else
			error("Unsupported wire type: " .. v1922)
		end
	end

	return v1919
end
function t238.jsonEncode(p147) -- line: 12374
	local t240 = {}

	if p147.title ~= nil and p147.title ~= "" then
		t240.title = p147.title
	end

	if p147.dismiss_text ~= nil and p147.dismiss_text ~= "" then
		t240.dismissText = p147.dismiss_text
	end

	if p147.user_id ~= nil and p147.user_id ~= "" then
		t240.userId = p147.user_id
	end

	if p147.cards ~= nil and #p147.cards > 0 then
		local t241 = {}

		for _, v1938 in p147.cards do
			table.insert(t241, v1938:jsonEncode())
		end

		t240.cards = t241
	end

	if p147.prompt_id ~= nil and p147.prompt_id ~= "" then
		t240.promptId = p147.prompt_id
	end

	if p147.prompt_type ~= nil and p147.prompt_type ~= "" then
		t240.promptType = p147.prompt_type
	end

	return t240
end
function t238.jsonDecode(t242: {[any]: any}) -- line: 12408
	-- upvalues: t238 (copy), t1 (copy)
	local v1940 = t238.new()

	if t242.title ~= nil then
		v1940.title = t242.title
	end

	if t242.dismiss_text ~= nil then
		v1940.dismiss_text = t242.dismiss_text
	end

	if t242.dismissText ~= nil then
		v1940.dismiss_text = t242.dismissText
	end

	if t242.user_id ~= nil then
		v1940.user_id = t242.user_id
	end

	if t242.userId ~= nil then
		v1940.user_id = t242.userId
	end

	if t242.cards ~= nil then
		local t243 = {}

		for _, v1943 in t242.cards do
			table.insert(t243, t1.CardContainerCardInputData.jsonDecode(v1943))
		end

		v1940.cards = t243
	end

	if t242.prompt_id ~= nil then
		v1940.prompt_id = t242.prompt_id
	end

	if t242.promptId ~= nil then
		v1940.prompt_id = t242.promptId
	end

	if t242.prompt_type ~= nil then
		v1940.prompt_type = t242.prompt_type
	end

	if t242.promptType ~= nil then
		v1940.prompt_type = t242.promptType
	end

	return v1940
end

t238.descriptor = {
	name = "CardContainerInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CardContainerInputData"
}
t1.CardContainerInputData = t238
typeRegistry.default:register(t1.CardContainerInputData)

local t244 = {}

t244.__index = t244

function t244.new(t245: {[any]: any}?) -- line: 12473
	-- upvalues: t244 (copy)
	return (setmetatable({
		title = if t245 ~= nil and t245.title ~= nil then t245.title else "",
		user_id = if t245 ~= nil and t245.user_id ~= nil then t245.user_id else "",
		description = if t245 ~= nil and t245.description ~= nil then t245.description else "",
		cta_text = if t245 ~= nil and t245.cta_text ~= nil then t245.cta_text else "",
		prompt_id = if t245 ~= nil and t245.prompt_id ~= nil then t245.prompt_id else "",
		prompt_type = if t245 ~= nil and t245.prompt_type ~= nil then t245.prompt_type else ""
	}, t244))
end
function t244.encode(p148) -- line: 12484
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n98 = 0

	if p148.title ~= nil and p148.title ~= "" then
		local v1948, v1949 = proto.writeTag(buf, n98, 1, proto.wireTypes.lengthDelimited)

		buf, n98 = proto.writeString(v1948, v1949, p148.title)
	end

	if p148.user_id ~= nil and p148.user_id ~= "" then
		local v1950, v1951 = proto.writeTag(buf, n98, 2, proto.wireTypes.lengthDelimited)

		buf, n98 = proto.writeString(v1950, v1951, p148.user_id)
	end

	if p148.description ~= nil and p148.description ~= "" then
		local v1952, v1953 = proto.writeTag(buf, n98, 3, proto.wireTypes.lengthDelimited)

		buf, n98 = proto.writeString(v1952, v1953, p148.description)
	end

	if p148.cta_text ~= nil and p148.cta_text ~= "" then
		local v1954, v1955 = proto.writeTag(buf, n98, 4, proto.wireTypes.lengthDelimited)

		buf, n98 = proto.writeString(v1954, v1955, p148.cta_text)
	end

	if p148.prompt_id ~= nil and p148.prompt_id ~= "" then
		local v1956, v1957 = proto.writeTag(buf, n98, 5, proto.wireTypes.lengthDelimited)

		buf, n98 = proto.writeString(v1956, v1957, p148.prompt_id)
	end

	if p148.prompt_type ~= nil and p148.prompt_type ~= "" then
		local v1958, v1959 = proto.writeTag(buf, n98, 6, proto.wireTypes.lengthDelimited)

		buf, n98 = proto.writeString(v1958, v1959, p148.prompt_type)
	end

	local buf54 = buffer.create(n98)

	buffer.copy(buf54, 0, buf, 0, n98)

	return buf54
end
function t244.decode(p149: buffer) -- line: 12523
	-- upvalues: t244 (copy), proto (copy)
	local v1962 = t244.new()
	local n99 = 0

	while n99 < buffer.len(p149) do
		local v1964, v1965

		v1964, v1965, n99 = proto.readTag(p149, n99)

		if v1965 == proto.wireTypes.varint then
			local v1966

			v1966, n99 = proto.readVarInt(p149, n99)
		elseif v1965 == proto.wireTypes.lengthDelimited then
			if v1964 == 1 then
				local v1967

				v1967, n99 = proto.readBuffer(p149, n99)
				v1962.title = buffer.tostring(v1967)
			elseif v1964 == 2 then
				local v1968

				v1968, n99 = proto.readBuffer(p149, n99)
				v1962.user_id = buffer.tostring(v1968)
			elseif v1964 == 3 then
				local v1969

				v1969, n99 = proto.readBuffer(p149, n99)
				v1962.description = buffer.tostring(v1969)
			elseif v1964 == 4 then
				local v1970

				v1970, n99 = proto.readBuffer(p149, n99)
				v1962.cta_text = buffer.tostring(v1970)
			elseif v1964 == 5 then
				local v1971

				v1971, n99 = proto.readBuffer(p149, n99)
				v1962.prompt_id = buffer.tostring(v1971)
			elseif v1964 == 6 then
				local v1972

				v1972, n99 = proto.readBuffer(p149, n99)
				v1962.prompt_type = buffer.tostring(v1972)
			else
				local v1973, v1974 = proto.readVarInt(p149, n99)

				n99 = v1974 + v1973
			end
		elseif v1965 == proto.wireTypes.i32 then
			local v1975

			v1975, n99 = proto.readFixed32(p149, n99)
		elseif v1965 == proto.wireTypes.i64 then
			local v1976

			v1976, n99 = proto.readFixed64(p149, n99)
		else
			error("Unsupported wire type: " .. v1965)
		end
	end

	return v1962
end
function t244.jsonEncode(p150) -- line: 12591
	local t246 = {}

	if p150.title ~= nil and p150.title ~= "" then
		t246.title = p150.title
	end

	if p150.user_id ~= nil and p150.user_id ~= "" then
		t246.userId = p150.user_id
	end

	if p150.description ~= nil and p150.description ~= "" then
		t246.description = p150.description
	end

	if p150.cta_text ~= nil and p150.cta_text ~= "" then
		t246.ctaText = p150.cta_text
	end

	if p150.prompt_id ~= nil and p150.prompt_id ~= "" then
		t246.promptId = p150.prompt_id
	end

	if p150.prompt_type ~= nil and p150.prompt_type ~= "" then
		t246.promptType = p150.prompt_type
	end

	return t246
end
function t244.jsonDecode(t247: {[any]: any}) -- line: 12621
	-- upvalues: t244 (copy)
	local v1980 = t244.new()

	if t247.title ~= nil then
		v1980.title = t247.title
	end

	if t247.user_id ~= nil then
		v1980.user_id = t247.user_id
	end

	if t247.userId ~= nil then
		v1980.user_id = t247.userId
	end

	if t247.description ~= nil then
		v1980.description = t247.description
	end

	if t247.cta_text ~= nil then
		v1980.cta_text = t247.cta_text
	end

	if t247.ctaText ~= nil then
		v1980.cta_text = t247.ctaText
	end

	if t247.prompt_id ~= nil then
		v1980.prompt_id = t247.prompt_id
	end

	if t247.promptId ~= nil then
		v1980.prompt_id = t247.promptId
	end

	if t247.prompt_type ~= nil then
		v1980.prompt_type = t247.prompt_type
	end

	if t247.promptType ~= nil then
		v1980.prompt_type = t247.promptType
	end

	return v1980
end

t244.descriptor = {
	name = "CardInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CardInputData"
}
t1.CardInputData = t244
typeRegistry.default:register(t1.CardInputData)

local t248 = {}

t248.__index = t248

function t248.new(t249: {[any]: any}?) -- line: 12681
	-- upvalues: t248 (copy)
	return (setmetatable({
		prompt_id = if t249 ~= nil and t249.prompt_id ~= nil then t249.prompt_id else "",
		prompt_type = if t249 ~= nil and t249.prompt_type ~= nil then t249.prompt_type else "",
		user_id = if t249 ~= nil and t249.user_id ~= nil then t249.user_id else "",
		audit_data = if t249 ~= nil and t249.audit_data ~= nil then t249.audit_data else ""
	}, t248))
end
function t248.encode(p151) -- line: 12690
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n100 = 0

	if p151.prompt_id ~= nil and p151.prompt_id ~= "" then
		local v1985, v1986 = proto.writeTag(buf, n100, 1, proto.wireTypes.lengthDelimited)

		buf, n100 = proto.writeString(v1985, v1986, p151.prompt_id)
	end

	if p151.prompt_type ~= nil and p151.prompt_type ~= "" then
		local v1987, v1988 = proto.writeTag(buf, n100, 2, proto.wireTypes.lengthDelimited)

		buf, n100 = proto.writeString(v1987, v1988, p151.prompt_type)
	end

	if p151.user_id ~= nil and p151.user_id ~= "" then
		local v1989, v1990 = proto.writeTag(buf, n100, 3, proto.wireTypes.lengthDelimited)

		buf, n100 = proto.writeString(v1989, v1990, p151.user_id)
	end

	if p151.audit_data ~= nil and p151.audit_data ~= "" then
		local v1991, v1992 = proto.writeTag(buf, n100, 4, proto.wireTypes.lengthDelimited)

		buf, n100 = proto.writeString(v1991, v1992, p151.audit_data)
	end

	local buf55 = buffer.create(n100)

	buffer.copy(buf55, 0, buf, 0, n100)

	return buf55
end
function t248.decode(p152: buffer) -- line: 12719
	-- upvalues: t248 (copy), proto (copy)
	local v1995 = t248.new()
	local n101 = 0

	while n101 < buffer.len(p152) do
		local v1997, v1998

		v1997, v1998, n101 = proto.readTag(p152, n101)

		if v1998 == proto.wireTypes.varint then
			local v1999

			v1999, n101 = proto.readVarInt(p152, n101)
		elseif v1998 == proto.wireTypes.lengthDelimited then
			if v1997 == 1 then
				local v2000

				v2000, n101 = proto.readBuffer(p152, n101)
				v1995.prompt_id = buffer.tostring(v2000)
			elseif v1997 == 2 then
				local v2001

				v2001, n101 = proto.readBuffer(p152, n101)
				v1995.prompt_type = buffer.tostring(v2001)
			elseif v1997 == 3 then
				local v2002

				v2002, n101 = proto.readBuffer(p152, n101)
				v1995.user_id = buffer.tostring(v2002)
			elseif v1997 == 4 then
				local v2003

				v2003, n101 = proto.readBuffer(p152, n101)
				v1995.audit_data = buffer.tostring(v2003)
			else
				local v2004, v2005 = proto.readVarInt(p152, n101)

				n101 = v2005 + v2004
			end
		elseif v1998 == proto.wireTypes.i32 then
			local v2006

			v2006, n101 = proto.readFixed32(p152, n101)
		elseif v1998 == proto.wireTypes.i64 then
			local v2007

			v2007, n101 = proto.readFixed64(p152, n101)
		else
			error("Unsupported wire type: " .. v1998)
		end
	end

	return v1995
end
function t248.jsonEncode(p153) -- line: 12777
	local t250 = {}

	if p153.prompt_id ~= nil and p153.prompt_id ~= "" then
		t250.promptId = p153.prompt_id
	end

	if p153.prompt_type ~= nil and p153.prompt_type ~= "" then
		t250.promptType = p153.prompt_type
	end

	if p153.user_id ~= nil and p153.user_id ~= "" then
		t250.userId = p153.user_id
	end

	if p153.audit_data ~= nil and p153.audit_data ~= "" then
		t250.auditData = p153.audit_data
	end

	return t250
end
function t248.jsonDecode(t251: {[any]: any}) -- line: 12799
	-- upvalues: t248 (copy)
	local v2011 = t248.new()

	if t251.prompt_id ~= nil then
		v2011.prompt_id = t251.prompt_id
	end

	if t251.promptId ~= nil then
		v2011.prompt_id = t251.promptId
	end

	if t251.prompt_type ~= nil then
		v2011.prompt_type = t251.prompt_type
	end

	if t251.promptType ~= nil then
		v2011.prompt_type = t251.promptType
	end

	if t251.user_id ~= nil then
		v2011.user_id = t251.user_id
	end

	if t251.userId ~= nil then
		v2011.user_id = t251.userId
	end

	if t251.audit_data ~= nil then
		v2011.audit_data = t251.audit_data
	end

	if t251.auditData ~= nil then
		v2011.audit_data = t251.auditData
	end

	return v2011
end

t248.descriptor = {
	name = "DialogInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.DialogInputData"
}
t1.DialogInputData = t248
typeRegistry.default:register(t1.DialogInputData)

local t252 = {}

t252.__index = t252

function t252.new(t253: {[any]: any}?) -- line: 12851
	-- upvalues: t252 (copy)
	return (setmetatable({
		title = if t253 ~= nil and t253.title ~= nil then t253.title else "",
		description = if t253 ~= nil and t253.description ~= nil then t253.description else "",
		primary_text = if t253 ~= nil and t253.primary_text ~= nil then t253.primary_text else "",
		secondary_text = if t253 ~= nil and t253.secondary_text ~= nil then t253.secondary_text else "",
		prompt_id = if t253 ~= nil and t253.prompt_id ~= nil then t253.prompt_id else "",
		prompt_type = if t253 ~= nil and t253.prompt_type ~= nil then t253.prompt_type else "",
		times_seen = if t253 ~= nil and t253.times_seen ~= nil then t253.times_seen else 0
	}, t252))
end
function t252.encode(p154) -- line: 12863
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n102 = 0

	if p154.title ~= nil and p154.title ~= "" then
		local v2016, v2017 = proto.writeTag(buf, n102, 1, proto.wireTypes.lengthDelimited)

		buf, n102 = proto.writeString(v2016, v2017, p154.title)
	end

	if p154.description ~= nil and p154.description ~= "" then
		local v2018, v2019 = proto.writeTag(buf, n102, 2, proto.wireTypes.lengthDelimited)

		buf, n102 = proto.writeString(v2018, v2019, p154.description)
	end

	if p154.primary_text ~= nil and p154.primary_text ~= "" then
		local v2020, v2021 = proto.writeTag(buf, n102, 3, proto.wireTypes.lengthDelimited)

		buf, n102 = proto.writeString(v2020, v2021, p154.primary_text)
	end

	if p154.secondary_text ~= nil and p154.secondary_text ~= "" then
		local v2022, v2023 = proto.writeTag(buf, n102, 4, proto.wireTypes.lengthDelimited)

		buf, n102 = proto.writeString(v2022, v2023, p154.secondary_text)
	end

	if p154.prompt_id ~= nil and p154.prompt_id ~= "" then
		local v2024, v2025 = proto.writeTag(buf, n102, 5, proto.wireTypes.lengthDelimited)

		buf, n102 = proto.writeString(v2024, v2025, p154.prompt_id)
	end

	if p154.prompt_type ~= nil and p154.prompt_type ~= "" then
		local v2026, v2027 = proto.writeTag(buf, n102, 6, proto.wireTypes.lengthDelimited)

		buf, n102 = proto.writeString(v2026, v2027, p154.prompt_type)
	end

	if p154.times_seen ~= nil and p154.times_seen ~= 0 then
		local v2028, v2029 = proto.writeTag(buf, n102, 7, proto.wireTypes.varint)

		buf, n102 = proto.writeVarInt(v2028, v2029, p154.times_seen)
	end

	local buf56 = buffer.create(n102)

	buffer.copy(buf56, 0, buf, 0, n102)

	return buf56
end
function t252.decode(p155: buffer) -- line: 12907
	-- upvalues: t252 (copy), proto (copy)
	local v2032 = t252.new()
	local n103 = 0

	while n103 < buffer.len(p155) do
		local v2034, v2035

		v2034, v2035, n103 = proto.readTag(p155, n103)

		if v2035 == proto.wireTypes.varint then
			if v2034 == 7 then
				local v2036

				v2036, n103 = proto.readVarIntI32(p155, n103)
				v2032.times_seen = v2036
			else
				local v2037

				v2037, n103 = proto.readVarInt(p155, n103)
			end
		elseif v2035 == proto.wireTypes.lengthDelimited then
			if v2034 == 1 then
				local v2038

				v2038, n103 = proto.readBuffer(p155, n103)
				v2032.title = buffer.tostring(v2038)
			elseif v2034 == 2 then
				local v2039

				v2039, n103 = proto.readBuffer(p155, n103)
				v2032.description = buffer.tostring(v2039)
			elseif v2034 == 3 then
				local v2040

				v2040, n103 = proto.readBuffer(p155, n103)
				v2032.primary_text = buffer.tostring(v2040)
			elseif v2034 == 4 then
				local v2041

				v2041, n103 = proto.readBuffer(p155, n103)
				v2032.secondary_text = buffer.tostring(v2041)
			elseif v2034 == 5 then
				local v2042

				v2042, n103 = proto.readBuffer(p155, n103)
				v2032.prompt_id = buffer.tostring(v2042)
			elseif v2034 == 6 then
				local v2043

				v2043, n103 = proto.readBuffer(p155, n103)
				v2032.prompt_type = buffer.tostring(v2043)
			else
				local v2044, v2045 = proto.readVarInt(p155, n103)

				n103 = v2045 + v2044
			end
		elseif v2035 == proto.wireTypes.i32 then
			local v2046

			v2046, n103 = proto.readFixed32(p155, n103)
		elseif v2035 == proto.wireTypes.i64 then
			local v2047

			v2047, n103 = proto.readFixed64(p155, n103)
		else
			error("Unsupported wire type: " .. v2035)
		end
	end

	return v2032
end
function t252.jsonEncode(p156) -- line: 12980
	local t254 = {}

	if p156.title ~= nil and p156.title ~= "" then
		t254.title = p156.title
	end

	if p156.description ~= nil and p156.description ~= "" then
		t254.description = p156.description
	end

	if p156.primary_text ~= nil and p156.primary_text ~= "" then
		t254.primaryText = p156.primary_text
	end

	if p156.secondary_text ~= nil and p156.secondary_text ~= "" then
		t254.secondaryText = p156.secondary_text
	end

	if p156.prompt_id ~= nil and p156.prompt_id ~= "" then
		t254.promptId = p156.prompt_id
	end

	if p156.prompt_type ~= nil and p156.prompt_type ~= "" then
		t254.promptType = p156.prompt_type
	end

	if p156.times_seen ~= nil and p156.times_seen ~= 0 then
		t254.timesSeen = p156.times_seen
	end

	return t254
end
function t252.jsonDecode(t255: {[any]: any}) -- line: 13014
	-- upvalues: t252 (copy)
	local v2051 = t252.new()

	if t255.title ~= nil then
		v2051.title = t255.title
	end

	if t255.description ~= nil then
		v2051.description = t255.description
	end

	if t255.primary_text ~= nil then
		v2051.primary_text = t255.primary_text
	end

	if t255.primaryText ~= nil then
		v2051.primary_text = t255.primaryText
	end

	if t255.secondary_text ~= nil then
		v2051.secondary_text = t255.secondary_text
	end

	if t255.secondaryText ~= nil then
		v2051.secondary_text = t255.secondaryText
	end

	if t255.prompt_id ~= nil then
		v2051.prompt_id = t255.prompt_id
	end

	if t255.promptId ~= nil then
		v2051.prompt_id = t255.promptId
	end

	if t255.prompt_type ~= nil then
		v2051.prompt_type = t255.prompt_type
	end

	if t255.promptType ~= nil then
		v2051.prompt_type = t255.promptType
	end

	if t255.times_seen ~= nil then
		v2051.times_seen = t255.times_seen
	end

	if t255.timesSeen ~= nil then
		v2051.times_seen = t255.timesSeen
	end

	return v2051
end

t252.descriptor = {
	name = "BannerInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.BannerInputData"
}
t1.BannerInputData = t252
typeRegistry.default:register(t1.BannerInputData)

local t256 = {}

t256.__index = t256

function t256.new(t257: {[any]: any}?) -- line: 13082
	-- upvalues: t256 (copy)
	return (setmetatable({
		tooltip_text = if t257 ~= nil and t257.tooltip_text ~= nil then t257.tooltip_text else "",
		prompt_id = if t257 ~= nil and t257.prompt_id ~= nil then t257.prompt_id else "",
		prompt_type = if t257 ~= nil and t257.prompt_type ~= nil then t257.prompt_type else ""
	}, t256))
end
function t256.encode(p157) -- line: 13090
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n104 = 0

	if p157.tooltip_text ~= nil and p157.tooltip_text ~= "" then
		local v2056, v2057 = proto.writeTag(buf, n104, 1, proto.wireTypes.lengthDelimited)

		buf, n104 = proto.writeString(v2056, v2057, p157.tooltip_text)
	end

	if p157.prompt_id ~= nil and p157.prompt_id ~= "" then
		local v2058, v2059 = proto.writeTag(buf, n104, 2, proto.wireTypes.lengthDelimited)

		buf, n104 = proto.writeString(v2058, v2059, p157.prompt_id)
	end

	if p157.prompt_type ~= nil and p157.prompt_type ~= "" then
		local v2060, v2061 = proto.writeTag(buf, n104, 3, proto.wireTypes.lengthDelimited)

		buf, n104 = proto.writeString(v2060, v2061, p157.prompt_type)
	end

	local buf57 = buffer.create(n104)

	buffer.copy(buf57, 0, buf, 0, n104)

	return buf57
end
function t256.decode(p158: buffer) -- line: 13114
	-- upvalues: t256 (copy), proto (copy)
	local v2064 = t256.new()
	local n105 = 0

	while n105 < buffer.len(p158) do
		local v2066, v2067

		v2066, v2067, n105 = proto.readTag(p158, n105)

		if v2067 == proto.wireTypes.varint then
			local v2068

			v2068, n105 = proto.readVarInt(p158, n105)
		elseif v2067 == proto.wireTypes.lengthDelimited then
			if v2066 == 1 then
				local v2069

				v2069, n105 = proto.readBuffer(p158, n105)
				v2064.tooltip_text = buffer.tostring(v2069)
			elseif v2066 == 2 then
				local v2070

				v2070, n105 = proto.readBuffer(p158, n105)
				v2064.prompt_id = buffer.tostring(v2070)
			elseif v2066 == 3 then
				local v2071

				v2071, n105 = proto.readBuffer(p158, n105)
				v2064.prompt_type = buffer.tostring(v2071)
			else
				local v2072, v2073 = proto.readVarInt(p158, n105)

				n105 = v2073 + v2072
			end
		elseif v2067 == proto.wireTypes.i32 then
			local v2074

			v2074, n105 = proto.readFixed32(p158, n105)
		elseif v2067 == proto.wireTypes.i64 then
			local v2075

			v2075, n105 = proto.readFixed64(p158, n105)
		else
			error("Unsupported wire type: " .. v2067)
		end
	end

	return v2064
end
function t256.jsonEncode(p159) -- line: 13167
	local t258 = {}

	if p159.tooltip_text ~= nil and p159.tooltip_text ~= "" then
		t258.tooltipText = p159.tooltip_text
	end

	if p159.prompt_id ~= nil and p159.prompt_id ~= "" then
		t258.promptId = p159.prompt_id
	end

	if p159.prompt_type ~= nil and p159.prompt_type ~= "" then
		t258.promptType = p159.prompt_type
	end

	return t258
end
function t256.jsonDecode(t259: {[any]: any}) -- line: 13185
	-- upvalues: t256 (copy)
	local v2079 = t256.new()

	if t259.tooltip_text ~= nil then
		v2079.tooltip_text = t259.tooltip_text
	end

	if t259.tooltipText ~= nil then
		v2079.tooltip_text = t259.tooltipText
	end

	if t259.prompt_id ~= nil then
		v2079.prompt_id = t259.prompt_id
	end

	if t259.promptId ~= nil then
		v2079.prompt_id = t259.promptId
	end

	if t259.prompt_type ~= nil then
		v2079.prompt_type = t259.prompt_type
	end

	if t259.promptType ~= nil then
		v2079.prompt_type = t259.promptType
	end

	return v2079
end

t256.descriptor = {
	name = "TooltipInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.TooltipInputData"
}
t1.TooltipInputData = t256
typeRegistry.default:register(t1.TooltipInputData)

local t260 = {}

t260.__index = t260

function t260.new(t261: {[any]: any}?) -- line: 13229
	-- upvalues: t260 (copy)
	return (setmetatable({
		media_id = if t261 ~= nil and t261.media_id ~= nil then t261.media_id else "",
		title = if t261 ~= nil and t261.title ~= nil then t261.title else "",
		description = if t261 ~= nil and t261.description ~= nil then t261.description else "",
		prompt_id = if t261 ~= nil and t261.prompt_id ~= nil then t261.prompt_id else "",
		prompt_type = if t261 ~= nil and t261.prompt_type ~= nil then t261.prompt_type else "",
		anchor_tag = if t261 ~= nil and t261.anchor_tag ~= nil then t261.anchor_tag else ""
	}, t260))
end
function t260.encode(p160) -- line: 13240
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n106 = 0

	if p160.media_id ~= nil and p160.media_id ~= "" then
		local v2084, v2085 = proto.writeTag(buf, n106, 1, proto.wireTypes.lengthDelimited)

		buf, n106 = proto.writeString(v2084, v2085, p160.media_id)
	end

	if p160.title ~= nil and p160.title ~= "" then
		local v2086, v2087 = proto.writeTag(buf, n106, 2, proto.wireTypes.lengthDelimited)

		buf, n106 = proto.writeString(v2086, v2087, p160.title)
	end

	if p160.description ~= nil and p160.description ~= "" then
		local v2088, v2089 = proto.writeTag(buf, n106, 3, proto.wireTypes.lengthDelimited)

		buf, n106 = proto.writeString(v2088, v2089, p160.description)
	end

	if p160.prompt_id ~= nil and p160.prompt_id ~= "" then
		local v2090, v2091 = proto.writeTag(buf, n106, 4, proto.wireTypes.lengthDelimited)

		buf, n106 = proto.writeString(v2090, v2091, p160.prompt_id)
	end

	if p160.prompt_type ~= nil and p160.prompt_type ~= "" then
		local v2092, v2093 = proto.writeTag(buf, n106, 5, proto.wireTypes.lengthDelimited)

		buf, n106 = proto.writeString(v2092, v2093, p160.prompt_type)
	end

	if p160.anchor_tag ~= nil and p160.anchor_tag ~= "" then
		local v2094, v2095 = proto.writeTag(buf, n106, 6, proto.wireTypes.lengthDelimited)

		buf, n106 = proto.writeString(v2094, v2095, p160.anchor_tag)
	end

	local buf58 = buffer.create(n106)

	buffer.copy(buf58, 0, buf, 0, n106)

	return buf58
end
function t260.decode(p161: buffer) -- line: 13279
	-- upvalues: t260 (copy), proto (copy)
	local v2098 = t260.new()
	local n107 = 0

	while n107 < buffer.len(p161) do
		local v2100, v2101

		v2100, v2101, n107 = proto.readTag(p161, n107)

		if v2101 == proto.wireTypes.varint then
			local v2102

			v2102, n107 = proto.readVarInt(p161, n107)
		elseif v2101 == proto.wireTypes.lengthDelimited then
			if v2100 == 1 then
				local v2103

				v2103, n107 = proto.readBuffer(p161, n107)
				v2098.media_id = buffer.tostring(v2103)
			elseif v2100 == 2 then
				local v2104

				v2104, n107 = proto.readBuffer(p161, n107)
				v2098.title = buffer.tostring(v2104)
			elseif v2100 == 3 then
				local v2105

				v2105, n107 = proto.readBuffer(p161, n107)
				v2098.description = buffer.tostring(v2105)
			elseif v2100 == 4 then
				local v2106

				v2106, n107 = proto.readBuffer(p161, n107)
				v2098.prompt_id = buffer.tostring(v2106)
			elseif v2100 == 5 then
				local v2107

				v2107, n107 = proto.readBuffer(p161, n107)
				v2098.prompt_type = buffer.tostring(v2107)
			elseif v2100 == 6 then
				local v2108

				v2108, n107 = proto.readBuffer(p161, n107)
				v2098.anchor_tag = buffer.tostring(v2108)
			else
				local v2109, v2110 = proto.readVarInt(p161, n107)

				n107 = v2110 + v2109
			end
		elseif v2101 == proto.wireTypes.i32 then
			local v2111

			v2111, n107 = proto.readFixed32(p161, n107)
		elseif v2101 == proto.wireTypes.i64 then
			local v2112

			v2112, n107 = proto.readFixed64(p161, n107)
		else
			error("Unsupported wire type: " .. v2101)
		end
	end

	return v2098
end
function t260.jsonEncode(p162) -- line: 13347
	local t262 = {}

	if p162.media_id ~= nil and p162.media_id ~= "" then
		t262.mediaId = p162.media_id
	end

	if p162.title ~= nil and p162.title ~= "" then
		t262.title = p162.title
	end

	if p162.description ~= nil and p162.description ~= "" then
		t262.description = p162.description
	end

	if p162.prompt_id ~= nil and p162.prompt_id ~= "" then
		t262.promptId = p162.prompt_id
	end

	if p162.prompt_type ~= nil and p162.prompt_type ~= "" then
		t262.promptType = p162.prompt_type
	end

	if p162.anchor_tag ~= nil and p162.anchor_tag ~= "" then
		t262.anchorTag = p162.anchor_tag
	end

	return t262
end
function t260.jsonDecode(t263: {[any]: any}) -- line: 13377
	-- upvalues: t260 (copy)
	local v2116 = t260.new()

	if t263.media_id ~= nil then
		v2116.media_id = t263.media_id
	end

	if t263.mediaId ~= nil then
		v2116.media_id = t263.mediaId
	end

	if t263.title ~= nil then
		v2116.title = t263.title
	end

	if t263.description ~= nil then
		v2116.description = t263.description
	end

	if t263.prompt_id ~= nil then
		v2116.prompt_id = t263.prompt_id
	end

	if t263.promptId ~= nil then
		v2116.prompt_id = t263.promptId
	end

	if t263.prompt_type ~= nil then
		v2116.prompt_type = t263.prompt_type
	end

	if t263.promptType ~= nil then
		v2116.prompt_type = t263.promptType
	end

	if t263.anchor_tag ~= nil then
		v2116.anchor_tag = t263.anchor_tag
	end

	if t263.anchorTag ~= nil then
		v2116.anchor_tag = t263.anchorTag
	end

	return v2116
end

t260.descriptor = {
	name = "CoachmarkInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CoachmarkInputData"
}
t1.CoachmarkInputData = t260
typeRegistry.default:register(t1.CoachmarkInputData)

local t264 = {}

t264.__index = t264

function t264.new(t265: {[any]: any}?) -- line: 13437
	-- upvalues: t264 (copy)
	return (setmetatable({
		prompt_id = if t265 ~= nil and t265.prompt_id ~= nil then t265.prompt_id else "",
		prompt_type = if t265 ~= nil and t265.prompt_type ~= nil then t265.prompt_type else ""
	}, t264))
end
function t264.encode(p163) -- line: 13444
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n108 = 0

	if p163.prompt_id ~= nil and p163.prompt_id ~= "" then
		local v2121, v2122 = proto.writeTag(buf, n108, 1, proto.wireTypes.lengthDelimited)

		buf, n108 = proto.writeString(v2121, v2122, p163.prompt_id)
	end

	if p163.prompt_type ~= nil and p163.prompt_type ~= "" then
		local v2123, v2124 = proto.writeTag(buf, n108, 2, proto.wireTypes.lengthDelimited)

		buf, n108 = proto.writeString(v2123, v2124, p163.prompt_type)
	end

	local buf59 = buffer.create(n108)

	buffer.copy(buf59, 0, buf, 0, n108)

	return buf59
end
function t264.decode(p164: buffer) -- line: 13463
	-- upvalues: t264 (copy), proto (copy)
	local v2127 = t264.new()
	local n109 = 0

	while n109 < buffer.len(p164) do
		local v2129, v2130

		v2129, v2130, n109 = proto.readTag(p164, n109)

		if v2130 == proto.wireTypes.varint then
			local v2131

			v2131, n109 = proto.readVarInt(p164, n109)
		elseif v2130 == proto.wireTypes.lengthDelimited then
			if v2129 == 1 then
				local v2132

				v2132, n109 = proto.readBuffer(p164, n109)
				v2127.prompt_id = buffer.tostring(v2132)
			elseif v2129 == 2 then
				local v2133

				v2133, n109 = proto.readBuffer(p164, n109)
				v2127.prompt_type = buffer.tostring(v2133)
			else
				local v2134, v2135 = proto.readVarInt(p164, n109)

				n109 = v2135 + v2134
			end
		elseif v2130 == proto.wireTypes.i32 then
			local v2136

			v2136, n109 = proto.readFixed32(p164, n109)
		elseif v2130 == proto.wireTypes.i64 then
			local v2137

			v2137, n109 = proto.readFixed64(p164, n109)
		else
			error("Unsupported wire type: " .. v2130)
		end
	end

	return v2127
end
function t264.jsonEncode(p165) -- line: 13511
	local t266 = {}

	if p165.prompt_id ~= nil and p165.prompt_id ~= "" then
		t266.promptId = p165.prompt_id
	end

	if p165.prompt_type ~= nil and p165.prompt_type ~= "" then
		t266.promptType = p165.prompt_type
	end

	return t266
end
function t264.jsonDecode(t267: {[any]: any}) -- line: 13525
	-- upvalues: t264 (copy)
	local v2141 = t264.new()

	if t267.prompt_id ~= nil then
		v2141.prompt_id = t267.prompt_id
	end

	if t267.promptId ~= nil then
		v2141.prompt_id = t267.promptId
	end

	if t267.prompt_type ~= nil then
		v2141.prompt_type = t267.prompt_type
	end

	if t267.promptType ~= nil then
		v2141.prompt_type = t267.promptType
	end

	return v2141
end

t264.descriptor = {
	name = "SystemBannerInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.SystemBannerInputData"
}
t1.SystemBannerInputData = t264
typeRegistry.default:register(t1.SystemBannerInputData)

local t268 = {}

t268.__index = t268

function t268.new(t269: {[any]: any}?) -- line: 13561
	-- upvalues: t268 (copy)
	return (setmetatable({
		upsell_prompt = if t269 ~= nil and t269.upsell_prompt ~= nil then t269.upsell_prompt else ""
	}, t268))
end
function t268.encode(p166) -- line: 13567
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n110 = 0

	if p166.upsell_prompt ~= nil and p166.upsell_prompt ~= "" then
		local v2146, v2147 = proto.writeTag(buf, n110, 1, proto.wireTypes.lengthDelimited)

		buf, n110 = proto.writeString(v2146, v2147, p166.upsell_prompt)
	end

	local buf60 = buffer.create(n110)

	buffer.copy(buf60, 0, buf, 0, n110)

	return buf60
end
function t268.decode(p167: buffer) -- line: 13581
	-- upvalues: t268 (copy), proto (copy)
	local v2150 = t268.new()
	local n111 = 0

	while n111 < buffer.len(p167) do
		local v2152, v2153

		v2152, v2153, n111 = proto.readTag(p167, n111)

		if v2153 == proto.wireTypes.varint then
			local v2154

			v2154, n111 = proto.readVarInt(p167, n111)
		elseif v2153 == proto.wireTypes.lengthDelimited then
			if v2152 == 1 then
				local v2155

				v2155, n111 = proto.readBuffer(p167, n111)
				v2150.upsell_prompt = buffer.tostring(v2155)
			else
				local v2156, v2157 = proto.readVarInt(p167, n111)

				n111 = v2157 + v2156
			end
		elseif v2153 == proto.wireTypes.i32 then
			local v2158

			v2158, n111 = proto.readFixed32(p167, n111)
		elseif v2153 == proto.wireTypes.i64 then
			local v2159

			v2159, n111 = proto.readFixed64(p167, n111)
		else
			error("Unsupported wire type: " .. v2153)
		end
	end

	return v2150
end
function t268.jsonEncode(p168) -- line: 13624
	local t270 = {}

	if p168.upsell_prompt ~= nil and p168.upsell_prompt ~= "" then
		t270.upsellPrompt = p168.upsell_prompt
	end

	return t270
end
function t268.jsonDecode(t271: {[any]: any}) -- line: 13634
	-- upvalues: t268 (copy)
	local v2163 = t268.new()

	if t271.upsell_prompt ~= nil then
		v2163.upsell_prompt = t271.upsell_prompt
	end

	if t271.upsellPrompt ~= nil then
		v2163.upsell_prompt = t271.upsellPrompt
	end

	return v2163
end

t268.descriptor = {
	name = "AgeCheckUpsellInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.AgeCheckUpsellInputData"
}
t1.AgeCheckUpsellInputData = t268
typeRegistry.default:register(t1.AgeCheckUpsellInputData)

local t272 = {}

t272.__index = t272

function t272.new(t273: {[any]: any}?) -- line: 13662
	-- upvalues: t272 (copy)
	return (setmetatable({
		modal_variant = if t273 ~= nil and t273.modal_variant ~= nil then t273.modal_variant else "",
		modal_sequence = if t273 ~= nil and t273.modal_sequence ~= nil then t273.modal_sequence else "",
		conversation_id = if t273 ~= nil and t273.conversation_id ~= nil then t273.conversation_id else "",
		friend_id = if t273 ~= nil and t273.friend_id ~= nil then t273.friend_id else ""
	}, t272))
end
function t272.encode(p169) -- line: 13673
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n112 = 0

	if p169.modal_variant ~= nil and p169.modal_variant ~= "" then
		local v2168, v2169 = proto.writeTag(buf, n112, 1, proto.wireTypes.lengthDelimited)

		buf, n112 = proto.writeString(v2168, v2169, p169.modal_variant)
	end

	if p169.modal_sequence ~= nil and p169.modal_sequence ~= "" then
		local v2170, v2171 = proto.writeTag(buf, n112, 2, proto.wireTypes.lengthDelimited)

		buf, n112 = proto.writeString(v2170, v2171, p169.modal_sequence)
	end

	if p169.conversation_id ~= nil and p169.conversation_id ~= "" then
		local v2172, v2173 = proto.writeTag(buf, n112, 3, proto.wireTypes.lengthDelimited)

		buf, n112 = proto.writeString(v2172, v2173, p169.conversation_id)
	end

	if p169.friend_id ~= nil and p169.friend_id ~= "" then
		local v2174, v2175 = proto.writeTag(buf, n112, 4, proto.wireTypes.lengthDelimited)

		buf, n112 = proto.writeString(v2174, v2175, p169.friend_id)
	end

	local buf61 = buffer.create(n112)

	buffer.copy(buf61, 0, buf, 0, n112)

	return buf61
end
function t272.decode(p170: buffer) -- line: 13702
	-- upvalues: t272 (copy), proto (copy)
	local v2178 = t272.new()
	local n113 = 0

	while n113 < buffer.len(p170) do
		local v2180, v2181

		v2180, v2181, n113 = proto.readTag(p170, n113)

		if v2181 == proto.wireTypes.varint then
			local v2182

			v2182, n113 = proto.readVarInt(p170, n113)
		elseif v2181 == proto.wireTypes.lengthDelimited then
			if v2180 == 1 then
				local v2183

				v2183, n113 = proto.readBuffer(p170, n113)
				v2178.modal_variant = buffer.tostring(v2183)
			elseif v2180 == 2 then
				local v2184

				v2184, n113 = proto.readBuffer(p170, n113)
				v2178.modal_sequence = buffer.tostring(v2184)
			elseif v2180 == 3 then
				local v2185

				v2185, n113 = proto.readBuffer(p170, n113)
				v2178.conversation_id = buffer.tostring(v2185)
			elseif v2180 == 4 then
				local v2186

				v2186, n113 = proto.readBuffer(p170, n113)
				v2178.friend_id = buffer.tostring(v2186)
			else
				local v2187, v2188 = proto.readVarInt(p170, n113)

				n113 = v2188 + v2187
			end
		elseif v2181 == proto.wireTypes.i32 then
			local v2189

			v2189, n113 = proto.readFixed32(p170, n113)
		elseif v2181 == proto.wireTypes.i64 then
			local v2190

			v2190, n113 = proto.readFixed64(p170, n113)
		else
			error("Unsupported wire type: " .. v2181)
		end
	end

	return v2178
end
function t272.jsonEncode(p171) -- line: 13760
	local t274 = {}

	if p171.modal_variant ~= nil and p171.modal_variant ~= "" then
		t274.modalVariant = p171.modal_variant
	end

	if p171.modal_sequence ~= nil and p171.modal_sequence ~= "" then
		t274.modalSequence = p171.modal_sequence
	end

	if p171.conversation_id ~= nil and p171.conversation_id ~= "" then
		t274.conversationId = p171.conversation_id
	end

	if p171.friend_id ~= nil and p171.friend_id ~= "" then
		t274.friendId = p171.friend_id
	end

	return t274
end
function t272.jsonDecode(t275: {[any]: any}) -- line: 13782
	-- upvalues: t272 (copy)
	local v2194 = t272.new()

	if t275.modal_variant ~= nil then
		v2194.modal_variant = t275.modal_variant
	end

	if t275.modalVariant ~= nil then
		v2194.modal_variant = t275.modalVariant
	end

	if t275.modal_sequence ~= nil then
		v2194.modal_sequence = t275.modal_sequence
	end

	if t275.modalSequence ~= nil then
		v2194.modal_sequence = t275.modalSequence
	end

	if t275.conversation_id ~= nil then
		v2194.conversation_id = t275.conversation_id
	end

	if t275.conversationId ~= nil then
		v2194.conversation_id = t275.conversationId
	end

	if t275.friend_id ~= nil then
		v2194.friend_id = t275.friend_id
	end

	if t275.friendId ~= nil then
		v2194.friend_id = t275.friendId
	end

	return v2194
end

t272.descriptor = {
	name = "PartyChatConversationUpsellInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.PartyChatConversationUpsellInputData"
}
t1.PartyChatConversationUpsellInputData = t272
typeRegistry.default:register(t1.PartyChatConversationUpsellInputData)

local t276 = {}

t276.__index = t276

function t276.new(t277: {[any]: any}?) -- line: 13836
	-- upvalues: t276 (copy)
	return (setmetatable({
		event_id = if t277 ~= nil and t277.event_id ~= nil then t277.event_id else "",
		universe_id = if t277 ~= nil and t277.universe_id ~= nil then t277.universe_id else "",
		entry_map = if t277 ~= nil and t277.entry_map ~= nil then t277.entry_map else {},
		entry_order = if t277 ~= nil and t277.entry_order ~= nil then t277.entry_order else {}
	}, t276))
end
function t276.encode(p172) -- line: 13847
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n114 = 0

	if p172.event_id ~= nil and p172.event_id ~= "" then
		local v2199, v2200 = proto.writeTag(buf, n114, 1, proto.wireTypes.lengthDelimited)

		buf, n114 = proto.writeString(v2199, v2200, p172.event_id)
	end

	if p172.universe_id ~= nil and p172.universe_id ~= "" then
		local v2201, v2202 = proto.writeTag(buf, n114, 2, proto.wireTypes.lengthDelimited)

		buf, n114 = proto.writeString(v2201, v2202, p172.universe_id)
	end

	if p172.entry_map ~= nil and next(p172.entry_map) ~= nil then
		for v2203, v2204 in p172.entry_map do
			local buf62 = buffer.create(0)
			local v2206, v2207 = proto.writeTag(buf62, 0, 1, proto.wireTypes.lengthDelimited)
			local v2208, v2209 = proto.writeString(v2206, v2207, v2203)
			local v2210 = v2204:encode()
			local v2211, v2212 = proto.writeTag(v2208, v2209, 2, proto.wireTypes.lengthDelimited)
			local v2213, v2214 = proto.writeBuffer(v2211, v2212, v2210, buffer.len(v2210))
			local v2215, v2216 = proto.writeTag(buf, n114, 3, proto.wireTypes.lengthDelimited)

			buf, n114 = proto.writeBuffer(v2215, v2216, v2213, v2214)
		end
	end

	if p172.entry_order ~= nil and #p172.entry_order > 0 then
		for _, v2218 in p172.entry_order do
			local v2219, v2220 = proto.writeTag(buf, n114, 4, proto.wireTypes.lengthDelimited)

			buf, n114 = proto.writeString(v2219, v2220, v2218)
		end
	end

	local buf63 = buffer.create(n114)

	buffer.copy(buf63, 0, buf, 0, n114)

	return buf63
end
function t276.decode(p173: buffer) -- line: 13887
	-- upvalues: t276 (copy), proto (copy), t1 (copy)
	local v2223 = t276.new()
	local n115 = 0

	while n115 < buffer.len(p173) do
		local v2225, v2226

		v2225, v2226, n115 = proto.readTag(p173, n115)

		if v2226 == proto.wireTypes.varint then
			local v2227

			v2227, n115 = proto.readVarInt(p173, n115)
		elseif v2226 == proto.wireTypes.lengthDelimited then
			if v2225 == 1 then
				local v2228

				v2228, n115 = proto.readBuffer(p173, n115)
				v2223.event_id = buffer.tostring(v2228)
			elseif v2225 == 2 then
				local v2229

				v2229, n115 = proto.readBuffer(p173, n115)
				v2223.universe_id = buffer.tostring(v2229)
			elseif v2225 == 3 then
				local v2230

				v2230, n115 = proto.readBuffer(p173, n115)

				local v2231 = t1.EventDetailsFeedInputData_EntryMapEntry.decode(v2230)
				local v2232 = t1.FeedEntry.new()

				v2223.entry_map[v2231.key or ""] = v2231.value or v2232
			elseif v2225 == 4 then
				local v2233

				v2233, n115 = proto.readBuffer(p173, n115)
				table.insert(v2223.entry_order, buffer.tostring(v2233))
			else
				local v2234, v2235 = proto.readVarInt(p173, n115)

				n115 = v2235 + v2234
			end
		elseif v2226 == proto.wireTypes.i32 then
			local v2236

			v2236, n115 = proto.readFixed32(p173, n115)
		elseif v2226 == proto.wireTypes.i64 then
			local v2237

			v2237, n115 = proto.readFixed64(p173, n115)
		else
			error("Unsupported wire type: " .. v2226)
		end
	end

	return v2223
end
function t276.jsonEncode(p174) -- line: 13952
	local t278 = {}

	if p174.event_id ~= nil and p174.event_id ~= "" then
		t278.eventId = p174.event_id
	end

	if p174.universe_id ~= nil and p174.universe_id ~= "" then
		t278.universeId = p174.universe_id
	end

	if p174.entry_map ~= nil and next(p174.entry_map) ~= nil then
		local t279 = {}

		for v2241, v2242 in p174.entry_map do
			t279[v2241] = v2242:jsonEncode()
		end

		t278.entryMap = t279
	end

	if p174.entry_order ~= nil and #p174.entry_order > 0 then
		local t280 = {}

		for _, v2245 in p174.entry_order do
			table.insert(t280, v2245)
		end

		t278.entryOrder = t280
	end

	return t278
end
function t276.jsonDecode(t281: {[any]: any}) -- line: 13982
	-- upvalues: t276 (copy), t1 (copy)
	local v2247 = t276.new()

	if t281.event_id ~= nil then
		v2247.event_id = t281.event_id
	end

	if t281.eventId ~= nil then
		v2247.event_id = t281.eventId
	end

	if t281.universe_id ~= nil then
		v2247.universe_id = t281.universe_id
	end

	if t281.universeId ~= nil then
		v2247.universe_id = t281.universeId
	end

	if t281.entry_map ~= nil then
		local t282 = {}

		for v2249, v2250 in t281.entry_map do
			t282[v2249] = t1.FeedEntry.jsonDecode(v2250)
		end

		v2247.entry_map = t282
	end

	if t281.entryMap ~= nil then
		local t283 = {}

		for v2252, v2253 in t281.entryMap do
			t283[v2252] = t1.FeedEntry.jsonDecode(v2253)
		end

		v2247.entry_map = t283
	end

	if t281.entry_order ~= nil then
		local t284 = {}

		for _, v2256 in t281.entry_order do
			table.insert(t284, v2256)
		end

		v2247.entry_order = t284
	end

	if t281.entryOrder ~= nil then
		local t285 = {}

		for _, v2259 in t281.entryOrder do
			table.insert(t285, v2259)
		end

		v2247.entry_order = t285
	end

	return v2247
end

t276.descriptor = {
	name = "EventDetailsFeedInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventDetailsFeedInputData"
}
t1.EventDetailsFeedInputData = t276
typeRegistry.default:register(t1.EventDetailsFeedInputData)

local t286 = {}

t286.__index = t286

function t286.new(t287: {[any]: any}?) -- line: 14054
	-- upvalues: t286 (copy)
	return (setmetatable({
		key = if t287 ~= nil and t287.key ~= nil then t287.key else "",
		value = if t287 ~= nil and t287.value ~= nil then t287.value else nil
	}, t286))
end
function t286.encode(p175) -- line: 14063
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n116 = 0

	if p175.key ~= nil and p175.key ~= "" then
		local v2264, v2265 = proto.writeTag(buf, n116, 1, proto.wireTypes.lengthDelimited)

		buf, n116 = proto.writeString(v2264, v2265, p175.key)
	end

	if p175.value ~= nil then
		local v2266 = p175.value:encode()
		local v2267, v2268 = proto.writeTag(buf, n116, 2, proto.wireTypes.lengthDelimited)

		buf, n116 = proto.writeBuffer(v2267, v2268, v2266, buffer.len(v2266))
	end

	local buf64 = buffer.create(n116)

	buffer.copy(buf64, 0, buf, 0, n116)

	return buf64
end
function t286.decode(p176: buffer) -- line: 14083
	-- upvalues: t286 (copy), proto (copy), t1 (copy)
	local v2271 = t286.new()
	local n117 = 0

	while n117 < buffer.len(p176) do
		local v2273, v2274

		v2273, v2274, n117 = proto.readTag(p176, n117)

		if v2274 == proto.wireTypes.varint then
			local v2275

			v2275, n117 = proto.readVarInt(p176, n117)
		elseif v2274 == proto.wireTypes.lengthDelimited then
			if v2273 == 1 then
				local v2276

				v2276, n117 = proto.readBuffer(p176, n117)
				v2271.key = buffer.tostring(v2276)
			elseif v2273 == 2 then
				local v2277

				v2277, n117 = proto.readBuffer(p176, n117)
				v2271.value = t1.FeedEntry.decode(v2277)
			else
				local v2278, v2279 = proto.readVarInt(p176, n117)

				n117 = v2279 + v2278
			end
		elseif v2274 == proto.wireTypes.i32 then
			local v2280

			v2280, n117 = proto.readFixed32(p176, n117)
		elseif v2274 == proto.wireTypes.i64 then
			local v2281

			v2281, n117 = proto.readFixed64(p176, n117)
		else
			error("Unsupported wire type: " .. v2274)
		end
	end

	return v2271
end
function t286.jsonEncode(p177) -- line: 14131
	local t288 = {}

	if p177.key ~= nil and p177.key ~= "" then
		t288.key = p177.key
	end

	if p177.value ~= nil then
		t288.value = p177.value:jsonEncode()
	end

	return t288
end
function t286.jsonDecode(t289: {[any]: any}) -- line: 14145
	-- upvalues: t286 (copy), t1 (copy)
	local v2285 = t286.new()

	if t289.key ~= nil then
		v2285.key = t289.key
	end

	if t289.value ~= nil then
		v2285.value = t1.FeedEntry.jsonDecode(t289.value)
	end

	return v2285
end

t286.descriptor = {
	name = "EventDetailsFeedInputData_EntryMapEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryMapEntry"
}
t1.EventDetailsFeedInputData_EntryMapEntry = t286
typeRegistry.default:register(t1.EventDetailsFeedInputData_EntryMapEntry)

local t290 = {}

t290.__index = t290

function t290.new(t291: {[any]: any}?) -- line: 14175
	-- upvalues: t290 (copy)
	return (setmetatable({
		event_id = if t291 ~= nil and t291.event_id ~= nil then t291.event_id else "",
		universe_id = if t291 ~= nil and t291.universe_id ~= nil then t291.universe_id else ""
	}, t290))
end
function t290.encode(p178) -- line: 14184
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n118 = 0

	if p178.event_id ~= nil and p178.event_id ~= "" then
		local v2290, v2291 = proto.writeTag(buf, n118, 1, proto.wireTypes.lengthDelimited)

		buf, n118 = proto.writeString(v2290, v2291, p178.event_id)
	end

	if p178.universe_id ~= nil and p178.universe_id ~= "" then
		local v2292, v2293 = proto.writeTag(buf, n118, 2, proto.wireTypes.lengthDelimited)

		buf, n118 = proto.writeString(v2292, v2293, p178.universe_id)
	end

	local buf65 = buffer.create(n118)

	buffer.copy(buf65, 0, buf, 0, n118)

	return buf65
end
function t290.decode(p179: buffer) -- line: 14203
	-- upvalues: t290 (copy), proto (copy)
	local v2296 = t290.new()
	local n119 = 0

	while n119 < buffer.len(p179) do
		local v2298, v2299

		v2298, v2299, n119 = proto.readTag(p179, n119)

		if v2299 == proto.wireTypes.varint then
			local v2300

			v2300, n119 = proto.readVarInt(p179, n119)
		elseif v2299 == proto.wireTypes.lengthDelimited then
			if v2298 == 1 then
				local v2301

				v2301, n119 = proto.readBuffer(p179, n119)
				v2296.event_id = buffer.tostring(v2301)
			elseif v2298 == 2 then
				local v2302

				v2302, n119 = proto.readBuffer(p179, n119)
				v2296.universe_id = buffer.tostring(v2302)
			else
				local v2303, v2304 = proto.readVarInt(p179, n119)

				n119 = v2304 + v2303
			end
		elseif v2299 == proto.wireTypes.i32 then
			local v2305

			v2305, n119 = proto.readFixed32(p179, n119)
		elseif v2299 == proto.wireTypes.i64 then
			local v2306

			v2306, n119 = proto.readFixed64(p179, n119)
		else
			error("Unsupported wire type: " .. v2299)
		end
	end

	return v2296
end
function t290.jsonEncode(p180) -- line: 14251
	local t292 = {}

	if p180.event_id ~= nil and p180.event_id ~= "" then
		t292.eventId = p180.event_id
	end

	if p180.universe_id ~= nil and p180.universe_id ~= "" then
		t292.universeId = p180.universe_id
	end

	return t292
end
function t290.jsonDecode(t293: {[any]: any}) -- line: 14265
	-- upvalues: t290 (copy)
	local v2310 = t290.new()

	if t293.event_id ~= nil then
		v2310.event_id = t293.event_id
	end

	if t293.eventId ~= nil then
		v2310.event_id = t293.eventId
	end

	if t293.universe_id ~= nil then
		v2310.universe_id = t293.universe_id
	end

	if t293.universeId ~= nil then
		v2310.universe_id = t293.universeId
	end

	return v2310
end

t290.descriptor = {
	name = "EventDetailsActionBarInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventDetailsActionBarInputData"
}
t1.EventDetailsActionBarInputData = t290
typeRegistry.default:register(t1.EventDetailsActionBarInputData)

local t294 = {}

t294.__index = t294

function t294.new(t295: {[any]: any}?) -- line: 14301
	-- upvalues: t294 (copy)
	return (setmetatable({
		event_id = if t295 ~= nil and t295.event_id ~= nil then t295.event_id else ""
	}, t294))
end
function t294.encode(p181) -- line: 14309
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n120 = 0

	if p181.event_id ~= nil and p181.event_id ~= "" then
		local v2315, v2316 = proto.writeTag(buf, n120, 1, proto.wireTypes.lengthDelimited)

		buf, n120 = proto.writeString(v2315, v2316, p181.event_id)
	end

	local buf66 = buffer.create(n120)

	buffer.copy(buf66, 0, buf, 0, n120)

	return buf66
end
function t294.decode(p182: buffer) -- line: 14323
	-- upvalues: t294 (copy), proto (copy)
	local v2319 = t294.new()
	local n121 = 0

	while n121 < buffer.len(p182) do
		local v2321, v2322

		v2321, v2322, n121 = proto.readTag(p182, n121)

		if v2322 == proto.wireTypes.varint then
			local v2323

			v2323, n121 = proto.readVarInt(p182, n121)
		elseif v2322 == proto.wireTypes.lengthDelimited then
			if v2321 == 1 then
				local v2324

				v2324, n121 = proto.readBuffer(p182, n121)
				v2319.event_id = buffer.tostring(v2324)
			else
				local v2325, v2326 = proto.readVarInt(p182, n121)

				n121 = v2326 + v2325
			end
		elseif v2322 == proto.wireTypes.i32 then
			local v2327

			v2327, n121 = proto.readFixed32(p182, n121)
		elseif v2322 == proto.wireTypes.i64 then
			local v2328

			v2328, n121 = proto.readFixed64(p182, n121)
		else
			error("Unsupported wire type: " .. v2322)
		end
	end

	return v2319
end
function t294.jsonEncode(p183) -- line: 14366
	local t296 = {}

	if p183.event_id ~= nil and p183.event_id ~= "" then
		t296.eventId = p183.event_id
	end

	return t296
end
function t294.jsonDecode(t297: {[any]: any}) -- line: 14376
	-- upvalues: t294 (copy)
	local v2332 = t294.new()

	if t297.event_id ~= nil then
		v2332.event_id = t297.event_id
	end

	if t297.eventId ~= nil then
		v2332.event_id = t297.eventId
	end

	return v2332
end

t294.descriptor = {
	name = "EventDescriptionInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventDescriptionInputData"
}
t1.EventDescriptionInputData = t294
typeRegistry.default:register(t1.EventDescriptionInputData)

local t298 = {}

t298.__index = t298

function t298.new(t299: {[any]: any}?) -- line: 14404
	-- upvalues: t298 (copy)
	return (setmetatable({
		event_id = if t299 ~= nil and t299.event_id ~= nil then t299.event_id else "",
		universe_id = if t299 ~= nil and t299.universe_id ~= nil then t299.universe_id else ""
	}, t298))
end
function t298.encode(p184) -- line: 14413
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n122 = 0

	if p184.event_id ~= nil and p184.event_id ~= "" then
		local v2337, v2338 = proto.writeTag(buf, n122, 1, proto.wireTypes.lengthDelimited)

		buf, n122 = proto.writeString(v2337, v2338, p184.event_id)
	end

	if p184.universe_id ~= nil and p184.universe_id ~= "" then
		local v2339, v2340 = proto.writeTag(buf, n122, 2, proto.wireTypes.lengthDelimited)

		buf, n122 = proto.writeString(v2339, v2340, p184.universe_id)
	end

	local buf67 = buffer.create(n122)

	buffer.copy(buf67, 0, buf, 0, n122)

	return buf67
end
function t298.decode(p185: buffer) -- line: 14432
	-- upvalues: t298 (copy), proto (copy)
	local v2343 = t298.new()
	local n123 = 0

	while n123 < buffer.len(p185) do
		local v2345, v2346

		v2345, v2346, n123 = proto.readTag(p185, n123)

		if v2346 == proto.wireTypes.varint then
			local v2347

			v2347, n123 = proto.readVarInt(p185, n123)
		elseif v2346 == proto.wireTypes.lengthDelimited then
			if v2345 == 1 then
				local v2348

				v2348, n123 = proto.readBuffer(p185, n123)
				v2343.event_id = buffer.tostring(v2348)
			elseif v2345 == 2 then
				local v2349

				v2349, n123 = proto.readBuffer(p185, n123)
				v2343.universe_id = buffer.tostring(v2349)
			else
				local v2350, v2351 = proto.readVarInt(p185, n123)

				n123 = v2351 + v2350
			end
		elseif v2346 == proto.wireTypes.i32 then
			local v2352

			v2352, n123 = proto.readFixed32(p185, n123)
		elseif v2346 == proto.wireTypes.i64 then
			local v2353

			v2353, n123 = proto.readFixed64(p185, n123)
		else
			error("Unsupported wire type: " .. v2346)
		end
	end

	return v2343
end
function t298.jsonEncode(p186) -- line: 14480
	local t300 = {}

	if p186.event_id ~= nil and p186.event_id ~= "" then
		t300.eventId = p186.event_id
	end

	if p186.universe_id ~= nil and p186.universe_id ~= "" then
		t300.universeId = p186.universe_id
	end

	return t300
end
function t298.jsonDecode(t301: {[any]: any}) -- line: 14494
	-- upvalues: t298 (copy)
	local v2357 = t298.new()

	if t301.event_id ~= nil then
		v2357.event_id = t301.event_id
	end

	if t301.eventId ~= nil then
		v2357.event_id = t301.eventId
	end

	if t301.universe_id ~= nil then
		v2357.universe_id = t301.universe_id
	end

	if t301.universeId ~= nil then
		v2357.universe_id = t301.universeId
	end

	return v2357
end

t298.descriptor = {
	name = "EventAttributionRowInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventAttributionRowInputData"
}
t1.EventAttributionRowInputData = t298
typeRegistry.default:register(t1.EventAttributionRowInputData)

local t302 = {}

t302.__index = t302

function t302.new(t303: {[any]: any}?) -- line: 14530
	-- upvalues: t302 (copy)
	return (setmetatable({
		event_id = if t303 ~= nil and t303.event_id ~= nil then t303.event_id else ""
	}, t302))
end
function t302.encode(p187) -- line: 14536
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n124 = 0

	if p187.event_id ~= nil and p187.event_id ~= "" then
		local v2362, v2363 = proto.writeTag(buf, n124, 1, proto.wireTypes.lengthDelimited)

		buf, n124 = proto.writeString(v2362, v2363, p187.event_id)
	end

	local buf68 = buffer.create(n124)

	buffer.copy(buf68, 0, buf, 0, n124)

	return buf68
end
function t302.decode(p188: buffer) -- line: 14550
	-- upvalues: t302 (copy), proto (copy)
	local v2366 = t302.new()
	local n125 = 0

	while n125 < buffer.len(p188) do
		local v2368, v2369

		v2368, v2369, n125 = proto.readTag(p188, n125)

		if v2369 == proto.wireTypes.varint then
			local v2370

			v2370, n125 = proto.readVarInt(p188, n125)
		elseif v2369 == proto.wireTypes.lengthDelimited then
			if v2368 == 1 then
				local v2371

				v2371, n125 = proto.readBuffer(p188, n125)
				v2366.event_id = buffer.tostring(v2371)
			else
				local v2372, v2373 = proto.readVarInt(p188, n125)

				n125 = v2373 + v2372
			end
		elseif v2369 == proto.wireTypes.i32 then
			local v2374

			v2374, n125 = proto.readFixed32(p188, n125)
		elseif v2369 == proto.wireTypes.i64 then
			local v2375

			v2375, n125 = proto.readFixed64(p188, n125)
		else
			error("Unsupported wire type: " .. v2369)
		end
	end

	return v2366
end
function t302.jsonEncode(p189) -- line: 14593
	local t304 = {}

	if p189.event_id ~= nil and p189.event_id ~= "" then
		t304.eventId = p189.event_id
	end

	return t304
end
function t302.jsonDecode(t305: {[any]: any}) -- line: 14603
	-- upvalues: t302 (copy)
	local v2379 = t302.new()

	if t305.event_id ~= nil then
		v2379.event_id = t305.event_id
	end

	if t305.eventId ~= nil then
		v2379.event_id = t305.eventId
	end

	return v2379
end

t302.descriptor = {
	name = "EventInfoTableInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventInfoTableInputData"
}
t1.EventInfoTableInputData = t302
typeRegistry.default:register(t1.EventInfoTableInputData)

local t306 = {}

t306.__index = t306

function t306.new(t307: {[any]: any}?) -- line: 14631
	-- upvalues: t306 (copy)
	return (setmetatable({
		event_id = if t307 ~= nil and t307.event_id ~= nil then t307.event_id else ""
	}, t306))
end
function t306.encode(p190) -- line: 14639
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n126 = 0

	if p190.event_id ~= nil and p190.event_id ~= "" then
		local v2384, v2385 = proto.writeTag(buf, n126, 1, proto.wireTypes.lengthDelimited)

		buf, n126 = proto.writeString(v2384, v2385, p190.event_id)
	end

	local buf69 = buffer.create(n126)

	buffer.copy(buf69, 0, buf, 0, n126)

	return buf69
end
function t306.decode(p191: buffer) -- line: 14653
	-- upvalues: t306 (copy), proto (copy)
	local v2388 = t306.new()
	local n127 = 0

	while n127 < buffer.len(p191) do
		local v2390, v2391

		v2390, v2391, n127 = proto.readTag(p191, n127)

		if v2391 == proto.wireTypes.varint then
			local v2392

			v2392, n127 = proto.readVarInt(p191, n127)
		elseif v2391 == proto.wireTypes.lengthDelimited then
			if v2390 == 1 then
				local v2393

				v2393, n127 = proto.readBuffer(p191, n127)
				v2388.event_id = buffer.tostring(v2393)
			else
				local v2394, v2395 = proto.readVarInt(p191, n127)

				n127 = v2395 + v2394
			end
		elseif v2391 == proto.wireTypes.i32 then
			local v2396

			v2396, n127 = proto.readFixed32(p191, n127)
		elseif v2391 == proto.wireTypes.i64 then
			local v2397

			v2397, n127 = proto.readFixed64(p191, n127)
		else
			error("Unsupported wire type: " .. v2391)
		end
	end

	return v2388
end
function t306.jsonEncode(p192) -- line: 14696
	local t308 = {}

	if p192.event_id ~= nil and p192.event_id ~= "" then
		t308.eventId = p192.event_id
	end

	return t308
end
function t306.jsonDecode(t309: {[any]: any}) -- line: 14706
	-- upvalues: t306 (copy)
	local v2401 = t306.new()

	if t309.event_id ~= nil then
		v2401.event_id = t309.event_id
	end

	if t309.eventId ~= nil then
		v2401.event_id = t309.eventId
	end

	return v2401
end

t306.descriptor = {
	name = "EventDetailsSheetFullBleedInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventDetailsSheetFullBleedInputData"
}
t1.EventDetailsSheetFullBleedInputData = t306
typeRegistry.default:register(t1.EventDetailsSheetFullBleedInputData)

local t310 = {}

t310.__index = t310

function t310.new(t311: {[any]: any}?) -- line: 14736
	-- upvalues: t310 (copy)
	return (setmetatable({
		event_id = if t311 ~= nil and t311.event_id ~= nil then t311.event_id else "",
		universe_id = if t311 ~= nil and t311.universe_id ~= nil then t311.universe_id else ""
	}, t310))
end
function t310.encode(p193) -- line: 14745
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n128 = 0

	if p193.event_id ~= nil and p193.event_id ~= "" then
		local v2406, v2407 = proto.writeTag(buf, n128, 1, proto.wireTypes.lengthDelimited)

		buf, n128 = proto.writeString(v2406, v2407, p193.event_id)
	end

	if p193.universe_id ~= nil and p193.universe_id ~= "" then
		local v2408, v2409 = proto.writeTag(buf, n128, 2, proto.wireTypes.lengthDelimited)

		buf, n128 = proto.writeString(v2408, v2409, p193.universe_id)
	end

	local buf70 = buffer.create(n128)

	buffer.copy(buf70, 0, buf, 0, n128)

	return buf70
end
function t310.decode(p194: buffer) -- line: 14764
	-- upvalues: t310 (copy), proto (copy)
	local v2412 = t310.new()
	local n129 = 0

	while n129 < buffer.len(p194) do
		local v2414, v2415

		v2414, v2415, n129 = proto.readTag(p194, n129)

		if v2415 == proto.wireTypes.varint then
			local v2416

			v2416, n129 = proto.readVarInt(p194, n129)
		elseif v2415 == proto.wireTypes.lengthDelimited then
			if v2414 == 1 then
				local v2417

				v2417, n129 = proto.readBuffer(p194, n129)
				v2412.event_id = buffer.tostring(v2417)
			elseif v2414 == 2 then
				local v2418

				v2418, n129 = proto.readBuffer(p194, n129)
				v2412.universe_id = buffer.tostring(v2418)
			else
				local v2419, v2420 = proto.readVarInt(p194, n129)

				n129 = v2420 + v2419
			end
		elseif v2415 == proto.wireTypes.i32 then
			local v2421

			v2421, n129 = proto.readFixed32(p194, n129)
		elseif v2415 == proto.wireTypes.i64 then
			local v2422

			v2422, n129 = proto.readFixed64(p194, n129)
		else
			error("Unsupported wire type: " .. v2415)
		end
	end

	return v2412
end
function t310.jsonEncode(p195) -- line: 14812
	local t312 = {}

	if p195.event_id ~= nil and p195.event_id ~= "" then
		t312.eventId = p195.event_id
	end

	if p195.universe_id ~= nil and p195.universe_id ~= "" then
		t312.universeId = p195.universe_id
	end

	return t312
end
function t310.jsonDecode(t313: {[any]: any}) -- line: 14826
	-- upvalues: t310 (copy)
	local v2426 = t310.new()

	if t313.event_id ~= nil then
		v2426.event_id = t313.event_id
	end

	if t313.eventId ~= nil then
		v2426.event_id = t313.eventId
	end

	if t313.universe_id ~= nil then
		v2426.universe_id = t313.universe_id
	end

	if t313.universeId ~= nil then
		v2426.universe_id = t313.universeId
	end

	return v2426
end

t310.descriptor = {
	name = "EventNotificationsModalInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventNotificationsModalInputData"
}
t1.EventNotificationsModalInputData = t310
typeRegistry.default:register(t1.EventNotificationsModalInputData)

local t314 = {}

t314.__index = t314

function t314.new(t315: {[any]: any}?) -- line: 14864
	-- upvalues: t314 (copy)
	return (setmetatable({
		entry_map = if t315 ~= nil and t315.entry_map ~= nil then t315.entry_map else {},
		entry_order = if t315 ~= nil and t315.entry_order ~= nil then t315.entry_order else {},
		next_page_token = if t315 ~= nil and t315.next_page_token ~= nil then t315.next_page_token else "",
		sticky_filter_pills = if t315 ~= nil and t315.sticky_filter_pills ~= nil then t315.sticky_filter_pills else nil,
		applied_filters = if t315 ~= nil and t315.applied_filters ~= nil then t315.applied_filters else ""
	}, t314))
end
function t314.encode(p196) -- line: 14876
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n130 = 0

	if p196.entry_map ~= nil and next(p196.entry_map) ~= nil then
		for v2431, v2432 in p196.entry_map do
			local buf71 = buffer.create(0)
			local v2434, v2435 = proto.writeTag(buf71, 0, 1, proto.wireTypes.lengthDelimited)
			local v2436, v2437 = proto.writeString(v2434, v2435, v2431)
			local v2438 = v2432:encode()
			local v2439, v2440 = proto.writeTag(v2436, v2437, 2, proto.wireTypes.lengthDelimited)
			local v2441, v2442 = proto.writeBuffer(v2439, v2440, v2438, buffer.len(v2438))
			local v2443, v2444 = proto.writeTag(buf, n130, 1, proto.wireTypes.lengthDelimited)

			buf, n130 = proto.writeBuffer(v2443, v2444, v2441, v2442)
		end
	end

	if p196.entry_order ~= nil and #p196.entry_order > 0 then
		for _, v2446 in p196.entry_order do
			local v2447, v2448 = proto.writeTag(buf, n130, 2, proto.wireTypes.lengthDelimited)

			buf, n130 = proto.writeString(v2447, v2448, v2446)
		end
	end

	if p196.next_page_token ~= nil and p196.next_page_token ~= "" then
		local v2449, v2450 = proto.writeTag(buf, n130, 3, proto.wireTypes.lengthDelimited)

		buf, n130 = proto.writeString(v2449, v2450, p196.next_page_token)
	end

	if p196.sticky_filter_pills ~= nil then
		local v2451 = p196.sticky_filter_pills:encode()
		local v2452, v2453 = proto.writeTag(buf, n130, 4, proto.wireTypes.lengthDelimited)

		buf, n130 = proto.writeBuffer(v2452, v2453, v2451, buffer.len(v2451))
	end

	if p196.applied_filters ~= nil and p196.applied_filters ~= "" then
		local v2454, v2455 = proto.writeTag(buf, n130, 5, proto.wireTypes.lengthDelimited)

		buf, n130 = proto.writeString(v2454, v2455, p196.applied_filters)
	end

	local buf72 = buffer.create(n130)

	buffer.copy(buf72, 0, buf, 0, n130)

	return buf72
end
function t314.decode(p197: buffer) -- line: 14922
	-- upvalues: t314 (copy), proto (copy), t1 (copy)
	local v2458 = t314.new()
	local n131 = 0

	while n131 < buffer.len(p197) do
		local v2460, v2461

		v2460, v2461, n131 = proto.readTag(p197, n131)

		if v2461 == proto.wireTypes.varint then
			local v2462

			v2462, n131 = proto.readVarInt(p197, n131)
		elseif v2461 == proto.wireTypes.lengthDelimited then
			if v2460 == 1 then
				local v2463

				v2463, n131 = proto.readBuffer(p197, n131)

				local v2464 = t1.ChartsFeedInputData_EntryMapEntry.decode(v2463)
				local v2465 = t1.FeedEntry.new()

				v2458.entry_map[v2464.key or ""] = v2464.value or v2465
			elseif v2460 == 2 then
				local v2466

				v2466, n131 = proto.readBuffer(p197, n131)
				table.insert(v2458.entry_order, buffer.tostring(v2466))
			elseif v2460 == 3 then
				local v2467

				v2467, n131 = proto.readBuffer(p197, n131)
				v2458.next_page_token = buffer.tostring(v2467)
			elseif v2460 == 4 then
				local v2468

				v2468, n131 = proto.readBuffer(p197, n131)
				v2458.sticky_filter_pills = t1.FilterPillsInputData.decode(v2468)
			elseif v2460 == 5 then
				local v2469

				v2469, n131 = proto.readBuffer(p197, n131)
				v2458.applied_filters = buffer.tostring(v2469)
			else
				local v2470, v2471 = proto.readVarInt(p197, n131)

				n131 = v2471 + v2470
			end
		elseif v2461 == proto.wireTypes.i32 then
			local v2472

			v2472, n131 = proto.readFixed32(p197, n131)
		elseif v2461 == proto.wireTypes.i64 then
			local v2473

			v2473, n131 = proto.readFixed64(p197, n131)
		else
			error("Unsupported wire type: " .. v2461)
		end
	end

	return v2458
end
function t314.jsonEncode(p198) -- line: 14992
	local t316 = {}

	if p198.entry_map ~= nil and next(p198.entry_map) ~= nil then
		local t317 = {}

		for v2477, v2478 in p198.entry_map do
			t317[v2477] = v2478:jsonEncode()
		end

		t316.entryMap = t317
	end

	if p198.entry_order ~= nil and #p198.entry_order > 0 then
		local t318 = {}

		for _, v2481 in p198.entry_order do
			table.insert(t318, v2481)
		end

		t316.entryOrder = t318
	end

	if p198.next_page_token ~= nil and p198.next_page_token ~= "" then
		t316.nextPageToken = p198.next_page_token
	end

	if p198.sticky_filter_pills ~= nil then
		t316.stickyFilterPills = p198.sticky_filter_pills:jsonEncode()
	end

	if p198.applied_filters ~= nil and p198.applied_filters ~= "" then
		t316.appliedFilters = p198.applied_filters
	end

	return t316
end
function t314.jsonDecode(t319: {[any]: any}) -- line: 15026
	-- upvalues: t314 (copy), t1 (copy)
	local v2483 = t314.new()

	if t319.entry_map ~= nil then
		local t320 = {}

		for v2485, v2486 in t319.entry_map do
			t320[v2485] = t1.FeedEntry.jsonDecode(v2486)
		end

		v2483.entry_map = t320
	end

	if t319.entryMap ~= nil then
		local t321 = {}

		for v2488, v2489 in t319.entryMap do
			t321[v2488] = t1.FeedEntry.jsonDecode(v2489)
		end

		v2483.entry_map = t321
	end

	if t319.entry_order ~= nil then
		local t322 = {}

		for _, v2492 in t319.entry_order do
			table.insert(t322, v2492)
		end

		v2483.entry_order = t322
	end

	if t319.entryOrder ~= nil then
		local t323 = {}

		for _, v2495 in t319.entryOrder do
			table.insert(t323, v2495)
		end

		v2483.entry_order = t323
	end

	if t319.next_page_token ~= nil then
		v2483.next_page_token = t319.next_page_token
	end

	if t319.nextPageToken ~= nil then
		v2483.next_page_token = t319.nextPageToken
	end

	if t319.sticky_filter_pills ~= nil then
		v2483.sticky_filter_pills = t1.FilterPillsInputData.jsonDecode(t319.sticky_filter_pills)
	end

	if t319.stickyFilterPills ~= nil then
		v2483.sticky_filter_pills = t1.FilterPillsInputData.jsonDecode(t319.stickyFilterPills)
	end

	if t319.applied_filters ~= nil then
		v2483.applied_filters = t319.applied_filters
	end

	if t319.appliedFilters ~= nil then
		v2483.applied_filters = t319.appliedFilters
	end

	return v2483
end

t314.descriptor = {
	name = "ChartsFeedInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ChartsFeedInputData"
}
t1.ChartsFeedInputData = t314
typeRegistry.default:register(t1.ChartsFeedInputData)

local t324 = {}

t324.__index = t324

function t324.new(t325: {[any]: any}?) -- line: 15106
	-- upvalues: t324 (copy)
	return (setmetatable({
		key = if t325 ~= nil and t325.key ~= nil then t325.key else "",
		value = if t325 ~= nil and t325.value ~= nil then t325.value else nil
	}, t324))
end
function t324.encode(p199) -- line: 15115
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n132 = 0

	if p199.key ~= nil and p199.key ~= "" then
		local v2500, v2501 = proto.writeTag(buf, n132, 1, proto.wireTypes.lengthDelimited)

		buf, n132 = proto.writeString(v2500, v2501, p199.key)
	end

	if p199.value ~= nil then
		local v2502 = p199.value:encode()
		local v2503, v2504 = proto.writeTag(buf, n132, 2, proto.wireTypes.lengthDelimited)

		buf, n132 = proto.writeBuffer(v2503, v2504, v2502, buffer.len(v2502))
	end

	local buf73 = buffer.create(n132)

	buffer.copy(buf73, 0, buf, 0, n132)

	return buf73
end
function t324.decode(p200: buffer) -- line: 15135
	-- upvalues: t324 (copy), proto (copy), t1 (copy)
	local v2507 = t324.new()
	local n133 = 0

	while n133 < buffer.len(p200) do
		local v2509, v2510

		v2509, v2510, n133 = proto.readTag(p200, n133)

		if v2510 == proto.wireTypes.varint then
			local v2511

			v2511, n133 = proto.readVarInt(p200, n133)
		elseif v2510 == proto.wireTypes.lengthDelimited then
			if v2509 == 1 then
				local v2512

				v2512, n133 = proto.readBuffer(p200, n133)
				v2507.key = buffer.tostring(v2512)
			elseif v2509 == 2 then
				local v2513

				v2513, n133 = proto.readBuffer(p200, n133)
				v2507.value = t1.FeedEntry.decode(v2513)
			else
				local v2514, v2515 = proto.readVarInt(p200, n133)

				n133 = v2515 + v2514
			end
		elseif v2510 == proto.wireTypes.i32 then
			local v2516

			v2516, n133 = proto.readFixed32(p200, n133)
		elseif v2510 == proto.wireTypes.i64 then
			local v2517

			v2517, n133 = proto.readFixed64(p200, n133)
		else
			error("Unsupported wire type: " .. v2510)
		end
	end

	return v2507
end
function t324.jsonEncode(p201) -- line: 15183
	local t326 = {}

	if p201.key ~= nil and p201.key ~= "" then
		t326.key = p201.key
	end

	if p201.value ~= nil then
		t326.value = p201.value:jsonEncode()
	end

	return t326
end
function t324.jsonDecode(t327: {[any]: any}) -- line: 15197
	-- upvalues: t324 (copy), t1 (copy)
	local v2521 = t324.new()

	if t327.key ~= nil then
		v2521.key = t327.key
	end

	if t327.value ~= nil then
		v2521.value = t1.FeedEntry.jsonDecode(t327.value)
	end

	return v2521
end

t324.descriptor = {
	name = "ChartsFeedInputData_EntryMapEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryMapEntry"
}
t1.ChartsFeedInputData_EntryMapEntry = t324
typeRegistry.default:register(t1.ChartsFeedInputData_EntryMapEntry)

local t328 = {}

t328.__index = t328

function t328.new(t329: {[any]: any}?) -- line: 15227
	-- upvalues: t328 (copy)
	return (setmetatable({
		filter_groups = if t329 ~= nil and t329.filter_groups ~= nil then t329.filter_groups else {},
		sort_id = if t329 ~= nil and t329.sort_id ~= nil then t329.sort_id else "",
		secondary_sort_id = if t329 ~= nil and t329.secondary_sort_id ~= nil then t329.secondary_sort_id else 0,
		title = if t329 ~= nil and t329.title ~= nil then t329.title else "",
		primary_sort_id = if t329 ~= nil and t329.primary_sort_id ~= nil then t329.primary_sort_id else nil,
		applied_filters = if t329 ~= nil and t329.applied_filters ~= nil then t329.applied_filters else nil
	}, t328))
end
function t328.encode(p202) -- line: 15238
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n134 = 0

	if p202.filter_groups ~= nil and #p202.filter_groups > 0 then
		for _, v2527 in p202.filter_groups do
			local v2528 = v2527:encode()
			local v2529, v2530 = proto.writeTag(buf, n134, 1, proto.wireTypes.lengthDelimited)

			buf, n134 = proto.writeBuffer(v2529, v2530, v2528, buffer.len(v2528))
		end
	end

	if p202.sort_id ~= nil and p202.sort_id ~= "" then
		local v2531, v2532 = proto.writeTag(buf, n134, 2, proto.wireTypes.lengthDelimited)

		buf, n134 = proto.writeString(v2531, v2532, p202.sort_id)
	end

	if p202.secondary_sort_id ~= nil and p202.secondary_sort_id ~= 0 then
		local v2533, v2534 = proto.writeTag(buf, n134, 3, proto.wireTypes.varint)

		buf, n134 = proto.writeVarInt(v2533, v2534, p202.secondary_sort_id)
	end

	if p202.title ~= nil and p202.title ~= "" then
		local v2535, v2536 = proto.writeTag(buf, n134, 4, proto.wireTypes.lengthDelimited)

		buf, n134 = proto.writeString(v2535, v2536, p202.title)
	end

	if p202.primary_sort_id ~= nil then
		local v2537, v2538 = proto.writeTag(buf, n134, 5, proto.wireTypes.varint)

		buf, n134 = proto.writeVarInt(v2537, v2538, p202.primary_sort_id)
	end

	if p202.applied_filters ~= nil then
		local v2539, v2540 = proto.writeTag(buf, n134, 6, proto.wireTypes.lengthDelimited)

		buf, n134 = proto.writeString(v2539, v2540, p202.applied_filters)
	end

	local buf74 = buffer.create(n134)

	buffer.copy(buf74, 0, buf, 0, n134)

	return buf74
end
function t328.decode(p203: buffer) -- line: 15280
	-- upvalues: t328 (copy), proto (copy), t1 (copy)
	local v2543 = t328.new()
	local n135 = 0

	while n135 < buffer.len(p203) do
		local v2545, v2546

		v2545, v2546, n135 = proto.readTag(p203, n135)

		if v2546 == proto.wireTypes.varint then
			if v2545 == 3 then
				local v2547

				v2547, n135 = proto.readVarIntI32(p203, n135)
				v2543.secondary_sort_id = v2547
			elseif v2545 == 5 then
				local v2548

				v2548, n135 = proto.readVarIntI32(p203, n135)
				v2543.primary_sort_id = v2548
			else
				local v2549

				v2549, n135 = proto.readVarInt(p203, n135)
			end
		elseif v2546 == proto.wireTypes.lengthDelimited then
			if v2545 == 1 then
				local v2550

				v2550, n135 = proto.readBuffer(p203, n135)
				table.insert(v2543.filter_groups, t1.FilterPillsInputData_FilterGroup.decode(v2550))
			elseif v2545 == 2 then
				local v2551

				v2551, n135 = proto.readBuffer(p203, n135)
				v2543.sort_id = buffer.tostring(v2551)
			elseif v2545 == 4 then
				local v2552

				v2552, n135 = proto.readBuffer(p203, n135)
				v2543.title = buffer.tostring(v2552)
			elseif v2545 == 6 then
				local v2553

				v2553, n135 = proto.readBuffer(p203, n135)
				v2543.applied_filters = buffer.tostring(v2553)
			else
				local v2554, v2555 = proto.readVarInt(p203, n135)

				n135 = v2555 + v2554
			end
		elseif v2546 == proto.wireTypes.i32 then
			local v2556

			v2556, n135 = proto.readFixed32(p203, n135)
		elseif v2546 == proto.wireTypes.i64 then
			local v2557

			v2557, n135 = proto.readFixed64(p203, n135)
		else
			error("Unsupported wire type: " .. v2546)
		end
	end

	return v2543
end
function t328.jsonEncode(p204) -- line: 15348
	local t330 = {}

	if p204.filter_groups ~= nil and #p204.filter_groups > 0 then
		local t331 = {}

		for _, v2562 in p204.filter_groups do
			table.insert(t331, v2562:jsonEncode())
		end

		t330.filterGroups = t331
	end

	if p204.sort_id ~= nil and p204.sort_id ~= "" then
		t330.sortId = p204.sort_id
	end

	if p204.secondary_sort_id ~= nil and p204.secondary_sort_id ~= 0 then
		t330.secondarySortId = p204.secondary_sort_id
	end

	if p204.title ~= nil and p204.title ~= "" then
		t330.title = p204.title
	end

	if p204.primary_sort_id ~= nil then
		t330.primarySortId = p204.primary_sort_id
	end

	if p204.applied_filters ~= nil then
		t330.appliedFilters = p204.applied_filters
	end

	return t330
end
function t328.jsonDecode(t332: {[any]: any}) -- line: 15382
	-- upvalues: t328 (copy), t1 (copy)
	local v2564 = t328.new()

	if t332.filter_groups ~= nil then
		local t333 = {}

		for _, v2567 in t332.filter_groups do
			table.insert(t333, t1.FilterPillsInputData_FilterGroup.jsonDecode(v2567))
		end

		v2564.filter_groups = t333
	end

	if t332.filterGroups ~= nil then
		local t334 = {}

		for _, v2570 in t332.filterGroups do
			table.insert(t334, t1.FilterPillsInputData_FilterGroup.jsonDecode(v2570))
		end

		v2564.filter_groups = t334
	end

	if t332.sort_id ~= nil then
		v2564.sort_id = t332.sort_id
	end

	if t332.sortId ~= nil then
		v2564.sort_id = t332.sortId
	end

	if t332.secondary_sort_id ~= nil then
		v2564.secondary_sort_id = t332.secondary_sort_id
	end

	if t332.secondarySortId ~= nil then
		v2564.secondary_sort_id = t332.secondarySortId
	end

	if t332.title ~= nil then
		v2564.title = t332.title
	end

	if t332.primary_sort_id ~= nil then
		v2564.primary_sort_id = t332.primary_sort_id
	end

	if t332.primarySortId ~= nil then
		v2564.primary_sort_id = t332.primarySortId
	end

	if t332.applied_filters ~= nil then
		v2564.applied_filters = t332.applied_filters
	end

	if t332.appliedFilters ~= nil then
		v2564.applied_filters = t332.appliedFilters
	end

	return v2564
end

t328.descriptor = {
	name = "FilterPillsInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.FilterPillsInputData"
}
t1.FilterPillsInputData = t328
typeRegistry.default:register(t1.FilterPillsInputData)

local t335 = {}

t335.__index = t335

function t335.new(t336: {[any]: any}?) -- line: 15456
	-- upvalues: t335 (copy)
	return (setmetatable({
		filter_id = if t336 ~= nil and t336.filter_id ~= nil then t336.filter_id else "",
		display_name = if t336 ~= nil and t336.display_name ~= nil then t336.display_name else "",
		options = if t336 ~= nil and t336.options ~= nil then t336.options else {},
		default_option_id = if t336 ~= nil and t336.default_option_id ~= nil then t336.default_option_id else "",
		selected_option_id = if t336 ~= nil and t336.selected_option_id ~= nil then t336.selected_option_id else "",
		filter_type = if t336 ~= nil and t336.filter_type ~= nil then t336.filter_type else "",
		inactive_option_ids = if t336 ~= nil and t336.inactive_option_ids ~= nil then t336.inactive_option_ids else {},
		info_text = if t336 ~= nil and t336.info_text ~= nil then t336.info_text else ""
	}, t335))
end
function t335.encode(p205) -- line: 15473
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n136 = 0

	if p205.filter_id ~= nil and p205.filter_id ~= "" then
		local v2575, v2576 = proto.writeTag(buf, n136, 1, proto.wireTypes.lengthDelimited)

		buf, n136 = proto.writeString(v2575, v2576, p205.filter_id)
	end

	if p205.display_name ~= nil and p205.display_name ~= "" then
		local v2577, v2578 = proto.writeTag(buf, n136, 2, proto.wireTypes.lengthDelimited)

		buf, n136 = proto.writeString(v2577, v2578, p205.display_name)
	end

	if p205.options ~= nil and #p205.options > 0 then
		for _, v2580 in p205.options do
			local v2581 = v2580:encode()
			local v2582, v2583 = proto.writeTag(buf, n136, 3, proto.wireTypes.lengthDelimited)

			buf, n136 = proto.writeBuffer(v2582, v2583, v2581, buffer.len(v2581))
		end
	end

	if p205.default_option_id ~= nil and p205.default_option_id ~= "" then
		local v2584, v2585 = proto.writeTag(buf, n136, 4, proto.wireTypes.lengthDelimited)

		buf, n136 = proto.writeString(v2584, v2585, p205.default_option_id)
	end

	if p205.selected_option_id ~= nil and p205.selected_option_id ~= "" then
		local v2586, v2587 = proto.writeTag(buf, n136, 5, proto.wireTypes.lengthDelimited)

		buf, n136 = proto.writeString(v2586, v2587, p205.selected_option_id)
	end

	if p205.filter_type ~= nil and p205.filter_type ~= "" then
		local v2588, v2589 = proto.writeTag(buf, n136, 6, proto.wireTypes.lengthDelimited)

		buf, n136 = proto.writeString(v2588, v2589, p205.filter_type)
	end

	if p205.inactive_option_ids ~= nil and #p205.inactive_option_ids > 0 then
		for _, v2591 in p205.inactive_option_ids do
			local v2592, v2593 = proto.writeTag(buf, n136, 7, proto.wireTypes.lengthDelimited)

			buf, n136 = proto.writeString(v2592, v2593, v2591)
		end
	end

	if p205.info_text ~= nil and p205.info_text ~= "" then
		local v2594, v2595 = proto.writeTag(buf, n136, 8, proto.wireTypes.lengthDelimited)

		buf, n136 = proto.writeString(v2594, v2595, p205.info_text)
	end

	local buf75 = buffer.create(n136)

	buffer.copy(buf75, 0, buf, 0, n136)

	return buf75
end
function t335.decode(p206: buffer) -- line: 15527
	-- upvalues: t335 (copy), proto (copy), t1 (copy)
	local v2598 = t335.new()
	local n137 = 0

	while n137 < buffer.len(p206) do
		local v2600, v2601

		v2600, v2601, n137 = proto.readTag(p206, n137)

		if v2601 == proto.wireTypes.varint then
			local v2602

			v2602, n137 = proto.readVarInt(p206, n137)
		elseif v2601 == proto.wireTypes.lengthDelimited then
			if v2600 == 1 then
				local v2603

				v2603, n137 = proto.readBuffer(p206, n137)
				v2598.filter_id = buffer.tostring(v2603)
			elseif v2600 == 2 then
				local v2604

				v2604, n137 = proto.readBuffer(p206, n137)
				v2598.display_name = buffer.tostring(v2604)
			elseif v2600 == 3 then
				local v2605

				v2605, n137 = proto.readBuffer(p206, n137)
				table.insert(v2598.options, t1.FilterPillsInputData_FilterOption.decode(v2605))
			elseif v2600 == 4 then
				local v2606

				v2606, n137 = proto.readBuffer(p206, n137)
				v2598.default_option_id = buffer.tostring(v2606)
			elseif v2600 == 5 then
				local v2607

				v2607, n137 = proto.readBuffer(p206, n137)
				v2598.selected_option_id = buffer.tostring(v2607)
			elseif v2600 == 6 then
				local v2608

				v2608, n137 = proto.readBuffer(p206, n137)
				v2598.filter_type = buffer.tostring(v2608)
			elseif v2600 == 7 then
				local v2609

				v2609, n137 = proto.readBuffer(p206, n137)
				table.insert(v2598.inactive_option_ids, buffer.tostring(v2609))
			elseif v2600 == 8 then
				local v2610

				v2610, n137 = proto.readBuffer(p206, n137)
				v2598.info_text = buffer.tostring(v2610)
			else
				local v2611, v2612 = proto.readVarInt(p206, n137)

				n137 = v2612 + v2611
			end
		elseif v2601 == proto.wireTypes.i32 then
			local v2613

			v2613, n137 = proto.readFixed32(p206, n137)
		elseif v2601 == proto.wireTypes.i64 then
			local v2614

			v2614, n137 = proto.readFixed64(p206, n137)
		else
			error("Unsupported wire type: " .. v2601)
		end
	end

	return v2598
end
function t335.jsonEncode(p207) -- line: 15605
	local t337 = {}

	if p207.filter_id ~= nil and p207.filter_id ~= "" then
		t337.filterId = p207.filter_id
	end

	if p207.display_name ~= nil and p207.display_name ~= "" then
		t337.displayName = p207.display_name
	end

	if p207.options ~= nil and #p207.options > 0 then
		local t338 = {}

		for _, v2619 in p207.options do
			table.insert(t338, v2619:jsonEncode())
		end

		t337.options = t338
	end

	if p207.default_option_id ~= nil and p207.default_option_id ~= "" then
		t337.defaultOptionId = p207.default_option_id
	end

	if p207.selected_option_id ~= nil and p207.selected_option_id ~= "" then
		t337.selectedOptionId = p207.selected_option_id
	end

	if p207.filter_type ~= nil and p207.filter_type ~= "" then
		t337.filterType = p207.filter_type
	end

	if p207.inactive_option_ids ~= nil and #p207.inactive_option_ids > 0 then
		local t339 = {}

		for _, v2622 in p207.inactive_option_ids do
			table.insert(t339, v2622)
		end

		t337.inactiveOptionIds = t339
	end

	if p207.info_text ~= nil and p207.info_text ~= "" then
		t337.infoText = p207.info_text
	end

	return t337
end
function t335.jsonDecode(t340: {[any]: any}) -- line: 15651
	-- upvalues: t335 (copy), t1 (copy)
	local v2624 = t335.new()

	if t340.filter_id ~= nil then
		v2624.filter_id = t340.filter_id
	end

	if t340.filterId ~= nil then
		v2624.filter_id = t340.filterId
	end

	if t340.display_name ~= nil then
		v2624.display_name = t340.display_name
	end

	if t340.displayName ~= nil then
		v2624.display_name = t340.displayName
	end

	if t340.options ~= nil then
		local t341 = {}

		for _, v2627 in t340.options do
			table.insert(t341, t1.FilterPillsInputData_FilterOption.jsonDecode(v2627))
		end

		v2624.options = t341
	end

	if t340.default_option_id ~= nil then
		v2624.default_option_id = t340.default_option_id
	end

	if t340.defaultOptionId ~= nil then
		v2624.default_option_id = t340.defaultOptionId
	end

	if t340.selected_option_id ~= nil then
		v2624.selected_option_id = t340.selected_option_id
	end

	if t340.selectedOptionId ~= nil then
		v2624.selected_option_id = t340.selectedOptionId
	end

	if t340.filter_type ~= nil then
		v2624.filter_type = t340.filter_type
	end

	if t340.filterType ~= nil then
		v2624.filter_type = t340.filterType
	end

	if t340.inactive_option_ids ~= nil then
		local t342 = {}

		for _, v2630 in t340.inactive_option_ids do
			table.insert(t342, v2630)
		end

		v2624.inactive_option_ids = t342
	end

	if t340.inactiveOptionIds ~= nil then
		local t343 = {}

		for _, v2633 in t340.inactiveOptionIds do
			table.insert(t343, v2633)
		end

		v2624.inactive_option_ids = t343
	end

	if t340.info_text ~= nil then
		v2624.info_text = t340.info_text
	end

	if t340.infoText ~= nil then
		v2624.info_text = t340.infoText
	end

	return v2624
end

t335.descriptor = {
	name = "FilterPillsInputData_FilterGroup",
	fullName = "roblox.apppageplatform.shared.v1beta1.FilterGroup"
}
t1.FilterPillsInputData_FilterGroup = t335
typeRegistry.default:register(t1.FilterPillsInputData_FilterGroup)

local t344 = {}

t344.__index = t344

function t344.new(t345: {[any]: any}?) -- line: 15748
	-- upvalues: t344 (copy)
	return (setmetatable({
		option_id = if t345 ~= nil and t345.option_id ~= nil then t345.option_id else "",
		display_name = if t345 ~= nil and t345.display_name ~= nil then t345.display_name else "",
		option_context_tag = if t345 ~= nil and t345.option_context_tag ~= nil then t345.option_context_tag else ""
	}, t344))
end
function t344.encode(p208) -- line: 15758
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n138 = 0

	if p208.option_id ~= nil and p208.option_id ~= "" then
		local v2638, v2639 = proto.writeTag(buf, n138, 1, proto.wireTypes.lengthDelimited)

		buf, n138 = proto.writeString(v2638, v2639, p208.option_id)
	end

	if p208.display_name ~= nil and p208.display_name ~= "" then
		local v2640, v2641 = proto.writeTag(buf, n138, 2, proto.wireTypes.lengthDelimited)

		buf, n138 = proto.writeString(v2640, v2641, p208.display_name)
	end

	if p208.option_context_tag ~= nil and p208.option_context_tag ~= "" then
		local v2642, v2643 = proto.writeTag(buf, n138, 3, proto.wireTypes.lengthDelimited)

		buf, n138 = proto.writeString(v2642, v2643, p208.option_context_tag)
	end

	local buf76 = buffer.create(n138)

	buffer.copy(buf76, 0, buf, 0, n138)

	return buf76
end
function t344.decode(p209: buffer) -- line: 15782
	-- upvalues: t344 (copy), proto (copy)
	local v2646 = t344.new()
	local n139 = 0

	while n139 < buffer.len(p209) do
		local v2648, v2649

		v2648, v2649, n139 = proto.readTag(p209, n139)

		if v2649 == proto.wireTypes.varint then
			local v2650

			v2650, n139 = proto.readVarInt(p209, n139)
		elseif v2649 == proto.wireTypes.lengthDelimited then
			if v2648 == 1 then
				local v2651

				v2651, n139 = proto.readBuffer(p209, n139)
				v2646.option_id = buffer.tostring(v2651)
			elseif v2648 == 2 then
				local v2652

				v2652, n139 = proto.readBuffer(p209, n139)
				v2646.display_name = buffer.tostring(v2652)
			elseif v2648 == 3 then
				local v2653

				v2653, n139 = proto.readBuffer(p209, n139)
				v2646.option_context_tag = buffer.tostring(v2653)
			else
				local v2654, v2655 = proto.readVarInt(p209, n139)

				n139 = v2655 + v2654
			end
		elseif v2649 == proto.wireTypes.i32 then
			local v2656

			v2656, n139 = proto.readFixed32(p209, n139)
		elseif v2649 == proto.wireTypes.i64 then
			local v2657

			v2657, n139 = proto.readFixed64(p209, n139)
		else
			error("Unsupported wire type: " .. v2649)
		end
	end

	return v2646
end
function t344.jsonEncode(p210) -- line: 15835
	local t346 = {}

	if p210.option_id ~= nil and p210.option_id ~= "" then
		t346.optionId = p210.option_id
	end

	if p210.display_name ~= nil and p210.display_name ~= "" then
		t346.displayName = p210.display_name
	end

	if p210.option_context_tag ~= nil and p210.option_context_tag ~= "" then
		t346.optionContextTag = p210.option_context_tag
	end

	return t346
end
function t344.jsonDecode(t347: {[any]: any}) -- line: 15853
	-- upvalues: t344 (copy)
	local v2661 = t344.new()

	if t347.option_id ~= nil then
		v2661.option_id = t347.option_id
	end

	if t347.optionId ~= nil then
		v2661.option_id = t347.optionId
	end

	if t347.display_name ~= nil then
		v2661.display_name = t347.display_name
	end

	if t347.displayName ~= nil then
		v2661.display_name = t347.displayName
	end

	if t347.option_context_tag ~= nil then
		v2661.option_context_tag = t347.option_context_tag
	end

	if t347.optionContextTag ~= nil then
		v2661.option_context_tag = t347.optionContextTag
	end

	return v2661
end

t344.descriptor = {
	name = "FilterPillsInputData_FilterOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.FilterOption"
}
t1.FilterPillsInputData_FilterOption = t344
typeRegistry.default:register(t1.FilterPillsInputData_FilterOption)

local t348 = {}

t348.__index = t348

function t348.new(t349: {[any]: any}?) -- line: 15899
	-- upvalues: t348 (copy)
	return (setmetatable({
		sort_options = if t349 ~= nil and t349.sort_options ~= nil then t349.sort_options else {},
		selected_sort_id = if t349 ~= nil and t349.selected_sort_id ~= nil then t349.selected_sort_id else ""
	}, t348))
end
function t348.encode(p211) -- line: 15906
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n140 = 0

	if p211.sort_options ~= nil and #p211.sort_options > 0 then
		for _, v2667 in p211.sort_options do
			local v2668 = v2667:encode()
			local v2669, v2670 = proto.writeTag(buf, n140, 1, proto.wireTypes.lengthDelimited)

			buf, n140 = proto.writeBuffer(v2669, v2670, v2668, buffer.len(v2668))
		end
	end

	if p211.selected_sort_id ~= nil and p211.selected_sort_id ~= "" then
		local v2671, v2672 = proto.writeTag(buf, n140, 2, proto.wireTypes.lengthDelimited)

		buf, n140 = proto.writeString(v2671, v2672, p211.selected_sort_id)
	end

	local buf77 = buffer.create(n140)

	buffer.copy(buf77, 0, buf, 0, n140)

	return buf77
end
function t348.decode(p212: buffer) -- line: 15928
	-- upvalues: t348 (copy), proto (copy), t1 (copy)
	local v2675 = t348.new()
	local n141 = 0

	while n141 < buffer.len(p212) do
		local v2677, v2678

		v2677, v2678, n141 = proto.readTag(p212, n141)

		if v2678 == proto.wireTypes.varint then
			local v2679

			v2679, n141 = proto.readVarInt(p212, n141)
		elseif v2678 == proto.wireTypes.lengthDelimited then
			if v2677 == 1 then
				local v2680

				v2680, n141 = proto.readBuffer(p212, n141)
				table.insert(v2675.sort_options, t1.SortSelectorInputData_SortOption.decode(v2680))
			elseif v2677 == 2 then
				local v2681

				v2681, n141 = proto.readBuffer(p212, n141)
				v2675.selected_sort_id = buffer.tostring(v2681)
			else
				local v2682, v2683 = proto.readVarInt(p212, n141)

				n141 = v2683 + v2682
			end
		elseif v2678 == proto.wireTypes.i32 then
			local v2684

			v2684, n141 = proto.readFixed32(p212, n141)
		elseif v2678 == proto.wireTypes.i64 then
			local v2685

			v2685, n141 = proto.readFixed64(p212, n141)
		else
			error("Unsupported wire type: " .. v2678)
		end
	end

	return v2675
end
function t348.jsonEncode(p213) -- line: 15976
	local t350 = {}

	if p213.sort_options ~= nil and #p213.sort_options > 0 then
		local t351 = {}

		for _, v2690 in p213.sort_options do
			table.insert(t351, v2690:jsonEncode())
		end

		t350.sortOptions = t351
	end

	if p213.selected_sort_id ~= nil and p213.selected_sort_id ~= "" then
		t350.selectedSortId = p213.selected_sort_id
	end

	return t350
end
function t348.jsonDecode(t352: {[any]: any}) -- line: 15994
	-- upvalues: t348 (copy), t1 (copy)
	local v2692 = t348.new()

	if t352.sort_options ~= nil then
		local t353 = {}

		for _, v2695 in t352.sort_options do
			table.insert(t353, t1.SortSelectorInputData_SortOption.jsonDecode(v2695))
		end

		v2692.sort_options = t353
	end

	if t352.sortOptions ~= nil then
		local t354 = {}

		for _, v2698 in t352.sortOptions do
			table.insert(t354, t1.SortSelectorInputData_SortOption.jsonDecode(v2698))
		end

		v2692.sort_options = t354
	end

	if t352.selected_sort_id ~= nil then
		v2692.selected_sort_id = t352.selected_sort_id
	end

	if t352.selectedSortId ~= nil then
		v2692.selected_sort_id = t352.selectedSortId
	end

	return v2692
end

t348.descriptor = {
	name = "SortSelectorInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.SortSelectorInputData"
}
t1.SortSelectorInputData = t348
typeRegistry.default:register(t1.SortSelectorInputData)

local t355 = {}

t355.__index = t355

function t355.new(t356: {[any]: any}?) -- line: 16040
	-- upvalues: t355 (copy)
	return (setmetatable({
		sort_id = if t356 ~= nil and t356.sort_id ~= nil then t356.sort_id else "",
		display_name = if t356 ~= nil and t356.display_name ~= nil then t356.display_name else "",
		content_type = if t356 ~= nil and t356.content_type ~= nil then t356.content_type else ""
	}, t355))
end
function t355.encode(p214) -- line: 16050
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n142 = 0

	if p214.sort_id ~= nil and p214.sort_id ~= "" then
		local v2703, v2704 = proto.writeTag(buf, n142, 1, proto.wireTypes.lengthDelimited)

		buf, n142 = proto.writeString(v2703, v2704, p214.sort_id)
	end

	if p214.display_name ~= nil and p214.display_name ~= "" then
		local v2705, v2706 = proto.writeTag(buf, n142, 2, proto.wireTypes.lengthDelimited)

		buf, n142 = proto.writeString(v2705, v2706, p214.display_name)
	end

	if p214.content_type ~= nil and p214.content_type ~= "" then
		local v2707, v2708 = proto.writeTag(buf, n142, 3, proto.wireTypes.lengthDelimited)

		buf, n142 = proto.writeString(v2707, v2708, p214.content_type)
	end

	local buf78 = buffer.create(n142)

	buffer.copy(buf78, 0, buf, 0, n142)

	return buf78
end
function t355.decode(p215: buffer) -- line: 16074
	-- upvalues: t355 (copy), proto (copy)
	local v2711 = t355.new()
	local n143 = 0

	while n143 < buffer.len(p215) do
		local v2713, v2714

		v2713, v2714, n143 = proto.readTag(p215, n143)

		if v2714 == proto.wireTypes.varint then
			local v2715

			v2715, n143 = proto.readVarInt(p215, n143)
		elseif v2714 == proto.wireTypes.lengthDelimited then
			if v2713 == 1 then
				local v2716

				v2716, n143 = proto.readBuffer(p215, n143)
				v2711.sort_id = buffer.tostring(v2716)
			elseif v2713 == 2 then
				local v2717

				v2717, n143 = proto.readBuffer(p215, n143)
				v2711.display_name = buffer.tostring(v2717)
			elseif v2713 == 3 then
				local v2718

				v2718, n143 = proto.readBuffer(p215, n143)
				v2711.content_type = buffer.tostring(v2718)
			else
				local v2719, v2720 = proto.readVarInt(p215, n143)

				n143 = v2720 + v2719
			end
		elseif v2714 == proto.wireTypes.i32 then
			local v2721

			v2721, n143 = proto.readFixed32(p215, n143)
		elseif v2714 == proto.wireTypes.i64 then
			local v2722

			v2722, n143 = proto.readFixed64(p215, n143)
		else
			error("Unsupported wire type: " .. v2714)
		end
	end

	return v2711
end
function t355.jsonEncode(p216) -- line: 16127
	local t357 = {}

	if p216.sort_id ~= nil and p216.sort_id ~= "" then
		t357.sortId = p216.sort_id
	end

	if p216.display_name ~= nil and p216.display_name ~= "" then
		t357.displayName = p216.display_name
	end

	if p216.content_type ~= nil and p216.content_type ~= "" then
		t357.contentType = p216.content_type
	end

	return t357
end
function t355.jsonDecode(t358: {[any]: any}) -- line: 16145
	-- upvalues: t355 (copy)
	local v2726 = t355.new()

	if t358.sort_id ~= nil then
		v2726.sort_id = t358.sort_id
	end

	if t358.sortId ~= nil then
		v2726.sort_id = t358.sortId
	end

	if t358.display_name ~= nil then
		v2726.display_name = t358.display_name
	end

	if t358.displayName ~= nil then
		v2726.display_name = t358.displayName
	end

	if t358.content_type ~= nil then
		v2726.content_type = t358.content_type
	end

	if t358.contentType ~= nil then
		v2726.content_type = t358.contentType
	end

	return v2726
end

t355.descriptor = {
	name = "SortSelectorInputData_SortOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.SortOption"
}
t1.SortSelectorInputData_SortOption = t355
typeRegistry.default:register(t1.SortSelectorInputData_SortOption)

local t359 = {}

t359.__index = t359

function t359.new(t360: {[any]: any}?) -- line: 16191
	-- upvalues: t359 (copy)
	return (setmetatable({
		id = if t360 ~= nil and t360.id ~= nil then t360.id else "",
		preview_rows = if t360 ~= nil and t360.preview_rows ~= nil then t360.preview_rows else 0,
		widget_style = if t360 ~= nil and t360.widget_style ~= nil then t360.widget_style else nil,
		see_all_button = t360 ~= nil and (t360.see_all_button ~= nil and t360.see_all_button),
		information_popover_text = if t360 ~= nil and t360.information_popover_text ~= nil then t360.information_popover_text else ""
	}, t359))
end
function t359.encode(p217) -- line: 16205
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n144 = 0

	if p217.id ~= nil and p217.id ~= "" then
		local v2731, v2732 = proto.writeTag(buf, n144, 1, proto.wireTypes.lengthDelimited)

		buf, n144 = proto.writeString(v2731, v2732, p217.id)
	end

	if p217.preview_rows ~= nil and p217.preview_rows ~= 0 then
		local v2733, v2734 = proto.writeTag(buf, n144, 4, proto.wireTypes.varint)

		buf, n144 = proto.writeVarInt(v2733, v2734, p217.preview_rows)
	end

	if p217.widget_style ~= nil then
		local v2735 = p217.widget_style:encode()
		local v2736, v2737 = proto.writeTag(buf, n144, 3, proto.wireTypes.lengthDelimited)

		buf, n144 = proto.writeBuffer(v2736, v2737, v2735, buffer.len(v2735))
	end

	if p217.see_all_button then
		local v2738, v2739 = proto.writeTag(buf, n144, 5, proto.wireTypes.varint)

		buf, n144 = proto.writeVarInt(v2738, v2739, not p217.see_all_button and 0 or 1)
	end

	if p217.information_popover_text ~= nil and p217.information_popover_text ~= "" then
		local v2740, v2741 = proto.writeTag(buf, n144, 6, proto.wireTypes.lengthDelimited)

		buf, n144 = proto.writeString(v2740, v2741, p217.information_popover_text)
	end

	local buf79 = buffer.create(n144)

	buffer.copy(buf79, 0, buf, 0, n144)

	return buf79
end
function t359.decode(p218: buffer) -- line: 16240
	-- upvalues: t359 (copy), proto (copy), t1 (copy)
	local v2744 = t359.new()
	local n145 = 0

	while n145 < buffer.len(p218) do
		local v2746, v2747

		v2746, v2747, n145 = proto.readTag(p218, n145)

		if v2747 == proto.wireTypes.varint then
			if v2746 == 4 then
				local v2748

				v2748, n145 = proto.readVarIntI64(p218, n145)
				v2744.preview_rows = v2748
			elseif v2746 == 5 then
				local v2749

				v2749, n145 = proto.readVarInt(p218, n145)
				v2744.see_all_button = v2749 ~= 0
			else
				local v2750

				v2750, n145 = proto.readVarInt(p218, n145)
			end
		elseif v2747 == proto.wireTypes.lengthDelimited then
			if v2746 == 1 then
				local v2751

				v2751, n145 = proto.readBuffer(p218, n145)
				v2744.id = buffer.tostring(v2751)
			elseif v2746 == 3 then
				local v2752

				v2752, n145 = proto.readBuffer(p218, n145)
				v2744.widget_style = t1.WidgetStyleData.decode(v2752)
			elseif v2746 == 6 then
				local v2753

				v2753, n145 = proto.readBuffer(p218, n145)
				v2744.information_popover_text = buffer.tostring(v2753)
			else
				local v2754, v2755 = proto.readVarInt(p218, n145)

				n145 = v2755 + v2754
			end
		elseif v2747 == proto.wireTypes.i32 then
			local v2756

			v2756, n145 = proto.readFixed32(p218, n145)
		elseif v2747 == proto.wireTypes.i64 then
			local v2757

			v2757, n145 = proto.readFixed64(p218, n145)
		else
			error("Unsupported wire type: " .. v2747)
		end
	end

	return v2744
end
function t359.jsonEncode(p219) -- line: 16303
	local t361 = {}

	if p219.id ~= nil and p219.id ~= "" then
		t361.id = p219.id
	end

	if p219.preview_rows ~= nil and p219.preview_rows ~= 0 then
		t361.previewRows = p219.preview_rows
	end

	if p219.widget_style ~= nil then
		t361.widgetStyle = p219.widget_style:jsonEncode()
	end

	if p219.see_all_button then
		t361.seeAllButton = p219.see_all_button
	end

	if p219.information_popover_text ~= nil and p219.information_popover_text ~= "" then
		t361.informationPopoverText = p219.information_popover_text
	end

	return t361
end
function t359.jsonDecode(t362: {[any]: any}) -- line: 16329
	-- upvalues: t359 (copy), t1 (copy)
	local v2761 = t359.new()

	if t362.id ~= nil then
		v2761.id = t362.id
	end

	if t362.preview_rows ~= nil then
		v2761.preview_rows = t362.preview_rows
	end

	if t362.previewRows ~= nil then
		v2761.preview_rows = t362.previewRows
	end

	if t362.widget_style ~= nil then
		v2761.widget_style = t1.WidgetStyleData.jsonDecode(t362.widget_style)
	end

	if t362.widgetStyle ~= nil then
		v2761.widget_style = t1.WidgetStyleData.jsonDecode(t362.widgetStyle)
	end

	if t362.see_all_button ~= nil then
		v2761.see_all_button = t362.see_all_button
	end

	if t362.seeAllButton ~= nil then
		v2761.see_all_button = t362.seeAllButton
	end

	if t362.information_popover_text ~= nil then
		v2761.information_popover_text = t362.information_popover_text
	end

	if t362.informationPopoverText ~= nil then
		v2761.information_popover_text = t362.informationPopoverText
	end

	return v2761
end

t359.descriptor = {
	name = "UAMarketplaceCatalogItemGroupInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UAMarketplaceCatalogItemGroupInputData"
}
t1.UAMarketplaceCatalogItemGroupInputData = t359
typeRegistry.default:register(t1.UAMarketplaceCatalogItemGroupInputData)

local t363 = {}

t363.__index = t363

function t363.new(t364: {[any]: any}?) -- line: 16387
	-- upvalues: t363 (copy)
	return (setmetatable({
		id = if t364 ~= nil and t364.id ~= nil then t364.id else "",
		num_items_to_show = if t364 ~= nil and t364.num_items_to_show ~= nil then t364.num_items_to_show else 0,
		widget_style = if t364 ~= nil and t364.widget_style ~= nil then t364.widget_style else nil,
		see_all_button = t364 ~= nil and (t364.see_all_button ~= nil and t364.see_all_button),
		information_popover_text = if t364 ~= nil and t364.information_popover_text ~= nil then t364.information_popover_text else ""
	}, t363))
end
function t363.encode(p220) -- line: 16401
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n146 = 0

	if p220.id ~= nil and p220.id ~= "" then
		local v2766, v2767 = proto.writeTag(buf, n146, 1, proto.wireTypes.lengthDelimited)

		buf, n146 = proto.writeString(v2766, v2767, p220.id)
	end

	if p220.num_items_to_show ~= nil and p220.num_items_to_show ~= 0 then
		local v2768, v2769 = proto.writeTag(buf, n146, 5, proto.wireTypes.varint)

		buf, n146 = proto.writeVarInt(v2768, v2769, p220.num_items_to_show)
	end

	if p220.widget_style ~= nil then
		local v2770 = p220.widget_style:encode()
		local v2771, v2772 = proto.writeTag(buf, n146, 3, proto.wireTypes.lengthDelimited)

		buf, n146 = proto.writeBuffer(v2771, v2772, v2770, buffer.len(v2770))
	end

	if p220.see_all_button then
		local v2773, v2774 = proto.writeTag(buf, n146, 6, proto.wireTypes.varint)

		buf, n146 = proto.writeVarInt(v2773, v2774, not p220.see_all_button and 0 or 1)
	end

	if p220.information_popover_text ~= nil and p220.information_popover_text ~= "" then
		local v2775, v2776 = proto.writeTag(buf, n146, 7, proto.wireTypes.lengthDelimited)

		buf, n146 = proto.writeString(v2775, v2776, p220.information_popover_text)
	end

	local buf80 = buffer.create(n146)

	buffer.copy(buf80, 0, buf, 0, n146)

	return buf80
end
function t363.decode(p221: buffer) -- line: 16438
	-- upvalues: t363 (copy), proto (copy), t1 (copy)
	local v2779 = t363.new()
	local n147 = 0

	while n147 < buffer.len(p221) do
		local v2781, v2782

		v2781, v2782, n147 = proto.readTag(p221, n147)

		if v2782 == proto.wireTypes.varint then
			if v2781 == 5 then
				local v2783

				v2783, n147 = proto.readVarIntI64(p221, n147)
				v2779.num_items_to_show = v2783
			elseif v2781 == 6 then
				local v2784

				v2784, n147 = proto.readVarInt(p221, n147)
				v2779.see_all_button = v2784 ~= 0
			else
				local v2785

				v2785, n147 = proto.readVarInt(p221, n147)
			end
		elseif v2782 == proto.wireTypes.lengthDelimited then
			if v2781 == 1 then
				local v2786

				v2786, n147 = proto.readBuffer(p221, n147)
				v2779.id = buffer.tostring(v2786)
			elseif v2781 == 3 then
				local v2787

				v2787, n147 = proto.readBuffer(p221, n147)
				v2779.widget_style = t1.WidgetStyleData.decode(v2787)
			elseif v2781 == 7 then
				local v2788

				v2788, n147 = proto.readBuffer(p221, n147)
				v2779.information_popover_text = buffer.tostring(v2788)
			else
				local v2789, v2790 = proto.readVarInt(p221, n147)

				n147 = v2790 + v2789
			end
		elseif v2782 == proto.wireTypes.i32 then
			local v2791

			v2791, n147 = proto.readFixed32(p221, n147)
		elseif v2782 == proto.wireTypes.i64 then
			local v2792

			v2792, n147 = proto.readFixed64(p221, n147)
		else
			error("Unsupported wire type: " .. v2782)
		end
	end

	return v2779
end
function t363.jsonEncode(p222) -- line: 16503
	local t365 = {}

	if p222.id ~= nil and p222.id ~= "" then
		t365.id = p222.id
	end

	if p222.num_items_to_show ~= nil and p222.num_items_to_show ~= 0 then
		t365.numItemsToShow = p222.num_items_to_show
	end

	if p222.widget_style ~= nil then
		t365.widgetStyle = p222.widget_style:jsonEncode()
	end

	if p222.see_all_button then
		t365.seeAllButton = p222.see_all_button
	end

	if p222.information_popover_text ~= nil and p222.information_popover_text ~= "" then
		t365.informationPopoverText = p222.information_popover_text
	end

	return t365
end
function t363.jsonDecode(t366: {[any]: any}) -- line: 16531
	-- upvalues: t363 (copy), t1 (copy)
	local v2796 = t363.new()

	if t366.id ~= nil then
		v2796.id = t366.id
	end

	if t366.num_items_to_show ~= nil then
		v2796.num_items_to_show = t366.num_items_to_show
	end

	if t366.numItemsToShow ~= nil then
		v2796.num_items_to_show = t366.numItemsToShow
	end

	if t366.widget_style ~= nil then
		v2796.widget_style = t1.WidgetStyleData.jsonDecode(t366.widget_style)
	end

	if t366.widgetStyle ~= nil then
		v2796.widget_style = t1.WidgetStyleData.jsonDecode(t366.widgetStyle)
	end

	if t366.see_all_button ~= nil then
		v2796.see_all_button = t366.see_all_button
	end

	if t366.seeAllButton ~= nil then
		v2796.see_all_button = t366.seeAllButton
	end

	if t366.information_popover_text ~= nil then
		v2796.information_popover_text = t366.information_popover_text
	end

	if t366.informationPopoverText ~= nil then
		v2796.information_popover_text = t366.informationPopoverText
	end

	return v2796
end

t363.descriptor = {
	name = "UAMarketplaceCatalogItemCarouselInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UAMarketplaceCatalogItemCarouselInputData"
}
t1.UAMarketplaceCatalogItemCarouselInputData = t363
typeRegistry.default:register(t1.UAMarketplaceCatalogItemCarouselInputData)

local t367 = {}

t367.__index = t367

function t367.new(t368: {[any]: any}?) -- line: 16589
	-- upvalues: t367 (copy)
	return (setmetatable({
		background_layers = if t368 ~= nil and t368.background_layers ~= nil then t368.background_layers else {}
	}, t367))
end
function t367.encode(p223) -- line: 16595
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n148 = 0

	if p223.background_layers ~= nil and #p223.background_layers > 0 then
		for _, v2802 in p223.background_layers do
			local v2803 = v2802:encode()
			local v2804, v2805 = proto.writeTag(buf, n148, 1, proto.wireTypes.lengthDelimited)

			buf, n148 = proto.writeBuffer(v2804, v2805, v2803, buffer.len(v2803))
		end
	end

	local buf81 = buffer.create(n148)

	buffer.copy(buf81, 0, buf, 0, n148)

	return buf81
end
function t367.decode(p224: buffer) -- line: 16612
	-- upvalues: t367 (copy), proto (copy), background_layer (copy)
	local v2808 = t367.new()
	local n149 = 0

	while n149 < buffer.len(p224) do
		local v2810, v2811

		v2810, v2811, n149 = proto.readTag(p224, n149)

		if v2811 == proto.wireTypes.varint then
			local v2812

			v2812, n149 = proto.readVarInt(p224, n149)
		elseif v2811 == proto.wireTypes.lengthDelimited then
			if v2810 == 1 then
				local v2813

				v2813, n149 = proto.readBuffer(p224, n149)
				table.insert(v2808.background_layers, background_layer.BackgroundLayer.decode(v2813))
			else
				local v2814, v2815 = proto.readVarInt(p224, n149)

				n149 = v2815 + v2814
			end
		elseif v2811 == proto.wireTypes.i32 then
			local v2816

			v2816, n149 = proto.readFixed32(p224, n149)
		elseif v2811 == proto.wireTypes.i64 then
			local v2817

			v2817, n149 = proto.readFixed64(p224, n149)
		else
			error("Unsupported wire type: " .. v2811)
		end
	end

	return v2808
end
function t367.jsonEncode(p225) -- line: 16658
	local t369 = {}

	if p225.background_layers ~= nil and #p225.background_layers > 0 then
		local t370 = {}

		for _, v2822 in p225.background_layers do
			table.insert(t370, v2822:jsonEncode())
		end

		t369.backgroundLayers = t370
	end

	return t369
end
function t367.jsonDecode(t371: {[any]: any}) -- line: 16672
	-- upvalues: t367 (copy), background_layer (copy)
	local v2824 = t367.new()

	if t371.background_layers ~= nil then
		local t372 = {}

		for _, v2827 in t371.background_layers do
			table.insert(t372, background_layer.BackgroundLayer.jsonDecode(v2827))
		end

		v2824.background_layers = t372
	end

	if t371.backgroundLayers ~= nil then
		local t373 = {}

		for _, v2830 in t371.backgroundLayers do
			table.insert(t373, background_layer.BackgroundLayer.jsonDecode(v2830))
		end

		v2824.background_layers = t373
	end

	return v2824
end

t367.descriptor = {
	name = "WidgetStyleData",
	fullName = "roblox.apppageplatform.shared.v1beta1.WidgetStyleData"
}
t1.WidgetStyleData = t367
typeRegistry.default:register(t1.WidgetStyleData)

local t374 = {}

t374.__index = t374

function t374.new(t375: {[any]: any}?) -- line: 16716
	-- upvalues: t374 (copy)
	return (setmetatable({
		id = if t375 ~= nil and t375.id ~= nil then t375.id else "",
		available_until = if t375 ~= nil and t375.available_until ~= nil then t375.available_until else "",
		widget_style = if t375 ~= nil and t375.widget_style ~= nil then t375.widget_style else nil
	}, t374))
end
function t374.encode(p226) -- line: 16726
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n150 = 0

	if p226.id ~= nil and p226.id ~= "" then
		local v2835, v2836 = proto.writeTag(buf, n150, 1, proto.wireTypes.lengthDelimited)

		buf, n150 = proto.writeString(v2835, v2836, p226.id)
	end

	if p226.available_until ~= nil and p226.available_until ~= "" then
		local v2837, v2838 = proto.writeTag(buf, n150, 2, proto.wireTypes.lengthDelimited)

		buf, n150 = proto.writeString(v2837, v2838, p226.available_until)
	end

	if p226.widget_style ~= nil then
		local v2839 = p226.widget_style:encode()
		local v2840, v2841 = proto.writeTag(buf, n150, 3, proto.wireTypes.lengthDelimited)

		buf, n150 = proto.writeBuffer(v2840, v2841, v2839, buffer.len(v2839))
	end

	local buf82 = buffer.create(n150)

	buffer.copy(buf82, 0, buf, 0, n150)

	return buf82
end
function t374.decode(p227: buffer) -- line: 16751
	-- upvalues: t374 (copy), proto (copy), t1 (copy)
	local v2844 = t374.new()
	local n151 = 0

	while n151 < buffer.len(p227) do
		local v2846, v2847

		v2846, v2847, n151 = proto.readTag(p227, n151)

		if v2847 == proto.wireTypes.varint then
			local v2848

			v2848, n151 = proto.readVarInt(p227, n151)
		elseif v2847 == proto.wireTypes.lengthDelimited then
			if v2846 == 1 then
				local v2849

				v2849, n151 = proto.readBuffer(p227, n151)
				v2844.id = buffer.tostring(v2849)
			elseif v2846 == 2 then
				local v2850

				v2850, n151 = proto.readBuffer(p227, n151)
				v2844.available_until = buffer.tostring(v2850)
			elseif v2846 == 3 then
				local v2851

				v2851, n151 = proto.readBuffer(p227, n151)
				v2844.widget_style = t1.WidgetStyleData.decode(v2851)
			else
				local v2852, v2853 = proto.readVarInt(p227, n151)

				n151 = v2853 + v2852
			end
		elseif v2847 == proto.wireTypes.i32 then
			local v2854

			v2854, n151 = proto.readFixed32(p227, n151)
		elseif v2847 == proto.wireTypes.i64 then
			local v2855

			v2855, n151 = proto.readFixed64(p227, n151)
		else
			error("Unsupported wire type: " .. v2847)
		end
	end

	return v2844
end
function t374.jsonEncode(p228) -- line: 16804
	local t376 = {}

	if p228.id ~= nil and p228.id ~= "" then
		t376.id = p228.id
	end

	if p228.available_until ~= nil and p228.available_until ~= "" then
		t376.availableUntil = p228.available_until
	end

	if p228.widget_style ~= nil then
		t376.widgetStyle = p228.widget_style:jsonEncode()
	end

	return t376
end
function t374.jsonDecode(t377: {[any]: any}) -- line: 16822
	-- upvalues: t374 (copy), t1 (copy)
	local v2859 = t374.new()

	if t377.id ~= nil then
		v2859.id = t377.id
	end

	if t377.available_until ~= nil then
		v2859.available_until = t377.available_until
	end

	if t377.availableUntil ~= nil then
		v2859.available_until = t377.availableUntil
	end

	if t377.widget_style ~= nil then
		v2859.widget_style = t1.WidgetStyleData.jsonDecode(t377.widget_style)
	end

	if t377.widgetStyle ~= nil then
		v2859.widget_style = t1.WidgetStyleData.jsonDecode(t377.widgetStyle)
	end

	return v2859
end

t374.descriptor = {
	name = "UAMarketplaceCatalogHeroUnitInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UAMarketplaceCatalogHeroUnitInputData"
}
t1.UAMarketplaceCatalogHeroUnitInputData = t374
typeRegistry.default:register(t1.UAMarketplaceCatalogHeroUnitInputData)

local t378 = {}

t378.__index = t378

function t378.new(t379: {[any]: any}?) -- line: 16864
	-- upvalues: t378 (copy)
	return (setmetatable({
		entry_map = if t379 ~= nil and t379.entry_map ~= nil then t379.entry_map else {},
		entry_order = if t379 ~= nil and t379.entry_order ~= nil then t379.entry_order else {}
	}, t378))
end
function t378.encode(p229) -- line: 16873
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n152 = 0

	if p229.entry_map ~= nil and next(p229.entry_map) ~= nil then
		for v2864, v2865 in p229.entry_map do
			local buf83 = buffer.create(0)
			local v2867, v2868 = proto.writeTag(buf83, 0, 1, proto.wireTypes.lengthDelimited)
			local v2869, v2870 = proto.writeString(v2867, v2868, v2864)
			local v2871 = v2865:encode()
			local v2872, v2873 = proto.writeTag(v2869, v2870, 2, proto.wireTypes.lengthDelimited)
			local v2874, v2875 = proto.writeBuffer(v2872, v2873, v2871, buffer.len(v2871))
			local v2876, v2877 = proto.writeTag(buf, n152, 1, proto.wireTypes.lengthDelimited)

			buf, n152 = proto.writeBuffer(v2876, v2877, v2874, v2875)
		end
	end

	if p229.entry_order ~= nil and #p229.entry_order > 0 then
		for _, v2879 in p229.entry_order do
			local v2880, v2881 = proto.writeTag(buf, n152, 2, proto.wireTypes.lengthDelimited)

			buf, n152 = proto.writeString(v2880, v2881, v2879)
		end
	end

	local buf84 = buffer.create(n152)

	buffer.copy(buf84, 0, buf, 0, n152)

	return buf84
end
function t378.decode(p230: buffer) -- line: 16903
	-- upvalues: t378 (copy), proto (copy), t1 (copy)
	local v2884 = t378.new()
	local n153 = 0

	while n153 < buffer.len(p230) do
		local v2886, v2887

		v2886, v2887, n153 = proto.readTag(p230, n153)

		if v2887 == proto.wireTypes.varint then
			local v2888

			v2888, n153 = proto.readVarInt(p230, n153)
		elseif v2887 == proto.wireTypes.lengthDelimited then
			if v2886 == 1 then
				local v2889

				v2889, n153 = proto.readBuffer(p230, n153)

				local v2890 = t1.UAMarketplaceCatalogFeedInputData_EntryMapEntry.decode(v2889)
				local v2891 = t1.FeedEntry.new()

				v2884.entry_map[v2890.key or ""] = v2890.value or v2891
			elseif v2886 == 2 then
				local v2892

				v2892, n153 = proto.readBuffer(p230, n153)
				table.insert(v2884.entry_order, buffer.tostring(v2892))
			else
				local v2893, v2894 = proto.readVarInt(p230, n153)

				n153 = v2894 + v2893
			end
		elseif v2887 == proto.wireTypes.i32 then
			local v2895

			v2895, n153 = proto.readFixed32(p230, n153)
		elseif v2887 == proto.wireTypes.i64 then
			local v2896

			v2896, n153 = proto.readFixed64(p230, n153)
		else
			error("Unsupported wire type: " .. v2887)
		end
	end

	return v2884
end
function t378.jsonEncode(p231) -- line: 16958
	local t380 = {}

	if p231.entry_map ~= nil and next(p231.entry_map) ~= nil then
		local t381 = {}

		for v2900, v2901 in p231.entry_map do
			t381[v2900] = v2901:jsonEncode()
		end

		t380.entryMap = t381
	end

	if p231.entry_order ~= nil and #p231.entry_order > 0 then
		local t382 = {}

		for _, v2904 in p231.entry_order do
			table.insert(t382, v2904)
		end

		t380.entryOrder = t382
	end

	return t380
end
function t378.jsonDecode(t383: {[any]: any}) -- line: 16980
	-- upvalues: t378 (copy), t1 (copy)
	local v2906 = t378.new()

	if t383.entry_map ~= nil then
		local t384 = {}

		for v2908, v2909 in t383.entry_map do
			t384[v2908] = t1.FeedEntry.jsonDecode(v2909)
		end

		v2906.entry_map = t384
	end

	if t383.entryMap ~= nil then
		local t385 = {}

		for v2911, v2912 in t383.entryMap do
			t385[v2911] = t1.FeedEntry.jsonDecode(v2912)
		end

		v2906.entry_map = t385
	end

	if t383.entry_order ~= nil then
		local t386 = {}

		for _, v2915 in t383.entry_order do
			table.insert(t386, v2915)
		end

		v2906.entry_order = t386
	end

	if t383.entryOrder ~= nil then
		local t387 = {}

		for _, v2918 in t383.entryOrder do
			table.insert(t387, v2918)
		end

		v2906.entry_order = t387
	end

	return v2906
end

t378.descriptor = {
	name = "UAMarketplaceCatalogFeedInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UAMarketplaceCatalogFeedInputData"
}
t1.UAMarketplaceCatalogFeedInputData = t378
typeRegistry.default:register(t1.UAMarketplaceCatalogFeedInputData)

local t388 = {}

t388.__index = t388

function t388.new(t389: {[any]: any}?) -- line: 17038
	-- upvalues: t388 (copy)
	return (setmetatable({
		key = if t389 ~= nil and t389.key ~= nil then t389.key else "",
		value = if t389 ~= nil and t389.value ~= nil then t389.value else nil
	}, t388))
end
function t388.encode(p232) -- line: 17047
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n154 = 0

	if p232.key ~= nil and p232.key ~= "" then
		local v2923, v2924 = proto.writeTag(buf, n154, 1, proto.wireTypes.lengthDelimited)

		buf, n154 = proto.writeString(v2923, v2924, p232.key)
	end

	if p232.value ~= nil then
		local v2925 = p232.value:encode()
		local v2926, v2927 = proto.writeTag(buf, n154, 2, proto.wireTypes.lengthDelimited)

		buf, n154 = proto.writeBuffer(v2926, v2927, v2925, buffer.len(v2925))
	end

	local buf85 = buffer.create(n154)

	buffer.copy(buf85, 0, buf, 0, n154)

	return buf85
end
function t388.decode(p233: buffer) -- line: 17069
	-- upvalues: t388 (copy), proto (copy), t1 (copy)
	local v2930 = t388.new()
	local n155 = 0

	while n155 < buffer.len(p233) do
		local v2932, v2933

		v2932, v2933, n155 = proto.readTag(p233, n155)

		if v2933 == proto.wireTypes.varint then
			local v2934

			v2934, n155 = proto.readVarInt(p233, n155)
		elseif v2933 == proto.wireTypes.lengthDelimited then
			if v2932 == 1 then
				local v2935

				v2935, n155 = proto.readBuffer(p233, n155)
				v2930.key = buffer.tostring(v2935)
			elseif v2932 == 2 then
				local v2936

				v2936, n155 = proto.readBuffer(p233, n155)
				v2930.value = t1.FeedEntry.decode(v2936)
			else
				local v2937, v2938 = proto.readVarInt(p233, n155)

				n155 = v2938 + v2937
			end
		elseif v2933 == proto.wireTypes.i32 then
			local v2939

			v2939, n155 = proto.readFixed32(p233, n155)
		elseif v2933 == proto.wireTypes.i64 then
			local v2940

			v2940, n155 = proto.readFixed64(p233, n155)
		else
			error("Unsupported wire type: " .. v2933)
		end
	end

	return v2930
end
function t388.jsonEncode(p234) -- line: 17119
	local t390 = {}

	if p234.key ~= nil and p234.key ~= "" then
		t390.key = p234.key
	end

	if p234.value ~= nil then
		t390.value = p234.value:jsonEncode()
	end

	return t390
end
function t388.jsonDecode(t391: {[any]: any}) -- line: 17135
	-- upvalues: t388 (copy), t1 (copy)
	local v2944 = t388.new()

	if t391.key ~= nil then
		v2944.key = t391.key
	end

	if t391.value ~= nil then
		v2944.value = t1.FeedEntry.jsonDecode(t391.value)
	end

	return v2944
end

t388.descriptor = {
	name = "UAMarketplaceCatalogFeedInputData_EntryMapEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryMapEntry"
}
t1.UAMarketplaceCatalogFeedInputData_EntryMapEntry = t388
typeRegistry.default:register(t1.UAMarketplaceCatalogFeedInputData_EntryMapEntry)

local t392 = {}

t392.__index = t392

function t392.new(t393: {[any]: any}?) -- line: 17166
	-- upvalues: t392 (copy)
	return (setmetatable({
		marketplace_catalog_category_items = if t393 ~= nil and t393.marketplace_catalog_category_items ~= nil then t393.marketplace_catalog_category_items else {},
		active_category_id = if t393 ~= nil and t393.active_category_id ~= nil then t393.active_category_id else "",
		active_tooltip_idx = if t393 ~= nil and t393.active_tooltip_idx ~= nil then t393.active_tooltip_idx else 0
	}, t392))
end
function t392.encode(p235) -- line: 17179
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n156 = 0

	if p235.marketplace_catalog_category_items ~= nil and #p235.marketplace_catalog_category_items > 0 then
		for _, v2950 in p235.marketplace_catalog_category_items do
			local v2951 = v2950:encode()
			local v2952, v2953 = proto.writeTag(buf, n156, 1, proto.wireTypes.lengthDelimited)

			buf, n156 = proto.writeBuffer(v2952, v2953, v2951, buffer.len(v2951))
		end
	end

	if p235.active_category_id ~= nil and p235.active_category_id ~= "" then
		local v2954, v2955 = proto.writeTag(buf, n156, 2, proto.wireTypes.lengthDelimited)

		buf, n156 = proto.writeString(v2954, v2955, p235.active_category_id)
	end

	if p235.active_tooltip_idx ~= nil and p235.active_tooltip_idx ~= 0 then
		local v2956, v2957 = proto.writeTag(buf, n156, 3, proto.wireTypes.varint)

		buf, n156 = proto.writeVarInt(v2956, v2957, p235.active_tooltip_idx)
	end

	local buf86 = buffer.create(n156)

	buffer.copy(buf86, 0, buf, 0, n156)

	return buf86
end
function t392.decode(p236: buffer) -- line: 17208
	-- upvalues: t392 (copy), proto (copy), t1 (copy)
	local v2960 = t392.new()
	local n157 = 0

	while n157 < buffer.len(p236) do
		local v2962, v2963

		v2962, v2963, n157 = proto.readTag(p236, n157)

		if v2963 == proto.wireTypes.varint then
			if v2962 == 3 then
				local v2964

				v2964, n157 = proto.readVarIntI64(p236, n157)
				v2960.active_tooltip_idx = v2964
			else
				local v2965

				v2965, n157 = proto.readVarInt(p236, n157)
			end
		elseif v2963 == proto.wireTypes.lengthDelimited then
			if v2962 == 1 then
				local v2966

				v2966, n157 = proto.readBuffer(p236, n157)
				table.insert(v2960.marketplace_catalog_category_items, t1.UAMarketplaceCatalogCategoryMenuInputData_MarketplaceCatalogCategoryItem.decode(v2966))
			elseif v2962 == 2 then
				local v2967

				v2967, n157 = proto.readBuffer(p236, n157)
				v2960.active_category_id = buffer.tostring(v2967)
			else
				local v2968, v2969 = proto.readVarInt(p236, n157)

				n157 = v2969 + v2968
			end
		elseif v2963 == proto.wireTypes.i32 then
			local v2970

			v2970, n157 = proto.readFixed32(p236, n157)
		elseif v2963 == proto.wireTypes.i64 then
			local v2971

			v2971, n157 = proto.readFixed64(p236, n157)
		else
			error("Unsupported wire type: " .. v2963)
		end
	end

	return v2960
end
function t392.jsonEncode(p237) -- line: 17266
	local t394 = {}

	if p237.marketplace_catalog_category_items ~= nil and #p237.marketplace_catalog_category_items > 0 then
		local t395 = {}

		for _, v2976 in p237.marketplace_catalog_category_items do
			table.insert(t395, v2976:jsonEncode())
		end

		t394.marketplaceCatalogCategoryItems = t395
	end

	if p237.active_category_id ~= nil and p237.active_category_id ~= "" then
		t394.activeCategoryId = p237.active_category_id
	end

	if p237.active_tooltip_idx ~= nil and p237.active_tooltip_idx ~= 0 then
		t394.activeTooltipIdx = p237.active_tooltip_idx
	end

	return t394
end
function t392.jsonDecode(t396: {[any]: any}) -- line: 17290
	-- upvalues: t392 (copy), t1 (copy)
	local v2978 = t392.new()

	if t396.marketplace_catalog_category_items ~= nil then
		local t397 = {}

		for _, v2981 in t396.marketplace_catalog_category_items do
			table.insert(t397, t1.UAMarketplaceCatalogCategoryMenuInputData_MarketplaceCatalogCategoryItem.jsonDecode(v2981))
		end

		v2978.marketplace_catalog_category_items = t397
	end

	if t396.marketplaceCatalogCategoryItems ~= nil then
		local t398 = {}

		for _, v2984 in t396.marketplaceCatalogCategoryItems do
			table.insert(t398, t1.UAMarketplaceCatalogCategoryMenuInputData_MarketplaceCatalogCategoryItem.jsonDecode(v2984))
		end

		v2978.marketplace_catalog_category_items = t398
	end

	if t396.active_category_id ~= nil then
		v2978.active_category_id = t396.active_category_id
	end

	if t396.activeCategoryId ~= nil then
		v2978.active_category_id = t396.activeCategoryId
	end

	if t396.active_tooltip_idx ~= nil then
		v2978.active_tooltip_idx = t396.active_tooltip_idx
	end

	if t396.activeTooltipIdx ~= nil then
		v2978.active_tooltip_idx = t396.activeTooltipIdx
	end

	return v2978
end

t392.descriptor = {
	name = "UAMarketplaceCatalogCategoryMenuInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UAMarketplaceCatalogCategoryMenuInputData"
}
t1.UAMarketplaceCatalogCategoryMenuInputData = t392
typeRegistry.default:register(t1.UAMarketplaceCatalogCategoryMenuInputData)

local t399 = {}

t399.__index = t399

function t399.new(t400: {[any]: any}?) -- line: 17353
	-- upvalues: t399 (copy)
	return (setmetatable({
		marketplace_catalog_category_item_id = if t400 ~= nil and t400.marketplace_catalog_category_item_id ~= nil then t400.marketplace_catalog_category_item_id else ""
	}, t399))
end
function t399.encode(p238) -- line: 17367
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n158 = 0

	if p238.marketplace_catalog_category_item_id ~= nil and p238.marketplace_catalog_category_item_id ~= "" then
		local v2989, v2990 = proto.writeTag(buf, n158, 1, proto.wireTypes.lengthDelimited)

		buf, n158 = proto.writeString(v2989, v2990, p238.marketplace_catalog_category_item_id)
	end

	local buf87 = buffer.create(n158)

	buffer.copy(buf87, 0, buf, 0, n158)

	return buf87
end
function t399.decode(p239: buffer) -- line: 17383
	-- upvalues: t399 (copy), proto (copy)
	local v2993 = t399.new()
	local n159 = 0

	while n159 < buffer.len(p239) do
		local v2995, v2996

		v2995, v2996, n159 = proto.readTag(p239, n159)

		if v2996 == proto.wireTypes.varint then
			local v2997

			v2997, n159 = proto.readVarInt(p239, n159)
		elseif v2996 == proto.wireTypes.lengthDelimited then
			if v2995 == 1 then
				local v2998

				v2998, n159 = proto.readBuffer(p239, n159)
				v2993.marketplace_catalog_category_item_id = buffer.tostring(v2998)
			else
				local v2999, v3000 = proto.readVarInt(p239, n159)

				n159 = v3000 + v2999
			end
		elseif v2996 == proto.wireTypes.i32 then
			local v3001

			v3001, n159 = proto.readFixed32(p239, n159)
		elseif v2996 == proto.wireTypes.i64 then
			local v3002

			v3002, n159 = proto.readFixed64(p239, n159)
		else
			error("Unsupported wire type: " .. v2996)
		end
	end

	return v2993
end
function t399.jsonEncode(p240) -- line: 17428
	local t401 = {}

	if p240.marketplace_catalog_category_item_id ~= nil and p240.marketplace_catalog_category_item_id ~= "" then
		t401.marketplaceCatalogCategoryItemId = p240.marketplace_catalog_category_item_id
	end

	return t401
end
function t399.jsonDecode(t402: {[any]: any}) -- line: 17440
	-- upvalues: t399 (copy)
	local v3006 = t399.new()

	if t402.marketplace_catalog_category_item_id ~= nil then
		v3006.marketplace_catalog_category_item_id = t402.marketplace_catalog_category_item_id
	end

	if t402.marketplaceCatalogCategoryItemId ~= nil then
		v3006.marketplace_catalog_category_item_id = t402.marketplaceCatalogCategoryItemId
	end

	return v3006
end

t399.descriptor = {
	name = "UAMarketplaceCatalogCategoryMenuInputData_MarketplaceCatalogCategoryItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.MarketplaceCatalogCategoryItem"
}
t1.UAMarketplaceCatalogCategoryMenuInputData_MarketplaceCatalogCategoryItem = t399
typeRegistry.default:register(t1.UAMarketplaceCatalogCategoryMenuInputData_MarketplaceCatalogCategoryItem)

local t403 = {}

t403.__index = t403

function t403.new(t404: {[any]: any}?) -- line: 17473
	-- upvalues: t403 (copy)
	return (setmetatable({
		items = if t404 ~= nil and t404.items ~= nil then t404.items else {},
		preview_columns = if t404 ~= nil and t404.preview_columns ~= nil then t404.preview_columns else 0,
		impression_id = if t404 ~= nil and t404.impression_id ~= nil then t404.impression_id else ""
	}, t403))
end
function t403.encode(p241) -- line: 17481
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n160 = 0

	if p241.items ~= nil and #p241.items > 0 then
		for _, v3012 in p241.items do
			local v3013 = v3012:encode()
			local v3014, v3015 = proto.writeTag(buf, n160, 1, proto.wireTypes.lengthDelimited)

			buf, n160 = proto.writeBuffer(v3014, v3015, v3013, buffer.len(v3013))
		end
	end

	if p241.preview_columns ~= nil and p241.preview_columns ~= 0 then
		local v3016, v3017 = proto.writeTag(buf, n160, 2, proto.wireTypes.varint)

		buf, n160 = proto.writeVarInt(v3016, v3017, p241.preview_columns)
	end

	if p241.impression_id ~= nil and p241.impression_id ~= "" then
		local v3018, v3019 = proto.writeTag(buf, n160, 3, proto.wireTypes.lengthDelimited)

		buf, n160 = proto.writeString(v3018, v3019, p241.impression_id)
	end

	local buf88 = buffer.create(n160)

	buffer.copy(buf88, 0, buf, 0, n160)

	return buf88
end
function t403.decode(p242: buffer) -- line: 17508
	-- upvalues: t403 (copy), proto (copy), t1 (copy)
	local v3022 = t403.new()
	local n161 = 0

	while n161 < buffer.len(p242) do
		local v3024, v3025

		v3024, v3025, n161 = proto.readTag(p242, n161)

		if v3025 == proto.wireTypes.varint then
			if v3024 == 2 then
				local v3026

				v3026, n161 = proto.readVarIntI32(p242, n161)
				v3022.preview_columns = v3026
			else
				local v3027

				v3027, n161 = proto.readVarInt(p242, n161)
			end
		elseif v3025 == proto.wireTypes.lengthDelimited then
			if v3024 == 1 then
				local v3028

				v3028, n161 = proto.readBuffer(p242, n161)
				table.insert(v3022.items, t1.CatalogItemGridInputData_CatalogItem.decode(v3028))
			elseif v3024 == 3 then
				local v3029

				v3029, n161 = proto.readBuffer(p242, n161)
				v3022.impression_id = buffer.tostring(v3029)
			else
				local v3030, v3031 = proto.readVarInt(p242, n161)

				n161 = v3031 + v3030
			end
		elseif v3025 == proto.wireTypes.i32 then
			local v3032

			v3032, n161 = proto.readFixed32(p242, n161)
		elseif v3025 == proto.wireTypes.i64 then
			local v3033

			v3033, n161 = proto.readFixed64(p242, n161)
		else
			error("Unsupported wire type: " .. v3025)
		end
	end

	return v3022
end
function t403.jsonEncode(p243) -- line: 17561
	local t405 = {}

	if p243.items ~= nil and #p243.items > 0 then
		local t406 = {}

		for _, v3038 in p243.items do
			table.insert(t406, v3038:jsonEncode())
		end

		t405.items = t406
	end

	if p243.preview_columns ~= nil and p243.preview_columns ~= 0 then
		t405.previewColumns = p243.preview_columns
	end

	if p243.impression_id ~= nil and p243.impression_id ~= "" then
		t405.impressionId = p243.impression_id
	end

	return t405
end
function t403.jsonDecode(t407: {[any]: any}) -- line: 17583
	-- upvalues: t403 (copy), t1 (copy)
	local v3040 = t403.new()

	if t407.items ~= nil then
		local t408 = {}

		for _, v3043 in t407.items do
			table.insert(t408, t1.CatalogItemGridInputData_CatalogItem.jsonDecode(v3043))
		end

		v3040.items = t408
	end

	if t407.preview_columns ~= nil then
		v3040.preview_columns = t407.preview_columns
	end

	if t407.previewColumns ~= nil then
		v3040.preview_columns = t407.previewColumns
	end

	if t407.impression_id ~= nil then
		v3040.impression_id = t407.impression_id
	end

	if t407.impressionId ~= nil then
		v3040.impression_id = t407.impressionId
	end

	return v3040
end

t403.descriptor = {
	name = "CatalogItemGridInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CatalogItemGridInputData"
}
t1.CatalogItemGridInputData = t403
typeRegistry.default:register(t1.CatalogItemGridInputData)

local t409 = {}

t409.__index = t409

function t409.new(t410: {[any]: any}?) -- line: 17628
	-- upvalues: t409 (copy)
	return (setmetatable({
		id = if t410 ~= nil and t410.id ~= nil then t410.id else "",
		type = if t410 ~= nil and t410.type ~= nil then t410.type else ""
	}, t409))
end
function t409.encode(p244) -- line: 17637
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n162 = 0

	if p244.id ~= nil and p244.id ~= "" then
		local v3048, v3049 = proto.writeTag(buf, n162, 1, proto.wireTypes.lengthDelimited)

		buf, n162 = proto.writeString(v3048, v3049, p244.id)
	end

	if p244.type ~= nil and p244.type ~= "" then
		local v3050, v3051 = proto.writeTag(buf, n162, 2, proto.wireTypes.lengthDelimited)

		buf, n162 = proto.writeString(v3050, v3051, p244.type)
	end

	local buf89 = buffer.create(n162)

	buffer.copy(buf89, 0, buf, 0, n162)

	return buf89
end
function t409.decode(p245: buffer) -- line: 17656
	-- upvalues: t409 (copy), proto (copy)
	local v3054 = t409.new()
	local n163 = 0

	while n163 < buffer.len(p245) do
		local v3056, v3057

		v3056, v3057, n163 = proto.readTag(p245, n163)

		if v3057 == proto.wireTypes.varint then
			local v3058

			v3058, n163 = proto.readVarInt(p245, n163)
		elseif v3057 == proto.wireTypes.lengthDelimited then
			if v3056 == 1 then
				local v3059

				v3059, n163 = proto.readBuffer(p245, n163)
				v3054.id = buffer.tostring(v3059)
			elseif v3056 == 2 then
				local v3060

				v3060, n163 = proto.readBuffer(p245, n163)
				v3054.type = buffer.tostring(v3060)
			else
				local v3061, v3062 = proto.readVarInt(p245, n163)

				n163 = v3062 + v3061
			end
		elseif v3057 == proto.wireTypes.i32 then
			local v3063

			v3063, n163 = proto.readFixed32(p245, n163)
		elseif v3057 == proto.wireTypes.i64 then
			local v3064

			v3064, n163 = proto.readFixed64(p245, n163)
		else
			error("Unsupported wire type: " .. v3057)
		end
	end

	return v3054
end
function t409.jsonEncode(p246) -- line: 17704
	local t411 = {}

	if p246.id ~= nil and p246.id ~= "" then
		t411.id = p246.id
	end

	if p246.type ~= nil and p246.type ~= "" then
		t411.type = p246.type
	end

	return t411
end
function t409.jsonDecode(t412: {[any]: any}) -- line: 17718
	-- upvalues: t409 (copy)
	local v3068 = t409.new()

	if t412.id ~= nil then
		v3068.id = t412.id
	end

	if t412.type ~= nil then
		v3068.type = t412.type
	end

	return v3068
end

t409.descriptor = {
	name = "CatalogItemGridInputData_CatalogItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.CatalogItem"
}
t1.CatalogItemGridInputData_CatalogItem = t409
typeRegistry.default:register(t1.CatalogItemGridInputData_CatalogItem)

local t413 = {}

t413.__index = t413

function t413.new(t414: {[any]: any}?) -- line: 17748
	-- upvalues: t413 (copy)
	return (setmetatable({
		entry_map = if t414 ~= nil and t414.entry_map ~= nil then t414.entry_map else {},
		entry_order = if t414 ~= nil and t414.entry_order ~= nil then t414.entry_order else {},
		content_pools = if t414 ~= nil and t414.content_pools ~= nil then t414.content_pools else {}
	}, t413))
end
function t413.encode(p247) -- line: 17758
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n164 = 0

	if p247.entry_map ~= nil and next(p247.entry_map) ~= nil then
		for v3073, v3074 in p247.entry_map do
			local buf90 = buffer.create(0)
			local v3076, v3077 = proto.writeTag(buf90, 0, 1, proto.wireTypes.lengthDelimited)
			local v3078, v3079 = proto.writeString(v3076, v3077, v3073)
			local v3080 = v3074:encode()
			local v3081, v3082 = proto.writeTag(v3078, v3079, 2, proto.wireTypes.lengthDelimited)
			local v3083, v3084 = proto.writeBuffer(v3081, v3082, v3080, buffer.len(v3080))
			local v3085, v3086 = proto.writeTag(buf, n164, 1, proto.wireTypes.lengthDelimited)

			buf, n164 = proto.writeBuffer(v3085, v3086, v3083, v3084)
		end
	end

	if p247.entry_order ~= nil and #p247.entry_order > 0 then
		for _, v3088 in p247.entry_order do
			local v3089, v3090 = proto.writeTag(buf, n164, 2, proto.wireTypes.lengthDelimited)

			buf, n164 = proto.writeString(v3089, v3090, v3088)
		end
	end

	if p247.content_pools ~= nil and next(p247.content_pools) ~= nil then
		for v3091, v3092 in p247.content_pools do
			local buf91 = buffer.create(0)
			local v3094, v3095 = proto.writeTag(buf91, 0, 1, proto.wireTypes.lengthDelimited)
			local v3096, v3097 = proto.writeString(v3094, v3095, v3091)
			local v3098 = v3092:encode()
			local v3099, v3100 = proto.writeTag(v3096, v3097, 2, proto.wireTypes.lengthDelimited)
			local v3101, v3102 = proto.writeBuffer(v3099, v3100, v3098, buffer.len(v3098))
			local v3103, v3104 = proto.writeTag(buf, n164, 3, proto.wireTypes.lengthDelimited)

			buf, n164 = proto.writeBuffer(v3103, v3104, v3101, v3102)
		end
	end

	local buf92 = buffer.create(n164)

	buffer.copy(buf92, 0, buf, 0, n164)

	return buf92
end
function t413.decode(p248: buffer) -- line: 17802
	-- upvalues: t413 (copy), proto (copy), t1 (copy)
	local v3107 = t413.new()
	local n165 = 0

	while n165 < buffer.len(p248) do
		local v3109, v3110

		v3109, v3110, n165 = proto.readTag(p248, n165)

		if v3110 == proto.wireTypes.varint then
			local v3111

			v3111, n165 = proto.readVarInt(p248, n165)
		elseif v3110 == proto.wireTypes.lengthDelimited then
			if v3109 == 1 then
				local v3112

				v3112, n165 = proto.readBuffer(p248, n165)

				local v3113 = t1.SearchResultsFeedInputData_EntryMapEntry.decode(v3112)
				local v3114 = t1.FeedEntry.new()

				v3107.entry_map[v3113.key or ""] = v3113.value or v3114
			elseif v3109 == 2 then
				local v3115

				v3115, n165 = proto.readBuffer(p248, n165)
				table.insert(v3107.entry_order, buffer.tostring(v3115))
			elseif v3109 == 3 then
				local v3116

				v3116, n165 = proto.readBuffer(p248, n165)

				local v3117 = t1.SearchResultsFeedInputData_ContentPoolsEntry.decode(v3116)
				local v3118 = t1.ContentPool.new()

				v3107.content_pools[v3117.key or ""] = v3117.value or v3118
			else
				local v3119, v3120 = proto.readVarInt(p248, n165)

				n165 = v3120 + v3119
			end
		elseif v3110 == proto.wireTypes.i32 then
			local v3121

			v3121, n165 = proto.readFixed32(p248, n165)
		elseif v3110 == proto.wireTypes.i64 then
			local v3122

			v3122, n165 = proto.readFixed64(p248, n165)
		else
			error("Unsupported wire type: " .. v3110)
		end
	end

	return v3107
end
function t413.jsonEncode(p249) -- line: 17869
	local t415 = {}

	if p249.entry_map ~= nil and next(p249.entry_map) ~= nil then
		local t416 = {}

		for v3126, v3127 in p249.entry_map do
			t416[v3126] = v3127:jsonEncode()
		end

		t415.entryMap = t416
	end

	if p249.entry_order ~= nil and #p249.entry_order > 0 then
		local t417 = {}

		for _, v3130 in p249.entry_order do
			table.insert(t417, v3130)
		end

		t415.entryOrder = t417
	end

	if p249.content_pools ~= nil and next(p249.content_pools) ~= nil then
		local t418 = {}

		for v3132, v3133 in p249.content_pools do
			t418[v3132] = v3133:jsonEncode()
		end

		t415.contentPools = t418
	end

	return t415
end
function t413.jsonDecode(t419: {[any]: any}) -- line: 17899
	-- upvalues: t413 (copy), t1 (copy)
	local v3135 = t413.new()

	if t419.entry_map ~= nil then
		local t420 = {}

		for v3137, v3138 in t419.entry_map do
			t420[v3137] = t1.FeedEntry.jsonDecode(v3138)
		end

		v3135.entry_map = t420
	end

	if t419.entryMap ~= nil then
		local t421 = {}

		for v3140, v3141 in t419.entryMap do
			t421[v3140] = t1.FeedEntry.jsonDecode(v3141)
		end

		v3135.entry_map = t421
	end

	if t419.entry_order ~= nil then
		local t422 = {}

		for _, v3144 in t419.entry_order do
			table.insert(t422, v3144)
		end

		v3135.entry_order = t422
	end

	if t419.entryOrder ~= nil then
		local t423 = {}

		for _, v3147 in t419.entryOrder do
			table.insert(t423, v3147)
		end

		v3135.entry_order = t423
	end

	if t419.content_pools ~= nil then
		local t424 = {}

		for v3149, v3150 in t419.content_pools do
			t424[v3149] = t1.ContentPool.jsonDecode(v3150)
		end

		v3135.content_pools = t424
	end

	if t419.contentPools ~= nil then
		local t425 = {}

		for v3152, v3153 in t419.contentPools do
			t425[v3152] = t1.ContentPool.jsonDecode(v3153)
		end

		v3135.content_pools = t425
	end

	return v3135
end

t413.descriptor = {
	name = "SearchResultsFeedInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.SearchResultsFeedInputData"
}
t1.SearchResultsFeedInputData = t413
typeRegistry.default:register(t1.SearchResultsFeedInputData)

local t426 = {}

t426.__index = t426

function t426.new(t427: {[any]: any}?) -- line: 17973
	-- upvalues: t426 (copy)
	return (setmetatable({
		key = if t427 ~= nil and t427.key ~= nil then t427.key else "",
		value = if t427 ~= nil and t427.value ~= nil then t427.value else nil
	}, t426))
end
function t426.encode(p250) -- line: 17982
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n166 = 0

	if p250.key ~= nil and p250.key ~= "" then
		local v3158, v3159 = proto.writeTag(buf, n166, 1, proto.wireTypes.lengthDelimited)

		buf, n166 = proto.writeString(v3158, v3159, p250.key)
	end

	if p250.value ~= nil then
		local v3160 = p250.value:encode()
		local v3161, v3162 = proto.writeTag(buf, n166, 2, proto.wireTypes.lengthDelimited)

		buf, n166 = proto.writeBuffer(v3161, v3162, v3160, buffer.len(v3160))
	end

	local buf93 = buffer.create(n166)

	buffer.copy(buf93, 0, buf, 0, n166)

	return buf93
end
function t426.decode(p251: buffer) -- line: 18004
	-- upvalues: t426 (copy), proto (copy), t1 (copy)
	local v3165 = t426.new()
	local n167 = 0

	while n167 < buffer.len(p251) do
		local v3167, v3168

		v3167, v3168, n167 = proto.readTag(p251, n167)

		if v3168 == proto.wireTypes.varint then
			local v3169

			v3169, n167 = proto.readVarInt(p251, n167)
		elseif v3168 == proto.wireTypes.lengthDelimited then
			if v3167 == 1 then
				local v3170

				v3170, n167 = proto.readBuffer(p251, n167)
				v3165.key = buffer.tostring(v3170)
			elseif v3167 == 2 then
				local v3171

				v3171, n167 = proto.readBuffer(p251, n167)
				v3165.value = t1.FeedEntry.decode(v3171)
			else
				local v3172, v3173 = proto.readVarInt(p251, n167)

				n167 = v3173 + v3172
			end
		elseif v3168 == proto.wireTypes.i32 then
			local v3174

			v3174, n167 = proto.readFixed32(p251, n167)
		elseif v3168 == proto.wireTypes.i64 then
			local v3175

			v3175, n167 = proto.readFixed64(p251, n167)
		else
			error("Unsupported wire type: " .. v3168)
		end
	end

	return v3165
end
function t426.jsonEncode(p252) -- line: 18054
	local t428 = {}

	if p252.key ~= nil and p252.key ~= "" then
		t428.key = p252.key
	end

	if p252.value ~= nil then
		t428.value = p252.value:jsonEncode()
	end

	return t428
end
function t426.jsonDecode(t429: {[any]: any}) -- line: 18070
	-- upvalues: t426 (copy), t1 (copy)
	local v3179 = t426.new()

	if t429.key ~= nil then
		v3179.key = t429.key
	end

	if t429.value ~= nil then
		v3179.value = t1.FeedEntry.jsonDecode(t429.value)
	end

	return v3179
end

t426.descriptor = {
	name = "SearchResultsFeedInputData_EntryMapEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryMapEntry"
}
t1.SearchResultsFeedInputData_EntryMapEntry = t426
typeRegistry.default:register(t1.SearchResultsFeedInputData_EntryMapEntry)

local t430 = {}

t430.__index = t430

function t430.new(t431: {[any]: any}?) -- line: 18100
	-- upvalues: t430 (copy)
	return (setmetatable({
		key = if t431 ~= nil and t431.key ~= nil then t431.key else "",
		value = if t431 ~= nil and t431.value ~= nil then t431.value else nil
	}, t430))
end
function t430.encode(p253) -- line: 18109
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n168 = 0

	if p253.key ~= nil and p253.key ~= "" then
		local v3184, v3185 = proto.writeTag(buf, n168, 1, proto.wireTypes.lengthDelimited)

		buf, n168 = proto.writeString(v3184, v3185, p253.key)
	end

	if p253.value ~= nil then
		local v3186 = p253.value:encode()
		local v3187, v3188 = proto.writeTag(buf, n168, 2, proto.wireTypes.lengthDelimited)

		buf, n168 = proto.writeBuffer(v3187, v3188, v3186, buffer.len(v3186))
	end

	local buf94 = buffer.create(n168)

	buffer.copy(buf94, 0, buf, 0, n168)

	return buf94
end
function t430.decode(p254: buffer) -- line: 18131
	-- upvalues: t430 (copy), proto (copy), t1 (copy)
	local v3191 = t430.new()
	local n169 = 0

	while n169 < buffer.len(p254) do
		local v3193, v3194

		v3193, v3194, n169 = proto.readTag(p254, n169)

		if v3194 == proto.wireTypes.varint then
			local v3195

			v3195, n169 = proto.readVarInt(p254, n169)
		elseif v3194 == proto.wireTypes.lengthDelimited then
			if v3193 == 1 then
				local v3196

				v3196, n169 = proto.readBuffer(p254, n169)
				v3191.key = buffer.tostring(v3196)
			elseif v3193 == 2 then
				local v3197

				v3197, n169 = proto.readBuffer(p254, n169)
				v3191.value = t1.ContentPool.decode(v3197)
			else
				local v3198, v3199 = proto.readVarInt(p254, n169)

				n169 = v3199 + v3198
			end
		elseif v3194 == proto.wireTypes.i32 then
			local v3200

			v3200, n169 = proto.readFixed32(p254, n169)
		elseif v3194 == proto.wireTypes.i64 then
			local v3201

			v3201, n169 = proto.readFixed64(p254, n169)
		else
			error("Unsupported wire type: " .. v3194)
		end
	end

	return v3191
end
function t430.jsonEncode(p255) -- line: 18181
	local t432 = {}

	if p255.key ~= nil and p255.key ~= "" then
		t432.key = p255.key
	end

	if p255.value ~= nil then
		t432.value = p255.value:jsonEncode()
	end

	return t432
end
function t430.jsonDecode(t433: {[any]: any}) -- line: 18197
	-- upvalues: t430 (copy), t1 (copy)
	local v3205 = t430.new()

	if t433.key ~= nil then
		v3205.key = t433.key
	end

	if t433.value ~= nil then
		v3205.value = t1.ContentPool.jsonDecode(t433.value)
	end

	return v3205
end

t430.descriptor = {
	name = "SearchResultsFeedInputData_ContentPoolsEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.ContentPoolsEntry"
}
t1.SearchResultsFeedInputData_ContentPoolsEntry = t430
typeRegistry.default:register(t1.SearchResultsFeedInputData_ContentPoolsEntry)

local t434 = {}

t434.__index = t434

function t434.new(t435: {[any]: any}?) -- line: 18227
	-- upvalues: t434 (copy)
	return (setmetatable({
		universe_id = if t435 ~= nil and t435.universe_id ~= nil then t435.universe_id else "",
		is_content_locked = t435 ~= nil and (t435.is_content_locked ~= nil and t435.is_content_locked)
	}, t434))
end
function t434.encode(p256) -- line: 18236
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n170 = 0

	if p256.universe_id ~= nil and p256.universe_id ~= "" then
		local v3210, v3211 = proto.writeTag(buf, n170, 1, proto.wireTypes.lengthDelimited)

		buf, n170 = proto.writeString(v3210, v3211, p256.universe_id)
	end

	if p256.is_content_locked then
		local v3212, v3213 = proto.writeTag(buf, n170, 2, proto.wireTypes.varint)

		buf, n170 = proto.writeVarInt(v3212, v3213, not p256.is_content_locked and 0 or 1)
	end

	local buf95 = buffer.create(n170)

	buffer.copy(buf95, 0, buf, 0, n170)

	return buf95
end
function t434.decode(p257: buffer) -- line: 18255
	-- upvalues: t434 (copy), proto (copy)
	local v3216 = t434.new()
	local n171 = 0

	while n171 < buffer.len(p257) do
		local v3218, v3219

		v3218, v3219, n171 = proto.readTag(p257, n171)

		if v3219 == proto.wireTypes.varint then
			if v3218 == 2 then
				local v3220

				v3220, n171 = proto.readVarInt(p257, n171)
				v3216.is_content_locked = v3220 ~= 0
			else
				local v3221

				v3221, n171 = proto.readVarInt(p257, n171)
			end
		elseif v3219 == proto.wireTypes.lengthDelimited then
			if v3218 == 1 then
				local v3222

				v3222, n171 = proto.readBuffer(p257, n171)
				v3216.universe_id = buffer.tostring(v3222)
			else
				local v3223, v3224 = proto.readVarInt(p257, n171)

				n171 = v3224 + v3223
			end
		elseif v3219 == proto.wireTypes.i32 then
			local v3225

			v3225, n171 = proto.readFixed32(p257, n171)
		elseif v3219 == proto.wireTypes.i64 then
			local v3226

			v3226, n171 = proto.readFixed64(p257, n171)
		else
			error("Unsupported wire type: " .. v3219)
		end
	end

	return v3216
end
function t434.jsonEncode(p258) -- line: 18303
	local t436 = {}

	if p258.universe_id ~= nil and p258.universe_id ~= "" then
		t436.universeId = p258.universe_id
	end

	if p258.is_content_locked then
		t436.isContentLocked = p258.is_content_locked
	end

	return t436
end
function t434.jsonDecode(t437: {[any]: any}) -- line: 18317
	-- upvalues: t434 (copy)
	local v3230 = t434.new()

	if t437.universe_id ~= nil then
		v3230.universe_id = t437.universe_id
	end

	if t437.universeId ~= nil then
		v3230.universe_id = t437.universeId
	end

	if t437.is_content_locked ~= nil then
		v3230.is_content_locked = t437.is_content_locked
	end

	if t437.isContentLocked ~= nil then
		v3230.is_content_locked = t437.isContentLocked
	end

	return v3230
end

t434.descriptor = {
	name = "ExperienceEmphasisTileInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceEmphasisTileInputData"
}
t1.ExperienceEmphasisTileInputData = t434
typeRegistry.default:register(t1.ExperienceEmphasisTileInputData)

local t438 = {}

t438.__index = t438

function t438.new(t439: {[any]: any}?) -- line: 18353
	-- upvalues: t438 (copy)
	return (setmetatable({
		overview_rich_text = if t439 ~= nil and t439.overview_rich_text ~= nil then t439.overview_rich_text else "",
		result_entry = if t439 ~= nil and t439.result_entry ~= nil then t439.result_entry else nil,
		follow_up_queries = if t439 ~= nil and t439.follow_up_queries ~= nil then t439.follow_up_queries else {},
		show_loading = t439 ~= nil and (t439.show_loading ~= nil and t439.show_loading),
		title = if t439 ~= nil and t439.title ~= nil then t439.title else "",
		search_query = if t439 ~= nil and t439.search_query ~= nil then t439.search_query else "",
		search_session_id = if t439 ~= nil and t439.search_session_id ~= nil then t439.search_session_id else "",
		universe_ids = if t439 ~= nil and t439.universe_ids ~= nil then t439.universe_ids else ""
	}, t438))
end
function t438.encode(p259) -- line: 18368
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n172 = 0

	if p259.overview_rich_text ~= nil and p259.overview_rich_text ~= "" then
		local v3235, v3236 = proto.writeTag(buf, n172, 1, proto.wireTypes.lengthDelimited)

		buf, n172 = proto.writeString(v3235, v3236, p259.overview_rich_text)
	end

	if p259.result_entry ~= nil then
		local v3237 = p259.result_entry:encode()
		local v3238, v3239 = proto.writeTag(buf, n172, 2, proto.wireTypes.lengthDelimited)

		buf, n172 = proto.writeBuffer(v3238, v3239, v3237, buffer.len(v3237))
	end

	if p259.follow_up_queries ~= nil and #p259.follow_up_queries > 0 then
		for _, v3241 in p259.follow_up_queries do
			local v3242, v3243 = proto.writeTag(buf, n172, 3, proto.wireTypes.lengthDelimited)

			buf, n172 = proto.writeString(v3242, v3243, v3241)
		end
	end

	if p259.show_loading then
		local v3244, v3245 = proto.writeTag(buf, n172, 4, proto.wireTypes.varint)

		buf, n172 = proto.writeVarInt(v3244, v3245, not p259.show_loading and 0 or 1)
	end

	if p259.title ~= nil and p259.title ~= "" then
		local v3246, v3247 = proto.writeTag(buf, n172, 5, proto.wireTypes.lengthDelimited)

		buf, n172 = proto.writeString(v3246, v3247, p259.title)
	end

	if p259.search_query ~= nil and p259.search_query ~= "" then
		local v3248, v3249 = proto.writeTag(buf, n172, 6, proto.wireTypes.lengthDelimited)

		buf, n172 = proto.writeString(v3248, v3249, p259.search_query)
	end

	if p259.search_session_id ~= nil and p259.search_session_id ~= "" then
		local v3250, v3251 = proto.writeTag(buf, n172, 7, proto.wireTypes.lengthDelimited)

		buf, n172 = proto.writeString(v3250, v3251, p259.search_session_id)
	end

	if p259.universe_ids ~= nil and p259.universe_ids ~= "" then
		local v3252, v3253 = proto.writeTag(buf, n172, 8, proto.wireTypes.lengthDelimited)

		buf, n172 = proto.writeString(v3252, v3253, p259.universe_ids)
	end

	local buf96 = buffer.create(n172)

	buffer.copy(buf96, 0, buf, 0, n172)

	return buf96
end
function t438.decode(p260: buffer) -- line: 18420
	-- upvalues: t438 (copy), proto (copy), t1 (copy)
	local v3256 = t438.new()
	local n173 = 0

	while n173 < buffer.len(p260) do
		local v3258, v3259

		v3258, v3259, n173 = proto.readTag(p260, n173)

		if v3259 == proto.wireTypes.varint then
			if v3258 == 4 then
				local v3260

				v3260, n173 = proto.readVarInt(p260, n173)
				v3256.show_loading = v3260 ~= 0
			else
				local v3261

				v3261, n173 = proto.readVarInt(p260, n173)
			end
		elseif v3259 == proto.wireTypes.lengthDelimited then
			if v3258 == 1 then
				local v3262

				v3262, n173 = proto.readBuffer(p260, n173)
				v3256.overview_rich_text = buffer.tostring(v3262)
			elseif v3258 == 2 then
				local v3263

				v3263, n173 = proto.readBuffer(p260, n173)
				v3256.result_entry = t1.FeedEntry.decode(v3263)
			elseif v3258 == 3 then
				local v3264

				v3264, n173 = proto.readBuffer(p260, n173)
				table.insert(v3256.follow_up_queries, buffer.tostring(v3264))
			elseif v3258 == 5 then
				local v3265

				v3265, n173 = proto.readBuffer(p260, n173)
				v3256.title = buffer.tostring(v3265)
			elseif v3258 == 6 then
				local v3266

				v3266, n173 = proto.readBuffer(p260, n173)
				v3256.search_query = buffer.tostring(v3266)
			elseif v3258 == 7 then
				local v3267

				v3267, n173 = proto.readBuffer(p260, n173)
				v3256.search_session_id = buffer.tostring(v3267)
			elseif v3258 == 8 then
				local v3268

				v3268, n173 = proto.readBuffer(p260, n173)
				v3256.universe_ids = buffer.tostring(v3268)
			else
				local v3269, v3270 = proto.readVarInt(p260, n173)

				n173 = v3270 + v3269
			end
		elseif v3259 == proto.wireTypes.i32 then
			local v3271

			v3271, n173 = proto.readFixed32(p260, n173)
		elseif v3259 == proto.wireTypes.i64 then
			local v3272

			v3272, n173 = proto.readFixed64(p260, n173)
		else
			error("Unsupported wire type: " .. v3259)
		end
	end

	return v3256
end
function t438.jsonEncode(p261) -- line: 18498
	local t440 = {}

	if p261.overview_rich_text ~= nil and p261.overview_rich_text ~= "" then
		t440.overviewRichText = p261.overview_rich_text
	end

	if p261.result_entry ~= nil then
		t440.resultEntry = p261.result_entry:jsonEncode()
	end

	if p261.follow_up_queries ~= nil and #p261.follow_up_queries > 0 then
		local t441 = {}

		for _, v3277 in p261.follow_up_queries do
			table.insert(t441, v3277)
		end

		t440.followUpQueries = t441
	end

	if p261.show_loading then
		t440.showLoading = p261.show_loading
	end

	if p261.title ~= nil and p261.title ~= "" then
		t440.title = p261.title
	end

	if p261.search_query ~= nil and p261.search_query ~= "" then
		t440.searchQuery = p261.search_query
	end

	if p261.search_session_id ~= nil and p261.search_session_id ~= "" then
		t440.searchSessionId = p261.search_session_id
	end

	if p261.universe_ids ~= nil and p261.universe_ids ~= "" then
		t440.universeIds = p261.universe_ids
	end

	return t440
end
function t438.jsonDecode(t442: {[any]: any}) -- line: 18540
	-- upvalues: t438 (copy), t1 (copy)
	local v3279 = t438.new()

	if t442.overview_rich_text ~= nil then
		v3279.overview_rich_text = t442.overview_rich_text
	end

	if t442.overviewRichText ~= nil then
		v3279.overview_rich_text = t442.overviewRichText
	end

	if t442.result_entry ~= nil then
		v3279.result_entry = t1.FeedEntry.jsonDecode(t442.result_entry)
	end

	if t442.resultEntry ~= nil then
		v3279.result_entry = t1.FeedEntry.jsonDecode(t442.resultEntry)
	end

	if t442.follow_up_queries ~= nil then
		local t443 = {}

		for _, v3282 in t442.follow_up_queries do
			table.insert(t443, v3282)
		end

		v3279.follow_up_queries = t443
	end

	if t442.followUpQueries ~= nil then
		local t444 = {}

		for _, v3285 in t442.followUpQueries do
			table.insert(t444, v3285)
		end

		v3279.follow_up_queries = t444
	end

	if t442.show_loading ~= nil then
		v3279.show_loading = t442.show_loading
	end

	if t442.showLoading ~= nil then
		v3279.show_loading = t442.showLoading
	end

	if t442.title ~= nil then
		v3279.title = t442.title
	end

	if t442.search_query ~= nil then
		v3279.search_query = t442.search_query
	end

	if t442.searchQuery ~= nil then
		v3279.search_query = t442.searchQuery
	end

	if t442.search_session_id ~= nil then
		v3279.search_session_id = t442.search_session_id
	end

	if t442.searchSessionId ~= nil then
		v3279.search_session_id = t442.searchSessionId
	end

	if t442.universe_ids ~= nil then
		v3279.universe_ids = t442.universe_ids
	end

	if t442.universeIds ~= nil then
		v3279.universe_ids = t442.universeIds
	end

	return v3279
end

t438.descriptor = {
	name = "PowerSearchAIOverviewInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.PowerSearchAIOverviewInputData"
}
t1.PowerSearchAIOverviewInputData = t438
typeRegistry.default:register(t1.PowerSearchAIOverviewInputData)

local t445 = {}

t445.__index = t445

function t445.new(t446: {[any]: any}?) -- line: 18630
	-- upvalues: t445 (copy)
	return (setmetatable({
		title = if t446 ~= nil and t446.title ~= nil then t446.title else "",
		user_items = if t446 ~= nil and t446.user_items ~= nil then t446.user_items else {},
		max_visible_rows = if t446 ~= nil and t446.max_visible_rows ~= nil then t446.max_visible_rows else 0
	}, t445))
end
function t445.encode(p262) -- line: 18638
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n174 = 0

	if p262.title ~= nil and p262.title ~= "" then
		local v3290, v3291 = proto.writeTag(buf, n174, 1, proto.wireTypes.lengthDelimited)

		buf, n174 = proto.writeString(v3290, v3291, p262.title)
	end

	if p262.user_items ~= nil and #p262.user_items > 0 then
		for _, v3293 in p262.user_items do
			local v3294 = v3293:encode()
			local v3295, v3296 = proto.writeTag(buf, n174, 2, proto.wireTypes.lengthDelimited)

			buf, n174 = proto.writeBuffer(v3295, v3296, v3294, buffer.len(v3294))
		end
	end

	if p262.max_visible_rows ~= nil and p262.max_visible_rows ~= 0 then
		local v3297, v3298 = proto.writeTag(buf, n174, 3, proto.wireTypes.varint)

		buf, n174 = proto.writeVarInt(v3297, v3298, p262.max_visible_rows)
	end

	local buf97 = buffer.create(n174)

	buffer.copy(buf97, 0, buf, 0, n174)

	return buf97
end
function t445.decode(p263: buffer) -- line: 18665
	-- upvalues: t445 (copy), proto (copy), t1 (copy)
	local v3301 = t445.new()
	local n175 = 0

	while n175 < buffer.len(p263) do
		local v3303, v3304

		v3303, v3304, n175 = proto.readTag(p263, n175)

		if v3304 == proto.wireTypes.varint then
			if v3303 == 3 then
				local v3305

				v3305, n175 = proto.readVarIntI32(p263, n175)
				v3301.max_visible_rows = v3305
			else
				local v3306

				v3306, n175 = proto.readVarInt(p263, n175)
			end
		elseif v3304 == proto.wireTypes.lengthDelimited then
			if v3303 == 1 then
				local v3307

				v3307, n175 = proto.readBuffer(p263, n175)
				v3301.title = buffer.tostring(v3307)
			elseif v3303 == 2 then
				local v3308

				v3308, n175 = proto.readBuffer(p263, n175)
				table.insert(v3301.user_items, t1.UserListInputData_UserItem.decode(v3308))
			else
				local v3309, v3310 = proto.readVarInt(p263, n175)

				n175 = v3310 + v3309
			end
		elseif v3304 == proto.wireTypes.i32 then
			local v3311

			v3311, n175 = proto.readFixed32(p263, n175)
		elseif v3304 == proto.wireTypes.i64 then
			local v3312

			v3312, n175 = proto.readFixed64(p263, n175)
		else
			error("Unsupported wire type: " .. v3304)
		end
	end

	return v3301
end
function t445.jsonEncode(p264) -- line: 18718
	local t447 = {}

	if p264.title ~= nil and p264.title ~= "" then
		t447.title = p264.title
	end

	if p264.user_items ~= nil and #p264.user_items > 0 then
		local t448 = {}

		for _, v3317 in p264.user_items do
			table.insert(t448, v3317:jsonEncode())
		end

		t447.userItems = t448
	end

	if p264.max_visible_rows ~= nil and p264.max_visible_rows ~= 0 then
		t447.maxVisibleRows = p264.max_visible_rows
	end

	return t447
end
function t445.jsonDecode(t449: {[any]: any}) -- line: 18740
	-- upvalues: t445 (copy), t1 (copy)
	local v3319 = t445.new()

	if t449.title ~= nil then
		v3319.title = t449.title
	end

	if t449.user_items ~= nil then
		local t450 = {}

		for _, v3322 in t449.user_items do
			table.insert(t450, t1.UserListInputData_UserItem.jsonDecode(v3322))
		end

		v3319.user_items = t450
	end

	if t449.userItems ~= nil then
		local t451 = {}

		for _, v3325 in t449.userItems do
			table.insert(t451, t1.UserListInputData_UserItem.jsonDecode(v3325))
		end

		v3319.user_items = t451
	end

	if t449.max_visible_rows ~= nil then
		v3319.max_visible_rows = t449.max_visible_rows
	end

	if t449.maxVisibleRows ~= nil then
		v3319.max_visible_rows = t449.maxVisibleRows
	end

	return v3319
end

t445.descriptor = {
	name = "UserListInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UserListInputData"
}
t1.UserListInputData = t445
typeRegistry.default:register(t1.UserListInputData)

local t452 = {}

t452.__index = t452

function t452.new(t453: {[any]: any}?) -- line: 18790
	-- upvalues: t452 (copy)
	return (setmetatable({
		user_id = if t453 ~= nil and t453.user_id ~= nil then t453.user_id else ""
	}, t452))
end
function t452.encode(p265) -- line: 18798
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n176 = 0

	if p265.user_id ~= nil and p265.user_id ~= "" then
		local v3330, v3331 = proto.writeTag(buf, n176, 1, proto.wireTypes.lengthDelimited)

		buf, n176 = proto.writeString(v3330, v3331, p265.user_id)
	end

	local buf98 = buffer.create(n176)

	buffer.copy(buf98, 0, buf, 0, n176)

	return buf98
end
function t452.decode(p266: buffer) -- line: 18812
	-- upvalues: t452 (copy), proto (copy)
	local v3334 = t452.new()
	local n177 = 0

	while n177 < buffer.len(p266) do
		local v3336, v3337

		v3336, v3337, n177 = proto.readTag(p266, n177)

		if v3337 == proto.wireTypes.varint then
			local v3338

			v3338, n177 = proto.readVarInt(p266, n177)
		elseif v3337 == proto.wireTypes.lengthDelimited then
			if v3336 == 1 then
				local v3339

				v3339, n177 = proto.readBuffer(p266, n177)
				v3334.user_id = buffer.tostring(v3339)
			else
				local v3340, v3341 = proto.readVarInt(p266, n177)

				n177 = v3341 + v3340
			end
		elseif v3337 == proto.wireTypes.i32 then
			local v3342

			v3342, n177 = proto.readFixed32(p266, n177)
		elseif v3337 == proto.wireTypes.i64 then
			local v3343

			v3343, n177 = proto.readFixed64(p266, n177)
		else
			error("Unsupported wire type: " .. v3337)
		end
	end

	return v3334
end
function t452.jsonEncode(p267) -- line: 18855
	local t454 = {}

	if p267.user_id ~= nil and p267.user_id ~= "" then
		t454.userId = p267.user_id
	end

	return t454
end
function t452.jsonDecode(t455: {[any]: any}) -- line: 18865
	-- upvalues: t452 (copy)
	local v3347 = t452.new()

	if t455.user_id ~= nil then
		v3347.user_id = t455.user_id
	end

	if t455.userId ~= nil then
		v3347.user_id = t455.userId
	end

	return v3347
end

t452.descriptor = {
	name = "UserListInputData_UserItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.UserItem"
}
t1.UserListInputData_UserItem = t452
typeRegistry.default:register(t1.UserListInputData_UserItem)

local t456 = {}

t456.__index = t456

function t456.new(t457: {[any]: any}?) -- line: 18893
	-- upvalues: t456 (copy)
	return (setmetatable({
		title = if t457 ~= nil and t457.title ~= nil then t457.title else "",
		items = if t457 ~= nil and t457.items ~= nil then t457.items else {},
		max_visible_rows = if t457 ~= nil and t457.max_visible_rows ~= nil then t457.max_visible_rows else 0
	}, t456))
end
function t456.encode(p268) -- line: 18901
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n178 = 0

	if p268.title ~= nil and p268.title ~= "" then
		local v3352, v3353 = proto.writeTag(buf, n178, 1, proto.wireTypes.lengthDelimited)

		buf, n178 = proto.writeString(v3352, v3353, p268.title)
	end

	if p268.items ~= nil and #p268.items > 0 then
		for _, v3355 in p268.items do
			local v3356 = v3355:encode()
			local v3357, v3358 = proto.writeTag(buf, n178, 2, proto.wireTypes.lengthDelimited)

			buf, n178 = proto.writeBuffer(v3357, v3358, v3356, buffer.len(v3356))
		end
	end

	if p268.max_visible_rows ~= nil and p268.max_visible_rows ~= 0 then
		local v3359, v3360 = proto.writeTag(buf, n178, 3, proto.wireTypes.varint)

		buf, n178 = proto.writeVarInt(v3359, v3360, p268.max_visible_rows)
	end

	local buf99 = buffer.create(n178)

	buffer.copy(buf99, 0, buf, 0, n178)

	return buf99
end
function t456.decode(p269: buffer) -- line: 18928
	-- upvalues: t456 (copy), proto (copy), t1 (copy)
	local v3363 = t456.new()
	local n179 = 0

	while n179 < buffer.len(p269) do
		local v3365, v3366

		v3365, v3366, n179 = proto.readTag(p269, n179)

		if v3366 == proto.wireTypes.varint then
			if v3365 == 3 then
				local v3367

				v3367, n179 = proto.readVarIntI32(p269, n179)
				v3363.max_visible_rows = v3367
			else
				local v3368

				v3368, n179 = proto.readVarInt(p269, n179)
			end
		elseif v3366 == proto.wireTypes.lengthDelimited then
			if v3365 == 1 then
				local v3369

				v3369, n179 = proto.readBuffer(p269, n179)
				v3363.title = buffer.tostring(v3369)
			elseif v3365 == 2 then
				local v3370

				v3370, n179 = proto.readBuffer(p269, n179)
				table.insert(v3363.items, t1.CatalogItemListInputData_CatalogItem.decode(v3370))
			else
				local v3371, v3372 = proto.readVarInt(p269, n179)

				n179 = v3372 + v3371
			end
		elseif v3366 == proto.wireTypes.i32 then
			local v3373

			v3373, n179 = proto.readFixed32(p269, n179)
		elseif v3366 == proto.wireTypes.i64 then
			local v3374

			v3374, n179 = proto.readFixed64(p269, n179)
		else
			error("Unsupported wire type: " .. v3366)
		end
	end

	return v3363
end
function t456.jsonEncode(p270) -- line: 18981
	local t458 = {}

	if p270.title ~= nil and p270.title ~= "" then
		t458.title = p270.title
	end

	if p270.items ~= nil and #p270.items > 0 then
		local t459 = {}

		for _, v3379 in p270.items do
			table.insert(t459, v3379:jsonEncode())
		end

		t458.items = t459
	end

	if p270.max_visible_rows ~= nil and p270.max_visible_rows ~= 0 then
		t458.maxVisibleRows = p270.max_visible_rows
	end

	return t458
end
function t456.jsonDecode(t460: {[any]: any}) -- line: 19003
	-- upvalues: t456 (copy), t1 (copy)
	local v3381 = t456.new()

	if t460.title ~= nil then
		v3381.title = t460.title
	end

	if t460.items ~= nil then
		local t461 = {}

		for _, v3384 in t460.items do
			table.insert(t461, t1.CatalogItemListInputData_CatalogItem.jsonDecode(v3384))
		end

		v3381.items = t461
	end

	if t460.max_visible_rows ~= nil then
		v3381.max_visible_rows = t460.max_visible_rows
	end

	if t460.maxVisibleRows ~= nil then
		v3381.max_visible_rows = t460.maxVisibleRows
	end

	return v3381
end

t456.descriptor = {
	name = "CatalogItemListInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CatalogItemListInputData"
}
t1.CatalogItemListInputData = t456
typeRegistry.default:register(t1.CatalogItemListInputData)

local t462 = {}

t462.__index = t462

function t462.new(t463: {[any]: any}?) -- line: 19044
	-- upvalues: t462 (copy)
	return (setmetatable({
		item_id = if t463 ~= nil and t463.item_id ~= nil then t463.item_id else "",
		item_type = if t463 ~= nil and t463.item_type ~= nil then t463.item_type else ""
	}, t462))
end
function t462.encode(p271) -- line: 19053
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n180 = 0

	if p271.item_id ~= nil and p271.item_id ~= "" then
		local v3389, v3390 = proto.writeTag(buf, n180, 1, proto.wireTypes.lengthDelimited)

		buf, n180 = proto.writeString(v3389, v3390, p271.item_id)
	end

	if p271.item_type ~= nil and p271.item_type ~= "" then
		local v3391, v3392 = proto.writeTag(buf, n180, 2, proto.wireTypes.lengthDelimited)

		buf, n180 = proto.writeString(v3391, v3392, p271.item_type)
	end

	local buf100 = buffer.create(n180)

	buffer.copy(buf100, 0, buf, 0, n180)

	return buf100
end
function t462.decode(p272: buffer) -- line: 19072
	-- upvalues: t462 (copy), proto (copy)
	local v3395 = t462.new()
	local n181 = 0

	while n181 < buffer.len(p272) do
		local v3397, v3398

		v3397, v3398, n181 = proto.readTag(p272, n181)

		if v3398 == proto.wireTypes.varint then
			local v3399

			v3399, n181 = proto.readVarInt(p272, n181)
		elseif v3398 == proto.wireTypes.lengthDelimited then
			if v3397 == 1 then
				local v3400

				v3400, n181 = proto.readBuffer(p272, n181)
				v3395.item_id = buffer.tostring(v3400)
			elseif v3397 == 2 then
				local v3401

				v3401, n181 = proto.readBuffer(p272, n181)
				v3395.item_type = buffer.tostring(v3401)
			else
				local v3402, v3403 = proto.readVarInt(p272, n181)

				n181 = v3403 + v3402
			end
		elseif v3398 == proto.wireTypes.i32 then
			local v3404

			v3404, n181 = proto.readFixed32(p272, n181)
		elseif v3398 == proto.wireTypes.i64 then
			local v3405

			v3405, n181 = proto.readFixed64(p272, n181)
		else
			error("Unsupported wire type: " .. v3398)
		end
	end

	return v3395
end
function t462.jsonEncode(p273) -- line: 19120
	local t464 = {}

	if p273.item_id ~= nil and p273.item_id ~= "" then
		t464.itemId = p273.item_id
	end

	if p273.item_type ~= nil and p273.item_type ~= "" then
		t464.itemType = p273.item_type
	end

	return t464
end
function t462.jsonDecode(t465: {[any]: any}) -- line: 19134
	-- upvalues: t462 (copy)
	local v3409 = t462.new()

	if t465.item_id ~= nil then
		v3409.item_id = t465.item_id
	end

	if t465.itemId ~= nil then
		v3409.item_id = t465.itemId
	end

	if t465.item_type ~= nil then
		v3409.item_type = t465.item_type
	end

	if t465.itemType ~= nil then
		v3409.item_type = t465.itemType
	end

	return v3409
end

t462.descriptor = {
	name = "CatalogItemListInputData_CatalogItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.CatalogItem"
}
t1.CatalogItemListInputData_CatalogItem = t462
typeRegistry.default:register(t1.CatalogItemListInputData_CatalogItem)

local t466 = {}

t466.__index = t466

function t466.new(t467: {[any]: any}?) -- line: 19172
	-- upvalues: t466 (copy)
	return (setmetatable({
		universe_id = if t467 ~= nil and t467.universe_id ~= nil then t467.universe_id else ""
	}, t466))
end
function t466.encode(p274) -- line: 19180
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n182 = 0

	if p274.universe_id ~= nil and p274.universe_id ~= "" then
		local v3414, v3415 = proto.writeTag(buf, n182, 1, proto.wireTypes.lengthDelimited)

		buf, n182 = proto.writeString(v3414, v3415, p274.universe_id)
	end

	local buf101 = buffer.create(n182)

	buffer.copy(buf101, 0, buf, 0, n182)

	return buf101
end
function t466.decode(p275: buffer) -- line: 19194
	-- upvalues: t466 (copy), proto (copy)
	local v3418 = t466.new()
	local n183 = 0

	while n183 < buffer.len(p275) do
		local v3420, v3421

		v3420, v3421, n183 = proto.readTag(p275, n183)

		if v3421 == proto.wireTypes.varint then
			local v3422

			v3422, n183 = proto.readVarInt(p275, n183)
		elseif v3421 == proto.wireTypes.lengthDelimited then
			if v3420 == 1 then
				local v3423

				v3423, n183 = proto.readBuffer(p275, n183)
				v3418.universe_id = buffer.tostring(v3423)
			else
				local v3424, v3425 = proto.readVarInt(p275, n183)

				n183 = v3425 + v3424
			end
		elseif v3421 == proto.wireTypes.i32 then
			local v3426

			v3426, n183 = proto.readFixed32(p275, n183)
		elseif v3421 == proto.wireTypes.i64 then
			local v3427

			v3427, n183 = proto.readFixed64(p275, n183)
		else
			error("Unsupported wire type: " .. v3421)
		end
	end

	return v3418
end
function t466.jsonEncode(p276) -- line: 19237
	local t468 = {}

	if p276.universe_id ~= nil and p276.universe_id ~= "" then
		t468.universeId = p276.universe_id
	end

	return t468
end
function t466.jsonDecode(t469: {[any]: any}) -- line: 19247
	-- upvalues: t466 (copy)
	local v3431 = t466.new()

	if t469.universe_id ~= nil then
		v3431.universe_id = t469.universe_id
	end

	if t469.universeId ~= nil then
		v3431.universe_id = t469.universeId
	end

	return v3431
end

t466.descriptor = {
	name = "ExperienceGuidelinesDialogInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceGuidelinesDialogInputData"
}
t1.ExperienceGuidelinesDialogInputData = t466
typeRegistry.default:register(t1.ExperienceGuidelinesDialogInputData)

local t470 = {}

t470.__index = t470

function t470.new(t471: {[any]: any}?) -- line: 19277
	-- upvalues: t470 (copy)
	return (setmetatable({
		title = if t471 ~= nil and t471.title ~= nil then t471.title else "",
		subtitle = if t471 ~= nil and t471.subtitle ~= nil then t471.subtitle else "",
		moment_items = if t471 ~= nil and t471.moment_items ~= nil then t471.moment_items else {}
	}, t470))
end
function t470.encode(p277) -- line: 19285
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n184 = 0

	if p277.title ~= nil and p277.title ~= "" then
		local v3436, v3437 = proto.writeTag(buf, n184, 1, proto.wireTypes.lengthDelimited)

		buf, n184 = proto.writeString(v3436, v3437, p277.title)
	end

	if p277.subtitle ~= nil and p277.subtitle ~= "" then
		local v3438, v3439 = proto.writeTag(buf, n184, 2, proto.wireTypes.lengthDelimited)

		buf, n184 = proto.writeString(v3438, v3439, p277.subtitle)
	end

	if p277.moment_items ~= nil and #p277.moment_items > 0 then
		for _, v3441 in p277.moment_items do
			local v3442 = v3441:encode()
			local v3443, v3444 = proto.writeTag(buf, n184, 3, proto.wireTypes.lengthDelimited)

			buf, n184 = proto.writeBuffer(v3443, v3444, v3442, buffer.len(v3442))
		end
	end

	local buf102 = buffer.create(n184)

	buffer.copy(buf102, 0, buf, 0, n184)

	return buf102
end
function t470.decode(p278: buffer) -- line: 19312
	-- upvalues: t470 (copy), proto (copy), t1 (copy)
	local v3447 = t470.new()
	local n185 = 0

	while n185 < buffer.len(p278) do
		local v3449, v3450

		v3449, v3450, n185 = proto.readTag(p278, n185)

		if v3450 == proto.wireTypes.varint then
			local v3451

			v3451, n185 = proto.readVarInt(p278, n185)
		elseif v3450 == proto.wireTypes.lengthDelimited then
			if v3449 == 1 then
				local v3452

				v3452, n185 = proto.readBuffer(p278, n185)
				v3447.title = buffer.tostring(v3452)
			elseif v3449 == 2 then
				local v3453

				v3453, n185 = proto.readBuffer(p278, n185)
				v3447.subtitle = buffer.tostring(v3453)
			elseif v3449 == 3 then
				local v3454

				v3454, n185 = proto.readBuffer(p278, n185)
				table.insert(v3447.moment_items, t1.MomentsCarouselInputData_MomentItem.decode(v3454))
			else
				local v3455, v3456 = proto.readVarInt(p278, n185)

				n185 = v3456 + v3455
			end
		elseif v3450 == proto.wireTypes.i32 then
			local v3457

			v3457, n185 = proto.readFixed32(p278, n185)
		elseif v3450 == proto.wireTypes.i64 then
			local v3458

			v3458, n185 = proto.readFixed64(p278, n185)
		else
			error("Unsupported wire type: " .. v3450)
		end
	end

	return v3447
end
function t470.jsonEncode(p279) -- line: 19365
	local t472 = {}

	if p279.title ~= nil and p279.title ~= "" then
		t472.title = p279.title
	end

	if p279.subtitle ~= nil and p279.subtitle ~= "" then
		t472.subtitle = p279.subtitle
	end

	if p279.moment_items ~= nil and #p279.moment_items > 0 then
		local t473 = {}

		for _, v3463 in p279.moment_items do
			table.insert(t473, v3463:jsonEncode())
		end

		t472.momentItems = t473
	end

	return t472
end
function t470.jsonDecode(t474: {[any]: any}) -- line: 19387
	-- upvalues: t470 (copy), t1 (copy)
	local v3465 = t470.new()

	if t474.title ~= nil then
		v3465.title = t474.title
	end

	if t474.subtitle ~= nil then
		v3465.subtitle = t474.subtitle
	end

	if t474.moment_items ~= nil then
		local t475 = {}

		for _, v3468 in t474.moment_items do
			table.insert(t475, t1.MomentsCarouselInputData_MomentItem.jsonDecode(v3468))
		end

		v3465.moment_items = t475
	end

	if t474.momentItems ~= nil then
		local t476 = {}

		for _, v3471 in t474.momentItems do
			table.insert(t476, t1.MomentsCarouselInputData_MomentItem.jsonDecode(v3471))
		end

		v3465.moment_items = t476
	end

	return v3465
end

t470.descriptor = {
	name = "MomentsCarouselInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.MomentsCarouselInputData"
}
t1.MomentsCarouselInputData = t470
typeRegistry.default:register(t1.MomentsCarouselInputData)

local t477 = {}

t477.__index = t477

function t477.new(t478: {[any]: any}?) -- line: 19433
	-- upvalues: t477 (copy)
	return (setmetatable({
		moment_id = if t478 ~= nil and t478.moment_id ~= nil then t478.moment_id else "",
		video_asset_id = if t478 ~= nil and t478.video_asset_id ~= nil then t478.video_asset_id else "",
		target_universe_id = if t478 ~= nil and t478.target_universe_id ~= nil then t478.target_universe_id else "",
		target_place_id = if t478 ~= nil and t478.target_place_id ~= nil then t478.target_place_id else "",
		feed_item_id = if t478 ~= nil and t478.feed_item_id ~= nil then t478.feed_item_id else "",
		capture_universe_id = if t478 ~= nil and t478.capture_universe_id ~= nil then t478.capture_universe_id else ""
	}, t477))
end
function t477.encode(p280) -- line: 19448
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n186 = 0

	if p280.moment_id ~= nil and p280.moment_id ~= "" then
		local v3476, v3477 = proto.writeTag(buf, n186, 1, proto.wireTypes.lengthDelimited)

		buf, n186 = proto.writeString(v3476, v3477, p280.moment_id)
	end

	if p280.video_asset_id ~= nil and p280.video_asset_id ~= "" then
		local v3478, v3479 = proto.writeTag(buf, n186, 2, proto.wireTypes.lengthDelimited)

		buf, n186 = proto.writeString(v3478, v3479, p280.video_asset_id)
	end

	if p280.target_universe_id ~= nil and p280.target_universe_id ~= "" then
		local v3480, v3481 = proto.writeTag(buf, n186, 3, proto.wireTypes.lengthDelimited)

		buf, n186 = proto.writeString(v3480, v3481, p280.target_universe_id)
	end

	if p280.target_place_id ~= nil and p280.target_place_id ~= "" then
		local v3482, v3483 = proto.writeTag(buf, n186, 4, proto.wireTypes.lengthDelimited)

		buf, n186 = proto.writeString(v3482, v3483, p280.target_place_id)
	end

	if p280.feed_item_id ~= nil and p280.feed_item_id ~= "" then
		local v3484, v3485 = proto.writeTag(buf, n186, 5, proto.wireTypes.lengthDelimited)

		buf, n186 = proto.writeString(v3484, v3485, p280.feed_item_id)
	end

	if p280.capture_universe_id ~= nil and p280.capture_universe_id ~= "" then
		local v3486, v3487 = proto.writeTag(buf, n186, 6, proto.wireTypes.lengthDelimited)

		buf, n186 = proto.writeString(v3486, v3487, p280.capture_universe_id)
	end

	local buf103 = buffer.create(n186)

	buffer.copy(buf103, 0, buf, 0, n186)

	return buf103
end
function t477.decode(p281: buffer) -- line: 19487
	-- upvalues: t477 (copy), proto (copy)
	local v3490 = t477.new()
	local n187 = 0

	while n187 < buffer.len(p281) do
		local v3492, v3493

		v3492, v3493, n187 = proto.readTag(p281, n187)

		if v3493 == proto.wireTypes.varint then
			local v3494

			v3494, n187 = proto.readVarInt(p281, n187)
		elseif v3493 == proto.wireTypes.lengthDelimited then
			if v3492 == 1 then
				local v3495

				v3495, n187 = proto.readBuffer(p281, n187)
				v3490.moment_id = buffer.tostring(v3495)
			elseif v3492 == 2 then
				local v3496

				v3496, n187 = proto.readBuffer(p281, n187)
				v3490.video_asset_id = buffer.tostring(v3496)
			elseif v3492 == 3 then
				local v3497

				v3497, n187 = proto.readBuffer(p281, n187)
				v3490.target_universe_id = buffer.tostring(v3497)
			elseif v3492 == 4 then
				local v3498

				v3498, n187 = proto.readBuffer(p281, n187)
				v3490.target_place_id = buffer.tostring(v3498)
			elseif v3492 == 5 then
				local v3499

				v3499, n187 = proto.readBuffer(p281, n187)
				v3490.feed_item_id = buffer.tostring(v3499)
			elseif v3492 == 6 then
				local v3500

				v3500, n187 = proto.readBuffer(p281, n187)
				v3490.capture_universe_id = buffer.tostring(v3500)
			else
				local v3501, v3502 = proto.readVarInt(p281, n187)

				n187 = v3502 + v3501
			end
		elseif v3493 == proto.wireTypes.i32 then
			local v3503

			v3503, n187 = proto.readFixed32(p281, n187)
		elseif v3493 == proto.wireTypes.i64 then
			local v3504

			v3504, n187 = proto.readFixed64(p281, n187)
		else
			error("Unsupported wire type: " .. v3493)
		end
	end

	return v3490
end
function t477.jsonEncode(p282) -- line: 19555
	local t479 = {}

	if p282.moment_id ~= nil and p282.moment_id ~= "" then
		t479.momentId = p282.moment_id
	end

	if p282.video_asset_id ~= nil and p282.video_asset_id ~= "" then
		t479.videoAssetId = p282.video_asset_id
	end

	if p282.target_universe_id ~= nil and p282.target_universe_id ~= "" then
		t479.targetUniverseId = p282.target_universe_id
	end

	if p282.target_place_id ~= nil and p282.target_place_id ~= "" then
		t479.targetPlaceId = p282.target_place_id
	end

	if p282.feed_item_id ~= nil and p282.feed_item_id ~= "" then
		t479.feedItemId = p282.feed_item_id
	end

	if p282.capture_universe_id ~= nil and p282.capture_universe_id ~= "" then
		t479.captureUniverseId = p282.capture_universe_id
	end

	return t479
end
function t477.jsonDecode(t480: {[any]: any}) -- line: 19585
	-- upvalues: t477 (copy)
	local v3508 = t477.new()

	if t480.moment_id ~= nil then
		v3508.moment_id = t480.moment_id
	end

	if t480.momentId ~= nil then
		v3508.moment_id = t480.momentId
	end

	if t480.video_asset_id ~= nil then
		v3508.video_asset_id = t480.video_asset_id
	end

	if t480.videoAssetId ~= nil then
		v3508.video_asset_id = t480.videoAssetId
	end

	if t480.target_universe_id ~= nil then
		v3508.target_universe_id = t480.target_universe_id
	end

	if t480.targetUniverseId ~= nil then
		v3508.target_universe_id = t480.targetUniverseId
	end

	if t480.target_place_id ~= nil then
		v3508.target_place_id = t480.target_place_id
	end

	if t480.targetPlaceId ~= nil then
		v3508.target_place_id = t480.targetPlaceId
	end

	if t480.feed_item_id ~= nil then
		v3508.feed_item_id = t480.feed_item_id
	end

	if t480.feedItemId ~= nil then
		v3508.feed_item_id = t480.feedItemId
	end

	if t480.capture_universe_id ~= nil then
		v3508.capture_universe_id = t480.capture_universe_id
	end

	if t480.captureUniverseId ~= nil then
		v3508.capture_universe_id = t480.captureUniverseId
	end

	return v3508
end

t477.descriptor = {
	name = "MomentsCarouselInputData_MomentItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.MomentItem"
}
t1.MomentsCarouselInputData_MomentItem = t477
typeRegistry.default:register(t1.MomentsCarouselInputData_MomentItem)

local t481 = {}

t481.__index = t481

function t481.new(t482: {[any]: any}?) -- line: 19655
	-- upvalues: t481 (copy)
	return (setmetatable({
		title = if t482 ~= nil and t482.title ~= nil then t482.title else "",
		subtitle = if t482 ~= nil and t482.subtitle ~= nil then t482.subtitle else ""
	}, t481))
end
function t481.encode(p283) -- line: 19662
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n188 = 0

	if p283.title ~= nil and p283.title ~= "" then
		local v3513, v3514 = proto.writeTag(buf, n188, 1, proto.wireTypes.lengthDelimited)

		buf, n188 = proto.writeString(v3513, v3514, p283.title)
	end

	if p283.subtitle ~= nil and p283.subtitle ~= "" then
		local v3515, v3516 = proto.writeTag(buf, n188, 2, proto.wireTypes.lengthDelimited)

		buf, n188 = proto.writeString(v3515, v3516, p283.subtitle)
	end

	local buf104 = buffer.create(n188)

	buffer.copy(buf104, 0, buf, 0, n188)

	return buf104
end
function t481.decode(p284: buffer) -- line: 19681
	-- upvalues: t481 (copy), proto (copy)
	local v3519 = t481.new()
	local n189 = 0

	while n189 < buffer.len(p284) do
		local v3521, v3522

		v3521, v3522, n189 = proto.readTag(p284, n189)

		if v3522 == proto.wireTypes.varint then
			local v3523

			v3523, n189 = proto.readVarInt(p284, n189)
		elseif v3522 == proto.wireTypes.lengthDelimited then
			if v3521 == 1 then
				local v3524

				v3524, n189 = proto.readBuffer(p284, n189)
				v3519.title = buffer.tostring(v3524)
			elseif v3521 == 2 then
				local v3525

				v3525, n189 = proto.readBuffer(p284, n189)
				v3519.subtitle = buffer.tostring(v3525)
			else
				local v3526, v3527 = proto.readVarInt(p284, n189)

				n189 = v3527 + v3526
			end
		elseif v3522 == proto.wireTypes.i32 then
			local v3528

			v3528, n189 = proto.readFixed32(p284, n189)
		elseif v3522 == proto.wireTypes.i64 then
			local v3529

			v3529, n189 = proto.readFixed64(p284, n189)
		else
			error("Unsupported wire type: " .. v3522)
		end
	end

	return v3519
end
function t481.jsonEncode(p285) -- line: 19729
	local t483 = {}

	if p285.title ~= nil and p285.title ~= "" then
		t483.title = p285.title
	end

	if p285.subtitle ~= nil and p285.subtitle ~= "" then
		t483.subtitle = p285.subtitle
	end

	return t483
end
function t481.jsonDecode(t484: {[any]: any}) -- line: 19743
	-- upvalues: t481 (copy)
	local v3533 = t481.new()

	if t484.title ~= nil then
		v3533.title = t484.title
	end

	if t484.subtitle ~= nil then
		v3533.subtitle = t484.subtitle
	end

	return v3533
end

t481.descriptor = {
	name = "AttributionRowInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.AttributionRowInputData"
}
t1.AttributionRowInputData = t481
typeRegistry.default:register(t1.AttributionRowInputData)

local t485 = {}

t485.__index = t485

function t485.new(t486: {[any]: any}?) -- line: 19771
	-- upvalues: t485 (copy)
	return (setmetatable({
		image_asset_id = if t486 ~= nil and t486.image_asset_id ~= nil then t486.image_asset_id else ""
	}, t485))
end
function t485.encode(p286) -- line: 19777
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n190 = 0

	if p286.image_asset_id ~= nil and p286.image_asset_id ~= "" then
		local v3538, v3539 = proto.writeTag(buf, n190, 1, proto.wireTypes.lengthDelimited)

		buf, n190 = proto.writeString(v3538, v3539, p286.image_asset_id)
	end

	local buf105 = buffer.create(n190)

	buffer.copy(buf105, 0, buf, 0, n190)

	return buf105
end
function t485.decode(p287: buffer) -- line: 19791
	-- upvalues: t485 (copy), proto (copy)
	local v3542 = t485.new()
	local n191 = 0

	while n191 < buffer.len(p287) do
		local v3544, v3545

		v3544, v3545, n191 = proto.readTag(p287, n191)

		if v3545 == proto.wireTypes.varint then
			local v3546

			v3546, n191 = proto.readVarInt(p287, n191)
		elseif v3545 == proto.wireTypes.lengthDelimited then
			if v3544 == 1 then
				local v3547

				v3547, n191 = proto.readBuffer(p287, n191)
				v3542.image_asset_id = buffer.tostring(v3547)
			else
				local v3548, v3549 = proto.readVarInt(p287, n191)

				n191 = v3549 + v3548
			end
		elseif v3545 == proto.wireTypes.i32 then
			local v3550

			v3550, n191 = proto.readFixed32(p287, n191)
		elseif v3545 == proto.wireTypes.i64 then
			local v3551

			v3551, n191 = proto.readFixed64(p287, n191)
		else
			error("Unsupported wire type: " .. v3545)
		end
	end

	return v3542
end
function t485.jsonEncode(p288) -- line: 19834
	local t487 = {}

	if p288.image_asset_id ~= nil and p288.image_asset_id ~= "" then
		t487.imageAssetId = p288.image_asset_id
	end

	return t487
end
function t485.jsonDecode(t488: {[any]: any}) -- line: 19844
	-- upvalues: t485 (copy)
	local v3555 = t485.new()

	if t488.image_asset_id ~= nil then
		v3555.image_asset_id = t488.image_asset_id
	end

	if t488.imageAssetId ~= nil then
		v3555.image_asset_id = t488.imageAssetId
	end

	return v3555
end

t485.descriptor = {
	name = "ImageInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ImageInputData"
}
t1.ImageInputData = t485
typeRegistry.default:register(t1.ImageInputData)

local t489 = {}

t489.__index = t489

function t489.new(t490: {[any]: any}?) -- line: 19872
	-- upvalues: t489 (copy)
	return (setmetatable({
		text = if t490 ~= nil and t490.text ~= nil then t490.text else "",
		is_rendered_text = t490 ~= nil and (t490.is_rendered_text ~= nil and t490.is_rendered_text)
	}, t489))
end
function t489.encode(p289) -- line: 19879
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n192 = 0

	if p289.text ~= nil and p289.text ~= "" then
		local v3560, v3561 = proto.writeTag(buf, n192, 1, proto.wireTypes.lengthDelimited)

		buf, n192 = proto.writeString(v3560, v3561, p289.text)
	end

	if p289.is_rendered_text then
		local v3562, v3563 = proto.writeTag(buf, n192, 2, proto.wireTypes.varint)

		buf, n192 = proto.writeVarInt(v3562, v3563, not p289.is_rendered_text and 0 or 1)
	end

	local buf106 = buffer.create(n192)

	buffer.copy(buf106, 0, buf, 0, n192)

	return buf106
end
function t489.decode(p290: buffer) -- line: 19898
	-- upvalues: t489 (copy), proto (copy)
	local v3566 = t489.new()
	local n193 = 0

	while n193 < buffer.len(p290) do
		local v3568, v3569

		v3568, v3569, n193 = proto.readTag(p290, n193)

		if v3569 == proto.wireTypes.varint then
			if v3568 == 2 then
				local v3570

				v3570, n193 = proto.readVarInt(p290, n193)
				v3566.is_rendered_text = v3570 ~= 0
			else
				local v3571

				v3571, n193 = proto.readVarInt(p290, n193)
			end
		elseif v3569 == proto.wireTypes.lengthDelimited then
			if v3568 == 1 then
				local v3572

				v3572, n193 = proto.readBuffer(p290, n193)
				v3566.text = buffer.tostring(v3572)
			else
				local v3573, v3574 = proto.readVarInt(p290, n193)

				n193 = v3574 + v3573
			end
		elseif v3569 == proto.wireTypes.i32 then
			local v3575

			v3575, n193 = proto.readFixed32(p290, n193)
		elseif v3569 == proto.wireTypes.i64 then
			local v3576

			v3576, n193 = proto.readFixed64(p290, n193)
		else
			error("Unsupported wire type: " .. v3569)
		end
	end

	return v3566
end
function t489.jsonEncode(p291) -- line: 19946
	local t491 = {}

	if p291.text ~= nil and p291.text ~= "" then
		t491.text = p291.text
	end

	if p291.is_rendered_text then
		t491.isRenderedText = p291.is_rendered_text
	end

	return t491
end
function t489.jsonDecode(t492: {[any]: any}) -- line: 19960
	-- upvalues: t489 (copy)
	local v3580 = t489.new()

	if t492.text ~= nil then
		v3580.text = t492.text
	end

	if t492.is_rendered_text ~= nil then
		v3580.is_rendered_text = t492.is_rendered_text
	end

	if t492.isRenderedText ~= nil then
		v3580.is_rendered_text = t492.isRenderedText
	end

	return v3580
end

t489.descriptor = {
	name = "TextInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.TextInputData"
}
t1.TextInputData = t489
typeRegistry.default:register(t1.TextInputData)

local t493 = {}

t493.__index = t493

function t493.new(t494: {[any]: any}?) -- line: 19992
	-- upvalues: t493 (copy)
	return (setmetatable({
		entry_map = if t494 ~= nil and t494.entry_map ~= nil then t494.entry_map else {},
		entry_order = if t494 ~= nil and t494.entry_order ~= nil then t494.entry_order else {},
		entry_order_map = if t494 ~= nil and t494.entry_order_map ~= nil then t494.entry_order_map else {},
		content_pools = if t494 ~= nil and t494.content_pools ~= nil then t494.content_pools else {}
	}, t493))
end
function t493.encode(p292) -- line: 20001
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n194 = 0

	if p292.entry_map ~= nil and next(p292.entry_map) ~= nil then
		for v3585, v3586 in p292.entry_map do
			local buf107 = buffer.create(0)
			local v3588, v3589 = proto.writeTag(buf107, 0, 1, proto.wireTypes.lengthDelimited)
			local v3590, v3591 = proto.writeString(v3588, v3589, v3585)
			local v3592 = v3586:encode()
			local v3593, v3594 = proto.writeTag(v3590, v3591, 2, proto.wireTypes.lengthDelimited)
			local v3595, v3596 = proto.writeBuffer(v3593, v3594, v3592, buffer.len(v3592))
			local v3597, v3598 = proto.writeTag(buf, n194, 1, proto.wireTypes.lengthDelimited)

			buf, n194 = proto.writeBuffer(v3597, v3598, v3595, v3596)
		end
	end

	if p292.entry_order ~= nil and #p292.entry_order > 0 then
		for _, v3600 in p292.entry_order do
			local v3601, v3602 = proto.writeTag(buf, n194, 2, proto.wireTypes.lengthDelimited)

			buf, n194 = proto.writeString(v3601, v3602, v3600)
		end
	end

	if p292.entry_order_map ~= nil and next(p292.entry_order_map) ~= nil then
		for v3603, v3604 in p292.entry_order_map do
			local buf108 = buffer.create(0)
			local v3606, v3607 = proto.writeTag(buf108, 0, 1, proto.wireTypes.lengthDelimited)
			local v3608, v3609 = proto.writeString(v3606, v3607, v3603)
			local v3610 = v3604:encode()
			local v3611, v3612 = proto.writeTag(v3608, v3609, 2, proto.wireTypes.lengthDelimited)
			local v3613, v3614 = proto.writeBuffer(v3611, v3612, v3610, buffer.len(v3610))
			local v3615, v3616 = proto.writeTag(buf, n194, 3, proto.wireTypes.lengthDelimited)

			buf, n194 = proto.writeBuffer(v3615, v3616, v3613, v3614)
		end
	end

	if p292.content_pools ~= nil and next(p292.content_pools) ~= nil then
		for v3617, v3618 in p292.content_pools do
			local buf109 = buffer.create(0)
			local v3620, v3621 = proto.writeTag(buf109, 0, 1, proto.wireTypes.lengthDelimited)
			local v3622, v3623 = proto.writeString(v3620, v3621, v3617)
			local v3624 = v3618:encode()
			local v3625, v3626 = proto.writeTag(v3622, v3623, 2, proto.wireTypes.lengthDelimited)
			local v3627, v3628 = proto.writeBuffer(v3625, v3626, v3624, buffer.len(v3624))
			local v3629, v3630 = proto.writeTag(buf, n194, 4, proto.wireTypes.lengthDelimited)

			buf, n194 = proto.writeBuffer(v3629, v3630, v3627, v3628)
		end
	end

	local buf110 = buffer.create(n194)

	buffer.copy(buf110, 0, buf, 0, n194)

	return buf110
end
function t493.decode(p293: buffer) -- line: 20059
	-- upvalues: t493 (copy), proto (copy), t1 (copy)
	local v3633 = t493.new()
	local n195 = 0

	while n195 < buffer.len(p293) do
		local v3635, v3636

		v3635, v3636, n195 = proto.readTag(p293, n195)

		if v3636 == proto.wireTypes.varint then
			local v3637

			v3637, n195 = proto.readVarInt(p293, n195)
		elseif v3636 == proto.wireTypes.lengthDelimited then
			if v3635 == 1 then
				local v3638

				v3638, n195 = proto.readBuffer(p293, n195)

				local v3639 = t1.VerticalFeedInputData_EntryMapEntry.decode(v3638)
				local v3640 = t1.FeedEntry.new()

				v3633.entry_map[v3639.key or ""] = v3639.value or v3640
			elseif v3635 == 2 then
				local v3641

				v3641, n195 = proto.readBuffer(p293, n195)
				table.insert(v3633.entry_order, buffer.tostring(v3641))
			elseif v3635 == 3 then
				local v3642

				v3642, n195 = proto.readBuffer(p293, n195)

				local v3643 = t1.VerticalFeedInputData_EntryOrderMapEntry.decode(v3642)
				local v3644 = t1.EntryOrder.new()

				v3633.entry_order_map[v3643.key or ""] = v3643.value or v3644
			elseif v3635 == 4 then
				local v3645

				v3645, n195 = proto.readBuffer(p293, n195)

				local v3646 = t1.VerticalFeedInputData_ContentPoolsEntry.decode(v3645)
				local v3647 = t1.ContentPool.new()

				v3633.content_pools[v3646.key or ""] = v3646.value or v3647
			else
				local v3648, v3649 = proto.readVarInt(p293, n195)

				n195 = v3649 + v3648
			end
		elseif v3636 == proto.wireTypes.i32 then
			local v3650

			v3650, n195 = proto.readFixed32(p293, n195)
		elseif v3636 == proto.wireTypes.i64 then
			local v3651

			v3651, n195 = proto.readFixed64(p293, n195)
		else
			error("Unsupported wire type: " .. v3636)
		end
	end

	return v3633
end
function t493.jsonEncode(p294) -- line: 20138
	local t495 = {}

	if p294.entry_map ~= nil and next(p294.entry_map) ~= nil then
		local t496 = {}

		for v3655, v3656 in p294.entry_map do
			t496[v3655] = v3656:jsonEncode()
		end

		t495.entryMap = t496
	end

	if p294.entry_order ~= nil and #p294.entry_order > 0 then
		local t497 = {}

		for _, v3659 in p294.entry_order do
			table.insert(t497, v3659)
		end

		t495.entryOrder = t497
	end

	if p294.entry_order_map ~= nil and next(p294.entry_order_map) ~= nil then
		local t498 = {}

		for v3661, v3662 in p294.entry_order_map do
			t498[v3661] = v3662:jsonEncode()
		end

		t495.entryOrderMap = t498
	end

	if p294.content_pools ~= nil and next(p294.content_pools) ~= nil then
		local t499 = {}

		for v3664, v3665 in p294.content_pools do
			t499[v3664] = v3665:jsonEncode()
		end

		t495.contentPools = t499
	end

	return t495
end
function t493.jsonDecode(t500: {[any]: any}) -- line: 20176
	-- upvalues: t493 (copy), t1 (copy)
	local v3667 = t493.new()

	if t500.entry_map ~= nil then
		local t501 = {}

		for v3669, v3670 in t500.entry_map do
			t501[v3669] = t1.FeedEntry.jsonDecode(v3670)
		end

		v3667.entry_map = t501
	end

	if t500.entryMap ~= nil then
		local t502 = {}

		for v3672, v3673 in t500.entryMap do
			t502[v3672] = t1.FeedEntry.jsonDecode(v3673)
		end

		v3667.entry_map = t502
	end

	if t500.entry_order ~= nil then
		local t503 = {}

		for _, v3676 in t500.entry_order do
			table.insert(t503, v3676)
		end

		v3667.entry_order = t503
	end

	if t500.entryOrder ~= nil then
		local t504 = {}

		for _, v3679 in t500.entryOrder do
			table.insert(t504, v3679)
		end

		v3667.entry_order = t504
	end

	if t500.entry_order_map ~= nil then
		local t505 = {}

		for v3681, v3682 in t500.entry_order_map do
			t505[v3681] = t1.EntryOrder.jsonDecode(v3682)
		end

		v3667.entry_order_map = t505
	end

	if t500.entryOrderMap ~= nil then
		local t506 = {}

		for v3684, v3685 in t500.entryOrderMap do
			t506[v3684] = t1.EntryOrder.jsonDecode(v3685)
		end

		v3667.entry_order_map = t506
	end

	if t500.content_pools ~= nil then
		local t507 = {}

		for v3687, v3688 in t500.content_pools do
			t507[v3687] = t1.ContentPool.jsonDecode(v3688)
		end

		v3667.content_pools = t507
	end

	if t500.contentPools ~= nil then
		local t508 = {}

		for v3690, v3691 in t500.contentPools do
			t508[v3690] = t1.ContentPool.jsonDecode(v3691)
		end

		v3667.content_pools = t508
	end

	return v3667
end

t493.descriptor = {
	name = "VerticalFeedInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.VerticalFeedInputData"
}
t1.VerticalFeedInputData = t493
typeRegistry.default:register(t1.VerticalFeedInputData)

local t509 = {}

t509.__index = t509

function t509.new(t510: {[any]: any}?) -- line: 20268
	-- upvalues: t509 (copy)
	return (setmetatable({
		key = if t510 ~= nil and t510.key ~= nil then t510.key else "",
		value = if t510 ~= nil and t510.value ~= nil then t510.value else nil
	}, t509))
end
function t509.encode(p295) -- line: 20277
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n196 = 0

	if p295.key ~= nil and p295.key ~= "" then
		local v3696, v3697 = proto.writeTag(buf, n196, 1, proto.wireTypes.lengthDelimited)

		buf, n196 = proto.writeString(v3696, v3697, p295.key)
	end

	if p295.value ~= nil then
		local v3698 = p295.value:encode()
		local v3699, v3700 = proto.writeTag(buf, n196, 2, proto.wireTypes.lengthDelimited)

		buf, n196 = proto.writeBuffer(v3699, v3700, v3698, buffer.len(v3698))
	end

	local buf111 = buffer.create(n196)

	buffer.copy(buf111, 0, buf, 0, n196)

	return buf111
end
function t509.decode(p296: buffer) -- line: 20297
	-- upvalues: t509 (copy), proto (copy), t1 (copy)
	local v3703 = t509.new()
	local n197 = 0

	while n197 < buffer.len(p296) do
		local v3705, v3706

		v3705, v3706, n197 = proto.readTag(p296, n197)

		if v3706 == proto.wireTypes.varint then
			local v3707

			v3707, n197 = proto.readVarInt(p296, n197)
		elseif v3706 == proto.wireTypes.lengthDelimited then
			if v3705 == 1 then
				local v3708

				v3708, n197 = proto.readBuffer(p296, n197)
				v3703.key = buffer.tostring(v3708)
			elseif v3705 == 2 then
				local v3709

				v3709, n197 = proto.readBuffer(p296, n197)
				v3703.value = t1.FeedEntry.decode(v3709)
			else
				local v3710, v3711 = proto.readVarInt(p296, n197)

				n197 = v3711 + v3710
			end
		elseif v3706 == proto.wireTypes.i32 then
			local v3712

			v3712, n197 = proto.readFixed32(p296, n197)
		elseif v3706 == proto.wireTypes.i64 then
			local v3713

			v3713, n197 = proto.readFixed64(p296, n197)
		else
			error("Unsupported wire type: " .. v3706)
		end
	end

	return v3703
end
function t509.jsonEncode(p297) -- line: 20345
	local t511 = {}

	if p297.key ~= nil and p297.key ~= "" then
		t511.key = p297.key
	end

	if p297.value ~= nil then
		t511.value = p297.value:jsonEncode()
	end

	return t511
end
function t509.jsonDecode(t512: {[any]: any}) -- line: 20359
	-- upvalues: t509 (copy), t1 (copy)
	local v3717 = t509.new()

	if t512.key ~= nil then
		v3717.key = t512.key
	end

	if t512.value ~= nil then
		v3717.value = t1.FeedEntry.jsonDecode(t512.value)
	end

	return v3717
end

t509.descriptor = {
	name = "VerticalFeedInputData_EntryMapEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryMapEntry"
}
t1.VerticalFeedInputData_EntryMapEntry = t509
typeRegistry.default:register(t1.VerticalFeedInputData_EntryMapEntry)

local t513 = {}

t513.__index = t513

function t513.new(t514: {[any]: any}?) -- line: 20389
	-- upvalues: t513 (copy)
	return (setmetatable({
		key = if t514 ~= nil and t514.key ~= nil then t514.key else "",
		value = if t514 ~= nil and t514.value ~= nil then t514.value else nil
	}, t513))
end
function t513.encode(p298) -- line: 20398
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n198 = 0

	if p298.key ~= nil and p298.key ~= "" then
		local v3722, v3723 = proto.writeTag(buf, n198, 1, proto.wireTypes.lengthDelimited)

		buf, n198 = proto.writeString(v3722, v3723, p298.key)
	end

	if p298.value ~= nil then
		local v3724 = p298.value:encode()
		local v3725, v3726 = proto.writeTag(buf, n198, 2, proto.wireTypes.lengthDelimited)

		buf, n198 = proto.writeBuffer(v3725, v3726, v3724, buffer.len(v3724))
	end

	local buf112 = buffer.create(n198)

	buffer.copy(buf112, 0, buf, 0, n198)

	return buf112
end
function t513.decode(p299: buffer) -- line: 20420
	-- upvalues: t513 (copy), proto (copy), t1 (copy)
	local v3729 = t513.new()
	local n199 = 0

	while n199 < buffer.len(p299) do
		local v3731, v3732

		v3731, v3732, n199 = proto.readTag(p299, n199)

		if v3732 == proto.wireTypes.varint then
			local v3733

			v3733, n199 = proto.readVarInt(p299, n199)
		elseif v3732 == proto.wireTypes.lengthDelimited then
			if v3731 == 1 then
				local v3734

				v3734, n199 = proto.readBuffer(p299, n199)
				v3729.key = buffer.tostring(v3734)
			elseif v3731 == 2 then
				local v3735

				v3735, n199 = proto.readBuffer(p299, n199)
				v3729.value = t1.EntryOrder.decode(v3735)
			else
				local v3736, v3737 = proto.readVarInt(p299, n199)

				n199 = v3737 + v3736
			end
		elseif v3732 == proto.wireTypes.i32 then
			local v3738

			v3738, n199 = proto.readFixed32(p299, n199)
		elseif v3732 == proto.wireTypes.i64 then
			local v3739

			v3739, n199 = proto.readFixed64(p299, n199)
		else
			error("Unsupported wire type: " .. v3732)
		end
	end

	return v3729
end
function t513.jsonEncode(p300) -- line: 20470
	local t515 = {}

	if p300.key ~= nil and p300.key ~= "" then
		t515.key = p300.key
	end

	if p300.value ~= nil then
		t515.value = p300.value:jsonEncode()
	end

	return t515
end
function t513.jsonDecode(t516: {[any]: any}) -- line: 20486
	-- upvalues: t513 (copy), t1 (copy)
	local v3743 = t513.new()

	if t516.key ~= nil then
		v3743.key = t516.key
	end

	if t516.value ~= nil then
		v3743.value = t1.EntryOrder.jsonDecode(t516.value)
	end

	return v3743
end

t513.descriptor = {
	name = "VerticalFeedInputData_EntryOrderMapEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryOrderMapEntry"
}
t1.VerticalFeedInputData_EntryOrderMapEntry = t513
typeRegistry.default:register(t1.VerticalFeedInputData_EntryOrderMapEntry)

local t517 = {}

t517.__index = t517

function t517.new(t518: {[any]: any}?) -- line: 20516
	-- upvalues: t517 (copy)
	return (setmetatable({
		key = if t518 ~= nil and t518.key ~= nil then t518.key else "",
		value = if t518 ~= nil and t518.value ~= nil then t518.value else nil
	}, t517))
end
function t517.encode(p301) -- line: 20525
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n200 = 0

	if p301.key ~= nil and p301.key ~= "" then
		local v3748, v3749 = proto.writeTag(buf, n200, 1, proto.wireTypes.lengthDelimited)

		buf, n200 = proto.writeString(v3748, v3749, p301.key)
	end

	if p301.value ~= nil then
		local v3750 = p301.value:encode()
		local v3751, v3752 = proto.writeTag(buf, n200, 2, proto.wireTypes.lengthDelimited)

		buf, n200 = proto.writeBuffer(v3751, v3752, v3750, buffer.len(v3750))
	end

	local buf113 = buffer.create(n200)

	buffer.copy(buf113, 0, buf, 0, n200)

	return buf113
end
function t517.decode(p302: buffer) -- line: 20545
	-- upvalues: t517 (copy), proto (copy), t1 (copy)
	local v3755 = t517.new()
	local n201 = 0

	while n201 < buffer.len(p302) do
		local v3757, v3758

		v3757, v3758, n201 = proto.readTag(p302, n201)

		if v3758 == proto.wireTypes.varint then
			local v3759

			v3759, n201 = proto.readVarInt(p302, n201)
		elseif v3758 == proto.wireTypes.lengthDelimited then
			if v3757 == 1 then
				local v3760

				v3760, n201 = proto.readBuffer(p302, n201)
				v3755.key = buffer.tostring(v3760)
			elseif v3757 == 2 then
				local v3761

				v3761, n201 = proto.readBuffer(p302, n201)
				v3755.value = t1.ContentPool.decode(v3761)
			else
				local v3762, v3763 = proto.readVarInt(p302, n201)

				n201 = v3763 + v3762
			end
		elseif v3758 == proto.wireTypes.i32 then
			local v3764

			v3764, n201 = proto.readFixed32(p302, n201)
		elseif v3758 == proto.wireTypes.i64 then
			local v3765

			v3765, n201 = proto.readFixed64(p302, n201)
		else
			error("Unsupported wire type: " .. v3758)
		end
	end

	return v3755
end
function t517.jsonEncode(p303) -- line: 20593
	local t519 = {}

	if p303.key ~= nil and p303.key ~= "" then
		t519.key = p303.key
	end

	if p303.value ~= nil then
		t519.value = p303.value:jsonEncode()
	end

	return t519
end
function t517.jsonDecode(t520: {[any]: any}) -- line: 20607
	-- upvalues: t517 (copy), t1 (copy)
	local v3769 = t517.new()

	if t520.key ~= nil then
		v3769.key = t520.key
	end

	if t520.value ~= nil then
		v3769.value = t1.ContentPool.jsonDecode(t520.value)
	end

	return v3769
end

t517.descriptor = {
	name = "VerticalFeedInputData_ContentPoolsEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.ContentPoolsEntry"
}
t1.VerticalFeedInputData_ContentPoolsEntry = t517
typeRegistry.default:register(t1.VerticalFeedInputData_ContentPoolsEntry)

local t521 = {}

t521.__index = t521

function t521.new(t522: {[any]: any}?) -- line: 20637
	-- upvalues: t521 (copy)
	return (setmetatable({
		foreground_header_entry = if t522 ~= nil and t522.foreground_header_entry ~= nil then t522.foreground_header_entry else nil,
		background_header_entry = if t522 ~= nil and t522.background_header_entry ~= nil then t522.background_header_entry else nil
	}, t521))
end
function t521.encode(p304) -- line: 20648
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n202 = 0

	if p304.foreground_header_entry ~= nil then
		local v3774 = p304.foreground_header_entry:encode()
		local v3775, v3776 = proto.writeTag(buf, n202, 1, proto.wireTypes.lengthDelimited)

		buf, n202 = proto.writeBuffer(v3775, v3776, v3774, buffer.len(v3774))
	end

	if p304.background_header_entry ~= nil then
		local v3777 = p304.background_header_entry:encode()
		local v3778, v3779 = proto.writeTag(buf, n202, 2, proto.wireTypes.lengthDelimited)

		buf, n202 = proto.writeBuffer(v3778, v3779, v3777, buffer.len(v3777))
	end

	local buf114 = buffer.create(n202)

	buffer.copy(buf114, 0, buf, 0, n202)

	return buf114
end
function t521.decode(p305: buffer) -- line: 20669
	-- upvalues: t521 (copy), proto (copy), t1 (copy)
	local v3782 = t521.new()
	local n203 = 0

	while n203 < buffer.len(p305) do
		local v3784, v3785

		v3784, v3785, n203 = proto.readTag(p305, n203)

		if v3785 == proto.wireTypes.varint then
			local v3786

			v3786, n203 = proto.readVarInt(p305, n203)
		elseif v3785 == proto.wireTypes.lengthDelimited then
			if v3784 == 1 then
				local v3787

				v3787, n203 = proto.readBuffer(p305, n203)
				v3782.foreground_header_entry = t1.ForegroundHeaderEntry.decode(v3787)
			elseif v3784 == 2 then
				local v3788

				v3788, n203 = proto.readBuffer(p305, n203)
				v3782.background_header_entry = t1.BackgroundHeaderEntry.decode(v3788)
			else
				local v3789, v3790 = proto.readVarInt(p305, n203)

				n203 = v3790 + v3789
			end
		elseif v3785 == proto.wireTypes.i32 then
			local v3791

			v3791, n203 = proto.readFixed32(p305, n203)
		elseif v3785 == proto.wireTypes.i64 then
			local v3792

			v3792, n203 = proto.readFixed64(p305, n203)
		else
			error("Unsupported wire type: " .. v3785)
		end
	end

	return v3782
end
function t521.jsonEncode(p306) -- line: 20717
	local t523 = {}

	if p306.foreground_header_entry ~= nil then
		t523.foregroundHeaderEntry = p306.foreground_header_entry:jsonEncode()
	end

	if p306.background_header_entry ~= nil then
		t523.backgroundHeaderEntry = p306.background_header_entry:jsonEncode()
	end

	return t523
end
function t521.jsonDecode(t524: {[any]: any}) -- line: 20731
	-- upvalues: t521 (copy), t1 (copy)
	local v3796 = t521.new()

	if t524.foreground_header_entry ~= nil then
		v3796.foreground_header_entry = t1.ForegroundHeaderEntry.jsonDecode(t524.foreground_header_entry)
	end

	if t524.foregroundHeaderEntry ~= nil then
		v3796.foreground_header_entry = t1.ForegroundHeaderEntry.jsonDecode(t524.foregroundHeaderEntry)
	end

	if t524.background_header_entry ~= nil then
		v3796.background_header_entry = t1.BackgroundHeaderEntry.jsonDecode(t524.background_header_entry)
	end

	if t524.backgroundHeaderEntry ~= nil then
		v3796.background_header_entry = t1.BackgroundHeaderEntry.jsonDecode(t524.backgroundHeaderEntry)
	end

	return v3796
end

t521.descriptor = {
	name = "PageHeaderInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.PageHeaderInputData"
}
t1.PageHeaderInputData = t521
typeRegistry.default:register(t1.PageHeaderInputData)

local t525 = {}

t525.__index = t525

function t525.new(t526: {[any]: any}?) -- line: 20767
	-- upvalues: t525 (copy)
	return (setmetatable({
		selected_option = if t526 ~= nil and t526.selected_option ~= nil then t526.selected_option else "",
		sort_id = if t526 ~= nil and t526.sort_id ~= nil then t526.sort_id else "",
		options = if t526 ~= nil and t526.options ~= nil then t526.options else {},
		experience_carousel = if t526 ~= nil and t526.experience_carousel ~= nil then t526.experience_carousel else nil,
		feed_item_key = if t526 ~= nil and t526.feed_item_key ~= nil then t526.feed_item_key else ""
	}, t525))
end
function t525.encode(p307) -- line: 20781
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n204 = 0

	if p307.selected_option ~= nil and p307.selected_option ~= "" then
		local v3801, v3802 = proto.writeTag(buf, n204, 1, proto.wireTypes.lengthDelimited)

		buf, n204 = proto.writeString(v3801, v3802, p307.selected_option)
	end

	if p307.sort_id ~= nil and p307.sort_id ~= "" then
		local v3803, v3804 = proto.writeTag(buf, n204, 2, proto.wireTypes.lengthDelimited)

		buf, n204 = proto.writeString(v3803, v3804, p307.sort_id)
	end

	if p307.options ~= nil and #p307.options > 0 then
		for _, v3806 in p307.options do
			local v3807 = v3806:encode()
			local v3808, v3809 = proto.writeTag(buf, n204, 3, proto.wireTypes.lengthDelimited)

			buf, n204 = proto.writeBuffer(v3808, v3809, v3807, buffer.len(v3807))
		end
	end

	if p307.experience_carousel ~= nil then
		local v3810 = p307.experience_carousel:encode()
		local v3811, v3812 = proto.writeTag(buf, n204, 4, proto.wireTypes.lengthDelimited)

		buf, n204 = proto.writeBuffer(v3811, v3812, v3810, buffer.len(v3810))
	end

	if p307.feed_item_key ~= nil and p307.feed_item_key ~= "" then
		local v3813, v3814 = proto.writeTag(buf, n204, 5, proto.wireTypes.lengthDelimited)

		buf, n204 = proto.writeString(v3813, v3814, p307.feed_item_key)
	end

	local buf115 = buffer.create(n204)

	buffer.copy(buf115, 0, buf, 0, n204)

	return buf115
end
function t525.decode(p308: buffer) -- line: 20819
	-- upvalues: t525 (copy), proto (copy), t1 (copy)
	local v3817 = t525.new()
	local n205 = 0

	while n205 < buffer.len(p308) do
		local v3819, v3820

		v3819, v3820, n205 = proto.readTag(p308, n205)

		if v3820 == proto.wireTypes.varint then
			local v3821

			v3821, n205 = proto.readVarInt(p308, n205)
		elseif v3820 == proto.wireTypes.lengthDelimited then
			if v3819 == 1 then
				local v3822

				v3822, n205 = proto.readBuffer(p308, n205)
				v3817.selected_option = buffer.tostring(v3822)
			elseif v3819 == 2 then
				local v3823

				v3823, n205 = proto.readBuffer(p308, n205)
				v3817.sort_id = buffer.tostring(v3823)
			elseif v3819 == 3 then
				local v3824

				v3824, n205 = proto.readBuffer(p308, n205)
				table.insert(v3817.options, t1.SelectorOption.decode(v3824))
			elseif v3819 == 4 then
				local v3825

				v3825, n205 = proto.readBuffer(p308, n205)
				v3817.experience_carousel = t1.ExperienceCarouselInputData.decode(v3825)
			elseif v3819 == 5 then
				local v3826

				v3826, n205 = proto.readBuffer(p308, n205)
				v3817.feed_item_key = buffer.tostring(v3826)
			else
				local v3827, v3828 = proto.readVarInt(p308, n205)

				n205 = v3828 + v3827
			end
		elseif v3820 == proto.wireTypes.i32 then
			local v3829

			v3829, n205 = proto.readFixed32(p308, n205)
		elseif v3820 == proto.wireTypes.i64 then
			local v3830

			v3830, n205 = proto.readFixed64(p308, n205)
		else
			error("Unsupported wire type: " .. v3820)
		end
	end

	return v3817
end
function t525.jsonEncode(p309) -- line: 20882
	local t527 = {}

	if p309.selected_option ~= nil and p309.selected_option ~= "" then
		t527.selectedOption = p309.selected_option
	end

	if p309.sort_id ~= nil and p309.sort_id ~= "" then
		t527.sortId = p309.sort_id
	end

	if p309.options ~= nil and #p309.options > 0 then
		local t528 = {}

		for _, v3835 in p309.options do
			table.insert(t528, v3835:jsonEncode())
		end

		t527.options = t528
	end

	if p309.experience_carousel ~= nil then
		t527.experienceCarousel = p309.experience_carousel:jsonEncode()
	end

	if p309.feed_item_key ~= nil and p309.feed_item_key ~= "" then
		t527.feedItemKey = p309.feed_item_key
	end

	return t527
end
function t525.jsonDecode(t529: {[any]: any}) -- line: 20912
	-- upvalues: t525 (copy), t1 (copy)
	local v3837 = t525.new()

	if t529.selected_option ~= nil then
		v3837.selected_option = t529.selected_option
	end

	if t529.selectedOption ~= nil then
		v3837.selected_option = t529.selectedOption
	end

	if t529.sort_id ~= nil then
		v3837.sort_id = t529.sort_id
	end

	if t529.sortId ~= nil then
		v3837.sort_id = t529.sortId
	end

	if t529.options ~= nil then
		local t530 = {}

		for _, v3840 in t529.options do
			table.insert(t530, t1.SelectorOption.jsonDecode(v3840))
		end

		v3837.options = t530
	end

	if t529.experience_carousel ~= nil then
		v3837.experience_carousel = t1.ExperienceCarouselInputData.jsonDecode(t529.experience_carousel)
	end

	if t529.experienceCarousel ~= nil then
		v3837.experience_carousel = t1.ExperienceCarouselInputData.jsonDecode(t529.experienceCarousel)
	end

	if t529.feed_item_key ~= nil then
		v3837.feed_item_key = t529.feed_item_key
	end

	if t529.feedItemKey ~= nil then
		v3837.feed_item_key = t529.feedItemKey
	end

	return v3837
end

t525.descriptor = {
	name = "OptionSelectorCarouselInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.OptionSelectorCarouselInputData"
}
t1.OptionSelectorCarouselInputData = t525
typeRegistry.default:register(t1.OptionSelectorCarouselInputData)

local t531 = {}

t531.__index = t531

function t531.new(t532: {[any]: any}?) -- line: 20973
	-- upvalues: t531 (copy)
	return (setmetatable({
		id = if t532 ~= nil and t532.id ~= nil then t532.id else "",
		display_name = if t532 ~= nil and t532.display_name ~= nil then t532.display_name else "",
		is_selected = t532 ~= nil and (t532.is_selected ~= nil and t532.is_selected)
	}, t531))
end
function t531.encode(p310) -- line: 20981
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n206 = 0

	if p310.id ~= nil and p310.id ~= "" then
		local v3845, v3846 = proto.writeTag(buf, n206, 1, proto.wireTypes.lengthDelimited)

		buf, n206 = proto.writeString(v3845, v3846, p310.id)
	end

	if p310.display_name ~= nil and p310.display_name ~= "" then
		local v3847, v3848 = proto.writeTag(buf, n206, 2, proto.wireTypes.lengthDelimited)

		buf, n206 = proto.writeString(v3847, v3848, p310.display_name)
	end

	if p310.is_selected then
		local v3849, v3850 = proto.writeTag(buf, n206, 3, proto.wireTypes.varint)

		buf, n206 = proto.writeVarInt(v3849, v3850, not p310.is_selected and 0 or 1)
	end

	local buf116 = buffer.create(n206)

	buffer.copy(buf116, 0, buf, 0, n206)

	return buf116
end
function t531.decode(p311: buffer) -- line: 21005
	-- upvalues: t531 (copy), proto (copy)
	local v3853 = t531.new()
	local n207 = 0

	while n207 < buffer.len(p311) do
		local v3855, v3856

		v3855, v3856, n207 = proto.readTag(p311, n207)

		if v3856 == proto.wireTypes.varint then
			if v3855 == 3 then
				local v3857

				v3857, n207 = proto.readVarInt(p311, n207)
				v3853.is_selected = v3857 ~= 0
			else
				local v3858

				v3858, n207 = proto.readVarInt(p311, n207)
			end
		elseif v3856 == proto.wireTypes.lengthDelimited then
			if v3855 == 1 then
				local v3859

				v3859, n207 = proto.readBuffer(p311, n207)
				v3853.id = buffer.tostring(v3859)
			elseif v3855 == 2 then
				local v3860

				v3860, n207 = proto.readBuffer(p311, n207)
				v3853.display_name = buffer.tostring(v3860)
			else
				local v3861, v3862 = proto.readVarInt(p311, n207)

				n207 = v3862 + v3861
			end
		elseif v3856 == proto.wireTypes.i32 then
			local v3863

			v3863, n207 = proto.readFixed32(p311, n207)
		elseif v3856 == proto.wireTypes.i64 then
			local v3864

			v3864, n207 = proto.readFixed64(p311, n207)
		else
			error("Unsupported wire type: " .. v3856)
		end
	end

	return v3853
end
function t531.jsonEncode(p312) -- line: 21058
	local t533 = {}

	if p312.id ~= nil and p312.id ~= "" then
		t533.id = p312.id
	end

	if p312.display_name ~= nil and p312.display_name ~= "" then
		t533.displayName = p312.display_name
	end

	if p312.is_selected then
		t533.isSelected = p312.is_selected
	end

	return t533
end
function t531.jsonDecode(t534: {[any]: any}) -- line: 21076
	-- upvalues: t531 (copy)
	local v3868 = t531.new()

	if t534.id ~= nil then
		v3868.id = t534.id
	end

	if t534.display_name ~= nil then
		v3868.display_name = t534.display_name
	end

	if t534.displayName ~= nil then
		v3868.display_name = t534.displayName
	end

	if t534.is_selected ~= nil then
		v3868.is_selected = t534.is_selected
	end

	if t534.isSelected ~= nil then
		v3868.is_selected = t534.isSelected
	end

	return v3868
end

t531.descriptor = {
	name = "SelectorOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.SelectorOption"
}
t1.SelectorOption = t531
typeRegistry.default:register(t1.SelectorOption)

local t535 = {}

t535.__index = t535

function t535.new(t536: {[any]: any}?) -- line: 21116
	-- upvalues: t535 (copy)
	return (setmetatable({
		layout = if t536 ~= nil and t536.layout ~= nil then t536.layout else nil,
		kind = if t536 ~= nil and t536.kind ~= nil then t536.kind else nil
	}, t535))
end
function t535.encode(p313) -- line: 21123
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n208 = 0

	if p313.layout ~= nil then
		local v3873 = p313.layout:encode()
		local v3874, v3875 = proto.writeTag(buf, n208, 1, proto.wireTypes.lengthDelimited)

		buf, n208 = proto.writeBuffer(v3874, v3875, v3873, buffer.len(v3873))
	end

	if p313.kind ~= nil and p313.kind.type == "universe" then
		local v3876 = p313.kind.value:encode()
		local v3877, v3878 = proto.writeTag(buf, n208, 2, proto.wireTypes.lengthDelimited)

		buf, n208 = proto.writeBuffer(v3877, v3878, v3876, buffer.len(v3876))
	end

	local buf117 = buffer.create(n208)

	buffer.copy(buf117, 0, buf, 0, n208)

	return buf117
end
function t535.decode(p314: buffer) -- line: 21146
	-- upvalues: t535 (copy), proto (copy), t1 (copy)
	local v3881 = t535.new()
	local n209 = 0

	while n209 < buffer.len(p314) do
		local v3883, v3884

		v3883, v3884, n209 = proto.readTag(p314, n209)

		if v3884 == proto.wireTypes.varint then
			local v3885

			v3885, n209 = proto.readVarInt(p314, n209)
		elseif v3884 == proto.wireTypes.lengthDelimited then
			if v3883 == 1 then
				local v3886

				v3886, n209 = proto.readBuffer(p314, n209)
				v3881.layout = t1.ItemLayout.decode(v3886)
			elseif v3883 == 2 then
				local v3887

				v3887, n209 = proto.readBuffer(p314, n209)
				v3881.kind = {
					type = "universe",
					value = t1.ExperienceCarouselInputData_UniverseItem.decode(v3887)
				}
			else
				local v3888, v3889 = proto.readVarInt(p314, n209)

				n209 = v3889 + v3888
			end
		elseif v3884 == proto.wireTypes.i32 then
			local v3890

			v3890, n209 = proto.readFixed32(p314, n209)
		elseif v3884 == proto.wireTypes.i64 then
			local v3891

			v3891, n209 = proto.readFixed64(p314, n209)
		else
			error("Unsupported wire type: " .. v3884)
		end
	end

	return v3881
end
function t535.jsonEncode(p315) -- line: 21195
	local t537 = {}

	if p315.layout ~= nil then
		t537.layout = p315.layout:jsonEncode()
	end

	if p315.kind ~= nil and p315.kind.type == "universe" then
		t537.universe = p315.kind.value:jsonEncode()
	end

	return t537
end
function t535.jsonDecode(t538: {[any]: any}) -- line: 21211
	-- upvalues: t535 (copy), t1 (copy)
	local v3895 = t535.new()

	if t538.layout ~= nil then
		v3895.layout = t1.ItemLayout.jsonDecode(t538.layout)
	end

	if t538.universe ~= nil then
		v3895.kind = {
			type = "universe",
			value = t1.ExperienceCarouselInputData_UniverseItem.jsonDecode(t538.universe)
		}
	end

	return v3895
end

t535.descriptor = {
	name = "ItemWithLayout",
	fullName = "roblox.apppageplatform.shared.v1beta1.ItemWithLayout"
}
t1.ItemWithLayout = t535
typeRegistry.default:register(t1.ItemWithLayout)

local t539 = {}

t539.__index = t539

function t539.new(t540: {[any]: any}?) -- line: 21242
	-- upvalues: t539 (copy)
	return (setmetatable({
		items = if t540 ~= nil and t540.items ~= nil then t540.items else {},
		collection_item_size = if t540 ~= nil and t540.collection_item_size ~= nil then t540.collection_item_size else nil
	}, t539))
end
function t539.encode(p316) -- line: 21251
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n210 = 0

	if p316.items ~= nil and #p316.items > 0 then
		for _, v3901 in p316.items do
			local v3902 = v3901:encode()
			local v3903, v3904 = proto.writeTag(buf, n210, 1, proto.wireTypes.lengthDelimited)

			buf, n210 = proto.writeBuffer(v3903, v3904, v3902, buffer.len(v3902))
		end
	end

	if p316.collection_item_size ~= nil then
		local v3905, v3906 = proto.writeTag(buf, n210, 2, proto.wireTypes.lengthDelimited)

		buf, n210 = proto.writeString(v3905, v3906, p316.collection_item_size)
	end

	local buf118 = buffer.create(n210)

	buffer.copy(buf118, 0, buf, 0, n210)

	return buf118
end
function t539.decode(p317: buffer) -- line: 21273
	-- upvalues: t539 (copy), proto (copy), t1 (copy)
	local v3909 = t539.new()
	local n211 = 0

	while n211 < buffer.len(p317) do
		local v3911, v3912

		v3911, v3912, n211 = proto.readTag(p317, n211)

		if v3912 == proto.wireTypes.varint then
			local v3913

			v3913, n211 = proto.readVarInt(p317, n211)
		elseif v3912 == proto.wireTypes.lengthDelimited then
			if v3911 == 1 then
				local v3914

				v3914, n211 = proto.readBuffer(p317, n211)
				table.insert(v3909.items, t1.ItemWithLayout.decode(v3914))
			elseif v3911 == 2 then
				local v3915

				v3915, n211 = proto.readBuffer(p317, n211)
				v3909.collection_item_size = buffer.tostring(v3915)
			else
				local v3916, v3917 = proto.readVarInt(p317, n211)

				n211 = v3917 + v3916
			end
		elseif v3912 == proto.wireTypes.i32 then
			local v3918

			v3918, n211 = proto.readFixed32(p317, n211)
		elseif v3912 == proto.wireTypes.i64 then
			local v3919

			v3919, n211 = proto.readFixed64(p317, n211)
		else
			error("Unsupported wire type: " .. v3912)
		end
	end

	return v3909
end
function t539.jsonEncode(p318) -- line: 21321
	local t541 = {}

	if p318.items ~= nil and #p318.items > 0 then
		local t542 = {}

		for _, v3924 in p318.items do
			table.insert(t542, v3924:jsonEncode())
		end

		t541.items = t542
	end

	if p318.collection_item_size ~= nil then
		t541.collectionItemSize = p318.collection_item_size
	end

	return t541
end
function t539.jsonDecode(t543: {[any]: any}) -- line: 21339
	-- upvalues: t539 (copy), t1 (copy)
	local v3926 = t539.new()

	if t543.items ~= nil then
		local t544 = {}

		for _, v3929 in t543.items do
			table.insert(t544, t1.ItemWithLayout.jsonDecode(v3929))
		end

		v3926.items = t544
	end

	if t543.collection_item_size ~= nil then
		v3926.collection_item_size = t543.collection_item_size
	end

	if t543.collectionItemSize ~= nil then
		v3926.collection_item_size = t543.collectionItemSize
	end

	return v3926
end

t539.descriptor = {
	name = "ContentPool",
	fullName = "roblox.apppageplatform.shared.v1beta1.ContentPool"
}
t1.ContentPool = t539
typeRegistry.default:register(t1.ContentPool)

local t545 = {}

t545.__index = t545

function t545.new(t546: {[any]: any}?) -- line: 21376
	-- upvalues: t545 (copy)
	return (setmetatable({
		col_span = if t546 ~= nil and t546.col_span ~= nil then t546.col_span else 0,
		row_span = if t546 ~= nil and t546.row_span ~= nil then t546.row_span else 0,
		alignment_type = if t546 ~= nil and t546.alignment_type ~= nil then t546.alignment_type else "",
		min_row_padding = if t546 ~= nil and t546.min_row_padding ~= nil then t546.min_row_padding else 0
	}, t545))
end
function t545.encode(p319) -- line: 21385
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n212 = 0

	if p319.col_span ~= nil and p319.col_span ~= 0 then
		local v3934, v3935 = proto.writeTag(buf, n212, 1, proto.wireTypes.varint)

		buf, n212 = proto.writeVarInt(v3934, v3935, p319.col_span)
	end

	if p319.row_span ~= nil and p319.row_span ~= 0 then
		local v3936, v3937 = proto.writeTag(buf, n212, 2, proto.wireTypes.varint)

		buf, n212 = proto.writeVarInt(v3936, v3937, p319.row_span)
	end

	if p319.alignment_type ~= nil and p319.alignment_type ~= "" then
		local v3938, v3939 = proto.writeTag(buf, n212, 3, proto.wireTypes.lengthDelimited)

		buf, n212 = proto.writeString(v3938, v3939, p319.alignment_type)
	end

	if p319.min_row_padding ~= nil and p319.min_row_padding ~= 0 then
		local v3940, v3941 = proto.writeTag(buf, n212, 4, proto.wireTypes.varint)

		buf, n212 = proto.writeVarInt(v3940, v3941, p319.min_row_padding)
	end

	local buf119 = buffer.create(n212)

	buffer.copy(buf119, 0, buf, 0, n212)

	return buf119
end
function t545.decode(p320: buffer) -- line: 21414
	-- upvalues: t545 (copy), proto (copy)
	local v3944 = t545.new()
	local n213 = 0

	while n213 < buffer.len(p320) do
		local v3946, v3947

		v3946, v3947, n213 = proto.readTag(p320, n213)

		if v3947 == proto.wireTypes.varint then
			if v3946 == 1 then
				local v3948

				v3948, n213 = proto.readVarIntI32(p320, n213)
				v3944.col_span = v3948
			elseif v3946 == 2 then
				local v3949

				v3949, n213 = proto.readVarIntI32(p320, n213)
				v3944.row_span = v3949
			elseif v3946 == 4 then
				local v3950

				v3950, n213 = proto.readVarIntI32(p320, n213)
				v3944.min_row_padding = v3950
			else
				local v3951

				v3951, n213 = proto.readVarInt(p320, n213)
			end
		elseif v3947 == proto.wireTypes.lengthDelimited then
			if v3946 == 3 then
				local v3952

				v3952, n213 = proto.readBuffer(p320, n213)
				v3944.alignment_type = buffer.tostring(v3952)
			else
				local v3953, v3954 = proto.readVarInt(p320, n213)

				n213 = v3954 + v3953
			end
		elseif v3947 == proto.wireTypes.i32 then
			local v3955

			v3955, n213 = proto.readFixed32(p320, n213)
		elseif v3947 == proto.wireTypes.i64 then
			local v3956

			v3956, n213 = proto.readFixed64(p320, n213)
		else
			error("Unsupported wire type: " .. v3947)
		end
	end

	return v3944
end
function t545.jsonEncode(p321) -- line: 21472
	local t547 = {}

	if p321.col_span ~= nil and p321.col_span ~= 0 then
		t547.colSpan = p321.col_span
	end

	if p321.row_span ~= nil and p321.row_span ~= 0 then
		t547.rowSpan = p321.row_span
	end

	if p321.alignment_type ~= nil and p321.alignment_type ~= "" then
		t547.alignmentType = p321.alignment_type
	end

	if p321.min_row_padding ~= nil and p321.min_row_padding ~= 0 then
		t547.minRowPadding = p321.min_row_padding
	end

	return t547
end
function t545.jsonDecode(t548: {[any]: any}) -- line: 21494
	-- upvalues: t545 (copy)
	local v3960 = t545.new()

	if t548.col_span ~= nil then
		v3960.col_span = t548.col_span
	end

	if t548.colSpan ~= nil then
		v3960.col_span = t548.colSpan
	end

	if t548.row_span ~= nil then
		v3960.row_span = t548.row_span
	end

	if t548.rowSpan ~= nil then
		v3960.row_span = t548.rowSpan
	end

	if t548.alignment_type ~= nil then
		v3960.alignment_type = t548.alignment_type
	end

	if t548.alignmentType ~= nil then
		v3960.alignment_type = t548.alignmentType
	end

	if t548.min_row_padding ~= nil then
		v3960.min_row_padding = t548.min_row_padding
	end

	if t548.minRowPadding ~= nil then
		v3960.min_row_padding = t548.minRowPadding
	end

	return v3960
end

t545.descriptor = {
	name = "ItemLayout",
	fullName = "roblox.apppageplatform.shared.v1beta1.ItemLayout"
}
t1.ItemLayout = t545
typeRegistry.default:register(t1.ItemLayout)
t1.PageEntryFormat = {
	fromNumber = function(n214: number) -- line: 21543
		if n214 == 0 then
			return "PAGE_ENTRY_FORMAT_INVALID"
		end

		if n214 == 1 then
			return "PAGE_ENTRY_FORMAT_UNIVERSAL"
		end

		return nil
	end,
	toNumber = function(p322) -- line: 21553
		if p322 == "PAGE_ENTRY_FORMAT_INVALID" then
			return 0
		end

		if p322 == "PAGE_ENTRY_FORMAT_UNIVERSAL" then
			return 1
		end

		return p322
	end,
	fromName = function(s1: string) -- line: 21563
		if s1 == "PAGE_ENTRY_FORMAT_INVALID" then
			return "PAGE_ENTRY_FORMAT_INVALID"
		end

		if s1 == "PAGE_ENTRY_FORMAT_UNIVERSAL" then
			return "PAGE_ENTRY_FORMAT_UNIVERSAL"
		end

		return nil
	end
}

return {
	UniversalPageEntry = t1.UniversalPageEntry,
	FeedEntry = t1.FeedEntry,
	ForegroundHeaderEntry = t1.ForegroundHeaderEntry,
	BackgroundHeaderEntry = t1.BackgroundHeaderEntry,
	PageEntryInputData = t1.PageEntryInputData,
	BadgesGridInputData = t1.BadgesGridInputData,
	BadgesGridInputData_BadgeInputData = t1.BadgesGridInputData_BadgeInputData,
	BadgeDetailsInputData = t1.BadgeDetailsInputData,
	BadgeDetailsInputData_LocalizedLiterals = t1.BadgeDetailsInputData_LocalizedLiterals,
	BadgeDetailsInputData_LocalizedLiterals_InfoTable = t1.BadgeDetailsInputData_LocalizedLiterals_InfoTable,
	BadgeDetailsInputData_LocalizedLiterals_ActionModule = t1.BadgeDetailsInputData_LocalizedLiterals_ActionModule,
	BadgeDetailsInputData_LocalizedLiterals_OverflowMenu = t1.BadgeDetailsInputData_LocalizedLiterals_OverflowMenu,
	StaticInputData = t1.StaticInputData,
	ExperienceDetailsFeedInputData = t1.ExperienceDetailsFeedInputData,
	EntryOrder = t1.EntryOrder,
	ExperienceDetailsActionBarInputData = t1.ExperienceDetailsActionBarInputData,
	ExperienceDetailsBannerImageInputData = t1.ExperienceDetailsBannerImageInputData,
	ExperienceDetailsStickyHeaderInputData = t1.ExperienceDetailsStickyHeaderInputData,
	ExperienceAttributionRowInputData = t1.ExperienceAttributionRowInputData,
	ExperienceActionModuleInputData = t1.ExperienceActionModuleInputData,
	ExperienceActionModuleInputData_ConnectionPlayedUser = t1.ExperienceActionModuleInputData_ConnectionPlayedUser,
	ExperienceMediaGalleryInputData = t1.ExperienceMediaGalleryInputData,
	ExperienceMediaGalleryInputData_MediaItem = t1.ExperienceMediaGalleryInputData_MediaItem,
	ExperienceDescriptionInputData = t1.ExperienceDescriptionInputData,
	ExperienceStatRowInputData = t1.ExperienceStatRowInputData,
	ExperienceInfoTableInputData = t1.ExperienceInfoTableInputData,
	ExperienceContentRatingLabelInputData = t1.ExperienceContentRatingLabelInputData,
	ExperienceRefundPolicyInputData = t1.ExperienceRefundPolicyInputData,
	ExperiencePlayWithRewardInputData = t1.ExperiencePlayWithRewardInputData,
	SocialLinkRowInputData = t1.SocialLinkRowInputData,
	SocialLinkRowInputData_SocialLinkItem = t1.SocialLinkRowInputData_SocialLinkItem,
	ExperienceCarouselInputData = t1.ExperienceCarouselInputData,
	ExperienceCarouselInputData_UniverseItem = t1.ExperienceCarouselInputData_UniverseItem,
	SongCarouselInputData = t1.SongCarouselInputData,
	SongCarouselInputData_SongItem = t1.SongCarouselInputData_SongItem,
	EventsCarouselInputData = t1.EventsCarouselInputData,
	EventsCarouselInputData_EventItem = t1.EventsCarouselInputData_EventItem,
	DevStoreFeedInputData = t1.DevStoreFeedInputData,
	GamePassCollectionInputData = t1.GamePassCollectionInputData,
	GamePassCollectionInputData_GamePassItem = t1.GamePassCollectionInputData_GamePassItem,
	DeveloperProductCollectionInputData = t1.DeveloperProductCollectionInputData,
	DeveloperProductCollectionInputData_DeveloperProductItem = t1.DeveloperProductCollectionInputData_DeveloperProductItem,
	SubscriptionCollectionInputData = t1.SubscriptionCollectionInputData,
	SubscriptionCollectionInputData_SubscriptionItem = t1.SubscriptionCollectionInputData_SubscriptionItem,
	CardContainerCardInputData = t1.CardContainerCardInputData,
	CardContainerInputData = t1.CardContainerInputData,
	CardInputData = t1.CardInputData,
	DialogInputData = t1.DialogInputData,
	BannerInputData = t1.BannerInputData,
	TooltipInputData = t1.TooltipInputData,
	CoachmarkInputData = t1.CoachmarkInputData,
	SystemBannerInputData = t1.SystemBannerInputData,
	AgeCheckUpsellInputData = t1.AgeCheckUpsellInputData,
	PartyChatConversationUpsellInputData = t1.PartyChatConversationUpsellInputData,
	EventDetailsFeedInputData = t1.EventDetailsFeedInputData,
	EventDetailsActionBarInputData = t1.EventDetailsActionBarInputData,
	EventDescriptionInputData = t1.EventDescriptionInputData,
	EventAttributionRowInputData = t1.EventAttributionRowInputData,
	EventInfoTableInputData = t1.EventInfoTableInputData,
	EventDetailsSheetFullBleedInputData = t1.EventDetailsSheetFullBleedInputData,
	EventNotificationsModalInputData = t1.EventNotificationsModalInputData,
	ChartsFeedInputData = t1.ChartsFeedInputData,
	FilterPillsInputData = t1.FilterPillsInputData,
	FilterPillsInputData_FilterGroup = t1.FilterPillsInputData_FilterGroup,
	FilterPillsInputData_FilterOption = t1.FilterPillsInputData_FilterOption,
	SortSelectorInputData = t1.SortSelectorInputData,
	SortSelectorInputData_SortOption = t1.SortSelectorInputData_SortOption,
	UAMarketplaceCatalogItemGroupInputData = t1.UAMarketplaceCatalogItemGroupInputData,
	UAMarketplaceCatalogItemCarouselInputData = t1.UAMarketplaceCatalogItemCarouselInputData,
	WidgetStyleData = t1.WidgetStyleData,
	UAMarketplaceCatalogHeroUnitInputData = t1.UAMarketplaceCatalogHeroUnitInputData,
	UAMarketplaceCatalogFeedInputData = t1.UAMarketplaceCatalogFeedInputData,
	UAMarketplaceCatalogCategoryMenuInputData = t1.UAMarketplaceCatalogCategoryMenuInputData,
	UAMarketplaceCatalogCategoryMenuInputData_MarketplaceCatalogCategoryItem = t1.UAMarketplaceCatalogCategoryMenuInputData_MarketplaceCatalogCategoryItem,
	CatalogItemGridInputData = t1.CatalogItemGridInputData,
	CatalogItemGridInputData_CatalogItem = t1.CatalogItemGridInputData_CatalogItem,
	SearchResultsFeedInputData = t1.SearchResultsFeedInputData,
	ExperienceEmphasisTileInputData = t1.ExperienceEmphasisTileInputData,
	PowerSearchAIOverviewInputData = t1.PowerSearchAIOverviewInputData,
	UserListInputData = t1.UserListInputData,
	UserListInputData_UserItem = t1.UserListInputData_UserItem,
	CatalogItemListInputData = t1.CatalogItemListInputData,
	CatalogItemListInputData_CatalogItem = t1.CatalogItemListInputData_CatalogItem,
	ExperienceGuidelinesDialogInputData = t1.ExperienceGuidelinesDialogInputData,
	MomentsCarouselInputData = t1.MomentsCarouselInputData,
	MomentsCarouselInputData_MomentItem = t1.MomentsCarouselInputData_MomentItem,
	AttributionRowInputData = t1.AttributionRowInputData,
	ImageInputData = t1.ImageInputData,
	TextInputData = t1.TextInputData,
	VerticalFeedInputData = t1.VerticalFeedInputData,
	PageHeaderInputData = t1.PageHeaderInputData,
	OptionSelectorCarouselInputData = t1.OptionSelectorCarouselInputData,
	SelectorOption = t1.SelectorOption,
	ItemWithLayout = t1.ItemWithLayout,
	ContentPool = t1.ContentPool,
	ItemLayout = t1.ItemLayout,
	PageEntryFormat = t1.PageEntryFormat
}
