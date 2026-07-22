local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local background_layer = require(script.Parent.background_layer)
local page_entry = require(script.Parent.page_entry)
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 3578
	-- upvalues: t2 (copy)
	return (setmetatable({
		page_entry = if t3 ~= nil and t3.page_entry ~= nil then t3.page_entry else nil,
		input_data = if t3 ~= nil and t3.input_data ~= nil then t3.input_data else nil
	}, t2))
end
function t2.encode(p1) -- line: 3585
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.page_entry ~= nil then
		local v122 = p1.page_entry:encode()
		local v123, v124 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeBuffer(v123, v124, v122, buffer.len(v122))
	end

	if p1.input_data ~= nil then
		local v125 = p1.input_data:encode()
		local v126, v127 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeBuffer(v126, v127, v125, buffer.len(v125))
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 3606
	-- upvalues: t2 (copy), proto (copy), page_entry (copy), t1 (copy)
	local v130 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v132, v133

		v132, v133, n2 = proto.readTag(p2, n2)

		if v133 == proto.wireTypes.varint then
			local v134

			v134, n2 = proto.readVarInt(p2, n2)
		elseif v133 == proto.wireTypes.lengthDelimited then
			if v132 == 1 then
				local v135

				v135, n2 = proto.readBuffer(p2, n2)
				v130.page_entry = page_entry.PageEntry.decode(v135)
			elseif v132 == 2 then
				local v136

				v136, n2 = proto.readBuffer(p2, n2)
				v130.input_data = t1.PageEntryInputData.decode(v136)
			else
				local v137, v138 = proto.readVarInt(p2, n2)

				n2 = v138 + v137
			end
		elseif v133 == proto.wireTypes.i32 then
			local v139

			v139, n2 = proto.readFixed32(p2, n2)
		elseif v133 == proto.wireTypes.i64 then
			local v140

			v140, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v133)
		end
	end

	return v130
end
function t2.jsonEncode(p3) -- line: 3654
	local t4 = {}

	if p3.page_entry ~= nil then
		t4.pageEntry = p3.page_entry:jsonEncode()
	end

	if p3.input_data ~= nil then
		t4.inputData = p3.input_data:jsonEncode()
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 3668
	-- upvalues: t2 (copy), page_entry (copy), t1 (copy)
	local v144 = t2.new()

	if t5.page_entry ~= nil then
		v144.page_entry = page_entry.PageEntry.jsonDecode(t5.page_entry)
	end

	if t5.pageEntry ~= nil then
		v144.page_entry = page_entry.PageEntry.jsonDecode(t5.pageEntry)
	end

	if t5.input_data ~= nil then
		v144.input_data = t1.PageEntryInputData.jsonDecode(t5.input_data)
	end

	if t5.inputData ~= nil then
		v144.input_data = t1.PageEntryInputData.jsonDecode(t5.inputData)
	end

	return v144
end

t2.descriptor = {
	name = "UniversalPageEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniversalPageEntry"
}
t1.UniversalPageEntry = t2
typeRegistry.default:register(t1.UniversalPageEntry)

local t6 = {}

t6.__index = t6

function t6.new(t7: {[any]: any}?) -- line: 3704
	-- upvalues: t6 (copy)
	return (setmetatable({
		input_data = if t7 ~= nil and t7.input_data ~= nil then t7.input_data else nil,
		roblox_component = if t7 ~= nil and t7.roblox_component ~= nil then t7.roblox_component else ""
	}, t6))
end
function t6.encode(p4) -- line: 3711
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n3 = 0

	if p4.input_data ~= nil then
		local v149 = p4.input_data:encode()
		local v150, v151 = proto.writeTag(buf, n3, 1, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeBuffer(v150, v151, v149, buffer.len(v149))
	end

	if p4.roblox_component ~= nil and p4.roblox_component ~= "" then
		local v152, v153 = proto.writeTag(buf, n3, 2, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeString(v152, v153, p4.roblox_component)
	end

	local buf3 = buffer.create(n3)

	buffer.copy(buf3, 0, buf, 0, n3)

	return buf3
end
function t6.decode(p5: buffer) -- line: 3731
	-- upvalues: t6 (copy), proto (copy), t1 (copy)
	local v156 = t6.new()
	local n4 = 0

	while n4 < buffer.len(p5) do
		local v158, v159

		v158, v159, n4 = proto.readTag(p5, n4)

		if v159 == proto.wireTypes.varint then
			local v160

			v160, n4 = proto.readVarInt(p5, n4)
		elseif v159 == proto.wireTypes.lengthDelimited then
			if v158 == 1 then
				local v161

				v161, n4 = proto.readBuffer(p5, n4)
				v156.input_data = t1.PageEntryInputData.decode(v161)
			elseif v158 == 2 then
				local v162

				v162, n4 = proto.readBuffer(p5, n4)
				v156.roblox_component = buffer.tostring(v162)
			else
				local v163, v164 = proto.readVarInt(p5, n4)

				n4 = v164 + v163
			end
		elseif v159 == proto.wireTypes.i32 then
			local v165

			v165, n4 = proto.readFixed32(p5, n4)
		elseif v159 == proto.wireTypes.i64 then
			local v166

			v166, n4 = proto.readFixed64(p5, n4)
		else
			error("Unsupported wire type: " .. v159)
		end
	end

	return v156
end
function t6.jsonEncode(p6) -- line: 3779
	local t8 = {}

	if p6.input_data ~= nil then
		t8.inputData = p6.input_data:jsonEncode()
	end

	if p6.roblox_component ~= nil and p6.roblox_component ~= "" then
		t8.robloxComponent = p6.roblox_component
	end

	return t8
end
function t6.jsonDecode(t9: {[any]: any}) -- line: 3793
	-- upvalues: t6 (copy), t1 (copy)
	local v170 = t6.new()

	if t9.input_data ~= nil then
		v170.input_data = t1.PageEntryInputData.jsonDecode(t9.input_data)
	end

	if t9.inputData ~= nil then
		v170.input_data = t1.PageEntryInputData.jsonDecode(t9.inputData)
	end

	if t9.roblox_component ~= nil then
		v170.roblox_component = t9.roblox_component
	end

	if t9.robloxComponent ~= nil then
		v170.roblox_component = t9.robloxComponent
	end

	return v170
end

t6.descriptor = {
	name = "FeedEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.FeedEntry"
}
t1.FeedEntry = t6
typeRegistry.default:register(t1.FeedEntry)

local t10 = {}

t10.__index = t10

function t10.new(t11: {[any]: any}?) -- line: 3829
	-- upvalues: t10 (copy)
	return (setmetatable({
		roblox_component = if t11 ~= nil and t11.roblox_component ~= nil then t11.roblox_component else "",
		input_data = if t11 ~= nil and t11.input_data ~= nil then t11.input_data else nil
	}, t10))
end
function t10.encode(p7) -- line: 3836
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n5 = 0

	if p7.roblox_component ~= nil and p7.roblox_component ~= "" then
		local v175, v176 = proto.writeTag(buf, n5, 1, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeString(v175, v176, p7.roblox_component)
	end

	if p7.input_data ~= nil and p7.input_data.type == "attribution_row" then
		local v177 = p7.input_data.value:encode()
		local v178, v179 = proto.writeTag(buf, n5, 2, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeBuffer(v178, v179, v177, buffer.len(v177))
	end

	local buf4 = buffer.create(n5)

	buffer.copy(buf4, 0, buf, 0, n5)

	return buf4
end
function t10.decode(p8: buffer) -- line: 3858
	-- upvalues: t10 (copy), proto (copy), t1 (copy)
	local v182 = t10.new()
	local n6 = 0

	while n6 < buffer.len(p8) do
		local v184, v185

		v184, v185, n6 = proto.readTag(p8, n6)

		if v185 == proto.wireTypes.varint then
			local v186

			v186, n6 = proto.readVarInt(p8, n6)
		elseif v185 == proto.wireTypes.lengthDelimited then
			if v184 == 1 then
				local v187

				v187, n6 = proto.readBuffer(p8, n6)
				v182.roblox_component = buffer.tostring(v187)
			elseif v184 == 2 then
				local v188

				v188, n6 = proto.readBuffer(p8, n6)
				v182.input_data = {
					type = "attribution_row",
					value = t1.AttributionRowInputData.decode(v188)
				}
			else
				local v189, v190 = proto.readVarInt(p8, n6)

				n6 = v190 + v189
			end
		elseif v185 == proto.wireTypes.i32 then
			local v191

			v191, n6 = proto.readFixed32(p8, n6)
		elseif v185 == proto.wireTypes.i64 then
			local v192

			v192, n6 = proto.readFixed64(p8, n6)
		else
			error("Unsupported wire type: " .. v185)
		end
	end

	return v182
end
function t10.jsonEncode(p9) -- line: 3907
	local t12 = {}

	if p9.roblox_component ~= nil and p9.roblox_component ~= "" then
		t12.robloxComponent = p9.roblox_component
	end

	if p9.input_data ~= nil and p9.input_data.type == "attribution_row" then
		t12.attributionRow = p9.input_data.value:jsonEncode()
	end

	return t12
end
function t10.jsonDecode(t13: {[any]: any}) -- line: 3923
	-- upvalues: t10 (copy), t1 (copy)
	local v196 = t10.new()

	if t13.roblox_component ~= nil then
		v196.roblox_component = t13.roblox_component
	end

	if t13.robloxComponent ~= nil then
		v196.roblox_component = t13.robloxComponent
	end

	if t13.attribution_row ~= nil then
		v196.input_data = {
			type = "attribution_row",
			value = t1.AttributionRowInputData.jsonDecode(t13.attribution_row)
		}
	end

	if t13.attributionRow ~= nil then
		v196.input_data = {
			type = "attribution_row",
			value = t1.AttributionRowInputData.jsonDecode(t13.attributionRow)
		}
	end

	return v196
end

t10.descriptor = {
	name = "ForegroundHeaderEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.ForegroundHeaderEntry"
}
t1.ForegroundHeaderEntry = t10
typeRegistry.default:register(t1.ForegroundHeaderEntry)

local t14 = {}

t14.__index = t14

function t14.new(t15: {[any]: any}?) -- line: 3961
	-- upvalues: t14 (copy)
	return (setmetatable({
		roblox_component = if t15 ~= nil and t15.roblox_component ~= nil then t15.roblox_component else "",
		input_data = if t15 ~= nil and t15.input_data ~= nil then t15.input_data else nil
	}, t14))
end
function t14.encode(p10) -- line: 3968
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n7 = 0

	if p10.roblox_component ~= nil and p10.roblox_component ~= "" then
		local v201, v202 = proto.writeTag(buf, n7, 1, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeString(v201, v202, p10.roblox_component)
	end

	if p10.input_data ~= nil and p10.input_data.type == "image" then
		local v203 = p10.input_data.value:encode()
		local v204, v205 = proto.writeTag(buf, n7, 2, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeBuffer(v204, v205, v203, buffer.len(v203))
	end

	local buf5 = buffer.create(n7)

	buffer.copy(buf5, 0, buf, 0, n7)

	return buf5
end
function t14.decode(p11: buffer) -- line: 3990
	-- upvalues: t14 (copy), proto (copy), t1 (copy)
	local v208 = t14.new()
	local n8 = 0

	while n8 < buffer.len(p11) do
		local v210, v211

		v210, v211, n8 = proto.readTag(p11, n8)

		if v211 == proto.wireTypes.varint then
			local v212

			v212, n8 = proto.readVarInt(p11, n8)
		elseif v211 == proto.wireTypes.lengthDelimited then
			if v210 == 1 then
				local v213

				v213, n8 = proto.readBuffer(p11, n8)
				v208.roblox_component = buffer.tostring(v213)
			elseif v210 == 2 then
				local v214

				v214, n8 = proto.readBuffer(p11, n8)
				v208.input_data = {
					type = "image",
					value = t1.ImageInputData.decode(v214)
				}
			else
				local v215, v216 = proto.readVarInt(p11, n8)

				n8 = v216 + v215
			end
		elseif v211 == proto.wireTypes.i32 then
			local v217

			v217, n8 = proto.readFixed32(p11, n8)
		elseif v211 == proto.wireTypes.i64 then
			local v218

			v218, n8 = proto.readFixed64(p11, n8)
		else
			error("Unsupported wire type: " .. v211)
		end
	end

	return v208
end
function t14.jsonEncode(p12) -- line: 4038
	local t16 = {}

	if p12.roblox_component ~= nil and p12.roblox_component ~= "" then
		t16.robloxComponent = p12.roblox_component
	end

	if p12.input_data ~= nil and p12.input_data.type == "image" then
		t16.image = p12.input_data.value:jsonEncode()
	end

	return t16
end
function t14.jsonDecode(t17: {[any]: any}) -- line: 4054
	-- upvalues: t14 (copy), t1 (copy)
	local v222 = t14.new()

	if t17.roblox_component ~= nil then
		v222.roblox_component = t17.roblox_component
	end

	if t17.robloxComponent ~= nil then
		v222.roblox_component = t17.robloxComponent
	end

	if t17.image ~= nil then
		v222.input_data = {
			type = "image",
			value = t1.ImageInputData.jsonDecode(t17.image)
		}
	end

	return v222
end

t14.descriptor = {
	name = "BackgroundHeaderEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.BackgroundHeaderEntry"
}
t1.BackgroundHeaderEntry = t14
typeRegistry.default:register(t1.BackgroundHeaderEntry)

local t18 = {}

t18.__index = t18

function t18.new(t19: {[any]: any}?) -- line: 4086
	-- upvalues: t18 (copy)
	return (setmetatable({
		kind = if t19 ~= nil and t19.kind ~= nil then t19.kind else nil
	}, t18))
end
function t18.encode(p13) -- line: 4092
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n9 = 0

	if p13.kind ~= nil then
		if p13.kind.type == "badges_grid" then
			local v227 = p13.kind.value:encode()
			local v228, v229 = proto.writeTag(buf, n9, 1, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v228, v229, v227, buffer.len(v227))
		elseif p13.kind.type == "badge_details" then
			local v230 = p13.kind.value:encode()
			local v231, v232 = proto.writeTag(buf, n9, 2, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v231, v232, v230, buffer.len(v230))
		elseif p13.kind.type == "static_content" then
			local v233 = p13.kind.value:encode()
			local v234, v235 = proto.writeTag(buf, n9, 3, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v234, v235, v233, buffer.len(v233))
		elseif p13.kind.type == "experience_attribution_row" then
			local v236 = p13.kind.value:encode()
			local v237, v238 = proto.writeTag(buf, n9, 4, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v237, v238, v236, buffer.len(v236))
		elseif p13.kind.type == "experience_action_module" then
			local v239 = p13.kind.value:encode()
			local v240, v241 = proto.writeTag(buf, n9, 5, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v240, v241, v239, buffer.len(v239))
		elseif p13.kind.type == "experience_media_gallery" then
			local v242 = p13.kind.value:encode()
			local v243, v244 = proto.writeTag(buf, n9, 6, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v243, v244, v242, buffer.len(v242))
		elseif p13.kind.type == "experience_description" then
			local v245 = p13.kind.value:encode()
			local v246, v247 = proto.writeTag(buf, n9, 7, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v246, v247, v245, buffer.len(v245))
		elseif p13.kind.type == "experience_stat_row" then
			local v248 = p13.kind.value:encode()
			local v249, v250 = proto.writeTag(buf, n9, 8, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v249, v250, v248, buffer.len(v248))
		elseif p13.kind.type == "experience_info_table" then
			local v251 = p13.kind.value:encode()
			local v252, v253 = proto.writeTag(buf, n9, 9, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v252, v253, v251, buffer.len(v251))
		elseif p13.kind.type == "social_link_row" then
			local v254 = p13.kind.value:encode()
			local v255, v256 = proto.writeTag(buf, n9, 10, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v255, v256, v254, buffer.len(v254))
		elseif p13.kind.type == "experience_carousel" then
			local v257 = p13.kind.value:encode()
			local v258, v259 = proto.writeTag(buf, n9, 11, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v258, v259, v257, buffer.len(v257))
		elseif p13.kind.type == "song_carousel" then
			local v260 = p13.kind.value:encode()
			local v261, v262 = proto.writeTag(buf, n9, 12, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v261, v262, v260, buffer.len(v260))
		elseif p13.kind.type == "events_carousel" then
			local v263 = p13.kind.value:encode()
			local v264, v265 = proto.writeTag(buf, n9, 13, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v264, v265, v263, buffer.len(v263))
		elseif p13.kind.type == "game_pass_collection" then
			local v266 = p13.kind.value:encode()
			local v267, v268 = proto.writeTag(buf, n9, 14, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v267, v268, v266, buffer.len(v266))
		elseif p13.kind.type == "developer_product_collection" then
			local v269 = p13.kind.value:encode()
			local v270, v271 = proto.writeTag(buf, n9, 15, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v270, v271, v269, buffer.len(v269))
		elseif p13.kind.type == "subscription_collection" then
			local v272 = p13.kind.value:encode()
			local v273, v274 = proto.writeTag(buf, n9, 16, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v273, v274, v272, buffer.len(v272))
		elseif p13.kind.type == "dynamic_store_category" then
			local v275 = p13.kind.value:encode()
			local v276, v277 = proto.writeTag(buf, n9, 17, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v276, v277, v275, buffer.len(v275))
		elseif p13.kind.type == "card_container" then
			local v278 = p13.kind.value:encode()
			local v279, v280 = proto.writeTag(buf, n9, 20, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v279, v280, v278, buffer.len(v278))
		elseif p13.kind.type == "card" then
			local v281 = p13.kind.value:encode()
			local v282, v283 = proto.writeTag(buf, n9, 21, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v282, v283, v281, buffer.len(v281))
		elseif p13.kind.type == "dialog" then
			local v284 = p13.kind.value:encode()
			local v285, v286 = proto.writeTag(buf, n9, 22, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v285, v286, v284, buffer.len(v284))
		elseif p13.kind.type == "banner" then
			local v287 = p13.kind.value:encode()
			local v288, v289 = proto.writeTag(buf, n9, 23, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v288, v289, v287, buffer.len(v287))
		elseif p13.kind.type == "tooltip" then
			local v290 = p13.kind.value:encode()
			local v291, v292 = proto.writeTag(buf, n9, 24, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v291, v292, v290, buffer.len(v290))
		elseif p13.kind.type == "coachmark" then
			local v293 = p13.kind.value:encode()
			local v294, v295 = proto.writeTag(buf, n9, 25, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v294, v295, v293, buffer.len(v293))
		elseif p13.kind.type == "system_banner_prompt" then
			local v296 = p13.kind.value:encode()
			local v297, v298 = proto.writeTag(buf, n9, 28, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v297, v298, v296, buffer.len(v296))
		elseif p13.kind.type == "age_check_upsell" then
			local v299 = p13.kind.value:encode()
			local v300, v301 = proto.writeTag(buf, n9, 29, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v300, v301, v299, buffer.len(v299))
		elseif p13.kind.type == "catalog_item_list" then
			local v302 = p13.kind.value:encode()
			local v303, v304 = proto.writeTag(buf, n9, 26, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v303, v304, v302, buffer.len(v302))
		elseif p13.kind.type == "user_list" then
			local v305 = p13.kind.value:encode()
			local v306, v307 = proto.writeTag(buf, n9, 27, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v306, v307, v305, buffer.len(v305))
		elseif p13.kind.type == "experience_content_rating_label" then
			local v308 = p13.kind.value:encode()
			local v309, v310 = proto.writeTag(buf, n9, 30, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v309, v310, v308, buffer.len(v308))
		elseif p13.kind.type == "experience_refund_policy" then
			local v311 = p13.kind.value:encode()
			local v312, v313 = proto.writeTag(buf, n9, 31, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v312, v313, v311, buffer.len(v311))
		elseif p13.kind.type == "experience_play_with_reward" then
			local v314 = p13.kind.value:encode()
			local v315, v316 = proto.writeTag(buf, n9, 32, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v315, v316, v314, buffer.len(v314))
		elseif p13.kind.type == "experience_guidelines_dialog" then
			local v317 = p13.kind.value:encode()
			local v318, v319 = proto.writeTag(buf, n9, 33, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v318, v319, v317, buffer.len(v317))
		elseif p13.kind.type == "community_section" then
			local v320 = p13.kind.value:encode()
			local v321, v322 = proto.writeTag(buf, n9, 35, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v321, v322, v320, buffer.len(v320))
		elseif p13.kind.type == "moments_carousel" then
			local v323 = p13.kind.value:encode()
			local v324, v325 = proto.writeTag(buf, n9, 34, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v324, v325, v323, buffer.len(v323))
		elseif p13.kind.type == "text" then
			local v326 = p13.kind.value:encode()
			local v327, v328 = proto.writeTag(buf, n9, 40, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v327, v328, v326, buffer.len(v326))
		elseif p13.kind.type == "vertical_feed" then
			local v329 = p13.kind.value:encode()
			local v330, v331 = proto.writeTag(buf, n9, 41, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v330, v331, v329, buffer.len(v329))
		elseif p13.kind.type == "page_header" then
			local v332 = p13.kind.value:encode()
			local v333, v334 = proto.writeTag(buf, n9, 42, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v333, v334, v332, buffer.len(v332))
		elseif p13.kind.type == "experience_details_feed" then
			local v335 = p13.kind.value:encode()
			local v336, v337 = proto.writeTag(buf, n9, 500, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v336, v337, v335, buffer.len(v335))
		elseif p13.kind.type == "experience_details_action_bar" then
			local v338 = p13.kind.value:encode()
			local v339, v340 = proto.writeTag(buf, n9, 501, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v339, v340, v338, buffer.len(v338))
		elseif p13.kind.type == "experience_details_banner_image" then
			local v341 = p13.kind.value:encode()
			local v342, v343 = proto.writeTag(buf, n9, 502, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v342, v343, v341, buffer.len(v341))
		elseif p13.kind.type == "experience_details_sticky_header" then
			local v344 = p13.kind.value:encode()
			local v345, v346 = proto.writeTag(buf, n9, 503, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v345, v346, v344, buffer.len(v344))
		elseif p13.kind.type == "event_details_feed" then
			local v347 = p13.kind.value:encode()
			local v348, v349 = proto.writeTag(buf, n9, 600, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v348, v349, v347, buffer.len(v347))
		elseif p13.kind.type == "event_details_action_bar" then
			local v350 = p13.kind.value:encode()
			local v351, v352 = proto.writeTag(buf, n9, 601, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v351, v352, v350, buffer.len(v350))
		elseif p13.kind.type == "event_attribution_row" then
			local v353 = p13.kind.value:encode()
			local v354, v355 = proto.writeTag(buf, n9, 602, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v354, v355, v353, buffer.len(v353))
		elseif p13.kind.type == "event_description" then
			local v356 = p13.kind.value:encode()
			local v357, v358 = proto.writeTag(buf, n9, 603, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v357, v358, v356, buffer.len(v356))
		elseif p13.kind.type == "event_info_table" then
			local v359 = p13.kind.value:encode()
			local v360, v361 = proto.writeTag(buf, n9, 604, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v360, v361, v359, buffer.len(v359))
		elseif p13.kind.type == "event_details_sheet_full_bleed" then
			local v362 = p13.kind.value:encode()
			local v363, v364 = proto.writeTag(buf, n9, 605, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v363, v364, v362, buffer.len(v362))
		elseif p13.kind.type == "event_notifications_modal" then
			local v365 = p13.kind.value:encode()
			local v366, v367 = proto.writeTag(buf, n9, 606, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v366, v367, v365, buffer.len(v365))
		elseif p13.kind.type == "dev_store_feed" then
			local v368 = p13.kind.value:encode()
			local v369, v370 = proto.writeTag(buf, n9, 700, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v369, v370, v368, buffer.len(v368))
		elseif p13.kind.type == "charts_feed" then
			local v371 = p13.kind.value:encode()
			local v372, v373 = proto.writeTag(buf, n9, 800, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v372, v373, v371, buffer.len(v371))
		elseif p13.kind.type == "filter_pills" then
			local v374 = p13.kind.value:encode()
			local v375, v376 = proto.writeTag(buf, n9, 801, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v375, v376, v374, buffer.len(v374))
		elseif p13.kind.type == "sort_selector" then
			local v377 = p13.kind.value:encode()
			local v378, v379 = proto.writeTag(buf, n9, 802, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v378, v379, v377, buffer.len(v377))
		elseif p13.kind.type == "genre_selector" then
			local v380 = p13.kind.value:encode()
			local v381, v382 = proto.writeTag(buf, n9, 803, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v381, v382, v380, buffer.len(v380))
		elseif p13.kind.type == "marketplace_catalog_feed" then
			local v383 = p13.kind.value:encode()
			local v384, v385 = proto.writeTag(buf, n9, 900, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v384, v385, v383, buffer.len(v383))
		elseif p13.kind.type == "marketplace_catalog_category_menu" then
			local v386 = p13.kind.value:encode()
			local v387, v388 = proto.writeTag(buf, n9, 901, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v387, v388, v386, buffer.len(v386))
		elseif p13.kind.type == "marketplace_catalog_item_group" then
			local v389 = p13.kind.value:encode()
			local v390, v391 = proto.writeTag(buf, n9, 902, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v390, v391, v389, buffer.len(v389))
		elseif p13.kind.type == "marketplace_catalog_item_carousel" then
			local v392 = p13.kind.value:encode()
			local v393, v394 = proto.writeTag(buf, n9, 903, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v393, v394, v392, buffer.len(v392))
		elseif p13.kind.type == "marketplace_catalog_hero_unit" then
			local v395 = p13.kind.value:encode()
			local v396, v397 = proto.writeTag(buf, n9, 904, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v396, v397, v395, buffer.len(v395))
		elseif p13.kind.type == "catalog_item_grid" then
			local v398 = p13.kind.value:encode()
			local v399, v400 = proto.writeTag(buf, n9, 905, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v399, v400, v398, buffer.len(v398))
		elseif p13.kind.type == "search_results_feed" then
			local v401 = p13.kind.value:encode()
			local v402, v403 = proto.writeTag(buf, n9, 1000, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v402, v403, v401, buffer.len(v401))
		elseif p13.kind.type == "power_search_ai_overview" then
			local v404 = p13.kind.value:encode()
			local v405, v406 = proto.writeTag(buf, n9, 1001, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v405, v406, v404, buffer.len(v404))
		elseif p13.kind.type == "experience_emphasis_tile" then
			local v407 = p13.kind.value:encode()
			local v408, v409 = proto.writeTag(buf, n9, 1002, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v408, v409, v407, buffer.len(v407))
		elseif p13.kind.type == "option_selector_carousel" then
			local v410 = p13.kind.value:encode()
			local v411, v412 = proto.writeTag(buf, n9, 1100, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v411, v412, v410, buffer.len(v410))
		elseif p13.kind.type == "party_chat_conversation_upsell" then
			local v413 = p13.kind.value:encode()
			local v414, v415 = proto.writeTag(buf, n9, 1200, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v414, v415, v413, buffer.len(v413))
		end
	end

	local buf6 = buffer.create(n9)

	buffer.copy(buf6, 0, buf, 0, n9)

	return buf6
end
function t18.decode(p14: buffer) -- line: 4357
	-- upvalues: t18 (copy), proto (copy), t1 (copy)
	local v418 = t18.new()
	local n10 = 0

	while n10 < buffer.len(p14) do
		local v420, v421

		v420, v421, n10 = proto.readTag(p14, n10)

		if v421 == proto.wireTypes.varint then
			local v422

			v422, n10 = proto.readVarInt(p14, n10)
		elseif v421 == proto.wireTypes.lengthDelimited then
			if v420 == 1 then
				local v423

				v423, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "badges_grid",
					value = t1.BadgesGridInputData.decode(v423)
				}
			elseif v420 == 2 then
				local v424

				v424, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "badge_details",
					value = t1.BadgeDetailsInputData.decode(v424)
				}
			elseif v420 == 3 then
				local v425

				v425, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "static_content",
					value = t1.StaticInputData.decode(v425)
				}
			elseif v420 == 4 then
				local v426

				v426, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "experience_attribution_row",
					value = t1.ExperienceAttributionRowInputData.decode(v426)
				}
			elseif v420 == 5 then
				local v427

				v427, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "experience_action_module",
					value = t1.ExperienceActionModuleInputData.decode(v427)
				}
			elseif v420 == 6 then
				local v428

				v428, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "experience_media_gallery",
					value = t1.ExperienceMediaGalleryInputData.decode(v428)
				}
			elseif v420 == 7 then
				local v429

				v429, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "experience_description",
					value = t1.ExperienceDescriptionInputData.decode(v429)
				}
			elseif v420 == 8 then
				local v430

				v430, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "experience_stat_row",
					value = t1.ExperienceStatRowInputData.decode(v430)
				}
			elseif v420 == 9 then
				local v431

				v431, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "experience_info_table",
					value = t1.ExperienceInfoTableInputData.decode(v431)
				}
			elseif v420 == 10 then
				local v432

				v432, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "social_link_row",
					value = t1.SocialLinkRowInputData.decode(v432)
				}
			elseif v420 == 11 then
				local v433

				v433, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "experience_carousel",
					value = t1.ExperienceCarouselInputData.decode(v433)
				}
			elseif v420 == 12 then
				local v434

				v434, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "song_carousel",
					value = t1.SongCarouselInputData.decode(v434)
				}
			elseif v420 == 13 then
				local v435

				v435, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "events_carousel",
					value = t1.EventsCarouselInputData.decode(v435)
				}
			elseif v420 == 14 then
				local v436

				v436, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "game_pass_collection",
					value = t1.GamePassCollectionInputData.decode(v436)
				}
			elseif v420 == 15 then
				local v437

				v437, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "developer_product_collection",
					value = t1.DeveloperProductCollectionInputData.decode(v437)
				}
			elseif v420 == 16 then
				local v438

				v438, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "subscription_collection",
					value = t1.SubscriptionCollectionInputData.decode(v438)
				}
			elseif v420 == 17 then
				local v439

				v439, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "dynamic_store_category",
					value = t1.DynamicStoreCategoryInputData.decode(v439)
				}
			elseif v420 == 20 then
				local v440

				v440, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "card_container",
					value = t1.CardContainerInputData.decode(v440)
				}
			elseif v420 == 21 then
				local v441

				v441, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "card",
					value = t1.CardInputData.decode(v441)
				}
			elseif v420 == 22 then
				local v442

				v442, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "dialog",
					value = t1.DialogInputData.decode(v442)
				}
			elseif v420 == 23 then
				local v443

				v443, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "banner",
					value = t1.BannerInputData.decode(v443)
				}
			elseif v420 == 24 then
				local v444

				v444, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "tooltip",
					value = t1.TooltipInputData.decode(v444)
				}
			elseif v420 == 25 then
				local v445

				v445, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "coachmark",
					value = t1.CoachmarkInputData.decode(v445)
				}
			elseif v420 == 26 then
				local v446

				v446, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "catalog_item_list",
					value = t1.CatalogItemListInputData.decode(v446)
				}
			elseif v420 == 27 then
				local v447

				v447, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "user_list",
					value = t1.UserListInputData.decode(v447)
				}
			elseif v420 == 28 then
				local v448

				v448, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "system_banner_prompt",
					value = t1.SystemBannerInputData.decode(v448)
				}
			elseif v420 == 29 then
				local v449

				v449, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "age_check_upsell",
					value = t1.AgeCheckUpsellInputData.decode(v449)
				}
			elseif v420 == 30 then
				local v450

				v450, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "experience_content_rating_label",
					value = t1.ExperienceContentRatingLabelInputData.decode(v450)
				}
			elseif v420 == 31 then
				local v451

				v451, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "experience_refund_policy",
					value = t1.ExperienceRefundPolicyInputData.decode(v451)
				}
			elseif v420 == 32 then
				local v452

				v452, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "experience_play_with_reward",
					value = t1.ExperiencePlayWithRewardInputData.decode(v452)
				}
			elseif v420 == 33 then
				local v453

				v453, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "experience_guidelines_dialog",
					value = t1.ExperienceGuidelinesDialogInputData.decode(v453)
				}
			elseif v420 == 34 then
				local v454

				v454, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "moments_carousel",
					value = t1.MomentsCarouselInputData.decode(v454)
				}
			elseif v420 == 35 then
				local v455

				v455, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "community_section",
					value = t1.CommunitySectionInputData.decode(v455)
				}
			elseif v420 == 40 then
				local v456

				v456, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "text",
					value = t1.TextInputData.decode(v456)
				}
			elseif v420 == 41 then
				local v457

				v457, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "vertical_feed",
					value = t1.VerticalFeedInputData.decode(v457)
				}
			elseif v420 == 42 then
				local v458

				v458, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "page_header",
					value = t1.PageHeaderInputData.decode(v458)
				}
			elseif v420 == 500 then
				local v459

				v459, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "experience_details_feed",
					value = t1.ExperienceDetailsFeedInputData.decode(v459)
				}
			elseif v420 == 501 then
				local v460

				v460, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "experience_details_action_bar",
					value = t1.ExperienceDetailsActionBarInputData.decode(v460)
				}
			elseif v420 == 502 then
				local v461

				v461, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "experience_details_banner_image",
					value = t1.ExperienceDetailsBannerImageInputData.decode(v461)
				}
			elseif v420 == 503 then
				local v462

				v462, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "experience_details_sticky_header",
					value = t1.ExperienceDetailsStickyHeaderInputData.decode(v462)
				}
			elseif v420 == 600 then
				local v463

				v463, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "event_details_feed",
					value = t1.EventDetailsFeedInputData.decode(v463)
				}
			elseif v420 == 601 then
				local v464

				v464, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "event_details_action_bar",
					value = t1.EventDetailsActionBarInputData.decode(v464)
				}
			elseif v420 == 602 then
				local v465

				v465, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "event_attribution_row",
					value = t1.EventAttributionRowInputData.decode(v465)
				}
			elseif v420 == 603 then
				local v466

				v466, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "event_description",
					value = t1.EventDescriptionInputData.decode(v466)
				}
			elseif v420 == 604 then
				local v467

				v467, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "event_info_table",
					value = t1.EventInfoTableInputData.decode(v467)
				}
			elseif v420 == 605 then
				local v468

				v468, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "event_details_sheet_full_bleed",
					value = t1.EventDetailsSheetFullBleedInputData.decode(v468)
				}
			elseif v420 == 606 then
				local v469

				v469, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "event_notifications_modal",
					value = t1.EventNotificationsModalInputData.decode(v469)
				}
			elseif v420 == 700 then
				local v470

				v470, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "dev_store_feed",
					value = t1.DevStoreFeedInputData.decode(v470)
				}
			elseif v420 == 800 then
				local v471

				v471, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "charts_feed",
					value = t1.ChartsFeedInputData.decode(v471)
				}
			elseif v420 == 801 then
				local v472

				v472, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "filter_pills",
					value = t1.FilterPillsInputData.decode(v472)
				}
			elseif v420 == 802 then
				local v473

				v473, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "sort_selector",
					value = t1.SortSelectorInputData.decode(v473)
				}
			elseif v420 == 803 then
				local v474

				v474, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "genre_selector",
					value = t1.ChartsGenreSelectorInputData.decode(v474)
				}
			elseif v420 == 900 then
				local v475

				v475, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "marketplace_catalog_feed",
					value = t1.UAMarketplaceCatalogFeedInputData.decode(v475)
				}
			elseif v420 == 901 then
				local v476

				v476, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "marketplace_catalog_category_menu",
					value = t1.UAMarketplaceCatalogCategoryMenuInputData.decode(v476)
				}
			elseif v420 == 902 then
				local v477

				v477, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "marketplace_catalog_item_group",
					value = t1.UAMarketplaceCatalogItemGroupInputData.decode(v477)
				}
			elseif v420 == 903 then
				local v478

				v478, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "marketplace_catalog_item_carousel",
					value = t1.UAMarketplaceCatalogItemCarouselInputData.decode(v478)
				}
			elseif v420 == 904 then
				local v479

				v479, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "marketplace_catalog_hero_unit",
					value = t1.UAMarketplaceCatalogHeroUnitInputData.decode(v479)
				}
			elseif v420 == 905 then
				local v480

				v480, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "catalog_item_grid",
					value = t1.CatalogItemGridInputData.decode(v480)
				}
			elseif v420 == 1000 then
				local v481

				v481, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "search_results_feed",
					value = t1.SearchResultsFeedInputData.decode(v481)
				}
			elseif v420 == 1001 then
				local v482

				v482, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "power_search_ai_overview",
					value = t1.PowerSearchAIOverviewInputData.decode(v482)
				}
			elseif v420 == 1002 then
				local v483

				v483, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "experience_emphasis_tile",
					value = t1.ExperienceEmphasisTileInputData.decode(v483)
				}
			elseif v420 == 1100 then
				local v484

				v484, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "option_selector_carousel",
					value = t1.OptionSelectorCarouselInputData.decode(v484)
				}
			elseif v420 == 1200 then
				local v485

				v485, n10 = proto.readBuffer(p14, n10)
				v418.kind = {
					type = "party_chat_conversation_upsell",
					value = t1.PartyChatConversationUpsellInputData.decode(v485)
				}
			else
				local v486, v487 = proto.readVarInt(p14, n10)

				n10 = v487 + v486
			end
		elseif v421 == proto.wireTypes.i32 then
			local v488

			v488, n10 = proto.readFixed32(p14, n10)
		elseif v421 == proto.wireTypes.i64 then
			local v489

			v489, n10 = proto.readFixed64(p14, n10)
		else
			error("Unsupported wire type: " .. v421)
		end
	end

	return v418
end
function t18.jsonEncode(p15) -- line: 4798
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
function t18.jsonDecode(t21: {[any]: any}) -- line: 4934
	-- upvalues: t18 (copy), t1 (copy)
	local v493 = t18.new()

	if t21.badges_grid ~= nil then
		v493.kind = {
			type = "badges_grid",
			value = t1.BadgesGridInputData.jsonDecode(t21.badges_grid)
		}
	end

	if t21.badgesGrid ~= nil then
		v493.kind = {
			type = "badges_grid",
			value = t1.BadgesGridInputData.jsonDecode(t21.badgesGrid)
		}
	end

	if t21.badge_details ~= nil then
		v493.kind = {
			type = "badge_details",
			value = t1.BadgeDetailsInputData.jsonDecode(t21.badge_details)
		}
	end

	if t21.badgeDetails ~= nil then
		v493.kind = {
			type = "badge_details",
			value = t1.BadgeDetailsInputData.jsonDecode(t21.badgeDetails)
		}
	end

	if t21.static_content ~= nil then
		v493.kind = {
			type = "static_content",
			value = t1.StaticInputData.jsonDecode(t21.static_content)
		}
	end

	if t21.staticContent ~= nil then
		v493.kind = {
			type = "static_content",
			value = t1.StaticInputData.jsonDecode(t21.staticContent)
		}
	end

	if t21.experience_attribution_row ~= nil then
		v493.kind = {
			type = "experience_attribution_row",
			value = t1.ExperienceAttributionRowInputData.jsonDecode(t21.experience_attribution_row)
		}
	end

	if t21.experienceAttributionRow ~= nil then
		v493.kind = {
			type = "experience_attribution_row",
			value = t1.ExperienceAttributionRowInputData.jsonDecode(t21.experienceAttributionRow)
		}
	end

	if t21.experience_action_module ~= nil then
		v493.kind = {
			type = "experience_action_module",
			value = t1.ExperienceActionModuleInputData.jsonDecode(t21.experience_action_module)
		}
	end

	if t21.experienceActionModule ~= nil then
		v493.kind = {
			type = "experience_action_module",
			value = t1.ExperienceActionModuleInputData.jsonDecode(t21.experienceActionModule)
		}
	end

	if t21.experience_media_gallery ~= nil then
		v493.kind = {
			type = "experience_media_gallery",
			value = t1.ExperienceMediaGalleryInputData.jsonDecode(t21.experience_media_gallery)
		}
	end

	if t21.experienceMediaGallery ~= nil then
		v493.kind = {
			type = "experience_media_gallery",
			value = t1.ExperienceMediaGalleryInputData.jsonDecode(t21.experienceMediaGallery)
		}
	end

	if t21.experience_description ~= nil then
		v493.kind = {
			type = "experience_description",
			value = t1.ExperienceDescriptionInputData.jsonDecode(t21.experience_description)
		}
	end

	if t21.experienceDescription ~= nil then
		v493.kind = {
			type = "experience_description",
			value = t1.ExperienceDescriptionInputData.jsonDecode(t21.experienceDescription)
		}
	end

	if t21.experience_stat_row ~= nil then
		v493.kind = {
			type = "experience_stat_row",
			value = t1.ExperienceStatRowInputData.jsonDecode(t21.experience_stat_row)
		}
	end

	if t21.experienceStatRow ~= nil then
		v493.kind = {
			type = "experience_stat_row",
			value = t1.ExperienceStatRowInputData.jsonDecode(t21.experienceStatRow)
		}
	end

	if t21.experience_info_table ~= nil then
		v493.kind = {
			type = "experience_info_table",
			value = t1.ExperienceInfoTableInputData.jsonDecode(t21.experience_info_table)
		}
	end

	if t21.experienceInfoTable ~= nil then
		v493.kind = {
			type = "experience_info_table",
			value = t1.ExperienceInfoTableInputData.jsonDecode(t21.experienceInfoTable)
		}
	end

	if t21.social_link_row ~= nil then
		v493.kind = {
			type = "social_link_row",
			value = t1.SocialLinkRowInputData.jsonDecode(t21.social_link_row)
		}
	end

	if t21.socialLinkRow ~= nil then
		v493.kind = {
			type = "social_link_row",
			value = t1.SocialLinkRowInputData.jsonDecode(t21.socialLinkRow)
		}
	end

	if t21.experience_carousel ~= nil then
		v493.kind = {
			type = "experience_carousel",
			value = t1.ExperienceCarouselInputData.jsonDecode(t21.experience_carousel)
		}
	end

	if t21.experienceCarousel ~= nil then
		v493.kind = {
			type = "experience_carousel",
			value = t1.ExperienceCarouselInputData.jsonDecode(t21.experienceCarousel)
		}
	end

	if t21.song_carousel ~= nil then
		v493.kind = {
			type = "song_carousel",
			value = t1.SongCarouselInputData.jsonDecode(t21.song_carousel)
		}
	end

	if t21.songCarousel ~= nil then
		v493.kind = {
			type = "song_carousel",
			value = t1.SongCarouselInputData.jsonDecode(t21.songCarousel)
		}
	end

	if t21.events_carousel ~= nil then
		v493.kind = {
			type = "events_carousel",
			value = t1.EventsCarouselInputData.jsonDecode(t21.events_carousel)
		}
	end

	if t21.eventsCarousel ~= nil then
		v493.kind = {
			type = "events_carousel",
			value = t1.EventsCarouselInputData.jsonDecode(t21.eventsCarousel)
		}
	end

	if t21.game_pass_collection ~= nil then
		v493.kind = {
			type = "game_pass_collection",
			value = t1.GamePassCollectionInputData.jsonDecode(t21.game_pass_collection)
		}
	end

	if t21.gamePassCollection ~= nil then
		v493.kind = {
			type = "game_pass_collection",
			value = t1.GamePassCollectionInputData.jsonDecode(t21.gamePassCollection)
		}
	end

	if t21.developer_product_collection ~= nil then
		v493.kind = {
			type = "developer_product_collection",
			value = t1.DeveloperProductCollectionInputData.jsonDecode(t21.developer_product_collection)
		}
	end

	if t21.developerProductCollection ~= nil then
		v493.kind = {
			type = "developer_product_collection",
			value = t1.DeveloperProductCollectionInputData.jsonDecode(t21.developerProductCollection)
		}
	end

	if t21.subscription_collection ~= nil then
		v493.kind = {
			type = "subscription_collection",
			value = t1.SubscriptionCollectionInputData.jsonDecode(t21.subscription_collection)
		}
	end

	if t21.subscriptionCollection ~= nil then
		v493.kind = {
			type = "subscription_collection",
			value = t1.SubscriptionCollectionInputData.jsonDecode(t21.subscriptionCollection)
		}
	end

	if t21.dynamic_store_category ~= nil then
		v493.kind = {
			type = "dynamic_store_category",
			value = t1.DynamicStoreCategoryInputData.jsonDecode(t21.dynamic_store_category)
		}
	end

	if t21.dynamicStoreCategory ~= nil then
		v493.kind = {
			type = "dynamic_store_category",
			value = t1.DynamicStoreCategoryInputData.jsonDecode(t21.dynamicStoreCategory)
		}
	end

	if t21.card_container ~= nil then
		v493.kind = {
			type = "card_container",
			value = t1.CardContainerInputData.jsonDecode(t21.card_container)
		}
	end

	if t21.cardContainer ~= nil then
		v493.kind = {
			type = "card_container",
			value = t1.CardContainerInputData.jsonDecode(t21.cardContainer)
		}
	end

	if t21.card ~= nil then
		v493.kind = {
			type = "card",
			value = t1.CardInputData.jsonDecode(t21.card)
		}
	end

	if t21.dialog ~= nil then
		v493.kind = {
			type = "dialog",
			value = t1.DialogInputData.jsonDecode(t21.dialog)
		}
	end

	if t21.banner ~= nil then
		v493.kind = {
			type = "banner",
			value = t1.BannerInputData.jsonDecode(t21.banner)
		}
	end

	if t21.tooltip ~= nil then
		v493.kind = {
			type = "tooltip",
			value = t1.TooltipInputData.jsonDecode(t21.tooltip)
		}
	end

	if t21.coachmark ~= nil then
		v493.kind = {
			type = "coachmark",
			value = t1.CoachmarkInputData.jsonDecode(t21.coachmark)
		}
	end

	if t21.system_banner_prompt ~= nil then
		v493.kind = {
			type = "system_banner_prompt",
			value = t1.SystemBannerInputData.jsonDecode(t21.system_banner_prompt)
		}
	end

	if t21.systemBannerPrompt ~= nil then
		v493.kind = {
			type = "system_banner_prompt",
			value = t1.SystemBannerInputData.jsonDecode(t21.systemBannerPrompt)
		}
	end

	if t21.age_check_upsell ~= nil then
		v493.kind = {
			type = "age_check_upsell",
			value = t1.AgeCheckUpsellInputData.jsonDecode(t21.age_check_upsell)
		}
	end

	if t21.ageCheckUpsell ~= nil then
		v493.kind = {
			type = "age_check_upsell",
			value = t1.AgeCheckUpsellInputData.jsonDecode(t21.ageCheckUpsell)
		}
	end

	if t21.catalog_item_list ~= nil then
		v493.kind = {
			type = "catalog_item_list",
			value = t1.CatalogItemListInputData.jsonDecode(t21.catalog_item_list)
		}
	end

	if t21.catalogItemList ~= nil then
		v493.kind = {
			type = "catalog_item_list",
			value = t1.CatalogItemListInputData.jsonDecode(t21.catalogItemList)
		}
	end

	if t21.user_list ~= nil then
		v493.kind = {
			type = "user_list",
			value = t1.UserListInputData.jsonDecode(t21.user_list)
		}
	end

	if t21.userList ~= nil then
		v493.kind = {
			type = "user_list",
			value = t1.UserListInputData.jsonDecode(t21.userList)
		}
	end

	if t21.experience_content_rating_label ~= nil then
		v493.kind = {
			type = "experience_content_rating_label",
			value = t1.ExperienceContentRatingLabelInputData.jsonDecode(t21.experience_content_rating_label)
		}
	end

	if t21.experienceContentRatingLabel ~= nil then
		v493.kind = {
			type = "experience_content_rating_label",
			value = t1.ExperienceContentRatingLabelInputData.jsonDecode(t21.experienceContentRatingLabel)
		}
	end

	if t21.experience_refund_policy ~= nil then
		v493.kind = {
			type = "experience_refund_policy",
			value = t1.ExperienceRefundPolicyInputData.jsonDecode(t21.experience_refund_policy)
		}
	end

	if t21.experienceRefundPolicy ~= nil then
		v493.kind = {
			type = "experience_refund_policy",
			value = t1.ExperienceRefundPolicyInputData.jsonDecode(t21.experienceRefundPolicy)
		}
	end

	if t21.experience_play_with_reward ~= nil then
		v493.kind = {
			type = "experience_play_with_reward",
			value = t1.ExperiencePlayWithRewardInputData.jsonDecode(t21.experience_play_with_reward)
		}
	end

	if t21.experiencePlayWithReward ~= nil then
		v493.kind = {
			type = "experience_play_with_reward",
			value = t1.ExperiencePlayWithRewardInputData.jsonDecode(t21.experiencePlayWithReward)
		}
	end

	if t21.experience_guidelines_dialog ~= nil then
		v493.kind = {
			type = "experience_guidelines_dialog",
			value = t1.ExperienceGuidelinesDialogInputData.jsonDecode(t21.experience_guidelines_dialog)
		}
	end

	if t21.experienceGuidelinesDialog ~= nil then
		v493.kind = {
			type = "experience_guidelines_dialog",
			value = t1.ExperienceGuidelinesDialogInputData.jsonDecode(t21.experienceGuidelinesDialog)
		}
	end

	if t21.community_section ~= nil then
		v493.kind = {
			type = "community_section",
			value = t1.CommunitySectionInputData.jsonDecode(t21.community_section)
		}
	end

	if t21.communitySection ~= nil then
		v493.kind = {
			type = "community_section",
			value = t1.CommunitySectionInputData.jsonDecode(t21.communitySection)
		}
	end

	if t21.moments_carousel ~= nil then
		v493.kind = {
			type = "moments_carousel",
			value = t1.MomentsCarouselInputData.jsonDecode(t21.moments_carousel)
		}
	end

	if t21.momentsCarousel ~= nil then
		v493.kind = {
			type = "moments_carousel",
			value = t1.MomentsCarouselInputData.jsonDecode(t21.momentsCarousel)
		}
	end

	if t21.text ~= nil then
		v493.kind = {
			type = "text",
			value = t1.TextInputData.jsonDecode(t21.text)
		}
	end

	if t21.vertical_feed ~= nil then
		v493.kind = {
			type = "vertical_feed",
			value = t1.VerticalFeedInputData.jsonDecode(t21.vertical_feed)
		}
	end

	if t21.verticalFeed ~= nil then
		v493.kind = {
			type = "vertical_feed",
			value = t1.VerticalFeedInputData.jsonDecode(t21.verticalFeed)
		}
	end

	if t21.page_header ~= nil then
		v493.kind = {
			type = "page_header",
			value = t1.PageHeaderInputData.jsonDecode(t21.page_header)
		}
	end

	if t21.pageHeader ~= nil then
		v493.kind = {
			type = "page_header",
			value = t1.PageHeaderInputData.jsonDecode(t21.pageHeader)
		}
	end

	if t21.experience_details_feed ~= nil then
		v493.kind = {
			type = "experience_details_feed",
			value = t1.ExperienceDetailsFeedInputData.jsonDecode(t21.experience_details_feed)
		}
	end

	if t21.experienceDetailsFeed ~= nil then
		v493.kind = {
			type = "experience_details_feed",
			value = t1.ExperienceDetailsFeedInputData.jsonDecode(t21.experienceDetailsFeed)
		}
	end

	if t21.experience_details_action_bar ~= nil then
		v493.kind = {
			type = "experience_details_action_bar",
			value = t1.ExperienceDetailsActionBarInputData.jsonDecode(t21.experience_details_action_bar)
		}
	end

	if t21.experienceDetailsActionBar ~= nil then
		v493.kind = {
			type = "experience_details_action_bar",
			value = t1.ExperienceDetailsActionBarInputData.jsonDecode(t21.experienceDetailsActionBar)
		}
	end

	if t21.experience_details_banner_image ~= nil then
		v493.kind = {
			type = "experience_details_banner_image",
			value = t1.ExperienceDetailsBannerImageInputData.jsonDecode(t21.experience_details_banner_image)
		}
	end

	if t21.experienceDetailsBannerImage ~= nil then
		v493.kind = {
			type = "experience_details_banner_image",
			value = t1.ExperienceDetailsBannerImageInputData.jsonDecode(t21.experienceDetailsBannerImage)
		}
	end

	if t21.experience_details_sticky_header ~= nil then
		v493.kind = {
			type = "experience_details_sticky_header",
			value = t1.ExperienceDetailsStickyHeaderInputData.jsonDecode(t21.experience_details_sticky_header)
		}
	end

	if t21.experienceDetailsStickyHeader ~= nil then
		v493.kind = {
			type = "experience_details_sticky_header",
			value = t1.ExperienceDetailsStickyHeaderInputData.jsonDecode(t21.experienceDetailsStickyHeader)
		}
	end

	if t21.event_details_feed ~= nil then
		v493.kind = {
			type = "event_details_feed",
			value = t1.EventDetailsFeedInputData.jsonDecode(t21.event_details_feed)
		}
	end

	if t21.eventDetailsFeed ~= nil then
		v493.kind = {
			type = "event_details_feed",
			value = t1.EventDetailsFeedInputData.jsonDecode(t21.eventDetailsFeed)
		}
	end

	if t21.event_details_action_bar ~= nil then
		v493.kind = {
			type = "event_details_action_bar",
			value = t1.EventDetailsActionBarInputData.jsonDecode(t21.event_details_action_bar)
		}
	end

	if t21.eventDetailsActionBar ~= nil then
		v493.kind = {
			type = "event_details_action_bar",
			value = t1.EventDetailsActionBarInputData.jsonDecode(t21.eventDetailsActionBar)
		}
	end

	if t21.event_attribution_row ~= nil then
		v493.kind = {
			type = "event_attribution_row",
			value = t1.EventAttributionRowInputData.jsonDecode(t21.event_attribution_row)
		}
	end

	if t21.eventAttributionRow ~= nil then
		v493.kind = {
			type = "event_attribution_row",
			value = t1.EventAttributionRowInputData.jsonDecode(t21.eventAttributionRow)
		}
	end

	if t21.event_description ~= nil then
		v493.kind = {
			type = "event_description",
			value = t1.EventDescriptionInputData.jsonDecode(t21.event_description)
		}
	end

	if t21.eventDescription ~= nil then
		v493.kind = {
			type = "event_description",
			value = t1.EventDescriptionInputData.jsonDecode(t21.eventDescription)
		}
	end

	if t21.event_info_table ~= nil then
		v493.kind = {
			type = "event_info_table",
			value = t1.EventInfoTableInputData.jsonDecode(t21.event_info_table)
		}
	end

	if t21.eventInfoTable ~= nil then
		v493.kind = {
			type = "event_info_table",
			value = t1.EventInfoTableInputData.jsonDecode(t21.eventInfoTable)
		}
	end

	if t21.event_details_sheet_full_bleed ~= nil then
		v493.kind = {
			type = "event_details_sheet_full_bleed",
			value = t1.EventDetailsSheetFullBleedInputData.jsonDecode(t21.event_details_sheet_full_bleed)
		}
	end

	if t21.eventDetailsSheetFullBleed ~= nil then
		v493.kind = {
			type = "event_details_sheet_full_bleed",
			value = t1.EventDetailsSheetFullBleedInputData.jsonDecode(t21.eventDetailsSheetFullBleed)
		}
	end

	if t21.event_notifications_modal ~= nil then
		v493.kind = {
			type = "event_notifications_modal",
			value = t1.EventNotificationsModalInputData.jsonDecode(t21.event_notifications_modal)
		}
	end

	if t21.eventNotificationsModal ~= nil then
		v493.kind = {
			type = "event_notifications_modal",
			value = t1.EventNotificationsModalInputData.jsonDecode(t21.eventNotificationsModal)
		}
	end

	if t21.dev_store_feed ~= nil then
		v493.kind = {
			type = "dev_store_feed",
			value = t1.DevStoreFeedInputData.jsonDecode(t21.dev_store_feed)
		}
	end

	if t21.devStoreFeed ~= nil then
		v493.kind = {
			type = "dev_store_feed",
			value = t1.DevStoreFeedInputData.jsonDecode(t21.devStoreFeed)
		}
	end

	if t21.charts_feed ~= nil then
		v493.kind = {
			type = "charts_feed",
			value = t1.ChartsFeedInputData.jsonDecode(t21.charts_feed)
		}
	end

	if t21.chartsFeed ~= nil then
		v493.kind = {
			type = "charts_feed",
			value = t1.ChartsFeedInputData.jsonDecode(t21.chartsFeed)
		}
	end

	if t21.filter_pills ~= nil then
		v493.kind = {
			type = "filter_pills",
			value = t1.FilterPillsInputData.jsonDecode(t21.filter_pills)
		}
	end

	if t21.filterPills ~= nil then
		v493.kind = {
			type = "filter_pills",
			value = t1.FilterPillsInputData.jsonDecode(t21.filterPills)
		}
	end

	if t21.sort_selector ~= nil then
		v493.kind = {
			type = "sort_selector",
			value = t1.SortSelectorInputData.jsonDecode(t21.sort_selector)
		}
	end

	if t21.sortSelector ~= nil then
		v493.kind = {
			type = "sort_selector",
			value = t1.SortSelectorInputData.jsonDecode(t21.sortSelector)
		}
	end

	if t21.genre_selector ~= nil then
		v493.kind = {
			type = "genre_selector",
			value = t1.ChartsGenreSelectorInputData.jsonDecode(t21.genre_selector)
		}
	end

	if t21.genreSelector ~= nil then
		v493.kind = {
			type = "genre_selector",
			value = t1.ChartsGenreSelectorInputData.jsonDecode(t21.genreSelector)
		}
	end

	if t21.marketplace_catalog_feed ~= nil then
		v493.kind = {
			type = "marketplace_catalog_feed",
			value = t1.UAMarketplaceCatalogFeedInputData.jsonDecode(t21.marketplace_catalog_feed)
		}
	end

	if t21.marketplaceCatalogFeed ~= nil then
		v493.kind = {
			type = "marketplace_catalog_feed",
			value = t1.UAMarketplaceCatalogFeedInputData.jsonDecode(t21.marketplaceCatalogFeed)
		}
	end

	if t21.marketplace_catalog_category_menu ~= nil then
		v493.kind = {
			type = "marketplace_catalog_category_menu",
			value = t1.UAMarketplaceCatalogCategoryMenuInputData.jsonDecode(t21.marketplace_catalog_category_menu)
		}
	end

	if t21.marketplaceCatalogCategoryMenu ~= nil then
		v493.kind = {
			type = "marketplace_catalog_category_menu",
			value = t1.UAMarketplaceCatalogCategoryMenuInputData.jsonDecode(t21.marketplaceCatalogCategoryMenu)
		}
	end

	if t21.marketplace_catalog_item_group ~= nil then
		v493.kind = {
			type = "marketplace_catalog_item_group",
			value = t1.UAMarketplaceCatalogItemGroupInputData.jsonDecode(t21.marketplace_catalog_item_group)
		}
	end

	if t21.marketplaceCatalogItemGroup ~= nil then
		v493.kind = {
			type = "marketplace_catalog_item_group",
			value = t1.UAMarketplaceCatalogItemGroupInputData.jsonDecode(t21.marketplaceCatalogItemGroup)
		}
	end

	if t21.marketplace_catalog_item_carousel ~= nil then
		v493.kind = {
			type = "marketplace_catalog_item_carousel",
			value = t1.UAMarketplaceCatalogItemCarouselInputData.jsonDecode(t21.marketplace_catalog_item_carousel)
		}
	end

	if t21.marketplaceCatalogItemCarousel ~= nil then
		v493.kind = {
			type = "marketplace_catalog_item_carousel",
			value = t1.UAMarketplaceCatalogItemCarouselInputData.jsonDecode(t21.marketplaceCatalogItemCarousel)
		}
	end

	if t21.marketplace_catalog_hero_unit ~= nil then
		v493.kind = {
			type = "marketplace_catalog_hero_unit",
			value = t1.UAMarketplaceCatalogHeroUnitInputData.jsonDecode(t21.marketplace_catalog_hero_unit)
		}
	end

	if t21.marketplaceCatalogHeroUnit ~= nil then
		v493.kind = {
			type = "marketplace_catalog_hero_unit",
			value = t1.UAMarketplaceCatalogHeroUnitInputData.jsonDecode(t21.marketplaceCatalogHeroUnit)
		}
	end

	if t21.catalog_item_grid ~= nil then
		v493.kind = {
			type = "catalog_item_grid",
			value = t1.CatalogItemGridInputData.jsonDecode(t21.catalog_item_grid)
		}
	end

	if t21.catalogItemGrid ~= nil then
		v493.kind = {
			type = "catalog_item_grid",
			value = t1.CatalogItemGridInputData.jsonDecode(t21.catalogItemGrid)
		}
	end

	if t21.search_results_feed ~= nil then
		v493.kind = {
			type = "search_results_feed",
			value = t1.SearchResultsFeedInputData.jsonDecode(t21.search_results_feed)
		}
	end

	if t21.searchResultsFeed ~= nil then
		v493.kind = {
			type = "search_results_feed",
			value = t1.SearchResultsFeedInputData.jsonDecode(t21.searchResultsFeed)
		}
	end

	if t21.power_search_ai_overview ~= nil then
		v493.kind = {
			type = "power_search_ai_overview",
			value = t1.PowerSearchAIOverviewInputData.jsonDecode(t21.power_search_ai_overview)
		}
	end

	if t21.powerSearchAiOverview ~= nil then
		v493.kind = {
			type = "power_search_ai_overview",
			value = t1.PowerSearchAIOverviewInputData.jsonDecode(t21.powerSearchAiOverview)
		}
	end

	if t21.experience_emphasis_tile ~= nil then
		v493.kind = {
			type = "experience_emphasis_tile",
			value = t1.ExperienceEmphasisTileInputData.jsonDecode(t21.experience_emphasis_tile)
		}
	end

	if t21.experienceEmphasisTile ~= nil then
		v493.kind = {
			type = "experience_emphasis_tile",
			value = t1.ExperienceEmphasisTileInputData.jsonDecode(t21.experienceEmphasisTile)
		}
	end

	if t21.option_selector_carousel ~= nil then
		v493.kind = {
			type = "option_selector_carousel",
			value = t1.OptionSelectorCarouselInputData.jsonDecode(t21.option_selector_carousel)
		}
	end

	if t21.optionSelectorCarousel ~= nil then
		v493.kind = {
			type = "option_selector_carousel",
			value = t1.OptionSelectorCarouselInputData.jsonDecode(t21.optionSelectorCarousel)
		}
	end

	if t21.party_chat_conversation_upsell ~= nil then
		v493.kind = {
			type = "party_chat_conversation_upsell",
			value = t1.PartyChatConversationUpsellInputData.jsonDecode(t21.party_chat_conversation_upsell)
		}
	end

	if t21.partyChatConversationUpsell ~= nil then
		v493.kind = {
			type = "party_chat_conversation_upsell",
			value = t1.PartyChatConversationUpsellInputData.jsonDecode(t21.partyChatConversationUpsell)
		}
	end

	return v493
end

t18.descriptor = {
	name = "PageEntryInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.PageEntryInputData"
}
t1.PageEntryInputData = t18
typeRegistry.default:register(t1.PageEntryInputData)

local t22 = {}

t22.__index = t22

function t22.new(t23: {[any]: any}?) -- line: 5720
	-- upvalues: t22 (copy)
	return (setmetatable({
		section_title = if t23 ~= nil and t23.section_title ~= nil then t23.section_title else "",
		badges = if t23 ~= nil and t23.badges ~= nil then t23.badges else {},
		collection_id = if t23 ~= nil and t23.collection_id ~= nil then t23.collection_id else "",
		collection_position = if t23 ~= nil and t23.collection_position ~= nil then t23.collection_position else "",
		universe_id = if t23 ~= nil and t23.universe_id ~= nil then t23.universe_id else ""
	}, t22))
end
function t22.encode(p16) -- line: 5732
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n11 = 0

	if p16.section_title ~= nil and p16.section_title ~= "" then
		local v498, v499 = proto.writeTag(buf, n11, 1, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeString(v498, v499, p16.section_title)
	end

	if p16.badges ~= nil and #p16.badges > 0 then
		for _, v501 in p16.badges do
			local v502 = v501:encode()
			local v503, v504 = proto.writeTag(buf, n11, 2, proto.wireTypes.lengthDelimited)

			buf, n11 = proto.writeBuffer(v503, v504, v502, buffer.len(v502))
		end
	end

	if p16.collection_id ~= nil and p16.collection_id ~= "" then
		local v505, v506 = proto.writeTag(buf, n11, 3, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeString(v505, v506, p16.collection_id)
	end

	if p16.collection_position ~= nil and p16.collection_position ~= "" then
		local v507, v508 = proto.writeTag(buf, n11, 4, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeString(v507, v508, p16.collection_position)
	end

	if p16.universe_id ~= nil and p16.universe_id ~= "" then
		local v509, v510 = proto.writeTag(buf, n11, 5, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeString(v509, v510, p16.universe_id)
	end

	local buf7 = buffer.create(n11)

	buffer.copy(buf7, 0, buf, 0, n11)

	return buf7
end
function t22.decode(p17: buffer) -- line: 5769
	-- upvalues: t22 (copy), proto (copy), t1 (copy)
	local v513 = t22.new()
	local n12 = 0

	while n12 < buffer.len(p17) do
		local v515, v516

		v515, v516, n12 = proto.readTag(p17, n12)

		if v516 == proto.wireTypes.varint then
			local v517

			v517, n12 = proto.readVarInt(p17, n12)
		elseif v516 == proto.wireTypes.lengthDelimited then
			if v515 == 1 then
				local v518

				v518, n12 = proto.readBuffer(p17, n12)
				v513.section_title = buffer.tostring(v518)
			elseif v515 == 2 then
				local v519

				v519, n12 = proto.readBuffer(p17, n12)
				table.insert(v513.badges, t1.BadgesGridInputData_BadgeInputData.decode(v519))
			elseif v515 == 3 then
				local v520

				v520, n12 = proto.readBuffer(p17, n12)
				v513.collection_id = buffer.tostring(v520)
			elseif v515 == 4 then
				local v521

				v521, n12 = proto.readBuffer(p17, n12)
				v513.collection_position = buffer.tostring(v521)
			elseif v515 == 5 then
				local v522

				v522, n12 = proto.readBuffer(p17, n12)
				v513.universe_id = buffer.tostring(v522)
			else
				local v523, v524 = proto.readVarInt(p17, n12)

				n12 = v524 + v523
			end
		elseif v516 == proto.wireTypes.i32 then
			local v525

			v525, n12 = proto.readFixed32(p17, n12)
		elseif v516 == proto.wireTypes.i64 then
			local v526

			v526, n12 = proto.readFixed64(p17, n12)
		else
			error("Unsupported wire type: " .. v516)
		end
	end

	return v513
end
function t22.jsonEncode(p18) -- line: 5832
	local t24 = {}

	if p18.section_title ~= nil and p18.section_title ~= "" then
		t24.sectionTitle = p18.section_title
	end

	if p18.badges ~= nil and #p18.badges > 0 then
		local t25 = {}

		for _, v531 in p18.badges do
			table.insert(t25, v531:jsonEncode())
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
function t22.jsonDecode(t26: {[any]: any}) -- line: 5862
	-- upvalues: t22 (copy), t1 (copy)
	local v533 = t22.new()

	if t26.section_title ~= nil then
		v533.section_title = t26.section_title
	end

	if t26.sectionTitle ~= nil then
		v533.section_title = t26.sectionTitle
	end

	if t26.badges ~= nil then
		local t27 = {}

		for _, v536 in t26.badges do
			table.insert(t27, t1.BadgesGridInputData_BadgeInputData.jsonDecode(v536))
		end

		v533.badges = t27
	end

	if t26.collection_id ~= nil then
		v533.collection_id = t26.collection_id
	end

	if t26.collectionId ~= nil then
		v533.collection_id = t26.collectionId
	end

	if t26.collection_position ~= nil then
		v533.collection_position = t26.collection_position
	end

	if t26.collectionPosition ~= nil then
		v533.collection_position = t26.collectionPosition
	end

	if t26.universe_id ~= nil then
		v533.universe_id = t26.universe_id
	end

	if t26.universeId ~= nil then
		v533.universe_id = t26.universeId
	end

	return v533
end

t22.descriptor = {
	name = "BadgesGridInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.BadgesGridInputData"
}
t1.BadgesGridInputData = t22
typeRegistry.default:register(t1.BadgesGridInputData)

local t28 = {}

t28.__index = t28

function t28.new(t29: {[any]: any}?) -- line: 5923
	-- upvalues: t28 (copy)
	return (setmetatable({
		badge_id = if t29 ~= nil and t29.badge_id ~= nil then t29.badge_id else ""
	}, t28))
end
function t28.encode(p19) -- line: 5931
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n13 = 0

	if p19.badge_id ~= nil and p19.badge_id ~= "" then
		local v541, v542 = proto.writeTag(buf, n13, 1, proto.wireTypes.lengthDelimited)

		buf, n13 = proto.writeString(v541, v542, p19.badge_id)
	end

	local buf8 = buffer.create(n13)

	buffer.copy(buf8, 0, buf, 0, n13)

	return buf8
end
function t28.decode(p20: buffer) -- line: 5945
	-- upvalues: t28 (copy), proto (copy)
	local v545 = t28.new()
	local n14 = 0

	while n14 < buffer.len(p20) do
		local v547, v548

		v547, v548, n14 = proto.readTag(p20, n14)

		if v548 == proto.wireTypes.varint then
			local v549

			v549, n14 = proto.readVarInt(p20, n14)
		elseif v548 == proto.wireTypes.lengthDelimited then
			if v547 == 1 then
				local v550

				v550, n14 = proto.readBuffer(p20, n14)
				v545.badge_id = buffer.tostring(v550)
			else
				local v551, v552 = proto.readVarInt(p20, n14)

				n14 = v552 + v551
			end
		elseif v548 == proto.wireTypes.i32 then
			local v553

			v553, n14 = proto.readFixed32(p20, n14)
		elseif v548 == proto.wireTypes.i64 then
			local v554

			v554, n14 = proto.readFixed64(p20, n14)
		else
			error("Unsupported wire type: " .. v548)
		end
	end

	return v545
end
function t28.jsonEncode(p21) -- line: 5988
	local t30 = {}

	if p21.badge_id ~= nil and p21.badge_id ~= "" then
		t30.badgeId = p21.badge_id
	end

	return t30
end
function t28.jsonDecode(t31: {[any]: any}) -- line: 5998
	-- upvalues: t28 (copy)
	local v558 = t28.new()

	if t31.badge_id ~= nil then
		v558.badge_id = t31.badge_id
	end

	if t31.badgeId ~= nil then
		v558.badge_id = t31.badgeId
	end

	return v558
end

t28.descriptor = {
	name = "BadgesGridInputData_BadgeInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.BadgeInputData"
}
t1.BadgesGridInputData_BadgeInputData = t28
typeRegistry.default:register(t1.BadgesGridInputData_BadgeInputData)

local t32 = {}

t32.__index = t32

function t32.new(t33: {[any]: any}?) -- line: 6028
	-- upvalues: t32 (copy)
	return (setmetatable({
		badge_id = if t33 ~= nil and t33.badge_id ~= nil then t33.badge_id else "",
		universe_id = if t33 ~= nil and t33.universe_id ~= nil then t33.universe_id else "",
		localized_literals = if t33 ~= nil and t33.localized_literals ~= nil then t33.localized_literals else nil,
		creator_key = if t33 ~= nil and t33.creator_key ~= nil then t33.creator_key else ""
	}, t32))
end
function t32.encode(p22) -- line: 6037
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n15 = 0

	if p22.badge_id ~= nil and p22.badge_id ~= "" then
		local v563, v564 = proto.writeTag(buf, n15, 1, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeString(v563, v564, p22.badge_id)
	end

	if p22.universe_id ~= nil and p22.universe_id ~= "" then
		local v565, v566 = proto.writeTag(buf, n15, 2, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeString(v565, v566, p22.universe_id)
	end

	if p22.localized_literals ~= nil then
		local v567 = p22.localized_literals:encode()
		local v568, v569 = proto.writeTag(buf, n15, 3, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeBuffer(v568, v569, v567, buffer.len(v567))
	end

	if p22.creator_key ~= nil and p22.creator_key ~= "" then
		local v570, v571 = proto.writeTag(buf, n15, 4, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeString(v570, v571, p22.creator_key)
	end

	local buf9 = buffer.create(n15)

	buffer.copy(buf9, 0, buf, 0, n15)

	return buf9
end
function t32.decode(p23: buffer) -- line: 6067
	-- upvalues: t32 (copy), proto (copy), t1 (copy)
	local v574 = t32.new()
	local n16 = 0

	while n16 < buffer.len(p23) do
		local v576, v577

		v576, v577, n16 = proto.readTag(p23, n16)

		if v577 == proto.wireTypes.varint then
			local v578

			v578, n16 = proto.readVarInt(p23, n16)
		elseif v577 == proto.wireTypes.lengthDelimited then
			if v576 == 1 then
				local v579

				v579, n16 = proto.readBuffer(p23, n16)
				v574.badge_id = buffer.tostring(v579)
			elseif v576 == 2 then
				local v580

				v580, n16 = proto.readBuffer(p23, n16)
				v574.universe_id = buffer.tostring(v580)
			elseif v576 == 3 then
				local v581

				v581, n16 = proto.readBuffer(p23, n16)
				v574.localized_literals = t1.BadgeDetailsInputData_LocalizedLiterals.decode(v581)
			elseif v576 == 4 then
				local v582

				v582, n16 = proto.readBuffer(p23, n16)
				v574.creator_key = buffer.tostring(v582)
			else
				local v583, v584 = proto.readVarInt(p23, n16)

				n16 = v584 + v583
			end
		elseif v577 == proto.wireTypes.i32 then
			local v585

			v585, n16 = proto.readFixed32(p23, n16)
		elseif v577 == proto.wireTypes.i64 then
			local v586

			v586, n16 = proto.readFixed64(p23, n16)
		else
			error("Unsupported wire type: " .. v577)
		end
	end

	return v574
end
function t32.jsonEncode(p24) -- line: 6125
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
function t32.jsonDecode(t35: {[any]: any}) -- line: 6147
	-- upvalues: t32 (copy), t1 (copy)
	local v590 = t32.new()

	if t35.badge_id ~= nil then
		v590.badge_id = t35.badge_id
	end

	if t35.badgeId ~= nil then
		v590.badge_id = t35.badgeId
	end

	if t35.universe_id ~= nil then
		v590.universe_id = t35.universe_id
	end

	if t35.universeId ~= nil then
		v590.universe_id = t35.universeId
	end

	if t35.localized_literals ~= nil then
		v590.localized_literals = t1.BadgeDetailsInputData_LocalizedLiterals.jsonDecode(t35.localized_literals)
	end

	if t35.localizedLiterals ~= nil then
		v590.localized_literals = t1.BadgeDetailsInputData_LocalizedLiterals.jsonDecode(t35.localizedLiterals)
	end

	if t35.creator_key ~= nil then
		v590.creator_key = t35.creator_key
	end

	if t35.creatorKey ~= nil then
		v590.creator_key = t35.creatorKey
	end

	return v590
end

t32.descriptor = {
	name = "BadgeDetailsInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.BadgeDetailsInputData"
}
t1.BadgeDetailsInputData = t32
typeRegistry.default:register(t1.BadgeDetailsInputData)

local t36 = {}

t36.__index = t36

function t36.new(t37: {[any]: any}?) -- line: 6201
	-- upvalues: t36 (copy)
	return (setmetatable({
		info_table = if t37 ~= nil and t37.info_table ~= nil then t37.info_table else nil,
		action_module = if t37 ~= nil and t37.action_module ~= nil then t37.action_module else nil,
		overflow_menu = if t37 ~= nil and t37.overflow_menu ~= nil then t37.overflow_menu else nil
	}, t36))
end
function t36.encode(p25) -- line: 6211
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n17 = 0

	if p25.info_table ~= nil then
		local v595 = p25.info_table:encode()
		local v596, v597 = proto.writeTag(buf, n17, 1, proto.wireTypes.lengthDelimited)

		buf, n17 = proto.writeBuffer(v596, v597, v595, buffer.len(v595))
	end

	if p25.action_module ~= nil then
		local v598 = p25.action_module:encode()
		local v599, v600 = proto.writeTag(buf, n17, 2, proto.wireTypes.lengthDelimited)

		buf, n17 = proto.writeBuffer(v599, v600, v598, buffer.len(v598))
	end

	if p25.overflow_menu ~= nil then
		local v601 = p25.overflow_menu:encode()
		local v602, v603 = proto.writeTag(buf, n17, 3, proto.wireTypes.lengthDelimited)

		buf, n17 = proto.writeBuffer(v602, v603, v601, buffer.len(v601))
	end

	local buf10 = buffer.create(n17)

	buffer.copy(buf10, 0, buf, 0, n17)

	return buf10
end
function t36.decode(p26: buffer) -- line: 6238
	-- upvalues: t36 (copy), proto (copy), t1 (copy)
	local v606 = t36.new()
	local n18 = 0

	while n18 < buffer.len(p26) do
		local v608, v609

		v608, v609, n18 = proto.readTag(p26, n18)

		if v609 == proto.wireTypes.varint then
			local v610

			v610, n18 = proto.readVarInt(p26, n18)
		elseif v609 == proto.wireTypes.lengthDelimited then
			if v608 == 1 then
				local v611

				v611, n18 = proto.readBuffer(p26, n18)
				v606.info_table = t1.BadgeDetailsInputData_LocalizedLiterals_InfoTable.decode(v611)
			elseif v608 == 2 then
				local v612

				v612, n18 = proto.readBuffer(p26, n18)
				v606.action_module = t1.BadgeDetailsInputData_LocalizedLiterals_ActionModule.decode(v612)
			elseif v608 == 3 then
				local v613

				v613, n18 = proto.readBuffer(p26, n18)
				v606.overflow_menu = t1.BadgeDetailsInputData_LocalizedLiterals_OverflowMenu.decode(v613)
			else
				local v614, v615 = proto.readVarInt(p26, n18)

				n18 = v615 + v614
			end
		elseif v609 == proto.wireTypes.i32 then
			local v616

			v616, n18 = proto.readFixed32(p26, n18)
		elseif v609 == proto.wireTypes.i64 then
			local v617

			v617, n18 = proto.readFixed64(p26, n18)
		else
			error("Unsupported wire type: " .. v609)
		end
	end

	return v606
end
function t36.jsonEncode(p27) -- line: 6291
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
function t36.jsonDecode(t39: {[any]: any}) -- line: 6309
	-- upvalues: t36 (copy), t1 (copy)
	local v621 = t36.new()

	if t39.info_table ~= nil then
		v621.info_table = t1.BadgeDetailsInputData_LocalizedLiterals_InfoTable.jsonDecode(t39.info_table)
	end

	if t39.infoTable ~= nil then
		v621.info_table = t1.BadgeDetailsInputData_LocalizedLiterals_InfoTable.jsonDecode(t39.infoTable)
	end

	if t39.action_module ~= nil then
		v621.action_module = t1.BadgeDetailsInputData_LocalizedLiterals_ActionModule.jsonDecode(t39.action_module)
	end

	if t39.actionModule ~= nil then
		v621.action_module = t1.BadgeDetailsInputData_LocalizedLiterals_ActionModule.jsonDecode(t39.actionModule)
	end

	if t39.overflow_menu ~= nil then
		v621.overflow_menu = t1.BadgeDetailsInputData_LocalizedLiterals_OverflowMenu.jsonDecode(t39.overflow_menu)
	end

	if t39.overflowMenu ~= nil then
		v621.overflow_menu = t1.BadgeDetailsInputData_LocalizedLiterals_OverflowMenu.jsonDecode(t39.overflowMenu)
	end

	return v621
end

t36.descriptor = {
	name = "BadgeDetailsInputData_LocalizedLiterals",
	fullName = "roblox.apppageplatform.shared.v1beta1.LocalizedLiterals"
}
t1.BadgeDetailsInputData_LocalizedLiterals = t36
typeRegistry.default:register(t1.BadgeDetailsInputData_LocalizedLiterals)

local t40 = {}

t40.__index = t40

function t40.new(t41: {[any]: any}?) -- line: 6360
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
function t40.encode(p28) -- line: 6379
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n19 = 0

	if p28.type_label ~= nil and p28.type_label ~= "" then
		local v626, v627 = proto.writeTag(buf, n19, 1, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeString(v626, v627, p28.type_label)
	end

	if p28.earned_label ~= nil and p28.earned_label ~= "" then
		local v628, v629 = proto.writeTag(buf, n19, 2, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeString(v628, v629, p28.earned_label)
	end

	if p28.updated_label ~= nil and p28.updated_label ~= "" then
		local v630, v631 = proto.writeTag(buf, n19, 3, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeString(v630, v631, p28.updated_label)
	end

	if p28.experience_label ~= nil and p28.experience_label ~= "" then
		local v632, v633 = proto.writeTag(buf, n19, 4, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeString(v632, v633, p28.experience_label)
	end

	if p28.rarity_label ~= nil and p28.rarity_label ~= "" then
		local v634, v635 = proto.writeTag(buf, n19, 5, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeString(v634, v635, p28.rarity_label)
	end

	if p28.won_yesterday_label ~= nil and p28.won_yesterday_label ~= "" then
		local v636, v637 = proto.writeTag(buf, n19, 6, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeString(v636, v637, p28.won_yesterday_label)
	end

	if p28.won_ever_label ~= nil and p28.won_ever_label ~= "" then
		local v638, v639 = proto.writeTag(buf, n19, 7, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeString(v638, v639, p28.won_ever_label)
	end

	local buf11 = buffer.create(n19)

	buffer.copy(buf11, 0, buf, 0, n19)

	return buf11
end
function t40.decode(p29: buffer) -- line: 6425
	-- upvalues: t40 (copy), proto (copy)
	local v642 = t40.new()
	local n20 = 0

	while n20 < buffer.len(p29) do
		local v644, v645

		v644, v645, n20 = proto.readTag(p29, n20)

		if v645 == proto.wireTypes.varint then
			local v646

			v646, n20 = proto.readVarInt(p29, n20)
		elseif v645 == proto.wireTypes.lengthDelimited then
			if v644 == 1 then
				local v647

				v647, n20 = proto.readBuffer(p29, n20)
				v642.type_label = buffer.tostring(v647)
			elseif v644 == 2 then
				local v648

				v648, n20 = proto.readBuffer(p29, n20)
				v642.earned_label = buffer.tostring(v648)
			elseif v644 == 3 then
				local v649

				v649, n20 = proto.readBuffer(p29, n20)
				v642.updated_label = buffer.tostring(v649)
			elseif v644 == 4 then
				local v650

				v650, n20 = proto.readBuffer(p29, n20)
				v642.experience_label = buffer.tostring(v650)
			elseif v644 == 5 then
				local v651

				v651, n20 = proto.readBuffer(p29, n20)
				v642.rarity_label = buffer.tostring(v651)
			elseif v644 == 6 then
				local v652

				v652, n20 = proto.readBuffer(p29, n20)
				v642.won_yesterday_label = buffer.tostring(v652)
			elseif v644 == 7 then
				local v653

				v653, n20 = proto.readBuffer(p29, n20)
				v642.won_ever_label = buffer.tostring(v653)
			else
				local v654, v655 = proto.readVarInt(p29, n20)

				n20 = v655 + v654
			end
		elseif v645 == proto.wireTypes.i32 then
			local v656

			v656, n20 = proto.readFixed32(p29, n20)
		elseif v645 == proto.wireTypes.i64 then
			local v657

			v657, n20 = proto.readFixed64(p29, n20)
		else
			error("Unsupported wire type: " .. v645)
		end
	end

	return v642
end
function t40.jsonEncode(p30) -- line: 6500
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
function t40.jsonDecode(t43: {[any]: any}) -- line: 6536
	-- upvalues: t40 (copy)
	local v661 = t40.new()

	if t43.type_label ~= nil then
		v661.type_label = t43.type_label
	end

	if t43.typeLabel ~= nil then
		v661.type_label = t43.typeLabel
	end

	if t43.earned_label ~= nil then
		v661.earned_label = t43.earned_label
	end

	if t43.earnedLabel ~= nil then
		v661.earned_label = t43.earnedLabel
	end

	if t43.updated_label ~= nil then
		v661.updated_label = t43.updated_label
	end

	if t43.updatedLabel ~= nil then
		v661.updated_label = t43.updatedLabel
	end

	if t43.experience_label ~= nil then
		v661.experience_label = t43.experience_label
	end

	if t43.experienceLabel ~= nil then
		v661.experience_label = t43.experienceLabel
	end

	if t43.rarity_label ~= nil then
		v661.rarity_label = t43.rarity_label
	end

	if t43.rarityLabel ~= nil then
		v661.rarity_label = t43.rarityLabel
	end

	if t43.won_yesterday_label ~= nil then
		v661.won_yesterday_label = t43.won_yesterday_label
	end

	if t43.wonYesterdayLabel ~= nil then
		v661.won_yesterday_label = t43.wonYesterdayLabel
	end

	if t43.won_ever_label ~= nil then
		v661.won_ever_label = t43.won_ever_label
	end

	if t43.wonEverLabel ~= nil then
		v661.won_ever_label = t43.wonEverLabel
	end

	return v661
end

t40.descriptor = {
	name = "BadgeDetailsInputData_LocalizedLiterals_InfoTable",
	fullName = "roblox.apppageplatform.shared.v1beta1.InfoTable"
}
t1.BadgeDetailsInputData_LocalizedLiterals_InfoTable = t40
typeRegistry.default:register(t1.BadgeDetailsInputData_LocalizedLiterals_InfoTable)

local t44 = {}

t44.__index = t44

function t44.new(t45: {[any]: any}?) -- line: 6616
	-- upvalues: t44 (copy)
	return (setmetatable({
		share = if t45 ~= nil and t45.share ~= nil then t45.share else "",
		report = if t45 ~= nil and t45.report ~= nil then t45.report else ""
	}, t44))
end
function t44.encode(p31) -- line: 6628
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n21 = 0

	if p31.share ~= nil and p31.share ~= "" then
		local v666, v667 = proto.writeTag(buf, n21, 1, proto.wireTypes.lengthDelimited)

		buf, n21 = proto.writeString(v666, v667, p31.share)
	end

	if p31.report ~= nil and p31.report ~= "" then
		local v668, v669 = proto.writeTag(buf, n21, 2, proto.wireTypes.lengthDelimited)

		buf, n21 = proto.writeString(v668, v669, p31.report)
	end

	local buf12 = buffer.create(n21)

	buffer.copy(buf12, 0, buf, 0, n21)

	return buf12
end
function t44.decode(p32: buffer) -- line: 6649
	-- upvalues: t44 (copy), proto (copy)
	local v672 = t44.new()
	local n22 = 0

	while n22 < buffer.len(p32) do
		local v674, v675

		v674, v675, n22 = proto.readTag(p32, n22)

		if v675 == proto.wireTypes.varint then
			local v676

			v676, n22 = proto.readVarInt(p32, n22)
		elseif v675 == proto.wireTypes.lengthDelimited then
			if v674 == 1 then
				local v677

				v677, n22 = proto.readBuffer(p32, n22)
				v672.share = buffer.tostring(v677)
			elseif v674 == 2 then
				local v678

				v678, n22 = proto.readBuffer(p32, n22)
				v672.report = buffer.tostring(v678)
			else
				local v679, v680 = proto.readVarInt(p32, n22)

				n22 = v680 + v679
			end
		elseif v675 == proto.wireTypes.i32 then
			local v681

			v681, n22 = proto.readFixed32(p32, n22)
		elseif v675 == proto.wireTypes.i64 then
			local v682

			v682, n22 = proto.readFixed64(p32, n22)
		else
			error("Unsupported wire type: " .. v675)
		end
	end

	return v672
end
function t44.jsonEncode(p33) -- line: 6699
	local t46 = {}

	if p33.share ~= nil and p33.share ~= "" then
		t46.share = p33.share
	end

	if p33.report ~= nil and p33.report ~= "" then
		t46.report = p33.report
	end

	return t46
end
function t44.jsonDecode(t47: {[any]: any}) -- line: 6715
	-- upvalues: t44 (copy)
	local v686 = t44.new()

	if t47.share ~= nil then
		v686.share = t47.share
	end

	if t47.report ~= nil then
		v686.report = t47.report
	end

	return v686
end

t44.descriptor = {
	name = "BadgeDetailsInputData_LocalizedLiterals_ActionModule",
	fullName = "roblox.apppageplatform.shared.v1beta1.ActionModule"
}
t1.BadgeDetailsInputData_LocalizedLiterals_ActionModule = t44
typeRegistry.default:register(t1.BadgeDetailsInputData_LocalizedLiterals_ActionModule)

local t48 = {}

t48.__index = t48

function t48.new(t49: {[any]: any}?) -- line: 6747
	-- upvalues: t48 (copy)
	return (setmetatable({
		report = if t49 ~= nil and t49.report ~= nil then t49.report else "",
		remove = if t49 ~= nil and t49.remove ~= nil then t49.remove else ""
	}, t48))
end
function t48.encode(p34) -- line: 6759
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n23 = 0

	if p34.report ~= nil and p34.report ~= "" then
		local v691, v692 = proto.writeTag(buf, n23, 1, proto.wireTypes.lengthDelimited)

		buf, n23 = proto.writeString(v691, v692, p34.report)
	end

	if p34.remove ~= nil and p34.remove ~= "" then
		local v693, v694 = proto.writeTag(buf, n23, 2, proto.wireTypes.lengthDelimited)

		buf, n23 = proto.writeString(v693, v694, p34.remove)
	end

	local buf13 = buffer.create(n23)

	buffer.copy(buf13, 0, buf, 0, n23)

	return buf13
end
function t48.decode(p35: buffer) -- line: 6780
	-- upvalues: t48 (copy), proto (copy)
	local v697 = t48.new()
	local n24 = 0

	while n24 < buffer.len(p35) do
		local v699, v700

		v699, v700, n24 = proto.readTag(p35, n24)

		if v700 == proto.wireTypes.varint then
			local v701

			v701, n24 = proto.readVarInt(p35, n24)
		elseif v700 == proto.wireTypes.lengthDelimited then
			if v699 == 1 then
				local v702

				v702, n24 = proto.readBuffer(p35, n24)
				v697.report = buffer.tostring(v702)
			elseif v699 == 2 then
				local v703

				v703, n24 = proto.readBuffer(p35, n24)
				v697.remove = buffer.tostring(v703)
			else
				local v704, v705 = proto.readVarInt(p35, n24)

				n24 = v705 + v704
			end
		elseif v700 == proto.wireTypes.i32 then
			local v706

			v706, n24 = proto.readFixed32(p35, n24)
		elseif v700 == proto.wireTypes.i64 then
			local v707

			v707, n24 = proto.readFixed64(p35, n24)
		else
			error("Unsupported wire type: " .. v700)
		end
	end

	return v697
end
function t48.jsonEncode(p36) -- line: 6830
	local t50 = {}

	if p36.report ~= nil and p36.report ~= "" then
		t50.report = p36.report
	end

	if p36.remove ~= nil and p36.remove ~= "" then
		t50.remove = p36.remove
	end

	return t50
end
function t48.jsonDecode(t51: {[any]: any}) -- line: 6846
	-- upvalues: t48 (copy)
	local v711 = t48.new()

	if t51.report ~= nil then
		v711.report = t51.report
	end

	if t51.remove ~= nil then
		v711.remove = t51.remove
	end

	return v711
end

t48.descriptor = {
	name = "BadgeDetailsInputData_LocalizedLiterals_OverflowMenu",
	fullName = "roblox.apppageplatform.shared.v1beta1.OverflowMenu"
}
t1.BadgeDetailsInputData_LocalizedLiterals_OverflowMenu = t48
typeRegistry.default:register(t1.BadgeDetailsInputData_LocalizedLiterals_OverflowMenu)

local t52 = {}

t52.__index = t52

function t52.new(_: {[any]: any}?) -- line: 6877
	-- upvalues: t52 (copy)
	return (setmetatable({}, t52))
end
function t52.encode(_) -- line: 6881
	local buf = buffer.create(0)
	local buf14 = buffer.create(0)

	buffer.copy(buf14, 0, buf, 0, 0)

	return buf14
end
function t52.decode(p38: buffer) -- line: 6890
	-- upvalues: t52 (copy), proto (copy)
	local v717 = t52.new()
	local n25 = 0

	while n25 < buffer.len(p38) do
		local v719, v720

		v719, v720, n25 = proto.readTag(p38, n25)

		if v720 == proto.wireTypes.varint then
			local v721

			v721, n25 = proto.readVarInt(p38, n25)
		elseif v720 == proto.wireTypes.lengthDelimited then
			local v722, v723 = proto.readVarInt(p38, n25)

			n25 = v723 + v722
		elseif v720 == proto.wireTypes.i32 then
			local v724

			v724, n25 = proto.readFixed32(p38, n25)
		elseif v720 == proto.wireTypes.i64 then
			local v725

			v725, n25 = proto.readFixed64(p38, n25)
		else
			error("Unsupported wire type: " .. v720)
		end
	end

	return v717
end
function t52.jsonEncode(_) -- line: 6928
	return {}
end
function t52.jsonDecode(_: {[any]: any}) -- line: 6934
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

function t55.new(t56: {[any]: any}?) -- line: 6954
	-- upvalues: t55 (copy)
	return (setmetatable({
		universe_id = if t56 ~= nil and t56.universe_id ~= nil then t56.universe_id else "",
		creator_key = if t56 ~= nil and t56.creator_key ~= nil then t56.creator_key else "",
		entry_map = if t56 ~= nil and t56.entry_map ~= nil then t56.entry_map else {},
		entry_order = if t56 ~= nil and t56.entry_order ~= nil then t56.entry_order else {},
		entry_order_map = if t56 ~= nil and t56.entry_order_map ~= nil then t56.entry_order_map else {}
	}, t55))
end
function t55.encode(p40) -- line: 6966
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n26 = 0

	if p40.universe_id ~= nil and p40.universe_id ~= "" then
		local v732, v733 = proto.writeTag(buf, n26, 1, proto.wireTypes.lengthDelimited)

		buf, n26 = proto.writeString(v732, v733, p40.universe_id)
	end

	if p40.creator_key ~= nil and p40.creator_key ~= "" then
		local v734, v735 = proto.writeTag(buf, n26, 2, proto.wireTypes.lengthDelimited)

		buf, n26 = proto.writeString(v734, v735, p40.creator_key)
	end

	if p40.entry_map ~= nil and next(p40.entry_map) ~= nil then
		for v736, v737 in p40.entry_map do
			local buf15 = buffer.create(0)
			local v739, v740 = proto.writeTag(buf15, 0, 1, proto.wireTypes.lengthDelimited)
			local v741, v742 = proto.writeString(v739, v740, v736)
			local v743 = v737:encode()
			local v744, v745 = proto.writeTag(v741, v742, 2, proto.wireTypes.lengthDelimited)
			local v746, v747 = proto.writeBuffer(v744, v745, v743, buffer.len(v743))
			local v748, v749 = proto.writeTag(buf, n26, 3, proto.wireTypes.lengthDelimited)

			buf, n26 = proto.writeBuffer(v748, v749, v746, v747)
		end
	end

	if p40.entry_order ~= nil and #p40.entry_order > 0 then
		for _, v751 in p40.entry_order do
			local v752, v753 = proto.writeTag(buf, n26, 4, proto.wireTypes.lengthDelimited)

			buf, n26 = proto.writeString(v752, v753, v751)
		end
	end

	if p40.entry_order_map ~= nil and next(p40.entry_order_map) ~= nil then
		for v754, v755 in p40.entry_order_map do
			local buf16 = buffer.create(0)
			local v757, v758 = proto.writeTag(buf16, 0, 1, proto.wireTypes.lengthDelimited)
			local v759, v760 = proto.writeString(v757, v758, v754)
			local v761 = v755:encode()
			local v762, v763 = proto.writeTag(v759, v760, 2, proto.wireTypes.lengthDelimited)
			local v764, v765 = proto.writeBuffer(v762, v763, v761, buffer.len(v761))
			local v766, v767 = proto.writeTag(buf, n26, 5, proto.wireTypes.lengthDelimited)

			buf, n26 = proto.writeBuffer(v766, v767, v764, v765)
		end
	end

	local buf17 = buffer.create(n26)

	buffer.copy(buf17, 0, buf, 0, n26)

	return buf17
end
function t55.decode(p41: buffer) -- line: 7020
	-- upvalues: t55 (copy), proto (copy), t1 (copy)
	local v770 = t55.new()
	local n27 = 0

	while n27 < buffer.len(p41) do
		local v772, v773

		v772, v773, n27 = proto.readTag(p41, n27)

		if v773 == proto.wireTypes.varint then
			local v774

			v774, n27 = proto.readVarInt(p41, n27)
		elseif v773 == proto.wireTypes.lengthDelimited then
			if v772 == 1 then
				local v775

				v775, n27 = proto.readBuffer(p41, n27)
				v770.universe_id = buffer.tostring(v775)
			elseif v772 == 2 then
				local v776

				v776, n27 = proto.readBuffer(p41, n27)
				v770.creator_key = buffer.tostring(v776)
			elseif v772 == 3 then
				local v777

				v777, n27 = proto.readBuffer(p41, n27)

				local v778 = t1.ExperienceDetailsFeedInputData_EntryMapEntry.decode(v777)
				local v779 = t1.FeedEntry.new()

				v770.entry_map[v778.key or ""] = v778.value or v779
			elseif v772 == 4 then
				local v780

				v780, n27 = proto.readBuffer(p41, n27)
				table.insert(v770.entry_order, buffer.tostring(v780))
			elseif v772 == 5 then
				local v781

				v781, n27 = proto.readBuffer(p41, n27)

				local v782 = t1.ExperienceDetailsFeedInputData_EntryOrderMapEntry.decode(v781)
				local v783 = t1.EntryOrder.new()

				v770.entry_order_map[v782.key or ""] = v782.value or v783
			else
				local v784, v785 = proto.readVarInt(p41, n27)

				n27 = v785 + v784
			end
		elseif v773 == proto.wireTypes.i32 then
			local v786

			v786, n27 = proto.readFixed32(p41, n27)
		elseif v773 == proto.wireTypes.i64 then
			local v787

			v787, n27 = proto.readFixed64(p41, n27)
		else
			error("Unsupported wire type: " .. v773)
		end
	end

	return v770
end
function t55.jsonEncode(p42) -- line: 7097
	local t57 = {}

	if p42.universe_id ~= nil and p42.universe_id ~= "" then
		t57.universeId = p42.universe_id
	end

	if p42.creator_key ~= nil and p42.creator_key ~= "" then
		t57.creatorKey = p42.creator_key
	end

	if p42.entry_map ~= nil and next(p42.entry_map) ~= nil then
		local t58 = {}

		for v791, v792 in p42.entry_map do
			t58[v791] = v792:jsonEncode()
		end

		t57.entryMap = t58
	end

	if p42.entry_order ~= nil and #p42.entry_order > 0 then
		local t59 = {}

		for _, v795 in p42.entry_order do
			table.insert(t59, v795)
		end

		t57.entryOrder = t59
	end

	if p42.entry_order_map ~= nil and next(p42.entry_order_map) ~= nil then
		local t60 = {}

		for v797, v798 in p42.entry_order_map do
			t60[v797] = v798:jsonEncode()
		end

		t57.entryOrderMap = t60
	end

	return t57
end
function t55.jsonDecode(t61: {[any]: any}) -- line: 7135
	-- upvalues: t55 (copy), t1 (copy)
	local v800 = t55.new()

	if t61.universe_id ~= nil then
		v800.universe_id = t61.universe_id
	end

	if t61.universeId ~= nil then
		v800.universe_id = t61.universeId
	end

	if t61.creator_key ~= nil then
		v800.creator_key = t61.creator_key
	end

	if t61.creatorKey ~= nil then
		v800.creator_key = t61.creatorKey
	end

	if t61.entry_map ~= nil then
		local t62 = {}

		for v802, v803 in t61.entry_map do
			t62[v802] = t1.FeedEntry.jsonDecode(v803)
		end

		v800.entry_map = t62
	end

	if t61.entryMap ~= nil then
		local t63 = {}

		for v805, v806 in t61.entryMap do
			t63[v805] = t1.FeedEntry.jsonDecode(v806)
		end

		v800.entry_map = t63
	end

	if t61.entry_order ~= nil then
		local t64 = {}

		for _, v809 in t61.entry_order do
			table.insert(t64, v809)
		end

		v800.entry_order = t64
	end

	if t61.entryOrder ~= nil then
		local t65 = {}

		for _, v812 in t61.entryOrder do
			table.insert(t65, v812)
		end

		v800.entry_order = t65
	end

	if t61.entry_order_map ~= nil then
		local t66 = {}

		for v814, v815 in t61.entry_order_map do
			t66[v814] = t1.EntryOrder.jsonDecode(v815)
		end

		v800.entry_order_map = t66
	end

	if t61.entryOrderMap ~= nil then
		local t67 = {}

		for v817, v818 in t61.entryOrderMap do
			t67[v817] = t1.EntryOrder.jsonDecode(v818)
		end

		v800.entry_order_map = t67
	end

	return v800
end

t55.descriptor = {
	name = "ExperienceDetailsFeedInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceDetailsFeedInputData"
}
t1.ExperienceDetailsFeedInputData = t55
typeRegistry.default:register(t1.ExperienceDetailsFeedInputData)

local t68 = {}

t68.__index = t68

function t68.new(t69: {[any]: any}?) -- line: 7225
	-- upvalues: t68 (copy)
	return (setmetatable({
		key = if t69 ~= nil and t69.key ~= nil then t69.key else "",
		value = if t69 ~= nil and t69.value ~= nil then t69.value else nil
	}, t68))
end
function t68.encode(p43) -- line: 7234
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n28 = 0

	if p43.key ~= nil and p43.key ~= "" then
		local v823, v824 = proto.writeTag(buf, n28, 1, proto.wireTypes.lengthDelimited)

		buf, n28 = proto.writeString(v823, v824, p43.key)
	end

	if p43.value ~= nil then
		local v825 = p43.value:encode()
		local v826, v827 = proto.writeTag(buf, n28, 2, proto.wireTypes.lengthDelimited)

		buf, n28 = proto.writeBuffer(v826, v827, v825, buffer.len(v825))
	end

	local buf18 = buffer.create(n28)

	buffer.copy(buf18, 0, buf, 0, n28)

	return buf18
end
function t68.decode(p44: buffer) -- line: 7256
	-- upvalues: t68 (copy), proto (copy), t1 (copy)
	local v830 = t68.new()
	local n29 = 0

	while n29 < buffer.len(p44) do
		local v832, v833

		v832, v833, n29 = proto.readTag(p44, n29)

		if v833 == proto.wireTypes.varint then
			local v834

			v834, n29 = proto.readVarInt(p44, n29)
		elseif v833 == proto.wireTypes.lengthDelimited then
			if v832 == 1 then
				local v835

				v835, n29 = proto.readBuffer(p44, n29)
				v830.key = buffer.tostring(v835)
			elseif v832 == 2 then
				local v836

				v836, n29 = proto.readBuffer(p44, n29)
				v830.value = t1.FeedEntry.decode(v836)
			else
				local v837, v838 = proto.readVarInt(p44, n29)

				n29 = v838 + v837
			end
		elseif v833 == proto.wireTypes.i32 then
			local v839

			v839, n29 = proto.readFixed32(p44, n29)
		elseif v833 == proto.wireTypes.i64 then
			local v840

			v840, n29 = proto.readFixed64(p44, n29)
		else
			error("Unsupported wire type: " .. v833)
		end
	end

	return v830
end
function t68.jsonEncode(p45) -- line: 7306
	local t70 = {}

	if p45.key ~= nil and p45.key ~= "" then
		t70.key = p45.key
	end

	if p45.value ~= nil then
		t70.value = p45.value:jsonEncode()
	end

	return t70
end
function t68.jsonDecode(t71: {[any]: any}) -- line: 7322
	-- upvalues: t68 (copy), t1 (copy)
	local v844 = t68.new()

	if t71.key ~= nil then
		v844.key = t71.key
	end

	if t71.value ~= nil then
		v844.value = t1.FeedEntry.jsonDecode(t71.value)
	end

	return v844
end

t68.descriptor = {
	name = "ExperienceDetailsFeedInputData_EntryMapEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryMapEntry"
}
t1.ExperienceDetailsFeedInputData_EntryMapEntry = t68
typeRegistry.default:register(t1.ExperienceDetailsFeedInputData_EntryMapEntry)

local t72 = {}

t72.__index = t72

function t72.new(t73: {[any]: any}?) -- line: 7353
	-- upvalues: t72 (copy)
	return (setmetatable({
		key = if t73 ~= nil and t73.key ~= nil then t73.key else "",
		value = if t73 ~= nil and t73.value ~= nil then t73.value else nil
	}, t72))
end
function t72.encode(p46) -- line: 7365
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n30 = 0

	if p46.key ~= nil and p46.key ~= "" then
		local v849, v850 = proto.writeTag(buf, n30, 1, proto.wireTypes.lengthDelimited)

		buf, n30 = proto.writeString(v849, v850, p46.key)
	end

	if p46.value ~= nil then
		local v851 = p46.value:encode()
		local v852, v853 = proto.writeTag(buf, n30, 2, proto.wireTypes.lengthDelimited)

		buf, n30 = proto.writeBuffer(v852, v853, v851, buffer.len(v851))
	end

	local buf19 = buffer.create(n30)

	buffer.copy(buf19, 0, buf, 0, n30)

	return buf19
end
function t72.decode(p47: buffer) -- line: 7387
	-- upvalues: t72 (copy), proto (copy), t1 (copy)
	local v856 = t72.new()
	local n31 = 0

	while n31 < buffer.len(p47) do
		local v858, v859

		v858, v859, n31 = proto.readTag(p47, n31)

		if v859 == proto.wireTypes.varint then
			local v860

			v860, n31 = proto.readVarInt(p47, n31)
		elseif v859 == proto.wireTypes.lengthDelimited then
			if v858 == 1 then
				local v861

				v861, n31 = proto.readBuffer(p47, n31)
				v856.key = buffer.tostring(v861)
			elseif v858 == 2 then
				local v862

				v862, n31 = proto.readBuffer(p47, n31)
				v856.value = t1.EntryOrder.decode(v862)
			else
				local v863, v864 = proto.readVarInt(p47, n31)

				n31 = v864 + v863
			end
		elseif v859 == proto.wireTypes.i32 then
			local v865

			v865, n31 = proto.readFixed32(p47, n31)
		elseif v859 == proto.wireTypes.i64 then
			local v866

			v866, n31 = proto.readFixed64(p47, n31)
		else
			error("Unsupported wire type: " .. v859)
		end
	end

	return v856
end
function t72.jsonEncode(p48) -- line: 7437
	local t74 = {}

	if p48.key ~= nil and p48.key ~= "" then
		t74.key = p48.key
	end

	if p48.value ~= nil then
		t74.value = p48.value:jsonEncode()
	end

	return t74
end
function t72.jsonDecode(t75: {[any]: any}) -- line: 7453
	-- upvalues: t72 (copy), t1 (copy)
	local v870 = t72.new()

	if t75.key ~= nil then
		v870.key = t75.key
	end

	if t75.value ~= nil then
		v870.value = t1.EntryOrder.jsonDecode(t75.value)
	end

	return v870
end

t72.descriptor = {
	name = "ExperienceDetailsFeedInputData_EntryOrderMapEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryOrderMapEntry"
}
t1.ExperienceDetailsFeedInputData_EntryOrderMapEntry = t72
typeRegistry.default:register(t1.ExperienceDetailsFeedInputData_EntryOrderMapEntry)

local t76 = {}

t76.__index = t76

function t76.new(t77: {[any]: any}?) -- line: 7484
	-- upvalues: t76 (copy)
	return (setmetatable({
		items = if t77 ~= nil and t77.items ~= nil then t77.items else {}
	}, t76))
end
function t76.encode(p49) -- line: 7490
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n32 = 0

	if p49.items ~= nil and #p49.items > 0 then
		for _, v876 in p49.items do
			local v877, v878 = proto.writeTag(buf, n32, 1, proto.wireTypes.lengthDelimited)

			buf, n32 = proto.writeString(v877, v878, v876)
		end
	end

	local buf20 = buffer.create(n32)

	buffer.copy(buf20, 0, buf, 0, n32)

	return buf20
end
function t76.decode(p50: buffer) -- line: 7506
	-- upvalues: t76 (copy), proto (copy)
	local v881 = t76.new()
	local n33 = 0

	while n33 < buffer.len(p50) do
		local v883, v884

		v883, v884, n33 = proto.readTag(p50, n33)

		if v884 == proto.wireTypes.varint then
			local v885

			v885, n33 = proto.readVarInt(p50, n33)
		elseif v884 == proto.wireTypes.lengthDelimited then
			if v883 == 1 then
				local v886

				v886, n33 = proto.readBuffer(p50, n33)
				table.insert(v881.items, buffer.tostring(v886))
			else
				local v887, v888 = proto.readVarInt(p50, n33)

				n33 = v888 + v887
			end
		elseif v884 == proto.wireTypes.i32 then
			local v889

			v889, n33 = proto.readFixed32(p50, n33)
		elseif v884 == proto.wireTypes.i64 then
			local v890

			v890, n33 = proto.readFixed64(p50, n33)
		else
			error("Unsupported wire type: " .. v884)
		end
	end

	return v881
end
function t76.jsonEncode(p51) -- line: 7549
	local t78 = {}

	if p51.items ~= nil and #p51.items > 0 then
		local t79 = {}

		for _, v895 in p51.items do
			table.insert(t79, v895)
		end

		t78.items = t79
	end

	return t78
end
function t76.jsonDecode(t80: {[any]: any}) -- line: 7563
	-- upvalues: t76 (copy)
	local v897 = t76.new()

	if t80.items ~= nil then
		local t81 = {}

		for _, v900 in t80.items do
			table.insert(t81, v900)
		end

		v897.items = t81
	end

	return v897
end

t76.descriptor = {
	name = "EntryOrder",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryOrder"
}
t1.EntryOrder = t76
typeRegistry.default:register(t1.EntryOrder)

local t82 = {}

t82.__index = t82

function t82.new(t83: {[any]: any}?) -- line: 7592
	-- upvalues: t82 (copy)
	return (setmetatable({
		universe_id = if t83 ~= nil and t83.universe_id ~= nil then t83.universe_id else "",
		user_owns_experience = t83 ~= nil and (t83.user_owns_experience ~= nil and t83.user_owns_experience)
	}, t82))
end
function t82.encode(p52) -- line: 7603
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n34 = 0

	if p52.universe_id ~= nil and p52.universe_id ~= "" then
		local v905, v906 = proto.writeTag(buf, n34, 1, proto.wireTypes.lengthDelimited)

		buf, n34 = proto.writeString(v905, v906, p52.universe_id)
	end

	if p52.user_owns_experience then
		local v907, v908 = proto.writeTag(buf, n34, 2, proto.wireTypes.varint)

		buf, n34 = proto.writeVarInt(v907, v908, not p52.user_owns_experience and 0 or 1)
	end

	local buf21 = buffer.create(n34)

	buffer.copy(buf21, 0, buf, 0, n34)

	return buf21
end
function t82.decode(p53: buffer) -- line: 7622
	-- upvalues: t82 (copy), proto (copy)
	local v911 = t82.new()
	local n35 = 0

	while n35 < buffer.len(p53) do
		local v913, v914

		v913, v914, n35 = proto.readTag(p53, n35)

		if v914 == proto.wireTypes.varint then
			if v913 == 2 then
				local v915

				v915, n35 = proto.readVarInt(p53, n35)
				v911.user_owns_experience = v915 ~= 0
			else
				local v916

				v916, n35 = proto.readVarInt(p53, n35)
			end
		elseif v914 == proto.wireTypes.lengthDelimited then
			if v913 == 1 then
				local v917

				v917, n35 = proto.readBuffer(p53, n35)
				v911.universe_id = buffer.tostring(v917)
			else
				local v918, v919 = proto.readVarInt(p53, n35)

				n35 = v919 + v918
			end
		elseif v914 == proto.wireTypes.i32 then
			local v920

			v920, n35 = proto.readFixed32(p53, n35)
		elseif v914 == proto.wireTypes.i64 then
			local v921

			v921, n35 = proto.readFixed64(p53, n35)
		else
			error("Unsupported wire type: " .. v914)
		end
	end

	return v911
end
function t82.jsonEncode(p54) -- line: 7670
	local t84 = {}

	if p54.universe_id ~= nil and p54.universe_id ~= "" then
		t84.universeId = p54.universe_id
	end

	if p54.user_owns_experience then
		t84.userOwnsExperience = p54.user_owns_experience
	end

	return t84
end
function t82.jsonDecode(t85: {[any]: any}) -- line: 7684
	-- upvalues: t82 (copy)
	local v925 = t82.new()

	if t85.universe_id ~= nil then
		v925.universe_id = t85.universe_id
	end

	if t85.universeId ~= nil then
		v925.universe_id = t85.universeId
	end

	if t85.user_owns_experience ~= nil then
		v925.user_owns_experience = t85.user_owns_experience
	end

	if t85.userOwnsExperience ~= nil then
		v925.user_owns_experience = t85.userOwnsExperience
	end

	return v925
end

t82.descriptor = {
	name = "ExperienceDetailsActionBarInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceDetailsActionBarInputData"
}
t1.ExperienceDetailsActionBarInputData = t82
typeRegistry.default:register(t1.ExperienceDetailsActionBarInputData)

local t86 = {}

t86.__index = t86

function t86.new(t87: {[any]: any}?) -- line: 7722
	-- upvalues: t86 (copy)
	return (setmetatable({
		media_asset_id = if t87 ~= nil and t87.media_asset_id ~= nil then t87.media_asset_id else ""
	}, t86))
end
function t86.encode(p55) -- line: 7730
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n36 = 0

	if p55.media_asset_id ~= nil and p55.media_asset_id ~= "" then
		local v930, v931 = proto.writeTag(buf, n36, 1, proto.wireTypes.lengthDelimited)

		buf, n36 = proto.writeString(v930, v931, p55.media_asset_id)
	end

	local buf22 = buffer.create(n36)

	buffer.copy(buf22, 0, buf, 0, n36)

	return buf22
end
function t86.decode(p56: buffer) -- line: 7744
	-- upvalues: t86 (copy), proto (copy)
	local v934 = t86.new()
	local n37 = 0

	while n37 < buffer.len(p56) do
		local v936, v937

		v936, v937, n37 = proto.readTag(p56, n37)

		if v937 == proto.wireTypes.varint then
			local v938

			v938, n37 = proto.readVarInt(p56, n37)
		elseif v937 == proto.wireTypes.lengthDelimited then
			if v936 == 1 then
				local v939

				v939, n37 = proto.readBuffer(p56, n37)
				v934.media_asset_id = buffer.tostring(v939)
			else
				local v940, v941 = proto.readVarInt(p56, n37)

				n37 = v941 + v940
			end
		elseif v937 == proto.wireTypes.i32 then
			local v942

			v942, n37 = proto.readFixed32(p56, n37)
		elseif v937 == proto.wireTypes.i64 then
			local v943

			v943, n37 = proto.readFixed64(p56, n37)
		else
			error("Unsupported wire type: " .. v937)
		end
	end

	return v934
end
function t86.jsonEncode(p57) -- line: 7787
	local t88 = {}

	if p57.media_asset_id ~= nil and p57.media_asset_id ~= "" then
		t88.mediaAssetId = p57.media_asset_id
	end

	return t88
end
function t86.jsonDecode(t89: {[any]: any}) -- line: 7797
	-- upvalues: t86 (copy)
	local v947 = t86.new()

	if t89.media_asset_id ~= nil then
		v947.media_asset_id = t89.media_asset_id
	end

	if t89.mediaAssetId ~= nil then
		v947.media_asset_id = t89.mediaAssetId
	end

	return v947
end

t86.descriptor = {
	name = "ExperienceDetailsBannerImageInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceDetailsBannerImageInputData"
}
t1.ExperienceDetailsBannerImageInputData = t86
typeRegistry.default:register(t1.ExperienceDetailsBannerImageInputData)

local t90 = {}

t90.__index = t90

function t90.new(t91: {[any]: any}?) -- line: 7827
	-- upvalues: t90 (copy)
	return (setmetatable({
		universe_id = if t91 ~= nil and t91.universe_id ~= nil then t91.universe_id else ""
	}, t90))
end
function t90.encode(p58) -- line: 7835
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n38 = 0

	if p58.universe_id ~= nil and p58.universe_id ~= "" then
		local v952, v953 = proto.writeTag(buf, n38, 1, proto.wireTypes.lengthDelimited)

		buf, n38 = proto.writeString(v952, v953, p58.universe_id)
	end

	local buf23 = buffer.create(n38)

	buffer.copy(buf23, 0, buf, 0, n38)

	return buf23
end
function t90.decode(p59: buffer) -- line: 7849
	-- upvalues: t90 (copy), proto (copy)
	local v956 = t90.new()
	local n39 = 0

	while n39 < buffer.len(p59) do
		local v958, v959

		v958, v959, n39 = proto.readTag(p59, n39)

		if v959 == proto.wireTypes.varint then
			local v960

			v960, n39 = proto.readVarInt(p59, n39)
		elseif v959 == proto.wireTypes.lengthDelimited then
			if v958 == 1 then
				local v961

				v961, n39 = proto.readBuffer(p59, n39)
				v956.universe_id = buffer.tostring(v961)
			else
				local v962, v963 = proto.readVarInt(p59, n39)

				n39 = v963 + v962
			end
		elseif v959 == proto.wireTypes.i32 then
			local v964

			v964, n39 = proto.readFixed32(p59, n39)
		elseif v959 == proto.wireTypes.i64 then
			local v965

			v965, n39 = proto.readFixed64(p59, n39)
		else
			error("Unsupported wire type: " .. v959)
		end
	end

	return v956
end
function t90.jsonEncode(p60) -- line: 7892
	local t92 = {}

	if p60.universe_id ~= nil and p60.universe_id ~= "" then
		t92.universeId = p60.universe_id
	end

	return t92
end
function t90.jsonDecode(t93: {[any]: any}) -- line: 7902
	-- upvalues: t90 (copy)
	local v969 = t90.new()

	if t93.universe_id ~= nil then
		v969.universe_id = t93.universe_id
	end

	if t93.universeId ~= nil then
		v969.universe_id = t93.universeId
	end

	return v969
end

t90.descriptor = {
	name = "ExperienceDetailsStickyHeaderInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceDetailsStickyHeaderInputData"
}
t1.ExperienceDetailsStickyHeaderInputData = t90
typeRegistry.default:register(t1.ExperienceDetailsStickyHeaderInputData)

local t94 = {}

t94.__index = t94

function t94.new(t95: {[any]: any}?) -- line: 7932
	-- upvalues: t94 (copy)
	return (setmetatable({
		universe_id = if t95 ~= nil and t95.universe_id ~= nil then t95.universe_id else "",
		creator_key = if t95 ~= nil and t95.creator_key ~= nil then t95.creator_key else ""
	}, t94))
end
function t94.encode(p61) -- line: 7941
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n40 = 0

	if p61.universe_id ~= nil and p61.universe_id ~= "" then
		local v974, v975 = proto.writeTag(buf, n40, 1, proto.wireTypes.lengthDelimited)

		buf, n40 = proto.writeString(v974, v975, p61.universe_id)
	end

	if p61.creator_key ~= nil and p61.creator_key ~= "" then
		local v976, v977 = proto.writeTag(buf, n40, 2, proto.wireTypes.lengthDelimited)

		buf, n40 = proto.writeString(v976, v977, p61.creator_key)
	end

	local buf24 = buffer.create(n40)

	buffer.copy(buf24, 0, buf, 0, n40)

	return buf24
end
function t94.decode(p62: buffer) -- line: 7960
	-- upvalues: t94 (copy), proto (copy)
	local v980 = t94.new()
	local n41 = 0

	while n41 < buffer.len(p62) do
		local v982, v983

		v982, v983, n41 = proto.readTag(p62, n41)

		if v983 == proto.wireTypes.varint then
			local v984

			v984, n41 = proto.readVarInt(p62, n41)
		elseif v983 == proto.wireTypes.lengthDelimited then
			if v982 == 1 then
				local v985

				v985, n41 = proto.readBuffer(p62, n41)
				v980.universe_id = buffer.tostring(v985)
			elseif v982 == 2 then
				local v986

				v986, n41 = proto.readBuffer(p62, n41)
				v980.creator_key = buffer.tostring(v986)
			else
				local v987, v988 = proto.readVarInt(p62, n41)

				n41 = v988 + v987
			end
		elseif v983 == proto.wireTypes.i32 then
			local v989

			v989, n41 = proto.readFixed32(p62, n41)
		elseif v983 == proto.wireTypes.i64 then
			local v990

			v990, n41 = proto.readFixed64(p62, n41)
		else
			error("Unsupported wire type: " .. v983)
		end
	end

	return v980
end
function t94.jsonEncode(p63) -- line: 8008
	local t96 = {}

	if p63.universe_id ~= nil and p63.universe_id ~= "" then
		t96.universeId = p63.universe_id
	end

	if p63.creator_key ~= nil and p63.creator_key ~= "" then
		t96.creatorKey = p63.creator_key
	end

	return t96
end
function t94.jsonDecode(t97: {[any]: any}) -- line: 8022
	-- upvalues: t94 (copy)
	local v994 = t94.new()

	if t97.universe_id ~= nil then
		v994.universe_id = t97.universe_id
	end

	if t97.universeId ~= nil then
		v994.universe_id = t97.universeId
	end

	if t97.creator_key ~= nil then
		v994.creator_key = t97.creator_key
	end

	if t97.creatorKey ~= nil then
		v994.creator_key = t97.creatorKey
	end

	return v994
end

t94.descriptor = {
	name = "ExperienceAttributionRowInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceAttributionRowInputData"
}
t1.ExperienceAttributionRowInputData = t94
typeRegistry.default:register(t1.ExperienceAttributionRowInputData)

local t98 = {}

t98.__index = t98

function t98.new(t99: {[any]: any}?) -- line: 8060
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
function t98.encode(p64) -- line: 8082
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n42 = 0

	if p64.universe_id ~= nil and p64.universe_id ~= "" then
		local v999, v1000 = proto.writeTag(buf, n42, 1, proto.wireTypes.lengthDelimited)

		buf, n42 = proto.writeString(v999, v1000, p64.universe_id)
	end

	if p64.root_place_id ~= nil and p64.root_place_id ~= "" then
		local v1001, v1002 = proto.writeTag(buf, n42, 2, proto.wireTypes.lengthDelimited)

		buf, n42 = proto.writeString(v1001, v1002, p64.root_place_id)
	end

	if p64.connection_played_display_name ~= nil and p64.connection_played_display_name ~= "" then
		local v1003, v1004 = proto.writeTag(buf, n42, 3, proto.wireTypes.lengthDelimited)

		buf, n42 = proto.writeString(v1003, v1004, p64.connection_played_display_name)
	end

	if p64.upsell_prompt ~= nil and p64.upsell_prompt ~= "" then
		local v1005, v1006 = proto.writeTag(buf, n42, 4, proto.wireTypes.lengthDelimited)

		buf, n42 = proto.writeString(v1005, v1006, p64.upsell_prompt)
	end

	if p64.connection_played_users ~= nil and #p64.connection_played_users > 0 then
		for _, v1008 in p64.connection_played_users do
			local v1009 = v1008:encode()
			local v1010, v1011 = proto.writeTag(buf, n42, 5, proto.wireTypes.lengthDelimited)

			buf, n42 = proto.writeBuffer(v1010, v1011, v1009, buffer.len(v1009))
		end
	end

	if p64.connection_played_num_others ~= nil and p64.connection_played_num_others ~= 0 then
		local v1012, v1013 = proto.writeTag(buf, n42, 6, proto.wireTypes.varint)

		buf, n42 = proto.writeVarInt(v1012, v1013, p64.connection_played_num_others)
	end

	if p64.connection_played_total_count ~= nil and p64.connection_played_total_count ~= 0 then
		local v1014, v1015 = proto.writeTag(buf, n42, 7, proto.wireTypes.varint)

		buf, n42 = proto.writeVarInt(v1014, v1015, p64.connection_played_total_count)
	end

	local buf25 = buffer.create(n42)

	buffer.copy(buf25, 0, buf, 0, n42)

	return buf25
end
function t98.decode(p65: buffer) -- line: 8129
	-- upvalues: t98 (copy), proto (copy), t1 (copy)
	local v1018 = t98.new()
	local n43 = 0

	while n43 < buffer.len(p65) do
		local v1020, v1021

		v1020, v1021, n43 = proto.readTag(p65, n43)

		if v1021 == proto.wireTypes.varint then
			if v1020 == 6 then
				local v1022

				v1022, n43 = proto.readVarIntI32(p65, n43)
				v1018.connection_played_num_others = v1022
			elseif v1020 == 7 then
				local v1023

				v1023, n43 = proto.readVarIntI32(p65, n43)
				v1018.connection_played_total_count = v1023
			else
				local v1024

				v1024, n43 = proto.readVarInt(p65, n43)
			end
		elseif v1021 == proto.wireTypes.lengthDelimited then
			if v1020 == 1 then
				local v1025

				v1025, n43 = proto.readBuffer(p65, n43)
				v1018.universe_id = buffer.tostring(v1025)
			elseif v1020 == 2 then
				local v1026

				v1026, n43 = proto.readBuffer(p65, n43)
				v1018.root_place_id = buffer.tostring(v1026)
			elseif v1020 == 3 then
				local v1027

				v1027, n43 = proto.readBuffer(p65, n43)
				v1018.connection_played_display_name = buffer.tostring(v1027)
			elseif v1020 == 4 then
				local v1028

				v1028, n43 = proto.readBuffer(p65, n43)
				v1018.upsell_prompt = buffer.tostring(v1028)
			elseif v1020 == 5 then
				local v1029

				v1029, n43 = proto.readBuffer(p65, n43)
				table.insert(v1018.connection_played_users, t1.ExperienceActionModuleInputData_ConnectionPlayedUser.decode(v1029))
			else
				local v1030, v1031 = proto.readVarInt(p65, n43)

				n43 = v1031 + v1030
			end
		elseif v1021 == proto.wireTypes.i32 then
			local v1032

			v1032, n43 = proto.readFixed32(p65, n43)
		elseif v1021 == proto.wireTypes.i64 then
			local v1033

			v1033, n43 = proto.readFixed64(p65, n43)
		else
			error("Unsupported wire type: " .. v1021)
		end
	end

	return v1018
end
function t98.jsonEncode(p66) -- line: 8205
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

		for _, v1038 in p66.connection_played_users do
			table.insert(t101, v1038:jsonEncode())
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
function t98.jsonDecode(t102: {[any]: any}) -- line: 8243
	-- upvalues: t98 (copy), t1 (copy)
	local v1040 = t98.new()

	if t102.universe_id ~= nil then
		v1040.universe_id = t102.universe_id
	end

	if t102.universeId ~= nil then
		v1040.universe_id = t102.universeId
	end

	if t102.root_place_id ~= nil then
		v1040.root_place_id = t102.root_place_id
	end

	if t102.rootPlaceId ~= nil then
		v1040.root_place_id = t102.rootPlaceId
	end

	if t102.connection_played_display_name ~= nil then
		v1040.connection_played_display_name = t102.connection_played_display_name
	end

	if t102.connectionPlayedDisplayName ~= nil then
		v1040.connection_played_display_name = t102.connectionPlayedDisplayName
	end

	if t102.upsell_prompt ~= nil then
		v1040.upsell_prompt = t102.upsell_prompt
	end

	if t102.upsellPrompt ~= nil then
		v1040.upsell_prompt = t102.upsellPrompt
	end

	if t102.connection_played_users ~= nil then
		local t103 = {}

		for _, v1043 in t102.connection_played_users do
			table.insert(t103, t1.ExperienceActionModuleInputData_ConnectionPlayedUser.jsonDecode(v1043))
		end

		v1040.connection_played_users = t103
	end

	if t102.connectionPlayedUsers ~= nil then
		local t104 = {}

		for _, v1046 in t102.connectionPlayedUsers do
			table.insert(t104, t1.ExperienceActionModuleInputData_ConnectionPlayedUser.jsonDecode(v1046))
		end

		v1040.connection_played_users = t104
	end

	if t102.connection_played_num_others ~= nil then
		v1040.connection_played_num_others = t102.connection_played_num_others
	end

	if t102.connectionPlayedNumOthers ~= nil then
		v1040.connection_played_num_others = t102.connectionPlayedNumOthers
	end

	if t102.connection_played_total_count ~= nil then
		v1040.connection_played_total_count = t102.connection_played_total_count
	end

	if t102.connectionPlayedTotalCount ~= nil then
		v1040.connection_played_total_count = t102.connectionPlayedTotalCount
	end

	return v1040
end

t98.descriptor = {
	name = "ExperienceActionModuleInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceActionModuleInputData"
}
t1.ExperienceActionModuleInputData = t98
typeRegistry.default:register(t1.ExperienceActionModuleInputData)

local t105 = {}

t105.__index = t105

function t105.new(t106: {[any]: any}?) -- line: 8330
	-- upvalues: t105 (copy)
	return (setmetatable({
		user_id = if t106 ~= nil and t106.user_id ~= nil then t106.user_id else ""
	}, t105))
end
function t105.encode(p67) -- line: 8341
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n44 = 0

	if p67.user_id ~= nil and p67.user_id ~= "" then
		local v1051, v1052 = proto.writeTag(buf, n44, 1, proto.wireTypes.lengthDelimited)

		buf, n44 = proto.writeString(v1051, v1052, p67.user_id)
	end

	local buf26 = buffer.create(n44)

	buffer.copy(buf26, 0, buf, 0, n44)

	return buf26
end
function t105.decode(p68: buffer) -- line: 8357
	-- upvalues: t105 (copy), proto (copy)
	local v1055 = t105.new()
	local n45 = 0

	while n45 < buffer.len(p68) do
		local v1057, v1058

		v1057, v1058, n45 = proto.readTag(p68, n45)

		if v1058 == proto.wireTypes.varint then
			local v1059

			v1059, n45 = proto.readVarInt(p68, n45)
		elseif v1058 == proto.wireTypes.lengthDelimited then
			if v1057 == 1 then
				local v1060

				v1060, n45 = proto.readBuffer(p68, n45)
				v1055.user_id = buffer.tostring(v1060)
			else
				local v1061, v1062 = proto.readVarInt(p68, n45)

				n45 = v1062 + v1061
			end
		elseif v1058 == proto.wireTypes.i32 then
			local v1063

			v1063, n45 = proto.readFixed32(p68, n45)
		elseif v1058 == proto.wireTypes.i64 then
			local v1064

			v1064, n45 = proto.readFixed64(p68, n45)
		else
			error("Unsupported wire type: " .. v1058)
		end
	end

	return v1055
end
function t105.jsonEncode(p69) -- line: 8402
	local t107 = {}

	if p69.user_id ~= nil and p69.user_id ~= "" then
		t107.userId = p69.user_id
	end

	return t107
end
function t105.jsonDecode(t108: {[any]: any}) -- line: 8414
	-- upvalues: t105 (copy)
	local v1068 = t105.new()

	if t108.user_id ~= nil then
		v1068.user_id = t108.user_id
	end

	if t108.userId ~= nil then
		v1068.user_id = t108.userId
	end

	return v1068
end

t105.descriptor = {
	name = "ExperienceActionModuleInputData_ConnectionPlayedUser",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConnectionPlayedUser"
}
t1.ExperienceActionModuleInputData_ConnectionPlayedUser = t105
typeRegistry.default:register(t1.ExperienceActionModuleInputData_ConnectionPlayedUser)

local t109 = {}

t109.__index = t109

function t109.new(t110: {[any]: any}?) -- line: 8445
	-- upvalues: t109 (copy)
	return (setmetatable({
		media_items = if t110 ~= nil and t110.media_items ~= nil then t110.media_items else {},
		universe_id = if t110 ~= nil and t110.universe_id ~= nil then t110.universe_id else "",
		place_id = if t110 ~= nil and t110.place_id ~= nil then t110.place_id else ""
	}, t109))
end
function t109.encode(p70) -- line: 8455
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n46 = 0

	if p70.media_items ~= nil and #p70.media_items > 0 then
		for _, v1074 in p70.media_items do
			local v1075 = v1074:encode()
			local v1076, v1077 = proto.writeTag(buf, n46, 1, proto.wireTypes.lengthDelimited)

			buf, n46 = proto.writeBuffer(v1076, v1077, v1075, buffer.len(v1075))
		end
	end

	if p70.universe_id ~= nil and p70.universe_id ~= "" then
		local v1078, v1079 = proto.writeTag(buf, n46, 2, proto.wireTypes.lengthDelimited)

		buf, n46 = proto.writeString(v1078, v1079, p70.universe_id)
	end

	if p70.place_id ~= nil and p70.place_id ~= "" then
		local v1080, v1081 = proto.writeTag(buf, n46, 3, proto.wireTypes.lengthDelimited)

		buf, n46 = proto.writeString(v1080, v1081, p70.place_id)
	end

	local buf27 = buffer.create(n46)

	buffer.copy(buf27, 0, buf, 0, n46)

	return buf27
end
function t109.decode(p71: buffer) -- line: 8482
	-- upvalues: t109 (copy), proto (copy), t1 (copy)
	local v1084 = t109.new()
	local n47 = 0

	while n47 < buffer.len(p71) do
		local v1086, v1087

		v1086, v1087, n47 = proto.readTag(p71, n47)

		if v1087 == proto.wireTypes.varint then
			local v1088

			v1088, n47 = proto.readVarInt(p71, n47)
		elseif v1087 == proto.wireTypes.lengthDelimited then
			if v1086 == 1 then
				local v1089

				v1089, n47 = proto.readBuffer(p71, n47)
				table.insert(v1084.media_items, t1.ExperienceMediaGalleryInputData_MediaItem.decode(v1089))
			elseif v1086 == 2 then
				local v1090

				v1090, n47 = proto.readBuffer(p71, n47)
				v1084.universe_id = buffer.tostring(v1090)
			elseif v1086 == 3 then
				local v1091

				v1091, n47 = proto.readBuffer(p71, n47)
				v1084.place_id = buffer.tostring(v1091)
			else
				local v1092, v1093 = proto.readVarInt(p71, n47)

				n47 = v1093 + v1092
			end
		elseif v1087 == proto.wireTypes.i32 then
			local v1094

			v1094, n47 = proto.readFixed32(p71, n47)
		elseif v1087 == proto.wireTypes.i64 then
			local v1095

			v1095, n47 = proto.readFixed64(p71, n47)
		else
			error("Unsupported wire type: " .. v1087)
		end
	end

	return v1084
end
function t109.jsonEncode(p72) -- line: 8535
	local t111 = {}

	if p72.media_items ~= nil and #p72.media_items > 0 then
		local t112 = {}

		for _, v1100 in p72.media_items do
			table.insert(t112, v1100:jsonEncode())
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
function t109.jsonDecode(t113: {[any]: any}) -- line: 8557
	-- upvalues: t109 (copy), t1 (copy)
	local v1102 = t109.new()

	if t113.media_items ~= nil then
		local t114 = {}

		for _, v1105 in t113.media_items do
			table.insert(t114, t1.ExperienceMediaGalleryInputData_MediaItem.jsonDecode(v1105))
		end

		v1102.media_items = t114
	end

	if t113.mediaItems ~= nil then
		local t115 = {}

		for _, v1108 in t113.mediaItems do
			table.insert(t115, t1.ExperienceMediaGalleryInputData_MediaItem.jsonDecode(v1108))
		end

		v1102.media_items = t115
	end

	if t113.universe_id ~= nil then
		v1102.universe_id = t113.universe_id
	end

	if t113.universeId ~= nil then
		v1102.universe_id = t113.universeId
	end

	if t113.place_id ~= nil then
		v1102.place_id = t113.place_id
	end

	if t113.placeId ~= nil then
		v1102.place_id = t113.placeId
	end

	return v1102
end

t109.descriptor = {
	name = "ExperienceMediaGalleryInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceMediaGalleryInputData"
}
t1.ExperienceMediaGalleryInputData = t109
typeRegistry.default:register(t1.ExperienceMediaGalleryInputData)

local t116 = {}

t116.__index = t116

function t116.new(t117: {[any]: any}?) -- line: 8611
	-- upvalues: t116 (copy)
	return (setmetatable({
		media_asset_id = if t117 ~= nil and t117.media_asset_id ~= nil then t117.media_asset_id else ""
	}, t116))
end
function t116.encode(p73) -- line: 8619
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n48 = 0

	if p73.media_asset_id ~= nil and p73.media_asset_id ~= "" then
		local v1113, v1114 = proto.writeTag(buf, n48, 1, proto.wireTypes.lengthDelimited)

		buf, n48 = proto.writeString(v1113, v1114, p73.media_asset_id)
	end

	local buf28 = buffer.create(n48)

	buffer.copy(buf28, 0, buf, 0, n48)

	return buf28
end
function t116.decode(p74: buffer) -- line: 8635
	-- upvalues: t116 (copy), proto (copy)
	local v1117 = t116.new()
	local n49 = 0

	while n49 < buffer.len(p74) do
		local v1119, v1120

		v1119, v1120, n49 = proto.readTag(p74, n49)

		if v1120 == proto.wireTypes.varint then
			local v1121

			v1121, n49 = proto.readVarInt(p74, n49)
		elseif v1120 == proto.wireTypes.lengthDelimited then
			if v1119 == 1 then
				local v1122

				v1122, n49 = proto.readBuffer(p74, n49)
				v1117.media_asset_id = buffer.tostring(v1122)
			else
				local v1123, v1124 = proto.readVarInt(p74, n49)

				n49 = v1124 + v1123
			end
		elseif v1120 == proto.wireTypes.i32 then
			local v1125

			v1125, n49 = proto.readFixed32(p74, n49)
		elseif v1120 == proto.wireTypes.i64 then
			local v1126

			v1126, n49 = proto.readFixed64(p74, n49)
		else
			error("Unsupported wire type: " .. v1120)
		end
	end

	return v1117
end
function t116.jsonEncode(p75) -- line: 8680
	local t118 = {}

	if p75.media_asset_id ~= nil and p75.media_asset_id ~= "" then
		t118.mediaAssetId = p75.media_asset_id
	end

	return t118
end
function t116.jsonDecode(t119: {[any]: any}) -- line: 8692
	-- upvalues: t116 (copy)
	local v1130 = t116.new()

	if t119.media_asset_id ~= nil then
		v1130.media_asset_id = t119.media_asset_id
	end

	if t119.mediaAssetId ~= nil then
		v1130.media_asset_id = t119.mediaAssetId
	end

	return v1130
end

t116.descriptor = {
	name = "ExperienceMediaGalleryInputData_MediaItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.MediaItem"
}
t1.ExperienceMediaGalleryInputData_MediaItem = t116
typeRegistry.default:register(t1.ExperienceMediaGalleryInputData_MediaItem)

local t120 = {}

t120.__index = t120

function t120.new(t121: {[any]: any}?) -- line: 8722
	-- upvalues: t120 (copy)
	return (setmetatable({
		universe_id = if t121 ~= nil and t121.universe_id ~= nil then t121.universe_id else ""
	}, t120))
end
function t120.encode(p76) -- line: 8730
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n50 = 0

	if p76.universe_id ~= nil and p76.universe_id ~= "" then
		local v1135, v1136 = proto.writeTag(buf, n50, 1, proto.wireTypes.lengthDelimited)

		buf, n50 = proto.writeString(v1135, v1136, p76.universe_id)
	end

	local buf29 = buffer.create(n50)

	buffer.copy(buf29, 0, buf, 0, n50)

	return buf29
end
function t120.decode(p77: buffer) -- line: 8744
	-- upvalues: t120 (copy), proto (copy)
	local v1139 = t120.new()
	local n51 = 0

	while n51 < buffer.len(p77) do
		local v1141, v1142

		v1141, v1142, n51 = proto.readTag(p77, n51)

		if v1142 == proto.wireTypes.varint then
			local v1143

			v1143, n51 = proto.readVarInt(p77, n51)
		elseif v1142 == proto.wireTypes.lengthDelimited then
			if v1141 == 1 then
				local v1144

				v1144, n51 = proto.readBuffer(p77, n51)
				v1139.universe_id = buffer.tostring(v1144)
			else
				local v1145, v1146 = proto.readVarInt(p77, n51)

				n51 = v1146 + v1145
			end
		elseif v1142 == proto.wireTypes.i32 then
			local v1147

			v1147, n51 = proto.readFixed32(p77, n51)
		elseif v1142 == proto.wireTypes.i64 then
			local v1148

			v1148, n51 = proto.readFixed64(p77, n51)
		else
			error("Unsupported wire type: " .. v1142)
		end
	end

	return v1139
end
function t120.jsonEncode(p78) -- line: 8787
	local t122 = {}

	if p78.universe_id ~= nil and p78.universe_id ~= "" then
		t122.universeId = p78.universe_id
	end

	return t122
end
function t120.jsonDecode(t123: {[any]: any}) -- line: 8797
	-- upvalues: t120 (copy)
	local v1152 = t120.new()

	if t123.universe_id ~= nil then
		v1152.universe_id = t123.universe_id
	end

	if t123.universeId ~= nil then
		v1152.universe_id = t123.universeId
	end

	return v1152
end

t120.descriptor = {
	name = "ExperienceDescriptionInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceDescriptionInputData"
}
t1.ExperienceDescriptionInputData = t120
typeRegistry.default:register(t1.ExperienceDescriptionInputData)

local t124 = {}

t124.__index = t124

function t124.new(t125: {[any]: any}?) -- line: 8825
	-- upvalues: t124 (copy)
	return (setmetatable({
		universe_id = if t125 ~= nil and t125.universe_id ~= nil then t125.universe_id else ""
	}, t124))
end
function t124.encode(p79) -- line: 8833
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n52 = 0

	if p79.universe_id ~= nil and p79.universe_id ~= "" then
		local v1157, v1158 = proto.writeTag(buf, n52, 1, proto.wireTypes.lengthDelimited)

		buf, n52 = proto.writeString(v1157, v1158, p79.universe_id)
	end

	local buf30 = buffer.create(n52)

	buffer.copy(buf30, 0, buf, 0, n52)

	return buf30
end
function t124.decode(p80: buffer) -- line: 8847
	-- upvalues: t124 (copy), proto (copy)
	local v1161 = t124.new()
	local n53 = 0

	while n53 < buffer.len(p80) do
		local v1163, v1164

		v1163, v1164, n53 = proto.readTag(p80, n53)

		if v1164 == proto.wireTypes.varint then
			local v1165

			v1165, n53 = proto.readVarInt(p80, n53)
		elseif v1164 == proto.wireTypes.lengthDelimited then
			if v1163 == 1 then
				local v1166

				v1166, n53 = proto.readBuffer(p80, n53)
				v1161.universe_id = buffer.tostring(v1166)
			else
				local v1167, v1168 = proto.readVarInt(p80, n53)

				n53 = v1168 + v1167
			end
		elseif v1164 == proto.wireTypes.i32 then
			local v1169

			v1169, n53 = proto.readFixed32(p80, n53)
		elseif v1164 == proto.wireTypes.i64 then
			local v1170

			v1170, n53 = proto.readFixed64(p80, n53)
		else
			error("Unsupported wire type: " .. v1164)
		end
	end

	return v1161
end
function t124.jsonEncode(p81) -- line: 8890
	local t126 = {}

	if p81.universe_id ~= nil and p81.universe_id ~= "" then
		t126.universeId = p81.universe_id
	end

	return t126
end
function t124.jsonDecode(t127: {[any]: any}) -- line: 8900
	-- upvalues: t124 (copy)
	local v1174 = t124.new()

	if t127.universe_id ~= nil then
		v1174.universe_id = t127.universe_id
	end

	if t127.universeId ~= nil then
		v1174.universe_id = t127.universeId
	end

	return v1174
end

t124.descriptor = {
	name = "ExperienceStatRowInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceStatRowInputData"
}
t1.ExperienceStatRowInputData = t124
typeRegistry.default:register(t1.ExperienceStatRowInputData)

local t128 = {}

t128.__index = t128

function t128.new(t129: {[any]: any}?) -- line: 8928
	-- upvalues: t128 (copy)
	return (setmetatable({
		universe_id = if t129 ~= nil and t129.universe_id ~= nil then t129.universe_id else "",
		has_store_items = t129 ~= nil and (t129.has_store_items ~= nil and t129.has_store_items),
		has_badges = t129 ~= nil and (t129.has_badges ~= nil and t129.has_badges),
		has_game_passes = t129 ~= nil and (t129.has_game_passes ~= nil and t129.has_game_passes)
	}, t128))
end
function t128.encode(p82) -- line: 8939
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n54 = 0

	if p82.universe_id ~= nil and p82.universe_id ~= "" then
		local v1179, v1180 = proto.writeTag(buf, n54, 1, proto.wireTypes.lengthDelimited)

		buf, n54 = proto.writeString(v1179, v1180, p82.universe_id)
	end

	if p82.has_store_items then
		local v1181, v1182 = proto.writeTag(buf, n54, 2, proto.wireTypes.varint)

		buf, n54 = proto.writeVarInt(v1181, v1182, not p82.has_store_items and 0 or 1)
	end

	if p82.has_badges then
		local v1183, v1184 = proto.writeTag(buf, n54, 3, proto.wireTypes.varint)

		buf, n54 = proto.writeVarInt(v1183, v1184, not p82.has_badges and 0 or 1)
	end

	if p82.has_game_passes then
		local v1185, v1186 = proto.writeTag(buf, n54, 4, proto.wireTypes.varint)

		buf, n54 = proto.writeVarInt(v1185, v1186, not p82.has_game_passes and 0 or 1)
	end

	local buf31 = buffer.create(n54)

	buffer.copy(buf31, 0, buf, 0, n54)

	return buf31
end
function t128.decode(p83: buffer) -- line: 8968
	-- upvalues: t128 (copy), proto (copy)
	local v1189 = t128.new()
	local n55 = 0

	while n55 < buffer.len(p83) do
		local v1191, v1192

		v1191, v1192, n55 = proto.readTag(p83, n55)

		if v1192 == proto.wireTypes.varint then
			if v1191 == 2 then
				local v1193

				v1193, n55 = proto.readVarInt(p83, n55)
				v1189.has_store_items = v1193 ~= 0
			elseif v1191 == 3 then
				local v1194

				v1194, n55 = proto.readVarInt(p83, n55)
				v1189.has_badges = v1194 ~= 0
			elseif v1191 == 4 then
				local v1195

				v1195, n55 = proto.readVarInt(p83, n55)
				v1189.has_game_passes = v1195 ~= 0
			else
				local v1196

				v1196, n55 = proto.readVarInt(p83, n55)
			end
		elseif v1192 == proto.wireTypes.lengthDelimited then
			if v1191 == 1 then
				local v1197

				v1197, n55 = proto.readBuffer(p83, n55)
				v1189.universe_id = buffer.tostring(v1197)
			else
				local v1198, v1199 = proto.readVarInt(p83, n55)

				n55 = v1199 + v1198
			end
		elseif v1192 == proto.wireTypes.i32 then
			local v1200

			v1200, n55 = proto.readFixed32(p83, n55)
		elseif v1192 == proto.wireTypes.i64 then
			local v1201

			v1201, n55 = proto.readFixed64(p83, n55)
		else
			error("Unsupported wire type: " .. v1192)
		end
	end

	return v1189
end
function t128.jsonEncode(p84) -- line: 9026
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
function t128.jsonDecode(t131: {[any]: any}) -- line: 9048
	-- upvalues: t128 (copy)
	local v1205 = t128.new()

	if t131.universe_id ~= nil then
		v1205.universe_id = t131.universe_id
	end

	if t131.universeId ~= nil then
		v1205.universe_id = t131.universeId
	end

	if t131.has_store_items ~= nil then
		v1205.has_store_items = t131.has_store_items
	end

	if t131.hasStoreItems ~= nil then
		v1205.has_store_items = t131.hasStoreItems
	end

	if t131.has_badges ~= nil then
		v1205.has_badges = t131.has_badges
	end

	if t131.hasBadges ~= nil then
		v1205.has_badges = t131.hasBadges
	end

	if t131.has_game_passes ~= nil then
		v1205.has_game_passes = t131.has_game_passes
	end

	if t131.hasGamePasses ~= nil then
		v1205.has_game_passes = t131.hasGamePasses
	end

	return v1205
end

t128.descriptor = {
	name = "ExperienceInfoTableInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceInfoTableInputData"
}
t1.ExperienceInfoTableInputData = t128
typeRegistry.default:register(t1.ExperienceInfoTableInputData)

local t132 = {}

t132.__index = t132

function t132.new(t133: {[any]: any}?) -- line: 9100
	-- upvalues: t132 (copy)
	return (setmetatable({
		universe_id = if t133 ~= nil and t133.universe_id ~= nil then t133.universe_id else ""
	}, t132))
end
function t132.encode(p85) -- line: 9108
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n56 = 0

	if p85.universe_id ~= nil and p85.universe_id ~= "" then
		local v1210, v1211 = proto.writeTag(buf, n56, 1, proto.wireTypes.lengthDelimited)

		buf, n56 = proto.writeString(v1210, v1211, p85.universe_id)
	end

	local buf32 = buffer.create(n56)

	buffer.copy(buf32, 0, buf, 0, n56)

	return buf32
end
function t132.decode(p86: buffer) -- line: 9122
	-- upvalues: t132 (copy), proto (copy)
	local v1214 = t132.new()
	local n57 = 0

	while n57 < buffer.len(p86) do
		local v1216, v1217

		v1216, v1217, n57 = proto.readTag(p86, n57)

		if v1217 == proto.wireTypes.varint then
			local v1218

			v1218, n57 = proto.readVarInt(p86, n57)
		elseif v1217 == proto.wireTypes.lengthDelimited then
			if v1216 == 1 then
				local v1219

				v1219, n57 = proto.readBuffer(p86, n57)
				v1214.universe_id = buffer.tostring(v1219)
			else
				local v1220, v1221 = proto.readVarInt(p86, n57)

				n57 = v1221 + v1220
			end
		elseif v1217 == proto.wireTypes.i32 then
			local v1222

			v1222, n57 = proto.readFixed32(p86, n57)
		elseif v1217 == proto.wireTypes.i64 then
			local v1223

			v1223, n57 = proto.readFixed64(p86, n57)
		else
			error("Unsupported wire type: " .. v1217)
		end
	end

	return v1214
end
function t132.jsonEncode(p87) -- line: 9165
	local t134 = {}

	if p87.universe_id ~= nil and p87.universe_id ~= "" then
		t134.universeId = p87.universe_id
	end

	return t134
end
function t132.jsonDecode(t135: {[any]: any}) -- line: 9175
	-- upvalues: t132 (copy)
	local v1227 = t132.new()

	if t135.universe_id ~= nil then
		v1227.universe_id = t135.universe_id
	end

	if t135.universeId ~= nil then
		v1227.universe_id = t135.universeId
	end

	return v1227
end

t132.descriptor = {
	name = "ExperienceContentRatingLabelInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceContentRatingLabelInputData"
}
t1.ExperienceContentRatingLabelInputData = t132
typeRegistry.default:register(t1.ExperienceContentRatingLabelInputData)

local t136 = {}

t136.__index = t136

function t136.new(t137: {[any]: any}?) -- line: 9205
	-- upvalues: t136 (copy)
	return (setmetatable({
		universe_id = if t137 ~= nil and t137.universe_id ~= nil then t137.universe_id else "",
		user_owns_experience = t137 ~= nil and (t137.user_owns_experience ~= nil and t137.user_owns_experience)
	}, t136))
end
function t136.encode(p88) -- line: 9216
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n58 = 0

	if p88.universe_id ~= nil and p88.universe_id ~= "" then
		local v1232, v1233 = proto.writeTag(buf, n58, 1, proto.wireTypes.lengthDelimited)

		buf, n58 = proto.writeString(v1232, v1233, p88.universe_id)
	end

	if p88.user_owns_experience then
		local v1234, v1235 = proto.writeTag(buf, n58, 2, proto.wireTypes.varint)

		buf, n58 = proto.writeVarInt(v1234, v1235, not p88.user_owns_experience and 0 or 1)
	end

	local buf33 = buffer.create(n58)

	buffer.copy(buf33, 0, buf, 0, n58)

	return buf33
end
function t136.decode(p89: buffer) -- line: 9235
	-- upvalues: t136 (copy), proto (copy)
	local v1238 = t136.new()
	local n59 = 0

	while n59 < buffer.len(p89) do
		local v1240, v1241

		v1240, v1241, n59 = proto.readTag(p89, n59)

		if v1241 == proto.wireTypes.varint then
			if v1240 == 2 then
				local v1242

				v1242, n59 = proto.readVarInt(p89, n59)
				v1238.user_owns_experience = v1242 ~= 0
			else
				local v1243

				v1243, n59 = proto.readVarInt(p89, n59)
			end
		elseif v1241 == proto.wireTypes.lengthDelimited then
			if v1240 == 1 then
				local v1244

				v1244, n59 = proto.readBuffer(p89, n59)
				v1238.universe_id = buffer.tostring(v1244)
			else
				local v1245, v1246 = proto.readVarInt(p89, n59)

				n59 = v1246 + v1245
			end
		elseif v1241 == proto.wireTypes.i32 then
			local v1247

			v1247, n59 = proto.readFixed32(p89, n59)
		elseif v1241 == proto.wireTypes.i64 then
			local v1248

			v1248, n59 = proto.readFixed64(p89, n59)
		else
			error("Unsupported wire type: " .. v1241)
		end
	end

	return v1238
end
function t136.jsonEncode(p90) -- line: 9283
	local t138 = {}

	if p90.universe_id ~= nil and p90.universe_id ~= "" then
		t138.universeId = p90.universe_id
	end

	if p90.user_owns_experience then
		t138.userOwnsExperience = p90.user_owns_experience
	end

	return t138
end
function t136.jsonDecode(t139: {[any]: any}) -- line: 9297
	-- upvalues: t136 (copy)
	local v1252 = t136.new()

	if t139.universe_id ~= nil then
		v1252.universe_id = t139.universe_id
	end

	if t139.universeId ~= nil then
		v1252.universe_id = t139.universeId
	end

	if t139.user_owns_experience ~= nil then
		v1252.user_owns_experience = t139.user_owns_experience
	end

	if t139.userOwnsExperience ~= nil then
		v1252.user_owns_experience = t139.userOwnsExperience
	end

	return v1252
end

t136.descriptor = {
	name = "ExperienceRefundPolicyInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceRefundPolicyInputData"
}
t1.ExperienceRefundPolicyInputData = t136
typeRegistry.default:register(t1.ExperienceRefundPolicyInputData)

local t140 = {}

t140.__index = t140

function t140.new(t141: {[any]: any}?) -- line: 9333
	-- upvalues: t140 (copy)
	return (setmetatable({
		universe_id = if t141 ~= nil and t141.universe_id ~= nil then t141.universe_id else "",
		place_id = if t141 ~= nil and t141.place_id ~= nil then t141.place_id else ""
	}, t140))
end
function t140.encode(p91) -- line: 9342
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n60 = 0

	if p91.universe_id ~= nil and p91.universe_id ~= "" then
		local v1257, v1258 = proto.writeTag(buf, n60, 1, proto.wireTypes.lengthDelimited)

		buf, n60 = proto.writeString(v1257, v1258, p91.universe_id)
	end

	if p91.place_id ~= nil and p91.place_id ~= "" then
		local v1259, v1260 = proto.writeTag(buf, n60, 2, proto.wireTypes.lengthDelimited)

		buf, n60 = proto.writeString(v1259, v1260, p91.place_id)
	end

	local buf34 = buffer.create(n60)

	buffer.copy(buf34, 0, buf, 0, n60)

	return buf34
end
function t140.decode(p92: buffer) -- line: 9361
	-- upvalues: t140 (copy), proto (copy)
	local v1263 = t140.new()
	local n61 = 0

	while n61 < buffer.len(p92) do
		local v1265, v1266

		v1265, v1266, n61 = proto.readTag(p92, n61)

		if v1266 == proto.wireTypes.varint then
			local v1267

			v1267, n61 = proto.readVarInt(p92, n61)
		elseif v1266 == proto.wireTypes.lengthDelimited then
			if v1265 == 1 then
				local v1268

				v1268, n61 = proto.readBuffer(p92, n61)
				v1263.universe_id = buffer.tostring(v1268)
			elseif v1265 == 2 then
				local v1269

				v1269, n61 = proto.readBuffer(p92, n61)
				v1263.place_id = buffer.tostring(v1269)
			else
				local v1270, v1271 = proto.readVarInt(p92, n61)

				n61 = v1271 + v1270
			end
		elseif v1266 == proto.wireTypes.i32 then
			local v1272

			v1272, n61 = proto.readFixed32(p92, n61)
		elseif v1266 == proto.wireTypes.i64 then
			local v1273

			v1273, n61 = proto.readFixed64(p92, n61)
		else
			error("Unsupported wire type: " .. v1266)
		end
	end

	return v1263
end
function t140.jsonEncode(p93) -- line: 9409
	local t142 = {}

	if p93.universe_id ~= nil and p93.universe_id ~= "" then
		t142.universeId = p93.universe_id
	end

	if p93.place_id ~= nil and p93.place_id ~= "" then
		t142.placeId = p93.place_id
	end

	return t142
end
function t140.jsonDecode(t143: {[any]: any}) -- line: 9423
	-- upvalues: t140 (copy)
	local v1277 = t140.new()

	if t143.universe_id ~= nil then
		v1277.universe_id = t143.universe_id
	end

	if t143.universeId ~= nil then
		v1277.universe_id = t143.universeId
	end

	if t143.place_id ~= nil then
		v1277.place_id = t143.place_id
	end

	if t143.placeId ~= nil then
		v1277.place_id = t143.placeId
	end

	return v1277
end

t140.descriptor = {
	name = "ExperiencePlayWithRewardInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperiencePlayWithRewardInputData"
}
t1.ExperiencePlayWithRewardInputData = t140
typeRegistry.default:register(t1.ExperiencePlayWithRewardInputData)

local t144 = {}

t144.__index = t144

function t144.new(t145: {[any]: any}?) -- line: 9461
	-- upvalues: t144 (copy)
	return (setmetatable({
		community_id = if t145 ~= nil and t145.community_id ~= nil then t145.community_id else ""
	}, t144))
end
function t144.encode(p94) -- line: 9469
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n62 = 0

	if p94.community_id ~= nil and p94.community_id ~= "" then
		local v1282, v1283 = proto.writeTag(buf, n62, 1, proto.wireTypes.lengthDelimited)

		buf, n62 = proto.writeString(v1282, v1283, p94.community_id)
	end

	local buf35 = buffer.create(n62)

	buffer.copy(buf35, 0, buf, 0, n62)

	return buf35
end
function t144.decode(p95: buffer) -- line: 9483
	-- upvalues: t144 (copy), proto (copy)
	local v1286 = t144.new()
	local n63 = 0

	while n63 < buffer.len(p95) do
		local v1288, v1289

		v1288, v1289, n63 = proto.readTag(p95, n63)

		if v1289 == proto.wireTypes.varint then
			local v1290

			v1290, n63 = proto.readVarInt(p95, n63)
		elseif v1289 == proto.wireTypes.lengthDelimited then
			if v1288 == 1 then
				local v1291

				v1291, n63 = proto.readBuffer(p95, n63)
				v1286.community_id = buffer.tostring(v1291)
			else
				local v1292, v1293 = proto.readVarInt(p95, n63)

				n63 = v1293 + v1292
			end
		elseif v1289 == proto.wireTypes.i32 then
			local v1294

			v1294, n63 = proto.readFixed32(p95, n63)
		elseif v1289 == proto.wireTypes.i64 then
			local v1295

			v1295, n63 = proto.readFixed64(p95, n63)
		else
			error("Unsupported wire type: " .. v1289)
		end
	end

	return v1286
end
function t144.jsonEncode(p96) -- line: 9526
	local t146 = {}

	if p96.community_id ~= nil and p96.community_id ~= "" then
		t146.communityId = p96.community_id
	end

	return t146
end
function t144.jsonDecode(t147: {[any]: any}) -- line: 9536
	-- upvalues: t144 (copy)
	local v1299 = t144.new()

	if t147.community_id ~= nil then
		v1299.community_id = t147.community_id
	end

	if t147.communityId ~= nil then
		v1299.community_id = t147.communityId
	end

	return v1299
end

t144.descriptor = {
	name = "CommunitySectionInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CommunitySectionInputData"
}
t1.CommunitySectionInputData = t144
typeRegistry.default:register(t1.CommunitySectionInputData)

local t148 = {}

t148.__index = t148

function t148.new(t149: {[any]: any}?) -- line: 9564
	-- upvalues: t148 (copy)
	return (setmetatable({
		social_link_items = if t149 ~= nil and t149.social_link_items ~= nil then t149.social_link_items else {}
	}, t148))
end
function t148.encode(p97) -- line: 9570
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n64 = 0

	if p97.social_link_items ~= nil and #p97.social_link_items > 0 then
		for _, v1305 in p97.social_link_items do
			local v1306 = v1305:encode()
			local v1307, v1308 = proto.writeTag(buf, n64, 1, proto.wireTypes.lengthDelimited)

			buf, n64 = proto.writeBuffer(v1307, v1308, v1306, buffer.len(v1306))
		end
	end

	local buf36 = buffer.create(n64)

	buffer.copy(buf36, 0, buf, 0, n64)

	return buf36
end
function t148.decode(p98: buffer) -- line: 9587
	-- upvalues: t148 (copy), proto (copy), t1 (copy)
	local v1311 = t148.new()
	local n65 = 0

	while n65 < buffer.len(p98) do
		local v1313, v1314

		v1313, v1314, n65 = proto.readTag(p98, n65)

		if v1314 == proto.wireTypes.varint then
			local v1315

			v1315, n65 = proto.readVarInt(p98, n65)
		elseif v1314 == proto.wireTypes.lengthDelimited then
			if v1313 == 1 then
				local v1316

				v1316, n65 = proto.readBuffer(p98, n65)
				table.insert(v1311.social_link_items, t1.SocialLinkRowInputData_SocialLinkItem.decode(v1316))
			else
				local v1317, v1318 = proto.readVarInt(p98, n65)

				n65 = v1318 + v1317
			end
		elseif v1314 == proto.wireTypes.i32 then
			local v1319

			v1319, n65 = proto.readFixed32(p98, n65)
		elseif v1314 == proto.wireTypes.i64 then
			local v1320

			v1320, n65 = proto.readFixed64(p98, n65)
		else
			error("Unsupported wire type: " .. v1314)
		end
	end

	return v1311
end
function t148.jsonEncode(p99) -- line: 9630
	local t150 = {}

	if p99.social_link_items ~= nil and #p99.social_link_items > 0 then
		local t151 = {}

		for _, v1325 in p99.social_link_items do
			table.insert(t151, v1325:jsonEncode())
		end

		t150.socialLinkItems = t151
	end

	return t150
end
function t148.jsonDecode(t152: {[any]: any}) -- line: 9644
	-- upvalues: t148 (copy), t1 (copy)
	local v1327 = t148.new()

	if t152.social_link_items ~= nil then
		local t153 = {}

		for _, v1330 in t152.social_link_items do
			table.insert(t153, t1.SocialLinkRowInputData_SocialLinkItem.jsonDecode(v1330))
		end

		v1327.social_link_items = t153
	end

	if t152.socialLinkItems ~= nil then
		local t154 = {}

		for _, v1333 in t152.socialLinkItems do
			table.insert(t154, t1.SocialLinkRowInputData_SocialLinkItem.jsonDecode(v1333))
		end

		v1327.social_link_items = t154
	end

	return v1327
end

t148.descriptor = {
	name = "SocialLinkRowInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.SocialLinkRowInputData"
}
t1.SocialLinkRowInputData = t148
typeRegistry.default:register(t1.SocialLinkRowInputData)

local t155 = {}

t155.__index = t155

function t155.new(t156: {[any]: any}?) -- line: 9682
	-- upvalues: t155 (copy)
	return (setmetatable({
		social_link_id = if t156 ~= nil and t156.social_link_id ~= nil then t156.social_link_id else ""
	}, t155))
end
function t155.encode(p100) -- line: 9690
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n66 = 0

	if p100.social_link_id ~= nil and p100.social_link_id ~= "" then
		local v1338, v1339 = proto.writeTag(buf, n66, 1, proto.wireTypes.lengthDelimited)

		buf, n66 = proto.writeString(v1338, v1339, p100.social_link_id)
	end

	local buf37 = buffer.create(n66)

	buffer.copy(buf37, 0, buf, 0, n66)

	return buf37
end
function t155.decode(p101: buffer) -- line: 9704
	-- upvalues: t155 (copy), proto (copy)
	local v1342 = t155.new()
	local n67 = 0

	while n67 < buffer.len(p101) do
		local v1344, v1345

		v1344, v1345, n67 = proto.readTag(p101, n67)

		if v1345 == proto.wireTypes.varint then
			local v1346

			v1346, n67 = proto.readVarInt(p101, n67)
		elseif v1345 == proto.wireTypes.lengthDelimited then
			if v1344 == 1 then
				local v1347

				v1347, n67 = proto.readBuffer(p101, n67)
				v1342.social_link_id = buffer.tostring(v1347)
			else
				local v1348, v1349 = proto.readVarInt(p101, n67)

				n67 = v1349 + v1348
			end
		elseif v1345 == proto.wireTypes.i32 then
			local v1350

			v1350, n67 = proto.readFixed32(p101, n67)
		elseif v1345 == proto.wireTypes.i64 then
			local v1351

			v1351, n67 = proto.readFixed64(p101, n67)
		else
			error("Unsupported wire type: " .. v1345)
		end
	end

	return v1342
end
function t155.jsonEncode(p102) -- line: 9747
	local t157 = {}

	if p102.social_link_id ~= nil and p102.social_link_id ~= "" then
		t157.socialLinkId = p102.social_link_id
	end

	return t157
end
function t155.jsonDecode(t158: {[any]: any}) -- line: 9757
	-- upvalues: t155 (copy)
	local v1355 = t155.new()

	if t158.social_link_id ~= nil then
		v1355.social_link_id = t158.social_link_id
	end

	if t158.socialLinkId ~= nil then
		v1355.social_link_id = t158.socialLinkId
	end

	return v1355
end

t155.descriptor = {
	name = "SocialLinkRowInputData_SocialLinkItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.SocialLinkItem"
}
t1.SocialLinkRowInputData_SocialLinkItem = t155
typeRegistry.default:register(t1.SocialLinkRowInputData_SocialLinkItem)

local t159 = {}

t159.__index = t159

function t159.new(t160: {[any]: any}?) -- line: 9787
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
		pool_id = if t160 ~= nil and t160.pool_id ~= nil then t160.pool_id else nil
	}, t159))
end
function t159.encode(p103) -- line: 9807
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n68 = 0

	if p103.title ~= nil and p103.title ~= "" then
		local v1360, v1361 = proto.writeTag(buf, n68, 1, proto.wireTypes.lengthDelimited)

		buf, n68 = proto.writeString(v1360, v1361, p103.title)
	end

	if p103.universe_items ~= nil and #p103.universe_items > 0 then
		for _, v1363 in p103.universe_items do
			local v1364 = v1363:encode()
			local v1365, v1366 = proto.writeTag(buf, n68, 2, proto.wireTypes.lengthDelimited)

			buf, n68 = proto.writeBuffer(v1365, v1366, v1364, buffer.len(v1364))
		end
	end

	if p103.next_page_token ~= nil and p103.next_page_token ~= "" then
		local v1367, v1368 = proto.writeTag(buf, n68, 3, proto.wireTypes.lengthDelimited)

		buf, n68 = proto.writeString(v1367, v1368, p103.next_page_token)
	end

	if p103.sort_id ~= nil and p103.sort_id ~= "" then
		local v1369, v1370 = proto.writeTag(buf, n68, 4, proto.wireTypes.lengthDelimited)

		buf, n68 = proto.writeString(v1369, v1370, p103.sort_id)
	end

	if p103.secondary_sort_id ~= nil and p103.secondary_sort_id ~= 0 then
		local v1371, v1372 = proto.writeTag(buf, n68, 5, proto.wireTypes.varint)

		buf, n68 = proto.writeVarInt(v1371, v1372, p103.secondary_sort_id)
	end

	if p103.max_visible_rows ~= nil and p103.max_visible_rows ~= 0 then
		local v1373, v1374 = proto.writeTag(buf, n68, 6, proto.wireTypes.varint)

		buf, n68 = proto.writeVarInt(v1373, v1374, p103.max_visible_rows)
	end

	if p103.subtitle ~= nil and p103.subtitle ~= "" then
		local v1375, v1376 = proto.writeTag(buf, n68, 7, proto.wireTypes.lengthDelimited)

		buf, n68 = proto.writeString(v1375, v1376, p103.subtitle)
	end

	if p103.info_text ~= nil and p103.info_text ~= "" then
		local v1377, v1378 = proto.writeTag(buf, n68, 8, proto.wireTypes.lengthDelimited)

		buf, n68 = proto.writeString(v1377, v1378, p103.info_text)
	end

	if p103.subtitle_link_path ~= nil and p103.subtitle_link_path ~= "" then
		local v1379, v1380 = proto.writeTag(buf, n68, 9, proto.wireTypes.lengthDelimited)

		buf, n68 = proto.writeString(v1379, v1380, p103.subtitle_link_path)
	end

	if p103.is_placeholder ~= nil then
		local v1381, v1382 = proto.writeTag(buf, n68, 10, proto.wireTypes.varint)

		buf, n68 = proto.writeVarInt(v1381, v1382, not p103.is_placeholder and 0 or 1)
	end

	if p103.primary_sort_id ~= nil then
		local v1383, v1384 = proto.writeTag(buf, n68, 11, proto.wireTypes.varint)

		buf, n68 = proto.writeVarInt(v1383, v1384, p103.primary_sort_id)
	end

	if p103.applied_filters ~= nil then
		local v1385, v1386 = proto.writeTag(buf, n68, 12, proto.wireTypes.lengthDelimited)

		buf, n68 = proto.writeString(v1385, v1386, p103.applied_filters)
	end

	if p103.pool_id ~= nil then
		local v1387, v1388 = proto.writeTag(buf, n68, 13, proto.wireTypes.lengthDelimited)

		buf, n68 = proto.writeString(v1387, v1388, p103.pool_id)
	end

	local buf38 = buffer.create(n68)

	buffer.copy(buf38, 0, buf, 0, n68)

	return buf38
end
function t159.decode(p104: buffer) -- line: 9884
	-- upvalues: t159 (copy), proto (copy), t1 (copy)
	local v1391 = t159.new()
	local n69 = 0

	while n69 < buffer.len(p104) do
		local v1393, v1394

		v1393, v1394, n69 = proto.readTag(p104, n69)

		if v1394 == proto.wireTypes.varint then
			if v1393 == 5 then
				local v1395

				v1395, n69 = proto.readVarIntI32(p104, n69)
				v1391.secondary_sort_id = v1395
			elseif v1393 == 6 then
				local v1396

				v1396, n69 = proto.readVarIntI32(p104, n69)
				v1391.max_visible_rows = v1396
			elseif v1393 == 10 then
				local v1397

				v1397, n69 = proto.readVarInt(p104, n69)
				v1391.is_placeholder = v1397 ~= 0
			elseif v1393 == 11 then
				local v1398

				v1398, n69 = proto.readVarIntI32(p104, n69)
				v1391.primary_sort_id = v1398
			else
				local v1399

				v1399, n69 = proto.readVarInt(p104, n69)
			end
		elseif v1394 == proto.wireTypes.lengthDelimited then
			if v1393 == 1 then
				local v1400

				v1400, n69 = proto.readBuffer(p104, n69)
				v1391.title = buffer.tostring(v1400)
			elseif v1393 == 2 then
				local v1401

				v1401, n69 = proto.readBuffer(p104, n69)
				table.insert(v1391.universe_items, t1.ExperienceCarouselInputData_UniverseItem.decode(v1401))
			elseif v1393 == 3 then
				local v1402

				v1402, n69 = proto.readBuffer(p104, n69)
				v1391.next_page_token = buffer.tostring(v1402)
			elseif v1393 == 4 then
				local v1403

				v1403, n69 = proto.readBuffer(p104, n69)
				v1391.sort_id = buffer.tostring(v1403)
			elseif v1393 == 7 then
				local v1404

				v1404, n69 = proto.readBuffer(p104, n69)
				v1391.subtitle = buffer.tostring(v1404)
			elseif v1393 == 8 then
				local v1405

				v1405, n69 = proto.readBuffer(p104, n69)
				v1391.info_text = buffer.tostring(v1405)
			elseif v1393 == 9 then
				local v1406

				v1406, n69 = proto.readBuffer(p104, n69)
				v1391.subtitle_link_path = buffer.tostring(v1406)
			elseif v1393 == 12 then
				local v1407

				v1407, n69 = proto.readBuffer(p104, n69)
				v1391.applied_filters = buffer.tostring(v1407)
			elseif v1393 == 13 then
				local v1408

				v1408, n69 = proto.readBuffer(p104, n69)
				v1391.pool_id = buffer.tostring(v1408)
			else
				local v1409, v1410 = proto.readVarInt(p104, n69)

				n69 = v1410 + v1409
			end
		elseif v1394 == proto.wireTypes.i32 then
			local v1411

			v1411, n69 = proto.readFixed32(p104, n69)
		elseif v1394 == proto.wireTypes.i64 then
			local v1412

			v1412, n69 = proto.readFixed64(p104, n69)
		else
			error("Unsupported wire type: " .. v1394)
		end
	end

	return v1391
end
function t159.jsonEncode(p105) -- line: 9987
	local t161 = {}

	if p105.title ~= nil and p105.title ~= "" then
		t161.title = p105.title
	end

	if p105.universe_items ~= nil and #p105.universe_items > 0 then
		local t162 = {}

		for _, v1417 in p105.universe_items do
			table.insert(t162, v1417:jsonEncode())
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

	return t161
end
function t159.jsonDecode(t163: {[any]: any}) -- line: 10049
	-- upvalues: t159 (copy), t1 (copy)
	local v1419 = t159.new()

	if t163.title ~= nil then
		v1419.title = t163.title
	end

	if t163.universe_items ~= nil then
		local t164 = {}

		for _, v1422 in t163.universe_items do
			table.insert(t164, t1.ExperienceCarouselInputData_UniverseItem.jsonDecode(v1422))
		end

		v1419.universe_items = t164
	end

	if t163.universeItems ~= nil then
		local t165 = {}

		for _, v1425 in t163.universeItems do
			table.insert(t165, t1.ExperienceCarouselInputData_UniverseItem.jsonDecode(v1425))
		end

		v1419.universe_items = t165
	end

	if t163.next_page_token ~= nil then
		v1419.next_page_token = t163.next_page_token
	end

	if t163.nextPageToken ~= nil then
		v1419.next_page_token = t163.nextPageToken
	end

	if t163.sort_id ~= nil then
		v1419.sort_id = t163.sort_id
	end

	if t163.sortId ~= nil then
		v1419.sort_id = t163.sortId
	end

	if t163.secondary_sort_id ~= nil then
		v1419.secondary_sort_id = t163.secondary_sort_id
	end

	if t163.secondarySortId ~= nil then
		v1419.secondary_sort_id = t163.secondarySortId
	end

	if t163.max_visible_rows ~= nil then
		v1419.max_visible_rows = t163.max_visible_rows
	end

	if t163.maxVisibleRows ~= nil then
		v1419.max_visible_rows = t163.maxVisibleRows
	end

	if t163.subtitle ~= nil then
		v1419.subtitle = t163.subtitle
	end

	if t163.info_text ~= nil then
		v1419.info_text = t163.info_text
	end

	if t163.infoText ~= nil then
		v1419.info_text = t163.infoText
	end

	if t163.subtitle_link_path ~= nil then
		v1419.subtitle_link_path = t163.subtitle_link_path
	end

	if t163.subtitleLinkPath ~= nil then
		v1419.subtitle_link_path = t163.subtitleLinkPath
	end

	if t163.is_placeholder ~= nil then
		v1419.is_placeholder = t163.is_placeholder
	end

	if t163.isPlaceholder ~= nil then
		v1419.is_placeholder = t163.isPlaceholder
	end

	if t163.primary_sort_id ~= nil then
		v1419.primary_sort_id = t163.primary_sort_id
	end

	if t163.primarySortId ~= nil then
		v1419.primary_sort_id = t163.primarySortId
	end

	if t163.applied_filters ~= nil then
		v1419.applied_filters = t163.applied_filters
	end

	if t163.appliedFilters ~= nil then
		v1419.applied_filters = t163.appliedFilters
	end

	if t163.pool_id ~= nil then
		v1419.pool_id = t163.pool_id
	end

	if t163.poolId ~= nil then
		v1419.pool_id = t163.poolId
	end

	return v1419
end

t159.descriptor = {
	name = "ExperienceCarouselInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceCarouselInputData"
}
t1.ExperienceCarouselInputData = t159
typeRegistry.default:register(t1.ExperienceCarouselInputData)

local t166 = {}

t166.__index = t166

function t166.new(t167: {[any]: any}?) -- line: 10175
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
function t166.encode(p106) -- line: 10194
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n70 = 0

	if p106.universe_id ~= nil and p106.universe_id ~= "" then
		local v1430, v1431 = proto.writeTag(buf, n70, 1, proto.wireTypes.lengthDelimited)

		buf, n70 = proto.writeString(v1430, v1431, p106.universe_id)
	end

	if p106.is_sponsored then
		local v1432, v1433 = proto.writeTag(buf, n70, 2, proto.wireTypes.varint)

		buf, n70 = proto.writeVarInt(v1432, v1433, not p106.is_sponsored and 0 or 1)
	end

	if p106.roblox_component ~= nil and p106.roblox_component ~= "" then
		local v1434, v1435 = proto.writeTag(buf, n70, 3, proto.wireTypes.lengthDelimited)

		buf, n70 = proto.writeString(v1434, v1435, p106.roblox_component)
	end

	if p106.native_ad_data ~= nil and p106.native_ad_data ~= "" then
		local v1436, v1437 = proto.writeTag(buf, n70, 4, proto.wireTypes.lengthDelimited)

		buf, n70 = proto.writeString(v1436, v1437, p106.native_ad_data)
	end

	if p106.is_content_locked then
		local v1438, v1439 = proto.writeTag(buf, n70, 5, proto.wireTypes.varint)

		buf, n70 = proto.writeVarInt(v1438, v1439, not p106.is_content_locked and 0 or 1)
	end

	if p106.title ~= nil and p106.title ~= "" then
		local v1440, v1441 = proto.writeTag(buf, n70, 6, proto.wireTypes.lengthDelimited)

		buf, n70 = proto.writeString(v1440, v1441, p106.title)
	end

	if p106.subtitle ~= nil and p106.subtitle ~= "" then
		local v1442, v1443 = proto.writeTag(buf, n70, 7, proto.wireTypes.lengthDelimited)

		buf, n70 = proto.writeString(v1442, v1443, p106.subtitle)
	end

	if p106.image_asset_id ~= nil and p106.image_asset_id ~= "" then
		local v1444, v1445 = proto.writeTag(buf, n70, 8, proto.wireTypes.lengthDelimited)

		buf, n70 = proto.writeString(v1444, v1445, p106.image_asset_id)
	end

	if p106.video_asset_id ~= nil and p106.video_asset_id ~= "" then
		local v1446, v1447 = proto.writeTag(buf, n70, 9, proto.wireTypes.lengthDelimited)

		buf, n70 = proto.writeString(v1446, v1447, p106.video_asset_id)
	end

	if p106.badge_text ~= nil and p106.badge_text ~= "" then
		local v1448, v1449 = proto.writeTag(buf, n70, 10, proto.wireTypes.lengthDelimited)

		buf, n70 = proto.writeString(v1448, v1449, p106.badge_text)
	end

	if p106.player_count ~= nil then
		local v1450, v1451 = proto.writeTag(buf, n70, 11, proto.wireTypes.varint)

		buf, n70 = proto.writeVarInt(v1450, v1451, p106.player_count)
	end

	if p106.creator_key ~= nil and p106.creator_key ~= "" then
		local v1452, v1453 = proto.writeTag(buf, n70, 12, proto.wireTypes.lengthDelimited)

		buf, n70 = proto.writeString(v1452, v1453, p106.creator_key)
	end

	local buf39 = buffer.create(n70)

	buffer.copy(buf39, 0, buf, 0, n70)

	return buf39
end
function t166.decode(p107: buffer) -- line: 10265
	-- upvalues: t166 (copy), proto (copy)
	local v1456 = t166.new()
	local n71 = 0

	while n71 < buffer.len(p107) do
		local v1458, v1459

		v1458, v1459, n71 = proto.readTag(p107, n71)

		if v1459 == proto.wireTypes.varint then
			if v1458 == 2 then
				local v1460

				v1460, n71 = proto.readVarInt(p107, n71)
				v1456.is_sponsored = v1460 ~= 0
			elseif v1458 == 5 then
				local v1461

				v1461, n71 = proto.readVarInt(p107, n71)
				v1456.is_content_locked = v1461 ~= 0
			elseif v1458 == 11 then
				local v1462

				v1462, n71 = proto.readVarIntI64(p107, n71)
				v1456.player_count = v1462
			else
				local v1463

				v1463, n71 = proto.readVarInt(p107, n71)
			end
		elseif v1459 == proto.wireTypes.lengthDelimited then
			if v1458 == 1 then
				local v1464

				v1464, n71 = proto.readBuffer(p107, n71)
				v1456.universe_id = buffer.tostring(v1464)
			elseif v1458 == 3 then
				local v1465

				v1465, n71 = proto.readBuffer(p107, n71)
				v1456.roblox_component = buffer.tostring(v1465)
			elseif v1458 == 4 then
				local v1466

				v1466, n71 = proto.readBuffer(p107, n71)
				v1456.native_ad_data = buffer.tostring(v1466)
			elseif v1458 == 6 then
				local v1467

				v1467, n71 = proto.readBuffer(p107, n71)
				v1456.title = buffer.tostring(v1467)
			elseif v1458 == 7 then
				local v1468

				v1468, n71 = proto.readBuffer(p107, n71)
				v1456.subtitle = buffer.tostring(v1468)
			elseif v1458 == 8 then
				local v1469

				v1469, n71 = proto.readBuffer(p107, n71)
				v1456.image_asset_id = buffer.tostring(v1469)
			elseif v1458 == 9 then
				local v1470

				v1470, n71 = proto.readBuffer(p107, n71)
				v1456.video_asset_id = buffer.tostring(v1470)
			elseif v1458 == 10 then
				local v1471

				v1471, n71 = proto.readBuffer(p107, n71)
				v1456.badge_text = buffer.tostring(v1471)
			elseif v1458 == 12 then
				local v1472

				v1472, n71 = proto.readBuffer(p107, n71)
				v1456.creator_key = buffer.tostring(v1472)
			else
				local v1473, v1474 = proto.readVarInt(p107, n71)

				n71 = v1474 + v1473
			end
		elseif v1459 == proto.wireTypes.i32 then
			local v1475

			v1475, n71 = proto.readFixed32(p107, n71)
		elseif v1459 == proto.wireTypes.i64 then
			local v1476

			v1476, n71 = proto.readFixed64(p107, n71)
		else
			error("Unsupported wire type: " .. v1459)
		end
	end

	return v1456
end
function t166.jsonEncode(p108) -- line: 10365
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
function t166.jsonDecode(t169: {[any]: any}) -- line: 10421
	-- upvalues: t166 (copy)
	local v1480 = t166.new()

	if t169.universe_id ~= nil then
		v1480.universe_id = t169.universe_id
	end

	if t169.universeId ~= nil then
		v1480.universe_id = t169.universeId
	end

	if t169.is_sponsored ~= nil then
		v1480.is_sponsored = t169.is_sponsored
	end

	if t169.isSponsored ~= nil then
		v1480.is_sponsored = t169.isSponsored
	end

	if t169.roblox_component ~= nil then
		v1480.roblox_component = t169.roblox_component
	end

	if t169.robloxComponent ~= nil then
		v1480.roblox_component = t169.robloxComponent
	end

	if t169.native_ad_data ~= nil then
		v1480.native_ad_data = t169.native_ad_data
	end

	if t169.nativeAdData ~= nil then
		v1480.native_ad_data = t169.nativeAdData
	end

	if t169.is_content_locked ~= nil then
		v1480.is_content_locked = t169.is_content_locked
	end

	if t169.isContentLocked ~= nil then
		v1480.is_content_locked = t169.isContentLocked
	end

	if t169.title ~= nil then
		v1480.title = t169.title
	end

	if t169.subtitle ~= nil then
		v1480.subtitle = t169.subtitle
	end

	if t169.image_asset_id ~= nil then
		v1480.image_asset_id = t169.image_asset_id
	end

	if t169.imageAssetId ~= nil then
		v1480.image_asset_id = t169.imageAssetId
	end

	if t169.video_asset_id ~= nil then
		v1480.video_asset_id = t169.video_asset_id
	end

	if t169.videoAssetId ~= nil then
		v1480.video_asset_id = t169.videoAssetId
	end

	if t169.badge_text ~= nil then
		v1480.badge_text = t169.badge_text
	end

	if t169.badgeText ~= nil then
		v1480.badge_text = t169.badgeText
	end

	if t169.player_count ~= nil then
		v1480.player_count = t169.player_count
	end

	if t169.playerCount ~= nil then
		v1480.player_count = t169.playerCount
	end

	if t169.creator_key ~= nil then
		v1480.creator_key = t169.creator_key
	end

	if t169.creatorKey ~= nil then
		v1480.creator_key = t169.creatorKey
	end

	return v1480
end

t166.descriptor = {
	name = "ExperienceCarouselInputData_UniverseItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniverseItem"
}
t1.ExperienceCarouselInputData_UniverseItem = t166
typeRegistry.default:register(t1.ExperienceCarouselInputData_UniverseItem)

local t170 = {}

t170.__index = t170

function t170.new(t171: {[any]: any}?) -- line: 10531
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
function t170.encode(p109) -- line: 10547
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n72 = 0

	if p109.title ~= nil and p109.title ~= "" then
		local v1485, v1486 = proto.writeTag(buf, n72, 1, proto.wireTypes.lengthDelimited)

		buf, n72 = proto.writeString(v1485, v1486, p109.title)
	end

	if p109.song_items ~= nil and #p109.song_items > 0 then
		for _, v1488 in p109.song_items do
			local v1489 = v1488:encode()
			local v1490, v1491 = proto.writeTag(buf, n72, 2, proto.wireTypes.lengthDelimited)

			buf, n72 = proto.writeBuffer(v1490, v1491, v1489, buffer.len(v1489))
		end
	end

	if p109.next_page_token ~= nil and p109.next_page_token ~= "" then
		local v1492, v1493 = proto.writeTag(buf, n72, 3, proto.wireTypes.lengthDelimited)

		buf, n72 = proto.writeString(v1492, v1493, p109.next_page_token)
	end

	if p109.sort_id ~= nil and p109.sort_id ~= "" then
		local v1494, v1495 = proto.writeTag(buf, n72, 4, proto.wireTypes.lengthDelimited)

		buf, n72 = proto.writeString(v1494, v1495, p109.sort_id)
	end

	if p109.secondary_sort_id ~= nil and p109.secondary_sort_id ~= 0 then
		local v1496, v1497 = proto.writeTag(buf, n72, 5, proto.wireTypes.varint)

		buf, n72 = proto.writeVarInt(v1496, v1497, p109.secondary_sort_id)
	end

	if p109.subtitle ~= nil and p109.subtitle ~= "" then
		local v1498, v1499 = proto.writeTag(buf, n72, 6, proto.wireTypes.lengthDelimited)

		buf, n72 = proto.writeString(v1498, v1499, p109.subtitle)
	end

	if p109.info_text ~= nil and p109.info_text ~= "" then
		local v1500, v1501 = proto.writeTag(buf, n72, 7, proto.wireTypes.lengthDelimited)

		buf, n72 = proto.writeString(v1500, v1501, p109.info_text)
	end

	if p109.subtitle_link_path ~= nil and p109.subtitle_link_path ~= "" then
		local v1502, v1503 = proto.writeTag(buf, n72, 8, proto.wireTypes.lengthDelimited)

		buf, n72 = proto.writeString(v1502, v1503, p109.subtitle_link_path)
	end

	if p109.is_placeholder ~= nil then
		local v1504, v1505 = proto.writeTag(buf, n72, 9, proto.wireTypes.varint)

		buf, n72 = proto.writeVarInt(v1504, v1505, not p109.is_placeholder and 0 or 1)
	end

	if p109.primary_sort_id ~= nil then
		local v1506, v1507 = proto.writeTag(buf, n72, 10, proto.wireTypes.varint)

		buf, n72 = proto.writeVarInt(v1506, v1507, p109.primary_sort_id)
	end

	if p109.applied_filters ~= nil then
		local v1508, v1509 = proto.writeTag(buf, n72, 11, proto.wireTypes.lengthDelimited)

		buf, n72 = proto.writeString(v1508, v1509, p109.applied_filters)
	end

	local buf40 = buffer.create(n72)

	buffer.copy(buf40, 0, buf, 0, n72)

	return buf40
end
function t170.decode(p110: buffer) -- line: 10614
	-- upvalues: t170 (copy), proto (copy), t1 (copy)
	local v1512 = t170.new()
	local n73 = 0

	while n73 < buffer.len(p110) do
		local v1514, v1515

		v1514, v1515, n73 = proto.readTag(p110, n73)

		if v1515 == proto.wireTypes.varint then
			if v1514 == 5 then
				local v1516

				v1516, n73 = proto.readVarIntI32(p110, n73)
				v1512.secondary_sort_id = v1516
			elseif v1514 == 9 then
				local v1517

				v1517, n73 = proto.readVarInt(p110, n73)
				v1512.is_placeholder = v1517 ~= 0
			elseif v1514 == 10 then
				local v1518

				v1518, n73 = proto.readVarIntI32(p110, n73)
				v1512.primary_sort_id = v1518
			else
				local v1519

				v1519, n73 = proto.readVarInt(p110, n73)
			end
		elseif v1515 == proto.wireTypes.lengthDelimited then
			if v1514 == 1 then
				local v1520

				v1520, n73 = proto.readBuffer(p110, n73)
				v1512.title = buffer.tostring(v1520)
			elseif v1514 == 2 then
				local v1521

				v1521, n73 = proto.readBuffer(p110, n73)
				table.insert(v1512.song_items, t1.SongCarouselInputData_SongItem.decode(v1521))
			elseif v1514 == 3 then
				local v1522

				v1522, n73 = proto.readBuffer(p110, n73)
				v1512.next_page_token = buffer.tostring(v1522)
			elseif v1514 == 4 then
				local v1523

				v1523, n73 = proto.readBuffer(p110, n73)
				v1512.sort_id = buffer.tostring(v1523)
			elseif v1514 == 6 then
				local v1524

				v1524, n73 = proto.readBuffer(p110, n73)
				v1512.subtitle = buffer.tostring(v1524)
			elseif v1514 == 7 then
				local v1525

				v1525, n73 = proto.readBuffer(p110, n73)
				v1512.info_text = buffer.tostring(v1525)
			elseif v1514 == 8 then
				local v1526

				v1526, n73 = proto.readBuffer(p110, n73)
				v1512.subtitle_link_path = buffer.tostring(v1526)
			elseif v1514 == 11 then
				local v1527

				v1527, n73 = proto.readBuffer(p110, n73)
				v1512.applied_filters = buffer.tostring(v1527)
			else
				local v1528, v1529 = proto.readVarInt(p110, n73)

				n73 = v1529 + v1528
			end
		elseif v1515 == proto.wireTypes.i32 then
			local v1530

			v1530, n73 = proto.readFixed32(p110, n73)
		elseif v1515 == proto.wireTypes.i64 then
			local v1531

			v1531, n73 = proto.readFixed64(p110, n73)
		else
			error("Unsupported wire type: " .. v1515)
		end
	end

	return v1512
end
function t170.jsonEncode(p111) -- line: 10707
	local t172 = {}

	if p111.title ~= nil and p111.title ~= "" then
		t172.title = p111.title
	end

	if p111.song_items ~= nil and #p111.song_items > 0 then
		local t173 = {}

		for _, v1536 in p111.song_items do
			table.insert(t173, v1536:jsonEncode())
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
function t170.jsonDecode(t174: {[any]: any}) -- line: 10761
	-- upvalues: t170 (copy), t1 (copy)
	local v1538 = t170.new()

	if t174.title ~= nil then
		v1538.title = t174.title
	end

	if t174.song_items ~= nil then
		local t175 = {}

		for _, v1541 in t174.song_items do
			table.insert(t175, t1.SongCarouselInputData_SongItem.jsonDecode(v1541))
		end

		v1538.song_items = t175
	end

	if t174.songItems ~= nil then
		local t176 = {}

		for _, v1544 in t174.songItems do
			table.insert(t176, t1.SongCarouselInputData_SongItem.jsonDecode(v1544))
		end

		v1538.song_items = t176
	end

	if t174.next_page_token ~= nil then
		v1538.next_page_token = t174.next_page_token
	end

	if t174.nextPageToken ~= nil then
		v1538.next_page_token = t174.nextPageToken
	end

	if t174.sort_id ~= nil then
		v1538.sort_id = t174.sort_id
	end

	if t174.sortId ~= nil then
		v1538.sort_id = t174.sortId
	end

	if t174.secondary_sort_id ~= nil then
		v1538.secondary_sort_id = t174.secondary_sort_id
	end

	if t174.secondarySortId ~= nil then
		v1538.secondary_sort_id = t174.secondarySortId
	end

	if t174.subtitle ~= nil then
		v1538.subtitle = t174.subtitle
	end

	if t174.info_text ~= nil then
		v1538.info_text = t174.info_text
	end

	if t174.infoText ~= nil then
		v1538.info_text = t174.infoText
	end

	if t174.subtitle_link_path ~= nil then
		v1538.subtitle_link_path = t174.subtitle_link_path
	end

	if t174.subtitleLinkPath ~= nil then
		v1538.subtitle_link_path = t174.subtitleLinkPath
	end

	if t174.is_placeholder ~= nil then
		v1538.is_placeholder = t174.is_placeholder
	end

	if t174.isPlaceholder ~= nil then
		v1538.is_placeholder = t174.isPlaceholder
	end

	if t174.primary_sort_id ~= nil then
		v1538.primary_sort_id = t174.primary_sort_id
	end

	if t174.primarySortId ~= nil then
		v1538.primary_sort_id = t174.primarySortId
	end

	if t174.applied_filters ~= nil then
		v1538.applied_filters = t174.applied_filters
	end

	if t174.appliedFilters ~= nil then
		v1538.applied_filters = t174.appliedFilters
	end

	return v1538
end

t170.descriptor = {
	name = "SongCarouselInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.SongCarouselInputData"
}
t1.SongCarouselInputData = t170
typeRegistry.default:register(t1.SongCarouselInputData)

local t177 = {}

t177.__index = t177

function t177.new(t178: {[any]: any}?) -- line: 10871
	-- upvalues: t177 (copy)
	return (setmetatable({
		song_id = if t178 ~= nil and t178.song_id ~= nil then t178.song_id else ""
	}, t177))
end
function t177.encode(p112) -- line: 10879
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n74 = 0

	if p112.song_id ~= nil and p112.song_id ~= "" then
		local v1549, v1550 = proto.writeTag(buf, n74, 1, proto.wireTypes.lengthDelimited)

		buf, n74 = proto.writeString(v1549, v1550, p112.song_id)
	end

	local buf41 = buffer.create(n74)

	buffer.copy(buf41, 0, buf, 0, n74)

	return buf41
end
function t177.decode(p113: buffer) -- line: 10893
	-- upvalues: t177 (copy), proto (copy)
	local v1553 = t177.new()
	local n75 = 0

	while n75 < buffer.len(p113) do
		local v1555, v1556

		v1555, v1556, n75 = proto.readTag(p113, n75)

		if v1556 == proto.wireTypes.varint then
			local v1557

			v1557, n75 = proto.readVarInt(p113, n75)
		elseif v1556 == proto.wireTypes.lengthDelimited then
			if v1555 == 1 then
				local v1558

				v1558, n75 = proto.readBuffer(p113, n75)
				v1553.song_id = buffer.tostring(v1558)
			else
				local v1559, v1560 = proto.readVarInt(p113, n75)

				n75 = v1560 + v1559
			end
		elseif v1556 == proto.wireTypes.i32 then
			local v1561

			v1561, n75 = proto.readFixed32(p113, n75)
		elseif v1556 == proto.wireTypes.i64 then
			local v1562

			v1562, n75 = proto.readFixed64(p113, n75)
		else
			error("Unsupported wire type: " .. v1556)
		end
	end

	return v1553
end
function t177.jsonEncode(p114) -- line: 10936
	local t179 = {}

	if p114.song_id ~= nil and p114.song_id ~= "" then
		t179.songId = p114.song_id
	end

	return t179
end
function t177.jsonDecode(t180: {[any]: any}) -- line: 10946
	-- upvalues: t177 (copy)
	local v1566 = t177.new()

	if t180.song_id ~= nil then
		v1566.song_id = t180.song_id
	end

	if t180.songId ~= nil then
		v1566.song_id = t180.songId
	end

	return v1566
end

t177.descriptor = {
	name = "SongCarouselInputData_SongItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.SongItem"
}
t1.SongCarouselInputData_SongItem = t177
typeRegistry.default:register(t1.SongCarouselInputData_SongItem)

local t181 = {}

t181.__index = t181

function t181.new(t182: {[any]: any}?) -- line: 10974
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
function t181.encode(p115) -- line: 10985
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n76 = 0

	if p115.title ~= nil and p115.title ~= "" then
		local v1571, v1572 = proto.writeTag(buf, n76, 1, proto.wireTypes.lengthDelimited)

		buf, n76 = proto.writeString(v1571, v1572, p115.title)
	end

	if p115.event_items ~= nil and #p115.event_items > 0 then
		for _, v1574 in p115.event_items do
			local v1575 = v1574:encode()
			local v1576, v1577 = proto.writeTag(buf, n76, 2, proto.wireTypes.lengthDelimited)

			buf, n76 = proto.writeBuffer(v1576, v1577, v1575, buffer.len(v1575))
		end
	end

	if p115.universe_id ~= nil and p115.universe_id ~= "" then
		local v1578, v1579 = proto.writeTag(buf, n76, 3, proto.wireTypes.lengthDelimited)

		buf, n76 = proto.writeString(v1578, v1579, p115.universe_id)
	end

	if p115.sort_id ~= nil and p115.sort_id ~= "" then
		local v1580, v1581 = proto.writeTag(buf, n76, 4, proto.wireTypes.lengthDelimited)

		buf, n76 = proto.writeString(v1580, v1581, p115.sort_id)
	end

	if p115.subtitle ~= nil and p115.subtitle ~= "" then
		local v1582, v1583 = proto.writeTag(buf, n76, 5, proto.wireTypes.lengthDelimited)

		buf, n76 = proto.writeString(v1582, v1583, p115.subtitle)
	end

	if p115.info_text ~= nil and p115.info_text ~= "" then
		local v1584, v1585 = proto.writeTag(buf, n76, 6, proto.wireTypes.lengthDelimited)

		buf, n76 = proto.writeString(v1584, v1585, p115.info_text)
	end

	local buf42 = buffer.create(n76)

	buffer.copy(buf42, 0, buf, 0, n76)

	return buf42
end
function t181.decode(p116: buffer) -- line: 11027
	-- upvalues: t181 (copy), proto (copy), t1 (copy)
	local v1588 = t181.new()
	local n77 = 0

	while n77 < buffer.len(p116) do
		local v1590, v1591

		v1590, v1591, n77 = proto.readTag(p116, n77)

		if v1591 == proto.wireTypes.varint then
			local v1592

			v1592, n77 = proto.readVarInt(p116, n77)
		elseif v1591 == proto.wireTypes.lengthDelimited then
			if v1590 == 1 then
				local v1593

				v1593, n77 = proto.readBuffer(p116, n77)
				v1588.title = buffer.tostring(v1593)
			elseif v1590 == 2 then
				local v1594

				v1594, n77 = proto.readBuffer(p116, n77)
				table.insert(v1588.event_items, t1.EventsCarouselInputData_EventItem.decode(v1594))
			elseif v1590 == 3 then
				local v1595

				v1595, n77 = proto.readBuffer(p116, n77)
				v1588.universe_id = buffer.tostring(v1595)
			elseif v1590 == 4 then
				local v1596

				v1596, n77 = proto.readBuffer(p116, n77)
				v1588.sort_id = buffer.tostring(v1596)
			elseif v1590 == 5 then
				local v1597

				v1597, n77 = proto.readBuffer(p116, n77)
				v1588.subtitle = buffer.tostring(v1597)
			elseif v1590 == 6 then
				local v1598

				v1598, n77 = proto.readBuffer(p116, n77)
				v1588.info_text = buffer.tostring(v1598)
			else
				local v1599, v1600 = proto.readVarInt(p116, n77)

				n77 = v1600 + v1599
			end
		elseif v1591 == proto.wireTypes.i32 then
			local v1601

			v1601, n77 = proto.readFixed32(p116, n77)
		elseif v1591 == proto.wireTypes.i64 then
			local v1602

			v1602, n77 = proto.readFixed64(p116, n77)
		else
			error("Unsupported wire type: " .. v1591)
		end
	end

	return v1588
end
function t181.jsonEncode(p117) -- line: 11095
	local t183 = {}

	if p117.title ~= nil and p117.title ~= "" then
		t183.title = p117.title
	end

	if p117.event_items ~= nil and #p117.event_items > 0 then
		local t184 = {}

		for _, v1607 in p117.event_items do
			table.insert(t184, v1607:jsonEncode())
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
function t181.jsonDecode(t185: {[any]: any}) -- line: 11129
	-- upvalues: t181 (copy), t1 (copy)
	local v1609 = t181.new()

	if t185.title ~= nil then
		v1609.title = t185.title
	end

	if t185.event_items ~= nil then
		local t186 = {}

		for _, v1612 in t185.event_items do
			table.insert(t186, t1.EventsCarouselInputData_EventItem.jsonDecode(v1612))
		end

		v1609.event_items = t186
	end

	if t185.eventItems ~= nil then
		local t187 = {}

		for _, v1615 in t185.eventItems do
			table.insert(t187, t1.EventsCarouselInputData_EventItem.jsonDecode(v1615))
		end

		v1609.event_items = t187
	end

	if t185.universe_id ~= nil then
		v1609.universe_id = t185.universe_id
	end

	if t185.universeId ~= nil then
		v1609.universe_id = t185.universeId
	end

	if t185.sort_id ~= nil then
		v1609.sort_id = t185.sort_id
	end

	if t185.sortId ~= nil then
		v1609.sort_id = t185.sortId
	end

	if t185.subtitle ~= nil then
		v1609.subtitle = t185.subtitle
	end

	if t185.info_text ~= nil then
		v1609.info_text = t185.info_text
	end

	if t185.infoText ~= nil then
		v1609.info_text = t185.infoText
	end

	return v1609
end

t181.descriptor = {
	name = "EventsCarouselInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventsCarouselInputData"
}
t1.EventsCarouselInputData = t181
typeRegistry.default:register(t1.EventsCarouselInputData)

local t188 = {}

t188.__index = t188

function t188.new(t189: {[any]: any}?) -- line: 11199
	-- upvalues: t188 (copy)
	return (setmetatable({
		event_id = if t189 ~= nil and t189.event_id ~= nil then t189.event_id else ""
	}, t188))
end
function t188.encode(p118) -- line: 11207
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n78 = 0

	if p118.event_id ~= nil and p118.event_id ~= "" then
		local v1620, v1621 = proto.writeTag(buf, n78, 1, proto.wireTypes.lengthDelimited)

		buf, n78 = proto.writeString(v1620, v1621, p118.event_id)
	end

	local buf43 = buffer.create(n78)

	buffer.copy(buf43, 0, buf, 0, n78)

	return buf43
end
function t188.decode(p119: buffer) -- line: 11221
	-- upvalues: t188 (copy), proto (copy)
	local v1624 = t188.new()
	local n79 = 0

	while n79 < buffer.len(p119) do
		local v1626, v1627

		v1626, v1627, n79 = proto.readTag(p119, n79)

		if v1627 == proto.wireTypes.varint then
			local v1628

			v1628, n79 = proto.readVarInt(p119, n79)
		elseif v1627 == proto.wireTypes.lengthDelimited then
			if v1626 == 1 then
				local v1629

				v1629, n79 = proto.readBuffer(p119, n79)
				v1624.event_id = buffer.tostring(v1629)
			else
				local v1630, v1631 = proto.readVarInt(p119, n79)

				n79 = v1631 + v1630
			end
		elseif v1627 == proto.wireTypes.i32 then
			local v1632

			v1632, n79 = proto.readFixed32(p119, n79)
		elseif v1627 == proto.wireTypes.i64 then
			local v1633

			v1633, n79 = proto.readFixed64(p119, n79)
		else
			error("Unsupported wire type: " .. v1627)
		end
	end

	return v1624
end
function t188.jsonEncode(p120) -- line: 11264
	local t190 = {}

	if p120.event_id ~= nil and p120.event_id ~= "" then
		t190.eventId = p120.event_id
	end

	return t190
end
function t188.jsonDecode(t191: {[any]: any}) -- line: 11274
	-- upvalues: t188 (copy)
	local v1637 = t188.new()

	if t191.event_id ~= nil then
		v1637.event_id = t191.event_id
	end

	if t191.eventId ~= nil then
		v1637.event_id = t191.eventId
	end

	return v1637
end

t188.descriptor = {
	name = "EventsCarouselInputData_EventItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventItem"
}
t1.EventsCarouselInputData_EventItem = t188
typeRegistry.default:register(t1.EventsCarouselInputData_EventItem)

local t192 = {}

t192.__index = t192

function t192.new(t193: {[any]: any}?) -- line: 11304
	-- upvalues: t192 (copy)
	return (setmetatable({
		universe_id = if t193 ~= nil and t193.universe_id ~= nil then t193.universe_id else "",
		entry_map = if t193 ~= nil and t193.entry_map ~= nil then t193.entry_map else {},
		entry_order = if t193 ~= nil and t193.entry_order ~= nil then t193.entry_order else {},
		creator_key = if t193 ~= nil and t193.creator_key ~= nil then t193.creator_key else ""
	}, t192))
end
function t192.encode(p121) -- line: 11313
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n80 = 0

	if p121.universe_id ~= nil and p121.universe_id ~= "" then
		local v1642, v1643 = proto.writeTag(buf, n80, 1, proto.wireTypes.lengthDelimited)

		buf, n80 = proto.writeString(v1642, v1643, p121.universe_id)
	end

	if p121.entry_map ~= nil and next(p121.entry_map) ~= nil then
		for v1644, v1645 in p121.entry_map do
			local buf44 = buffer.create(0)
			local v1647, v1648 = proto.writeTag(buf44, 0, 1, proto.wireTypes.lengthDelimited)
			local v1649, v1650 = proto.writeString(v1647, v1648, v1644)
			local v1651 = v1645:encode()
			local v1652, v1653 = proto.writeTag(v1649, v1650, 2, proto.wireTypes.lengthDelimited)
			local v1654, v1655 = proto.writeBuffer(v1652, v1653, v1651, buffer.len(v1651))
			local v1656, v1657 = proto.writeTag(buf, n80, 2, proto.wireTypes.lengthDelimited)

			buf, n80 = proto.writeBuffer(v1656, v1657, v1654, v1655)
		end
	end

	if p121.entry_order ~= nil and #p121.entry_order > 0 then
		for _, v1659 in p121.entry_order do
			local v1660, v1661 = proto.writeTag(buf, n80, 3, proto.wireTypes.lengthDelimited)

			buf, n80 = proto.writeString(v1660, v1661, v1659)
		end
	end

	if p121.creator_key ~= nil and p121.creator_key ~= "" then
		local v1662, v1663 = proto.writeTag(buf, n80, 4, proto.wireTypes.lengthDelimited)

		buf, n80 = proto.writeString(v1662, v1663, p121.creator_key)
	end

	local buf45 = buffer.create(n80)

	buffer.copy(buf45, 0, buf, 0, n80)

	return buf45
end
function t192.decode(p122: buffer) -- line: 11353
	-- upvalues: t192 (copy), proto (copy), t1 (copy)
	local v1666 = t192.new()
	local n81 = 0

	while n81 < buffer.len(p122) do
		local v1668, v1669

		v1668, v1669, n81 = proto.readTag(p122, n81)

		if v1669 == proto.wireTypes.varint then
			local v1670

			v1670, n81 = proto.readVarInt(p122, n81)
		elseif v1669 == proto.wireTypes.lengthDelimited then
			if v1668 == 1 then
				local v1671

				v1671, n81 = proto.readBuffer(p122, n81)
				v1666.universe_id = buffer.tostring(v1671)
			elseif v1668 == 2 then
				local v1672

				v1672, n81 = proto.readBuffer(p122, n81)

				local v1673 = t1.DevStoreFeedInputData_EntryMapEntry.decode(v1672)
				local v1674 = t1.FeedEntry.new()

				v1666.entry_map[v1673.key or ""] = v1673.value or v1674
			elseif v1668 == 3 then
				local v1675

				v1675, n81 = proto.readBuffer(p122, n81)
				table.insert(v1666.entry_order, buffer.tostring(v1675))
			elseif v1668 == 4 then
				local v1676

				v1676, n81 = proto.readBuffer(p122, n81)
				v1666.creator_key = buffer.tostring(v1676)
			else
				local v1677, v1678 = proto.readVarInt(p122, n81)

				n81 = v1678 + v1677
			end
		elseif v1669 == proto.wireTypes.i32 then
			local v1679

			v1679, n81 = proto.readFixed32(p122, n81)
		elseif v1669 == proto.wireTypes.i64 then
			local v1680

			v1680, n81 = proto.readFixed64(p122, n81)
		else
			error("Unsupported wire type: " .. v1669)
		end
	end

	return v1666
end
function t192.jsonEncode(p123) -- line: 11418
	local t194 = {}

	if p123.universe_id ~= nil and p123.universe_id ~= "" then
		t194.universeId = p123.universe_id
	end

	if p123.entry_map ~= nil and next(p123.entry_map) ~= nil then
		local t195 = {}

		for v1684, v1685 in p123.entry_map do
			t195[v1684] = v1685:jsonEncode()
		end

		t194.entryMap = t195
	end

	if p123.entry_order ~= nil and #p123.entry_order > 0 then
		local t196 = {}

		for _, v1688 in p123.entry_order do
			table.insert(t196, v1688)
		end

		t194.entryOrder = t196
	end

	if p123.creator_key ~= nil and p123.creator_key ~= "" then
		t194.creatorKey = p123.creator_key
	end

	return t194
end
function t192.jsonDecode(t197: {[any]: any}) -- line: 11448
	-- upvalues: t192 (copy), t1 (copy)
	local v1690 = t192.new()

	if t197.universe_id ~= nil then
		v1690.universe_id = t197.universe_id
	end

	if t197.universeId ~= nil then
		v1690.universe_id = t197.universeId
	end

	if t197.entry_map ~= nil then
		local t198 = {}

		for v1692, v1693 in t197.entry_map do
			t198[v1692] = t1.FeedEntry.jsonDecode(v1693)
		end

		v1690.entry_map = t198
	end

	if t197.entryMap ~= nil then
		local t199 = {}

		for v1695, v1696 in t197.entryMap do
			t199[v1695] = t1.FeedEntry.jsonDecode(v1696)
		end

		v1690.entry_map = t199
	end

	if t197.entry_order ~= nil then
		local t200 = {}

		for _, v1699 in t197.entry_order do
			table.insert(t200, v1699)
		end

		v1690.entry_order = t200
	end

	if t197.entryOrder ~= nil then
		local t201 = {}

		for _, v1702 in t197.entryOrder do
			table.insert(t201, v1702)
		end

		v1690.entry_order = t201
	end

	if t197.creator_key ~= nil then
		v1690.creator_key = t197.creator_key
	end

	if t197.creatorKey ~= nil then
		v1690.creator_key = t197.creatorKey
	end

	return v1690
end

t192.descriptor = {
	name = "DevStoreFeedInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.DevStoreFeedInputData"
}
t1.DevStoreFeedInputData = t192
typeRegistry.default:register(t1.DevStoreFeedInputData)

local t202 = {}

t202.__index = t202

function t202.new(t203: {[any]: any}?) -- line: 11520
	-- upvalues: t202 (copy)
	return (setmetatable({
		key = if t203 ~= nil and t203.key ~= nil then t203.key else "",
		value = if t203 ~= nil and t203.value ~= nil then t203.value else nil
	}, t202))
end
function t202.encode(p124) -- line: 11529
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n82 = 0

	if p124.key ~= nil and p124.key ~= "" then
		local v1707, v1708 = proto.writeTag(buf, n82, 1, proto.wireTypes.lengthDelimited)

		buf, n82 = proto.writeString(v1707, v1708, p124.key)
	end

	if p124.value ~= nil then
		local v1709 = p124.value:encode()
		local v1710, v1711 = proto.writeTag(buf, n82, 2, proto.wireTypes.lengthDelimited)

		buf, n82 = proto.writeBuffer(v1710, v1711, v1709, buffer.len(v1709))
	end

	local buf46 = buffer.create(n82)

	buffer.copy(buf46, 0, buf, 0, n82)

	return buf46
end
function t202.decode(p125: buffer) -- line: 11549
	-- upvalues: t202 (copy), proto (copy), t1 (copy)
	local v1714 = t202.new()
	local n83 = 0

	while n83 < buffer.len(p125) do
		local v1716, v1717

		v1716, v1717, n83 = proto.readTag(p125, n83)

		if v1717 == proto.wireTypes.varint then
			local v1718

			v1718, n83 = proto.readVarInt(p125, n83)
		elseif v1717 == proto.wireTypes.lengthDelimited then
			if v1716 == 1 then
				local v1719

				v1719, n83 = proto.readBuffer(p125, n83)
				v1714.key = buffer.tostring(v1719)
			elseif v1716 == 2 then
				local v1720

				v1720, n83 = proto.readBuffer(p125, n83)
				v1714.value = t1.FeedEntry.decode(v1720)
			else
				local v1721, v1722 = proto.readVarInt(p125, n83)

				n83 = v1722 + v1721
			end
		elseif v1717 == proto.wireTypes.i32 then
			local v1723

			v1723, n83 = proto.readFixed32(p125, n83)
		elseif v1717 == proto.wireTypes.i64 then
			local v1724

			v1724, n83 = proto.readFixed64(p125, n83)
		else
			error("Unsupported wire type: " .. v1717)
		end
	end

	return v1714
end
function t202.jsonEncode(p126) -- line: 11597
	local t204 = {}

	if p126.key ~= nil and p126.key ~= "" then
		t204.key = p126.key
	end

	if p126.value ~= nil then
		t204.value = p126.value:jsonEncode()
	end

	return t204
end
function t202.jsonDecode(t205: {[any]: any}) -- line: 11611
	-- upvalues: t202 (copy), t1 (copy)
	local v1728 = t202.new()

	if t205.key ~= nil then
		v1728.key = t205.key
	end

	if t205.value ~= nil then
		v1728.value = t1.FeedEntry.jsonDecode(t205.value)
	end

	return v1728
end

t202.descriptor = {
	name = "DevStoreFeedInputData_EntryMapEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryMapEntry"
}
t1.DevStoreFeedInputData_EntryMapEntry = t202
typeRegistry.default:register(t1.DevStoreFeedInputData_EntryMapEntry)

local t206 = {}

t206.__index = t206

function t206.new(t207: {[any]: any}?) -- line: 11641
	-- upvalues: t206 (copy)
	return (setmetatable({
		game_passes = if t207 ~= nil and t207.game_passes ~= nil then t207.game_passes else {}
	}, t206))
end
function t206.encode(p127) -- line: 11649
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n84 = 0

	if p127.game_passes ~= nil and #p127.game_passes > 0 then
		for _, v1734 in p127.game_passes do
			local v1735 = v1734:encode()
			local v1736, v1737 = proto.writeTag(buf, n84, 1, proto.wireTypes.lengthDelimited)

			buf, n84 = proto.writeBuffer(v1736, v1737, v1735, buffer.len(v1735))
		end
	end

	local buf47 = buffer.create(n84)

	buffer.copy(buf47, 0, buf, 0, n84)

	return buf47
end
function t206.decode(p128: buffer) -- line: 11666
	-- upvalues: t206 (copy), proto (copy), t1 (copy)
	local v1740 = t206.new()
	local n85 = 0

	while n85 < buffer.len(p128) do
		local v1742, v1743

		v1742, v1743, n85 = proto.readTag(p128, n85)

		if v1743 == proto.wireTypes.varint then
			local v1744

			v1744, n85 = proto.readVarInt(p128, n85)
		elseif v1743 == proto.wireTypes.lengthDelimited then
			if v1742 == 1 then
				local v1745

				v1745, n85 = proto.readBuffer(p128, n85)
				table.insert(v1740.game_passes, t1.GamePassCollectionInputData_GamePassItem.decode(v1745))
			else
				local v1746, v1747 = proto.readVarInt(p128, n85)

				n85 = v1747 + v1746
			end
		elseif v1743 == proto.wireTypes.i32 then
			local v1748

			v1748, n85 = proto.readFixed32(p128, n85)
		elseif v1743 == proto.wireTypes.i64 then
			local v1749

			v1749, n85 = proto.readFixed64(p128, n85)
		else
			error("Unsupported wire type: " .. v1743)
		end
	end

	return v1740
end
function t206.jsonEncode(p129) -- line: 11709
	local t208 = {}

	if p129.game_passes ~= nil and #p129.game_passes > 0 then
		local t209 = {}

		for _, v1754 in p129.game_passes do
			table.insert(t209, v1754:jsonEncode())
		end

		t208.gamePasses = t209
	end

	return t208
end
function t206.jsonDecode(t210: {[any]: any}) -- line: 11723
	-- upvalues: t206 (copy), t1 (copy)
	local v1756 = t206.new()

	if t210.game_passes ~= nil then
		local t211 = {}

		for _, v1759 in t210.game_passes do
			table.insert(t211, t1.GamePassCollectionInputData_GamePassItem.jsonDecode(v1759))
		end

		v1756.game_passes = t211
	end

	if t210.gamePasses ~= nil then
		local t212 = {}

		for _, v1762 in t210.gamePasses do
			table.insert(t212, t1.GamePassCollectionInputData_GamePassItem.jsonDecode(v1762))
		end

		v1756.game_passes = t212
	end

	return v1756
end

t206.descriptor = {
	name = "GamePassCollectionInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.GamePassCollectionInputData"
}
t1.GamePassCollectionInputData = t206
typeRegistry.default:register(t1.GamePassCollectionInputData)

local t213 = {}

t213.__index = t213

function t213.new(t214: {[any]: any}?) -- line: 11761
	-- upvalues: t213 (copy)
	return (setmetatable({
		game_pass_id = if t214 ~= nil and t214.game_pass_id ~= nil then t214.game_pass_id else ""
	}, t213))
end
function t213.encode(p130) -- line: 11769
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n86 = 0

	if p130.game_pass_id ~= nil and p130.game_pass_id ~= "" then
		local v1767, v1768 = proto.writeTag(buf, n86, 1, proto.wireTypes.lengthDelimited)

		buf, n86 = proto.writeString(v1767, v1768, p130.game_pass_id)
	end

	local buf48 = buffer.create(n86)

	buffer.copy(buf48, 0, buf, 0, n86)

	return buf48
end
function t213.decode(p131: buffer) -- line: 11785
	-- upvalues: t213 (copy), proto (copy)
	local v1771 = t213.new()
	local n87 = 0

	while n87 < buffer.len(p131) do
		local v1773, v1774

		v1773, v1774, n87 = proto.readTag(p131, n87)

		if v1774 == proto.wireTypes.varint then
			local v1775

			v1775, n87 = proto.readVarInt(p131, n87)
		elseif v1774 == proto.wireTypes.lengthDelimited then
			if v1773 == 1 then
				local v1776

				v1776, n87 = proto.readBuffer(p131, n87)
				v1771.game_pass_id = buffer.tostring(v1776)
			else
				local v1777, v1778 = proto.readVarInt(p131, n87)

				n87 = v1778 + v1777
			end
		elseif v1774 == proto.wireTypes.i32 then
			local v1779

			v1779, n87 = proto.readFixed32(p131, n87)
		elseif v1774 == proto.wireTypes.i64 then
			local v1780

			v1780, n87 = proto.readFixed64(p131, n87)
		else
			error("Unsupported wire type: " .. v1774)
		end
	end

	return v1771
end
function t213.jsonEncode(p132) -- line: 11830
	local t215 = {}

	if p132.game_pass_id ~= nil and p132.game_pass_id ~= "" then
		t215.gamePassId = p132.game_pass_id
	end

	return t215
end
function t213.jsonDecode(t216: {[any]: any}) -- line: 11842
	-- upvalues: t213 (copy)
	local v1784 = t213.new()

	if t216.game_pass_id ~= nil then
		v1784.game_pass_id = t216.game_pass_id
	end

	if t216.gamePassId ~= nil then
		v1784.game_pass_id = t216.gamePassId
	end

	return v1784
end

t213.descriptor = {
	name = "GamePassCollectionInputData_GamePassItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.GamePassItem"
}
t1.GamePassCollectionInputData_GamePassItem = t213
typeRegistry.default:register(t1.GamePassCollectionInputData_GamePassItem)

local t217 = {}

t217.__index = t217

function t217.new(t218: {[any]: any}?) -- line: 11872
	-- upvalues: t217 (copy)
	return (setmetatable({
		developer_products = if t218 ~= nil and t218.developer_products ~= nil then t218.developer_products else {}
	}, t217))
end
function t217.encode(p133) -- line: 11880
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n88 = 0

	if p133.developer_products ~= nil and #p133.developer_products > 0 then
		for _, v1790 in p133.developer_products do
			local v1791 = v1790:encode()
			local v1792, v1793 = proto.writeTag(buf, n88, 1, proto.wireTypes.lengthDelimited)

			buf, n88 = proto.writeBuffer(v1792, v1793, v1791, buffer.len(v1791))
		end
	end

	local buf49 = buffer.create(n88)

	buffer.copy(buf49, 0, buf, 0, n88)

	return buf49
end
function t217.decode(p134: buffer) -- line: 11897
	-- upvalues: t217 (copy), proto (copy), t1 (copy)
	local v1796 = t217.new()
	local n89 = 0

	while n89 < buffer.len(p134) do
		local v1798, v1799

		v1798, v1799, n89 = proto.readTag(p134, n89)

		if v1799 == proto.wireTypes.varint then
			local v1800

			v1800, n89 = proto.readVarInt(p134, n89)
		elseif v1799 == proto.wireTypes.lengthDelimited then
			if v1798 == 1 then
				local v1801

				v1801, n89 = proto.readBuffer(p134, n89)
				table.insert(v1796.developer_products, t1.DeveloperProductCollectionInputData_DeveloperProductItem.decode(v1801))
			else
				local v1802, v1803 = proto.readVarInt(p134, n89)

				n89 = v1803 + v1802
			end
		elseif v1799 == proto.wireTypes.i32 then
			local v1804

			v1804, n89 = proto.readFixed32(p134, n89)
		elseif v1799 == proto.wireTypes.i64 then
			local v1805

			v1805, n89 = proto.readFixed64(p134, n89)
		else
			error("Unsupported wire type: " .. v1799)
		end
	end

	return v1796
end
function t217.jsonEncode(p135) -- line: 11943
	local t219 = {}

	if p135.developer_products ~= nil and #p135.developer_products > 0 then
		local t220 = {}

		for _, v1810 in p135.developer_products do
			table.insert(t220, v1810:jsonEncode())
		end

		t219.developerProducts = t220
	end

	return t219
end
function t217.jsonDecode(t221: {[any]: any}) -- line: 11957
	-- upvalues: t217 (copy), t1 (copy)
	local v1812 = t217.new()

	if t221.developer_products ~= nil then
		local t222 = {}

		for _, v1815 in t221.developer_products do
			table.insert(t222, t1.DeveloperProductCollectionInputData_DeveloperProductItem.jsonDecode(v1815))
		end

		v1812.developer_products = t222
	end

	if t221.developerProducts ~= nil then
		local t223 = {}

		for _, v1818 in t221.developerProducts do
			table.insert(t223, t1.DeveloperProductCollectionInputData_DeveloperProductItem.jsonDecode(v1818))
		end

		v1812.developer_products = t223
	end

	return v1812
end

t217.descriptor = {
	name = "DeveloperProductCollectionInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.DeveloperProductCollectionInputData"
}
t1.DeveloperProductCollectionInputData = t217
typeRegistry.default:register(t1.DeveloperProductCollectionInputData)

local t224 = {}

t224.__index = t224

function t224.new(t225: {[any]: any}?) -- line: 12004
	-- upvalues: t224 (copy)
	return (setmetatable({
		developer_product_id = if t225 ~= nil and t225.developer_product_id ~= nil then t225.developer_product_id else ""
	}, t224))
end
function t224.encode(p136) -- line: 12017
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n90 = 0

	if p136.developer_product_id ~= nil and p136.developer_product_id ~= "" then
		local v1823, v1824 = proto.writeTag(buf, n90, 1, proto.wireTypes.lengthDelimited)

		buf, n90 = proto.writeString(v1823, v1824, p136.developer_product_id)
	end

	local buf50 = buffer.create(n90)

	buffer.copy(buf50, 0, buf, 0, n90)

	return buf50
end
function t224.decode(p137: buffer) -- line: 12033
	-- upvalues: t224 (copy), proto (copy)
	local v1827 = t224.new()
	local n91 = 0

	while n91 < buffer.len(p137) do
		local v1829, v1830

		v1829, v1830, n91 = proto.readTag(p137, n91)

		if v1830 == proto.wireTypes.varint then
			local v1831

			v1831, n91 = proto.readVarInt(p137, n91)
		elseif v1830 == proto.wireTypes.lengthDelimited then
			if v1829 == 1 then
				local v1832

				v1832, n91 = proto.readBuffer(p137, n91)
				v1827.developer_product_id = buffer.tostring(v1832)
			else
				local v1833, v1834 = proto.readVarInt(p137, n91)

				n91 = v1834 + v1833
			end
		elseif v1830 == proto.wireTypes.i32 then
			local v1835

			v1835, n91 = proto.readFixed32(p137, n91)
		elseif v1830 == proto.wireTypes.i64 then
			local v1836

			v1836, n91 = proto.readFixed64(p137, n91)
		else
			error("Unsupported wire type: " .. v1830)
		end
	end

	return v1827
end
function t224.jsonEncode(p138) -- line: 12078
	local t226 = {}

	if p138.developer_product_id ~= nil and p138.developer_product_id ~= "" then
		t226.developerProductId = p138.developer_product_id
	end

	return t226
end
function t224.jsonDecode(t227: {[any]: any}) -- line: 12090
	-- upvalues: t224 (copy)
	local v1840 = t224.new()

	if t227.developer_product_id ~= nil then
		v1840.developer_product_id = t227.developer_product_id
	end

	if t227.developerProductId ~= nil then
		v1840.developer_product_id = t227.developerProductId
	end

	return v1840
end

t224.descriptor = {
	name = "DeveloperProductCollectionInputData_DeveloperProductItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.DeveloperProductItem"
}
t1.DeveloperProductCollectionInputData_DeveloperProductItem = t224
typeRegistry.default:register(t1.DeveloperProductCollectionInputData_DeveloperProductItem)

local t228 = {}

t228.__index = t228

function t228.new(t229: {[any]: any}?) -- line: 12121
	-- upvalues: t228 (copy)
	return (setmetatable({
		subscriptions = if t229 ~= nil and t229.subscriptions ~= nil then t229.subscriptions else {}
	}, t228))
end
function t228.encode(p139) -- line: 12129
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n92 = 0

	if p139.subscriptions ~= nil and #p139.subscriptions > 0 then
		for _, v1846 in p139.subscriptions do
			local v1847 = v1846:encode()
			local v1848, v1849 = proto.writeTag(buf, n92, 1, proto.wireTypes.lengthDelimited)

			buf, n92 = proto.writeBuffer(v1848, v1849, v1847, buffer.len(v1847))
		end
	end

	local buf51 = buffer.create(n92)

	buffer.copy(buf51, 0, buf, 0, n92)

	return buf51
end
function t228.decode(p140: buffer) -- line: 12146
	-- upvalues: t228 (copy), proto (copy), t1 (copy)
	local v1852 = t228.new()
	local n93 = 0

	while n93 < buffer.len(p140) do
		local v1854, v1855

		v1854, v1855, n93 = proto.readTag(p140, n93)

		if v1855 == proto.wireTypes.varint then
			local v1856

			v1856, n93 = proto.readVarInt(p140, n93)
		elseif v1855 == proto.wireTypes.lengthDelimited then
			if v1854 == 1 then
				local v1857

				v1857, n93 = proto.readBuffer(p140, n93)
				table.insert(v1852.subscriptions, t1.SubscriptionCollectionInputData_SubscriptionItem.decode(v1857))
			else
				local v1858, v1859 = proto.readVarInt(p140, n93)

				n93 = v1859 + v1858
			end
		elseif v1855 == proto.wireTypes.i32 then
			local v1860

			v1860, n93 = proto.readFixed32(p140, n93)
		elseif v1855 == proto.wireTypes.i64 then
			local v1861

			v1861, n93 = proto.readFixed64(p140, n93)
		else
			error("Unsupported wire type: " .. v1855)
		end
	end

	return v1852
end
function t228.jsonEncode(p141) -- line: 12192
	local t230 = {}

	if p141.subscriptions ~= nil and #p141.subscriptions > 0 then
		local t231 = {}

		for _, v1866 in p141.subscriptions do
			table.insert(t231, v1866:jsonEncode())
		end

		t230.subscriptions = t231
	end

	return t230
end
function t228.jsonDecode(t232: {[any]: any}) -- line: 12206
	-- upvalues: t228 (copy), t1 (copy)
	local v1868 = t228.new()

	if t232.subscriptions ~= nil then
		local t233 = {}

		for _, v1871 in t232.subscriptions do
			table.insert(t233, t1.SubscriptionCollectionInputData_SubscriptionItem.jsonDecode(v1871))
		end

		v1868.subscriptions = t233
	end

	return v1868
end

t228.descriptor = {
	name = "SubscriptionCollectionInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.SubscriptionCollectionInputData"
}
t1.SubscriptionCollectionInputData = t228
typeRegistry.default:register(t1.SubscriptionCollectionInputData)

local t234 = {}

t234.__index = t234

function t234.new(t235: {[any]: any}?) -- line: 12236
	-- upvalues: t234 (copy)
	return (setmetatable({
		subscription_id = if t235 ~= nil and t235.subscription_id ~= nil then t235.subscription_id else ""
	}, t234))
end
function t234.encode(p142) -- line: 12247
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n94 = 0

	if p142.subscription_id ~= nil and p142.subscription_id ~= "" then
		local v1876, v1877 = proto.writeTag(buf, n94, 1, proto.wireTypes.lengthDelimited)

		buf, n94 = proto.writeString(v1876, v1877, p142.subscription_id)
	end

	local buf52 = buffer.create(n94)

	buffer.copy(buf52, 0, buf, 0, n94)

	return buf52
end
function t234.decode(p143: buffer) -- line: 12263
	-- upvalues: t234 (copy), proto (copy)
	local v1880 = t234.new()
	local n95 = 0

	while n95 < buffer.len(p143) do
		local v1882, v1883

		v1882, v1883, n95 = proto.readTag(p143, n95)

		if v1883 == proto.wireTypes.varint then
			local v1884

			v1884, n95 = proto.readVarInt(p143, n95)
		elseif v1883 == proto.wireTypes.lengthDelimited then
			if v1882 == 1 then
				local v1885

				v1885, n95 = proto.readBuffer(p143, n95)
				v1880.subscription_id = buffer.tostring(v1885)
			else
				local v1886, v1887 = proto.readVarInt(p143, n95)

				n95 = v1887 + v1886
			end
		elseif v1883 == proto.wireTypes.i32 then
			local v1888

			v1888, n95 = proto.readFixed32(p143, n95)
		elseif v1883 == proto.wireTypes.i64 then
			local v1889

			v1889, n95 = proto.readFixed64(p143, n95)
		else
			error("Unsupported wire type: " .. v1883)
		end
	end

	return v1880
end
function t234.jsonEncode(p144) -- line: 12308
	local t236 = {}

	if p144.subscription_id ~= nil and p144.subscription_id ~= "" then
		t236.subscriptionId = p144.subscription_id
	end

	return t236
end
function t234.jsonDecode(t237: {[any]: any}) -- line: 12320
	-- upvalues: t234 (copy)
	local v1893 = t234.new()

	if t237.subscription_id ~= nil then
		v1893.subscription_id = t237.subscription_id
	end

	if t237.subscriptionId ~= nil then
		v1893.subscription_id = t237.subscriptionId
	end

	return v1893
end

t234.descriptor = {
	name = "SubscriptionCollectionInputData_SubscriptionItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.SubscriptionItem"
}
t1.SubscriptionCollectionInputData_SubscriptionItem = t234
typeRegistry.default:register(t1.SubscriptionCollectionInputData_SubscriptionItem)

local t238 = {}

t238.__index = t238

function t238.new(t239: {[any]: any}?) -- line: 12351
	-- upvalues: t238 (copy)
	return (setmetatable({
		items = if t239 ~= nil and t239.items ~= nil then t239.items else {},
		universe_id = if t239 ~= nil and t239.universe_id ~= nil then t239.universe_id else "",
		section_title = if t239 ~= nil and t239.section_title ~= nil then t239.section_title else ""
	}, t238))
end
function t238.encode(p145) -- line: 12361
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n96 = 0

	if p145.items ~= nil and #p145.items > 0 then
		for _, v1899 in p145.items do
			local v1900 = v1899:encode()
			local v1901, v1902 = proto.writeTag(buf, n96, 1, proto.wireTypes.lengthDelimited)

			buf, n96 = proto.writeBuffer(v1901, v1902, v1900, buffer.len(v1900))
		end
	end

	if p145.universe_id ~= nil and p145.universe_id ~= "" then
		local v1903, v1904 = proto.writeTag(buf, n96, 2, proto.wireTypes.lengthDelimited)

		buf, n96 = proto.writeString(v1903, v1904, p145.universe_id)
	end

	if p145.section_title ~= nil and p145.section_title ~= "" then
		local v1905, v1906 = proto.writeTag(buf, n96, 3, proto.wireTypes.lengthDelimited)

		buf, n96 = proto.writeString(v1905, v1906, p145.section_title)
	end

	local buf53 = buffer.create(n96)

	buffer.copy(buf53, 0, buf, 0, n96)

	return buf53
end
function t238.decode(p146: buffer) -- line: 12388
	-- upvalues: t238 (copy), proto (copy), t1 (copy)
	local v1909 = t238.new()
	local n97 = 0

	while n97 < buffer.len(p146) do
		local v1911, v1912

		v1911, v1912, n97 = proto.readTag(p146, n97)

		if v1912 == proto.wireTypes.varint then
			local v1913

			v1913, n97 = proto.readVarInt(p146, n97)
		elseif v1912 == proto.wireTypes.lengthDelimited then
			if v1911 == 1 then
				local v1914

				v1914, n97 = proto.readBuffer(p146, n97)
				table.insert(v1909.items, t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItem.decode(v1914))
			elseif v1911 == 2 then
				local v1915

				v1915, n97 = proto.readBuffer(p146, n97)
				v1909.universe_id = buffer.tostring(v1915)
			elseif v1911 == 3 then
				local v1916

				v1916, n97 = proto.readBuffer(p146, n97)
				v1909.section_title = buffer.tostring(v1916)
			else
				local v1917, v1918 = proto.readVarInt(p146, n97)

				n97 = v1918 + v1917
			end
		elseif v1912 == proto.wireTypes.i32 then
			local v1919

			v1919, n97 = proto.readFixed32(p146, n97)
		elseif v1912 == proto.wireTypes.i64 then
			local v1920

			v1920, n97 = proto.readFixed64(p146, n97)
		else
			error("Unsupported wire type: " .. v1912)
		end
	end

	return v1909
end
function t238.jsonEncode(p147) -- line: 12444
	local t240 = {}

	if p147.items ~= nil and #p147.items > 0 then
		local t241 = {}

		for _, v1925 in p147.items do
			table.insert(t241, v1925:jsonEncode())
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
function t238.jsonDecode(t242: {[any]: any}) -- line: 12466
	-- upvalues: t238 (copy), t1 (copy)
	local v1927 = t238.new()

	if t242.items ~= nil then
		local t243 = {}

		for _, v1930 in t242.items do
			table.insert(t243, t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItem.jsonDecode(v1930))
		end

		v1927.items = t243
	end

	if t242.universe_id ~= nil then
		v1927.universe_id = t242.universe_id
	end

	if t242.universeId ~= nil then
		v1927.universe_id = t242.universeId
	end

	if t242.section_title ~= nil then
		v1927.section_title = t242.section_title
	end

	if t242.sectionTitle ~= nil then
		v1927.section_title = t242.sectionTitle
	end

	return v1927
end

t238.descriptor = {
	name = "DynamicStoreCategoryInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.DynamicStoreCategoryInputData"
}
t1.DynamicStoreCategoryInputData = t238
typeRegistry.default:register(t1.DynamicStoreCategoryInputData)

local t244 = {}

t244.__index = t244

function t244.new(t245: {[any]: any}?) -- line: 12515
	-- upvalues: t1 (copy), t244 (copy)
	return (setmetatable({
		item_id = if t245 ~= nil and t245.item_id ~= nil then t245.item_id else "",
		identifier = if t245 ~= nil and t245.identifier ~= nil then t245.identifier else assert(t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItemType.fromNumber(0), "Enum has no 0 default")
	}, t244))
end
function t244.encode(p148) -- line: 12532
	-- upvalues: proto (copy), t1 (copy)
	local buf = buffer.create(0)
	local n98 = 0

	if p148.item_id ~= nil and p148.item_id ~= "" then
		local v1935, v1936 = proto.writeTag(buf, n98, 1, proto.wireTypes.lengthDelimited)

		buf, n98 = proto.writeString(v1935, v1936, p148.item_id)
	end

	if p148.identifier ~= nil and (p148.identifier ~= nil and p148.identifier ~= 0 or p148.identifier ~= t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItemType.fromNumber(0)) then
		local v1937, v1938 = proto.writeTag(buf, n98, 2, proto.wireTypes.varint)

		buf, n98 = proto.writeVarInt(v1937, v1938, t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItemType.toNumber(p148.identifier))
	end

	local buf54 = buffer.create(n98)

	buffer.copy(buf54, 0, buf, 0, n98)

	return buf54
end
function t244.decode(p149: buffer) -- line: 12564
	-- upvalues: t244 (copy), proto (copy), t1 (copy)
	local v1941 = t244.new()
	local n99 = 0

	while n99 < buffer.len(p149) do
		local v1943, v1944

		v1943, v1944, n99 = proto.readTag(p149, n99)

		if v1944 == proto.wireTypes.varint then
			if v1943 == 2 then
				local v1945

				v1945, n99 = proto.readVarIntI32(p149, n99)
				v1941.identifier = t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItemType.fromNumber(v1945) or v1945
			else
				local v1946

				v1946, n99 = proto.readVarInt(p149, n99)
			end
		elseif v1944 == proto.wireTypes.lengthDelimited then
			if v1943 == 1 then
				local v1947

				v1947, n99 = proto.readBuffer(p149, n99)
				v1941.item_id = buffer.tostring(v1947)
			else
				local v1948, v1949 = proto.readVarInt(p149, n99)

				n99 = v1949 + v1948
			end
		elseif v1944 == proto.wireTypes.i32 then
			local v1950

			v1950, n99 = proto.readFixed32(p149, n99)
		elseif v1944 == proto.wireTypes.i64 then
			local v1951

			v1951, n99 = proto.readFixed64(p149, n99)
		else
			error("Unsupported wire type: " .. v1944)
		end
	end

	return v1941
end
function t244.jsonEncode(p150) -- line: 12616
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
function t244.jsonDecode(t247: {[any]: any}) -- line: 12643
	-- upvalues: t244 (copy), t1 (copy)
	local v1955 = t244.new()

	if t247.item_id ~= nil then
		v1955.item_id = t247.item_id
	end

	if t247.itemId ~= nil then
		v1955.item_id = t247.itemId
	end

	if t247.identifier ~= nil then
		v1955.identifier = if typeof(t247.identifier) ~= "number" then t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItemType.fromName(t247.identifier) or t247.identifier else t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItemType.fromNumber(t247.identifier) or t247.identifier
	end

	return v1955
end

t244.descriptor = {
	name = "DynamicStoreCategoryInputData_DynamicStoreCategoryItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.DynamicStoreCategoryItem"
}
t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItem = t244
typeRegistry.default:register(t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItem)
t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItemType = {
	fromNumber = function(n100: number) -- line: 12682
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
	toNumber = function(p151) -- line: 12694
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
	fromName = function(s1: string) -- line: 12706
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

function t248.new(t249: {[any]: any}?) -- line: 12723
	-- upvalues: t248 (copy)
	return (setmetatable({
		roblox_component = if t249 ~= nil and t249.roblox_component ~= nil then t249.roblox_component else "",
		identifier = if t249 ~= nil and t249.identifier ~= nil then t249.identifier else "",
		title = if t249 ~= nil and t249.title ~= nil then t249.title else "",
		user_id = if t249 ~= nil and t249.user_id ~= nil then t249.user_id else "",
		description = if t249 ~= nil and t249.description ~= nil then t249.description else "",
		cta_text = if t249 ~= nil and t249.cta_text ~= nil then t249.cta_text else "",
		prompt_id = if t249 ~= nil and t249.prompt_id ~= nil then t249.prompt_id else "",
		prompt_type = if t249 ~= nil and t249.prompt_type ~= nil then t249.prompt_type else ""
	}, t248))
end
function t248.encode(p152) -- line: 12738
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n101 = 0

	if p152.roblox_component ~= nil and p152.roblox_component ~= "" then
		local v1963, v1964 = proto.writeTag(buf, n101, 1, proto.wireTypes.lengthDelimited)

		buf, n101 = proto.writeString(v1963, v1964, p152.roblox_component)
	end

	if p152.identifier ~= nil and p152.identifier ~= "" then
		local v1965, v1966 = proto.writeTag(buf, n101, 2, proto.wireTypes.lengthDelimited)

		buf, n101 = proto.writeString(v1965, v1966, p152.identifier)
	end

	if p152.title ~= nil and p152.title ~= "" then
		local v1967, v1968 = proto.writeTag(buf, n101, 3, proto.wireTypes.lengthDelimited)

		buf, n101 = proto.writeString(v1967, v1968, p152.title)
	end

	if p152.user_id ~= nil and p152.user_id ~= "" then
		local v1969, v1970 = proto.writeTag(buf, n101, 4, proto.wireTypes.lengthDelimited)

		buf, n101 = proto.writeString(v1969, v1970, p152.user_id)
	end

	if p152.description ~= nil and p152.description ~= "" then
		local v1971, v1972 = proto.writeTag(buf, n101, 5, proto.wireTypes.lengthDelimited)

		buf, n101 = proto.writeString(v1971, v1972, p152.description)
	end

	if p152.cta_text ~= nil and p152.cta_text ~= "" then
		local v1973, v1974 = proto.writeTag(buf, n101, 6, proto.wireTypes.lengthDelimited)

		buf, n101 = proto.writeString(v1973, v1974, p152.cta_text)
	end

	if p152.prompt_id ~= nil and p152.prompt_id ~= "" then
		local v1975, v1976 = proto.writeTag(buf, n101, 7, proto.wireTypes.lengthDelimited)

		buf, n101 = proto.writeString(v1975, v1976, p152.prompt_id)
	end

	if p152.prompt_type ~= nil and p152.prompt_type ~= "" then
		local v1977, v1978 = proto.writeTag(buf, n101, 8, proto.wireTypes.lengthDelimited)

		buf, n101 = proto.writeString(v1977, v1978, p152.prompt_type)
	end

	local buf55 = buffer.create(n101)

	buffer.copy(buf55, 0, buf, 0, n101)

	return buf55
end
function t248.decode(p153: buffer) -- line: 12787
	-- upvalues: t248 (copy), proto (copy)
	local v1981 = t248.new()
	local n102 = 0

	while n102 < buffer.len(p153) do
		local v1983, v1984

		v1983, v1984, n102 = proto.readTag(p153, n102)

		if v1984 == proto.wireTypes.varint then
			local v1985

			v1985, n102 = proto.readVarInt(p153, n102)
		elseif v1984 == proto.wireTypes.lengthDelimited then
			if v1983 == 1 then
				local v1986

				v1986, n102 = proto.readBuffer(p153, n102)
				v1981.roblox_component = buffer.tostring(v1986)
			elseif v1983 == 2 then
				local v1987

				v1987, n102 = proto.readBuffer(p153, n102)
				v1981.identifier = buffer.tostring(v1987)
			elseif v1983 == 3 then
				local v1988

				v1988, n102 = proto.readBuffer(p153, n102)
				v1981.title = buffer.tostring(v1988)
			elseif v1983 == 4 then
				local v1989

				v1989, n102 = proto.readBuffer(p153, n102)
				v1981.user_id = buffer.tostring(v1989)
			elseif v1983 == 5 then
				local v1990

				v1990, n102 = proto.readBuffer(p153, n102)
				v1981.description = buffer.tostring(v1990)
			elseif v1983 == 6 then
				local v1991

				v1991, n102 = proto.readBuffer(p153, n102)
				v1981.cta_text = buffer.tostring(v1991)
			elseif v1983 == 7 then
				local v1992

				v1992, n102 = proto.readBuffer(p153, n102)
				v1981.prompt_id = buffer.tostring(v1992)
			elseif v1983 == 8 then
				local v1993

				v1993, n102 = proto.readBuffer(p153, n102)
				v1981.prompt_type = buffer.tostring(v1993)
			else
				local v1994, v1995 = proto.readVarInt(p153, n102)

				n102 = v1995 + v1994
			end
		elseif v1984 == proto.wireTypes.i32 then
			local v1996

			v1996, n102 = proto.readFixed32(p153, n102)
		elseif v1984 == proto.wireTypes.i64 then
			local v1997

			v1997, n102 = proto.readFixed64(p153, n102)
		else
			error("Unsupported wire type: " .. v1984)
		end
	end

	return v1981
end
function t248.jsonEncode(p154) -- line: 12865
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

	return t250
end
function t248.jsonDecode(t251: {[any]: any}) -- line: 12903
	-- upvalues: t248 (copy)
	local v2001 = t248.new()

	if t251.roblox_component ~= nil then
		v2001.roblox_component = t251.roblox_component
	end

	if t251.robloxComponent ~= nil then
		v2001.roblox_component = t251.robloxComponent
	end

	if t251.identifier ~= nil then
		v2001.identifier = t251.identifier
	end

	if t251.title ~= nil then
		v2001.title = t251.title
	end

	if t251.user_id ~= nil then
		v2001.user_id = t251.user_id
	end

	if t251.userId ~= nil then
		v2001.user_id = t251.userId
	end

	if t251.description ~= nil then
		v2001.description = t251.description
	end

	if t251.cta_text ~= nil then
		v2001.cta_text = t251.cta_text
	end

	if t251.ctaText ~= nil then
		v2001.cta_text = t251.ctaText
	end

	if t251.prompt_id ~= nil then
		v2001.prompt_id = t251.prompt_id
	end

	if t251.promptId ~= nil then
		v2001.prompt_id = t251.promptId
	end

	if t251.prompt_type ~= nil then
		v2001.prompt_type = t251.prompt_type
	end

	if t251.promptType ~= nil then
		v2001.prompt_type = t251.promptType
	end

	return v2001
end

t248.descriptor = {
	name = "CardContainerCardInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CardContainerCardInputData"
}
t1.CardContainerCardInputData = t248
typeRegistry.default:register(t1.CardContainerCardInputData)

local t252 = {}

t252.__index = t252

function t252.new(t253: {[any]: any}?) -- line: 12975
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
function t252.encode(p155) -- line: 12986
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n103 = 0

	if p155.title ~= nil and p155.title ~= "" then
		local v2006, v2007 = proto.writeTag(buf, n103, 1, proto.wireTypes.lengthDelimited)

		buf, n103 = proto.writeString(v2006, v2007, p155.title)
	end

	if p155.dismiss_text ~= nil and p155.dismiss_text ~= "" then
		local v2008, v2009 = proto.writeTag(buf, n103, 2, proto.wireTypes.lengthDelimited)

		buf, n103 = proto.writeString(v2008, v2009, p155.dismiss_text)
	end

	if p155.user_id ~= nil and p155.user_id ~= "" then
		local v2010, v2011 = proto.writeTag(buf, n103, 3, proto.wireTypes.lengthDelimited)

		buf, n103 = proto.writeString(v2010, v2011, p155.user_id)
	end

	if p155.cards ~= nil and #p155.cards > 0 then
		for _, v2013 in p155.cards do
			local v2014 = v2013:encode()
			local v2015, v2016 = proto.writeTag(buf, n103, 4, proto.wireTypes.lengthDelimited)

			buf, n103 = proto.writeBuffer(v2015, v2016, v2014, buffer.len(v2014))
		end
	end

	if p155.prompt_id ~= nil and p155.prompt_id ~= "" then
		local v2017, v2018 = proto.writeTag(buf, n103, 5, proto.wireTypes.lengthDelimited)

		buf, n103 = proto.writeString(v2017, v2018, p155.prompt_id)
	end

	if p155.prompt_type ~= nil and p155.prompt_type ~= "" then
		local v2019, v2020 = proto.writeTag(buf, n103, 6, proto.wireTypes.lengthDelimited)

		buf, n103 = proto.writeString(v2019, v2020, p155.prompt_type)
	end

	local buf56 = buffer.create(n103)

	buffer.copy(buf56, 0, buf, 0, n103)

	return buf56
end
function t252.decode(p156: buffer) -- line: 13028
	-- upvalues: t252 (copy), proto (copy), t1 (copy)
	local v2023 = t252.new()
	local n104 = 0

	while n104 < buffer.len(p156) do
		local v2025, v2026

		v2025, v2026, n104 = proto.readTag(p156, n104)

		if v2026 == proto.wireTypes.varint then
			local v2027

			v2027, n104 = proto.readVarInt(p156, n104)
		elseif v2026 == proto.wireTypes.lengthDelimited then
			if v2025 == 1 then
				local v2028

				v2028, n104 = proto.readBuffer(p156, n104)
				v2023.title = buffer.tostring(v2028)
			elseif v2025 == 2 then
				local v2029

				v2029, n104 = proto.readBuffer(p156, n104)
				v2023.dismiss_text = buffer.tostring(v2029)
			elseif v2025 == 3 then
				local v2030

				v2030, n104 = proto.readBuffer(p156, n104)
				v2023.user_id = buffer.tostring(v2030)
			elseif v2025 == 4 then
				local v2031

				v2031, n104 = proto.readBuffer(p156, n104)
				table.insert(v2023.cards, t1.CardContainerCardInputData.decode(v2031))
			elseif v2025 == 5 then
				local v2032

				v2032, n104 = proto.readBuffer(p156, n104)
				v2023.prompt_id = buffer.tostring(v2032)
			elseif v2025 == 6 then
				local v2033

				v2033, n104 = proto.readBuffer(p156, n104)
				v2023.prompt_type = buffer.tostring(v2033)
			else
				local v2034, v2035 = proto.readVarInt(p156, n104)

				n104 = v2035 + v2034
			end
		elseif v2026 == proto.wireTypes.i32 then
			local v2036

			v2036, n104 = proto.readFixed32(p156, n104)
		elseif v2026 == proto.wireTypes.i64 then
			local v2037

			v2037, n104 = proto.readFixed64(p156, n104)
		else
			error("Unsupported wire type: " .. v2026)
		end
	end

	return v2023
end
function t252.jsonEncode(p157) -- line: 13096
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

		for _, v2042 in p157.cards do
			table.insert(t255, v2042:jsonEncode())
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
function t252.jsonDecode(t256: {[any]: any}) -- line: 13130
	-- upvalues: t252 (copy), t1 (copy)
	local v2044 = t252.new()

	if t256.title ~= nil then
		v2044.title = t256.title
	end

	if t256.dismiss_text ~= nil then
		v2044.dismiss_text = t256.dismiss_text
	end

	if t256.dismissText ~= nil then
		v2044.dismiss_text = t256.dismissText
	end

	if t256.user_id ~= nil then
		v2044.user_id = t256.user_id
	end

	if t256.userId ~= nil then
		v2044.user_id = t256.userId
	end

	if t256.cards ~= nil then
		local t257 = {}

		for _, v2047 in t256.cards do
			table.insert(t257, t1.CardContainerCardInputData.jsonDecode(v2047))
		end

		v2044.cards = t257
	end

	if t256.prompt_id ~= nil then
		v2044.prompt_id = t256.prompt_id
	end

	if t256.promptId ~= nil then
		v2044.prompt_id = t256.promptId
	end

	if t256.prompt_type ~= nil then
		v2044.prompt_type = t256.prompt_type
	end

	if t256.promptType ~= nil then
		v2044.prompt_type = t256.promptType
	end

	return v2044
end

t252.descriptor = {
	name = "CardContainerInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CardContainerInputData"
}
t1.CardContainerInputData = t252
typeRegistry.default:register(t1.CardContainerInputData)

local t258 = {}

t258.__index = t258

function t258.new(t259: {[any]: any}?) -- line: 13195
	-- upvalues: t258 (copy)
	return (setmetatable({
		title = if t259 ~= nil and t259.title ~= nil then t259.title else "",
		user_id = if t259 ~= nil and t259.user_id ~= nil then t259.user_id else "",
		description = if t259 ~= nil and t259.description ~= nil then t259.description else "",
		cta_text = if t259 ~= nil and t259.cta_text ~= nil then t259.cta_text else "",
		prompt_id = if t259 ~= nil and t259.prompt_id ~= nil then t259.prompt_id else "",
		prompt_type = if t259 ~= nil and t259.prompt_type ~= nil then t259.prompt_type else ""
	}, t258))
end
function t258.encode(p158) -- line: 13206
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n105 = 0

	if p158.title ~= nil and p158.title ~= "" then
		local v2052, v2053 = proto.writeTag(buf, n105, 1, proto.wireTypes.lengthDelimited)

		buf, n105 = proto.writeString(v2052, v2053, p158.title)
	end

	if p158.user_id ~= nil and p158.user_id ~= "" then
		local v2054, v2055 = proto.writeTag(buf, n105, 2, proto.wireTypes.lengthDelimited)

		buf, n105 = proto.writeString(v2054, v2055, p158.user_id)
	end

	if p158.description ~= nil and p158.description ~= "" then
		local v2056, v2057 = proto.writeTag(buf, n105, 3, proto.wireTypes.lengthDelimited)

		buf, n105 = proto.writeString(v2056, v2057, p158.description)
	end

	if p158.cta_text ~= nil and p158.cta_text ~= "" then
		local v2058, v2059 = proto.writeTag(buf, n105, 4, proto.wireTypes.lengthDelimited)

		buf, n105 = proto.writeString(v2058, v2059, p158.cta_text)
	end

	if p158.prompt_id ~= nil and p158.prompt_id ~= "" then
		local v2060, v2061 = proto.writeTag(buf, n105, 5, proto.wireTypes.lengthDelimited)

		buf, n105 = proto.writeString(v2060, v2061, p158.prompt_id)
	end

	if p158.prompt_type ~= nil and p158.prompt_type ~= "" then
		local v2062, v2063 = proto.writeTag(buf, n105, 6, proto.wireTypes.lengthDelimited)

		buf, n105 = proto.writeString(v2062, v2063, p158.prompt_type)
	end

	local buf57 = buffer.create(n105)

	buffer.copy(buf57, 0, buf, 0, n105)

	return buf57
end
function t258.decode(p159: buffer) -- line: 13245
	-- upvalues: t258 (copy), proto (copy)
	local v2066 = t258.new()
	local n106 = 0

	while n106 < buffer.len(p159) do
		local v2068, v2069

		v2068, v2069, n106 = proto.readTag(p159, n106)

		if v2069 == proto.wireTypes.varint then
			local v2070

			v2070, n106 = proto.readVarInt(p159, n106)
		elseif v2069 == proto.wireTypes.lengthDelimited then
			if v2068 == 1 then
				local v2071

				v2071, n106 = proto.readBuffer(p159, n106)
				v2066.title = buffer.tostring(v2071)
			elseif v2068 == 2 then
				local v2072

				v2072, n106 = proto.readBuffer(p159, n106)
				v2066.user_id = buffer.tostring(v2072)
			elseif v2068 == 3 then
				local v2073

				v2073, n106 = proto.readBuffer(p159, n106)
				v2066.description = buffer.tostring(v2073)
			elseif v2068 == 4 then
				local v2074

				v2074, n106 = proto.readBuffer(p159, n106)
				v2066.cta_text = buffer.tostring(v2074)
			elseif v2068 == 5 then
				local v2075

				v2075, n106 = proto.readBuffer(p159, n106)
				v2066.prompt_id = buffer.tostring(v2075)
			elseif v2068 == 6 then
				local v2076

				v2076, n106 = proto.readBuffer(p159, n106)
				v2066.prompt_type = buffer.tostring(v2076)
			else
				local v2077, v2078 = proto.readVarInt(p159, n106)

				n106 = v2078 + v2077
			end
		elseif v2069 == proto.wireTypes.i32 then
			local v2079

			v2079, n106 = proto.readFixed32(p159, n106)
		elseif v2069 == proto.wireTypes.i64 then
			local v2080

			v2080, n106 = proto.readFixed64(p159, n106)
		else
			error("Unsupported wire type: " .. v2069)
		end
	end

	return v2066
end
function t258.jsonEncode(p160) -- line: 13313
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

	return t260
end
function t258.jsonDecode(t261: {[any]: any}) -- line: 13343
	-- upvalues: t258 (copy)
	local v2084 = t258.new()

	if t261.title ~= nil then
		v2084.title = t261.title
	end

	if t261.user_id ~= nil then
		v2084.user_id = t261.user_id
	end

	if t261.userId ~= nil then
		v2084.user_id = t261.userId
	end

	if t261.description ~= nil then
		v2084.description = t261.description
	end

	if t261.cta_text ~= nil then
		v2084.cta_text = t261.cta_text
	end

	if t261.ctaText ~= nil then
		v2084.cta_text = t261.ctaText
	end

	if t261.prompt_id ~= nil then
		v2084.prompt_id = t261.prompt_id
	end

	if t261.promptId ~= nil then
		v2084.prompt_id = t261.promptId
	end

	if t261.prompt_type ~= nil then
		v2084.prompt_type = t261.prompt_type
	end

	if t261.promptType ~= nil then
		v2084.prompt_type = t261.promptType
	end

	return v2084
end

t258.descriptor = {
	name = "CardInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CardInputData"
}
t1.CardInputData = t258
typeRegistry.default:register(t1.CardInputData)

local t262 = {}

t262.__index = t262

function t262.new(t263: {[any]: any}?) -- line: 13403
	-- upvalues: t262 (copy)
	return (setmetatable({
		prompt_id = if t263 ~= nil and t263.prompt_id ~= nil then t263.prompt_id else "",
		prompt_type = if t263 ~= nil and t263.prompt_type ~= nil then t263.prompt_type else "",
		user_id = if t263 ~= nil and t263.user_id ~= nil then t263.user_id else "",
		audit_data = if t263 ~= nil and t263.audit_data ~= nil then t263.audit_data else ""
	}, t262))
end
function t262.encode(p161) -- line: 13412
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n107 = 0

	if p161.prompt_id ~= nil and p161.prompt_id ~= "" then
		local v2089, v2090 = proto.writeTag(buf, n107, 1, proto.wireTypes.lengthDelimited)

		buf, n107 = proto.writeString(v2089, v2090, p161.prompt_id)
	end

	if p161.prompt_type ~= nil and p161.prompt_type ~= "" then
		local v2091, v2092 = proto.writeTag(buf, n107, 2, proto.wireTypes.lengthDelimited)

		buf, n107 = proto.writeString(v2091, v2092, p161.prompt_type)
	end

	if p161.user_id ~= nil and p161.user_id ~= "" then
		local v2093, v2094 = proto.writeTag(buf, n107, 3, proto.wireTypes.lengthDelimited)

		buf, n107 = proto.writeString(v2093, v2094, p161.user_id)
	end

	if p161.audit_data ~= nil and p161.audit_data ~= "" then
		local v2095, v2096 = proto.writeTag(buf, n107, 4, proto.wireTypes.lengthDelimited)

		buf, n107 = proto.writeString(v2095, v2096, p161.audit_data)
	end

	local buf58 = buffer.create(n107)

	buffer.copy(buf58, 0, buf, 0, n107)

	return buf58
end
function t262.decode(p162: buffer) -- line: 13441
	-- upvalues: t262 (copy), proto (copy)
	local v2099 = t262.new()
	local n108 = 0

	while n108 < buffer.len(p162) do
		local v2101, v2102

		v2101, v2102, n108 = proto.readTag(p162, n108)

		if v2102 == proto.wireTypes.varint then
			local v2103

			v2103, n108 = proto.readVarInt(p162, n108)
		elseif v2102 == proto.wireTypes.lengthDelimited then
			if v2101 == 1 then
				local v2104

				v2104, n108 = proto.readBuffer(p162, n108)
				v2099.prompt_id = buffer.tostring(v2104)
			elseif v2101 == 2 then
				local v2105

				v2105, n108 = proto.readBuffer(p162, n108)
				v2099.prompt_type = buffer.tostring(v2105)
			elseif v2101 == 3 then
				local v2106

				v2106, n108 = proto.readBuffer(p162, n108)
				v2099.user_id = buffer.tostring(v2106)
			elseif v2101 == 4 then
				local v2107

				v2107, n108 = proto.readBuffer(p162, n108)
				v2099.audit_data = buffer.tostring(v2107)
			else
				local v2108, v2109 = proto.readVarInt(p162, n108)

				n108 = v2109 + v2108
			end
		elseif v2102 == proto.wireTypes.i32 then
			local v2110

			v2110, n108 = proto.readFixed32(p162, n108)
		elseif v2102 == proto.wireTypes.i64 then
			local v2111

			v2111, n108 = proto.readFixed64(p162, n108)
		else
			error("Unsupported wire type: " .. v2102)
		end
	end

	return v2099
end
function t262.jsonEncode(p163) -- line: 13499
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
function t262.jsonDecode(t265: {[any]: any}) -- line: 13521
	-- upvalues: t262 (copy)
	local v2115 = t262.new()

	if t265.prompt_id ~= nil then
		v2115.prompt_id = t265.prompt_id
	end

	if t265.promptId ~= nil then
		v2115.prompt_id = t265.promptId
	end

	if t265.prompt_type ~= nil then
		v2115.prompt_type = t265.prompt_type
	end

	if t265.promptType ~= nil then
		v2115.prompt_type = t265.promptType
	end

	if t265.user_id ~= nil then
		v2115.user_id = t265.user_id
	end

	if t265.userId ~= nil then
		v2115.user_id = t265.userId
	end

	if t265.audit_data ~= nil then
		v2115.audit_data = t265.audit_data
	end

	if t265.auditData ~= nil then
		v2115.audit_data = t265.auditData
	end

	return v2115
end

t262.descriptor = {
	name = "DialogInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.DialogInputData"
}
t1.DialogInputData = t262
typeRegistry.default:register(t1.DialogInputData)

local t266 = {}

t266.__index = t266

function t266.new(t267: {[any]: any}?) -- line: 13573
	-- upvalues: t266 (copy)
	return (setmetatable({
		sender_count = if t267 ~= nil and t267.sender_count ~= nil then t267.sender_count else 0,
		total_robux_amount = if t267 ~= nil and t267.total_robux_amount ~= nil then t267.total_robux_amount else 0
	}, t266))
end
function t266.encode(p164) -- line: 13580
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n109 = 0

	if p164.sender_count ~= nil and p164.sender_count ~= 0 then
		local v2120, v2121 = proto.writeTag(buf, n109, 1, proto.wireTypes.varint)

		buf, n109 = proto.writeVarInt(v2120, v2121, p164.sender_count)
	end

	if p164.total_robux_amount ~= nil and p164.total_robux_amount ~= 0 then
		local v2122, v2123 = proto.writeTag(buf, n109, 2, proto.wireTypes.varint)

		buf, n109 = proto.writeVarInt(v2122, v2123, p164.total_robux_amount)
	end

	local buf59 = buffer.create(n109)

	buffer.copy(buf59, 0, buf, 0, n109)

	return buf59
end
function t266.decode(p165: buffer) -- line: 13599
	-- upvalues: t266 (copy), proto (copy)
	local v2126 = t266.new()
	local n110 = 0

	while n110 < buffer.len(p165) do
		local v2128, v2129

		v2128, v2129, n110 = proto.readTag(p165, n110)

		if v2129 == proto.wireTypes.varint then
			if v2128 == 1 then
				local v2130

				v2130, n110 = proto.readVarIntI32(p165, n110)
				v2126.sender_count = v2130
			elseif v2128 == 2 then
				local v2131

				v2131, n110 = proto.readVarIntI64(p165, n110)
				v2126.total_robux_amount = v2131
			else
				local v2132

				v2132, n110 = proto.readVarInt(p165, n110)
			end
		elseif v2129 == proto.wireTypes.lengthDelimited then
			local v2133, v2134 = proto.readVarInt(p165, n110)

			n110 = v2134 + v2133
		elseif v2129 == proto.wireTypes.i32 then
			local v2135

			v2135, n110 = proto.readFixed32(p165, n110)
		elseif v2129 == proto.wireTypes.i64 then
			local v2136

			v2136, n110 = proto.readFixed64(p165, n110)
		else
			error("Unsupported wire type: " .. v2129)
		end
	end

	return v2126
end
function t266.jsonEncode(p166) -- line: 13647
	local t268 = {}

	if p166.sender_count ~= nil and p166.sender_count ~= 0 then
		t268.senderCount = p166.sender_count
	end

	if p166.total_robux_amount ~= nil and p166.total_robux_amount ~= 0 then
		t268.totalRobuxAmount = p166.total_robux_amount
	end

	return t268
end
function t266.jsonDecode(t269: {[any]: any}) -- line: 13661
	-- upvalues: t266 (copy)
	local v2140 = t266.new()

	if t269.sender_count ~= nil then
		v2140.sender_count = t269.sender_count
	end

	if t269.senderCount ~= nil then
		v2140.sender_count = t269.senderCount
	end

	if t269.total_robux_amount ~= nil then
		v2140.total_robux_amount = t269.total_robux_amount
	end

	if t269.totalRobuxAmount ~= nil then
		v2140.total_robux_amount = t269.totalRobuxAmount
	end

	return v2140
end

t266.descriptor = {
	name = "IncomingTransferContent",
	fullName = "roblox.apppageplatform.shared.v1beta1.IncomingTransferContent"
}
t1.IncomingTransferContent = t266
typeRegistry.default:register(t1.IncomingTransferContent)

local t270 = {}

t270.__index = t270

function t270.new(t271: {[any]: any}?) -- line: 13697
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
function t270.encode(p167) -- line: 13710
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n111 = 0

	if p167.title ~= nil and p167.title ~= "" then
		local v2145, v2146 = proto.writeTag(buf, n111, 1, proto.wireTypes.lengthDelimited)

		buf, n111 = proto.writeString(v2145, v2146, p167.title)
	end

	if p167.description ~= nil and p167.description ~= "" then
		local v2147, v2148 = proto.writeTag(buf, n111, 2, proto.wireTypes.lengthDelimited)

		buf, n111 = proto.writeString(v2147, v2148, p167.description)
	end

	if p167.primary_text ~= nil and p167.primary_text ~= "" then
		local v2149, v2150 = proto.writeTag(buf, n111, 3, proto.wireTypes.lengthDelimited)

		buf, n111 = proto.writeString(v2149, v2150, p167.primary_text)
	end

	if p167.secondary_text ~= nil and p167.secondary_text ~= "" then
		local v2151, v2152 = proto.writeTag(buf, n111, 4, proto.wireTypes.lengthDelimited)

		buf, n111 = proto.writeString(v2151, v2152, p167.secondary_text)
	end

	if p167.prompt_id ~= nil and p167.prompt_id ~= "" then
		local v2153, v2154 = proto.writeTag(buf, n111, 5, proto.wireTypes.lengthDelimited)

		buf, n111 = proto.writeString(v2153, v2154, p167.prompt_id)
	end

	if p167.prompt_type ~= nil and p167.prompt_type ~= "" then
		local v2155, v2156 = proto.writeTag(buf, n111, 6, proto.wireTypes.lengthDelimited)

		buf, n111 = proto.writeString(v2155, v2156, p167.prompt_type)
	end

	if p167.times_seen ~= nil and p167.times_seen ~= 0 then
		local v2157, v2158 = proto.writeTag(buf, n111, 7, proto.wireTypes.varint)

		buf, n111 = proto.writeVarInt(v2157, v2158, p167.times_seen)
	end

	if p167.content ~= nil and p167.content.type == "incoming_transfer_content" then
		local v2159 = p167.content.value:encode()
		local v2160, v2161 = proto.writeTag(buf, n111, 8, proto.wireTypes.lengthDelimited)

		buf, n111 = proto.writeBuffer(v2160, v2161, v2159, buffer.len(v2159))
	end

	local buf60 = buffer.create(n111)

	buffer.copy(buf60, 0, buf, 0, n111)

	return buf60
end
function t270.decode(p168: buffer) -- line: 13762
	-- upvalues: t270 (copy), proto (copy), t1 (copy)
	local v2164 = t270.new()
	local n112 = 0

	while n112 < buffer.len(p168) do
		local v2166, v2167

		v2166, v2167, n112 = proto.readTag(p168, n112)

		if v2167 == proto.wireTypes.varint then
			if v2166 == 7 then
				local v2168

				v2168, n112 = proto.readVarIntI32(p168, n112)
				v2164.times_seen = v2168
			else
				local v2169

				v2169, n112 = proto.readVarInt(p168, n112)
			end
		elseif v2167 == proto.wireTypes.lengthDelimited then
			if v2166 == 1 then
				local v2170

				v2170, n112 = proto.readBuffer(p168, n112)
				v2164.title = buffer.tostring(v2170)
			elseif v2166 == 2 then
				local v2171

				v2171, n112 = proto.readBuffer(p168, n112)
				v2164.description = buffer.tostring(v2171)
			elseif v2166 == 3 then
				local v2172

				v2172, n112 = proto.readBuffer(p168, n112)
				v2164.primary_text = buffer.tostring(v2172)
			elseif v2166 == 4 then
				local v2173

				v2173, n112 = proto.readBuffer(p168, n112)
				v2164.secondary_text = buffer.tostring(v2173)
			elseif v2166 == 5 then
				local v2174

				v2174, n112 = proto.readBuffer(p168, n112)
				v2164.prompt_id = buffer.tostring(v2174)
			elseif v2166 == 6 then
				local v2175

				v2175, n112 = proto.readBuffer(p168, n112)
				v2164.prompt_type = buffer.tostring(v2175)
			elseif v2166 == 8 then
				local v2176

				v2176, n112 = proto.readBuffer(p168, n112)
				v2164.content = {
					type = "incoming_transfer_content",
					value = t1.IncomingTransferContent.decode(v2176)
				}
			else
				local v2177, v2178 = proto.readVarInt(p168, n112)

				n112 = v2178 + v2177
			end
		elseif v2167 == proto.wireTypes.i32 then
			local v2179

			v2179, n112 = proto.readFixed32(p168, n112)
		elseif v2167 == proto.wireTypes.i64 then
			local v2180

			v2180, n112 = proto.readFixed64(p168, n112)
		else
			error("Unsupported wire type: " .. v2167)
		end
	end

	return v2164
end
function t270.jsonEncode(p169) -- line: 13841
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
function t270.jsonDecode(t273: {[any]: any}) -- line: 13881
	-- upvalues: t270 (copy), t1 (copy)
	local v2184 = t270.new()

	if t273.title ~= nil then
		v2184.title = t273.title
	end

	if t273.description ~= nil then
		v2184.description = t273.description
	end

	if t273.primary_text ~= nil then
		v2184.primary_text = t273.primary_text
	end

	if t273.primaryText ~= nil then
		v2184.primary_text = t273.primaryText
	end

	if t273.secondary_text ~= nil then
		v2184.secondary_text = t273.secondary_text
	end

	if t273.secondaryText ~= nil then
		v2184.secondary_text = t273.secondaryText
	end

	if t273.prompt_id ~= nil then
		v2184.prompt_id = t273.prompt_id
	end

	if t273.promptId ~= nil then
		v2184.prompt_id = t273.promptId
	end

	if t273.prompt_type ~= nil then
		v2184.prompt_type = t273.prompt_type
	end

	if t273.promptType ~= nil then
		v2184.prompt_type = t273.promptType
	end

	if t273.times_seen ~= nil then
		v2184.times_seen = t273.times_seen
	end

	if t273.timesSeen ~= nil then
		v2184.times_seen = t273.timesSeen
	end

	if t273.incoming_transfer_content ~= nil then
		v2184.content = {
			type = "incoming_transfer_content",
			value = t1.IncomingTransferContent.jsonDecode(t273.incoming_transfer_content)
		}
	end

	if t273.incomingTransferContent ~= nil then
		v2184.content = {
			type = "incoming_transfer_content",
			value = t1.IncomingTransferContent.jsonDecode(t273.incomingTransferContent)
		}
	end

	return v2184
end

t270.descriptor = {
	name = "BannerInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.BannerInputData"
}
t1.BannerInputData = t270
typeRegistry.default:register(t1.BannerInputData)

local t274 = {}

t274.__index = t274

function t274.new(t275: {[any]: any}?) -- line: 13963
	-- upvalues: t274 (copy)
	return (setmetatable({
		tooltip_text = if t275 ~= nil and t275.tooltip_text ~= nil then t275.tooltip_text else "",
		prompt_id = if t275 ~= nil and t275.prompt_id ~= nil then t275.prompt_id else "",
		prompt_type = if t275 ~= nil and t275.prompt_type ~= nil then t275.prompt_type else ""
	}, t274))
end
function t274.encode(p170) -- line: 13971
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n113 = 0

	if p170.tooltip_text ~= nil and p170.tooltip_text ~= "" then
		local v2189, v2190 = proto.writeTag(buf, n113, 1, proto.wireTypes.lengthDelimited)

		buf, n113 = proto.writeString(v2189, v2190, p170.tooltip_text)
	end

	if p170.prompt_id ~= nil and p170.prompt_id ~= "" then
		local v2191, v2192 = proto.writeTag(buf, n113, 2, proto.wireTypes.lengthDelimited)

		buf, n113 = proto.writeString(v2191, v2192, p170.prompt_id)
	end

	if p170.prompt_type ~= nil and p170.prompt_type ~= "" then
		local v2193, v2194 = proto.writeTag(buf, n113, 3, proto.wireTypes.lengthDelimited)

		buf, n113 = proto.writeString(v2193, v2194, p170.prompt_type)
	end

	local buf61 = buffer.create(n113)

	buffer.copy(buf61, 0, buf, 0, n113)

	return buf61
end
function t274.decode(p171: buffer) -- line: 13995
	-- upvalues: t274 (copy), proto (copy)
	local v2197 = t274.new()
	local n114 = 0

	while n114 < buffer.len(p171) do
		local v2199, v2200

		v2199, v2200, n114 = proto.readTag(p171, n114)

		if v2200 == proto.wireTypes.varint then
			local v2201

			v2201, n114 = proto.readVarInt(p171, n114)
		elseif v2200 == proto.wireTypes.lengthDelimited then
			if v2199 == 1 then
				local v2202

				v2202, n114 = proto.readBuffer(p171, n114)
				v2197.tooltip_text = buffer.tostring(v2202)
			elseif v2199 == 2 then
				local v2203

				v2203, n114 = proto.readBuffer(p171, n114)
				v2197.prompt_id = buffer.tostring(v2203)
			elseif v2199 == 3 then
				local v2204

				v2204, n114 = proto.readBuffer(p171, n114)
				v2197.prompt_type = buffer.tostring(v2204)
			else
				local v2205, v2206 = proto.readVarInt(p171, n114)

				n114 = v2206 + v2205
			end
		elseif v2200 == proto.wireTypes.i32 then
			local v2207

			v2207, n114 = proto.readFixed32(p171, n114)
		elseif v2200 == proto.wireTypes.i64 then
			local v2208

			v2208, n114 = proto.readFixed64(p171, n114)
		else
			error("Unsupported wire type: " .. v2200)
		end
	end

	return v2197
end
function t274.jsonEncode(p172) -- line: 14048
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
function t274.jsonDecode(t277: {[any]: any}) -- line: 14066
	-- upvalues: t274 (copy)
	local v2212 = t274.new()

	if t277.tooltip_text ~= nil then
		v2212.tooltip_text = t277.tooltip_text
	end

	if t277.tooltipText ~= nil then
		v2212.tooltip_text = t277.tooltipText
	end

	if t277.prompt_id ~= nil then
		v2212.prompt_id = t277.prompt_id
	end

	if t277.promptId ~= nil then
		v2212.prompt_id = t277.promptId
	end

	if t277.prompt_type ~= nil then
		v2212.prompt_type = t277.prompt_type
	end

	if t277.promptType ~= nil then
		v2212.prompt_type = t277.promptType
	end

	return v2212
end

t274.descriptor = {
	name = "TooltipInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.TooltipInputData"
}
t1.TooltipInputData = t274
typeRegistry.default:register(t1.TooltipInputData)

local t278 = {}

t278.__index = t278

function t278.new(t279: {[any]: any}?) -- line: 14110
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
function t278.encode(p173) -- line: 14121
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n115 = 0

	if p173.media_id ~= nil and p173.media_id ~= "" then
		local v2217, v2218 = proto.writeTag(buf, n115, 1, proto.wireTypes.lengthDelimited)

		buf, n115 = proto.writeString(v2217, v2218, p173.media_id)
	end

	if p173.title ~= nil and p173.title ~= "" then
		local v2219, v2220 = proto.writeTag(buf, n115, 2, proto.wireTypes.lengthDelimited)

		buf, n115 = proto.writeString(v2219, v2220, p173.title)
	end

	if p173.description ~= nil and p173.description ~= "" then
		local v2221, v2222 = proto.writeTag(buf, n115, 3, proto.wireTypes.lengthDelimited)

		buf, n115 = proto.writeString(v2221, v2222, p173.description)
	end

	if p173.prompt_id ~= nil and p173.prompt_id ~= "" then
		local v2223, v2224 = proto.writeTag(buf, n115, 4, proto.wireTypes.lengthDelimited)

		buf, n115 = proto.writeString(v2223, v2224, p173.prompt_id)
	end

	if p173.prompt_type ~= nil and p173.prompt_type ~= "" then
		local v2225, v2226 = proto.writeTag(buf, n115, 5, proto.wireTypes.lengthDelimited)

		buf, n115 = proto.writeString(v2225, v2226, p173.prompt_type)
	end

	if p173.anchor_tag ~= nil and p173.anchor_tag ~= "" then
		local v2227, v2228 = proto.writeTag(buf, n115, 6, proto.wireTypes.lengthDelimited)

		buf, n115 = proto.writeString(v2227, v2228, p173.anchor_tag)
	end

	local buf62 = buffer.create(n115)

	buffer.copy(buf62, 0, buf, 0, n115)

	return buf62
end
function t278.decode(p174: buffer) -- line: 14160
	-- upvalues: t278 (copy), proto (copy)
	local v2231 = t278.new()
	local n116 = 0

	while n116 < buffer.len(p174) do
		local v2233, v2234

		v2233, v2234, n116 = proto.readTag(p174, n116)

		if v2234 == proto.wireTypes.varint then
			local v2235

			v2235, n116 = proto.readVarInt(p174, n116)
		elseif v2234 == proto.wireTypes.lengthDelimited then
			if v2233 == 1 then
				local v2236

				v2236, n116 = proto.readBuffer(p174, n116)
				v2231.media_id = buffer.tostring(v2236)
			elseif v2233 == 2 then
				local v2237

				v2237, n116 = proto.readBuffer(p174, n116)
				v2231.title = buffer.tostring(v2237)
			elseif v2233 == 3 then
				local v2238

				v2238, n116 = proto.readBuffer(p174, n116)
				v2231.description = buffer.tostring(v2238)
			elseif v2233 == 4 then
				local v2239

				v2239, n116 = proto.readBuffer(p174, n116)
				v2231.prompt_id = buffer.tostring(v2239)
			elseif v2233 == 5 then
				local v2240

				v2240, n116 = proto.readBuffer(p174, n116)
				v2231.prompt_type = buffer.tostring(v2240)
			elseif v2233 == 6 then
				local v2241

				v2241, n116 = proto.readBuffer(p174, n116)
				v2231.anchor_tag = buffer.tostring(v2241)
			else
				local v2242, v2243 = proto.readVarInt(p174, n116)

				n116 = v2243 + v2242
			end
		elseif v2234 == proto.wireTypes.i32 then
			local v2244

			v2244, n116 = proto.readFixed32(p174, n116)
		elseif v2234 == proto.wireTypes.i64 then
			local v2245

			v2245, n116 = proto.readFixed64(p174, n116)
		else
			error("Unsupported wire type: " .. v2234)
		end
	end

	return v2231
end
function t278.jsonEncode(p175) -- line: 14228
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
function t278.jsonDecode(t281: {[any]: any}) -- line: 14258
	-- upvalues: t278 (copy)
	local v2249 = t278.new()

	if t281.media_id ~= nil then
		v2249.media_id = t281.media_id
	end

	if t281.mediaId ~= nil then
		v2249.media_id = t281.mediaId
	end

	if t281.title ~= nil then
		v2249.title = t281.title
	end

	if t281.description ~= nil then
		v2249.description = t281.description
	end

	if t281.prompt_id ~= nil then
		v2249.prompt_id = t281.prompt_id
	end

	if t281.promptId ~= nil then
		v2249.prompt_id = t281.promptId
	end

	if t281.prompt_type ~= nil then
		v2249.prompt_type = t281.prompt_type
	end

	if t281.promptType ~= nil then
		v2249.prompt_type = t281.promptType
	end

	if t281.anchor_tag ~= nil then
		v2249.anchor_tag = t281.anchor_tag
	end

	if t281.anchorTag ~= nil then
		v2249.anchor_tag = t281.anchorTag
	end

	return v2249
end

t278.descriptor = {
	name = "CoachmarkInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CoachmarkInputData"
}
t1.CoachmarkInputData = t278
typeRegistry.default:register(t1.CoachmarkInputData)

local t282 = {}

t282.__index = t282

function t282.new(t283: {[any]: any}?) -- line: 14318
	-- upvalues: t282 (copy)
	return (setmetatable({
		prompt_id = if t283 ~= nil and t283.prompt_id ~= nil then t283.prompt_id else "",
		prompt_type = if t283 ~= nil and t283.prompt_type ~= nil then t283.prompt_type else ""
	}, t282))
end
function t282.encode(p176) -- line: 14325
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n117 = 0

	if p176.prompt_id ~= nil and p176.prompt_id ~= "" then
		local v2254, v2255 = proto.writeTag(buf, n117, 1, proto.wireTypes.lengthDelimited)

		buf, n117 = proto.writeString(v2254, v2255, p176.prompt_id)
	end

	if p176.prompt_type ~= nil and p176.prompt_type ~= "" then
		local v2256, v2257 = proto.writeTag(buf, n117, 2, proto.wireTypes.lengthDelimited)

		buf, n117 = proto.writeString(v2256, v2257, p176.prompt_type)
	end

	local buf63 = buffer.create(n117)

	buffer.copy(buf63, 0, buf, 0, n117)

	return buf63
end
function t282.decode(p177: buffer) -- line: 14344
	-- upvalues: t282 (copy), proto (copy)
	local v2260 = t282.new()
	local n118 = 0

	while n118 < buffer.len(p177) do
		local v2262, v2263

		v2262, v2263, n118 = proto.readTag(p177, n118)

		if v2263 == proto.wireTypes.varint then
			local v2264

			v2264, n118 = proto.readVarInt(p177, n118)
		elseif v2263 == proto.wireTypes.lengthDelimited then
			if v2262 == 1 then
				local v2265

				v2265, n118 = proto.readBuffer(p177, n118)
				v2260.prompt_id = buffer.tostring(v2265)
			elseif v2262 == 2 then
				local v2266

				v2266, n118 = proto.readBuffer(p177, n118)
				v2260.prompt_type = buffer.tostring(v2266)
			else
				local v2267, v2268 = proto.readVarInt(p177, n118)

				n118 = v2268 + v2267
			end
		elseif v2263 == proto.wireTypes.i32 then
			local v2269

			v2269, n118 = proto.readFixed32(p177, n118)
		elseif v2263 == proto.wireTypes.i64 then
			local v2270

			v2270, n118 = proto.readFixed64(p177, n118)
		else
			error("Unsupported wire type: " .. v2263)
		end
	end

	return v2260
end
function t282.jsonEncode(p178) -- line: 14392
	local t284 = {}

	if p178.prompt_id ~= nil and p178.prompt_id ~= "" then
		t284.promptId = p178.prompt_id
	end

	if p178.prompt_type ~= nil and p178.prompt_type ~= "" then
		t284.promptType = p178.prompt_type
	end

	return t284
end
function t282.jsonDecode(t285: {[any]: any}) -- line: 14406
	-- upvalues: t282 (copy)
	local v2274 = t282.new()

	if t285.prompt_id ~= nil then
		v2274.prompt_id = t285.prompt_id
	end

	if t285.promptId ~= nil then
		v2274.prompt_id = t285.promptId
	end

	if t285.prompt_type ~= nil then
		v2274.prompt_type = t285.prompt_type
	end

	if t285.promptType ~= nil then
		v2274.prompt_type = t285.promptType
	end

	return v2274
end

t282.descriptor = {
	name = "SystemBannerInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.SystemBannerInputData"
}
t1.SystemBannerInputData = t282
typeRegistry.default:register(t1.SystemBannerInputData)

local t286 = {}

t286.__index = t286

function t286.new(t287: {[any]: any}?) -- line: 14442
	-- upvalues: t286 (copy)
	return (setmetatable({
		upsell_prompt = if t287 ~= nil and t287.upsell_prompt ~= nil then t287.upsell_prompt else ""
	}, t286))
end
function t286.encode(p179) -- line: 14448
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n119 = 0

	if p179.upsell_prompt ~= nil and p179.upsell_prompt ~= "" then
		local v2279, v2280 = proto.writeTag(buf, n119, 1, proto.wireTypes.lengthDelimited)

		buf, n119 = proto.writeString(v2279, v2280, p179.upsell_prompt)
	end

	local buf64 = buffer.create(n119)

	buffer.copy(buf64, 0, buf, 0, n119)

	return buf64
end
function t286.decode(p180: buffer) -- line: 14462
	-- upvalues: t286 (copy), proto (copy)
	local v2283 = t286.new()
	local n120 = 0

	while n120 < buffer.len(p180) do
		local v2285, v2286

		v2285, v2286, n120 = proto.readTag(p180, n120)

		if v2286 == proto.wireTypes.varint then
			local v2287

			v2287, n120 = proto.readVarInt(p180, n120)
		elseif v2286 == proto.wireTypes.lengthDelimited then
			if v2285 == 1 then
				local v2288

				v2288, n120 = proto.readBuffer(p180, n120)
				v2283.upsell_prompt = buffer.tostring(v2288)
			else
				local v2289, v2290 = proto.readVarInt(p180, n120)

				n120 = v2290 + v2289
			end
		elseif v2286 == proto.wireTypes.i32 then
			local v2291

			v2291, n120 = proto.readFixed32(p180, n120)
		elseif v2286 == proto.wireTypes.i64 then
			local v2292

			v2292, n120 = proto.readFixed64(p180, n120)
		else
			error("Unsupported wire type: " .. v2286)
		end
	end

	return v2283
end
function t286.jsonEncode(p181) -- line: 14505
	local t288 = {}

	if p181.upsell_prompt ~= nil and p181.upsell_prompt ~= "" then
		t288.upsellPrompt = p181.upsell_prompt
	end

	return t288
end
function t286.jsonDecode(t289: {[any]: any}) -- line: 14515
	-- upvalues: t286 (copy)
	local v2296 = t286.new()

	if t289.upsell_prompt ~= nil then
		v2296.upsell_prompt = t289.upsell_prompt
	end

	if t289.upsellPrompt ~= nil then
		v2296.upsell_prompt = t289.upsellPrompt
	end

	return v2296
end

t286.descriptor = {
	name = "AgeCheckUpsellInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.AgeCheckUpsellInputData"
}
t1.AgeCheckUpsellInputData = t286
typeRegistry.default:register(t1.AgeCheckUpsellInputData)

local t290 = {}

t290.__index = t290

function t290.new(t291: {[any]: any}?) -- line: 14543
	-- upvalues: t290 (copy)
	return (setmetatable({
		modal_variant = if t291 ~= nil and t291.modal_variant ~= nil then t291.modal_variant else "",
		modal_sequence = if t291 ~= nil and t291.modal_sequence ~= nil then t291.modal_sequence else "",
		conversation_id = if t291 ~= nil and t291.conversation_id ~= nil then t291.conversation_id else "",
		friend_id = if t291 ~= nil and t291.friend_id ~= nil then t291.friend_id else ""
	}, t290))
end
function t290.encode(p182) -- line: 14554
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n121 = 0

	if p182.modal_variant ~= nil and p182.modal_variant ~= "" then
		local v2301, v2302 = proto.writeTag(buf, n121, 1, proto.wireTypes.lengthDelimited)

		buf, n121 = proto.writeString(v2301, v2302, p182.modal_variant)
	end

	if p182.modal_sequence ~= nil and p182.modal_sequence ~= "" then
		local v2303, v2304 = proto.writeTag(buf, n121, 2, proto.wireTypes.lengthDelimited)

		buf, n121 = proto.writeString(v2303, v2304, p182.modal_sequence)
	end

	if p182.conversation_id ~= nil and p182.conversation_id ~= "" then
		local v2305, v2306 = proto.writeTag(buf, n121, 3, proto.wireTypes.lengthDelimited)

		buf, n121 = proto.writeString(v2305, v2306, p182.conversation_id)
	end

	if p182.friend_id ~= nil and p182.friend_id ~= "" then
		local v2307, v2308 = proto.writeTag(buf, n121, 4, proto.wireTypes.lengthDelimited)

		buf, n121 = proto.writeString(v2307, v2308, p182.friend_id)
	end

	local buf65 = buffer.create(n121)

	buffer.copy(buf65, 0, buf, 0, n121)

	return buf65
end
function t290.decode(p183: buffer) -- line: 14583
	-- upvalues: t290 (copy), proto (copy)
	local v2311 = t290.new()
	local n122 = 0

	while n122 < buffer.len(p183) do
		local v2313, v2314

		v2313, v2314, n122 = proto.readTag(p183, n122)

		if v2314 == proto.wireTypes.varint then
			local v2315

			v2315, n122 = proto.readVarInt(p183, n122)
		elseif v2314 == proto.wireTypes.lengthDelimited then
			if v2313 == 1 then
				local v2316

				v2316, n122 = proto.readBuffer(p183, n122)
				v2311.modal_variant = buffer.tostring(v2316)
			elseif v2313 == 2 then
				local v2317

				v2317, n122 = proto.readBuffer(p183, n122)
				v2311.modal_sequence = buffer.tostring(v2317)
			elseif v2313 == 3 then
				local v2318

				v2318, n122 = proto.readBuffer(p183, n122)
				v2311.conversation_id = buffer.tostring(v2318)
			elseif v2313 == 4 then
				local v2319

				v2319, n122 = proto.readBuffer(p183, n122)
				v2311.friend_id = buffer.tostring(v2319)
			else
				local v2320, v2321 = proto.readVarInt(p183, n122)

				n122 = v2321 + v2320
			end
		elseif v2314 == proto.wireTypes.i32 then
			local v2322

			v2322, n122 = proto.readFixed32(p183, n122)
		elseif v2314 == proto.wireTypes.i64 then
			local v2323

			v2323, n122 = proto.readFixed64(p183, n122)
		else
			error("Unsupported wire type: " .. v2314)
		end
	end

	return v2311
end
function t290.jsonEncode(p184) -- line: 14641
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
function t290.jsonDecode(t293: {[any]: any}) -- line: 14663
	-- upvalues: t290 (copy)
	local v2327 = t290.new()

	if t293.modal_variant ~= nil then
		v2327.modal_variant = t293.modal_variant
	end

	if t293.modalVariant ~= nil then
		v2327.modal_variant = t293.modalVariant
	end

	if t293.modal_sequence ~= nil then
		v2327.modal_sequence = t293.modal_sequence
	end

	if t293.modalSequence ~= nil then
		v2327.modal_sequence = t293.modalSequence
	end

	if t293.conversation_id ~= nil then
		v2327.conversation_id = t293.conversation_id
	end

	if t293.conversationId ~= nil then
		v2327.conversation_id = t293.conversationId
	end

	if t293.friend_id ~= nil then
		v2327.friend_id = t293.friend_id
	end

	if t293.friendId ~= nil then
		v2327.friend_id = t293.friendId
	end

	return v2327
end

t290.descriptor = {
	name = "PartyChatConversationUpsellInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.PartyChatConversationUpsellInputData"
}
t1.PartyChatConversationUpsellInputData = t290
typeRegistry.default:register(t1.PartyChatConversationUpsellInputData)

local t294 = {}

t294.__index = t294

function t294.new(t295: {[any]: any}?) -- line: 14717
	-- upvalues: t294 (copy)
	return (setmetatable({
		event_id = if t295 ~= nil and t295.event_id ~= nil then t295.event_id else "",
		universe_id = if t295 ~= nil and t295.universe_id ~= nil then t295.universe_id else "",
		entry_map = if t295 ~= nil and t295.entry_map ~= nil then t295.entry_map else {},
		entry_order = if t295 ~= nil and t295.entry_order ~= nil then t295.entry_order else {}
	}, t294))
end
function t294.encode(p185) -- line: 14728
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n123 = 0

	if p185.event_id ~= nil and p185.event_id ~= "" then
		local v2332, v2333 = proto.writeTag(buf, n123, 1, proto.wireTypes.lengthDelimited)

		buf, n123 = proto.writeString(v2332, v2333, p185.event_id)
	end

	if p185.universe_id ~= nil and p185.universe_id ~= "" then
		local v2334, v2335 = proto.writeTag(buf, n123, 2, proto.wireTypes.lengthDelimited)

		buf, n123 = proto.writeString(v2334, v2335, p185.universe_id)
	end

	if p185.entry_map ~= nil and next(p185.entry_map) ~= nil then
		for v2336, v2337 in p185.entry_map do
			local buf66 = buffer.create(0)
			local v2339, v2340 = proto.writeTag(buf66, 0, 1, proto.wireTypes.lengthDelimited)
			local v2341, v2342 = proto.writeString(v2339, v2340, v2336)
			local v2343 = v2337:encode()
			local v2344, v2345 = proto.writeTag(v2341, v2342, 2, proto.wireTypes.lengthDelimited)
			local v2346, v2347 = proto.writeBuffer(v2344, v2345, v2343, buffer.len(v2343))
			local v2348, v2349 = proto.writeTag(buf, n123, 3, proto.wireTypes.lengthDelimited)

			buf, n123 = proto.writeBuffer(v2348, v2349, v2346, v2347)
		end
	end

	if p185.entry_order ~= nil and #p185.entry_order > 0 then
		for _, v2351 in p185.entry_order do
			local v2352, v2353 = proto.writeTag(buf, n123, 4, proto.wireTypes.lengthDelimited)

			buf, n123 = proto.writeString(v2352, v2353, v2351)
		end
	end

	local buf67 = buffer.create(n123)

	buffer.copy(buf67, 0, buf, 0, n123)

	return buf67
end
function t294.decode(p186: buffer) -- line: 14768
	-- upvalues: t294 (copy), proto (copy), t1 (copy)
	local v2356 = t294.new()
	local n124 = 0

	while n124 < buffer.len(p186) do
		local v2358, v2359

		v2358, v2359, n124 = proto.readTag(p186, n124)

		if v2359 == proto.wireTypes.varint then
			local v2360

			v2360, n124 = proto.readVarInt(p186, n124)
		elseif v2359 == proto.wireTypes.lengthDelimited then
			if v2358 == 1 then
				local v2361

				v2361, n124 = proto.readBuffer(p186, n124)
				v2356.event_id = buffer.tostring(v2361)
			elseif v2358 == 2 then
				local v2362

				v2362, n124 = proto.readBuffer(p186, n124)
				v2356.universe_id = buffer.tostring(v2362)
			elseif v2358 == 3 then
				local v2363

				v2363, n124 = proto.readBuffer(p186, n124)

				local v2364 = t1.EventDetailsFeedInputData_EntryMapEntry.decode(v2363)
				local v2365 = t1.FeedEntry.new()

				v2356.entry_map[v2364.key or ""] = v2364.value or v2365
			elseif v2358 == 4 then
				local v2366

				v2366, n124 = proto.readBuffer(p186, n124)
				table.insert(v2356.entry_order, buffer.tostring(v2366))
			else
				local v2367, v2368 = proto.readVarInt(p186, n124)

				n124 = v2368 + v2367
			end
		elseif v2359 == proto.wireTypes.i32 then
			local v2369

			v2369, n124 = proto.readFixed32(p186, n124)
		elseif v2359 == proto.wireTypes.i64 then
			local v2370

			v2370, n124 = proto.readFixed64(p186, n124)
		else
			error("Unsupported wire type: " .. v2359)
		end
	end

	return v2356
end
function t294.jsonEncode(p187) -- line: 14833
	local t296 = {}

	if p187.event_id ~= nil and p187.event_id ~= "" then
		t296.eventId = p187.event_id
	end

	if p187.universe_id ~= nil and p187.universe_id ~= "" then
		t296.universeId = p187.universe_id
	end

	if p187.entry_map ~= nil and next(p187.entry_map) ~= nil then
		local t297 = {}

		for v2374, v2375 in p187.entry_map do
			t297[v2374] = v2375:jsonEncode()
		end

		t296.entryMap = t297
	end

	if p187.entry_order ~= nil and #p187.entry_order > 0 then
		local t298 = {}

		for _, v2378 in p187.entry_order do
			table.insert(t298, v2378)
		end

		t296.entryOrder = t298
	end

	return t296
end
function t294.jsonDecode(t299: {[any]: any}) -- line: 14863
	-- upvalues: t294 (copy), t1 (copy)
	local v2380 = t294.new()

	if t299.event_id ~= nil then
		v2380.event_id = t299.event_id
	end

	if t299.eventId ~= nil then
		v2380.event_id = t299.eventId
	end

	if t299.universe_id ~= nil then
		v2380.universe_id = t299.universe_id
	end

	if t299.universeId ~= nil then
		v2380.universe_id = t299.universeId
	end

	if t299.entry_map ~= nil then
		local t300 = {}

		for v2382, v2383 in t299.entry_map do
			t300[v2382] = t1.FeedEntry.jsonDecode(v2383)
		end

		v2380.entry_map = t300
	end

	if t299.entryMap ~= nil then
		local t301 = {}

		for v2385, v2386 in t299.entryMap do
			t301[v2385] = t1.FeedEntry.jsonDecode(v2386)
		end

		v2380.entry_map = t301
	end

	if t299.entry_order ~= nil then
		local t302 = {}

		for _, v2389 in t299.entry_order do
			table.insert(t302, v2389)
		end

		v2380.entry_order = t302
	end

	if t299.entryOrder ~= nil then
		local t303 = {}

		for _, v2392 in t299.entryOrder do
			table.insert(t303, v2392)
		end

		v2380.entry_order = t303
	end

	return v2380
end

t294.descriptor = {
	name = "EventDetailsFeedInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventDetailsFeedInputData"
}
t1.EventDetailsFeedInputData = t294
typeRegistry.default:register(t1.EventDetailsFeedInputData)

local t304 = {}

t304.__index = t304

function t304.new(t305: {[any]: any}?) -- line: 14935
	-- upvalues: t304 (copy)
	return (setmetatable({
		key = if t305 ~= nil and t305.key ~= nil then t305.key else "",
		value = if t305 ~= nil and t305.value ~= nil then t305.value else nil
	}, t304))
end
function t304.encode(p188) -- line: 14944
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n125 = 0

	if p188.key ~= nil and p188.key ~= "" then
		local v2397, v2398 = proto.writeTag(buf, n125, 1, proto.wireTypes.lengthDelimited)

		buf, n125 = proto.writeString(v2397, v2398, p188.key)
	end

	if p188.value ~= nil then
		local v2399 = p188.value:encode()
		local v2400, v2401 = proto.writeTag(buf, n125, 2, proto.wireTypes.lengthDelimited)

		buf, n125 = proto.writeBuffer(v2400, v2401, v2399, buffer.len(v2399))
	end

	local buf68 = buffer.create(n125)

	buffer.copy(buf68, 0, buf, 0, n125)

	return buf68
end
function t304.decode(p189: buffer) -- line: 14964
	-- upvalues: t304 (copy), proto (copy), t1 (copy)
	local v2404 = t304.new()
	local n126 = 0

	while n126 < buffer.len(p189) do
		local v2406, v2407

		v2406, v2407, n126 = proto.readTag(p189, n126)

		if v2407 == proto.wireTypes.varint then
			local v2408

			v2408, n126 = proto.readVarInt(p189, n126)
		elseif v2407 == proto.wireTypes.lengthDelimited then
			if v2406 == 1 then
				local v2409

				v2409, n126 = proto.readBuffer(p189, n126)
				v2404.key = buffer.tostring(v2409)
			elseif v2406 == 2 then
				local v2410

				v2410, n126 = proto.readBuffer(p189, n126)
				v2404.value = t1.FeedEntry.decode(v2410)
			else
				local v2411, v2412 = proto.readVarInt(p189, n126)

				n126 = v2412 + v2411
			end
		elseif v2407 == proto.wireTypes.i32 then
			local v2413

			v2413, n126 = proto.readFixed32(p189, n126)
		elseif v2407 == proto.wireTypes.i64 then
			local v2414

			v2414, n126 = proto.readFixed64(p189, n126)
		else
			error("Unsupported wire type: " .. v2407)
		end
	end

	return v2404
end
function t304.jsonEncode(p190) -- line: 15012
	local t306 = {}

	if p190.key ~= nil and p190.key ~= "" then
		t306.key = p190.key
	end

	if p190.value ~= nil then
		t306.value = p190.value:jsonEncode()
	end

	return t306
end
function t304.jsonDecode(t307: {[any]: any}) -- line: 15026
	-- upvalues: t304 (copy), t1 (copy)
	local v2418 = t304.new()

	if t307.key ~= nil then
		v2418.key = t307.key
	end

	if t307.value ~= nil then
		v2418.value = t1.FeedEntry.jsonDecode(t307.value)
	end

	return v2418
end

t304.descriptor = {
	name = "EventDetailsFeedInputData_EntryMapEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryMapEntry"
}
t1.EventDetailsFeedInputData_EntryMapEntry = t304
typeRegistry.default:register(t1.EventDetailsFeedInputData_EntryMapEntry)

local t308 = {}

t308.__index = t308

function t308.new(t309: {[any]: any}?) -- line: 15056
	-- upvalues: t308 (copy)
	return (setmetatable({
		event_id = if t309 ~= nil and t309.event_id ~= nil then t309.event_id else "",
		universe_id = if t309 ~= nil and t309.universe_id ~= nil then t309.universe_id else ""
	}, t308))
end
function t308.encode(p191) -- line: 15065
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n127 = 0

	if p191.event_id ~= nil and p191.event_id ~= "" then
		local v2423, v2424 = proto.writeTag(buf, n127, 1, proto.wireTypes.lengthDelimited)

		buf, n127 = proto.writeString(v2423, v2424, p191.event_id)
	end

	if p191.universe_id ~= nil and p191.universe_id ~= "" then
		local v2425, v2426 = proto.writeTag(buf, n127, 2, proto.wireTypes.lengthDelimited)

		buf, n127 = proto.writeString(v2425, v2426, p191.universe_id)
	end

	local buf69 = buffer.create(n127)

	buffer.copy(buf69, 0, buf, 0, n127)

	return buf69
end
function t308.decode(p192: buffer) -- line: 15084
	-- upvalues: t308 (copy), proto (copy)
	local v2429 = t308.new()
	local n128 = 0

	while n128 < buffer.len(p192) do
		local v2431, v2432

		v2431, v2432, n128 = proto.readTag(p192, n128)

		if v2432 == proto.wireTypes.varint then
			local v2433

			v2433, n128 = proto.readVarInt(p192, n128)
		elseif v2432 == proto.wireTypes.lengthDelimited then
			if v2431 == 1 then
				local v2434

				v2434, n128 = proto.readBuffer(p192, n128)
				v2429.event_id = buffer.tostring(v2434)
			elseif v2431 == 2 then
				local v2435

				v2435, n128 = proto.readBuffer(p192, n128)
				v2429.universe_id = buffer.tostring(v2435)
			else
				local v2436, v2437 = proto.readVarInt(p192, n128)

				n128 = v2437 + v2436
			end
		elseif v2432 == proto.wireTypes.i32 then
			local v2438

			v2438, n128 = proto.readFixed32(p192, n128)
		elseif v2432 == proto.wireTypes.i64 then
			local v2439

			v2439, n128 = proto.readFixed64(p192, n128)
		else
			error("Unsupported wire type: " .. v2432)
		end
	end

	return v2429
end
function t308.jsonEncode(p193) -- line: 15132
	local t310 = {}

	if p193.event_id ~= nil and p193.event_id ~= "" then
		t310.eventId = p193.event_id
	end

	if p193.universe_id ~= nil and p193.universe_id ~= "" then
		t310.universeId = p193.universe_id
	end

	return t310
end
function t308.jsonDecode(t311: {[any]: any}) -- line: 15146
	-- upvalues: t308 (copy)
	local v2443 = t308.new()

	if t311.event_id ~= nil then
		v2443.event_id = t311.event_id
	end

	if t311.eventId ~= nil then
		v2443.event_id = t311.eventId
	end

	if t311.universe_id ~= nil then
		v2443.universe_id = t311.universe_id
	end

	if t311.universeId ~= nil then
		v2443.universe_id = t311.universeId
	end

	return v2443
end

t308.descriptor = {
	name = "EventDetailsActionBarInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventDetailsActionBarInputData"
}
t1.EventDetailsActionBarInputData = t308
typeRegistry.default:register(t1.EventDetailsActionBarInputData)

local t312 = {}

t312.__index = t312

function t312.new(t313: {[any]: any}?) -- line: 15182
	-- upvalues: t312 (copy)
	return (setmetatable({
		event_id = if t313 ~= nil and t313.event_id ~= nil then t313.event_id else ""
	}, t312))
end
function t312.encode(p194) -- line: 15190
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n129 = 0

	if p194.event_id ~= nil and p194.event_id ~= "" then
		local v2448, v2449 = proto.writeTag(buf, n129, 1, proto.wireTypes.lengthDelimited)

		buf, n129 = proto.writeString(v2448, v2449, p194.event_id)
	end

	local buf70 = buffer.create(n129)

	buffer.copy(buf70, 0, buf, 0, n129)

	return buf70
end
function t312.decode(p195: buffer) -- line: 15204
	-- upvalues: t312 (copy), proto (copy)
	local v2452 = t312.new()
	local n130 = 0

	while n130 < buffer.len(p195) do
		local v2454, v2455

		v2454, v2455, n130 = proto.readTag(p195, n130)

		if v2455 == proto.wireTypes.varint then
			local v2456

			v2456, n130 = proto.readVarInt(p195, n130)
		elseif v2455 == proto.wireTypes.lengthDelimited then
			if v2454 == 1 then
				local v2457

				v2457, n130 = proto.readBuffer(p195, n130)
				v2452.event_id = buffer.tostring(v2457)
			else
				local v2458, v2459 = proto.readVarInt(p195, n130)

				n130 = v2459 + v2458
			end
		elseif v2455 == proto.wireTypes.i32 then
			local v2460

			v2460, n130 = proto.readFixed32(p195, n130)
		elseif v2455 == proto.wireTypes.i64 then
			local v2461

			v2461, n130 = proto.readFixed64(p195, n130)
		else
			error("Unsupported wire type: " .. v2455)
		end
	end

	return v2452
end
function t312.jsonEncode(p196) -- line: 15247
	local t314 = {}

	if p196.event_id ~= nil and p196.event_id ~= "" then
		t314.eventId = p196.event_id
	end

	return t314
end
function t312.jsonDecode(t315: {[any]: any}) -- line: 15257
	-- upvalues: t312 (copy)
	local v2465 = t312.new()

	if t315.event_id ~= nil then
		v2465.event_id = t315.event_id
	end

	if t315.eventId ~= nil then
		v2465.event_id = t315.eventId
	end

	return v2465
end

t312.descriptor = {
	name = "EventDescriptionInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventDescriptionInputData"
}
t1.EventDescriptionInputData = t312
typeRegistry.default:register(t1.EventDescriptionInputData)

local t316 = {}

t316.__index = t316

function t316.new(t317: {[any]: any}?) -- line: 15285
	-- upvalues: t316 (copy)
	return (setmetatable({
		event_id = if t317 ~= nil and t317.event_id ~= nil then t317.event_id else "",
		universe_id = if t317 ~= nil and t317.universe_id ~= nil then t317.universe_id else ""
	}, t316))
end
function t316.encode(p197) -- line: 15294
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n131 = 0

	if p197.event_id ~= nil and p197.event_id ~= "" then
		local v2470, v2471 = proto.writeTag(buf, n131, 1, proto.wireTypes.lengthDelimited)

		buf, n131 = proto.writeString(v2470, v2471, p197.event_id)
	end

	if p197.universe_id ~= nil and p197.universe_id ~= "" then
		local v2472, v2473 = proto.writeTag(buf, n131, 2, proto.wireTypes.lengthDelimited)

		buf, n131 = proto.writeString(v2472, v2473, p197.universe_id)
	end

	local buf71 = buffer.create(n131)

	buffer.copy(buf71, 0, buf, 0, n131)

	return buf71
end
function t316.decode(p198: buffer) -- line: 15313
	-- upvalues: t316 (copy), proto (copy)
	local v2476 = t316.new()
	local n132 = 0

	while n132 < buffer.len(p198) do
		local v2478, v2479

		v2478, v2479, n132 = proto.readTag(p198, n132)

		if v2479 == proto.wireTypes.varint then
			local v2480

			v2480, n132 = proto.readVarInt(p198, n132)
		elseif v2479 == proto.wireTypes.lengthDelimited then
			if v2478 == 1 then
				local v2481

				v2481, n132 = proto.readBuffer(p198, n132)
				v2476.event_id = buffer.tostring(v2481)
			elseif v2478 == 2 then
				local v2482

				v2482, n132 = proto.readBuffer(p198, n132)
				v2476.universe_id = buffer.tostring(v2482)
			else
				local v2483, v2484 = proto.readVarInt(p198, n132)

				n132 = v2484 + v2483
			end
		elseif v2479 == proto.wireTypes.i32 then
			local v2485

			v2485, n132 = proto.readFixed32(p198, n132)
		elseif v2479 == proto.wireTypes.i64 then
			local v2486

			v2486, n132 = proto.readFixed64(p198, n132)
		else
			error("Unsupported wire type: " .. v2479)
		end
	end

	return v2476
end
function t316.jsonEncode(p199) -- line: 15361
	local t318 = {}

	if p199.event_id ~= nil and p199.event_id ~= "" then
		t318.eventId = p199.event_id
	end

	if p199.universe_id ~= nil and p199.universe_id ~= "" then
		t318.universeId = p199.universe_id
	end

	return t318
end
function t316.jsonDecode(t319: {[any]: any}) -- line: 15375
	-- upvalues: t316 (copy)
	local v2490 = t316.new()

	if t319.event_id ~= nil then
		v2490.event_id = t319.event_id
	end

	if t319.eventId ~= nil then
		v2490.event_id = t319.eventId
	end

	if t319.universe_id ~= nil then
		v2490.universe_id = t319.universe_id
	end

	if t319.universeId ~= nil then
		v2490.universe_id = t319.universeId
	end

	return v2490
end

t316.descriptor = {
	name = "EventAttributionRowInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventAttributionRowInputData"
}
t1.EventAttributionRowInputData = t316
typeRegistry.default:register(t1.EventAttributionRowInputData)

local t320 = {}

t320.__index = t320

function t320.new(t321: {[any]: any}?) -- line: 15411
	-- upvalues: t320 (copy)
	return (setmetatable({
		event_id = if t321 ~= nil and t321.event_id ~= nil then t321.event_id else ""
	}, t320))
end
function t320.encode(p200) -- line: 15417
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n133 = 0

	if p200.event_id ~= nil and p200.event_id ~= "" then
		local v2495, v2496 = proto.writeTag(buf, n133, 1, proto.wireTypes.lengthDelimited)

		buf, n133 = proto.writeString(v2495, v2496, p200.event_id)
	end

	local buf72 = buffer.create(n133)

	buffer.copy(buf72, 0, buf, 0, n133)

	return buf72
end
function t320.decode(p201: buffer) -- line: 15431
	-- upvalues: t320 (copy), proto (copy)
	local v2499 = t320.new()
	local n134 = 0

	while n134 < buffer.len(p201) do
		local v2501, v2502

		v2501, v2502, n134 = proto.readTag(p201, n134)

		if v2502 == proto.wireTypes.varint then
			local v2503

			v2503, n134 = proto.readVarInt(p201, n134)
		elseif v2502 == proto.wireTypes.lengthDelimited then
			if v2501 == 1 then
				local v2504

				v2504, n134 = proto.readBuffer(p201, n134)
				v2499.event_id = buffer.tostring(v2504)
			else
				local v2505, v2506 = proto.readVarInt(p201, n134)

				n134 = v2506 + v2505
			end
		elseif v2502 == proto.wireTypes.i32 then
			local v2507

			v2507, n134 = proto.readFixed32(p201, n134)
		elseif v2502 == proto.wireTypes.i64 then
			local v2508

			v2508, n134 = proto.readFixed64(p201, n134)
		else
			error("Unsupported wire type: " .. v2502)
		end
	end

	return v2499
end
function t320.jsonEncode(p202) -- line: 15474
	local t322 = {}

	if p202.event_id ~= nil and p202.event_id ~= "" then
		t322.eventId = p202.event_id
	end

	return t322
end
function t320.jsonDecode(t323: {[any]: any}) -- line: 15484
	-- upvalues: t320 (copy)
	local v2512 = t320.new()

	if t323.event_id ~= nil then
		v2512.event_id = t323.event_id
	end

	if t323.eventId ~= nil then
		v2512.event_id = t323.eventId
	end

	return v2512
end

t320.descriptor = {
	name = "EventInfoTableInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventInfoTableInputData"
}
t1.EventInfoTableInputData = t320
typeRegistry.default:register(t1.EventInfoTableInputData)

local t324 = {}

t324.__index = t324

function t324.new(t325: {[any]: any}?) -- line: 15512
	-- upvalues: t324 (copy)
	return (setmetatable({
		event_id = if t325 ~= nil and t325.event_id ~= nil then t325.event_id else ""
	}, t324))
end
function t324.encode(p203) -- line: 15520
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n135 = 0

	if p203.event_id ~= nil and p203.event_id ~= "" then
		local v2517, v2518 = proto.writeTag(buf, n135, 1, proto.wireTypes.lengthDelimited)

		buf, n135 = proto.writeString(v2517, v2518, p203.event_id)
	end

	local buf73 = buffer.create(n135)

	buffer.copy(buf73, 0, buf, 0, n135)

	return buf73
end
function t324.decode(p204: buffer) -- line: 15534
	-- upvalues: t324 (copy), proto (copy)
	local v2521 = t324.new()
	local n136 = 0

	while n136 < buffer.len(p204) do
		local v2523, v2524

		v2523, v2524, n136 = proto.readTag(p204, n136)

		if v2524 == proto.wireTypes.varint then
			local v2525

			v2525, n136 = proto.readVarInt(p204, n136)
		elseif v2524 == proto.wireTypes.lengthDelimited then
			if v2523 == 1 then
				local v2526

				v2526, n136 = proto.readBuffer(p204, n136)
				v2521.event_id = buffer.tostring(v2526)
			else
				local v2527, v2528 = proto.readVarInt(p204, n136)

				n136 = v2528 + v2527
			end
		elseif v2524 == proto.wireTypes.i32 then
			local v2529

			v2529, n136 = proto.readFixed32(p204, n136)
		elseif v2524 == proto.wireTypes.i64 then
			local v2530

			v2530, n136 = proto.readFixed64(p204, n136)
		else
			error("Unsupported wire type: " .. v2524)
		end
	end

	return v2521
end
function t324.jsonEncode(p205) -- line: 15577
	local t326 = {}

	if p205.event_id ~= nil and p205.event_id ~= "" then
		t326.eventId = p205.event_id
	end

	return t326
end
function t324.jsonDecode(t327: {[any]: any}) -- line: 15587
	-- upvalues: t324 (copy)
	local v2534 = t324.new()

	if t327.event_id ~= nil then
		v2534.event_id = t327.event_id
	end

	if t327.eventId ~= nil then
		v2534.event_id = t327.eventId
	end

	return v2534
end

t324.descriptor = {
	name = "EventDetailsSheetFullBleedInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventDetailsSheetFullBleedInputData"
}
t1.EventDetailsSheetFullBleedInputData = t324
typeRegistry.default:register(t1.EventDetailsSheetFullBleedInputData)

local t328 = {}

t328.__index = t328

function t328.new(t329: {[any]: any}?) -- line: 15617
	-- upvalues: t328 (copy)
	return (setmetatable({
		event_id = if t329 ~= nil and t329.event_id ~= nil then t329.event_id else "",
		universe_id = if t329 ~= nil and t329.universe_id ~= nil then t329.universe_id else ""
	}, t328))
end
function t328.encode(p206) -- line: 15626
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n137 = 0

	if p206.event_id ~= nil and p206.event_id ~= "" then
		local v2539, v2540 = proto.writeTag(buf, n137, 1, proto.wireTypes.lengthDelimited)

		buf, n137 = proto.writeString(v2539, v2540, p206.event_id)
	end

	if p206.universe_id ~= nil and p206.universe_id ~= "" then
		local v2541, v2542 = proto.writeTag(buf, n137, 2, proto.wireTypes.lengthDelimited)

		buf, n137 = proto.writeString(v2541, v2542, p206.universe_id)
	end

	local buf74 = buffer.create(n137)

	buffer.copy(buf74, 0, buf, 0, n137)

	return buf74
end
function t328.decode(p207: buffer) -- line: 15645
	-- upvalues: t328 (copy), proto (copy)
	local v2545 = t328.new()
	local n138 = 0

	while n138 < buffer.len(p207) do
		local v2547, v2548

		v2547, v2548, n138 = proto.readTag(p207, n138)

		if v2548 == proto.wireTypes.varint then
			local v2549

			v2549, n138 = proto.readVarInt(p207, n138)
		elseif v2548 == proto.wireTypes.lengthDelimited then
			if v2547 == 1 then
				local v2550

				v2550, n138 = proto.readBuffer(p207, n138)
				v2545.event_id = buffer.tostring(v2550)
			elseif v2547 == 2 then
				local v2551

				v2551, n138 = proto.readBuffer(p207, n138)
				v2545.universe_id = buffer.tostring(v2551)
			else
				local v2552, v2553 = proto.readVarInt(p207, n138)

				n138 = v2553 + v2552
			end
		elseif v2548 == proto.wireTypes.i32 then
			local v2554

			v2554, n138 = proto.readFixed32(p207, n138)
		elseif v2548 == proto.wireTypes.i64 then
			local v2555

			v2555, n138 = proto.readFixed64(p207, n138)
		else
			error("Unsupported wire type: " .. v2548)
		end
	end

	return v2545
end
function t328.jsonEncode(p208) -- line: 15693
	local t330 = {}

	if p208.event_id ~= nil and p208.event_id ~= "" then
		t330.eventId = p208.event_id
	end

	if p208.universe_id ~= nil and p208.universe_id ~= "" then
		t330.universeId = p208.universe_id
	end

	return t330
end
function t328.jsonDecode(t331: {[any]: any}) -- line: 15707
	-- upvalues: t328 (copy)
	local v2559 = t328.new()

	if t331.event_id ~= nil then
		v2559.event_id = t331.event_id
	end

	if t331.eventId ~= nil then
		v2559.event_id = t331.eventId
	end

	if t331.universe_id ~= nil then
		v2559.universe_id = t331.universe_id
	end

	if t331.universeId ~= nil then
		v2559.universe_id = t331.universeId
	end

	return v2559
end

t328.descriptor = {
	name = "EventNotificationsModalInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventNotificationsModalInputData"
}
t1.EventNotificationsModalInputData = t328
typeRegistry.default:register(t1.EventNotificationsModalInputData)

local t332 = {}

t332.__index = t332

function t332.new(t333: {[any]: any}?) -- line: 15745
	-- upvalues: t332 (copy)
	return (setmetatable({
		entry_map = if t333 ~= nil and t333.entry_map ~= nil then t333.entry_map else {},
		entry_order = if t333 ~= nil and t333.entry_order ~= nil then t333.entry_order else {},
		next_page_token = if t333 ~= nil and t333.next_page_token ~= nil then t333.next_page_token else "",
		sticky_filter_pills = if t333 ~= nil and t333.sticky_filter_pills ~= nil then t333.sticky_filter_pills else nil,
		applied_filters = if t333 ~= nil and t333.applied_filters ~= nil then t333.applied_filters else ""
	}, t332))
end
function t332.encode(p209) -- line: 15757
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n139 = 0

	if p209.entry_map ~= nil and next(p209.entry_map) ~= nil then
		for v2564, v2565 in p209.entry_map do
			local buf75 = buffer.create(0)
			local v2567, v2568 = proto.writeTag(buf75, 0, 1, proto.wireTypes.lengthDelimited)
			local v2569, v2570 = proto.writeString(v2567, v2568, v2564)
			local v2571 = v2565:encode()
			local v2572, v2573 = proto.writeTag(v2569, v2570, 2, proto.wireTypes.lengthDelimited)
			local v2574, v2575 = proto.writeBuffer(v2572, v2573, v2571, buffer.len(v2571))
			local v2576, v2577 = proto.writeTag(buf, n139, 1, proto.wireTypes.lengthDelimited)

			buf, n139 = proto.writeBuffer(v2576, v2577, v2574, v2575)
		end
	end

	if p209.entry_order ~= nil and #p209.entry_order > 0 then
		for _, v2579 in p209.entry_order do
			local v2580, v2581 = proto.writeTag(buf, n139, 2, proto.wireTypes.lengthDelimited)

			buf, n139 = proto.writeString(v2580, v2581, v2579)
		end
	end

	if p209.next_page_token ~= nil and p209.next_page_token ~= "" then
		local v2582, v2583 = proto.writeTag(buf, n139, 3, proto.wireTypes.lengthDelimited)

		buf, n139 = proto.writeString(v2582, v2583, p209.next_page_token)
	end

	if p209.sticky_filter_pills ~= nil then
		local v2584 = p209.sticky_filter_pills:encode()
		local v2585, v2586 = proto.writeTag(buf, n139, 4, proto.wireTypes.lengthDelimited)

		buf, n139 = proto.writeBuffer(v2585, v2586, v2584, buffer.len(v2584))
	end

	if p209.applied_filters ~= nil and p209.applied_filters ~= "" then
		local v2587, v2588 = proto.writeTag(buf, n139, 5, proto.wireTypes.lengthDelimited)

		buf, n139 = proto.writeString(v2587, v2588, p209.applied_filters)
	end

	local buf76 = buffer.create(n139)

	buffer.copy(buf76, 0, buf, 0, n139)

	return buf76
end
function t332.decode(p210: buffer) -- line: 15803
	-- upvalues: t332 (copy), proto (copy), t1 (copy)
	local v2591 = t332.new()
	local n140 = 0

	while n140 < buffer.len(p210) do
		local v2593, v2594

		v2593, v2594, n140 = proto.readTag(p210, n140)

		if v2594 == proto.wireTypes.varint then
			local v2595

			v2595, n140 = proto.readVarInt(p210, n140)
		elseif v2594 == proto.wireTypes.lengthDelimited then
			if v2593 == 1 then
				local v2596

				v2596, n140 = proto.readBuffer(p210, n140)

				local v2597 = t1.ChartsFeedInputData_EntryMapEntry.decode(v2596)
				local v2598 = t1.FeedEntry.new()

				v2591.entry_map[v2597.key or ""] = v2597.value or v2598
			elseif v2593 == 2 then
				local v2599

				v2599, n140 = proto.readBuffer(p210, n140)
				table.insert(v2591.entry_order, buffer.tostring(v2599))
			elseif v2593 == 3 then
				local v2600

				v2600, n140 = proto.readBuffer(p210, n140)
				v2591.next_page_token = buffer.tostring(v2600)
			elseif v2593 == 4 then
				local v2601

				v2601, n140 = proto.readBuffer(p210, n140)
				v2591.sticky_filter_pills = t1.FilterPillsInputData.decode(v2601)
			elseif v2593 == 5 then
				local v2602

				v2602, n140 = proto.readBuffer(p210, n140)
				v2591.applied_filters = buffer.tostring(v2602)
			else
				local v2603, v2604 = proto.readVarInt(p210, n140)

				n140 = v2604 + v2603
			end
		elseif v2594 == proto.wireTypes.i32 then
			local v2605

			v2605, n140 = proto.readFixed32(p210, n140)
		elseif v2594 == proto.wireTypes.i64 then
			local v2606

			v2606, n140 = proto.readFixed64(p210, n140)
		else
			error("Unsupported wire type: " .. v2594)
		end
	end

	return v2591
end
function t332.jsonEncode(p211) -- line: 15873
	local t334 = {}

	if p211.entry_map ~= nil and next(p211.entry_map) ~= nil then
		local t335 = {}

		for v2610, v2611 in p211.entry_map do
			t335[v2610] = v2611:jsonEncode()
		end

		t334.entryMap = t335
	end

	if p211.entry_order ~= nil and #p211.entry_order > 0 then
		local t336 = {}

		for _, v2614 in p211.entry_order do
			table.insert(t336, v2614)
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
function t332.jsonDecode(t337: {[any]: any}) -- line: 15907
	-- upvalues: t332 (copy), t1 (copy)
	local v2616 = t332.new()

	if t337.entry_map ~= nil then
		local t338 = {}

		for v2618, v2619 in t337.entry_map do
			t338[v2618] = t1.FeedEntry.jsonDecode(v2619)
		end

		v2616.entry_map = t338
	end

	if t337.entryMap ~= nil then
		local t339 = {}

		for v2621, v2622 in t337.entryMap do
			t339[v2621] = t1.FeedEntry.jsonDecode(v2622)
		end

		v2616.entry_map = t339
	end

	if t337.entry_order ~= nil then
		local t340 = {}

		for _, v2625 in t337.entry_order do
			table.insert(t340, v2625)
		end

		v2616.entry_order = t340
	end

	if t337.entryOrder ~= nil then
		local t341 = {}

		for _, v2628 in t337.entryOrder do
			table.insert(t341, v2628)
		end

		v2616.entry_order = t341
	end

	if t337.next_page_token ~= nil then
		v2616.next_page_token = t337.next_page_token
	end

	if t337.nextPageToken ~= nil then
		v2616.next_page_token = t337.nextPageToken
	end

	if t337.sticky_filter_pills ~= nil then
		v2616.sticky_filter_pills = t1.FilterPillsInputData.jsonDecode(t337.sticky_filter_pills)
	end

	if t337.stickyFilterPills ~= nil then
		v2616.sticky_filter_pills = t1.FilterPillsInputData.jsonDecode(t337.stickyFilterPills)
	end

	if t337.applied_filters ~= nil then
		v2616.applied_filters = t337.applied_filters
	end

	if t337.appliedFilters ~= nil then
		v2616.applied_filters = t337.appliedFilters
	end

	return v2616
end

t332.descriptor = {
	name = "ChartsFeedInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ChartsFeedInputData"
}
t1.ChartsFeedInputData = t332
typeRegistry.default:register(t1.ChartsFeedInputData)

local t342 = {}

t342.__index = t342

function t342.new(t343: {[any]: any}?) -- line: 15987
	-- upvalues: t342 (copy)
	return (setmetatable({
		key = if t343 ~= nil and t343.key ~= nil then t343.key else "",
		value = if t343 ~= nil and t343.value ~= nil then t343.value else nil
	}, t342))
end
function t342.encode(p212) -- line: 15996
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n141 = 0

	if p212.key ~= nil and p212.key ~= "" then
		local v2633, v2634 = proto.writeTag(buf, n141, 1, proto.wireTypes.lengthDelimited)

		buf, n141 = proto.writeString(v2633, v2634, p212.key)
	end

	if p212.value ~= nil then
		local v2635 = p212.value:encode()
		local v2636, v2637 = proto.writeTag(buf, n141, 2, proto.wireTypes.lengthDelimited)

		buf, n141 = proto.writeBuffer(v2636, v2637, v2635, buffer.len(v2635))
	end

	local buf77 = buffer.create(n141)

	buffer.copy(buf77, 0, buf, 0, n141)

	return buf77
end
function t342.decode(p213: buffer) -- line: 16016
	-- upvalues: t342 (copy), proto (copy), t1 (copy)
	local v2640 = t342.new()
	local n142 = 0

	while n142 < buffer.len(p213) do
		local v2642, v2643

		v2642, v2643, n142 = proto.readTag(p213, n142)

		if v2643 == proto.wireTypes.varint then
			local v2644

			v2644, n142 = proto.readVarInt(p213, n142)
		elseif v2643 == proto.wireTypes.lengthDelimited then
			if v2642 == 1 then
				local v2645

				v2645, n142 = proto.readBuffer(p213, n142)
				v2640.key = buffer.tostring(v2645)
			elseif v2642 == 2 then
				local v2646

				v2646, n142 = proto.readBuffer(p213, n142)
				v2640.value = t1.FeedEntry.decode(v2646)
			else
				local v2647, v2648 = proto.readVarInt(p213, n142)

				n142 = v2648 + v2647
			end
		elseif v2643 == proto.wireTypes.i32 then
			local v2649

			v2649, n142 = proto.readFixed32(p213, n142)
		elseif v2643 == proto.wireTypes.i64 then
			local v2650

			v2650, n142 = proto.readFixed64(p213, n142)
		else
			error("Unsupported wire type: " .. v2643)
		end
	end

	return v2640
end
function t342.jsonEncode(p214) -- line: 16064
	local t344 = {}

	if p214.key ~= nil and p214.key ~= "" then
		t344.key = p214.key
	end

	if p214.value ~= nil then
		t344.value = p214.value:jsonEncode()
	end

	return t344
end
function t342.jsonDecode(t345: {[any]: any}) -- line: 16078
	-- upvalues: t342 (copy), t1 (copy)
	local v2654 = t342.new()

	if t345.key ~= nil then
		v2654.key = t345.key
	end

	if t345.value ~= nil then
		v2654.value = t1.FeedEntry.jsonDecode(t345.value)
	end

	return v2654
end

t342.descriptor = {
	name = "ChartsFeedInputData_EntryMapEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryMapEntry"
}
t1.ChartsFeedInputData_EntryMapEntry = t342
typeRegistry.default:register(t1.ChartsFeedInputData_EntryMapEntry)

local t346 = {}

t346.__index = t346

function t346.new(t347: {[any]: any}?) -- line: 16108
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
function t346.encode(p215) -- line: 16119
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n143 = 0

	if p215.filter_groups ~= nil and #p215.filter_groups > 0 then
		for _, v2660 in p215.filter_groups do
			local v2661 = v2660:encode()
			local v2662, v2663 = proto.writeTag(buf, n143, 1, proto.wireTypes.lengthDelimited)

			buf, n143 = proto.writeBuffer(v2662, v2663, v2661, buffer.len(v2661))
		end
	end

	if p215.sort_id ~= nil and p215.sort_id ~= "" then
		local v2664, v2665 = proto.writeTag(buf, n143, 2, proto.wireTypes.lengthDelimited)

		buf, n143 = proto.writeString(v2664, v2665, p215.sort_id)
	end

	if p215.secondary_sort_id ~= nil and p215.secondary_sort_id ~= 0 then
		local v2666, v2667 = proto.writeTag(buf, n143, 3, proto.wireTypes.varint)

		buf, n143 = proto.writeVarInt(v2666, v2667, p215.secondary_sort_id)
	end

	if p215.title ~= nil and p215.title ~= "" then
		local v2668, v2669 = proto.writeTag(buf, n143, 4, proto.wireTypes.lengthDelimited)

		buf, n143 = proto.writeString(v2668, v2669, p215.title)
	end

	if p215.primary_sort_id ~= nil then
		local v2670, v2671 = proto.writeTag(buf, n143, 5, proto.wireTypes.varint)

		buf, n143 = proto.writeVarInt(v2670, v2671, p215.primary_sort_id)
	end

	if p215.applied_filters ~= nil then
		local v2672, v2673 = proto.writeTag(buf, n143, 6, proto.wireTypes.lengthDelimited)

		buf, n143 = proto.writeString(v2672, v2673, p215.applied_filters)
	end

	local buf78 = buffer.create(n143)

	buffer.copy(buf78, 0, buf, 0, n143)

	return buf78
end
function t346.decode(p216: buffer) -- line: 16161
	-- upvalues: t346 (copy), proto (copy), t1 (copy)
	local v2676 = t346.new()
	local n144 = 0

	while n144 < buffer.len(p216) do
		local v2678, v2679

		v2678, v2679, n144 = proto.readTag(p216, n144)

		if v2679 == proto.wireTypes.varint then
			if v2678 == 3 then
				local v2680

				v2680, n144 = proto.readVarIntI32(p216, n144)
				v2676.secondary_sort_id = v2680
			elseif v2678 == 5 then
				local v2681

				v2681, n144 = proto.readVarIntI32(p216, n144)
				v2676.primary_sort_id = v2681
			else
				local v2682

				v2682, n144 = proto.readVarInt(p216, n144)
			end
		elseif v2679 == proto.wireTypes.lengthDelimited then
			if v2678 == 1 then
				local v2683

				v2683, n144 = proto.readBuffer(p216, n144)
				table.insert(v2676.filter_groups, t1.FilterPillsInputData_FilterGroup.decode(v2683))
			elseif v2678 == 2 then
				local v2684

				v2684, n144 = proto.readBuffer(p216, n144)
				v2676.sort_id = buffer.tostring(v2684)
			elseif v2678 == 4 then
				local v2685

				v2685, n144 = proto.readBuffer(p216, n144)
				v2676.title = buffer.tostring(v2685)
			elseif v2678 == 6 then
				local v2686

				v2686, n144 = proto.readBuffer(p216, n144)
				v2676.applied_filters = buffer.tostring(v2686)
			else
				local v2687, v2688 = proto.readVarInt(p216, n144)

				n144 = v2688 + v2687
			end
		elseif v2679 == proto.wireTypes.i32 then
			local v2689

			v2689, n144 = proto.readFixed32(p216, n144)
		elseif v2679 == proto.wireTypes.i64 then
			local v2690

			v2690, n144 = proto.readFixed64(p216, n144)
		else
			error("Unsupported wire type: " .. v2679)
		end
	end

	return v2676
end
function t346.jsonEncode(p217) -- line: 16229
	local t348 = {}

	if p217.filter_groups ~= nil and #p217.filter_groups > 0 then
		local t349 = {}

		for _, v2695 in p217.filter_groups do
			table.insert(t349, v2695:jsonEncode())
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
function t346.jsonDecode(t350: {[any]: any}) -- line: 16263
	-- upvalues: t346 (copy), t1 (copy)
	local v2697 = t346.new()

	if t350.filter_groups ~= nil then
		local t351 = {}

		for _, v2700 in t350.filter_groups do
			table.insert(t351, t1.FilterPillsInputData_FilterGroup.jsonDecode(v2700))
		end

		v2697.filter_groups = t351
	end

	if t350.filterGroups ~= nil then
		local t352 = {}

		for _, v2703 in t350.filterGroups do
			table.insert(t352, t1.FilterPillsInputData_FilterGroup.jsonDecode(v2703))
		end

		v2697.filter_groups = t352
	end

	if t350.sort_id ~= nil then
		v2697.sort_id = t350.sort_id
	end

	if t350.sortId ~= nil then
		v2697.sort_id = t350.sortId
	end

	if t350.secondary_sort_id ~= nil then
		v2697.secondary_sort_id = t350.secondary_sort_id
	end

	if t350.secondarySortId ~= nil then
		v2697.secondary_sort_id = t350.secondarySortId
	end

	if t350.title ~= nil then
		v2697.title = t350.title
	end

	if t350.primary_sort_id ~= nil then
		v2697.primary_sort_id = t350.primary_sort_id
	end

	if t350.primarySortId ~= nil then
		v2697.primary_sort_id = t350.primarySortId
	end

	if t350.applied_filters ~= nil then
		v2697.applied_filters = t350.applied_filters
	end

	if t350.appliedFilters ~= nil then
		v2697.applied_filters = t350.appliedFilters
	end

	return v2697
end

t346.descriptor = {
	name = "FilterPillsInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.FilterPillsInputData"
}
t1.FilterPillsInputData = t346
typeRegistry.default:register(t1.FilterPillsInputData)

local t353 = {}

t353.__index = t353

function t353.new(t354: {[any]: any}?) -- line: 16337
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
function t353.encode(p218) -- line: 16354
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n145 = 0

	if p218.filter_id ~= nil and p218.filter_id ~= "" then
		local v2708, v2709 = proto.writeTag(buf, n145, 1, proto.wireTypes.lengthDelimited)

		buf, n145 = proto.writeString(v2708, v2709, p218.filter_id)
	end

	if p218.display_name ~= nil and p218.display_name ~= "" then
		local v2710, v2711 = proto.writeTag(buf, n145, 2, proto.wireTypes.lengthDelimited)

		buf, n145 = proto.writeString(v2710, v2711, p218.display_name)
	end

	if p218.options ~= nil and #p218.options > 0 then
		for _, v2713 in p218.options do
			local v2714 = v2713:encode()
			local v2715, v2716 = proto.writeTag(buf, n145, 3, proto.wireTypes.lengthDelimited)

			buf, n145 = proto.writeBuffer(v2715, v2716, v2714, buffer.len(v2714))
		end
	end

	if p218.default_option_id ~= nil and p218.default_option_id ~= "" then
		local v2717, v2718 = proto.writeTag(buf, n145, 4, proto.wireTypes.lengthDelimited)

		buf, n145 = proto.writeString(v2717, v2718, p218.default_option_id)
	end

	if p218.selected_option_id ~= nil and p218.selected_option_id ~= "" then
		local v2719, v2720 = proto.writeTag(buf, n145, 5, proto.wireTypes.lengthDelimited)

		buf, n145 = proto.writeString(v2719, v2720, p218.selected_option_id)
	end

	if p218.filter_type ~= nil and p218.filter_type ~= "" then
		local v2721, v2722 = proto.writeTag(buf, n145, 6, proto.wireTypes.lengthDelimited)

		buf, n145 = proto.writeString(v2721, v2722, p218.filter_type)
	end

	if p218.inactive_option_ids ~= nil and #p218.inactive_option_ids > 0 then
		for _, v2724 in p218.inactive_option_ids do
			local v2725, v2726 = proto.writeTag(buf, n145, 7, proto.wireTypes.lengthDelimited)

			buf, n145 = proto.writeString(v2725, v2726, v2724)
		end
	end

	if p218.info_text ~= nil and p218.info_text ~= "" then
		local v2727, v2728 = proto.writeTag(buf, n145, 8, proto.wireTypes.lengthDelimited)

		buf, n145 = proto.writeString(v2727, v2728, p218.info_text)
	end

	local buf79 = buffer.create(n145)

	buffer.copy(buf79, 0, buf, 0, n145)

	return buf79
end
function t353.decode(p219: buffer) -- line: 16408
	-- upvalues: t353 (copy), proto (copy), t1 (copy)
	local v2731 = t353.new()
	local n146 = 0

	while n146 < buffer.len(p219) do
		local v2733, v2734

		v2733, v2734, n146 = proto.readTag(p219, n146)

		if v2734 == proto.wireTypes.varint then
			local v2735

			v2735, n146 = proto.readVarInt(p219, n146)
		elseif v2734 == proto.wireTypes.lengthDelimited then
			if v2733 == 1 then
				local v2736

				v2736, n146 = proto.readBuffer(p219, n146)
				v2731.filter_id = buffer.tostring(v2736)
			elseif v2733 == 2 then
				local v2737

				v2737, n146 = proto.readBuffer(p219, n146)
				v2731.display_name = buffer.tostring(v2737)
			elseif v2733 == 3 then
				local v2738

				v2738, n146 = proto.readBuffer(p219, n146)
				table.insert(v2731.options, t1.FilterPillsInputData_FilterOption.decode(v2738))
			elseif v2733 == 4 then
				local v2739

				v2739, n146 = proto.readBuffer(p219, n146)
				v2731.default_option_id = buffer.tostring(v2739)
			elseif v2733 == 5 then
				local v2740

				v2740, n146 = proto.readBuffer(p219, n146)
				v2731.selected_option_id = buffer.tostring(v2740)
			elseif v2733 == 6 then
				local v2741

				v2741, n146 = proto.readBuffer(p219, n146)
				v2731.filter_type = buffer.tostring(v2741)
			elseif v2733 == 7 then
				local v2742

				v2742, n146 = proto.readBuffer(p219, n146)
				table.insert(v2731.inactive_option_ids, buffer.tostring(v2742))
			elseif v2733 == 8 then
				local v2743

				v2743, n146 = proto.readBuffer(p219, n146)
				v2731.info_text = buffer.tostring(v2743)
			else
				local v2744, v2745 = proto.readVarInt(p219, n146)

				n146 = v2745 + v2744
			end
		elseif v2734 == proto.wireTypes.i32 then
			local v2746

			v2746, n146 = proto.readFixed32(p219, n146)
		elseif v2734 == proto.wireTypes.i64 then
			local v2747

			v2747, n146 = proto.readFixed64(p219, n146)
		else
			error("Unsupported wire type: " .. v2734)
		end
	end

	return v2731
end
function t353.jsonEncode(p220) -- line: 16486
	local t355 = {}

	if p220.filter_id ~= nil and p220.filter_id ~= "" then
		t355.filterId = p220.filter_id
	end

	if p220.display_name ~= nil and p220.display_name ~= "" then
		t355.displayName = p220.display_name
	end

	if p220.options ~= nil and #p220.options > 0 then
		local t356 = {}

		for _, v2752 in p220.options do
			table.insert(t356, v2752:jsonEncode())
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

		for _, v2755 in p220.inactive_option_ids do
			table.insert(t357, v2755)
		end

		t355.inactiveOptionIds = t357
	end

	if p220.info_text ~= nil and p220.info_text ~= "" then
		t355.infoText = p220.info_text
	end

	return t355
end
function t353.jsonDecode(t358: {[any]: any}) -- line: 16532
	-- upvalues: t353 (copy), t1 (copy)
	local v2757 = t353.new()

	if t358.filter_id ~= nil then
		v2757.filter_id = t358.filter_id
	end

	if t358.filterId ~= nil then
		v2757.filter_id = t358.filterId
	end

	if t358.display_name ~= nil then
		v2757.display_name = t358.display_name
	end

	if t358.displayName ~= nil then
		v2757.display_name = t358.displayName
	end

	if t358.options ~= nil then
		local t359 = {}

		for _, v2760 in t358.options do
			table.insert(t359, t1.FilterPillsInputData_FilterOption.jsonDecode(v2760))
		end

		v2757.options = t359
	end

	if t358.default_option_id ~= nil then
		v2757.default_option_id = t358.default_option_id
	end

	if t358.defaultOptionId ~= nil then
		v2757.default_option_id = t358.defaultOptionId
	end

	if t358.selected_option_id ~= nil then
		v2757.selected_option_id = t358.selected_option_id
	end

	if t358.selectedOptionId ~= nil then
		v2757.selected_option_id = t358.selectedOptionId
	end

	if t358.filter_type ~= nil then
		v2757.filter_type = t358.filter_type
	end

	if t358.filterType ~= nil then
		v2757.filter_type = t358.filterType
	end

	if t358.inactive_option_ids ~= nil then
		local t360 = {}

		for _, v2763 in t358.inactive_option_ids do
			table.insert(t360, v2763)
		end

		v2757.inactive_option_ids = t360
	end

	if t358.inactiveOptionIds ~= nil then
		local t361 = {}

		for _, v2766 in t358.inactiveOptionIds do
			table.insert(t361, v2766)
		end

		v2757.inactive_option_ids = t361
	end

	if t358.info_text ~= nil then
		v2757.info_text = t358.info_text
	end

	if t358.infoText ~= nil then
		v2757.info_text = t358.infoText
	end

	return v2757
end

t353.descriptor = {
	name = "FilterPillsInputData_FilterGroup",
	fullName = "roblox.apppageplatform.shared.v1beta1.FilterGroup"
}
t1.FilterPillsInputData_FilterGroup = t353
typeRegistry.default:register(t1.FilterPillsInputData_FilterGroup)

local t362 = {}

t362.__index = t362

function t362.new(t363: {[any]: any}?) -- line: 16629
	-- upvalues: t362 (copy)
	return (setmetatable({
		option_id = if t363 ~= nil and t363.option_id ~= nil then t363.option_id else "",
		display_name = if t363 ~= nil and t363.display_name ~= nil then t363.display_name else "",
		option_context_tag = if t363 ~= nil and t363.option_context_tag ~= nil then t363.option_context_tag else ""
	}, t362))
end
function t362.encode(p221) -- line: 16639
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n147 = 0

	if p221.option_id ~= nil and p221.option_id ~= "" then
		local v2771, v2772 = proto.writeTag(buf, n147, 1, proto.wireTypes.lengthDelimited)

		buf, n147 = proto.writeString(v2771, v2772, p221.option_id)
	end

	if p221.display_name ~= nil and p221.display_name ~= "" then
		local v2773, v2774 = proto.writeTag(buf, n147, 2, proto.wireTypes.lengthDelimited)

		buf, n147 = proto.writeString(v2773, v2774, p221.display_name)
	end

	if p221.option_context_tag ~= nil and p221.option_context_tag ~= "" then
		local v2775, v2776 = proto.writeTag(buf, n147, 3, proto.wireTypes.lengthDelimited)

		buf, n147 = proto.writeString(v2775, v2776, p221.option_context_tag)
	end

	local buf80 = buffer.create(n147)

	buffer.copy(buf80, 0, buf, 0, n147)

	return buf80
end
function t362.decode(p222: buffer) -- line: 16663
	-- upvalues: t362 (copy), proto (copy)
	local v2779 = t362.new()
	local n148 = 0

	while n148 < buffer.len(p222) do
		local v2781, v2782

		v2781, v2782, n148 = proto.readTag(p222, n148)

		if v2782 == proto.wireTypes.varint then
			local v2783

			v2783, n148 = proto.readVarInt(p222, n148)
		elseif v2782 == proto.wireTypes.lengthDelimited then
			if v2781 == 1 then
				local v2784

				v2784, n148 = proto.readBuffer(p222, n148)
				v2779.option_id = buffer.tostring(v2784)
			elseif v2781 == 2 then
				local v2785

				v2785, n148 = proto.readBuffer(p222, n148)
				v2779.display_name = buffer.tostring(v2785)
			elseif v2781 == 3 then
				local v2786

				v2786, n148 = proto.readBuffer(p222, n148)
				v2779.option_context_tag = buffer.tostring(v2786)
			else
				local v2787, v2788 = proto.readVarInt(p222, n148)

				n148 = v2788 + v2787
			end
		elseif v2782 == proto.wireTypes.i32 then
			local v2789

			v2789, n148 = proto.readFixed32(p222, n148)
		elseif v2782 == proto.wireTypes.i64 then
			local v2790

			v2790, n148 = proto.readFixed64(p222, n148)
		else
			error("Unsupported wire type: " .. v2782)
		end
	end

	return v2779
end
function t362.jsonEncode(p223) -- line: 16716
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
function t362.jsonDecode(t365: {[any]: any}) -- line: 16734
	-- upvalues: t362 (copy)
	local v2794 = t362.new()

	if t365.option_id ~= nil then
		v2794.option_id = t365.option_id
	end

	if t365.optionId ~= nil then
		v2794.option_id = t365.optionId
	end

	if t365.display_name ~= nil then
		v2794.display_name = t365.display_name
	end

	if t365.displayName ~= nil then
		v2794.display_name = t365.displayName
	end

	if t365.option_context_tag ~= nil then
		v2794.option_context_tag = t365.option_context_tag
	end

	if t365.optionContextTag ~= nil then
		v2794.option_context_tag = t365.optionContextTag
	end

	return v2794
end

t362.descriptor = {
	name = "FilterPillsInputData_FilterOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.FilterOption"
}
t1.FilterPillsInputData_FilterOption = t362
typeRegistry.default:register(t1.FilterPillsInputData_FilterOption)

local t366 = {}

t366.__index = t366

function t366.new(t367: {[any]: any}?) -- line: 16780
	-- upvalues: t366 (copy)
	return (setmetatable({
		sort_options = if t367 ~= nil and t367.sort_options ~= nil then t367.sort_options else {},
		selected_sort_id = if t367 ~= nil and t367.selected_sort_id ~= nil then t367.selected_sort_id else ""
	}, t366))
end
function t366.encode(p224) -- line: 16787
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n149 = 0

	if p224.sort_options ~= nil and #p224.sort_options > 0 then
		for _, v2800 in p224.sort_options do
			local v2801 = v2800:encode()
			local v2802, v2803 = proto.writeTag(buf, n149, 1, proto.wireTypes.lengthDelimited)

			buf, n149 = proto.writeBuffer(v2802, v2803, v2801, buffer.len(v2801))
		end
	end

	if p224.selected_sort_id ~= nil and p224.selected_sort_id ~= "" then
		local v2804, v2805 = proto.writeTag(buf, n149, 2, proto.wireTypes.lengthDelimited)

		buf, n149 = proto.writeString(v2804, v2805, p224.selected_sort_id)
	end

	local buf81 = buffer.create(n149)

	buffer.copy(buf81, 0, buf, 0, n149)

	return buf81
end
function t366.decode(p225: buffer) -- line: 16809
	-- upvalues: t366 (copy), proto (copy), t1 (copy)
	local v2808 = t366.new()
	local n150 = 0

	while n150 < buffer.len(p225) do
		local v2810, v2811

		v2810, v2811, n150 = proto.readTag(p225, n150)

		if v2811 == proto.wireTypes.varint then
			local v2812

			v2812, n150 = proto.readVarInt(p225, n150)
		elseif v2811 == proto.wireTypes.lengthDelimited then
			if v2810 == 1 then
				local v2813

				v2813, n150 = proto.readBuffer(p225, n150)
				table.insert(v2808.sort_options, t1.SortSelectorInputData_SortOption.decode(v2813))
			elseif v2810 == 2 then
				local v2814

				v2814, n150 = proto.readBuffer(p225, n150)
				v2808.selected_sort_id = buffer.tostring(v2814)
			else
				local v2815, v2816 = proto.readVarInt(p225, n150)

				n150 = v2816 + v2815
			end
		elseif v2811 == proto.wireTypes.i32 then
			local v2817

			v2817, n150 = proto.readFixed32(p225, n150)
		elseif v2811 == proto.wireTypes.i64 then
			local v2818

			v2818, n150 = proto.readFixed64(p225, n150)
		else
			error("Unsupported wire type: " .. v2811)
		end
	end

	return v2808
end
function t366.jsonEncode(p226) -- line: 16857
	local t368 = {}

	if p226.sort_options ~= nil and #p226.sort_options > 0 then
		local t369 = {}

		for _, v2823 in p226.sort_options do
			table.insert(t369, v2823:jsonEncode())
		end

		t368.sortOptions = t369
	end

	if p226.selected_sort_id ~= nil and p226.selected_sort_id ~= "" then
		t368.selectedSortId = p226.selected_sort_id
	end

	return t368
end
function t366.jsonDecode(t370: {[any]: any}) -- line: 16875
	-- upvalues: t366 (copy), t1 (copy)
	local v2825 = t366.new()

	if t370.sort_options ~= nil then
		local t371 = {}

		for _, v2828 in t370.sort_options do
			table.insert(t371, t1.SortSelectorInputData_SortOption.jsonDecode(v2828))
		end

		v2825.sort_options = t371
	end

	if t370.sortOptions ~= nil then
		local t372 = {}

		for _, v2831 in t370.sortOptions do
			table.insert(t372, t1.SortSelectorInputData_SortOption.jsonDecode(v2831))
		end

		v2825.sort_options = t372
	end

	if t370.selected_sort_id ~= nil then
		v2825.selected_sort_id = t370.selected_sort_id
	end

	if t370.selectedSortId ~= nil then
		v2825.selected_sort_id = t370.selectedSortId
	end

	return v2825
end

t366.descriptor = {
	name = "SortSelectorInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.SortSelectorInputData"
}
t1.SortSelectorInputData = t366
typeRegistry.default:register(t1.SortSelectorInputData)

local t373 = {}

t373.__index = t373

function t373.new(t374: {[any]: any}?) -- line: 16921
	-- upvalues: t373 (copy)
	return (setmetatable({
		sort_id = if t374 ~= nil and t374.sort_id ~= nil then t374.sort_id else "",
		display_name = if t374 ~= nil and t374.display_name ~= nil then t374.display_name else "",
		content_type = if t374 ~= nil and t374.content_type ~= nil then t374.content_type else ""
	}, t373))
end
function t373.encode(p227) -- line: 16931
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n151 = 0

	if p227.sort_id ~= nil and p227.sort_id ~= "" then
		local v2836, v2837 = proto.writeTag(buf, n151, 1, proto.wireTypes.lengthDelimited)

		buf, n151 = proto.writeString(v2836, v2837, p227.sort_id)
	end

	if p227.display_name ~= nil and p227.display_name ~= "" then
		local v2838, v2839 = proto.writeTag(buf, n151, 2, proto.wireTypes.lengthDelimited)

		buf, n151 = proto.writeString(v2838, v2839, p227.display_name)
	end

	if p227.content_type ~= nil and p227.content_type ~= "" then
		local v2840, v2841 = proto.writeTag(buf, n151, 3, proto.wireTypes.lengthDelimited)

		buf, n151 = proto.writeString(v2840, v2841, p227.content_type)
	end

	local buf82 = buffer.create(n151)

	buffer.copy(buf82, 0, buf, 0, n151)

	return buf82
end
function t373.decode(p228: buffer) -- line: 16955
	-- upvalues: t373 (copy), proto (copy)
	local v2844 = t373.new()
	local n152 = 0

	while n152 < buffer.len(p228) do
		local v2846, v2847

		v2846, v2847, n152 = proto.readTag(p228, n152)

		if v2847 == proto.wireTypes.varint then
			local v2848

			v2848, n152 = proto.readVarInt(p228, n152)
		elseif v2847 == proto.wireTypes.lengthDelimited then
			if v2846 == 1 then
				local v2849

				v2849, n152 = proto.readBuffer(p228, n152)
				v2844.sort_id = buffer.tostring(v2849)
			elseif v2846 == 2 then
				local v2850

				v2850, n152 = proto.readBuffer(p228, n152)
				v2844.display_name = buffer.tostring(v2850)
			elseif v2846 == 3 then
				local v2851

				v2851, n152 = proto.readBuffer(p228, n152)
				v2844.content_type = buffer.tostring(v2851)
			else
				local v2852, v2853 = proto.readVarInt(p228, n152)

				n152 = v2853 + v2852
			end
		elseif v2847 == proto.wireTypes.i32 then
			local v2854

			v2854, n152 = proto.readFixed32(p228, n152)
		elseif v2847 == proto.wireTypes.i64 then
			local v2855

			v2855, n152 = proto.readFixed64(p228, n152)
		else
			error("Unsupported wire type: " .. v2847)
		end
	end

	return v2844
end
function t373.jsonEncode(p229) -- line: 17008
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
function t373.jsonDecode(t376: {[any]: any}) -- line: 17026
	-- upvalues: t373 (copy)
	local v2859 = t373.new()

	if t376.sort_id ~= nil then
		v2859.sort_id = t376.sort_id
	end

	if t376.sortId ~= nil then
		v2859.sort_id = t376.sortId
	end

	if t376.display_name ~= nil then
		v2859.display_name = t376.display_name
	end

	if t376.displayName ~= nil then
		v2859.display_name = t376.displayName
	end

	if t376.content_type ~= nil then
		v2859.content_type = t376.content_type
	end

	if t376.contentType ~= nil then
		v2859.content_type = t376.contentType
	end

	return v2859
end

t373.descriptor = {
	name = "SortSelectorInputData_SortOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.SortOption"
}
t1.SortSelectorInputData_SortOption = t373
typeRegistry.default:register(t1.SortSelectorInputData_SortOption)

local t377 = {}

t377.__index = t377

function t377.new(t378: {[any]: any}?) -- line: 17072
	-- upvalues: t377 (copy)
	return (setmetatable({
		selected_option = if t378 ~= nil and t378.selected_option ~= nil then t378.selected_option else "",
		options = if t378 ~= nil and t378.options ~= nil then t378.options else {},
		experience_carousel = if t378 ~= nil and t378.experience_carousel ~= nil then t378.experience_carousel else nil
	}, t377))
end
function t377.encode(p230) -- line: 17084
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n153 = 0

	if p230.selected_option ~= nil and p230.selected_option ~= "" then
		local v2864, v2865 = proto.writeTag(buf, n153, 1, proto.wireTypes.lengthDelimited)

		buf, n153 = proto.writeString(v2864, v2865, p230.selected_option)
	end

	if p230.options ~= nil and #p230.options > 0 then
		for _, v2867 in p230.options do
			local v2868 = v2867:encode()
			local v2869, v2870 = proto.writeTag(buf, n153, 2, proto.wireTypes.lengthDelimited)

			buf, n153 = proto.writeBuffer(v2869, v2870, v2868, buffer.len(v2868))
		end
	end

	if p230.experience_carousel ~= nil then
		local v2871 = p230.experience_carousel:encode()
		local v2872, v2873 = proto.writeTag(buf, n153, 3, proto.wireTypes.lengthDelimited)

		buf, n153 = proto.writeBuffer(v2872, v2873, v2871, buffer.len(v2871))
	end

	local buf83 = buffer.create(n153)

	buffer.copy(buf83, 0, buf, 0, n153)

	return buf83
end
function t377.decode(p231: buffer) -- line: 17112
	-- upvalues: t377 (copy), proto (copy), t1 (copy)
	local v2876 = t377.new()
	local n154 = 0

	while n154 < buffer.len(p231) do
		local v2878, v2879

		v2878, v2879, n154 = proto.readTag(p231, n154)

		if v2879 == proto.wireTypes.varint then
			local v2880

			v2880, n154 = proto.readVarInt(p231, n154)
		elseif v2879 == proto.wireTypes.lengthDelimited then
			if v2878 == 1 then
				local v2881

				v2881, n154 = proto.readBuffer(p231, n154)
				v2876.selected_option = buffer.tostring(v2881)
			elseif v2878 == 2 then
				local v2882

				v2882, n154 = proto.readBuffer(p231, n154)
				table.insert(v2876.options, t1.SelectorOption.decode(v2882))
			elseif v2878 == 3 then
				local v2883

				v2883, n154 = proto.readBuffer(p231, n154)
				v2876.experience_carousel = t1.ExperienceCarouselInputData.decode(v2883)
			else
				local v2884, v2885 = proto.readVarInt(p231, n154)

				n154 = v2885 + v2884
			end
		elseif v2879 == proto.wireTypes.i32 then
			local v2886

			v2886, n154 = proto.readFixed32(p231, n154)
		elseif v2879 == proto.wireTypes.i64 then
			local v2887

			v2887, n154 = proto.readFixed64(p231, n154)
		else
			error("Unsupported wire type: " .. v2879)
		end
	end

	return v2876
end
function t377.jsonEncode(p232) -- line: 17165
	local t379 = {}

	if p232.selected_option ~= nil and p232.selected_option ~= "" then
		t379.selectedOption = p232.selected_option
	end

	if p232.options ~= nil and #p232.options > 0 then
		local t380 = {}

		for _, v2892 in p232.options do
			table.insert(t380, v2892:jsonEncode())
		end

		t379.options = t380
	end

	if p232.experience_carousel ~= nil then
		t379.experienceCarousel = p232.experience_carousel:jsonEncode()
	end

	return t379
end
function t377.jsonDecode(t381: {[any]: any}) -- line: 17187
	-- upvalues: t377 (copy), t1 (copy)
	local v2894 = t377.new()

	if t381.selected_option ~= nil then
		v2894.selected_option = t381.selected_option
	end

	if t381.selectedOption ~= nil then
		v2894.selected_option = t381.selectedOption
	end

	if t381.options ~= nil then
		local t382 = {}

		for _, v2897 in t381.options do
			table.insert(t382, t1.SelectorOption.jsonDecode(v2897))
		end

		v2894.options = t382
	end

	if t381.experience_carousel ~= nil then
		v2894.experience_carousel = t1.ExperienceCarouselInputData.jsonDecode(t381.experience_carousel)
	end

	if t381.experienceCarousel ~= nil then
		v2894.experience_carousel = t1.ExperienceCarouselInputData.jsonDecode(t381.experienceCarousel)
	end

	return v2894
end

t377.descriptor = {
	name = "ChartsGenreSelectorInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ChartsGenreSelectorInputData"
}
t1.ChartsGenreSelectorInputData = t377
typeRegistry.default:register(t1.ChartsGenreSelectorInputData)

local t383 = {}

t383.__index = t383

function t383.new(t384: {[any]: any}?) -- line: 17232
	-- upvalues: t383 (copy)
	return (setmetatable({
		id = if t384 ~= nil and t384.id ~= nil then t384.id else "",
		preview_rows = if t384 ~= nil and t384.preview_rows ~= nil then t384.preview_rows else 0,
		widget_style = if t384 ~= nil and t384.widget_style ~= nil then t384.widget_style else nil,
		see_all_button = t384 ~= nil and (t384.see_all_button ~= nil and t384.see_all_button),
		information_popover_text = if t384 ~= nil and t384.information_popover_text ~= nil then t384.information_popover_text else ""
	}, t383))
end
function t383.encode(p233) -- line: 17246
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n155 = 0

	if p233.id ~= nil and p233.id ~= "" then
		local v2902, v2903 = proto.writeTag(buf, n155, 1, proto.wireTypes.lengthDelimited)

		buf, n155 = proto.writeString(v2902, v2903, p233.id)
	end

	if p233.preview_rows ~= nil and p233.preview_rows ~= 0 then
		local v2904, v2905 = proto.writeTag(buf, n155, 4, proto.wireTypes.varint)

		buf, n155 = proto.writeVarInt(v2904, v2905, p233.preview_rows)
	end

	if p233.widget_style ~= nil then
		local v2906 = p233.widget_style:encode()
		local v2907, v2908 = proto.writeTag(buf, n155, 3, proto.wireTypes.lengthDelimited)

		buf, n155 = proto.writeBuffer(v2907, v2908, v2906, buffer.len(v2906))
	end

	if p233.see_all_button then
		local v2909, v2910 = proto.writeTag(buf, n155, 5, proto.wireTypes.varint)

		buf, n155 = proto.writeVarInt(v2909, v2910, not p233.see_all_button and 0 or 1)
	end

	if p233.information_popover_text ~= nil and p233.information_popover_text ~= "" then
		local v2911, v2912 = proto.writeTag(buf, n155, 6, proto.wireTypes.lengthDelimited)

		buf, n155 = proto.writeString(v2911, v2912, p233.information_popover_text)
	end

	local buf84 = buffer.create(n155)

	buffer.copy(buf84, 0, buf, 0, n155)

	return buf84
end
function t383.decode(p234: buffer) -- line: 17281
	-- upvalues: t383 (copy), proto (copy), t1 (copy)
	local v2915 = t383.new()
	local n156 = 0

	while n156 < buffer.len(p234) do
		local v2917, v2918

		v2917, v2918, n156 = proto.readTag(p234, n156)

		if v2918 == proto.wireTypes.varint then
			if v2917 == 4 then
				local v2919

				v2919, n156 = proto.readVarIntI64(p234, n156)
				v2915.preview_rows = v2919
			elseif v2917 == 5 then
				local v2920

				v2920, n156 = proto.readVarInt(p234, n156)
				v2915.see_all_button = v2920 ~= 0
			else
				local v2921

				v2921, n156 = proto.readVarInt(p234, n156)
			end
		elseif v2918 == proto.wireTypes.lengthDelimited then
			if v2917 == 1 then
				local v2922

				v2922, n156 = proto.readBuffer(p234, n156)
				v2915.id = buffer.tostring(v2922)
			elseif v2917 == 3 then
				local v2923

				v2923, n156 = proto.readBuffer(p234, n156)
				v2915.widget_style = t1.WidgetStyleData.decode(v2923)
			elseif v2917 == 6 then
				local v2924

				v2924, n156 = proto.readBuffer(p234, n156)
				v2915.information_popover_text = buffer.tostring(v2924)
			else
				local v2925, v2926 = proto.readVarInt(p234, n156)

				n156 = v2926 + v2925
			end
		elseif v2918 == proto.wireTypes.i32 then
			local v2927

			v2927, n156 = proto.readFixed32(p234, n156)
		elseif v2918 == proto.wireTypes.i64 then
			local v2928

			v2928, n156 = proto.readFixed64(p234, n156)
		else
			error("Unsupported wire type: " .. v2918)
		end
	end

	return v2915
end
function t383.jsonEncode(p235) -- line: 17344
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
function t383.jsonDecode(t386: {[any]: any}) -- line: 17370
	-- upvalues: t383 (copy), t1 (copy)
	local v2932 = t383.new()

	if t386.id ~= nil then
		v2932.id = t386.id
	end

	if t386.preview_rows ~= nil then
		v2932.preview_rows = t386.preview_rows
	end

	if t386.previewRows ~= nil then
		v2932.preview_rows = t386.previewRows
	end

	if t386.widget_style ~= nil then
		v2932.widget_style = t1.WidgetStyleData.jsonDecode(t386.widget_style)
	end

	if t386.widgetStyle ~= nil then
		v2932.widget_style = t1.WidgetStyleData.jsonDecode(t386.widgetStyle)
	end

	if t386.see_all_button ~= nil then
		v2932.see_all_button = t386.see_all_button
	end

	if t386.seeAllButton ~= nil then
		v2932.see_all_button = t386.seeAllButton
	end

	if t386.information_popover_text ~= nil then
		v2932.information_popover_text = t386.information_popover_text
	end

	if t386.informationPopoverText ~= nil then
		v2932.information_popover_text = t386.informationPopoverText
	end

	return v2932
end

t383.descriptor = {
	name = "UAMarketplaceCatalogItemGroupInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UAMarketplaceCatalogItemGroupInputData"
}
t1.UAMarketplaceCatalogItemGroupInputData = t383
typeRegistry.default:register(t1.UAMarketplaceCatalogItemGroupInputData)

local t387 = {}

t387.__index = t387

function t387.new(t388: {[any]: any}?) -- line: 17428
	-- upvalues: t387 (copy)
	return (setmetatable({
		id = if t388 ~= nil and t388.id ~= nil then t388.id else "",
		num_items_to_show = if t388 ~= nil and t388.num_items_to_show ~= nil then t388.num_items_to_show else 0,
		widget_style = if t388 ~= nil and t388.widget_style ~= nil then t388.widget_style else nil,
		see_all_button = t388 ~= nil and (t388.see_all_button ~= nil and t388.see_all_button),
		information_popover_text = if t388 ~= nil and t388.information_popover_text ~= nil then t388.information_popover_text else ""
	}, t387))
end
function t387.encode(p236) -- line: 17442
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n157 = 0

	if p236.id ~= nil and p236.id ~= "" then
		local v2937, v2938 = proto.writeTag(buf, n157, 1, proto.wireTypes.lengthDelimited)

		buf, n157 = proto.writeString(v2937, v2938, p236.id)
	end

	if p236.num_items_to_show ~= nil and p236.num_items_to_show ~= 0 then
		local v2939, v2940 = proto.writeTag(buf, n157, 5, proto.wireTypes.varint)

		buf, n157 = proto.writeVarInt(v2939, v2940, p236.num_items_to_show)
	end

	if p236.widget_style ~= nil then
		local v2941 = p236.widget_style:encode()
		local v2942, v2943 = proto.writeTag(buf, n157, 3, proto.wireTypes.lengthDelimited)

		buf, n157 = proto.writeBuffer(v2942, v2943, v2941, buffer.len(v2941))
	end

	if p236.see_all_button then
		local v2944, v2945 = proto.writeTag(buf, n157, 6, proto.wireTypes.varint)

		buf, n157 = proto.writeVarInt(v2944, v2945, not p236.see_all_button and 0 or 1)
	end

	if p236.information_popover_text ~= nil and p236.information_popover_text ~= "" then
		local v2946, v2947 = proto.writeTag(buf, n157, 7, proto.wireTypes.lengthDelimited)

		buf, n157 = proto.writeString(v2946, v2947, p236.information_popover_text)
	end

	local buf85 = buffer.create(n157)

	buffer.copy(buf85, 0, buf, 0, n157)

	return buf85
end
function t387.decode(p237: buffer) -- line: 17479
	-- upvalues: t387 (copy), proto (copy), t1 (copy)
	local v2950 = t387.new()
	local n158 = 0

	while n158 < buffer.len(p237) do
		local v2952, v2953

		v2952, v2953, n158 = proto.readTag(p237, n158)

		if v2953 == proto.wireTypes.varint then
			if v2952 == 5 then
				local v2954

				v2954, n158 = proto.readVarIntI64(p237, n158)
				v2950.num_items_to_show = v2954
			elseif v2952 == 6 then
				local v2955

				v2955, n158 = proto.readVarInt(p237, n158)
				v2950.see_all_button = v2955 ~= 0
			else
				local v2956

				v2956, n158 = proto.readVarInt(p237, n158)
			end
		elseif v2953 == proto.wireTypes.lengthDelimited then
			if v2952 == 1 then
				local v2957

				v2957, n158 = proto.readBuffer(p237, n158)
				v2950.id = buffer.tostring(v2957)
			elseif v2952 == 3 then
				local v2958

				v2958, n158 = proto.readBuffer(p237, n158)
				v2950.widget_style = t1.WidgetStyleData.decode(v2958)
			elseif v2952 == 7 then
				local v2959

				v2959, n158 = proto.readBuffer(p237, n158)
				v2950.information_popover_text = buffer.tostring(v2959)
			else
				local v2960, v2961 = proto.readVarInt(p237, n158)

				n158 = v2961 + v2960
			end
		elseif v2953 == proto.wireTypes.i32 then
			local v2962

			v2962, n158 = proto.readFixed32(p237, n158)
		elseif v2953 == proto.wireTypes.i64 then
			local v2963

			v2963, n158 = proto.readFixed64(p237, n158)
		else
			error("Unsupported wire type: " .. v2953)
		end
	end

	return v2950
end
function t387.jsonEncode(p238) -- line: 17544
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
function t387.jsonDecode(t390: {[any]: any}) -- line: 17572
	-- upvalues: t387 (copy), t1 (copy)
	local v2967 = t387.new()

	if t390.id ~= nil then
		v2967.id = t390.id
	end

	if t390.num_items_to_show ~= nil then
		v2967.num_items_to_show = t390.num_items_to_show
	end

	if t390.numItemsToShow ~= nil then
		v2967.num_items_to_show = t390.numItemsToShow
	end

	if t390.widget_style ~= nil then
		v2967.widget_style = t1.WidgetStyleData.jsonDecode(t390.widget_style)
	end

	if t390.widgetStyle ~= nil then
		v2967.widget_style = t1.WidgetStyleData.jsonDecode(t390.widgetStyle)
	end

	if t390.see_all_button ~= nil then
		v2967.see_all_button = t390.see_all_button
	end

	if t390.seeAllButton ~= nil then
		v2967.see_all_button = t390.seeAllButton
	end

	if t390.information_popover_text ~= nil then
		v2967.information_popover_text = t390.information_popover_text
	end

	if t390.informationPopoverText ~= nil then
		v2967.information_popover_text = t390.informationPopoverText
	end

	return v2967
end

t387.descriptor = {
	name = "UAMarketplaceCatalogItemCarouselInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UAMarketplaceCatalogItemCarouselInputData"
}
t1.UAMarketplaceCatalogItemCarouselInputData = t387
typeRegistry.default:register(t1.UAMarketplaceCatalogItemCarouselInputData)

local t391 = {}

t391.__index = t391

function t391.new(t392: {[any]: any}?) -- line: 17630
	-- upvalues: t391 (copy)
	return (setmetatable({
		background_layers = if t392 ~= nil and t392.background_layers ~= nil then t392.background_layers else {}
	}, t391))
end
function t391.encode(p239) -- line: 17636
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n159 = 0

	if p239.background_layers ~= nil and #p239.background_layers > 0 then
		for _, v2973 in p239.background_layers do
			local v2974 = v2973:encode()
			local v2975, v2976 = proto.writeTag(buf, n159, 1, proto.wireTypes.lengthDelimited)

			buf, n159 = proto.writeBuffer(v2975, v2976, v2974, buffer.len(v2974))
		end
	end

	local buf86 = buffer.create(n159)

	buffer.copy(buf86, 0, buf, 0, n159)

	return buf86
end
function t391.decode(p240: buffer) -- line: 17653
	-- upvalues: t391 (copy), proto (copy), background_layer (copy)
	local v2979 = t391.new()
	local n160 = 0

	while n160 < buffer.len(p240) do
		local v2981, v2982

		v2981, v2982, n160 = proto.readTag(p240, n160)

		if v2982 == proto.wireTypes.varint then
			local v2983

			v2983, n160 = proto.readVarInt(p240, n160)
		elseif v2982 == proto.wireTypes.lengthDelimited then
			if v2981 == 1 then
				local v2984

				v2984, n160 = proto.readBuffer(p240, n160)
				table.insert(v2979.background_layers, background_layer.BackgroundLayer.decode(v2984))
			else
				local v2985, v2986 = proto.readVarInt(p240, n160)

				n160 = v2986 + v2985
			end
		elseif v2982 == proto.wireTypes.i32 then
			local v2987

			v2987, n160 = proto.readFixed32(p240, n160)
		elseif v2982 == proto.wireTypes.i64 then
			local v2988

			v2988, n160 = proto.readFixed64(p240, n160)
		else
			error("Unsupported wire type: " .. v2982)
		end
	end

	return v2979
end
function t391.jsonEncode(p241) -- line: 17699
	local t393 = {}

	if p241.background_layers ~= nil and #p241.background_layers > 0 then
		local t394 = {}

		for _, v2993 in p241.background_layers do
			table.insert(t394, v2993:jsonEncode())
		end

		t393.backgroundLayers = t394
	end

	return t393
end
function t391.jsonDecode(t395: {[any]: any}) -- line: 17713
	-- upvalues: t391 (copy), background_layer (copy)
	local v2995 = t391.new()

	if t395.background_layers ~= nil then
		local t396 = {}

		for _, v2998 in t395.background_layers do
			table.insert(t396, background_layer.BackgroundLayer.jsonDecode(v2998))
		end

		v2995.background_layers = t396
	end

	if t395.backgroundLayers ~= nil then
		local t397 = {}

		for _, v3001 in t395.backgroundLayers do
			table.insert(t397, background_layer.BackgroundLayer.jsonDecode(v3001))
		end

		v2995.background_layers = t397
	end

	return v2995
end

t391.descriptor = {
	name = "WidgetStyleData",
	fullName = "roblox.apppageplatform.shared.v1beta1.WidgetStyleData"
}
t1.WidgetStyleData = t391
typeRegistry.default:register(t1.WidgetStyleData)

local t398 = {}

t398.__index = t398

function t398.new(t399: {[any]: any}?) -- line: 17757
	-- upvalues: t398 (copy)
	return (setmetatable({
		id = if t399 ~= nil and t399.id ~= nil then t399.id else "",
		available_until = if t399 ~= nil and t399.available_until ~= nil then t399.available_until else "",
		widget_style = if t399 ~= nil and t399.widget_style ~= nil then t399.widget_style else nil
	}, t398))
end
function t398.encode(p242) -- line: 17767
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n161 = 0

	if p242.id ~= nil and p242.id ~= "" then
		local v3006, v3007 = proto.writeTag(buf, n161, 1, proto.wireTypes.lengthDelimited)

		buf, n161 = proto.writeString(v3006, v3007, p242.id)
	end

	if p242.available_until ~= nil and p242.available_until ~= "" then
		local v3008, v3009 = proto.writeTag(buf, n161, 2, proto.wireTypes.lengthDelimited)

		buf, n161 = proto.writeString(v3008, v3009, p242.available_until)
	end

	if p242.widget_style ~= nil then
		local v3010 = p242.widget_style:encode()
		local v3011, v3012 = proto.writeTag(buf, n161, 3, proto.wireTypes.lengthDelimited)

		buf, n161 = proto.writeBuffer(v3011, v3012, v3010, buffer.len(v3010))
	end

	local buf87 = buffer.create(n161)

	buffer.copy(buf87, 0, buf, 0, n161)

	return buf87
end
function t398.decode(p243: buffer) -- line: 17792
	-- upvalues: t398 (copy), proto (copy), t1 (copy)
	local v3015 = t398.new()
	local n162 = 0

	while n162 < buffer.len(p243) do
		local v3017, v3018

		v3017, v3018, n162 = proto.readTag(p243, n162)

		if v3018 == proto.wireTypes.varint then
			local v3019

			v3019, n162 = proto.readVarInt(p243, n162)
		elseif v3018 == proto.wireTypes.lengthDelimited then
			if v3017 == 1 then
				local v3020

				v3020, n162 = proto.readBuffer(p243, n162)
				v3015.id = buffer.tostring(v3020)
			elseif v3017 == 2 then
				local v3021

				v3021, n162 = proto.readBuffer(p243, n162)
				v3015.available_until = buffer.tostring(v3021)
			elseif v3017 == 3 then
				local v3022

				v3022, n162 = proto.readBuffer(p243, n162)
				v3015.widget_style = t1.WidgetStyleData.decode(v3022)
			else
				local v3023, v3024 = proto.readVarInt(p243, n162)

				n162 = v3024 + v3023
			end
		elseif v3018 == proto.wireTypes.i32 then
			local v3025

			v3025, n162 = proto.readFixed32(p243, n162)
		elseif v3018 == proto.wireTypes.i64 then
			local v3026

			v3026, n162 = proto.readFixed64(p243, n162)
		else
			error("Unsupported wire type: " .. v3018)
		end
	end

	return v3015
end
function t398.jsonEncode(p244) -- line: 17845
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
function t398.jsonDecode(t401: {[any]: any}) -- line: 17863
	-- upvalues: t398 (copy), t1 (copy)
	local v3030 = t398.new()

	if t401.id ~= nil then
		v3030.id = t401.id
	end

	if t401.available_until ~= nil then
		v3030.available_until = t401.available_until
	end

	if t401.availableUntil ~= nil then
		v3030.available_until = t401.availableUntil
	end

	if t401.widget_style ~= nil then
		v3030.widget_style = t1.WidgetStyleData.jsonDecode(t401.widget_style)
	end

	if t401.widgetStyle ~= nil then
		v3030.widget_style = t1.WidgetStyleData.jsonDecode(t401.widgetStyle)
	end

	return v3030
end

t398.descriptor = {
	name = "UAMarketplaceCatalogHeroUnitInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UAMarketplaceCatalogHeroUnitInputData"
}
t1.UAMarketplaceCatalogHeroUnitInputData = t398
typeRegistry.default:register(t1.UAMarketplaceCatalogHeroUnitInputData)

local t402 = {}

t402.__index = t402

function t402.new(t403: {[any]: any}?) -- line: 17905
	-- upvalues: t402 (copy)
	return (setmetatable({
		entry_map = if t403 ~= nil and t403.entry_map ~= nil then t403.entry_map else {},
		entry_order = if t403 ~= nil and t403.entry_order ~= nil then t403.entry_order else {}
	}, t402))
end
function t402.encode(p245) -- line: 17914
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n163 = 0

	if p245.entry_map ~= nil and next(p245.entry_map) ~= nil then
		for v3035, v3036 in p245.entry_map do
			local buf88 = buffer.create(0)
			local v3038, v3039 = proto.writeTag(buf88, 0, 1, proto.wireTypes.lengthDelimited)
			local v3040, v3041 = proto.writeString(v3038, v3039, v3035)
			local v3042 = v3036:encode()
			local v3043, v3044 = proto.writeTag(v3040, v3041, 2, proto.wireTypes.lengthDelimited)
			local v3045, v3046 = proto.writeBuffer(v3043, v3044, v3042, buffer.len(v3042))
			local v3047, v3048 = proto.writeTag(buf, n163, 1, proto.wireTypes.lengthDelimited)

			buf, n163 = proto.writeBuffer(v3047, v3048, v3045, v3046)
		end
	end

	if p245.entry_order ~= nil and #p245.entry_order > 0 then
		for _, v3050 in p245.entry_order do
			local v3051, v3052 = proto.writeTag(buf, n163, 2, proto.wireTypes.lengthDelimited)

			buf, n163 = proto.writeString(v3051, v3052, v3050)
		end
	end

	local buf89 = buffer.create(n163)

	buffer.copy(buf89, 0, buf, 0, n163)

	return buf89
end
function t402.decode(p246: buffer) -- line: 17944
	-- upvalues: t402 (copy), proto (copy), t1 (copy)
	local v3055 = t402.new()
	local n164 = 0

	while n164 < buffer.len(p246) do
		local v3057, v3058

		v3057, v3058, n164 = proto.readTag(p246, n164)

		if v3058 == proto.wireTypes.varint then
			local v3059

			v3059, n164 = proto.readVarInt(p246, n164)
		elseif v3058 == proto.wireTypes.lengthDelimited then
			if v3057 == 1 then
				local v3060

				v3060, n164 = proto.readBuffer(p246, n164)

				local v3061 = t1.UAMarketplaceCatalogFeedInputData_EntryMapEntry.decode(v3060)
				local v3062 = t1.FeedEntry.new()

				v3055.entry_map[v3061.key or ""] = v3061.value or v3062
			elseif v3057 == 2 then
				local v3063

				v3063, n164 = proto.readBuffer(p246, n164)
				table.insert(v3055.entry_order, buffer.tostring(v3063))
			else
				local v3064, v3065 = proto.readVarInt(p246, n164)

				n164 = v3065 + v3064
			end
		elseif v3058 == proto.wireTypes.i32 then
			local v3066

			v3066, n164 = proto.readFixed32(p246, n164)
		elseif v3058 == proto.wireTypes.i64 then
			local v3067

			v3067, n164 = proto.readFixed64(p246, n164)
		else
			error("Unsupported wire type: " .. v3058)
		end
	end

	return v3055
end
function t402.jsonEncode(p247) -- line: 17999
	local t404 = {}

	if p247.entry_map ~= nil and next(p247.entry_map) ~= nil then
		local t405 = {}

		for v3071, v3072 in p247.entry_map do
			t405[v3071] = v3072:jsonEncode()
		end

		t404.entryMap = t405
	end

	if p247.entry_order ~= nil and #p247.entry_order > 0 then
		local t406 = {}

		for _, v3075 in p247.entry_order do
			table.insert(t406, v3075)
		end

		t404.entryOrder = t406
	end

	return t404
end
function t402.jsonDecode(t407: {[any]: any}) -- line: 18021
	-- upvalues: t402 (copy), t1 (copy)
	local v3077 = t402.new()

	if t407.entry_map ~= nil then
		local t408 = {}

		for v3079, v3080 in t407.entry_map do
			t408[v3079] = t1.FeedEntry.jsonDecode(v3080)
		end

		v3077.entry_map = t408
	end

	if t407.entryMap ~= nil then
		local t409 = {}

		for v3082, v3083 in t407.entryMap do
			t409[v3082] = t1.FeedEntry.jsonDecode(v3083)
		end

		v3077.entry_map = t409
	end

	if t407.entry_order ~= nil then
		local t410 = {}

		for _, v3086 in t407.entry_order do
			table.insert(t410, v3086)
		end

		v3077.entry_order = t410
	end

	if t407.entryOrder ~= nil then
		local t411 = {}

		for _, v3089 in t407.entryOrder do
			table.insert(t411, v3089)
		end

		v3077.entry_order = t411
	end

	return v3077
end

t402.descriptor = {
	name = "UAMarketplaceCatalogFeedInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UAMarketplaceCatalogFeedInputData"
}
t1.UAMarketplaceCatalogFeedInputData = t402
typeRegistry.default:register(t1.UAMarketplaceCatalogFeedInputData)

local t412 = {}

t412.__index = t412

function t412.new(t413: {[any]: any}?) -- line: 18079
	-- upvalues: t412 (copy)
	return (setmetatable({
		key = if t413 ~= nil and t413.key ~= nil then t413.key else "",
		value = if t413 ~= nil and t413.value ~= nil then t413.value else nil
	}, t412))
end
function t412.encode(p248) -- line: 18088
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n165 = 0

	if p248.key ~= nil and p248.key ~= "" then
		local v3094, v3095 = proto.writeTag(buf, n165, 1, proto.wireTypes.lengthDelimited)

		buf, n165 = proto.writeString(v3094, v3095, p248.key)
	end

	if p248.value ~= nil then
		local v3096 = p248.value:encode()
		local v3097, v3098 = proto.writeTag(buf, n165, 2, proto.wireTypes.lengthDelimited)

		buf, n165 = proto.writeBuffer(v3097, v3098, v3096, buffer.len(v3096))
	end

	local buf90 = buffer.create(n165)

	buffer.copy(buf90, 0, buf, 0, n165)

	return buf90
end
function t412.decode(p249: buffer) -- line: 18110
	-- upvalues: t412 (copy), proto (copy), t1 (copy)
	local v3101 = t412.new()
	local n166 = 0

	while n166 < buffer.len(p249) do
		local v3103, v3104

		v3103, v3104, n166 = proto.readTag(p249, n166)

		if v3104 == proto.wireTypes.varint then
			local v3105

			v3105, n166 = proto.readVarInt(p249, n166)
		elseif v3104 == proto.wireTypes.lengthDelimited then
			if v3103 == 1 then
				local v3106

				v3106, n166 = proto.readBuffer(p249, n166)
				v3101.key = buffer.tostring(v3106)
			elseif v3103 == 2 then
				local v3107

				v3107, n166 = proto.readBuffer(p249, n166)
				v3101.value = t1.FeedEntry.decode(v3107)
			else
				local v3108, v3109 = proto.readVarInt(p249, n166)

				n166 = v3109 + v3108
			end
		elseif v3104 == proto.wireTypes.i32 then
			local v3110

			v3110, n166 = proto.readFixed32(p249, n166)
		elseif v3104 == proto.wireTypes.i64 then
			local v3111

			v3111, n166 = proto.readFixed64(p249, n166)
		else
			error("Unsupported wire type: " .. v3104)
		end
	end

	return v3101
end
function t412.jsonEncode(p250) -- line: 18160
	local t414 = {}

	if p250.key ~= nil and p250.key ~= "" then
		t414.key = p250.key
	end

	if p250.value ~= nil then
		t414.value = p250.value:jsonEncode()
	end

	return t414
end
function t412.jsonDecode(t415: {[any]: any}) -- line: 18176
	-- upvalues: t412 (copy), t1 (copy)
	local v3115 = t412.new()

	if t415.key ~= nil then
		v3115.key = t415.key
	end

	if t415.value ~= nil then
		v3115.value = t1.FeedEntry.jsonDecode(t415.value)
	end

	return v3115
end

t412.descriptor = {
	name = "UAMarketplaceCatalogFeedInputData_EntryMapEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryMapEntry"
}
t1.UAMarketplaceCatalogFeedInputData_EntryMapEntry = t412
typeRegistry.default:register(t1.UAMarketplaceCatalogFeedInputData_EntryMapEntry)

local t416 = {}

t416.__index = t416

function t416.new(t417: {[any]: any}?) -- line: 18207
	-- upvalues: t416 (copy)
	return (setmetatable({
		marketplace_catalog_category_items = if t417 ~= nil and t417.marketplace_catalog_category_items ~= nil then t417.marketplace_catalog_category_items else {},
		active_category_id = if t417 ~= nil and t417.active_category_id ~= nil then t417.active_category_id else "",
		active_tooltip_idx = if t417 ~= nil and t417.active_tooltip_idx ~= nil then t417.active_tooltip_idx else 0
	}, t416))
end
function t416.encode(p251) -- line: 18220
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n167 = 0

	if p251.marketplace_catalog_category_items ~= nil and #p251.marketplace_catalog_category_items > 0 then
		for _, v3121 in p251.marketplace_catalog_category_items do
			local v3122 = v3121:encode()
			local v3123, v3124 = proto.writeTag(buf, n167, 1, proto.wireTypes.lengthDelimited)

			buf, n167 = proto.writeBuffer(v3123, v3124, v3122, buffer.len(v3122))
		end
	end

	if p251.active_category_id ~= nil and p251.active_category_id ~= "" then
		local v3125, v3126 = proto.writeTag(buf, n167, 2, proto.wireTypes.lengthDelimited)

		buf, n167 = proto.writeString(v3125, v3126, p251.active_category_id)
	end

	if p251.active_tooltip_idx ~= nil and p251.active_tooltip_idx ~= 0 then
		local v3127, v3128 = proto.writeTag(buf, n167, 3, proto.wireTypes.varint)

		buf, n167 = proto.writeVarInt(v3127, v3128, p251.active_tooltip_idx)
	end

	local buf91 = buffer.create(n167)

	buffer.copy(buf91, 0, buf, 0, n167)

	return buf91
end
function t416.decode(p252: buffer) -- line: 18249
	-- upvalues: t416 (copy), proto (copy), t1 (copy)
	local v3131 = t416.new()
	local n168 = 0

	while n168 < buffer.len(p252) do
		local v3133, v3134

		v3133, v3134, n168 = proto.readTag(p252, n168)

		if v3134 == proto.wireTypes.varint then
			if v3133 == 3 then
				local v3135

				v3135, n168 = proto.readVarIntI64(p252, n168)
				v3131.active_tooltip_idx = v3135
			else
				local v3136

				v3136, n168 = proto.readVarInt(p252, n168)
			end
		elseif v3134 == proto.wireTypes.lengthDelimited then
			if v3133 == 1 then
				local v3137

				v3137, n168 = proto.readBuffer(p252, n168)
				table.insert(v3131.marketplace_catalog_category_items, t1.UAMarketplaceCatalogCategoryMenuInputData_MarketplaceCatalogCategoryItem.decode(v3137))
			elseif v3133 == 2 then
				local v3138

				v3138, n168 = proto.readBuffer(p252, n168)
				v3131.active_category_id = buffer.tostring(v3138)
			else
				local v3139, v3140 = proto.readVarInt(p252, n168)

				n168 = v3140 + v3139
			end
		elseif v3134 == proto.wireTypes.i32 then
			local v3141

			v3141, n168 = proto.readFixed32(p252, n168)
		elseif v3134 == proto.wireTypes.i64 then
			local v3142

			v3142, n168 = proto.readFixed64(p252, n168)
		else
			error("Unsupported wire type: " .. v3134)
		end
	end

	return v3131
end
function t416.jsonEncode(p253) -- line: 18307
	local t418 = {}

	if p253.marketplace_catalog_category_items ~= nil and #p253.marketplace_catalog_category_items > 0 then
		local t419 = {}

		for _, v3147 in p253.marketplace_catalog_category_items do
			table.insert(t419, v3147:jsonEncode())
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
function t416.jsonDecode(t420: {[any]: any}) -- line: 18331
	-- upvalues: t416 (copy), t1 (copy)
	local v3149 = t416.new()

	if t420.marketplace_catalog_category_items ~= nil then
		local t421 = {}

		for _, v3152 in t420.marketplace_catalog_category_items do
			table.insert(t421, t1.UAMarketplaceCatalogCategoryMenuInputData_MarketplaceCatalogCategoryItem.jsonDecode(v3152))
		end

		v3149.marketplace_catalog_category_items = t421
	end

	if t420.marketplaceCatalogCategoryItems ~= nil then
		local t422 = {}

		for _, v3155 in t420.marketplaceCatalogCategoryItems do
			table.insert(t422, t1.UAMarketplaceCatalogCategoryMenuInputData_MarketplaceCatalogCategoryItem.jsonDecode(v3155))
		end

		v3149.marketplace_catalog_category_items = t422
	end

	if t420.active_category_id ~= nil then
		v3149.active_category_id = t420.active_category_id
	end

	if t420.activeCategoryId ~= nil then
		v3149.active_category_id = t420.activeCategoryId
	end

	if t420.active_tooltip_idx ~= nil then
		v3149.active_tooltip_idx = t420.active_tooltip_idx
	end

	if t420.activeTooltipIdx ~= nil then
		v3149.active_tooltip_idx = t420.activeTooltipIdx
	end

	return v3149
end

t416.descriptor = {
	name = "UAMarketplaceCatalogCategoryMenuInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UAMarketplaceCatalogCategoryMenuInputData"
}
t1.UAMarketplaceCatalogCategoryMenuInputData = t416
typeRegistry.default:register(t1.UAMarketplaceCatalogCategoryMenuInputData)

local t423 = {}

t423.__index = t423

function t423.new(t424: {[any]: any}?) -- line: 18394
	-- upvalues: t423 (copy)
	return (setmetatable({
		marketplace_catalog_category_item_id = if t424 ~= nil and t424.marketplace_catalog_category_item_id ~= nil then t424.marketplace_catalog_category_item_id else ""
	}, t423))
end
function t423.encode(p254) -- line: 18408
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n169 = 0

	if p254.marketplace_catalog_category_item_id ~= nil and p254.marketplace_catalog_category_item_id ~= "" then
		local v3160, v3161 = proto.writeTag(buf, n169, 1, proto.wireTypes.lengthDelimited)

		buf, n169 = proto.writeString(v3160, v3161, p254.marketplace_catalog_category_item_id)
	end

	local buf92 = buffer.create(n169)

	buffer.copy(buf92, 0, buf, 0, n169)

	return buf92
end
function t423.decode(p255: buffer) -- line: 18424
	-- upvalues: t423 (copy), proto (copy)
	local v3164 = t423.new()
	local n170 = 0

	while n170 < buffer.len(p255) do
		local v3166, v3167

		v3166, v3167, n170 = proto.readTag(p255, n170)

		if v3167 == proto.wireTypes.varint then
			local v3168

			v3168, n170 = proto.readVarInt(p255, n170)
		elseif v3167 == proto.wireTypes.lengthDelimited then
			if v3166 == 1 then
				local v3169

				v3169, n170 = proto.readBuffer(p255, n170)
				v3164.marketplace_catalog_category_item_id = buffer.tostring(v3169)
			else
				local v3170, v3171 = proto.readVarInt(p255, n170)

				n170 = v3171 + v3170
			end
		elseif v3167 == proto.wireTypes.i32 then
			local v3172

			v3172, n170 = proto.readFixed32(p255, n170)
		elseif v3167 == proto.wireTypes.i64 then
			local v3173

			v3173, n170 = proto.readFixed64(p255, n170)
		else
			error("Unsupported wire type: " .. v3167)
		end
	end

	return v3164
end
function t423.jsonEncode(p256) -- line: 18469
	local t425 = {}

	if p256.marketplace_catalog_category_item_id ~= nil and p256.marketplace_catalog_category_item_id ~= "" then
		t425.marketplaceCatalogCategoryItemId = p256.marketplace_catalog_category_item_id
	end

	return t425
end
function t423.jsonDecode(t426: {[any]: any}) -- line: 18481
	-- upvalues: t423 (copy)
	local v3177 = t423.new()

	if t426.marketplace_catalog_category_item_id ~= nil then
		v3177.marketplace_catalog_category_item_id = t426.marketplace_catalog_category_item_id
	end

	if t426.marketplaceCatalogCategoryItemId ~= nil then
		v3177.marketplace_catalog_category_item_id = t426.marketplaceCatalogCategoryItemId
	end

	return v3177
end

t423.descriptor = {
	name = "UAMarketplaceCatalogCategoryMenuInputData_MarketplaceCatalogCategoryItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.MarketplaceCatalogCategoryItem"
}
t1.UAMarketplaceCatalogCategoryMenuInputData_MarketplaceCatalogCategoryItem = t423
typeRegistry.default:register(t1.UAMarketplaceCatalogCategoryMenuInputData_MarketplaceCatalogCategoryItem)

local t427 = {}

t427.__index = t427

function t427.new(t428: {[any]: any}?) -- line: 18514
	-- upvalues: t427 (copy)
	return (setmetatable({
		items = if t428 ~= nil and t428.items ~= nil then t428.items else {},
		preview_columns = if t428 ~= nil and t428.preview_columns ~= nil then t428.preview_columns else 0,
		impression_id = if t428 ~= nil and t428.impression_id ~= nil then t428.impression_id else ""
	}, t427))
end
function t427.encode(p257) -- line: 18522
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n171 = 0

	if p257.items ~= nil and #p257.items > 0 then
		for _, v3183 in p257.items do
			local v3184 = v3183:encode()
			local v3185, v3186 = proto.writeTag(buf, n171, 1, proto.wireTypes.lengthDelimited)

			buf, n171 = proto.writeBuffer(v3185, v3186, v3184, buffer.len(v3184))
		end
	end

	if p257.preview_columns ~= nil and p257.preview_columns ~= 0 then
		local v3187, v3188 = proto.writeTag(buf, n171, 2, proto.wireTypes.varint)

		buf, n171 = proto.writeVarInt(v3187, v3188, p257.preview_columns)
	end

	if p257.impression_id ~= nil and p257.impression_id ~= "" then
		local v3189, v3190 = proto.writeTag(buf, n171, 3, proto.wireTypes.lengthDelimited)

		buf, n171 = proto.writeString(v3189, v3190, p257.impression_id)
	end

	local buf93 = buffer.create(n171)

	buffer.copy(buf93, 0, buf, 0, n171)

	return buf93
end
function t427.decode(p258: buffer) -- line: 18549
	-- upvalues: t427 (copy), proto (copy), t1 (copy)
	local v3193 = t427.new()
	local n172 = 0

	while n172 < buffer.len(p258) do
		local v3195, v3196

		v3195, v3196, n172 = proto.readTag(p258, n172)

		if v3196 == proto.wireTypes.varint then
			if v3195 == 2 then
				local v3197

				v3197, n172 = proto.readVarIntI32(p258, n172)
				v3193.preview_columns = v3197
			else
				local v3198

				v3198, n172 = proto.readVarInt(p258, n172)
			end
		elseif v3196 == proto.wireTypes.lengthDelimited then
			if v3195 == 1 then
				local v3199

				v3199, n172 = proto.readBuffer(p258, n172)
				table.insert(v3193.items, t1.CatalogItemGridInputData_CatalogItem.decode(v3199))
			elseif v3195 == 3 then
				local v3200

				v3200, n172 = proto.readBuffer(p258, n172)
				v3193.impression_id = buffer.tostring(v3200)
			else
				local v3201, v3202 = proto.readVarInt(p258, n172)

				n172 = v3202 + v3201
			end
		elseif v3196 == proto.wireTypes.i32 then
			local v3203

			v3203, n172 = proto.readFixed32(p258, n172)
		elseif v3196 == proto.wireTypes.i64 then
			local v3204

			v3204, n172 = proto.readFixed64(p258, n172)
		else
			error("Unsupported wire type: " .. v3196)
		end
	end

	return v3193
end
function t427.jsonEncode(p259) -- line: 18602
	local t429 = {}

	if p259.items ~= nil and #p259.items > 0 then
		local t430 = {}

		for _, v3209 in p259.items do
			table.insert(t430, v3209:jsonEncode())
		end

		t429.items = t430
	end

	if p259.preview_columns ~= nil and p259.preview_columns ~= 0 then
		t429.previewColumns = p259.preview_columns
	end

	if p259.impression_id ~= nil and p259.impression_id ~= "" then
		t429.impressionId = p259.impression_id
	end

	return t429
end
function t427.jsonDecode(t431: {[any]: any}) -- line: 18624
	-- upvalues: t427 (copy), t1 (copy)
	local v3211 = t427.new()

	if t431.items ~= nil then
		local t432 = {}

		for _, v3214 in t431.items do
			table.insert(t432, t1.CatalogItemGridInputData_CatalogItem.jsonDecode(v3214))
		end

		v3211.items = t432
	end

	if t431.preview_columns ~= nil then
		v3211.preview_columns = t431.preview_columns
	end

	if t431.previewColumns ~= nil then
		v3211.preview_columns = t431.previewColumns
	end

	if t431.impression_id ~= nil then
		v3211.impression_id = t431.impression_id
	end

	if t431.impressionId ~= nil then
		v3211.impression_id = t431.impressionId
	end

	return v3211
end

t427.descriptor = {
	name = "CatalogItemGridInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CatalogItemGridInputData"
}
t1.CatalogItemGridInputData = t427
typeRegistry.default:register(t1.CatalogItemGridInputData)

local t433 = {}

t433.__index = t433

function t433.new(t434: {[any]: any}?) -- line: 18669
	-- upvalues: t433 (copy)
	return (setmetatable({
		id = if t434 ~= nil and t434.id ~= nil then t434.id else "",
		type = if t434 ~= nil and t434.type ~= nil then t434.type else ""
	}, t433))
end
function t433.encode(p260) -- line: 18678
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n173 = 0

	if p260.id ~= nil and p260.id ~= "" then
		local v3219, v3220 = proto.writeTag(buf, n173, 1, proto.wireTypes.lengthDelimited)

		buf, n173 = proto.writeString(v3219, v3220, p260.id)
	end

	if p260.type ~= nil and p260.type ~= "" then
		local v3221, v3222 = proto.writeTag(buf, n173, 2, proto.wireTypes.lengthDelimited)

		buf, n173 = proto.writeString(v3221, v3222, p260.type)
	end

	local buf94 = buffer.create(n173)

	buffer.copy(buf94, 0, buf, 0, n173)

	return buf94
end
function t433.decode(p261: buffer) -- line: 18697
	-- upvalues: t433 (copy), proto (copy)
	local v3225 = t433.new()
	local n174 = 0

	while n174 < buffer.len(p261) do
		local v3227, v3228

		v3227, v3228, n174 = proto.readTag(p261, n174)

		if v3228 == proto.wireTypes.varint then
			local v3229

			v3229, n174 = proto.readVarInt(p261, n174)
		elseif v3228 == proto.wireTypes.lengthDelimited then
			if v3227 == 1 then
				local v3230

				v3230, n174 = proto.readBuffer(p261, n174)
				v3225.id = buffer.tostring(v3230)
			elseif v3227 == 2 then
				local v3231

				v3231, n174 = proto.readBuffer(p261, n174)
				v3225.type = buffer.tostring(v3231)
			else
				local v3232, v3233 = proto.readVarInt(p261, n174)

				n174 = v3233 + v3232
			end
		elseif v3228 == proto.wireTypes.i32 then
			local v3234

			v3234, n174 = proto.readFixed32(p261, n174)
		elseif v3228 == proto.wireTypes.i64 then
			local v3235

			v3235, n174 = proto.readFixed64(p261, n174)
		else
			error("Unsupported wire type: " .. v3228)
		end
	end

	return v3225
end
function t433.jsonEncode(p262) -- line: 18745
	local t435 = {}

	if p262.id ~= nil and p262.id ~= "" then
		t435.id = p262.id
	end

	if p262.type ~= nil and p262.type ~= "" then
		t435.type = p262.type
	end

	return t435
end
function t433.jsonDecode(t436: {[any]: any}) -- line: 18759
	-- upvalues: t433 (copy)
	local v3239 = t433.new()

	if t436.id ~= nil then
		v3239.id = t436.id
	end

	if t436.type ~= nil then
		v3239.type = t436.type
	end

	return v3239
end

t433.descriptor = {
	name = "CatalogItemGridInputData_CatalogItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.CatalogItem"
}
t1.CatalogItemGridInputData_CatalogItem = t433
typeRegistry.default:register(t1.CatalogItemGridInputData_CatalogItem)

local t437 = {}

t437.__index = t437

function t437.new(t438: {[any]: any}?) -- line: 18789
	-- upvalues: t437 (copy)
	return (setmetatable({
		entry_map = if t438 ~= nil and t438.entry_map ~= nil then t438.entry_map else {},
		entry_order = if t438 ~= nil and t438.entry_order ~= nil then t438.entry_order else {},
		content_pools = if t438 ~= nil and t438.content_pools ~= nil then t438.content_pools else {}
	}, t437))
end
function t437.encode(p263) -- line: 18799
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n175 = 0

	if p263.entry_map ~= nil and next(p263.entry_map) ~= nil then
		for v3244, v3245 in p263.entry_map do
			local buf95 = buffer.create(0)
			local v3247, v3248 = proto.writeTag(buf95, 0, 1, proto.wireTypes.lengthDelimited)
			local v3249, v3250 = proto.writeString(v3247, v3248, v3244)
			local v3251 = v3245:encode()
			local v3252, v3253 = proto.writeTag(v3249, v3250, 2, proto.wireTypes.lengthDelimited)
			local v3254, v3255 = proto.writeBuffer(v3252, v3253, v3251, buffer.len(v3251))
			local v3256, v3257 = proto.writeTag(buf, n175, 1, proto.wireTypes.lengthDelimited)

			buf, n175 = proto.writeBuffer(v3256, v3257, v3254, v3255)
		end
	end

	if p263.entry_order ~= nil and #p263.entry_order > 0 then
		for _, v3259 in p263.entry_order do
			local v3260, v3261 = proto.writeTag(buf, n175, 2, proto.wireTypes.lengthDelimited)

			buf, n175 = proto.writeString(v3260, v3261, v3259)
		end
	end

	if p263.content_pools ~= nil and next(p263.content_pools) ~= nil then
		for v3262, v3263 in p263.content_pools do
			local buf96 = buffer.create(0)
			local v3265, v3266 = proto.writeTag(buf96, 0, 1, proto.wireTypes.lengthDelimited)
			local v3267, v3268 = proto.writeString(v3265, v3266, v3262)
			local v3269 = v3263:encode()
			local v3270, v3271 = proto.writeTag(v3267, v3268, 2, proto.wireTypes.lengthDelimited)
			local v3272, v3273 = proto.writeBuffer(v3270, v3271, v3269, buffer.len(v3269))
			local v3274, v3275 = proto.writeTag(buf, n175, 3, proto.wireTypes.lengthDelimited)

			buf, n175 = proto.writeBuffer(v3274, v3275, v3272, v3273)
		end
	end

	local buf97 = buffer.create(n175)

	buffer.copy(buf97, 0, buf, 0, n175)

	return buf97
end
function t437.decode(p264: buffer) -- line: 18843
	-- upvalues: t437 (copy), proto (copy), t1 (copy)
	local v3278 = t437.new()
	local n176 = 0

	while n176 < buffer.len(p264) do
		local v3280, v3281

		v3280, v3281, n176 = proto.readTag(p264, n176)

		if v3281 == proto.wireTypes.varint then
			local v3282

			v3282, n176 = proto.readVarInt(p264, n176)
		elseif v3281 == proto.wireTypes.lengthDelimited then
			if v3280 == 1 then
				local v3283

				v3283, n176 = proto.readBuffer(p264, n176)

				local v3284 = t1.SearchResultsFeedInputData_EntryMapEntry.decode(v3283)
				local v3285 = t1.FeedEntry.new()

				v3278.entry_map[v3284.key or ""] = v3284.value or v3285
			elseif v3280 == 2 then
				local v3286

				v3286, n176 = proto.readBuffer(p264, n176)
				table.insert(v3278.entry_order, buffer.tostring(v3286))
			elseif v3280 == 3 then
				local v3287

				v3287, n176 = proto.readBuffer(p264, n176)

				local v3288 = t1.SearchResultsFeedInputData_ContentPoolsEntry.decode(v3287)
				local v3289 = t1.ContentPool.new()

				v3278.content_pools[v3288.key or ""] = v3288.value or v3289
			else
				local v3290, v3291 = proto.readVarInt(p264, n176)

				n176 = v3291 + v3290
			end
		elseif v3281 == proto.wireTypes.i32 then
			local v3292

			v3292, n176 = proto.readFixed32(p264, n176)
		elseif v3281 == proto.wireTypes.i64 then
			local v3293

			v3293, n176 = proto.readFixed64(p264, n176)
		else
			error("Unsupported wire type: " .. v3281)
		end
	end

	return v3278
end
function t437.jsonEncode(p265) -- line: 18910
	local t439 = {}

	if p265.entry_map ~= nil and next(p265.entry_map) ~= nil then
		local t440 = {}

		for v3297, v3298 in p265.entry_map do
			t440[v3297] = v3298:jsonEncode()
		end

		t439.entryMap = t440
	end

	if p265.entry_order ~= nil and #p265.entry_order > 0 then
		local t441 = {}

		for _, v3301 in p265.entry_order do
			table.insert(t441, v3301)
		end

		t439.entryOrder = t441
	end

	if p265.content_pools ~= nil and next(p265.content_pools) ~= nil then
		local t442 = {}

		for v3303, v3304 in p265.content_pools do
			t442[v3303] = v3304:jsonEncode()
		end

		t439.contentPools = t442
	end

	return t439
end
function t437.jsonDecode(t443: {[any]: any}) -- line: 18940
	-- upvalues: t437 (copy), t1 (copy)
	local v3306 = t437.new()

	if t443.entry_map ~= nil then
		local t444 = {}

		for v3308, v3309 in t443.entry_map do
			t444[v3308] = t1.FeedEntry.jsonDecode(v3309)
		end

		v3306.entry_map = t444
	end

	if t443.entryMap ~= nil then
		local t445 = {}

		for v3311, v3312 in t443.entryMap do
			t445[v3311] = t1.FeedEntry.jsonDecode(v3312)
		end

		v3306.entry_map = t445
	end

	if t443.entry_order ~= nil then
		local t446 = {}

		for _, v3315 in t443.entry_order do
			table.insert(t446, v3315)
		end

		v3306.entry_order = t446
	end

	if t443.entryOrder ~= nil then
		local t447 = {}

		for _, v3318 in t443.entryOrder do
			table.insert(t447, v3318)
		end

		v3306.entry_order = t447
	end

	if t443.content_pools ~= nil then
		local t448 = {}

		for v3320, v3321 in t443.content_pools do
			t448[v3320] = t1.ContentPool.jsonDecode(v3321)
		end

		v3306.content_pools = t448
	end

	if t443.contentPools ~= nil then
		local t449 = {}

		for v3323, v3324 in t443.contentPools do
			t449[v3323] = t1.ContentPool.jsonDecode(v3324)
		end

		v3306.content_pools = t449
	end

	return v3306
end

t437.descriptor = {
	name = "SearchResultsFeedInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.SearchResultsFeedInputData"
}
t1.SearchResultsFeedInputData = t437
typeRegistry.default:register(t1.SearchResultsFeedInputData)

local t450 = {}

t450.__index = t450

function t450.new(t451: {[any]: any}?) -- line: 19014
	-- upvalues: t450 (copy)
	return (setmetatable({
		key = if t451 ~= nil and t451.key ~= nil then t451.key else "",
		value = if t451 ~= nil and t451.value ~= nil then t451.value else nil
	}, t450))
end
function t450.encode(p266) -- line: 19023
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n177 = 0

	if p266.key ~= nil and p266.key ~= "" then
		local v3329, v3330 = proto.writeTag(buf, n177, 1, proto.wireTypes.lengthDelimited)

		buf, n177 = proto.writeString(v3329, v3330, p266.key)
	end

	if p266.value ~= nil then
		local v3331 = p266.value:encode()
		local v3332, v3333 = proto.writeTag(buf, n177, 2, proto.wireTypes.lengthDelimited)

		buf, n177 = proto.writeBuffer(v3332, v3333, v3331, buffer.len(v3331))
	end

	local buf98 = buffer.create(n177)

	buffer.copy(buf98, 0, buf, 0, n177)

	return buf98
end
function t450.decode(p267: buffer) -- line: 19045
	-- upvalues: t450 (copy), proto (copy), t1 (copy)
	local v3336 = t450.new()
	local n178 = 0

	while n178 < buffer.len(p267) do
		local v3338, v3339

		v3338, v3339, n178 = proto.readTag(p267, n178)

		if v3339 == proto.wireTypes.varint then
			local v3340

			v3340, n178 = proto.readVarInt(p267, n178)
		elseif v3339 == proto.wireTypes.lengthDelimited then
			if v3338 == 1 then
				local v3341

				v3341, n178 = proto.readBuffer(p267, n178)
				v3336.key = buffer.tostring(v3341)
			elseif v3338 == 2 then
				local v3342

				v3342, n178 = proto.readBuffer(p267, n178)
				v3336.value = t1.FeedEntry.decode(v3342)
			else
				local v3343, v3344 = proto.readVarInt(p267, n178)

				n178 = v3344 + v3343
			end
		elseif v3339 == proto.wireTypes.i32 then
			local v3345

			v3345, n178 = proto.readFixed32(p267, n178)
		elseif v3339 == proto.wireTypes.i64 then
			local v3346

			v3346, n178 = proto.readFixed64(p267, n178)
		else
			error("Unsupported wire type: " .. v3339)
		end
	end

	return v3336
end
function t450.jsonEncode(p268) -- line: 19095
	local t452 = {}

	if p268.key ~= nil and p268.key ~= "" then
		t452.key = p268.key
	end

	if p268.value ~= nil then
		t452.value = p268.value:jsonEncode()
	end

	return t452
end
function t450.jsonDecode(t453: {[any]: any}) -- line: 19111
	-- upvalues: t450 (copy), t1 (copy)
	local v3350 = t450.new()

	if t453.key ~= nil then
		v3350.key = t453.key
	end

	if t453.value ~= nil then
		v3350.value = t1.FeedEntry.jsonDecode(t453.value)
	end

	return v3350
end

t450.descriptor = {
	name = "SearchResultsFeedInputData_EntryMapEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryMapEntry"
}
t1.SearchResultsFeedInputData_EntryMapEntry = t450
typeRegistry.default:register(t1.SearchResultsFeedInputData_EntryMapEntry)

local t454 = {}

t454.__index = t454

function t454.new(t455: {[any]: any}?) -- line: 19141
	-- upvalues: t454 (copy)
	return (setmetatable({
		key = if t455 ~= nil and t455.key ~= nil then t455.key else "",
		value = if t455 ~= nil and t455.value ~= nil then t455.value else nil
	}, t454))
end
function t454.encode(p269) -- line: 19150
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n179 = 0

	if p269.key ~= nil and p269.key ~= "" then
		local v3355, v3356 = proto.writeTag(buf, n179, 1, proto.wireTypes.lengthDelimited)

		buf, n179 = proto.writeString(v3355, v3356, p269.key)
	end

	if p269.value ~= nil then
		local v3357 = p269.value:encode()
		local v3358, v3359 = proto.writeTag(buf, n179, 2, proto.wireTypes.lengthDelimited)

		buf, n179 = proto.writeBuffer(v3358, v3359, v3357, buffer.len(v3357))
	end

	local buf99 = buffer.create(n179)

	buffer.copy(buf99, 0, buf, 0, n179)

	return buf99
end
function t454.decode(p270: buffer) -- line: 19172
	-- upvalues: t454 (copy), proto (copy), t1 (copy)
	local v3362 = t454.new()
	local n180 = 0

	while n180 < buffer.len(p270) do
		local v3364, v3365

		v3364, v3365, n180 = proto.readTag(p270, n180)

		if v3365 == proto.wireTypes.varint then
			local v3366

			v3366, n180 = proto.readVarInt(p270, n180)
		elseif v3365 == proto.wireTypes.lengthDelimited then
			if v3364 == 1 then
				local v3367

				v3367, n180 = proto.readBuffer(p270, n180)
				v3362.key = buffer.tostring(v3367)
			elseif v3364 == 2 then
				local v3368

				v3368, n180 = proto.readBuffer(p270, n180)
				v3362.value = t1.ContentPool.decode(v3368)
			else
				local v3369, v3370 = proto.readVarInt(p270, n180)

				n180 = v3370 + v3369
			end
		elseif v3365 == proto.wireTypes.i32 then
			local v3371

			v3371, n180 = proto.readFixed32(p270, n180)
		elseif v3365 == proto.wireTypes.i64 then
			local v3372

			v3372, n180 = proto.readFixed64(p270, n180)
		else
			error("Unsupported wire type: " .. v3365)
		end
	end

	return v3362
end
function t454.jsonEncode(p271) -- line: 19222
	local t456 = {}

	if p271.key ~= nil and p271.key ~= "" then
		t456.key = p271.key
	end

	if p271.value ~= nil then
		t456.value = p271.value:jsonEncode()
	end

	return t456
end
function t454.jsonDecode(t457: {[any]: any}) -- line: 19238
	-- upvalues: t454 (copy), t1 (copy)
	local v3376 = t454.new()

	if t457.key ~= nil then
		v3376.key = t457.key
	end

	if t457.value ~= nil then
		v3376.value = t1.ContentPool.jsonDecode(t457.value)
	end

	return v3376
end

t454.descriptor = {
	name = "SearchResultsFeedInputData_ContentPoolsEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.ContentPoolsEntry"
}
t1.SearchResultsFeedInputData_ContentPoolsEntry = t454
typeRegistry.default:register(t1.SearchResultsFeedInputData_ContentPoolsEntry)

local t458 = {}

t458.__index = t458

function t458.new(t459: {[any]: any}?) -- line: 19268
	-- upvalues: t458 (copy)
	return (setmetatable({
		universe_id = if t459 ~= nil and t459.universe_id ~= nil then t459.universe_id else "",
		is_content_locked = t459 ~= nil and (t459.is_content_locked ~= nil and t459.is_content_locked)
	}, t458))
end
function t458.encode(p272) -- line: 19277
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n181 = 0

	if p272.universe_id ~= nil and p272.universe_id ~= "" then
		local v3381, v3382 = proto.writeTag(buf, n181, 1, proto.wireTypes.lengthDelimited)

		buf, n181 = proto.writeString(v3381, v3382, p272.universe_id)
	end

	if p272.is_content_locked then
		local v3383, v3384 = proto.writeTag(buf, n181, 2, proto.wireTypes.varint)

		buf, n181 = proto.writeVarInt(v3383, v3384, not p272.is_content_locked and 0 or 1)
	end

	local buf100 = buffer.create(n181)

	buffer.copy(buf100, 0, buf, 0, n181)

	return buf100
end
function t458.decode(p273: buffer) -- line: 19296
	-- upvalues: t458 (copy), proto (copy)
	local v3387 = t458.new()
	local n182 = 0

	while n182 < buffer.len(p273) do
		local v3389, v3390

		v3389, v3390, n182 = proto.readTag(p273, n182)

		if v3390 == proto.wireTypes.varint then
			if v3389 == 2 then
				local v3391

				v3391, n182 = proto.readVarInt(p273, n182)
				v3387.is_content_locked = v3391 ~= 0
			else
				local v3392

				v3392, n182 = proto.readVarInt(p273, n182)
			end
		elseif v3390 == proto.wireTypes.lengthDelimited then
			if v3389 == 1 then
				local v3393

				v3393, n182 = proto.readBuffer(p273, n182)
				v3387.universe_id = buffer.tostring(v3393)
			else
				local v3394, v3395 = proto.readVarInt(p273, n182)

				n182 = v3395 + v3394
			end
		elseif v3390 == proto.wireTypes.i32 then
			local v3396

			v3396, n182 = proto.readFixed32(p273, n182)
		elseif v3390 == proto.wireTypes.i64 then
			local v3397

			v3397, n182 = proto.readFixed64(p273, n182)
		else
			error("Unsupported wire type: " .. v3390)
		end
	end

	return v3387
end
function t458.jsonEncode(p274) -- line: 19344
	local t460 = {}

	if p274.universe_id ~= nil and p274.universe_id ~= "" then
		t460.universeId = p274.universe_id
	end

	if p274.is_content_locked then
		t460.isContentLocked = p274.is_content_locked
	end

	return t460
end
function t458.jsonDecode(t461: {[any]: any}) -- line: 19358
	-- upvalues: t458 (copy)
	local v3401 = t458.new()

	if t461.universe_id ~= nil then
		v3401.universe_id = t461.universe_id
	end

	if t461.universeId ~= nil then
		v3401.universe_id = t461.universeId
	end

	if t461.is_content_locked ~= nil then
		v3401.is_content_locked = t461.is_content_locked
	end

	if t461.isContentLocked ~= nil then
		v3401.is_content_locked = t461.isContentLocked
	end

	return v3401
end

t458.descriptor = {
	name = "ExperienceEmphasisTileInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceEmphasisTileInputData"
}
t1.ExperienceEmphasisTileInputData = t458
typeRegistry.default:register(t1.ExperienceEmphasisTileInputData)

local t462 = {}

t462.__index = t462

function t462.new(t463: {[any]: any}?) -- line: 19394
	-- upvalues: t462 (copy)
	return (setmetatable({
		overview_rich_text = if t463 ~= nil and t463.overview_rich_text ~= nil then t463.overview_rich_text else "",
		result_entry = if t463 ~= nil and t463.result_entry ~= nil then t463.result_entry else nil,
		follow_up_queries = if t463 ~= nil and t463.follow_up_queries ~= nil then t463.follow_up_queries else {},
		show_loading = t463 ~= nil and (t463.show_loading ~= nil and t463.show_loading),
		title = if t463 ~= nil and t463.title ~= nil then t463.title else "",
		search_query = if t463 ~= nil and t463.search_query ~= nil then t463.search_query else "",
		search_session_id = if t463 ~= nil and t463.search_session_id ~= nil then t463.search_session_id else "",
		universe_ids = if t463 ~= nil and t463.universe_ids ~= nil then t463.universe_ids else ""
	}, t462))
end
function t462.encode(p275) -- line: 19409
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n183 = 0

	if p275.overview_rich_text ~= nil and p275.overview_rich_text ~= "" then
		local v3406, v3407 = proto.writeTag(buf, n183, 1, proto.wireTypes.lengthDelimited)

		buf, n183 = proto.writeString(v3406, v3407, p275.overview_rich_text)
	end

	if p275.result_entry ~= nil then
		local v3408 = p275.result_entry:encode()
		local v3409, v3410 = proto.writeTag(buf, n183, 2, proto.wireTypes.lengthDelimited)

		buf, n183 = proto.writeBuffer(v3409, v3410, v3408, buffer.len(v3408))
	end

	if p275.follow_up_queries ~= nil and #p275.follow_up_queries > 0 then
		for _, v3412 in p275.follow_up_queries do
			local v3413, v3414 = proto.writeTag(buf, n183, 3, proto.wireTypes.lengthDelimited)

			buf, n183 = proto.writeString(v3413, v3414, v3412)
		end
	end

	if p275.show_loading then
		local v3415, v3416 = proto.writeTag(buf, n183, 4, proto.wireTypes.varint)

		buf, n183 = proto.writeVarInt(v3415, v3416, not p275.show_loading and 0 or 1)
	end

	if p275.title ~= nil and p275.title ~= "" then
		local v3417, v3418 = proto.writeTag(buf, n183, 5, proto.wireTypes.lengthDelimited)

		buf, n183 = proto.writeString(v3417, v3418, p275.title)
	end

	if p275.search_query ~= nil and p275.search_query ~= "" then
		local v3419, v3420 = proto.writeTag(buf, n183, 6, proto.wireTypes.lengthDelimited)

		buf, n183 = proto.writeString(v3419, v3420, p275.search_query)
	end

	if p275.search_session_id ~= nil and p275.search_session_id ~= "" then
		local v3421, v3422 = proto.writeTag(buf, n183, 7, proto.wireTypes.lengthDelimited)

		buf, n183 = proto.writeString(v3421, v3422, p275.search_session_id)
	end

	if p275.universe_ids ~= nil and p275.universe_ids ~= "" then
		local v3423, v3424 = proto.writeTag(buf, n183, 8, proto.wireTypes.lengthDelimited)

		buf, n183 = proto.writeString(v3423, v3424, p275.universe_ids)
	end

	local buf101 = buffer.create(n183)

	buffer.copy(buf101, 0, buf, 0, n183)

	return buf101
end
function t462.decode(p276: buffer) -- line: 19461
	-- upvalues: t462 (copy), proto (copy), t1 (copy)
	local v3427 = t462.new()
	local n184 = 0

	while n184 < buffer.len(p276) do
		local v3429, v3430

		v3429, v3430, n184 = proto.readTag(p276, n184)

		if v3430 == proto.wireTypes.varint then
			if v3429 == 4 then
				local v3431

				v3431, n184 = proto.readVarInt(p276, n184)
				v3427.show_loading = v3431 ~= 0
			else
				local v3432

				v3432, n184 = proto.readVarInt(p276, n184)
			end
		elseif v3430 == proto.wireTypes.lengthDelimited then
			if v3429 == 1 then
				local v3433

				v3433, n184 = proto.readBuffer(p276, n184)
				v3427.overview_rich_text = buffer.tostring(v3433)
			elseif v3429 == 2 then
				local v3434

				v3434, n184 = proto.readBuffer(p276, n184)
				v3427.result_entry = t1.FeedEntry.decode(v3434)
			elseif v3429 == 3 then
				local v3435

				v3435, n184 = proto.readBuffer(p276, n184)
				table.insert(v3427.follow_up_queries, buffer.tostring(v3435))
			elseif v3429 == 5 then
				local v3436

				v3436, n184 = proto.readBuffer(p276, n184)
				v3427.title = buffer.tostring(v3436)
			elseif v3429 == 6 then
				local v3437

				v3437, n184 = proto.readBuffer(p276, n184)
				v3427.search_query = buffer.tostring(v3437)
			elseif v3429 == 7 then
				local v3438

				v3438, n184 = proto.readBuffer(p276, n184)
				v3427.search_session_id = buffer.tostring(v3438)
			elseif v3429 == 8 then
				local v3439

				v3439, n184 = proto.readBuffer(p276, n184)
				v3427.universe_ids = buffer.tostring(v3439)
			else
				local v3440, v3441 = proto.readVarInt(p276, n184)

				n184 = v3441 + v3440
			end
		elseif v3430 == proto.wireTypes.i32 then
			local v3442

			v3442, n184 = proto.readFixed32(p276, n184)
		elseif v3430 == proto.wireTypes.i64 then
			local v3443

			v3443, n184 = proto.readFixed64(p276, n184)
		else
			error("Unsupported wire type: " .. v3430)
		end
	end

	return v3427
end
function t462.jsonEncode(p277) -- line: 19539
	local t464 = {}

	if p277.overview_rich_text ~= nil and p277.overview_rich_text ~= "" then
		t464.overviewRichText = p277.overview_rich_text
	end

	if p277.result_entry ~= nil then
		t464.resultEntry = p277.result_entry:jsonEncode()
	end

	if p277.follow_up_queries ~= nil and #p277.follow_up_queries > 0 then
		local t465 = {}

		for _, v3448 in p277.follow_up_queries do
			table.insert(t465, v3448)
		end

		t464.followUpQueries = t465
	end

	if p277.show_loading then
		t464.showLoading = p277.show_loading
	end

	if p277.title ~= nil and p277.title ~= "" then
		t464.title = p277.title
	end

	if p277.search_query ~= nil and p277.search_query ~= "" then
		t464.searchQuery = p277.search_query
	end

	if p277.search_session_id ~= nil and p277.search_session_id ~= "" then
		t464.searchSessionId = p277.search_session_id
	end

	if p277.universe_ids ~= nil and p277.universe_ids ~= "" then
		t464.universeIds = p277.universe_ids
	end

	return t464
end
function t462.jsonDecode(t466: {[any]: any}) -- line: 19581
	-- upvalues: t462 (copy), t1 (copy)
	local v3450 = t462.new()

	if t466.overview_rich_text ~= nil then
		v3450.overview_rich_text = t466.overview_rich_text
	end

	if t466.overviewRichText ~= nil then
		v3450.overview_rich_text = t466.overviewRichText
	end

	if t466.result_entry ~= nil then
		v3450.result_entry = t1.FeedEntry.jsonDecode(t466.result_entry)
	end

	if t466.resultEntry ~= nil then
		v3450.result_entry = t1.FeedEntry.jsonDecode(t466.resultEntry)
	end

	if t466.follow_up_queries ~= nil then
		local t467 = {}

		for _, v3453 in t466.follow_up_queries do
			table.insert(t467, v3453)
		end

		v3450.follow_up_queries = t467
	end

	if t466.followUpQueries ~= nil then
		local t468 = {}

		for _, v3456 in t466.followUpQueries do
			table.insert(t468, v3456)
		end

		v3450.follow_up_queries = t468
	end

	if t466.show_loading ~= nil then
		v3450.show_loading = t466.show_loading
	end

	if t466.showLoading ~= nil then
		v3450.show_loading = t466.showLoading
	end

	if t466.title ~= nil then
		v3450.title = t466.title
	end

	if t466.search_query ~= nil then
		v3450.search_query = t466.search_query
	end

	if t466.searchQuery ~= nil then
		v3450.search_query = t466.searchQuery
	end

	if t466.search_session_id ~= nil then
		v3450.search_session_id = t466.search_session_id
	end

	if t466.searchSessionId ~= nil then
		v3450.search_session_id = t466.searchSessionId
	end

	if t466.universe_ids ~= nil then
		v3450.universe_ids = t466.universe_ids
	end

	if t466.universeIds ~= nil then
		v3450.universe_ids = t466.universeIds
	end

	return v3450
end

t462.descriptor = {
	name = "PowerSearchAIOverviewInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.PowerSearchAIOverviewInputData"
}
t1.PowerSearchAIOverviewInputData = t462
typeRegistry.default:register(t1.PowerSearchAIOverviewInputData)

local t469 = {}

t469.__index = t469

function t469.new(t470: {[any]: any}?) -- line: 19671
	-- upvalues: t469 (copy)
	return (setmetatable({
		title = if t470 ~= nil and t470.title ~= nil then t470.title else "",
		user_items = if t470 ~= nil and t470.user_items ~= nil then t470.user_items else {},
		max_visible_rows = if t470 ~= nil and t470.max_visible_rows ~= nil then t470.max_visible_rows else 0
	}, t469))
end
function t469.encode(p278) -- line: 19679
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n185 = 0

	if p278.title ~= nil and p278.title ~= "" then
		local v3461, v3462 = proto.writeTag(buf, n185, 1, proto.wireTypes.lengthDelimited)

		buf, n185 = proto.writeString(v3461, v3462, p278.title)
	end

	if p278.user_items ~= nil and #p278.user_items > 0 then
		for _, v3464 in p278.user_items do
			local v3465 = v3464:encode()
			local v3466, v3467 = proto.writeTag(buf, n185, 2, proto.wireTypes.lengthDelimited)

			buf, n185 = proto.writeBuffer(v3466, v3467, v3465, buffer.len(v3465))
		end
	end

	if p278.max_visible_rows ~= nil and p278.max_visible_rows ~= 0 then
		local v3468, v3469 = proto.writeTag(buf, n185, 3, proto.wireTypes.varint)

		buf, n185 = proto.writeVarInt(v3468, v3469, p278.max_visible_rows)
	end

	local buf102 = buffer.create(n185)

	buffer.copy(buf102, 0, buf, 0, n185)

	return buf102
end
function t469.decode(p279: buffer) -- line: 19706
	-- upvalues: t469 (copy), proto (copy), t1 (copy)
	local v3472 = t469.new()
	local n186 = 0

	while n186 < buffer.len(p279) do
		local v3474, v3475

		v3474, v3475, n186 = proto.readTag(p279, n186)

		if v3475 == proto.wireTypes.varint then
			if v3474 == 3 then
				local v3476

				v3476, n186 = proto.readVarIntI32(p279, n186)
				v3472.max_visible_rows = v3476
			else
				local v3477

				v3477, n186 = proto.readVarInt(p279, n186)
			end
		elseif v3475 == proto.wireTypes.lengthDelimited then
			if v3474 == 1 then
				local v3478

				v3478, n186 = proto.readBuffer(p279, n186)
				v3472.title = buffer.tostring(v3478)
			elseif v3474 == 2 then
				local v3479

				v3479, n186 = proto.readBuffer(p279, n186)
				table.insert(v3472.user_items, t1.UserListInputData_UserItem.decode(v3479))
			else
				local v3480, v3481 = proto.readVarInt(p279, n186)

				n186 = v3481 + v3480
			end
		elseif v3475 == proto.wireTypes.i32 then
			local v3482

			v3482, n186 = proto.readFixed32(p279, n186)
		elseif v3475 == proto.wireTypes.i64 then
			local v3483

			v3483, n186 = proto.readFixed64(p279, n186)
		else
			error("Unsupported wire type: " .. v3475)
		end
	end

	return v3472
end
function t469.jsonEncode(p280) -- line: 19759
	local t471 = {}

	if p280.title ~= nil and p280.title ~= "" then
		t471.title = p280.title
	end

	if p280.user_items ~= nil and #p280.user_items > 0 then
		local t472 = {}

		for _, v3488 in p280.user_items do
			table.insert(t472, v3488:jsonEncode())
		end

		t471.userItems = t472
	end

	if p280.max_visible_rows ~= nil and p280.max_visible_rows ~= 0 then
		t471.maxVisibleRows = p280.max_visible_rows
	end

	return t471
end
function t469.jsonDecode(t473: {[any]: any}) -- line: 19781
	-- upvalues: t469 (copy), t1 (copy)
	local v3490 = t469.new()

	if t473.title ~= nil then
		v3490.title = t473.title
	end

	if t473.user_items ~= nil then
		local t474 = {}

		for _, v3493 in t473.user_items do
			table.insert(t474, t1.UserListInputData_UserItem.jsonDecode(v3493))
		end

		v3490.user_items = t474
	end

	if t473.userItems ~= nil then
		local t475 = {}

		for _, v3496 in t473.userItems do
			table.insert(t475, t1.UserListInputData_UserItem.jsonDecode(v3496))
		end

		v3490.user_items = t475
	end

	if t473.max_visible_rows ~= nil then
		v3490.max_visible_rows = t473.max_visible_rows
	end

	if t473.maxVisibleRows ~= nil then
		v3490.max_visible_rows = t473.maxVisibleRows
	end

	return v3490
end

t469.descriptor = {
	name = "UserListInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UserListInputData"
}
t1.UserListInputData = t469
typeRegistry.default:register(t1.UserListInputData)

local t476 = {}

t476.__index = t476

function t476.new(t477: {[any]: any}?) -- line: 19831
	-- upvalues: t476 (copy)
	return (setmetatable({
		user_id = if t477 ~= nil and t477.user_id ~= nil then t477.user_id else ""
	}, t476))
end
function t476.encode(p281) -- line: 19839
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n187 = 0

	if p281.user_id ~= nil and p281.user_id ~= "" then
		local v3501, v3502 = proto.writeTag(buf, n187, 1, proto.wireTypes.lengthDelimited)

		buf, n187 = proto.writeString(v3501, v3502, p281.user_id)
	end

	local buf103 = buffer.create(n187)

	buffer.copy(buf103, 0, buf, 0, n187)

	return buf103
end
function t476.decode(p282: buffer) -- line: 19853
	-- upvalues: t476 (copy), proto (copy)
	local v3505 = t476.new()
	local n188 = 0

	while n188 < buffer.len(p282) do
		local v3507, v3508

		v3507, v3508, n188 = proto.readTag(p282, n188)

		if v3508 == proto.wireTypes.varint then
			local v3509

			v3509, n188 = proto.readVarInt(p282, n188)
		elseif v3508 == proto.wireTypes.lengthDelimited then
			if v3507 == 1 then
				local v3510

				v3510, n188 = proto.readBuffer(p282, n188)
				v3505.user_id = buffer.tostring(v3510)
			else
				local v3511, v3512 = proto.readVarInt(p282, n188)

				n188 = v3512 + v3511
			end
		elseif v3508 == proto.wireTypes.i32 then
			local v3513

			v3513, n188 = proto.readFixed32(p282, n188)
		elseif v3508 == proto.wireTypes.i64 then
			local v3514

			v3514, n188 = proto.readFixed64(p282, n188)
		else
			error("Unsupported wire type: " .. v3508)
		end
	end

	return v3505
end
function t476.jsonEncode(p283) -- line: 19896
	local t478 = {}

	if p283.user_id ~= nil and p283.user_id ~= "" then
		t478.userId = p283.user_id
	end

	return t478
end
function t476.jsonDecode(t479: {[any]: any}) -- line: 19906
	-- upvalues: t476 (copy)
	local v3518 = t476.new()

	if t479.user_id ~= nil then
		v3518.user_id = t479.user_id
	end

	if t479.userId ~= nil then
		v3518.user_id = t479.userId
	end

	return v3518
end

t476.descriptor = {
	name = "UserListInputData_UserItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.UserItem"
}
t1.UserListInputData_UserItem = t476
typeRegistry.default:register(t1.UserListInputData_UserItem)

local t480 = {}

t480.__index = t480

function t480.new(t481: {[any]: any}?) -- line: 19934
	-- upvalues: t480 (copy)
	return (setmetatable({
		title = if t481 ~= nil and t481.title ~= nil then t481.title else "",
		items = if t481 ~= nil and t481.items ~= nil then t481.items else {},
		max_visible_rows = if t481 ~= nil and t481.max_visible_rows ~= nil then t481.max_visible_rows else 0
	}, t480))
end
function t480.encode(p284) -- line: 19942
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n189 = 0

	if p284.title ~= nil and p284.title ~= "" then
		local v3523, v3524 = proto.writeTag(buf, n189, 1, proto.wireTypes.lengthDelimited)

		buf, n189 = proto.writeString(v3523, v3524, p284.title)
	end

	if p284.items ~= nil and #p284.items > 0 then
		for _, v3526 in p284.items do
			local v3527 = v3526:encode()
			local v3528, v3529 = proto.writeTag(buf, n189, 2, proto.wireTypes.lengthDelimited)

			buf, n189 = proto.writeBuffer(v3528, v3529, v3527, buffer.len(v3527))
		end
	end

	if p284.max_visible_rows ~= nil and p284.max_visible_rows ~= 0 then
		local v3530, v3531 = proto.writeTag(buf, n189, 3, proto.wireTypes.varint)

		buf, n189 = proto.writeVarInt(v3530, v3531, p284.max_visible_rows)
	end

	local buf104 = buffer.create(n189)

	buffer.copy(buf104, 0, buf, 0, n189)

	return buf104
end
function t480.decode(p285: buffer) -- line: 19969
	-- upvalues: t480 (copy), proto (copy), t1 (copy)
	local v3534 = t480.new()
	local n190 = 0

	while n190 < buffer.len(p285) do
		local v3536, v3537

		v3536, v3537, n190 = proto.readTag(p285, n190)

		if v3537 == proto.wireTypes.varint then
			if v3536 == 3 then
				local v3538

				v3538, n190 = proto.readVarIntI32(p285, n190)
				v3534.max_visible_rows = v3538
			else
				local v3539

				v3539, n190 = proto.readVarInt(p285, n190)
			end
		elseif v3537 == proto.wireTypes.lengthDelimited then
			if v3536 == 1 then
				local v3540

				v3540, n190 = proto.readBuffer(p285, n190)
				v3534.title = buffer.tostring(v3540)
			elseif v3536 == 2 then
				local v3541

				v3541, n190 = proto.readBuffer(p285, n190)
				table.insert(v3534.items, t1.CatalogItemListInputData_CatalogItem.decode(v3541))
			else
				local v3542, v3543 = proto.readVarInt(p285, n190)

				n190 = v3543 + v3542
			end
		elseif v3537 == proto.wireTypes.i32 then
			local v3544

			v3544, n190 = proto.readFixed32(p285, n190)
		elseif v3537 == proto.wireTypes.i64 then
			local v3545

			v3545, n190 = proto.readFixed64(p285, n190)
		else
			error("Unsupported wire type: " .. v3537)
		end
	end

	return v3534
end
function t480.jsonEncode(p286) -- line: 20022
	local t482 = {}

	if p286.title ~= nil and p286.title ~= "" then
		t482.title = p286.title
	end

	if p286.items ~= nil and #p286.items > 0 then
		local t483 = {}

		for _, v3550 in p286.items do
			table.insert(t483, v3550:jsonEncode())
		end

		t482.items = t483
	end

	if p286.max_visible_rows ~= nil and p286.max_visible_rows ~= 0 then
		t482.maxVisibleRows = p286.max_visible_rows
	end

	return t482
end
function t480.jsonDecode(t484: {[any]: any}) -- line: 20044
	-- upvalues: t480 (copy), t1 (copy)
	local v3552 = t480.new()

	if t484.title ~= nil then
		v3552.title = t484.title
	end

	if t484.items ~= nil then
		local t485 = {}

		for _, v3555 in t484.items do
			table.insert(t485, t1.CatalogItemListInputData_CatalogItem.jsonDecode(v3555))
		end

		v3552.items = t485
	end

	if t484.max_visible_rows ~= nil then
		v3552.max_visible_rows = t484.max_visible_rows
	end

	if t484.maxVisibleRows ~= nil then
		v3552.max_visible_rows = t484.maxVisibleRows
	end

	return v3552
end

t480.descriptor = {
	name = "CatalogItemListInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CatalogItemListInputData"
}
t1.CatalogItemListInputData = t480
typeRegistry.default:register(t1.CatalogItemListInputData)

local t486 = {}

t486.__index = t486

function t486.new(t487: {[any]: any}?) -- line: 20085
	-- upvalues: t486 (copy)
	return (setmetatable({
		item_id = if t487 ~= nil and t487.item_id ~= nil then t487.item_id else "",
		item_type = if t487 ~= nil and t487.item_type ~= nil then t487.item_type else ""
	}, t486))
end
function t486.encode(p287) -- line: 20094
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n191 = 0

	if p287.item_id ~= nil and p287.item_id ~= "" then
		local v3560, v3561 = proto.writeTag(buf, n191, 1, proto.wireTypes.lengthDelimited)

		buf, n191 = proto.writeString(v3560, v3561, p287.item_id)
	end

	if p287.item_type ~= nil and p287.item_type ~= "" then
		local v3562, v3563 = proto.writeTag(buf, n191, 2, proto.wireTypes.lengthDelimited)

		buf, n191 = proto.writeString(v3562, v3563, p287.item_type)
	end

	local buf105 = buffer.create(n191)

	buffer.copy(buf105, 0, buf, 0, n191)

	return buf105
end
function t486.decode(p288: buffer) -- line: 20113
	-- upvalues: t486 (copy), proto (copy)
	local v3566 = t486.new()
	local n192 = 0

	while n192 < buffer.len(p288) do
		local v3568, v3569

		v3568, v3569, n192 = proto.readTag(p288, n192)

		if v3569 == proto.wireTypes.varint then
			local v3570

			v3570, n192 = proto.readVarInt(p288, n192)
		elseif v3569 == proto.wireTypes.lengthDelimited then
			if v3568 == 1 then
				local v3571

				v3571, n192 = proto.readBuffer(p288, n192)
				v3566.item_id = buffer.tostring(v3571)
			elseif v3568 == 2 then
				local v3572

				v3572, n192 = proto.readBuffer(p288, n192)
				v3566.item_type = buffer.tostring(v3572)
			else
				local v3573, v3574 = proto.readVarInt(p288, n192)

				n192 = v3574 + v3573
			end
		elseif v3569 == proto.wireTypes.i32 then
			local v3575

			v3575, n192 = proto.readFixed32(p288, n192)
		elseif v3569 == proto.wireTypes.i64 then
			local v3576

			v3576, n192 = proto.readFixed64(p288, n192)
		else
			error("Unsupported wire type: " .. v3569)
		end
	end

	return v3566
end
function t486.jsonEncode(p289) -- line: 20161
	local t488 = {}

	if p289.item_id ~= nil and p289.item_id ~= "" then
		t488.itemId = p289.item_id
	end

	if p289.item_type ~= nil and p289.item_type ~= "" then
		t488.itemType = p289.item_type
	end

	return t488
end
function t486.jsonDecode(t489: {[any]: any}) -- line: 20175
	-- upvalues: t486 (copy)
	local v3580 = t486.new()

	if t489.item_id ~= nil then
		v3580.item_id = t489.item_id
	end

	if t489.itemId ~= nil then
		v3580.item_id = t489.itemId
	end

	if t489.item_type ~= nil then
		v3580.item_type = t489.item_type
	end

	if t489.itemType ~= nil then
		v3580.item_type = t489.itemType
	end

	return v3580
end

t486.descriptor = {
	name = "CatalogItemListInputData_CatalogItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.CatalogItem"
}
t1.CatalogItemListInputData_CatalogItem = t486
typeRegistry.default:register(t1.CatalogItemListInputData_CatalogItem)

local t490 = {}

t490.__index = t490

function t490.new(t491: {[any]: any}?) -- line: 20213
	-- upvalues: t490 (copy)
	return (setmetatable({
		universe_id = if t491 ~= nil and t491.universe_id ~= nil then t491.universe_id else ""
	}, t490))
end
function t490.encode(p290) -- line: 20221
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n193 = 0

	if p290.universe_id ~= nil and p290.universe_id ~= "" then
		local v3585, v3586 = proto.writeTag(buf, n193, 1, proto.wireTypes.lengthDelimited)

		buf, n193 = proto.writeString(v3585, v3586, p290.universe_id)
	end

	local buf106 = buffer.create(n193)

	buffer.copy(buf106, 0, buf, 0, n193)

	return buf106
end
function t490.decode(p291: buffer) -- line: 20235
	-- upvalues: t490 (copy), proto (copy)
	local v3589 = t490.new()
	local n194 = 0

	while n194 < buffer.len(p291) do
		local v3591, v3592

		v3591, v3592, n194 = proto.readTag(p291, n194)

		if v3592 == proto.wireTypes.varint then
			local v3593

			v3593, n194 = proto.readVarInt(p291, n194)
		elseif v3592 == proto.wireTypes.lengthDelimited then
			if v3591 == 1 then
				local v3594

				v3594, n194 = proto.readBuffer(p291, n194)
				v3589.universe_id = buffer.tostring(v3594)
			else
				local v3595, v3596 = proto.readVarInt(p291, n194)

				n194 = v3596 + v3595
			end
		elseif v3592 == proto.wireTypes.i32 then
			local v3597

			v3597, n194 = proto.readFixed32(p291, n194)
		elseif v3592 == proto.wireTypes.i64 then
			local v3598

			v3598, n194 = proto.readFixed64(p291, n194)
		else
			error("Unsupported wire type: " .. v3592)
		end
	end

	return v3589
end
function t490.jsonEncode(p292) -- line: 20278
	local t492 = {}

	if p292.universe_id ~= nil and p292.universe_id ~= "" then
		t492.universeId = p292.universe_id
	end

	return t492
end
function t490.jsonDecode(t493: {[any]: any}) -- line: 20288
	-- upvalues: t490 (copy)
	local v3602 = t490.new()

	if t493.universe_id ~= nil then
		v3602.universe_id = t493.universe_id
	end

	if t493.universeId ~= nil then
		v3602.universe_id = t493.universeId
	end

	return v3602
end

t490.descriptor = {
	name = "ExperienceGuidelinesDialogInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceGuidelinesDialogInputData"
}
t1.ExperienceGuidelinesDialogInputData = t490
typeRegistry.default:register(t1.ExperienceGuidelinesDialogInputData)

local t494 = {}

t494.__index = t494

function t494.new(t495: {[any]: any}?) -- line: 20318
	-- upvalues: t494 (copy)
	return (setmetatable({
		title = if t495 ~= nil and t495.title ~= nil then t495.title else "",
		subtitle = if t495 ~= nil and t495.subtitle ~= nil then t495.subtitle else "",
		moment_items = if t495 ~= nil and t495.moment_items ~= nil then t495.moment_items else {}
	}, t494))
end
function t494.encode(p293) -- line: 20326
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n195 = 0

	if p293.title ~= nil and p293.title ~= "" then
		local v3607, v3608 = proto.writeTag(buf, n195, 1, proto.wireTypes.lengthDelimited)

		buf, n195 = proto.writeString(v3607, v3608, p293.title)
	end

	if p293.subtitle ~= nil and p293.subtitle ~= "" then
		local v3609, v3610 = proto.writeTag(buf, n195, 2, proto.wireTypes.lengthDelimited)

		buf, n195 = proto.writeString(v3609, v3610, p293.subtitle)
	end

	if p293.moment_items ~= nil and #p293.moment_items > 0 then
		for _, v3612 in p293.moment_items do
			local v3613 = v3612:encode()
			local v3614, v3615 = proto.writeTag(buf, n195, 3, proto.wireTypes.lengthDelimited)

			buf, n195 = proto.writeBuffer(v3614, v3615, v3613, buffer.len(v3613))
		end
	end

	local buf107 = buffer.create(n195)

	buffer.copy(buf107, 0, buf, 0, n195)

	return buf107
end
function t494.decode(p294: buffer) -- line: 20353
	-- upvalues: t494 (copy), proto (copy), t1 (copy)
	local v3618 = t494.new()
	local n196 = 0

	while n196 < buffer.len(p294) do
		local v3620, v3621

		v3620, v3621, n196 = proto.readTag(p294, n196)

		if v3621 == proto.wireTypes.varint then
			local v3622

			v3622, n196 = proto.readVarInt(p294, n196)
		elseif v3621 == proto.wireTypes.lengthDelimited then
			if v3620 == 1 then
				local v3623

				v3623, n196 = proto.readBuffer(p294, n196)
				v3618.title = buffer.tostring(v3623)
			elseif v3620 == 2 then
				local v3624

				v3624, n196 = proto.readBuffer(p294, n196)
				v3618.subtitle = buffer.tostring(v3624)
			elseif v3620 == 3 then
				local v3625

				v3625, n196 = proto.readBuffer(p294, n196)
				table.insert(v3618.moment_items, t1.MomentsCarouselInputData_MomentItem.decode(v3625))
			else
				local v3626, v3627 = proto.readVarInt(p294, n196)

				n196 = v3627 + v3626
			end
		elseif v3621 == proto.wireTypes.i32 then
			local v3628

			v3628, n196 = proto.readFixed32(p294, n196)
		elseif v3621 == proto.wireTypes.i64 then
			local v3629

			v3629, n196 = proto.readFixed64(p294, n196)
		else
			error("Unsupported wire type: " .. v3621)
		end
	end

	return v3618
end
function t494.jsonEncode(p295) -- line: 20406
	local t496 = {}

	if p295.title ~= nil and p295.title ~= "" then
		t496.title = p295.title
	end

	if p295.subtitle ~= nil and p295.subtitle ~= "" then
		t496.subtitle = p295.subtitle
	end

	if p295.moment_items ~= nil and #p295.moment_items > 0 then
		local t497 = {}

		for _, v3634 in p295.moment_items do
			table.insert(t497, v3634:jsonEncode())
		end

		t496.momentItems = t497
	end

	return t496
end
function t494.jsonDecode(t498: {[any]: any}) -- line: 20428
	-- upvalues: t494 (copy), t1 (copy)
	local v3636 = t494.new()

	if t498.title ~= nil then
		v3636.title = t498.title
	end

	if t498.subtitle ~= nil then
		v3636.subtitle = t498.subtitle
	end

	if t498.moment_items ~= nil then
		local t499 = {}

		for _, v3639 in t498.moment_items do
			table.insert(t499, t1.MomentsCarouselInputData_MomentItem.jsonDecode(v3639))
		end

		v3636.moment_items = t499
	end

	if t498.momentItems ~= nil then
		local t500 = {}

		for _, v3642 in t498.momentItems do
			table.insert(t500, t1.MomentsCarouselInputData_MomentItem.jsonDecode(v3642))
		end

		v3636.moment_items = t500
	end

	return v3636
end

t494.descriptor = {
	name = "MomentsCarouselInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.MomentsCarouselInputData"
}
t1.MomentsCarouselInputData = t494
typeRegistry.default:register(t1.MomentsCarouselInputData)

local t501 = {}

t501.__index = t501

function t501.new(t502: {[any]: any}?) -- line: 20474
	-- upvalues: t501 (copy)
	return (setmetatable({
		moment_id = if t502 ~= nil and t502.moment_id ~= nil then t502.moment_id else "",
		video_asset_id = if t502 ~= nil and t502.video_asset_id ~= nil then t502.video_asset_id else "",
		target_universe_id = if t502 ~= nil and t502.target_universe_id ~= nil then t502.target_universe_id else "",
		target_place_id = if t502 ~= nil and t502.target_place_id ~= nil then t502.target_place_id else "",
		feed_item_id = if t502 ~= nil and t502.feed_item_id ~= nil then t502.feed_item_id else "",
		capture_universe_id = if t502 ~= nil and t502.capture_universe_id ~= nil then t502.capture_universe_id else ""
	}, t501))
end
function t501.encode(p296) -- line: 20489
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n197 = 0

	if p296.moment_id ~= nil and p296.moment_id ~= "" then
		local v3647, v3648 = proto.writeTag(buf, n197, 1, proto.wireTypes.lengthDelimited)

		buf, n197 = proto.writeString(v3647, v3648, p296.moment_id)
	end

	if p296.video_asset_id ~= nil and p296.video_asset_id ~= "" then
		local v3649, v3650 = proto.writeTag(buf, n197, 2, proto.wireTypes.lengthDelimited)

		buf, n197 = proto.writeString(v3649, v3650, p296.video_asset_id)
	end

	if p296.target_universe_id ~= nil and p296.target_universe_id ~= "" then
		local v3651, v3652 = proto.writeTag(buf, n197, 3, proto.wireTypes.lengthDelimited)

		buf, n197 = proto.writeString(v3651, v3652, p296.target_universe_id)
	end

	if p296.target_place_id ~= nil and p296.target_place_id ~= "" then
		local v3653, v3654 = proto.writeTag(buf, n197, 4, proto.wireTypes.lengthDelimited)

		buf, n197 = proto.writeString(v3653, v3654, p296.target_place_id)
	end

	if p296.feed_item_id ~= nil and p296.feed_item_id ~= "" then
		local v3655, v3656 = proto.writeTag(buf, n197, 5, proto.wireTypes.lengthDelimited)

		buf, n197 = proto.writeString(v3655, v3656, p296.feed_item_id)
	end

	if p296.capture_universe_id ~= nil and p296.capture_universe_id ~= "" then
		local v3657, v3658 = proto.writeTag(buf, n197, 6, proto.wireTypes.lengthDelimited)

		buf, n197 = proto.writeString(v3657, v3658, p296.capture_universe_id)
	end

	local buf108 = buffer.create(n197)

	buffer.copy(buf108, 0, buf, 0, n197)

	return buf108
end
function t501.decode(p297: buffer) -- line: 20528
	-- upvalues: t501 (copy), proto (copy)
	local v3661 = t501.new()
	local n198 = 0

	while n198 < buffer.len(p297) do
		local v3663, v3664

		v3663, v3664, n198 = proto.readTag(p297, n198)

		if v3664 == proto.wireTypes.varint then
			local v3665

			v3665, n198 = proto.readVarInt(p297, n198)
		elseif v3664 == proto.wireTypes.lengthDelimited then
			if v3663 == 1 then
				local v3666

				v3666, n198 = proto.readBuffer(p297, n198)
				v3661.moment_id = buffer.tostring(v3666)
			elseif v3663 == 2 then
				local v3667

				v3667, n198 = proto.readBuffer(p297, n198)
				v3661.video_asset_id = buffer.tostring(v3667)
			elseif v3663 == 3 then
				local v3668

				v3668, n198 = proto.readBuffer(p297, n198)
				v3661.target_universe_id = buffer.tostring(v3668)
			elseif v3663 == 4 then
				local v3669

				v3669, n198 = proto.readBuffer(p297, n198)
				v3661.target_place_id = buffer.tostring(v3669)
			elseif v3663 == 5 then
				local v3670

				v3670, n198 = proto.readBuffer(p297, n198)
				v3661.feed_item_id = buffer.tostring(v3670)
			elseif v3663 == 6 then
				local v3671

				v3671, n198 = proto.readBuffer(p297, n198)
				v3661.capture_universe_id = buffer.tostring(v3671)
			else
				local v3672, v3673 = proto.readVarInt(p297, n198)

				n198 = v3673 + v3672
			end
		elseif v3664 == proto.wireTypes.i32 then
			local v3674

			v3674, n198 = proto.readFixed32(p297, n198)
		elseif v3664 == proto.wireTypes.i64 then
			local v3675

			v3675, n198 = proto.readFixed64(p297, n198)
		else
			error("Unsupported wire type: " .. v3664)
		end
	end

	return v3661
end
function t501.jsonEncode(p298) -- line: 20596
	local t503 = {}

	if p298.moment_id ~= nil and p298.moment_id ~= "" then
		t503.momentId = p298.moment_id
	end

	if p298.video_asset_id ~= nil and p298.video_asset_id ~= "" then
		t503.videoAssetId = p298.video_asset_id
	end

	if p298.target_universe_id ~= nil and p298.target_universe_id ~= "" then
		t503.targetUniverseId = p298.target_universe_id
	end

	if p298.target_place_id ~= nil and p298.target_place_id ~= "" then
		t503.targetPlaceId = p298.target_place_id
	end

	if p298.feed_item_id ~= nil and p298.feed_item_id ~= "" then
		t503.feedItemId = p298.feed_item_id
	end

	if p298.capture_universe_id ~= nil and p298.capture_universe_id ~= "" then
		t503.captureUniverseId = p298.capture_universe_id
	end

	return t503
end
function t501.jsonDecode(t504: {[any]: any}) -- line: 20626
	-- upvalues: t501 (copy)
	local v3679 = t501.new()

	if t504.moment_id ~= nil then
		v3679.moment_id = t504.moment_id
	end

	if t504.momentId ~= nil then
		v3679.moment_id = t504.momentId
	end

	if t504.video_asset_id ~= nil then
		v3679.video_asset_id = t504.video_asset_id
	end

	if t504.videoAssetId ~= nil then
		v3679.video_asset_id = t504.videoAssetId
	end

	if t504.target_universe_id ~= nil then
		v3679.target_universe_id = t504.target_universe_id
	end

	if t504.targetUniverseId ~= nil then
		v3679.target_universe_id = t504.targetUniverseId
	end

	if t504.target_place_id ~= nil then
		v3679.target_place_id = t504.target_place_id
	end

	if t504.targetPlaceId ~= nil then
		v3679.target_place_id = t504.targetPlaceId
	end

	if t504.feed_item_id ~= nil then
		v3679.feed_item_id = t504.feed_item_id
	end

	if t504.feedItemId ~= nil then
		v3679.feed_item_id = t504.feedItemId
	end

	if t504.capture_universe_id ~= nil then
		v3679.capture_universe_id = t504.capture_universe_id
	end

	if t504.captureUniverseId ~= nil then
		v3679.capture_universe_id = t504.captureUniverseId
	end

	return v3679
end

t501.descriptor = {
	name = "MomentsCarouselInputData_MomentItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.MomentItem"
}
t1.MomentsCarouselInputData_MomentItem = t501
typeRegistry.default:register(t1.MomentsCarouselInputData_MomentItem)

local t505 = {}

t505.__index = t505

function t505.new(t506: {[any]: any}?) -- line: 20696
	-- upvalues: t505 (copy)
	return (setmetatable({
		title = if t506 ~= nil and t506.title ~= nil then t506.title else "",
		subtitle = if t506 ~= nil and t506.subtitle ~= nil then t506.subtitle else ""
	}, t505))
end
function t505.encode(p299) -- line: 20703
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n199 = 0

	if p299.title ~= nil and p299.title ~= "" then
		local v3684, v3685 = proto.writeTag(buf, n199, 1, proto.wireTypes.lengthDelimited)

		buf, n199 = proto.writeString(v3684, v3685, p299.title)
	end

	if p299.subtitle ~= nil and p299.subtitle ~= "" then
		local v3686, v3687 = proto.writeTag(buf, n199, 2, proto.wireTypes.lengthDelimited)

		buf, n199 = proto.writeString(v3686, v3687, p299.subtitle)
	end

	local buf109 = buffer.create(n199)

	buffer.copy(buf109, 0, buf, 0, n199)

	return buf109
end
function t505.decode(p300: buffer) -- line: 20722
	-- upvalues: t505 (copy), proto (copy)
	local v3690 = t505.new()
	local n200 = 0

	while n200 < buffer.len(p300) do
		local v3692, v3693

		v3692, v3693, n200 = proto.readTag(p300, n200)

		if v3693 == proto.wireTypes.varint then
			local v3694

			v3694, n200 = proto.readVarInt(p300, n200)
		elseif v3693 == proto.wireTypes.lengthDelimited then
			if v3692 == 1 then
				local v3695

				v3695, n200 = proto.readBuffer(p300, n200)
				v3690.title = buffer.tostring(v3695)
			elseif v3692 == 2 then
				local v3696

				v3696, n200 = proto.readBuffer(p300, n200)
				v3690.subtitle = buffer.tostring(v3696)
			else
				local v3697, v3698 = proto.readVarInt(p300, n200)

				n200 = v3698 + v3697
			end
		elseif v3693 == proto.wireTypes.i32 then
			local v3699

			v3699, n200 = proto.readFixed32(p300, n200)
		elseif v3693 == proto.wireTypes.i64 then
			local v3700

			v3700, n200 = proto.readFixed64(p300, n200)
		else
			error("Unsupported wire type: " .. v3693)
		end
	end

	return v3690
end
function t505.jsonEncode(p301) -- line: 20770
	local t507 = {}

	if p301.title ~= nil and p301.title ~= "" then
		t507.title = p301.title
	end

	if p301.subtitle ~= nil and p301.subtitle ~= "" then
		t507.subtitle = p301.subtitle
	end

	return t507
end
function t505.jsonDecode(t508: {[any]: any}) -- line: 20784
	-- upvalues: t505 (copy)
	local v3704 = t505.new()

	if t508.title ~= nil then
		v3704.title = t508.title
	end

	if t508.subtitle ~= nil then
		v3704.subtitle = t508.subtitle
	end

	return v3704
end

t505.descriptor = {
	name = "AttributionRowInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.AttributionRowInputData"
}
t1.AttributionRowInputData = t505
typeRegistry.default:register(t1.AttributionRowInputData)

local t509 = {}

t509.__index = t509

function t509.new(t510: {[any]: any}?) -- line: 20812
	-- upvalues: t509 (copy)
	return (setmetatable({
		image_asset_id = if t510 ~= nil and t510.image_asset_id ~= nil then t510.image_asset_id else ""
	}, t509))
end
function t509.encode(p302) -- line: 20818
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n201 = 0

	if p302.image_asset_id ~= nil and p302.image_asset_id ~= "" then
		local v3709, v3710 = proto.writeTag(buf, n201, 1, proto.wireTypes.lengthDelimited)

		buf, n201 = proto.writeString(v3709, v3710, p302.image_asset_id)
	end

	local buf110 = buffer.create(n201)

	buffer.copy(buf110, 0, buf, 0, n201)

	return buf110
end
function t509.decode(p303: buffer) -- line: 20832
	-- upvalues: t509 (copy), proto (copy)
	local v3713 = t509.new()
	local n202 = 0

	while n202 < buffer.len(p303) do
		local v3715, v3716

		v3715, v3716, n202 = proto.readTag(p303, n202)

		if v3716 == proto.wireTypes.varint then
			local v3717

			v3717, n202 = proto.readVarInt(p303, n202)
		elseif v3716 == proto.wireTypes.lengthDelimited then
			if v3715 == 1 then
				local v3718

				v3718, n202 = proto.readBuffer(p303, n202)
				v3713.image_asset_id = buffer.tostring(v3718)
			else
				local v3719, v3720 = proto.readVarInt(p303, n202)

				n202 = v3720 + v3719
			end
		elseif v3716 == proto.wireTypes.i32 then
			local v3721

			v3721, n202 = proto.readFixed32(p303, n202)
		elseif v3716 == proto.wireTypes.i64 then
			local v3722

			v3722, n202 = proto.readFixed64(p303, n202)
		else
			error("Unsupported wire type: " .. v3716)
		end
	end

	return v3713
end
function t509.jsonEncode(p304) -- line: 20875
	local t511 = {}

	if p304.image_asset_id ~= nil and p304.image_asset_id ~= "" then
		t511.imageAssetId = p304.image_asset_id
	end

	return t511
end
function t509.jsonDecode(t512: {[any]: any}) -- line: 20885
	-- upvalues: t509 (copy)
	local v3726 = t509.new()

	if t512.image_asset_id ~= nil then
		v3726.image_asset_id = t512.image_asset_id
	end

	if t512.imageAssetId ~= nil then
		v3726.image_asset_id = t512.imageAssetId
	end

	return v3726
end

t509.descriptor = {
	name = "ImageInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ImageInputData"
}
t1.ImageInputData = t509
typeRegistry.default:register(t1.ImageInputData)

local t513 = {}

t513.__index = t513

function t513.new(t514: {[any]: any}?) -- line: 20913
	-- upvalues: t513 (copy)
	return (setmetatable({
		text = if t514 ~= nil and t514.text ~= nil then t514.text else "",
		is_rendered_text = t514 ~= nil and (t514.is_rendered_text ~= nil and t514.is_rendered_text)
	}, t513))
end
function t513.encode(p305) -- line: 20920
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n203 = 0

	if p305.text ~= nil and p305.text ~= "" then
		local v3731, v3732 = proto.writeTag(buf, n203, 1, proto.wireTypes.lengthDelimited)

		buf, n203 = proto.writeString(v3731, v3732, p305.text)
	end

	if p305.is_rendered_text then
		local v3733, v3734 = proto.writeTag(buf, n203, 2, proto.wireTypes.varint)

		buf, n203 = proto.writeVarInt(v3733, v3734, not p305.is_rendered_text and 0 or 1)
	end

	local buf111 = buffer.create(n203)

	buffer.copy(buf111, 0, buf, 0, n203)

	return buf111
end
function t513.decode(p306: buffer) -- line: 20939
	-- upvalues: t513 (copy), proto (copy)
	local v3737 = t513.new()
	local n204 = 0

	while n204 < buffer.len(p306) do
		local v3739, v3740

		v3739, v3740, n204 = proto.readTag(p306, n204)

		if v3740 == proto.wireTypes.varint then
			if v3739 == 2 then
				local v3741

				v3741, n204 = proto.readVarInt(p306, n204)
				v3737.is_rendered_text = v3741 ~= 0
			else
				local v3742

				v3742, n204 = proto.readVarInt(p306, n204)
			end
		elseif v3740 == proto.wireTypes.lengthDelimited then
			if v3739 == 1 then
				local v3743

				v3743, n204 = proto.readBuffer(p306, n204)
				v3737.text = buffer.tostring(v3743)
			else
				local v3744, v3745 = proto.readVarInt(p306, n204)

				n204 = v3745 + v3744
			end
		elseif v3740 == proto.wireTypes.i32 then
			local v3746

			v3746, n204 = proto.readFixed32(p306, n204)
		elseif v3740 == proto.wireTypes.i64 then
			local v3747

			v3747, n204 = proto.readFixed64(p306, n204)
		else
			error("Unsupported wire type: " .. v3740)
		end
	end

	return v3737
end
function t513.jsonEncode(p307) -- line: 20987
	local t515 = {}

	if p307.text ~= nil and p307.text ~= "" then
		t515.text = p307.text
	end

	if p307.is_rendered_text then
		t515.isRenderedText = p307.is_rendered_text
	end

	return t515
end
function t513.jsonDecode(t516: {[any]: any}) -- line: 21001
	-- upvalues: t513 (copy)
	local v3751 = t513.new()

	if t516.text ~= nil then
		v3751.text = t516.text
	end

	if t516.is_rendered_text ~= nil then
		v3751.is_rendered_text = t516.is_rendered_text
	end

	if t516.isRenderedText ~= nil then
		v3751.is_rendered_text = t516.isRenderedText
	end

	return v3751
end

t513.descriptor = {
	name = "TextInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.TextInputData"
}
t1.TextInputData = t513
typeRegistry.default:register(t1.TextInputData)

local t517 = {}

t517.__index = t517

function t517.new(t518: {[any]: any}?) -- line: 21033
	-- upvalues: t517 (copy)
	return (setmetatable({
		entry_map = if t518 ~= nil and t518.entry_map ~= nil then t518.entry_map else {},
		entry_order = if t518 ~= nil and t518.entry_order ~= nil then t518.entry_order else {},
		entry_order_map = if t518 ~= nil and t518.entry_order_map ~= nil then t518.entry_order_map else {},
		content_pools = if t518 ~= nil and t518.content_pools ~= nil then t518.content_pools else {}
	}, t517))
end
function t517.encode(p308) -- line: 21042
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n205 = 0

	if p308.entry_map ~= nil and next(p308.entry_map) ~= nil then
		for v3756, v3757 in p308.entry_map do
			local buf112 = buffer.create(0)
			local v3759, v3760 = proto.writeTag(buf112, 0, 1, proto.wireTypes.lengthDelimited)
			local v3761, v3762 = proto.writeString(v3759, v3760, v3756)
			local v3763 = v3757:encode()
			local v3764, v3765 = proto.writeTag(v3761, v3762, 2, proto.wireTypes.lengthDelimited)
			local v3766, v3767 = proto.writeBuffer(v3764, v3765, v3763, buffer.len(v3763))
			local v3768, v3769 = proto.writeTag(buf, n205, 1, proto.wireTypes.lengthDelimited)

			buf, n205 = proto.writeBuffer(v3768, v3769, v3766, v3767)
		end
	end

	if p308.entry_order ~= nil and #p308.entry_order > 0 then
		for _, v3771 in p308.entry_order do
			local v3772, v3773 = proto.writeTag(buf, n205, 2, proto.wireTypes.lengthDelimited)

			buf, n205 = proto.writeString(v3772, v3773, v3771)
		end
	end

	if p308.entry_order_map ~= nil and next(p308.entry_order_map) ~= nil then
		for v3774, v3775 in p308.entry_order_map do
			local buf113 = buffer.create(0)
			local v3777, v3778 = proto.writeTag(buf113, 0, 1, proto.wireTypes.lengthDelimited)
			local v3779, v3780 = proto.writeString(v3777, v3778, v3774)
			local v3781 = v3775:encode()
			local v3782, v3783 = proto.writeTag(v3779, v3780, 2, proto.wireTypes.lengthDelimited)
			local v3784, v3785 = proto.writeBuffer(v3782, v3783, v3781, buffer.len(v3781))
			local v3786, v3787 = proto.writeTag(buf, n205, 3, proto.wireTypes.lengthDelimited)

			buf, n205 = proto.writeBuffer(v3786, v3787, v3784, v3785)
		end
	end

	if p308.content_pools ~= nil and next(p308.content_pools) ~= nil then
		for v3788, v3789 in p308.content_pools do
			local buf114 = buffer.create(0)
			local v3791, v3792 = proto.writeTag(buf114, 0, 1, proto.wireTypes.lengthDelimited)
			local v3793, v3794 = proto.writeString(v3791, v3792, v3788)
			local v3795 = v3789:encode()
			local v3796, v3797 = proto.writeTag(v3793, v3794, 2, proto.wireTypes.lengthDelimited)
			local v3798, v3799 = proto.writeBuffer(v3796, v3797, v3795, buffer.len(v3795))
			local v3800, v3801 = proto.writeTag(buf, n205, 4, proto.wireTypes.lengthDelimited)

			buf, n205 = proto.writeBuffer(v3800, v3801, v3798, v3799)
		end
	end

	local buf115 = buffer.create(n205)

	buffer.copy(buf115, 0, buf, 0, n205)

	return buf115
end
function t517.decode(p309: buffer) -- line: 21100
	-- upvalues: t517 (copy), proto (copy), t1 (copy)
	local v3804 = t517.new()
	local n206 = 0

	while n206 < buffer.len(p309) do
		local v3806, v3807

		v3806, v3807, n206 = proto.readTag(p309, n206)

		if v3807 == proto.wireTypes.varint then
			local v3808

			v3808, n206 = proto.readVarInt(p309, n206)
		elseif v3807 == proto.wireTypes.lengthDelimited then
			if v3806 == 1 then
				local v3809

				v3809, n206 = proto.readBuffer(p309, n206)

				local v3810 = t1.VerticalFeedInputData_EntryMapEntry.decode(v3809)
				local v3811 = t1.FeedEntry.new()

				v3804.entry_map[v3810.key or ""] = v3810.value or v3811
			elseif v3806 == 2 then
				local v3812

				v3812, n206 = proto.readBuffer(p309, n206)
				table.insert(v3804.entry_order, buffer.tostring(v3812))
			elseif v3806 == 3 then
				local v3813

				v3813, n206 = proto.readBuffer(p309, n206)

				local v3814 = t1.VerticalFeedInputData_EntryOrderMapEntry.decode(v3813)
				local v3815 = t1.EntryOrder.new()

				v3804.entry_order_map[v3814.key or ""] = v3814.value or v3815
			elseif v3806 == 4 then
				local v3816

				v3816, n206 = proto.readBuffer(p309, n206)

				local v3817 = t1.VerticalFeedInputData_ContentPoolsEntry.decode(v3816)
				local v3818 = t1.ContentPool.new()

				v3804.content_pools[v3817.key or ""] = v3817.value or v3818
			else
				local v3819, v3820 = proto.readVarInt(p309, n206)

				n206 = v3820 + v3819
			end
		elseif v3807 == proto.wireTypes.i32 then
			local v3821

			v3821, n206 = proto.readFixed32(p309, n206)
		elseif v3807 == proto.wireTypes.i64 then
			local v3822

			v3822, n206 = proto.readFixed64(p309, n206)
		else
			error("Unsupported wire type: " .. v3807)
		end
	end

	return v3804
end
function t517.jsonEncode(p310) -- line: 21179
	local t519 = {}

	if p310.entry_map ~= nil and next(p310.entry_map) ~= nil then
		local t520 = {}

		for v3826, v3827 in p310.entry_map do
			t520[v3826] = v3827:jsonEncode()
		end

		t519.entryMap = t520
	end

	if p310.entry_order ~= nil and #p310.entry_order > 0 then
		local t521 = {}

		for _, v3830 in p310.entry_order do
			table.insert(t521, v3830)
		end

		t519.entryOrder = t521
	end

	if p310.entry_order_map ~= nil and next(p310.entry_order_map) ~= nil then
		local t522 = {}

		for v3832, v3833 in p310.entry_order_map do
			t522[v3832] = v3833:jsonEncode()
		end

		t519.entryOrderMap = t522
	end

	if p310.content_pools ~= nil and next(p310.content_pools) ~= nil then
		local t523 = {}

		for v3835, v3836 in p310.content_pools do
			t523[v3835] = v3836:jsonEncode()
		end

		t519.contentPools = t523
	end

	return t519
end
function t517.jsonDecode(t524: {[any]: any}) -- line: 21217
	-- upvalues: t517 (copy), t1 (copy)
	local v3838 = t517.new()

	if t524.entry_map ~= nil then
		local t525 = {}

		for v3840, v3841 in t524.entry_map do
			t525[v3840] = t1.FeedEntry.jsonDecode(v3841)
		end

		v3838.entry_map = t525
	end

	if t524.entryMap ~= nil then
		local t526 = {}

		for v3843, v3844 in t524.entryMap do
			t526[v3843] = t1.FeedEntry.jsonDecode(v3844)
		end

		v3838.entry_map = t526
	end

	if t524.entry_order ~= nil then
		local t527 = {}

		for _, v3847 in t524.entry_order do
			table.insert(t527, v3847)
		end

		v3838.entry_order = t527
	end

	if t524.entryOrder ~= nil then
		local t528 = {}

		for _, v3850 in t524.entryOrder do
			table.insert(t528, v3850)
		end

		v3838.entry_order = t528
	end

	if t524.entry_order_map ~= nil then
		local t529 = {}

		for v3852, v3853 in t524.entry_order_map do
			t529[v3852] = t1.EntryOrder.jsonDecode(v3853)
		end

		v3838.entry_order_map = t529
	end

	if t524.entryOrderMap ~= nil then
		local t530 = {}

		for v3855, v3856 in t524.entryOrderMap do
			t530[v3855] = t1.EntryOrder.jsonDecode(v3856)
		end

		v3838.entry_order_map = t530
	end

	if t524.content_pools ~= nil then
		local t531 = {}

		for v3858, v3859 in t524.content_pools do
			t531[v3858] = t1.ContentPool.jsonDecode(v3859)
		end

		v3838.content_pools = t531
	end

	if t524.contentPools ~= nil then
		local t532 = {}

		for v3861, v3862 in t524.contentPools do
			t532[v3861] = t1.ContentPool.jsonDecode(v3862)
		end

		v3838.content_pools = t532
	end

	return v3838
end

t517.descriptor = {
	name = "VerticalFeedInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.VerticalFeedInputData"
}
t1.VerticalFeedInputData = t517
typeRegistry.default:register(t1.VerticalFeedInputData)

local t533 = {}

t533.__index = t533

function t533.new(t534: {[any]: any}?) -- line: 21309
	-- upvalues: t533 (copy)
	return (setmetatable({
		key = if t534 ~= nil and t534.key ~= nil then t534.key else "",
		value = if t534 ~= nil and t534.value ~= nil then t534.value else nil
	}, t533))
end
function t533.encode(p311) -- line: 21318
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n207 = 0

	if p311.key ~= nil and p311.key ~= "" then
		local v3867, v3868 = proto.writeTag(buf, n207, 1, proto.wireTypes.lengthDelimited)

		buf, n207 = proto.writeString(v3867, v3868, p311.key)
	end

	if p311.value ~= nil then
		local v3869 = p311.value:encode()
		local v3870, v3871 = proto.writeTag(buf, n207, 2, proto.wireTypes.lengthDelimited)

		buf, n207 = proto.writeBuffer(v3870, v3871, v3869, buffer.len(v3869))
	end

	local buf116 = buffer.create(n207)

	buffer.copy(buf116, 0, buf, 0, n207)

	return buf116
end
function t533.decode(p312: buffer) -- line: 21338
	-- upvalues: t533 (copy), proto (copy), t1 (copy)
	local v3874 = t533.new()
	local n208 = 0

	while n208 < buffer.len(p312) do
		local v3876, v3877

		v3876, v3877, n208 = proto.readTag(p312, n208)

		if v3877 == proto.wireTypes.varint then
			local v3878

			v3878, n208 = proto.readVarInt(p312, n208)
		elseif v3877 == proto.wireTypes.lengthDelimited then
			if v3876 == 1 then
				local v3879

				v3879, n208 = proto.readBuffer(p312, n208)
				v3874.key = buffer.tostring(v3879)
			elseif v3876 == 2 then
				local v3880

				v3880, n208 = proto.readBuffer(p312, n208)
				v3874.value = t1.FeedEntry.decode(v3880)
			else
				local v3881, v3882 = proto.readVarInt(p312, n208)

				n208 = v3882 + v3881
			end
		elseif v3877 == proto.wireTypes.i32 then
			local v3883

			v3883, n208 = proto.readFixed32(p312, n208)
		elseif v3877 == proto.wireTypes.i64 then
			local v3884

			v3884, n208 = proto.readFixed64(p312, n208)
		else
			error("Unsupported wire type: " .. v3877)
		end
	end

	return v3874
end
function t533.jsonEncode(p313) -- line: 21386
	local t535 = {}

	if p313.key ~= nil and p313.key ~= "" then
		t535.key = p313.key
	end

	if p313.value ~= nil then
		t535.value = p313.value:jsonEncode()
	end

	return t535
end
function t533.jsonDecode(t536: {[any]: any}) -- line: 21400
	-- upvalues: t533 (copy), t1 (copy)
	local v3888 = t533.new()

	if t536.key ~= nil then
		v3888.key = t536.key
	end

	if t536.value ~= nil then
		v3888.value = t1.FeedEntry.jsonDecode(t536.value)
	end

	return v3888
end

t533.descriptor = {
	name = "VerticalFeedInputData_EntryMapEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryMapEntry"
}
t1.VerticalFeedInputData_EntryMapEntry = t533
typeRegistry.default:register(t1.VerticalFeedInputData_EntryMapEntry)

local t537 = {}

t537.__index = t537

function t537.new(t538: {[any]: any}?) -- line: 21430
	-- upvalues: t537 (copy)
	return (setmetatable({
		key = if t538 ~= nil and t538.key ~= nil then t538.key else "",
		value = if t538 ~= nil and t538.value ~= nil then t538.value else nil
	}, t537))
end
function t537.encode(p314) -- line: 21439
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n209 = 0

	if p314.key ~= nil and p314.key ~= "" then
		local v3893, v3894 = proto.writeTag(buf, n209, 1, proto.wireTypes.lengthDelimited)

		buf, n209 = proto.writeString(v3893, v3894, p314.key)
	end

	if p314.value ~= nil then
		local v3895 = p314.value:encode()
		local v3896, v3897 = proto.writeTag(buf, n209, 2, proto.wireTypes.lengthDelimited)

		buf, n209 = proto.writeBuffer(v3896, v3897, v3895, buffer.len(v3895))
	end

	local buf117 = buffer.create(n209)

	buffer.copy(buf117, 0, buf, 0, n209)

	return buf117
end
function t537.decode(p315: buffer) -- line: 21461
	-- upvalues: t537 (copy), proto (copy), t1 (copy)
	local v3900 = t537.new()
	local n210 = 0

	while n210 < buffer.len(p315) do
		local v3902, v3903

		v3902, v3903, n210 = proto.readTag(p315, n210)

		if v3903 == proto.wireTypes.varint then
			local v3904

			v3904, n210 = proto.readVarInt(p315, n210)
		elseif v3903 == proto.wireTypes.lengthDelimited then
			if v3902 == 1 then
				local v3905

				v3905, n210 = proto.readBuffer(p315, n210)
				v3900.key = buffer.tostring(v3905)
			elseif v3902 == 2 then
				local v3906

				v3906, n210 = proto.readBuffer(p315, n210)
				v3900.value = t1.EntryOrder.decode(v3906)
			else
				local v3907, v3908 = proto.readVarInt(p315, n210)

				n210 = v3908 + v3907
			end
		elseif v3903 == proto.wireTypes.i32 then
			local v3909

			v3909, n210 = proto.readFixed32(p315, n210)
		elseif v3903 == proto.wireTypes.i64 then
			local v3910

			v3910, n210 = proto.readFixed64(p315, n210)
		else
			error("Unsupported wire type: " .. v3903)
		end
	end

	return v3900
end
function t537.jsonEncode(p316) -- line: 21511
	local t539 = {}

	if p316.key ~= nil and p316.key ~= "" then
		t539.key = p316.key
	end

	if p316.value ~= nil then
		t539.value = p316.value:jsonEncode()
	end

	return t539
end
function t537.jsonDecode(t540: {[any]: any}) -- line: 21527
	-- upvalues: t537 (copy), t1 (copy)
	local v3914 = t537.new()

	if t540.key ~= nil then
		v3914.key = t540.key
	end

	if t540.value ~= nil then
		v3914.value = t1.EntryOrder.jsonDecode(t540.value)
	end

	return v3914
end

t537.descriptor = {
	name = "VerticalFeedInputData_EntryOrderMapEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryOrderMapEntry"
}
t1.VerticalFeedInputData_EntryOrderMapEntry = t537
typeRegistry.default:register(t1.VerticalFeedInputData_EntryOrderMapEntry)

local t541 = {}

t541.__index = t541

function t541.new(t542: {[any]: any}?) -- line: 21557
	-- upvalues: t541 (copy)
	return (setmetatable({
		key = if t542 ~= nil and t542.key ~= nil then t542.key else "",
		value = if t542 ~= nil and t542.value ~= nil then t542.value else nil
	}, t541))
end
function t541.encode(p317) -- line: 21566
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n211 = 0

	if p317.key ~= nil and p317.key ~= "" then
		local v3919, v3920 = proto.writeTag(buf, n211, 1, proto.wireTypes.lengthDelimited)

		buf, n211 = proto.writeString(v3919, v3920, p317.key)
	end

	if p317.value ~= nil then
		local v3921 = p317.value:encode()
		local v3922, v3923 = proto.writeTag(buf, n211, 2, proto.wireTypes.lengthDelimited)

		buf, n211 = proto.writeBuffer(v3922, v3923, v3921, buffer.len(v3921))
	end

	local buf118 = buffer.create(n211)

	buffer.copy(buf118, 0, buf, 0, n211)

	return buf118
end
function t541.decode(p318: buffer) -- line: 21586
	-- upvalues: t541 (copy), proto (copy), t1 (copy)
	local v3926 = t541.new()
	local n212 = 0

	while n212 < buffer.len(p318) do
		local v3928, v3929

		v3928, v3929, n212 = proto.readTag(p318, n212)

		if v3929 == proto.wireTypes.varint then
			local v3930

			v3930, n212 = proto.readVarInt(p318, n212)
		elseif v3929 == proto.wireTypes.lengthDelimited then
			if v3928 == 1 then
				local v3931

				v3931, n212 = proto.readBuffer(p318, n212)
				v3926.key = buffer.tostring(v3931)
			elseif v3928 == 2 then
				local v3932

				v3932, n212 = proto.readBuffer(p318, n212)
				v3926.value = t1.ContentPool.decode(v3932)
			else
				local v3933, v3934 = proto.readVarInt(p318, n212)

				n212 = v3934 + v3933
			end
		elseif v3929 == proto.wireTypes.i32 then
			local v3935

			v3935, n212 = proto.readFixed32(p318, n212)
		elseif v3929 == proto.wireTypes.i64 then
			local v3936

			v3936, n212 = proto.readFixed64(p318, n212)
		else
			error("Unsupported wire type: " .. v3929)
		end
	end

	return v3926
end
function t541.jsonEncode(p319) -- line: 21634
	local t543 = {}

	if p319.key ~= nil and p319.key ~= "" then
		t543.key = p319.key
	end

	if p319.value ~= nil then
		t543.value = p319.value:jsonEncode()
	end

	return t543
end
function t541.jsonDecode(t544: {[any]: any}) -- line: 21648
	-- upvalues: t541 (copy), t1 (copy)
	local v3940 = t541.new()

	if t544.key ~= nil then
		v3940.key = t544.key
	end

	if t544.value ~= nil then
		v3940.value = t1.ContentPool.jsonDecode(t544.value)
	end

	return v3940
end

t541.descriptor = {
	name = "VerticalFeedInputData_ContentPoolsEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.ContentPoolsEntry"
}
t1.VerticalFeedInputData_ContentPoolsEntry = t541
typeRegistry.default:register(t1.VerticalFeedInputData_ContentPoolsEntry)

local t545 = {}

t545.__index = t545

function t545.new(t546: {[any]: any}?) -- line: 21678
	-- upvalues: t545 (copy)
	return (setmetatable({
		foreground_header_entry = if t546 ~= nil and t546.foreground_header_entry ~= nil then t546.foreground_header_entry else nil,
		background_header_entry = if t546 ~= nil and t546.background_header_entry ~= nil then t546.background_header_entry else nil
	}, t545))
end
function t545.encode(p320) -- line: 21689
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n213 = 0

	if p320.foreground_header_entry ~= nil then
		local v3945 = p320.foreground_header_entry:encode()
		local v3946, v3947 = proto.writeTag(buf, n213, 1, proto.wireTypes.lengthDelimited)

		buf, n213 = proto.writeBuffer(v3946, v3947, v3945, buffer.len(v3945))
	end

	if p320.background_header_entry ~= nil then
		local v3948 = p320.background_header_entry:encode()
		local v3949, v3950 = proto.writeTag(buf, n213, 2, proto.wireTypes.lengthDelimited)

		buf, n213 = proto.writeBuffer(v3949, v3950, v3948, buffer.len(v3948))
	end

	local buf119 = buffer.create(n213)

	buffer.copy(buf119, 0, buf, 0, n213)

	return buf119
end
function t545.decode(p321: buffer) -- line: 21710
	-- upvalues: t545 (copy), proto (copy), t1 (copy)
	local v3953 = t545.new()
	local n214 = 0

	while n214 < buffer.len(p321) do
		local v3955, v3956

		v3955, v3956, n214 = proto.readTag(p321, n214)

		if v3956 == proto.wireTypes.varint then
			local v3957

			v3957, n214 = proto.readVarInt(p321, n214)
		elseif v3956 == proto.wireTypes.lengthDelimited then
			if v3955 == 1 then
				local v3958

				v3958, n214 = proto.readBuffer(p321, n214)
				v3953.foreground_header_entry = t1.ForegroundHeaderEntry.decode(v3958)
			elseif v3955 == 2 then
				local v3959

				v3959, n214 = proto.readBuffer(p321, n214)
				v3953.background_header_entry = t1.BackgroundHeaderEntry.decode(v3959)
			else
				local v3960, v3961 = proto.readVarInt(p321, n214)

				n214 = v3961 + v3960
			end
		elseif v3956 == proto.wireTypes.i32 then
			local v3962

			v3962, n214 = proto.readFixed32(p321, n214)
		elseif v3956 == proto.wireTypes.i64 then
			local v3963

			v3963, n214 = proto.readFixed64(p321, n214)
		else
			error("Unsupported wire type: " .. v3956)
		end
	end

	return v3953
end
function t545.jsonEncode(p322) -- line: 21758
	local t547 = {}

	if p322.foreground_header_entry ~= nil then
		t547.foregroundHeaderEntry = p322.foreground_header_entry:jsonEncode()
	end

	if p322.background_header_entry ~= nil then
		t547.backgroundHeaderEntry = p322.background_header_entry:jsonEncode()
	end

	return t547
end
function t545.jsonDecode(t548: {[any]: any}) -- line: 21772
	-- upvalues: t545 (copy), t1 (copy)
	local v3967 = t545.new()

	if t548.foreground_header_entry ~= nil then
		v3967.foreground_header_entry = t1.ForegroundHeaderEntry.jsonDecode(t548.foreground_header_entry)
	end

	if t548.foregroundHeaderEntry ~= nil then
		v3967.foreground_header_entry = t1.ForegroundHeaderEntry.jsonDecode(t548.foregroundHeaderEntry)
	end

	if t548.background_header_entry ~= nil then
		v3967.background_header_entry = t1.BackgroundHeaderEntry.jsonDecode(t548.background_header_entry)
	end

	if t548.backgroundHeaderEntry ~= nil then
		v3967.background_header_entry = t1.BackgroundHeaderEntry.jsonDecode(t548.backgroundHeaderEntry)
	end

	return v3967
end

t545.descriptor = {
	name = "PageHeaderInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.PageHeaderInputData"
}
t1.PageHeaderInputData = t545
typeRegistry.default:register(t1.PageHeaderInputData)

local t549 = {}

t549.__index = t549

function t549.new(t550: {[any]: any}?) -- line: 21808
	-- upvalues: t549 (copy)
	return (setmetatable({
		selected_option = if t550 ~= nil and t550.selected_option ~= nil then t550.selected_option else "",
		sort_id = if t550 ~= nil and t550.sort_id ~= nil then t550.sort_id else "",
		options = if t550 ~= nil and t550.options ~= nil then t550.options else {},
		experience_carousel = if t550 ~= nil and t550.experience_carousel ~= nil then t550.experience_carousel else nil,
		feed_item_key = if t550 ~= nil and t550.feed_item_key ~= nil then t550.feed_item_key else ""
	}, t549))
end
function t549.encode(p323) -- line: 21822
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n215 = 0

	if p323.selected_option ~= nil and p323.selected_option ~= "" then
		local v3972, v3973 = proto.writeTag(buf, n215, 1, proto.wireTypes.lengthDelimited)

		buf, n215 = proto.writeString(v3972, v3973, p323.selected_option)
	end

	if p323.sort_id ~= nil and p323.sort_id ~= "" then
		local v3974, v3975 = proto.writeTag(buf, n215, 2, proto.wireTypes.lengthDelimited)

		buf, n215 = proto.writeString(v3974, v3975, p323.sort_id)
	end

	if p323.options ~= nil and #p323.options > 0 then
		for _, v3977 in p323.options do
			local v3978 = v3977:encode()
			local v3979, v3980 = proto.writeTag(buf, n215, 3, proto.wireTypes.lengthDelimited)

			buf, n215 = proto.writeBuffer(v3979, v3980, v3978, buffer.len(v3978))
		end
	end

	if p323.experience_carousel ~= nil then
		local v3981 = p323.experience_carousel:encode()
		local v3982, v3983 = proto.writeTag(buf, n215, 4, proto.wireTypes.lengthDelimited)

		buf, n215 = proto.writeBuffer(v3982, v3983, v3981, buffer.len(v3981))
	end

	if p323.feed_item_key ~= nil and p323.feed_item_key ~= "" then
		local v3984, v3985 = proto.writeTag(buf, n215, 5, proto.wireTypes.lengthDelimited)

		buf, n215 = proto.writeString(v3984, v3985, p323.feed_item_key)
	end

	local buf120 = buffer.create(n215)

	buffer.copy(buf120, 0, buf, 0, n215)

	return buf120
end
function t549.decode(p324: buffer) -- line: 21860
	-- upvalues: t549 (copy), proto (copy), t1 (copy)
	local v3988 = t549.new()
	local n216 = 0

	while n216 < buffer.len(p324) do
		local v3990, v3991

		v3990, v3991, n216 = proto.readTag(p324, n216)

		if v3991 == proto.wireTypes.varint then
			local v3992

			v3992, n216 = proto.readVarInt(p324, n216)
		elseif v3991 == proto.wireTypes.lengthDelimited then
			if v3990 == 1 then
				local v3993

				v3993, n216 = proto.readBuffer(p324, n216)
				v3988.selected_option = buffer.tostring(v3993)
			elseif v3990 == 2 then
				local v3994

				v3994, n216 = proto.readBuffer(p324, n216)
				v3988.sort_id = buffer.tostring(v3994)
			elseif v3990 == 3 then
				local v3995

				v3995, n216 = proto.readBuffer(p324, n216)
				table.insert(v3988.options, t1.SelectorOption.decode(v3995))
			elseif v3990 == 4 then
				local v3996

				v3996, n216 = proto.readBuffer(p324, n216)
				v3988.experience_carousel = t1.ExperienceCarouselInputData.decode(v3996)
			elseif v3990 == 5 then
				local v3997

				v3997, n216 = proto.readBuffer(p324, n216)
				v3988.feed_item_key = buffer.tostring(v3997)
			else
				local v3998, v3999 = proto.readVarInt(p324, n216)

				n216 = v3999 + v3998
			end
		elseif v3991 == proto.wireTypes.i32 then
			local v4000

			v4000, n216 = proto.readFixed32(p324, n216)
		elseif v3991 == proto.wireTypes.i64 then
			local v4001

			v4001, n216 = proto.readFixed64(p324, n216)
		else
			error("Unsupported wire type: " .. v3991)
		end
	end

	return v3988
end
function t549.jsonEncode(p325) -- line: 21923
	local t551 = {}

	if p325.selected_option ~= nil and p325.selected_option ~= "" then
		t551.selectedOption = p325.selected_option
	end

	if p325.sort_id ~= nil and p325.sort_id ~= "" then
		t551.sortId = p325.sort_id
	end

	if p325.options ~= nil and #p325.options > 0 then
		local t552 = {}

		for _, v4006 in p325.options do
			table.insert(t552, v4006:jsonEncode())
		end

		t551.options = t552
	end

	if p325.experience_carousel ~= nil then
		t551.experienceCarousel = p325.experience_carousel:jsonEncode()
	end

	if p325.feed_item_key ~= nil and p325.feed_item_key ~= "" then
		t551.feedItemKey = p325.feed_item_key
	end

	return t551
end
function t549.jsonDecode(t553: {[any]: any}) -- line: 21953
	-- upvalues: t549 (copy), t1 (copy)
	local v4008 = t549.new()

	if t553.selected_option ~= nil then
		v4008.selected_option = t553.selected_option
	end

	if t553.selectedOption ~= nil then
		v4008.selected_option = t553.selectedOption
	end

	if t553.sort_id ~= nil then
		v4008.sort_id = t553.sort_id
	end

	if t553.sortId ~= nil then
		v4008.sort_id = t553.sortId
	end

	if t553.options ~= nil then
		local t554 = {}

		for _, v4011 in t553.options do
			table.insert(t554, t1.SelectorOption.jsonDecode(v4011))
		end

		v4008.options = t554
	end

	if t553.experience_carousel ~= nil then
		v4008.experience_carousel = t1.ExperienceCarouselInputData.jsonDecode(t553.experience_carousel)
	end

	if t553.experienceCarousel ~= nil then
		v4008.experience_carousel = t1.ExperienceCarouselInputData.jsonDecode(t553.experienceCarousel)
	end

	if t553.feed_item_key ~= nil then
		v4008.feed_item_key = t553.feed_item_key
	end

	if t553.feedItemKey ~= nil then
		v4008.feed_item_key = t553.feedItemKey
	end

	return v4008
end

t549.descriptor = {
	name = "OptionSelectorCarouselInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.OptionSelectorCarouselInputData"
}
t1.OptionSelectorCarouselInputData = t549
typeRegistry.default:register(t1.OptionSelectorCarouselInputData)

local t555 = {}

t555.__index = t555

function t555.new(t556: {[any]: any}?) -- line: 22014
	-- upvalues: t555 (copy)
	return (setmetatable({
		id = if t556 ~= nil and t556.id ~= nil then t556.id else "",
		display_name = if t556 ~= nil and t556.display_name ~= nil then t556.display_name else "",
		is_selected = t556 ~= nil and (t556.is_selected ~= nil and t556.is_selected)
	}, t555))
end
function t555.encode(p326) -- line: 22022
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n217 = 0

	if p326.id ~= nil and p326.id ~= "" then
		local v4016, v4017 = proto.writeTag(buf, n217, 1, proto.wireTypes.lengthDelimited)

		buf, n217 = proto.writeString(v4016, v4017, p326.id)
	end

	if p326.display_name ~= nil and p326.display_name ~= "" then
		local v4018, v4019 = proto.writeTag(buf, n217, 2, proto.wireTypes.lengthDelimited)

		buf, n217 = proto.writeString(v4018, v4019, p326.display_name)
	end

	if p326.is_selected then
		local v4020, v4021 = proto.writeTag(buf, n217, 3, proto.wireTypes.varint)

		buf, n217 = proto.writeVarInt(v4020, v4021, not p326.is_selected and 0 or 1)
	end

	local buf121 = buffer.create(n217)

	buffer.copy(buf121, 0, buf, 0, n217)

	return buf121
end
function t555.decode(p327: buffer) -- line: 22046
	-- upvalues: t555 (copy), proto (copy)
	local v4024 = t555.new()
	local n218 = 0

	while n218 < buffer.len(p327) do
		local v4026, v4027

		v4026, v4027, n218 = proto.readTag(p327, n218)

		if v4027 == proto.wireTypes.varint then
			if v4026 == 3 then
				local v4028

				v4028, n218 = proto.readVarInt(p327, n218)
				v4024.is_selected = v4028 ~= 0
			else
				local v4029

				v4029, n218 = proto.readVarInt(p327, n218)
			end
		elseif v4027 == proto.wireTypes.lengthDelimited then
			if v4026 == 1 then
				local v4030

				v4030, n218 = proto.readBuffer(p327, n218)
				v4024.id = buffer.tostring(v4030)
			elseif v4026 == 2 then
				local v4031

				v4031, n218 = proto.readBuffer(p327, n218)
				v4024.display_name = buffer.tostring(v4031)
			else
				local v4032, v4033 = proto.readVarInt(p327, n218)

				n218 = v4033 + v4032
			end
		elseif v4027 == proto.wireTypes.i32 then
			local v4034

			v4034, n218 = proto.readFixed32(p327, n218)
		elseif v4027 == proto.wireTypes.i64 then
			local v4035

			v4035, n218 = proto.readFixed64(p327, n218)
		else
			error("Unsupported wire type: " .. v4027)
		end
	end

	return v4024
end
function t555.jsonEncode(p328) -- line: 22099
	local t557 = {}

	if p328.id ~= nil and p328.id ~= "" then
		t557.id = p328.id
	end

	if p328.display_name ~= nil and p328.display_name ~= "" then
		t557.displayName = p328.display_name
	end

	if p328.is_selected then
		t557.isSelected = p328.is_selected
	end

	return t557
end
function t555.jsonDecode(t558: {[any]: any}) -- line: 22117
	-- upvalues: t555 (copy)
	local v4039 = t555.new()

	if t558.id ~= nil then
		v4039.id = t558.id
	end

	if t558.display_name ~= nil then
		v4039.display_name = t558.display_name
	end

	if t558.displayName ~= nil then
		v4039.display_name = t558.displayName
	end

	if t558.is_selected ~= nil then
		v4039.is_selected = t558.is_selected
	end

	if t558.isSelected ~= nil then
		v4039.is_selected = t558.isSelected
	end

	return v4039
end

t555.descriptor = {
	name = "SelectorOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.SelectorOption"
}
t1.SelectorOption = t555
typeRegistry.default:register(t1.SelectorOption)

local t559 = {}

t559.__index = t559

function t559.new(t560: {[any]: any}?) -- line: 22157
	-- upvalues: t559 (copy)
	return (setmetatable({
		layout = if t560 ~= nil and t560.layout ~= nil then t560.layout else nil,
		kind = if t560 ~= nil and t560.kind ~= nil then t560.kind else nil
	}, t559))
end
function t559.encode(p329) -- line: 22164
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n219 = 0

	if p329.layout ~= nil then
		local v4044 = p329.layout:encode()
		local v4045, v4046 = proto.writeTag(buf, n219, 1, proto.wireTypes.lengthDelimited)

		buf, n219 = proto.writeBuffer(v4045, v4046, v4044, buffer.len(v4044))
	end

	if p329.kind ~= nil and p329.kind.type == "universe" then
		local v4047 = p329.kind.value:encode()
		local v4048, v4049 = proto.writeTag(buf, n219, 2, proto.wireTypes.lengthDelimited)

		buf, n219 = proto.writeBuffer(v4048, v4049, v4047, buffer.len(v4047))
	end

	local buf122 = buffer.create(n219)

	buffer.copy(buf122, 0, buf, 0, n219)

	return buf122
end
function t559.decode(p330: buffer) -- line: 22187
	-- upvalues: t559 (copy), proto (copy), t1 (copy)
	local v4052 = t559.new()
	local n220 = 0

	while n220 < buffer.len(p330) do
		local v4054, v4055

		v4054, v4055, n220 = proto.readTag(p330, n220)

		if v4055 == proto.wireTypes.varint then
			local v4056

			v4056, n220 = proto.readVarInt(p330, n220)
		elseif v4055 == proto.wireTypes.lengthDelimited then
			if v4054 == 1 then
				local v4057

				v4057, n220 = proto.readBuffer(p330, n220)
				v4052.layout = t1.ItemLayout.decode(v4057)
			elseif v4054 == 2 then
				local v4058

				v4058, n220 = proto.readBuffer(p330, n220)
				v4052.kind = {
					type = "universe",
					value = t1.ExperienceCarouselInputData_UniverseItem.decode(v4058)
				}
			else
				local v4059, v4060 = proto.readVarInt(p330, n220)

				n220 = v4060 + v4059
			end
		elseif v4055 == proto.wireTypes.i32 then
			local v4061

			v4061, n220 = proto.readFixed32(p330, n220)
		elseif v4055 == proto.wireTypes.i64 then
			local v4062

			v4062, n220 = proto.readFixed64(p330, n220)
		else
			error("Unsupported wire type: " .. v4055)
		end
	end

	return v4052
end
function t559.jsonEncode(p331) -- line: 22236
	local t561 = {}

	if p331.layout ~= nil then
		t561.layout = p331.layout:jsonEncode()
	end

	if p331.kind ~= nil and p331.kind.type == "universe" then
		t561.universe = p331.kind.value:jsonEncode()
	end

	return t561
end
function t559.jsonDecode(t562: {[any]: any}) -- line: 22252
	-- upvalues: t559 (copy), t1 (copy)
	local v4066 = t559.new()

	if t562.layout ~= nil then
		v4066.layout = t1.ItemLayout.jsonDecode(t562.layout)
	end

	if t562.universe ~= nil then
		v4066.kind = {
			type = "universe",
			value = t1.ExperienceCarouselInputData_UniverseItem.jsonDecode(t562.universe)
		}
	end

	return v4066
end

t559.descriptor = {
	name = "ItemWithLayout",
	fullName = "roblox.apppageplatform.shared.v1beta1.ItemWithLayout"
}
t1.ItemWithLayout = t559
typeRegistry.default:register(t1.ItemWithLayout)

local t563 = {}

t563.__index = t563

function t563.new(t564: {[any]: any}?) -- line: 22283
	-- upvalues: t563 (copy)
	return (setmetatable({
		items = if t564 ~= nil and t564.items ~= nil then t564.items else {},
		collection_item_size = if t564 ~= nil and t564.collection_item_size ~= nil then t564.collection_item_size else nil
	}, t563))
end
function t563.encode(p332) -- line: 22292
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n221 = 0

	if p332.items ~= nil and #p332.items > 0 then
		for _, v4072 in p332.items do
			local v4073 = v4072:encode()
			local v4074, v4075 = proto.writeTag(buf, n221, 1, proto.wireTypes.lengthDelimited)

			buf, n221 = proto.writeBuffer(v4074, v4075, v4073, buffer.len(v4073))
		end
	end

	if p332.collection_item_size ~= nil then
		local v4076, v4077 = proto.writeTag(buf, n221, 2, proto.wireTypes.lengthDelimited)

		buf, n221 = proto.writeString(v4076, v4077, p332.collection_item_size)
	end

	local buf123 = buffer.create(n221)

	buffer.copy(buf123, 0, buf, 0, n221)

	return buf123
end
function t563.decode(p333: buffer) -- line: 22314
	-- upvalues: t563 (copy), proto (copy), t1 (copy)
	local v4080 = t563.new()
	local n222 = 0

	while n222 < buffer.len(p333) do
		local v4082, v4083

		v4082, v4083, n222 = proto.readTag(p333, n222)

		if v4083 == proto.wireTypes.varint then
			local v4084

			v4084, n222 = proto.readVarInt(p333, n222)
		elseif v4083 == proto.wireTypes.lengthDelimited then
			if v4082 == 1 then
				local v4085

				v4085, n222 = proto.readBuffer(p333, n222)
				table.insert(v4080.items, t1.ItemWithLayout.decode(v4085))
			elseif v4082 == 2 then
				local v4086

				v4086, n222 = proto.readBuffer(p333, n222)
				v4080.collection_item_size = buffer.tostring(v4086)
			else
				local v4087, v4088 = proto.readVarInt(p333, n222)

				n222 = v4088 + v4087
			end
		elseif v4083 == proto.wireTypes.i32 then
			local v4089

			v4089, n222 = proto.readFixed32(p333, n222)
		elseif v4083 == proto.wireTypes.i64 then
			local v4090

			v4090, n222 = proto.readFixed64(p333, n222)
		else
			error("Unsupported wire type: " .. v4083)
		end
	end

	return v4080
end
function t563.jsonEncode(p334) -- line: 22362
	local t565 = {}

	if p334.items ~= nil and #p334.items > 0 then
		local t566 = {}

		for _, v4095 in p334.items do
			table.insert(t566, v4095:jsonEncode())
		end

		t565.items = t566
	end

	if p334.collection_item_size ~= nil then
		t565.collectionItemSize = p334.collection_item_size
	end

	return t565
end
function t563.jsonDecode(t567: {[any]: any}) -- line: 22380
	-- upvalues: t563 (copy), t1 (copy)
	local v4097 = t563.new()

	if t567.items ~= nil then
		local t568 = {}

		for _, v4100 in t567.items do
			table.insert(t568, t1.ItemWithLayout.jsonDecode(v4100))
		end

		v4097.items = t568
	end

	if t567.collection_item_size ~= nil then
		v4097.collection_item_size = t567.collection_item_size
	end

	if t567.collectionItemSize ~= nil then
		v4097.collection_item_size = t567.collectionItemSize
	end

	return v4097
end

t563.descriptor = {
	name = "ContentPool",
	fullName = "roblox.apppageplatform.shared.v1beta1.ContentPool"
}
t1.ContentPool = t563
typeRegistry.default:register(t1.ContentPool)

local t569 = {}

t569.__index = t569

function t569.new(t570: {[any]: any}?) -- line: 22417
	-- upvalues: t569 (copy)
	return (setmetatable({
		col_span = if t570 ~= nil and t570.col_span ~= nil then t570.col_span else 0,
		row_span = if t570 ~= nil and t570.row_span ~= nil then t570.row_span else 0,
		alignment_type = if t570 ~= nil and t570.alignment_type ~= nil then t570.alignment_type else "",
		min_row_padding = if t570 ~= nil and t570.min_row_padding ~= nil then t570.min_row_padding else 0
	}, t569))
end
function t569.encode(p335) -- line: 22426
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n223 = 0

	if p335.col_span ~= nil and p335.col_span ~= 0 then
		local v4105, v4106 = proto.writeTag(buf, n223, 1, proto.wireTypes.varint)

		buf, n223 = proto.writeVarInt(v4105, v4106, p335.col_span)
	end

	if p335.row_span ~= nil and p335.row_span ~= 0 then
		local v4107, v4108 = proto.writeTag(buf, n223, 2, proto.wireTypes.varint)

		buf, n223 = proto.writeVarInt(v4107, v4108, p335.row_span)
	end

	if p335.alignment_type ~= nil and p335.alignment_type ~= "" then
		local v4109, v4110 = proto.writeTag(buf, n223, 3, proto.wireTypes.lengthDelimited)

		buf, n223 = proto.writeString(v4109, v4110, p335.alignment_type)
	end

	if p335.min_row_padding ~= nil and p335.min_row_padding ~= 0 then
		local v4111, v4112 = proto.writeTag(buf, n223, 4, proto.wireTypes.varint)

		buf, n223 = proto.writeVarInt(v4111, v4112, p335.min_row_padding)
	end

	local buf124 = buffer.create(n223)

	buffer.copy(buf124, 0, buf, 0, n223)

	return buf124
end
function t569.decode(p336: buffer) -- line: 22455
	-- upvalues: t569 (copy), proto (copy)
	local v4115 = t569.new()
	local n224 = 0

	while n224 < buffer.len(p336) do
		local v4117, v4118

		v4117, v4118, n224 = proto.readTag(p336, n224)

		if v4118 == proto.wireTypes.varint then
			if v4117 == 1 then
				local v4119

				v4119, n224 = proto.readVarIntI32(p336, n224)
				v4115.col_span = v4119
			elseif v4117 == 2 then
				local v4120

				v4120, n224 = proto.readVarIntI32(p336, n224)
				v4115.row_span = v4120
			elseif v4117 == 4 then
				local v4121

				v4121, n224 = proto.readVarIntI32(p336, n224)
				v4115.min_row_padding = v4121
			else
				local v4122

				v4122, n224 = proto.readVarInt(p336, n224)
			end
		elseif v4118 == proto.wireTypes.lengthDelimited then
			if v4117 == 3 then
				local v4123

				v4123, n224 = proto.readBuffer(p336, n224)
				v4115.alignment_type = buffer.tostring(v4123)
			else
				local v4124, v4125 = proto.readVarInt(p336, n224)

				n224 = v4125 + v4124
			end
		elseif v4118 == proto.wireTypes.i32 then
			local v4126

			v4126, n224 = proto.readFixed32(p336, n224)
		elseif v4118 == proto.wireTypes.i64 then
			local v4127

			v4127, n224 = proto.readFixed64(p336, n224)
		else
			error("Unsupported wire type: " .. v4118)
		end
	end

	return v4115
end
function t569.jsonEncode(p337) -- line: 22513
	local t571 = {}

	if p337.col_span ~= nil and p337.col_span ~= 0 then
		t571.colSpan = p337.col_span
	end

	if p337.row_span ~= nil and p337.row_span ~= 0 then
		t571.rowSpan = p337.row_span
	end

	if p337.alignment_type ~= nil and p337.alignment_type ~= "" then
		t571.alignmentType = p337.alignment_type
	end

	if p337.min_row_padding ~= nil and p337.min_row_padding ~= 0 then
		t571.minRowPadding = p337.min_row_padding
	end

	return t571
end
function t569.jsonDecode(t572: {[any]: any}) -- line: 22535
	-- upvalues: t569 (copy)
	local v4131 = t569.new()

	if t572.col_span ~= nil then
		v4131.col_span = t572.col_span
	end

	if t572.colSpan ~= nil then
		v4131.col_span = t572.colSpan
	end

	if t572.row_span ~= nil then
		v4131.row_span = t572.row_span
	end

	if t572.rowSpan ~= nil then
		v4131.row_span = t572.rowSpan
	end

	if t572.alignment_type ~= nil then
		v4131.alignment_type = t572.alignment_type
	end

	if t572.alignmentType ~= nil then
		v4131.alignment_type = t572.alignmentType
	end

	if t572.min_row_padding ~= nil then
		v4131.min_row_padding = t572.min_row_padding
	end

	if t572.minRowPadding ~= nil then
		v4131.min_row_padding = t572.minRowPadding
	end

	return v4131
end

t569.descriptor = {
	name = "ItemLayout",
	fullName = "roblox.apppageplatform.shared.v1beta1.ItemLayout"
}
t1.ItemLayout = t569
typeRegistry.default:register(t1.ItemLayout)
t1.PageEntryFormat = {
	fromNumber = function(n225: number) -- line: 22584
		if n225 == 0 then
			return "PAGE_ENTRY_FORMAT_INVALID"
		end

		if n225 == 1 then
			return "PAGE_ENTRY_FORMAT_UNIVERSAL"
		end

		return nil
	end,
	toNumber = function(p338) -- line: 22594
		if p338 == "PAGE_ENTRY_FORMAT_INVALID" then
			return 0
		end

		if p338 == "PAGE_ENTRY_FORMAT_UNIVERSAL" then
			return 1
		end

		return p338
	end,
	fromName = function(s2: string) -- line: 22604
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
