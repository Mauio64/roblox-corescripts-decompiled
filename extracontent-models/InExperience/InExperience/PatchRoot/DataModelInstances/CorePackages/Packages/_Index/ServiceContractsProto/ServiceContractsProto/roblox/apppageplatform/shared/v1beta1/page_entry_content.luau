local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local background_layer = require(script.Parent.background_layer)
local page_entry = require(script.Parent.page_entry)
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 3630
	-- upvalues: t2 (copy)
	return (setmetatable({
		page_entry = if t3 ~= nil and t3.page_entry ~= nil then t3.page_entry else nil,
		input_data = if t3 ~= nil and t3.input_data ~= nil then t3.input_data else nil
	}, t2))
end
function t2.encode(p1) -- line: 3637
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.page_entry ~= nil then
		local v123 = p1.page_entry:encode()
		local v124, v125 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeBuffer(v124, v125, v123, buffer.len(v123))
	end

	if p1.input_data ~= nil then
		local v126 = p1.input_data:encode()
		local v127, v128 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeBuffer(v127, v128, v126, buffer.len(v126))
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 3658
	-- upvalues: t2 (copy), proto (copy), page_entry (copy), t1 (copy)
	local v131 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v133, v134

		v133, v134, n2 = proto.readTag(p2, n2)

		if v134 == proto.wireTypes.varint then
			local v135

			v135, n2 = proto.readVarInt(p2, n2)
		elseif v134 == proto.wireTypes.lengthDelimited then
			if v133 == 1 then
				local v136

				v136, n2 = proto.readBuffer(p2, n2)
				v131.page_entry = page_entry.PageEntry.decode(v136)
			elseif v133 == 2 then
				local v137

				v137, n2 = proto.readBuffer(p2, n2)
				v131.input_data = t1.PageEntryInputData.decode(v137)
			else
				local v138, v139 = proto.readVarInt(p2, n2)

				n2 = v139 + v138
			end
		elseif v134 == proto.wireTypes.i32 then
			local v140

			v140, n2 = proto.readFixed32(p2, n2)
		elseif v134 == proto.wireTypes.i64 then
			local v141

			v141, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v134)
		end
	end

	return v131
end
function t2.jsonEncode(p3) -- line: 3706
	local t4 = {}

	if p3.page_entry ~= nil then
		t4.pageEntry = p3.page_entry:jsonEncode()
	end

	if p3.input_data ~= nil then
		t4.inputData = p3.input_data:jsonEncode()
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 3720
	-- upvalues: t2 (copy), page_entry (copy), t1 (copy)
	local v145 = t2.new()

	if t5.page_entry ~= nil then
		v145.page_entry = page_entry.PageEntry.jsonDecode(t5.page_entry)
	end

	if t5.pageEntry ~= nil then
		v145.page_entry = page_entry.PageEntry.jsonDecode(t5.pageEntry)
	end

	if t5.input_data ~= nil then
		v145.input_data = t1.PageEntryInputData.jsonDecode(t5.input_data)
	end

	if t5.inputData ~= nil then
		v145.input_data = t1.PageEntryInputData.jsonDecode(t5.inputData)
	end

	return v145
end

t2.descriptor = {
	name = "UniversalPageEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniversalPageEntry"
}
t1.UniversalPageEntry = t2
typeRegistry.default:register(t1.UniversalPageEntry)

local t6 = {}

t6.__index = t6

function t6.new(t7: {[any]: any}?) -- line: 3756
	-- upvalues: t6 (copy)
	return (setmetatable({
		input_data = if t7 ~= nil and t7.input_data ~= nil then t7.input_data else nil,
		roblox_component = if t7 ~= nil and t7.roblox_component ~= nil then t7.roblox_component else ""
	}, t6))
end
function t6.encode(p4) -- line: 3763
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n3 = 0

	if p4.input_data ~= nil then
		local v150 = p4.input_data:encode()
		local v151, v152 = proto.writeTag(buf, n3, 1, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeBuffer(v151, v152, v150, buffer.len(v150))
	end

	if p4.roblox_component ~= nil and p4.roblox_component ~= "" then
		local v153, v154 = proto.writeTag(buf, n3, 2, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeString(v153, v154, p4.roblox_component)
	end

	local buf3 = buffer.create(n3)

	buffer.copy(buf3, 0, buf, 0, n3)

	return buf3
end
function t6.decode(p5: buffer) -- line: 3783
	-- upvalues: t6 (copy), proto (copy), t1 (copy)
	local v157 = t6.new()
	local n4 = 0

	while n4 < buffer.len(p5) do
		local v159, v160

		v159, v160, n4 = proto.readTag(p5, n4)

		if v160 == proto.wireTypes.varint then
			local v161

			v161, n4 = proto.readVarInt(p5, n4)
		elseif v160 == proto.wireTypes.lengthDelimited then
			if v159 == 1 then
				local v162

				v162, n4 = proto.readBuffer(p5, n4)
				v157.input_data = t1.PageEntryInputData.decode(v162)
			elseif v159 == 2 then
				local v163

				v163, n4 = proto.readBuffer(p5, n4)
				v157.roblox_component = buffer.tostring(v163)
			else
				local v164, v165 = proto.readVarInt(p5, n4)

				n4 = v165 + v164
			end
		elseif v160 == proto.wireTypes.i32 then
			local v166

			v166, n4 = proto.readFixed32(p5, n4)
		elseif v160 == proto.wireTypes.i64 then
			local v167

			v167, n4 = proto.readFixed64(p5, n4)
		else
			error("Unsupported wire type: " .. v160)
		end
	end

	return v157
end
function t6.jsonEncode(p6) -- line: 3831
	local t8 = {}

	if p6.input_data ~= nil then
		t8.inputData = p6.input_data:jsonEncode()
	end

	if p6.roblox_component ~= nil and p6.roblox_component ~= "" then
		t8.robloxComponent = p6.roblox_component
	end

	return t8
end
function t6.jsonDecode(t9: {[any]: any}) -- line: 3845
	-- upvalues: t6 (copy), t1 (copy)
	local v171 = t6.new()

	if t9.input_data ~= nil then
		v171.input_data = t1.PageEntryInputData.jsonDecode(t9.input_data)
	end

	if t9.inputData ~= nil then
		v171.input_data = t1.PageEntryInputData.jsonDecode(t9.inputData)
	end

	if t9.roblox_component ~= nil then
		v171.roblox_component = t9.roblox_component
	end

	if t9.robloxComponent ~= nil then
		v171.roblox_component = t9.robloxComponent
	end

	return v171
end

t6.descriptor = {
	name = "FeedEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.FeedEntry"
}
t1.FeedEntry = t6
typeRegistry.default:register(t1.FeedEntry)

local t10 = {}

t10.__index = t10

function t10.new(t11: {[any]: any}?) -- line: 3881
	-- upvalues: t10 (copy)
	return (setmetatable({
		roblox_component = if t11 ~= nil and t11.roblox_component ~= nil then t11.roblox_component else "",
		input_data = if t11 ~= nil and t11.input_data ~= nil then t11.input_data else nil
	}, t10))
end
function t10.encode(p7) -- line: 3888
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n5 = 0

	if p7.roblox_component ~= nil and p7.roblox_component ~= "" then
		local v176, v177 = proto.writeTag(buf, n5, 1, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeString(v176, v177, p7.roblox_component)
	end

	if p7.input_data ~= nil and p7.input_data.type == "attribution_row" then
		local v178 = p7.input_data.value:encode()
		local v179, v180 = proto.writeTag(buf, n5, 2, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeBuffer(v179, v180, v178, buffer.len(v178))
	end

	local buf4 = buffer.create(n5)

	buffer.copy(buf4, 0, buf, 0, n5)

	return buf4
end
function t10.decode(p8: buffer) -- line: 3910
	-- upvalues: t10 (copy), proto (copy), t1 (copy)
	local v183 = t10.new()
	local n6 = 0

	while n6 < buffer.len(p8) do
		local v185, v186

		v185, v186, n6 = proto.readTag(p8, n6)

		if v186 == proto.wireTypes.varint then
			local v187

			v187, n6 = proto.readVarInt(p8, n6)
		elseif v186 == proto.wireTypes.lengthDelimited then
			if v185 == 1 then
				local v188

				v188, n6 = proto.readBuffer(p8, n6)
				v183.roblox_component = buffer.tostring(v188)
			elseif v185 == 2 then
				local v189

				v189, n6 = proto.readBuffer(p8, n6)
				v183.input_data = {
					type = "attribution_row",
					value = t1.AttributionRowInputData.decode(v189)
				}
			else
				local v190, v191 = proto.readVarInt(p8, n6)

				n6 = v191 + v190
			end
		elseif v186 == proto.wireTypes.i32 then
			local v192

			v192, n6 = proto.readFixed32(p8, n6)
		elseif v186 == proto.wireTypes.i64 then
			local v193

			v193, n6 = proto.readFixed64(p8, n6)
		else
			error("Unsupported wire type: " .. v186)
		end
	end

	return v183
end
function t10.jsonEncode(p9) -- line: 3959
	local t12 = {}

	if p9.roblox_component ~= nil and p9.roblox_component ~= "" then
		t12.robloxComponent = p9.roblox_component
	end

	if p9.input_data ~= nil and p9.input_data.type == "attribution_row" then
		t12.attributionRow = p9.input_data.value:jsonEncode()
	end

	return t12
end
function t10.jsonDecode(t13: {[any]: any}) -- line: 3975
	-- upvalues: t10 (copy), t1 (copy)
	local v197 = t10.new()

	if t13.roblox_component ~= nil then
		v197.roblox_component = t13.roblox_component
	end

	if t13.robloxComponent ~= nil then
		v197.roblox_component = t13.robloxComponent
	end

	if t13.attribution_row ~= nil then
		v197.input_data = {
			type = "attribution_row",
			value = t1.AttributionRowInputData.jsonDecode(t13.attribution_row)
		}
	end

	if t13.attributionRow ~= nil then
		v197.input_data = {
			type = "attribution_row",
			value = t1.AttributionRowInputData.jsonDecode(t13.attributionRow)
		}
	end

	return v197
end

t10.descriptor = {
	name = "ForegroundHeaderEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.ForegroundHeaderEntry"
}
t1.ForegroundHeaderEntry = t10
typeRegistry.default:register(t1.ForegroundHeaderEntry)

local t14 = {}

t14.__index = t14

function t14.new(t15: {[any]: any}?) -- line: 4013
	-- upvalues: t14 (copy)
	return (setmetatable({
		roblox_component = if t15 ~= nil and t15.roblox_component ~= nil then t15.roblox_component else "",
		input_data = if t15 ~= nil and t15.input_data ~= nil then t15.input_data else nil
	}, t14))
end
function t14.encode(p10) -- line: 4020
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n7 = 0

	if p10.roblox_component ~= nil and p10.roblox_component ~= "" then
		local v202, v203 = proto.writeTag(buf, n7, 1, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeString(v202, v203, p10.roblox_component)
	end

	if p10.input_data ~= nil and p10.input_data.type == "image" then
		local v204 = p10.input_data.value:encode()
		local v205, v206 = proto.writeTag(buf, n7, 2, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeBuffer(v205, v206, v204, buffer.len(v204))
	end

	local buf5 = buffer.create(n7)

	buffer.copy(buf5, 0, buf, 0, n7)

	return buf5
end
function t14.decode(p11: buffer) -- line: 4042
	-- upvalues: t14 (copy), proto (copy), t1 (copy)
	local v209 = t14.new()
	local n8 = 0

	while n8 < buffer.len(p11) do
		local v211, v212

		v211, v212, n8 = proto.readTag(p11, n8)

		if v212 == proto.wireTypes.varint then
			local v213

			v213, n8 = proto.readVarInt(p11, n8)
		elseif v212 == proto.wireTypes.lengthDelimited then
			if v211 == 1 then
				local v214

				v214, n8 = proto.readBuffer(p11, n8)
				v209.roblox_component = buffer.tostring(v214)
			elseif v211 == 2 then
				local v215

				v215, n8 = proto.readBuffer(p11, n8)
				v209.input_data = {
					type = "image",
					value = t1.ImageInputData.decode(v215)
				}
			else
				local v216, v217 = proto.readVarInt(p11, n8)

				n8 = v217 + v216
			end
		elseif v212 == proto.wireTypes.i32 then
			local v218

			v218, n8 = proto.readFixed32(p11, n8)
		elseif v212 == proto.wireTypes.i64 then
			local v219

			v219, n8 = proto.readFixed64(p11, n8)
		else
			error("Unsupported wire type: " .. v212)
		end
	end

	return v209
end
function t14.jsonEncode(p12) -- line: 4090
	local t16 = {}

	if p12.roblox_component ~= nil and p12.roblox_component ~= "" then
		t16.robloxComponent = p12.roblox_component
	end

	if p12.input_data ~= nil and p12.input_data.type == "image" then
		t16.image = p12.input_data.value:jsonEncode()
	end

	return t16
end
function t14.jsonDecode(t17: {[any]: any}) -- line: 4106
	-- upvalues: t14 (copy), t1 (copy)
	local v223 = t14.new()

	if t17.roblox_component ~= nil then
		v223.roblox_component = t17.roblox_component
	end

	if t17.robloxComponent ~= nil then
		v223.roblox_component = t17.robloxComponent
	end

	if t17.image ~= nil then
		v223.input_data = {
			type = "image",
			value = t1.ImageInputData.jsonDecode(t17.image)
		}
	end

	return v223
end

t14.descriptor = {
	name = "BackgroundHeaderEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.BackgroundHeaderEntry"
}
t1.BackgroundHeaderEntry = t14
typeRegistry.default:register(t1.BackgroundHeaderEntry)

local t18 = {}

t18.__index = t18

function t18.new(t19: {[any]: any}?) -- line: 4138
	-- upvalues: t18 (copy)
	return (setmetatable({
		kind = if t19 ~= nil and t19.kind ~= nil then t19.kind else nil
	}, t18))
end
function t18.encode(p13) -- line: 4144
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n9 = 0

	if p13.kind ~= nil then
		if p13.kind.type == "badges_grid" then
			local v228 = p13.kind.value:encode()
			local v229, v230 = proto.writeTag(buf, n9, 1, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v229, v230, v228, buffer.len(v228))
		elseif p13.kind.type == "badge_details" then
			local v231 = p13.kind.value:encode()
			local v232, v233 = proto.writeTag(buf, n9, 2, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v232, v233, v231, buffer.len(v231))
		elseif p13.kind.type == "static_content" then
			local v234 = p13.kind.value:encode()
			local v235, v236 = proto.writeTag(buf, n9, 3, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v235, v236, v234, buffer.len(v234))
		elseif p13.kind.type == "experience_attribution_row" then
			local v237 = p13.kind.value:encode()
			local v238, v239 = proto.writeTag(buf, n9, 4, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v238, v239, v237, buffer.len(v237))
		elseif p13.kind.type == "experience_action_module" then
			local v240 = p13.kind.value:encode()
			local v241, v242 = proto.writeTag(buf, n9, 5, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v241, v242, v240, buffer.len(v240))
		elseif p13.kind.type == "experience_media_gallery" then
			local v243 = p13.kind.value:encode()
			local v244, v245 = proto.writeTag(buf, n9, 6, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v244, v245, v243, buffer.len(v243))
		elseif p13.kind.type == "experience_description" then
			local v246 = p13.kind.value:encode()
			local v247, v248 = proto.writeTag(buf, n9, 7, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v247, v248, v246, buffer.len(v246))
		elseif p13.kind.type == "experience_stat_row" then
			local v249 = p13.kind.value:encode()
			local v250, v251 = proto.writeTag(buf, n9, 8, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v250, v251, v249, buffer.len(v249))
		elseif p13.kind.type == "experience_info_table" then
			local v252 = p13.kind.value:encode()
			local v253, v254 = proto.writeTag(buf, n9, 9, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v253, v254, v252, buffer.len(v252))
		elseif p13.kind.type == "social_link_row" then
			local v255 = p13.kind.value:encode()
			local v256, v257 = proto.writeTag(buf, n9, 10, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v256, v257, v255, buffer.len(v255))
		elseif p13.kind.type == "experience_carousel" then
			local v258 = p13.kind.value:encode()
			local v259, v260 = proto.writeTag(buf, n9, 11, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v259, v260, v258, buffer.len(v258))
		elseif p13.kind.type == "song_carousel" then
			local v261 = p13.kind.value:encode()
			local v262, v263 = proto.writeTag(buf, n9, 12, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v262, v263, v261, buffer.len(v261))
		elseif p13.kind.type == "events_carousel" then
			local v264 = p13.kind.value:encode()
			local v265, v266 = proto.writeTag(buf, n9, 13, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v265, v266, v264, buffer.len(v264))
		elseif p13.kind.type == "game_pass_collection" then
			local v267 = p13.kind.value:encode()
			local v268, v269 = proto.writeTag(buf, n9, 14, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v268, v269, v267, buffer.len(v267))
		elseif p13.kind.type == "developer_product_collection" then
			local v270 = p13.kind.value:encode()
			local v271, v272 = proto.writeTag(buf, n9, 15, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v271, v272, v270, buffer.len(v270))
		elseif p13.kind.type == "subscription_collection" then
			local v273 = p13.kind.value:encode()
			local v274, v275 = proto.writeTag(buf, n9, 16, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v274, v275, v273, buffer.len(v273))
		elseif p13.kind.type == "dynamic_store_category" then
			local v276 = p13.kind.value:encode()
			local v277, v278 = proto.writeTag(buf, n9, 17, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v277, v278, v276, buffer.len(v276))
		elseif p13.kind.type == "card_container" then
			local v279 = p13.kind.value:encode()
			local v280, v281 = proto.writeTag(buf, n9, 20, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v280, v281, v279, buffer.len(v279))
		elseif p13.kind.type == "card" then
			local v282 = p13.kind.value:encode()
			local v283, v284 = proto.writeTag(buf, n9, 21, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v283, v284, v282, buffer.len(v282))
		elseif p13.kind.type == "dialog" then
			local v285 = p13.kind.value:encode()
			local v286, v287 = proto.writeTag(buf, n9, 22, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v286, v287, v285, buffer.len(v285))
		elseif p13.kind.type == "banner" then
			local v288 = p13.kind.value:encode()
			local v289, v290 = proto.writeTag(buf, n9, 23, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v289, v290, v288, buffer.len(v288))
		elseif p13.kind.type == "tooltip" then
			local v291 = p13.kind.value:encode()
			local v292, v293 = proto.writeTag(buf, n9, 24, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v292, v293, v291, buffer.len(v291))
		elseif p13.kind.type == "coachmark" then
			local v294 = p13.kind.value:encode()
			local v295, v296 = proto.writeTag(buf, n9, 25, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v295, v296, v294, buffer.len(v294))
		elseif p13.kind.type == "system_banner_prompt" then
			local v297 = p13.kind.value:encode()
			local v298, v299 = proto.writeTag(buf, n9, 28, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v298, v299, v297, buffer.len(v297))
		elseif p13.kind.type == "age_check_upsell" then
			local v300 = p13.kind.value:encode()
			local v301, v302 = proto.writeTag(buf, n9, 29, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v301, v302, v300, buffer.len(v300))
		elseif p13.kind.type == "catalog_item_list" then
			local v303 = p13.kind.value:encode()
			local v304, v305 = proto.writeTag(buf, n9, 26, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v304, v305, v303, buffer.len(v303))
		elseif p13.kind.type == "user_list" then
			local v306 = p13.kind.value:encode()
			local v307, v308 = proto.writeTag(buf, n9, 27, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v307, v308, v306, buffer.len(v306))
		elseif p13.kind.type == "experience_content_rating_label" then
			local v309 = p13.kind.value:encode()
			local v310, v311 = proto.writeTag(buf, n9, 30, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v310, v311, v309, buffer.len(v309))
		elseif p13.kind.type == "experience_refund_policy" then
			local v312 = p13.kind.value:encode()
			local v313, v314 = proto.writeTag(buf, n9, 31, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v313, v314, v312, buffer.len(v312))
		elseif p13.kind.type == "experience_play_with_reward" then
			local v315 = p13.kind.value:encode()
			local v316, v317 = proto.writeTag(buf, n9, 32, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v316, v317, v315, buffer.len(v315))
		elseif p13.kind.type == "experience_guidelines_dialog" then
			local v318 = p13.kind.value:encode()
			local v319, v320 = proto.writeTag(buf, n9, 33, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v319, v320, v318, buffer.len(v318))
		elseif p13.kind.type == "community_section" then
			local v321 = p13.kind.value:encode()
			local v322, v323 = proto.writeTag(buf, n9, 35, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v322, v323, v321, buffer.len(v321))
		elseif p13.kind.type == "moments_carousel" then
			local v324 = p13.kind.value:encode()
			local v325, v326 = proto.writeTag(buf, n9, 34, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v325, v326, v324, buffer.len(v324))
		elseif p13.kind.type == "text" then
			local v327 = p13.kind.value:encode()
			local v328, v329 = proto.writeTag(buf, n9, 40, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v328, v329, v327, buffer.len(v327))
		elseif p13.kind.type == "vertical_feed" then
			local v330 = p13.kind.value:encode()
			local v331, v332 = proto.writeTag(buf, n9, 41, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v331, v332, v330, buffer.len(v330))
		elseif p13.kind.type == "page_header" then
			local v333 = p13.kind.value:encode()
			local v334, v335 = proto.writeTag(buf, n9, 42, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v334, v335, v333, buffer.len(v333))
		elseif p13.kind.type == "experience_details_feed" then
			local v336 = p13.kind.value:encode()
			local v337, v338 = proto.writeTag(buf, n9, 500, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v337, v338, v336, buffer.len(v336))
		elseif p13.kind.type == "experience_details_action_bar" then
			local v339 = p13.kind.value:encode()
			local v340, v341 = proto.writeTag(buf, n9, 501, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v340, v341, v339, buffer.len(v339))
		elseif p13.kind.type == "experience_details_banner_image" then
			local v342 = p13.kind.value:encode()
			local v343, v344 = proto.writeTag(buf, n9, 502, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v343, v344, v342, buffer.len(v342))
		elseif p13.kind.type == "experience_details_sticky_header" then
			local v345 = p13.kind.value:encode()
			local v346, v347 = proto.writeTag(buf, n9, 503, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v346, v347, v345, buffer.len(v345))
		elseif p13.kind.type == "event_details_feed" then
			local v348 = p13.kind.value:encode()
			local v349, v350 = proto.writeTag(buf, n9, 600, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v349, v350, v348, buffer.len(v348))
		elseif p13.kind.type == "event_details_action_bar" then
			local v351 = p13.kind.value:encode()
			local v352, v353 = proto.writeTag(buf, n9, 601, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v352, v353, v351, buffer.len(v351))
		elseif p13.kind.type == "event_attribution_row" then
			local v354 = p13.kind.value:encode()
			local v355, v356 = proto.writeTag(buf, n9, 602, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v355, v356, v354, buffer.len(v354))
		elseif p13.kind.type == "event_description" then
			local v357 = p13.kind.value:encode()
			local v358, v359 = proto.writeTag(buf, n9, 603, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v358, v359, v357, buffer.len(v357))
		elseif p13.kind.type == "event_info_table" then
			local v360 = p13.kind.value:encode()
			local v361, v362 = proto.writeTag(buf, n9, 604, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v361, v362, v360, buffer.len(v360))
		elseif p13.kind.type == "event_details_sheet_full_bleed" then
			local v363 = p13.kind.value:encode()
			local v364, v365 = proto.writeTag(buf, n9, 605, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v364, v365, v363, buffer.len(v363))
		elseif p13.kind.type == "event_notifications_modal" then
			local v366 = p13.kind.value:encode()
			local v367, v368 = proto.writeTag(buf, n9, 606, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v367, v368, v366, buffer.len(v366))
		elseif p13.kind.type == "dev_store_feed" then
			local v369 = p13.kind.value:encode()
			local v370, v371 = proto.writeTag(buf, n9, 700, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v370, v371, v369, buffer.len(v369))
		elseif p13.kind.type == "charts_feed" then
			local v372 = p13.kind.value:encode()
			local v373, v374 = proto.writeTag(buf, n9, 800, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v373, v374, v372, buffer.len(v372))
		elseif p13.kind.type == "filter_pills" then
			local v375 = p13.kind.value:encode()
			local v376, v377 = proto.writeTag(buf, n9, 801, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v376, v377, v375, buffer.len(v375))
		elseif p13.kind.type == "sort_selector" then
			local v378 = p13.kind.value:encode()
			local v379, v380 = proto.writeTag(buf, n9, 802, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v379, v380, v378, buffer.len(v378))
		elseif p13.kind.type == "genre_selector" then
			local v381 = p13.kind.value:encode()
			local v382, v383 = proto.writeTag(buf, n9, 803, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v382, v383, v381, buffer.len(v381))
		elseif p13.kind.type == "marketplace_catalog_feed" then
			local v384 = p13.kind.value:encode()
			local v385, v386 = proto.writeTag(buf, n9, 900, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v385, v386, v384, buffer.len(v384))
		elseif p13.kind.type == "marketplace_catalog_category_menu" then
			local v387 = p13.kind.value:encode()
			local v388, v389 = proto.writeTag(buf, n9, 901, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v388, v389, v387, buffer.len(v387))
		elseif p13.kind.type == "marketplace_catalog_item_group" then
			local v390 = p13.kind.value:encode()
			local v391, v392 = proto.writeTag(buf, n9, 902, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v391, v392, v390, buffer.len(v390))
		elseif p13.kind.type == "marketplace_catalog_item_carousel" then
			local v393 = p13.kind.value:encode()
			local v394, v395 = proto.writeTag(buf, n9, 903, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v394, v395, v393, buffer.len(v393))
		elseif p13.kind.type == "marketplace_catalog_hero_unit" then
			local v396 = p13.kind.value:encode()
			local v397, v398 = proto.writeTag(buf, n9, 904, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v397, v398, v396, buffer.len(v396))
		elseif p13.kind.type == "catalog_item_grid" then
			local v399 = p13.kind.value:encode()
			local v400, v401 = proto.writeTag(buf, n9, 905, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v400, v401, v399, buffer.len(v399))
		elseif p13.kind.type == "marketplace_offer_modal" then
			local v402 = p13.kind.value:encode()
			local v403, v404 = proto.writeTag(buf, n9, 906, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v403, v404, v402, buffer.len(v402))
		elseif p13.kind.type == "search_results_feed" then
			local v405 = p13.kind.value:encode()
			local v406, v407 = proto.writeTag(buf, n9, 1000, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v406, v407, v405, buffer.len(v405))
		elseif p13.kind.type == "power_search_ai_overview" then
			local v408 = p13.kind.value:encode()
			local v409, v410 = proto.writeTag(buf, n9, 1001, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v409, v410, v408, buffer.len(v408))
		elseif p13.kind.type == "experience_emphasis_tile" then
			local v411 = p13.kind.value:encode()
			local v412, v413 = proto.writeTag(buf, n9, 1002, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v412, v413, v411, buffer.len(v411))
		elseif p13.kind.type == "option_selector_carousel" then
			local v414 = p13.kind.value:encode()
			local v415, v416 = proto.writeTag(buf, n9, 1100, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v415, v416, v414, buffer.len(v414))
		elseif p13.kind.type == "party_chat_conversation_upsell" then
			local v417 = p13.kind.value:encode()
			local v418, v419 = proto.writeTag(buf, n9, 1200, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v418, v419, v417, buffer.len(v417))
		end
	end

	local buf6 = buffer.create(n9)

	buffer.copy(buf6, 0, buf, 0, n9)

	return buf6
end
function t18.decode(p14: buffer) -- line: 4413
	-- upvalues: t18 (copy), proto (copy), t1 (copy)
	local v422 = t18.new()
	local n10 = 0

	while n10 < buffer.len(p14) do
		local v424, v425

		v424, v425, n10 = proto.readTag(p14, n10)

		if v425 == proto.wireTypes.varint then
			local v426

			v426, n10 = proto.readVarInt(p14, n10)
		elseif v425 == proto.wireTypes.lengthDelimited then
			if v424 == 1 then
				local v427

				v427, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "badges_grid",
					value = t1.BadgesGridInputData.decode(v427)
				}
			elseif v424 == 2 then
				local v428

				v428, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "badge_details",
					value = t1.BadgeDetailsInputData.decode(v428)
				}
			elseif v424 == 3 then
				local v429

				v429, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "static_content",
					value = t1.StaticInputData.decode(v429)
				}
			elseif v424 == 4 then
				local v430

				v430, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "experience_attribution_row",
					value = t1.ExperienceAttributionRowInputData.decode(v430)
				}
			elseif v424 == 5 then
				local v431

				v431, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "experience_action_module",
					value = t1.ExperienceActionModuleInputData.decode(v431)
				}
			elseif v424 == 6 then
				local v432

				v432, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "experience_media_gallery",
					value = t1.ExperienceMediaGalleryInputData.decode(v432)
				}
			elseif v424 == 7 then
				local v433

				v433, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "experience_description",
					value = t1.ExperienceDescriptionInputData.decode(v433)
				}
			elseif v424 == 8 then
				local v434

				v434, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "experience_stat_row",
					value = t1.ExperienceStatRowInputData.decode(v434)
				}
			elseif v424 == 9 then
				local v435

				v435, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "experience_info_table",
					value = t1.ExperienceInfoTableInputData.decode(v435)
				}
			elseif v424 == 10 then
				local v436

				v436, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "social_link_row",
					value = t1.SocialLinkRowInputData.decode(v436)
				}
			elseif v424 == 11 then
				local v437

				v437, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "experience_carousel",
					value = t1.ExperienceCarouselInputData.decode(v437)
				}
			elseif v424 == 12 then
				local v438

				v438, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "song_carousel",
					value = t1.SongCarouselInputData.decode(v438)
				}
			elseif v424 == 13 then
				local v439

				v439, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "events_carousel",
					value = t1.EventsCarouselInputData.decode(v439)
				}
			elseif v424 == 14 then
				local v440

				v440, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "game_pass_collection",
					value = t1.GamePassCollectionInputData.decode(v440)
				}
			elseif v424 == 15 then
				local v441

				v441, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "developer_product_collection",
					value = t1.DeveloperProductCollectionInputData.decode(v441)
				}
			elseif v424 == 16 then
				local v442

				v442, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "subscription_collection",
					value = t1.SubscriptionCollectionInputData.decode(v442)
				}
			elseif v424 == 17 then
				local v443

				v443, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "dynamic_store_category",
					value = t1.DynamicStoreCategoryInputData.decode(v443)
				}
			elseif v424 == 20 then
				local v444

				v444, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "card_container",
					value = t1.CardContainerInputData.decode(v444)
				}
			elseif v424 == 21 then
				local v445

				v445, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "card",
					value = t1.CardInputData.decode(v445)
				}
			elseif v424 == 22 then
				local v446

				v446, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "dialog",
					value = t1.DialogInputData.decode(v446)
				}
			elseif v424 == 23 then
				local v447

				v447, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "banner",
					value = t1.BannerInputData.decode(v447)
				}
			elseif v424 == 24 then
				local v448

				v448, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "tooltip",
					value = t1.TooltipInputData.decode(v448)
				}
			elseif v424 == 25 then
				local v449

				v449, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "coachmark",
					value = t1.CoachmarkInputData.decode(v449)
				}
			elseif v424 == 26 then
				local v450

				v450, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "catalog_item_list",
					value = t1.CatalogItemListInputData.decode(v450)
				}
			elseif v424 == 27 then
				local v451

				v451, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "user_list",
					value = t1.UserListInputData.decode(v451)
				}
			elseif v424 == 28 then
				local v452

				v452, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "system_banner_prompt",
					value = t1.SystemBannerInputData.decode(v452)
				}
			elseif v424 == 29 then
				local v453

				v453, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "age_check_upsell",
					value = t1.AgeCheckUpsellInputData.decode(v453)
				}
			elseif v424 == 30 then
				local v454

				v454, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "experience_content_rating_label",
					value = t1.ExperienceContentRatingLabelInputData.decode(v454)
				}
			elseif v424 == 31 then
				local v455

				v455, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "experience_refund_policy",
					value = t1.ExperienceRefundPolicyInputData.decode(v455)
				}
			elseif v424 == 32 then
				local v456

				v456, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "experience_play_with_reward",
					value = t1.ExperiencePlayWithRewardInputData.decode(v456)
				}
			elseif v424 == 33 then
				local v457

				v457, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "experience_guidelines_dialog",
					value = t1.ExperienceGuidelinesDialogInputData.decode(v457)
				}
			elseif v424 == 34 then
				local v458

				v458, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "moments_carousel",
					value = t1.MomentsCarouselInputData.decode(v458)
				}
			elseif v424 == 35 then
				local v459

				v459, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "community_section",
					value = t1.CommunitySectionInputData.decode(v459)
				}
			elseif v424 == 40 then
				local v460

				v460, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "text",
					value = t1.TextInputData.decode(v460)
				}
			elseif v424 == 41 then
				local v461

				v461, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "vertical_feed",
					value = t1.VerticalFeedInputData.decode(v461)
				}
			elseif v424 == 42 then
				local v462

				v462, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "page_header",
					value = t1.PageHeaderInputData.decode(v462)
				}
			elseif v424 == 500 then
				local v463

				v463, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "experience_details_feed",
					value = t1.ExperienceDetailsFeedInputData.decode(v463)
				}
			elseif v424 == 501 then
				local v464

				v464, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "experience_details_action_bar",
					value = t1.ExperienceDetailsActionBarInputData.decode(v464)
				}
			elseif v424 == 502 then
				local v465

				v465, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "experience_details_banner_image",
					value = t1.ExperienceDetailsBannerImageInputData.decode(v465)
				}
			elseif v424 == 503 then
				local v466

				v466, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "experience_details_sticky_header",
					value = t1.ExperienceDetailsStickyHeaderInputData.decode(v466)
				}
			elseif v424 == 600 then
				local v467

				v467, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "event_details_feed",
					value = t1.EventDetailsFeedInputData.decode(v467)
				}
			elseif v424 == 601 then
				local v468

				v468, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "event_details_action_bar",
					value = t1.EventDetailsActionBarInputData.decode(v468)
				}
			elseif v424 == 602 then
				local v469

				v469, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "event_attribution_row",
					value = t1.EventAttributionRowInputData.decode(v469)
				}
			elseif v424 == 603 then
				local v470

				v470, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "event_description",
					value = t1.EventDescriptionInputData.decode(v470)
				}
			elseif v424 == 604 then
				local v471

				v471, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "event_info_table",
					value = t1.EventInfoTableInputData.decode(v471)
				}
			elseif v424 == 605 then
				local v472

				v472, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "event_details_sheet_full_bleed",
					value = t1.EventDetailsSheetFullBleedInputData.decode(v472)
				}
			elseif v424 == 606 then
				local v473

				v473, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "event_notifications_modal",
					value = t1.EventNotificationsModalInputData.decode(v473)
				}
			elseif v424 == 700 then
				local v474

				v474, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "dev_store_feed",
					value = t1.DevStoreFeedInputData.decode(v474)
				}
			elseif v424 == 800 then
				local v475

				v475, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "charts_feed",
					value = t1.ChartsFeedInputData.decode(v475)
				}
			elseif v424 == 801 then
				local v476

				v476, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "filter_pills",
					value = t1.FilterPillsInputData.decode(v476)
				}
			elseif v424 == 802 then
				local v477

				v477, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "sort_selector",
					value = t1.SortSelectorInputData.decode(v477)
				}
			elseif v424 == 803 then
				local v478

				v478, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "genre_selector",
					value = t1.ChartsGenreSelectorInputData.decode(v478)
				}
			elseif v424 == 900 then
				local v479

				v479, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "marketplace_catalog_feed",
					value = t1.UAMarketplaceCatalogFeedInputData.decode(v479)
				}
			elseif v424 == 901 then
				local v480

				v480, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "marketplace_catalog_category_menu",
					value = t1.UAMarketplaceCatalogCategoryMenuInputData.decode(v480)
				}
			elseif v424 == 902 then
				local v481

				v481, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "marketplace_catalog_item_group",
					value = t1.UAMarketplaceCatalogItemGroupInputData.decode(v481)
				}
			elseif v424 == 903 then
				local v482

				v482, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "marketplace_catalog_item_carousel",
					value = t1.UAMarketplaceCatalogItemCarouselInputData.decode(v482)
				}
			elseif v424 == 904 then
				local v483

				v483, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "marketplace_catalog_hero_unit",
					value = t1.UAMarketplaceCatalogHeroUnitInputData.decode(v483)
				}
			elseif v424 == 905 then
				local v484

				v484, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "catalog_item_grid",
					value = t1.CatalogItemGridInputData.decode(v484)
				}
			elseif v424 == 906 then
				local v485

				v485, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "marketplace_offer_modal",
					value = t1.MarketplaceOfferModalInputData.decode(v485)
				}
			elseif v424 == 1000 then
				local v486

				v486, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "search_results_feed",
					value = t1.SearchResultsFeedInputData.decode(v486)
				}
			elseif v424 == 1001 then
				local v487

				v487, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "power_search_ai_overview",
					value = t1.PowerSearchAIOverviewInputData.decode(v487)
				}
			elseif v424 == 1002 then
				local v488

				v488, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "experience_emphasis_tile",
					value = t1.ExperienceEmphasisTileInputData.decode(v488)
				}
			elseif v424 == 1100 then
				local v489

				v489, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "option_selector_carousel",
					value = t1.OptionSelectorCarouselInputData.decode(v489)
				}
			elseif v424 == 1200 then
				local v490

				v490, n10 = proto.readBuffer(p14, n10)
				v422.kind = {
					type = "party_chat_conversation_upsell",
					value = t1.PartyChatConversationUpsellInputData.decode(v490)
				}
			else
				local v491, v492 = proto.readVarInt(p14, n10)

				n10 = v492 + v491
			end
		elseif v425 == proto.wireTypes.i32 then
			local v493

			v493, n10 = proto.readFixed32(p14, n10)
		elseif v425 == proto.wireTypes.i64 then
			local v494

			v494, n10 = proto.readFixed64(p14, n10)
		else
			error("Unsupported wire type: " .. v425)
		end
	end

	return v422
end
function t18.jsonEncode(p15) -- line: 4862
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

		if p15.kind.type == "dynamic_store_category" then
			t20.dynamicStoreCategory = p15.kind.value:jsonEncode()

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

		if p15.kind.type == "community_section" then
			t20.communitySection = p15.kind.value:jsonEncode()

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

		if p15.kind.type == "genre_selector" then
			t20.genreSelector = p15.kind.value:jsonEncode()

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

		if p15.kind.type == "marketplace_offer_modal" then
			t20.marketplaceOfferModal = p15.kind.value:jsonEncode()

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
function t18.jsonDecode(t21: {[any]: any}) -- line: 5000
	-- upvalues: t18 (copy), t1 (copy)
	local v498 = t18.new()

	if t21.badges_grid ~= nil then
		v498.kind = {
			type = "badges_grid",
			value = t1.BadgesGridInputData.jsonDecode(t21.badges_grid)
		}
	end

	if t21.badgesGrid ~= nil then
		v498.kind = {
			type = "badges_grid",
			value = t1.BadgesGridInputData.jsonDecode(t21.badgesGrid)
		}
	end

	if t21.badge_details ~= nil then
		v498.kind = {
			type = "badge_details",
			value = t1.BadgeDetailsInputData.jsonDecode(t21.badge_details)
		}
	end

	if t21.badgeDetails ~= nil then
		v498.kind = {
			type = "badge_details",
			value = t1.BadgeDetailsInputData.jsonDecode(t21.badgeDetails)
		}
	end

	if t21.static_content ~= nil then
		v498.kind = {
			type = "static_content",
			value = t1.StaticInputData.jsonDecode(t21.static_content)
		}
	end

	if t21.staticContent ~= nil then
		v498.kind = {
			type = "static_content",
			value = t1.StaticInputData.jsonDecode(t21.staticContent)
		}
	end

	if t21.experience_attribution_row ~= nil then
		v498.kind = {
			type = "experience_attribution_row",
			value = t1.ExperienceAttributionRowInputData.jsonDecode(t21.experience_attribution_row)
		}
	end

	if t21.experienceAttributionRow ~= nil then
		v498.kind = {
			type = "experience_attribution_row",
			value = t1.ExperienceAttributionRowInputData.jsonDecode(t21.experienceAttributionRow)
		}
	end

	if t21.experience_action_module ~= nil then
		v498.kind = {
			type = "experience_action_module",
			value = t1.ExperienceActionModuleInputData.jsonDecode(t21.experience_action_module)
		}
	end

	if t21.experienceActionModule ~= nil then
		v498.kind = {
			type = "experience_action_module",
			value = t1.ExperienceActionModuleInputData.jsonDecode(t21.experienceActionModule)
		}
	end

	if t21.experience_media_gallery ~= nil then
		v498.kind = {
			type = "experience_media_gallery",
			value = t1.ExperienceMediaGalleryInputData.jsonDecode(t21.experience_media_gallery)
		}
	end

	if t21.experienceMediaGallery ~= nil then
		v498.kind = {
			type = "experience_media_gallery",
			value = t1.ExperienceMediaGalleryInputData.jsonDecode(t21.experienceMediaGallery)
		}
	end

	if t21.experience_description ~= nil then
		v498.kind = {
			type = "experience_description",
			value = t1.ExperienceDescriptionInputData.jsonDecode(t21.experience_description)
		}
	end

	if t21.experienceDescription ~= nil then
		v498.kind = {
			type = "experience_description",
			value = t1.ExperienceDescriptionInputData.jsonDecode(t21.experienceDescription)
		}
	end

	if t21.experience_stat_row ~= nil then
		v498.kind = {
			type = "experience_stat_row",
			value = t1.ExperienceStatRowInputData.jsonDecode(t21.experience_stat_row)
		}
	end

	if t21.experienceStatRow ~= nil then
		v498.kind = {
			type = "experience_stat_row",
			value = t1.ExperienceStatRowInputData.jsonDecode(t21.experienceStatRow)
		}
	end

	if t21.experience_info_table ~= nil then
		v498.kind = {
			type = "experience_info_table",
			value = t1.ExperienceInfoTableInputData.jsonDecode(t21.experience_info_table)
		}
	end

	if t21.experienceInfoTable ~= nil then
		v498.kind = {
			type = "experience_info_table",
			value = t1.ExperienceInfoTableInputData.jsonDecode(t21.experienceInfoTable)
		}
	end

	if t21.social_link_row ~= nil then
		v498.kind = {
			type = "social_link_row",
			value = t1.SocialLinkRowInputData.jsonDecode(t21.social_link_row)
		}
	end

	if t21.socialLinkRow ~= nil then
		v498.kind = {
			type = "social_link_row",
			value = t1.SocialLinkRowInputData.jsonDecode(t21.socialLinkRow)
		}
	end

	if t21.experience_carousel ~= nil then
		v498.kind = {
			type = "experience_carousel",
			value = t1.ExperienceCarouselInputData.jsonDecode(t21.experience_carousel)
		}
	end

	if t21.experienceCarousel ~= nil then
		v498.kind = {
			type = "experience_carousel",
			value = t1.ExperienceCarouselInputData.jsonDecode(t21.experienceCarousel)
		}
	end

	if t21.song_carousel ~= nil then
		v498.kind = {
			type = "song_carousel",
			value = t1.SongCarouselInputData.jsonDecode(t21.song_carousel)
		}
	end

	if t21.songCarousel ~= nil then
		v498.kind = {
			type = "song_carousel",
			value = t1.SongCarouselInputData.jsonDecode(t21.songCarousel)
		}
	end

	if t21.events_carousel ~= nil then
		v498.kind = {
			type = "events_carousel",
			value = t1.EventsCarouselInputData.jsonDecode(t21.events_carousel)
		}
	end

	if t21.eventsCarousel ~= nil then
		v498.kind = {
			type = "events_carousel",
			value = t1.EventsCarouselInputData.jsonDecode(t21.eventsCarousel)
		}
	end

	if t21.game_pass_collection ~= nil then
		v498.kind = {
			type = "game_pass_collection",
			value = t1.GamePassCollectionInputData.jsonDecode(t21.game_pass_collection)
		}
	end

	if t21.gamePassCollection ~= nil then
		v498.kind = {
			type = "game_pass_collection",
			value = t1.GamePassCollectionInputData.jsonDecode(t21.gamePassCollection)
		}
	end

	if t21.developer_product_collection ~= nil then
		v498.kind = {
			type = "developer_product_collection",
			value = t1.DeveloperProductCollectionInputData.jsonDecode(t21.developer_product_collection)
		}
	end

	if t21.developerProductCollection ~= nil then
		v498.kind = {
			type = "developer_product_collection",
			value = t1.DeveloperProductCollectionInputData.jsonDecode(t21.developerProductCollection)
		}
	end

	if t21.subscription_collection ~= nil then
		v498.kind = {
			type = "subscription_collection",
			value = t1.SubscriptionCollectionInputData.jsonDecode(t21.subscription_collection)
		}
	end

	if t21.subscriptionCollection ~= nil then
		v498.kind = {
			type = "subscription_collection",
			value = t1.SubscriptionCollectionInputData.jsonDecode(t21.subscriptionCollection)
		}
	end

	if t21.dynamic_store_category ~= nil then
		v498.kind = {
			type = "dynamic_store_category",
			value = t1.DynamicStoreCategoryInputData.jsonDecode(t21.dynamic_store_category)
		}
	end

	if t21.dynamicStoreCategory ~= nil then
		v498.kind = {
			type = "dynamic_store_category",
			value = t1.DynamicStoreCategoryInputData.jsonDecode(t21.dynamicStoreCategory)
		}
	end

	if t21.card_container ~= nil then
		v498.kind = {
			type = "card_container",
			value = t1.CardContainerInputData.jsonDecode(t21.card_container)
		}
	end

	if t21.cardContainer ~= nil then
		v498.kind = {
			type = "card_container",
			value = t1.CardContainerInputData.jsonDecode(t21.cardContainer)
		}
	end

	if t21.card ~= nil then
		v498.kind = {
			type = "card",
			value = t1.CardInputData.jsonDecode(t21.card)
		}
	end

	if t21.dialog ~= nil then
		v498.kind = {
			type = "dialog",
			value = t1.DialogInputData.jsonDecode(t21.dialog)
		}
	end

	if t21.banner ~= nil then
		v498.kind = {
			type = "banner",
			value = t1.BannerInputData.jsonDecode(t21.banner)
		}
	end

	if t21.tooltip ~= nil then
		v498.kind = {
			type = "tooltip",
			value = t1.TooltipInputData.jsonDecode(t21.tooltip)
		}
	end

	if t21.coachmark ~= nil then
		v498.kind = {
			type = "coachmark",
			value = t1.CoachmarkInputData.jsonDecode(t21.coachmark)
		}
	end

	if t21.system_banner_prompt ~= nil then
		v498.kind = {
			type = "system_banner_prompt",
			value = t1.SystemBannerInputData.jsonDecode(t21.system_banner_prompt)
		}
	end

	if t21.systemBannerPrompt ~= nil then
		v498.kind = {
			type = "system_banner_prompt",
			value = t1.SystemBannerInputData.jsonDecode(t21.systemBannerPrompt)
		}
	end

	if t21.age_check_upsell ~= nil then
		v498.kind = {
			type = "age_check_upsell",
			value = t1.AgeCheckUpsellInputData.jsonDecode(t21.age_check_upsell)
		}
	end

	if t21.ageCheckUpsell ~= nil then
		v498.kind = {
			type = "age_check_upsell",
			value = t1.AgeCheckUpsellInputData.jsonDecode(t21.ageCheckUpsell)
		}
	end

	if t21.catalog_item_list ~= nil then
		v498.kind = {
			type = "catalog_item_list",
			value = t1.CatalogItemListInputData.jsonDecode(t21.catalog_item_list)
		}
	end

	if t21.catalogItemList ~= nil then
		v498.kind = {
			type = "catalog_item_list",
			value = t1.CatalogItemListInputData.jsonDecode(t21.catalogItemList)
		}
	end

	if t21.user_list ~= nil then
		v498.kind = {
			type = "user_list",
			value = t1.UserListInputData.jsonDecode(t21.user_list)
		}
	end

	if t21.userList ~= nil then
		v498.kind = {
			type = "user_list",
			value = t1.UserListInputData.jsonDecode(t21.userList)
		}
	end

	if t21.experience_content_rating_label ~= nil then
		v498.kind = {
			type = "experience_content_rating_label",
			value = t1.ExperienceContentRatingLabelInputData.jsonDecode(t21.experience_content_rating_label)
		}
	end

	if t21.experienceContentRatingLabel ~= nil then
		v498.kind = {
			type = "experience_content_rating_label",
			value = t1.ExperienceContentRatingLabelInputData.jsonDecode(t21.experienceContentRatingLabel)
		}
	end

	if t21.experience_refund_policy ~= nil then
		v498.kind = {
			type = "experience_refund_policy",
			value = t1.ExperienceRefundPolicyInputData.jsonDecode(t21.experience_refund_policy)
		}
	end

	if t21.experienceRefundPolicy ~= nil then
		v498.kind = {
			type = "experience_refund_policy",
			value = t1.ExperienceRefundPolicyInputData.jsonDecode(t21.experienceRefundPolicy)
		}
	end

	if t21.experience_play_with_reward ~= nil then
		v498.kind = {
			type = "experience_play_with_reward",
			value = t1.ExperiencePlayWithRewardInputData.jsonDecode(t21.experience_play_with_reward)
		}
	end

	if t21.experiencePlayWithReward ~= nil then
		v498.kind = {
			type = "experience_play_with_reward",
			value = t1.ExperiencePlayWithRewardInputData.jsonDecode(t21.experiencePlayWithReward)
		}
	end

	if t21.experience_guidelines_dialog ~= nil then
		v498.kind = {
			type = "experience_guidelines_dialog",
			value = t1.ExperienceGuidelinesDialogInputData.jsonDecode(t21.experience_guidelines_dialog)
		}
	end

	if t21.experienceGuidelinesDialog ~= nil then
		v498.kind = {
			type = "experience_guidelines_dialog",
			value = t1.ExperienceGuidelinesDialogInputData.jsonDecode(t21.experienceGuidelinesDialog)
		}
	end

	if t21.community_section ~= nil then
		v498.kind = {
			type = "community_section",
			value = t1.CommunitySectionInputData.jsonDecode(t21.community_section)
		}
	end

	if t21.communitySection ~= nil then
		v498.kind = {
			type = "community_section",
			value = t1.CommunitySectionInputData.jsonDecode(t21.communitySection)
		}
	end

	if t21.moments_carousel ~= nil then
		v498.kind = {
			type = "moments_carousel",
			value = t1.MomentsCarouselInputData.jsonDecode(t21.moments_carousel)
		}
	end

	if t21.momentsCarousel ~= nil then
		v498.kind = {
			type = "moments_carousel",
			value = t1.MomentsCarouselInputData.jsonDecode(t21.momentsCarousel)
		}
	end

	if t21.text ~= nil then
		v498.kind = {
			type = "text",
			value = t1.TextInputData.jsonDecode(t21.text)
		}
	end

	if t21.vertical_feed ~= nil then
		v498.kind = {
			type = "vertical_feed",
			value = t1.VerticalFeedInputData.jsonDecode(t21.vertical_feed)
		}
	end

	if t21.verticalFeed ~= nil then
		v498.kind = {
			type = "vertical_feed",
			value = t1.VerticalFeedInputData.jsonDecode(t21.verticalFeed)
		}
	end

	if t21.page_header ~= nil then
		v498.kind = {
			type = "page_header",
			value = t1.PageHeaderInputData.jsonDecode(t21.page_header)
		}
	end

	if t21.pageHeader ~= nil then
		v498.kind = {
			type = "page_header",
			value = t1.PageHeaderInputData.jsonDecode(t21.pageHeader)
		}
	end

	if t21.experience_details_feed ~= nil then
		v498.kind = {
			type = "experience_details_feed",
			value = t1.ExperienceDetailsFeedInputData.jsonDecode(t21.experience_details_feed)
		}
	end

	if t21.experienceDetailsFeed ~= nil then
		v498.kind = {
			type = "experience_details_feed",
			value = t1.ExperienceDetailsFeedInputData.jsonDecode(t21.experienceDetailsFeed)
		}
	end

	if t21.experience_details_action_bar ~= nil then
		v498.kind = {
			type = "experience_details_action_bar",
			value = t1.ExperienceDetailsActionBarInputData.jsonDecode(t21.experience_details_action_bar)
		}
	end

	if t21.experienceDetailsActionBar ~= nil then
		v498.kind = {
			type = "experience_details_action_bar",
			value = t1.ExperienceDetailsActionBarInputData.jsonDecode(t21.experienceDetailsActionBar)
		}
	end

	if t21.experience_details_banner_image ~= nil then
		v498.kind = {
			type = "experience_details_banner_image",
			value = t1.ExperienceDetailsBannerImageInputData.jsonDecode(t21.experience_details_banner_image)
		}
	end

	if t21.experienceDetailsBannerImage ~= nil then
		v498.kind = {
			type = "experience_details_banner_image",
			value = t1.ExperienceDetailsBannerImageInputData.jsonDecode(t21.experienceDetailsBannerImage)
		}
	end

	if t21.experience_details_sticky_header ~= nil then
		v498.kind = {
			type = "experience_details_sticky_header",
			value = t1.ExperienceDetailsStickyHeaderInputData.jsonDecode(t21.experience_details_sticky_header)
		}
	end

	if t21.experienceDetailsStickyHeader ~= nil then
		v498.kind = {
			type = "experience_details_sticky_header",
			value = t1.ExperienceDetailsStickyHeaderInputData.jsonDecode(t21.experienceDetailsStickyHeader)
		}
	end

	if t21.event_details_feed ~= nil then
		v498.kind = {
			type = "event_details_feed",
			value = t1.EventDetailsFeedInputData.jsonDecode(t21.event_details_feed)
		}
	end

	if t21.eventDetailsFeed ~= nil then
		v498.kind = {
			type = "event_details_feed",
			value = t1.EventDetailsFeedInputData.jsonDecode(t21.eventDetailsFeed)
		}
	end

	if t21.event_details_action_bar ~= nil then
		v498.kind = {
			type = "event_details_action_bar",
			value = t1.EventDetailsActionBarInputData.jsonDecode(t21.event_details_action_bar)
		}
	end

	if t21.eventDetailsActionBar ~= nil then
		v498.kind = {
			type = "event_details_action_bar",
			value = t1.EventDetailsActionBarInputData.jsonDecode(t21.eventDetailsActionBar)
		}
	end

	if t21.event_attribution_row ~= nil then
		v498.kind = {
			type = "event_attribution_row",
			value = t1.EventAttributionRowInputData.jsonDecode(t21.event_attribution_row)
		}
	end

	if t21.eventAttributionRow ~= nil then
		v498.kind = {
			type = "event_attribution_row",
			value = t1.EventAttributionRowInputData.jsonDecode(t21.eventAttributionRow)
		}
	end

	if t21.event_description ~= nil then
		v498.kind = {
			type = "event_description",
			value = t1.EventDescriptionInputData.jsonDecode(t21.event_description)
		}
	end

	if t21.eventDescription ~= nil then
		v498.kind = {
			type = "event_description",
			value = t1.EventDescriptionInputData.jsonDecode(t21.eventDescription)
		}
	end

	if t21.event_info_table ~= nil then
		v498.kind = {
			type = "event_info_table",
			value = t1.EventInfoTableInputData.jsonDecode(t21.event_info_table)
		}
	end

	if t21.eventInfoTable ~= nil then
		v498.kind = {
			type = "event_info_table",
			value = t1.EventInfoTableInputData.jsonDecode(t21.eventInfoTable)
		}
	end

	if t21.event_details_sheet_full_bleed ~= nil then
		v498.kind = {
			type = "event_details_sheet_full_bleed",
			value = t1.EventDetailsSheetFullBleedInputData.jsonDecode(t21.event_details_sheet_full_bleed)
		}
	end

	if t21.eventDetailsSheetFullBleed ~= nil then
		v498.kind = {
			type = "event_details_sheet_full_bleed",
			value = t1.EventDetailsSheetFullBleedInputData.jsonDecode(t21.eventDetailsSheetFullBleed)
		}
	end

	if t21.event_notifications_modal ~= nil then
		v498.kind = {
			type = "event_notifications_modal",
			value = t1.EventNotificationsModalInputData.jsonDecode(t21.event_notifications_modal)
		}
	end

	if t21.eventNotificationsModal ~= nil then
		v498.kind = {
			type = "event_notifications_modal",
			value = t1.EventNotificationsModalInputData.jsonDecode(t21.eventNotificationsModal)
		}
	end

	if t21.dev_store_feed ~= nil then
		v498.kind = {
			type = "dev_store_feed",
			value = t1.DevStoreFeedInputData.jsonDecode(t21.dev_store_feed)
		}
	end

	if t21.devStoreFeed ~= nil then
		v498.kind = {
			type = "dev_store_feed",
			value = t1.DevStoreFeedInputData.jsonDecode(t21.devStoreFeed)
		}
	end

	if t21.charts_feed ~= nil then
		v498.kind = {
			type = "charts_feed",
			value = t1.ChartsFeedInputData.jsonDecode(t21.charts_feed)
		}
	end

	if t21.chartsFeed ~= nil then
		v498.kind = {
			type = "charts_feed",
			value = t1.ChartsFeedInputData.jsonDecode(t21.chartsFeed)
		}
	end

	if t21.filter_pills ~= nil then
		v498.kind = {
			type = "filter_pills",
			value = t1.FilterPillsInputData.jsonDecode(t21.filter_pills)
		}
	end

	if t21.filterPills ~= nil then
		v498.kind = {
			type = "filter_pills",
			value = t1.FilterPillsInputData.jsonDecode(t21.filterPills)
		}
	end

	if t21.sort_selector ~= nil then
		v498.kind = {
			type = "sort_selector",
			value = t1.SortSelectorInputData.jsonDecode(t21.sort_selector)
		}
	end

	if t21.sortSelector ~= nil then
		v498.kind = {
			type = "sort_selector",
			value = t1.SortSelectorInputData.jsonDecode(t21.sortSelector)
		}
	end

	if t21.genre_selector ~= nil then
		v498.kind = {
			type = "genre_selector",
			value = t1.ChartsGenreSelectorInputData.jsonDecode(t21.genre_selector)
		}
	end

	if t21.genreSelector ~= nil then
		v498.kind = {
			type = "genre_selector",
			value = t1.ChartsGenreSelectorInputData.jsonDecode(t21.genreSelector)
		}
	end

	if t21.marketplace_catalog_feed ~= nil then
		v498.kind = {
			type = "marketplace_catalog_feed",
			value = t1.UAMarketplaceCatalogFeedInputData.jsonDecode(t21.marketplace_catalog_feed)
		}
	end

	if t21.marketplaceCatalogFeed ~= nil then
		v498.kind = {
			type = "marketplace_catalog_feed",
			value = t1.UAMarketplaceCatalogFeedInputData.jsonDecode(t21.marketplaceCatalogFeed)
		}
	end

	if t21.marketplace_catalog_category_menu ~= nil then
		v498.kind = {
			type = "marketplace_catalog_category_menu",
			value = t1.UAMarketplaceCatalogCategoryMenuInputData.jsonDecode(t21.marketplace_catalog_category_menu)
		}
	end

	if t21.marketplaceCatalogCategoryMenu ~= nil then
		v498.kind = {
			type = "marketplace_catalog_category_menu",
			value = t1.UAMarketplaceCatalogCategoryMenuInputData.jsonDecode(t21.marketplaceCatalogCategoryMenu)
		}
	end

	if t21.marketplace_catalog_item_group ~= nil then
		v498.kind = {
			type = "marketplace_catalog_item_group",
			value = t1.UAMarketplaceCatalogItemGroupInputData.jsonDecode(t21.marketplace_catalog_item_group)
		}
	end

	if t21.marketplaceCatalogItemGroup ~= nil then
		v498.kind = {
			type = "marketplace_catalog_item_group",
			value = t1.UAMarketplaceCatalogItemGroupInputData.jsonDecode(t21.marketplaceCatalogItemGroup)
		}
	end

	if t21.marketplace_catalog_item_carousel ~= nil then
		v498.kind = {
			type = "marketplace_catalog_item_carousel",
			value = t1.UAMarketplaceCatalogItemCarouselInputData.jsonDecode(t21.marketplace_catalog_item_carousel)
		}
	end

	if t21.marketplaceCatalogItemCarousel ~= nil then
		v498.kind = {
			type = "marketplace_catalog_item_carousel",
			value = t1.UAMarketplaceCatalogItemCarouselInputData.jsonDecode(t21.marketplaceCatalogItemCarousel)
		}
	end

	if t21.marketplace_catalog_hero_unit ~= nil then
		v498.kind = {
			type = "marketplace_catalog_hero_unit",
			value = t1.UAMarketplaceCatalogHeroUnitInputData.jsonDecode(t21.marketplace_catalog_hero_unit)
		}
	end

	if t21.marketplaceCatalogHeroUnit ~= nil then
		v498.kind = {
			type = "marketplace_catalog_hero_unit",
			value = t1.UAMarketplaceCatalogHeroUnitInputData.jsonDecode(t21.marketplaceCatalogHeroUnit)
		}
	end

	if t21.catalog_item_grid ~= nil then
		v498.kind = {
			type = "catalog_item_grid",
			value = t1.CatalogItemGridInputData.jsonDecode(t21.catalog_item_grid)
		}
	end

	if t21.catalogItemGrid ~= nil then
		v498.kind = {
			type = "catalog_item_grid",
			value = t1.CatalogItemGridInputData.jsonDecode(t21.catalogItemGrid)
		}
	end

	if t21.marketplace_offer_modal ~= nil then
		v498.kind = {
			type = "marketplace_offer_modal",
			value = t1.MarketplaceOfferModalInputData.jsonDecode(t21.marketplace_offer_modal)
		}
	end

	if t21.marketplaceOfferModal ~= nil then
		v498.kind = {
			type = "marketplace_offer_modal",
			value = t1.MarketplaceOfferModalInputData.jsonDecode(t21.marketplaceOfferModal)
		}
	end

	if t21.search_results_feed ~= nil then
		v498.kind = {
			type = "search_results_feed",
			value = t1.SearchResultsFeedInputData.jsonDecode(t21.search_results_feed)
		}
	end

	if t21.searchResultsFeed ~= nil then
		v498.kind = {
			type = "search_results_feed",
			value = t1.SearchResultsFeedInputData.jsonDecode(t21.searchResultsFeed)
		}
	end

	if t21.power_search_ai_overview ~= nil then
		v498.kind = {
			type = "power_search_ai_overview",
			value = t1.PowerSearchAIOverviewInputData.jsonDecode(t21.power_search_ai_overview)
		}
	end

	if t21.powerSearchAiOverview ~= nil then
		v498.kind = {
			type = "power_search_ai_overview",
			value = t1.PowerSearchAIOverviewInputData.jsonDecode(t21.powerSearchAiOverview)
		}
	end

	if t21.experience_emphasis_tile ~= nil then
		v498.kind = {
			type = "experience_emphasis_tile",
			value = t1.ExperienceEmphasisTileInputData.jsonDecode(t21.experience_emphasis_tile)
		}
	end

	if t21.experienceEmphasisTile ~= nil then
		v498.kind = {
			type = "experience_emphasis_tile",
			value = t1.ExperienceEmphasisTileInputData.jsonDecode(t21.experienceEmphasisTile)
		}
	end

	if t21.option_selector_carousel ~= nil then
		v498.kind = {
			type = "option_selector_carousel",
			value = t1.OptionSelectorCarouselInputData.jsonDecode(t21.option_selector_carousel)
		}
	end

	if t21.optionSelectorCarousel ~= nil then
		v498.kind = {
			type = "option_selector_carousel",
			value = t1.OptionSelectorCarouselInputData.jsonDecode(t21.optionSelectorCarousel)
		}
	end

	if t21.party_chat_conversation_upsell ~= nil then
		v498.kind = {
			type = "party_chat_conversation_upsell",
			value = t1.PartyChatConversationUpsellInputData.jsonDecode(t21.party_chat_conversation_upsell)
		}
	end

	if t21.partyChatConversationUpsell ~= nil then
		v498.kind = {
			type = "party_chat_conversation_upsell",
			value = t1.PartyChatConversationUpsellInputData.jsonDecode(t21.partyChatConversationUpsell)
		}
	end

	return v498
end

t18.descriptor = {
	name = "PageEntryInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.PageEntryInputData"
}
t1.PageEntryInputData = t18
typeRegistry.default:register(t1.PageEntryInputData)

local t22 = {}

t22.__index = t22

function t22.new(t23: {[any]: any}?) -- line: 5800
	-- upvalues: t22 (copy)
	return (setmetatable({
		section_title = if t23 ~= nil and t23.section_title ~= nil then t23.section_title else "",
		badges = if t23 ~= nil and t23.badges ~= nil then t23.badges else {},
		collection_id = if t23 ~= nil and t23.collection_id ~= nil then t23.collection_id else "",
		collection_position = if t23 ~= nil and t23.collection_position ~= nil then t23.collection_position else "",
		universe_id = if t23 ~= nil and t23.universe_id ~= nil then t23.universe_id else ""
	}, t22))
end
function t22.encode(p16) -- line: 5812
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n11 = 0

	if p16.section_title ~= nil and p16.section_title ~= "" then
		local v503, v504 = proto.writeTag(buf, n11, 1, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeString(v503, v504, p16.section_title)
	end

	if p16.badges ~= nil and #p16.badges > 0 then
		for _, v506 in p16.badges do
			local v507 = v506:encode()
			local v508, v509 = proto.writeTag(buf, n11, 2, proto.wireTypes.lengthDelimited)

			buf, n11 = proto.writeBuffer(v508, v509, v507, buffer.len(v507))
		end
	end

	if p16.collection_id ~= nil and p16.collection_id ~= "" then
		local v510, v511 = proto.writeTag(buf, n11, 3, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeString(v510, v511, p16.collection_id)
	end

	if p16.collection_position ~= nil and p16.collection_position ~= "" then
		local v512, v513 = proto.writeTag(buf, n11, 4, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeString(v512, v513, p16.collection_position)
	end

	if p16.universe_id ~= nil and p16.universe_id ~= "" then
		local v514, v515 = proto.writeTag(buf, n11, 5, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeString(v514, v515, p16.universe_id)
	end

	local buf7 = buffer.create(n11)

	buffer.copy(buf7, 0, buf, 0, n11)

	return buf7
end
function t22.decode(p17: buffer) -- line: 5849
	-- upvalues: t22 (copy), proto (copy), t1 (copy)
	local v518 = t22.new()
	local n12 = 0

	while n12 < buffer.len(p17) do
		local v520, v521

		v520, v521, n12 = proto.readTag(p17, n12)

		if v521 == proto.wireTypes.varint then
			local v522

			v522, n12 = proto.readVarInt(p17, n12)
		elseif v521 == proto.wireTypes.lengthDelimited then
			if v520 == 1 then
				local v523

				v523, n12 = proto.readBuffer(p17, n12)
				v518.section_title = buffer.tostring(v523)
			elseif v520 == 2 then
				local v524

				v524, n12 = proto.readBuffer(p17, n12)
				table.insert(v518.badges, t1.BadgesGridInputData_BadgeInputData.decode(v524))
			elseif v520 == 3 then
				local v525

				v525, n12 = proto.readBuffer(p17, n12)
				v518.collection_id = buffer.tostring(v525)
			elseif v520 == 4 then
				local v526

				v526, n12 = proto.readBuffer(p17, n12)
				v518.collection_position = buffer.tostring(v526)
			elseif v520 == 5 then
				local v527

				v527, n12 = proto.readBuffer(p17, n12)
				v518.universe_id = buffer.tostring(v527)
			else
				local v528, v529 = proto.readVarInt(p17, n12)

				n12 = v529 + v528
			end
		elseif v521 == proto.wireTypes.i32 then
			local v530

			v530, n12 = proto.readFixed32(p17, n12)
		elseif v521 == proto.wireTypes.i64 then
			local v531

			v531, n12 = proto.readFixed64(p17, n12)
		else
			error("Unsupported wire type: " .. v521)
		end
	end

	return v518
end
function t22.jsonEncode(p18) -- line: 5912
	local t24 = {}

	if p18.section_title ~= nil and p18.section_title ~= "" then
		t24.sectionTitle = p18.section_title
	end

	if p18.badges ~= nil and #p18.badges > 0 then
		local t25 = {}

		for _, v536 in p18.badges do
			table.insert(t25, v536:jsonEncode())
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
function t22.jsonDecode(t26: {[any]: any}) -- line: 5942
	-- upvalues: t22 (copy), t1 (copy)
	local v538 = t22.new()

	if t26.section_title ~= nil then
		v538.section_title = t26.section_title
	end

	if t26.sectionTitle ~= nil then
		v538.section_title = t26.sectionTitle
	end

	if t26.badges ~= nil then
		local t27 = {}

		for _, v541 in t26.badges do
			table.insert(t27, t1.BadgesGridInputData_BadgeInputData.jsonDecode(v541))
		end

		v538.badges = t27
	end

	if t26.collection_id ~= nil then
		v538.collection_id = t26.collection_id
	end

	if t26.collectionId ~= nil then
		v538.collection_id = t26.collectionId
	end

	if t26.collection_position ~= nil then
		v538.collection_position = t26.collection_position
	end

	if t26.collectionPosition ~= nil then
		v538.collection_position = t26.collectionPosition
	end

	if t26.universe_id ~= nil then
		v538.universe_id = t26.universe_id
	end

	if t26.universeId ~= nil then
		v538.universe_id = t26.universeId
	end

	return v538
end

t22.descriptor = {
	name = "BadgesGridInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.BadgesGridInputData"
}
t1.BadgesGridInputData = t22
typeRegistry.default:register(t1.BadgesGridInputData)

local t28 = {}

t28.__index = t28

function t28.new(t29: {[any]: any}?) -- line: 6003
	-- upvalues: t28 (copy)
	return (setmetatable({
		badge_id = if t29 ~= nil and t29.badge_id ~= nil then t29.badge_id else ""
	}, t28))
end
function t28.encode(p19) -- line: 6011
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n13 = 0

	if p19.badge_id ~= nil and p19.badge_id ~= "" then
		local v546, v547 = proto.writeTag(buf, n13, 1, proto.wireTypes.lengthDelimited)

		buf, n13 = proto.writeString(v546, v547, p19.badge_id)
	end

	local buf8 = buffer.create(n13)

	buffer.copy(buf8, 0, buf, 0, n13)

	return buf8
end
function t28.decode(p20: buffer) -- line: 6025
	-- upvalues: t28 (copy), proto (copy)
	local v550 = t28.new()
	local n14 = 0

	while n14 < buffer.len(p20) do
		local v552, v553

		v552, v553, n14 = proto.readTag(p20, n14)

		if v553 == proto.wireTypes.varint then
			local v554

			v554, n14 = proto.readVarInt(p20, n14)
		elseif v553 == proto.wireTypes.lengthDelimited then
			if v552 == 1 then
				local v555

				v555, n14 = proto.readBuffer(p20, n14)
				v550.badge_id = buffer.tostring(v555)
			else
				local v556, v557 = proto.readVarInt(p20, n14)

				n14 = v557 + v556
			end
		elseif v553 == proto.wireTypes.i32 then
			local v558

			v558, n14 = proto.readFixed32(p20, n14)
		elseif v553 == proto.wireTypes.i64 then
			local v559

			v559, n14 = proto.readFixed64(p20, n14)
		else
			error("Unsupported wire type: " .. v553)
		end
	end

	return v550
end
function t28.jsonEncode(p21) -- line: 6068
	local t30 = {}

	if p21.badge_id ~= nil and p21.badge_id ~= "" then
		t30.badgeId = p21.badge_id
	end

	return t30
end
function t28.jsonDecode(t31: {[any]: any}) -- line: 6078
	-- upvalues: t28 (copy)
	local v563 = t28.new()

	if t31.badge_id ~= nil then
		v563.badge_id = t31.badge_id
	end

	if t31.badgeId ~= nil then
		v563.badge_id = t31.badgeId
	end

	return v563
end

t28.descriptor = {
	name = "BadgesGridInputData_BadgeInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.BadgeInputData"
}
t1.BadgesGridInputData_BadgeInputData = t28
typeRegistry.default:register(t1.BadgesGridInputData_BadgeInputData)

local t32 = {}

t32.__index = t32

function t32.new(t33: {[any]: any}?) -- line: 6108
	-- upvalues: t32 (copy)
	return (setmetatable({
		badge_id = if t33 ~= nil and t33.badge_id ~= nil then t33.badge_id else "",
		universe_id = if t33 ~= nil and t33.universe_id ~= nil then t33.universe_id else "",
		localized_literals = if t33 ~= nil and t33.localized_literals ~= nil then t33.localized_literals else nil,
		creator_key = if t33 ~= nil and t33.creator_key ~= nil then t33.creator_key else ""
	}, t32))
end
function t32.encode(p22) -- line: 6117
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n15 = 0

	if p22.badge_id ~= nil and p22.badge_id ~= "" then
		local v568, v569 = proto.writeTag(buf, n15, 1, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeString(v568, v569, p22.badge_id)
	end

	if p22.universe_id ~= nil and p22.universe_id ~= "" then
		local v570, v571 = proto.writeTag(buf, n15, 2, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeString(v570, v571, p22.universe_id)
	end

	if p22.localized_literals ~= nil then
		local v572 = p22.localized_literals:encode()
		local v573, v574 = proto.writeTag(buf, n15, 3, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeBuffer(v573, v574, v572, buffer.len(v572))
	end

	if p22.creator_key ~= nil and p22.creator_key ~= "" then
		local v575, v576 = proto.writeTag(buf, n15, 4, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeString(v575, v576, p22.creator_key)
	end

	local buf9 = buffer.create(n15)

	buffer.copy(buf9, 0, buf, 0, n15)

	return buf9
end
function t32.decode(p23: buffer) -- line: 6147
	-- upvalues: t32 (copy), proto (copy), t1 (copy)
	local v579 = t32.new()
	local n16 = 0

	while n16 < buffer.len(p23) do
		local v581, v582

		v581, v582, n16 = proto.readTag(p23, n16)

		if v582 == proto.wireTypes.varint then
			local v583

			v583, n16 = proto.readVarInt(p23, n16)
		elseif v582 == proto.wireTypes.lengthDelimited then
			if v581 == 1 then
				local v584

				v584, n16 = proto.readBuffer(p23, n16)
				v579.badge_id = buffer.tostring(v584)
			elseif v581 == 2 then
				local v585

				v585, n16 = proto.readBuffer(p23, n16)
				v579.universe_id = buffer.tostring(v585)
			elseif v581 == 3 then
				local v586

				v586, n16 = proto.readBuffer(p23, n16)
				v579.localized_literals = t1.BadgeDetailsInputData_LocalizedLiterals.decode(v586)
			elseif v581 == 4 then
				local v587

				v587, n16 = proto.readBuffer(p23, n16)
				v579.creator_key = buffer.tostring(v587)
			else
				local v588, v589 = proto.readVarInt(p23, n16)

				n16 = v589 + v588
			end
		elseif v582 == proto.wireTypes.i32 then
			local v590

			v590, n16 = proto.readFixed32(p23, n16)
		elseif v582 == proto.wireTypes.i64 then
			local v591

			v591, n16 = proto.readFixed64(p23, n16)
		else
			error("Unsupported wire type: " .. v582)
		end
	end

	return v579
end
function t32.jsonEncode(p24) -- line: 6205
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
function t32.jsonDecode(t35: {[any]: any}) -- line: 6227
	-- upvalues: t32 (copy), t1 (copy)
	local v595 = t32.new()

	if t35.badge_id ~= nil then
		v595.badge_id = t35.badge_id
	end

	if t35.badgeId ~= nil then
		v595.badge_id = t35.badgeId
	end

	if t35.universe_id ~= nil then
		v595.universe_id = t35.universe_id
	end

	if t35.universeId ~= nil then
		v595.universe_id = t35.universeId
	end

	if t35.localized_literals ~= nil then
		v595.localized_literals = t1.BadgeDetailsInputData_LocalizedLiterals.jsonDecode(t35.localized_literals)
	end

	if t35.localizedLiterals ~= nil then
		v595.localized_literals = t1.BadgeDetailsInputData_LocalizedLiterals.jsonDecode(t35.localizedLiterals)
	end

	if t35.creator_key ~= nil then
		v595.creator_key = t35.creator_key
	end

	if t35.creatorKey ~= nil then
		v595.creator_key = t35.creatorKey
	end

	return v595
end

t32.descriptor = {
	name = "BadgeDetailsInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.BadgeDetailsInputData"
}
t1.BadgeDetailsInputData = t32
typeRegistry.default:register(t1.BadgeDetailsInputData)

local t36 = {}

t36.__index = t36

function t36.new(t37: {[any]: any}?) -- line: 6281
	-- upvalues: t36 (copy)
	return (setmetatable({
		info_table = if t37 ~= nil and t37.info_table ~= nil then t37.info_table else nil,
		action_module = if t37 ~= nil and t37.action_module ~= nil then t37.action_module else nil,
		overflow_menu = if t37 ~= nil and t37.overflow_menu ~= nil then t37.overflow_menu else nil
	}, t36))
end
function t36.encode(p25) -- line: 6291
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n17 = 0

	if p25.info_table ~= nil then
		local v600 = p25.info_table:encode()
		local v601, v602 = proto.writeTag(buf, n17, 1, proto.wireTypes.lengthDelimited)

		buf, n17 = proto.writeBuffer(v601, v602, v600, buffer.len(v600))
	end

	if p25.action_module ~= nil then
		local v603 = p25.action_module:encode()
		local v604, v605 = proto.writeTag(buf, n17, 2, proto.wireTypes.lengthDelimited)

		buf, n17 = proto.writeBuffer(v604, v605, v603, buffer.len(v603))
	end

	if p25.overflow_menu ~= nil then
		local v606 = p25.overflow_menu:encode()
		local v607, v608 = proto.writeTag(buf, n17, 3, proto.wireTypes.lengthDelimited)

		buf, n17 = proto.writeBuffer(v607, v608, v606, buffer.len(v606))
	end

	local buf10 = buffer.create(n17)

	buffer.copy(buf10, 0, buf, 0, n17)

	return buf10
end
function t36.decode(p26: buffer) -- line: 6318
	-- upvalues: t36 (copy), proto (copy), t1 (copy)
	local v611 = t36.new()
	local n18 = 0

	while n18 < buffer.len(p26) do
		local v613, v614

		v613, v614, n18 = proto.readTag(p26, n18)

		if v614 == proto.wireTypes.varint then
			local v615

			v615, n18 = proto.readVarInt(p26, n18)
		elseif v614 == proto.wireTypes.lengthDelimited then
			if v613 == 1 then
				local v616

				v616, n18 = proto.readBuffer(p26, n18)
				v611.info_table = t1.BadgeDetailsInputData_LocalizedLiterals_InfoTable.decode(v616)
			elseif v613 == 2 then
				local v617

				v617, n18 = proto.readBuffer(p26, n18)
				v611.action_module = t1.BadgeDetailsInputData_LocalizedLiterals_ActionModule.decode(v617)
			elseif v613 == 3 then
				local v618

				v618, n18 = proto.readBuffer(p26, n18)
				v611.overflow_menu = t1.BadgeDetailsInputData_LocalizedLiterals_OverflowMenu.decode(v618)
			else
				local v619, v620 = proto.readVarInt(p26, n18)

				n18 = v620 + v619
			end
		elseif v614 == proto.wireTypes.i32 then
			local v621

			v621, n18 = proto.readFixed32(p26, n18)
		elseif v614 == proto.wireTypes.i64 then
			local v622

			v622, n18 = proto.readFixed64(p26, n18)
		else
			error("Unsupported wire type: " .. v614)
		end
	end

	return v611
end
function t36.jsonEncode(p27) -- line: 6371
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
function t36.jsonDecode(t39: {[any]: any}) -- line: 6389
	-- upvalues: t36 (copy), t1 (copy)
	local v626 = t36.new()

	if t39.info_table ~= nil then
		v626.info_table = t1.BadgeDetailsInputData_LocalizedLiterals_InfoTable.jsonDecode(t39.info_table)
	end

	if t39.infoTable ~= nil then
		v626.info_table = t1.BadgeDetailsInputData_LocalizedLiterals_InfoTable.jsonDecode(t39.infoTable)
	end

	if t39.action_module ~= nil then
		v626.action_module = t1.BadgeDetailsInputData_LocalizedLiterals_ActionModule.jsonDecode(t39.action_module)
	end

	if t39.actionModule ~= nil then
		v626.action_module = t1.BadgeDetailsInputData_LocalizedLiterals_ActionModule.jsonDecode(t39.actionModule)
	end

	if t39.overflow_menu ~= nil then
		v626.overflow_menu = t1.BadgeDetailsInputData_LocalizedLiterals_OverflowMenu.jsonDecode(t39.overflow_menu)
	end

	if t39.overflowMenu ~= nil then
		v626.overflow_menu = t1.BadgeDetailsInputData_LocalizedLiterals_OverflowMenu.jsonDecode(t39.overflowMenu)
	end

	return v626
end

t36.descriptor = {
	name = "BadgeDetailsInputData_LocalizedLiterals",
	fullName = "roblox.apppageplatform.shared.v1beta1.LocalizedLiterals"
}
t1.BadgeDetailsInputData_LocalizedLiterals = t36
typeRegistry.default:register(t1.BadgeDetailsInputData_LocalizedLiterals)

local t40 = {}

t40.__index = t40

function t40.new(t41: {[any]: any}?) -- line: 6440
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
function t40.encode(p28) -- line: 6459
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n19 = 0

	if p28.type_label ~= nil and p28.type_label ~= "" then
		local v631, v632 = proto.writeTag(buf, n19, 1, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeString(v631, v632, p28.type_label)
	end

	if p28.earned_label ~= nil and p28.earned_label ~= "" then
		local v633, v634 = proto.writeTag(buf, n19, 2, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeString(v633, v634, p28.earned_label)
	end

	if p28.updated_label ~= nil and p28.updated_label ~= "" then
		local v635, v636 = proto.writeTag(buf, n19, 3, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeString(v635, v636, p28.updated_label)
	end

	if p28.experience_label ~= nil and p28.experience_label ~= "" then
		local v637, v638 = proto.writeTag(buf, n19, 4, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeString(v637, v638, p28.experience_label)
	end

	if p28.rarity_label ~= nil and p28.rarity_label ~= "" then
		local v639, v640 = proto.writeTag(buf, n19, 5, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeString(v639, v640, p28.rarity_label)
	end

	if p28.won_yesterday_label ~= nil and p28.won_yesterday_label ~= "" then
		local v641, v642 = proto.writeTag(buf, n19, 6, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeString(v641, v642, p28.won_yesterday_label)
	end

	if p28.won_ever_label ~= nil and p28.won_ever_label ~= "" then
		local v643, v644 = proto.writeTag(buf, n19, 7, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeString(v643, v644, p28.won_ever_label)
	end

	local buf11 = buffer.create(n19)

	buffer.copy(buf11, 0, buf, 0, n19)

	return buf11
end
function t40.decode(p29: buffer) -- line: 6505
	-- upvalues: t40 (copy), proto (copy)
	local v647 = t40.new()
	local n20 = 0

	while n20 < buffer.len(p29) do
		local v649, v650

		v649, v650, n20 = proto.readTag(p29, n20)

		if v650 == proto.wireTypes.varint then
			local v651

			v651, n20 = proto.readVarInt(p29, n20)
		elseif v650 == proto.wireTypes.lengthDelimited then
			if v649 == 1 then
				local v652

				v652, n20 = proto.readBuffer(p29, n20)
				v647.type_label = buffer.tostring(v652)
			elseif v649 == 2 then
				local v653

				v653, n20 = proto.readBuffer(p29, n20)
				v647.earned_label = buffer.tostring(v653)
			elseif v649 == 3 then
				local v654

				v654, n20 = proto.readBuffer(p29, n20)
				v647.updated_label = buffer.tostring(v654)
			elseif v649 == 4 then
				local v655

				v655, n20 = proto.readBuffer(p29, n20)
				v647.experience_label = buffer.tostring(v655)
			elseif v649 == 5 then
				local v656

				v656, n20 = proto.readBuffer(p29, n20)
				v647.rarity_label = buffer.tostring(v656)
			elseif v649 == 6 then
				local v657

				v657, n20 = proto.readBuffer(p29, n20)
				v647.won_yesterday_label = buffer.tostring(v657)
			elseif v649 == 7 then
				local v658

				v658, n20 = proto.readBuffer(p29, n20)
				v647.won_ever_label = buffer.tostring(v658)
			else
				local v659, v660 = proto.readVarInt(p29, n20)

				n20 = v660 + v659
			end
		elseif v650 == proto.wireTypes.i32 then
			local v661

			v661, n20 = proto.readFixed32(p29, n20)
		elseif v650 == proto.wireTypes.i64 then
			local v662

			v662, n20 = proto.readFixed64(p29, n20)
		else
			error("Unsupported wire type: " .. v650)
		end
	end

	return v647
end
function t40.jsonEncode(p30) -- line: 6580
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
function t40.jsonDecode(t43: {[any]: any}) -- line: 6616
	-- upvalues: t40 (copy)
	local v666 = t40.new()

	if t43.type_label ~= nil then
		v666.type_label = t43.type_label
	end

	if t43.typeLabel ~= nil then
		v666.type_label = t43.typeLabel
	end

	if t43.earned_label ~= nil then
		v666.earned_label = t43.earned_label
	end

	if t43.earnedLabel ~= nil then
		v666.earned_label = t43.earnedLabel
	end

	if t43.updated_label ~= nil then
		v666.updated_label = t43.updated_label
	end

	if t43.updatedLabel ~= nil then
		v666.updated_label = t43.updatedLabel
	end

	if t43.experience_label ~= nil then
		v666.experience_label = t43.experience_label
	end

	if t43.experienceLabel ~= nil then
		v666.experience_label = t43.experienceLabel
	end

	if t43.rarity_label ~= nil then
		v666.rarity_label = t43.rarity_label
	end

	if t43.rarityLabel ~= nil then
		v666.rarity_label = t43.rarityLabel
	end

	if t43.won_yesterday_label ~= nil then
		v666.won_yesterday_label = t43.won_yesterday_label
	end

	if t43.wonYesterdayLabel ~= nil then
		v666.won_yesterday_label = t43.wonYesterdayLabel
	end

	if t43.won_ever_label ~= nil then
		v666.won_ever_label = t43.won_ever_label
	end

	if t43.wonEverLabel ~= nil then
		v666.won_ever_label = t43.wonEverLabel
	end

	return v666
end

t40.descriptor = {
	name = "BadgeDetailsInputData_LocalizedLiterals_InfoTable",
	fullName = "roblox.apppageplatform.shared.v1beta1.InfoTable"
}
t1.BadgeDetailsInputData_LocalizedLiterals_InfoTable = t40
typeRegistry.default:register(t1.BadgeDetailsInputData_LocalizedLiterals_InfoTable)

local t44 = {}

t44.__index = t44

function t44.new(t45: {[any]: any}?) -- line: 6696
	-- upvalues: t44 (copy)
	return (setmetatable({
		share = if t45 ~= nil and t45.share ~= nil then t45.share else "",
		report = if t45 ~= nil and t45.report ~= nil then t45.report else ""
	}, t44))
end
function t44.encode(p31) -- line: 6708
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n21 = 0

	if p31.share ~= nil and p31.share ~= "" then
		local v671, v672 = proto.writeTag(buf, n21, 1, proto.wireTypes.lengthDelimited)

		buf, n21 = proto.writeString(v671, v672, p31.share)
	end

	if p31.report ~= nil and p31.report ~= "" then
		local v673, v674 = proto.writeTag(buf, n21, 2, proto.wireTypes.lengthDelimited)

		buf, n21 = proto.writeString(v673, v674, p31.report)
	end

	local buf12 = buffer.create(n21)

	buffer.copy(buf12, 0, buf, 0, n21)

	return buf12
end
function t44.decode(p32: buffer) -- line: 6729
	-- upvalues: t44 (copy), proto (copy)
	local v677 = t44.new()
	local n22 = 0

	while n22 < buffer.len(p32) do
		local v679, v680

		v679, v680, n22 = proto.readTag(p32, n22)

		if v680 == proto.wireTypes.varint then
			local v681

			v681, n22 = proto.readVarInt(p32, n22)
		elseif v680 == proto.wireTypes.lengthDelimited then
			if v679 == 1 then
				local v682

				v682, n22 = proto.readBuffer(p32, n22)
				v677.share = buffer.tostring(v682)
			elseif v679 == 2 then
				local v683

				v683, n22 = proto.readBuffer(p32, n22)
				v677.report = buffer.tostring(v683)
			else
				local v684, v685 = proto.readVarInt(p32, n22)

				n22 = v685 + v684
			end
		elseif v680 == proto.wireTypes.i32 then
			local v686

			v686, n22 = proto.readFixed32(p32, n22)
		elseif v680 == proto.wireTypes.i64 then
			local v687

			v687, n22 = proto.readFixed64(p32, n22)
		else
			error("Unsupported wire type: " .. v680)
		end
	end

	return v677
end
function t44.jsonEncode(p33) -- line: 6779
	local t46 = {}

	if p33.share ~= nil and p33.share ~= "" then
		t46.share = p33.share
	end

	if p33.report ~= nil and p33.report ~= "" then
		t46.report = p33.report
	end

	return t46
end
function t44.jsonDecode(t47: {[any]: any}) -- line: 6795
	-- upvalues: t44 (copy)
	local v691 = t44.new()

	if t47.share ~= nil then
		v691.share = t47.share
	end

	if t47.report ~= nil then
		v691.report = t47.report
	end

	return v691
end

t44.descriptor = {
	name = "BadgeDetailsInputData_LocalizedLiterals_ActionModule",
	fullName = "roblox.apppageplatform.shared.v1beta1.ActionModule"
}
t1.BadgeDetailsInputData_LocalizedLiterals_ActionModule = t44
typeRegistry.default:register(t1.BadgeDetailsInputData_LocalizedLiterals_ActionModule)

local t48 = {}

t48.__index = t48

function t48.new(t49: {[any]: any}?) -- line: 6827
	-- upvalues: t48 (copy)
	return (setmetatable({
		report = if t49 ~= nil and t49.report ~= nil then t49.report else "",
		remove = if t49 ~= nil and t49.remove ~= nil then t49.remove else ""
	}, t48))
end
function t48.encode(p34) -- line: 6839
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n23 = 0

	if p34.report ~= nil and p34.report ~= "" then
		local v696, v697 = proto.writeTag(buf, n23, 1, proto.wireTypes.lengthDelimited)

		buf, n23 = proto.writeString(v696, v697, p34.report)
	end

	if p34.remove ~= nil and p34.remove ~= "" then
		local v698, v699 = proto.writeTag(buf, n23, 2, proto.wireTypes.lengthDelimited)

		buf, n23 = proto.writeString(v698, v699, p34.remove)
	end

	local buf13 = buffer.create(n23)

	buffer.copy(buf13, 0, buf, 0, n23)

	return buf13
end
function t48.decode(p35: buffer) -- line: 6860
	-- upvalues: t48 (copy), proto (copy)
	local v702 = t48.new()
	local n24 = 0

	while n24 < buffer.len(p35) do
		local v704, v705

		v704, v705, n24 = proto.readTag(p35, n24)

		if v705 == proto.wireTypes.varint then
			local v706

			v706, n24 = proto.readVarInt(p35, n24)
		elseif v705 == proto.wireTypes.lengthDelimited then
			if v704 == 1 then
				local v707

				v707, n24 = proto.readBuffer(p35, n24)
				v702.report = buffer.tostring(v707)
			elseif v704 == 2 then
				local v708

				v708, n24 = proto.readBuffer(p35, n24)
				v702.remove = buffer.tostring(v708)
			else
				local v709, v710 = proto.readVarInt(p35, n24)

				n24 = v710 + v709
			end
		elseif v705 == proto.wireTypes.i32 then
			local v711

			v711, n24 = proto.readFixed32(p35, n24)
		elseif v705 == proto.wireTypes.i64 then
			local v712

			v712, n24 = proto.readFixed64(p35, n24)
		else
			error("Unsupported wire type: " .. v705)
		end
	end

	return v702
end
function t48.jsonEncode(p36) -- line: 6910
	local t50 = {}

	if p36.report ~= nil and p36.report ~= "" then
		t50.report = p36.report
	end

	if p36.remove ~= nil and p36.remove ~= "" then
		t50.remove = p36.remove
	end

	return t50
end
function t48.jsonDecode(t51: {[any]: any}) -- line: 6926
	-- upvalues: t48 (copy)
	local v716 = t48.new()

	if t51.report ~= nil then
		v716.report = t51.report
	end

	if t51.remove ~= nil then
		v716.remove = t51.remove
	end

	return v716
end

t48.descriptor = {
	name = "BadgeDetailsInputData_LocalizedLiterals_OverflowMenu",
	fullName = "roblox.apppageplatform.shared.v1beta1.OverflowMenu"
}
t1.BadgeDetailsInputData_LocalizedLiterals_OverflowMenu = t48
typeRegistry.default:register(t1.BadgeDetailsInputData_LocalizedLiterals_OverflowMenu)

local t52 = {}

t52.__index = t52

function t52.new(_: {[any]: any}?) -- line: 6957
	-- upvalues: t52 (copy)
	return (setmetatable({}, t52))
end
function t52.encode(_) -- line: 6961
	local buf = buffer.create(0)
	local buf14 = buffer.create(0)

	buffer.copy(buf14, 0, buf, 0, 0)

	return buf14
end
function t52.decode(p38: buffer) -- line: 6970
	-- upvalues: t52 (copy), proto (copy)
	local v722 = t52.new()
	local n25 = 0

	while n25 < buffer.len(p38) do
		local v724, v725

		v724, v725, n25 = proto.readTag(p38, n25)

		if v725 == proto.wireTypes.varint then
			local v726

			v726, n25 = proto.readVarInt(p38, n25)
		elseif v725 == proto.wireTypes.lengthDelimited then
			local v727, v728 = proto.readVarInt(p38, n25)

			n25 = v728 + v727
		elseif v725 == proto.wireTypes.i32 then
			local v729

			v729, n25 = proto.readFixed32(p38, n25)
		elseif v725 == proto.wireTypes.i64 then
			local v730

			v730, n25 = proto.readFixed64(p38, n25)
		else
			error("Unsupported wire type: " .. v725)
		end
	end

	return v722
end
function t52.jsonEncode(_) -- line: 7008
	return {}
end
function t52.jsonDecode(_: {[any]: any}) -- line: 7014
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

function t55.new(t56: {[any]: any}?) -- line: 7034
	-- upvalues: t55 (copy)
	return (setmetatable({
		universe_id = if t56 ~= nil and t56.universe_id ~= nil then t56.universe_id else "",
		creator_key = if t56 ~= nil and t56.creator_key ~= nil then t56.creator_key else "",
		entry_map = if t56 ~= nil and t56.entry_map ~= nil then t56.entry_map else {},
		entry_order = if t56 ~= nil and t56.entry_order ~= nil then t56.entry_order else {},
		entry_order_map = if t56 ~= nil and t56.entry_order_map ~= nil then t56.entry_order_map else {}
	}, t55))
end
function t55.encode(p40) -- line: 7046
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n26 = 0

	if p40.universe_id ~= nil and p40.universe_id ~= "" then
		local v737, v738 = proto.writeTag(buf, n26, 1, proto.wireTypes.lengthDelimited)

		buf, n26 = proto.writeString(v737, v738, p40.universe_id)
	end

	if p40.creator_key ~= nil and p40.creator_key ~= "" then
		local v739, v740 = proto.writeTag(buf, n26, 2, proto.wireTypes.lengthDelimited)

		buf, n26 = proto.writeString(v739, v740, p40.creator_key)
	end

	if p40.entry_map ~= nil and next(p40.entry_map) ~= nil then
		for v741, v742 in p40.entry_map do
			local buf15 = buffer.create(0)
			local v744, v745 = proto.writeTag(buf15, 0, 1, proto.wireTypes.lengthDelimited)
			local v746, v747 = proto.writeString(v744, v745, v741)
			local v748 = v742:encode()
			local v749, v750 = proto.writeTag(v746, v747, 2, proto.wireTypes.lengthDelimited)
			local v751, v752 = proto.writeBuffer(v749, v750, v748, buffer.len(v748))
			local v753, v754 = proto.writeTag(buf, n26, 3, proto.wireTypes.lengthDelimited)

			buf, n26 = proto.writeBuffer(v753, v754, v751, v752)
		end
	end

	if p40.entry_order ~= nil and #p40.entry_order > 0 then
		for _, v756 in p40.entry_order do
			local v757, v758 = proto.writeTag(buf, n26, 4, proto.wireTypes.lengthDelimited)

			buf, n26 = proto.writeString(v757, v758, v756)
		end
	end

	if p40.entry_order_map ~= nil and next(p40.entry_order_map) ~= nil then
		for v759, v760 in p40.entry_order_map do
			local buf16 = buffer.create(0)
			local v762, v763 = proto.writeTag(buf16, 0, 1, proto.wireTypes.lengthDelimited)
			local v764, v765 = proto.writeString(v762, v763, v759)
			local v766 = v760:encode()
			local v767, v768 = proto.writeTag(v764, v765, 2, proto.wireTypes.lengthDelimited)
			local v769, v770 = proto.writeBuffer(v767, v768, v766, buffer.len(v766))
			local v771, v772 = proto.writeTag(buf, n26, 5, proto.wireTypes.lengthDelimited)

			buf, n26 = proto.writeBuffer(v771, v772, v769, v770)
		end
	end

	local buf17 = buffer.create(n26)

	buffer.copy(buf17, 0, buf, 0, n26)

	return buf17
end
function t55.decode(p41: buffer) -- line: 7100
	-- upvalues: t55 (copy), proto (copy), t1 (copy)
	local v775 = t55.new()
	local n27 = 0

	while n27 < buffer.len(p41) do
		local v777, v778

		v777, v778, n27 = proto.readTag(p41, n27)

		if v778 == proto.wireTypes.varint then
			local v779

			v779, n27 = proto.readVarInt(p41, n27)
		elseif v778 == proto.wireTypes.lengthDelimited then
			if v777 == 1 then
				local v780

				v780, n27 = proto.readBuffer(p41, n27)
				v775.universe_id = buffer.tostring(v780)
			elseif v777 == 2 then
				local v781

				v781, n27 = proto.readBuffer(p41, n27)
				v775.creator_key = buffer.tostring(v781)
			elseif v777 == 3 then
				local v782

				v782, n27 = proto.readBuffer(p41, n27)

				local v783 = t1.ExperienceDetailsFeedInputData_EntryMapEntry.decode(v782)
				local v784 = t1.FeedEntry.new()

				v775.entry_map[v783.key or ""] = v783.value or v784
			elseif v777 == 4 then
				local v785

				v785, n27 = proto.readBuffer(p41, n27)
				table.insert(v775.entry_order, buffer.tostring(v785))
			elseif v777 == 5 then
				local v786

				v786, n27 = proto.readBuffer(p41, n27)

				local v787 = t1.ExperienceDetailsFeedInputData_EntryOrderMapEntry.decode(v786)
				local v788 = t1.EntryOrder.new()

				v775.entry_order_map[v787.key or ""] = v787.value or v788
			else
				local v789, v790 = proto.readVarInt(p41, n27)

				n27 = v790 + v789
			end
		elseif v778 == proto.wireTypes.i32 then
			local v791

			v791, n27 = proto.readFixed32(p41, n27)
		elseif v778 == proto.wireTypes.i64 then
			local v792

			v792, n27 = proto.readFixed64(p41, n27)
		else
			error("Unsupported wire type: " .. v778)
		end
	end

	return v775
end
function t55.jsonEncode(p42) -- line: 7177
	local t57 = {}

	if p42.universe_id ~= nil and p42.universe_id ~= "" then
		t57.universeId = p42.universe_id
	end

	if p42.creator_key ~= nil and p42.creator_key ~= "" then
		t57.creatorKey = p42.creator_key
	end

	if p42.entry_map ~= nil and next(p42.entry_map) ~= nil then
		local t58 = {}

		for v796, v797 in p42.entry_map do
			t58[v796] = v797:jsonEncode()
		end

		t57.entryMap = t58
	end

	if p42.entry_order ~= nil and #p42.entry_order > 0 then
		local t59 = {}

		for _, v800 in p42.entry_order do
			table.insert(t59, v800)
		end

		t57.entryOrder = t59
	end

	if p42.entry_order_map ~= nil and next(p42.entry_order_map) ~= nil then
		local t60 = {}

		for v802, v803 in p42.entry_order_map do
			t60[v802] = v803:jsonEncode()
		end

		t57.entryOrderMap = t60
	end

	return t57
end
function t55.jsonDecode(t61: {[any]: any}) -- line: 7215
	-- upvalues: t55 (copy), t1 (copy)
	local v805 = t55.new()

	if t61.universe_id ~= nil then
		v805.universe_id = t61.universe_id
	end

	if t61.universeId ~= nil then
		v805.universe_id = t61.universeId
	end

	if t61.creator_key ~= nil then
		v805.creator_key = t61.creator_key
	end

	if t61.creatorKey ~= nil then
		v805.creator_key = t61.creatorKey
	end

	if t61.entry_map ~= nil then
		local t62 = {}

		for v807, v808 in t61.entry_map do
			t62[v807] = t1.FeedEntry.jsonDecode(v808)
		end

		v805.entry_map = t62
	end

	if t61.entryMap ~= nil then
		local t63 = {}

		for v810, v811 in t61.entryMap do
			t63[v810] = t1.FeedEntry.jsonDecode(v811)
		end

		v805.entry_map = t63
	end

	if t61.entry_order ~= nil then
		local t64 = {}

		for _, v814 in t61.entry_order do
			table.insert(t64, v814)
		end

		v805.entry_order = t64
	end

	if t61.entryOrder ~= nil then
		local t65 = {}

		for _, v817 in t61.entryOrder do
			table.insert(t65, v817)
		end

		v805.entry_order = t65
	end

	if t61.entry_order_map ~= nil then
		local t66 = {}

		for v819, v820 in t61.entry_order_map do
			t66[v819] = t1.EntryOrder.jsonDecode(v820)
		end

		v805.entry_order_map = t66
	end

	if t61.entryOrderMap ~= nil then
		local t67 = {}

		for v822, v823 in t61.entryOrderMap do
			t67[v822] = t1.EntryOrder.jsonDecode(v823)
		end

		v805.entry_order_map = t67
	end

	return v805
end

t55.descriptor = {
	name = "ExperienceDetailsFeedInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceDetailsFeedInputData"
}
t1.ExperienceDetailsFeedInputData = t55
typeRegistry.default:register(t1.ExperienceDetailsFeedInputData)

local t68 = {}

t68.__index = t68

function t68.new(t69: {[any]: any}?) -- line: 7305
	-- upvalues: t68 (copy)
	return (setmetatable({
		key = if t69 ~= nil and t69.key ~= nil then t69.key else "",
		value = if t69 ~= nil and t69.value ~= nil then t69.value else nil
	}, t68))
end
function t68.encode(p43) -- line: 7314
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n28 = 0

	if p43.key ~= nil and p43.key ~= "" then
		local v828, v829 = proto.writeTag(buf, n28, 1, proto.wireTypes.lengthDelimited)

		buf, n28 = proto.writeString(v828, v829, p43.key)
	end

	if p43.value ~= nil then
		local v830 = p43.value:encode()
		local v831, v832 = proto.writeTag(buf, n28, 2, proto.wireTypes.lengthDelimited)

		buf, n28 = proto.writeBuffer(v831, v832, v830, buffer.len(v830))
	end

	local buf18 = buffer.create(n28)

	buffer.copy(buf18, 0, buf, 0, n28)

	return buf18
end
function t68.decode(p44: buffer) -- line: 7336
	-- upvalues: t68 (copy), proto (copy), t1 (copy)
	local v835 = t68.new()
	local n29 = 0

	while n29 < buffer.len(p44) do
		local v837, v838

		v837, v838, n29 = proto.readTag(p44, n29)

		if v838 == proto.wireTypes.varint then
			local v839

			v839, n29 = proto.readVarInt(p44, n29)
		elseif v838 == proto.wireTypes.lengthDelimited then
			if v837 == 1 then
				local v840

				v840, n29 = proto.readBuffer(p44, n29)
				v835.key = buffer.tostring(v840)
			elseif v837 == 2 then
				local v841

				v841, n29 = proto.readBuffer(p44, n29)
				v835.value = t1.FeedEntry.decode(v841)
			else
				local v842, v843 = proto.readVarInt(p44, n29)

				n29 = v843 + v842
			end
		elseif v838 == proto.wireTypes.i32 then
			local v844

			v844, n29 = proto.readFixed32(p44, n29)
		elseif v838 == proto.wireTypes.i64 then
			local v845

			v845, n29 = proto.readFixed64(p44, n29)
		else
			error("Unsupported wire type: " .. v838)
		end
	end

	return v835
end
function t68.jsonEncode(p45) -- line: 7386
	local t70 = {}

	if p45.key ~= nil and p45.key ~= "" then
		t70.key = p45.key
	end

	if p45.value ~= nil then
		t70.value = p45.value:jsonEncode()
	end

	return t70
end
function t68.jsonDecode(t71: {[any]: any}) -- line: 7402
	-- upvalues: t68 (copy), t1 (copy)
	local v849 = t68.new()

	if t71.key ~= nil then
		v849.key = t71.key
	end

	if t71.value ~= nil then
		v849.value = t1.FeedEntry.jsonDecode(t71.value)
	end

	return v849
end

t68.descriptor = {
	name = "ExperienceDetailsFeedInputData_EntryMapEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryMapEntry"
}
t1.ExperienceDetailsFeedInputData_EntryMapEntry = t68
typeRegistry.default:register(t1.ExperienceDetailsFeedInputData_EntryMapEntry)

local t72 = {}

t72.__index = t72

function t72.new(t73: {[any]: any}?) -- line: 7433
	-- upvalues: t72 (copy)
	return (setmetatable({
		key = if t73 ~= nil and t73.key ~= nil then t73.key else "",
		value = if t73 ~= nil and t73.value ~= nil then t73.value else nil
	}, t72))
end
function t72.encode(p46) -- line: 7445
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n30 = 0

	if p46.key ~= nil and p46.key ~= "" then
		local v854, v855 = proto.writeTag(buf, n30, 1, proto.wireTypes.lengthDelimited)

		buf, n30 = proto.writeString(v854, v855, p46.key)
	end

	if p46.value ~= nil then
		local v856 = p46.value:encode()
		local v857, v858 = proto.writeTag(buf, n30, 2, proto.wireTypes.lengthDelimited)

		buf, n30 = proto.writeBuffer(v857, v858, v856, buffer.len(v856))
	end

	local buf19 = buffer.create(n30)

	buffer.copy(buf19, 0, buf, 0, n30)

	return buf19
end
function t72.decode(p47: buffer) -- line: 7467
	-- upvalues: t72 (copy), proto (copy), t1 (copy)
	local v861 = t72.new()
	local n31 = 0

	while n31 < buffer.len(p47) do
		local v863, v864

		v863, v864, n31 = proto.readTag(p47, n31)

		if v864 == proto.wireTypes.varint then
			local v865

			v865, n31 = proto.readVarInt(p47, n31)
		elseif v864 == proto.wireTypes.lengthDelimited then
			if v863 == 1 then
				local v866

				v866, n31 = proto.readBuffer(p47, n31)
				v861.key = buffer.tostring(v866)
			elseif v863 == 2 then
				local v867

				v867, n31 = proto.readBuffer(p47, n31)
				v861.value = t1.EntryOrder.decode(v867)
			else
				local v868, v869 = proto.readVarInt(p47, n31)

				n31 = v869 + v868
			end
		elseif v864 == proto.wireTypes.i32 then
			local v870

			v870, n31 = proto.readFixed32(p47, n31)
		elseif v864 == proto.wireTypes.i64 then
			local v871

			v871, n31 = proto.readFixed64(p47, n31)
		else
			error("Unsupported wire type: " .. v864)
		end
	end

	return v861
end
function t72.jsonEncode(p48) -- line: 7517
	local t74 = {}

	if p48.key ~= nil and p48.key ~= "" then
		t74.key = p48.key
	end

	if p48.value ~= nil then
		t74.value = p48.value:jsonEncode()
	end

	return t74
end
function t72.jsonDecode(t75: {[any]: any}) -- line: 7533
	-- upvalues: t72 (copy), t1 (copy)
	local v875 = t72.new()

	if t75.key ~= nil then
		v875.key = t75.key
	end

	if t75.value ~= nil then
		v875.value = t1.EntryOrder.jsonDecode(t75.value)
	end

	return v875
end

t72.descriptor = {
	name = "ExperienceDetailsFeedInputData_EntryOrderMapEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryOrderMapEntry"
}
t1.ExperienceDetailsFeedInputData_EntryOrderMapEntry = t72
typeRegistry.default:register(t1.ExperienceDetailsFeedInputData_EntryOrderMapEntry)

local t76 = {}

t76.__index = t76

function t76.new(t77: {[any]: any}?) -- line: 7564
	-- upvalues: t76 (copy)
	return (setmetatable({
		items = if t77 ~= nil and t77.items ~= nil then t77.items else {}
	}, t76))
end
function t76.encode(p49) -- line: 7570
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n32 = 0

	if p49.items ~= nil and #p49.items > 0 then
		for _, v881 in p49.items do
			local v882, v883 = proto.writeTag(buf, n32, 1, proto.wireTypes.lengthDelimited)

			buf, n32 = proto.writeString(v882, v883, v881)
		end
	end

	local buf20 = buffer.create(n32)

	buffer.copy(buf20, 0, buf, 0, n32)

	return buf20
end
function t76.decode(p50: buffer) -- line: 7586
	-- upvalues: t76 (copy), proto (copy)
	local v886 = t76.new()
	local n33 = 0

	while n33 < buffer.len(p50) do
		local v888, v889

		v888, v889, n33 = proto.readTag(p50, n33)

		if v889 == proto.wireTypes.varint then
			local v890

			v890, n33 = proto.readVarInt(p50, n33)
		elseif v889 == proto.wireTypes.lengthDelimited then
			if v888 == 1 then
				local v891

				v891, n33 = proto.readBuffer(p50, n33)
				table.insert(v886.items, buffer.tostring(v891))
			else
				local v892, v893 = proto.readVarInt(p50, n33)

				n33 = v893 + v892
			end
		elseif v889 == proto.wireTypes.i32 then
			local v894

			v894, n33 = proto.readFixed32(p50, n33)
		elseif v889 == proto.wireTypes.i64 then
			local v895

			v895, n33 = proto.readFixed64(p50, n33)
		else
			error("Unsupported wire type: " .. v889)
		end
	end

	return v886
end
function t76.jsonEncode(p51) -- line: 7629
	local t78 = {}

	if p51.items ~= nil and #p51.items > 0 then
		local t79 = {}

		for _, v900 in p51.items do
			table.insert(t79, v900)
		end

		t78.items = t79
	end

	return t78
end
function t76.jsonDecode(t80: {[any]: any}) -- line: 7643
	-- upvalues: t76 (copy)
	local v902 = t76.new()

	if t80.items ~= nil then
		local t81 = {}

		for _, v905 in t80.items do
			table.insert(t81, v905)
		end

		v902.items = t81
	end

	return v902
end

t76.descriptor = {
	name = "EntryOrder",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryOrder"
}
t1.EntryOrder = t76
typeRegistry.default:register(t1.EntryOrder)

local t82 = {}

t82.__index = t82

function t82.new(t83: {[any]: any}?) -- line: 7672
	-- upvalues: t82 (copy)
	return (setmetatable({
		universe_id = if t83 ~= nil and t83.universe_id ~= nil then t83.universe_id else "",
		user_owns_experience = t83 ~= nil and (t83.user_owns_experience ~= nil and t83.user_owns_experience)
	}, t82))
end
function t82.encode(p52) -- line: 7683
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n34 = 0

	if p52.universe_id ~= nil and p52.universe_id ~= "" then
		local v910, v911 = proto.writeTag(buf, n34, 1, proto.wireTypes.lengthDelimited)

		buf, n34 = proto.writeString(v910, v911, p52.universe_id)
	end

	if p52.user_owns_experience then
		local v912, v913 = proto.writeTag(buf, n34, 2, proto.wireTypes.varint)

		buf, n34 = proto.writeVarInt(v912, v913, not p52.user_owns_experience and 0 or 1)
	end

	local buf21 = buffer.create(n34)

	buffer.copy(buf21, 0, buf, 0, n34)

	return buf21
end
function t82.decode(p53: buffer) -- line: 7702
	-- upvalues: t82 (copy), proto (copy)
	local v916 = t82.new()
	local n35 = 0

	while n35 < buffer.len(p53) do
		local v918, v919

		v918, v919, n35 = proto.readTag(p53, n35)

		if v919 == proto.wireTypes.varint then
			if v918 == 2 then
				local v920

				v920, n35 = proto.readVarInt(p53, n35)
				v916.user_owns_experience = v920 ~= 0
			else
				local v921

				v921, n35 = proto.readVarInt(p53, n35)
			end
		elseif v919 == proto.wireTypes.lengthDelimited then
			if v918 == 1 then
				local v922

				v922, n35 = proto.readBuffer(p53, n35)
				v916.universe_id = buffer.tostring(v922)
			else
				local v923, v924 = proto.readVarInt(p53, n35)

				n35 = v924 + v923
			end
		elseif v919 == proto.wireTypes.i32 then
			local v925

			v925, n35 = proto.readFixed32(p53, n35)
		elseif v919 == proto.wireTypes.i64 then
			local v926

			v926, n35 = proto.readFixed64(p53, n35)
		else
			error("Unsupported wire type: " .. v919)
		end
	end

	return v916
end
function t82.jsonEncode(p54) -- line: 7750
	local t84 = {}

	if p54.universe_id ~= nil and p54.universe_id ~= "" then
		t84.universeId = p54.universe_id
	end

	if p54.user_owns_experience then
		t84.userOwnsExperience = p54.user_owns_experience
	end

	return t84
end
function t82.jsonDecode(t85: {[any]: any}) -- line: 7764
	-- upvalues: t82 (copy)
	local v930 = t82.new()

	if t85.universe_id ~= nil then
		v930.universe_id = t85.universe_id
	end

	if t85.universeId ~= nil then
		v930.universe_id = t85.universeId
	end

	if t85.user_owns_experience ~= nil then
		v930.user_owns_experience = t85.user_owns_experience
	end

	if t85.userOwnsExperience ~= nil then
		v930.user_owns_experience = t85.userOwnsExperience
	end

	return v930
end

t82.descriptor = {
	name = "ExperienceDetailsActionBarInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceDetailsActionBarInputData"
}
t1.ExperienceDetailsActionBarInputData = t82
typeRegistry.default:register(t1.ExperienceDetailsActionBarInputData)

local t86 = {}

t86.__index = t86

function t86.new(t87: {[any]: any}?) -- line: 7802
	-- upvalues: t86 (copy)
	return (setmetatable({
		media_asset_id = if t87 ~= nil and t87.media_asset_id ~= nil then t87.media_asset_id else ""
	}, t86))
end
function t86.encode(p55) -- line: 7810
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n36 = 0

	if p55.media_asset_id ~= nil and p55.media_asset_id ~= "" then
		local v935, v936 = proto.writeTag(buf, n36, 1, proto.wireTypes.lengthDelimited)

		buf, n36 = proto.writeString(v935, v936, p55.media_asset_id)
	end

	local buf22 = buffer.create(n36)

	buffer.copy(buf22, 0, buf, 0, n36)

	return buf22
end
function t86.decode(p56: buffer) -- line: 7824
	-- upvalues: t86 (copy), proto (copy)
	local v939 = t86.new()
	local n37 = 0

	while n37 < buffer.len(p56) do
		local v941, v942

		v941, v942, n37 = proto.readTag(p56, n37)

		if v942 == proto.wireTypes.varint then
			local v943

			v943, n37 = proto.readVarInt(p56, n37)
		elseif v942 == proto.wireTypes.lengthDelimited then
			if v941 == 1 then
				local v944

				v944, n37 = proto.readBuffer(p56, n37)
				v939.media_asset_id = buffer.tostring(v944)
			else
				local v945, v946 = proto.readVarInt(p56, n37)

				n37 = v946 + v945
			end
		elseif v942 == proto.wireTypes.i32 then
			local v947

			v947, n37 = proto.readFixed32(p56, n37)
		elseif v942 == proto.wireTypes.i64 then
			local v948

			v948, n37 = proto.readFixed64(p56, n37)
		else
			error("Unsupported wire type: " .. v942)
		end
	end

	return v939
end
function t86.jsonEncode(p57) -- line: 7867
	local t88 = {}

	if p57.media_asset_id ~= nil and p57.media_asset_id ~= "" then
		t88.mediaAssetId = p57.media_asset_id
	end

	return t88
end
function t86.jsonDecode(t89: {[any]: any}) -- line: 7877
	-- upvalues: t86 (copy)
	local v952 = t86.new()

	if t89.media_asset_id ~= nil then
		v952.media_asset_id = t89.media_asset_id
	end

	if t89.mediaAssetId ~= nil then
		v952.media_asset_id = t89.mediaAssetId
	end

	return v952
end

t86.descriptor = {
	name = "ExperienceDetailsBannerImageInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceDetailsBannerImageInputData"
}
t1.ExperienceDetailsBannerImageInputData = t86
typeRegistry.default:register(t1.ExperienceDetailsBannerImageInputData)

local t90 = {}

t90.__index = t90

function t90.new(t91: {[any]: any}?) -- line: 7907
	-- upvalues: t90 (copy)
	return (setmetatable({
		universe_id = if t91 ~= nil and t91.universe_id ~= nil then t91.universe_id else ""
	}, t90))
end
function t90.encode(p58) -- line: 7915
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n38 = 0

	if p58.universe_id ~= nil and p58.universe_id ~= "" then
		local v957, v958 = proto.writeTag(buf, n38, 1, proto.wireTypes.lengthDelimited)

		buf, n38 = proto.writeString(v957, v958, p58.universe_id)
	end

	local buf23 = buffer.create(n38)

	buffer.copy(buf23, 0, buf, 0, n38)

	return buf23
end
function t90.decode(p59: buffer) -- line: 7929
	-- upvalues: t90 (copy), proto (copy)
	local v961 = t90.new()
	local n39 = 0

	while n39 < buffer.len(p59) do
		local v963, v964

		v963, v964, n39 = proto.readTag(p59, n39)

		if v964 == proto.wireTypes.varint then
			local v965

			v965, n39 = proto.readVarInt(p59, n39)
		elseif v964 == proto.wireTypes.lengthDelimited then
			if v963 == 1 then
				local v966

				v966, n39 = proto.readBuffer(p59, n39)
				v961.universe_id = buffer.tostring(v966)
			else
				local v967, v968 = proto.readVarInt(p59, n39)

				n39 = v968 + v967
			end
		elseif v964 == proto.wireTypes.i32 then
			local v969

			v969, n39 = proto.readFixed32(p59, n39)
		elseif v964 == proto.wireTypes.i64 then
			local v970

			v970, n39 = proto.readFixed64(p59, n39)
		else
			error("Unsupported wire type: " .. v964)
		end
	end

	return v961
end
function t90.jsonEncode(p60) -- line: 7972
	local t92 = {}

	if p60.universe_id ~= nil and p60.universe_id ~= "" then
		t92.universeId = p60.universe_id
	end

	return t92
end
function t90.jsonDecode(t93: {[any]: any}) -- line: 7982
	-- upvalues: t90 (copy)
	local v974 = t90.new()

	if t93.universe_id ~= nil then
		v974.universe_id = t93.universe_id
	end

	if t93.universeId ~= nil then
		v974.universe_id = t93.universeId
	end

	return v974
end

t90.descriptor = {
	name = "ExperienceDetailsStickyHeaderInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceDetailsStickyHeaderInputData"
}
t1.ExperienceDetailsStickyHeaderInputData = t90
typeRegistry.default:register(t1.ExperienceDetailsStickyHeaderInputData)

local t94 = {}

t94.__index = t94

function t94.new(t95: {[any]: any}?) -- line: 8012
	-- upvalues: t94 (copy)
	return (setmetatable({
		universe_id = if t95 ~= nil and t95.universe_id ~= nil then t95.universe_id else "",
		creator_key = if t95 ~= nil and t95.creator_key ~= nil then t95.creator_key else ""
	}, t94))
end
function t94.encode(p61) -- line: 8021
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n40 = 0

	if p61.universe_id ~= nil and p61.universe_id ~= "" then
		local v979, v980 = proto.writeTag(buf, n40, 1, proto.wireTypes.lengthDelimited)

		buf, n40 = proto.writeString(v979, v980, p61.universe_id)
	end

	if p61.creator_key ~= nil and p61.creator_key ~= "" then
		local v981, v982 = proto.writeTag(buf, n40, 2, proto.wireTypes.lengthDelimited)

		buf, n40 = proto.writeString(v981, v982, p61.creator_key)
	end

	local buf24 = buffer.create(n40)

	buffer.copy(buf24, 0, buf, 0, n40)

	return buf24
end
function t94.decode(p62: buffer) -- line: 8040
	-- upvalues: t94 (copy), proto (copy)
	local v985 = t94.new()
	local n41 = 0

	while n41 < buffer.len(p62) do
		local v987, v988

		v987, v988, n41 = proto.readTag(p62, n41)

		if v988 == proto.wireTypes.varint then
			local v989

			v989, n41 = proto.readVarInt(p62, n41)
		elseif v988 == proto.wireTypes.lengthDelimited then
			if v987 == 1 then
				local v990

				v990, n41 = proto.readBuffer(p62, n41)
				v985.universe_id = buffer.tostring(v990)
			elseif v987 == 2 then
				local v991

				v991, n41 = proto.readBuffer(p62, n41)
				v985.creator_key = buffer.tostring(v991)
			else
				local v992, v993 = proto.readVarInt(p62, n41)

				n41 = v993 + v992
			end
		elseif v988 == proto.wireTypes.i32 then
			local v994

			v994, n41 = proto.readFixed32(p62, n41)
		elseif v988 == proto.wireTypes.i64 then
			local v995

			v995, n41 = proto.readFixed64(p62, n41)
		else
			error("Unsupported wire type: " .. v988)
		end
	end

	return v985
end
function t94.jsonEncode(p63) -- line: 8088
	local t96 = {}

	if p63.universe_id ~= nil and p63.universe_id ~= "" then
		t96.universeId = p63.universe_id
	end

	if p63.creator_key ~= nil and p63.creator_key ~= "" then
		t96.creatorKey = p63.creator_key
	end

	return t96
end
function t94.jsonDecode(t97: {[any]: any}) -- line: 8102
	-- upvalues: t94 (copy)
	local v999 = t94.new()

	if t97.universe_id ~= nil then
		v999.universe_id = t97.universe_id
	end

	if t97.universeId ~= nil then
		v999.universe_id = t97.universeId
	end

	if t97.creator_key ~= nil then
		v999.creator_key = t97.creator_key
	end

	if t97.creatorKey ~= nil then
		v999.creator_key = t97.creatorKey
	end

	return v999
end

t94.descriptor = {
	name = "ExperienceAttributionRowInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceAttributionRowInputData"
}
t1.ExperienceAttributionRowInputData = t94
typeRegistry.default:register(t1.ExperienceAttributionRowInputData)

local t98 = {}

t98.__index = t98

function t98.new(t99: {[any]: any}?) -- line: 8140
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
function t98.encode(p64) -- line: 8162
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n42 = 0

	if p64.universe_id ~= nil and p64.universe_id ~= "" then
		local v1004, v1005 = proto.writeTag(buf, n42, 1, proto.wireTypes.lengthDelimited)

		buf, n42 = proto.writeString(v1004, v1005, p64.universe_id)
	end

	if p64.root_place_id ~= nil and p64.root_place_id ~= "" then
		local v1006, v1007 = proto.writeTag(buf, n42, 2, proto.wireTypes.lengthDelimited)

		buf, n42 = proto.writeString(v1006, v1007, p64.root_place_id)
	end

	if p64.connection_played_display_name ~= nil and p64.connection_played_display_name ~= "" then
		local v1008, v1009 = proto.writeTag(buf, n42, 3, proto.wireTypes.lengthDelimited)

		buf, n42 = proto.writeString(v1008, v1009, p64.connection_played_display_name)
	end

	if p64.upsell_prompt ~= nil and p64.upsell_prompt ~= "" then
		local v1010, v1011 = proto.writeTag(buf, n42, 4, proto.wireTypes.lengthDelimited)

		buf, n42 = proto.writeString(v1010, v1011, p64.upsell_prompt)
	end

	if p64.connection_played_users ~= nil and #p64.connection_played_users > 0 then
		for _, v1013 in p64.connection_played_users do
			local v1014 = v1013:encode()
			local v1015, v1016 = proto.writeTag(buf, n42, 5, proto.wireTypes.lengthDelimited)

			buf, n42 = proto.writeBuffer(v1015, v1016, v1014, buffer.len(v1014))
		end
	end

	if p64.connection_played_num_others ~= nil and p64.connection_played_num_others ~= 0 then
		local v1017, v1018 = proto.writeTag(buf, n42, 6, proto.wireTypes.varint)

		buf, n42 = proto.writeVarInt(v1017, v1018, p64.connection_played_num_others)
	end

	if p64.connection_played_total_count ~= nil and p64.connection_played_total_count ~= 0 then
		local v1019, v1020 = proto.writeTag(buf, n42, 7, proto.wireTypes.varint)

		buf, n42 = proto.writeVarInt(v1019, v1020, p64.connection_played_total_count)
	end

	local buf25 = buffer.create(n42)

	buffer.copy(buf25, 0, buf, 0, n42)

	return buf25
end
function t98.decode(p65: buffer) -- line: 8209
	-- upvalues: t98 (copy), proto (copy), t1 (copy)
	local v1023 = t98.new()
	local n43 = 0

	while n43 < buffer.len(p65) do
		local v1025, v1026

		v1025, v1026, n43 = proto.readTag(p65, n43)

		if v1026 == proto.wireTypes.varint then
			if v1025 == 6 then
				local v1027

				v1027, n43 = proto.readVarIntI32(p65, n43)
				v1023.connection_played_num_others = v1027
			elseif v1025 == 7 then
				local v1028

				v1028, n43 = proto.readVarIntI32(p65, n43)
				v1023.connection_played_total_count = v1028
			else
				local v1029

				v1029, n43 = proto.readVarInt(p65, n43)
			end
		elseif v1026 == proto.wireTypes.lengthDelimited then
			if v1025 == 1 then
				local v1030

				v1030, n43 = proto.readBuffer(p65, n43)
				v1023.universe_id = buffer.tostring(v1030)
			elseif v1025 == 2 then
				local v1031

				v1031, n43 = proto.readBuffer(p65, n43)
				v1023.root_place_id = buffer.tostring(v1031)
			elseif v1025 == 3 then
				local v1032

				v1032, n43 = proto.readBuffer(p65, n43)
				v1023.connection_played_display_name = buffer.tostring(v1032)
			elseif v1025 == 4 then
				local v1033

				v1033, n43 = proto.readBuffer(p65, n43)
				v1023.upsell_prompt = buffer.tostring(v1033)
			elseif v1025 == 5 then
				local v1034

				v1034, n43 = proto.readBuffer(p65, n43)
				table.insert(v1023.connection_played_users, t1.ExperienceActionModuleInputData_ConnectionPlayedUser.decode(v1034))
			else
				local v1035, v1036 = proto.readVarInt(p65, n43)

				n43 = v1036 + v1035
			end
		elseif v1026 == proto.wireTypes.i32 then
			local v1037

			v1037, n43 = proto.readFixed32(p65, n43)
		elseif v1026 == proto.wireTypes.i64 then
			local v1038

			v1038, n43 = proto.readFixed64(p65, n43)
		else
			error("Unsupported wire type: " .. v1026)
		end
	end

	return v1023
end
function t98.jsonEncode(p66) -- line: 8285
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

		for _, v1043 in p66.connection_played_users do
			table.insert(t101, v1043:jsonEncode())
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
function t98.jsonDecode(t102: {[any]: any}) -- line: 8323
	-- upvalues: t98 (copy), t1 (copy)
	local v1045 = t98.new()

	if t102.universe_id ~= nil then
		v1045.universe_id = t102.universe_id
	end

	if t102.universeId ~= nil then
		v1045.universe_id = t102.universeId
	end

	if t102.root_place_id ~= nil then
		v1045.root_place_id = t102.root_place_id
	end

	if t102.rootPlaceId ~= nil then
		v1045.root_place_id = t102.rootPlaceId
	end

	if t102.connection_played_display_name ~= nil then
		v1045.connection_played_display_name = t102.connection_played_display_name
	end

	if t102.connectionPlayedDisplayName ~= nil then
		v1045.connection_played_display_name = t102.connectionPlayedDisplayName
	end

	if t102.upsell_prompt ~= nil then
		v1045.upsell_prompt = t102.upsell_prompt
	end

	if t102.upsellPrompt ~= nil then
		v1045.upsell_prompt = t102.upsellPrompt
	end

	if t102.connection_played_users ~= nil then
		local t103 = {}

		for _, v1048 in t102.connection_played_users do
			table.insert(t103, t1.ExperienceActionModuleInputData_ConnectionPlayedUser.jsonDecode(v1048))
		end

		v1045.connection_played_users = t103
	end

	if t102.connectionPlayedUsers ~= nil then
		local t104 = {}

		for _, v1051 in t102.connectionPlayedUsers do
			table.insert(t104, t1.ExperienceActionModuleInputData_ConnectionPlayedUser.jsonDecode(v1051))
		end

		v1045.connection_played_users = t104
	end

	if t102.connection_played_num_others ~= nil then
		v1045.connection_played_num_others = t102.connection_played_num_others
	end

	if t102.connectionPlayedNumOthers ~= nil then
		v1045.connection_played_num_others = t102.connectionPlayedNumOthers
	end

	if t102.connection_played_total_count ~= nil then
		v1045.connection_played_total_count = t102.connection_played_total_count
	end

	if t102.connectionPlayedTotalCount ~= nil then
		v1045.connection_played_total_count = t102.connectionPlayedTotalCount
	end

	return v1045
end

t98.descriptor = {
	name = "ExperienceActionModuleInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceActionModuleInputData"
}
t1.ExperienceActionModuleInputData = t98
typeRegistry.default:register(t1.ExperienceActionModuleInputData)

local t105 = {}

t105.__index = t105

function t105.new(t106: {[any]: any}?) -- line: 8410
	-- upvalues: t105 (copy)
	return (setmetatable({
		user_id = if t106 ~= nil and t106.user_id ~= nil then t106.user_id else ""
	}, t105))
end
function t105.encode(p67) -- line: 8421
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n44 = 0

	if p67.user_id ~= nil and p67.user_id ~= "" then
		local v1056, v1057 = proto.writeTag(buf, n44, 1, proto.wireTypes.lengthDelimited)

		buf, n44 = proto.writeString(v1056, v1057, p67.user_id)
	end

	local buf26 = buffer.create(n44)

	buffer.copy(buf26, 0, buf, 0, n44)

	return buf26
end
function t105.decode(p68: buffer) -- line: 8437
	-- upvalues: t105 (copy), proto (copy)
	local v1060 = t105.new()
	local n45 = 0

	while n45 < buffer.len(p68) do
		local v1062, v1063

		v1062, v1063, n45 = proto.readTag(p68, n45)

		if v1063 == proto.wireTypes.varint then
			local v1064

			v1064, n45 = proto.readVarInt(p68, n45)
		elseif v1063 == proto.wireTypes.lengthDelimited then
			if v1062 == 1 then
				local v1065

				v1065, n45 = proto.readBuffer(p68, n45)
				v1060.user_id = buffer.tostring(v1065)
			else
				local v1066, v1067 = proto.readVarInt(p68, n45)

				n45 = v1067 + v1066
			end
		elseif v1063 == proto.wireTypes.i32 then
			local v1068

			v1068, n45 = proto.readFixed32(p68, n45)
		elseif v1063 == proto.wireTypes.i64 then
			local v1069

			v1069, n45 = proto.readFixed64(p68, n45)
		else
			error("Unsupported wire type: " .. v1063)
		end
	end

	return v1060
end
function t105.jsonEncode(p69) -- line: 8482
	local t107 = {}

	if p69.user_id ~= nil and p69.user_id ~= "" then
		t107.userId = p69.user_id
	end

	return t107
end
function t105.jsonDecode(t108: {[any]: any}) -- line: 8494
	-- upvalues: t105 (copy)
	local v1073 = t105.new()

	if t108.user_id ~= nil then
		v1073.user_id = t108.user_id
	end

	if t108.userId ~= nil then
		v1073.user_id = t108.userId
	end

	return v1073
end

t105.descriptor = {
	name = "ExperienceActionModuleInputData_ConnectionPlayedUser",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConnectionPlayedUser"
}
t1.ExperienceActionModuleInputData_ConnectionPlayedUser = t105
typeRegistry.default:register(t1.ExperienceActionModuleInputData_ConnectionPlayedUser)

local t109 = {}

t109.__index = t109

function t109.new(t110: {[any]: any}?) -- line: 8525
	-- upvalues: t109 (copy)
	return (setmetatable({
		media_items = if t110 ~= nil and t110.media_items ~= nil then t110.media_items else {},
		universe_id = if t110 ~= nil and t110.universe_id ~= nil then t110.universe_id else "",
		place_id = if t110 ~= nil and t110.place_id ~= nil then t110.place_id else ""
	}, t109))
end
function t109.encode(p70) -- line: 8535
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n46 = 0

	if p70.media_items ~= nil and #p70.media_items > 0 then
		for _, v1079 in p70.media_items do
			local v1080 = v1079:encode()
			local v1081, v1082 = proto.writeTag(buf, n46, 1, proto.wireTypes.lengthDelimited)

			buf, n46 = proto.writeBuffer(v1081, v1082, v1080, buffer.len(v1080))
		end
	end

	if p70.universe_id ~= nil and p70.universe_id ~= "" then
		local v1083, v1084 = proto.writeTag(buf, n46, 2, proto.wireTypes.lengthDelimited)

		buf, n46 = proto.writeString(v1083, v1084, p70.universe_id)
	end

	if p70.place_id ~= nil and p70.place_id ~= "" then
		local v1085, v1086 = proto.writeTag(buf, n46, 3, proto.wireTypes.lengthDelimited)

		buf, n46 = proto.writeString(v1085, v1086, p70.place_id)
	end

	local buf27 = buffer.create(n46)

	buffer.copy(buf27, 0, buf, 0, n46)

	return buf27
end
function t109.decode(p71: buffer) -- line: 8562
	-- upvalues: t109 (copy), proto (copy), t1 (copy)
	local v1089 = t109.new()
	local n47 = 0

	while n47 < buffer.len(p71) do
		local v1091, v1092

		v1091, v1092, n47 = proto.readTag(p71, n47)

		if v1092 == proto.wireTypes.varint then
			local v1093

			v1093, n47 = proto.readVarInt(p71, n47)
		elseif v1092 == proto.wireTypes.lengthDelimited then
			if v1091 == 1 then
				local v1094

				v1094, n47 = proto.readBuffer(p71, n47)
				table.insert(v1089.media_items, t1.ExperienceMediaGalleryInputData_MediaItem.decode(v1094))
			elseif v1091 == 2 then
				local v1095

				v1095, n47 = proto.readBuffer(p71, n47)
				v1089.universe_id = buffer.tostring(v1095)
			elseif v1091 == 3 then
				local v1096

				v1096, n47 = proto.readBuffer(p71, n47)
				v1089.place_id = buffer.tostring(v1096)
			else
				local v1097, v1098 = proto.readVarInt(p71, n47)

				n47 = v1098 + v1097
			end
		elseif v1092 == proto.wireTypes.i32 then
			local v1099

			v1099, n47 = proto.readFixed32(p71, n47)
		elseif v1092 == proto.wireTypes.i64 then
			local v1100

			v1100, n47 = proto.readFixed64(p71, n47)
		else
			error("Unsupported wire type: " .. v1092)
		end
	end

	return v1089
end
function t109.jsonEncode(p72) -- line: 8615
	local t111 = {}

	if p72.media_items ~= nil and #p72.media_items > 0 then
		local t112 = {}

		for _, v1105 in p72.media_items do
			table.insert(t112, v1105:jsonEncode())
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
function t109.jsonDecode(t113: {[any]: any}) -- line: 8637
	-- upvalues: t109 (copy), t1 (copy)
	local v1107 = t109.new()

	if t113.media_items ~= nil then
		local t114 = {}

		for _, v1110 in t113.media_items do
			table.insert(t114, t1.ExperienceMediaGalleryInputData_MediaItem.jsonDecode(v1110))
		end

		v1107.media_items = t114
	end

	if t113.mediaItems ~= nil then
		local t115 = {}

		for _, v1113 in t113.mediaItems do
			table.insert(t115, t1.ExperienceMediaGalleryInputData_MediaItem.jsonDecode(v1113))
		end

		v1107.media_items = t115
	end

	if t113.universe_id ~= nil then
		v1107.universe_id = t113.universe_id
	end

	if t113.universeId ~= nil then
		v1107.universe_id = t113.universeId
	end

	if t113.place_id ~= nil then
		v1107.place_id = t113.place_id
	end

	if t113.placeId ~= nil then
		v1107.place_id = t113.placeId
	end

	return v1107
end

t109.descriptor = {
	name = "ExperienceMediaGalleryInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceMediaGalleryInputData"
}
t1.ExperienceMediaGalleryInputData = t109
typeRegistry.default:register(t1.ExperienceMediaGalleryInputData)

local t116 = {}

t116.__index = t116

function t116.new(t117: {[any]: any}?) -- line: 8691
	-- upvalues: t116 (copy)
	return (setmetatable({
		media_asset_id = if t117 ~= nil and t117.media_asset_id ~= nil then t117.media_asset_id else ""
	}, t116))
end
function t116.encode(p73) -- line: 8699
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n48 = 0

	if p73.media_asset_id ~= nil and p73.media_asset_id ~= "" then
		local v1118, v1119 = proto.writeTag(buf, n48, 1, proto.wireTypes.lengthDelimited)

		buf, n48 = proto.writeString(v1118, v1119, p73.media_asset_id)
	end

	local buf28 = buffer.create(n48)

	buffer.copy(buf28, 0, buf, 0, n48)

	return buf28
end
function t116.decode(p74: buffer) -- line: 8715
	-- upvalues: t116 (copy), proto (copy)
	local v1122 = t116.new()
	local n49 = 0

	while n49 < buffer.len(p74) do
		local v1124, v1125

		v1124, v1125, n49 = proto.readTag(p74, n49)

		if v1125 == proto.wireTypes.varint then
			local v1126

			v1126, n49 = proto.readVarInt(p74, n49)
		elseif v1125 == proto.wireTypes.lengthDelimited then
			if v1124 == 1 then
				local v1127

				v1127, n49 = proto.readBuffer(p74, n49)
				v1122.media_asset_id = buffer.tostring(v1127)
			else
				local v1128, v1129 = proto.readVarInt(p74, n49)

				n49 = v1129 + v1128
			end
		elseif v1125 == proto.wireTypes.i32 then
			local v1130

			v1130, n49 = proto.readFixed32(p74, n49)
		elseif v1125 == proto.wireTypes.i64 then
			local v1131

			v1131, n49 = proto.readFixed64(p74, n49)
		else
			error("Unsupported wire type: " .. v1125)
		end
	end

	return v1122
end
function t116.jsonEncode(p75) -- line: 8760
	local t118 = {}

	if p75.media_asset_id ~= nil and p75.media_asset_id ~= "" then
		t118.mediaAssetId = p75.media_asset_id
	end

	return t118
end
function t116.jsonDecode(t119: {[any]: any}) -- line: 8772
	-- upvalues: t116 (copy)
	local v1135 = t116.new()

	if t119.media_asset_id ~= nil then
		v1135.media_asset_id = t119.media_asset_id
	end

	if t119.mediaAssetId ~= nil then
		v1135.media_asset_id = t119.mediaAssetId
	end

	return v1135
end

t116.descriptor = {
	name = "ExperienceMediaGalleryInputData_MediaItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.MediaItem"
}
t1.ExperienceMediaGalleryInputData_MediaItem = t116
typeRegistry.default:register(t1.ExperienceMediaGalleryInputData_MediaItem)

local t120 = {}

t120.__index = t120

function t120.new(t121: {[any]: any}?) -- line: 8802
	-- upvalues: t120 (copy)
	return (setmetatable({
		universe_id = if t121 ~= nil and t121.universe_id ~= nil then t121.universe_id else ""
	}, t120))
end
function t120.encode(p76) -- line: 8810
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n50 = 0

	if p76.universe_id ~= nil and p76.universe_id ~= "" then
		local v1140, v1141 = proto.writeTag(buf, n50, 1, proto.wireTypes.lengthDelimited)

		buf, n50 = proto.writeString(v1140, v1141, p76.universe_id)
	end

	local buf29 = buffer.create(n50)

	buffer.copy(buf29, 0, buf, 0, n50)

	return buf29
end
function t120.decode(p77: buffer) -- line: 8824
	-- upvalues: t120 (copy), proto (copy)
	local v1144 = t120.new()
	local n51 = 0

	while n51 < buffer.len(p77) do
		local v1146, v1147

		v1146, v1147, n51 = proto.readTag(p77, n51)

		if v1147 == proto.wireTypes.varint then
			local v1148

			v1148, n51 = proto.readVarInt(p77, n51)
		elseif v1147 == proto.wireTypes.lengthDelimited then
			if v1146 == 1 then
				local v1149

				v1149, n51 = proto.readBuffer(p77, n51)
				v1144.universe_id = buffer.tostring(v1149)
			else
				local v1150, v1151 = proto.readVarInt(p77, n51)

				n51 = v1151 + v1150
			end
		elseif v1147 == proto.wireTypes.i32 then
			local v1152

			v1152, n51 = proto.readFixed32(p77, n51)
		elseif v1147 == proto.wireTypes.i64 then
			local v1153

			v1153, n51 = proto.readFixed64(p77, n51)
		else
			error("Unsupported wire type: " .. v1147)
		end
	end

	return v1144
end
function t120.jsonEncode(p78) -- line: 8867
	local t122 = {}

	if p78.universe_id ~= nil and p78.universe_id ~= "" then
		t122.universeId = p78.universe_id
	end

	return t122
end
function t120.jsonDecode(t123: {[any]: any}) -- line: 8877
	-- upvalues: t120 (copy)
	local v1157 = t120.new()

	if t123.universe_id ~= nil then
		v1157.universe_id = t123.universe_id
	end

	if t123.universeId ~= nil then
		v1157.universe_id = t123.universeId
	end

	return v1157
end

t120.descriptor = {
	name = "ExperienceDescriptionInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceDescriptionInputData"
}
t1.ExperienceDescriptionInputData = t120
typeRegistry.default:register(t1.ExperienceDescriptionInputData)

local t124 = {}

t124.__index = t124

function t124.new(t125: {[any]: any}?) -- line: 8905
	-- upvalues: t124 (copy)
	return (setmetatable({
		universe_id = if t125 ~= nil and t125.universe_id ~= nil then t125.universe_id else ""
	}, t124))
end
function t124.encode(p79) -- line: 8913
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n52 = 0

	if p79.universe_id ~= nil and p79.universe_id ~= "" then
		local v1162, v1163 = proto.writeTag(buf, n52, 1, proto.wireTypes.lengthDelimited)

		buf, n52 = proto.writeString(v1162, v1163, p79.universe_id)
	end

	local buf30 = buffer.create(n52)

	buffer.copy(buf30, 0, buf, 0, n52)

	return buf30
end
function t124.decode(p80: buffer) -- line: 8927
	-- upvalues: t124 (copy), proto (copy)
	local v1166 = t124.new()
	local n53 = 0

	while n53 < buffer.len(p80) do
		local v1168, v1169

		v1168, v1169, n53 = proto.readTag(p80, n53)

		if v1169 == proto.wireTypes.varint then
			local v1170

			v1170, n53 = proto.readVarInt(p80, n53)
		elseif v1169 == proto.wireTypes.lengthDelimited then
			if v1168 == 1 then
				local v1171

				v1171, n53 = proto.readBuffer(p80, n53)
				v1166.universe_id = buffer.tostring(v1171)
			else
				local v1172, v1173 = proto.readVarInt(p80, n53)

				n53 = v1173 + v1172
			end
		elseif v1169 == proto.wireTypes.i32 then
			local v1174

			v1174, n53 = proto.readFixed32(p80, n53)
		elseif v1169 == proto.wireTypes.i64 then
			local v1175

			v1175, n53 = proto.readFixed64(p80, n53)
		else
			error("Unsupported wire type: " .. v1169)
		end
	end

	return v1166
end
function t124.jsonEncode(p81) -- line: 8970
	local t126 = {}

	if p81.universe_id ~= nil and p81.universe_id ~= "" then
		t126.universeId = p81.universe_id
	end

	return t126
end
function t124.jsonDecode(t127: {[any]: any}) -- line: 8980
	-- upvalues: t124 (copy)
	local v1179 = t124.new()

	if t127.universe_id ~= nil then
		v1179.universe_id = t127.universe_id
	end

	if t127.universeId ~= nil then
		v1179.universe_id = t127.universeId
	end

	return v1179
end

t124.descriptor = {
	name = "ExperienceStatRowInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceStatRowInputData"
}
t1.ExperienceStatRowInputData = t124
typeRegistry.default:register(t1.ExperienceStatRowInputData)

local t128 = {}

t128.__index = t128

function t128.new(t129: {[any]: any}?) -- line: 9008
	-- upvalues: t128 (copy)
	return (setmetatable({
		universe_id = if t129 ~= nil and t129.universe_id ~= nil then t129.universe_id else "",
		has_store_items = t129 ~= nil and (t129.has_store_items ~= nil and t129.has_store_items),
		has_badges = t129 ~= nil and (t129.has_badges ~= nil and t129.has_badges),
		has_game_passes = t129 ~= nil and (t129.has_game_passes ~= nil and t129.has_game_passes)
	}, t128))
end
function t128.encode(p82) -- line: 9019
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n54 = 0

	if p82.universe_id ~= nil and p82.universe_id ~= "" then
		local v1184, v1185 = proto.writeTag(buf, n54, 1, proto.wireTypes.lengthDelimited)

		buf, n54 = proto.writeString(v1184, v1185, p82.universe_id)
	end

	if p82.has_store_items then
		local v1186, v1187 = proto.writeTag(buf, n54, 2, proto.wireTypes.varint)

		buf, n54 = proto.writeVarInt(v1186, v1187, not p82.has_store_items and 0 or 1)
	end

	if p82.has_badges then
		local v1188, v1189 = proto.writeTag(buf, n54, 3, proto.wireTypes.varint)

		buf, n54 = proto.writeVarInt(v1188, v1189, not p82.has_badges and 0 or 1)
	end

	if p82.has_game_passes then
		local v1190, v1191 = proto.writeTag(buf, n54, 4, proto.wireTypes.varint)

		buf, n54 = proto.writeVarInt(v1190, v1191, not p82.has_game_passes and 0 or 1)
	end

	local buf31 = buffer.create(n54)

	buffer.copy(buf31, 0, buf, 0, n54)

	return buf31
end
function t128.decode(p83: buffer) -- line: 9048
	-- upvalues: t128 (copy), proto (copy)
	local v1194 = t128.new()
	local n55 = 0

	while n55 < buffer.len(p83) do
		local v1196, v1197

		v1196, v1197, n55 = proto.readTag(p83, n55)

		if v1197 == proto.wireTypes.varint then
			if v1196 == 2 then
				local v1198

				v1198, n55 = proto.readVarInt(p83, n55)
				v1194.has_store_items = v1198 ~= 0
			elseif v1196 == 3 then
				local v1199

				v1199, n55 = proto.readVarInt(p83, n55)
				v1194.has_badges = v1199 ~= 0
			elseif v1196 == 4 then
				local v1200

				v1200, n55 = proto.readVarInt(p83, n55)
				v1194.has_game_passes = v1200 ~= 0
			else
				local v1201

				v1201, n55 = proto.readVarInt(p83, n55)
			end
		elseif v1197 == proto.wireTypes.lengthDelimited then
			if v1196 == 1 then
				local v1202

				v1202, n55 = proto.readBuffer(p83, n55)
				v1194.universe_id = buffer.tostring(v1202)
			else
				local v1203, v1204 = proto.readVarInt(p83, n55)

				n55 = v1204 + v1203
			end
		elseif v1197 == proto.wireTypes.i32 then
			local v1205

			v1205, n55 = proto.readFixed32(p83, n55)
		elseif v1197 == proto.wireTypes.i64 then
			local v1206

			v1206, n55 = proto.readFixed64(p83, n55)
		else
			error("Unsupported wire type: " .. v1197)
		end
	end

	return v1194
end
function t128.jsonEncode(p84) -- line: 9106
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
function t128.jsonDecode(t131: {[any]: any}) -- line: 9128
	-- upvalues: t128 (copy)
	local v1210 = t128.new()

	if t131.universe_id ~= nil then
		v1210.universe_id = t131.universe_id
	end

	if t131.universeId ~= nil then
		v1210.universe_id = t131.universeId
	end

	if t131.has_store_items ~= nil then
		v1210.has_store_items = t131.has_store_items
	end

	if t131.hasStoreItems ~= nil then
		v1210.has_store_items = t131.hasStoreItems
	end

	if t131.has_badges ~= nil then
		v1210.has_badges = t131.has_badges
	end

	if t131.hasBadges ~= nil then
		v1210.has_badges = t131.hasBadges
	end

	if t131.has_game_passes ~= nil then
		v1210.has_game_passes = t131.has_game_passes
	end

	if t131.hasGamePasses ~= nil then
		v1210.has_game_passes = t131.hasGamePasses
	end

	return v1210
end

t128.descriptor = {
	name = "ExperienceInfoTableInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceInfoTableInputData"
}
t1.ExperienceInfoTableInputData = t128
typeRegistry.default:register(t1.ExperienceInfoTableInputData)

local t132 = {}

t132.__index = t132

function t132.new(t133: {[any]: any}?) -- line: 9180
	-- upvalues: t132 (copy)
	return (setmetatable({
		universe_id = if t133 ~= nil and t133.universe_id ~= nil then t133.universe_id else ""
	}, t132))
end
function t132.encode(p85) -- line: 9188
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n56 = 0

	if p85.universe_id ~= nil and p85.universe_id ~= "" then
		local v1215, v1216 = proto.writeTag(buf, n56, 1, proto.wireTypes.lengthDelimited)

		buf, n56 = proto.writeString(v1215, v1216, p85.universe_id)
	end

	local buf32 = buffer.create(n56)

	buffer.copy(buf32, 0, buf, 0, n56)

	return buf32
end
function t132.decode(p86: buffer) -- line: 9202
	-- upvalues: t132 (copy), proto (copy)
	local v1219 = t132.new()
	local n57 = 0

	while n57 < buffer.len(p86) do
		local v1221, v1222

		v1221, v1222, n57 = proto.readTag(p86, n57)

		if v1222 == proto.wireTypes.varint then
			local v1223

			v1223, n57 = proto.readVarInt(p86, n57)
		elseif v1222 == proto.wireTypes.lengthDelimited then
			if v1221 == 1 then
				local v1224

				v1224, n57 = proto.readBuffer(p86, n57)
				v1219.universe_id = buffer.tostring(v1224)
			else
				local v1225, v1226 = proto.readVarInt(p86, n57)

				n57 = v1226 + v1225
			end
		elseif v1222 == proto.wireTypes.i32 then
			local v1227

			v1227, n57 = proto.readFixed32(p86, n57)
		elseif v1222 == proto.wireTypes.i64 then
			local v1228

			v1228, n57 = proto.readFixed64(p86, n57)
		else
			error("Unsupported wire type: " .. v1222)
		end
	end

	return v1219
end
function t132.jsonEncode(p87) -- line: 9245
	local t134 = {}

	if p87.universe_id ~= nil and p87.universe_id ~= "" then
		t134.universeId = p87.universe_id
	end

	return t134
end
function t132.jsonDecode(t135: {[any]: any}) -- line: 9255
	-- upvalues: t132 (copy)
	local v1232 = t132.new()

	if t135.universe_id ~= nil then
		v1232.universe_id = t135.universe_id
	end

	if t135.universeId ~= nil then
		v1232.universe_id = t135.universeId
	end

	return v1232
end

t132.descriptor = {
	name = "ExperienceContentRatingLabelInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceContentRatingLabelInputData"
}
t1.ExperienceContentRatingLabelInputData = t132
typeRegistry.default:register(t1.ExperienceContentRatingLabelInputData)

local t136 = {}

t136.__index = t136

function t136.new(t137: {[any]: any}?) -- line: 9285
	-- upvalues: t136 (copy)
	return (setmetatable({
		universe_id = if t137 ~= nil and t137.universe_id ~= nil then t137.universe_id else "",
		user_owns_experience = t137 ~= nil and (t137.user_owns_experience ~= nil and t137.user_owns_experience)
	}, t136))
end
function t136.encode(p88) -- line: 9296
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n58 = 0

	if p88.universe_id ~= nil and p88.universe_id ~= "" then
		local v1237, v1238 = proto.writeTag(buf, n58, 1, proto.wireTypes.lengthDelimited)

		buf, n58 = proto.writeString(v1237, v1238, p88.universe_id)
	end

	if p88.user_owns_experience then
		local v1239, v1240 = proto.writeTag(buf, n58, 2, proto.wireTypes.varint)

		buf, n58 = proto.writeVarInt(v1239, v1240, not p88.user_owns_experience and 0 or 1)
	end

	local buf33 = buffer.create(n58)

	buffer.copy(buf33, 0, buf, 0, n58)

	return buf33
end
function t136.decode(p89: buffer) -- line: 9315
	-- upvalues: t136 (copy), proto (copy)
	local v1243 = t136.new()
	local n59 = 0

	while n59 < buffer.len(p89) do
		local v1245, v1246

		v1245, v1246, n59 = proto.readTag(p89, n59)

		if v1246 == proto.wireTypes.varint then
			if v1245 == 2 then
				local v1247

				v1247, n59 = proto.readVarInt(p89, n59)
				v1243.user_owns_experience = v1247 ~= 0
			else
				local v1248

				v1248, n59 = proto.readVarInt(p89, n59)
			end
		elseif v1246 == proto.wireTypes.lengthDelimited then
			if v1245 == 1 then
				local v1249

				v1249, n59 = proto.readBuffer(p89, n59)
				v1243.universe_id = buffer.tostring(v1249)
			else
				local v1250, v1251 = proto.readVarInt(p89, n59)

				n59 = v1251 + v1250
			end
		elseif v1246 == proto.wireTypes.i32 then
			local v1252

			v1252, n59 = proto.readFixed32(p89, n59)
		elseif v1246 == proto.wireTypes.i64 then
			local v1253

			v1253, n59 = proto.readFixed64(p89, n59)
		else
			error("Unsupported wire type: " .. v1246)
		end
	end

	return v1243
end
function t136.jsonEncode(p90) -- line: 9363
	local t138 = {}

	if p90.universe_id ~= nil and p90.universe_id ~= "" then
		t138.universeId = p90.universe_id
	end

	if p90.user_owns_experience then
		t138.userOwnsExperience = p90.user_owns_experience
	end

	return t138
end
function t136.jsonDecode(t139: {[any]: any}) -- line: 9377
	-- upvalues: t136 (copy)
	local v1257 = t136.new()

	if t139.universe_id ~= nil then
		v1257.universe_id = t139.universe_id
	end

	if t139.universeId ~= nil then
		v1257.universe_id = t139.universeId
	end

	if t139.user_owns_experience ~= nil then
		v1257.user_owns_experience = t139.user_owns_experience
	end

	if t139.userOwnsExperience ~= nil then
		v1257.user_owns_experience = t139.userOwnsExperience
	end

	return v1257
end

t136.descriptor = {
	name = "ExperienceRefundPolicyInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceRefundPolicyInputData"
}
t1.ExperienceRefundPolicyInputData = t136
typeRegistry.default:register(t1.ExperienceRefundPolicyInputData)

local t140 = {}

t140.__index = t140

function t140.new(t141: {[any]: any}?) -- line: 9413
	-- upvalues: t140 (copy)
	return (setmetatable({
		universe_id = if t141 ~= nil and t141.universe_id ~= nil then t141.universe_id else "",
		place_id = if t141 ~= nil and t141.place_id ~= nil then t141.place_id else ""
	}, t140))
end
function t140.encode(p91) -- line: 9422
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n60 = 0

	if p91.universe_id ~= nil and p91.universe_id ~= "" then
		local v1262, v1263 = proto.writeTag(buf, n60, 1, proto.wireTypes.lengthDelimited)

		buf, n60 = proto.writeString(v1262, v1263, p91.universe_id)
	end

	if p91.place_id ~= nil and p91.place_id ~= "" then
		local v1264, v1265 = proto.writeTag(buf, n60, 2, proto.wireTypes.lengthDelimited)

		buf, n60 = proto.writeString(v1264, v1265, p91.place_id)
	end

	local buf34 = buffer.create(n60)

	buffer.copy(buf34, 0, buf, 0, n60)

	return buf34
end
function t140.decode(p92: buffer) -- line: 9441
	-- upvalues: t140 (copy), proto (copy)
	local v1268 = t140.new()
	local n61 = 0

	while n61 < buffer.len(p92) do
		local v1270, v1271

		v1270, v1271, n61 = proto.readTag(p92, n61)

		if v1271 == proto.wireTypes.varint then
			local v1272

			v1272, n61 = proto.readVarInt(p92, n61)
		elseif v1271 == proto.wireTypes.lengthDelimited then
			if v1270 == 1 then
				local v1273

				v1273, n61 = proto.readBuffer(p92, n61)
				v1268.universe_id = buffer.tostring(v1273)
			elseif v1270 == 2 then
				local v1274

				v1274, n61 = proto.readBuffer(p92, n61)
				v1268.place_id = buffer.tostring(v1274)
			else
				local v1275, v1276 = proto.readVarInt(p92, n61)

				n61 = v1276 + v1275
			end
		elseif v1271 == proto.wireTypes.i32 then
			local v1277

			v1277, n61 = proto.readFixed32(p92, n61)
		elseif v1271 == proto.wireTypes.i64 then
			local v1278

			v1278, n61 = proto.readFixed64(p92, n61)
		else
			error("Unsupported wire type: " .. v1271)
		end
	end

	return v1268
end
function t140.jsonEncode(p93) -- line: 9489
	local t142 = {}

	if p93.universe_id ~= nil and p93.universe_id ~= "" then
		t142.universeId = p93.universe_id
	end

	if p93.place_id ~= nil and p93.place_id ~= "" then
		t142.placeId = p93.place_id
	end

	return t142
end
function t140.jsonDecode(t143: {[any]: any}) -- line: 9503
	-- upvalues: t140 (copy)
	local v1282 = t140.new()

	if t143.universe_id ~= nil then
		v1282.universe_id = t143.universe_id
	end

	if t143.universeId ~= nil then
		v1282.universe_id = t143.universeId
	end

	if t143.place_id ~= nil then
		v1282.place_id = t143.place_id
	end

	if t143.placeId ~= nil then
		v1282.place_id = t143.placeId
	end

	return v1282
end

t140.descriptor = {
	name = "ExperiencePlayWithRewardInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperiencePlayWithRewardInputData"
}
t1.ExperiencePlayWithRewardInputData = t140
typeRegistry.default:register(t1.ExperiencePlayWithRewardInputData)

local t144 = {}

t144.__index = t144

function t144.new(t145: {[any]: any}?) -- line: 9541
	-- upvalues: t144 (copy)
	return (setmetatable({
		community_id = if t145 ~= nil and t145.community_id ~= nil then t145.community_id else ""
	}, t144))
end
function t144.encode(p94) -- line: 9549
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n62 = 0

	if p94.community_id ~= nil and p94.community_id ~= "" then
		local v1287, v1288 = proto.writeTag(buf, n62, 1, proto.wireTypes.lengthDelimited)

		buf, n62 = proto.writeString(v1287, v1288, p94.community_id)
	end

	local buf35 = buffer.create(n62)

	buffer.copy(buf35, 0, buf, 0, n62)

	return buf35
end
function t144.decode(p95: buffer) -- line: 9563
	-- upvalues: t144 (copy), proto (copy)
	local v1291 = t144.new()
	local n63 = 0

	while n63 < buffer.len(p95) do
		local v1293, v1294

		v1293, v1294, n63 = proto.readTag(p95, n63)

		if v1294 == proto.wireTypes.varint then
			local v1295

			v1295, n63 = proto.readVarInt(p95, n63)
		elseif v1294 == proto.wireTypes.lengthDelimited then
			if v1293 == 1 then
				local v1296

				v1296, n63 = proto.readBuffer(p95, n63)
				v1291.community_id = buffer.tostring(v1296)
			else
				local v1297, v1298 = proto.readVarInt(p95, n63)

				n63 = v1298 + v1297
			end
		elseif v1294 == proto.wireTypes.i32 then
			local v1299

			v1299, n63 = proto.readFixed32(p95, n63)
		elseif v1294 == proto.wireTypes.i64 then
			local v1300

			v1300, n63 = proto.readFixed64(p95, n63)
		else
			error("Unsupported wire type: " .. v1294)
		end
	end

	return v1291
end
function t144.jsonEncode(p96) -- line: 9606
	local t146 = {}

	if p96.community_id ~= nil and p96.community_id ~= "" then
		t146.communityId = p96.community_id
	end

	return t146
end
function t144.jsonDecode(t147: {[any]: any}) -- line: 9616
	-- upvalues: t144 (copy)
	local v1304 = t144.new()

	if t147.community_id ~= nil then
		v1304.community_id = t147.community_id
	end

	if t147.communityId ~= nil then
		v1304.community_id = t147.communityId
	end

	return v1304
end

t144.descriptor = {
	name = "CommunitySectionInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CommunitySectionInputData"
}
t1.CommunitySectionInputData = t144
typeRegistry.default:register(t1.CommunitySectionInputData)

local t148 = {}

t148.__index = t148

function t148.new(t149: {[any]: any}?) -- line: 9644
	-- upvalues: t148 (copy)
	return (setmetatable({
		social_link_items = if t149 ~= nil and t149.social_link_items ~= nil then t149.social_link_items else {}
	}, t148))
end
function t148.encode(p97) -- line: 9650
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n64 = 0

	if p97.social_link_items ~= nil and #p97.social_link_items > 0 then
		for _, v1310 in p97.social_link_items do
			local v1311 = v1310:encode()
			local v1312, v1313 = proto.writeTag(buf, n64, 1, proto.wireTypes.lengthDelimited)

			buf, n64 = proto.writeBuffer(v1312, v1313, v1311, buffer.len(v1311))
		end
	end

	local buf36 = buffer.create(n64)

	buffer.copy(buf36, 0, buf, 0, n64)

	return buf36
end
function t148.decode(p98: buffer) -- line: 9667
	-- upvalues: t148 (copy), proto (copy), t1 (copy)
	local v1316 = t148.new()
	local n65 = 0

	while n65 < buffer.len(p98) do
		local v1318, v1319

		v1318, v1319, n65 = proto.readTag(p98, n65)

		if v1319 == proto.wireTypes.varint then
			local v1320

			v1320, n65 = proto.readVarInt(p98, n65)
		elseif v1319 == proto.wireTypes.lengthDelimited then
			if v1318 == 1 then
				local v1321

				v1321, n65 = proto.readBuffer(p98, n65)
				table.insert(v1316.social_link_items, t1.SocialLinkRowInputData_SocialLinkItem.decode(v1321))
			else
				local v1322, v1323 = proto.readVarInt(p98, n65)

				n65 = v1323 + v1322
			end
		elseif v1319 == proto.wireTypes.i32 then
			local v1324

			v1324, n65 = proto.readFixed32(p98, n65)
		elseif v1319 == proto.wireTypes.i64 then
			local v1325

			v1325, n65 = proto.readFixed64(p98, n65)
		else
			error("Unsupported wire type: " .. v1319)
		end
	end

	return v1316
end
function t148.jsonEncode(p99) -- line: 9710
	local t150 = {}

	if p99.social_link_items ~= nil and #p99.social_link_items > 0 then
		local t151 = {}

		for _, v1330 in p99.social_link_items do
			table.insert(t151, v1330:jsonEncode())
		end

		t150.socialLinkItems = t151
	end

	return t150
end
function t148.jsonDecode(t152: {[any]: any}) -- line: 9724
	-- upvalues: t148 (copy), t1 (copy)
	local v1332 = t148.new()

	if t152.social_link_items ~= nil then
		local t153 = {}

		for _, v1335 in t152.social_link_items do
			table.insert(t153, t1.SocialLinkRowInputData_SocialLinkItem.jsonDecode(v1335))
		end

		v1332.social_link_items = t153
	end

	if t152.socialLinkItems ~= nil then
		local t154 = {}

		for _, v1338 in t152.socialLinkItems do
			table.insert(t154, t1.SocialLinkRowInputData_SocialLinkItem.jsonDecode(v1338))
		end

		v1332.social_link_items = t154
	end

	return v1332
end

t148.descriptor = {
	name = "SocialLinkRowInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.SocialLinkRowInputData"
}
t1.SocialLinkRowInputData = t148
typeRegistry.default:register(t1.SocialLinkRowInputData)

local t155 = {}

t155.__index = t155

function t155.new(t156: {[any]: any}?) -- line: 9762
	-- upvalues: t155 (copy)
	return (setmetatable({
		social_link_id = if t156 ~= nil and t156.social_link_id ~= nil then t156.social_link_id else ""
	}, t155))
end
function t155.encode(p100) -- line: 9770
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n66 = 0

	if p100.social_link_id ~= nil and p100.social_link_id ~= "" then
		local v1343, v1344 = proto.writeTag(buf, n66, 1, proto.wireTypes.lengthDelimited)

		buf, n66 = proto.writeString(v1343, v1344, p100.social_link_id)
	end

	local buf37 = buffer.create(n66)

	buffer.copy(buf37, 0, buf, 0, n66)

	return buf37
end
function t155.decode(p101: buffer) -- line: 9784
	-- upvalues: t155 (copy), proto (copy)
	local v1347 = t155.new()
	local n67 = 0

	while n67 < buffer.len(p101) do
		local v1349, v1350

		v1349, v1350, n67 = proto.readTag(p101, n67)

		if v1350 == proto.wireTypes.varint then
			local v1351

			v1351, n67 = proto.readVarInt(p101, n67)
		elseif v1350 == proto.wireTypes.lengthDelimited then
			if v1349 == 1 then
				local v1352

				v1352, n67 = proto.readBuffer(p101, n67)
				v1347.social_link_id = buffer.tostring(v1352)
			else
				local v1353, v1354 = proto.readVarInt(p101, n67)

				n67 = v1354 + v1353
			end
		elseif v1350 == proto.wireTypes.i32 then
			local v1355

			v1355, n67 = proto.readFixed32(p101, n67)
		elseif v1350 == proto.wireTypes.i64 then
			local v1356

			v1356, n67 = proto.readFixed64(p101, n67)
		else
			error("Unsupported wire type: " .. v1350)
		end
	end

	return v1347
end
function t155.jsonEncode(p102) -- line: 9827
	local t157 = {}

	if p102.social_link_id ~= nil and p102.social_link_id ~= "" then
		t157.socialLinkId = p102.social_link_id
	end

	return t157
end
function t155.jsonDecode(t158: {[any]: any}) -- line: 9837
	-- upvalues: t155 (copy)
	local v1360 = t155.new()

	if t158.social_link_id ~= nil then
		v1360.social_link_id = t158.social_link_id
	end

	if t158.socialLinkId ~= nil then
		v1360.social_link_id = t158.socialLinkId
	end

	return v1360
end

t155.descriptor = {
	name = "SocialLinkRowInputData_SocialLinkItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.SocialLinkItem"
}
t1.SocialLinkRowInputData_SocialLinkItem = t155
typeRegistry.default:register(t1.SocialLinkRowInputData_SocialLinkItem)

local t159 = {}

t159.__index = t159

function t159.new(t160: {[any]: any}?) -- line: 9867
	-- upvalues: t159 (copy)
	return (setmetatable({
		title = if t160 ~= nil and t160.title ~= nil then t160.title else "",
		universe_items = if t160 ~= nil and t160.universe_items ~= nil then t160.universe_items else {},
		next_page_token = if t160 ~= nil and t160.next_page_token ~= nil then t160.next_page_token else "",
		sort_id = if t160 ~= nil and t160.sort_id ~= nil then t160.sort_id else "",
		secondary_sort_id = if t160 ~= nil and t160.secondary_sort_id ~= nil then t160.secondary_sort_id else 0,
		max_visible_rows = if t160 ~= nil and t160.max_visible_rows ~= nil then t160.max_visible_rows else 0,
		subtitle = if t160 ~= nil and t160.subtitle ~= nil then t160.subtitle else "",
		info_text = if t160 ~= nil and t160.info_text ~= nil then t160.info_text else "",
		subtitle_link_path = if t160 ~= nil and t160.subtitle_link_path ~= nil then t160.subtitle_link_path else "",
		is_placeholder = if t160 ~= nil and t160.is_placeholder ~= nil then t160.is_placeholder else nil,
		primary_sort_id = if t160 ~= nil and t160.primary_sort_id ~= nil then t160.primary_sort_id else nil,
		applied_filters = if t160 ~= nil and t160.applied_filters ~= nil then t160.applied_filters else nil,
		pool_id = if t160 ~= nil and t160.pool_id ~= nil then t160.pool_id else nil,
		has_emphasized_tile = t160 ~= nil and (t160.has_emphasized_tile ~= nil and t160.has_emphasized_tile)
	}, t159))
end
function t159.encode(p103) -- line: 9890
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n68 = 0

	if p103.title ~= nil and p103.title ~= "" then
		local v1365, v1366 = proto.writeTag(buf, n68, 1, proto.wireTypes.lengthDelimited)

		buf, n68 = proto.writeString(v1365, v1366, p103.title)
	end

	if p103.universe_items ~= nil and #p103.universe_items > 0 then
		for _, v1368 in p103.universe_items do
			local v1369 = v1368:encode()
			local v1370, v1371 = proto.writeTag(buf, n68, 2, proto.wireTypes.lengthDelimited)

			buf, n68 = proto.writeBuffer(v1370, v1371, v1369, buffer.len(v1369))
		end
	end

	if p103.next_page_token ~= nil and p103.next_page_token ~= "" then
		local v1372, v1373 = proto.writeTag(buf, n68, 3, proto.wireTypes.lengthDelimited)

		buf, n68 = proto.writeString(v1372, v1373, p103.next_page_token)
	end

	if p103.sort_id ~= nil and p103.sort_id ~= "" then
		local v1374, v1375 = proto.writeTag(buf, n68, 4, proto.wireTypes.lengthDelimited)

		buf, n68 = proto.writeString(v1374, v1375, p103.sort_id)
	end

	if p103.secondary_sort_id ~= nil and p103.secondary_sort_id ~= 0 then
		local v1376, v1377 = proto.writeTag(buf, n68, 5, proto.wireTypes.varint)

		buf, n68 = proto.writeVarInt(v1376, v1377, p103.secondary_sort_id)
	end

	if p103.max_visible_rows ~= nil and p103.max_visible_rows ~= 0 then
		local v1378, v1379 = proto.writeTag(buf, n68, 6, proto.wireTypes.varint)

		buf, n68 = proto.writeVarInt(v1378, v1379, p103.max_visible_rows)
	end

	if p103.subtitle ~= nil and p103.subtitle ~= "" then
		local v1380, v1381 = proto.writeTag(buf, n68, 7, proto.wireTypes.lengthDelimited)

		buf, n68 = proto.writeString(v1380, v1381, p103.subtitle)
	end

	if p103.info_text ~= nil and p103.info_text ~= "" then
		local v1382, v1383 = proto.writeTag(buf, n68, 8, proto.wireTypes.lengthDelimited)

		buf, n68 = proto.writeString(v1382, v1383, p103.info_text)
	end

	if p103.subtitle_link_path ~= nil and p103.subtitle_link_path ~= "" then
		local v1384, v1385 = proto.writeTag(buf, n68, 9, proto.wireTypes.lengthDelimited)

		buf, n68 = proto.writeString(v1384, v1385, p103.subtitle_link_path)
	end

	if p103.is_placeholder ~= nil then
		local v1386, v1387 = proto.writeTag(buf, n68, 10, proto.wireTypes.varint)

		buf, n68 = proto.writeVarInt(v1386, v1387, not p103.is_placeholder and 0 or 1)
	end

	if p103.primary_sort_id ~= nil then
		local v1388, v1389 = proto.writeTag(buf, n68, 11, proto.wireTypes.varint)

		buf, n68 = proto.writeVarInt(v1388, v1389, p103.primary_sort_id)
	end

	if p103.applied_filters ~= nil then
		local v1390, v1391 = proto.writeTag(buf, n68, 12, proto.wireTypes.lengthDelimited)

		buf, n68 = proto.writeString(v1390, v1391, p103.applied_filters)
	end

	if p103.pool_id ~= nil then
		local v1392, v1393 = proto.writeTag(buf, n68, 13, proto.wireTypes.lengthDelimited)

		buf, n68 = proto.writeString(v1392, v1393, p103.pool_id)
	end

	if p103.has_emphasized_tile then
		local v1394, v1395 = proto.writeTag(buf, n68, 14, proto.wireTypes.varint)

		buf, n68 = proto.writeVarInt(v1394, v1395, not p103.has_emphasized_tile and 0 or 1)
	end

	local buf38 = buffer.create(n68)

	buffer.copy(buf38, 0, buf, 0, n68)

	return buf38
end
function t159.decode(p104: buffer) -- line: 9972
	-- upvalues: t159 (copy), proto (copy), t1 (copy)
	local v1398 = t159.new()
	local n69 = 0

	while n69 < buffer.len(p104) do
		local v1400, v1401

		v1400, v1401, n69 = proto.readTag(p104, n69)

		if v1401 == proto.wireTypes.varint then
			if v1400 == 5 then
				local v1402

				v1402, n69 = proto.readVarIntI32(p104, n69)
				v1398.secondary_sort_id = v1402
			elseif v1400 == 6 then
				local v1403

				v1403, n69 = proto.readVarIntI32(p104, n69)
				v1398.max_visible_rows = v1403
			elseif v1400 == 10 then
				local v1404

				v1404, n69 = proto.readVarInt(p104, n69)
				v1398.is_placeholder = v1404 ~= 0
			elseif v1400 == 11 then
				local v1405

				v1405, n69 = proto.readVarIntI32(p104, n69)
				v1398.primary_sort_id = v1405
			elseif v1400 == 14 then
				local v1406

				v1406, n69 = proto.readVarInt(p104, n69)
				v1398.has_emphasized_tile = v1406 ~= 0
			else
				local v1407

				v1407, n69 = proto.readVarInt(p104, n69)
			end
		elseif v1401 == proto.wireTypes.lengthDelimited then
			if v1400 == 1 then
				local v1408

				v1408, n69 = proto.readBuffer(p104, n69)
				v1398.title = buffer.tostring(v1408)
			elseif v1400 == 2 then
				local v1409

				v1409, n69 = proto.readBuffer(p104, n69)
				table.insert(v1398.universe_items, t1.ExperienceCarouselInputData_UniverseItem.decode(v1409))
			elseif v1400 == 3 then
				local v1410

				v1410, n69 = proto.readBuffer(p104, n69)
				v1398.next_page_token = buffer.tostring(v1410)
			elseif v1400 == 4 then
				local v1411

				v1411, n69 = proto.readBuffer(p104, n69)
				v1398.sort_id = buffer.tostring(v1411)
			elseif v1400 == 7 then
				local v1412

				v1412, n69 = proto.readBuffer(p104, n69)
				v1398.subtitle = buffer.tostring(v1412)
			elseif v1400 == 8 then
				local v1413

				v1413, n69 = proto.readBuffer(p104, n69)
				v1398.info_text = buffer.tostring(v1413)
			elseif v1400 == 9 then
				local v1414

				v1414, n69 = proto.readBuffer(p104, n69)
				v1398.subtitle_link_path = buffer.tostring(v1414)
			elseif v1400 == 12 then
				local v1415

				v1415, n69 = proto.readBuffer(p104, n69)
				v1398.applied_filters = buffer.tostring(v1415)
			elseif v1400 == 13 then
				local v1416

				v1416, n69 = proto.readBuffer(p104, n69)
				v1398.pool_id = buffer.tostring(v1416)
			else
				local v1417, v1418 = proto.readVarInt(p104, n69)

				n69 = v1418 + v1417
			end
		elseif v1401 == proto.wireTypes.i32 then
			local v1419

			v1419, n69 = proto.readFixed32(p104, n69)
		elseif v1401 == proto.wireTypes.i64 then
			local v1420

			v1420, n69 = proto.readFixed64(p104, n69)
		else
			error("Unsupported wire type: " .. v1401)
		end
	end

	return v1398
end
function t159.jsonEncode(p105) -- line: 10080
	local t161 = {}

	if p105.title ~= nil and p105.title ~= "" then
		t161.title = p105.title
	end

	if p105.universe_items ~= nil and #p105.universe_items > 0 then
		local t162 = {}

		for _, v1425 in p105.universe_items do
			table.insert(t162, v1425:jsonEncode())
		end

		t161.universeItems = t162
	end

	if p105.next_page_token ~= nil and p105.next_page_token ~= "" then
		t161.nextPageToken = p105.next_page_token
	end

	if p105.sort_id ~= nil and p105.sort_id ~= "" then
		t161.sortId = p105.sort_id
	end

	if p105.secondary_sort_id ~= nil and p105.secondary_sort_id ~= 0 then
		t161.secondarySortId = p105.secondary_sort_id
	end

	if p105.max_visible_rows ~= nil and p105.max_visible_rows ~= 0 then
		t161.maxVisibleRows = p105.max_visible_rows
	end

	if p105.subtitle ~= nil and p105.subtitle ~= "" then
		t161.subtitle = p105.subtitle
	end

	if p105.info_text ~= nil and p105.info_text ~= "" then
		t161.infoText = p105.info_text
	end

	if p105.subtitle_link_path ~= nil and p105.subtitle_link_path ~= "" then
		t161.subtitleLinkPath = p105.subtitle_link_path
	end

	if p105.is_placeholder ~= nil then
		t161.isPlaceholder = p105.is_placeholder
	end

	if p105.primary_sort_id ~= nil then
		t161.primarySortId = p105.primary_sort_id
	end

	if p105.applied_filters ~= nil then
		t161.appliedFilters = p105.applied_filters
	end

	if p105.pool_id ~= nil then
		t161.poolId = p105.pool_id
	end

	if p105.has_emphasized_tile then
		t161.hasEmphasizedTile = p105.has_emphasized_tile
	end

	return t161
end
function t159.jsonDecode(t163: {[any]: any}) -- line: 10146
	-- upvalues: t159 (copy), t1 (copy)
	local v1427 = t159.new()

	if t163.title ~= nil then
		v1427.title = t163.title
	end

	if t163.universe_items ~= nil then
		local t164 = {}

		for _, v1430 in t163.universe_items do
			table.insert(t164, t1.ExperienceCarouselInputData_UniverseItem.jsonDecode(v1430))
		end

		v1427.universe_items = t164
	end

	if t163.universeItems ~= nil then
		local t165 = {}

		for _, v1433 in t163.universeItems do
			table.insert(t165, t1.ExperienceCarouselInputData_UniverseItem.jsonDecode(v1433))
		end

		v1427.universe_items = t165
	end

	if t163.next_page_token ~= nil then
		v1427.next_page_token = t163.next_page_token
	end

	if t163.nextPageToken ~= nil then
		v1427.next_page_token = t163.nextPageToken
	end

	if t163.sort_id ~= nil then
		v1427.sort_id = t163.sort_id
	end

	if t163.sortId ~= nil then
		v1427.sort_id = t163.sortId
	end

	if t163.secondary_sort_id ~= nil then
		v1427.secondary_sort_id = t163.secondary_sort_id
	end

	if t163.secondarySortId ~= nil then
		v1427.secondary_sort_id = t163.secondarySortId
	end

	if t163.max_visible_rows ~= nil then
		v1427.max_visible_rows = t163.max_visible_rows
	end

	if t163.maxVisibleRows ~= nil then
		v1427.max_visible_rows = t163.maxVisibleRows
	end

	if t163.subtitle ~= nil then
		v1427.subtitle = t163.subtitle
	end

	if t163.info_text ~= nil then
		v1427.info_text = t163.info_text
	end

	if t163.infoText ~= nil then
		v1427.info_text = t163.infoText
	end

	if t163.subtitle_link_path ~= nil then
		v1427.subtitle_link_path = t163.subtitle_link_path
	end

	if t163.subtitleLinkPath ~= nil then
		v1427.subtitle_link_path = t163.subtitleLinkPath
	end

	if t163.is_placeholder ~= nil then
		v1427.is_placeholder = t163.is_placeholder
	end

	if t163.isPlaceholder ~= nil then
		v1427.is_placeholder = t163.isPlaceholder
	end

	if t163.primary_sort_id ~= nil then
		v1427.primary_sort_id = t163.primary_sort_id
	end

	if t163.primarySortId ~= nil then
		v1427.primary_sort_id = t163.primarySortId
	end

	if t163.applied_filters ~= nil then
		v1427.applied_filters = t163.applied_filters
	end

	if t163.appliedFilters ~= nil then
		v1427.applied_filters = t163.appliedFilters
	end

	if t163.pool_id ~= nil then
		v1427.pool_id = t163.pool_id
	end

	if t163.poolId ~= nil then
		v1427.pool_id = t163.poolId
	end

	if t163.has_emphasized_tile ~= nil then
		v1427.has_emphasized_tile = t163.has_emphasized_tile
	end

	if t163.hasEmphasizedTile ~= nil then
		v1427.has_emphasized_tile = t163.hasEmphasizedTile
	end

	return v1427
end

t159.descriptor = {
	name = "ExperienceCarouselInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceCarouselInputData"
}
t1.ExperienceCarouselInputData = t159
typeRegistry.default:register(t1.ExperienceCarouselInputData)

local t166 = {}

t166.__index = t166

function t166.new(t167: {[any]: any}?) -- line: 10280
	-- upvalues: t166 (copy)
	return (setmetatable({
		universe_id = if t167 ~= nil and t167.universe_id ~= nil then t167.universe_id else "",
		is_sponsored = t167 ~= nil and (t167.is_sponsored ~= nil and t167.is_sponsored),
		roblox_component = if t167 ~= nil and t167.roblox_component ~= nil then t167.roblox_component else "",
		native_ad_data = if t167 ~= nil and t167.native_ad_data ~= nil then t167.native_ad_data else "",
		is_content_locked = t167 ~= nil and (t167.is_content_locked ~= nil and t167.is_content_locked),
		title = if t167 ~= nil and t167.title ~= nil then t167.title else "",
		subtitle = if t167 ~= nil and t167.subtitle ~= nil then t167.subtitle else "",
		image_asset_id = if t167 ~= nil and t167.image_asset_id ~= nil then t167.image_asset_id else "",
		video_asset_id = if t167 ~= nil and t167.video_asset_id ~= nil then t167.video_asset_id else "",
		badge_text = if t167 ~= nil and t167.badge_text ~= nil then t167.badge_text else "",
		player_count = if t167 ~= nil and t167.player_count ~= nil then t167.player_count else nil,
		creator_key = if t167 ~= nil and t167.creator_key ~= nil then t167.creator_key else ""
	}, t166))
end
function t166.encode(p106) -- line: 10299
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n70 = 0

	if p106.universe_id ~= nil and p106.universe_id ~= "" then
		local v1438, v1439 = proto.writeTag(buf, n70, 1, proto.wireTypes.lengthDelimited)

		buf, n70 = proto.writeString(v1438, v1439, p106.universe_id)
	end

	if p106.is_sponsored then
		local v1440, v1441 = proto.writeTag(buf, n70, 2, proto.wireTypes.varint)

		buf, n70 = proto.writeVarInt(v1440, v1441, not p106.is_sponsored and 0 or 1)
	end

	if p106.roblox_component ~= nil and p106.roblox_component ~= "" then
		local v1442, v1443 = proto.writeTag(buf, n70, 3, proto.wireTypes.lengthDelimited)

		buf, n70 = proto.writeString(v1442, v1443, p106.roblox_component)
	end

	if p106.native_ad_data ~= nil and p106.native_ad_data ~= "" then
		local v1444, v1445 = proto.writeTag(buf, n70, 4, proto.wireTypes.lengthDelimited)

		buf, n70 = proto.writeString(v1444, v1445, p106.native_ad_data)
	end

	if p106.is_content_locked then
		local v1446, v1447 = proto.writeTag(buf, n70, 5, proto.wireTypes.varint)

		buf, n70 = proto.writeVarInt(v1446, v1447, not p106.is_content_locked and 0 or 1)
	end

	if p106.title ~= nil and p106.title ~= "" then
		local v1448, v1449 = proto.writeTag(buf, n70, 6, proto.wireTypes.lengthDelimited)

		buf, n70 = proto.writeString(v1448, v1449, p106.title)
	end

	if p106.subtitle ~= nil and p106.subtitle ~= "" then
		local v1450, v1451 = proto.writeTag(buf, n70, 7, proto.wireTypes.lengthDelimited)

		buf, n70 = proto.writeString(v1450, v1451, p106.subtitle)
	end

	if p106.image_asset_id ~= nil and p106.image_asset_id ~= "" then
		local v1452, v1453 = proto.writeTag(buf, n70, 8, proto.wireTypes.lengthDelimited)

		buf, n70 = proto.writeString(v1452, v1453, p106.image_asset_id)
	end

	if p106.video_asset_id ~= nil and p106.video_asset_id ~= "" then
		local v1454, v1455 = proto.writeTag(buf, n70, 9, proto.wireTypes.lengthDelimited)

		buf, n70 = proto.writeString(v1454, v1455, p106.video_asset_id)
	end

	if p106.badge_text ~= nil and p106.badge_text ~= "" then
		local v1456, v1457 = proto.writeTag(buf, n70, 10, proto.wireTypes.lengthDelimited)

		buf, n70 = proto.writeString(v1456, v1457, p106.badge_text)
	end

	if p106.player_count ~= nil then
		local v1458, v1459 = proto.writeTag(buf, n70, 11, proto.wireTypes.varint)

		buf, n70 = proto.writeVarInt(v1458, v1459, p106.player_count)
	end

	if p106.creator_key ~= nil and p106.creator_key ~= "" then
		local v1460, v1461 = proto.writeTag(buf, n70, 12, proto.wireTypes.lengthDelimited)

		buf, n70 = proto.writeString(v1460, v1461, p106.creator_key)
	end

	local buf39 = buffer.create(n70)

	buffer.copy(buf39, 0, buf, 0, n70)

	return buf39
end
function t166.decode(p107: buffer) -- line: 10370
	-- upvalues: t166 (copy), proto (copy)
	local v1464 = t166.new()
	local n71 = 0

	while n71 < buffer.len(p107) do
		local v1466, v1467

		v1466, v1467, n71 = proto.readTag(p107, n71)

		if v1467 == proto.wireTypes.varint then
			if v1466 == 2 then
				local v1468

				v1468, n71 = proto.readVarInt(p107, n71)
				v1464.is_sponsored = v1468 ~= 0
			elseif v1466 == 5 then
				local v1469

				v1469, n71 = proto.readVarInt(p107, n71)
				v1464.is_content_locked = v1469 ~= 0
			elseif v1466 == 11 then
				local v1470

				v1470, n71 = proto.readVarIntI64(p107, n71)
				v1464.player_count = v1470
			else
				local v1471

				v1471, n71 = proto.readVarInt(p107, n71)
			end
		elseif v1467 == proto.wireTypes.lengthDelimited then
			if v1466 == 1 then
				local v1472

				v1472, n71 = proto.readBuffer(p107, n71)
				v1464.universe_id = buffer.tostring(v1472)
			elseif v1466 == 3 then
				local v1473

				v1473, n71 = proto.readBuffer(p107, n71)
				v1464.roblox_component = buffer.tostring(v1473)
			elseif v1466 == 4 then
				local v1474

				v1474, n71 = proto.readBuffer(p107, n71)
				v1464.native_ad_data = buffer.tostring(v1474)
			elseif v1466 == 6 then
				local v1475

				v1475, n71 = proto.readBuffer(p107, n71)
				v1464.title = buffer.tostring(v1475)
			elseif v1466 == 7 then
				local v1476

				v1476, n71 = proto.readBuffer(p107, n71)
				v1464.subtitle = buffer.tostring(v1476)
			elseif v1466 == 8 then
				local v1477

				v1477, n71 = proto.readBuffer(p107, n71)
				v1464.image_asset_id = buffer.tostring(v1477)
			elseif v1466 == 9 then
				local v1478

				v1478, n71 = proto.readBuffer(p107, n71)
				v1464.video_asset_id = buffer.tostring(v1478)
			elseif v1466 == 10 then
				local v1479

				v1479, n71 = proto.readBuffer(p107, n71)
				v1464.badge_text = buffer.tostring(v1479)
			elseif v1466 == 12 then
				local v1480

				v1480, n71 = proto.readBuffer(p107, n71)
				v1464.creator_key = buffer.tostring(v1480)
			else
				local v1481, v1482 = proto.readVarInt(p107, n71)

				n71 = v1482 + v1481
			end
		elseif v1467 == proto.wireTypes.i32 then
			local v1483

			v1483, n71 = proto.readFixed32(p107, n71)
		elseif v1467 == proto.wireTypes.i64 then
			local v1484

			v1484, n71 = proto.readFixed64(p107, n71)
		else
			error("Unsupported wire type: " .. v1467)
		end
	end

	return v1464
end
function t166.jsonEncode(p108) -- line: 10470
	local t168 = {}

	if p108.universe_id ~= nil and p108.universe_id ~= "" then
		t168.universeId = p108.universe_id
	end

	if p108.is_sponsored then
		t168.isSponsored = p108.is_sponsored
	end

	if p108.roblox_component ~= nil and p108.roblox_component ~= "" then
		t168.robloxComponent = p108.roblox_component
	end

	if p108.native_ad_data ~= nil and p108.native_ad_data ~= "" then
		t168.nativeAdData = p108.native_ad_data
	end

	if p108.is_content_locked then
		t168.isContentLocked = p108.is_content_locked
	end

	if p108.title ~= nil and p108.title ~= "" then
		t168.title = p108.title
	end

	if p108.subtitle ~= nil and p108.subtitle ~= "" then
		t168.subtitle = p108.subtitle
	end

	if p108.image_asset_id ~= nil and p108.image_asset_id ~= "" then
		t168.imageAssetId = p108.image_asset_id
	end

	if p108.video_asset_id ~= nil and p108.video_asset_id ~= "" then
		t168.videoAssetId = p108.video_asset_id
	end

	if p108.badge_text ~= nil and p108.badge_text ~= "" then
		t168.badgeText = p108.badge_text
	end

	if p108.player_count ~= nil then
		t168.playerCount = p108.player_count
	end

	if p108.creator_key ~= nil and p108.creator_key ~= "" then
		t168.creatorKey = p108.creator_key
	end

	return t168
end
function t166.jsonDecode(t169: {[any]: any}) -- line: 10526
	-- upvalues: t166 (copy)
	local v1488 = t166.new()

	if t169.universe_id ~= nil then
		v1488.universe_id = t169.universe_id
	end

	if t169.universeId ~= nil then
		v1488.universe_id = t169.universeId
	end

	if t169.is_sponsored ~= nil then
		v1488.is_sponsored = t169.is_sponsored
	end

	if t169.isSponsored ~= nil then
		v1488.is_sponsored = t169.isSponsored
	end

	if t169.roblox_component ~= nil then
		v1488.roblox_component = t169.roblox_component
	end

	if t169.robloxComponent ~= nil then
		v1488.roblox_component = t169.robloxComponent
	end

	if t169.native_ad_data ~= nil then
		v1488.native_ad_data = t169.native_ad_data
	end

	if t169.nativeAdData ~= nil then
		v1488.native_ad_data = t169.nativeAdData
	end

	if t169.is_content_locked ~= nil then
		v1488.is_content_locked = t169.is_content_locked
	end

	if t169.isContentLocked ~= nil then
		v1488.is_content_locked = t169.isContentLocked
	end

	if t169.title ~= nil then
		v1488.title = t169.title
	end

	if t169.subtitle ~= nil then
		v1488.subtitle = t169.subtitle
	end

	if t169.image_asset_id ~= nil then
		v1488.image_asset_id = t169.image_asset_id
	end

	if t169.imageAssetId ~= nil then
		v1488.image_asset_id = t169.imageAssetId
	end

	if t169.video_asset_id ~= nil then
		v1488.video_asset_id = t169.video_asset_id
	end

	if t169.videoAssetId ~= nil then
		v1488.video_asset_id = t169.videoAssetId
	end

	if t169.badge_text ~= nil then
		v1488.badge_text = t169.badge_text
	end

	if t169.badgeText ~= nil then
		v1488.badge_text = t169.badgeText
	end

	if t169.player_count ~= nil then
		v1488.player_count = t169.player_count
	end

	if t169.playerCount ~= nil then
		v1488.player_count = t169.playerCount
	end

	if t169.creator_key ~= nil then
		v1488.creator_key = t169.creator_key
	end

	if t169.creatorKey ~= nil then
		v1488.creator_key = t169.creatorKey
	end

	return v1488
end

t166.descriptor = {
	name = "ExperienceCarouselInputData_UniverseItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniverseItem"
}
t1.ExperienceCarouselInputData_UniverseItem = t166
typeRegistry.default:register(t1.ExperienceCarouselInputData_UniverseItem)

local t170 = {}

t170.__index = t170

function t170.new(t171: {[any]: any}?) -- line: 10636
	-- upvalues: t170 (copy)
	return (setmetatable({
		title = if t171 ~= nil and t171.title ~= nil then t171.title else "",
		song_items = if t171 ~= nil and t171.song_items ~= nil then t171.song_items else {},
		next_page_token = if t171 ~= nil and t171.next_page_token ~= nil then t171.next_page_token else "",
		sort_id = if t171 ~= nil and t171.sort_id ~= nil then t171.sort_id else "",
		secondary_sort_id = if t171 ~= nil and t171.secondary_sort_id ~= nil then t171.secondary_sort_id else 0,
		subtitle = if t171 ~= nil and t171.subtitle ~= nil then t171.subtitle else "",
		info_text = if t171 ~= nil and t171.info_text ~= nil then t171.info_text else "",
		subtitle_link_path = if t171 ~= nil and t171.subtitle_link_path ~= nil then t171.subtitle_link_path else "",
		is_placeholder = if t171 ~= nil and t171.is_placeholder ~= nil then t171.is_placeholder else nil,
		primary_sort_id = if t171 ~= nil and t171.primary_sort_id ~= nil then t171.primary_sort_id else nil,
		applied_filters = if t171 ~= nil and t171.applied_filters ~= nil then t171.applied_filters else nil
	}, t170))
end
function t170.encode(p109) -- line: 10652
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n72 = 0

	if p109.title ~= nil and p109.title ~= "" then
		local v1493, v1494 = proto.writeTag(buf, n72, 1, proto.wireTypes.lengthDelimited)

		buf, n72 = proto.writeString(v1493, v1494, p109.title)
	end

	if p109.song_items ~= nil and #p109.song_items > 0 then
		for _, v1496 in p109.song_items do
			local v1497 = v1496:encode()
			local v1498, v1499 = proto.writeTag(buf, n72, 2, proto.wireTypes.lengthDelimited)

			buf, n72 = proto.writeBuffer(v1498, v1499, v1497, buffer.len(v1497))
		end
	end

	if p109.next_page_token ~= nil and p109.next_page_token ~= "" then
		local v1500, v1501 = proto.writeTag(buf, n72, 3, proto.wireTypes.lengthDelimited)

		buf, n72 = proto.writeString(v1500, v1501, p109.next_page_token)
	end

	if p109.sort_id ~= nil and p109.sort_id ~= "" then
		local v1502, v1503 = proto.writeTag(buf, n72, 4, proto.wireTypes.lengthDelimited)

		buf, n72 = proto.writeString(v1502, v1503, p109.sort_id)
	end

	if p109.secondary_sort_id ~= nil and p109.secondary_sort_id ~= 0 then
		local v1504, v1505 = proto.writeTag(buf, n72, 5, proto.wireTypes.varint)

		buf, n72 = proto.writeVarInt(v1504, v1505, p109.secondary_sort_id)
	end

	if p109.subtitle ~= nil and p109.subtitle ~= "" then
		local v1506, v1507 = proto.writeTag(buf, n72, 6, proto.wireTypes.lengthDelimited)

		buf, n72 = proto.writeString(v1506, v1507, p109.subtitle)
	end

	if p109.info_text ~= nil and p109.info_text ~= "" then
		local v1508, v1509 = proto.writeTag(buf, n72, 7, proto.wireTypes.lengthDelimited)

		buf, n72 = proto.writeString(v1508, v1509, p109.info_text)
	end

	if p109.subtitle_link_path ~= nil and p109.subtitle_link_path ~= "" then
		local v1510, v1511 = proto.writeTag(buf, n72, 8, proto.wireTypes.lengthDelimited)

		buf, n72 = proto.writeString(v1510, v1511, p109.subtitle_link_path)
	end

	if p109.is_placeholder ~= nil then
		local v1512, v1513 = proto.writeTag(buf, n72, 9, proto.wireTypes.varint)

		buf, n72 = proto.writeVarInt(v1512, v1513, not p109.is_placeholder and 0 or 1)
	end

	if p109.primary_sort_id ~= nil then
		local v1514, v1515 = proto.writeTag(buf, n72, 10, proto.wireTypes.varint)

		buf, n72 = proto.writeVarInt(v1514, v1515, p109.primary_sort_id)
	end

	if p109.applied_filters ~= nil then
		local v1516, v1517 = proto.writeTag(buf, n72, 11, proto.wireTypes.lengthDelimited)

		buf, n72 = proto.writeString(v1516, v1517, p109.applied_filters)
	end

	local buf40 = buffer.create(n72)

	buffer.copy(buf40, 0, buf, 0, n72)

	return buf40
end
function t170.decode(p110: buffer) -- line: 10719
	-- upvalues: t170 (copy), proto (copy), t1 (copy)
	local v1520 = t170.new()
	local n73 = 0

	while n73 < buffer.len(p110) do
		local v1522, v1523

		v1522, v1523, n73 = proto.readTag(p110, n73)

		if v1523 == proto.wireTypes.varint then
			if v1522 == 5 then
				local v1524

				v1524, n73 = proto.readVarIntI32(p110, n73)
				v1520.secondary_sort_id = v1524
			elseif v1522 == 9 then
				local v1525

				v1525, n73 = proto.readVarInt(p110, n73)
				v1520.is_placeholder = v1525 ~= 0
			elseif v1522 == 10 then
				local v1526

				v1526, n73 = proto.readVarIntI32(p110, n73)
				v1520.primary_sort_id = v1526
			else
				local v1527

				v1527, n73 = proto.readVarInt(p110, n73)
			end
		elseif v1523 == proto.wireTypes.lengthDelimited then
			if v1522 == 1 then
				local v1528

				v1528, n73 = proto.readBuffer(p110, n73)
				v1520.title = buffer.tostring(v1528)
			elseif v1522 == 2 then
				local v1529

				v1529, n73 = proto.readBuffer(p110, n73)
				table.insert(v1520.song_items, t1.SongCarouselInputData_SongItem.decode(v1529))
			elseif v1522 == 3 then
				local v1530

				v1530, n73 = proto.readBuffer(p110, n73)
				v1520.next_page_token = buffer.tostring(v1530)
			elseif v1522 == 4 then
				local v1531

				v1531, n73 = proto.readBuffer(p110, n73)
				v1520.sort_id = buffer.tostring(v1531)
			elseif v1522 == 6 then
				local v1532

				v1532, n73 = proto.readBuffer(p110, n73)
				v1520.subtitle = buffer.tostring(v1532)
			elseif v1522 == 7 then
				local v1533

				v1533, n73 = proto.readBuffer(p110, n73)
				v1520.info_text = buffer.tostring(v1533)
			elseif v1522 == 8 then
				local v1534

				v1534, n73 = proto.readBuffer(p110, n73)
				v1520.subtitle_link_path = buffer.tostring(v1534)
			elseif v1522 == 11 then
				local v1535

				v1535, n73 = proto.readBuffer(p110, n73)
				v1520.applied_filters = buffer.tostring(v1535)
			else
				local v1536, v1537 = proto.readVarInt(p110, n73)

				n73 = v1537 + v1536
			end
		elseif v1523 == proto.wireTypes.i32 then
			local v1538

			v1538, n73 = proto.readFixed32(p110, n73)
		elseif v1523 == proto.wireTypes.i64 then
			local v1539

			v1539, n73 = proto.readFixed64(p110, n73)
		else
			error("Unsupported wire type: " .. v1523)
		end
	end

	return v1520
end
function t170.jsonEncode(p111) -- line: 10812
	local t172 = {}

	if p111.title ~= nil and p111.title ~= "" then
		t172.title = p111.title
	end

	if p111.song_items ~= nil and #p111.song_items > 0 then
		local t173 = {}

		for _, v1544 in p111.song_items do
			table.insert(t173, v1544:jsonEncode())
		end

		t172.songItems = t173
	end

	if p111.next_page_token ~= nil and p111.next_page_token ~= "" then
		t172.nextPageToken = p111.next_page_token
	end

	if p111.sort_id ~= nil and p111.sort_id ~= "" then
		t172.sortId = p111.sort_id
	end

	if p111.secondary_sort_id ~= nil and p111.secondary_sort_id ~= 0 then
		t172.secondarySortId = p111.secondary_sort_id
	end

	if p111.subtitle ~= nil and p111.subtitle ~= "" then
		t172.subtitle = p111.subtitle
	end

	if p111.info_text ~= nil and p111.info_text ~= "" then
		t172.infoText = p111.info_text
	end

	if p111.subtitle_link_path ~= nil and p111.subtitle_link_path ~= "" then
		t172.subtitleLinkPath = p111.subtitle_link_path
	end

	if p111.is_placeholder ~= nil then
		t172.isPlaceholder = p111.is_placeholder
	end

	if p111.primary_sort_id ~= nil then
		t172.primarySortId = p111.primary_sort_id
	end

	if p111.applied_filters ~= nil then
		t172.appliedFilters = p111.applied_filters
	end

	return t172
end
function t170.jsonDecode(t174: {[any]: any}) -- line: 10866
	-- upvalues: t170 (copy), t1 (copy)
	local v1546 = t170.new()

	if t174.title ~= nil then
		v1546.title = t174.title
	end

	if t174.song_items ~= nil then
		local t175 = {}

		for _, v1549 in t174.song_items do
			table.insert(t175, t1.SongCarouselInputData_SongItem.jsonDecode(v1549))
		end

		v1546.song_items = t175
	end

	if t174.songItems ~= nil then
		local t176 = {}

		for _, v1552 in t174.songItems do
			table.insert(t176, t1.SongCarouselInputData_SongItem.jsonDecode(v1552))
		end

		v1546.song_items = t176
	end

	if t174.next_page_token ~= nil then
		v1546.next_page_token = t174.next_page_token
	end

	if t174.nextPageToken ~= nil then
		v1546.next_page_token = t174.nextPageToken
	end

	if t174.sort_id ~= nil then
		v1546.sort_id = t174.sort_id
	end

	if t174.sortId ~= nil then
		v1546.sort_id = t174.sortId
	end

	if t174.secondary_sort_id ~= nil then
		v1546.secondary_sort_id = t174.secondary_sort_id
	end

	if t174.secondarySortId ~= nil then
		v1546.secondary_sort_id = t174.secondarySortId
	end

	if t174.subtitle ~= nil then
		v1546.subtitle = t174.subtitle
	end

	if t174.info_text ~= nil then
		v1546.info_text = t174.info_text
	end

	if t174.infoText ~= nil then
		v1546.info_text = t174.infoText
	end

	if t174.subtitle_link_path ~= nil then
		v1546.subtitle_link_path = t174.subtitle_link_path
	end

	if t174.subtitleLinkPath ~= nil then
		v1546.subtitle_link_path = t174.subtitleLinkPath
	end

	if t174.is_placeholder ~= nil then
		v1546.is_placeholder = t174.is_placeholder
	end

	if t174.isPlaceholder ~= nil then
		v1546.is_placeholder = t174.isPlaceholder
	end

	if t174.primary_sort_id ~= nil then
		v1546.primary_sort_id = t174.primary_sort_id
	end

	if t174.primarySortId ~= nil then
		v1546.primary_sort_id = t174.primarySortId
	end

	if t174.applied_filters ~= nil then
		v1546.applied_filters = t174.applied_filters
	end

	if t174.appliedFilters ~= nil then
		v1546.applied_filters = t174.appliedFilters
	end

	return v1546
end

t170.descriptor = {
	name = "SongCarouselInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.SongCarouselInputData"
}
t1.SongCarouselInputData = t170
typeRegistry.default:register(t1.SongCarouselInputData)

local t177 = {}

t177.__index = t177

function t177.new(t178: {[any]: any}?) -- line: 10976
	-- upvalues: t177 (copy)
	return (setmetatable({
		song_id = if t178 ~= nil and t178.song_id ~= nil then t178.song_id else ""
	}, t177))
end
function t177.encode(p112) -- line: 10984
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n74 = 0

	if p112.song_id ~= nil and p112.song_id ~= "" then
		local v1557, v1558 = proto.writeTag(buf, n74, 1, proto.wireTypes.lengthDelimited)

		buf, n74 = proto.writeString(v1557, v1558, p112.song_id)
	end

	local buf41 = buffer.create(n74)

	buffer.copy(buf41, 0, buf, 0, n74)

	return buf41
end
function t177.decode(p113: buffer) -- line: 10998
	-- upvalues: t177 (copy), proto (copy)
	local v1561 = t177.new()
	local n75 = 0

	while n75 < buffer.len(p113) do
		local v1563, v1564

		v1563, v1564, n75 = proto.readTag(p113, n75)

		if v1564 == proto.wireTypes.varint then
			local v1565

			v1565, n75 = proto.readVarInt(p113, n75)
		elseif v1564 == proto.wireTypes.lengthDelimited then
			if v1563 == 1 then
				local v1566

				v1566, n75 = proto.readBuffer(p113, n75)
				v1561.song_id = buffer.tostring(v1566)
			else
				local v1567, v1568 = proto.readVarInt(p113, n75)

				n75 = v1568 + v1567
			end
		elseif v1564 == proto.wireTypes.i32 then
			local v1569

			v1569, n75 = proto.readFixed32(p113, n75)
		elseif v1564 == proto.wireTypes.i64 then
			local v1570

			v1570, n75 = proto.readFixed64(p113, n75)
		else
			error("Unsupported wire type: " .. v1564)
		end
	end

	return v1561
end
function t177.jsonEncode(p114) -- line: 11041
	local t179 = {}

	if p114.song_id ~= nil and p114.song_id ~= "" then
		t179.songId = p114.song_id
	end

	return t179
end
function t177.jsonDecode(t180: {[any]: any}) -- line: 11051
	-- upvalues: t177 (copy)
	local v1574 = t177.new()

	if t180.song_id ~= nil then
		v1574.song_id = t180.song_id
	end

	if t180.songId ~= nil then
		v1574.song_id = t180.songId
	end

	return v1574
end

t177.descriptor = {
	name = "SongCarouselInputData_SongItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.SongItem"
}
t1.SongCarouselInputData_SongItem = t177
typeRegistry.default:register(t1.SongCarouselInputData_SongItem)

local t181 = {}

t181.__index = t181

function t181.new(t182: {[any]: any}?) -- line: 11079
	-- upvalues: t181 (copy)
	return (setmetatable({
		title = if t182 ~= nil and t182.title ~= nil then t182.title else "",
		event_items = if t182 ~= nil and t182.event_items ~= nil then t182.event_items else {},
		universe_id = if t182 ~= nil and t182.universe_id ~= nil then t182.universe_id else "",
		sort_id = if t182 ~= nil and t182.sort_id ~= nil then t182.sort_id else "",
		subtitle = if t182 ~= nil and t182.subtitle ~= nil then t182.subtitle else "",
		info_text = if t182 ~= nil and t182.info_text ~= nil then t182.info_text else ""
	}, t181))
end
function t181.encode(p115) -- line: 11090
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n76 = 0

	if p115.title ~= nil and p115.title ~= "" then
		local v1579, v1580 = proto.writeTag(buf, n76, 1, proto.wireTypes.lengthDelimited)

		buf, n76 = proto.writeString(v1579, v1580, p115.title)
	end

	if p115.event_items ~= nil and #p115.event_items > 0 then
		for _, v1582 in p115.event_items do
			local v1583 = v1582:encode()
			local v1584, v1585 = proto.writeTag(buf, n76, 2, proto.wireTypes.lengthDelimited)

			buf, n76 = proto.writeBuffer(v1584, v1585, v1583, buffer.len(v1583))
		end
	end

	if p115.universe_id ~= nil and p115.universe_id ~= "" then
		local v1586, v1587 = proto.writeTag(buf, n76, 3, proto.wireTypes.lengthDelimited)

		buf, n76 = proto.writeString(v1586, v1587, p115.universe_id)
	end

	if p115.sort_id ~= nil and p115.sort_id ~= "" then
		local v1588, v1589 = proto.writeTag(buf, n76, 4, proto.wireTypes.lengthDelimited)

		buf, n76 = proto.writeString(v1588, v1589, p115.sort_id)
	end

	if p115.subtitle ~= nil and p115.subtitle ~= "" then
		local v1590, v1591 = proto.writeTag(buf, n76, 5, proto.wireTypes.lengthDelimited)

		buf, n76 = proto.writeString(v1590, v1591, p115.subtitle)
	end

	if p115.info_text ~= nil and p115.info_text ~= "" then
		local v1592, v1593 = proto.writeTag(buf, n76, 6, proto.wireTypes.lengthDelimited)

		buf, n76 = proto.writeString(v1592, v1593, p115.info_text)
	end

	local buf42 = buffer.create(n76)

	buffer.copy(buf42, 0, buf, 0, n76)

	return buf42
end
function t181.decode(p116: buffer) -- line: 11132
	-- upvalues: t181 (copy), proto (copy), t1 (copy)
	local v1596 = t181.new()
	local n77 = 0

	while n77 < buffer.len(p116) do
		local v1598, v1599

		v1598, v1599, n77 = proto.readTag(p116, n77)

		if v1599 == proto.wireTypes.varint then
			local v1600

			v1600, n77 = proto.readVarInt(p116, n77)
		elseif v1599 == proto.wireTypes.lengthDelimited then
			if v1598 == 1 then
				local v1601

				v1601, n77 = proto.readBuffer(p116, n77)
				v1596.title = buffer.tostring(v1601)
			elseif v1598 == 2 then
				local v1602

				v1602, n77 = proto.readBuffer(p116, n77)
				table.insert(v1596.event_items, t1.EventsCarouselInputData_EventItem.decode(v1602))
			elseif v1598 == 3 then
				local v1603

				v1603, n77 = proto.readBuffer(p116, n77)
				v1596.universe_id = buffer.tostring(v1603)
			elseif v1598 == 4 then
				local v1604

				v1604, n77 = proto.readBuffer(p116, n77)
				v1596.sort_id = buffer.tostring(v1604)
			elseif v1598 == 5 then
				local v1605

				v1605, n77 = proto.readBuffer(p116, n77)
				v1596.subtitle = buffer.tostring(v1605)
			elseif v1598 == 6 then
				local v1606

				v1606, n77 = proto.readBuffer(p116, n77)
				v1596.info_text = buffer.tostring(v1606)
			else
				local v1607, v1608 = proto.readVarInt(p116, n77)

				n77 = v1608 + v1607
			end
		elseif v1599 == proto.wireTypes.i32 then
			local v1609

			v1609, n77 = proto.readFixed32(p116, n77)
		elseif v1599 == proto.wireTypes.i64 then
			local v1610

			v1610, n77 = proto.readFixed64(p116, n77)
		else
			error("Unsupported wire type: " .. v1599)
		end
	end

	return v1596
end
function t181.jsonEncode(p117) -- line: 11200
	local t183 = {}

	if p117.title ~= nil and p117.title ~= "" then
		t183.title = p117.title
	end

	if p117.event_items ~= nil and #p117.event_items > 0 then
		local t184 = {}

		for _, v1615 in p117.event_items do
			table.insert(t184, v1615:jsonEncode())
		end

		t183.eventItems = t184
	end

	if p117.universe_id ~= nil and p117.universe_id ~= "" then
		t183.universeId = p117.universe_id
	end

	if p117.sort_id ~= nil and p117.sort_id ~= "" then
		t183.sortId = p117.sort_id
	end

	if p117.subtitle ~= nil and p117.subtitle ~= "" then
		t183.subtitle = p117.subtitle
	end

	if p117.info_text ~= nil and p117.info_text ~= "" then
		t183.infoText = p117.info_text
	end

	return t183
end
function t181.jsonDecode(t185: {[any]: any}) -- line: 11234
	-- upvalues: t181 (copy), t1 (copy)
	local v1617 = t181.new()

	if t185.title ~= nil then
		v1617.title = t185.title
	end

	if t185.event_items ~= nil then
		local t186 = {}

		for _, v1620 in t185.event_items do
			table.insert(t186, t1.EventsCarouselInputData_EventItem.jsonDecode(v1620))
		end

		v1617.event_items = t186
	end

	if t185.eventItems ~= nil then
		local t187 = {}

		for _, v1623 in t185.eventItems do
			table.insert(t187, t1.EventsCarouselInputData_EventItem.jsonDecode(v1623))
		end

		v1617.event_items = t187
	end

	if t185.universe_id ~= nil then
		v1617.universe_id = t185.universe_id
	end

	if t185.universeId ~= nil then
		v1617.universe_id = t185.universeId
	end

	if t185.sort_id ~= nil then
		v1617.sort_id = t185.sort_id
	end

	if t185.sortId ~= nil then
		v1617.sort_id = t185.sortId
	end

	if t185.subtitle ~= nil then
		v1617.subtitle = t185.subtitle
	end

	if t185.info_text ~= nil then
		v1617.info_text = t185.info_text
	end

	if t185.infoText ~= nil then
		v1617.info_text = t185.infoText
	end

	return v1617
end

t181.descriptor = {
	name = "EventsCarouselInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventsCarouselInputData"
}
t1.EventsCarouselInputData = t181
typeRegistry.default:register(t1.EventsCarouselInputData)

local t188 = {}

t188.__index = t188

function t188.new(t189: {[any]: any}?) -- line: 11304
	-- upvalues: t188 (copy)
	return (setmetatable({
		event_id = if t189 ~= nil and t189.event_id ~= nil then t189.event_id else ""
	}, t188))
end
function t188.encode(p118) -- line: 11312
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n78 = 0

	if p118.event_id ~= nil and p118.event_id ~= "" then
		local v1628, v1629 = proto.writeTag(buf, n78, 1, proto.wireTypes.lengthDelimited)

		buf, n78 = proto.writeString(v1628, v1629, p118.event_id)
	end

	local buf43 = buffer.create(n78)

	buffer.copy(buf43, 0, buf, 0, n78)

	return buf43
end
function t188.decode(p119: buffer) -- line: 11326
	-- upvalues: t188 (copy), proto (copy)
	local v1632 = t188.new()
	local n79 = 0

	while n79 < buffer.len(p119) do
		local v1634, v1635

		v1634, v1635, n79 = proto.readTag(p119, n79)

		if v1635 == proto.wireTypes.varint then
			local v1636

			v1636, n79 = proto.readVarInt(p119, n79)
		elseif v1635 == proto.wireTypes.lengthDelimited then
			if v1634 == 1 then
				local v1637

				v1637, n79 = proto.readBuffer(p119, n79)
				v1632.event_id = buffer.tostring(v1637)
			else
				local v1638, v1639 = proto.readVarInt(p119, n79)

				n79 = v1639 + v1638
			end
		elseif v1635 == proto.wireTypes.i32 then
			local v1640

			v1640, n79 = proto.readFixed32(p119, n79)
		elseif v1635 == proto.wireTypes.i64 then
			local v1641

			v1641, n79 = proto.readFixed64(p119, n79)
		else
			error("Unsupported wire type: " .. v1635)
		end
	end

	return v1632
end
function t188.jsonEncode(p120) -- line: 11369
	local t190 = {}

	if p120.event_id ~= nil and p120.event_id ~= "" then
		t190.eventId = p120.event_id
	end

	return t190
end
function t188.jsonDecode(t191: {[any]: any}) -- line: 11379
	-- upvalues: t188 (copy)
	local v1645 = t188.new()

	if t191.event_id ~= nil then
		v1645.event_id = t191.event_id
	end

	if t191.eventId ~= nil then
		v1645.event_id = t191.eventId
	end

	return v1645
end

t188.descriptor = {
	name = "EventsCarouselInputData_EventItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventItem"
}
t1.EventsCarouselInputData_EventItem = t188
typeRegistry.default:register(t1.EventsCarouselInputData_EventItem)

local t192 = {}

t192.__index = t192

function t192.new(t193: {[any]: any}?) -- line: 11409
	-- upvalues: t192 (copy)
	return (setmetatable({
		universe_id = if t193 ~= nil and t193.universe_id ~= nil then t193.universe_id else "",
		entry_map = if t193 ~= nil and t193.entry_map ~= nil then t193.entry_map else {},
		entry_order = if t193 ~= nil and t193.entry_order ~= nil then t193.entry_order else {},
		creator_key = if t193 ~= nil and t193.creator_key ~= nil then t193.creator_key else ""
	}, t192))
end
function t192.encode(p121) -- line: 11418
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n80 = 0

	if p121.universe_id ~= nil and p121.universe_id ~= "" then
		local v1650, v1651 = proto.writeTag(buf, n80, 1, proto.wireTypes.lengthDelimited)

		buf, n80 = proto.writeString(v1650, v1651, p121.universe_id)
	end

	if p121.entry_map ~= nil and next(p121.entry_map) ~= nil then
		for v1652, v1653 in p121.entry_map do
			local buf44 = buffer.create(0)
			local v1655, v1656 = proto.writeTag(buf44, 0, 1, proto.wireTypes.lengthDelimited)
			local v1657, v1658 = proto.writeString(v1655, v1656, v1652)
			local v1659 = v1653:encode()
			local v1660, v1661 = proto.writeTag(v1657, v1658, 2, proto.wireTypes.lengthDelimited)
			local v1662, v1663 = proto.writeBuffer(v1660, v1661, v1659, buffer.len(v1659))
			local v1664, v1665 = proto.writeTag(buf, n80, 2, proto.wireTypes.lengthDelimited)

			buf, n80 = proto.writeBuffer(v1664, v1665, v1662, v1663)
		end
	end

	if p121.entry_order ~= nil and #p121.entry_order > 0 then
		for _, v1667 in p121.entry_order do
			local v1668, v1669 = proto.writeTag(buf, n80, 3, proto.wireTypes.lengthDelimited)

			buf, n80 = proto.writeString(v1668, v1669, v1667)
		end
	end

	if p121.creator_key ~= nil and p121.creator_key ~= "" then
		local v1670, v1671 = proto.writeTag(buf, n80, 4, proto.wireTypes.lengthDelimited)

		buf, n80 = proto.writeString(v1670, v1671, p121.creator_key)
	end

	local buf45 = buffer.create(n80)

	buffer.copy(buf45, 0, buf, 0, n80)

	return buf45
end
function t192.decode(p122: buffer) -- line: 11458
	-- upvalues: t192 (copy), proto (copy), t1 (copy)
	local v1674 = t192.new()
	local n81 = 0

	while n81 < buffer.len(p122) do
		local v1676, v1677

		v1676, v1677, n81 = proto.readTag(p122, n81)

		if v1677 == proto.wireTypes.varint then
			local v1678

			v1678, n81 = proto.readVarInt(p122, n81)
		elseif v1677 == proto.wireTypes.lengthDelimited then
			if v1676 == 1 then
				local v1679

				v1679, n81 = proto.readBuffer(p122, n81)
				v1674.universe_id = buffer.tostring(v1679)
			elseif v1676 == 2 then
				local v1680

				v1680, n81 = proto.readBuffer(p122, n81)

				local v1681 = t1.DevStoreFeedInputData_EntryMapEntry.decode(v1680)
				local v1682 = t1.FeedEntry.new()

				v1674.entry_map[v1681.key or ""] = v1681.value or v1682
			elseif v1676 == 3 then
				local v1683

				v1683, n81 = proto.readBuffer(p122, n81)
				table.insert(v1674.entry_order, buffer.tostring(v1683))
			elseif v1676 == 4 then
				local v1684

				v1684, n81 = proto.readBuffer(p122, n81)
				v1674.creator_key = buffer.tostring(v1684)
			else
				local v1685, v1686 = proto.readVarInt(p122, n81)

				n81 = v1686 + v1685
			end
		elseif v1677 == proto.wireTypes.i32 then
			local v1687

			v1687, n81 = proto.readFixed32(p122, n81)
		elseif v1677 == proto.wireTypes.i64 then
			local v1688

			v1688, n81 = proto.readFixed64(p122, n81)
		else
			error("Unsupported wire type: " .. v1677)
		end
	end

	return v1674
end
function t192.jsonEncode(p123) -- line: 11523
	local t194 = {}

	if p123.universe_id ~= nil and p123.universe_id ~= "" then
		t194.universeId = p123.universe_id
	end

	if p123.entry_map ~= nil and next(p123.entry_map) ~= nil then
		local t195 = {}

		for v1692, v1693 in p123.entry_map do
			t195[v1692] = v1693:jsonEncode()
		end

		t194.entryMap = t195
	end

	if p123.entry_order ~= nil and #p123.entry_order > 0 then
		local t196 = {}

		for _, v1696 in p123.entry_order do
			table.insert(t196, v1696)
		end

		t194.entryOrder = t196
	end

	if p123.creator_key ~= nil and p123.creator_key ~= "" then
		t194.creatorKey = p123.creator_key
	end

	return t194
end
function t192.jsonDecode(t197: {[any]: any}) -- line: 11553
	-- upvalues: t192 (copy), t1 (copy)
	local v1698 = t192.new()

	if t197.universe_id ~= nil then
		v1698.universe_id = t197.universe_id
	end

	if t197.universeId ~= nil then
		v1698.universe_id = t197.universeId
	end

	if t197.entry_map ~= nil then
		local t198 = {}

		for v1700, v1701 in t197.entry_map do
			t198[v1700] = t1.FeedEntry.jsonDecode(v1701)
		end

		v1698.entry_map = t198
	end

	if t197.entryMap ~= nil then
		local t199 = {}

		for v1703, v1704 in t197.entryMap do
			t199[v1703] = t1.FeedEntry.jsonDecode(v1704)
		end

		v1698.entry_map = t199
	end

	if t197.entry_order ~= nil then
		local t200 = {}

		for _, v1707 in t197.entry_order do
			table.insert(t200, v1707)
		end

		v1698.entry_order = t200
	end

	if t197.entryOrder ~= nil then
		local t201 = {}

		for _, v1710 in t197.entryOrder do
			table.insert(t201, v1710)
		end

		v1698.entry_order = t201
	end

	if t197.creator_key ~= nil then
		v1698.creator_key = t197.creator_key
	end

	if t197.creatorKey ~= nil then
		v1698.creator_key = t197.creatorKey
	end

	return v1698
end

t192.descriptor = {
	name = "DevStoreFeedInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.DevStoreFeedInputData"
}
t1.DevStoreFeedInputData = t192
typeRegistry.default:register(t1.DevStoreFeedInputData)

local t202 = {}

t202.__index = t202

function t202.new(t203: {[any]: any}?) -- line: 11625
	-- upvalues: t202 (copy)
	return (setmetatable({
		key = if t203 ~= nil and t203.key ~= nil then t203.key else "",
		value = if t203 ~= nil and t203.value ~= nil then t203.value else nil
	}, t202))
end
function t202.encode(p124) -- line: 11634
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n82 = 0

	if p124.key ~= nil and p124.key ~= "" then
		local v1715, v1716 = proto.writeTag(buf, n82, 1, proto.wireTypes.lengthDelimited)

		buf, n82 = proto.writeString(v1715, v1716, p124.key)
	end

	if p124.value ~= nil then
		local v1717 = p124.value:encode()
		local v1718, v1719 = proto.writeTag(buf, n82, 2, proto.wireTypes.lengthDelimited)

		buf, n82 = proto.writeBuffer(v1718, v1719, v1717, buffer.len(v1717))
	end

	local buf46 = buffer.create(n82)

	buffer.copy(buf46, 0, buf, 0, n82)

	return buf46
end
function t202.decode(p125: buffer) -- line: 11654
	-- upvalues: t202 (copy), proto (copy), t1 (copy)
	local v1722 = t202.new()
	local n83 = 0

	while n83 < buffer.len(p125) do
		local v1724, v1725

		v1724, v1725, n83 = proto.readTag(p125, n83)

		if v1725 == proto.wireTypes.varint then
			local v1726

			v1726, n83 = proto.readVarInt(p125, n83)
		elseif v1725 == proto.wireTypes.lengthDelimited then
			if v1724 == 1 then
				local v1727

				v1727, n83 = proto.readBuffer(p125, n83)
				v1722.key = buffer.tostring(v1727)
			elseif v1724 == 2 then
				local v1728

				v1728, n83 = proto.readBuffer(p125, n83)
				v1722.value = t1.FeedEntry.decode(v1728)
			else
				local v1729, v1730 = proto.readVarInt(p125, n83)

				n83 = v1730 + v1729
			end
		elseif v1725 == proto.wireTypes.i32 then
			local v1731

			v1731, n83 = proto.readFixed32(p125, n83)
		elseif v1725 == proto.wireTypes.i64 then
			local v1732

			v1732, n83 = proto.readFixed64(p125, n83)
		else
			error("Unsupported wire type: " .. v1725)
		end
	end

	return v1722
end
function t202.jsonEncode(p126) -- line: 11702
	local t204 = {}

	if p126.key ~= nil and p126.key ~= "" then
		t204.key = p126.key
	end

	if p126.value ~= nil then
		t204.value = p126.value:jsonEncode()
	end

	return t204
end
function t202.jsonDecode(t205: {[any]: any}) -- line: 11716
	-- upvalues: t202 (copy), t1 (copy)
	local v1736 = t202.new()

	if t205.key ~= nil then
		v1736.key = t205.key
	end

	if t205.value ~= nil then
		v1736.value = t1.FeedEntry.jsonDecode(t205.value)
	end

	return v1736
end

t202.descriptor = {
	name = "DevStoreFeedInputData_EntryMapEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryMapEntry"
}
t1.DevStoreFeedInputData_EntryMapEntry = t202
typeRegistry.default:register(t1.DevStoreFeedInputData_EntryMapEntry)

local t206 = {}

t206.__index = t206

function t206.new(t207: {[any]: any}?) -- line: 11746
	-- upvalues: t206 (copy)
	return (setmetatable({
		game_passes = if t207 ~= nil and t207.game_passes ~= nil then t207.game_passes else {}
	}, t206))
end
function t206.encode(p127) -- line: 11754
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n84 = 0

	if p127.game_passes ~= nil and #p127.game_passes > 0 then
		for _, v1742 in p127.game_passes do
			local v1743 = v1742:encode()
			local v1744, v1745 = proto.writeTag(buf, n84, 1, proto.wireTypes.lengthDelimited)

			buf, n84 = proto.writeBuffer(v1744, v1745, v1743, buffer.len(v1743))
		end
	end

	local buf47 = buffer.create(n84)

	buffer.copy(buf47, 0, buf, 0, n84)

	return buf47
end
function t206.decode(p128: buffer) -- line: 11771
	-- upvalues: t206 (copy), proto (copy), t1 (copy)
	local v1748 = t206.new()
	local n85 = 0

	while n85 < buffer.len(p128) do
		local v1750, v1751

		v1750, v1751, n85 = proto.readTag(p128, n85)

		if v1751 == proto.wireTypes.varint then
			local v1752

			v1752, n85 = proto.readVarInt(p128, n85)
		elseif v1751 == proto.wireTypes.lengthDelimited then
			if v1750 == 1 then
				local v1753

				v1753, n85 = proto.readBuffer(p128, n85)
				table.insert(v1748.game_passes, t1.GamePassCollectionInputData_GamePassItem.decode(v1753))
			else
				local v1754, v1755 = proto.readVarInt(p128, n85)

				n85 = v1755 + v1754
			end
		elseif v1751 == proto.wireTypes.i32 then
			local v1756

			v1756, n85 = proto.readFixed32(p128, n85)
		elseif v1751 == proto.wireTypes.i64 then
			local v1757

			v1757, n85 = proto.readFixed64(p128, n85)
		else
			error("Unsupported wire type: " .. v1751)
		end
	end

	return v1748
end
function t206.jsonEncode(p129) -- line: 11814
	local t208 = {}

	if p129.game_passes ~= nil and #p129.game_passes > 0 then
		local t209 = {}

		for _, v1762 in p129.game_passes do
			table.insert(t209, v1762:jsonEncode())
		end

		t208.gamePasses = t209
	end

	return t208
end
function t206.jsonDecode(t210: {[any]: any}) -- line: 11828
	-- upvalues: t206 (copy), t1 (copy)
	local v1764 = t206.new()

	if t210.game_passes ~= nil then
		local t211 = {}

		for _, v1767 in t210.game_passes do
			table.insert(t211, t1.GamePassCollectionInputData_GamePassItem.jsonDecode(v1767))
		end

		v1764.game_passes = t211
	end

	if t210.gamePasses ~= nil then
		local t212 = {}

		for _, v1770 in t210.gamePasses do
			table.insert(t212, t1.GamePassCollectionInputData_GamePassItem.jsonDecode(v1770))
		end

		v1764.game_passes = t212
	end

	return v1764
end

t206.descriptor = {
	name = "GamePassCollectionInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.GamePassCollectionInputData"
}
t1.GamePassCollectionInputData = t206
typeRegistry.default:register(t1.GamePassCollectionInputData)

local t213 = {}

t213.__index = t213

function t213.new(t214: {[any]: any}?) -- line: 11866
	-- upvalues: t213 (copy)
	return (setmetatable({
		game_pass_id = if t214 ~= nil and t214.game_pass_id ~= nil then t214.game_pass_id else ""
	}, t213))
end
function t213.encode(p130) -- line: 11874
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n86 = 0

	if p130.game_pass_id ~= nil and p130.game_pass_id ~= "" then
		local v1775, v1776 = proto.writeTag(buf, n86, 1, proto.wireTypes.lengthDelimited)

		buf, n86 = proto.writeString(v1775, v1776, p130.game_pass_id)
	end

	local buf48 = buffer.create(n86)

	buffer.copy(buf48, 0, buf, 0, n86)

	return buf48
end
function t213.decode(p131: buffer) -- line: 11890
	-- upvalues: t213 (copy), proto (copy)
	local v1779 = t213.new()
	local n87 = 0

	while n87 < buffer.len(p131) do
		local v1781, v1782

		v1781, v1782, n87 = proto.readTag(p131, n87)

		if v1782 == proto.wireTypes.varint then
			local v1783

			v1783, n87 = proto.readVarInt(p131, n87)
		elseif v1782 == proto.wireTypes.lengthDelimited then
			if v1781 == 1 then
				local v1784

				v1784, n87 = proto.readBuffer(p131, n87)
				v1779.game_pass_id = buffer.tostring(v1784)
			else
				local v1785, v1786 = proto.readVarInt(p131, n87)

				n87 = v1786 + v1785
			end
		elseif v1782 == proto.wireTypes.i32 then
			local v1787

			v1787, n87 = proto.readFixed32(p131, n87)
		elseif v1782 == proto.wireTypes.i64 then
			local v1788

			v1788, n87 = proto.readFixed64(p131, n87)
		else
			error("Unsupported wire type: " .. v1782)
		end
	end

	return v1779
end
function t213.jsonEncode(p132) -- line: 11935
	local t215 = {}

	if p132.game_pass_id ~= nil and p132.game_pass_id ~= "" then
		t215.gamePassId = p132.game_pass_id
	end

	return t215
end
function t213.jsonDecode(t216: {[any]: any}) -- line: 11947
	-- upvalues: t213 (copy)
	local v1792 = t213.new()

	if t216.game_pass_id ~= nil then
		v1792.game_pass_id = t216.game_pass_id
	end

	if t216.gamePassId ~= nil then
		v1792.game_pass_id = t216.gamePassId
	end

	return v1792
end

t213.descriptor = {
	name = "GamePassCollectionInputData_GamePassItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.GamePassItem"
}
t1.GamePassCollectionInputData_GamePassItem = t213
typeRegistry.default:register(t1.GamePassCollectionInputData_GamePassItem)

local t217 = {}

t217.__index = t217

function t217.new(t218: {[any]: any}?) -- line: 11977
	-- upvalues: t217 (copy)
	return (setmetatable({
		developer_products = if t218 ~= nil and t218.developer_products ~= nil then t218.developer_products else {}
	}, t217))
end
function t217.encode(p133) -- line: 11985
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n88 = 0

	if p133.developer_products ~= nil and #p133.developer_products > 0 then
		for _, v1798 in p133.developer_products do
			local v1799 = v1798:encode()
			local v1800, v1801 = proto.writeTag(buf, n88, 1, proto.wireTypes.lengthDelimited)

			buf, n88 = proto.writeBuffer(v1800, v1801, v1799, buffer.len(v1799))
		end
	end

	local buf49 = buffer.create(n88)

	buffer.copy(buf49, 0, buf, 0, n88)

	return buf49
end
function t217.decode(p134: buffer) -- line: 12002
	-- upvalues: t217 (copy), proto (copy), t1 (copy)
	local v1804 = t217.new()
	local n89 = 0

	while n89 < buffer.len(p134) do
		local v1806, v1807

		v1806, v1807, n89 = proto.readTag(p134, n89)

		if v1807 == proto.wireTypes.varint then
			local v1808

			v1808, n89 = proto.readVarInt(p134, n89)
		elseif v1807 == proto.wireTypes.lengthDelimited then
			if v1806 == 1 then
				local v1809

				v1809, n89 = proto.readBuffer(p134, n89)
				table.insert(v1804.developer_products, t1.DeveloperProductCollectionInputData_DeveloperProductItem.decode(v1809))
			else
				local v1810, v1811 = proto.readVarInt(p134, n89)

				n89 = v1811 + v1810
			end
		elseif v1807 == proto.wireTypes.i32 then
			local v1812

			v1812, n89 = proto.readFixed32(p134, n89)
		elseif v1807 == proto.wireTypes.i64 then
			local v1813

			v1813, n89 = proto.readFixed64(p134, n89)
		else
			error("Unsupported wire type: " .. v1807)
		end
	end

	return v1804
end
function t217.jsonEncode(p135) -- line: 12048
	local t219 = {}

	if p135.developer_products ~= nil and #p135.developer_products > 0 then
		local t220 = {}

		for _, v1818 in p135.developer_products do
			table.insert(t220, v1818:jsonEncode())
		end

		t219.developerProducts = t220
	end

	return t219
end
function t217.jsonDecode(t221: {[any]: any}) -- line: 12062
	-- upvalues: t217 (copy), t1 (copy)
	local v1820 = t217.new()

	if t221.developer_products ~= nil then
		local t222 = {}

		for _, v1823 in t221.developer_products do
			table.insert(t222, t1.DeveloperProductCollectionInputData_DeveloperProductItem.jsonDecode(v1823))
		end

		v1820.developer_products = t222
	end

	if t221.developerProducts ~= nil then
		local t223 = {}

		for _, v1826 in t221.developerProducts do
			table.insert(t223, t1.DeveloperProductCollectionInputData_DeveloperProductItem.jsonDecode(v1826))
		end

		v1820.developer_products = t223
	end

	return v1820
end

t217.descriptor = {
	name = "DeveloperProductCollectionInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.DeveloperProductCollectionInputData"
}
t1.DeveloperProductCollectionInputData = t217
typeRegistry.default:register(t1.DeveloperProductCollectionInputData)

local t224 = {}

t224.__index = t224

function t224.new(t225: {[any]: any}?) -- line: 12109
	-- upvalues: t224 (copy)
	return (setmetatable({
		developer_product_id = if t225 ~= nil and t225.developer_product_id ~= nil then t225.developer_product_id else ""
	}, t224))
end
function t224.encode(p136) -- line: 12122
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n90 = 0

	if p136.developer_product_id ~= nil and p136.developer_product_id ~= "" then
		local v1831, v1832 = proto.writeTag(buf, n90, 1, proto.wireTypes.lengthDelimited)

		buf, n90 = proto.writeString(v1831, v1832, p136.developer_product_id)
	end

	local buf50 = buffer.create(n90)

	buffer.copy(buf50, 0, buf, 0, n90)

	return buf50
end
function t224.decode(p137: buffer) -- line: 12138
	-- upvalues: t224 (copy), proto (copy)
	local v1835 = t224.new()
	local n91 = 0

	while n91 < buffer.len(p137) do
		local v1837, v1838

		v1837, v1838, n91 = proto.readTag(p137, n91)

		if v1838 == proto.wireTypes.varint then
			local v1839

			v1839, n91 = proto.readVarInt(p137, n91)
		elseif v1838 == proto.wireTypes.lengthDelimited then
			if v1837 == 1 then
				local v1840

				v1840, n91 = proto.readBuffer(p137, n91)
				v1835.developer_product_id = buffer.tostring(v1840)
			else
				local v1841, v1842 = proto.readVarInt(p137, n91)

				n91 = v1842 + v1841
			end
		elseif v1838 == proto.wireTypes.i32 then
			local v1843

			v1843, n91 = proto.readFixed32(p137, n91)
		elseif v1838 == proto.wireTypes.i64 then
			local v1844

			v1844, n91 = proto.readFixed64(p137, n91)
		else
			error("Unsupported wire type: " .. v1838)
		end
	end

	return v1835
end
function t224.jsonEncode(p138) -- line: 12183
	local t226 = {}

	if p138.developer_product_id ~= nil and p138.developer_product_id ~= "" then
		t226.developerProductId = p138.developer_product_id
	end

	return t226
end
function t224.jsonDecode(t227: {[any]: any}) -- line: 12195
	-- upvalues: t224 (copy)
	local v1848 = t224.new()

	if t227.developer_product_id ~= nil then
		v1848.developer_product_id = t227.developer_product_id
	end

	if t227.developerProductId ~= nil then
		v1848.developer_product_id = t227.developerProductId
	end

	return v1848
end

t224.descriptor = {
	name = "DeveloperProductCollectionInputData_DeveloperProductItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.DeveloperProductItem"
}
t1.DeveloperProductCollectionInputData_DeveloperProductItem = t224
typeRegistry.default:register(t1.DeveloperProductCollectionInputData_DeveloperProductItem)

local t228 = {}

t228.__index = t228

function t228.new(t229: {[any]: any}?) -- line: 12226
	-- upvalues: t228 (copy)
	return (setmetatable({
		subscriptions = if t229 ~= nil and t229.subscriptions ~= nil then t229.subscriptions else {}
	}, t228))
end
function t228.encode(p139) -- line: 12234
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n92 = 0

	if p139.subscriptions ~= nil and #p139.subscriptions > 0 then
		for _, v1854 in p139.subscriptions do
			local v1855 = v1854:encode()
			local v1856, v1857 = proto.writeTag(buf, n92, 1, proto.wireTypes.lengthDelimited)

			buf, n92 = proto.writeBuffer(v1856, v1857, v1855, buffer.len(v1855))
		end
	end

	local buf51 = buffer.create(n92)

	buffer.copy(buf51, 0, buf, 0, n92)

	return buf51
end
function t228.decode(p140: buffer) -- line: 12251
	-- upvalues: t228 (copy), proto (copy), t1 (copy)
	local v1860 = t228.new()
	local n93 = 0

	while n93 < buffer.len(p140) do
		local v1862, v1863

		v1862, v1863, n93 = proto.readTag(p140, n93)

		if v1863 == proto.wireTypes.varint then
			local v1864

			v1864, n93 = proto.readVarInt(p140, n93)
		elseif v1863 == proto.wireTypes.lengthDelimited then
			if v1862 == 1 then
				local v1865

				v1865, n93 = proto.readBuffer(p140, n93)
				table.insert(v1860.subscriptions, t1.SubscriptionCollectionInputData_SubscriptionItem.decode(v1865))
			else
				local v1866, v1867 = proto.readVarInt(p140, n93)

				n93 = v1867 + v1866
			end
		elseif v1863 == proto.wireTypes.i32 then
			local v1868

			v1868, n93 = proto.readFixed32(p140, n93)
		elseif v1863 == proto.wireTypes.i64 then
			local v1869

			v1869, n93 = proto.readFixed64(p140, n93)
		else
			error("Unsupported wire type: " .. v1863)
		end
	end

	return v1860
end
function t228.jsonEncode(p141) -- line: 12297
	local t230 = {}

	if p141.subscriptions ~= nil and #p141.subscriptions > 0 then
		local t231 = {}

		for _, v1874 in p141.subscriptions do
			table.insert(t231, v1874:jsonEncode())
		end

		t230.subscriptions = t231
	end

	return t230
end
function t228.jsonDecode(t232: {[any]: any}) -- line: 12311
	-- upvalues: t228 (copy), t1 (copy)
	local v1876 = t228.new()

	if t232.subscriptions ~= nil then
		local t233 = {}

		for _, v1879 in t232.subscriptions do
			table.insert(t233, t1.SubscriptionCollectionInputData_SubscriptionItem.jsonDecode(v1879))
		end

		v1876.subscriptions = t233
	end

	return v1876
end

t228.descriptor = {
	name = "SubscriptionCollectionInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.SubscriptionCollectionInputData"
}
t1.SubscriptionCollectionInputData = t228
typeRegistry.default:register(t1.SubscriptionCollectionInputData)

local t234 = {}

t234.__index = t234

function t234.new(t235: {[any]: any}?) -- line: 12341
	-- upvalues: t234 (copy)
	return (setmetatable({
		subscription_id = if t235 ~= nil and t235.subscription_id ~= nil then t235.subscription_id else ""
	}, t234))
end
function t234.encode(p142) -- line: 12352
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n94 = 0

	if p142.subscription_id ~= nil and p142.subscription_id ~= "" then
		local v1884, v1885 = proto.writeTag(buf, n94, 1, proto.wireTypes.lengthDelimited)

		buf, n94 = proto.writeString(v1884, v1885, p142.subscription_id)
	end

	local buf52 = buffer.create(n94)

	buffer.copy(buf52, 0, buf, 0, n94)

	return buf52
end
function t234.decode(p143: buffer) -- line: 12368
	-- upvalues: t234 (copy), proto (copy)
	local v1888 = t234.new()
	local n95 = 0

	while n95 < buffer.len(p143) do
		local v1890, v1891

		v1890, v1891, n95 = proto.readTag(p143, n95)

		if v1891 == proto.wireTypes.varint then
			local v1892

			v1892, n95 = proto.readVarInt(p143, n95)
		elseif v1891 == proto.wireTypes.lengthDelimited then
			if v1890 == 1 then
				local v1893

				v1893, n95 = proto.readBuffer(p143, n95)
				v1888.subscription_id = buffer.tostring(v1893)
			else
				local v1894, v1895 = proto.readVarInt(p143, n95)

				n95 = v1895 + v1894
			end
		elseif v1891 == proto.wireTypes.i32 then
			local v1896

			v1896, n95 = proto.readFixed32(p143, n95)
		elseif v1891 == proto.wireTypes.i64 then
			local v1897

			v1897, n95 = proto.readFixed64(p143, n95)
		else
			error("Unsupported wire type: " .. v1891)
		end
	end

	return v1888
end
function t234.jsonEncode(p144) -- line: 12413
	local t236 = {}

	if p144.subscription_id ~= nil and p144.subscription_id ~= "" then
		t236.subscriptionId = p144.subscription_id
	end

	return t236
end
function t234.jsonDecode(t237: {[any]: any}) -- line: 12425
	-- upvalues: t234 (copy)
	local v1901 = t234.new()

	if t237.subscription_id ~= nil then
		v1901.subscription_id = t237.subscription_id
	end

	if t237.subscriptionId ~= nil then
		v1901.subscription_id = t237.subscriptionId
	end

	return v1901
end

t234.descriptor = {
	name = "SubscriptionCollectionInputData_SubscriptionItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.SubscriptionItem"
}
t1.SubscriptionCollectionInputData_SubscriptionItem = t234
typeRegistry.default:register(t1.SubscriptionCollectionInputData_SubscriptionItem)

local t238 = {}

t238.__index = t238

function t238.new(t239: {[any]: any}?) -- line: 12456
	-- upvalues: t238 (copy)
	return (setmetatable({
		items = if t239 ~= nil and t239.items ~= nil then t239.items else {},
		universe_id = if t239 ~= nil and t239.universe_id ~= nil then t239.universe_id else "",
		section_title = if t239 ~= nil and t239.section_title ~= nil then t239.section_title else ""
	}, t238))
end
function t238.encode(p145) -- line: 12466
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n96 = 0

	if p145.items ~= nil and #p145.items > 0 then
		for _, v1907 in p145.items do
			local v1908 = v1907:encode()
			local v1909, v1910 = proto.writeTag(buf, n96, 1, proto.wireTypes.lengthDelimited)

			buf, n96 = proto.writeBuffer(v1909, v1910, v1908, buffer.len(v1908))
		end
	end

	if p145.universe_id ~= nil and p145.universe_id ~= "" then
		local v1911, v1912 = proto.writeTag(buf, n96, 2, proto.wireTypes.lengthDelimited)

		buf, n96 = proto.writeString(v1911, v1912, p145.universe_id)
	end

	if p145.section_title ~= nil and p145.section_title ~= "" then
		local v1913, v1914 = proto.writeTag(buf, n96, 3, proto.wireTypes.lengthDelimited)

		buf, n96 = proto.writeString(v1913, v1914, p145.section_title)
	end

	local buf53 = buffer.create(n96)

	buffer.copy(buf53, 0, buf, 0, n96)

	return buf53
end
function t238.decode(p146: buffer) -- line: 12493
	-- upvalues: t238 (copy), proto (copy), t1 (copy)
	local v1917 = t238.new()
	local n97 = 0

	while n97 < buffer.len(p146) do
		local v1919, v1920

		v1919, v1920, n97 = proto.readTag(p146, n97)

		if v1920 == proto.wireTypes.varint then
			local v1921

			v1921, n97 = proto.readVarInt(p146, n97)
		elseif v1920 == proto.wireTypes.lengthDelimited then
			if v1919 == 1 then
				local v1922

				v1922, n97 = proto.readBuffer(p146, n97)
				table.insert(v1917.items, t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItem.decode(v1922))
			elseif v1919 == 2 then
				local v1923

				v1923, n97 = proto.readBuffer(p146, n97)
				v1917.universe_id = buffer.tostring(v1923)
			elseif v1919 == 3 then
				local v1924

				v1924, n97 = proto.readBuffer(p146, n97)
				v1917.section_title = buffer.tostring(v1924)
			else
				local v1925, v1926 = proto.readVarInt(p146, n97)

				n97 = v1926 + v1925
			end
		elseif v1920 == proto.wireTypes.i32 then
			local v1927

			v1927, n97 = proto.readFixed32(p146, n97)
		elseif v1920 == proto.wireTypes.i64 then
			local v1928

			v1928, n97 = proto.readFixed64(p146, n97)
		else
			error("Unsupported wire type: " .. v1920)
		end
	end

	return v1917
end
function t238.jsonEncode(p147) -- line: 12549
	local t240 = {}

	if p147.items ~= nil and #p147.items > 0 then
		local t241 = {}

		for _, v1933 in p147.items do
			table.insert(t241, v1933:jsonEncode())
		end

		t240.items = t241
	end

	if p147.universe_id ~= nil and p147.universe_id ~= "" then
		t240.universeId = p147.universe_id
	end

	if p147.section_title ~= nil and p147.section_title ~= "" then
		t240.sectionTitle = p147.section_title
	end

	return t240
end
function t238.jsonDecode(t242: {[any]: any}) -- line: 12571
	-- upvalues: t238 (copy), t1 (copy)
	local v1935 = t238.new()

	if t242.items ~= nil then
		local t243 = {}

		for _, v1938 in t242.items do
			table.insert(t243, t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItem.jsonDecode(v1938))
		end

		v1935.items = t243
	end

	if t242.universe_id ~= nil then
		v1935.universe_id = t242.universe_id
	end

	if t242.universeId ~= nil then
		v1935.universe_id = t242.universeId
	end

	if t242.section_title ~= nil then
		v1935.section_title = t242.section_title
	end

	if t242.sectionTitle ~= nil then
		v1935.section_title = t242.sectionTitle
	end

	return v1935
end

t238.descriptor = {
	name = "DynamicStoreCategoryInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.DynamicStoreCategoryInputData"
}
t1.DynamicStoreCategoryInputData = t238
typeRegistry.default:register(t1.DynamicStoreCategoryInputData)

local t244 = {}

t244.__index = t244

function t244.new(t245: {[any]: any}?) -- line: 12620
	-- upvalues: t1 (copy), t244 (copy)
	return (setmetatable({
		item_id = if t245 ~= nil and t245.item_id ~= nil then t245.item_id else "",
		identifier = if t245 ~= nil and t245.identifier ~= nil then t245.identifier else assert(t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItemType.fromNumber(0), "Enum has no 0 default")
	}, t244))
end
function t244.encode(p148) -- line: 12637
	-- upvalues: proto (copy), t1 (copy)
	local buf = buffer.create(0)
	local n98 = 0

	if p148.item_id ~= nil and p148.item_id ~= "" then
		local v1943, v1944 = proto.writeTag(buf, n98, 1, proto.wireTypes.lengthDelimited)

		buf, n98 = proto.writeString(v1943, v1944, p148.item_id)
	end

	if p148.identifier ~= nil and (p148.identifier ~= nil and p148.identifier ~= 0 or p148.identifier ~= t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItemType.fromNumber(0)) then
		local v1945, v1946 = proto.writeTag(buf, n98, 2, proto.wireTypes.varint)

		buf, n98 = proto.writeVarInt(v1945, v1946, t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItemType.toNumber(p148.identifier))
	end

	local buf54 = buffer.create(n98)

	buffer.copy(buf54, 0, buf, 0, n98)

	return buf54
end
function t244.decode(p149: buffer) -- line: 12669
	-- upvalues: t244 (copy), proto (copy), t1 (copy)
	local v1949 = t244.new()
	local n99 = 0

	while n99 < buffer.len(p149) do
		local v1951, v1952

		v1951, v1952, n99 = proto.readTag(p149, n99)

		if v1952 == proto.wireTypes.varint then
			if v1951 == 2 then
				local v1953

				v1953, n99 = proto.readVarIntI32(p149, n99)
				v1949.identifier = t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItemType.fromNumber(v1953) or v1953
			else
				local v1954

				v1954, n99 = proto.readVarInt(p149, n99)
			end
		elseif v1952 == proto.wireTypes.lengthDelimited then
			if v1951 == 1 then
				local v1955

				v1955, n99 = proto.readBuffer(p149, n99)
				v1949.item_id = buffer.tostring(v1955)
			else
				local v1956, v1957 = proto.readVarInt(p149, n99)

				n99 = v1957 + v1956
			end
		elseif v1952 == proto.wireTypes.i32 then
			local v1958

			v1958, n99 = proto.readFixed32(p149, n99)
		elseif v1952 == proto.wireTypes.i64 then
			local v1959

			v1959, n99 = proto.readFixed64(p149, n99)
		else
			error("Unsupported wire type: " .. v1952)
		end
	end

	return v1949
end
function t244.jsonEncode(p150) -- line: 12721
	-- upvalues: t1 (copy)
	local t246 = {}

	if p150.item_id ~= nil and p150.item_id ~= "" then
		t246.itemId = p150.item_id
	end

	if p150.identifier ~= nil and (p150.identifier ~= nil and p150.identifier ~= 0 or p150.identifier ~= t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItemType.fromNumber(0)) then
		t246.identifier = if typeof(p150.identifier) ~= "number" then t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItemType.toNumber(p150.identifier) else p150.identifier
	end

	return t246
end
function t244.jsonDecode(t247: {[any]: any}) -- line: 12748
	-- upvalues: t244 (copy), t1 (copy)
	local v1963 = t244.new()

	if t247.item_id ~= nil then
		v1963.item_id = t247.item_id
	end

	if t247.itemId ~= nil then
		v1963.item_id = t247.itemId
	end

	if t247.identifier ~= nil then
		v1963.identifier = if typeof(t247.identifier) ~= "number" then t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItemType.fromName(t247.identifier) or t247.identifier else t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItemType.fromNumber(t247.identifier) or t247.identifier
	end

	return v1963
end

t244.descriptor = {
	name = "DynamicStoreCategoryInputData_DynamicStoreCategoryItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.DynamicStoreCategoryItem"
}
t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItem = t244
typeRegistry.default:register(t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItem)
t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItemType = {
	fromNumber = function(n100: number) -- line: 12787
		if n100 == 0 then
			return "DYNAMIC_STORE_CATEGORY_ITEM_TYPE_INVALID"
		end

		if n100 == 1 then
			return "DYNAMIC_STORE_CATEGORY_ITEM_TYPE_GAME_PASS"
		end

		if n100 == 2 then
			return "DYNAMIC_STORE_CATEGORY_ITEM_TYPE_DEVELOPER_PRODUCT"
		end

		return nil
	end,
	toNumber = function(p151) -- line: 12799
		if p151 == "DYNAMIC_STORE_CATEGORY_ITEM_TYPE_INVALID" then
			return 0
		end

		if p151 == "DYNAMIC_STORE_CATEGORY_ITEM_TYPE_GAME_PASS" then
			return 1
		end

		if p151 == "DYNAMIC_STORE_CATEGORY_ITEM_TYPE_DEVELOPER_PRODUCT" then
			return 2
		end

		return p151
	end,
	fromName = function(s1: string) -- line: 12811
		if s1 == "DYNAMIC_STORE_CATEGORY_ITEM_TYPE_INVALID" then
			return "DYNAMIC_STORE_CATEGORY_ITEM_TYPE_INVALID"
		end

		if s1 == "DYNAMIC_STORE_CATEGORY_ITEM_TYPE_GAME_PASS" then
			return "DYNAMIC_STORE_CATEGORY_ITEM_TYPE_GAME_PASS"
		end

		if s1 == "DYNAMIC_STORE_CATEGORY_ITEM_TYPE_DEVELOPER_PRODUCT" then
			return "DYNAMIC_STORE_CATEGORY_ITEM_TYPE_DEVELOPER_PRODUCT"
		end

		return nil
	end
}

local t248 = {}

t248.__index = t248

function t248.new(t249: {[any]: any}?) -- line: 12828
	-- upvalues: t248 (copy)
	return (setmetatable({
		roblox_component = if t249 ~= nil and t249.roblox_component ~= nil then t249.roblox_component else "",
		identifier = if t249 ~= nil and t249.identifier ~= nil then t249.identifier else "",
		title = if t249 ~= nil and t249.title ~= nil then t249.title else "",
		user_id = if t249 ~= nil and t249.user_id ~= nil then t249.user_id else "",
		description = if t249 ~= nil and t249.description ~= nil then t249.description else "",
		cta_text = if t249 ~= nil and t249.cta_text ~= nil then t249.cta_text else "",
		prompt_id = if t249 ~= nil and t249.prompt_id ~= nil then t249.prompt_id else "",
		prompt_type = if t249 ~= nil and t249.prompt_type ~= nil then t249.prompt_type else "",
		entity_id = if t249 ~= nil and t249.entity_id ~= nil then t249.entity_id else ""
	}, t248))
end
function t248.encode(p152) -- line: 12844
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n101 = 0

	if p152.roblox_component ~= nil and p152.roblox_component ~= "" then
		local v1971, v1972 = proto.writeTag(buf, n101, 1, proto.wireTypes.lengthDelimited)

		buf, n101 = proto.writeString(v1971, v1972, p152.roblox_component)
	end

	if p152.identifier ~= nil and p152.identifier ~= "" then
		local v1973, v1974 = proto.writeTag(buf, n101, 2, proto.wireTypes.lengthDelimited)

		buf, n101 = proto.writeString(v1973, v1974, p152.identifier)
	end

	if p152.title ~= nil and p152.title ~= "" then
		local v1975, v1976 = proto.writeTag(buf, n101, 3, proto.wireTypes.lengthDelimited)

		buf, n101 = proto.writeString(v1975, v1976, p152.title)
	end

	if p152.user_id ~= nil and p152.user_id ~= "" then
		local v1977, v1978 = proto.writeTag(buf, n101, 4, proto.wireTypes.lengthDelimited)

		buf, n101 = proto.writeString(v1977, v1978, p152.user_id)
	end

	if p152.description ~= nil and p152.description ~= "" then
		local v1979, v1980 = proto.writeTag(buf, n101, 5, proto.wireTypes.lengthDelimited)

		buf, n101 = proto.writeString(v1979, v1980, p152.description)
	end

	if p152.cta_text ~= nil and p152.cta_text ~= "" then
		local v1981, v1982 = proto.writeTag(buf, n101, 6, proto.wireTypes.lengthDelimited)

		buf, n101 = proto.writeString(v1981, v1982, p152.cta_text)
	end

	if p152.prompt_id ~= nil and p152.prompt_id ~= "" then
		local v1983, v1984 = proto.writeTag(buf, n101, 7, proto.wireTypes.lengthDelimited)

		buf, n101 = proto.writeString(v1983, v1984, p152.prompt_id)
	end

	if p152.prompt_type ~= nil and p152.prompt_type ~= "" then
		local v1985, v1986 = proto.writeTag(buf, n101, 8, proto.wireTypes.lengthDelimited)

		buf, n101 = proto.writeString(v1985, v1986, p152.prompt_type)
	end

	if p152.entity_id ~= nil and p152.entity_id ~= "" then
		local v1987, v1988 = proto.writeTag(buf, n101, 9, proto.wireTypes.lengthDelimited)

		buf, n101 = proto.writeString(v1987, v1988, p152.entity_id)
	end

	local buf55 = buffer.create(n101)

	buffer.copy(buf55, 0, buf, 0, n101)

	return buf55
end
function t248.decode(p153: buffer) -- line: 12898
	-- upvalues: t248 (copy), proto (copy)
	local v1991 = t248.new()
	local n102 = 0

	while n102 < buffer.len(p153) do
		local v1993, v1994

		v1993, v1994, n102 = proto.readTag(p153, n102)

		if v1994 == proto.wireTypes.varint then
			local v1995

			v1995, n102 = proto.readVarInt(p153, n102)
		elseif v1994 == proto.wireTypes.lengthDelimited then
			if v1993 == 1 then
				local v1996

				v1996, n102 = proto.readBuffer(p153, n102)
				v1991.roblox_component = buffer.tostring(v1996)
			elseif v1993 == 2 then
				local v1997

				v1997, n102 = proto.readBuffer(p153, n102)
				v1991.identifier = buffer.tostring(v1997)
			elseif v1993 == 3 then
				local v1998

				v1998, n102 = proto.readBuffer(p153, n102)
				v1991.title = buffer.tostring(v1998)
			elseif v1993 == 4 then
				local v1999

				v1999, n102 = proto.readBuffer(p153, n102)
				v1991.user_id = buffer.tostring(v1999)
			elseif v1993 == 5 then
				local v2000

				v2000, n102 = proto.readBuffer(p153, n102)
				v1991.description = buffer.tostring(v2000)
			elseif v1993 == 6 then
				local v2001

				v2001, n102 = proto.readBuffer(p153, n102)
				v1991.cta_text = buffer.tostring(v2001)
			elseif v1993 == 7 then
				local v2002

				v2002, n102 = proto.readBuffer(p153, n102)
				v1991.prompt_id = buffer.tostring(v2002)
			elseif v1993 == 8 then
				local v2003

				v2003, n102 = proto.readBuffer(p153, n102)
				v1991.prompt_type = buffer.tostring(v2003)
			elseif v1993 == 9 then
				local v2004

				v2004, n102 = proto.readBuffer(p153, n102)
				v1991.entity_id = buffer.tostring(v2004)
			else
				local v2005, v2006 = proto.readVarInt(p153, n102)

				n102 = v2006 + v2005
			end
		elseif v1994 == proto.wireTypes.i32 then
			local v2007

			v2007, n102 = proto.readFixed32(p153, n102)
		elseif v1994 == proto.wireTypes.i64 then
			local v2008

			v2008, n102 = proto.readFixed64(p153, n102)
		else
			error("Unsupported wire type: " .. v1994)
		end
	end

	return v1991
end
function t248.jsonEncode(p154) -- line: 12981
	local t250 = {}

	if p154.roblox_component ~= nil and p154.roblox_component ~= "" then
		t250.robloxComponent = p154.roblox_component
	end

	if p154.identifier ~= nil and p154.identifier ~= "" then
		t250.identifier = p154.identifier
	end

	if p154.title ~= nil and p154.title ~= "" then
		t250.title = p154.title
	end

	if p154.user_id ~= nil and p154.user_id ~= "" then
		t250.userId = p154.user_id
	end

	if p154.description ~= nil and p154.description ~= "" then
		t250.description = p154.description
	end

	if p154.cta_text ~= nil and p154.cta_text ~= "" then
		t250.ctaText = p154.cta_text
	end

	if p154.prompt_id ~= nil and p154.prompt_id ~= "" then
		t250.promptId = p154.prompt_id
	end

	if p154.prompt_type ~= nil and p154.prompt_type ~= "" then
		t250.promptType = p154.prompt_type
	end

	if p154.entity_id ~= nil and p154.entity_id ~= "" then
		t250.entityId = p154.entity_id
	end

	return t250
end
function t248.jsonDecode(t251: {[any]: any}) -- line: 13023
	-- upvalues: t248 (copy)
	local v2012 = t248.new()

	if t251.roblox_component ~= nil then
		v2012.roblox_component = t251.roblox_component
	end

	if t251.robloxComponent ~= nil then
		v2012.roblox_component = t251.robloxComponent
	end

	if t251.identifier ~= nil then
		v2012.identifier = t251.identifier
	end

	if t251.title ~= nil then
		v2012.title = t251.title
	end

	if t251.user_id ~= nil then
		v2012.user_id = t251.user_id
	end

	if t251.userId ~= nil then
		v2012.user_id = t251.userId
	end

	if t251.description ~= nil then
		v2012.description = t251.description
	end

	if t251.cta_text ~= nil then
		v2012.cta_text = t251.cta_text
	end

	if t251.ctaText ~= nil then
		v2012.cta_text = t251.ctaText
	end

	if t251.prompt_id ~= nil then
		v2012.prompt_id = t251.prompt_id
	end

	if t251.promptId ~= nil then
		v2012.prompt_id = t251.promptId
	end

	if t251.prompt_type ~= nil then
		v2012.prompt_type = t251.prompt_type
	end

	if t251.promptType ~= nil then
		v2012.prompt_type = t251.promptType
	end

	if t251.entity_id ~= nil then
		v2012.entity_id = t251.entity_id
	end

	if t251.entityId ~= nil then
		v2012.entity_id = t251.entityId
	end

	return v2012
end

t248.descriptor = {
	name = "CardContainerCardInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CardContainerCardInputData"
}
t1.CardContainerCardInputData = t248
typeRegistry.default:register(t1.CardContainerCardInputData)

local t252 = {}

t252.__index = t252

function t252.new(t253: {[any]: any}?) -- line: 13103
	-- upvalues: t252 (copy)
	return (setmetatable({
		title = if t253 ~= nil and t253.title ~= nil then t253.title else "",
		dismiss_text = if t253 ~= nil and t253.dismiss_text ~= nil then t253.dismiss_text else "",
		user_id = if t253 ~= nil and t253.user_id ~= nil then t253.user_id else "",
		cards = if t253 ~= nil and t253.cards ~= nil then t253.cards else {},
		prompt_id = if t253 ~= nil and t253.prompt_id ~= nil then t253.prompt_id else "",
		prompt_type = if t253 ~= nil and t253.prompt_type ~= nil then t253.prompt_type else ""
	}, t252))
end
function t252.encode(p155) -- line: 13114
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n103 = 0

	if p155.title ~= nil and p155.title ~= "" then
		local v2017, v2018 = proto.writeTag(buf, n103, 1, proto.wireTypes.lengthDelimited)

		buf, n103 = proto.writeString(v2017, v2018, p155.title)
	end

	if p155.dismiss_text ~= nil and p155.dismiss_text ~= "" then
		local v2019, v2020 = proto.writeTag(buf, n103, 2, proto.wireTypes.lengthDelimited)

		buf, n103 = proto.writeString(v2019, v2020, p155.dismiss_text)
	end

	if p155.user_id ~= nil and p155.user_id ~= "" then
		local v2021, v2022 = proto.writeTag(buf, n103, 3, proto.wireTypes.lengthDelimited)

		buf, n103 = proto.writeString(v2021, v2022, p155.user_id)
	end

	if p155.cards ~= nil and #p155.cards > 0 then
		for _, v2024 in p155.cards do
			local v2025 = v2024:encode()
			local v2026, v2027 = proto.writeTag(buf, n103, 4, proto.wireTypes.lengthDelimited)

			buf, n103 = proto.writeBuffer(v2026, v2027, v2025, buffer.len(v2025))
		end
	end

	if p155.prompt_id ~= nil and p155.prompt_id ~= "" then
		local v2028, v2029 = proto.writeTag(buf, n103, 5, proto.wireTypes.lengthDelimited)

		buf, n103 = proto.writeString(v2028, v2029, p155.prompt_id)
	end

	if p155.prompt_type ~= nil and p155.prompt_type ~= "" then
		local v2030, v2031 = proto.writeTag(buf, n103, 6, proto.wireTypes.lengthDelimited)

		buf, n103 = proto.writeString(v2030, v2031, p155.prompt_type)
	end

	local buf56 = buffer.create(n103)

	buffer.copy(buf56, 0, buf, 0, n103)

	return buf56
end
function t252.decode(p156: buffer) -- line: 13156
	-- upvalues: t252 (copy), proto (copy), t1 (copy)
	local v2034 = t252.new()
	local n104 = 0

	while n104 < buffer.len(p156) do
		local v2036, v2037

		v2036, v2037, n104 = proto.readTag(p156, n104)

		if v2037 == proto.wireTypes.varint then
			local v2038

			v2038, n104 = proto.readVarInt(p156, n104)
		elseif v2037 == proto.wireTypes.lengthDelimited then
			if v2036 == 1 then
				local v2039

				v2039, n104 = proto.readBuffer(p156, n104)
				v2034.title = buffer.tostring(v2039)
			elseif v2036 == 2 then
				local v2040

				v2040, n104 = proto.readBuffer(p156, n104)
				v2034.dismiss_text = buffer.tostring(v2040)
			elseif v2036 == 3 then
				local v2041

				v2041, n104 = proto.readBuffer(p156, n104)
				v2034.user_id = buffer.tostring(v2041)
			elseif v2036 == 4 then
				local v2042

				v2042, n104 = proto.readBuffer(p156, n104)
				table.insert(v2034.cards, t1.CardContainerCardInputData.decode(v2042))
			elseif v2036 == 5 then
				local v2043

				v2043, n104 = proto.readBuffer(p156, n104)
				v2034.prompt_id = buffer.tostring(v2043)
			elseif v2036 == 6 then
				local v2044

				v2044, n104 = proto.readBuffer(p156, n104)
				v2034.prompt_type = buffer.tostring(v2044)
			else
				local v2045, v2046 = proto.readVarInt(p156, n104)

				n104 = v2046 + v2045
			end
		elseif v2037 == proto.wireTypes.i32 then
			local v2047

			v2047, n104 = proto.readFixed32(p156, n104)
		elseif v2037 == proto.wireTypes.i64 then
			local v2048

			v2048, n104 = proto.readFixed64(p156, n104)
		else
			error("Unsupported wire type: " .. v2037)
		end
	end

	return v2034
end
function t252.jsonEncode(p157) -- line: 13224
	local t254 = {}

	if p157.title ~= nil and p157.title ~= "" then
		t254.title = p157.title
	end

	if p157.dismiss_text ~= nil and p157.dismiss_text ~= "" then
		t254.dismissText = p157.dismiss_text
	end

	if p157.user_id ~= nil and p157.user_id ~= "" then
		t254.userId = p157.user_id
	end

	if p157.cards ~= nil and #p157.cards > 0 then
		local t255 = {}

		for _, v2053 in p157.cards do
			table.insert(t255, v2053:jsonEncode())
		end

		t254.cards = t255
	end

	if p157.prompt_id ~= nil and p157.prompt_id ~= "" then
		t254.promptId = p157.prompt_id
	end

	if p157.prompt_type ~= nil and p157.prompt_type ~= "" then
		t254.promptType = p157.prompt_type
	end

	return t254
end
function t252.jsonDecode(t256: {[any]: any}) -- line: 13258
	-- upvalues: t252 (copy), t1 (copy)
	local v2055 = t252.new()

	if t256.title ~= nil then
		v2055.title = t256.title
	end

	if t256.dismiss_text ~= nil then
		v2055.dismiss_text = t256.dismiss_text
	end

	if t256.dismissText ~= nil then
		v2055.dismiss_text = t256.dismissText
	end

	if t256.user_id ~= nil then
		v2055.user_id = t256.user_id
	end

	if t256.userId ~= nil then
		v2055.user_id = t256.userId
	end

	if t256.cards ~= nil then
		local t257 = {}

		for _, v2058 in t256.cards do
			table.insert(t257, t1.CardContainerCardInputData.jsonDecode(v2058))
		end

		v2055.cards = t257
	end

	if t256.prompt_id ~= nil then
		v2055.prompt_id = t256.prompt_id
	end

	if t256.promptId ~= nil then
		v2055.prompt_id = t256.promptId
	end

	if t256.prompt_type ~= nil then
		v2055.prompt_type = t256.prompt_type
	end

	if t256.promptType ~= nil then
		v2055.prompt_type = t256.promptType
	end

	return v2055
end

t252.descriptor = {
	name = "CardContainerInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CardContainerInputData"
}
t1.CardContainerInputData = t252
typeRegistry.default:register(t1.CardContainerInputData)

local t258 = {}

t258.__index = t258

function t258.new(t259: {[any]: any}?) -- line: 13323
	-- upvalues: t258 (copy)
	return (setmetatable({
		title = if t259 ~= nil and t259.title ~= nil then t259.title else "",
		user_id = if t259 ~= nil and t259.user_id ~= nil then t259.user_id else "",
		description = if t259 ~= nil and t259.description ~= nil then t259.description else "",
		cta_text = if t259 ~= nil and t259.cta_text ~= nil then t259.cta_text else "",
		prompt_id = if t259 ~= nil and t259.prompt_id ~= nil then t259.prompt_id else "",
		prompt_type = if t259 ~= nil and t259.prompt_type ~= nil then t259.prompt_type else "",
		entity_id = if t259 ~= nil and t259.entity_id ~= nil then t259.entity_id else ""
	}, t258))
end
function t258.encode(p158) -- line: 13335
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n105 = 0

	if p158.title ~= nil and p158.title ~= "" then
		local v2063, v2064 = proto.writeTag(buf, n105, 1, proto.wireTypes.lengthDelimited)

		buf, n105 = proto.writeString(v2063, v2064, p158.title)
	end

	if p158.user_id ~= nil and p158.user_id ~= "" then
		local v2065, v2066 = proto.writeTag(buf, n105, 2, proto.wireTypes.lengthDelimited)

		buf, n105 = proto.writeString(v2065, v2066, p158.user_id)
	end

	if p158.description ~= nil and p158.description ~= "" then
		local v2067, v2068 = proto.writeTag(buf, n105, 3, proto.wireTypes.lengthDelimited)

		buf, n105 = proto.writeString(v2067, v2068, p158.description)
	end

	if p158.cta_text ~= nil and p158.cta_text ~= "" then
		local v2069, v2070 = proto.writeTag(buf, n105, 4, proto.wireTypes.lengthDelimited)

		buf, n105 = proto.writeString(v2069, v2070, p158.cta_text)
	end

	if p158.prompt_id ~= nil and p158.prompt_id ~= "" then
		local v2071, v2072 = proto.writeTag(buf, n105, 5, proto.wireTypes.lengthDelimited)

		buf, n105 = proto.writeString(v2071, v2072, p158.prompt_id)
	end

	if p158.prompt_type ~= nil and p158.prompt_type ~= "" then
		local v2073, v2074 = proto.writeTag(buf, n105, 6, proto.wireTypes.lengthDelimited)

		buf, n105 = proto.writeString(v2073, v2074, p158.prompt_type)
	end

	if p158.entity_id ~= nil and p158.entity_id ~= "" then
		local v2075, v2076 = proto.writeTag(buf, n105, 7, proto.wireTypes.lengthDelimited)

		buf, n105 = proto.writeString(v2075, v2076, p158.entity_id)
	end

	local buf57 = buffer.create(n105)

	buffer.copy(buf57, 0, buf, 0, n105)

	return buf57
end
function t258.decode(p159: buffer) -- line: 13379
	-- upvalues: t258 (copy), proto (copy)
	local v2079 = t258.new()
	local n106 = 0

	while n106 < buffer.len(p159) do
		local v2081, v2082

		v2081, v2082, n106 = proto.readTag(p159, n106)

		if v2082 == proto.wireTypes.varint then
			local v2083

			v2083, n106 = proto.readVarInt(p159, n106)
		elseif v2082 == proto.wireTypes.lengthDelimited then
			if v2081 == 1 then
				local v2084

				v2084, n106 = proto.readBuffer(p159, n106)
				v2079.title = buffer.tostring(v2084)
			elseif v2081 == 2 then
				local v2085

				v2085, n106 = proto.readBuffer(p159, n106)
				v2079.user_id = buffer.tostring(v2085)
			elseif v2081 == 3 then
				local v2086

				v2086, n106 = proto.readBuffer(p159, n106)
				v2079.description = buffer.tostring(v2086)
			elseif v2081 == 4 then
				local v2087

				v2087, n106 = proto.readBuffer(p159, n106)
				v2079.cta_text = buffer.tostring(v2087)
			elseif v2081 == 5 then
				local v2088

				v2088, n106 = proto.readBuffer(p159, n106)
				v2079.prompt_id = buffer.tostring(v2088)
			elseif v2081 == 6 then
				local v2089

				v2089, n106 = proto.readBuffer(p159, n106)
				v2079.prompt_type = buffer.tostring(v2089)
			elseif v2081 == 7 then
				local v2090

				v2090, n106 = proto.readBuffer(p159, n106)
				v2079.entity_id = buffer.tostring(v2090)
			else
				local v2091, v2092 = proto.readVarInt(p159, n106)

				n106 = v2092 + v2091
			end
		elseif v2082 == proto.wireTypes.i32 then
			local v2093

			v2093, n106 = proto.readFixed32(p159, n106)
		elseif v2082 == proto.wireTypes.i64 then
			local v2094

			v2094, n106 = proto.readFixed64(p159, n106)
		else
			error("Unsupported wire type: " .. v2082)
		end
	end

	return v2079
end
function t258.jsonEncode(p160) -- line: 13452
	local t260 = {}

	if p160.title ~= nil and p160.title ~= "" then
		t260.title = p160.title
	end

	if p160.user_id ~= nil and p160.user_id ~= "" then
		t260.userId = p160.user_id
	end

	if p160.description ~= nil and p160.description ~= "" then
		t260.description = p160.description
	end

	if p160.cta_text ~= nil and p160.cta_text ~= "" then
		t260.ctaText = p160.cta_text
	end

	if p160.prompt_id ~= nil and p160.prompt_id ~= "" then
		t260.promptId = p160.prompt_id
	end

	if p160.prompt_type ~= nil and p160.prompt_type ~= "" then
		t260.promptType = p160.prompt_type
	end

	if p160.entity_id ~= nil and p160.entity_id ~= "" then
		t260.entityId = p160.entity_id
	end

	return t260
end
function t258.jsonDecode(t261: {[any]: any}) -- line: 13486
	-- upvalues: t258 (copy)
	local v2098 = t258.new()

	if t261.title ~= nil then
		v2098.title = t261.title
	end

	if t261.user_id ~= nil then
		v2098.user_id = t261.user_id
	end

	if t261.userId ~= nil then
		v2098.user_id = t261.userId
	end

	if t261.description ~= nil then
		v2098.description = t261.description
	end

	if t261.cta_text ~= nil then
		v2098.cta_text = t261.cta_text
	end

	if t261.ctaText ~= nil then
		v2098.cta_text = t261.ctaText
	end

	if t261.prompt_id ~= nil then
		v2098.prompt_id = t261.prompt_id
	end

	if t261.promptId ~= nil then
		v2098.prompt_id = t261.promptId
	end

	if t261.prompt_type ~= nil then
		v2098.prompt_type = t261.prompt_type
	end

	if t261.promptType ~= nil then
		v2098.prompt_type = t261.promptType
	end

	if t261.entity_id ~= nil then
		v2098.entity_id = t261.entity_id
	end

	if t261.entityId ~= nil then
		v2098.entity_id = t261.entityId
	end

	return v2098
end

t258.descriptor = {
	name = "CardInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CardInputData"
}
t1.CardInputData = t258
typeRegistry.default:register(t1.CardInputData)

local t262 = {}

t262.__index = t262

function t262.new(t263: {[any]: any}?) -- line: 13554
	-- upvalues: t262 (copy)
	return (setmetatable({
		prompt_id = if t263 ~= nil and t263.prompt_id ~= nil then t263.prompt_id else "",
		prompt_type = if t263 ~= nil and t263.prompt_type ~= nil then t263.prompt_type else "",
		user_id = if t263 ~= nil and t263.user_id ~= nil then t263.user_id else "",
		audit_data = if t263 ~= nil and t263.audit_data ~= nil then t263.audit_data else ""
	}, t262))
end
function t262.encode(p161) -- line: 13563
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n107 = 0

	if p161.prompt_id ~= nil and p161.prompt_id ~= "" then
		local v2103, v2104 = proto.writeTag(buf, n107, 1, proto.wireTypes.lengthDelimited)

		buf, n107 = proto.writeString(v2103, v2104, p161.prompt_id)
	end

	if p161.prompt_type ~= nil and p161.prompt_type ~= "" then
		local v2105, v2106 = proto.writeTag(buf, n107, 2, proto.wireTypes.lengthDelimited)

		buf, n107 = proto.writeString(v2105, v2106, p161.prompt_type)
	end

	if p161.user_id ~= nil and p161.user_id ~= "" then
		local v2107, v2108 = proto.writeTag(buf, n107, 3, proto.wireTypes.lengthDelimited)

		buf, n107 = proto.writeString(v2107, v2108, p161.user_id)
	end

	if p161.audit_data ~= nil and p161.audit_data ~= "" then
		local v2109, v2110 = proto.writeTag(buf, n107, 4, proto.wireTypes.lengthDelimited)

		buf, n107 = proto.writeString(v2109, v2110, p161.audit_data)
	end

	local buf58 = buffer.create(n107)

	buffer.copy(buf58, 0, buf, 0, n107)

	return buf58
end
function t262.decode(p162: buffer) -- line: 13592
	-- upvalues: t262 (copy), proto (copy)
	local v2113 = t262.new()
	local n108 = 0

	while n108 < buffer.len(p162) do
		local v2115, v2116

		v2115, v2116, n108 = proto.readTag(p162, n108)

		if v2116 == proto.wireTypes.varint then
			local v2117

			v2117, n108 = proto.readVarInt(p162, n108)
		elseif v2116 == proto.wireTypes.lengthDelimited then
			if v2115 == 1 then
				local v2118

				v2118, n108 = proto.readBuffer(p162, n108)
				v2113.prompt_id = buffer.tostring(v2118)
			elseif v2115 == 2 then
				local v2119

				v2119, n108 = proto.readBuffer(p162, n108)
				v2113.prompt_type = buffer.tostring(v2119)
			elseif v2115 == 3 then
				local v2120

				v2120, n108 = proto.readBuffer(p162, n108)
				v2113.user_id = buffer.tostring(v2120)
			elseif v2115 == 4 then
				local v2121

				v2121, n108 = proto.readBuffer(p162, n108)
				v2113.audit_data = buffer.tostring(v2121)
			else
				local v2122, v2123 = proto.readVarInt(p162, n108)

				n108 = v2123 + v2122
			end
		elseif v2116 == proto.wireTypes.i32 then
			local v2124

			v2124, n108 = proto.readFixed32(p162, n108)
		elseif v2116 == proto.wireTypes.i64 then
			local v2125

			v2125, n108 = proto.readFixed64(p162, n108)
		else
			error("Unsupported wire type: " .. v2116)
		end
	end

	return v2113
end
function t262.jsonEncode(p163) -- line: 13650
	local t264 = {}

	if p163.prompt_id ~= nil and p163.prompt_id ~= "" then
		t264.promptId = p163.prompt_id
	end

	if p163.prompt_type ~= nil and p163.prompt_type ~= "" then
		t264.promptType = p163.prompt_type
	end

	if p163.user_id ~= nil and p163.user_id ~= "" then
		t264.userId = p163.user_id
	end

	if p163.audit_data ~= nil and p163.audit_data ~= "" then
		t264.auditData = p163.audit_data
	end

	return t264
end
function t262.jsonDecode(t265: {[any]: any}) -- line: 13672
	-- upvalues: t262 (copy)
	local v2129 = t262.new()

	if t265.prompt_id ~= nil then
		v2129.prompt_id = t265.prompt_id
	end

	if t265.promptId ~= nil then
		v2129.prompt_id = t265.promptId
	end

	if t265.prompt_type ~= nil then
		v2129.prompt_type = t265.prompt_type
	end

	if t265.promptType ~= nil then
		v2129.prompt_type = t265.promptType
	end

	if t265.user_id ~= nil then
		v2129.user_id = t265.user_id
	end

	if t265.userId ~= nil then
		v2129.user_id = t265.userId
	end

	if t265.audit_data ~= nil then
		v2129.audit_data = t265.audit_data
	end

	if t265.auditData ~= nil then
		v2129.audit_data = t265.auditData
	end

	return v2129
end

t262.descriptor = {
	name = "DialogInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.DialogInputData"
}
t1.DialogInputData = t262
typeRegistry.default:register(t1.DialogInputData)

local t266 = {}

t266.__index = t266

function t266.new(t267: {[any]: any}?) -- line: 13724
	-- upvalues: t266 (copy)
	return (setmetatable({
		sender_count = if t267 ~= nil and t267.sender_count ~= nil then t267.sender_count else 0,
		total_robux_amount = if t267 ~= nil and t267.total_robux_amount ~= nil then t267.total_robux_amount else 0
	}, t266))
end
function t266.encode(p164) -- line: 13731
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n109 = 0

	if p164.sender_count ~= nil and p164.sender_count ~= 0 then
		local v2134, v2135 = proto.writeTag(buf, n109, 1, proto.wireTypes.varint)

		buf, n109 = proto.writeVarInt(v2134, v2135, p164.sender_count)
	end

	if p164.total_robux_amount ~= nil and p164.total_robux_amount ~= 0 then
		local v2136, v2137 = proto.writeTag(buf, n109, 2, proto.wireTypes.varint)

		buf, n109 = proto.writeVarInt(v2136, v2137, p164.total_robux_amount)
	end

	local buf59 = buffer.create(n109)

	buffer.copy(buf59, 0, buf, 0, n109)

	return buf59
end
function t266.decode(p165: buffer) -- line: 13750
	-- upvalues: t266 (copy), proto (copy)
	local v2140 = t266.new()
	local n110 = 0

	while n110 < buffer.len(p165) do
		local v2142, v2143

		v2142, v2143, n110 = proto.readTag(p165, n110)

		if v2143 == proto.wireTypes.varint then
			if v2142 == 1 then
				local v2144

				v2144, n110 = proto.readVarIntI32(p165, n110)
				v2140.sender_count = v2144
			elseif v2142 == 2 then
				local v2145

				v2145, n110 = proto.readVarIntI64(p165, n110)
				v2140.total_robux_amount = v2145
			else
				local v2146

				v2146, n110 = proto.readVarInt(p165, n110)
			end
		elseif v2143 == proto.wireTypes.lengthDelimited then
			local v2147, v2148 = proto.readVarInt(p165, n110)

			n110 = v2148 + v2147
		elseif v2143 == proto.wireTypes.i32 then
			local v2149

			v2149, n110 = proto.readFixed32(p165, n110)
		elseif v2143 == proto.wireTypes.i64 then
			local v2150

			v2150, n110 = proto.readFixed64(p165, n110)
		else
			error("Unsupported wire type: " .. v2143)
		end
	end

	return v2140
end
function t266.jsonEncode(p166) -- line: 13798
	local t268 = {}

	if p166.sender_count ~= nil and p166.sender_count ~= 0 then
		t268.senderCount = p166.sender_count
	end

	if p166.total_robux_amount ~= nil and p166.total_robux_amount ~= 0 then
		t268.totalRobuxAmount = p166.total_robux_amount
	end

	return t268
end
function t266.jsonDecode(t269: {[any]: any}) -- line: 13812
	-- upvalues: t266 (copy)
	local v2154 = t266.new()

	if t269.sender_count ~= nil then
		v2154.sender_count = t269.sender_count
	end

	if t269.senderCount ~= nil then
		v2154.sender_count = t269.senderCount
	end

	if t269.total_robux_amount ~= nil then
		v2154.total_robux_amount = t269.total_robux_amount
	end

	if t269.totalRobuxAmount ~= nil then
		v2154.total_robux_amount = t269.totalRobuxAmount
	end

	return v2154
end

t266.descriptor = {
	name = "IncomingTransferContent",
	fullName = "roblox.apppageplatform.shared.v1beta1.IncomingTransferContent"
}
t1.IncomingTransferContent = t266
typeRegistry.default:register(t1.IncomingTransferContent)

local t270 = {}

t270.__index = t270

function t270.new(t271: {[any]: any}?) -- line: 13848
	-- upvalues: t270 (copy)
	return (setmetatable({
		title = if t271 ~= nil and t271.title ~= nil then t271.title else "",
		description = if t271 ~= nil and t271.description ~= nil then t271.description else "",
		primary_text = if t271 ~= nil and t271.primary_text ~= nil then t271.primary_text else "",
		secondary_text = if t271 ~= nil and t271.secondary_text ~= nil then t271.secondary_text else "",
		prompt_id = if t271 ~= nil and t271.prompt_id ~= nil then t271.prompt_id else "",
		prompt_type = if t271 ~= nil and t271.prompt_type ~= nil then t271.prompt_type else "",
		times_seen = if t271 ~= nil and t271.times_seen ~= nil then t271.times_seen else 0,
		content = if t271 ~= nil and t271.content ~= nil then t271.content else nil
	}, t270))
end
function t270.encode(p167) -- line: 13861
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n111 = 0

	if p167.title ~= nil and p167.title ~= "" then
		local v2159, v2160 = proto.writeTag(buf, n111, 1, proto.wireTypes.lengthDelimited)

		buf, n111 = proto.writeString(v2159, v2160, p167.title)
	end

	if p167.description ~= nil and p167.description ~= "" then
		local v2161, v2162 = proto.writeTag(buf, n111, 2, proto.wireTypes.lengthDelimited)

		buf, n111 = proto.writeString(v2161, v2162, p167.description)
	end

	if p167.primary_text ~= nil and p167.primary_text ~= "" then
		local v2163, v2164 = proto.writeTag(buf, n111, 3, proto.wireTypes.lengthDelimited)

		buf, n111 = proto.writeString(v2163, v2164, p167.primary_text)
	end

	if p167.secondary_text ~= nil and p167.secondary_text ~= "" then
		local v2165, v2166 = proto.writeTag(buf, n111, 4, proto.wireTypes.lengthDelimited)

		buf, n111 = proto.writeString(v2165, v2166, p167.secondary_text)
	end

	if p167.prompt_id ~= nil and p167.prompt_id ~= "" then
		local v2167, v2168 = proto.writeTag(buf, n111, 5, proto.wireTypes.lengthDelimited)

		buf, n111 = proto.writeString(v2167, v2168, p167.prompt_id)
	end

	if p167.prompt_type ~= nil and p167.prompt_type ~= "" then
		local v2169, v2170 = proto.writeTag(buf, n111, 6, proto.wireTypes.lengthDelimited)

		buf, n111 = proto.writeString(v2169, v2170, p167.prompt_type)
	end

	if p167.times_seen ~= nil and p167.times_seen ~= 0 then
		local v2171, v2172 = proto.writeTag(buf, n111, 7, proto.wireTypes.varint)

		buf, n111 = proto.writeVarInt(v2171, v2172, p167.times_seen)
	end

	if p167.content ~= nil and p167.content.type == "incoming_transfer_content" then
		local v2173 = p167.content.value:encode()
		local v2174, v2175 = proto.writeTag(buf, n111, 8, proto.wireTypes.lengthDelimited)

		buf, n111 = proto.writeBuffer(v2174, v2175, v2173, buffer.len(v2173))
	end

	local buf60 = buffer.create(n111)

	buffer.copy(buf60, 0, buf, 0, n111)

	return buf60
end
function t270.decode(p168: buffer) -- line: 13913
	-- upvalues: t270 (copy), proto (copy), t1 (copy)
	local v2178 = t270.new()
	local n112 = 0

	while n112 < buffer.len(p168) do
		local v2180, v2181

		v2180, v2181, n112 = proto.readTag(p168, n112)

		if v2181 == proto.wireTypes.varint then
			if v2180 == 7 then
				local v2182

				v2182, n112 = proto.readVarIntI32(p168, n112)
				v2178.times_seen = v2182
			else
				local v2183

				v2183, n112 = proto.readVarInt(p168, n112)
			end
		elseif v2181 == proto.wireTypes.lengthDelimited then
			if v2180 == 1 then
				local v2184

				v2184, n112 = proto.readBuffer(p168, n112)
				v2178.title = buffer.tostring(v2184)
			elseif v2180 == 2 then
				local v2185

				v2185, n112 = proto.readBuffer(p168, n112)
				v2178.description = buffer.tostring(v2185)
			elseif v2180 == 3 then
				local v2186

				v2186, n112 = proto.readBuffer(p168, n112)
				v2178.primary_text = buffer.tostring(v2186)
			elseif v2180 == 4 then
				local v2187

				v2187, n112 = proto.readBuffer(p168, n112)
				v2178.secondary_text = buffer.tostring(v2187)
			elseif v2180 == 5 then
				local v2188

				v2188, n112 = proto.readBuffer(p168, n112)
				v2178.prompt_id = buffer.tostring(v2188)
			elseif v2180 == 6 then
				local v2189

				v2189, n112 = proto.readBuffer(p168, n112)
				v2178.prompt_type = buffer.tostring(v2189)
			elseif v2180 == 8 then
				local v2190

				v2190, n112 = proto.readBuffer(p168, n112)
				v2178.content = {
					type = "incoming_transfer_content",
					value = t1.IncomingTransferContent.decode(v2190)
				}
			else
				local v2191, v2192 = proto.readVarInt(p168, n112)

				n112 = v2192 + v2191
			end
		elseif v2181 == proto.wireTypes.i32 then
			local v2193

			v2193, n112 = proto.readFixed32(p168, n112)
		elseif v2181 == proto.wireTypes.i64 then
			local v2194

			v2194, n112 = proto.readFixed64(p168, n112)
		else
			error("Unsupported wire type: " .. v2181)
		end
	end

	return v2178
end
function t270.jsonEncode(p169) -- line: 13992
	local t272 = {}

	if p169.title ~= nil and p169.title ~= "" then
		t272.title = p169.title
	end

	if p169.description ~= nil and p169.description ~= "" then
		t272.description = p169.description
	end

	if p169.primary_text ~= nil and p169.primary_text ~= "" then
		t272.primaryText = p169.primary_text
	end

	if p169.secondary_text ~= nil and p169.secondary_text ~= "" then
		t272.secondaryText = p169.secondary_text
	end

	if p169.prompt_id ~= nil and p169.prompt_id ~= "" then
		t272.promptId = p169.prompt_id
	end

	if p169.prompt_type ~= nil and p169.prompt_type ~= "" then
		t272.promptType = p169.prompt_type
	end

	if p169.times_seen ~= nil and p169.times_seen ~= 0 then
		t272.timesSeen = p169.times_seen
	end

	if p169.content ~= nil and p169.content.type == "incoming_transfer_content" then
		t272.incomingTransferContent = p169.content.value:jsonEncode()
	end

	return t272
end
function t270.jsonDecode(t273: {[any]: any}) -- line: 14032
	-- upvalues: t270 (copy), t1 (copy)
	local v2198 = t270.new()

	if t273.title ~= nil then
		v2198.title = t273.title
	end

	if t273.description ~= nil then
		v2198.description = t273.description
	end

	if t273.primary_text ~= nil then
		v2198.primary_text = t273.primary_text
	end

	if t273.primaryText ~= nil then
		v2198.primary_text = t273.primaryText
	end

	if t273.secondary_text ~= nil then
		v2198.secondary_text = t273.secondary_text
	end

	if t273.secondaryText ~= nil then
		v2198.secondary_text = t273.secondaryText
	end

	if t273.prompt_id ~= nil then
		v2198.prompt_id = t273.prompt_id
	end

	if t273.promptId ~= nil then
		v2198.prompt_id = t273.promptId
	end

	if t273.prompt_type ~= nil then
		v2198.prompt_type = t273.prompt_type
	end

	if t273.promptType ~= nil then
		v2198.prompt_type = t273.promptType
	end

	if t273.times_seen ~= nil then
		v2198.times_seen = t273.times_seen
	end

	if t273.timesSeen ~= nil then
		v2198.times_seen = t273.timesSeen
	end

	if t273.incoming_transfer_content ~= nil then
		v2198.content = {
			type = "incoming_transfer_content",
			value = t1.IncomingTransferContent.jsonDecode(t273.incoming_transfer_content)
		}
	end

	if t273.incomingTransferContent ~= nil then
		v2198.content = {
			type = "incoming_transfer_content",
			value = t1.IncomingTransferContent.jsonDecode(t273.incomingTransferContent)
		}
	end

	return v2198
end

t270.descriptor = {
	name = "BannerInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.BannerInputData"
}
t1.BannerInputData = t270
typeRegistry.default:register(t1.BannerInputData)

local t274 = {}

t274.__index = t274

function t274.new(t275: {[any]: any}?) -- line: 14114
	-- upvalues: t274 (copy)
	return (setmetatable({
		tooltip_text = if t275 ~= nil and t275.tooltip_text ~= nil then t275.tooltip_text else "",
		prompt_id = if t275 ~= nil and t275.prompt_id ~= nil then t275.prompt_id else "",
		prompt_type = if t275 ~= nil and t275.prompt_type ~= nil then t275.prompt_type else ""
	}, t274))
end
function t274.encode(p170) -- line: 14122
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n113 = 0

	if p170.tooltip_text ~= nil and p170.tooltip_text ~= "" then
		local v2203, v2204 = proto.writeTag(buf, n113, 1, proto.wireTypes.lengthDelimited)

		buf, n113 = proto.writeString(v2203, v2204, p170.tooltip_text)
	end

	if p170.prompt_id ~= nil and p170.prompt_id ~= "" then
		local v2205, v2206 = proto.writeTag(buf, n113, 2, proto.wireTypes.lengthDelimited)

		buf, n113 = proto.writeString(v2205, v2206, p170.prompt_id)
	end

	if p170.prompt_type ~= nil and p170.prompt_type ~= "" then
		local v2207, v2208 = proto.writeTag(buf, n113, 3, proto.wireTypes.lengthDelimited)

		buf, n113 = proto.writeString(v2207, v2208, p170.prompt_type)
	end

	local buf61 = buffer.create(n113)

	buffer.copy(buf61, 0, buf, 0, n113)

	return buf61
end
function t274.decode(p171: buffer) -- line: 14146
	-- upvalues: t274 (copy), proto (copy)
	local v2211 = t274.new()
	local n114 = 0

	while n114 < buffer.len(p171) do
		local v2213, v2214

		v2213, v2214, n114 = proto.readTag(p171, n114)

		if v2214 == proto.wireTypes.varint then
			local v2215

			v2215, n114 = proto.readVarInt(p171, n114)
		elseif v2214 == proto.wireTypes.lengthDelimited then
			if v2213 == 1 then
				local v2216

				v2216, n114 = proto.readBuffer(p171, n114)
				v2211.tooltip_text = buffer.tostring(v2216)
			elseif v2213 == 2 then
				local v2217

				v2217, n114 = proto.readBuffer(p171, n114)
				v2211.prompt_id = buffer.tostring(v2217)
			elseif v2213 == 3 then
				local v2218

				v2218, n114 = proto.readBuffer(p171, n114)
				v2211.prompt_type = buffer.tostring(v2218)
			else
				local v2219, v2220 = proto.readVarInt(p171, n114)

				n114 = v2220 + v2219
			end
		elseif v2214 == proto.wireTypes.i32 then
			local v2221

			v2221, n114 = proto.readFixed32(p171, n114)
		elseif v2214 == proto.wireTypes.i64 then
			local v2222

			v2222, n114 = proto.readFixed64(p171, n114)
		else
			error("Unsupported wire type: " .. v2214)
		end
	end

	return v2211
end
function t274.jsonEncode(p172) -- line: 14199
	local t276 = {}

	if p172.tooltip_text ~= nil and p172.tooltip_text ~= "" then
		t276.tooltipText = p172.tooltip_text
	end

	if p172.prompt_id ~= nil and p172.prompt_id ~= "" then
		t276.promptId = p172.prompt_id
	end

	if p172.prompt_type ~= nil and p172.prompt_type ~= "" then
		t276.promptType = p172.prompt_type
	end

	return t276
end
function t274.jsonDecode(t277: {[any]: any}) -- line: 14217
	-- upvalues: t274 (copy)
	local v2226 = t274.new()

	if t277.tooltip_text ~= nil then
		v2226.tooltip_text = t277.tooltip_text
	end

	if t277.tooltipText ~= nil then
		v2226.tooltip_text = t277.tooltipText
	end

	if t277.prompt_id ~= nil then
		v2226.prompt_id = t277.prompt_id
	end

	if t277.promptId ~= nil then
		v2226.prompt_id = t277.promptId
	end

	if t277.prompt_type ~= nil then
		v2226.prompt_type = t277.prompt_type
	end

	if t277.promptType ~= nil then
		v2226.prompt_type = t277.promptType
	end

	return v2226
end

t274.descriptor = {
	name = "TooltipInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.TooltipInputData"
}
t1.TooltipInputData = t274
typeRegistry.default:register(t1.TooltipInputData)

local t278 = {}

t278.__index = t278

function t278.new(t279: {[any]: any}?) -- line: 14261
	-- upvalues: t278 (copy)
	return (setmetatable({
		media_id = if t279 ~= nil and t279.media_id ~= nil then t279.media_id else "",
		title = if t279 ~= nil and t279.title ~= nil then t279.title else "",
		description = if t279 ~= nil and t279.description ~= nil then t279.description else "",
		prompt_id = if t279 ~= nil and t279.prompt_id ~= nil then t279.prompt_id else "",
		prompt_type = if t279 ~= nil and t279.prompt_type ~= nil then t279.prompt_type else "",
		anchor_tag = if t279 ~= nil and t279.anchor_tag ~= nil then t279.anchor_tag else ""
	}, t278))
end
function t278.encode(p173) -- line: 14272
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n115 = 0

	if p173.media_id ~= nil and p173.media_id ~= "" then
		local v2231, v2232 = proto.writeTag(buf, n115, 1, proto.wireTypes.lengthDelimited)

		buf, n115 = proto.writeString(v2231, v2232, p173.media_id)
	end

	if p173.title ~= nil and p173.title ~= "" then
		local v2233, v2234 = proto.writeTag(buf, n115, 2, proto.wireTypes.lengthDelimited)

		buf, n115 = proto.writeString(v2233, v2234, p173.title)
	end

	if p173.description ~= nil and p173.description ~= "" then
		local v2235, v2236 = proto.writeTag(buf, n115, 3, proto.wireTypes.lengthDelimited)

		buf, n115 = proto.writeString(v2235, v2236, p173.description)
	end

	if p173.prompt_id ~= nil and p173.prompt_id ~= "" then
		local v2237, v2238 = proto.writeTag(buf, n115, 4, proto.wireTypes.lengthDelimited)

		buf, n115 = proto.writeString(v2237, v2238, p173.prompt_id)
	end

	if p173.prompt_type ~= nil and p173.prompt_type ~= "" then
		local v2239, v2240 = proto.writeTag(buf, n115, 5, proto.wireTypes.lengthDelimited)

		buf, n115 = proto.writeString(v2239, v2240, p173.prompt_type)
	end

	if p173.anchor_tag ~= nil and p173.anchor_tag ~= "" then
		local v2241, v2242 = proto.writeTag(buf, n115, 6, proto.wireTypes.lengthDelimited)

		buf, n115 = proto.writeString(v2241, v2242, p173.anchor_tag)
	end

	local buf62 = buffer.create(n115)

	buffer.copy(buf62, 0, buf, 0, n115)

	return buf62
end
function t278.decode(p174: buffer) -- line: 14311
	-- upvalues: t278 (copy), proto (copy)
	local v2245 = t278.new()
	local n116 = 0

	while n116 < buffer.len(p174) do
		local v2247, v2248

		v2247, v2248, n116 = proto.readTag(p174, n116)

		if v2248 == proto.wireTypes.varint then
			local v2249

			v2249, n116 = proto.readVarInt(p174, n116)
		elseif v2248 == proto.wireTypes.lengthDelimited then
			if v2247 == 1 then
				local v2250

				v2250, n116 = proto.readBuffer(p174, n116)
				v2245.media_id = buffer.tostring(v2250)
			elseif v2247 == 2 then
				local v2251

				v2251, n116 = proto.readBuffer(p174, n116)
				v2245.title = buffer.tostring(v2251)
			elseif v2247 == 3 then
				local v2252

				v2252, n116 = proto.readBuffer(p174, n116)
				v2245.description = buffer.tostring(v2252)
			elseif v2247 == 4 then
				local v2253

				v2253, n116 = proto.readBuffer(p174, n116)
				v2245.prompt_id = buffer.tostring(v2253)
			elseif v2247 == 5 then
				local v2254

				v2254, n116 = proto.readBuffer(p174, n116)
				v2245.prompt_type = buffer.tostring(v2254)
			elseif v2247 == 6 then
				local v2255

				v2255, n116 = proto.readBuffer(p174, n116)
				v2245.anchor_tag = buffer.tostring(v2255)
			else
				local v2256, v2257 = proto.readVarInt(p174, n116)

				n116 = v2257 + v2256
			end
		elseif v2248 == proto.wireTypes.i32 then
			local v2258

			v2258, n116 = proto.readFixed32(p174, n116)
		elseif v2248 == proto.wireTypes.i64 then
			local v2259

			v2259, n116 = proto.readFixed64(p174, n116)
		else
			error("Unsupported wire type: " .. v2248)
		end
	end

	return v2245
end
function t278.jsonEncode(p175) -- line: 14379
	local t280 = {}

	if p175.media_id ~= nil and p175.media_id ~= "" then
		t280.mediaId = p175.media_id
	end

	if p175.title ~= nil and p175.title ~= "" then
		t280.title = p175.title
	end

	if p175.description ~= nil and p175.description ~= "" then
		t280.description = p175.description
	end

	if p175.prompt_id ~= nil and p175.prompt_id ~= "" then
		t280.promptId = p175.prompt_id
	end

	if p175.prompt_type ~= nil and p175.prompt_type ~= "" then
		t280.promptType = p175.prompt_type
	end

	if p175.anchor_tag ~= nil and p175.anchor_tag ~= "" then
		t280.anchorTag = p175.anchor_tag
	end

	return t280
end
function t278.jsonDecode(t281: {[any]: any}) -- line: 14409
	-- upvalues: t278 (copy)
	local v2263 = t278.new()

	if t281.media_id ~= nil then
		v2263.media_id = t281.media_id
	end

	if t281.mediaId ~= nil then
		v2263.media_id = t281.mediaId
	end

	if t281.title ~= nil then
		v2263.title = t281.title
	end

	if t281.description ~= nil then
		v2263.description = t281.description
	end

	if t281.prompt_id ~= nil then
		v2263.prompt_id = t281.prompt_id
	end

	if t281.promptId ~= nil then
		v2263.prompt_id = t281.promptId
	end

	if t281.prompt_type ~= nil then
		v2263.prompt_type = t281.prompt_type
	end

	if t281.promptType ~= nil then
		v2263.prompt_type = t281.promptType
	end

	if t281.anchor_tag ~= nil then
		v2263.anchor_tag = t281.anchor_tag
	end

	if t281.anchorTag ~= nil then
		v2263.anchor_tag = t281.anchorTag
	end

	return v2263
end

t278.descriptor = {
	name = "CoachmarkInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CoachmarkInputData"
}
t1.CoachmarkInputData = t278
typeRegistry.default:register(t1.CoachmarkInputData)

local t282 = {}

t282.__index = t282

function t282.new(t283: {[any]: any}?) -- line: 14469
	-- upvalues: t282 (copy)
	return (setmetatable({
		prompt_id = if t283 ~= nil and t283.prompt_id ~= nil then t283.prompt_id else "",
		prompt_type = if t283 ~= nil and t283.prompt_type ~= nil then t283.prompt_type else ""
	}, t282))
end
function t282.encode(p176) -- line: 14476
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n117 = 0

	if p176.prompt_id ~= nil and p176.prompt_id ~= "" then
		local v2268, v2269 = proto.writeTag(buf, n117, 1, proto.wireTypes.lengthDelimited)

		buf, n117 = proto.writeString(v2268, v2269, p176.prompt_id)
	end

	if p176.prompt_type ~= nil and p176.prompt_type ~= "" then
		local v2270, v2271 = proto.writeTag(buf, n117, 2, proto.wireTypes.lengthDelimited)

		buf, n117 = proto.writeString(v2270, v2271, p176.prompt_type)
	end

	local buf63 = buffer.create(n117)

	buffer.copy(buf63, 0, buf, 0, n117)

	return buf63
end
function t282.decode(p177: buffer) -- line: 14495
	-- upvalues: t282 (copy), proto (copy)
	local v2274 = t282.new()
	local n118 = 0

	while n118 < buffer.len(p177) do
		local v2276, v2277

		v2276, v2277, n118 = proto.readTag(p177, n118)

		if v2277 == proto.wireTypes.varint then
			local v2278

			v2278, n118 = proto.readVarInt(p177, n118)
		elseif v2277 == proto.wireTypes.lengthDelimited then
			if v2276 == 1 then
				local v2279

				v2279, n118 = proto.readBuffer(p177, n118)
				v2274.prompt_id = buffer.tostring(v2279)
			elseif v2276 == 2 then
				local v2280

				v2280, n118 = proto.readBuffer(p177, n118)
				v2274.prompt_type = buffer.tostring(v2280)
			else
				local v2281, v2282 = proto.readVarInt(p177, n118)

				n118 = v2282 + v2281
			end
		elseif v2277 == proto.wireTypes.i32 then
			local v2283

			v2283, n118 = proto.readFixed32(p177, n118)
		elseif v2277 == proto.wireTypes.i64 then
			local v2284

			v2284, n118 = proto.readFixed64(p177, n118)
		else
			error("Unsupported wire type: " .. v2277)
		end
	end

	return v2274
end
function t282.jsonEncode(p178) -- line: 14543
	local t284 = {}

	if p178.prompt_id ~= nil and p178.prompt_id ~= "" then
		t284.promptId = p178.prompt_id
	end

	if p178.prompt_type ~= nil and p178.prompt_type ~= "" then
		t284.promptType = p178.prompt_type
	end

	return t284
end
function t282.jsonDecode(t285: {[any]: any}) -- line: 14557
	-- upvalues: t282 (copy)
	local v2288 = t282.new()

	if t285.prompt_id ~= nil then
		v2288.prompt_id = t285.prompt_id
	end

	if t285.promptId ~= nil then
		v2288.prompt_id = t285.promptId
	end

	if t285.prompt_type ~= nil then
		v2288.prompt_type = t285.prompt_type
	end

	if t285.promptType ~= nil then
		v2288.prompt_type = t285.promptType
	end

	return v2288
end

t282.descriptor = {
	name = "SystemBannerInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.SystemBannerInputData"
}
t1.SystemBannerInputData = t282
typeRegistry.default:register(t1.SystemBannerInputData)

local t286 = {}

t286.__index = t286

function t286.new(t287: {[any]: any}?) -- line: 14593
	-- upvalues: t286 (copy)
	return (setmetatable({
		upsell_prompt = if t287 ~= nil and t287.upsell_prompt ~= nil then t287.upsell_prompt else ""
	}, t286))
end
function t286.encode(p179) -- line: 14599
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n119 = 0

	if p179.upsell_prompt ~= nil and p179.upsell_prompt ~= "" then
		local v2293, v2294 = proto.writeTag(buf, n119, 1, proto.wireTypes.lengthDelimited)

		buf, n119 = proto.writeString(v2293, v2294, p179.upsell_prompt)
	end

	local buf64 = buffer.create(n119)

	buffer.copy(buf64, 0, buf, 0, n119)

	return buf64
end
function t286.decode(p180: buffer) -- line: 14613
	-- upvalues: t286 (copy), proto (copy)
	local v2297 = t286.new()
	local n120 = 0

	while n120 < buffer.len(p180) do
		local v2299, v2300

		v2299, v2300, n120 = proto.readTag(p180, n120)

		if v2300 == proto.wireTypes.varint then
			local v2301

			v2301, n120 = proto.readVarInt(p180, n120)
		elseif v2300 == proto.wireTypes.lengthDelimited then
			if v2299 == 1 then
				local v2302

				v2302, n120 = proto.readBuffer(p180, n120)
				v2297.upsell_prompt = buffer.tostring(v2302)
			else
				local v2303, v2304 = proto.readVarInt(p180, n120)

				n120 = v2304 + v2303
			end
		elseif v2300 == proto.wireTypes.i32 then
			local v2305

			v2305, n120 = proto.readFixed32(p180, n120)
		elseif v2300 == proto.wireTypes.i64 then
			local v2306

			v2306, n120 = proto.readFixed64(p180, n120)
		else
			error("Unsupported wire type: " .. v2300)
		end
	end

	return v2297
end
function t286.jsonEncode(p181) -- line: 14656
	local t288 = {}

	if p181.upsell_prompt ~= nil and p181.upsell_prompt ~= "" then
		t288.upsellPrompt = p181.upsell_prompt
	end

	return t288
end
function t286.jsonDecode(t289: {[any]: any}) -- line: 14666
	-- upvalues: t286 (copy)
	local v2310 = t286.new()

	if t289.upsell_prompt ~= nil then
		v2310.upsell_prompt = t289.upsell_prompt
	end

	if t289.upsellPrompt ~= nil then
		v2310.upsell_prompt = t289.upsellPrompt
	end

	return v2310
end

t286.descriptor = {
	name = "AgeCheckUpsellInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.AgeCheckUpsellInputData"
}
t1.AgeCheckUpsellInputData = t286
typeRegistry.default:register(t1.AgeCheckUpsellInputData)

local t290 = {}

t290.__index = t290

function t290.new(t291: {[any]: any}?) -- line: 14694
	-- upvalues: t290 (copy)
	return (setmetatable({
		modal_variant = if t291 ~= nil and t291.modal_variant ~= nil then t291.modal_variant else "",
		modal_sequence = if t291 ~= nil and t291.modal_sequence ~= nil then t291.modal_sequence else "",
		conversation_id = if t291 ~= nil and t291.conversation_id ~= nil then t291.conversation_id else "",
		friend_id = if t291 ~= nil and t291.friend_id ~= nil then t291.friend_id else ""
	}, t290))
end
function t290.encode(p182) -- line: 14705
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n121 = 0

	if p182.modal_variant ~= nil and p182.modal_variant ~= "" then
		local v2315, v2316 = proto.writeTag(buf, n121, 1, proto.wireTypes.lengthDelimited)

		buf, n121 = proto.writeString(v2315, v2316, p182.modal_variant)
	end

	if p182.modal_sequence ~= nil and p182.modal_sequence ~= "" then
		local v2317, v2318 = proto.writeTag(buf, n121, 2, proto.wireTypes.lengthDelimited)

		buf, n121 = proto.writeString(v2317, v2318, p182.modal_sequence)
	end

	if p182.conversation_id ~= nil and p182.conversation_id ~= "" then
		local v2319, v2320 = proto.writeTag(buf, n121, 3, proto.wireTypes.lengthDelimited)

		buf, n121 = proto.writeString(v2319, v2320, p182.conversation_id)
	end

	if p182.friend_id ~= nil and p182.friend_id ~= "" then
		local v2321, v2322 = proto.writeTag(buf, n121, 4, proto.wireTypes.lengthDelimited)

		buf, n121 = proto.writeString(v2321, v2322, p182.friend_id)
	end

	local buf65 = buffer.create(n121)

	buffer.copy(buf65, 0, buf, 0, n121)

	return buf65
end
function t290.decode(p183: buffer) -- line: 14734
	-- upvalues: t290 (copy), proto (copy)
	local v2325 = t290.new()
	local n122 = 0

	while n122 < buffer.len(p183) do
		local v2327, v2328

		v2327, v2328, n122 = proto.readTag(p183, n122)

		if v2328 == proto.wireTypes.varint then
			local v2329

			v2329, n122 = proto.readVarInt(p183, n122)
		elseif v2328 == proto.wireTypes.lengthDelimited then
			if v2327 == 1 then
				local v2330

				v2330, n122 = proto.readBuffer(p183, n122)
				v2325.modal_variant = buffer.tostring(v2330)
			elseif v2327 == 2 then
				local v2331

				v2331, n122 = proto.readBuffer(p183, n122)
				v2325.modal_sequence = buffer.tostring(v2331)
			elseif v2327 == 3 then
				local v2332

				v2332, n122 = proto.readBuffer(p183, n122)
				v2325.conversation_id = buffer.tostring(v2332)
			elseif v2327 == 4 then
				local v2333

				v2333, n122 = proto.readBuffer(p183, n122)
				v2325.friend_id = buffer.tostring(v2333)
			else
				local v2334, v2335 = proto.readVarInt(p183, n122)

				n122 = v2335 + v2334
			end
		elseif v2328 == proto.wireTypes.i32 then
			local v2336

			v2336, n122 = proto.readFixed32(p183, n122)
		elseif v2328 == proto.wireTypes.i64 then
			local v2337

			v2337, n122 = proto.readFixed64(p183, n122)
		else
			error("Unsupported wire type: " .. v2328)
		end
	end

	return v2325
end
function t290.jsonEncode(p184) -- line: 14792
	local t292 = {}

	if p184.modal_variant ~= nil and p184.modal_variant ~= "" then
		t292.modalVariant = p184.modal_variant
	end

	if p184.modal_sequence ~= nil and p184.modal_sequence ~= "" then
		t292.modalSequence = p184.modal_sequence
	end

	if p184.conversation_id ~= nil and p184.conversation_id ~= "" then
		t292.conversationId = p184.conversation_id
	end

	if p184.friend_id ~= nil and p184.friend_id ~= "" then
		t292.friendId = p184.friend_id
	end

	return t292
end
function t290.jsonDecode(t293: {[any]: any}) -- line: 14814
	-- upvalues: t290 (copy)
	local v2341 = t290.new()

	if t293.modal_variant ~= nil then
		v2341.modal_variant = t293.modal_variant
	end

	if t293.modalVariant ~= nil then
		v2341.modal_variant = t293.modalVariant
	end

	if t293.modal_sequence ~= nil then
		v2341.modal_sequence = t293.modal_sequence
	end

	if t293.modalSequence ~= nil then
		v2341.modal_sequence = t293.modalSequence
	end

	if t293.conversation_id ~= nil then
		v2341.conversation_id = t293.conversation_id
	end

	if t293.conversationId ~= nil then
		v2341.conversation_id = t293.conversationId
	end

	if t293.friend_id ~= nil then
		v2341.friend_id = t293.friend_id
	end

	if t293.friendId ~= nil then
		v2341.friend_id = t293.friendId
	end

	return v2341
end

t290.descriptor = {
	name = "PartyChatConversationUpsellInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.PartyChatConversationUpsellInputData"
}
t1.PartyChatConversationUpsellInputData = t290
typeRegistry.default:register(t1.PartyChatConversationUpsellInputData)

local t294 = {}

t294.__index = t294

function t294.new(t295: {[any]: any}?) -- line: 14868
	-- upvalues: t294 (copy)
	return (setmetatable({
		event_id = if t295 ~= nil and t295.event_id ~= nil then t295.event_id else "",
		universe_id = if t295 ~= nil and t295.universe_id ~= nil then t295.universe_id else "",
		entry_map = if t295 ~= nil and t295.entry_map ~= nil then t295.entry_map else {},
		entry_order = if t295 ~= nil and t295.entry_order ~= nil then t295.entry_order else {}
	}, t294))
end
function t294.encode(p185) -- line: 14879
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n123 = 0

	if p185.event_id ~= nil and p185.event_id ~= "" then
		local v2346, v2347 = proto.writeTag(buf, n123, 1, proto.wireTypes.lengthDelimited)

		buf, n123 = proto.writeString(v2346, v2347, p185.event_id)
	end

	if p185.universe_id ~= nil and p185.universe_id ~= "" then
		local v2348, v2349 = proto.writeTag(buf, n123, 2, proto.wireTypes.lengthDelimited)

		buf, n123 = proto.writeString(v2348, v2349, p185.universe_id)
	end

	if p185.entry_map ~= nil and next(p185.entry_map) ~= nil then
		for v2350, v2351 in p185.entry_map do
			local buf66 = buffer.create(0)
			local v2353, v2354 = proto.writeTag(buf66, 0, 1, proto.wireTypes.lengthDelimited)
			local v2355, v2356 = proto.writeString(v2353, v2354, v2350)
			local v2357 = v2351:encode()
			local v2358, v2359 = proto.writeTag(v2355, v2356, 2, proto.wireTypes.lengthDelimited)
			local v2360, v2361 = proto.writeBuffer(v2358, v2359, v2357, buffer.len(v2357))
			local v2362, v2363 = proto.writeTag(buf, n123, 3, proto.wireTypes.lengthDelimited)

			buf, n123 = proto.writeBuffer(v2362, v2363, v2360, v2361)
		end
	end

	if p185.entry_order ~= nil and #p185.entry_order > 0 then
		for _, v2365 in p185.entry_order do
			local v2366, v2367 = proto.writeTag(buf, n123, 4, proto.wireTypes.lengthDelimited)

			buf, n123 = proto.writeString(v2366, v2367, v2365)
		end
	end

	local buf67 = buffer.create(n123)

	buffer.copy(buf67, 0, buf, 0, n123)

	return buf67
end
function t294.decode(p186: buffer) -- line: 14919
	-- upvalues: t294 (copy), proto (copy), t1 (copy)
	local v2370 = t294.new()
	local n124 = 0

	while n124 < buffer.len(p186) do
		local v2372, v2373

		v2372, v2373, n124 = proto.readTag(p186, n124)

		if v2373 == proto.wireTypes.varint then
			local v2374

			v2374, n124 = proto.readVarInt(p186, n124)
		elseif v2373 == proto.wireTypes.lengthDelimited then
			if v2372 == 1 then
				local v2375

				v2375, n124 = proto.readBuffer(p186, n124)
				v2370.event_id = buffer.tostring(v2375)
			elseif v2372 == 2 then
				local v2376

				v2376, n124 = proto.readBuffer(p186, n124)
				v2370.universe_id = buffer.tostring(v2376)
			elseif v2372 == 3 then
				local v2377

				v2377, n124 = proto.readBuffer(p186, n124)

				local v2378 = t1.EventDetailsFeedInputData_EntryMapEntry.decode(v2377)
				local v2379 = t1.FeedEntry.new()

				v2370.entry_map[v2378.key or ""] = v2378.value or v2379
			elseif v2372 == 4 then
				local v2380

				v2380, n124 = proto.readBuffer(p186, n124)
				table.insert(v2370.entry_order, buffer.tostring(v2380))
			else
				local v2381, v2382 = proto.readVarInt(p186, n124)

				n124 = v2382 + v2381
			end
		elseif v2373 == proto.wireTypes.i32 then
			local v2383

			v2383, n124 = proto.readFixed32(p186, n124)
		elseif v2373 == proto.wireTypes.i64 then
			local v2384

			v2384, n124 = proto.readFixed64(p186, n124)
		else
			error("Unsupported wire type: " .. v2373)
		end
	end

	return v2370
end
function t294.jsonEncode(p187) -- line: 14984
	local t296 = {}

	if p187.event_id ~= nil and p187.event_id ~= "" then
		t296.eventId = p187.event_id
	end

	if p187.universe_id ~= nil and p187.universe_id ~= "" then
		t296.universeId = p187.universe_id
	end

	if p187.entry_map ~= nil and next(p187.entry_map) ~= nil then
		local t297 = {}

		for v2388, v2389 in p187.entry_map do
			t297[v2388] = v2389:jsonEncode()
		end

		t296.entryMap = t297
	end

	if p187.entry_order ~= nil and #p187.entry_order > 0 then
		local t298 = {}

		for _, v2392 in p187.entry_order do
			table.insert(t298, v2392)
		end

		t296.entryOrder = t298
	end

	return t296
end
function t294.jsonDecode(t299: {[any]: any}) -- line: 15014
	-- upvalues: t294 (copy), t1 (copy)
	local v2394 = t294.new()

	if t299.event_id ~= nil then
		v2394.event_id = t299.event_id
	end

	if t299.eventId ~= nil then
		v2394.event_id = t299.eventId
	end

	if t299.universe_id ~= nil then
		v2394.universe_id = t299.universe_id
	end

	if t299.universeId ~= nil then
		v2394.universe_id = t299.universeId
	end

	if t299.entry_map ~= nil then
		local t300 = {}

		for v2396, v2397 in t299.entry_map do
			t300[v2396] = t1.FeedEntry.jsonDecode(v2397)
		end

		v2394.entry_map = t300
	end

	if t299.entryMap ~= nil then
		local t301 = {}

		for v2399, v2400 in t299.entryMap do
			t301[v2399] = t1.FeedEntry.jsonDecode(v2400)
		end

		v2394.entry_map = t301
	end

	if t299.entry_order ~= nil then
		local t302 = {}

		for _, v2403 in t299.entry_order do
			table.insert(t302, v2403)
		end

		v2394.entry_order = t302
	end

	if t299.entryOrder ~= nil then
		local t303 = {}

		for _, v2406 in t299.entryOrder do
			table.insert(t303, v2406)
		end

		v2394.entry_order = t303
	end

	return v2394
end

t294.descriptor = {
	name = "EventDetailsFeedInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventDetailsFeedInputData"
}
t1.EventDetailsFeedInputData = t294
typeRegistry.default:register(t1.EventDetailsFeedInputData)

local t304 = {}

t304.__index = t304

function t304.new(t305: {[any]: any}?) -- line: 15086
	-- upvalues: t304 (copy)
	return (setmetatable({
		key = if t305 ~= nil and t305.key ~= nil then t305.key else "",
		value = if t305 ~= nil and t305.value ~= nil then t305.value else nil
	}, t304))
end
function t304.encode(p188) -- line: 15095
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n125 = 0

	if p188.key ~= nil and p188.key ~= "" then
		local v2411, v2412 = proto.writeTag(buf, n125, 1, proto.wireTypes.lengthDelimited)

		buf, n125 = proto.writeString(v2411, v2412, p188.key)
	end

	if p188.value ~= nil then
		local v2413 = p188.value:encode()
		local v2414, v2415 = proto.writeTag(buf, n125, 2, proto.wireTypes.lengthDelimited)

		buf, n125 = proto.writeBuffer(v2414, v2415, v2413, buffer.len(v2413))
	end

	local buf68 = buffer.create(n125)

	buffer.copy(buf68, 0, buf, 0, n125)

	return buf68
end
function t304.decode(p189: buffer) -- line: 15115
	-- upvalues: t304 (copy), proto (copy), t1 (copy)
	local v2418 = t304.new()
	local n126 = 0

	while n126 < buffer.len(p189) do
		local v2420, v2421

		v2420, v2421, n126 = proto.readTag(p189, n126)

		if v2421 == proto.wireTypes.varint then
			local v2422

			v2422, n126 = proto.readVarInt(p189, n126)
		elseif v2421 == proto.wireTypes.lengthDelimited then
			if v2420 == 1 then
				local v2423

				v2423, n126 = proto.readBuffer(p189, n126)
				v2418.key = buffer.tostring(v2423)
			elseif v2420 == 2 then
				local v2424

				v2424, n126 = proto.readBuffer(p189, n126)
				v2418.value = t1.FeedEntry.decode(v2424)
			else
				local v2425, v2426 = proto.readVarInt(p189, n126)

				n126 = v2426 + v2425
			end
		elseif v2421 == proto.wireTypes.i32 then
			local v2427

			v2427, n126 = proto.readFixed32(p189, n126)
		elseif v2421 == proto.wireTypes.i64 then
			local v2428

			v2428, n126 = proto.readFixed64(p189, n126)
		else
			error("Unsupported wire type: " .. v2421)
		end
	end

	return v2418
end
function t304.jsonEncode(p190) -- line: 15163
	local t306 = {}

	if p190.key ~= nil and p190.key ~= "" then
		t306.key = p190.key
	end

	if p190.value ~= nil then
		t306.value = p190.value:jsonEncode()
	end

	return t306
end
function t304.jsonDecode(t307: {[any]: any}) -- line: 15177
	-- upvalues: t304 (copy), t1 (copy)
	local v2432 = t304.new()

	if t307.key ~= nil then
		v2432.key = t307.key
	end

	if t307.value ~= nil then
		v2432.value = t1.FeedEntry.jsonDecode(t307.value)
	end

	return v2432
end

t304.descriptor = {
	name = "EventDetailsFeedInputData_EntryMapEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryMapEntry"
}
t1.EventDetailsFeedInputData_EntryMapEntry = t304
typeRegistry.default:register(t1.EventDetailsFeedInputData_EntryMapEntry)

local t308 = {}

t308.__index = t308

function t308.new(t309: {[any]: any}?) -- line: 15207
	-- upvalues: t308 (copy)
	return (setmetatable({
		event_id = if t309 ~= nil and t309.event_id ~= nil then t309.event_id else "",
		universe_id = if t309 ~= nil and t309.universe_id ~= nil then t309.universe_id else ""
	}, t308))
end
function t308.encode(p191) -- line: 15216
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n127 = 0

	if p191.event_id ~= nil and p191.event_id ~= "" then
		local v2437, v2438 = proto.writeTag(buf, n127, 1, proto.wireTypes.lengthDelimited)

		buf, n127 = proto.writeString(v2437, v2438, p191.event_id)
	end

	if p191.universe_id ~= nil and p191.universe_id ~= "" then
		local v2439, v2440 = proto.writeTag(buf, n127, 2, proto.wireTypes.lengthDelimited)

		buf, n127 = proto.writeString(v2439, v2440, p191.universe_id)
	end

	local buf69 = buffer.create(n127)

	buffer.copy(buf69, 0, buf, 0, n127)

	return buf69
end
function t308.decode(p192: buffer) -- line: 15235
	-- upvalues: t308 (copy), proto (copy)
	local v2443 = t308.new()
	local n128 = 0

	while n128 < buffer.len(p192) do
		local v2445, v2446

		v2445, v2446, n128 = proto.readTag(p192, n128)

		if v2446 == proto.wireTypes.varint then
			local v2447

			v2447, n128 = proto.readVarInt(p192, n128)
		elseif v2446 == proto.wireTypes.lengthDelimited then
			if v2445 == 1 then
				local v2448

				v2448, n128 = proto.readBuffer(p192, n128)
				v2443.event_id = buffer.tostring(v2448)
			elseif v2445 == 2 then
				local v2449

				v2449, n128 = proto.readBuffer(p192, n128)
				v2443.universe_id = buffer.tostring(v2449)
			else
				local v2450, v2451 = proto.readVarInt(p192, n128)

				n128 = v2451 + v2450
			end
		elseif v2446 == proto.wireTypes.i32 then
			local v2452

			v2452, n128 = proto.readFixed32(p192, n128)
		elseif v2446 == proto.wireTypes.i64 then
			local v2453

			v2453, n128 = proto.readFixed64(p192, n128)
		else
			error("Unsupported wire type: " .. v2446)
		end
	end

	return v2443
end
function t308.jsonEncode(p193) -- line: 15283
	local t310 = {}

	if p193.event_id ~= nil and p193.event_id ~= "" then
		t310.eventId = p193.event_id
	end

	if p193.universe_id ~= nil and p193.universe_id ~= "" then
		t310.universeId = p193.universe_id
	end

	return t310
end
function t308.jsonDecode(t311: {[any]: any}) -- line: 15297
	-- upvalues: t308 (copy)
	local v2457 = t308.new()

	if t311.event_id ~= nil then
		v2457.event_id = t311.event_id
	end

	if t311.eventId ~= nil then
		v2457.event_id = t311.eventId
	end

	if t311.universe_id ~= nil then
		v2457.universe_id = t311.universe_id
	end

	if t311.universeId ~= nil then
		v2457.universe_id = t311.universeId
	end

	return v2457
end

t308.descriptor = {
	name = "EventDetailsActionBarInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventDetailsActionBarInputData"
}
t1.EventDetailsActionBarInputData = t308
typeRegistry.default:register(t1.EventDetailsActionBarInputData)

local t312 = {}

t312.__index = t312

function t312.new(t313: {[any]: any}?) -- line: 15333
	-- upvalues: t312 (copy)
	return (setmetatable({
		event_id = if t313 ~= nil and t313.event_id ~= nil then t313.event_id else ""
	}, t312))
end
function t312.encode(p194) -- line: 15341
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n129 = 0

	if p194.event_id ~= nil and p194.event_id ~= "" then
		local v2462, v2463 = proto.writeTag(buf, n129, 1, proto.wireTypes.lengthDelimited)

		buf, n129 = proto.writeString(v2462, v2463, p194.event_id)
	end

	local buf70 = buffer.create(n129)

	buffer.copy(buf70, 0, buf, 0, n129)

	return buf70
end
function t312.decode(p195: buffer) -- line: 15355
	-- upvalues: t312 (copy), proto (copy)
	local v2466 = t312.new()
	local n130 = 0

	while n130 < buffer.len(p195) do
		local v2468, v2469

		v2468, v2469, n130 = proto.readTag(p195, n130)

		if v2469 == proto.wireTypes.varint then
			local v2470

			v2470, n130 = proto.readVarInt(p195, n130)
		elseif v2469 == proto.wireTypes.lengthDelimited then
			if v2468 == 1 then
				local v2471

				v2471, n130 = proto.readBuffer(p195, n130)
				v2466.event_id = buffer.tostring(v2471)
			else
				local v2472, v2473 = proto.readVarInt(p195, n130)

				n130 = v2473 + v2472
			end
		elseif v2469 == proto.wireTypes.i32 then
			local v2474

			v2474, n130 = proto.readFixed32(p195, n130)
		elseif v2469 == proto.wireTypes.i64 then
			local v2475

			v2475, n130 = proto.readFixed64(p195, n130)
		else
			error("Unsupported wire type: " .. v2469)
		end
	end

	return v2466
end
function t312.jsonEncode(p196) -- line: 15398
	local t314 = {}

	if p196.event_id ~= nil and p196.event_id ~= "" then
		t314.eventId = p196.event_id
	end

	return t314
end
function t312.jsonDecode(t315: {[any]: any}) -- line: 15408
	-- upvalues: t312 (copy)
	local v2479 = t312.new()

	if t315.event_id ~= nil then
		v2479.event_id = t315.event_id
	end

	if t315.eventId ~= nil then
		v2479.event_id = t315.eventId
	end

	return v2479
end

t312.descriptor = {
	name = "EventDescriptionInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventDescriptionInputData"
}
t1.EventDescriptionInputData = t312
typeRegistry.default:register(t1.EventDescriptionInputData)

local t316 = {}

t316.__index = t316

function t316.new(t317: {[any]: any}?) -- line: 15436
	-- upvalues: t316 (copy)
	return (setmetatable({
		event_id = if t317 ~= nil and t317.event_id ~= nil then t317.event_id else "",
		universe_id = if t317 ~= nil and t317.universe_id ~= nil then t317.universe_id else ""
	}, t316))
end
function t316.encode(p197) -- line: 15445
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n131 = 0

	if p197.event_id ~= nil and p197.event_id ~= "" then
		local v2484, v2485 = proto.writeTag(buf, n131, 1, proto.wireTypes.lengthDelimited)

		buf, n131 = proto.writeString(v2484, v2485, p197.event_id)
	end

	if p197.universe_id ~= nil and p197.universe_id ~= "" then
		local v2486, v2487 = proto.writeTag(buf, n131, 2, proto.wireTypes.lengthDelimited)

		buf, n131 = proto.writeString(v2486, v2487, p197.universe_id)
	end

	local buf71 = buffer.create(n131)

	buffer.copy(buf71, 0, buf, 0, n131)

	return buf71
end
function t316.decode(p198: buffer) -- line: 15464
	-- upvalues: t316 (copy), proto (copy)
	local v2490 = t316.new()
	local n132 = 0

	while n132 < buffer.len(p198) do
		local v2492, v2493

		v2492, v2493, n132 = proto.readTag(p198, n132)

		if v2493 == proto.wireTypes.varint then
			local v2494

			v2494, n132 = proto.readVarInt(p198, n132)
		elseif v2493 == proto.wireTypes.lengthDelimited then
			if v2492 == 1 then
				local v2495

				v2495, n132 = proto.readBuffer(p198, n132)
				v2490.event_id = buffer.tostring(v2495)
			elseif v2492 == 2 then
				local v2496

				v2496, n132 = proto.readBuffer(p198, n132)
				v2490.universe_id = buffer.tostring(v2496)
			else
				local v2497, v2498 = proto.readVarInt(p198, n132)

				n132 = v2498 + v2497
			end
		elseif v2493 == proto.wireTypes.i32 then
			local v2499

			v2499, n132 = proto.readFixed32(p198, n132)
		elseif v2493 == proto.wireTypes.i64 then
			local v2500

			v2500, n132 = proto.readFixed64(p198, n132)
		else
			error("Unsupported wire type: " .. v2493)
		end
	end

	return v2490
end
function t316.jsonEncode(p199) -- line: 15512
	local t318 = {}

	if p199.event_id ~= nil and p199.event_id ~= "" then
		t318.eventId = p199.event_id
	end

	if p199.universe_id ~= nil and p199.universe_id ~= "" then
		t318.universeId = p199.universe_id
	end

	return t318
end
function t316.jsonDecode(t319: {[any]: any}) -- line: 15526
	-- upvalues: t316 (copy)
	local v2504 = t316.new()

	if t319.event_id ~= nil then
		v2504.event_id = t319.event_id
	end

	if t319.eventId ~= nil then
		v2504.event_id = t319.eventId
	end

	if t319.universe_id ~= nil then
		v2504.universe_id = t319.universe_id
	end

	if t319.universeId ~= nil then
		v2504.universe_id = t319.universeId
	end

	return v2504
end

t316.descriptor = {
	name = "EventAttributionRowInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventAttributionRowInputData"
}
t1.EventAttributionRowInputData = t316
typeRegistry.default:register(t1.EventAttributionRowInputData)

local t320 = {}

t320.__index = t320

function t320.new(t321: {[any]: any}?) -- line: 15562
	-- upvalues: t320 (copy)
	return (setmetatable({
		event_id = if t321 ~= nil and t321.event_id ~= nil then t321.event_id else ""
	}, t320))
end
function t320.encode(p200) -- line: 15568
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n133 = 0

	if p200.event_id ~= nil and p200.event_id ~= "" then
		local v2509, v2510 = proto.writeTag(buf, n133, 1, proto.wireTypes.lengthDelimited)

		buf, n133 = proto.writeString(v2509, v2510, p200.event_id)
	end

	local buf72 = buffer.create(n133)

	buffer.copy(buf72, 0, buf, 0, n133)

	return buf72
end
function t320.decode(p201: buffer) -- line: 15582
	-- upvalues: t320 (copy), proto (copy)
	local v2513 = t320.new()
	local n134 = 0

	while n134 < buffer.len(p201) do
		local v2515, v2516

		v2515, v2516, n134 = proto.readTag(p201, n134)

		if v2516 == proto.wireTypes.varint then
			local v2517

			v2517, n134 = proto.readVarInt(p201, n134)
		elseif v2516 == proto.wireTypes.lengthDelimited then
			if v2515 == 1 then
				local v2518

				v2518, n134 = proto.readBuffer(p201, n134)
				v2513.event_id = buffer.tostring(v2518)
			else
				local v2519, v2520 = proto.readVarInt(p201, n134)

				n134 = v2520 + v2519
			end
		elseif v2516 == proto.wireTypes.i32 then
			local v2521

			v2521, n134 = proto.readFixed32(p201, n134)
		elseif v2516 == proto.wireTypes.i64 then
			local v2522

			v2522, n134 = proto.readFixed64(p201, n134)
		else
			error("Unsupported wire type: " .. v2516)
		end
	end

	return v2513
end
function t320.jsonEncode(p202) -- line: 15625
	local t322 = {}

	if p202.event_id ~= nil and p202.event_id ~= "" then
		t322.eventId = p202.event_id
	end

	return t322
end
function t320.jsonDecode(t323: {[any]: any}) -- line: 15635
	-- upvalues: t320 (copy)
	local v2526 = t320.new()

	if t323.event_id ~= nil then
		v2526.event_id = t323.event_id
	end

	if t323.eventId ~= nil then
		v2526.event_id = t323.eventId
	end

	return v2526
end

t320.descriptor = {
	name = "EventInfoTableInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventInfoTableInputData"
}
t1.EventInfoTableInputData = t320
typeRegistry.default:register(t1.EventInfoTableInputData)

local t324 = {}

t324.__index = t324

function t324.new(t325: {[any]: any}?) -- line: 15663
	-- upvalues: t324 (copy)
	return (setmetatable({
		event_id = if t325 ~= nil and t325.event_id ~= nil then t325.event_id else ""
	}, t324))
end
function t324.encode(p203) -- line: 15671
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n135 = 0

	if p203.event_id ~= nil and p203.event_id ~= "" then
		local v2531, v2532 = proto.writeTag(buf, n135, 1, proto.wireTypes.lengthDelimited)

		buf, n135 = proto.writeString(v2531, v2532, p203.event_id)
	end

	local buf73 = buffer.create(n135)

	buffer.copy(buf73, 0, buf, 0, n135)

	return buf73
end
function t324.decode(p204: buffer) -- line: 15685
	-- upvalues: t324 (copy), proto (copy)
	local v2535 = t324.new()
	local n136 = 0

	while n136 < buffer.len(p204) do
		local v2537, v2538

		v2537, v2538, n136 = proto.readTag(p204, n136)

		if v2538 == proto.wireTypes.varint then
			local v2539

			v2539, n136 = proto.readVarInt(p204, n136)
		elseif v2538 == proto.wireTypes.lengthDelimited then
			if v2537 == 1 then
				local v2540

				v2540, n136 = proto.readBuffer(p204, n136)
				v2535.event_id = buffer.tostring(v2540)
			else
				local v2541, v2542 = proto.readVarInt(p204, n136)

				n136 = v2542 + v2541
			end
		elseif v2538 == proto.wireTypes.i32 then
			local v2543

			v2543, n136 = proto.readFixed32(p204, n136)
		elseif v2538 == proto.wireTypes.i64 then
			local v2544

			v2544, n136 = proto.readFixed64(p204, n136)
		else
			error("Unsupported wire type: " .. v2538)
		end
	end

	return v2535
end
function t324.jsonEncode(p205) -- line: 15728
	local t326 = {}

	if p205.event_id ~= nil and p205.event_id ~= "" then
		t326.eventId = p205.event_id
	end

	return t326
end
function t324.jsonDecode(t327: {[any]: any}) -- line: 15738
	-- upvalues: t324 (copy)
	local v2548 = t324.new()

	if t327.event_id ~= nil then
		v2548.event_id = t327.event_id
	end

	if t327.eventId ~= nil then
		v2548.event_id = t327.eventId
	end

	return v2548
end

t324.descriptor = {
	name = "EventDetailsSheetFullBleedInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventDetailsSheetFullBleedInputData"
}
t1.EventDetailsSheetFullBleedInputData = t324
typeRegistry.default:register(t1.EventDetailsSheetFullBleedInputData)

local t328 = {}

t328.__index = t328

function t328.new(t329: {[any]: any}?) -- line: 15768
	-- upvalues: t328 (copy)
	return (setmetatable({
		event_id = if t329 ~= nil and t329.event_id ~= nil then t329.event_id else "",
		universe_id = if t329 ~= nil and t329.universe_id ~= nil then t329.universe_id else ""
	}, t328))
end
function t328.encode(p206) -- line: 15777
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n137 = 0

	if p206.event_id ~= nil and p206.event_id ~= "" then
		local v2553, v2554 = proto.writeTag(buf, n137, 1, proto.wireTypes.lengthDelimited)

		buf, n137 = proto.writeString(v2553, v2554, p206.event_id)
	end

	if p206.universe_id ~= nil and p206.universe_id ~= "" then
		local v2555, v2556 = proto.writeTag(buf, n137, 2, proto.wireTypes.lengthDelimited)

		buf, n137 = proto.writeString(v2555, v2556, p206.universe_id)
	end

	local buf74 = buffer.create(n137)

	buffer.copy(buf74, 0, buf, 0, n137)

	return buf74
end
function t328.decode(p207: buffer) -- line: 15796
	-- upvalues: t328 (copy), proto (copy)
	local v2559 = t328.new()
	local n138 = 0

	while n138 < buffer.len(p207) do
		local v2561, v2562

		v2561, v2562, n138 = proto.readTag(p207, n138)

		if v2562 == proto.wireTypes.varint then
			local v2563

			v2563, n138 = proto.readVarInt(p207, n138)
		elseif v2562 == proto.wireTypes.lengthDelimited then
			if v2561 == 1 then
				local v2564

				v2564, n138 = proto.readBuffer(p207, n138)
				v2559.event_id = buffer.tostring(v2564)
			elseif v2561 == 2 then
				local v2565

				v2565, n138 = proto.readBuffer(p207, n138)
				v2559.universe_id = buffer.tostring(v2565)
			else
				local v2566, v2567 = proto.readVarInt(p207, n138)

				n138 = v2567 + v2566
			end
		elseif v2562 == proto.wireTypes.i32 then
			local v2568

			v2568, n138 = proto.readFixed32(p207, n138)
		elseif v2562 == proto.wireTypes.i64 then
			local v2569

			v2569, n138 = proto.readFixed64(p207, n138)
		else
			error("Unsupported wire type: " .. v2562)
		end
	end

	return v2559
end
function t328.jsonEncode(p208) -- line: 15844
	local t330 = {}

	if p208.event_id ~= nil and p208.event_id ~= "" then
		t330.eventId = p208.event_id
	end

	if p208.universe_id ~= nil and p208.universe_id ~= "" then
		t330.universeId = p208.universe_id
	end

	return t330
end
function t328.jsonDecode(t331: {[any]: any}) -- line: 15858
	-- upvalues: t328 (copy)
	local v2573 = t328.new()

	if t331.event_id ~= nil then
		v2573.event_id = t331.event_id
	end

	if t331.eventId ~= nil then
		v2573.event_id = t331.eventId
	end

	if t331.universe_id ~= nil then
		v2573.universe_id = t331.universe_id
	end

	if t331.universeId ~= nil then
		v2573.universe_id = t331.universeId
	end

	return v2573
end

t328.descriptor = {
	name = "EventNotificationsModalInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventNotificationsModalInputData"
}
t1.EventNotificationsModalInputData = t328
typeRegistry.default:register(t1.EventNotificationsModalInputData)

local t332 = {}

t332.__index = t332

function t332.new(t333: {[any]: any}?) -- line: 15896
	-- upvalues: t332 (copy)
	return (setmetatable({
		entry_map = if t333 ~= nil and t333.entry_map ~= nil then t333.entry_map else {},
		entry_order = if t333 ~= nil and t333.entry_order ~= nil then t333.entry_order else {},
		next_page_token = if t333 ~= nil and t333.next_page_token ~= nil then t333.next_page_token else "",
		sticky_filter_pills = if t333 ~= nil and t333.sticky_filter_pills ~= nil then t333.sticky_filter_pills else nil,
		applied_filters = if t333 ~= nil and t333.applied_filters ~= nil then t333.applied_filters else ""
	}, t332))
end
function t332.encode(p209) -- line: 15908
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n139 = 0

	if p209.entry_map ~= nil and next(p209.entry_map) ~= nil then
		for v2578, v2579 in p209.entry_map do
			local buf75 = buffer.create(0)
			local v2581, v2582 = proto.writeTag(buf75, 0, 1, proto.wireTypes.lengthDelimited)
			local v2583, v2584 = proto.writeString(v2581, v2582, v2578)
			local v2585 = v2579:encode()
			local v2586, v2587 = proto.writeTag(v2583, v2584, 2, proto.wireTypes.lengthDelimited)
			local v2588, v2589 = proto.writeBuffer(v2586, v2587, v2585, buffer.len(v2585))
			local v2590, v2591 = proto.writeTag(buf, n139, 1, proto.wireTypes.lengthDelimited)

			buf, n139 = proto.writeBuffer(v2590, v2591, v2588, v2589)
		end
	end

	if p209.entry_order ~= nil and #p209.entry_order > 0 then
		for _, v2593 in p209.entry_order do
			local v2594, v2595 = proto.writeTag(buf, n139, 2, proto.wireTypes.lengthDelimited)

			buf, n139 = proto.writeString(v2594, v2595, v2593)
		end
	end

	if p209.next_page_token ~= nil and p209.next_page_token ~= "" then
		local v2596, v2597 = proto.writeTag(buf, n139, 3, proto.wireTypes.lengthDelimited)

		buf, n139 = proto.writeString(v2596, v2597, p209.next_page_token)
	end

	if p209.sticky_filter_pills ~= nil then
		local v2598 = p209.sticky_filter_pills:encode()
		local v2599, v2600 = proto.writeTag(buf, n139, 4, proto.wireTypes.lengthDelimited)

		buf, n139 = proto.writeBuffer(v2599, v2600, v2598, buffer.len(v2598))
	end

	if p209.applied_filters ~= nil and p209.applied_filters ~= "" then
		local v2601, v2602 = proto.writeTag(buf, n139, 5, proto.wireTypes.lengthDelimited)

		buf, n139 = proto.writeString(v2601, v2602, p209.applied_filters)
	end

	local buf76 = buffer.create(n139)

	buffer.copy(buf76, 0, buf, 0, n139)

	return buf76
end
function t332.decode(p210: buffer) -- line: 15954
	-- upvalues: t332 (copy), proto (copy), t1 (copy)
	local v2605 = t332.new()
	local n140 = 0

	while n140 < buffer.len(p210) do
		local v2607, v2608

		v2607, v2608, n140 = proto.readTag(p210, n140)

		if v2608 == proto.wireTypes.varint then
			local v2609

			v2609, n140 = proto.readVarInt(p210, n140)
		elseif v2608 == proto.wireTypes.lengthDelimited then
			if v2607 == 1 then
				local v2610

				v2610, n140 = proto.readBuffer(p210, n140)

				local v2611 = t1.ChartsFeedInputData_EntryMapEntry.decode(v2610)
				local v2612 = t1.FeedEntry.new()

				v2605.entry_map[v2611.key or ""] = v2611.value or v2612
			elseif v2607 == 2 then
				local v2613

				v2613, n140 = proto.readBuffer(p210, n140)
				table.insert(v2605.entry_order, buffer.tostring(v2613))
			elseif v2607 == 3 then
				local v2614

				v2614, n140 = proto.readBuffer(p210, n140)
				v2605.next_page_token = buffer.tostring(v2614)
			elseif v2607 == 4 then
				local v2615

				v2615, n140 = proto.readBuffer(p210, n140)
				v2605.sticky_filter_pills = t1.FilterPillsInputData.decode(v2615)
			elseif v2607 == 5 then
				local v2616

				v2616, n140 = proto.readBuffer(p210, n140)
				v2605.applied_filters = buffer.tostring(v2616)
			else
				local v2617, v2618 = proto.readVarInt(p210, n140)

				n140 = v2618 + v2617
			end
		elseif v2608 == proto.wireTypes.i32 then
			local v2619

			v2619, n140 = proto.readFixed32(p210, n140)
		elseif v2608 == proto.wireTypes.i64 then
			local v2620

			v2620, n140 = proto.readFixed64(p210, n140)
		else
			error("Unsupported wire type: " .. v2608)
		end
	end

	return v2605
end
function t332.jsonEncode(p211) -- line: 16024
	local t334 = {}

	if p211.entry_map ~= nil and next(p211.entry_map) ~= nil then
		local t335 = {}

		for v2624, v2625 in p211.entry_map do
			t335[v2624] = v2625:jsonEncode()
		end

		t334.entryMap = t335
	end

	if p211.entry_order ~= nil and #p211.entry_order > 0 then
		local t336 = {}

		for _, v2628 in p211.entry_order do
			table.insert(t336, v2628)
		end

		t334.entryOrder = t336
	end

	if p211.next_page_token ~= nil and p211.next_page_token ~= "" then
		t334.nextPageToken = p211.next_page_token
	end

	if p211.sticky_filter_pills ~= nil then
		t334.stickyFilterPills = p211.sticky_filter_pills:jsonEncode()
	end

	if p211.applied_filters ~= nil and p211.applied_filters ~= "" then
		t334.appliedFilters = p211.applied_filters
	end

	return t334
end
function t332.jsonDecode(t337: {[any]: any}) -- line: 16058
	-- upvalues: t332 (copy), t1 (copy)
	local v2630 = t332.new()

	if t337.entry_map ~= nil then
		local t338 = {}

		for v2632, v2633 in t337.entry_map do
			t338[v2632] = t1.FeedEntry.jsonDecode(v2633)
		end

		v2630.entry_map = t338
	end

	if t337.entryMap ~= nil then
		local t339 = {}

		for v2635, v2636 in t337.entryMap do
			t339[v2635] = t1.FeedEntry.jsonDecode(v2636)
		end

		v2630.entry_map = t339
	end

	if t337.entry_order ~= nil then
		local t340 = {}

		for _, v2639 in t337.entry_order do
			table.insert(t340, v2639)
		end

		v2630.entry_order = t340
	end

	if t337.entryOrder ~= nil then
		local t341 = {}

		for _, v2642 in t337.entryOrder do
			table.insert(t341, v2642)
		end

		v2630.entry_order = t341
	end

	if t337.next_page_token ~= nil then
		v2630.next_page_token = t337.next_page_token
	end

	if t337.nextPageToken ~= nil then
		v2630.next_page_token = t337.nextPageToken
	end

	if t337.sticky_filter_pills ~= nil then
		v2630.sticky_filter_pills = t1.FilterPillsInputData.jsonDecode(t337.sticky_filter_pills)
	end

	if t337.stickyFilterPills ~= nil then
		v2630.sticky_filter_pills = t1.FilterPillsInputData.jsonDecode(t337.stickyFilterPills)
	end

	if t337.applied_filters ~= nil then
		v2630.applied_filters = t337.applied_filters
	end

	if t337.appliedFilters ~= nil then
		v2630.applied_filters = t337.appliedFilters
	end

	return v2630
end

t332.descriptor = {
	name = "ChartsFeedInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ChartsFeedInputData"
}
t1.ChartsFeedInputData = t332
typeRegistry.default:register(t1.ChartsFeedInputData)

local t342 = {}

t342.__index = t342

function t342.new(t343: {[any]: any}?) -- line: 16138
	-- upvalues: t342 (copy)
	return (setmetatable({
		key = if t343 ~= nil and t343.key ~= nil then t343.key else "",
		value = if t343 ~= nil and t343.value ~= nil then t343.value else nil
	}, t342))
end
function t342.encode(p212) -- line: 16147
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n141 = 0

	if p212.key ~= nil and p212.key ~= "" then
		local v2647, v2648 = proto.writeTag(buf, n141, 1, proto.wireTypes.lengthDelimited)

		buf, n141 = proto.writeString(v2647, v2648, p212.key)
	end

	if p212.value ~= nil then
		local v2649 = p212.value:encode()
		local v2650, v2651 = proto.writeTag(buf, n141, 2, proto.wireTypes.lengthDelimited)

		buf, n141 = proto.writeBuffer(v2650, v2651, v2649, buffer.len(v2649))
	end

	local buf77 = buffer.create(n141)

	buffer.copy(buf77, 0, buf, 0, n141)

	return buf77
end
function t342.decode(p213: buffer) -- line: 16167
	-- upvalues: t342 (copy), proto (copy), t1 (copy)
	local v2654 = t342.new()
	local n142 = 0

	while n142 < buffer.len(p213) do
		local v2656, v2657

		v2656, v2657, n142 = proto.readTag(p213, n142)

		if v2657 == proto.wireTypes.varint then
			local v2658

			v2658, n142 = proto.readVarInt(p213, n142)
		elseif v2657 == proto.wireTypes.lengthDelimited then
			if v2656 == 1 then
				local v2659

				v2659, n142 = proto.readBuffer(p213, n142)
				v2654.key = buffer.tostring(v2659)
			elseif v2656 == 2 then
				local v2660

				v2660, n142 = proto.readBuffer(p213, n142)
				v2654.value = t1.FeedEntry.decode(v2660)
			else
				local v2661, v2662 = proto.readVarInt(p213, n142)

				n142 = v2662 + v2661
			end
		elseif v2657 == proto.wireTypes.i32 then
			local v2663

			v2663, n142 = proto.readFixed32(p213, n142)
		elseif v2657 == proto.wireTypes.i64 then
			local v2664

			v2664, n142 = proto.readFixed64(p213, n142)
		else
			error("Unsupported wire type: " .. v2657)
		end
	end

	return v2654
end
function t342.jsonEncode(p214) -- line: 16215
	local t344 = {}

	if p214.key ~= nil and p214.key ~= "" then
		t344.key = p214.key
	end

	if p214.value ~= nil then
		t344.value = p214.value:jsonEncode()
	end

	return t344
end
function t342.jsonDecode(t345: {[any]: any}) -- line: 16229
	-- upvalues: t342 (copy), t1 (copy)
	local v2668 = t342.new()

	if t345.key ~= nil then
		v2668.key = t345.key
	end

	if t345.value ~= nil then
		v2668.value = t1.FeedEntry.jsonDecode(t345.value)
	end

	return v2668
end

t342.descriptor = {
	name = "ChartsFeedInputData_EntryMapEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryMapEntry"
}
t1.ChartsFeedInputData_EntryMapEntry = t342
typeRegistry.default:register(t1.ChartsFeedInputData_EntryMapEntry)

local t346 = {}

t346.__index = t346

function t346.new(t347: {[any]: any}?) -- line: 16259
	-- upvalues: t346 (copy)
	return (setmetatable({
		filter_groups = if t347 ~= nil and t347.filter_groups ~= nil then t347.filter_groups else {},
		sort_id = if t347 ~= nil and t347.sort_id ~= nil then t347.sort_id else "",
		secondary_sort_id = if t347 ~= nil and t347.secondary_sort_id ~= nil then t347.secondary_sort_id else 0,
		title = if t347 ~= nil and t347.title ~= nil then t347.title else "",
		primary_sort_id = if t347 ~= nil and t347.primary_sort_id ~= nil then t347.primary_sort_id else nil,
		applied_filters = if t347 ~= nil and t347.applied_filters ~= nil then t347.applied_filters else nil
	}, t346))
end
function t346.encode(p215) -- line: 16270
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n143 = 0

	if p215.filter_groups ~= nil and #p215.filter_groups > 0 then
		for _, v2674 in p215.filter_groups do
			local v2675 = v2674:encode()
			local v2676, v2677 = proto.writeTag(buf, n143, 1, proto.wireTypes.lengthDelimited)

			buf, n143 = proto.writeBuffer(v2676, v2677, v2675, buffer.len(v2675))
		end
	end

	if p215.sort_id ~= nil and p215.sort_id ~= "" then
		local v2678, v2679 = proto.writeTag(buf, n143, 2, proto.wireTypes.lengthDelimited)

		buf, n143 = proto.writeString(v2678, v2679, p215.sort_id)
	end

	if p215.secondary_sort_id ~= nil and p215.secondary_sort_id ~= 0 then
		local v2680, v2681 = proto.writeTag(buf, n143, 3, proto.wireTypes.varint)

		buf, n143 = proto.writeVarInt(v2680, v2681, p215.secondary_sort_id)
	end

	if p215.title ~= nil and p215.title ~= "" then
		local v2682, v2683 = proto.writeTag(buf, n143, 4, proto.wireTypes.lengthDelimited)

		buf, n143 = proto.writeString(v2682, v2683, p215.title)
	end

	if p215.primary_sort_id ~= nil then
		local v2684, v2685 = proto.writeTag(buf, n143, 5, proto.wireTypes.varint)

		buf, n143 = proto.writeVarInt(v2684, v2685, p215.primary_sort_id)
	end

	if p215.applied_filters ~= nil then
		local v2686, v2687 = proto.writeTag(buf, n143, 6, proto.wireTypes.lengthDelimited)

		buf, n143 = proto.writeString(v2686, v2687, p215.applied_filters)
	end

	local buf78 = buffer.create(n143)

	buffer.copy(buf78, 0, buf, 0, n143)

	return buf78
end
function t346.decode(p216: buffer) -- line: 16312
	-- upvalues: t346 (copy), proto (copy), t1 (copy)
	local v2690 = t346.new()
	local n144 = 0

	while n144 < buffer.len(p216) do
		local v2692, v2693

		v2692, v2693, n144 = proto.readTag(p216, n144)

		if v2693 == proto.wireTypes.varint then
			if v2692 == 3 then
				local v2694

				v2694, n144 = proto.readVarIntI32(p216, n144)
				v2690.secondary_sort_id = v2694
			elseif v2692 == 5 then
				local v2695

				v2695, n144 = proto.readVarIntI32(p216, n144)
				v2690.primary_sort_id = v2695
			else
				local v2696

				v2696, n144 = proto.readVarInt(p216, n144)
			end
		elseif v2693 == proto.wireTypes.lengthDelimited then
			if v2692 == 1 then
				local v2697

				v2697, n144 = proto.readBuffer(p216, n144)
				table.insert(v2690.filter_groups, t1.FilterPillsInputData_FilterGroup.decode(v2697))
			elseif v2692 == 2 then
				local v2698

				v2698, n144 = proto.readBuffer(p216, n144)
				v2690.sort_id = buffer.tostring(v2698)
			elseif v2692 == 4 then
				local v2699

				v2699, n144 = proto.readBuffer(p216, n144)
				v2690.title = buffer.tostring(v2699)
			elseif v2692 == 6 then
				local v2700

				v2700, n144 = proto.readBuffer(p216, n144)
				v2690.applied_filters = buffer.tostring(v2700)
			else
				local v2701, v2702 = proto.readVarInt(p216, n144)

				n144 = v2702 + v2701
			end
		elseif v2693 == proto.wireTypes.i32 then
			local v2703

			v2703, n144 = proto.readFixed32(p216, n144)
		elseif v2693 == proto.wireTypes.i64 then
			local v2704

			v2704, n144 = proto.readFixed64(p216, n144)
		else
			error("Unsupported wire type: " .. v2693)
		end
	end

	return v2690
end
function t346.jsonEncode(p217) -- line: 16380
	local t348 = {}

	if p217.filter_groups ~= nil and #p217.filter_groups > 0 then
		local t349 = {}

		for _, v2709 in p217.filter_groups do
			table.insert(t349, v2709:jsonEncode())
		end

		t348.filterGroups = t349
	end

	if p217.sort_id ~= nil and p217.sort_id ~= "" then
		t348.sortId = p217.sort_id
	end

	if p217.secondary_sort_id ~= nil and p217.secondary_sort_id ~= 0 then
		t348.secondarySortId = p217.secondary_sort_id
	end

	if p217.title ~= nil and p217.title ~= "" then
		t348.title = p217.title
	end

	if p217.primary_sort_id ~= nil then
		t348.primarySortId = p217.primary_sort_id
	end

	if p217.applied_filters ~= nil then
		t348.appliedFilters = p217.applied_filters
	end

	return t348
end
function t346.jsonDecode(t350: {[any]: any}) -- line: 16414
	-- upvalues: t346 (copy), t1 (copy)
	local v2711 = t346.new()

	if t350.filter_groups ~= nil then
		local t351 = {}

		for _, v2714 in t350.filter_groups do
			table.insert(t351, t1.FilterPillsInputData_FilterGroup.jsonDecode(v2714))
		end

		v2711.filter_groups = t351
	end

	if t350.filterGroups ~= nil then
		local t352 = {}

		for _, v2717 in t350.filterGroups do
			table.insert(t352, t1.FilterPillsInputData_FilterGroup.jsonDecode(v2717))
		end

		v2711.filter_groups = t352
	end

	if t350.sort_id ~= nil then
		v2711.sort_id = t350.sort_id
	end

	if t350.sortId ~= nil then
		v2711.sort_id = t350.sortId
	end

	if t350.secondary_sort_id ~= nil then
		v2711.secondary_sort_id = t350.secondary_sort_id
	end

	if t350.secondarySortId ~= nil then
		v2711.secondary_sort_id = t350.secondarySortId
	end

	if t350.title ~= nil then
		v2711.title = t350.title
	end

	if t350.primary_sort_id ~= nil then
		v2711.primary_sort_id = t350.primary_sort_id
	end

	if t350.primarySortId ~= nil then
		v2711.primary_sort_id = t350.primarySortId
	end

	if t350.applied_filters ~= nil then
		v2711.applied_filters = t350.applied_filters
	end

	if t350.appliedFilters ~= nil then
		v2711.applied_filters = t350.appliedFilters
	end

	return v2711
end

t346.descriptor = {
	name = "FilterPillsInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.FilterPillsInputData"
}
t1.FilterPillsInputData = t346
typeRegistry.default:register(t1.FilterPillsInputData)

local t353 = {}

t353.__index = t353

function t353.new(t354: {[any]: any}?) -- line: 16488
	-- upvalues: t353 (copy)
	return (setmetatable({
		filter_id = if t354 ~= nil and t354.filter_id ~= nil then t354.filter_id else "",
		display_name = if t354 ~= nil and t354.display_name ~= nil then t354.display_name else "",
		options = if t354 ~= nil and t354.options ~= nil then t354.options else {},
		default_option_id = if t354 ~= nil and t354.default_option_id ~= nil then t354.default_option_id else "",
		selected_option_id = if t354 ~= nil and t354.selected_option_id ~= nil then t354.selected_option_id else "",
		filter_type = if t354 ~= nil and t354.filter_type ~= nil then t354.filter_type else "",
		inactive_option_ids = if t354 ~= nil and t354.inactive_option_ids ~= nil then t354.inactive_option_ids else {},
		info_text = if t354 ~= nil and t354.info_text ~= nil then t354.info_text else ""
	}, t353))
end
function t353.encode(p218) -- line: 16505
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n145 = 0

	if p218.filter_id ~= nil and p218.filter_id ~= "" then
		local v2722, v2723 = proto.writeTag(buf, n145, 1, proto.wireTypes.lengthDelimited)

		buf, n145 = proto.writeString(v2722, v2723, p218.filter_id)
	end

	if p218.display_name ~= nil and p218.display_name ~= "" then
		local v2724, v2725 = proto.writeTag(buf, n145, 2, proto.wireTypes.lengthDelimited)

		buf, n145 = proto.writeString(v2724, v2725, p218.display_name)
	end

	if p218.options ~= nil and #p218.options > 0 then
		for _, v2727 in p218.options do
			local v2728 = v2727:encode()
			local v2729, v2730 = proto.writeTag(buf, n145, 3, proto.wireTypes.lengthDelimited)

			buf, n145 = proto.writeBuffer(v2729, v2730, v2728, buffer.len(v2728))
		end
	end

	if p218.default_option_id ~= nil and p218.default_option_id ~= "" then
		local v2731, v2732 = proto.writeTag(buf, n145, 4, proto.wireTypes.lengthDelimited)

		buf, n145 = proto.writeString(v2731, v2732, p218.default_option_id)
	end

	if p218.selected_option_id ~= nil and p218.selected_option_id ~= "" then
		local v2733, v2734 = proto.writeTag(buf, n145, 5, proto.wireTypes.lengthDelimited)

		buf, n145 = proto.writeString(v2733, v2734, p218.selected_option_id)
	end

	if p218.filter_type ~= nil and p218.filter_type ~= "" then
		local v2735, v2736 = proto.writeTag(buf, n145, 6, proto.wireTypes.lengthDelimited)

		buf, n145 = proto.writeString(v2735, v2736, p218.filter_type)
	end

	if p218.inactive_option_ids ~= nil and #p218.inactive_option_ids > 0 then
		for _, v2738 in p218.inactive_option_ids do
			local v2739, v2740 = proto.writeTag(buf, n145, 7, proto.wireTypes.lengthDelimited)

			buf, n145 = proto.writeString(v2739, v2740, v2738)
		end
	end

	if p218.info_text ~= nil and p218.info_text ~= "" then
		local v2741, v2742 = proto.writeTag(buf, n145, 8, proto.wireTypes.lengthDelimited)

		buf, n145 = proto.writeString(v2741, v2742, p218.info_text)
	end

	local buf79 = buffer.create(n145)

	buffer.copy(buf79, 0, buf, 0, n145)

	return buf79
end
function t353.decode(p219: buffer) -- line: 16559
	-- upvalues: t353 (copy), proto (copy), t1 (copy)
	local v2745 = t353.new()
	local n146 = 0

	while n146 < buffer.len(p219) do
		local v2747, v2748

		v2747, v2748, n146 = proto.readTag(p219, n146)

		if v2748 == proto.wireTypes.varint then
			local v2749

			v2749, n146 = proto.readVarInt(p219, n146)
		elseif v2748 == proto.wireTypes.lengthDelimited then
			if v2747 == 1 then
				local v2750

				v2750, n146 = proto.readBuffer(p219, n146)
				v2745.filter_id = buffer.tostring(v2750)
			elseif v2747 == 2 then
				local v2751

				v2751, n146 = proto.readBuffer(p219, n146)
				v2745.display_name = buffer.tostring(v2751)
			elseif v2747 == 3 then
				local v2752

				v2752, n146 = proto.readBuffer(p219, n146)
				table.insert(v2745.options, t1.FilterPillsInputData_FilterOption.decode(v2752))
			elseif v2747 == 4 then
				local v2753

				v2753, n146 = proto.readBuffer(p219, n146)
				v2745.default_option_id = buffer.tostring(v2753)
			elseif v2747 == 5 then
				local v2754

				v2754, n146 = proto.readBuffer(p219, n146)
				v2745.selected_option_id = buffer.tostring(v2754)
			elseif v2747 == 6 then
				local v2755

				v2755, n146 = proto.readBuffer(p219, n146)
				v2745.filter_type = buffer.tostring(v2755)
			elseif v2747 == 7 then
				local v2756

				v2756, n146 = proto.readBuffer(p219, n146)
				table.insert(v2745.inactive_option_ids, buffer.tostring(v2756))
			elseif v2747 == 8 then
				local v2757

				v2757, n146 = proto.readBuffer(p219, n146)
				v2745.info_text = buffer.tostring(v2757)
			else
				local v2758, v2759 = proto.readVarInt(p219, n146)

				n146 = v2759 + v2758
			end
		elseif v2748 == proto.wireTypes.i32 then
			local v2760

			v2760, n146 = proto.readFixed32(p219, n146)
		elseif v2748 == proto.wireTypes.i64 then
			local v2761

			v2761, n146 = proto.readFixed64(p219, n146)
		else
			error("Unsupported wire type: " .. v2748)
		end
	end

	return v2745
end
function t353.jsonEncode(p220) -- line: 16637
	local t355 = {}

	if p220.filter_id ~= nil and p220.filter_id ~= "" then
		t355.filterId = p220.filter_id
	end

	if p220.display_name ~= nil and p220.display_name ~= "" then
		t355.displayName = p220.display_name
	end

	if p220.options ~= nil and #p220.options > 0 then
		local t356 = {}

		for _, v2766 in p220.options do
			table.insert(t356, v2766:jsonEncode())
		end

		t355.options = t356
	end

	if p220.default_option_id ~= nil and p220.default_option_id ~= "" then
		t355.defaultOptionId = p220.default_option_id
	end

	if p220.selected_option_id ~= nil and p220.selected_option_id ~= "" then
		t355.selectedOptionId = p220.selected_option_id
	end

	if p220.filter_type ~= nil and p220.filter_type ~= "" then
		t355.filterType = p220.filter_type
	end

	if p220.inactive_option_ids ~= nil and #p220.inactive_option_ids > 0 then
		local t357 = {}

		for _, v2769 in p220.inactive_option_ids do
			table.insert(t357, v2769)
		end

		t355.inactiveOptionIds = t357
	end

	if p220.info_text ~= nil and p220.info_text ~= "" then
		t355.infoText = p220.info_text
	end

	return t355
end
function t353.jsonDecode(t358: {[any]: any}) -- line: 16683
	-- upvalues: t353 (copy), t1 (copy)
	local v2771 = t353.new()

	if t358.filter_id ~= nil then
		v2771.filter_id = t358.filter_id
	end

	if t358.filterId ~= nil then
		v2771.filter_id = t358.filterId
	end

	if t358.display_name ~= nil then
		v2771.display_name = t358.display_name
	end

	if t358.displayName ~= nil then
		v2771.display_name = t358.displayName
	end

	if t358.options ~= nil then
		local t359 = {}

		for _, v2774 in t358.options do
			table.insert(t359, t1.FilterPillsInputData_FilterOption.jsonDecode(v2774))
		end

		v2771.options = t359
	end

	if t358.default_option_id ~= nil then
		v2771.default_option_id = t358.default_option_id
	end

	if t358.defaultOptionId ~= nil then
		v2771.default_option_id = t358.defaultOptionId
	end

	if t358.selected_option_id ~= nil then
		v2771.selected_option_id = t358.selected_option_id
	end

	if t358.selectedOptionId ~= nil then
		v2771.selected_option_id = t358.selectedOptionId
	end

	if t358.filter_type ~= nil then
		v2771.filter_type = t358.filter_type
	end

	if t358.filterType ~= nil then
		v2771.filter_type = t358.filterType
	end

	if t358.inactive_option_ids ~= nil then
		local t360 = {}

		for _, v2777 in t358.inactive_option_ids do
			table.insert(t360, v2777)
		end

		v2771.inactive_option_ids = t360
	end

	if t358.inactiveOptionIds ~= nil then
		local t361 = {}

		for _, v2780 in t358.inactiveOptionIds do
			table.insert(t361, v2780)
		end

		v2771.inactive_option_ids = t361
	end

	if t358.info_text ~= nil then
		v2771.info_text = t358.info_text
	end

	if t358.infoText ~= nil then
		v2771.info_text = t358.infoText
	end

	return v2771
end

t353.descriptor = {
	name = "FilterPillsInputData_FilterGroup",
	fullName = "roblox.apppageplatform.shared.v1beta1.FilterGroup"
}
t1.FilterPillsInputData_FilterGroup = t353
typeRegistry.default:register(t1.FilterPillsInputData_FilterGroup)

local t362 = {}

t362.__index = t362

function t362.new(t363: {[any]: any}?) -- line: 16780
	-- upvalues: t362 (copy)
	return (setmetatable({
		option_id = if t363 ~= nil and t363.option_id ~= nil then t363.option_id else "",
		display_name = if t363 ~= nil and t363.display_name ~= nil then t363.display_name else "",
		option_context_tag = if t363 ~= nil and t363.option_context_tag ~= nil then t363.option_context_tag else ""
	}, t362))
end
function t362.encode(p221) -- line: 16790
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n147 = 0

	if p221.option_id ~= nil and p221.option_id ~= "" then
		local v2785, v2786 = proto.writeTag(buf, n147, 1, proto.wireTypes.lengthDelimited)

		buf, n147 = proto.writeString(v2785, v2786, p221.option_id)
	end

	if p221.display_name ~= nil and p221.display_name ~= "" then
		local v2787, v2788 = proto.writeTag(buf, n147, 2, proto.wireTypes.lengthDelimited)

		buf, n147 = proto.writeString(v2787, v2788, p221.display_name)
	end

	if p221.option_context_tag ~= nil and p221.option_context_tag ~= "" then
		local v2789, v2790 = proto.writeTag(buf, n147, 3, proto.wireTypes.lengthDelimited)

		buf, n147 = proto.writeString(v2789, v2790, p221.option_context_tag)
	end

	local buf80 = buffer.create(n147)

	buffer.copy(buf80, 0, buf, 0, n147)

	return buf80
end
function t362.decode(p222: buffer) -- line: 16814
	-- upvalues: t362 (copy), proto (copy)
	local v2793 = t362.new()
	local n148 = 0

	while n148 < buffer.len(p222) do
		local v2795, v2796

		v2795, v2796, n148 = proto.readTag(p222, n148)

		if v2796 == proto.wireTypes.varint then
			local v2797

			v2797, n148 = proto.readVarInt(p222, n148)
		elseif v2796 == proto.wireTypes.lengthDelimited then
			if v2795 == 1 then
				local v2798

				v2798, n148 = proto.readBuffer(p222, n148)
				v2793.option_id = buffer.tostring(v2798)
			elseif v2795 == 2 then
				local v2799

				v2799, n148 = proto.readBuffer(p222, n148)
				v2793.display_name = buffer.tostring(v2799)
			elseif v2795 == 3 then
				local v2800

				v2800, n148 = proto.readBuffer(p222, n148)
				v2793.option_context_tag = buffer.tostring(v2800)
			else
				local v2801, v2802 = proto.readVarInt(p222, n148)

				n148 = v2802 + v2801
			end
		elseif v2796 == proto.wireTypes.i32 then
			local v2803

			v2803, n148 = proto.readFixed32(p222, n148)
		elseif v2796 == proto.wireTypes.i64 then
			local v2804

			v2804, n148 = proto.readFixed64(p222, n148)
		else
			error("Unsupported wire type: " .. v2796)
		end
	end

	return v2793
end
function t362.jsonEncode(p223) -- line: 16867
	local t364 = {}

	if p223.option_id ~= nil and p223.option_id ~= "" then
		t364.optionId = p223.option_id
	end

	if p223.display_name ~= nil and p223.display_name ~= "" then
		t364.displayName = p223.display_name
	end

	if p223.option_context_tag ~= nil and p223.option_context_tag ~= "" then
		t364.optionContextTag = p223.option_context_tag
	end

	return t364
end
function t362.jsonDecode(t365: {[any]: any}) -- line: 16885
	-- upvalues: t362 (copy)
	local v2808 = t362.new()

	if t365.option_id ~= nil then
		v2808.option_id = t365.option_id
	end

	if t365.optionId ~= nil then
		v2808.option_id = t365.optionId
	end

	if t365.display_name ~= nil then
		v2808.display_name = t365.display_name
	end

	if t365.displayName ~= nil then
		v2808.display_name = t365.displayName
	end

	if t365.option_context_tag ~= nil then
		v2808.option_context_tag = t365.option_context_tag
	end

	if t365.optionContextTag ~= nil then
		v2808.option_context_tag = t365.optionContextTag
	end

	return v2808
end

t362.descriptor = {
	name = "FilterPillsInputData_FilterOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.FilterOption"
}
t1.FilterPillsInputData_FilterOption = t362
typeRegistry.default:register(t1.FilterPillsInputData_FilterOption)

local t366 = {}

t366.__index = t366

function t366.new(t367: {[any]: any}?) -- line: 16931
	-- upvalues: t366 (copy)
	return (setmetatable({
		sort_options = if t367 ~= nil and t367.sort_options ~= nil then t367.sort_options else {},
		selected_sort_id = if t367 ~= nil and t367.selected_sort_id ~= nil then t367.selected_sort_id else ""
	}, t366))
end
function t366.encode(p224) -- line: 16938
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n149 = 0

	if p224.sort_options ~= nil and #p224.sort_options > 0 then
		for _, v2814 in p224.sort_options do
			local v2815 = v2814:encode()
			local v2816, v2817 = proto.writeTag(buf, n149, 1, proto.wireTypes.lengthDelimited)

			buf, n149 = proto.writeBuffer(v2816, v2817, v2815, buffer.len(v2815))
		end
	end

	if p224.selected_sort_id ~= nil and p224.selected_sort_id ~= "" then
		local v2818, v2819 = proto.writeTag(buf, n149, 2, proto.wireTypes.lengthDelimited)

		buf, n149 = proto.writeString(v2818, v2819, p224.selected_sort_id)
	end

	local buf81 = buffer.create(n149)

	buffer.copy(buf81, 0, buf, 0, n149)

	return buf81
end
function t366.decode(p225: buffer) -- line: 16960
	-- upvalues: t366 (copy), proto (copy), t1 (copy)
	local v2822 = t366.new()
	local n150 = 0

	while n150 < buffer.len(p225) do
		local v2824, v2825

		v2824, v2825, n150 = proto.readTag(p225, n150)

		if v2825 == proto.wireTypes.varint then
			local v2826

			v2826, n150 = proto.readVarInt(p225, n150)
		elseif v2825 == proto.wireTypes.lengthDelimited then
			if v2824 == 1 then
				local v2827

				v2827, n150 = proto.readBuffer(p225, n150)
				table.insert(v2822.sort_options, t1.SortSelectorInputData_SortOption.decode(v2827))
			elseif v2824 == 2 then
				local v2828

				v2828, n150 = proto.readBuffer(p225, n150)
				v2822.selected_sort_id = buffer.tostring(v2828)
			else
				local v2829, v2830 = proto.readVarInt(p225, n150)

				n150 = v2830 + v2829
			end
		elseif v2825 == proto.wireTypes.i32 then
			local v2831

			v2831, n150 = proto.readFixed32(p225, n150)
		elseif v2825 == proto.wireTypes.i64 then
			local v2832

			v2832, n150 = proto.readFixed64(p225, n150)
		else
			error("Unsupported wire type: " .. v2825)
		end
	end

	return v2822
end
function t366.jsonEncode(p226) -- line: 17008
	local t368 = {}

	if p226.sort_options ~= nil and #p226.sort_options > 0 then
		local t369 = {}

		for _, v2837 in p226.sort_options do
			table.insert(t369, v2837:jsonEncode())
		end

		t368.sortOptions = t369
	end

	if p226.selected_sort_id ~= nil and p226.selected_sort_id ~= "" then
		t368.selectedSortId = p226.selected_sort_id
	end

	return t368
end
function t366.jsonDecode(t370: {[any]: any}) -- line: 17026
	-- upvalues: t366 (copy), t1 (copy)
	local v2839 = t366.new()

	if t370.sort_options ~= nil then
		local t371 = {}

		for _, v2842 in t370.sort_options do
			table.insert(t371, t1.SortSelectorInputData_SortOption.jsonDecode(v2842))
		end

		v2839.sort_options = t371
	end

	if t370.sortOptions ~= nil then
		local t372 = {}

		for _, v2845 in t370.sortOptions do
			table.insert(t372, t1.SortSelectorInputData_SortOption.jsonDecode(v2845))
		end

		v2839.sort_options = t372
	end

	if t370.selected_sort_id ~= nil then
		v2839.selected_sort_id = t370.selected_sort_id
	end

	if t370.selectedSortId ~= nil then
		v2839.selected_sort_id = t370.selectedSortId
	end

	return v2839
end

t366.descriptor = {
	name = "SortSelectorInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.SortSelectorInputData"
}
t1.SortSelectorInputData = t366
typeRegistry.default:register(t1.SortSelectorInputData)

local t373 = {}

t373.__index = t373

function t373.new(t374: {[any]: any}?) -- line: 17072
	-- upvalues: t373 (copy)
	return (setmetatable({
		sort_id = if t374 ~= nil and t374.sort_id ~= nil then t374.sort_id else "",
		display_name = if t374 ~= nil and t374.display_name ~= nil then t374.display_name else "",
		content_type = if t374 ~= nil and t374.content_type ~= nil then t374.content_type else ""
	}, t373))
end
function t373.encode(p227) -- line: 17082
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n151 = 0

	if p227.sort_id ~= nil and p227.sort_id ~= "" then
		local v2850, v2851 = proto.writeTag(buf, n151, 1, proto.wireTypes.lengthDelimited)

		buf, n151 = proto.writeString(v2850, v2851, p227.sort_id)
	end

	if p227.display_name ~= nil and p227.display_name ~= "" then
		local v2852, v2853 = proto.writeTag(buf, n151, 2, proto.wireTypes.lengthDelimited)

		buf, n151 = proto.writeString(v2852, v2853, p227.display_name)
	end

	if p227.content_type ~= nil and p227.content_type ~= "" then
		local v2854, v2855 = proto.writeTag(buf, n151, 3, proto.wireTypes.lengthDelimited)

		buf, n151 = proto.writeString(v2854, v2855, p227.content_type)
	end

	local buf82 = buffer.create(n151)

	buffer.copy(buf82, 0, buf, 0, n151)

	return buf82
end
function t373.decode(p228: buffer) -- line: 17106
	-- upvalues: t373 (copy), proto (copy)
	local v2858 = t373.new()
	local n152 = 0

	while n152 < buffer.len(p228) do
		local v2860, v2861

		v2860, v2861, n152 = proto.readTag(p228, n152)

		if v2861 == proto.wireTypes.varint then
			local v2862

			v2862, n152 = proto.readVarInt(p228, n152)
		elseif v2861 == proto.wireTypes.lengthDelimited then
			if v2860 == 1 then
				local v2863

				v2863, n152 = proto.readBuffer(p228, n152)
				v2858.sort_id = buffer.tostring(v2863)
			elseif v2860 == 2 then
				local v2864

				v2864, n152 = proto.readBuffer(p228, n152)
				v2858.display_name = buffer.tostring(v2864)
			elseif v2860 == 3 then
				local v2865

				v2865, n152 = proto.readBuffer(p228, n152)
				v2858.content_type = buffer.tostring(v2865)
			else
				local v2866, v2867 = proto.readVarInt(p228, n152)

				n152 = v2867 + v2866
			end
		elseif v2861 == proto.wireTypes.i32 then
			local v2868

			v2868, n152 = proto.readFixed32(p228, n152)
		elseif v2861 == proto.wireTypes.i64 then
			local v2869

			v2869, n152 = proto.readFixed64(p228, n152)
		else
			error("Unsupported wire type: " .. v2861)
		end
	end

	return v2858
end
function t373.jsonEncode(p229) -- line: 17159
	local t375 = {}

	if p229.sort_id ~= nil and p229.sort_id ~= "" then
		t375.sortId = p229.sort_id
	end

	if p229.display_name ~= nil and p229.display_name ~= "" then
		t375.displayName = p229.display_name
	end

	if p229.content_type ~= nil and p229.content_type ~= "" then
		t375.contentType = p229.content_type
	end

	return t375
end
function t373.jsonDecode(t376: {[any]: any}) -- line: 17177
	-- upvalues: t373 (copy)
	local v2873 = t373.new()

	if t376.sort_id ~= nil then
		v2873.sort_id = t376.sort_id
	end

	if t376.sortId ~= nil then
		v2873.sort_id = t376.sortId
	end

	if t376.display_name ~= nil then
		v2873.display_name = t376.display_name
	end

	if t376.displayName ~= nil then
		v2873.display_name = t376.displayName
	end

	if t376.content_type ~= nil then
		v2873.content_type = t376.content_type
	end

	if t376.contentType ~= nil then
		v2873.content_type = t376.contentType
	end

	return v2873
end

t373.descriptor = {
	name = "SortSelectorInputData_SortOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.SortOption"
}
t1.SortSelectorInputData_SortOption = t373
typeRegistry.default:register(t1.SortSelectorInputData_SortOption)

local t377 = {}

t377.__index = t377

function t377.new(t378: {[any]: any}?) -- line: 17223
	-- upvalues: t377 (copy)
	return (setmetatable({
		selected_option = if t378 ~= nil and t378.selected_option ~= nil then t378.selected_option else "",
		options = if t378 ~= nil and t378.options ~= nil then t378.options else {},
		experience_carousel = if t378 ~= nil and t378.experience_carousel ~= nil then t378.experience_carousel else nil
	}, t377))
end
function t377.encode(p230) -- line: 17235
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n153 = 0

	if p230.selected_option ~= nil and p230.selected_option ~= "" then
		local v2878, v2879 = proto.writeTag(buf, n153, 1, proto.wireTypes.lengthDelimited)

		buf, n153 = proto.writeString(v2878, v2879, p230.selected_option)
	end

	if p230.options ~= nil and #p230.options > 0 then
		for _, v2881 in p230.options do
			local v2882 = v2881:encode()
			local v2883, v2884 = proto.writeTag(buf, n153, 2, proto.wireTypes.lengthDelimited)

			buf, n153 = proto.writeBuffer(v2883, v2884, v2882, buffer.len(v2882))
		end
	end

	if p230.experience_carousel ~= nil then
		local v2885 = p230.experience_carousel:encode()
		local v2886, v2887 = proto.writeTag(buf, n153, 3, proto.wireTypes.lengthDelimited)

		buf, n153 = proto.writeBuffer(v2886, v2887, v2885, buffer.len(v2885))
	end

	local buf83 = buffer.create(n153)

	buffer.copy(buf83, 0, buf, 0, n153)

	return buf83
end
function t377.decode(p231: buffer) -- line: 17263
	-- upvalues: t377 (copy), proto (copy), t1 (copy)
	local v2890 = t377.new()
	local n154 = 0

	while n154 < buffer.len(p231) do
		local v2892, v2893

		v2892, v2893, n154 = proto.readTag(p231, n154)

		if v2893 == proto.wireTypes.varint then
			local v2894

			v2894, n154 = proto.readVarInt(p231, n154)
		elseif v2893 == proto.wireTypes.lengthDelimited then
			if v2892 == 1 then
				local v2895

				v2895, n154 = proto.readBuffer(p231, n154)
				v2890.selected_option = buffer.tostring(v2895)
			elseif v2892 == 2 then
				local v2896

				v2896, n154 = proto.readBuffer(p231, n154)
				table.insert(v2890.options, t1.SelectorOption.decode(v2896))
			elseif v2892 == 3 then
				local v2897

				v2897, n154 = proto.readBuffer(p231, n154)
				v2890.experience_carousel = t1.ExperienceCarouselInputData.decode(v2897)
			else
				local v2898, v2899 = proto.readVarInt(p231, n154)

				n154 = v2899 + v2898
			end
		elseif v2893 == proto.wireTypes.i32 then
			local v2900

			v2900, n154 = proto.readFixed32(p231, n154)
		elseif v2893 == proto.wireTypes.i64 then
			local v2901

			v2901, n154 = proto.readFixed64(p231, n154)
		else
			error("Unsupported wire type: " .. v2893)
		end
	end

	return v2890
end
function t377.jsonEncode(p232) -- line: 17316
	local t379 = {}

	if p232.selected_option ~= nil and p232.selected_option ~= "" then
		t379.selectedOption = p232.selected_option
	end

	if p232.options ~= nil and #p232.options > 0 then
		local t380 = {}

		for _, v2906 in p232.options do
			table.insert(t380, v2906:jsonEncode())
		end

		t379.options = t380
	end

	if p232.experience_carousel ~= nil then
		t379.experienceCarousel = p232.experience_carousel:jsonEncode()
	end

	return t379
end
function t377.jsonDecode(t381: {[any]: any}) -- line: 17338
	-- upvalues: t377 (copy), t1 (copy)
	local v2908 = t377.new()

	if t381.selected_option ~= nil then
		v2908.selected_option = t381.selected_option
	end

	if t381.selectedOption ~= nil then
		v2908.selected_option = t381.selectedOption
	end

	if t381.options ~= nil then
		local t382 = {}

		for _, v2911 in t381.options do
			table.insert(t382, t1.SelectorOption.jsonDecode(v2911))
		end

		v2908.options = t382
	end

	if t381.experience_carousel ~= nil then
		v2908.experience_carousel = t1.ExperienceCarouselInputData.jsonDecode(t381.experience_carousel)
	end

	if t381.experienceCarousel ~= nil then
		v2908.experience_carousel = t1.ExperienceCarouselInputData.jsonDecode(t381.experienceCarousel)
	end

	return v2908
end

t377.descriptor = {
	name = "ChartsGenreSelectorInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ChartsGenreSelectorInputData"
}
t1.ChartsGenreSelectorInputData = t377
typeRegistry.default:register(t1.ChartsGenreSelectorInputData)

local t383 = {}

t383.__index = t383

function t383.new(t384: {[any]: any}?) -- line: 17383
	-- upvalues: t383 (copy)
	return (setmetatable({
		id = if t384 ~= nil and t384.id ~= nil then t384.id else "",
		preview_rows = if t384 ~= nil and t384.preview_rows ~= nil then t384.preview_rows else 0,
		widget_style = if t384 ~= nil and t384.widget_style ~= nil then t384.widget_style else nil,
		see_all_button = t384 ~= nil and (t384.see_all_button ~= nil and t384.see_all_button),
		information_popover_text = if t384 ~= nil and t384.information_popover_text ~= nil then t384.information_popover_text else ""
	}, t383))
end
function t383.encode(p233) -- line: 17397
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n155 = 0

	if p233.id ~= nil and p233.id ~= "" then
		local v2916, v2917 = proto.writeTag(buf, n155, 1, proto.wireTypes.lengthDelimited)

		buf, n155 = proto.writeString(v2916, v2917, p233.id)
	end

	if p233.preview_rows ~= nil and p233.preview_rows ~= 0 then
		local v2918, v2919 = proto.writeTag(buf, n155, 4, proto.wireTypes.varint)

		buf, n155 = proto.writeVarInt(v2918, v2919, p233.preview_rows)
	end

	if p233.widget_style ~= nil then
		local v2920 = p233.widget_style:encode()
		local v2921, v2922 = proto.writeTag(buf, n155, 3, proto.wireTypes.lengthDelimited)

		buf, n155 = proto.writeBuffer(v2921, v2922, v2920, buffer.len(v2920))
	end

	if p233.see_all_button then
		local v2923, v2924 = proto.writeTag(buf, n155, 5, proto.wireTypes.varint)

		buf, n155 = proto.writeVarInt(v2923, v2924, not p233.see_all_button and 0 or 1)
	end

	if p233.information_popover_text ~= nil and p233.information_popover_text ~= "" then
		local v2925, v2926 = proto.writeTag(buf, n155, 6, proto.wireTypes.lengthDelimited)

		buf, n155 = proto.writeString(v2925, v2926, p233.information_popover_text)
	end

	local buf84 = buffer.create(n155)

	buffer.copy(buf84, 0, buf, 0, n155)

	return buf84
end
function t383.decode(p234: buffer) -- line: 17432
	-- upvalues: t383 (copy), proto (copy), t1 (copy)
	local v2929 = t383.new()
	local n156 = 0

	while n156 < buffer.len(p234) do
		local v2931, v2932

		v2931, v2932, n156 = proto.readTag(p234, n156)

		if v2932 == proto.wireTypes.varint then
			if v2931 == 4 then
				local v2933

				v2933, n156 = proto.readVarIntI64(p234, n156)
				v2929.preview_rows = v2933
			elseif v2931 == 5 then
				local v2934

				v2934, n156 = proto.readVarInt(p234, n156)
				v2929.see_all_button = v2934 ~= 0
			else
				local v2935

				v2935, n156 = proto.readVarInt(p234, n156)
			end
		elseif v2932 == proto.wireTypes.lengthDelimited then
			if v2931 == 1 then
				local v2936

				v2936, n156 = proto.readBuffer(p234, n156)
				v2929.id = buffer.tostring(v2936)
			elseif v2931 == 3 then
				local v2937

				v2937, n156 = proto.readBuffer(p234, n156)
				v2929.widget_style = t1.WidgetStyleData.decode(v2937)
			elseif v2931 == 6 then
				local v2938

				v2938, n156 = proto.readBuffer(p234, n156)
				v2929.information_popover_text = buffer.tostring(v2938)
			else
				local v2939, v2940 = proto.readVarInt(p234, n156)

				n156 = v2940 + v2939
			end
		elseif v2932 == proto.wireTypes.i32 then
			local v2941

			v2941, n156 = proto.readFixed32(p234, n156)
		elseif v2932 == proto.wireTypes.i64 then
			local v2942

			v2942, n156 = proto.readFixed64(p234, n156)
		else
			error("Unsupported wire type: " .. v2932)
		end
	end

	return v2929
end
function t383.jsonEncode(p235) -- line: 17495
	local t385 = {}

	if p235.id ~= nil and p235.id ~= "" then
		t385.id = p235.id
	end

	if p235.preview_rows ~= nil and p235.preview_rows ~= 0 then
		t385.previewRows = p235.preview_rows
	end

	if p235.widget_style ~= nil then
		t385.widgetStyle = p235.widget_style:jsonEncode()
	end

	if p235.see_all_button then
		t385.seeAllButton = p235.see_all_button
	end

	if p235.information_popover_text ~= nil and p235.information_popover_text ~= "" then
		t385.informationPopoverText = p235.information_popover_text
	end

	return t385
end
function t383.jsonDecode(t386: {[any]: any}) -- line: 17521
	-- upvalues: t383 (copy), t1 (copy)
	local v2946 = t383.new()

	if t386.id ~= nil then
		v2946.id = t386.id
	end

	if t386.preview_rows ~= nil then
		v2946.preview_rows = t386.preview_rows
	end

	if t386.previewRows ~= nil then
		v2946.preview_rows = t386.previewRows
	end

	if t386.widget_style ~= nil then
		v2946.widget_style = t1.WidgetStyleData.jsonDecode(t386.widget_style)
	end

	if t386.widgetStyle ~= nil then
		v2946.widget_style = t1.WidgetStyleData.jsonDecode(t386.widgetStyle)
	end

	if t386.see_all_button ~= nil then
		v2946.see_all_button = t386.see_all_button
	end

	if t386.seeAllButton ~= nil then
		v2946.see_all_button = t386.seeAllButton
	end

	if t386.information_popover_text ~= nil then
		v2946.information_popover_text = t386.information_popover_text
	end

	if t386.informationPopoverText ~= nil then
		v2946.information_popover_text = t386.informationPopoverText
	end

	return v2946
end

t383.descriptor = {
	name = "UAMarketplaceCatalogItemGroupInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UAMarketplaceCatalogItemGroupInputData"
}
t1.UAMarketplaceCatalogItemGroupInputData = t383
typeRegistry.default:register(t1.UAMarketplaceCatalogItemGroupInputData)

local t387 = {}

t387.__index = t387

function t387.new(t388: {[any]: any}?) -- line: 17579
	-- upvalues: t387 (copy)
	return (setmetatable({
		id = if t388 ~= nil and t388.id ~= nil then t388.id else "",
		num_items_to_show = if t388 ~= nil and t388.num_items_to_show ~= nil then t388.num_items_to_show else 0,
		widget_style = if t388 ~= nil and t388.widget_style ~= nil then t388.widget_style else nil,
		see_all_button = t388 ~= nil and (t388.see_all_button ~= nil and t388.see_all_button),
		information_popover_text = if t388 ~= nil and t388.information_popover_text ~= nil then t388.information_popover_text else ""
	}, t387))
end
function t387.encode(p236) -- line: 17593
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n157 = 0

	if p236.id ~= nil and p236.id ~= "" then
		local v2951, v2952 = proto.writeTag(buf, n157, 1, proto.wireTypes.lengthDelimited)

		buf, n157 = proto.writeString(v2951, v2952, p236.id)
	end

	if p236.num_items_to_show ~= nil and p236.num_items_to_show ~= 0 then
		local v2953, v2954 = proto.writeTag(buf, n157, 5, proto.wireTypes.varint)

		buf, n157 = proto.writeVarInt(v2953, v2954, p236.num_items_to_show)
	end

	if p236.widget_style ~= nil then
		local v2955 = p236.widget_style:encode()
		local v2956, v2957 = proto.writeTag(buf, n157, 3, proto.wireTypes.lengthDelimited)

		buf, n157 = proto.writeBuffer(v2956, v2957, v2955, buffer.len(v2955))
	end

	if p236.see_all_button then
		local v2958, v2959 = proto.writeTag(buf, n157, 6, proto.wireTypes.varint)

		buf, n157 = proto.writeVarInt(v2958, v2959, not p236.see_all_button and 0 or 1)
	end

	if p236.information_popover_text ~= nil and p236.information_popover_text ~= "" then
		local v2960, v2961 = proto.writeTag(buf, n157, 7, proto.wireTypes.lengthDelimited)

		buf, n157 = proto.writeString(v2960, v2961, p236.information_popover_text)
	end

	local buf85 = buffer.create(n157)

	buffer.copy(buf85, 0, buf, 0, n157)

	return buf85
end
function t387.decode(p237: buffer) -- line: 17630
	-- upvalues: t387 (copy), proto (copy), t1 (copy)
	local v2964 = t387.new()
	local n158 = 0

	while n158 < buffer.len(p237) do
		local v2966, v2967

		v2966, v2967, n158 = proto.readTag(p237, n158)

		if v2967 == proto.wireTypes.varint then
			if v2966 == 5 then
				local v2968

				v2968, n158 = proto.readVarIntI64(p237, n158)
				v2964.num_items_to_show = v2968
			elseif v2966 == 6 then
				local v2969

				v2969, n158 = proto.readVarInt(p237, n158)
				v2964.see_all_button = v2969 ~= 0
			else
				local v2970

				v2970, n158 = proto.readVarInt(p237, n158)
			end
		elseif v2967 == proto.wireTypes.lengthDelimited then
			if v2966 == 1 then
				local v2971

				v2971, n158 = proto.readBuffer(p237, n158)
				v2964.id = buffer.tostring(v2971)
			elseif v2966 == 3 then
				local v2972

				v2972, n158 = proto.readBuffer(p237, n158)
				v2964.widget_style = t1.WidgetStyleData.decode(v2972)
			elseif v2966 == 7 then
				local v2973

				v2973, n158 = proto.readBuffer(p237, n158)
				v2964.information_popover_text = buffer.tostring(v2973)
			else
				local v2974, v2975 = proto.readVarInt(p237, n158)

				n158 = v2975 + v2974
			end
		elseif v2967 == proto.wireTypes.i32 then
			local v2976

			v2976, n158 = proto.readFixed32(p237, n158)
		elseif v2967 == proto.wireTypes.i64 then
			local v2977

			v2977, n158 = proto.readFixed64(p237, n158)
		else
			error("Unsupported wire type: " .. v2967)
		end
	end

	return v2964
end
function t387.jsonEncode(p238) -- line: 17695
	local t389 = {}

	if p238.id ~= nil and p238.id ~= "" then
		t389.id = p238.id
	end

	if p238.num_items_to_show ~= nil and p238.num_items_to_show ~= 0 then
		t389.numItemsToShow = p238.num_items_to_show
	end

	if p238.widget_style ~= nil then
		t389.widgetStyle = p238.widget_style:jsonEncode()
	end

	if p238.see_all_button then
		t389.seeAllButton = p238.see_all_button
	end

	if p238.information_popover_text ~= nil and p238.information_popover_text ~= "" then
		t389.informationPopoverText = p238.information_popover_text
	end

	return t389
end
function t387.jsonDecode(t390: {[any]: any}) -- line: 17723
	-- upvalues: t387 (copy), t1 (copy)
	local v2981 = t387.new()

	if t390.id ~= nil then
		v2981.id = t390.id
	end

	if t390.num_items_to_show ~= nil then
		v2981.num_items_to_show = t390.num_items_to_show
	end

	if t390.numItemsToShow ~= nil then
		v2981.num_items_to_show = t390.numItemsToShow
	end

	if t390.widget_style ~= nil then
		v2981.widget_style = t1.WidgetStyleData.jsonDecode(t390.widget_style)
	end

	if t390.widgetStyle ~= nil then
		v2981.widget_style = t1.WidgetStyleData.jsonDecode(t390.widgetStyle)
	end

	if t390.see_all_button ~= nil then
		v2981.see_all_button = t390.see_all_button
	end

	if t390.seeAllButton ~= nil then
		v2981.see_all_button = t390.seeAllButton
	end

	if t390.information_popover_text ~= nil then
		v2981.information_popover_text = t390.information_popover_text
	end

	if t390.informationPopoverText ~= nil then
		v2981.information_popover_text = t390.informationPopoverText
	end

	return v2981
end

t387.descriptor = {
	name = "UAMarketplaceCatalogItemCarouselInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UAMarketplaceCatalogItemCarouselInputData"
}
t1.UAMarketplaceCatalogItemCarouselInputData = t387
typeRegistry.default:register(t1.UAMarketplaceCatalogItemCarouselInputData)

local t391 = {}

t391.__index = t391

function t391.new(t392: {[any]: any}?) -- line: 17781
	-- upvalues: t391 (copy)
	return (setmetatable({
		background_layers = if t392 ~= nil and t392.background_layers ~= nil then t392.background_layers else {}
	}, t391))
end
function t391.encode(p239) -- line: 17787
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n159 = 0

	if p239.background_layers ~= nil and #p239.background_layers > 0 then
		for _, v2987 in p239.background_layers do
			local v2988 = v2987:encode()
			local v2989, v2990 = proto.writeTag(buf, n159, 1, proto.wireTypes.lengthDelimited)

			buf, n159 = proto.writeBuffer(v2989, v2990, v2988, buffer.len(v2988))
		end
	end

	local buf86 = buffer.create(n159)

	buffer.copy(buf86, 0, buf, 0, n159)

	return buf86
end
function t391.decode(p240: buffer) -- line: 17804
	-- upvalues: t391 (copy), proto (copy), background_layer (copy)
	local v2993 = t391.new()
	local n160 = 0

	while n160 < buffer.len(p240) do
		local v2995, v2996

		v2995, v2996, n160 = proto.readTag(p240, n160)

		if v2996 == proto.wireTypes.varint then
			local v2997

			v2997, n160 = proto.readVarInt(p240, n160)
		elseif v2996 == proto.wireTypes.lengthDelimited then
			if v2995 == 1 then
				local v2998

				v2998, n160 = proto.readBuffer(p240, n160)
				table.insert(v2993.background_layers, background_layer.BackgroundLayer.decode(v2998))
			else
				local v2999, v3000 = proto.readVarInt(p240, n160)

				n160 = v3000 + v2999
			end
		elseif v2996 == proto.wireTypes.i32 then
			local v3001

			v3001, n160 = proto.readFixed32(p240, n160)
		elseif v2996 == proto.wireTypes.i64 then
			local v3002

			v3002, n160 = proto.readFixed64(p240, n160)
		else
			error("Unsupported wire type: " .. v2996)
		end
	end

	return v2993
end
function t391.jsonEncode(p241) -- line: 17850
	local t393 = {}

	if p241.background_layers ~= nil and #p241.background_layers > 0 then
		local t394 = {}

		for _, v3007 in p241.background_layers do
			table.insert(t394, v3007:jsonEncode())
		end

		t393.backgroundLayers = t394
	end

	return t393
end
function t391.jsonDecode(t395: {[any]: any}) -- line: 17864
	-- upvalues: t391 (copy), background_layer (copy)
	local v3009 = t391.new()

	if t395.background_layers ~= nil then
		local t396 = {}

		for _, v3012 in t395.background_layers do
			table.insert(t396, background_layer.BackgroundLayer.jsonDecode(v3012))
		end

		v3009.background_layers = t396
	end

	if t395.backgroundLayers ~= nil then
		local t397 = {}

		for _, v3015 in t395.backgroundLayers do
			table.insert(t397, background_layer.BackgroundLayer.jsonDecode(v3015))
		end

		v3009.background_layers = t397
	end

	return v3009
end

t391.descriptor = {
	name = "WidgetStyleData",
	fullName = "roblox.apppageplatform.shared.v1beta1.WidgetStyleData"
}
t1.WidgetStyleData = t391
typeRegistry.default:register(t1.WidgetStyleData)

local t398 = {}

t398.__index = t398

function t398.new(t399: {[any]: any}?) -- line: 17908
	-- upvalues: t398 (copy)
	return (setmetatable({
		id = if t399 ~= nil and t399.id ~= nil then t399.id else "",
		available_until = if t399 ~= nil and t399.available_until ~= nil then t399.available_until else "",
		widget_style = if t399 ~= nil and t399.widget_style ~= nil then t399.widget_style else nil
	}, t398))
end
function t398.encode(p242) -- line: 17918
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n161 = 0

	if p242.id ~= nil and p242.id ~= "" then
		local v3020, v3021 = proto.writeTag(buf, n161, 1, proto.wireTypes.lengthDelimited)

		buf, n161 = proto.writeString(v3020, v3021, p242.id)
	end

	if p242.available_until ~= nil and p242.available_until ~= "" then
		local v3022, v3023 = proto.writeTag(buf, n161, 2, proto.wireTypes.lengthDelimited)

		buf, n161 = proto.writeString(v3022, v3023, p242.available_until)
	end

	if p242.widget_style ~= nil then
		local v3024 = p242.widget_style:encode()
		local v3025, v3026 = proto.writeTag(buf, n161, 3, proto.wireTypes.lengthDelimited)

		buf, n161 = proto.writeBuffer(v3025, v3026, v3024, buffer.len(v3024))
	end

	local buf87 = buffer.create(n161)

	buffer.copy(buf87, 0, buf, 0, n161)

	return buf87
end
function t398.decode(p243: buffer) -- line: 17943
	-- upvalues: t398 (copy), proto (copy), t1 (copy)
	local v3029 = t398.new()
	local n162 = 0

	while n162 < buffer.len(p243) do
		local v3031, v3032

		v3031, v3032, n162 = proto.readTag(p243, n162)

		if v3032 == proto.wireTypes.varint then
			local v3033

			v3033, n162 = proto.readVarInt(p243, n162)
		elseif v3032 == proto.wireTypes.lengthDelimited then
			if v3031 == 1 then
				local v3034

				v3034, n162 = proto.readBuffer(p243, n162)
				v3029.id = buffer.tostring(v3034)
			elseif v3031 == 2 then
				local v3035

				v3035, n162 = proto.readBuffer(p243, n162)
				v3029.available_until = buffer.tostring(v3035)
			elseif v3031 == 3 then
				local v3036

				v3036, n162 = proto.readBuffer(p243, n162)
				v3029.widget_style = t1.WidgetStyleData.decode(v3036)
			else
				local v3037, v3038 = proto.readVarInt(p243, n162)

				n162 = v3038 + v3037
			end
		elseif v3032 == proto.wireTypes.i32 then
			local v3039

			v3039, n162 = proto.readFixed32(p243, n162)
		elseif v3032 == proto.wireTypes.i64 then
			local v3040

			v3040, n162 = proto.readFixed64(p243, n162)
		else
			error("Unsupported wire type: " .. v3032)
		end
	end

	return v3029
end
function t398.jsonEncode(p244) -- line: 17996
	local t400 = {}

	if p244.id ~= nil and p244.id ~= "" then
		t400.id = p244.id
	end

	if p244.available_until ~= nil and p244.available_until ~= "" then
		t400.availableUntil = p244.available_until
	end

	if p244.widget_style ~= nil then
		t400.widgetStyle = p244.widget_style:jsonEncode()
	end

	return t400
end
function t398.jsonDecode(t401: {[any]: any}) -- line: 18014
	-- upvalues: t398 (copy), t1 (copy)
	local v3044 = t398.new()

	if t401.id ~= nil then
		v3044.id = t401.id
	end

	if t401.available_until ~= nil then
		v3044.available_until = t401.available_until
	end

	if t401.availableUntil ~= nil then
		v3044.available_until = t401.availableUntil
	end

	if t401.widget_style ~= nil then
		v3044.widget_style = t1.WidgetStyleData.jsonDecode(t401.widget_style)
	end

	if t401.widgetStyle ~= nil then
		v3044.widget_style = t1.WidgetStyleData.jsonDecode(t401.widgetStyle)
	end

	return v3044
end

t398.descriptor = {
	name = "UAMarketplaceCatalogHeroUnitInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UAMarketplaceCatalogHeroUnitInputData"
}
t1.UAMarketplaceCatalogHeroUnitInputData = t398
typeRegistry.default:register(t1.UAMarketplaceCatalogHeroUnitInputData)

local t402 = {}

t402.__index = t402

function t402.new(t403: {[any]: any}?) -- line: 18056
	-- upvalues: t402 (copy)
	return (setmetatable({
		entry_map = if t403 ~= nil and t403.entry_map ~= nil then t403.entry_map else {},
		entry_order = if t403 ~= nil and t403.entry_order ~= nil then t403.entry_order else {}
	}, t402))
end
function t402.encode(p245) -- line: 18065
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n163 = 0

	if p245.entry_map ~= nil and next(p245.entry_map) ~= nil then
		for v3049, v3050 in p245.entry_map do
			local buf88 = buffer.create(0)
			local v3052, v3053 = proto.writeTag(buf88, 0, 1, proto.wireTypes.lengthDelimited)
			local v3054, v3055 = proto.writeString(v3052, v3053, v3049)
			local v3056 = v3050:encode()
			local v3057, v3058 = proto.writeTag(v3054, v3055, 2, proto.wireTypes.lengthDelimited)
			local v3059, v3060 = proto.writeBuffer(v3057, v3058, v3056, buffer.len(v3056))
			local v3061, v3062 = proto.writeTag(buf, n163, 1, proto.wireTypes.lengthDelimited)

			buf, n163 = proto.writeBuffer(v3061, v3062, v3059, v3060)
		end
	end

	if p245.entry_order ~= nil and #p245.entry_order > 0 then
		for _, v3064 in p245.entry_order do
			local v3065, v3066 = proto.writeTag(buf, n163, 2, proto.wireTypes.lengthDelimited)

			buf, n163 = proto.writeString(v3065, v3066, v3064)
		end
	end

	local buf89 = buffer.create(n163)

	buffer.copy(buf89, 0, buf, 0, n163)

	return buf89
end
function t402.decode(p246: buffer) -- line: 18095
	-- upvalues: t402 (copy), proto (copy), t1 (copy)
	local v3069 = t402.new()
	local n164 = 0

	while n164 < buffer.len(p246) do
		local v3071, v3072

		v3071, v3072, n164 = proto.readTag(p246, n164)

		if v3072 == proto.wireTypes.varint then
			local v3073

			v3073, n164 = proto.readVarInt(p246, n164)
		elseif v3072 == proto.wireTypes.lengthDelimited then
			if v3071 == 1 then
				local v3074

				v3074, n164 = proto.readBuffer(p246, n164)

				local v3075 = t1.UAMarketplaceCatalogFeedInputData_EntryMapEntry.decode(v3074)
				local v3076 = t1.FeedEntry.new()

				v3069.entry_map[v3075.key or ""] = v3075.value or v3076
			elseif v3071 == 2 then
				local v3077

				v3077, n164 = proto.readBuffer(p246, n164)
				table.insert(v3069.entry_order, buffer.tostring(v3077))
			else
				local v3078, v3079 = proto.readVarInt(p246, n164)

				n164 = v3079 + v3078
			end
		elseif v3072 == proto.wireTypes.i32 then
			local v3080

			v3080, n164 = proto.readFixed32(p246, n164)
		elseif v3072 == proto.wireTypes.i64 then
			local v3081

			v3081, n164 = proto.readFixed64(p246, n164)
		else
			error("Unsupported wire type: " .. v3072)
		end
	end

	return v3069
end
function t402.jsonEncode(p247) -- line: 18150
	local t404 = {}

	if p247.entry_map ~= nil and next(p247.entry_map) ~= nil then
		local t405 = {}

		for v3085, v3086 in p247.entry_map do
			t405[v3085] = v3086:jsonEncode()
		end

		t404.entryMap = t405
	end

	if p247.entry_order ~= nil and #p247.entry_order > 0 then
		local t406 = {}

		for _, v3089 in p247.entry_order do
			table.insert(t406, v3089)
		end

		t404.entryOrder = t406
	end

	return t404
end
function t402.jsonDecode(t407: {[any]: any}) -- line: 18172
	-- upvalues: t402 (copy), t1 (copy)
	local v3091 = t402.new()

	if t407.entry_map ~= nil then
		local t408 = {}

		for v3093, v3094 in t407.entry_map do
			t408[v3093] = t1.FeedEntry.jsonDecode(v3094)
		end

		v3091.entry_map = t408
	end

	if t407.entryMap ~= nil then
		local t409 = {}

		for v3096, v3097 in t407.entryMap do
			t409[v3096] = t1.FeedEntry.jsonDecode(v3097)
		end

		v3091.entry_map = t409
	end

	if t407.entry_order ~= nil then
		local t410 = {}

		for _, v3100 in t407.entry_order do
			table.insert(t410, v3100)
		end

		v3091.entry_order = t410
	end

	if t407.entryOrder ~= nil then
		local t411 = {}

		for _, v3103 in t407.entryOrder do
			table.insert(t411, v3103)
		end

		v3091.entry_order = t411
	end

	return v3091
end

t402.descriptor = {
	name = "UAMarketplaceCatalogFeedInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UAMarketplaceCatalogFeedInputData"
}
t1.UAMarketplaceCatalogFeedInputData = t402
typeRegistry.default:register(t1.UAMarketplaceCatalogFeedInputData)

local t412 = {}

t412.__index = t412

function t412.new(t413: {[any]: any}?) -- line: 18230
	-- upvalues: t412 (copy)
	return (setmetatable({
		key = if t413 ~= nil and t413.key ~= nil then t413.key else "",
		value = if t413 ~= nil and t413.value ~= nil then t413.value else nil
	}, t412))
end
function t412.encode(p248) -- line: 18239
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n165 = 0

	if p248.key ~= nil and p248.key ~= "" then
		local v3108, v3109 = proto.writeTag(buf, n165, 1, proto.wireTypes.lengthDelimited)

		buf, n165 = proto.writeString(v3108, v3109, p248.key)
	end

	if p248.value ~= nil then
		local v3110 = p248.value:encode()
		local v3111, v3112 = proto.writeTag(buf, n165, 2, proto.wireTypes.lengthDelimited)

		buf, n165 = proto.writeBuffer(v3111, v3112, v3110, buffer.len(v3110))
	end

	local buf90 = buffer.create(n165)

	buffer.copy(buf90, 0, buf, 0, n165)

	return buf90
end
function t412.decode(p249: buffer) -- line: 18261
	-- upvalues: t412 (copy), proto (copy), t1 (copy)
	local v3115 = t412.new()
	local n166 = 0

	while n166 < buffer.len(p249) do
		local v3117, v3118

		v3117, v3118, n166 = proto.readTag(p249, n166)

		if v3118 == proto.wireTypes.varint then
			local v3119

			v3119, n166 = proto.readVarInt(p249, n166)
		elseif v3118 == proto.wireTypes.lengthDelimited then
			if v3117 == 1 then
				local v3120

				v3120, n166 = proto.readBuffer(p249, n166)
				v3115.key = buffer.tostring(v3120)
			elseif v3117 == 2 then
				local v3121

				v3121, n166 = proto.readBuffer(p249, n166)
				v3115.value = t1.FeedEntry.decode(v3121)
			else
				local v3122, v3123 = proto.readVarInt(p249, n166)

				n166 = v3123 + v3122
			end
		elseif v3118 == proto.wireTypes.i32 then
			local v3124

			v3124, n166 = proto.readFixed32(p249, n166)
		elseif v3118 == proto.wireTypes.i64 then
			local v3125

			v3125, n166 = proto.readFixed64(p249, n166)
		else
			error("Unsupported wire type: " .. v3118)
		end
	end

	return v3115
end
function t412.jsonEncode(p250) -- line: 18311
	local t414 = {}

	if p250.key ~= nil and p250.key ~= "" then
		t414.key = p250.key
	end

	if p250.value ~= nil then
		t414.value = p250.value:jsonEncode()
	end

	return t414
end
function t412.jsonDecode(t415: {[any]: any}) -- line: 18327
	-- upvalues: t412 (copy), t1 (copy)
	local v3129 = t412.new()

	if t415.key ~= nil then
		v3129.key = t415.key
	end

	if t415.value ~= nil then
		v3129.value = t1.FeedEntry.jsonDecode(t415.value)
	end

	return v3129
end

t412.descriptor = {
	name = "UAMarketplaceCatalogFeedInputData_EntryMapEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryMapEntry"
}
t1.UAMarketplaceCatalogFeedInputData_EntryMapEntry = t412
typeRegistry.default:register(t1.UAMarketplaceCatalogFeedInputData_EntryMapEntry)

local t416 = {}

t416.__index = t416

function t416.new(t417: {[any]: any}?) -- line: 18358
	-- upvalues: t416 (copy)
	return (setmetatable({
		marketplace_catalog_category_items = if t417 ~= nil and t417.marketplace_catalog_category_items ~= nil then t417.marketplace_catalog_category_items else {},
		active_category_id = if t417 ~= nil and t417.active_category_id ~= nil then t417.active_category_id else "",
		active_tooltip_idx = if t417 ~= nil and t417.active_tooltip_idx ~= nil then t417.active_tooltip_idx else 0
	}, t416))
end
function t416.encode(p251) -- line: 18371
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n167 = 0

	if p251.marketplace_catalog_category_items ~= nil and #p251.marketplace_catalog_category_items > 0 then
		for _, v3135 in p251.marketplace_catalog_category_items do
			local v3136 = v3135:encode()
			local v3137, v3138 = proto.writeTag(buf, n167, 1, proto.wireTypes.lengthDelimited)

			buf, n167 = proto.writeBuffer(v3137, v3138, v3136, buffer.len(v3136))
		end
	end

	if p251.active_category_id ~= nil and p251.active_category_id ~= "" then
		local v3139, v3140 = proto.writeTag(buf, n167, 2, proto.wireTypes.lengthDelimited)

		buf, n167 = proto.writeString(v3139, v3140, p251.active_category_id)
	end

	if p251.active_tooltip_idx ~= nil and p251.active_tooltip_idx ~= 0 then
		local v3141, v3142 = proto.writeTag(buf, n167, 3, proto.wireTypes.varint)

		buf, n167 = proto.writeVarInt(v3141, v3142, p251.active_tooltip_idx)
	end

	local buf91 = buffer.create(n167)

	buffer.copy(buf91, 0, buf, 0, n167)

	return buf91
end
function t416.decode(p252: buffer) -- line: 18400
	-- upvalues: t416 (copy), proto (copy), t1 (copy)
	local v3145 = t416.new()
	local n168 = 0

	while n168 < buffer.len(p252) do
		local v3147, v3148

		v3147, v3148, n168 = proto.readTag(p252, n168)

		if v3148 == proto.wireTypes.varint then
			if v3147 == 3 then
				local v3149

				v3149, n168 = proto.readVarIntI64(p252, n168)
				v3145.active_tooltip_idx = v3149
			else
				local v3150

				v3150, n168 = proto.readVarInt(p252, n168)
			end
		elseif v3148 == proto.wireTypes.lengthDelimited then
			if v3147 == 1 then
				local v3151

				v3151, n168 = proto.readBuffer(p252, n168)
				table.insert(v3145.marketplace_catalog_category_items, t1.UAMarketplaceCatalogCategoryMenuInputData_MarketplaceCatalogCategoryItem.decode(v3151))
			elseif v3147 == 2 then
				local v3152

				v3152, n168 = proto.readBuffer(p252, n168)
				v3145.active_category_id = buffer.tostring(v3152)
			else
				local v3153, v3154 = proto.readVarInt(p252, n168)

				n168 = v3154 + v3153
			end
		elseif v3148 == proto.wireTypes.i32 then
			local v3155

			v3155, n168 = proto.readFixed32(p252, n168)
		elseif v3148 == proto.wireTypes.i64 then
			local v3156

			v3156, n168 = proto.readFixed64(p252, n168)
		else
			error("Unsupported wire type: " .. v3148)
		end
	end

	return v3145
end
function t416.jsonEncode(p253) -- line: 18458
	local t418 = {}

	if p253.marketplace_catalog_category_items ~= nil and #p253.marketplace_catalog_category_items > 0 then
		local t419 = {}

		for _, v3161 in p253.marketplace_catalog_category_items do
			table.insert(t419, v3161:jsonEncode())
		end

		t418.marketplaceCatalogCategoryItems = t419
	end

	if p253.active_category_id ~= nil and p253.active_category_id ~= "" then
		t418.activeCategoryId = p253.active_category_id
	end

	if p253.active_tooltip_idx ~= nil and p253.active_tooltip_idx ~= 0 then
		t418.activeTooltipIdx = p253.active_tooltip_idx
	end

	return t418
end
function t416.jsonDecode(t420: {[any]: any}) -- line: 18482
	-- upvalues: t416 (copy), t1 (copy)
	local v3163 = t416.new()

	if t420.marketplace_catalog_category_items ~= nil then
		local t421 = {}

		for _, v3166 in t420.marketplace_catalog_category_items do
			table.insert(t421, t1.UAMarketplaceCatalogCategoryMenuInputData_MarketplaceCatalogCategoryItem.jsonDecode(v3166))
		end

		v3163.marketplace_catalog_category_items = t421
	end

	if t420.marketplaceCatalogCategoryItems ~= nil then
		local t422 = {}

		for _, v3169 in t420.marketplaceCatalogCategoryItems do
			table.insert(t422, t1.UAMarketplaceCatalogCategoryMenuInputData_MarketplaceCatalogCategoryItem.jsonDecode(v3169))
		end

		v3163.marketplace_catalog_category_items = t422
	end

	if t420.active_category_id ~= nil then
		v3163.active_category_id = t420.active_category_id
	end

	if t420.activeCategoryId ~= nil then
		v3163.active_category_id = t420.activeCategoryId
	end

	if t420.active_tooltip_idx ~= nil then
		v3163.active_tooltip_idx = t420.active_tooltip_idx
	end

	if t420.activeTooltipIdx ~= nil then
		v3163.active_tooltip_idx = t420.activeTooltipIdx
	end

	return v3163
end

t416.descriptor = {
	name = "UAMarketplaceCatalogCategoryMenuInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UAMarketplaceCatalogCategoryMenuInputData"
}
t1.UAMarketplaceCatalogCategoryMenuInputData = t416
typeRegistry.default:register(t1.UAMarketplaceCatalogCategoryMenuInputData)

local t423 = {}

t423.__index = t423

function t423.new(t424: {[any]: any}?) -- line: 18545
	-- upvalues: t423 (copy)
	return (setmetatable({
		marketplace_catalog_category_item_id = if t424 ~= nil and t424.marketplace_catalog_category_item_id ~= nil then t424.marketplace_catalog_category_item_id else ""
	}, t423))
end
function t423.encode(p254) -- line: 18559
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n169 = 0

	if p254.marketplace_catalog_category_item_id ~= nil and p254.marketplace_catalog_category_item_id ~= "" then
		local v3174, v3175 = proto.writeTag(buf, n169, 1, proto.wireTypes.lengthDelimited)

		buf, n169 = proto.writeString(v3174, v3175, p254.marketplace_catalog_category_item_id)
	end

	local buf92 = buffer.create(n169)

	buffer.copy(buf92, 0, buf, 0, n169)

	return buf92
end
function t423.decode(p255: buffer) -- line: 18575
	-- upvalues: t423 (copy), proto (copy)
	local v3178 = t423.new()
	local n170 = 0

	while n170 < buffer.len(p255) do
		local v3180, v3181

		v3180, v3181, n170 = proto.readTag(p255, n170)

		if v3181 == proto.wireTypes.varint then
			local v3182

			v3182, n170 = proto.readVarInt(p255, n170)
		elseif v3181 == proto.wireTypes.lengthDelimited then
			if v3180 == 1 then
				local v3183

				v3183, n170 = proto.readBuffer(p255, n170)
				v3178.marketplace_catalog_category_item_id = buffer.tostring(v3183)
			else
				local v3184, v3185 = proto.readVarInt(p255, n170)

				n170 = v3185 + v3184
			end
		elseif v3181 == proto.wireTypes.i32 then
			local v3186

			v3186, n170 = proto.readFixed32(p255, n170)
		elseif v3181 == proto.wireTypes.i64 then
			local v3187

			v3187, n170 = proto.readFixed64(p255, n170)
		else
			error("Unsupported wire type: " .. v3181)
		end
	end

	return v3178
end
function t423.jsonEncode(p256) -- line: 18620
	local t425 = {}

	if p256.marketplace_catalog_category_item_id ~= nil and p256.marketplace_catalog_category_item_id ~= "" then
		t425.marketplaceCatalogCategoryItemId = p256.marketplace_catalog_category_item_id
	end

	return t425
end
function t423.jsonDecode(t426: {[any]: any}) -- line: 18632
	-- upvalues: t423 (copy)
	local v3191 = t423.new()

	if t426.marketplace_catalog_category_item_id ~= nil then
		v3191.marketplace_catalog_category_item_id = t426.marketplace_catalog_category_item_id
	end

	if t426.marketplaceCatalogCategoryItemId ~= nil then
		v3191.marketplace_catalog_category_item_id = t426.marketplaceCatalogCategoryItemId
	end

	return v3191
end

t423.descriptor = {
	name = "UAMarketplaceCatalogCategoryMenuInputData_MarketplaceCatalogCategoryItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.MarketplaceCatalogCategoryItem"
}
t1.UAMarketplaceCatalogCategoryMenuInputData_MarketplaceCatalogCategoryItem = t423
typeRegistry.default:register(t1.UAMarketplaceCatalogCategoryMenuInputData_MarketplaceCatalogCategoryItem)

local t427 = {}

t427.__index = t427

function t427.new(t428: {[any]: any}?) -- line: 18665
	-- upvalues: t427 (copy)
	return (setmetatable({
		hero_icon = if t428 ~= nil and t428.hero_icon ~= nil then t428.hero_icon else nil,
		body_dismiss_button_text = if t428 ~= nil and t428.body_dismiss_button_text ~= nil then t428.body_dismiss_button_text else "",
		body_title = if t428 ~= nil and t428.body_title ~= nil then t428.body_title else "",
		body_rich_text = if t428 ~= nil and t428.body_rich_text ~= nil then t428.body_rich_text else "",
		terms_link_text = if t428 ~= nil and t428.terms_link_text ~= nil then t428.terms_link_text else nil,
		terms_title = if t428 ~= nil and t428.terms_title ~= nil then t428.terms_title else nil,
		terms_body_rich_text = if t428 ~= nil and t428.terms_body_rich_text ~= nil then t428.terms_body_rich_text else nil,
		terms_dismiss_button_text = if t428 ~= nil and t428.terms_dismiss_button_text ~= nil then t428.terms_dismiss_button_text else nil,
		offer_id = if t428 ~= nil and t428.offer_id ~= nil then t428.offer_id else ""
	}, t427))
end
function t427.encode(p257) -- line: 18687
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n171 = 0

	if p257.hero_icon ~= nil then
		local v3196, v3197 = proto.writeTag(buf, n171, 1, proto.wireTypes.lengthDelimited)

		buf, n171 = proto.writeString(v3196, v3197, p257.hero_icon)
	end

	if p257.body_dismiss_button_text ~= nil and p257.body_dismiss_button_text ~= "" then
		local v3198, v3199 = proto.writeTag(buf, n171, 2, proto.wireTypes.lengthDelimited)

		buf, n171 = proto.writeString(v3198, v3199, p257.body_dismiss_button_text)
	end

	if p257.body_title ~= nil and p257.body_title ~= "" then
		local v3200, v3201 = proto.writeTag(buf, n171, 3, proto.wireTypes.lengthDelimited)

		buf, n171 = proto.writeString(v3200, v3201, p257.body_title)
	end

	if p257.body_rich_text ~= nil and p257.body_rich_text ~= "" then
		local v3202, v3203 = proto.writeTag(buf, n171, 4, proto.wireTypes.lengthDelimited)

		buf, n171 = proto.writeString(v3202, v3203, p257.body_rich_text)
	end

	if p257.terms_link_text ~= nil then
		local v3204, v3205 = proto.writeTag(buf, n171, 5, proto.wireTypes.lengthDelimited)

		buf, n171 = proto.writeString(v3204, v3205, p257.terms_link_text)
	end

	if p257.terms_title ~= nil then
		local v3206, v3207 = proto.writeTag(buf, n171, 6, proto.wireTypes.lengthDelimited)

		buf, n171 = proto.writeString(v3206, v3207, p257.terms_title)
	end

	if p257.terms_body_rich_text ~= nil then
		local v3208, v3209 = proto.writeTag(buf, n171, 7, proto.wireTypes.lengthDelimited)

		buf, n171 = proto.writeString(v3208, v3209, p257.terms_body_rich_text)
	end

	if p257.terms_dismiss_button_text ~= nil then
		local v3210, v3211 = proto.writeTag(buf, n171, 8, proto.wireTypes.lengthDelimited)

		buf, n171 = proto.writeString(v3210, v3211, p257.terms_dismiss_button_text)
	end

	if p257.offer_id ~= nil and p257.offer_id ~= "" then
		local v3212, v3213 = proto.writeTag(buf, n171, 9, proto.wireTypes.lengthDelimited)

		buf, n171 = proto.writeString(v3212, v3213, p257.offer_id)
	end

	local buf93 = buffer.create(n171)

	buffer.copy(buf93, 0, buf, 0, n171)

	return buf93
end
function t427.decode(p258: buffer) -- line: 18741
	-- upvalues: t427 (copy), proto (copy)
	local v3216 = t427.new()
	local n172 = 0

	while n172 < buffer.len(p258) do
		local v3218, v3219

		v3218, v3219, n172 = proto.readTag(p258, n172)

		if v3219 == proto.wireTypes.varint then
			local v3220

			v3220, n172 = proto.readVarInt(p258, n172)
		elseif v3219 == proto.wireTypes.lengthDelimited then
			if v3218 == 1 then
				local v3221

				v3221, n172 = proto.readBuffer(p258, n172)
				v3216.hero_icon = buffer.tostring(v3221)
			elseif v3218 == 2 then
				local v3222

				v3222, n172 = proto.readBuffer(p258, n172)
				v3216.body_dismiss_button_text = buffer.tostring(v3222)
			elseif v3218 == 3 then
				local v3223

				v3223, n172 = proto.readBuffer(p258, n172)
				v3216.body_title = buffer.tostring(v3223)
			elseif v3218 == 4 then
				local v3224

				v3224, n172 = proto.readBuffer(p258, n172)
				v3216.body_rich_text = buffer.tostring(v3224)
			elseif v3218 == 5 then
				local v3225

				v3225, n172 = proto.readBuffer(p258, n172)
				v3216.terms_link_text = buffer.tostring(v3225)
			elseif v3218 == 6 then
				local v3226

				v3226, n172 = proto.readBuffer(p258, n172)
				v3216.terms_title = buffer.tostring(v3226)
			elseif v3218 == 7 then
				local v3227

				v3227, n172 = proto.readBuffer(p258, n172)
				v3216.terms_body_rich_text = buffer.tostring(v3227)
			elseif v3218 == 8 then
				local v3228

				v3228, n172 = proto.readBuffer(p258, n172)
				v3216.terms_dismiss_button_text = buffer.tostring(v3228)
			elseif v3218 == 9 then
				local v3229

				v3229, n172 = proto.readBuffer(p258, n172)
				v3216.offer_id = buffer.tostring(v3229)
			else
				local v3230, v3231 = proto.readVarInt(p258, n172)

				n172 = v3231 + v3230
			end
		elseif v3219 == proto.wireTypes.i32 then
			local v3232

			v3232, n172 = proto.readFixed32(p258, n172)
		elseif v3219 == proto.wireTypes.i64 then
			local v3233

			v3233, n172 = proto.readFixed64(p258, n172)
		else
			error("Unsupported wire type: " .. v3219)
		end
	end

	return v3216
end
function t427.jsonEncode(p259) -- line: 18824
	local t429 = {}

	if p259.hero_icon ~= nil then
		t429.heroIcon = p259.hero_icon
	end

	if p259.body_dismiss_button_text ~= nil and p259.body_dismiss_button_text ~= "" then
		t429.bodyDismissButtonText = p259.body_dismiss_button_text
	end

	if p259.body_title ~= nil and p259.body_title ~= "" then
		t429.bodyTitle = p259.body_title
	end

	if p259.body_rich_text ~= nil and p259.body_rich_text ~= "" then
		t429.bodyRichText = p259.body_rich_text
	end

	if p259.terms_link_text ~= nil then
		t429.termsLinkText = p259.terms_link_text
	end

	if p259.terms_title ~= nil then
		t429.termsTitle = p259.terms_title
	end

	if p259.terms_body_rich_text ~= nil then
		t429.termsBodyRichText = p259.terms_body_rich_text
	end

	if p259.terms_dismiss_button_text ~= nil then
		t429.termsDismissButtonText = p259.terms_dismiss_button_text
	end

	if p259.offer_id ~= nil and p259.offer_id ~= "" then
		t429.offerId = p259.offer_id
	end

	return t429
end
function t427.jsonDecode(t430: {[any]: any}) -- line: 18866
	-- upvalues: t427 (copy)
	local v3237 = t427.new()

	if t430.hero_icon ~= nil then
		v3237.hero_icon = t430.hero_icon
	end

	if t430.heroIcon ~= nil then
		v3237.hero_icon = t430.heroIcon
	end

	if t430.body_dismiss_button_text ~= nil then
		v3237.body_dismiss_button_text = t430.body_dismiss_button_text
	end

	if t430.bodyDismissButtonText ~= nil then
		v3237.body_dismiss_button_text = t430.bodyDismissButtonText
	end

	if t430.body_title ~= nil then
		v3237.body_title = t430.body_title
	end

	if t430.bodyTitle ~= nil then
		v3237.body_title = t430.bodyTitle
	end

	if t430.body_rich_text ~= nil then
		v3237.body_rich_text = t430.body_rich_text
	end

	if t430.bodyRichText ~= nil then
		v3237.body_rich_text = t430.bodyRichText
	end

	if t430.terms_link_text ~= nil then
		v3237.terms_link_text = t430.terms_link_text
	end

	if t430.termsLinkText ~= nil then
		v3237.terms_link_text = t430.termsLinkText
	end

	if t430.terms_title ~= nil then
		v3237.terms_title = t430.terms_title
	end

	if t430.termsTitle ~= nil then
		v3237.terms_title = t430.termsTitle
	end

	if t430.terms_body_rich_text ~= nil then
		v3237.terms_body_rich_text = t430.terms_body_rich_text
	end

	if t430.termsBodyRichText ~= nil then
		v3237.terms_body_rich_text = t430.termsBodyRichText
	end

	if t430.terms_dismiss_button_text ~= nil then
		v3237.terms_dismiss_button_text = t430.terms_dismiss_button_text
	end

	if t430.termsDismissButtonText ~= nil then
		v3237.terms_dismiss_button_text = t430.termsDismissButtonText
	end

	if t430.offer_id ~= nil then
		v3237.offer_id = t430.offer_id
	end

	if t430.offerId ~= nil then
		v3237.offer_id = t430.offerId
	end

	return v3237
end

t427.descriptor = {
	name = "MarketplaceOfferModalInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.MarketplaceOfferModalInputData"
}
t1.MarketplaceOfferModalInputData = t427
typeRegistry.default:register(t1.MarketplaceOfferModalInputData)

local t431 = {}

t431.__index = t431

function t431.new(t432: {[any]: any}?) -- line: 18958
	-- upvalues: t431 (copy)
	return (setmetatable({
		items = if t432 ~= nil and t432.items ~= nil then t432.items else {},
		preview_columns = if t432 ~= nil and t432.preview_columns ~= nil then t432.preview_columns else 0,
		impression_id = if t432 ~= nil and t432.impression_id ~= nil then t432.impression_id else ""
	}, t431))
end
function t431.encode(p260) -- line: 18966
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n173 = 0

	if p260.items ~= nil and #p260.items > 0 then
		for _, v3243 in p260.items do
			local v3244 = v3243:encode()
			local v3245, v3246 = proto.writeTag(buf, n173, 1, proto.wireTypes.lengthDelimited)

			buf, n173 = proto.writeBuffer(v3245, v3246, v3244, buffer.len(v3244))
		end
	end

	if p260.preview_columns ~= nil and p260.preview_columns ~= 0 then
		local v3247, v3248 = proto.writeTag(buf, n173, 2, proto.wireTypes.varint)

		buf, n173 = proto.writeVarInt(v3247, v3248, p260.preview_columns)
	end

	if p260.impression_id ~= nil and p260.impression_id ~= "" then
		local v3249, v3250 = proto.writeTag(buf, n173, 3, proto.wireTypes.lengthDelimited)

		buf, n173 = proto.writeString(v3249, v3250, p260.impression_id)
	end

	local buf94 = buffer.create(n173)

	buffer.copy(buf94, 0, buf, 0, n173)

	return buf94
end
function t431.decode(p261: buffer) -- line: 18993
	-- upvalues: t431 (copy), proto (copy), t1 (copy)
	local v3253 = t431.new()
	local n174 = 0

	while n174 < buffer.len(p261) do
		local v3255, v3256

		v3255, v3256, n174 = proto.readTag(p261, n174)

		if v3256 == proto.wireTypes.varint then
			if v3255 == 2 then
				local v3257

				v3257, n174 = proto.readVarIntI32(p261, n174)
				v3253.preview_columns = v3257
			else
				local v3258

				v3258, n174 = proto.readVarInt(p261, n174)
			end
		elseif v3256 == proto.wireTypes.lengthDelimited then
			if v3255 == 1 then
				local v3259

				v3259, n174 = proto.readBuffer(p261, n174)
				table.insert(v3253.items, t1.CatalogItemGridInputData_CatalogItem.decode(v3259))
			elseif v3255 == 3 then
				local v3260

				v3260, n174 = proto.readBuffer(p261, n174)
				v3253.impression_id = buffer.tostring(v3260)
			else
				local v3261, v3262 = proto.readVarInt(p261, n174)

				n174 = v3262 + v3261
			end
		elseif v3256 == proto.wireTypes.i32 then
			local v3263

			v3263, n174 = proto.readFixed32(p261, n174)
		elseif v3256 == proto.wireTypes.i64 then
			local v3264

			v3264, n174 = proto.readFixed64(p261, n174)
		else
			error("Unsupported wire type: " .. v3256)
		end
	end

	return v3253
end
function t431.jsonEncode(p262) -- line: 19046
	local t433 = {}

	if p262.items ~= nil and #p262.items > 0 then
		local t434 = {}

		for _, v3269 in p262.items do
			table.insert(t434, v3269:jsonEncode())
		end

		t433.items = t434
	end

	if p262.preview_columns ~= nil and p262.preview_columns ~= 0 then
		t433.previewColumns = p262.preview_columns
	end

	if p262.impression_id ~= nil and p262.impression_id ~= "" then
		t433.impressionId = p262.impression_id
	end

	return t433
end
function t431.jsonDecode(t435: {[any]: any}) -- line: 19068
	-- upvalues: t431 (copy), t1 (copy)
	local v3271 = t431.new()

	if t435.items ~= nil then
		local t436 = {}

		for _, v3274 in t435.items do
			table.insert(t436, t1.CatalogItemGridInputData_CatalogItem.jsonDecode(v3274))
		end

		v3271.items = t436
	end

	if t435.preview_columns ~= nil then
		v3271.preview_columns = t435.preview_columns
	end

	if t435.previewColumns ~= nil then
		v3271.preview_columns = t435.previewColumns
	end

	if t435.impression_id ~= nil then
		v3271.impression_id = t435.impression_id
	end

	if t435.impressionId ~= nil then
		v3271.impression_id = t435.impressionId
	end

	return v3271
end

t431.descriptor = {
	name = "CatalogItemGridInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CatalogItemGridInputData"
}
t1.CatalogItemGridInputData = t431
typeRegistry.default:register(t1.CatalogItemGridInputData)

local t437 = {}

t437.__index = t437

function t437.new(t438: {[any]: any}?) -- line: 19113
	-- upvalues: t437 (copy)
	return (setmetatable({
		id = if t438 ~= nil and t438.id ~= nil then t438.id else "",
		type = if t438 ~= nil and t438.type ~= nil then t438.type else ""
	}, t437))
end
function t437.encode(p263) -- line: 19122
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n175 = 0

	if p263.id ~= nil and p263.id ~= "" then
		local v3279, v3280 = proto.writeTag(buf, n175, 1, proto.wireTypes.lengthDelimited)

		buf, n175 = proto.writeString(v3279, v3280, p263.id)
	end

	if p263.type ~= nil and p263.type ~= "" then
		local v3281, v3282 = proto.writeTag(buf, n175, 2, proto.wireTypes.lengthDelimited)

		buf, n175 = proto.writeString(v3281, v3282, p263.type)
	end

	local buf95 = buffer.create(n175)

	buffer.copy(buf95, 0, buf, 0, n175)

	return buf95
end
function t437.decode(p264: buffer) -- line: 19141
	-- upvalues: t437 (copy), proto (copy)
	local v3285 = t437.new()
	local n176 = 0

	while n176 < buffer.len(p264) do
		local v3287, v3288

		v3287, v3288, n176 = proto.readTag(p264, n176)

		if v3288 == proto.wireTypes.varint then
			local v3289

			v3289, n176 = proto.readVarInt(p264, n176)
		elseif v3288 == proto.wireTypes.lengthDelimited then
			if v3287 == 1 then
				local v3290

				v3290, n176 = proto.readBuffer(p264, n176)
				v3285.id = buffer.tostring(v3290)
			elseif v3287 == 2 then
				local v3291

				v3291, n176 = proto.readBuffer(p264, n176)
				v3285.type = buffer.tostring(v3291)
			else
				local v3292, v3293 = proto.readVarInt(p264, n176)

				n176 = v3293 + v3292
			end
		elseif v3288 == proto.wireTypes.i32 then
			local v3294

			v3294, n176 = proto.readFixed32(p264, n176)
		elseif v3288 == proto.wireTypes.i64 then
			local v3295

			v3295, n176 = proto.readFixed64(p264, n176)
		else
			error("Unsupported wire type: " .. v3288)
		end
	end

	return v3285
end
function t437.jsonEncode(p265) -- line: 19189
	local t439 = {}

	if p265.id ~= nil and p265.id ~= "" then
		t439.id = p265.id
	end

	if p265.type ~= nil and p265.type ~= "" then
		t439.type = p265.type
	end

	return t439
end
function t437.jsonDecode(t440: {[any]: any}) -- line: 19203
	-- upvalues: t437 (copy)
	local v3299 = t437.new()

	if t440.id ~= nil then
		v3299.id = t440.id
	end

	if t440.type ~= nil then
		v3299.type = t440.type
	end

	return v3299
end

t437.descriptor = {
	name = "CatalogItemGridInputData_CatalogItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.CatalogItem"
}
t1.CatalogItemGridInputData_CatalogItem = t437
typeRegistry.default:register(t1.CatalogItemGridInputData_CatalogItem)

local t441 = {}

t441.__index = t441

function t441.new(t442: {[any]: any}?) -- line: 19233
	-- upvalues: t441 (copy)
	return (setmetatable({
		entry_map = if t442 ~= nil and t442.entry_map ~= nil then t442.entry_map else {},
		entry_order = if t442 ~= nil and t442.entry_order ~= nil then t442.entry_order else {},
		content_pools = if t442 ~= nil and t442.content_pools ~= nil then t442.content_pools else {},
		search_session_id = if t442 ~= nil and t442.search_session_id ~= nil then t442.search_session_id else ""
	}, t441))
end
function t441.encode(p266) -- line: 19244
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n177 = 0

	if p266.entry_map ~= nil and next(p266.entry_map) ~= nil then
		for v3304, v3305 in p266.entry_map do
			local buf96 = buffer.create(0)
			local v3307, v3308 = proto.writeTag(buf96, 0, 1, proto.wireTypes.lengthDelimited)
			local v3309, v3310 = proto.writeString(v3307, v3308, v3304)
			local v3311 = v3305:encode()
			local v3312, v3313 = proto.writeTag(v3309, v3310, 2, proto.wireTypes.lengthDelimited)
			local v3314, v3315 = proto.writeBuffer(v3312, v3313, v3311, buffer.len(v3311))
			local v3316, v3317 = proto.writeTag(buf, n177, 1, proto.wireTypes.lengthDelimited)

			buf, n177 = proto.writeBuffer(v3316, v3317, v3314, v3315)
		end
	end

	if p266.entry_order ~= nil and #p266.entry_order > 0 then
		for _, v3319 in p266.entry_order do
			local v3320, v3321 = proto.writeTag(buf, n177, 2, proto.wireTypes.lengthDelimited)

			buf, n177 = proto.writeString(v3320, v3321, v3319)
		end
	end

	if p266.content_pools ~= nil and next(p266.content_pools) ~= nil then
		for v3322, v3323 in p266.content_pools do
			local buf97 = buffer.create(0)
			local v3325, v3326 = proto.writeTag(buf97, 0, 1, proto.wireTypes.lengthDelimited)
			local v3327, v3328 = proto.writeString(v3325, v3326, v3322)
			local v3329 = v3323:encode()
			local v3330, v3331 = proto.writeTag(v3327, v3328, 2, proto.wireTypes.lengthDelimited)
			local v3332, v3333 = proto.writeBuffer(v3330, v3331, v3329, buffer.len(v3329))
			local v3334, v3335 = proto.writeTag(buf, n177, 3, proto.wireTypes.lengthDelimited)

			buf, n177 = proto.writeBuffer(v3334, v3335, v3332, v3333)
		end
	end

	if p266.search_session_id ~= nil and p266.search_session_id ~= "" then
		local v3336, v3337 = proto.writeTag(buf, n177, 4, proto.wireTypes.lengthDelimited)

		buf, n177 = proto.writeString(v3336, v3337, p266.search_session_id)
	end

	local buf98 = buffer.create(n177)

	buffer.copy(buf98, 0, buf, 0, n177)

	return buf98
end
function t441.decode(p267: buffer) -- line: 19293
	-- upvalues: t441 (copy), proto (copy), t1 (copy)
	local v3340 = t441.new()
	local n178 = 0

	while n178 < buffer.len(p267) do
		local v3342, v3343

		v3342, v3343, n178 = proto.readTag(p267, n178)

		if v3343 == proto.wireTypes.varint then
			local v3344

			v3344, n178 = proto.readVarInt(p267, n178)
		elseif v3343 == proto.wireTypes.lengthDelimited then
			if v3342 == 1 then
				local v3345

				v3345, n178 = proto.readBuffer(p267, n178)

				local v3346 = t1.SearchResultsFeedInputData_EntryMapEntry.decode(v3345)
				local v3347 = t1.FeedEntry.new()

				v3340.entry_map[v3346.key or ""] = v3346.value or v3347
			elseif v3342 == 2 then
				local v3348

				v3348, n178 = proto.readBuffer(p267, n178)
				table.insert(v3340.entry_order, buffer.tostring(v3348))
			elseif v3342 == 3 then
				local v3349

				v3349, n178 = proto.readBuffer(p267, n178)

				local v3350 = t1.SearchResultsFeedInputData_ContentPoolsEntry.decode(v3349)
				local v3351 = t1.ContentPool.new()

				v3340.content_pools[v3350.key or ""] = v3350.value or v3351
			elseif v3342 == 4 then
				local v3352

				v3352, n178 = proto.readBuffer(p267, n178)
				v3340.search_session_id = buffer.tostring(v3352)
			else
				local v3353, v3354 = proto.readVarInt(p267, n178)

				n178 = v3354 + v3353
			end
		elseif v3343 == proto.wireTypes.i32 then
			local v3355

			v3355, n178 = proto.readFixed32(p267, n178)
		elseif v3343 == proto.wireTypes.i64 then
			local v3356

			v3356, n178 = proto.readFixed64(p267, n178)
		else
			error("Unsupported wire type: " .. v3343)
		end
	end

	return v3340
end
function t441.jsonEncode(p268) -- line: 19365
	local t443 = {}

	if p268.entry_map ~= nil and next(p268.entry_map) ~= nil then
		local t444 = {}

		for v3360, v3361 in p268.entry_map do
			t444[v3360] = v3361:jsonEncode()
		end

		t443.entryMap = t444
	end

	if p268.entry_order ~= nil and #p268.entry_order > 0 then
		local t445 = {}

		for _, v3364 in p268.entry_order do
			table.insert(t445, v3364)
		end

		t443.entryOrder = t445
	end

	if p268.content_pools ~= nil and next(p268.content_pools) ~= nil then
		local t446 = {}

		for v3366, v3367 in p268.content_pools do
			t446[v3366] = v3367:jsonEncode()
		end

		t443.contentPools = t446
	end

	if p268.search_session_id ~= nil and p268.search_session_id ~= "" then
		t443.searchSessionId = p268.search_session_id
	end

	return t443
end
function t441.jsonDecode(t447: {[any]: any}) -- line: 19399
	-- upvalues: t441 (copy), t1 (copy)
	local v3369 = t441.new()

	if t447.entry_map ~= nil then
		local t448 = {}

		for v3371, v3372 in t447.entry_map do
			t448[v3371] = t1.FeedEntry.jsonDecode(v3372)
		end

		v3369.entry_map = t448
	end

	if t447.entryMap ~= nil then
		local t449 = {}

		for v3374, v3375 in t447.entryMap do
			t449[v3374] = t1.FeedEntry.jsonDecode(v3375)
		end

		v3369.entry_map = t449
	end

	if t447.entry_order ~= nil then
		local t450 = {}

		for _, v3378 in t447.entry_order do
			table.insert(t450, v3378)
		end

		v3369.entry_order = t450
	end

	if t447.entryOrder ~= nil then
		local t451 = {}

		for _, v3381 in t447.entryOrder do
			table.insert(t451, v3381)
		end

		v3369.entry_order = t451
	end

	if t447.content_pools ~= nil then
		local t452 = {}

		for v3383, v3384 in t447.content_pools do
			t452[v3383] = t1.ContentPool.jsonDecode(v3384)
		end

		v3369.content_pools = t452
	end

	if t447.contentPools ~= nil then
		local t453 = {}

		for v3386, v3387 in t447.contentPools do
			t453[v3386] = t1.ContentPool.jsonDecode(v3387)
		end

		v3369.content_pools = t453
	end

	if t447.search_session_id ~= nil then
		v3369.search_session_id = t447.search_session_id
	end

	if t447.searchSessionId ~= nil then
		v3369.search_session_id = t447.searchSessionId
	end

	return v3369
end

t441.descriptor = {
	name = "SearchResultsFeedInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.SearchResultsFeedInputData"
}
t1.SearchResultsFeedInputData = t441
typeRegistry.default:register(t1.SearchResultsFeedInputData)

local t454 = {}

t454.__index = t454

function t454.new(t455: {[any]: any}?) -- line: 19481
	-- upvalues: t454 (copy)
	return (setmetatable({
		key = if t455 ~= nil and t455.key ~= nil then t455.key else "",
		value = if t455 ~= nil and t455.value ~= nil then t455.value else nil
	}, t454))
end
function t454.encode(p269) -- line: 19490
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n179 = 0

	if p269.key ~= nil and p269.key ~= "" then
		local v3392, v3393 = proto.writeTag(buf, n179, 1, proto.wireTypes.lengthDelimited)

		buf, n179 = proto.writeString(v3392, v3393, p269.key)
	end

	if p269.value ~= nil then
		local v3394 = p269.value:encode()
		local v3395, v3396 = proto.writeTag(buf, n179, 2, proto.wireTypes.lengthDelimited)

		buf, n179 = proto.writeBuffer(v3395, v3396, v3394, buffer.len(v3394))
	end

	local buf99 = buffer.create(n179)

	buffer.copy(buf99, 0, buf, 0, n179)

	return buf99
end
function t454.decode(p270: buffer) -- line: 19512
	-- upvalues: t454 (copy), proto (copy), t1 (copy)
	local v3399 = t454.new()
	local n180 = 0

	while n180 < buffer.len(p270) do
		local v3401, v3402

		v3401, v3402, n180 = proto.readTag(p270, n180)

		if v3402 == proto.wireTypes.varint then
			local v3403

			v3403, n180 = proto.readVarInt(p270, n180)
		elseif v3402 == proto.wireTypes.lengthDelimited then
			if v3401 == 1 then
				local v3404

				v3404, n180 = proto.readBuffer(p270, n180)
				v3399.key = buffer.tostring(v3404)
			elseif v3401 == 2 then
				local v3405

				v3405, n180 = proto.readBuffer(p270, n180)
				v3399.value = t1.FeedEntry.decode(v3405)
			else
				local v3406, v3407 = proto.readVarInt(p270, n180)

				n180 = v3407 + v3406
			end
		elseif v3402 == proto.wireTypes.i32 then
			local v3408

			v3408, n180 = proto.readFixed32(p270, n180)
		elseif v3402 == proto.wireTypes.i64 then
			local v3409

			v3409, n180 = proto.readFixed64(p270, n180)
		else
			error("Unsupported wire type: " .. v3402)
		end
	end

	return v3399
end
function t454.jsonEncode(p271) -- line: 19562
	local t456 = {}

	if p271.key ~= nil and p271.key ~= "" then
		t456.key = p271.key
	end

	if p271.value ~= nil then
		t456.value = p271.value:jsonEncode()
	end

	return t456
end
function t454.jsonDecode(t457: {[any]: any}) -- line: 19578
	-- upvalues: t454 (copy), t1 (copy)
	local v3413 = t454.new()

	if t457.key ~= nil then
		v3413.key = t457.key
	end

	if t457.value ~= nil then
		v3413.value = t1.FeedEntry.jsonDecode(t457.value)
	end

	return v3413
end

t454.descriptor = {
	name = "SearchResultsFeedInputData_EntryMapEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryMapEntry"
}
t1.SearchResultsFeedInputData_EntryMapEntry = t454
typeRegistry.default:register(t1.SearchResultsFeedInputData_EntryMapEntry)

local t458 = {}

t458.__index = t458

function t458.new(t459: {[any]: any}?) -- line: 19608
	-- upvalues: t458 (copy)
	return (setmetatable({
		key = if t459 ~= nil and t459.key ~= nil then t459.key else "",
		value = if t459 ~= nil and t459.value ~= nil then t459.value else nil
	}, t458))
end
function t458.encode(p272) -- line: 19617
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n181 = 0

	if p272.key ~= nil and p272.key ~= "" then
		local v3418, v3419 = proto.writeTag(buf, n181, 1, proto.wireTypes.lengthDelimited)

		buf, n181 = proto.writeString(v3418, v3419, p272.key)
	end

	if p272.value ~= nil then
		local v3420 = p272.value:encode()
		local v3421, v3422 = proto.writeTag(buf, n181, 2, proto.wireTypes.lengthDelimited)

		buf, n181 = proto.writeBuffer(v3421, v3422, v3420, buffer.len(v3420))
	end

	local buf100 = buffer.create(n181)

	buffer.copy(buf100, 0, buf, 0, n181)

	return buf100
end
function t458.decode(p273: buffer) -- line: 19639
	-- upvalues: t458 (copy), proto (copy), t1 (copy)
	local v3425 = t458.new()
	local n182 = 0

	while n182 < buffer.len(p273) do
		local v3427, v3428

		v3427, v3428, n182 = proto.readTag(p273, n182)

		if v3428 == proto.wireTypes.varint then
			local v3429

			v3429, n182 = proto.readVarInt(p273, n182)
		elseif v3428 == proto.wireTypes.lengthDelimited then
			if v3427 == 1 then
				local v3430

				v3430, n182 = proto.readBuffer(p273, n182)
				v3425.key = buffer.tostring(v3430)
			elseif v3427 == 2 then
				local v3431

				v3431, n182 = proto.readBuffer(p273, n182)
				v3425.value = t1.ContentPool.decode(v3431)
			else
				local v3432, v3433 = proto.readVarInt(p273, n182)

				n182 = v3433 + v3432
			end
		elseif v3428 == proto.wireTypes.i32 then
			local v3434

			v3434, n182 = proto.readFixed32(p273, n182)
		elseif v3428 == proto.wireTypes.i64 then
			local v3435

			v3435, n182 = proto.readFixed64(p273, n182)
		else
			error("Unsupported wire type: " .. v3428)
		end
	end

	return v3425
end
function t458.jsonEncode(p274) -- line: 19689
	local t460 = {}

	if p274.key ~= nil and p274.key ~= "" then
		t460.key = p274.key
	end

	if p274.value ~= nil then
		t460.value = p274.value:jsonEncode()
	end

	return t460
end
function t458.jsonDecode(t461: {[any]: any}) -- line: 19705
	-- upvalues: t458 (copy), t1 (copy)
	local v3439 = t458.new()

	if t461.key ~= nil then
		v3439.key = t461.key
	end

	if t461.value ~= nil then
		v3439.value = t1.ContentPool.jsonDecode(t461.value)
	end

	return v3439
end

t458.descriptor = {
	name = "SearchResultsFeedInputData_ContentPoolsEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.ContentPoolsEntry"
}
t1.SearchResultsFeedInputData_ContentPoolsEntry = t458
typeRegistry.default:register(t1.SearchResultsFeedInputData_ContentPoolsEntry)

local t462 = {}

t462.__index = t462

function t462.new(t463: {[any]: any}?) -- line: 19735
	-- upvalues: t462 (copy)
	return (setmetatable({
		universe_id = if t463 ~= nil and t463.universe_id ~= nil then t463.universe_id else "",
		is_content_locked = t463 ~= nil and (t463.is_content_locked ~= nil and t463.is_content_locked)
	}, t462))
end
function t462.encode(p275) -- line: 19744
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n183 = 0

	if p275.universe_id ~= nil and p275.universe_id ~= "" then
		local v3444, v3445 = proto.writeTag(buf, n183, 1, proto.wireTypes.lengthDelimited)

		buf, n183 = proto.writeString(v3444, v3445, p275.universe_id)
	end

	if p275.is_content_locked then
		local v3446, v3447 = proto.writeTag(buf, n183, 2, proto.wireTypes.varint)

		buf, n183 = proto.writeVarInt(v3446, v3447, not p275.is_content_locked and 0 or 1)
	end

	local buf101 = buffer.create(n183)

	buffer.copy(buf101, 0, buf, 0, n183)

	return buf101
end
function t462.decode(p276: buffer) -- line: 19763
	-- upvalues: t462 (copy), proto (copy)
	local v3450 = t462.new()
	local n184 = 0

	while n184 < buffer.len(p276) do
		local v3452, v3453

		v3452, v3453, n184 = proto.readTag(p276, n184)

		if v3453 == proto.wireTypes.varint then
			if v3452 == 2 then
				local v3454

				v3454, n184 = proto.readVarInt(p276, n184)
				v3450.is_content_locked = v3454 ~= 0
			else
				local v3455

				v3455, n184 = proto.readVarInt(p276, n184)
			end
		elseif v3453 == proto.wireTypes.lengthDelimited then
			if v3452 == 1 then
				local v3456

				v3456, n184 = proto.readBuffer(p276, n184)
				v3450.universe_id = buffer.tostring(v3456)
			else
				local v3457, v3458 = proto.readVarInt(p276, n184)

				n184 = v3458 + v3457
			end
		elseif v3453 == proto.wireTypes.i32 then
			local v3459

			v3459, n184 = proto.readFixed32(p276, n184)
		elseif v3453 == proto.wireTypes.i64 then
			local v3460

			v3460, n184 = proto.readFixed64(p276, n184)
		else
			error("Unsupported wire type: " .. v3453)
		end
	end

	return v3450
end
function t462.jsonEncode(p277) -- line: 19811
	local t464 = {}

	if p277.universe_id ~= nil and p277.universe_id ~= "" then
		t464.universeId = p277.universe_id
	end

	if p277.is_content_locked then
		t464.isContentLocked = p277.is_content_locked
	end

	return t464
end
function t462.jsonDecode(t465: {[any]: any}) -- line: 19825
	-- upvalues: t462 (copy)
	local v3464 = t462.new()

	if t465.universe_id ~= nil then
		v3464.universe_id = t465.universe_id
	end

	if t465.universeId ~= nil then
		v3464.universe_id = t465.universeId
	end

	if t465.is_content_locked ~= nil then
		v3464.is_content_locked = t465.is_content_locked
	end

	if t465.isContentLocked ~= nil then
		v3464.is_content_locked = t465.isContentLocked
	end

	return v3464
end

t462.descriptor = {
	name = "ExperienceEmphasisTileInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceEmphasisTileInputData"
}
t1.ExperienceEmphasisTileInputData = t462
typeRegistry.default:register(t1.ExperienceEmphasisTileInputData)

local t466 = {}

t466.__index = t466

function t466.new(t467: {[any]: any}?) -- line: 19861
	-- upvalues: t466 (copy)
	return (setmetatable({
		overview_rich_text = if t467 ~= nil and t467.overview_rich_text ~= nil then t467.overview_rich_text else "",
		result_entry = if t467 ~= nil and t467.result_entry ~= nil then t467.result_entry else nil,
		follow_up_queries = if t467 ~= nil and t467.follow_up_queries ~= nil then t467.follow_up_queries else {},
		show_loading = t467 ~= nil and (t467.show_loading ~= nil and t467.show_loading),
		title = if t467 ~= nil and t467.title ~= nil then t467.title else "",
		search_query = if t467 ~= nil and t467.search_query ~= nil then t467.search_query else "",
		universe_ids = if t467 ~= nil and t467.universe_ids ~= nil then t467.universe_ids else ""
	}, t466))
end
function t466.encode(p278) -- line: 19875
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n185 = 0

	if p278.overview_rich_text ~= nil and p278.overview_rich_text ~= "" then
		local v3469, v3470 = proto.writeTag(buf, n185, 1, proto.wireTypes.lengthDelimited)

		buf, n185 = proto.writeString(v3469, v3470, p278.overview_rich_text)
	end

	if p278.result_entry ~= nil then
		local v3471 = p278.result_entry:encode()
		local v3472, v3473 = proto.writeTag(buf, n185, 2, proto.wireTypes.lengthDelimited)

		buf, n185 = proto.writeBuffer(v3472, v3473, v3471, buffer.len(v3471))
	end

	if p278.follow_up_queries ~= nil and #p278.follow_up_queries > 0 then
		for _, v3475 in p278.follow_up_queries do
			local v3476, v3477 = proto.writeTag(buf, n185, 3, proto.wireTypes.lengthDelimited)

			buf, n185 = proto.writeString(v3476, v3477, v3475)
		end
	end

	if p278.show_loading then
		local v3478, v3479 = proto.writeTag(buf, n185, 4, proto.wireTypes.varint)

		buf, n185 = proto.writeVarInt(v3478, v3479, not p278.show_loading and 0 or 1)
	end

	if p278.title ~= nil and p278.title ~= "" then
		local v3480, v3481 = proto.writeTag(buf, n185, 5, proto.wireTypes.lengthDelimited)

		buf, n185 = proto.writeString(v3480, v3481, p278.title)
	end

	if p278.search_query ~= nil and p278.search_query ~= "" then
		local v3482, v3483 = proto.writeTag(buf, n185, 6, proto.wireTypes.lengthDelimited)

		buf, n185 = proto.writeString(v3482, v3483, p278.search_query)
	end

	if p278.universe_ids ~= nil and p278.universe_ids ~= "" then
		local v3484, v3485 = proto.writeTag(buf, n185, 8, proto.wireTypes.lengthDelimited)

		buf, n185 = proto.writeString(v3484, v3485, p278.universe_ids)
	end

	local buf102 = buffer.create(n185)

	buffer.copy(buf102, 0, buf, 0, n185)

	return buf102
end
function t466.decode(p279: buffer) -- line: 19922
	-- upvalues: t466 (copy), proto (copy), t1 (copy)
	local v3488 = t466.new()
	local n186 = 0

	while n186 < buffer.len(p279) do
		local v3490, v3491

		v3490, v3491, n186 = proto.readTag(p279, n186)

		if v3491 == proto.wireTypes.varint then
			if v3490 == 4 then
				local v3492

				v3492, n186 = proto.readVarInt(p279, n186)
				v3488.show_loading = v3492 ~= 0
			else
				local v3493

				v3493, n186 = proto.readVarInt(p279, n186)
			end
		elseif v3491 == proto.wireTypes.lengthDelimited then
			if v3490 == 1 then
				local v3494

				v3494, n186 = proto.readBuffer(p279, n186)
				v3488.overview_rich_text = buffer.tostring(v3494)
			elseif v3490 == 2 then
				local v3495

				v3495, n186 = proto.readBuffer(p279, n186)
				v3488.result_entry = t1.FeedEntry.decode(v3495)
			elseif v3490 == 3 then
				local v3496

				v3496, n186 = proto.readBuffer(p279, n186)
				table.insert(v3488.follow_up_queries, buffer.tostring(v3496))
			elseif v3490 == 5 then
				local v3497

				v3497, n186 = proto.readBuffer(p279, n186)
				v3488.title = buffer.tostring(v3497)
			elseif v3490 == 6 then
				local v3498

				v3498, n186 = proto.readBuffer(p279, n186)
				v3488.search_query = buffer.tostring(v3498)
			elseif v3490 == 8 then
				local v3499

				v3499, n186 = proto.readBuffer(p279, n186)
				v3488.universe_ids = buffer.tostring(v3499)
			else
				local v3500, v3501 = proto.readVarInt(p279, n186)

				n186 = v3501 + v3500
			end
		elseif v3491 == proto.wireTypes.i32 then
			local v3502

			v3502, n186 = proto.readFixed32(p279, n186)
		elseif v3491 == proto.wireTypes.i64 then
			local v3503

			v3503, n186 = proto.readFixed64(p279, n186)
		else
			error("Unsupported wire type: " .. v3491)
		end
	end

	return v3488
end
function t466.jsonEncode(p280) -- line: 19995
	local t468 = {}

	if p280.overview_rich_text ~= nil and p280.overview_rich_text ~= "" then
		t468.overviewRichText = p280.overview_rich_text
	end

	if p280.result_entry ~= nil then
		t468.resultEntry = p280.result_entry:jsonEncode()
	end

	if p280.follow_up_queries ~= nil and #p280.follow_up_queries > 0 then
		local t469 = {}

		for _, v3508 in p280.follow_up_queries do
			table.insert(t469, v3508)
		end

		t468.followUpQueries = t469
	end

	if p280.show_loading then
		t468.showLoading = p280.show_loading
	end

	if p280.title ~= nil and p280.title ~= "" then
		t468.title = p280.title
	end

	if p280.search_query ~= nil and p280.search_query ~= "" then
		t468.searchQuery = p280.search_query
	end

	if p280.universe_ids ~= nil and p280.universe_ids ~= "" then
		t468.universeIds = p280.universe_ids
	end

	return t468
end
function t466.jsonDecode(t470: {[any]: any}) -- line: 20033
	-- upvalues: t466 (copy), t1 (copy)
	local v3510 = t466.new()

	if t470.overview_rich_text ~= nil then
		v3510.overview_rich_text = t470.overview_rich_text
	end

	if t470.overviewRichText ~= nil then
		v3510.overview_rich_text = t470.overviewRichText
	end

	if t470.result_entry ~= nil then
		v3510.result_entry = t1.FeedEntry.jsonDecode(t470.result_entry)
	end

	if t470.resultEntry ~= nil then
		v3510.result_entry = t1.FeedEntry.jsonDecode(t470.resultEntry)
	end

	if t470.follow_up_queries ~= nil then
		local t471 = {}

		for _, v3513 in t470.follow_up_queries do
			table.insert(t471, v3513)
		end

		v3510.follow_up_queries = t471
	end

	if t470.followUpQueries ~= nil then
		local t472 = {}

		for _, v3516 in t470.followUpQueries do
			table.insert(t472, v3516)
		end

		v3510.follow_up_queries = t472
	end

	if t470.show_loading ~= nil then
		v3510.show_loading = t470.show_loading
	end

	if t470.showLoading ~= nil then
		v3510.show_loading = t470.showLoading
	end

	if t470.title ~= nil then
		v3510.title = t470.title
	end

	if t470.search_query ~= nil then
		v3510.search_query = t470.search_query
	end

	if t470.searchQuery ~= nil then
		v3510.search_query = t470.searchQuery
	end

	if t470.universe_ids ~= nil then
		v3510.universe_ids = t470.universe_ids
	end

	if t470.universeIds ~= nil then
		v3510.universe_ids = t470.universeIds
	end

	return v3510
end

t466.descriptor = {
	name = "PowerSearchAIOverviewInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.PowerSearchAIOverviewInputData"
}
t1.PowerSearchAIOverviewInputData = t466
typeRegistry.default:register(t1.PowerSearchAIOverviewInputData)

local t473 = {}

t473.__index = t473

function t473.new(t474: {[any]: any}?) -- line: 20115
	-- upvalues: t473 (copy)
	return (setmetatable({
		title = if t474 ~= nil and t474.title ~= nil then t474.title else "",
		user_items = if t474 ~= nil and t474.user_items ~= nil then t474.user_items else {},
		max_visible_rows = if t474 ~= nil and t474.max_visible_rows ~= nil then t474.max_visible_rows else 0
	}, t473))
end
function t473.encode(p281) -- line: 20123
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n187 = 0

	if p281.title ~= nil and p281.title ~= "" then
		local v3521, v3522 = proto.writeTag(buf, n187, 1, proto.wireTypes.lengthDelimited)

		buf, n187 = proto.writeString(v3521, v3522, p281.title)
	end

	if p281.user_items ~= nil and #p281.user_items > 0 then
		for _, v3524 in p281.user_items do
			local v3525 = v3524:encode()
			local v3526, v3527 = proto.writeTag(buf, n187, 2, proto.wireTypes.lengthDelimited)

			buf, n187 = proto.writeBuffer(v3526, v3527, v3525, buffer.len(v3525))
		end
	end

	if p281.max_visible_rows ~= nil and p281.max_visible_rows ~= 0 then
		local v3528, v3529 = proto.writeTag(buf, n187, 3, proto.wireTypes.varint)

		buf, n187 = proto.writeVarInt(v3528, v3529, p281.max_visible_rows)
	end

	local buf103 = buffer.create(n187)

	buffer.copy(buf103, 0, buf, 0, n187)

	return buf103
end
function t473.decode(p282: buffer) -- line: 20150
	-- upvalues: t473 (copy), proto (copy), t1 (copy)
	local v3532 = t473.new()
	local n188 = 0

	while n188 < buffer.len(p282) do
		local v3534, v3535

		v3534, v3535, n188 = proto.readTag(p282, n188)

		if v3535 == proto.wireTypes.varint then
			if v3534 == 3 then
				local v3536

				v3536, n188 = proto.readVarIntI32(p282, n188)
				v3532.max_visible_rows = v3536
			else
				local v3537

				v3537, n188 = proto.readVarInt(p282, n188)
			end
		elseif v3535 == proto.wireTypes.lengthDelimited then
			if v3534 == 1 then
				local v3538

				v3538, n188 = proto.readBuffer(p282, n188)
				v3532.title = buffer.tostring(v3538)
			elseif v3534 == 2 then
				local v3539

				v3539, n188 = proto.readBuffer(p282, n188)
				table.insert(v3532.user_items, t1.UserListInputData_UserItem.decode(v3539))
			else
				local v3540, v3541 = proto.readVarInt(p282, n188)

				n188 = v3541 + v3540
			end
		elseif v3535 == proto.wireTypes.i32 then
			local v3542

			v3542, n188 = proto.readFixed32(p282, n188)
		elseif v3535 == proto.wireTypes.i64 then
			local v3543

			v3543, n188 = proto.readFixed64(p282, n188)
		else
			error("Unsupported wire type: " .. v3535)
		end
	end

	return v3532
end
function t473.jsonEncode(p283) -- line: 20203
	local t475 = {}

	if p283.title ~= nil and p283.title ~= "" then
		t475.title = p283.title
	end

	if p283.user_items ~= nil and #p283.user_items > 0 then
		local t476 = {}

		for _, v3548 in p283.user_items do
			table.insert(t476, v3548:jsonEncode())
		end

		t475.userItems = t476
	end

	if p283.max_visible_rows ~= nil and p283.max_visible_rows ~= 0 then
		t475.maxVisibleRows = p283.max_visible_rows
	end

	return t475
end
function t473.jsonDecode(t477: {[any]: any}) -- line: 20225
	-- upvalues: t473 (copy), t1 (copy)
	local v3550 = t473.new()

	if t477.title ~= nil then
		v3550.title = t477.title
	end

	if t477.user_items ~= nil then
		local t478 = {}

		for _, v3553 in t477.user_items do
			table.insert(t478, t1.UserListInputData_UserItem.jsonDecode(v3553))
		end

		v3550.user_items = t478
	end

	if t477.userItems ~= nil then
		local t479 = {}

		for _, v3556 in t477.userItems do
			table.insert(t479, t1.UserListInputData_UserItem.jsonDecode(v3556))
		end

		v3550.user_items = t479
	end

	if t477.max_visible_rows ~= nil then
		v3550.max_visible_rows = t477.max_visible_rows
	end

	if t477.maxVisibleRows ~= nil then
		v3550.max_visible_rows = t477.maxVisibleRows
	end

	return v3550
end

t473.descriptor = {
	name = "UserListInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UserListInputData"
}
t1.UserListInputData = t473
typeRegistry.default:register(t1.UserListInputData)

local t480 = {}

t480.__index = t480

function t480.new(t481: {[any]: any}?) -- line: 20275
	-- upvalues: t480 (copy)
	return (setmetatable({
		user_id = if t481 ~= nil and t481.user_id ~= nil then t481.user_id else ""
	}, t480))
end
function t480.encode(p284) -- line: 20283
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n189 = 0

	if p284.user_id ~= nil and p284.user_id ~= "" then
		local v3561, v3562 = proto.writeTag(buf, n189, 1, proto.wireTypes.lengthDelimited)

		buf, n189 = proto.writeString(v3561, v3562, p284.user_id)
	end

	local buf104 = buffer.create(n189)

	buffer.copy(buf104, 0, buf, 0, n189)

	return buf104
end
function t480.decode(p285: buffer) -- line: 20297
	-- upvalues: t480 (copy), proto (copy)
	local v3565 = t480.new()
	local n190 = 0

	while n190 < buffer.len(p285) do
		local v3567, v3568

		v3567, v3568, n190 = proto.readTag(p285, n190)

		if v3568 == proto.wireTypes.varint then
			local v3569

			v3569, n190 = proto.readVarInt(p285, n190)
		elseif v3568 == proto.wireTypes.lengthDelimited then
			if v3567 == 1 then
				local v3570

				v3570, n190 = proto.readBuffer(p285, n190)
				v3565.user_id = buffer.tostring(v3570)
			else
				local v3571, v3572 = proto.readVarInt(p285, n190)

				n190 = v3572 + v3571
			end
		elseif v3568 == proto.wireTypes.i32 then
			local v3573

			v3573, n190 = proto.readFixed32(p285, n190)
		elseif v3568 == proto.wireTypes.i64 then
			local v3574

			v3574, n190 = proto.readFixed64(p285, n190)
		else
			error("Unsupported wire type: " .. v3568)
		end
	end

	return v3565
end
function t480.jsonEncode(p286) -- line: 20340
	local t482 = {}

	if p286.user_id ~= nil and p286.user_id ~= "" then
		t482.userId = p286.user_id
	end

	return t482
end
function t480.jsonDecode(t483: {[any]: any}) -- line: 20350
	-- upvalues: t480 (copy)
	local v3578 = t480.new()

	if t483.user_id ~= nil then
		v3578.user_id = t483.user_id
	end

	if t483.userId ~= nil then
		v3578.user_id = t483.userId
	end

	return v3578
end

t480.descriptor = {
	name = "UserListInputData_UserItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.UserItem"
}
t1.UserListInputData_UserItem = t480
typeRegistry.default:register(t1.UserListInputData_UserItem)

local t484 = {}

t484.__index = t484

function t484.new(t485: {[any]: any}?) -- line: 20378
	-- upvalues: t484 (copy)
	return (setmetatable({
		title = if t485 ~= nil and t485.title ~= nil then t485.title else "",
		items = if t485 ~= nil and t485.items ~= nil then t485.items else {},
		max_visible_rows = if t485 ~= nil and t485.max_visible_rows ~= nil then t485.max_visible_rows else 0
	}, t484))
end
function t484.encode(p287) -- line: 20386
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n191 = 0

	if p287.title ~= nil and p287.title ~= "" then
		local v3583, v3584 = proto.writeTag(buf, n191, 1, proto.wireTypes.lengthDelimited)

		buf, n191 = proto.writeString(v3583, v3584, p287.title)
	end

	if p287.items ~= nil and #p287.items > 0 then
		for _, v3586 in p287.items do
			local v3587 = v3586:encode()
			local v3588, v3589 = proto.writeTag(buf, n191, 2, proto.wireTypes.lengthDelimited)

			buf, n191 = proto.writeBuffer(v3588, v3589, v3587, buffer.len(v3587))
		end
	end

	if p287.max_visible_rows ~= nil and p287.max_visible_rows ~= 0 then
		local v3590, v3591 = proto.writeTag(buf, n191, 3, proto.wireTypes.varint)

		buf, n191 = proto.writeVarInt(v3590, v3591, p287.max_visible_rows)
	end

	local buf105 = buffer.create(n191)

	buffer.copy(buf105, 0, buf, 0, n191)

	return buf105
end
function t484.decode(p288: buffer) -- line: 20413
	-- upvalues: t484 (copy), proto (copy), t1 (copy)
	local v3594 = t484.new()
	local n192 = 0

	while n192 < buffer.len(p288) do
		local v3596, v3597

		v3596, v3597, n192 = proto.readTag(p288, n192)

		if v3597 == proto.wireTypes.varint then
			if v3596 == 3 then
				local v3598

				v3598, n192 = proto.readVarIntI32(p288, n192)
				v3594.max_visible_rows = v3598
			else
				local v3599

				v3599, n192 = proto.readVarInt(p288, n192)
			end
		elseif v3597 == proto.wireTypes.lengthDelimited then
			if v3596 == 1 then
				local v3600

				v3600, n192 = proto.readBuffer(p288, n192)
				v3594.title = buffer.tostring(v3600)
			elseif v3596 == 2 then
				local v3601

				v3601, n192 = proto.readBuffer(p288, n192)
				table.insert(v3594.items, t1.CatalogItemListInputData_CatalogItem.decode(v3601))
			else
				local v3602, v3603 = proto.readVarInt(p288, n192)

				n192 = v3603 + v3602
			end
		elseif v3597 == proto.wireTypes.i32 then
			local v3604

			v3604, n192 = proto.readFixed32(p288, n192)
		elseif v3597 == proto.wireTypes.i64 then
			local v3605

			v3605, n192 = proto.readFixed64(p288, n192)
		else
			error("Unsupported wire type: " .. v3597)
		end
	end

	return v3594
end
function t484.jsonEncode(p289) -- line: 20466
	local t486 = {}

	if p289.title ~= nil and p289.title ~= "" then
		t486.title = p289.title
	end

	if p289.items ~= nil and #p289.items > 0 then
		local t487 = {}

		for _, v3610 in p289.items do
			table.insert(t487, v3610:jsonEncode())
		end

		t486.items = t487
	end

	if p289.max_visible_rows ~= nil and p289.max_visible_rows ~= 0 then
		t486.maxVisibleRows = p289.max_visible_rows
	end

	return t486
end
function t484.jsonDecode(t488: {[any]: any}) -- line: 20488
	-- upvalues: t484 (copy), t1 (copy)
	local v3612 = t484.new()

	if t488.title ~= nil then
		v3612.title = t488.title
	end

	if t488.items ~= nil then
		local t489 = {}

		for _, v3615 in t488.items do
			table.insert(t489, t1.CatalogItemListInputData_CatalogItem.jsonDecode(v3615))
		end

		v3612.items = t489
	end

	if t488.max_visible_rows ~= nil then
		v3612.max_visible_rows = t488.max_visible_rows
	end

	if t488.maxVisibleRows ~= nil then
		v3612.max_visible_rows = t488.maxVisibleRows
	end

	return v3612
end

t484.descriptor = {
	name = "CatalogItemListInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CatalogItemListInputData"
}
t1.CatalogItemListInputData = t484
typeRegistry.default:register(t1.CatalogItemListInputData)

local t490 = {}

t490.__index = t490

function t490.new(t491: {[any]: any}?) -- line: 20529
	-- upvalues: t490 (copy)
	return (setmetatable({
		item_id = if t491 ~= nil and t491.item_id ~= nil then t491.item_id else "",
		item_type = if t491 ~= nil and t491.item_type ~= nil then t491.item_type else ""
	}, t490))
end
function t490.encode(p290) -- line: 20538
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n193 = 0

	if p290.item_id ~= nil and p290.item_id ~= "" then
		local v3620, v3621 = proto.writeTag(buf, n193, 1, proto.wireTypes.lengthDelimited)

		buf, n193 = proto.writeString(v3620, v3621, p290.item_id)
	end

	if p290.item_type ~= nil and p290.item_type ~= "" then
		local v3622, v3623 = proto.writeTag(buf, n193, 2, proto.wireTypes.lengthDelimited)

		buf, n193 = proto.writeString(v3622, v3623, p290.item_type)
	end

	local buf106 = buffer.create(n193)

	buffer.copy(buf106, 0, buf, 0, n193)

	return buf106
end
function t490.decode(p291: buffer) -- line: 20557
	-- upvalues: t490 (copy), proto (copy)
	local v3626 = t490.new()
	local n194 = 0

	while n194 < buffer.len(p291) do
		local v3628, v3629

		v3628, v3629, n194 = proto.readTag(p291, n194)

		if v3629 == proto.wireTypes.varint then
			local v3630

			v3630, n194 = proto.readVarInt(p291, n194)
		elseif v3629 == proto.wireTypes.lengthDelimited then
			if v3628 == 1 then
				local v3631

				v3631, n194 = proto.readBuffer(p291, n194)
				v3626.item_id = buffer.tostring(v3631)
			elseif v3628 == 2 then
				local v3632

				v3632, n194 = proto.readBuffer(p291, n194)
				v3626.item_type = buffer.tostring(v3632)
			else
				local v3633, v3634 = proto.readVarInt(p291, n194)

				n194 = v3634 + v3633
			end
		elseif v3629 == proto.wireTypes.i32 then
			local v3635

			v3635, n194 = proto.readFixed32(p291, n194)
		elseif v3629 == proto.wireTypes.i64 then
			local v3636

			v3636, n194 = proto.readFixed64(p291, n194)
		else
			error("Unsupported wire type: " .. v3629)
		end
	end

	return v3626
end
function t490.jsonEncode(p292) -- line: 20605
	local t492 = {}

	if p292.item_id ~= nil and p292.item_id ~= "" then
		t492.itemId = p292.item_id
	end

	if p292.item_type ~= nil and p292.item_type ~= "" then
		t492.itemType = p292.item_type
	end

	return t492
end
function t490.jsonDecode(t493: {[any]: any}) -- line: 20619
	-- upvalues: t490 (copy)
	local v3640 = t490.new()

	if t493.item_id ~= nil then
		v3640.item_id = t493.item_id
	end

	if t493.itemId ~= nil then
		v3640.item_id = t493.itemId
	end

	if t493.item_type ~= nil then
		v3640.item_type = t493.item_type
	end

	if t493.itemType ~= nil then
		v3640.item_type = t493.itemType
	end

	return v3640
end

t490.descriptor = {
	name = "CatalogItemListInputData_CatalogItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.CatalogItem"
}
t1.CatalogItemListInputData_CatalogItem = t490
typeRegistry.default:register(t1.CatalogItemListInputData_CatalogItem)

local t494 = {}

t494.__index = t494

function t494.new(t495: {[any]: any}?) -- line: 20657
	-- upvalues: t494 (copy)
	return (setmetatable({
		universe_id = if t495 ~= nil and t495.universe_id ~= nil then t495.universe_id else ""
	}, t494))
end
function t494.encode(p293) -- line: 20665
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n195 = 0

	if p293.universe_id ~= nil and p293.universe_id ~= "" then
		local v3645, v3646 = proto.writeTag(buf, n195, 1, proto.wireTypes.lengthDelimited)

		buf, n195 = proto.writeString(v3645, v3646, p293.universe_id)
	end

	local buf107 = buffer.create(n195)

	buffer.copy(buf107, 0, buf, 0, n195)

	return buf107
end
function t494.decode(p294: buffer) -- line: 20679
	-- upvalues: t494 (copy), proto (copy)
	local v3649 = t494.new()
	local n196 = 0

	while n196 < buffer.len(p294) do
		local v3651, v3652

		v3651, v3652, n196 = proto.readTag(p294, n196)

		if v3652 == proto.wireTypes.varint then
			local v3653

			v3653, n196 = proto.readVarInt(p294, n196)
		elseif v3652 == proto.wireTypes.lengthDelimited then
			if v3651 == 1 then
				local v3654

				v3654, n196 = proto.readBuffer(p294, n196)
				v3649.universe_id = buffer.tostring(v3654)
			else
				local v3655, v3656 = proto.readVarInt(p294, n196)

				n196 = v3656 + v3655
			end
		elseif v3652 == proto.wireTypes.i32 then
			local v3657

			v3657, n196 = proto.readFixed32(p294, n196)
		elseif v3652 == proto.wireTypes.i64 then
			local v3658

			v3658, n196 = proto.readFixed64(p294, n196)
		else
			error("Unsupported wire type: " .. v3652)
		end
	end

	return v3649
end
function t494.jsonEncode(p295) -- line: 20722
	local t496 = {}

	if p295.universe_id ~= nil and p295.universe_id ~= "" then
		t496.universeId = p295.universe_id
	end

	return t496
end
function t494.jsonDecode(t497: {[any]: any}) -- line: 20732
	-- upvalues: t494 (copy)
	local v3662 = t494.new()

	if t497.universe_id ~= nil then
		v3662.universe_id = t497.universe_id
	end

	if t497.universeId ~= nil then
		v3662.universe_id = t497.universeId
	end

	return v3662
end

t494.descriptor = {
	name = "ExperienceGuidelinesDialogInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceGuidelinesDialogInputData"
}
t1.ExperienceGuidelinesDialogInputData = t494
typeRegistry.default:register(t1.ExperienceGuidelinesDialogInputData)

local t498 = {}

t498.__index = t498

function t498.new(t499: {[any]: any}?) -- line: 20762
	-- upvalues: t498 (copy)
	return (setmetatable({
		title = if t499 ~= nil and t499.title ~= nil then t499.title else "",
		subtitle = if t499 ~= nil and t499.subtitle ~= nil then t499.subtitle else "",
		moment_items = if t499 ~= nil and t499.moment_items ~= nil then t499.moment_items else {}
	}, t498))
end
function t498.encode(p296) -- line: 20770
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n197 = 0

	if p296.title ~= nil and p296.title ~= "" then
		local v3667, v3668 = proto.writeTag(buf, n197, 1, proto.wireTypes.lengthDelimited)

		buf, n197 = proto.writeString(v3667, v3668, p296.title)
	end

	if p296.subtitle ~= nil and p296.subtitle ~= "" then
		local v3669, v3670 = proto.writeTag(buf, n197, 2, proto.wireTypes.lengthDelimited)

		buf, n197 = proto.writeString(v3669, v3670, p296.subtitle)
	end

	if p296.moment_items ~= nil and #p296.moment_items > 0 then
		for _, v3672 in p296.moment_items do
			local v3673 = v3672:encode()
			local v3674, v3675 = proto.writeTag(buf, n197, 3, proto.wireTypes.lengthDelimited)

			buf, n197 = proto.writeBuffer(v3674, v3675, v3673, buffer.len(v3673))
		end
	end

	local buf108 = buffer.create(n197)

	buffer.copy(buf108, 0, buf, 0, n197)

	return buf108
end
function t498.decode(p297: buffer) -- line: 20797
	-- upvalues: t498 (copy), proto (copy), t1 (copy)
	local v3678 = t498.new()
	local n198 = 0

	while n198 < buffer.len(p297) do
		local v3680, v3681

		v3680, v3681, n198 = proto.readTag(p297, n198)

		if v3681 == proto.wireTypes.varint then
			local v3682

			v3682, n198 = proto.readVarInt(p297, n198)
		elseif v3681 == proto.wireTypes.lengthDelimited then
			if v3680 == 1 then
				local v3683

				v3683, n198 = proto.readBuffer(p297, n198)
				v3678.title = buffer.tostring(v3683)
			elseif v3680 == 2 then
				local v3684

				v3684, n198 = proto.readBuffer(p297, n198)
				v3678.subtitle = buffer.tostring(v3684)
			elseif v3680 == 3 then
				local v3685

				v3685, n198 = proto.readBuffer(p297, n198)
				table.insert(v3678.moment_items, t1.MomentsCarouselInputData_MomentItem.decode(v3685))
			else
				local v3686, v3687 = proto.readVarInt(p297, n198)

				n198 = v3687 + v3686
			end
		elseif v3681 == proto.wireTypes.i32 then
			local v3688

			v3688, n198 = proto.readFixed32(p297, n198)
		elseif v3681 == proto.wireTypes.i64 then
			local v3689

			v3689, n198 = proto.readFixed64(p297, n198)
		else
			error("Unsupported wire type: " .. v3681)
		end
	end

	return v3678
end
function t498.jsonEncode(p298) -- line: 20850
	local t500 = {}

	if p298.title ~= nil and p298.title ~= "" then
		t500.title = p298.title
	end

	if p298.subtitle ~= nil and p298.subtitle ~= "" then
		t500.subtitle = p298.subtitle
	end

	if p298.moment_items ~= nil and #p298.moment_items > 0 then
		local t501 = {}

		for _, v3694 in p298.moment_items do
			table.insert(t501, v3694:jsonEncode())
		end

		t500.momentItems = t501
	end

	return t500
end
function t498.jsonDecode(t502: {[any]: any}) -- line: 20872
	-- upvalues: t498 (copy), t1 (copy)
	local v3696 = t498.new()

	if t502.title ~= nil then
		v3696.title = t502.title
	end

	if t502.subtitle ~= nil then
		v3696.subtitle = t502.subtitle
	end

	if t502.moment_items ~= nil then
		local t503 = {}

		for _, v3699 in t502.moment_items do
			table.insert(t503, t1.MomentsCarouselInputData_MomentItem.jsonDecode(v3699))
		end

		v3696.moment_items = t503
	end

	if t502.momentItems ~= nil then
		local t504 = {}

		for _, v3702 in t502.momentItems do
			table.insert(t504, t1.MomentsCarouselInputData_MomentItem.jsonDecode(v3702))
		end

		v3696.moment_items = t504
	end

	return v3696
end

t498.descriptor = {
	name = "MomentsCarouselInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.MomentsCarouselInputData"
}
t1.MomentsCarouselInputData = t498
typeRegistry.default:register(t1.MomentsCarouselInputData)

local t505 = {}

t505.__index = t505

function t505.new(t506: {[any]: any}?) -- line: 20918
	-- upvalues: t505 (copy)
	return (setmetatable({
		moment_id = if t506 ~= nil and t506.moment_id ~= nil then t506.moment_id else "",
		video_asset_id = if t506 ~= nil and t506.video_asset_id ~= nil then t506.video_asset_id else "",
		target_universe_id = if t506 ~= nil and t506.target_universe_id ~= nil then t506.target_universe_id else "",
		target_place_id = if t506 ~= nil and t506.target_place_id ~= nil then t506.target_place_id else "",
		feed_item_id = if t506 ~= nil and t506.feed_item_id ~= nil then t506.feed_item_id else "",
		capture_universe_id = if t506 ~= nil and t506.capture_universe_id ~= nil then t506.capture_universe_id else ""
	}, t505))
end
function t505.encode(p299) -- line: 20933
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n199 = 0

	if p299.moment_id ~= nil and p299.moment_id ~= "" then
		local v3707, v3708 = proto.writeTag(buf, n199, 1, proto.wireTypes.lengthDelimited)

		buf, n199 = proto.writeString(v3707, v3708, p299.moment_id)
	end

	if p299.video_asset_id ~= nil and p299.video_asset_id ~= "" then
		local v3709, v3710 = proto.writeTag(buf, n199, 2, proto.wireTypes.lengthDelimited)

		buf, n199 = proto.writeString(v3709, v3710, p299.video_asset_id)
	end

	if p299.target_universe_id ~= nil and p299.target_universe_id ~= "" then
		local v3711, v3712 = proto.writeTag(buf, n199, 3, proto.wireTypes.lengthDelimited)

		buf, n199 = proto.writeString(v3711, v3712, p299.target_universe_id)
	end

	if p299.target_place_id ~= nil and p299.target_place_id ~= "" then
		local v3713, v3714 = proto.writeTag(buf, n199, 4, proto.wireTypes.lengthDelimited)

		buf, n199 = proto.writeString(v3713, v3714, p299.target_place_id)
	end

	if p299.feed_item_id ~= nil and p299.feed_item_id ~= "" then
		local v3715, v3716 = proto.writeTag(buf, n199, 5, proto.wireTypes.lengthDelimited)

		buf, n199 = proto.writeString(v3715, v3716, p299.feed_item_id)
	end

	if p299.capture_universe_id ~= nil and p299.capture_universe_id ~= "" then
		local v3717, v3718 = proto.writeTag(buf, n199, 6, proto.wireTypes.lengthDelimited)

		buf, n199 = proto.writeString(v3717, v3718, p299.capture_universe_id)
	end

	local buf109 = buffer.create(n199)

	buffer.copy(buf109, 0, buf, 0, n199)

	return buf109
end
function t505.decode(p300: buffer) -- line: 20972
	-- upvalues: t505 (copy), proto (copy)
	local v3721 = t505.new()
	local n200 = 0

	while n200 < buffer.len(p300) do
		local v3723, v3724

		v3723, v3724, n200 = proto.readTag(p300, n200)

		if v3724 == proto.wireTypes.varint then
			local v3725

			v3725, n200 = proto.readVarInt(p300, n200)
		elseif v3724 == proto.wireTypes.lengthDelimited then
			if v3723 == 1 then
				local v3726

				v3726, n200 = proto.readBuffer(p300, n200)
				v3721.moment_id = buffer.tostring(v3726)
			elseif v3723 == 2 then
				local v3727

				v3727, n200 = proto.readBuffer(p300, n200)
				v3721.video_asset_id = buffer.tostring(v3727)
			elseif v3723 == 3 then
				local v3728

				v3728, n200 = proto.readBuffer(p300, n200)
				v3721.target_universe_id = buffer.tostring(v3728)
			elseif v3723 == 4 then
				local v3729

				v3729, n200 = proto.readBuffer(p300, n200)
				v3721.target_place_id = buffer.tostring(v3729)
			elseif v3723 == 5 then
				local v3730

				v3730, n200 = proto.readBuffer(p300, n200)
				v3721.feed_item_id = buffer.tostring(v3730)
			elseif v3723 == 6 then
				local v3731

				v3731, n200 = proto.readBuffer(p300, n200)
				v3721.capture_universe_id = buffer.tostring(v3731)
			else
				local v3732, v3733 = proto.readVarInt(p300, n200)

				n200 = v3733 + v3732
			end
		elseif v3724 == proto.wireTypes.i32 then
			local v3734

			v3734, n200 = proto.readFixed32(p300, n200)
		elseif v3724 == proto.wireTypes.i64 then
			local v3735

			v3735, n200 = proto.readFixed64(p300, n200)
		else
			error("Unsupported wire type: " .. v3724)
		end
	end

	return v3721
end
function t505.jsonEncode(p301) -- line: 21040
	local t507 = {}

	if p301.moment_id ~= nil and p301.moment_id ~= "" then
		t507.momentId = p301.moment_id
	end

	if p301.video_asset_id ~= nil and p301.video_asset_id ~= "" then
		t507.videoAssetId = p301.video_asset_id
	end

	if p301.target_universe_id ~= nil and p301.target_universe_id ~= "" then
		t507.targetUniverseId = p301.target_universe_id
	end

	if p301.target_place_id ~= nil and p301.target_place_id ~= "" then
		t507.targetPlaceId = p301.target_place_id
	end

	if p301.feed_item_id ~= nil and p301.feed_item_id ~= "" then
		t507.feedItemId = p301.feed_item_id
	end

	if p301.capture_universe_id ~= nil and p301.capture_universe_id ~= "" then
		t507.captureUniverseId = p301.capture_universe_id
	end

	return t507
end
function t505.jsonDecode(t508: {[any]: any}) -- line: 21070
	-- upvalues: t505 (copy)
	local v3739 = t505.new()

	if t508.moment_id ~= nil then
		v3739.moment_id = t508.moment_id
	end

	if t508.momentId ~= nil then
		v3739.moment_id = t508.momentId
	end

	if t508.video_asset_id ~= nil then
		v3739.video_asset_id = t508.video_asset_id
	end

	if t508.videoAssetId ~= nil then
		v3739.video_asset_id = t508.videoAssetId
	end

	if t508.target_universe_id ~= nil then
		v3739.target_universe_id = t508.target_universe_id
	end

	if t508.targetUniverseId ~= nil then
		v3739.target_universe_id = t508.targetUniverseId
	end

	if t508.target_place_id ~= nil then
		v3739.target_place_id = t508.target_place_id
	end

	if t508.targetPlaceId ~= nil then
		v3739.target_place_id = t508.targetPlaceId
	end

	if t508.feed_item_id ~= nil then
		v3739.feed_item_id = t508.feed_item_id
	end

	if t508.feedItemId ~= nil then
		v3739.feed_item_id = t508.feedItemId
	end

	if t508.capture_universe_id ~= nil then
		v3739.capture_universe_id = t508.capture_universe_id
	end

	if t508.captureUniverseId ~= nil then
		v3739.capture_universe_id = t508.captureUniverseId
	end

	return v3739
end

t505.descriptor = {
	name = "MomentsCarouselInputData_MomentItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.MomentItem"
}
t1.MomentsCarouselInputData_MomentItem = t505
typeRegistry.default:register(t1.MomentsCarouselInputData_MomentItem)

local t509 = {}

t509.__index = t509

function t509.new(t510: {[any]: any}?) -- line: 21140
	-- upvalues: t509 (copy)
	return (setmetatable({
		title = if t510 ~= nil and t510.title ~= nil then t510.title else "",
		subtitle = if t510 ~= nil and t510.subtitle ~= nil then t510.subtitle else ""
	}, t509))
end
function t509.encode(p302) -- line: 21147
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n201 = 0

	if p302.title ~= nil and p302.title ~= "" then
		local v3744, v3745 = proto.writeTag(buf, n201, 1, proto.wireTypes.lengthDelimited)

		buf, n201 = proto.writeString(v3744, v3745, p302.title)
	end

	if p302.subtitle ~= nil and p302.subtitle ~= "" then
		local v3746, v3747 = proto.writeTag(buf, n201, 2, proto.wireTypes.lengthDelimited)

		buf, n201 = proto.writeString(v3746, v3747, p302.subtitle)
	end

	local buf110 = buffer.create(n201)

	buffer.copy(buf110, 0, buf, 0, n201)

	return buf110
end
function t509.decode(p303: buffer) -- line: 21166
	-- upvalues: t509 (copy), proto (copy)
	local v3750 = t509.new()
	local n202 = 0

	while n202 < buffer.len(p303) do
		local v3752, v3753

		v3752, v3753, n202 = proto.readTag(p303, n202)

		if v3753 == proto.wireTypes.varint then
			local v3754

			v3754, n202 = proto.readVarInt(p303, n202)
		elseif v3753 == proto.wireTypes.lengthDelimited then
			if v3752 == 1 then
				local v3755

				v3755, n202 = proto.readBuffer(p303, n202)
				v3750.title = buffer.tostring(v3755)
			elseif v3752 == 2 then
				local v3756

				v3756, n202 = proto.readBuffer(p303, n202)
				v3750.subtitle = buffer.tostring(v3756)
			else
				local v3757, v3758 = proto.readVarInt(p303, n202)

				n202 = v3758 + v3757
			end
		elseif v3753 == proto.wireTypes.i32 then
			local v3759

			v3759, n202 = proto.readFixed32(p303, n202)
		elseif v3753 == proto.wireTypes.i64 then
			local v3760

			v3760, n202 = proto.readFixed64(p303, n202)
		else
			error("Unsupported wire type: " .. v3753)
		end
	end

	return v3750
end
function t509.jsonEncode(p304) -- line: 21214
	local t511 = {}

	if p304.title ~= nil and p304.title ~= "" then
		t511.title = p304.title
	end

	if p304.subtitle ~= nil and p304.subtitle ~= "" then
		t511.subtitle = p304.subtitle
	end

	return t511
end
function t509.jsonDecode(t512: {[any]: any}) -- line: 21228
	-- upvalues: t509 (copy)
	local v3764 = t509.new()

	if t512.title ~= nil then
		v3764.title = t512.title
	end

	if t512.subtitle ~= nil then
		v3764.subtitle = t512.subtitle
	end

	return v3764
end

t509.descriptor = {
	name = "AttributionRowInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.AttributionRowInputData"
}
t1.AttributionRowInputData = t509
typeRegistry.default:register(t1.AttributionRowInputData)

local t513 = {}

t513.__index = t513

function t513.new(t514: {[any]: any}?) -- line: 21256
	-- upvalues: t513 (copy)
	return (setmetatable({
		image_asset_id = if t514 ~= nil and t514.image_asset_id ~= nil then t514.image_asset_id else ""
	}, t513))
end
function t513.encode(p305) -- line: 21262
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n203 = 0

	if p305.image_asset_id ~= nil and p305.image_asset_id ~= "" then
		local v3769, v3770 = proto.writeTag(buf, n203, 1, proto.wireTypes.lengthDelimited)

		buf, n203 = proto.writeString(v3769, v3770, p305.image_asset_id)
	end

	local buf111 = buffer.create(n203)

	buffer.copy(buf111, 0, buf, 0, n203)

	return buf111
end
function t513.decode(p306: buffer) -- line: 21276
	-- upvalues: t513 (copy), proto (copy)
	local v3773 = t513.new()
	local n204 = 0

	while n204 < buffer.len(p306) do
		local v3775, v3776

		v3775, v3776, n204 = proto.readTag(p306, n204)

		if v3776 == proto.wireTypes.varint then
			local v3777

			v3777, n204 = proto.readVarInt(p306, n204)
		elseif v3776 == proto.wireTypes.lengthDelimited then
			if v3775 == 1 then
				local v3778

				v3778, n204 = proto.readBuffer(p306, n204)
				v3773.image_asset_id = buffer.tostring(v3778)
			else
				local v3779, v3780 = proto.readVarInt(p306, n204)

				n204 = v3780 + v3779
			end
		elseif v3776 == proto.wireTypes.i32 then
			local v3781

			v3781, n204 = proto.readFixed32(p306, n204)
		elseif v3776 == proto.wireTypes.i64 then
			local v3782

			v3782, n204 = proto.readFixed64(p306, n204)
		else
			error("Unsupported wire type: " .. v3776)
		end
	end

	return v3773
end
function t513.jsonEncode(p307) -- line: 21319
	local t515 = {}

	if p307.image_asset_id ~= nil and p307.image_asset_id ~= "" then
		t515.imageAssetId = p307.image_asset_id
	end

	return t515
end
function t513.jsonDecode(t516: {[any]: any}) -- line: 21329
	-- upvalues: t513 (copy)
	local v3786 = t513.new()

	if t516.image_asset_id ~= nil then
		v3786.image_asset_id = t516.image_asset_id
	end

	if t516.imageAssetId ~= nil then
		v3786.image_asset_id = t516.imageAssetId
	end

	return v3786
end

t513.descriptor = {
	name = "ImageInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ImageInputData"
}
t1.ImageInputData = t513
typeRegistry.default:register(t1.ImageInputData)

local t517 = {}

t517.__index = t517

function t517.new(t518: {[any]: any}?) -- line: 21357
	-- upvalues: t517 (copy)
	return (setmetatable({
		text = if t518 ~= nil and t518.text ~= nil then t518.text else "",
		is_rendered_text = t518 ~= nil and (t518.is_rendered_text ~= nil and t518.is_rendered_text)
	}, t517))
end
function t517.encode(p308) -- line: 21364
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n205 = 0

	if p308.text ~= nil and p308.text ~= "" then
		local v3791, v3792 = proto.writeTag(buf, n205, 1, proto.wireTypes.lengthDelimited)

		buf, n205 = proto.writeString(v3791, v3792, p308.text)
	end

	if p308.is_rendered_text then
		local v3793, v3794 = proto.writeTag(buf, n205, 2, proto.wireTypes.varint)

		buf, n205 = proto.writeVarInt(v3793, v3794, not p308.is_rendered_text and 0 or 1)
	end

	local buf112 = buffer.create(n205)

	buffer.copy(buf112, 0, buf, 0, n205)

	return buf112
end
function t517.decode(p309: buffer) -- line: 21383
	-- upvalues: t517 (copy), proto (copy)
	local v3797 = t517.new()
	local n206 = 0

	while n206 < buffer.len(p309) do
		local v3799, v3800

		v3799, v3800, n206 = proto.readTag(p309, n206)

		if v3800 == proto.wireTypes.varint then
			if v3799 == 2 then
				local v3801

				v3801, n206 = proto.readVarInt(p309, n206)
				v3797.is_rendered_text = v3801 ~= 0
			else
				local v3802

				v3802, n206 = proto.readVarInt(p309, n206)
			end
		elseif v3800 == proto.wireTypes.lengthDelimited then
			if v3799 == 1 then
				local v3803

				v3803, n206 = proto.readBuffer(p309, n206)
				v3797.text = buffer.tostring(v3803)
			else
				local v3804, v3805 = proto.readVarInt(p309, n206)

				n206 = v3805 + v3804
			end
		elseif v3800 == proto.wireTypes.i32 then
			local v3806

			v3806, n206 = proto.readFixed32(p309, n206)
		elseif v3800 == proto.wireTypes.i64 then
			local v3807

			v3807, n206 = proto.readFixed64(p309, n206)
		else
			error("Unsupported wire type: " .. v3800)
		end
	end

	return v3797
end
function t517.jsonEncode(p310) -- line: 21431
	local t519 = {}

	if p310.text ~= nil and p310.text ~= "" then
		t519.text = p310.text
	end

	if p310.is_rendered_text then
		t519.isRenderedText = p310.is_rendered_text
	end

	return t519
end
function t517.jsonDecode(t520: {[any]: any}) -- line: 21445
	-- upvalues: t517 (copy)
	local v3811 = t517.new()

	if t520.text ~= nil then
		v3811.text = t520.text
	end

	if t520.is_rendered_text ~= nil then
		v3811.is_rendered_text = t520.is_rendered_text
	end

	if t520.isRenderedText ~= nil then
		v3811.is_rendered_text = t520.isRenderedText
	end

	return v3811
end

t517.descriptor = {
	name = "TextInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.TextInputData"
}
t1.TextInputData = t517
typeRegistry.default:register(t1.TextInputData)

local t521 = {}

t521.__index = t521

function t521.new(t522: {[any]: any}?) -- line: 21477
	-- upvalues: t521 (copy)
	return (setmetatable({
		entry_map = if t522 ~= nil and t522.entry_map ~= nil then t522.entry_map else {},
		entry_order = if t522 ~= nil and t522.entry_order ~= nil then t522.entry_order else {},
		entry_order_map = if t522 ~= nil and t522.entry_order_map ~= nil then t522.entry_order_map else {},
		content_pools = if t522 ~= nil and t522.content_pools ~= nil then t522.content_pools else {}
	}, t521))
end
function t521.encode(p311) -- line: 21486
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n207 = 0

	if p311.entry_map ~= nil and next(p311.entry_map) ~= nil then
		for v3816, v3817 in p311.entry_map do
			local buf113 = buffer.create(0)
			local v3819, v3820 = proto.writeTag(buf113, 0, 1, proto.wireTypes.lengthDelimited)
			local v3821, v3822 = proto.writeString(v3819, v3820, v3816)
			local v3823 = v3817:encode()
			local v3824, v3825 = proto.writeTag(v3821, v3822, 2, proto.wireTypes.lengthDelimited)
			local v3826, v3827 = proto.writeBuffer(v3824, v3825, v3823, buffer.len(v3823))
			local v3828, v3829 = proto.writeTag(buf, n207, 1, proto.wireTypes.lengthDelimited)

			buf, n207 = proto.writeBuffer(v3828, v3829, v3826, v3827)
		end
	end

	if p311.entry_order ~= nil and #p311.entry_order > 0 then
		for _, v3831 in p311.entry_order do
			local v3832, v3833 = proto.writeTag(buf, n207, 2, proto.wireTypes.lengthDelimited)

			buf, n207 = proto.writeString(v3832, v3833, v3831)
		end
	end

	if p311.entry_order_map ~= nil and next(p311.entry_order_map) ~= nil then
		for v3834, v3835 in p311.entry_order_map do
			local buf114 = buffer.create(0)
			local v3837, v3838 = proto.writeTag(buf114, 0, 1, proto.wireTypes.lengthDelimited)
			local v3839, v3840 = proto.writeString(v3837, v3838, v3834)
			local v3841 = v3835:encode()
			local v3842, v3843 = proto.writeTag(v3839, v3840, 2, proto.wireTypes.lengthDelimited)
			local v3844, v3845 = proto.writeBuffer(v3842, v3843, v3841, buffer.len(v3841))
			local v3846, v3847 = proto.writeTag(buf, n207, 3, proto.wireTypes.lengthDelimited)

			buf, n207 = proto.writeBuffer(v3846, v3847, v3844, v3845)
		end
	end

	if p311.content_pools ~= nil and next(p311.content_pools) ~= nil then
		for v3848, v3849 in p311.content_pools do
			local buf115 = buffer.create(0)
			local v3851, v3852 = proto.writeTag(buf115, 0, 1, proto.wireTypes.lengthDelimited)
			local v3853, v3854 = proto.writeString(v3851, v3852, v3848)
			local v3855 = v3849:encode()
			local v3856, v3857 = proto.writeTag(v3853, v3854, 2, proto.wireTypes.lengthDelimited)
			local v3858, v3859 = proto.writeBuffer(v3856, v3857, v3855, buffer.len(v3855))
			local v3860, v3861 = proto.writeTag(buf, n207, 4, proto.wireTypes.lengthDelimited)

			buf, n207 = proto.writeBuffer(v3860, v3861, v3858, v3859)
		end
	end

	local buf116 = buffer.create(n207)

	buffer.copy(buf116, 0, buf, 0, n207)

	return buf116
end
function t521.decode(p312: buffer) -- line: 21544
	-- upvalues: t521 (copy), proto (copy), t1 (copy)
	local v3864 = t521.new()
	local n208 = 0

	while n208 < buffer.len(p312) do
		local v3866, v3867

		v3866, v3867, n208 = proto.readTag(p312, n208)

		if v3867 == proto.wireTypes.varint then
			local v3868

			v3868, n208 = proto.readVarInt(p312, n208)
		elseif v3867 == proto.wireTypes.lengthDelimited then
			if v3866 == 1 then
				local v3869

				v3869, n208 = proto.readBuffer(p312, n208)

				local v3870 = t1.VerticalFeedInputData_EntryMapEntry.decode(v3869)
				local v3871 = t1.FeedEntry.new()

				v3864.entry_map[v3870.key or ""] = v3870.value or v3871
			elseif v3866 == 2 then
				local v3872

				v3872, n208 = proto.readBuffer(p312, n208)
				table.insert(v3864.entry_order, buffer.tostring(v3872))
			elseif v3866 == 3 then
				local v3873

				v3873, n208 = proto.readBuffer(p312, n208)

				local v3874 = t1.VerticalFeedInputData_EntryOrderMapEntry.decode(v3873)
				local v3875 = t1.EntryOrder.new()

				v3864.entry_order_map[v3874.key or ""] = v3874.value or v3875
			elseif v3866 == 4 then
				local v3876

				v3876, n208 = proto.readBuffer(p312, n208)

				local v3877 = t1.VerticalFeedInputData_ContentPoolsEntry.decode(v3876)
				local v3878 = t1.ContentPool.new()

				v3864.content_pools[v3877.key or ""] = v3877.value or v3878
			else
				local v3879, v3880 = proto.readVarInt(p312, n208)

				n208 = v3880 + v3879
			end
		elseif v3867 == proto.wireTypes.i32 then
			local v3881

			v3881, n208 = proto.readFixed32(p312, n208)
		elseif v3867 == proto.wireTypes.i64 then
			local v3882

			v3882, n208 = proto.readFixed64(p312, n208)
		else
			error("Unsupported wire type: " .. v3867)
		end
	end

	return v3864
end
function t521.jsonEncode(p313) -- line: 21623
	local t523 = {}

	if p313.entry_map ~= nil and next(p313.entry_map) ~= nil then
		local t524 = {}

		for v3886, v3887 in p313.entry_map do
			t524[v3886] = v3887:jsonEncode()
		end

		t523.entryMap = t524
	end

	if p313.entry_order ~= nil and #p313.entry_order > 0 then
		local t525 = {}

		for _, v3890 in p313.entry_order do
			table.insert(t525, v3890)
		end

		t523.entryOrder = t525
	end

	if p313.entry_order_map ~= nil and next(p313.entry_order_map) ~= nil then
		local t526 = {}

		for v3892, v3893 in p313.entry_order_map do
			t526[v3892] = v3893:jsonEncode()
		end

		t523.entryOrderMap = t526
	end

	if p313.content_pools ~= nil and next(p313.content_pools) ~= nil then
		local t527 = {}

		for v3895, v3896 in p313.content_pools do
			t527[v3895] = v3896:jsonEncode()
		end

		t523.contentPools = t527
	end

	return t523
end
function t521.jsonDecode(t528: {[any]: any}) -- line: 21661
	-- upvalues: t521 (copy), t1 (copy)
	local v3898 = t521.new()

	if t528.entry_map ~= nil then
		local t529 = {}

		for v3900, v3901 in t528.entry_map do
			t529[v3900] = t1.FeedEntry.jsonDecode(v3901)
		end

		v3898.entry_map = t529
	end

	if t528.entryMap ~= nil then
		local t530 = {}

		for v3903, v3904 in t528.entryMap do
			t530[v3903] = t1.FeedEntry.jsonDecode(v3904)
		end

		v3898.entry_map = t530
	end

	if t528.entry_order ~= nil then
		local t531 = {}

		for _, v3907 in t528.entry_order do
			table.insert(t531, v3907)
		end

		v3898.entry_order = t531
	end

	if t528.entryOrder ~= nil then
		local t532 = {}

		for _, v3910 in t528.entryOrder do
			table.insert(t532, v3910)
		end

		v3898.entry_order = t532
	end

	if t528.entry_order_map ~= nil then
		local t533 = {}

		for v3912, v3913 in t528.entry_order_map do
			t533[v3912] = t1.EntryOrder.jsonDecode(v3913)
		end

		v3898.entry_order_map = t533
	end

	if t528.entryOrderMap ~= nil then
		local t534 = {}

		for v3915, v3916 in t528.entryOrderMap do
			t534[v3915] = t1.EntryOrder.jsonDecode(v3916)
		end

		v3898.entry_order_map = t534
	end

	if t528.content_pools ~= nil then
		local t535 = {}

		for v3918, v3919 in t528.content_pools do
			t535[v3918] = t1.ContentPool.jsonDecode(v3919)
		end

		v3898.content_pools = t535
	end

	if t528.contentPools ~= nil then
		local t536 = {}

		for v3921, v3922 in t528.contentPools do
			t536[v3921] = t1.ContentPool.jsonDecode(v3922)
		end

		v3898.content_pools = t536
	end

	return v3898
end

t521.descriptor = {
	name = "VerticalFeedInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.VerticalFeedInputData"
}
t1.VerticalFeedInputData = t521
typeRegistry.default:register(t1.VerticalFeedInputData)

local t537 = {}

t537.__index = t537

function t537.new(t538: {[any]: any}?) -- line: 21753
	-- upvalues: t537 (copy)
	return (setmetatable({
		key = if t538 ~= nil and t538.key ~= nil then t538.key else "",
		value = if t538 ~= nil and t538.value ~= nil then t538.value else nil
	}, t537))
end
function t537.encode(p314) -- line: 21762
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n209 = 0

	if p314.key ~= nil and p314.key ~= "" then
		local v3927, v3928 = proto.writeTag(buf, n209, 1, proto.wireTypes.lengthDelimited)

		buf, n209 = proto.writeString(v3927, v3928, p314.key)
	end

	if p314.value ~= nil then
		local v3929 = p314.value:encode()
		local v3930, v3931 = proto.writeTag(buf, n209, 2, proto.wireTypes.lengthDelimited)

		buf, n209 = proto.writeBuffer(v3930, v3931, v3929, buffer.len(v3929))
	end

	local buf117 = buffer.create(n209)

	buffer.copy(buf117, 0, buf, 0, n209)

	return buf117
end
function t537.decode(p315: buffer) -- line: 21782
	-- upvalues: t537 (copy), proto (copy), t1 (copy)
	local v3934 = t537.new()
	local n210 = 0

	while n210 < buffer.len(p315) do
		local v3936, v3937

		v3936, v3937, n210 = proto.readTag(p315, n210)

		if v3937 == proto.wireTypes.varint then
			local v3938

			v3938, n210 = proto.readVarInt(p315, n210)
		elseif v3937 == proto.wireTypes.lengthDelimited then
			if v3936 == 1 then
				local v3939

				v3939, n210 = proto.readBuffer(p315, n210)
				v3934.key = buffer.tostring(v3939)
			elseif v3936 == 2 then
				local v3940

				v3940, n210 = proto.readBuffer(p315, n210)
				v3934.value = t1.FeedEntry.decode(v3940)
			else
				local v3941, v3942 = proto.readVarInt(p315, n210)

				n210 = v3942 + v3941
			end
		elseif v3937 == proto.wireTypes.i32 then
			local v3943

			v3943, n210 = proto.readFixed32(p315, n210)
		elseif v3937 == proto.wireTypes.i64 then
			local v3944

			v3944, n210 = proto.readFixed64(p315, n210)
		else
			error("Unsupported wire type: " .. v3937)
		end
	end

	return v3934
end
function t537.jsonEncode(p316) -- line: 21830
	local t539 = {}

	if p316.key ~= nil and p316.key ~= "" then
		t539.key = p316.key
	end

	if p316.value ~= nil then
		t539.value = p316.value:jsonEncode()
	end

	return t539
end
function t537.jsonDecode(t540: {[any]: any}) -- line: 21844
	-- upvalues: t537 (copy), t1 (copy)
	local v3948 = t537.new()

	if t540.key ~= nil then
		v3948.key = t540.key
	end

	if t540.value ~= nil then
		v3948.value = t1.FeedEntry.jsonDecode(t540.value)
	end

	return v3948
end

t537.descriptor = {
	name = "VerticalFeedInputData_EntryMapEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryMapEntry"
}
t1.VerticalFeedInputData_EntryMapEntry = t537
typeRegistry.default:register(t1.VerticalFeedInputData_EntryMapEntry)

local t541 = {}

t541.__index = t541

function t541.new(t542: {[any]: any}?) -- line: 21874
	-- upvalues: t541 (copy)
	return (setmetatable({
		key = if t542 ~= nil and t542.key ~= nil then t542.key else "",
		value = if t542 ~= nil and t542.value ~= nil then t542.value else nil
	}, t541))
end
function t541.encode(p317) -- line: 21883
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n211 = 0

	if p317.key ~= nil and p317.key ~= "" then
		local v3953, v3954 = proto.writeTag(buf, n211, 1, proto.wireTypes.lengthDelimited)

		buf, n211 = proto.writeString(v3953, v3954, p317.key)
	end

	if p317.value ~= nil then
		local v3955 = p317.value:encode()
		local v3956, v3957 = proto.writeTag(buf, n211, 2, proto.wireTypes.lengthDelimited)

		buf, n211 = proto.writeBuffer(v3956, v3957, v3955, buffer.len(v3955))
	end

	local buf118 = buffer.create(n211)

	buffer.copy(buf118, 0, buf, 0, n211)

	return buf118
end
function t541.decode(p318: buffer) -- line: 21905
	-- upvalues: t541 (copy), proto (copy), t1 (copy)
	local v3960 = t541.new()
	local n212 = 0

	while n212 < buffer.len(p318) do
		local v3962, v3963

		v3962, v3963, n212 = proto.readTag(p318, n212)

		if v3963 == proto.wireTypes.varint then
			local v3964

			v3964, n212 = proto.readVarInt(p318, n212)
		elseif v3963 == proto.wireTypes.lengthDelimited then
			if v3962 == 1 then
				local v3965

				v3965, n212 = proto.readBuffer(p318, n212)
				v3960.key = buffer.tostring(v3965)
			elseif v3962 == 2 then
				local v3966

				v3966, n212 = proto.readBuffer(p318, n212)
				v3960.value = t1.EntryOrder.decode(v3966)
			else
				local v3967, v3968 = proto.readVarInt(p318, n212)

				n212 = v3968 + v3967
			end
		elseif v3963 == proto.wireTypes.i32 then
			local v3969

			v3969, n212 = proto.readFixed32(p318, n212)
		elseif v3963 == proto.wireTypes.i64 then
			local v3970

			v3970, n212 = proto.readFixed64(p318, n212)
		else
			error("Unsupported wire type: " .. v3963)
		end
	end

	return v3960
end
function t541.jsonEncode(p319) -- line: 21955
	local t543 = {}

	if p319.key ~= nil and p319.key ~= "" then
		t543.key = p319.key
	end

	if p319.value ~= nil then
		t543.value = p319.value:jsonEncode()
	end

	return t543
end
function t541.jsonDecode(t544: {[any]: any}) -- line: 21971
	-- upvalues: t541 (copy), t1 (copy)
	local v3974 = t541.new()

	if t544.key ~= nil then
		v3974.key = t544.key
	end

	if t544.value ~= nil then
		v3974.value = t1.EntryOrder.jsonDecode(t544.value)
	end

	return v3974
end

t541.descriptor = {
	name = "VerticalFeedInputData_EntryOrderMapEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryOrderMapEntry"
}
t1.VerticalFeedInputData_EntryOrderMapEntry = t541
typeRegistry.default:register(t1.VerticalFeedInputData_EntryOrderMapEntry)

local t545 = {}

t545.__index = t545

function t545.new(t546: {[any]: any}?) -- line: 22001
	-- upvalues: t545 (copy)
	return (setmetatable({
		key = if t546 ~= nil and t546.key ~= nil then t546.key else "",
		value = if t546 ~= nil and t546.value ~= nil then t546.value else nil
	}, t545))
end
function t545.encode(p320) -- line: 22010
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n213 = 0

	if p320.key ~= nil and p320.key ~= "" then
		local v3979, v3980 = proto.writeTag(buf, n213, 1, proto.wireTypes.lengthDelimited)

		buf, n213 = proto.writeString(v3979, v3980, p320.key)
	end

	if p320.value ~= nil then
		local v3981 = p320.value:encode()
		local v3982, v3983 = proto.writeTag(buf, n213, 2, proto.wireTypes.lengthDelimited)

		buf, n213 = proto.writeBuffer(v3982, v3983, v3981, buffer.len(v3981))
	end

	local buf119 = buffer.create(n213)

	buffer.copy(buf119, 0, buf, 0, n213)

	return buf119
end
function t545.decode(p321: buffer) -- line: 22030
	-- upvalues: t545 (copy), proto (copy), t1 (copy)
	local v3986 = t545.new()
	local n214 = 0

	while n214 < buffer.len(p321) do
		local v3988, v3989

		v3988, v3989, n214 = proto.readTag(p321, n214)

		if v3989 == proto.wireTypes.varint then
			local v3990

			v3990, n214 = proto.readVarInt(p321, n214)
		elseif v3989 == proto.wireTypes.lengthDelimited then
			if v3988 == 1 then
				local v3991

				v3991, n214 = proto.readBuffer(p321, n214)
				v3986.key = buffer.tostring(v3991)
			elseif v3988 == 2 then
				local v3992

				v3992, n214 = proto.readBuffer(p321, n214)
				v3986.value = t1.ContentPool.decode(v3992)
			else
				local v3993, v3994 = proto.readVarInt(p321, n214)

				n214 = v3994 + v3993
			end
		elseif v3989 == proto.wireTypes.i32 then
			local v3995

			v3995, n214 = proto.readFixed32(p321, n214)
		elseif v3989 == proto.wireTypes.i64 then
			local v3996

			v3996, n214 = proto.readFixed64(p321, n214)
		else
			error("Unsupported wire type: " .. v3989)
		end
	end

	return v3986
end
function t545.jsonEncode(p322) -- line: 22078
	local t547 = {}

	if p322.key ~= nil and p322.key ~= "" then
		t547.key = p322.key
	end

	if p322.value ~= nil then
		t547.value = p322.value:jsonEncode()
	end

	return t547
end
function t545.jsonDecode(t548: {[any]: any}) -- line: 22092
	-- upvalues: t545 (copy), t1 (copy)
	local v4000 = t545.new()

	if t548.key ~= nil then
		v4000.key = t548.key
	end

	if t548.value ~= nil then
		v4000.value = t1.ContentPool.jsonDecode(t548.value)
	end

	return v4000
end

t545.descriptor = {
	name = "VerticalFeedInputData_ContentPoolsEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.ContentPoolsEntry"
}
t1.VerticalFeedInputData_ContentPoolsEntry = t545
typeRegistry.default:register(t1.VerticalFeedInputData_ContentPoolsEntry)

local t549 = {}

t549.__index = t549

function t549.new(t550: {[any]: any}?) -- line: 22122
	-- upvalues: t549 (copy)
	return (setmetatable({
		foreground_header_entry = if t550 ~= nil and t550.foreground_header_entry ~= nil then t550.foreground_header_entry else nil,
		background_header_entry = if t550 ~= nil and t550.background_header_entry ~= nil then t550.background_header_entry else nil
	}, t549))
end
function t549.encode(p323) -- line: 22133
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n215 = 0

	if p323.foreground_header_entry ~= nil then
		local v4005 = p323.foreground_header_entry:encode()
		local v4006, v4007 = proto.writeTag(buf, n215, 1, proto.wireTypes.lengthDelimited)

		buf, n215 = proto.writeBuffer(v4006, v4007, v4005, buffer.len(v4005))
	end

	if p323.background_header_entry ~= nil then
		local v4008 = p323.background_header_entry:encode()
		local v4009, v4010 = proto.writeTag(buf, n215, 2, proto.wireTypes.lengthDelimited)

		buf, n215 = proto.writeBuffer(v4009, v4010, v4008, buffer.len(v4008))
	end

	local buf120 = buffer.create(n215)

	buffer.copy(buf120, 0, buf, 0, n215)

	return buf120
end
function t549.decode(p324: buffer) -- line: 22154
	-- upvalues: t549 (copy), proto (copy), t1 (copy)
	local v4013 = t549.new()
	local n216 = 0

	while n216 < buffer.len(p324) do
		local v4015, v4016

		v4015, v4016, n216 = proto.readTag(p324, n216)

		if v4016 == proto.wireTypes.varint then
			local v4017

			v4017, n216 = proto.readVarInt(p324, n216)
		elseif v4016 == proto.wireTypes.lengthDelimited then
			if v4015 == 1 then
				local v4018

				v4018, n216 = proto.readBuffer(p324, n216)
				v4013.foreground_header_entry = t1.ForegroundHeaderEntry.decode(v4018)
			elseif v4015 == 2 then
				local v4019

				v4019, n216 = proto.readBuffer(p324, n216)
				v4013.background_header_entry = t1.BackgroundHeaderEntry.decode(v4019)
			else
				local v4020, v4021 = proto.readVarInt(p324, n216)

				n216 = v4021 + v4020
			end
		elseif v4016 == proto.wireTypes.i32 then
			local v4022

			v4022, n216 = proto.readFixed32(p324, n216)
		elseif v4016 == proto.wireTypes.i64 then
			local v4023

			v4023, n216 = proto.readFixed64(p324, n216)
		else
			error("Unsupported wire type: " .. v4016)
		end
	end

	return v4013
end
function t549.jsonEncode(p325) -- line: 22202
	local t551 = {}

	if p325.foreground_header_entry ~= nil then
		t551.foregroundHeaderEntry = p325.foreground_header_entry:jsonEncode()
	end

	if p325.background_header_entry ~= nil then
		t551.backgroundHeaderEntry = p325.background_header_entry:jsonEncode()
	end

	return t551
end
function t549.jsonDecode(t552: {[any]: any}) -- line: 22216
	-- upvalues: t549 (copy), t1 (copy)
	local v4027 = t549.new()

	if t552.foreground_header_entry ~= nil then
		v4027.foreground_header_entry = t1.ForegroundHeaderEntry.jsonDecode(t552.foreground_header_entry)
	end

	if t552.foregroundHeaderEntry ~= nil then
		v4027.foreground_header_entry = t1.ForegroundHeaderEntry.jsonDecode(t552.foregroundHeaderEntry)
	end

	if t552.background_header_entry ~= nil then
		v4027.background_header_entry = t1.BackgroundHeaderEntry.jsonDecode(t552.background_header_entry)
	end

	if t552.backgroundHeaderEntry ~= nil then
		v4027.background_header_entry = t1.BackgroundHeaderEntry.jsonDecode(t552.backgroundHeaderEntry)
	end

	return v4027
end

t549.descriptor = {
	name = "PageHeaderInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.PageHeaderInputData"
}
t1.PageHeaderInputData = t549
typeRegistry.default:register(t1.PageHeaderInputData)

local t553 = {}

t553.__index = t553

function t553.new(t554: {[any]: any}?) -- line: 22252
	-- upvalues: t553 (copy)
	return (setmetatable({
		selected_option = if t554 ~= nil and t554.selected_option ~= nil then t554.selected_option else "",
		sort_id = if t554 ~= nil and t554.sort_id ~= nil then t554.sort_id else "",
		options = if t554 ~= nil and t554.options ~= nil then t554.options else {},
		experience_carousel = if t554 ~= nil and t554.experience_carousel ~= nil then t554.experience_carousel else nil,
		feed_item_key = if t554 ~= nil and t554.feed_item_key ~= nil then t554.feed_item_key else ""
	}, t553))
end
function t553.encode(p326) -- line: 22266
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n217 = 0

	if p326.selected_option ~= nil and p326.selected_option ~= "" then
		local v4032, v4033 = proto.writeTag(buf, n217, 1, proto.wireTypes.lengthDelimited)

		buf, n217 = proto.writeString(v4032, v4033, p326.selected_option)
	end

	if p326.sort_id ~= nil and p326.sort_id ~= "" then
		local v4034, v4035 = proto.writeTag(buf, n217, 2, proto.wireTypes.lengthDelimited)

		buf, n217 = proto.writeString(v4034, v4035, p326.sort_id)
	end

	if p326.options ~= nil and #p326.options > 0 then
		for _, v4037 in p326.options do
			local v4038 = v4037:encode()
			local v4039, v4040 = proto.writeTag(buf, n217, 3, proto.wireTypes.lengthDelimited)

			buf, n217 = proto.writeBuffer(v4039, v4040, v4038, buffer.len(v4038))
		end
	end

	if p326.experience_carousel ~= nil then
		local v4041 = p326.experience_carousel:encode()
		local v4042, v4043 = proto.writeTag(buf, n217, 4, proto.wireTypes.lengthDelimited)

		buf, n217 = proto.writeBuffer(v4042, v4043, v4041, buffer.len(v4041))
	end

	if p326.feed_item_key ~= nil and p326.feed_item_key ~= "" then
		local v4044, v4045 = proto.writeTag(buf, n217, 5, proto.wireTypes.lengthDelimited)

		buf, n217 = proto.writeString(v4044, v4045, p326.feed_item_key)
	end

	local buf121 = buffer.create(n217)

	buffer.copy(buf121, 0, buf, 0, n217)

	return buf121
end
function t553.decode(p327: buffer) -- line: 22304
	-- upvalues: t553 (copy), proto (copy), t1 (copy)
	local v4048 = t553.new()
	local n218 = 0

	while n218 < buffer.len(p327) do
		local v4050, v4051

		v4050, v4051, n218 = proto.readTag(p327, n218)

		if v4051 == proto.wireTypes.varint then
			local v4052

			v4052, n218 = proto.readVarInt(p327, n218)
		elseif v4051 == proto.wireTypes.lengthDelimited then
			if v4050 == 1 then
				local v4053

				v4053, n218 = proto.readBuffer(p327, n218)
				v4048.selected_option = buffer.tostring(v4053)
			elseif v4050 == 2 then
				local v4054

				v4054, n218 = proto.readBuffer(p327, n218)
				v4048.sort_id = buffer.tostring(v4054)
			elseif v4050 == 3 then
				local v4055

				v4055, n218 = proto.readBuffer(p327, n218)
				table.insert(v4048.options, t1.SelectorOption.decode(v4055))
			elseif v4050 == 4 then
				local v4056

				v4056, n218 = proto.readBuffer(p327, n218)
				v4048.experience_carousel = t1.ExperienceCarouselInputData.decode(v4056)
			elseif v4050 == 5 then
				local v4057

				v4057, n218 = proto.readBuffer(p327, n218)
				v4048.feed_item_key = buffer.tostring(v4057)
			else
				local v4058, v4059 = proto.readVarInt(p327, n218)

				n218 = v4059 + v4058
			end
		elseif v4051 == proto.wireTypes.i32 then
			local v4060

			v4060, n218 = proto.readFixed32(p327, n218)
		elseif v4051 == proto.wireTypes.i64 then
			local v4061

			v4061, n218 = proto.readFixed64(p327, n218)
		else
			error("Unsupported wire type: " .. v4051)
		end
	end

	return v4048
end
function t553.jsonEncode(p328) -- line: 22367
	local t555 = {}

	if p328.selected_option ~= nil and p328.selected_option ~= "" then
		t555.selectedOption = p328.selected_option
	end

	if p328.sort_id ~= nil and p328.sort_id ~= "" then
		t555.sortId = p328.sort_id
	end

	if p328.options ~= nil and #p328.options > 0 then
		local t556 = {}

		for _, v4066 in p328.options do
			table.insert(t556, v4066:jsonEncode())
		end

		t555.options = t556
	end

	if p328.experience_carousel ~= nil then
		t555.experienceCarousel = p328.experience_carousel:jsonEncode()
	end

	if p328.feed_item_key ~= nil and p328.feed_item_key ~= "" then
		t555.feedItemKey = p328.feed_item_key
	end

	return t555
end
function t553.jsonDecode(t557: {[any]: any}) -- line: 22397
	-- upvalues: t553 (copy), t1 (copy)
	local v4068 = t553.new()

	if t557.selected_option ~= nil then
		v4068.selected_option = t557.selected_option
	end

	if t557.selectedOption ~= nil then
		v4068.selected_option = t557.selectedOption
	end

	if t557.sort_id ~= nil then
		v4068.sort_id = t557.sort_id
	end

	if t557.sortId ~= nil then
		v4068.sort_id = t557.sortId
	end

	if t557.options ~= nil then
		local t558 = {}

		for _, v4071 in t557.options do
			table.insert(t558, t1.SelectorOption.jsonDecode(v4071))
		end

		v4068.options = t558
	end

	if t557.experience_carousel ~= nil then
		v4068.experience_carousel = t1.ExperienceCarouselInputData.jsonDecode(t557.experience_carousel)
	end

	if t557.experienceCarousel ~= nil then
		v4068.experience_carousel = t1.ExperienceCarouselInputData.jsonDecode(t557.experienceCarousel)
	end

	if t557.feed_item_key ~= nil then
		v4068.feed_item_key = t557.feed_item_key
	end

	if t557.feedItemKey ~= nil then
		v4068.feed_item_key = t557.feedItemKey
	end

	return v4068
end

t553.descriptor = {
	name = "OptionSelectorCarouselInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.OptionSelectorCarouselInputData"
}
t1.OptionSelectorCarouselInputData = t553
typeRegistry.default:register(t1.OptionSelectorCarouselInputData)

local t559 = {}

t559.__index = t559

function t559.new(t560: {[any]: any}?) -- line: 22458
	-- upvalues: t559 (copy)
	return (setmetatable({
		id = if t560 ~= nil and t560.id ~= nil then t560.id else "",
		display_name = if t560 ~= nil and t560.display_name ~= nil then t560.display_name else "",
		is_selected = t560 ~= nil and (t560.is_selected ~= nil and t560.is_selected)
	}, t559))
end
function t559.encode(p329) -- line: 22466
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n219 = 0

	if p329.id ~= nil and p329.id ~= "" then
		local v4076, v4077 = proto.writeTag(buf, n219, 1, proto.wireTypes.lengthDelimited)

		buf, n219 = proto.writeString(v4076, v4077, p329.id)
	end

	if p329.display_name ~= nil and p329.display_name ~= "" then
		local v4078, v4079 = proto.writeTag(buf, n219, 2, proto.wireTypes.lengthDelimited)

		buf, n219 = proto.writeString(v4078, v4079, p329.display_name)
	end

	if p329.is_selected then
		local v4080, v4081 = proto.writeTag(buf, n219, 3, proto.wireTypes.varint)

		buf, n219 = proto.writeVarInt(v4080, v4081, not p329.is_selected and 0 or 1)
	end

	local buf122 = buffer.create(n219)

	buffer.copy(buf122, 0, buf, 0, n219)

	return buf122
end
function t559.decode(p330: buffer) -- line: 22490
	-- upvalues: t559 (copy), proto (copy)
	local v4084 = t559.new()
	local n220 = 0

	while n220 < buffer.len(p330) do
		local v4086, v4087

		v4086, v4087, n220 = proto.readTag(p330, n220)

		if v4087 == proto.wireTypes.varint then
			if v4086 == 3 then
				local v4088

				v4088, n220 = proto.readVarInt(p330, n220)
				v4084.is_selected = v4088 ~= 0
			else
				local v4089

				v4089, n220 = proto.readVarInt(p330, n220)
			end
		elseif v4087 == proto.wireTypes.lengthDelimited then
			if v4086 == 1 then
				local v4090

				v4090, n220 = proto.readBuffer(p330, n220)
				v4084.id = buffer.tostring(v4090)
			elseif v4086 == 2 then
				local v4091

				v4091, n220 = proto.readBuffer(p330, n220)
				v4084.display_name = buffer.tostring(v4091)
			else
				local v4092, v4093 = proto.readVarInt(p330, n220)

				n220 = v4093 + v4092
			end
		elseif v4087 == proto.wireTypes.i32 then
			local v4094

			v4094, n220 = proto.readFixed32(p330, n220)
		elseif v4087 == proto.wireTypes.i64 then
			local v4095

			v4095, n220 = proto.readFixed64(p330, n220)
		else
			error("Unsupported wire type: " .. v4087)
		end
	end

	return v4084
end
function t559.jsonEncode(p331) -- line: 22543
	local t561 = {}

	if p331.id ~= nil and p331.id ~= "" then
		t561.id = p331.id
	end

	if p331.display_name ~= nil and p331.display_name ~= "" then
		t561.displayName = p331.display_name
	end

	if p331.is_selected then
		t561.isSelected = p331.is_selected
	end

	return t561
end
function t559.jsonDecode(t562: {[any]: any}) -- line: 22561
	-- upvalues: t559 (copy)
	local v4099 = t559.new()

	if t562.id ~= nil then
		v4099.id = t562.id
	end

	if t562.display_name ~= nil then
		v4099.display_name = t562.display_name
	end

	if t562.displayName ~= nil then
		v4099.display_name = t562.displayName
	end

	if t562.is_selected ~= nil then
		v4099.is_selected = t562.is_selected
	end

	if t562.isSelected ~= nil then
		v4099.is_selected = t562.isSelected
	end

	return v4099
end

t559.descriptor = {
	name = "SelectorOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.SelectorOption"
}
t1.SelectorOption = t559
typeRegistry.default:register(t1.SelectorOption)

local t563 = {}

t563.__index = t563

function t563.new(t564: {[any]: any}?) -- line: 22601
	-- upvalues: t563 (copy)
	return (setmetatable({
		layout = if t564 ~= nil and t564.layout ~= nil then t564.layout else nil,
		kind = if t564 ~= nil and t564.kind ~= nil then t564.kind else nil
	}, t563))
end
function t563.encode(p332) -- line: 22608
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n221 = 0

	if p332.layout ~= nil then
		local v4104 = p332.layout:encode()
		local v4105, v4106 = proto.writeTag(buf, n221, 1, proto.wireTypes.lengthDelimited)

		buf, n221 = proto.writeBuffer(v4105, v4106, v4104, buffer.len(v4104))
	end

	if p332.kind ~= nil and p332.kind.type == "universe" then
		local v4107 = p332.kind.value:encode()
		local v4108, v4109 = proto.writeTag(buf, n221, 2, proto.wireTypes.lengthDelimited)

		buf, n221 = proto.writeBuffer(v4108, v4109, v4107, buffer.len(v4107))
	end

	local buf123 = buffer.create(n221)

	buffer.copy(buf123, 0, buf, 0, n221)

	return buf123
end
function t563.decode(p333: buffer) -- line: 22631
	-- upvalues: t563 (copy), proto (copy), t1 (copy)
	local v4112 = t563.new()
	local n222 = 0

	while n222 < buffer.len(p333) do
		local v4114, v4115

		v4114, v4115, n222 = proto.readTag(p333, n222)

		if v4115 == proto.wireTypes.varint then
			local v4116

			v4116, n222 = proto.readVarInt(p333, n222)
		elseif v4115 == proto.wireTypes.lengthDelimited then
			if v4114 == 1 then
				local v4117

				v4117, n222 = proto.readBuffer(p333, n222)
				v4112.layout = t1.ItemLayout.decode(v4117)
			elseif v4114 == 2 then
				local v4118

				v4118, n222 = proto.readBuffer(p333, n222)
				v4112.kind = {
					type = "universe",
					value = t1.ExperienceCarouselInputData_UniverseItem.decode(v4118)
				}
			else
				local v4119, v4120 = proto.readVarInt(p333, n222)

				n222 = v4120 + v4119
			end
		elseif v4115 == proto.wireTypes.i32 then
			local v4121

			v4121, n222 = proto.readFixed32(p333, n222)
		elseif v4115 == proto.wireTypes.i64 then
			local v4122

			v4122, n222 = proto.readFixed64(p333, n222)
		else
			error("Unsupported wire type: " .. v4115)
		end
	end

	return v4112
end
function t563.jsonEncode(p334) -- line: 22680
	local t565 = {}

	if p334.layout ~= nil then
		t565.layout = p334.layout:jsonEncode()
	end

	if p334.kind ~= nil and p334.kind.type == "universe" then
		t565.universe = p334.kind.value:jsonEncode()
	end

	return t565
end
function t563.jsonDecode(t566: {[any]: any}) -- line: 22696
	-- upvalues: t563 (copy), t1 (copy)
	local v4126 = t563.new()

	if t566.layout ~= nil then
		v4126.layout = t1.ItemLayout.jsonDecode(t566.layout)
	end

	if t566.universe ~= nil then
		v4126.kind = {
			type = "universe",
			value = t1.ExperienceCarouselInputData_UniverseItem.jsonDecode(t566.universe)
		}
	end

	return v4126
end

t563.descriptor = {
	name = "ItemWithLayout",
	fullName = "roblox.apppageplatform.shared.v1beta1.ItemWithLayout"
}
t1.ItemWithLayout = t563
typeRegistry.default:register(t1.ItemWithLayout)

local t567 = {}

t567.__index = t567

function t567.new(t568: {[any]: any}?) -- line: 22727
	-- upvalues: t567 (copy)
	return (setmetatable({
		items = if t568 ~= nil and t568.items ~= nil then t568.items else {},
		collection_item_size = if t568 ~= nil and t568.collection_item_size ~= nil then t568.collection_item_size else nil
	}, t567))
end
function t567.encode(p335) -- line: 22736
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n223 = 0

	if p335.items ~= nil and #p335.items > 0 then
		for _, v4132 in p335.items do
			local v4133 = v4132:encode()
			local v4134, v4135 = proto.writeTag(buf, n223, 1, proto.wireTypes.lengthDelimited)

			buf, n223 = proto.writeBuffer(v4134, v4135, v4133, buffer.len(v4133))
		end
	end

	if p335.collection_item_size ~= nil then
		local v4136, v4137 = proto.writeTag(buf, n223, 2, proto.wireTypes.lengthDelimited)

		buf, n223 = proto.writeString(v4136, v4137, p335.collection_item_size)
	end

	local buf124 = buffer.create(n223)

	buffer.copy(buf124, 0, buf, 0, n223)

	return buf124
end
function t567.decode(p336: buffer) -- line: 22758
	-- upvalues: t567 (copy), proto (copy), t1 (copy)
	local v4140 = t567.new()
	local n224 = 0

	while n224 < buffer.len(p336) do
		local v4142, v4143

		v4142, v4143, n224 = proto.readTag(p336, n224)

		if v4143 == proto.wireTypes.varint then
			local v4144

			v4144, n224 = proto.readVarInt(p336, n224)
		elseif v4143 == proto.wireTypes.lengthDelimited then
			if v4142 == 1 then
				local v4145

				v4145, n224 = proto.readBuffer(p336, n224)
				table.insert(v4140.items, t1.ItemWithLayout.decode(v4145))
			elseif v4142 == 2 then
				local v4146

				v4146, n224 = proto.readBuffer(p336, n224)
				v4140.collection_item_size = buffer.tostring(v4146)
			else
				local v4147, v4148 = proto.readVarInt(p336, n224)

				n224 = v4148 + v4147
			end
		elseif v4143 == proto.wireTypes.i32 then
			local v4149

			v4149, n224 = proto.readFixed32(p336, n224)
		elseif v4143 == proto.wireTypes.i64 then
			local v4150

			v4150, n224 = proto.readFixed64(p336, n224)
		else
			error("Unsupported wire type: " .. v4143)
		end
	end

	return v4140
end
function t567.jsonEncode(p337) -- line: 22806
	local t569 = {}

	if p337.items ~= nil and #p337.items > 0 then
		local t570 = {}

		for _, v4155 in p337.items do
			table.insert(t570, v4155:jsonEncode())
		end

		t569.items = t570
	end

	if p337.collection_item_size ~= nil then
		t569.collectionItemSize = p337.collection_item_size
	end

	return t569
end
function t567.jsonDecode(t571: {[any]: any}) -- line: 22824
	-- upvalues: t567 (copy), t1 (copy)
	local v4157 = t567.new()

	if t571.items ~= nil then
		local t572 = {}

		for _, v4160 in t571.items do
			table.insert(t572, t1.ItemWithLayout.jsonDecode(v4160))
		end

		v4157.items = t572
	end

	if t571.collection_item_size ~= nil then
		v4157.collection_item_size = t571.collection_item_size
	end

	if t571.collectionItemSize ~= nil then
		v4157.collection_item_size = t571.collectionItemSize
	end

	return v4157
end

t567.descriptor = {
	name = "ContentPool",
	fullName = "roblox.apppageplatform.shared.v1beta1.ContentPool"
}
t1.ContentPool = t567
typeRegistry.default:register(t1.ContentPool)

local t573 = {}

t573.__index = t573

function t573.new(t574: {[any]: any}?) -- line: 22861
	-- upvalues: t573 (copy)
	return (setmetatable({
		col_span = if t574 ~= nil and t574.col_span ~= nil then t574.col_span else 0,
		row_span = if t574 ~= nil and t574.row_span ~= nil then t574.row_span else 0,
		alignment_type = if t574 ~= nil and t574.alignment_type ~= nil then t574.alignment_type else "",
		min_row_padding = if t574 ~= nil and t574.min_row_padding ~= nil then t574.min_row_padding else 0
	}, t573))
end
function t573.encode(p338) -- line: 22870
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n225 = 0

	if p338.col_span ~= nil and p338.col_span ~= 0 then
		local v4165, v4166 = proto.writeTag(buf, n225, 1, proto.wireTypes.varint)

		buf, n225 = proto.writeVarInt(v4165, v4166, p338.col_span)
	end

	if p338.row_span ~= nil and p338.row_span ~= 0 then
		local v4167, v4168 = proto.writeTag(buf, n225, 2, proto.wireTypes.varint)

		buf, n225 = proto.writeVarInt(v4167, v4168, p338.row_span)
	end

	if p338.alignment_type ~= nil and p338.alignment_type ~= "" then
		local v4169, v4170 = proto.writeTag(buf, n225, 3, proto.wireTypes.lengthDelimited)

		buf, n225 = proto.writeString(v4169, v4170, p338.alignment_type)
	end

	if p338.min_row_padding ~= nil and p338.min_row_padding ~= 0 then
		local v4171, v4172 = proto.writeTag(buf, n225, 4, proto.wireTypes.varint)

		buf, n225 = proto.writeVarInt(v4171, v4172, p338.min_row_padding)
	end

	local buf125 = buffer.create(n225)

	buffer.copy(buf125, 0, buf, 0, n225)

	return buf125
end
function t573.decode(p339: buffer) -- line: 22899
	-- upvalues: t573 (copy), proto (copy)
	local v4175 = t573.new()
	local n226 = 0

	while n226 < buffer.len(p339) do
		local v4177, v4178

		v4177, v4178, n226 = proto.readTag(p339, n226)

		if v4178 == proto.wireTypes.varint then
			if v4177 == 1 then
				local v4179

				v4179, n226 = proto.readVarIntI32(p339, n226)
				v4175.col_span = v4179
			elseif v4177 == 2 then
				local v4180

				v4180, n226 = proto.readVarIntI32(p339, n226)
				v4175.row_span = v4180
			elseif v4177 == 4 then
				local v4181

				v4181, n226 = proto.readVarIntI32(p339, n226)
				v4175.min_row_padding = v4181
			else
				local v4182

				v4182, n226 = proto.readVarInt(p339, n226)
			end
		elseif v4178 == proto.wireTypes.lengthDelimited then
			if v4177 == 3 then
				local v4183

				v4183, n226 = proto.readBuffer(p339, n226)
				v4175.alignment_type = buffer.tostring(v4183)
			else
				local v4184, v4185 = proto.readVarInt(p339, n226)

				n226 = v4185 + v4184
			end
		elseif v4178 == proto.wireTypes.i32 then
			local v4186

			v4186, n226 = proto.readFixed32(p339, n226)
		elseif v4178 == proto.wireTypes.i64 then
			local v4187

			v4187, n226 = proto.readFixed64(p339, n226)
		else
			error("Unsupported wire type: " .. v4178)
		end
	end

	return v4175
end
function t573.jsonEncode(p340) -- line: 22957
	local t575 = {}

	if p340.col_span ~= nil and p340.col_span ~= 0 then
		t575.colSpan = p340.col_span
	end

	if p340.row_span ~= nil and p340.row_span ~= 0 then
		t575.rowSpan = p340.row_span
	end

	if p340.alignment_type ~= nil and p340.alignment_type ~= "" then
		t575.alignmentType = p340.alignment_type
	end

	if p340.min_row_padding ~= nil and p340.min_row_padding ~= 0 then
		t575.minRowPadding = p340.min_row_padding
	end

	return t575
end
function t573.jsonDecode(t576: {[any]: any}) -- line: 22979
	-- upvalues: t573 (copy)
	local v4191 = t573.new()

	if t576.col_span ~= nil then
		v4191.col_span = t576.col_span
	end

	if t576.colSpan ~= nil then
		v4191.col_span = t576.colSpan
	end

	if t576.row_span ~= nil then
		v4191.row_span = t576.row_span
	end

	if t576.rowSpan ~= nil then
		v4191.row_span = t576.rowSpan
	end

	if t576.alignment_type ~= nil then
		v4191.alignment_type = t576.alignment_type
	end

	if t576.alignmentType ~= nil then
		v4191.alignment_type = t576.alignmentType
	end

	if t576.min_row_padding ~= nil then
		v4191.min_row_padding = t576.min_row_padding
	end

	if t576.minRowPadding ~= nil then
		v4191.min_row_padding = t576.minRowPadding
	end

	return v4191
end

t573.descriptor = {
	name = "ItemLayout",
	fullName = "roblox.apppageplatform.shared.v1beta1.ItemLayout"
}
t1.ItemLayout = t573
typeRegistry.default:register(t1.ItemLayout)
t1.PageEntryFormat = {
	fromNumber = function(n227: number) -- line: 23028
		if n227 == 0 then
			return "PAGE_ENTRY_FORMAT_INVALID"
		end

		if n227 == 1 then
			return "PAGE_ENTRY_FORMAT_UNIVERSAL"
		end

		return nil
	end,
	toNumber = function(p341) -- line: 23038
		if p341 == "PAGE_ENTRY_FORMAT_INVALID" then
			return 0
		end

		if p341 == "PAGE_ENTRY_FORMAT_UNIVERSAL" then
			return 1
		end

		return p341
	end,
	fromName = function(s2: string) -- line: 23048
		if s2 == "PAGE_ENTRY_FORMAT_INVALID" then
			return "PAGE_ENTRY_FORMAT_INVALID"
		end

		if s2 == "PAGE_ENTRY_FORMAT_UNIVERSAL" then
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
	CommunitySectionInputData = t1.CommunitySectionInputData,
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
	DynamicStoreCategoryInputData = t1.DynamicStoreCategoryInputData,
	DynamicStoreCategoryInputData_DynamicStoreCategoryItem = t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItem,
	DynamicStoreCategoryInputData_DynamicStoreCategoryItemType = t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItemType,
	CardContainerCardInputData = t1.CardContainerCardInputData,
	CardContainerInputData = t1.CardContainerInputData,
	CardInputData = t1.CardInputData,
	DialogInputData = t1.DialogInputData,
	IncomingTransferContent = t1.IncomingTransferContent,
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
	ChartsGenreSelectorInputData = t1.ChartsGenreSelectorInputData,
	UAMarketplaceCatalogItemGroupInputData = t1.UAMarketplaceCatalogItemGroupInputData,
	UAMarketplaceCatalogItemCarouselInputData = t1.UAMarketplaceCatalogItemCarouselInputData,
	WidgetStyleData = t1.WidgetStyleData,
	UAMarketplaceCatalogHeroUnitInputData = t1.UAMarketplaceCatalogHeroUnitInputData,
	UAMarketplaceCatalogFeedInputData = t1.UAMarketplaceCatalogFeedInputData,
	UAMarketplaceCatalogCategoryMenuInputData = t1.UAMarketplaceCatalogCategoryMenuInputData,
	UAMarketplaceCatalogCategoryMenuInputData_MarketplaceCatalogCategoryItem = t1.UAMarketplaceCatalogCategoryMenuInputData_MarketplaceCatalogCategoryItem,
	MarketplaceOfferModalInputData = t1.MarketplaceOfferModalInputData,
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
