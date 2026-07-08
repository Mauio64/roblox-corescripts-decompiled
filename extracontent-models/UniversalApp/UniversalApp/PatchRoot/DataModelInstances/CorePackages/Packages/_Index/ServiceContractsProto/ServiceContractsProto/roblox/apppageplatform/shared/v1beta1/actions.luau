local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local prop_condition = require(script.Parent.prop_condition)
local prop_types = require(script.Parent.prop_types)
local prop_types_engine = require(script.Parent.prop_types_engine)
local share_link_data = require(script.Parent.share_link_data)
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 4969
	-- upvalues: t1 (copy), t2 (copy)
	return (setmetatable({
		action_type = if t3 ~= nil and t3.action_type ~= nil then t3.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t3 ~= nil and t3.action_params ~= nil then t3.action_params else nil
	}, t2))
end
function t2.encode(p1) -- line: 4978
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.action_type ~= nil and (p1.action_type ~= nil and p1.action_type ~= 0 or p1.action_type ~= t1.ActionType.fromNumber(0)) then
		local v169, v170 = proto.writeTag(buf, n1, 1, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v169, v170, t1.ActionType.toNumber(p1.action_type))
	end

	if p1.action_params ~= nil then
		local v171 = p1.action_params:encode()
		local v172, v173 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeBuffer(v172, v173, v171, buffer.len(v171))
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 5004
	-- upvalues: t2 (copy), proto (copy), t1 (copy)
	local v176 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v178, v179

		v178, v179, n2 = proto.readTag(p2, n2)

		if v179 == proto.wireTypes.varint then
			if v178 == 1 then
				local v180

				v180, n2 = proto.readVarIntI32(p2, n2)
				v176.action_type = t1.ActionType.fromNumber(v180) or v180
			else
				local v181

				v181, n2 = proto.readVarInt(p2, n2)
			end
		elseif v179 == proto.wireTypes.lengthDelimited then
			if v178 == 2 then
				local v182

				v182, n2 = proto.readBuffer(p2, n2)
				v176.action_params = t1.DismissDialogAction_Params.decode(v182)
			else
				local v183, v184 = proto.readVarInt(p2, n2)

				n2 = v184 + v183
			end
		elseif v179 == proto.wireTypes.i32 then
			local v185

			v185, n2 = proto.readFixed32(p2, n2)
		elseif v179 == proto.wireTypes.i64 then
			local v186

			v186, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v179)
		end
	end

	return v176
end
function t2.jsonEncode(p3) -- line: 5052
	-- upvalues: t1 (copy)
	local t4 = {}

	if p3.action_type ~= nil and (p3.action_type ~= nil and p3.action_type ~= 0 or p3.action_type ~= t1.ActionType.fromNumber(0)) then
		t4.actionType = if typeof(p3.action_type) ~= "number" then t1.ActionType.toNumber(p3.action_type) else p3.action_type
	end

	if p3.action_params ~= nil then
		t4.actionParams = p3.action_params:jsonEncode()
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 5074
	-- upvalues: t2 (copy), t1 (copy)
	local v190 = t2.new()

	if t5.action_type ~= nil then
		v190.action_type = if typeof(t5.action_type) ~= "number" then t1.ActionType.fromName(t5.action_type) or t5.action_type else t1.ActionType.fromNumber(t5.action_type) or t5.action_type
	end

	if t5.actionType ~= nil then
		v190.action_type = if typeof(t5.actionType) ~= "number" then t1.ActionType.fromName(t5.actionType) or t5.actionType else t1.ActionType.fromNumber(t5.actionType) or t5.actionType
	end

	if t5.action_params ~= nil then
		v190.action_params = t1.DismissDialogAction_Params.jsonDecode(t5.action_params)
	end

	if t5.actionParams ~= nil then
		v190.action_params = t1.DismissDialogAction_Params.jsonDecode(t5.actionParams)
	end

	return v190
end

t2.descriptor = {
	name = "DismissDialogAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.DismissDialogAction"
}
t1.DismissDialogAction = t2
typeRegistry.default:register(t1.DismissDialogAction)

local t6 = {}

t6.__index = t6

function t6.new(t7: {[any]: any}?) -- line: 5114
	-- upvalues: t6 (copy)
	return (setmetatable({
		dialog_type = if t7 ~= nil and t7.dialog_type ~= nil then t7.dialog_type else nil
	}, t6))
end
function t6.encode(p4) -- line: 5122
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n3 = 0

	if p4.dialog_type ~= nil then
		local v195 = p4.dialog_type:encode()
		local v196, v197 = proto.writeTag(buf, n3, 1, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeBuffer(v196, v197, v195, buffer.len(v195))
	end

	local buf3 = buffer.create(n3)

	buffer.copy(buf3, 0, buf, 0, n3)

	return buf3
end
function t6.decode(p5: buffer) -- line: 5137
	-- upvalues: t6 (copy), proto (copy), prop_types (copy)
	local v200 = t6.new()
	local n4 = 0

	while n4 < buffer.len(p5) do
		local v202, v203

		v202, v203, n4 = proto.readTag(p5, n4)

		if v203 == proto.wireTypes.varint then
			local v204

			v204, n4 = proto.readVarInt(p5, n4)
		elseif v203 == proto.wireTypes.lengthDelimited then
			if v202 == 1 then
				local v205

				v205, n4 = proto.readBuffer(p5, n4)
				v200.dialog_type = prop_types.StringProp.decode(v205)
			else
				local v206, v207 = proto.readVarInt(p5, n4)

				n4 = v207 + v206
			end
		elseif v203 == proto.wireTypes.i32 then
			local v208

			v208, n4 = proto.readFixed32(p5, n4)
		elseif v203 == proto.wireTypes.i64 then
			local v209

			v209, n4 = proto.readFixed64(p5, n4)
		else
			error("Unsupported wire type: " .. v203)
		end
	end

	return v200
end
function t6.jsonEncode(p6) -- line: 5180
	local t8 = {}

	if p6.dialog_type ~= nil then
		t8.dialogType = p6.dialog_type:jsonEncode()
	end

	return t8
end
function t6.jsonDecode(t9: {[any]: any}) -- line: 5190
	-- upvalues: t6 (copy), prop_types (copy)
	local v213 = t6.new()

	if t9.dialog_type ~= nil then
		v213.dialog_type = prop_types.StringProp.jsonDecode(t9.dialog_type)
	end

	if t9.dialogType ~= nil then
		v213.dialog_type = prop_types.StringProp.jsonDecode(t9.dialogType)
	end

	return v213
end

t6.descriptor = {
	name = "DismissDialogAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.DismissDialogAction_Params = t6
typeRegistry.default:register(t1.DismissDialogAction_Params)

local t10 = {}

t10.__index = t10

function t10.new(t11: {[any]: any}?) -- line: 5219
	-- upvalues: t1 (copy), t10 (copy)
	return (setmetatable({
		action_type = if t11 ~= nil and t11.action_type ~= nil then t11.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t11 ~= nil and t11.action_params ~= nil then t11.action_params else nil
	}, t10))
end
function t10.encode(p7) -- line: 5228
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n5 = 0

	if p7.action_type ~= nil and (p7.action_type ~= nil and p7.action_type ~= 0 or p7.action_type ~= t1.ActionType.fromNumber(0)) then
		local v218, v219 = proto.writeTag(buf, n5, 1, proto.wireTypes.varint)

		buf, n5 = proto.writeVarInt(v218, v219, t1.ActionType.toNumber(p7.action_type))
	end

	if p7.action_params ~= nil then
		local v220 = p7.action_params:encode()
		local v221, v222 = proto.writeTag(buf, n5, 2, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeBuffer(v221, v222, v220, buffer.len(v220))
	end

	local buf4 = buffer.create(n5)

	buffer.copy(buf4, 0, buf, 0, n5)

	return buf4
end
function t10.decode(p8: buffer) -- line: 5254
	-- upvalues: t10 (copy), proto (copy), t1 (copy)
	local v225 = t10.new()
	local n6 = 0

	while n6 < buffer.len(p8) do
		local v227, v228

		v227, v228, n6 = proto.readTag(p8, n6)

		if v228 == proto.wireTypes.varint then
			if v227 == 1 then
				local v229

				v229, n6 = proto.readVarIntI32(p8, n6)
				v225.action_type = t1.ActionType.fromNumber(v229) or v229
			else
				local v230

				v230, n6 = proto.readVarInt(p8, n6)
			end
		elseif v228 == proto.wireTypes.lengthDelimited then
			if v227 == 2 then
				local v231

				v231, n6 = proto.readBuffer(p8, n6)
				v225.action_params = t1.LinkAction_Params.decode(v231)
			else
				local v232, v233 = proto.readVarInt(p8, n6)

				n6 = v233 + v232
			end
		elseif v228 == proto.wireTypes.i32 then
			local v234

			v234, n6 = proto.readFixed32(p8, n6)
		elseif v228 == proto.wireTypes.i64 then
			local v235

			v235, n6 = proto.readFixed64(p8, n6)
		else
			error("Unsupported wire type: " .. v228)
		end
	end

	return v225
end
function t10.jsonEncode(p9) -- line: 5302
	-- upvalues: t1 (copy)
	local t12 = {}

	if p9.action_type ~= nil and (p9.action_type ~= nil and p9.action_type ~= 0 or p9.action_type ~= t1.ActionType.fromNumber(0)) then
		t12.actionType = if typeof(p9.action_type) ~= "number" then t1.ActionType.toNumber(p9.action_type) else p9.action_type
	end

	if p9.action_params ~= nil then
		t12.actionParams = p9.action_params:jsonEncode()
	end

	return t12
end
function t10.jsonDecode(t13: {[any]: any}) -- line: 5324
	-- upvalues: t10 (copy), t1 (copy)
	local v239 = t10.new()

	if t13.action_type ~= nil then
		v239.action_type = if typeof(t13.action_type) ~= "number" then t1.ActionType.fromName(t13.action_type) or t13.action_type else t1.ActionType.fromNumber(t13.action_type) or t13.action_type
	end

	if t13.actionType ~= nil then
		v239.action_type = if typeof(t13.actionType) ~= "number" then t1.ActionType.fromName(t13.actionType) or t13.actionType else t1.ActionType.fromNumber(t13.actionType) or t13.actionType
	end

	if t13.action_params ~= nil then
		v239.action_params = t1.LinkAction_Params.jsonDecode(t13.action_params)
	end

	if t13.actionParams ~= nil then
		v239.action_params = t1.LinkAction_Params.jsonDecode(t13.actionParams)
	end

	return v239
end

t10.descriptor = {
	name = "LinkAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.LinkAction"
}
t1.LinkAction = t10
typeRegistry.default:register(t1.LinkAction)

local t14 = {}

t14.__index = t14

function t14.new(t15: {[any]: any}?) -- line: 5364
	-- upvalues: t14 (copy)
	return (setmetatable({
		url = if t15 ~= nil and t15.url ~= nil then t15.url else nil,
		title_key = if t15 ~= nil and t15.title_key ~= nil then t15.title_key else nil,
		on_webview_close = if t15 ~= nil and t15.on_webview_close ~= nil then t15.on_webview_close else nil
	}, t14))
end
function t14.encode(p10) -- line: 5372
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n7 = 0

	if p10.url ~= nil then
		local v244 = p10.url:encode()
		local v245, v246 = proto.writeTag(buf, n7, 1, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeBuffer(v245, v246, v244, buffer.len(v244))
	end

	if p10.title_key ~= nil then
		local v247 = p10.title_key:encode()
		local v248, v249 = proto.writeTag(buf, n7, 2, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeBuffer(v248, v249, v247, buffer.len(v247))
	end

	if p10.on_webview_close ~= nil then
		local v250 = p10.on_webview_close:encode()
		local v251, v252 = proto.writeTag(buf, n7, 4, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeBuffer(v251, v252, v250, buffer.len(v250))
	end

	local buf5 = buffer.create(n7)

	buffer.copy(buf5, 0, buf, 0, n7)

	return buf5
end
function t14.decode(p11: buffer) -- line: 5399
	-- upvalues: t14 (copy), proto (copy), prop_types (copy), t1 (copy)
	local v255 = t14.new()
	local n8 = 0

	while n8 < buffer.len(p11) do
		local v257, v258

		v257, v258, n8 = proto.readTag(p11, n8)

		if v258 == proto.wireTypes.varint then
			local v259

			v259, n8 = proto.readVarInt(p11, n8)
		elseif v258 == proto.wireTypes.lengthDelimited then
			if v257 == 1 then
				local v260

				v260, n8 = proto.readBuffer(p11, n8)
				v255.url = prop_types.StringProp.decode(v260)
			elseif v257 == 2 then
				local v261

				v261, n8 = proto.readBuffer(p11, n8)
				v255.title_key = prop_types.StringProp.decode(v261)
			elseif v257 == 4 then
				local v262

				v262, n8 = proto.readBuffer(p11, n8)
				v255.on_webview_close = t1.ActionProp.decode(v262)
			else
				local v263, v264 = proto.readVarInt(p11, n8)

				n8 = v264 + v263
			end
		elseif v258 == proto.wireTypes.i32 then
			local v265

			v265, n8 = proto.readFixed32(p11, n8)
		elseif v258 == proto.wireTypes.i64 then
			local v266

			v266, n8 = proto.readFixed64(p11, n8)
		else
			error("Unsupported wire type: " .. v258)
		end
	end

	return v255
end
function t14.jsonEncode(p12) -- line: 5452
	local t16 = {}

	if p12.url ~= nil then
		t16.url = p12.url:jsonEncode()
	end

	if p12.title_key ~= nil then
		t16.titleKey = p12.title_key:jsonEncode()
	end

	if p12.on_webview_close ~= nil then
		t16.onWebviewClose = p12.on_webview_close:jsonEncode()
	end

	return t16
end
function t14.jsonDecode(t17: {[any]: any}) -- line: 5470
	-- upvalues: t14 (copy), prop_types (copy), t1 (copy)
	local v270 = t14.new()

	if t17.url ~= nil then
		v270.url = prop_types.StringProp.jsonDecode(t17.url)
	end

	if t17.title_key ~= nil then
		v270.title_key = prop_types.StringProp.jsonDecode(t17.title_key)
	end

	if t17.titleKey ~= nil then
		v270.title_key = prop_types.StringProp.jsonDecode(t17.titleKey)
	end

	if t17.on_webview_close ~= nil then
		v270.on_webview_close = t1.ActionProp.jsonDecode(t17.on_webview_close)
	end

	if t17.onWebviewClose ~= nil then
		v270.on_webview_close = t1.ActionProp.jsonDecode(t17.onWebviewClose)
	end

	return v270
end

t14.descriptor = {
	name = "LinkAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.LinkAction_Params = t14
typeRegistry.default:register(t1.LinkAction_Params)

local t18 = {}

t18.__index = t18

function t18.new(t19: {[any]: any}?) -- line: 5510
	-- upvalues: t1 (copy), t18 (copy)
	return (setmetatable({
		action_type = if t19 ~= nil and t19.action_type ~= nil then t19.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t19 ~= nil and t19.action_params ~= nil then t19.action_params else nil
	}, t18))
end
function t18.encode(p13) -- line: 5519
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n9 = 0

	if p13.action_type ~= nil and (p13.action_type ~= nil and p13.action_type ~= 0 or p13.action_type ~= t1.ActionType.fromNumber(0)) then
		local v275, v276 = proto.writeTag(buf, n9, 1, proto.wireTypes.varint)

		buf, n9 = proto.writeVarInt(v275, v276, t1.ActionType.toNumber(p13.action_type))
	end

	if p13.action_params ~= nil then
		local v277 = p13.action_params:encode()
		local v278, v279 = proto.writeTag(buf, n9, 2, proto.wireTypes.lengthDelimited)

		buf, n9 = proto.writeBuffer(v278, v279, v277, buffer.len(v277))
	end

	local buf6 = buffer.create(n9)

	buffer.copy(buf6, 0, buf, 0, n9)

	return buf6
end
function t18.decode(p14: buffer) -- line: 5545
	-- upvalues: t18 (copy), proto (copy), t1 (copy)
	local v282 = t18.new()
	local n10 = 0

	while n10 < buffer.len(p14) do
		local v284, v285

		v284, v285, n10 = proto.readTag(p14, n10)

		if v285 == proto.wireTypes.varint then
			if v284 == 1 then
				local v286

				v286, n10 = proto.readVarIntI32(p14, n10)
				v282.action_type = t1.ActionType.fromNumber(v286) or v286
			else
				local v287

				v287, n10 = proto.readVarInt(p14, n10)
			end
		elseif v285 == proto.wireTypes.lengthDelimited then
			if v284 == 2 then
				local v288

				v288, n10 = proto.readBuffer(p14, n10)
				v282.action_params = t1.OpenSocialLinkAction_Params.decode(v288)
			else
				local v289, v290 = proto.readVarInt(p14, n10)

				n10 = v290 + v289
			end
		elseif v285 == proto.wireTypes.i32 then
			local v291

			v291, n10 = proto.readFixed32(p14, n10)
		elseif v285 == proto.wireTypes.i64 then
			local v292

			v292, n10 = proto.readFixed64(p14, n10)
		else
			error("Unsupported wire type: " .. v285)
		end
	end

	return v282
end
function t18.jsonEncode(p15) -- line: 5593
	-- upvalues: t1 (copy)
	local t20 = {}

	if p15.action_type ~= nil and (p15.action_type ~= nil and p15.action_type ~= 0 or p15.action_type ~= t1.ActionType.fromNumber(0)) then
		t20.actionType = if typeof(p15.action_type) ~= "number" then t1.ActionType.toNumber(p15.action_type) else p15.action_type
	end

	if p15.action_params ~= nil then
		t20.actionParams = p15.action_params:jsonEncode()
	end

	return t20
end
function t18.jsonDecode(t21: {[any]: any}) -- line: 5615
	-- upvalues: t18 (copy), t1 (copy)
	local v296 = t18.new()

	if t21.action_type ~= nil then
		v296.action_type = if typeof(t21.action_type) ~= "number" then t1.ActionType.fromName(t21.action_type) or t21.action_type else t1.ActionType.fromNumber(t21.action_type) or t21.action_type
	end

	if t21.actionType ~= nil then
		v296.action_type = if typeof(t21.actionType) ~= "number" then t1.ActionType.fromName(t21.actionType) or t21.actionType else t1.ActionType.fromNumber(t21.actionType) or t21.actionType
	end

	if t21.action_params ~= nil then
		v296.action_params = t1.OpenSocialLinkAction_Params.jsonDecode(t21.action_params)
	end

	if t21.actionParams ~= nil then
		v296.action_params = t1.OpenSocialLinkAction_Params.jsonDecode(t21.actionParams)
	end

	return v296
end

t18.descriptor = {
	name = "OpenSocialLinkAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.OpenSocialLinkAction"
}
t1.OpenSocialLinkAction = t18
typeRegistry.default:register(t1.OpenSocialLinkAction)

local t22 = {}

t22.__index = t22

function t22.new(t23: {[any]: any}?) -- line: 5655
	-- upvalues: t22 (copy)
	return (setmetatable({
		assignment_id = if t23 ~= nil and t23.assignment_id ~= nil then t23.assignment_id else nil,
		assignment_type = if t23 ~= nil and t23.assignment_type ~= nil then t23.assignment_type else nil,
		social_link_type = if t23 ~= nil and t23.social_link_type ~= nil then t23.social_link_type else nil,
		social_link_url = if t23 ~= nil and t23.social_link_url ~= nil then t23.social_link_url else nil,
		social_link_display_type = if t23 ~= nil and t23.social_link_display_type ~= nil then t23.social_link_display_type else nil
	}, t22))
end
function t22.encode(p16) -- line: 5669
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n11 = 0

	if p16.assignment_id ~= nil then
		local v301 = p16.assignment_id:encode()
		local v302, v303 = proto.writeTag(buf, n11, 1, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeBuffer(v302, v303, v301, buffer.len(v301))
	end

	if p16.assignment_type ~= nil then
		local v304 = p16.assignment_type:encode()
		local v305, v306 = proto.writeTag(buf, n11, 2, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeBuffer(v305, v306, v304, buffer.len(v304))
	end

	if p16.social_link_type ~= nil then
		local v307 = p16.social_link_type:encode()
		local v308, v309 = proto.writeTag(buf, n11, 3, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeBuffer(v308, v309, v307, buffer.len(v307))
	end

	if p16.social_link_url ~= nil then
		local v310 = p16.social_link_url:encode()
		local v311, v312 = proto.writeTag(buf, n11, 4, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeBuffer(v311, v312, v310, buffer.len(v310))
	end

	if p16.social_link_display_type ~= nil then
		local v313 = p16.social_link_display_type:encode()
		local v314, v315 = proto.writeTag(buf, n11, 5, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeBuffer(v314, v315, v313, buffer.len(v313))
	end

	local buf7 = buffer.create(n11)

	buffer.copy(buf7, 0, buf, 0, n11)

	return buf7
end
function t22.decode(p17: buffer) -- line: 5708
	-- upvalues: t22 (copy), proto (copy), prop_types (copy)
	local v318 = t22.new()
	local n12 = 0

	while n12 < buffer.len(p17) do
		local v320, v321

		v320, v321, n12 = proto.readTag(p17, n12)

		if v321 == proto.wireTypes.varint then
			local v322

			v322, n12 = proto.readVarInt(p17, n12)
		elseif v321 == proto.wireTypes.lengthDelimited then
			if v320 == 1 then
				local v323

				v323, n12 = proto.readBuffer(p17, n12)
				v318.assignment_id = prop_types.StringProp.decode(v323)
			elseif v320 == 2 then
				local v324

				v324, n12 = proto.readBuffer(p17, n12)
				v318.assignment_type = prop_types.StringProp.decode(v324)
			elseif v320 == 3 then
				local v325

				v325, n12 = proto.readBuffer(p17, n12)
				v318.social_link_type = prop_types.StringProp.decode(v325)
			elseif v320 == 4 then
				local v326

				v326, n12 = proto.readBuffer(p17, n12)
				v318.social_link_url = prop_types.StringProp.decode(v326)
			elseif v320 == 5 then
				local v327

				v327, n12 = proto.readBuffer(p17, n12)
				v318.social_link_display_type = prop_types.StringProp.decode(v327)
			else
				local v328, v329 = proto.readVarInt(p17, n12)

				n12 = v329 + v328
			end
		elseif v321 == proto.wireTypes.i32 then
			local v330

			v330, n12 = proto.readFixed32(p17, n12)
		elseif v321 == proto.wireTypes.i64 then
			local v331

			v331, n12 = proto.readFixed64(p17, n12)
		else
			error("Unsupported wire type: " .. v321)
		end
	end

	return v318
end
function t22.jsonEncode(p18) -- line: 5772
	local t24 = {}

	if p18.assignment_id ~= nil then
		t24.assignmentId = p18.assignment_id:jsonEncode()
	end

	if p18.assignment_type ~= nil then
		t24.assignmentType = p18.assignment_type:jsonEncode()
	end

	if p18.social_link_type ~= nil then
		t24.socialLinkType = p18.social_link_type:jsonEncode()
	end

	if p18.social_link_url ~= nil then
		t24.socialLinkUrl = p18.social_link_url:jsonEncode()
	end

	if p18.social_link_display_type ~= nil then
		t24.socialLinkDisplayType = p18.social_link_display_type:jsonEncode()
	end

	return t24
end
function t22.jsonDecode(t25: {[any]: any}) -- line: 5798
	-- upvalues: t22 (copy), prop_types (copy)
	local v335 = t22.new()

	if t25.assignment_id ~= nil then
		v335.assignment_id = prop_types.StringProp.jsonDecode(t25.assignment_id)
	end

	if t25.assignmentId ~= nil then
		v335.assignment_id = prop_types.StringProp.jsonDecode(t25.assignmentId)
	end

	if t25.assignment_type ~= nil then
		v335.assignment_type = prop_types.StringProp.jsonDecode(t25.assignment_type)
	end

	if t25.assignmentType ~= nil then
		v335.assignment_type = prop_types.StringProp.jsonDecode(t25.assignmentType)
	end

	if t25.social_link_type ~= nil then
		v335.social_link_type = prop_types.StringProp.jsonDecode(t25.social_link_type)
	end

	if t25.socialLinkType ~= nil then
		v335.social_link_type = prop_types.StringProp.jsonDecode(t25.socialLinkType)
	end

	if t25.social_link_url ~= nil then
		v335.social_link_url = prop_types.StringProp.jsonDecode(t25.social_link_url)
	end

	if t25.socialLinkUrl ~= nil then
		v335.social_link_url = prop_types.StringProp.jsonDecode(t25.socialLinkUrl)
	end

	if t25.social_link_display_type ~= nil then
		v335.social_link_display_type = prop_types.StringProp.jsonDecode(t25.social_link_display_type)
	end

	if t25.socialLinkDisplayType ~= nil then
		v335.social_link_display_type = prop_types.StringProp.jsonDecode(t25.socialLinkDisplayType)
	end

	return v335
end

t22.descriptor = {
	name = "OpenSocialLinkAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.OpenSocialLinkAction_Params = t22
typeRegistry.default:register(t1.OpenSocialLinkAction_Params)

local t26 = {}

t26.__index = t26

function t26.new(t27: {[any]: any}?) -- line: 5868
	-- upvalues: t1 (copy), t26 (copy)
	return (setmetatable({
		action_type = if t27 ~= nil and t27.action_type ~= nil then t27.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t27 ~= nil and t27.action_params ~= nil then t27.action_params else nil
	}, t26))
end
function t26.encode(p19) -- line: 5877
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n13 = 0

	if p19.action_type ~= nil and (p19.action_type ~= nil and p19.action_type ~= 0 or p19.action_type ~= t1.ActionType.fromNumber(0)) then
		local v340, v341 = proto.writeTag(buf, n13, 1, proto.wireTypes.varint)

		buf, n13 = proto.writeVarInt(v340, v341, t1.ActionType.toNumber(p19.action_type))
	end

	if p19.action_params ~= nil then
		local v342 = p19.action_params:encode()
		local v343, v344 = proto.writeTag(buf, n13, 2, proto.wireTypes.lengthDelimited)

		buf, n13 = proto.writeBuffer(v343, v344, v342, buffer.len(v342))
	end

	local buf8 = buffer.create(n13)

	buffer.copy(buf8, 0, buf, 0, n13)

	return buf8
end
function t26.decode(p20: buffer) -- line: 5903
	-- upvalues: t26 (copy), proto (copy), t1 (copy)
	local v347 = t26.new()
	local n14 = 0

	while n14 < buffer.len(p20) do
		local v349, v350

		v349, v350, n14 = proto.readTag(p20, n14)

		if v350 == proto.wireTypes.varint then
			if v349 == 1 then
				local v351

				v351, n14 = proto.readVarIntI32(p20, n14)
				v347.action_type = t1.ActionType.fromNumber(v351) or v351
			else
				local v352

				v352, n14 = proto.readVarInt(p20, n14)
			end
		elseif v350 == proto.wireTypes.lengthDelimited then
			if v349 == 2 then
				local v353

				v353, n14 = proto.readBuffer(p20, n14)
				v347.action_params = t1.OpenGameDetailsAction_Params.decode(v353)
			else
				local v354, v355 = proto.readVarInt(p20, n14)

				n14 = v355 + v354
			end
		elseif v350 == proto.wireTypes.i32 then
			local v356

			v356, n14 = proto.readFixed32(p20, n14)
		elseif v350 == proto.wireTypes.i64 then
			local v357

			v357, n14 = proto.readFixed64(p20, n14)
		else
			error("Unsupported wire type: " .. v350)
		end
	end

	return v347
end
function t26.jsonEncode(p21) -- line: 5951
	-- upvalues: t1 (copy)
	local t28 = {}

	if p21.action_type ~= nil and (p21.action_type ~= nil and p21.action_type ~= 0 or p21.action_type ~= t1.ActionType.fromNumber(0)) then
		t28.actionType = if typeof(p21.action_type) ~= "number" then t1.ActionType.toNumber(p21.action_type) else p21.action_type
	end

	if p21.action_params ~= nil then
		t28.actionParams = p21.action_params:jsonEncode()
	end

	return t28
end
function t26.jsonDecode(t29: {[any]: any}) -- line: 5973
	-- upvalues: t26 (copy), t1 (copy)
	local v361 = t26.new()

	if t29.action_type ~= nil then
		v361.action_type = if typeof(t29.action_type) ~= "number" then t1.ActionType.fromName(t29.action_type) or t29.action_type else t1.ActionType.fromNumber(t29.action_type) or t29.action_type
	end

	if t29.actionType ~= nil then
		v361.action_type = if typeof(t29.actionType) ~= "number" then t1.ActionType.fromName(t29.actionType) or t29.actionType else t1.ActionType.fromNumber(t29.actionType) or t29.actionType
	end

	if t29.action_params ~= nil then
		v361.action_params = t1.OpenGameDetailsAction_Params.jsonDecode(t29.action_params)
	end

	if t29.actionParams ~= nil then
		v361.action_params = t1.OpenGameDetailsAction_Params.jsonDecode(t29.actionParams)
	end

	return v361
end

t26.descriptor = {
	name = "OpenGameDetailsAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.OpenGameDetailsAction"
}
t1.OpenGameDetailsAction = t26
typeRegistry.default:register(t1.OpenGameDetailsAction)

local t30 = {}

t30.__index = t30

function t30.new(t31: {[any]: any}?) -- line: 6013
	-- upvalues: t30 (copy)
	return (setmetatable({
		place_id = if t31 ~= nil and t31.place_id ~= nil then t31.place_id else nil,
		universe_id = if t31 ~= nil and t31.universe_id ~= nil then t31.universe_id else nil,
		inherit_referral_session = if t31 ~= nil and t31.inherit_referral_session ~= nil then t31.inherit_referral_session else nil
	}, t30))
end
function t30.encode(p22) -- line: 6025
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n15 = 0

	if p22.place_id ~= nil then
		local v366 = p22.place_id:encode()
		local v367, v368 = proto.writeTag(buf, n15, 1, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeBuffer(v367, v368, v366, buffer.len(v366))
	end

	if p22.universe_id ~= nil then
		local v369 = p22.universe_id:encode()
		local v370, v371 = proto.writeTag(buf, n15, 2, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeBuffer(v370, v371, v369, buffer.len(v369))
	end

	if p22.inherit_referral_session ~= nil then
		local v372 = p22.inherit_referral_session:encode()
		local v373, v374 = proto.writeTag(buf, n15, 3, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeBuffer(v373, v374, v372, buffer.len(v372))
	end

	local buf9 = buffer.create(n15)

	buffer.copy(buf9, 0, buf, 0, n15)

	return buf9
end
function t30.decode(p23: buffer) -- line: 6052
	-- upvalues: t30 (copy), proto (copy), prop_types (copy)
	local v377 = t30.new()
	local n16 = 0

	while n16 < buffer.len(p23) do
		local v379, v380

		v379, v380, n16 = proto.readTag(p23, n16)

		if v380 == proto.wireTypes.varint then
			local v381

			v381, n16 = proto.readVarInt(p23, n16)
		elseif v380 == proto.wireTypes.lengthDelimited then
			if v379 == 1 then
				local v382

				v382, n16 = proto.readBuffer(p23, n16)
				v377.place_id = prop_types.StringProp.decode(v382)
			elseif v379 == 2 then
				local v383

				v383, n16 = proto.readBuffer(p23, n16)
				v377.universe_id = prop_types.StringProp.decode(v383)
			elseif v379 == 3 then
				local v384

				v384, n16 = proto.readBuffer(p23, n16)
				v377.inherit_referral_session = prop_types.BoolProp.decode(v384)
			else
				local v385, v386 = proto.readVarInt(p23, n16)

				n16 = v386 + v385
			end
		elseif v380 == proto.wireTypes.i32 then
			local v387

			v387, n16 = proto.readFixed32(p23, n16)
		elseif v380 == proto.wireTypes.i64 then
			local v388

			v388, n16 = proto.readFixed64(p23, n16)
		else
			error("Unsupported wire type: " .. v380)
		end
	end

	return v377
end
function t30.jsonEncode(p24) -- line: 6106
	local t32 = {}

	if p24.place_id ~= nil then
		t32.placeId = p24.place_id:jsonEncode()
	end

	if p24.universe_id ~= nil then
		t32.universeId = p24.universe_id:jsonEncode()
	end

	if p24.inherit_referral_session ~= nil then
		t32.inheritReferralSession = p24.inherit_referral_session:jsonEncode()
	end

	return t32
end
function t30.jsonDecode(t33: {[any]: any}) -- line: 6124
	-- upvalues: t30 (copy), prop_types (copy)
	local v392 = t30.new()

	if t33.place_id ~= nil then
		v392.place_id = prop_types.StringProp.jsonDecode(t33.place_id)
	end

	if t33.placeId ~= nil then
		v392.place_id = prop_types.StringProp.jsonDecode(t33.placeId)
	end

	if t33.universe_id ~= nil then
		v392.universe_id = prop_types.StringProp.jsonDecode(t33.universe_id)
	end

	if t33.universeId ~= nil then
		v392.universe_id = prop_types.StringProp.jsonDecode(t33.universeId)
	end

	if t33.inherit_referral_session ~= nil then
		v392.inherit_referral_session = prop_types.BoolProp.jsonDecode(t33.inherit_referral_session)
	end

	if t33.inheritReferralSession ~= nil then
		v392.inherit_referral_session = prop_types.BoolProp.jsonDecode(t33.inheritReferralSession)
	end

	return v392
end

t30.descriptor = {
	name = "OpenGameDetailsAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.OpenGameDetailsAction_Params = t30
typeRegistry.default:register(t1.OpenGameDetailsAction_Params)

local t34 = {}

t34.__index = t34

function t34.new(t35: {[any]: any}?) -- line: 6171
	-- upvalues: t1 (copy), t34 (copy)
	return (setmetatable({
		action_type = if t35 ~= nil and t35.action_type ~= nil then t35.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t35 ~= nil and t35.action_params ~= nil then t35.action_params else nil
	}, t34))
end
function t34.encode(p25) -- line: 6180
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n17 = 0

	if p25.action_type ~= nil and (p25.action_type ~= nil and p25.action_type ~= 0 or p25.action_type ~= t1.ActionType.fromNumber(0)) then
		local v397, v398 = proto.writeTag(buf, n17, 1, proto.wireTypes.varint)

		buf, n17 = proto.writeVarInt(v397, v398, t1.ActionType.toNumber(p25.action_type))
	end

	if p25.action_params ~= nil then
		local v399 = p25.action_params:encode()
		local v400, v401 = proto.writeTag(buf, n17, 2, proto.wireTypes.lengthDelimited)

		buf, n17 = proto.writeBuffer(v400, v401, v399, buffer.len(v399))
	end

	local buf10 = buffer.create(n17)

	buffer.copy(buf10, 0, buf, 0, n17)

	return buf10
end
function t34.decode(p26: buffer) -- line: 6206
	-- upvalues: t34 (copy), proto (copy), t1 (copy)
	local v404 = t34.new()
	local n18 = 0

	while n18 < buffer.len(p26) do
		local v406, v407

		v406, v407, n18 = proto.readTag(p26, n18)

		if v407 == proto.wireTypes.varint then
			if v406 == 1 then
				local v408

				v408, n18 = proto.readVarIntI32(p26, n18)
				v404.action_type = t1.ActionType.fromNumber(v408) or v408
			else
				local v409

				v409, n18 = proto.readVarInt(p26, n18)
			end
		elseif v407 == proto.wireTypes.lengthDelimited then
			if v406 == 2 then
				local v410

				v410, n18 = proto.readBuffer(p26, n18)
				v404.action_params = t1.OpenJoinFriendsAction_Params.decode(v410)
			else
				local v411, v412 = proto.readVarInt(p26, n18)

				n18 = v412 + v411
			end
		elseif v407 == proto.wireTypes.i32 then
			local v413

			v413, n18 = proto.readFixed32(p26, n18)
		elseif v407 == proto.wireTypes.i64 then
			local v414

			v414, n18 = proto.readFixed64(p26, n18)
		else
			error("Unsupported wire type: " .. v407)
		end
	end

	return v404
end
function t34.jsonEncode(p27) -- line: 6254
	-- upvalues: t1 (copy)
	local t36 = {}

	if p27.action_type ~= nil and (p27.action_type ~= nil and p27.action_type ~= 0 or p27.action_type ~= t1.ActionType.fromNumber(0)) then
		t36.actionType = if typeof(p27.action_type) ~= "number" then t1.ActionType.toNumber(p27.action_type) else p27.action_type
	end

	if p27.action_params ~= nil then
		t36.actionParams = p27.action_params:jsonEncode()
	end

	return t36
end
function t34.jsonDecode(t37: {[any]: any}) -- line: 6276
	-- upvalues: t34 (copy), t1 (copy)
	local v418 = t34.new()

	if t37.action_type ~= nil then
		v418.action_type = if typeof(t37.action_type) ~= "number" then t1.ActionType.fromName(t37.action_type) or t37.action_type else t1.ActionType.fromNumber(t37.action_type) or t37.action_type
	end

	if t37.actionType ~= nil then
		v418.action_type = if typeof(t37.actionType) ~= "number" then t1.ActionType.fromName(t37.actionType) or t37.actionType else t1.ActionType.fromNumber(t37.actionType) or t37.actionType
	end

	if t37.action_params ~= nil then
		v418.action_params = t1.OpenJoinFriendsAction_Params.jsonDecode(t37.action_params)
	end

	if t37.actionParams ~= nil then
		v418.action_params = t1.OpenJoinFriendsAction_Params.jsonDecode(t37.actionParams)
	end

	return v418
end

t34.descriptor = {
	name = "OpenJoinFriendsAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.OpenJoinFriendsAction"
}
t1.OpenJoinFriendsAction = t34
typeRegistry.default:register(t1.OpenJoinFriendsAction)

local t38 = {}

t38.__index = t38

function t38.new(t39: {[any]: any}?) -- line: 6316
	-- upvalues: t38 (copy)
	return (setmetatable({
		place_id = if t39 ~= nil and t39.place_id ~= nil then t39.place_id else nil,
		universe_id = if t39 ~= nil and t39.universe_id ~= nil then t39.universe_id else nil
	}, t38))
end
function t38.encode(p28) -- line: 6325
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n19 = 0

	if p28.place_id ~= nil then
		local v423 = p28.place_id:encode()
		local v424, v425 = proto.writeTag(buf, n19, 1, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeBuffer(v424, v425, v423, buffer.len(v423))
	end

	if p28.universe_id ~= nil then
		local v426 = p28.universe_id:encode()
		local v427, v428 = proto.writeTag(buf, n19, 2, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeBuffer(v427, v428, v426, buffer.len(v426))
	end

	local buf11 = buffer.create(n19)

	buffer.copy(buf11, 0, buf, 0, n19)

	return buf11
end
function t38.decode(p29: buffer) -- line: 6346
	-- upvalues: t38 (copy), proto (copy), prop_types (copy)
	local v431 = t38.new()
	local n20 = 0

	while n20 < buffer.len(p29) do
		local v433, v434

		v433, v434, n20 = proto.readTag(p29, n20)

		if v434 == proto.wireTypes.varint then
			local v435

			v435, n20 = proto.readVarInt(p29, n20)
		elseif v434 == proto.wireTypes.lengthDelimited then
			if v433 == 1 then
				local v436

				v436, n20 = proto.readBuffer(p29, n20)
				v431.place_id = prop_types.StringProp.decode(v436)
			elseif v433 == 2 then
				local v437

				v437, n20 = proto.readBuffer(p29, n20)
				v431.universe_id = prop_types.StringProp.decode(v437)
			else
				local v438, v439 = proto.readVarInt(p29, n20)

				n20 = v439 + v438
			end
		elseif v434 == proto.wireTypes.i32 then
			local v440

			v440, n20 = proto.readFixed32(p29, n20)
		elseif v434 == proto.wireTypes.i64 then
			local v441

			v441, n20 = proto.readFixed64(p29, n20)
		else
			error("Unsupported wire type: " .. v434)
		end
	end

	return v431
end
function t38.jsonEncode(p30) -- line: 6394
	local t40 = {}

	if p30.place_id ~= nil then
		t40.placeId = p30.place_id:jsonEncode()
	end

	if p30.universe_id ~= nil then
		t40.universeId = p30.universe_id:jsonEncode()
	end

	return t40
end
function t38.jsonDecode(t41: {[any]: any}) -- line: 6408
	-- upvalues: t38 (copy), prop_types (copy)
	local v445 = t38.new()

	if t41.place_id ~= nil then
		v445.place_id = prop_types.StringProp.jsonDecode(t41.place_id)
	end

	if t41.placeId ~= nil then
		v445.place_id = prop_types.StringProp.jsonDecode(t41.placeId)
	end

	if t41.universe_id ~= nil then
		v445.universe_id = prop_types.StringProp.jsonDecode(t41.universe_id)
	end

	if t41.universeId ~= nil then
		v445.universe_id = prop_types.StringProp.jsonDecode(t41.universeId)
	end

	return v445
end

t38.descriptor = {
	name = "OpenJoinFriendsAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.OpenJoinFriendsAction_Params = t38
typeRegistry.default:register(t1.OpenJoinFriendsAction_Params)

local t42 = {}

t42.__index = t42

function t42.new(t43: {[any]: any}?) -- line: 6445
	-- upvalues: t1 (copy), t42 (copy)
	return (setmetatable({
		action_type = if t43 ~= nil and t43.action_type ~= nil then t43.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t43 ~= nil and t43.action_params ~= nil then t43.action_params else nil
	}, t42))
end
function t42.encode(p31) -- line: 6456
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n21 = 0

	if p31.action_type ~= nil and (p31.action_type ~= nil and p31.action_type ~= 0 or p31.action_type ~= t1.ActionType.fromNumber(0)) then
		local v450, v451 = proto.writeTag(buf, n21, 1, proto.wireTypes.varint)

		buf, n21 = proto.writeVarInt(v450, v451, t1.ActionType.toNumber(p31.action_type))
	end

	if p31.action_params ~= nil then
		local v452 = p31.action_params:encode()
		local v453, v454 = proto.writeTag(buf, n21, 2, proto.wireTypes.lengthDelimited)

		buf, n21 = proto.writeBuffer(v453, v454, v452, buffer.len(v452))
	end

	local buf12 = buffer.create(n21)

	buffer.copy(buf12, 0, buf, 0, n21)

	return buf12
end
function t42.decode(p32: buffer) -- line: 6482
	-- upvalues: t42 (copy), proto (copy), t1 (copy)
	local v457 = t42.new()
	local n22 = 0

	while n22 < buffer.len(p32) do
		local v459, v460

		v459, v460, n22 = proto.readTag(p32, n22)

		if v460 == proto.wireTypes.varint then
			if v459 == 1 then
				local v461

				v461, n22 = proto.readVarIntI32(p32, n22)
				v457.action_type = t1.ActionType.fromNumber(v461) or v461
			else
				local v462

				v462, n22 = proto.readVarInt(p32, n22)
			end
		elseif v460 == proto.wireTypes.lengthDelimited then
			if v459 == 2 then
				local v463

				v463, n22 = proto.readBuffer(p32, n22)
				v457.action_params = t1.OpenMarketplaceTryOnAction_Params.decode(v463)
			else
				local v464, v465 = proto.readVarInt(p32, n22)

				n22 = v465 + v464
			end
		elseif v460 == proto.wireTypes.i32 then
			local v466

			v466, n22 = proto.readFixed32(p32, n22)
		elseif v460 == proto.wireTypes.i64 then
			local v467

			v467, n22 = proto.readFixed64(p32, n22)
		else
			error("Unsupported wire type: " .. v460)
		end
	end

	return v457
end
function t42.jsonEncode(p33) -- line: 6530
	-- upvalues: t1 (copy)
	local t44 = {}

	if p33.action_type ~= nil and (p33.action_type ~= nil and p33.action_type ~= 0 or p33.action_type ~= t1.ActionType.fromNumber(0)) then
		t44.actionType = if typeof(p33.action_type) ~= "number" then t1.ActionType.toNumber(p33.action_type) else p33.action_type
	end

	if p33.action_params ~= nil then
		t44.actionParams = p33.action_params:jsonEncode()
	end

	return t44
end
function t42.jsonDecode(t45: {[any]: any}) -- line: 6552
	-- upvalues: t42 (copy), t1 (copy)
	local v471 = t42.new()

	if t45.action_type ~= nil then
		v471.action_type = if typeof(t45.action_type) ~= "number" then t1.ActionType.fromName(t45.action_type) or t45.action_type else t1.ActionType.fromNumber(t45.action_type) or t45.action_type
	end

	if t45.actionType ~= nil then
		v471.action_type = if typeof(t45.actionType) ~= "number" then t1.ActionType.fromName(t45.actionType) or t45.actionType else t1.ActionType.fromNumber(t45.actionType) or t45.actionType
	end

	if t45.action_params ~= nil then
		v471.action_params = t1.OpenMarketplaceTryOnAction_Params.jsonDecode(t45.action_params)
	end

	if t45.actionParams ~= nil then
		v471.action_params = t1.OpenMarketplaceTryOnAction_Params.jsonDecode(t45.actionParams)
	end

	return v471
end

t42.descriptor = {
	name = "OpenMarketplaceTryOnAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.OpenMarketplaceTryOnAction"
}
t1.OpenMarketplaceTryOnAction = t42
typeRegistry.default:register(t1.OpenMarketplaceTryOnAction)

local t46 = {}

t46.__index = t46

function t46.new(t47: {[any]: any}?) -- line: 6592
	-- upvalues: t46 (copy)
	return (setmetatable({
		item_id = if t47 ~= nil and t47.item_id ~= nil then t47.item_id else nil,
		item_type = if t47 ~= nil and t47.item_type ~= nil then t47.item_type else nil,
		item_sub_type_name = if t47 ~= nil and t47.item_sub_type_name ~= nil then t47.item_sub_type_name else nil
	}, t46))
end
function t46.encode(p34) -- line: 6602
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n23 = 0

	if p34.item_id ~= nil then
		local v476 = p34.item_id:encode()
		local v477, v478 = proto.writeTag(buf, n23, 1, proto.wireTypes.lengthDelimited)

		buf, n23 = proto.writeBuffer(v477, v478, v476, buffer.len(v476))
	end

	if p34.item_type ~= nil then
		local v479 = p34.item_type:encode()
		local v480, v481 = proto.writeTag(buf, n23, 2, proto.wireTypes.lengthDelimited)

		buf, n23 = proto.writeBuffer(v480, v481, v479, buffer.len(v479))
	end

	if p34.item_sub_type_name ~= nil then
		local v482 = p34.item_sub_type_name:encode()
		local v483, v484 = proto.writeTag(buf, n23, 3, proto.wireTypes.lengthDelimited)

		buf, n23 = proto.writeBuffer(v483, v484, v482, buffer.len(v482))
	end

	local buf13 = buffer.create(n23)

	buffer.copy(buf13, 0, buf, 0, n23)

	return buf13
end
function t46.decode(p35: buffer) -- line: 6629
	-- upvalues: t46 (copy), proto (copy), prop_types (copy)
	local v487 = t46.new()
	local n24 = 0

	while n24 < buffer.len(p35) do
		local v489, v490

		v489, v490, n24 = proto.readTag(p35, n24)

		if v490 == proto.wireTypes.varint then
			local v491

			v491, n24 = proto.readVarInt(p35, n24)
		elseif v490 == proto.wireTypes.lengthDelimited then
			if v489 == 1 then
				local v492

				v492, n24 = proto.readBuffer(p35, n24)
				v487.item_id = prop_types.StringProp.decode(v492)
			elseif v489 == 2 then
				local v493

				v493, n24 = proto.readBuffer(p35, n24)
				v487.item_type = prop_types.StringProp.decode(v493)
			elseif v489 == 3 then
				local v494

				v494, n24 = proto.readBuffer(p35, n24)
				v487.item_sub_type_name = prop_types.StringProp.decode(v494)
			else
				local v495, v496 = proto.readVarInt(p35, n24)

				n24 = v496 + v495
			end
		elseif v490 == proto.wireTypes.i32 then
			local v497

			v497, n24 = proto.readFixed32(p35, n24)
		elseif v490 == proto.wireTypes.i64 then
			local v498

			v498, n24 = proto.readFixed64(p35, n24)
		else
			error("Unsupported wire type: " .. v490)
		end
	end

	return v487
end
function t46.jsonEncode(p36) -- line: 6682
	local t48 = {}

	if p36.item_id ~= nil then
		t48.itemId = p36.item_id:jsonEncode()
	end

	if p36.item_type ~= nil then
		t48.itemType = p36.item_type:jsonEncode()
	end

	if p36.item_sub_type_name ~= nil then
		t48.itemSubTypeName = p36.item_sub_type_name:jsonEncode()
	end

	return t48
end
function t46.jsonDecode(t49: {[any]: any}) -- line: 6700
	-- upvalues: t46 (copy), prop_types (copy)
	local v502 = t46.new()

	if t49.item_id ~= nil then
		v502.item_id = prop_types.StringProp.jsonDecode(t49.item_id)
	end

	if t49.itemId ~= nil then
		v502.item_id = prop_types.StringProp.jsonDecode(t49.itemId)
	end

	if t49.item_type ~= nil then
		v502.item_type = prop_types.StringProp.jsonDecode(t49.item_type)
	end

	if t49.itemType ~= nil then
		v502.item_type = prop_types.StringProp.jsonDecode(t49.itemType)
	end

	if t49.item_sub_type_name ~= nil then
		v502.item_sub_type_name = prop_types.StringProp.jsonDecode(t49.item_sub_type_name)
	end

	if t49.itemSubTypeName ~= nil then
		v502.item_sub_type_name = prop_types.StringProp.jsonDecode(t49.itemSubTypeName)
	end

	return v502
end

t46.descriptor = {
	name = "OpenMarketplaceTryOnAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.OpenMarketplaceTryOnAction_Params = t46
typeRegistry.default:register(t1.OpenMarketplaceTryOnAction_Params)

local t50 = {}

t50.__index = t50

function t50.new(t51: {[any]: any}?) -- line: 6748
	-- upvalues: t1 (copy), t50 (copy)
	return (setmetatable({
		action_type = if t51 ~= nil and t51.action_type ~= nil then t51.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t51 ~= nil and t51.action_params ~= nil then t51.action_params else nil
	}, t50))
end
function t50.encode(p37) -- line: 6757
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n25 = 0

	if p37.action_type ~= nil and (p37.action_type ~= nil and p37.action_type ~= 0 or p37.action_type ~= t1.ActionType.fromNumber(0)) then
		local v507, v508 = proto.writeTag(buf, n25, 1, proto.wireTypes.varint)

		buf, n25 = proto.writeVarInt(v507, v508, t1.ActionType.toNumber(p37.action_type))
	end

	if p37.action_params ~= nil then
		local v509 = p37.action_params:encode()
		local v510, v511 = proto.writeTag(buf, n25, 2, proto.wireTypes.lengthDelimited)

		buf, n25 = proto.writeBuffer(v510, v511, v509, buffer.len(v509))
	end

	local buf14 = buffer.create(n25)

	buffer.copy(buf14, 0, buf, 0, n25)

	return buf14
end
function t50.decode(p38: buffer) -- line: 6783
	-- upvalues: t50 (copy), proto (copy), t1 (copy)
	local v514 = t50.new()
	local n26 = 0

	while n26 < buffer.len(p38) do
		local v516, v517

		v516, v517, n26 = proto.readTag(p38, n26)

		if v517 == proto.wireTypes.varint then
			if v516 == 1 then
				local v518

				v518, n26 = proto.readVarIntI32(p38, n26)
				v514.action_type = t1.ActionType.fromNumber(v518) or v518
			else
				local v519

				v519, n26 = proto.readVarInt(p38, n26)
			end
		elseif v517 == proto.wireTypes.lengthDelimited then
			if v516 == 2 then
				local v520

				v520, n26 = proto.readBuffer(p38, n26)
				v514.action_params = t1.OpenSeeAllAction_Params.decode(v520)
			else
				local v521, v522 = proto.readVarInt(p38, n26)

				n26 = v522 + v521
			end
		elseif v517 == proto.wireTypes.i32 then
			local v523

			v523, n26 = proto.readFixed32(p38, n26)
		elseif v517 == proto.wireTypes.i64 then
			local v524

			v524, n26 = proto.readFixed64(p38, n26)
		else
			error("Unsupported wire type: " .. v517)
		end
	end

	return v514
end
function t50.jsonEncode(p39) -- line: 6831
	-- upvalues: t1 (copy)
	local t52 = {}

	if p39.action_type ~= nil and (p39.action_type ~= nil and p39.action_type ~= 0 or p39.action_type ~= t1.ActionType.fromNumber(0)) then
		t52.actionType = if typeof(p39.action_type) ~= "number" then t1.ActionType.toNumber(p39.action_type) else p39.action_type
	end

	if p39.action_params ~= nil then
		t52.actionParams = p39.action_params:jsonEncode()
	end

	return t52
end
function t50.jsonDecode(t53: {[any]: any}) -- line: 6853
	-- upvalues: t50 (copy), t1 (copy)
	local v528 = t50.new()

	if t53.action_type ~= nil then
		v528.action_type = if typeof(t53.action_type) ~= "number" then t1.ActionType.fromName(t53.action_type) or t53.action_type else t1.ActionType.fromNumber(t53.action_type) or t53.action_type
	end

	if t53.actionType ~= nil then
		v528.action_type = if typeof(t53.actionType) ~= "number" then t1.ActionType.fromName(t53.actionType) or t53.actionType else t1.ActionType.fromNumber(t53.actionType) or t53.actionType
	end

	if t53.action_params ~= nil then
		v528.action_params = t1.OpenSeeAllAction_Params.jsonDecode(t53.action_params)
	end

	if t53.actionParams ~= nil then
		v528.action_params = t1.OpenSeeAllAction_Params.jsonDecode(t53.actionParams)
	end

	return v528
end

t50.descriptor = {
	name = "OpenSeeAllAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.OpenSeeAllAction"
}
t1.OpenSeeAllAction = t50
typeRegistry.default:register(t1.OpenSeeAllAction)

local t54 = {}

t54.__index = t54

function t54.new(t55: {[any]: any}?) -- line: 6893
	-- upvalues: t54 (copy)
	return (setmetatable({
		collection_id = if t55 ~= nil and t55.collection_id ~= nil then t55.collection_id else nil,
		game_set_target_id = if t55 ~= nil and t55.game_set_target_id ~= nil then t55.game_set_target_id else nil,
		collection_position = if t55 ~= nil and t55.collection_position ~= nil then t55.collection_position else nil
	}, t54))
end
function t54.encode(p40) -- line: 6903
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n27 = 0

	if p40.collection_id ~= nil then
		local v533 = p40.collection_id:encode()
		local v534, v535 = proto.writeTag(buf, n27, 1, proto.wireTypes.lengthDelimited)

		buf, n27 = proto.writeBuffer(v534, v535, v533, buffer.len(v533))
	end

	if p40.game_set_target_id ~= nil then
		local v536 = p40.game_set_target_id:encode()
		local v537, v538 = proto.writeTag(buf, n27, 2, proto.wireTypes.lengthDelimited)

		buf, n27 = proto.writeBuffer(v537, v538, v536, buffer.len(v536))
	end

	if p40.collection_position ~= nil then
		local v539 = p40.collection_position:encode()
		local v540, v541 = proto.writeTag(buf, n27, 3, proto.wireTypes.lengthDelimited)

		buf, n27 = proto.writeBuffer(v540, v541, v539, buffer.len(v539))
	end

	local buf15 = buffer.create(n27)

	buffer.copy(buf15, 0, buf, 0, n27)

	return buf15
end
function t54.decode(p41: buffer) -- line: 6930
	-- upvalues: t54 (copy), proto (copy), prop_types (copy)
	local v544 = t54.new()
	local n28 = 0

	while n28 < buffer.len(p41) do
		local v546, v547

		v546, v547, n28 = proto.readTag(p41, n28)

		if v547 == proto.wireTypes.varint then
			local v548

			v548, n28 = proto.readVarInt(p41, n28)
		elseif v547 == proto.wireTypes.lengthDelimited then
			if v546 == 1 then
				local v549

				v549, n28 = proto.readBuffer(p41, n28)
				v544.collection_id = prop_types.StringProp.decode(v549)
			elseif v546 == 2 then
				local v550

				v550, n28 = proto.readBuffer(p41, n28)
				v544.game_set_target_id = prop_types.StringProp.decode(v550)
			elseif v546 == 3 then
				local v551

				v551, n28 = proto.readBuffer(p41, n28)
				v544.collection_position = prop_types.StringProp.decode(v551)
			else
				local v552, v553 = proto.readVarInt(p41, n28)

				n28 = v553 + v552
			end
		elseif v547 == proto.wireTypes.i32 then
			local v554

			v554, n28 = proto.readFixed32(p41, n28)
		elseif v547 == proto.wireTypes.i64 then
			local v555

			v555, n28 = proto.readFixed64(p41, n28)
		else
			error("Unsupported wire type: " .. v547)
		end
	end

	return v544
end
function t54.jsonEncode(p42) -- line: 6984
	local t56 = {}

	if p42.collection_id ~= nil then
		t56.collectionId = p42.collection_id:jsonEncode()
	end

	if p42.game_set_target_id ~= nil then
		t56.gameSetTargetId = p42.game_set_target_id:jsonEncode()
	end

	if p42.collection_position ~= nil then
		t56.collectionPosition = p42.collection_position:jsonEncode()
	end

	return t56
end
function t54.jsonDecode(t57: {[any]: any}) -- line: 7002
	-- upvalues: t54 (copy), prop_types (copy)
	local v559 = t54.new()

	if t57.collection_id ~= nil then
		v559.collection_id = prop_types.StringProp.jsonDecode(t57.collection_id)
	end

	if t57.collectionId ~= nil then
		v559.collection_id = prop_types.StringProp.jsonDecode(t57.collectionId)
	end

	if t57.game_set_target_id ~= nil then
		v559.game_set_target_id = prop_types.StringProp.jsonDecode(t57.game_set_target_id)
	end

	if t57.gameSetTargetId ~= nil then
		v559.game_set_target_id = prop_types.StringProp.jsonDecode(t57.gameSetTargetId)
	end

	if t57.collection_position ~= nil then
		v559.collection_position = prop_types.StringProp.jsonDecode(t57.collection_position)
	end

	if t57.collectionPosition ~= nil then
		v559.collection_position = prop_types.StringProp.jsonDecode(t57.collectionPosition)
	end

	return v559
end

t54.descriptor = {
	name = "OpenSeeAllAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.OpenSeeAllAction_Params = t54
typeRegistry.default:register(t1.OpenSeeAllAction_Params)

local t58 = {}

t58.__index = t58

function t58.new(t59: {[any]: any}?) -- line: 7052
	-- upvalues: t1 (copy), t58 (copy)
	return (setmetatable({
		action_type = if t59 ~= nil and t59.action_type ~= nil then t59.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t59 ~= nil and t59.action_params ~= nil then t59.action_params else nil
	}, t58))
end
function t58.encode(p43) -- line: 7063
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n29 = 0

	if p43.action_type ~= nil and (p43.action_type ~= nil and p43.action_type ~= 0 or p43.action_type ~= t1.ActionType.fromNumber(0)) then
		local v564, v565 = proto.writeTag(buf, n29, 1, proto.wireTypes.varint)

		buf, n29 = proto.writeVarInt(v564, v565, t1.ActionType.toNumber(p43.action_type))
	end

	if p43.action_params ~= nil then
		local v566 = p43.action_params:encode()
		local v567, v568 = proto.writeTag(buf, n29, 2, proto.wireTypes.lengthDelimited)

		buf, n29 = proto.writeBuffer(v567, v568, v566, buffer.len(v566))
	end

	local buf16 = buffer.create(n29)

	buffer.copy(buf16, 0, buf, 0, n29)

	return buf16
end
function t58.decode(p44: buffer) -- line: 7089
	-- upvalues: t58 (copy), proto (copy), t1 (copy)
	local v571 = t58.new()
	local n30 = 0

	while n30 < buffer.len(p44) do
		local v573, v574

		v573, v574, n30 = proto.readTag(p44, n30)

		if v574 == proto.wireTypes.varint then
			if v573 == 1 then
				local v575

				v575, n30 = proto.readVarIntI32(p44, n30)
				v571.action_type = t1.ActionType.fromNumber(v575) or v575
			else
				local v576

				v576, n30 = proto.readVarInt(p44, n30)
			end
		elseif v574 == proto.wireTypes.lengthDelimited then
			if v573 == 2 then
				local v577

				v577, n30 = proto.readBuffer(p44, n30)
				v571.action_params = t1.OpenSponsoredTooltipAction_Params.decode(v577)
			else
				local v578, v579 = proto.readVarInt(p44, n30)

				n30 = v579 + v578
			end
		elseif v574 == proto.wireTypes.i32 then
			local v580

			v580, n30 = proto.readFixed32(p44, n30)
		elseif v574 == proto.wireTypes.i64 then
			local v581

			v581, n30 = proto.readFixed64(p44, n30)
		else
			error("Unsupported wire type: " .. v574)
		end
	end

	return v571
end
function t58.jsonEncode(p45) -- line: 7137
	-- upvalues: t1 (copy)
	local t60 = {}

	if p45.action_type ~= nil and (p45.action_type ~= nil and p45.action_type ~= 0 or p45.action_type ~= t1.ActionType.fromNumber(0)) then
		t60.actionType = if typeof(p45.action_type) ~= "number" then t1.ActionType.toNumber(p45.action_type) else p45.action_type
	end

	if p45.action_params ~= nil then
		t60.actionParams = p45.action_params:jsonEncode()
	end

	return t60
end
function t58.jsonDecode(t61: {[any]: any}) -- line: 7159
	-- upvalues: t58 (copy), t1 (copy)
	local v585 = t58.new()

	if t61.action_type ~= nil then
		v585.action_type = if typeof(t61.action_type) ~= "number" then t1.ActionType.fromName(t61.action_type) or t61.action_type else t1.ActionType.fromNumber(t61.action_type) or t61.action_type
	end

	if t61.actionType ~= nil then
		v585.action_type = if typeof(t61.actionType) ~= "number" then t1.ActionType.fromName(t61.actionType) or t61.actionType else t1.ActionType.fromNumber(t61.actionType) or t61.actionType
	end

	if t61.action_params ~= nil then
		v585.action_params = t1.OpenSponsoredTooltipAction_Params.jsonDecode(t61.action_params)
	end

	if t61.actionParams ~= nil then
		v585.action_params = t1.OpenSponsoredTooltipAction_Params.jsonDecode(t61.actionParams)
	end

	return v585
end

t58.descriptor = {
	name = "OpenSponsoredTooltipAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.OpenSponsoredTooltipAction"
}
t1.OpenSponsoredTooltipAction = t58
typeRegistry.default:register(t1.OpenSponsoredTooltipAction)

local t62 = {}

t62.__index = t62

function t62.new(_: {[any]: any}?) -- line: 7199
	-- upvalues: t62 (copy)
	return (setmetatable({}, t62))
end
function t62.encode(_) -- line: 7205
	local buf = buffer.create(0)
	local buf17 = buffer.create(0)

	buffer.copy(buf17, 0, buf, 0, 0)

	return buf17
end
function t62.decode(p47: buffer) -- line: 7214
	-- upvalues: t62 (copy), proto (copy)
	local v591 = t62.new()
	local n31 = 0

	while n31 < buffer.len(p47) do
		local v593, v594

		v593, v594, n31 = proto.readTag(p47, n31)

		if v594 == proto.wireTypes.varint then
			local v595

			v595, n31 = proto.readVarInt(p47, n31)
		elseif v594 == proto.wireTypes.lengthDelimited then
			local v596, v597 = proto.readVarInt(p47, n31)

			n31 = v597 + v596
		elseif v594 == proto.wireTypes.i32 then
			local v598

			v598, n31 = proto.readFixed32(p47, n31)
		elseif v594 == proto.wireTypes.i64 then
			local v599

			v599, n31 = proto.readFixed64(p47, n31)
		else
			error("Unsupported wire type: " .. v594)
		end
	end

	return v591
end
function t62.jsonEncode(_) -- line: 7252
	return {}
end
function t62.jsonDecode(_: {[any]: any}) -- line: 7258
	-- upvalues: t62 (copy)
	return (t62.new())
end

t62.descriptor = {
	name = "OpenSponsoredTooltipAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.OpenSponsoredTooltipAction_Params = t62
typeRegistry.default:register(t1.OpenSponsoredTooltipAction_Params)

local t65 = {}

t65.__index = t65

function t65.new(t66: {[any]: any}?) -- line: 7280
	-- upvalues: t1 (copy), t65 (copy)
	return (setmetatable({
		action_type = if t66 ~= nil and t66.action_type ~= nil then t66.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t66 ~= nil and t66.action_params ~= nil then t66.action_params else nil
	}, t65))
end
function t65.encode(p49) -- line: 7289
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n32 = 0

	if p49.action_type ~= nil and (p49.action_type ~= nil and p49.action_type ~= 0 or p49.action_type ~= t1.ActionType.fromNumber(0)) then
		local v606, v607 = proto.writeTag(buf, n32, 1, proto.wireTypes.varint)

		buf, n32 = proto.writeVarInt(v606, v607, t1.ActionType.toNumber(p49.action_type))
	end

	if p49.action_params ~= nil then
		local v608 = p49.action_params:encode()
		local v609, v610 = proto.writeTag(buf, n32, 2, proto.wireTypes.lengthDelimited)

		buf, n32 = proto.writeBuffer(v609, v610, v608, buffer.len(v608))
	end

	local buf18 = buffer.create(n32)

	buffer.copy(buf18, 0, buf, 0, n32)

	return buf18
end
function t65.decode(p50: buffer) -- line: 7315
	-- upvalues: t65 (copy), proto (copy), t1 (copy)
	local v613 = t65.new()
	local n33 = 0

	while n33 < buffer.len(p50) do
		local v615, v616

		v615, v616, n33 = proto.readTag(p50, n33)

		if v616 == proto.wireTypes.varint then
			if v615 == 1 then
				local v617

				v617, n33 = proto.readVarIntI32(p50, n33)
				v613.action_type = t1.ActionType.fromNumber(v617) or v617
			else
				local v618

				v618, n33 = proto.readVarInt(p50, n33)
			end
		elseif v616 == proto.wireTypes.lengthDelimited then
			if v615 == 2 then
				local v619

				v619, n33 = proto.readBuffer(p50, n33)
				v613.action_params = t1.PlayButtonClickAction_Params.decode(v619)
			else
				local v620, v621 = proto.readVarInt(p50, n33)

				n33 = v621 + v620
			end
		elseif v616 == proto.wireTypes.i32 then
			local v622

			v622, n33 = proto.readFixed32(p50, n33)
		elseif v616 == proto.wireTypes.i64 then
			local v623

			v623, n33 = proto.readFixed64(p50, n33)
		else
			error("Unsupported wire type: " .. v616)
		end
	end

	return v613
end
function t65.jsonEncode(p51) -- line: 7363
	-- upvalues: t1 (copy)
	local t67 = {}

	if p51.action_type ~= nil and (p51.action_type ~= nil and p51.action_type ~= 0 or p51.action_type ~= t1.ActionType.fromNumber(0)) then
		t67.actionType = if typeof(p51.action_type) ~= "number" then t1.ActionType.toNumber(p51.action_type) else p51.action_type
	end

	if p51.action_params ~= nil then
		t67.actionParams = p51.action_params:jsonEncode()
	end

	return t67
end
function t65.jsonDecode(t68: {[any]: any}) -- line: 7385
	-- upvalues: t65 (copy), t1 (copy)
	local v627 = t65.new()

	if t68.action_type ~= nil then
		v627.action_type = if typeof(t68.action_type) ~= "number" then t1.ActionType.fromName(t68.action_type) or t68.action_type else t1.ActionType.fromNumber(t68.action_type) or t68.action_type
	end

	if t68.actionType ~= nil then
		v627.action_type = if typeof(t68.actionType) ~= "number" then t1.ActionType.fromName(t68.actionType) or t68.actionType else t1.ActionType.fromNumber(t68.actionType) or t68.actionType
	end

	if t68.action_params ~= nil then
		v627.action_params = t1.PlayButtonClickAction_Params.jsonDecode(t68.action_params)
	end

	if t68.actionParams ~= nil then
		v627.action_params = t1.PlayButtonClickAction_Params.jsonDecode(t68.actionParams)
	end

	return v627
end

t65.descriptor = {
	name = "PlayButtonClickAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.PlayButtonClickAction"
}
t1.PlayButtonClickAction = t65
typeRegistry.default:register(t1.PlayButtonClickAction)

local t69 = {}

t69.__index = t69

function t69.new(_: {[any]: any}?) -- line: 7425
	-- upvalues: t69 (copy)
	return (setmetatable({}, t69))
end
function t69.encode(_) -- line: 7431
	local buf = buffer.create(0)
	local buf19 = buffer.create(0)

	buffer.copy(buf19, 0, buf, 0, 0)

	return buf19
end
function t69.decode(p53: buffer) -- line: 7440
	-- upvalues: t69 (copy), proto (copy)
	local v633 = t69.new()
	local n34 = 0

	while n34 < buffer.len(p53) do
		local v635, v636

		v635, v636, n34 = proto.readTag(p53, n34)

		if v636 == proto.wireTypes.varint then
			local v637

			v637, n34 = proto.readVarInt(p53, n34)
		elseif v636 == proto.wireTypes.lengthDelimited then
			local v638, v639 = proto.readVarInt(p53, n34)

			n34 = v639 + v638
		elseif v636 == proto.wireTypes.i32 then
			local v640

			v640, n34 = proto.readFixed32(p53, n34)
		elseif v636 == proto.wireTypes.i64 then
			local v641

			v641, n34 = proto.readFixed64(p53, n34)
		else
			error("Unsupported wire type: " .. v636)
		end
	end

	return v633
end
function t69.jsonEncode(_) -- line: 7478
	return {}
end
function t69.jsonDecode(_: {[any]: any}) -- line: 7484
	-- upvalues: t69 (copy)
	return (t69.new())
end

t69.descriptor = {
	name = "PlayButtonClickAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.PlayButtonClickAction_Params = t69
typeRegistry.default:register(t1.PlayButtonClickAction_Params)

local t72 = {}

t72.__index = t72

function t72.new(t73: {[any]: any}?) -- line: 7504
	-- upvalues: t1 (copy), t72 (copy)
	return (setmetatable({
		action_type = if t73 ~= nil and t73.action_type ~= nil then t73.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t73 ~= nil and t73.action_params ~= nil then t73.action_params else nil
	}, t72))
end
function t72.encode(p55) -- line: 7513
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n35 = 0

	if p55.action_type ~= nil and (p55.action_type ~= nil and p55.action_type ~= 0 or p55.action_type ~= t1.ActionType.fromNumber(0)) then
		local v648, v649 = proto.writeTag(buf, n35, 1, proto.wireTypes.varint)

		buf, n35 = proto.writeVarInt(v648, v649, t1.ActionType.toNumber(p55.action_type))
	end

	if p55.action_params ~= nil then
		local v650 = p55.action_params:encode()
		local v651, v652 = proto.writeTag(buf, n35, 2, proto.wireTypes.lengthDelimited)

		buf, n35 = proto.writeBuffer(v651, v652, v650, buffer.len(v650))
	end

	local buf20 = buffer.create(n35)

	buffer.copy(buf20, 0, buf, 0, n35)

	return buf20
end
function t72.decode(p56: buffer) -- line: 7539
	-- upvalues: t72 (copy), proto (copy), t1 (copy)
	local v655 = t72.new()
	local n36 = 0

	while n36 < buffer.len(p56) do
		local v657, v658

		v657, v658, n36 = proto.readTag(p56, n36)

		if v658 == proto.wireTypes.varint then
			if v657 == 1 then
				local v659

				v659, n36 = proto.readVarIntI32(p56, n36)
				v655.action_type = t1.ActionType.fromNumber(v659) or v659
			else
				local v660

				v660, n36 = proto.readVarInt(p56, n36)
			end
		elseif v658 == proto.wireTypes.lengthDelimited then
			if v657 == 2 then
				local v661

				v661, n36 = proto.readBuffer(p56, n36)
				v655.action_params = t1.UpdateUserSettingsAction_Params.decode(v661)
			else
				local v662, v663 = proto.readVarInt(p56, n36)

				n36 = v663 + v662
			end
		elseif v658 == proto.wireTypes.i32 then
			local v664

			v664, n36 = proto.readFixed32(p56, n36)
		elseif v658 == proto.wireTypes.i64 then
			local v665

			v665, n36 = proto.readFixed64(p56, n36)
		else
			error("Unsupported wire type: " .. v658)
		end
	end

	return v655
end
function t72.jsonEncode(p57) -- line: 7587
	-- upvalues: t1 (copy)
	local t74 = {}

	if p57.action_type ~= nil and (p57.action_type ~= nil and p57.action_type ~= 0 or p57.action_type ~= t1.ActionType.fromNumber(0)) then
		t74.actionType = if typeof(p57.action_type) ~= "number" then t1.ActionType.toNumber(p57.action_type) else p57.action_type
	end

	if p57.action_params ~= nil then
		t74.actionParams = p57.action_params:jsonEncode()
	end

	return t74
end
function t72.jsonDecode(t75: {[any]: any}) -- line: 7609
	-- upvalues: t72 (copy), t1 (copy)
	local v669 = t72.new()

	if t75.action_type ~= nil then
		v669.action_type = if typeof(t75.action_type) ~= "number" then t1.ActionType.fromName(t75.action_type) or t75.action_type else t1.ActionType.fromNumber(t75.action_type) or t75.action_type
	end

	if t75.actionType ~= nil then
		v669.action_type = if typeof(t75.actionType) ~= "number" then t1.ActionType.fromName(t75.actionType) or t75.actionType else t1.ActionType.fromNumber(t75.actionType) or t75.actionType
	end

	if t75.action_params ~= nil then
		v669.action_params = t1.UpdateUserSettingsAction_Params.jsonDecode(t75.action_params)
	end

	if t75.actionParams ~= nil then
		v669.action_params = t1.UpdateUserSettingsAction_Params.jsonDecode(t75.actionParams)
	end

	return v669
end

t72.descriptor = {
	name = "UpdateUserSettingsAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.UpdateUserSettingsAction"
}
t1.UpdateUserSettingsAction = t72
typeRegistry.default:register(t1.UpdateUserSettingsAction)

local t76 = {}

t76.__index = t76

function t76.new(t77: {[any]: any}?) -- line: 7649
	-- upvalues: t76 (copy)
	return (setmetatable({
		settings = if t77 ~= nil and t77.settings ~= nil then t77.settings else nil,
		audit_data = if t77 ~= nil and t77.audit_data ~= nil then t77.audit_data else nil
	}, t76))
end
function t76.encode(p58) -- line: 7658
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n37 = 0

	if p58.settings ~= nil then
		local v674 = p58.settings:encode()
		local v675, v676 = proto.writeTag(buf, n37, 1, proto.wireTypes.lengthDelimited)

		buf, n37 = proto.writeBuffer(v675, v676, v674, buffer.len(v674))
	end

	if p58.audit_data ~= nil then
		local v677 = p58.audit_data:encode()
		local v678, v679 = proto.writeTag(buf, n37, 2, proto.wireTypes.lengthDelimited)

		buf, n37 = proto.writeBuffer(v678, v679, v677, buffer.len(v677))
	end

	local buf21 = buffer.create(n37)

	buffer.copy(buf21, 0, buf, 0, n37)

	return buf21
end
function t76.decode(p59: buffer) -- line: 7679
	-- upvalues: t76 (copy), proto (copy), prop_types (copy)
	local v682 = t76.new()
	local n38 = 0

	while n38 < buffer.len(p59) do
		local v684, v685

		v684, v685, n38 = proto.readTag(p59, n38)

		if v685 == proto.wireTypes.varint then
			local v686

			v686, n38 = proto.readVarInt(p59, n38)
		elseif v685 == proto.wireTypes.lengthDelimited then
			if v684 == 1 then
				local v687

				v687, n38 = proto.readBuffer(p59, n38)
				v682.settings = prop_types.StructProp.decode(v687)
			elseif v684 == 2 then
				local v688

				v688, n38 = proto.readBuffer(p59, n38)
				v682.audit_data = prop_types.StringProp.decode(v688)
			else
				local v689, v690 = proto.readVarInt(p59, n38)

				n38 = v690 + v689
			end
		elseif v685 == proto.wireTypes.i32 then
			local v691

			v691, n38 = proto.readFixed32(p59, n38)
		elseif v685 == proto.wireTypes.i64 then
			local v692

			v692, n38 = proto.readFixed64(p59, n38)
		else
			error("Unsupported wire type: " .. v685)
		end
	end

	return v682
end
function t76.jsonEncode(p60) -- line: 7727
	local t78 = {}

	if p60.settings ~= nil then
		t78.settings = p60.settings:jsonEncode()
	end

	if p60.audit_data ~= nil then
		t78.auditData = p60.audit_data:jsonEncode()
	end

	return t78
end
function t76.jsonDecode(t79: {[any]: any}) -- line: 7741
	-- upvalues: t76 (copy), prop_types (copy)
	local v696 = t76.new()

	if t79.settings ~= nil then
		v696.settings = prop_types.StructProp.jsonDecode(t79.settings)
	end

	if t79.audit_data ~= nil then
		v696.audit_data = prop_types.StringProp.jsonDecode(t79.audit_data)
	end

	if t79.auditData ~= nil then
		v696.audit_data = prop_types.StringProp.jsonDecode(t79.auditData)
	end

	return v696
end

t76.descriptor = {
	name = "UpdateUserSettingsAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.UpdateUserSettingsAction_Params = t76
typeRegistry.default:register(t1.UpdateUserSettingsAction_Params)

local t80 = {}

t80.__index = t80

function t80.new(t81: {[any]: any}?) -- line: 7773
	-- upvalues: t1 (copy), t80 (copy)
	return (setmetatable({
		action_type = if t81 ~= nil and t81.action_type ~= nil then t81.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t81 ~= nil and t81.action_params ~= nil then t81.action_params else nil
	}, t80))
end
function t80.encode(p61) -- line: 7782
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n39 = 0

	if p61.action_type ~= nil and (p61.action_type ~= nil and p61.action_type ~= 0 or p61.action_type ~= t1.ActionType.fromNumber(0)) then
		local v701, v702 = proto.writeTag(buf, n39, 1, proto.wireTypes.varint)

		buf, n39 = proto.writeVarInt(v701, v702, t1.ActionType.toNumber(p61.action_type))
	end

	if p61.action_params ~= nil then
		local v703 = p61.action_params:encode()
		local v704, v705 = proto.writeTag(buf, n39, 2, proto.wireTypes.lengthDelimited)

		buf, n39 = proto.writeBuffer(v704, v705, v703, buffer.len(v703))
	end

	local buf22 = buffer.create(n39)

	buffer.copy(buf22, 0, buf, 0, n39)

	return buf22
end
function t80.decode(p62: buffer) -- line: 7808
	-- upvalues: t80 (copy), proto (copy), t1 (copy)
	local v708 = t80.new()
	local n40 = 0

	while n40 < buffer.len(p62) do
		local v710, v711

		v710, v711, n40 = proto.readTag(p62, n40)

		if v711 == proto.wireTypes.varint then
			if v710 == 1 then
				local v712

				v712, n40 = proto.readVarIntI32(p62, n40)
				v708.action_type = t1.ActionType.fromNumber(v712) or v712
			else
				local v713

				v713, n40 = proto.readVarInt(p62, n40)
			end
		elseif v711 == proto.wireTypes.lengthDelimited then
			if v710 == 2 then
				local v714

				v714, n40 = proto.readBuffer(p62, n40)
				v708.action_params = t1.OpenTooltipAction_Params.decode(v714)
			else
				local v715, v716 = proto.readVarInt(p62, n40)

				n40 = v716 + v715
			end
		elseif v711 == proto.wireTypes.i32 then
			local v717

			v717, n40 = proto.readFixed32(p62, n40)
		elseif v711 == proto.wireTypes.i64 then
			local v718

			v718, n40 = proto.readFixed64(p62, n40)
		else
			error("Unsupported wire type: " .. v711)
		end
	end

	return v708
end
function t80.jsonEncode(p63) -- line: 7856
	-- upvalues: t1 (copy)
	local t82 = {}

	if p63.action_type ~= nil and (p63.action_type ~= nil and p63.action_type ~= 0 or p63.action_type ~= t1.ActionType.fromNumber(0)) then
		t82.actionType = if typeof(p63.action_type) ~= "number" then t1.ActionType.toNumber(p63.action_type) else p63.action_type
	end

	if p63.action_params ~= nil then
		t82.actionParams = p63.action_params:jsonEncode()
	end

	return t82
end
function t80.jsonDecode(t83: {[any]: any}) -- line: 7878
	-- upvalues: t80 (copy), t1 (copy)
	local v722 = t80.new()

	if t83.action_type ~= nil then
		v722.action_type = if typeof(t83.action_type) ~= "number" then t1.ActionType.fromName(t83.action_type) or t83.action_type else t1.ActionType.fromNumber(t83.action_type) or t83.action_type
	end

	if t83.actionType ~= nil then
		v722.action_type = if typeof(t83.actionType) ~= "number" then t1.ActionType.fromName(t83.actionType) or t83.actionType else t1.ActionType.fromNumber(t83.actionType) or t83.actionType
	end

	if t83.action_params ~= nil then
		v722.action_params = t1.OpenTooltipAction_Params.jsonDecode(t83.action_params)
	end

	if t83.actionParams ~= nil then
		v722.action_params = t1.OpenTooltipAction_Params.jsonDecode(t83.actionParams)
	end

	return v722
end

t80.descriptor = {
	name = "OpenTooltipAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.OpenTooltipAction"
}
t1.OpenTooltipAction = t80
typeRegistry.default:register(t1.OpenTooltipAction)

local t84 = {}

t84.__index = t84

function t84.new(t85: {[any]: any}?) -- line: 7918
	-- upvalues: t84 (copy)
	return (setmetatable({
		tooltip_title = if t85 ~= nil and t85.tooltip_title ~= nil then t85.tooltip_title else nil,
		tooltip_info_text = if t85 ~= nil and t85.tooltip_info_text ~= nil then t85.tooltip_info_text else nil
	}, t84))
end
function t84.encode(p64) -- line: 7925
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n41 = 0

	if p64.tooltip_title ~= nil then
		local v727 = p64.tooltip_title:encode()
		local v728, v729 = proto.writeTag(buf, n41, 1, proto.wireTypes.lengthDelimited)

		buf, n41 = proto.writeBuffer(v728, v729, v727, buffer.len(v727))
	end

	if p64.tooltip_info_text ~= nil then
		local v730 = p64.tooltip_info_text:encode()
		local v731, v732 = proto.writeTag(buf, n41, 2, proto.wireTypes.lengthDelimited)

		buf, n41 = proto.writeBuffer(v731, v732, v730, buffer.len(v730))
	end

	local buf23 = buffer.create(n41)

	buffer.copy(buf23, 0, buf, 0, n41)

	return buf23
end
function t84.decode(p65: buffer) -- line: 7946
	-- upvalues: t84 (copy), proto (copy), prop_types (copy)
	local v735 = t84.new()
	local n42 = 0

	while n42 < buffer.len(p65) do
		local v737, v738

		v737, v738, n42 = proto.readTag(p65, n42)

		if v738 == proto.wireTypes.varint then
			local v739

			v739, n42 = proto.readVarInt(p65, n42)
		elseif v738 == proto.wireTypes.lengthDelimited then
			if v737 == 1 then
				local v740

				v740, n42 = proto.readBuffer(p65, n42)
				v735.tooltip_title = prop_types.StringProp.decode(v740)
			elseif v737 == 2 then
				local v741

				v741, n42 = proto.readBuffer(p65, n42)
				v735.tooltip_info_text = prop_types.StringProp.decode(v741)
			else
				local v742, v743 = proto.readVarInt(p65, n42)

				n42 = v743 + v742
			end
		elseif v738 == proto.wireTypes.i32 then
			local v744

			v744, n42 = proto.readFixed32(p65, n42)
		elseif v738 == proto.wireTypes.i64 then
			local v745

			v745, n42 = proto.readFixed64(p65, n42)
		else
			error("Unsupported wire type: " .. v738)
		end
	end

	return v735
end
function t84.jsonEncode(p66) -- line: 7994
	local t86 = {}

	if p66.tooltip_title ~= nil then
		t86.tooltipTitle = p66.tooltip_title:jsonEncode()
	end

	if p66.tooltip_info_text ~= nil then
		t86.tooltipInfoText = p66.tooltip_info_text:jsonEncode()
	end

	return t86
end
function t84.jsonDecode(t87: {[any]: any}) -- line: 8008
	-- upvalues: t84 (copy), prop_types (copy)
	local v749 = t84.new()

	if t87.tooltip_title ~= nil then
		v749.tooltip_title = prop_types.StringProp.jsonDecode(t87.tooltip_title)
	end

	if t87.tooltipTitle ~= nil then
		v749.tooltip_title = prop_types.StringProp.jsonDecode(t87.tooltipTitle)
	end

	if t87.tooltip_info_text ~= nil then
		v749.tooltip_info_text = prop_types.StringProp.jsonDecode(t87.tooltip_info_text)
	end

	if t87.tooltipInfoText ~= nil then
		v749.tooltip_info_text = prop_types.StringProp.jsonDecode(t87.tooltipInfoText)
	end

	return v749
end

t84.descriptor = {
	name = "OpenTooltipAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.OpenTooltipAction_Params = t84
typeRegistry.default:register(t1.OpenTooltipAction_Params)

local t88 = {}

t88.__index = t88

function t88.new(t89: {[any]: any}?) -- line: 8048
	-- upvalues: t1 (copy), t88 (copy)
	return (setmetatable({
		action_type = if t89 ~= nil and t89.action_type ~= nil then t89.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t89 ~= nil and t89.action_params ~= nil then t89.action_params else nil
	}, t88))
end
function t88.encode(p67) -- line: 8057
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n43 = 0

	if p67.action_type ~= nil and (p67.action_type ~= nil and p67.action_type ~= 0 or p67.action_type ~= t1.ActionType.fromNumber(0)) then
		local v754, v755 = proto.writeTag(buf, n43, 1, proto.wireTypes.varint)

		buf, n43 = proto.writeVarInt(v754, v755, t1.ActionType.toNumber(p67.action_type))
	end

	if p67.action_params ~= nil then
		local v756 = p67.action_params:encode()
		local v757, v758 = proto.writeTag(buf, n43, 2, proto.wireTypes.lengthDelimited)

		buf, n43 = proto.writeBuffer(v757, v758, v756, buffer.len(v756))
	end

	local buf24 = buffer.create(n43)

	buffer.copy(buf24, 0, buf, 0, n43)

	return buf24
end
function t88.decode(p68: buffer) -- line: 8083
	-- upvalues: t88 (copy), proto (copy), t1 (copy)
	local v761 = t88.new()
	local n44 = 0

	while n44 < buffer.len(p68) do
		local v763, v764

		v763, v764, n44 = proto.readTag(p68, n44)

		if v764 == proto.wireTypes.varint then
			if v763 == 1 then
				local v765

				v765, n44 = proto.readVarIntI32(p68, n44)
				v761.action_type = t1.ActionType.fromNumber(v765) or v765
			else
				local v766

				v766, n44 = proto.readVarInt(p68, n44)
			end
		elseif v764 == proto.wireTypes.lengthDelimited then
			if v763 == 2 then
				local v767

				v767, n44 = proto.readBuffer(p68, n44)
				v761.action_params = t1.OpenBadgeDetailsAction_Params.decode(v767)
			else
				local v768, v769 = proto.readVarInt(p68, n44)

				n44 = v769 + v768
			end
		elseif v764 == proto.wireTypes.i32 then
			local v770

			v770, n44 = proto.readFixed32(p68, n44)
		elseif v764 == proto.wireTypes.i64 then
			local v771

			v771, n44 = proto.readFixed64(p68, n44)
		else
			error("Unsupported wire type: " .. v764)
		end
	end

	return v761
end
function t88.jsonEncode(p69) -- line: 8131
	-- upvalues: t1 (copy)
	local t90 = {}

	if p69.action_type ~= nil and (p69.action_type ~= nil and p69.action_type ~= 0 or p69.action_type ~= t1.ActionType.fromNumber(0)) then
		t90.actionType = if typeof(p69.action_type) ~= "number" then t1.ActionType.toNumber(p69.action_type) else p69.action_type
	end

	if p69.action_params ~= nil then
		t90.actionParams = p69.action_params:jsonEncode()
	end

	return t90
end
function t88.jsonDecode(t91: {[any]: any}) -- line: 8153
	-- upvalues: t88 (copy), t1 (copy)
	local v775 = t88.new()

	if t91.action_type ~= nil then
		v775.action_type = if typeof(t91.action_type) ~= "number" then t1.ActionType.fromName(t91.action_type) or t91.action_type else t1.ActionType.fromNumber(t91.action_type) or t91.action_type
	end

	if t91.actionType ~= nil then
		v775.action_type = if typeof(t91.actionType) ~= "number" then t1.ActionType.fromName(t91.actionType) or t91.actionType else t1.ActionType.fromNumber(t91.actionType) or t91.actionType
	end

	if t91.action_params ~= nil then
		v775.action_params = t1.OpenBadgeDetailsAction_Params.jsonDecode(t91.action_params)
	end

	if t91.actionParams ~= nil then
		v775.action_params = t1.OpenBadgeDetailsAction_Params.jsonDecode(t91.actionParams)
	end

	return v775
end

t88.descriptor = {
	name = "OpenBadgeDetailsAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.OpenBadgeDetailsAction"
}
t1.OpenBadgeDetailsAction = t88
typeRegistry.default:register(t1.OpenBadgeDetailsAction)

local t92 = {}

t92.__index = t92

function t92.new(t93: {[any]: any}?) -- line: 8193
	-- upvalues: t92 (copy)
	return (setmetatable({
		badge_id = if t93 ~= nil and t93.badge_id ~= nil then t93.badge_id else nil,
		title_text = if t93 ~= nil and t93.title_text ~= nil then t93.title_text else nil
	}, t92))
end
function t92.encode(p70) -- line: 8202
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n45 = 0

	if p70.badge_id ~= nil then
		local v780 = p70.badge_id:encode()
		local v781, v782 = proto.writeTag(buf, n45, 1, proto.wireTypes.lengthDelimited)

		buf, n45 = proto.writeBuffer(v781, v782, v780, buffer.len(v780))
	end

	if p70.title_text ~= nil then
		local v783 = p70.title_text:encode()
		local v784, v785 = proto.writeTag(buf, n45, 2, proto.wireTypes.lengthDelimited)

		buf, n45 = proto.writeBuffer(v784, v785, v783, buffer.len(v783))
	end

	local buf25 = buffer.create(n45)

	buffer.copy(buf25, 0, buf, 0, n45)

	return buf25
end
function t92.decode(p71: buffer) -- line: 8223
	-- upvalues: t92 (copy), proto (copy), prop_types (copy)
	local v788 = t92.new()
	local n46 = 0

	while n46 < buffer.len(p71) do
		local v790, v791

		v790, v791, n46 = proto.readTag(p71, n46)

		if v791 == proto.wireTypes.varint then
			local v792

			v792, n46 = proto.readVarInt(p71, n46)
		elseif v791 == proto.wireTypes.lengthDelimited then
			if v790 == 1 then
				local v793

				v793, n46 = proto.readBuffer(p71, n46)
				v788.badge_id = prop_types.StringProp.decode(v793)
			elseif v790 == 2 then
				local v794

				v794, n46 = proto.readBuffer(p71, n46)
				v788.title_text = prop_types.StringProp.decode(v794)
			else
				local v795, v796 = proto.readVarInt(p71, n46)

				n46 = v796 + v795
			end
		elseif v791 == proto.wireTypes.i32 then
			local v797

			v797, n46 = proto.readFixed32(p71, n46)
		elseif v791 == proto.wireTypes.i64 then
			local v798

			v798, n46 = proto.readFixed64(p71, n46)
		else
			error("Unsupported wire type: " .. v791)
		end
	end

	return v788
end
function t92.jsonEncode(p72) -- line: 8271
	local t94 = {}

	if p72.badge_id ~= nil then
		t94.badgeId = p72.badge_id:jsonEncode()
	end

	if p72.title_text ~= nil then
		t94.titleText = p72.title_text:jsonEncode()
	end

	return t94
end
function t92.jsonDecode(t95: {[any]: any}) -- line: 8285
	-- upvalues: t92 (copy), prop_types (copy)
	local v802 = t92.new()

	if t95.badge_id ~= nil then
		v802.badge_id = prop_types.StringProp.jsonDecode(t95.badge_id)
	end

	if t95.badgeId ~= nil then
		v802.badge_id = prop_types.StringProp.jsonDecode(t95.badgeId)
	end

	if t95.title_text ~= nil then
		v802.title_text = prop_types.StringProp.jsonDecode(t95.title_text)
	end

	if t95.titleText ~= nil then
		v802.title_text = prop_types.StringProp.jsonDecode(t95.titleText)
	end

	return v802
end

t92.descriptor = {
	name = "OpenBadgeDetailsAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.OpenBadgeDetailsAction_Params = t92
typeRegistry.default:register(t1.OpenBadgeDetailsAction_Params)

local t96 = {}

t96.__index = t96

function t96.new(t97: {[any]: any}?) -- line: 8321
	-- upvalues: t1 (copy), t96 (copy)
	return (setmetatable({
		action_type = if t97 ~= nil and t97.action_type ~= nil then t97.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t97 ~= nil and t97.action_params ~= nil then t97.action_params else nil
	}, t96))
end
function t96.encode(p73) -- line: 8330
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n47 = 0

	if p73.action_type ~= nil and (p73.action_type ~= nil and p73.action_type ~= 0 or p73.action_type ~= t1.ActionType.fromNumber(0)) then
		local v807, v808 = proto.writeTag(buf, n47, 1, proto.wireTypes.varint)

		buf, n47 = proto.writeVarInt(v807, v808, t1.ActionType.toNumber(p73.action_type))
	end

	if p73.action_params ~= nil then
		local v809 = p73.action_params:encode()
		local v810, v811 = proto.writeTag(buf, n47, 2, proto.wireTypes.lengthDelimited)

		buf, n47 = proto.writeBuffer(v810, v811, v809, buffer.len(v809))
	end

	local buf26 = buffer.create(n47)

	buffer.copy(buf26, 0, buf, 0, n47)

	return buf26
end
function t96.decode(p74: buffer) -- line: 8356
	-- upvalues: t96 (copy), proto (copy), t1 (copy)
	local v814 = t96.new()
	local n48 = 0

	while n48 < buffer.len(p74) do
		local v816, v817

		v816, v817, n48 = proto.readTag(p74, n48)

		if v817 == proto.wireTypes.varint then
			if v816 == 1 then
				local v818

				v818, n48 = proto.readVarIntI32(p74, n48)
				v814.action_type = t1.ActionType.fromNumber(v818) or v818
			else
				local v819

				v819, n48 = proto.readVarInt(p74, n48)
			end
		elseif v817 == proto.wireTypes.lengthDelimited then
			if v816 == 2 then
				local v820

				v820, n48 = proto.readBuffer(p74, n48)
				v814.action_params = t1.LoadMoreFromApiAction_Params.decode(v820)
			else
				local v821, v822 = proto.readVarInt(p74, n48)

				n48 = v822 + v821
			end
		elseif v817 == proto.wireTypes.i32 then
			local v823

			v823, n48 = proto.readFixed32(p74, n48)
		elseif v817 == proto.wireTypes.i64 then
			local v824

			v824, n48 = proto.readFixed64(p74, n48)
		else
			error("Unsupported wire type: " .. v817)
		end
	end

	return v814
end
function t96.jsonEncode(p75) -- line: 8404
	-- upvalues: t1 (copy)
	local t98 = {}

	if p75.action_type ~= nil and (p75.action_type ~= nil and p75.action_type ~= 0 or p75.action_type ~= t1.ActionType.fromNumber(0)) then
		t98.actionType = if typeof(p75.action_type) ~= "number" then t1.ActionType.toNumber(p75.action_type) else p75.action_type
	end

	if p75.action_params ~= nil then
		t98.actionParams = p75.action_params:jsonEncode()
	end

	return t98
end
function t96.jsonDecode(t99: {[any]: any}) -- line: 8426
	-- upvalues: t96 (copy), t1 (copy)
	local v828 = t96.new()

	if t99.action_type ~= nil then
		v828.action_type = if typeof(t99.action_type) ~= "number" then t1.ActionType.fromName(t99.action_type) or t99.action_type else t1.ActionType.fromNumber(t99.action_type) or t99.action_type
	end

	if t99.actionType ~= nil then
		v828.action_type = if typeof(t99.actionType) ~= "number" then t1.ActionType.fromName(t99.actionType) or t99.actionType else t1.ActionType.fromNumber(t99.actionType) or t99.actionType
	end

	if t99.action_params ~= nil then
		v828.action_params = t1.LoadMoreFromApiAction_Params.jsonDecode(t99.action_params)
	end

	if t99.actionParams ~= nil then
		v828.action_params = t1.LoadMoreFromApiAction_Params.jsonDecode(t99.actionParams)
	end

	return v828
end

t96.descriptor = {
	name = "LoadMoreFromApiAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.LoadMoreFromApiAction"
}
t1.LoadMoreFromApiAction = t96
typeRegistry.default:register(t1.LoadMoreFromApiAction)

local t100 = {}

t100.__index = t100

function t100.new(t101: {[any]: any}?) -- line: 8466
	-- upvalues: t100 (copy)
	return (setmetatable({
		surface_key = if t101 ~= nil and t101.surface_key ~= nil then t101.surface_key else nil,
		config_key = if t101 ~= nil and t101.config_key ~= nil then t101.config_key else nil
	}, t100))
end
function t100.encode(p76) -- line: 8475
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n49 = 0

	if p76.surface_key ~= nil then
		local v833 = p76.surface_key:encode()
		local v834, v835 = proto.writeTag(buf, n49, 1, proto.wireTypes.lengthDelimited)

		buf, n49 = proto.writeBuffer(v834, v835, v833, buffer.len(v833))
	end

	if p76.config_key ~= nil then
		local v836 = p76.config_key:encode()
		local v837, v838 = proto.writeTag(buf, n49, 2, proto.wireTypes.lengthDelimited)

		buf, n49 = proto.writeBuffer(v837, v838, v836, buffer.len(v836))
	end

	local buf27 = buffer.create(n49)

	buffer.copy(buf27, 0, buf, 0, n49)

	return buf27
end
function t100.decode(p77: buffer) -- line: 8496
	-- upvalues: t100 (copy), proto (copy), prop_types (copy)
	local v841 = t100.new()
	local n50 = 0

	while n50 < buffer.len(p77) do
		local v843, v844

		v843, v844, n50 = proto.readTag(p77, n50)

		if v844 == proto.wireTypes.varint then
			local v845

			v845, n50 = proto.readVarInt(p77, n50)
		elseif v844 == proto.wireTypes.lengthDelimited then
			if v843 == 1 then
				local v846

				v846, n50 = proto.readBuffer(p77, n50)
				v841.surface_key = prop_types.StringProp.decode(v846)
			elseif v843 == 2 then
				local v847

				v847, n50 = proto.readBuffer(p77, n50)
				v841.config_key = prop_types.StringProp.decode(v847)
			else
				local v848, v849 = proto.readVarInt(p77, n50)

				n50 = v849 + v848
			end
		elseif v844 == proto.wireTypes.i32 then
			local v850

			v850, n50 = proto.readFixed32(p77, n50)
		elseif v844 == proto.wireTypes.i64 then
			local v851

			v851, n50 = proto.readFixed64(p77, n50)
		else
			error("Unsupported wire type: " .. v844)
		end
	end

	return v841
end
function t100.jsonEncode(p78) -- line: 8544
	local t102 = {}

	if p78.surface_key ~= nil then
		t102.surfaceKey = p78.surface_key:jsonEncode()
	end

	if p78.config_key ~= nil then
		t102.configKey = p78.config_key:jsonEncode()
	end

	return t102
end
function t100.jsonDecode(t103: {[any]: any}) -- line: 8558
	-- upvalues: t100 (copy), prop_types (copy)
	local v855 = t100.new()

	if t103.surface_key ~= nil then
		v855.surface_key = prop_types.StringProp.jsonDecode(t103.surface_key)
	end

	if t103.surfaceKey ~= nil then
		v855.surface_key = prop_types.StringProp.jsonDecode(t103.surfaceKey)
	end

	if t103.config_key ~= nil then
		v855.config_key = prop_types.StringProp.jsonDecode(t103.config_key)
	end

	if t103.configKey ~= nil then
		v855.config_key = prop_types.StringProp.jsonDecode(t103.configKey)
	end

	return v855
end

t100.descriptor = {
	name = "LoadMoreFromApiAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.LoadMoreFromApiAction_Params = t100
typeRegistry.default:register(t1.LoadMoreFromApiAction_Params)

local t104 = {}

t104.__index = t104

function t104.new(t105: {[any]: any}?) -- line: 8595
	-- upvalues: t1 (copy), t104 (copy)
	return (setmetatable({
		action_type = if t105 ~= nil and t105.action_type ~= nil then t105.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t105 ~= nil and t105.action_params ~= nil then t105.action_params else nil
	}, t104))
end
function t104.encode(p79) -- line: 8604
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n51 = 0

	if p79.action_type ~= nil and (p79.action_type ~= nil and p79.action_type ~= 0 or p79.action_type ~= t1.ActionType.fromNumber(0)) then
		local v860, v861 = proto.writeTag(buf, n51, 1, proto.wireTypes.varint)

		buf, n51 = proto.writeVarInt(v860, v861, t1.ActionType.toNumber(p79.action_type))
	end

	if p79.action_params ~= nil then
		local v862 = p79.action_params:encode()
		local v863, v864 = proto.writeTag(buf, n51, 2, proto.wireTypes.lengthDelimited)

		buf, n51 = proto.writeBuffer(v863, v864, v862, buffer.len(v862))
	end

	local buf28 = buffer.create(n51)

	buffer.copy(buf28, 0, buf, 0, n51)

	return buf28
end
function t104.decode(p80: buffer) -- line: 8630
	-- upvalues: t104 (copy), proto (copy), t1 (copy)
	local v867 = t104.new()
	local n52 = 0

	while n52 < buffer.len(p80) do
		local v869, v870

		v869, v870, n52 = proto.readTag(p80, n52)

		if v870 == proto.wireTypes.varint then
			if v869 == 1 then
				local v871

				v871, n52 = proto.readVarIntI32(p80, n52)
				v867.action_type = t1.ActionType.fromNumber(v871) or v871
			else
				local v872

				v872, n52 = proto.readVarInt(p80, n52)
			end
		elseif v870 == proto.wireTypes.lengthDelimited then
			if v869 == 2 then
				local v873

				v873, n52 = proto.readBuffer(p80, n52)
				v867.action_params = t1.ShareAction_Params.decode(v873)
			else
				local v874, v875 = proto.readVarInt(p80, n52)

				n52 = v875 + v874
			end
		elseif v870 == proto.wireTypes.i32 then
			local v876

			v876, n52 = proto.readFixed32(p80, n52)
		elseif v870 == proto.wireTypes.i64 then
			local v877

			v877, n52 = proto.readFixed64(p80, n52)
		else
			error("Unsupported wire type: " .. v870)
		end
	end

	return v867
end
function t104.jsonEncode(p81) -- line: 8678
	-- upvalues: t1 (copy)
	local t106 = {}

	if p81.action_type ~= nil and (p81.action_type ~= nil and p81.action_type ~= 0 or p81.action_type ~= t1.ActionType.fromNumber(0)) then
		t106.actionType = if typeof(p81.action_type) ~= "number" then t1.ActionType.toNumber(p81.action_type) else p81.action_type
	end

	if p81.action_params ~= nil then
		t106.actionParams = p81.action_params:jsonEncode()
	end

	return t106
end
function t104.jsonDecode(t107: {[any]: any}) -- line: 8700
	-- upvalues: t104 (copy), t1 (copy)
	local v881 = t104.new()

	if t107.action_type ~= nil then
		v881.action_type = if typeof(t107.action_type) ~= "number" then t1.ActionType.fromName(t107.action_type) or t107.action_type else t1.ActionType.fromNumber(t107.action_type) or t107.action_type
	end

	if t107.actionType ~= nil then
		v881.action_type = if typeof(t107.actionType) ~= "number" then t1.ActionType.fromName(t107.actionType) or t107.actionType else t1.ActionType.fromNumber(t107.actionType) or t107.actionType
	end

	if t107.action_params ~= nil then
		v881.action_params = t1.ShareAction_Params.jsonDecode(t107.action_params)
	end

	if t107.actionParams ~= nil then
		v881.action_params = t1.ShareAction_Params.jsonDecode(t107.actionParams)
	end

	return v881
end

t104.descriptor = {
	name = "ShareAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.ShareAction"
}
t1.ShareAction = t104
typeRegistry.default:register(t1.ShareAction)

local t108 = {}

t108.__index = t108

function t108.new(t109: {[any]: any}?) -- line: 8740
	-- upvalues: t108 (copy)
	return (setmetatable({
		oneof_prop = if t109 ~= nil and t109.oneof_prop ~= nil then t109.oneof_prop else nil
	}, t108))
end
function t108.encode(p82) -- line: 8748
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n53 = 0

	if p82.oneof_prop ~= nil then
		if p82.oneof_prop.type == "generic_share_link_data" then
			local v886 = p82.oneof_prop.value:encode()
			local v887, v888 = proto.writeTag(buf, n53, 1, proto.wireTypes.lengthDelimited)

			buf, n53 = proto.writeBuffer(v887, v888, v886, buffer.len(v886))
		elseif p82.oneof_prop.type == "share_link_fetch_data" then
			local v889 = p82.oneof_prop.value:encode()
			local v890, v891 = proto.writeTag(buf, n53, 2, proto.wireTypes.lengthDelimited)

			buf, n53 = proto.writeBuffer(v890, v891, v889, buffer.len(v889))
		end
	end

	local buf29 = buffer.create(n53)

	buffer.copy(buf29, 0, buf, 0, n53)

	return buf29
end
function t108.decode(p83: buffer) -- line: 8769
	-- upvalues: t108 (copy), proto (copy), share_link_data (copy)
	local v894 = t108.new()
	local n54 = 0

	while n54 < buffer.len(p83) do
		local v896, v897

		v896, v897, n54 = proto.readTag(p83, n54)

		if v897 == proto.wireTypes.varint then
			local v898

			v898, n54 = proto.readVarInt(p83, n54)
		elseif v897 == proto.wireTypes.lengthDelimited then
			if v896 == 1 then
				local v899

				v899, n54 = proto.readBuffer(p83, n54)
				v894.oneof_prop = {
					type = "generic_share_link_data",
					value = share_link_data.GenericShareLinkData.decode(v899)
				}
			elseif v896 == 2 then
				local v900

				v900, n54 = proto.readBuffer(p83, n54)
				v894.oneof_prop = {
					type = "share_link_fetch_data",
					value = share_link_data.ShareLinkFetchData.decode(v900)
				}
			else
				local v901, v902 = proto.readVarInt(p83, n54)

				n54 = v902 + v901
			end
		elseif v897 == proto.wireTypes.i32 then
			local v903

			v903, n54 = proto.readFixed32(p83, n54)
		elseif v897 == proto.wireTypes.i64 then
			local v904

			v904, n54 = proto.readFixed64(p83, n54)
		else
			error("Unsupported wire type: " .. v897)
		end
	end

	return v894
end
function t108.jsonEncode(p84) -- line: 8825
	local t110 = {}

	if p84.oneof_prop ~= nil then
		if p84.oneof_prop.type == "generic_share_link_data" then
			t110.genericShareLinkData = p84.oneof_prop.value:jsonEncode()

			return t110
		end

		if p84.oneof_prop.type == "share_link_fetch_data" then
			t110.shareLinkFetchData = p84.oneof_prop.value:jsonEncode()
		end
	end

	return t110
end
function t108.jsonDecode(t111: {[any]: any}) -- line: 8839
	-- upvalues: t108 (copy), share_link_data (copy)
	local v908 = t108.new()

	if t111.generic_share_link_data ~= nil then
		v908.oneof_prop = {
			type = "generic_share_link_data",
			value = share_link_data.GenericShareLinkData.jsonDecode(t111.generic_share_link_data)
		}
	end

	if t111.genericShareLinkData ~= nil then
		v908.oneof_prop = {
			type = "generic_share_link_data",
			value = share_link_data.GenericShareLinkData.jsonDecode(t111.genericShareLinkData)
		}
	end

	if t111.share_link_fetch_data ~= nil then
		v908.oneof_prop = {
			type = "share_link_fetch_data",
			value = share_link_data.ShareLinkFetchData.jsonDecode(t111.share_link_fetch_data)
		}
	end

	if t111.shareLinkFetchData ~= nil then
		v908.oneof_prop = {
			type = "share_link_fetch_data",
			value = share_link_data.ShareLinkFetchData.jsonDecode(t111.shareLinkFetchData)
		}
	end

	return v908
end

t108.descriptor = {
	name = "ShareAction_ShareLinkData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ShareLinkData"
}
t1.ShareAction_ShareLinkData = t108
typeRegistry.default:register(t1.ShareAction_ShareLinkData)

local t112 = {}

t112.__index = t112

function t112.new(t113: {[any]: any}?) -- line: 8895
	-- upvalues: t112 (copy)
	return (setmetatable({
		share_link_type = if t113 ~= nil and t113.share_link_type ~= nil then t113.share_link_type else nil,
		share_link_data = if t113 ~= nil and t113.share_link_data ~= nil then t113.share_link_data else nil,
		entry_point_key = if t113 ~= nil and t113.entry_point_key ~= nil then t113.entry_point_key else nil
	}, t112))
end
function t112.encode(p85) -- line: 8903
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n55 = 0

	if p85.share_link_type ~= nil then
		local v913 = p85.share_link_type:encode()
		local v914, v915 = proto.writeTag(buf, n55, 1, proto.wireTypes.lengthDelimited)

		buf, n55 = proto.writeBuffer(v914, v915, v913, buffer.len(v913))
	end

	if p85.share_link_data ~= nil then
		local v916 = p85.share_link_data:encode()
		local v917, v918 = proto.writeTag(buf, n55, 2, proto.wireTypes.lengthDelimited)

		buf, n55 = proto.writeBuffer(v917, v918, v916, buffer.len(v916))
	end

	if p85.entry_point_key ~= nil then
		local v919 = p85.entry_point_key:encode()
		local v920, v921 = proto.writeTag(buf, n55, 3, proto.wireTypes.lengthDelimited)

		buf, n55 = proto.writeBuffer(v920, v921, v919, buffer.len(v919))
	end

	local buf30 = buffer.create(n55)

	buffer.copy(buf30, 0, buf, 0, n55)

	return buf30
end
function t112.decode(p86: buffer) -- line: 8930
	-- upvalues: t112 (copy), proto (copy), prop_types (copy), t1 (copy)
	local v924 = t112.new()
	local n56 = 0

	while n56 < buffer.len(p86) do
		local v926, v927

		v926, v927, n56 = proto.readTag(p86, n56)

		if v927 == proto.wireTypes.varint then
			local v928

			v928, n56 = proto.readVarInt(p86, n56)
		elseif v927 == proto.wireTypes.lengthDelimited then
			if v926 == 1 then
				local v929

				v929, n56 = proto.readBuffer(p86, n56)
				v924.share_link_type = prop_types.StringProp.decode(v929)
			elseif v926 == 2 then
				local v930

				v930, n56 = proto.readBuffer(p86, n56)
				v924.share_link_data = t1.ShareAction_ShareLinkData.decode(v930)
			elseif v926 == 3 then
				local v931

				v931, n56 = proto.readBuffer(p86, n56)
				v924.entry_point_key = prop_types.StringProp.decode(v931)
			else
				local v932, v933 = proto.readVarInt(p86, n56)

				n56 = v933 + v932
			end
		elseif v927 == proto.wireTypes.i32 then
			local v934

			v934, n56 = proto.readFixed32(p86, n56)
		elseif v927 == proto.wireTypes.i64 then
			local v935

			v935, n56 = proto.readFixed64(p86, n56)
		else
			error("Unsupported wire type: " .. v927)
		end
	end

	return v924
end
function t112.jsonEncode(p87) -- line: 8983
	local t114 = {}

	if p87.share_link_type ~= nil then
		t114.shareLinkType = p87.share_link_type:jsonEncode()
	end

	if p87.share_link_data ~= nil then
		t114.shareLinkData = p87.share_link_data:jsonEncode()
	end

	if p87.entry_point_key ~= nil then
		t114.entryPointKey = p87.entry_point_key:jsonEncode()
	end

	return t114
end
function t112.jsonDecode(t115: {[any]: any}) -- line: 9001
	-- upvalues: t112 (copy), prop_types (copy), t1 (copy)
	local v939 = t112.new()

	if t115.share_link_type ~= nil then
		v939.share_link_type = prop_types.StringProp.jsonDecode(t115.share_link_type)
	end

	if t115.shareLinkType ~= nil then
		v939.share_link_type = prop_types.StringProp.jsonDecode(t115.shareLinkType)
	end

	if t115.share_link_data ~= nil then
		v939.share_link_data = t1.ShareAction_ShareLinkData.jsonDecode(t115.share_link_data)
	end

	if t115.shareLinkData ~= nil then
		v939.share_link_data = t1.ShareAction_ShareLinkData.jsonDecode(t115.shareLinkData)
	end

	if t115.entry_point_key ~= nil then
		v939.entry_point_key = prop_types.StringProp.jsonDecode(t115.entry_point_key)
	end

	if t115.entryPointKey ~= nil then
		v939.entry_point_key = prop_types.StringProp.jsonDecode(t115.entryPointKey)
	end

	return v939
end

t112.descriptor = {
	name = "ShareAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.ShareAction_Params = t112
typeRegistry.default:register(t1.ShareAction_Params)

local t116 = {}

t116.__index = t116

function t116.new(t117: {[any]: any}?) -- line: 9049
	-- upvalues: t1 (copy), t116 (copy)
	return (setmetatable({
		action_type = if t117 ~= nil and t117.action_type ~= nil then t117.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t117 ~= nil and t117.action_params ~= nil then t117.action_params else nil
	}, t116))
end
function t116.encode(p88) -- line: 9058
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n57 = 0

	if p88.action_type ~= nil and (p88.action_type ~= nil and p88.action_type ~= 0 or p88.action_type ~= t1.ActionType.fromNumber(0)) then
		local v944, v945 = proto.writeTag(buf, n57, 1, proto.wireTypes.varint)

		buf, n57 = proto.writeVarInt(v944, v945, t1.ActionType.toNumber(p88.action_type))
	end

	if p88.action_params ~= nil then
		local v946 = p88.action_params:encode()
		local v947, v948 = proto.writeTag(buf, n57, 2, proto.wireTypes.lengthDelimited)

		buf, n57 = proto.writeBuffer(v947, v948, v946, buffer.len(v946))
	end

	local buf31 = buffer.create(n57)

	buffer.copy(buf31, 0, buf, 0, n57)

	return buf31
end
function t116.decode(p89: buffer) -- line: 9084
	-- upvalues: t116 (copy), proto (copy), t1 (copy)
	local v951 = t116.new()
	local n58 = 0

	while n58 < buffer.len(p89) do
		local v953, v954

		v953, v954, n58 = proto.readTag(p89, n58)

		if v954 == proto.wireTypes.varint then
			if v953 == 1 then
				local v955

				v955, n58 = proto.readVarIntI32(p89, n58)
				v951.action_type = t1.ActionType.fromNumber(v955) or v955
			else
				local v956

				v956, n58 = proto.readVarInt(p89, n58)
			end
		elseif v954 == proto.wireTypes.lengthDelimited then
			if v953 == 2 then
				local v957

				v957, n58 = proto.readBuffer(p89, n58)
				v951.action_params = t1.OpenAbuseReportAction_Params.decode(v957)
			else
				local v958, v959 = proto.readVarInt(p89, n58)

				n58 = v959 + v958
			end
		elseif v954 == proto.wireTypes.i32 then
			local v960

			v960, n58 = proto.readFixed32(p89, n58)
		elseif v954 == proto.wireTypes.i64 then
			local v961

			v961, n58 = proto.readFixed64(p89, n58)
		else
			error("Unsupported wire type: " .. v954)
		end
	end

	return v951
end
function t116.jsonEncode(p90) -- line: 9132
	-- upvalues: t1 (copy)
	local t118 = {}

	if p90.action_type ~= nil and (p90.action_type ~= nil and p90.action_type ~= 0 or p90.action_type ~= t1.ActionType.fromNumber(0)) then
		t118.actionType = if typeof(p90.action_type) ~= "number" then t1.ActionType.toNumber(p90.action_type) else p90.action_type
	end

	if p90.action_params ~= nil then
		t118.actionParams = p90.action_params:jsonEncode()
	end

	return t118
end
function t116.jsonDecode(t119: {[any]: any}) -- line: 9154
	-- upvalues: t116 (copy), t1 (copy)
	local v965 = t116.new()

	if t119.action_type ~= nil then
		v965.action_type = if typeof(t119.action_type) ~= "number" then t1.ActionType.fromName(t119.action_type) or t119.action_type else t1.ActionType.fromNumber(t119.action_type) or t119.action_type
	end

	if t119.actionType ~= nil then
		v965.action_type = if typeof(t119.actionType) ~= "number" then t1.ActionType.fromName(t119.actionType) or t119.actionType else t1.ActionType.fromNumber(t119.actionType) or t119.actionType
	end

	if t119.action_params ~= nil then
		v965.action_params = t1.OpenAbuseReportAction_Params.jsonDecode(t119.action_params)
	end

	if t119.actionParams ~= nil then
		v965.action_params = t1.OpenAbuseReportAction_Params.jsonDecode(t119.actionParams)
	end

	return v965
end

t116.descriptor = {
	name = "OpenAbuseReportAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.OpenAbuseReportAction"
}
t1.OpenAbuseReportAction = t116
typeRegistry.default:register(t1.OpenAbuseReportAction)

local t120 = {}

t120.__index = t120

function t120.new(t121: {[any]: any}?) -- line: 9194
	-- upvalues: t120 (copy)
	return (setmetatable({
		target_id = if t121 ~= nil and t121.target_id ~= nil then t121.target_id else nil,
		abuse_vector = if t121 ~= nil and t121.abuse_vector ~= nil then t121.abuse_vector else nil,
		asset_type_name = if t121 ~= nil and t121.asset_type_name ~= nil then t121.asset_type_name else nil,
		universe_id = if t121 ~= nil and t121.universe_id ~= nil then t121.universe_id else nil
	}, t120))
end
function t120.encode(p91) -- line: 9205
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n59 = 0

	if p91.target_id ~= nil then
		local v970 = p91.target_id:encode()
		local v971, v972 = proto.writeTag(buf, n59, 1, proto.wireTypes.lengthDelimited)

		buf, n59 = proto.writeBuffer(v971, v972, v970, buffer.len(v970))
	end

	if p91.abuse_vector ~= nil then
		local v973 = p91.abuse_vector:encode()
		local v974, v975 = proto.writeTag(buf, n59, 2, proto.wireTypes.lengthDelimited)

		buf, n59 = proto.writeBuffer(v974, v975, v973, buffer.len(v973))
	end

	if p91.asset_type_name ~= nil then
		local v976 = p91.asset_type_name:encode()
		local v977, v978 = proto.writeTag(buf, n59, 3, proto.wireTypes.lengthDelimited)

		buf, n59 = proto.writeBuffer(v977, v978, v976, buffer.len(v976))
	end

	if p91.universe_id ~= nil then
		local v979 = p91.universe_id:encode()
		local v980, v981 = proto.writeTag(buf, n59, 4, proto.wireTypes.lengthDelimited)

		buf, n59 = proto.writeBuffer(v980, v981, v979, buffer.len(v979))
	end

	local buf32 = buffer.create(n59)

	buffer.copy(buf32, 0, buf, 0, n59)

	return buf32
end
function t120.decode(p92: buffer) -- line: 9238
	-- upvalues: t120 (copy), proto (copy), prop_types (copy)
	local v984 = t120.new()
	local n60 = 0

	while n60 < buffer.len(p92) do
		local v986, v987

		v986, v987, n60 = proto.readTag(p92, n60)

		if v987 == proto.wireTypes.varint then
			local v988

			v988, n60 = proto.readVarInt(p92, n60)
		elseif v987 == proto.wireTypes.lengthDelimited then
			if v986 == 1 then
				local v989

				v989, n60 = proto.readBuffer(p92, n60)
				v984.target_id = prop_types.StringProp.decode(v989)
			elseif v986 == 2 then
				local v990

				v990, n60 = proto.readBuffer(p92, n60)
				v984.abuse_vector = prop_types.StringProp.decode(v990)
			elseif v986 == 3 then
				local v991

				v991, n60 = proto.readBuffer(p92, n60)
				v984.asset_type_name = prop_types.StringProp.decode(v991)
			elseif v986 == 4 then
				local v992

				v992, n60 = proto.readBuffer(p92, n60)
				v984.universe_id = prop_types.StringProp.decode(v992)
			else
				local v993, v994 = proto.readVarInt(p92, n60)

				n60 = v994 + v993
			end
		elseif v987 == proto.wireTypes.i32 then
			local v995

			v995, n60 = proto.readFixed32(p92, n60)
		elseif v987 == proto.wireTypes.i64 then
			local v996

			v996, n60 = proto.readFixed64(p92, n60)
		else
			error("Unsupported wire type: " .. v987)
		end
	end

	return v984
end
function t120.jsonEncode(p93) -- line: 9296
	local t122 = {}

	if p93.target_id ~= nil then
		t122.targetId = p93.target_id:jsonEncode()
	end

	if p93.abuse_vector ~= nil then
		t122.abuseVector = p93.abuse_vector:jsonEncode()
	end

	if p93.asset_type_name ~= nil then
		t122.assetTypeName = p93.asset_type_name:jsonEncode()
	end

	if p93.universe_id ~= nil then
		t122.universeId = p93.universe_id:jsonEncode()
	end

	return t122
end
function t120.jsonDecode(t123: {[any]: any}) -- line: 9318
	-- upvalues: t120 (copy), prop_types (copy)
	local v1000 = t120.new()

	if t123.target_id ~= nil then
		v1000.target_id = prop_types.StringProp.jsonDecode(t123.target_id)
	end

	if t123.targetId ~= nil then
		v1000.target_id = prop_types.StringProp.jsonDecode(t123.targetId)
	end

	if t123.abuse_vector ~= nil then
		v1000.abuse_vector = prop_types.StringProp.jsonDecode(t123.abuse_vector)
	end

	if t123.abuseVector ~= nil then
		v1000.abuse_vector = prop_types.StringProp.jsonDecode(t123.abuseVector)
	end

	if t123.asset_type_name ~= nil then
		v1000.asset_type_name = prop_types.StringProp.jsonDecode(t123.asset_type_name)
	end

	if t123.assetTypeName ~= nil then
		v1000.asset_type_name = prop_types.StringProp.jsonDecode(t123.assetTypeName)
	end

	if t123.universe_id ~= nil then
		v1000.universe_id = prop_types.StringProp.jsonDecode(t123.universe_id)
	end

	if t123.universeId ~= nil then
		v1000.universe_id = prop_types.StringProp.jsonDecode(t123.universeId)
	end

	return v1000
end

t120.descriptor = {
	name = "OpenAbuseReportAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.OpenAbuseReportAction_Params = t120
typeRegistry.default:register(t1.OpenAbuseReportAction_Params)

local t124 = {}

t124.__index = t124

function t124.new(t125: {[any]: any}?) -- line: 9375
	-- upvalues: t1 (copy), t124 (copy)
	return (setmetatable({
		action_type = if t125 ~= nil and t125.action_type ~= nil then t125.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t125 ~= nil and t125.action_params ~= nil then t125.action_params else nil
	}, t124))
end
function t124.encode(p94) -- line: 9386
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n61 = 0

	if p94.action_type ~= nil and (p94.action_type ~= nil and p94.action_type ~= 0 or p94.action_type ~= t1.ActionType.fromNumber(0)) then
		local v1005, v1006 = proto.writeTag(buf, n61, 1, proto.wireTypes.varint)

		buf, n61 = proto.writeVarInt(v1005, v1006, t1.ActionType.toNumber(p94.action_type))
	end

	if p94.action_params ~= nil then
		local v1007 = p94.action_params:encode()
		local v1008, v1009 = proto.writeTag(buf, n61, 2, proto.wireTypes.lengthDelimited)

		buf, n61 = proto.writeBuffer(v1008, v1009, v1007, buffer.len(v1007))
	end

	local buf33 = buffer.create(n61)

	buffer.copy(buf33, 0, buf, 0, n61)

	return buf33
end
function t124.decode(p95: buffer) -- line: 9412
	-- upvalues: t124 (copy), proto (copy), t1 (copy)
	local v1012 = t124.new()
	local n62 = 0

	while n62 < buffer.len(p95) do
		local v1014, v1015

		v1014, v1015, n62 = proto.readTag(p95, n62)

		if v1015 == proto.wireTypes.varint then
			if v1014 == 1 then
				local v1016

				v1016, n62 = proto.readVarIntI32(p95, n62)
				v1012.action_type = t1.ActionType.fromNumber(v1016) or v1016
			else
				local v1017

				v1017, n62 = proto.readVarInt(p95, n62)
			end
		elseif v1015 == proto.wireTypes.lengthDelimited then
			if v1014 == 2 then
				local v1018

				v1018, n62 = proto.readBuffer(p95, n62)
				v1012.action_params = t1.RemoveBadgeFromInventoryAction_Params.decode(v1018)
			else
				local v1019, v1020 = proto.readVarInt(p95, n62)

				n62 = v1020 + v1019
			end
		elseif v1015 == proto.wireTypes.i32 then
			local v1021

			v1021, n62 = proto.readFixed32(p95, n62)
		elseif v1015 == proto.wireTypes.i64 then
			local v1022

			v1022, n62 = proto.readFixed64(p95, n62)
		else
			error("Unsupported wire type: " .. v1015)
		end
	end

	return v1012
end
function t124.jsonEncode(p96) -- line: 9460
	-- upvalues: t1 (copy)
	local t126 = {}

	if p96.action_type ~= nil and (p96.action_type ~= nil and p96.action_type ~= 0 or p96.action_type ~= t1.ActionType.fromNumber(0)) then
		t126.actionType = if typeof(p96.action_type) ~= "number" then t1.ActionType.toNumber(p96.action_type) else p96.action_type
	end

	if p96.action_params ~= nil then
		t126.actionParams = p96.action_params:jsonEncode()
	end

	return t126
end
function t124.jsonDecode(t127: {[any]: any}) -- line: 9482
	-- upvalues: t124 (copy), t1 (copy)
	local v1026 = t124.new()

	if t127.action_type ~= nil then
		v1026.action_type = if typeof(t127.action_type) ~= "number" then t1.ActionType.fromName(t127.action_type) or t127.action_type else t1.ActionType.fromNumber(t127.action_type) or t127.action_type
	end

	if t127.actionType ~= nil then
		v1026.action_type = if typeof(t127.actionType) ~= "number" then t1.ActionType.fromName(t127.actionType) or t127.actionType else t1.ActionType.fromNumber(t127.actionType) or t127.actionType
	end

	if t127.action_params ~= nil then
		v1026.action_params = t1.RemoveBadgeFromInventoryAction_Params.jsonDecode(t127.action_params)
	end

	if t127.actionParams ~= nil then
		v1026.action_params = t1.RemoveBadgeFromInventoryAction_Params.jsonDecode(t127.actionParams)
	end

	return v1026
end

t124.descriptor = {
	name = "RemoveBadgeFromInventoryAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.RemoveBadgeFromInventoryAction"
}
t1.RemoveBadgeFromInventoryAction = t124
typeRegistry.default:register(t1.RemoveBadgeFromInventoryAction)

local t128 = {}

t128.__index = t128

function t128.new(t129: {[any]: any}?) -- line: 9522
	-- upvalues: t128 (copy)
	return (setmetatable({
		asset_id = if t129 ~= nil and t129.asset_id ~= nil then t129.asset_id else nil
	}, t128))
end
function t128.encode(p97) -- line: 9530
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n63 = 0

	if p97.asset_id ~= nil then
		local v1031 = p97.asset_id:encode()
		local v1032, v1033 = proto.writeTag(buf, n63, 1, proto.wireTypes.lengthDelimited)

		buf, n63 = proto.writeBuffer(v1032, v1033, v1031, buffer.len(v1031))
	end

	local buf34 = buffer.create(n63)

	buffer.copy(buf34, 0, buf, 0, n63)

	return buf34
end
function t128.decode(p98: buffer) -- line: 9545
	-- upvalues: t128 (copy), proto (copy), prop_types (copy)
	local v1036 = t128.new()
	local n64 = 0

	while n64 < buffer.len(p98) do
		local v1038, v1039

		v1038, v1039, n64 = proto.readTag(p98, n64)

		if v1039 == proto.wireTypes.varint then
			local v1040

			v1040, n64 = proto.readVarInt(p98, n64)
		elseif v1039 == proto.wireTypes.lengthDelimited then
			if v1038 == 1 then
				local v1041

				v1041, n64 = proto.readBuffer(p98, n64)
				v1036.asset_id = prop_types.StringProp.decode(v1041)
			else
				local v1042, v1043 = proto.readVarInt(p98, n64)

				n64 = v1043 + v1042
			end
		elseif v1039 == proto.wireTypes.i32 then
			local v1044

			v1044, n64 = proto.readFixed32(p98, n64)
		elseif v1039 == proto.wireTypes.i64 then
			local v1045

			v1045, n64 = proto.readFixed64(p98, n64)
		else
			error("Unsupported wire type: " .. v1039)
		end
	end

	return v1036
end
function t128.jsonEncode(p99) -- line: 9588
	local t130 = {}

	if p99.asset_id ~= nil then
		t130.assetId = p99.asset_id:jsonEncode()
	end

	return t130
end
function t128.jsonDecode(t131: {[any]: any}) -- line: 9598
	-- upvalues: t128 (copy), prop_types (copy)
	local v1049 = t128.new()

	if t131.asset_id ~= nil then
		v1049.asset_id = prop_types.StringProp.jsonDecode(t131.asset_id)
	end

	if t131.assetId ~= nil then
		v1049.asset_id = prop_types.StringProp.jsonDecode(t131.assetId)
	end

	return v1049
end

t128.descriptor = {
	name = "RemoveBadgeFromInventoryAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.RemoveBadgeFromInventoryAction_Params = t128
typeRegistry.default:register(t1.RemoveBadgeFromInventoryAction_Params)

local t132 = {}

t132.__index = t132

function t132.new(t133: {[any]: any}?) -- line: 9628
	-- upvalues: t1 (copy), t132 (copy)
	return (setmetatable({
		action_type = if t133 ~= nil and t133.action_type ~= nil then t133.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t133 ~= nil and t133.action_params ~= nil then t133.action_params else nil
	}, t132))
end
function t132.encode(p100) -- line: 9637
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n65 = 0

	if p100.action_type ~= nil and (p100.action_type ~= nil and p100.action_type ~= 0 or p100.action_type ~= t1.ActionType.fromNumber(0)) then
		local v1054, v1055 = proto.writeTag(buf, n65, 1, proto.wireTypes.varint)

		buf, n65 = proto.writeVarInt(v1054, v1055, t1.ActionType.toNumber(p100.action_type))
	end

	if p100.action_params ~= nil then
		local v1056 = p100.action_params:encode()
		local v1057, v1058 = proto.writeTag(buf, n65, 2, proto.wireTypes.lengthDelimited)

		buf, n65 = proto.writeBuffer(v1057, v1058, v1056, buffer.len(v1056))
	end

	local buf35 = buffer.create(n65)

	buffer.copy(buf35, 0, buf, 0, n65)

	return buf35
end
function t132.decode(p101: buffer) -- line: 9663
	-- upvalues: t132 (copy), proto (copy), t1 (copy)
	local v1061 = t132.new()
	local n66 = 0

	while n66 < buffer.len(p101) do
		local v1063, v1064

		v1063, v1064, n66 = proto.readTag(p101, n66)

		if v1064 == proto.wireTypes.varint then
			if v1063 == 1 then
				local v1065

				v1065, n66 = proto.readVarIntI32(p101, n66)
				v1061.action_type = t1.ActionType.fromNumber(v1065) or v1065
			else
				local v1066

				v1066, n66 = proto.readVarInt(p101, n66)
			end
		elseif v1064 == proto.wireTypes.lengthDelimited then
			if v1063 == 2 then
				local v1067

				v1067, n66 = proto.readBuffer(p101, n66)
				v1061.action_params = t1.OpenProfileAction_Params.decode(v1067)
			else
				local v1068, v1069 = proto.readVarInt(p101, n66)

				n66 = v1069 + v1068
			end
		elseif v1064 == proto.wireTypes.i32 then
			local v1070

			v1070, n66 = proto.readFixed32(p101, n66)
		elseif v1064 == proto.wireTypes.i64 then
			local v1071

			v1071, n66 = proto.readFixed64(p101, n66)
		else
			error("Unsupported wire type: " .. v1064)
		end
	end

	return v1061
end
function t132.jsonEncode(p102) -- line: 9711
	-- upvalues: t1 (copy)
	local t134 = {}

	if p102.action_type ~= nil and (p102.action_type ~= nil and p102.action_type ~= 0 or p102.action_type ~= t1.ActionType.fromNumber(0)) then
		t134.actionType = if typeof(p102.action_type) ~= "number" then t1.ActionType.toNumber(p102.action_type) else p102.action_type
	end

	if p102.action_params ~= nil then
		t134.actionParams = p102.action_params:jsonEncode()
	end

	return t134
end
function t132.jsonDecode(t135: {[any]: any}) -- line: 9733
	-- upvalues: t132 (copy), t1 (copy)
	local v1075 = t132.new()

	if t135.action_type ~= nil then
		v1075.action_type = if typeof(t135.action_type) ~= "number" then t1.ActionType.fromName(t135.action_type) or t135.action_type else t1.ActionType.fromNumber(t135.action_type) or t135.action_type
	end

	if t135.actionType ~= nil then
		v1075.action_type = if typeof(t135.actionType) ~= "number" then t1.ActionType.fromName(t135.actionType) or t135.actionType else t1.ActionType.fromNumber(t135.actionType) or t135.actionType
	end

	if t135.action_params ~= nil then
		v1075.action_params = t1.OpenProfileAction_Params.jsonDecode(t135.action_params)
	end

	if t135.actionParams ~= nil then
		v1075.action_params = t1.OpenProfileAction_Params.jsonDecode(t135.actionParams)
	end

	return v1075
end

t132.descriptor = {
	name = "OpenProfileAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.OpenProfileAction"
}
t1.OpenProfileAction = t132
typeRegistry.default:register(t1.OpenProfileAction)

local t136 = {}

t136.__index = t136

function t136.new(t137: {[any]: any}?) -- line: 9773
	-- upvalues: t136 (copy)
	return (setmetatable({
		profile_id = if t137 ~= nil and t137.profile_id ~= nil then t137.profile_id else nil,
		profile_type = if t137 ~= nil and t137.profile_type ~= nil then t137.profile_type else nil,
		source = if t137 ~= nil and t137.source ~= nil then t137.source else nil
	}, t136))
end
function t136.encode(p103) -- line: 9781
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n67 = 0

	if p103.profile_id ~= nil then
		local v1080 = p103.profile_id:encode()
		local v1081, v1082 = proto.writeTag(buf, n67, 1, proto.wireTypes.lengthDelimited)

		buf, n67 = proto.writeBuffer(v1081, v1082, v1080, buffer.len(v1080))
	end

	if p103.profile_type ~= nil then
		local v1083 = p103.profile_type:encode()
		local v1084, v1085 = proto.writeTag(buf, n67, 2, proto.wireTypes.lengthDelimited)

		buf, n67 = proto.writeBuffer(v1084, v1085, v1083, buffer.len(v1083))
	end

	if p103.source ~= nil then
		local v1086 = p103.source:encode()
		local v1087, v1088 = proto.writeTag(buf, n67, 3, proto.wireTypes.lengthDelimited)

		buf, n67 = proto.writeBuffer(v1087, v1088, v1086, buffer.len(v1086))
	end

	local buf36 = buffer.create(n67)

	buffer.copy(buf36, 0, buf, 0, n67)

	return buf36
end
function t136.decode(p104: buffer) -- line: 9808
	-- upvalues: t136 (copy), proto (copy), prop_types (copy)
	local v1091 = t136.new()
	local n68 = 0

	while n68 < buffer.len(p104) do
		local v1093, v1094

		v1093, v1094, n68 = proto.readTag(p104, n68)

		if v1094 == proto.wireTypes.varint then
			local v1095

			v1095, n68 = proto.readVarInt(p104, n68)
		elseif v1094 == proto.wireTypes.lengthDelimited then
			if v1093 == 1 then
				local v1096

				v1096, n68 = proto.readBuffer(p104, n68)
				v1091.profile_id = prop_types.StringProp.decode(v1096)
			elseif v1093 == 2 then
				local v1097

				v1097, n68 = proto.readBuffer(p104, n68)
				v1091.profile_type = prop_types.StringProp.decode(v1097)
			elseif v1093 == 3 then
				local v1098

				v1098, n68 = proto.readBuffer(p104, n68)
				v1091.source = prop_types.StringProp.decode(v1098)
			else
				local v1099, v1100 = proto.readVarInt(p104, n68)

				n68 = v1100 + v1099
			end
		elseif v1094 == proto.wireTypes.i32 then
			local v1101

			v1101, n68 = proto.readFixed32(p104, n68)
		elseif v1094 == proto.wireTypes.i64 then
			local v1102

			v1102, n68 = proto.readFixed64(p104, n68)
		else
			error("Unsupported wire type: " .. v1094)
		end
	end

	return v1091
end
function t136.jsonEncode(p105) -- line: 9861
	local t138 = {}

	if p105.profile_id ~= nil then
		t138.profileId = p105.profile_id:jsonEncode()
	end

	if p105.profile_type ~= nil then
		t138.profileType = p105.profile_type:jsonEncode()
	end

	if p105.source ~= nil then
		t138.source = p105.source:jsonEncode()
	end

	return t138
end
function t136.jsonDecode(t139: {[any]: any}) -- line: 9879
	-- upvalues: t136 (copy), prop_types (copy)
	local v1106 = t136.new()

	if t139.profile_id ~= nil then
		v1106.profile_id = prop_types.StringProp.jsonDecode(t139.profile_id)
	end

	if t139.profileId ~= nil then
		v1106.profile_id = prop_types.StringProp.jsonDecode(t139.profileId)
	end

	if t139.profile_type ~= nil then
		v1106.profile_type = prop_types.StringProp.jsonDecode(t139.profile_type)
	end

	if t139.profileType ~= nil then
		v1106.profile_type = prop_types.StringProp.jsonDecode(t139.profileType)
	end

	if t139.source ~= nil then
		v1106.source = prop_types.StringProp.jsonDecode(t139.source)
	end

	return v1106
end

t136.descriptor = {
	name = "OpenProfileAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.OpenProfileAction_Params = t136
typeRegistry.default:register(t1.OpenProfileAction_Params)

local t140 = {}

t140.__index = t140

function t140.new(t141: {[any]: any}?) -- line: 9921
	-- upvalues: t1 (copy), t140 (copy)
	return (setmetatable({
		action_type = if t141 ~= nil and t141.action_type ~= nil then t141.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t141 ~= nil and t141.action_params ~= nil then t141.action_params else nil
	}, t140))
end
function t140.encode(p106) -- line: 9932
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n69 = 0

	if p106.action_type ~= nil and (p106.action_type ~= nil and p106.action_type ~= 0 or p106.action_type ~= t1.ActionType.fromNumber(0)) then
		local v1111, v1112 = proto.writeTag(buf, n69, 1, proto.wireTypes.varint)

		buf, n69 = proto.writeVarInt(v1111, v1112, t1.ActionType.toNumber(p106.action_type))
	end

	if p106.action_params ~= nil then
		local v1113 = p106.action_params:encode()
		local v1114, v1115 = proto.writeTag(buf, n69, 2, proto.wireTypes.lengthDelimited)

		buf, n69 = proto.writeBuffer(v1114, v1115, v1113, buffer.len(v1113))
	end

	local buf37 = buffer.create(n69)

	buffer.copy(buf37, 0, buf, 0, n69)

	return buf37
end
function t140.decode(p107: buffer) -- line: 9958
	-- upvalues: t140 (copy), proto (copy), t1 (copy)
	local v1118 = t140.new()
	local n70 = 0

	while n70 < buffer.len(p107) do
		local v1120, v1121

		v1120, v1121, n70 = proto.readTag(p107, n70)

		if v1121 == proto.wireTypes.varint then
			if v1120 == 1 then
				local v1122

				v1122, n70 = proto.readVarIntI32(p107, n70)
				v1118.action_type = t1.ActionType.fromNumber(v1122) or v1122
			else
				local v1123

				v1123, n70 = proto.readVarInt(p107, n70)
			end
		elseif v1121 == proto.wireTypes.lengthDelimited then
			if v1120 == 2 then
				local v1124

				v1124, n70 = proto.readBuffer(p107, n70)
				v1118.action_params = t1.OpenFacialAgeEstimationAction_Params.decode(v1124)
			else
				local v1125, v1126 = proto.readVarInt(p107, n70)

				n70 = v1126 + v1125
			end
		elseif v1121 == proto.wireTypes.i32 then
			local v1127

			v1127, n70 = proto.readFixed32(p107, n70)
		elseif v1121 == proto.wireTypes.i64 then
			local v1128

			v1128, n70 = proto.readFixed64(p107, n70)
		else
			error("Unsupported wire type: " .. v1121)
		end
	end

	return v1118
end
function t140.jsonEncode(p108) -- line: 10006
	-- upvalues: t1 (copy)
	local t142 = {}

	if p108.action_type ~= nil and (p108.action_type ~= nil and p108.action_type ~= 0 or p108.action_type ~= t1.ActionType.fromNumber(0)) then
		t142.actionType = if typeof(p108.action_type) ~= "number" then t1.ActionType.toNumber(p108.action_type) else p108.action_type
	end

	if p108.action_params ~= nil then
		t142.actionParams = p108.action_params:jsonEncode()
	end

	return t142
end
function t140.jsonDecode(t143: {[any]: any}) -- line: 10028
	-- upvalues: t140 (copy), t1 (copy)
	local v1132 = t140.new()

	if t143.action_type ~= nil then
		v1132.action_type = if typeof(t143.action_type) ~= "number" then t1.ActionType.fromName(t143.action_type) or t143.action_type else t1.ActionType.fromNumber(t143.action_type) or t143.action_type
	end

	if t143.actionType ~= nil then
		v1132.action_type = if typeof(t143.actionType) ~= "number" then t1.ActionType.fromName(t143.actionType) or t143.actionType else t1.ActionType.fromNumber(t143.actionType) or t143.actionType
	end

	if t143.action_params ~= nil then
		v1132.action_params = t1.OpenFacialAgeEstimationAction_Params.jsonDecode(t143.action_params)
	end

	if t143.actionParams ~= nil then
		v1132.action_params = t1.OpenFacialAgeEstimationAction_Params.jsonDecode(t143.actionParams)
	end

	return v1132
end

t140.descriptor = {
	name = "OpenFacialAgeEstimationAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.OpenFacialAgeEstimationAction"
}
t1.OpenFacialAgeEstimationAction = t140
typeRegistry.default:register(t1.OpenFacialAgeEstimationAction)

local t144 = {}

t144.__index = t144

function t144.new(t145: {[any]: any}?) -- line: 10068
	-- upvalues: t144 (copy)
	return (setmetatable({
		user_id = if t145 ~= nil and t145.user_id ~= nil then t145.user_id else nil,
		source = if t145 ~= nil and t145.source ~= nil then t145.source else nil,
		context = if t145 ~= nil and t145.context ~= nil then t145.context else nil,
		is_in_experience = if t145 ~= nil and t145.is_in_experience ~= nil then t145.is_in_experience else nil,
		on_success = if t145 ~= nil and t145.on_success ~= nil then t145.on_success else nil,
		on_failure = if t145 ~= nil and t145.on_failure ~= nil then t145.on_failure else nil
	}, t144))
end
function t144.encode(p109) -- line: 10081
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n71 = 0

	if p109.user_id ~= nil then
		local v1137 = p109.user_id:encode()
		local v1138, v1139 = proto.writeTag(buf, n71, 1, proto.wireTypes.lengthDelimited)

		buf, n71 = proto.writeBuffer(v1138, v1139, v1137, buffer.len(v1137))
	end

	if p109.source ~= nil then
		local v1140 = p109.source:encode()
		local v1141, v1142 = proto.writeTag(buf, n71, 2, proto.wireTypes.lengthDelimited)

		buf, n71 = proto.writeBuffer(v1141, v1142, v1140, buffer.len(v1140))
	end

	if p109.context ~= nil then
		local v1143 = p109.context:encode()
		local v1144, v1145 = proto.writeTag(buf, n71, 3, proto.wireTypes.lengthDelimited)

		buf, n71 = proto.writeBuffer(v1144, v1145, v1143, buffer.len(v1143))
	end

	if p109.is_in_experience ~= nil then
		local v1146 = p109.is_in_experience:encode()
		local v1147, v1148 = proto.writeTag(buf, n71, 4, proto.wireTypes.lengthDelimited)

		buf, n71 = proto.writeBuffer(v1147, v1148, v1146, buffer.len(v1146))
	end

	if p109.on_success ~= nil then
		local v1149 = p109.on_success:encode()
		local v1150, v1151 = proto.writeTag(buf, n71, 5, proto.wireTypes.lengthDelimited)

		buf, n71 = proto.writeBuffer(v1150, v1151, v1149, buffer.len(v1149))
	end

	if p109.on_failure ~= nil then
		local v1152 = p109.on_failure:encode()
		local v1153, v1154 = proto.writeTag(buf, n71, 6, proto.wireTypes.lengthDelimited)

		buf, n71 = proto.writeBuffer(v1153, v1154, v1152, buffer.len(v1152))
	end

	local buf38 = buffer.create(n71)

	buffer.copy(buf38, 0, buf, 0, n71)

	return buf38
end
function t144.decode(p110: buffer) -- line: 10126
	-- upvalues: t144 (copy), proto (copy), prop_types (copy), t1 (copy)
	local v1157 = t144.new()
	local n72 = 0

	while n72 < buffer.len(p110) do
		local v1159, v1160

		v1159, v1160, n72 = proto.readTag(p110, n72)

		if v1160 == proto.wireTypes.varint then
			local v1161

			v1161, n72 = proto.readVarInt(p110, n72)
		elseif v1160 == proto.wireTypes.lengthDelimited then
			if v1159 == 1 then
				local v1162

				v1162, n72 = proto.readBuffer(p110, n72)
				v1157.user_id = prop_types.StringProp.decode(v1162)
			elseif v1159 == 2 then
				local v1163

				v1163, n72 = proto.readBuffer(p110, n72)
				v1157.source = prop_types.StringProp.decode(v1163)
			elseif v1159 == 3 then
				local v1164

				v1164, n72 = proto.readBuffer(p110, n72)
				v1157.context = prop_types.StringProp.decode(v1164)
			elseif v1159 == 4 then
				local v1165

				v1165, n72 = proto.readBuffer(p110, n72)
				v1157.is_in_experience = prop_types.BoolProp.decode(v1165)
			elseif v1159 == 5 then
				local v1166

				v1166, n72 = proto.readBuffer(p110, n72)
				v1157.on_success = t1.ActionProp.decode(v1166)
			elseif v1159 == 6 then
				local v1167

				v1167, n72 = proto.readBuffer(p110, n72)
				v1157.on_failure = t1.ActionProp.decode(v1167)
			else
				local v1168, v1169 = proto.readVarInt(p110, n72)

				n72 = v1169 + v1168
			end
		elseif v1160 == proto.wireTypes.i32 then
			local v1170

			v1170, n72 = proto.readFixed32(p110, n72)
		elseif v1160 == proto.wireTypes.i64 then
			local v1171

			v1171, n72 = proto.readFixed64(p110, n72)
		else
			error("Unsupported wire type: " .. v1160)
		end
	end

	return v1157
end
function t144.jsonEncode(p111) -- line: 10194
	local t146 = {}

	if p111.user_id ~= nil then
		t146.userId = p111.user_id:jsonEncode()
	end

	if p111.source ~= nil then
		t146.source = p111.source:jsonEncode()
	end

	if p111.context ~= nil then
		t146.context = p111.context:jsonEncode()
	end

	if p111.is_in_experience ~= nil then
		t146.isInExperience = p111.is_in_experience:jsonEncode()
	end

	if p111.on_success ~= nil then
		t146.onSuccess = p111.on_success:jsonEncode()
	end

	if p111.on_failure ~= nil then
		t146.onFailure = p111.on_failure:jsonEncode()
	end

	return t146
end
function t144.jsonDecode(t147: {[any]: any}) -- line: 10224
	-- upvalues: t144 (copy), prop_types (copy), t1 (copy)
	local v1175 = t144.new()

	if t147.user_id ~= nil then
		v1175.user_id = prop_types.StringProp.jsonDecode(t147.user_id)
	end

	if t147.userId ~= nil then
		v1175.user_id = prop_types.StringProp.jsonDecode(t147.userId)
	end

	if t147.source ~= nil then
		v1175.source = prop_types.StringProp.jsonDecode(t147.source)
	end

	if t147.context ~= nil then
		v1175.context = prop_types.StringProp.jsonDecode(t147.context)
	end

	if t147.is_in_experience ~= nil then
		v1175.is_in_experience = prop_types.BoolProp.jsonDecode(t147.is_in_experience)
	end

	if t147.isInExperience ~= nil then
		v1175.is_in_experience = prop_types.BoolProp.jsonDecode(t147.isInExperience)
	end

	if t147.on_success ~= nil then
		v1175.on_success = t1.ActionProp.jsonDecode(t147.on_success)
	end

	if t147.onSuccess ~= nil then
		v1175.on_success = t1.ActionProp.jsonDecode(t147.onSuccess)
	end

	if t147.on_failure ~= nil then
		v1175.on_failure = t1.ActionProp.jsonDecode(t147.on_failure)
	end

	if t147.onFailure ~= nil then
		v1175.on_failure = t1.ActionProp.jsonDecode(t147.onFailure)
	end

	return v1175
end

t144.descriptor = {
	name = "OpenFacialAgeEstimationAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.OpenFacialAgeEstimationAction_Params = t144
typeRegistry.default:register(t1.OpenFacialAgeEstimationAction_Params)

local t148 = {}

t148.__index = t148

function t148.new(t149: {[any]: any}?) -- line: 10288
	-- upvalues: t1 (copy), t148 (copy)
	return (setmetatable({
		action_type = if t149 ~= nil and t149.action_type ~= nil then t149.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t149 ~= nil and t149.action_params ~= nil then t149.action_params else nil
	}, t148))
end
function t148.encode(p112) -- line: 10299
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n73 = 0

	if p112.action_type ~= nil and (p112.action_type ~= nil and p112.action_type ~= 0 or p112.action_type ~= t1.ActionType.fromNumber(0)) then
		local v1180, v1181 = proto.writeTag(buf, n73, 1, proto.wireTypes.varint)

		buf, n73 = proto.writeVarInt(v1180, v1181, t1.ActionType.toNumber(p112.action_type))
	end

	if p112.action_params ~= nil then
		local v1182 = p112.action_params:encode()
		local v1183, v1184 = proto.writeTag(buf, n73, 2, proto.wireTypes.lengthDelimited)

		buf, n73 = proto.writeBuffer(v1183, v1184, v1182, buffer.len(v1182))
	end

	local buf39 = buffer.create(n73)

	buffer.copy(buf39, 0, buf, 0, n73)

	return buf39
end
function t148.decode(p113: buffer) -- line: 10325
	-- upvalues: t148 (copy), proto (copy), t1 (copy)
	local v1187 = t148.new()
	local n74 = 0

	while n74 < buffer.len(p113) do
		local v1189, v1190

		v1189, v1190, n74 = proto.readTag(p113, n74)

		if v1190 == proto.wireTypes.varint then
			if v1189 == 1 then
				local v1191

				v1191, n74 = proto.readVarIntI32(p113, n74)
				v1187.action_type = t1.ActionType.fromNumber(v1191) or v1191
			else
				local v1192

				v1192, n74 = proto.readVarInt(p113, n74)
			end
		elseif v1190 == proto.wireTypes.lengthDelimited then
			if v1189 == 2 then
				local v1193

				v1193, n74 = proto.readBuffer(p113, n74)
				v1187.action_params = t1.OpenPhoneUpsellModalAction_Params.decode(v1193)
			else
				local v1194, v1195 = proto.readVarInt(p113, n74)

				n74 = v1195 + v1194
			end
		elseif v1190 == proto.wireTypes.i32 then
			local v1196

			v1196, n74 = proto.readFixed32(p113, n74)
		elseif v1190 == proto.wireTypes.i64 then
			local v1197

			v1197, n74 = proto.readFixed64(p113, n74)
		else
			error("Unsupported wire type: " .. v1190)
		end
	end

	return v1187
end
function t148.jsonEncode(p114) -- line: 10373
	-- upvalues: t1 (copy)
	local t150 = {}

	if p114.action_type ~= nil and (p114.action_type ~= nil and p114.action_type ~= 0 or p114.action_type ~= t1.ActionType.fromNumber(0)) then
		t150.actionType = if typeof(p114.action_type) ~= "number" then t1.ActionType.toNumber(p114.action_type) else p114.action_type
	end

	if p114.action_params ~= nil then
		t150.actionParams = p114.action_params:jsonEncode()
	end

	return t150
end
function t148.jsonDecode(t151: {[any]: any}) -- line: 10395
	-- upvalues: t148 (copy), t1 (copy)
	local v1201 = t148.new()

	if t151.action_type ~= nil then
		v1201.action_type = if typeof(t151.action_type) ~= "number" then t1.ActionType.fromName(t151.action_type) or t151.action_type else t1.ActionType.fromNumber(t151.action_type) or t151.action_type
	end

	if t151.actionType ~= nil then
		v1201.action_type = if typeof(t151.actionType) ~= "number" then t1.ActionType.fromName(t151.actionType) or t151.actionType else t1.ActionType.fromNumber(t151.actionType) or t151.actionType
	end

	if t151.action_params ~= nil then
		v1201.action_params = t1.OpenPhoneUpsellModalAction_Params.jsonDecode(t151.action_params)
	end

	if t151.actionParams ~= nil then
		v1201.action_params = t1.OpenPhoneUpsellModalAction_Params.jsonDecode(t151.actionParams)
	end

	return v1201
end

t148.descriptor = {
	name = "OpenPhoneUpsellModalAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.OpenPhoneUpsellModalAction"
}
t1.OpenPhoneUpsellModalAction = t148
typeRegistry.default:register(t1.OpenPhoneUpsellModalAction)

local t152 = {}

t152.__index = t152

function t152.new(t153: {[any]: any}?) -- line: 10435
	-- upvalues: t152 (copy)
	return (setmetatable({
		voice_opt_in = if t153 ~= nil and t153.voice_opt_in ~= nil then t153.voice_opt_in else nil,
		event_context = if t153 ~= nil and t153.event_context ~= nil then t153.event_context else nil,
		origin = if t153 ~= nil and t153.origin ~= nil then t153.origin else nil,
		should_autofill_android_phone_number_at_launch = if t153 ~= nil and t153.should_autofill_android_phone_number_at_launch ~= nil then t153.should_autofill_android_phone_number_at_launch else nil,
		add_phone_description_key = if t153 ~= nil and t153.add_phone_description_key ~= nil then t153.add_phone_description_key else nil,
		on_success = if t153 ~= nil and t153.on_success ~= nil then t153.on_success else nil,
		on_failure = if t153 ~= nil and t153.on_failure ~= nil then t153.on_failure else nil,
		on_cancelled = if t153 ~= nil and t153.on_cancelled ~= nil then t153.on_cancelled else nil
	}, t152))
end
function t152.encode(p115) -- line: 10455
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n75 = 0

	if p115.voice_opt_in ~= nil then
		local v1206 = p115.voice_opt_in:encode()
		local v1207, v1208 = proto.writeTag(buf, n75, 1, proto.wireTypes.lengthDelimited)

		buf, n75 = proto.writeBuffer(v1207, v1208, v1206, buffer.len(v1206))
	end

	if p115.event_context ~= nil then
		local v1209 = p115.event_context:encode()
		local v1210, v1211 = proto.writeTag(buf, n75, 2, proto.wireTypes.lengthDelimited)

		buf, n75 = proto.writeBuffer(v1210, v1211, v1209, buffer.len(v1209))
	end

	if p115.origin ~= nil then
		local v1212 = p115.origin:encode()
		local v1213, v1214 = proto.writeTag(buf, n75, 3, proto.wireTypes.lengthDelimited)

		buf, n75 = proto.writeBuffer(v1213, v1214, v1212, buffer.len(v1212))
	end

	if p115.should_autofill_android_phone_number_at_launch ~= nil then
		local v1215 = p115.should_autofill_android_phone_number_at_launch:encode()
		local v1216, v1217 = proto.writeTag(buf, n75, 4, proto.wireTypes.lengthDelimited)

		buf, n75 = proto.writeBuffer(v1216, v1217, v1215, buffer.len(v1215))
	end

	if p115.add_phone_description_key ~= nil then
		local v1218 = p115.add_phone_description_key:encode()
		local v1219, v1220 = proto.writeTag(buf, n75, 5, proto.wireTypes.lengthDelimited)

		buf, n75 = proto.writeBuffer(v1219, v1220, v1218, buffer.len(v1218))
	end

	if p115.on_success ~= nil then
		local v1221 = p115.on_success:encode()
		local v1222, v1223 = proto.writeTag(buf, n75, 6, proto.wireTypes.lengthDelimited)

		buf, n75 = proto.writeBuffer(v1222, v1223, v1221, buffer.len(v1221))
	end

	if p115.on_failure ~= nil then
		local v1224 = p115.on_failure:encode()
		local v1225, v1226 = proto.writeTag(buf, n75, 7, proto.wireTypes.lengthDelimited)

		buf, n75 = proto.writeBuffer(v1225, v1226, v1224, buffer.len(v1224))
	end

	if p115.on_cancelled ~= nil then
		local v1227 = p115.on_cancelled:encode()
		local v1228, v1229 = proto.writeTag(buf, n75, 8, proto.wireTypes.lengthDelimited)

		buf, n75 = proto.writeBuffer(v1228, v1229, v1227, buffer.len(v1227))
	end

	local buf40 = buffer.create(n75)

	buffer.copy(buf40, 0, buf, 0, n75)

	return buf40
end
function t152.decode(p116: buffer) -- line: 10512
	-- upvalues: t152 (copy), proto (copy), prop_types (copy), t1 (copy)
	local v1232 = t152.new()
	local n76 = 0

	while n76 < buffer.len(p116) do
		local v1234, v1235

		v1234, v1235, n76 = proto.readTag(p116, n76)

		if v1235 == proto.wireTypes.varint then
			local v1236

			v1236, n76 = proto.readVarInt(p116, n76)
		elseif v1235 == proto.wireTypes.lengthDelimited then
			if v1234 == 1 then
				local v1237

				v1237, n76 = proto.readBuffer(p116, n76)
				v1232.voice_opt_in = prop_types.BoolProp.decode(v1237)
			elseif v1234 == 2 then
				local v1238

				v1238, n76 = proto.readBuffer(p116, n76)
				v1232.event_context = prop_types.StringProp.decode(v1238)
			elseif v1234 == 3 then
				local v1239

				v1239, n76 = proto.readBuffer(p116, n76)
				v1232.origin = prop_types.StringProp.decode(v1239)
			elseif v1234 == 4 then
				local v1240

				v1240, n76 = proto.readBuffer(p116, n76)
				v1232.should_autofill_android_phone_number_at_launch = prop_types.BoolProp.decode(v1240)
			elseif v1234 == 5 then
				local v1241

				v1241, n76 = proto.readBuffer(p116, n76)
				v1232.add_phone_description_key = prop_types.StringProp.decode(v1241)
			elseif v1234 == 6 then
				local v1242

				v1242, n76 = proto.readBuffer(p116, n76)
				v1232.on_success = t1.ActionProp.decode(v1242)
			elseif v1234 == 7 then
				local v1243

				v1243, n76 = proto.readBuffer(p116, n76)
				v1232.on_failure = t1.ActionProp.decode(v1243)
			elseif v1234 == 8 then
				local v1244

				v1244, n76 = proto.readBuffer(p116, n76)
				v1232.on_cancelled = t1.ActionProp.decode(v1244)
			else
				local v1245, v1246 = proto.readVarInt(p116, n76)

				n76 = v1246 + v1245
			end
		elseif v1235 == proto.wireTypes.i32 then
			local v1247

			v1247, n76 = proto.readFixed32(p116, n76)
		elseif v1235 == proto.wireTypes.i64 then
			local v1248

			v1248, n76 = proto.readFixed64(p116, n76)
		else
			error("Unsupported wire type: " .. v1235)
		end
	end

	return v1232
end
function t152.jsonEncode(p117) -- line: 10592
	local t154 = {}

	if p117.voice_opt_in ~= nil then
		t154.voiceOptIn = p117.voice_opt_in:jsonEncode()
	end

	if p117.event_context ~= nil then
		t154.eventContext = p117.event_context:jsonEncode()
	end

	if p117.origin ~= nil then
		t154.origin = p117.origin:jsonEncode()
	end

	if p117.should_autofill_android_phone_number_at_launch ~= nil then
		t154.shouldAutofillAndroidPhoneNumberAtLaunch = p117.should_autofill_android_phone_number_at_launch:jsonEncode()
	end

	if p117.add_phone_description_key ~= nil then
		t154.addPhoneDescriptionKey = p117.add_phone_description_key:jsonEncode()
	end

	if p117.on_success ~= nil then
		t154.onSuccess = p117.on_success:jsonEncode()
	end

	if p117.on_failure ~= nil then
		t154.onFailure = p117.on_failure:jsonEncode()
	end

	if p117.on_cancelled ~= nil then
		t154.onCancelled = p117.on_cancelled:jsonEncode()
	end

	return t154
end
function t152.jsonDecode(t155: {[any]: any}) -- line: 10631
	-- upvalues: t152 (copy), prop_types (copy), t1 (copy)
	local v1252 = t152.new()

	if t155.voice_opt_in ~= nil then
		v1252.voice_opt_in = prop_types.BoolProp.jsonDecode(t155.voice_opt_in)
	end

	if t155.voiceOptIn ~= nil then
		v1252.voice_opt_in = prop_types.BoolProp.jsonDecode(t155.voiceOptIn)
	end

	if t155.event_context ~= nil then
		v1252.event_context = prop_types.StringProp.jsonDecode(t155.event_context)
	end

	if t155.eventContext ~= nil then
		v1252.event_context = prop_types.StringProp.jsonDecode(t155.eventContext)
	end

	if t155.origin ~= nil then
		v1252.origin = prop_types.StringProp.jsonDecode(t155.origin)
	end

	if t155.should_autofill_android_phone_number_at_launch ~= nil then
		v1252.should_autofill_android_phone_number_at_launch = prop_types.BoolProp.jsonDecode(t155.should_autofill_android_phone_number_at_launch)
	end

	if t155.shouldAutofillAndroidPhoneNumberAtLaunch ~= nil then
		v1252.should_autofill_android_phone_number_at_launch = prop_types.BoolProp.jsonDecode(t155.shouldAutofillAndroidPhoneNumberAtLaunch)
	end

	if t155.add_phone_description_key ~= nil then
		v1252.add_phone_description_key = prop_types.StringProp.jsonDecode(t155.add_phone_description_key)
	end

	if t155.addPhoneDescriptionKey ~= nil then
		v1252.add_phone_description_key = prop_types.StringProp.jsonDecode(t155.addPhoneDescriptionKey)
	end

	if t155.on_success ~= nil then
		v1252.on_success = t1.ActionProp.jsonDecode(t155.on_success)
	end

	if t155.onSuccess ~= nil then
		v1252.on_success = t1.ActionProp.jsonDecode(t155.onSuccess)
	end

	if t155.on_failure ~= nil then
		v1252.on_failure = t1.ActionProp.jsonDecode(t155.on_failure)
	end

	if t155.onFailure ~= nil then
		v1252.on_failure = t1.ActionProp.jsonDecode(t155.onFailure)
	end

	if t155.on_cancelled ~= nil then
		v1252.on_cancelled = t1.ActionProp.jsonDecode(t155.on_cancelled)
	end

	if t155.onCancelled ~= nil then
		v1252.on_cancelled = t1.ActionProp.jsonDecode(t155.onCancelled)
	end

	return v1252
end

t152.descriptor = {
	name = "OpenPhoneUpsellModalAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.OpenPhoneUpsellModalAction_Params = t152
typeRegistry.default:register(t1.OpenPhoneUpsellModalAction_Params)

local t156 = {}

t156.__index = t156

function t156.new(t157: {[any]: any}?) -- line: 10724
	-- upvalues: t1 (copy), t156 (copy)
	return (setmetatable({
		action_type = if t157 ~= nil and t157.action_type ~= nil then t157.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t157 ~= nil and t157.action_params ~= nil then t157.action_params else nil
	}, t156))
end
function t156.encode(p118) -- line: 10735
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n77 = 0

	if p118.action_type ~= nil and (p118.action_type ~= nil and p118.action_type ~= 0 or p118.action_type ~= t1.ActionType.fromNumber(0)) then
		local v1257, v1258 = proto.writeTag(buf, n77, 1, proto.wireTypes.varint)

		buf, n77 = proto.writeVarInt(v1257, v1258, t1.ActionType.toNumber(p118.action_type))
	end

	if p118.action_params ~= nil then
		local v1259 = p118.action_params:encode()
		local v1260, v1261 = proto.writeTag(buf, n77, 2, proto.wireTypes.lengthDelimited)

		buf, n77 = proto.writeBuffer(v1260, v1261, v1259, buffer.len(v1259))
	end

	local buf41 = buffer.create(n77)

	buffer.copy(buf41, 0, buf, 0, n77)

	return buf41
end
function t156.decode(p119: buffer) -- line: 10761
	-- upvalues: t156 (copy), proto (copy), t1 (copy)
	local v1264 = t156.new()
	local n78 = 0

	while n78 < buffer.len(p119) do
		local v1266, v1267

		v1266, v1267, n78 = proto.readTag(p119, n78)

		if v1267 == proto.wireTypes.varint then
			if v1266 == 1 then
				local v1268

				v1268, n78 = proto.readVarIntI32(p119, n78)
				v1264.action_type = t1.ActionType.fromNumber(v1268) or v1268
			else
				local v1269

				v1269, n78 = proto.readVarInt(p119, n78)
			end
		elseif v1267 == proto.wireTypes.lengthDelimited then
			if v1266 == 2 then
				local v1270

				v1270, n78 = proto.readBuffer(p119, n78)
				v1264.action_params = t1.OpenEmailUpsellModalAction_Params.decode(v1270)
			else
				local v1271, v1272 = proto.readVarInt(p119, n78)

				n78 = v1272 + v1271
			end
		elseif v1267 == proto.wireTypes.i32 then
			local v1273

			v1273, n78 = proto.readFixed32(p119, n78)
		elseif v1267 == proto.wireTypes.i64 then
			local v1274

			v1274, n78 = proto.readFixed64(p119, n78)
		else
			error("Unsupported wire type: " .. v1267)
		end
	end

	return v1264
end
function t156.jsonEncode(p120) -- line: 10809
	-- upvalues: t1 (copy)
	local t158 = {}

	if p120.action_type ~= nil and (p120.action_type ~= nil and p120.action_type ~= 0 or p120.action_type ~= t1.ActionType.fromNumber(0)) then
		t158.actionType = if typeof(p120.action_type) ~= "number" then t1.ActionType.toNumber(p120.action_type) else p120.action_type
	end

	if p120.action_params ~= nil then
		t158.actionParams = p120.action_params:jsonEncode()
	end

	return t158
end
function t156.jsonDecode(t159: {[any]: any}) -- line: 10831
	-- upvalues: t156 (copy), t1 (copy)
	local v1278 = t156.new()

	if t159.action_type ~= nil then
		v1278.action_type = if typeof(t159.action_type) ~= "number" then t1.ActionType.fromName(t159.action_type) or t159.action_type else t1.ActionType.fromNumber(t159.action_type) or t159.action_type
	end

	if t159.actionType ~= nil then
		v1278.action_type = if typeof(t159.actionType) ~= "number" then t1.ActionType.fromName(t159.actionType) or t159.actionType else t1.ActionType.fromNumber(t159.actionType) or t159.actionType
	end

	if t159.action_params ~= nil then
		v1278.action_params = t1.OpenEmailUpsellModalAction_Params.jsonDecode(t159.action_params)
	end

	if t159.actionParams ~= nil then
		v1278.action_params = t1.OpenEmailUpsellModalAction_Params.jsonDecode(t159.actionParams)
	end

	return v1278
end

t156.descriptor = {
	name = "OpenEmailUpsellModalAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.OpenEmailUpsellModalAction"
}
t1.OpenEmailUpsellModalAction = t156
typeRegistry.default:register(t1.OpenEmailUpsellModalAction)

local t160 = {}

t160.__index = t160

function t160.new(t161: {[any]: any}?) -- line: 10871
	-- upvalues: t160 (copy)
	return (setmetatable({
		add_email_over13_text_key = if t161 ~= nil and t161.add_email_over13_text_key ~= nil then t161.add_email_over13_text_key else nil,
		add_email_title_key = if t161 ~= nil and t161.add_email_title_key ~= nil then t161.add_email_title_key else nil,
		is_email_modal_called_from_home_page = if t161 ~= nil and t161.is_email_modal_called_from_home_page ~= nil then t161.is_email_modal_called_from_home_page else nil,
		event_context = if t161 ~= nil and t161.event_context ~= nil then t161.event_context else nil,
		origin = if t161 ~= nil and t161.origin ~= nil then t161.origin else nil,
		section = if t161 ~= nil and t161.section ~= nil then t161.section else nil,
		on_success = if t161 ~= nil and t161.on_success ~= nil then t161.on_success else nil,
		on_failure = if t161 ~= nil and t161.on_failure ~= nil then t161.on_failure else nil
	}, t160))
end
function t160.encode(p121) -- line: 10893
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n79 = 0

	if p121.add_email_over13_text_key ~= nil then
		local v1283 = p121.add_email_over13_text_key:encode()
		local v1284, v1285 = proto.writeTag(buf, n79, 1, proto.wireTypes.lengthDelimited)

		buf, n79 = proto.writeBuffer(v1284, v1285, v1283, buffer.len(v1283))
	end

	if p121.add_email_title_key ~= nil then
		local v1286 = p121.add_email_title_key:encode()
		local v1287, v1288 = proto.writeTag(buf, n79, 2, proto.wireTypes.lengthDelimited)

		buf, n79 = proto.writeBuffer(v1287, v1288, v1286, buffer.len(v1286))
	end

	if p121.is_email_modal_called_from_home_page ~= nil then
		local v1289 = p121.is_email_modal_called_from_home_page:encode()
		local v1290, v1291 = proto.writeTag(buf, n79, 3, proto.wireTypes.lengthDelimited)

		buf, n79 = proto.writeBuffer(v1290, v1291, v1289, buffer.len(v1289))
	end

	if p121.event_context ~= nil then
		local v1292 = p121.event_context:encode()
		local v1293, v1294 = proto.writeTag(buf, n79, 4, proto.wireTypes.lengthDelimited)

		buf, n79 = proto.writeBuffer(v1293, v1294, v1292, buffer.len(v1292))
	end

	if p121.origin ~= nil then
		local v1295 = p121.origin:encode()
		local v1296, v1297 = proto.writeTag(buf, n79, 5, proto.wireTypes.lengthDelimited)

		buf, n79 = proto.writeBuffer(v1296, v1297, v1295, buffer.len(v1295))
	end

	if p121.section ~= nil then
		local v1298 = p121.section:encode()
		local v1299, v1300 = proto.writeTag(buf, n79, 6, proto.wireTypes.lengthDelimited)

		buf, n79 = proto.writeBuffer(v1299, v1300, v1298, buffer.len(v1298))
	end

	if p121.on_success ~= nil then
		local v1301 = p121.on_success:encode()
		local v1302, v1303 = proto.writeTag(buf, n79, 7, proto.wireTypes.lengthDelimited)

		buf, n79 = proto.writeBuffer(v1302, v1303, v1301, buffer.len(v1301))
	end

	if p121.on_failure ~= nil then
		local v1304 = p121.on_failure:encode()
		local v1305, v1306 = proto.writeTag(buf, n79, 8, proto.wireTypes.lengthDelimited)

		buf, n79 = proto.writeBuffer(v1305, v1306, v1304, buffer.len(v1304))
	end

	local buf42 = buffer.create(n79)

	buffer.copy(buf42, 0, buf, 0, n79)

	return buf42
end
function t160.decode(p122: buffer) -- line: 10950
	-- upvalues: t160 (copy), proto (copy), prop_types (copy), t1 (copy)
	local v1309 = t160.new()
	local n80 = 0

	while n80 < buffer.len(p122) do
		local v1311, v1312

		v1311, v1312, n80 = proto.readTag(p122, n80)

		if v1312 == proto.wireTypes.varint then
			local v1313

			v1313, n80 = proto.readVarInt(p122, n80)
		elseif v1312 == proto.wireTypes.lengthDelimited then
			if v1311 == 1 then
				local v1314

				v1314, n80 = proto.readBuffer(p122, n80)
				v1309.add_email_over13_text_key = prop_types.StringProp.decode(v1314)
			elseif v1311 == 2 then
				local v1315

				v1315, n80 = proto.readBuffer(p122, n80)
				v1309.add_email_title_key = prop_types.StringProp.decode(v1315)
			elseif v1311 == 3 then
				local v1316

				v1316, n80 = proto.readBuffer(p122, n80)
				v1309.is_email_modal_called_from_home_page = prop_types.BoolProp.decode(v1316)
			elseif v1311 == 4 then
				local v1317

				v1317, n80 = proto.readBuffer(p122, n80)
				v1309.event_context = prop_types.StringProp.decode(v1317)
			elseif v1311 == 5 then
				local v1318

				v1318, n80 = proto.readBuffer(p122, n80)
				v1309.origin = prop_types.StringProp.decode(v1318)
			elseif v1311 == 6 then
				local v1319

				v1319, n80 = proto.readBuffer(p122, n80)
				v1309.section = prop_types.StringProp.decode(v1319)
			elseif v1311 == 7 then
				local v1320

				v1320, n80 = proto.readBuffer(p122, n80)
				v1309.on_success = t1.ActionProp.decode(v1320)
			elseif v1311 == 8 then
				local v1321

				v1321, n80 = proto.readBuffer(p122, n80)
				v1309.on_failure = t1.ActionProp.decode(v1321)
			else
				local v1322, v1323 = proto.readVarInt(p122, n80)

				n80 = v1323 + v1322
			end
		elseif v1312 == proto.wireTypes.i32 then
			local v1324

			v1324, n80 = proto.readFixed32(p122, n80)
		elseif v1312 == proto.wireTypes.i64 then
			local v1325

			v1325, n80 = proto.readFixed64(p122, n80)
		else
			error("Unsupported wire type: " .. v1312)
		end
	end

	return v1309
end
function t160.jsonEncode(p123) -- line: 11031
	local t162 = {}

	if p123.add_email_over13_text_key ~= nil then
		t162.addEmailOver13TextKey = p123.add_email_over13_text_key:jsonEncode()
	end

	if p123.add_email_title_key ~= nil then
		t162.addEmailTitleKey = p123.add_email_title_key:jsonEncode()
	end

	if p123.is_email_modal_called_from_home_page ~= nil then
		t162.isEmailModalCalledFromHomePage = p123.is_email_modal_called_from_home_page:jsonEncode()
	end

	if p123.event_context ~= nil then
		t162.eventContext = p123.event_context:jsonEncode()
	end

	if p123.origin ~= nil then
		t162.origin = p123.origin:jsonEncode()
	end

	if p123.section ~= nil then
		t162.section = p123.section:jsonEncode()
	end

	if p123.on_success ~= nil then
		t162.onSuccess = p123.on_success:jsonEncode()
	end

	if p123.on_failure ~= nil then
		t162.onFailure = p123.on_failure:jsonEncode()
	end

	return t162
end
function t160.jsonDecode(t163: {[any]: any}) -- line: 11069
	-- upvalues: t160 (copy), prop_types (copy), t1 (copy)
	local v1329 = t160.new()

	if t163.add_email_over13_text_key ~= nil then
		v1329.add_email_over13_text_key = prop_types.StringProp.jsonDecode(t163.add_email_over13_text_key)
	end

	if t163.addEmailOver13TextKey ~= nil then
		v1329.add_email_over13_text_key = prop_types.StringProp.jsonDecode(t163.addEmailOver13TextKey)
	end

	if t163.add_email_title_key ~= nil then
		v1329.add_email_title_key = prop_types.StringProp.jsonDecode(t163.add_email_title_key)
	end

	if t163.addEmailTitleKey ~= nil then
		v1329.add_email_title_key = prop_types.StringProp.jsonDecode(t163.addEmailTitleKey)
	end

	if t163.is_email_modal_called_from_home_page ~= nil then
		v1329.is_email_modal_called_from_home_page = prop_types.BoolProp.jsonDecode(t163.is_email_modal_called_from_home_page)
	end

	if t163.isEmailModalCalledFromHomePage ~= nil then
		v1329.is_email_modal_called_from_home_page = prop_types.BoolProp.jsonDecode(t163.isEmailModalCalledFromHomePage)
	end

	if t163.event_context ~= nil then
		v1329.event_context = prop_types.StringProp.jsonDecode(t163.event_context)
	end

	if t163.eventContext ~= nil then
		v1329.event_context = prop_types.StringProp.jsonDecode(t163.eventContext)
	end

	if t163.origin ~= nil then
		v1329.origin = prop_types.StringProp.jsonDecode(t163.origin)
	end

	if t163.section ~= nil then
		v1329.section = prop_types.StringProp.jsonDecode(t163.section)
	end

	if t163.on_success ~= nil then
		v1329.on_success = t1.ActionProp.jsonDecode(t163.on_success)
	end

	if t163.onSuccess ~= nil then
		v1329.on_success = t1.ActionProp.jsonDecode(t163.onSuccess)
	end

	if t163.on_failure ~= nil then
		v1329.on_failure = t1.ActionProp.jsonDecode(t163.on_failure)
	end

	if t163.onFailure ~= nil then
		v1329.on_failure = t1.ActionProp.jsonDecode(t163.onFailure)
	end

	return v1329
end

t160.descriptor = {
	name = "OpenEmailUpsellModalAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.OpenEmailUpsellModalAction_Params = t160
typeRegistry.default:register(t1.OpenEmailUpsellModalAction_Params)

local t164 = {}

t164.__index = t164

function t164.new(t165: {[any]: any}?) -- line: 11159
	-- upvalues: t1 (copy), t164 (copy)
	return (setmetatable({
		action_type = if t165 ~= nil and t165.action_type ~= nil then t165.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t165 ~= nil and t165.action_params ~= nil then t165.action_params else nil
	}, t164))
end
function t164.encode(p124) -- line: 11170
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n81 = 0

	if p124.action_type ~= nil and (p124.action_type ~= nil and p124.action_type ~= 0 or p124.action_type ~= t1.ActionType.fromNumber(0)) then
		local v1334, v1335 = proto.writeTag(buf, n81, 1, proto.wireTypes.varint)

		buf, n81 = proto.writeVarInt(v1334, v1335, t1.ActionType.toNumber(p124.action_type))
	end

	if p124.action_params ~= nil then
		local v1336 = p124.action_params:encode()
		local v1337, v1338 = proto.writeTag(buf, n81, 2, proto.wireTypes.lengthDelimited)

		buf, n81 = proto.writeBuffer(v1337, v1338, v1336, buffer.len(v1336))
	end

	local buf43 = buffer.create(n81)

	buffer.copy(buf43, 0, buf, 0, n81)

	return buf43
end
function t164.decode(p125: buffer) -- line: 11196
	-- upvalues: t164 (copy), proto (copy), t1 (copy)
	local v1341 = t164.new()
	local n82 = 0

	while n82 < buffer.len(p125) do
		local v1343, v1344

		v1343, v1344, n82 = proto.readTag(p125, n82)

		if v1344 == proto.wireTypes.varint then
			if v1343 == 1 then
				local v1345

				v1345, n82 = proto.readVarIntI32(p125, n82)
				v1341.action_type = t1.ActionType.fromNumber(v1345) or v1345
			else
				local v1346

				v1346, n82 = proto.readVarInt(p125, n82)
			end
		elseif v1344 == proto.wireTypes.lengthDelimited then
			if v1343 == 2 then
				local v1347

				v1347, n82 = proto.readBuffer(p125, n82)
				v1341.action_params = t1.OpenAddConnectionsPageAction_Params.decode(v1347)
			else
				local v1348, v1349 = proto.readVarInt(p125, n82)

				n82 = v1349 + v1348
			end
		elseif v1344 == proto.wireTypes.i32 then
			local v1350

			v1350, n82 = proto.readFixed32(p125, n82)
		elseif v1344 == proto.wireTypes.i64 then
			local v1351

			v1351, n82 = proto.readFixed64(p125, n82)
		else
			error("Unsupported wire type: " .. v1344)
		end
	end

	return v1341
end
function t164.jsonEncode(p126) -- line: 11244
	-- upvalues: t1 (copy)
	local t166 = {}

	if p126.action_type ~= nil and (p126.action_type ~= nil and p126.action_type ~= 0 or p126.action_type ~= t1.ActionType.fromNumber(0)) then
		t166.actionType = if typeof(p126.action_type) ~= "number" then t1.ActionType.toNumber(p126.action_type) else p126.action_type
	end

	if p126.action_params ~= nil then
		t166.actionParams = p126.action_params:jsonEncode()
	end

	return t166
end
function t164.jsonDecode(t167: {[any]: any}) -- line: 11266
	-- upvalues: t164 (copy), t1 (copy)
	local v1355 = t164.new()

	if t167.action_type ~= nil then
		v1355.action_type = if typeof(t167.action_type) ~= "number" then t1.ActionType.fromName(t167.action_type) or t167.action_type else t1.ActionType.fromNumber(t167.action_type) or t167.action_type
	end

	if t167.actionType ~= nil then
		v1355.action_type = if typeof(t167.actionType) ~= "number" then t1.ActionType.fromName(t167.actionType) or t167.actionType else t1.ActionType.fromNumber(t167.actionType) or t167.actionType
	end

	if t167.action_params ~= nil then
		v1355.action_params = t1.OpenAddConnectionsPageAction_Params.jsonDecode(t167.action_params)
	end

	if t167.actionParams ~= nil then
		v1355.action_params = t1.OpenAddConnectionsPageAction_Params.jsonDecode(t167.actionParams)
	end

	return v1355
end

t164.descriptor = {
	name = "OpenAddConnectionsPageAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.OpenAddConnectionsPageAction"
}
t1.OpenAddConnectionsPageAction = t164
typeRegistry.default:register(t1.OpenAddConnectionsPageAction)

local t168 = {}

t168.__index = t168

function t168.new(t169: {[any]: any}?) -- line: 11306
	-- upvalues: t168 (copy)
	return (setmetatable({
		user_id = if t169 ~= nil and t169.user_id ~= nil then t169.user_id else nil,
		source = if t169 ~= nil and t169.source ~= nil then t169.source else nil
	}, t168))
end
function t168.encode(p127) -- line: 11315
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n83 = 0

	if p127.user_id ~= nil then
		local v1360 = p127.user_id:encode()
		local v1361, v1362 = proto.writeTag(buf, n83, 1, proto.wireTypes.lengthDelimited)

		buf, n83 = proto.writeBuffer(v1361, v1362, v1360, buffer.len(v1360))
	end

	if p127.source ~= nil then
		local v1363 = p127.source:encode()
		local v1364, v1365 = proto.writeTag(buf, n83, 2, proto.wireTypes.lengthDelimited)

		buf, n83 = proto.writeBuffer(v1364, v1365, v1363, buffer.len(v1363))
	end

	local buf44 = buffer.create(n83)

	buffer.copy(buf44, 0, buf, 0, n83)

	return buf44
end
function t168.decode(p128: buffer) -- line: 11336
	-- upvalues: t168 (copy), proto (copy), prop_types (copy)
	local v1368 = t168.new()
	local n84 = 0

	while n84 < buffer.len(p128) do
		local v1370, v1371

		v1370, v1371, n84 = proto.readTag(p128, n84)

		if v1371 == proto.wireTypes.varint then
			local v1372

			v1372, n84 = proto.readVarInt(p128, n84)
		elseif v1371 == proto.wireTypes.lengthDelimited then
			if v1370 == 1 then
				local v1373

				v1373, n84 = proto.readBuffer(p128, n84)
				v1368.user_id = prop_types.StringProp.decode(v1373)
			elseif v1370 == 2 then
				local v1374

				v1374, n84 = proto.readBuffer(p128, n84)
				v1368.source = prop_types.StringProp.decode(v1374)
			else
				local v1375, v1376 = proto.readVarInt(p128, n84)

				n84 = v1376 + v1375
			end
		elseif v1371 == proto.wireTypes.i32 then
			local v1377

			v1377, n84 = proto.readFixed32(p128, n84)
		elseif v1371 == proto.wireTypes.i64 then
			local v1378

			v1378, n84 = proto.readFixed64(p128, n84)
		else
			error("Unsupported wire type: " .. v1371)
		end
	end

	return v1368
end
function t168.jsonEncode(p129) -- line: 11384
	local t170 = {}

	if p129.user_id ~= nil then
		t170.userId = p129.user_id:jsonEncode()
	end

	if p129.source ~= nil then
		t170.source = p129.source:jsonEncode()
	end

	return t170
end
function t168.jsonDecode(t171: {[any]: any}) -- line: 11398
	-- upvalues: t168 (copy), prop_types (copy)
	local v1382 = t168.new()

	if t171.user_id ~= nil then
		v1382.user_id = prop_types.StringProp.jsonDecode(t171.user_id)
	end

	if t171.userId ~= nil then
		v1382.user_id = prop_types.StringProp.jsonDecode(t171.userId)
	end

	if t171.source ~= nil then
		v1382.source = prop_types.StringProp.jsonDecode(t171.source)
	end

	return v1382
end

t168.descriptor = {
	name = "OpenAddConnectionsPageAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.OpenAddConnectionsPageAction_Params = t168
typeRegistry.default:register(t1.OpenAddConnectionsPageAction_Params)

local t172 = {}

t172.__index = t172

function t172.new(t173: {[any]: any}?) -- line: 11432
	-- upvalues: t1 (copy), t172 (copy)
	return (setmetatable({
		action_type = if t173 ~= nil and t173.action_type ~= nil then t173.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t173 ~= nil and t173.action_params ~= nil then t173.action_params else nil
	}, t172))
end
function t172.encode(p130) -- line: 11441
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n85 = 0

	if p130.action_type ~= nil and (p130.action_type ~= nil and p130.action_type ~= 0 or p130.action_type ~= t1.ActionType.fromNumber(0)) then
		local v1387, v1388 = proto.writeTag(buf, n85, 1, proto.wireTypes.varint)

		buf, n85 = proto.writeVarInt(v1387, v1388, t1.ActionType.toNumber(p130.action_type))
	end

	if p130.action_params ~= nil then
		local v1389 = p130.action_params:encode()
		local v1390, v1391 = proto.writeTag(buf, n85, 2, proto.wireTypes.lengthDelimited)

		buf, n85 = proto.writeBuffer(v1390, v1391, v1389, buffer.len(v1389))
	end

	local buf45 = buffer.create(n85)

	buffer.copy(buf45, 0, buf, 0, n85)

	return buf45
end
function t172.decode(p131: buffer) -- line: 11467
	-- upvalues: t172 (copy), proto (copy), t1 (copy)
	local v1394 = t172.new()
	local n86 = 0

	while n86 < buffer.len(p131) do
		local v1396, v1397

		v1396, v1397, n86 = proto.readTag(p131, n86)

		if v1397 == proto.wireTypes.varint then
			if v1396 == 1 then
				local v1398

				v1398, n86 = proto.readVarIntI32(p131, n86)
				v1394.action_type = t1.ActionType.fromNumber(v1398) or v1398
			else
				local v1399

				v1399, n86 = proto.readVarInt(p131, n86)
			end
		elseif v1397 == proto.wireTypes.lengthDelimited then
			if v1396 == 2 then
				local v1400

				v1400, n86 = proto.readBuffer(p131, n86)
				v1394.action_params = t1.OpenMarketplaceAction_Params.decode(v1400)
			else
				local v1401, v1402 = proto.readVarInt(p131, n86)

				n86 = v1402 + v1401
			end
		elseif v1397 == proto.wireTypes.i32 then
			local v1403

			v1403, n86 = proto.readFixed32(p131, n86)
		elseif v1397 == proto.wireTypes.i64 then
			local v1404

			v1404, n86 = proto.readFixed64(p131, n86)
		else
			error("Unsupported wire type: " .. v1397)
		end
	end

	return v1394
end
function t172.jsonEncode(p132) -- line: 11515
	-- upvalues: t1 (copy)
	local t174 = {}

	if p132.action_type ~= nil and (p132.action_type ~= nil and p132.action_type ~= 0 or p132.action_type ~= t1.ActionType.fromNumber(0)) then
		t174.actionType = if typeof(p132.action_type) ~= "number" then t1.ActionType.toNumber(p132.action_type) else p132.action_type
	end

	if p132.action_params ~= nil then
		t174.actionParams = p132.action_params:jsonEncode()
	end

	return t174
end
function t172.jsonDecode(t175: {[any]: any}) -- line: 11537
	-- upvalues: t172 (copy), t1 (copy)
	local v1408 = t172.new()

	if t175.action_type ~= nil then
		v1408.action_type = if typeof(t175.action_type) ~= "number" then t1.ActionType.fromName(t175.action_type) or t175.action_type else t1.ActionType.fromNumber(t175.action_type) or t175.action_type
	end

	if t175.actionType ~= nil then
		v1408.action_type = if typeof(t175.actionType) ~= "number" then t1.ActionType.fromName(t175.actionType) or t175.actionType else t1.ActionType.fromNumber(t175.actionType) or t175.actionType
	end

	if t175.action_params ~= nil then
		v1408.action_params = t1.OpenMarketplaceAction_Params.jsonDecode(t175.action_params)
	end

	if t175.actionParams ~= nil then
		v1408.action_params = t1.OpenMarketplaceAction_Params.jsonDecode(t175.actionParams)
	end

	return v1408
end

t172.descriptor = {
	name = "OpenMarketplaceAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.OpenMarketplaceAction"
}
t1.OpenMarketplaceAction = t172
typeRegistry.default:register(t1.OpenMarketplaceAction)

local t176 = {}

t176.__index = t176

function t176.new(t177: {[any]: any}?) -- line: 11577
	-- upvalues: t176 (copy)
	return (setmetatable({
		user_id = if t177 ~= nil and t177.user_id ~= nil then t177.user_id else nil,
		source = if t177 ~= nil and t177.source ~= nil then t177.source else nil
	}, t176))
end
function t176.encode(p133) -- line: 11586
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n87 = 0

	if p133.user_id ~= nil then
		local v1413 = p133.user_id:encode()
		local v1414, v1415 = proto.writeTag(buf, n87, 1, proto.wireTypes.lengthDelimited)

		buf, n87 = proto.writeBuffer(v1414, v1415, v1413, buffer.len(v1413))
	end

	if p133.source ~= nil then
		local v1416 = p133.source:encode()
		local v1417, v1418 = proto.writeTag(buf, n87, 2, proto.wireTypes.lengthDelimited)

		buf, n87 = proto.writeBuffer(v1417, v1418, v1416, buffer.len(v1416))
	end

	local buf46 = buffer.create(n87)

	buffer.copy(buf46, 0, buf, 0, n87)

	return buf46
end
function t176.decode(p134: buffer) -- line: 11607
	-- upvalues: t176 (copy), proto (copy), prop_types (copy)
	local v1421 = t176.new()
	local n88 = 0

	while n88 < buffer.len(p134) do
		local v1423, v1424

		v1423, v1424, n88 = proto.readTag(p134, n88)

		if v1424 == proto.wireTypes.varint then
			local v1425

			v1425, n88 = proto.readVarInt(p134, n88)
		elseif v1424 == proto.wireTypes.lengthDelimited then
			if v1423 == 1 then
				local v1426

				v1426, n88 = proto.readBuffer(p134, n88)
				v1421.user_id = prop_types.StringProp.decode(v1426)
			elseif v1423 == 2 then
				local v1427

				v1427, n88 = proto.readBuffer(p134, n88)
				v1421.source = prop_types.StringProp.decode(v1427)
			else
				local v1428, v1429 = proto.readVarInt(p134, n88)

				n88 = v1429 + v1428
			end
		elseif v1424 == proto.wireTypes.i32 then
			local v1430

			v1430, n88 = proto.readFixed32(p134, n88)
		elseif v1424 == proto.wireTypes.i64 then
			local v1431

			v1431, n88 = proto.readFixed64(p134, n88)
		else
			error("Unsupported wire type: " .. v1424)
		end
	end

	return v1421
end
function t176.jsonEncode(p135) -- line: 11655
	local t178 = {}

	if p135.user_id ~= nil then
		t178.userId = p135.user_id:jsonEncode()
	end

	if p135.source ~= nil then
		t178.source = p135.source:jsonEncode()
	end

	return t178
end
function t176.jsonDecode(t179: {[any]: any}) -- line: 11669
	-- upvalues: t176 (copy), prop_types (copy)
	local v1435 = t176.new()

	if t179.user_id ~= nil then
		v1435.user_id = prop_types.StringProp.jsonDecode(t179.user_id)
	end

	if t179.userId ~= nil then
		v1435.user_id = prop_types.StringProp.jsonDecode(t179.userId)
	end

	if t179.source ~= nil then
		v1435.source = prop_types.StringProp.jsonDecode(t179.source)
	end

	return v1435
end

t176.descriptor = {
	name = "OpenMarketplaceAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.OpenMarketplaceAction_Params = t176
typeRegistry.default:register(t1.OpenMarketplaceAction_Params)

local t180 = {}

t180.__index = t180

function t180.new(t181: {[any]: any}?) -- line: 11701
	-- upvalues: t1 (copy), t180 (copy)
	return (setmetatable({
		action_type = if t181 ~= nil and t181.action_type ~= nil then t181.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t181 ~= nil and t181.action_params ~= nil then t181.action_params else nil
	}, t180))
end
function t180.encode(p136) -- line: 11712
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n89 = 0

	if p136.action_type ~= nil and (p136.action_type ~= nil and p136.action_type ~= 0 or p136.action_type ~= t1.ActionType.fromNumber(0)) then
		local v1440, v1441 = proto.writeTag(buf, n89, 1, proto.wireTypes.varint)

		buf, n89 = proto.writeVarInt(v1440, v1441, t1.ActionType.toNumber(p136.action_type))
	end

	if p136.action_params ~= nil then
		local v1442 = p136.action_params:encode()
		local v1443, v1444 = proto.writeTag(buf, n89, 2, proto.wireTypes.lengthDelimited)

		buf, n89 = proto.writeBuffer(v1443, v1444, v1442, buffer.len(v1442))
	end

	local buf47 = buffer.create(n89)

	buffer.copy(buf47, 0, buf, 0, n89)

	return buf47
end
function t180.decode(p137: buffer) -- line: 11738
	-- upvalues: t180 (copy), proto (copy), t1 (copy)
	local v1447 = t180.new()
	local n90 = 0

	while n90 < buffer.len(p137) do
		local v1449, v1450

		v1449, v1450, n90 = proto.readTag(p137, n90)

		if v1450 == proto.wireTypes.varint then
			if v1449 == 1 then
				local v1451

				v1451, n90 = proto.readVarIntI32(p137, n90)
				v1447.action_type = t1.ActionType.fromNumber(v1451) or v1451
			else
				local v1452

				v1452, n90 = proto.readVarInt(p137, n90)
			end
		elseif v1450 == proto.wireTypes.lengthDelimited then
			if v1449 == 2 then
				local v1453

				v1453, n90 = proto.readBuffer(p137, n90)
				v1447.action_params = t1.HideProfileCompletionAction_Params.decode(v1453)
			else
				local v1454, v1455 = proto.readVarInt(p137, n90)

				n90 = v1455 + v1454
			end
		elseif v1450 == proto.wireTypes.i32 then
			local v1456

			v1456, n90 = proto.readFixed32(p137, n90)
		elseif v1450 == proto.wireTypes.i64 then
			local v1457

			v1457, n90 = proto.readFixed64(p137, n90)
		else
			error("Unsupported wire type: " .. v1450)
		end
	end

	return v1447
end
function t180.jsonEncode(p138) -- line: 11786
	-- upvalues: t1 (copy)
	local t182 = {}

	if p138.action_type ~= nil and (p138.action_type ~= nil and p138.action_type ~= 0 or p138.action_type ~= t1.ActionType.fromNumber(0)) then
		t182.actionType = if typeof(p138.action_type) ~= "number" then t1.ActionType.toNumber(p138.action_type) else p138.action_type
	end

	if p138.action_params ~= nil then
		t182.actionParams = p138.action_params:jsonEncode()
	end

	return t182
end
function t180.jsonDecode(t183: {[any]: any}) -- line: 11808
	-- upvalues: t180 (copy), t1 (copy)
	local v1461 = t180.new()

	if t183.action_type ~= nil then
		v1461.action_type = if typeof(t183.action_type) ~= "number" then t1.ActionType.fromName(t183.action_type) or t183.action_type else t1.ActionType.fromNumber(t183.action_type) or t183.action_type
	end

	if t183.actionType ~= nil then
		v1461.action_type = if typeof(t183.actionType) ~= "number" then t1.ActionType.fromName(t183.actionType) or t183.actionType else t1.ActionType.fromNumber(t183.actionType) or t183.actionType
	end

	if t183.action_params ~= nil then
		v1461.action_params = t1.HideProfileCompletionAction_Params.jsonDecode(t183.action_params)
	end

	if t183.actionParams ~= nil then
		v1461.action_params = t1.HideProfileCompletionAction_Params.jsonDecode(t183.actionParams)
	end

	return v1461
end

t180.descriptor = {
	name = "HideProfileCompletionAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.HideProfileCompletionAction"
}
t1.HideProfileCompletionAction = t180
typeRegistry.default:register(t1.HideProfileCompletionAction)

local t184 = {}

t184.__index = t184

function t184.new(t185: {[any]: any}?) -- line: 11848
	-- upvalues: t184 (copy)
	return (setmetatable({
		user_id = if t185 ~= nil and t185.user_id ~= nil then t185.user_id else nil,
		prompt_id = if t185 ~= nil and t185.prompt_id ~= nil then t185.prompt_id else nil,
		source = if t185 ~= nil and t185.source ~= nil then t185.source else nil,
		prompt_type = if t185 ~= nil and t185.prompt_type ~= nil then t185.prompt_type else nil
	}, t184))
end
function t184.encode(p139) -- line: 11859
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n91 = 0

	if p139.user_id ~= nil then
		local v1466 = p139.user_id:encode()
		local v1467, v1468 = proto.writeTag(buf, n91, 1, proto.wireTypes.lengthDelimited)

		buf, n91 = proto.writeBuffer(v1467, v1468, v1466, buffer.len(v1466))
	end

	if p139.prompt_id ~= nil then
		local v1469 = p139.prompt_id:encode()
		local v1470, v1471 = proto.writeTag(buf, n91, 2, proto.wireTypes.lengthDelimited)

		buf, n91 = proto.writeBuffer(v1470, v1471, v1469, buffer.len(v1469))
	end

	if p139.source ~= nil then
		local v1472 = p139.source:encode()
		local v1473, v1474 = proto.writeTag(buf, n91, 3, proto.wireTypes.lengthDelimited)

		buf, n91 = proto.writeBuffer(v1473, v1474, v1472, buffer.len(v1472))
	end

	if p139.prompt_type ~= nil then
		local v1475 = p139.prompt_type:encode()
		local v1476, v1477 = proto.writeTag(buf, n91, 4, proto.wireTypes.lengthDelimited)

		buf, n91 = proto.writeBuffer(v1476, v1477, v1475, buffer.len(v1475))
	end

	local buf48 = buffer.create(n91)

	buffer.copy(buf48, 0, buf, 0, n91)

	return buf48
end
function t184.decode(p140: buffer) -- line: 11892
	-- upvalues: t184 (copy), proto (copy), prop_types (copy)
	local v1480 = t184.new()
	local n92 = 0

	while n92 < buffer.len(p140) do
		local v1482, v1483

		v1482, v1483, n92 = proto.readTag(p140, n92)

		if v1483 == proto.wireTypes.varint then
			local v1484

			v1484, n92 = proto.readVarInt(p140, n92)
		elseif v1483 == proto.wireTypes.lengthDelimited then
			if v1482 == 1 then
				local v1485

				v1485, n92 = proto.readBuffer(p140, n92)
				v1480.user_id = prop_types.StringProp.decode(v1485)
			elseif v1482 == 2 then
				local v1486

				v1486, n92 = proto.readBuffer(p140, n92)
				v1480.prompt_id = prop_types.StringProp.decode(v1486)
			elseif v1482 == 3 then
				local v1487

				v1487, n92 = proto.readBuffer(p140, n92)
				v1480.source = prop_types.StringProp.decode(v1487)
			elseif v1482 == 4 then
				local v1488

				v1488, n92 = proto.readBuffer(p140, n92)
				v1480.prompt_type = prop_types.StringProp.decode(v1488)
			else
				local v1489, v1490 = proto.readVarInt(p140, n92)

				n92 = v1490 + v1489
			end
		elseif v1483 == proto.wireTypes.i32 then
			local v1491

			v1491, n92 = proto.readFixed32(p140, n92)
		elseif v1483 == proto.wireTypes.i64 then
			local v1492

			v1492, n92 = proto.readFixed64(p140, n92)
		else
			error("Unsupported wire type: " .. v1483)
		end
	end

	return v1480
end
function t184.jsonEncode(p141) -- line: 11950
	local t186 = {}

	if p141.user_id ~= nil then
		t186.userId = p141.user_id:jsonEncode()
	end

	if p141.prompt_id ~= nil then
		t186.promptId = p141.prompt_id:jsonEncode()
	end

	if p141.source ~= nil then
		t186.source = p141.source:jsonEncode()
	end

	if p141.prompt_type ~= nil then
		t186.promptType = p141.prompt_type:jsonEncode()
	end

	return t186
end
function t184.jsonDecode(t187: {[any]: any}) -- line: 11972
	-- upvalues: t184 (copy), prop_types (copy)
	local v1496 = t184.new()

	if t187.user_id ~= nil then
		v1496.user_id = prop_types.StringProp.jsonDecode(t187.user_id)
	end

	if t187.userId ~= nil then
		v1496.user_id = prop_types.StringProp.jsonDecode(t187.userId)
	end

	if t187.prompt_id ~= nil then
		v1496.prompt_id = prop_types.StringProp.jsonDecode(t187.prompt_id)
	end

	if t187.promptId ~= nil then
		v1496.prompt_id = prop_types.StringProp.jsonDecode(t187.promptId)
	end

	if t187.source ~= nil then
		v1496.source = prop_types.StringProp.jsonDecode(t187.source)
	end

	if t187.prompt_type ~= nil then
		v1496.prompt_type = prop_types.StringProp.jsonDecode(t187.prompt_type)
	end

	if t187.promptType ~= nil then
		v1496.prompt_type = prop_types.StringProp.jsonDecode(t187.promptType)
	end

	return v1496
end

t184.descriptor = {
	name = "HideProfileCompletionAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.HideProfileCompletionAction_Params = t184
typeRegistry.default:register(t1.HideProfileCompletionAction_Params)

local t188 = {}

t188.__index = t188

function t188.new(t189: {[any]: any}?) -- line: 12023
	-- upvalues: t1 (copy), t188 (copy)
	return (setmetatable({
		action_type = if t189 ~= nil and t189.action_type ~= nil then t189.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t189 ~= nil and t189.action_params ~= nil then t189.action_params else nil
	}, t188))
end
function t188.encode(p142) -- line: 12034
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n93 = 0

	if p142.action_type ~= nil and (p142.action_type ~= nil and p142.action_type ~= 0 or p142.action_type ~= t1.ActionType.fromNumber(0)) then
		local v1501, v1502 = proto.writeTag(buf, n93, 1, proto.wireTypes.varint)

		buf, n93 = proto.writeVarInt(v1501, v1502, t1.ActionType.toNumber(p142.action_type))
	end

	if p142.action_params ~= nil then
		local v1503 = p142.action_params:encode()
		local v1504, v1505 = proto.writeTag(buf, n93, 2, proto.wireTypes.lengthDelimited)

		buf, n93 = proto.writeBuffer(v1504, v1505, v1503, buffer.len(v1503))
	end

	local buf49 = buffer.create(n93)

	buffer.copy(buf49, 0, buf, 0, n93)

	return buf49
end
function t188.decode(p143: buffer) -- line: 12060
	-- upvalues: t188 (copy), proto (copy), t1 (copy)
	local v1508 = t188.new()
	local n94 = 0

	while n94 < buffer.len(p143) do
		local v1510, v1511

		v1510, v1511, n94 = proto.readTag(p143, n94)

		if v1511 == proto.wireTypes.varint then
			if v1510 == 1 then
				local v1512

				v1512, n94 = proto.readVarIntI32(p143, n94)
				v1508.action_type = t1.ActionType.fromNumber(v1512) or v1512
			else
				local v1513

				v1513, n94 = proto.readVarInt(p143, n94)
			end
		elseif v1511 == proto.wireTypes.lengthDelimited then
			if v1510 == 2 then
				local v1514

				v1514, n94 = proto.readBuffer(p143, n94)
				v1508.action_params = t1.SelectMarketplaceCatalogCategory_Params.decode(v1514)
			else
				local v1515, v1516 = proto.readVarInt(p143, n94)

				n94 = v1516 + v1515
			end
		elseif v1511 == proto.wireTypes.i32 then
			local v1517

			v1517, n94 = proto.readFixed32(p143, n94)
		elseif v1511 == proto.wireTypes.i64 then
			local v1518

			v1518, n94 = proto.readFixed64(p143, n94)
		else
			error("Unsupported wire type: " .. v1511)
		end
	end

	return v1508
end
function t188.jsonEncode(p144) -- line: 12108
	-- upvalues: t1 (copy)
	local t190 = {}

	if p144.action_type ~= nil and (p144.action_type ~= nil and p144.action_type ~= 0 or p144.action_type ~= t1.ActionType.fromNumber(0)) then
		t190.actionType = if typeof(p144.action_type) ~= "number" then t1.ActionType.toNumber(p144.action_type) else p144.action_type
	end

	if p144.action_params ~= nil then
		t190.actionParams = p144.action_params:jsonEncode()
	end

	return t190
end
function t188.jsonDecode(t191: {[any]: any}) -- line: 12130
	-- upvalues: t188 (copy), t1 (copy)
	local v1522 = t188.new()

	if t191.action_type ~= nil then
		v1522.action_type = if typeof(t191.action_type) ~= "number" then t1.ActionType.fromName(t191.action_type) or t191.action_type else t1.ActionType.fromNumber(t191.action_type) or t191.action_type
	end

	if t191.actionType ~= nil then
		v1522.action_type = if typeof(t191.actionType) ~= "number" then t1.ActionType.fromName(t191.actionType) or t191.actionType else t1.ActionType.fromNumber(t191.actionType) or t191.actionType
	end

	if t191.action_params ~= nil then
		v1522.action_params = t1.SelectMarketplaceCatalogCategory_Params.jsonDecode(t191.action_params)
	end

	if t191.actionParams ~= nil then
		v1522.action_params = t1.SelectMarketplaceCatalogCategory_Params.jsonDecode(t191.actionParams)
	end

	return v1522
end

t188.descriptor = {
	name = "SelectMarketplaceCatalogCategory",
	fullName = "roblox.apppageplatform.shared.v1beta1.SelectMarketplaceCatalogCategory"
}
t1.SelectMarketplaceCatalogCategory = t188
typeRegistry.default:register(t1.SelectMarketplaceCatalogCategory)

local t192 = {}

t192.__index = t192

function t192.new(t193: {[any]: any}?) -- line: 12172
	-- upvalues: t192 (copy)
	return (setmetatable({
		category_id = if t193 ~= nil and t193.category_id ~= nil then t193.category_id else nil
	}, t192))
end
function t192.encode(p145) -- line: 12180
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n95 = 0

	if p145.category_id ~= nil then
		local v1527 = p145.category_id:encode()
		local v1528, v1529 = proto.writeTag(buf, n95, 1, proto.wireTypes.lengthDelimited)

		buf, n95 = proto.writeBuffer(v1528, v1529, v1527, buffer.len(v1527))
	end

	local buf50 = buffer.create(n95)

	buffer.copy(buf50, 0, buf, 0, n95)

	return buf50
end
function t192.decode(p146: buffer) -- line: 12195
	-- upvalues: t192 (copy), proto (copy), prop_types (copy)
	local v1532 = t192.new()
	local n96 = 0

	while n96 < buffer.len(p146) do
		local v1534, v1535

		v1534, v1535, n96 = proto.readTag(p146, n96)

		if v1535 == proto.wireTypes.varint then
			local v1536

			v1536, n96 = proto.readVarInt(p146, n96)
		elseif v1535 == proto.wireTypes.lengthDelimited then
			if v1534 == 1 then
				local v1537

				v1537, n96 = proto.readBuffer(p146, n96)
				v1532.category_id = prop_types.StringProp.decode(v1537)
			else
				local v1538, v1539 = proto.readVarInt(p146, n96)

				n96 = v1539 + v1538
			end
		elseif v1535 == proto.wireTypes.i32 then
			local v1540

			v1540, n96 = proto.readFixed32(p146, n96)
		elseif v1535 == proto.wireTypes.i64 then
			local v1541

			v1541, n96 = proto.readFixed64(p146, n96)
		else
			error("Unsupported wire type: " .. v1535)
		end
	end

	return v1532
end
function t192.jsonEncode(p147) -- line: 12238
	local t194 = {}

	if p147.category_id ~= nil then
		t194.categoryId = p147.category_id:jsonEncode()
	end

	return t194
end
function t192.jsonDecode(t195: {[any]: any}) -- line: 12248
	-- upvalues: t192 (copy), prop_types (copy)
	local v1545 = t192.new()

	if t195.category_id ~= nil then
		v1545.category_id = prop_types.StringProp.jsonDecode(t195.category_id)
	end

	if t195.categoryId ~= nil then
		v1545.category_id = prop_types.StringProp.jsonDecode(t195.categoryId)
	end

	return v1545
end

t192.descriptor = {
	name = "SelectMarketplaceCatalogCategory_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.SelectMarketplaceCatalogCategory_Params = t192
typeRegistry.default:register(t1.SelectMarketplaceCatalogCategory_Params)

local t196 = {}

t196.__index = t196

function t196.new(t197: {[any]: any}?) -- line: 12279
	-- upvalues: t1 (copy), t196 (copy)
	return (setmetatable({
		action_type = if t197 ~= nil and t197.action_type ~= nil then t197.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t197 ~= nil and t197.action_params ~= nil then t197.action_params else nil
	}, t196))
end
function t196.encode(p148) -- line: 12290
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n97 = 0

	if p148.action_type ~= nil and (p148.action_type ~= nil and p148.action_type ~= 0 or p148.action_type ~= t1.ActionType.fromNumber(0)) then
		local v1550, v1551 = proto.writeTag(buf, n97, 1, proto.wireTypes.varint)

		buf, n97 = proto.writeVarInt(v1550, v1551, t1.ActionType.toNumber(p148.action_type))
	end

	if p148.action_params ~= nil then
		local v1552 = p148.action_params:encode()
		local v1553, v1554 = proto.writeTag(buf, n97, 2, proto.wireTypes.lengthDelimited)

		buf, n97 = proto.writeBuffer(v1553, v1554, v1552, buffer.len(v1552))
	end

	local buf51 = buffer.create(n97)

	buffer.copy(buf51, 0, buf, 0, n97)

	return buf51
end
function t196.decode(p149: buffer) -- line: 12316
	-- upvalues: t196 (copy), proto (copy), t1 (copy)
	local v1557 = t196.new()
	local n98 = 0

	while n98 < buffer.len(p149) do
		local v1559, v1560

		v1559, v1560, n98 = proto.readTag(p149, n98)

		if v1560 == proto.wireTypes.varint then
			if v1559 == 1 then
				local v1561

				v1561, n98 = proto.readVarIntI32(p149, n98)
				v1557.action_type = t1.ActionType.fromNumber(v1561) or v1561
			else
				local v1562

				v1562, n98 = proto.readVarInt(p149, n98)
			end
		elseif v1560 == proto.wireTypes.lengthDelimited then
			if v1559 == 2 then
				local v1563

				v1563, n98 = proto.readBuffer(p149, n98)
				v1557.action_params = t1.SelectMarketplaceCatalogSubcategory_Params.decode(v1563)
			else
				local v1564, v1565 = proto.readVarInt(p149, n98)

				n98 = v1565 + v1564
			end
		elseif v1560 == proto.wireTypes.i32 then
			local v1566

			v1566, n98 = proto.readFixed32(p149, n98)
		elseif v1560 == proto.wireTypes.i64 then
			local v1567

			v1567, n98 = proto.readFixed64(p149, n98)
		else
			error("Unsupported wire type: " .. v1560)
		end
	end

	return v1557
end
function t196.jsonEncode(p150) -- line: 12364
	-- upvalues: t1 (copy)
	local t198 = {}

	if p150.action_type ~= nil and (p150.action_type ~= nil and p150.action_type ~= 0 or p150.action_type ~= t1.ActionType.fromNumber(0)) then
		t198.actionType = if typeof(p150.action_type) ~= "number" then t1.ActionType.toNumber(p150.action_type) else p150.action_type
	end

	if p150.action_params ~= nil then
		t198.actionParams = p150.action_params:jsonEncode()
	end

	return t198
end
function t196.jsonDecode(t199: {[any]: any}) -- line: 12386
	-- upvalues: t196 (copy), t1 (copy)
	local v1571 = t196.new()

	if t199.action_type ~= nil then
		v1571.action_type = if typeof(t199.action_type) ~= "number" then t1.ActionType.fromName(t199.action_type) or t199.action_type else t1.ActionType.fromNumber(t199.action_type) or t199.action_type
	end

	if t199.actionType ~= nil then
		v1571.action_type = if typeof(t199.actionType) ~= "number" then t1.ActionType.fromName(t199.actionType) or t199.actionType else t1.ActionType.fromNumber(t199.actionType) or t199.actionType
	end

	if t199.action_params ~= nil then
		v1571.action_params = t1.SelectMarketplaceCatalogSubcategory_Params.jsonDecode(t199.action_params)
	end

	if t199.actionParams ~= nil then
		v1571.action_params = t1.SelectMarketplaceCatalogSubcategory_Params.jsonDecode(t199.actionParams)
	end

	return v1571
end

t196.descriptor = {
	name = "SelectMarketplaceCatalogSubcategory",
	fullName = "roblox.apppageplatform.shared.v1beta1.SelectMarketplaceCatalogSubcategory"
}
t1.SelectMarketplaceCatalogSubcategory = t196
typeRegistry.default:register(t1.SelectMarketplaceCatalogSubcategory)

local t200 = {}

t200.__index = t200

function t200.new(t201: {[any]: any}?) -- line: 12428
	-- upvalues: t200 (copy)
	return (setmetatable({
		subcategory_id = if t201 ~= nil and t201.subcategory_id ~= nil then t201.subcategory_id else nil
	}, t200))
end
function t200.encode(p151) -- line: 12436
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n99 = 0

	if p151.subcategory_id ~= nil then
		local v1576 = p151.subcategory_id:encode()
		local v1577, v1578 = proto.writeTag(buf, n99, 1, proto.wireTypes.lengthDelimited)

		buf, n99 = proto.writeBuffer(v1577, v1578, v1576, buffer.len(v1576))
	end

	local buf52 = buffer.create(n99)

	buffer.copy(buf52, 0, buf, 0, n99)

	return buf52
end
function t200.decode(p152: buffer) -- line: 12453
	-- upvalues: t200 (copy), proto (copy), prop_types (copy)
	local v1581 = t200.new()
	local n100 = 0

	while n100 < buffer.len(p152) do
		local v1583, v1584

		v1583, v1584, n100 = proto.readTag(p152, n100)

		if v1584 == proto.wireTypes.varint then
			local v1585

			v1585, n100 = proto.readVarInt(p152, n100)
		elseif v1584 == proto.wireTypes.lengthDelimited then
			if v1583 == 1 then
				local v1586

				v1586, n100 = proto.readBuffer(p152, n100)
				v1581.subcategory_id = prop_types.StringProp.decode(v1586)
			else
				local v1587, v1588 = proto.readVarInt(p152, n100)

				n100 = v1588 + v1587
			end
		elseif v1584 == proto.wireTypes.i32 then
			local v1589

			v1589, n100 = proto.readFixed32(p152, n100)
		elseif v1584 == proto.wireTypes.i64 then
			local v1590

			v1590, n100 = proto.readFixed64(p152, n100)
		else
			error("Unsupported wire type: " .. v1584)
		end
	end

	return v1581
end
function t200.jsonEncode(p153) -- line: 12498
	local t202 = {}

	if p153.subcategory_id ~= nil then
		t202.subcategoryId = p153.subcategory_id:jsonEncode()
	end

	return t202
end
function t200.jsonDecode(t203: {[any]: any}) -- line: 12510
	-- upvalues: t200 (copy), prop_types (copy)
	local v1594 = t200.new()

	if t203.subcategory_id ~= nil then
		v1594.subcategory_id = prop_types.StringProp.jsonDecode(t203.subcategory_id)
	end

	if t203.subcategoryId ~= nil then
		v1594.subcategory_id = prop_types.StringProp.jsonDecode(t203.subcategoryId)
	end

	return v1594
end

t200.descriptor = {
	name = "SelectMarketplaceCatalogSubcategory_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.SelectMarketplaceCatalogSubcategory_Params = t200
typeRegistry.default:register(t1.SelectMarketplaceCatalogSubcategory_Params)

local t204 = {}

t204.__index = t204

function t204.new(t205: {[any]: any}?) -- line: 12542
	-- upvalues: t1 (copy), t204 (copy)
	return (setmetatable({
		action_type = if t205 ~= nil and t205.action_type ~= nil then t205.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t205 ~= nil and t205.action_params ~= nil then t205.action_params else nil
	}, t204))
end
function t204.encode(p154) -- line: 12553
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n101 = 0

	if p154.action_type ~= nil and (p154.action_type ~= nil and p154.action_type ~= 0 or p154.action_type ~= t1.ActionType.fromNumber(0)) then
		local v1599, v1600 = proto.writeTag(buf, n101, 1, proto.wireTypes.varint)

		buf, n101 = proto.writeVarInt(v1599, v1600, t1.ActionType.toNumber(p154.action_type))
	end

	if p154.action_params ~= nil then
		local v1601 = p154.action_params:encode()
		local v1602, v1603 = proto.writeTag(buf, n101, 2, proto.wireTypes.lengthDelimited)

		buf, n101 = proto.writeBuffer(v1602, v1603, v1601, buffer.len(v1601))
	end

	local buf53 = buffer.create(n101)

	buffer.copy(buf53, 0, buf, 0, n101)

	return buf53
end
function t204.decode(p155: buffer) -- line: 12579
	-- upvalues: t204 (copy), proto (copy), t1 (copy)
	local v1606 = t204.new()
	local n102 = 0

	while n102 < buffer.len(p155) do
		local v1608, v1609

		v1608, v1609, n102 = proto.readTag(p155, n102)

		if v1609 == proto.wireTypes.varint then
			if v1608 == 1 then
				local v1610

				v1610, n102 = proto.readVarIntI32(p155, n102)
				v1606.action_type = t1.ActionType.fromNumber(v1610) or v1610
			else
				local v1611

				v1611, n102 = proto.readVarInt(p155, n102)
			end
		elseif v1609 == proto.wireTypes.lengthDelimited then
			if v1608 == 2 then
				local v1612

				v1612, n102 = proto.readBuffer(p155, n102)
				v1606.action_params = t1.OpenMarketplaceCatalogSeeAll_Params.decode(v1612)
			else
				local v1613, v1614 = proto.readVarInt(p155, n102)

				n102 = v1614 + v1613
			end
		elseif v1609 == proto.wireTypes.i32 then
			local v1615

			v1615, n102 = proto.readFixed32(p155, n102)
		elseif v1609 == proto.wireTypes.i64 then
			local v1616

			v1616, n102 = proto.readFixed64(p155, n102)
		else
			error("Unsupported wire type: " .. v1609)
		end
	end

	return v1606
end
function t204.jsonEncode(p156) -- line: 12627
	-- upvalues: t1 (copy)
	local t206 = {}

	if p156.action_type ~= nil and (p156.action_type ~= nil and p156.action_type ~= 0 or p156.action_type ~= t1.ActionType.fromNumber(0)) then
		t206.actionType = if typeof(p156.action_type) ~= "number" then t1.ActionType.toNumber(p156.action_type) else p156.action_type
	end

	if p156.action_params ~= nil then
		t206.actionParams = p156.action_params:jsonEncode()
	end

	return t206
end
function t204.jsonDecode(t207: {[any]: any}) -- line: 12649
	-- upvalues: t204 (copy), t1 (copy)
	local v1620 = t204.new()

	if t207.action_type ~= nil then
		v1620.action_type = if typeof(t207.action_type) ~= "number" then t1.ActionType.fromName(t207.action_type) or t207.action_type else t1.ActionType.fromNumber(t207.action_type) or t207.action_type
	end

	if t207.actionType ~= nil then
		v1620.action_type = if typeof(t207.actionType) ~= "number" then t1.ActionType.fromName(t207.actionType) or t207.actionType else t1.ActionType.fromNumber(t207.actionType) or t207.actionType
	end

	if t207.action_params ~= nil then
		v1620.action_params = t1.OpenMarketplaceCatalogSeeAll_Params.jsonDecode(t207.action_params)
	end

	if t207.actionParams ~= nil then
		v1620.action_params = t1.OpenMarketplaceCatalogSeeAll_Params.jsonDecode(t207.actionParams)
	end

	return v1620
end

t204.descriptor = {
	name = "OpenMarketplaceCatalogSeeAll",
	fullName = "roblox.apppageplatform.shared.v1beta1.OpenMarketplaceCatalogSeeAll"
}
t1.OpenMarketplaceCatalogSeeAll = t204
typeRegistry.default:register(t1.OpenMarketplaceCatalogSeeAll)

local t208 = {}

t208.__index = t208

function t208.new(t209: {[any]: any}?) -- line: 12689
	-- upvalues: t208 (copy)
	return (setmetatable({
		sort_id = if t209 ~= nil and t209.sort_id ~= nil then t209.sort_id else nil,
		title = if t209 ~= nil and t209.title ~= nil then t209.title else nil,
		description = if t209 ~= nil and t209.description ~= nil then t209.description else nil,
		tooltip_text = if t209 ~= nil and t209.tooltip_text ~= nil then t209.tooltip_text else nil
	}, t208))
end
function t208.encode(p157) -- line: 12700
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n103 = 0

	if p157.sort_id ~= nil then
		local v1625 = p157.sort_id:encode()
		local v1626, v1627 = proto.writeTag(buf, n103, 1, proto.wireTypes.lengthDelimited)

		buf, n103 = proto.writeBuffer(v1626, v1627, v1625, buffer.len(v1625))
	end

	if p157.title ~= nil then
		local v1628 = p157.title:encode()
		local v1629, v1630 = proto.writeTag(buf, n103, 2, proto.wireTypes.lengthDelimited)

		buf, n103 = proto.writeBuffer(v1629, v1630, v1628, buffer.len(v1628))
	end

	if p157.description ~= nil then
		local v1631 = p157.description:encode()
		local v1632, v1633 = proto.writeTag(buf, n103, 3, proto.wireTypes.lengthDelimited)

		buf, n103 = proto.writeBuffer(v1632, v1633, v1631, buffer.len(v1631))
	end

	if p157.tooltip_text ~= nil then
		local v1634 = p157.tooltip_text:encode()
		local v1635, v1636 = proto.writeTag(buf, n103, 4, proto.wireTypes.lengthDelimited)

		buf, n103 = proto.writeBuffer(v1635, v1636, v1634, buffer.len(v1634))
	end

	local buf54 = buffer.create(n103)

	buffer.copy(buf54, 0, buf, 0, n103)

	return buf54
end
function t208.decode(p158: buffer) -- line: 12733
	-- upvalues: t208 (copy), proto (copy), prop_types (copy)
	local v1639 = t208.new()
	local n104 = 0

	while n104 < buffer.len(p158) do
		local v1641, v1642

		v1641, v1642, n104 = proto.readTag(p158, n104)

		if v1642 == proto.wireTypes.varint then
			local v1643

			v1643, n104 = proto.readVarInt(p158, n104)
		elseif v1642 == proto.wireTypes.lengthDelimited then
			if v1641 == 1 then
				local v1644

				v1644, n104 = proto.readBuffer(p158, n104)
				v1639.sort_id = prop_types.StringProp.decode(v1644)
			elseif v1641 == 2 then
				local v1645

				v1645, n104 = proto.readBuffer(p158, n104)
				v1639.title = prop_types.StringProp.decode(v1645)
			elseif v1641 == 3 then
				local v1646

				v1646, n104 = proto.readBuffer(p158, n104)
				v1639.description = prop_types.StringProp.decode(v1646)
			elseif v1641 == 4 then
				local v1647

				v1647, n104 = proto.readBuffer(p158, n104)
				v1639.tooltip_text = prop_types.StringProp.decode(v1647)
			else
				local v1648, v1649 = proto.readVarInt(p158, n104)

				n104 = v1649 + v1648
			end
		elseif v1642 == proto.wireTypes.i32 then
			local v1650

			v1650, n104 = proto.readFixed32(p158, n104)
		elseif v1642 == proto.wireTypes.i64 then
			local v1651

			v1651, n104 = proto.readFixed64(p158, n104)
		else
			error("Unsupported wire type: " .. v1642)
		end
	end

	return v1639
end
function t208.jsonEncode(p159) -- line: 12791
	local t210 = {}

	if p159.sort_id ~= nil then
		t210.sortId = p159.sort_id:jsonEncode()
	end

	if p159.title ~= nil then
		t210.title = p159.title:jsonEncode()
	end

	if p159.description ~= nil then
		t210.description = p159.description:jsonEncode()
	end

	if p159.tooltip_text ~= nil then
		t210.tooltipText = p159.tooltip_text:jsonEncode()
	end

	return t210
end
function t208.jsonDecode(t211: {[any]: any}) -- line: 12813
	-- upvalues: t208 (copy), prop_types (copy)
	local v1655 = t208.new()

	if t211.sort_id ~= nil then
		v1655.sort_id = prop_types.StringProp.jsonDecode(t211.sort_id)
	end

	if t211.sortId ~= nil then
		v1655.sort_id = prop_types.StringProp.jsonDecode(t211.sortId)
	end

	if t211.title ~= nil then
		v1655.title = prop_types.StringProp.jsonDecode(t211.title)
	end

	if t211.description ~= nil then
		v1655.description = prop_types.StringProp.jsonDecode(t211.description)
	end

	if t211.tooltip_text ~= nil then
		v1655.tooltip_text = prop_types.StringProp.jsonDecode(t211.tooltip_text)
	end

	if t211.tooltipText ~= nil then
		v1655.tooltip_text = prop_types.StringProp.jsonDecode(t211.tooltipText)
	end

	return v1655
end

t208.descriptor = {
	name = "OpenMarketplaceCatalogSeeAll_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.OpenMarketplaceCatalogSeeAll_Params = t208
typeRegistry.default:register(t1.OpenMarketplaceCatalogSeeAll_Params)

local t212 = {}

t212.__index = t212

function t212.new(t213: {[any]: any}?) -- line: 12862
	-- upvalues: t1 (copy), t212 (copy)
	return (setmetatable({
		action_type = if t213 ~= nil and t213.action_type ~= nil then t213.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t213 ~= nil and t213.action_params ~= nil then t213.action_params else nil
	}, t212))
end
function t212.encode(p160) -- line: 12873
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n105 = 0

	if p160.action_type ~= nil and (p160.action_type ~= nil and p160.action_type ~= 0 or p160.action_type ~= t1.ActionType.fromNumber(0)) then
		local v1660, v1661 = proto.writeTag(buf, n105, 1, proto.wireTypes.varint)

		buf, n105 = proto.writeVarInt(v1660, v1661, t1.ActionType.toNumber(p160.action_type))
	end

	if p160.action_params ~= nil then
		local v1662 = p160.action_params:encode()
		local v1663, v1664 = proto.writeTag(buf, n105, 2, proto.wireTypes.lengthDelimited)

		buf, n105 = proto.writeBuffer(v1663, v1664, v1662, buffer.len(v1662))
	end

	local buf55 = buffer.create(n105)

	buffer.copy(buf55, 0, buf, 0, n105)

	return buf55
end
function t212.decode(p161: buffer) -- line: 12899
	-- upvalues: t212 (copy), proto (copy), t1 (copy)
	local v1667 = t212.new()
	local n106 = 0

	while n106 < buffer.len(p161) do
		local v1669, v1670

		v1669, v1670, n106 = proto.readTag(p161, n106)

		if v1670 == proto.wireTypes.varint then
			if v1669 == 1 then
				local v1671

				v1671, n106 = proto.readVarIntI32(p161, n106)
				v1667.action_type = t1.ActionType.fromNumber(v1671) or v1671
			else
				local v1672

				v1672, n106 = proto.readVarInt(p161, n106)
			end
		elseif v1670 == proto.wireTypes.lengthDelimited then
			if v1669 == 2 then
				local v1673

				v1673, n106 = proto.readBuffer(p161, n106)
				v1667.action_params = t1.CloseMarketplaceCategoryTooltip_Params.decode(v1673)
			else
				local v1674, v1675 = proto.readVarInt(p161, n106)

				n106 = v1675 + v1674
			end
		elseif v1670 == proto.wireTypes.i32 then
			local v1676

			v1676, n106 = proto.readFixed32(p161, n106)
		elseif v1670 == proto.wireTypes.i64 then
			local v1677

			v1677, n106 = proto.readFixed64(p161, n106)
		else
			error("Unsupported wire type: " .. v1670)
		end
	end

	return v1667
end
function t212.jsonEncode(p162) -- line: 12947
	-- upvalues: t1 (copy)
	local t214 = {}

	if p162.action_type ~= nil and (p162.action_type ~= nil and p162.action_type ~= 0 or p162.action_type ~= t1.ActionType.fromNumber(0)) then
		t214.actionType = if typeof(p162.action_type) ~= "number" then t1.ActionType.toNumber(p162.action_type) else p162.action_type
	end

	if p162.action_params ~= nil then
		t214.actionParams = p162.action_params:jsonEncode()
	end

	return t214
end
function t212.jsonDecode(t215: {[any]: any}) -- line: 12969
	-- upvalues: t212 (copy), t1 (copy)
	local v1681 = t212.new()

	if t215.action_type ~= nil then
		v1681.action_type = if typeof(t215.action_type) ~= "number" then t1.ActionType.fromName(t215.action_type) or t215.action_type else t1.ActionType.fromNumber(t215.action_type) or t215.action_type
	end

	if t215.actionType ~= nil then
		v1681.action_type = if typeof(t215.actionType) ~= "number" then t1.ActionType.fromName(t215.actionType) or t215.actionType else t1.ActionType.fromNumber(t215.actionType) or t215.actionType
	end

	if t215.action_params ~= nil then
		v1681.action_params = t1.CloseMarketplaceCategoryTooltip_Params.jsonDecode(t215.action_params)
	end

	if t215.actionParams ~= nil then
		v1681.action_params = t1.CloseMarketplaceCategoryTooltip_Params.jsonDecode(t215.actionParams)
	end

	return v1681
end

t212.descriptor = {
	name = "CloseMarketplaceCategoryTooltip",
	fullName = "roblox.apppageplatform.shared.v1beta1.CloseMarketplaceCategoryTooltip"
}
t1.CloseMarketplaceCategoryTooltip = t212
typeRegistry.default:register(t1.CloseMarketplaceCategoryTooltip)

local t216 = {}

t216.__index = t216

function t216.new(t217: {[any]: any}?) -- line: 13009
	-- upvalues: t216 (copy)
	return (setmetatable({
		tooltip_id = if t217 ~= nil and t217.tooltip_id ~= nil then t217.tooltip_id else nil
	}, t216))
end
function t216.encode(p163) -- line: 13017
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n107 = 0

	if p163.tooltip_id ~= nil then
		local v1686 = p163.tooltip_id:encode()
		local v1687, v1688 = proto.writeTag(buf, n107, 1, proto.wireTypes.lengthDelimited)

		buf, n107 = proto.writeBuffer(v1687, v1688, v1686, buffer.len(v1686))
	end

	local buf56 = buffer.create(n107)

	buffer.copy(buf56, 0, buf, 0, n107)

	return buf56
end
function t216.decode(p164: buffer) -- line: 13032
	-- upvalues: t216 (copy), proto (copy), prop_types (copy)
	local v1691 = t216.new()
	local n108 = 0

	while n108 < buffer.len(p164) do
		local v1693, v1694

		v1693, v1694, n108 = proto.readTag(p164, n108)

		if v1694 == proto.wireTypes.varint then
			local v1695

			v1695, n108 = proto.readVarInt(p164, n108)
		elseif v1694 == proto.wireTypes.lengthDelimited then
			if v1693 == 1 then
				local v1696

				v1696, n108 = proto.readBuffer(p164, n108)
				v1691.tooltip_id = prop_types.StringProp.decode(v1696)
			else
				local v1697, v1698 = proto.readVarInt(p164, n108)

				n108 = v1698 + v1697
			end
		elseif v1694 == proto.wireTypes.i32 then
			local v1699

			v1699, n108 = proto.readFixed32(p164, n108)
		elseif v1694 == proto.wireTypes.i64 then
			local v1700

			v1700, n108 = proto.readFixed64(p164, n108)
		else
			error("Unsupported wire type: " .. v1694)
		end
	end

	return v1691
end
function t216.jsonEncode(p165) -- line: 13075
	local t218 = {}

	if p165.tooltip_id ~= nil then
		t218.tooltipId = p165.tooltip_id:jsonEncode()
	end

	return t218
end
function t216.jsonDecode(t219: {[any]: any}) -- line: 13085
	-- upvalues: t216 (copy), prop_types (copy)
	local v1704 = t216.new()

	if t219.tooltip_id ~= nil then
		v1704.tooltip_id = prop_types.StringProp.jsonDecode(t219.tooltip_id)
	end

	if t219.tooltipId ~= nil then
		v1704.tooltip_id = prop_types.StringProp.jsonDecode(t219.tooltipId)
	end

	return v1704
end

t216.descriptor = {
	name = "CloseMarketplaceCategoryTooltip_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.CloseMarketplaceCategoryTooltip_Params = t216
typeRegistry.default:register(t1.CloseMarketplaceCategoryTooltip_Params)

local t220 = {}

t220.__index = t220

function t220.new(t221: {[any]: any}?) -- line: 13115
	-- upvalues: t1 (copy), t220 (copy)
	return (setmetatable({
		action_type = if t221 ~= nil and t221.action_type ~= nil then t221.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t221 ~= nil and t221.action_params ~= nil then t221.action_params else nil
	}, t220))
end
function t220.encode(p166) -- line: 13124
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n109 = 0

	if p166.action_type ~= nil and (p166.action_type ~= nil and p166.action_type ~= 0 or p166.action_type ~= t1.ActionType.fromNumber(0)) then
		local v1709, v1710 = proto.writeTag(buf, n109, 1, proto.wireTypes.varint)

		buf, n109 = proto.writeVarInt(v1709, v1710, t1.ActionType.toNumber(p166.action_type))
	end

	if p166.action_params ~= nil then
		local v1711 = p166.action_params:encode()
		local v1712, v1713 = proto.writeTag(buf, n109, 2, proto.wireTypes.lengthDelimited)

		buf, n109 = proto.writeBuffer(v1712, v1713, v1711, buffer.len(v1711))
	end

	local buf57 = buffer.create(n109)

	buffer.copy(buf57, 0, buf, 0, n109)

	return buf57
end
function t220.decode(p167: buffer) -- line: 13150
	-- upvalues: t220 (copy), proto (copy), t1 (copy)
	local v1716 = t220.new()
	local n110 = 0

	while n110 < buffer.len(p167) do
		local v1718, v1719

		v1718, v1719, n110 = proto.readTag(p167, n110)

		if v1719 == proto.wireTypes.varint then
			if v1718 == 1 then
				local v1720

				v1720, n110 = proto.readVarIntI32(p167, n110)
				v1716.action_type = t1.ActionType.fromNumber(v1720) or v1720
			else
				local v1721

				v1721, n110 = proto.readVarInt(p167, n110)
			end
		elseif v1719 == proto.wireTypes.lengthDelimited then
			if v1718 == 2 then
				local v1722

				v1722, n110 = proto.readBuffer(p167, n110)
				v1716.action_params = t1.ResizeMarketplaceCatalog_Params.decode(v1722)
			else
				local v1723, v1724 = proto.readVarInt(p167, n110)

				n110 = v1724 + v1723
			end
		elseif v1719 == proto.wireTypes.i32 then
			local v1725

			v1725, n110 = proto.readFixed32(p167, n110)
		elseif v1719 == proto.wireTypes.i64 then
			local v1726

			v1726, n110 = proto.readFixed64(p167, n110)
		else
			error("Unsupported wire type: " .. v1719)
		end
	end

	return v1716
end
function t220.jsonEncode(p168) -- line: 13198
	-- upvalues: t1 (copy)
	local t222 = {}

	if p168.action_type ~= nil and (p168.action_type ~= nil and p168.action_type ~= 0 or p168.action_type ~= t1.ActionType.fromNumber(0)) then
		t222.actionType = if typeof(p168.action_type) ~= "number" then t1.ActionType.toNumber(p168.action_type) else p168.action_type
	end

	if p168.action_params ~= nil then
		t222.actionParams = p168.action_params:jsonEncode()
	end

	return t222
end
function t220.jsonDecode(t223: {[any]: any}) -- line: 13220
	-- upvalues: t220 (copy), t1 (copy)
	local v1730 = t220.new()

	if t223.action_type ~= nil then
		v1730.action_type = if typeof(t223.action_type) ~= "number" then t1.ActionType.fromName(t223.action_type) or t223.action_type else t1.ActionType.fromNumber(t223.action_type) or t223.action_type
	end

	if t223.actionType ~= nil then
		v1730.action_type = if typeof(t223.actionType) ~= "number" then t1.ActionType.fromName(t223.actionType) or t223.actionType else t1.ActionType.fromNumber(t223.actionType) or t223.actionType
	end

	if t223.action_params ~= nil then
		v1730.action_params = t1.ResizeMarketplaceCatalog_Params.jsonDecode(t223.action_params)
	end

	if t223.actionParams ~= nil then
		v1730.action_params = t1.ResizeMarketplaceCatalog_Params.jsonDecode(t223.actionParams)
	end

	return v1730
end

t220.descriptor = {
	name = "ResizeMarketplaceCatalog",
	fullName = "roblox.apppageplatform.shared.v1beta1.ResizeMarketplaceCatalog"
}
t1.ResizeMarketplaceCatalog = t220
typeRegistry.default:register(t1.ResizeMarketplaceCatalog)

local t224 = {}

t224.__index = t224

function t224.new(t225: {[any]: any}?) -- line: 13260
	-- upvalues: t224 (copy)
	return (setmetatable({
		category_id = if t225 ~= nil and t225.category_id ~= nil then t225.category_id else nil,
		subcategory_id = if t225 ~= nil and t225.subcategory_id ~= nil then t225.subcategory_id else nil,
		screen_size = if t225 ~= nil and t225.screen_size ~= nil then t225.screen_size else nil
	}, t224))
end
function t224.encode(p169) -- line: 13270
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n111 = 0

	if p169.category_id ~= nil then
		local v1735 = p169.category_id:encode()
		local v1736, v1737 = proto.writeTag(buf, n111, 1, proto.wireTypes.lengthDelimited)

		buf, n111 = proto.writeBuffer(v1736, v1737, v1735, buffer.len(v1735))
	end

	if p169.subcategory_id ~= nil then
		local v1738 = p169.subcategory_id:encode()
		local v1739, v1740 = proto.writeTag(buf, n111, 2, proto.wireTypes.lengthDelimited)

		buf, n111 = proto.writeBuffer(v1739, v1740, v1738, buffer.len(v1738))
	end

	if p169.screen_size ~= nil then
		local v1741 = p169.screen_size:encode()
		local v1742, v1743 = proto.writeTag(buf, n111, 3, proto.wireTypes.lengthDelimited)

		buf, n111 = proto.writeBuffer(v1742, v1743, v1741, buffer.len(v1741))
	end

	local buf58 = buffer.create(n111)

	buffer.copy(buf58, 0, buf, 0, n111)

	return buf58
end
function t224.decode(p170: buffer) -- line: 13297
	-- upvalues: t224 (copy), proto (copy), prop_types (copy)
	local v1746 = t224.new()
	local n112 = 0

	while n112 < buffer.len(p170) do
		local v1748, v1749

		v1748, v1749, n112 = proto.readTag(p170, n112)

		if v1749 == proto.wireTypes.varint then
			local v1750

			v1750, n112 = proto.readVarInt(p170, n112)
		elseif v1749 == proto.wireTypes.lengthDelimited then
			if v1748 == 1 then
				local v1751

				v1751, n112 = proto.readBuffer(p170, n112)
				v1746.category_id = prop_types.StringProp.decode(v1751)
			elseif v1748 == 2 then
				local v1752

				v1752, n112 = proto.readBuffer(p170, n112)
				v1746.subcategory_id = prop_types.StringProp.decode(v1752)
			elseif v1748 == 3 then
				local v1753

				v1753, n112 = proto.readBuffer(p170, n112)
				v1746.screen_size = prop_types.StringProp.decode(v1753)
			else
				local v1754, v1755 = proto.readVarInt(p170, n112)

				n112 = v1755 + v1754
			end
		elseif v1749 == proto.wireTypes.i32 then
			local v1756

			v1756, n112 = proto.readFixed32(p170, n112)
		elseif v1749 == proto.wireTypes.i64 then
			local v1757

			v1757, n112 = proto.readFixed64(p170, n112)
		else
			error("Unsupported wire type: " .. v1749)
		end
	end

	return v1746
end
function t224.jsonEncode(p171) -- line: 13350
	local t226 = {}

	if p171.category_id ~= nil then
		t226.categoryId = p171.category_id:jsonEncode()
	end

	if p171.subcategory_id ~= nil then
		t226.subcategoryId = p171.subcategory_id:jsonEncode()
	end

	if p171.screen_size ~= nil then
		t226.screenSize = p171.screen_size:jsonEncode()
	end

	return t226
end
function t224.jsonDecode(t227: {[any]: any}) -- line: 13368
	-- upvalues: t224 (copy), prop_types (copy)
	local v1761 = t224.new()

	if t227.category_id ~= nil then
		v1761.category_id = prop_types.StringProp.jsonDecode(t227.category_id)
	end

	if t227.categoryId ~= nil then
		v1761.category_id = prop_types.StringProp.jsonDecode(t227.categoryId)
	end

	if t227.subcategory_id ~= nil then
		v1761.subcategory_id = prop_types.StringProp.jsonDecode(t227.subcategory_id)
	end

	if t227.subcategoryId ~= nil then
		v1761.subcategory_id = prop_types.StringProp.jsonDecode(t227.subcategoryId)
	end

	if t227.screen_size ~= nil then
		v1761.screen_size = prop_types.StringProp.jsonDecode(t227.screen_size)
	end

	if t227.screenSize ~= nil then
		v1761.screen_size = prop_types.StringProp.jsonDecode(t227.screenSize)
	end

	return v1761
end

t224.descriptor = {
	name = "ResizeMarketplaceCatalog_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.ResizeMarketplaceCatalog_Params = t224
typeRegistry.default:register(t1.ResizeMarketplaceCatalog_Params)

local t228 = {}

t228.__index = t228

function t228.new(t229: {[any]: any}?) -- line: 13416
	-- upvalues: t1 (copy), t228 (copy)
	return (setmetatable({
		action_type = if t229 ~= nil and t229.action_type ~= nil then t229.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t229 ~= nil and t229.action_params ~= nil then t229.action_params else nil
	}, t228))
end
function t228.encode(p172) -- line: 13427
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n113 = 0

	if p172.action_type ~= nil and (p172.action_type ~= nil and p172.action_type ~= 0 or p172.action_type ~= t1.ActionType.fromNumber(0)) then
		local v1766, v1767 = proto.writeTag(buf, n113, 1, proto.wireTypes.varint)

		buf, n113 = proto.writeVarInt(v1766, v1767, t1.ActionType.toNumber(p172.action_type))
	end

	if p172.action_params ~= nil then
		local v1768 = p172.action_params:encode()
		local v1769, v1770 = proto.writeTag(buf, n113, 2, proto.wireTypes.lengthDelimited)

		buf, n113 = proto.writeBuffer(v1769, v1770, v1768, buffer.len(v1768))
	end

	local buf59 = buffer.create(n113)

	buffer.copy(buf59, 0, buf, 0, n113)

	return buf59
end
function t228.decode(p173: buffer) -- line: 13453
	-- upvalues: t228 (copy), proto (copy), t1 (copy)
	local v1773 = t228.new()
	local n114 = 0

	while n114 < buffer.len(p173) do
		local v1775, v1776

		v1775, v1776, n114 = proto.readTag(p173, n114)

		if v1776 == proto.wireTypes.varint then
			if v1775 == 1 then
				local v1777

				v1777, n114 = proto.readVarIntI32(p173, n114)
				v1773.action_type = t1.ActionType.fromNumber(v1777) or v1777
			else
				local v1778

				v1778, n114 = proto.readVarInt(p173, n114)
			end
		elseif v1776 == proto.wireTypes.lengthDelimited then
			if v1775 == 2 then
				local v1779

				v1779, n114 = proto.readBuffer(p173, n114)
				v1773.action_params = t1.OpenChartsSortDetailAction_Params.decode(v1779)
			else
				local v1780, v1781 = proto.readVarInt(p173, n114)

				n114 = v1781 + v1780
			end
		elseif v1776 == proto.wireTypes.i32 then
			local v1782

			v1782, n114 = proto.readFixed32(p173, n114)
		elseif v1776 == proto.wireTypes.i64 then
			local v1783

			v1783, n114 = proto.readFixed64(p173, n114)
		else
			error("Unsupported wire type: " .. v1776)
		end
	end

	return v1773
end
function t228.jsonEncode(p174) -- line: 13501
	-- upvalues: t1 (copy)
	local t230 = {}

	if p174.action_type ~= nil and (p174.action_type ~= nil and p174.action_type ~= 0 or p174.action_type ~= t1.ActionType.fromNumber(0)) then
		t230.actionType = if typeof(p174.action_type) ~= "number" then t1.ActionType.toNumber(p174.action_type) else p174.action_type
	end

	if p174.action_params ~= nil then
		t230.actionParams = p174.action_params:jsonEncode()
	end

	return t230
end
function t228.jsonDecode(t231: {[any]: any}) -- line: 13523
	-- upvalues: t228 (copy), t1 (copy)
	local v1787 = t228.new()

	if t231.action_type ~= nil then
		v1787.action_type = if typeof(t231.action_type) ~= "number" then t1.ActionType.fromName(t231.action_type) or t231.action_type else t1.ActionType.fromNumber(t231.action_type) or t231.action_type
	end

	if t231.actionType ~= nil then
		v1787.action_type = if typeof(t231.actionType) ~= "number" then t1.ActionType.fromName(t231.actionType) or t231.actionType else t1.ActionType.fromNumber(t231.actionType) or t231.actionType
	end

	if t231.action_params ~= nil then
		v1787.action_params = t1.OpenChartsSortDetailAction_Params.jsonDecode(t231.action_params)
	end

	if t231.actionParams ~= nil then
		v1787.action_params = t1.OpenChartsSortDetailAction_Params.jsonDecode(t231.actionParams)
	end

	return v1787
end

t228.descriptor = {
	name = "OpenChartsSortDetailAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.OpenChartsSortDetailAction"
}
t1.OpenChartsSortDetailAction = t228
typeRegistry.default:register(t1.OpenChartsSortDetailAction)

local t232 = {}

t232.__index = t232

function t232.new(t233: {[any]: any}?) -- line: 13563
	-- upvalues: t232 (copy)
	return (setmetatable({
		sort_id = if t233 ~= nil and t233.sort_id ~= nil then t233.sort_id else nil,
		secondary_sort_id = if t233 ~= nil and t233.secondary_sort_id ~= nil then t233.secondary_sort_id else nil
	}, t232))
end
function t232.encode(p175) -- line: 13572
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n115 = 0

	if p175.sort_id ~= nil then
		local v1792 = p175.sort_id:encode()
		local v1793, v1794 = proto.writeTag(buf, n115, 1, proto.wireTypes.lengthDelimited)

		buf, n115 = proto.writeBuffer(v1793, v1794, v1792, buffer.len(v1792))
	end

	if p175.secondary_sort_id ~= nil then
		local v1795 = p175.secondary_sort_id:encode()
		local v1796, v1797 = proto.writeTag(buf, n115, 2, proto.wireTypes.lengthDelimited)

		buf, n115 = proto.writeBuffer(v1796, v1797, v1795, buffer.len(v1795))
	end

	local buf60 = buffer.create(n115)

	buffer.copy(buf60, 0, buf, 0, n115)

	return buf60
end
function t232.decode(p176: buffer) -- line: 13593
	-- upvalues: t232 (copy), proto (copy), prop_types (copy)
	local v1800 = t232.new()
	local n116 = 0

	while n116 < buffer.len(p176) do
		local v1802, v1803

		v1802, v1803, n116 = proto.readTag(p176, n116)

		if v1803 == proto.wireTypes.varint then
			local v1804

			v1804, n116 = proto.readVarInt(p176, n116)
		elseif v1803 == proto.wireTypes.lengthDelimited then
			if v1802 == 1 then
				local v1805

				v1805, n116 = proto.readBuffer(p176, n116)
				v1800.sort_id = prop_types.StringProp.decode(v1805)
			elseif v1802 == 2 then
				local v1806

				v1806, n116 = proto.readBuffer(p176, n116)
				v1800.secondary_sort_id = prop_types.Int32Prop.decode(v1806)
			else
				local v1807, v1808 = proto.readVarInt(p176, n116)

				n116 = v1808 + v1807
			end
		elseif v1803 == proto.wireTypes.i32 then
			local v1809

			v1809, n116 = proto.readFixed32(p176, n116)
		elseif v1803 == proto.wireTypes.i64 then
			local v1810

			v1810, n116 = proto.readFixed64(p176, n116)
		else
			error("Unsupported wire type: " .. v1803)
		end
	end

	return v1800
end
function t232.jsonEncode(p177) -- line: 13641
	local t234 = {}

	if p177.sort_id ~= nil then
		t234.sortId = p177.sort_id:jsonEncode()
	end

	if p177.secondary_sort_id ~= nil then
		t234.secondarySortId = p177.secondary_sort_id:jsonEncode()
	end

	return t234
end
function t232.jsonDecode(t235: {[any]: any}) -- line: 13655
	-- upvalues: t232 (copy), prop_types (copy)
	local v1814 = t232.new()

	if t235.sort_id ~= nil then
		v1814.sort_id = prop_types.StringProp.jsonDecode(t235.sort_id)
	end

	if t235.sortId ~= nil then
		v1814.sort_id = prop_types.StringProp.jsonDecode(t235.sortId)
	end

	if t235.secondary_sort_id ~= nil then
		v1814.secondary_sort_id = prop_types.Int32Prop.jsonDecode(t235.secondary_sort_id)
	end

	if t235.secondarySortId ~= nil then
		v1814.secondary_sort_id = prop_types.Int32Prop.jsonDecode(t235.secondarySortId)
	end

	return v1814
end

t232.descriptor = {
	name = "OpenChartsSortDetailAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.OpenChartsSortDetailAction_Params = t232
typeRegistry.default:register(t1.OpenChartsSortDetailAction_Params)

local t236 = {}

t236.__index = t236

function t236.new(t237: {[any]: any}?) -- line: 13695
	-- upvalues: t1 (copy), t236 (copy)
	return (setmetatable({
		action_type = if t237 ~= nil and t237.action_type ~= nil then t237.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t237 ~= nil and t237.action_params ~= nil then t237.action_params else nil
	}, t236))
end
function t236.encode(p178) -- line: 13704
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n117 = 0

	if p178.action_type ~= nil and (p178.action_type ~= nil and p178.action_type ~= 0 or p178.action_type ~= t1.ActionType.fromNumber(0)) then
		local v1819, v1820 = proto.writeTag(buf, n117, 1, proto.wireTypes.varint)

		buf, n117 = proto.writeVarInt(v1819, v1820, t1.ActionType.toNumber(p178.action_type))
	end

	if p178.action_params ~= nil then
		local v1821 = p178.action_params:encode()
		local v1822, v1823 = proto.writeTag(buf, n117, 2, proto.wireTypes.lengthDelimited)

		buf, n117 = proto.writeBuffer(v1822, v1823, v1821, buffer.len(v1821))
	end

	local buf61 = buffer.create(n117)

	buffer.copy(buf61, 0, buf, 0, n117)

	return buf61
end
function t236.decode(p179: buffer) -- line: 13730
	-- upvalues: t236 (copy), proto (copy), t1 (copy)
	local v1826 = t236.new()
	local n118 = 0

	while n118 < buffer.len(p179) do
		local v1828, v1829

		v1828, v1829, n118 = proto.readTag(p179, n118)

		if v1829 == proto.wireTypes.varint then
			if v1828 == 1 then
				local v1830

				v1830, n118 = proto.readVarIntI32(p179, n118)
				v1826.action_type = t1.ActionType.fromNumber(v1830) or v1830
			else
				local v1831

				v1831, n118 = proto.readVarInt(p179, n118)
			end
		elseif v1829 == proto.wireTypes.lengthDelimited then
			if v1828 == 2 then
				local v1832

				v1832, n118 = proto.readBuffer(p179, n118)
				v1826.action_params = t1.OpenSongDetailAction_Params.decode(v1832)
			else
				local v1833, v1834 = proto.readVarInt(p179, n118)

				n118 = v1834 + v1833
			end
		elseif v1829 == proto.wireTypes.i32 then
			local v1835

			v1835, n118 = proto.readFixed32(p179, n118)
		elseif v1829 == proto.wireTypes.i64 then
			local v1836

			v1836, n118 = proto.readFixed64(p179, n118)
		else
			error("Unsupported wire type: " .. v1829)
		end
	end

	return v1826
end
function t236.jsonEncode(p180) -- line: 13778
	-- upvalues: t1 (copy)
	local t238 = {}

	if p180.action_type ~= nil and (p180.action_type ~= nil and p180.action_type ~= 0 or p180.action_type ~= t1.ActionType.fromNumber(0)) then
		t238.actionType = if typeof(p180.action_type) ~= "number" then t1.ActionType.toNumber(p180.action_type) else p180.action_type
	end

	if p180.action_params ~= nil then
		t238.actionParams = p180.action_params:jsonEncode()
	end

	return t238
end
function t236.jsonDecode(t239: {[any]: any}) -- line: 13800
	-- upvalues: t236 (copy), t1 (copy)
	local v1840 = t236.new()

	if t239.action_type ~= nil then
		v1840.action_type = if typeof(t239.action_type) ~= "number" then t1.ActionType.fromName(t239.action_type) or t239.action_type else t1.ActionType.fromNumber(t239.action_type) or t239.action_type
	end

	if t239.actionType ~= nil then
		v1840.action_type = if typeof(t239.actionType) ~= "number" then t1.ActionType.fromName(t239.actionType) or t239.actionType else t1.ActionType.fromNumber(t239.actionType) or t239.actionType
	end

	if t239.action_params ~= nil then
		v1840.action_params = t1.OpenSongDetailAction_Params.jsonDecode(t239.action_params)
	end

	if t239.actionParams ~= nil then
		v1840.action_params = t1.OpenSongDetailAction_Params.jsonDecode(t239.actionParams)
	end

	return v1840
end

t236.descriptor = {
	name = "OpenSongDetailAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.OpenSongDetailAction"
}
t1.OpenSongDetailAction = t236
typeRegistry.default:register(t1.OpenSongDetailAction)

local t240 = {}

t240.__index = t240

function t240.new(t241: {[any]: any}?) -- line: 13840
	-- upvalues: t240 (copy)
	return (setmetatable({
		song_id = if t241 ~= nil and t241.song_id ~= nil then t241.song_id else nil
	}, t240))
end
function t240.encode(p181) -- line: 13848
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n119 = 0

	if p181.song_id ~= nil then
		local v1845 = p181.song_id:encode()
		local v1846, v1847 = proto.writeTag(buf, n119, 1, proto.wireTypes.lengthDelimited)

		buf, n119 = proto.writeBuffer(v1846, v1847, v1845, buffer.len(v1845))
	end

	local buf62 = buffer.create(n119)

	buffer.copy(buf62, 0, buf, 0, n119)

	return buf62
end
function t240.decode(p182: buffer) -- line: 13863
	-- upvalues: t240 (copy), proto (copy), prop_types (copy)
	local v1850 = t240.new()
	local n120 = 0

	while n120 < buffer.len(p182) do
		local v1852, v1853

		v1852, v1853, n120 = proto.readTag(p182, n120)

		if v1853 == proto.wireTypes.varint then
			local v1854

			v1854, n120 = proto.readVarInt(p182, n120)
		elseif v1853 == proto.wireTypes.lengthDelimited then
			if v1852 == 1 then
				local v1855

				v1855, n120 = proto.readBuffer(p182, n120)
				v1850.song_id = prop_types.StringProp.decode(v1855)
			else
				local v1856, v1857 = proto.readVarInt(p182, n120)

				n120 = v1857 + v1856
			end
		elseif v1853 == proto.wireTypes.i32 then
			local v1858

			v1858, n120 = proto.readFixed32(p182, n120)
		elseif v1853 == proto.wireTypes.i64 then
			local v1859

			v1859, n120 = proto.readFixed64(p182, n120)
		else
			error("Unsupported wire type: " .. v1853)
		end
	end

	return v1850
end
function t240.jsonEncode(p183) -- line: 13906
	local t242 = {}

	if p183.song_id ~= nil then
		t242.songId = p183.song_id:jsonEncode()
	end

	return t242
end
function t240.jsonDecode(t243: {[any]: any}) -- line: 13916
	-- upvalues: t240 (copy), prop_types (copy)
	local v1863 = t240.new()

	if t243.song_id ~= nil then
		v1863.song_id = prop_types.StringProp.jsonDecode(t243.song_id)
	end

	if t243.songId ~= nil then
		v1863.song_id = prop_types.StringProp.jsonDecode(t243.songId)
	end

	return v1863
end

t240.descriptor = {
	name = "OpenSongDetailAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.OpenSongDetailAction_Params = t240
typeRegistry.default:register(t1.OpenSongDetailAction_Params)

local t244 = {}

t244.__index = t244

function t244.new(t245: {[any]: any}?) -- line: 13944
	-- upvalues: t1 (copy), t244 (copy)
	return (setmetatable({
		action_type = if t245 ~= nil and t245.action_type ~= nil then t245.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t245 ~= nil and t245.action_params ~= nil then t245.action_params else nil
	}, t244))
end
function t244.encode(p184) -- line: 13955
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n121 = 0

	if p184.action_type ~= nil and (p184.action_type ~= nil and p184.action_type ~= 0 or p184.action_type ~= t1.ActionType.fromNumber(0)) then
		local v1868, v1869 = proto.writeTag(buf, n121, 1, proto.wireTypes.varint)

		buf, n121 = proto.writeVarInt(v1868, v1869, t1.ActionType.toNumber(p184.action_type))
	end

	if p184.action_params ~= nil then
		local v1870 = p184.action_params:encode()
		local v1871, v1872 = proto.writeTag(buf, n121, 2, proto.wireTypes.lengthDelimited)

		buf, n121 = proto.writeBuffer(v1871, v1872, v1870, buffer.len(v1870))
	end

	local buf63 = buffer.create(n121)

	buffer.copy(buf63, 0, buf, 0, n121)

	return buf63
end
function t244.decode(p185: buffer) -- line: 13981
	-- upvalues: t244 (copy), proto (copy), t1 (copy)
	local v1875 = t244.new()
	local n122 = 0

	while n122 < buffer.len(p185) do
		local v1877, v1878

		v1877, v1878, n122 = proto.readTag(p185, n122)

		if v1878 == proto.wireTypes.varint then
			if v1877 == 1 then
				local v1879

				v1879, n122 = proto.readVarIntI32(p185, n122)
				v1875.action_type = t1.ActionType.fromNumber(v1879) or v1879
			else
				local v1880

				v1880, n122 = proto.readVarInt(p185, n122)
			end
		elseif v1878 == proto.wireTypes.lengthDelimited then
			if v1877 == 2 then
				local v1881

				v1881, n122 = proto.readBuffer(p185, n122)
				v1875.action_params = t1.OpenMarketplaceCatalogFilters_Params.decode(v1881)
			else
				local v1882, v1883 = proto.readVarInt(p185, n122)

				n122 = v1883 + v1882
			end
		elseif v1878 == proto.wireTypes.i32 then
			local v1884

			v1884, n122 = proto.readFixed32(p185, n122)
		elseif v1878 == proto.wireTypes.i64 then
			local v1885

			v1885, n122 = proto.readFixed64(p185, n122)
		else
			error("Unsupported wire type: " .. v1878)
		end
	end

	return v1875
end
function t244.jsonEncode(p186) -- line: 14029
	-- upvalues: t1 (copy)
	local t246 = {}

	if p186.action_type ~= nil and (p186.action_type ~= nil and p186.action_type ~= 0 or p186.action_type ~= t1.ActionType.fromNumber(0)) then
		t246.actionType = if typeof(p186.action_type) ~= "number" then t1.ActionType.toNumber(p186.action_type) else p186.action_type
	end

	if p186.action_params ~= nil then
		t246.actionParams = p186.action_params:jsonEncode()
	end

	return t246
end
function t244.jsonDecode(t247: {[any]: any}) -- line: 14051
	-- upvalues: t244 (copy), t1 (copy)
	local v1889 = t244.new()

	if t247.action_type ~= nil then
		v1889.action_type = if typeof(t247.action_type) ~= "number" then t1.ActionType.fromName(t247.action_type) or t247.action_type else t1.ActionType.fromNumber(t247.action_type) or t247.action_type
	end

	if t247.actionType ~= nil then
		v1889.action_type = if typeof(t247.actionType) ~= "number" then t1.ActionType.fromName(t247.actionType) or t247.actionType else t1.ActionType.fromNumber(t247.actionType) or t247.actionType
	end

	if t247.action_params ~= nil then
		v1889.action_params = t1.OpenMarketplaceCatalogFilters_Params.jsonDecode(t247.action_params)
	end

	if t247.actionParams ~= nil then
		v1889.action_params = t1.OpenMarketplaceCatalogFilters_Params.jsonDecode(t247.actionParams)
	end

	return v1889
end

t244.descriptor = {
	name = "OpenMarketplaceCatalogFilters",
	fullName = "roblox.apppageplatform.shared.v1beta1.OpenMarketplaceCatalogFilters"
}
t1.OpenMarketplaceCatalogFilters = t244
typeRegistry.default:register(t1.OpenMarketplaceCatalogFilters)

local t248 = {}

t248.__index = t248

function t248.new(_: {[any]: any}?) -- line: 14091
	-- upvalues: t248 (copy)
	return (setmetatable({}, t248))
end
function t248.encode(_) -- line: 14097
	local buf = buffer.create(0)
	local buf64 = buffer.create(0)

	buffer.copy(buf64, 0, buf, 0, 0)

	return buf64
end
function t248.decode(p188: buffer) -- line: 14106
	-- upvalues: t248 (copy), proto (copy)
	local v1895 = t248.new()
	local n123 = 0

	while n123 < buffer.len(p188) do
		local v1897, v1898

		v1897, v1898, n123 = proto.readTag(p188, n123)

		if v1898 == proto.wireTypes.varint then
			local v1899

			v1899, n123 = proto.readVarInt(p188, n123)
		elseif v1898 == proto.wireTypes.lengthDelimited then
			local v1900, v1901 = proto.readVarInt(p188, n123)

			n123 = v1901 + v1900
		elseif v1898 == proto.wireTypes.i32 then
			local v1902

			v1902, n123 = proto.readFixed32(p188, n123)
		elseif v1898 == proto.wireTypes.i64 then
			local v1903

			v1903, n123 = proto.readFixed64(p188, n123)
		else
			error("Unsupported wire type: " .. v1898)
		end
	end

	return v1895
end
function t248.jsonEncode(_) -- line: 14144
	return {}
end
function t248.jsonDecode(_: {[any]: any}) -- line: 14150
	-- upvalues: t248 (copy)
	return (t248.new())
end

t248.descriptor = {
	name = "OpenMarketplaceCatalogFilters_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.OpenMarketplaceCatalogFilters_Params = t248
typeRegistry.default:register(t1.OpenMarketplaceCatalogFilters_Params)

local t251 = {}

t251.__index = t251

function t251.new(t252: {[any]: any}?) -- line: 14172
	-- upvalues: t1 (copy), t251 (copy)
	return (setmetatable({
		action_type = if t252 ~= nil and t252.action_type ~= nil then t252.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t252 ~= nil and t252.action_params ~= nil then t252.action_params else nil
	}, t251))
end
function t251.encode(p190) -- line: 14181
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n124 = 0

	if p190.action_type ~= nil and (p190.action_type ~= nil and p190.action_type ~= 0 or p190.action_type ~= t1.ActionType.fromNumber(0)) then
		local v1910, v1911 = proto.writeTag(buf, n124, 1, proto.wireTypes.varint)

		buf, n124 = proto.writeVarInt(v1910, v1911, t1.ActionType.toNumber(p190.action_type))
	end

	if p190.action_params ~= nil then
		local v1912 = p190.action_params:encode()
		local v1913, v1914 = proto.writeTag(buf, n124, 2, proto.wireTypes.lengthDelimited)

		buf, n124 = proto.writeBuffer(v1913, v1914, v1912, buffer.len(v1912))
	end

	local buf65 = buffer.create(n124)

	buffer.copy(buf65, 0, buf, 0, n124)

	return buf65
end
function t251.decode(p191: buffer) -- line: 14207
	-- upvalues: t251 (copy), proto (copy), t1 (copy)
	local v1917 = t251.new()
	local n125 = 0

	while n125 < buffer.len(p191) do
		local v1919, v1920

		v1919, v1920, n125 = proto.readTag(p191, n125)

		if v1920 == proto.wireTypes.varint then
			if v1919 == 1 then
				local v1921

				v1921, n125 = proto.readVarIntI32(p191, n125)
				v1917.action_type = t1.ActionType.fromNumber(v1921) or v1921
			else
				local v1922

				v1922, n125 = proto.readVarInt(p191, n125)
			end
		elseif v1920 == proto.wireTypes.lengthDelimited then
			if v1919 == 2 then
				local v1923

				v1923, n125 = proto.readBuffer(p191, n125)
				v1917.action_params = t1.RefreshFromApiAction_Params.decode(v1923)
			else
				local v1924, v1925 = proto.readVarInt(p191, n125)

				n125 = v1925 + v1924
			end
		elseif v1920 == proto.wireTypes.i32 then
			local v1926

			v1926, n125 = proto.readFixed32(p191, n125)
		elseif v1920 == proto.wireTypes.i64 then
			local v1927

			v1927, n125 = proto.readFixed64(p191, n125)
		else
			error("Unsupported wire type: " .. v1920)
		end
	end

	return v1917
end
function t251.jsonEncode(p192) -- line: 14255
	-- upvalues: t1 (copy)
	local t253 = {}

	if p192.action_type ~= nil and (p192.action_type ~= nil and p192.action_type ~= 0 or p192.action_type ~= t1.ActionType.fromNumber(0)) then
		t253.actionType = if typeof(p192.action_type) ~= "number" then t1.ActionType.toNumber(p192.action_type) else p192.action_type
	end

	if p192.action_params ~= nil then
		t253.actionParams = p192.action_params:jsonEncode()
	end

	return t253
end
function t251.jsonDecode(t254: {[any]: any}) -- line: 14277
	-- upvalues: t251 (copy), t1 (copy)
	local v1931 = t251.new()

	if t254.action_type ~= nil then
		v1931.action_type = if typeof(t254.action_type) ~= "number" then t1.ActionType.fromName(t254.action_type) or t254.action_type else t1.ActionType.fromNumber(t254.action_type) or t254.action_type
	end

	if t254.actionType ~= nil then
		v1931.action_type = if typeof(t254.actionType) ~= "number" then t1.ActionType.fromName(t254.actionType) or t254.actionType else t1.ActionType.fromNumber(t254.actionType) or t254.actionType
	end

	if t254.action_params ~= nil then
		v1931.action_params = t1.RefreshFromApiAction_Params.jsonDecode(t254.action_params)
	end

	if t254.actionParams ~= nil then
		v1931.action_params = t1.RefreshFromApiAction_Params.jsonDecode(t254.actionParams)
	end

	return v1931
end

t251.descriptor = {
	name = "RefreshFromApiAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.RefreshFromApiAction"
}
t1.RefreshFromApiAction = t251
typeRegistry.default:register(t1.RefreshFromApiAction)

local t255 = {}

t255.__index = t255

function t255.new(t256: {[any]: any}?) -- line: 14317
	-- upvalues: t255 (copy)
	return (setmetatable({
		surface_key = if t256 ~= nil and t256.surface_key ~= nil then t256.surface_key else nil,
		config_key = if t256 ~= nil and t256.config_key ~= nil then t256.config_key else nil
	}, t255))
end
function t255.encode(p193) -- line: 14326
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n126 = 0

	if p193.surface_key ~= nil then
		local v1936 = p193.surface_key:encode()
		local v1937, v1938 = proto.writeTag(buf, n126, 1, proto.wireTypes.lengthDelimited)

		buf, n126 = proto.writeBuffer(v1937, v1938, v1936, buffer.len(v1936))
	end

	if p193.config_key ~= nil then
		local v1939 = p193.config_key:encode()
		local v1940, v1941 = proto.writeTag(buf, n126, 2, proto.wireTypes.lengthDelimited)

		buf, n126 = proto.writeBuffer(v1940, v1941, v1939, buffer.len(v1939))
	end

	local buf66 = buffer.create(n126)

	buffer.copy(buf66, 0, buf, 0, n126)

	return buf66
end
function t255.decode(p194: buffer) -- line: 14347
	-- upvalues: t255 (copy), proto (copy), prop_types (copy)
	local v1944 = t255.new()
	local n127 = 0

	while n127 < buffer.len(p194) do
		local v1946, v1947

		v1946, v1947, n127 = proto.readTag(p194, n127)

		if v1947 == proto.wireTypes.varint then
			local v1948

			v1948, n127 = proto.readVarInt(p194, n127)
		elseif v1947 == proto.wireTypes.lengthDelimited then
			if v1946 == 1 then
				local v1949

				v1949, n127 = proto.readBuffer(p194, n127)
				v1944.surface_key = prop_types.StringProp.decode(v1949)
			elseif v1946 == 2 then
				local v1950

				v1950, n127 = proto.readBuffer(p194, n127)
				v1944.config_key = prop_types.StringProp.decode(v1950)
			else
				local v1951, v1952 = proto.readVarInt(p194, n127)

				n127 = v1952 + v1951
			end
		elseif v1947 == proto.wireTypes.i32 then
			local v1953

			v1953, n127 = proto.readFixed32(p194, n127)
		elseif v1947 == proto.wireTypes.i64 then
			local v1954

			v1954, n127 = proto.readFixed64(p194, n127)
		else
			error("Unsupported wire type: " .. v1947)
		end
	end

	return v1944
end
function t255.jsonEncode(p195) -- line: 14395
	local t257 = {}

	if p195.surface_key ~= nil then
		t257.surfaceKey = p195.surface_key:jsonEncode()
	end

	if p195.config_key ~= nil then
		t257.configKey = p195.config_key:jsonEncode()
	end

	return t257
end
function t255.jsonDecode(t258: {[any]: any}) -- line: 14409
	-- upvalues: t255 (copy), prop_types (copy)
	local v1958 = t255.new()

	if t258.surface_key ~= nil then
		v1958.surface_key = prop_types.StringProp.jsonDecode(t258.surface_key)
	end

	if t258.surfaceKey ~= nil then
		v1958.surface_key = prop_types.StringProp.jsonDecode(t258.surfaceKey)
	end

	if t258.config_key ~= nil then
		v1958.config_key = prop_types.StringProp.jsonDecode(t258.config_key)
	end

	if t258.configKey ~= nil then
		v1958.config_key = prop_types.StringProp.jsonDecode(t258.configKey)
	end

	return v1958
end

t255.descriptor = {
	name = "RefreshFromApiAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.RefreshFromApiAction_Params = t255
typeRegistry.default:register(t1.RefreshFromApiAction_Params)

local t259 = {}

t259.__index = t259

function t259.new(t260: {[any]: any}?) -- line: 14446
	-- upvalues: t1 (copy), t259 (copy)
	return (setmetatable({
		action_type = if t260 ~= nil and t260.action_type ~= nil then t260.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t260 ~= nil and t260.action_params ~= nil then t260.action_params else nil
	}, t259))
end
function t259.encode(p196) -- line: 14457
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n128 = 0

	if p196.action_type ~= nil and (p196.action_type ~= nil and p196.action_type ~= 0 or p196.action_type ~= t1.ActionType.fromNumber(0)) then
		local v1963, v1964 = proto.writeTag(buf, n128, 1, proto.wireTypes.varint)

		buf, n128 = proto.writeVarInt(v1963, v1964, t1.ActionType.toNumber(p196.action_type))
	end

	if p196.action_params ~= nil then
		local v1965 = p196.action_params:encode()
		local v1966, v1967 = proto.writeTag(buf, n128, 2, proto.wireTypes.lengthDelimited)

		buf, n128 = proto.writeBuffer(v1966, v1967, v1965, buffer.len(v1965))
	end

	local buf67 = buffer.create(n128)

	buffer.copy(buf67, 0, buf, 0, n128)

	return buf67
end
function t259.decode(p197: buffer) -- line: 14483
	-- upvalues: t259 (copy), proto (copy), t1 (copy)
	local v1970 = t259.new()
	local n129 = 0

	while n129 < buffer.len(p197) do
		local v1972, v1973

		v1972, v1973, n129 = proto.readTag(p197, n129)

		if v1973 == proto.wireTypes.varint then
			if v1972 == 1 then
				local v1974

				v1974, n129 = proto.readVarIntI32(p197, n129)
				v1970.action_type = t1.ActionType.fromNumber(v1974) or v1974
			else
				local v1975

				v1975, n129 = proto.readVarInt(p197, n129)
			end
		elseif v1973 == proto.wireTypes.lengthDelimited then
			if v1972 == 2 then
				local v1976

				v1976, n129 = proto.readBuffer(p197, n129)
				v1970.action_params = t1.RefreshOmniRecommendationFeedItemAction_Params.decode(v1976)
			else
				local v1977, v1978 = proto.readVarInt(p197, n129)

				n129 = v1978 + v1977
			end
		elseif v1973 == proto.wireTypes.i32 then
			local v1979

			v1979, n129 = proto.readFixed32(p197, n129)
		elseif v1973 == proto.wireTypes.i64 then
			local v1980

			v1980, n129 = proto.readFixed64(p197, n129)
		else
			error("Unsupported wire type: " .. v1973)
		end
	end

	return v1970
end
function t259.jsonEncode(p198) -- line: 14531
	-- upvalues: t1 (copy)
	local t261 = {}

	if p198.action_type ~= nil and (p198.action_type ~= nil and p198.action_type ~= 0 or p198.action_type ~= t1.ActionType.fromNumber(0)) then
		t261.actionType = if typeof(p198.action_type) ~= "number" then t1.ActionType.toNumber(p198.action_type) else p198.action_type
	end

	if p198.action_params ~= nil then
		t261.actionParams = p198.action_params:jsonEncode()
	end

	return t261
end
function t259.jsonDecode(t262: {[any]: any}) -- line: 14553
	-- upvalues: t259 (copy), t1 (copy)
	local v1984 = t259.new()

	if t262.action_type ~= nil then
		v1984.action_type = if typeof(t262.action_type) ~= "number" then t1.ActionType.fromName(t262.action_type) or t262.action_type else t1.ActionType.fromNumber(t262.action_type) or t262.action_type
	end

	if t262.actionType ~= nil then
		v1984.action_type = if typeof(t262.actionType) ~= "number" then t1.ActionType.fromName(t262.actionType) or t262.actionType else t1.ActionType.fromNumber(t262.actionType) or t262.actionType
	end

	if t262.action_params ~= nil then
		v1984.action_params = t1.RefreshOmniRecommendationFeedItemAction_Params.jsonDecode(t262.action_params)
	end

	if t262.actionParams ~= nil then
		v1984.action_params = t1.RefreshOmniRecommendationFeedItemAction_Params.jsonDecode(t262.actionParams)
	end

	return v1984
end

t259.descriptor = {
	name = "RefreshOmniRecommendationFeedItemAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.RefreshOmniRecommendationFeedItemAction"
}
t1.RefreshOmniRecommendationFeedItemAction = t259
typeRegistry.default:register(t1.RefreshOmniRecommendationFeedItemAction)

local t263 = {}

t263.__index = t263

function t263.new(t264: {[any]: any}?) -- line: 14595
	-- upvalues: t263 (copy)
	return (setmetatable({
		topic_id = if t264 ~= nil and t264.topic_id ~= nil then t264.topic_id else nil,
		selected_option = if t264 ~= nil and t264.selected_option ~= nil then t264.selected_option else nil,
		request_intent = if t264 ~= nil and t264.request_intent ~= nil then t264.request_intent else nil,
		feed_item_key = if t264 ~= nil and t264.feed_item_key ~= nil then t264.feed_item_key else nil
	}, t263))
end
function t263.encode(p199) -- line: 14606
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n130 = 0

	if p199.topic_id ~= nil then
		local v1989 = p199.topic_id:encode()
		local v1990, v1991 = proto.writeTag(buf, n130, 1, proto.wireTypes.lengthDelimited)

		buf, n130 = proto.writeBuffer(v1990, v1991, v1989, buffer.len(v1989))
	end

	if p199.selected_option ~= nil then
		local v1992 = p199.selected_option:encode()
		local v1993, v1994 = proto.writeTag(buf, n130, 2, proto.wireTypes.lengthDelimited)

		buf, n130 = proto.writeBuffer(v1993, v1994, v1992, buffer.len(v1992))
	end

	if p199.request_intent ~= nil then
		local v1995 = p199.request_intent:encode()
		local v1996, v1997 = proto.writeTag(buf, n130, 3, proto.wireTypes.lengthDelimited)

		buf, n130 = proto.writeBuffer(v1996, v1997, v1995, buffer.len(v1995))
	end

	if p199.feed_item_key ~= nil then
		local v1998 = p199.feed_item_key:encode()
		local v1999, v2000 = proto.writeTag(buf, n130, 4, proto.wireTypes.lengthDelimited)

		buf, n130 = proto.writeBuffer(v1999, v2000, v1998, buffer.len(v1998))
	end

	local buf68 = buffer.create(n130)

	buffer.copy(buf68, 0, buf, 0, n130)

	return buf68
end
function t263.decode(p200: buffer) -- line: 14641
	-- upvalues: t263 (copy), proto (copy), prop_types (copy)
	local v2003 = t263.new()
	local n131 = 0

	while n131 < buffer.len(p200) do
		local v2005, v2006

		v2005, v2006, n131 = proto.readTag(p200, n131)

		if v2006 == proto.wireTypes.varint then
			local v2007

			v2007, n131 = proto.readVarInt(p200, n131)
		elseif v2006 == proto.wireTypes.lengthDelimited then
			if v2005 == 1 then
				local v2008

				v2008, n131 = proto.readBuffer(p200, n131)
				v2003.topic_id = prop_types.StringProp.decode(v2008)
			elseif v2005 == 2 then
				local v2009

				v2009, n131 = proto.readBuffer(p200, n131)
				v2003.selected_option = prop_types.StringProp.decode(v2009)
			elseif v2005 == 3 then
				local v2010

				v2010, n131 = proto.readBuffer(p200, n131)
				v2003.request_intent = prop_types.StringProp.decode(v2010)
			elseif v2005 == 4 then
				local v2011

				v2011, n131 = proto.readBuffer(p200, n131)
				v2003.feed_item_key = prop_types.StringProp.decode(v2011)
			else
				local v2012, v2013 = proto.readVarInt(p200, n131)

				n131 = v2013 + v2012
			end
		elseif v2006 == proto.wireTypes.i32 then
			local v2014

			v2014, n131 = proto.readFixed32(p200, n131)
		elseif v2006 == proto.wireTypes.i64 then
			local v2015

			v2015, n131 = proto.readFixed64(p200, n131)
		else
			error("Unsupported wire type: " .. v2006)
		end
	end

	return v2003
end
function t263.jsonEncode(p201) -- line: 14701
	local t265 = {}

	if p201.topic_id ~= nil then
		t265.topicId = p201.topic_id:jsonEncode()
	end

	if p201.selected_option ~= nil then
		t265.selectedOption = p201.selected_option:jsonEncode()
	end

	if p201.request_intent ~= nil then
		t265.requestIntent = p201.request_intent:jsonEncode()
	end

	if p201.feed_item_key ~= nil then
		t265.feedItemKey = p201.feed_item_key:jsonEncode()
	end

	return t265
end
function t263.jsonDecode(t266: {[any]: any}) -- line: 14725
	-- upvalues: t263 (copy), prop_types (copy)
	local v2019 = t263.new()

	if t266.topic_id ~= nil then
		v2019.topic_id = prop_types.StringProp.jsonDecode(t266.topic_id)
	end

	if t266.topicId ~= nil then
		v2019.topic_id = prop_types.StringProp.jsonDecode(t266.topicId)
	end

	if t266.selected_option ~= nil then
		v2019.selected_option = prop_types.StringProp.jsonDecode(t266.selected_option)
	end

	if t266.selectedOption ~= nil then
		v2019.selected_option = prop_types.StringProp.jsonDecode(t266.selectedOption)
	end

	if t266.request_intent ~= nil then
		v2019.request_intent = prop_types.StringProp.jsonDecode(t266.request_intent)
	end

	if t266.requestIntent ~= nil then
		v2019.request_intent = prop_types.StringProp.jsonDecode(t266.requestIntent)
	end

	if t266.feed_item_key ~= nil then
		v2019.feed_item_key = prop_types.StringProp.jsonDecode(t266.feed_item_key)
	end

	if t266.feedItemKey ~= nil then
		v2019.feed_item_key = prop_types.StringProp.jsonDecode(t266.feedItemKey)
	end

	return v2019
end

t263.descriptor = {
	name = "RefreshOmniRecommendationFeedItemAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.RefreshOmniRecommendationFeedItemAction_Params = t263
typeRegistry.default:register(t1.RefreshOmniRecommendationFeedItemAction_Params)

local t267 = {}

t267.__index = t267

function t267.new(t268: {[any]: any}?) -- line: 14785
	-- upvalues: t1 (copy), t267 (copy)
	return (setmetatable({
		action_type = if t268 ~= nil and t268.action_type ~= nil then t268.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t268 ~= nil and t268.action_params ~= nil then t268.action_params else nil
	}, t267))
end
function t267.encode(p202) -- line: 14794
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n132 = 0

	if p202.action_type ~= nil and (p202.action_type ~= nil and p202.action_type ~= 0 or p202.action_type ~= t1.ActionType.fromNumber(0)) then
		local v2024, v2025 = proto.writeTag(buf, n132, 1, proto.wireTypes.varint)

		buf, n132 = proto.writeVarInt(v2024, v2025, t1.ActionType.toNumber(p202.action_type))
	end

	if p202.action_params ~= nil then
		local v2026 = p202.action_params:encode()
		local v2027, v2028 = proto.writeTag(buf, n132, 2, proto.wireTypes.lengthDelimited)

		buf, n132 = proto.writeBuffer(v2027, v2028, v2026, buffer.len(v2026))
	end

	local buf69 = buffer.create(n132)

	buffer.copy(buf69, 0, buf, 0, n132)

	return buf69
end
function t267.decode(p203: buffer) -- line: 14820
	-- upvalues: t267 (copy), proto (copy), t1 (copy)
	local v2031 = t267.new()
	local n133 = 0

	while n133 < buffer.len(p203) do
		local v2033, v2034

		v2033, v2034, n133 = proto.readTag(p203, n133)

		if v2034 == proto.wireTypes.varint then
			if v2033 == 1 then
				local v2035

				v2035, n133 = proto.readVarIntI32(p203, n133)
				v2031.action_type = t1.ActionType.fromNumber(v2035) or v2035
			else
				local v2036

				v2036, n133 = proto.readVarInt(p203, n133)
			end
		elseif v2034 == proto.wireTypes.lengthDelimited then
			if v2033 == 2 then
				local v2037

				v2037, n133 = proto.readBuffer(p203, n133)
				v2031.action_params = t1.RsvpToEventAction_Params.decode(v2037)
			else
				local v2038, v2039 = proto.readVarInt(p203, n133)

				n133 = v2039 + v2038
			end
		elseif v2034 == proto.wireTypes.i32 then
			local v2040

			v2040, n133 = proto.readFixed32(p203, n133)
		elseif v2034 == proto.wireTypes.i64 then
			local v2041

			v2041, n133 = proto.readFixed64(p203, n133)
		else
			error("Unsupported wire type: " .. v2034)
		end
	end

	return v2031
end
function t267.jsonEncode(p204) -- line: 14868
	-- upvalues: t1 (copy)
	local t269 = {}

	if p204.action_type ~= nil and (p204.action_type ~= nil and p204.action_type ~= 0 or p204.action_type ~= t1.ActionType.fromNumber(0)) then
		t269.actionType = if typeof(p204.action_type) ~= "number" then t1.ActionType.toNumber(p204.action_type) else p204.action_type
	end

	if p204.action_params ~= nil then
		t269.actionParams = p204.action_params:jsonEncode()
	end

	return t269
end
function t267.jsonDecode(t270: {[any]: any}) -- line: 14890
	-- upvalues: t267 (copy), t1 (copy)
	local v2045 = t267.new()

	if t270.action_type ~= nil then
		v2045.action_type = if typeof(t270.action_type) ~= "number" then t1.ActionType.fromName(t270.action_type) or t270.action_type else t1.ActionType.fromNumber(t270.action_type) or t270.action_type
	end

	if t270.actionType ~= nil then
		v2045.action_type = if typeof(t270.actionType) ~= "number" then t1.ActionType.fromName(t270.actionType) or t270.actionType else t1.ActionType.fromNumber(t270.actionType) or t270.actionType
	end

	if t270.action_params ~= nil then
		v2045.action_params = t1.RsvpToEventAction_Params.jsonDecode(t270.action_params)
	end

	if t270.actionParams ~= nil then
		v2045.action_params = t1.RsvpToEventAction_Params.jsonDecode(t270.actionParams)
	end

	return v2045
end

t267.descriptor = {
	name = "RsvpToEventAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.RsvpToEventAction"
}
t1.RsvpToEventAction = t267
typeRegistry.default:register(t1.RsvpToEventAction)

local t271 = {}

t271.__index = t271

function t271.new(t272: {[any]: any}?) -- line: 14930
	-- upvalues: t271 (copy)
	return (setmetatable({
		event_id = if t272 ~= nil and t272.event_id ~= nil then t272.event_id else nil,
		user_rsvp = if t272 ~= nil and t272.user_rsvp ~= nil then t272.user_rsvp else nil,
		notifications_modal_identifier = if t272 ~= nil and t272.notifications_modal_identifier ~= nil then t272.notifications_modal_identifier else nil
	}, t271))
end
function t271.encode(p205) -- line: 14940
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n134 = 0

	if p205.event_id ~= nil then
		local v2050 = p205.event_id:encode()
		local v2051, v2052 = proto.writeTag(buf, n134, 1, proto.wireTypes.lengthDelimited)

		buf, n134 = proto.writeBuffer(v2051, v2052, v2050, buffer.len(v2050))
	end

	if p205.user_rsvp ~= nil then
		local v2053 = p205.user_rsvp:encode()
		local v2054, v2055 = proto.writeTag(buf, n134, 2, proto.wireTypes.lengthDelimited)

		buf, n134 = proto.writeBuffer(v2054, v2055, v2053, buffer.len(v2053))
	end

	if p205.notifications_modal_identifier ~= nil then
		local v2056 = p205.notifications_modal_identifier:encode()
		local v2057, v2058 = proto.writeTag(buf, n134, 3, proto.wireTypes.lengthDelimited)

		buf, n134 = proto.writeBuffer(v2057, v2058, v2056, buffer.len(v2056))
	end

	local buf70 = buffer.create(n134)

	buffer.copy(buf70, 0, buf, 0, n134)

	return buf70
end
function t271.decode(p206: buffer) -- line: 14967
	-- upvalues: t271 (copy), proto (copy), prop_types (copy)
	local v2061 = t271.new()
	local n135 = 0

	while n135 < buffer.len(p206) do
		local v2063, v2064

		v2063, v2064, n135 = proto.readTag(p206, n135)

		if v2064 == proto.wireTypes.varint then
			local v2065

			v2065, n135 = proto.readVarInt(p206, n135)
		elseif v2064 == proto.wireTypes.lengthDelimited then
			if v2063 == 1 then
				local v2066

				v2066, n135 = proto.readBuffer(p206, n135)
				v2061.event_id = prop_types.StringProp.decode(v2066)
			elseif v2063 == 2 then
				local v2067

				v2067, n135 = proto.readBuffer(p206, n135)
				v2061.user_rsvp = prop_types.BoolProp.decode(v2067)
			elseif v2063 == 3 then
				local v2068

				v2068, n135 = proto.readBuffer(p206, n135)
				v2061.notifications_modal_identifier = prop_types.StringProp.decode(v2068)
			else
				local v2069, v2070 = proto.readVarInt(p206, n135)

				n135 = v2070 + v2069
			end
		elseif v2064 == proto.wireTypes.i32 then
			local v2071

			v2071, n135 = proto.readFixed32(p206, n135)
		elseif v2064 == proto.wireTypes.i64 then
			local v2072

			v2072, n135 = proto.readFixed64(p206, n135)
		else
			error("Unsupported wire type: " .. v2064)
		end
	end

	return v2061
end
function t271.jsonEncode(p207) -- line: 15021
	local t273 = {}

	if p207.event_id ~= nil then
		t273.eventId = p207.event_id:jsonEncode()
	end

	if p207.user_rsvp ~= nil then
		t273.userRsvp = p207.user_rsvp:jsonEncode()
	end

	if p207.notifications_modal_identifier ~= nil then
		t273.notificationsModalIdentifier = p207.notifications_modal_identifier:jsonEncode()
	end

	return t273
end
function t271.jsonDecode(t274: {[any]: any}) -- line: 15039
	-- upvalues: t271 (copy), prop_types (copy)
	local v2076 = t271.new()

	if t274.event_id ~= nil then
		v2076.event_id = prop_types.StringProp.jsonDecode(t274.event_id)
	end

	if t274.eventId ~= nil then
		v2076.event_id = prop_types.StringProp.jsonDecode(t274.eventId)
	end

	if t274.user_rsvp ~= nil then
		v2076.user_rsvp = prop_types.BoolProp.jsonDecode(t274.user_rsvp)
	end

	if t274.userRsvp ~= nil then
		v2076.user_rsvp = prop_types.BoolProp.jsonDecode(t274.userRsvp)
	end

	if t274.notifications_modal_identifier ~= nil then
		v2076.notifications_modal_identifier = prop_types.StringProp.jsonDecode(t274.notifications_modal_identifier)
	end

	if t274.notificationsModalIdentifier ~= nil then
		v2076.notifications_modal_identifier = prop_types.StringProp.jsonDecode(t274.notificationsModalIdentifier)
	end

	return v2076
end

t271.descriptor = {
	name = "RsvpToEventAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.RsvpToEventAction_Params = t271
typeRegistry.default:register(t1.RsvpToEventAction_Params)

local t275 = {}

t275.__index = t275

function t275.new(t276: {[any]: any}?) -- line: 15089
	-- upvalues: t1 (copy), t275 (copy)
	return (setmetatable({
		action_type = if t276 ~= nil and t276.action_type ~= nil then t276.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t276 ~= nil and t276.action_params ~= nil then t276.action_params else nil
	}, t275))
end
function t275.encode(p208) -- line: 15098
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n136 = 0

	if p208.action_type ~= nil and (p208.action_type ~= nil and p208.action_type ~= 0 or p208.action_type ~= t1.ActionType.fromNumber(0)) then
		local v2081, v2082 = proto.writeTag(buf, n136, 1, proto.wireTypes.varint)

		buf, n136 = proto.writeVarInt(v2081, v2082, t1.ActionType.toNumber(p208.action_type))
	end

	if p208.action_params ~= nil then
		local v2083 = p208.action_params:encode()
		local v2084, v2085 = proto.writeTag(buf, n136, 2, proto.wireTypes.lengthDelimited)

		buf, n136 = proto.writeBuffer(v2084, v2085, v2083, buffer.len(v2083))
	end

	local buf71 = buffer.create(n136)

	buffer.copy(buf71, 0, buf, 0, n136)

	return buf71
end
function t275.decode(p209: buffer) -- line: 15124
	-- upvalues: t275 (copy), proto (copy), t1 (copy)
	local v2088 = t275.new()
	local n137 = 0

	while n137 < buffer.len(p209) do
		local v2090, v2091

		v2090, v2091, n137 = proto.readTag(p209, n137)

		if v2091 == proto.wireTypes.varint then
			if v2090 == 1 then
				local v2092

				v2092, n137 = proto.readVarIntI32(p209, n137)
				v2088.action_type = t1.ActionType.fromNumber(v2092) or v2092
			else
				local v2093

				v2093, n137 = proto.readVarInt(p209, n137)
			end
		elseif v2091 == proto.wireTypes.lengthDelimited then
			if v2090 == 2 then
				local v2094

				v2094, n137 = proto.readBuffer(p209, n137)
				v2088.action_params = t1.OpenEventDetailsAction_Params.decode(v2094)
			else
				local v2095, v2096 = proto.readVarInt(p209, n137)

				n137 = v2096 + v2095
			end
		elseif v2091 == proto.wireTypes.i32 then
			local v2097

			v2097, n137 = proto.readFixed32(p209, n137)
		elseif v2091 == proto.wireTypes.i64 then
			local v2098

			v2098, n137 = proto.readFixed64(p209, n137)
		else
			error("Unsupported wire type: " .. v2091)
		end
	end

	return v2088
end
function t275.jsonEncode(p210) -- line: 15172
	-- upvalues: t1 (copy)
	local t277 = {}

	if p210.action_type ~= nil and (p210.action_type ~= nil and p210.action_type ~= 0 or p210.action_type ~= t1.ActionType.fromNumber(0)) then
		t277.actionType = if typeof(p210.action_type) ~= "number" then t1.ActionType.toNumber(p210.action_type) else p210.action_type
	end

	if p210.action_params ~= nil then
		t277.actionParams = p210.action_params:jsonEncode()
	end

	return t277
end
function t275.jsonDecode(t278: {[any]: any}) -- line: 15194
	-- upvalues: t275 (copy), t1 (copy)
	local v2102 = t275.new()

	if t278.action_type ~= nil then
		v2102.action_type = if typeof(t278.action_type) ~= "number" then t1.ActionType.fromName(t278.action_type) or t278.action_type else t1.ActionType.fromNumber(t278.action_type) or t278.action_type
	end

	if t278.actionType ~= nil then
		v2102.action_type = if typeof(t278.actionType) ~= "number" then t1.ActionType.fromName(t278.actionType) or t278.actionType else t1.ActionType.fromNumber(t278.actionType) or t278.actionType
	end

	if t278.action_params ~= nil then
		v2102.action_params = t1.OpenEventDetailsAction_Params.jsonDecode(t278.action_params)
	end

	if t278.actionParams ~= nil then
		v2102.action_params = t1.OpenEventDetailsAction_Params.jsonDecode(t278.actionParams)
	end

	return v2102
end

t275.descriptor = {
	name = "OpenEventDetailsAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.OpenEventDetailsAction"
}
t1.OpenEventDetailsAction = t275
typeRegistry.default:register(t1.OpenEventDetailsAction)

local t279 = {}

t279.__index = t279

function t279.new(t280: {[any]: any}?) -- line: 15234
	-- upvalues: t279 (copy)
	return (setmetatable({
		event_id = if t280 ~= nil and t280.event_id ~= nil then t280.event_id else nil
	}, t279))
end
function t279.encode(p211) -- line: 15242
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n138 = 0

	if p211.event_id ~= nil then
		local v2107 = p211.event_id:encode()
		local v2108, v2109 = proto.writeTag(buf, n138, 1, proto.wireTypes.lengthDelimited)

		buf, n138 = proto.writeBuffer(v2108, v2109, v2107, buffer.len(v2107))
	end

	local buf72 = buffer.create(n138)

	buffer.copy(buf72, 0, buf, 0, n138)

	return buf72
end
function t279.decode(p212: buffer) -- line: 15257
	-- upvalues: t279 (copy), proto (copy), prop_types (copy)
	local v2112 = t279.new()
	local n139 = 0

	while n139 < buffer.len(p212) do
		local v2114, v2115

		v2114, v2115, n139 = proto.readTag(p212, n139)

		if v2115 == proto.wireTypes.varint then
			local v2116

			v2116, n139 = proto.readVarInt(p212, n139)
		elseif v2115 == proto.wireTypes.lengthDelimited then
			if v2114 == 1 then
				local v2117

				v2117, n139 = proto.readBuffer(p212, n139)
				v2112.event_id = prop_types.StringProp.decode(v2117)
			else
				local v2118, v2119 = proto.readVarInt(p212, n139)

				n139 = v2119 + v2118
			end
		elseif v2115 == proto.wireTypes.i32 then
			local v2120

			v2120, n139 = proto.readFixed32(p212, n139)
		elseif v2115 == proto.wireTypes.i64 then
			local v2121

			v2121, n139 = proto.readFixed64(p212, n139)
		else
			error("Unsupported wire type: " .. v2115)
		end
	end

	return v2112
end
function t279.jsonEncode(p213) -- line: 15300
	local t281 = {}

	if p213.event_id ~= nil then
		t281.eventId = p213.event_id:jsonEncode()
	end

	return t281
end
function t279.jsonDecode(t282: {[any]: any}) -- line: 15310
	-- upvalues: t279 (copy), prop_types (copy)
	local v2125 = t279.new()

	if t282.event_id ~= nil then
		v2125.event_id = prop_types.StringProp.jsonDecode(t282.event_id)
	end

	if t282.eventId ~= nil then
		v2125.event_id = prop_types.StringProp.jsonDecode(t282.eventId)
	end

	return v2125
end

t279.descriptor = {
	name = "OpenEventDetailsAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.OpenEventDetailsAction_Params = t279
typeRegistry.default:register(t1.OpenEventDetailsAction_Params)

local t283 = {}

t283.__index = t283

function t283.new(t284: {[any]: any}?) -- line: 15338
	-- upvalues: t1 (copy), t283 (copy)
	return (setmetatable({
		action_type = if t284 ~= nil and t284.action_type ~= nil then t284.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t284 ~= nil and t284.action_params ~= nil then t284.action_params else nil
	}, t283))
end
function t283.encode(p214) -- line: 15347
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n140 = 0

	if p214.action_type ~= nil and (p214.action_type ~= nil and p214.action_type ~= 0 or p214.action_type ~= t1.ActionType.fromNumber(0)) then
		local v2130, v2131 = proto.writeTag(buf, n140, 1, proto.wireTypes.varint)

		buf, n140 = proto.writeVarInt(v2130, v2131, t1.ActionType.toNumber(p214.action_type))
	end

	if p214.action_params ~= nil then
		local v2132 = p214.action_params:encode()
		local v2133, v2134 = proto.writeTag(buf, n140, 2, proto.wireTypes.lengthDelimited)

		buf, n140 = proto.writeBuffer(v2133, v2134, v2132, buffer.len(v2132))
	end

	local buf73 = buffer.create(n140)

	buffer.copy(buf73, 0, buf, 0, n140)

	return buf73
end
function t283.decode(p215: buffer) -- line: 15373
	-- upvalues: t283 (copy), proto (copy), t1 (copy)
	local v2137 = t283.new()
	local n141 = 0

	while n141 < buffer.len(p215) do
		local v2139, v2140

		v2139, v2140, n141 = proto.readTag(p215, n141)

		if v2140 == proto.wireTypes.varint then
			if v2139 == 1 then
				local v2141

				v2141, n141 = proto.readVarIntI32(p215, n141)
				v2137.action_type = t1.ActionType.fromNumber(v2141) or v2141
			else
				local v2142

				v2142, n141 = proto.readVarInt(p215, n141)
			end
		elseif v2140 == proto.wireTypes.lengthDelimited then
			if v2139 == 2 then
				local v2143

				v2143, n141 = proto.readBuffer(p215, n141)
				v2137.action_params = t1.OpenBadgesSeeAllAction_Params.decode(v2143)
			else
				local v2144, v2145 = proto.readVarInt(p215, n141)

				n141 = v2145 + v2144
			end
		elseif v2140 == proto.wireTypes.i32 then
			local v2146

			v2146, n141 = proto.readFixed32(p215, n141)
		elseif v2140 == proto.wireTypes.i64 then
			local v2147

			v2147, n141 = proto.readFixed64(p215, n141)
		else
			error("Unsupported wire type: " .. v2140)
		end
	end

	return v2137
end
function t283.jsonEncode(p216) -- line: 15421
	-- upvalues: t1 (copy)
	local t285 = {}

	if p216.action_type ~= nil and (p216.action_type ~= nil and p216.action_type ~= 0 or p216.action_type ~= t1.ActionType.fromNumber(0)) then
		t285.actionType = if typeof(p216.action_type) ~= "number" then t1.ActionType.toNumber(p216.action_type) else p216.action_type
	end

	if p216.action_params ~= nil then
		t285.actionParams = p216.action_params:jsonEncode()
	end

	return t285
end
function t283.jsonDecode(t286: {[any]: any}) -- line: 15443
	-- upvalues: t283 (copy), t1 (copy)
	local v2151 = t283.new()

	if t286.action_type ~= nil then
		v2151.action_type = if typeof(t286.action_type) ~= "number" then t1.ActionType.fromName(t286.action_type) or t286.action_type else t1.ActionType.fromNumber(t286.action_type) or t286.action_type
	end

	if t286.actionType ~= nil then
		v2151.action_type = if typeof(t286.actionType) ~= "number" then t1.ActionType.fromName(t286.actionType) or t286.actionType else t1.ActionType.fromNumber(t286.actionType) or t286.actionType
	end

	if t286.action_params ~= nil then
		v2151.action_params = t1.OpenBadgesSeeAllAction_Params.jsonDecode(t286.action_params)
	end

	if t286.actionParams ~= nil then
		v2151.action_params = t1.OpenBadgesSeeAllAction_Params.jsonDecode(t286.actionParams)
	end

	return v2151
end

t283.descriptor = {
	name = "OpenBadgesSeeAllAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.OpenBadgesSeeAllAction"
}
t1.OpenBadgesSeeAllAction = t283
typeRegistry.default:register(t1.OpenBadgesSeeAllAction)

local t287 = {}

t287.__index = t287

function t287.new(t288: {[any]: any}?) -- line: 15483
	-- upvalues: t287 (copy)
	return (setmetatable({
		universe_id = if t288 ~= nil and t288.universe_id ~= nil then t288.universe_id else nil
	}, t287))
end
function t287.encode(p217) -- line: 15491
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n142 = 0

	if p217.universe_id ~= nil then
		local v2156 = p217.universe_id:encode()
		local v2157, v2158 = proto.writeTag(buf, n142, 1, proto.wireTypes.lengthDelimited)

		buf, n142 = proto.writeBuffer(v2157, v2158, v2156, buffer.len(v2156))
	end

	local buf74 = buffer.create(n142)

	buffer.copy(buf74, 0, buf, 0, n142)

	return buf74
end
function t287.decode(p218: buffer) -- line: 15506
	-- upvalues: t287 (copy), proto (copy), prop_types (copy)
	local v2161 = t287.new()
	local n143 = 0

	while n143 < buffer.len(p218) do
		local v2163, v2164

		v2163, v2164, n143 = proto.readTag(p218, n143)

		if v2164 == proto.wireTypes.varint then
			local v2165

			v2165, n143 = proto.readVarInt(p218, n143)
		elseif v2164 == proto.wireTypes.lengthDelimited then
			if v2163 == 1 then
				local v2166

				v2166, n143 = proto.readBuffer(p218, n143)
				v2161.universe_id = prop_types.StringProp.decode(v2166)
			else
				local v2167, v2168 = proto.readVarInt(p218, n143)

				n143 = v2168 + v2167
			end
		elseif v2164 == proto.wireTypes.i32 then
			local v2169

			v2169, n143 = proto.readFixed32(p218, n143)
		elseif v2164 == proto.wireTypes.i64 then
			local v2170

			v2170, n143 = proto.readFixed64(p218, n143)
		else
			error("Unsupported wire type: " .. v2164)
		end
	end

	return v2161
end
function t287.jsonEncode(p219) -- line: 15549
	local t289 = {}

	if p219.universe_id ~= nil then
		t289.universeId = p219.universe_id:jsonEncode()
	end

	return t289
end
function t287.jsonDecode(t290: {[any]: any}) -- line: 15559
	-- upvalues: t287 (copy), prop_types (copy)
	local v2174 = t287.new()

	if t290.universe_id ~= nil then
		v2174.universe_id = prop_types.StringProp.jsonDecode(t290.universe_id)
	end

	if t290.universeId ~= nil then
		v2174.universe_id = prop_types.StringProp.jsonDecode(t290.universeId)
	end

	return v2174
end

t287.descriptor = {
	name = "OpenBadgesSeeAllAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.OpenBadgesSeeAllAction_Params = t287
typeRegistry.default:register(t1.OpenBadgesSeeAllAction_Params)

local t291 = {}

t291.__index = t291

function t291.new(t292: {[any]: any}?) -- line: 15588
	-- upvalues: t1 (copy), t291 (copy)
	return (setmetatable({
		action_type = if t292 ~= nil and t292.action_type ~= nil then t292.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t292 ~= nil and t292.action_params ~= nil then t292.action_params else nil
	}, t291))
end
function t291.encode(p220) -- line: 15599
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n144 = 0

	if p220.action_type ~= nil and (p220.action_type ~= nil and p220.action_type ~= 0 or p220.action_type ~= t1.ActionType.fromNumber(0)) then
		local v2179, v2180 = proto.writeTag(buf, n144, 1, proto.wireTypes.varint)

		buf, n144 = proto.writeVarInt(v2179, v2180, t1.ActionType.toNumber(p220.action_type))
	end

	if p220.action_params ~= nil then
		local v2181 = p220.action_params:encode()
		local v2182, v2183 = proto.writeTag(buf, n144, 2, proto.wireTypes.lengthDelimited)

		buf, n144 = proto.writeBuffer(v2182, v2183, v2181, buffer.len(v2181))
	end

	local buf75 = buffer.create(n144)

	buffer.copy(buf75, 0, buf, 0, n144)

	return buf75
end
function t291.decode(p221: buffer) -- line: 15625
	-- upvalues: t291 (copy), proto (copy), t1 (copy)
	local v2186 = t291.new()
	local n145 = 0

	while n145 < buffer.len(p221) do
		local v2188, v2189

		v2188, v2189, n145 = proto.readTag(p221, n145)

		if v2189 == proto.wireTypes.varint then
			if v2188 == 1 then
				local v2190

				v2190, n145 = proto.readVarIntI32(p221, n145)
				v2186.action_type = t1.ActionType.fromNumber(v2190) or v2190
			else
				local v2191

				v2191, n145 = proto.readVarInt(p221, n145)
			end
		elseif v2189 == proto.wireTypes.lengthDelimited then
			if v2188 == 2 then
				local v2192

				v2192, n145 = proto.readBuffer(p221, n145)
				v2186.action_params = t1.OpenExperienceStoreSeeAllAction_Params.decode(v2192)
			else
				local v2193, v2194 = proto.readVarInt(p221, n145)

				n145 = v2194 + v2193
			end
		elseif v2189 == proto.wireTypes.i32 then
			local v2195

			v2195, n145 = proto.readFixed32(p221, n145)
		elseif v2189 == proto.wireTypes.i64 then
			local v2196

			v2196, n145 = proto.readFixed64(p221, n145)
		else
			error("Unsupported wire type: " .. v2189)
		end
	end

	return v2186
end
function t291.jsonEncode(p222) -- line: 15673
	-- upvalues: t1 (copy)
	local t293 = {}

	if p222.action_type ~= nil and (p222.action_type ~= nil and p222.action_type ~= 0 or p222.action_type ~= t1.ActionType.fromNumber(0)) then
		t293.actionType = if typeof(p222.action_type) ~= "number" then t1.ActionType.toNumber(p222.action_type) else p222.action_type
	end

	if p222.action_params ~= nil then
		t293.actionParams = p222.action_params:jsonEncode()
	end

	return t293
end
function t291.jsonDecode(t294: {[any]: any}) -- line: 15695
	-- upvalues: t291 (copy), t1 (copy)
	local v2200 = t291.new()

	if t294.action_type ~= nil then
		v2200.action_type = if typeof(t294.action_type) ~= "number" then t1.ActionType.fromName(t294.action_type) or t294.action_type else t1.ActionType.fromNumber(t294.action_type) or t294.action_type
	end

	if t294.actionType ~= nil then
		v2200.action_type = if typeof(t294.actionType) ~= "number" then t1.ActionType.fromName(t294.actionType) or t294.actionType else t1.ActionType.fromNumber(t294.actionType) or t294.actionType
	end

	if t294.action_params ~= nil then
		v2200.action_params = t1.OpenExperienceStoreSeeAllAction_Params.jsonDecode(t294.action_params)
	end

	if t294.actionParams ~= nil then
		v2200.action_params = t1.OpenExperienceStoreSeeAllAction_Params.jsonDecode(t294.actionParams)
	end

	return v2200
end

t291.descriptor = {
	name = "OpenExperienceStoreSeeAllAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.OpenExperienceStoreSeeAllAction"
}
t1.OpenExperienceStoreSeeAllAction = t291
typeRegistry.default:register(t1.OpenExperienceStoreSeeAllAction)

local t295 = {}

t295.__index = t295

function t295.new(t296: {[any]: any}?) -- line: 15735
	-- upvalues: t295 (copy)
	return (setmetatable({
		universe_id = if t296 ~= nil and t296.universe_id ~= nil then t296.universe_id else nil
	}, t295))
end
function t295.encode(p223) -- line: 15743
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n146 = 0

	if p223.universe_id ~= nil then
		local v2205 = p223.universe_id:encode()
		local v2206, v2207 = proto.writeTag(buf, n146, 1, proto.wireTypes.lengthDelimited)

		buf, n146 = proto.writeBuffer(v2206, v2207, v2205, buffer.len(v2205))
	end

	local buf76 = buffer.create(n146)

	buffer.copy(buf76, 0, buf, 0, n146)

	return buf76
end
function t295.decode(p224: buffer) -- line: 15758
	-- upvalues: t295 (copy), proto (copy), prop_types (copy)
	local v2210 = t295.new()
	local n147 = 0

	while n147 < buffer.len(p224) do
		local v2212, v2213

		v2212, v2213, n147 = proto.readTag(p224, n147)

		if v2213 == proto.wireTypes.varint then
			local v2214

			v2214, n147 = proto.readVarInt(p224, n147)
		elseif v2213 == proto.wireTypes.lengthDelimited then
			if v2212 == 1 then
				local v2215

				v2215, n147 = proto.readBuffer(p224, n147)
				v2210.universe_id = prop_types.StringProp.decode(v2215)
			else
				local v2216, v2217 = proto.readVarInt(p224, n147)

				n147 = v2217 + v2216
			end
		elseif v2213 == proto.wireTypes.i32 then
			local v2218

			v2218, n147 = proto.readFixed32(p224, n147)
		elseif v2213 == proto.wireTypes.i64 then
			local v2219

			v2219, n147 = proto.readFixed64(p224, n147)
		else
			error("Unsupported wire type: " .. v2213)
		end
	end

	return v2210
end
function t295.jsonEncode(p225) -- line: 15801
	local t297 = {}

	if p225.universe_id ~= nil then
		t297.universeId = p225.universe_id:jsonEncode()
	end

	return t297
end
function t295.jsonDecode(t298: {[any]: any}) -- line: 15811
	-- upvalues: t295 (copy), prop_types (copy)
	local v2223 = t295.new()

	if t298.universe_id ~= nil then
		v2223.universe_id = prop_types.StringProp.jsonDecode(t298.universe_id)
	end

	if t298.universeId ~= nil then
		v2223.universe_id = prop_types.StringProp.jsonDecode(t298.universeId)
	end

	return v2223
end

t295.descriptor = {
	name = "OpenExperienceStoreSeeAllAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.OpenExperienceStoreSeeAllAction_Params = t295
typeRegistry.default:register(t1.OpenExperienceStoreSeeAllAction_Params)

local t299 = {}

t299.__index = t299

function t299.new(t300: {[any]: any}?) -- line: 15842
	-- upvalues: t1 (copy), t299 (copy)
	return (setmetatable({
		action_type = if t300 ~= nil and t300.action_type ~= nil then t300.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t300 ~= nil and t300.action_params ~= nil then t300.action_params else nil
	}, t299))
end
function t299.encode(p226) -- line: 15853
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n148 = 0

	if p226.action_type ~= nil and (p226.action_type ~= nil and p226.action_type ~= 0 or p226.action_type ~= t1.ActionType.fromNumber(0)) then
		local v2228, v2229 = proto.writeTag(buf, n148, 1, proto.wireTypes.varint)

		buf, n148 = proto.writeVarInt(v2228, v2229, t1.ActionType.toNumber(p226.action_type))
	end

	if p226.action_params ~= nil then
		local v2230 = p226.action_params:encode()
		local v2231, v2232 = proto.writeTag(buf, n148, 2, proto.wireTypes.lengthDelimited)

		buf, n148 = proto.writeBuffer(v2231, v2232, v2230, buffer.len(v2230))
	end

	local buf77 = buffer.create(n148)

	buffer.copy(buf77, 0, buf, 0, n148)

	return buf77
end
function t299.decode(p227: buffer) -- line: 15879
	-- upvalues: t299 (copy), proto (copy), t1 (copy)
	local v2235 = t299.new()
	local n149 = 0

	while n149 < buffer.len(p227) do
		local v2237, v2238

		v2237, v2238, n149 = proto.readTag(p227, n149)

		if v2238 == proto.wireTypes.varint then
			if v2237 == 1 then
				local v2239

				v2239, n149 = proto.readVarIntI32(p227, n149)
				v2235.action_type = t1.ActionType.fromNumber(v2239) or v2239
			else
				local v2240

				v2240, n149 = proto.readVarInt(p227, n149)
			end
		elseif v2238 == proto.wireTypes.lengthDelimited then
			if v2237 == 2 then
				local v2241

				v2241, n149 = proto.readBuffer(p227, n149)
				v2235.action_params = t1.OpenSubscriptionPurchasePageAction_Params.decode(v2241)
			else
				local v2242, v2243 = proto.readVarInt(p227, n149)

				n149 = v2243 + v2242
			end
		elseif v2238 == proto.wireTypes.i32 then
			local v2244

			v2244, n149 = proto.readFixed32(p227, n149)
		elseif v2238 == proto.wireTypes.i64 then
			local v2245

			v2245, n149 = proto.readFixed64(p227, n149)
		else
			error("Unsupported wire type: " .. v2238)
		end
	end

	return v2235
end
function t299.jsonEncode(p228) -- line: 15927
	-- upvalues: t1 (copy)
	local t301 = {}

	if p228.action_type ~= nil and (p228.action_type ~= nil and p228.action_type ~= 0 or p228.action_type ~= t1.ActionType.fromNumber(0)) then
		t301.actionType = if typeof(p228.action_type) ~= "number" then t1.ActionType.toNumber(p228.action_type) else p228.action_type
	end

	if p228.action_params ~= nil then
		t301.actionParams = p228.action_params:jsonEncode()
	end

	return t301
end
function t299.jsonDecode(t302: {[any]: any}) -- line: 15949
	-- upvalues: t299 (copy), t1 (copy)
	local v2249 = t299.new()

	if t302.action_type ~= nil then
		v2249.action_type = if typeof(t302.action_type) ~= "number" then t1.ActionType.fromName(t302.action_type) or t302.action_type else t1.ActionType.fromNumber(t302.action_type) or t302.action_type
	end

	if t302.actionType ~= nil then
		v2249.action_type = if typeof(t302.actionType) ~= "number" then t1.ActionType.fromName(t302.actionType) or t302.actionType else t1.ActionType.fromNumber(t302.actionType) or t302.actionType
	end

	if t302.action_params ~= nil then
		v2249.action_params = t1.OpenSubscriptionPurchasePageAction_Params.jsonDecode(t302.action_params)
	end

	if t302.actionParams ~= nil then
		v2249.action_params = t1.OpenSubscriptionPurchasePageAction_Params.jsonDecode(t302.actionParams)
	end

	return v2249
end

t299.descriptor = {
	name = "OpenSubscriptionPurchasePageAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.OpenSubscriptionPurchasePageAction"
}
t1.OpenSubscriptionPurchasePageAction = t299
typeRegistry.default:register(t1.OpenSubscriptionPurchasePageAction)

local t303 = {}

t303.__index = t303

function t303.new(t304: {[any]: any}?) -- line: 15991
	-- upvalues: t303 (copy)
	return (setmetatable({
		subscription_id = if t304 ~= nil and t304.subscription_id ~= nil then t304.subscription_id else nil,
		universe_id = if t304 ~= nil and t304.universe_id ~= nil then t304.universe_id else nil,
		creator_name = if t304 ~= nil and t304.creator_name ~= nil then t304.creator_name else nil,
		creator_verified = if t304 ~= nil and t304.creator_verified ~= nil then t304.creator_verified else nil,
		name = if t304 ~= nil and t304.name ~= nil then t304.name else nil,
		description = if t304 ~= nil and t304.description ~= nil then t304.description else nil,
		image_asset_id = if t304 ~= nil and t304.image_asset_id ~= nil then t304.image_asset_id else nil,
		period_type = if t304 ~= nil and t304.period_type ~= nil then t304.period_type else nil,
		is_subscribed = if t304 ~= nil and t304.is_subscribed ~= nil then t304.is_subscribed else nil,
		price_display = if t304 ~= nil and t304.price_display ~= nil then t304.price_display else nil,
		price_in_robux = if t304 ~= nil and t304.price_in_robux ~= nil then t304.price_in_robux else nil,
		price_tier = if t304 ~= nil and t304.price_tier ~= nil then t304.price_tier else nil,
		thumbnail_string = if t304 ~= nil and t304.thumbnail_string ~= nil then t304.thumbnail_string else nil
	}, t303))
end
function t303.encode(p229) -- line: 16011
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n150 = 0

	if p229.subscription_id ~= nil then
		local v2254 = p229.subscription_id:encode()
		local v2255, v2256 = proto.writeTag(buf, n150, 1, proto.wireTypes.lengthDelimited)

		buf, n150 = proto.writeBuffer(v2255, v2256, v2254, buffer.len(v2254))
	end

	if p229.universe_id ~= nil then
		local v2257 = p229.universe_id:encode()
		local v2258, v2259 = proto.writeTag(buf, n150, 2, proto.wireTypes.lengthDelimited)

		buf, n150 = proto.writeBuffer(v2258, v2259, v2257, buffer.len(v2257))
	end

	if p229.creator_name ~= nil then
		local v2260 = p229.creator_name:encode()
		local v2261, v2262 = proto.writeTag(buf, n150, 3, proto.wireTypes.lengthDelimited)

		buf, n150 = proto.writeBuffer(v2261, v2262, v2260, buffer.len(v2260))
	end

	if p229.creator_verified ~= nil then
		local v2263 = p229.creator_verified:encode()
		local v2264, v2265 = proto.writeTag(buf, n150, 4, proto.wireTypes.lengthDelimited)

		buf, n150 = proto.writeBuffer(v2264, v2265, v2263, buffer.len(v2263))
	end

	if p229.name ~= nil then
		local v2266 = p229.name:encode()
		local v2267, v2268 = proto.writeTag(buf, n150, 5, proto.wireTypes.lengthDelimited)

		buf, n150 = proto.writeBuffer(v2267, v2268, v2266, buffer.len(v2266))
	end

	if p229.description ~= nil then
		local v2269 = p229.description:encode()
		local v2270, v2271 = proto.writeTag(buf, n150, 6, proto.wireTypes.lengthDelimited)

		buf, n150 = proto.writeBuffer(v2270, v2271, v2269, buffer.len(v2269))
	end

	if p229.image_asset_id ~= nil then
		local v2272 = p229.image_asset_id:encode()
		local v2273, v2274 = proto.writeTag(buf, n150, 7, proto.wireTypes.lengthDelimited)

		buf, n150 = proto.writeBuffer(v2273, v2274, v2272, buffer.len(v2272))
	end

	if p229.period_type ~= nil then
		local v2275 = p229.period_type:encode()
		local v2276, v2277 = proto.writeTag(buf, n150, 8, proto.wireTypes.lengthDelimited)

		buf, n150 = proto.writeBuffer(v2276, v2277, v2275, buffer.len(v2275))
	end

	if p229.is_subscribed ~= nil then
		local v2278 = p229.is_subscribed:encode()
		local v2279, v2280 = proto.writeTag(buf, n150, 9, proto.wireTypes.lengthDelimited)

		buf, n150 = proto.writeBuffer(v2279, v2280, v2278, buffer.len(v2278))
	end

	if p229.price_display ~= nil then
		local v2281 = p229.price_display:encode()
		local v2282, v2283 = proto.writeTag(buf, n150, 10, proto.wireTypes.lengthDelimited)

		buf, n150 = proto.writeBuffer(v2282, v2283, v2281, buffer.len(v2281))
	end

	if p229.price_in_robux ~= nil then
		local v2284 = p229.price_in_robux:encode()
		local v2285, v2286 = proto.writeTag(buf, n150, 11, proto.wireTypes.lengthDelimited)

		buf, n150 = proto.writeBuffer(v2285, v2286, v2284, buffer.len(v2284))
	end

	if p229.price_tier ~= nil then
		local v2287 = p229.price_tier:encode()
		local v2288, v2289 = proto.writeTag(buf, n150, 12, proto.wireTypes.lengthDelimited)

		buf, n150 = proto.writeBuffer(v2288, v2289, v2287, buffer.len(v2287))
	end

	if p229.thumbnail_string ~= nil then
		local v2290 = p229.thumbnail_string:encode()
		local v2291, v2292 = proto.writeTag(buf, n150, 13, proto.wireTypes.lengthDelimited)

		buf, n150 = proto.writeBuffer(v2291, v2292, v2290, buffer.len(v2290))
	end

	local buf78 = buffer.create(n150)

	buffer.copy(buf78, 0, buf, 0, n150)

	return buf78
end
function t303.decode(p230: buffer) -- line: 16100
	-- upvalues: t303 (copy), proto (copy), prop_types (copy)
	local v2295 = t303.new()
	local n151 = 0

	while n151 < buffer.len(p230) do
		local v2297, v2298

		v2297, v2298, n151 = proto.readTag(p230, n151)

		if v2298 == proto.wireTypes.varint then
			local v2299

			v2299, n151 = proto.readVarInt(p230, n151)
		elseif v2298 == proto.wireTypes.lengthDelimited then
			if v2297 == 1 then
				local v2300

				v2300, n151 = proto.readBuffer(p230, n151)
				v2295.subscription_id = prop_types.StringProp.decode(v2300)
			elseif v2297 == 2 then
				local v2301

				v2301, n151 = proto.readBuffer(p230, n151)
				v2295.universe_id = prop_types.StringProp.decode(v2301)
			elseif v2297 == 3 then
				local v2302

				v2302, n151 = proto.readBuffer(p230, n151)
				v2295.creator_name = prop_types.StringProp.decode(v2302)
			elseif v2297 == 4 then
				local v2303

				v2303, n151 = proto.readBuffer(p230, n151)
				v2295.creator_verified = prop_types.BoolProp.decode(v2303)
			elseif v2297 == 5 then
				local v2304

				v2304, n151 = proto.readBuffer(p230, n151)
				v2295.name = prop_types.StringProp.decode(v2304)
			elseif v2297 == 6 then
				local v2305

				v2305, n151 = proto.readBuffer(p230, n151)
				v2295.description = prop_types.StringProp.decode(v2305)
			elseif v2297 == 7 then
				local v2306

				v2306, n151 = proto.readBuffer(p230, n151)
				v2295.image_asset_id = prop_types.Int64Prop.decode(v2306)
			elseif v2297 == 8 then
				local v2307

				v2307, n151 = proto.readBuffer(p230, n151)
				v2295.period_type = prop_types.StringProp.decode(v2307)
			elseif v2297 == 9 then
				local v2308

				v2308, n151 = proto.readBuffer(p230, n151)
				v2295.is_subscribed = prop_types.BoolProp.decode(v2308)
			elseif v2297 == 10 then
				local v2309

				v2309, n151 = proto.readBuffer(p230, n151)
				v2295.price_display = prop_types.StringProp.decode(v2309)
			elseif v2297 == 11 then
				local v2310

				v2310, n151 = proto.readBuffer(p230, n151)
				v2295.price_in_robux = prop_types.Int64Prop.decode(v2310)
			elseif v2297 == 12 then
				local v2311

				v2311, n151 = proto.readBuffer(p230, n151)
				v2295.price_tier = prop_types.Int64Prop.decode(v2311)
			elseif v2297 == 13 then
				local v2312

				v2312, n151 = proto.readBuffer(p230, n151)
				v2295.thumbnail_string = prop_types.StringProp.decode(v2312)
			else
				local v2313, v2314 = proto.readVarInt(p230, n151)

				n151 = v2314 + v2313
			end
		elseif v2298 == proto.wireTypes.i32 then
			local v2315

			v2315, n151 = proto.readFixed32(p230, n151)
		elseif v2298 == proto.wireTypes.i64 then
			local v2316

			v2316, n151 = proto.readFixed64(p230, n151)
		else
			error("Unsupported wire type: " .. v2298)
		end
	end

	return v2295
end
function t303.jsonEncode(p231) -- line: 16205
	local t305 = {}

	if p231.subscription_id ~= nil then
		t305.subscriptionId = p231.subscription_id:jsonEncode()
	end

	if p231.universe_id ~= nil then
		t305.universeId = p231.universe_id:jsonEncode()
	end

	if p231.creator_name ~= nil then
		t305.creatorName = p231.creator_name:jsonEncode()
	end

	if p231.creator_verified ~= nil then
		t305.creatorVerified = p231.creator_verified:jsonEncode()
	end

	if p231.name ~= nil then
		t305.name = p231.name:jsonEncode()
	end

	if p231.description ~= nil then
		t305.description = p231.description:jsonEncode()
	end

	if p231.image_asset_id ~= nil then
		t305.imageAssetId = p231.image_asset_id:jsonEncode()
	end

	if p231.period_type ~= nil then
		t305.periodType = p231.period_type:jsonEncode()
	end

	if p231.is_subscribed ~= nil then
		t305.isSubscribed = p231.is_subscribed:jsonEncode()
	end

	if p231.price_display ~= nil then
		t305.priceDisplay = p231.price_display:jsonEncode()
	end

	if p231.price_in_robux ~= nil then
		t305.priceInRobux = p231.price_in_robux:jsonEncode()
	end

	if p231.price_tier ~= nil then
		t305.priceTier = p231.price_tier:jsonEncode()
	end

	if p231.thumbnail_string ~= nil then
		t305.thumbnailString = p231.thumbnail_string:jsonEncode()
	end

	return t305
end
function t303.jsonDecode(t306: {[any]: any}) -- line: 16265
	-- upvalues: t303 (copy), prop_types (copy)
	local v2320 = t303.new()

	if t306.subscription_id ~= nil then
		v2320.subscription_id = prop_types.StringProp.jsonDecode(t306.subscription_id)
	end

	if t306.subscriptionId ~= nil then
		v2320.subscription_id = prop_types.StringProp.jsonDecode(t306.subscriptionId)
	end

	if t306.universe_id ~= nil then
		v2320.universe_id = prop_types.StringProp.jsonDecode(t306.universe_id)
	end

	if t306.universeId ~= nil then
		v2320.universe_id = prop_types.StringProp.jsonDecode(t306.universeId)
	end

	if t306.creator_name ~= nil then
		v2320.creator_name = prop_types.StringProp.jsonDecode(t306.creator_name)
	end

	if t306.creatorName ~= nil then
		v2320.creator_name = prop_types.StringProp.jsonDecode(t306.creatorName)
	end

	if t306.creator_verified ~= nil then
		v2320.creator_verified = prop_types.BoolProp.jsonDecode(t306.creator_verified)
	end

	if t306.creatorVerified ~= nil then
		v2320.creator_verified = prop_types.BoolProp.jsonDecode(t306.creatorVerified)
	end

	if t306.name ~= nil then
		v2320.name = prop_types.StringProp.jsonDecode(t306.name)
	end

	if t306.description ~= nil then
		v2320.description = prop_types.StringProp.jsonDecode(t306.description)
	end

	if t306.image_asset_id ~= nil then
		v2320.image_asset_id = prop_types.Int64Prop.jsonDecode(t306.image_asset_id)
	end

	if t306.imageAssetId ~= nil then
		v2320.image_asset_id = prop_types.Int64Prop.jsonDecode(t306.imageAssetId)
	end

	if t306.period_type ~= nil then
		v2320.period_type = prop_types.StringProp.jsonDecode(t306.period_type)
	end

	if t306.periodType ~= nil then
		v2320.period_type = prop_types.StringProp.jsonDecode(t306.periodType)
	end

	if t306.is_subscribed ~= nil then
		v2320.is_subscribed = prop_types.BoolProp.jsonDecode(t306.is_subscribed)
	end

	if t306.isSubscribed ~= nil then
		v2320.is_subscribed = prop_types.BoolProp.jsonDecode(t306.isSubscribed)
	end

	if t306.price_display ~= nil then
		v2320.price_display = prop_types.StringProp.jsonDecode(t306.price_display)
	end

	if t306.priceDisplay ~= nil then
		v2320.price_display = prop_types.StringProp.jsonDecode(t306.priceDisplay)
	end

	if t306.price_in_robux ~= nil then
		v2320.price_in_robux = prop_types.Int64Prop.jsonDecode(t306.price_in_robux)
	end

	if t306.priceInRobux ~= nil then
		v2320.price_in_robux = prop_types.Int64Prop.jsonDecode(t306.priceInRobux)
	end

	if t306.price_tier ~= nil then
		v2320.price_tier = prop_types.Int64Prop.jsonDecode(t306.price_tier)
	end

	if t306.priceTier ~= nil then
		v2320.price_tier = prop_types.Int64Prop.jsonDecode(t306.priceTier)
	end

	if t306.thumbnail_string ~= nil then
		v2320.thumbnail_string = prop_types.StringProp.jsonDecode(t306.thumbnail_string)
	end

	if t306.thumbnailString ~= nil then
		v2320.thumbnail_string = prop_types.StringProp.jsonDecode(t306.thumbnailString)
	end

	return v2320
end

t303.descriptor = {
	name = "OpenSubscriptionPurchasePageAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.OpenSubscriptionPurchasePageAction_Params = t303
typeRegistry.default:register(t1.OpenSubscriptionPurchasePageAction_Params)

local t307 = {}

t307.__index = t307

function t307.new(t308: {[any]: any}?) -- line: 16402
	-- upvalues: t1 (copy), t307 (copy)
	return (setmetatable({
		action_type = if t308 ~= nil and t308.action_type ~= nil then t308.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t308 ~= nil and t308.action_params ~= nil then t308.action_params else nil
	}, t307))
end
function t307.encode(p232) -- line: 16411
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n152 = 0

	if p232.action_type ~= nil and (p232.action_type ~= nil and p232.action_type ~= 0 or p232.action_type ~= t1.ActionType.fromNumber(0)) then
		local v2325, v2326 = proto.writeTag(buf, n152, 1, proto.wireTypes.varint)

		buf, n152 = proto.writeVarInt(v2325, v2326, t1.ActionType.toNumber(p232.action_type))
	end

	if p232.action_params ~= nil then
		local v2327 = p232.action_params:encode()
		local v2328, v2329 = proto.writeTag(buf, n152, 2, proto.wireTypes.lengthDelimited)

		buf, n152 = proto.writeBuffer(v2328, v2329, v2327, buffer.len(v2327))
	end

	local buf79 = buffer.create(n152)

	buffer.copy(buf79, 0, buf, 0, n152)

	return buf79
end
function t307.decode(p233: buffer) -- line: 16437
	-- upvalues: t307 (copy), proto (copy), t1 (copy)
	local v2332 = t307.new()
	local n153 = 0

	while n153 < buffer.len(p233) do
		local v2334, v2335

		v2334, v2335, n153 = proto.readTag(p233, n153)

		if v2335 == proto.wireTypes.varint then
			if v2334 == 1 then
				local v2336

				v2336, n153 = proto.readVarIntI32(p233, n153)
				v2332.action_type = t1.ActionType.fromNumber(v2336) or v2336
			else
				local v2337

				v2337, n153 = proto.readVarInt(p233, n153)
			end
		elseif v2335 == proto.wireTypes.lengthDelimited then
			if v2334 == 2 then
				local v2338

				v2338, n153 = proto.readBuffer(p233, n153)
				v2332.action_params = t1.RefreshGamePassesAction_Params.decode(v2338)
			else
				local v2339, v2340 = proto.readVarInt(p233, n153)

				n153 = v2340 + v2339
			end
		elseif v2335 == proto.wireTypes.i32 then
			local v2341

			v2341, n153 = proto.readFixed32(p233, n153)
		elseif v2335 == proto.wireTypes.i64 then
			local v2342

			v2342, n153 = proto.readFixed64(p233, n153)
		else
			error("Unsupported wire type: " .. v2335)
		end
	end

	return v2332
end
function t307.jsonEncode(p234) -- line: 16485
	-- upvalues: t1 (copy)
	local t309 = {}

	if p234.action_type ~= nil and (p234.action_type ~= nil and p234.action_type ~= 0 or p234.action_type ~= t1.ActionType.fromNumber(0)) then
		t309.actionType = if typeof(p234.action_type) ~= "number" then t1.ActionType.toNumber(p234.action_type) else p234.action_type
	end

	if p234.action_params ~= nil then
		t309.actionParams = p234.action_params:jsonEncode()
	end

	return t309
end
function t307.jsonDecode(t310: {[any]: any}) -- line: 16507
	-- upvalues: t307 (copy), t1 (copy)
	local v2346 = t307.new()

	if t310.action_type ~= nil then
		v2346.action_type = if typeof(t310.action_type) ~= "number" then t1.ActionType.fromName(t310.action_type) or t310.action_type else t1.ActionType.fromNumber(t310.action_type) or t310.action_type
	end

	if t310.actionType ~= nil then
		v2346.action_type = if typeof(t310.actionType) ~= "number" then t1.ActionType.fromName(t310.actionType) or t310.actionType else t1.ActionType.fromNumber(t310.actionType) or t310.actionType
	end

	if t310.action_params ~= nil then
		v2346.action_params = t1.RefreshGamePassesAction_Params.jsonDecode(t310.action_params)
	end

	if t310.actionParams ~= nil then
		v2346.action_params = t1.RefreshGamePassesAction_Params.jsonDecode(t310.actionParams)
	end

	return v2346
end

t307.descriptor = {
	name = "RefreshGamePassesAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.RefreshGamePassesAction"
}
t1.RefreshGamePassesAction = t307
typeRegistry.default:register(t1.RefreshGamePassesAction)

local t311 = {}

t311.__index = t311

function t311.new(t312: {[any]: any}?) -- line: 16547
	-- upvalues: t311 (copy)
	return (setmetatable({
		universe_id = if t312 ~= nil and t312.universe_id ~= nil then t312.universe_id else nil
	}, t311))
end
function t311.encode(p235) -- line: 16555
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n154 = 0

	if p235.universe_id ~= nil then
		local v2351 = p235.universe_id:encode()
		local v2352, v2353 = proto.writeTag(buf, n154, 1, proto.wireTypes.lengthDelimited)

		buf, n154 = proto.writeBuffer(v2352, v2353, v2351, buffer.len(v2351))
	end

	local buf80 = buffer.create(n154)

	buffer.copy(buf80, 0, buf, 0, n154)

	return buf80
end
function t311.decode(p236: buffer) -- line: 16570
	-- upvalues: t311 (copy), proto (copy), prop_types (copy)
	local v2356 = t311.new()
	local n155 = 0

	while n155 < buffer.len(p236) do
		local v2358, v2359

		v2358, v2359, n155 = proto.readTag(p236, n155)

		if v2359 == proto.wireTypes.varint then
			local v2360

			v2360, n155 = proto.readVarInt(p236, n155)
		elseif v2359 == proto.wireTypes.lengthDelimited then
			if v2358 == 1 then
				local v2361

				v2361, n155 = proto.readBuffer(p236, n155)
				v2356.universe_id = prop_types.StringProp.decode(v2361)
			else
				local v2362, v2363 = proto.readVarInt(p236, n155)

				n155 = v2363 + v2362
			end
		elseif v2359 == proto.wireTypes.i32 then
			local v2364

			v2364, n155 = proto.readFixed32(p236, n155)
		elseif v2359 == proto.wireTypes.i64 then
			local v2365

			v2365, n155 = proto.readFixed64(p236, n155)
		else
			error("Unsupported wire type: " .. v2359)
		end
	end

	return v2356
end
function t311.jsonEncode(p237) -- line: 16613
	local t313 = {}

	if p237.universe_id ~= nil then
		t313.universeId = p237.universe_id:jsonEncode()
	end

	return t313
end
function t311.jsonDecode(t314: {[any]: any}) -- line: 16623
	-- upvalues: t311 (copy), prop_types (copy)
	local v2369 = t311.new()

	if t314.universe_id ~= nil then
		v2369.universe_id = prop_types.StringProp.jsonDecode(t314.universe_id)
	end

	if t314.universeId ~= nil then
		v2369.universe_id = prop_types.StringProp.jsonDecode(t314.universeId)
	end

	return v2369
end

t311.descriptor = {
	name = "RefreshGamePassesAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.RefreshGamePassesAction_Params = t311
typeRegistry.default:register(t1.RefreshGamePassesAction_Params)

local t315 = {}

t315.__index = t315

function t315.new(t316: {[any]: any}?) -- line: 16652
	-- upvalues: t1 (copy), t315 (copy)
	return (setmetatable({
		action_type = if t316 ~= nil and t316.action_type ~= nil then t316.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t316 ~= nil and t316.action_params ~= nil then t316.action_params else nil
	}, t315))
end
function t315.encode(p238) -- line: 16661
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n156 = 0

	if p238.action_type ~= nil and (p238.action_type ~= nil and p238.action_type ~= 0 or p238.action_type ~= t1.ActionType.fromNumber(0)) then
		local v2374, v2375 = proto.writeTag(buf, n156, 1, proto.wireTypes.varint)

		buf, n156 = proto.writeVarInt(v2374, v2375, t1.ActionType.toNumber(p238.action_type))
	end

	if p238.action_params ~= nil then
		local v2376 = p238.action_params:encode()
		local v2377, v2378 = proto.writeTag(buf, n156, 2, proto.wireTypes.lengthDelimited)

		buf, n156 = proto.writeBuffer(v2377, v2378, v2376, buffer.len(v2376))
	end

	local buf81 = buffer.create(n156)

	buffer.copy(buf81, 0, buf, 0, n156)

	return buf81
end
function t315.decode(p239: buffer) -- line: 16687
	-- upvalues: t315 (copy), proto (copy), t1 (copy)
	local v2381 = t315.new()
	local n157 = 0

	while n157 < buffer.len(p239) do
		local v2383, v2384

		v2383, v2384, n157 = proto.readTag(p239, n157)

		if v2384 == proto.wireTypes.varint then
			if v2383 == 1 then
				local v2385

				v2385, n157 = proto.readVarIntI32(p239, n157)
				v2381.action_type = t1.ActionType.fromNumber(v2385) or v2385
			else
				local v2386

				v2386, n157 = proto.readVarInt(p239, n157)
			end
		elseif v2384 == proto.wireTypes.lengthDelimited then
			if v2383 == 2 then
				local v2387

				v2387, n157 = proto.readBuffer(p239, n157)
				v2381.action_params = t1.RefreshPlayabilityAction_Params.decode(v2387)
			else
				local v2388, v2389 = proto.readVarInt(p239, n157)

				n157 = v2389 + v2388
			end
		elseif v2384 == proto.wireTypes.i32 then
			local v2390

			v2390, n157 = proto.readFixed32(p239, n157)
		elseif v2384 == proto.wireTypes.i64 then
			local v2391

			v2391, n157 = proto.readFixed64(p239, n157)
		else
			error("Unsupported wire type: " .. v2384)
		end
	end

	return v2381
end
function t315.jsonEncode(p240) -- line: 16735
	-- upvalues: t1 (copy)
	local t317 = {}

	if p240.action_type ~= nil and (p240.action_type ~= nil and p240.action_type ~= 0 or p240.action_type ~= t1.ActionType.fromNumber(0)) then
		t317.actionType = if typeof(p240.action_type) ~= "number" then t1.ActionType.toNumber(p240.action_type) else p240.action_type
	end

	if p240.action_params ~= nil then
		t317.actionParams = p240.action_params:jsonEncode()
	end

	return t317
end
function t315.jsonDecode(t318: {[any]: any}) -- line: 16757
	-- upvalues: t315 (copy), t1 (copy)
	local v2395 = t315.new()

	if t318.action_type ~= nil then
		v2395.action_type = if typeof(t318.action_type) ~= "number" then t1.ActionType.fromName(t318.action_type) or t318.action_type else t1.ActionType.fromNumber(t318.action_type) or t318.action_type
	end

	if t318.actionType ~= nil then
		v2395.action_type = if typeof(t318.actionType) ~= "number" then t1.ActionType.fromName(t318.actionType) or t318.actionType else t1.ActionType.fromNumber(t318.actionType) or t318.actionType
	end

	if t318.action_params ~= nil then
		v2395.action_params = t1.RefreshPlayabilityAction_Params.jsonDecode(t318.action_params)
	end

	if t318.actionParams ~= nil then
		v2395.action_params = t1.RefreshPlayabilityAction_Params.jsonDecode(t318.actionParams)
	end

	return v2395
end

t315.descriptor = {
	name = "RefreshPlayabilityAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.RefreshPlayabilityAction"
}
t1.RefreshPlayabilityAction = t315
typeRegistry.default:register(t1.RefreshPlayabilityAction)

local t319 = {}

t319.__index = t319

function t319.new(t320: {[any]: any}?) -- line: 16797
	-- upvalues: t319 (copy)
	return (setmetatable({
		universe_id = if t320 ~= nil and t320.universe_id ~= nil then t320.universe_id else nil
	}, t319))
end
function t319.encode(p241) -- line: 16805
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n158 = 0

	if p241.universe_id ~= nil then
		local v2400 = p241.universe_id:encode()
		local v2401, v2402 = proto.writeTag(buf, n158, 1, proto.wireTypes.lengthDelimited)

		buf, n158 = proto.writeBuffer(v2401, v2402, v2400, buffer.len(v2400))
	end

	local buf82 = buffer.create(n158)

	buffer.copy(buf82, 0, buf, 0, n158)

	return buf82
end
function t319.decode(p242: buffer) -- line: 16820
	-- upvalues: t319 (copy), proto (copy), prop_types (copy)
	local v2405 = t319.new()
	local n159 = 0

	while n159 < buffer.len(p242) do
		local v2407, v2408

		v2407, v2408, n159 = proto.readTag(p242, n159)

		if v2408 == proto.wireTypes.varint then
			local v2409

			v2409, n159 = proto.readVarInt(p242, n159)
		elseif v2408 == proto.wireTypes.lengthDelimited then
			if v2407 == 1 then
				local v2410

				v2410, n159 = proto.readBuffer(p242, n159)
				v2405.universe_id = prop_types.StringProp.decode(v2410)
			else
				local v2411, v2412 = proto.readVarInt(p242, n159)

				n159 = v2412 + v2411
			end
		elseif v2408 == proto.wireTypes.i32 then
			local v2413

			v2413, n159 = proto.readFixed32(p242, n159)
		elseif v2408 == proto.wireTypes.i64 then
			local v2414

			v2414, n159 = proto.readFixed64(p242, n159)
		else
			error("Unsupported wire type: " .. v2408)
		end
	end

	return v2405
end
function t319.jsonEncode(p243) -- line: 16863
	local t321 = {}

	if p243.universe_id ~= nil then
		t321.universeId = p243.universe_id:jsonEncode()
	end

	return t321
end
function t319.jsonDecode(t322: {[any]: any}) -- line: 16873
	-- upvalues: t319 (copy), prop_types (copy)
	local v2418 = t319.new()

	if t322.universe_id ~= nil then
		v2418.universe_id = prop_types.StringProp.jsonDecode(t322.universe_id)
	end

	if t322.universeId ~= nil then
		v2418.universe_id = prop_types.StringProp.jsonDecode(t322.universeId)
	end

	return v2418
end

t319.descriptor = {
	name = "RefreshPlayabilityAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.RefreshPlayabilityAction_Params = t319
typeRegistry.default:register(t1.RefreshPlayabilityAction_Params)

local t323 = {}

t323.__index = t323

function t323.new(t324: {[any]: any}?) -- line: 16902
	-- upvalues: t1 (copy), t323 (copy)
	return (setmetatable({
		action_type = if t324 ~= nil and t324.action_type ~= nil then t324.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t324 ~= nil and t324.action_params ~= nil then t324.action_params else nil
	}, t323))
end
function t323.encode(p244) -- line: 16913
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n160 = 0

	if p244.action_type ~= nil and (p244.action_type ~= nil and p244.action_type ~= 0 or p244.action_type ~= t1.ActionType.fromNumber(0)) then
		local v2423, v2424 = proto.writeTag(buf, n160, 1, proto.wireTypes.varint)

		buf, n160 = proto.writeVarInt(v2423, v2424, t1.ActionType.toNumber(p244.action_type))
	end

	if p244.action_params ~= nil then
		local v2425 = p244.action_params:encode()
		local v2426, v2427 = proto.writeTag(buf, n160, 2, proto.wireTypes.lengthDelimited)

		buf, n160 = proto.writeBuffer(v2426, v2427, v2425, buffer.len(v2425))
	end

	local buf83 = buffer.create(n160)

	buffer.copy(buf83, 0, buf, 0, n160)

	return buf83
end
function t323.decode(p245: buffer) -- line: 16939
	-- upvalues: t323 (copy), proto (copy), t1 (copy)
	local v2430 = t323.new()
	local n161 = 0

	while n161 < buffer.len(p245) do
		local v2432, v2433

		v2432, v2433, n161 = proto.readTag(p245, n161)

		if v2433 == proto.wireTypes.varint then
			if v2432 == 1 then
				local v2434

				v2434, n161 = proto.readVarIntI32(p245, n161)
				v2430.action_type = t1.ActionType.fromNumber(v2434) or v2434
			else
				local v2435

				v2435, n161 = proto.readVarInt(p245, n161)
			end
		elseif v2433 == proto.wireTypes.lengthDelimited then
			if v2432 == 2 then
				local v2436

				v2436, n161 = proto.readBuffer(p245, n161)
				v2430.action_params = t1.RefreshDeveloperProductsAction_Params.decode(v2436)
			else
				local v2437, v2438 = proto.readVarInt(p245, n161)

				n161 = v2438 + v2437
			end
		elseif v2433 == proto.wireTypes.i32 then
			local v2439

			v2439, n161 = proto.readFixed32(p245, n161)
		elseif v2433 == proto.wireTypes.i64 then
			local v2440

			v2440, n161 = proto.readFixed64(p245, n161)
		else
			error("Unsupported wire type: " .. v2433)
		end
	end

	return v2430
end
function t323.jsonEncode(p246) -- line: 16987
	-- upvalues: t1 (copy)
	local t325 = {}

	if p246.action_type ~= nil and (p246.action_type ~= nil and p246.action_type ~= 0 or p246.action_type ~= t1.ActionType.fromNumber(0)) then
		t325.actionType = if typeof(p246.action_type) ~= "number" then t1.ActionType.toNumber(p246.action_type) else p246.action_type
	end

	if p246.action_params ~= nil then
		t325.actionParams = p246.action_params:jsonEncode()
	end

	return t325
end
function t323.jsonDecode(t326: {[any]: any}) -- line: 17009
	-- upvalues: t323 (copy), t1 (copy)
	local v2444 = t323.new()

	if t326.action_type ~= nil then
		v2444.action_type = if typeof(t326.action_type) ~= "number" then t1.ActionType.fromName(t326.action_type) or t326.action_type else t1.ActionType.fromNumber(t326.action_type) or t326.action_type
	end

	if t326.actionType ~= nil then
		v2444.action_type = if typeof(t326.actionType) ~= "number" then t1.ActionType.fromName(t326.actionType) or t326.actionType else t1.ActionType.fromNumber(t326.actionType) or t326.actionType
	end

	if t326.action_params ~= nil then
		v2444.action_params = t1.RefreshDeveloperProductsAction_Params.jsonDecode(t326.action_params)
	end

	if t326.actionParams ~= nil then
		v2444.action_params = t1.RefreshDeveloperProductsAction_Params.jsonDecode(t326.actionParams)
	end

	return v2444
end

t323.descriptor = {
	name = "RefreshDeveloperProductsAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.RefreshDeveloperProductsAction"
}
t1.RefreshDeveloperProductsAction = t323
typeRegistry.default:register(t1.RefreshDeveloperProductsAction)

local t327 = {}

t327.__index = t327

function t327.new(t328: {[any]: any}?) -- line: 17049
	-- upvalues: t327 (copy)
	return (setmetatable({
		place_id = if t328 ~= nil and t328.place_id ~= nil then t328.place_id else nil
	}, t327))
end
function t327.encode(p247) -- line: 17057
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n162 = 0

	if p247.place_id ~= nil then
		local v2449 = p247.place_id:encode()
		local v2450, v2451 = proto.writeTag(buf, n162, 1, proto.wireTypes.lengthDelimited)

		buf, n162 = proto.writeBuffer(v2450, v2451, v2449, buffer.len(v2449))
	end

	local buf84 = buffer.create(n162)

	buffer.copy(buf84, 0, buf, 0, n162)

	return buf84
end
function t327.decode(p248: buffer) -- line: 17072
	-- upvalues: t327 (copy), proto (copy), prop_types (copy)
	local v2454 = t327.new()
	local n163 = 0

	while n163 < buffer.len(p248) do
		local v2456, v2457

		v2456, v2457, n163 = proto.readTag(p248, n163)

		if v2457 == proto.wireTypes.varint then
			local v2458

			v2458, n163 = proto.readVarInt(p248, n163)
		elseif v2457 == proto.wireTypes.lengthDelimited then
			if v2456 == 1 then
				local v2459

				v2459, n163 = proto.readBuffer(p248, n163)
				v2454.place_id = prop_types.StringProp.decode(v2459)
			else
				local v2460, v2461 = proto.readVarInt(p248, n163)

				n163 = v2461 + v2460
			end
		elseif v2457 == proto.wireTypes.i32 then
			local v2462

			v2462, n163 = proto.readFixed32(p248, n163)
		elseif v2457 == proto.wireTypes.i64 then
			local v2463

			v2463, n163 = proto.readFixed64(p248, n163)
		else
			error("Unsupported wire type: " .. v2457)
		end
	end

	return v2454
end
function t327.jsonEncode(p249) -- line: 17115
	local t329 = {}

	if p249.place_id ~= nil then
		t329.placeId = p249.place_id:jsonEncode()
	end

	return t329
end
function t327.jsonDecode(t330: {[any]: any}) -- line: 17125
	-- upvalues: t327 (copy), prop_types (copy)
	local v2467 = t327.new()

	if t330.place_id ~= nil then
		v2467.place_id = prop_types.StringProp.jsonDecode(t330.place_id)
	end

	if t330.placeId ~= nil then
		v2467.place_id = prop_types.StringProp.jsonDecode(t330.placeId)
	end

	return v2467
end

t327.descriptor = {
	name = "RefreshDeveloperProductsAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.RefreshDeveloperProductsAction_Params = t327
typeRegistry.default:register(t1.RefreshDeveloperProductsAction_Params)

local t331 = {}

t331.__index = t331

function t331.new(t332: {[any]: any}?) -- line: 17155
	-- upvalues: t1 (copy), t331 (copy)
	return (setmetatable({
		action_type = if t332 ~= nil and t332.action_type ~= nil then t332.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t332 ~= nil and t332.action_params ~= nil then t332.action_params else nil
	}, t331))
end
function t331.encode(p250) -- line: 17164
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n164 = 0

	if p250.action_type ~= nil and (p250.action_type ~= nil and p250.action_type ~= 0 or p250.action_type ~= t1.ActionType.fromNumber(0)) then
		local v2472, v2473 = proto.writeTag(buf, n164, 1, proto.wireTypes.varint)

		buf, n164 = proto.writeVarInt(v2472, v2473, t1.ActionType.toNumber(p250.action_type))
	end

	if p250.action_params ~= nil then
		local v2474 = p250.action_params:encode()
		local v2475, v2476 = proto.writeTag(buf, n164, 2, proto.wireTypes.lengthDelimited)

		buf, n164 = proto.writeBuffer(v2475, v2476, v2474, buffer.len(v2474))
	end

	local buf85 = buffer.create(n164)

	buffer.copy(buf85, 0, buf, 0, n164)

	return buf85
end
function t331.decode(p251: buffer) -- line: 17190
	-- upvalues: t331 (copy), proto (copy), t1 (copy)
	local v2479 = t331.new()
	local n165 = 0

	while n165 < buffer.len(p251) do
		local v2481, v2482

		v2481, v2482, n165 = proto.readTag(p251, n165)

		if v2482 == proto.wireTypes.varint then
			if v2481 == 1 then
				local v2483

				v2483, n165 = proto.readVarIntI32(p251, n165)
				v2479.action_type = t1.ActionType.fromNumber(v2483) or v2483
			else
				local v2484

				v2484, n165 = proto.readVarInt(p251, n165)
			end
		elseif v2482 == proto.wireTypes.lengthDelimited then
			if v2481 == 2 then
				local v2485

				v2485, n165 = proto.readBuffer(p251, n165)
				v2479.action_params = t1.OpenFaeTrialUpsellAction_Params.decode(v2485)
			else
				local v2486, v2487 = proto.readVarInt(p251, n165)

				n165 = v2487 + v2486
			end
		elseif v2482 == proto.wireTypes.i32 then
			local v2488

			v2488, n165 = proto.readFixed32(p251, n165)
		elseif v2482 == proto.wireTypes.i64 then
			local v2489

			v2489, n165 = proto.readFixed64(p251, n165)
		else
			error("Unsupported wire type: " .. v2482)
		end
	end

	return v2479
end
function t331.jsonEncode(p252) -- line: 17238
	-- upvalues: t1 (copy)
	local t333 = {}

	if p252.action_type ~= nil and (p252.action_type ~= nil and p252.action_type ~= 0 or p252.action_type ~= t1.ActionType.fromNumber(0)) then
		t333.actionType = if typeof(p252.action_type) ~= "number" then t1.ActionType.toNumber(p252.action_type) else p252.action_type
	end

	if p252.action_params ~= nil then
		t333.actionParams = p252.action_params:jsonEncode()
	end

	return t333
end
function t331.jsonDecode(t334: {[any]: any}) -- line: 17260
	-- upvalues: t331 (copy), t1 (copy)
	local v2493 = t331.new()

	if t334.action_type ~= nil then
		v2493.action_type = if typeof(t334.action_type) ~= "number" then t1.ActionType.fromName(t334.action_type) or t334.action_type else t1.ActionType.fromNumber(t334.action_type) or t334.action_type
	end

	if t334.actionType ~= nil then
		v2493.action_type = if typeof(t334.actionType) ~= "number" then t1.ActionType.fromName(t334.actionType) or t334.actionType else t1.ActionType.fromNumber(t334.actionType) or t334.actionType
	end

	if t334.action_params ~= nil then
		v2493.action_params = t1.OpenFaeTrialUpsellAction_Params.jsonDecode(t334.action_params)
	end

	if t334.actionParams ~= nil then
		v2493.action_params = t1.OpenFaeTrialUpsellAction_Params.jsonDecode(t334.actionParams)
	end

	return v2493
end

t331.descriptor = {
	name = "OpenFaeTrialUpsellAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.OpenFaeTrialUpsellAction"
}
t1.OpenFaeTrialUpsellAction = t331
typeRegistry.default:register(t1.OpenFaeTrialUpsellAction)

local t335 = {}

t335.__index = t335

function t335.new(t336: {[any]: any}?) -- line: 17300
	-- upvalues: t335 (copy)
	return (setmetatable({
		source = if t336 ~= nil and t336.source ~= nil then t336.source else nil
	}, t335))
end
function t335.encode(p253) -- line: 17308
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n166 = 0

	if p253.source ~= nil then
		local v2498 = p253.source:encode()
		local v2499, v2500 = proto.writeTag(buf, n166, 1, proto.wireTypes.lengthDelimited)

		buf, n166 = proto.writeBuffer(v2499, v2500, v2498, buffer.len(v2498))
	end

	local buf86 = buffer.create(n166)

	buffer.copy(buf86, 0, buf, 0, n166)

	return buf86
end
function t335.decode(p254: buffer) -- line: 17323
	-- upvalues: t335 (copy), proto (copy), prop_types (copy)
	local v2503 = t335.new()
	local n167 = 0

	while n167 < buffer.len(p254) do
		local v2505, v2506

		v2505, v2506, n167 = proto.readTag(p254, n167)

		if v2506 == proto.wireTypes.varint then
			local v2507

			v2507, n167 = proto.readVarInt(p254, n167)
		elseif v2506 == proto.wireTypes.lengthDelimited then
			if v2505 == 1 then
				local v2508

				v2508, n167 = proto.readBuffer(p254, n167)
				v2503.source = prop_types.StringProp.decode(v2508)
			else
				local v2509, v2510 = proto.readVarInt(p254, n167)

				n167 = v2510 + v2509
			end
		elseif v2506 == proto.wireTypes.i32 then
			local v2511

			v2511, n167 = proto.readFixed32(p254, n167)
		elseif v2506 == proto.wireTypes.i64 then
			local v2512

			v2512, n167 = proto.readFixed64(p254, n167)
		else
			error("Unsupported wire type: " .. v2506)
		end
	end

	return v2503
end
function t335.jsonEncode(p255) -- line: 17366
	local t337 = {}

	if p255.source ~= nil then
		t337.source = p255.source:jsonEncode()
	end

	return t337
end
function t335.jsonDecode(t338: {[any]: any}) -- line: 17376
	-- upvalues: t335 (copy), prop_types (copy)
	local v2516 = t335.new()

	if t338.source ~= nil then
		v2516.source = prop_types.StringProp.jsonDecode(t338.source)
	end

	return v2516
end

t335.descriptor = {
	name = "OpenFaeTrialUpsellAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.OpenFaeTrialUpsellAction_Params = t335
typeRegistry.default:register(t1.OpenFaeTrialUpsellAction_Params)

local t339 = {}

t339.__index = t339

function t339.new(t340: {[any]: any}?) -- line: 17400
	-- upvalues: t1 (copy), t339 (copy)
	return (setmetatable({
		action_type = if t340 ~= nil and t340.action_type ~= nil then t340.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t340 ~= nil and t340.action_params ~= nil then t340.action_params else nil
	}, t339))
end
function t339.encode(p256) -- line: 17409
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n168 = 0

	if p256.action_type ~= nil and (p256.action_type ~= nil and p256.action_type ~= 0 or p256.action_type ~= t1.ActionType.fromNumber(0)) then
		local v2521, v2522 = proto.writeTag(buf, n168, 1, proto.wireTypes.varint)

		buf, n168 = proto.writeVarInt(v2521, v2522, t1.ActionType.toNumber(p256.action_type))
	end

	if p256.action_params ~= nil then
		local v2523 = p256.action_params:encode()
		local v2524, v2525 = proto.writeTag(buf, n168, 2, proto.wireTypes.lengthDelimited)

		buf, n168 = proto.writeBuffer(v2524, v2525, v2523, buffer.len(v2523))
	end

	local buf87 = buffer.create(n168)

	buffer.copy(buf87, 0, buf, 0, n168)

	return buf87
end
function t339.decode(p257: buffer) -- line: 17435
	-- upvalues: t339 (copy), proto (copy), t1 (copy)
	local v2528 = t339.new()
	local n169 = 0

	while n169 < buffer.len(p257) do
		local v2530, v2531

		v2530, v2531, n169 = proto.readTag(p257, n169)

		if v2531 == proto.wireTypes.varint then
			if v2530 == 1 then
				local v2532

				v2532, n169 = proto.readVarIntI32(p257, n169)
				v2528.action_type = t1.ActionType.fromNumber(v2532) or v2532
			else
				local v2533

				v2533, n169 = proto.readVarInt(p257, n169)
			end
		elseif v2531 == proto.wireTypes.lengthDelimited then
			if v2530 == 2 then
				local v2534

				v2534, n169 = proto.readBuffer(p257, n169)
				v2528.action_params = t1.OpenSduiOverlayAction_Params.decode(v2534)
			else
				local v2535, v2536 = proto.readVarInt(p257, n169)

				n169 = v2536 + v2535
			end
		elseif v2531 == proto.wireTypes.i32 then
			local v2537

			v2537, n169 = proto.readFixed32(p257, n169)
		elseif v2531 == proto.wireTypes.i64 then
			local v2538

			v2538, n169 = proto.readFixed64(p257, n169)
		else
			error("Unsupported wire type: " .. v2531)
		end
	end

	return v2528
end
function t339.jsonEncode(p258) -- line: 17483
	-- upvalues: t1 (copy)
	local t341 = {}

	if p258.action_type ~= nil and (p258.action_type ~= nil and p258.action_type ~= 0 or p258.action_type ~= t1.ActionType.fromNumber(0)) then
		t341.actionType = if typeof(p258.action_type) ~= "number" then t1.ActionType.toNumber(p258.action_type) else p258.action_type
	end

	if p258.action_params ~= nil then
		t341.actionParams = p258.action_params:jsonEncode()
	end

	return t341
end
function t339.jsonDecode(t342: {[any]: any}) -- line: 17505
	-- upvalues: t339 (copy), t1 (copy)
	local v2542 = t339.new()

	if t342.action_type ~= nil then
		v2542.action_type = if typeof(t342.action_type) ~= "number" then t1.ActionType.fromName(t342.action_type) or t342.action_type else t1.ActionType.fromNumber(t342.action_type) or t342.action_type
	end

	if t342.actionType ~= nil then
		v2542.action_type = if typeof(t342.actionType) ~= "number" then t1.ActionType.fromName(t342.actionType) or t342.actionType else t1.ActionType.fromNumber(t342.actionType) or t342.actionType
	end

	if t342.action_params ~= nil then
		v2542.action_params = t1.OpenSduiOverlayAction_Params.jsonDecode(t342.action_params)
	end

	if t342.actionParams ~= nil then
		v2542.action_params = t1.OpenSduiOverlayAction_Params.jsonDecode(t342.actionParams)
	end

	return v2542
end

t339.descriptor = {
	name = "OpenSduiOverlayAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.OpenSduiOverlayAction"
}
t1.OpenSduiOverlayAction = t339
typeRegistry.default:register(t1.OpenSduiOverlayAction)

local t343 = {}

t343.__index = t343

function t343.new(t344: {[any]: any}?) -- line: 17545
	-- upvalues: t343 (copy)
	return (setmetatable({
		config_key = if t344 ~= nil and t344.config_key ~= nil then t344.config_key else nil,
		identifier = if t344 ~= nil and t344.identifier ~= nil then t344.identifier else nil
	}, t343))
end
function t343.encode(p259) -- line: 17554
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n170 = 0

	if p259.config_key ~= nil then
		local v2547 = p259.config_key:encode()
		local v2548, v2549 = proto.writeTag(buf, n170, 1, proto.wireTypes.lengthDelimited)

		buf, n170 = proto.writeBuffer(v2548, v2549, v2547, buffer.len(v2547))
	end

	if p259.identifier ~= nil then
		local v2550 = p259.identifier:encode()
		local v2551, v2552 = proto.writeTag(buf, n170, 2, proto.wireTypes.lengthDelimited)

		buf, n170 = proto.writeBuffer(v2551, v2552, v2550, buffer.len(v2550))
	end

	local buf88 = buffer.create(n170)

	buffer.copy(buf88, 0, buf, 0, n170)

	return buf88
end
function t343.decode(p260: buffer) -- line: 17575
	-- upvalues: t343 (copy), proto (copy), prop_types (copy)
	local v2555 = t343.new()
	local n171 = 0

	while n171 < buffer.len(p260) do
		local v2557, v2558

		v2557, v2558, n171 = proto.readTag(p260, n171)

		if v2558 == proto.wireTypes.varint then
			local v2559

			v2559, n171 = proto.readVarInt(p260, n171)
		elseif v2558 == proto.wireTypes.lengthDelimited then
			if v2557 == 1 then
				local v2560

				v2560, n171 = proto.readBuffer(p260, n171)
				v2555.config_key = prop_types.StringProp.decode(v2560)
			elseif v2557 == 2 then
				local v2561

				v2561, n171 = proto.readBuffer(p260, n171)
				v2555.identifier = prop_types.StringProp.decode(v2561)
			else
				local v2562, v2563 = proto.readVarInt(p260, n171)

				n171 = v2563 + v2562
			end
		elseif v2558 == proto.wireTypes.i32 then
			local v2564

			v2564, n171 = proto.readFixed32(p260, n171)
		elseif v2558 == proto.wireTypes.i64 then
			local v2565

			v2565, n171 = proto.readFixed64(p260, n171)
		else
			error("Unsupported wire type: " .. v2558)
		end
	end

	return v2555
end
function t343.jsonEncode(p261) -- line: 17623
	local t345 = {}

	if p261.config_key ~= nil then
		t345.configKey = p261.config_key:jsonEncode()
	end

	if p261.identifier ~= nil then
		t345.identifier = p261.identifier:jsonEncode()
	end

	return t345
end
function t343.jsonDecode(t346: {[any]: any}) -- line: 17637
	-- upvalues: t343 (copy), prop_types (copy)
	local v2569 = t343.new()

	if t346.config_key ~= nil then
		v2569.config_key = prop_types.StringProp.jsonDecode(t346.config_key)
	end

	if t346.configKey ~= nil then
		v2569.config_key = prop_types.StringProp.jsonDecode(t346.configKey)
	end

	if t346.identifier ~= nil then
		v2569.identifier = prop_types.StringProp.jsonDecode(t346.identifier)
	end

	return v2569
end

t343.descriptor = {
	name = "OpenSduiOverlayAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.OpenSduiOverlayAction_Params = t343
typeRegistry.default:register(t1.OpenSduiOverlayAction_Params)

local t347 = {}

t347.__index = t347

function t347.new(t348: {[any]: any}?) -- line: 17669
	-- upvalues: t1 (copy), t347 (copy)
	return (setmetatable({
		action_type = if t348 ~= nil and t348.action_type ~= nil then t348.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t348 ~= nil and t348.action_params ~= nil then t348.action_params else nil
	}, t347))
end
function t347.encode(p262) -- line: 17678
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n172 = 0

	if p262.action_type ~= nil and (p262.action_type ~= nil and p262.action_type ~= 0 or p262.action_type ~= t1.ActionType.fromNumber(0)) then
		local v2574, v2575 = proto.writeTag(buf, n172, 1, proto.wireTypes.varint)

		buf, n172 = proto.writeVarInt(v2574, v2575, t1.ActionType.toNumber(p262.action_type))
	end

	if p262.action_params ~= nil then
		local v2576 = p262.action_params:encode()
		local v2577, v2578 = proto.writeTag(buf, n172, 2, proto.wireTypes.lengthDelimited)

		buf, n172 = proto.writeBuffer(v2577, v2578, v2576, buffer.len(v2576))
	end

	local buf89 = buffer.create(n172)

	buffer.copy(buf89, 0, buf, 0, n172)

	return buf89
end
function t347.decode(p263: buffer) -- line: 17704
	-- upvalues: t347 (copy), proto (copy), t1 (copy)
	local v2581 = t347.new()
	local n173 = 0

	while n173 < buffer.len(p263) do
		local v2583, v2584

		v2583, v2584, n173 = proto.readTag(p263, n173)

		if v2584 == proto.wireTypes.varint then
			if v2583 == 1 then
				local v2585

				v2585, n173 = proto.readVarIntI32(p263, n173)
				v2581.action_type = t1.ActionType.fromNumber(v2585) or v2585
			else
				local v2586

				v2586, n173 = proto.readVarInt(p263, n173)
			end
		elseif v2584 == proto.wireTypes.lengthDelimited then
			if v2583 == 2 then
				local v2587

				v2587, n173 = proto.readBuffer(p263, n173)
				v2581.action_params = t1.ApplyChartsFilterAction_Params.decode(v2587)
			else
				local v2588, v2589 = proto.readVarInt(p263, n173)

				n173 = v2589 + v2588
			end
		elseif v2584 == proto.wireTypes.i32 then
			local v2590

			v2590, n173 = proto.readFixed32(p263, n173)
		elseif v2584 == proto.wireTypes.i64 then
			local v2591

			v2591, n173 = proto.readFixed64(p263, n173)
		else
			error("Unsupported wire type: " .. v2584)
		end
	end

	return v2581
end
function t347.jsonEncode(p264) -- line: 17752
	-- upvalues: t1 (copy)
	local t349 = {}

	if p264.action_type ~= nil and (p264.action_type ~= nil and p264.action_type ~= 0 or p264.action_type ~= t1.ActionType.fromNumber(0)) then
		t349.actionType = if typeof(p264.action_type) ~= "number" then t1.ActionType.toNumber(p264.action_type) else p264.action_type
	end

	if p264.action_params ~= nil then
		t349.actionParams = p264.action_params:jsonEncode()
	end

	return t349
end
function t347.jsonDecode(t350: {[any]: any}) -- line: 17774
	-- upvalues: t347 (copy), t1 (copy)
	local v2595 = t347.new()

	if t350.action_type ~= nil then
		v2595.action_type = if typeof(t350.action_type) ~= "number" then t1.ActionType.fromName(t350.action_type) or t350.action_type else t1.ActionType.fromNumber(t350.action_type) or t350.action_type
	end

	if t350.actionType ~= nil then
		v2595.action_type = if typeof(t350.actionType) ~= "number" then t1.ActionType.fromName(t350.actionType) or t350.actionType else t1.ActionType.fromNumber(t350.actionType) or t350.actionType
	end

	if t350.action_params ~= nil then
		v2595.action_params = t1.ApplyChartsFilterAction_Params.jsonDecode(t350.action_params)
	end

	if t350.actionParams ~= nil then
		v2595.action_params = t1.ApplyChartsFilterAction_Params.jsonDecode(t350.actionParams)
	end

	return v2595
end

t347.descriptor = {
	name = "ApplyChartsFilterAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.ApplyChartsFilterAction"
}
t1.ApplyChartsFilterAction = t347
typeRegistry.default:register(t1.ApplyChartsFilterAction)

local t351 = {}

t351.__index = t351

function t351.new(t352: {[any]: any}?) -- line: 17814
	-- upvalues: t351 (copy)
	return (setmetatable({
		session_id = if t352 ~= nil and t352.session_id ~= nil then t352.session_id else nil
	}, t351))
end
function t351.encode(p265) -- line: 17822
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n174 = 0

	if p265.session_id ~= nil then
		local v2600 = p265.session_id:encode()
		local v2601, v2602 = proto.writeTag(buf, n174, 1, proto.wireTypes.lengthDelimited)

		buf, n174 = proto.writeBuffer(v2601, v2602, v2600, buffer.len(v2600))
	end

	local buf90 = buffer.create(n174)

	buffer.copy(buf90, 0, buf, 0, n174)

	return buf90
end
function t351.decode(p266: buffer) -- line: 17837
	-- upvalues: t351 (copy), proto (copy), prop_types (copy)
	local v2605 = t351.new()
	local n175 = 0

	while n175 < buffer.len(p266) do
		local v2607, v2608

		v2607, v2608, n175 = proto.readTag(p266, n175)

		if v2608 == proto.wireTypes.varint then
			local v2609

			v2609, n175 = proto.readVarInt(p266, n175)
		elseif v2608 == proto.wireTypes.lengthDelimited then
			if v2607 == 1 then
				local v2610

				v2610, n175 = proto.readBuffer(p266, n175)
				v2605.session_id = prop_types.StringProp.decode(v2610)
			else
				local v2611, v2612 = proto.readVarInt(p266, n175)

				n175 = v2612 + v2611
			end
		elseif v2608 == proto.wireTypes.i32 then
			local v2613

			v2613, n175 = proto.readFixed32(p266, n175)
		elseif v2608 == proto.wireTypes.i64 then
			local v2614

			v2614, n175 = proto.readFixed64(p266, n175)
		else
			error("Unsupported wire type: " .. v2608)
		end
	end

	return v2605
end
function t351.jsonEncode(p267) -- line: 17880
	local t353 = {}

	if p267.session_id ~= nil then
		t353.sessionId = p267.session_id:jsonEncode()
	end

	return t353
end
function t351.jsonDecode(t354: {[any]: any}) -- line: 17890
	-- upvalues: t351 (copy), prop_types (copy)
	local v2618 = t351.new()

	if t354.session_id ~= nil then
		v2618.session_id = prop_types.StringProp.jsonDecode(t354.session_id)
	end

	if t354.sessionId ~= nil then
		v2618.session_id = prop_types.StringProp.jsonDecode(t354.sessionId)
	end

	return v2618
end

t351.descriptor = {
	name = "ApplyChartsFilterAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.ApplyChartsFilterAction_Params = t351
typeRegistry.default:register(t1.ApplyChartsFilterAction_Params)

local t355 = {}

t355.__index = t355

function t355.new(t356: {[any]: any}?) -- line: 17918
	-- upvalues: t1 (copy), t355 (copy)
	return (setmetatable({
		action_type = if t356 ~= nil and t356.action_type ~= nil then t356.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t356 ~= nil and t356.action_params ~= nil then t356.action_params else nil
	}, t355))
end
function t355.encode(p268) -- line: 17927
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n176 = 0

	if p268.action_type ~= nil and (p268.action_type ~= nil and p268.action_type ~= 0 or p268.action_type ~= t1.ActionType.fromNumber(0)) then
		local v2623, v2624 = proto.writeTag(buf, n176, 1, proto.wireTypes.varint)

		buf, n176 = proto.writeVarInt(v2623, v2624, t1.ActionType.toNumber(p268.action_type))
	end

	if p268.action_params ~= nil then
		local v2625 = p268.action_params:encode()
		local v2626, v2627 = proto.writeTag(buf, n176, 2, proto.wireTypes.lengthDelimited)

		buf, n176 = proto.writeBuffer(v2626, v2627, v2625, buffer.len(v2625))
	end

	local buf91 = buffer.create(n176)

	buffer.copy(buf91, 0, buf, 0, n176)

	return buf91
end
function t355.decode(p269: buffer) -- line: 17953
	-- upvalues: t355 (copy), proto (copy), t1 (copy)
	local v2630 = t355.new()
	local n177 = 0

	while n177 < buffer.len(p269) do
		local v2632, v2633

		v2632, v2633, n177 = proto.readTag(p269, n177)

		if v2633 == proto.wireTypes.varint then
			if v2632 == 1 then
				local v2634

				v2634, n177 = proto.readVarIntI32(p269, n177)
				v2630.action_type = t1.ActionType.fromNumber(v2634) or v2634
			else
				local v2635

				v2635, n177 = proto.readVarInt(p269, n177)
			end
		elseif v2633 == proto.wireTypes.lengthDelimited then
			if v2632 == 2 then
				local v2636

				v2636, n177 = proto.readBuffer(p269, n177)
				v2630.action_params = t1.AnalyticsEventAction_Params.decode(v2636)
			else
				local v2637, v2638 = proto.readVarInt(p269, n177)

				n177 = v2638 + v2637
			end
		elseif v2633 == proto.wireTypes.i32 then
			local v2639

			v2639, n177 = proto.readFixed32(p269, n177)
		elseif v2633 == proto.wireTypes.i64 then
			local v2640

			v2640, n177 = proto.readFixed64(p269, n177)
		else
			error("Unsupported wire type: " .. v2633)
		end
	end

	return v2630
end
function t355.jsonEncode(p270) -- line: 18001
	-- upvalues: t1 (copy)
	local t357 = {}

	if p270.action_type ~= nil and (p270.action_type ~= nil and p270.action_type ~= 0 or p270.action_type ~= t1.ActionType.fromNumber(0)) then
		t357.actionType = if typeof(p270.action_type) ~= "number" then t1.ActionType.toNumber(p270.action_type) else p270.action_type
	end

	if p270.action_params ~= nil then
		t357.actionParams = p270.action_params:jsonEncode()
	end

	return t357
end
function t355.jsonDecode(t358: {[any]: any}) -- line: 18023
	-- upvalues: t355 (copy), t1 (copy)
	local v2644 = t355.new()

	if t358.action_type ~= nil then
		v2644.action_type = if typeof(t358.action_type) ~= "number" then t1.ActionType.fromName(t358.action_type) or t358.action_type else t1.ActionType.fromNumber(t358.action_type) or t358.action_type
	end

	if t358.actionType ~= nil then
		v2644.action_type = if typeof(t358.actionType) ~= "number" then t1.ActionType.fromName(t358.actionType) or t358.actionType else t1.ActionType.fromNumber(t358.actionType) or t358.actionType
	end

	if t358.action_params ~= nil then
		v2644.action_params = t1.AnalyticsEventAction_Params.jsonDecode(t358.action_params)
	end

	if t358.actionParams ~= nil then
		v2644.action_params = t1.AnalyticsEventAction_Params.jsonDecode(t358.actionParams)
	end

	return v2644
end

t355.descriptor = {
	name = "AnalyticsEventAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.AnalyticsEventAction"
}
t1.AnalyticsEventAction = t355
typeRegistry.default:register(t1.AnalyticsEventAction)

local t359 = {}

t359.__index = t359

function t359.new(t360: {[any]: any}?) -- line: 18063
	-- upvalues: t359 (copy)
	return (setmetatable({
		event_name = if t360 ~= nil and t360.event_name ~= nil then t360.event_name else nil,
		event_fields = if t360 ~= nil and t360.event_fields ~= nil then t360.event_fields else nil
	}, t359))
end
function t359.encode(p271) -- line: 18072
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n178 = 0

	if p271.event_name ~= nil then
		local v2649 = p271.event_name:encode()
		local v2650, v2651 = proto.writeTag(buf, n178, 1, proto.wireTypes.lengthDelimited)

		buf, n178 = proto.writeBuffer(v2650, v2651, v2649, buffer.len(v2649))
	end

	if p271.event_fields ~= nil then
		local v2652 = p271.event_fields:encode()
		local v2653, v2654 = proto.writeTag(buf, n178, 2, proto.wireTypes.lengthDelimited)

		buf, n178 = proto.writeBuffer(v2653, v2654, v2652, buffer.len(v2652))
	end

	local buf92 = buffer.create(n178)

	buffer.copy(buf92, 0, buf, 0, n178)

	return buf92
end
function t359.decode(p272: buffer) -- line: 18093
	-- upvalues: t359 (copy), proto (copy), prop_types (copy)
	local v2657 = t359.new()
	local n179 = 0

	while n179 < buffer.len(p272) do
		local v2659, v2660

		v2659, v2660, n179 = proto.readTag(p272, n179)

		if v2660 == proto.wireTypes.varint then
			local v2661

			v2661, n179 = proto.readVarInt(p272, n179)
		elseif v2660 == proto.wireTypes.lengthDelimited then
			if v2659 == 1 then
				local v2662

				v2662, n179 = proto.readBuffer(p272, n179)
				v2657.event_name = prop_types.StringProp.decode(v2662)
			elseif v2659 == 2 then
				local v2663

				v2663, n179 = proto.readBuffer(p272, n179)
				v2657.event_fields = prop_types.StructProp.decode(v2663)
			else
				local v2664, v2665 = proto.readVarInt(p272, n179)

				n179 = v2665 + v2664
			end
		elseif v2660 == proto.wireTypes.i32 then
			local v2666

			v2666, n179 = proto.readFixed32(p272, n179)
		elseif v2660 == proto.wireTypes.i64 then
			local v2667

			v2667, n179 = proto.readFixed64(p272, n179)
		else
			error("Unsupported wire type: " .. v2660)
		end
	end

	return v2657
end
function t359.jsonEncode(p273) -- line: 18141
	local t361 = {}

	if p273.event_name ~= nil then
		t361.eventName = p273.event_name:jsonEncode()
	end

	if p273.event_fields ~= nil then
		t361.eventFields = p273.event_fields:jsonEncode()
	end

	return t361
end
function t359.jsonDecode(t362: {[any]: any}) -- line: 18155
	-- upvalues: t359 (copy), prop_types (copy)
	local v2671 = t359.new()

	if t362.event_name ~= nil then
		v2671.event_name = prop_types.StringProp.jsonDecode(t362.event_name)
	end

	if t362.eventName ~= nil then
		v2671.event_name = prop_types.StringProp.jsonDecode(t362.eventName)
	end

	if t362.event_fields ~= nil then
		v2671.event_fields = prop_types.StructProp.jsonDecode(t362.event_fields)
	end

	if t362.eventFields ~= nil then
		v2671.event_fields = prop_types.StructProp.jsonDecode(t362.eventFields)
	end

	return v2671
end

t359.descriptor = {
	name = "AnalyticsEventAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.AnalyticsEventAction_Params = t359
typeRegistry.default:register(t1.AnalyticsEventAction_Params)

local t363 = {}

t363.__index = t363

function t363.new(t364: {[any]: any}?) -- line: 18193
	-- upvalues: t1 (copy), t363 (copy)
	return (setmetatable({
		action_type = if t364 ~= nil and t364.action_type ~= nil then t364.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t364 ~= nil and t364.action_params ~= nil then t364.action_params else nil
	}, t363))
end
function t363.encode(p274) -- line: 18204
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n180 = 0

	if p274.action_type ~= nil and (p274.action_type ~= nil and p274.action_type ~= 0 or p274.action_type ~= t1.ActionType.fromNumber(0)) then
		local v2676, v2677 = proto.writeTag(buf, n180, 1, proto.wireTypes.varint)

		buf, n180 = proto.writeVarInt(v2676, v2677, t1.ActionType.toNumber(p274.action_type))
	end

	if p274.action_params ~= nil then
		local v2678 = p274.action_params:encode()
		local v2679, v2680 = proto.writeTag(buf, n180, 2, proto.wireTypes.lengthDelimited)

		buf, n180 = proto.writeBuffer(v2679, v2680, v2678, buffer.len(v2678))
	end

	local buf93 = buffer.create(n180)

	buffer.copy(buf93, 0, buf, 0, n180)

	return buf93
end
function t363.decode(p275: buffer) -- line: 18230
	-- upvalues: t363 (copy), proto (copy), t1 (copy)
	local v2683 = t363.new()
	local n181 = 0

	while n181 < buffer.len(p275) do
		local v2685, v2686

		v2685, v2686, n181 = proto.readTag(p275, n181)

		if v2686 == proto.wireTypes.varint then
			if v2685 == 1 then
				local v2687

				v2687, n181 = proto.readVarIntI32(p275, n181)
				v2683.action_type = t1.ActionType.fromNumber(v2687) or v2687
			else
				local v2688

				v2688, n181 = proto.readVarInt(p275, n181)
			end
		elseif v2686 == proto.wireTypes.lengthDelimited then
			if v2685 == 2 then
				local v2689

				v2689, n181 = proto.readBuffer(p275, n181)
				v2683.action_params = t1.CustomAnalyticsEventAction_Params.decode(v2689)
			else
				local v2690, v2691 = proto.readVarInt(p275, n181)

				n181 = v2691 + v2690
			end
		elseif v2686 == proto.wireTypes.i32 then
			local v2692

			v2692, n181 = proto.readFixed32(p275, n181)
		elseif v2686 == proto.wireTypes.i64 then
			local v2693

			v2693, n181 = proto.readFixed64(p275, n181)
		else
			error("Unsupported wire type: " .. v2686)
		end
	end

	return v2683
end
function t363.jsonEncode(p276) -- line: 18278
	-- upvalues: t1 (copy)
	local t365 = {}

	if p276.action_type ~= nil and (p276.action_type ~= nil and p276.action_type ~= 0 or p276.action_type ~= t1.ActionType.fromNumber(0)) then
		t365.actionType = if typeof(p276.action_type) ~= "number" then t1.ActionType.toNumber(p276.action_type) else p276.action_type
	end

	if p276.action_params ~= nil then
		t365.actionParams = p276.action_params:jsonEncode()
	end

	return t365
end
function t363.jsonDecode(t366: {[any]: any}) -- line: 18300
	-- upvalues: t363 (copy), t1 (copy)
	local v2697 = t363.new()

	if t366.action_type ~= nil then
		v2697.action_type = if typeof(t366.action_type) ~= "number" then t1.ActionType.fromName(t366.action_type) or t366.action_type else t1.ActionType.fromNumber(t366.action_type) or t366.action_type
	end

	if t366.actionType ~= nil then
		v2697.action_type = if typeof(t366.actionType) ~= "number" then t1.ActionType.fromName(t366.actionType) or t366.actionType else t1.ActionType.fromNumber(t366.actionType) or t366.actionType
	end

	if t366.action_params ~= nil then
		v2697.action_params = t1.CustomAnalyticsEventAction_Params.jsonDecode(t366.action_params)
	end

	if t366.actionParams ~= nil then
		v2697.action_params = t1.CustomAnalyticsEventAction_Params.jsonDecode(t366.actionParams)
	end

	return v2697
end

t363.descriptor = {
	name = "CustomAnalyticsEventAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.CustomAnalyticsEventAction"
}
t1.CustomAnalyticsEventAction = t363
typeRegistry.default:register(t1.CustomAnalyticsEventAction)

local t367 = {}

t367.__index = t367

function t367.new(t368: {[any]: any}?) -- line: 18340
	-- upvalues: t367 (copy)
	return (setmetatable({
		event_name = if t368 ~= nil and t368.event_name ~= nil then t368.event_name else nil,
		event_fields = if t368 ~= nil and t368.event_fields ~= nil then t368.event_fields else nil
	}, t367))
end
function t367.encode(p277) -- line: 18349
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n182 = 0

	if p277.event_name ~= nil then
		local v2702 = p277.event_name:encode()
		local v2703, v2704 = proto.writeTag(buf, n182, 1, proto.wireTypes.lengthDelimited)

		buf, n182 = proto.writeBuffer(v2703, v2704, v2702, buffer.len(v2702))
	end

	if p277.event_fields ~= nil then
		local v2705 = p277.event_fields:encode()
		local v2706, v2707 = proto.writeTag(buf, n182, 2, proto.wireTypes.lengthDelimited)

		buf, n182 = proto.writeBuffer(v2706, v2707, v2705, buffer.len(v2705))
	end

	local buf94 = buffer.create(n182)

	buffer.copy(buf94, 0, buf, 0, n182)

	return buf94
end
function t367.decode(p278: buffer) -- line: 18370
	-- upvalues: t367 (copy), proto (copy), prop_types (copy)
	local v2710 = t367.new()
	local n183 = 0

	while n183 < buffer.len(p278) do
		local v2712, v2713

		v2712, v2713, n183 = proto.readTag(p278, n183)

		if v2713 == proto.wireTypes.varint then
			local v2714

			v2714, n183 = proto.readVarInt(p278, n183)
		elseif v2713 == proto.wireTypes.lengthDelimited then
			if v2712 == 1 then
				local v2715

				v2715, n183 = proto.readBuffer(p278, n183)
				v2710.event_name = prop_types.StringProp.decode(v2715)
			elseif v2712 == 2 then
				local v2716

				v2716, n183 = proto.readBuffer(p278, n183)
				v2710.event_fields = prop_types.StructProp.decode(v2716)
			else
				local v2717, v2718 = proto.readVarInt(p278, n183)

				n183 = v2718 + v2717
			end
		elseif v2713 == proto.wireTypes.i32 then
			local v2719

			v2719, n183 = proto.readFixed32(p278, n183)
		elseif v2713 == proto.wireTypes.i64 then
			local v2720

			v2720, n183 = proto.readFixed64(p278, n183)
		else
			error("Unsupported wire type: " .. v2713)
		end
	end

	return v2710
end
function t367.jsonEncode(p279) -- line: 18418
	local t369 = {}

	if p279.event_name ~= nil then
		t369.eventName = p279.event_name:jsonEncode()
	end

	if p279.event_fields ~= nil then
		t369.eventFields = p279.event_fields:jsonEncode()
	end

	return t369
end
function t367.jsonDecode(t370: {[any]: any}) -- line: 18432
	-- upvalues: t367 (copy), prop_types (copy)
	local v2724 = t367.new()

	if t370.event_name ~= nil then
		v2724.event_name = prop_types.StringProp.jsonDecode(t370.event_name)
	end

	if t370.eventName ~= nil then
		v2724.event_name = prop_types.StringProp.jsonDecode(t370.eventName)
	end

	if t370.event_fields ~= nil then
		v2724.event_fields = prop_types.StructProp.jsonDecode(t370.event_fields)
	end

	if t370.eventFields ~= nil then
		v2724.event_fields = prop_types.StructProp.jsonDecode(t370.eventFields)
	end

	return v2724
end

t367.descriptor = {
	name = "CustomAnalyticsEventAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.CustomAnalyticsEventAction_Params = t367
typeRegistry.default:register(t1.CustomAnalyticsEventAction_Params)

local t371 = {}

t371.__index = t371

function t371.new(t372: {[any]: any}?) -- line: 18472
	-- upvalues: t1 (copy), t371 (copy)
	return (setmetatable({
		action_type = if t372 ~= nil and t372.action_type ~= nil then t372.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t372 ~= nil and t372.action_params ~= nil then t372.action_params else nil
	}, t371))
end
function t371.encode(p280) -- line: 18481
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n184 = 0

	if p280.action_type ~= nil and (p280.action_type ~= nil and p280.action_type ~= 0 or p280.action_type ~= t1.ActionType.fromNumber(0)) then
		local v2729, v2730 = proto.writeTag(buf, n184, 1, proto.wireTypes.varint)

		buf, n184 = proto.writeVarInt(v2729, v2730, t1.ActionType.toNumber(p280.action_type))
	end

	if p280.action_params ~= nil then
		local v2731 = p280.action_params:encode()
		local v2732, v2733 = proto.writeTag(buf, n184, 2, proto.wireTypes.lengthDelimited)

		buf, n184 = proto.writeBuffer(v2732, v2733, v2731, buffer.len(v2731))
	end

	local buf95 = buffer.create(n184)

	buffer.copy(buf95, 0, buf, 0, n184)

	return buf95
end
function t371.decode(p281: buffer) -- line: 18507
	-- upvalues: t371 (copy), proto (copy), t1 (copy)
	local v2736 = t371.new()
	local n185 = 0

	while n185 < buffer.len(p281) do
		local v2738, v2739

		v2738, v2739, n185 = proto.readTag(p281, n185)

		if v2739 == proto.wireTypes.varint then
			if v2738 == 1 then
				local v2740

				v2740, n185 = proto.readVarIntI32(p281, n185)
				v2736.action_type = t1.ActionType.fromNumber(v2740) or v2740
			else
				local v2741

				v2741, n185 = proto.readVarInt(p281, n185)
			end
		elseif v2739 == proto.wireTypes.lengthDelimited then
			if v2738 == 2 then
				local v2742

				v2742, n185 = proto.readBuffer(p281, n185)
				v2736.action_params = t1.OpenGameInviteAction_Params.decode(v2742)
			else
				local v2743, v2744 = proto.readVarInt(p281, n185)

				n185 = v2744 + v2743
			end
		elseif v2739 == proto.wireTypes.i32 then
			local v2745

			v2745, n185 = proto.readFixed32(p281, n185)
		elseif v2739 == proto.wireTypes.i64 then
			local v2746

			v2746, n185 = proto.readFixed64(p281, n185)
		else
			error("Unsupported wire type: " .. v2739)
		end
	end

	return v2736
end
function t371.jsonEncode(p282) -- line: 18555
	-- upvalues: t1 (copy)
	local t373 = {}

	if p282.action_type ~= nil and (p282.action_type ~= nil and p282.action_type ~= 0 or p282.action_type ~= t1.ActionType.fromNumber(0)) then
		t373.actionType = if typeof(p282.action_type) ~= "number" then t1.ActionType.toNumber(p282.action_type) else p282.action_type
	end

	if p282.action_params ~= nil then
		t373.actionParams = p282.action_params:jsonEncode()
	end

	return t373
end
function t371.jsonDecode(t374: {[any]: any}) -- line: 18577
	-- upvalues: t371 (copy), t1 (copy)
	local v2750 = t371.new()

	if t374.action_type ~= nil then
		v2750.action_type = if typeof(t374.action_type) ~= "number" then t1.ActionType.fromName(t374.action_type) or t374.action_type else t1.ActionType.fromNumber(t374.action_type) or t374.action_type
	end

	if t374.actionType ~= nil then
		v2750.action_type = if typeof(t374.actionType) ~= "number" then t1.ActionType.fromName(t374.actionType) or t374.actionType else t1.ActionType.fromNumber(t374.actionType) or t374.actionType
	end

	if t374.action_params ~= nil then
		v2750.action_params = t1.OpenGameInviteAction_Params.jsonDecode(t374.action_params)
	end

	if t374.actionParams ~= nil then
		v2750.action_params = t1.OpenGameInviteAction_Params.jsonDecode(t374.actionParams)
	end

	return v2750
end

t371.descriptor = {
	name = "OpenGameInviteAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.OpenGameInviteAction"
}
t1.OpenGameInviteAction = t371
typeRegistry.default:register(t1.OpenGameInviteAction)

local t375 = {}

t375.__index = t375

function t375.new(t376: {[any]: any}?) -- line: 18617
	-- upvalues: t375 (copy)
	return (setmetatable({
		universe_id = if t376 ~= nil and t376.universe_id ~= nil then t376.universe_id else nil,
		root_place_id = if t376 ~= nil and t376.root_place_id ~= nil then t376.root_place_id else nil,
		trigger = if t376 ~= nil and t376.trigger ~= nil then t376.trigger else nil,
		button_name = if t376 ~= nil and t376.button_name ~= nil then t376.button_name else nil
	}, t375))
end
function t375.encode(p283) -- line: 18628
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n186 = 0

	if p283.universe_id ~= nil then
		local v2755 = p283.universe_id:encode()
		local v2756, v2757 = proto.writeTag(buf, n186, 1, proto.wireTypes.lengthDelimited)

		buf, n186 = proto.writeBuffer(v2756, v2757, v2755, buffer.len(v2755))
	end

	if p283.root_place_id ~= nil then
		local v2758 = p283.root_place_id:encode()
		local v2759, v2760 = proto.writeTag(buf, n186, 2, proto.wireTypes.lengthDelimited)

		buf, n186 = proto.writeBuffer(v2759, v2760, v2758, buffer.len(v2758))
	end

	if p283.trigger ~= nil then
		local v2761 = p283.trigger:encode()
		local v2762, v2763 = proto.writeTag(buf, n186, 3, proto.wireTypes.lengthDelimited)

		buf, n186 = proto.writeBuffer(v2762, v2763, v2761, buffer.len(v2761))
	end

	if p283.button_name ~= nil then
		local v2764 = p283.button_name:encode()
		local v2765, v2766 = proto.writeTag(buf, n186, 4, proto.wireTypes.lengthDelimited)

		buf, n186 = proto.writeBuffer(v2765, v2766, v2764, buffer.len(v2764))
	end

	local buf96 = buffer.create(n186)

	buffer.copy(buf96, 0, buf, 0, n186)

	return buf96
end
function t375.decode(p284: buffer) -- line: 18661
	-- upvalues: t375 (copy), proto (copy), prop_types (copy)
	local v2769 = t375.new()
	local n187 = 0

	while n187 < buffer.len(p284) do
		local v2771, v2772

		v2771, v2772, n187 = proto.readTag(p284, n187)

		if v2772 == proto.wireTypes.varint then
			local v2773

			v2773, n187 = proto.readVarInt(p284, n187)
		elseif v2772 == proto.wireTypes.lengthDelimited then
			if v2771 == 1 then
				local v2774

				v2774, n187 = proto.readBuffer(p284, n187)
				v2769.universe_id = prop_types.StringProp.decode(v2774)
			elseif v2771 == 2 then
				local v2775

				v2775, n187 = proto.readBuffer(p284, n187)
				v2769.root_place_id = prop_types.StringProp.decode(v2775)
			elseif v2771 == 3 then
				local v2776

				v2776, n187 = proto.readBuffer(p284, n187)
				v2769.trigger = prop_types.StringProp.decode(v2776)
			elseif v2771 == 4 then
				local v2777

				v2777, n187 = proto.readBuffer(p284, n187)
				v2769.button_name = prop_types.StringProp.decode(v2777)
			else
				local v2778, v2779 = proto.readVarInt(p284, n187)

				n187 = v2779 + v2778
			end
		elseif v2772 == proto.wireTypes.i32 then
			local v2780

			v2780, n187 = proto.readFixed32(p284, n187)
		elseif v2772 == proto.wireTypes.i64 then
			local v2781

			v2781, n187 = proto.readFixed64(p284, n187)
		else
			error("Unsupported wire type: " .. v2772)
		end
	end

	return v2769
end
function t375.jsonEncode(p285) -- line: 18719
	local t377 = {}

	if p285.universe_id ~= nil then
		t377.universeId = p285.universe_id:jsonEncode()
	end

	if p285.root_place_id ~= nil then
		t377.rootPlaceId = p285.root_place_id:jsonEncode()
	end

	if p285.trigger ~= nil then
		t377.trigger = p285.trigger:jsonEncode()
	end

	if p285.button_name ~= nil then
		t377.buttonName = p285.button_name:jsonEncode()
	end

	return t377
end
function t375.jsonDecode(t378: {[any]: any}) -- line: 18741
	-- upvalues: t375 (copy), prop_types (copy)
	local v2785 = t375.new()

	if t378.universe_id ~= nil then
		v2785.universe_id = prop_types.StringProp.jsonDecode(t378.universe_id)
	end

	if t378.universeId ~= nil then
		v2785.universe_id = prop_types.StringProp.jsonDecode(t378.universeId)
	end

	if t378.root_place_id ~= nil then
		v2785.root_place_id = prop_types.StringProp.jsonDecode(t378.root_place_id)
	end

	if t378.rootPlaceId ~= nil then
		v2785.root_place_id = prop_types.StringProp.jsonDecode(t378.rootPlaceId)
	end

	if t378.trigger ~= nil then
		v2785.trigger = prop_types.StringProp.jsonDecode(t378.trigger)
	end

	if t378.button_name ~= nil then
		v2785.button_name = prop_types.StringProp.jsonDecode(t378.button_name)
	end

	if t378.buttonName ~= nil then
		v2785.button_name = prop_types.StringProp.jsonDecode(t378.buttonName)
	end

	return v2785
end

t375.descriptor = {
	name = "OpenGameInviteAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.OpenGameInviteAction_Params = t375
typeRegistry.default:register(t1.OpenGameInviteAction_Params)

local t379 = {}

t379.__index = t379

function t379.new(t380: {[any]: any}?) -- line: 18793
	-- upvalues: t1 (copy), t379 (copy)
	return (setmetatable({
		action_type = if t380 ~= nil and t380.action_type ~= nil then t380.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t380 ~= nil and t380.action_params ~= nil then t380.action_params else nil
	}, t379))
end
function t379.encode(p286) -- line: 18802
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n188 = 0

	if p286.action_type ~= nil and (p286.action_type ~= nil and p286.action_type ~= 0 or p286.action_type ~= t1.ActionType.fromNumber(0)) then
		local v2790, v2791 = proto.writeTag(buf, n188, 1, proto.wireTypes.varint)

		buf, n188 = proto.writeVarInt(v2790, v2791, t1.ActionType.toNumber(p286.action_type))
	end

	if p286.action_params ~= nil then
		local v2792 = p286.action_params:encode()
		local v2793, v2794 = proto.writeTag(buf, n188, 2, proto.wireTypes.lengthDelimited)

		buf, n188 = proto.writeBuffer(v2793, v2794, v2792, buffer.len(v2792))
	end

	local buf97 = buffer.create(n188)

	buffer.copy(buf97, 0, buf, 0, n188)

	return buf97
end
function t379.decode(p287: buffer) -- line: 18828
	-- upvalues: t379 (copy), proto (copy), t1 (copy)
	local v2797 = t379.new()
	local n189 = 0

	while n189 < buffer.len(p287) do
		local v2799, v2800

		v2799, v2800, n189 = proto.readTag(p287, n189)

		if v2800 == proto.wireTypes.varint then
			if v2799 == 1 then
				local v2801

				v2801, n189 = proto.readVarIntI32(p287, n189)
				v2797.action_type = t1.ActionType.fromNumber(v2801) or v2801
			else
				local v2802

				v2802, n189 = proto.readVarInt(p287, n189)
			end
		elseif v2800 == proto.wireTypes.lengthDelimited then
			if v2799 == 2 then
				local v2803

				v2803, n189 = proto.readBuffer(p287, n189)
				v2797.action_params = t1.LaunchExperienceAction_Params.decode(v2803)
			else
				local v2804, v2805 = proto.readVarInt(p287, n189)

				n189 = v2805 + v2804
			end
		elseif v2800 == proto.wireTypes.i32 then
			local v2806

			v2806, n189 = proto.readFixed32(p287, n189)
		elseif v2800 == proto.wireTypes.i64 then
			local v2807

			v2807, n189 = proto.readFixed64(p287, n189)
		else
			error("Unsupported wire type: " .. v2800)
		end
	end

	return v2797
end
function t379.jsonEncode(p288) -- line: 18876
	-- upvalues: t1 (copy)
	local t381 = {}

	if p288.action_type ~= nil and (p288.action_type ~= nil and p288.action_type ~= 0 or p288.action_type ~= t1.ActionType.fromNumber(0)) then
		t381.actionType = if typeof(p288.action_type) ~= "number" then t1.ActionType.toNumber(p288.action_type) else p288.action_type
	end

	if p288.action_params ~= nil then
		t381.actionParams = p288.action_params:jsonEncode()
	end

	return t381
end
function t379.jsonDecode(t382: {[any]: any}) -- line: 18898
	-- upvalues: t379 (copy), t1 (copy)
	local v2811 = t379.new()

	if t382.action_type ~= nil then
		v2811.action_type = if typeof(t382.action_type) ~= "number" then t1.ActionType.fromName(t382.action_type) or t382.action_type else t1.ActionType.fromNumber(t382.action_type) or t382.action_type
	end

	if t382.actionType ~= nil then
		v2811.action_type = if typeof(t382.actionType) ~= "number" then t1.ActionType.fromName(t382.actionType) or t382.actionType else t1.ActionType.fromNumber(t382.actionType) or t382.actionType
	end

	if t382.action_params ~= nil then
		v2811.action_params = t1.LaunchExperienceAction_Params.jsonDecode(t382.action_params)
	end

	if t382.actionParams ~= nil then
		v2811.action_params = t1.LaunchExperienceAction_Params.jsonDecode(t382.actionParams)
	end

	return v2811
end

t379.descriptor = {
	name = "LaunchExperienceAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.LaunchExperienceAction"
}
t1.LaunchExperienceAction = t379
typeRegistry.default:register(t1.LaunchExperienceAction)

local t383 = {}

t383.__index = t383

function t383.new(t384: {[any]: any}?) -- line: 18938
	-- upvalues: t383 (copy)
	return (setmetatable({
		kind = if t384 ~= nil and t384.kind ~= nil then t384.kind else nil
	}, t383))
end
function t383.encode(p289) -- line: 18946
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n190 = 0

	if p289.kind ~= nil then
		if p289.kind.type == "literal" then
			local v2816 = p289.kind.value:encode()
			local v2817, v2818 = proto.writeTag(buf, n190, 1, proto.wireTypes.lengthDelimited)

			buf, n190 = proto.writeBuffer(v2817, v2818, v2816, buffer.len(v2816))
		elseif p289.kind.type == "binding_path" then
			local v2819, v2820 = proto.writeTag(buf, n190, 2, proto.wireTypes.lengthDelimited)

			buf, n190 = proto.writeString(v2819, v2820, p289.kind.value)
		end
	end

	local buf98 = buffer.create(n190)

	buffer.copy(buf98, 0, buf, 0, n190)

	return buf98
end
function t383.decode(p290: buffer) -- line: 18968
	-- upvalues: t383 (copy), proto (copy), t1 (copy)
	local v2823 = t383.new()
	local n191 = 0

	while n191 < buffer.len(p290) do
		local v2825, v2826

		v2825, v2826, n191 = proto.readTag(p290, n191)

		if v2826 == proto.wireTypes.varint then
			local v2827

			v2827, n191 = proto.readVarInt(p290, n191)
		elseif v2826 == proto.wireTypes.lengthDelimited then
			if v2825 == 1 then
				local v2828

				v2828, n191 = proto.readBuffer(p290, n191)
				v2823.kind = {
					type = "literal",
					value = t1.LaunchExperienceAction_ExperienceJoinData_ExperienceJoinDataLiteral.decode(v2828)
				}
			elseif v2825 == 2 then
				local v2829

				v2829, n191 = proto.readBuffer(p290, n191)
				v2823.kind = {
					type = "binding_path",
					value = buffer.tostring(v2829)
				}
			else
				local v2830, v2831 = proto.readVarInt(p290, n191)

				n191 = v2831 + v2830
			end
		elseif v2826 == proto.wireTypes.i32 then
			local v2832

			v2832, n191 = proto.readFixed32(p290, n191)
		elseif v2826 == proto.wireTypes.i64 then
			local v2833

			v2833, n191 = proto.readFixed64(p290, n191)
		else
			error("Unsupported wire type: " .. v2826)
		end
	end

	return v2823
end
function t383.jsonEncode(p291) -- line: 19023
	local t385 = {}

	if p291.kind ~= nil then
		if p291.kind.type == "literal" then
			t385.literal = p291.kind.value:jsonEncode()

			return t385
		end

		if p291.kind.type == "binding_path" then
			t385.bindingPath = p291.kind.value
		end
	end

	return t385
end
function t383.jsonDecode(t386: {[any]: any}) -- line: 19039
	-- upvalues: t383 (copy), t1 (copy)
	local v2837 = t383.new()

	if t386.literal ~= nil then
		v2837.kind = {
			type = "literal",
			value = t1.LaunchExperienceAction_ExperienceJoinData_ExperienceJoinDataLiteral.jsonDecode(t386.literal)
		}
	end

	if t386.binding_path ~= nil then
		v2837.kind = {
			type = "binding_path",
			value = t386.binding_path
		}
	end

	if t386.bindingPath ~= nil then
		v2837.kind = {
			type = "binding_path",
			value = t386.bindingPath
		}
	end

	return v2837
end

t383.descriptor = {
	name = "LaunchExperienceAction_ExperienceJoinData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceJoinData"
}
t1.LaunchExperienceAction_ExperienceJoinData = t383
typeRegistry.default:register(t1.LaunchExperienceAction_ExperienceJoinData)

local t387 = {}

t387.__index = t387

function t387.new(t388: {[any]: any}?) -- line: 19079
	-- upvalues: t387 (copy)
	return (setmetatable({
		launch_data = if t388 ~= nil and t388.launch_data ~= nil then t388.launch_data else nil,
		event_id = if t388 ~= nil and t388.event_id ~= nil then t388.event_id else nil
	}, t387))
end
function t387.encode(p292) -- line: 19091
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n192 = 0

	if p292.launch_data ~= nil then
		local v2842 = p292.launch_data:encode()
		local v2843, v2844 = proto.writeTag(buf, n192, 1, proto.wireTypes.lengthDelimited)

		buf, n192 = proto.writeBuffer(v2843, v2844, v2842, buffer.len(v2842))
	end

	if p292.event_id ~= nil then
		local v2845 = p292.event_id:encode()
		local v2846, v2847 = proto.writeTag(buf, n192, 2, proto.wireTypes.lengthDelimited)

		buf, n192 = proto.writeBuffer(v2846, v2847, v2845, buffer.len(v2845))
	end

	local buf99 = buffer.create(n192)

	buffer.copy(buf99, 0, buf, 0, n192)

	return buf99
end
function t387.decode(p293: buffer) -- line: 19114
	-- upvalues: t387 (copy), proto (copy), prop_types (copy)
	local v2850 = t387.new()
	local n193 = 0

	while n193 < buffer.len(p293) do
		local v2852, v2853

		v2852, v2853, n193 = proto.readTag(p293, n193)

		if v2853 == proto.wireTypes.varint then
			local v2854

			v2854, n193 = proto.readVarInt(p293, n193)
		elseif v2853 == proto.wireTypes.lengthDelimited then
			if v2852 == 1 then
				local v2855

				v2855, n193 = proto.readBuffer(p293, n193)
				v2850.launch_data = prop_types.StringProp.decode(v2855)
			elseif v2852 == 2 then
				local v2856

				v2856, n193 = proto.readBuffer(p293, n193)
				v2850.event_id = prop_types.StringProp.decode(v2856)
			else
				local v2857, v2858 = proto.readVarInt(p293, n193)

				n193 = v2858 + v2857
			end
		elseif v2853 == proto.wireTypes.i32 then
			local v2859

			v2859, n193 = proto.readFixed32(p293, n193)
		elseif v2853 == proto.wireTypes.i64 then
			local v2860

			v2860, n193 = proto.readFixed64(p293, n193)
		else
			error("Unsupported wire type: " .. v2853)
		end
	end

	return v2850
end
function t387.jsonEncode(p294) -- line: 19164
	local t389 = {}

	if p294.launch_data ~= nil then
		t389.launchData = p294.launch_data:jsonEncode()
	end

	if p294.event_id ~= nil then
		t389.eventId = p294.event_id:jsonEncode()
	end

	return t389
end
function t387.jsonDecode(t390: {[any]: any}) -- line: 19180
	-- upvalues: t387 (copy), prop_types (copy)
	local v2864 = t387.new()

	if t390.launch_data ~= nil then
		v2864.launch_data = prop_types.StringProp.jsonDecode(t390.launch_data)
	end

	if t390.launchData ~= nil then
		v2864.launch_data = prop_types.StringProp.jsonDecode(t390.launchData)
	end

	if t390.event_id ~= nil then
		v2864.event_id = prop_types.StringProp.jsonDecode(t390.event_id)
	end

	if t390.eventId ~= nil then
		v2864.event_id = prop_types.StringProp.jsonDecode(t390.eventId)
	end

	return v2864
end

t387.descriptor = {
	name = "LaunchExperienceAction_ExperienceJoinData_ExperienceJoinDataLiteral",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceJoinDataLiteral"
}
t1.LaunchExperienceAction_ExperienceJoinData_ExperienceJoinDataLiteral = t387
typeRegistry.default:register(t1.LaunchExperienceAction_ExperienceJoinData_ExperienceJoinDataLiteral)

local t391 = {}

t391.__index = t391

function t391.new(t392: {[any]: any}?) -- line: 19220
	-- upvalues: t391 (copy)
	return (setmetatable({
		place_id = if t392 ~= nil and t392.place_id ~= nil then t392.place_id else nil,
		universe_id = if t392 ~= nil and t392.universe_id ~= nil then t392.universe_id else nil,
		launch_source = if t392 ~= nil and t392.launch_source ~= nil then t392.launch_source else nil,
		experience_join_data = if t392 ~= nil and t392.experience_join_data ~= nil then t392.experience_join_data else nil
	}, t391))
end
function t391.encode(p295) -- line: 19233
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n194 = 0

	if p295.place_id ~= nil then
		local v2869 = p295.place_id:encode()
		local v2870, v2871 = proto.writeTag(buf, n194, 1, proto.wireTypes.lengthDelimited)

		buf, n194 = proto.writeBuffer(v2870, v2871, v2869, buffer.len(v2869))
	end

	if p295.universe_id ~= nil then
		local v2872 = p295.universe_id:encode()
		local v2873, v2874 = proto.writeTag(buf, n194, 2, proto.wireTypes.lengthDelimited)

		buf, n194 = proto.writeBuffer(v2873, v2874, v2872, buffer.len(v2872))
	end

	if p295.launch_source ~= nil then
		local v2875 = p295.launch_source:encode()
		local v2876, v2877 = proto.writeTag(buf, n194, 3, proto.wireTypes.lengthDelimited)

		buf, n194 = proto.writeBuffer(v2876, v2877, v2875, buffer.len(v2875))
	end

	if p295.experience_join_data ~= nil then
		local v2878 = p295.experience_join_data:encode()
		local v2879, v2880 = proto.writeTag(buf, n194, 4, proto.wireTypes.lengthDelimited)

		buf, n194 = proto.writeBuffer(v2879, v2880, v2878, buffer.len(v2878))
	end

	local buf100 = buffer.create(n194)

	buffer.copy(buf100, 0, buf, 0, n194)

	return buf100
end
function t391.decode(p296: buffer) -- line: 19266
	-- upvalues: t391 (copy), proto (copy), prop_types (copy), t1 (copy)
	local v2883 = t391.new()
	local n195 = 0

	while n195 < buffer.len(p296) do
		local v2885, v2886

		v2885, v2886, n195 = proto.readTag(p296, n195)

		if v2886 == proto.wireTypes.varint then
			local v2887

			v2887, n195 = proto.readVarInt(p296, n195)
		elseif v2886 == proto.wireTypes.lengthDelimited then
			if v2885 == 1 then
				local v2888

				v2888, n195 = proto.readBuffer(p296, n195)
				v2883.place_id = prop_types.StringProp.decode(v2888)
			elseif v2885 == 2 then
				local v2889

				v2889, n195 = proto.readBuffer(p296, n195)
				v2883.universe_id = prop_types.StringProp.decode(v2889)
			elseif v2885 == 3 then
				local v2890

				v2890, n195 = proto.readBuffer(p296, n195)
				v2883.launch_source = prop_types.StringProp.decode(v2890)
			elseif v2885 == 4 then
				local v2891

				v2891, n195 = proto.readBuffer(p296, n195)
				v2883.experience_join_data = t1.LaunchExperienceAction_ExperienceJoinData.decode(v2891)
			else
				local v2892, v2893 = proto.readVarInt(p296, n195)

				n195 = v2893 + v2892
			end
		elseif v2886 == proto.wireTypes.i32 then
			local v2894

			v2894, n195 = proto.readFixed32(p296, n195)
		elseif v2886 == proto.wireTypes.i64 then
			local v2895

			v2895, n195 = proto.readFixed64(p296, n195)
		else
			error("Unsupported wire type: " .. v2886)
		end
	end

	return v2883
end
function t391.jsonEncode(p297) -- line: 19324
	local t393 = {}

	if p297.place_id ~= nil then
		t393.placeId = p297.place_id:jsonEncode()
	end

	if p297.universe_id ~= nil then
		t393.universeId = p297.universe_id:jsonEncode()
	end

	if p297.launch_source ~= nil then
		t393.launchSource = p297.launch_source:jsonEncode()
	end

	if p297.experience_join_data ~= nil then
		t393.experienceJoinData = p297.experience_join_data:jsonEncode()
	end

	return t393
end
function t391.jsonDecode(t394: {[any]: any}) -- line: 19346
	-- upvalues: t391 (copy), prop_types (copy), t1 (copy)
	local v2899 = t391.new()

	if t394.place_id ~= nil then
		v2899.place_id = prop_types.StringProp.jsonDecode(t394.place_id)
	end

	if t394.placeId ~= nil then
		v2899.place_id = prop_types.StringProp.jsonDecode(t394.placeId)
	end

	if t394.universe_id ~= nil then
		v2899.universe_id = prop_types.StringProp.jsonDecode(t394.universe_id)
	end

	if t394.universeId ~= nil then
		v2899.universe_id = prop_types.StringProp.jsonDecode(t394.universeId)
	end

	if t394.launch_source ~= nil then
		v2899.launch_source = prop_types.StringProp.jsonDecode(t394.launch_source)
	end

	if t394.launchSource ~= nil then
		v2899.launch_source = prop_types.StringProp.jsonDecode(t394.launchSource)
	end

	if t394.experience_join_data ~= nil then
		v2899.experience_join_data = t1.LaunchExperienceAction_ExperienceJoinData.jsonDecode(t394.experience_join_data)
	end

	if t394.experienceJoinData ~= nil then
		v2899.experience_join_data = t1.LaunchExperienceAction_ExperienceJoinData.jsonDecode(t394.experienceJoinData)
	end

	return v2899
end

t391.descriptor = {
	name = "LaunchExperienceAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.LaunchExperienceAction_Params = t391
typeRegistry.default:register(t1.LaunchExperienceAction_Params)

local t395 = {}

t395.__index = t395

function t395.new(t396: {[any]: any}?) -- line: 19403
	-- upvalues: t1 (copy), t395 (copy)
	return (setmetatable({
		action_type = if t396 ~= nil and t396.action_type ~= nil then t396.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t396 ~= nil and t396.action_params ~= nil then t396.action_params else nil
	}, t395))
end
function t395.encode(p298) -- line: 19414
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n196 = 0

	if p298.action_type ~= nil and (p298.action_type ~= nil and p298.action_type ~= 0 or p298.action_type ~= t1.ActionType.fromNumber(0)) then
		local v2904, v2905 = proto.writeTag(buf, n196, 1, proto.wireTypes.varint)

		buf, n196 = proto.writeVarInt(v2904, v2905, t1.ActionType.toNumber(p298.action_type))
	end

	if p298.action_params ~= nil then
		local v2906 = p298.action_params:encode()
		local v2907, v2908 = proto.writeTag(buf, n196, 2, proto.wireTypes.lengthDelimited)

		buf, n196 = proto.writeBuffer(v2907, v2908, v2906, buffer.len(v2906))
	end

	local buf101 = buffer.create(n196)

	buffer.copy(buf101, 0, buf, 0, n196)

	return buf101
end
function t395.decode(p299: buffer) -- line: 19440
	-- upvalues: t395 (copy), proto (copy), t1 (copy)
	local v2911 = t395.new()
	local n197 = 0

	while n197 < buffer.len(p299) do
		local v2913, v2914

		v2913, v2914, n197 = proto.readTag(p299, n197)

		if v2914 == proto.wireTypes.varint then
			if v2913 == 1 then
				local v2915

				v2915, n197 = proto.readVarIntI32(p299, n197)
				v2911.action_type = t1.ActionType.fromNumber(v2915) or v2915
			else
				local v2916

				v2916, n197 = proto.readVarInt(p299, n197)
			end
		elseif v2914 == proto.wireTypes.lengthDelimited then
			if v2913 == 2 then
				local v2917

				v2917, n197 = proto.readBuffer(p299, n197)
				v2911.action_params = t1.ToggleExperienceFavoriteAction_Params.decode(v2917)
			else
				local v2918, v2919 = proto.readVarInt(p299, n197)

				n197 = v2919 + v2918
			end
		elseif v2914 == proto.wireTypes.i32 then
			local v2920

			v2920, n197 = proto.readFixed32(p299, n197)
		elseif v2914 == proto.wireTypes.i64 then
			local v2921

			v2921, n197 = proto.readFixed64(p299, n197)
		else
			error("Unsupported wire type: " .. v2914)
		end
	end

	return v2911
end
function t395.jsonEncode(p300) -- line: 19488
	-- upvalues: t1 (copy)
	local t397 = {}

	if p300.action_type ~= nil and (p300.action_type ~= nil and p300.action_type ~= 0 or p300.action_type ~= t1.ActionType.fromNumber(0)) then
		t397.actionType = if typeof(p300.action_type) ~= "number" then t1.ActionType.toNumber(p300.action_type) else p300.action_type
	end

	if p300.action_params ~= nil then
		t397.actionParams = p300.action_params:jsonEncode()
	end

	return t397
end
function t395.jsonDecode(t398: {[any]: any}) -- line: 19510
	-- upvalues: t395 (copy), t1 (copy)
	local v2925 = t395.new()

	if t398.action_type ~= nil then
		v2925.action_type = if typeof(t398.action_type) ~= "number" then t1.ActionType.fromName(t398.action_type) or t398.action_type else t1.ActionType.fromNumber(t398.action_type) or t398.action_type
	end

	if t398.actionType ~= nil then
		v2925.action_type = if typeof(t398.actionType) ~= "number" then t1.ActionType.fromName(t398.actionType) or t398.actionType else t1.ActionType.fromNumber(t398.actionType) or t398.actionType
	end

	if t398.action_params ~= nil then
		v2925.action_params = t1.ToggleExperienceFavoriteAction_Params.jsonDecode(t398.action_params)
	end

	if t398.actionParams ~= nil then
		v2925.action_params = t1.ToggleExperienceFavoriteAction_Params.jsonDecode(t398.actionParams)
	end

	return v2925
end

t395.descriptor = {
	name = "ToggleExperienceFavoriteAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.ToggleExperienceFavoriteAction"
}
t1.ToggleExperienceFavoriteAction = t395
typeRegistry.default:register(t1.ToggleExperienceFavoriteAction)

local t399 = {}

t399.__index = t399

function t399.new(t400: {[any]: any}?) -- line: 19550
	-- upvalues: t399 (copy)
	return (setmetatable({
		universe_id = if t400 ~= nil and t400.universe_id ~= nil then t400.universe_id else nil,
		place_id = if t400 ~= nil and t400.place_id ~= nil then t400.place_id else nil,
		ctx = if t400 ~= nil and t400.ctx ~= nil then t400.ctx else nil
	}, t399))
end
function t399.encode(p301) -- line: 19560
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n198 = 0

	if p301.universe_id ~= nil then
		local v2930 = p301.universe_id:encode()
		local v2931, v2932 = proto.writeTag(buf, n198, 1, proto.wireTypes.lengthDelimited)

		buf, n198 = proto.writeBuffer(v2931, v2932, v2930, buffer.len(v2930))
	end

	if p301.place_id ~= nil then
		local v2933 = p301.place_id:encode()
		local v2934, v2935 = proto.writeTag(buf, n198, 2, proto.wireTypes.lengthDelimited)

		buf, n198 = proto.writeBuffer(v2934, v2935, v2933, buffer.len(v2933))
	end

	if p301.ctx ~= nil then
		local v2936 = p301.ctx:encode()
		local v2937, v2938 = proto.writeTag(buf, n198, 3, proto.wireTypes.lengthDelimited)

		buf, n198 = proto.writeBuffer(v2937, v2938, v2936, buffer.len(v2936))
	end

	local buf102 = buffer.create(n198)

	buffer.copy(buf102, 0, buf, 0, n198)

	return buf102
end
function t399.decode(p302: buffer) -- line: 19587
	-- upvalues: t399 (copy), proto (copy), prop_types (copy)
	local v2941 = t399.new()
	local n199 = 0

	while n199 < buffer.len(p302) do
		local v2943, v2944

		v2943, v2944, n199 = proto.readTag(p302, n199)

		if v2944 == proto.wireTypes.varint then
			local v2945

			v2945, n199 = proto.readVarInt(p302, n199)
		elseif v2944 == proto.wireTypes.lengthDelimited then
			if v2943 == 1 then
				local v2946

				v2946, n199 = proto.readBuffer(p302, n199)
				v2941.universe_id = prop_types.StringProp.decode(v2946)
			elseif v2943 == 2 then
				local v2947

				v2947, n199 = proto.readBuffer(p302, n199)
				v2941.place_id = prop_types.StringProp.decode(v2947)
			elseif v2943 == 3 then
				local v2948

				v2948, n199 = proto.readBuffer(p302, n199)
				v2941.ctx = prop_types.StringProp.decode(v2948)
			else
				local v2949, v2950 = proto.readVarInt(p302, n199)

				n199 = v2950 + v2949
			end
		elseif v2944 == proto.wireTypes.i32 then
			local v2951

			v2951, n199 = proto.readFixed32(p302, n199)
		elseif v2944 == proto.wireTypes.i64 then
			local v2952

			v2952, n199 = proto.readFixed64(p302, n199)
		else
			error("Unsupported wire type: " .. v2944)
		end
	end

	return v2941
end
function t399.jsonEncode(p303) -- line: 19640
	local t401 = {}

	if p303.universe_id ~= nil then
		t401.universeId = p303.universe_id:jsonEncode()
	end

	if p303.place_id ~= nil then
		t401.placeId = p303.place_id:jsonEncode()
	end

	if p303.ctx ~= nil then
		t401.ctx = p303.ctx:jsonEncode()
	end

	return t401
end
function t399.jsonDecode(t402: {[any]: any}) -- line: 19658
	-- upvalues: t399 (copy), prop_types (copy)
	local v2956 = t399.new()

	if t402.universe_id ~= nil then
		v2956.universe_id = prop_types.StringProp.jsonDecode(t402.universe_id)
	end

	if t402.universeId ~= nil then
		v2956.universe_id = prop_types.StringProp.jsonDecode(t402.universeId)
	end

	if t402.place_id ~= nil then
		v2956.place_id = prop_types.StringProp.jsonDecode(t402.place_id)
	end

	if t402.placeId ~= nil then
		v2956.place_id = prop_types.StringProp.jsonDecode(t402.placeId)
	end

	if t402.ctx ~= nil then
		v2956.ctx = prop_types.StringProp.jsonDecode(t402.ctx)
	end

	return v2956
end

t399.descriptor = {
	name = "ToggleExperienceFavoriteAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.ToggleExperienceFavoriteAction_Params = t399
typeRegistry.default:register(t1.ToggleExperienceFavoriteAction_Params)

local t403 = {}

t403.__index = t403

function t403.new(t404: {[any]: any}?) -- line: 19701
	-- upvalues: t1 (copy), t403 (copy)
	return (setmetatable({
		action_type = if t404 ~= nil and t404.action_type ~= nil then t404.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t404 ~= nil and t404.action_params ~= nil then t404.action_params else nil
	}, t403))
end
function t403.encode(p304) -- line: 19712
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n200 = 0

	if p304.action_type ~= nil and (p304.action_type ~= nil and p304.action_type ~= 0 or p304.action_type ~= t1.ActionType.fromNumber(0)) then
		local v2961, v2962 = proto.writeTag(buf, n200, 1, proto.wireTypes.varint)

		buf, n200 = proto.writeVarInt(v2961, v2962, t1.ActionType.toNumber(p304.action_type))
	end

	if p304.action_params ~= nil then
		local v2963 = p304.action_params:encode()
		local v2964, v2965 = proto.writeTag(buf, n200, 2, proto.wireTypes.lengthDelimited)

		buf, n200 = proto.writeBuffer(v2964, v2965, v2963, buffer.len(v2963))
	end

	local buf103 = buffer.create(n200)

	buffer.copy(buf103, 0, buf, 0, n200)

	return buf103
end
function t403.decode(p305: buffer) -- line: 19738
	-- upvalues: t403 (copy), proto (copy), t1 (copy)
	local v2968 = t403.new()
	local n201 = 0

	while n201 < buffer.len(p305) do
		local v2970, v2971

		v2970, v2971, n201 = proto.readTag(p305, n201)

		if v2971 == proto.wireTypes.varint then
			if v2970 == 1 then
				local v2972

				v2972, n201 = proto.readVarIntI32(p305, n201)
				v2968.action_type = t1.ActionType.fromNumber(v2972) or v2972
			else
				local v2973

				v2973, n201 = proto.readVarInt(p305, n201)
			end
		elseif v2971 == proto.wireTypes.lengthDelimited then
			if v2970 == 2 then
				local v2974

				v2974, n201 = proto.readBuffer(p305, n201)
				v2968.action_params = t1.ToggleExperienceFollowAction_Params.decode(v2974)
			else
				local v2975, v2976 = proto.readVarInt(p305, n201)

				n201 = v2976 + v2975
			end
		elseif v2971 == proto.wireTypes.i32 then
			local v2977

			v2977, n201 = proto.readFixed32(p305, n201)
		elseif v2971 == proto.wireTypes.i64 then
			local v2978

			v2978, n201 = proto.readFixed64(p305, n201)
		else
			error("Unsupported wire type: " .. v2971)
		end
	end

	return v2968
end
function t403.jsonEncode(p306) -- line: 19786
	-- upvalues: t1 (copy)
	local t405 = {}

	if p306.action_type ~= nil and (p306.action_type ~= nil and p306.action_type ~= 0 or p306.action_type ~= t1.ActionType.fromNumber(0)) then
		t405.actionType = if typeof(p306.action_type) ~= "number" then t1.ActionType.toNumber(p306.action_type) else p306.action_type
	end

	if p306.action_params ~= nil then
		t405.actionParams = p306.action_params:jsonEncode()
	end

	return t405
end
function t403.jsonDecode(t406: {[any]: any}) -- line: 19808
	-- upvalues: t403 (copy), t1 (copy)
	local v2982 = t403.new()

	if t406.action_type ~= nil then
		v2982.action_type = if typeof(t406.action_type) ~= "number" then t1.ActionType.fromName(t406.action_type) or t406.action_type else t1.ActionType.fromNumber(t406.action_type) or t406.action_type
	end

	if t406.actionType ~= nil then
		v2982.action_type = if typeof(t406.actionType) ~= "number" then t1.ActionType.fromName(t406.actionType) or t406.actionType else t1.ActionType.fromNumber(t406.actionType) or t406.actionType
	end

	if t406.action_params ~= nil then
		v2982.action_params = t1.ToggleExperienceFollowAction_Params.jsonDecode(t406.action_params)
	end

	if t406.actionParams ~= nil then
		v2982.action_params = t1.ToggleExperienceFollowAction_Params.jsonDecode(t406.actionParams)
	end

	return v2982
end

t403.descriptor = {
	name = "ToggleExperienceFollowAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.ToggleExperienceFollowAction"
}
t1.ToggleExperienceFollowAction = t403
typeRegistry.default:register(t1.ToggleExperienceFollowAction)

local t407 = {}

t407.__index = t407

function t407.new(t408: {[any]: any}?) -- line: 19848
	-- upvalues: t407 (copy)
	return (setmetatable({
		universe_id = if t408 ~= nil and t408.universe_id ~= nil then t408.universe_id else nil,
		game_name = if t408 ~= nil and t408.game_name ~= nil then t408.game_name else nil,
		ctx = if t408 ~= nil and t408.ctx ~= nil then t408.ctx else nil
	}, t407))
end
function t407.encode(p307) -- line: 19858
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n202 = 0

	if p307.universe_id ~= nil then
		local v2987 = p307.universe_id:encode()
		local v2988, v2989 = proto.writeTag(buf, n202, 1, proto.wireTypes.lengthDelimited)

		buf, n202 = proto.writeBuffer(v2988, v2989, v2987, buffer.len(v2987))
	end

	if p307.game_name ~= nil then
		local v2990 = p307.game_name:encode()
		local v2991, v2992 = proto.writeTag(buf, n202, 2, proto.wireTypes.lengthDelimited)

		buf, n202 = proto.writeBuffer(v2991, v2992, v2990, buffer.len(v2990))
	end

	if p307.ctx ~= nil then
		local v2993 = p307.ctx:encode()
		local v2994, v2995 = proto.writeTag(buf, n202, 3, proto.wireTypes.lengthDelimited)

		buf, n202 = proto.writeBuffer(v2994, v2995, v2993, buffer.len(v2993))
	end

	local buf104 = buffer.create(n202)

	buffer.copy(buf104, 0, buf, 0, n202)

	return buf104
end
function t407.decode(p308: buffer) -- line: 19885
	-- upvalues: t407 (copy), proto (copy), prop_types (copy)
	local v2998 = t407.new()
	local n203 = 0

	while n203 < buffer.len(p308) do
		local v3000, v3001

		v3000, v3001, n203 = proto.readTag(p308, n203)

		if v3001 == proto.wireTypes.varint then
			local v3002

			v3002, n203 = proto.readVarInt(p308, n203)
		elseif v3001 == proto.wireTypes.lengthDelimited then
			if v3000 == 1 then
				local v3003

				v3003, n203 = proto.readBuffer(p308, n203)
				v2998.universe_id = prop_types.StringProp.decode(v3003)
			elseif v3000 == 2 then
				local v3004

				v3004, n203 = proto.readBuffer(p308, n203)
				v2998.game_name = prop_types.StringProp.decode(v3004)
			elseif v3000 == 3 then
				local v3005

				v3005, n203 = proto.readBuffer(p308, n203)
				v2998.ctx = prop_types.StringProp.decode(v3005)
			else
				local v3006, v3007 = proto.readVarInt(p308, n203)

				n203 = v3007 + v3006
			end
		elseif v3001 == proto.wireTypes.i32 then
			local v3008

			v3008, n203 = proto.readFixed32(p308, n203)
		elseif v3001 == proto.wireTypes.i64 then
			local v3009

			v3009, n203 = proto.readFixed64(p308, n203)
		else
			error("Unsupported wire type: " .. v3001)
		end
	end

	return v2998
end
function t407.jsonEncode(p309) -- line: 19938
	local t409 = {}

	if p309.universe_id ~= nil then
		t409.universeId = p309.universe_id:jsonEncode()
	end

	if p309.game_name ~= nil then
		t409.gameName = p309.game_name:jsonEncode()
	end

	if p309.ctx ~= nil then
		t409.ctx = p309.ctx:jsonEncode()
	end

	return t409
end
function t407.jsonDecode(t410: {[any]: any}) -- line: 19956
	-- upvalues: t407 (copy), prop_types (copy)
	local v3013 = t407.new()

	if t410.universe_id ~= nil then
		v3013.universe_id = prop_types.StringProp.jsonDecode(t410.universe_id)
	end

	if t410.universeId ~= nil then
		v3013.universe_id = prop_types.StringProp.jsonDecode(t410.universeId)
	end

	if t410.game_name ~= nil then
		v3013.game_name = prop_types.StringProp.jsonDecode(t410.game_name)
	end

	if t410.gameName ~= nil then
		v3013.game_name = prop_types.StringProp.jsonDecode(t410.gameName)
	end

	if t410.ctx ~= nil then
		v3013.ctx = prop_types.StringProp.jsonDecode(t410.ctx)
	end

	return v3013
end

t407.descriptor = {
	name = "ToggleExperienceFollowAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.ToggleExperienceFollowAction_Params = t407
typeRegistry.default:register(t1.ToggleExperienceFollowAction_Params)

local t411 = {}

t411.__index = t411

function t411.new(t412: {[any]: any}?) -- line: 19999
	-- upvalues: t1 (copy), t411 (copy)
	return (setmetatable({
		action_type = if t412 ~= nil and t412.action_type ~= nil then t412.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t412 ~= nil and t412.action_params ~= nil then t412.action_params else nil
	}, t411))
end
function t411.encode(p310) -- line: 20010
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n204 = 0

	if p310.action_type ~= nil and (p310.action_type ~= nil and p310.action_type ~= 0 or p310.action_type ~= t1.ActionType.fromNumber(0)) then
		local v3018, v3019 = proto.writeTag(buf, n204, 1, proto.wireTypes.varint)

		buf, n204 = proto.writeVarInt(v3018, v3019, t1.ActionType.toNumber(p310.action_type))
	end

	if p310.action_params ~= nil then
		local v3020 = p310.action_params:encode()
		local v3021, v3022 = proto.writeTag(buf, n204, 2, proto.wireTypes.lengthDelimited)

		buf, n204 = proto.writeBuffer(v3021, v3022, v3020, buffer.len(v3020))
	end

	local buf105 = buffer.create(n204)

	buffer.copy(buf105, 0, buf, 0, n204)

	return buf105
end
function t411.decode(p311: buffer) -- line: 20036
	-- upvalues: t411 (copy), proto (copy), t1 (copy)
	local v3025 = t411.new()
	local n205 = 0

	while n205 < buffer.len(p311) do
		local v3027, v3028

		v3027, v3028, n205 = proto.readTag(p311, n205)

		if v3028 == proto.wireTypes.varint then
			if v3027 == 1 then
				local v3029

				v3029, n205 = proto.readVarIntI32(p311, n205)
				v3025.action_type = t1.ActionType.fromNumber(v3029) or v3029
			else
				local v3030

				v3030, n205 = proto.readVarInt(p311, n205)
			end
		elseif v3028 == proto.wireTypes.lengthDelimited then
			if v3027 == 2 then
				local v3031

				v3031, n205 = proto.readBuffer(p311, n205)
				v3025.action_params = t1.ToggleExperienceVoteAction_Params.decode(v3031)
			else
				local v3032, v3033 = proto.readVarInt(p311, n205)

				n205 = v3033 + v3032
			end
		elseif v3028 == proto.wireTypes.i32 then
			local v3034

			v3034, n205 = proto.readFixed32(p311, n205)
		elseif v3028 == proto.wireTypes.i64 then
			local v3035

			v3035, n205 = proto.readFixed64(p311, n205)
		else
			error("Unsupported wire type: " .. v3028)
		end
	end

	return v3025
end
function t411.jsonEncode(p312) -- line: 20084
	-- upvalues: t1 (copy)
	local t413 = {}

	if p312.action_type ~= nil and (p312.action_type ~= nil and p312.action_type ~= 0 or p312.action_type ~= t1.ActionType.fromNumber(0)) then
		t413.actionType = if typeof(p312.action_type) ~= "number" then t1.ActionType.toNumber(p312.action_type) else p312.action_type
	end

	if p312.action_params ~= nil then
		t413.actionParams = p312.action_params:jsonEncode()
	end

	return t413
end
function t411.jsonDecode(t414: {[any]: any}) -- line: 20106
	-- upvalues: t411 (copy), t1 (copy)
	local v3039 = t411.new()

	if t414.action_type ~= nil then
		v3039.action_type = if typeof(t414.action_type) ~= "number" then t1.ActionType.fromName(t414.action_type) or t414.action_type else t1.ActionType.fromNumber(t414.action_type) or t414.action_type
	end

	if t414.actionType ~= nil then
		v3039.action_type = if typeof(t414.actionType) ~= "number" then t1.ActionType.fromName(t414.actionType) or t414.actionType else t1.ActionType.fromNumber(t414.actionType) or t414.actionType
	end

	if t414.action_params ~= nil then
		v3039.action_params = t1.ToggleExperienceVoteAction_Params.jsonDecode(t414.action_params)
	end

	if t414.actionParams ~= nil then
		v3039.action_params = t1.ToggleExperienceVoteAction_Params.jsonDecode(t414.actionParams)
	end

	return v3039
end

t411.descriptor = {
	name = "ToggleExperienceVoteAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.ToggleExperienceVoteAction"
}
t1.ToggleExperienceVoteAction = t411
typeRegistry.default:register(t1.ToggleExperienceVoteAction)

local t415 = {}

t415.__index = t415

function t415.new(t416: {[any]: any}?) -- line: 20146
	-- upvalues: t415 (copy)
	return (setmetatable({
		universe_id = if t416 ~= nil and t416.universe_id ~= nil then t416.universe_id else nil,
		vote_direction = if t416 ~= nil and t416.vote_direction ~= nil then t416.vote_direction else nil,
		place_id = if t416 ~= nil and t416.place_id ~= nil then t416.place_id else nil,
		ctx = if t416 ~= nil and t416.ctx ~= nil then t416.ctx else nil
	}, t415))
end
function t415.encode(p313) -- line: 20157
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n206 = 0

	if p313.universe_id ~= nil then
		local v3044 = p313.universe_id:encode()
		local v3045, v3046 = proto.writeTag(buf, n206, 1, proto.wireTypes.lengthDelimited)

		buf, n206 = proto.writeBuffer(v3045, v3046, v3044, buffer.len(v3044))
	end

	if p313.vote_direction ~= nil then
		local v3047 = p313.vote_direction:encode()
		local v3048, v3049 = proto.writeTag(buf, n206, 2, proto.wireTypes.lengthDelimited)

		buf, n206 = proto.writeBuffer(v3048, v3049, v3047, buffer.len(v3047))
	end

	if p313.place_id ~= nil then
		local v3050 = p313.place_id:encode()
		local v3051, v3052 = proto.writeTag(buf, n206, 3, proto.wireTypes.lengthDelimited)

		buf, n206 = proto.writeBuffer(v3051, v3052, v3050, buffer.len(v3050))
	end

	if p313.ctx ~= nil then
		local v3053 = p313.ctx:encode()
		local v3054, v3055 = proto.writeTag(buf, n206, 4, proto.wireTypes.lengthDelimited)

		buf, n206 = proto.writeBuffer(v3054, v3055, v3053, buffer.len(v3053))
	end

	local buf106 = buffer.create(n206)

	buffer.copy(buf106, 0, buf, 0, n206)

	return buf106
end
function t415.decode(p314: buffer) -- line: 20190
	-- upvalues: t415 (copy), proto (copy), prop_types (copy)
	local v3058 = t415.new()
	local n207 = 0

	while n207 < buffer.len(p314) do
		local v3060, v3061

		v3060, v3061, n207 = proto.readTag(p314, n207)

		if v3061 == proto.wireTypes.varint then
			local v3062

			v3062, n207 = proto.readVarInt(p314, n207)
		elseif v3061 == proto.wireTypes.lengthDelimited then
			if v3060 == 1 then
				local v3063

				v3063, n207 = proto.readBuffer(p314, n207)
				v3058.universe_id = prop_types.StringProp.decode(v3063)
			elseif v3060 == 2 then
				local v3064

				v3064, n207 = proto.readBuffer(p314, n207)
				v3058.vote_direction = prop_types.BoolProp.decode(v3064)
			elseif v3060 == 3 then
				local v3065

				v3065, n207 = proto.readBuffer(p314, n207)
				v3058.place_id = prop_types.StringProp.decode(v3065)
			elseif v3060 == 4 then
				local v3066

				v3066, n207 = proto.readBuffer(p314, n207)
				v3058.ctx = prop_types.StringProp.decode(v3066)
			else
				local v3067, v3068 = proto.readVarInt(p314, n207)

				n207 = v3068 + v3067
			end
		elseif v3061 == proto.wireTypes.i32 then
			local v3069

			v3069, n207 = proto.readFixed32(p314, n207)
		elseif v3061 == proto.wireTypes.i64 then
			local v3070

			v3070, n207 = proto.readFixed64(p314, n207)
		else
			error("Unsupported wire type: " .. v3061)
		end
	end

	return v3058
end
function t415.jsonEncode(p315) -- line: 20248
	local t417 = {}

	if p315.universe_id ~= nil then
		t417.universeId = p315.universe_id:jsonEncode()
	end

	if p315.vote_direction ~= nil then
		t417.voteDirection = p315.vote_direction:jsonEncode()
	end

	if p315.place_id ~= nil then
		t417.placeId = p315.place_id:jsonEncode()
	end

	if p315.ctx ~= nil then
		t417.ctx = p315.ctx:jsonEncode()
	end

	return t417
end
function t415.jsonDecode(t418: {[any]: any}) -- line: 20270
	-- upvalues: t415 (copy), prop_types (copy)
	local v3074 = t415.new()

	if t418.universe_id ~= nil then
		v3074.universe_id = prop_types.StringProp.jsonDecode(t418.universe_id)
	end

	if t418.universeId ~= nil then
		v3074.universe_id = prop_types.StringProp.jsonDecode(t418.universeId)
	end

	if t418.vote_direction ~= nil then
		v3074.vote_direction = prop_types.BoolProp.jsonDecode(t418.vote_direction)
	end

	if t418.voteDirection ~= nil then
		v3074.vote_direction = prop_types.BoolProp.jsonDecode(t418.voteDirection)
	end

	if t418.place_id ~= nil then
		v3074.place_id = prop_types.StringProp.jsonDecode(t418.place_id)
	end

	if t418.placeId ~= nil then
		v3074.place_id = prop_types.StringProp.jsonDecode(t418.placeId)
	end

	if t418.ctx ~= nil then
		v3074.ctx = prop_types.StringProp.jsonDecode(t418.ctx)
	end

	return v3074
end

t415.descriptor = {
	name = "ToggleExperienceVoteAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.ToggleExperienceVoteAction_Params = t415
typeRegistry.default:register(t1.ToggleExperienceVoteAction_Params)

local t419 = {}

t419.__index = t419

function t419.new(t420: {[any]: any}?) -- line: 20323
	-- upvalues: t1 (copy), t419 (copy)
	return (setmetatable({
		action_type = if t420 ~= nil and t420.action_type ~= nil then t420.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t420 ~= nil and t420.action_params ~= nil then t420.action_params else nil
	}, t419))
end
function t419.encode(p316) -- line: 20332
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n208 = 0

	if p316.action_type ~= nil and (p316.action_type ~= nil and p316.action_type ~= 0 or p316.action_type ~= t1.ActionType.fromNumber(0)) then
		local v3079, v3080 = proto.writeTag(buf, n208, 1, proto.wireTypes.varint)

		buf, n208 = proto.writeVarInt(v3079, v3080, t1.ActionType.toNumber(p316.action_type))
	end

	if p316.action_params ~= nil then
		local v3081 = p316.action_params:encode()
		local v3082, v3083 = proto.writeTag(buf, n208, 2, proto.wireTypes.lengthDelimited)

		buf, n208 = proto.writeBuffer(v3082, v3083, v3081, buffer.len(v3081))
	end

	local buf107 = buffer.create(n208)

	buffer.copy(buf107, 0, buf, 0, n208)

	return buf107
end
function t419.decode(p317: buffer) -- line: 20358
	-- upvalues: t419 (copy), proto (copy), t1 (copy)
	local v3086 = t419.new()
	local n209 = 0

	while n209 < buffer.len(p317) do
		local v3088, v3089

		v3088, v3089, n209 = proto.readTag(p317, n209)

		if v3089 == proto.wireTypes.varint then
			if v3088 == 1 then
				local v3090

				v3090, n209 = proto.readVarIntI32(p317, n209)
				v3086.action_type = t1.ActionType.fromNumber(v3090) or v3090
			else
				local v3091

				v3091, n209 = proto.readVarInt(p317, n209)
			end
		elseif v3089 == proto.wireTypes.lengthDelimited then
			if v3088 == 2 then
				local v3092

				v3092, n209 = proto.readBuffer(p317, n209)
				v3086.action_params = t1.OpenPurchasePromptAction_Params.decode(v3092)
			else
				local v3093, v3094 = proto.readVarInt(p317, n209)

				n209 = v3094 + v3093
			end
		elseif v3089 == proto.wireTypes.i32 then
			local v3095

			v3095, n209 = proto.readFixed32(p317, n209)
		elseif v3089 == proto.wireTypes.i64 then
			local v3096

			v3096, n209 = proto.readFixed64(p317, n209)
		else
			error("Unsupported wire type: " .. v3089)
		end
	end

	return v3086
end
function t419.jsonEncode(p318) -- line: 20406
	-- upvalues: t1 (copy)
	local t421 = {}

	if p318.action_type ~= nil and (p318.action_type ~= nil and p318.action_type ~= 0 or p318.action_type ~= t1.ActionType.fromNumber(0)) then
		t421.actionType = if typeof(p318.action_type) ~= "number" then t1.ActionType.toNumber(p318.action_type) else p318.action_type
	end

	if p318.action_params ~= nil then
		t421.actionParams = p318.action_params:jsonEncode()
	end

	return t421
end
function t419.jsonDecode(t422: {[any]: any}) -- line: 20428
	-- upvalues: t419 (copy), t1 (copy)
	local v3100 = t419.new()

	if t422.action_type ~= nil then
		v3100.action_type = if typeof(t422.action_type) ~= "number" then t1.ActionType.fromName(t422.action_type) or t422.action_type else t1.ActionType.fromNumber(t422.action_type) or t422.action_type
	end

	if t422.actionType ~= nil then
		v3100.action_type = if typeof(t422.actionType) ~= "number" then t1.ActionType.fromName(t422.actionType) or t422.actionType else t1.ActionType.fromNumber(t422.actionType) or t422.actionType
	end

	if t422.action_params ~= nil then
		v3100.action_params = t1.OpenPurchasePromptAction_Params.jsonDecode(t422.action_params)
	end

	if t422.actionParams ~= nil then
		v3100.action_params = t1.OpenPurchasePromptAction_Params.jsonDecode(t422.actionParams)
	end

	return v3100
end

t419.descriptor = {
	name = "OpenPurchasePromptAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.OpenPurchasePromptAction"
}
t1.OpenPurchasePromptAction = t419
typeRegistry.default:register(t1.OpenPurchasePromptAction)

local t423 = {}

t423.__index = t423

function t423.new(t424: {[any]: any}?) -- line: 20468
	-- upvalues: t423 (copy)
	return (setmetatable({
		kind = if t424 ~= nil and t424.kind ~= nil then t424.kind else nil
	}, t423))
end
function t423.encode(p319) -- line: 20476
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n210 = 0

	if p319.kind ~= nil then
		if p319.kind.type == "literal" then
			local v3105 = p319.kind.value:encode()
			local v3106, v3107 = proto.writeTag(buf, n210, 1, proto.wireTypes.lengthDelimited)

			buf, n210 = proto.writeBuffer(v3106, v3107, v3105, buffer.len(v3105))
		elseif p319.kind.type == "binding_path" then
			local v3108, v3109 = proto.writeTag(buf, n210, 2, proto.wireTypes.lengthDelimited)

			buf, n210 = proto.writeString(v3108, v3109, p319.kind.value)
		end
	end

	local buf108 = buffer.create(n210)

	buffer.copy(buf108, 0, buf, 0, n210)

	return buf108
end
function t423.decode(p320: buffer) -- line: 20496
	-- upvalues: t423 (copy), proto (copy), t1 (copy)
	local v3112 = t423.new()
	local n211 = 0

	while n211 < buffer.len(p320) do
		local v3114, v3115

		v3114, v3115, n211 = proto.readTag(p320, n211)

		if v3115 == proto.wireTypes.varint then
			local v3116

			v3116, n211 = proto.readVarInt(p320, n211)
		elseif v3115 == proto.wireTypes.lengthDelimited then
			if v3114 == 1 then
				local v3117

				v3117, n211 = proto.readBuffer(p320, n211)
				v3112.kind = {
					type = "literal",
					value = t1.OpenPurchasePromptAction_ProductPayload_ProductPayloadLiteral.decode(v3117)
				}
			elseif v3114 == 2 then
				local v3118

				v3118, n211 = proto.readBuffer(p320, n211)
				v3112.kind = {
					type = "binding_path",
					value = buffer.tostring(v3118)
				}
			else
				local v3119, v3120 = proto.readVarInt(p320, n211)

				n211 = v3120 + v3119
			end
		elseif v3115 == proto.wireTypes.i32 then
			local v3121

			v3121, n211 = proto.readFixed32(p320, n211)
		elseif v3115 == proto.wireTypes.i64 then
			local v3122

			v3122, n211 = proto.readFixed64(p320, n211)
		else
			error("Unsupported wire type: " .. v3115)
		end
	end

	return v3112
end
function t423.jsonEncode(p321) -- line: 20547
	local t425 = {}

	if p321.kind ~= nil then
		if p321.kind.type == "literal" then
			t425.literal = p321.kind.value:jsonEncode()

			return t425
		end

		if p321.kind.type == "binding_path" then
			t425.bindingPath = p321.kind.value
		end
	end

	return t425
end
function t423.jsonDecode(t426: {[any]: any}) -- line: 20561
	-- upvalues: t423 (copy), t1 (copy)
	local v3126 = t423.new()

	if t426.literal ~= nil then
		v3126.kind = {
			type = "literal",
			value = t1.OpenPurchasePromptAction_ProductPayload_ProductPayloadLiteral.jsonDecode(t426.literal)
		}
	end

	if t426.binding_path ~= nil then
		v3126.kind = {
			type = "binding_path",
			value = t426.binding_path
		}
	end

	if t426.bindingPath ~= nil then
		v3126.kind = {
			type = "binding_path",
			value = t426.bindingPath
		}
	end

	return v3126
end

t423.descriptor = {
	name = "OpenPurchasePromptAction_ProductPayload",
	fullName = "roblox.apppageplatform.shared.v1beta1.ProductPayload"
}
t1.OpenPurchasePromptAction_ProductPayload = t423
typeRegistry.default:register(t1.OpenPurchasePromptAction_ProductPayload)

local t427 = {}

t427.__index = t427

function t427.new(t428: {[any]: any}?) -- line: 20601
	-- upvalues: t427 (copy)
	return (setmetatable({
		kind = if t428 ~= nil and t428.kind ~= nil then t428.kind else nil,
		id = if t428 ~= nil and t428.id ~= nil then t428.id else nil,
		subscription_id = if t428 ~= nil and t428.subscription_id ~= nil then t428.subscription_id else nil,
		universe_id = if t428 ~= nil and t428.universe_id ~= nil then t428.universe_id else nil,
		equip_if_purchased = if t428 ~= nil and t428.equip_if_purchased ~= nil then t428.equip_if_purchased else nil,
		name = if t428 ~= nil and t428.name ~= nil then t428.name else nil,
		expected_price = if t428 ~= nil and t428.expected_price ~= nil then t428.expected_price else nil,
		icon_image_asset_id = if t428 ~= nil and t428.icon_image_asset_id ~= nil then t428.icon_image_asset_id else nil,
		is_subscription_in_robux = if t428 ~= nil and t428.is_subscription_in_robux ~= nil then t428.is_subscription_in_robux else nil,
		display_price = if t428 ~= nil and t428.display_price ~= nil then t428.display_price else nil
	}, t427))
end
function t427.encode(p322) -- line: 20627
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n212 = 0

	if p322.kind ~= nil then
		local v3131 = p322.kind:encode()
		local v3132, v3133 = proto.writeTag(buf, n212, 1, proto.wireTypes.lengthDelimited)

		buf, n212 = proto.writeBuffer(v3132, v3133, v3131, buffer.len(v3131))
	end

	if p322.id ~= nil then
		local v3134 = p322.id:encode()
		local v3135, v3136 = proto.writeTag(buf, n212, 2, proto.wireTypes.lengthDelimited)

		buf, n212 = proto.writeBuffer(v3135, v3136, v3134, buffer.len(v3134))
	end

	if p322.subscription_id ~= nil then
		local v3137 = p322.subscription_id:encode()
		local v3138, v3139 = proto.writeTag(buf, n212, 3, proto.wireTypes.lengthDelimited)

		buf, n212 = proto.writeBuffer(v3138, v3139, v3137, buffer.len(v3137))
	end

	if p322.universe_id ~= nil then
		local v3140 = p322.universe_id:encode()
		local v3141, v3142 = proto.writeTag(buf, n212, 4, proto.wireTypes.lengthDelimited)

		buf, n212 = proto.writeBuffer(v3141, v3142, v3140, buffer.len(v3140))
	end

	if p322.equip_if_purchased ~= nil then
		local v3143 = p322.equip_if_purchased:encode()
		local v3144, v3145 = proto.writeTag(buf, n212, 5, proto.wireTypes.lengthDelimited)

		buf, n212 = proto.writeBuffer(v3144, v3145, v3143, buffer.len(v3143))
	end

	if p322.name ~= nil then
		local v3146 = p322.name:encode()
		local v3147, v3148 = proto.writeTag(buf, n212, 6, proto.wireTypes.lengthDelimited)

		buf, n212 = proto.writeBuffer(v3147, v3148, v3146, buffer.len(v3146))
	end

	if p322.expected_price ~= nil then
		local v3149 = p322.expected_price:encode()
		local v3150, v3151 = proto.writeTag(buf, n212, 7, proto.wireTypes.lengthDelimited)

		buf, n212 = proto.writeBuffer(v3150, v3151, v3149, buffer.len(v3149))
	end

	if p322.icon_image_asset_id ~= nil then
		local v3152 = p322.icon_image_asset_id:encode()
		local v3153, v3154 = proto.writeTag(buf, n212, 8, proto.wireTypes.lengthDelimited)

		buf, n212 = proto.writeBuffer(v3153, v3154, v3152, buffer.len(v3152))
	end

	if p322.is_subscription_in_robux ~= nil then
		local v3155 = p322.is_subscription_in_robux:encode()
		local v3156, v3157 = proto.writeTag(buf, n212, 9, proto.wireTypes.lengthDelimited)

		buf, n212 = proto.writeBuffer(v3156, v3157, v3155, buffer.len(v3155))
	end

	if p322.display_price ~= nil then
		local v3158 = p322.display_price:encode()
		local v3159, v3160 = proto.writeTag(buf, n212, 10, proto.wireTypes.lengthDelimited)

		buf, n212 = proto.writeBuffer(v3159, v3160, v3158, buffer.len(v3158))
	end

	local buf109 = buffer.create(n212)

	buffer.copy(buf109, 0, buf, 0, n212)

	return buf109
end
function t427.decode(p323: buffer) -- line: 20698
	-- upvalues: t427 (copy), proto (copy), prop_types (copy)
	local v3163 = t427.new()
	local n213 = 0

	while n213 < buffer.len(p323) do
		local v3165, v3166

		v3165, v3166, n213 = proto.readTag(p323, n213)

		if v3166 == proto.wireTypes.varint then
			local v3167

			v3167, n213 = proto.readVarInt(p323, n213)
		elseif v3166 == proto.wireTypes.lengthDelimited then
			if v3165 == 1 then
				local v3168

				v3168, n213 = proto.readBuffer(p323, n213)
				v3163.kind = prop_types.StringProp.decode(v3168)
			elseif v3165 == 2 then
				local v3169

				v3169, n213 = proto.readBuffer(p323, n213)
				v3163.id = prop_types.StringProp.decode(v3169)
			elseif v3165 == 3 then
				local v3170

				v3170, n213 = proto.readBuffer(p323, n213)
				v3163.subscription_id = prop_types.StringProp.decode(v3170)
			elseif v3165 == 4 then
				local v3171

				v3171, n213 = proto.readBuffer(p323, n213)
				v3163.universe_id = prop_types.StringProp.decode(v3171)
			elseif v3165 == 5 then
				local v3172

				v3172, n213 = proto.readBuffer(p323, n213)
				v3163.equip_if_purchased = prop_types.BoolProp.decode(v3172)
			elseif v3165 == 6 then
				local v3173

				v3173, n213 = proto.readBuffer(p323, n213)
				v3163.name = prop_types.StringProp.decode(v3173)
			elseif v3165 == 7 then
				local v3174

				v3174, n213 = proto.readBuffer(p323, n213)
				v3163.expected_price = prop_types.Int64Prop.decode(v3174)
			elseif v3165 == 8 then
				local v3175

				v3175, n213 = proto.readBuffer(p323, n213)
				v3163.icon_image_asset_id = prop_types.Int64Prop.decode(v3175)
			elseif v3165 == 9 then
				local v3176

				v3176, n213 = proto.readBuffer(p323, n213)
				v3163.is_subscription_in_robux = prop_types.BoolProp.decode(v3176)
			elseif v3165 == 10 then
				local v3177

				v3177, n213 = proto.readBuffer(p323, n213)
				v3163.display_price = prop_types.StringProp.decode(v3177)
			else
				local v3178, v3179 = proto.readVarInt(p323, n213)

				n213 = v3179 + v3178
			end
		elseif v3166 == proto.wireTypes.i32 then
			local v3180

			v3180, n213 = proto.readFixed32(p323, n213)
		elseif v3166 == proto.wireTypes.i64 then
			local v3181

			v3181, n213 = proto.readFixed64(p323, n213)
		else
			error("Unsupported wire type: " .. v3166)
		end
	end

	return v3163
end
function t427.jsonEncode(p324) -- line: 20789
	local t429 = {}

	if p324.kind ~= nil then
		t429.kind = p324.kind:jsonEncode()
	end

	if p324.id ~= nil then
		t429.id = p324.id:jsonEncode()
	end

	if p324.subscription_id ~= nil then
		t429.subscriptionId = p324.subscription_id:jsonEncode()
	end

	if p324.universe_id ~= nil then
		t429.universeId = p324.universe_id:jsonEncode()
	end

	if p324.equip_if_purchased ~= nil then
		t429.equipIfPurchased = p324.equip_if_purchased:jsonEncode()
	end

	if p324.name ~= nil then
		t429.name = p324.name:jsonEncode()
	end

	if p324.expected_price ~= nil then
		t429.expectedPrice = p324.expected_price:jsonEncode()
	end

	if p324.icon_image_asset_id ~= nil then
		t429.iconImageAssetId = p324.icon_image_asset_id:jsonEncode()
	end

	if p324.is_subscription_in_robux ~= nil then
		t429.isSubscriptionInRobux = p324.is_subscription_in_robux:jsonEncode()
	end

	if p324.display_price ~= nil then
		t429.displayPrice = p324.display_price:jsonEncode()
	end

	return t429
end
function t427.jsonDecode(t430: {[any]: any}) -- line: 20837
	-- upvalues: t427 (copy), prop_types (copy)
	local v3185 = t427.new()

	if t430.kind ~= nil then
		v3185.kind = prop_types.StringProp.jsonDecode(t430.kind)
	end

	if t430.id ~= nil then
		v3185.id = prop_types.StringProp.jsonDecode(t430.id)
	end

	if t430.subscription_id ~= nil then
		v3185.subscription_id = prop_types.StringProp.jsonDecode(t430.subscription_id)
	end

	if t430.subscriptionId ~= nil then
		v3185.subscription_id = prop_types.StringProp.jsonDecode(t430.subscriptionId)
	end

	if t430.universe_id ~= nil then
		v3185.universe_id = prop_types.StringProp.jsonDecode(t430.universe_id)
	end

	if t430.universeId ~= nil then
		v3185.universe_id = prop_types.StringProp.jsonDecode(t430.universeId)
	end

	if t430.equip_if_purchased ~= nil then
		v3185.equip_if_purchased = prop_types.BoolProp.jsonDecode(t430.equip_if_purchased)
	end

	if t430.equipIfPurchased ~= nil then
		v3185.equip_if_purchased = prop_types.BoolProp.jsonDecode(t430.equipIfPurchased)
	end

	if t430.name ~= nil then
		v3185.name = prop_types.StringProp.jsonDecode(t430.name)
	end

	if t430.expected_price ~= nil then
		v3185.expected_price = prop_types.Int64Prop.jsonDecode(t430.expected_price)
	end

	if t430.expectedPrice ~= nil then
		v3185.expected_price = prop_types.Int64Prop.jsonDecode(t430.expectedPrice)
	end

	if t430.icon_image_asset_id ~= nil then
		v3185.icon_image_asset_id = prop_types.Int64Prop.jsonDecode(t430.icon_image_asset_id)
	end

	if t430.iconImageAssetId ~= nil then
		v3185.icon_image_asset_id = prop_types.Int64Prop.jsonDecode(t430.iconImageAssetId)
	end

	if t430.is_subscription_in_robux ~= nil then
		v3185.is_subscription_in_robux = prop_types.BoolProp.jsonDecode(t430.is_subscription_in_robux)
	end

	if t430.isSubscriptionInRobux ~= nil then
		v3185.is_subscription_in_robux = prop_types.BoolProp.jsonDecode(t430.isSubscriptionInRobux)
	end

	if t430.display_price ~= nil then
		v3185.display_price = prop_types.StringProp.jsonDecode(t430.display_price)
	end

	if t430.displayPrice ~= nil then
		v3185.display_price = prop_types.StringProp.jsonDecode(t430.displayPrice)
	end

	return v3185
end

t427.descriptor = {
	name = "OpenPurchasePromptAction_ProductPayload_ProductPayloadLiteral",
	fullName = "roblox.apppageplatform.shared.v1beta1.ProductPayloadLiteral"
}
t1.OpenPurchasePromptAction_ProductPayload_ProductPayloadLiteral = t427
typeRegistry.default:register(t1.OpenPurchasePromptAction_ProductPayload_ProductPayloadLiteral)

local t431 = {}

t431.__index = t431

function t431.new(t432: {[any]: any}?) -- line: 20941
	-- upvalues: t431 (copy)
	return (setmetatable({
		kind = if t432 ~= nil and t432.kind ~= nil then t432.kind else nil
	}, t431))
end
function t431.encode(p325) -- line: 20949
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n214 = 0

	if p325.kind ~= nil then
		if p325.kind.type == "literal" then
			local v3190 = p325.kind.value:encode()
			local v3191, v3192 = proto.writeTag(buf, n214, 1, proto.wireTypes.lengthDelimited)

			buf, n214 = proto.writeBuffer(v3191, v3192, v3190, buffer.len(v3190))
		elseif p325.kind.type == "binding_path" then
			local v3193, v3194 = proto.writeTag(buf, n214, 2, proto.wireTypes.lengthDelimited)

			buf, n214 = proto.writeString(v3193, v3194, p325.kind.value)
		end
	end

	local buf110 = buffer.create(n214)

	buffer.copy(buf110, 0, buf, 0, n214)

	return buf110
end
function t431.decode(p326: buffer) -- line: 20969
	-- upvalues: t431 (copy), proto (copy), t1 (copy)
	local v3197 = t431.new()
	local n215 = 0

	while n215 < buffer.len(p326) do
		local v3199, v3200

		v3199, v3200, n215 = proto.readTag(p326, n215)

		if v3200 == proto.wireTypes.varint then
			local v3201

			v3201, n215 = proto.readVarInt(p326, n215)
		elseif v3200 == proto.wireTypes.lengthDelimited then
			if v3199 == 1 then
				local v3202

				v3202, n215 = proto.readBuffer(p326, n215)
				v3197.kind = {
					type = "literal",
					value = t1.OpenPurchasePromptAction_DisplayInfo_DisplayInfoLiteral.decode(v3202)
				}
			elseif v3199 == 2 then
				local v3203

				v3203, n215 = proto.readBuffer(p326, n215)
				v3197.kind = {
					type = "binding_path",
					value = buffer.tostring(v3203)
				}
			else
				local v3204, v3205 = proto.readVarInt(p326, n215)

				n215 = v3205 + v3204
			end
		elseif v3200 == proto.wireTypes.i32 then
			local v3206

			v3206, n215 = proto.readFixed32(p326, n215)
		elseif v3200 == proto.wireTypes.i64 then
			local v3207

			v3207, n215 = proto.readFixed64(p326, n215)
		else
			error("Unsupported wire type: " .. v3200)
		end
	end

	return v3197
end
function t431.jsonEncode(p327) -- line: 21020
	local t433 = {}

	if p327.kind ~= nil then
		if p327.kind.type == "literal" then
			t433.literal = p327.kind.value:jsonEncode()

			return t433
		end

		if p327.kind.type == "binding_path" then
			t433.bindingPath = p327.kind.value
		end
	end

	return t433
end
function t431.jsonDecode(t434: {[any]: any}) -- line: 21034
	-- upvalues: t431 (copy), t1 (copy)
	local v3211 = t431.new()

	if t434.literal ~= nil then
		v3211.kind = {
			type = "literal",
			value = t1.OpenPurchasePromptAction_DisplayInfo_DisplayInfoLiteral.jsonDecode(t434.literal)
		}
	end

	if t434.binding_path ~= nil then
		v3211.kind = {
			type = "binding_path",
			value = t434.binding_path
		}
	end

	if t434.bindingPath ~= nil then
		v3211.kind = {
			type = "binding_path",
			value = t434.bindingPath
		}
	end

	return v3211
end

t431.descriptor = {
	name = "OpenPurchasePromptAction_DisplayInfo",
	fullName = "roblox.apppageplatform.shared.v1beta1.DisplayInfo"
}
t1.OpenPurchasePromptAction_DisplayInfo = t431
typeRegistry.default:register(t1.OpenPurchasePromptAction_DisplayInfo)

local t435 = {}

t435.__index = t435

function t435.new(t436: {[any]: any}?) -- line: 21072
	-- upvalues: t435 (copy)
	return (setmetatable({
		product_name = if t436 ~= nil and t436.product_name ~= nil then t436.product_name else nil,
		description = if t436 ~= nil and t436.description ~= nil then t436.description else nil,
		image_url = if t436 ~= nil and t436.image_url ~= nil then t436.image_url else nil,
		price_in_robux = if t436 ~= nil and t436.price_in_robux ~= nil then t436.price_in_robux else nil,
		display_price = if t436 ~= nil and t436.display_price ~= nil then t436.display_price else nil,
		icon_image_asset_id = if t436 ~= nil and t436.icon_image_asset_id ~= nil then t436.icon_image_asset_id else nil,
		product_id = if t436 ~= nil and t436.product_id ~= nil then t436.product_id else nil,
		target_id = if t436 ~= nil and t436.target_id ~= nil then t436.target_id else nil,
		is_for_sale = if t436 ~= nil and t436.is_for_sale ~= nil then t436.is_for_sale else nil,
		product_type = if t436 ~= nil and t436.product_type ~= nil then t436.product_type else nil,
		base_price_in_robux = if t436 ~= nil and t436.base_price_in_robux ~= nil then t436.base_price_in_robux else nil,
		price_discount_details = if t436 ~= nil and t436.price_discount_details ~= nil then t436.price_discount_details else nil
	}, t435))
end
function t435.encode(p328) -- line: 21100
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n216 = 0

	if p328.product_name ~= nil then
		local v3216 = p328.product_name:encode()
		local v3217, v3218 = proto.writeTag(buf, n216, 1, proto.wireTypes.lengthDelimited)

		buf, n216 = proto.writeBuffer(v3217, v3218, v3216, buffer.len(v3216))
	end

	if p328.description ~= nil then
		local v3219 = p328.description:encode()
		local v3220, v3221 = proto.writeTag(buf, n216, 2, proto.wireTypes.lengthDelimited)

		buf, n216 = proto.writeBuffer(v3220, v3221, v3219, buffer.len(v3219))
	end

	if p328.image_url ~= nil then
		local v3222 = p328.image_url:encode()
		local v3223, v3224 = proto.writeTag(buf, n216, 3, proto.wireTypes.lengthDelimited)

		buf, n216 = proto.writeBuffer(v3223, v3224, v3222, buffer.len(v3222))
	end

	if p328.price_in_robux ~= nil then
		local v3225 = p328.price_in_robux:encode()
		local v3226, v3227 = proto.writeTag(buf, n216, 4, proto.wireTypes.lengthDelimited)

		buf, n216 = proto.writeBuffer(v3226, v3227, v3225, buffer.len(v3225))
	end

	if p328.display_price ~= nil then
		local v3228 = p328.display_price:encode()
		local v3229, v3230 = proto.writeTag(buf, n216, 5, proto.wireTypes.lengthDelimited)

		buf, n216 = proto.writeBuffer(v3229, v3230, v3228, buffer.len(v3228))
	end

	if p328.icon_image_asset_id ~= nil then
		local v3231 = p328.icon_image_asset_id:encode()
		local v3232, v3233 = proto.writeTag(buf, n216, 6, proto.wireTypes.lengthDelimited)

		buf, n216 = proto.writeBuffer(v3232, v3233, v3231, buffer.len(v3231))
	end

	if p328.product_id ~= nil then
		local v3234 = p328.product_id:encode()
		local v3235, v3236 = proto.writeTag(buf, n216, 7, proto.wireTypes.lengthDelimited)

		buf, n216 = proto.writeBuffer(v3235, v3236, v3234, buffer.len(v3234))
	end

	if p328.target_id ~= nil then
		local v3237 = p328.target_id:encode()
		local v3238, v3239 = proto.writeTag(buf, n216, 8, proto.wireTypes.lengthDelimited)

		buf, n216 = proto.writeBuffer(v3238, v3239, v3237, buffer.len(v3237))
	end

	if p328.is_for_sale ~= nil then
		local v3240 = p328.is_for_sale:encode()
		local v3241, v3242 = proto.writeTag(buf, n216, 9, proto.wireTypes.lengthDelimited)

		buf, n216 = proto.writeBuffer(v3241, v3242, v3240, buffer.len(v3240))
	end

	if p328.product_type ~= nil then
		local v3243 = p328.product_type:encode()
		local v3244, v3245 = proto.writeTag(buf, n216, 10, proto.wireTypes.lengthDelimited)

		buf, n216 = proto.writeBuffer(v3244, v3245, v3243, buffer.len(v3243))
	end

	if p328.base_price_in_robux ~= nil then
		local v3246 = p328.base_price_in_robux:encode()
		local v3247, v3248 = proto.writeTag(buf, n216, 11, proto.wireTypes.lengthDelimited)

		buf, n216 = proto.writeBuffer(v3247, v3248, v3246, buffer.len(v3246))
	end

	if p328.price_discount_details ~= nil then
		local v3249 = p328.price_discount_details:encode()
		local v3250, v3251 = proto.writeTag(buf, n216, 12, proto.wireTypes.lengthDelimited)

		buf, n216 = proto.writeBuffer(v3250, v3251, v3249, buffer.len(v3249))
	end

	local buf111 = buffer.create(n216)

	buffer.copy(buf111, 0, buf, 0, n216)

	return buf111
end
function t435.decode(p329: buffer) -- line: 21183
	-- upvalues: t435 (copy), proto (copy), prop_types (copy)
	local v3254 = t435.new()
	local n217 = 0

	while n217 < buffer.len(p329) do
		local v3256, v3257

		v3256, v3257, n217 = proto.readTag(p329, n217)

		if v3257 == proto.wireTypes.varint then
			local v3258

			v3258, n217 = proto.readVarInt(p329, n217)
		elseif v3257 == proto.wireTypes.lengthDelimited then
			if v3256 == 1 then
				local v3259

				v3259, n217 = proto.readBuffer(p329, n217)
				v3254.product_name = prop_types.StringProp.decode(v3259)
			elseif v3256 == 2 then
				local v3260

				v3260, n217 = proto.readBuffer(p329, n217)
				v3254.description = prop_types.StringProp.decode(v3260)
			elseif v3256 == 3 then
				local v3261

				v3261, n217 = proto.readBuffer(p329, n217)
				v3254.image_url = prop_types.StringProp.decode(v3261)
			elseif v3256 == 4 then
				local v3262

				v3262, n217 = proto.readBuffer(p329, n217)
				v3254.price_in_robux = prop_types.Int64Prop.decode(v3262)
			elseif v3256 == 5 then
				local v3263

				v3263, n217 = proto.readBuffer(p329, n217)
				v3254.display_price = prop_types.StringProp.decode(v3263)
			elseif v3256 == 6 then
				local v3264

				v3264, n217 = proto.readBuffer(p329, n217)
				v3254.icon_image_asset_id = prop_types.Int64Prop.decode(v3264)
			elseif v3256 == 7 then
				local v3265

				v3265, n217 = proto.readBuffer(p329, n217)
				v3254.product_id = prop_types.Int64Prop.decode(v3265)
			elseif v3256 == 8 then
				local v3266

				v3266, n217 = proto.readBuffer(p329, n217)
				v3254.target_id = prop_types.StringProp.decode(v3266)
			elseif v3256 == 9 then
				local v3267

				v3267, n217 = proto.readBuffer(p329, n217)
				v3254.is_for_sale = prop_types.BoolProp.decode(v3267)
			elseif v3256 == 10 then
				local v3268

				v3268, n217 = proto.readBuffer(p329, n217)
				v3254.product_type = prop_types.StringProp.decode(v3268)
			elseif v3256 == 11 then
				local v3269

				v3269, n217 = proto.readBuffer(p329, n217)
				v3254.base_price_in_robux = prop_types.Int64Prop.decode(v3269)
			elseif v3256 == 12 then
				local v3270

				v3270, n217 = proto.readBuffer(p329, n217)
				v3254.price_discount_details = prop_types.ArrayOfStructProp.decode(v3270)
			else
				local v3271, v3272 = proto.readVarInt(p329, n217)

				n217 = v3272 + v3271
			end
		elseif v3257 == proto.wireTypes.i32 then
			local v3273

			v3273, n217 = proto.readFixed32(p329, n217)
		elseif v3257 == proto.wireTypes.i64 then
			local v3274

			v3274, n217 = proto.readFixed64(p329, n217)
		else
			error("Unsupported wire type: " .. v3257)
		end
	end

	return v3254
end
function t435.jsonEncode(p330) -- line: 21284
	local t437 = {}

	if p330.product_name ~= nil then
		t437.productName = p330.product_name:jsonEncode()
	end

	if p330.description ~= nil then
		t437.description = p330.description:jsonEncode()
	end

	if p330.image_url ~= nil then
		t437.imageUrl = p330.image_url:jsonEncode()
	end

	if p330.price_in_robux ~= nil then
		t437.priceInRobux = p330.price_in_robux:jsonEncode()
	end

	if p330.display_price ~= nil then
		t437.displayPrice = p330.display_price:jsonEncode()
	end

	if p330.icon_image_asset_id ~= nil then
		t437.iconImageAssetId = p330.icon_image_asset_id:jsonEncode()
	end

	if p330.product_id ~= nil then
		t437.productId = p330.product_id:jsonEncode()
	end

	if p330.target_id ~= nil then
		t437.targetId = p330.target_id:jsonEncode()
	end

	if p330.is_for_sale ~= nil then
		t437.isForSale = p330.is_for_sale:jsonEncode()
	end

	if p330.product_type ~= nil then
		t437.productType = p330.product_type:jsonEncode()
	end

	if p330.base_price_in_robux ~= nil then
		t437.basePriceInRobux = p330.base_price_in_robux:jsonEncode()
	end

	if p330.price_discount_details ~= nil then
		t437.priceDiscountDetails = p330.price_discount_details:jsonEncode()
	end

	return t437
end
function t435.jsonDecode(t438: {[any]: any}) -- line: 21340
	-- upvalues: t435 (copy), prop_types (copy)
	local v3278 = t435.new()

	if t438.product_name ~= nil then
		v3278.product_name = prop_types.StringProp.jsonDecode(t438.product_name)
	end

	if t438.productName ~= nil then
		v3278.product_name = prop_types.StringProp.jsonDecode(t438.productName)
	end

	if t438.description ~= nil then
		v3278.description = prop_types.StringProp.jsonDecode(t438.description)
	end

	if t438.image_url ~= nil then
		v3278.image_url = prop_types.StringProp.jsonDecode(t438.image_url)
	end

	if t438.imageUrl ~= nil then
		v3278.image_url = prop_types.StringProp.jsonDecode(t438.imageUrl)
	end

	if t438.price_in_robux ~= nil then
		v3278.price_in_robux = prop_types.Int64Prop.jsonDecode(t438.price_in_robux)
	end

	if t438.priceInRobux ~= nil then
		v3278.price_in_robux = prop_types.Int64Prop.jsonDecode(t438.priceInRobux)
	end

	if t438.display_price ~= nil then
		v3278.display_price = prop_types.StringProp.jsonDecode(t438.display_price)
	end

	if t438.displayPrice ~= nil then
		v3278.display_price = prop_types.StringProp.jsonDecode(t438.displayPrice)
	end

	if t438.icon_image_asset_id ~= nil then
		v3278.icon_image_asset_id = prop_types.Int64Prop.jsonDecode(t438.icon_image_asset_id)
	end

	if t438.iconImageAssetId ~= nil then
		v3278.icon_image_asset_id = prop_types.Int64Prop.jsonDecode(t438.iconImageAssetId)
	end

	if t438.product_id ~= nil then
		v3278.product_id = prop_types.Int64Prop.jsonDecode(t438.product_id)
	end

	if t438.productId ~= nil then
		v3278.product_id = prop_types.Int64Prop.jsonDecode(t438.productId)
	end

	if t438.target_id ~= nil then
		v3278.target_id = prop_types.StringProp.jsonDecode(t438.target_id)
	end

	if t438.targetId ~= nil then
		v3278.target_id = prop_types.StringProp.jsonDecode(t438.targetId)
	end

	if t438.is_for_sale ~= nil then
		v3278.is_for_sale = prop_types.BoolProp.jsonDecode(t438.is_for_sale)
	end

	if t438.isForSale ~= nil then
		v3278.is_for_sale = prop_types.BoolProp.jsonDecode(t438.isForSale)
	end

	if t438.product_type ~= nil then
		v3278.product_type = prop_types.StringProp.jsonDecode(t438.product_type)
	end

	if t438.productType ~= nil then
		v3278.product_type = prop_types.StringProp.jsonDecode(t438.productType)
	end

	if t438.base_price_in_robux ~= nil then
		v3278.base_price_in_robux = prop_types.Int64Prop.jsonDecode(t438.base_price_in_robux)
	end

	if t438.basePriceInRobux ~= nil then
		v3278.base_price_in_robux = prop_types.Int64Prop.jsonDecode(t438.basePriceInRobux)
	end

	if t438.price_discount_details ~= nil then
		v3278.price_discount_details = prop_types.ArrayOfStructProp.jsonDecode(t438.price_discount_details)
	end

	if t438.priceDiscountDetails ~= nil then
		v3278.price_discount_details = prop_types.ArrayOfStructProp.jsonDecode(t438.priceDiscountDetails)
	end

	return v3278
end

t435.descriptor = {
	name = "OpenPurchasePromptAction_DisplayInfo_DisplayInfoLiteral",
	fullName = "roblox.apppageplatform.shared.v1beta1.DisplayInfoLiteral"
}
t1.OpenPurchasePromptAction_DisplayInfo_DisplayInfoLiteral = t435
typeRegistry.default:register(t1.OpenPurchasePromptAction_DisplayInfo_DisplayInfoLiteral)

local t439 = {}

t439.__index = t439

function t439.new(t440: {[any]: any}?) -- line: 21474
	-- upvalues: t439 (copy)
	return (setmetatable({
		kind = if t440 ~= nil and t440.kind ~= nil then t440.kind else nil
	}, t439))
end
function t439.encode(p331) -- line: 21482
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n218 = 0

	if p331.kind ~= nil then
		if p331.kind.type == "literal" then
			local v3283 = p331.kind.value:encode()
			local v3284, v3285 = proto.writeTag(buf, n218, 1, proto.wireTypes.lengthDelimited)

			buf, n218 = proto.writeBuffer(v3284, v3285, v3283, buffer.len(v3283))
		elseif p331.kind.type == "binding_path" then
			local v3286, v3287 = proto.writeTag(buf, n218, 2, proto.wireTypes.lengthDelimited)

			buf, n218 = proto.writeString(v3286, v3287, p331.kind.value)
		end
	end

	local buf112 = buffer.create(n218)

	buffer.copy(buf112, 0, buf, 0, n218)

	return buf112
end
function t439.decode(p332: buffer) -- line: 21504
	-- upvalues: t439 (copy), proto (copy), t1 (copy)
	local v3290 = t439.new()
	local n219 = 0

	while n219 < buffer.len(p332) do
		local v3292, v3293

		v3292, v3293, n219 = proto.readTag(p332, n219)

		if v3293 == proto.wireTypes.varint then
			local v3294

			v3294, n219 = proto.readVarInt(p332, n219)
		elseif v3293 == proto.wireTypes.lengthDelimited then
			if v3292 == 1 then
				local v3295

				v3295, n219 = proto.readBuffer(p332, n219)
				v3290.kind = {
					type = "literal",
					value = t1.OpenPurchasePromptAction_PurchaseOptions_PurchaseOptionsLiteral.decode(v3295)
				}
			elseif v3292 == 2 then
				local v3296

				v3296, n219 = proto.readBuffer(p332, n219)
				v3290.kind = {
					type = "binding_path",
					value = buffer.tostring(v3296)
				}
			else
				local v3297, v3298 = proto.readVarInt(p332, n219)

				n219 = v3298 + v3297
			end
		elseif v3293 == proto.wireTypes.i32 then
			local v3299

			v3299, n219 = proto.readFixed32(p332, n219)
		elseif v3293 == proto.wireTypes.i64 then
			local v3300

			v3300, n219 = proto.readFixed64(p332, n219)
		else
			error("Unsupported wire type: " .. v3293)
		end
	end

	return v3290
end
function t439.jsonEncode(p333) -- line: 21557
	local t441 = {}

	if p333.kind ~= nil then
		if p333.kind.type == "literal" then
			t441.literal = p333.kind.value:jsonEncode()

			return t441
		end

		if p333.kind.type == "binding_path" then
			t441.bindingPath = p333.kind.value
		end
	end

	return t441
end
function t439.jsonDecode(t442: {[any]: any}) -- line: 21573
	-- upvalues: t439 (copy), t1 (copy)
	local v3304 = t439.new()

	if t442.literal ~= nil then
		v3304.kind = {
			type = "literal",
			value = t1.OpenPurchasePromptAction_PurchaseOptions_PurchaseOptionsLiteral.jsonDecode(t442.literal)
		}
	end

	if t442.binding_path ~= nil then
		v3304.kind = {
			type = "binding_path",
			value = t442.binding_path
		}
	end

	if t442.bindingPath ~= nil then
		v3304.kind = {
			type = "binding_path",
			value = t442.bindingPath
		}
	end

	return v3304
end

t439.descriptor = {
	name = "OpenPurchasePromptAction_PurchaseOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.PurchaseOptions"
}
t1.OpenPurchasePromptAction_PurchaseOptions = t439
typeRegistry.default:register(t1.OpenPurchasePromptAction_PurchaseOptions)

local t443 = {}

t443.__index = t443

function t443.new(t444: {[any]: any}?) -- line: 21613
	-- upvalues: t443 (copy)
	return (setmetatable({
		should_skip_ownership_check = if t444 ~= nil and t444.should_skip_ownership_check ~= nil then t444.should_skip_ownership_check else nil,
		enable_preloaded_purchase_ui = if t444 ~= nil and t444.enable_preloaded_purchase_ui ~= nil then t444.enable_preloaded_purchase_ui else nil,
		completion_message = if t444 ~= nil and t444.completion_message ~= nil then t444.completion_message else nil,
		completion_button_text = if t444 ~= nil and t444.completion_button_text ~= nil then t444.completion_button_text else nil,
		prevent_double_confirm = if t444 ~= nil and t444.prevent_double_confirm ~= nil then t444.prevent_double_confirm else nil,
		provided_robux_balance = if t444 ~= nil and t444.provided_robux_balance ~= nil then t444.provided_robux_balance else nil
	}, t443))
end
function t443.encode(p334) -- line: 21641
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n220 = 0

	if p334.should_skip_ownership_check ~= nil then
		local v3309 = p334.should_skip_ownership_check:encode()
		local v3310, v3311 = proto.writeTag(buf, n220, 1, proto.wireTypes.lengthDelimited)

		buf, n220 = proto.writeBuffer(v3310, v3311, v3309, buffer.len(v3309))
	end

	if p334.enable_preloaded_purchase_ui ~= nil then
		local v3312 = p334.enable_preloaded_purchase_ui:encode()
		local v3313, v3314 = proto.writeTag(buf, n220, 2, proto.wireTypes.lengthDelimited)

		buf, n220 = proto.writeBuffer(v3313, v3314, v3312, buffer.len(v3312))
	end

	if p334.completion_message ~= nil then
		local v3315 = p334.completion_message:encode()
		local v3316, v3317 = proto.writeTag(buf, n220, 3, proto.wireTypes.lengthDelimited)

		buf, n220 = proto.writeBuffer(v3316, v3317, v3315, buffer.len(v3315))
	end

	if p334.completion_button_text ~= nil then
		local v3318 = p334.completion_button_text:encode()
		local v3319, v3320 = proto.writeTag(buf, n220, 4, proto.wireTypes.lengthDelimited)

		buf, n220 = proto.writeBuffer(v3319, v3320, v3318, buffer.len(v3318))
	end

	if p334.prevent_double_confirm ~= nil then
		local v3321 = p334.prevent_double_confirm:encode()
		local v3322, v3323 = proto.writeTag(buf, n220, 5, proto.wireTypes.lengthDelimited)

		buf, n220 = proto.writeBuffer(v3322, v3323, v3321, buffer.len(v3321))
	end

	if p334.provided_robux_balance ~= nil then
		local v3324 = p334.provided_robux_balance:encode()
		local v3325, v3326 = proto.writeTag(buf, n220, 6, proto.wireTypes.lengthDelimited)

		buf, n220 = proto.writeBuffer(v3325, v3326, v3324, buffer.len(v3324))
	end

	local buf113 = buffer.create(n220)

	buffer.copy(buf113, 0, buf, 0, n220)

	return buf113
end
function t443.decode(p335: buffer) -- line: 21688
	-- upvalues: t443 (copy), proto (copy), prop_types (copy)
	local v3329 = t443.new()
	local n221 = 0

	while n221 < buffer.len(p335) do
		local v3331, v3332

		v3331, v3332, n221 = proto.readTag(p335, n221)

		if v3332 == proto.wireTypes.varint then
			local v3333

			v3333, n221 = proto.readVarInt(p335, n221)
		elseif v3332 == proto.wireTypes.lengthDelimited then
			if v3331 == 1 then
				local v3334

				v3334, n221 = proto.readBuffer(p335, n221)
				v3329.should_skip_ownership_check = prop_types.BoolProp.decode(v3334)
			elseif v3331 == 2 then
				local v3335

				v3335, n221 = proto.readBuffer(p335, n221)
				v3329.enable_preloaded_purchase_ui = prop_types.BoolProp.decode(v3335)
			elseif v3331 == 3 then
				local v3336

				v3336, n221 = proto.readBuffer(p335, n221)
				v3329.completion_message = prop_types.StringProp.decode(v3336)
			elseif v3331 == 4 then
				local v3337

				v3337, n221 = proto.readBuffer(p335, n221)
				v3329.completion_button_text = prop_types.StringProp.decode(v3337)
			elseif v3331 == 5 then
				local v3338

				v3338, n221 = proto.readBuffer(p335, n221)
				v3329.prevent_double_confirm = prop_types.BoolProp.decode(v3338)
			elseif v3331 == 6 then
				local v3339

				v3339, n221 = proto.readBuffer(p335, n221)
				v3329.provided_robux_balance = prop_types.Int64Prop.decode(v3339)
			else
				local v3340, v3341 = proto.readVarInt(p335, n221)

				n221 = v3341 + v3340
			end
		elseif v3332 == proto.wireTypes.i32 then
			local v3342

			v3342, n221 = proto.readFixed32(p335, n221)
		elseif v3332 == proto.wireTypes.i64 then
			local v3343

			v3343, n221 = proto.readFixed64(p335, n221)
		else
			error("Unsupported wire type: " .. v3332)
		end
	end

	return v3329
end
function t443.jsonEncode(p336) -- line: 21763
	local t445 = {}

	if p336.should_skip_ownership_check ~= nil then
		t445.shouldSkipOwnershipCheck = p336.should_skip_ownership_check:jsonEncode()
	end

	if p336.enable_preloaded_purchase_ui ~= nil then
		t445.enablePreloadedPurchaseUi = p336.enable_preloaded_purchase_ui:jsonEncode()
	end

	if p336.completion_message ~= nil then
		t445.completionMessage = p336.completion_message:jsonEncode()
	end

	if p336.completion_button_text ~= nil then
		t445.completionButtonText = p336.completion_button_text:jsonEncode()
	end

	if p336.prevent_double_confirm ~= nil then
		t445.preventDoubleConfirm = p336.prevent_double_confirm:jsonEncode()
	end

	if p336.provided_robux_balance ~= nil then
		t445.providedRobuxBalance = p336.provided_robux_balance:jsonEncode()
	end

	return t445
end
function t443.jsonDecode(t446: {[any]: any}) -- line: 21795
	-- upvalues: t443 (copy), prop_types (copy)
	local v3347 = t443.new()

	if t446.should_skip_ownership_check ~= nil then
		v3347.should_skip_ownership_check = prop_types.BoolProp.jsonDecode(t446.should_skip_ownership_check)
	end

	if t446.shouldSkipOwnershipCheck ~= nil then
		v3347.should_skip_ownership_check = prop_types.BoolProp.jsonDecode(t446.shouldSkipOwnershipCheck)
	end

	if t446.enable_preloaded_purchase_ui ~= nil then
		v3347.enable_preloaded_purchase_ui = prop_types.BoolProp.jsonDecode(t446.enable_preloaded_purchase_ui)
	end

	if t446.enablePreloadedPurchaseUi ~= nil then
		v3347.enable_preloaded_purchase_ui = prop_types.BoolProp.jsonDecode(t446.enablePreloadedPurchaseUi)
	end

	if t446.completion_message ~= nil then
		v3347.completion_message = prop_types.StringProp.jsonDecode(t446.completion_message)
	end

	if t446.completionMessage ~= nil then
		v3347.completion_message = prop_types.StringProp.jsonDecode(t446.completionMessage)
	end

	if t446.completion_button_text ~= nil then
		v3347.completion_button_text = prop_types.StringProp.jsonDecode(t446.completion_button_text)
	end

	if t446.completionButtonText ~= nil then
		v3347.completion_button_text = prop_types.StringProp.jsonDecode(t446.completionButtonText)
	end

	if t446.prevent_double_confirm ~= nil then
		v3347.prevent_double_confirm = prop_types.BoolProp.jsonDecode(t446.prevent_double_confirm)
	end

	if t446.preventDoubleConfirm ~= nil then
		v3347.prevent_double_confirm = prop_types.BoolProp.jsonDecode(t446.preventDoubleConfirm)
	end

	if t446.provided_robux_balance ~= nil then
		v3347.provided_robux_balance = prop_types.Int64Prop.jsonDecode(t446.provided_robux_balance)
	end

	if t446.providedRobuxBalance ~= nil then
		v3347.provided_robux_balance = prop_types.Int64Prop.jsonDecode(t446.providedRobuxBalance)
	end

	return v3347
end

t443.descriptor = {
	name = "OpenPurchasePromptAction_PurchaseOptions_PurchaseOptionsLiteral",
	fullName = "roblox.apppageplatform.shared.v1beta1.PurchaseOptionsLiteral"
}
t1.OpenPurchasePromptAction_PurchaseOptions_PurchaseOptionsLiteral = t443
typeRegistry.default:register(t1.OpenPurchasePromptAction_PurchaseOptions_PurchaseOptionsLiteral)

local t447 = {}

t447.__index = t447

function t447.new(t448: {[any]: any}?) -- line: 21880
	-- upvalues: t447 (copy)
	return (setmetatable({
		kind = if t448 ~= nil and t448.kind ~= nil then t448.kind else nil
	}, t447))
end
function t447.encode(p337) -- line: 21891
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n222 = 0

	if p337.kind ~= nil then
		if p337.kind.type == "literal" then
			local v3352 = p337.kind.value:encode()
			local v3353, v3354 = proto.writeTag(buf, n222, 1, proto.wireTypes.lengthDelimited)

			buf, n222 = proto.writeBuffer(v3353, v3354, v3352, buffer.len(v3352))
		elseif p337.kind.type == "binding_path" then
			local v3355, v3356 = proto.writeTag(buf, n222, 2, proto.wireTypes.lengthDelimited)

			buf, n222 = proto.writeString(v3355, v3356, p337.kind.value)
		end
	end

	local buf114 = buffer.create(n222)

	buffer.copy(buf114, 0, buf, 0, n222)

	return buf114
end
function t447.decode(p338: buffer) -- line: 21913
	-- upvalues: t447 (copy), proto (copy), t1 (copy)
	local v3359 = t447.new()
	local n223 = 0

	while n223 < buffer.len(p338) do
		local v3361, v3362

		v3361, v3362, n223 = proto.readTag(p338, n223)

		if v3362 == proto.wireTypes.varint then
			local v3363

			v3363, n223 = proto.readVarInt(p338, n223)
		elseif v3362 == proto.wireTypes.lengthDelimited then
			if v3361 == 1 then
				local v3364

				v3364, n223 = proto.readBuffer(p338, n223)
				v3359.kind = {
					type = "literal",
					value = t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata_PurchaseAnalyticsMetadataLiteral.decode(v3364)
				}
			elseif v3361 == 2 then
				local v3365

				v3365, n223 = proto.readBuffer(p338, n223)
				v3359.kind = {
					type = "binding_path",
					value = buffer.tostring(v3365)
				}
			else
				local v3366, v3367 = proto.readVarInt(p338, n223)

				n223 = v3367 + v3366
			end
		elseif v3362 == proto.wireTypes.i32 then
			local v3368

			v3368, n223 = proto.readFixed32(p338, n223)
		elseif v3362 == proto.wireTypes.i64 then
			local v3369

			v3369, n223 = proto.readFixed64(p338, n223)
		else
			error("Unsupported wire type: " .. v3362)
		end
	end

	return v3359
end
function t447.jsonEncode(p339) -- line: 21968
	local t449 = {}

	if p339.kind ~= nil then
		if p339.kind.type == "literal" then
			t449.literal = p339.kind.value:jsonEncode()

			return t449
		end

		if p339.kind.type == "binding_path" then
			t449.bindingPath = p339.kind.value
		end
	end

	return t449
end
function t447.jsonDecode(t450: {[any]: any}) -- line: 21984
	-- upvalues: t447 (copy), t1 (copy)
	local v3373 = t447.new()

	if t450.literal ~= nil then
		v3373.kind = {
			type = "literal",
			value = t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata_PurchaseAnalyticsMetadataLiteral.jsonDecode(t450.literal)
		}
	end

	if t450.binding_path ~= nil then
		v3373.kind = {
			type = "binding_path",
			value = t450.binding_path
		}
	end

	if t450.bindingPath ~= nil then
		v3373.kind = {
			type = "binding_path",
			value = t450.bindingPath
		}
	end

	return v3373
end

t447.descriptor = {
	name = "OpenPurchasePromptAction_PurchaseAnalyticsMetadata",
	fullName = "roblox.apppageplatform.shared.v1beta1.PurchaseAnalyticsMetadata"
}
t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata = t447
typeRegistry.default:register(t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata)

local t451 = {}

t451.__index = t451

function t451.new(t452: {[any]: any}?) -- line: 22025
	-- upvalues: t451 (copy)
	return (setmetatable({
		surface = if t452 ~= nil and t452.surface ~= nil then t452.surface else nil,
		product_universe_id = if t452 ~= nil and t452.product_universe_id ~= nil then t452.product_universe_id else nil
	}, t451))
end
function t451.encode(p340) -- line: 22039
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n224 = 0

	if p340.surface ~= nil then
		local v3378 = p340.surface:encode()
		local v3379, v3380 = proto.writeTag(buf, n224, 1, proto.wireTypes.lengthDelimited)

		buf, n224 = proto.writeBuffer(v3379, v3380, v3378, buffer.len(v3378))
	end

	if p340.product_universe_id ~= nil then
		local v3381 = p340.product_universe_id:encode()
		local v3382, v3383 = proto.writeTag(buf, n224, 2, proto.wireTypes.lengthDelimited)

		buf, n224 = proto.writeBuffer(v3382, v3383, v3381, buffer.len(v3381))
	end

	local buf115 = buffer.create(n224)

	buffer.copy(buf115, 0, buf, 0, n224)

	return buf115
end
function t451.decode(p341: buffer) -- line: 22062
	-- upvalues: t451 (copy), proto (copy), prop_types (copy)
	local v3386 = t451.new()
	local n225 = 0

	while n225 < buffer.len(p341) do
		local v3388, v3389

		v3388, v3389, n225 = proto.readTag(p341, n225)

		if v3389 == proto.wireTypes.varint then
			local v3390

			v3390, n225 = proto.readVarInt(p341, n225)
		elseif v3389 == proto.wireTypes.lengthDelimited then
			if v3388 == 1 then
				local v3391

				v3391, n225 = proto.readBuffer(p341, n225)
				v3386.surface = prop_types.StringProp.decode(v3391)
			elseif v3388 == 2 then
				local v3392

				v3392, n225 = proto.readBuffer(p341, n225)
				v3386.product_universe_id = prop_types.StringProp.decode(v3392)
			else
				local v3393, v3394 = proto.readVarInt(p341, n225)

				n225 = v3394 + v3393
			end
		elseif v3389 == proto.wireTypes.i32 then
			local v3395

			v3395, n225 = proto.readFixed32(p341, n225)
		elseif v3389 == proto.wireTypes.i64 then
			local v3396

			v3396, n225 = proto.readFixed64(p341, n225)
		else
			error("Unsupported wire type: " .. v3389)
		end
	end

	return v3386
end
function t451.jsonEncode(p342) -- line: 22113
	local t453 = {}

	if p342.surface ~= nil then
		t453.surface = p342.surface:jsonEncode()
	end

	if p342.product_universe_id ~= nil then
		t453.productUniverseId = p342.product_universe_id:jsonEncode()
	end

	return t453
end
function t451.jsonDecode(t454: {[any]: any}) -- line: 22129
	-- upvalues: t451 (copy), prop_types (copy)
	local v3400 = t451.new()

	if t454.surface ~= nil then
		v3400.surface = prop_types.StringProp.jsonDecode(t454.surface)
	end

	if t454.product_universe_id ~= nil then
		v3400.product_universe_id = prop_types.StringProp.jsonDecode(t454.product_universe_id)
	end

	if t454.productUniverseId ~= nil then
		v3400.product_universe_id = prop_types.StringProp.jsonDecode(t454.productUniverseId)
	end

	return v3400
end

t451.descriptor = {
	name = "OpenPurchasePromptAction_PurchaseAnalyticsMetadata_PurchaseAnalyticsMetadataLiteral",
	fullName = "roblox.apppageplatform.shared.v1beta1.PurchaseAnalyticsMetadataLiteral"
}
t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata_PurchaseAnalyticsMetadataLiteral = t451
typeRegistry.default:register(t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata_PurchaseAnalyticsMetadataLiteral)

local t455 = {}

t455.__index = t455

function t455.new(t456: {[any]: any}?) -- line: 22170
	-- upvalues: t455 (copy)
	return (setmetatable({
		product_payload = if t456 ~= nil and t456.product_payload ~= nil then t456.product_payload else nil,
		display_info = if t456 ~= nil and t456.display_info ~= nil then t456.display_info else nil,
		purchase_options = if t456 ~= nil and t456.purchase_options ~= nil then t456.purchase_options else nil,
		purchase_analytics_metadata = if t456 ~= nil and t456.purchase_analytics_metadata ~= nil then t456.purchase_analytics_metadata else nil,
		root_place_id = if t456 ~= nil and t456.root_place_id ~= nil then t456.root_place_id else nil
	}, t455))
end
function t455.encode(p343) -- line: 22184
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n226 = 0

	if p343.product_payload ~= nil then
		local v3405 = p343.product_payload:encode()
		local v3406, v3407 = proto.writeTag(buf, n226, 1, proto.wireTypes.lengthDelimited)

		buf, n226 = proto.writeBuffer(v3406, v3407, v3405, buffer.len(v3405))
	end

	if p343.display_info ~= nil then
		local v3408 = p343.display_info:encode()
		local v3409, v3410 = proto.writeTag(buf, n226, 2, proto.wireTypes.lengthDelimited)

		buf, n226 = proto.writeBuffer(v3409, v3410, v3408, buffer.len(v3408))
	end

	if p343.purchase_options ~= nil then
		local v3411 = p343.purchase_options:encode()
		local v3412, v3413 = proto.writeTag(buf, n226, 3, proto.wireTypes.lengthDelimited)

		buf, n226 = proto.writeBuffer(v3412, v3413, v3411, buffer.len(v3411))
	end

	if p343.purchase_analytics_metadata ~= nil then
		local v3414 = p343.purchase_analytics_metadata:encode()
		local v3415, v3416 = proto.writeTag(buf, n226, 4, proto.wireTypes.lengthDelimited)

		buf, n226 = proto.writeBuffer(v3415, v3416, v3414, buffer.len(v3414))
	end

	if p343.root_place_id ~= nil then
		local v3417 = p343.root_place_id:encode()
		local v3418, v3419 = proto.writeTag(buf, n226, 5, proto.wireTypes.lengthDelimited)

		buf, n226 = proto.writeBuffer(v3418, v3419, v3417, buffer.len(v3417))
	end

	local buf116 = buffer.create(n226)

	buffer.copy(buf116, 0, buf, 0, n226)

	return buf116
end
function t455.decode(p344: buffer) -- line: 22223
	-- upvalues: t455 (copy), proto (copy), t1 (copy), prop_types (copy)
	local v3422 = t455.new()
	local n227 = 0

	while n227 < buffer.len(p344) do
		local v3424, v3425

		v3424, v3425, n227 = proto.readTag(p344, n227)

		if v3425 == proto.wireTypes.varint then
			local v3426

			v3426, n227 = proto.readVarInt(p344, n227)
		elseif v3425 == proto.wireTypes.lengthDelimited then
			if v3424 == 1 then
				local v3427

				v3427, n227 = proto.readBuffer(p344, n227)
				v3422.product_payload = t1.OpenPurchasePromptAction_ProductPayload.decode(v3427)
			elseif v3424 == 2 then
				local v3428

				v3428, n227 = proto.readBuffer(p344, n227)
				v3422.display_info = t1.OpenPurchasePromptAction_DisplayInfo.decode(v3428)
			elseif v3424 == 3 then
				local v3429

				v3429, n227 = proto.readBuffer(p344, n227)
				v3422.purchase_options = t1.OpenPurchasePromptAction_PurchaseOptions.decode(v3429)
			elseif v3424 == 4 then
				local v3430

				v3430, n227 = proto.readBuffer(p344, n227)
				v3422.purchase_analytics_metadata = t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata.decode(v3430)
			elseif v3424 == 5 then
				local v3431

				v3431, n227 = proto.readBuffer(p344, n227)
				v3422.root_place_id = prop_types.StringProp.decode(v3431)
			else
				local v3432, v3433 = proto.readVarInt(p344, n227)

				n227 = v3433 + v3432
			end
		elseif v3425 == proto.wireTypes.i32 then
			local v3434

			v3434, n227 = proto.readFixed32(p344, n227)
		elseif v3425 == proto.wireTypes.i64 then
			local v3435

			v3435, n227 = proto.readFixed64(p344, n227)
		else
			error("Unsupported wire type: " .. v3425)
		end
	end

	return v3422
end
function t455.jsonEncode(p345) -- line: 22287
	local t457 = {}

	if p345.product_payload ~= nil then
		t457.productPayload = p345.product_payload:jsonEncode()
	end

	if p345.display_info ~= nil then
		t457.displayInfo = p345.display_info:jsonEncode()
	end

	if p345.purchase_options ~= nil then
		t457.purchaseOptions = p345.purchase_options:jsonEncode()
	end

	if p345.purchase_analytics_metadata ~= nil then
		t457.purchaseAnalyticsMetadata = p345.purchase_analytics_metadata:jsonEncode()
	end

	if p345.root_place_id ~= nil then
		t457.rootPlaceId = p345.root_place_id:jsonEncode()
	end

	return t457
end
function t455.jsonDecode(t458: {[any]: any}) -- line: 22313
	-- upvalues: t455 (copy), t1 (copy), prop_types (copy)
	local v3439 = t455.new()

	if t458.product_payload ~= nil then
		v3439.product_payload = t1.OpenPurchasePromptAction_ProductPayload.jsonDecode(t458.product_payload)
	end

	if t458.productPayload ~= nil then
		v3439.product_payload = t1.OpenPurchasePromptAction_ProductPayload.jsonDecode(t458.productPayload)
	end

	if t458.display_info ~= nil then
		v3439.display_info = t1.OpenPurchasePromptAction_DisplayInfo.jsonDecode(t458.display_info)
	end

	if t458.displayInfo ~= nil then
		v3439.display_info = t1.OpenPurchasePromptAction_DisplayInfo.jsonDecode(t458.displayInfo)
	end

	if t458.purchase_options ~= nil then
		v3439.purchase_options = t1.OpenPurchasePromptAction_PurchaseOptions.jsonDecode(t458.purchase_options)
	end

	if t458.purchaseOptions ~= nil then
		v3439.purchase_options = t1.OpenPurchasePromptAction_PurchaseOptions.jsonDecode(t458.purchaseOptions)
	end

	if t458.purchase_analytics_metadata ~= nil then
		v3439.purchase_analytics_metadata = t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata.jsonDecode(t458.purchase_analytics_metadata)
	end

	if t458.purchaseAnalyticsMetadata ~= nil then
		v3439.purchase_analytics_metadata = t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata.jsonDecode(t458.purchaseAnalyticsMetadata)
	end

	if t458.root_place_id ~= nil then
		v3439.root_place_id = prop_types.StringProp.jsonDecode(t458.root_place_id)
	end

	if t458.rootPlaceId ~= nil then
		v3439.root_place_id = prop_types.StringProp.jsonDecode(t458.rootPlaceId)
	end

	return v3439
end

t455.descriptor = {
	name = "OpenPurchasePromptAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.OpenPurchasePromptAction_Params = t455
typeRegistry.default:register(t1.OpenPurchasePromptAction_Params)

local t459 = {}

t459.__index = t459

function t459.new(t460: {[any]: any}?) -- line: 22378
	-- upvalues: t1 (copy), t459 (copy)
	return (setmetatable({
		action_type = if t460 ~= nil and t460.action_type ~= nil then t460.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t460 ~= nil and t460.action_params ~= nil then t460.action_params else nil
	}, t459))
end
function t459.encode(p346) -- line: 22389
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n228 = 0

	if p346.action_type ~= nil and (p346.action_type ~= nil and p346.action_type ~= 0 or p346.action_type ~= t1.ActionType.fromNumber(0)) then
		local v3444, v3445 = proto.writeTag(buf, n228, 1, proto.wireTypes.varint)

		buf, n228 = proto.writeVarInt(v3444, v3445, t1.ActionType.toNumber(p346.action_type))
	end

	if p346.action_params ~= nil then
		local v3446 = p346.action_params:encode()
		local v3447, v3448 = proto.writeTag(buf, n228, 2, proto.wireTypes.lengthDelimited)

		buf, n228 = proto.writeBuffer(v3447, v3448, v3446, buffer.len(v3446))
	end

	local buf117 = buffer.create(n228)

	buffer.copy(buf117, 0, buf, 0, n228)

	return buf117
end
function t459.decode(p347: buffer) -- line: 22415
	-- upvalues: t459 (copy), proto (copy), t1 (copy)
	local v3451 = t459.new()
	local n229 = 0

	while n229 < buffer.len(p347) do
		local v3453, v3454

		v3453, v3454, n229 = proto.readTag(p347, n229)

		if v3454 == proto.wireTypes.varint then
			if v3453 == 1 then
				local v3455

				v3455, n229 = proto.readVarIntI32(p347, n229)
				v3451.action_type = t1.ActionType.fromNumber(v3455) or v3455
			else
				local v3456

				v3456, n229 = proto.readVarInt(p347, n229)
			end
		elseif v3454 == proto.wireTypes.lengthDelimited then
			if v3453 == 2 then
				local v3457

				v3457, n229 = proto.readBuffer(p347, n229)
				v3451.action_params = t1.ReportSurfaceLoadTimeMilestoneAction_Params.decode(v3457)
			else
				local v3458, v3459 = proto.readVarInt(p347, n229)

				n229 = v3459 + v3458
			end
		elseif v3454 == proto.wireTypes.i32 then
			local v3460

			v3460, n229 = proto.readFixed32(p347, n229)
		elseif v3454 == proto.wireTypes.i64 then
			local v3461

			v3461, n229 = proto.readFixed64(p347, n229)
		else
			error("Unsupported wire type: " .. v3454)
		end
	end

	return v3451
end
function t459.jsonEncode(p348) -- line: 22463
	-- upvalues: t1 (copy)
	local t461 = {}

	if p348.action_type ~= nil and (p348.action_type ~= nil and p348.action_type ~= 0 or p348.action_type ~= t1.ActionType.fromNumber(0)) then
		t461.actionType = if typeof(p348.action_type) ~= "number" then t1.ActionType.toNumber(p348.action_type) else p348.action_type
	end

	if p348.action_params ~= nil then
		t461.actionParams = p348.action_params:jsonEncode()
	end

	return t461
end
function t459.jsonDecode(t462: {[any]: any}) -- line: 22485
	-- upvalues: t459 (copy), t1 (copy)
	local v3465 = t459.new()

	if t462.action_type ~= nil then
		v3465.action_type = if typeof(t462.action_type) ~= "number" then t1.ActionType.fromName(t462.action_type) or t462.action_type else t1.ActionType.fromNumber(t462.action_type) or t462.action_type
	end

	if t462.actionType ~= nil then
		v3465.action_type = if typeof(t462.actionType) ~= "number" then t1.ActionType.fromName(t462.actionType) or t462.actionType else t1.ActionType.fromNumber(t462.actionType) or t462.actionType
	end

	if t462.action_params ~= nil then
		v3465.action_params = t1.ReportSurfaceLoadTimeMilestoneAction_Params.jsonDecode(t462.action_params)
	end

	if t462.actionParams ~= nil then
		v3465.action_params = t1.ReportSurfaceLoadTimeMilestoneAction_Params.jsonDecode(t462.actionParams)
	end

	return v3465
end

t459.descriptor = {
	name = "ReportSurfaceLoadTimeMilestoneAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.ReportSurfaceLoadTimeMilestoneAction"
}
t1.ReportSurfaceLoadTimeMilestoneAction = t459
typeRegistry.default:register(t1.ReportSurfaceLoadTimeMilestoneAction)

local t463 = {}

t463.__index = t463

function t463.new(t464: {[any]: any}?) -- line: 22527
	-- upvalues: t463 (copy)
	return (setmetatable({
		milestone = if t464 ~= nil and t464.milestone ~= nil then t464.milestone else nil,
		metadata = if t464 ~= nil and t464.metadata ~= nil then t464.metadata else nil
	}, t463))
end
function t463.encode(p349) -- line: 22536
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n230 = 0

	if p349.milestone ~= nil then
		local v3470 = p349.milestone:encode()
		local v3471, v3472 = proto.writeTag(buf, n230, 1, proto.wireTypes.lengthDelimited)

		buf, n230 = proto.writeBuffer(v3471, v3472, v3470, buffer.len(v3470))
	end

	if p349.metadata ~= nil then
		local v3473 = p349.metadata:encode()
		local v3474, v3475 = proto.writeTag(buf, n230, 3, proto.wireTypes.lengthDelimited)

		buf, n230 = proto.writeBuffer(v3474, v3475, v3473, buffer.len(v3473))
	end

	local buf118 = buffer.create(n230)

	buffer.copy(buf118, 0, buf, 0, n230)

	return buf118
end
function t463.decode(p350: buffer) -- line: 22559
	-- upvalues: t463 (copy), proto (copy), prop_types (copy)
	local v3478 = t463.new()
	local n231 = 0

	while n231 < buffer.len(p350) do
		local v3480, v3481

		v3480, v3481, n231 = proto.readTag(p350, n231)

		if v3481 == proto.wireTypes.varint then
			local v3482

			v3482, n231 = proto.readVarInt(p350, n231)
		elseif v3481 == proto.wireTypes.lengthDelimited then
			if v3480 == 1 then
				local v3483

				v3483, n231 = proto.readBuffer(p350, n231)
				v3478.milestone = prop_types.StringProp.decode(v3483)
			elseif v3480 == 3 then
				local v3484

				v3484, n231 = proto.readBuffer(p350, n231)
				v3478.metadata = prop_types.StructProp.decode(v3484)
			else
				local v3485, v3486 = proto.readVarInt(p350, n231)

				n231 = v3486 + v3485
			end
		elseif v3481 == proto.wireTypes.i32 then
			local v3487

			v3487, n231 = proto.readFixed32(p350, n231)
		elseif v3481 == proto.wireTypes.i64 then
			local v3488

			v3488, n231 = proto.readFixed64(p350, n231)
		else
			error("Unsupported wire type: " .. v3481)
		end
	end

	return v3478
end
function t463.jsonEncode(p351) -- line: 22609
	local t465 = {}

	if p351.milestone ~= nil then
		t465.milestone = p351.milestone:jsonEncode()
	end

	if p351.metadata ~= nil then
		t465.metadata = p351.metadata:jsonEncode()
	end

	return t465
end
function t463.jsonDecode(t466: {[any]: any}) -- line: 22625
	-- upvalues: t463 (copy), prop_types (copy)
	local v3492 = t463.new()

	if t466.milestone ~= nil then
		v3492.milestone = prop_types.StringProp.jsonDecode(t466.milestone)
	end

	if t466.metadata ~= nil then
		v3492.metadata = prop_types.StructProp.jsonDecode(t466.metadata)
	end

	return v3492
end

t463.descriptor = {
	name = "ReportSurfaceLoadTimeMilestoneAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.ReportSurfaceLoadTimeMilestoneAction_Params = t463
typeRegistry.default:register(t1.ReportSurfaceLoadTimeMilestoneAction_Params)

local t467 = {}

t467.__index = t467

function t467.new(t468: {[any]: any}?) -- line: 22655
	-- upvalues: t1 (copy), t467 (copy)
	return (setmetatable({
		action_type = if t468 ~= nil and t468.action_type ~= nil then t468.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t468 ~= nil and t468.action_params ~= nil then t468.action_params else nil
	}, t467))
end
function t467.encode(p352) -- line: 22666
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n232 = 0

	if p352.action_type ~= nil and (p352.action_type ~= nil and p352.action_type ~= 0 or p352.action_type ~= t1.ActionType.fromNumber(0)) then
		local v3497, v3498 = proto.writeTag(buf, n232, 1, proto.wireTypes.varint)

		buf, n232 = proto.writeVarInt(v3497, v3498, t1.ActionType.toNumber(p352.action_type))
	end

	if p352.action_params ~= nil then
		local v3499 = p352.action_params:encode()
		local v3500, v3501 = proto.writeTag(buf, n232, 2, proto.wireTypes.lengthDelimited)

		buf, n232 = proto.writeBuffer(v3500, v3501, v3499, buffer.len(v3499))
	end

	local buf119 = buffer.create(n232)

	buffer.copy(buf119, 0, buf, 0, n232)

	return buf119
end
function t467.decode(p353: buffer) -- line: 22692
	-- upvalues: t467 (copy), proto (copy), t1 (copy)
	local v3504 = t467.new()
	local n233 = 0

	while n233 < buffer.len(p353) do
		local v3506, v3507

		v3506, v3507, n233 = proto.readTag(p353, n233)

		if v3507 == proto.wireTypes.varint then
			if v3506 == 1 then
				local v3508

				v3508, n233 = proto.readVarIntI32(p353, n233)
				v3504.action_type = t1.ActionType.fromNumber(v3508) or v3508
			else
				local v3509

				v3509, n233 = proto.readVarInt(p353, n233)
			end
		elseif v3507 == proto.wireTypes.lengthDelimited then
			if v3506 == 2 then
				local v3510

				v3510, n233 = proto.readBuffer(p353, n233)
				v3504.action_params = t1.DismissGameFeedbackAction_Params.decode(v3510)
			else
				local v3511, v3512 = proto.readVarInt(p353, n233)

				n233 = v3512 + v3511
			end
		elseif v3507 == proto.wireTypes.i32 then
			local v3513

			v3513, n233 = proto.readFixed32(p353, n233)
		elseif v3507 == proto.wireTypes.i64 then
			local v3514

			v3514, n233 = proto.readFixed64(p353, n233)
		else
			error("Unsupported wire type: " .. v3507)
		end
	end

	return v3504
end
function t467.jsonEncode(p354) -- line: 22740
	-- upvalues: t1 (copy)
	local t469 = {}

	if p354.action_type ~= nil and (p354.action_type ~= nil and p354.action_type ~= 0 or p354.action_type ~= t1.ActionType.fromNumber(0)) then
		t469.actionType = if typeof(p354.action_type) ~= "number" then t1.ActionType.toNumber(p354.action_type) else p354.action_type
	end

	if p354.action_params ~= nil then
		t469.actionParams = p354.action_params:jsonEncode()
	end

	return t469
end
function t467.jsonDecode(t470: {[any]: any}) -- line: 22762
	-- upvalues: t467 (copy), t1 (copy)
	local v3518 = t467.new()

	if t470.action_type ~= nil then
		v3518.action_type = if typeof(t470.action_type) ~= "number" then t1.ActionType.fromName(t470.action_type) or t470.action_type else t1.ActionType.fromNumber(t470.action_type) or t470.action_type
	end

	if t470.actionType ~= nil then
		v3518.action_type = if typeof(t470.actionType) ~= "number" then t1.ActionType.fromName(t470.actionType) or t470.actionType else t1.ActionType.fromNumber(t470.actionType) or t470.actionType
	end

	if t470.action_params ~= nil then
		v3518.action_params = t1.DismissGameFeedbackAction_Params.jsonDecode(t470.action_params)
	end

	if t470.actionParams ~= nil then
		v3518.action_params = t1.DismissGameFeedbackAction_Params.jsonDecode(t470.actionParams)
	end

	return v3518
end

t467.descriptor = {
	name = "DismissGameFeedbackAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.DismissGameFeedbackAction"
}
t1.DismissGameFeedbackAction = t467
typeRegistry.default:register(t1.DismissGameFeedbackAction)

local t471 = {}

t471.__index = t471

function t471.new(t472: {[any]: any}?) -- line: 22802
	-- upvalues: t471 (copy)
	return (setmetatable({
		root_place_id = if t472 ~= nil and t472.root_place_id ~= nil then t472.root_place_id else nil
	}, t471))
end
function t471.encode(p355) -- line: 22810
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n234 = 0

	if p355.root_place_id ~= nil then
		local v3523 = p355.root_place_id:encode()
		local v3524, v3525 = proto.writeTag(buf, n234, 1, proto.wireTypes.lengthDelimited)

		buf, n234 = proto.writeBuffer(v3524, v3525, v3523, buffer.len(v3523))
	end

	local buf120 = buffer.create(n234)

	buffer.copy(buf120, 0, buf, 0, n234)

	return buf120
end
function t471.decode(p356: buffer) -- line: 22825
	-- upvalues: t471 (copy), proto (copy), prop_types (copy)
	local v3528 = t471.new()
	local n235 = 0

	while n235 < buffer.len(p356) do
		local v3530, v3531

		v3530, v3531, n235 = proto.readTag(p356, n235)

		if v3531 == proto.wireTypes.varint then
			local v3532

			v3532, n235 = proto.readVarInt(p356, n235)
		elseif v3531 == proto.wireTypes.lengthDelimited then
			if v3530 == 1 then
				local v3533

				v3533, n235 = proto.readBuffer(p356, n235)
				v3528.root_place_id = prop_types.StringProp.decode(v3533)
			else
				local v3534, v3535 = proto.readVarInt(p356, n235)

				n235 = v3535 + v3534
			end
		elseif v3531 == proto.wireTypes.i32 then
			local v3536

			v3536, n235 = proto.readFixed32(p356, n235)
		elseif v3531 == proto.wireTypes.i64 then
			local v3537

			v3537, n235 = proto.readFixed64(p356, n235)
		else
			error("Unsupported wire type: " .. v3531)
		end
	end

	return v3528
end
function t471.jsonEncode(p357) -- line: 22868
	local t473 = {}

	if p357.root_place_id ~= nil then
		t473.rootPlaceId = p357.root_place_id:jsonEncode()
	end

	return t473
end
function t471.jsonDecode(t474: {[any]: any}) -- line: 22878
	-- upvalues: t471 (copy), prop_types (copy)
	local v3541 = t471.new()

	if t474.root_place_id ~= nil then
		v3541.root_place_id = prop_types.StringProp.jsonDecode(t474.root_place_id)
	end

	if t474.rootPlaceId ~= nil then
		v3541.root_place_id = prop_types.StringProp.jsonDecode(t474.rootPlaceId)
	end

	return v3541
end

t471.descriptor = {
	name = "DismissGameFeedbackAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.DismissGameFeedbackAction_Params = t471
typeRegistry.default:register(t1.DismissGameFeedbackAction_Params)

local t475 = {}

t475.__index = t475

function t475.new(t476: {[any]: any}?) -- line: 22910
	-- upvalues: t1 (copy), t475 (copy)
	return (setmetatable({
		action_type = if t476 ~= nil and t476.action_type ~= nil then t476.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t476 ~= nil and t476.action_params ~= nil then t476.action_params else nil
	}, t475))
end
function t475.encode(p358) -- line: 22921
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n236 = 0

	if p358.action_type ~= nil and (p358.action_type ~= nil and p358.action_type ~= 0 or p358.action_type ~= t1.ActionType.fromNumber(0)) then
		local v3546, v3547 = proto.writeTag(buf, n236, 1, proto.wireTypes.varint)

		buf, n236 = proto.writeVarInt(v3546, v3547, t1.ActionType.toNumber(p358.action_type))
	end

	if p358.action_params ~= nil then
		local v3548 = p358.action_params:encode()
		local v3549, v3550 = proto.writeTag(buf, n236, 2, proto.wireTypes.lengthDelimited)

		buf, n236 = proto.writeBuffer(v3549, v3550, v3548, buffer.len(v3548))
	end

	local buf121 = buffer.create(n236)

	buffer.copy(buf121, 0, buf, 0, n236)

	return buf121
end
function t475.decode(p359: buffer) -- line: 22947
	-- upvalues: t475 (copy), proto (copy), t1 (copy)
	local v3553 = t475.new()
	local n237 = 0

	while n237 < buffer.len(p359) do
		local v3555, v3556

		v3555, v3556, n237 = proto.readTag(p359, n237)

		if v3556 == proto.wireTypes.varint then
			if v3555 == 1 then
				local v3557

				v3557, n237 = proto.readVarIntI32(p359, n237)
				v3553.action_type = t1.ActionType.fromNumber(v3557) or v3557
			else
				local v3558

				v3558, n237 = proto.readVarInt(p359, n237)
			end
		elseif v3556 == proto.wireTypes.lengthDelimited then
			if v3555 == 2 then
				local v3559

				v3559, n237 = proto.readBuffer(p359, n237)
				v3553.action_params = t1.OpenGameFeedbackFormAction_Params.decode(v3559)
			else
				local v3560, v3561 = proto.readVarInt(p359, n237)

				n237 = v3561 + v3560
			end
		elseif v3556 == proto.wireTypes.i32 then
			local v3562

			v3562, n237 = proto.readFixed32(p359, n237)
		elseif v3556 == proto.wireTypes.i64 then
			local v3563

			v3563, n237 = proto.readFixed64(p359, n237)
		else
			error("Unsupported wire type: " .. v3556)
		end
	end

	return v3553
end
function t475.jsonEncode(p360) -- line: 22995
	-- upvalues: t1 (copy)
	local t477 = {}

	if p360.action_type ~= nil and (p360.action_type ~= nil and p360.action_type ~= 0 or p360.action_type ~= t1.ActionType.fromNumber(0)) then
		t477.actionType = if typeof(p360.action_type) ~= "number" then t1.ActionType.toNumber(p360.action_type) else p360.action_type
	end

	if p360.action_params ~= nil then
		t477.actionParams = p360.action_params:jsonEncode()
	end

	return t477
end
function t475.jsonDecode(t478: {[any]: any}) -- line: 23017
	-- upvalues: t475 (copy), t1 (copy)
	local v3567 = t475.new()

	if t478.action_type ~= nil then
		v3567.action_type = if typeof(t478.action_type) ~= "number" then t1.ActionType.fromName(t478.action_type) or t478.action_type else t1.ActionType.fromNumber(t478.action_type) or t478.action_type
	end

	if t478.actionType ~= nil then
		v3567.action_type = if typeof(t478.actionType) ~= "number" then t1.ActionType.fromName(t478.actionType) or t478.actionType else t1.ActionType.fromNumber(t478.actionType) or t478.actionType
	end

	if t478.action_params ~= nil then
		v3567.action_params = t1.OpenGameFeedbackFormAction_Params.jsonDecode(t478.action_params)
	end

	if t478.actionParams ~= nil then
		v3567.action_params = t1.OpenGameFeedbackFormAction_Params.jsonDecode(t478.actionParams)
	end

	return v3567
end

t475.descriptor = {
	name = "OpenGameFeedbackFormAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.OpenGameFeedbackFormAction"
}
t1.OpenGameFeedbackFormAction = t475
typeRegistry.default:register(t1.OpenGameFeedbackFormAction)

local t479 = {}

t479.__index = t479

function t479.new(t480: {[any]: any}?) -- line: 23057
	-- upvalues: t479 (copy)
	return (setmetatable({
		universe_id = if t480 ~= nil and t480.universe_id ~= nil then t480.universe_id else nil,
		root_place_id = if t480 ~= nil and t480.root_place_id ~= nil then t480.root_place_id else nil
	}, t479))
end
function t479.encode(p361) -- line: 23066
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n238 = 0

	if p361.universe_id ~= nil then
		local v3572 = p361.universe_id:encode()
		local v3573, v3574 = proto.writeTag(buf, n238, 1, proto.wireTypes.lengthDelimited)

		buf, n238 = proto.writeBuffer(v3573, v3574, v3572, buffer.len(v3572))
	end

	if p361.root_place_id ~= nil then
		local v3575 = p361.root_place_id:encode()
		local v3576, v3577 = proto.writeTag(buf, n238, 2, proto.wireTypes.lengthDelimited)

		buf, n238 = proto.writeBuffer(v3576, v3577, v3575, buffer.len(v3575))
	end

	local buf122 = buffer.create(n238)

	buffer.copy(buf122, 0, buf, 0, n238)

	return buf122
end
function t479.decode(p362: buffer) -- line: 23087
	-- upvalues: t479 (copy), proto (copy), prop_types (copy)
	local v3580 = t479.new()
	local n239 = 0

	while n239 < buffer.len(p362) do
		local v3582, v3583

		v3582, v3583, n239 = proto.readTag(p362, n239)

		if v3583 == proto.wireTypes.varint then
			local v3584

			v3584, n239 = proto.readVarInt(p362, n239)
		elseif v3583 == proto.wireTypes.lengthDelimited then
			if v3582 == 1 then
				local v3585

				v3585, n239 = proto.readBuffer(p362, n239)
				v3580.universe_id = prop_types.StringProp.decode(v3585)
			elseif v3582 == 2 then
				local v3586

				v3586, n239 = proto.readBuffer(p362, n239)
				v3580.root_place_id = prop_types.StringProp.decode(v3586)
			else
				local v3587, v3588 = proto.readVarInt(p362, n239)

				n239 = v3588 + v3587
			end
		elseif v3583 == proto.wireTypes.i32 then
			local v3589

			v3589, n239 = proto.readFixed32(p362, n239)
		elseif v3583 == proto.wireTypes.i64 then
			local v3590

			v3590, n239 = proto.readFixed64(p362, n239)
		else
			error("Unsupported wire type: " .. v3583)
		end
	end

	return v3580
end
function t479.jsonEncode(p363) -- line: 23135
	local t481 = {}

	if p363.universe_id ~= nil then
		t481.universeId = p363.universe_id:jsonEncode()
	end

	if p363.root_place_id ~= nil then
		t481.rootPlaceId = p363.root_place_id:jsonEncode()
	end

	return t481
end
function t479.jsonDecode(t482: {[any]: any}) -- line: 23149
	-- upvalues: t479 (copy), prop_types (copy)
	local v3594 = t479.new()

	if t482.universe_id ~= nil then
		v3594.universe_id = prop_types.StringProp.jsonDecode(t482.universe_id)
	end

	if t482.universeId ~= nil then
		v3594.universe_id = prop_types.StringProp.jsonDecode(t482.universeId)
	end

	if t482.root_place_id ~= nil then
		v3594.root_place_id = prop_types.StringProp.jsonDecode(t482.root_place_id)
	end

	if t482.rootPlaceId ~= nil then
		v3594.root_place_id = prop_types.StringProp.jsonDecode(t482.rootPlaceId)
	end

	return v3594
end

t479.descriptor = {
	name = "OpenGameFeedbackFormAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.OpenGameFeedbackFormAction_Params = t479
typeRegistry.default:register(t1.OpenGameFeedbackFormAction_Params)

local t483 = {}

t483.__index = t483

function t483.new(t484: {[any]: any}?) -- line: 23190
	-- upvalues: t1 (copy), t483 (copy)
	return (setmetatable({
		action_type = if t484 ~= nil and t484.action_type ~= nil then t484.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t484 ~= nil and t484.action_params ~= nil then t484.action_params else nil
	}, t483))
end
function t483.encode(p364) -- line: 23199
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n240 = 0

	if p364.action_type ~= nil and (p364.action_type ~= nil and p364.action_type ~= 0 or p364.action_type ~= t1.ActionType.fromNumber(0)) then
		local v3599, v3600 = proto.writeTag(buf, n240, 1, proto.wireTypes.varint)

		buf, n240 = proto.writeVarInt(v3599, v3600, t1.ActionType.toNumber(p364.action_type))
	end

	if p364.action_params ~= nil then
		local v3601 = p364.action_params:encode()
		local v3602, v3603 = proto.writeTag(buf, n240, 2, proto.wireTypes.lengthDelimited)

		buf, n240 = proto.writeBuffer(v3602, v3603, v3601, buffer.len(v3601))
	end

	local buf123 = buffer.create(n240)

	buffer.copy(buf123, 0, buf, 0, n240)

	return buf123
end
function t483.decode(p365: buffer) -- line: 23225
	-- upvalues: t483 (copy), proto (copy), t1 (copy)
	local v3606 = t483.new()
	local n241 = 0

	while n241 < buffer.len(p365) do
		local v3608, v3609

		v3608, v3609, n241 = proto.readTag(p365, n241)

		if v3609 == proto.wireTypes.varint then
			if v3608 == 1 then
				local v3610

				v3610, n241 = proto.readVarIntI32(p365, n241)
				v3606.action_type = t1.ActionType.fromNumber(v3610) or v3610
			else
				local v3611

				v3611, n241 = proto.readVarInt(p365, n241)
			end
		elseif v3609 == proto.wireTypes.lengthDelimited then
			if v3608 == 2 then
				local v3612

				v3612, n241 = proto.readBuffer(p365, n241)
				v3606.action_params = t1.AiOverviewFeedbackAction_Params.decode(v3612)
			else
				local v3613, v3614 = proto.readVarInt(p365, n241)

				n241 = v3614 + v3613
			end
		elseif v3609 == proto.wireTypes.i32 then
			local v3615

			v3615, n241 = proto.readFixed32(p365, n241)
		elseif v3609 == proto.wireTypes.i64 then
			local v3616

			v3616, n241 = proto.readFixed64(p365, n241)
		else
			error("Unsupported wire type: " .. v3609)
		end
	end

	return v3606
end
function t483.jsonEncode(p366) -- line: 23273
	-- upvalues: t1 (copy)
	local t485 = {}

	if p366.action_type ~= nil and (p366.action_type ~= nil and p366.action_type ~= 0 or p366.action_type ~= t1.ActionType.fromNumber(0)) then
		t485.actionType = if typeof(p366.action_type) ~= "number" then t1.ActionType.toNumber(p366.action_type) else p366.action_type
	end

	if p366.action_params ~= nil then
		t485.actionParams = p366.action_params:jsonEncode()
	end

	return t485
end
function t483.jsonDecode(t486: {[any]: any}) -- line: 23295
	-- upvalues: t483 (copy), t1 (copy)
	local v3620 = t483.new()

	if t486.action_type ~= nil then
		v3620.action_type = if typeof(t486.action_type) ~= "number" then t1.ActionType.fromName(t486.action_type) or t486.action_type else t1.ActionType.fromNumber(t486.action_type) or t486.action_type
	end

	if t486.actionType ~= nil then
		v3620.action_type = if typeof(t486.actionType) ~= "number" then t1.ActionType.fromName(t486.actionType) or t486.actionType else t1.ActionType.fromNumber(t486.actionType) or t486.actionType
	end

	if t486.action_params ~= nil then
		v3620.action_params = t1.AiOverviewFeedbackAction_Params.jsonDecode(t486.action_params)
	end

	if t486.actionParams ~= nil then
		v3620.action_params = t1.AiOverviewFeedbackAction_Params.jsonDecode(t486.actionParams)
	end

	return v3620
end

t483.descriptor = {
	name = "AiOverviewFeedbackAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.AiOverviewFeedbackAction"
}
t1.AiOverviewFeedbackAction = t483
typeRegistry.default:register(t1.AiOverviewFeedbackAction)

local t487 = {}

t487.__index = t487

function t487.new(t488: {[any]: any}?) -- line: 23335
	-- upvalues: t487 (copy)
	return (setmetatable({
		sentiment = if t488 ~= nil and t488.sentiment ~= nil then t488.sentiment else nil,
		dialog_title = if t488 ~= nil and t488.dialog_title ~= nil then t488.dialog_title else nil,
		dialog_text = if t488 ~= nil and t488.dialog_text ~= nil then t488.dialog_text else nil,
		placeholder_text = if t488 ~= nil and t488.placeholder_text ~= nil then t488.placeholder_text else nil
	}, t487))
end
function t487.encode(p367) -- line: 23346
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n242 = 0

	if p367.sentiment ~= nil then
		local v3625 = p367.sentiment:encode()
		local v3626, v3627 = proto.writeTag(buf, n242, 1, proto.wireTypes.lengthDelimited)

		buf, n242 = proto.writeBuffer(v3626, v3627, v3625, buffer.len(v3625))
	end

	if p367.dialog_title ~= nil then
		local v3628 = p367.dialog_title:encode()
		local v3629, v3630 = proto.writeTag(buf, n242, 2, proto.wireTypes.lengthDelimited)

		buf, n242 = proto.writeBuffer(v3629, v3630, v3628, buffer.len(v3628))
	end

	if p367.dialog_text ~= nil then
		local v3631 = p367.dialog_text:encode()
		local v3632, v3633 = proto.writeTag(buf, n242, 3, proto.wireTypes.lengthDelimited)

		buf, n242 = proto.writeBuffer(v3632, v3633, v3631, buffer.len(v3631))
	end

	if p367.placeholder_text ~= nil then
		local v3634 = p367.placeholder_text:encode()
		local v3635, v3636 = proto.writeTag(buf, n242, 4, proto.wireTypes.lengthDelimited)

		buf, n242 = proto.writeBuffer(v3635, v3636, v3634, buffer.len(v3634))
	end

	local buf124 = buffer.create(n242)

	buffer.copy(buf124, 0, buf, 0, n242)

	return buf124
end
function t487.decode(p368: buffer) -- line: 23379
	-- upvalues: t487 (copy), proto (copy), prop_types (copy)
	local v3639 = t487.new()
	local n243 = 0

	while n243 < buffer.len(p368) do
		local v3641, v3642

		v3641, v3642, n243 = proto.readTag(p368, n243)

		if v3642 == proto.wireTypes.varint then
			local v3643

			v3643, n243 = proto.readVarInt(p368, n243)
		elseif v3642 == proto.wireTypes.lengthDelimited then
			if v3641 == 1 then
				local v3644

				v3644, n243 = proto.readBuffer(p368, n243)
				v3639.sentiment = prop_types.StringProp.decode(v3644)
			elseif v3641 == 2 then
				local v3645

				v3645, n243 = proto.readBuffer(p368, n243)
				v3639.dialog_title = prop_types.StringProp.decode(v3645)
			elseif v3641 == 3 then
				local v3646

				v3646, n243 = proto.readBuffer(p368, n243)
				v3639.dialog_text = prop_types.StringProp.decode(v3646)
			elseif v3641 == 4 then
				local v3647

				v3647, n243 = proto.readBuffer(p368, n243)
				v3639.placeholder_text = prop_types.StringProp.decode(v3647)
			else
				local v3648, v3649 = proto.readVarInt(p368, n243)

				n243 = v3649 + v3648
			end
		elseif v3642 == proto.wireTypes.i32 then
			local v3650

			v3650, n243 = proto.readFixed32(p368, n243)
		elseif v3642 == proto.wireTypes.i64 then
			local v3651

			v3651, n243 = proto.readFixed64(p368, n243)
		else
			error("Unsupported wire type: " .. v3642)
		end
	end

	return v3639
end
function t487.jsonEncode(p369) -- line: 23437
	local t489 = {}

	if p369.sentiment ~= nil then
		t489.sentiment = p369.sentiment:jsonEncode()
	end

	if p369.dialog_title ~= nil then
		t489.dialogTitle = p369.dialog_title:jsonEncode()
	end

	if p369.dialog_text ~= nil then
		t489.dialogText = p369.dialog_text:jsonEncode()
	end

	if p369.placeholder_text ~= nil then
		t489.placeholderText = p369.placeholder_text:jsonEncode()
	end

	return t489
end
function t487.jsonDecode(t490: {[any]: any}) -- line: 23459
	-- upvalues: t487 (copy), prop_types (copy)
	local v3655 = t487.new()

	if t490.sentiment ~= nil then
		v3655.sentiment = prop_types.StringProp.jsonDecode(t490.sentiment)
	end

	if t490.dialog_title ~= nil then
		v3655.dialog_title = prop_types.StringProp.jsonDecode(t490.dialog_title)
	end

	if t490.dialogTitle ~= nil then
		v3655.dialog_title = prop_types.StringProp.jsonDecode(t490.dialogTitle)
	end

	if t490.dialog_text ~= nil then
		v3655.dialog_text = prop_types.StringProp.jsonDecode(t490.dialog_text)
	end

	if t490.dialogText ~= nil then
		v3655.dialog_text = prop_types.StringProp.jsonDecode(t490.dialogText)
	end

	if t490.placeholder_text ~= nil then
		v3655.placeholder_text = prop_types.StringProp.jsonDecode(t490.placeholder_text)
	end

	if t490.placeholderText ~= nil then
		v3655.placeholder_text = prop_types.StringProp.jsonDecode(t490.placeholderText)
	end

	return v3655
end

t487.descriptor = {
	name = "AiOverviewFeedbackAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.AiOverviewFeedbackAction_Params = t487
typeRegistry.default:register(t1.AiOverviewFeedbackAction_Params)

local t491 = {}

t491.__index = t491

function t491.new(t492: {[any]: any}?) -- line: 23512
	-- upvalues: t1 (copy), t491 (copy)
	return (setmetatable({
		action_type = if t492 ~= nil and t492.action_type ~= nil then t492.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t492 ~= nil and t492.action_params ~= nil then t492.action_params else nil
	}, t491))
end
function t491.encode(p370) -- line: 23523
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n244 = 0

	if p370.action_type ~= nil and (p370.action_type ~= nil and p370.action_type ~= 0 or p370.action_type ~= t1.ActionType.fromNumber(0)) then
		local v3660, v3661 = proto.writeTag(buf, n244, 1, proto.wireTypes.varint)

		buf, n244 = proto.writeVarInt(v3660, v3661, t1.ActionType.toNumber(p370.action_type))
	end

	if p370.action_params ~= nil then
		local v3662 = p370.action_params:encode()
		local v3663, v3664 = proto.writeTag(buf, n244, 2, proto.wireTypes.lengthDelimited)

		buf, n244 = proto.writeBuffer(v3663, v3664, v3662, buffer.len(v3662))
	end

	local buf125 = buffer.create(n244)

	buffer.copy(buf125, 0, buf, 0, n244)

	return buf125
end
function t491.decode(p371: buffer) -- line: 23549
	-- upvalues: t491 (copy), proto (copy), t1 (copy)
	local v3667 = t491.new()
	local n245 = 0

	while n245 < buffer.len(p371) do
		local v3669, v3670

		v3669, v3670, n245 = proto.readTag(p371, n245)

		if v3670 == proto.wireTypes.varint then
			if v3669 == 1 then
				local v3671

				v3671, n245 = proto.readVarIntI32(p371, n245)
				v3667.action_type = t1.ActionType.fromNumber(v3671) or v3671
			else
				local v3672

				v3672, n245 = proto.readVarInt(p371, n245)
			end
		elseif v3670 == proto.wireTypes.lengthDelimited then
			if v3669 == 2 then
				local v3673

				v3673, n245 = proto.readBuffer(p371, n245)
				v3667.action_params = t1.EnableEventNotificationsAction_Params.decode(v3673)
			else
				local v3674, v3675 = proto.readVarInt(p371, n245)

				n245 = v3675 + v3674
			end
		elseif v3670 == proto.wireTypes.i32 then
			local v3676

			v3676, n245 = proto.readFixed32(p371, n245)
		elseif v3670 == proto.wireTypes.i64 then
			local v3677

			v3677, n245 = proto.readFixed64(p371, n245)
		else
			error("Unsupported wire type: " .. v3670)
		end
	end

	return v3667
end
function t491.jsonEncode(p372) -- line: 23597
	-- upvalues: t1 (copy)
	local t493 = {}

	if p372.action_type ~= nil and (p372.action_type ~= nil and p372.action_type ~= 0 or p372.action_type ~= t1.ActionType.fromNumber(0)) then
		t493.actionType = if typeof(p372.action_type) ~= "number" then t1.ActionType.toNumber(p372.action_type) else p372.action_type
	end

	if p372.action_params ~= nil then
		t493.actionParams = p372.action_params:jsonEncode()
	end

	return t493
end
function t491.jsonDecode(t494: {[any]: any}) -- line: 23619
	-- upvalues: t491 (copy), t1 (copy)
	local v3681 = t491.new()

	if t494.action_type ~= nil then
		v3681.action_type = if typeof(t494.action_type) ~= "number" then t1.ActionType.fromName(t494.action_type) or t494.action_type else t1.ActionType.fromNumber(t494.action_type) or t494.action_type
	end

	if t494.actionType ~= nil then
		v3681.action_type = if typeof(t494.actionType) ~= "number" then t1.ActionType.fromName(t494.actionType) or t494.actionType else t1.ActionType.fromNumber(t494.actionType) or t494.actionType
	end

	if t494.action_params ~= nil then
		v3681.action_params = t1.EnableEventNotificationsAction_Params.jsonDecode(t494.action_params)
	end

	if t494.actionParams ~= nil then
		v3681.action_params = t1.EnableEventNotificationsAction_Params.jsonDecode(t494.actionParams)
	end

	return v3681
end

t491.descriptor = {
	name = "EnableEventNotificationsAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.EnableEventNotificationsAction"
}
t1.EnableEventNotificationsAction = t491
typeRegistry.default:register(t1.EnableEventNotificationsAction)

local t495 = {}

t495.__index = t495

function t495.new(t496: {[any]: any}?) -- line: 23659
	-- upvalues: t495 (copy)
	return (setmetatable({
		event_id = if t496 ~= nil and t496.event_id ~= nil then t496.event_id else nil,
		universe_id = if t496 ~= nil and t496.universe_id ~= nil then t496.universe_id else nil,
		channel = if t496 ~= nil and t496.channel ~= nil then t496.channel else nil
	}, t495))
end
function t495.encode(p373) -- line: 23669
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n246 = 0

	if p373.event_id ~= nil then
		local v3686 = p373.event_id:encode()
		local v3687, v3688 = proto.writeTag(buf, n246, 1, proto.wireTypes.lengthDelimited)

		buf, n246 = proto.writeBuffer(v3687, v3688, v3686, buffer.len(v3686))
	end

	if p373.universe_id ~= nil then
		local v3689 = p373.universe_id:encode()
		local v3690, v3691 = proto.writeTag(buf, n246, 2, proto.wireTypes.lengthDelimited)

		buf, n246 = proto.writeBuffer(v3690, v3691, v3689, buffer.len(v3689))
	end

	if p373.channel ~= nil then
		local v3692 = p373.channel:encode()
		local v3693, v3694 = proto.writeTag(buf, n246, 3, proto.wireTypes.lengthDelimited)

		buf, n246 = proto.writeBuffer(v3693, v3694, v3692, buffer.len(v3692))
	end

	local buf126 = buffer.create(n246)

	buffer.copy(buf126, 0, buf, 0, n246)

	return buf126
end
function t495.decode(p374: buffer) -- line: 23696
	-- upvalues: t495 (copy), proto (copy), prop_types (copy)
	local v3697 = t495.new()
	local n247 = 0

	while n247 < buffer.len(p374) do
		local v3699, v3700

		v3699, v3700, n247 = proto.readTag(p374, n247)

		if v3700 == proto.wireTypes.varint then
			local v3701

			v3701, n247 = proto.readVarInt(p374, n247)
		elseif v3700 == proto.wireTypes.lengthDelimited then
			if v3699 == 1 then
				local v3702

				v3702, n247 = proto.readBuffer(p374, n247)
				v3697.event_id = prop_types.StringProp.decode(v3702)
			elseif v3699 == 2 then
				local v3703

				v3703, n247 = proto.readBuffer(p374, n247)
				v3697.universe_id = prop_types.StringProp.decode(v3703)
			elseif v3699 == 3 then
				local v3704

				v3704, n247 = proto.readBuffer(p374, n247)
				v3697.channel = prop_types.StringProp.decode(v3704)
			else
				local v3705, v3706 = proto.readVarInt(p374, n247)

				n247 = v3706 + v3705
			end
		elseif v3700 == proto.wireTypes.i32 then
			local v3707

			v3707, n247 = proto.readFixed32(p374, n247)
		elseif v3700 == proto.wireTypes.i64 then
			local v3708

			v3708, n247 = proto.readFixed64(p374, n247)
		else
			error("Unsupported wire type: " .. v3700)
		end
	end

	return v3697
end
function t495.jsonEncode(p375) -- line: 23749
	local t497 = {}

	if p375.event_id ~= nil then
		t497.eventId = p375.event_id:jsonEncode()
	end

	if p375.universe_id ~= nil then
		t497.universeId = p375.universe_id:jsonEncode()
	end

	if p375.channel ~= nil then
		t497.channel = p375.channel:jsonEncode()
	end

	return t497
end
function t495.jsonDecode(t498: {[any]: any}) -- line: 23767
	-- upvalues: t495 (copy), prop_types (copy)
	local v3712 = t495.new()

	if t498.event_id ~= nil then
		v3712.event_id = prop_types.StringProp.jsonDecode(t498.event_id)
	end

	if t498.eventId ~= nil then
		v3712.event_id = prop_types.StringProp.jsonDecode(t498.eventId)
	end

	if t498.universe_id ~= nil then
		v3712.universe_id = prop_types.StringProp.jsonDecode(t498.universe_id)
	end

	if t498.universeId ~= nil then
		v3712.universe_id = prop_types.StringProp.jsonDecode(t498.universeId)
	end

	if t498.channel ~= nil then
		v3712.channel = prop_types.StringProp.jsonDecode(t498.channel)
	end

	return v3712
end

t495.descriptor = {
	name = "EnableEventNotificationsAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.EnableEventNotificationsAction_Params = t495
typeRegistry.default:register(t1.EnableEventNotificationsAction_Params)

local t499 = {}

t499.__index = t499

function t499.new(t500: {[any]: any}?) -- line: 23810
	-- upvalues: t1 (copy), t499 (copy)
	return (setmetatable({
		action_type = if t500 ~= nil and t500.action_type ~= nil then t500.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t500 ~= nil and t500.action_params ~= nil then t500.action_params else nil
	}, t499))
end
function t499.encode(p376) -- line: 23821
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n248 = 0

	if p376.action_type ~= nil and (p376.action_type ~= nil and p376.action_type ~= 0 or p376.action_type ~= t1.ActionType.fromNumber(0)) then
		local v3717, v3718 = proto.writeTag(buf, n248, 1, proto.wireTypes.varint)

		buf, n248 = proto.writeVarInt(v3717, v3718, t1.ActionType.toNumber(p376.action_type))
	end

	if p376.action_params ~= nil then
		local v3719 = p376.action_params:encode()
		local v3720, v3721 = proto.writeTag(buf, n248, 2, proto.wireTypes.lengthDelimited)

		buf, n248 = proto.writeBuffer(v3720, v3721, v3719, buffer.len(v3719))
	end

	local buf127 = buffer.create(n248)

	buffer.copy(buf127, 0, buf, 0, n248)

	return buf127
end
function t499.decode(p377: buffer) -- line: 23847
	-- upvalues: t499 (copy), proto (copy), t1 (copy)
	local v3724 = t499.new()
	local n249 = 0

	while n249 < buffer.len(p377) do
		local v3726, v3727

		v3726, v3727, n249 = proto.readTag(p377, n249)

		if v3727 == proto.wireTypes.varint then
			if v3726 == 1 then
				local v3728

				v3728, n249 = proto.readVarIntI32(p377, n249)
				v3724.action_type = t1.ActionType.fromNumber(v3728) or v3728
			else
				local v3729

				v3729, n249 = proto.readVarInt(p377, n249)
			end
		elseif v3727 == proto.wireTypes.lengthDelimited then
			if v3726 == 2 then
				local v3730

				v3730, n249 = proto.readBuffer(p377, n249)
				v3724.action_params = t1.DismissEventNotificationsModalAction_Params.decode(v3730)
			else
				local v3731, v3732 = proto.readVarInt(p377, n249)

				n249 = v3732 + v3731
			end
		elseif v3727 == proto.wireTypes.i32 then
			local v3733

			v3733, n249 = proto.readFixed32(p377, n249)
		elseif v3727 == proto.wireTypes.i64 then
			local v3734

			v3734, n249 = proto.readFixed64(p377, n249)
		else
			error("Unsupported wire type: " .. v3727)
		end
	end

	return v3724
end
function t499.jsonEncode(p378) -- line: 23895
	-- upvalues: t1 (copy)
	local t501 = {}

	if p378.action_type ~= nil and (p378.action_type ~= nil and p378.action_type ~= 0 or p378.action_type ~= t1.ActionType.fromNumber(0)) then
		t501.actionType = if typeof(p378.action_type) ~= "number" then t1.ActionType.toNumber(p378.action_type) else p378.action_type
	end

	if p378.action_params ~= nil then
		t501.actionParams = p378.action_params:jsonEncode()
	end

	return t501
end
function t499.jsonDecode(t502: {[any]: any}) -- line: 23917
	-- upvalues: t499 (copy), t1 (copy)
	local v3738 = t499.new()

	if t502.action_type ~= nil then
		v3738.action_type = if typeof(t502.action_type) ~= "number" then t1.ActionType.fromName(t502.action_type) or t502.action_type else t1.ActionType.fromNumber(t502.action_type) or t502.action_type
	end

	if t502.actionType ~= nil then
		v3738.action_type = if typeof(t502.actionType) ~= "number" then t1.ActionType.fromName(t502.actionType) or t502.actionType else t1.ActionType.fromNumber(t502.actionType) or t502.actionType
	end

	if t502.action_params ~= nil then
		v3738.action_params = t1.DismissEventNotificationsModalAction_Params.jsonDecode(t502.action_params)
	end

	if t502.actionParams ~= nil then
		v3738.action_params = t1.DismissEventNotificationsModalAction_Params.jsonDecode(t502.actionParams)
	end

	return v3738
end

t499.descriptor = {
	name = "DismissEventNotificationsModalAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.DismissEventNotificationsModalAction"
}
t1.DismissEventNotificationsModalAction = t499
typeRegistry.default:register(t1.DismissEventNotificationsModalAction)

local t503 = {}

t503.__index = t503

function t503.new(t504: {[any]: any}?) -- line: 23959
	-- upvalues: t503 (copy)
	return (setmetatable({
		event_id = if t504 ~= nil and t504.event_id ~= nil then t504.event_id else nil
	}, t503))
end
function t503.encode(p379) -- line: 23967
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n250 = 0

	if p379.event_id ~= nil then
		local v3743 = p379.event_id:encode()
		local v3744, v3745 = proto.writeTag(buf, n250, 1, proto.wireTypes.lengthDelimited)

		buf, n250 = proto.writeBuffer(v3744, v3745, v3743, buffer.len(v3743))
	end

	local buf128 = buffer.create(n250)

	buffer.copy(buf128, 0, buf, 0, n250)

	return buf128
end
function t503.decode(p380: buffer) -- line: 23984
	-- upvalues: t503 (copy), proto (copy), prop_types (copy)
	local v3748 = t503.new()
	local n251 = 0

	while n251 < buffer.len(p380) do
		local v3750, v3751

		v3750, v3751, n251 = proto.readTag(p380, n251)

		if v3751 == proto.wireTypes.varint then
			local v3752

			v3752, n251 = proto.readVarInt(p380, n251)
		elseif v3751 == proto.wireTypes.lengthDelimited then
			if v3750 == 1 then
				local v3753

				v3753, n251 = proto.readBuffer(p380, n251)
				v3748.event_id = prop_types.StringProp.decode(v3753)
			else
				local v3754, v3755 = proto.readVarInt(p380, n251)

				n251 = v3755 + v3754
			end
		elseif v3751 == proto.wireTypes.i32 then
			local v3756

			v3756, n251 = proto.readFixed32(p380, n251)
		elseif v3751 == proto.wireTypes.i64 then
			local v3757

			v3757, n251 = proto.readFixed64(p380, n251)
		else
			error("Unsupported wire type: " .. v3751)
		end
	end

	return v3748
end
function t503.jsonEncode(p381) -- line: 24029
	local t505 = {}

	if p381.event_id ~= nil then
		t505.eventId = p381.event_id:jsonEncode()
	end

	return t505
end
function t503.jsonDecode(t506: {[any]: any}) -- line: 24041
	-- upvalues: t503 (copy), prop_types (copy)
	local v3761 = t503.new()

	if t506.event_id ~= nil then
		v3761.event_id = prop_types.StringProp.jsonDecode(t506.event_id)
	end

	if t506.eventId ~= nil then
		v3761.event_id = prop_types.StringProp.jsonDecode(t506.eventId)
	end

	return v3761
end

t503.descriptor = {
	name = "DismissEventNotificationsModalAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.DismissEventNotificationsModalAction_Params = t503
typeRegistry.default:register(t1.DismissEventNotificationsModalAction_Params)

local t507 = {}

t507.__index = t507

function t507.new(t508: {[any]: any}?) -- line: 24071
	-- upvalues: t1 (copy), t507 (copy)
	return (setmetatable({
		action_type = if t508 ~= nil and t508.action_type ~= nil then t508.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t508 ~= nil and t508.action_params ~= nil then t508.action_params else nil
	}, t507))
end
function t507.encode(p382) -- line: 24080
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n252 = 0

	if p382.action_type ~= nil and (p382.action_type ~= nil and p382.action_type ~= 0 or p382.action_type ~= t1.ActionType.fromNumber(0)) then
		local v3766, v3767 = proto.writeTag(buf, n252, 1, proto.wireTypes.varint)

		buf, n252 = proto.writeVarInt(v3766, v3767, t1.ActionType.toNumber(p382.action_type))
	end

	if p382.action_params ~= nil then
		local v3768 = p382.action_params:encode()
		local v3769, v3770 = proto.writeTag(buf, n252, 2, proto.wireTypes.lengthDelimited)

		buf, n252 = proto.writeBuffer(v3769, v3770, v3768, buffer.len(v3768))
	end

	local buf129 = buffer.create(n252)

	buffer.copy(buf129, 0, buf, 0, n252)

	return buf129
end
function t507.decode(p383: buffer) -- line: 24106
	-- upvalues: t507 (copy), proto (copy), t1 (copy)
	local v3773 = t507.new()
	local n253 = 0

	while n253 < buffer.len(p383) do
		local v3775, v3776

		v3775, v3776, n253 = proto.readTag(p383, n253)

		if v3776 == proto.wireTypes.varint then
			if v3775 == 1 then
				local v3777

				v3777, n253 = proto.readVarIntI32(p383, n253)
				v3773.action_type = t1.ActionType.fromNumber(v3777) or v3777
			else
				local v3778

				v3778, n253 = proto.readVarInt(p383, n253)
			end
		elseif v3776 == proto.wireTypes.lengthDelimited then
			if v3775 == 2 then
				local v3779

				v3779, n253 = proto.readBuffer(p383, n253)
				v3773.action_params = t1.OpenAmpWizardAction_Params.decode(v3779)
			else
				local v3780, v3781 = proto.readVarInt(p383, n253)

				n253 = v3781 + v3780
			end
		elseif v3776 == proto.wireTypes.i32 then
			local v3782

			v3782, n253 = proto.readFixed32(p383, n253)
		elseif v3776 == proto.wireTypes.i64 then
			local v3783

			v3783, n253 = proto.readFixed64(p383, n253)
		else
			error("Unsupported wire type: " .. v3776)
		end
	end

	return v3773
end
function t507.jsonEncode(p384) -- line: 24154
	-- upvalues: t1 (copy)
	local t509 = {}

	if p384.action_type ~= nil and (p384.action_type ~= nil and p384.action_type ~= 0 or p384.action_type ~= t1.ActionType.fromNumber(0)) then
		t509.actionType = if typeof(p384.action_type) ~= "number" then t1.ActionType.toNumber(p384.action_type) else p384.action_type
	end

	if p384.action_params ~= nil then
		t509.actionParams = p384.action_params:jsonEncode()
	end

	return t509
end
function t507.jsonDecode(t510: {[any]: any}) -- line: 24176
	-- upvalues: t507 (copy), t1 (copy)
	local v3787 = t507.new()

	if t510.action_type ~= nil then
		v3787.action_type = if typeof(t510.action_type) ~= "number" then t1.ActionType.fromName(t510.action_type) or t510.action_type else t1.ActionType.fromNumber(t510.action_type) or t510.action_type
	end

	if t510.actionType ~= nil then
		v3787.action_type = if typeof(t510.actionType) ~= "number" then t1.ActionType.fromName(t510.actionType) or t510.actionType else t1.ActionType.fromNumber(t510.actionType) or t510.actionType
	end

	if t510.action_params ~= nil then
		v3787.action_params = t1.OpenAmpWizardAction_Params.jsonDecode(t510.action_params)
	end

	if t510.actionParams ~= nil then
		v3787.action_params = t1.OpenAmpWizardAction_Params.jsonDecode(t510.actionParams)
	end

	return v3787
end

t507.descriptor = {
	name = "OpenAmpWizardAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.OpenAmpWizardAction"
}
t1.OpenAmpWizardAction = t507
typeRegistry.default:register(t1.OpenAmpWizardAction)

local t511 = {}

t511.__index = t511

function t511.new(t512: {[any]: any}?) -- line: 24216
	-- upvalues: t511 (copy)
	return (setmetatable({
		feature_name = if t512 ~= nil and t512.feature_name ~= nil then t512.feature_name else nil,
		name_space = if t512 ~= nil and t512.name_space ~= nil then t512.name_space else nil,
		entry_point_event_ctx = if t512 ~= nil and t512.entry_point_event_ctx ~= nil then t512.entry_point_event_ctx else nil,
		skip_facial_age_estimation_web_link_modal = if t512 ~= nil and t512.skip_facial_age_estimation_web_link_modal ~= nil then t512.skip_facial_age_estimation_web_link_modal else nil
	}, t511))
end
function t511.encode(p385) -- line: 24232
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n254 = 0

	if p385.feature_name ~= nil then
		local v3792 = p385.feature_name:encode()
		local v3793, v3794 = proto.writeTag(buf, n254, 1, proto.wireTypes.lengthDelimited)

		buf, n254 = proto.writeBuffer(v3793, v3794, v3792, buffer.len(v3792))
	end

	if p385.name_space ~= nil then
		local v3795 = p385.name_space:encode()
		local v3796, v3797 = proto.writeTag(buf, n254, 2, proto.wireTypes.lengthDelimited)

		buf, n254 = proto.writeBuffer(v3796, v3797, v3795, buffer.len(v3795))
	end

	if p385.entry_point_event_ctx ~= nil then
		local v3798 = p385.entry_point_event_ctx:encode()
		local v3799, v3800 = proto.writeTag(buf, n254, 3, proto.wireTypes.lengthDelimited)

		buf, n254 = proto.writeBuffer(v3799, v3800, v3798, buffer.len(v3798))
	end

	if p385.skip_facial_age_estimation_web_link_modal ~= nil then
		local v3801 = p385.skip_facial_age_estimation_web_link_modal:encode()
		local v3802, v3803 = proto.writeTag(buf, n254, 4, proto.wireTypes.lengthDelimited)

		buf, n254 = proto.writeBuffer(v3802, v3803, v3801, buffer.len(v3801))
	end

	local buf130 = buffer.create(n254)

	buffer.copy(buf130, 0, buf, 0, n254)

	return buf130
end
function t511.decode(p386: buffer) -- line: 24265
	-- upvalues: t511 (copy), proto (copy), prop_types (copy)
	local v3806 = t511.new()
	local n255 = 0

	while n255 < buffer.len(p386) do
		local v3808, v3809

		v3808, v3809, n255 = proto.readTag(p386, n255)

		if v3809 == proto.wireTypes.varint then
			local v3810

			v3810, n255 = proto.readVarInt(p386, n255)
		elseif v3809 == proto.wireTypes.lengthDelimited then
			if v3808 == 1 then
				local v3811

				v3811, n255 = proto.readBuffer(p386, n255)
				v3806.feature_name = prop_types.StringProp.decode(v3811)
			elseif v3808 == 2 then
				local v3812

				v3812, n255 = proto.readBuffer(p386, n255)
				v3806.name_space = prop_types.StringProp.decode(v3812)
			elseif v3808 == 3 then
				local v3813

				v3813, n255 = proto.readBuffer(p386, n255)
				v3806.entry_point_event_ctx = prop_types.StringProp.decode(v3813)
			elseif v3808 == 4 then
				local v3814

				v3814, n255 = proto.readBuffer(p386, n255)
				v3806.skip_facial_age_estimation_web_link_modal = prop_types.BoolProp.decode(v3814)
			else
				local v3815, v3816 = proto.readVarInt(p386, n255)

				n255 = v3816 + v3815
			end
		elseif v3809 == proto.wireTypes.i32 then
			local v3817

			v3817, n255 = proto.readFixed32(p386, n255)
		elseif v3809 == proto.wireTypes.i64 then
			local v3818

			v3818, n255 = proto.readFixed64(p386, n255)
		else
			error("Unsupported wire type: " .. v3809)
		end
	end

	return v3806
end
function t511.jsonEncode(p387) -- line: 24325
	local t513 = {}

	if p387.feature_name ~= nil then
		t513.featureName = p387.feature_name:jsonEncode()
	end

	if p387.name_space ~= nil then
		t513.nameSpace = p387.name_space:jsonEncode()
	end

	if p387.entry_point_event_ctx ~= nil then
		t513.entryPointEventCtx = p387.entry_point_event_ctx:jsonEncode()
	end

	if p387.skip_facial_age_estimation_web_link_modal ~= nil then
		t513.skipFacialAgeEstimationWebLinkModal = p387.skip_facial_age_estimation_web_link_modal:jsonEncode()
	end

	return t513
end
function t511.jsonDecode(t514: {[any]: any}) -- line: 24347
	-- upvalues: t511 (copy), prop_types (copy)
	local v3822 = t511.new()

	if t514.feature_name ~= nil then
		v3822.feature_name = prop_types.StringProp.jsonDecode(t514.feature_name)
	end

	if t514.featureName ~= nil then
		v3822.feature_name = prop_types.StringProp.jsonDecode(t514.featureName)
	end

	if t514.name_space ~= nil then
		v3822.name_space = prop_types.StringProp.jsonDecode(t514.name_space)
	end

	if t514.nameSpace ~= nil then
		v3822.name_space = prop_types.StringProp.jsonDecode(t514.nameSpace)
	end

	if t514.entry_point_event_ctx ~= nil then
		v3822.entry_point_event_ctx = prop_types.StringProp.jsonDecode(t514.entry_point_event_ctx)
	end

	if t514.entryPointEventCtx ~= nil then
		v3822.entry_point_event_ctx = prop_types.StringProp.jsonDecode(t514.entryPointEventCtx)
	end

	if t514.skip_facial_age_estimation_web_link_modal ~= nil then
		v3822.skip_facial_age_estimation_web_link_modal = prop_types.BoolProp.jsonDecode(t514.skip_facial_age_estimation_web_link_modal)
	end

	if t514.skipFacialAgeEstimationWebLinkModal ~= nil then
		v3822.skip_facial_age_estimation_web_link_modal = prop_types.BoolProp.jsonDecode(t514.skipFacialAgeEstimationWebLinkModal)
	end

	return v3822
end

t511.descriptor = {
	name = "OpenAmpWizardAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.OpenAmpWizardAction_Params = t511
typeRegistry.default:register(t1.OpenAmpWizardAction_Params)

local t515 = {}

t515.__index = t515

function t515.new(t516: {[any]: any}?) -- line: 24409
	-- upvalues: t1 (copy), t515 (copy)
	return (setmetatable({
		action_type = if t516 ~= nil and t516.action_type ~= nil then t516.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t516 ~= nil and t516.action_params ~= nil then t516.action_params else nil
	}, t515))
end
function t515.encode(p388) -- line: 24420
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n256 = 0

	if p388.action_type ~= nil and (p388.action_type ~= nil and p388.action_type ~= 0 or p388.action_type ~= t1.ActionType.fromNumber(0)) then
		local v3827, v3828 = proto.writeTag(buf, n256, 1, proto.wireTypes.varint)

		buf, n256 = proto.writeVarInt(v3827, v3828, t1.ActionType.toNumber(p388.action_type))
	end

	if p388.action_params ~= nil then
		local v3829 = p388.action_params:encode()
		local v3830, v3831 = proto.writeTag(buf, n256, 2, proto.wireTypes.lengthDelimited)

		buf, n256 = proto.writeBuffer(v3830, v3831, v3829, buffer.len(v3829))
	end

	local buf131 = buffer.create(n256)

	buffer.copy(buf131, 0, buf, 0, n256)

	return buf131
end
function t515.decode(p389: buffer) -- line: 24446
	-- upvalues: t515 (copy), proto (copy), t1 (copy)
	local v3834 = t515.new()
	local n257 = 0

	while n257 < buffer.len(p389) do
		local v3836, v3837

		v3836, v3837, n257 = proto.readTag(p389, n257)

		if v3837 == proto.wireTypes.varint then
			if v3836 == 1 then
				local v3838

				v3838, n257 = proto.readVarIntI32(p389, n257)
				v3834.action_type = t1.ActionType.fromNumber(v3838) or v3838
			else
				local v3839

				v3839, n257 = proto.readVarInt(p389, n257)
			end
		elseif v3837 == proto.wireTypes.lengthDelimited then
			if v3836 == 2 then
				local v3840

				v3840, n257 = proto.readBuffer(p389, n257)
				v3834.action_params = t1.OpenSocialProofUserListSheetAction_Params.decode(v3840)
			else
				local v3841, v3842 = proto.readVarInt(p389, n257)

				n257 = v3842 + v3841
			end
		elseif v3837 == proto.wireTypes.i32 then
			local v3843

			v3843, n257 = proto.readFixed32(p389, n257)
		elseif v3837 == proto.wireTypes.i64 then
			local v3844

			v3844, n257 = proto.readFixed64(p389, n257)
		else
			error("Unsupported wire type: " .. v3837)
		end
	end

	return v3834
end
function t515.jsonEncode(p390) -- line: 24494
	-- upvalues: t1 (copy)
	local t517 = {}

	if p390.action_type ~= nil and (p390.action_type ~= nil and p390.action_type ~= 0 or p390.action_type ~= t1.ActionType.fromNumber(0)) then
		t517.actionType = if typeof(p390.action_type) ~= "number" then t1.ActionType.toNumber(p390.action_type) else p390.action_type
	end

	if p390.action_params ~= nil then
		t517.actionParams = p390.action_params:jsonEncode()
	end

	return t517
end
function t515.jsonDecode(t518: {[any]: any}) -- line: 24516
	-- upvalues: t515 (copy), t1 (copy)
	local v3848 = t515.new()

	if t518.action_type ~= nil then
		v3848.action_type = if typeof(t518.action_type) ~= "number" then t1.ActionType.fromName(t518.action_type) or t518.action_type else t1.ActionType.fromNumber(t518.action_type) or t518.action_type
	end

	if t518.actionType ~= nil then
		v3848.action_type = if typeof(t518.actionType) ~= "number" then t1.ActionType.fromName(t518.actionType) or t518.actionType else t1.ActionType.fromNumber(t518.actionType) or t518.actionType
	end

	if t518.action_params ~= nil then
		v3848.action_params = t1.OpenSocialProofUserListSheetAction_Params.jsonDecode(t518.action_params)
	end

	if t518.actionParams ~= nil then
		v3848.action_params = t1.OpenSocialProofUserListSheetAction_Params.jsonDecode(t518.actionParams)
	end

	return v3848
end

t515.descriptor = {
	name = "OpenSocialProofUserListSheetAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.OpenSocialProofUserListSheetAction"
}
t1.OpenSocialProofUserListSheetAction = t515
typeRegistry.default:register(t1.OpenSocialProofUserListSheetAction)

local t519 = {}

t519.__index = t519

function t519.new(t520: {[any]: any}?) -- line: 24558
	-- upvalues: t519 (copy)
	return (setmetatable({
		universe_id = if t520 ~= nil and t520.universe_id ~= nil then t520.universe_id else nil,
		place_id = if t520 ~= nil and t520.place_id ~= nil then t520.place_id else nil,
		total_connections = if t520 ~= nil and t520.total_connections ~= nil then t520.total_connections else nil,
		user_ids = if t520 ~= nil and t520.user_ids ~= nil then t520.user_ids else nil,
		sheet_title = if t520 ~= nil and t520.sheet_title ~= nil then t520.sheet_title else nil
	}, t519))
end
function t519.encode(p391) -- line: 24570
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n258 = 0

	if p391.universe_id ~= nil then
		local v3853 = p391.universe_id:encode()
		local v3854, v3855 = proto.writeTag(buf, n258, 1, proto.wireTypes.lengthDelimited)

		buf, n258 = proto.writeBuffer(v3854, v3855, v3853, buffer.len(v3853))
	end

	if p391.place_id ~= nil then
		local v3856 = p391.place_id:encode()
		local v3857, v3858 = proto.writeTag(buf, n258, 2, proto.wireTypes.lengthDelimited)

		buf, n258 = proto.writeBuffer(v3857, v3858, v3856, buffer.len(v3856))
	end

	if p391.total_connections ~= nil then
		local v3859 = p391.total_connections:encode()
		local v3860, v3861 = proto.writeTag(buf, n258, 3, proto.wireTypes.lengthDelimited)

		buf, n258 = proto.writeBuffer(v3860, v3861, v3859, buffer.len(v3859))
	end

	if p391.user_ids ~= nil then
		local v3862 = p391.user_ids:encode()
		local v3863, v3864 = proto.writeTag(buf, n258, 4, proto.wireTypes.lengthDelimited)

		buf, n258 = proto.writeBuffer(v3863, v3864, v3862, buffer.len(v3862))
	end

	if p391.sheet_title ~= nil then
		local v3865 = p391.sheet_title:encode()
		local v3866, v3867 = proto.writeTag(buf, n258, 5, proto.wireTypes.lengthDelimited)

		buf, n258 = proto.writeBuffer(v3866, v3867, v3865, buffer.len(v3865))
	end

	local buf132 = buffer.create(n258)

	buffer.copy(buf132, 0, buf, 0, n258)

	return buf132
end
function t519.decode(p392: buffer) -- line: 24611
	-- upvalues: t519 (copy), proto (copy), prop_types (copy)
	local v3870 = t519.new()
	local n259 = 0

	while n259 < buffer.len(p392) do
		local v3872, v3873

		v3872, v3873, n259 = proto.readTag(p392, n259)

		if v3873 == proto.wireTypes.varint then
			local v3874

			v3874, n259 = proto.readVarInt(p392, n259)
		elseif v3873 == proto.wireTypes.lengthDelimited then
			if v3872 == 1 then
				local v3875

				v3875, n259 = proto.readBuffer(p392, n259)
				v3870.universe_id = prop_types.StringProp.decode(v3875)
			elseif v3872 == 2 then
				local v3876

				v3876, n259 = proto.readBuffer(p392, n259)
				v3870.place_id = prop_types.StringProp.decode(v3876)
			elseif v3872 == 3 then
				local v3877

				v3877, n259 = proto.readBuffer(p392, n259)
				v3870.total_connections = prop_types.Int32Prop.decode(v3877)
			elseif v3872 == 4 then
				local v3878

				v3878, n259 = proto.readBuffer(p392, n259)
				v3870.user_ids = prop_types.ArrayOfAvatarProp.decode(v3878)
			elseif v3872 == 5 then
				local v3879

				v3879, n259 = proto.readBuffer(p392, n259)
				v3870.sheet_title = prop_types.StringProp.decode(v3879)
			else
				local v3880, v3881 = proto.readVarInt(p392, n259)

				n259 = v3881 + v3880
			end
		elseif v3873 == proto.wireTypes.i32 then
			local v3882

			v3882, n259 = proto.readFixed32(p392, n259)
		elseif v3873 == proto.wireTypes.i64 then
			local v3883

			v3883, n259 = proto.readFixed64(p392, n259)
		else
			error("Unsupported wire type: " .. v3873)
		end
	end

	return v3870
end
function t519.jsonEncode(p393) -- line: 24676
	local t521 = {}

	if p393.universe_id ~= nil then
		t521.universeId = p393.universe_id:jsonEncode()
	end

	if p393.place_id ~= nil then
		t521.placeId = p393.place_id:jsonEncode()
	end

	if p393.total_connections ~= nil then
		t521.totalConnections = p393.total_connections:jsonEncode()
	end

	if p393.user_ids ~= nil then
		t521.userIds = p393.user_ids:jsonEncode()
	end

	if p393.sheet_title ~= nil then
		t521.sheetTitle = p393.sheet_title:jsonEncode()
	end

	return t521
end
function t519.jsonDecode(t522: {[any]: any}) -- line: 24704
	-- upvalues: t519 (copy), prop_types (copy)
	local v3887 = t519.new()

	if t522.universe_id ~= nil then
		v3887.universe_id = prop_types.StringProp.jsonDecode(t522.universe_id)
	end

	if t522.universeId ~= nil then
		v3887.universe_id = prop_types.StringProp.jsonDecode(t522.universeId)
	end

	if t522.place_id ~= nil then
		v3887.place_id = prop_types.StringProp.jsonDecode(t522.place_id)
	end

	if t522.placeId ~= nil then
		v3887.place_id = prop_types.StringProp.jsonDecode(t522.placeId)
	end

	if t522.total_connections ~= nil then
		v3887.total_connections = prop_types.Int32Prop.jsonDecode(t522.total_connections)
	end

	if t522.totalConnections ~= nil then
		v3887.total_connections = prop_types.Int32Prop.jsonDecode(t522.totalConnections)
	end

	if t522.user_ids ~= nil then
		v3887.user_ids = prop_types.ArrayOfAvatarProp.jsonDecode(t522.user_ids)
	end

	if t522.userIds ~= nil then
		v3887.user_ids = prop_types.ArrayOfAvatarProp.jsonDecode(t522.userIds)
	end

	if t522.sheet_title ~= nil then
		v3887.sheet_title = prop_types.StringProp.jsonDecode(t522.sheet_title)
	end

	if t522.sheetTitle ~= nil then
		v3887.sheet_title = prop_types.StringProp.jsonDecode(t522.sheetTitle)
	end

	return v3887
end

t519.descriptor = {
	name = "OpenSocialProofUserListSheetAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.OpenSocialProofUserListSheetAction_Params = t519
typeRegistry.default:register(t1.OpenSocialProofUserListSheetAction_Params)

local t523 = {}

t523.__index = t523

function t523.new(t524: {[any]: any}?) -- line: 24772
	-- upvalues: t1 (copy), t523 (copy)
	return (setmetatable({
		action_type = if t524 ~= nil and t524.action_type ~= nil then t524.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t524 ~= nil and t524.action_params ~= nil then t524.action_params else nil
	}, t523))
end
function t523.encode(p394) -- line: 24783
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n260 = 0

	if p394.action_type ~= nil and (p394.action_type ~= nil and p394.action_type ~= 0 or p394.action_type ~= t1.ActionType.fromNumber(0)) then
		local v3892, v3893 = proto.writeTag(buf, n260, 1, proto.wireTypes.varint)

		buf, n260 = proto.writeVarInt(v3892, v3893, t1.ActionType.toNumber(p394.action_type))
	end

	if p394.action_params ~= nil then
		local v3894 = p394.action_params:encode()
		local v3895, v3896 = proto.writeTag(buf, n260, 2, proto.wireTypes.lengthDelimited)

		buf, n260 = proto.writeBuffer(v3895, v3896, v3894, buffer.len(v3894))
	end

	local buf133 = buffer.create(n260)

	buffer.copy(buf133, 0, buf, 0, n260)

	return buf133
end
function t523.decode(p395: buffer) -- line: 24809
	-- upvalues: t523 (copy), proto (copy), t1 (copy)
	local v3899 = t523.new()
	local n261 = 0

	while n261 < buffer.len(p395) do
		local v3901, v3902

		v3901, v3902, n261 = proto.readTag(p395, n261)

		if v3902 == proto.wireTypes.varint then
			if v3901 == 1 then
				local v3903

				v3903, n261 = proto.readVarIntI32(p395, n261)
				v3899.action_type = t1.ActionType.fromNumber(v3903) or v3903
			else
				local v3904

				v3904, n261 = proto.readVarInt(p395, n261)
			end
		elseif v3902 == proto.wireTypes.lengthDelimited then
			if v3901 == 2 then
				local v3905

				v3905, n261 = proto.readBuffer(p395, n261)
				v3899.action_params = t1.OpenSearchResultsTabAction_Params.decode(v3905)
			else
				local v3906, v3907 = proto.readVarInt(p395, n261)

				n261 = v3907 + v3906
			end
		elseif v3902 == proto.wireTypes.i32 then
			local v3908

			v3908, n261 = proto.readFixed32(p395, n261)
		elseif v3902 == proto.wireTypes.i64 then
			local v3909

			v3909, n261 = proto.readFixed64(p395, n261)
		else
			error("Unsupported wire type: " .. v3902)
		end
	end

	return v3899
end
function t523.jsonEncode(p396) -- line: 24857
	-- upvalues: t1 (copy)
	local t525 = {}

	if p396.action_type ~= nil and (p396.action_type ~= nil and p396.action_type ~= 0 or p396.action_type ~= t1.ActionType.fromNumber(0)) then
		t525.actionType = if typeof(p396.action_type) ~= "number" then t1.ActionType.toNumber(p396.action_type) else p396.action_type
	end

	if p396.action_params ~= nil then
		t525.actionParams = p396.action_params:jsonEncode()
	end

	return t525
end
function t523.jsonDecode(t526: {[any]: any}) -- line: 24879
	-- upvalues: t523 (copy), t1 (copy)
	local v3913 = t523.new()

	if t526.action_type ~= nil then
		v3913.action_type = if typeof(t526.action_type) ~= "number" then t1.ActionType.fromName(t526.action_type) or t526.action_type else t1.ActionType.fromNumber(t526.action_type) or t526.action_type
	end

	if t526.actionType ~= nil then
		v3913.action_type = if typeof(t526.actionType) ~= "number" then t1.ActionType.fromName(t526.actionType) or t526.actionType else t1.ActionType.fromNumber(t526.actionType) or t526.actionType
	end

	if t526.action_params ~= nil then
		v3913.action_params = t1.OpenSearchResultsTabAction_Params.jsonDecode(t526.action_params)
	end

	if t526.actionParams ~= nil then
		v3913.action_params = t1.OpenSearchResultsTabAction_Params.jsonDecode(t526.actionParams)
	end

	return v3913
end

t523.descriptor = {
	name = "OpenSearchResultsTabAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.OpenSearchResultsTabAction"
}
t1.OpenSearchResultsTabAction = t523
typeRegistry.default:register(t1.OpenSearchResultsTabAction)

local t527 = {}

t527.__index = t527

function t527.new(t528: {[any]: any}?) -- line: 24919
	-- upvalues: t527 (copy)
	return (setmetatable({
		search_type = if t528 ~= nil and t528.search_type ~= nil then t528.search_type else nil
	}, t527))
end
function t527.encode(p397) -- line: 24927
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n262 = 0

	if p397.search_type ~= nil then
		local v3918 = p397.search_type:encode()
		local v3919, v3920 = proto.writeTag(buf, n262, 1, proto.wireTypes.lengthDelimited)

		buf, n262 = proto.writeBuffer(v3919, v3920, v3918, buffer.len(v3918))
	end

	local buf134 = buffer.create(n262)

	buffer.copy(buf134, 0, buf, 0, n262)

	return buf134
end
function t527.decode(p398: buffer) -- line: 24942
	-- upvalues: t527 (copy), proto (copy), prop_types (copy)
	local v3923 = t527.new()
	local n263 = 0

	while n263 < buffer.len(p398) do
		local v3925, v3926

		v3925, v3926, n263 = proto.readTag(p398, n263)

		if v3926 == proto.wireTypes.varint then
			local v3927

			v3927, n263 = proto.readVarInt(p398, n263)
		elseif v3926 == proto.wireTypes.lengthDelimited then
			if v3925 == 1 then
				local v3928

				v3928, n263 = proto.readBuffer(p398, n263)
				v3923.search_type = prop_types.StringProp.decode(v3928)
			else
				local v3929, v3930 = proto.readVarInt(p398, n263)

				n263 = v3930 + v3929
			end
		elseif v3926 == proto.wireTypes.i32 then
			local v3931

			v3931, n263 = proto.readFixed32(p398, n263)
		elseif v3926 == proto.wireTypes.i64 then
			local v3932

			v3932, n263 = proto.readFixed64(p398, n263)
		else
			error("Unsupported wire type: " .. v3926)
		end
	end

	return v3923
end
function t527.jsonEncode(p399) -- line: 24985
	local t529 = {}

	if p399.search_type ~= nil then
		t529.searchType = p399.search_type:jsonEncode()
	end

	return t529
end
function t527.jsonDecode(t530: {[any]: any}) -- line: 24995
	-- upvalues: t527 (copy), prop_types (copy)
	local v3936 = t527.new()

	if t530.search_type ~= nil then
		v3936.search_type = prop_types.StringProp.jsonDecode(t530.search_type)
	end

	if t530.searchType ~= nil then
		v3936.search_type = prop_types.StringProp.jsonDecode(t530.searchType)
	end

	return v3936
end

t527.descriptor = {
	name = "OpenSearchResultsTabAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.OpenSearchResultsTabAction_Params = t527
typeRegistry.default:register(t1.OpenSearchResultsTabAction_Params)

local t531 = {}

t531.__index = t531

function t531.new(t532: {[any]: any}?) -- line: 25026
	-- upvalues: t1 (copy), t531 (copy)
	return (setmetatable({
		action_type = if t532 ~= nil and t532.action_type ~= nil then t532.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t532 ~= nil and t532.action_params ~= nil then t532.action_params else nil
	}, t531))
end
function t531.encode(p400) -- line: 25035
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n264 = 0

	if p400.action_type ~= nil and (p400.action_type ~= nil and p400.action_type ~= 0 or p400.action_type ~= t1.ActionType.fromNumber(0)) then
		local v3941, v3942 = proto.writeTag(buf, n264, 1, proto.wireTypes.varint)

		buf, n264 = proto.writeVarInt(v3941, v3942, t1.ActionType.toNumber(p400.action_type))
	end

	if p400.action_params ~= nil then
		local v3943 = p400.action_params:encode()
		local v3944, v3945 = proto.writeTag(buf, n264, 2, proto.wireTypes.lengthDelimited)

		buf, n264 = proto.writeBuffer(v3944, v3945, v3943, buffer.len(v3943))
	end

	local buf135 = buffer.create(n264)

	buffer.copy(buf135, 0, buf, 0, n264)

	return buf135
end
function t531.decode(p401: buffer) -- line: 25061
	-- upvalues: t531 (copy), proto (copy), t1 (copy)
	local v3948 = t531.new()
	local n265 = 0

	while n265 < buffer.len(p401) do
		local v3950, v3951

		v3950, v3951, n265 = proto.readTag(p401, n265)

		if v3951 == proto.wireTypes.varint then
			if v3950 == 1 then
				local v3952

				v3952, n265 = proto.readVarIntI32(p401, n265)
				v3948.action_type = t1.ActionType.fromNumber(v3952) or v3952
			else
				local v3953

				v3953, n265 = proto.readVarInt(p401, n265)
			end
		elseif v3951 == proto.wireTypes.lengthDelimited then
			if v3950 == 2 then
				local v3954

				v3954, n265 = proto.readBuffer(p401, n265)
				v3948.action_params = t1.DismissPromptAction_Params.decode(v3954)
			else
				local v3955, v3956 = proto.readVarInt(p401, n265)

				n265 = v3956 + v3955
			end
		elseif v3951 == proto.wireTypes.i32 then
			local v3957

			v3957, n265 = proto.readFixed32(p401, n265)
		elseif v3951 == proto.wireTypes.i64 then
			local v3958

			v3958, n265 = proto.readFixed64(p401, n265)
		else
			error("Unsupported wire type: " .. v3951)
		end
	end

	return v3948
end
function t531.jsonEncode(p402) -- line: 25109
	-- upvalues: t1 (copy)
	local t533 = {}

	if p402.action_type ~= nil and (p402.action_type ~= nil and p402.action_type ~= 0 or p402.action_type ~= t1.ActionType.fromNumber(0)) then
		t533.actionType = if typeof(p402.action_type) ~= "number" then t1.ActionType.toNumber(p402.action_type) else p402.action_type
	end

	if p402.action_params ~= nil then
		t533.actionParams = p402.action_params:jsonEncode()
	end

	return t533
end
function t531.jsonDecode(t534: {[any]: any}) -- line: 25131
	-- upvalues: t531 (copy), t1 (copy)
	local v3962 = t531.new()

	if t534.action_type ~= nil then
		v3962.action_type = if typeof(t534.action_type) ~= "number" then t1.ActionType.fromName(t534.action_type) or t534.action_type else t1.ActionType.fromNumber(t534.action_type) or t534.action_type
	end

	if t534.actionType ~= nil then
		v3962.action_type = if typeof(t534.actionType) ~= "number" then t1.ActionType.fromName(t534.actionType) or t534.actionType else t1.ActionType.fromNumber(t534.actionType) or t534.actionType
	end

	if t534.action_params ~= nil then
		v3962.action_params = t1.DismissPromptAction_Params.jsonDecode(t534.action_params)
	end

	if t534.actionParams ~= nil then
		v3962.action_params = t1.DismissPromptAction_Params.jsonDecode(t534.actionParams)
	end

	return v3962
end

t531.descriptor = {
	name = "DismissPromptAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.DismissPromptAction"
}
t1.DismissPromptAction = t531
typeRegistry.default:register(t1.DismissPromptAction)

local t535 = {}

t535.__index = t535

function t535.new(t536: {[any]: any}?) -- line: 25171
	-- upvalues: t535 (copy)
	return (setmetatable({
		prompt_type = if t536 ~= nil and t536.prompt_type ~= nil then t536.prompt_type else nil,
		prompt_id = if t536 ~= nil and t536.prompt_id ~= nil then t536.prompt_id else nil
	}, t535))
end
function t535.encode(p403) -- line: 25180
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n266 = 0

	if p403.prompt_type ~= nil then
		local v3967 = p403.prompt_type:encode()
		local v3968, v3969 = proto.writeTag(buf, n266, 1, proto.wireTypes.lengthDelimited)

		buf, n266 = proto.writeBuffer(v3968, v3969, v3967, buffer.len(v3967))
	end

	if p403.prompt_id ~= nil then
		local v3970 = p403.prompt_id:encode()
		local v3971, v3972 = proto.writeTag(buf, n266, 2, proto.wireTypes.lengthDelimited)

		buf, n266 = proto.writeBuffer(v3971, v3972, v3970, buffer.len(v3970))
	end

	local buf136 = buffer.create(n266)

	buffer.copy(buf136, 0, buf, 0, n266)

	return buf136
end
function t535.decode(p404: buffer) -- line: 25201
	-- upvalues: t535 (copy), proto (copy), prop_types (copy)
	local v3975 = t535.new()
	local n267 = 0

	while n267 < buffer.len(p404) do
		local v3977, v3978

		v3977, v3978, n267 = proto.readTag(p404, n267)

		if v3978 == proto.wireTypes.varint then
			local v3979

			v3979, n267 = proto.readVarInt(p404, n267)
		elseif v3978 == proto.wireTypes.lengthDelimited then
			if v3977 == 1 then
				local v3980

				v3980, n267 = proto.readBuffer(p404, n267)
				v3975.prompt_type = prop_types.StringProp.decode(v3980)
			elseif v3977 == 2 then
				local v3981

				v3981, n267 = proto.readBuffer(p404, n267)
				v3975.prompt_id = prop_types.StringProp.decode(v3981)
			else
				local v3982, v3983 = proto.readVarInt(p404, n267)

				n267 = v3983 + v3982
			end
		elseif v3978 == proto.wireTypes.i32 then
			local v3984

			v3984, n267 = proto.readFixed32(p404, n267)
		elseif v3978 == proto.wireTypes.i64 then
			local v3985

			v3985, n267 = proto.readFixed64(p404, n267)
		else
			error("Unsupported wire type: " .. v3978)
		end
	end

	return v3975
end
function t535.jsonEncode(p405) -- line: 25249
	local t537 = {}

	if p405.prompt_type ~= nil then
		t537.promptType = p405.prompt_type:jsonEncode()
	end

	if p405.prompt_id ~= nil then
		t537.promptId = p405.prompt_id:jsonEncode()
	end

	return t537
end
function t535.jsonDecode(t538: {[any]: any}) -- line: 25263
	-- upvalues: t535 (copy), prop_types (copy)
	local v3989 = t535.new()

	if t538.prompt_type ~= nil then
		v3989.prompt_type = prop_types.StringProp.jsonDecode(t538.prompt_type)
	end

	if t538.promptType ~= nil then
		v3989.prompt_type = prop_types.StringProp.jsonDecode(t538.promptType)
	end

	if t538.prompt_id ~= nil then
		v3989.prompt_id = prop_types.StringProp.jsonDecode(t538.prompt_id)
	end

	if t538.promptId ~= nil then
		v3989.prompt_id = prop_types.StringProp.jsonDecode(t538.promptId)
	end

	return v3989
end

t535.descriptor = {
	name = "DismissPromptAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.DismissPromptAction_Params = t535
typeRegistry.default:register(t1.DismissPromptAction_Params)

local t539 = {}

t539.__index = t539

function t539.new(t540: {[any]: any}?) -- line: 25301
	-- upvalues: t1 (copy), t539 (copy)
	return (setmetatable({
		action_type = if t540 ~= nil and t540.action_type ~= nil then t540.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t540 ~= nil and t540.action_params ~= nil then t540.action_params else nil
	}, t539))
end
function t539.encode(p406) -- line: 25315
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n268 = 0

	if p406.action_type ~= nil and (p406.action_type ~= nil and p406.action_type ~= 0 or p406.action_type ~= t1.ActionType.fromNumber(0)) then
		local v3994, v3995 = proto.writeTag(buf, n268, 1, proto.wireTypes.varint)

		buf, n268 = proto.writeVarInt(v3994, v3995, t1.ActionType.toNumber(p406.action_type))
	end

	if p406.action_params ~= nil then
		local v3996 = p406.action_params:encode()
		local v3997, v3998 = proto.writeTag(buf, n268, 2, proto.wireTypes.lengthDelimited)

		buf, n268 = proto.writeBuffer(v3997, v3998, v3996, buffer.len(v3996))
	end

	local buf137 = buffer.create(n268)

	buffer.copy(buf137, 0, buf, 0, n268)

	return buf137
end
function t539.decode(p407: buffer) -- line: 25343
	-- upvalues: t539 (copy), proto (copy), t1 (copy)
	local v4001 = t539.new()
	local n269 = 0

	while n269 < buffer.len(p407) do
		local v4003, v4004

		v4003, v4004, n269 = proto.readTag(p407, n269)

		if v4004 == proto.wireTypes.varint then
			if v4003 == 1 then
				local v4005

				v4005, n269 = proto.readVarIntI32(p407, n269)
				v4001.action_type = t1.ActionType.fromNumber(v4005) or v4005
			else
				local v4006

				v4006, n269 = proto.readVarInt(p407, n269)
			end
		elseif v4004 == proto.wireTypes.lengthDelimited then
			if v4003 == 2 then
				local v4007

				v4007, n269 = proto.readBuffer(p407, n269)
				v4001.action_params = t1.RecordPartyChatConversationUpsellAcknowledgementAction_Params.decode(v4007)
			else
				local v4008, v4009 = proto.readVarInt(p407, n269)

				n269 = v4009 + v4008
			end
		elseif v4004 == proto.wireTypes.i32 then
			local v4010

			v4010, n269 = proto.readFixed32(p407, n269)
		elseif v4004 == proto.wireTypes.i64 then
			local v4011

			v4011, n269 = proto.readFixed64(p407, n269)
		else
			error("Unsupported wire type: " .. v4004)
		end
	end

	return v4001
end
function t539.jsonEncode(p408) -- line: 25394
	-- upvalues: t1 (copy)
	local t541 = {}

	if p408.action_type ~= nil and (p408.action_type ~= nil and p408.action_type ~= 0 or p408.action_type ~= t1.ActionType.fromNumber(0)) then
		t541.actionType = if typeof(p408.action_type) ~= "number" then t1.ActionType.toNumber(p408.action_type) else p408.action_type
	end

	if p408.action_params ~= nil then
		t541.actionParams = p408.action_params:jsonEncode()
	end

	return t541
end
function t539.jsonDecode(t542: {[any]: any}) -- line: 25418
	-- upvalues: t539 (copy), t1 (copy)
	local v4015 = t539.new()

	if t542.action_type ~= nil then
		v4015.action_type = if typeof(t542.action_type) ~= "number" then t1.ActionType.fromName(t542.action_type) or t542.action_type else t1.ActionType.fromNumber(t542.action_type) or t542.action_type
	end

	if t542.actionType ~= nil then
		v4015.action_type = if typeof(t542.actionType) ~= "number" then t1.ActionType.fromName(t542.actionType) or t542.actionType else t1.ActionType.fromNumber(t542.actionType) or t542.actionType
	end

	if t542.action_params ~= nil then
		v4015.action_params = t1.RecordPartyChatConversationUpsellAcknowledgementAction_Params.jsonDecode(t542.action_params)
	end

	if t542.actionParams ~= nil then
		v4015.action_params = t1.RecordPartyChatConversationUpsellAcknowledgementAction_Params.jsonDecode(t542.actionParams)
	end

	return v4015
end

t539.descriptor = {
	name = "RecordPartyChatConversationUpsellAcknowledgementAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.RecordPartyChatConversationUpsellAcknowledgementAction"
}
t1.RecordPartyChatConversationUpsellAcknowledgementAction = t539
typeRegistry.default:register(t1.RecordPartyChatConversationUpsellAcknowledgementAction)

local t543 = {}

t543.__index = t543

function t543.new(t544: {[any]: any}?) -- line: 25464
	-- upvalues: t543 (copy)
	return (setmetatable({
		modal_action = if t544 ~= nil and t544.modal_action ~= nil then t544.modal_action else nil,
		modal_variant = if t544 ~= nil and t544.modal_variant ~= nil then t544.modal_variant else nil,
		modal_sequence = if t544 ~= nil and t544.modal_sequence ~= nil then t544.modal_sequence else nil,
		conversation_id = if t544 ~= nil and t544.conversation_id ~= nil then t544.conversation_id else nil,
		friend_id = if t544 ~= nil and t544.friend_id ~= nil then t544.friend_id else nil
	}, t543))
end
function t543.encode(p409) -- line: 25479
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n270 = 0

	if p409.modal_action ~= nil then
		local v4020 = p409.modal_action:encode()
		local v4021, v4022 = proto.writeTag(buf, n270, 1, proto.wireTypes.lengthDelimited)

		buf, n270 = proto.writeBuffer(v4021, v4022, v4020, buffer.len(v4020))
	end

	if p409.modal_variant ~= nil then
		local v4023 = p409.modal_variant:encode()
		local v4024, v4025 = proto.writeTag(buf, n270, 2, proto.wireTypes.lengthDelimited)

		buf, n270 = proto.writeBuffer(v4024, v4025, v4023, buffer.len(v4023))
	end

	if p409.modal_sequence ~= nil then
		local v4026 = p409.modal_sequence:encode()
		local v4027, v4028 = proto.writeTag(buf, n270, 3, proto.wireTypes.lengthDelimited)

		buf, n270 = proto.writeBuffer(v4027, v4028, v4026, buffer.len(v4026))
	end

	if p409.conversation_id ~= nil then
		local v4029 = p409.conversation_id:encode()
		local v4030, v4031 = proto.writeTag(buf, n270, 4, proto.wireTypes.lengthDelimited)

		buf, n270 = proto.writeBuffer(v4030, v4031, v4029, buffer.len(v4029))
	end

	if p409.friend_id ~= nil then
		local v4032 = p409.friend_id:encode()
		local v4033, v4034 = proto.writeTag(buf, n270, 5, proto.wireTypes.lengthDelimited)

		buf, n270 = proto.writeBuffer(v4033, v4034, v4032, buffer.len(v4032))
	end

	local buf138 = buffer.create(n270)

	buffer.copy(buf138, 0, buf, 0, n270)

	return buf138
end
function t543.decode(p410: buffer) -- line: 25520
	-- upvalues: t543 (copy), proto (copy), prop_types (copy)
	local v4037 = t543.new()
	local n271 = 0

	while n271 < buffer.len(p410) do
		local v4039, v4040

		v4039, v4040, n271 = proto.readTag(p410, n271)

		if v4040 == proto.wireTypes.varint then
			local v4041

			v4041, n271 = proto.readVarInt(p410, n271)
		elseif v4040 == proto.wireTypes.lengthDelimited then
			if v4039 == 1 then
				local v4042

				v4042, n271 = proto.readBuffer(p410, n271)
				v4037.modal_action = prop_types.StringProp.decode(v4042)
			elseif v4039 == 2 then
				local v4043

				v4043, n271 = proto.readBuffer(p410, n271)
				v4037.modal_variant = prop_types.StringProp.decode(v4043)
			elseif v4039 == 3 then
				local v4044

				v4044, n271 = proto.readBuffer(p410, n271)
				v4037.modal_sequence = prop_types.StringProp.decode(v4044)
			elseif v4039 == 4 then
				local v4045

				v4045, n271 = proto.readBuffer(p410, n271)
				v4037.conversation_id = prop_types.StringProp.decode(v4045)
			elseif v4039 == 5 then
				local v4046

				v4046, n271 = proto.readBuffer(p410, n271)
				v4037.friend_id = prop_types.StringProp.decode(v4046)
			else
				local v4047, v4048 = proto.readVarInt(p410, n271)

				n271 = v4048 + v4047
			end
		elseif v4040 == proto.wireTypes.i32 then
			local v4049

			v4049, n271 = proto.readFixed32(p410, n271)
		elseif v4040 == proto.wireTypes.i64 then
			local v4050

			v4050, n271 = proto.readFixed64(p410, n271)
		else
			error("Unsupported wire type: " .. v4040)
		end
	end

	return v4037
end
function t543.jsonEncode(p411) -- line: 25585
	local t545 = {}

	if p411.modal_action ~= nil then
		t545.modalAction = p411.modal_action:jsonEncode()
	end

	if p411.modal_variant ~= nil then
		t545.modalVariant = p411.modal_variant:jsonEncode()
	end

	if p411.modal_sequence ~= nil then
		t545.modalSequence = p411.modal_sequence:jsonEncode()
	end

	if p411.conversation_id ~= nil then
		t545.conversationId = p411.conversation_id:jsonEncode()
	end

	if p411.friend_id ~= nil then
		t545.friendId = p411.friend_id:jsonEncode()
	end

	return t545
end
function t543.jsonDecode(t546: {[any]: any}) -- line: 25613
	-- upvalues: t543 (copy), prop_types (copy)
	local v4054 = t543.new()

	if t546.modal_action ~= nil then
		v4054.modal_action = prop_types.StringProp.jsonDecode(t546.modal_action)
	end

	if t546.modalAction ~= nil then
		v4054.modal_action = prop_types.StringProp.jsonDecode(t546.modalAction)
	end

	if t546.modal_variant ~= nil then
		v4054.modal_variant = prop_types.StringProp.jsonDecode(t546.modal_variant)
	end

	if t546.modalVariant ~= nil then
		v4054.modal_variant = prop_types.StringProp.jsonDecode(t546.modalVariant)
	end

	if t546.modal_sequence ~= nil then
		v4054.modal_sequence = prop_types.StringProp.jsonDecode(t546.modal_sequence)
	end

	if t546.modalSequence ~= nil then
		v4054.modal_sequence = prop_types.StringProp.jsonDecode(t546.modalSequence)
	end

	if t546.conversation_id ~= nil then
		v4054.conversation_id = prop_types.StringProp.jsonDecode(t546.conversation_id)
	end

	if t546.conversationId ~= nil then
		v4054.conversation_id = prop_types.StringProp.jsonDecode(t546.conversationId)
	end

	if t546.friend_id ~= nil then
		v4054.friend_id = prop_types.StringProp.jsonDecode(t546.friend_id)
	end

	if t546.friendId ~= nil then
		v4054.friend_id = prop_types.StringProp.jsonDecode(t546.friendId)
	end

	return v4054
end

t543.descriptor = {
	name = "RecordPartyChatConversationUpsellAcknowledgementAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.RecordPartyChatConversationUpsellAcknowledgementAction_Params = t543
typeRegistry.default:register(t1.RecordPartyChatConversationUpsellAcknowledgementAction_Params)

local t547 = {}

t547.__index = t547

function t547.new(t548: {[any]: any}?) -- line: 25684
	-- upvalues: t1 (copy), t547 (copy)
	return (setmetatable({
		action_type = if t548 ~= nil and t548.action_type ~= nil then t548.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t548 ~= nil and t548.action_params ~= nil then t548.action_params else nil
	}, t547))
end
function t547.encode(p412) -- line: 25693
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n272 = 0

	if p412.action_type ~= nil and (p412.action_type ~= nil and p412.action_type ~= 0 or p412.action_type ~= t1.ActionType.fromNumber(0)) then
		local v4059, v4060 = proto.writeTag(buf, n272, 1, proto.wireTypes.varint)

		buf, n272 = proto.writeVarInt(v4059, v4060, t1.ActionType.toNumber(p412.action_type))
	end

	if p412.action_params ~= nil then
		local v4061 = p412.action_params:encode()
		local v4062, v4063 = proto.writeTag(buf, n272, 2, proto.wireTypes.lengthDelimited)

		buf, n272 = proto.writeBuffer(v4062, v4063, v4061, buffer.len(v4061))
	end

	local buf139 = buffer.create(n272)

	buffer.copy(buf139, 0, buf, 0, n272)

	return buf139
end
function t547.decode(p413: buffer) -- line: 25719
	-- upvalues: t547 (copy), proto (copy), t1 (copy)
	local v4066 = t547.new()
	local n273 = 0

	while n273 < buffer.len(p413) do
		local v4068, v4069

		v4068, v4069, n273 = proto.readTag(p413, n273)

		if v4069 == proto.wireTypes.varint then
			if v4068 == 1 then
				local v4070

				v4070, n273 = proto.readVarIntI32(p413, n273)
				v4066.action_type = t1.ActionType.fromNumber(v4070) or v4070
			else
				local v4071

				v4071, n273 = proto.readVarInt(p413, n273)
			end
		elseif v4069 == proto.wireTypes.lengthDelimited then
			if v4068 == 2 then
				local v4072

				v4072, n273 = proto.readBuffer(p413, n273)
				v4066.action_params = t1.RequestFriendshipAction_Params.decode(v4072)
			else
				local v4073, v4074 = proto.readVarInt(p413, n273)

				n273 = v4074 + v4073
			end
		elseif v4069 == proto.wireTypes.i32 then
			local v4075

			v4075, n273 = proto.readFixed32(p413, n273)
		elseif v4069 == proto.wireTypes.i64 then
			local v4076

			v4076, n273 = proto.readFixed64(p413, n273)
		else
			error("Unsupported wire type: " .. v4069)
		end
	end

	return v4066
end
function t547.jsonEncode(p414) -- line: 25767
	-- upvalues: t1 (copy)
	local t549 = {}

	if p414.action_type ~= nil and (p414.action_type ~= nil and p414.action_type ~= 0 or p414.action_type ~= t1.ActionType.fromNumber(0)) then
		t549.actionType = if typeof(p414.action_type) ~= "number" then t1.ActionType.toNumber(p414.action_type) else p414.action_type
	end

	if p414.action_params ~= nil then
		t549.actionParams = p414.action_params:jsonEncode()
	end

	return t549
end
function t547.jsonDecode(t550: {[any]: any}) -- line: 25789
	-- upvalues: t547 (copy), t1 (copy)
	local v4080 = t547.new()

	if t550.action_type ~= nil then
		v4080.action_type = if typeof(t550.action_type) ~= "number" then t1.ActionType.fromName(t550.action_type) or t550.action_type else t1.ActionType.fromNumber(t550.action_type) or t550.action_type
	end

	if t550.actionType ~= nil then
		v4080.action_type = if typeof(t550.actionType) ~= "number" then t1.ActionType.fromName(t550.actionType) or t550.actionType else t1.ActionType.fromNumber(t550.actionType) or t550.actionType
	end

	if t550.action_params ~= nil then
		v4080.action_params = t1.RequestFriendshipAction_Params.jsonDecode(t550.action_params)
	end

	if t550.actionParams ~= nil then
		v4080.action_params = t1.RequestFriendshipAction_Params.jsonDecode(t550.actionParams)
	end

	return v4080
end

t547.descriptor = {
	name = "RequestFriendshipAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.RequestFriendshipAction"
}
t1.RequestFriendshipAction = t547
typeRegistry.default:register(t1.RequestFriendshipAction)

local t551 = {}

t551.__index = t551

function t551.new(t552: {[any]: any}?) -- line: 25829
	-- upvalues: t551 (copy)
	return (setmetatable({
		target_user_id = if t552 ~= nil and t552.target_user_id ~= nil then t552.target_user_id else nil,
		source = if t552 ~= nil and t552.source ~= nil then t552.source else nil
	}, t551))
end
function t551.encode(p415) -- line: 25838
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n274 = 0

	if p415.target_user_id ~= nil then
		local v4085 = p415.target_user_id:encode()
		local v4086, v4087 = proto.writeTag(buf, n274, 1, proto.wireTypes.lengthDelimited)

		buf, n274 = proto.writeBuffer(v4086, v4087, v4085, buffer.len(v4085))
	end

	if p415.source ~= nil then
		local v4088 = p415.source:encode()
		local v4089, v4090 = proto.writeTag(buf, n274, 2, proto.wireTypes.lengthDelimited)

		buf, n274 = proto.writeBuffer(v4089, v4090, v4088, buffer.len(v4088))
	end

	local buf140 = buffer.create(n274)

	buffer.copy(buf140, 0, buf, 0, n274)

	return buf140
end
function t551.decode(p416: buffer) -- line: 25859
	-- upvalues: t551 (copy), proto (copy), prop_types (copy)
	local v4093 = t551.new()
	local n275 = 0

	while n275 < buffer.len(p416) do
		local v4095, v4096

		v4095, v4096, n275 = proto.readTag(p416, n275)

		if v4096 == proto.wireTypes.varint then
			local v4097

			v4097, n275 = proto.readVarInt(p416, n275)
		elseif v4096 == proto.wireTypes.lengthDelimited then
			if v4095 == 1 then
				local v4098

				v4098, n275 = proto.readBuffer(p416, n275)
				v4093.target_user_id = prop_types.StringProp.decode(v4098)
			elseif v4095 == 2 then
				local v4099

				v4099, n275 = proto.readBuffer(p416, n275)
				v4093.source = prop_types.StringProp.decode(v4099)
			else
				local v4100, v4101 = proto.readVarInt(p416, n275)

				n275 = v4101 + v4100
			end
		elseif v4096 == proto.wireTypes.i32 then
			local v4102

			v4102, n275 = proto.readFixed32(p416, n275)
		elseif v4096 == proto.wireTypes.i64 then
			local v4103

			v4103, n275 = proto.readFixed64(p416, n275)
		else
			error("Unsupported wire type: " .. v4096)
		end
	end

	return v4093
end
function t551.jsonEncode(p417) -- line: 25907
	local t553 = {}

	if p417.target_user_id ~= nil then
		t553.targetUserId = p417.target_user_id:jsonEncode()
	end

	if p417.source ~= nil then
		t553.source = p417.source:jsonEncode()
	end

	return t553
end
function t551.jsonDecode(t554: {[any]: any}) -- line: 25921
	-- upvalues: t551 (copy), prop_types (copy)
	local v4107 = t551.new()

	if t554.target_user_id ~= nil then
		v4107.target_user_id = prop_types.StringProp.jsonDecode(t554.target_user_id)
	end

	if t554.targetUserId ~= nil then
		v4107.target_user_id = prop_types.StringProp.jsonDecode(t554.targetUserId)
	end

	if t554.source ~= nil then
		v4107.source = prop_types.StringProp.jsonDecode(t554.source)
	end

	return v4107
end

t551.descriptor = {
	name = "RequestFriendshipAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.RequestFriendshipAction_Params = t551
typeRegistry.default:register(t1.RequestFriendshipAction_Params)

local t555 = {}

t555.__index = t555

function t555.new(t556: {[any]: any}?) -- line: 25955
	-- upvalues: t1 (copy), t555 (copy)
	return (setmetatable({
		action_type = if t556 ~= nil and t556.action_type ~= nil then t556.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t556 ~= nil and t556.action_params ~= nil then t556.action_params else nil
	}, t555))
end
function t555.encode(p418) -- line: 25966
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n276 = 0

	if p418.action_type ~= nil and (p418.action_type ~= nil and p418.action_type ~= 0 or p418.action_type ~= t1.ActionType.fromNumber(0)) then
		local v4112, v4113 = proto.writeTag(buf, n276, 1, proto.wireTypes.varint)

		buf, n276 = proto.writeVarInt(v4112, v4113, t1.ActionType.toNumber(p418.action_type))
	end

	if p418.action_params ~= nil then
		local v4114 = p418.action_params:encode()
		local v4115, v4116 = proto.writeTag(buf, n276, 2, proto.wireTypes.lengthDelimited)

		buf, n276 = proto.writeBuffer(v4115, v4116, v4114, buffer.len(v4114))
	end

	local buf141 = buffer.create(n276)

	buffer.copy(buf141, 0, buf, 0, n276)

	return buf141
end
function t555.decode(p419: buffer) -- line: 25992
	-- upvalues: t555 (copy), proto (copy), t1 (copy)
	local v4119 = t555.new()
	local n277 = 0

	while n277 < buffer.len(p419) do
		local v4121, v4122

		v4121, v4122, n277 = proto.readTag(p419, n277)

		if v4122 == proto.wireTypes.varint then
			if v4121 == 1 then
				local v4123

				v4123, n277 = proto.readVarIntI32(p419, n277)
				v4119.action_type = t1.ActionType.fromNumber(v4123) or v4123
			else
				local v4124

				v4124, n277 = proto.readVarInt(p419, n277)
			end
		elseif v4122 == proto.wireTypes.lengthDelimited then
			if v4121 == 2 then
				local v4125

				v4125, n277 = proto.readBuffer(p419, n277)
				v4119.action_params = t1.OpenTrustedFriendsUpsellModalAction_Params.decode(v4125)
			else
				local v4126, v4127 = proto.readVarInt(p419, n277)

				n277 = v4127 + v4126
			end
		elseif v4122 == proto.wireTypes.i32 then
			local v4128

			v4128, n277 = proto.readFixed32(p419, n277)
		elseif v4122 == proto.wireTypes.i64 then
			local v4129

			v4129, n277 = proto.readFixed64(p419, n277)
		else
			error("Unsupported wire type: " .. v4122)
		end
	end

	return v4119
end
function t555.jsonEncode(p420) -- line: 26040
	-- upvalues: t1 (copy)
	local t557 = {}

	if p420.action_type ~= nil and (p420.action_type ~= nil and p420.action_type ~= 0 or p420.action_type ~= t1.ActionType.fromNumber(0)) then
		t557.actionType = if typeof(p420.action_type) ~= "number" then t1.ActionType.toNumber(p420.action_type) else p420.action_type
	end

	if p420.action_params ~= nil then
		t557.actionParams = p420.action_params:jsonEncode()
	end

	return t557
end
function t555.jsonDecode(t558: {[any]: any}) -- line: 26062
	-- upvalues: t555 (copy), t1 (copy)
	local v4133 = t555.new()

	if t558.action_type ~= nil then
		v4133.action_type = if typeof(t558.action_type) ~= "number" then t1.ActionType.fromName(t558.action_type) or t558.action_type else t1.ActionType.fromNumber(t558.action_type) or t558.action_type
	end

	if t558.actionType ~= nil then
		v4133.action_type = if typeof(t558.actionType) ~= "number" then t1.ActionType.fromName(t558.actionType) or t558.actionType else t1.ActionType.fromNumber(t558.actionType) or t558.actionType
	end

	if t558.action_params ~= nil then
		v4133.action_params = t1.OpenTrustedFriendsUpsellModalAction_Params.jsonDecode(t558.action_params)
	end

	if t558.actionParams ~= nil then
		v4133.action_params = t1.OpenTrustedFriendsUpsellModalAction_Params.jsonDecode(t558.actionParams)
	end

	return v4133
end

t555.descriptor = {
	name = "OpenTrustedFriendsUpsellModalAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.OpenTrustedFriendsUpsellModalAction"
}
t1.OpenTrustedFriendsUpsellModalAction = t555
typeRegistry.default:register(t1.OpenTrustedFriendsUpsellModalAction)

local t559 = {}

t559.__index = t559

function t559.new(t560: {[any]: any}?) -- line: 26104
	-- upvalues: t559 (copy)
	return (setmetatable({
		target_user_id = if t560 ~= nil and t560.target_user_id ~= nil then t560.target_user_id else nil
	}, t559))
end
function t559.encode(p421) -- line: 26112
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n278 = 0

	if p421.target_user_id ~= nil then
		local v4138 = p421.target_user_id:encode()
		local v4139, v4140 = proto.writeTag(buf, n278, 1, proto.wireTypes.lengthDelimited)

		buf, n278 = proto.writeBuffer(v4139, v4140, v4138, buffer.len(v4138))
	end

	local buf142 = buffer.create(n278)

	buffer.copy(buf142, 0, buf, 0, n278)

	return buf142
end
function t559.decode(p422: buffer) -- line: 26129
	-- upvalues: t559 (copy), proto (copy), prop_types (copy)
	local v4143 = t559.new()
	local n279 = 0

	while n279 < buffer.len(p422) do
		local v4145, v4146

		v4145, v4146, n279 = proto.readTag(p422, n279)

		if v4146 == proto.wireTypes.varint then
			local v4147

			v4147, n279 = proto.readVarInt(p422, n279)
		elseif v4146 == proto.wireTypes.lengthDelimited then
			if v4145 == 1 then
				local v4148

				v4148, n279 = proto.readBuffer(p422, n279)
				v4143.target_user_id = prop_types.StringProp.decode(v4148)
			else
				local v4149, v4150 = proto.readVarInt(p422, n279)

				n279 = v4150 + v4149
			end
		elseif v4146 == proto.wireTypes.i32 then
			local v4151

			v4151, n279 = proto.readFixed32(p422, n279)
		elseif v4146 == proto.wireTypes.i64 then
			local v4152

			v4152, n279 = proto.readFixed64(p422, n279)
		else
			error("Unsupported wire type: " .. v4146)
		end
	end

	return v4143
end
function t559.jsonEncode(p423) -- line: 26174
	local t561 = {}

	if p423.target_user_id ~= nil then
		t561.targetUserId = p423.target_user_id:jsonEncode()
	end

	return t561
end
function t559.jsonDecode(t562: {[any]: any}) -- line: 26186
	-- upvalues: t559 (copy), prop_types (copy)
	local v4156 = t559.new()

	if t562.target_user_id ~= nil then
		v4156.target_user_id = prop_types.StringProp.jsonDecode(t562.target_user_id)
	end

	if t562.targetUserId ~= nil then
		v4156.target_user_id = prop_types.StringProp.jsonDecode(t562.targetUserId)
	end

	return v4156
end

t559.descriptor = {
	name = "OpenTrustedFriendsUpsellModalAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.OpenTrustedFriendsUpsellModalAction_Params = t559
typeRegistry.default:register(t1.OpenTrustedFriendsUpsellModalAction_Params)

local t563 = {}

t563.__index = t563

function t563.new(t564: {[any]: any}?) -- line: 26218
	-- upvalues: t1 (copy), t563 (copy)
	return (setmetatable({
		action_type = if t564 ~= nil and t564.action_type ~= nil then t564.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t564 ~= nil and t564.action_params ~= nil then t564.action_params else nil
	}, t563))
end
function t563.encode(p424) -- line: 26229
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n280 = 0

	if p424.action_type ~= nil and (p424.action_type ~= nil and p424.action_type ~= 0 or p424.action_type ~= t1.ActionType.fromNumber(0)) then
		local v4161, v4162 = proto.writeTag(buf, n280, 1, proto.wireTypes.varint)

		buf, n280 = proto.writeVarInt(v4161, v4162, t1.ActionType.toNumber(p424.action_type))
	end

	if p424.action_params ~= nil then
		local v4163 = p424.action_params:encode()
		local v4164, v4165 = proto.writeTag(buf, n280, 2, proto.wireTypes.lengthDelimited)

		buf, n280 = proto.writeBuffer(v4164, v4165, v4163, buffer.len(v4163))
	end

	local buf143 = buffer.create(n280)

	buffer.copy(buf143, 0, buf, 0, n280)

	return buf143
end
function t563.decode(p425: buffer) -- line: 26255
	-- upvalues: t563 (copy), proto (copy), t1 (copy)
	local v4168 = t563.new()
	local n281 = 0

	while n281 < buffer.len(p425) do
		local v4170, v4171

		v4170, v4171, n281 = proto.readTag(p425, n281)

		if v4171 == proto.wireTypes.varint then
			if v4170 == 1 then
				local v4172

				v4172, n281 = proto.readVarIntI32(p425, n281)
				v4168.action_type = t1.ActionType.fromNumber(v4172) or v4172
			else
				local v4173

				v4173, n281 = proto.readVarInt(p425, n281)
			end
		elseif v4171 == proto.wireTypes.lengthDelimited then
			if v4170 == 2 then
				local v4174

				v4174, n281 = proto.readBuffer(p425, n281)
				v4168.action_params = t1.OpenSearchResultsWithQueryAction_Params.decode(v4174)
			else
				local v4175, v4176 = proto.readVarInt(p425, n281)

				n281 = v4176 + v4175
			end
		elseif v4171 == proto.wireTypes.i32 then
			local v4177

			v4177, n281 = proto.readFixed32(p425, n281)
		elseif v4171 == proto.wireTypes.i64 then
			local v4178

			v4178, n281 = proto.readFixed64(p425, n281)
		else
			error("Unsupported wire type: " .. v4171)
		end
	end

	return v4168
end
function t563.jsonEncode(p426) -- line: 26303
	-- upvalues: t1 (copy)
	local t565 = {}

	if p426.action_type ~= nil and (p426.action_type ~= nil and p426.action_type ~= 0 or p426.action_type ~= t1.ActionType.fromNumber(0)) then
		t565.actionType = if typeof(p426.action_type) ~= "number" then t1.ActionType.toNumber(p426.action_type) else p426.action_type
	end

	if p426.action_params ~= nil then
		t565.actionParams = p426.action_params:jsonEncode()
	end

	return t565
end
function t563.jsonDecode(t566: {[any]: any}) -- line: 26325
	-- upvalues: t563 (copy), t1 (copy)
	local v4182 = t563.new()

	if t566.action_type ~= nil then
		v4182.action_type = if typeof(t566.action_type) ~= "number" then t1.ActionType.fromName(t566.action_type) or t566.action_type else t1.ActionType.fromNumber(t566.action_type) or t566.action_type
	end

	if t566.actionType ~= nil then
		v4182.action_type = if typeof(t566.actionType) ~= "number" then t1.ActionType.fromName(t566.actionType) or t566.actionType else t1.ActionType.fromNumber(t566.actionType) or t566.actionType
	end

	if t566.action_params ~= nil then
		v4182.action_params = t1.OpenSearchResultsWithQueryAction_Params.jsonDecode(t566.action_params)
	end

	if t566.actionParams ~= nil then
		v4182.action_params = t1.OpenSearchResultsWithQueryAction_Params.jsonDecode(t566.actionParams)
	end

	return v4182
end

t563.descriptor = {
	name = "OpenSearchResultsWithQueryAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.OpenSearchResultsWithQueryAction"
}
t1.OpenSearchResultsWithQueryAction = t563
typeRegistry.default:register(t1.OpenSearchResultsWithQueryAction)

local t567 = {}

t567.__index = t567

function t567.new(t568: {[any]: any}?) -- line: 26367
	-- upvalues: t567 (copy)
	return (setmetatable({
		search_query = if t568 ~= nil and t568.search_query ~= nil then t568.search_query else nil,
		search_type = if t568 ~= nil and t568.search_type ~= nil then t568.search_type else nil
	}, t567))
end
function t567.encode(p427) -- line: 26376
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n282 = 0

	if p427.search_query ~= nil then
		local v4187 = p427.search_query:encode()
		local v4188, v4189 = proto.writeTag(buf, n282, 1, proto.wireTypes.lengthDelimited)

		buf, n282 = proto.writeBuffer(v4188, v4189, v4187, buffer.len(v4187))
	end

	if p427.search_type ~= nil then
		local v4190 = p427.search_type:encode()
		local v4191, v4192 = proto.writeTag(buf, n282, 2, proto.wireTypes.lengthDelimited)

		buf, n282 = proto.writeBuffer(v4191, v4192, v4190, buffer.len(v4190))
	end

	local buf144 = buffer.create(n282)

	buffer.copy(buf144, 0, buf, 0, n282)

	return buf144
end
function t567.decode(p428: buffer) -- line: 26397
	-- upvalues: t567 (copy), proto (copy), prop_types (copy)
	local v4195 = t567.new()
	local n283 = 0

	while n283 < buffer.len(p428) do
		local v4197, v4198

		v4197, v4198, n283 = proto.readTag(p428, n283)

		if v4198 == proto.wireTypes.varint then
			local v4199

			v4199, n283 = proto.readVarInt(p428, n283)
		elseif v4198 == proto.wireTypes.lengthDelimited then
			if v4197 == 1 then
				local v4200

				v4200, n283 = proto.readBuffer(p428, n283)
				v4195.search_query = prop_types.StringProp.decode(v4200)
			elseif v4197 == 2 then
				local v4201

				v4201, n283 = proto.readBuffer(p428, n283)
				v4195.search_type = prop_types.StringProp.decode(v4201)
			else
				local v4202, v4203 = proto.readVarInt(p428, n283)

				n283 = v4203 + v4202
			end
		elseif v4198 == proto.wireTypes.i32 then
			local v4204

			v4204, n283 = proto.readFixed32(p428, n283)
		elseif v4198 == proto.wireTypes.i64 then
			local v4205

			v4205, n283 = proto.readFixed64(p428, n283)
		else
			error("Unsupported wire type: " .. v4198)
		end
	end

	return v4195
end
function t567.jsonEncode(p429) -- line: 26445
	local t569 = {}

	if p429.search_query ~= nil then
		t569.searchQuery = p429.search_query:jsonEncode()
	end

	if p429.search_type ~= nil then
		t569.searchType = p429.search_type:jsonEncode()
	end

	return t569
end
function t567.jsonDecode(t570: {[any]: any}) -- line: 26459
	-- upvalues: t567 (copy), prop_types (copy)
	local v4209 = t567.new()

	if t570.search_query ~= nil then
		v4209.search_query = prop_types.StringProp.jsonDecode(t570.search_query)
	end

	if t570.searchQuery ~= nil then
		v4209.search_query = prop_types.StringProp.jsonDecode(t570.searchQuery)
	end

	if t570.search_type ~= nil then
		v4209.search_type = prop_types.StringProp.jsonDecode(t570.search_type)
	end

	if t570.searchType ~= nil then
		v4209.search_type = prop_types.StringProp.jsonDecode(t570.searchType)
	end

	return v4209
end

t567.descriptor = {
	name = "OpenSearchResultsWithQueryAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.OpenSearchResultsWithQueryAction_Params = t567
typeRegistry.default:register(t1.OpenSearchResultsWithQueryAction_Params)

local t571 = {}

t571.__index = t571

function t571.new(t572: {[any]: any}?) -- line: 26500
	-- upvalues: t1 (copy), t571 (copy)
	return (setmetatable({
		action_type = if t572 ~= nil and t572.action_type ~= nil then t572.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t572 ~= nil and t572.action_params ~= nil then t572.action_params else nil
	}, t571))
end
function t571.encode(p430) -- line: 26511
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n284 = 0

	if p430.action_type ~= nil and (p430.action_type ~= nil and p430.action_type ~= 0 or p430.action_type ~= t1.ActionType.fromNumber(0)) then
		local v4214, v4215 = proto.writeTag(buf, n284, 1, proto.wireTypes.varint)

		buf, n284 = proto.writeVarInt(v4214, v4215, t1.ActionType.toNumber(p430.action_type))
	end

	if p430.action_params ~= nil then
		local v4216 = p430.action_params:encode()
		local v4217, v4218 = proto.writeTag(buf, n284, 2, proto.wireTypes.lengthDelimited)

		buf, n284 = proto.writeBuffer(v4217, v4218, v4216, buffer.len(v4216))
	end

	local buf145 = buffer.create(n284)

	buffer.copy(buf145, 0, buf, 0, n284)

	return buf145
end
function t571.decode(p431: buffer) -- line: 26537
	-- upvalues: t571 (copy), proto (copy), t1 (copy)
	local v4221 = t571.new()
	local n285 = 0

	while n285 < buffer.len(p431) do
		local v4223, v4224

		v4223, v4224, n285 = proto.readTag(p431, n285)

		if v4224 == proto.wireTypes.varint then
			if v4223 == 1 then
				local v4225

				v4225, n285 = proto.readVarIntI32(p431, n285)
				v4221.action_type = t1.ActionType.fromNumber(v4225) or v4225
			else
				local v4226

				v4226, n285 = proto.readVarInt(p431, n285)
			end
		elseif v4224 == proto.wireTypes.lengthDelimited then
			if v4223 == 2 then
				local v4227

				v4227, n285 = proto.readBuffer(p431, n285)
				v4221.action_params = t1.SelectMarketplaceFavoritesCategory_Params.decode(v4227)
			else
				local v4228, v4229 = proto.readVarInt(p431, n285)

				n285 = v4229 + v4228
			end
		elseif v4224 == proto.wireTypes.i32 then
			local v4230

			v4230, n285 = proto.readFixed32(p431, n285)
		elseif v4224 == proto.wireTypes.i64 then
			local v4231

			v4231, n285 = proto.readFixed64(p431, n285)
		else
			error("Unsupported wire type: " .. v4224)
		end
	end

	return v4221
end
function t571.jsonEncode(p432) -- line: 26585
	-- upvalues: t1 (copy)
	local t573 = {}

	if p432.action_type ~= nil and (p432.action_type ~= nil and p432.action_type ~= 0 or p432.action_type ~= t1.ActionType.fromNumber(0)) then
		t573.actionType = if typeof(p432.action_type) ~= "number" then t1.ActionType.toNumber(p432.action_type) else p432.action_type
	end

	if p432.action_params ~= nil then
		t573.actionParams = p432.action_params:jsonEncode()
	end

	return t573
end
function t571.jsonDecode(t574: {[any]: any}) -- line: 26607
	-- upvalues: t571 (copy), t1 (copy)
	local v4235 = t571.new()

	if t574.action_type ~= nil then
		v4235.action_type = if typeof(t574.action_type) ~= "number" then t1.ActionType.fromName(t574.action_type) or t574.action_type else t1.ActionType.fromNumber(t574.action_type) or t574.action_type
	end

	if t574.actionType ~= nil then
		v4235.action_type = if typeof(t574.actionType) ~= "number" then t1.ActionType.fromName(t574.actionType) or t574.actionType else t1.ActionType.fromNumber(t574.actionType) or t574.actionType
	end

	if t574.action_params ~= nil then
		v4235.action_params = t1.SelectMarketplaceFavoritesCategory_Params.jsonDecode(t574.action_params)
	end

	if t574.actionParams ~= nil then
		v4235.action_params = t1.SelectMarketplaceFavoritesCategory_Params.jsonDecode(t574.actionParams)
	end

	return v4235
end

t571.descriptor = {
	name = "SelectMarketplaceFavoritesCategory",
	fullName = "roblox.apppageplatform.shared.v1beta1.SelectMarketplaceFavoritesCategory"
}
t1.SelectMarketplaceFavoritesCategory = t571
typeRegistry.default:register(t1.SelectMarketplaceFavoritesCategory)

local t575 = {}

t575.__index = t575

function t575.new(t576: {[any]: any}?) -- line: 26649
	-- upvalues: t575 (copy)
	return (setmetatable({
		category_id = if t576 ~= nil and t576.category_id ~= nil then t576.category_id else nil
	}, t575))
end
function t575.encode(p433) -- line: 26657
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n286 = 0

	if p433.category_id ~= nil then
		local v4240 = p433.category_id:encode()
		local v4241, v4242 = proto.writeTag(buf, n286, 1, proto.wireTypes.lengthDelimited)

		buf, n286 = proto.writeBuffer(v4241, v4242, v4240, buffer.len(v4240))
	end

	local buf146 = buffer.create(n286)

	buffer.copy(buf146, 0, buf, 0, n286)

	return buf146
end
function t575.decode(p434: buffer) -- line: 26674
	-- upvalues: t575 (copy), proto (copy), prop_types (copy)
	local v4245 = t575.new()
	local n287 = 0

	while n287 < buffer.len(p434) do
		local v4247, v4248

		v4247, v4248, n287 = proto.readTag(p434, n287)

		if v4248 == proto.wireTypes.varint then
			local v4249

			v4249, n287 = proto.readVarInt(p434, n287)
		elseif v4248 == proto.wireTypes.lengthDelimited then
			if v4247 == 1 then
				local v4250

				v4250, n287 = proto.readBuffer(p434, n287)
				v4245.category_id = prop_types.StringProp.decode(v4250)
			else
				local v4251, v4252 = proto.readVarInt(p434, n287)

				n287 = v4252 + v4251
			end
		elseif v4248 == proto.wireTypes.i32 then
			local v4253

			v4253, n287 = proto.readFixed32(p434, n287)
		elseif v4248 == proto.wireTypes.i64 then
			local v4254

			v4254, n287 = proto.readFixed64(p434, n287)
		else
			error("Unsupported wire type: " .. v4248)
		end
	end

	return v4245
end
function t575.jsonEncode(p435) -- line: 26719
	local t577 = {}

	if p435.category_id ~= nil then
		t577.categoryId = p435.category_id:jsonEncode()
	end

	return t577
end
function t575.jsonDecode(t578: {[any]: any}) -- line: 26731
	-- upvalues: t575 (copy), prop_types (copy)
	local v4258 = t575.new()

	if t578.category_id ~= nil then
		v4258.category_id = prop_types.StringProp.jsonDecode(t578.category_id)
	end

	if t578.categoryId ~= nil then
		v4258.category_id = prop_types.StringProp.jsonDecode(t578.categoryId)
	end

	return v4258
end

t575.descriptor = {
	name = "SelectMarketplaceFavoritesCategory_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.SelectMarketplaceFavoritesCategory_Params = t575
typeRegistry.default:register(t1.SelectMarketplaceFavoritesCategory_Params)

local t579 = {}

t579.__index = t579

function t579.new(t580: {[any]: any}?) -- line: 26762
	-- upvalues: t1 (copy), t579 (copy)
	return (setmetatable({
		action_type = if t580 ~= nil and t580.action_type ~= nil then t580.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
		action_params = if t580 ~= nil and t580.action_params ~= nil then t580.action_params else nil
	}, t579))
end
function t579.encode(p436) -- line: 26771
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n288 = 0

	if p436.action_type ~= nil and (p436.action_type ~= nil and p436.action_type ~= 0 or p436.action_type ~= t1.ActionType.fromNumber(0)) then
		local v4263, v4264 = proto.writeTag(buf, n288, 1, proto.wireTypes.varint)

		buf, n288 = proto.writeVarInt(v4263, v4264, t1.ActionType.toNumber(p436.action_type))
	end

	if p436.action_params ~= nil then
		local v4265 = p436.action_params:encode()
		local v4266, v4267 = proto.writeTag(buf, n288, 2, proto.wireTypes.lengthDelimited)

		buf, n288 = proto.writeBuffer(v4266, v4267, v4265, buffer.len(v4265))
	end

	local buf147 = buffer.create(n288)

	buffer.copy(buf147, 0, buf, 0, n288)

	return buf147
end
function t579.decode(p437: buffer) -- line: 26797
	-- upvalues: t579 (copy), proto (copy), t1 (copy)
	local v4270 = t579.new()
	local n289 = 0

	while n289 < buffer.len(p437) do
		local v4272, v4273

		v4272, v4273, n289 = proto.readTag(p437, n289)

		if v4273 == proto.wireTypes.varint then
			if v4272 == 1 then
				local v4274

				v4274, n289 = proto.readVarIntI32(p437, n289)
				v4270.action_type = t1.ActionType.fromNumber(v4274) or v4274
			else
				local v4275

				v4275, n289 = proto.readVarInt(p437, n289)
			end
		elseif v4273 == proto.wireTypes.lengthDelimited then
			if v4272 == 2 then
				local v4276

				v4276, n289 = proto.readBuffer(p437, n289)
				v4270.action_params = t1.DownloadAppAction_Params.decode(v4276)
			else
				local v4277, v4278 = proto.readVarInt(p437, n289)

				n289 = v4278 + v4277
			end
		elseif v4273 == proto.wireTypes.i32 then
			local v4279

			v4279, n289 = proto.readFixed32(p437, n289)
		elseif v4273 == proto.wireTypes.i64 then
			local v4280

			v4280, n289 = proto.readFixed64(p437, n289)
		else
			error("Unsupported wire type: " .. v4273)
		end
	end

	return v4270
end
function t579.jsonEncode(p438) -- line: 26845
	-- upvalues: t1 (copy)
	local t581 = {}

	if p438.action_type ~= nil and (p438.action_type ~= nil and p438.action_type ~= 0 or p438.action_type ~= t1.ActionType.fromNumber(0)) then
		t581.actionType = if typeof(p438.action_type) ~= "number" then t1.ActionType.toNumber(p438.action_type) else p438.action_type
	end

	if p438.action_params ~= nil then
		t581.actionParams = p438.action_params:jsonEncode()
	end

	return t581
end
function t579.jsonDecode(t582: {[any]: any}) -- line: 26867
	-- upvalues: t579 (copy), t1 (copy)
	local v4284 = t579.new()

	if t582.action_type ~= nil then
		v4284.action_type = if typeof(t582.action_type) ~= "number" then t1.ActionType.fromName(t582.action_type) or t582.action_type else t1.ActionType.fromNumber(t582.action_type) or t582.action_type
	end

	if t582.actionType ~= nil then
		v4284.action_type = if typeof(t582.actionType) ~= "number" then t1.ActionType.fromName(t582.actionType) or t582.actionType else t1.ActionType.fromNumber(t582.actionType) or t582.actionType
	end

	if t582.action_params ~= nil then
		v4284.action_params = t1.DownloadAppAction_Params.jsonDecode(t582.action_params)
	end

	if t582.actionParams ~= nil then
		v4284.action_params = t1.DownloadAppAction_Params.jsonDecode(t582.actionParams)
	end

	return v4284
end

t579.descriptor = {
	name = "DownloadAppAction",
	fullName = "roblox.apppageplatform.shared.v1beta1.DownloadAppAction"
}
t1.DownloadAppAction = t579
typeRegistry.default:register(t1.DownloadAppAction)

local t583 = {}

t583.__index = t583

function t583.new(t584: {[any]: any}?) -- line: 26907
	-- upvalues: t583 (copy)
	return (setmetatable({
		source = if t584 ~= nil and t584.source ~= nil then t584.source else nil,
		download_type = if t584 ~= nil and t584.download_type ~= nil then t584.download_type else nil
	}, t583))
end
function t583.encode(p439) -- line: 26914
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n290 = 0

	if p439.source ~= nil then
		local v4289 = p439.source:encode()
		local v4290, v4291 = proto.writeTag(buf, n290, 1, proto.wireTypes.lengthDelimited)

		buf, n290 = proto.writeBuffer(v4290, v4291, v4289, buffer.len(v4289))
	end

	if p439.download_type ~= nil then
		local v4292 = p439.download_type:encode()
		local v4293, v4294 = proto.writeTag(buf, n290, 2, proto.wireTypes.lengthDelimited)

		buf, n290 = proto.writeBuffer(v4293, v4294, v4292, buffer.len(v4292))
	end

	local buf148 = buffer.create(n290)

	buffer.copy(buf148, 0, buf, 0, n290)

	return buf148
end
function t583.decode(p440: buffer) -- line: 26935
	-- upvalues: t583 (copy), proto (copy), prop_types (copy)
	local v4297 = t583.new()
	local n291 = 0

	while n291 < buffer.len(p440) do
		local v4299, v4300

		v4299, v4300, n291 = proto.readTag(p440, n291)

		if v4300 == proto.wireTypes.varint then
			local v4301

			v4301, n291 = proto.readVarInt(p440, n291)
		elseif v4300 == proto.wireTypes.lengthDelimited then
			if v4299 == 1 then
				local v4302

				v4302, n291 = proto.readBuffer(p440, n291)
				v4297.source = prop_types.StringProp.decode(v4302)
			elseif v4299 == 2 then
				local v4303

				v4303, n291 = proto.readBuffer(p440, n291)
				v4297.download_type = prop_types.StringProp.decode(v4303)
			else
				local v4304, v4305 = proto.readVarInt(p440, n291)

				n291 = v4305 + v4304
			end
		elseif v4300 == proto.wireTypes.i32 then
			local v4306

			v4306, n291 = proto.readFixed32(p440, n291)
		elseif v4300 == proto.wireTypes.i64 then
			local v4307

			v4307, n291 = proto.readFixed64(p440, n291)
		else
			error("Unsupported wire type: " .. v4300)
		end
	end

	return v4297
end
function t583.jsonEncode(p441) -- line: 26983
	local t585 = {}

	if p441.source ~= nil then
		t585.source = p441.source:jsonEncode()
	end

	if p441.download_type ~= nil then
		t585.downloadType = p441.download_type:jsonEncode()
	end

	return t585
end
function t583.jsonDecode(t586: {[any]: any}) -- line: 26997
	-- upvalues: t583 (copy), prop_types (copy)
	local v4311 = t583.new()

	if t586.source ~= nil then
		v4311.source = prop_types.StringProp.jsonDecode(t586.source)
	end

	if t586.download_type ~= nil then
		v4311.download_type = prop_types.StringProp.jsonDecode(t586.download_type)
	end

	if t586.downloadType ~= nil then
		v4311.download_type = prop_types.StringProp.jsonDecode(t586.downloadType)
	end

	return v4311
end

t583.descriptor = {
	name = "DownloadAppAction_Params",
	fullName = "roblox.apppageplatform.shared.v1beta1.Params"
}
t1.DownloadAppAction_Params = t583
typeRegistry.default:register(t1.DownloadAppAction_Params)

local t587 = {}

t587.__index = t587

function t587.new(t588: {[any]: any}?) -- line: 27031
	-- upvalues: t587 (copy)
	return (setmetatable({
		kind = if t588 ~= nil and t588.kind ~= nil then t588.kind else nil,
		telemetry_handler = if t588 ~= nil and t588.telemetry_handler ~= nil then t588.telemetry_handler else nil,
		accessibility_label = if t588 ~= nil and t588.accessibility_label ~= nil then t588.accessibility_label else nil
	}, t587))
end
function t587.encode(p442) -- line: 27041
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n292 = 0

	if p442.kind ~= nil then
		if p442.kind.type == "dismiss_dialog_action" then
			local v4316 = p442.kind.value:encode()
			local v4317, v4318 = proto.writeTag(buf, n292, 1, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4317, v4318, v4316, buffer.len(v4316))
		elseif p442.kind.type == "link_action" then
			local v4319 = p442.kind.value:encode()
			local v4320, v4321 = proto.writeTag(buf, n292, 2, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4320, v4321, v4319, buffer.len(v4319))
		elseif p442.kind.type == "open_game_details_action" then
			local v4322 = p442.kind.value:encode()
			local v4323, v4324 = proto.writeTag(buf, n292, 3, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4323, v4324, v4322, buffer.len(v4322))
		elseif p442.kind.type == "open_join_friends_action" then
			local v4325 = p442.kind.value:encode()
			local v4326, v4327 = proto.writeTag(buf, n292, 4, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4326, v4327, v4325, buffer.len(v4325))
		elseif p442.kind.type == "open_marketplace_try_on_action" then
			local v4328 = p442.kind.value:encode()
			local v4329, v4330 = proto.writeTag(buf, n292, 5, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4329, v4330, v4328, buffer.len(v4328))
		elseif p442.kind.type == "open_see_all_action" then
			local v4331 = p442.kind.value:encode()
			local v4332, v4333 = proto.writeTag(buf, n292, 6, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4332, v4333, v4331, buffer.len(v4331))
		elseif p442.kind.type == "open_sponsored_tooltip_action" then
			local v4334 = p442.kind.value:encode()
			local v4335, v4336 = proto.writeTag(buf, n292, 7, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4335, v4336, v4334, buffer.len(v4334))
		elseif p442.kind.type == "play_button_click_action" then
			local v4337 = p442.kind.value:encode()
			local v4338, v4339 = proto.writeTag(buf, n292, 8, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4338, v4339, v4337, buffer.len(v4337))
		elseif p442.kind.type == "update_user_settings_action" then
			local v4340 = p442.kind.value:encode()
			local v4341, v4342 = proto.writeTag(buf, n292, 9, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4341, v4342, v4340, buffer.len(v4340))
		elseif p442.kind.type == "open_tooltip_action" then
			local v4343 = p442.kind.value:encode()
			local v4344, v4345 = proto.writeTag(buf, n292, 10, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4344, v4345, v4343, buffer.len(v4343))
		elseif p442.kind.type == "open_badge_details_action" then
			local v4346 = p442.kind.value:encode()
			local v4347, v4348 = proto.writeTag(buf, n292, 11, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4347, v4348, v4346, buffer.len(v4346))
		elseif p442.kind.type == "load_more_from_api_action" then
			local v4349 = p442.kind.value:encode()
			local v4350, v4351 = proto.writeTag(buf, n292, 12, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4350, v4351, v4349, buffer.len(v4349))
		elseif p442.kind.type == "share_action" then
			local v4352 = p442.kind.value:encode()
			local v4353, v4354 = proto.writeTag(buf, n292, 13, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4353, v4354, v4352, buffer.len(v4352))
		elseif p442.kind.type == "open_abuse_report_action" then
			local v4355 = p442.kind.value:encode()
			local v4356, v4357 = proto.writeTag(buf, n292, 14, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4356, v4357, v4355, buffer.len(v4355))
		elseif p442.kind.type == "remove_badge_from_inventory_action" then
			local v4358 = p442.kind.value:encode()
			local v4359, v4360 = proto.writeTag(buf, n292, 15, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4359, v4360, v4358, buffer.len(v4358))
		elseif p442.kind.type == "open_profile_action" then
			local v4361 = p442.kind.value:encode()
			local v4362, v4363 = proto.writeTag(buf, n292, 16, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4362, v4363, v4361, buffer.len(v4361))
		elseif p442.kind.type == "open_facial_age_estimation_action" then
			local v4364 = p442.kind.value:encode()
			local v4365, v4366 = proto.writeTag(buf, n292, 17, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4365, v4366, v4364, buffer.len(v4364))
		elseif p442.kind.type == "open_add_connections_page_action" then
			local v4367 = p442.kind.value:encode()
			local v4368, v4369 = proto.writeTag(buf, n292, 18, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4368, v4369, v4367, buffer.len(v4367))
		elseif p442.kind.type == "open_marketplace_action" then
			local v4370 = p442.kind.value:encode()
			local v4371, v4372 = proto.writeTag(buf, n292, 19, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4371, v4372, v4370, buffer.len(v4370))
		elseif p442.kind.type == "hide_profile_completion_action" then
			local v4373 = p442.kind.value:encode()
			local v4374, v4375 = proto.writeTag(buf, n292, 20, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4374, v4375, v4373, buffer.len(v4373))
		elseif p442.kind.type == "select_marketplace_catalog_category" then
			local v4376 = p442.kind.value:encode()
			local v4377, v4378 = proto.writeTag(buf, n292, 21, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4377, v4378, v4376, buffer.len(v4376))
		elseif p442.kind.type == "select_marketplace_catalog_subcategory" then
			local v4379 = p442.kind.value:encode()
			local v4380, v4381 = proto.writeTag(buf, n292, 22, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4380, v4381, v4379, buffer.len(v4379))
		elseif p442.kind.type == "open_marketplace_catalog_see_all" then
			local v4382 = p442.kind.value:encode()
			local v4383, v4384 = proto.writeTag(buf, n292, 23, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4383, v4384, v4382, buffer.len(v4382))
		elseif p442.kind.type == "close_marketplace_category_tooltip" then
			local v4385 = p442.kind.value:encode()
			local v4386, v4387 = proto.writeTag(buf, n292, 24, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4386, v4387, v4385, buffer.len(v4385))
		elseif p442.kind.type == "resize_marketplace_catalog" then
			local v4388 = p442.kind.value:encode()
			local v4389, v4390 = proto.writeTag(buf, n292, 25, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4389, v4390, v4388, buffer.len(v4388))
		elseif p442.kind.type == "open_marketplace_catalog_filters" then
			local v4391 = p442.kind.value:encode()
			local v4392, v4393 = proto.writeTag(buf, n292, 26, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4392, v4393, v4391, buffer.len(v4391))
		elseif p442.kind.type == "open_social_link_action" then
			local v4394 = p442.kind.value:encode()
			local v4395, v4396 = proto.writeTag(buf, n292, 27, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4395, v4396, v4394, buffer.len(v4394))
		elseif p442.kind.type == "open_charts_sort_detail_action" then
			local v4397 = p442.kind.value:encode()
			local v4398, v4399 = proto.writeTag(buf, n292, 28, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4398, v4399, v4397, buffer.len(v4397))
		elseif p442.kind.type == "open_song_detail_action" then
			local v4400 = p442.kind.value:encode()
			local v4401, v4402 = proto.writeTag(buf, n292, 29, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4401, v4402, v4400, buffer.len(v4400))
		elseif p442.kind.type == "refresh_from_api_action" then
			local v4403 = p442.kind.value:encode()
			local v4404, v4405 = proto.writeTag(buf, n292, 30, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4404, v4405, v4403, buffer.len(v4403))
		elseif p442.kind.type == "rsvp_to_event_action" then
			local v4406 = p442.kind.value:encode()
			local v4407, v4408 = proto.writeTag(buf, n292, 31, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4407, v4408, v4406, buffer.len(v4406))
		elseif p442.kind.type == "apply_charts_filter_action" then
			local v4409 = p442.kind.value:encode()
			local v4410, v4411 = proto.writeTag(buf, n292, 32, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4410, v4411, v4409, buffer.len(v4409))
		elseif p442.kind.type == "analytics_event_action" then
			local v4412 = p442.kind.value:encode()
			local v4413, v4414 = proto.writeTag(buf, n292, 33, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4413, v4414, v4412, buffer.len(v4412))
		elseif p442.kind.type == "custom_analytics_event_action" then
			local v4415 = p442.kind.value:encode()
			local v4416, v4417 = proto.writeTag(buf, n292, 34, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4416, v4417, v4415, buffer.len(v4415))
		elseif p442.kind.type == "open_game_invite_action" then
			local v4418 = p442.kind.value:encode()
			local v4419, v4420 = proto.writeTag(buf, n292, 35, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4419, v4420, v4418, buffer.len(v4418))
		elseif p442.kind.type == "open_event_details_action" then
			local v4421 = p442.kind.value:encode()
			local v4422, v4423 = proto.writeTag(buf, n292, 36, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4422, v4423, v4421, buffer.len(v4421))
		elseif p442.kind.type == "launch_experience_action" then
			local v4424 = p442.kind.value:encode()
			local v4425, v4426 = proto.writeTag(buf, n292, 37, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4425, v4426, v4424, buffer.len(v4424))
		elseif p442.kind.type == "toggle_experience_favorite_action" then
			local v4427 = p442.kind.value:encode()
			local v4428, v4429 = proto.writeTag(buf, n292, 38, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4428, v4429, v4427, buffer.len(v4427))
		elseif p442.kind.type == "toggle_experience_follow_action" then
			local v4430 = p442.kind.value:encode()
			local v4431, v4432 = proto.writeTag(buf, n292, 39, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4431, v4432, v4430, buffer.len(v4430))
		elseif p442.kind.type == "toggle_experience_vote_action" then
			local v4433 = p442.kind.value:encode()
			local v4434, v4435 = proto.writeTag(buf, n292, 40, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4434, v4435, v4433, buffer.len(v4433))
		elseif p442.kind.type == "open_purchase_prompt_action" then
			local v4436 = p442.kind.value:encode()
			local v4437, v4438 = proto.writeTag(buf, n292, 41, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4437, v4438, v4436, buffer.len(v4436))
		elseif p442.kind.type == "open_sdui_overlay_action" then
			local v4439 = p442.kind.value:encode()
			local v4440, v4441 = proto.writeTag(buf, n292, 42, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4440, v4441, v4439, buffer.len(v4439))
		elseif p442.kind.type == "open_badges_see_all_action" then
			local v4442 = p442.kind.value:encode()
			local v4443, v4444 = proto.writeTag(buf, n292, 43, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4443, v4444, v4442, buffer.len(v4442))
		elseif p442.kind.type == "open_experience_store_see_all_action" then
			local v4445 = p442.kind.value:encode()
			local v4446, v4447 = proto.writeTag(buf, n292, 44, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4446, v4447, v4445, buffer.len(v4445))
		elseif p442.kind.type == "dismiss_game_feedback_action" then
			local v4448 = p442.kind.value:encode()
			local v4449, v4450 = proto.writeTag(buf, n292, 45, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4449, v4450, v4448, buffer.len(v4448))
		elseif p442.kind.type == "open_game_feedback_form_action" then
			local v4451 = p442.kind.value:encode()
			local v4452, v4453 = proto.writeTag(buf, n292, 46, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4452, v4453, v4451, buffer.len(v4451))
		elseif p442.kind.type == "enable_event_notifications_action" then
			local v4454 = p442.kind.value:encode()
			local v4455, v4456 = proto.writeTag(buf, n292, 47, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4455, v4456, v4454, buffer.len(v4454))
		elseif p442.kind.type == "dismiss_event_notifications_modal_action" then
			local v4457 = p442.kind.value:encode()
			local v4458, v4459 = proto.writeTag(buf, n292, 48, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4458, v4459, v4457, buffer.len(v4457))
		elseif p442.kind.type == "open_amp_wizard_action" then
			local v4460 = p442.kind.value:encode()
			local v4461, v4462 = proto.writeTag(buf, n292, 49, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4461, v4462, v4460, buffer.len(v4460))
		elseif p442.kind.type == "open_subscription_purchase_page_action" then
			local v4463 = p442.kind.value:encode()
			local v4464, v4465 = proto.writeTag(buf, n292, 50, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4464, v4465, v4463, buffer.len(v4463))
		elseif p442.kind.type == "refresh_game_passes_action" then
			local v4466 = p442.kind.value:encode()
			local v4467, v4468 = proto.writeTag(buf, n292, 51, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4467, v4468, v4466, buffer.len(v4466))
		elseif p442.kind.type == "refresh_playability_action" then
			local v4469 = p442.kind.value:encode()
			local v4470, v4471 = proto.writeTag(buf, n292, 52, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4470, v4471, v4469, buffer.len(v4469))
		elseif p442.kind.type == "open_social_proof_user_list_sheet_action" then
			local v4472 = p442.kind.value:encode()
			local v4473, v4474 = proto.writeTag(buf, n292, 53, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4473, v4474, v4472, buffer.len(v4472))
		elseif p442.kind.type == "report_surface_load_time_milestone_action" then
			local v4475 = p442.kind.value:encode()
			local v4476, v4477 = proto.writeTag(buf, n292, 54, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4476, v4477, v4475, buffer.len(v4475))
		elseif p442.kind.type == "open_search_results_tab_action" then
			local v4478 = p442.kind.value:encode()
			local v4479, v4480 = proto.writeTag(buf, n292, 55, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4479, v4480, v4478, buffer.len(v4478))
		elseif p442.kind.type == "open_phone_upsell_modal_action" then
			local v4481 = p442.kind.value:encode()
			local v4482, v4483 = proto.writeTag(buf, n292, 56, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4482, v4483, v4481, buffer.len(v4481))
		elseif p442.kind.type == "open_email_upsell_modal_action" then
			local v4484 = p442.kind.value:encode()
			local v4485, v4486 = proto.writeTag(buf, n292, 57, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4485, v4486, v4484, buffer.len(v4484))
		elseif p442.kind.type == "dismiss_prompt_action" then
			local v4487 = p442.kind.value:encode()
			local v4488, v4489 = proto.writeTag(buf, n292, 58, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4488, v4489, v4487, buffer.len(v4487))
		elseif p442.kind.type == "request_friendship_action" then
			local v4490 = p442.kind.value:encode()
			local v4491, v4492 = proto.writeTag(buf, n292, 59, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4491, v4492, v4490, buffer.len(v4490))
		elseif p442.kind.type == "refresh_developer_products_action" then
			local v4493 = p442.kind.value:encode()
			local v4494, v4495 = proto.writeTag(buf, n292, 60, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4494, v4495, v4493, buffer.len(v4493))
		elseif p442.kind.type == "open_fae_trial_upsell_action" then
			local v4496 = p442.kind.value:encode()
			local v4497, v4498 = proto.writeTag(buf, n292, 61, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4497, v4498, v4496, buffer.len(v4496))
		elseif p442.kind.type == "refresh_omni_recommendation_feed_item_action" then
			local v4499 = p442.kind.value:encode()
			local v4500, v4501 = proto.writeTag(buf, n292, 62, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4500, v4501, v4499, buffer.len(v4499))
		elseif p442.kind.type == "ai_overview_feedback_action" then
			local v4502 = p442.kind.value:encode()
			local v4503, v4504 = proto.writeTag(buf, n292, 63, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4503, v4504, v4502, buffer.len(v4502))
		elseif p442.kind.type == "open_trusted_friends_upsell_modal_action" then
			local v4505 = p442.kind.value:encode()
			local v4506, v4507 = proto.writeTag(buf, n292, 64, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4506, v4507, v4505, buffer.len(v4505))
		elseif p442.kind.type == "record_party_chat_conversation_upsell_acknowledgement_action" then
			local v4508 = p442.kind.value:encode()
			local v4509, v4510 = proto.writeTag(buf, n292, 65, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4509, v4510, v4508, buffer.len(v4508))
		elseif p442.kind.type == "open_search_results_with_query_action" then
			local v4511 = p442.kind.value:encode()
			local v4512, v4513 = proto.writeTag(buf, n292, 66, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4512, v4513, v4511, buffer.len(v4511))
		elseif p442.kind.type == "select_marketplace_favorites_category" then
			local v4514 = p442.kind.value:encode()
			local v4515, v4516 = proto.writeTag(buf, n292, 67, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4515, v4516, v4514, buffer.len(v4514))
		elseif p442.kind.type == "download_app_action" then
			local v4517 = p442.kind.value:encode()
			local v4518, v4519 = proto.writeTag(buf, n292, 68, proto.wireTypes.lengthDelimited)

			buf, n292 = proto.writeBuffer(v4518, v4519, v4517, buffer.len(v4517))
		end
	end

	if p442.telemetry_handler ~= nil then
		local v4520 = p442.telemetry_handler:encode()
		local v4521, v4522 = proto.writeTag(buf, n292, 1000, proto.wireTypes.lengthDelimited)

		buf, n292 = proto.writeBuffer(v4521, v4522, v4520, buffer.len(v4520))
	end

	if p442.accessibility_label ~= nil then
		local v4523 = p442.accessibility_label:encode()
		local v4524, v4525 = proto.writeTag(buf, n292, 1001, proto.wireTypes.lengthDelimited)

		buf, n292 = proto.writeBuffer(v4524, v4525, v4523, buffer.len(v4523))
	end

	local buf149 = buffer.create(n292)

	buffer.copy(buf149, 0, buf, 0, n292)

	return buf149
end
function t587.decode(p443: buffer) -- line: 27338
	-- upvalues: t587 (copy), proto (copy), t1 (copy), prop_types (copy)
	local v4528 = t587.new()
	local n293 = 0

	while n293 < buffer.len(p443) do
		local v4530, v4531

		v4530, v4531, n293 = proto.readTag(p443, n293)

		if v4531 == proto.wireTypes.varint then
			local v4532

			v4532, n293 = proto.readVarInt(p443, n293)
		elseif v4531 == proto.wireTypes.lengthDelimited then
			if v4530 == 1 then
				local v4533

				v4533, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "dismiss_dialog_action",
					value = t1.DismissDialogAction.decode(v4533)
				}
			elseif v4530 == 2 then
				local v4534

				v4534, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "link_action",
					value = t1.LinkAction.decode(v4534)
				}
			elseif v4530 == 3 then
				local v4535

				v4535, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "open_game_details_action",
					value = t1.OpenGameDetailsAction.decode(v4535)
				}
			elseif v4530 == 4 then
				local v4536

				v4536, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "open_join_friends_action",
					value = t1.OpenJoinFriendsAction.decode(v4536)
				}
			elseif v4530 == 5 then
				local v4537

				v4537, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "open_marketplace_try_on_action",
					value = t1.OpenMarketplaceTryOnAction.decode(v4537)
				}
			elseif v4530 == 6 then
				local v4538

				v4538, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "open_see_all_action",
					value = t1.OpenSeeAllAction.decode(v4538)
				}
			elseif v4530 == 7 then
				local v4539

				v4539, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "open_sponsored_tooltip_action",
					value = t1.OpenSponsoredTooltipAction.decode(v4539)
				}
			elseif v4530 == 8 then
				local v4540

				v4540, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "play_button_click_action",
					value = t1.PlayButtonClickAction.decode(v4540)
				}
			elseif v4530 == 9 then
				local v4541

				v4541, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "update_user_settings_action",
					value = t1.UpdateUserSettingsAction.decode(v4541)
				}
			elseif v4530 == 10 then
				local v4542

				v4542, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "open_tooltip_action",
					value = t1.OpenTooltipAction.decode(v4542)
				}
			elseif v4530 == 11 then
				local v4543

				v4543, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "open_badge_details_action",
					value = t1.OpenBadgeDetailsAction.decode(v4543)
				}
			elseif v4530 == 12 then
				local v4544

				v4544, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "load_more_from_api_action",
					value = t1.LoadMoreFromApiAction.decode(v4544)
				}
			elseif v4530 == 13 then
				local v4545

				v4545, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "share_action",
					value = t1.ShareAction.decode(v4545)
				}
			elseif v4530 == 14 then
				local v4546

				v4546, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "open_abuse_report_action",
					value = t1.OpenAbuseReportAction.decode(v4546)
				}
			elseif v4530 == 15 then
				local v4547

				v4547, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "remove_badge_from_inventory_action",
					value = t1.RemoveBadgeFromInventoryAction.decode(v4547)
				}
			elseif v4530 == 16 then
				local v4548

				v4548, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "open_profile_action",
					value = t1.OpenProfileAction.decode(v4548)
				}
			elseif v4530 == 17 then
				local v4549

				v4549, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "open_facial_age_estimation_action",
					value = t1.OpenFacialAgeEstimationAction.decode(v4549)
				}
			elseif v4530 == 18 then
				local v4550

				v4550, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "open_add_connections_page_action",
					value = t1.OpenAddConnectionsPageAction.decode(v4550)
				}
			elseif v4530 == 19 then
				local v4551

				v4551, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "open_marketplace_action",
					value = t1.OpenMarketplaceAction.decode(v4551)
				}
			elseif v4530 == 20 then
				local v4552

				v4552, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "hide_profile_completion_action",
					value = t1.HideProfileCompletionAction.decode(v4552)
				}
			elseif v4530 == 21 then
				local v4553

				v4553, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "select_marketplace_catalog_category",
					value = t1.SelectMarketplaceCatalogCategory.decode(v4553)
				}
			elseif v4530 == 22 then
				local v4554

				v4554, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "select_marketplace_catalog_subcategory",
					value = t1.SelectMarketplaceCatalogSubcategory.decode(v4554)
				}
			elseif v4530 == 23 then
				local v4555

				v4555, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "open_marketplace_catalog_see_all",
					value = t1.OpenMarketplaceCatalogSeeAll.decode(v4555)
				}
			elseif v4530 == 24 then
				local v4556

				v4556, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "close_marketplace_category_tooltip",
					value = t1.CloseMarketplaceCategoryTooltip.decode(v4556)
				}
			elseif v4530 == 25 then
				local v4557

				v4557, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "resize_marketplace_catalog",
					value = t1.ResizeMarketplaceCatalog.decode(v4557)
				}
			elseif v4530 == 26 then
				local v4558

				v4558, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "open_marketplace_catalog_filters",
					value = t1.OpenMarketplaceCatalogFilters.decode(v4558)
				}
			elseif v4530 == 27 then
				local v4559

				v4559, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "open_social_link_action",
					value = t1.OpenSocialLinkAction.decode(v4559)
				}
			elseif v4530 == 28 then
				local v4560

				v4560, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "open_charts_sort_detail_action",
					value = t1.OpenChartsSortDetailAction.decode(v4560)
				}
			elseif v4530 == 29 then
				local v4561

				v4561, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "open_song_detail_action",
					value = t1.OpenSongDetailAction.decode(v4561)
				}
			elseif v4530 == 30 then
				local v4562

				v4562, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "refresh_from_api_action",
					value = t1.RefreshFromApiAction.decode(v4562)
				}
			elseif v4530 == 31 then
				local v4563

				v4563, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "rsvp_to_event_action",
					value = t1.RsvpToEventAction.decode(v4563)
				}
			elseif v4530 == 32 then
				local v4564

				v4564, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "apply_charts_filter_action",
					value = t1.ApplyChartsFilterAction.decode(v4564)
				}
			elseif v4530 == 33 then
				local v4565

				v4565, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "analytics_event_action",
					value = t1.AnalyticsEventAction.decode(v4565)
				}
			elseif v4530 == 34 then
				local v4566

				v4566, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "custom_analytics_event_action",
					value = t1.CustomAnalyticsEventAction.decode(v4566)
				}
			elseif v4530 == 35 then
				local v4567

				v4567, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "open_game_invite_action",
					value = t1.OpenGameInviteAction.decode(v4567)
				}
			elseif v4530 == 36 then
				local v4568

				v4568, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "open_event_details_action",
					value = t1.OpenEventDetailsAction.decode(v4568)
				}
			elseif v4530 == 37 then
				local v4569

				v4569, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "launch_experience_action",
					value = t1.LaunchExperienceAction.decode(v4569)
				}
			elseif v4530 == 38 then
				local v4570

				v4570, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "toggle_experience_favorite_action",
					value = t1.ToggleExperienceFavoriteAction.decode(v4570)
				}
			elseif v4530 == 39 then
				local v4571

				v4571, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "toggle_experience_follow_action",
					value = t1.ToggleExperienceFollowAction.decode(v4571)
				}
			elseif v4530 == 40 then
				local v4572

				v4572, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "toggle_experience_vote_action",
					value = t1.ToggleExperienceVoteAction.decode(v4572)
				}
			elseif v4530 == 41 then
				local v4573

				v4573, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "open_purchase_prompt_action",
					value = t1.OpenPurchasePromptAction.decode(v4573)
				}
			elseif v4530 == 42 then
				local v4574

				v4574, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "open_sdui_overlay_action",
					value = t1.OpenSduiOverlayAction.decode(v4574)
				}
			elseif v4530 == 43 then
				local v4575

				v4575, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "open_badges_see_all_action",
					value = t1.OpenBadgesSeeAllAction.decode(v4575)
				}
			elseif v4530 == 44 then
				local v4576

				v4576, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "open_experience_store_see_all_action",
					value = t1.OpenExperienceStoreSeeAllAction.decode(v4576)
				}
			elseif v4530 == 45 then
				local v4577

				v4577, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "dismiss_game_feedback_action",
					value = t1.DismissGameFeedbackAction.decode(v4577)
				}
			elseif v4530 == 46 then
				local v4578

				v4578, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "open_game_feedback_form_action",
					value = t1.OpenGameFeedbackFormAction.decode(v4578)
				}
			elseif v4530 == 47 then
				local v4579

				v4579, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "enable_event_notifications_action",
					value = t1.EnableEventNotificationsAction.decode(v4579)
				}
			elseif v4530 == 48 then
				local v4580

				v4580, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "dismiss_event_notifications_modal_action",
					value = t1.DismissEventNotificationsModalAction.decode(v4580)
				}
			elseif v4530 == 49 then
				local v4581

				v4581, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "open_amp_wizard_action",
					value = t1.OpenAmpWizardAction.decode(v4581)
				}
			elseif v4530 == 50 then
				local v4582

				v4582, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "open_subscription_purchase_page_action",
					value = t1.OpenSubscriptionPurchasePageAction.decode(v4582)
				}
			elseif v4530 == 51 then
				local v4583

				v4583, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "refresh_game_passes_action",
					value = t1.RefreshGamePassesAction.decode(v4583)
				}
			elseif v4530 == 52 then
				local v4584

				v4584, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "refresh_playability_action",
					value = t1.RefreshPlayabilityAction.decode(v4584)
				}
			elseif v4530 == 53 then
				local v4585

				v4585, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "open_social_proof_user_list_sheet_action",
					value = t1.OpenSocialProofUserListSheetAction.decode(v4585)
				}
			elseif v4530 == 54 then
				local v4586

				v4586, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "report_surface_load_time_milestone_action",
					value = t1.ReportSurfaceLoadTimeMilestoneAction.decode(v4586)
				}
			elseif v4530 == 55 then
				local v4587

				v4587, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "open_search_results_tab_action",
					value = t1.OpenSearchResultsTabAction.decode(v4587)
				}
			elseif v4530 == 56 then
				local v4588

				v4588, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "open_phone_upsell_modal_action",
					value = t1.OpenPhoneUpsellModalAction.decode(v4588)
				}
			elseif v4530 == 57 then
				local v4589

				v4589, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "open_email_upsell_modal_action",
					value = t1.OpenEmailUpsellModalAction.decode(v4589)
				}
			elseif v4530 == 58 then
				local v4590

				v4590, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "dismiss_prompt_action",
					value = t1.DismissPromptAction.decode(v4590)
				}
			elseif v4530 == 59 then
				local v4591

				v4591, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "request_friendship_action",
					value = t1.RequestFriendshipAction.decode(v4591)
				}
			elseif v4530 == 60 then
				local v4592

				v4592, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "refresh_developer_products_action",
					value = t1.RefreshDeveloperProductsAction.decode(v4592)
				}
			elseif v4530 == 61 then
				local v4593

				v4593, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "open_fae_trial_upsell_action",
					value = t1.OpenFaeTrialUpsellAction.decode(v4593)
				}
			elseif v4530 == 62 then
				local v4594

				v4594, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "refresh_omni_recommendation_feed_item_action",
					value = t1.RefreshOmniRecommendationFeedItemAction.decode(v4594)
				}
			elseif v4530 == 63 then
				local v4595

				v4595, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "ai_overview_feedback_action",
					value = t1.AiOverviewFeedbackAction.decode(v4595)
				}
			elseif v4530 == 64 then
				local v4596

				v4596, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "open_trusted_friends_upsell_modal_action",
					value = t1.OpenTrustedFriendsUpsellModalAction.decode(v4596)
				}
			elseif v4530 == 65 then
				local v4597

				v4597, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "record_party_chat_conversation_upsell_acknowledgement_action",
					value = t1.RecordPartyChatConversationUpsellAcknowledgementAction.decode(v4597)
				}
			elseif v4530 == 66 then
				local v4598

				v4598, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "open_search_results_with_query_action",
					value = t1.OpenSearchResultsWithQueryAction.decode(v4598)
				}
			elseif v4530 == 67 then
				local v4599

				v4599, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "select_marketplace_favorites_category",
					value = t1.SelectMarketplaceFavoritesCategory.decode(v4599)
				}
			elseif v4530 == 68 then
				local v4600

				v4600, n293 = proto.readBuffer(p443, n293)
				v4528.kind = {
					type = "download_app_action",
					value = t1.DownloadAppAction.decode(v4600)
				}
			elseif v4530 == 1000 then
				local v4601

				v4601, n293 = proto.readBuffer(p443, n293)
				v4528.telemetry_handler = prop_types.StringProp.decode(v4601)
			elseif v4530 == 1001 then
				local v4602

				v4602, n293 = proto.readBuffer(p443, n293)
				v4528.accessibility_label = prop_types.StringFormat.decode(v4602)
			else
				local v4603, v4604 = proto.readVarInt(p443, n293)

				n293 = v4604 + v4603
			end
		elseif v4531 == proto.wireTypes.i32 then
			local v4605

			v4605, n293 = proto.readFixed32(p443, n293)
		elseif v4531 == proto.wireTypes.i64 then
			local v4606

			v4606, n293 = proto.readFixed64(p443, n293)
		else
			error("Unsupported wire type: " .. v4531)
		end
	end

	return v4528
end
function t587.jsonEncode(p444) -- line: 27858
	local t589 = {}

	if p444.kind ~= nil then
		if p444.kind.type == "dismiss_dialog_action" then
			t589.dismissDialogAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "link_action" then
			t589.linkAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "open_game_details_action" then
			t589.openGameDetailsAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "open_join_friends_action" then
			t589.openJoinFriendsAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "open_marketplace_try_on_action" then
			t589.openMarketplaceTryOnAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "open_see_all_action" then
			t589.openSeeAllAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "open_sponsored_tooltip_action" then
			t589.openSponsoredTooltipAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "play_button_click_action" then
			t589.playButtonClickAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "update_user_settings_action" then
			t589.updateUserSettingsAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "open_tooltip_action" then
			t589.openTooltipAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "open_badge_details_action" then
			t589.openBadgeDetailsAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "load_more_from_api_action" then
			t589.loadMoreFromApiAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "share_action" then
			t589.shareAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "open_abuse_report_action" then
			t589.openAbuseReportAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "remove_badge_from_inventory_action" then
			t589.removeBadgeFromInventoryAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "open_profile_action" then
			t589.openProfileAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "open_facial_age_estimation_action" then
			t589.openFacialAgeEstimationAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "open_add_connections_page_action" then
			t589.openAddConnectionsPageAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "open_marketplace_action" then
			t589.openMarketplaceAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "hide_profile_completion_action" then
			t589.hideProfileCompletionAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "select_marketplace_catalog_category" then
			t589.selectMarketplaceCatalogCategory = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "select_marketplace_catalog_subcategory" then
			t589.selectMarketplaceCatalogSubcategory = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "open_marketplace_catalog_see_all" then
			t589.openMarketplaceCatalogSeeAll = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "close_marketplace_category_tooltip" then
			t589.closeMarketplaceCategoryTooltip = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "resize_marketplace_catalog" then
			t589.resizeMarketplaceCatalog = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "open_marketplace_catalog_filters" then
			t589.openMarketplaceCatalogFilters = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "open_social_link_action" then
			t589.openSocialLinkAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "open_charts_sort_detail_action" then
			t589.openChartsSortDetailAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "open_song_detail_action" then
			t589.openSongDetailAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "refresh_from_api_action" then
			t589.refreshFromApiAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "rsvp_to_event_action" then
			t589.rsvpToEventAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "apply_charts_filter_action" then
			t589.applyChartsFilterAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "analytics_event_action" then
			t589.analyticsEventAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "custom_analytics_event_action" then
			t589.customAnalyticsEventAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "open_game_invite_action" then
			t589.openGameInviteAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "open_event_details_action" then
			t589.openEventDetailsAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "launch_experience_action" then
			t589.launchExperienceAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "toggle_experience_favorite_action" then
			t589.toggleExperienceFavoriteAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "toggle_experience_follow_action" then
			t589.toggleExperienceFollowAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "toggle_experience_vote_action" then
			t589.toggleExperienceVoteAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "open_purchase_prompt_action" then
			t589.openPurchasePromptAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "open_sdui_overlay_action" then
			t589.openSduiOverlayAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "open_badges_see_all_action" then
			t589.openBadgesSeeAllAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "open_experience_store_see_all_action" then
			t589.openExperienceStoreSeeAllAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "dismiss_game_feedback_action" then
			t589.dismissGameFeedbackAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "open_game_feedback_form_action" then
			t589.openGameFeedbackFormAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "enable_event_notifications_action" then
			t589.enableEventNotificationsAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "dismiss_event_notifications_modal_action" then
			t589.dismissEventNotificationsModalAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "open_amp_wizard_action" then
			t589.openAmpWizardAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "open_subscription_purchase_page_action" then
			t589.openSubscriptionPurchasePageAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "refresh_game_passes_action" then
			t589.refreshGamePassesAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "refresh_playability_action" then
			t589.refreshPlayabilityAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "open_social_proof_user_list_sheet_action" then
			t589.openSocialProofUserListSheetAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "report_surface_load_time_milestone_action" then
			t589.reportSurfaceLoadTimeMilestoneAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "open_search_results_tab_action" then
			t589.openSearchResultsTabAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "open_phone_upsell_modal_action" then
			t589.openPhoneUpsellModalAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "open_email_upsell_modal_action" then
			t589.openEmailUpsellModalAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "dismiss_prompt_action" then
			t589.dismissPromptAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "request_friendship_action" then
			t589.requestFriendshipAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "refresh_developer_products_action" then
			t589.refreshDeveloperProductsAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "open_fae_trial_upsell_action" then
			t589.openFaeTrialUpsellAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "refresh_omni_recommendation_feed_item_action" then
			t589.refreshOmniRecommendationFeedItemAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "ai_overview_feedback_action" then
			t589.aiOverviewFeedbackAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "open_trusted_friends_upsell_modal_action" then
			t589.openTrustedFriendsUpsellModalAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "record_party_chat_conversation_upsell_acknowledgement_action" then
			t589.recordPartyChatConversationUpsellAcknowledgementAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "open_search_results_with_query_action" then
			t589.openSearchResultsWithQueryAction = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "select_marketplace_favorites_category" then
			t589.selectMarketplaceFavoritesCategory = p444.kind.value:jsonEncode()
		elseif p444.kind.type == "download_app_action" then
			t589.downloadAppAction = p444.kind.value:jsonEncode()
		end
	end

	if p444.telemetry_handler ~= nil then
		t589.telemetryHandler = p444.telemetry_handler:jsonEncode()
	end

	if p444.accessibility_label ~= nil then
		t589.accessibilityLabel = p444.accessibility_label:jsonEncode()
	end

	return t589
end
function t587.jsonDecode(t590: {[any]: any}) -- line: 28012
	-- upvalues: t587 (copy), t1 (copy), prop_types (copy)
	local v4610 = t587.new()

	if t590.dismiss_dialog_action ~= nil then
		v4610.kind = {
			type = "dismiss_dialog_action",
			value = t1.DismissDialogAction.jsonDecode(t590.dismiss_dialog_action)
		}
	end

	if t590.dismissDialogAction ~= nil then
		v4610.kind = {
			type = "dismiss_dialog_action",
			value = t1.DismissDialogAction.jsonDecode(t590.dismissDialogAction)
		}
	end

	if t590.link_action ~= nil then
		v4610.kind = {
			type = "link_action",
			value = t1.LinkAction.jsonDecode(t590.link_action)
		}
	end

	if t590.linkAction ~= nil then
		v4610.kind = {
			type = "link_action",
			value = t1.LinkAction.jsonDecode(t590.linkAction)
		}
	end

	if t590.open_game_details_action ~= nil then
		v4610.kind = {
			type = "open_game_details_action",
			value = t1.OpenGameDetailsAction.jsonDecode(t590.open_game_details_action)
		}
	end

	if t590.openGameDetailsAction ~= nil then
		v4610.kind = {
			type = "open_game_details_action",
			value = t1.OpenGameDetailsAction.jsonDecode(t590.openGameDetailsAction)
		}
	end

	if t590.open_join_friends_action ~= nil then
		v4610.kind = {
			type = "open_join_friends_action",
			value = t1.OpenJoinFriendsAction.jsonDecode(t590.open_join_friends_action)
		}
	end

	if t590.openJoinFriendsAction ~= nil then
		v4610.kind = {
			type = "open_join_friends_action",
			value = t1.OpenJoinFriendsAction.jsonDecode(t590.openJoinFriendsAction)
		}
	end

	if t590.open_marketplace_try_on_action ~= nil then
		v4610.kind = {
			type = "open_marketplace_try_on_action",
			value = t1.OpenMarketplaceTryOnAction.jsonDecode(t590.open_marketplace_try_on_action)
		}
	end

	if t590.openMarketplaceTryOnAction ~= nil then
		v4610.kind = {
			type = "open_marketplace_try_on_action",
			value = t1.OpenMarketplaceTryOnAction.jsonDecode(t590.openMarketplaceTryOnAction)
		}
	end

	if t590.open_see_all_action ~= nil then
		v4610.kind = {
			type = "open_see_all_action",
			value = t1.OpenSeeAllAction.jsonDecode(t590.open_see_all_action)
		}
	end

	if t590.openSeeAllAction ~= nil then
		v4610.kind = {
			type = "open_see_all_action",
			value = t1.OpenSeeAllAction.jsonDecode(t590.openSeeAllAction)
		}
	end

	if t590.open_sponsored_tooltip_action ~= nil then
		v4610.kind = {
			type = "open_sponsored_tooltip_action",
			value = t1.OpenSponsoredTooltipAction.jsonDecode(t590.open_sponsored_tooltip_action)
		}
	end

	if t590.openSponsoredTooltipAction ~= nil then
		v4610.kind = {
			type = "open_sponsored_tooltip_action",
			value = t1.OpenSponsoredTooltipAction.jsonDecode(t590.openSponsoredTooltipAction)
		}
	end

	if t590.play_button_click_action ~= nil then
		v4610.kind = {
			type = "play_button_click_action",
			value = t1.PlayButtonClickAction.jsonDecode(t590.play_button_click_action)
		}
	end

	if t590.playButtonClickAction ~= nil then
		v4610.kind = {
			type = "play_button_click_action",
			value = t1.PlayButtonClickAction.jsonDecode(t590.playButtonClickAction)
		}
	end

	if t590.update_user_settings_action ~= nil then
		v4610.kind = {
			type = "update_user_settings_action",
			value = t1.UpdateUserSettingsAction.jsonDecode(t590.update_user_settings_action)
		}
	end

	if t590.updateUserSettingsAction ~= nil then
		v4610.kind = {
			type = "update_user_settings_action",
			value = t1.UpdateUserSettingsAction.jsonDecode(t590.updateUserSettingsAction)
		}
	end

	if t590.open_tooltip_action ~= nil then
		v4610.kind = {
			type = "open_tooltip_action",
			value = t1.OpenTooltipAction.jsonDecode(t590.open_tooltip_action)
		}
	end

	if t590.openTooltipAction ~= nil then
		v4610.kind = {
			type = "open_tooltip_action",
			value = t1.OpenTooltipAction.jsonDecode(t590.openTooltipAction)
		}
	end

	if t590.open_badge_details_action ~= nil then
		v4610.kind = {
			type = "open_badge_details_action",
			value = t1.OpenBadgeDetailsAction.jsonDecode(t590.open_badge_details_action)
		}
	end

	if t590.openBadgeDetailsAction ~= nil then
		v4610.kind = {
			type = "open_badge_details_action",
			value = t1.OpenBadgeDetailsAction.jsonDecode(t590.openBadgeDetailsAction)
		}
	end

	if t590.load_more_from_api_action ~= nil then
		v4610.kind = {
			type = "load_more_from_api_action",
			value = t1.LoadMoreFromApiAction.jsonDecode(t590.load_more_from_api_action)
		}
	end

	if t590.loadMoreFromApiAction ~= nil then
		v4610.kind = {
			type = "load_more_from_api_action",
			value = t1.LoadMoreFromApiAction.jsonDecode(t590.loadMoreFromApiAction)
		}
	end

	if t590.share_action ~= nil then
		v4610.kind = {
			type = "share_action",
			value = t1.ShareAction.jsonDecode(t590.share_action)
		}
	end

	if t590.shareAction ~= nil then
		v4610.kind = {
			type = "share_action",
			value = t1.ShareAction.jsonDecode(t590.shareAction)
		}
	end

	if t590.open_abuse_report_action ~= nil then
		v4610.kind = {
			type = "open_abuse_report_action",
			value = t1.OpenAbuseReportAction.jsonDecode(t590.open_abuse_report_action)
		}
	end

	if t590.openAbuseReportAction ~= nil then
		v4610.kind = {
			type = "open_abuse_report_action",
			value = t1.OpenAbuseReportAction.jsonDecode(t590.openAbuseReportAction)
		}
	end

	if t590.remove_badge_from_inventory_action ~= nil then
		v4610.kind = {
			type = "remove_badge_from_inventory_action",
			value = t1.RemoveBadgeFromInventoryAction.jsonDecode(t590.remove_badge_from_inventory_action)
		}
	end

	if t590.removeBadgeFromInventoryAction ~= nil then
		v4610.kind = {
			type = "remove_badge_from_inventory_action",
			value = t1.RemoveBadgeFromInventoryAction.jsonDecode(t590.removeBadgeFromInventoryAction)
		}
	end

	if t590.open_profile_action ~= nil then
		v4610.kind = {
			type = "open_profile_action",
			value = t1.OpenProfileAction.jsonDecode(t590.open_profile_action)
		}
	end

	if t590.openProfileAction ~= nil then
		v4610.kind = {
			type = "open_profile_action",
			value = t1.OpenProfileAction.jsonDecode(t590.openProfileAction)
		}
	end

	if t590.open_facial_age_estimation_action ~= nil then
		v4610.kind = {
			type = "open_facial_age_estimation_action",
			value = t1.OpenFacialAgeEstimationAction.jsonDecode(t590.open_facial_age_estimation_action)
		}
	end

	if t590.openFacialAgeEstimationAction ~= nil then
		v4610.kind = {
			type = "open_facial_age_estimation_action",
			value = t1.OpenFacialAgeEstimationAction.jsonDecode(t590.openFacialAgeEstimationAction)
		}
	end

	if t590.open_add_connections_page_action ~= nil then
		v4610.kind = {
			type = "open_add_connections_page_action",
			value = t1.OpenAddConnectionsPageAction.jsonDecode(t590.open_add_connections_page_action)
		}
	end

	if t590.openAddConnectionsPageAction ~= nil then
		v4610.kind = {
			type = "open_add_connections_page_action",
			value = t1.OpenAddConnectionsPageAction.jsonDecode(t590.openAddConnectionsPageAction)
		}
	end

	if t590.open_marketplace_action ~= nil then
		v4610.kind = {
			type = "open_marketplace_action",
			value = t1.OpenMarketplaceAction.jsonDecode(t590.open_marketplace_action)
		}
	end

	if t590.openMarketplaceAction ~= nil then
		v4610.kind = {
			type = "open_marketplace_action",
			value = t1.OpenMarketplaceAction.jsonDecode(t590.openMarketplaceAction)
		}
	end

	if t590.hide_profile_completion_action ~= nil then
		v4610.kind = {
			type = "hide_profile_completion_action",
			value = t1.HideProfileCompletionAction.jsonDecode(t590.hide_profile_completion_action)
		}
	end

	if t590.hideProfileCompletionAction ~= nil then
		v4610.kind = {
			type = "hide_profile_completion_action",
			value = t1.HideProfileCompletionAction.jsonDecode(t590.hideProfileCompletionAction)
		}
	end

	if t590.select_marketplace_catalog_category ~= nil then
		v4610.kind = {
			type = "select_marketplace_catalog_category",
			value = t1.SelectMarketplaceCatalogCategory.jsonDecode(t590.select_marketplace_catalog_category)
		}
	end

	if t590.selectMarketplaceCatalogCategory ~= nil then
		v4610.kind = {
			type = "select_marketplace_catalog_category",
			value = t1.SelectMarketplaceCatalogCategory.jsonDecode(t590.selectMarketplaceCatalogCategory)
		}
	end

	if t590.select_marketplace_catalog_subcategory ~= nil then
		v4610.kind = {
			type = "select_marketplace_catalog_subcategory",
			value = t1.SelectMarketplaceCatalogSubcategory.jsonDecode(t590.select_marketplace_catalog_subcategory)
		}
	end

	if t590.selectMarketplaceCatalogSubcategory ~= nil then
		v4610.kind = {
			type = "select_marketplace_catalog_subcategory",
			value = t1.SelectMarketplaceCatalogSubcategory.jsonDecode(t590.selectMarketplaceCatalogSubcategory)
		}
	end

	if t590.open_marketplace_catalog_see_all ~= nil then
		v4610.kind = {
			type = "open_marketplace_catalog_see_all",
			value = t1.OpenMarketplaceCatalogSeeAll.jsonDecode(t590.open_marketplace_catalog_see_all)
		}
	end

	if t590.openMarketplaceCatalogSeeAll ~= nil then
		v4610.kind = {
			type = "open_marketplace_catalog_see_all",
			value = t1.OpenMarketplaceCatalogSeeAll.jsonDecode(t590.openMarketplaceCatalogSeeAll)
		}
	end

	if t590.close_marketplace_category_tooltip ~= nil then
		v4610.kind = {
			type = "close_marketplace_category_tooltip",
			value = t1.CloseMarketplaceCategoryTooltip.jsonDecode(t590.close_marketplace_category_tooltip)
		}
	end

	if t590.closeMarketplaceCategoryTooltip ~= nil then
		v4610.kind = {
			type = "close_marketplace_category_tooltip",
			value = t1.CloseMarketplaceCategoryTooltip.jsonDecode(t590.closeMarketplaceCategoryTooltip)
		}
	end

	if t590.resize_marketplace_catalog ~= nil then
		v4610.kind = {
			type = "resize_marketplace_catalog",
			value = t1.ResizeMarketplaceCatalog.jsonDecode(t590.resize_marketplace_catalog)
		}
	end

	if t590.resizeMarketplaceCatalog ~= nil then
		v4610.kind = {
			type = "resize_marketplace_catalog",
			value = t1.ResizeMarketplaceCatalog.jsonDecode(t590.resizeMarketplaceCatalog)
		}
	end

	if t590.open_marketplace_catalog_filters ~= nil then
		v4610.kind = {
			type = "open_marketplace_catalog_filters",
			value = t1.OpenMarketplaceCatalogFilters.jsonDecode(t590.open_marketplace_catalog_filters)
		}
	end

	if t590.openMarketplaceCatalogFilters ~= nil then
		v4610.kind = {
			type = "open_marketplace_catalog_filters",
			value = t1.OpenMarketplaceCatalogFilters.jsonDecode(t590.openMarketplaceCatalogFilters)
		}
	end

	if t590.open_social_link_action ~= nil then
		v4610.kind = {
			type = "open_social_link_action",
			value = t1.OpenSocialLinkAction.jsonDecode(t590.open_social_link_action)
		}
	end

	if t590.openSocialLinkAction ~= nil then
		v4610.kind = {
			type = "open_social_link_action",
			value = t1.OpenSocialLinkAction.jsonDecode(t590.openSocialLinkAction)
		}
	end

	if t590.open_charts_sort_detail_action ~= nil then
		v4610.kind = {
			type = "open_charts_sort_detail_action",
			value = t1.OpenChartsSortDetailAction.jsonDecode(t590.open_charts_sort_detail_action)
		}
	end

	if t590.openChartsSortDetailAction ~= nil then
		v4610.kind = {
			type = "open_charts_sort_detail_action",
			value = t1.OpenChartsSortDetailAction.jsonDecode(t590.openChartsSortDetailAction)
		}
	end

	if t590.open_song_detail_action ~= nil then
		v4610.kind = {
			type = "open_song_detail_action",
			value = t1.OpenSongDetailAction.jsonDecode(t590.open_song_detail_action)
		}
	end

	if t590.openSongDetailAction ~= nil then
		v4610.kind = {
			type = "open_song_detail_action",
			value = t1.OpenSongDetailAction.jsonDecode(t590.openSongDetailAction)
		}
	end

	if t590.refresh_from_api_action ~= nil then
		v4610.kind = {
			type = "refresh_from_api_action",
			value = t1.RefreshFromApiAction.jsonDecode(t590.refresh_from_api_action)
		}
	end

	if t590.refreshFromApiAction ~= nil then
		v4610.kind = {
			type = "refresh_from_api_action",
			value = t1.RefreshFromApiAction.jsonDecode(t590.refreshFromApiAction)
		}
	end

	if t590.rsvp_to_event_action ~= nil then
		v4610.kind = {
			type = "rsvp_to_event_action",
			value = t1.RsvpToEventAction.jsonDecode(t590.rsvp_to_event_action)
		}
	end

	if t590.rsvpToEventAction ~= nil then
		v4610.kind = {
			type = "rsvp_to_event_action",
			value = t1.RsvpToEventAction.jsonDecode(t590.rsvpToEventAction)
		}
	end

	if t590.apply_charts_filter_action ~= nil then
		v4610.kind = {
			type = "apply_charts_filter_action",
			value = t1.ApplyChartsFilterAction.jsonDecode(t590.apply_charts_filter_action)
		}
	end

	if t590.applyChartsFilterAction ~= nil then
		v4610.kind = {
			type = "apply_charts_filter_action",
			value = t1.ApplyChartsFilterAction.jsonDecode(t590.applyChartsFilterAction)
		}
	end

	if t590.analytics_event_action ~= nil then
		v4610.kind = {
			type = "analytics_event_action",
			value = t1.AnalyticsEventAction.jsonDecode(t590.analytics_event_action)
		}
	end

	if t590.analyticsEventAction ~= nil then
		v4610.kind = {
			type = "analytics_event_action",
			value = t1.AnalyticsEventAction.jsonDecode(t590.analyticsEventAction)
		}
	end

	if t590.custom_analytics_event_action ~= nil then
		v4610.kind = {
			type = "custom_analytics_event_action",
			value = t1.CustomAnalyticsEventAction.jsonDecode(t590.custom_analytics_event_action)
		}
	end

	if t590.customAnalyticsEventAction ~= nil then
		v4610.kind = {
			type = "custom_analytics_event_action",
			value = t1.CustomAnalyticsEventAction.jsonDecode(t590.customAnalyticsEventAction)
		}
	end

	if t590.open_game_invite_action ~= nil then
		v4610.kind = {
			type = "open_game_invite_action",
			value = t1.OpenGameInviteAction.jsonDecode(t590.open_game_invite_action)
		}
	end

	if t590.openGameInviteAction ~= nil then
		v4610.kind = {
			type = "open_game_invite_action",
			value = t1.OpenGameInviteAction.jsonDecode(t590.openGameInviteAction)
		}
	end

	if t590.open_event_details_action ~= nil then
		v4610.kind = {
			type = "open_event_details_action",
			value = t1.OpenEventDetailsAction.jsonDecode(t590.open_event_details_action)
		}
	end

	if t590.openEventDetailsAction ~= nil then
		v4610.kind = {
			type = "open_event_details_action",
			value = t1.OpenEventDetailsAction.jsonDecode(t590.openEventDetailsAction)
		}
	end

	if t590.launch_experience_action ~= nil then
		v4610.kind = {
			type = "launch_experience_action",
			value = t1.LaunchExperienceAction.jsonDecode(t590.launch_experience_action)
		}
	end

	if t590.launchExperienceAction ~= nil then
		v4610.kind = {
			type = "launch_experience_action",
			value = t1.LaunchExperienceAction.jsonDecode(t590.launchExperienceAction)
		}
	end

	if t590.toggle_experience_favorite_action ~= nil then
		v4610.kind = {
			type = "toggle_experience_favorite_action",
			value = t1.ToggleExperienceFavoriteAction.jsonDecode(t590.toggle_experience_favorite_action)
		}
	end

	if t590.toggleExperienceFavoriteAction ~= nil then
		v4610.kind = {
			type = "toggle_experience_favorite_action",
			value = t1.ToggleExperienceFavoriteAction.jsonDecode(t590.toggleExperienceFavoriteAction)
		}
	end

	if t590.toggle_experience_follow_action ~= nil then
		v4610.kind = {
			type = "toggle_experience_follow_action",
			value = t1.ToggleExperienceFollowAction.jsonDecode(t590.toggle_experience_follow_action)
		}
	end

	if t590.toggleExperienceFollowAction ~= nil then
		v4610.kind = {
			type = "toggle_experience_follow_action",
			value = t1.ToggleExperienceFollowAction.jsonDecode(t590.toggleExperienceFollowAction)
		}
	end

	if t590.toggle_experience_vote_action ~= nil then
		v4610.kind = {
			type = "toggle_experience_vote_action",
			value = t1.ToggleExperienceVoteAction.jsonDecode(t590.toggle_experience_vote_action)
		}
	end

	if t590.toggleExperienceVoteAction ~= nil then
		v4610.kind = {
			type = "toggle_experience_vote_action",
			value = t1.ToggleExperienceVoteAction.jsonDecode(t590.toggleExperienceVoteAction)
		}
	end

	if t590.open_purchase_prompt_action ~= nil then
		v4610.kind = {
			type = "open_purchase_prompt_action",
			value = t1.OpenPurchasePromptAction.jsonDecode(t590.open_purchase_prompt_action)
		}
	end

	if t590.openPurchasePromptAction ~= nil then
		v4610.kind = {
			type = "open_purchase_prompt_action",
			value = t1.OpenPurchasePromptAction.jsonDecode(t590.openPurchasePromptAction)
		}
	end

	if t590.open_sdui_overlay_action ~= nil then
		v4610.kind = {
			type = "open_sdui_overlay_action",
			value = t1.OpenSduiOverlayAction.jsonDecode(t590.open_sdui_overlay_action)
		}
	end

	if t590.openSduiOverlayAction ~= nil then
		v4610.kind = {
			type = "open_sdui_overlay_action",
			value = t1.OpenSduiOverlayAction.jsonDecode(t590.openSduiOverlayAction)
		}
	end

	if t590.open_badges_see_all_action ~= nil then
		v4610.kind = {
			type = "open_badges_see_all_action",
			value = t1.OpenBadgesSeeAllAction.jsonDecode(t590.open_badges_see_all_action)
		}
	end

	if t590.openBadgesSeeAllAction ~= nil then
		v4610.kind = {
			type = "open_badges_see_all_action",
			value = t1.OpenBadgesSeeAllAction.jsonDecode(t590.openBadgesSeeAllAction)
		}
	end

	if t590.open_experience_store_see_all_action ~= nil then
		v4610.kind = {
			type = "open_experience_store_see_all_action",
			value = t1.OpenExperienceStoreSeeAllAction.jsonDecode(t590.open_experience_store_see_all_action)
		}
	end

	if t590.openExperienceStoreSeeAllAction ~= nil then
		v4610.kind = {
			type = "open_experience_store_see_all_action",
			value = t1.OpenExperienceStoreSeeAllAction.jsonDecode(t590.openExperienceStoreSeeAllAction)
		}
	end

	if t590.dismiss_game_feedback_action ~= nil then
		v4610.kind = {
			type = "dismiss_game_feedback_action",
			value = t1.DismissGameFeedbackAction.jsonDecode(t590.dismiss_game_feedback_action)
		}
	end

	if t590.dismissGameFeedbackAction ~= nil then
		v4610.kind = {
			type = "dismiss_game_feedback_action",
			value = t1.DismissGameFeedbackAction.jsonDecode(t590.dismissGameFeedbackAction)
		}
	end

	if t590.open_game_feedback_form_action ~= nil then
		v4610.kind = {
			type = "open_game_feedback_form_action",
			value = t1.OpenGameFeedbackFormAction.jsonDecode(t590.open_game_feedback_form_action)
		}
	end

	if t590.openGameFeedbackFormAction ~= nil then
		v4610.kind = {
			type = "open_game_feedback_form_action",
			value = t1.OpenGameFeedbackFormAction.jsonDecode(t590.openGameFeedbackFormAction)
		}
	end

	if t590.enable_event_notifications_action ~= nil then
		v4610.kind = {
			type = "enable_event_notifications_action",
			value = t1.EnableEventNotificationsAction.jsonDecode(t590.enable_event_notifications_action)
		}
	end

	if t590.enableEventNotificationsAction ~= nil then
		v4610.kind = {
			type = "enable_event_notifications_action",
			value = t1.EnableEventNotificationsAction.jsonDecode(t590.enableEventNotificationsAction)
		}
	end

	if t590.dismiss_event_notifications_modal_action ~= nil then
		v4610.kind = {
			type = "dismiss_event_notifications_modal_action",
			value = t1.DismissEventNotificationsModalAction.jsonDecode(t590.dismiss_event_notifications_modal_action)
		}
	end

	if t590.dismissEventNotificationsModalAction ~= nil then
		v4610.kind = {
			type = "dismiss_event_notifications_modal_action",
			value = t1.DismissEventNotificationsModalAction.jsonDecode(t590.dismissEventNotificationsModalAction)
		}
	end

	if t590.open_amp_wizard_action ~= nil then
		v4610.kind = {
			type = "open_amp_wizard_action",
			value = t1.OpenAmpWizardAction.jsonDecode(t590.open_amp_wizard_action)
		}
	end

	if t590.openAmpWizardAction ~= nil then
		v4610.kind = {
			type = "open_amp_wizard_action",
			value = t1.OpenAmpWizardAction.jsonDecode(t590.openAmpWizardAction)
		}
	end

	if t590.open_subscription_purchase_page_action ~= nil then
		v4610.kind = {
			type = "open_subscription_purchase_page_action",
			value = t1.OpenSubscriptionPurchasePageAction.jsonDecode(t590.open_subscription_purchase_page_action)
		}
	end

	if t590.openSubscriptionPurchasePageAction ~= nil then
		v4610.kind = {
			type = "open_subscription_purchase_page_action",
			value = t1.OpenSubscriptionPurchasePageAction.jsonDecode(t590.openSubscriptionPurchasePageAction)
		}
	end

	if t590.refresh_game_passes_action ~= nil then
		v4610.kind = {
			type = "refresh_game_passes_action",
			value = t1.RefreshGamePassesAction.jsonDecode(t590.refresh_game_passes_action)
		}
	end

	if t590.refreshGamePassesAction ~= nil then
		v4610.kind = {
			type = "refresh_game_passes_action",
			value = t1.RefreshGamePassesAction.jsonDecode(t590.refreshGamePassesAction)
		}
	end

	if t590.refresh_playability_action ~= nil then
		v4610.kind = {
			type = "refresh_playability_action",
			value = t1.RefreshPlayabilityAction.jsonDecode(t590.refresh_playability_action)
		}
	end

	if t590.refreshPlayabilityAction ~= nil then
		v4610.kind = {
			type = "refresh_playability_action",
			value = t1.RefreshPlayabilityAction.jsonDecode(t590.refreshPlayabilityAction)
		}
	end

	if t590.open_social_proof_user_list_sheet_action ~= nil then
		v4610.kind = {
			type = "open_social_proof_user_list_sheet_action",
			value = t1.OpenSocialProofUserListSheetAction.jsonDecode(t590.open_social_proof_user_list_sheet_action)
		}
	end

	if t590.openSocialProofUserListSheetAction ~= nil then
		v4610.kind = {
			type = "open_social_proof_user_list_sheet_action",
			value = t1.OpenSocialProofUserListSheetAction.jsonDecode(t590.openSocialProofUserListSheetAction)
		}
	end

	if t590.report_surface_load_time_milestone_action ~= nil then
		v4610.kind = {
			type = "report_surface_load_time_milestone_action",
			value = t1.ReportSurfaceLoadTimeMilestoneAction.jsonDecode(t590.report_surface_load_time_milestone_action)
		}
	end

	if t590.reportSurfaceLoadTimeMilestoneAction ~= nil then
		v4610.kind = {
			type = "report_surface_load_time_milestone_action",
			value = t1.ReportSurfaceLoadTimeMilestoneAction.jsonDecode(t590.reportSurfaceLoadTimeMilestoneAction)
		}
	end

	if t590.open_search_results_tab_action ~= nil then
		v4610.kind = {
			type = "open_search_results_tab_action",
			value = t1.OpenSearchResultsTabAction.jsonDecode(t590.open_search_results_tab_action)
		}
	end

	if t590.openSearchResultsTabAction ~= nil then
		v4610.kind = {
			type = "open_search_results_tab_action",
			value = t1.OpenSearchResultsTabAction.jsonDecode(t590.openSearchResultsTabAction)
		}
	end

	if t590.open_phone_upsell_modal_action ~= nil then
		v4610.kind = {
			type = "open_phone_upsell_modal_action",
			value = t1.OpenPhoneUpsellModalAction.jsonDecode(t590.open_phone_upsell_modal_action)
		}
	end

	if t590.openPhoneUpsellModalAction ~= nil then
		v4610.kind = {
			type = "open_phone_upsell_modal_action",
			value = t1.OpenPhoneUpsellModalAction.jsonDecode(t590.openPhoneUpsellModalAction)
		}
	end

	if t590.open_email_upsell_modal_action ~= nil then
		v4610.kind = {
			type = "open_email_upsell_modal_action",
			value = t1.OpenEmailUpsellModalAction.jsonDecode(t590.open_email_upsell_modal_action)
		}
	end

	if t590.openEmailUpsellModalAction ~= nil then
		v4610.kind = {
			type = "open_email_upsell_modal_action",
			value = t1.OpenEmailUpsellModalAction.jsonDecode(t590.openEmailUpsellModalAction)
		}
	end

	if t590.dismiss_prompt_action ~= nil then
		v4610.kind = {
			type = "dismiss_prompt_action",
			value = t1.DismissPromptAction.jsonDecode(t590.dismiss_prompt_action)
		}
	end

	if t590.dismissPromptAction ~= nil then
		v4610.kind = {
			type = "dismiss_prompt_action",
			value = t1.DismissPromptAction.jsonDecode(t590.dismissPromptAction)
		}
	end

	if t590.request_friendship_action ~= nil then
		v4610.kind = {
			type = "request_friendship_action",
			value = t1.RequestFriendshipAction.jsonDecode(t590.request_friendship_action)
		}
	end

	if t590.requestFriendshipAction ~= nil then
		v4610.kind = {
			type = "request_friendship_action",
			value = t1.RequestFriendshipAction.jsonDecode(t590.requestFriendshipAction)
		}
	end

	if t590.refresh_developer_products_action ~= nil then
		v4610.kind = {
			type = "refresh_developer_products_action",
			value = t1.RefreshDeveloperProductsAction.jsonDecode(t590.refresh_developer_products_action)
		}
	end

	if t590.refreshDeveloperProductsAction ~= nil then
		v4610.kind = {
			type = "refresh_developer_products_action",
			value = t1.RefreshDeveloperProductsAction.jsonDecode(t590.refreshDeveloperProductsAction)
		}
	end

	if t590.open_fae_trial_upsell_action ~= nil then
		v4610.kind = {
			type = "open_fae_trial_upsell_action",
			value = t1.OpenFaeTrialUpsellAction.jsonDecode(t590.open_fae_trial_upsell_action)
		}
	end

	if t590.openFaeTrialUpsellAction ~= nil then
		v4610.kind = {
			type = "open_fae_trial_upsell_action",
			value = t1.OpenFaeTrialUpsellAction.jsonDecode(t590.openFaeTrialUpsellAction)
		}
	end

	if t590.refresh_omni_recommendation_feed_item_action ~= nil then
		v4610.kind = {
			type = "refresh_omni_recommendation_feed_item_action",
			value = t1.RefreshOmniRecommendationFeedItemAction.jsonDecode(t590.refresh_omni_recommendation_feed_item_action)
		}
	end

	if t590.refreshOmniRecommendationFeedItemAction ~= nil then
		v4610.kind = {
			type = "refresh_omni_recommendation_feed_item_action",
			value = t1.RefreshOmniRecommendationFeedItemAction.jsonDecode(t590.refreshOmniRecommendationFeedItemAction)
		}
	end

	if t590.ai_overview_feedback_action ~= nil then
		v4610.kind = {
			type = "ai_overview_feedback_action",
			value = t1.AiOverviewFeedbackAction.jsonDecode(t590.ai_overview_feedback_action)
		}
	end

	if t590.aiOverviewFeedbackAction ~= nil then
		v4610.kind = {
			type = "ai_overview_feedback_action",
			value = t1.AiOverviewFeedbackAction.jsonDecode(t590.aiOverviewFeedbackAction)
		}
	end

	if t590.open_trusted_friends_upsell_modal_action ~= nil then
		v4610.kind = {
			type = "open_trusted_friends_upsell_modal_action",
			value = t1.OpenTrustedFriendsUpsellModalAction.jsonDecode(t590.open_trusted_friends_upsell_modal_action)
		}
	end

	if t590.openTrustedFriendsUpsellModalAction ~= nil then
		v4610.kind = {
			type = "open_trusted_friends_upsell_modal_action",
			value = t1.OpenTrustedFriendsUpsellModalAction.jsonDecode(t590.openTrustedFriendsUpsellModalAction)
		}
	end

	if t590.record_party_chat_conversation_upsell_acknowledgement_action ~= nil then
		v4610.kind = {
			type = "record_party_chat_conversation_upsell_acknowledgement_action",
			value = t1.RecordPartyChatConversationUpsellAcknowledgementAction.jsonDecode(t590.record_party_chat_conversation_upsell_acknowledgement_action)
		}
	end

	if t590.recordPartyChatConversationUpsellAcknowledgementAction ~= nil then
		v4610.kind = {
			type = "record_party_chat_conversation_upsell_acknowledgement_action",
			value = t1.RecordPartyChatConversationUpsellAcknowledgementAction.jsonDecode(t590.recordPartyChatConversationUpsellAcknowledgementAction)
		}
	end

	if t590.open_search_results_with_query_action ~= nil then
		v4610.kind = {
			type = "open_search_results_with_query_action",
			value = t1.OpenSearchResultsWithQueryAction.jsonDecode(t590.open_search_results_with_query_action)
		}
	end

	if t590.openSearchResultsWithQueryAction ~= nil then
		v4610.kind = {
			type = "open_search_results_with_query_action",
			value = t1.OpenSearchResultsWithQueryAction.jsonDecode(t590.openSearchResultsWithQueryAction)
		}
	end

	if t590.select_marketplace_favorites_category ~= nil then
		v4610.kind = {
			type = "select_marketplace_favorites_category",
			value = t1.SelectMarketplaceFavoritesCategory.jsonDecode(t590.select_marketplace_favorites_category)
		}
	end

	if t590.selectMarketplaceFavoritesCategory ~= nil then
		v4610.kind = {
			type = "select_marketplace_favorites_category",
			value = t1.SelectMarketplaceFavoritesCategory.jsonDecode(t590.selectMarketplaceFavoritesCategory)
		}
	end

	if t590.download_app_action ~= nil then
		v4610.kind = {
			type = "download_app_action",
			value = t1.DownloadAppAction.jsonDecode(t590.download_app_action)
		}
	end

	if t590.downloadAppAction ~= nil then
		v4610.kind = {
			type = "download_app_action",
			value = t1.DownloadAppAction.jsonDecode(t590.downloadAppAction)
		}
	end

	if t590.telemetry_handler ~= nil then
		v4610.telemetry_handler = prop_types.StringProp.jsonDecode(t590.telemetry_handler)
	end

	if t590.telemetryHandler ~= nil then
		v4610.telemetry_handler = prop_types.StringProp.jsonDecode(t590.telemetryHandler)
	end

	if t590.accessibility_label ~= nil then
		v4610.accessibility_label = prop_types.StringFormat.jsonDecode(t590.accessibility_label)
	end

	if t590.accessibilityLabel ~= nil then
		v4610.accessibility_label = prop_types.StringFormat.jsonDecode(t590.accessibilityLabel)
	end

	return v4610
end

t587.descriptor = {
	name = "Action",
	fullName = "roblox.apppageplatform.shared.v1beta1.Action"
}
t1.Action = t587
typeRegistry.default:register(t1.Action)

local t591 = {}

t591.__index = t591

function t591.new(t592: {[any]: any}?) -- line: 29022
	-- upvalues: t591 (copy)
	return (setmetatable({
		kind = if t592 ~= nil and t592.kind ~= nil then t592.kind else nil
	}, t591))
end
function t591.encode(p445) -- line: 29028
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n294 = 0

	if p445.kind ~= nil then
		if p445.kind.type == "value" then
			local v4615 = p445.kind.value:encode()
			local v4616, v4617 = proto.writeTag(buf, n294, 1, proto.wireTypes.lengthDelimited)

			buf, n294 = proto.writeBuffer(v4616, v4617, v4615, buffer.len(v4615))
		elseif p445.kind.type == "conditional" then
			local v4618 = p445.kind.value:encode()
			local v4619, v4620 = proto.writeTag(buf, n294, 2, proto.wireTypes.lengthDelimited)

			buf, n294 = proto.writeBuffer(v4619, v4620, v4618, buffer.len(v4618))
		end
	end

	local buf150 = buffer.create(n294)

	buffer.copy(buf150, 0, buf, 0, n294)

	return buf150
end
function t591.decode(p446: buffer) -- line: 29049
	-- upvalues: t591 (copy), proto (copy), t1 (copy)
	local v4623 = t591.new()
	local n295 = 0

	while n295 < buffer.len(p446) do
		local v4625, v4626

		v4625, v4626, n295 = proto.readTag(p446, n295)

		if v4626 == proto.wireTypes.varint then
			local v4627

			v4627, n295 = proto.readVarInt(p446, n295)
		elseif v4626 == proto.wireTypes.lengthDelimited then
			if v4625 == 1 then
				local v4628

				v4628, n295 = proto.readBuffer(p446, n295)
				v4623.kind = {
					type = "value",
					value = t1.Action.decode(v4628)
				}
			elseif v4625 == 2 then
				local v4629

				v4629, n295 = proto.readBuffer(p446, n295)
				v4623.kind = {
					type = "conditional",
					value = t1.ActionProp_ConditionalOptions.decode(v4629)
				}
			else
				local v4630, v4631 = proto.readVarInt(p446, n295)

				n295 = v4631 + v4630
			end
		elseif v4626 == proto.wireTypes.i32 then
			local v4632

			v4632, n295 = proto.readFixed32(p446, n295)
		elseif v4626 == proto.wireTypes.i64 then
			local v4633

			v4633, n295 = proto.readFixed64(p446, n295)
		else
			error("Unsupported wire type: " .. v4626)
		end
	end

	return v4623
end
function t591.jsonEncode(p447) -- line: 29097
	local t593 = {}

	if p447.kind ~= nil then
		if p447.kind.type == "value" then
			t593.value = p447.kind.value:jsonEncode()

			return t593
		end

		if p447.kind.type == "conditional" then
			t593.conditional = p447.kind.value:jsonEncode()
		end
	end

	return t593
end
function t591.jsonDecode(t594: {[any]: any}) -- line: 29111
	-- upvalues: t591 (copy), t1 (copy)
	local v4637 = t591.new()

	if t594.value ~= nil then
		v4637.kind = {
			type = "value",
			value = t1.Action.jsonDecode(t594.value)
		}
	end

	if t594.conditional ~= nil then
		v4637.kind = {
			type = "conditional",
			value = t1.ActionProp_ConditionalOptions.jsonDecode(t594.conditional)
		}
	end

	return v4637
end

t591.descriptor = {
	name = "ActionProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.ActionProp"
}
t1.ActionProp = t591
typeRegistry.default:register(t1.ActionProp)

local t595 = {}

t595.__index = t595

function t595.new(t596: {[any]: any}?) -- line: 29140
	-- upvalues: t595 (copy)
	return (setmetatable({
		condition = if t596 ~= nil and t596.condition ~= nil then t596.condition else nil,
		kind = if t596 ~= nil and t596.kind ~= nil then t596.kind else nil
	}, t595))
end
function t595.encode(p448) -- line: 29149
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n296 = 0

	if p448.condition ~= nil then
		local v4642 = p448.condition:encode()
		local v4643, v4644 = proto.writeTag(buf, n296, 1, proto.wireTypes.lengthDelimited)

		buf, n296 = proto.writeBuffer(v4643, v4644, v4642, buffer.len(v4642))
	end

	if p448.kind ~= nil and p448.kind.type == "value" then
		local v4645 = p448.kind.value:encode()
		local v4646, v4647 = proto.writeTag(buf, n296, 3, proto.wireTypes.lengthDelimited)

		buf, n296 = proto.writeBuffer(v4646, v4647, v4645, buffer.len(v4645))
	end

	local buf151 = buffer.create(n296)

	buffer.copy(buf151, 0, buf, 0, n296)

	return buf151
end
function t595.decode(p449: buffer) -- line: 29172
	-- upvalues: t595 (copy), proto (copy), prop_condition (copy), t1 (copy)
	local v4650 = t595.new()
	local n297 = 0

	while n297 < buffer.len(p449) do
		local v4652, v4653

		v4652, v4653, n297 = proto.readTag(p449, n297)

		if v4653 == proto.wireTypes.varint then
			local v4654

			v4654, n297 = proto.readVarInt(p449, n297)
		elseif v4653 == proto.wireTypes.lengthDelimited then
			if v4652 == 1 then
				local v4655

				v4655, n297 = proto.readBuffer(p449, n297)
				v4650.condition = prop_condition.PropCondition.decode(v4655)
			elseif v4652 == 3 then
				local v4656

				v4656, n297 = proto.readBuffer(p449, n297)
				v4650.kind = {
					type = "value",
					value = t1.Action.decode(v4656)
				}
			else
				local v4657, v4658 = proto.readVarInt(p449, n297)

				n297 = v4658 + v4657
			end
		elseif v4653 == proto.wireTypes.i32 then
			local v4659

			v4659, n297 = proto.readFixed32(p449, n297)
		elseif v4653 == proto.wireTypes.i64 then
			local v4660

			v4660, n297 = proto.readFixed64(p449, n297)
		else
			error("Unsupported wire type: " .. v4653)
		end
	end

	return v4650
end
function t595.jsonEncode(p450) -- line: 29220
	local t597 = {}

	if p450.condition ~= nil then
		t597.condition = p450.condition:jsonEncode()
	end

	if p450.kind ~= nil and p450.kind.type == "value" then
		t597.value = p450.kind.value:jsonEncode()
	end

	return t597
end
function t595.jsonDecode(t598: {[any]: any}) -- line: 29236
	-- upvalues: t595 (copy), prop_condition (copy), t1 (copy)
	local v4664 = t595.new()

	if t598.condition ~= nil then
		v4664.condition = prop_condition.PropCondition.jsonDecode(t598.condition)
	end

	if t598.value ~= nil then
		v4664.kind = {
			type = "value",
			value = t1.Action.jsonDecode(t598.value)
		}
	end

	return v4664
end

t595.descriptor = {
	name = "ActionProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.ActionProp_ConditionalOption = t595
typeRegistry.default:register(t1.ActionProp_ConditionalOption)

local t599 = {}

t599.__index = t599

function t599.new(t600: {[any]: any}?) -- line: 29265
	-- upvalues: t599 (copy)
	return (setmetatable({
		options = if t600 ~= nil and t600.options ~= nil then t600.options else {}
	}, t599))
end
function t599.encode(p451) -- line: 29273
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n298 = 0

	if p451.options ~= nil and #p451.options > 0 then
		for _, v4670 in p451.options do
			local v4671 = v4670:encode()
			local v4672, v4673 = proto.writeTag(buf, n298, 1, proto.wireTypes.lengthDelimited)

			buf, n298 = proto.writeBuffer(v4672, v4673, v4671, buffer.len(v4671))
		end
	end

	local buf152 = buffer.create(n298)

	buffer.copy(buf152, 0, buf, 0, n298)

	return buf152
end
function t599.decode(p452: buffer) -- line: 29290
	-- upvalues: t599 (copy), proto (copy), t1 (copy)
	local v4676 = t599.new()
	local n299 = 0

	while n299 < buffer.len(p452) do
		local v4678, v4679

		v4678, v4679, n299 = proto.readTag(p452, n299)

		if v4679 == proto.wireTypes.varint then
			local v4680

			v4680, n299 = proto.readVarInt(p452, n299)
		elseif v4679 == proto.wireTypes.lengthDelimited then
			if v4678 == 1 then
				local v4681

				v4681, n299 = proto.readBuffer(p452, n299)
				table.insert(v4676.options, t1.ActionProp_ConditionalOption.decode(v4681))
			else
				local v4682, v4683 = proto.readVarInt(p452, n299)

				n299 = v4683 + v4682
			end
		elseif v4679 == proto.wireTypes.i32 then
			local v4684

			v4684, n299 = proto.readFixed32(p452, n299)
		elseif v4679 == proto.wireTypes.i64 then
			local v4685

			v4685, n299 = proto.readFixed64(p452, n299)
		else
			error("Unsupported wire type: " .. v4679)
		end
	end

	return v4676
end
function t599.jsonEncode(p453) -- line: 29333
	local t601 = {}

	if p453.options ~= nil and #p453.options > 0 then
		local t602 = {}

		for _, v4690 in p453.options do
			table.insert(t602, v4690:jsonEncode())
		end

		t601.options = t602
	end

	return t601
end
function t599.jsonDecode(t603: {[any]: any}) -- line: 29347
	-- upvalues: t599 (copy), t1 (copy)
	local v4692 = t599.new()

	if t603.options ~= nil then
		local t604 = {}

		for _, v4695 in t603.options do
			table.insert(t604, t1.ActionProp_ConditionalOption.jsonDecode(v4695))
		end

		v4692.options = t604
	end

	return v4692
end

t599.descriptor = {
	name = "ActionProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.ActionProp_ConditionalOptions = t599
typeRegistry.default:register(t1.ActionProp_ConditionalOptions)

local t605 = {}

t605.__index = t605

function t605.new(t606: {[any]: any}?) -- line: 29376
	-- upvalues: t605 (copy)
	return (setmetatable({
		kind = if t606 ~= nil and t606.kind ~= nil then t606.kind else nil
	}, t605))
end
function t605.encode(p454) -- line: 29382
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n300 = 0

	if p454.kind ~= nil then
		if p454.kind.type == "literal" then
			local v4700 = p454.kind.value:encode()
			local v4701, v4702 = proto.writeTag(buf, n300, 1, proto.wireTypes.lengthDelimited)

			buf, n300 = proto.writeBuffer(v4701, v4702, v4700, buffer.len(v4700))
		elseif p454.kind.type == "conditional" then
			local v4703 = p454.kind.value:encode()
			local v4704, v4705 = proto.writeTag(buf, n300, 2, proto.wireTypes.lengthDelimited)

			buf, n300 = proto.writeBuffer(v4704, v4705, v4703, buffer.len(v4703))
		elseif p454.kind.type == "binding_path" then
			local v4706, v4707 = proto.writeTag(buf, n300, 3, proto.wireTypes.lengthDelimited)

			buf, n300 = proto.writeString(v4706, v4707, p454.kind.value)
		end
	end

	local buf153 = buffer.create(n300)

	buffer.copy(buf153, 0, buf, 0, n300)

	return buf153
end
function t605.decode(p455: buffer) -- line: 29406
	-- upvalues: t605 (copy), proto (copy), t1 (copy)
	local v4710 = t605.new()
	local n301 = 0

	while n301 < buffer.len(p455) do
		local v4712, v4713

		v4712, v4713, n301 = proto.readTag(p455, n301)

		if v4713 == proto.wireTypes.varint then
			local v4714

			v4714, n301 = proto.readVarInt(p455, n301)
		elseif v4713 == proto.wireTypes.lengthDelimited then
			if v4712 == 1 then
				local v4715

				v4715, n301 = proto.readBuffer(p455, n301)
				v4710.kind = {
					type = "literal",
					value = t1.FocusNavActionsProp_FocusNavData.decode(v4715)
				}
			elseif v4712 == 2 then
				local v4716

				v4716, n301 = proto.readBuffer(p455, n301)
				v4710.kind = {
					type = "conditional",
					value = t1.FocusNavActionsProp_ConditionalOptions.decode(v4716)
				}
			elseif v4712 == 3 then
				local v4717

				v4717, n301 = proto.readBuffer(p455, n301)
				v4710.kind = {
					type = "binding_path",
					value = buffer.tostring(v4717)
				}
			else
				local v4718, v4719 = proto.readVarInt(p455, n301)

				n301 = v4719 + v4718
			end
		elseif v4713 == proto.wireTypes.i32 then
			local v4720

			v4720, n301 = proto.readFixed32(p455, n301)
		elseif v4713 == proto.wireTypes.i64 then
			local v4721

			v4721, n301 = proto.readFixed64(p455, n301)
		else
			error("Unsupported wire type: " .. v4713)
		end
	end

	return v4710
end
function t605.jsonEncode(p456) -- line: 29460
	local t607 = {}

	if p456.kind ~= nil then
		if p456.kind.type == "literal" then
			t607.literal = p456.kind.value:jsonEncode()

			return t607
		end

		if p456.kind.type == "conditional" then
			t607.conditional = p456.kind.value:jsonEncode()

			return t607
		end

		if p456.kind.type == "binding_path" then
			t607.bindingPath = p456.kind.value
		end
	end

	return t607
end
function t605.jsonDecode(t608: {[any]: any}) -- line: 29476
	-- upvalues: t605 (copy), t1 (copy)
	local v4725 = t605.new()

	if t608.literal ~= nil then
		v4725.kind = {
			type = "literal",
			value = t1.FocusNavActionsProp_FocusNavData.jsonDecode(t608.literal)
		}
	end

	if t608.conditional ~= nil then
		v4725.kind = {
			type = "conditional",
			value = t1.FocusNavActionsProp_ConditionalOptions.jsonDecode(t608.conditional)
		}
	end

	if t608.binding_path ~= nil then
		v4725.kind = {
			type = "binding_path",
			value = t608.binding_path
		}
	end

	if t608.bindingPath ~= nil then
		v4725.kind = {
			type = "binding_path",
			value = t608.bindingPath
		}
	end

	return v4725
end

t605.descriptor = {
	name = "FocusNavActionsProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.FocusNavActionsProp"
}
t1.FocusNavActionsProp = t605
typeRegistry.default:register(t1.FocusNavActionsProp)

local t609 = {}

t609.__index = t609

function t609.new(t610: {[any]: any}?) -- line: 29516
	-- upvalues: t609 (copy)
	return (setmetatable({
		condition = if t610 ~= nil and t610.condition ~= nil then t610.condition else nil,
		kind = if t610 ~= nil and t610.kind ~= nil then t610.kind else nil
	}, t609))
end
function t609.encode(p457) -- line: 29525
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n302 = 0

	if p457.condition ~= nil then
		local v4730 = p457.condition:encode()
		local v4731, v4732 = proto.writeTag(buf, n302, 1, proto.wireTypes.lengthDelimited)

		buf, n302 = proto.writeBuffer(v4731, v4732, v4730, buffer.len(v4730))
	end

	if p457.kind ~= nil then
		if p457.kind.type == "literal" then
			local v4733 = p457.kind.value:encode()
			local v4734, v4735 = proto.writeTag(buf, n302, 3, proto.wireTypes.lengthDelimited)

			buf, n302 = proto.writeBuffer(v4734, v4735, v4733, buffer.len(v4733))
		elseif p457.kind.type == "binding_path" then
			local v4736, v4737 = proto.writeTag(buf, n302, 4, proto.wireTypes.lengthDelimited)

			buf, n302 = proto.writeString(v4736, v4737, p457.kind.value)
		end
	end

	local buf154 = buffer.create(n302)

	buffer.copy(buf154, 0, buf, 0, n302)

	return buf154
end
function t609.decode(p458: buffer) -- line: 29551
	-- upvalues: t609 (copy), proto (copy), prop_condition (copy), t1 (copy)
	local v4740 = t609.new()
	local n303 = 0

	while n303 < buffer.len(p458) do
		local v4742, v4743

		v4742, v4743, n303 = proto.readTag(p458, n303)

		if v4743 == proto.wireTypes.varint then
			local v4744

			v4744, n303 = proto.readVarInt(p458, n303)
		elseif v4743 == proto.wireTypes.lengthDelimited then
			if v4742 == 1 then
				local v4745

				v4745, n303 = proto.readBuffer(p458, n303)
				v4740.condition = prop_condition.PropCondition.decode(v4745)
			elseif v4742 == 3 then
				local v4746

				v4746, n303 = proto.readBuffer(p458, n303)
				v4740.kind = {
					type = "literal",
					value = t1.FocusNavActionsProp_FocusNavData.decode(v4746)
				}
			elseif v4742 == 4 then
				local v4747

				v4747, n303 = proto.readBuffer(p458, n303)
				v4740.kind = {
					type = "binding_path",
					value = buffer.tostring(v4747)
				}
			else
				local v4748, v4749 = proto.readVarInt(p458, n303)

				n303 = v4749 + v4748
			end
		elseif v4743 == proto.wireTypes.i32 then
			local v4750

			v4750, n303 = proto.readFixed32(p458, n303)
		elseif v4743 == proto.wireTypes.i64 then
			local v4751

			v4751, n303 = proto.readFixed64(p458, n303)
		else
			error("Unsupported wire type: " .. v4743)
		end
	end

	return v4740
end
function t609.jsonEncode(p459) -- line: 29604
	local t611 = {}

	if p459.condition ~= nil then
		t611.condition = p459.condition:jsonEncode()
	end

	if p459.kind ~= nil then
		if p459.kind.type == "literal" then
			t611.literal = p459.kind.value:jsonEncode()

			return t611
		end

		if p459.kind.type == "binding_path" then
			t611.bindingPath = p459.kind.value
		end
	end

	return t611
end
function t609.jsonDecode(t612: {[any]: any}) -- line: 29622
	-- upvalues: t609 (copy), prop_condition (copy), t1 (copy)
	local v4755 = t609.new()

	if t612.condition ~= nil then
		v4755.condition = prop_condition.PropCondition.jsonDecode(t612.condition)
	end

	if t612.literal ~= nil then
		v4755.kind = {
			type = "literal",
			value = t1.FocusNavActionsProp_FocusNavData.jsonDecode(t612.literal)
		}
	end

	if t612.binding_path ~= nil then
		v4755.kind = {
			type = "binding_path",
			value = t612.binding_path
		}
	end

	if t612.bindingPath ~= nil then
		v4755.kind = {
			type = "binding_path",
			value = t612.bindingPath
		}
	end

	return v4755
end

t609.descriptor = {
	name = "FocusNavActionsProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.FocusNavActionsProp_ConditionalOption = t609
typeRegistry.default:register(t1.FocusNavActionsProp_ConditionalOption)

local t613 = {}

t613.__index = t613

function t613.new(t614: {[any]: any}?) -- line: 29662
	-- upvalues: t613 (copy)
	return (setmetatable({
		options = if t614 ~= nil and t614.options ~= nil then t614.options else {}
	}, t613))
end
function t613.encode(p460) -- line: 29670
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n304 = 0

	if p460.options ~= nil and #p460.options > 0 then
		for _, v4761 in p460.options do
			local v4762 = v4761:encode()
			local v4763, v4764 = proto.writeTag(buf, n304, 1, proto.wireTypes.lengthDelimited)

			buf, n304 = proto.writeBuffer(v4763, v4764, v4762, buffer.len(v4762))
		end
	end

	local buf155 = buffer.create(n304)

	buffer.copy(buf155, 0, buf, 0, n304)

	return buf155
end
function t613.decode(p461: buffer) -- line: 29687
	-- upvalues: t613 (copy), proto (copy), t1 (copy)
	local v4767 = t613.new()
	local n305 = 0

	while n305 < buffer.len(p461) do
		local v4769, v4770

		v4769, v4770, n305 = proto.readTag(p461, n305)

		if v4770 == proto.wireTypes.varint then
			local v4771

			v4771, n305 = proto.readVarInt(p461, n305)
		elseif v4770 == proto.wireTypes.lengthDelimited then
			if v4769 == 1 then
				local v4772

				v4772, n305 = proto.readBuffer(p461, n305)
				table.insert(v4767.options, t1.FocusNavActionsProp_ConditionalOption.decode(v4772))
			else
				local v4773, v4774 = proto.readVarInt(p461, n305)

				n305 = v4774 + v4773
			end
		elseif v4770 == proto.wireTypes.i32 then
			local v4775

			v4775, n305 = proto.readFixed32(p461, n305)
		elseif v4770 == proto.wireTypes.i64 then
			local v4776

			v4776, n305 = proto.readFixed64(p461, n305)
		else
			error("Unsupported wire type: " .. v4770)
		end
	end

	return v4767
end
function t613.jsonEncode(p462) -- line: 29730
	local t615 = {}

	if p462.options ~= nil and #p462.options > 0 then
		local t616 = {}

		for _, v4781 in p462.options do
			table.insert(t616, v4781:jsonEncode())
		end

		t615.options = t616
	end

	return t615
end
function t613.jsonDecode(t617: {[any]: any}) -- line: 29744
	-- upvalues: t613 (copy), t1 (copy)
	local v4783 = t613.new()

	if t617.options ~= nil then
		local t618 = {}

		for _, v4786 in t617.options do
			table.insert(t618, t1.FocusNavActionsProp_ConditionalOption.jsonDecode(v4786))
		end

		v4783.options = t618
	end

	return v4783
end

t613.descriptor = {
	name = "FocusNavActionsProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.FocusNavActionsProp_ConditionalOptions = t613
typeRegistry.default:register(t1.FocusNavActionsProp_ConditionalOptions)

local t619 = {}

t619.__index = t619

function t619.new(t620: {[any]: any}?) -- line: 29775
	-- upvalues: t619 (copy)
	return (setmetatable({
		keys = if t620 ~= nil and t620.keys ~= nil then t620.keys else {},
		events = if t620 ~= nil and t620.events ~= nil then t620.events else {}
	}, t619))
end
function t619.encode(p463) -- line: 29784
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n306 = 0

	if p463.keys ~= nil and next(p463.keys) ~= nil then
		for v4791, v4792 in p463.keys do
			local buf156 = buffer.create(0)
			local v4794, v4795 = proto.writeTag(buf156, 0, 1, proto.wireTypes.lengthDelimited)
			local v4796, v4797 = proto.writeString(v4794, v4795, v4791)
			local v4798 = v4792:encode()
			local v4799, v4800 = proto.writeTag(v4796, v4797, 2, proto.wireTypes.lengthDelimited)
			local v4801, v4802 = proto.writeBuffer(v4799, v4800, v4798, buffer.len(v4798))
			local v4803, v4804 = proto.writeTag(buf, n306, 3, proto.wireTypes.lengthDelimited)

			buf, n306 = proto.writeBuffer(v4803, v4804, v4801, v4802)
		end
	end

	if p463.events ~= nil and next(p463.events) ~= nil then
		for v4805, v4806 in p463.events do
			local buf157 = buffer.create(0)
			local v4808, v4809 = proto.writeTag(buf157, 0, 1, proto.wireTypes.lengthDelimited)
			local v4810, v4811 = proto.writeString(v4808, v4809, v4805)
			local v4812 = v4806:encode()
			local v4813, v4814 = proto.writeTag(v4810, v4811, 2, proto.wireTypes.lengthDelimited)
			local v4815, v4816 = proto.writeBuffer(v4813, v4814, v4812, buffer.len(v4812))
			local v4817, v4818 = proto.writeTag(buf, n306, 4, proto.wireTypes.lengthDelimited)

			buf, n306 = proto.writeBuffer(v4817, v4818, v4815, v4816)
		end
	end

	local buf158 = buffer.create(n306)

	buffer.copy(buf158, 0, buf, 0, n306)

	return buf158
end
function t619.decode(p464: buffer) -- line: 29821
	-- upvalues: t619 (copy), proto (copy), t1 (copy), prop_types_engine (copy)
	local v4821 = t619.new()
	local n307 = 0

	while n307 < buffer.len(p464) do
		local v4823, v4824

		v4823, v4824, n307 = proto.readTag(p464, n307)

		if v4824 == proto.wireTypes.varint then
			local v4825

			v4825, n307 = proto.readVarInt(p464, n307)
		elseif v4824 == proto.wireTypes.lengthDelimited then
			if v4823 == 3 then
				local v4826

				v4826, n307 = proto.readBuffer(p464, n307)

				local v4827 = t1.FocusNavActionsProp_FocusNavData_KeysEntry.decode(v4826)
				local v4828 = prop_types_engine.KeyCodeProp.new()

				v4821.keys[v4827.key or ""] = v4827.value or v4828
			elseif v4823 == 4 then
				local v4829

				v4829, n307 = proto.readBuffer(p464, n307)

				local v4830 = t1.FocusNavActionsProp_FocusNavData_EventsEntry.decode(v4829)
				local v4831 = t1.ActionProp.new()

				v4821.events[v4830.key or ""] = v4830.value or v4831
			else
				local v4832, v4833 = proto.readVarInt(p464, n307)

				n307 = v4833 + v4832
			end
		elseif v4824 == proto.wireTypes.i32 then
			local v4834

			v4834, n307 = proto.readFixed32(p464, n307)
		elseif v4824 == proto.wireTypes.i64 then
			local v4835

			v4835, n307 = proto.readFixed64(p464, n307)
		else
			error("Unsupported wire type: " .. v4824)
		end
	end

	return v4821
end
function t619.jsonEncode(p465) -- line: 29883
	local t621 = {}

	if p465.keys ~= nil and next(p465.keys) ~= nil then
		local t622 = {}

		for v4839, v4840 in p465.keys do
			t622[v4839] = v4840:jsonEncode()
		end

		t621.keys = t622
	end

	if p465.events ~= nil and next(p465.events) ~= nil then
		local t623 = {}

		for v4842, v4843 in p465.events do
			t623[v4842] = v4843:jsonEncode()
		end

		t621.events = t623
	end

	return t621
end
function t619.jsonDecode(t624: {[any]: any}) -- line: 29905
	-- upvalues: t619 (copy), prop_types_engine (copy), t1 (copy)
	local v4845 = t619.new()

	if t624.keys ~= nil then
		local t625 = {}

		for v4847, v4848 in t624.keys do
			t625[v4847] = prop_types_engine.KeyCodeProp.jsonDecode(v4848)
		end

		v4845.keys = t625
	end

	if t624.events ~= nil then
		local t626 = {}

		for v4850, v4851 in t624.events do
			t626[v4850] = t1.ActionProp.jsonDecode(v4851)
		end

		v4845.events = t626
	end

	return v4845
end

t619.descriptor = {
	name = "FocusNavActionsProp_FocusNavData",
	fullName = "roblox.apppageplatform.shared.v1beta1.FocusNavData"
}
t1.FocusNavActionsProp_FocusNavData = t619
typeRegistry.default:register(t1.FocusNavActionsProp_FocusNavData)

local t627 = {}

t627.__index = t627

function t627.new(t628: {[any]: any}?) -- line: 29945
	-- upvalues: t627 (copy)
	return (setmetatable({
		key = if t628 ~= nil and t628.key ~= nil then t628.key else "",
		value = if t628 ~= nil and t628.value ~= nil then t628.value else nil
	}, t627))
end
function t627.encode(p466) -- line: 29954
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n308 = 0

	if p466.key ~= nil and p466.key ~= "" then
		local v4856, v4857 = proto.writeTag(buf, n308, 1, proto.wireTypes.lengthDelimited)

		buf, n308 = proto.writeString(v4856, v4857, p466.key)
	end

	if p466.value ~= nil then
		local v4858 = p466.value:encode()
		local v4859, v4860 = proto.writeTag(buf, n308, 2, proto.wireTypes.lengthDelimited)

		buf, n308 = proto.writeBuffer(v4859, v4860, v4858, buffer.len(v4858))
	end

	local buf159 = buffer.create(n308)

	buffer.copy(buf159, 0, buf, 0, n308)

	return buf159
end
function t627.decode(p467: buffer) -- line: 29976
	-- upvalues: t627 (copy), proto (copy), prop_types_engine (copy)
	local v4863 = t627.new()
	local n309 = 0

	while n309 < buffer.len(p467) do
		local v4865, v4866

		v4865, v4866, n309 = proto.readTag(p467, n309)

		if v4866 == proto.wireTypes.varint then
			local v4867

			v4867, n309 = proto.readVarInt(p467, n309)
		elseif v4866 == proto.wireTypes.lengthDelimited then
			if v4865 == 1 then
				local v4868

				v4868, n309 = proto.readBuffer(p467, n309)
				v4863.key = buffer.tostring(v4868)
			elseif v4865 == 2 then
				local v4869

				v4869, n309 = proto.readBuffer(p467, n309)
				v4863.value = prop_types_engine.KeyCodeProp.decode(v4869)
			else
				local v4870, v4871 = proto.readVarInt(p467, n309)

				n309 = v4871 + v4870
			end
		elseif v4866 == proto.wireTypes.i32 then
			local v4872

			v4872, n309 = proto.readFixed32(p467, n309)
		elseif v4866 == proto.wireTypes.i64 then
			local v4873

			v4873, n309 = proto.readFixed64(p467, n309)
		else
			error("Unsupported wire type: " .. v4866)
		end
	end

	return v4863
end
function t627.jsonEncode(p468) -- line: 30026
	local t629 = {}

	if p468.key ~= nil and p468.key ~= "" then
		t629.key = p468.key
	end

	if p468.value ~= nil then
		t629.value = p468.value:jsonEncode()
	end

	return t629
end
function t627.jsonDecode(t630: {[any]: any}) -- line: 30042
	-- upvalues: t627 (copy), prop_types_engine (copy)
	local v4877 = t627.new()

	if t630.key ~= nil then
		v4877.key = t630.key
	end

	if t630.value ~= nil then
		v4877.value = prop_types_engine.KeyCodeProp.jsonDecode(t630.value)
	end

	return v4877
end

t627.descriptor = {
	name = "FocusNavActionsProp_FocusNavData_KeysEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.KeysEntry"
}
t1.FocusNavActionsProp_FocusNavData_KeysEntry = t627
typeRegistry.default:register(t1.FocusNavActionsProp_FocusNavData_KeysEntry)

local t631 = {}

t631.__index = t631

function t631.new(t632: {[any]: any}?) -- line: 30072
	-- upvalues: t631 (copy)
	return (setmetatable({
		key = if t632 ~= nil and t632.key ~= nil then t632.key else "",
		value = if t632 ~= nil and t632.value ~= nil then t632.value else nil
	}, t631))
end
function t631.encode(p469) -- line: 30081
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n310 = 0

	if p469.key ~= nil and p469.key ~= "" then
		local v4882, v4883 = proto.writeTag(buf, n310, 1, proto.wireTypes.lengthDelimited)

		buf, n310 = proto.writeString(v4882, v4883, p469.key)
	end

	if p469.value ~= nil then
		local v4884 = p469.value:encode()
		local v4885, v4886 = proto.writeTag(buf, n310, 2, proto.wireTypes.lengthDelimited)

		buf, n310 = proto.writeBuffer(v4885, v4886, v4884, buffer.len(v4884))
	end

	local buf160 = buffer.create(n310)

	buffer.copy(buf160, 0, buf, 0, n310)

	return buf160
end
function t631.decode(p470: buffer) -- line: 30103
	-- upvalues: t631 (copy), proto (copy), t1 (copy)
	local v4889 = t631.new()
	local n311 = 0

	while n311 < buffer.len(p470) do
		local v4891, v4892

		v4891, v4892, n311 = proto.readTag(p470, n311)

		if v4892 == proto.wireTypes.varint then
			local v4893

			v4893, n311 = proto.readVarInt(p470, n311)
		elseif v4892 == proto.wireTypes.lengthDelimited then
			if v4891 == 1 then
				local v4894

				v4894, n311 = proto.readBuffer(p470, n311)
				v4889.key = buffer.tostring(v4894)
			elseif v4891 == 2 then
				local v4895

				v4895, n311 = proto.readBuffer(p470, n311)
				v4889.value = t1.ActionProp.decode(v4895)
			else
				local v4896, v4897 = proto.readVarInt(p470, n311)

				n311 = v4897 + v4896
			end
		elseif v4892 == proto.wireTypes.i32 then
			local v4898

			v4898, n311 = proto.readFixed32(p470, n311)
		elseif v4892 == proto.wireTypes.i64 then
			local v4899

			v4899, n311 = proto.readFixed64(p470, n311)
		else
			error("Unsupported wire type: " .. v4892)
		end
	end

	return v4889
end
function t631.jsonEncode(p471) -- line: 30153
	local t633 = {}

	if p471.key ~= nil and p471.key ~= "" then
		t633.key = p471.key
	end

	if p471.value ~= nil then
		t633.value = p471.value:jsonEncode()
	end

	return t633
end
function t631.jsonDecode(t634: {[any]: any}) -- line: 30169
	-- upvalues: t631 (copy), t1 (copy)
	local v4903 = t631.new()

	if t634.key ~= nil then
		v4903.key = t634.key
	end

	if t634.value ~= nil then
		v4903.value = t1.ActionProp.jsonDecode(t634.value)
	end

	return v4903
end

t631.descriptor = {
	name = "FocusNavActionsProp_FocusNavData_EventsEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventsEntry"
}
t1.FocusNavActionsProp_FocusNavData_EventsEntry = t631
typeRegistry.default:register(t1.FocusNavActionsProp_FocusNavData_EventsEntry)
t1.ActionType = {
	fromNumber = function(n312: number) -- line: 30196
		if n312 == 0 then
			return "ACTION_TYPE_INVALID"
		end

		if n312 == 1 then
			return "ACTION_TYPE_DISMISS_DIALOG"
		end

		if n312 == 2 then
			return "ACTION_TYPE_LINK"
		end

		if n312 == 3 then
			return "ACTION_TYPE_OPEN_GAME_DETAILS"
		end

		if n312 == 4 then
			return "ACTION_TYPE_OPEN_JOIN_FRIENDS"
		end

		if n312 == 5 then
			return "ACTION_TYPE_OPEN_MARKETPLACE_TRY_ON"
		end

		if n312 == 6 then
			return "ACTION_TYPE_OPEN_SEE_ALL"
		end

		if n312 == 7 then
			return "ACTION_TYPE_OPEN_SPONSORED_TOOLTIP"
		end

		if n312 == 8 then
			return "ACTION_TYPE_PLAY_BUTTON_CLICK"
		end

		if n312 == 9 then
			return "ACTION_TYPE_UPDATE_USER_SETTINGS"
		end

		if n312 == 10 then
			return "ACTION_TYPE_OPEN_TOOLTIP"
		end

		if n312 == 11 then
			return "ACTION_TYPE_OPEN_BADGE_DETAILS"
		end

		if n312 == 12 then
			return "ACTION_TYPE_LOAD_MORE_FROM_API"
		end

		if n312 == 13 then
			return "ACTION_TYPE_SHARE"
		end

		if n312 == 14 then
			return "ACTION_TYPE_OPEN_ABUSE_REPORT"
		end

		if n312 == 15 then
			return "ACTION_TYPE_REMOVE_BADGE_FROM_INVENTORY"
		end

		if n312 == 16 then
			return "ACTION_TYPE_OPEN_PROFILE"
		end

		if n312 == 17 then
			return "ACTION_TYPE_OPEN_FACIAL_AGE_ESTIMATION"
		end

		if n312 == 18 then
			return "ACTION_TYPE_OPEN_ADD_CONNECTIONS_PAGE"
		end

		if n312 == 19 then
			return "ACTION_TYPE_OPEN_MARKETPLACE"
		end

		if n312 == 20 then
			return "ACTION_TYPE_HIDE_PROFILE_COMPLETION"
		end

		if n312 == 21 then
			return "ACTION_TYPE_SELECT_MARKETPLACE_CATALOG_CATEGORY"
		end

		if n312 == 22 then
			return "ACTION_TYPE_SELECT_MARKETPLACE_CATALOG_SUBCATEGORY"
		end

		if n312 == 23 then
			return "ACTION_TYPE_OPEN_MARKETPLACE_CATALOG_SEE_ALL"
		end

		if n312 == 24 then
			return "ACTION_TYPE_CLOSE_MARKETPLACE_CATEGORY_TOOLTIP"
		end

		if n312 == 25 then
			return "ACTION_TYPE_RESIZE_MARKETPLACE_CATALOG"
		end

		if n312 == 26 then
			return "ACTION_TYPE_OPEN_MARKETPLACE_CATALOG_FILTERS"
		end

		if n312 == 27 then
			return "ACTION_TYPE_OPEN_SOCIAL_LINK"
		end

		if n312 == 28 then
			return "ACTION_TYPE_OPEN_CHARTS_SORT_DETAIL"
		end

		if n312 == 29 then
			return "ACTION_TYPE_OPEN_SONG_DETAIL"
		end

		if n312 == 30 then
			return "ACTION_TYPE_REFRESH_FROM_API"
		end

		if n312 == 31 then
			return "ACTION_TYPE_RSVP_TO_EVENT"
		end

		if n312 == 32 then
			return "ACTION_TYPE_APPLY_CHARTS_FILTER"
		end

		if n312 == 33 then
			return "ACTION_TYPE_ANALYTICS_EVENT"
		end

		if n312 == 34 then
			return "ACTION_TYPE_CUSTOM_ANALYTICS_EVENT"
		end

		if n312 == 35 then
			return "ACTION_TYPE_OPEN_GAME_INVITE"
		end

		if n312 == 36 then
			return "ACTION_TYPE_OPEN_EVENT_DETAILS"
		end

		if n312 == 37 then
			return "ACTION_TYPE_LAUNCH_EXPERIENCE"
		end

		if n312 == 38 then
			return "ACTION_TYPE_TOGGLE_EXPERIENCE_FAVORITE"
		end

		if n312 == 39 then
			return "ACTION_TYPE_TOGGLE_EXPERIENCE_FOLLOW"
		end

		if n312 == 40 then
			return "ACTION_TYPE_TOGGLE_EXPERIENCE_VOTE"
		end

		if n312 == 41 then
			return "ACTION_TYPE_OPEN_PURCHASE_PROMPT"
		end

		if n312 == 42 then
			return "ACTION_TYPE_OPEN_SDUI_OVERLAY"
		end

		if n312 == 43 then
			return "ACTION_TYPE_OPEN_BADGES_SEE_ALL"
		end

		if n312 == 44 then
			return "ACTION_TYPE_OPEN_EXPERIENCE_STORE_SEE_ALL"
		end

		if n312 == 45 then
			return "ACTION_TYPE_DISMISS_GAME_FEEDBACK"
		end

		if n312 == 46 then
			return "ACTION_TYPE_OPEN_GAME_FEEDBACK_FORM"
		end

		if n312 == 47 then
			return "ACTION_TYPE_ENABLE_EVENT_NOTIFICATIONS"
		end

		if n312 == 48 then
			return "ACTION_TYPE_DISMISS_EVENT_NOTIFICATIONS_MODAL"
		end

		if n312 == 49 then
			return "ACTION_TYPE_OPEN_AMP_WIZARD"
		end

		if n312 == 50 then
			return "ACTION_TYPE_OPEN_SUBSCRIPTION_PURCHASE_PAGE"
		end

		if n312 == 51 then
			return "ACTION_TYPE_REFRESH_GAME_PASSES"
		end

		if n312 == 52 then
			return "ACTION_TYPE_REFRESH_PLAYABILITY"
		end

		if n312 == 53 then
			return "ACTION_TYPE_OPEN_SOCIAL_PROOF_USER_LIST_SHEET"
		end

		if n312 == 54 then
			return "ACTION_TYPE_REPORT_SURFACE_LOAD_TIME_MILESTONE"
		end

		if n312 == 55 then
			return "ACTION_TYPE_OPEN_SEARCH_RESULTS_TAB"
		end

		if n312 == 56 then
			return "ACTION_TYPE_OPEN_PHONE_UPSELL_MODAL"
		end

		if n312 == 57 then
			return "ACTION_TYPE_OPEN_EMAIL_UPSELL_MODAL"
		end

		if n312 == 58 then
			return "ACTION_TYPE_DISMISS_PROMPT"
		end

		if n312 == 59 then
			return "ACTION_TYPE_REQUEST_FRIENDSHIP"
		end

		if n312 == 60 then
			return "ACTION_TYPE_REFRESH_DEVELOPER_PRODUCTS"
		end

		if n312 == 61 then
			return "ACTION_TYPE_OPEN_FAE_TRIAL_UPSELL"
		end

		if n312 == 62 then
			return "ACTION_TYPE_REFRESH_OMNI_RECOMMENDATION_FEED_ITEM"
		end

		if n312 == 63 then
			return "ACTION_TYPE_AI_OVERVIEW_FEEDBACK"
		end

		if n312 == 64 then
			return "ACTION_TYPE_OPEN_TRUSTED_FRIENDS_UPSELL_MODAL"
		end

		if n312 == 65 then
			return "ACTION_TYPE_RECORD_PARTY_CHAT_CONVERSATION_UPSELL_ACKNOWLEDGEMENT"
		end

		if n312 == 66 then
			return "ACTION_TYPE_OPEN_SEARCH_RESULTS_WITH_QUERY"
		end

		if n312 == 67 then
			return "ACTION_TYPE_SELECT_MARKETPLACE_FAVORITES_CATEGORY"
		end

		if n312 == 68 then
			return "ACTION_TYPE_DOWNLOAD_APP"
		end

		return nil
	end,
	toNumber = function(p472) -- line: 30340
		if p472 == "ACTION_TYPE_INVALID" then
			return 0
		end

		if p472 == "ACTION_TYPE_DISMISS_DIALOG" then
			return 1
		end

		if p472 == "ACTION_TYPE_LINK" then
			return 2
		end

		if p472 == "ACTION_TYPE_OPEN_GAME_DETAILS" then
			return 3
		end

		if p472 == "ACTION_TYPE_OPEN_JOIN_FRIENDS" then
			return 4
		end

		if p472 == "ACTION_TYPE_OPEN_MARKETPLACE_TRY_ON" then
			return 5
		end

		if p472 == "ACTION_TYPE_OPEN_SEE_ALL" then
			return 6
		end

		if p472 == "ACTION_TYPE_OPEN_SPONSORED_TOOLTIP" then
			return 7
		end

		if p472 == "ACTION_TYPE_PLAY_BUTTON_CLICK" then
			return 8
		end

		if p472 == "ACTION_TYPE_UPDATE_USER_SETTINGS" then
			return 9
		end

		if p472 == "ACTION_TYPE_OPEN_TOOLTIP" then
			return 10
		end

		if p472 == "ACTION_TYPE_OPEN_BADGE_DETAILS" then
			return 11
		end

		if p472 == "ACTION_TYPE_LOAD_MORE_FROM_API" then
			return 12
		end

		if p472 == "ACTION_TYPE_SHARE" then
			return 13
		end

		if p472 == "ACTION_TYPE_OPEN_ABUSE_REPORT" then
			return 14
		end

		if p472 == "ACTION_TYPE_REMOVE_BADGE_FROM_INVENTORY" then
			return 15
		end

		if p472 == "ACTION_TYPE_OPEN_PROFILE" then
			return 16
		end

		if p472 == "ACTION_TYPE_OPEN_FACIAL_AGE_ESTIMATION" then
			return 17
		end

		if p472 == "ACTION_TYPE_OPEN_ADD_CONNECTIONS_PAGE" then
			return 18
		end

		if p472 == "ACTION_TYPE_OPEN_MARKETPLACE" then
			return 19
		end

		if p472 == "ACTION_TYPE_HIDE_PROFILE_COMPLETION" then
			return 20
		end

		if p472 == "ACTION_TYPE_SELECT_MARKETPLACE_CATALOG_CATEGORY" then
			return 21
		end

		if p472 == "ACTION_TYPE_SELECT_MARKETPLACE_CATALOG_SUBCATEGORY" then
			return 22
		end

		if p472 == "ACTION_TYPE_OPEN_MARKETPLACE_CATALOG_SEE_ALL" then
			return 23
		end

		if p472 == "ACTION_TYPE_CLOSE_MARKETPLACE_CATEGORY_TOOLTIP" then
			return 24
		end

		if p472 == "ACTION_TYPE_RESIZE_MARKETPLACE_CATALOG" then
			return 25
		end

		if p472 == "ACTION_TYPE_OPEN_MARKETPLACE_CATALOG_FILTERS" then
			return 26
		end

		if p472 == "ACTION_TYPE_OPEN_SOCIAL_LINK" then
			return 27
		end

		if p472 == "ACTION_TYPE_OPEN_CHARTS_SORT_DETAIL" then
			return 28
		end

		if p472 == "ACTION_TYPE_OPEN_SONG_DETAIL" then
			return 29
		end

		if p472 == "ACTION_TYPE_REFRESH_FROM_API" then
			return 30
		end

		if p472 == "ACTION_TYPE_RSVP_TO_EVENT" then
			return 31
		end

		if p472 == "ACTION_TYPE_APPLY_CHARTS_FILTER" then
			return 32
		end

		if p472 == "ACTION_TYPE_ANALYTICS_EVENT" then
			return 33
		end

		if p472 == "ACTION_TYPE_CUSTOM_ANALYTICS_EVENT" then
			return 34
		end

		if p472 == "ACTION_TYPE_OPEN_GAME_INVITE" then
			return 35
		end

		if p472 == "ACTION_TYPE_OPEN_EVENT_DETAILS" then
			return 36
		end

		if p472 == "ACTION_TYPE_LAUNCH_EXPERIENCE" then
			return 37
		end

		if p472 == "ACTION_TYPE_TOGGLE_EXPERIENCE_FAVORITE" then
			return 38
		end

		if p472 == "ACTION_TYPE_TOGGLE_EXPERIENCE_FOLLOW" then
			return 39
		end

		if p472 == "ACTION_TYPE_TOGGLE_EXPERIENCE_VOTE" then
			return 40
		end

		if p472 == "ACTION_TYPE_OPEN_PURCHASE_PROMPT" then
			return 41
		end

		if p472 == "ACTION_TYPE_OPEN_SDUI_OVERLAY" then
			return 42
		end

		if p472 == "ACTION_TYPE_OPEN_BADGES_SEE_ALL" then
			return 43
		end

		if p472 == "ACTION_TYPE_OPEN_EXPERIENCE_STORE_SEE_ALL" then
			return 44
		end

		if p472 == "ACTION_TYPE_DISMISS_GAME_FEEDBACK" then
			return 45
		end

		if p472 == "ACTION_TYPE_OPEN_GAME_FEEDBACK_FORM" then
			return 46
		end

		if p472 == "ACTION_TYPE_ENABLE_EVENT_NOTIFICATIONS" then
			return 47
		end

		if p472 == "ACTION_TYPE_DISMISS_EVENT_NOTIFICATIONS_MODAL" then
			return 48
		end

		if p472 == "ACTION_TYPE_OPEN_AMP_WIZARD" then
			return 49
		end

		if p472 == "ACTION_TYPE_OPEN_SUBSCRIPTION_PURCHASE_PAGE" then
			return 50
		end

		if p472 == "ACTION_TYPE_REFRESH_GAME_PASSES" then
			return 51
		end

		if p472 == "ACTION_TYPE_REFRESH_PLAYABILITY" then
			return 52
		end

		if p472 == "ACTION_TYPE_OPEN_SOCIAL_PROOF_USER_LIST_SHEET" then
			return 53
		end

		if p472 == "ACTION_TYPE_REPORT_SURFACE_LOAD_TIME_MILESTONE" then
			return 54
		end

		if p472 == "ACTION_TYPE_OPEN_SEARCH_RESULTS_TAB" then
			return 55
		end

		if p472 == "ACTION_TYPE_OPEN_PHONE_UPSELL_MODAL" then
			return 56
		end

		if p472 == "ACTION_TYPE_OPEN_EMAIL_UPSELL_MODAL" then
			return 57
		end

		if p472 == "ACTION_TYPE_DISMISS_PROMPT" then
			return 58
		end

		if p472 == "ACTION_TYPE_REQUEST_FRIENDSHIP" then
			return 59
		end

		if p472 == "ACTION_TYPE_REFRESH_DEVELOPER_PRODUCTS" then
			return 60
		end

		if p472 == "ACTION_TYPE_OPEN_FAE_TRIAL_UPSELL" then
			return 61
		end

		if p472 == "ACTION_TYPE_REFRESH_OMNI_RECOMMENDATION_FEED_ITEM" then
			return 62
		end

		if p472 == "ACTION_TYPE_AI_OVERVIEW_FEEDBACK" then
			return 63
		end

		if p472 == "ACTION_TYPE_OPEN_TRUSTED_FRIENDS_UPSELL_MODAL" then
			return 64
		end

		if p472 == "ACTION_TYPE_RECORD_PARTY_CHAT_CONVERSATION_UPSELL_ACKNOWLEDGEMENT" then
			return 65
		end

		if p472 == "ACTION_TYPE_OPEN_SEARCH_RESULTS_WITH_QUERY" then
			return 66
		end

		if p472 == "ACTION_TYPE_SELECT_MARKETPLACE_FAVORITES_CATEGORY" then
			return 67
		end

		if p472 == "ACTION_TYPE_DOWNLOAD_APP" then
			return 68
		end

		return p472
	end,
	fromName = function(s1: string) -- line: 30484
		if s1 == "ACTION_TYPE_INVALID" then
			return "ACTION_TYPE_INVALID"
		end

		if s1 == "ACTION_TYPE_DISMISS_DIALOG" then
			return "ACTION_TYPE_DISMISS_DIALOG"
		end

		if s1 == "ACTION_TYPE_LINK" then
			return "ACTION_TYPE_LINK"
		end

		if s1 == "ACTION_TYPE_OPEN_GAME_DETAILS" then
			return "ACTION_TYPE_OPEN_GAME_DETAILS"
		end

		if s1 == "ACTION_TYPE_OPEN_JOIN_FRIENDS" then
			return "ACTION_TYPE_OPEN_JOIN_FRIENDS"
		end

		if s1 == "ACTION_TYPE_OPEN_MARKETPLACE_TRY_ON" then
			return "ACTION_TYPE_OPEN_MARKETPLACE_TRY_ON"
		end

		if s1 == "ACTION_TYPE_OPEN_SEE_ALL" then
			return "ACTION_TYPE_OPEN_SEE_ALL"
		end

		if s1 == "ACTION_TYPE_OPEN_SPONSORED_TOOLTIP" then
			return "ACTION_TYPE_OPEN_SPONSORED_TOOLTIP"
		end

		if s1 == "ACTION_TYPE_PLAY_BUTTON_CLICK" then
			return "ACTION_TYPE_PLAY_BUTTON_CLICK"
		end

		if s1 == "ACTION_TYPE_UPDATE_USER_SETTINGS" then
			return "ACTION_TYPE_UPDATE_USER_SETTINGS"
		end

		if s1 == "ACTION_TYPE_OPEN_TOOLTIP" then
			return "ACTION_TYPE_OPEN_TOOLTIP"
		end

		if s1 == "ACTION_TYPE_OPEN_BADGE_DETAILS" then
			return "ACTION_TYPE_OPEN_BADGE_DETAILS"
		end

		if s1 == "ACTION_TYPE_LOAD_MORE_FROM_API" then
			return "ACTION_TYPE_LOAD_MORE_FROM_API"
		end

		if s1 == "ACTION_TYPE_SHARE" then
			return "ACTION_TYPE_SHARE"
		end

		if s1 == "ACTION_TYPE_OPEN_ABUSE_REPORT" then
			return "ACTION_TYPE_OPEN_ABUSE_REPORT"
		end

		if s1 == "ACTION_TYPE_REMOVE_BADGE_FROM_INVENTORY" then
			return "ACTION_TYPE_REMOVE_BADGE_FROM_INVENTORY"
		end

		if s1 == "ACTION_TYPE_OPEN_PROFILE" then
			return "ACTION_TYPE_OPEN_PROFILE"
		end

		if s1 == "ACTION_TYPE_OPEN_FACIAL_AGE_ESTIMATION" then
			return "ACTION_TYPE_OPEN_FACIAL_AGE_ESTIMATION"
		end

		if s1 == "ACTION_TYPE_OPEN_ADD_CONNECTIONS_PAGE" then
			return "ACTION_TYPE_OPEN_ADD_CONNECTIONS_PAGE"
		end

		if s1 == "ACTION_TYPE_OPEN_MARKETPLACE" then
			return "ACTION_TYPE_OPEN_MARKETPLACE"
		end

		if s1 == "ACTION_TYPE_HIDE_PROFILE_COMPLETION" then
			return "ACTION_TYPE_HIDE_PROFILE_COMPLETION"
		end

		if s1 == "ACTION_TYPE_SELECT_MARKETPLACE_CATALOG_CATEGORY" then
			return "ACTION_TYPE_SELECT_MARKETPLACE_CATALOG_CATEGORY"
		end

		if s1 == "ACTION_TYPE_SELECT_MARKETPLACE_CATALOG_SUBCATEGORY" then
			return "ACTION_TYPE_SELECT_MARKETPLACE_CATALOG_SUBCATEGORY"
		end

		if s1 == "ACTION_TYPE_OPEN_MARKETPLACE_CATALOG_SEE_ALL" then
			return "ACTION_TYPE_OPEN_MARKETPLACE_CATALOG_SEE_ALL"
		end

		if s1 == "ACTION_TYPE_CLOSE_MARKETPLACE_CATEGORY_TOOLTIP" then
			return "ACTION_TYPE_CLOSE_MARKETPLACE_CATEGORY_TOOLTIP"
		end

		if s1 == "ACTION_TYPE_RESIZE_MARKETPLACE_CATALOG" then
			return "ACTION_TYPE_RESIZE_MARKETPLACE_CATALOG"
		end

		if s1 == "ACTION_TYPE_OPEN_MARKETPLACE_CATALOG_FILTERS" then
			return "ACTION_TYPE_OPEN_MARKETPLACE_CATALOG_FILTERS"
		end

		if s1 == "ACTION_TYPE_OPEN_SOCIAL_LINK" then
			return "ACTION_TYPE_OPEN_SOCIAL_LINK"
		end

		if s1 == "ACTION_TYPE_OPEN_CHARTS_SORT_DETAIL" then
			return "ACTION_TYPE_OPEN_CHARTS_SORT_DETAIL"
		end

		if s1 == "ACTION_TYPE_OPEN_SONG_DETAIL" then
			return "ACTION_TYPE_OPEN_SONG_DETAIL"
		end

		if s1 == "ACTION_TYPE_REFRESH_FROM_API" then
			return "ACTION_TYPE_REFRESH_FROM_API"
		end

		if s1 == "ACTION_TYPE_RSVP_TO_EVENT" then
			return "ACTION_TYPE_RSVP_TO_EVENT"
		end

		if s1 == "ACTION_TYPE_APPLY_CHARTS_FILTER" then
			return "ACTION_TYPE_APPLY_CHARTS_FILTER"
		end

		if s1 == "ACTION_TYPE_ANALYTICS_EVENT" then
			return "ACTION_TYPE_ANALYTICS_EVENT"
		end

		if s1 == "ACTION_TYPE_CUSTOM_ANALYTICS_EVENT" then
			return "ACTION_TYPE_CUSTOM_ANALYTICS_EVENT"
		end

		if s1 == "ACTION_TYPE_OPEN_GAME_INVITE" then
			return "ACTION_TYPE_OPEN_GAME_INVITE"
		end

		if s1 == "ACTION_TYPE_OPEN_EVENT_DETAILS" then
			return "ACTION_TYPE_OPEN_EVENT_DETAILS"
		end

		if s1 == "ACTION_TYPE_LAUNCH_EXPERIENCE" then
			return "ACTION_TYPE_LAUNCH_EXPERIENCE"
		end

		if s1 == "ACTION_TYPE_TOGGLE_EXPERIENCE_FAVORITE" then
			return "ACTION_TYPE_TOGGLE_EXPERIENCE_FAVORITE"
		end

		if s1 == "ACTION_TYPE_TOGGLE_EXPERIENCE_FOLLOW" then
			return "ACTION_TYPE_TOGGLE_EXPERIENCE_FOLLOW"
		end

		if s1 == "ACTION_TYPE_TOGGLE_EXPERIENCE_VOTE" then
			return "ACTION_TYPE_TOGGLE_EXPERIENCE_VOTE"
		end

		if s1 == "ACTION_TYPE_OPEN_PURCHASE_PROMPT" then
			return "ACTION_TYPE_OPEN_PURCHASE_PROMPT"
		end

		if s1 == "ACTION_TYPE_OPEN_SDUI_OVERLAY" then
			return "ACTION_TYPE_OPEN_SDUI_OVERLAY"
		end

		if s1 == "ACTION_TYPE_OPEN_BADGES_SEE_ALL" then
			return "ACTION_TYPE_OPEN_BADGES_SEE_ALL"
		end

		if s1 == "ACTION_TYPE_OPEN_EXPERIENCE_STORE_SEE_ALL" then
			return "ACTION_TYPE_OPEN_EXPERIENCE_STORE_SEE_ALL"
		end

		if s1 == "ACTION_TYPE_DISMISS_GAME_FEEDBACK" then
			return "ACTION_TYPE_DISMISS_GAME_FEEDBACK"
		end

		if s1 == "ACTION_TYPE_OPEN_GAME_FEEDBACK_FORM" then
			return "ACTION_TYPE_OPEN_GAME_FEEDBACK_FORM"
		end

		if s1 == "ACTION_TYPE_ENABLE_EVENT_NOTIFICATIONS" then
			return "ACTION_TYPE_ENABLE_EVENT_NOTIFICATIONS"
		end

		if s1 == "ACTION_TYPE_DISMISS_EVENT_NOTIFICATIONS_MODAL" then
			return "ACTION_TYPE_DISMISS_EVENT_NOTIFICATIONS_MODAL"
		end

		if s1 == "ACTION_TYPE_OPEN_AMP_WIZARD" then
			return "ACTION_TYPE_OPEN_AMP_WIZARD"
		end

		if s1 == "ACTION_TYPE_OPEN_SUBSCRIPTION_PURCHASE_PAGE" then
			return "ACTION_TYPE_OPEN_SUBSCRIPTION_PURCHASE_PAGE"
		end

		if s1 == "ACTION_TYPE_REFRESH_GAME_PASSES" then
			return "ACTION_TYPE_REFRESH_GAME_PASSES"
		end

		if s1 == "ACTION_TYPE_REFRESH_PLAYABILITY" then
			return "ACTION_TYPE_REFRESH_PLAYABILITY"
		end

		if s1 == "ACTION_TYPE_OPEN_SOCIAL_PROOF_USER_LIST_SHEET" then
			return "ACTION_TYPE_OPEN_SOCIAL_PROOF_USER_LIST_SHEET"
		end

		if s1 == "ACTION_TYPE_REPORT_SURFACE_LOAD_TIME_MILESTONE" then
			return "ACTION_TYPE_REPORT_SURFACE_LOAD_TIME_MILESTONE"
		end

		if s1 == "ACTION_TYPE_OPEN_SEARCH_RESULTS_TAB" then
			return "ACTION_TYPE_OPEN_SEARCH_RESULTS_TAB"
		end

		if s1 == "ACTION_TYPE_OPEN_PHONE_UPSELL_MODAL" then
			return "ACTION_TYPE_OPEN_PHONE_UPSELL_MODAL"
		end

		if s1 == "ACTION_TYPE_OPEN_EMAIL_UPSELL_MODAL" then
			return "ACTION_TYPE_OPEN_EMAIL_UPSELL_MODAL"
		end

		if s1 == "ACTION_TYPE_DISMISS_PROMPT" then
			return "ACTION_TYPE_DISMISS_PROMPT"
		end

		if s1 == "ACTION_TYPE_REQUEST_FRIENDSHIP" then
			return "ACTION_TYPE_REQUEST_FRIENDSHIP"
		end

		if s1 == "ACTION_TYPE_REFRESH_DEVELOPER_PRODUCTS" then
			return "ACTION_TYPE_REFRESH_DEVELOPER_PRODUCTS"
		end

		if s1 == "ACTION_TYPE_OPEN_FAE_TRIAL_UPSELL" then
			return "ACTION_TYPE_OPEN_FAE_TRIAL_UPSELL"
		end

		if s1 == "ACTION_TYPE_REFRESH_OMNI_RECOMMENDATION_FEED_ITEM" then
			return "ACTION_TYPE_REFRESH_OMNI_RECOMMENDATION_FEED_ITEM"
		end

		if s1 == "ACTION_TYPE_AI_OVERVIEW_FEEDBACK" then
			return "ACTION_TYPE_AI_OVERVIEW_FEEDBACK"
		end

		if s1 == "ACTION_TYPE_OPEN_TRUSTED_FRIENDS_UPSELL_MODAL" then
			return "ACTION_TYPE_OPEN_TRUSTED_FRIENDS_UPSELL_MODAL"
		end

		if s1 == "ACTION_TYPE_RECORD_PARTY_CHAT_CONVERSATION_UPSELL_ACKNOWLEDGEMENT" then
			return "ACTION_TYPE_RECORD_PARTY_CHAT_CONVERSATION_UPSELL_ACKNOWLEDGEMENT"
		end

		if s1 == "ACTION_TYPE_OPEN_SEARCH_RESULTS_WITH_QUERY" then
			return "ACTION_TYPE_OPEN_SEARCH_RESULTS_WITH_QUERY"
		end

		if s1 == "ACTION_TYPE_SELECT_MARKETPLACE_FAVORITES_CATEGORY" then
			return "ACTION_TYPE_SELECT_MARKETPLACE_FAVORITES_CATEGORY"
		end

		if s1 == "ACTION_TYPE_DOWNLOAD_APP" then
			return "ACTION_TYPE_DOWNLOAD_APP"
		end

		return nil
	end
}

return {
	DismissDialogAction = t1.DismissDialogAction,
	DismissDialogAction_Params = t1.DismissDialogAction_Params,
	LinkAction = t1.LinkAction,
	LinkAction_Params = t1.LinkAction_Params,
	OpenSocialLinkAction = t1.OpenSocialLinkAction,
	OpenSocialLinkAction_Params = t1.OpenSocialLinkAction_Params,
	OpenGameDetailsAction = t1.OpenGameDetailsAction,
	OpenGameDetailsAction_Params = t1.OpenGameDetailsAction_Params,
	OpenJoinFriendsAction = t1.OpenJoinFriendsAction,
	OpenJoinFriendsAction_Params = t1.OpenJoinFriendsAction_Params,
	OpenMarketplaceTryOnAction = t1.OpenMarketplaceTryOnAction,
	OpenMarketplaceTryOnAction_Params = t1.OpenMarketplaceTryOnAction_Params,
	OpenSeeAllAction = t1.OpenSeeAllAction,
	OpenSeeAllAction_Params = t1.OpenSeeAllAction_Params,
	OpenSponsoredTooltipAction = t1.OpenSponsoredTooltipAction,
	OpenSponsoredTooltipAction_Params = t1.OpenSponsoredTooltipAction_Params,
	PlayButtonClickAction = t1.PlayButtonClickAction,
	PlayButtonClickAction_Params = t1.PlayButtonClickAction_Params,
	UpdateUserSettingsAction = t1.UpdateUserSettingsAction,
	UpdateUserSettingsAction_Params = t1.UpdateUserSettingsAction_Params,
	OpenTooltipAction = t1.OpenTooltipAction,
	OpenTooltipAction_Params = t1.OpenTooltipAction_Params,
	OpenBadgeDetailsAction = t1.OpenBadgeDetailsAction,
	OpenBadgeDetailsAction_Params = t1.OpenBadgeDetailsAction_Params,
	LoadMoreFromApiAction = t1.LoadMoreFromApiAction,
	LoadMoreFromApiAction_Params = t1.LoadMoreFromApiAction_Params,
	ShareAction = t1.ShareAction,
	ShareAction_ShareLinkData = t1.ShareAction_ShareLinkData,
	ShareAction_Params = t1.ShareAction_Params,
	OpenAbuseReportAction = t1.OpenAbuseReportAction,
	OpenAbuseReportAction_Params = t1.OpenAbuseReportAction_Params,
	RemoveBadgeFromInventoryAction = t1.RemoveBadgeFromInventoryAction,
	RemoveBadgeFromInventoryAction_Params = t1.RemoveBadgeFromInventoryAction_Params,
	OpenProfileAction = t1.OpenProfileAction,
	OpenProfileAction_Params = t1.OpenProfileAction_Params,
	OpenFacialAgeEstimationAction = t1.OpenFacialAgeEstimationAction,
	OpenFacialAgeEstimationAction_Params = t1.OpenFacialAgeEstimationAction_Params,
	OpenPhoneUpsellModalAction = t1.OpenPhoneUpsellModalAction,
	OpenPhoneUpsellModalAction_Params = t1.OpenPhoneUpsellModalAction_Params,
	OpenEmailUpsellModalAction = t1.OpenEmailUpsellModalAction,
	OpenEmailUpsellModalAction_Params = t1.OpenEmailUpsellModalAction_Params,
	OpenAddConnectionsPageAction = t1.OpenAddConnectionsPageAction,
	OpenAddConnectionsPageAction_Params = t1.OpenAddConnectionsPageAction_Params,
	OpenMarketplaceAction = t1.OpenMarketplaceAction,
	OpenMarketplaceAction_Params = t1.OpenMarketplaceAction_Params,
	HideProfileCompletionAction = t1.HideProfileCompletionAction,
	HideProfileCompletionAction_Params = t1.HideProfileCompletionAction_Params,
	SelectMarketplaceCatalogCategory = t1.SelectMarketplaceCatalogCategory,
	SelectMarketplaceCatalogCategory_Params = t1.SelectMarketplaceCatalogCategory_Params,
	SelectMarketplaceCatalogSubcategory = t1.SelectMarketplaceCatalogSubcategory,
	SelectMarketplaceCatalogSubcategory_Params = t1.SelectMarketplaceCatalogSubcategory_Params,
	OpenMarketplaceCatalogSeeAll = t1.OpenMarketplaceCatalogSeeAll,
	OpenMarketplaceCatalogSeeAll_Params = t1.OpenMarketplaceCatalogSeeAll_Params,
	CloseMarketplaceCategoryTooltip = t1.CloseMarketplaceCategoryTooltip,
	CloseMarketplaceCategoryTooltip_Params = t1.CloseMarketplaceCategoryTooltip_Params,
	ResizeMarketplaceCatalog = t1.ResizeMarketplaceCatalog,
	ResizeMarketplaceCatalog_Params = t1.ResizeMarketplaceCatalog_Params,
	OpenChartsSortDetailAction = t1.OpenChartsSortDetailAction,
	OpenChartsSortDetailAction_Params = t1.OpenChartsSortDetailAction_Params,
	OpenSongDetailAction = t1.OpenSongDetailAction,
	OpenSongDetailAction_Params = t1.OpenSongDetailAction_Params,
	OpenMarketplaceCatalogFilters = t1.OpenMarketplaceCatalogFilters,
	OpenMarketplaceCatalogFilters_Params = t1.OpenMarketplaceCatalogFilters_Params,
	RefreshFromApiAction = t1.RefreshFromApiAction,
	RefreshFromApiAction_Params = t1.RefreshFromApiAction_Params,
	RefreshOmniRecommendationFeedItemAction = t1.RefreshOmniRecommendationFeedItemAction,
	RefreshOmniRecommendationFeedItemAction_Params = t1.RefreshOmniRecommendationFeedItemAction_Params,
	RsvpToEventAction = t1.RsvpToEventAction,
	RsvpToEventAction_Params = t1.RsvpToEventAction_Params,
	OpenEventDetailsAction = t1.OpenEventDetailsAction,
	OpenEventDetailsAction_Params = t1.OpenEventDetailsAction_Params,
	OpenBadgesSeeAllAction = t1.OpenBadgesSeeAllAction,
	OpenBadgesSeeAllAction_Params = t1.OpenBadgesSeeAllAction_Params,
	OpenExperienceStoreSeeAllAction = t1.OpenExperienceStoreSeeAllAction,
	OpenExperienceStoreSeeAllAction_Params = t1.OpenExperienceStoreSeeAllAction_Params,
	OpenSubscriptionPurchasePageAction = t1.OpenSubscriptionPurchasePageAction,
	OpenSubscriptionPurchasePageAction_Params = t1.OpenSubscriptionPurchasePageAction_Params,
	RefreshGamePassesAction = t1.RefreshGamePassesAction,
	RefreshGamePassesAction_Params = t1.RefreshGamePassesAction_Params,
	RefreshPlayabilityAction = t1.RefreshPlayabilityAction,
	RefreshPlayabilityAction_Params = t1.RefreshPlayabilityAction_Params,
	RefreshDeveloperProductsAction = t1.RefreshDeveloperProductsAction,
	RefreshDeveloperProductsAction_Params = t1.RefreshDeveloperProductsAction_Params,
	OpenFaeTrialUpsellAction = t1.OpenFaeTrialUpsellAction,
	OpenFaeTrialUpsellAction_Params = t1.OpenFaeTrialUpsellAction_Params,
	OpenSduiOverlayAction = t1.OpenSduiOverlayAction,
	OpenSduiOverlayAction_Params = t1.OpenSduiOverlayAction_Params,
	ApplyChartsFilterAction = t1.ApplyChartsFilterAction,
	ApplyChartsFilterAction_Params = t1.ApplyChartsFilterAction_Params,
	AnalyticsEventAction = t1.AnalyticsEventAction,
	AnalyticsEventAction_Params = t1.AnalyticsEventAction_Params,
	CustomAnalyticsEventAction = t1.CustomAnalyticsEventAction,
	CustomAnalyticsEventAction_Params = t1.CustomAnalyticsEventAction_Params,
	OpenGameInviteAction = t1.OpenGameInviteAction,
	OpenGameInviteAction_Params = t1.OpenGameInviteAction_Params,
	LaunchExperienceAction = t1.LaunchExperienceAction,
	LaunchExperienceAction_ExperienceJoinData = t1.LaunchExperienceAction_ExperienceJoinData,
	LaunchExperienceAction_ExperienceJoinData_ExperienceJoinDataLiteral = t1.LaunchExperienceAction_ExperienceJoinData_ExperienceJoinDataLiteral,
	LaunchExperienceAction_Params = t1.LaunchExperienceAction_Params,
	ToggleExperienceFavoriteAction = t1.ToggleExperienceFavoriteAction,
	ToggleExperienceFavoriteAction_Params = t1.ToggleExperienceFavoriteAction_Params,
	ToggleExperienceFollowAction = t1.ToggleExperienceFollowAction,
	ToggleExperienceFollowAction_Params = t1.ToggleExperienceFollowAction_Params,
	ToggleExperienceVoteAction = t1.ToggleExperienceVoteAction,
	ToggleExperienceVoteAction_Params = t1.ToggleExperienceVoteAction_Params,
	OpenPurchasePromptAction = t1.OpenPurchasePromptAction,
	OpenPurchasePromptAction_ProductPayload = t1.OpenPurchasePromptAction_ProductPayload,
	OpenPurchasePromptAction_ProductPayload_ProductPayloadLiteral = t1.OpenPurchasePromptAction_ProductPayload_ProductPayloadLiteral,
	OpenPurchasePromptAction_DisplayInfo = t1.OpenPurchasePromptAction_DisplayInfo,
	OpenPurchasePromptAction_DisplayInfo_DisplayInfoLiteral = t1.OpenPurchasePromptAction_DisplayInfo_DisplayInfoLiteral,
	OpenPurchasePromptAction_PurchaseOptions = t1.OpenPurchasePromptAction_PurchaseOptions,
	OpenPurchasePromptAction_PurchaseOptions_PurchaseOptionsLiteral = t1.OpenPurchasePromptAction_PurchaseOptions_PurchaseOptionsLiteral,
	OpenPurchasePromptAction_PurchaseAnalyticsMetadata = t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata,
	OpenPurchasePromptAction_PurchaseAnalyticsMetadata_PurchaseAnalyticsMetadataLiteral = t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata_PurchaseAnalyticsMetadataLiteral,
	OpenPurchasePromptAction_Params = t1.OpenPurchasePromptAction_Params,
	ReportSurfaceLoadTimeMilestoneAction = t1.ReportSurfaceLoadTimeMilestoneAction,
	ReportSurfaceLoadTimeMilestoneAction_Params = t1.ReportSurfaceLoadTimeMilestoneAction_Params,
	DismissGameFeedbackAction = t1.DismissGameFeedbackAction,
	DismissGameFeedbackAction_Params = t1.DismissGameFeedbackAction_Params,
	OpenGameFeedbackFormAction = t1.OpenGameFeedbackFormAction,
	OpenGameFeedbackFormAction_Params = t1.OpenGameFeedbackFormAction_Params,
	AiOverviewFeedbackAction = t1.AiOverviewFeedbackAction,
	AiOverviewFeedbackAction_Params = t1.AiOverviewFeedbackAction_Params,
	EnableEventNotificationsAction = t1.EnableEventNotificationsAction,
	EnableEventNotificationsAction_Params = t1.EnableEventNotificationsAction_Params,
	DismissEventNotificationsModalAction = t1.DismissEventNotificationsModalAction,
	DismissEventNotificationsModalAction_Params = t1.DismissEventNotificationsModalAction_Params,
	OpenAmpWizardAction = t1.OpenAmpWizardAction,
	OpenAmpWizardAction_Params = t1.OpenAmpWizardAction_Params,
	OpenSocialProofUserListSheetAction = t1.OpenSocialProofUserListSheetAction,
	OpenSocialProofUserListSheetAction_Params = t1.OpenSocialProofUserListSheetAction_Params,
	OpenSearchResultsTabAction = t1.OpenSearchResultsTabAction,
	OpenSearchResultsTabAction_Params = t1.OpenSearchResultsTabAction_Params,
	DismissPromptAction = t1.DismissPromptAction,
	DismissPromptAction_Params = t1.DismissPromptAction_Params,
	RecordPartyChatConversationUpsellAcknowledgementAction = t1.RecordPartyChatConversationUpsellAcknowledgementAction,
	RecordPartyChatConversationUpsellAcknowledgementAction_Params = t1.RecordPartyChatConversationUpsellAcknowledgementAction_Params,
	RequestFriendshipAction = t1.RequestFriendshipAction,
	RequestFriendshipAction_Params = t1.RequestFriendshipAction_Params,
	OpenTrustedFriendsUpsellModalAction = t1.OpenTrustedFriendsUpsellModalAction,
	OpenTrustedFriendsUpsellModalAction_Params = t1.OpenTrustedFriendsUpsellModalAction_Params,
	OpenSearchResultsWithQueryAction = t1.OpenSearchResultsWithQueryAction,
	OpenSearchResultsWithQueryAction_Params = t1.OpenSearchResultsWithQueryAction_Params,
	SelectMarketplaceFavoritesCategory = t1.SelectMarketplaceFavoritesCategory,
	SelectMarketplaceFavoritesCategory_Params = t1.SelectMarketplaceFavoritesCategory_Params,
	DownloadAppAction = t1.DownloadAppAction,
	DownloadAppAction_Params = t1.DownloadAppAction_Params,
	Action = t1.Action,
	ActionProp = t1.ActionProp,
	ActionProp_ConditionalOption = t1.ActionProp_ConditionalOption,
	ActionProp_ConditionalOptions = t1.ActionProp_ConditionalOptions,
	FocusNavActionsProp = t1.FocusNavActionsProp,
	FocusNavActionsProp_ConditionalOption = t1.FocusNavActionsProp_ConditionalOption,
	FocusNavActionsProp_ConditionalOptions = t1.FocusNavActionsProp_ConditionalOptions,
	FocusNavActionsProp_FocusNavData = t1.FocusNavActionsProp_FocusNavData,
	ActionType = t1.ActionType
}
