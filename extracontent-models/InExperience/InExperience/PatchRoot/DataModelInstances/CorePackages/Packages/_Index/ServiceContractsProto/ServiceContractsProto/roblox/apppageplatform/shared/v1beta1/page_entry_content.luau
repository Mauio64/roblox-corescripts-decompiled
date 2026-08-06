local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local background_layer = require(script.Parent.background_layer)
local page_entry = require(script.Parent.page_entry)
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 3746
	-- upvalues: t2 (copy)
	return (setmetatable({
		page_entry = if t3 ~= nil and t3.page_entry ~= nil then t3.page_entry else nil,
		input_data = if t3 ~= nil and t3.input_data ~= nil then t3.input_data else nil
	}, t2))
end
function t2.encode(p1) -- line: 3753
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.page_entry ~= nil then
		local v127 = p1.page_entry:encode()
		local v128, v129 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeBuffer(v128, v129, v127, buffer.len(v127))
	end

	if p1.input_data ~= nil then
		local v130 = p1.input_data:encode()
		local v131, v132 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeBuffer(v131, v132, v130, buffer.len(v130))
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 3774
	-- upvalues: t2 (copy), proto (copy), page_entry (copy), t1 (copy)
	local v135 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v137, v138

		v137, v138, n2 = proto.readTag(p2, n2)

		if v138 == proto.wireTypes.varint then
			local v139

			v139, n2 = proto.readVarInt(p2, n2)
		elseif v138 == proto.wireTypes.lengthDelimited then
			if v137 == 1 then
				local v140

				v140, n2 = proto.readBuffer(p2, n2)
				v135.page_entry = page_entry.PageEntry.decode(v140)
			elseif v137 == 2 then
				local v141

				v141, n2 = proto.readBuffer(p2, n2)
				v135.input_data = t1.PageEntryInputData.decode(v141)
			else
				local v142, v143 = proto.readVarInt(p2, n2)

				n2 = v143 + v142
			end
		elseif v138 == proto.wireTypes.i32 then
			local v144

			v144, n2 = proto.readFixed32(p2, n2)
		elseif v138 == proto.wireTypes.i64 then
			local v145

			v145, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v138)
		end
	end

	return v135
end
function t2.jsonEncode(p3) -- line: 3822
	local t4 = {}

	if p3.page_entry ~= nil then
		t4.pageEntry = p3.page_entry:jsonEncode()
	end

	if p3.input_data ~= nil then
		t4.inputData = p3.input_data:jsonEncode()
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 3836
	-- upvalues: t2 (copy), page_entry (copy), t1 (copy)
	local v149 = t2.new()

	if t5.page_entry ~= nil then
		v149.page_entry = page_entry.PageEntry.jsonDecode(t5.page_entry)
	end

	if t5.pageEntry ~= nil then
		v149.page_entry = page_entry.PageEntry.jsonDecode(t5.pageEntry)
	end

	if t5.input_data ~= nil then
		v149.input_data = t1.PageEntryInputData.jsonDecode(t5.input_data)
	end

	if t5.inputData ~= nil then
		v149.input_data = t1.PageEntryInputData.jsonDecode(t5.inputData)
	end

	return v149
end

t2.descriptor = {
	name = "UniversalPageEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniversalPageEntry"
}
t1.UniversalPageEntry = t2
typeRegistry.default:register(t1.UniversalPageEntry)

local t6 = {}

t6.__index = t6

function t6.new(t7: {[any]: any}?) -- line: 3872
	-- upvalues: t6 (copy)
	return (setmetatable({
		input_data = if t7 ~= nil and t7.input_data ~= nil then t7.input_data else nil,
		roblox_component = if t7 ~= nil and t7.roblox_component ~= nil then t7.roblox_component else ""
	}, t6))
end
function t6.encode(p4) -- line: 3879
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n3 = 0

	if p4.input_data ~= nil then
		local v154 = p4.input_data:encode()
		local v155, v156 = proto.writeTag(buf, n3, 1, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeBuffer(v155, v156, v154, buffer.len(v154))
	end

	if p4.roblox_component ~= nil and p4.roblox_component ~= "" then
		local v157, v158 = proto.writeTag(buf, n3, 2, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeString(v157, v158, p4.roblox_component)
	end

	local buf3 = buffer.create(n3)

	buffer.copy(buf3, 0, buf, 0, n3)

	return buf3
end
function t6.decode(p5: buffer) -- line: 3899
	-- upvalues: t6 (copy), proto (copy), t1 (copy)
	local v161 = t6.new()
	local n4 = 0

	while n4 < buffer.len(p5) do
		local v163, v164

		v163, v164, n4 = proto.readTag(p5, n4)

		if v164 == proto.wireTypes.varint then
			local v165

			v165, n4 = proto.readVarInt(p5, n4)
		elseif v164 == proto.wireTypes.lengthDelimited then
			if v163 == 1 then
				local v166

				v166, n4 = proto.readBuffer(p5, n4)
				v161.input_data = t1.PageEntryInputData.decode(v166)
			elseif v163 == 2 then
				local v167

				v167, n4 = proto.readBuffer(p5, n4)
				v161.roblox_component = buffer.tostring(v167)
			else
				local v168, v169 = proto.readVarInt(p5, n4)

				n4 = v169 + v168
			end
		elseif v164 == proto.wireTypes.i32 then
			local v170

			v170, n4 = proto.readFixed32(p5, n4)
		elseif v164 == proto.wireTypes.i64 then
			local v171

			v171, n4 = proto.readFixed64(p5, n4)
		else
			error("Unsupported wire type: " .. v164)
		end
	end

	return v161
end
function t6.jsonEncode(p6) -- line: 3947
	local t8 = {}

	if p6.input_data ~= nil then
		t8.inputData = p6.input_data:jsonEncode()
	end

	if p6.roblox_component ~= nil and p6.roblox_component ~= "" then
		t8.robloxComponent = p6.roblox_component
	end

	return t8
end
function t6.jsonDecode(t9: {[any]: any}) -- line: 3961
	-- upvalues: t6 (copy), t1 (copy)
	local v175 = t6.new()

	if t9.input_data ~= nil then
		v175.input_data = t1.PageEntryInputData.jsonDecode(t9.input_data)
	end

	if t9.inputData ~= nil then
		v175.input_data = t1.PageEntryInputData.jsonDecode(t9.inputData)
	end

	if t9.roblox_component ~= nil then
		v175.roblox_component = t9.roblox_component
	end

	if t9.robloxComponent ~= nil then
		v175.roblox_component = t9.robloxComponent
	end

	return v175
end

t6.descriptor = {
	name = "FeedEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.FeedEntry"
}
t1.FeedEntry = t6
typeRegistry.default:register(t1.FeedEntry)

local t10 = {}

t10.__index = t10

function t10.new(t11: {[any]: any}?) -- line: 3997
	-- upvalues: t10 (copy)
	return (setmetatable({
		roblox_component = if t11 ~= nil and t11.roblox_component ~= nil then t11.roblox_component else "",
		input_data = if t11 ~= nil and t11.input_data ~= nil then t11.input_data else nil,
		cta_buttons = if t11 ~= nil and t11.cta_buttons ~= nil then t11.cta_buttons else nil
	}, t10))
end
function t10.encode(p7) -- line: 4005
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n5 = 0

	if p7.roblox_component ~= nil and p7.roblox_component ~= "" then
		local v180, v181 = proto.writeTag(buf, n5, 1, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeString(v180, v181, p7.roblox_component)
	end

	if p7.input_data ~= nil and p7.input_data.type == "attribution_row" then
		local v182 = p7.input_data.value:encode()
		local v183, v184 = proto.writeTag(buf, n5, 2, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeBuffer(v183, v184, v182, buffer.len(v182))
	end

	if p7.cta_buttons ~= nil then
		local v185 = p7.cta_buttons:encode()
		local v186, v187 = proto.writeTag(buf, n5, 3, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeBuffer(v186, v187, v185, buffer.len(v185))
	end

	local buf4 = buffer.create(n5)

	buffer.copy(buf4, 0, buf, 0, n5)

	return buf4
end
function t10.decode(p8: buffer) -- line: 4033
	-- upvalues: t10 (copy), proto (copy), t1 (copy)
	local v190 = t10.new()
	local n6 = 0

	while n6 < buffer.len(p8) do
		local v192, v193

		v192, v193, n6 = proto.readTag(p8, n6)

		if v193 == proto.wireTypes.varint then
			local v194

			v194, n6 = proto.readVarInt(p8, n6)
		elseif v193 == proto.wireTypes.lengthDelimited then
			if v192 == 1 then
				local v195

				v195, n6 = proto.readBuffer(p8, n6)
				v190.roblox_component = buffer.tostring(v195)
			elseif v192 == 2 then
				local v196

				v196, n6 = proto.readBuffer(p8, n6)
				v190.input_data = {
					type = "attribution_row",
					value = t1.AttributionRowInputData.decode(v196)
				}
			elseif v192 == 3 then
				local v197

				v197, n6 = proto.readBuffer(p8, n6)
				v190.cta_buttons = t1.CtaButtonsInputData.decode(v197)
			else
				local v198, v199 = proto.readVarInt(p8, n6)

				n6 = v199 + v198
			end
		elseif v193 == proto.wireTypes.i32 then
			local v200

			v200, n6 = proto.readFixed32(p8, n6)
		elseif v193 == proto.wireTypes.i64 then
			local v201

			v201, n6 = proto.readFixed64(p8, n6)
		else
			error("Unsupported wire type: " .. v193)
		end
	end

	return v190
end
function t10.jsonEncode(p9) -- line: 4087
	local t12 = {}

	if p9.roblox_component ~= nil and p9.roblox_component ~= "" then
		t12.robloxComponent = p9.roblox_component
	end

	if p9.input_data ~= nil and p9.input_data.type == "attribution_row" then
		t12.attributionRow = p9.input_data.value:jsonEncode()
	end

	if p9.cta_buttons ~= nil then
		t12.ctaButtons = p9.cta_buttons:jsonEncode()
	end

	return t12
end
function t10.jsonDecode(t13: {[any]: any}) -- line: 4107
	-- upvalues: t10 (copy), t1 (copy)
	local v205 = t10.new()

	if t13.roblox_component ~= nil then
		v205.roblox_component = t13.roblox_component
	end

	if t13.robloxComponent ~= nil then
		v205.roblox_component = t13.robloxComponent
	end

	if t13.attribution_row ~= nil then
		v205.input_data = {
			type = "attribution_row",
			value = t1.AttributionRowInputData.jsonDecode(t13.attribution_row)
		}
	end

	if t13.attributionRow ~= nil then
		v205.input_data = {
			type = "attribution_row",
			value = t1.AttributionRowInputData.jsonDecode(t13.attributionRow)
		}
	end

	if t13.cta_buttons ~= nil then
		v205.cta_buttons = t1.CtaButtonsInputData.jsonDecode(t13.cta_buttons)
	end

	if t13.ctaButtons ~= nil then
		v205.cta_buttons = t1.CtaButtonsInputData.jsonDecode(t13.ctaButtons)
	end

	return v205
end

t10.descriptor = {
	name = "ForegroundHeaderEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.ForegroundHeaderEntry"
}
t1.ForegroundHeaderEntry = t10
typeRegistry.default:register(t1.ForegroundHeaderEntry)

local t14 = {}

t14.__index = t14

function t14.new(t15: {[any]: any}?) -- line: 4153
	-- upvalues: t14 (copy)
	return (setmetatable({
		roblox_component = if t15 ~= nil and t15.roblox_component ~= nil then t15.roblox_component else "",
		input_data = if t15 ~= nil and t15.input_data ~= nil then t15.input_data else nil
	}, t14))
end
function t14.encode(p10) -- line: 4160
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n7 = 0

	if p10.roblox_component ~= nil and p10.roblox_component ~= "" then
		local v210, v211 = proto.writeTag(buf, n7, 1, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeString(v210, v211, p10.roblox_component)
	end

	if p10.input_data ~= nil then
		if p10.input_data.type == "image" then
			local v212 = p10.input_data.value:encode()
			local v213, v214 = proto.writeTag(buf, n7, 2, proto.wireTypes.lengthDelimited)

			buf, n7 = proto.writeBuffer(v213, v214, v212, buffer.len(v212))
		elseif p10.input_data.type == "video" then
			local v215 = p10.input_data.value:encode()
			local v216, v217 = proto.writeTag(buf, n7, 3, proto.wireTypes.lengthDelimited)

			buf, n7 = proto.writeBuffer(v216, v217, v215, buffer.len(v215))
		end
	end

	local buf5 = buffer.create(n7)

	buffer.copy(buf5, 0, buf, 0, n7)

	return buf5
end
function t14.decode(p11: buffer) -- line: 4186
	-- upvalues: t14 (copy), proto (copy), t1 (copy)
	local v220 = t14.new()
	local n8 = 0

	while n8 < buffer.len(p11) do
		local v222, v223

		v222, v223, n8 = proto.readTag(p11, n8)

		if v223 == proto.wireTypes.varint then
			local v224

			v224, n8 = proto.readVarInt(p11, n8)
		elseif v223 == proto.wireTypes.lengthDelimited then
			if v222 == 1 then
				local v225

				v225, n8 = proto.readBuffer(p11, n8)
				v220.roblox_component = buffer.tostring(v225)
			elseif v222 == 2 then
				local v226

				v226, n8 = proto.readBuffer(p11, n8)
				v220.input_data = {
					type = "image",
					value = t1.ImageInputData.decode(v226)
				}
			elseif v222 == 3 then
				local v227

				v227, n8 = proto.readBuffer(p11, n8)
				v220.input_data = {
					type = "video",
					value = t1.VideoInputData.decode(v227)
				}
			else
				local v228, v229 = proto.readVarInt(p11, n8)

				n8 = v229 + v228
			end
		elseif v223 == proto.wireTypes.i32 then
			local v230

			v230, n8 = proto.readFixed32(p11, n8)
		elseif v223 == proto.wireTypes.i64 then
			local v231

			v231, n8 = proto.readFixed64(p11, n8)
		else
			error("Unsupported wire type: " .. v223)
		end
	end

	return v220
end
function t14.jsonEncode(p12) -- line: 4239
	local t16 = {}

	if p12.roblox_component ~= nil and p12.roblox_component ~= "" then
		t16.robloxComponent = p12.roblox_component
	end

	if p12.input_data ~= nil then
		if p12.input_data.type == "image" then
			t16.image = p12.input_data.value:jsonEncode()

			return t16
		end

		if p12.input_data.type == "video" then
			t16.video = p12.input_data.value:jsonEncode()
		end
	end

	return t16
end
function t14.jsonDecode(t17: {[any]: any}) -- line: 4257
	-- upvalues: t14 (copy), t1 (copy)
	local v235 = t14.new()

	if t17.roblox_component ~= nil then
		v235.roblox_component = t17.roblox_component
	end

	if t17.robloxComponent ~= nil then
		v235.roblox_component = t17.robloxComponent
	end

	if t17.image ~= nil then
		v235.input_data = {
			type = "image",
			value = t1.ImageInputData.jsonDecode(t17.image)
		}
	end

	if t17.video ~= nil then
		v235.input_data = {
			type = "video",
			value = t1.VideoInputData.jsonDecode(t17.video)
		}
	end

	return v235
end

t14.descriptor = {
	name = "BackgroundHeaderEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.BackgroundHeaderEntry"
}
t1.BackgroundHeaderEntry = t14
typeRegistry.default:register(t1.BackgroundHeaderEntry)

local t18 = {}

t18.__index = t18

function t18.new(t19: {[any]: any}?) -- line: 4293
	-- upvalues: t18 (copy)
	return (setmetatable({
		kind = if t19 ~= nil and t19.kind ~= nil then t19.kind else nil
	}, t18))
end
function t18.encode(p13) -- line: 4299
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n9 = 0

	if p13.kind ~= nil then
		if p13.kind.type == "badges_grid" then
			local v240 = p13.kind.value:encode()
			local v241, v242 = proto.writeTag(buf, n9, 1, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v241, v242, v240, buffer.len(v240))
		elseif p13.kind.type == "badge_details" then
			local v243 = p13.kind.value:encode()
			local v244, v245 = proto.writeTag(buf, n9, 2, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v244, v245, v243, buffer.len(v243))
		elseif p13.kind.type == "static_content" then
			local v246 = p13.kind.value:encode()
			local v247, v248 = proto.writeTag(buf, n9, 3, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v247, v248, v246, buffer.len(v246))
		elseif p13.kind.type == "experience_attribution_row" then
			local v249 = p13.kind.value:encode()
			local v250, v251 = proto.writeTag(buf, n9, 4, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v250, v251, v249, buffer.len(v249))
		elseif p13.kind.type == "experience_action_module" then
			local v252 = p13.kind.value:encode()
			local v253, v254 = proto.writeTag(buf, n9, 5, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v253, v254, v252, buffer.len(v252))
		elseif p13.kind.type == "experience_media_gallery" then
			local v255 = p13.kind.value:encode()
			local v256, v257 = proto.writeTag(buf, n9, 6, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v256, v257, v255, buffer.len(v255))
		elseif p13.kind.type == "experience_description" then
			local v258 = p13.kind.value:encode()
			local v259, v260 = proto.writeTag(buf, n9, 7, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v259, v260, v258, buffer.len(v258))
		elseif p13.kind.type == "experience_stat_row" then
			local v261 = p13.kind.value:encode()
			local v262, v263 = proto.writeTag(buf, n9, 8, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v262, v263, v261, buffer.len(v261))
		elseif p13.kind.type == "experience_info_table" then
			local v264 = p13.kind.value:encode()
			local v265, v266 = proto.writeTag(buf, n9, 9, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v265, v266, v264, buffer.len(v264))
		elseif p13.kind.type == "social_link_row" then
			local v267 = p13.kind.value:encode()
			local v268, v269 = proto.writeTag(buf, n9, 10, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v268, v269, v267, buffer.len(v267))
		elseif p13.kind.type == "experience_carousel" then
			local v270 = p13.kind.value:encode()
			local v271, v272 = proto.writeTag(buf, n9, 11, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v271, v272, v270, buffer.len(v270))
		elseif p13.kind.type == "song_carousel" then
			local v273 = p13.kind.value:encode()
			local v274, v275 = proto.writeTag(buf, n9, 12, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v274, v275, v273, buffer.len(v273))
		elseif p13.kind.type == "events_carousel" then
			local v276 = p13.kind.value:encode()
			local v277, v278 = proto.writeTag(buf, n9, 13, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v277, v278, v276, buffer.len(v276))
		elseif p13.kind.type == "game_pass_collection" then
			local v279 = p13.kind.value:encode()
			local v280, v281 = proto.writeTag(buf, n9, 14, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v280, v281, v279, buffer.len(v279))
		elseif p13.kind.type == "developer_product_collection" then
			local v282 = p13.kind.value:encode()
			local v283, v284 = proto.writeTag(buf, n9, 15, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v283, v284, v282, buffer.len(v282))
		elseif p13.kind.type == "subscription_collection" then
			local v285 = p13.kind.value:encode()
			local v286, v287 = proto.writeTag(buf, n9, 16, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v286, v287, v285, buffer.len(v285))
		elseif p13.kind.type == "dynamic_store_category" then
			local v288 = p13.kind.value:encode()
			local v289, v290 = proto.writeTag(buf, n9, 17, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v289, v290, v288, buffer.len(v288))
		elseif p13.kind.type == "card_container" then
			local v291 = p13.kind.value:encode()
			local v292, v293 = proto.writeTag(buf, n9, 20, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v292, v293, v291, buffer.len(v291))
		elseif p13.kind.type == "card" then
			local v294 = p13.kind.value:encode()
			local v295, v296 = proto.writeTag(buf, n9, 21, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v295, v296, v294, buffer.len(v294))
		elseif p13.kind.type == "dialog" then
			local v297 = p13.kind.value:encode()
			local v298, v299 = proto.writeTag(buf, n9, 22, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v298, v299, v297, buffer.len(v297))
		elseif p13.kind.type == "banner" then
			local v300 = p13.kind.value:encode()
			local v301, v302 = proto.writeTag(buf, n9, 23, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v301, v302, v300, buffer.len(v300))
		elseif p13.kind.type == "tooltip" then
			local v303 = p13.kind.value:encode()
			local v304, v305 = proto.writeTag(buf, n9, 24, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v304, v305, v303, buffer.len(v303))
		elseif p13.kind.type == "coachmark" then
			local v306 = p13.kind.value:encode()
			local v307, v308 = proto.writeTag(buf, n9, 25, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v307, v308, v306, buffer.len(v306))
		elseif p13.kind.type == "system_banner_prompt" then
			local v309 = p13.kind.value:encode()
			local v310, v311 = proto.writeTag(buf, n9, 28, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v310, v311, v309, buffer.len(v309))
		elseif p13.kind.type == "age_check_upsell" then
			local v312 = p13.kind.value:encode()
			local v313, v314 = proto.writeTag(buf, n9, 29, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v313, v314, v312, buffer.len(v312))
		elseif p13.kind.type == "catalog_item_list" then
			local v315 = p13.kind.value:encode()
			local v316, v317 = proto.writeTag(buf, n9, 26, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v316, v317, v315, buffer.len(v315))
		elseif p13.kind.type == "user_list" then
			local v318 = p13.kind.value:encode()
			local v319, v320 = proto.writeTag(buf, n9, 27, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v319, v320, v318, buffer.len(v318))
		elseif p13.kind.type == "experience_content_rating_label" then
			local v321 = p13.kind.value:encode()
			local v322, v323 = proto.writeTag(buf, n9, 30, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v322, v323, v321, buffer.len(v321))
		elseif p13.kind.type == "experience_refund_policy" then
			local v324 = p13.kind.value:encode()
			local v325, v326 = proto.writeTag(buf, n9, 31, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v325, v326, v324, buffer.len(v324))
		elseif p13.kind.type == "experience_play_with_reward" then
			local v327 = p13.kind.value:encode()
			local v328, v329 = proto.writeTag(buf, n9, 32, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v328, v329, v327, buffer.len(v327))
		elseif p13.kind.type == "experience_guidelines_dialog" then
			local v330 = p13.kind.value:encode()
			local v331, v332 = proto.writeTag(buf, n9, 33, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v331, v332, v330, buffer.len(v330))
		elseif p13.kind.type == "community_section" then
			local v333 = p13.kind.value:encode()
			local v334, v335 = proto.writeTag(buf, n9, 35, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v334, v335, v333, buffer.len(v333))
		elseif p13.kind.type == "moments_carousel" then
			local v336 = p13.kind.value:encode()
			local v337, v338 = proto.writeTag(buf, n9, 34, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v337, v338, v336, buffer.len(v336))
		elseif p13.kind.type == "text" then
			local v339 = p13.kind.value:encode()
			local v340, v341 = proto.writeTag(buf, n9, 40, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v340, v341, v339, buffer.len(v339))
		elseif p13.kind.type == "vertical_feed" then
			local v342 = p13.kind.value:encode()
			local v343, v344 = proto.writeTag(buf, n9, 41, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v343, v344, v342, buffer.len(v342))
		elseif p13.kind.type == "page_header" then
			local v345 = p13.kind.value:encode()
			local v346, v347 = proto.writeTag(buf, n9, 42, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v346, v347, v345, buffer.len(v345))
		elseif p13.kind.type == "experience_details_feed" then
			local v348 = p13.kind.value:encode()
			local v349, v350 = proto.writeTag(buf, n9, 500, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v349, v350, v348, buffer.len(v348))
		elseif p13.kind.type == "experience_details_action_bar" then
			local v351 = p13.kind.value:encode()
			local v352, v353 = proto.writeTag(buf, n9, 501, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v352, v353, v351, buffer.len(v351))
		elseif p13.kind.type == "experience_details_banner_image" then
			local v354 = p13.kind.value:encode()
			local v355, v356 = proto.writeTag(buf, n9, 502, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v355, v356, v354, buffer.len(v354))
		elseif p13.kind.type == "experience_details_sticky_header" then
			local v357 = p13.kind.value:encode()
			local v358, v359 = proto.writeTag(buf, n9, 503, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v358, v359, v357, buffer.len(v357))
		elseif p13.kind.type == "event_details_feed" then
			local v360 = p13.kind.value:encode()
			local v361, v362 = proto.writeTag(buf, n9, 600, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v361, v362, v360, buffer.len(v360))
		elseif p13.kind.type == "event_details_action_bar" then
			local v363 = p13.kind.value:encode()
			local v364, v365 = proto.writeTag(buf, n9, 601, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v364, v365, v363, buffer.len(v363))
		elseif p13.kind.type == "event_attribution_row" then
			local v366 = p13.kind.value:encode()
			local v367, v368 = proto.writeTag(buf, n9, 602, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v367, v368, v366, buffer.len(v366))
		elseif p13.kind.type == "event_description" then
			local v369 = p13.kind.value:encode()
			local v370, v371 = proto.writeTag(buf, n9, 603, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v370, v371, v369, buffer.len(v369))
		elseif p13.kind.type == "event_info_table" then
			local v372 = p13.kind.value:encode()
			local v373, v374 = proto.writeTag(buf, n9, 604, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v373, v374, v372, buffer.len(v372))
		elseif p13.kind.type == "event_details_sheet_full_bleed" then
			local v375 = p13.kind.value:encode()
			local v376, v377 = proto.writeTag(buf, n9, 605, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v376, v377, v375, buffer.len(v375))
		elseif p13.kind.type == "event_notifications_modal" then
			local v378 = p13.kind.value:encode()
			local v379, v380 = proto.writeTag(buf, n9, 606, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v379, v380, v378, buffer.len(v378))
		elseif p13.kind.type == "dev_store_feed" then
			local v381 = p13.kind.value:encode()
			local v382, v383 = proto.writeTag(buf, n9, 700, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v382, v383, v381, buffer.len(v381))
		elseif p13.kind.type == "charts_feed" then
			local v384 = p13.kind.value:encode()
			local v385, v386 = proto.writeTag(buf, n9, 800, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v385, v386, v384, buffer.len(v384))
		elseif p13.kind.type == "filter_pills" then
			local v387 = p13.kind.value:encode()
			local v388, v389 = proto.writeTag(buf, n9, 801, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v388, v389, v387, buffer.len(v387))
		elseif p13.kind.type == "sort_selector" then
			local v390 = p13.kind.value:encode()
			local v391, v392 = proto.writeTag(buf, n9, 802, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v391, v392, v390, buffer.len(v390))
		elseif p13.kind.type == "genre_selector" then
			local v393 = p13.kind.value:encode()
			local v394, v395 = proto.writeTag(buf, n9, 803, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v394, v395, v393, buffer.len(v393))
		elseif p13.kind.type == "marketplace_catalog_feed" then
			local v396 = p13.kind.value:encode()
			local v397, v398 = proto.writeTag(buf, n9, 900, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v397, v398, v396, buffer.len(v396))
		elseif p13.kind.type == "marketplace_catalog_category_menu" then
			local v399 = p13.kind.value:encode()
			local v400, v401 = proto.writeTag(buf, n9, 901, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v400, v401, v399, buffer.len(v399))
		elseif p13.kind.type == "marketplace_catalog_item_group" then
			local v402 = p13.kind.value:encode()
			local v403, v404 = proto.writeTag(buf, n9, 902, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v403, v404, v402, buffer.len(v402))
		elseif p13.kind.type == "marketplace_catalog_item_carousel" then
			local v405 = p13.kind.value:encode()
			local v406, v407 = proto.writeTag(buf, n9, 903, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v406, v407, v405, buffer.len(v405))
		elseif p13.kind.type == "marketplace_catalog_hero_unit" then
			local v408 = p13.kind.value:encode()
			local v409, v410 = proto.writeTag(buf, n9, 904, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v409, v410, v408, buffer.len(v408))
		elseif p13.kind.type == "catalog_item_grid" then
			local v411 = p13.kind.value:encode()
			local v412, v413 = proto.writeTag(buf, n9, 905, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v412, v413, v411, buffer.len(v411))
		elseif p13.kind.type == "marketplace_offer_modal" then
			local v414 = p13.kind.value:encode()
			local v415, v416 = proto.writeTag(buf, n9, 906, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v415, v416, v414, buffer.len(v414))
		elseif p13.kind.type == "search_results_feed" then
			local v417 = p13.kind.value:encode()
			local v418, v419 = proto.writeTag(buf, n9, 1000, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v418, v419, v417, buffer.len(v417))
		elseif p13.kind.type == "power_search_ai_overview" then
			local v420 = p13.kind.value:encode()
			local v421, v422 = proto.writeTag(buf, n9, 1001, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v421, v422, v420, buffer.len(v420))
		elseif p13.kind.type == "experience_emphasis_tile" then
			local v423 = p13.kind.value:encode()
			local v424, v425 = proto.writeTag(buf, n9, 1002, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v424, v425, v423, buffer.len(v423))
		elseif p13.kind.type == "option_selector_carousel" then
			local v426 = p13.kind.value:encode()
			local v427, v428 = proto.writeTag(buf, n9, 1100, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v427, v428, v426, buffer.len(v426))
		elseif p13.kind.type == "party_chat_conversation_upsell" then
			local v429 = p13.kind.value:encode()
			local v430, v431 = proto.writeTag(buf, n9, 1200, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v430, v431, v429, buffer.len(v429))
		elseif p13.kind.type == "pre_auth_landing_sticky_header" then
			local v432 = p13.kind.value:encode()
			local v433, v434 = proto.writeTag(buf, n9, 1300, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v433, v434, v432, buffer.len(v432))
		end
	end

	local buf6 = buffer.create(n9)

	buffer.copy(buf6, 0, buf, 0, n9)

	return buf6
end
function t18.decode(p14: buffer) -- line: 4572
	-- upvalues: t18 (copy), proto (copy), t1 (copy)
	local v437 = t18.new()
	local n10 = 0

	while n10 < buffer.len(p14) do
		local v439, v440

		v439, v440, n10 = proto.readTag(p14, n10)

		if v440 == proto.wireTypes.varint then
			local v441

			v441, n10 = proto.readVarInt(p14, n10)
		elseif v440 == proto.wireTypes.lengthDelimited then
			if v439 == 1 then
				local v442

				v442, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "badges_grid",
					value = t1.BadgesGridInputData.decode(v442)
				}
			elseif v439 == 2 then
				local v443

				v443, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "badge_details",
					value = t1.BadgeDetailsInputData.decode(v443)
				}
			elseif v439 == 3 then
				local v444

				v444, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "static_content",
					value = t1.StaticInputData.decode(v444)
				}
			elseif v439 == 4 then
				local v445

				v445, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "experience_attribution_row",
					value = t1.ExperienceAttributionRowInputData.decode(v445)
				}
			elseif v439 == 5 then
				local v446

				v446, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "experience_action_module",
					value = t1.ExperienceActionModuleInputData.decode(v446)
				}
			elseif v439 == 6 then
				local v447

				v447, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "experience_media_gallery",
					value = t1.ExperienceMediaGalleryInputData.decode(v447)
				}
			elseif v439 == 7 then
				local v448

				v448, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "experience_description",
					value = t1.ExperienceDescriptionInputData.decode(v448)
				}
			elseif v439 == 8 then
				local v449

				v449, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "experience_stat_row",
					value = t1.ExperienceStatRowInputData.decode(v449)
				}
			elseif v439 == 9 then
				local v450

				v450, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "experience_info_table",
					value = t1.ExperienceInfoTableInputData.decode(v450)
				}
			elseif v439 == 10 then
				local v451

				v451, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "social_link_row",
					value = t1.SocialLinkRowInputData.decode(v451)
				}
			elseif v439 == 11 then
				local v452

				v452, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "experience_carousel",
					value = t1.ExperienceCarouselInputData.decode(v452)
				}
			elseif v439 == 12 then
				local v453

				v453, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "song_carousel",
					value = t1.SongCarouselInputData.decode(v453)
				}
			elseif v439 == 13 then
				local v454

				v454, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "events_carousel",
					value = t1.EventsCarouselInputData.decode(v454)
				}
			elseif v439 == 14 then
				local v455

				v455, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "game_pass_collection",
					value = t1.GamePassCollectionInputData.decode(v455)
				}
			elseif v439 == 15 then
				local v456

				v456, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "developer_product_collection",
					value = t1.DeveloperProductCollectionInputData.decode(v456)
				}
			elseif v439 == 16 then
				local v457

				v457, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "subscription_collection",
					value = t1.SubscriptionCollectionInputData.decode(v457)
				}
			elseif v439 == 17 then
				local v458

				v458, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "dynamic_store_category",
					value = t1.DynamicStoreCategoryInputData.decode(v458)
				}
			elseif v439 == 20 then
				local v459

				v459, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "card_container",
					value = t1.CardContainerInputData.decode(v459)
				}
			elseif v439 == 21 then
				local v460

				v460, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "card",
					value = t1.CardInputData.decode(v460)
				}
			elseif v439 == 22 then
				local v461

				v461, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "dialog",
					value = t1.DialogInputData.decode(v461)
				}
			elseif v439 == 23 then
				local v462

				v462, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "banner",
					value = t1.BannerInputData.decode(v462)
				}
			elseif v439 == 24 then
				local v463

				v463, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "tooltip",
					value = t1.TooltipInputData.decode(v463)
				}
			elseif v439 == 25 then
				local v464

				v464, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "coachmark",
					value = t1.CoachmarkInputData.decode(v464)
				}
			elseif v439 == 26 then
				local v465

				v465, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "catalog_item_list",
					value = t1.CatalogItemListInputData.decode(v465)
				}
			elseif v439 == 27 then
				local v466

				v466, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "user_list",
					value = t1.UserListInputData.decode(v466)
				}
			elseif v439 == 28 then
				local v467

				v467, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "system_banner_prompt",
					value = t1.SystemBannerInputData.decode(v467)
				}
			elseif v439 == 29 then
				local v468

				v468, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "age_check_upsell",
					value = t1.AgeCheckUpsellInputData.decode(v468)
				}
			elseif v439 == 30 then
				local v469

				v469, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "experience_content_rating_label",
					value = t1.ExperienceContentRatingLabelInputData.decode(v469)
				}
			elseif v439 == 31 then
				local v470

				v470, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "experience_refund_policy",
					value = t1.ExperienceRefundPolicyInputData.decode(v470)
				}
			elseif v439 == 32 then
				local v471

				v471, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "experience_play_with_reward",
					value = t1.ExperiencePlayWithRewardInputData.decode(v471)
				}
			elseif v439 == 33 then
				local v472

				v472, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "experience_guidelines_dialog",
					value = t1.ExperienceGuidelinesDialogInputData.decode(v472)
				}
			elseif v439 == 34 then
				local v473

				v473, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "moments_carousel",
					value = t1.MomentsCarouselInputData.decode(v473)
				}
			elseif v439 == 35 then
				local v474

				v474, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "community_section",
					value = t1.CommunitySectionInputData.decode(v474)
				}
			elseif v439 == 40 then
				local v475

				v475, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "text",
					value = t1.TextInputData.decode(v475)
				}
			elseif v439 == 41 then
				local v476

				v476, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "vertical_feed",
					value = t1.VerticalFeedInputData.decode(v476)
				}
			elseif v439 == 42 then
				local v477

				v477, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "page_header",
					value = t1.PageHeaderInputData.decode(v477)
				}
			elseif v439 == 500 then
				local v478

				v478, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "experience_details_feed",
					value = t1.ExperienceDetailsFeedInputData.decode(v478)
				}
			elseif v439 == 501 then
				local v479

				v479, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "experience_details_action_bar",
					value = t1.ExperienceDetailsActionBarInputData.decode(v479)
				}
			elseif v439 == 502 then
				local v480

				v480, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "experience_details_banner_image",
					value = t1.ExperienceDetailsBannerImageInputData.decode(v480)
				}
			elseif v439 == 503 then
				local v481

				v481, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "experience_details_sticky_header",
					value = t1.ExperienceDetailsStickyHeaderInputData.decode(v481)
				}
			elseif v439 == 600 then
				local v482

				v482, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "event_details_feed",
					value = t1.EventDetailsFeedInputData.decode(v482)
				}
			elseif v439 == 601 then
				local v483

				v483, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "event_details_action_bar",
					value = t1.EventDetailsActionBarInputData.decode(v483)
				}
			elseif v439 == 602 then
				local v484

				v484, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "event_attribution_row",
					value = t1.EventAttributionRowInputData.decode(v484)
				}
			elseif v439 == 603 then
				local v485

				v485, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "event_description",
					value = t1.EventDescriptionInputData.decode(v485)
				}
			elseif v439 == 604 then
				local v486

				v486, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "event_info_table",
					value = t1.EventInfoTableInputData.decode(v486)
				}
			elseif v439 == 605 then
				local v487

				v487, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "event_details_sheet_full_bleed",
					value = t1.EventDetailsSheetFullBleedInputData.decode(v487)
				}
			elseif v439 == 606 then
				local v488

				v488, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "event_notifications_modal",
					value = t1.EventNotificationsModalInputData.decode(v488)
				}
			elseif v439 == 700 then
				local v489

				v489, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "dev_store_feed",
					value = t1.DevStoreFeedInputData.decode(v489)
				}
			elseif v439 == 800 then
				local v490

				v490, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "charts_feed",
					value = t1.ChartsFeedInputData.decode(v490)
				}
			elseif v439 == 801 then
				local v491

				v491, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "filter_pills",
					value = t1.FilterPillsInputData.decode(v491)
				}
			elseif v439 == 802 then
				local v492

				v492, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "sort_selector",
					value = t1.SortSelectorInputData.decode(v492)
				}
			elseif v439 == 803 then
				local v493

				v493, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "genre_selector",
					value = t1.ChartsGenreSelectorInputData.decode(v493)
				}
			elseif v439 == 900 then
				local v494

				v494, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "marketplace_catalog_feed",
					value = t1.UAMarketplaceCatalogFeedInputData.decode(v494)
				}
			elseif v439 == 901 then
				local v495

				v495, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "marketplace_catalog_category_menu",
					value = t1.UAMarketplaceCatalogCategoryMenuInputData.decode(v495)
				}
			elseif v439 == 902 then
				local v496

				v496, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "marketplace_catalog_item_group",
					value = t1.UAMarketplaceCatalogItemGroupInputData.decode(v496)
				}
			elseif v439 == 903 then
				local v497

				v497, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "marketplace_catalog_item_carousel",
					value = t1.UAMarketplaceCatalogItemCarouselInputData.decode(v497)
				}
			elseif v439 == 904 then
				local v498

				v498, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "marketplace_catalog_hero_unit",
					value = t1.UAMarketplaceCatalogHeroUnitInputData.decode(v498)
				}
			elseif v439 == 905 then
				local v499

				v499, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "catalog_item_grid",
					value = t1.CatalogItemGridInputData.decode(v499)
				}
			elseif v439 == 906 then
				local v500

				v500, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "marketplace_offer_modal",
					value = t1.MarketplaceOfferModalInputData.decode(v500)
				}
			elseif v439 == 1000 then
				local v501

				v501, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "search_results_feed",
					value = t1.SearchResultsFeedInputData.decode(v501)
				}
			elseif v439 == 1001 then
				local v502

				v502, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "power_search_ai_overview",
					value = t1.PowerSearchAIOverviewInputData.decode(v502)
				}
			elseif v439 == 1002 then
				local v503

				v503, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "experience_emphasis_tile",
					value = t1.ExperienceEmphasisTileInputData.decode(v503)
				}
			elseif v439 == 1100 then
				local v504

				v504, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "option_selector_carousel",
					value = t1.OptionSelectorCarouselInputData.decode(v504)
				}
			elseif v439 == 1200 then
				local v505

				v505, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "party_chat_conversation_upsell",
					value = t1.PartyChatConversationUpsellInputData.decode(v505)
				}
			elseif v439 == 1300 then
				local v506

				v506, n10 = proto.readBuffer(p14, n10)
				v437.kind = {
					type = "pre_auth_landing_sticky_header",
					value = t1.PreAuthLandingStickyHeaderInputData.decode(v506)
				}
			else
				local v507, v508 = proto.readVarInt(p14, n10)

				n10 = v508 + v507
			end
		elseif v440 == proto.wireTypes.i32 then
			local v509

			v509, n10 = proto.readFixed32(p14, n10)
		elseif v440 == proto.wireTypes.i64 then
			local v510

			v510, n10 = proto.readFixed64(p14, n10)
		else
			error("Unsupported wire type: " .. v440)
		end
	end

	return v437
end
function t18.jsonEncode(p15) -- line: 5029
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

			return t20
		end

		if p15.kind.type == "pre_auth_landing_sticky_header" then
			t20.preAuthLandingStickyHeader = p15.kind.value:jsonEncode()
		end
	end

	return t20
end
function t18.jsonDecode(t21: {[any]: any}) -- line: 5169
	-- upvalues: t18 (copy), t1 (copy)
	local v514 = t18.new()

	if t21.badges_grid ~= nil then
		v514.kind = {
			type = "badges_grid",
			value = t1.BadgesGridInputData.jsonDecode(t21.badges_grid)
		}
	end

	if t21.badgesGrid ~= nil then
		v514.kind = {
			type = "badges_grid",
			value = t1.BadgesGridInputData.jsonDecode(t21.badgesGrid)
		}
	end

	if t21.badge_details ~= nil then
		v514.kind = {
			type = "badge_details",
			value = t1.BadgeDetailsInputData.jsonDecode(t21.badge_details)
		}
	end

	if t21.badgeDetails ~= nil then
		v514.kind = {
			type = "badge_details",
			value = t1.BadgeDetailsInputData.jsonDecode(t21.badgeDetails)
		}
	end

	if t21.static_content ~= nil then
		v514.kind = {
			type = "static_content",
			value = t1.StaticInputData.jsonDecode(t21.static_content)
		}
	end

	if t21.staticContent ~= nil then
		v514.kind = {
			type = "static_content",
			value = t1.StaticInputData.jsonDecode(t21.staticContent)
		}
	end

	if t21.experience_attribution_row ~= nil then
		v514.kind = {
			type = "experience_attribution_row",
			value = t1.ExperienceAttributionRowInputData.jsonDecode(t21.experience_attribution_row)
		}
	end

	if t21.experienceAttributionRow ~= nil then
		v514.kind = {
			type = "experience_attribution_row",
			value = t1.ExperienceAttributionRowInputData.jsonDecode(t21.experienceAttributionRow)
		}
	end

	if t21.experience_action_module ~= nil then
		v514.kind = {
			type = "experience_action_module",
			value = t1.ExperienceActionModuleInputData.jsonDecode(t21.experience_action_module)
		}
	end

	if t21.experienceActionModule ~= nil then
		v514.kind = {
			type = "experience_action_module",
			value = t1.ExperienceActionModuleInputData.jsonDecode(t21.experienceActionModule)
		}
	end

	if t21.experience_media_gallery ~= nil then
		v514.kind = {
			type = "experience_media_gallery",
			value = t1.ExperienceMediaGalleryInputData.jsonDecode(t21.experience_media_gallery)
		}
	end

	if t21.experienceMediaGallery ~= nil then
		v514.kind = {
			type = "experience_media_gallery",
			value = t1.ExperienceMediaGalleryInputData.jsonDecode(t21.experienceMediaGallery)
		}
	end

	if t21.experience_description ~= nil then
		v514.kind = {
			type = "experience_description",
			value = t1.ExperienceDescriptionInputData.jsonDecode(t21.experience_description)
		}
	end

	if t21.experienceDescription ~= nil then
		v514.kind = {
			type = "experience_description",
			value = t1.ExperienceDescriptionInputData.jsonDecode(t21.experienceDescription)
		}
	end

	if t21.experience_stat_row ~= nil then
		v514.kind = {
			type = "experience_stat_row",
			value = t1.ExperienceStatRowInputData.jsonDecode(t21.experience_stat_row)
		}
	end

	if t21.experienceStatRow ~= nil then
		v514.kind = {
			type = "experience_stat_row",
			value = t1.ExperienceStatRowInputData.jsonDecode(t21.experienceStatRow)
		}
	end

	if t21.experience_info_table ~= nil then
		v514.kind = {
			type = "experience_info_table",
			value = t1.ExperienceInfoTableInputData.jsonDecode(t21.experience_info_table)
		}
	end

	if t21.experienceInfoTable ~= nil then
		v514.kind = {
			type = "experience_info_table",
			value = t1.ExperienceInfoTableInputData.jsonDecode(t21.experienceInfoTable)
		}
	end

	if t21.social_link_row ~= nil then
		v514.kind = {
			type = "social_link_row",
			value = t1.SocialLinkRowInputData.jsonDecode(t21.social_link_row)
		}
	end

	if t21.socialLinkRow ~= nil then
		v514.kind = {
			type = "social_link_row",
			value = t1.SocialLinkRowInputData.jsonDecode(t21.socialLinkRow)
		}
	end

	if t21.experience_carousel ~= nil then
		v514.kind = {
			type = "experience_carousel",
			value = t1.ExperienceCarouselInputData.jsonDecode(t21.experience_carousel)
		}
	end

	if t21.experienceCarousel ~= nil then
		v514.kind = {
			type = "experience_carousel",
			value = t1.ExperienceCarouselInputData.jsonDecode(t21.experienceCarousel)
		}
	end

	if t21.song_carousel ~= nil then
		v514.kind = {
			type = "song_carousel",
			value = t1.SongCarouselInputData.jsonDecode(t21.song_carousel)
		}
	end

	if t21.songCarousel ~= nil then
		v514.kind = {
			type = "song_carousel",
			value = t1.SongCarouselInputData.jsonDecode(t21.songCarousel)
		}
	end

	if t21.events_carousel ~= nil then
		v514.kind = {
			type = "events_carousel",
			value = t1.EventsCarouselInputData.jsonDecode(t21.events_carousel)
		}
	end

	if t21.eventsCarousel ~= nil then
		v514.kind = {
			type = "events_carousel",
			value = t1.EventsCarouselInputData.jsonDecode(t21.eventsCarousel)
		}
	end

	if t21.game_pass_collection ~= nil then
		v514.kind = {
			type = "game_pass_collection",
			value = t1.GamePassCollectionInputData.jsonDecode(t21.game_pass_collection)
		}
	end

	if t21.gamePassCollection ~= nil then
		v514.kind = {
			type = "game_pass_collection",
			value = t1.GamePassCollectionInputData.jsonDecode(t21.gamePassCollection)
		}
	end

	if t21.developer_product_collection ~= nil then
		v514.kind = {
			type = "developer_product_collection",
			value = t1.DeveloperProductCollectionInputData.jsonDecode(t21.developer_product_collection)
		}
	end

	if t21.developerProductCollection ~= nil then
		v514.kind = {
			type = "developer_product_collection",
			value = t1.DeveloperProductCollectionInputData.jsonDecode(t21.developerProductCollection)
		}
	end

	if t21.subscription_collection ~= nil then
		v514.kind = {
			type = "subscription_collection",
			value = t1.SubscriptionCollectionInputData.jsonDecode(t21.subscription_collection)
		}
	end

	if t21.subscriptionCollection ~= nil then
		v514.kind = {
			type = "subscription_collection",
			value = t1.SubscriptionCollectionInputData.jsonDecode(t21.subscriptionCollection)
		}
	end

	if t21.dynamic_store_category ~= nil then
		v514.kind = {
			type = "dynamic_store_category",
			value = t1.DynamicStoreCategoryInputData.jsonDecode(t21.dynamic_store_category)
		}
	end

	if t21.dynamicStoreCategory ~= nil then
		v514.kind = {
			type = "dynamic_store_category",
			value = t1.DynamicStoreCategoryInputData.jsonDecode(t21.dynamicStoreCategory)
		}
	end

	if t21.card_container ~= nil then
		v514.kind = {
			type = "card_container",
			value = t1.CardContainerInputData.jsonDecode(t21.card_container)
		}
	end

	if t21.cardContainer ~= nil then
		v514.kind = {
			type = "card_container",
			value = t1.CardContainerInputData.jsonDecode(t21.cardContainer)
		}
	end

	if t21.card ~= nil then
		v514.kind = {
			type = "card",
			value = t1.CardInputData.jsonDecode(t21.card)
		}
	end

	if t21.dialog ~= nil then
		v514.kind = {
			type = "dialog",
			value = t1.DialogInputData.jsonDecode(t21.dialog)
		}
	end

	if t21.banner ~= nil then
		v514.kind = {
			type = "banner",
			value = t1.BannerInputData.jsonDecode(t21.banner)
		}
	end

	if t21.tooltip ~= nil then
		v514.kind = {
			type = "tooltip",
			value = t1.TooltipInputData.jsonDecode(t21.tooltip)
		}
	end

	if t21.coachmark ~= nil then
		v514.kind = {
			type = "coachmark",
			value = t1.CoachmarkInputData.jsonDecode(t21.coachmark)
		}
	end

	if t21.system_banner_prompt ~= nil then
		v514.kind = {
			type = "system_banner_prompt",
			value = t1.SystemBannerInputData.jsonDecode(t21.system_banner_prompt)
		}
	end

	if t21.systemBannerPrompt ~= nil then
		v514.kind = {
			type = "system_banner_prompt",
			value = t1.SystemBannerInputData.jsonDecode(t21.systemBannerPrompt)
		}
	end

	if t21.age_check_upsell ~= nil then
		v514.kind = {
			type = "age_check_upsell",
			value = t1.AgeCheckUpsellInputData.jsonDecode(t21.age_check_upsell)
		}
	end

	if t21.ageCheckUpsell ~= nil then
		v514.kind = {
			type = "age_check_upsell",
			value = t1.AgeCheckUpsellInputData.jsonDecode(t21.ageCheckUpsell)
		}
	end

	if t21.catalog_item_list ~= nil then
		v514.kind = {
			type = "catalog_item_list",
			value = t1.CatalogItemListInputData.jsonDecode(t21.catalog_item_list)
		}
	end

	if t21.catalogItemList ~= nil then
		v514.kind = {
			type = "catalog_item_list",
			value = t1.CatalogItemListInputData.jsonDecode(t21.catalogItemList)
		}
	end

	if t21.user_list ~= nil then
		v514.kind = {
			type = "user_list",
			value = t1.UserListInputData.jsonDecode(t21.user_list)
		}
	end

	if t21.userList ~= nil then
		v514.kind = {
			type = "user_list",
			value = t1.UserListInputData.jsonDecode(t21.userList)
		}
	end

	if t21.experience_content_rating_label ~= nil then
		v514.kind = {
			type = "experience_content_rating_label",
			value = t1.ExperienceContentRatingLabelInputData.jsonDecode(t21.experience_content_rating_label)
		}
	end

	if t21.experienceContentRatingLabel ~= nil then
		v514.kind = {
			type = "experience_content_rating_label",
			value = t1.ExperienceContentRatingLabelInputData.jsonDecode(t21.experienceContentRatingLabel)
		}
	end

	if t21.experience_refund_policy ~= nil then
		v514.kind = {
			type = "experience_refund_policy",
			value = t1.ExperienceRefundPolicyInputData.jsonDecode(t21.experience_refund_policy)
		}
	end

	if t21.experienceRefundPolicy ~= nil then
		v514.kind = {
			type = "experience_refund_policy",
			value = t1.ExperienceRefundPolicyInputData.jsonDecode(t21.experienceRefundPolicy)
		}
	end

	if t21.experience_play_with_reward ~= nil then
		v514.kind = {
			type = "experience_play_with_reward",
			value = t1.ExperiencePlayWithRewardInputData.jsonDecode(t21.experience_play_with_reward)
		}
	end

	if t21.experiencePlayWithReward ~= nil then
		v514.kind = {
			type = "experience_play_with_reward",
			value = t1.ExperiencePlayWithRewardInputData.jsonDecode(t21.experiencePlayWithReward)
		}
	end

	if t21.experience_guidelines_dialog ~= nil then
		v514.kind = {
			type = "experience_guidelines_dialog",
			value = t1.ExperienceGuidelinesDialogInputData.jsonDecode(t21.experience_guidelines_dialog)
		}
	end

	if t21.experienceGuidelinesDialog ~= nil then
		v514.kind = {
			type = "experience_guidelines_dialog",
			value = t1.ExperienceGuidelinesDialogInputData.jsonDecode(t21.experienceGuidelinesDialog)
		}
	end

	if t21.community_section ~= nil then
		v514.kind = {
			type = "community_section",
			value = t1.CommunitySectionInputData.jsonDecode(t21.community_section)
		}
	end

	if t21.communitySection ~= nil then
		v514.kind = {
			type = "community_section",
			value = t1.CommunitySectionInputData.jsonDecode(t21.communitySection)
		}
	end

	if t21.moments_carousel ~= nil then
		v514.kind = {
			type = "moments_carousel",
			value = t1.MomentsCarouselInputData.jsonDecode(t21.moments_carousel)
		}
	end

	if t21.momentsCarousel ~= nil then
		v514.kind = {
			type = "moments_carousel",
			value = t1.MomentsCarouselInputData.jsonDecode(t21.momentsCarousel)
		}
	end

	if t21.text ~= nil then
		v514.kind = {
			type = "text",
			value = t1.TextInputData.jsonDecode(t21.text)
		}
	end

	if t21.vertical_feed ~= nil then
		v514.kind = {
			type = "vertical_feed",
			value = t1.VerticalFeedInputData.jsonDecode(t21.vertical_feed)
		}
	end

	if t21.verticalFeed ~= nil then
		v514.kind = {
			type = "vertical_feed",
			value = t1.VerticalFeedInputData.jsonDecode(t21.verticalFeed)
		}
	end

	if t21.page_header ~= nil then
		v514.kind = {
			type = "page_header",
			value = t1.PageHeaderInputData.jsonDecode(t21.page_header)
		}
	end

	if t21.pageHeader ~= nil then
		v514.kind = {
			type = "page_header",
			value = t1.PageHeaderInputData.jsonDecode(t21.pageHeader)
		}
	end

	if t21.experience_details_feed ~= nil then
		v514.kind = {
			type = "experience_details_feed",
			value = t1.ExperienceDetailsFeedInputData.jsonDecode(t21.experience_details_feed)
		}
	end

	if t21.experienceDetailsFeed ~= nil then
		v514.kind = {
			type = "experience_details_feed",
			value = t1.ExperienceDetailsFeedInputData.jsonDecode(t21.experienceDetailsFeed)
		}
	end

	if t21.experience_details_action_bar ~= nil then
		v514.kind = {
			type = "experience_details_action_bar",
			value = t1.ExperienceDetailsActionBarInputData.jsonDecode(t21.experience_details_action_bar)
		}
	end

	if t21.experienceDetailsActionBar ~= nil then
		v514.kind = {
			type = "experience_details_action_bar",
			value = t1.ExperienceDetailsActionBarInputData.jsonDecode(t21.experienceDetailsActionBar)
		}
	end

	if t21.experience_details_banner_image ~= nil then
		v514.kind = {
			type = "experience_details_banner_image",
			value = t1.ExperienceDetailsBannerImageInputData.jsonDecode(t21.experience_details_banner_image)
		}
	end

	if t21.experienceDetailsBannerImage ~= nil then
		v514.kind = {
			type = "experience_details_banner_image",
			value = t1.ExperienceDetailsBannerImageInputData.jsonDecode(t21.experienceDetailsBannerImage)
		}
	end

	if t21.experience_details_sticky_header ~= nil then
		v514.kind = {
			type = "experience_details_sticky_header",
			value = t1.ExperienceDetailsStickyHeaderInputData.jsonDecode(t21.experience_details_sticky_header)
		}
	end

	if t21.experienceDetailsStickyHeader ~= nil then
		v514.kind = {
			type = "experience_details_sticky_header",
			value = t1.ExperienceDetailsStickyHeaderInputData.jsonDecode(t21.experienceDetailsStickyHeader)
		}
	end

	if t21.event_details_feed ~= nil then
		v514.kind = {
			type = "event_details_feed",
			value = t1.EventDetailsFeedInputData.jsonDecode(t21.event_details_feed)
		}
	end

	if t21.eventDetailsFeed ~= nil then
		v514.kind = {
			type = "event_details_feed",
			value = t1.EventDetailsFeedInputData.jsonDecode(t21.eventDetailsFeed)
		}
	end

	if t21.event_details_action_bar ~= nil then
		v514.kind = {
			type = "event_details_action_bar",
			value = t1.EventDetailsActionBarInputData.jsonDecode(t21.event_details_action_bar)
		}
	end

	if t21.eventDetailsActionBar ~= nil then
		v514.kind = {
			type = "event_details_action_bar",
			value = t1.EventDetailsActionBarInputData.jsonDecode(t21.eventDetailsActionBar)
		}
	end

	if t21.event_attribution_row ~= nil then
		v514.kind = {
			type = "event_attribution_row",
			value = t1.EventAttributionRowInputData.jsonDecode(t21.event_attribution_row)
		}
	end

	if t21.eventAttributionRow ~= nil then
		v514.kind = {
			type = "event_attribution_row",
			value = t1.EventAttributionRowInputData.jsonDecode(t21.eventAttributionRow)
		}
	end

	if t21.event_description ~= nil then
		v514.kind = {
			type = "event_description",
			value = t1.EventDescriptionInputData.jsonDecode(t21.event_description)
		}
	end

	if t21.eventDescription ~= nil then
		v514.kind = {
			type = "event_description",
			value = t1.EventDescriptionInputData.jsonDecode(t21.eventDescription)
		}
	end

	if t21.event_info_table ~= nil then
		v514.kind = {
			type = "event_info_table",
			value = t1.EventInfoTableInputData.jsonDecode(t21.event_info_table)
		}
	end

	if t21.eventInfoTable ~= nil then
		v514.kind = {
			type = "event_info_table",
			value = t1.EventInfoTableInputData.jsonDecode(t21.eventInfoTable)
		}
	end

	if t21.event_details_sheet_full_bleed ~= nil then
		v514.kind = {
			type = "event_details_sheet_full_bleed",
			value = t1.EventDetailsSheetFullBleedInputData.jsonDecode(t21.event_details_sheet_full_bleed)
		}
	end

	if t21.eventDetailsSheetFullBleed ~= nil then
		v514.kind = {
			type = "event_details_sheet_full_bleed",
			value = t1.EventDetailsSheetFullBleedInputData.jsonDecode(t21.eventDetailsSheetFullBleed)
		}
	end

	if t21.event_notifications_modal ~= nil then
		v514.kind = {
			type = "event_notifications_modal",
			value = t1.EventNotificationsModalInputData.jsonDecode(t21.event_notifications_modal)
		}
	end

	if t21.eventNotificationsModal ~= nil then
		v514.kind = {
			type = "event_notifications_modal",
			value = t1.EventNotificationsModalInputData.jsonDecode(t21.eventNotificationsModal)
		}
	end

	if t21.dev_store_feed ~= nil then
		v514.kind = {
			type = "dev_store_feed",
			value = t1.DevStoreFeedInputData.jsonDecode(t21.dev_store_feed)
		}
	end

	if t21.devStoreFeed ~= nil then
		v514.kind = {
			type = "dev_store_feed",
			value = t1.DevStoreFeedInputData.jsonDecode(t21.devStoreFeed)
		}
	end

	if t21.charts_feed ~= nil then
		v514.kind = {
			type = "charts_feed",
			value = t1.ChartsFeedInputData.jsonDecode(t21.charts_feed)
		}
	end

	if t21.chartsFeed ~= nil then
		v514.kind = {
			type = "charts_feed",
			value = t1.ChartsFeedInputData.jsonDecode(t21.chartsFeed)
		}
	end

	if t21.filter_pills ~= nil then
		v514.kind = {
			type = "filter_pills",
			value = t1.FilterPillsInputData.jsonDecode(t21.filter_pills)
		}
	end

	if t21.filterPills ~= nil then
		v514.kind = {
			type = "filter_pills",
			value = t1.FilterPillsInputData.jsonDecode(t21.filterPills)
		}
	end

	if t21.sort_selector ~= nil then
		v514.kind = {
			type = "sort_selector",
			value = t1.SortSelectorInputData.jsonDecode(t21.sort_selector)
		}
	end

	if t21.sortSelector ~= nil then
		v514.kind = {
			type = "sort_selector",
			value = t1.SortSelectorInputData.jsonDecode(t21.sortSelector)
		}
	end

	if t21.genre_selector ~= nil then
		v514.kind = {
			type = "genre_selector",
			value = t1.ChartsGenreSelectorInputData.jsonDecode(t21.genre_selector)
		}
	end

	if t21.genreSelector ~= nil then
		v514.kind = {
			type = "genre_selector",
			value = t1.ChartsGenreSelectorInputData.jsonDecode(t21.genreSelector)
		}
	end

	if t21.marketplace_catalog_feed ~= nil then
		v514.kind = {
			type = "marketplace_catalog_feed",
			value = t1.UAMarketplaceCatalogFeedInputData.jsonDecode(t21.marketplace_catalog_feed)
		}
	end

	if t21.marketplaceCatalogFeed ~= nil then
		v514.kind = {
			type = "marketplace_catalog_feed",
			value = t1.UAMarketplaceCatalogFeedInputData.jsonDecode(t21.marketplaceCatalogFeed)
		}
	end

	if t21.marketplace_catalog_category_menu ~= nil then
		v514.kind = {
			type = "marketplace_catalog_category_menu",
			value = t1.UAMarketplaceCatalogCategoryMenuInputData.jsonDecode(t21.marketplace_catalog_category_menu)
		}
	end

	if t21.marketplaceCatalogCategoryMenu ~= nil then
		v514.kind = {
			type = "marketplace_catalog_category_menu",
			value = t1.UAMarketplaceCatalogCategoryMenuInputData.jsonDecode(t21.marketplaceCatalogCategoryMenu)
		}
	end

	if t21.marketplace_catalog_item_group ~= nil then
		v514.kind = {
			type = "marketplace_catalog_item_group",
			value = t1.UAMarketplaceCatalogItemGroupInputData.jsonDecode(t21.marketplace_catalog_item_group)
		}
	end

	if t21.marketplaceCatalogItemGroup ~= nil then
		v514.kind = {
			type = "marketplace_catalog_item_group",
			value = t1.UAMarketplaceCatalogItemGroupInputData.jsonDecode(t21.marketplaceCatalogItemGroup)
		}
	end

	if t21.marketplace_catalog_item_carousel ~= nil then
		v514.kind = {
			type = "marketplace_catalog_item_carousel",
			value = t1.UAMarketplaceCatalogItemCarouselInputData.jsonDecode(t21.marketplace_catalog_item_carousel)
		}
	end

	if t21.marketplaceCatalogItemCarousel ~= nil then
		v514.kind = {
			type = "marketplace_catalog_item_carousel",
			value = t1.UAMarketplaceCatalogItemCarouselInputData.jsonDecode(t21.marketplaceCatalogItemCarousel)
		}
	end

	if t21.marketplace_catalog_hero_unit ~= nil then
		v514.kind = {
			type = "marketplace_catalog_hero_unit",
			value = t1.UAMarketplaceCatalogHeroUnitInputData.jsonDecode(t21.marketplace_catalog_hero_unit)
		}
	end

	if t21.marketplaceCatalogHeroUnit ~= nil then
		v514.kind = {
			type = "marketplace_catalog_hero_unit",
			value = t1.UAMarketplaceCatalogHeroUnitInputData.jsonDecode(t21.marketplaceCatalogHeroUnit)
		}
	end

	if t21.catalog_item_grid ~= nil then
		v514.kind = {
			type = "catalog_item_grid",
			value = t1.CatalogItemGridInputData.jsonDecode(t21.catalog_item_grid)
		}
	end

	if t21.catalogItemGrid ~= nil then
		v514.kind = {
			type = "catalog_item_grid",
			value = t1.CatalogItemGridInputData.jsonDecode(t21.catalogItemGrid)
		}
	end

	if t21.marketplace_offer_modal ~= nil then
		v514.kind = {
			type = "marketplace_offer_modal",
			value = t1.MarketplaceOfferModalInputData.jsonDecode(t21.marketplace_offer_modal)
		}
	end

	if t21.marketplaceOfferModal ~= nil then
		v514.kind = {
			type = "marketplace_offer_modal",
			value = t1.MarketplaceOfferModalInputData.jsonDecode(t21.marketplaceOfferModal)
		}
	end

	if t21.search_results_feed ~= nil then
		v514.kind = {
			type = "search_results_feed",
			value = t1.SearchResultsFeedInputData.jsonDecode(t21.search_results_feed)
		}
	end

	if t21.searchResultsFeed ~= nil then
		v514.kind = {
			type = "search_results_feed",
			value = t1.SearchResultsFeedInputData.jsonDecode(t21.searchResultsFeed)
		}
	end

	if t21.power_search_ai_overview ~= nil then
		v514.kind = {
			type = "power_search_ai_overview",
			value = t1.PowerSearchAIOverviewInputData.jsonDecode(t21.power_search_ai_overview)
		}
	end

	if t21.powerSearchAiOverview ~= nil then
		v514.kind = {
			type = "power_search_ai_overview",
			value = t1.PowerSearchAIOverviewInputData.jsonDecode(t21.powerSearchAiOverview)
		}
	end

	if t21.experience_emphasis_tile ~= nil then
		v514.kind = {
			type = "experience_emphasis_tile",
			value = t1.ExperienceEmphasisTileInputData.jsonDecode(t21.experience_emphasis_tile)
		}
	end

	if t21.experienceEmphasisTile ~= nil then
		v514.kind = {
			type = "experience_emphasis_tile",
			value = t1.ExperienceEmphasisTileInputData.jsonDecode(t21.experienceEmphasisTile)
		}
	end

	if t21.option_selector_carousel ~= nil then
		v514.kind = {
			type = "option_selector_carousel",
			value = t1.OptionSelectorCarouselInputData.jsonDecode(t21.option_selector_carousel)
		}
	end

	if t21.optionSelectorCarousel ~= nil then
		v514.kind = {
			type = "option_selector_carousel",
			value = t1.OptionSelectorCarouselInputData.jsonDecode(t21.optionSelectorCarousel)
		}
	end

	if t21.party_chat_conversation_upsell ~= nil then
		v514.kind = {
			type = "party_chat_conversation_upsell",
			value = t1.PartyChatConversationUpsellInputData.jsonDecode(t21.party_chat_conversation_upsell)
		}
	end

	if t21.partyChatConversationUpsell ~= nil then
		v514.kind = {
			type = "party_chat_conversation_upsell",
			value = t1.PartyChatConversationUpsellInputData.jsonDecode(t21.partyChatConversationUpsell)
		}
	end

	if t21.pre_auth_landing_sticky_header ~= nil then
		v514.kind = {
			type = "pre_auth_landing_sticky_header",
			value = t1.PreAuthLandingStickyHeaderInputData.jsonDecode(t21.pre_auth_landing_sticky_header)
		}
	end

	if t21.preAuthLandingStickyHeader ~= nil then
		v514.kind = {
			type = "pre_auth_landing_sticky_header",
			value = t1.PreAuthLandingStickyHeaderInputData.jsonDecode(t21.preAuthLandingStickyHeader)
		}
	end

	return v514
end

t18.descriptor = {
	name = "PageEntryInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.PageEntryInputData"
}
t1.PageEntryInputData = t18
typeRegistry.default:register(t1.PageEntryInputData)

local t22 = {}

t22.__index = t22

function t22.new(t23: {[any]: any}?) -- line: 5983
	-- upvalues: t22 (copy)
	return (setmetatable({
		section_title = if t23 ~= nil and t23.section_title ~= nil then t23.section_title else "",
		badges = if t23 ~= nil and t23.badges ~= nil then t23.badges else {},
		collection_id = if t23 ~= nil and t23.collection_id ~= nil then t23.collection_id else "",
		collection_position = if t23 ~= nil and t23.collection_position ~= nil then t23.collection_position else "",
		universe_id = if t23 ~= nil and t23.universe_id ~= nil then t23.universe_id else ""
	}, t22))
end
function t22.encode(p16) -- line: 5995
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n11 = 0

	if p16.section_title ~= nil and p16.section_title ~= "" then
		local v519, v520 = proto.writeTag(buf, n11, 1, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeString(v519, v520, p16.section_title)
	end

	if p16.badges ~= nil and #p16.badges > 0 then
		for _, v522 in p16.badges do
			local v523 = v522:encode()
			local v524, v525 = proto.writeTag(buf, n11, 2, proto.wireTypes.lengthDelimited)

			buf, n11 = proto.writeBuffer(v524, v525, v523, buffer.len(v523))
		end
	end

	if p16.collection_id ~= nil and p16.collection_id ~= "" then
		local v526, v527 = proto.writeTag(buf, n11, 3, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeString(v526, v527, p16.collection_id)
	end

	if p16.collection_position ~= nil and p16.collection_position ~= "" then
		local v528, v529 = proto.writeTag(buf, n11, 4, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeString(v528, v529, p16.collection_position)
	end

	if p16.universe_id ~= nil and p16.universe_id ~= "" then
		local v530, v531 = proto.writeTag(buf, n11, 5, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeString(v530, v531, p16.universe_id)
	end

	local buf7 = buffer.create(n11)

	buffer.copy(buf7, 0, buf, 0, n11)

	return buf7
end
function t22.decode(p17: buffer) -- line: 6032
	-- upvalues: t22 (copy), proto (copy), t1 (copy)
	local v534 = t22.new()
	local n12 = 0

	while n12 < buffer.len(p17) do
		local v536, v537

		v536, v537, n12 = proto.readTag(p17, n12)

		if v537 == proto.wireTypes.varint then
			local v538

			v538, n12 = proto.readVarInt(p17, n12)
		elseif v537 == proto.wireTypes.lengthDelimited then
			if v536 == 1 then
				local v539

				v539, n12 = proto.readBuffer(p17, n12)
				v534.section_title = buffer.tostring(v539)
			elseif v536 == 2 then
				local v540

				v540, n12 = proto.readBuffer(p17, n12)
				table.insert(v534.badges, t1.BadgesGridInputData_BadgeInputData.decode(v540))
			elseif v536 == 3 then
				local v541

				v541, n12 = proto.readBuffer(p17, n12)
				v534.collection_id = buffer.tostring(v541)
			elseif v536 == 4 then
				local v542

				v542, n12 = proto.readBuffer(p17, n12)
				v534.collection_position = buffer.tostring(v542)
			elseif v536 == 5 then
				local v543

				v543, n12 = proto.readBuffer(p17, n12)
				v534.universe_id = buffer.tostring(v543)
			else
				local v544, v545 = proto.readVarInt(p17, n12)

				n12 = v545 + v544
			end
		elseif v537 == proto.wireTypes.i32 then
			local v546

			v546, n12 = proto.readFixed32(p17, n12)
		elseif v537 == proto.wireTypes.i64 then
			local v547

			v547, n12 = proto.readFixed64(p17, n12)
		else
			error("Unsupported wire type: " .. v537)
		end
	end

	return v534
end
function t22.jsonEncode(p18) -- line: 6095
	local t24 = {}

	if p18.section_title ~= nil and p18.section_title ~= "" then
		t24.sectionTitle = p18.section_title
	end

	if p18.badges ~= nil and #p18.badges > 0 then
		local t25 = {}

		for _, v552 in p18.badges do
			table.insert(t25, v552:jsonEncode())
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
function t22.jsonDecode(t26: {[any]: any}) -- line: 6125
	-- upvalues: t22 (copy), t1 (copy)
	local v554 = t22.new()

	if t26.section_title ~= nil then
		v554.section_title = t26.section_title
	end

	if t26.sectionTitle ~= nil then
		v554.section_title = t26.sectionTitle
	end

	if t26.badges ~= nil then
		local t27 = {}

		for _, v557 in t26.badges do
			table.insert(t27, t1.BadgesGridInputData_BadgeInputData.jsonDecode(v557))
		end

		v554.badges = t27
	end

	if t26.collection_id ~= nil then
		v554.collection_id = t26.collection_id
	end

	if t26.collectionId ~= nil then
		v554.collection_id = t26.collectionId
	end

	if t26.collection_position ~= nil then
		v554.collection_position = t26.collection_position
	end

	if t26.collectionPosition ~= nil then
		v554.collection_position = t26.collectionPosition
	end

	if t26.universe_id ~= nil then
		v554.universe_id = t26.universe_id
	end

	if t26.universeId ~= nil then
		v554.universe_id = t26.universeId
	end

	return v554
end

t22.descriptor = {
	name = "BadgesGridInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.BadgesGridInputData"
}
t1.BadgesGridInputData = t22
typeRegistry.default:register(t1.BadgesGridInputData)

local t28 = {}

t28.__index = t28

function t28.new(t29: {[any]: any}?) -- line: 6186
	-- upvalues: t28 (copy)
	return (setmetatable({
		badge_id = if t29 ~= nil and t29.badge_id ~= nil then t29.badge_id else ""
	}, t28))
end
function t28.encode(p19) -- line: 6194
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n13 = 0

	if p19.badge_id ~= nil and p19.badge_id ~= "" then
		local v562, v563 = proto.writeTag(buf, n13, 1, proto.wireTypes.lengthDelimited)

		buf, n13 = proto.writeString(v562, v563, p19.badge_id)
	end

	local buf8 = buffer.create(n13)

	buffer.copy(buf8, 0, buf, 0, n13)

	return buf8
end
function t28.decode(p20: buffer) -- line: 6208
	-- upvalues: t28 (copy), proto (copy)
	local v566 = t28.new()
	local n14 = 0

	while n14 < buffer.len(p20) do
		local v568, v569

		v568, v569, n14 = proto.readTag(p20, n14)

		if v569 == proto.wireTypes.varint then
			local v570

			v570, n14 = proto.readVarInt(p20, n14)
		elseif v569 == proto.wireTypes.lengthDelimited then
			if v568 == 1 then
				local v571

				v571, n14 = proto.readBuffer(p20, n14)
				v566.badge_id = buffer.tostring(v571)
			else
				local v572, v573 = proto.readVarInt(p20, n14)

				n14 = v573 + v572
			end
		elseif v569 == proto.wireTypes.i32 then
			local v574

			v574, n14 = proto.readFixed32(p20, n14)
		elseif v569 == proto.wireTypes.i64 then
			local v575

			v575, n14 = proto.readFixed64(p20, n14)
		else
			error("Unsupported wire type: " .. v569)
		end
	end

	return v566
end
function t28.jsonEncode(p21) -- line: 6251
	local t30 = {}

	if p21.badge_id ~= nil and p21.badge_id ~= "" then
		t30.badgeId = p21.badge_id
	end

	return t30
end
function t28.jsonDecode(t31: {[any]: any}) -- line: 6261
	-- upvalues: t28 (copy)
	local v579 = t28.new()

	if t31.badge_id ~= nil then
		v579.badge_id = t31.badge_id
	end

	if t31.badgeId ~= nil then
		v579.badge_id = t31.badgeId
	end

	return v579
end

t28.descriptor = {
	name = "BadgesGridInputData_BadgeInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.BadgeInputData"
}
t1.BadgesGridInputData_BadgeInputData = t28
typeRegistry.default:register(t1.BadgesGridInputData_BadgeInputData)

local t32 = {}

t32.__index = t32

function t32.new(t33: {[any]: any}?) -- line: 6291
	-- upvalues: t32 (copy)
	return (setmetatable({
		badge_id = if t33 ~= nil and t33.badge_id ~= nil then t33.badge_id else "",
		universe_id = if t33 ~= nil and t33.universe_id ~= nil then t33.universe_id else "",
		localized_literals = if t33 ~= nil and t33.localized_literals ~= nil then t33.localized_literals else nil,
		creator_key = if t33 ~= nil and t33.creator_key ~= nil then t33.creator_key else ""
	}, t32))
end
function t32.encode(p22) -- line: 6300
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n15 = 0

	if p22.badge_id ~= nil and p22.badge_id ~= "" then
		local v584, v585 = proto.writeTag(buf, n15, 1, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeString(v584, v585, p22.badge_id)
	end

	if p22.universe_id ~= nil and p22.universe_id ~= "" then
		local v586, v587 = proto.writeTag(buf, n15, 2, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeString(v586, v587, p22.universe_id)
	end

	if p22.localized_literals ~= nil then
		local v588 = p22.localized_literals:encode()
		local v589, v590 = proto.writeTag(buf, n15, 3, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeBuffer(v589, v590, v588, buffer.len(v588))
	end

	if p22.creator_key ~= nil and p22.creator_key ~= "" then
		local v591, v592 = proto.writeTag(buf, n15, 4, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeString(v591, v592, p22.creator_key)
	end

	local buf9 = buffer.create(n15)

	buffer.copy(buf9, 0, buf, 0, n15)

	return buf9
end
function t32.decode(p23: buffer) -- line: 6330
	-- upvalues: t32 (copy), proto (copy), t1 (copy)
	local v595 = t32.new()
	local n16 = 0

	while n16 < buffer.len(p23) do
		local v597, v598

		v597, v598, n16 = proto.readTag(p23, n16)

		if v598 == proto.wireTypes.varint then
			local v599

			v599, n16 = proto.readVarInt(p23, n16)
		elseif v598 == proto.wireTypes.lengthDelimited then
			if v597 == 1 then
				local v600

				v600, n16 = proto.readBuffer(p23, n16)
				v595.badge_id = buffer.tostring(v600)
			elseif v597 == 2 then
				local v601

				v601, n16 = proto.readBuffer(p23, n16)
				v595.universe_id = buffer.tostring(v601)
			elseif v597 == 3 then
				local v602

				v602, n16 = proto.readBuffer(p23, n16)
				v595.localized_literals = t1.BadgeDetailsInputData_LocalizedLiterals.decode(v602)
			elseif v597 == 4 then
				local v603

				v603, n16 = proto.readBuffer(p23, n16)
				v595.creator_key = buffer.tostring(v603)
			else
				local v604, v605 = proto.readVarInt(p23, n16)

				n16 = v605 + v604
			end
		elseif v598 == proto.wireTypes.i32 then
			local v606

			v606, n16 = proto.readFixed32(p23, n16)
		elseif v598 == proto.wireTypes.i64 then
			local v607

			v607, n16 = proto.readFixed64(p23, n16)
		else
			error("Unsupported wire type: " .. v598)
		end
	end

	return v595
end
function t32.jsonEncode(p24) -- line: 6388
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
function t32.jsonDecode(t35: {[any]: any}) -- line: 6410
	-- upvalues: t32 (copy), t1 (copy)
	local v611 = t32.new()

	if t35.badge_id ~= nil then
		v611.badge_id = t35.badge_id
	end

	if t35.badgeId ~= nil then
		v611.badge_id = t35.badgeId
	end

	if t35.universe_id ~= nil then
		v611.universe_id = t35.universe_id
	end

	if t35.universeId ~= nil then
		v611.universe_id = t35.universeId
	end

	if t35.localized_literals ~= nil then
		v611.localized_literals = t1.BadgeDetailsInputData_LocalizedLiterals.jsonDecode(t35.localized_literals)
	end

	if t35.localizedLiterals ~= nil then
		v611.localized_literals = t1.BadgeDetailsInputData_LocalizedLiterals.jsonDecode(t35.localizedLiterals)
	end

	if t35.creator_key ~= nil then
		v611.creator_key = t35.creator_key
	end

	if t35.creatorKey ~= nil then
		v611.creator_key = t35.creatorKey
	end

	return v611
end

t32.descriptor = {
	name = "BadgeDetailsInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.BadgeDetailsInputData"
}
t1.BadgeDetailsInputData = t32
typeRegistry.default:register(t1.BadgeDetailsInputData)

local t36 = {}

t36.__index = t36

function t36.new(t37: {[any]: any}?) -- line: 6464
	-- upvalues: t36 (copy)
	return (setmetatable({
		info_table = if t37 ~= nil and t37.info_table ~= nil then t37.info_table else nil,
		action_module = if t37 ~= nil and t37.action_module ~= nil then t37.action_module else nil,
		overflow_menu = if t37 ~= nil and t37.overflow_menu ~= nil then t37.overflow_menu else nil
	}, t36))
end
function t36.encode(p25) -- line: 6474
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n17 = 0

	if p25.info_table ~= nil then
		local v616 = p25.info_table:encode()
		local v617, v618 = proto.writeTag(buf, n17, 1, proto.wireTypes.lengthDelimited)

		buf, n17 = proto.writeBuffer(v617, v618, v616, buffer.len(v616))
	end

	if p25.action_module ~= nil then
		local v619 = p25.action_module:encode()
		local v620, v621 = proto.writeTag(buf, n17, 2, proto.wireTypes.lengthDelimited)

		buf, n17 = proto.writeBuffer(v620, v621, v619, buffer.len(v619))
	end

	if p25.overflow_menu ~= nil then
		local v622 = p25.overflow_menu:encode()
		local v623, v624 = proto.writeTag(buf, n17, 3, proto.wireTypes.lengthDelimited)

		buf, n17 = proto.writeBuffer(v623, v624, v622, buffer.len(v622))
	end

	local buf10 = buffer.create(n17)

	buffer.copy(buf10, 0, buf, 0, n17)

	return buf10
end
function t36.decode(p26: buffer) -- line: 6501
	-- upvalues: t36 (copy), proto (copy), t1 (copy)
	local v627 = t36.new()
	local n18 = 0

	while n18 < buffer.len(p26) do
		local v629, v630

		v629, v630, n18 = proto.readTag(p26, n18)

		if v630 == proto.wireTypes.varint then
			local v631

			v631, n18 = proto.readVarInt(p26, n18)
		elseif v630 == proto.wireTypes.lengthDelimited then
			if v629 == 1 then
				local v632

				v632, n18 = proto.readBuffer(p26, n18)
				v627.info_table = t1.BadgeDetailsInputData_LocalizedLiterals_InfoTable.decode(v632)
			elseif v629 == 2 then
				local v633

				v633, n18 = proto.readBuffer(p26, n18)
				v627.action_module = t1.BadgeDetailsInputData_LocalizedLiterals_ActionModule.decode(v633)
			elseif v629 == 3 then
				local v634

				v634, n18 = proto.readBuffer(p26, n18)
				v627.overflow_menu = t1.BadgeDetailsInputData_LocalizedLiterals_OverflowMenu.decode(v634)
			else
				local v635, v636 = proto.readVarInt(p26, n18)

				n18 = v636 + v635
			end
		elseif v630 == proto.wireTypes.i32 then
			local v637

			v637, n18 = proto.readFixed32(p26, n18)
		elseif v630 == proto.wireTypes.i64 then
			local v638

			v638, n18 = proto.readFixed64(p26, n18)
		else
			error("Unsupported wire type: " .. v630)
		end
	end

	return v627
end
function t36.jsonEncode(p27) -- line: 6554
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
function t36.jsonDecode(t39: {[any]: any}) -- line: 6572
	-- upvalues: t36 (copy), t1 (copy)
	local v642 = t36.new()

	if t39.info_table ~= nil then
		v642.info_table = t1.BadgeDetailsInputData_LocalizedLiterals_InfoTable.jsonDecode(t39.info_table)
	end

	if t39.infoTable ~= nil then
		v642.info_table = t1.BadgeDetailsInputData_LocalizedLiterals_InfoTable.jsonDecode(t39.infoTable)
	end

	if t39.action_module ~= nil then
		v642.action_module = t1.BadgeDetailsInputData_LocalizedLiterals_ActionModule.jsonDecode(t39.action_module)
	end

	if t39.actionModule ~= nil then
		v642.action_module = t1.BadgeDetailsInputData_LocalizedLiterals_ActionModule.jsonDecode(t39.actionModule)
	end

	if t39.overflow_menu ~= nil then
		v642.overflow_menu = t1.BadgeDetailsInputData_LocalizedLiterals_OverflowMenu.jsonDecode(t39.overflow_menu)
	end

	if t39.overflowMenu ~= nil then
		v642.overflow_menu = t1.BadgeDetailsInputData_LocalizedLiterals_OverflowMenu.jsonDecode(t39.overflowMenu)
	end

	return v642
end

t36.descriptor = {
	name = "BadgeDetailsInputData_LocalizedLiterals",
	fullName = "roblox.apppageplatform.shared.v1beta1.LocalizedLiterals"
}
t1.BadgeDetailsInputData_LocalizedLiterals = t36
typeRegistry.default:register(t1.BadgeDetailsInputData_LocalizedLiterals)

local t40 = {}

t40.__index = t40

function t40.new(t41: {[any]: any}?) -- line: 6623
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
function t40.encode(p28) -- line: 6642
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n19 = 0

	if p28.type_label ~= nil and p28.type_label ~= "" then
		local v647, v648 = proto.writeTag(buf, n19, 1, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeString(v647, v648, p28.type_label)
	end

	if p28.earned_label ~= nil and p28.earned_label ~= "" then
		local v649, v650 = proto.writeTag(buf, n19, 2, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeString(v649, v650, p28.earned_label)
	end

	if p28.updated_label ~= nil and p28.updated_label ~= "" then
		local v651, v652 = proto.writeTag(buf, n19, 3, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeString(v651, v652, p28.updated_label)
	end

	if p28.experience_label ~= nil and p28.experience_label ~= "" then
		local v653, v654 = proto.writeTag(buf, n19, 4, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeString(v653, v654, p28.experience_label)
	end

	if p28.rarity_label ~= nil and p28.rarity_label ~= "" then
		local v655, v656 = proto.writeTag(buf, n19, 5, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeString(v655, v656, p28.rarity_label)
	end

	if p28.won_yesterday_label ~= nil and p28.won_yesterday_label ~= "" then
		local v657, v658 = proto.writeTag(buf, n19, 6, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeString(v657, v658, p28.won_yesterday_label)
	end

	if p28.won_ever_label ~= nil and p28.won_ever_label ~= "" then
		local v659, v660 = proto.writeTag(buf, n19, 7, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeString(v659, v660, p28.won_ever_label)
	end

	local buf11 = buffer.create(n19)

	buffer.copy(buf11, 0, buf, 0, n19)

	return buf11
end
function t40.decode(p29: buffer) -- line: 6688
	-- upvalues: t40 (copy), proto (copy)
	local v663 = t40.new()
	local n20 = 0

	while n20 < buffer.len(p29) do
		local v665, v666

		v665, v666, n20 = proto.readTag(p29, n20)

		if v666 == proto.wireTypes.varint then
			local v667

			v667, n20 = proto.readVarInt(p29, n20)
		elseif v666 == proto.wireTypes.lengthDelimited then
			if v665 == 1 then
				local v668

				v668, n20 = proto.readBuffer(p29, n20)
				v663.type_label = buffer.tostring(v668)
			elseif v665 == 2 then
				local v669

				v669, n20 = proto.readBuffer(p29, n20)
				v663.earned_label = buffer.tostring(v669)
			elseif v665 == 3 then
				local v670

				v670, n20 = proto.readBuffer(p29, n20)
				v663.updated_label = buffer.tostring(v670)
			elseif v665 == 4 then
				local v671

				v671, n20 = proto.readBuffer(p29, n20)
				v663.experience_label = buffer.tostring(v671)
			elseif v665 == 5 then
				local v672

				v672, n20 = proto.readBuffer(p29, n20)
				v663.rarity_label = buffer.tostring(v672)
			elseif v665 == 6 then
				local v673

				v673, n20 = proto.readBuffer(p29, n20)
				v663.won_yesterday_label = buffer.tostring(v673)
			elseif v665 == 7 then
				local v674

				v674, n20 = proto.readBuffer(p29, n20)
				v663.won_ever_label = buffer.tostring(v674)
			else
				local v675, v676 = proto.readVarInt(p29, n20)

				n20 = v676 + v675
			end
		elseif v666 == proto.wireTypes.i32 then
			local v677

			v677, n20 = proto.readFixed32(p29, n20)
		elseif v666 == proto.wireTypes.i64 then
			local v678

			v678, n20 = proto.readFixed64(p29, n20)
		else
			error("Unsupported wire type: " .. v666)
		end
	end

	return v663
end
function t40.jsonEncode(p30) -- line: 6763
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
function t40.jsonDecode(t43: {[any]: any}) -- line: 6799
	-- upvalues: t40 (copy)
	local v682 = t40.new()

	if t43.type_label ~= nil then
		v682.type_label = t43.type_label
	end

	if t43.typeLabel ~= nil then
		v682.type_label = t43.typeLabel
	end

	if t43.earned_label ~= nil then
		v682.earned_label = t43.earned_label
	end

	if t43.earnedLabel ~= nil then
		v682.earned_label = t43.earnedLabel
	end

	if t43.updated_label ~= nil then
		v682.updated_label = t43.updated_label
	end

	if t43.updatedLabel ~= nil then
		v682.updated_label = t43.updatedLabel
	end

	if t43.experience_label ~= nil then
		v682.experience_label = t43.experience_label
	end

	if t43.experienceLabel ~= nil then
		v682.experience_label = t43.experienceLabel
	end

	if t43.rarity_label ~= nil then
		v682.rarity_label = t43.rarity_label
	end

	if t43.rarityLabel ~= nil then
		v682.rarity_label = t43.rarityLabel
	end

	if t43.won_yesterday_label ~= nil then
		v682.won_yesterday_label = t43.won_yesterday_label
	end

	if t43.wonYesterdayLabel ~= nil then
		v682.won_yesterday_label = t43.wonYesterdayLabel
	end

	if t43.won_ever_label ~= nil then
		v682.won_ever_label = t43.won_ever_label
	end

	if t43.wonEverLabel ~= nil then
		v682.won_ever_label = t43.wonEverLabel
	end

	return v682
end

t40.descriptor = {
	name = "BadgeDetailsInputData_LocalizedLiterals_InfoTable",
	fullName = "roblox.apppageplatform.shared.v1beta1.InfoTable"
}
t1.BadgeDetailsInputData_LocalizedLiterals_InfoTable = t40
typeRegistry.default:register(t1.BadgeDetailsInputData_LocalizedLiterals_InfoTable)

local t44 = {}

t44.__index = t44

function t44.new(t45: {[any]: any}?) -- line: 6879
	-- upvalues: t44 (copy)
	return (setmetatable({
		share = if t45 ~= nil and t45.share ~= nil then t45.share else "",
		report = if t45 ~= nil and t45.report ~= nil then t45.report else ""
	}, t44))
end
function t44.encode(p31) -- line: 6891
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n21 = 0

	if p31.share ~= nil and p31.share ~= "" then
		local v687, v688 = proto.writeTag(buf, n21, 1, proto.wireTypes.lengthDelimited)

		buf, n21 = proto.writeString(v687, v688, p31.share)
	end

	if p31.report ~= nil and p31.report ~= "" then
		local v689, v690 = proto.writeTag(buf, n21, 2, proto.wireTypes.lengthDelimited)

		buf, n21 = proto.writeString(v689, v690, p31.report)
	end

	local buf12 = buffer.create(n21)

	buffer.copy(buf12, 0, buf, 0, n21)

	return buf12
end
function t44.decode(p32: buffer) -- line: 6912
	-- upvalues: t44 (copy), proto (copy)
	local v693 = t44.new()
	local n22 = 0

	while n22 < buffer.len(p32) do
		local v695, v696

		v695, v696, n22 = proto.readTag(p32, n22)

		if v696 == proto.wireTypes.varint then
			local v697

			v697, n22 = proto.readVarInt(p32, n22)
		elseif v696 == proto.wireTypes.lengthDelimited then
			if v695 == 1 then
				local v698

				v698, n22 = proto.readBuffer(p32, n22)
				v693.share = buffer.tostring(v698)
			elseif v695 == 2 then
				local v699

				v699, n22 = proto.readBuffer(p32, n22)
				v693.report = buffer.tostring(v699)
			else
				local v700, v701 = proto.readVarInt(p32, n22)

				n22 = v701 + v700
			end
		elseif v696 == proto.wireTypes.i32 then
			local v702

			v702, n22 = proto.readFixed32(p32, n22)
		elseif v696 == proto.wireTypes.i64 then
			local v703

			v703, n22 = proto.readFixed64(p32, n22)
		else
			error("Unsupported wire type: " .. v696)
		end
	end

	return v693
end
function t44.jsonEncode(p33) -- line: 6962
	local t46 = {}

	if p33.share ~= nil and p33.share ~= "" then
		t46.share = p33.share
	end

	if p33.report ~= nil and p33.report ~= "" then
		t46.report = p33.report
	end

	return t46
end
function t44.jsonDecode(t47: {[any]: any}) -- line: 6978
	-- upvalues: t44 (copy)
	local v707 = t44.new()

	if t47.share ~= nil then
		v707.share = t47.share
	end

	if t47.report ~= nil then
		v707.report = t47.report
	end

	return v707
end

t44.descriptor = {
	name = "BadgeDetailsInputData_LocalizedLiterals_ActionModule",
	fullName = "roblox.apppageplatform.shared.v1beta1.ActionModule"
}
t1.BadgeDetailsInputData_LocalizedLiterals_ActionModule = t44
typeRegistry.default:register(t1.BadgeDetailsInputData_LocalizedLiterals_ActionModule)

local t48 = {}

t48.__index = t48

function t48.new(t49: {[any]: any}?) -- line: 7010
	-- upvalues: t48 (copy)
	return (setmetatable({
		report = if t49 ~= nil and t49.report ~= nil then t49.report else "",
		remove = if t49 ~= nil and t49.remove ~= nil then t49.remove else ""
	}, t48))
end
function t48.encode(p34) -- line: 7022
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n23 = 0

	if p34.report ~= nil and p34.report ~= "" then
		local v712, v713 = proto.writeTag(buf, n23, 1, proto.wireTypes.lengthDelimited)

		buf, n23 = proto.writeString(v712, v713, p34.report)
	end

	if p34.remove ~= nil and p34.remove ~= "" then
		local v714, v715 = proto.writeTag(buf, n23, 2, proto.wireTypes.lengthDelimited)

		buf, n23 = proto.writeString(v714, v715, p34.remove)
	end

	local buf13 = buffer.create(n23)

	buffer.copy(buf13, 0, buf, 0, n23)

	return buf13
end
function t48.decode(p35: buffer) -- line: 7043
	-- upvalues: t48 (copy), proto (copy)
	local v718 = t48.new()
	local n24 = 0

	while n24 < buffer.len(p35) do
		local v720, v721

		v720, v721, n24 = proto.readTag(p35, n24)

		if v721 == proto.wireTypes.varint then
			local v722

			v722, n24 = proto.readVarInt(p35, n24)
		elseif v721 == proto.wireTypes.lengthDelimited then
			if v720 == 1 then
				local v723

				v723, n24 = proto.readBuffer(p35, n24)
				v718.report = buffer.tostring(v723)
			elseif v720 == 2 then
				local v724

				v724, n24 = proto.readBuffer(p35, n24)
				v718.remove = buffer.tostring(v724)
			else
				local v725, v726 = proto.readVarInt(p35, n24)

				n24 = v726 + v725
			end
		elseif v721 == proto.wireTypes.i32 then
			local v727

			v727, n24 = proto.readFixed32(p35, n24)
		elseif v721 == proto.wireTypes.i64 then
			local v728

			v728, n24 = proto.readFixed64(p35, n24)
		else
			error("Unsupported wire type: " .. v721)
		end
	end

	return v718
end
function t48.jsonEncode(p36) -- line: 7093
	local t50 = {}

	if p36.report ~= nil and p36.report ~= "" then
		t50.report = p36.report
	end

	if p36.remove ~= nil and p36.remove ~= "" then
		t50.remove = p36.remove
	end

	return t50
end
function t48.jsonDecode(t51: {[any]: any}) -- line: 7109
	-- upvalues: t48 (copy)
	local v732 = t48.new()

	if t51.report ~= nil then
		v732.report = t51.report
	end

	if t51.remove ~= nil then
		v732.remove = t51.remove
	end

	return v732
end

t48.descriptor = {
	name = "BadgeDetailsInputData_LocalizedLiterals_OverflowMenu",
	fullName = "roblox.apppageplatform.shared.v1beta1.OverflowMenu"
}
t1.BadgeDetailsInputData_LocalizedLiterals_OverflowMenu = t48
typeRegistry.default:register(t1.BadgeDetailsInputData_LocalizedLiterals_OverflowMenu)

local t52 = {}

t52.__index = t52

function t52.new(_: {[any]: any}?) -- line: 7140
	-- upvalues: t52 (copy)
	return (setmetatable({}, t52))
end
function t52.encode(_) -- line: 7144
	local buf = buffer.create(0)
	local buf14 = buffer.create(0)

	buffer.copy(buf14, 0, buf, 0, 0)

	return buf14
end
function t52.decode(p38: buffer) -- line: 7153
	-- upvalues: t52 (copy), proto (copy)
	local v738 = t52.new()
	local n25 = 0

	while n25 < buffer.len(p38) do
		local v740, v741

		v740, v741, n25 = proto.readTag(p38, n25)

		if v741 == proto.wireTypes.varint then
			local v742

			v742, n25 = proto.readVarInt(p38, n25)
		elseif v741 == proto.wireTypes.lengthDelimited then
			local v743, v744 = proto.readVarInt(p38, n25)

			n25 = v744 + v743
		elseif v741 == proto.wireTypes.i32 then
			local v745

			v745, n25 = proto.readFixed32(p38, n25)
		elseif v741 == proto.wireTypes.i64 then
			local v746

			v746, n25 = proto.readFixed64(p38, n25)
		else
			error("Unsupported wire type: " .. v741)
		end
	end

	return v738
end
function t52.jsonEncode(_) -- line: 7191
	return {}
end
function t52.jsonDecode(_: {[any]: any}) -- line: 7197
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

function t55.new(t56: {[any]: any}?) -- line: 7217
	-- upvalues: t55 (copy)
	return (setmetatable({
		universe_id = if t56 ~= nil and t56.universe_id ~= nil then t56.universe_id else "",
		creator_key = if t56 ~= nil and t56.creator_key ~= nil then t56.creator_key else "",
		entry_map = if t56 ~= nil and t56.entry_map ~= nil then t56.entry_map else {},
		entry_order = if t56 ~= nil and t56.entry_order ~= nil then t56.entry_order else {},
		entry_order_map = if t56 ~= nil and t56.entry_order_map ~= nil then t56.entry_order_map else {}
	}, t55))
end
function t55.encode(p40) -- line: 7229
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n26 = 0

	if p40.universe_id ~= nil and p40.universe_id ~= "" then
		local v753, v754 = proto.writeTag(buf, n26, 1, proto.wireTypes.lengthDelimited)

		buf, n26 = proto.writeString(v753, v754, p40.universe_id)
	end

	if p40.creator_key ~= nil and p40.creator_key ~= "" then
		local v755, v756 = proto.writeTag(buf, n26, 2, proto.wireTypes.lengthDelimited)

		buf, n26 = proto.writeString(v755, v756, p40.creator_key)
	end

	if p40.entry_map ~= nil and next(p40.entry_map) ~= nil then
		for v757, v758 in p40.entry_map do
			local buf15 = buffer.create(0)
			local v760, v761 = proto.writeTag(buf15, 0, 1, proto.wireTypes.lengthDelimited)
			local v762, v763 = proto.writeString(v760, v761, v757)
			local v764 = v758:encode()
			local v765, v766 = proto.writeTag(v762, v763, 2, proto.wireTypes.lengthDelimited)
			local v767, v768 = proto.writeBuffer(v765, v766, v764, buffer.len(v764))
			local v769, v770 = proto.writeTag(buf, n26, 3, proto.wireTypes.lengthDelimited)

			buf, n26 = proto.writeBuffer(v769, v770, v767, v768)
		end
	end

	if p40.entry_order ~= nil and #p40.entry_order > 0 then
		for _, v772 in p40.entry_order do
			local v773, v774 = proto.writeTag(buf, n26, 4, proto.wireTypes.lengthDelimited)

			buf, n26 = proto.writeString(v773, v774, v772)
		end
	end

	if p40.entry_order_map ~= nil and next(p40.entry_order_map) ~= nil then
		for v775, v776 in p40.entry_order_map do
			local buf16 = buffer.create(0)
			local v778, v779 = proto.writeTag(buf16, 0, 1, proto.wireTypes.lengthDelimited)
			local v780, v781 = proto.writeString(v778, v779, v775)
			local v782 = v776:encode()
			local v783, v784 = proto.writeTag(v780, v781, 2, proto.wireTypes.lengthDelimited)
			local v785, v786 = proto.writeBuffer(v783, v784, v782, buffer.len(v782))
			local v787, v788 = proto.writeTag(buf, n26, 5, proto.wireTypes.lengthDelimited)

			buf, n26 = proto.writeBuffer(v787, v788, v785, v786)
		end
	end

	local buf17 = buffer.create(n26)

	buffer.copy(buf17, 0, buf, 0, n26)

	return buf17
end
function t55.decode(p41: buffer) -- line: 7283
	-- upvalues: t55 (copy), proto (copy), t1 (copy)
	local v791 = t55.new()
	local n27 = 0

	while n27 < buffer.len(p41) do
		local v793, v794

		v793, v794, n27 = proto.readTag(p41, n27)

		if v794 == proto.wireTypes.varint then
			local v795

			v795, n27 = proto.readVarInt(p41, n27)
		elseif v794 == proto.wireTypes.lengthDelimited then
			if v793 == 1 then
				local v796

				v796, n27 = proto.readBuffer(p41, n27)
				v791.universe_id = buffer.tostring(v796)
			elseif v793 == 2 then
				local v797

				v797, n27 = proto.readBuffer(p41, n27)
				v791.creator_key = buffer.tostring(v797)
			elseif v793 == 3 then
				local v798

				v798, n27 = proto.readBuffer(p41, n27)

				local v799 = t1.ExperienceDetailsFeedInputData_EntryMapEntry.decode(v798)
				local v800 = t1.FeedEntry.new()

				v791.entry_map[v799.key or ""] = v799.value or v800
			elseif v793 == 4 then
				local v801

				v801, n27 = proto.readBuffer(p41, n27)
				table.insert(v791.entry_order, buffer.tostring(v801))
			elseif v793 == 5 then
				local v802

				v802, n27 = proto.readBuffer(p41, n27)

				local v803 = t1.ExperienceDetailsFeedInputData_EntryOrderMapEntry.decode(v802)
				local v804 = t1.EntryOrder.new()

				v791.entry_order_map[v803.key or ""] = v803.value or v804
			else
				local v805, v806 = proto.readVarInt(p41, n27)

				n27 = v806 + v805
			end
		elseif v794 == proto.wireTypes.i32 then
			local v807

			v807, n27 = proto.readFixed32(p41, n27)
		elseif v794 == proto.wireTypes.i64 then
			local v808

			v808, n27 = proto.readFixed64(p41, n27)
		else
			error("Unsupported wire type: " .. v794)
		end
	end

	return v791
end
function t55.jsonEncode(p42) -- line: 7360
	local t57 = {}

	if p42.universe_id ~= nil and p42.universe_id ~= "" then
		t57.universeId = p42.universe_id
	end

	if p42.creator_key ~= nil and p42.creator_key ~= "" then
		t57.creatorKey = p42.creator_key
	end

	if p42.entry_map ~= nil and next(p42.entry_map) ~= nil then
		local t58 = {}

		for v812, v813 in p42.entry_map do
			t58[v812] = v813:jsonEncode()
		end

		t57.entryMap = t58
	end

	if p42.entry_order ~= nil and #p42.entry_order > 0 then
		local t59 = {}

		for _, v816 in p42.entry_order do
			table.insert(t59, v816)
		end

		t57.entryOrder = t59
	end

	if p42.entry_order_map ~= nil and next(p42.entry_order_map) ~= nil then
		local t60 = {}

		for v818, v819 in p42.entry_order_map do
			t60[v818] = v819:jsonEncode()
		end

		t57.entryOrderMap = t60
	end

	return t57
end
function t55.jsonDecode(t61: {[any]: any}) -- line: 7398
	-- upvalues: t55 (copy), t1 (copy)
	local v821 = t55.new()

	if t61.universe_id ~= nil then
		v821.universe_id = t61.universe_id
	end

	if t61.universeId ~= nil then
		v821.universe_id = t61.universeId
	end

	if t61.creator_key ~= nil then
		v821.creator_key = t61.creator_key
	end

	if t61.creatorKey ~= nil then
		v821.creator_key = t61.creatorKey
	end

	if t61.entry_map ~= nil then
		local t62 = {}

		for v823, v824 in t61.entry_map do
			t62[v823] = t1.FeedEntry.jsonDecode(v824)
		end

		v821.entry_map = t62
	end

	if t61.entryMap ~= nil then
		local t63 = {}

		for v826, v827 in t61.entryMap do
			t63[v826] = t1.FeedEntry.jsonDecode(v827)
		end

		v821.entry_map = t63
	end

	if t61.entry_order ~= nil then
		local t64 = {}

		for _, v830 in t61.entry_order do
			table.insert(t64, v830)
		end

		v821.entry_order = t64
	end

	if t61.entryOrder ~= nil then
		local t65 = {}

		for _, v833 in t61.entryOrder do
			table.insert(t65, v833)
		end

		v821.entry_order = t65
	end

	if t61.entry_order_map ~= nil then
		local t66 = {}

		for v835, v836 in t61.entry_order_map do
			t66[v835] = t1.EntryOrder.jsonDecode(v836)
		end

		v821.entry_order_map = t66
	end

	if t61.entryOrderMap ~= nil then
		local t67 = {}

		for v838, v839 in t61.entryOrderMap do
			t67[v838] = t1.EntryOrder.jsonDecode(v839)
		end

		v821.entry_order_map = t67
	end

	return v821
end

t55.descriptor = {
	name = "ExperienceDetailsFeedInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceDetailsFeedInputData"
}
t1.ExperienceDetailsFeedInputData = t55
typeRegistry.default:register(t1.ExperienceDetailsFeedInputData)

local t68 = {}

t68.__index = t68

function t68.new(t69: {[any]: any}?) -- line: 7488
	-- upvalues: t68 (copy)
	return (setmetatable({
		key = if t69 ~= nil and t69.key ~= nil then t69.key else "",
		value = if t69 ~= nil and t69.value ~= nil then t69.value else nil
	}, t68))
end
function t68.encode(p43) -- line: 7497
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n28 = 0

	if p43.key ~= nil and p43.key ~= "" then
		local v844, v845 = proto.writeTag(buf, n28, 1, proto.wireTypes.lengthDelimited)

		buf, n28 = proto.writeString(v844, v845, p43.key)
	end

	if p43.value ~= nil then
		local v846 = p43.value:encode()
		local v847, v848 = proto.writeTag(buf, n28, 2, proto.wireTypes.lengthDelimited)

		buf, n28 = proto.writeBuffer(v847, v848, v846, buffer.len(v846))
	end

	local buf18 = buffer.create(n28)

	buffer.copy(buf18, 0, buf, 0, n28)

	return buf18
end
function t68.decode(p44: buffer) -- line: 7519
	-- upvalues: t68 (copy), proto (copy), t1 (copy)
	local v851 = t68.new()
	local n29 = 0

	while n29 < buffer.len(p44) do
		local v853, v854

		v853, v854, n29 = proto.readTag(p44, n29)

		if v854 == proto.wireTypes.varint then
			local v855

			v855, n29 = proto.readVarInt(p44, n29)
		elseif v854 == proto.wireTypes.lengthDelimited then
			if v853 == 1 then
				local v856

				v856, n29 = proto.readBuffer(p44, n29)
				v851.key = buffer.tostring(v856)
			elseif v853 == 2 then
				local v857

				v857, n29 = proto.readBuffer(p44, n29)
				v851.value = t1.FeedEntry.decode(v857)
			else
				local v858, v859 = proto.readVarInt(p44, n29)

				n29 = v859 + v858
			end
		elseif v854 == proto.wireTypes.i32 then
			local v860

			v860, n29 = proto.readFixed32(p44, n29)
		elseif v854 == proto.wireTypes.i64 then
			local v861

			v861, n29 = proto.readFixed64(p44, n29)
		else
			error("Unsupported wire type: " .. v854)
		end
	end

	return v851
end
function t68.jsonEncode(p45) -- line: 7569
	local t70 = {}

	if p45.key ~= nil and p45.key ~= "" then
		t70.key = p45.key
	end

	if p45.value ~= nil then
		t70.value = p45.value:jsonEncode()
	end

	return t70
end
function t68.jsonDecode(t71: {[any]: any}) -- line: 7585
	-- upvalues: t68 (copy), t1 (copy)
	local v865 = t68.new()

	if t71.key ~= nil then
		v865.key = t71.key
	end

	if t71.value ~= nil then
		v865.value = t1.FeedEntry.jsonDecode(t71.value)
	end

	return v865
end

t68.descriptor = {
	name = "ExperienceDetailsFeedInputData_EntryMapEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryMapEntry"
}
t1.ExperienceDetailsFeedInputData_EntryMapEntry = t68
typeRegistry.default:register(t1.ExperienceDetailsFeedInputData_EntryMapEntry)

local t72 = {}

t72.__index = t72

function t72.new(t73: {[any]: any}?) -- line: 7616
	-- upvalues: t72 (copy)
	return (setmetatable({
		key = if t73 ~= nil and t73.key ~= nil then t73.key else "",
		value = if t73 ~= nil and t73.value ~= nil then t73.value else nil
	}, t72))
end
function t72.encode(p46) -- line: 7628
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n30 = 0

	if p46.key ~= nil and p46.key ~= "" then
		local v870, v871 = proto.writeTag(buf, n30, 1, proto.wireTypes.lengthDelimited)

		buf, n30 = proto.writeString(v870, v871, p46.key)
	end

	if p46.value ~= nil then
		local v872 = p46.value:encode()
		local v873, v874 = proto.writeTag(buf, n30, 2, proto.wireTypes.lengthDelimited)

		buf, n30 = proto.writeBuffer(v873, v874, v872, buffer.len(v872))
	end

	local buf19 = buffer.create(n30)

	buffer.copy(buf19, 0, buf, 0, n30)

	return buf19
end
function t72.decode(p47: buffer) -- line: 7650
	-- upvalues: t72 (copy), proto (copy), t1 (copy)
	local v877 = t72.new()
	local n31 = 0

	while n31 < buffer.len(p47) do
		local v879, v880

		v879, v880, n31 = proto.readTag(p47, n31)

		if v880 == proto.wireTypes.varint then
			local v881

			v881, n31 = proto.readVarInt(p47, n31)
		elseif v880 == proto.wireTypes.lengthDelimited then
			if v879 == 1 then
				local v882

				v882, n31 = proto.readBuffer(p47, n31)
				v877.key = buffer.tostring(v882)
			elseif v879 == 2 then
				local v883

				v883, n31 = proto.readBuffer(p47, n31)
				v877.value = t1.EntryOrder.decode(v883)
			else
				local v884, v885 = proto.readVarInt(p47, n31)

				n31 = v885 + v884
			end
		elseif v880 == proto.wireTypes.i32 then
			local v886

			v886, n31 = proto.readFixed32(p47, n31)
		elseif v880 == proto.wireTypes.i64 then
			local v887

			v887, n31 = proto.readFixed64(p47, n31)
		else
			error("Unsupported wire type: " .. v880)
		end
	end

	return v877
end
function t72.jsonEncode(p48) -- line: 7700
	local t74 = {}

	if p48.key ~= nil and p48.key ~= "" then
		t74.key = p48.key
	end

	if p48.value ~= nil then
		t74.value = p48.value:jsonEncode()
	end

	return t74
end
function t72.jsonDecode(t75: {[any]: any}) -- line: 7716
	-- upvalues: t72 (copy), t1 (copy)
	local v891 = t72.new()

	if t75.key ~= nil then
		v891.key = t75.key
	end

	if t75.value ~= nil then
		v891.value = t1.EntryOrder.jsonDecode(t75.value)
	end

	return v891
end

t72.descriptor = {
	name = "ExperienceDetailsFeedInputData_EntryOrderMapEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryOrderMapEntry"
}
t1.ExperienceDetailsFeedInputData_EntryOrderMapEntry = t72
typeRegistry.default:register(t1.ExperienceDetailsFeedInputData_EntryOrderMapEntry)

local t76 = {}

t76.__index = t76

function t76.new(t77: {[any]: any}?) -- line: 7747
	-- upvalues: t76 (copy)
	return (setmetatable({
		items = if t77 ~= nil and t77.items ~= nil then t77.items else {}
	}, t76))
end
function t76.encode(p49) -- line: 7753
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n32 = 0

	if p49.items ~= nil and #p49.items > 0 then
		for _, v897 in p49.items do
			local v898, v899 = proto.writeTag(buf, n32, 1, proto.wireTypes.lengthDelimited)

			buf, n32 = proto.writeString(v898, v899, v897)
		end
	end

	local buf20 = buffer.create(n32)

	buffer.copy(buf20, 0, buf, 0, n32)

	return buf20
end
function t76.decode(p50: buffer) -- line: 7769
	-- upvalues: t76 (copy), proto (copy)
	local v902 = t76.new()
	local n33 = 0

	while n33 < buffer.len(p50) do
		local v904, v905

		v904, v905, n33 = proto.readTag(p50, n33)

		if v905 == proto.wireTypes.varint then
			local v906

			v906, n33 = proto.readVarInt(p50, n33)
		elseif v905 == proto.wireTypes.lengthDelimited then
			if v904 == 1 then
				local v907

				v907, n33 = proto.readBuffer(p50, n33)
				table.insert(v902.items, buffer.tostring(v907))
			else
				local v908, v909 = proto.readVarInt(p50, n33)

				n33 = v909 + v908
			end
		elseif v905 == proto.wireTypes.i32 then
			local v910

			v910, n33 = proto.readFixed32(p50, n33)
		elseif v905 == proto.wireTypes.i64 then
			local v911

			v911, n33 = proto.readFixed64(p50, n33)
		else
			error("Unsupported wire type: " .. v905)
		end
	end

	return v902
end
function t76.jsonEncode(p51) -- line: 7812
	local t78 = {}

	if p51.items ~= nil and #p51.items > 0 then
		local t79 = {}

		for _, v916 in p51.items do
			table.insert(t79, v916)
		end

		t78.items = t79
	end

	return t78
end
function t76.jsonDecode(t80: {[any]: any}) -- line: 7826
	-- upvalues: t76 (copy)
	local v918 = t76.new()

	if t80.items ~= nil then
		local t81 = {}

		for _, v921 in t80.items do
			table.insert(t81, v921)
		end

		v918.items = t81
	end

	return v918
end

t76.descriptor = {
	name = "EntryOrder",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryOrder"
}
t1.EntryOrder = t76
typeRegistry.default:register(t1.EntryOrder)

local t82 = {}

t82.__index = t82

function t82.new(t83: {[any]: any}?) -- line: 7855
	-- upvalues: t82 (copy)
	return (setmetatable({
		universe_id = if t83 ~= nil and t83.universe_id ~= nil then t83.universe_id else "",
		user_owns_experience = t83 ~= nil and (t83.user_owns_experience ~= nil and t83.user_owns_experience)
	}, t82))
end
function t82.encode(p52) -- line: 7866
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n34 = 0

	if p52.universe_id ~= nil and p52.universe_id ~= "" then
		local v926, v927 = proto.writeTag(buf, n34, 1, proto.wireTypes.lengthDelimited)

		buf, n34 = proto.writeString(v926, v927, p52.universe_id)
	end

	if p52.user_owns_experience then
		local v928, v929 = proto.writeTag(buf, n34, 2, proto.wireTypes.varint)

		buf, n34 = proto.writeVarInt(v928, v929, not p52.user_owns_experience and 0 or 1)
	end

	local buf21 = buffer.create(n34)

	buffer.copy(buf21, 0, buf, 0, n34)

	return buf21
end
function t82.decode(p53: buffer) -- line: 7885
	-- upvalues: t82 (copy), proto (copy)
	local v932 = t82.new()
	local n35 = 0

	while n35 < buffer.len(p53) do
		local v934, v935

		v934, v935, n35 = proto.readTag(p53, n35)

		if v935 == proto.wireTypes.varint then
			if v934 == 2 then
				local v936

				v936, n35 = proto.readVarInt(p53, n35)
				v932.user_owns_experience = v936 ~= 0
			else
				local v937

				v937, n35 = proto.readVarInt(p53, n35)
			end
		elseif v935 == proto.wireTypes.lengthDelimited then
			if v934 == 1 then
				local v938

				v938, n35 = proto.readBuffer(p53, n35)
				v932.universe_id = buffer.tostring(v938)
			else
				local v939, v940 = proto.readVarInt(p53, n35)

				n35 = v940 + v939
			end
		elseif v935 == proto.wireTypes.i32 then
			local v941

			v941, n35 = proto.readFixed32(p53, n35)
		elseif v935 == proto.wireTypes.i64 then
			local v942

			v942, n35 = proto.readFixed64(p53, n35)
		else
			error("Unsupported wire type: " .. v935)
		end
	end

	return v932
end
function t82.jsonEncode(p54) -- line: 7933
	local t84 = {}

	if p54.universe_id ~= nil and p54.universe_id ~= "" then
		t84.universeId = p54.universe_id
	end

	if p54.user_owns_experience then
		t84.userOwnsExperience = p54.user_owns_experience
	end

	return t84
end
function t82.jsonDecode(t85: {[any]: any}) -- line: 7947
	-- upvalues: t82 (copy)
	local v946 = t82.new()

	if t85.universe_id ~= nil then
		v946.universe_id = t85.universe_id
	end

	if t85.universeId ~= nil then
		v946.universe_id = t85.universeId
	end

	if t85.user_owns_experience ~= nil then
		v946.user_owns_experience = t85.user_owns_experience
	end

	if t85.userOwnsExperience ~= nil then
		v946.user_owns_experience = t85.userOwnsExperience
	end

	return v946
end

t82.descriptor = {
	name = "ExperienceDetailsActionBarInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceDetailsActionBarInputData"
}
t1.ExperienceDetailsActionBarInputData = t82
typeRegistry.default:register(t1.ExperienceDetailsActionBarInputData)

local t86 = {}

t86.__index = t86

function t86.new(t87: {[any]: any}?) -- line: 7985
	-- upvalues: t86 (copy)
	return (setmetatable({
		media_asset_id = if t87 ~= nil and t87.media_asset_id ~= nil then t87.media_asset_id else ""
	}, t86))
end
function t86.encode(p55) -- line: 7993
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n36 = 0

	if p55.media_asset_id ~= nil and p55.media_asset_id ~= "" then
		local v951, v952 = proto.writeTag(buf, n36, 1, proto.wireTypes.lengthDelimited)

		buf, n36 = proto.writeString(v951, v952, p55.media_asset_id)
	end

	local buf22 = buffer.create(n36)

	buffer.copy(buf22, 0, buf, 0, n36)

	return buf22
end
function t86.decode(p56: buffer) -- line: 8007
	-- upvalues: t86 (copy), proto (copy)
	local v955 = t86.new()
	local n37 = 0

	while n37 < buffer.len(p56) do
		local v957, v958

		v957, v958, n37 = proto.readTag(p56, n37)

		if v958 == proto.wireTypes.varint then
			local v959

			v959, n37 = proto.readVarInt(p56, n37)
		elseif v958 == proto.wireTypes.lengthDelimited then
			if v957 == 1 then
				local v960

				v960, n37 = proto.readBuffer(p56, n37)
				v955.media_asset_id = buffer.tostring(v960)
			else
				local v961, v962 = proto.readVarInt(p56, n37)

				n37 = v962 + v961
			end
		elseif v958 == proto.wireTypes.i32 then
			local v963

			v963, n37 = proto.readFixed32(p56, n37)
		elseif v958 == proto.wireTypes.i64 then
			local v964

			v964, n37 = proto.readFixed64(p56, n37)
		else
			error("Unsupported wire type: " .. v958)
		end
	end

	return v955
end
function t86.jsonEncode(p57) -- line: 8050
	local t88 = {}

	if p57.media_asset_id ~= nil and p57.media_asset_id ~= "" then
		t88.mediaAssetId = p57.media_asset_id
	end

	return t88
end
function t86.jsonDecode(t89: {[any]: any}) -- line: 8060
	-- upvalues: t86 (copy)
	local v968 = t86.new()

	if t89.media_asset_id ~= nil then
		v968.media_asset_id = t89.media_asset_id
	end

	if t89.mediaAssetId ~= nil then
		v968.media_asset_id = t89.mediaAssetId
	end

	return v968
end

t86.descriptor = {
	name = "ExperienceDetailsBannerImageInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceDetailsBannerImageInputData"
}
t1.ExperienceDetailsBannerImageInputData = t86
typeRegistry.default:register(t1.ExperienceDetailsBannerImageInputData)

local t90 = {}

t90.__index = t90

function t90.new(t91: {[any]: any}?) -- line: 8090
	-- upvalues: t90 (copy)
	return (setmetatable({
		universe_id = if t91 ~= nil and t91.universe_id ~= nil then t91.universe_id else ""
	}, t90))
end
function t90.encode(p58) -- line: 8098
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n38 = 0

	if p58.universe_id ~= nil and p58.universe_id ~= "" then
		local v973, v974 = proto.writeTag(buf, n38, 1, proto.wireTypes.lengthDelimited)

		buf, n38 = proto.writeString(v973, v974, p58.universe_id)
	end

	local buf23 = buffer.create(n38)

	buffer.copy(buf23, 0, buf, 0, n38)

	return buf23
end
function t90.decode(p59: buffer) -- line: 8112
	-- upvalues: t90 (copy), proto (copy)
	local v977 = t90.new()
	local n39 = 0

	while n39 < buffer.len(p59) do
		local v979, v980

		v979, v980, n39 = proto.readTag(p59, n39)

		if v980 == proto.wireTypes.varint then
			local v981

			v981, n39 = proto.readVarInt(p59, n39)
		elseif v980 == proto.wireTypes.lengthDelimited then
			if v979 == 1 then
				local v982

				v982, n39 = proto.readBuffer(p59, n39)
				v977.universe_id = buffer.tostring(v982)
			else
				local v983, v984 = proto.readVarInt(p59, n39)

				n39 = v984 + v983
			end
		elseif v980 == proto.wireTypes.i32 then
			local v985

			v985, n39 = proto.readFixed32(p59, n39)
		elseif v980 == proto.wireTypes.i64 then
			local v986

			v986, n39 = proto.readFixed64(p59, n39)
		else
			error("Unsupported wire type: " .. v980)
		end
	end

	return v977
end
function t90.jsonEncode(p60) -- line: 8155
	local t92 = {}

	if p60.universe_id ~= nil and p60.universe_id ~= "" then
		t92.universeId = p60.universe_id
	end

	return t92
end
function t90.jsonDecode(t93: {[any]: any}) -- line: 8165
	-- upvalues: t90 (copy)
	local v990 = t90.new()

	if t93.universe_id ~= nil then
		v990.universe_id = t93.universe_id
	end

	if t93.universeId ~= nil then
		v990.universe_id = t93.universeId
	end

	return v990
end

t90.descriptor = {
	name = "ExperienceDetailsStickyHeaderInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceDetailsStickyHeaderInputData"
}
t1.ExperienceDetailsStickyHeaderInputData = t90
typeRegistry.default:register(t1.ExperienceDetailsStickyHeaderInputData)

local t94 = {}

t94.__index = t94

function t94.new(t95: {[any]: any}?) -- line: 8195
	-- upvalues: t94 (copy)
	return (setmetatable({
		universe_id = if t95 ~= nil and t95.universe_id ~= nil then t95.universe_id else "",
		creator_key = if t95 ~= nil and t95.creator_key ~= nil then t95.creator_key else ""
	}, t94))
end
function t94.encode(p61) -- line: 8204
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n40 = 0

	if p61.universe_id ~= nil and p61.universe_id ~= "" then
		local v995, v996 = proto.writeTag(buf, n40, 1, proto.wireTypes.lengthDelimited)

		buf, n40 = proto.writeString(v995, v996, p61.universe_id)
	end

	if p61.creator_key ~= nil and p61.creator_key ~= "" then
		local v997, v998 = proto.writeTag(buf, n40, 2, proto.wireTypes.lengthDelimited)

		buf, n40 = proto.writeString(v997, v998, p61.creator_key)
	end

	local buf24 = buffer.create(n40)

	buffer.copy(buf24, 0, buf, 0, n40)

	return buf24
end
function t94.decode(p62: buffer) -- line: 8223
	-- upvalues: t94 (copy), proto (copy)
	local v1001 = t94.new()
	local n41 = 0

	while n41 < buffer.len(p62) do
		local v1003, v1004

		v1003, v1004, n41 = proto.readTag(p62, n41)

		if v1004 == proto.wireTypes.varint then
			local v1005

			v1005, n41 = proto.readVarInt(p62, n41)
		elseif v1004 == proto.wireTypes.lengthDelimited then
			if v1003 == 1 then
				local v1006

				v1006, n41 = proto.readBuffer(p62, n41)
				v1001.universe_id = buffer.tostring(v1006)
			elseif v1003 == 2 then
				local v1007

				v1007, n41 = proto.readBuffer(p62, n41)
				v1001.creator_key = buffer.tostring(v1007)
			else
				local v1008, v1009 = proto.readVarInt(p62, n41)

				n41 = v1009 + v1008
			end
		elseif v1004 == proto.wireTypes.i32 then
			local v1010

			v1010, n41 = proto.readFixed32(p62, n41)
		elseif v1004 == proto.wireTypes.i64 then
			local v1011

			v1011, n41 = proto.readFixed64(p62, n41)
		else
			error("Unsupported wire type: " .. v1004)
		end
	end

	return v1001
end
function t94.jsonEncode(p63) -- line: 8271
	local t96 = {}

	if p63.universe_id ~= nil and p63.universe_id ~= "" then
		t96.universeId = p63.universe_id
	end

	if p63.creator_key ~= nil and p63.creator_key ~= "" then
		t96.creatorKey = p63.creator_key
	end

	return t96
end
function t94.jsonDecode(t97: {[any]: any}) -- line: 8285
	-- upvalues: t94 (copy)
	local v1015 = t94.new()

	if t97.universe_id ~= nil then
		v1015.universe_id = t97.universe_id
	end

	if t97.universeId ~= nil then
		v1015.universe_id = t97.universeId
	end

	if t97.creator_key ~= nil then
		v1015.creator_key = t97.creator_key
	end

	if t97.creatorKey ~= nil then
		v1015.creator_key = t97.creatorKey
	end

	return v1015
end

t94.descriptor = {
	name = "ExperienceAttributionRowInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceAttributionRowInputData"
}
t1.ExperienceAttributionRowInputData = t94
typeRegistry.default:register(t1.ExperienceAttributionRowInputData)

local t98 = {}

t98.__index = t98

function t98.new(t99: {[any]: any}?) -- line: 8323
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
function t98.encode(p64) -- line: 8345
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n42 = 0

	if p64.universe_id ~= nil and p64.universe_id ~= "" then
		local v1020, v1021 = proto.writeTag(buf, n42, 1, proto.wireTypes.lengthDelimited)

		buf, n42 = proto.writeString(v1020, v1021, p64.universe_id)
	end

	if p64.root_place_id ~= nil and p64.root_place_id ~= "" then
		local v1022, v1023 = proto.writeTag(buf, n42, 2, proto.wireTypes.lengthDelimited)

		buf, n42 = proto.writeString(v1022, v1023, p64.root_place_id)
	end

	if p64.connection_played_display_name ~= nil and p64.connection_played_display_name ~= "" then
		local v1024, v1025 = proto.writeTag(buf, n42, 3, proto.wireTypes.lengthDelimited)

		buf, n42 = proto.writeString(v1024, v1025, p64.connection_played_display_name)
	end

	if p64.upsell_prompt ~= nil and p64.upsell_prompt ~= "" then
		local v1026, v1027 = proto.writeTag(buf, n42, 4, proto.wireTypes.lengthDelimited)

		buf, n42 = proto.writeString(v1026, v1027, p64.upsell_prompt)
	end

	if p64.connection_played_users ~= nil and #p64.connection_played_users > 0 then
		for _, v1029 in p64.connection_played_users do
			local v1030 = v1029:encode()
			local v1031, v1032 = proto.writeTag(buf, n42, 5, proto.wireTypes.lengthDelimited)

			buf, n42 = proto.writeBuffer(v1031, v1032, v1030, buffer.len(v1030))
		end
	end

	if p64.connection_played_num_others ~= nil and p64.connection_played_num_others ~= 0 then
		local v1033, v1034 = proto.writeTag(buf, n42, 6, proto.wireTypes.varint)

		buf, n42 = proto.writeVarInt(v1033, v1034, p64.connection_played_num_others)
	end

	if p64.connection_played_total_count ~= nil and p64.connection_played_total_count ~= 0 then
		local v1035, v1036 = proto.writeTag(buf, n42, 7, proto.wireTypes.varint)

		buf, n42 = proto.writeVarInt(v1035, v1036, p64.connection_played_total_count)
	end

	local buf25 = buffer.create(n42)

	buffer.copy(buf25, 0, buf, 0, n42)

	return buf25
end
function t98.decode(p65: buffer) -- line: 8392
	-- upvalues: t98 (copy), proto (copy), t1 (copy)
	local v1039 = t98.new()
	local n43 = 0

	while n43 < buffer.len(p65) do
		local v1041, v1042

		v1041, v1042, n43 = proto.readTag(p65, n43)

		if v1042 == proto.wireTypes.varint then
			if v1041 == 6 then
				local v1043

				v1043, n43 = proto.readVarIntI32(p65, n43)
				v1039.connection_played_num_others = v1043
			elseif v1041 == 7 then
				local v1044

				v1044, n43 = proto.readVarIntI32(p65, n43)
				v1039.connection_played_total_count = v1044
			else
				local v1045

				v1045, n43 = proto.readVarInt(p65, n43)
			end
		elseif v1042 == proto.wireTypes.lengthDelimited then
			if v1041 == 1 then
				local v1046

				v1046, n43 = proto.readBuffer(p65, n43)
				v1039.universe_id = buffer.tostring(v1046)
			elseif v1041 == 2 then
				local v1047

				v1047, n43 = proto.readBuffer(p65, n43)
				v1039.root_place_id = buffer.tostring(v1047)
			elseif v1041 == 3 then
				local v1048

				v1048, n43 = proto.readBuffer(p65, n43)
				v1039.connection_played_display_name = buffer.tostring(v1048)
			elseif v1041 == 4 then
				local v1049

				v1049, n43 = proto.readBuffer(p65, n43)
				v1039.upsell_prompt = buffer.tostring(v1049)
			elseif v1041 == 5 then
				local v1050

				v1050, n43 = proto.readBuffer(p65, n43)
				table.insert(v1039.connection_played_users, t1.ExperienceActionModuleInputData_ConnectionPlayedUser.decode(v1050))
			else
				local v1051, v1052 = proto.readVarInt(p65, n43)

				n43 = v1052 + v1051
			end
		elseif v1042 == proto.wireTypes.i32 then
			local v1053

			v1053, n43 = proto.readFixed32(p65, n43)
		elseif v1042 == proto.wireTypes.i64 then
			local v1054

			v1054, n43 = proto.readFixed64(p65, n43)
		else
			error("Unsupported wire type: " .. v1042)
		end
	end

	return v1039
end
function t98.jsonEncode(p66) -- line: 8468
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

		for _, v1059 in p66.connection_played_users do
			table.insert(t101, v1059:jsonEncode())
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
function t98.jsonDecode(t102: {[any]: any}) -- line: 8506
	-- upvalues: t98 (copy), t1 (copy)
	local v1061 = t98.new()

	if t102.universe_id ~= nil then
		v1061.universe_id = t102.universe_id
	end

	if t102.universeId ~= nil then
		v1061.universe_id = t102.universeId
	end

	if t102.root_place_id ~= nil then
		v1061.root_place_id = t102.root_place_id
	end

	if t102.rootPlaceId ~= nil then
		v1061.root_place_id = t102.rootPlaceId
	end

	if t102.connection_played_display_name ~= nil then
		v1061.connection_played_display_name = t102.connection_played_display_name
	end

	if t102.connectionPlayedDisplayName ~= nil then
		v1061.connection_played_display_name = t102.connectionPlayedDisplayName
	end

	if t102.upsell_prompt ~= nil then
		v1061.upsell_prompt = t102.upsell_prompt
	end

	if t102.upsellPrompt ~= nil then
		v1061.upsell_prompt = t102.upsellPrompt
	end

	if t102.connection_played_users ~= nil then
		local t103 = {}

		for _, v1064 in t102.connection_played_users do
			table.insert(t103, t1.ExperienceActionModuleInputData_ConnectionPlayedUser.jsonDecode(v1064))
		end

		v1061.connection_played_users = t103
	end

	if t102.connectionPlayedUsers ~= nil then
		local t104 = {}

		for _, v1067 in t102.connectionPlayedUsers do
			table.insert(t104, t1.ExperienceActionModuleInputData_ConnectionPlayedUser.jsonDecode(v1067))
		end

		v1061.connection_played_users = t104
	end

	if t102.connection_played_num_others ~= nil then
		v1061.connection_played_num_others = t102.connection_played_num_others
	end

	if t102.connectionPlayedNumOthers ~= nil then
		v1061.connection_played_num_others = t102.connectionPlayedNumOthers
	end

	if t102.connection_played_total_count ~= nil then
		v1061.connection_played_total_count = t102.connection_played_total_count
	end

	if t102.connectionPlayedTotalCount ~= nil then
		v1061.connection_played_total_count = t102.connectionPlayedTotalCount
	end

	return v1061
end

t98.descriptor = {
	name = "ExperienceActionModuleInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceActionModuleInputData"
}
t1.ExperienceActionModuleInputData = t98
typeRegistry.default:register(t1.ExperienceActionModuleInputData)

local t105 = {}

t105.__index = t105

function t105.new(t106: {[any]: any}?) -- line: 8593
	-- upvalues: t105 (copy)
	return (setmetatable({
		user_id = if t106 ~= nil and t106.user_id ~= nil then t106.user_id else ""
	}, t105))
end
function t105.encode(p67) -- line: 8604
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n44 = 0

	if p67.user_id ~= nil and p67.user_id ~= "" then
		local v1072, v1073 = proto.writeTag(buf, n44, 1, proto.wireTypes.lengthDelimited)

		buf, n44 = proto.writeString(v1072, v1073, p67.user_id)
	end

	local buf26 = buffer.create(n44)

	buffer.copy(buf26, 0, buf, 0, n44)

	return buf26
end
function t105.decode(p68: buffer) -- line: 8620
	-- upvalues: t105 (copy), proto (copy)
	local v1076 = t105.new()
	local n45 = 0

	while n45 < buffer.len(p68) do
		local v1078, v1079

		v1078, v1079, n45 = proto.readTag(p68, n45)

		if v1079 == proto.wireTypes.varint then
			local v1080

			v1080, n45 = proto.readVarInt(p68, n45)
		elseif v1079 == proto.wireTypes.lengthDelimited then
			if v1078 == 1 then
				local v1081

				v1081, n45 = proto.readBuffer(p68, n45)
				v1076.user_id = buffer.tostring(v1081)
			else
				local v1082, v1083 = proto.readVarInt(p68, n45)

				n45 = v1083 + v1082
			end
		elseif v1079 == proto.wireTypes.i32 then
			local v1084

			v1084, n45 = proto.readFixed32(p68, n45)
		elseif v1079 == proto.wireTypes.i64 then
			local v1085

			v1085, n45 = proto.readFixed64(p68, n45)
		else
			error("Unsupported wire type: " .. v1079)
		end
	end

	return v1076
end
function t105.jsonEncode(p69) -- line: 8665
	local t107 = {}

	if p69.user_id ~= nil and p69.user_id ~= "" then
		t107.userId = p69.user_id
	end

	return t107
end
function t105.jsonDecode(t108: {[any]: any}) -- line: 8677
	-- upvalues: t105 (copy)
	local v1089 = t105.new()

	if t108.user_id ~= nil then
		v1089.user_id = t108.user_id
	end

	if t108.userId ~= nil then
		v1089.user_id = t108.userId
	end

	return v1089
end

t105.descriptor = {
	name = "ExperienceActionModuleInputData_ConnectionPlayedUser",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConnectionPlayedUser"
}
t1.ExperienceActionModuleInputData_ConnectionPlayedUser = t105
typeRegistry.default:register(t1.ExperienceActionModuleInputData_ConnectionPlayedUser)

local t109 = {}

t109.__index = t109

function t109.new(t110: {[any]: any}?) -- line: 8708
	-- upvalues: t109 (copy)
	return (setmetatable({
		media_items = if t110 ~= nil and t110.media_items ~= nil then t110.media_items else {},
		universe_id = if t110 ~= nil and t110.universe_id ~= nil then t110.universe_id else "",
		place_id = if t110 ~= nil and t110.place_id ~= nil then t110.place_id else ""
	}, t109))
end
function t109.encode(p70) -- line: 8718
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n46 = 0

	if p70.media_items ~= nil and #p70.media_items > 0 then
		for _, v1095 in p70.media_items do
			local v1096 = v1095:encode()
			local v1097, v1098 = proto.writeTag(buf, n46, 1, proto.wireTypes.lengthDelimited)

			buf, n46 = proto.writeBuffer(v1097, v1098, v1096, buffer.len(v1096))
		end
	end

	if p70.universe_id ~= nil and p70.universe_id ~= "" then
		local v1099, v1100 = proto.writeTag(buf, n46, 2, proto.wireTypes.lengthDelimited)

		buf, n46 = proto.writeString(v1099, v1100, p70.universe_id)
	end

	if p70.place_id ~= nil and p70.place_id ~= "" then
		local v1101, v1102 = proto.writeTag(buf, n46, 3, proto.wireTypes.lengthDelimited)

		buf, n46 = proto.writeString(v1101, v1102, p70.place_id)
	end

	local buf27 = buffer.create(n46)

	buffer.copy(buf27, 0, buf, 0, n46)

	return buf27
end
function t109.decode(p71: buffer) -- line: 8745
	-- upvalues: t109 (copy), proto (copy), t1 (copy)
	local v1105 = t109.new()
	local n47 = 0

	while n47 < buffer.len(p71) do
		local v1107, v1108

		v1107, v1108, n47 = proto.readTag(p71, n47)

		if v1108 == proto.wireTypes.varint then
			local v1109

			v1109, n47 = proto.readVarInt(p71, n47)
		elseif v1108 == proto.wireTypes.lengthDelimited then
			if v1107 == 1 then
				local v1110

				v1110, n47 = proto.readBuffer(p71, n47)
				table.insert(v1105.media_items, t1.ExperienceMediaGalleryInputData_MediaItem.decode(v1110))
			elseif v1107 == 2 then
				local v1111

				v1111, n47 = proto.readBuffer(p71, n47)
				v1105.universe_id = buffer.tostring(v1111)
			elseif v1107 == 3 then
				local v1112

				v1112, n47 = proto.readBuffer(p71, n47)
				v1105.place_id = buffer.tostring(v1112)
			else
				local v1113, v1114 = proto.readVarInt(p71, n47)

				n47 = v1114 + v1113
			end
		elseif v1108 == proto.wireTypes.i32 then
			local v1115

			v1115, n47 = proto.readFixed32(p71, n47)
		elseif v1108 == proto.wireTypes.i64 then
			local v1116

			v1116, n47 = proto.readFixed64(p71, n47)
		else
			error("Unsupported wire type: " .. v1108)
		end
	end

	return v1105
end
function t109.jsonEncode(p72) -- line: 8798
	local t111 = {}

	if p72.media_items ~= nil and #p72.media_items > 0 then
		local t112 = {}

		for _, v1121 in p72.media_items do
			table.insert(t112, v1121:jsonEncode())
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
function t109.jsonDecode(t113: {[any]: any}) -- line: 8820
	-- upvalues: t109 (copy), t1 (copy)
	local v1123 = t109.new()

	if t113.media_items ~= nil then
		local t114 = {}

		for _, v1126 in t113.media_items do
			table.insert(t114, t1.ExperienceMediaGalleryInputData_MediaItem.jsonDecode(v1126))
		end

		v1123.media_items = t114
	end

	if t113.mediaItems ~= nil then
		local t115 = {}

		for _, v1129 in t113.mediaItems do
			table.insert(t115, t1.ExperienceMediaGalleryInputData_MediaItem.jsonDecode(v1129))
		end

		v1123.media_items = t115
	end

	if t113.universe_id ~= nil then
		v1123.universe_id = t113.universe_id
	end

	if t113.universeId ~= nil then
		v1123.universe_id = t113.universeId
	end

	if t113.place_id ~= nil then
		v1123.place_id = t113.place_id
	end

	if t113.placeId ~= nil then
		v1123.place_id = t113.placeId
	end

	return v1123
end

t109.descriptor = {
	name = "ExperienceMediaGalleryInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceMediaGalleryInputData"
}
t1.ExperienceMediaGalleryInputData = t109
typeRegistry.default:register(t1.ExperienceMediaGalleryInputData)

local t116 = {}

t116.__index = t116

function t116.new(t117: {[any]: any}?) -- line: 8874
	-- upvalues: t116 (copy)
	return (setmetatable({
		media_asset_id = if t117 ~= nil and t117.media_asset_id ~= nil then t117.media_asset_id else ""
	}, t116))
end
function t116.encode(p73) -- line: 8882
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n48 = 0

	if p73.media_asset_id ~= nil and p73.media_asset_id ~= "" then
		local v1134, v1135 = proto.writeTag(buf, n48, 1, proto.wireTypes.lengthDelimited)

		buf, n48 = proto.writeString(v1134, v1135, p73.media_asset_id)
	end

	local buf28 = buffer.create(n48)

	buffer.copy(buf28, 0, buf, 0, n48)

	return buf28
end
function t116.decode(p74: buffer) -- line: 8898
	-- upvalues: t116 (copy), proto (copy)
	local v1138 = t116.new()
	local n49 = 0

	while n49 < buffer.len(p74) do
		local v1140, v1141

		v1140, v1141, n49 = proto.readTag(p74, n49)

		if v1141 == proto.wireTypes.varint then
			local v1142

			v1142, n49 = proto.readVarInt(p74, n49)
		elseif v1141 == proto.wireTypes.lengthDelimited then
			if v1140 == 1 then
				local v1143

				v1143, n49 = proto.readBuffer(p74, n49)
				v1138.media_asset_id = buffer.tostring(v1143)
			else
				local v1144, v1145 = proto.readVarInt(p74, n49)

				n49 = v1145 + v1144
			end
		elseif v1141 == proto.wireTypes.i32 then
			local v1146

			v1146, n49 = proto.readFixed32(p74, n49)
		elseif v1141 == proto.wireTypes.i64 then
			local v1147

			v1147, n49 = proto.readFixed64(p74, n49)
		else
			error("Unsupported wire type: " .. v1141)
		end
	end

	return v1138
end
function t116.jsonEncode(p75) -- line: 8943
	local t118 = {}

	if p75.media_asset_id ~= nil and p75.media_asset_id ~= "" then
		t118.mediaAssetId = p75.media_asset_id
	end

	return t118
end
function t116.jsonDecode(t119: {[any]: any}) -- line: 8955
	-- upvalues: t116 (copy)
	local v1151 = t116.new()

	if t119.media_asset_id ~= nil then
		v1151.media_asset_id = t119.media_asset_id
	end

	if t119.mediaAssetId ~= nil then
		v1151.media_asset_id = t119.mediaAssetId
	end

	return v1151
end

t116.descriptor = {
	name = "ExperienceMediaGalleryInputData_MediaItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.MediaItem"
}
t1.ExperienceMediaGalleryInputData_MediaItem = t116
typeRegistry.default:register(t1.ExperienceMediaGalleryInputData_MediaItem)

local t120 = {}

t120.__index = t120

function t120.new(t121: {[any]: any}?) -- line: 8985
	-- upvalues: t120 (copy)
	return (setmetatable({
		universe_id = if t121 ~= nil and t121.universe_id ~= nil then t121.universe_id else ""
	}, t120))
end
function t120.encode(p76) -- line: 8993
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n50 = 0

	if p76.universe_id ~= nil and p76.universe_id ~= "" then
		local v1156, v1157 = proto.writeTag(buf, n50, 1, proto.wireTypes.lengthDelimited)

		buf, n50 = proto.writeString(v1156, v1157, p76.universe_id)
	end

	local buf29 = buffer.create(n50)

	buffer.copy(buf29, 0, buf, 0, n50)

	return buf29
end
function t120.decode(p77: buffer) -- line: 9007
	-- upvalues: t120 (copy), proto (copy)
	local v1160 = t120.new()
	local n51 = 0

	while n51 < buffer.len(p77) do
		local v1162, v1163

		v1162, v1163, n51 = proto.readTag(p77, n51)

		if v1163 == proto.wireTypes.varint then
			local v1164

			v1164, n51 = proto.readVarInt(p77, n51)
		elseif v1163 == proto.wireTypes.lengthDelimited then
			if v1162 == 1 then
				local v1165

				v1165, n51 = proto.readBuffer(p77, n51)
				v1160.universe_id = buffer.tostring(v1165)
			else
				local v1166, v1167 = proto.readVarInt(p77, n51)

				n51 = v1167 + v1166
			end
		elseif v1163 == proto.wireTypes.i32 then
			local v1168

			v1168, n51 = proto.readFixed32(p77, n51)
		elseif v1163 == proto.wireTypes.i64 then
			local v1169

			v1169, n51 = proto.readFixed64(p77, n51)
		else
			error("Unsupported wire type: " .. v1163)
		end
	end

	return v1160
end
function t120.jsonEncode(p78) -- line: 9050
	local t122 = {}

	if p78.universe_id ~= nil and p78.universe_id ~= "" then
		t122.universeId = p78.universe_id
	end

	return t122
end
function t120.jsonDecode(t123: {[any]: any}) -- line: 9060
	-- upvalues: t120 (copy)
	local v1173 = t120.new()

	if t123.universe_id ~= nil then
		v1173.universe_id = t123.universe_id
	end

	if t123.universeId ~= nil then
		v1173.universe_id = t123.universeId
	end

	return v1173
end

t120.descriptor = {
	name = "ExperienceDescriptionInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceDescriptionInputData"
}
t1.ExperienceDescriptionInputData = t120
typeRegistry.default:register(t1.ExperienceDescriptionInputData)

local t124 = {}

t124.__index = t124

function t124.new(t125: {[any]: any}?) -- line: 9088
	-- upvalues: t124 (copy)
	return (setmetatable({
		universe_id = if t125 ~= nil and t125.universe_id ~= nil then t125.universe_id else ""
	}, t124))
end
function t124.encode(p79) -- line: 9096
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n52 = 0

	if p79.universe_id ~= nil and p79.universe_id ~= "" then
		local v1178, v1179 = proto.writeTag(buf, n52, 1, proto.wireTypes.lengthDelimited)

		buf, n52 = proto.writeString(v1178, v1179, p79.universe_id)
	end

	local buf30 = buffer.create(n52)

	buffer.copy(buf30, 0, buf, 0, n52)

	return buf30
end
function t124.decode(p80: buffer) -- line: 9110
	-- upvalues: t124 (copy), proto (copy)
	local v1182 = t124.new()
	local n53 = 0

	while n53 < buffer.len(p80) do
		local v1184, v1185

		v1184, v1185, n53 = proto.readTag(p80, n53)

		if v1185 == proto.wireTypes.varint then
			local v1186

			v1186, n53 = proto.readVarInt(p80, n53)
		elseif v1185 == proto.wireTypes.lengthDelimited then
			if v1184 == 1 then
				local v1187

				v1187, n53 = proto.readBuffer(p80, n53)
				v1182.universe_id = buffer.tostring(v1187)
			else
				local v1188, v1189 = proto.readVarInt(p80, n53)

				n53 = v1189 + v1188
			end
		elseif v1185 == proto.wireTypes.i32 then
			local v1190

			v1190, n53 = proto.readFixed32(p80, n53)
		elseif v1185 == proto.wireTypes.i64 then
			local v1191

			v1191, n53 = proto.readFixed64(p80, n53)
		else
			error("Unsupported wire type: " .. v1185)
		end
	end

	return v1182
end
function t124.jsonEncode(p81) -- line: 9153
	local t126 = {}

	if p81.universe_id ~= nil and p81.universe_id ~= "" then
		t126.universeId = p81.universe_id
	end

	return t126
end
function t124.jsonDecode(t127: {[any]: any}) -- line: 9163
	-- upvalues: t124 (copy)
	local v1195 = t124.new()

	if t127.universe_id ~= nil then
		v1195.universe_id = t127.universe_id
	end

	if t127.universeId ~= nil then
		v1195.universe_id = t127.universeId
	end

	return v1195
end

t124.descriptor = {
	name = "ExperienceStatRowInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceStatRowInputData"
}
t1.ExperienceStatRowInputData = t124
typeRegistry.default:register(t1.ExperienceStatRowInputData)

local t128 = {}

t128.__index = t128

function t128.new(t129: {[any]: any}?) -- line: 9191
	-- upvalues: t128 (copy)
	return (setmetatable({
		universe_id = if t129 ~= nil and t129.universe_id ~= nil then t129.universe_id else "",
		has_store_items = t129 ~= nil and (t129.has_store_items ~= nil and t129.has_store_items),
		has_badges = t129 ~= nil and (t129.has_badges ~= nil and t129.has_badges),
		has_game_passes = t129 ~= nil and (t129.has_game_passes ~= nil and t129.has_game_passes)
	}, t128))
end
function t128.encode(p82) -- line: 9202
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n54 = 0

	if p82.universe_id ~= nil and p82.universe_id ~= "" then
		local v1200, v1201 = proto.writeTag(buf, n54, 1, proto.wireTypes.lengthDelimited)

		buf, n54 = proto.writeString(v1200, v1201, p82.universe_id)
	end

	if p82.has_store_items then
		local v1202, v1203 = proto.writeTag(buf, n54, 2, proto.wireTypes.varint)

		buf, n54 = proto.writeVarInt(v1202, v1203, not p82.has_store_items and 0 or 1)
	end

	if p82.has_badges then
		local v1204, v1205 = proto.writeTag(buf, n54, 3, proto.wireTypes.varint)

		buf, n54 = proto.writeVarInt(v1204, v1205, not p82.has_badges and 0 or 1)
	end

	if p82.has_game_passes then
		local v1206, v1207 = proto.writeTag(buf, n54, 4, proto.wireTypes.varint)

		buf, n54 = proto.writeVarInt(v1206, v1207, not p82.has_game_passes and 0 or 1)
	end

	local buf31 = buffer.create(n54)

	buffer.copy(buf31, 0, buf, 0, n54)

	return buf31
end
function t128.decode(p83: buffer) -- line: 9231
	-- upvalues: t128 (copy), proto (copy)
	local v1210 = t128.new()
	local n55 = 0

	while n55 < buffer.len(p83) do
		local v1212, v1213

		v1212, v1213, n55 = proto.readTag(p83, n55)

		if v1213 == proto.wireTypes.varint then
			if v1212 == 2 then
				local v1214

				v1214, n55 = proto.readVarInt(p83, n55)
				v1210.has_store_items = v1214 ~= 0
			elseif v1212 == 3 then
				local v1215

				v1215, n55 = proto.readVarInt(p83, n55)
				v1210.has_badges = v1215 ~= 0
			elseif v1212 == 4 then
				local v1216

				v1216, n55 = proto.readVarInt(p83, n55)
				v1210.has_game_passes = v1216 ~= 0
			else
				local v1217

				v1217, n55 = proto.readVarInt(p83, n55)
			end
		elseif v1213 == proto.wireTypes.lengthDelimited then
			if v1212 == 1 then
				local v1218

				v1218, n55 = proto.readBuffer(p83, n55)
				v1210.universe_id = buffer.tostring(v1218)
			else
				local v1219, v1220 = proto.readVarInt(p83, n55)

				n55 = v1220 + v1219
			end
		elseif v1213 == proto.wireTypes.i32 then
			local v1221

			v1221, n55 = proto.readFixed32(p83, n55)
		elseif v1213 == proto.wireTypes.i64 then
			local v1222

			v1222, n55 = proto.readFixed64(p83, n55)
		else
			error("Unsupported wire type: " .. v1213)
		end
	end

	return v1210
end
function t128.jsonEncode(p84) -- line: 9289
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
function t128.jsonDecode(t131: {[any]: any}) -- line: 9311
	-- upvalues: t128 (copy)
	local v1226 = t128.new()

	if t131.universe_id ~= nil then
		v1226.universe_id = t131.universe_id
	end

	if t131.universeId ~= nil then
		v1226.universe_id = t131.universeId
	end

	if t131.has_store_items ~= nil then
		v1226.has_store_items = t131.has_store_items
	end

	if t131.hasStoreItems ~= nil then
		v1226.has_store_items = t131.hasStoreItems
	end

	if t131.has_badges ~= nil then
		v1226.has_badges = t131.has_badges
	end

	if t131.hasBadges ~= nil then
		v1226.has_badges = t131.hasBadges
	end

	if t131.has_game_passes ~= nil then
		v1226.has_game_passes = t131.has_game_passes
	end

	if t131.hasGamePasses ~= nil then
		v1226.has_game_passes = t131.hasGamePasses
	end

	return v1226
end

t128.descriptor = {
	name = "ExperienceInfoTableInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceInfoTableInputData"
}
t1.ExperienceInfoTableInputData = t128
typeRegistry.default:register(t1.ExperienceInfoTableInputData)

local t132 = {}

t132.__index = t132

function t132.new(t133: {[any]: any}?) -- line: 9363
	-- upvalues: t132 (copy)
	return (setmetatable({
		universe_id = if t133 ~= nil and t133.universe_id ~= nil then t133.universe_id else ""
	}, t132))
end
function t132.encode(p85) -- line: 9371
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n56 = 0

	if p85.universe_id ~= nil and p85.universe_id ~= "" then
		local v1231, v1232 = proto.writeTag(buf, n56, 1, proto.wireTypes.lengthDelimited)

		buf, n56 = proto.writeString(v1231, v1232, p85.universe_id)
	end

	local buf32 = buffer.create(n56)

	buffer.copy(buf32, 0, buf, 0, n56)

	return buf32
end
function t132.decode(p86: buffer) -- line: 9385
	-- upvalues: t132 (copy), proto (copy)
	local v1235 = t132.new()
	local n57 = 0

	while n57 < buffer.len(p86) do
		local v1237, v1238

		v1237, v1238, n57 = proto.readTag(p86, n57)

		if v1238 == proto.wireTypes.varint then
			local v1239

			v1239, n57 = proto.readVarInt(p86, n57)
		elseif v1238 == proto.wireTypes.lengthDelimited then
			if v1237 == 1 then
				local v1240

				v1240, n57 = proto.readBuffer(p86, n57)
				v1235.universe_id = buffer.tostring(v1240)
			else
				local v1241, v1242 = proto.readVarInt(p86, n57)

				n57 = v1242 + v1241
			end
		elseif v1238 == proto.wireTypes.i32 then
			local v1243

			v1243, n57 = proto.readFixed32(p86, n57)
		elseif v1238 == proto.wireTypes.i64 then
			local v1244

			v1244, n57 = proto.readFixed64(p86, n57)
		else
			error("Unsupported wire type: " .. v1238)
		end
	end

	return v1235
end
function t132.jsonEncode(p87) -- line: 9428
	local t134 = {}

	if p87.universe_id ~= nil and p87.universe_id ~= "" then
		t134.universeId = p87.universe_id
	end

	return t134
end
function t132.jsonDecode(t135: {[any]: any}) -- line: 9438
	-- upvalues: t132 (copy)
	local v1248 = t132.new()

	if t135.universe_id ~= nil then
		v1248.universe_id = t135.universe_id
	end

	if t135.universeId ~= nil then
		v1248.universe_id = t135.universeId
	end

	return v1248
end

t132.descriptor = {
	name = "ExperienceContentRatingLabelInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceContentRatingLabelInputData"
}
t1.ExperienceContentRatingLabelInputData = t132
typeRegistry.default:register(t1.ExperienceContentRatingLabelInputData)

local t136 = {}

t136.__index = t136

function t136.new(t137: {[any]: any}?) -- line: 9468
	-- upvalues: t136 (copy)
	return (setmetatable({
		universe_id = if t137 ~= nil and t137.universe_id ~= nil then t137.universe_id else "",
		user_owns_experience = t137 ~= nil and (t137.user_owns_experience ~= nil and t137.user_owns_experience)
	}, t136))
end
function t136.encode(p88) -- line: 9479
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n58 = 0

	if p88.universe_id ~= nil and p88.universe_id ~= "" then
		local v1253, v1254 = proto.writeTag(buf, n58, 1, proto.wireTypes.lengthDelimited)

		buf, n58 = proto.writeString(v1253, v1254, p88.universe_id)
	end

	if p88.user_owns_experience then
		local v1255, v1256 = proto.writeTag(buf, n58, 2, proto.wireTypes.varint)

		buf, n58 = proto.writeVarInt(v1255, v1256, not p88.user_owns_experience and 0 or 1)
	end

	local buf33 = buffer.create(n58)

	buffer.copy(buf33, 0, buf, 0, n58)

	return buf33
end
function t136.decode(p89: buffer) -- line: 9498
	-- upvalues: t136 (copy), proto (copy)
	local v1259 = t136.new()
	local n59 = 0

	while n59 < buffer.len(p89) do
		local v1261, v1262

		v1261, v1262, n59 = proto.readTag(p89, n59)

		if v1262 == proto.wireTypes.varint then
			if v1261 == 2 then
				local v1263

				v1263, n59 = proto.readVarInt(p89, n59)
				v1259.user_owns_experience = v1263 ~= 0
			else
				local v1264

				v1264, n59 = proto.readVarInt(p89, n59)
			end
		elseif v1262 == proto.wireTypes.lengthDelimited then
			if v1261 == 1 then
				local v1265

				v1265, n59 = proto.readBuffer(p89, n59)
				v1259.universe_id = buffer.tostring(v1265)
			else
				local v1266, v1267 = proto.readVarInt(p89, n59)

				n59 = v1267 + v1266
			end
		elseif v1262 == proto.wireTypes.i32 then
			local v1268

			v1268, n59 = proto.readFixed32(p89, n59)
		elseif v1262 == proto.wireTypes.i64 then
			local v1269

			v1269, n59 = proto.readFixed64(p89, n59)
		else
			error("Unsupported wire type: " .. v1262)
		end
	end

	return v1259
end
function t136.jsonEncode(p90) -- line: 9546
	local t138 = {}

	if p90.universe_id ~= nil and p90.universe_id ~= "" then
		t138.universeId = p90.universe_id
	end

	if p90.user_owns_experience then
		t138.userOwnsExperience = p90.user_owns_experience
	end

	return t138
end
function t136.jsonDecode(t139: {[any]: any}) -- line: 9560
	-- upvalues: t136 (copy)
	local v1273 = t136.new()

	if t139.universe_id ~= nil then
		v1273.universe_id = t139.universe_id
	end

	if t139.universeId ~= nil then
		v1273.universe_id = t139.universeId
	end

	if t139.user_owns_experience ~= nil then
		v1273.user_owns_experience = t139.user_owns_experience
	end

	if t139.userOwnsExperience ~= nil then
		v1273.user_owns_experience = t139.userOwnsExperience
	end

	return v1273
end

t136.descriptor = {
	name = "ExperienceRefundPolicyInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceRefundPolicyInputData"
}
t1.ExperienceRefundPolicyInputData = t136
typeRegistry.default:register(t1.ExperienceRefundPolicyInputData)

local t140 = {}

t140.__index = t140

function t140.new(t141: {[any]: any}?) -- line: 9596
	-- upvalues: t140 (copy)
	return (setmetatable({
		universe_id = if t141 ~= nil and t141.universe_id ~= nil then t141.universe_id else "",
		place_id = if t141 ~= nil and t141.place_id ~= nil then t141.place_id else ""
	}, t140))
end
function t140.encode(p91) -- line: 9605
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n60 = 0

	if p91.universe_id ~= nil and p91.universe_id ~= "" then
		local v1278, v1279 = proto.writeTag(buf, n60, 1, proto.wireTypes.lengthDelimited)

		buf, n60 = proto.writeString(v1278, v1279, p91.universe_id)
	end

	if p91.place_id ~= nil and p91.place_id ~= "" then
		local v1280, v1281 = proto.writeTag(buf, n60, 2, proto.wireTypes.lengthDelimited)

		buf, n60 = proto.writeString(v1280, v1281, p91.place_id)
	end

	local buf34 = buffer.create(n60)

	buffer.copy(buf34, 0, buf, 0, n60)

	return buf34
end
function t140.decode(p92: buffer) -- line: 9624
	-- upvalues: t140 (copy), proto (copy)
	local v1284 = t140.new()
	local n61 = 0

	while n61 < buffer.len(p92) do
		local v1286, v1287

		v1286, v1287, n61 = proto.readTag(p92, n61)

		if v1287 == proto.wireTypes.varint then
			local v1288

			v1288, n61 = proto.readVarInt(p92, n61)
		elseif v1287 == proto.wireTypes.lengthDelimited then
			if v1286 == 1 then
				local v1289

				v1289, n61 = proto.readBuffer(p92, n61)
				v1284.universe_id = buffer.tostring(v1289)
			elseif v1286 == 2 then
				local v1290

				v1290, n61 = proto.readBuffer(p92, n61)
				v1284.place_id = buffer.tostring(v1290)
			else
				local v1291, v1292 = proto.readVarInt(p92, n61)

				n61 = v1292 + v1291
			end
		elseif v1287 == proto.wireTypes.i32 then
			local v1293

			v1293, n61 = proto.readFixed32(p92, n61)
		elseif v1287 == proto.wireTypes.i64 then
			local v1294

			v1294, n61 = proto.readFixed64(p92, n61)
		else
			error("Unsupported wire type: " .. v1287)
		end
	end

	return v1284
end
function t140.jsonEncode(p93) -- line: 9672
	local t142 = {}

	if p93.universe_id ~= nil and p93.universe_id ~= "" then
		t142.universeId = p93.universe_id
	end

	if p93.place_id ~= nil and p93.place_id ~= "" then
		t142.placeId = p93.place_id
	end

	return t142
end
function t140.jsonDecode(t143: {[any]: any}) -- line: 9686
	-- upvalues: t140 (copy)
	local v1298 = t140.new()

	if t143.universe_id ~= nil then
		v1298.universe_id = t143.universe_id
	end

	if t143.universeId ~= nil then
		v1298.universe_id = t143.universeId
	end

	if t143.place_id ~= nil then
		v1298.place_id = t143.place_id
	end

	if t143.placeId ~= nil then
		v1298.place_id = t143.placeId
	end

	return v1298
end

t140.descriptor = {
	name = "ExperiencePlayWithRewardInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperiencePlayWithRewardInputData"
}
t1.ExperiencePlayWithRewardInputData = t140
typeRegistry.default:register(t1.ExperiencePlayWithRewardInputData)

local t144 = {}

t144.__index = t144

function t144.new(t145: {[any]: any}?) -- line: 9724
	-- upvalues: t144 (copy)
	return (setmetatable({
		community_id = if t145 ~= nil and t145.community_id ~= nil then t145.community_id else ""
	}, t144))
end
function t144.encode(p94) -- line: 9732
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n62 = 0

	if p94.community_id ~= nil and p94.community_id ~= "" then
		local v1303, v1304 = proto.writeTag(buf, n62, 1, proto.wireTypes.lengthDelimited)

		buf, n62 = proto.writeString(v1303, v1304, p94.community_id)
	end

	local buf35 = buffer.create(n62)

	buffer.copy(buf35, 0, buf, 0, n62)

	return buf35
end
function t144.decode(p95: buffer) -- line: 9746
	-- upvalues: t144 (copy), proto (copy)
	local v1307 = t144.new()
	local n63 = 0

	while n63 < buffer.len(p95) do
		local v1309, v1310

		v1309, v1310, n63 = proto.readTag(p95, n63)

		if v1310 == proto.wireTypes.varint then
			local v1311

			v1311, n63 = proto.readVarInt(p95, n63)
		elseif v1310 == proto.wireTypes.lengthDelimited then
			if v1309 == 1 then
				local v1312

				v1312, n63 = proto.readBuffer(p95, n63)
				v1307.community_id = buffer.tostring(v1312)
			else
				local v1313, v1314 = proto.readVarInt(p95, n63)

				n63 = v1314 + v1313
			end
		elseif v1310 == proto.wireTypes.i32 then
			local v1315

			v1315, n63 = proto.readFixed32(p95, n63)
		elseif v1310 == proto.wireTypes.i64 then
			local v1316

			v1316, n63 = proto.readFixed64(p95, n63)
		else
			error("Unsupported wire type: " .. v1310)
		end
	end

	return v1307
end
function t144.jsonEncode(p96) -- line: 9789
	local t146 = {}

	if p96.community_id ~= nil and p96.community_id ~= "" then
		t146.communityId = p96.community_id
	end

	return t146
end
function t144.jsonDecode(t147: {[any]: any}) -- line: 9799
	-- upvalues: t144 (copy)
	local v1320 = t144.new()

	if t147.community_id ~= nil then
		v1320.community_id = t147.community_id
	end

	if t147.communityId ~= nil then
		v1320.community_id = t147.communityId
	end

	return v1320
end

t144.descriptor = {
	name = "CommunitySectionInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CommunitySectionInputData"
}
t1.CommunitySectionInputData = t144
typeRegistry.default:register(t1.CommunitySectionInputData)

local t148 = {}

t148.__index = t148

function t148.new(t149: {[any]: any}?) -- line: 9827
	-- upvalues: t148 (copy)
	return (setmetatable({
		social_link_items = if t149 ~= nil and t149.social_link_items ~= nil then t149.social_link_items else {}
	}, t148))
end
function t148.encode(p97) -- line: 9833
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n64 = 0

	if p97.social_link_items ~= nil and #p97.social_link_items > 0 then
		for _, v1326 in p97.social_link_items do
			local v1327 = v1326:encode()
			local v1328, v1329 = proto.writeTag(buf, n64, 1, proto.wireTypes.lengthDelimited)

			buf, n64 = proto.writeBuffer(v1328, v1329, v1327, buffer.len(v1327))
		end
	end

	local buf36 = buffer.create(n64)

	buffer.copy(buf36, 0, buf, 0, n64)

	return buf36
end
function t148.decode(p98: buffer) -- line: 9850
	-- upvalues: t148 (copy), proto (copy), t1 (copy)
	local v1332 = t148.new()
	local n65 = 0

	while n65 < buffer.len(p98) do
		local v1334, v1335

		v1334, v1335, n65 = proto.readTag(p98, n65)

		if v1335 == proto.wireTypes.varint then
			local v1336

			v1336, n65 = proto.readVarInt(p98, n65)
		elseif v1335 == proto.wireTypes.lengthDelimited then
			if v1334 == 1 then
				local v1337

				v1337, n65 = proto.readBuffer(p98, n65)
				table.insert(v1332.social_link_items, t1.SocialLinkRowInputData_SocialLinkItem.decode(v1337))
			else
				local v1338, v1339 = proto.readVarInt(p98, n65)

				n65 = v1339 + v1338
			end
		elseif v1335 == proto.wireTypes.i32 then
			local v1340

			v1340, n65 = proto.readFixed32(p98, n65)
		elseif v1335 == proto.wireTypes.i64 then
			local v1341

			v1341, n65 = proto.readFixed64(p98, n65)
		else
			error("Unsupported wire type: " .. v1335)
		end
	end

	return v1332
end
function t148.jsonEncode(p99) -- line: 9893
	local t150 = {}

	if p99.social_link_items ~= nil and #p99.social_link_items > 0 then
		local t151 = {}

		for _, v1346 in p99.social_link_items do
			table.insert(t151, v1346:jsonEncode())
		end

		t150.socialLinkItems = t151
	end

	return t150
end
function t148.jsonDecode(t152: {[any]: any}) -- line: 9907
	-- upvalues: t148 (copy), t1 (copy)
	local v1348 = t148.new()

	if t152.social_link_items ~= nil then
		local t153 = {}

		for _, v1351 in t152.social_link_items do
			table.insert(t153, t1.SocialLinkRowInputData_SocialLinkItem.jsonDecode(v1351))
		end

		v1348.social_link_items = t153
	end

	if t152.socialLinkItems ~= nil then
		local t154 = {}

		for _, v1354 in t152.socialLinkItems do
			table.insert(t154, t1.SocialLinkRowInputData_SocialLinkItem.jsonDecode(v1354))
		end

		v1348.social_link_items = t154
	end

	return v1348
end

t148.descriptor = {
	name = "SocialLinkRowInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.SocialLinkRowInputData"
}
t1.SocialLinkRowInputData = t148
typeRegistry.default:register(t1.SocialLinkRowInputData)

local t155 = {}

t155.__index = t155

function t155.new(t156: {[any]: any}?) -- line: 9945
	-- upvalues: t155 (copy)
	return (setmetatable({
		social_link_id = if t156 ~= nil and t156.social_link_id ~= nil then t156.social_link_id else ""
	}, t155))
end
function t155.encode(p100) -- line: 9953
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n66 = 0

	if p100.social_link_id ~= nil and p100.social_link_id ~= "" then
		local v1359, v1360 = proto.writeTag(buf, n66, 1, proto.wireTypes.lengthDelimited)

		buf, n66 = proto.writeString(v1359, v1360, p100.social_link_id)
	end

	local buf37 = buffer.create(n66)

	buffer.copy(buf37, 0, buf, 0, n66)

	return buf37
end
function t155.decode(p101: buffer) -- line: 9967
	-- upvalues: t155 (copy), proto (copy)
	local v1363 = t155.new()
	local n67 = 0

	while n67 < buffer.len(p101) do
		local v1365, v1366

		v1365, v1366, n67 = proto.readTag(p101, n67)

		if v1366 == proto.wireTypes.varint then
			local v1367

			v1367, n67 = proto.readVarInt(p101, n67)
		elseif v1366 == proto.wireTypes.lengthDelimited then
			if v1365 == 1 then
				local v1368

				v1368, n67 = proto.readBuffer(p101, n67)
				v1363.social_link_id = buffer.tostring(v1368)
			else
				local v1369, v1370 = proto.readVarInt(p101, n67)

				n67 = v1370 + v1369
			end
		elseif v1366 == proto.wireTypes.i32 then
			local v1371

			v1371, n67 = proto.readFixed32(p101, n67)
		elseif v1366 == proto.wireTypes.i64 then
			local v1372

			v1372, n67 = proto.readFixed64(p101, n67)
		else
			error("Unsupported wire type: " .. v1366)
		end
	end

	return v1363
end
function t155.jsonEncode(p102) -- line: 10010
	local t157 = {}

	if p102.social_link_id ~= nil and p102.social_link_id ~= "" then
		t157.socialLinkId = p102.social_link_id
	end

	return t157
end
function t155.jsonDecode(t158: {[any]: any}) -- line: 10020
	-- upvalues: t155 (copy)
	local v1376 = t155.new()

	if t158.social_link_id ~= nil then
		v1376.social_link_id = t158.social_link_id
	end

	if t158.socialLinkId ~= nil then
		v1376.social_link_id = t158.socialLinkId
	end

	return v1376
end

t155.descriptor = {
	name = "SocialLinkRowInputData_SocialLinkItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.SocialLinkItem"
}
t1.SocialLinkRowInputData_SocialLinkItem = t155
typeRegistry.default:register(t1.SocialLinkRowInputData_SocialLinkItem)

local t159 = {}

t159.__index = t159

function t159.new(t160: {[any]: any}?) -- line: 10050
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
function t159.encode(p103) -- line: 10073
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n68 = 0

	if p103.title ~= nil and p103.title ~= "" then
		local v1381, v1382 = proto.writeTag(buf, n68, 1, proto.wireTypes.lengthDelimited)

		buf, n68 = proto.writeString(v1381, v1382, p103.title)
	end

	if p103.universe_items ~= nil and #p103.universe_items > 0 then
		for _, v1384 in p103.universe_items do
			local v1385 = v1384:encode()
			local v1386, v1387 = proto.writeTag(buf, n68, 2, proto.wireTypes.lengthDelimited)

			buf, n68 = proto.writeBuffer(v1386, v1387, v1385, buffer.len(v1385))
		end
	end

	if p103.next_page_token ~= nil and p103.next_page_token ~= "" then
		local v1388, v1389 = proto.writeTag(buf, n68, 3, proto.wireTypes.lengthDelimited)

		buf, n68 = proto.writeString(v1388, v1389, p103.next_page_token)
	end

	if p103.sort_id ~= nil and p103.sort_id ~= "" then
		local v1390, v1391 = proto.writeTag(buf, n68, 4, proto.wireTypes.lengthDelimited)

		buf, n68 = proto.writeString(v1390, v1391, p103.sort_id)
	end

	if p103.secondary_sort_id ~= nil and p103.secondary_sort_id ~= 0 then
		local v1392, v1393 = proto.writeTag(buf, n68, 5, proto.wireTypes.varint)

		buf, n68 = proto.writeVarInt(v1392, v1393, p103.secondary_sort_id)
	end

	if p103.max_visible_rows ~= nil and p103.max_visible_rows ~= 0 then
		local v1394, v1395 = proto.writeTag(buf, n68, 6, proto.wireTypes.varint)

		buf, n68 = proto.writeVarInt(v1394, v1395, p103.max_visible_rows)
	end

	if p103.subtitle ~= nil and p103.subtitle ~= "" then
		local v1396, v1397 = proto.writeTag(buf, n68, 7, proto.wireTypes.lengthDelimited)

		buf, n68 = proto.writeString(v1396, v1397, p103.subtitle)
	end

	if p103.info_text ~= nil and p103.info_text ~= "" then
		local v1398, v1399 = proto.writeTag(buf, n68, 8, proto.wireTypes.lengthDelimited)

		buf, n68 = proto.writeString(v1398, v1399, p103.info_text)
	end

	if p103.subtitle_link_path ~= nil and p103.subtitle_link_path ~= "" then
		local v1400, v1401 = proto.writeTag(buf, n68, 9, proto.wireTypes.lengthDelimited)

		buf, n68 = proto.writeString(v1400, v1401, p103.subtitle_link_path)
	end

	if p103.is_placeholder ~= nil then
		local v1402, v1403 = proto.writeTag(buf, n68, 10, proto.wireTypes.varint)

		buf, n68 = proto.writeVarInt(v1402, v1403, not p103.is_placeholder and 0 or 1)
	end

	if p103.primary_sort_id ~= nil then
		local v1404, v1405 = proto.writeTag(buf, n68, 11, proto.wireTypes.varint)

		buf, n68 = proto.writeVarInt(v1404, v1405, p103.primary_sort_id)
	end

	if p103.applied_filters ~= nil then
		local v1406, v1407 = proto.writeTag(buf, n68, 12, proto.wireTypes.lengthDelimited)

		buf, n68 = proto.writeString(v1406, v1407, p103.applied_filters)
	end

	if p103.pool_id ~= nil then
		local v1408, v1409 = proto.writeTag(buf, n68, 13, proto.wireTypes.lengthDelimited)

		buf, n68 = proto.writeString(v1408, v1409, p103.pool_id)
	end

	if p103.has_emphasized_tile then
		local v1410, v1411 = proto.writeTag(buf, n68, 14, proto.wireTypes.varint)

		buf, n68 = proto.writeVarInt(v1410, v1411, not p103.has_emphasized_tile and 0 or 1)
	end

	local buf38 = buffer.create(n68)

	buffer.copy(buf38, 0, buf, 0, n68)

	return buf38
end
function t159.decode(p104: buffer) -- line: 10155
	-- upvalues: t159 (copy), proto (copy), t1 (copy)
	local v1414 = t159.new()
	local n69 = 0

	while n69 < buffer.len(p104) do
		local v1416, v1417

		v1416, v1417, n69 = proto.readTag(p104, n69)

		if v1417 == proto.wireTypes.varint then
			if v1416 == 5 then
				local v1418

				v1418, n69 = proto.readVarIntI32(p104, n69)
				v1414.secondary_sort_id = v1418
			elseif v1416 == 6 then
				local v1419

				v1419, n69 = proto.readVarIntI32(p104, n69)
				v1414.max_visible_rows = v1419
			elseif v1416 == 10 then
				local v1420

				v1420, n69 = proto.readVarInt(p104, n69)
				v1414.is_placeholder = v1420 ~= 0
			elseif v1416 == 11 then
				local v1421

				v1421, n69 = proto.readVarIntI32(p104, n69)
				v1414.primary_sort_id = v1421
			elseif v1416 == 14 then
				local v1422

				v1422, n69 = proto.readVarInt(p104, n69)
				v1414.has_emphasized_tile = v1422 ~= 0
			else
				local v1423

				v1423, n69 = proto.readVarInt(p104, n69)
			end
		elseif v1417 == proto.wireTypes.lengthDelimited then
			if v1416 == 1 then
				local v1424

				v1424, n69 = proto.readBuffer(p104, n69)
				v1414.title = buffer.tostring(v1424)
			elseif v1416 == 2 then
				local v1425

				v1425, n69 = proto.readBuffer(p104, n69)
				table.insert(v1414.universe_items, t1.ExperienceCarouselInputData_UniverseItem.decode(v1425))
			elseif v1416 == 3 then
				local v1426

				v1426, n69 = proto.readBuffer(p104, n69)
				v1414.next_page_token = buffer.tostring(v1426)
			elseif v1416 == 4 then
				local v1427

				v1427, n69 = proto.readBuffer(p104, n69)
				v1414.sort_id = buffer.tostring(v1427)
			elseif v1416 == 7 then
				local v1428

				v1428, n69 = proto.readBuffer(p104, n69)
				v1414.subtitle = buffer.tostring(v1428)
			elseif v1416 == 8 then
				local v1429

				v1429, n69 = proto.readBuffer(p104, n69)
				v1414.info_text = buffer.tostring(v1429)
			elseif v1416 == 9 then
				local v1430

				v1430, n69 = proto.readBuffer(p104, n69)
				v1414.subtitle_link_path = buffer.tostring(v1430)
			elseif v1416 == 12 then
				local v1431

				v1431, n69 = proto.readBuffer(p104, n69)
				v1414.applied_filters = buffer.tostring(v1431)
			elseif v1416 == 13 then
				local v1432

				v1432, n69 = proto.readBuffer(p104, n69)
				v1414.pool_id = buffer.tostring(v1432)
			else
				local v1433, v1434 = proto.readVarInt(p104, n69)

				n69 = v1434 + v1433
			end
		elseif v1417 == proto.wireTypes.i32 then
			local v1435

			v1435, n69 = proto.readFixed32(p104, n69)
		elseif v1417 == proto.wireTypes.i64 then
			local v1436

			v1436, n69 = proto.readFixed64(p104, n69)
		else
			error("Unsupported wire type: " .. v1417)
		end
	end

	return v1414
end
function t159.jsonEncode(p105) -- line: 10263
	local t161 = {}

	if p105.title ~= nil and p105.title ~= "" then
		t161.title = p105.title
	end

	if p105.universe_items ~= nil and #p105.universe_items > 0 then
		local t162 = {}

		for _, v1441 in p105.universe_items do
			table.insert(t162, v1441:jsonEncode())
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
function t159.jsonDecode(t163: {[any]: any}) -- line: 10329
	-- upvalues: t159 (copy), t1 (copy)
	local v1443 = t159.new()

	if t163.title ~= nil then
		v1443.title = t163.title
	end

	if t163.universe_items ~= nil then
		local t164 = {}

		for _, v1446 in t163.universe_items do
			table.insert(t164, t1.ExperienceCarouselInputData_UniverseItem.jsonDecode(v1446))
		end

		v1443.universe_items = t164
	end

	if t163.universeItems ~= nil then
		local t165 = {}

		for _, v1449 in t163.universeItems do
			table.insert(t165, t1.ExperienceCarouselInputData_UniverseItem.jsonDecode(v1449))
		end

		v1443.universe_items = t165
	end

	if t163.next_page_token ~= nil then
		v1443.next_page_token = t163.next_page_token
	end

	if t163.nextPageToken ~= nil then
		v1443.next_page_token = t163.nextPageToken
	end

	if t163.sort_id ~= nil then
		v1443.sort_id = t163.sort_id
	end

	if t163.sortId ~= nil then
		v1443.sort_id = t163.sortId
	end

	if t163.secondary_sort_id ~= nil then
		v1443.secondary_sort_id = t163.secondary_sort_id
	end

	if t163.secondarySortId ~= nil then
		v1443.secondary_sort_id = t163.secondarySortId
	end

	if t163.max_visible_rows ~= nil then
		v1443.max_visible_rows = t163.max_visible_rows
	end

	if t163.maxVisibleRows ~= nil then
		v1443.max_visible_rows = t163.maxVisibleRows
	end

	if t163.subtitle ~= nil then
		v1443.subtitle = t163.subtitle
	end

	if t163.info_text ~= nil then
		v1443.info_text = t163.info_text
	end

	if t163.infoText ~= nil then
		v1443.info_text = t163.infoText
	end

	if t163.subtitle_link_path ~= nil then
		v1443.subtitle_link_path = t163.subtitle_link_path
	end

	if t163.subtitleLinkPath ~= nil then
		v1443.subtitle_link_path = t163.subtitleLinkPath
	end

	if t163.is_placeholder ~= nil then
		v1443.is_placeholder = t163.is_placeholder
	end

	if t163.isPlaceholder ~= nil then
		v1443.is_placeholder = t163.isPlaceholder
	end

	if t163.primary_sort_id ~= nil then
		v1443.primary_sort_id = t163.primary_sort_id
	end

	if t163.primarySortId ~= nil then
		v1443.primary_sort_id = t163.primarySortId
	end

	if t163.applied_filters ~= nil then
		v1443.applied_filters = t163.applied_filters
	end

	if t163.appliedFilters ~= nil then
		v1443.applied_filters = t163.appliedFilters
	end

	if t163.pool_id ~= nil then
		v1443.pool_id = t163.pool_id
	end

	if t163.poolId ~= nil then
		v1443.pool_id = t163.poolId
	end

	if t163.has_emphasized_tile ~= nil then
		v1443.has_emphasized_tile = t163.has_emphasized_tile
	end

	if t163.hasEmphasizedTile ~= nil then
		v1443.has_emphasized_tile = t163.hasEmphasizedTile
	end

	return v1443
end

t159.descriptor = {
	name = "ExperienceCarouselInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceCarouselInputData"
}
t1.ExperienceCarouselInputData = t159
typeRegistry.default:register(t1.ExperienceCarouselInputData)

local t166 = {}

t166.__index = t166

function t166.new(t167: {[any]: any}?) -- line: 10463
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
		creator_key = if t167 ~= nil and t167.creator_key ~= nil then t167.creator_key else "",
		rank = if t167 ~= nil and t167.rank ~= nil then t167.rank else nil
	}, t166))
end
function t166.encode(p106) -- line: 10483
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n70 = 0

	if p106.universe_id ~= nil and p106.universe_id ~= "" then
		local v1454, v1455 = proto.writeTag(buf, n70, 1, proto.wireTypes.lengthDelimited)

		buf, n70 = proto.writeString(v1454, v1455, p106.universe_id)
	end

	if p106.is_sponsored then
		local v1456, v1457 = proto.writeTag(buf, n70, 2, proto.wireTypes.varint)

		buf, n70 = proto.writeVarInt(v1456, v1457, not p106.is_sponsored and 0 or 1)
	end

	if p106.roblox_component ~= nil and p106.roblox_component ~= "" then
		local v1458, v1459 = proto.writeTag(buf, n70, 3, proto.wireTypes.lengthDelimited)

		buf, n70 = proto.writeString(v1458, v1459, p106.roblox_component)
	end

	if p106.native_ad_data ~= nil and p106.native_ad_data ~= "" then
		local v1460, v1461 = proto.writeTag(buf, n70, 4, proto.wireTypes.lengthDelimited)

		buf, n70 = proto.writeString(v1460, v1461, p106.native_ad_data)
	end

	if p106.is_content_locked then
		local v1462, v1463 = proto.writeTag(buf, n70, 5, proto.wireTypes.varint)

		buf, n70 = proto.writeVarInt(v1462, v1463, not p106.is_content_locked and 0 or 1)
	end

	if p106.title ~= nil and p106.title ~= "" then
		local v1464, v1465 = proto.writeTag(buf, n70, 6, proto.wireTypes.lengthDelimited)

		buf, n70 = proto.writeString(v1464, v1465, p106.title)
	end

	if p106.subtitle ~= nil and p106.subtitle ~= "" then
		local v1466, v1467 = proto.writeTag(buf, n70, 7, proto.wireTypes.lengthDelimited)

		buf, n70 = proto.writeString(v1466, v1467, p106.subtitle)
	end

	if p106.image_asset_id ~= nil and p106.image_asset_id ~= "" then
		local v1468, v1469 = proto.writeTag(buf, n70, 8, proto.wireTypes.lengthDelimited)

		buf, n70 = proto.writeString(v1468, v1469, p106.image_asset_id)
	end

	if p106.video_asset_id ~= nil and p106.video_asset_id ~= "" then
		local v1470, v1471 = proto.writeTag(buf, n70, 9, proto.wireTypes.lengthDelimited)

		buf, n70 = proto.writeString(v1470, v1471, p106.video_asset_id)
	end

	if p106.badge_text ~= nil and p106.badge_text ~= "" then
		local v1472, v1473 = proto.writeTag(buf, n70, 10, proto.wireTypes.lengthDelimited)

		buf, n70 = proto.writeString(v1472, v1473, p106.badge_text)
	end

	if p106.player_count ~= nil then
		local v1474, v1475 = proto.writeTag(buf, n70, 11, proto.wireTypes.varint)

		buf, n70 = proto.writeVarInt(v1474, v1475, p106.player_count)
	end

	if p106.creator_key ~= nil and p106.creator_key ~= "" then
		local v1476, v1477 = proto.writeTag(buf, n70, 12, proto.wireTypes.lengthDelimited)

		buf, n70 = proto.writeString(v1476, v1477, p106.creator_key)
	end

	if p106.rank ~= nil then
		local v1478, v1479 = proto.writeTag(buf, n70, 13, proto.wireTypes.varint)

		buf, n70 = proto.writeVarInt(v1478, v1479, p106.rank)
	end

	local buf39 = buffer.create(n70)

	buffer.copy(buf39, 0, buf, 0, n70)

	return buf39
end
function t166.decode(p107: buffer) -- line: 10559
	-- upvalues: t166 (copy), proto (copy)
	local v1482 = t166.new()
	local n71 = 0

	while n71 < buffer.len(p107) do
		local v1484, v1485

		v1484, v1485, n71 = proto.readTag(p107, n71)

		if v1485 == proto.wireTypes.varint then
			if v1484 == 2 then
				local v1486

				v1486, n71 = proto.readVarInt(p107, n71)
				v1482.is_sponsored = v1486 ~= 0
			elseif v1484 == 5 then
				local v1487

				v1487, n71 = proto.readVarInt(p107, n71)
				v1482.is_content_locked = v1487 ~= 0
			elseif v1484 == 11 then
				local v1488

				v1488, n71 = proto.readVarIntI64(p107, n71)
				v1482.player_count = v1488
			elseif v1484 == 13 then
				local v1489

				v1489, n71 = proto.readVarIntI32(p107, n71)
				v1482.rank = v1489
			else
				local v1490

				v1490, n71 = proto.readVarInt(p107, n71)
			end
		elseif v1485 == proto.wireTypes.lengthDelimited then
			if v1484 == 1 then
				local v1491

				v1491, n71 = proto.readBuffer(p107, n71)
				v1482.universe_id = buffer.tostring(v1491)
			elseif v1484 == 3 then
				local v1492

				v1492, n71 = proto.readBuffer(p107, n71)
				v1482.roblox_component = buffer.tostring(v1492)
			elseif v1484 == 4 then
				local v1493

				v1493, n71 = proto.readBuffer(p107, n71)
				v1482.native_ad_data = buffer.tostring(v1493)
			elseif v1484 == 6 then
				local v1494

				v1494, n71 = proto.readBuffer(p107, n71)
				v1482.title = buffer.tostring(v1494)
			elseif v1484 == 7 then
				local v1495

				v1495, n71 = proto.readBuffer(p107, n71)
				v1482.subtitle = buffer.tostring(v1495)
			elseif v1484 == 8 then
				local v1496

				v1496, n71 = proto.readBuffer(p107, n71)
				v1482.image_asset_id = buffer.tostring(v1496)
			elseif v1484 == 9 then
				local v1497

				v1497, n71 = proto.readBuffer(p107, n71)
				v1482.video_asset_id = buffer.tostring(v1497)
			elseif v1484 == 10 then
				local v1498

				v1498, n71 = proto.readBuffer(p107, n71)
				v1482.badge_text = buffer.tostring(v1498)
			elseif v1484 == 12 then
				local v1499

				v1499, n71 = proto.readBuffer(p107, n71)
				v1482.creator_key = buffer.tostring(v1499)
			else
				local v1500, v1501 = proto.readVarInt(p107, n71)

				n71 = v1501 + v1500
			end
		elseif v1485 == proto.wireTypes.i32 then
			local v1502

			v1502, n71 = proto.readFixed32(p107, n71)
		elseif v1485 == proto.wireTypes.i64 then
			local v1503

			v1503, n71 = proto.readFixed64(p107, n71)
		else
			error("Unsupported wire type: " .. v1485)
		end
	end

	return v1482
end
function t166.jsonEncode(p108) -- line: 10664
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

	if p108.rank ~= nil then
		t168.rank = p108.rank
	end

	return t168
end
function t166.jsonDecode(t169: {[any]: any}) -- line: 10724
	-- upvalues: t166 (copy)
	local v1507 = t166.new()

	if t169.universe_id ~= nil then
		v1507.universe_id = t169.universe_id
	end

	if t169.universeId ~= nil then
		v1507.universe_id = t169.universeId
	end

	if t169.is_sponsored ~= nil then
		v1507.is_sponsored = t169.is_sponsored
	end

	if t169.isSponsored ~= nil then
		v1507.is_sponsored = t169.isSponsored
	end

	if t169.roblox_component ~= nil then
		v1507.roblox_component = t169.roblox_component
	end

	if t169.robloxComponent ~= nil then
		v1507.roblox_component = t169.robloxComponent
	end

	if t169.native_ad_data ~= nil then
		v1507.native_ad_data = t169.native_ad_data
	end

	if t169.nativeAdData ~= nil then
		v1507.native_ad_data = t169.nativeAdData
	end

	if t169.is_content_locked ~= nil then
		v1507.is_content_locked = t169.is_content_locked
	end

	if t169.isContentLocked ~= nil then
		v1507.is_content_locked = t169.isContentLocked
	end

	if t169.title ~= nil then
		v1507.title = t169.title
	end

	if t169.subtitle ~= nil then
		v1507.subtitle = t169.subtitle
	end

	if t169.image_asset_id ~= nil then
		v1507.image_asset_id = t169.image_asset_id
	end

	if t169.imageAssetId ~= nil then
		v1507.image_asset_id = t169.imageAssetId
	end

	if t169.video_asset_id ~= nil then
		v1507.video_asset_id = t169.video_asset_id
	end

	if t169.videoAssetId ~= nil then
		v1507.video_asset_id = t169.videoAssetId
	end

	if t169.badge_text ~= nil then
		v1507.badge_text = t169.badge_text
	end

	if t169.badgeText ~= nil then
		v1507.badge_text = t169.badgeText
	end

	if t169.player_count ~= nil then
		v1507.player_count = t169.player_count
	end

	if t169.playerCount ~= nil then
		v1507.player_count = t169.playerCount
	end

	if t169.creator_key ~= nil then
		v1507.creator_key = t169.creator_key
	end

	if t169.creatorKey ~= nil then
		v1507.creator_key = t169.creatorKey
	end

	if t169.rank ~= nil then
		v1507.rank = t169.rank
	end

	return v1507
end

t166.descriptor = {
	name = "ExperienceCarouselInputData_UniverseItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniverseItem"
}
t1.ExperienceCarouselInputData_UniverseItem = t166
typeRegistry.default:register(t1.ExperienceCarouselInputData_UniverseItem)

local t170 = {}

t170.__index = t170

function t170.new(t171: {[any]: any}?) -- line: 10838
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
function t170.encode(p109) -- line: 10854
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n72 = 0

	if p109.title ~= nil and p109.title ~= "" then
		local v1512, v1513 = proto.writeTag(buf, n72, 1, proto.wireTypes.lengthDelimited)

		buf, n72 = proto.writeString(v1512, v1513, p109.title)
	end

	if p109.song_items ~= nil and #p109.song_items > 0 then
		for _, v1515 in p109.song_items do
			local v1516 = v1515:encode()
			local v1517, v1518 = proto.writeTag(buf, n72, 2, proto.wireTypes.lengthDelimited)

			buf, n72 = proto.writeBuffer(v1517, v1518, v1516, buffer.len(v1516))
		end
	end

	if p109.next_page_token ~= nil and p109.next_page_token ~= "" then
		local v1519, v1520 = proto.writeTag(buf, n72, 3, proto.wireTypes.lengthDelimited)

		buf, n72 = proto.writeString(v1519, v1520, p109.next_page_token)
	end

	if p109.sort_id ~= nil and p109.sort_id ~= "" then
		local v1521, v1522 = proto.writeTag(buf, n72, 4, proto.wireTypes.lengthDelimited)

		buf, n72 = proto.writeString(v1521, v1522, p109.sort_id)
	end

	if p109.secondary_sort_id ~= nil and p109.secondary_sort_id ~= 0 then
		local v1523, v1524 = proto.writeTag(buf, n72, 5, proto.wireTypes.varint)

		buf, n72 = proto.writeVarInt(v1523, v1524, p109.secondary_sort_id)
	end

	if p109.subtitle ~= nil and p109.subtitle ~= "" then
		local v1525, v1526 = proto.writeTag(buf, n72, 6, proto.wireTypes.lengthDelimited)

		buf, n72 = proto.writeString(v1525, v1526, p109.subtitle)
	end

	if p109.info_text ~= nil and p109.info_text ~= "" then
		local v1527, v1528 = proto.writeTag(buf, n72, 7, proto.wireTypes.lengthDelimited)

		buf, n72 = proto.writeString(v1527, v1528, p109.info_text)
	end

	if p109.subtitle_link_path ~= nil and p109.subtitle_link_path ~= "" then
		local v1529, v1530 = proto.writeTag(buf, n72, 8, proto.wireTypes.lengthDelimited)

		buf, n72 = proto.writeString(v1529, v1530, p109.subtitle_link_path)
	end

	if p109.is_placeholder ~= nil then
		local v1531, v1532 = proto.writeTag(buf, n72, 9, proto.wireTypes.varint)

		buf, n72 = proto.writeVarInt(v1531, v1532, not p109.is_placeholder and 0 or 1)
	end

	if p109.primary_sort_id ~= nil then
		local v1533, v1534 = proto.writeTag(buf, n72, 10, proto.wireTypes.varint)

		buf, n72 = proto.writeVarInt(v1533, v1534, p109.primary_sort_id)
	end

	if p109.applied_filters ~= nil then
		local v1535, v1536 = proto.writeTag(buf, n72, 11, proto.wireTypes.lengthDelimited)

		buf, n72 = proto.writeString(v1535, v1536, p109.applied_filters)
	end

	local buf40 = buffer.create(n72)

	buffer.copy(buf40, 0, buf, 0, n72)

	return buf40
end
function t170.decode(p110: buffer) -- line: 10921
	-- upvalues: t170 (copy), proto (copy), t1 (copy)
	local v1539 = t170.new()
	local n73 = 0

	while n73 < buffer.len(p110) do
		local v1541, v1542

		v1541, v1542, n73 = proto.readTag(p110, n73)

		if v1542 == proto.wireTypes.varint then
			if v1541 == 5 then
				local v1543

				v1543, n73 = proto.readVarIntI32(p110, n73)
				v1539.secondary_sort_id = v1543
			elseif v1541 == 9 then
				local v1544

				v1544, n73 = proto.readVarInt(p110, n73)
				v1539.is_placeholder = v1544 ~= 0
			elseif v1541 == 10 then
				local v1545

				v1545, n73 = proto.readVarIntI32(p110, n73)
				v1539.primary_sort_id = v1545
			else
				local v1546

				v1546, n73 = proto.readVarInt(p110, n73)
			end
		elseif v1542 == proto.wireTypes.lengthDelimited then
			if v1541 == 1 then
				local v1547

				v1547, n73 = proto.readBuffer(p110, n73)
				v1539.title = buffer.tostring(v1547)
			elseif v1541 == 2 then
				local v1548

				v1548, n73 = proto.readBuffer(p110, n73)
				table.insert(v1539.song_items, t1.SongCarouselInputData_SongItem.decode(v1548))
			elseif v1541 == 3 then
				local v1549

				v1549, n73 = proto.readBuffer(p110, n73)
				v1539.next_page_token = buffer.tostring(v1549)
			elseif v1541 == 4 then
				local v1550

				v1550, n73 = proto.readBuffer(p110, n73)
				v1539.sort_id = buffer.tostring(v1550)
			elseif v1541 == 6 then
				local v1551

				v1551, n73 = proto.readBuffer(p110, n73)
				v1539.subtitle = buffer.tostring(v1551)
			elseif v1541 == 7 then
				local v1552

				v1552, n73 = proto.readBuffer(p110, n73)
				v1539.info_text = buffer.tostring(v1552)
			elseif v1541 == 8 then
				local v1553

				v1553, n73 = proto.readBuffer(p110, n73)
				v1539.subtitle_link_path = buffer.tostring(v1553)
			elseif v1541 == 11 then
				local v1554

				v1554, n73 = proto.readBuffer(p110, n73)
				v1539.applied_filters = buffer.tostring(v1554)
			else
				local v1555, v1556 = proto.readVarInt(p110, n73)

				n73 = v1556 + v1555
			end
		elseif v1542 == proto.wireTypes.i32 then
			local v1557

			v1557, n73 = proto.readFixed32(p110, n73)
		elseif v1542 == proto.wireTypes.i64 then
			local v1558

			v1558, n73 = proto.readFixed64(p110, n73)
		else
			error("Unsupported wire type: " .. v1542)
		end
	end

	return v1539
end
function t170.jsonEncode(p111) -- line: 11014
	local t172 = {}

	if p111.title ~= nil and p111.title ~= "" then
		t172.title = p111.title
	end

	if p111.song_items ~= nil and #p111.song_items > 0 then
		local t173 = {}

		for _, v1563 in p111.song_items do
			table.insert(t173, v1563:jsonEncode())
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
function t170.jsonDecode(t174: {[any]: any}) -- line: 11068
	-- upvalues: t170 (copy), t1 (copy)
	local v1565 = t170.new()

	if t174.title ~= nil then
		v1565.title = t174.title
	end

	if t174.song_items ~= nil then
		local t175 = {}

		for _, v1568 in t174.song_items do
			table.insert(t175, t1.SongCarouselInputData_SongItem.jsonDecode(v1568))
		end

		v1565.song_items = t175
	end

	if t174.songItems ~= nil then
		local t176 = {}

		for _, v1571 in t174.songItems do
			table.insert(t176, t1.SongCarouselInputData_SongItem.jsonDecode(v1571))
		end

		v1565.song_items = t176
	end

	if t174.next_page_token ~= nil then
		v1565.next_page_token = t174.next_page_token
	end

	if t174.nextPageToken ~= nil then
		v1565.next_page_token = t174.nextPageToken
	end

	if t174.sort_id ~= nil then
		v1565.sort_id = t174.sort_id
	end

	if t174.sortId ~= nil then
		v1565.sort_id = t174.sortId
	end

	if t174.secondary_sort_id ~= nil then
		v1565.secondary_sort_id = t174.secondary_sort_id
	end

	if t174.secondarySortId ~= nil then
		v1565.secondary_sort_id = t174.secondarySortId
	end

	if t174.subtitle ~= nil then
		v1565.subtitle = t174.subtitle
	end

	if t174.info_text ~= nil then
		v1565.info_text = t174.info_text
	end

	if t174.infoText ~= nil then
		v1565.info_text = t174.infoText
	end

	if t174.subtitle_link_path ~= nil then
		v1565.subtitle_link_path = t174.subtitle_link_path
	end

	if t174.subtitleLinkPath ~= nil then
		v1565.subtitle_link_path = t174.subtitleLinkPath
	end

	if t174.is_placeholder ~= nil then
		v1565.is_placeholder = t174.is_placeholder
	end

	if t174.isPlaceholder ~= nil then
		v1565.is_placeholder = t174.isPlaceholder
	end

	if t174.primary_sort_id ~= nil then
		v1565.primary_sort_id = t174.primary_sort_id
	end

	if t174.primarySortId ~= nil then
		v1565.primary_sort_id = t174.primarySortId
	end

	if t174.applied_filters ~= nil then
		v1565.applied_filters = t174.applied_filters
	end

	if t174.appliedFilters ~= nil then
		v1565.applied_filters = t174.appliedFilters
	end

	return v1565
end

t170.descriptor = {
	name = "SongCarouselInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.SongCarouselInputData"
}
t1.SongCarouselInputData = t170
typeRegistry.default:register(t1.SongCarouselInputData)

local t177 = {}

t177.__index = t177

function t177.new(t178: {[any]: any}?) -- line: 11178
	-- upvalues: t177 (copy)
	return (setmetatable({
		song_id = if t178 ~= nil and t178.song_id ~= nil then t178.song_id else ""
	}, t177))
end
function t177.encode(p112) -- line: 11186
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n74 = 0

	if p112.song_id ~= nil and p112.song_id ~= "" then
		local v1576, v1577 = proto.writeTag(buf, n74, 1, proto.wireTypes.lengthDelimited)

		buf, n74 = proto.writeString(v1576, v1577, p112.song_id)
	end

	local buf41 = buffer.create(n74)

	buffer.copy(buf41, 0, buf, 0, n74)

	return buf41
end
function t177.decode(p113: buffer) -- line: 11200
	-- upvalues: t177 (copy), proto (copy)
	local v1580 = t177.new()
	local n75 = 0

	while n75 < buffer.len(p113) do
		local v1582, v1583

		v1582, v1583, n75 = proto.readTag(p113, n75)

		if v1583 == proto.wireTypes.varint then
			local v1584

			v1584, n75 = proto.readVarInt(p113, n75)
		elseif v1583 == proto.wireTypes.lengthDelimited then
			if v1582 == 1 then
				local v1585

				v1585, n75 = proto.readBuffer(p113, n75)
				v1580.song_id = buffer.tostring(v1585)
			else
				local v1586, v1587 = proto.readVarInt(p113, n75)

				n75 = v1587 + v1586
			end
		elseif v1583 == proto.wireTypes.i32 then
			local v1588

			v1588, n75 = proto.readFixed32(p113, n75)
		elseif v1583 == proto.wireTypes.i64 then
			local v1589

			v1589, n75 = proto.readFixed64(p113, n75)
		else
			error("Unsupported wire type: " .. v1583)
		end
	end

	return v1580
end
function t177.jsonEncode(p114) -- line: 11243
	local t179 = {}

	if p114.song_id ~= nil and p114.song_id ~= "" then
		t179.songId = p114.song_id
	end

	return t179
end
function t177.jsonDecode(t180: {[any]: any}) -- line: 11253
	-- upvalues: t177 (copy)
	local v1593 = t177.new()

	if t180.song_id ~= nil then
		v1593.song_id = t180.song_id
	end

	if t180.songId ~= nil then
		v1593.song_id = t180.songId
	end

	return v1593
end

t177.descriptor = {
	name = "SongCarouselInputData_SongItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.SongItem"
}
t1.SongCarouselInputData_SongItem = t177
typeRegistry.default:register(t1.SongCarouselInputData_SongItem)

local t181 = {}

t181.__index = t181

function t181.new(t182: {[any]: any}?) -- line: 11281
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
function t181.encode(p115) -- line: 11292
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n76 = 0

	if p115.title ~= nil and p115.title ~= "" then
		local v1598, v1599 = proto.writeTag(buf, n76, 1, proto.wireTypes.lengthDelimited)

		buf, n76 = proto.writeString(v1598, v1599, p115.title)
	end

	if p115.event_items ~= nil and #p115.event_items > 0 then
		for _, v1601 in p115.event_items do
			local v1602 = v1601:encode()
			local v1603, v1604 = proto.writeTag(buf, n76, 2, proto.wireTypes.lengthDelimited)

			buf, n76 = proto.writeBuffer(v1603, v1604, v1602, buffer.len(v1602))
		end
	end

	if p115.universe_id ~= nil and p115.universe_id ~= "" then
		local v1605, v1606 = proto.writeTag(buf, n76, 3, proto.wireTypes.lengthDelimited)

		buf, n76 = proto.writeString(v1605, v1606, p115.universe_id)
	end

	if p115.sort_id ~= nil and p115.sort_id ~= "" then
		local v1607, v1608 = proto.writeTag(buf, n76, 4, proto.wireTypes.lengthDelimited)

		buf, n76 = proto.writeString(v1607, v1608, p115.sort_id)
	end

	if p115.subtitle ~= nil and p115.subtitle ~= "" then
		local v1609, v1610 = proto.writeTag(buf, n76, 5, proto.wireTypes.lengthDelimited)

		buf, n76 = proto.writeString(v1609, v1610, p115.subtitle)
	end

	if p115.info_text ~= nil and p115.info_text ~= "" then
		local v1611, v1612 = proto.writeTag(buf, n76, 6, proto.wireTypes.lengthDelimited)

		buf, n76 = proto.writeString(v1611, v1612, p115.info_text)
	end

	local buf42 = buffer.create(n76)

	buffer.copy(buf42, 0, buf, 0, n76)

	return buf42
end
function t181.decode(p116: buffer) -- line: 11334
	-- upvalues: t181 (copy), proto (copy), t1 (copy)
	local v1615 = t181.new()
	local n77 = 0

	while n77 < buffer.len(p116) do
		local v1617, v1618

		v1617, v1618, n77 = proto.readTag(p116, n77)

		if v1618 == proto.wireTypes.varint then
			local v1619

			v1619, n77 = proto.readVarInt(p116, n77)
		elseif v1618 == proto.wireTypes.lengthDelimited then
			if v1617 == 1 then
				local v1620

				v1620, n77 = proto.readBuffer(p116, n77)
				v1615.title = buffer.tostring(v1620)
			elseif v1617 == 2 then
				local v1621

				v1621, n77 = proto.readBuffer(p116, n77)
				table.insert(v1615.event_items, t1.EventsCarouselInputData_EventItem.decode(v1621))
			elseif v1617 == 3 then
				local v1622

				v1622, n77 = proto.readBuffer(p116, n77)
				v1615.universe_id = buffer.tostring(v1622)
			elseif v1617 == 4 then
				local v1623

				v1623, n77 = proto.readBuffer(p116, n77)
				v1615.sort_id = buffer.tostring(v1623)
			elseif v1617 == 5 then
				local v1624

				v1624, n77 = proto.readBuffer(p116, n77)
				v1615.subtitle = buffer.tostring(v1624)
			elseif v1617 == 6 then
				local v1625

				v1625, n77 = proto.readBuffer(p116, n77)
				v1615.info_text = buffer.tostring(v1625)
			else
				local v1626, v1627 = proto.readVarInt(p116, n77)

				n77 = v1627 + v1626
			end
		elseif v1618 == proto.wireTypes.i32 then
			local v1628

			v1628, n77 = proto.readFixed32(p116, n77)
		elseif v1618 == proto.wireTypes.i64 then
			local v1629

			v1629, n77 = proto.readFixed64(p116, n77)
		else
			error("Unsupported wire type: " .. v1618)
		end
	end

	return v1615
end
function t181.jsonEncode(p117) -- line: 11402
	local t183 = {}

	if p117.title ~= nil and p117.title ~= "" then
		t183.title = p117.title
	end

	if p117.event_items ~= nil and #p117.event_items > 0 then
		local t184 = {}

		for _, v1634 in p117.event_items do
			table.insert(t184, v1634:jsonEncode())
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
function t181.jsonDecode(t185: {[any]: any}) -- line: 11436
	-- upvalues: t181 (copy), t1 (copy)
	local v1636 = t181.new()

	if t185.title ~= nil then
		v1636.title = t185.title
	end

	if t185.event_items ~= nil then
		local t186 = {}

		for _, v1639 in t185.event_items do
			table.insert(t186, t1.EventsCarouselInputData_EventItem.jsonDecode(v1639))
		end

		v1636.event_items = t186
	end

	if t185.eventItems ~= nil then
		local t187 = {}

		for _, v1642 in t185.eventItems do
			table.insert(t187, t1.EventsCarouselInputData_EventItem.jsonDecode(v1642))
		end

		v1636.event_items = t187
	end

	if t185.universe_id ~= nil then
		v1636.universe_id = t185.universe_id
	end

	if t185.universeId ~= nil then
		v1636.universe_id = t185.universeId
	end

	if t185.sort_id ~= nil then
		v1636.sort_id = t185.sort_id
	end

	if t185.sortId ~= nil then
		v1636.sort_id = t185.sortId
	end

	if t185.subtitle ~= nil then
		v1636.subtitle = t185.subtitle
	end

	if t185.info_text ~= nil then
		v1636.info_text = t185.info_text
	end

	if t185.infoText ~= nil then
		v1636.info_text = t185.infoText
	end

	return v1636
end

t181.descriptor = {
	name = "EventsCarouselInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventsCarouselInputData"
}
t1.EventsCarouselInputData = t181
typeRegistry.default:register(t1.EventsCarouselInputData)

local t188 = {}

t188.__index = t188

function t188.new(t189: {[any]: any}?) -- line: 11506
	-- upvalues: t188 (copy)
	return (setmetatable({
		event_id = if t189 ~= nil and t189.event_id ~= nil then t189.event_id else ""
	}, t188))
end
function t188.encode(p118) -- line: 11514
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n78 = 0

	if p118.event_id ~= nil and p118.event_id ~= "" then
		local v1647, v1648 = proto.writeTag(buf, n78, 1, proto.wireTypes.lengthDelimited)

		buf, n78 = proto.writeString(v1647, v1648, p118.event_id)
	end

	local buf43 = buffer.create(n78)

	buffer.copy(buf43, 0, buf, 0, n78)

	return buf43
end
function t188.decode(p119: buffer) -- line: 11528
	-- upvalues: t188 (copy), proto (copy)
	local v1651 = t188.new()
	local n79 = 0

	while n79 < buffer.len(p119) do
		local v1653, v1654

		v1653, v1654, n79 = proto.readTag(p119, n79)

		if v1654 == proto.wireTypes.varint then
			local v1655

			v1655, n79 = proto.readVarInt(p119, n79)
		elseif v1654 == proto.wireTypes.lengthDelimited then
			if v1653 == 1 then
				local v1656

				v1656, n79 = proto.readBuffer(p119, n79)
				v1651.event_id = buffer.tostring(v1656)
			else
				local v1657, v1658 = proto.readVarInt(p119, n79)

				n79 = v1658 + v1657
			end
		elseif v1654 == proto.wireTypes.i32 then
			local v1659

			v1659, n79 = proto.readFixed32(p119, n79)
		elseif v1654 == proto.wireTypes.i64 then
			local v1660

			v1660, n79 = proto.readFixed64(p119, n79)
		else
			error("Unsupported wire type: " .. v1654)
		end
	end

	return v1651
end
function t188.jsonEncode(p120) -- line: 11571
	local t190 = {}

	if p120.event_id ~= nil and p120.event_id ~= "" then
		t190.eventId = p120.event_id
	end

	return t190
end
function t188.jsonDecode(t191: {[any]: any}) -- line: 11581
	-- upvalues: t188 (copy)
	local v1664 = t188.new()

	if t191.event_id ~= nil then
		v1664.event_id = t191.event_id
	end

	if t191.eventId ~= nil then
		v1664.event_id = t191.eventId
	end

	return v1664
end

t188.descriptor = {
	name = "EventsCarouselInputData_EventItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventItem"
}
t1.EventsCarouselInputData_EventItem = t188
typeRegistry.default:register(t1.EventsCarouselInputData_EventItem)

local t192 = {}

t192.__index = t192

function t192.new(t193: {[any]: any}?) -- line: 11611
	-- upvalues: t192 (copy)
	return (setmetatable({
		universe_id = if t193 ~= nil and t193.universe_id ~= nil then t193.universe_id else "",
		entry_map = if t193 ~= nil and t193.entry_map ~= nil then t193.entry_map else {},
		entry_order = if t193 ~= nil and t193.entry_order ~= nil then t193.entry_order else {},
		creator_key = if t193 ~= nil and t193.creator_key ~= nil then t193.creator_key else ""
	}, t192))
end
function t192.encode(p121) -- line: 11620
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n80 = 0

	if p121.universe_id ~= nil and p121.universe_id ~= "" then
		local v1669, v1670 = proto.writeTag(buf, n80, 1, proto.wireTypes.lengthDelimited)

		buf, n80 = proto.writeString(v1669, v1670, p121.universe_id)
	end

	if p121.entry_map ~= nil and next(p121.entry_map) ~= nil then
		for v1671, v1672 in p121.entry_map do
			local buf44 = buffer.create(0)
			local v1674, v1675 = proto.writeTag(buf44, 0, 1, proto.wireTypes.lengthDelimited)
			local v1676, v1677 = proto.writeString(v1674, v1675, v1671)
			local v1678 = v1672:encode()
			local v1679, v1680 = proto.writeTag(v1676, v1677, 2, proto.wireTypes.lengthDelimited)
			local v1681, v1682 = proto.writeBuffer(v1679, v1680, v1678, buffer.len(v1678))
			local v1683, v1684 = proto.writeTag(buf, n80, 2, proto.wireTypes.lengthDelimited)

			buf, n80 = proto.writeBuffer(v1683, v1684, v1681, v1682)
		end
	end

	if p121.entry_order ~= nil and #p121.entry_order > 0 then
		for _, v1686 in p121.entry_order do
			local v1687, v1688 = proto.writeTag(buf, n80, 3, proto.wireTypes.lengthDelimited)

			buf, n80 = proto.writeString(v1687, v1688, v1686)
		end
	end

	if p121.creator_key ~= nil and p121.creator_key ~= "" then
		local v1689, v1690 = proto.writeTag(buf, n80, 4, proto.wireTypes.lengthDelimited)

		buf, n80 = proto.writeString(v1689, v1690, p121.creator_key)
	end

	local buf45 = buffer.create(n80)

	buffer.copy(buf45, 0, buf, 0, n80)

	return buf45
end
function t192.decode(p122: buffer) -- line: 11660
	-- upvalues: t192 (copy), proto (copy), t1 (copy)
	local v1693 = t192.new()
	local n81 = 0

	while n81 < buffer.len(p122) do
		local v1695, v1696

		v1695, v1696, n81 = proto.readTag(p122, n81)

		if v1696 == proto.wireTypes.varint then
			local v1697

			v1697, n81 = proto.readVarInt(p122, n81)
		elseif v1696 == proto.wireTypes.lengthDelimited then
			if v1695 == 1 then
				local v1698

				v1698, n81 = proto.readBuffer(p122, n81)
				v1693.universe_id = buffer.tostring(v1698)
			elseif v1695 == 2 then
				local v1699

				v1699, n81 = proto.readBuffer(p122, n81)

				local v1700 = t1.DevStoreFeedInputData_EntryMapEntry.decode(v1699)
				local v1701 = t1.FeedEntry.new()

				v1693.entry_map[v1700.key or ""] = v1700.value or v1701
			elseif v1695 == 3 then
				local v1702

				v1702, n81 = proto.readBuffer(p122, n81)
				table.insert(v1693.entry_order, buffer.tostring(v1702))
			elseif v1695 == 4 then
				local v1703

				v1703, n81 = proto.readBuffer(p122, n81)
				v1693.creator_key = buffer.tostring(v1703)
			else
				local v1704, v1705 = proto.readVarInt(p122, n81)

				n81 = v1705 + v1704
			end
		elseif v1696 == proto.wireTypes.i32 then
			local v1706

			v1706, n81 = proto.readFixed32(p122, n81)
		elseif v1696 == proto.wireTypes.i64 then
			local v1707

			v1707, n81 = proto.readFixed64(p122, n81)
		else
			error("Unsupported wire type: " .. v1696)
		end
	end

	return v1693
end
function t192.jsonEncode(p123) -- line: 11725
	local t194 = {}

	if p123.universe_id ~= nil and p123.universe_id ~= "" then
		t194.universeId = p123.universe_id
	end

	if p123.entry_map ~= nil and next(p123.entry_map) ~= nil then
		local t195 = {}

		for v1711, v1712 in p123.entry_map do
			t195[v1711] = v1712:jsonEncode()
		end

		t194.entryMap = t195
	end

	if p123.entry_order ~= nil and #p123.entry_order > 0 then
		local t196 = {}

		for _, v1715 in p123.entry_order do
			table.insert(t196, v1715)
		end

		t194.entryOrder = t196
	end

	if p123.creator_key ~= nil and p123.creator_key ~= "" then
		t194.creatorKey = p123.creator_key
	end

	return t194
end
function t192.jsonDecode(t197: {[any]: any}) -- line: 11755
	-- upvalues: t192 (copy), t1 (copy)
	local v1717 = t192.new()

	if t197.universe_id ~= nil then
		v1717.universe_id = t197.universe_id
	end

	if t197.universeId ~= nil then
		v1717.universe_id = t197.universeId
	end

	if t197.entry_map ~= nil then
		local t198 = {}

		for v1719, v1720 in t197.entry_map do
			t198[v1719] = t1.FeedEntry.jsonDecode(v1720)
		end

		v1717.entry_map = t198
	end

	if t197.entryMap ~= nil then
		local t199 = {}

		for v1722, v1723 in t197.entryMap do
			t199[v1722] = t1.FeedEntry.jsonDecode(v1723)
		end

		v1717.entry_map = t199
	end

	if t197.entry_order ~= nil then
		local t200 = {}

		for _, v1726 in t197.entry_order do
			table.insert(t200, v1726)
		end

		v1717.entry_order = t200
	end

	if t197.entryOrder ~= nil then
		local t201 = {}

		for _, v1729 in t197.entryOrder do
			table.insert(t201, v1729)
		end

		v1717.entry_order = t201
	end

	if t197.creator_key ~= nil then
		v1717.creator_key = t197.creator_key
	end

	if t197.creatorKey ~= nil then
		v1717.creator_key = t197.creatorKey
	end

	return v1717
end

t192.descriptor = {
	name = "DevStoreFeedInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.DevStoreFeedInputData"
}
t1.DevStoreFeedInputData = t192
typeRegistry.default:register(t1.DevStoreFeedInputData)

local t202 = {}

t202.__index = t202

function t202.new(t203: {[any]: any}?) -- line: 11827
	-- upvalues: t202 (copy)
	return (setmetatable({
		key = if t203 ~= nil and t203.key ~= nil then t203.key else "",
		value = if t203 ~= nil and t203.value ~= nil then t203.value else nil
	}, t202))
end
function t202.encode(p124) -- line: 11836
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n82 = 0

	if p124.key ~= nil and p124.key ~= "" then
		local v1734, v1735 = proto.writeTag(buf, n82, 1, proto.wireTypes.lengthDelimited)

		buf, n82 = proto.writeString(v1734, v1735, p124.key)
	end

	if p124.value ~= nil then
		local v1736 = p124.value:encode()
		local v1737, v1738 = proto.writeTag(buf, n82, 2, proto.wireTypes.lengthDelimited)

		buf, n82 = proto.writeBuffer(v1737, v1738, v1736, buffer.len(v1736))
	end

	local buf46 = buffer.create(n82)

	buffer.copy(buf46, 0, buf, 0, n82)

	return buf46
end
function t202.decode(p125: buffer) -- line: 11856
	-- upvalues: t202 (copy), proto (copy), t1 (copy)
	local v1741 = t202.new()
	local n83 = 0

	while n83 < buffer.len(p125) do
		local v1743, v1744

		v1743, v1744, n83 = proto.readTag(p125, n83)

		if v1744 == proto.wireTypes.varint then
			local v1745

			v1745, n83 = proto.readVarInt(p125, n83)
		elseif v1744 == proto.wireTypes.lengthDelimited then
			if v1743 == 1 then
				local v1746

				v1746, n83 = proto.readBuffer(p125, n83)
				v1741.key = buffer.tostring(v1746)
			elseif v1743 == 2 then
				local v1747

				v1747, n83 = proto.readBuffer(p125, n83)
				v1741.value = t1.FeedEntry.decode(v1747)
			else
				local v1748, v1749 = proto.readVarInt(p125, n83)

				n83 = v1749 + v1748
			end
		elseif v1744 == proto.wireTypes.i32 then
			local v1750

			v1750, n83 = proto.readFixed32(p125, n83)
		elseif v1744 == proto.wireTypes.i64 then
			local v1751

			v1751, n83 = proto.readFixed64(p125, n83)
		else
			error("Unsupported wire type: " .. v1744)
		end
	end

	return v1741
end
function t202.jsonEncode(p126) -- line: 11904
	local t204 = {}

	if p126.key ~= nil and p126.key ~= "" then
		t204.key = p126.key
	end

	if p126.value ~= nil then
		t204.value = p126.value:jsonEncode()
	end

	return t204
end
function t202.jsonDecode(t205: {[any]: any}) -- line: 11918
	-- upvalues: t202 (copy), t1 (copy)
	local v1755 = t202.new()

	if t205.key ~= nil then
		v1755.key = t205.key
	end

	if t205.value ~= nil then
		v1755.value = t1.FeedEntry.jsonDecode(t205.value)
	end

	return v1755
end

t202.descriptor = {
	name = "DevStoreFeedInputData_EntryMapEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryMapEntry"
}
t1.DevStoreFeedInputData_EntryMapEntry = t202
typeRegistry.default:register(t1.DevStoreFeedInputData_EntryMapEntry)

local t206 = {}

t206.__index = t206

function t206.new(t207: {[any]: any}?) -- line: 11948
	-- upvalues: t206 (copy)
	return (setmetatable({
		game_passes = if t207 ~= nil and t207.game_passes ~= nil then t207.game_passes else {}
	}, t206))
end
function t206.encode(p127) -- line: 11956
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n84 = 0

	if p127.game_passes ~= nil and #p127.game_passes > 0 then
		for _, v1761 in p127.game_passes do
			local v1762 = v1761:encode()
			local v1763, v1764 = proto.writeTag(buf, n84, 1, proto.wireTypes.lengthDelimited)

			buf, n84 = proto.writeBuffer(v1763, v1764, v1762, buffer.len(v1762))
		end
	end

	local buf47 = buffer.create(n84)

	buffer.copy(buf47, 0, buf, 0, n84)

	return buf47
end
function t206.decode(p128: buffer) -- line: 11973
	-- upvalues: t206 (copy), proto (copy), t1 (copy)
	local v1767 = t206.new()
	local n85 = 0

	while n85 < buffer.len(p128) do
		local v1769, v1770

		v1769, v1770, n85 = proto.readTag(p128, n85)

		if v1770 == proto.wireTypes.varint then
			local v1771

			v1771, n85 = proto.readVarInt(p128, n85)
		elseif v1770 == proto.wireTypes.lengthDelimited then
			if v1769 == 1 then
				local v1772

				v1772, n85 = proto.readBuffer(p128, n85)
				table.insert(v1767.game_passes, t1.GamePassCollectionInputData_GamePassItem.decode(v1772))
			else
				local v1773, v1774 = proto.readVarInt(p128, n85)

				n85 = v1774 + v1773
			end
		elseif v1770 == proto.wireTypes.i32 then
			local v1775

			v1775, n85 = proto.readFixed32(p128, n85)
		elseif v1770 == proto.wireTypes.i64 then
			local v1776

			v1776, n85 = proto.readFixed64(p128, n85)
		else
			error("Unsupported wire type: " .. v1770)
		end
	end

	return v1767
end
function t206.jsonEncode(p129) -- line: 12016
	local t208 = {}

	if p129.game_passes ~= nil and #p129.game_passes > 0 then
		local t209 = {}

		for _, v1781 in p129.game_passes do
			table.insert(t209, v1781:jsonEncode())
		end

		t208.gamePasses = t209
	end

	return t208
end
function t206.jsonDecode(t210: {[any]: any}) -- line: 12030
	-- upvalues: t206 (copy), t1 (copy)
	local v1783 = t206.new()

	if t210.game_passes ~= nil then
		local t211 = {}

		for _, v1786 in t210.game_passes do
			table.insert(t211, t1.GamePassCollectionInputData_GamePassItem.jsonDecode(v1786))
		end

		v1783.game_passes = t211
	end

	if t210.gamePasses ~= nil then
		local t212 = {}

		for _, v1789 in t210.gamePasses do
			table.insert(t212, t1.GamePassCollectionInputData_GamePassItem.jsonDecode(v1789))
		end

		v1783.game_passes = t212
	end

	return v1783
end

t206.descriptor = {
	name = "GamePassCollectionInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.GamePassCollectionInputData"
}
t1.GamePassCollectionInputData = t206
typeRegistry.default:register(t1.GamePassCollectionInputData)

local t213 = {}

t213.__index = t213

function t213.new(t214: {[any]: any}?) -- line: 12068
	-- upvalues: t213 (copy)
	return (setmetatable({
		game_pass_id = if t214 ~= nil and t214.game_pass_id ~= nil then t214.game_pass_id else ""
	}, t213))
end
function t213.encode(p130) -- line: 12076
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n86 = 0

	if p130.game_pass_id ~= nil and p130.game_pass_id ~= "" then
		local v1794, v1795 = proto.writeTag(buf, n86, 1, proto.wireTypes.lengthDelimited)

		buf, n86 = proto.writeString(v1794, v1795, p130.game_pass_id)
	end

	local buf48 = buffer.create(n86)

	buffer.copy(buf48, 0, buf, 0, n86)

	return buf48
end
function t213.decode(p131: buffer) -- line: 12092
	-- upvalues: t213 (copy), proto (copy)
	local v1798 = t213.new()
	local n87 = 0

	while n87 < buffer.len(p131) do
		local v1800, v1801

		v1800, v1801, n87 = proto.readTag(p131, n87)

		if v1801 == proto.wireTypes.varint then
			local v1802

			v1802, n87 = proto.readVarInt(p131, n87)
		elseif v1801 == proto.wireTypes.lengthDelimited then
			if v1800 == 1 then
				local v1803

				v1803, n87 = proto.readBuffer(p131, n87)
				v1798.game_pass_id = buffer.tostring(v1803)
			else
				local v1804, v1805 = proto.readVarInt(p131, n87)

				n87 = v1805 + v1804
			end
		elseif v1801 == proto.wireTypes.i32 then
			local v1806

			v1806, n87 = proto.readFixed32(p131, n87)
		elseif v1801 == proto.wireTypes.i64 then
			local v1807

			v1807, n87 = proto.readFixed64(p131, n87)
		else
			error("Unsupported wire type: " .. v1801)
		end
	end

	return v1798
end
function t213.jsonEncode(p132) -- line: 12137
	local t215 = {}

	if p132.game_pass_id ~= nil and p132.game_pass_id ~= "" then
		t215.gamePassId = p132.game_pass_id
	end

	return t215
end
function t213.jsonDecode(t216: {[any]: any}) -- line: 12149
	-- upvalues: t213 (copy)
	local v1811 = t213.new()

	if t216.game_pass_id ~= nil then
		v1811.game_pass_id = t216.game_pass_id
	end

	if t216.gamePassId ~= nil then
		v1811.game_pass_id = t216.gamePassId
	end

	return v1811
end

t213.descriptor = {
	name = "GamePassCollectionInputData_GamePassItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.GamePassItem"
}
t1.GamePassCollectionInputData_GamePassItem = t213
typeRegistry.default:register(t1.GamePassCollectionInputData_GamePassItem)

local t217 = {}

t217.__index = t217

function t217.new(t218: {[any]: any}?) -- line: 12179
	-- upvalues: t217 (copy)
	return (setmetatable({
		developer_products = if t218 ~= nil and t218.developer_products ~= nil then t218.developer_products else {}
	}, t217))
end
function t217.encode(p133) -- line: 12187
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n88 = 0

	if p133.developer_products ~= nil and #p133.developer_products > 0 then
		for _, v1817 in p133.developer_products do
			local v1818 = v1817:encode()
			local v1819, v1820 = proto.writeTag(buf, n88, 1, proto.wireTypes.lengthDelimited)

			buf, n88 = proto.writeBuffer(v1819, v1820, v1818, buffer.len(v1818))
		end
	end

	local buf49 = buffer.create(n88)

	buffer.copy(buf49, 0, buf, 0, n88)

	return buf49
end
function t217.decode(p134: buffer) -- line: 12204
	-- upvalues: t217 (copy), proto (copy), t1 (copy)
	local v1823 = t217.new()
	local n89 = 0

	while n89 < buffer.len(p134) do
		local v1825, v1826

		v1825, v1826, n89 = proto.readTag(p134, n89)

		if v1826 == proto.wireTypes.varint then
			local v1827

			v1827, n89 = proto.readVarInt(p134, n89)
		elseif v1826 == proto.wireTypes.lengthDelimited then
			if v1825 == 1 then
				local v1828

				v1828, n89 = proto.readBuffer(p134, n89)
				table.insert(v1823.developer_products, t1.DeveloperProductCollectionInputData_DeveloperProductItem.decode(v1828))
			else
				local v1829, v1830 = proto.readVarInt(p134, n89)

				n89 = v1830 + v1829
			end
		elseif v1826 == proto.wireTypes.i32 then
			local v1831

			v1831, n89 = proto.readFixed32(p134, n89)
		elseif v1826 == proto.wireTypes.i64 then
			local v1832

			v1832, n89 = proto.readFixed64(p134, n89)
		else
			error("Unsupported wire type: " .. v1826)
		end
	end

	return v1823
end
function t217.jsonEncode(p135) -- line: 12250
	local t219 = {}

	if p135.developer_products ~= nil and #p135.developer_products > 0 then
		local t220 = {}

		for _, v1837 in p135.developer_products do
			table.insert(t220, v1837:jsonEncode())
		end

		t219.developerProducts = t220
	end

	return t219
end
function t217.jsonDecode(t221: {[any]: any}) -- line: 12264
	-- upvalues: t217 (copy), t1 (copy)
	local v1839 = t217.new()

	if t221.developer_products ~= nil then
		local t222 = {}

		for _, v1842 in t221.developer_products do
			table.insert(t222, t1.DeveloperProductCollectionInputData_DeveloperProductItem.jsonDecode(v1842))
		end

		v1839.developer_products = t222
	end

	if t221.developerProducts ~= nil then
		local t223 = {}

		for _, v1845 in t221.developerProducts do
			table.insert(t223, t1.DeveloperProductCollectionInputData_DeveloperProductItem.jsonDecode(v1845))
		end

		v1839.developer_products = t223
	end

	return v1839
end

t217.descriptor = {
	name = "DeveloperProductCollectionInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.DeveloperProductCollectionInputData"
}
t1.DeveloperProductCollectionInputData = t217
typeRegistry.default:register(t1.DeveloperProductCollectionInputData)

local t224 = {}

t224.__index = t224

function t224.new(t225: {[any]: any}?) -- line: 12311
	-- upvalues: t224 (copy)
	return (setmetatable({
		developer_product_id = if t225 ~= nil and t225.developer_product_id ~= nil then t225.developer_product_id else ""
	}, t224))
end
function t224.encode(p136) -- line: 12324
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n90 = 0

	if p136.developer_product_id ~= nil and p136.developer_product_id ~= "" then
		local v1850, v1851 = proto.writeTag(buf, n90, 1, proto.wireTypes.lengthDelimited)

		buf, n90 = proto.writeString(v1850, v1851, p136.developer_product_id)
	end

	local buf50 = buffer.create(n90)

	buffer.copy(buf50, 0, buf, 0, n90)

	return buf50
end
function t224.decode(p137: buffer) -- line: 12340
	-- upvalues: t224 (copy), proto (copy)
	local v1854 = t224.new()
	local n91 = 0

	while n91 < buffer.len(p137) do
		local v1856, v1857

		v1856, v1857, n91 = proto.readTag(p137, n91)

		if v1857 == proto.wireTypes.varint then
			local v1858

			v1858, n91 = proto.readVarInt(p137, n91)
		elseif v1857 == proto.wireTypes.lengthDelimited then
			if v1856 == 1 then
				local v1859

				v1859, n91 = proto.readBuffer(p137, n91)
				v1854.developer_product_id = buffer.tostring(v1859)
			else
				local v1860, v1861 = proto.readVarInt(p137, n91)

				n91 = v1861 + v1860
			end
		elseif v1857 == proto.wireTypes.i32 then
			local v1862

			v1862, n91 = proto.readFixed32(p137, n91)
		elseif v1857 == proto.wireTypes.i64 then
			local v1863

			v1863, n91 = proto.readFixed64(p137, n91)
		else
			error("Unsupported wire type: " .. v1857)
		end
	end

	return v1854
end
function t224.jsonEncode(p138) -- line: 12385
	local t226 = {}

	if p138.developer_product_id ~= nil and p138.developer_product_id ~= "" then
		t226.developerProductId = p138.developer_product_id
	end

	return t226
end
function t224.jsonDecode(t227: {[any]: any}) -- line: 12397
	-- upvalues: t224 (copy)
	local v1867 = t224.new()

	if t227.developer_product_id ~= nil then
		v1867.developer_product_id = t227.developer_product_id
	end

	if t227.developerProductId ~= nil then
		v1867.developer_product_id = t227.developerProductId
	end

	return v1867
end

t224.descriptor = {
	name = "DeveloperProductCollectionInputData_DeveloperProductItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.DeveloperProductItem"
}
t1.DeveloperProductCollectionInputData_DeveloperProductItem = t224
typeRegistry.default:register(t1.DeveloperProductCollectionInputData_DeveloperProductItem)

local t228 = {}

t228.__index = t228

function t228.new(t229: {[any]: any}?) -- line: 12428
	-- upvalues: t228 (copy)
	return (setmetatable({
		subscriptions = if t229 ~= nil and t229.subscriptions ~= nil then t229.subscriptions else {}
	}, t228))
end
function t228.encode(p139) -- line: 12436
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n92 = 0

	if p139.subscriptions ~= nil and #p139.subscriptions > 0 then
		for _, v1873 in p139.subscriptions do
			local v1874 = v1873:encode()
			local v1875, v1876 = proto.writeTag(buf, n92, 1, proto.wireTypes.lengthDelimited)

			buf, n92 = proto.writeBuffer(v1875, v1876, v1874, buffer.len(v1874))
		end
	end

	local buf51 = buffer.create(n92)

	buffer.copy(buf51, 0, buf, 0, n92)

	return buf51
end
function t228.decode(p140: buffer) -- line: 12453
	-- upvalues: t228 (copy), proto (copy), t1 (copy)
	local v1879 = t228.new()
	local n93 = 0

	while n93 < buffer.len(p140) do
		local v1881, v1882

		v1881, v1882, n93 = proto.readTag(p140, n93)

		if v1882 == proto.wireTypes.varint then
			local v1883

			v1883, n93 = proto.readVarInt(p140, n93)
		elseif v1882 == proto.wireTypes.lengthDelimited then
			if v1881 == 1 then
				local v1884

				v1884, n93 = proto.readBuffer(p140, n93)
				table.insert(v1879.subscriptions, t1.SubscriptionCollectionInputData_SubscriptionItem.decode(v1884))
			else
				local v1885, v1886 = proto.readVarInt(p140, n93)

				n93 = v1886 + v1885
			end
		elseif v1882 == proto.wireTypes.i32 then
			local v1887

			v1887, n93 = proto.readFixed32(p140, n93)
		elseif v1882 == proto.wireTypes.i64 then
			local v1888

			v1888, n93 = proto.readFixed64(p140, n93)
		else
			error("Unsupported wire type: " .. v1882)
		end
	end

	return v1879
end
function t228.jsonEncode(p141) -- line: 12499
	local t230 = {}

	if p141.subscriptions ~= nil and #p141.subscriptions > 0 then
		local t231 = {}

		for _, v1893 in p141.subscriptions do
			table.insert(t231, v1893:jsonEncode())
		end

		t230.subscriptions = t231
	end

	return t230
end
function t228.jsonDecode(t232: {[any]: any}) -- line: 12513
	-- upvalues: t228 (copy), t1 (copy)
	local v1895 = t228.new()

	if t232.subscriptions ~= nil then
		local t233 = {}

		for _, v1898 in t232.subscriptions do
			table.insert(t233, t1.SubscriptionCollectionInputData_SubscriptionItem.jsonDecode(v1898))
		end

		v1895.subscriptions = t233
	end

	return v1895
end

t228.descriptor = {
	name = "SubscriptionCollectionInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.SubscriptionCollectionInputData"
}
t1.SubscriptionCollectionInputData = t228
typeRegistry.default:register(t1.SubscriptionCollectionInputData)

local t234 = {}

t234.__index = t234

function t234.new(t235: {[any]: any}?) -- line: 12543
	-- upvalues: t234 (copy)
	return (setmetatable({
		subscription_id = if t235 ~= nil and t235.subscription_id ~= nil then t235.subscription_id else ""
	}, t234))
end
function t234.encode(p142) -- line: 12554
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n94 = 0

	if p142.subscription_id ~= nil and p142.subscription_id ~= "" then
		local v1903, v1904 = proto.writeTag(buf, n94, 1, proto.wireTypes.lengthDelimited)

		buf, n94 = proto.writeString(v1903, v1904, p142.subscription_id)
	end

	local buf52 = buffer.create(n94)

	buffer.copy(buf52, 0, buf, 0, n94)

	return buf52
end
function t234.decode(p143: buffer) -- line: 12570
	-- upvalues: t234 (copy), proto (copy)
	local v1907 = t234.new()
	local n95 = 0

	while n95 < buffer.len(p143) do
		local v1909, v1910

		v1909, v1910, n95 = proto.readTag(p143, n95)

		if v1910 == proto.wireTypes.varint then
			local v1911

			v1911, n95 = proto.readVarInt(p143, n95)
		elseif v1910 == proto.wireTypes.lengthDelimited then
			if v1909 == 1 then
				local v1912

				v1912, n95 = proto.readBuffer(p143, n95)
				v1907.subscription_id = buffer.tostring(v1912)
			else
				local v1913, v1914 = proto.readVarInt(p143, n95)

				n95 = v1914 + v1913
			end
		elseif v1910 == proto.wireTypes.i32 then
			local v1915

			v1915, n95 = proto.readFixed32(p143, n95)
		elseif v1910 == proto.wireTypes.i64 then
			local v1916

			v1916, n95 = proto.readFixed64(p143, n95)
		else
			error("Unsupported wire type: " .. v1910)
		end
	end

	return v1907
end
function t234.jsonEncode(p144) -- line: 12615
	local t236 = {}

	if p144.subscription_id ~= nil and p144.subscription_id ~= "" then
		t236.subscriptionId = p144.subscription_id
	end

	return t236
end
function t234.jsonDecode(t237: {[any]: any}) -- line: 12627
	-- upvalues: t234 (copy)
	local v1920 = t234.new()

	if t237.subscription_id ~= nil then
		v1920.subscription_id = t237.subscription_id
	end

	if t237.subscriptionId ~= nil then
		v1920.subscription_id = t237.subscriptionId
	end

	return v1920
end

t234.descriptor = {
	name = "SubscriptionCollectionInputData_SubscriptionItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.SubscriptionItem"
}
t1.SubscriptionCollectionInputData_SubscriptionItem = t234
typeRegistry.default:register(t1.SubscriptionCollectionInputData_SubscriptionItem)

local t238 = {}

t238.__index = t238

function t238.new(t239: {[any]: any}?) -- line: 12658
	-- upvalues: t238 (copy)
	return (setmetatable({
		items = if t239 ~= nil and t239.items ~= nil then t239.items else {},
		universe_id = if t239 ~= nil and t239.universe_id ~= nil then t239.universe_id else "",
		section_title = if t239 ~= nil and t239.section_title ~= nil then t239.section_title else ""
	}, t238))
end
function t238.encode(p145) -- line: 12668
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n96 = 0

	if p145.items ~= nil and #p145.items > 0 then
		for _, v1926 in p145.items do
			local v1927 = v1926:encode()
			local v1928, v1929 = proto.writeTag(buf, n96, 1, proto.wireTypes.lengthDelimited)

			buf, n96 = proto.writeBuffer(v1928, v1929, v1927, buffer.len(v1927))
		end
	end

	if p145.universe_id ~= nil and p145.universe_id ~= "" then
		local v1930, v1931 = proto.writeTag(buf, n96, 2, proto.wireTypes.lengthDelimited)

		buf, n96 = proto.writeString(v1930, v1931, p145.universe_id)
	end

	if p145.section_title ~= nil and p145.section_title ~= "" then
		local v1932, v1933 = proto.writeTag(buf, n96, 3, proto.wireTypes.lengthDelimited)

		buf, n96 = proto.writeString(v1932, v1933, p145.section_title)
	end

	local buf53 = buffer.create(n96)

	buffer.copy(buf53, 0, buf, 0, n96)

	return buf53
end
function t238.decode(p146: buffer) -- line: 12695
	-- upvalues: t238 (copy), proto (copy), t1 (copy)
	local v1936 = t238.new()
	local n97 = 0

	while n97 < buffer.len(p146) do
		local v1938, v1939

		v1938, v1939, n97 = proto.readTag(p146, n97)

		if v1939 == proto.wireTypes.varint then
			local v1940

			v1940, n97 = proto.readVarInt(p146, n97)
		elseif v1939 == proto.wireTypes.lengthDelimited then
			if v1938 == 1 then
				local v1941

				v1941, n97 = proto.readBuffer(p146, n97)
				table.insert(v1936.items, t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItem.decode(v1941))
			elseif v1938 == 2 then
				local v1942

				v1942, n97 = proto.readBuffer(p146, n97)
				v1936.universe_id = buffer.tostring(v1942)
			elseif v1938 == 3 then
				local v1943

				v1943, n97 = proto.readBuffer(p146, n97)
				v1936.section_title = buffer.tostring(v1943)
			else
				local v1944, v1945 = proto.readVarInt(p146, n97)

				n97 = v1945 + v1944
			end
		elseif v1939 == proto.wireTypes.i32 then
			local v1946

			v1946, n97 = proto.readFixed32(p146, n97)
		elseif v1939 == proto.wireTypes.i64 then
			local v1947

			v1947, n97 = proto.readFixed64(p146, n97)
		else
			error("Unsupported wire type: " .. v1939)
		end
	end

	return v1936
end
function t238.jsonEncode(p147) -- line: 12751
	local t240 = {}

	if p147.items ~= nil and #p147.items > 0 then
		local t241 = {}

		for _, v1952 in p147.items do
			table.insert(t241, v1952:jsonEncode())
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
function t238.jsonDecode(t242: {[any]: any}) -- line: 12773
	-- upvalues: t238 (copy), t1 (copy)
	local v1954 = t238.new()

	if t242.items ~= nil then
		local t243 = {}

		for _, v1957 in t242.items do
			table.insert(t243, t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItem.jsonDecode(v1957))
		end

		v1954.items = t243
	end

	if t242.universe_id ~= nil then
		v1954.universe_id = t242.universe_id
	end

	if t242.universeId ~= nil then
		v1954.universe_id = t242.universeId
	end

	if t242.section_title ~= nil then
		v1954.section_title = t242.section_title
	end

	if t242.sectionTitle ~= nil then
		v1954.section_title = t242.sectionTitle
	end

	return v1954
end

t238.descriptor = {
	name = "DynamicStoreCategoryInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.DynamicStoreCategoryInputData"
}
t1.DynamicStoreCategoryInputData = t238
typeRegistry.default:register(t1.DynamicStoreCategoryInputData)

local t244 = {}

t244.__index = t244

function t244.new(t245: {[any]: any}?) -- line: 12822
	-- upvalues: t1 (copy), t244 (copy)
	return (setmetatable({
		item_id = if t245 ~= nil and t245.item_id ~= nil then t245.item_id else "",
		identifier = if t245 ~= nil and t245.identifier ~= nil then t245.identifier else assert(t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItemType.fromNumber(0), "Enum has no 0 default")
	}, t244))
end
function t244.encode(p148) -- line: 12839
	-- upvalues: proto (copy), t1 (copy)
	local buf = buffer.create(0)
	local n98 = 0

	if p148.item_id ~= nil and p148.item_id ~= "" then
		local v1962, v1963 = proto.writeTag(buf, n98, 1, proto.wireTypes.lengthDelimited)

		buf, n98 = proto.writeString(v1962, v1963, p148.item_id)
	end

	if p148.identifier ~= nil and (p148.identifier ~= nil and p148.identifier ~= 0 or p148.identifier ~= t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItemType.fromNumber(0)) then
		local v1964, v1965 = proto.writeTag(buf, n98, 2, proto.wireTypes.varint)

		buf, n98 = proto.writeVarInt(v1964, v1965, t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItemType.toNumber(p148.identifier))
	end

	local buf54 = buffer.create(n98)

	buffer.copy(buf54, 0, buf, 0, n98)

	return buf54
end
function t244.decode(p149: buffer) -- line: 12871
	-- upvalues: t244 (copy), proto (copy), t1 (copy)
	local v1968 = t244.new()
	local n99 = 0

	while n99 < buffer.len(p149) do
		local v1970, v1971

		v1970, v1971, n99 = proto.readTag(p149, n99)

		if v1971 == proto.wireTypes.varint then
			if v1970 == 2 then
				local v1972

				v1972, n99 = proto.readVarIntI32(p149, n99)
				v1968.identifier = t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItemType.fromNumber(v1972) or v1972
			else
				local v1973

				v1973, n99 = proto.readVarInt(p149, n99)
			end
		elseif v1971 == proto.wireTypes.lengthDelimited then
			if v1970 == 1 then
				local v1974

				v1974, n99 = proto.readBuffer(p149, n99)
				v1968.item_id = buffer.tostring(v1974)
			else
				local v1975, v1976 = proto.readVarInt(p149, n99)

				n99 = v1976 + v1975
			end
		elseif v1971 == proto.wireTypes.i32 then
			local v1977

			v1977, n99 = proto.readFixed32(p149, n99)
		elseif v1971 == proto.wireTypes.i64 then
			local v1978

			v1978, n99 = proto.readFixed64(p149, n99)
		else
			error("Unsupported wire type: " .. v1971)
		end
	end

	return v1968
end
function t244.jsonEncode(p150) -- line: 12923
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
function t244.jsonDecode(t247: {[any]: any}) -- line: 12950
	-- upvalues: t244 (copy), t1 (copy)
	local v1982 = t244.new()

	if t247.item_id ~= nil then
		v1982.item_id = t247.item_id
	end

	if t247.itemId ~= nil then
		v1982.item_id = t247.itemId
	end

	if t247.identifier ~= nil then
		v1982.identifier = if typeof(t247.identifier) ~= "number" then t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItemType.fromName(t247.identifier) or t247.identifier else t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItemType.fromNumber(t247.identifier) or t247.identifier
	end

	return v1982
end

t244.descriptor = {
	name = "DynamicStoreCategoryInputData_DynamicStoreCategoryItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.DynamicStoreCategoryItem"
}
t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItem = t244
typeRegistry.default:register(t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItem)
t1.DynamicStoreCategoryInputData_DynamicStoreCategoryItemType = {
	fromNumber = function(n100: number) -- line: 12989
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
	toNumber = function(p151) -- line: 13001
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
	fromName = function(s1: string) -- line: 13013
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

function t248.new(t249: {[any]: any}?) -- line: 13030
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
function t248.encode(p152) -- line: 13046
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n101 = 0

	if p152.roblox_component ~= nil and p152.roblox_component ~= "" then
		local v1990, v1991 = proto.writeTag(buf, n101, 1, proto.wireTypes.lengthDelimited)

		buf, n101 = proto.writeString(v1990, v1991, p152.roblox_component)
	end

	if p152.identifier ~= nil and p152.identifier ~= "" then
		local v1992, v1993 = proto.writeTag(buf, n101, 2, proto.wireTypes.lengthDelimited)

		buf, n101 = proto.writeString(v1992, v1993, p152.identifier)
	end

	if p152.title ~= nil and p152.title ~= "" then
		local v1994, v1995 = proto.writeTag(buf, n101, 3, proto.wireTypes.lengthDelimited)

		buf, n101 = proto.writeString(v1994, v1995, p152.title)
	end

	if p152.user_id ~= nil and p152.user_id ~= "" then
		local v1996, v1997 = proto.writeTag(buf, n101, 4, proto.wireTypes.lengthDelimited)

		buf, n101 = proto.writeString(v1996, v1997, p152.user_id)
	end

	if p152.description ~= nil and p152.description ~= "" then
		local v1998, v1999 = proto.writeTag(buf, n101, 5, proto.wireTypes.lengthDelimited)

		buf, n101 = proto.writeString(v1998, v1999, p152.description)
	end

	if p152.cta_text ~= nil and p152.cta_text ~= "" then
		local v2000, v2001 = proto.writeTag(buf, n101, 6, proto.wireTypes.lengthDelimited)

		buf, n101 = proto.writeString(v2000, v2001, p152.cta_text)
	end

	if p152.prompt_id ~= nil and p152.prompt_id ~= "" then
		local v2002, v2003 = proto.writeTag(buf, n101, 7, proto.wireTypes.lengthDelimited)

		buf, n101 = proto.writeString(v2002, v2003, p152.prompt_id)
	end

	if p152.prompt_type ~= nil and p152.prompt_type ~= "" then
		local v2004, v2005 = proto.writeTag(buf, n101, 8, proto.wireTypes.lengthDelimited)

		buf, n101 = proto.writeString(v2004, v2005, p152.prompt_type)
	end

	if p152.entity_id ~= nil and p152.entity_id ~= "" then
		local v2006, v2007 = proto.writeTag(buf, n101, 9, proto.wireTypes.lengthDelimited)

		buf, n101 = proto.writeString(v2006, v2007, p152.entity_id)
	end

	local buf55 = buffer.create(n101)

	buffer.copy(buf55, 0, buf, 0, n101)

	return buf55
end
function t248.decode(p153: buffer) -- line: 13100
	-- upvalues: t248 (copy), proto (copy)
	local v2010 = t248.new()
	local n102 = 0

	while n102 < buffer.len(p153) do
		local v2012, v2013

		v2012, v2013, n102 = proto.readTag(p153, n102)

		if v2013 == proto.wireTypes.varint then
			local v2014

			v2014, n102 = proto.readVarInt(p153, n102)
		elseif v2013 == proto.wireTypes.lengthDelimited then
			if v2012 == 1 then
				local v2015

				v2015, n102 = proto.readBuffer(p153, n102)
				v2010.roblox_component = buffer.tostring(v2015)
			elseif v2012 == 2 then
				local v2016

				v2016, n102 = proto.readBuffer(p153, n102)
				v2010.identifier = buffer.tostring(v2016)
			elseif v2012 == 3 then
				local v2017

				v2017, n102 = proto.readBuffer(p153, n102)
				v2010.title = buffer.tostring(v2017)
			elseif v2012 == 4 then
				local v2018

				v2018, n102 = proto.readBuffer(p153, n102)
				v2010.user_id = buffer.tostring(v2018)
			elseif v2012 == 5 then
				local v2019

				v2019, n102 = proto.readBuffer(p153, n102)
				v2010.description = buffer.tostring(v2019)
			elseif v2012 == 6 then
				local v2020

				v2020, n102 = proto.readBuffer(p153, n102)
				v2010.cta_text = buffer.tostring(v2020)
			elseif v2012 == 7 then
				local v2021

				v2021, n102 = proto.readBuffer(p153, n102)
				v2010.prompt_id = buffer.tostring(v2021)
			elseif v2012 == 8 then
				local v2022

				v2022, n102 = proto.readBuffer(p153, n102)
				v2010.prompt_type = buffer.tostring(v2022)
			elseif v2012 == 9 then
				local v2023

				v2023, n102 = proto.readBuffer(p153, n102)
				v2010.entity_id = buffer.tostring(v2023)
			else
				local v2024, v2025 = proto.readVarInt(p153, n102)

				n102 = v2025 + v2024
			end
		elseif v2013 == proto.wireTypes.i32 then
			local v2026

			v2026, n102 = proto.readFixed32(p153, n102)
		elseif v2013 == proto.wireTypes.i64 then
			local v2027

			v2027, n102 = proto.readFixed64(p153, n102)
		else
			error("Unsupported wire type: " .. v2013)
		end
	end

	return v2010
end
function t248.jsonEncode(p154) -- line: 13183
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
function t248.jsonDecode(t251: {[any]: any}) -- line: 13225
	-- upvalues: t248 (copy)
	local v2031 = t248.new()

	if t251.roblox_component ~= nil then
		v2031.roblox_component = t251.roblox_component
	end

	if t251.robloxComponent ~= nil then
		v2031.roblox_component = t251.robloxComponent
	end

	if t251.identifier ~= nil then
		v2031.identifier = t251.identifier
	end

	if t251.title ~= nil then
		v2031.title = t251.title
	end

	if t251.user_id ~= nil then
		v2031.user_id = t251.user_id
	end

	if t251.userId ~= nil then
		v2031.user_id = t251.userId
	end

	if t251.description ~= nil then
		v2031.description = t251.description
	end

	if t251.cta_text ~= nil then
		v2031.cta_text = t251.cta_text
	end

	if t251.ctaText ~= nil then
		v2031.cta_text = t251.ctaText
	end

	if t251.prompt_id ~= nil then
		v2031.prompt_id = t251.prompt_id
	end

	if t251.promptId ~= nil then
		v2031.prompt_id = t251.promptId
	end

	if t251.prompt_type ~= nil then
		v2031.prompt_type = t251.prompt_type
	end

	if t251.promptType ~= nil then
		v2031.prompt_type = t251.promptType
	end

	if t251.entity_id ~= nil then
		v2031.entity_id = t251.entity_id
	end

	if t251.entityId ~= nil then
		v2031.entity_id = t251.entityId
	end

	return v2031
end

t248.descriptor = {
	name = "CardContainerCardInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CardContainerCardInputData"
}
t1.CardContainerCardInputData = t248
typeRegistry.default:register(t1.CardContainerCardInputData)

local t252 = {}

t252.__index = t252

function t252.new(t253: {[any]: any}?) -- line: 13305
	-- upvalues: t252 (copy)
	return (setmetatable({
		group_id = if t253 ~= nil and t253.group_id ~= nil then t253.group_id else "",
		experience_id = if t253 ~= nil and t253.experience_id ~= nil then t253.experience_id else ""
	}, t252))
end
function t252.encode(p155) -- line: 13314
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n103 = 0

	if p155.group_id ~= nil and p155.group_id ~= "" then
		local v2036, v2037 = proto.writeTag(buf, n103, 1, proto.wireTypes.lengthDelimited)

		buf, n103 = proto.writeString(v2036, v2037, p155.group_id)
	end

	if p155.experience_id ~= nil and p155.experience_id ~= "" then
		local v2038, v2039 = proto.writeTag(buf, n103, 2, proto.wireTypes.lengthDelimited)

		buf, n103 = proto.writeString(v2038, v2039, p155.experience_id)
	end

	local buf56 = buffer.create(n103)

	buffer.copy(buf56, 0, buf, 0, n103)

	return buf56
end
function t252.decode(p156: buffer) -- line: 13333
	-- upvalues: t252 (copy), proto (copy)
	local v2042 = t252.new()
	local n104 = 0

	while n104 < buffer.len(p156) do
		local v2044, v2045

		v2044, v2045, n104 = proto.readTag(p156, n104)

		if v2045 == proto.wireTypes.varint then
			local v2046

			v2046, n104 = proto.readVarInt(p156, n104)
		elseif v2045 == proto.wireTypes.lengthDelimited then
			if v2044 == 1 then
				local v2047

				v2047, n104 = proto.readBuffer(p156, n104)
				v2042.group_id = buffer.tostring(v2047)
			elseif v2044 == 2 then
				local v2048

				v2048, n104 = proto.readBuffer(p156, n104)
				v2042.experience_id = buffer.tostring(v2048)
			else
				local v2049, v2050 = proto.readVarInt(p156, n104)

				n104 = v2050 + v2049
			end
		elseif v2045 == proto.wireTypes.i32 then
			local v2051

			v2051, n104 = proto.readFixed32(p156, n104)
		elseif v2045 == proto.wireTypes.i64 then
			local v2052

			v2052, n104 = proto.readFixed64(p156, n104)
		else
			error("Unsupported wire type: " .. v2045)
		end
	end

	return v2042
end
function t252.jsonEncode(p157) -- line: 13381
	local t254 = {}

	if p157.group_id ~= nil and p157.group_id ~= "" then
		t254.groupId = p157.group_id
	end

	if p157.experience_id ~= nil and p157.experience_id ~= "" then
		t254.experienceId = p157.experience_id
	end

	return t254
end
function t252.jsonDecode(t255: {[any]: any}) -- line: 13395
	-- upvalues: t252 (copy)
	local v2056 = t252.new()

	if t255.group_id ~= nil then
		v2056.group_id = t255.group_id
	end

	if t255.groupId ~= nil then
		v2056.group_id = t255.groupId
	end

	if t255.experience_id ~= nil then
		v2056.experience_id = t255.experience_id
	end

	if t255.experienceId ~= nil then
		v2056.experience_id = t255.experienceId
	end

	return v2056
end

t252.descriptor = {
	name = "CommunitiesCardClientAttributes",
	fullName = "roblox.apppageplatform.shared.v1beta1.CommunitiesCardClientAttributes"
}
t1.CommunitiesCardClientAttributes = t252
typeRegistry.default:register(t1.CommunitiesCardClientAttributes)

local t256 = {}

t256.__index = t256

function t256.new(t257: {[any]: any}?) -- line: 13431
	-- upvalues: t256 (copy)
	return (setmetatable({
		title = if t257 ~= nil and t257.title ~= nil then t257.title else "",
		dismiss_text = if t257 ~= nil and t257.dismiss_text ~= nil then t257.dismiss_text else "",
		user_id = if t257 ~= nil and t257.user_id ~= nil then t257.user_id else "",
		cards = if t257 ~= nil and t257.cards ~= nil then t257.cards else {},
		prompt_id = if t257 ~= nil and t257.prompt_id ~= nil then t257.prompt_id else "",
		prompt_type = if t257 ~= nil and t257.prompt_type ~= nil then t257.prompt_type else "",
		sort_id = if t257 ~= nil and t257.sort_id ~= nil then t257.sort_id else "",
		feed_item_key = if t257 ~= nil and t257.feed_item_key ~= nil then t257.feed_item_key else "",
		client_attributes = if t257 ~= nil and t257.client_attributes ~= nil then t257.client_attributes else nil
	}, t256))
end
function t256.encode(p158) -- line: 13445
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n105 = 0

	if p158.title ~= nil and p158.title ~= "" then
		local v2061, v2062 = proto.writeTag(buf, n105, 1, proto.wireTypes.lengthDelimited)

		buf, n105 = proto.writeString(v2061, v2062, p158.title)
	end

	if p158.dismiss_text ~= nil and p158.dismiss_text ~= "" then
		local v2063, v2064 = proto.writeTag(buf, n105, 2, proto.wireTypes.lengthDelimited)

		buf, n105 = proto.writeString(v2063, v2064, p158.dismiss_text)
	end

	if p158.user_id ~= nil and p158.user_id ~= "" then
		local v2065, v2066 = proto.writeTag(buf, n105, 3, proto.wireTypes.lengthDelimited)

		buf, n105 = proto.writeString(v2065, v2066, p158.user_id)
	end

	if p158.cards ~= nil and #p158.cards > 0 then
		for _, v2068 in p158.cards do
			local v2069 = v2068:encode()
			local v2070, v2071 = proto.writeTag(buf, n105, 4, proto.wireTypes.lengthDelimited)

			buf, n105 = proto.writeBuffer(v2070, v2071, v2069, buffer.len(v2069))
		end
	end

	if p158.prompt_id ~= nil and p158.prompt_id ~= "" then
		local v2072, v2073 = proto.writeTag(buf, n105, 5, proto.wireTypes.lengthDelimited)

		buf, n105 = proto.writeString(v2072, v2073, p158.prompt_id)
	end

	if p158.prompt_type ~= nil and p158.prompt_type ~= "" then
		local v2074, v2075 = proto.writeTag(buf, n105, 6, proto.wireTypes.lengthDelimited)

		buf, n105 = proto.writeString(v2074, v2075, p158.prompt_type)
	end

	if p158.sort_id ~= nil and p158.sort_id ~= "" then
		local v2076, v2077 = proto.writeTag(buf, n105, 7, proto.wireTypes.lengthDelimited)

		buf, n105 = proto.writeString(v2076, v2077, p158.sort_id)
	end

	if p158.feed_item_key ~= nil and p158.feed_item_key ~= "" then
		local v2078, v2079 = proto.writeTag(buf, n105, 8, proto.wireTypes.lengthDelimited)

		buf, n105 = proto.writeString(v2078, v2079, p158.feed_item_key)
	end

	if p158.client_attributes ~= nil and p158.client_attributes.type == "communities_client_attributes" then
		local v2080 = p158.client_attributes.value:encode()
		local v2081, v2082 = proto.writeTag(buf, n105, 9, proto.wireTypes.lengthDelimited)

		buf, n105 = proto.writeBuffer(v2081, v2082, v2080, buffer.len(v2080))
	end

	local buf57 = buffer.create(n105)

	buffer.copy(buf57, 0, buf, 0, n105)

	return buf57
end
function t256.decode(p159: buffer) -- line: 13505
	-- upvalues: t256 (copy), proto (copy), t1 (copy)
	local v2085 = t256.new()
	local n106 = 0

	while n106 < buffer.len(p159) do
		local v2087, v2088

		v2087, v2088, n106 = proto.readTag(p159, n106)

		if v2088 == proto.wireTypes.varint then
			local v2089

			v2089, n106 = proto.readVarInt(p159, n106)
		elseif v2088 == proto.wireTypes.lengthDelimited then
			if v2087 == 1 then
				local v2090

				v2090, n106 = proto.readBuffer(p159, n106)
				v2085.title = buffer.tostring(v2090)
			elseif v2087 == 2 then
				local v2091

				v2091, n106 = proto.readBuffer(p159, n106)
				v2085.dismiss_text = buffer.tostring(v2091)
			elseif v2087 == 3 then
				local v2092

				v2092, n106 = proto.readBuffer(p159, n106)
				v2085.user_id = buffer.tostring(v2092)
			elseif v2087 == 4 then
				local v2093

				v2093, n106 = proto.readBuffer(p159, n106)
				table.insert(v2085.cards, t1.CardContainerCardInputData.decode(v2093))
			elseif v2087 == 5 then
				local v2094

				v2094, n106 = proto.readBuffer(p159, n106)
				v2085.prompt_id = buffer.tostring(v2094)
			elseif v2087 == 6 then
				local v2095

				v2095, n106 = proto.readBuffer(p159, n106)
				v2085.prompt_type = buffer.tostring(v2095)
			elseif v2087 == 7 then
				local v2096

				v2096, n106 = proto.readBuffer(p159, n106)
				v2085.sort_id = buffer.tostring(v2096)
			elseif v2087 == 8 then
				local v2097

				v2097, n106 = proto.readBuffer(p159, n106)
				v2085.feed_item_key = buffer.tostring(v2097)
			elseif v2087 == 9 then
				local v2098

				v2098, n106 = proto.readBuffer(p159, n106)
				v2085.client_attributes = {
					type = "communities_client_attributes",
					value = t1.CommunitiesCardClientAttributes.decode(v2098)
				}
			else
				local v2099, v2100 = proto.readVarInt(p159, n106)

				n106 = v2100 + v2099
			end
		elseif v2088 == proto.wireTypes.i32 then
			local v2101

			v2101, n106 = proto.readFixed32(p159, n106)
		elseif v2088 == proto.wireTypes.i64 then
			local v2102

			v2102, n106 = proto.readFixed64(p159, n106)
		else
			error("Unsupported wire type: " .. v2088)
		end
	end

	return v2085
end
function t256.jsonEncode(p160) -- line: 13591
	local t258 = {}

	if p160.title ~= nil and p160.title ~= "" then
		t258.title = p160.title
	end

	if p160.dismiss_text ~= nil and p160.dismiss_text ~= "" then
		t258.dismissText = p160.dismiss_text
	end

	if p160.user_id ~= nil and p160.user_id ~= "" then
		t258.userId = p160.user_id
	end

	if p160.cards ~= nil and #p160.cards > 0 then
		local t259 = {}

		for _, v2107 in p160.cards do
			table.insert(t259, v2107:jsonEncode())
		end

		t258.cards = t259
	end

	if p160.prompt_id ~= nil and p160.prompt_id ~= "" then
		t258.promptId = p160.prompt_id
	end

	if p160.prompt_type ~= nil and p160.prompt_type ~= "" then
		t258.promptType = p160.prompt_type
	end

	if p160.sort_id ~= nil and p160.sort_id ~= "" then
		t258.sortId = p160.sort_id
	end

	if p160.feed_item_key ~= nil and p160.feed_item_key ~= "" then
		t258.feedItemKey = p160.feed_item_key
	end

	if p160.client_attributes ~= nil and p160.client_attributes.type == "communities_client_attributes" then
		t258.communitiesClientAttributes = p160.client_attributes.value:jsonEncode()
	end

	return t258
end
function t256.jsonDecode(t260: {[any]: any}) -- line: 13639
	-- upvalues: t256 (copy), t1 (copy)
	local v2109 = t256.new()

	if t260.title ~= nil then
		v2109.title = t260.title
	end

	if t260.dismiss_text ~= nil then
		v2109.dismiss_text = t260.dismiss_text
	end

	if t260.dismissText ~= nil then
		v2109.dismiss_text = t260.dismissText
	end

	if t260.user_id ~= nil then
		v2109.user_id = t260.user_id
	end

	if t260.userId ~= nil then
		v2109.user_id = t260.userId
	end

	if t260.cards ~= nil then
		local t261 = {}

		for _, v2112 in t260.cards do
			table.insert(t261, t1.CardContainerCardInputData.jsonDecode(v2112))
		end

		v2109.cards = t261
	end

	if t260.prompt_id ~= nil then
		v2109.prompt_id = t260.prompt_id
	end

	if t260.promptId ~= nil then
		v2109.prompt_id = t260.promptId
	end

	if t260.prompt_type ~= nil then
		v2109.prompt_type = t260.prompt_type
	end

	if t260.promptType ~= nil then
		v2109.prompt_type = t260.promptType
	end

	if t260.sort_id ~= nil then
		v2109.sort_id = t260.sort_id
	end

	if t260.sortId ~= nil then
		v2109.sort_id = t260.sortId
	end

	if t260.feed_item_key ~= nil then
		v2109.feed_item_key = t260.feed_item_key
	end

	if t260.feedItemKey ~= nil then
		v2109.feed_item_key = t260.feedItemKey
	end

	if t260.communities_client_attributes ~= nil then
		v2109.client_attributes = {
			type = "communities_client_attributes",
			value = t1.CommunitiesCardClientAttributes.jsonDecode(t260.communities_client_attributes)
		}
	end

	if t260.communitiesClientAttributes ~= nil then
		v2109.client_attributes = {
			type = "communities_client_attributes",
			value = t1.CommunitiesCardClientAttributes.jsonDecode(t260.communitiesClientAttributes)
		}
	end

	return v2109
end

t256.descriptor = {
	name = "CardContainerInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CardContainerInputData"
}
t1.CardContainerInputData = t256
typeRegistry.default:register(t1.CardContainerInputData)

local t262 = {}

t262.__index = t262

function t262.new(t263: {[any]: any}?) -- line: 13734
	-- upvalues: t262 (copy)
	return (setmetatable({
		title = if t263 ~= nil and t263.title ~= nil then t263.title else "",
		user_id = if t263 ~= nil and t263.user_id ~= nil then t263.user_id else "",
		description = if t263 ~= nil and t263.description ~= nil then t263.description else "",
		cta_text = if t263 ~= nil and t263.cta_text ~= nil then t263.cta_text else "",
		prompt_id = if t263 ~= nil and t263.prompt_id ~= nil then t263.prompt_id else "",
		prompt_type = if t263 ~= nil and t263.prompt_type ~= nil then t263.prompt_type else "",
		entity_id = if t263 ~= nil and t263.entity_id ~= nil then t263.entity_id else ""
	}, t262))
end
function t262.encode(p161) -- line: 13746
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n107 = 0

	if p161.title ~= nil and p161.title ~= "" then
		local v2117, v2118 = proto.writeTag(buf, n107, 1, proto.wireTypes.lengthDelimited)

		buf, n107 = proto.writeString(v2117, v2118, p161.title)
	end

	if p161.user_id ~= nil and p161.user_id ~= "" then
		local v2119, v2120 = proto.writeTag(buf, n107, 2, proto.wireTypes.lengthDelimited)

		buf, n107 = proto.writeString(v2119, v2120, p161.user_id)
	end

	if p161.description ~= nil and p161.description ~= "" then
		local v2121, v2122 = proto.writeTag(buf, n107, 3, proto.wireTypes.lengthDelimited)

		buf, n107 = proto.writeString(v2121, v2122, p161.description)
	end

	if p161.cta_text ~= nil and p161.cta_text ~= "" then
		local v2123, v2124 = proto.writeTag(buf, n107, 4, proto.wireTypes.lengthDelimited)

		buf, n107 = proto.writeString(v2123, v2124, p161.cta_text)
	end

	if p161.prompt_id ~= nil and p161.prompt_id ~= "" then
		local v2125, v2126 = proto.writeTag(buf, n107, 5, proto.wireTypes.lengthDelimited)

		buf, n107 = proto.writeString(v2125, v2126, p161.prompt_id)
	end

	if p161.prompt_type ~= nil and p161.prompt_type ~= "" then
		local v2127, v2128 = proto.writeTag(buf, n107, 6, proto.wireTypes.lengthDelimited)

		buf, n107 = proto.writeString(v2127, v2128, p161.prompt_type)
	end

	if p161.entity_id ~= nil and p161.entity_id ~= "" then
		local v2129, v2130 = proto.writeTag(buf, n107, 7, proto.wireTypes.lengthDelimited)

		buf, n107 = proto.writeString(v2129, v2130, p161.entity_id)
	end

	local buf58 = buffer.create(n107)

	buffer.copy(buf58, 0, buf, 0, n107)

	return buf58
end
function t262.decode(p162: buffer) -- line: 13790
	-- upvalues: t262 (copy), proto (copy)
	local v2133 = t262.new()
	local n108 = 0

	while n108 < buffer.len(p162) do
		local v2135, v2136

		v2135, v2136, n108 = proto.readTag(p162, n108)

		if v2136 == proto.wireTypes.varint then
			local v2137

			v2137, n108 = proto.readVarInt(p162, n108)
		elseif v2136 == proto.wireTypes.lengthDelimited then
			if v2135 == 1 then
				local v2138

				v2138, n108 = proto.readBuffer(p162, n108)
				v2133.title = buffer.tostring(v2138)
			elseif v2135 == 2 then
				local v2139

				v2139, n108 = proto.readBuffer(p162, n108)
				v2133.user_id = buffer.tostring(v2139)
			elseif v2135 == 3 then
				local v2140

				v2140, n108 = proto.readBuffer(p162, n108)
				v2133.description = buffer.tostring(v2140)
			elseif v2135 == 4 then
				local v2141

				v2141, n108 = proto.readBuffer(p162, n108)
				v2133.cta_text = buffer.tostring(v2141)
			elseif v2135 == 5 then
				local v2142

				v2142, n108 = proto.readBuffer(p162, n108)
				v2133.prompt_id = buffer.tostring(v2142)
			elseif v2135 == 6 then
				local v2143

				v2143, n108 = proto.readBuffer(p162, n108)
				v2133.prompt_type = buffer.tostring(v2143)
			elseif v2135 == 7 then
				local v2144

				v2144, n108 = proto.readBuffer(p162, n108)
				v2133.entity_id = buffer.tostring(v2144)
			else
				local v2145, v2146 = proto.readVarInt(p162, n108)

				n108 = v2146 + v2145
			end
		elseif v2136 == proto.wireTypes.i32 then
			local v2147

			v2147, n108 = proto.readFixed32(p162, n108)
		elseif v2136 == proto.wireTypes.i64 then
			local v2148

			v2148, n108 = proto.readFixed64(p162, n108)
		else
			error("Unsupported wire type: " .. v2136)
		end
	end

	return v2133
end
function t262.jsonEncode(p163) -- line: 13863
	local t264 = {}

	if p163.title ~= nil and p163.title ~= "" then
		t264.title = p163.title
	end

	if p163.user_id ~= nil and p163.user_id ~= "" then
		t264.userId = p163.user_id
	end

	if p163.description ~= nil and p163.description ~= "" then
		t264.description = p163.description
	end

	if p163.cta_text ~= nil and p163.cta_text ~= "" then
		t264.ctaText = p163.cta_text
	end

	if p163.prompt_id ~= nil and p163.prompt_id ~= "" then
		t264.promptId = p163.prompt_id
	end

	if p163.prompt_type ~= nil and p163.prompt_type ~= "" then
		t264.promptType = p163.prompt_type
	end

	if p163.entity_id ~= nil and p163.entity_id ~= "" then
		t264.entityId = p163.entity_id
	end

	return t264
end
function t262.jsonDecode(t265: {[any]: any}) -- line: 13897
	-- upvalues: t262 (copy)
	local v2152 = t262.new()

	if t265.title ~= nil then
		v2152.title = t265.title
	end

	if t265.user_id ~= nil then
		v2152.user_id = t265.user_id
	end

	if t265.userId ~= nil then
		v2152.user_id = t265.userId
	end

	if t265.description ~= nil then
		v2152.description = t265.description
	end

	if t265.cta_text ~= nil then
		v2152.cta_text = t265.cta_text
	end

	if t265.ctaText ~= nil then
		v2152.cta_text = t265.ctaText
	end

	if t265.prompt_id ~= nil then
		v2152.prompt_id = t265.prompt_id
	end

	if t265.promptId ~= nil then
		v2152.prompt_id = t265.promptId
	end

	if t265.prompt_type ~= nil then
		v2152.prompt_type = t265.prompt_type
	end

	if t265.promptType ~= nil then
		v2152.prompt_type = t265.promptType
	end

	if t265.entity_id ~= nil then
		v2152.entity_id = t265.entity_id
	end

	if t265.entityId ~= nil then
		v2152.entity_id = t265.entityId
	end

	return v2152
end

t262.descriptor = {
	name = "CardInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CardInputData"
}
t1.CardInputData = t262
typeRegistry.default:register(t1.CardInputData)

local t266 = {}

t266.__index = t266

function t266.new(t267: {[any]: any}?) -- line: 13965
	-- upvalues: t266 (copy)
	return (setmetatable({
		prompt_id = if t267 ~= nil and t267.prompt_id ~= nil then t267.prompt_id else "",
		prompt_type = if t267 ~= nil and t267.prompt_type ~= nil then t267.prompt_type else "",
		user_id = if t267 ~= nil and t267.user_id ~= nil then t267.user_id else "",
		audit_data = if t267 ~= nil and t267.audit_data ~= nil then t267.audit_data else ""
	}, t266))
end
function t266.encode(p164) -- line: 13974
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n109 = 0

	if p164.prompt_id ~= nil and p164.prompt_id ~= "" then
		local v2157, v2158 = proto.writeTag(buf, n109, 1, proto.wireTypes.lengthDelimited)

		buf, n109 = proto.writeString(v2157, v2158, p164.prompt_id)
	end

	if p164.prompt_type ~= nil and p164.prompt_type ~= "" then
		local v2159, v2160 = proto.writeTag(buf, n109, 2, proto.wireTypes.lengthDelimited)

		buf, n109 = proto.writeString(v2159, v2160, p164.prompt_type)
	end

	if p164.user_id ~= nil and p164.user_id ~= "" then
		local v2161, v2162 = proto.writeTag(buf, n109, 3, proto.wireTypes.lengthDelimited)

		buf, n109 = proto.writeString(v2161, v2162, p164.user_id)
	end

	if p164.audit_data ~= nil and p164.audit_data ~= "" then
		local v2163, v2164 = proto.writeTag(buf, n109, 4, proto.wireTypes.lengthDelimited)

		buf, n109 = proto.writeString(v2163, v2164, p164.audit_data)
	end

	local buf59 = buffer.create(n109)

	buffer.copy(buf59, 0, buf, 0, n109)

	return buf59
end
function t266.decode(p165: buffer) -- line: 14003
	-- upvalues: t266 (copy), proto (copy)
	local v2167 = t266.new()
	local n110 = 0

	while n110 < buffer.len(p165) do
		local v2169, v2170

		v2169, v2170, n110 = proto.readTag(p165, n110)

		if v2170 == proto.wireTypes.varint then
			local v2171

			v2171, n110 = proto.readVarInt(p165, n110)
		elseif v2170 == proto.wireTypes.lengthDelimited then
			if v2169 == 1 then
				local v2172

				v2172, n110 = proto.readBuffer(p165, n110)
				v2167.prompt_id = buffer.tostring(v2172)
			elseif v2169 == 2 then
				local v2173

				v2173, n110 = proto.readBuffer(p165, n110)
				v2167.prompt_type = buffer.tostring(v2173)
			elseif v2169 == 3 then
				local v2174

				v2174, n110 = proto.readBuffer(p165, n110)
				v2167.user_id = buffer.tostring(v2174)
			elseif v2169 == 4 then
				local v2175

				v2175, n110 = proto.readBuffer(p165, n110)
				v2167.audit_data = buffer.tostring(v2175)
			else
				local v2176, v2177 = proto.readVarInt(p165, n110)

				n110 = v2177 + v2176
			end
		elseif v2170 == proto.wireTypes.i32 then
			local v2178

			v2178, n110 = proto.readFixed32(p165, n110)
		elseif v2170 == proto.wireTypes.i64 then
			local v2179

			v2179, n110 = proto.readFixed64(p165, n110)
		else
			error("Unsupported wire type: " .. v2170)
		end
	end

	return v2167
end
function t266.jsonEncode(p166) -- line: 14061
	local t268 = {}

	if p166.prompt_id ~= nil and p166.prompt_id ~= "" then
		t268.promptId = p166.prompt_id
	end

	if p166.prompt_type ~= nil and p166.prompt_type ~= "" then
		t268.promptType = p166.prompt_type
	end

	if p166.user_id ~= nil and p166.user_id ~= "" then
		t268.userId = p166.user_id
	end

	if p166.audit_data ~= nil and p166.audit_data ~= "" then
		t268.auditData = p166.audit_data
	end

	return t268
end
function t266.jsonDecode(t269: {[any]: any}) -- line: 14083
	-- upvalues: t266 (copy)
	local v2183 = t266.new()

	if t269.prompt_id ~= nil then
		v2183.prompt_id = t269.prompt_id
	end

	if t269.promptId ~= nil then
		v2183.prompt_id = t269.promptId
	end

	if t269.prompt_type ~= nil then
		v2183.prompt_type = t269.prompt_type
	end

	if t269.promptType ~= nil then
		v2183.prompt_type = t269.promptType
	end

	if t269.user_id ~= nil then
		v2183.user_id = t269.user_id
	end

	if t269.userId ~= nil then
		v2183.user_id = t269.userId
	end

	if t269.audit_data ~= nil then
		v2183.audit_data = t269.audit_data
	end

	if t269.auditData ~= nil then
		v2183.audit_data = t269.auditData
	end

	return v2183
end

t266.descriptor = {
	name = "DialogInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.DialogInputData"
}
t1.DialogInputData = t266
typeRegistry.default:register(t1.DialogInputData)

local t270 = {}

t270.__index = t270

function t270.new(t271: {[any]: any}?) -- line: 14135
	-- upvalues: t270 (copy)
	return (setmetatable({
		sender_count = if t271 ~= nil and t271.sender_count ~= nil then t271.sender_count else 0,
		total_robux_amount = if t271 ~= nil and t271.total_robux_amount ~= nil then t271.total_robux_amount else 0
	}, t270))
end
function t270.encode(p167) -- line: 14142
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n111 = 0

	if p167.sender_count ~= nil and p167.sender_count ~= 0 then
		local v2188, v2189 = proto.writeTag(buf, n111, 1, proto.wireTypes.varint)

		buf, n111 = proto.writeVarInt(v2188, v2189, p167.sender_count)
	end

	if p167.total_robux_amount ~= nil and p167.total_robux_amount ~= 0 then
		local v2190, v2191 = proto.writeTag(buf, n111, 2, proto.wireTypes.varint)

		buf, n111 = proto.writeVarInt(v2190, v2191, p167.total_robux_amount)
	end

	local buf60 = buffer.create(n111)

	buffer.copy(buf60, 0, buf, 0, n111)

	return buf60
end
function t270.decode(p168: buffer) -- line: 14161
	-- upvalues: t270 (copy), proto (copy)
	local v2194 = t270.new()
	local n112 = 0

	while n112 < buffer.len(p168) do
		local v2196, v2197

		v2196, v2197, n112 = proto.readTag(p168, n112)

		if v2197 == proto.wireTypes.varint then
			if v2196 == 1 then
				local v2198

				v2198, n112 = proto.readVarIntI32(p168, n112)
				v2194.sender_count = v2198
			elseif v2196 == 2 then
				local v2199

				v2199, n112 = proto.readVarIntI64(p168, n112)
				v2194.total_robux_amount = v2199
			else
				local v2200

				v2200, n112 = proto.readVarInt(p168, n112)
			end
		elseif v2197 == proto.wireTypes.lengthDelimited then
			local v2201, v2202 = proto.readVarInt(p168, n112)

			n112 = v2202 + v2201
		elseif v2197 == proto.wireTypes.i32 then
			local v2203

			v2203, n112 = proto.readFixed32(p168, n112)
		elseif v2197 == proto.wireTypes.i64 then
			local v2204

			v2204, n112 = proto.readFixed64(p168, n112)
		else
			error("Unsupported wire type: " .. v2197)
		end
	end

	return v2194
end
function t270.jsonEncode(p169) -- line: 14209
	local t272 = {}

	if p169.sender_count ~= nil and p169.sender_count ~= 0 then
		t272.senderCount = p169.sender_count
	end

	if p169.total_robux_amount ~= nil and p169.total_robux_amount ~= 0 then
		t272.totalRobuxAmount = p169.total_robux_amount
	end

	return t272
end
function t270.jsonDecode(t273: {[any]: any}) -- line: 14223
	-- upvalues: t270 (copy)
	local v2208 = t270.new()

	if t273.sender_count ~= nil then
		v2208.sender_count = t273.sender_count
	end

	if t273.senderCount ~= nil then
		v2208.sender_count = t273.senderCount
	end

	if t273.total_robux_amount ~= nil then
		v2208.total_robux_amount = t273.total_robux_amount
	end

	if t273.totalRobuxAmount ~= nil then
		v2208.total_robux_amount = t273.totalRobuxAmount
	end

	return v2208
end

t270.descriptor = {
	name = "IncomingTransferContent",
	fullName = "roblox.apppageplatform.shared.v1beta1.IncomingTransferContent"
}
t1.IncomingTransferContent = t270
typeRegistry.default:register(t1.IncomingTransferContent)

local t274 = {}

t274.__index = t274

function t274.new(t275: {[any]: any}?) -- line: 14259
	-- upvalues: t274 (copy)
	return (setmetatable({
		title = if t275 ~= nil and t275.title ~= nil then t275.title else "",
		description = if t275 ~= nil and t275.description ~= nil then t275.description else "",
		primary_text = if t275 ~= nil and t275.primary_text ~= nil then t275.primary_text else "",
		secondary_text = if t275 ~= nil and t275.secondary_text ~= nil then t275.secondary_text else "",
		prompt_id = if t275 ~= nil and t275.prompt_id ~= nil then t275.prompt_id else "",
		prompt_type = if t275 ~= nil and t275.prompt_type ~= nil then t275.prompt_type else "",
		times_seen = if t275 ~= nil and t275.times_seen ~= nil then t275.times_seen else 0,
		content = if t275 ~= nil and t275.content ~= nil then t275.content else nil
	}, t274))
end
function t274.encode(p170) -- line: 14272
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n113 = 0

	if p170.title ~= nil and p170.title ~= "" then
		local v2213, v2214 = proto.writeTag(buf, n113, 1, proto.wireTypes.lengthDelimited)

		buf, n113 = proto.writeString(v2213, v2214, p170.title)
	end

	if p170.description ~= nil and p170.description ~= "" then
		local v2215, v2216 = proto.writeTag(buf, n113, 2, proto.wireTypes.lengthDelimited)

		buf, n113 = proto.writeString(v2215, v2216, p170.description)
	end

	if p170.primary_text ~= nil and p170.primary_text ~= "" then
		local v2217, v2218 = proto.writeTag(buf, n113, 3, proto.wireTypes.lengthDelimited)

		buf, n113 = proto.writeString(v2217, v2218, p170.primary_text)
	end

	if p170.secondary_text ~= nil and p170.secondary_text ~= "" then
		local v2219, v2220 = proto.writeTag(buf, n113, 4, proto.wireTypes.lengthDelimited)

		buf, n113 = proto.writeString(v2219, v2220, p170.secondary_text)
	end

	if p170.prompt_id ~= nil and p170.prompt_id ~= "" then
		local v2221, v2222 = proto.writeTag(buf, n113, 5, proto.wireTypes.lengthDelimited)

		buf, n113 = proto.writeString(v2221, v2222, p170.prompt_id)
	end

	if p170.prompt_type ~= nil and p170.prompt_type ~= "" then
		local v2223, v2224 = proto.writeTag(buf, n113, 6, proto.wireTypes.lengthDelimited)

		buf, n113 = proto.writeString(v2223, v2224, p170.prompt_type)
	end

	if p170.times_seen ~= nil and p170.times_seen ~= 0 then
		local v2225, v2226 = proto.writeTag(buf, n113, 7, proto.wireTypes.varint)

		buf, n113 = proto.writeVarInt(v2225, v2226, p170.times_seen)
	end

	if p170.content ~= nil and p170.content.type == "incoming_transfer_content" then
		local v2227 = p170.content.value:encode()
		local v2228, v2229 = proto.writeTag(buf, n113, 8, proto.wireTypes.lengthDelimited)

		buf, n113 = proto.writeBuffer(v2228, v2229, v2227, buffer.len(v2227))
	end

	local buf61 = buffer.create(n113)

	buffer.copy(buf61, 0, buf, 0, n113)

	return buf61
end
function t274.decode(p171: buffer) -- line: 14324
	-- upvalues: t274 (copy), proto (copy), t1 (copy)
	local v2232 = t274.new()
	local n114 = 0

	while n114 < buffer.len(p171) do
		local v2234, v2235

		v2234, v2235, n114 = proto.readTag(p171, n114)

		if v2235 == proto.wireTypes.varint then
			if v2234 == 7 then
				local v2236

				v2236, n114 = proto.readVarIntI32(p171, n114)
				v2232.times_seen = v2236
			else
				local v2237

				v2237, n114 = proto.readVarInt(p171, n114)
			end
		elseif v2235 == proto.wireTypes.lengthDelimited then
			if v2234 == 1 then
				local v2238

				v2238, n114 = proto.readBuffer(p171, n114)
				v2232.title = buffer.tostring(v2238)
			elseif v2234 == 2 then
				local v2239

				v2239, n114 = proto.readBuffer(p171, n114)
				v2232.description = buffer.tostring(v2239)
			elseif v2234 == 3 then
				local v2240

				v2240, n114 = proto.readBuffer(p171, n114)
				v2232.primary_text = buffer.tostring(v2240)
			elseif v2234 == 4 then
				local v2241

				v2241, n114 = proto.readBuffer(p171, n114)
				v2232.secondary_text = buffer.tostring(v2241)
			elseif v2234 == 5 then
				local v2242

				v2242, n114 = proto.readBuffer(p171, n114)
				v2232.prompt_id = buffer.tostring(v2242)
			elseif v2234 == 6 then
				local v2243

				v2243, n114 = proto.readBuffer(p171, n114)
				v2232.prompt_type = buffer.tostring(v2243)
			elseif v2234 == 8 then
				local v2244

				v2244, n114 = proto.readBuffer(p171, n114)
				v2232.content = {
					type = "incoming_transfer_content",
					value = t1.IncomingTransferContent.decode(v2244)
				}
			else
				local v2245, v2246 = proto.readVarInt(p171, n114)

				n114 = v2246 + v2245
			end
		elseif v2235 == proto.wireTypes.i32 then
			local v2247

			v2247, n114 = proto.readFixed32(p171, n114)
		elseif v2235 == proto.wireTypes.i64 then
			local v2248

			v2248, n114 = proto.readFixed64(p171, n114)
		else
			error("Unsupported wire type: " .. v2235)
		end
	end

	return v2232
end
function t274.jsonEncode(p172) -- line: 14403
	local t276 = {}

	if p172.title ~= nil and p172.title ~= "" then
		t276.title = p172.title
	end

	if p172.description ~= nil and p172.description ~= "" then
		t276.description = p172.description
	end

	if p172.primary_text ~= nil and p172.primary_text ~= "" then
		t276.primaryText = p172.primary_text
	end

	if p172.secondary_text ~= nil and p172.secondary_text ~= "" then
		t276.secondaryText = p172.secondary_text
	end

	if p172.prompt_id ~= nil and p172.prompt_id ~= "" then
		t276.promptId = p172.prompt_id
	end

	if p172.prompt_type ~= nil and p172.prompt_type ~= "" then
		t276.promptType = p172.prompt_type
	end

	if p172.times_seen ~= nil and p172.times_seen ~= 0 then
		t276.timesSeen = p172.times_seen
	end

	if p172.content ~= nil and p172.content.type == "incoming_transfer_content" then
		t276.incomingTransferContent = p172.content.value:jsonEncode()
	end

	return t276
end
function t274.jsonDecode(t277: {[any]: any}) -- line: 14443
	-- upvalues: t274 (copy), t1 (copy)
	local v2252 = t274.new()

	if t277.title ~= nil then
		v2252.title = t277.title
	end

	if t277.description ~= nil then
		v2252.description = t277.description
	end

	if t277.primary_text ~= nil then
		v2252.primary_text = t277.primary_text
	end

	if t277.primaryText ~= nil then
		v2252.primary_text = t277.primaryText
	end

	if t277.secondary_text ~= nil then
		v2252.secondary_text = t277.secondary_text
	end

	if t277.secondaryText ~= nil then
		v2252.secondary_text = t277.secondaryText
	end

	if t277.prompt_id ~= nil then
		v2252.prompt_id = t277.prompt_id
	end

	if t277.promptId ~= nil then
		v2252.prompt_id = t277.promptId
	end

	if t277.prompt_type ~= nil then
		v2252.prompt_type = t277.prompt_type
	end

	if t277.promptType ~= nil then
		v2252.prompt_type = t277.promptType
	end

	if t277.times_seen ~= nil then
		v2252.times_seen = t277.times_seen
	end

	if t277.timesSeen ~= nil then
		v2252.times_seen = t277.timesSeen
	end

	if t277.incoming_transfer_content ~= nil then
		v2252.content = {
			type = "incoming_transfer_content",
			value = t1.IncomingTransferContent.jsonDecode(t277.incoming_transfer_content)
		}
	end

	if t277.incomingTransferContent ~= nil then
		v2252.content = {
			type = "incoming_transfer_content",
			value = t1.IncomingTransferContent.jsonDecode(t277.incomingTransferContent)
		}
	end

	return v2252
end

t274.descriptor = {
	name = "BannerInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.BannerInputData"
}
t1.BannerInputData = t274
typeRegistry.default:register(t1.BannerInputData)

local t278 = {}

t278.__index = t278

function t278.new(t279: {[any]: any}?) -- line: 14525
	-- upvalues: t278 (copy)
	return (setmetatable({
		tooltip_text = if t279 ~= nil and t279.tooltip_text ~= nil then t279.tooltip_text else "",
		prompt_id = if t279 ~= nil and t279.prompt_id ~= nil then t279.prompt_id else "",
		prompt_type = if t279 ~= nil and t279.prompt_type ~= nil then t279.prompt_type else ""
	}, t278))
end
function t278.encode(p173) -- line: 14533
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n115 = 0

	if p173.tooltip_text ~= nil and p173.tooltip_text ~= "" then
		local v2257, v2258 = proto.writeTag(buf, n115, 1, proto.wireTypes.lengthDelimited)

		buf, n115 = proto.writeString(v2257, v2258, p173.tooltip_text)
	end

	if p173.prompt_id ~= nil and p173.prompt_id ~= "" then
		local v2259, v2260 = proto.writeTag(buf, n115, 2, proto.wireTypes.lengthDelimited)

		buf, n115 = proto.writeString(v2259, v2260, p173.prompt_id)
	end

	if p173.prompt_type ~= nil and p173.prompt_type ~= "" then
		local v2261, v2262 = proto.writeTag(buf, n115, 3, proto.wireTypes.lengthDelimited)

		buf, n115 = proto.writeString(v2261, v2262, p173.prompt_type)
	end

	local buf62 = buffer.create(n115)

	buffer.copy(buf62, 0, buf, 0, n115)

	return buf62
end
function t278.decode(p174: buffer) -- line: 14557
	-- upvalues: t278 (copy), proto (copy)
	local v2265 = t278.new()
	local n116 = 0

	while n116 < buffer.len(p174) do
		local v2267, v2268

		v2267, v2268, n116 = proto.readTag(p174, n116)

		if v2268 == proto.wireTypes.varint then
			local v2269

			v2269, n116 = proto.readVarInt(p174, n116)
		elseif v2268 == proto.wireTypes.lengthDelimited then
			if v2267 == 1 then
				local v2270

				v2270, n116 = proto.readBuffer(p174, n116)
				v2265.tooltip_text = buffer.tostring(v2270)
			elseif v2267 == 2 then
				local v2271

				v2271, n116 = proto.readBuffer(p174, n116)
				v2265.prompt_id = buffer.tostring(v2271)
			elseif v2267 == 3 then
				local v2272

				v2272, n116 = proto.readBuffer(p174, n116)
				v2265.prompt_type = buffer.tostring(v2272)
			else
				local v2273, v2274 = proto.readVarInt(p174, n116)

				n116 = v2274 + v2273
			end
		elseif v2268 == proto.wireTypes.i32 then
			local v2275

			v2275, n116 = proto.readFixed32(p174, n116)
		elseif v2268 == proto.wireTypes.i64 then
			local v2276

			v2276, n116 = proto.readFixed64(p174, n116)
		else
			error("Unsupported wire type: " .. v2268)
		end
	end

	return v2265
end
function t278.jsonEncode(p175) -- line: 14610
	local t280 = {}

	if p175.tooltip_text ~= nil and p175.tooltip_text ~= "" then
		t280.tooltipText = p175.tooltip_text
	end

	if p175.prompt_id ~= nil and p175.prompt_id ~= "" then
		t280.promptId = p175.prompt_id
	end

	if p175.prompt_type ~= nil and p175.prompt_type ~= "" then
		t280.promptType = p175.prompt_type
	end

	return t280
end
function t278.jsonDecode(t281: {[any]: any}) -- line: 14628
	-- upvalues: t278 (copy)
	local v2280 = t278.new()

	if t281.tooltip_text ~= nil then
		v2280.tooltip_text = t281.tooltip_text
	end

	if t281.tooltipText ~= nil then
		v2280.tooltip_text = t281.tooltipText
	end

	if t281.prompt_id ~= nil then
		v2280.prompt_id = t281.prompt_id
	end

	if t281.promptId ~= nil then
		v2280.prompt_id = t281.promptId
	end

	if t281.prompt_type ~= nil then
		v2280.prompt_type = t281.prompt_type
	end

	if t281.promptType ~= nil then
		v2280.prompt_type = t281.promptType
	end

	return v2280
end

t278.descriptor = {
	name = "TooltipInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.TooltipInputData"
}
t1.TooltipInputData = t278
typeRegistry.default:register(t1.TooltipInputData)

local t282 = {}

t282.__index = t282

function t282.new(t283: {[any]: any}?) -- line: 14672
	-- upvalues: t282 (copy)
	return (setmetatable({
		media_id = if t283 ~= nil and t283.media_id ~= nil then t283.media_id else "",
		title = if t283 ~= nil and t283.title ~= nil then t283.title else "",
		description = if t283 ~= nil and t283.description ~= nil then t283.description else "",
		prompt_id = if t283 ~= nil and t283.prompt_id ~= nil then t283.prompt_id else "",
		prompt_type = if t283 ~= nil and t283.prompt_type ~= nil then t283.prompt_type else "",
		anchor_tag = if t283 ~= nil and t283.anchor_tag ~= nil then t283.anchor_tag else ""
	}, t282))
end
function t282.encode(p176) -- line: 14683
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n117 = 0

	if p176.media_id ~= nil and p176.media_id ~= "" then
		local v2285, v2286 = proto.writeTag(buf, n117, 1, proto.wireTypes.lengthDelimited)

		buf, n117 = proto.writeString(v2285, v2286, p176.media_id)
	end

	if p176.title ~= nil and p176.title ~= "" then
		local v2287, v2288 = proto.writeTag(buf, n117, 2, proto.wireTypes.lengthDelimited)

		buf, n117 = proto.writeString(v2287, v2288, p176.title)
	end

	if p176.description ~= nil and p176.description ~= "" then
		local v2289, v2290 = proto.writeTag(buf, n117, 3, proto.wireTypes.lengthDelimited)

		buf, n117 = proto.writeString(v2289, v2290, p176.description)
	end

	if p176.prompt_id ~= nil and p176.prompt_id ~= "" then
		local v2291, v2292 = proto.writeTag(buf, n117, 4, proto.wireTypes.lengthDelimited)

		buf, n117 = proto.writeString(v2291, v2292, p176.prompt_id)
	end

	if p176.prompt_type ~= nil and p176.prompt_type ~= "" then
		local v2293, v2294 = proto.writeTag(buf, n117, 5, proto.wireTypes.lengthDelimited)

		buf, n117 = proto.writeString(v2293, v2294, p176.prompt_type)
	end

	if p176.anchor_tag ~= nil and p176.anchor_tag ~= "" then
		local v2295, v2296 = proto.writeTag(buf, n117, 6, proto.wireTypes.lengthDelimited)

		buf, n117 = proto.writeString(v2295, v2296, p176.anchor_tag)
	end

	local buf63 = buffer.create(n117)

	buffer.copy(buf63, 0, buf, 0, n117)

	return buf63
end
function t282.decode(p177: buffer) -- line: 14722
	-- upvalues: t282 (copy), proto (copy)
	local v2299 = t282.new()
	local n118 = 0

	while n118 < buffer.len(p177) do
		local v2301, v2302

		v2301, v2302, n118 = proto.readTag(p177, n118)

		if v2302 == proto.wireTypes.varint then
			local v2303

			v2303, n118 = proto.readVarInt(p177, n118)
		elseif v2302 == proto.wireTypes.lengthDelimited then
			if v2301 == 1 then
				local v2304

				v2304, n118 = proto.readBuffer(p177, n118)
				v2299.media_id = buffer.tostring(v2304)
			elseif v2301 == 2 then
				local v2305

				v2305, n118 = proto.readBuffer(p177, n118)
				v2299.title = buffer.tostring(v2305)
			elseif v2301 == 3 then
				local v2306

				v2306, n118 = proto.readBuffer(p177, n118)
				v2299.description = buffer.tostring(v2306)
			elseif v2301 == 4 then
				local v2307

				v2307, n118 = proto.readBuffer(p177, n118)
				v2299.prompt_id = buffer.tostring(v2307)
			elseif v2301 == 5 then
				local v2308

				v2308, n118 = proto.readBuffer(p177, n118)
				v2299.prompt_type = buffer.tostring(v2308)
			elseif v2301 == 6 then
				local v2309

				v2309, n118 = proto.readBuffer(p177, n118)
				v2299.anchor_tag = buffer.tostring(v2309)
			else
				local v2310, v2311 = proto.readVarInt(p177, n118)

				n118 = v2311 + v2310
			end
		elseif v2302 == proto.wireTypes.i32 then
			local v2312

			v2312, n118 = proto.readFixed32(p177, n118)
		elseif v2302 == proto.wireTypes.i64 then
			local v2313

			v2313, n118 = proto.readFixed64(p177, n118)
		else
			error("Unsupported wire type: " .. v2302)
		end
	end

	return v2299
end
function t282.jsonEncode(p178) -- line: 14790
	local t284 = {}

	if p178.media_id ~= nil and p178.media_id ~= "" then
		t284.mediaId = p178.media_id
	end

	if p178.title ~= nil and p178.title ~= "" then
		t284.title = p178.title
	end

	if p178.description ~= nil and p178.description ~= "" then
		t284.description = p178.description
	end

	if p178.prompt_id ~= nil and p178.prompt_id ~= "" then
		t284.promptId = p178.prompt_id
	end

	if p178.prompt_type ~= nil and p178.prompt_type ~= "" then
		t284.promptType = p178.prompt_type
	end

	if p178.anchor_tag ~= nil and p178.anchor_tag ~= "" then
		t284.anchorTag = p178.anchor_tag
	end

	return t284
end
function t282.jsonDecode(t285: {[any]: any}) -- line: 14820
	-- upvalues: t282 (copy)
	local v2317 = t282.new()

	if t285.media_id ~= nil then
		v2317.media_id = t285.media_id
	end

	if t285.mediaId ~= nil then
		v2317.media_id = t285.mediaId
	end

	if t285.title ~= nil then
		v2317.title = t285.title
	end

	if t285.description ~= nil then
		v2317.description = t285.description
	end

	if t285.prompt_id ~= nil then
		v2317.prompt_id = t285.prompt_id
	end

	if t285.promptId ~= nil then
		v2317.prompt_id = t285.promptId
	end

	if t285.prompt_type ~= nil then
		v2317.prompt_type = t285.prompt_type
	end

	if t285.promptType ~= nil then
		v2317.prompt_type = t285.promptType
	end

	if t285.anchor_tag ~= nil then
		v2317.anchor_tag = t285.anchor_tag
	end

	if t285.anchorTag ~= nil then
		v2317.anchor_tag = t285.anchorTag
	end

	return v2317
end

t282.descriptor = {
	name = "CoachmarkInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CoachmarkInputData"
}
t1.CoachmarkInputData = t282
typeRegistry.default:register(t1.CoachmarkInputData)

local t286 = {}

t286.__index = t286

function t286.new(t287: {[any]: any}?) -- line: 14880
	-- upvalues: t286 (copy)
	return (setmetatable({
		prompt_id = if t287 ~= nil and t287.prompt_id ~= nil then t287.prompt_id else "",
		prompt_type = if t287 ~= nil and t287.prompt_type ~= nil then t287.prompt_type else ""
	}, t286))
end
function t286.encode(p179) -- line: 14887
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n119 = 0

	if p179.prompt_id ~= nil and p179.prompt_id ~= "" then
		local v2322, v2323 = proto.writeTag(buf, n119, 1, proto.wireTypes.lengthDelimited)

		buf, n119 = proto.writeString(v2322, v2323, p179.prompt_id)
	end

	if p179.prompt_type ~= nil and p179.prompt_type ~= "" then
		local v2324, v2325 = proto.writeTag(buf, n119, 2, proto.wireTypes.lengthDelimited)

		buf, n119 = proto.writeString(v2324, v2325, p179.prompt_type)
	end

	local buf64 = buffer.create(n119)

	buffer.copy(buf64, 0, buf, 0, n119)

	return buf64
end
function t286.decode(p180: buffer) -- line: 14906
	-- upvalues: t286 (copy), proto (copy)
	local v2328 = t286.new()
	local n120 = 0

	while n120 < buffer.len(p180) do
		local v2330, v2331

		v2330, v2331, n120 = proto.readTag(p180, n120)

		if v2331 == proto.wireTypes.varint then
			local v2332

			v2332, n120 = proto.readVarInt(p180, n120)
		elseif v2331 == proto.wireTypes.lengthDelimited then
			if v2330 == 1 then
				local v2333

				v2333, n120 = proto.readBuffer(p180, n120)
				v2328.prompt_id = buffer.tostring(v2333)
			elseif v2330 == 2 then
				local v2334

				v2334, n120 = proto.readBuffer(p180, n120)
				v2328.prompt_type = buffer.tostring(v2334)
			else
				local v2335, v2336 = proto.readVarInt(p180, n120)

				n120 = v2336 + v2335
			end
		elseif v2331 == proto.wireTypes.i32 then
			local v2337

			v2337, n120 = proto.readFixed32(p180, n120)
		elseif v2331 == proto.wireTypes.i64 then
			local v2338

			v2338, n120 = proto.readFixed64(p180, n120)
		else
			error("Unsupported wire type: " .. v2331)
		end
	end

	return v2328
end
function t286.jsonEncode(p181) -- line: 14954
	local t288 = {}

	if p181.prompt_id ~= nil and p181.prompt_id ~= "" then
		t288.promptId = p181.prompt_id
	end

	if p181.prompt_type ~= nil and p181.prompt_type ~= "" then
		t288.promptType = p181.prompt_type
	end

	return t288
end
function t286.jsonDecode(t289: {[any]: any}) -- line: 14968
	-- upvalues: t286 (copy)
	local v2342 = t286.new()

	if t289.prompt_id ~= nil then
		v2342.prompt_id = t289.prompt_id
	end

	if t289.promptId ~= nil then
		v2342.prompt_id = t289.promptId
	end

	if t289.prompt_type ~= nil then
		v2342.prompt_type = t289.prompt_type
	end

	if t289.promptType ~= nil then
		v2342.prompt_type = t289.promptType
	end

	return v2342
end

t286.descriptor = {
	name = "SystemBannerInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.SystemBannerInputData"
}
t1.SystemBannerInputData = t286
typeRegistry.default:register(t1.SystemBannerInputData)

local t290 = {}

t290.__index = t290

function t290.new(t291: {[any]: any}?) -- line: 15004
	-- upvalues: t290 (copy)
	return (setmetatable({
		upsell_prompt = if t291 ~= nil and t291.upsell_prompt ~= nil then t291.upsell_prompt else ""
	}, t290))
end
function t290.encode(p182) -- line: 15010
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n121 = 0

	if p182.upsell_prompt ~= nil and p182.upsell_prompt ~= "" then
		local v2347, v2348 = proto.writeTag(buf, n121, 1, proto.wireTypes.lengthDelimited)

		buf, n121 = proto.writeString(v2347, v2348, p182.upsell_prompt)
	end

	local buf65 = buffer.create(n121)

	buffer.copy(buf65, 0, buf, 0, n121)

	return buf65
end
function t290.decode(p183: buffer) -- line: 15024
	-- upvalues: t290 (copy), proto (copy)
	local v2351 = t290.new()
	local n122 = 0

	while n122 < buffer.len(p183) do
		local v2353, v2354

		v2353, v2354, n122 = proto.readTag(p183, n122)

		if v2354 == proto.wireTypes.varint then
			local v2355

			v2355, n122 = proto.readVarInt(p183, n122)
		elseif v2354 == proto.wireTypes.lengthDelimited then
			if v2353 == 1 then
				local v2356

				v2356, n122 = proto.readBuffer(p183, n122)
				v2351.upsell_prompt = buffer.tostring(v2356)
			else
				local v2357, v2358 = proto.readVarInt(p183, n122)

				n122 = v2358 + v2357
			end
		elseif v2354 == proto.wireTypes.i32 then
			local v2359

			v2359, n122 = proto.readFixed32(p183, n122)
		elseif v2354 == proto.wireTypes.i64 then
			local v2360

			v2360, n122 = proto.readFixed64(p183, n122)
		else
			error("Unsupported wire type: " .. v2354)
		end
	end

	return v2351
end
function t290.jsonEncode(p184) -- line: 15067
	local t292 = {}

	if p184.upsell_prompt ~= nil and p184.upsell_prompt ~= "" then
		t292.upsellPrompt = p184.upsell_prompt
	end

	return t292
end
function t290.jsonDecode(t293: {[any]: any}) -- line: 15077
	-- upvalues: t290 (copy)
	local v2364 = t290.new()

	if t293.upsell_prompt ~= nil then
		v2364.upsell_prompt = t293.upsell_prompt
	end

	if t293.upsellPrompt ~= nil then
		v2364.upsell_prompt = t293.upsellPrompt
	end

	return v2364
end

t290.descriptor = {
	name = "AgeCheckUpsellInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.AgeCheckUpsellInputData"
}
t1.AgeCheckUpsellInputData = t290
typeRegistry.default:register(t1.AgeCheckUpsellInputData)

local t294 = {}

t294.__index = t294

function t294.new(t295: {[any]: any}?) -- line: 15105
	-- upvalues: t294 (copy)
	return (setmetatable({
		modal_variant = if t295 ~= nil and t295.modal_variant ~= nil then t295.modal_variant else "",
		modal_sequence = if t295 ~= nil and t295.modal_sequence ~= nil then t295.modal_sequence else "",
		conversation_id = if t295 ~= nil and t295.conversation_id ~= nil then t295.conversation_id else "",
		friend_id = if t295 ~= nil and t295.friend_id ~= nil then t295.friend_id else ""
	}, t294))
end
function t294.encode(p185) -- line: 15116
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n123 = 0

	if p185.modal_variant ~= nil and p185.modal_variant ~= "" then
		local v2369, v2370 = proto.writeTag(buf, n123, 1, proto.wireTypes.lengthDelimited)

		buf, n123 = proto.writeString(v2369, v2370, p185.modal_variant)
	end

	if p185.modal_sequence ~= nil and p185.modal_sequence ~= "" then
		local v2371, v2372 = proto.writeTag(buf, n123, 2, proto.wireTypes.lengthDelimited)

		buf, n123 = proto.writeString(v2371, v2372, p185.modal_sequence)
	end

	if p185.conversation_id ~= nil and p185.conversation_id ~= "" then
		local v2373, v2374 = proto.writeTag(buf, n123, 3, proto.wireTypes.lengthDelimited)

		buf, n123 = proto.writeString(v2373, v2374, p185.conversation_id)
	end

	if p185.friend_id ~= nil and p185.friend_id ~= "" then
		local v2375, v2376 = proto.writeTag(buf, n123, 4, proto.wireTypes.lengthDelimited)

		buf, n123 = proto.writeString(v2375, v2376, p185.friend_id)
	end

	local buf66 = buffer.create(n123)

	buffer.copy(buf66, 0, buf, 0, n123)

	return buf66
end
function t294.decode(p186: buffer) -- line: 15145
	-- upvalues: t294 (copy), proto (copy)
	local v2379 = t294.new()
	local n124 = 0

	while n124 < buffer.len(p186) do
		local v2381, v2382

		v2381, v2382, n124 = proto.readTag(p186, n124)

		if v2382 == proto.wireTypes.varint then
			local v2383

			v2383, n124 = proto.readVarInt(p186, n124)
		elseif v2382 == proto.wireTypes.lengthDelimited then
			if v2381 == 1 then
				local v2384

				v2384, n124 = proto.readBuffer(p186, n124)
				v2379.modal_variant = buffer.tostring(v2384)
			elseif v2381 == 2 then
				local v2385

				v2385, n124 = proto.readBuffer(p186, n124)
				v2379.modal_sequence = buffer.tostring(v2385)
			elseif v2381 == 3 then
				local v2386

				v2386, n124 = proto.readBuffer(p186, n124)
				v2379.conversation_id = buffer.tostring(v2386)
			elseif v2381 == 4 then
				local v2387

				v2387, n124 = proto.readBuffer(p186, n124)
				v2379.friend_id = buffer.tostring(v2387)
			else
				local v2388, v2389 = proto.readVarInt(p186, n124)

				n124 = v2389 + v2388
			end
		elseif v2382 == proto.wireTypes.i32 then
			local v2390

			v2390, n124 = proto.readFixed32(p186, n124)
		elseif v2382 == proto.wireTypes.i64 then
			local v2391

			v2391, n124 = proto.readFixed64(p186, n124)
		else
			error("Unsupported wire type: " .. v2382)
		end
	end

	return v2379
end
function t294.jsonEncode(p187) -- line: 15203
	local t296 = {}

	if p187.modal_variant ~= nil and p187.modal_variant ~= "" then
		t296.modalVariant = p187.modal_variant
	end

	if p187.modal_sequence ~= nil and p187.modal_sequence ~= "" then
		t296.modalSequence = p187.modal_sequence
	end

	if p187.conversation_id ~= nil and p187.conversation_id ~= "" then
		t296.conversationId = p187.conversation_id
	end

	if p187.friend_id ~= nil and p187.friend_id ~= "" then
		t296.friendId = p187.friend_id
	end

	return t296
end
function t294.jsonDecode(t297: {[any]: any}) -- line: 15225
	-- upvalues: t294 (copy)
	local v2395 = t294.new()

	if t297.modal_variant ~= nil then
		v2395.modal_variant = t297.modal_variant
	end

	if t297.modalVariant ~= nil then
		v2395.modal_variant = t297.modalVariant
	end

	if t297.modal_sequence ~= nil then
		v2395.modal_sequence = t297.modal_sequence
	end

	if t297.modalSequence ~= nil then
		v2395.modal_sequence = t297.modalSequence
	end

	if t297.conversation_id ~= nil then
		v2395.conversation_id = t297.conversation_id
	end

	if t297.conversationId ~= nil then
		v2395.conversation_id = t297.conversationId
	end

	if t297.friend_id ~= nil then
		v2395.friend_id = t297.friend_id
	end

	if t297.friendId ~= nil then
		v2395.friend_id = t297.friendId
	end

	return v2395
end

t294.descriptor = {
	name = "PartyChatConversationUpsellInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.PartyChatConversationUpsellInputData"
}
t1.PartyChatConversationUpsellInputData = t294
typeRegistry.default:register(t1.PartyChatConversationUpsellInputData)

local t298 = {}

t298.__index = t298

function t298.new(t299: {[any]: any}?) -- line: 15279
	-- upvalues: t298 (copy)
	return (setmetatable({
		event_id = if t299 ~= nil and t299.event_id ~= nil then t299.event_id else "",
		universe_id = if t299 ~= nil and t299.universe_id ~= nil then t299.universe_id else "",
		entry_map = if t299 ~= nil and t299.entry_map ~= nil then t299.entry_map else {},
		entry_order = if t299 ~= nil and t299.entry_order ~= nil then t299.entry_order else {}
	}, t298))
end
function t298.encode(p188) -- line: 15290
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n125 = 0

	if p188.event_id ~= nil and p188.event_id ~= "" then
		local v2400, v2401 = proto.writeTag(buf, n125, 1, proto.wireTypes.lengthDelimited)

		buf, n125 = proto.writeString(v2400, v2401, p188.event_id)
	end

	if p188.universe_id ~= nil and p188.universe_id ~= "" then
		local v2402, v2403 = proto.writeTag(buf, n125, 2, proto.wireTypes.lengthDelimited)

		buf, n125 = proto.writeString(v2402, v2403, p188.universe_id)
	end

	if p188.entry_map ~= nil and next(p188.entry_map) ~= nil then
		for v2404, v2405 in p188.entry_map do
			local buf67 = buffer.create(0)
			local v2407, v2408 = proto.writeTag(buf67, 0, 1, proto.wireTypes.lengthDelimited)
			local v2409, v2410 = proto.writeString(v2407, v2408, v2404)
			local v2411 = v2405:encode()
			local v2412, v2413 = proto.writeTag(v2409, v2410, 2, proto.wireTypes.lengthDelimited)
			local v2414, v2415 = proto.writeBuffer(v2412, v2413, v2411, buffer.len(v2411))
			local v2416, v2417 = proto.writeTag(buf, n125, 3, proto.wireTypes.lengthDelimited)

			buf, n125 = proto.writeBuffer(v2416, v2417, v2414, v2415)
		end
	end

	if p188.entry_order ~= nil and #p188.entry_order > 0 then
		for _, v2419 in p188.entry_order do
			local v2420, v2421 = proto.writeTag(buf, n125, 4, proto.wireTypes.lengthDelimited)

			buf, n125 = proto.writeString(v2420, v2421, v2419)
		end
	end

	local buf68 = buffer.create(n125)

	buffer.copy(buf68, 0, buf, 0, n125)

	return buf68
end
function t298.decode(p189: buffer) -- line: 15330
	-- upvalues: t298 (copy), proto (copy), t1 (copy)
	local v2424 = t298.new()
	local n126 = 0

	while n126 < buffer.len(p189) do
		local v2426, v2427

		v2426, v2427, n126 = proto.readTag(p189, n126)

		if v2427 == proto.wireTypes.varint then
			local v2428

			v2428, n126 = proto.readVarInt(p189, n126)
		elseif v2427 == proto.wireTypes.lengthDelimited then
			if v2426 == 1 then
				local v2429

				v2429, n126 = proto.readBuffer(p189, n126)
				v2424.event_id = buffer.tostring(v2429)
			elseif v2426 == 2 then
				local v2430

				v2430, n126 = proto.readBuffer(p189, n126)
				v2424.universe_id = buffer.tostring(v2430)
			elseif v2426 == 3 then
				local v2431

				v2431, n126 = proto.readBuffer(p189, n126)

				local v2432 = t1.EventDetailsFeedInputData_EntryMapEntry.decode(v2431)
				local v2433 = t1.FeedEntry.new()

				v2424.entry_map[v2432.key or ""] = v2432.value or v2433
			elseif v2426 == 4 then
				local v2434

				v2434, n126 = proto.readBuffer(p189, n126)
				table.insert(v2424.entry_order, buffer.tostring(v2434))
			else
				local v2435, v2436 = proto.readVarInt(p189, n126)

				n126 = v2436 + v2435
			end
		elseif v2427 == proto.wireTypes.i32 then
			local v2437

			v2437, n126 = proto.readFixed32(p189, n126)
		elseif v2427 == proto.wireTypes.i64 then
			local v2438

			v2438, n126 = proto.readFixed64(p189, n126)
		else
			error("Unsupported wire type: " .. v2427)
		end
	end

	return v2424
end
function t298.jsonEncode(p190) -- line: 15395
	local t300 = {}

	if p190.event_id ~= nil and p190.event_id ~= "" then
		t300.eventId = p190.event_id
	end

	if p190.universe_id ~= nil and p190.universe_id ~= "" then
		t300.universeId = p190.universe_id
	end

	if p190.entry_map ~= nil and next(p190.entry_map) ~= nil then
		local t301 = {}

		for v2442, v2443 in p190.entry_map do
			t301[v2442] = v2443:jsonEncode()
		end

		t300.entryMap = t301
	end

	if p190.entry_order ~= nil and #p190.entry_order > 0 then
		local t302 = {}

		for _, v2446 in p190.entry_order do
			table.insert(t302, v2446)
		end

		t300.entryOrder = t302
	end

	return t300
end
function t298.jsonDecode(t303: {[any]: any}) -- line: 15425
	-- upvalues: t298 (copy), t1 (copy)
	local v2448 = t298.new()

	if t303.event_id ~= nil then
		v2448.event_id = t303.event_id
	end

	if t303.eventId ~= nil then
		v2448.event_id = t303.eventId
	end

	if t303.universe_id ~= nil then
		v2448.universe_id = t303.universe_id
	end

	if t303.universeId ~= nil then
		v2448.universe_id = t303.universeId
	end

	if t303.entry_map ~= nil then
		local t304 = {}

		for v2450, v2451 in t303.entry_map do
			t304[v2450] = t1.FeedEntry.jsonDecode(v2451)
		end

		v2448.entry_map = t304
	end

	if t303.entryMap ~= nil then
		local t305 = {}

		for v2453, v2454 in t303.entryMap do
			t305[v2453] = t1.FeedEntry.jsonDecode(v2454)
		end

		v2448.entry_map = t305
	end

	if t303.entry_order ~= nil then
		local t306 = {}

		for _, v2457 in t303.entry_order do
			table.insert(t306, v2457)
		end

		v2448.entry_order = t306
	end

	if t303.entryOrder ~= nil then
		local t307 = {}

		for _, v2460 in t303.entryOrder do
			table.insert(t307, v2460)
		end

		v2448.entry_order = t307
	end

	return v2448
end

t298.descriptor = {
	name = "EventDetailsFeedInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventDetailsFeedInputData"
}
t1.EventDetailsFeedInputData = t298
typeRegistry.default:register(t1.EventDetailsFeedInputData)

local t308 = {}

t308.__index = t308

function t308.new(t309: {[any]: any}?) -- line: 15497
	-- upvalues: t308 (copy)
	return (setmetatable({
		key = if t309 ~= nil and t309.key ~= nil then t309.key else "",
		value = if t309 ~= nil and t309.value ~= nil then t309.value else nil
	}, t308))
end
function t308.encode(p191) -- line: 15506
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n127 = 0

	if p191.key ~= nil and p191.key ~= "" then
		local v2465, v2466 = proto.writeTag(buf, n127, 1, proto.wireTypes.lengthDelimited)

		buf, n127 = proto.writeString(v2465, v2466, p191.key)
	end

	if p191.value ~= nil then
		local v2467 = p191.value:encode()
		local v2468, v2469 = proto.writeTag(buf, n127, 2, proto.wireTypes.lengthDelimited)

		buf, n127 = proto.writeBuffer(v2468, v2469, v2467, buffer.len(v2467))
	end

	local buf69 = buffer.create(n127)

	buffer.copy(buf69, 0, buf, 0, n127)

	return buf69
end
function t308.decode(p192: buffer) -- line: 15526
	-- upvalues: t308 (copy), proto (copy), t1 (copy)
	local v2472 = t308.new()
	local n128 = 0

	while n128 < buffer.len(p192) do
		local v2474, v2475

		v2474, v2475, n128 = proto.readTag(p192, n128)

		if v2475 == proto.wireTypes.varint then
			local v2476

			v2476, n128 = proto.readVarInt(p192, n128)
		elseif v2475 == proto.wireTypes.lengthDelimited then
			if v2474 == 1 then
				local v2477

				v2477, n128 = proto.readBuffer(p192, n128)
				v2472.key = buffer.tostring(v2477)
			elseif v2474 == 2 then
				local v2478

				v2478, n128 = proto.readBuffer(p192, n128)
				v2472.value = t1.FeedEntry.decode(v2478)
			else
				local v2479, v2480 = proto.readVarInt(p192, n128)

				n128 = v2480 + v2479
			end
		elseif v2475 == proto.wireTypes.i32 then
			local v2481

			v2481, n128 = proto.readFixed32(p192, n128)
		elseif v2475 == proto.wireTypes.i64 then
			local v2482

			v2482, n128 = proto.readFixed64(p192, n128)
		else
			error("Unsupported wire type: " .. v2475)
		end
	end

	return v2472
end
function t308.jsonEncode(p193) -- line: 15574
	local t310 = {}

	if p193.key ~= nil and p193.key ~= "" then
		t310.key = p193.key
	end

	if p193.value ~= nil then
		t310.value = p193.value:jsonEncode()
	end

	return t310
end
function t308.jsonDecode(t311: {[any]: any}) -- line: 15588
	-- upvalues: t308 (copy), t1 (copy)
	local v2486 = t308.new()

	if t311.key ~= nil then
		v2486.key = t311.key
	end

	if t311.value ~= nil then
		v2486.value = t1.FeedEntry.jsonDecode(t311.value)
	end

	return v2486
end

t308.descriptor = {
	name = "EventDetailsFeedInputData_EntryMapEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryMapEntry"
}
t1.EventDetailsFeedInputData_EntryMapEntry = t308
typeRegistry.default:register(t1.EventDetailsFeedInputData_EntryMapEntry)

local t312 = {}

t312.__index = t312

function t312.new(t313: {[any]: any}?) -- line: 15618
	-- upvalues: t312 (copy)
	return (setmetatable({
		event_id = if t313 ~= nil and t313.event_id ~= nil then t313.event_id else "",
		universe_id = if t313 ~= nil and t313.universe_id ~= nil then t313.universe_id else ""
	}, t312))
end
function t312.encode(p194) -- line: 15627
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n129 = 0

	if p194.event_id ~= nil and p194.event_id ~= "" then
		local v2491, v2492 = proto.writeTag(buf, n129, 1, proto.wireTypes.lengthDelimited)

		buf, n129 = proto.writeString(v2491, v2492, p194.event_id)
	end

	if p194.universe_id ~= nil and p194.universe_id ~= "" then
		local v2493, v2494 = proto.writeTag(buf, n129, 2, proto.wireTypes.lengthDelimited)

		buf, n129 = proto.writeString(v2493, v2494, p194.universe_id)
	end

	local buf70 = buffer.create(n129)

	buffer.copy(buf70, 0, buf, 0, n129)

	return buf70
end
function t312.decode(p195: buffer) -- line: 15646
	-- upvalues: t312 (copy), proto (copy)
	local v2497 = t312.new()
	local n130 = 0

	while n130 < buffer.len(p195) do
		local v2499, v2500

		v2499, v2500, n130 = proto.readTag(p195, n130)

		if v2500 == proto.wireTypes.varint then
			local v2501

			v2501, n130 = proto.readVarInt(p195, n130)
		elseif v2500 == proto.wireTypes.lengthDelimited then
			if v2499 == 1 then
				local v2502

				v2502, n130 = proto.readBuffer(p195, n130)
				v2497.event_id = buffer.tostring(v2502)
			elseif v2499 == 2 then
				local v2503

				v2503, n130 = proto.readBuffer(p195, n130)
				v2497.universe_id = buffer.tostring(v2503)
			else
				local v2504, v2505 = proto.readVarInt(p195, n130)

				n130 = v2505 + v2504
			end
		elseif v2500 == proto.wireTypes.i32 then
			local v2506

			v2506, n130 = proto.readFixed32(p195, n130)
		elseif v2500 == proto.wireTypes.i64 then
			local v2507

			v2507, n130 = proto.readFixed64(p195, n130)
		else
			error("Unsupported wire type: " .. v2500)
		end
	end

	return v2497
end
function t312.jsonEncode(p196) -- line: 15694
	local t314 = {}

	if p196.event_id ~= nil and p196.event_id ~= "" then
		t314.eventId = p196.event_id
	end

	if p196.universe_id ~= nil and p196.universe_id ~= "" then
		t314.universeId = p196.universe_id
	end

	return t314
end
function t312.jsonDecode(t315: {[any]: any}) -- line: 15708
	-- upvalues: t312 (copy)
	local v2511 = t312.new()

	if t315.event_id ~= nil then
		v2511.event_id = t315.event_id
	end

	if t315.eventId ~= nil then
		v2511.event_id = t315.eventId
	end

	if t315.universe_id ~= nil then
		v2511.universe_id = t315.universe_id
	end

	if t315.universeId ~= nil then
		v2511.universe_id = t315.universeId
	end

	return v2511
end

t312.descriptor = {
	name = "EventDetailsActionBarInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventDetailsActionBarInputData"
}
t1.EventDetailsActionBarInputData = t312
typeRegistry.default:register(t1.EventDetailsActionBarInputData)

local t316 = {}

t316.__index = t316

function t316.new(t317: {[any]: any}?) -- line: 15744
	-- upvalues: t316 (copy)
	return (setmetatable({
		event_id = if t317 ~= nil and t317.event_id ~= nil then t317.event_id else ""
	}, t316))
end
function t316.encode(p197) -- line: 15752
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n131 = 0

	if p197.event_id ~= nil and p197.event_id ~= "" then
		local v2516, v2517 = proto.writeTag(buf, n131, 1, proto.wireTypes.lengthDelimited)

		buf, n131 = proto.writeString(v2516, v2517, p197.event_id)
	end

	local buf71 = buffer.create(n131)

	buffer.copy(buf71, 0, buf, 0, n131)

	return buf71
end
function t316.decode(p198: buffer) -- line: 15766
	-- upvalues: t316 (copy), proto (copy)
	local v2520 = t316.new()
	local n132 = 0

	while n132 < buffer.len(p198) do
		local v2522, v2523

		v2522, v2523, n132 = proto.readTag(p198, n132)

		if v2523 == proto.wireTypes.varint then
			local v2524

			v2524, n132 = proto.readVarInt(p198, n132)
		elseif v2523 == proto.wireTypes.lengthDelimited then
			if v2522 == 1 then
				local v2525

				v2525, n132 = proto.readBuffer(p198, n132)
				v2520.event_id = buffer.tostring(v2525)
			else
				local v2526, v2527 = proto.readVarInt(p198, n132)

				n132 = v2527 + v2526
			end
		elseif v2523 == proto.wireTypes.i32 then
			local v2528

			v2528, n132 = proto.readFixed32(p198, n132)
		elseif v2523 == proto.wireTypes.i64 then
			local v2529

			v2529, n132 = proto.readFixed64(p198, n132)
		else
			error("Unsupported wire type: " .. v2523)
		end
	end

	return v2520
end
function t316.jsonEncode(p199) -- line: 15809
	local t318 = {}

	if p199.event_id ~= nil and p199.event_id ~= "" then
		t318.eventId = p199.event_id
	end

	return t318
end
function t316.jsonDecode(t319: {[any]: any}) -- line: 15819
	-- upvalues: t316 (copy)
	local v2533 = t316.new()

	if t319.event_id ~= nil then
		v2533.event_id = t319.event_id
	end

	if t319.eventId ~= nil then
		v2533.event_id = t319.eventId
	end

	return v2533
end

t316.descriptor = {
	name = "EventDescriptionInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventDescriptionInputData"
}
t1.EventDescriptionInputData = t316
typeRegistry.default:register(t1.EventDescriptionInputData)

local t320 = {}

t320.__index = t320

function t320.new(t321: {[any]: any}?) -- line: 15847
	-- upvalues: t320 (copy)
	return (setmetatable({
		event_id = if t321 ~= nil and t321.event_id ~= nil then t321.event_id else "",
		universe_id = if t321 ~= nil and t321.universe_id ~= nil then t321.universe_id else ""
	}, t320))
end
function t320.encode(p200) -- line: 15856
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n133 = 0

	if p200.event_id ~= nil and p200.event_id ~= "" then
		local v2538, v2539 = proto.writeTag(buf, n133, 1, proto.wireTypes.lengthDelimited)

		buf, n133 = proto.writeString(v2538, v2539, p200.event_id)
	end

	if p200.universe_id ~= nil and p200.universe_id ~= "" then
		local v2540, v2541 = proto.writeTag(buf, n133, 2, proto.wireTypes.lengthDelimited)

		buf, n133 = proto.writeString(v2540, v2541, p200.universe_id)
	end

	local buf72 = buffer.create(n133)

	buffer.copy(buf72, 0, buf, 0, n133)

	return buf72
end
function t320.decode(p201: buffer) -- line: 15875
	-- upvalues: t320 (copy), proto (copy)
	local v2544 = t320.new()
	local n134 = 0

	while n134 < buffer.len(p201) do
		local v2546, v2547

		v2546, v2547, n134 = proto.readTag(p201, n134)

		if v2547 == proto.wireTypes.varint then
			local v2548

			v2548, n134 = proto.readVarInt(p201, n134)
		elseif v2547 == proto.wireTypes.lengthDelimited then
			if v2546 == 1 then
				local v2549

				v2549, n134 = proto.readBuffer(p201, n134)
				v2544.event_id = buffer.tostring(v2549)
			elseif v2546 == 2 then
				local v2550

				v2550, n134 = proto.readBuffer(p201, n134)
				v2544.universe_id = buffer.tostring(v2550)
			else
				local v2551, v2552 = proto.readVarInt(p201, n134)

				n134 = v2552 + v2551
			end
		elseif v2547 == proto.wireTypes.i32 then
			local v2553

			v2553, n134 = proto.readFixed32(p201, n134)
		elseif v2547 == proto.wireTypes.i64 then
			local v2554

			v2554, n134 = proto.readFixed64(p201, n134)
		else
			error("Unsupported wire type: " .. v2547)
		end
	end

	return v2544
end
function t320.jsonEncode(p202) -- line: 15923
	local t322 = {}

	if p202.event_id ~= nil and p202.event_id ~= "" then
		t322.eventId = p202.event_id
	end

	if p202.universe_id ~= nil and p202.universe_id ~= "" then
		t322.universeId = p202.universe_id
	end

	return t322
end
function t320.jsonDecode(t323: {[any]: any}) -- line: 15937
	-- upvalues: t320 (copy)
	local v2558 = t320.new()

	if t323.event_id ~= nil then
		v2558.event_id = t323.event_id
	end

	if t323.eventId ~= nil then
		v2558.event_id = t323.eventId
	end

	if t323.universe_id ~= nil then
		v2558.universe_id = t323.universe_id
	end

	if t323.universeId ~= nil then
		v2558.universe_id = t323.universeId
	end

	return v2558
end

t320.descriptor = {
	name = "EventAttributionRowInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventAttributionRowInputData"
}
t1.EventAttributionRowInputData = t320
typeRegistry.default:register(t1.EventAttributionRowInputData)

local t324 = {}

t324.__index = t324

function t324.new(t325: {[any]: any}?) -- line: 15973
	-- upvalues: t324 (copy)
	return (setmetatable({
		event_id = if t325 ~= nil and t325.event_id ~= nil then t325.event_id else ""
	}, t324))
end
function t324.encode(p203) -- line: 15979
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n135 = 0

	if p203.event_id ~= nil and p203.event_id ~= "" then
		local v2563, v2564 = proto.writeTag(buf, n135, 1, proto.wireTypes.lengthDelimited)

		buf, n135 = proto.writeString(v2563, v2564, p203.event_id)
	end

	local buf73 = buffer.create(n135)

	buffer.copy(buf73, 0, buf, 0, n135)

	return buf73
end
function t324.decode(p204: buffer) -- line: 15993
	-- upvalues: t324 (copy), proto (copy)
	local v2567 = t324.new()
	local n136 = 0

	while n136 < buffer.len(p204) do
		local v2569, v2570

		v2569, v2570, n136 = proto.readTag(p204, n136)

		if v2570 == proto.wireTypes.varint then
			local v2571

			v2571, n136 = proto.readVarInt(p204, n136)
		elseif v2570 == proto.wireTypes.lengthDelimited then
			if v2569 == 1 then
				local v2572

				v2572, n136 = proto.readBuffer(p204, n136)
				v2567.event_id = buffer.tostring(v2572)
			else
				local v2573, v2574 = proto.readVarInt(p204, n136)

				n136 = v2574 + v2573
			end
		elseif v2570 == proto.wireTypes.i32 then
			local v2575

			v2575, n136 = proto.readFixed32(p204, n136)
		elseif v2570 == proto.wireTypes.i64 then
			local v2576

			v2576, n136 = proto.readFixed64(p204, n136)
		else
			error("Unsupported wire type: " .. v2570)
		end
	end

	return v2567
end
function t324.jsonEncode(p205) -- line: 16036
	local t326 = {}

	if p205.event_id ~= nil and p205.event_id ~= "" then
		t326.eventId = p205.event_id
	end

	return t326
end
function t324.jsonDecode(t327: {[any]: any}) -- line: 16046
	-- upvalues: t324 (copy)
	local v2580 = t324.new()

	if t327.event_id ~= nil then
		v2580.event_id = t327.event_id
	end

	if t327.eventId ~= nil then
		v2580.event_id = t327.eventId
	end

	return v2580
end

t324.descriptor = {
	name = "EventInfoTableInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventInfoTableInputData"
}
t1.EventInfoTableInputData = t324
typeRegistry.default:register(t1.EventInfoTableInputData)

local t328 = {}

t328.__index = t328

function t328.new(t329: {[any]: any}?) -- line: 16074
	-- upvalues: t328 (copy)
	return (setmetatable({
		event_id = if t329 ~= nil and t329.event_id ~= nil then t329.event_id else ""
	}, t328))
end
function t328.encode(p206) -- line: 16082
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n137 = 0

	if p206.event_id ~= nil and p206.event_id ~= "" then
		local v2585, v2586 = proto.writeTag(buf, n137, 1, proto.wireTypes.lengthDelimited)

		buf, n137 = proto.writeString(v2585, v2586, p206.event_id)
	end

	local buf74 = buffer.create(n137)

	buffer.copy(buf74, 0, buf, 0, n137)

	return buf74
end
function t328.decode(p207: buffer) -- line: 16096
	-- upvalues: t328 (copy), proto (copy)
	local v2589 = t328.new()
	local n138 = 0

	while n138 < buffer.len(p207) do
		local v2591, v2592

		v2591, v2592, n138 = proto.readTag(p207, n138)

		if v2592 == proto.wireTypes.varint then
			local v2593

			v2593, n138 = proto.readVarInt(p207, n138)
		elseif v2592 == proto.wireTypes.lengthDelimited then
			if v2591 == 1 then
				local v2594

				v2594, n138 = proto.readBuffer(p207, n138)
				v2589.event_id = buffer.tostring(v2594)
			else
				local v2595, v2596 = proto.readVarInt(p207, n138)

				n138 = v2596 + v2595
			end
		elseif v2592 == proto.wireTypes.i32 then
			local v2597

			v2597, n138 = proto.readFixed32(p207, n138)
		elseif v2592 == proto.wireTypes.i64 then
			local v2598

			v2598, n138 = proto.readFixed64(p207, n138)
		else
			error("Unsupported wire type: " .. v2592)
		end
	end

	return v2589
end
function t328.jsonEncode(p208) -- line: 16139
	local t330 = {}

	if p208.event_id ~= nil and p208.event_id ~= "" then
		t330.eventId = p208.event_id
	end

	return t330
end
function t328.jsonDecode(t331: {[any]: any}) -- line: 16149
	-- upvalues: t328 (copy)
	local v2602 = t328.new()

	if t331.event_id ~= nil then
		v2602.event_id = t331.event_id
	end

	if t331.eventId ~= nil then
		v2602.event_id = t331.eventId
	end

	return v2602
end

t328.descriptor = {
	name = "EventDetailsSheetFullBleedInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventDetailsSheetFullBleedInputData"
}
t1.EventDetailsSheetFullBleedInputData = t328
typeRegistry.default:register(t1.EventDetailsSheetFullBleedInputData)

local t332 = {}

t332.__index = t332

function t332.new(t333: {[any]: any}?) -- line: 16179
	-- upvalues: t332 (copy)
	return (setmetatable({
		event_id = if t333 ~= nil and t333.event_id ~= nil then t333.event_id else "",
		universe_id = if t333 ~= nil and t333.universe_id ~= nil then t333.universe_id else ""
	}, t332))
end
function t332.encode(p209) -- line: 16188
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n139 = 0

	if p209.event_id ~= nil and p209.event_id ~= "" then
		local v2607, v2608 = proto.writeTag(buf, n139, 1, proto.wireTypes.lengthDelimited)

		buf, n139 = proto.writeString(v2607, v2608, p209.event_id)
	end

	if p209.universe_id ~= nil and p209.universe_id ~= "" then
		local v2609, v2610 = proto.writeTag(buf, n139, 2, proto.wireTypes.lengthDelimited)

		buf, n139 = proto.writeString(v2609, v2610, p209.universe_id)
	end

	local buf75 = buffer.create(n139)

	buffer.copy(buf75, 0, buf, 0, n139)

	return buf75
end
function t332.decode(p210: buffer) -- line: 16207
	-- upvalues: t332 (copy), proto (copy)
	local v2613 = t332.new()
	local n140 = 0

	while n140 < buffer.len(p210) do
		local v2615, v2616

		v2615, v2616, n140 = proto.readTag(p210, n140)

		if v2616 == proto.wireTypes.varint then
			local v2617

			v2617, n140 = proto.readVarInt(p210, n140)
		elseif v2616 == proto.wireTypes.lengthDelimited then
			if v2615 == 1 then
				local v2618

				v2618, n140 = proto.readBuffer(p210, n140)
				v2613.event_id = buffer.tostring(v2618)
			elseif v2615 == 2 then
				local v2619

				v2619, n140 = proto.readBuffer(p210, n140)
				v2613.universe_id = buffer.tostring(v2619)
			else
				local v2620, v2621 = proto.readVarInt(p210, n140)

				n140 = v2621 + v2620
			end
		elseif v2616 == proto.wireTypes.i32 then
			local v2622

			v2622, n140 = proto.readFixed32(p210, n140)
		elseif v2616 == proto.wireTypes.i64 then
			local v2623

			v2623, n140 = proto.readFixed64(p210, n140)
		else
			error("Unsupported wire type: " .. v2616)
		end
	end

	return v2613
end
function t332.jsonEncode(p211) -- line: 16255
	local t334 = {}

	if p211.event_id ~= nil and p211.event_id ~= "" then
		t334.eventId = p211.event_id
	end

	if p211.universe_id ~= nil and p211.universe_id ~= "" then
		t334.universeId = p211.universe_id
	end

	return t334
end
function t332.jsonDecode(t335: {[any]: any}) -- line: 16269
	-- upvalues: t332 (copy)
	local v2627 = t332.new()

	if t335.event_id ~= nil then
		v2627.event_id = t335.event_id
	end

	if t335.eventId ~= nil then
		v2627.event_id = t335.eventId
	end

	if t335.universe_id ~= nil then
		v2627.universe_id = t335.universe_id
	end

	if t335.universeId ~= nil then
		v2627.universe_id = t335.universeId
	end

	return v2627
end

t332.descriptor = {
	name = "EventNotificationsModalInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventNotificationsModalInputData"
}
t1.EventNotificationsModalInputData = t332
typeRegistry.default:register(t1.EventNotificationsModalInputData)

local t336 = {}

t336.__index = t336

function t336.new(t337: {[any]: any}?) -- line: 16307
	-- upvalues: t336 (copy)
	return (setmetatable({
		entry_map = if t337 ~= nil and t337.entry_map ~= nil then t337.entry_map else {},
		entry_order = if t337 ~= nil and t337.entry_order ~= nil then t337.entry_order else {},
		next_page_token = if t337 ~= nil and t337.next_page_token ~= nil then t337.next_page_token else "",
		sticky_filter_pills = if t337 ~= nil and t337.sticky_filter_pills ~= nil then t337.sticky_filter_pills else nil,
		applied_filters = if t337 ~= nil and t337.applied_filters ~= nil then t337.applied_filters else ""
	}, t336))
end
function t336.encode(p212) -- line: 16319
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n141 = 0

	if p212.entry_map ~= nil and next(p212.entry_map) ~= nil then
		for v2632, v2633 in p212.entry_map do
			local buf76 = buffer.create(0)
			local v2635, v2636 = proto.writeTag(buf76, 0, 1, proto.wireTypes.lengthDelimited)
			local v2637, v2638 = proto.writeString(v2635, v2636, v2632)
			local v2639 = v2633:encode()
			local v2640, v2641 = proto.writeTag(v2637, v2638, 2, proto.wireTypes.lengthDelimited)
			local v2642, v2643 = proto.writeBuffer(v2640, v2641, v2639, buffer.len(v2639))
			local v2644, v2645 = proto.writeTag(buf, n141, 1, proto.wireTypes.lengthDelimited)

			buf, n141 = proto.writeBuffer(v2644, v2645, v2642, v2643)
		end
	end

	if p212.entry_order ~= nil and #p212.entry_order > 0 then
		for _, v2647 in p212.entry_order do
			local v2648, v2649 = proto.writeTag(buf, n141, 2, proto.wireTypes.lengthDelimited)

			buf, n141 = proto.writeString(v2648, v2649, v2647)
		end
	end

	if p212.next_page_token ~= nil and p212.next_page_token ~= "" then
		local v2650, v2651 = proto.writeTag(buf, n141, 3, proto.wireTypes.lengthDelimited)

		buf, n141 = proto.writeString(v2650, v2651, p212.next_page_token)
	end

	if p212.sticky_filter_pills ~= nil then
		local v2652 = p212.sticky_filter_pills:encode()
		local v2653, v2654 = proto.writeTag(buf, n141, 4, proto.wireTypes.lengthDelimited)

		buf, n141 = proto.writeBuffer(v2653, v2654, v2652, buffer.len(v2652))
	end

	if p212.applied_filters ~= nil and p212.applied_filters ~= "" then
		local v2655, v2656 = proto.writeTag(buf, n141, 5, proto.wireTypes.lengthDelimited)

		buf, n141 = proto.writeString(v2655, v2656, p212.applied_filters)
	end

	local buf77 = buffer.create(n141)

	buffer.copy(buf77, 0, buf, 0, n141)

	return buf77
end
function t336.decode(p213: buffer) -- line: 16365
	-- upvalues: t336 (copy), proto (copy), t1 (copy)
	local v2659 = t336.new()
	local n142 = 0

	while n142 < buffer.len(p213) do
		local v2661, v2662

		v2661, v2662, n142 = proto.readTag(p213, n142)

		if v2662 == proto.wireTypes.varint then
			local v2663

			v2663, n142 = proto.readVarInt(p213, n142)
		elseif v2662 == proto.wireTypes.lengthDelimited then
			if v2661 == 1 then
				local v2664

				v2664, n142 = proto.readBuffer(p213, n142)

				local v2665 = t1.ChartsFeedInputData_EntryMapEntry.decode(v2664)
				local v2666 = t1.FeedEntry.new()

				v2659.entry_map[v2665.key or ""] = v2665.value or v2666
			elseif v2661 == 2 then
				local v2667

				v2667, n142 = proto.readBuffer(p213, n142)
				table.insert(v2659.entry_order, buffer.tostring(v2667))
			elseif v2661 == 3 then
				local v2668

				v2668, n142 = proto.readBuffer(p213, n142)
				v2659.next_page_token = buffer.tostring(v2668)
			elseif v2661 == 4 then
				local v2669

				v2669, n142 = proto.readBuffer(p213, n142)
				v2659.sticky_filter_pills = t1.FilterPillsInputData.decode(v2669)
			elseif v2661 == 5 then
				local v2670

				v2670, n142 = proto.readBuffer(p213, n142)
				v2659.applied_filters = buffer.tostring(v2670)
			else
				local v2671, v2672 = proto.readVarInt(p213, n142)

				n142 = v2672 + v2671
			end
		elseif v2662 == proto.wireTypes.i32 then
			local v2673

			v2673, n142 = proto.readFixed32(p213, n142)
		elseif v2662 == proto.wireTypes.i64 then
			local v2674

			v2674, n142 = proto.readFixed64(p213, n142)
		else
			error("Unsupported wire type: " .. v2662)
		end
	end

	return v2659
end
function t336.jsonEncode(p214) -- line: 16435
	local t338 = {}

	if p214.entry_map ~= nil and next(p214.entry_map) ~= nil then
		local t339 = {}

		for v2678, v2679 in p214.entry_map do
			t339[v2678] = v2679:jsonEncode()
		end

		t338.entryMap = t339
	end

	if p214.entry_order ~= nil and #p214.entry_order > 0 then
		local t340 = {}

		for _, v2682 in p214.entry_order do
			table.insert(t340, v2682)
		end

		t338.entryOrder = t340
	end

	if p214.next_page_token ~= nil and p214.next_page_token ~= "" then
		t338.nextPageToken = p214.next_page_token
	end

	if p214.sticky_filter_pills ~= nil then
		t338.stickyFilterPills = p214.sticky_filter_pills:jsonEncode()
	end

	if p214.applied_filters ~= nil and p214.applied_filters ~= "" then
		t338.appliedFilters = p214.applied_filters
	end

	return t338
end
function t336.jsonDecode(t341: {[any]: any}) -- line: 16469
	-- upvalues: t336 (copy), t1 (copy)
	local v2684 = t336.new()

	if t341.entry_map ~= nil then
		local t342 = {}

		for v2686, v2687 in t341.entry_map do
			t342[v2686] = t1.FeedEntry.jsonDecode(v2687)
		end

		v2684.entry_map = t342
	end

	if t341.entryMap ~= nil then
		local t343 = {}

		for v2689, v2690 in t341.entryMap do
			t343[v2689] = t1.FeedEntry.jsonDecode(v2690)
		end

		v2684.entry_map = t343
	end

	if t341.entry_order ~= nil then
		local t344 = {}

		for _, v2693 in t341.entry_order do
			table.insert(t344, v2693)
		end

		v2684.entry_order = t344
	end

	if t341.entryOrder ~= nil then
		local t345 = {}

		for _, v2696 in t341.entryOrder do
			table.insert(t345, v2696)
		end

		v2684.entry_order = t345
	end

	if t341.next_page_token ~= nil then
		v2684.next_page_token = t341.next_page_token
	end

	if t341.nextPageToken ~= nil then
		v2684.next_page_token = t341.nextPageToken
	end

	if t341.sticky_filter_pills ~= nil then
		v2684.sticky_filter_pills = t1.FilterPillsInputData.jsonDecode(t341.sticky_filter_pills)
	end

	if t341.stickyFilterPills ~= nil then
		v2684.sticky_filter_pills = t1.FilterPillsInputData.jsonDecode(t341.stickyFilterPills)
	end

	if t341.applied_filters ~= nil then
		v2684.applied_filters = t341.applied_filters
	end

	if t341.appliedFilters ~= nil then
		v2684.applied_filters = t341.appliedFilters
	end

	return v2684
end

t336.descriptor = {
	name = "ChartsFeedInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ChartsFeedInputData"
}
t1.ChartsFeedInputData = t336
typeRegistry.default:register(t1.ChartsFeedInputData)

local t346 = {}

t346.__index = t346

function t346.new(t347: {[any]: any}?) -- line: 16549
	-- upvalues: t346 (copy)
	return (setmetatable({
		key = if t347 ~= nil and t347.key ~= nil then t347.key else "",
		value = if t347 ~= nil and t347.value ~= nil then t347.value else nil
	}, t346))
end
function t346.encode(p215) -- line: 16558
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n143 = 0

	if p215.key ~= nil and p215.key ~= "" then
		local v2701, v2702 = proto.writeTag(buf, n143, 1, proto.wireTypes.lengthDelimited)

		buf, n143 = proto.writeString(v2701, v2702, p215.key)
	end

	if p215.value ~= nil then
		local v2703 = p215.value:encode()
		local v2704, v2705 = proto.writeTag(buf, n143, 2, proto.wireTypes.lengthDelimited)

		buf, n143 = proto.writeBuffer(v2704, v2705, v2703, buffer.len(v2703))
	end

	local buf78 = buffer.create(n143)

	buffer.copy(buf78, 0, buf, 0, n143)

	return buf78
end
function t346.decode(p216: buffer) -- line: 16578
	-- upvalues: t346 (copy), proto (copy), t1 (copy)
	local v2708 = t346.new()
	local n144 = 0

	while n144 < buffer.len(p216) do
		local v2710, v2711

		v2710, v2711, n144 = proto.readTag(p216, n144)

		if v2711 == proto.wireTypes.varint then
			local v2712

			v2712, n144 = proto.readVarInt(p216, n144)
		elseif v2711 == proto.wireTypes.lengthDelimited then
			if v2710 == 1 then
				local v2713

				v2713, n144 = proto.readBuffer(p216, n144)
				v2708.key = buffer.tostring(v2713)
			elseif v2710 == 2 then
				local v2714

				v2714, n144 = proto.readBuffer(p216, n144)
				v2708.value = t1.FeedEntry.decode(v2714)
			else
				local v2715, v2716 = proto.readVarInt(p216, n144)

				n144 = v2716 + v2715
			end
		elseif v2711 == proto.wireTypes.i32 then
			local v2717

			v2717, n144 = proto.readFixed32(p216, n144)
		elseif v2711 == proto.wireTypes.i64 then
			local v2718

			v2718, n144 = proto.readFixed64(p216, n144)
		else
			error("Unsupported wire type: " .. v2711)
		end
	end

	return v2708
end
function t346.jsonEncode(p217) -- line: 16626
	local t348 = {}

	if p217.key ~= nil and p217.key ~= "" then
		t348.key = p217.key
	end

	if p217.value ~= nil then
		t348.value = p217.value:jsonEncode()
	end

	return t348
end
function t346.jsonDecode(t349: {[any]: any}) -- line: 16640
	-- upvalues: t346 (copy), t1 (copy)
	local v2722 = t346.new()

	if t349.key ~= nil then
		v2722.key = t349.key
	end

	if t349.value ~= nil then
		v2722.value = t1.FeedEntry.jsonDecode(t349.value)
	end

	return v2722
end

t346.descriptor = {
	name = "ChartsFeedInputData_EntryMapEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryMapEntry"
}
t1.ChartsFeedInputData_EntryMapEntry = t346
typeRegistry.default:register(t1.ChartsFeedInputData_EntryMapEntry)

local t350 = {}

t350.__index = t350

function t350.new(t351: {[any]: any}?) -- line: 16670
	-- upvalues: t350 (copy)
	return (setmetatable({
		filter_groups = if t351 ~= nil and t351.filter_groups ~= nil then t351.filter_groups else {},
		sort_id = if t351 ~= nil and t351.sort_id ~= nil then t351.sort_id else "",
		secondary_sort_id = if t351 ~= nil and t351.secondary_sort_id ~= nil then t351.secondary_sort_id else 0,
		title = if t351 ~= nil and t351.title ~= nil then t351.title else "",
		primary_sort_id = if t351 ~= nil and t351.primary_sort_id ~= nil then t351.primary_sort_id else nil,
		applied_filters = if t351 ~= nil and t351.applied_filters ~= nil then t351.applied_filters else nil
	}, t350))
end
function t350.encode(p218) -- line: 16681
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n145 = 0

	if p218.filter_groups ~= nil and #p218.filter_groups > 0 then
		for _, v2728 in p218.filter_groups do
			local v2729 = v2728:encode()
			local v2730, v2731 = proto.writeTag(buf, n145, 1, proto.wireTypes.lengthDelimited)

			buf, n145 = proto.writeBuffer(v2730, v2731, v2729, buffer.len(v2729))
		end
	end

	if p218.sort_id ~= nil and p218.sort_id ~= "" then
		local v2732, v2733 = proto.writeTag(buf, n145, 2, proto.wireTypes.lengthDelimited)

		buf, n145 = proto.writeString(v2732, v2733, p218.sort_id)
	end

	if p218.secondary_sort_id ~= nil and p218.secondary_sort_id ~= 0 then
		local v2734, v2735 = proto.writeTag(buf, n145, 3, proto.wireTypes.varint)

		buf, n145 = proto.writeVarInt(v2734, v2735, p218.secondary_sort_id)
	end

	if p218.title ~= nil and p218.title ~= "" then
		local v2736, v2737 = proto.writeTag(buf, n145, 4, proto.wireTypes.lengthDelimited)

		buf, n145 = proto.writeString(v2736, v2737, p218.title)
	end

	if p218.primary_sort_id ~= nil then
		local v2738, v2739 = proto.writeTag(buf, n145, 5, proto.wireTypes.varint)

		buf, n145 = proto.writeVarInt(v2738, v2739, p218.primary_sort_id)
	end

	if p218.applied_filters ~= nil then
		local v2740, v2741 = proto.writeTag(buf, n145, 6, proto.wireTypes.lengthDelimited)

		buf, n145 = proto.writeString(v2740, v2741, p218.applied_filters)
	end

	local buf79 = buffer.create(n145)

	buffer.copy(buf79, 0, buf, 0, n145)

	return buf79
end
function t350.decode(p219: buffer) -- line: 16723
	-- upvalues: t350 (copy), proto (copy), t1 (copy)
	local v2744 = t350.new()
	local n146 = 0

	while n146 < buffer.len(p219) do
		local v2746, v2747

		v2746, v2747, n146 = proto.readTag(p219, n146)

		if v2747 == proto.wireTypes.varint then
			if v2746 == 3 then
				local v2748

				v2748, n146 = proto.readVarIntI32(p219, n146)
				v2744.secondary_sort_id = v2748
			elseif v2746 == 5 then
				local v2749

				v2749, n146 = proto.readVarIntI32(p219, n146)
				v2744.primary_sort_id = v2749
			else
				local v2750

				v2750, n146 = proto.readVarInt(p219, n146)
			end
		elseif v2747 == proto.wireTypes.lengthDelimited then
			if v2746 == 1 then
				local v2751

				v2751, n146 = proto.readBuffer(p219, n146)
				table.insert(v2744.filter_groups, t1.FilterPillsInputData_FilterGroup.decode(v2751))
			elseif v2746 == 2 then
				local v2752

				v2752, n146 = proto.readBuffer(p219, n146)
				v2744.sort_id = buffer.tostring(v2752)
			elseif v2746 == 4 then
				local v2753

				v2753, n146 = proto.readBuffer(p219, n146)
				v2744.title = buffer.tostring(v2753)
			elseif v2746 == 6 then
				local v2754

				v2754, n146 = proto.readBuffer(p219, n146)
				v2744.applied_filters = buffer.tostring(v2754)
			else
				local v2755, v2756 = proto.readVarInt(p219, n146)

				n146 = v2756 + v2755
			end
		elseif v2747 == proto.wireTypes.i32 then
			local v2757

			v2757, n146 = proto.readFixed32(p219, n146)
		elseif v2747 == proto.wireTypes.i64 then
			local v2758

			v2758, n146 = proto.readFixed64(p219, n146)
		else
			error("Unsupported wire type: " .. v2747)
		end
	end

	return v2744
end
function t350.jsonEncode(p220) -- line: 16791
	local t352 = {}

	if p220.filter_groups ~= nil and #p220.filter_groups > 0 then
		local t353 = {}

		for _, v2763 in p220.filter_groups do
			table.insert(t353, v2763:jsonEncode())
		end

		t352.filterGroups = t353
	end

	if p220.sort_id ~= nil and p220.sort_id ~= "" then
		t352.sortId = p220.sort_id
	end

	if p220.secondary_sort_id ~= nil and p220.secondary_sort_id ~= 0 then
		t352.secondarySortId = p220.secondary_sort_id
	end

	if p220.title ~= nil and p220.title ~= "" then
		t352.title = p220.title
	end

	if p220.primary_sort_id ~= nil then
		t352.primarySortId = p220.primary_sort_id
	end

	if p220.applied_filters ~= nil then
		t352.appliedFilters = p220.applied_filters
	end

	return t352
end
function t350.jsonDecode(t354: {[any]: any}) -- line: 16825
	-- upvalues: t350 (copy), t1 (copy)
	local v2765 = t350.new()

	if t354.filter_groups ~= nil then
		local t355 = {}

		for _, v2768 in t354.filter_groups do
			table.insert(t355, t1.FilterPillsInputData_FilterGroup.jsonDecode(v2768))
		end

		v2765.filter_groups = t355
	end

	if t354.filterGroups ~= nil then
		local t356 = {}

		for _, v2771 in t354.filterGroups do
			table.insert(t356, t1.FilterPillsInputData_FilterGroup.jsonDecode(v2771))
		end

		v2765.filter_groups = t356
	end

	if t354.sort_id ~= nil then
		v2765.sort_id = t354.sort_id
	end

	if t354.sortId ~= nil then
		v2765.sort_id = t354.sortId
	end

	if t354.secondary_sort_id ~= nil then
		v2765.secondary_sort_id = t354.secondary_sort_id
	end

	if t354.secondarySortId ~= nil then
		v2765.secondary_sort_id = t354.secondarySortId
	end

	if t354.title ~= nil then
		v2765.title = t354.title
	end

	if t354.primary_sort_id ~= nil then
		v2765.primary_sort_id = t354.primary_sort_id
	end

	if t354.primarySortId ~= nil then
		v2765.primary_sort_id = t354.primarySortId
	end

	if t354.applied_filters ~= nil then
		v2765.applied_filters = t354.applied_filters
	end

	if t354.appliedFilters ~= nil then
		v2765.applied_filters = t354.appliedFilters
	end

	return v2765
end

t350.descriptor = {
	name = "FilterPillsInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.FilterPillsInputData"
}
t1.FilterPillsInputData = t350
typeRegistry.default:register(t1.FilterPillsInputData)

local t357 = {}

t357.__index = t357

function t357.new(t358: {[any]: any}?) -- line: 16899
	-- upvalues: t357 (copy)
	return (setmetatable({
		filter_id = if t358 ~= nil and t358.filter_id ~= nil then t358.filter_id else "",
		display_name = if t358 ~= nil and t358.display_name ~= nil then t358.display_name else "",
		options = if t358 ~= nil and t358.options ~= nil then t358.options else {},
		default_option_id = if t358 ~= nil and t358.default_option_id ~= nil then t358.default_option_id else "",
		selected_option_id = if t358 ~= nil and t358.selected_option_id ~= nil then t358.selected_option_id else "",
		filter_type = if t358 ~= nil and t358.filter_type ~= nil then t358.filter_type else "",
		inactive_option_ids = if t358 ~= nil and t358.inactive_option_ids ~= nil then t358.inactive_option_ids else {},
		info_text = if t358 ~= nil and t358.info_text ~= nil then t358.info_text else ""
	}, t357))
end
function t357.encode(p221) -- line: 16916
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n147 = 0

	if p221.filter_id ~= nil and p221.filter_id ~= "" then
		local v2776, v2777 = proto.writeTag(buf, n147, 1, proto.wireTypes.lengthDelimited)

		buf, n147 = proto.writeString(v2776, v2777, p221.filter_id)
	end

	if p221.display_name ~= nil and p221.display_name ~= "" then
		local v2778, v2779 = proto.writeTag(buf, n147, 2, proto.wireTypes.lengthDelimited)

		buf, n147 = proto.writeString(v2778, v2779, p221.display_name)
	end

	if p221.options ~= nil and #p221.options > 0 then
		for _, v2781 in p221.options do
			local v2782 = v2781:encode()
			local v2783, v2784 = proto.writeTag(buf, n147, 3, proto.wireTypes.lengthDelimited)

			buf, n147 = proto.writeBuffer(v2783, v2784, v2782, buffer.len(v2782))
		end
	end

	if p221.default_option_id ~= nil and p221.default_option_id ~= "" then
		local v2785, v2786 = proto.writeTag(buf, n147, 4, proto.wireTypes.lengthDelimited)

		buf, n147 = proto.writeString(v2785, v2786, p221.default_option_id)
	end

	if p221.selected_option_id ~= nil and p221.selected_option_id ~= "" then
		local v2787, v2788 = proto.writeTag(buf, n147, 5, proto.wireTypes.lengthDelimited)

		buf, n147 = proto.writeString(v2787, v2788, p221.selected_option_id)
	end

	if p221.filter_type ~= nil and p221.filter_type ~= "" then
		local v2789, v2790 = proto.writeTag(buf, n147, 6, proto.wireTypes.lengthDelimited)

		buf, n147 = proto.writeString(v2789, v2790, p221.filter_type)
	end

	if p221.inactive_option_ids ~= nil and #p221.inactive_option_ids > 0 then
		for _, v2792 in p221.inactive_option_ids do
			local v2793, v2794 = proto.writeTag(buf, n147, 7, proto.wireTypes.lengthDelimited)

			buf, n147 = proto.writeString(v2793, v2794, v2792)
		end
	end

	if p221.info_text ~= nil and p221.info_text ~= "" then
		local v2795, v2796 = proto.writeTag(buf, n147, 8, proto.wireTypes.lengthDelimited)

		buf, n147 = proto.writeString(v2795, v2796, p221.info_text)
	end

	local buf80 = buffer.create(n147)

	buffer.copy(buf80, 0, buf, 0, n147)

	return buf80
end
function t357.decode(p222: buffer) -- line: 16970
	-- upvalues: t357 (copy), proto (copy), t1 (copy)
	local v2799 = t357.new()
	local n148 = 0

	while n148 < buffer.len(p222) do
		local v2801, v2802

		v2801, v2802, n148 = proto.readTag(p222, n148)

		if v2802 == proto.wireTypes.varint then
			local v2803

			v2803, n148 = proto.readVarInt(p222, n148)
		elseif v2802 == proto.wireTypes.lengthDelimited then
			if v2801 == 1 then
				local v2804

				v2804, n148 = proto.readBuffer(p222, n148)
				v2799.filter_id = buffer.tostring(v2804)
			elseif v2801 == 2 then
				local v2805

				v2805, n148 = proto.readBuffer(p222, n148)
				v2799.display_name = buffer.tostring(v2805)
			elseif v2801 == 3 then
				local v2806

				v2806, n148 = proto.readBuffer(p222, n148)
				table.insert(v2799.options, t1.FilterPillsInputData_FilterOption.decode(v2806))
			elseif v2801 == 4 then
				local v2807

				v2807, n148 = proto.readBuffer(p222, n148)
				v2799.default_option_id = buffer.tostring(v2807)
			elseif v2801 == 5 then
				local v2808

				v2808, n148 = proto.readBuffer(p222, n148)
				v2799.selected_option_id = buffer.tostring(v2808)
			elseif v2801 == 6 then
				local v2809

				v2809, n148 = proto.readBuffer(p222, n148)
				v2799.filter_type = buffer.tostring(v2809)
			elseif v2801 == 7 then
				local v2810

				v2810, n148 = proto.readBuffer(p222, n148)
				table.insert(v2799.inactive_option_ids, buffer.tostring(v2810))
			elseif v2801 == 8 then
				local v2811

				v2811, n148 = proto.readBuffer(p222, n148)
				v2799.info_text = buffer.tostring(v2811)
			else
				local v2812, v2813 = proto.readVarInt(p222, n148)

				n148 = v2813 + v2812
			end
		elseif v2802 == proto.wireTypes.i32 then
			local v2814

			v2814, n148 = proto.readFixed32(p222, n148)
		elseif v2802 == proto.wireTypes.i64 then
			local v2815

			v2815, n148 = proto.readFixed64(p222, n148)
		else
			error("Unsupported wire type: " .. v2802)
		end
	end

	return v2799
end
function t357.jsonEncode(p223) -- line: 17048
	local t359 = {}

	if p223.filter_id ~= nil and p223.filter_id ~= "" then
		t359.filterId = p223.filter_id
	end

	if p223.display_name ~= nil and p223.display_name ~= "" then
		t359.displayName = p223.display_name
	end

	if p223.options ~= nil and #p223.options > 0 then
		local t360 = {}

		for _, v2820 in p223.options do
			table.insert(t360, v2820:jsonEncode())
		end

		t359.options = t360
	end

	if p223.default_option_id ~= nil and p223.default_option_id ~= "" then
		t359.defaultOptionId = p223.default_option_id
	end

	if p223.selected_option_id ~= nil and p223.selected_option_id ~= "" then
		t359.selectedOptionId = p223.selected_option_id
	end

	if p223.filter_type ~= nil and p223.filter_type ~= "" then
		t359.filterType = p223.filter_type
	end

	if p223.inactive_option_ids ~= nil and #p223.inactive_option_ids > 0 then
		local t361 = {}

		for _, v2823 in p223.inactive_option_ids do
			table.insert(t361, v2823)
		end

		t359.inactiveOptionIds = t361
	end

	if p223.info_text ~= nil and p223.info_text ~= "" then
		t359.infoText = p223.info_text
	end

	return t359
end
function t357.jsonDecode(t362: {[any]: any}) -- line: 17094
	-- upvalues: t357 (copy), t1 (copy)
	local v2825 = t357.new()

	if t362.filter_id ~= nil then
		v2825.filter_id = t362.filter_id
	end

	if t362.filterId ~= nil then
		v2825.filter_id = t362.filterId
	end

	if t362.display_name ~= nil then
		v2825.display_name = t362.display_name
	end

	if t362.displayName ~= nil then
		v2825.display_name = t362.displayName
	end

	if t362.options ~= nil then
		local t363 = {}

		for _, v2828 in t362.options do
			table.insert(t363, t1.FilterPillsInputData_FilterOption.jsonDecode(v2828))
		end

		v2825.options = t363
	end

	if t362.default_option_id ~= nil then
		v2825.default_option_id = t362.default_option_id
	end

	if t362.defaultOptionId ~= nil then
		v2825.default_option_id = t362.defaultOptionId
	end

	if t362.selected_option_id ~= nil then
		v2825.selected_option_id = t362.selected_option_id
	end

	if t362.selectedOptionId ~= nil then
		v2825.selected_option_id = t362.selectedOptionId
	end

	if t362.filter_type ~= nil then
		v2825.filter_type = t362.filter_type
	end

	if t362.filterType ~= nil then
		v2825.filter_type = t362.filterType
	end

	if t362.inactive_option_ids ~= nil then
		local t364 = {}

		for _, v2831 in t362.inactive_option_ids do
			table.insert(t364, v2831)
		end

		v2825.inactive_option_ids = t364
	end

	if t362.inactiveOptionIds ~= nil then
		local t365 = {}

		for _, v2834 in t362.inactiveOptionIds do
			table.insert(t365, v2834)
		end

		v2825.inactive_option_ids = t365
	end

	if t362.info_text ~= nil then
		v2825.info_text = t362.info_text
	end

	if t362.infoText ~= nil then
		v2825.info_text = t362.infoText
	end

	return v2825
end

t357.descriptor = {
	name = "FilterPillsInputData_FilterGroup",
	fullName = "roblox.apppageplatform.shared.v1beta1.FilterGroup"
}
t1.FilterPillsInputData_FilterGroup = t357
typeRegistry.default:register(t1.FilterPillsInputData_FilterGroup)

local t366 = {}

t366.__index = t366

function t366.new(t367: {[any]: any}?) -- line: 17191
	-- upvalues: t366 (copy)
	return (setmetatable({
		option_id = if t367 ~= nil and t367.option_id ~= nil then t367.option_id else "",
		display_name = if t367 ~= nil and t367.display_name ~= nil then t367.display_name else "",
		option_context_tag = if t367 ~= nil and t367.option_context_tag ~= nil then t367.option_context_tag else ""
	}, t366))
end
function t366.encode(p224) -- line: 17201
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n149 = 0

	if p224.option_id ~= nil and p224.option_id ~= "" then
		local v2839, v2840 = proto.writeTag(buf, n149, 1, proto.wireTypes.lengthDelimited)

		buf, n149 = proto.writeString(v2839, v2840, p224.option_id)
	end

	if p224.display_name ~= nil and p224.display_name ~= "" then
		local v2841, v2842 = proto.writeTag(buf, n149, 2, proto.wireTypes.lengthDelimited)

		buf, n149 = proto.writeString(v2841, v2842, p224.display_name)
	end

	if p224.option_context_tag ~= nil and p224.option_context_tag ~= "" then
		local v2843, v2844 = proto.writeTag(buf, n149, 3, proto.wireTypes.lengthDelimited)

		buf, n149 = proto.writeString(v2843, v2844, p224.option_context_tag)
	end

	local buf81 = buffer.create(n149)

	buffer.copy(buf81, 0, buf, 0, n149)

	return buf81
end
function t366.decode(p225: buffer) -- line: 17225
	-- upvalues: t366 (copy), proto (copy)
	local v2847 = t366.new()
	local n150 = 0

	while n150 < buffer.len(p225) do
		local v2849, v2850

		v2849, v2850, n150 = proto.readTag(p225, n150)

		if v2850 == proto.wireTypes.varint then
			local v2851

			v2851, n150 = proto.readVarInt(p225, n150)
		elseif v2850 == proto.wireTypes.lengthDelimited then
			if v2849 == 1 then
				local v2852

				v2852, n150 = proto.readBuffer(p225, n150)
				v2847.option_id = buffer.tostring(v2852)
			elseif v2849 == 2 then
				local v2853

				v2853, n150 = proto.readBuffer(p225, n150)
				v2847.display_name = buffer.tostring(v2853)
			elseif v2849 == 3 then
				local v2854

				v2854, n150 = proto.readBuffer(p225, n150)
				v2847.option_context_tag = buffer.tostring(v2854)
			else
				local v2855, v2856 = proto.readVarInt(p225, n150)

				n150 = v2856 + v2855
			end
		elseif v2850 == proto.wireTypes.i32 then
			local v2857

			v2857, n150 = proto.readFixed32(p225, n150)
		elseif v2850 == proto.wireTypes.i64 then
			local v2858

			v2858, n150 = proto.readFixed64(p225, n150)
		else
			error("Unsupported wire type: " .. v2850)
		end
	end

	return v2847
end
function t366.jsonEncode(p226) -- line: 17278
	local t368 = {}

	if p226.option_id ~= nil and p226.option_id ~= "" then
		t368.optionId = p226.option_id
	end

	if p226.display_name ~= nil and p226.display_name ~= "" then
		t368.displayName = p226.display_name
	end

	if p226.option_context_tag ~= nil and p226.option_context_tag ~= "" then
		t368.optionContextTag = p226.option_context_tag
	end

	return t368
end
function t366.jsonDecode(t369: {[any]: any}) -- line: 17296
	-- upvalues: t366 (copy)
	local v2862 = t366.new()

	if t369.option_id ~= nil then
		v2862.option_id = t369.option_id
	end

	if t369.optionId ~= nil then
		v2862.option_id = t369.optionId
	end

	if t369.display_name ~= nil then
		v2862.display_name = t369.display_name
	end

	if t369.displayName ~= nil then
		v2862.display_name = t369.displayName
	end

	if t369.option_context_tag ~= nil then
		v2862.option_context_tag = t369.option_context_tag
	end

	if t369.optionContextTag ~= nil then
		v2862.option_context_tag = t369.optionContextTag
	end

	return v2862
end

t366.descriptor = {
	name = "FilterPillsInputData_FilterOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.FilterOption"
}
t1.FilterPillsInputData_FilterOption = t366
typeRegistry.default:register(t1.FilterPillsInputData_FilterOption)

local t370 = {}

t370.__index = t370

function t370.new(t371: {[any]: any}?) -- line: 17342
	-- upvalues: t370 (copy)
	return (setmetatable({
		sort_options = if t371 ~= nil and t371.sort_options ~= nil then t371.sort_options else {},
		selected_sort_id = if t371 ~= nil and t371.selected_sort_id ~= nil then t371.selected_sort_id else ""
	}, t370))
end
function t370.encode(p227) -- line: 17349
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n151 = 0

	if p227.sort_options ~= nil and #p227.sort_options > 0 then
		for _, v2868 in p227.sort_options do
			local v2869 = v2868:encode()
			local v2870, v2871 = proto.writeTag(buf, n151, 1, proto.wireTypes.lengthDelimited)

			buf, n151 = proto.writeBuffer(v2870, v2871, v2869, buffer.len(v2869))
		end
	end

	if p227.selected_sort_id ~= nil and p227.selected_sort_id ~= "" then
		local v2872, v2873 = proto.writeTag(buf, n151, 2, proto.wireTypes.lengthDelimited)

		buf, n151 = proto.writeString(v2872, v2873, p227.selected_sort_id)
	end

	local buf82 = buffer.create(n151)

	buffer.copy(buf82, 0, buf, 0, n151)

	return buf82
end
function t370.decode(p228: buffer) -- line: 17371
	-- upvalues: t370 (copy), proto (copy), t1 (copy)
	local v2876 = t370.new()
	local n152 = 0

	while n152 < buffer.len(p228) do
		local v2878, v2879

		v2878, v2879, n152 = proto.readTag(p228, n152)

		if v2879 == proto.wireTypes.varint then
			local v2880

			v2880, n152 = proto.readVarInt(p228, n152)
		elseif v2879 == proto.wireTypes.lengthDelimited then
			if v2878 == 1 then
				local v2881

				v2881, n152 = proto.readBuffer(p228, n152)
				table.insert(v2876.sort_options, t1.SortSelectorInputData_SortOption.decode(v2881))
			elseif v2878 == 2 then
				local v2882

				v2882, n152 = proto.readBuffer(p228, n152)
				v2876.selected_sort_id = buffer.tostring(v2882)
			else
				local v2883, v2884 = proto.readVarInt(p228, n152)

				n152 = v2884 + v2883
			end
		elseif v2879 == proto.wireTypes.i32 then
			local v2885

			v2885, n152 = proto.readFixed32(p228, n152)
		elseif v2879 == proto.wireTypes.i64 then
			local v2886

			v2886, n152 = proto.readFixed64(p228, n152)
		else
			error("Unsupported wire type: " .. v2879)
		end
	end

	return v2876
end
function t370.jsonEncode(p229) -- line: 17419
	local t372 = {}

	if p229.sort_options ~= nil and #p229.sort_options > 0 then
		local t373 = {}

		for _, v2891 in p229.sort_options do
			table.insert(t373, v2891:jsonEncode())
		end

		t372.sortOptions = t373
	end

	if p229.selected_sort_id ~= nil and p229.selected_sort_id ~= "" then
		t372.selectedSortId = p229.selected_sort_id
	end

	return t372
end
function t370.jsonDecode(t374: {[any]: any}) -- line: 17437
	-- upvalues: t370 (copy), t1 (copy)
	local v2893 = t370.new()

	if t374.sort_options ~= nil then
		local t375 = {}

		for _, v2896 in t374.sort_options do
			table.insert(t375, t1.SortSelectorInputData_SortOption.jsonDecode(v2896))
		end

		v2893.sort_options = t375
	end

	if t374.sortOptions ~= nil then
		local t376 = {}

		for _, v2899 in t374.sortOptions do
			table.insert(t376, t1.SortSelectorInputData_SortOption.jsonDecode(v2899))
		end

		v2893.sort_options = t376
	end

	if t374.selected_sort_id ~= nil then
		v2893.selected_sort_id = t374.selected_sort_id
	end

	if t374.selectedSortId ~= nil then
		v2893.selected_sort_id = t374.selectedSortId
	end

	return v2893
end

t370.descriptor = {
	name = "SortSelectorInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.SortSelectorInputData"
}
t1.SortSelectorInputData = t370
typeRegistry.default:register(t1.SortSelectorInputData)

local t377 = {}

t377.__index = t377

function t377.new(t378: {[any]: any}?) -- line: 17483
	-- upvalues: t377 (copy)
	return (setmetatable({
		sort_id = if t378 ~= nil and t378.sort_id ~= nil then t378.sort_id else "",
		display_name = if t378 ~= nil and t378.display_name ~= nil then t378.display_name else "",
		content_type = if t378 ~= nil and t378.content_type ~= nil then t378.content_type else ""
	}, t377))
end
function t377.encode(p230) -- line: 17493
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n153 = 0

	if p230.sort_id ~= nil and p230.sort_id ~= "" then
		local v2904, v2905 = proto.writeTag(buf, n153, 1, proto.wireTypes.lengthDelimited)

		buf, n153 = proto.writeString(v2904, v2905, p230.sort_id)
	end

	if p230.display_name ~= nil and p230.display_name ~= "" then
		local v2906, v2907 = proto.writeTag(buf, n153, 2, proto.wireTypes.lengthDelimited)

		buf, n153 = proto.writeString(v2906, v2907, p230.display_name)
	end

	if p230.content_type ~= nil and p230.content_type ~= "" then
		local v2908, v2909 = proto.writeTag(buf, n153, 3, proto.wireTypes.lengthDelimited)

		buf, n153 = proto.writeString(v2908, v2909, p230.content_type)
	end

	local buf83 = buffer.create(n153)

	buffer.copy(buf83, 0, buf, 0, n153)

	return buf83
end
function t377.decode(p231: buffer) -- line: 17517
	-- upvalues: t377 (copy), proto (copy)
	local v2912 = t377.new()
	local n154 = 0

	while n154 < buffer.len(p231) do
		local v2914, v2915

		v2914, v2915, n154 = proto.readTag(p231, n154)

		if v2915 == proto.wireTypes.varint then
			local v2916

			v2916, n154 = proto.readVarInt(p231, n154)
		elseif v2915 == proto.wireTypes.lengthDelimited then
			if v2914 == 1 then
				local v2917

				v2917, n154 = proto.readBuffer(p231, n154)
				v2912.sort_id = buffer.tostring(v2917)
			elseif v2914 == 2 then
				local v2918

				v2918, n154 = proto.readBuffer(p231, n154)
				v2912.display_name = buffer.tostring(v2918)
			elseif v2914 == 3 then
				local v2919

				v2919, n154 = proto.readBuffer(p231, n154)
				v2912.content_type = buffer.tostring(v2919)
			else
				local v2920, v2921 = proto.readVarInt(p231, n154)

				n154 = v2921 + v2920
			end
		elseif v2915 == proto.wireTypes.i32 then
			local v2922

			v2922, n154 = proto.readFixed32(p231, n154)
		elseif v2915 == proto.wireTypes.i64 then
			local v2923

			v2923, n154 = proto.readFixed64(p231, n154)
		else
			error("Unsupported wire type: " .. v2915)
		end
	end

	return v2912
end
function t377.jsonEncode(p232) -- line: 17570
	local t379 = {}

	if p232.sort_id ~= nil and p232.sort_id ~= "" then
		t379.sortId = p232.sort_id
	end

	if p232.display_name ~= nil and p232.display_name ~= "" then
		t379.displayName = p232.display_name
	end

	if p232.content_type ~= nil and p232.content_type ~= "" then
		t379.contentType = p232.content_type
	end

	return t379
end
function t377.jsonDecode(t380: {[any]: any}) -- line: 17588
	-- upvalues: t377 (copy)
	local v2927 = t377.new()

	if t380.sort_id ~= nil then
		v2927.sort_id = t380.sort_id
	end

	if t380.sortId ~= nil then
		v2927.sort_id = t380.sortId
	end

	if t380.display_name ~= nil then
		v2927.display_name = t380.display_name
	end

	if t380.displayName ~= nil then
		v2927.display_name = t380.displayName
	end

	if t380.content_type ~= nil then
		v2927.content_type = t380.content_type
	end

	if t380.contentType ~= nil then
		v2927.content_type = t380.contentType
	end

	return v2927
end

t377.descriptor = {
	name = "SortSelectorInputData_SortOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.SortOption"
}
t1.SortSelectorInputData_SortOption = t377
typeRegistry.default:register(t1.SortSelectorInputData_SortOption)

local t381 = {}

t381.__index = t381

function t381.new(t382: {[any]: any}?) -- line: 17634
	-- upvalues: t381 (copy)
	return (setmetatable({
		selected_option = if t382 ~= nil and t382.selected_option ~= nil then t382.selected_option else "",
		options = if t382 ~= nil and t382.options ~= nil then t382.options else {},
		experience_carousel = if t382 ~= nil and t382.experience_carousel ~= nil then t382.experience_carousel else nil
	}, t381))
end
function t381.encode(p233) -- line: 17646
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n155 = 0

	if p233.selected_option ~= nil and p233.selected_option ~= "" then
		local v2932, v2933 = proto.writeTag(buf, n155, 1, proto.wireTypes.lengthDelimited)

		buf, n155 = proto.writeString(v2932, v2933, p233.selected_option)
	end

	if p233.options ~= nil and #p233.options > 0 then
		for _, v2935 in p233.options do
			local v2936 = v2935:encode()
			local v2937, v2938 = proto.writeTag(buf, n155, 2, proto.wireTypes.lengthDelimited)

			buf, n155 = proto.writeBuffer(v2937, v2938, v2936, buffer.len(v2936))
		end
	end

	if p233.experience_carousel ~= nil then
		local v2939 = p233.experience_carousel:encode()
		local v2940, v2941 = proto.writeTag(buf, n155, 3, proto.wireTypes.lengthDelimited)

		buf, n155 = proto.writeBuffer(v2940, v2941, v2939, buffer.len(v2939))
	end

	local buf84 = buffer.create(n155)

	buffer.copy(buf84, 0, buf, 0, n155)

	return buf84
end
function t381.decode(p234: buffer) -- line: 17674
	-- upvalues: t381 (copy), proto (copy), t1 (copy)
	local v2944 = t381.new()
	local n156 = 0

	while n156 < buffer.len(p234) do
		local v2946, v2947

		v2946, v2947, n156 = proto.readTag(p234, n156)

		if v2947 == proto.wireTypes.varint then
			local v2948

			v2948, n156 = proto.readVarInt(p234, n156)
		elseif v2947 == proto.wireTypes.lengthDelimited then
			if v2946 == 1 then
				local v2949

				v2949, n156 = proto.readBuffer(p234, n156)
				v2944.selected_option = buffer.tostring(v2949)
			elseif v2946 == 2 then
				local v2950

				v2950, n156 = proto.readBuffer(p234, n156)
				table.insert(v2944.options, t1.SelectorOption.decode(v2950))
			elseif v2946 == 3 then
				local v2951

				v2951, n156 = proto.readBuffer(p234, n156)
				v2944.experience_carousel = t1.ExperienceCarouselInputData.decode(v2951)
			else
				local v2952, v2953 = proto.readVarInt(p234, n156)

				n156 = v2953 + v2952
			end
		elseif v2947 == proto.wireTypes.i32 then
			local v2954

			v2954, n156 = proto.readFixed32(p234, n156)
		elseif v2947 == proto.wireTypes.i64 then
			local v2955

			v2955, n156 = proto.readFixed64(p234, n156)
		else
			error("Unsupported wire type: " .. v2947)
		end
	end

	return v2944
end
function t381.jsonEncode(p235) -- line: 17727
	local t383 = {}

	if p235.selected_option ~= nil and p235.selected_option ~= "" then
		t383.selectedOption = p235.selected_option
	end

	if p235.options ~= nil and #p235.options > 0 then
		local t384 = {}

		for _, v2960 in p235.options do
			table.insert(t384, v2960:jsonEncode())
		end

		t383.options = t384
	end

	if p235.experience_carousel ~= nil then
		t383.experienceCarousel = p235.experience_carousel:jsonEncode()
	end

	return t383
end
function t381.jsonDecode(t385: {[any]: any}) -- line: 17749
	-- upvalues: t381 (copy), t1 (copy)
	local v2962 = t381.new()

	if t385.selected_option ~= nil then
		v2962.selected_option = t385.selected_option
	end

	if t385.selectedOption ~= nil then
		v2962.selected_option = t385.selectedOption
	end

	if t385.options ~= nil then
		local t386 = {}

		for _, v2965 in t385.options do
			table.insert(t386, t1.SelectorOption.jsonDecode(v2965))
		end

		v2962.options = t386
	end

	if t385.experience_carousel ~= nil then
		v2962.experience_carousel = t1.ExperienceCarouselInputData.jsonDecode(t385.experience_carousel)
	end

	if t385.experienceCarousel ~= nil then
		v2962.experience_carousel = t1.ExperienceCarouselInputData.jsonDecode(t385.experienceCarousel)
	end

	return v2962
end

t381.descriptor = {
	name = "ChartsGenreSelectorInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ChartsGenreSelectorInputData"
}
t1.ChartsGenreSelectorInputData = t381
typeRegistry.default:register(t1.ChartsGenreSelectorInputData)

local t387 = {}

t387.__index = t387

function t387.new(t388: {[any]: any}?) -- line: 17794
	-- upvalues: t387 (copy)
	return (setmetatable({
		id = if t388 ~= nil and t388.id ~= nil then t388.id else "",
		preview_rows = if t388 ~= nil and t388.preview_rows ~= nil then t388.preview_rows else 0,
		widget_style = if t388 ~= nil and t388.widget_style ~= nil then t388.widget_style else nil,
		see_all_button = t388 ~= nil and (t388.see_all_button ~= nil and t388.see_all_button),
		information_popover_text = if t388 ~= nil and t388.information_popover_text ~= nil then t388.information_popover_text else ""
	}, t387))
end
function t387.encode(p236) -- line: 17808
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n157 = 0

	if p236.id ~= nil and p236.id ~= "" then
		local v2970, v2971 = proto.writeTag(buf, n157, 1, proto.wireTypes.lengthDelimited)

		buf, n157 = proto.writeString(v2970, v2971, p236.id)
	end

	if p236.preview_rows ~= nil and p236.preview_rows ~= 0 then
		local v2972, v2973 = proto.writeTag(buf, n157, 4, proto.wireTypes.varint)

		buf, n157 = proto.writeVarInt(v2972, v2973, p236.preview_rows)
	end

	if p236.widget_style ~= nil then
		local v2974 = p236.widget_style:encode()
		local v2975, v2976 = proto.writeTag(buf, n157, 3, proto.wireTypes.lengthDelimited)

		buf, n157 = proto.writeBuffer(v2975, v2976, v2974, buffer.len(v2974))
	end

	if p236.see_all_button then
		local v2977, v2978 = proto.writeTag(buf, n157, 5, proto.wireTypes.varint)

		buf, n157 = proto.writeVarInt(v2977, v2978, not p236.see_all_button and 0 or 1)
	end

	if p236.information_popover_text ~= nil and p236.information_popover_text ~= "" then
		local v2979, v2980 = proto.writeTag(buf, n157, 6, proto.wireTypes.lengthDelimited)

		buf, n157 = proto.writeString(v2979, v2980, p236.information_popover_text)
	end

	local buf85 = buffer.create(n157)

	buffer.copy(buf85, 0, buf, 0, n157)

	return buf85
end
function t387.decode(p237: buffer) -- line: 17843
	-- upvalues: t387 (copy), proto (copy), t1 (copy)
	local v2983 = t387.new()
	local n158 = 0

	while n158 < buffer.len(p237) do
		local v2985, v2986

		v2985, v2986, n158 = proto.readTag(p237, n158)

		if v2986 == proto.wireTypes.varint then
			if v2985 == 4 then
				local v2987

				v2987, n158 = proto.readVarIntI64(p237, n158)
				v2983.preview_rows = v2987
			elseif v2985 == 5 then
				local v2988

				v2988, n158 = proto.readVarInt(p237, n158)
				v2983.see_all_button = v2988 ~= 0
			else
				local v2989

				v2989, n158 = proto.readVarInt(p237, n158)
			end
		elseif v2986 == proto.wireTypes.lengthDelimited then
			if v2985 == 1 then
				local v2990

				v2990, n158 = proto.readBuffer(p237, n158)
				v2983.id = buffer.tostring(v2990)
			elseif v2985 == 3 then
				local v2991

				v2991, n158 = proto.readBuffer(p237, n158)
				v2983.widget_style = t1.WidgetStyleData.decode(v2991)
			elseif v2985 == 6 then
				local v2992

				v2992, n158 = proto.readBuffer(p237, n158)
				v2983.information_popover_text = buffer.tostring(v2992)
			else
				local v2993, v2994 = proto.readVarInt(p237, n158)

				n158 = v2994 + v2993
			end
		elseif v2986 == proto.wireTypes.i32 then
			local v2995

			v2995, n158 = proto.readFixed32(p237, n158)
		elseif v2986 == proto.wireTypes.i64 then
			local v2996

			v2996, n158 = proto.readFixed64(p237, n158)
		else
			error("Unsupported wire type: " .. v2986)
		end
	end

	return v2983
end
function t387.jsonEncode(p238) -- line: 17906
	local t389 = {}

	if p238.id ~= nil and p238.id ~= "" then
		t389.id = p238.id
	end

	if p238.preview_rows ~= nil and p238.preview_rows ~= 0 then
		t389.previewRows = p238.preview_rows
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
function t387.jsonDecode(t390: {[any]: any}) -- line: 17932
	-- upvalues: t387 (copy), t1 (copy)
	local v3000 = t387.new()

	if t390.id ~= nil then
		v3000.id = t390.id
	end

	if t390.preview_rows ~= nil then
		v3000.preview_rows = t390.preview_rows
	end

	if t390.previewRows ~= nil then
		v3000.preview_rows = t390.previewRows
	end

	if t390.widget_style ~= nil then
		v3000.widget_style = t1.WidgetStyleData.jsonDecode(t390.widget_style)
	end

	if t390.widgetStyle ~= nil then
		v3000.widget_style = t1.WidgetStyleData.jsonDecode(t390.widgetStyle)
	end

	if t390.see_all_button ~= nil then
		v3000.see_all_button = t390.see_all_button
	end

	if t390.seeAllButton ~= nil then
		v3000.see_all_button = t390.seeAllButton
	end

	if t390.information_popover_text ~= nil then
		v3000.information_popover_text = t390.information_popover_text
	end

	if t390.informationPopoverText ~= nil then
		v3000.information_popover_text = t390.informationPopoverText
	end

	return v3000
end

t387.descriptor = {
	name = "UAMarketplaceCatalogItemGroupInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UAMarketplaceCatalogItemGroupInputData"
}
t1.UAMarketplaceCatalogItemGroupInputData = t387
typeRegistry.default:register(t1.UAMarketplaceCatalogItemGroupInputData)

local t391 = {}

t391.__index = t391

function t391.new(t392: {[any]: any}?) -- line: 17990
	-- upvalues: t391 (copy)
	return (setmetatable({
		id = if t392 ~= nil and t392.id ~= nil then t392.id else "",
		num_items_to_show = if t392 ~= nil and t392.num_items_to_show ~= nil then t392.num_items_to_show else 0,
		widget_style = if t392 ~= nil and t392.widget_style ~= nil then t392.widget_style else nil,
		see_all_button = t392 ~= nil and (t392.see_all_button ~= nil and t392.see_all_button),
		information_popover_text = if t392 ~= nil and t392.information_popover_text ~= nil then t392.information_popover_text else ""
	}, t391))
end
function t391.encode(p239) -- line: 18004
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n159 = 0

	if p239.id ~= nil and p239.id ~= "" then
		local v3005, v3006 = proto.writeTag(buf, n159, 1, proto.wireTypes.lengthDelimited)

		buf, n159 = proto.writeString(v3005, v3006, p239.id)
	end

	if p239.num_items_to_show ~= nil and p239.num_items_to_show ~= 0 then
		local v3007, v3008 = proto.writeTag(buf, n159, 5, proto.wireTypes.varint)

		buf, n159 = proto.writeVarInt(v3007, v3008, p239.num_items_to_show)
	end

	if p239.widget_style ~= nil then
		local v3009 = p239.widget_style:encode()
		local v3010, v3011 = proto.writeTag(buf, n159, 3, proto.wireTypes.lengthDelimited)

		buf, n159 = proto.writeBuffer(v3010, v3011, v3009, buffer.len(v3009))
	end

	if p239.see_all_button then
		local v3012, v3013 = proto.writeTag(buf, n159, 6, proto.wireTypes.varint)

		buf, n159 = proto.writeVarInt(v3012, v3013, not p239.see_all_button and 0 or 1)
	end

	if p239.information_popover_text ~= nil and p239.information_popover_text ~= "" then
		local v3014, v3015 = proto.writeTag(buf, n159, 7, proto.wireTypes.lengthDelimited)

		buf, n159 = proto.writeString(v3014, v3015, p239.information_popover_text)
	end

	local buf86 = buffer.create(n159)

	buffer.copy(buf86, 0, buf, 0, n159)

	return buf86
end
function t391.decode(p240: buffer) -- line: 18041
	-- upvalues: t391 (copy), proto (copy), t1 (copy)
	local v3018 = t391.new()
	local n160 = 0

	while n160 < buffer.len(p240) do
		local v3020, v3021

		v3020, v3021, n160 = proto.readTag(p240, n160)

		if v3021 == proto.wireTypes.varint then
			if v3020 == 5 then
				local v3022

				v3022, n160 = proto.readVarIntI64(p240, n160)
				v3018.num_items_to_show = v3022
			elseif v3020 == 6 then
				local v3023

				v3023, n160 = proto.readVarInt(p240, n160)
				v3018.see_all_button = v3023 ~= 0
			else
				local v3024

				v3024, n160 = proto.readVarInt(p240, n160)
			end
		elseif v3021 == proto.wireTypes.lengthDelimited then
			if v3020 == 1 then
				local v3025

				v3025, n160 = proto.readBuffer(p240, n160)
				v3018.id = buffer.tostring(v3025)
			elseif v3020 == 3 then
				local v3026

				v3026, n160 = proto.readBuffer(p240, n160)
				v3018.widget_style = t1.WidgetStyleData.decode(v3026)
			elseif v3020 == 7 then
				local v3027

				v3027, n160 = proto.readBuffer(p240, n160)
				v3018.information_popover_text = buffer.tostring(v3027)
			else
				local v3028, v3029 = proto.readVarInt(p240, n160)

				n160 = v3029 + v3028
			end
		elseif v3021 == proto.wireTypes.i32 then
			local v3030

			v3030, n160 = proto.readFixed32(p240, n160)
		elseif v3021 == proto.wireTypes.i64 then
			local v3031

			v3031, n160 = proto.readFixed64(p240, n160)
		else
			error("Unsupported wire type: " .. v3021)
		end
	end

	return v3018
end
function t391.jsonEncode(p241) -- line: 18106
	local t393 = {}

	if p241.id ~= nil and p241.id ~= "" then
		t393.id = p241.id
	end

	if p241.num_items_to_show ~= nil and p241.num_items_to_show ~= 0 then
		t393.numItemsToShow = p241.num_items_to_show
	end

	if p241.widget_style ~= nil then
		t393.widgetStyle = p241.widget_style:jsonEncode()
	end

	if p241.see_all_button then
		t393.seeAllButton = p241.see_all_button
	end

	if p241.information_popover_text ~= nil and p241.information_popover_text ~= "" then
		t393.informationPopoverText = p241.information_popover_text
	end

	return t393
end
function t391.jsonDecode(t394: {[any]: any}) -- line: 18134
	-- upvalues: t391 (copy), t1 (copy)
	local v3035 = t391.new()

	if t394.id ~= nil then
		v3035.id = t394.id
	end

	if t394.num_items_to_show ~= nil then
		v3035.num_items_to_show = t394.num_items_to_show
	end

	if t394.numItemsToShow ~= nil then
		v3035.num_items_to_show = t394.numItemsToShow
	end

	if t394.widget_style ~= nil then
		v3035.widget_style = t1.WidgetStyleData.jsonDecode(t394.widget_style)
	end

	if t394.widgetStyle ~= nil then
		v3035.widget_style = t1.WidgetStyleData.jsonDecode(t394.widgetStyle)
	end

	if t394.see_all_button ~= nil then
		v3035.see_all_button = t394.see_all_button
	end

	if t394.seeAllButton ~= nil then
		v3035.see_all_button = t394.seeAllButton
	end

	if t394.information_popover_text ~= nil then
		v3035.information_popover_text = t394.information_popover_text
	end

	if t394.informationPopoverText ~= nil then
		v3035.information_popover_text = t394.informationPopoverText
	end

	return v3035
end

t391.descriptor = {
	name = "UAMarketplaceCatalogItemCarouselInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UAMarketplaceCatalogItemCarouselInputData"
}
t1.UAMarketplaceCatalogItemCarouselInputData = t391
typeRegistry.default:register(t1.UAMarketplaceCatalogItemCarouselInputData)

local t395 = {}

t395.__index = t395

function t395.new(t396: {[any]: any}?) -- line: 18192
	-- upvalues: t395 (copy)
	return (setmetatable({
		background_layers = if t396 ~= nil and t396.background_layers ~= nil then t396.background_layers else {}
	}, t395))
end
function t395.encode(p242) -- line: 18198
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n161 = 0

	if p242.background_layers ~= nil and #p242.background_layers > 0 then
		for _, v3041 in p242.background_layers do
			local v3042 = v3041:encode()
			local v3043, v3044 = proto.writeTag(buf, n161, 1, proto.wireTypes.lengthDelimited)

			buf, n161 = proto.writeBuffer(v3043, v3044, v3042, buffer.len(v3042))
		end
	end

	local buf87 = buffer.create(n161)

	buffer.copy(buf87, 0, buf, 0, n161)

	return buf87
end
function t395.decode(p243: buffer) -- line: 18215
	-- upvalues: t395 (copy), proto (copy), background_layer (copy)
	local v3047 = t395.new()
	local n162 = 0

	while n162 < buffer.len(p243) do
		local v3049, v3050

		v3049, v3050, n162 = proto.readTag(p243, n162)

		if v3050 == proto.wireTypes.varint then
			local v3051

			v3051, n162 = proto.readVarInt(p243, n162)
		elseif v3050 == proto.wireTypes.lengthDelimited then
			if v3049 == 1 then
				local v3052

				v3052, n162 = proto.readBuffer(p243, n162)
				table.insert(v3047.background_layers, background_layer.BackgroundLayer.decode(v3052))
			else
				local v3053, v3054 = proto.readVarInt(p243, n162)

				n162 = v3054 + v3053
			end
		elseif v3050 == proto.wireTypes.i32 then
			local v3055

			v3055, n162 = proto.readFixed32(p243, n162)
		elseif v3050 == proto.wireTypes.i64 then
			local v3056

			v3056, n162 = proto.readFixed64(p243, n162)
		else
			error("Unsupported wire type: " .. v3050)
		end
	end

	return v3047
end
function t395.jsonEncode(p244) -- line: 18261
	local t397 = {}

	if p244.background_layers ~= nil and #p244.background_layers > 0 then
		local t398 = {}

		for _, v3061 in p244.background_layers do
			table.insert(t398, v3061:jsonEncode())
		end

		t397.backgroundLayers = t398
	end

	return t397
end
function t395.jsonDecode(t399: {[any]: any}) -- line: 18275
	-- upvalues: t395 (copy), background_layer (copy)
	local v3063 = t395.new()

	if t399.background_layers ~= nil then
		local t400 = {}

		for _, v3066 in t399.background_layers do
			table.insert(t400, background_layer.BackgroundLayer.jsonDecode(v3066))
		end

		v3063.background_layers = t400
	end

	if t399.backgroundLayers ~= nil then
		local t401 = {}

		for _, v3069 in t399.backgroundLayers do
			table.insert(t401, background_layer.BackgroundLayer.jsonDecode(v3069))
		end

		v3063.background_layers = t401
	end

	return v3063
end

t395.descriptor = {
	name = "WidgetStyleData",
	fullName = "roblox.apppageplatform.shared.v1beta1.WidgetStyleData"
}
t1.WidgetStyleData = t395
typeRegistry.default:register(t1.WidgetStyleData)

local t402 = {}

t402.__index = t402

function t402.new(t403: {[any]: any}?) -- line: 18319
	-- upvalues: t402 (copy)
	return (setmetatable({
		id = if t403 ~= nil and t403.id ~= nil then t403.id else "",
		available_until = if t403 ~= nil and t403.available_until ~= nil then t403.available_until else "",
		widget_style = if t403 ~= nil and t403.widget_style ~= nil then t403.widget_style else nil
	}, t402))
end
function t402.encode(p245) -- line: 18329
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n163 = 0

	if p245.id ~= nil and p245.id ~= "" then
		local v3074, v3075 = proto.writeTag(buf, n163, 1, proto.wireTypes.lengthDelimited)

		buf, n163 = proto.writeString(v3074, v3075, p245.id)
	end

	if p245.available_until ~= nil and p245.available_until ~= "" then
		local v3076, v3077 = proto.writeTag(buf, n163, 2, proto.wireTypes.lengthDelimited)

		buf, n163 = proto.writeString(v3076, v3077, p245.available_until)
	end

	if p245.widget_style ~= nil then
		local v3078 = p245.widget_style:encode()
		local v3079, v3080 = proto.writeTag(buf, n163, 3, proto.wireTypes.lengthDelimited)

		buf, n163 = proto.writeBuffer(v3079, v3080, v3078, buffer.len(v3078))
	end

	local buf88 = buffer.create(n163)

	buffer.copy(buf88, 0, buf, 0, n163)

	return buf88
end
function t402.decode(p246: buffer) -- line: 18354
	-- upvalues: t402 (copy), proto (copy), t1 (copy)
	local v3083 = t402.new()
	local n164 = 0

	while n164 < buffer.len(p246) do
		local v3085, v3086

		v3085, v3086, n164 = proto.readTag(p246, n164)

		if v3086 == proto.wireTypes.varint then
			local v3087

			v3087, n164 = proto.readVarInt(p246, n164)
		elseif v3086 == proto.wireTypes.lengthDelimited then
			if v3085 == 1 then
				local v3088

				v3088, n164 = proto.readBuffer(p246, n164)
				v3083.id = buffer.tostring(v3088)
			elseif v3085 == 2 then
				local v3089

				v3089, n164 = proto.readBuffer(p246, n164)
				v3083.available_until = buffer.tostring(v3089)
			elseif v3085 == 3 then
				local v3090

				v3090, n164 = proto.readBuffer(p246, n164)
				v3083.widget_style = t1.WidgetStyleData.decode(v3090)
			else
				local v3091, v3092 = proto.readVarInt(p246, n164)

				n164 = v3092 + v3091
			end
		elseif v3086 == proto.wireTypes.i32 then
			local v3093

			v3093, n164 = proto.readFixed32(p246, n164)
		elseif v3086 == proto.wireTypes.i64 then
			local v3094

			v3094, n164 = proto.readFixed64(p246, n164)
		else
			error("Unsupported wire type: " .. v3086)
		end
	end

	return v3083
end
function t402.jsonEncode(p247) -- line: 18407
	local t404 = {}

	if p247.id ~= nil and p247.id ~= "" then
		t404.id = p247.id
	end

	if p247.available_until ~= nil and p247.available_until ~= "" then
		t404.availableUntil = p247.available_until
	end

	if p247.widget_style ~= nil then
		t404.widgetStyle = p247.widget_style:jsonEncode()
	end

	return t404
end
function t402.jsonDecode(t405: {[any]: any}) -- line: 18425
	-- upvalues: t402 (copy), t1 (copy)
	local v3098 = t402.new()

	if t405.id ~= nil then
		v3098.id = t405.id
	end

	if t405.available_until ~= nil then
		v3098.available_until = t405.available_until
	end

	if t405.availableUntil ~= nil then
		v3098.available_until = t405.availableUntil
	end

	if t405.widget_style ~= nil then
		v3098.widget_style = t1.WidgetStyleData.jsonDecode(t405.widget_style)
	end

	if t405.widgetStyle ~= nil then
		v3098.widget_style = t1.WidgetStyleData.jsonDecode(t405.widgetStyle)
	end

	return v3098
end

t402.descriptor = {
	name = "UAMarketplaceCatalogHeroUnitInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UAMarketplaceCatalogHeroUnitInputData"
}
t1.UAMarketplaceCatalogHeroUnitInputData = t402
typeRegistry.default:register(t1.UAMarketplaceCatalogHeroUnitInputData)

local t406 = {}

t406.__index = t406

function t406.new(t407: {[any]: any}?) -- line: 18467
	-- upvalues: t406 (copy)
	return (setmetatable({
		entry_map = if t407 ~= nil and t407.entry_map ~= nil then t407.entry_map else {},
		entry_order = if t407 ~= nil and t407.entry_order ~= nil then t407.entry_order else {}
	}, t406))
end
function t406.encode(p248) -- line: 18476
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n165 = 0

	if p248.entry_map ~= nil and next(p248.entry_map) ~= nil then
		for v3103, v3104 in p248.entry_map do
			local buf89 = buffer.create(0)
			local v3106, v3107 = proto.writeTag(buf89, 0, 1, proto.wireTypes.lengthDelimited)
			local v3108, v3109 = proto.writeString(v3106, v3107, v3103)
			local v3110 = v3104:encode()
			local v3111, v3112 = proto.writeTag(v3108, v3109, 2, proto.wireTypes.lengthDelimited)
			local v3113, v3114 = proto.writeBuffer(v3111, v3112, v3110, buffer.len(v3110))
			local v3115, v3116 = proto.writeTag(buf, n165, 1, proto.wireTypes.lengthDelimited)

			buf, n165 = proto.writeBuffer(v3115, v3116, v3113, v3114)
		end
	end

	if p248.entry_order ~= nil and #p248.entry_order > 0 then
		for _, v3118 in p248.entry_order do
			local v3119, v3120 = proto.writeTag(buf, n165, 2, proto.wireTypes.lengthDelimited)

			buf, n165 = proto.writeString(v3119, v3120, v3118)
		end
	end

	local buf90 = buffer.create(n165)

	buffer.copy(buf90, 0, buf, 0, n165)

	return buf90
end
function t406.decode(p249: buffer) -- line: 18506
	-- upvalues: t406 (copy), proto (copy), t1 (copy)
	local v3123 = t406.new()
	local n166 = 0

	while n166 < buffer.len(p249) do
		local v3125, v3126

		v3125, v3126, n166 = proto.readTag(p249, n166)

		if v3126 == proto.wireTypes.varint then
			local v3127

			v3127, n166 = proto.readVarInt(p249, n166)
		elseif v3126 == proto.wireTypes.lengthDelimited then
			if v3125 == 1 then
				local v3128

				v3128, n166 = proto.readBuffer(p249, n166)

				local v3129 = t1.UAMarketplaceCatalogFeedInputData_EntryMapEntry.decode(v3128)
				local v3130 = t1.FeedEntry.new()

				v3123.entry_map[v3129.key or ""] = v3129.value or v3130
			elseif v3125 == 2 then
				local v3131

				v3131, n166 = proto.readBuffer(p249, n166)
				table.insert(v3123.entry_order, buffer.tostring(v3131))
			else
				local v3132, v3133 = proto.readVarInt(p249, n166)

				n166 = v3133 + v3132
			end
		elseif v3126 == proto.wireTypes.i32 then
			local v3134

			v3134, n166 = proto.readFixed32(p249, n166)
		elseif v3126 == proto.wireTypes.i64 then
			local v3135

			v3135, n166 = proto.readFixed64(p249, n166)
		else
			error("Unsupported wire type: " .. v3126)
		end
	end

	return v3123
end
function t406.jsonEncode(p250) -- line: 18561
	local t408 = {}

	if p250.entry_map ~= nil and next(p250.entry_map) ~= nil then
		local t409 = {}

		for v3139, v3140 in p250.entry_map do
			t409[v3139] = v3140:jsonEncode()
		end

		t408.entryMap = t409
	end

	if p250.entry_order ~= nil and #p250.entry_order > 0 then
		local t410 = {}

		for _, v3143 in p250.entry_order do
			table.insert(t410, v3143)
		end

		t408.entryOrder = t410
	end

	return t408
end
function t406.jsonDecode(t411: {[any]: any}) -- line: 18583
	-- upvalues: t406 (copy), t1 (copy)
	local v3145 = t406.new()

	if t411.entry_map ~= nil then
		local t412 = {}

		for v3147, v3148 in t411.entry_map do
			t412[v3147] = t1.FeedEntry.jsonDecode(v3148)
		end

		v3145.entry_map = t412
	end

	if t411.entryMap ~= nil then
		local t413 = {}

		for v3150, v3151 in t411.entryMap do
			t413[v3150] = t1.FeedEntry.jsonDecode(v3151)
		end

		v3145.entry_map = t413
	end

	if t411.entry_order ~= nil then
		local t414 = {}

		for _, v3154 in t411.entry_order do
			table.insert(t414, v3154)
		end

		v3145.entry_order = t414
	end

	if t411.entryOrder ~= nil then
		local t415 = {}

		for _, v3157 in t411.entryOrder do
			table.insert(t415, v3157)
		end

		v3145.entry_order = t415
	end

	return v3145
end

t406.descriptor = {
	name = "UAMarketplaceCatalogFeedInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UAMarketplaceCatalogFeedInputData"
}
t1.UAMarketplaceCatalogFeedInputData = t406
typeRegistry.default:register(t1.UAMarketplaceCatalogFeedInputData)

local t416 = {}

t416.__index = t416

function t416.new(t417: {[any]: any}?) -- line: 18641
	-- upvalues: t416 (copy)
	return (setmetatable({
		key = if t417 ~= nil and t417.key ~= nil then t417.key else "",
		value = if t417 ~= nil and t417.value ~= nil then t417.value else nil
	}, t416))
end
function t416.encode(p251) -- line: 18650
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n167 = 0

	if p251.key ~= nil and p251.key ~= "" then
		local v3162, v3163 = proto.writeTag(buf, n167, 1, proto.wireTypes.lengthDelimited)

		buf, n167 = proto.writeString(v3162, v3163, p251.key)
	end

	if p251.value ~= nil then
		local v3164 = p251.value:encode()
		local v3165, v3166 = proto.writeTag(buf, n167, 2, proto.wireTypes.lengthDelimited)

		buf, n167 = proto.writeBuffer(v3165, v3166, v3164, buffer.len(v3164))
	end

	local buf91 = buffer.create(n167)

	buffer.copy(buf91, 0, buf, 0, n167)

	return buf91
end
function t416.decode(p252: buffer) -- line: 18672
	-- upvalues: t416 (copy), proto (copy), t1 (copy)
	local v3169 = t416.new()
	local n168 = 0

	while n168 < buffer.len(p252) do
		local v3171, v3172

		v3171, v3172, n168 = proto.readTag(p252, n168)

		if v3172 == proto.wireTypes.varint then
			local v3173

			v3173, n168 = proto.readVarInt(p252, n168)
		elseif v3172 == proto.wireTypes.lengthDelimited then
			if v3171 == 1 then
				local v3174

				v3174, n168 = proto.readBuffer(p252, n168)
				v3169.key = buffer.tostring(v3174)
			elseif v3171 == 2 then
				local v3175

				v3175, n168 = proto.readBuffer(p252, n168)
				v3169.value = t1.FeedEntry.decode(v3175)
			else
				local v3176, v3177 = proto.readVarInt(p252, n168)

				n168 = v3177 + v3176
			end
		elseif v3172 == proto.wireTypes.i32 then
			local v3178

			v3178, n168 = proto.readFixed32(p252, n168)
		elseif v3172 == proto.wireTypes.i64 then
			local v3179

			v3179, n168 = proto.readFixed64(p252, n168)
		else
			error("Unsupported wire type: " .. v3172)
		end
	end

	return v3169
end
function t416.jsonEncode(p253) -- line: 18722
	local t418 = {}

	if p253.key ~= nil and p253.key ~= "" then
		t418.key = p253.key
	end

	if p253.value ~= nil then
		t418.value = p253.value:jsonEncode()
	end

	return t418
end
function t416.jsonDecode(t419: {[any]: any}) -- line: 18738
	-- upvalues: t416 (copy), t1 (copy)
	local v3183 = t416.new()

	if t419.key ~= nil then
		v3183.key = t419.key
	end

	if t419.value ~= nil then
		v3183.value = t1.FeedEntry.jsonDecode(t419.value)
	end

	return v3183
end

t416.descriptor = {
	name = "UAMarketplaceCatalogFeedInputData_EntryMapEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryMapEntry"
}
t1.UAMarketplaceCatalogFeedInputData_EntryMapEntry = t416
typeRegistry.default:register(t1.UAMarketplaceCatalogFeedInputData_EntryMapEntry)

local t420 = {}

t420.__index = t420

function t420.new(t421: {[any]: any}?) -- line: 18769
	-- upvalues: t420 (copy)
	return (setmetatable({
		marketplace_catalog_category_items = if t421 ~= nil and t421.marketplace_catalog_category_items ~= nil then t421.marketplace_catalog_category_items else {},
		active_category_id = if t421 ~= nil and t421.active_category_id ~= nil then t421.active_category_id else "",
		active_tooltip_idx = if t421 ~= nil and t421.active_tooltip_idx ~= nil then t421.active_tooltip_idx else 0
	}, t420))
end
function t420.encode(p254) -- line: 18782
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n169 = 0

	if p254.marketplace_catalog_category_items ~= nil and #p254.marketplace_catalog_category_items > 0 then
		for _, v3189 in p254.marketplace_catalog_category_items do
			local v3190 = v3189:encode()
			local v3191, v3192 = proto.writeTag(buf, n169, 1, proto.wireTypes.lengthDelimited)

			buf, n169 = proto.writeBuffer(v3191, v3192, v3190, buffer.len(v3190))
		end
	end

	if p254.active_category_id ~= nil and p254.active_category_id ~= "" then
		local v3193, v3194 = proto.writeTag(buf, n169, 2, proto.wireTypes.lengthDelimited)

		buf, n169 = proto.writeString(v3193, v3194, p254.active_category_id)
	end

	if p254.active_tooltip_idx ~= nil and p254.active_tooltip_idx ~= 0 then
		local v3195, v3196 = proto.writeTag(buf, n169, 3, proto.wireTypes.varint)

		buf, n169 = proto.writeVarInt(v3195, v3196, p254.active_tooltip_idx)
	end

	local buf92 = buffer.create(n169)

	buffer.copy(buf92, 0, buf, 0, n169)

	return buf92
end
function t420.decode(p255: buffer) -- line: 18811
	-- upvalues: t420 (copy), proto (copy), t1 (copy)
	local v3199 = t420.new()
	local n170 = 0

	while n170 < buffer.len(p255) do
		local v3201, v3202

		v3201, v3202, n170 = proto.readTag(p255, n170)

		if v3202 == proto.wireTypes.varint then
			if v3201 == 3 then
				local v3203

				v3203, n170 = proto.readVarIntI64(p255, n170)
				v3199.active_tooltip_idx = v3203
			else
				local v3204

				v3204, n170 = proto.readVarInt(p255, n170)
			end
		elseif v3202 == proto.wireTypes.lengthDelimited then
			if v3201 == 1 then
				local v3205

				v3205, n170 = proto.readBuffer(p255, n170)
				table.insert(v3199.marketplace_catalog_category_items, t1.UAMarketplaceCatalogCategoryMenuInputData_MarketplaceCatalogCategoryItem.decode(v3205))
			elseif v3201 == 2 then
				local v3206

				v3206, n170 = proto.readBuffer(p255, n170)
				v3199.active_category_id = buffer.tostring(v3206)
			else
				local v3207, v3208 = proto.readVarInt(p255, n170)

				n170 = v3208 + v3207
			end
		elseif v3202 == proto.wireTypes.i32 then
			local v3209

			v3209, n170 = proto.readFixed32(p255, n170)
		elseif v3202 == proto.wireTypes.i64 then
			local v3210

			v3210, n170 = proto.readFixed64(p255, n170)
		else
			error("Unsupported wire type: " .. v3202)
		end
	end

	return v3199
end
function t420.jsonEncode(p256) -- line: 18869
	local t422 = {}

	if p256.marketplace_catalog_category_items ~= nil and #p256.marketplace_catalog_category_items > 0 then
		local t423 = {}

		for _, v3215 in p256.marketplace_catalog_category_items do
			table.insert(t423, v3215:jsonEncode())
		end

		t422.marketplaceCatalogCategoryItems = t423
	end

	if p256.active_category_id ~= nil and p256.active_category_id ~= "" then
		t422.activeCategoryId = p256.active_category_id
	end

	if p256.active_tooltip_idx ~= nil and p256.active_tooltip_idx ~= 0 then
		t422.activeTooltipIdx = p256.active_tooltip_idx
	end

	return t422
end
function t420.jsonDecode(t424: {[any]: any}) -- line: 18893
	-- upvalues: t420 (copy), t1 (copy)
	local v3217 = t420.new()

	if t424.marketplace_catalog_category_items ~= nil then
		local t425 = {}

		for _, v3220 in t424.marketplace_catalog_category_items do
			table.insert(t425, t1.UAMarketplaceCatalogCategoryMenuInputData_MarketplaceCatalogCategoryItem.jsonDecode(v3220))
		end

		v3217.marketplace_catalog_category_items = t425
	end

	if t424.marketplaceCatalogCategoryItems ~= nil then
		local t426 = {}

		for _, v3223 in t424.marketplaceCatalogCategoryItems do
			table.insert(t426, t1.UAMarketplaceCatalogCategoryMenuInputData_MarketplaceCatalogCategoryItem.jsonDecode(v3223))
		end

		v3217.marketplace_catalog_category_items = t426
	end

	if t424.active_category_id ~= nil then
		v3217.active_category_id = t424.active_category_id
	end

	if t424.activeCategoryId ~= nil then
		v3217.active_category_id = t424.activeCategoryId
	end

	if t424.active_tooltip_idx ~= nil then
		v3217.active_tooltip_idx = t424.active_tooltip_idx
	end

	if t424.activeTooltipIdx ~= nil then
		v3217.active_tooltip_idx = t424.activeTooltipIdx
	end

	return v3217
end

t420.descriptor = {
	name = "UAMarketplaceCatalogCategoryMenuInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UAMarketplaceCatalogCategoryMenuInputData"
}
t1.UAMarketplaceCatalogCategoryMenuInputData = t420
typeRegistry.default:register(t1.UAMarketplaceCatalogCategoryMenuInputData)

local t427 = {}

t427.__index = t427

function t427.new(t428: {[any]: any}?) -- line: 18956
	-- upvalues: t427 (copy)
	return (setmetatable({
		marketplace_catalog_category_item_id = if t428 ~= nil and t428.marketplace_catalog_category_item_id ~= nil then t428.marketplace_catalog_category_item_id else ""
	}, t427))
end
function t427.encode(p257) -- line: 18970
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n171 = 0

	if p257.marketplace_catalog_category_item_id ~= nil and p257.marketplace_catalog_category_item_id ~= "" then
		local v3228, v3229 = proto.writeTag(buf, n171, 1, proto.wireTypes.lengthDelimited)

		buf, n171 = proto.writeString(v3228, v3229, p257.marketplace_catalog_category_item_id)
	end

	local buf93 = buffer.create(n171)

	buffer.copy(buf93, 0, buf, 0, n171)

	return buf93
end
function t427.decode(p258: buffer) -- line: 18986
	-- upvalues: t427 (copy), proto (copy)
	local v3232 = t427.new()
	local n172 = 0

	while n172 < buffer.len(p258) do
		local v3234, v3235

		v3234, v3235, n172 = proto.readTag(p258, n172)

		if v3235 == proto.wireTypes.varint then
			local v3236

			v3236, n172 = proto.readVarInt(p258, n172)
		elseif v3235 == proto.wireTypes.lengthDelimited then
			if v3234 == 1 then
				local v3237

				v3237, n172 = proto.readBuffer(p258, n172)
				v3232.marketplace_catalog_category_item_id = buffer.tostring(v3237)
			else
				local v3238, v3239 = proto.readVarInt(p258, n172)

				n172 = v3239 + v3238
			end
		elseif v3235 == proto.wireTypes.i32 then
			local v3240

			v3240, n172 = proto.readFixed32(p258, n172)
		elseif v3235 == proto.wireTypes.i64 then
			local v3241

			v3241, n172 = proto.readFixed64(p258, n172)
		else
			error("Unsupported wire type: " .. v3235)
		end
	end

	return v3232
end
function t427.jsonEncode(p259) -- line: 19031
	local t429 = {}

	if p259.marketplace_catalog_category_item_id ~= nil and p259.marketplace_catalog_category_item_id ~= "" then
		t429.marketplaceCatalogCategoryItemId = p259.marketplace_catalog_category_item_id
	end

	return t429
end
function t427.jsonDecode(t430: {[any]: any}) -- line: 19043
	-- upvalues: t427 (copy)
	local v3245 = t427.new()

	if t430.marketplace_catalog_category_item_id ~= nil then
		v3245.marketplace_catalog_category_item_id = t430.marketplace_catalog_category_item_id
	end

	if t430.marketplaceCatalogCategoryItemId ~= nil then
		v3245.marketplace_catalog_category_item_id = t430.marketplaceCatalogCategoryItemId
	end

	return v3245
end

t427.descriptor = {
	name = "UAMarketplaceCatalogCategoryMenuInputData_MarketplaceCatalogCategoryItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.MarketplaceCatalogCategoryItem"
}
t1.UAMarketplaceCatalogCategoryMenuInputData_MarketplaceCatalogCategoryItem = t427
typeRegistry.default:register(t1.UAMarketplaceCatalogCategoryMenuInputData_MarketplaceCatalogCategoryItem)

local t431 = {}

t431.__index = t431

function t431.new(t432: {[any]: any}?) -- line: 19076
	-- upvalues: t431 (copy)
	return (setmetatable({
		hero_icon = if t432 ~= nil and t432.hero_icon ~= nil then t432.hero_icon else nil,
		body_dismiss_button_text = if t432 ~= nil and t432.body_dismiss_button_text ~= nil then t432.body_dismiss_button_text else "",
		body_title = if t432 ~= nil and t432.body_title ~= nil then t432.body_title else "",
		body_rich_text = if t432 ~= nil and t432.body_rich_text ~= nil then t432.body_rich_text else "",
		terms_link_text = if t432 ~= nil and t432.terms_link_text ~= nil then t432.terms_link_text else nil,
		terms_title = if t432 ~= nil and t432.terms_title ~= nil then t432.terms_title else nil,
		terms_body_rich_text = if t432 ~= nil and t432.terms_body_rich_text ~= nil then t432.terms_body_rich_text else nil,
		terms_dismiss_button_text = if t432 ~= nil and t432.terms_dismiss_button_text ~= nil then t432.terms_dismiss_button_text else nil,
		offer_id = if t432 ~= nil and t432.offer_id ~= nil then t432.offer_id else ""
	}, t431))
end
function t431.encode(p260) -- line: 19098
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n173 = 0

	if p260.hero_icon ~= nil then
		local v3250, v3251 = proto.writeTag(buf, n173, 1, proto.wireTypes.lengthDelimited)

		buf, n173 = proto.writeString(v3250, v3251, p260.hero_icon)
	end

	if p260.body_dismiss_button_text ~= nil and p260.body_dismiss_button_text ~= "" then
		local v3252, v3253 = proto.writeTag(buf, n173, 2, proto.wireTypes.lengthDelimited)

		buf, n173 = proto.writeString(v3252, v3253, p260.body_dismiss_button_text)
	end

	if p260.body_title ~= nil and p260.body_title ~= "" then
		local v3254, v3255 = proto.writeTag(buf, n173, 3, proto.wireTypes.lengthDelimited)

		buf, n173 = proto.writeString(v3254, v3255, p260.body_title)
	end

	if p260.body_rich_text ~= nil and p260.body_rich_text ~= "" then
		local v3256, v3257 = proto.writeTag(buf, n173, 4, proto.wireTypes.lengthDelimited)

		buf, n173 = proto.writeString(v3256, v3257, p260.body_rich_text)
	end

	if p260.terms_link_text ~= nil then
		local v3258, v3259 = proto.writeTag(buf, n173, 5, proto.wireTypes.lengthDelimited)

		buf, n173 = proto.writeString(v3258, v3259, p260.terms_link_text)
	end

	if p260.terms_title ~= nil then
		local v3260, v3261 = proto.writeTag(buf, n173, 6, proto.wireTypes.lengthDelimited)

		buf, n173 = proto.writeString(v3260, v3261, p260.terms_title)
	end

	if p260.terms_body_rich_text ~= nil then
		local v3262, v3263 = proto.writeTag(buf, n173, 7, proto.wireTypes.lengthDelimited)

		buf, n173 = proto.writeString(v3262, v3263, p260.terms_body_rich_text)
	end

	if p260.terms_dismiss_button_text ~= nil then
		local v3264, v3265 = proto.writeTag(buf, n173, 8, proto.wireTypes.lengthDelimited)

		buf, n173 = proto.writeString(v3264, v3265, p260.terms_dismiss_button_text)
	end

	if p260.offer_id ~= nil and p260.offer_id ~= "" then
		local v3266, v3267 = proto.writeTag(buf, n173, 9, proto.wireTypes.lengthDelimited)

		buf, n173 = proto.writeString(v3266, v3267, p260.offer_id)
	end

	local buf94 = buffer.create(n173)

	buffer.copy(buf94, 0, buf, 0, n173)

	return buf94
end
function t431.decode(p261: buffer) -- line: 19152
	-- upvalues: t431 (copy), proto (copy)
	local v3270 = t431.new()
	local n174 = 0

	while n174 < buffer.len(p261) do
		local v3272, v3273

		v3272, v3273, n174 = proto.readTag(p261, n174)

		if v3273 == proto.wireTypes.varint then
			local v3274

			v3274, n174 = proto.readVarInt(p261, n174)
		elseif v3273 == proto.wireTypes.lengthDelimited then
			if v3272 == 1 then
				local v3275

				v3275, n174 = proto.readBuffer(p261, n174)
				v3270.hero_icon = buffer.tostring(v3275)
			elseif v3272 == 2 then
				local v3276

				v3276, n174 = proto.readBuffer(p261, n174)
				v3270.body_dismiss_button_text = buffer.tostring(v3276)
			elseif v3272 == 3 then
				local v3277

				v3277, n174 = proto.readBuffer(p261, n174)
				v3270.body_title = buffer.tostring(v3277)
			elseif v3272 == 4 then
				local v3278

				v3278, n174 = proto.readBuffer(p261, n174)
				v3270.body_rich_text = buffer.tostring(v3278)
			elseif v3272 == 5 then
				local v3279

				v3279, n174 = proto.readBuffer(p261, n174)
				v3270.terms_link_text = buffer.tostring(v3279)
			elseif v3272 == 6 then
				local v3280

				v3280, n174 = proto.readBuffer(p261, n174)
				v3270.terms_title = buffer.tostring(v3280)
			elseif v3272 == 7 then
				local v3281

				v3281, n174 = proto.readBuffer(p261, n174)
				v3270.terms_body_rich_text = buffer.tostring(v3281)
			elseif v3272 == 8 then
				local v3282

				v3282, n174 = proto.readBuffer(p261, n174)
				v3270.terms_dismiss_button_text = buffer.tostring(v3282)
			elseif v3272 == 9 then
				local v3283

				v3283, n174 = proto.readBuffer(p261, n174)
				v3270.offer_id = buffer.tostring(v3283)
			else
				local v3284, v3285 = proto.readVarInt(p261, n174)

				n174 = v3285 + v3284
			end
		elseif v3273 == proto.wireTypes.i32 then
			local v3286

			v3286, n174 = proto.readFixed32(p261, n174)
		elseif v3273 == proto.wireTypes.i64 then
			local v3287

			v3287, n174 = proto.readFixed64(p261, n174)
		else
			error("Unsupported wire type: " .. v3273)
		end
	end

	return v3270
end
function t431.jsonEncode(p262) -- line: 19235
	local t433 = {}

	if p262.hero_icon ~= nil then
		t433.heroIcon = p262.hero_icon
	end

	if p262.body_dismiss_button_text ~= nil and p262.body_dismiss_button_text ~= "" then
		t433.bodyDismissButtonText = p262.body_dismiss_button_text
	end

	if p262.body_title ~= nil and p262.body_title ~= "" then
		t433.bodyTitle = p262.body_title
	end

	if p262.body_rich_text ~= nil and p262.body_rich_text ~= "" then
		t433.bodyRichText = p262.body_rich_text
	end

	if p262.terms_link_text ~= nil then
		t433.termsLinkText = p262.terms_link_text
	end

	if p262.terms_title ~= nil then
		t433.termsTitle = p262.terms_title
	end

	if p262.terms_body_rich_text ~= nil then
		t433.termsBodyRichText = p262.terms_body_rich_text
	end

	if p262.terms_dismiss_button_text ~= nil then
		t433.termsDismissButtonText = p262.terms_dismiss_button_text
	end

	if p262.offer_id ~= nil and p262.offer_id ~= "" then
		t433.offerId = p262.offer_id
	end

	return t433
end
function t431.jsonDecode(t434: {[any]: any}) -- line: 19277
	-- upvalues: t431 (copy)
	local v3291 = t431.new()

	if t434.hero_icon ~= nil then
		v3291.hero_icon = t434.hero_icon
	end

	if t434.heroIcon ~= nil then
		v3291.hero_icon = t434.heroIcon
	end

	if t434.body_dismiss_button_text ~= nil then
		v3291.body_dismiss_button_text = t434.body_dismiss_button_text
	end

	if t434.bodyDismissButtonText ~= nil then
		v3291.body_dismiss_button_text = t434.bodyDismissButtonText
	end

	if t434.body_title ~= nil then
		v3291.body_title = t434.body_title
	end

	if t434.bodyTitle ~= nil then
		v3291.body_title = t434.bodyTitle
	end

	if t434.body_rich_text ~= nil then
		v3291.body_rich_text = t434.body_rich_text
	end

	if t434.bodyRichText ~= nil then
		v3291.body_rich_text = t434.bodyRichText
	end

	if t434.terms_link_text ~= nil then
		v3291.terms_link_text = t434.terms_link_text
	end

	if t434.termsLinkText ~= nil then
		v3291.terms_link_text = t434.termsLinkText
	end

	if t434.terms_title ~= nil then
		v3291.terms_title = t434.terms_title
	end

	if t434.termsTitle ~= nil then
		v3291.terms_title = t434.termsTitle
	end

	if t434.terms_body_rich_text ~= nil then
		v3291.terms_body_rich_text = t434.terms_body_rich_text
	end

	if t434.termsBodyRichText ~= nil then
		v3291.terms_body_rich_text = t434.termsBodyRichText
	end

	if t434.terms_dismiss_button_text ~= nil then
		v3291.terms_dismiss_button_text = t434.terms_dismiss_button_text
	end

	if t434.termsDismissButtonText ~= nil then
		v3291.terms_dismiss_button_text = t434.termsDismissButtonText
	end

	if t434.offer_id ~= nil then
		v3291.offer_id = t434.offer_id
	end

	if t434.offerId ~= nil then
		v3291.offer_id = t434.offerId
	end

	return v3291
end

t431.descriptor = {
	name = "MarketplaceOfferModalInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.MarketplaceOfferModalInputData"
}
t1.MarketplaceOfferModalInputData = t431
typeRegistry.default:register(t1.MarketplaceOfferModalInputData)

local t435 = {}

t435.__index = t435

function t435.new(t436: {[any]: any}?) -- line: 19369
	-- upvalues: t435 (copy)
	return (setmetatable({
		items = if t436 ~= nil and t436.items ~= nil then t436.items else {},
		preview_columns = if t436 ~= nil and t436.preview_columns ~= nil then t436.preview_columns else 0,
		impression_id = if t436 ~= nil and t436.impression_id ~= nil then t436.impression_id else ""
	}, t435))
end
function t435.encode(p263) -- line: 19377
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n175 = 0

	if p263.items ~= nil and #p263.items > 0 then
		for _, v3297 in p263.items do
			local v3298 = v3297:encode()
			local v3299, v3300 = proto.writeTag(buf, n175, 1, proto.wireTypes.lengthDelimited)

			buf, n175 = proto.writeBuffer(v3299, v3300, v3298, buffer.len(v3298))
		end
	end

	if p263.preview_columns ~= nil and p263.preview_columns ~= 0 then
		local v3301, v3302 = proto.writeTag(buf, n175, 2, proto.wireTypes.varint)

		buf, n175 = proto.writeVarInt(v3301, v3302, p263.preview_columns)
	end

	if p263.impression_id ~= nil and p263.impression_id ~= "" then
		local v3303, v3304 = proto.writeTag(buf, n175, 3, proto.wireTypes.lengthDelimited)

		buf, n175 = proto.writeString(v3303, v3304, p263.impression_id)
	end

	local buf95 = buffer.create(n175)

	buffer.copy(buf95, 0, buf, 0, n175)

	return buf95
end
function t435.decode(p264: buffer) -- line: 19404
	-- upvalues: t435 (copy), proto (copy), t1 (copy)
	local v3307 = t435.new()
	local n176 = 0

	while n176 < buffer.len(p264) do
		local v3309, v3310

		v3309, v3310, n176 = proto.readTag(p264, n176)

		if v3310 == proto.wireTypes.varint then
			if v3309 == 2 then
				local v3311

				v3311, n176 = proto.readVarIntI32(p264, n176)
				v3307.preview_columns = v3311
			else
				local v3312

				v3312, n176 = proto.readVarInt(p264, n176)
			end
		elseif v3310 == proto.wireTypes.lengthDelimited then
			if v3309 == 1 then
				local v3313

				v3313, n176 = proto.readBuffer(p264, n176)
				table.insert(v3307.items, t1.CatalogItemGridInputData_CatalogItem.decode(v3313))
			elseif v3309 == 3 then
				local v3314

				v3314, n176 = proto.readBuffer(p264, n176)
				v3307.impression_id = buffer.tostring(v3314)
			else
				local v3315, v3316 = proto.readVarInt(p264, n176)

				n176 = v3316 + v3315
			end
		elseif v3310 == proto.wireTypes.i32 then
			local v3317

			v3317, n176 = proto.readFixed32(p264, n176)
		elseif v3310 == proto.wireTypes.i64 then
			local v3318

			v3318, n176 = proto.readFixed64(p264, n176)
		else
			error("Unsupported wire type: " .. v3310)
		end
	end

	return v3307
end
function t435.jsonEncode(p265) -- line: 19457
	local t437 = {}

	if p265.items ~= nil and #p265.items > 0 then
		local t438 = {}

		for _, v3323 in p265.items do
			table.insert(t438, v3323:jsonEncode())
		end

		t437.items = t438
	end

	if p265.preview_columns ~= nil and p265.preview_columns ~= 0 then
		t437.previewColumns = p265.preview_columns
	end

	if p265.impression_id ~= nil and p265.impression_id ~= "" then
		t437.impressionId = p265.impression_id
	end

	return t437
end
function t435.jsonDecode(t439: {[any]: any}) -- line: 19479
	-- upvalues: t435 (copy), t1 (copy)
	local v3325 = t435.new()

	if t439.items ~= nil then
		local t440 = {}

		for _, v3328 in t439.items do
			table.insert(t440, t1.CatalogItemGridInputData_CatalogItem.jsonDecode(v3328))
		end

		v3325.items = t440
	end

	if t439.preview_columns ~= nil then
		v3325.preview_columns = t439.preview_columns
	end

	if t439.previewColumns ~= nil then
		v3325.preview_columns = t439.previewColumns
	end

	if t439.impression_id ~= nil then
		v3325.impression_id = t439.impression_id
	end

	if t439.impressionId ~= nil then
		v3325.impression_id = t439.impressionId
	end

	return v3325
end

t435.descriptor = {
	name = "CatalogItemGridInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CatalogItemGridInputData"
}
t1.CatalogItemGridInputData = t435
typeRegistry.default:register(t1.CatalogItemGridInputData)

local t441 = {}

t441.__index = t441

function t441.new(t442: {[any]: any}?) -- line: 19524
	-- upvalues: t441 (copy)
	return (setmetatable({
		id = if t442 ~= nil and t442.id ~= nil then t442.id else "",
		type = if t442 ~= nil and t442.type ~= nil then t442.type else ""
	}, t441))
end
function t441.encode(p266) -- line: 19533
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n177 = 0

	if p266.id ~= nil and p266.id ~= "" then
		local v3333, v3334 = proto.writeTag(buf, n177, 1, proto.wireTypes.lengthDelimited)

		buf, n177 = proto.writeString(v3333, v3334, p266.id)
	end

	if p266.type ~= nil and p266.type ~= "" then
		local v3335, v3336 = proto.writeTag(buf, n177, 2, proto.wireTypes.lengthDelimited)

		buf, n177 = proto.writeString(v3335, v3336, p266.type)
	end

	local buf96 = buffer.create(n177)

	buffer.copy(buf96, 0, buf, 0, n177)

	return buf96
end
function t441.decode(p267: buffer) -- line: 19552
	-- upvalues: t441 (copy), proto (copy)
	local v3339 = t441.new()
	local n178 = 0

	while n178 < buffer.len(p267) do
		local v3341, v3342

		v3341, v3342, n178 = proto.readTag(p267, n178)

		if v3342 == proto.wireTypes.varint then
			local v3343

			v3343, n178 = proto.readVarInt(p267, n178)
		elseif v3342 == proto.wireTypes.lengthDelimited then
			if v3341 == 1 then
				local v3344

				v3344, n178 = proto.readBuffer(p267, n178)
				v3339.id = buffer.tostring(v3344)
			elseif v3341 == 2 then
				local v3345

				v3345, n178 = proto.readBuffer(p267, n178)
				v3339.type = buffer.tostring(v3345)
			else
				local v3346, v3347 = proto.readVarInt(p267, n178)

				n178 = v3347 + v3346
			end
		elseif v3342 == proto.wireTypes.i32 then
			local v3348

			v3348, n178 = proto.readFixed32(p267, n178)
		elseif v3342 == proto.wireTypes.i64 then
			local v3349

			v3349, n178 = proto.readFixed64(p267, n178)
		else
			error("Unsupported wire type: " .. v3342)
		end
	end

	return v3339
end
function t441.jsonEncode(p268) -- line: 19600
	local t443 = {}

	if p268.id ~= nil and p268.id ~= "" then
		t443.id = p268.id
	end

	if p268.type ~= nil and p268.type ~= "" then
		t443.type = p268.type
	end

	return t443
end
function t441.jsonDecode(t444: {[any]: any}) -- line: 19614
	-- upvalues: t441 (copy)
	local v3353 = t441.new()

	if t444.id ~= nil then
		v3353.id = t444.id
	end

	if t444.type ~= nil then
		v3353.type = t444.type
	end

	return v3353
end

t441.descriptor = {
	name = "CatalogItemGridInputData_CatalogItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.CatalogItem"
}
t1.CatalogItemGridInputData_CatalogItem = t441
typeRegistry.default:register(t1.CatalogItemGridInputData_CatalogItem)

local t445 = {}

t445.__index = t445

function t445.new(t446: {[any]: any}?) -- line: 19644
	-- upvalues: t445 (copy)
	return (setmetatable({
		entry_map = if t446 ~= nil and t446.entry_map ~= nil then t446.entry_map else {},
		entry_order = if t446 ~= nil and t446.entry_order ~= nil then t446.entry_order else {},
		content_pools = if t446 ~= nil and t446.content_pools ~= nil then t446.content_pools else {},
		search_session_id = if t446 ~= nil and t446.search_session_id ~= nil then t446.search_session_id else ""
	}, t445))
end
function t445.encode(p269) -- line: 19655
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n179 = 0

	if p269.entry_map ~= nil and next(p269.entry_map) ~= nil then
		for v3358, v3359 in p269.entry_map do
			local buf97 = buffer.create(0)
			local v3361, v3362 = proto.writeTag(buf97, 0, 1, proto.wireTypes.lengthDelimited)
			local v3363, v3364 = proto.writeString(v3361, v3362, v3358)
			local v3365 = v3359:encode()
			local v3366, v3367 = proto.writeTag(v3363, v3364, 2, proto.wireTypes.lengthDelimited)
			local v3368, v3369 = proto.writeBuffer(v3366, v3367, v3365, buffer.len(v3365))
			local v3370, v3371 = proto.writeTag(buf, n179, 1, proto.wireTypes.lengthDelimited)

			buf, n179 = proto.writeBuffer(v3370, v3371, v3368, v3369)
		end
	end

	if p269.entry_order ~= nil and #p269.entry_order > 0 then
		for _, v3373 in p269.entry_order do
			local v3374, v3375 = proto.writeTag(buf, n179, 2, proto.wireTypes.lengthDelimited)

			buf, n179 = proto.writeString(v3374, v3375, v3373)
		end
	end

	if p269.content_pools ~= nil and next(p269.content_pools) ~= nil then
		for v3376, v3377 in p269.content_pools do
			local buf98 = buffer.create(0)
			local v3379, v3380 = proto.writeTag(buf98, 0, 1, proto.wireTypes.lengthDelimited)
			local v3381, v3382 = proto.writeString(v3379, v3380, v3376)
			local v3383 = v3377:encode()
			local v3384, v3385 = proto.writeTag(v3381, v3382, 2, proto.wireTypes.lengthDelimited)
			local v3386, v3387 = proto.writeBuffer(v3384, v3385, v3383, buffer.len(v3383))
			local v3388, v3389 = proto.writeTag(buf, n179, 3, proto.wireTypes.lengthDelimited)

			buf, n179 = proto.writeBuffer(v3388, v3389, v3386, v3387)
		end
	end

	if p269.search_session_id ~= nil and p269.search_session_id ~= "" then
		local v3390, v3391 = proto.writeTag(buf, n179, 4, proto.wireTypes.lengthDelimited)

		buf, n179 = proto.writeString(v3390, v3391, p269.search_session_id)
	end

	local buf99 = buffer.create(n179)

	buffer.copy(buf99, 0, buf, 0, n179)

	return buf99
end
function t445.decode(p270: buffer) -- line: 19704
	-- upvalues: t445 (copy), proto (copy), t1 (copy)
	local v3394 = t445.new()
	local n180 = 0

	while n180 < buffer.len(p270) do
		local v3396, v3397

		v3396, v3397, n180 = proto.readTag(p270, n180)

		if v3397 == proto.wireTypes.varint then
			local v3398

			v3398, n180 = proto.readVarInt(p270, n180)
		elseif v3397 == proto.wireTypes.lengthDelimited then
			if v3396 == 1 then
				local v3399

				v3399, n180 = proto.readBuffer(p270, n180)

				local v3400 = t1.SearchResultsFeedInputData_EntryMapEntry.decode(v3399)
				local v3401 = t1.FeedEntry.new()

				v3394.entry_map[v3400.key or ""] = v3400.value or v3401
			elseif v3396 == 2 then
				local v3402

				v3402, n180 = proto.readBuffer(p270, n180)
				table.insert(v3394.entry_order, buffer.tostring(v3402))
			elseif v3396 == 3 then
				local v3403

				v3403, n180 = proto.readBuffer(p270, n180)

				local v3404 = t1.SearchResultsFeedInputData_ContentPoolsEntry.decode(v3403)
				local v3405 = t1.ContentPool.new()

				v3394.content_pools[v3404.key or ""] = v3404.value or v3405
			elseif v3396 == 4 then
				local v3406

				v3406, n180 = proto.readBuffer(p270, n180)
				v3394.search_session_id = buffer.tostring(v3406)
			else
				local v3407, v3408 = proto.readVarInt(p270, n180)

				n180 = v3408 + v3407
			end
		elseif v3397 == proto.wireTypes.i32 then
			local v3409

			v3409, n180 = proto.readFixed32(p270, n180)
		elseif v3397 == proto.wireTypes.i64 then
			local v3410

			v3410, n180 = proto.readFixed64(p270, n180)
		else
			error("Unsupported wire type: " .. v3397)
		end
	end

	return v3394
end
function t445.jsonEncode(p271) -- line: 19776
	local t447 = {}

	if p271.entry_map ~= nil and next(p271.entry_map) ~= nil then
		local t448 = {}

		for v3414, v3415 in p271.entry_map do
			t448[v3414] = v3415:jsonEncode()
		end

		t447.entryMap = t448
	end

	if p271.entry_order ~= nil and #p271.entry_order > 0 then
		local t449 = {}

		for _, v3418 in p271.entry_order do
			table.insert(t449, v3418)
		end

		t447.entryOrder = t449
	end

	if p271.content_pools ~= nil and next(p271.content_pools) ~= nil then
		local t450 = {}

		for v3420, v3421 in p271.content_pools do
			t450[v3420] = v3421:jsonEncode()
		end

		t447.contentPools = t450
	end

	if p271.search_session_id ~= nil and p271.search_session_id ~= "" then
		t447.searchSessionId = p271.search_session_id
	end

	return t447
end
function t445.jsonDecode(t451: {[any]: any}) -- line: 19810
	-- upvalues: t445 (copy), t1 (copy)
	local v3423 = t445.new()

	if t451.entry_map ~= nil then
		local t452 = {}

		for v3425, v3426 in t451.entry_map do
			t452[v3425] = t1.FeedEntry.jsonDecode(v3426)
		end

		v3423.entry_map = t452
	end

	if t451.entryMap ~= nil then
		local t453 = {}

		for v3428, v3429 in t451.entryMap do
			t453[v3428] = t1.FeedEntry.jsonDecode(v3429)
		end

		v3423.entry_map = t453
	end

	if t451.entry_order ~= nil then
		local t454 = {}

		for _, v3432 in t451.entry_order do
			table.insert(t454, v3432)
		end

		v3423.entry_order = t454
	end

	if t451.entryOrder ~= nil then
		local t455 = {}

		for _, v3435 in t451.entryOrder do
			table.insert(t455, v3435)
		end

		v3423.entry_order = t455
	end

	if t451.content_pools ~= nil then
		local t456 = {}

		for v3437, v3438 in t451.content_pools do
			t456[v3437] = t1.ContentPool.jsonDecode(v3438)
		end

		v3423.content_pools = t456
	end

	if t451.contentPools ~= nil then
		local t457 = {}

		for v3440, v3441 in t451.contentPools do
			t457[v3440] = t1.ContentPool.jsonDecode(v3441)
		end

		v3423.content_pools = t457
	end

	if t451.search_session_id ~= nil then
		v3423.search_session_id = t451.search_session_id
	end

	if t451.searchSessionId ~= nil then
		v3423.search_session_id = t451.searchSessionId
	end

	return v3423
end

t445.descriptor = {
	name = "SearchResultsFeedInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.SearchResultsFeedInputData"
}
t1.SearchResultsFeedInputData = t445
typeRegistry.default:register(t1.SearchResultsFeedInputData)

local t458 = {}

t458.__index = t458

function t458.new(t459: {[any]: any}?) -- line: 19892
	-- upvalues: t458 (copy)
	return (setmetatable({
		key = if t459 ~= nil and t459.key ~= nil then t459.key else "",
		value = if t459 ~= nil and t459.value ~= nil then t459.value else nil
	}, t458))
end
function t458.encode(p272) -- line: 19901
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n181 = 0

	if p272.key ~= nil and p272.key ~= "" then
		local v3446, v3447 = proto.writeTag(buf, n181, 1, proto.wireTypes.lengthDelimited)

		buf, n181 = proto.writeString(v3446, v3447, p272.key)
	end

	if p272.value ~= nil then
		local v3448 = p272.value:encode()
		local v3449, v3450 = proto.writeTag(buf, n181, 2, proto.wireTypes.lengthDelimited)

		buf, n181 = proto.writeBuffer(v3449, v3450, v3448, buffer.len(v3448))
	end

	local buf100 = buffer.create(n181)

	buffer.copy(buf100, 0, buf, 0, n181)

	return buf100
end
function t458.decode(p273: buffer) -- line: 19923
	-- upvalues: t458 (copy), proto (copy), t1 (copy)
	local v3453 = t458.new()
	local n182 = 0

	while n182 < buffer.len(p273) do
		local v3455, v3456

		v3455, v3456, n182 = proto.readTag(p273, n182)

		if v3456 == proto.wireTypes.varint then
			local v3457

			v3457, n182 = proto.readVarInt(p273, n182)
		elseif v3456 == proto.wireTypes.lengthDelimited then
			if v3455 == 1 then
				local v3458

				v3458, n182 = proto.readBuffer(p273, n182)
				v3453.key = buffer.tostring(v3458)
			elseif v3455 == 2 then
				local v3459

				v3459, n182 = proto.readBuffer(p273, n182)
				v3453.value = t1.FeedEntry.decode(v3459)
			else
				local v3460, v3461 = proto.readVarInt(p273, n182)

				n182 = v3461 + v3460
			end
		elseif v3456 == proto.wireTypes.i32 then
			local v3462

			v3462, n182 = proto.readFixed32(p273, n182)
		elseif v3456 == proto.wireTypes.i64 then
			local v3463

			v3463, n182 = proto.readFixed64(p273, n182)
		else
			error("Unsupported wire type: " .. v3456)
		end
	end

	return v3453
end
function t458.jsonEncode(p274) -- line: 19973
	local t460 = {}

	if p274.key ~= nil and p274.key ~= "" then
		t460.key = p274.key
	end

	if p274.value ~= nil then
		t460.value = p274.value:jsonEncode()
	end

	return t460
end
function t458.jsonDecode(t461: {[any]: any}) -- line: 19989
	-- upvalues: t458 (copy), t1 (copy)
	local v3467 = t458.new()

	if t461.key ~= nil then
		v3467.key = t461.key
	end

	if t461.value ~= nil then
		v3467.value = t1.FeedEntry.jsonDecode(t461.value)
	end

	return v3467
end

t458.descriptor = {
	name = "SearchResultsFeedInputData_EntryMapEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryMapEntry"
}
t1.SearchResultsFeedInputData_EntryMapEntry = t458
typeRegistry.default:register(t1.SearchResultsFeedInputData_EntryMapEntry)

local t462 = {}

t462.__index = t462

function t462.new(t463: {[any]: any}?) -- line: 20019
	-- upvalues: t462 (copy)
	return (setmetatable({
		key = if t463 ~= nil and t463.key ~= nil then t463.key else "",
		value = if t463 ~= nil and t463.value ~= nil then t463.value else nil
	}, t462))
end
function t462.encode(p275) -- line: 20028
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n183 = 0

	if p275.key ~= nil and p275.key ~= "" then
		local v3472, v3473 = proto.writeTag(buf, n183, 1, proto.wireTypes.lengthDelimited)

		buf, n183 = proto.writeString(v3472, v3473, p275.key)
	end

	if p275.value ~= nil then
		local v3474 = p275.value:encode()
		local v3475, v3476 = proto.writeTag(buf, n183, 2, proto.wireTypes.lengthDelimited)

		buf, n183 = proto.writeBuffer(v3475, v3476, v3474, buffer.len(v3474))
	end

	local buf101 = buffer.create(n183)

	buffer.copy(buf101, 0, buf, 0, n183)

	return buf101
end
function t462.decode(p276: buffer) -- line: 20050
	-- upvalues: t462 (copy), proto (copy), t1 (copy)
	local v3479 = t462.new()
	local n184 = 0

	while n184 < buffer.len(p276) do
		local v3481, v3482

		v3481, v3482, n184 = proto.readTag(p276, n184)

		if v3482 == proto.wireTypes.varint then
			local v3483

			v3483, n184 = proto.readVarInt(p276, n184)
		elseif v3482 == proto.wireTypes.lengthDelimited then
			if v3481 == 1 then
				local v3484

				v3484, n184 = proto.readBuffer(p276, n184)
				v3479.key = buffer.tostring(v3484)
			elseif v3481 == 2 then
				local v3485

				v3485, n184 = proto.readBuffer(p276, n184)
				v3479.value = t1.ContentPool.decode(v3485)
			else
				local v3486, v3487 = proto.readVarInt(p276, n184)

				n184 = v3487 + v3486
			end
		elseif v3482 == proto.wireTypes.i32 then
			local v3488

			v3488, n184 = proto.readFixed32(p276, n184)
		elseif v3482 == proto.wireTypes.i64 then
			local v3489

			v3489, n184 = proto.readFixed64(p276, n184)
		else
			error("Unsupported wire type: " .. v3482)
		end
	end

	return v3479
end
function t462.jsonEncode(p277) -- line: 20100
	local t464 = {}

	if p277.key ~= nil and p277.key ~= "" then
		t464.key = p277.key
	end

	if p277.value ~= nil then
		t464.value = p277.value:jsonEncode()
	end

	return t464
end
function t462.jsonDecode(t465: {[any]: any}) -- line: 20116
	-- upvalues: t462 (copy), t1 (copy)
	local v3493 = t462.new()

	if t465.key ~= nil then
		v3493.key = t465.key
	end

	if t465.value ~= nil then
		v3493.value = t1.ContentPool.jsonDecode(t465.value)
	end

	return v3493
end

t462.descriptor = {
	name = "SearchResultsFeedInputData_ContentPoolsEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.ContentPoolsEntry"
}
t1.SearchResultsFeedInputData_ContentPoolsEntry = t462
typeRegistry.default:register(t1.SearchResultsFeedInputData_ContentPoolsEntry)

local t466 = {}

t466.__index = t466

function t466.new(t467: {[any]: any}?) -- line: 20146
	-- upvalues: t466 (copy)
	return (setmetatable({
		universe_id = if t467 ~= nil and t467.universe_id ~= nil then t467.universe_id else "",
		is_content_locked = t467 ~= nil and (t467.is_content_locked ~= nil and t467.is_content_locked)
	}, t466))
end
function t466.encode(p278) -- line: 20155
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n185 = 0

	if p278.universe_id ~= nil and p278.universe_id ~= "" then
		local v3498, v3499 = proto.writeTag(buf, n185, 1, proto.wireTypes.lengthDelimited)

		buf, n185 = proto.writeString(v3498, v3499, p278.universe_id)
	end

	if p278.is_content_locked then
		local v3500, v3501 = proto.writeTag(buf, n185, 2, proto.wireTypes.varint)

		buf, n185 = proto.writeVarInt(v3500, v3501, not p278.is_content_locked and 0 or 1)
	end

	local buf102 = buffer.create(n185)

	buffer.copy(buf102, 0, buf, 0, n185)

	return buf102
end
function t466.decode(p279: buffer) -- line: 20174
	-- upvalues: t466 (copy), proto (copy)
	local v3504 = t466.new()
	local n186 = 0

	while n186 < buffer.len(p279) do
		local v3506, v3507

		v3506, v3507, n186 = proto.readTag(p279, n186)

		if v3507 == proto.wireTypes.varint then
			if v3506 == 2 then
				local v3508

				v3508, n186 = proto.readVarInt(p279, n186)
				v3504.is_content_locked = v3508 ~= 0
			else
				local v3509

				v3509, n186 = proto.readVarInt(p279, n186)
			end
		elseif v3507 == proto.wireTypes.lengthDelimited then
			if v3506 == 1 then
				local v3510

				v3510, n186 = proto.readBuffer(p279, n186)
				v3504.universe_id = buffer.tostring(v3510)
			else
				local v3511, v3512 = proto.readVarInt(p279, n186)

				n186 = v3512 + v3511
			end
		elseif v3507 == proto.wireTypes.i32 then
			local v3513

			v3513, n186 = proto.readFixed32(p279, n186)
		elseif v3507 == proto.wireTypes.i64 then
			local v3514

			v3514, n186 = proto.readFixed64(p279, n186)
		else
			error("Unsupported wire type: " .. v3507)
		end
	end

	return v3504
end
function t466.jsonEncode(p280) -- line: 20222
	local t468 = {}

	if p280.universe_id ~= nil and p280.universe_id ~= "" then
		t468.universeId = p280.universe_id
	end

	if p280.is_content_locked then
		t468.isContentLocked = p280.is_content_locked
	end

	return t468
end
function t466.jsonDecode(t469: {[any]: any}) -- line: 20236
	-- upvalues: t466 (copy)
	local v3518 = t466.new()

	if t469.universe_id ~= nil then
		v3518.universe_id = t469.universe_id
	end

	if t469.universeId ~= nil then
		v3518.universe_id = t469.universeId
	end

	if t469.is_content_locked ~= nil then
		v3518.is_content_locked = t469.is_content_locked
	end

	if t469.isContentLocked ~= nil then
		v3518.is_content_locked = t469.isContentLocked
	end

	return v3518
end

t466.descriptor = {
	name = "ExperienceEmphasisTileInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceEmphasisTileInputData"
}
t1.ExperienceEmphasisTileInputData = t466
typeRegistry.default:register(t1.ExperienceEmphasisTileInputData)

local t470 = {}

t470.__index = t470

function t470.new(t471: {[any]: any}?) -- line: 20272
	-- upvalues: t470 (copy)
	return (setmetatable({
		overview_rich_text = if t471 ~= nil and t471.overview_rich_text ~= nil then t471.overview_rich_text else "",
		result_entry = if t471 ~= nil and t471.result_entry ~= nil then t471.result_entry else nil,
		follow_up_queries = if t471 ~= nil and t471.follow_up_queries ~= nil then t471.follow_up_queries else {},
		show_loading = t471 ~= nil and (t471.show_loading ~= nil and t471.show_loading),
		title = if t471 ~= nil and t471.title ~= nil then t471.title else "",
		search_query = if t471 ~= nil and t471.search_query ~= nil then t471.search_query else "",
		universe_ids = if t471 ~= nil and t471.universe_ids ~= nil then t471.universe_ids else ""
	}, t470))
end
function t470.encode(p281) -- line: 20286
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n187 = 0

	if p281.overview_rich_text ~= nil and p281.overview_rich_text ~= "" then
		local v3523, v3524 = proto.writeTag(buf, n187, 1, proto.wireTypes.lengthDelimited)

		buf, n187 = proto.writeString(v3523, v3524, p281.overview_rich_text)
	end

	if p281.result_entry ~= nil then
		local v3525 = p281.result_entry:encode()
		local v3526, v3527 = proto.writeTag(buf, n187, 2, proto.wireTypes.lengthDelimited)

		buf, n187 = proto.writeBuffer(v3526, v3527, v3525, buffer.len(v3525))
	end

	if p281.follow_up_queries ~= nil and #p281.follow_up_queries > 0 then
		for _, v3529 in p281.follow_up_queries do
			local v3530, v3531 = proto.writeTag(buf, n187, 3, proto.wireTypes.lengthDelimited)

			buf, n187 = proto.writeString(v3530, v3531, v3529)
		end
	end

	if p281.show_loading then
		local v3532, v3533 = proto.writeTag(buf, n187, 4, proto.wireTypes.varint)

		buf, n187 = proto.writeVarInt(v3532, v3533, not p281.show_loading and 0 or 1)
	end

	if p281.title ~= nil and p281.title ~= "" then
		local v3534, v3535 = proto.writeTag(buf, n187, 5, proto.wireTypes.lengthDelimited)

		buf, n187 = proto.writeString(v3534, v3535, p281.title)
	end

	if p281.search_query ~= nil and p281.search_query ~= "" then
		local v3536, v3537 = proto.writeTag(buf, n187, 6, proto.wireTypes.lengthDelimited)

		buf, n187 = proto.writeString(v3536, v3537, p281.search_query)
	end

	if p281.universe_ids ~= nil and p281.universe_ids ~= "" then
		local v3538, v3539 = proto.writeTag(buf, n187, 8, proto.wireTypes.lengthDelimited)

		buf, n187 = proto.writeString(v3538, v3539, p281.universe_ids)
	end

	local buf103 = buffer.create(n187)

	buffer.copy(buf103, 0, buf, 0, n187)

	return buf103
end
function t470.decode(p282: buffer) -- line: 20333
	-- upvalues: t470 (copy), proto (copy), t1 (copy)
	local v3542 = t470.new()
	local n188 = 0

	while n188 < buffer.len(p282) do
		local v3544, v3545

		v3544, v3545, n188 = proto.readTag(p282, n188)

		if v3545 == proto.wireTypes.varint then
			if v3544 == 4 then
				local v3546

				v3546, n188 = proto.readVarInt(p282, n188)
				v3542.show_loading = v3546 ~= 0
			else
				local v3547

				v3547, n188 = proto.readVarInt(p282, n188)
			end
		elseif v3545 == proto.wireTypes.lengthDelimited then
			if v3544 == 1 then
				local v3548

				v3548, n188 = proto.readBuffer(p282, n188)
				v3542.overview_rich_text = buffer.tostring(v3548)
			elseif v3544 == 2 then
				local v3549

				v3549, n188 = proto.readBuffer(p282, n188)
				v3542.result_entry = t1.FeedEntry.decode(v3549)
			elseif v3544 == 3 then
				local v3550

				v3550, n188 = proto.readBuffer(p282, n188)
				table.insert(v3542.follow_up_queries, buffer.tostring(v3550))
			elseif v3544 == 5 then
				local v3551

				v3551, n188 = proto.readBuffer(p282, n188)
				v3542.title = buffer.tostring(v3551)
			elseif v3544 == 6 then
				local v3552

				v3552, n188 = proto.readBuffer(p282, n188)
				v3542.search_query = buffer.tostring(v3552)
			elseif v3544 == 8 then
				local v3553

				v3553, n188 = proto.readBuffer(p282, n188)
				v3542.universe_ids = buffer.tostring(v3553)
			else
				local v3554, v3555 = proto.readVarInt(p282, n188)

				n188 = v3555 + v3554
			end
		elseif v3545 == proto.wireTypes.i32 then
			local v3556

			v3556, n188 = proto.readFixed32(p282, n188)
		elseif v3545 == proto.wireTypes.i64 then
			local v3557

			v3557, n188 = proto.readFixed64(p282, n188)
		else
			error("Unsupported wire type: " .. v3545)
		end
	end

	return v3542
end
function t470.jsonEncode(p283) -- line: 20406
	local t472 = {}

	if p283.overview_rich_text ~= nil and p283.overview_rich_text ~= "" then
		t472.overviewRichText = p283.overview_rich_text
	end

	if p283.result_entry ~= nil then
		t472.resultEntry = p283.result_entry:jsonEncode()
	end

	if p283.follow_up_queries ~= nil and #p283.follow_up_queries > 0 then
		local t473 = {}

		for _, v3562 in p283.follow_up_queries do
			table.insert(t473, v3562)
		end

		t472.followUpQueries = t473
	end

	if p283.show_loading then
		t472.showLoading = p283.show_loading
	end

	if p283.title ~= nil and p283.title ~= "" then
		t472.title = p283.title
	end

	if p283.search_query ~= nil and p283.search_query ~= "" then
		t472.searchQuery = p283.search_query
	end

	if p283.universe_ids ~= nil and p283.universe_ids ~= "" then
		t472.universeIds = p283.universe_ids
	end

	return t472
end
function t470.jsonDecode(t474: {[any]: any}) -- line: 20444
	-- upvalues: t470 (copy), t1 (copy)
	local v3564 = t470.new()

	if t474.overview_rich_text ~= nil then
		v3564.overview_rich_text = t474.overview_rich_text
	end

	if t474.overviewRichText ~= nil then
		v3564.overview_rich_text = t474.overviewRichText
	end

	if t474.result_entry ~= nil then
		v3564.result_entry = t1.FeedEntry.jsonDecode(t474.result_entry)
	end

	if t474.resultEntry ~= nil then
		v3564.result_entry = t1.FeedEntry.jsonDecode(t474.resultEntry)
	end

	if t474.follow_up_queries ~= nil then
		local t475 = {}

		for _, v3567 in t474.follow_up_queries do
			table.insert(t475, v3567)
		end

		v3564.follow_up_queries = t475
	end

	if t474.followUpQueries ~= nil then
		local t476 = {}

		for _, v3570 in t474.followUpQueries do
			table.insert(t476, v3570)
		end

		v3564.follow_up_queries = t476
	end

	if t474.show_loading ~= nil then
		v3564.show_loading = t474.show_loading
	end

	if t474.showLoading ~= nil then
		v3564.show_loading = t474.showLoading
	end

	if t474.title ~= nil then
		v3564.title = t474.title
	end

	if t474.search_query ~= nil then
		v3564.search_query = t474.search_query
	end

	if t474.searchQuery ~= nil then
		v3564.search_query = t474.searchQuery
	end

	if t474.universe_ids ~= nil then
		v3564.universe_ids = t474.universe_ids
	end

	if t474.universeIds ~= nil then
		v3564.universe_ids = t474.universeIds
	end

	return v3564
end

t470.descriptor = {
	name = "PowerSearchAIOverviewInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.PowerSearchAIOverviewInputData"
}
t1.PowerSearchAIOverviewInputData = t470
typeRegistry.default:register(t1.PowerSearchAIOverviewInputData)

local t477 = {}

t477.__index = t477

function t477.new(t478: {[any]: any}?) -- line: 20526
	-- upvalues: t477 (copy)
	return (setmetatable({
		title = if t478 ~= nil and t478.title ~= nil then t478.title else "",
		user_items = if t478 ~= nil and t478.user_items ~= nil then t478.user_items else {},
		max_visible_rows = if t478 ~= nil and t478.max_visible_rows ~= nil then t478.max_visible_rows else 0
	}, t477))
end
function t477.encode(p284) -- line: 20534
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n189 = 0

	if p284.title ~= nil and p284.title ~= "" then
		local v3575, v3576 = proto.writeTag(buf, n189, 1, proto.wireTypes.lengthDelimited)

		buf, n189 = proto.writeString(v3575, v3576, p284.title)
	end

	if p284.user_items ~= nil and #p284.user_items > 0 then
		for _, v3578 in p284.user_items do
			local v3579 = v3578:encode()
			local v3580, v3581 = proto.writeTag(buf, n189, 2, proto.wireTypes.lengthDelimited)

			buf, n189 = proto.writeBuffer(v3580, v3581, v3579, buffer.len(v3579))
		end
	end

	if p284.max_visible_rows ~= nil and p284.max_visible_rows ~= 0 then
		local v3582, v3583 = proto.writeTag(buf, n189, 3, proto.wireTypes.varint)

		buf, n189 = proto.writeVarInt(v3582, v3583, p284.max_visible_rows)
	end

	local buf104 = buffer.create(n189)

	buffer.copy(buf104, 0, buf, 0, n189)

	return buf104
end
function t477.decode(p285: buffer) -- line: 20561
	-- upvalues: t477 (copy), proto (copy), t1 (copy)
	local v3586 = t477.new()
	local n190 = 0

	while n190 < buffer.len(p285) do
		local v3588, v3589

		v3588, v3589, n190 = proto.readTag(p285, n190)

		if v3589 == proto.wireTypes.varint then
			if v3588 == 3 then
				local v3590

				v3590, n190 = proto.readVarIntI32(p285, n190)
				v3586.max_visible_rows = v3590
			else
				local v3591

				v3591, n190 = proto.readVarInt(p285, n190)
			end
		elseif v3589 == proto.wireTypes.lengthDelimited then
			if v3588 == 1 then
				local v3592

				v3592, n190 = proto.readBuffer(p285, n190)
				v3586.title = buffer.tostring(v3592)
			elseif v3588 == 2 then
				local v3593

				v3593, n190 = proto.readBuffer(p285, n190)
				table.insert(v3586.user_items, t1.UserListInputData_UserItem.decode(v3593))
			else
				local v3594, v3595 = proto.readVarInt(p285, n190)

				n190 = v3595 + v3594
			end
		elseif v3589 == proto.wireTypes.i32 then
			local v3596

			v3596, n190 = proto.readFixed32(p285, n190)
		elseif v3589 == proto.wireTypes.i64 then
			local v3597

			v3597, n190 = proto.readFixed64(p285, n190)
		else
			error("Unsupported wire type: " .. v3589)
		end
	end

	return v3586
end
function t477.jsonEncode(p286) -- line: 20614
	local t479 = {}

	if p286.title ~= nil and p286.title ~= "" then
		t479.title = p286.title
	end

	if p286.user_items ~= nil and #p286.user_items > 0 then
		local t480 = {}

		for _, v3602 in p286.user_items do
			table.insert(t480, v3602:jsonEncode())
		end

		t479.userItems = t480
	end

	if p286.max_visible_rows ~= nil and p286.max_visible_rows ~= 0 then
		t479.maxVisibleRows = p286.max_visible_rows
	end

	return t479
end
function t477.jsonDecode(t481: {[any]: any}) -- line: 20636
	-- upvalues: t477 (copy), t1 (copy)
	local v3604 = t477.new()

	if t481.title ~= nil then
		v3604.title = t481.title
	end

	if t481.user_items ~= nil then
		local t482 = {}

		for _, v3607 in t481.user_items do
			table.insert(t482, t1.UserListInputData_UserItem.jsonDecode(v3607))
		end

		v3604.user_items = t482
	end

	if t481.userItems ~= nil then
		local t483 = {}

		for _, v3610 in t481.userItems do
			table.insert(t483, t1.UserListInputData_UserItem.jsonDecode(v3610))
		end

		v3604.user_items = t483
	end

	if t481.max_visible_rows ~= nil then
		v3604.max_visible_rows = t481.max_visible_rows
	end

	if t481.maxVisibleRows ~= nil then
		v3604.max_visible_rows = t481.maxVisibleRows
	end

	return v3604
end

t477.descriptor = {
	name = "UserListInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UserListInputData"
}
t1.UserListInputData = t477
typeRegistry.default:register(t1.UserListInputData)

local t484 = {}

t484.__index = t484

function t484.new(t485: {[any]: any}?) -- line: 20686
	-- upvalues: t484 (copy)
	return (setmetatable({
		user_id = if t485 ~= nil and t485.user_id ~= nil then t485.user_id else ""
	}, t484))
end
function t484.encode(p287) -- line: 20694
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n191 = 0

	if p287.user_id ~= nil and p287.user_id ~= "" then
		local v3615, v3616 = proto.writeTag(buf, n191, 1, proto.wireTypes.lengthDelimited)

		buf, n191 = proto.writeString(v3615, v3616, p287.user_id)
	end

	local buf105 = buffer.create(n191)

	buffer.copy(buf105, 0, buf, 0, n191)

	return buf105
end
function t484.decode(p288: buffer) -- line: 20708
	-- upvalues: t484 (copy), proto (copy)
	local v3619 = t484.new()
	local n192 = 0

	while n192 < buffer.len(p288) do
		local v3621, v3622

		v3621, v3622, n192 = proto.readTag(p288, n192)

		if v3622 == proto.wireTypes.varint then
			local v3623

			v3623, n192 = proto.readVarInt(p288, n192)
		elseif v3622 == proto.wireTypes.lengthDelimited then
			if v3621 == 1 then
				local v3624

				v3624, n192 = proto.readBuffer(p288, n192)
				v3619.user_id = buffer.tostring(v3624)
			else
				local v3625, v3626 = proto.readVarInt(p288, n192)

				n192 = v3626 + v3625
			end
		elseif v3622 == proto.wireTypes.i32 then
			local v3627

			v3627, n192 = proto.readFixed32(p288, n192)
		elseif v3622 == proto.wireTypes.i64 then
			local v3628

			v3628, n192 = proto.readFixed64(p288, n192)
		else
			error("Unsupported wire type: " .. v3622)
		end
	end

	return v3619
end
function t484.jsonEncode(p289) -- line: 20751
	local t486 = {}

	if p289.user_id ~= nil and p289.user_id ~= "" then
		t486.userId = p289.user_id
	end

	return t486
end
function t484.jsonDecode(t487: {[any]: any}) -- line: 20761
	-- upvalues: t484 (copy)
	local v3632 = t484.new()

	if t487.user_id ~= nil then
		v3632.user_id = t487.user_id
	end

	if t487.userId ~= nil then
		v3632.user_id = t487.userId
	end

	return v3632
end

t484.descriptor = {
	name = "UserListInputData_UserItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.UserItem"
}
t1.UserListInputData_UserItem = t484
typeRegistry.default:register(t1.UserListInputData_UserItem)

local t488 = {}

t488.__index = t488

function t488.new(t489: {[any]: any}?) -- line: 20789
	-- upvalues: t488 (copy)
	return (setmetatable({
		title = if t489 ~= nil and t489.title ~= nil then t489.title else "",
		items = if t489 ~= nil and t489.items ~= nil then t489.items else {},
		max_visible_rows = if t489 ~= nil and t489.max_visible_rows ~= nil then t489.max_visible_rows else 0
	}, t488))
end
function t488.encode(p290) -- line: 20797
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n193 = 0

	if p290.title ~= nil and p290.title ~= "" then
		local v3637, v3638 = proto.writeTag(buf, n193, 1, proto.wireTypes.lengthDelimited)

		buf, n193 = proto.writeString(v3637, v3638, p290.title)
	end

	if p290.items ~= nil and #p290.items > 0 then
		for _, v3640 in p290.items do
			local v3641 = v3640:encode()
			local v3642, v3643 = proto.writeTag(buf, n193, 2, proto.wireTypes.lengthDelimited)

			buf, n193 = proto.writeBuffer(v3642, v3643, v3641, buffer.len(v3641))
		end
	end

	if p290.max_visible_rows ~= nil and p290.max_visible_rows ~= 0 then
		local v3644, v3645 = proto.writeTag(buf, n193, 3, proto.wireTypes.varint)

		buf, n193 = proto.writeVarInt(v3644, v3645, p290.max_visible_rows)
	end

	local buf106 = buffer.create(n193)

	buffer.copy(buf106, 0, buf, 0, n193)

	return buf106
end
function t488.decode(p291: buffer) -- line: 20824
	-- upvalues: t488 (copy), proto (copy), t1 (copy)
	local v3648 = t488.new()
	local n194 = 0

	while n194 < buffer.len(p291) do
		local v3650, v3651

		v3650, v3651, n194 = proto.readTag(p291, n194)

		if v3651 == proto.wireTypes.varint then
			if v3650 == 3 then
				local v3652

				v3652, n194 = proto.readVarIntI32(p291, n194)
				v3648.max_visible_rows = v3652
			else
				local v3653

				v3653, n194 = proto.readVarInt(p291, n194)
			end
		elseif v3651 == proto.wireTypes.lengthDelimited then
			if v3650 == 1 then
				local v3654

				v3654, n194 = proto.readBuffer(p291, n194)
				v3648.title = buffer.tostring(v3654)
			elseif v3650 == 2 then
				local v3655

				v3655, n194 = proto.readBuffer(p291, n194)
				table.insert(v3648.items, t1.CatalogItemListInputData_CatalogItem.decode(v3655))
			else
				local v3656, v3657 = proto.readVarInt(p291, n194)

				n194 = v3657 + v3656
			end
		elseif v3651 == proto.wireTypes.i32 then
			local v3658

			v3658, n194 = proto.readFixed32(p291, n194)
		elseif v3651 == proto.wireTypes.i64 then
			local v3659

			v3659, n194 = proto.readFixed64(p291, n194)
		else
			error("Unsupported wire type: " .. v3651)
		end
	end

	return v3648
end
function t488.jsonEncode(p292) -- line: 20877
	local t490 = {}

	if p292.title ~= nil and p292.title ~= "" then
		t490.title = p292.title
	end

	if p292.items ~= nil and #p292.items > 0 then
		local t491 = {}

		for _, v3664 in p292.items do
			table.insert(t491, v3664:jsonEncode())
		end

		t490.items = t491
	end

	if p292.max_visible_rows ~= nil and p292.max_visible_rows ~= 0 then
		t490.maxVisibleRows = p292.max_visible_rows
	end

	return t490
end
function t488.jsonDecode(t492: {[any]: any}) -- line: 20899
	-- upvalues: t488 (copy), t1 (copy)
	local v3666 = t488.new()

	if t492.title ~= nil then
		v3666.title = t492.title
	end

	if t492.items ~= nil then
		local t493 = {}

		for _, v3669 in t492.items do
			table.insert(t493, t1.CatalogItemListInputData_CatalogItem.jsonDecode(v3669))
		end

		v3666.items = t493
	end

	if t492.max_visible_rows ~= nil then
		v3666.max_visible_rows = t492.max_visible_rows
	end

	if t492.maxVisibleRows ~= nil then
		v3666.max_visible_rows = t492.maxVisibleRows
	end

	return v3666
end

t488.descriptor = {
	name = "CatalogItemListInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CatalogItemListInputData"
}
t1.CatalogItemListInputData = t488
typeRegistry.default:register(t1.CatalogItemListInputData)

local t494 = {}

t494.__index = t494

function t494.new(t495: {[any]: any}?) -- line: 20940
	-- upvalues: t494 (copy)
	return (setmetatable({
		item_id = if t495 ~= nil and t495.item_id ~= nil then t495.item_id else "",
		item_type = if t495 ~= nil and t495.item_type ~= nil then t495.item_type else ""
	}, t494))
end
function t494.encode(p293) -- line: 20949
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n195 = 0

	if p293.item_id ~= nil and p293.item_id ~= "" then
		local v3674, v3675 = proto.writeTag(buf, n195, 1, proto.wireTypes.lengthDelimited)

		buf, n195 = proto.writeString(v3674, v3675, p293.item_id)
	end

	if p293.item_type ~= nil and p293.item_type ~= "" then
		local v3676, v3677 = proto.writeTag(buf, n195, 2, proto.wireTypes.lengthDelimited)

		buf, n195 = proto.writeString(v3676, v3677, p293.item_type)
	end

	local buf107 = buffer.create(n195)

	buffer.copy(buf107, 0, buf, 0, n195)

	return buf107
end
function t494.decode(p294: buffer) -- line: 20968
	-- upvalues: t494 (copy), proto (copy)
	local v3680 = t494.new()
	local n196 = 0

	while n196 < buffer.len(p294) do
		local v3682, v3683

		v3682, v3683, n196 = proto.readTag(p294, n196)

		if v3683 == proto.wireTypes.varint then
			local v3684

			v3684, n196 = proto.readVarInt(p294, n196)
		elseif v3683 == proto.wireTypes.lengthDelimited then
			if v3682 == 1 then
				local v3685

				v3685, n196 = proto.readBuffer(p294, n196)
				v3680.item_id = buffer.tostring(v3685)
			elseif v3682 == 2 then
				local v3686

				v3686, n196 = proto.readBuffer(p294, n196)
				v3680.item_type = buffer.tostring(v3686)
			else
				local v3687, v3688 = proto.readVarInt(p294, n196)

				n196 = v3688 + v3687
			end
		elseif v3683 == proto.wireTypes.i32 then
			local v3689

			v3689, n196 = proto.readFixed32(p294, n196)
		elseif v3683 == proto.wireTypes.i64 then
			local v3690

			v3690, n196 = proto.readFixed64(p294, n196)
		else
			error("Unsupported wire type: " .. v3683)
		end
	end

	return v3680
end
function t494.jsonEncode(p295) -- line: 21016
	local t496 = {}

	if p295.item_id ~= nil and p295.item_id ~= "" then
		t496.itemId = p295.item_id
	end

	if p295.item_type ~= nil and p295.item_type ~= "" then
		t496.itemType = p295.item_type
	end

	return t496
end
function t494.jsonDecode(t497: {[any]: any}) -- line: 21030
	-- upvalues: t494 (copy)
	local v3694 = t494.new()

	if t497.item_id ~= nil then
		v3694.item_id = t497.item_id
	end

	if t497.itemId ~= nil then
		v3694.item_id = t497.itemId
	end

	if t497.item_type ~= nil then
		v3694.item_type = t497.item_type
	end

	if t497.itemType ~= nil then
		v3694.item_type = t497.itemType
	end

	return v3694
end

t494.descriptor = {
	name = "CatalogItemListInputData_CatalogItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.CatalogItem"
}
t1.CatalogItemListInputData_CatalogItem = t494
typeRegistry.default:register(t1.CatalogItemListInputData_CatalogItem)

local t498 = {}

t498.__index = t498

function t498.new(t499: {[any]: any}?) -- line: 21068
	-- upvalues: t498 (copy)
	return (setmetatable({
		universe_id = if t499 ~= nil and t499.universe_id ~= nil then t499.universe_id else ""
	}, t498))
end
function t498.encode(p296) -- line: 21076
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n197 = 0

	if p296.universe_id ~= nil and p296.universe_id ~= "" then
		local v3699, v3700 = proto.writeTag(buf, n197, 1, proto.wireTypes.lengthDelimited)

		buf, n197 = proto.writeString(v3699, v3700, p296.universe_id)
	end

	local buf108 = buffer.create(n197)

	buffer.copy(buf108, 0, buf, 0, n197)

	return buf108
end
function t498.decode(p297: buffer) -- line: 21090
	-- upvalues: t498 (copy), proto (copy)
	local v3703 = t498.new()
	local n198 = 0

	while n198 < buffer.len(p297) do
		local v3705, v3706

		v3705, v3706, n198 = proto.readTag(p297, n198)

		if v3706 == proto.wireTypes.varint then
			local v3707

			v3707, n198 = proto.readVarInt(p297, n198)
		elseif v3706 == proto.wireTypes.lengthDelimited then
			if v3705 == 1 then
				local v3708

				v3708, n198 = proto.readBuffer(p297, n198)
				v3703.universe_id = buffer.tostring(v3708)
			else
				local v3709, v3710 = proto.readVarInt(p297, n198)

				n198 = v3710 + v3709
			end
		elseif v3706 == proto.wireTypes.i32 then
			local v3711

			v3711, n198 = proto.readFixed32(p297, n198)
		elseif v3706 == proto.wireTypes.i64 then
			local v3712

			v3712, n198 = proto.readFixed64(p297, n198)
		else
			error("Unsupported wire type: " .. v3706)
		end
	end

	return v3703
end
function t498.jsonEncode(p298) -- line: 21133
	local t500 = {}

	if p298.universe_id ~= nil and p298.universe_id ~= "" then
		t500.universeId = p298.universe_id
	end

	return t500
end
function t498.jsonDecode(t501: {[any]: any}) -- line: 21143
	-- upvalues: t498 (copy)
	local v3716 = t498.new()

	if t501.universe_id ~= nil then
		v3716.universe_id = t501.universe_id
	end

	if t501.universeId ~= nil then
		v3716.universe_id = t501.universeId
	end

	return v3716
end

t498.descriptor = {
	name = "ExperienceGuidelinesDialogInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceGuidelinesDialogInputData"
}
t1.ExperienceGuidelinesDialogInputData = t498
typeRegistry.default:register(t1.ExperienceGuidelinesDialogInputData)

local t502 = {}

t502.__index = t502

function t502.new(t503: {[any]: any}?) -- line: 21173
	-- upvalues: t502 (copy)
	return (setmetatable({
		title = if t503 ~= nil and t503.title ~= nil then t503.title else "",
		subtitle = if t503 ~= nil and t503.subtitle ~= nil then t503.subtitle else "",
		moment_items = if t503 ~= nil and t503.moment_items ~= nil then t503.moment_items else {}
	}, t502))
end
function t502.encode(p299) -- line: 21181
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n199 = 0

	if p299.title ~= nil and p299.title ~= "" then
		local v3721, v3722 = proto.writeTag(buf, n199, 1, proto.wireTypes.lengthDelimited)

		buf, n199 = proto.writeString(v3721, v3722, p299.title)
	end

	if p299.subtitle ~= nil and p299.subtitle ~= "" then
		local v3723, v3724 = proto.writeTag(buf, n199, 2, proto.wireTypes.lengthDelimited)

		buf, n199 = proto.writeString(v3723, v3724, p299.subtitle)
	end

	if p299.moment_items ~= nil and #p299.moment_items > 0 then
		for _, v3726 in p299.moment_items do
			local v3727 = v3726:encode()
			local v3728, v3729 = proto.writeTag(buf, n199, 3, proto.wireTypes.lengthDelimited)

			buf, n199 = proto.writeBuffer(v3728, v3729, v3727, buffer.len(v3727))
		end
	end

	local buf109 = buffer.create(n199)

	buffer.copy(buf109, 0, buf, 0, n199)

	return buf109
end
function t502.decode(p300: buffer) -- line: 21208
	-- upvalues: t502 (copy), proto (copy), t1 (copy)
	local v3732 = t502.new()
	local n200 = 0

	while n200 < buffer.len(p300) do
		local v3734, v3735

		v3734, v3735, n200 = proto.readTag(p300, n200)

		if v3735 == proto.wireTypes.varint then
			local v3736

			v3736, n200 = proto.readVarInt(p300, n200)
		elseif v3735 == proto.wireTypes.lengthDelimited then
			if v3734 == 1 then
				local v3737

				v3737, n200 = proto.readBuffer(p300, n200)
				v3732.title = buffer.tostring(v3737)
			elseif v3734 == 2 then
				local v3738

				v3738, n200 = proto.readBuffer(p300, n200)
				v3732.subtitle = buffer.tostring(v3738)
			elseif v3734 == 3 then
				local v3739

				v3739, n200 = proto.readBuffer(p300, n200)
				table.insert(v3732.moment_items, t1.MomentsCarouselInputData_MomentItem.decode(v3739))
			else
				local v3740, v3741 = proto.readVarInt(p300, n200)

				n200 = v3741 + v3740
			end
		elseif v3735 == proto.wireTypes.i32 then
			local v3742

			v3742, n200 = proto.readFixed32(p300, n200)
		elseif v3735 == proto.wireTypes.i64 then
			local v3743

			v3743, n200 = proto.readFixed64(p300, n200)
		else
			error("Unsupported wire type: " .. v3735)
		end
	end

	return v3732
end
function t502.jsonEncode(p301) -- line: 21261
	local t504 = {}

	if p301.title ~= nil and p301.title ~= "" then
		t504.title = p301.title
	end

	if p301.subtitle ~= nil and p301.subtitle ~= "" then
		t504.subtitle = p301.subtitle
	end

	if p301.moment_items ~= nil and #p301.moment_items > 0 then
		local t505 = {}

		for _, v3748 in p301.moment_items do
			table.insert(t505, v3748:jsonEncode())
		end

		t504.momentItems = t505
	end

	return t504
end
function t502.jsonDecode(t506: {[any]: any}) -- line: 21283
	-- upvalues: t502 (copy), t1 (copy)
	local v3750 = t502.new()

	if t506.title ~= nil then
		v3750.title = t506.title
	end

	if t506.subtitle ~= nil then
		v3750.subtitle = t506.subtitle
	end

	if t506.moment_items ~= nil then
		local t507 = {}

		for _, v3753 in t506.moment_items do
			table.insert(t507, t1.MomentsCarouselInputData_MomentItem.jsonDecode(v3753))
		end

		v3750.moment_items = t507
	end

	if t506.momentItems ~= nil then
		local t508 = {}

		for _, v3756 in t506.momentItems do
			table.insert(t508, t1.MomentsCarouselInputData_MomentItem.jsonDecode(v3756))
		end

		v3750.moment_items = t508
	end

	return v3750
end

t502.descriptor = {
	name = "MomentsCarouselInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.MomentsCarouselInputData"
}
t1.MomentsCarouselInputData = t502
typeRegistry.default:register(t1.MomentsCarouselInputData)

local t509 = {}

t509.__index = t509

function t509.new(t510: {[any]: any}?) -- line: 21329
	-- upvalues: t509 (copy)
	return (setmetatable({
		moment_id = if t510 ~= nil and t510.moment_id ~= nil then t510.moment_id else "",
		video_asset_id = if t510 ~= nil and t510.video_asset_id ~= nil then t510.video_asset_id else "",
		target_universe_id = if t510 ~= nil and t510.target_universe_id ~= nil then t510.target_universe_id else "",
		target_place_id = if t510 ~= nil and t510.target_place_id ~= nil then t510.target_place_id else "",
		feed_item_id = if t510 ~= nil and t510.feed_item_id ~= nil then t510.feed_item_id else "",
		capture_universe_id = if t510 ~= nil and t510.capture_universe_id ~= nil then t510.capture_universe_id else ""
	}, t509))
end
function t509.encode(p302) -- line: 21344
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n201 = 0

	if p302.moment_id ~= nil and p302.moment_id ~= "" then
		local v3761, v3762 = proto.writeTag(buf, n201, 1, proto.wireTypes.lengthDelimited)

		buf, n201 = proto.writeString(v3761, v3762, p302.moment_id)
	end

	if p302.video_asset_id ~= nil and p302.video_asset_id ~= "" then
		local v3763, v3764 = proto.writeTag(buf, n201, 2, proto.wireTypes.lengthDelimited)

		buf, n201 = proto.writeString(v3763, v3764, p302.video_asset_id)
	end

	if p302.target_universe_id ~= nil and p302.target_universe_id ~= "" then
		local v3765, v3766 = proto.writeTag(buf, n201, 3, proto.wireTypes.lengthDelimited)

		buf, n201 = proto.writeString(v3765, v3766, p302.target_universe_id)
	end

	if p302.target_place_id ~= nil and p302.target_place_id ~= "" then
		local v3767, v3768 = proto.writeTag(buf, n201, 4, proto.wireTypes.lengthDelimited)

		buf, n201 = proto.writeString(v3767, v3768, p302.target_place_id)
	end

	if p302.feed_item_id ~= nil and p302.feed_item_id ~= "" then
		local v3769, v3770 = proto.writeTag(buf, n201, 5, proto.wireTypes.lengthDelimited)

		buf, n201 = proto.writeString(v3769, v3770, p302.feed_item_id)
	end

	if p302.capture_universe_id ~= nil and p302.capture_universe_id ~= "" then
		local v3771, v3772 = proto.writeTag(buf, n201, 6, proto.wireTypes.lengthDelimited)

		buf, n201 = proto.writeString(v3771, v3772, p302.capture_universe_id)
	end

	local buf110 = buffer.create(n201)

	buffer.copy(buf110, 0, buf, 0, n201)

	return buf110
end
function t509.decode(p303: buffer) -- line: 21383
	-- upvalues: t509 (copy), proto (copy)
	local v3775 = t509.new()
	local n202 = 0

	while n202 < buffer.len(p303) do
		local v3777, v3778

		v3777, v3778, n202 = proto.readTag(p303, n202)

		if v3778 == proto.wireTypes.varint then
			local v3779

			v3779, n202 = proto.readVarInt(p303, n202)
		elseif v3778 == proto.wireTypes.lengthDelimited then
			if v3777 == 1 then
				local v3780

				v3780, n202 = proto.readBuffer(p303, n202)
				v3775.moment_id = buffer.tostring(v3780)
			elseif v3777 == 2 then
				local v3781

				v3781, n202 = proto.readBuffer(p303, n202)
				v3775.video_asset_id = buffer.tostring(v3781)
			elseif v3777 == 3 then
				local v3782

				v3782, n202 = proto.readBuffer(p303, n202)
				v3775.target_universe_id = buffer.tostring(v3782)
			elseif v3777 == 4 then
				local v3783

				v3783, n202 = proto.readBuffer(p303, n202)
				v3775.target_place_id = buffer.tostring(v3783)
			elseif v3777 == 5 then
				local v3784

				v3784, n202 = proto.readBuffer(p303, n202)
				v3775.feed_item_id = buffer.tostring(v3784)
			elseif v3777 == 6 then
				local v3785

				v3785, n202 = proto.readBuffer(p303, n202)
				v3775.capture_universe_id = buffer.tostring(v3785)
			else
				local v3786, v3787 = proto.readVarInt(p303, n202)

				n202 = v3787 + v3786
			end
		elseif v3778 == proto.wireTypes.i32 then
			local v3788

			v3788, n202 = proto.readFixed32(p303, n202)
		elseif v3778 == proto.wireTypes.i64 then
			local v3789

			v3789, n202 = proto.readFixed64(p303, n202)
		else
			error("Unsupported wire type: " .. v3778)
		end
	end

	return v3775
end
function t509.jsonEncode(p304) -- line: 21451
	local t511 = {}

	if p304.moment_id ~= nil and p304.moment_id ~= "" then
		t511.momentId = p304.moment_id
	end

	if p304.video_asset_id ~= nil and p304.video_asset_id ~= "" then
		t511.videoAssetId = p304.video_asset_id
	end

	if p304.target_universe_id ~= nil and p304.target_universe_id ~= "" then
		t511.targetUniverseId = p304.target_universe_id
	end

	if p304.target_place_id ~= nil and p304.target_place_id ~= "" then
		t511.targetPlaceId = p304.target_place_id
	end

	if p304.feed_item_id ~= nil and p304.feed_item_id ~= "" then
		t511.feedItemId = p304.feed_item_id
	end

	if p304.capture_universe_id ~= nil and p304.capture_universe_id ~= "" then
		t511.captureUniverseId = p304.capture_universe_id
	end

	return t511
end
function t509.jsonDecode(t512: {[any]: any}) -- line: 21481
	-- upvalues: t509 (copy)
	local v3793 = t509.new()

	if t512.moment_id ~= nil then
		v3793.moment_id = t512.moment_id
	end

	if t512.momentId ~= nil then
		v3793.moment_id = t512.momentId
	end

	if t512.video_asset_id ~= nil then
		v3793.video_asset_id = t512.video_asset_id
	end

	if t512.videoAssetId ~= nil then
		v3793.video_asset_id = t512.videoAssetId
	end

	if t512.target_universe_id ~= nil then
		v3793.target_universe_id = t512.target_universe_id
	end

	if t512.targetUniverseId ~= nil then
		v3793.target_universe_id = t512.targetUniverseId
	end

	if t512.target_place_id ~= nil then
		v3793.target_place_id = t512.target_place_id
	end

	if t512.targetPlaceId ~= nil then
		v3793.target_place_id = t512.targetPlaceId
	end

	if t512.feed_item_id ~= nil then
		v3793.feed_item_id = t512.feed_item_id
	end

	if t512.feedItemId ~= nil then
		v3793.feed_item_id = t512.feedItemId
	end

	if t512.capture_universe_id ~= nil then
		v3793.capture_universe_id = t512.capture_universe_id
	end

	if t512.captureUniverseId ~= nil then
		v3793.capture_universe_id = t512.captureUniverseId
	end

	return v3793
end

t509.descriptor = {
	name = "MomentsCarouselInputData_MomentItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.MomentItem"
}
t1.MomentsCarouselInputData_MomentItem = t509
typeRegistry.default:register(t1.MomentsCarouselInputData_MomentItem)

local t513 = {}

t513.__index = t513

function t513.new(t514: {[any]: any}?) -- line: 21551
	-- upvalues: t513 (copy)
	return (setmetatable({
		title = if t514 ~= nil and t514.title ~= nil then t514.title else "",
		subtitle = if t514 ~= nil and t514.subtitle ~= nil then t514.subtitle else ""
	}, t513))
end
function t513.encode(p305) -- line: 21558
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n203 = 0

	if p305.title ~= nil and p305.title ~= "" then
		local v3798, v3799 = proto.writeTag(buf, n203, 1, proto.wireTypes.lengthDelimited)

		buf, n203 = proto.writeString(v3798, v3799, p305.title)
	end

	if p305.subtitle ~= nil and p305.subtitle ~= "" then
		local v3800, v3801 = proto.writeTag(buf, n203, 2, proto.wireTypes.lengthDelimited)

		buf, n203 = proto.writeString(v3800, v3801, p305.subtitle)
	end

	local buf111 = buffer.create(n203)

	buffer.copy(buf111, 0, buf, 0, n203)

	return buf111
end
function t513.decode(p306: buffer) -- line: 21577
	-- upvalues: t513 (copy), proto (copy)
	local v3804 = t513.new()
	local n204 = 0

	while n204 < buffer.len(p306) do
		local v3806, v3807

		v3806, v3807, n204 = proto.readTag(p306, n204)

		if v3807 == proto.wireTypes.varint then
			local v3808

			v3808, n204 = proto.readVarInt(p306, n204)
		elseif v3807 == proto.wireTypes.lengthDelimited then
			if v3806 == 1 then
				local v3809

				v3809, n204 = proto.readBuffer(p306, n204)
				v3804.title = buffer.tostring(v3809)
			elseif v3806 == 2 then
				local v3810

				v3810, n204 = proto.readBuffer(p306, n204)
				v3804.subtitle = buffer.tostring(v3810)
			else
				local v3811, v3812 = proto.readVarInt(p306, n204)

				n204 = v3812 + v3811
			end
		elseif v3807 == proto.wireTypes.i32 then
			local v3813

			v3813, n204 = proto.readFixed32(p306, n204)
		elseif v3807 == proto.wireTypes.i64 then
			local v3814

			v3814, n204 = proto.readFixed64(p306, n204)
		else
			error("Unsupported wire type: " .. v3807)
		end
	end

	return v3804
end
function t513.jsonEncode(p307) -- line: 21625
	local t515 = {}

	if p307.title ~= nil and p307.title ~= "" then
		t515.title = p307.title
	end

	if p307.subtitle ~= nil and p307.subtitle ~= "" then
		t515.subtitle = p307.subtitle
	end

	return t515
end
function t513.jsonDecode(t516: {[any]: any}) -- line: 21639
	-- upvalues: t513 (copy)
	local v3818 = t513.new()

	if t516.title ~= nil then
		v3818.title = t516.title
	end

	if t516.subtitle ~= nil then
		v3818.subtitle = t516.subtitle
	end

	return v3818
end

t513.descriptor = {
	name = "AttributionRowInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.AttributionRowInputData"
}
t1.AttributionRowInputData = t513
typeRegistry.default:register(t1.AttributionRowInputData)

local t517 = {}

t517.__index = t517

function t517.new(t518: {[any]: any}?) -- line: 21667
	-- upvalues: t517 (copy)
	return (setmetatable({
		primary_cta_button_text = if t518 ~= nil and t518.primary_cta_button_text ~= nil then t518.primary_cta_button_text else "",
		secondary_cta_button_text = if t518 ~= nil and t518.secondary_cta_button_text ~= nil then t518.secondary_cta_button_text else ""
	}, t517))
end
function t517.encode(p308) -- line: 21678
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n205 = 0

	if p308.primary_cta_button_text ~= nil and p308.primary_cta_button_text ~= "" then
		local v3823, v3824 = proto.writeTag(buf, n205, 1, proto.wireTypes.lengthDelimited)

		buf, n205 = proto.writeString(v3823, v3824, p308.primary_cta_button_text)
	end

	if p308.secondary_cta_button_text ~= nil and p308.secondary_cta_button_text ~= "" then
		local v3825, v3826 = proto.writeTag(buf, n205, 2, proto.wireTypes.lengthDelimited)

		buf, n205 = proto.writeString(v3825, v3826, p308.secondary_cta_button_text)
	end

	local buf112 = buffer.create(n205)

	buffer.copy(buf112, 0, buf, 0, n205)

	return buf112
end
function t517.decode(p309: buffer) -- line: 21697
	-- upvalues: t517 (copy), proto (copy)
	local v3829 = t517.new()
	local n206 = 0

	while n206 < buffer.len(p309) do
		local v3831, v3832

		v3831, v3832, n206 = proto.readTag(p309, n206)

		if v3832 == proto.wireTypes.varint then
			local v3833

			v3833, n206 = proto.readVarInt(p309, n206)
		elseif v3832 == proto.wireTypes.lengthDelimited then
			if v3831 == 1 then
				local v3834

				v3834, n206 = proto.readBuffer(p309, n206)
				v3829.primary_cta_button_text = buffer.tostring(v3834)
			elseif v3831 == 2 then
				local v3835

				v3835, n206 = proto.readBuffer(p309, n206)
				v3829.secondary_cta_button_text = buffer.tostring(v3835)
			else
				local v3836, v3837 = proto.readVarInt(p309, n206)

				n206 = v3837 + v3836
			end
		elseif v3832 == proto.wireTypes.i32 then
			local v3838

			v3838, n206 = proto.readFixed32(p309, n206)
		elseif v3832 == proto.wireTypes.i64 then
			local v3839

			v3839, n206 = proto.readFixed64(p309, n206)
		else
			error("Unsupported wire type: " .. v3832)
		end
	end

	return v3829
end
function t517.jsonEncode(p310) -- line: 21745
	local t519 = {}

	if p310.primary_cta_button_text ~= nil and p310.primary_cta_button_text ~= "" then
		t519.primaryCtaButtonText = p310.primary_cta_button_text
	end

	if p310.secondary_cta_button_text ~= nil and p310.secondary_cta_button_text ~= "" then
		t519.secondaryCtaButtonText = p310.secondary_cta_button_text
	end

	return t519
end
function t517.jsonDecode(t520: {[any]: any}) -- line: 21759
	-- upvalues: t517 (copy)
	local v3843 = t517.new()

	if t520.primary_cta_button_text ~= nil then
		v3843.primary_cta_button_text = t520.primary_cta_button_text
	end

	if t520.primaryCtaButtonText ~= nil then
		v3843.primary_cta_button_text = t520.primaryCtaButtonText
	end

	if t520.secondary_cta_button_text ~= nil then
		v3843.secondary_cta_button_text = t520.secondary_cta_button_text
	end

	if t520.secondaryCtaButtonText ~= nil then
		v3843.secondary_cta_button_text = t520.secondaryCtaButtonText
	end

	return v3843
end

t517.descriptor = {
	name = "CtaButtonsInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CtaButtonsInputData"
}
t1.CtaButtonsInputData = t517
typeRegistry.default:register(t1.CtaButtonsInputData)

local t521 = {}

t521.__index = t521

function t521.new(t522: {[any]: any}?) -- line: 21795
	-- upvalues: t521 (copy)
	return (setmetatable({
		image_asset_id = if t522 ~= nil and t522.image_asset_id ~= nil then t522.image_asset_id else ""
	}, t521))
end
function t521.encode(p311) -- line: 21801
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n207 = 0

	if p311.image_asset_id ~= nil and p311.image_asset_id ~= "" then
		local v3848, v3849 = proto.writeTag(buf, n207, 1, proto.wireTypes.lengthDelimited)

		buf, n207 = proto.writeString(v3848, v3849, p311.image_asset_id)
	end

	local buf113 = buffer.create(n207)

	buffer.copy(buf113, 0, buf, 0, n207)

	return buf113
end
function t521.decode(p312: buffer) -- line: 21815
	-- upvalues: t521 (copy), proto (copy)
	local v3852 = t521.new()
	local n208 = 0

	while n208 < buffer.len(p312) do
		local v3854, v3855

		v3854, v3855, n208 = proto.readTag(p312, n208)

		if v3855 == proto.wireTypes.varint then
			local v3856

			v3856, n208 = proto.readVarInt(p312, n208)
		elseif v3855 == proto.wireTypes.lengthDelimited then
			if v3854 == 1 then
				local v3857

				v3857, n208 = proto.readBuffer(p312, n208)
				v3852.image_asset_id = buffer.tostring(v3857)
			else
				local v3858, v3859 = proto.readVarInt(p312, n208)

				n208 = v3859 + v3858
			end
		elseif v3855 == proto.wireTypes.i32 then
			local v3860

			v3860, n208 = proto.readFixed32(p312, n208)
		elseif v3855 == proto.wireTypes.i64 then
			local v3861

			v3861, n208 = proto.readFixed64(p312, n208)
		else
			error("Unsupported wire type: " .. v3855)
		end
	end

	return v3852
end
function t521.jsonEncode(p313) -- line: 21858
	local t523 = {}

	if p313.image_asset_id ~= nil and p313.image_asset_id ~= "" then
		t523.imageAssetId = p313.image_asset_id
	end

	return t523
end
function t521.jsonDecode(t524: {[any]: any}) -- line: 21868
	-- upvalues: t521 (copy)
	local v3865 = t521.new()

	if t524.image_asset_id ~= nil then
		v3865.image_asset_id = t524.image_asset_id
	end

	if t524.imageAssetId ~= nil then
		v3865.image_asset_id = t524.imageAssetId
	end

	return v3865
end

t521.descriptor = {
	name = "ImageInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ImageInputData"
}
t1.ImageInputData = t521
typeRegistry.default:register(t1.ImageInputData)

local t525 = {}

t525.__index = t525

function t525.new(t526: {[any]: any}?) -- line: 21896
	-- upvalues: t525 (copy)
	return (setmetatable({
		video_asset_id = if t526 ~= nil and t526.video_asset_id ~= nil then t526.video_asset_id else ""
	}, t525))
end
function t525.encode(p314) -- line: 21902
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n209 = 0

	if p314.video_asset_id ~= nil and p314.video_asset_id ~= "" then
		local v3870, v3871 = proto.writeTag(buf, n209, 1, proto.wireTypes.lengthDelimited)

		buf, n209 = proto.writeString(v3870, v3871, p314.video_asset_id)
	end

	local buf114 = buffer.create(n209)

	buffer.copy(buf114, 0, buf, 0, n209)

	return buf114
end
function t525.decode(p315: buffer) -- line: 21916
	-- upvalues: t525 (copy), proto (copy)
	local v3874 = t525.new()
	local n210 = 0

	while n210 < buffer.len(p315) do
		local v3876, v3877

		v3876, v3877, n210 = proto.readTag(p315, n210)

		if v3877 == proto.wireTypes.varint then
			local v3878

			v3878, n210 = proto.readVarInt(p315, n210)
		elseif v3877 == proto.wireTypes.lengthDelimited then
			if v3876 == 1 then
				local v3879

				v3879, n210 = proto.readBuffer(p315, n210)
				v3874.video_asset_id = buffer.tostring(v3879)
			else
				local v3880, v3881 = proto.readVarInt(p315, n210)

				n210 = v3881 + v3880
			end
		elseif v3877 == proto.wireTypes.i32 then
			local v3882

			v3882, n210 = proto.readFixed32(p315, n210)
		elseif v3877 == proto.wireTypes.i64 then
			local v3883

			v3883, n210 = proto.readFixed64(p315, n210)
		else
			error("Unsupported wire type: " .. v3877)
		end
	end

	return v3874
end
function t525.jsonEncode(p316) -- line: 21959
	local t527 = {}

	if p316.video_asset_id ~= nil and p316.video_asset_id ~= "" then
		t527.videoAssetId = p316.video_asset_id
	end

	return t527
end
function t525.jsonDecode(t528: {[any]: any}) -- line: 21969
	-- upvalues: t525 (copy)
	local v3887 = t525.new()

	if t528.video_asset_id ~= nil then
		v3887.video_asset_id = t528.video_asset_id
	end

	if t528.videoAssetId ~= nil then
		v3887.video_asset_id = t528.videoAssetId
	end

	return v3887
end

t525.descriptor = {
	name = "VideoInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.VideoInputData"
}
t1.VideoInputData = t525
typeRegistry.default:register(t1.VideoInputData)

local t529 = {}

t529.__index = t529

function t529.new(t530: {[any]: any}?) -- line: 21997
	-- upvalues: t529 (copy)
	return (setmetatable({
		text = if t530 ~= nil and t530.text ~= nil then t530.text else "",
		is_rendered_text = t530 ~= nil and (t530.is_rendered_text ~= nil and t530.is_rendered_text)
	}, t529))
end
function t529.encode(p317) -- line: 22004
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n211 = 0

	if p317.text ~= nil and p317.text ~= "" then
		local v3892, v3893 = proto.writeTag(buf, n211, 1, proto.wireTypes.lengthDelimited)

		buf, n211 = proto.writeString(v3892, v3893, p317.text)
	end

	if p317.is_rendered_text then
		local v3894, v3895 = proto.writeTag(buf, n211, 2, proto.wireTypes.varint)

		buf, n211 = proto.writeVarInt(v3894, v3895, not p317.is_rendered_text and 0 or 1)
	end

	local buf115 = buffer.create(n211)

	buffer.copy(buf115, 0, buf, 0, n211)

	return buf115
end
function t529.decode(p318: buffer) -- line: 22023
	-- upvalues: t529 (copy), proto (copy)
	local v3898 = t529.new()
	local n212 = 0

	while n212 < buffer.len(p318) do
		local v3900, v3901

		v3900, v3901, n212 = proto.readTag(p318, n212)

		if v3901 == proto.wireTypes.varint then
			if v3900 == 2 then
				local v3902

				v3902, n212 = proto.readVarInt(p318, n212)
				v3898.is_rendered_text = v3902 ~= 0
			else
				local v3903

				v3903, n212 = proto.readVarInt(p318, n212)
			end
		elseif v3901 == proto.wireTypes.lengthDelimited then
			if v3900 == 1 then
				local v3904

				v3904, n212 = proto.readBuffer(p318, n212)
				v3898.text = buffer.tostring(v3904)
			else
				local v3905, v3906 = proto.readVarInt(p318, n212)

				n212 = v3906 + v3905
			end
		elseif v3901 == proto.wireTypes.i32 then
			local v3907

			v3907, n212 = proto.readFixed32(p318, n212)
		elseif v3901 == proto.wireTypes.i64 then
			local v3908

			v3908, n212 = proto.readFixed64(p318, n212)
		else
			error("Unsupported wire type: " .. v3901)
		end
	end

	return v3898
end
function t529.jsonEncode(p319) -- line: 22071
	local t531 = {}

	if p319.text ~= nil and p319.text ~= "" then
		t531.text = p319.text
	end

	if p319.is_rendered_text then
		t531.isRenderedText = p319.is_rendered_text
	end

	return t531
end
function t529.jsonDecode(t532: {[any]: any}) -- line: 22085
	-- upvalues: t529 (copy)
	local v3912 = t529.new()

	if t532.text ~= nil then
		v3912.text = t532.text
	end

	if t532.is_rendered_text ~= nil then
		v3912.is_rendered_text = t532.is_rendered_text
	end

	if t532.isRenderedText ~= nil then
		v3912.is_rendered_text = t532.isRenderedText
	end

	return v3912
end

t529.descriptor = {
	name = "TextInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.TextInputData"
}
t1.TextInputData = t529
typeRegistry.default:register(t1.TextInputData)

local t533 = {}

t533.__index = t533

function t533.new(t534: {[any]: any}?) -- line: 22117
	-- upvalues: t533 (copy)
	return (setmetatable({
		entry_map = if t534 ~= nil and t534.entry_map ~= nil then t534.entry_map else {},
		entry_order = if t534 ~= nil and t534.entry_order ~= nil then t534.entry_order else {},
		entry_order_map = if t534 ~= nil and t534.entry_order_map ~= nil then t534.entry_order_map else {},
		content_pools = if t534 ~= nil and t534.content_pools ~= nil then t534.content_pools else {}
	}, t533))
end
function t533.encode(p320) -- line: 22126
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n213 = 0

	if p320.entry_map ~= nil and next(p320.entry_map) ~= nil then
		for v3917, v3918 in p320.entry_map do
			local buf116 = buffer.create(0)
			local v3920, v3921 = proto.writeTag(buf116, 0, 1, proto.wireTypes.lengthDelimited)
			local v3922, v3923 = proto.writeString(v3920, v3921, v3917)
			local v3924 = v3918:encode()
			local v3925, v3926 = proto.writeTag(v3922, v3923, 2, proto.wireTypes.lengthDelimited)
			local v3927, v3928 = proto.writeBuffer(v3925, v3926, v3924, buffer.len(v3924))
			local v3929, v3930 = proto.writeTag(buf, n213, 1, proto.wireTypes.lengthDelimited)

			buf, n213 = proto.writeBuffer(v3929, v3930, v3927, v3928)
		end
	end

	if p320.entry_order ~= nil and #p320.entry_order > 0 then
		for _, v3932 in p320.entry_order do
			local v3933, v3934 = proto.writeTag(buf, n213, 2, proto.wireTypes.lengthDelimited)

			buf, n213 = proto.writeString(v3933, v3934, v3932)
		end
	end

	if p320.entry_order_map ~= nil and next(p320.entry_order_map) ~= nil then
		for v3935, v3936 in p320.entry_order_map do
			local buf117 = buffer.create(0)
			local v3938, v3939 = proto.writeTag(buf117, 0, 1, proto.wireTypes.lengthDelimited)
			local v3940, v3941 = proto.writeString(v3938, v3939, v3935)
			local v3942 = v3936:encode()
			local v3943, v3944 = proto.writeTag(v3940, v3941, 2, proto.wireTypes.lengthDelimited)
			local v3945, v3946 = proto.writeBuffer(v3943, v3944, v3942, buffer.len(v3942))
			local v3947, v3948 = proto.writeTag(buf, n213, 3, proto.wireTypes.lengthDelimited)

			buf, n213 = proto.writeBuffer(v3947, v3948, v3945, v3946)
		end
	end

	if p320.content_pools ~= nil and next(p320.content_pools) ~= nil then
		for v3949, v3950 in p320.content_pools do
			local buf118 = buffer.create(0)
			local v3952, v3953 = proto.writeTag(buf118, 0, 1, proto.wireTypes.lengthDelimited)
			local v3954, v3955 = proto.writeString(v3952, v3953, v3949)
			local v3956 = v3950:encode()
			local v3957, v3958 = proto.writeTag(v3954, v3955, 2, proto.wireTypes.lengthDelimited)
			local v3959, v3960 = proto.writeBuffer(v3957, v3958, v3956, buffer.len(v3956))
			local v3961, v3962 = proto.writeTag(buf, n213, 4, proto.wireTypes.lengthDelimited)

			buf, n213 = proto.writeBuffer(v3961, v3962, v3959, v3960)
		end
	end

	local buf119 = buffer.create(n213)

	buffer.copy(buf119, 0, buf, 0, n213)

	return buf119
end
function t533.decode(p321: buffer) -- line: 22184
	-- upvalues: t533 (copy), proto (copy), t1 (copy)
	local v3965 = t533.new()
	local n214 = 0

	while n214 < buffer.len(p321) do
		local v3967, v3968

		v3967, v3968, n214 = proto.readTag(p321, n214)

		if v3968 == proto.wireTypes.varint then
			local v3969

			v3969, n214 = proto.readVarInt(p321, n214)
		elseif v3968 == proto.wireTypes.lengthDelimited then
			if v3967 == 1 then
				local v3970

				v3970, n214 = proto.readBuffer(p321, n214)

				local v3971 = t1.VerticalFeedInputData_EntryMapEntry.decode(v3970)
				local v3972 = t1.FeedEntry.new()

				v3965.entry_map[v3971.key or ""] = v3971.value or v3972
			elseif v3967 == 2 then
				local v3973

				v3973, n214 = proto.readBuffer(p321, n214)
				table.insert(v3965.entry_order, buffer.tostring(v3973))
			elseif v3967 == 3 then
				local v3974

				v3974, n214 = proto.readBuffer(p321, n214)

				local v3975 = t1.VerticalFeedInputData_EntryOrderMapEntry.decode(v3974)
				local v3976 = t1.EntryOrder.new()

				v3965.entry_order_map[v3975.key or ""] = v3975.value or v3976
			elseif v3967 == 4 then
				local v3977

				v3977, n214 = proto.readBuffer(p321, n214)

				local v3978 = t1.VerticalFeedInputData_ContentPoolsEntry.decode(v3977)
				local v3979 = t1.ContentPool.new()

				v3965.content_pools[v3978.key or ""] = v3978.value or v3979
			else
				local v3980, v3981 = proto.readVarInt(p321, n214)

				n214 = v3981 + v3980
			end
		elseif v3968 == proto.wireTypes.i32 then
			local v3982

			v3982, n214 = proto.readFixed32(p321, n214)
		elseif v3968 == proto.wireTypes.i64 then
			local v3983

			v3983, n214 = proto.readFixed64(p321, n214)
		else
			error("Unsupported wire type: " .. v3968)
		end
	end

	return v3965
end
function t533.jsonEncode(p322) -- line: 22263
	local t535 = {}

	if p322.entry_map ~= nil and next(p322.entry_map) ~= nil then
		local t536 = {}

		for v3987, v3988 in p322.entry_map do
			t536[v3987] = v3988:jsonEncode()
		end

		t535.entryMap = t536
	end

	if p322.entry_order ~= nil and #p322.entry_order > 0 then
		local t537 = {}

		for _, v3991 in p322.entry_order do
			table.insert(t537, v3991)
		end

		t535.entryOrder = t537
	end

	if p322.entry_order_map ~= nil and next(p322.entry_order_map) ~= nil then
		local t538 = {}

		for v3993, v3994 in p322.entry_order_map do
			t538[v3993] = v3994:jsonEncode()
		end

		t535.entryOrderMap = t538
	end

	if p322.content_pools ~= nil and next(p322.content_pools) ~= nil then
		local t539 = {}

		for v3996, v3997 in p322.content_pools do
			t539[v3996] = v3997:jsonEncode()
		end

		t535.contentPools = t539
	end

	return t535
end
function t533.jsonDecode(t540: {[any]: any}) -- line: 22301
	-- upvalues: t533 (copy), t1 (copy)
	local v3999 = t533.new()

	if t540.entry_map ~= nil then
		local t541 = {}

		for v4001, v4002 in t540.entry_map do
			t541[v4001] = t1.FeedEntry.jsonDecode(v4002)
		end

		v3999.entry_map = t541
	end

	if t540.entryMap ~= nil then
		local t542 = {}

		for v4004, v4005 in t540.entryMap do
			t542[v4004] = t1.FeedEntry.jsonDecode(v4005)
		end

		v3999.entry_map = t542
	end

	if t540.entry_order ~= nil then
		local t543 = {}

		for _, v4008 in t540.entry_order do
			table.insert(t543, v4008)
		end

		v3999.entry_order = t543
	end

	if t540.entryOrder ~= nil then
		local t544 = {}

		for _, v4011 in t540.entryOrder do
			table.insert(t544, v4011)
		end

		v3999.entry_order = t544
	end

	if t540.entry_order_map ~= nil then
		local t545 = {}

		for v4013, v4014 in t540.entry_order_map do
			t545[v4013] = t1.EntryOrder.jsonDecode(v4014)
		end

		v3999.entry_order_map = t545
	end

	if t540.entryOrderMap ~= nil then
		local t546 = {}

		for v4016, v4017 in t540.entryOrderMap do
			t546[v4016] = t1.EntryOrder.jsonDecode(v4017)
		end

		v3999.entry_order_map = t546
	end

	if t540.content_pools ~= nil then
		local t547 = {}

		for v4019, v4020 in t540.content_pools do
			t547[v4019] = t1.ContentPool.jsonDecode(v4020)
		end

		v3999.content_pools = t547
	end

	if t540.contentPools ~= nil then
		local t548 = {}

		for v4022, v4023 in t540.contentPools do
			t548[v4022] = t1.ContentPool.jsonDecode(v4023)
		end

		v3999.content_pools = t548
	end

	return v3999
end

t533.descriptor = {
	name = "VerticalFeedInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.VerticalFeedInputData"
}
t1.VerticalFeedInputData = t533
typeRegistry.default:register(t1.VerticalFeedInputData)

local t549 = {}

t549.__index = t549

function t549.new(t550: {[any]: any}?) -- line: 22393
	-- upvalues: t549 (copy)
	return (setmetatable({
		key = if t550 ~= nil and t550.key ~= nil then t550.key else "",
		value = if t550 ~= nil and t550.value ~= nil then t550.value else nil
	}, t549))
end
function t549.encode(p323) -- line: 22402
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n215 = 0

	if p323.key ~= nil and p323.key ~= "" then
		local v4028, v4029 = proto.writeTag(buf, n215, 1, proto.wireTypes.lengthDelimited)

		buf, n215 = proto.writeString(v4028, v4029, p323.key)
	end

	if p323.value ~= nil then
		local v4030 = p323.value:encode()
		local v4031, v4032 = proto.writeTag(buf, n215, 2, proto.wireTypes.lengthDelimited)

		buf, n215 = proto.writeBuffer(v4031, v4032, v4030, buffer.len(v4030))
	end

	local buf120 = buffer.create(n215)

	buffer.copy(buf120, 0, buf, 0, n215)

	return buf120
end
function t549.decode(p324: buffer) -- line: 22422
	-- upvalues: t549 (copy), proto (copy), t1 (copy)
	local v4035 = t549.new()
	local n216 = 0

	while n216 < buffer.len(p324) do
		local v4037, v4038

		v4037, v4038, n216 = proto.readTag(p324, n216)

		if v4038 == proto.wireTypes.varint then
			local v4039

			v4039, n216 = proto.readVarInt(p324, n216)
		elseif v4038 == proto.wireTypes.lengthDelimited then
			if v4037 == 1 then
				local v4040

				v4040, n216 = proto.readBuffer(p324, n216)
				v4035.key = buffer.tostring(v4040)
			elseif v4037 == 2 then
				local v4041

				v4041, n216 = proto.readBuffer(p324, n216)
				v4035.value = t1.FeedEntry.decode(v4041)
			else
				local v4042, v4043 = proto.readVarInt(p324, n216)

				n216 = v4043 + v4042
			end
		elseif v4038 == proto.wireTypes.i32 then
			local v4044

			v4044, n216 = proto.readFixed32(p324, n216)
		elseif v4038 == proto.wireTypes.i64 then
			local v4045

			v4045, n216 = proto.readFixed64(p324, n216)
		else
			error("Unsupported wire type: " .. v4038)
		end
	end

	return v4035
end
function t549.jsonEncode(p325) -- line: 22470
	local t551 = {}

	if p325.key ~= nil and p325.key ~= "" then
		t551.key = p325.key
	end

	if p325.value ~= nil then
		t551.value = p325.value:jsonEncode()
	end

	return t551
end
function t549.jsonDecode(t552: {[any]: any}) -- line: 22484
	-- upvalues: t549 (copy), t1 (copy)
	local v4049 = t549.new()

	if t552.key ~= nil then
		v4049.key = t552.key
	end

	if t552.value ~= nil then
		v4049.value = t1.FeedEntry.jsonDecode(t552.value)
	end

	return v4049
end

t549.descriptor = {
	name = "VerticalFeedInputData_EntryMapEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryMapEntry"
}
t1.VerticalFeedInputData_EntryMapEntry = t549
typeRegistry.default:register(t1.VerticalFeedInputData_EntryMapEntry)

local t553 = {}

t553.__index = t553

function t553.new(t554: {[any]: any}?) -- line: 22514
	-- upvalues: t553 (copy)
	return (setmetatable({
		key = if t554 ~= nil and t554.key ~= nil then t554.key else "",
		value = if t554 ~= nil and t554.value ~= nil then t554.value else nil
	}, t553))
end
function t553.encode(p326) -- line: 22523
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n217 = 0

	if p326.key ~= nil and p326.key ~= "" then
		local v4054, v4055 = proto.writeTag(buf, n217, 1, proto.wireTypes.lengthDelimited)

		buf, n217 = proto.writeString(v4054, v4055, p326.key)
	end

	if p326.value ~= nil then
		local v4056 = p326.value:encode()
		local v4057, v4058 = proto.writeTag(buf, n217, 2, proto.wireTypes.lengthDelimited)

		buf, n217 = proto.writeBuffer(v4057, v4058, v4056, buffer.len(v4056))
	end

	local buf121 = buffer.create(n217)

	buffer.copy(buf121, 0, buf, 0, n217)

	return buf121
end
function t553.decode(p327: buffer) -- line: 22545
	-- upvalues: t553 (copy), proto (copy), t1 (copy)
	local v4061 = t553.new()
	local n218 = 0

	while n218 < buffer.len(p327) do
		local v4063, v4064

		v4063, v4064, n218 = proto.readTag(p327, n218)

		if v4064 == proto.wireTypes.varint then
			local v4065

			v4065, n218 = proto.readVarInt(p327, n218)
		elseif v4064 == proto.wireTypes.lengthDelimited then
			if v4063 == 1 then
				local v4066

				v4066, n218 = proto.readBuffer(p327, n218)
				v4061.key = buffer.tostring(v4066)
			elseif v4063 == 2 then
				local v4067

				v4067, n218 = proto.readBuffer(p327, n218)
				v4061.value = t1.EntryOrder.decode(v4067)
			else
				local v4068, v4069 = proto.readVarInt(p327, n218)

				n218 = v4069 + v4068
			end
		elseif v4064 == proto.wireTypes.i32 then
			local v4070

			v4070, n218 = proto.readFixed32(p327, n218)
		elseif v4064 == proto.wireTypes.i64 then
			local v4071

			v4071, n218 = proto.readFixed64(p327, n218)
		else
			error("Unsupported wire type: " .. v4064)
		end
	end

	return v4061
end
function t553.jsonEncode(p328) -- line: 22595
	local t555 = {}

	if p328.key ~= nil and p328.key ~= "" then
		t555.key = p328.key
	end

	if p328.value ~= nil then
		t555.value = p328.value:jsonEncode()
	end

	return t555
end
function t553.jsonDecode(t556: {[any]: any}) -- line: 22611
	-- upvalues: t553 (copy), t1 (copy)
	local v4075 = t553.new()

	if t556.key ~= nil then
		v4075.key = t556.key
	end

	if t556.value ~= nil then
		v4075.value = t1.EntryOrder.jsonDecode(t556.value)
	end

	return v4075
end

t553.descriptor = {
	name = "VerticalFeedInputData_EntryOrderMapEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EntryOrderMapEntry"
}
t1.VerticalFeedInputData_EntryOrderMapEntry = t553
typeRegistry.default:register(t1.VerticalFeedInputData_EntryOrderMapEntry)

local t557 = {}

t557.__index = t557

function t557.new(t558: {[any]: any}?) -- line: 22641
	-- upvalues: t557 (copy)
	return (setmetatable({
		key = if t558 ~= nil and t558.key ~= nil then t558.key else "",
		value = if t558 ~= nil and t558.value ~= nil then t558.value else nil
	}, t557))
end
function t557.encode(p329) -- line: 22650
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n219 = 0

	if p329.key ~= nil and p329.key ~= "" then
		local v4080, v4081 = proto.writeTag(buf, n219, 1, proto.wireTypes.lengthDelimited)

		buf, n219 = proto.writeString(v4080, v4081, p329.key)
	end

	if p329.value ~= nil then
		local v4082 = p329.value:encode()
		local v4083, v4084 = proto.writeTag(buf, n219, 2, proto.wireTypes.lengthDelimited)

		buf, n219 = proto.writeBuffer(v4083, v4084, v4082, buffer.len(v4082))
	end

	local buf122 = buffer.create(n219)

	buffer.copy(buf122, 0, buf, 0, n219)

	return buf122
end
function t557.decode(p330: buffer) -- line: 22670
	-- upvalues: t557 (copy), proto (copy), t1 (copy)
	local v4087 = t557.new()
	local n220 = 0

	while n220 < buffer.len(p330) do
		local v4089, v4090

		v4089, v4090, n220 = proto.readTag(p330, n220)

		if v4090 == proto.wireTypes.varint then
			local v4091

			v4091, n220 = proto.readVarInt(p330, n220)
		elseif v4090 == proto.wireTypes.lengthDelimited then
			if v4089 == 1 then
				local v4092

				v4092, n220 = proto.readBuffer(p330, n220)
				v4087.key = buffer.tostring(v4092)
			elseif v4089 == 2 then
				local v4093

				v4093, n220 = proto.readBuffer(p330, n220)
				v4087.value = t1.ContentPool.decode(v4093)
			else
				local v4094, v4095 = proto.readVarInt(p330, n220)

				n220 = v4095 + v4094
			end
		elseif v4090 == proto.wireTypes.i32 then
			local v4096

			v4096, n220 = proto.readFixed32(p330, n220)
		elseif v4090 == proto.wireTypes.i64 then
			local v4097

			v4097, n220 = proto.readFixed64(p330, n220)
		else
			error("Unsupported wire type: " .. v4090)
		end
	end

	return v4087
end
function t557.jsonEncode(p331) -- line: 22718
	local t559 = {}

	if p331.key ~= nil and p331.key ~= "" then
		t559.key = p331.key
	end

	if p331.value ~= nil then
		t559.value = p331.value:jsonEncode()
	end

	return t559
end
function t557.jsonDecode(t560: {[any]: any}) -- line: 22732
	-- upvalues: t557 (copy), t1 (copy)
	local v4101 = t557.new()

	if t560.key ~= nil then
		v4101.key = t560.key
	end

	if t560.value ~= nil then
		v4101.value = t1.ContentPool.jsonDecode(t560.value)
	end

	return v4101
end

t557.descriptor = {
	name = "VerticalFeedInputData_ContentPoolsEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.ContentPoolsEntry"
}
t1.VerticalFeedInputData_ContentPoolsEntry = t557
typeRegistry.default:register(t1.VerticalFeedInputData_ContentPoolsEntry)

local t561 = {}

t561.__index = t561

function t561.new(t562: {[any]: any}?) -- line: 22762
	-- upvalues: t561 (copy)
	return (setmetatable({
		foreground_header_entry = if t562 ~= nil and t562.foreground_header_entry ~= nil then t562.foreground_header_entry else nil,
		background_header_entry = if t562 ~= nil and t562.background_header_entry ~= nil then t562.background_header_entry else nil
	}, t561))
end
function t561.encode(p332) -- line: 22773
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n221 = 0

	if p332.foreground_header_entry ~= nil then
		local v4106 = p332.foreground_header_entry:encode()
		local v4107, v4108 = proto.writeTag(buf, n221, 1, proto.wireTypes.lengthDelimited)

		buf, n221 = proto.writeBuffer(v4107, v4108, v4106, buffer.len(v4106))
	end

	if p332.background_header_entry ~= nil then
		local v4109 = p332.background_header_entry:encode()
		local v4110, v4111 = proto.writeTag(buf, n221, 2, proto.wireTypes.lengthDelimited)

		buf, n221 = proto.writeBuffer(v4110, v4111, v4109, buffer.len(v4109))
	end

	local buf123 = buffer.create(n221)

	buffer.copy(buf123, 0, buf, 0, n221)

	return buf123
end
function t561.decode(p333: buffer) -- line: 22794
	-- upvalues: t561 (copy), proto (copy), t1 (copy)
	local v4114 = t561.new()
	local n222 = 0

	while n222 < buffer.len(p333) do
		local v4116, v4117

		v4116, v4117, n222 = proto.readTag(p333, n222)

		if v4117 == proto.wireTypes.varint then
			local v4118

			v4118, n222 = proto.readVarInt(p333, n222)
		elseif v4117 == proto.wireTypes.lengthDelimited then
			if v4116 == 1 then
				local v4119

				v4119, n222 = proto.readBuffer(p333, n222)
				v4114.foreground_header_entry = t1.ForegroundHeaderEntry.decode(v4119)
			elseif v4116 == 2 then
				local v4120

				v4120, n222 = proto.readBuffer(p333, n222)
				v4114.background_header_entry = t1.BackgroundHeaderEntry.decode(v4120)
			else
				local v4121, v4122 = proto.readVarInt(p333, n222)

				n222 = v4122 + v4121
			end
		elseif v4117 == proto.wireTypes.i32 then
			local v4123

			v4123, n222 = proto.readFixed32(p333, n222)
		elseif v4117 == proto.wireTypes.i64 then
			local v4124

			v4124, n222 = proto.readFixed64(p333, n222)
		else
			error("Unsupported wire type: " .. v4117)
		end
	end

	return v4114
end
function t561.jsonEncode(p334) -- line: 22842
	local t563 = {}

	if p334.foreground_header_entry ~= nil then
		t563.foregroundHeaderEntry = p334.foreground_header_entry:jsonEncode()
	end

	if p334.background_header_entry ~= nil then
		t563.backgroundHeaderEntry = p334.background_header_entry:jsonEncode()
	end

	return t563
end
function t561.jsonDecode(t564: {[any]: any}) -- line: 22856
	-- upvalues: t561 (copy), t1 (copy)
	local v4128 = t561.new()

	if t564.foreground_header_entry ~= nil then
		v4128.foreground_header_entry = t1.ForegroundHeaderEntry.jsonDecode(t564.foreground_header_entry)
	end

	if t564.foregroundHeaderEntry ~= nil then
		v4128.foreground_header_entry = t1.ForegroundHeaderEntry.jsonDecode(t564.foregroundHeaderEntry)
	end

	if t564.background_header_entry ~= nil then
		v4128.background_header_entry = t1.BackgroundHeaderEntry.jsonDecode(t564.background_header_entry)
	end

	if t564.backgroundHeaderEntry ~= nil then
		v4128.background_header_entry = t1.BackgroundHeaderEntry.jsonDecode(t564.backgroundHeaderEntry)
	end

	return v4128
end

t561.descriptor = {
	name = "PageHeaderInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.PageHeaderInputData"
}
t1.PageHeaderInputData = t561
typeRegistry.default:register(t1.PageHeaderInputData)

local t565 = {}

t565.__index = t565

function t565.new(t566: {[any]: any}?) -- line: 22892
	-- upvalues: t565 (copy)
	return (setmetatable({
		cta_button_text = if t566 ~= nil and t566.cta_button_text ~= nil then t566.cta_button_text else ""
	}, t565))
end
function t565.encode(p335) -- line: 22900
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n223 = 0

	if p335.cta_button_text ~= nil and p335.cta_button_text ~= "" then
		local v4133, v4134 = proto.writeTag(buf, n223, 1, proto.wireTypes.lengthDelimited)

		buf, n223 = proto.writeString(v4133, v4134, p335.cta_button_text)
	end

	local buf124 = buffer.create(n223)

	buffer.copy(buf124, 0, buf, 0, n223)

	return buf124
end
function t565.decode(p336: buffer) -- line: 22914
	-- upvalues: t565 (copy), proto (copy)
	local v4137 = t565.new()
	local n224 = 0

	while n224 < buffer.len(p336) do
		local v4139, v4140

		v4139, v4140, n224 = proto.readTag(p336, n224)

		if v4140 == proto.wireTypes.varint then
			local v4141

			v4141, n224 = proto.readVarInt(p336, n224)
		elseif v4140 == proto.wireTypes.lengthDelimited then
			if v4139 == 1 then
				local v4142

				v4142, n224 = proto.readBuffer(p336, n224)
				v4137.cta_button_text = buffer.tostring(v4142)
			else
				local v4143, v4144 = proto.readVarInt(p336, n224)

				n224 = v4144 + v4143
			end
		elseif v4140 == proto.wireTypes.i32 then
			local v4145

			v4145, n224 = proto.readFixed32(p336, n224)
		elseif v4140 == proto.wireTypes.i64 then
			local v4146

			v4146, n224 = proto.readFixed64(p336, n224)
		else
			error("Unsupported wire type: " .. v4140)
		end
	end

	return v4137
end
function t565.jsonEncode(p337) -- line: 22957
	local t567 = {}

	if p337.cta_button_text ~= nil and p337.cta_button_text ~= "" then
		t567.ctaButtonText = p337.cta_button_text
	end

	return t567
end
function t565.jsonDecode(t568: {[any]: any}) -- line: 22967
	-- upvalues: t565 (copy)
	local v4150 = t565.new()

	if t568.cta_button_text ~= nil then
		v4150.cta_button_text = t568.cta_button_text
	end

	if t568.ctaButtonText ~= nil then
		v4150.cta_button_text = t568.ctaButtonText
	end

	return v4150
end

t565.descriptor = {
	name = "PreAuthLandingStickyHeaderInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.PreAuthLandingStickyHeaderInputData"
}
t1.PreAuthLandingStickyHeaderInputData = t565
typeRegistry.default:register(t1.PreAuthLandingStickyHeaderInputData)

local t569 = {}

t569.__index = t569

function t569.new(t570: {[any]: any}?) -- line: 22997
	-- upvalues: t569 (copy)
	return (setmetatable({
		selected_option = if t570 ~= nil and t570.selected_option ~= nil then t570.selected_option else "",
		sort_id = if t570 ~= nil and t570.sort_id ~= nil then t570.sort_id else "",
		options = if t570 ~= nil and t570.options ~= nil then t570.options else {},
		experience_carousel = if t570 ~= nil and t570.experience_carousel ~= nil then t570.experience_carousel else nil,
		feed_item_key = if t570 ~= nil and t570.feed_item_key ~= nil then t570.feed_item_key else ""
	}, t569))
end
function t569.encode(p338) -- line: 23011
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n225 = 0

	if p338.selected_option ~= nil and p338.selected_option ~= "" then
		local v4155, v4156 = proto.writeTag(buf, n225, 1, proto.wireTypes.lengthDelimited)

		buf, n225 = proto.writeString(v4155, v4156, p338.selected_option)
	end

	if p338.sort_id ~= nil and p338.sort_id ~= "" then
		local v4157, v4158 = proto.writeTag(buf, n225, 2, proto.wireTypes.lengthDelimited)

		buf, n225 = proto.writeString(v4157, v4158, p338.sort_id)
	end

	if p338.options ~= nil and #p338.options > 0 then
		for _, v4160 in p338.options do
			local v4161 = v4160:encode()
			local v4162, v4163 = proto.writeTag(buf, n225, 3, proto.wireTypes.lengthDelimited)

			buf, n225 = proto.writeBuffer(v4162, v4163, v4161, buffer.len(v4161))
		end
	end

	if p338.experience_carousel ~= nil then
		local v4164 = p338.experience_carousel:encode()
		local v4165, v4166 = proto.writeTag(buf, n225, 4, proto.wireTypes.lengthDelimited)

		buf, n225 = proto.writeBuffer(v4165, v4166, v4164, buffer.len(v4164))
	end

	if p338.feed_item_key ~= nil and p338.feed_item_key ~= "" then
		local v4167, v4168 = proto.writeTag(buf, n225, 5, proto.wireTypes.lengthDelimited)

		buf, n225 = proto.writeString(v4167, v4168, p338.feed_item_key)
	end

	local buf125 = buffer.create(n225)

	buffer.copy(buf125, 0, buf, 0, n225)

	return buf125
end
function t569.decode(p339: buffer) -- line: 23049
	-- upvalues: t569 (copy), proto (copy), t1 (copy)
	local v4171 = t569.new()
	local n226 = 0

	while n226 < buffer.len(p339) do
		local v4173, v4174

		v4173, v4174, n226 = proto.readTag(p339, n226)

		if v4174 == proto.wireTypes.varint then
			local v4175

			v4175, n226 = proto.readVarInt(p339, n226)
		elseif v4174 == proto.wireTypes.lengthDelimited then
			if v4173 == 1 then
				local v4176

				v4176, n226 = proto.readBuffer(p339, n226)
				v4171.selected_option = buffer.tostring(v4176)
			elseif v4173 == 2 then
				local v4177

				v4177, n226 = proto.readBuffer(p339, n226)
				v4171.sort_id = buffer.tostring(v4177)
			elseif v4173 == 3 then
				local v4178

				v4178, n226 = proto.readBuffer(p339, n226)
				table.insert(v4171.options, t1.SelectorOption.decode(v4178))
			elseif v4173 == 4 then
				local v4179

				v4179, n226 = proto.readBuffer(p339, n226)
				v4171.experience_carousel = t1.ExperienceCarouselInputData.decode(v4179)
			elseif v4173 == 5 then
				local v4180

				v4180, n226 = proto.readBuffer(p339, n226)
				v4171.feed_item_key = buffer.tostring(v4180)
			else
				local v4181, v4182 = proto.readVarInt(p339, n226)

				n226 = v4182 + v4181
			end
		elseif v4174 == proto.wireTypes.i32 then
			local v4183

			v4183, n226 = proto.readFixed32(p339, n226)
		elseif v4174 == proto.wireTypes.i64 then
			local v4184

			v4184, n226 = proto.readFixed64(p339, n226)
		else
			error("Unsupported wire type: " .. v4174)
		end
	end

	return v4171
end
function t569.jsonEncode(p340) -- line: 23112
	local t571 = {}

	if p340.selected_option ~= nil and p340.selected_option ~= "" then
		t571.selectedOption = p340.selected_option
	end

	if p340.sort_id ~= nil and p340.sort_id ~= "" then
		t571.sortId = p340.sort_id
	end

	if p340.options ~= nil and #p340.options > 0 then
		local t572 = {}

		for _, v4189 in p340.options do
			table.insert(t572, v4189:jsonEncode())
		end

		t571.options = t572
	end

	if p340.experience_carousel ~= nil then
		t571.experienceCarousel = p340.experience_carousel:jsonEncode()
	end

	if p340.feed_item_key ~= nil and p340.feed_item_key ~= "" then
		t571.feedItemKey = p340.feed_item_key
	end

	return t571
end
function t569.jsonDecode(t573: {[any]: any}) -- line: 23142
	-- upvalues: t569 (copy), t1 (copy)
	local v4191 = t569.new()

	if t573.selected_option ~= nil then
		v4191.selected_option = t573.selected_option
	end

	if t573.selectedOption ~= nil then
		v4191.selected_option = t573.selectedOption
	end

	if t573.sort_id ~= nil then
		v4191.sort_id = t573.sort_id
	end

	if t573.sortId ~= nil then
		v4191.sort_id = t573.sortId
	end

	if t573.options ~= nil then
		local t574 = {}

		for _, v4194 in t573.options do
			table.insert(t574, t1.SelectorOption.jsonDecode(v4194))
		end

		v4191.options = t574
	end

	if t573.experience_carousel ~= nil then
		v4191.experience_carousel = t1.ExperienceCarouselInputData.jsonDecode(t573.experience_carousel)
	end

	if t573.experienceCarousel ~= nil then
		v4191.experience_carousel = t1.ExperienceCarouselInputData.jsonDecode(t573.experienceCarousel)
	end

	if t573.feed_item_key ~= nil then
		v4191.feed_item_key = t573.feed_item_key
	end

	if t573.feedItemKey ~= nil then
		v4191.feed_item_key = t573.feedItemKey
	end

	return v4191
end

t569.descriptor = {
	name = "OptionSelectorCarouselInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.OptionSelectorCarouselInputData"
}
t1.OptionSelectorCarouselInputData = t569
typeRegistry.default:register(t1.OptionSelectorCarouselInputData)

local t575 = {}

t575.__index = t575

function t575.new(t576: {[any]: any}?) -- line: 23203
	-- upvalues: t575 (copy)
	return (setmetatable({
		id = if t576 ~= nil and t576.id ~= nil then t576.id else "",
		display_name = if t576 ~= nil and t576.display_name ~= nil then t576.display_name else "",
		is_selected = t576 ~= nil and (t576.is_selected ~= nil and t576.is_selected)
	}, t575))
end
function t575.encode(p341) -- line: 23211
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n227 = 0

	if p341.id ~= nil and p341.id ~= "" then
		local v4199, v4200 = proto.writeTag(buf, n227, 1, proto.wireTypes.lengthDelimited)

		buf, n227 = proto.writeString(v4199, v4200, p341.id)
	end

	if p341.display_name ~= nil and p341.display_name ~= "" then
		local v4201, v4202 = proto.writeTag(buf, n227, 2, proto.wireTypes.lengthDelimited)

		buf, n227 = proto.writeString(v4201, v4202, p341.display_name)
	end

	if p341.is_selected then
		local v4203, v4204 = proto.writeTag(buf, n227, 3, proto.wireTypes.varint)

		buf, n227 = proto.writeVarInt(v4203, v4204, not p341.is_selected and 0 or 1)
	end

	local buf126 = buffer.create(n227)

	buffer.copy(buf126, 0, buf, 0, n227)

	return buf126
end
function t575.decode(p342: buffer) -- line: 23235
	-- upvalues: t575 (copy), proto (copy)
	local v4207 = t575.new()
	local n228 = 0

	while n228 < buffer.len(p342) do
		local v4209, v4210

		v4209, v4210, n228 = proto.readTag(p342, n228)

		if v4210 == proto.wireTypes.varint then
			if v4209 == 3 then
				local v4211

				v4211, n228 = proto.readVarInt(p342, n228)
				v4207.is_selected = v4211 ~= 0
			else
				local v4212

				v4212, n228 = proto.readVarInt(p342, n228)
			end
		elseif v4210 == proto.wireTypes.lengthDelimited then
			if v4209 == 1 then
				local v4213

				v4213, n228 = proto.readBuffer(p342, n228)
				v4207.id = buffer.tostring(v4213)
			elseif v4209 == 2 then
				local v4214

				v4214, n228 = proto.readBuffer(p342, n228)
				v4207.display_name = buffer.tostring(v4214)
			else
				local v4215, v4216 = proto.readVarInt(p342, n228)

				n228 = v4216 + v4215
			end
		elseif v4210 == proto.wireTypes.i32 then
			local v4217

			v4217, n228 = proto.readFixed32(p342, n228)
		elseif v4210 == proto.wireTypes.i64 then
			local v4218

			v4218, n228 = proto.readFixed64(p342, n228)
		else
			error("Unsupported wire type: " .. v4210)
		end
	end

	return v4207
end
function t575.jsonEncode(p343) -- line: 23288
	local t577 = {}

	if p343.id ~= nil and p343.id ~= "" then
		t577.id = p343.id
	end

	if p343.display_name ~= nil and p343.display_name ~= "" then
		t577.displayName = p343.display_name
	end

	if p343.is_selected then
		t577.isSelected = p343.is_selected
	end

	return t577
end
function t575.jsonDecode(t578: {[any]: any}) -- line: 23306
	-- upvalues: t575 (copy)
	local v4222 = t575.new()

	if t578.id ~= nil then
		v4222.id = t578.id
	end

	if t578.display_name ~= nil then
		v4222.display_name = t578.display_name
	end

	if t578.displayName ~= nil then
		v4222.display_name = t578.displayName
	end

	if t578.is_selected ~= nil then
		v4222.is_selected = t578.is_selected
	end

	if t578.isSelected ~= nil then
		v4222.is_selected = t578.isSelected
	end

	return v4222
end

t575.descriptor = {
	name = "SelectorOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.SelectorOption"
}
t1.SelectorOption = t575
typeRegistry.default:register(t1.SelectorOption)

local t579 = {}

t579.__index = t579

function t579.new(t580: {[any]: any}?) -- line: 23346
	-- upvalues: t579 (copy)
	return (setmetatable({
		layout = if t580 ~= nil and t580.layout ~= nil then t580.layout else nil,
		kind = if t580 ~= nil and t580.kind ~= nil then t580.kind else nil
	}, t579))
end
function t579.encode(p344) -- line: 23353
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n229 = 0

	if p344.layout ~= nil then
		local v4227 = p344.layout:encode()
		local v4228, v4229 = proto.writeTag(buf, n229, 1, proto.wireTypes.lengthDelimited)

		buf, n229 = proto.writeBuffer(v4228, v4229, v4227, buffer.len(v4227))
	end

	if p344.kind ~= nil and p344.kind.type == "universe" then
		local v4230 = p344.kind.value:encode()
		local v4231, v4232 = proto.writeTag(buf, n229, 2, proto.wireTypes.lengthDelimited)

		buf, n229 = proto.writeBuffer(v4231, v4232, v4230, buffer.len(v4230))
	end

	local buf127 = buffer.create(n229)

	buffer.copy(buf127, 0, buf, 0, n229)

	return buf127
end
function t579.decode(p345: buffer) -- line: 23376
	-- upvalues: t579 (copy), proto (copy), t1 (copy)
	local v4235 = t579.new()
	local n230 = 0

	while n230 < buffer.len(p345) do
		local v4237, v4238

		v4237, v4238, n230 = proto.readTag(p345, n230)

		if v4238 == proto.wireTypes.varint then
			local v4239

			v4239, n230 = proto.readVarInt(p345, n230)
		elseif v4238 == proto.wireTypes.lengthDelimited then
			if v4237 == 1 then
				local v4240

				v4240, n230 = proto.readBuffer(p345, n230)
				v4235.layout = t1.ItemLayout.decode(v4240)
			elseif v4237 == 2 then
				local v4241

				v4241, n230 = proto.readBuffer(p345, n230)
				v4235.kind = {
					type = "universe",
					value = t1.ExperienceCarouselInputData_UniverseItem.decode(v4241)
				}
			else
				local v4242, v4243 = proto.readVarInt(p345, n230)

				n230 = v4243 + v4242
			end
		elseif v4238 == proto.wireTypes.i32 then
			local v4244

			v4244, n230 = proto.readFixed32(p345, n230)
		elseif v4238 == proto.wireTypes.i64 then
			local v4245

			v4245, n230 = proto.readFixed64(p345, n230)
		else
			error("Unsupported wire type: " .. v4238)
		end
	end

	return v4235
end
function t579.jsonEncode(p346) -- line: 23425
	local t581 = {}

	if p346.layout ~= nil then
		t581.layout = p346.layout:jsonEncode()
	end

	if p346.kind ~= nil and p346.kind.type == "universe" then
		t581.universe = p346.kind.value:jsonEncode()
	end

	return t581
end
function t579.jsonDecode(t582: {[any]: any}) -- line: 23441
	-- upvalues: t579 (copy), t1 (copy)
	local v4249 = t579.new()

	if t582.layout ~= nil then
		v4249.layout = t1.ItemLayout.jsonDecode(t582.layout)
	end

	if t582.universe ~= nil then
		v4249.kind = {
			type = "universe",
			value = t1.ExperienceCarouselInputData_UniverseItem.jsonDecode(t582.universe)
		}
	end

	return v4249
end

t579.descriptor = {
	name = "ItemWithLayout",
	fullName = "roblox.apppageplatform.shared.v1beta1.ItemWithLayout"
}
t1.ItemWithLayout = t579
typeRegistry.default:register(t1.ItemWithLayout)

local t583 = {}

t583.__index = t583

function t583.new(t584: {[any]: any}?) -- line: 23472
	-- upvalues: t583 (copy)
	return (setmetatable({
		items = if t584 ~= nil and t584.items ~= nil then t584.items else {},
		collection_item_size = if t584 ~= nil and t584.collection_item_size ~= nil then t584.collection_item_size else nil
	}, t583))
end
function t583.encode(p347) -- line: 23481
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n231 = 0

	if p347.items ~= nil and #p347.items > 0 then
		for _, v4255 in p347.items do
			local v4256 = v4255:encode()
			local v4257, v4258 = proto.writeTag(buf, n231, 1, proto.wireTypes.lengthDelimited)

			buf, n231 = proto.writeBuffer(v4257, v4258, v4256, buffer.len(v4256))
		end
	end

	if p347.collection_item_size ~= nil then
		local v4259, v4260 = proto.writeTag(buf, n231, 2, proto.wireTypes.lengthDelimited)

		buf, n231 = proto.writeString(v4259, v4260, p347.collection_item_size)
	end

	local buf128 = buffer.create(n231)

	buffer.copy(buf128, 0, buf, 0, n231)

	return buf128
end
function t583.decode(p348: buffer) -- line: 23503
	-- upvalues: t583 (copy), proto (copy), t1 (copy)
	local v4263 = t583.new()
	local n232 = 0

	while n232 < buffer.len(p348) do
		local v4265, v4266

		v4265, v4266, n232 = proto.readTag(p348, n232)

		if v4266 == proto.wireTypes.varint then
			local v4267

			v4267, n232 = proto.readVarInt(p348, n232)
		elseif v4266 == proto.wireTypes.lengthDelimited then
			if v4265 == 1 then
				local v4268

				v4268, n232 = proto.readBuffer(p348, n232)
				table.insert(v4263.items, t1.ItemWithLayout.decode(v4268))
			elseif v4265 == 2 then
				local v4269

				v4269, n232 = proto.readBuffer(p348, n232)
				v4263.collection_item_size = buffer.tostring(v4269)
			else
				local v4270, v4271 = proto.readVarInt(p348, n232)

				n232 = v4271 + v4270
			end
		elseif v4266 == proto.wireTypes.i32 then
			local v4272

			v4272, n232 = proto.readFixed32(p348, n232)
		elseif v4266 == proto.wireTypes.i64 then
			local v4273

			v4273, n232 = proto.readFixed64(p348, n232)
		else
			error("Unsupported wire type: " .. v4266)
		end
	end

	return v4263
end
function t583.jsonEncode(p349) -- line: 23551
	local t585 = {}

	if p349.items ~= nil and #p349.items > 0 then
		local t586 = {}

		for _, v4278 in p349.items do
			table.insert(t586, v4278:jsonEncode())
		end

		t585.items = t586
	end

	if p349.collection_item_size ~= nil then
		t585.collectionItemSize = p349.collection_item_size
	end

	return t585
end
function t583.jsonDecode(t587: {[any]: any}) -- line: 23569
	-- upvalues: t583 (copy), t1 (copy)
	local v4280 = t583.new()

	if t587.items ~= nil then
		local t588 = {}

		for _, v4283 in t587.items do
			table.insert(t588, t1.ItemWithLayout.jsonDecode(v4283))
		end

		v4280.items = t588
	end

	if t587.collection_item_size ~= nil then
		v4280.collection_item_size = t587.collection_item_size
	end

	if t587.collectionItemSize ~= nil then
		v4280.collection_item_size = t587.collectionItemSize
	end

	return v4280
end

t583.descriptor = {
	name = "ContentPool",
	fullName = "roblox.apppageplatform.shared.v1beta1.ContentPool"
}
t1.ContentPool = t583
typeRegistry.default:register(t1.ContentPool)

local t589 = {}

t589.__index = t589

function t589.new(t590: {[any]: any}?) -- line: 23606
	-- upvalues: t589 (copy)
	return (setmetatable({
		col_span = if t590 ~= nil and t590.col_span ~= nil then t590.col_span else 0,
		row_span = if t590 ~= nil and t590.row_span ~= nil then t590.row_span else 0,
		alignment_type = if t590 ~= nil and t590.alignment_type ~= nil then t590.alignment_type else "",
		min_row_padding = if t590 ~= nil and t590.min_row_padding ~= nil then t590.min_row_padding else 0
	}, t589))
end
function t589.encode(p350) -- line: 23615
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n233 = 0

	if p350.col_span ~= nil and p350.col_span ~= 0 then
		local v4288, v4289 = proto.writeTag(buf, n233, 1, proto.wireTypes.varint)

		buf, n233 = proto.writeVarInt(v4288, v4289, p350.col_span)
	end

	if p350.row_span ~= nil and p350.row_span ~= 0 then
		local v4290, v4291 = proto.writeTag(buf, n233, 2, proto.wireTypes.varint)

		buf, n233 = proto.writeVarInt(v4290, v4291, p350.row_span)
	end

	if p350.alignment_type ~= nil and p350.alignment_type ~= "" then
		local v4292, v4293 = proto.writeTag(buf, n233, 3, proto.wireTypes.lengthDelimited)

		buf, n233 = proto.writeString(v4292, v4293, p350.alignment_type)
	end

	if p350.min_row_padding ~= nil and p350.min_row_padding ~= 0 then
		local v4294, v4295 = proto.writeTag(buf, n233, 4, proto.wireTypes.varint)

		buf, n233 = proto.writeVarInt(v4294, v4295, p350.min_row_padding)
	end

	local buf129 = buffer.create(n233)

	buffer.copy(buf129, 0, buf, 0, n233)

	return buf129
end
function t589.decode(p351: buffer) -- line: 23644
	-- upvalues: t589 (copy), proto (copy)
	local v4298 = t589.new()
	local n234 = 0

	while n234 < buffer.len(p351) do
		local v4300, v4301

		v4300, v4301, n234 = proto.readTag(p351, n234)

		if v4301 == proto.wireTypes.varint then
			if v4300 == 1 then
				local v4302

				v4302, n234 = proto.readVarIntI32(p351, n234)
				v4298.col_span = v4302
			elseif v4300 == 2 then
				local v4303

				v4303, n234 = proto.readVarIntI32(p351, n234)
				v4298.row_span = v4303
			elseif v4300 == 4 then
				local v4304

				v4304, n234 = proto.readVarIntI32(p351, n234)
				v4298.min_row_padding = v4304
			else
				local v4305

				v4305, n234 = proto.readVarInt(p351, n234)
			end
		elseif v4301 == proto.wireTypes.lengthDelimited then
			if v4300 == 3 then
				local v4306

				v4306, n234 = proto.readBuffer(p351, n234)
				v4298.alignment_type = buffer.tostring(v4306)
			else
				local v4307, v4308 = proto.readVarInt(p351, n234)

				n234 = v4308 + v4307
			end
		elseif v4301 == proto.wireTypes.i32 then
			local v4309

			v4309, n234 = proto.readFixed32(p351, n234)
		elseif v4301 == proto.wireTypes.i64 then
			local v4310

			v4310, n234 = proto.readFixed64(p351, n234)
		else
			error("Unsupported wire type: " .. v4301)
		end
	end

	return v4298
end
function t589.jsonEncode(p352) -- line: 23702
	local t591 = {}

	if p352.col_span ~= nil and p352.col_span ~= 0 then
		t591.colSpan = p352.col_span
	end

	if p352.row_span ~= nil and p352.row_span ~= 0 then
		t591.rowSpan = p352.row_span
	end

	if p352.alignment_type ~= nil and p352.alignment_type ~= "" then
		t591.alignmentType = p352.alignment_type
	end

	if p352.min_row_padding ~= nil and p352.min_row_padding ~= 0 then
		t591.minRowPadding = p352.min_row_padding
	end

	return t591
end
function t589.jsonDecode(t592: {[any]: any}) -- line: 23724
	-- upvalues: t589 (copy)
	local v4314 = t589.new()

	if t592.col_span ~= nil then
		v4314.col_span = t592.col_span
	end

	if t592.colSpan ~= nil then
		v4314.col_span = t592.colSpan
	end

	if t592.row_span ~= nil then
		v4314.row_span = t592.row_span
	end

	if t592.rowSpan ~= nil then
		v4314.row_span = t592.rowSpan
	end

	if t592.alignment_type ~= nil then
		v4314.alignment_type = t592.alignment_type
	end

	if t592.alignmentType ~= nil then
		v4314.alignment_type = t592.alignmentType
	end

	if t592.min_row_padding ~= nil then
		v4314.min_row_padding = t592.min_row_padding
	end

	if t592.minRowPadding ~= nil then
		v4314.min_row_padding = t592.minRowPadding
	end

	return v4314
end

t589.descriptor = {
	name = "ItemLayout",
	fullName = "roblox.apppageplatform.shared.v1beta1.ItemLayout"
}
t1.ItemLayout = t589
typeRegistry.default:register(t1.ItemLayout)
t1.PageEntryFormat = {
	fromNumber = function(n235: number) -- line: 23773
		if n235 == 0 then
			return "PAGE_ENTRY_FORMAT_INVALID"
		end

		if n235 == 1 then
			return "PAGE_ENTRY_FORMAT_UNIVERSAL"
		end

		return nil
	end,
	toNumber = function(p353) -- line: 23783
		if p353 == "PAGE_ENTRY_FORMAT_INVALID" then
			return 0
		end

		if p353 == "PAGE_ENTRY_FORMAT_UNIVERSAL" then
			return 1
		end

		return p353
	end,
	fromName = function(s2: string) -- line: 23793
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
	CommunitiesCardClientAttributes = t1.CommunitiesCardClientAttributes,
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
	CtaButtonsInputData = t1.CtaButtonsInputData,
	ImageInputData = t1.ImageInputData,
	VideoInputData = t1.VideoInputData,
	TextInputData = t1.TextInputData,
	VerticalFeedInputData = t1.VerticalFeedInputData,
	PageHeaderInputData = t1.PageHeaderInputData,
	PreAuthLandingStickyHeaderInputData = t1.PreAuthLandingStickyHeaderInputData,
	OptionSelectorCarouselInputData = t1.OptionSelectorCarouselInputData,
	SelectorOption = t1.SelectorOption,
	ItemWithLayout = t1.ItemWithLayout,
	ContentPool = t1.ContentPool,
	ItemLayout = t1.ItemLayout,
	PageEntryFormat = t1.PageEntryFormat
}
