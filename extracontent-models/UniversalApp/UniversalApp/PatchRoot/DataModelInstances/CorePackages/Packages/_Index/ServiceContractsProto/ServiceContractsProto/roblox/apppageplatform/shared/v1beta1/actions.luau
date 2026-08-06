local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local prop_condition = require(script.Parent.prop_condition)
local prop_types_engine

do
	local prop_types = require(script.Parent.prop_types)

	prop_types_engine = require(script.Parent.prop_types_engine)

	do
		local share_link_data = require(script.Parent.share_link_data)

		do
			local t2 = {}

			t2.__index = t2

			function t2.new(t3: {[any]: any}?) -- line: 5471
				-- upvalues: t1 (copy), t2 (copy)
				return (setmetatable({
					action_type = if t3 ~= nil and t3.action_type ~= nil then t3.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t3 ~= nil and t3.action_params ~= nil then t3.action_params else nil
				}, t2))
			end
			function t2.encode(p1) -- line: 5480
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n1 = 0

				if p1.action_type ~= nil and (p1.action_type ~= nil and p1.action_type ~= 0 or p1.action_type ~= t1.ActionType.fromNumber(0)) then
					local v185, v186 = proto.writeTag(buf, n1, 1, proto.wireTypes.varint)

					buf, n1 = proto.writeVarInt(v185, v186, t1.ActionType.toNumber(p1.action_type))
				end

				if p1.action_params ~= nil then
					local v187 = p1.action_params:encode()
					local v188, v189 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

					buf, n1 = proto.writeBuffer(v188, v189, v187, buffer.len(v187))
				end

				local buf2 = buffer.create(n1)

				buffer.copy(buf2, 0, buf, 0, n1)

				return buf2
			end
			function t2.decode(p2: buffer) -- line: 5506
				-- upvalues: t2 (copy), proto (copy), t1 (copy)
				local v192 = t2.new()
				local n2 = 0

				while n2 < buffer.len(p2) do
					local v194, v195

					v194, v195, n2 = proto.readTag(p2, n2)

					if v195 == proto.wireTypes.varint then
						if v194 == 1 then
							local v196

							v196, n2 = proto.readVarIntI32(p2, n2)
							v192.action_type = t1.ActionType.fromNumber(v196) or v196
						else
							local v197

							v197, n2 = proto.readVarInt(p2, n2)
						end
					elseif v195 == proto.wireTypes.lengthDelimited then
						if v194 == 2 then
							local v198

							v198, n2 = proto.readBuffer(p2, n2)
							v192.action_params = t1.DismissDialogAction_Params.decode(v198)
						else
							local v199, v200 = proto.readVarInt(p2, n2)

							n2 = v200 + v199
						end
					elseif v195 == proto.wireTypes.i32 then
						local v201

						v201, n2 = proto.readFixed32(p2, n2)
					elseif v195 == proto.wireTypes.i64 then
						local v202

						v202, n2 = proto.readFixed64(p2, n2)
					else
						error("Unsupported wire type: " .. v195)
					end
				end

				return v192
			end
			function t2.jsonEncode(p3) -- line: 5554
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
			function t2.jsonDecode(t5: {[any]: any}) -- line: 5576
				-- upvalues: t2 (copy), t1 (copy)
				local v206 = t2.new()

				if t5.action_type ~= nil then
					v206.action_type = if typeof(t5.action_type) ~= "number" then t1.ActionType.fromName(t5.action_type) or t5.action_type else t1.ActionType.fromNumber(t5.action_type) or t5.action_type
				end

				if t5.actionType ~= nil then
					v206.action_type = if typeof(t5.actionType) ~= "number" then t1.ActionType.fromName(t5.actionType) or t5.actionType else t1.ActionType.fromNumber(t5.actionType) or t5.actionType
				end

				if t5.action_params ~= nil then
					v206.action_params = t1.DismissDialogAction_Params.jsonDecode(t5.action_params)
				end

				if t5.actionParams ~= nil then
					v206.action_params = t1.DismissDialogAction_Params.jsonDecode(t5.actionParams)
				end

				return v206
			end

			t2.descriptor = {
				name = "DismissDialogAction",
				fullName = "roblox.apppageplatform.shared.v1beta1.DismissDialogAction"
			}
			t1.DismissDialogAction = t2
		end

		typeRegistry.default:register(t1.DismissDialogAction)

		do
			local t6 = {}

			t6.__index = t6

			function t6.new(t7: {[any]: any}?) -- line: 5616
				-- upvalues: t6 (copy)
				return (setmetatable({
					dialog_type = if t7 ~= nil and t7.dialog_type ~= nil then t7.dialog_type else nil
				}, t6))
			end
			function t6.encode(p4) -- line: 5624
				-- upvalues: proto (copy)
				local buf = buffer.create(0)
				local n3 = 0

				if p4.dialog_type ~= nil then
					local v211 = p4.dialog_type:encode()
					local v212, v213 = proto.writeTag(buf, n3, 1, proto.wireTypes.lengthDelimited)

					buf, n3 = proto.writeBuffer(v212, v213, v211, buffer.len(v211))
				end

				local buf3 = buffer.create(n3)

				buffer.copy(buf3, 0, buf, 0, n3)

				return buf3
			end
			function t6.decode(p5: buffer) -- line: 5639
				-- upvalues: t6 (copy), proto (copy), prop_types (copy)
				local v216 = t6.new()
				local n4 = 0

				while n4 < buffer.len(p5) do
					local v218, v219

					v218, v219, n4 = proto.readTag(p5, n4)

					if v219 == proto.wireTypes.varint then
						local v220

						v220, n4 = proto.readVarInt(p5, n4)
					elseif v219 == proto.wireTypes.lengthDelimited then
						if v218 == 1 then
							local v221

							v221, n4 = proto.readBuffer(p5, n4)
							v216.dialog_type = prop_types.StringProp.decode(v221)
						else
							local v222, v223 = proto.readVarInt(p5, n4)

							n4 = v223 + v222
						end
					elseif v219 == proto.wireTypes.i32 then
						local v224

						v224, n4 = proto.readFixed32(p5, n4)
					elseif v219 == proto.wireTypes.i64 then
						local v225

						v225, n4 = proto.readFixed64(p5, n4)
					else
						error("Unsupported wire type: " .. v219)
					end
				end

				return v216
			end
			function t6.jsonEncode(p6) -- line: 5682
				local t8 = {}

				if p6.dialog_type ~= nil then
					t8.dialogType = p6.dialog_type:jsonEncode()
				end

				return t8
			end
			function t6.jsonDecode(t9: {[any]: any}) -- line: 5692
				-- upvalues: t6 (copy), prop_types (copy)
				local v229 = t6.new()

				if t9.dialog_type ~= nil then
					v229.dialog_type = prop_types.StringProp.jsonDecode(t9.dialog_type)
				end

				if t9.dialogType ~= nil then
					v229.dialog_type = prop_types.StringProp.jsonDecode(t9.dialogType)
				end

				return v229
			end

			t6.descriptor = {
				name = "DismissDialogAction_Params",
				fullName = "roblox.apppageplatform.shared.v1beta1.Params"
			}
			t1.DismissDialogAction_Params = t6
		end

		typeRegistry.default:register(t1.DismissDialogAction_Params)

		do
			local t10 = {}

			t10.__index = t10

			function t10.new(t11: {[any]: any}?) -- line: 5721
				-- upvalues: t1 (copy), t10 (copy)
				return (setmetatable({
					action_type = if t11 ~= nil and t11.action_type ~= nil then t11.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t11 ~= nil and t11.action_params ~= nil then t11.action_params else nil
				}, t10))
			end
			function t10.encode(p7) -- line: 5730
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n5 = 0

				if p7.action_type ~= nil and (p7.action_type ~= nil and p7.action_type ~= 0 or p7.action_type ~= t1.ActionType.fromNumber(0)) then
					local v234, v235 = proto.writeTag(buf, n5, 1, proto.wireTypes.varint)

					buf, n5 = proto.writeVarInt(v234, v235, t1.ActionType.toNumber(p7.action_type))
				end

				if p7.action_params ~= nil then
					local v236 = p7.action_params:encode()
					local v237, v238 = proto.writeTag(buf, n5, 2, proto.wireTypes.lengthDelimited)

					buf, n5 = proto.writeBuffer(v237, v238, v236, buffer.len(v236))
				end

				local buf4 = buffer.create(n5)

				buffer.copy(buf4, 0, buf, 0, n5)

				return buf4
			end
			function t10.decode(p8: buffer) -- line: 5756
				-- upvalues: t10 (copy), proto (copy), t1 (copy)
				local v241 = t10.new()
				local n6 = 0

				while n6 < buffer.len(p8) do
					local v243, v244

					v243, v244, n6 = proto.readTag(p8, n6)

					if v244 == proto.wireTypes.varint then
						if v243 == 1 then
							local v245

							v245, n6 = proto.readVarIntI32(p8, n6)
							v241.action_type = t1.ActionType.fromNumber(v245) or v245
						else
							local v246

							v246, n6 = proto.readVarInt(p8, n6)
						end
					elseif v244 == proto.wireTypes.lengthDelimited then
						if v243 == 2 then
							local v247

							v247, n6 = proto.readBuffer(p8, n6)
							v241.action_params = t1.LinkAction_Params.decode(v247)
						else
							local v248, v249 = proto.readVarInt(p8, n6)

							n6 = v249 + v248
						end
					elseif v244 == proto.wireTypes.i32 then
						local v250

						v250, n6 = proto.readFixed32(p8, n6)
					elseif v244 == proto.wireTypes.i64 then
						local v251

						v251, n6 = proto.readFixed64(p8, n6)
					else
						error("Unsupported wire type: " .. v244)
					end
				end

				return v241
			end
			function t10.jsonEncode(p9) -- line: 5804
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
			function t10.jsonDecode(t13: {[any]: any}) -- line: 5826
				-- upvalues: t10 (copy), t1 (copy)
				local v255 = t10.new()

				if t13.action_type ~= nil then
					v255.action_type = if typeof(t13.action_type) ~= "number" then t1.ActionType.fromName(t13.action_type) or t13.action_type else t1.ActionType.fromNumber(t13.action_type) or t13.action_type
				end

				if t13.actionType ~= nil then
					v255.action_type = if typeof(t13.actionType) ~= "number" then t1.ActionType.fromName(t13.actionType) or t13.actionType else t1.ActionType.fromNumber(t13.actionType) or t13.actionType
				end

				if t13.action_params ~= nil then
					v255.action_params = t1.LinkAction_Params.jsonDecode(t13.action_params)
				end

				if t13.actionParams ~= nil then
					v255.action_params = t1.LinkAction_Params.jsonDecode(t13.actionParams)
				end

				return v255
			end

			t10.descriptor = {
				name = "LinkAction",
				fullName = "roblox.apppageplatform.shared.v1beta1.LinkAction"
			}
			t1.LinkAction = t10
		end

		typeRegistry.default:register(t1.LinkAction)

		do
			local t14 = {}

			t14.__index = t14

			function t14.new(t15: {[any]: any}?) -- line: 5866
				-- upvalues: t14 (copy)
				return (setmetatable({
					url = if t15 ~= nil and t15.url ~= nil then t15.url else nil,
					title_key = if t15 ~= nil and t15.title_key ~= nil then t15.title_key else nil,
					on_webview_close = if t15 ~= nil and t15.on_webview_close ~= nil then t15.on_webview_close else nil
				}, t14))
			end
			function t14.encode(p10) -- line: 5874
				-- upvalues: proto (copy)
				local buf = buffer.create(0)
				local n7 = 0

				if p10.url ~= nil then
					local v260 = p10.url:encode()
					local v261, v262 = proto.writeTag(buf, n7, 1, proto.wireTypes.lengthDelimited)

					buf, n7 = proto.writeBuffer(v261, v262, v260, buffer.len(v260))
				end

				if p10.title_key ~= nil then
					local v263 = p10.title_key:encode()
					local v264, v265 = proto.writeTag(buf, n7, 2, proto.wireTypes.lengthDelimited)

					buf, n7 = proto.writeBuffer(v264, v265, v263, buffer.len(v263))
				end

				if p10.on_webview_close ~= nil then
					local v266 = p10.on_webview_close:encode()
					local v267, v268 = proto.writeTag(buf, n7, 4, proto.wireTypes.lengthDelimited)

					buf, n7 = proto.writeBuffer(v267, v268, v266, buffer.len(v266))
				end

				local buf5 = buffer.create(n7)

				buffer.copy(buf5, 0, buf, 0, n7)

				return buf5
			end
			function t14.decode(p11: buffer) -- line: 5901
				-- upvalues: t14 (copy), proto (copy), prop_types (copy), t1 (copy)
				local v271 = t14.new()
				local n8 = 0

				while n8 < buffer.len(p11) do
					local v273, v274

					v273, v274, n8 = proto.readTag(p11, n8)

					if v274 == proto.wireTypes.varint then
						local v275

						v275, n8 = proto.readVarInt(p11, n8)
					elseif v274 == proto.wireTypes.lengthDelimited then
						if v273 == 1 then
							local v276

							v276, n8 = proto.readBuffer(p11, n8)
							v271.url = prop_types.StringProp.decode(v276)
						elseif v273 == 2 then
							local v277

							v277, n8 = proto.readBuffer(p11, n8)
							v271.title_key = prop_types.StringProp.decode(v277)
						elseif v273 == 4 then
							local v278

							v278, n8 = proto.readBuffer(p11, n8)
							v271.on_webview_close = t1.ActionProp.decode(v278)
						else
							local v279, v280 = proto.readVarInt(p11, n8)

							n8 = v280 + v279
						end
					elseif v274 == proto.wireTypes.i32 then
						local v281

						v281, n8 = proto.readFixed32(p11, n8)
					elseif v274 == proto.wireTypes.i64 then
						local v282

						v282, n8 = proto.readFixed64(p11, n8)
					else
						error("Unsupported wire type: " .. v274)
					end
				end

				return v271
			end
			function t14.jsonEncode(p12) -- line: 5954
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
			function t14.jsonDecode(t17: {[any]: any}) -- line: 5972
				-- upvalues: t14 (copy), prop_types (copy), t1 (copy)
				local v286 = t14.new()

				if t17.url ~= nil then
					v286.url = prop_types.StringProp.jsonDecode(t17.url)
				end

				if t17.title_key ~= nil then
					v286.title_key = prop_types.StringProp.jsonDecode(t17.title_key)
				end

				if t17.titleKey ~= nil then
					v286.title_key = prop_types.StringProp.jsonDecode(t17.titleKey)
				end

				if t17.on_webview_close ~= nil then
					v286.on_webview_close = t1.ActionProp.jsonDecode(t17.on_webview_close)
				end

				if t17.onWebviewClose ~= nil then
					v286.on_webview_close = t1.ActionProp.jsonDecode(t17.onWebviewClose)
				end

				return v286
			end

			t14.descriptor = {
				name = "LinkAction_Params",
				fullName = "roblox.apppageplatform.shared.v1beta1.Params"
			}
			t1.LinkAction_Params = t14
		end

		typeRegistry.default:register(t1.LinkAction_Params)

		do
			local t18 = {}

			t18.__index = t18

			function t18.new(t19: {[any]: any}?) -- line: 6012
				-- upvalues: t1 (copy), t18 (copy)
				return (setmetatable({
					action_type = if t19 ~= nil and t19.action_type ~= nil then t19.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t19 ~= nil and t19.action_params ~= nil then t19.action_params else nil
				}, t18))
			end
			function t18.encode(p13) -- line: 6021
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n9 = 0

				if p13.action_type ~= nil and (p13.action_type ~= nil and p13.action_type ~= 0 or p13.action_type ~= t1.ActionType.fromNumber(0)) then
					local v291, v292 = proto.writeTag(buf, n9, 1, proto.wireTypes.varint)

					buf, n9 = proto.writeVarInt(v291, v292, t1.ActionType.toNumber(p13.action_type))
				end

				if p13.action_params ~= nil then
					local v293 = p13.action_params:encode()
					local v294, v295 = proto.writeTag(buf, n9, 2, proto.wireTypes.lengthDelimited)

					buf, n9 = proto.writeBuffer(v294, v295, v293, buffer.len(v293))
				end

				local buf6 = buffer.create(n9)

				buffer.copy(buf6, 0, buf, 0, n9)

				return buf6
			end
			function t18.decode(p14: buffer) -- line: 6047
				-- upvalues: t18 (copy), proto (copy), t1 (copy)
				local v298 = t18.new()
				local n10 = 0

				while n10 < buffer.len(p14) do
					local v300, v301

					v300, v301, n10 = proto.readTag(p14, n10)

					if v301 == proto.wireTypes.varint then
						if v300 == 1 then
							local v302

							v302, n10 = proto.readVarIntI32(p14, n10)
							v298.action_type = t1.ActionType.fromNumber(v302) or v302
						else
							local v303

							v303, n10 = proto.readVarInt(p14, n10)
						end
					elseif v301 == proto.wireTypes.lengthDelimited then
						if v300 == 2 then
							local v304

							v304, n10 = proto.readBuffer(p14, n10)
							v298.action_params = t1.OpenSocialLinkAction_Params.decode(v304)
						else
							local v305, v306 = proto.readVarInt(p14, n10)

							n10 = v306 + v305
						end
					elseif v301 == proto.wireTypes.i32 then
						local v307

						v307, n10 = proto.readFixed32(p14, n10)
					elseif v301 == proto.wireTypes.i64 then
						local v308

						v308, n10 = proto.readFixed64(p14, n10)
					else
						error("Unsupported wire type: " .. v301)
					end
				end

				return v298
			end
			function t18.jsonEncode(p15) -- line: 6095
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
			function t18.jsonDecode(t21: {[any]: any}) -- line: 6117
				-- upvalues: t18 (copy), t1 (copy)
				local v312 = t18.new()

				if t21.action_type ~= nil then
					v312.action_type = if typeof(t21.action_type) ~= "number" then t1.ActionType.fromName(t21.action_type) or t21.action_type else t1.ActionType.fromNumber(t21.action_type) or t21.action_type
				end

				if t21.actionType ~= nil then
					v312.action_type = if typeof(t21.actionType) ~= "number" then t1.ActionType.fromName(t21.actionType) or t21.actionType else t1.ActionType.fromNumber(t21.actionType) or t21.actionType
				end

				if t21.action_params ~= nil then
					v312.action_params = t1.OpenSocialLinkAction_Params.jsonDecode(t21.action_params)
				end

				if t21.actionParams ~= nil then
					v312.action_params = t1.OpenSocialLinkAction_Params.jsonDecode(t21.actionParams)
				end

				return v312
			end

			t18.descriptor = {
				name = "OpenSocialLinkAction",
				fullName = "roblox.apppageplatform.shared.v1beta1.OpenSocialLinkAction"
			}
			t1.OpenSocialLinkAction = t18
		end

		typeRegistry.default:register(t1.OpenSocialLinkAction)

		do
			local t22 = {}

			t22.__index = t22

			function t22.new(t23: {[any]: any}?) -- line: 6157
				-- upvalues: t22 (copy)
				return (setmetatable({
					assignment_id = if t23 ~= nil and t23.assignment_id ~= nil then t23.assignment_id else nil,
					assignment_type = if t23 ~= nil and t23.assignment_type ~= nil then t23.assignment_type else nil,
					social_link_type = if t23 ~= nil and t23.social_link_type ~= nil then t23.social_link_type else nil,
					social_link_url = if t23 ~= nil and t23.social_link_url ~= nil then t23.social_link_url else nil,
					social_link_display_type = if t23 ~= nil and t23.social_link_display_type ~= nil then t23.social_link_display_type else nil
				}, t22))
			end
			function t22.encode(p16) -- line: 6171
				-- upvalues: proto (copy)
				local buf = buffer.create(0)
				local n11 = 0

				if p16.assignment_id ~= nil then
					local v317 = p16.assignment_id:encode()
					local v318, v319 = proto.writeTag(buf, n11, 1, proto.wireTypes.lengthDelimited)

					buf, n11 = proto.writeBuffer(v318, v319, v317, buffer.len(v317))
				end

				if p16.assignment_type ~= nil then
					local v320 = p16.assignment_type:encode()
					local v321, v322 = proto.writeTag(buf, n11, 2, proto.wireTypes.lengthDelimited)

					buf, n11 = proto.writeBuffer(v321, v322, v320, buffer.len(v320))
				end

				if p16.social_link_type ~= nil then
					local v323 = p16.social_link_type:encode()
					local v324, v325 = proto.writeTag(buf, n11, 3, proto.wireTypes.lengthDelimited)

					buf, n11 = proto.writeBuffer(v324, v325, v323, buffer.len(v323))
				end

				if p16.social_link_url ~= nil then
					local v326 = p16.social_link_url:encode()
					local v327, v328 = proto.writeTag(buf, n11, 4, proto.wireTypes.lengthDelimited)

					buf, n11 = proto.writeBuffer(v327, v328, v326, buffer.len(v326))
				end

				if p16.social_link_display_type ~= nil then
					local v329 = p16.social_link_display_type:encode()
					local v330, v331 = proto.writeTag(buf, n11, 5, proto.wireTypes.lengthDelimited)

					buf, n11 = proto.writeBuffer(v330, v331, v329, buffer.len(v329))
				end

				local buf7 = buffer.create(n11)

				buffer.copy(buf7, 0, buf, 0, n11)

				return buf7
			end
			function t22.decode(p17: buffer) -- line: 6210
				-- upvalues: t22 (copy), proto (copy), prop_types (copy)
				local v334 = t22.new()
				local n12 = 0

				while n12 < buffer.len(p17) do
					local v336, v337

					v336, v337, n12 = proto.readTag(p17, n12)

					if v337 == proto.wireTypes.varint then
						local v338

						v338, n12 = proto.readVarInt(p17, n12)
					elseif v337 == proto.wireTypes.lengthDelimited then
						if v336 == 1 then
							local v339

							v339, n12 = proto.readBuffer(p17, n12)
							v334.assignment_id = prop_types.StringProp.decode(v339)
						elseif v336 == 2 then
							local v340

							v340, n12 = proto.readBuffer(p17, n12)
							v334.assignment_type = prop_types.StringProp.decode(v340)
						elseif v336 == 3 then
							local v341

							v341, n12 = proto.readBuffer(p17, n12)
							v334.social_link_type = prop_types.StringProp.decode(v341)
						elseif v336 == 4 then
							local v342

							v342, n12 = proto.readBuffer(p17, n12)
							v334.social_link_url = prop_types.StringProp.decode(v342)
						elseif v336 == 5 then
							local v343

							v343, n12 = proto.readBuffer(p17, n12)
							v334.social_link_display_type = prop_types.StringProp.decode(v343)
						else
							local v344, v345 = proto.readVarInt(p17, n12)

							n12 = v345 + v344
						end
					elseif v337 == proto.wireTypes.i32 then
						local v346

						v346, n12 = proto.readFixed32(p17, n12)
					elseif v337 == proto.wireTypes.i64 then
						local v347

						v347, n12 = proto.readFixed64(p17, n12)
					else
						error("Unsupported wire type: " .. v337)
					end
				end

				return v334
			end
			function t22.jsonEncode(p18) -- line: 6274
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
			function t22.jsonDecode(t25: {[any]: any}) -- line: 6300
				-- upvalues: t22 (copy), prop_types (copy)
				local v351 = t22.new()

				if t25.assignment_id ~= nil then
					v351.assignment_id = prop_types.StringProp.jsonDecode(t25.assignment_id)
				end

				if t25.assignmentId ~= nil then
					v351.assignment_id = prop_types.StringProp.jsonDecode(t25.assignmentId)
				end

				if t25.assignment_type ~= nil then
					v351.assignment_type = prop_types.StringProp.jsonDecode(t25.assignment_type)
				end

				if t25.assignmentType ~= nil then
					v351.assignment_type = prop_types.StringProp.jsonDecode(t25.assignmentType)
				end

				if t25.social_link_type ~= nil then
					v351.social_link_type = prop_types.StringProp.jsonDecode(t25.social_link_type)
				end

				if t25.socialLinkType ~= nil then
					v351.social_link_type = prop_types.StringProp.jsonDecode(t25.socialLinkType)
				end

				if t25.social_link_url ~= nil then
					v351.social_link_url = prop_types.StringProp.jsonDecode(t25.social_link_url)
				end

				if t25.socialLinkUrl ~= nil then
					v351.social_link_url = prop_types.StringProp.jsonDecode(t25.socialLinkUrl)
				end

				if t25.social_link_display_type ~= nil then
					v351.social_link_display_type = prop_types.StringProp.jsonDecode(t25.social_link_display_type)
				end

				if t25.socialLinkDisplayType ~= nil then
					v351.social_link_display_type = prop_types.StringProp.jsonDecode(t25.socialLinkDisplayType)
				end

				return v351
			end

			t22.descriptor = {
				name = "OpenSocialLinkAction_Params",
				fullName = "roblox.apppageplatform.shared.v1beta1.Params"
			}
			t1.OpenSocialLinkAction_Params = t22
		end

		typeRegistry.default:register(t1.OpenSocialLinkAction_Params)

		do
			local t26 = {}

			t26.__index = t26

			function t26.new(t27: {[any]: any}?) -- line: 6370
				-- upvalues: t1 (copy), t26 (copy)
				return (setmetatable({
					action_type = if t27 ~= nil and t27.action_type ~= nil then t27.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t27 ~= nil and t27.action_params ~= nil then t27.action_params else nil
				}, t26))
			end
			function t26.encode(p19) -- line: 6379
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n13 = 0

				if p19.action_type ~= nil and (p19.action_type ~= nil and p19.action_type ~= 0 or p19.action_type ~= t1.ActionType.fromNumber(0)) then
					local v356, v357 = proto.writeTag(buf, n13, 1, proto.wireTypes.varint)

					buf, n13 = proto.writeVarInt(v356, v357, t1.ActionType.toNumber(p19.action_type))
				end

				if p19.action_params ~= nil then
					local v358 = p19.action_params:encode()
					local v359, v360 = proto.writeTag(buf, n13, 2, proto.wireTypes.lengthDelimited)

					buf, n13 = proto.writeBuffer(v359, v360, v358, buffer.len(v358))
				end

				local buf8 = buffer.create(n13)

				buffer.copy(buf8, 0, buf, 0, n13)

				return buf8
			end
			function t26.decode(p20: buffer) -- line: 6405
				-- upvalues: t26 (copy), proto (copy), t1 (copy)
				local v363 = t26.new()
				local n14 = 0

				while n14 < buffer.len(p20) do
					local v365, v366

					v365, v366, n14 = proto.readTag(p20, n14)

					if v366 == proto.wireTypes.varint then
						if v365 == 1 then
							local v367

							v367, n14 = proto.readVarIntI32(p20, n14)
							v363.action_type = t1.ActionType.fromNumber(v367) or v367
						else
							local v368

							v368, n14 = proto.readVarInt(p20, n14)
						end
					elseif v366 == proto.wireTypes.lengthDelimited then
						if v365 == 2 then
							local v369

							v369, n14 = proto.readBuffer(p20, n14)
							v363.action_params = t1.OpenGameDetailsAction_Params.decode(v369)
						else
							local v370, v371 = proto.readVarInt(p20, n14)

							n14 = v371 + v370
						end
					elseif v366 == proto.wireTypes.i32 then
						local v372

						v372, n14 = proto.readFixed32(p20, n14)
					elseif v366 == proto.wireTypes.i64 then
						local v373

						v373, n14 = proto.readFixed64(p20, n14)
					else
						error("Unsupported wire type: " .. v366)
					end
				end

				return v363
			end
			function t26.jsonEncode(p21) -- line: 6453
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
			function t26.jsonDecode(t29: {[any]: any}) -- line: 6475
				-- upvalues: t26 (copy), t1 (copy)
				local v377 = t26.new()

				if t29.action_type ~= nil then
					v377.action_type = if typeof(t29.action_type) ~= "number" then t1.ActionType.fromName(t29.action_type) or t29.action_type else t1.ActionType.fromNumber(t29.action_type) or t29.action_type
				end

				if t29.actionType ~= nil then
					v377.action_type = if typeof(t29.actionType) ~= "number" then t1.ActionType.fromName(t29.actionType) or t29.actionType else t1.ActionType.fromNumber(t29.actionType) or t29.actionType
				end

				if t29.action_params ~= nil then
					v377.action_params = t1.OpenGameDetailsAction_Params.jsonDecode(t29.action_params)
				end

				if t29.actionParams ~= nil then
					v377.action_params = t1.OpenGameDetailsAction_Params.jsonDecode(t29.actionParams)
				end

				return v377
			end

			t26.descriptor = {
				name = "OpenGameDetailsAction",
				fullName = "roblox.apppageplatform.shared.v1beta1.OpenGameDetailsAction"
			}
			t1.OpenGameDetailsAction = t26
		end

		typeRegistry.default:register(t1.OpenGameDetailsAction)

		do
			local t30 = {}

			t30.__index = t30

			function t30.new(t31: {[any]: any}?) -- line: 6515
				-- upvalues: t30 (copy)
				return (setmetatable({
					place_id = if t31 ~= nil and t31.place_id ~= nil then t31.place_id else nil,
					universe_id = if t31 ~= nil and t31.universe_id ~= nil then t31.universe_id else nil,
					inherit_referral_session = if t31 ~= nil and t31.inherit_referral_session ~= nil then t31.inherit_referral_session else nil
				}, t30))
			end
			function t30.encode(p22) -- line: 6527
				-- upvalues: proto (copy)
				local buf = buffer.create(0)
				local n15 = 0

				if p22.place_id ~= nil then
					local v382 = p22.place_id:encode()
					local v383, v384 = proto.writeTag(buf, n15, 1, proto.wireTypes.lengthDelimited)

					buf, n15 = proto.writeBuffer(v383, v384, v382, buffer.len(v382))
				end

				if p22.universe_id ~= nil then
					local v385 = p22.universe_id:encode()
					local v386, v387 = proto.writeTag(buf, n15, 2, proto.wireTypes.lengthDelimited)

					buf, n15 = proto.writeBuffer(v386, v387, v385, buffer.len(v385))
				end

				if p22.inherit_referral_session ~= nil then
					local v388 = p22.inherit_referral_session:encode()
					local v389, v390 = proto.writeTag(buf, n15, 3, proto.wireTypes.lengthDelimited)

					buf, n15 = proto.writeBuffer(v389, v390, v388, buffer.len(v388))
				end

				local buf9 = buffer.create(n15)

				buffer.copy(buf9, 0, buf, 0, n15)

				return buf9
			end
			function t30.decode(p23: buffer) -- line: 6554
				-- upvalues: t30 (copy), proto (copy), prop_types (copy)
				local v393 = t30.new()
				local n16 = 0

				while n16 < buffer.len(p23) do
					local v395, v396

					v395, v396, n16 = proto.readTag(p23, n16)

					if v396 == proto.wireTypes.varint then
						local v397

						v397, n16 = proto.readVarInt(p23, n16)
					elseif v396 == proto.wireTypes.lengthDelimited then
						if v395 == 1 then
							local v398

							v398, n16 = proto.readBuffer(p23, n16)
							v393.place_id = prop_types.StringProp.decode(v398)
						elseif v395 == 2 then
							local v399

							v399, n16 = proto.readBuffer(p23, n16)
							v393.universe_id = prop_types.StringProp.decode(v399)
						elseif v395 == 3 then
							local v400

							v400, n16 = proto.readBuffer(p23, n16)
							v393.inherit_referral_session = prop_types.BoolProp.decode(v400)
						else
							local v401, v402 = proto.readVarInt(p23, n16)

							n16 = v402 + v401
						end
					elseif v396 == proto.wireTypes.i32 then
						local v403

						v403, n16 = proto.readFixed32(p23, n16)
					elseif v396 == proto.wireTypes.i64 then
						local v404

						v404, n16 = proto.readFixed64(p23, n16)
					else
						error("Unsupported wire type: " .. v396)
					end
				end

				return v393
			end
			function t30.jsonEncode(p24) -- line: 6608
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
			function t30.jsonDecode(t33: {[any]: any}) -- line: 6626
				-- upvalues: t30 (copy), prop_types (copy)
				local v408 = t30.new()

				if t33.place_id ~= nil then
					v408.place_id = prop_types.StringProp.jsonDecode(t33.place_id)
				end

				if t33.placeId ~= nil then
					v408.place_id = prop_types.StringProp.jsonDecode(t33.placeId)
				end

				if t33.universe_id ~= nil then
					v408.universe_id = prop_types.StringProp.jsonDecode(t33.universe_id)
				end

				if t33.universeId ~= nil then
					v408.universe_id = prop_types.StringProp.jsonDecode(t33.universeId)
				end

				if t33.inherit_referral_session ~= nil then
					v408.inherit_referral_session = prop_types.BoolProp.jsonDecode(t33.inherit_referral_session)
				end

				if t33.inheritReferralSession ~= nil then
					v408.inherit_referral_session = prop_types.BoolProp.jsonDecode(t33.inheritReferralSession)
				end

				return v408
			end

			t30.descriptor = {
				name = "OpenGameDetailsAction_Params",
				fullName = "roblox.apppageplatform.shared.v1beta1.Params"
			}
			t1.OpenGameDetailsAction_Params = t30
		end

		typeRegistry.default:register(t1.OpenGameDetailsAction_Params)

		do
			local t34 = {}

			t34.__index = t34

			function t34.new(t35: {[any]: any}?) -- line: 6673
				-- upvalues: t1 (copy), t34 (copy)
				return (setmetatable({
					action_type = if t35 ~= nil and t35.action_type ~= nil then t35.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t35 ~= nil and t35.action_params ~= nil then t35.action_params else nil
				}, t34))
			end
			function t34.encode(p25) -- line: 6682
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n17 = 0

				if p25.action_type ~= nil and (p25.action_type ~= nil and p25.action_type ~= 0 or p25.action_type ~= t1.ActionType.fromNumber(0)) then
					local v413, v414 = proto.writeTag(buf, n17, 1, proto.wireTypes.varint)

					buf, n17 = proto.writeVarInt(v413, v414, t1.ActionType.toNumber(p25.action_type))
				end

				if p25.action_params ~= nil then
					local v415 = p25.action_params:encode()
					local v416, v417 = proto.writeTag(buf, n17, 2, proto.wireTypes.lengthDelimited)

					buf, n17 = proto.writeBuffer(v416, v417, v415, buffer.len(v415))
				end

				local buf10 = buffer.create(n17)

				buffer.copy(buf10, 0, buf, 0, n17)

				return buf10
			end
			function t34.decode(p26: buffer) -- line: 6708
				-- upvalues: t34 (copy), proto (copy), t1 (copy)
				local v420 = t34.new()
				local n18 = 0

				while n18 < buffer.len(p26) do
					local v422, v423

					v422, v423, n18 = proto.readTag(p26, n18)

					if v423 == proto.wireTypes.varint then
						if v422 == 1 then
							local v424

							v424, n18 = proto.readVarIntI32(p26, n18)
							v420.action_type = t1.ActionType.fromNumber(v424) or v424
						else
							local v425

							v425, n18 = proto.readVarInt(p26, n18)
						end
					elseif v423 == proto.wireTypes.lengthDelimited then
						if v422 == 2 then
							local v426

							v426, n18 = proto.readBuffer(p26, n18)
							v420.action_params = t1.OpenJoinFriendsAction_Params.decode(v426)
						else
							local v427, v428 = proto.readVarInt(p26, n18)

							n18 = v428 + v427
						end
					elseif v423 == proto.wireTypes.i32 then
						local v429

						v429, n18 = proto.readFixed32(p26, n18)
					elseif v423 == proto.wireTypes.i64 then
						local v430

						v430, n18 = proto.readFixed64(p26, n18)
					else
						error("Unsupported wire type: " .. v423)
					end
				end

				return v420
			end
			function t34.jsonEncode(p27) -- line: 6756
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
			function t34.jsonDecode(t37: {[any]: any}) -- line: 6778
				-- upvalues: t34 (copy), t1 (copy)
				local v434 = t34.new()

				if t37.action_type ~= nil then
					v434.action_type = if typeof(t37.action_type) ~= "number" then t1.ActionType.fromName(t37.action_type) or t37.action_type else t1.ActionType.fromNumber(t37.action_type) or t37.action_type
				end

				if t37.actionType ~= nil then
					v434.action_type = if typeof(t37.actionType) ~= "number" then t1.ActionType.fromName(t37.actionType) or t37.actionType else t1.ActionType.fromNumber(t37.actionType) or t37.actionType
				end

				if t37.action_params ~= nil then
					v434.action_params = t1.OpenJoinFriendsAction_Params.jsonDecode(t37.action_params)
				end

				if t37.actionParams ~= nil then
					v434.action_params = t1.OpenJoinFriendsAction_Params.jsonDecode(t37.actionParams)
				end

				return v434
			end

			t34.descriptor = {
				name = "OpenJoinFriendsAction",
				fullName = "roblox.apppageplatform.shared.v1beta1.OpenJoinFriendsAction"
			}
			t1.OpenJoinFriendsAction = t34
		end

		typeRegistry.default:register(t1.OpenJoinFriendsAction)

		do
			local t38 = {}

			t38.__index = t38

			function t38.new(t39: {[any]: any}?) -- line: 6818
				-- upvalues: t38 (copy)
				return (setmetatable({
					place_id = if t39 ~= nil and t39.place_id ~= nil then t39.place_id else nil,
					universe_id = if t39 ~= nil and t39.universe_id ~= nil then t39.universe_id else nil
				}, t38))
			end
			function t38.encode(p28) -- line: 6827
				-- upvalues: proto (copy)
				local buf = buffer.create(0)
				local n19 = 0

				if p28.place_id ~= nil then
					local v439 = p28.place_id:encode()
					local v440, v441 = proto.writeTag(buf, n19, 1, proto.wireTypes.lengthDelimited)

					buf, n19 = proto.writeBuffer(v440, v441, v439, buffer.len(v439))
				end

				if p28.universe_id ~= nil then
					local v442 = p28.universe_id:encode()
					local v443, v444 = proto.writeTag(buf, n19, 2, proto.wireTypes.lengthDelimited)

					buf, n19 = proto.writeBuffer(v443, v444, v442, buffer.len(v442))
				end

				local buf11 = buffer.create(n19)

				buffer.copy(buf11, 0, buf, 0, n19)

				return buf11
			end
			function t38.decode(p29: buffer) -- line: 6848
				-- upvalues: t38 (copy), proto (copy), prop_types (copy)
				local v447 = t38.new()
				local n20 = 0

				while n20 < buffer.len(p29) do
					local v449, v450

					v449, v450, n20 = proto.readTag(p29, n20)

					if v450 == proto.wireTypes.varint then
						local v451

						v451, n20 = proto.readVarInt(p29, n20)
					elseif v450 == proto.wireTypes.lengthDelimited then
						if v449 == 1 then
							local v452

							v452, n20 = proto.readBuffer(p29, n20)
							v447.place_id = prop_types.StringProp.decode(v452)
						elseif v449 == 2 then
							local v453

							v453, n20 = proto.readBuffer(p29, n20)
							v447.universe_id = prop_types.StringProp.decode(v453)
						else
							local v454, v455 = proto.readVarInt(p29, n20)

							n20 = v455 + v454
						end
					elseif v450 == proto.wireTypes.i32 then
						local v456

						v456, n20 = proto.readFixed32(p29, n20)
					elseif v450 == proto.wireTypes.i64 then
						local v457

						v457, n20 = proto.readFixed64(p29, n20)
					else
						error("Unsupported wire type: " .. v450)
					end
				end

				return v447
			end
			function t38.jsonEncode(p30) -- line: 6896
				local t40 = {}

				if p30.place_id ~= nil then
					t40.placeId = p30.place_id:jsonEncode()
				end

				if p30.universe_id ~= nil then
					t40.universeId = p30.universe_id:jsonEncode()
				end

				return t40
			end
			function t38.jsonDecode(t41: {[any]: any}) -- line: 6910
				-- upvalues: t38 (copy), prop_types (copy)
				local v461 = t38.new()

				if t41.place_id ~= nil then
					v461.place_id = prop_types.StringProp.jsonDecode(t41.place_id)
				end

				if t41.placeId ~= nil then
					v461.place_id = prop_types.StringProp.jsonDecode(t41.placeId)
				end

				if t41.universe_id ~= nil then
					v461.universe_id = prop_types.StringProp.jsonDecode(t41.universe_id)
				end

				if t41.universeId ~= nil then
					v461.universe_id = prop_types.StringProp.jsonDecode(t41.universeId)
				end

				return v461
			end

			t38.descriptor = {
				name = "OpenJoinFriendsAction_Params",
				fullName = "roblox.apppageplatform.shared.v1beta1.Params"
			}
			t1.OpenJoinFriendsAction_Params = t38
		end

		typeRegistry.default:register(t1.OpenJoinFriendsAction_Params)

		do
			local t42 = {}

			t42.__index = t42

			function t42.new(t43: {[any]: any}?) -- line: 6947
				-- upvalues: t1 (copy), t42 (copy)
				return (setmetatable({
					action_type = if t43 ~= nil and t43.action_type ~= nil then t43.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t43 ~= nil and t43.action_params ~= nil then t43.action_params else nil
				}, t42))
			end
			function t42.encode(p31) -- line: 6958
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n21 = 0

				if p31.action_type ~= nil and (p31.action_type ~= nil and p31.action_type ~= 0 or p31.action_type ~= t1.ActionType.fromNumber(0)) then
					local v466, v467 = proto.writeTag(buf, n21, 1, proto.wireTypes.varint)

					buf, n21 = proto.writeVarInt(v466, v467, t1.ActionType.toNumber(p31.action_type))
				end

				if p31.action_params ~= nil then
					local v468 = p31.action_params:encode()
					local v469, v470 = proto.writeTag(buf, n21, 2, proto.wireTypes.lengthDelimited)

					buf, n21 = proto.writeBuffer(v469, v470, v468, buffer.len(v468))
				end

				local buf12 = buffer.create(n21)

				buffer.copy(buf12, 0, buf, 0, n21)

				return buf12
			end
			function t42.decode(p32: buffer) -- line: 6984
				-- upvalues: t42 (copy), proto (copy), t1 (copy)
				local v473 = t42.new()
				local n22 = 0

				while n22 < buffer.len(p32) do
					local v475, v476

					v475, v476, n22 = proto.readTag(p32, n22)

					if v476 == proto.wireTypes.varint then
						if v475 == 1 then
							local v477

							v477, n22 = proto.readVarIntI32(p32, n22)
							v473.action_type = t1.ActionType.fromNumber(v477) or v477
						else
							local v478

							v478, n22 = proto.readVarInt(p32, n22)
						end
					elseif v476 == proto.wireTypes.lengthDelimited then
						if v475 == 2 then
							local v479

							v479, n22 = proto.readBuffer(p32, n22)
							v473.action_params = t1.OpenMarketplaceTryOnAction_Params.decode(v479)
						else
							local v480, v481 = proto.readVarInt(p32, n22)

							n22 = v481 + v480
						end
					elseif v476 == proto.wireTypes.i32 then
						local v482

						v482, n22 = proto.readFixed32(p32, n22)
					elseif v476 == proto.wireTypes.i64 then
						local v483

						v483, n22 = proto.readFixed64(p32, n22)
					else
						error("Unsupported wire type: " .. v476)
					end
				end

				return v473
			end
			function t42.jsonEncode(p33) -- line: 7032
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
			function t42.jsonDecode(t45: {[any]: any}) -- line: 7054
				-- upvalues: t42 (copy), t1 (copy)
				local v487 = t42.new()

				if t45.action_type ~= nil then
					v487.action_type = if typeof(t45.action_type) ~= "number" then t1.ActionType.fromName(t45.action_type) or t45.action_type else t1.ActionType.fromNumber(t45.action_type) or t45.action_type
				end

				if t45.actionType ~= nil then
					v487.action_type = if typeof(t45.actionType) ~= "number" then t1.ActionType.fromName(t45.actionType) or t45.actionType else t1.ActionType.fromNumber(t45.actionType) or t45.actionType
				end

				if t45.action_params ~= nil then
					v487.action_params = t1.OpenMarketplaceTryOnAction_Params.jsonDecode(t45.action_params)
				end

				if t45.actionParams ~= nil then
					v487.action_params = t1.OpenMarketplaceTryOnAction_Params.jsonDecode(t45.actionParams)
				end

				return v487
			end

			t42.descriptor = {
				name = "OpenMarketplaceTryOnAction",
				fullName = "roblox.apppageplatform.shared.v1beta1.OpenMarketplaceTryOnAction"
			}
			t1.OpenMarketplaceTryOnAction = t42
		end

		typeRegistry.default:register(t1.OpenMarketplaceTryOnAction)

		do
			local t46 = {}

			t46.__index = t46

			function t46.new(t47: {[any]: any}?) -- line: 7094
				-- upvalues: t46 (copy)
				return (setmetatable({
					item_id = if t47 ~= nil and t47.item_id ~= nil then t47.item_id else nil,
					item_type = if t47 ~= nil and t47.item_type ~= nil then t47.item_type else nil,
					item_sub_type_name = if t47 ~= nil and t47.item_sub_type_name ~= nil then t47.item_sub_type_name else nil
				}, t46))
			end
			function t46.encode(p34) -- line: 7104
				-- upvalues: proto (copy)
				local buf = buffer.create(0)
				local n23 = 0

				if p34.item_id ~= nil then
					local v492 = p34.item_id:encode()
					local v493, v494 = proto.writeTag(buf, n23, 1, proto.wireTypes.lengthDelimited)

					buf, n23 = proto.writeBuffer(v493, v494, v492, buffer.len(v492))
				end

				if p34.item_type ~= nil then
					local v495 = p34.item_type:encode()
					local v496, v497 = proto.writeTag(buf, n23, 2, proto.wireTypes.lengthDelimited)

					buf, n23 = proto.writeBuffer(v496, v497, v495, buffer.len(v495))
				end

				if p34.item_sub_type_name ~= nil then
					local v498 = p34.item_sub_type_name:encode()
					local v499, v500 = proto.writeTag(buf, n23, 3, proto.wireTypes.lengthDelimited)

					buf, n23 = proto.writeBuffer(v499, v500, v498, buffer.len(v498))
				end

				local buf13 = buffer.create(n23)

				buffer.copy(buf13, 0, buf, 0, n23)

				return buf13
			end
			function t46.decode(p35: buffer) -- line: 7131
				-- upvalues: t46 (copy), proto (copy), prop_types (copy)
				local v503 = t46.new()
				local n24 = 0

				while n24 < buffer.len(p35) do
					local v505, v506

					v505, v506, n24 = proto.readTag(p35, n24)

					if v506 == proto.wireTypes.varint then
						local v507

						v507, n24 = proto.readVarInt(p35, n24)
					elseif v506 == proto.wireTypes.lengthDelimited then
						if v505 == 1 then
							local v508

							v508, n24 = proto.readBuffer(p35, n24)
							v503.item_id = prop_types.StringProp.decode(v508)
						elseif v505 == 2 then
							local v509

							v509, n24 = proto.readBuffer(p35, n24)
							v503.item_type = prop_types.StringProp.decode(v509)
						elseif v505 == 3 then
							local v510

							v510, n24 = proto.readBuffer(p35, n24)
							v503.item_sub_type_name = prop_types.StringProp.decode(v510)
						else
							local v511, v512 = proto.readVarInt(p35, n24)

							n24 = v512 + v511
						end
					elseif v506 == proto.wireTypes.i32 then
						local v513

						v513, n24 = proto.readFixed32(p35, n24)
					elseif v506 == proto.wireTypes.i64 then
						local v514

						v514, n24 = proto.readFixed64(p35, n24)
					else
						error("Unsupported wire type: " .. v506)
					end
				end

				return v503
			end
			function t46.jsonEncode(p36) -- line: 7184
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
			function t46.jsonDecode(t49: {[any]: any}) -- line: 7202
				-- upvalues: t46 (copy), prop_types (copy)
				local v518 = t46.new()

				if t49.item_id ~= nil then
					v518.item_id = prop_types.StringProp.jsonDecode(t49.item_id)
				end

				if t49.itemId ~= nil then
					v518.item_id = prop_types.StringProp.jsonDecode(t49.itemId)
				end

				if t49.item_type ~= nil then
					v518.item_type = prop_types.StringProp.jsonDecode(t49.item_type)
				end

				if t49.itemType ~= nil then
					v518.item_type = prop_types.StringProp.jsonDecode(t49.itemType)
				end

				if t49.item_sub_type_name ~= nil then
					v518.item_sub_type_name = prop_types.StringProp.jsonDecode(t49.item_sub_type_name)
				end

				if t49.itemSubTypeName ~= nil then
					v518.item_sub_type_name = prop_types.StringProp.jsonDecode(t49.itemSubTypeName)
				end

				return v518
			end

			t46.descriptor = {
				name = "OpenMarketplaceTryOnAction_Params",
				fullName = "roblox.apppageplatform.shared.v1beta1.Params"
			}
			t1.OpenMarketplaceTryOnAction_Params = t46
		end

		typeRegistry.default:register(t1.OpenMarketplaceTryOnAction_Params)

		do
			local t50 = {}

			t50.__index = t50

			function t50.new(t51: {[any]: any}?) -- line: 7250
				-- upvalues: t1 (copy), t50 (copy)
				return (setmetatable({
					action_type = if t51 ~= nil and t51.action_type ~= nil then t51.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t51 ~= nil and t51.action_params ~= nil then t51.action_params else nil
				}, t50))
			end
			function t50.encode(p37) -- line: 7259
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n25 = 0

				if p37.action_type ~= nil and (p37.action_type ~= nil and p37.action_type ~= 0 or p37.action_type ~= t1.ActionType.fromNumber(0)) then
					local v523, v524 = proto.writeTag(buf, n25, 1, proto.wireTypes.varint)

					buf, n25 = proto.writeVarInt(v523, v524, t1.ActionType.toNumber(p37.action_type))
				end

				if p37.action_params ~= nil then
					local v525 = p37.action_params:encode()
					local v526, v527 = proto.writeTag(buf, n25, 2, proto.wireTypes.lengthDelimited)

					buf, n25 = proto.writeBuffer(v526, v527, v525, buffer.len(v525))
				end

				local buf14 = buffer.create(n25)

				buffer.copy(buf14, 0, buf, 0, n25)

				return buf14
			end
			function t50.decode(p38: buffer) -- line: 7285
				-- upvalues: t50 (copy), proto (copy), t1 (copy)
				local v530 = t50.new()
				local n26 = 0

				while n26 < buffer.len(p38) do
					local v532, v533

					v532, v533, n26 = proto.readTag(p38, n26)

					if v533 == proto.wireTypes.varint then
						if v532 == 1 then
							local v534

							v534, n26 = proto.readVarIntI32(p38, n26)
							v530.action_type = t1.ActionType.fromNumber(v534) or v534
						else
							local v535

							v535, n26 = proto.readVarInt(p38, n26)
						end
					elseif v533 == proto.wireTypes.lengthDelimited then
						if v532 == 2 then
							local v536

							v536, n26 = proto.readBuffer(p38, n26)
							v530.action_params = t1.OpenSeeAllAction_Params.decode(v536)
						else
							local v537, v538 = proto.readVarInt(p38, n26)

							n26 = v538 + v537
						end
					elseif v533 == proto.wireTypes.i32 then
						local v539

						v539, n26 = proto.readFixed32(p38, n26)
					elseif v533 == proto.wireTypes.i64 then
						local v540

						v540, n26 = proto.readFixed64(p38, n26)
					else
						error("Unsupported wire type: " .. v533)
					end
				end

				return v530
			end
			function t50.jsonEncode(p39) -- line: 7333
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
			function t50.jsonDecode(t53: {[any]: any}) -- line: 7355
				-- upvalues: t50 (copy), t1 (copy)
				local v544 = t50.new()

				if t53.action_type ~= nil then
					v544.action_type = if typeof(t53.action_type) ~= "number" then t1.ActionType.fromName(t53.action_type) or t53.action_type else t1.ActionType.fromNumber(t53.action_type) or t53.action_type
				end

				if t53.actionType ~= nil then
					v544.action_type = if typeof(t53.actionType) ~= "number" then t1.ActionType.fromName(t53.actionType) or t53.actionType else t1.ActionType.fromNumber(t53.actionType) or t53.actionType
				end

				if t53.action_params ~= nil then
					v544.action_params = t1.OpenSeeAllAction_Params.jsonDecode(t53.action_params)
				end

				if t53.actionParams ~= nil then
					v544.action_params = t1.OpenSeeAllAction_Params.jsonDecode(t53.actionParams)
				end

				return v544
			end

			t50.descriptor = {
				name = "OpenSeeAllAction",
				fullName = "roblox.apppageplatform.shared.v1beta1.OpenSeeAllAction"
			}
			t1.OpenSeeAllAction = t50
		end

		typeRegistry.default:register(t1.OpenSeeAllAction)

		do
			local t54 = {}

			t54.__index = t54

			function t54.new(t55: {[any]: any}?) -- line: 7395
				-- upvalues: t54 (copy)
				return (setmetatable({
					collection_id = if t55 ~= nil and t55.collection_id ~= nil then t55.collection_id else nil,
					game_set_target_id = if t55 ~= nil and t55.game_set_target_id ~= nil then t55.game_set_target_id else nil,
					collection_position = if t55 ~= nil and t55.collection_position ~= nil then t55.collection_position else nil
				}, t54))
			end
			function t54.encode(p40) -- line: 7405
				-- upvalues: proto (copy)
				local buf = buffer.create(0)
				local n27 = 0

				if p40.collection_id ~= nil then
					local v549 = p40.collection_id:encode()
					local v550, v551 = proto.writeTag(buf, n27, 1, proto.wireTypes.lengthDelimited)

					buf, n27 = proto.writeBuffer(v550, v551, v549, buffer.len(v549))
				end

				if p40.game_set_target_id ~= nil then
					local v552 = p40.game_set_target_id:encode()
					local v553, v554 = proto.writeTag(buf, n27, 2, proto.wireTypes.lengthDelimited)

					buf, n27 = proto.writeBuffer(v553, v554, v552, buffer.len(v552))
				end

				if p40.collection_position ~= nil then
					local v555 = p40.collection_position:encode()
					local v556, v557 = proto.writeTag(buf, n27, 3, proto.wireTypes.lengthDelimited)

					buf, n27 = proto.writeBuffer(v556, v557, v555, buffer.len(v555))
				end

				local buf15 = buffer.create(n27)

				buffer.copy(buf15, 0, buf, 0, n27)

				return buf15
			end
			function t54.decode(p41: buffer) -- line: 7432
				-- upvalues: t54 (copy), proto (copy), prop_types (copy)
				local v560 = t54.new()
				local n28 = 0

				while n28 < buffer.len(p41) do
					local v562, v563

					v562, v563, n28 = proto.readTag(p41, n28)

					if v563 == proto.wireTypes.varint then
						local v564

						v564, n28 = proto.readVarInt(p41, n28)
					elseif v563 == proto.wireTypes.lengthDelimited then
						if v562 == 1 then
							local v565

							v565, n28 = proto.readBuffer(p41, n28)
							v560.collection_id = prop_types.StringProp.decode(v565)
						elseif v562 == 2 then
							local v566

							v566, n28 = proto.readBuffer(p41, n28)
							v560.game_set_target_id = prop_types.StringProp.decode(v566)
						elseif v562 == 3 then
							local v567

							v567, n28 = proto.readBuffer(p41, n28)
							v560.collection_position = prop_types.StringProp.decode(v567)
						else
							local v568, v569 = proto.readVarInt(p41, n28)

							n28 = v569 + v568
						end
					elseif v563 == proto.wireTypes.i32 then
						local v570

						v570, n28 = proto.readFixed32(p41, n28)
					elseif v563 == proto.wireTypes.i64 then
						local v571

						v571, n28 = proto.readFixed64(p41, n28)
					else
						error("Unsupported wire type: " .. v563)
					end
				end

				return v560
			end
			function t54.jsonEncode(p42) -- line: 7486
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
			function t54.jsonDecode(t57: {[any]: any}) -- line: 7504
				-- upvalues: t54 (copy), prop_types (copy)
				local v575 = t54.new()

				if t57.collection_id ~= nil then
					v575.collection_id = prop_types.StringProp.jsonDecode(t57.collection_id)
				end

				if t57.collectionId ~= nil then
					v575.collection_id = prop_types.StringProp.jsonDecode(t57.collectionId)
				end

				if t57.game_set_target_id ~= nil then
					v575.game_set_target_id = prop_types.StringProp.jsonDecode(t57.game_set_target_id)
				end

				if t57.gameSetTargetId ~= nil then
					v575.game_set_target_id = prop_types.StringProp.jsonDecode(t57.gameSetTargetId)
				end

				if t57.collection_position ~= nil then
					v575.collection_position = prop_types.StringProp.jsonDecode(t57.collection_position)
				end

				if t57.collectionPosition ~= nil then
					v575.collection_position = prop_types.StringProp.jsonDecode(t57.collectionPosition)
				end

				return v575
			end

			t54.descriptor = {
				name = "OpenSeeAllAction_Params",
				fullName = "roblox.apppageplatform.shared.v1beta1.Params"
			}
			t1.OpenSeeAllAction_Params = t54
		end

		typeRegistry.default:register(t1.OpenSeeAllAction_Params)

		do
			local t58 = {}

			t58.__index = t58

			function t58.new(t59: {[any]: any}?) -- line: 7554
				-- upvalues: t1 (copy), t58 (copy)
				return (setmetatable({
					action_type = if t59 ~= nil and t59.action_type ~= nil then t59.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t59 ~= nil and t59.action_params ~= nil then t59.action_params else nil
				}, t58))
			end
			function t58.encode(p43) -- line: 7565
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n29 = 0

				if p43.action_type ~= nil and (p43.action_type ~= nil and p43.action_type ~= 0 or p43.action_type ~= t1.ActionType.fromNumber(0)) then
					local v580, v581 = proto.writeTag(buf, n29, 1, proto.wireTypes.varint)

					buf, n29 = proto.writeVarInt(v580, v581, t1.ActionType.toNumber(p43.action_type))
				end

				if p43.action_params ~= nil then
					local v582 = p43.action_params:encode()
					local v583, v584 = proto.writeTag(buf, n29, 2, proto.wireTypes.lengthDelimited)

					buf, n29 = proto.writeBuffer(v583, v584, v582, buffer.len(v582))
				end

				local buf16 = buffer.create(n29)

				buffer.copy(buf16, 0, buf, 0, n29)

				return buf16
			end
			function t58.decode(p44: buffer) -- line: 7591
				-- upvalues: t58 (copy), proto (copy), t1 (copy)
				local v587 = t58.new()
				local n30 = 0

				while n30 < buffer.len(p44) do
					local v589, v590

					v589, v590, n30 = proto.readTag(p44, n30)

					if v590 == proto.wireTypes.varint then
						if v589 == 1 then
							local v591

							v591, n30 = proto.readVarIntI32(p44, n30)
							v587.action_type = t1.ActionType.fromNumber(v591) or v591
						else
							local v592

							v592, n30 = proto.readVarInt(p44, n30)
						end
					elseif v590 == proto.wireTypes.lengthDelimited then
						if v589 == 2 then
							local v593

							v593, n30 = proto.readBuffer(p44, n30)
							v587.action_params = t1.OpenSponsoredTooltipAction_Params.decode(v593)
						else
							local v594, v595 = proto.readVarInt(p44, n30)

							n30 = v595 + v594
						end
					elseif v590 == proto.wireTypes.i32 then
						local v596

						v596, n30 = proto.readFixed32(p44, n30)
					elseif v590 == proto.wireTypes.i64 then
						local v597

						v597, n30 = proto.readFixed64(p44, n30)
					else
						error("Unsupported wire type: " .. v590)
					end
				end

				return v587
			end
			function t58.jsonEncode(p45) -- line: 7639
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
			function t58.jsonDecode(t61: {[any]: any}) -- line: 7661
				-- upvalues: t58 (copy), t1 (copy)
				local v601 = t58.new()

				if t61.action_type ~= nil then
					v601.action_type = if typeof(t61.action_type) ~= "number" then t1.ActionType.fromName(t61.action_type) or t61.action_type else t1.ActionType.fromNumber(t61.action_type) or t61.action_type
				end

				if t61.actionType ~= nil then
					v601.action_type = if typeof(t61.actionType) ~= "number" then t1.ActionType.fromName(t61.actionType) or t61.actionType else t1.ActionType.fromNumber(t61.actionType) or t61.actionType
				end

				if t61.action_params ~= nil then
					v601.action_params = t1.OpenSponsoredTooltipAction_Params.jsonDecode(t61.action_params)
				end

				if t61.actionParams ~= nil then
					v601.action_params = t1.OpenSponsoredTooltipAction_Params.jsonDecode(t61.actionParams)
				end

				return v601
			end

			t58.descriptor = {
				name = "OpenSponsoredTooltipAction",
				fullName = "roblox.apppageplatform.shared.v1beta1.OpenSponsoredTooltipAction"
			}
			t1.OpenSponsoredTooltipAction = t58
		end

		typeRegistry.default:register(t1.OpenSponsoredTooltipAction)

		do
			local t62 = {}

			t62.__index = t62

			function t62.new(_: {[any]: any}?) -- line: 7701
				-- upvalues: t62 (copy)
				return (setmetatable({}, t62))
			end
			function t62.encode(_) -- line: 7707
				local buf = buffer.create(0)
				local buf17 = buffer.create(0)

				buffer.copy(buf17, 0, buf, 0, 0)

				return buf17
			end
			function t62.decode(p47: buffer) -- line: 7716
				-- upvalues: t62 (copy), proto (copy)
				local v607 = t62.new()
				local n31 = 0

				while n31 < buffer.len(p47) do
					local v609, v610

					v609, v610, n31 = proto.readTag(p47, n31)

					if v610 == proto.wireTypes.varint then
						local v611

						v611, n31 = proto.readVarInt(p47, n31)
					elseif v610 == proto.wireTypes.lengthDelimited then
						local v612, v613 = proto.readVarInt(p47, n31)

						n31 = v613 + v612
					elseif v610 == proto.wireTypes.i32 then
						local v614

						v614, n31 = proto.readFixed32(p47, n31)
					elseif v610 == proto.wireTypes.i64 then
						local v615

						v615, n31 = proto.readFixed64(p47, n31)
					else
						error("Unsupported wire type: " .. v610)
					end
				end

				return v607
			end
			function t62.jsonEncode(_) -- line: 7754
				return {}
			end
			function t62.jsonDecode(_: {[any]: any}) -- line: 7760
				-- upvalues: t62 (copy)
				return (t62.new())
			end

			t62.descriptor = {
				name = "OpenSponsoredTooltipAction_Params",
				fullName = "roblox.apppageplatform.shared.v1beta1.Params"
			}
			t1.OpenSponsoredTooltipAction_Params = t62
		end

		typeRegistry.default:register(t1.OpenSponsoredTooltipAction_Params)

		do
			local t65 = {}

			t65.__index = t65

			function t65.new(t66: {[any]: any}?) -- line: 7782
				-- upvalues: t1 (copy), t65 (copy)
				return (setmetatable({
					action_type = if t66 ~= nil and t66.action_type ~= nil then t66.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t66 ~= nil and t66.action_params ~= nil then t66.action_params else nil
				}, t65))
			end
			function t65.encode(p49) -- line: 7791
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n32 = 0

				if p49.action_type ~= nil and (p49.action_type ~= nil and p49.action_type ~= 0 or p49.action_type ~= t1.ActionType.fromNumber(0)) then
					local v622, v623 = proto.writeTag(buf, n32, 1, proto.wireTypes.varint)

					buf, n32 = proto.writeVarInt(v622, v623, t1.ActionType.toNumber(p49.action_type))
				end

				if p49.action_params ~= nil then
					local v624 = p49.action_params:encode()
					local v625, v626 = proto.writeTag(buf, n32, 2, proto.wireTypes.lengthDelimited)

					buf, n32 = proto.writeBuffer(v625, v626, v624, buffer.len(v624))
				end

				local buf18 = buffer.create(n32)

				buffer.copy(buf18, 0, buf, 0, n32)

				return buf18
			end
			function t65.decode(p50: buffer) -- line: 7817
				-- upvalues: t65 (copy), proto (copy), t1 (copy)
				local v629 = t65.new()
				local n33 = 0

				while n33 < buffer.len(p50) do
					local v631, v632

					v631, v632, n33 = proto.readTag(p50, n33)

					if v632 == proto.wireTypes.varint then
						if v631 == 1 then
							local v633

							v633, n33 = proto.readVarIntI32(p50, n33)
							v629.action_type = t1.ActionType.fromNumber(v633) or v633
						else
							local v634

							v634, n33 = proto.readVarInt(p50, n33)
						end
					elseif v632 == proto.wireTypes.lengthDelimited then
						if v631 == 2 then
							local v635

							v635, n33 = proto.readBuffer(p50, n33)
							v629.action_params = t1.PlayButtonClickAction_Params.decode(v635)
						else
							local v636, v637 = proto.readVarInt(p50, n33)

							n33 = v637 + v636
						end
					elseif v632 == proto.wireTypes.i32 then
						local v638

						v638, n33 = proto.readFixed32(p50, n33)
					elseif v632 == proto.wireTypes.i64 then
						local v639

						v639, n33 = proto.readFixed64(p50, n33)
					else
						error("Unsupported wire type: " .. v632)
					end
				end

				return v629
			end
			function t65.jsonEncode(p51) -- line: 7865
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
			function t65.jsonDecode(t68: {[any]: any}) -- line: 7887
				-- upvalues: t65 (copy), t1 (copy)
				local v643 = t65.new()

				if t68.action_type ~= nil then
					v643.action_type = if typeof(t68.action_type) ~= "number" then t1.ActionType.fromName(t68.action_type) or t68.action_type else t1.ActionType.fromNumber(t68.action_type) or t68.action_type
				end

				if t68.actionType ~= nil then
					v643.action_type = if typeof(t68.actionType) ~= "number" then t1.ActionType.fromName(t68.actionType) or t68.actionType else t1.ActionType.fromNumber(t68.actionType) or t68.actionType
				end

				if t68.action_params ~= nil then
					v643.action_params = t1.PlayButtonClickAction_Params.jsonDecode(t68.action_params)
				end

				if t68.actionParams ~= nil then
					v643.action_params = t1.PlayButtonClickAction_Params.jsonDecode(t68.actionParams)
				end

				return v643
			end

			t65.descriptor = {
				name = "PlayButtonClickAction",
				fullName = "roblox.apppageplatform.shared.v1beta1.PlayButtonClickAction"
			}
			t1.PlayButtonClickAction = t65
		end

		typeRegistry.default:register(t1.PlayButtonClickAction)

		do
			local t69 = {}

			t69.__index = t69

			function t69.new(_: {[any]: any}?) -- line: 7927
				-- upvalues: t69 (copy)
				return (setmetatable({}, t69))
			end
			function t69.encode(_) -- line: 7933
				local buf = buffer.create(0)
				local buf19 = buffer.create(0)

				buffer.copy(buf19, 0, buf, 0, 0)

				return buf19
			end
			function t69.decode(p53: buffer) -- line: 7942
				-- upvalues: t69 (copy), proto (copy)
				local v649 = t69.new()
				local n34 = 0

				while n34 < buffer.len(p53) do
					local v651, v652

					v651, v652, n34 = proto.readTag(p53, n34)

					if v652 == proto.wireTypes.varint then
						local v653

						v653, n34 = proto.readVarInt(p53, n34)
					elseif v652 == proto.wireTypes.lengthDelimited then
						local v654, v655 = proto.readVarInt(p53, n34)

						n34 = v655 + v654
					elseif v652 == proto.wireTypes.i32 then
						local v656

						v656, n34 = proto.readFixed32(p53, n34)
					elseif v652 == proto.wireTypes.i64 then
						local v657

						v657, n34 = proto.readFixed64(p53, n34)
					else
						error("Unsupported wire type: " .. v652)
					end
				end

				return v649
			end
			function t69.jsonEncode(_) -- line: 7980
				return {}
			end
			function t69.jsonDecode(_: {[any]: any}) -- line: 7986
				-- upvalues: t69 (copy)
				return (t69.new())
			end

			t69.descriptor = {
				name = "PlayButtonClickAction_Params",
				fullName = "roblox.apppageplatform.shared.v1beta1.Params"
			}
			t1.PlayButtonClickAction_Params = t69
		end

		typeRegistry.default:register(t1.PlayButtonClickAction_Params)

		do
			local t72 = {}

			t72.__index = t72

			function t72.new(t73: {[any]: any}?) -- line: 8006
				-- upvalues: t1 (copy), t72 (copy)
				return (setmetatable({
					action_type = if t73 ~= nil and t73.action_type ~= nil then t73.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t73 ~= nil and t73.action_params ~= nil then t73.action_params else nil
				}, t72))
			end
			function t72.encode(p55) -- line: 8015
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n35 = 0

				if p55.action_type ~= nil and (p55.action_type ~= nil and p55.action_type ~= 0 or p55.action_type ~= t1.ActionType.fromNumber(0)) then
					local v664, v665 = proto.writeTag(buf, n35, 1, proto.wireTypes.varint)

					buf, n35 = proto.writeVarInt(v664, v665, t1.ActionType.toNumber(p55.action_type))
				end

				if p55.action_params ~= nil then
					local v666 = p55.action_params:encode()
					local v667, v668 = proto.writeTag(buf, n35, 2, proto.wireTypes.lengthDelimited)

					buf, n35 = proto.writeBuffer(v667, v668, v666, buffer.len(v666))
				end

				local buf20 = buffer.create(n35)

				buffer.copy(buf20, 0, buf, 0, n35)

				return buf20
			end
			function t72.decode(p56: buffer) -- line: 8041
				-- upvalues: t72 (copy), proto (copy), t1 (copy)
				local v671 = t72.new()
				local n36 = 0

				while n36 < buffer.len(p56) do
					local v673, v674

					v673, v674, n36 = proto.readTag(p56, n36)

					if v674 == proto.wireTypes.varint then
						if v673 == 1 then
							local v675

							v675, n36 = proto.readVarIntI32(p56, n36)
							v671.action_type = t1.ActionType.fromNumber(v675) or v675
						else
							local v676

							v676, n36 = proto.readVarInt(p56, n36)
						end
					elseif v674 == proto.wireTypes.lengthDelimited then
						if v673 == 2 then
							local v677

							v677, n36 = proto.readBuffer(p56, n36)
							v671.action_params = t1.UpdateUserSettingsAction_Params.decode(v677)
						else
							local v678, v679 = proto.readVarInt(p56, n36)

							n36 = v679 + v678
						end
					elseif v674 == proto.wireTypes.i32 then
						local v680

						v680, n36 = proto.readFixed32(p56, n36)
					elseif v674 == proto.wireTypes.i64 then
						local v681

						v681, n36 = proto.readFixed64(p56, n36)
					else
						error("Unsupported wire type: " .. v674)
					end
				end

				return v671
			end
			function t72.jsonEncode(p57) -- line: 8089
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
			function t72.jsonDecode(t75: {[any]: any}) -- line: 8111
				-- upvalues: t72 (copy), t1 (copy)
				local v685 = t72.new()

				if t75.action_type ~= nil then
					v685.action_type = if typeof(t75.action_type) ~= "number" then t1.ActionType.fromName(t75.action_type) or t75.action_type else t1.ActionType.fromNumber(t75.action_type) or t75.action_type
				end

				if t75.actionType ~= nil then
					v685.action_type = if typeof(t75.actionType) ~= "number" then t1.ActionType.fromName(t75.actionType) or t75.actionType else t1.ActionType.fromNumber(t75.actionType) or t75.actionType
				end

				if t75.action_params ~= nil then
					v685.action_params = t1.UpdateUserSettingsAction_Params.jsonDecode(t75.action_params)
				end

				if t75.actionParams ~= nil then
					v685.action_params = t1.UpdateUserSettingsAction_Params.jsonDecode(t75.actionParams)
				end

				return v685
			end

			t72.descriptor = {
				name = "UpdateUserSettingsAction",
				fullName = "roblox.apppageplatform.shared.v1beta1.UpdateUserSettingsAction"
			}
			t1.UpdateUserSettingsAction = t72
		end

		typeRegistry.default:register(t1.UpdateUserSettingsAction)

		do
			local t76 = {}

			t76.__index = t76

			function t76.new(t77: {[any]: any}?) -- line: 8151
				-- upvalues: t76 (copy)
				return (setmetatable({
					settings = if t77 ~= nil and t77.settings ~= nil then t77.settings else nil,
					audit_data = if t77 ~= nil and t77.audit_data ~= nil then t77.audit_data else nil
				}, t76))
			end
			function t76.encode(p58) -- line: 8160
				-- upvalues: proto (copy)
				local buf = buffer.create(0)
				local n37 = 0

				if p58.settings ~= nil then
					local v690 = p58.settings:encode()
					local v691, v692 = proto.writeTag(buf, n37, 1, proto.wireTypes.lengthDelimited)

					buf, n37 = proto.writeBuffer(v691, v692, v690, buffer.len(v690))
				end

				if p58.audit_data ~= nil then
					local v693 = p58.audit_data:encode()
					local v694, v695 = proto.writeTag(buf, n37, 2, proto.wireTypes.lengthDelimited)

					buf, n37 = proto.writeBuffer(v694, v695, v693, buffer.len(v693))
				end

				local buf21 = buffer.create(n37)

				buffer.copy(buf21, 0, buf, 0, n37)

				return buf21
			end
			function t76.decode(p59: buffer) -- line: 8181
				-- upvalues: t76 (copy), proto (copy), prop_types (copy)
				local v698 = t76.new()
				local n38 = 0

				while n38 < buffer.len(p59) do
					local v700, v701

					v700, v701, n38 = proto.readTag(p59, n38)

					if v701 == proto.wireTypes.varint then
						local v702

						v702, n38 = proto.readVarInt(p59, n38)
					elseif v701 == proto.wireTypes.lengthDelimited then
						if v700 == 1 then
							local v703

							v703, n38 = proto.readBuffer(p59, n38)
							v698.settings = prop_types.StructProp.decode(v703)
						elseif v700 == 2 then
							local v704

							v704, n38 = proto.readBuffer(p59, n38)
							v698.audit_data = prop_types.StringProp.decode(v704)
						else
							local v705, v706 = proto.readVarInt(p59, n38)

							n38 = v706 + v705
						end
					elseif v701 == proto.wireTypes.i32 then
						local v707

						v707, n38 = proto.readFixed32(p59, n38)
					elseif v701 == proto.wireTypes.i64 then
						local v708

						v708, n38 = proto.readFixed64(p59, n38)
					else
						error("Unsupported wire type: " .. v701)
					end
				end

				return v698
			end
			function t76.jsonEncode(p60) -- line: 8229
				local t78 = {}

				if p60.settings ~= nil then
					t78.settings = p60.settings:jsonEncode()
				end

				if p60.audit_data ~= nil then
					t78.auditData = p60.audit_data:jsonEncode()
				end

				return t78
			end
			function t76.jsonDecode(t79: {[any]: any}) -- line: 8243
				-- upvalues: t76 (copy), prop_types (copy)
				local v712 = t76.new()

				if t79.settings ~= nil then
					v712.settings = prop_types.StructProp.jsonDecode(t79.settings)
				end

				if t79.audit_data ~= nil then
					v712.audit_data = prop_types.StringProp.jsonDecode(t79.audit_data)
				end

				if t79.auditData ~= nil then
					v712.audit_data = prop_types.StringProp.jsonDecode(t79.auditData)
				end

				return v712
			end

			t76.descriptor = {
				name = "UpdateUserSettingsAction_Params",
				fullName = "roblox.apppageplatform.shared.v1beta1.Params"
			}
			t1.UpdateUserSettingsAction_Params = t76
		end

		typeRegistry.default:register(t1.UpdateUserSettingsAction_Params)

		do
			local t80 = {}

			t80.__index = t80

			function t80.new(t81: {[any]: any}?) -- line: 8275
				-- upvalues: t1 (copy), t80 (copy)
				return (setmetatable({
					action_type = if t81 ~= nil and t81.action_type ~= nil then t81.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t81 ~= nil and t81.action_params ~= nil then t81.action_params else nil
				}, t80))
			end
			function t80.encode(p61) -- line: 8284
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n39 = 0

				if p61.action_type ~= nil and (p61.action_type ~= nil and p61.action_type ~= 0 or p61.action_type ~= t1.ActionType.fromNumber(0)) then
					local v717, v718 = proto.writeTag(buf, n39, 1, proto.wireTypes.varint)

					buf, n39 = proto.writeVarInt(v717, v718, t1.ActionType.toNumber(p61.action_type))
				end

				if p61.action_params ~= nil then
					local v719 = p61.action_params:encode()
					local v720, v721 = proto.writeTag(buf, n39, 2, proto.wireTypes.lengthDelimited)

					buf, n39 = proto.writeBuffer(v720, v721, v719, buffer.len(v719))
				end

				local buf22 = buffer.create(n39)

				buffer.copy(buf22, 0, buf, 0, n39)

				return buf22
			end
			function t80.decode(p62: buffer) -- line: 8310
				-- upvalues: t80 (copy), proto (copy), t1 (copy)
				local v724 = t80.new()
				local n40 = 0

				while n40 < buffer.len(p62) do
					local v726, v727

					v726, v727, n40 = proto.readTag(p62, n40)

					if v727 == proto.wireTypes.varint then
						if v726 == 1 then
							local v728

							v728, n40 = proto.readVarIntI32(p62, n40)
							v724.action_type = t1.ActionType.fromNumber(v728) or v728
						else
							local v729

							v729, n40 = proto.readVarInt(p62, n40)
						end
					elseif v727 == proto.wireTypes.lengthDelimited then
						if v726 == 2 then
							local v730

							v730, n40 = proto.readBuffer(p62, n40)
							v724.action_params = t1.OpenTooltipAction_Params.decode(v730)
						else
							local v731, v732 = proto.readVarInt(p62, n40)

							n40 = v732 + v731
						end
					elseif v727 == proto.wireTypes.i32 then
						local v733

						v733, n40 = proto.readFixed32(p62, n40)
					elseif v727 == proto.wireTypes.i64 then
						local v734

						v734, n40 = proto.readFixed64(p62, n40)
					else
						error("Unsupported wire type: " .. v727)
					end
				end

				return v724
			end
			function t80.jsonEncode(p63) -- line: 8358
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
			function t80.jsonDecode(t83: {[any]: any}) -- line: 8380
				-- upvalues: t80 (copy), t1 (copy)
				local v738 = t80.new()

				if t83.action_type ~= nil then
					v738.action_type = if typeof(t83.action_type) ~= "number" then t1.ActionType.fromName(t83.action_type) or t83.action_type else t1.ActionType.fromNumber(t83.action_type) or t83.action_type
				end

				if t83.actionType ~= nil then
					v738.action_type = if typeof(t83.actionType) ~= "number" then t1.ActionType.fromName(t83.actionType) or t83.actionType else t1.ActionType.fromNumber(t83.actionType) or t83.actionType
				end

				if t83.action_params ~= nil then
					v738.action_params = t1.OpenTooltipAction_Params.jsonDecode(t83.action_params)
				end

				if t83.actionParams ~= nil then
					v738.action_params = t1.OpenTooltipAction_Params.jsonDecode(t83.actionParams)
				end

				return v738
			end

			t80.descriptor = {
				name = "OpenTooltipAction",
				fullName = "roblox.apppageplatform.shared.v1beta1.OpenTooltipAction"
			}
			t1.OpenTooltipAction = t80
		end

		typeRegistry.default:register(t1.OpenTooltipAction)

		do
			local t84 = {}

			t84.__index = t84

			function t84.new(t85: {[any]: any}?) -- line: 8420
				-- upvalues: t84 (copy)
				return (setmetatable({
					tooltip_title = if t85 ~= nil and t85.tooltip_title ~= nil then t85.tooltip_title else nil,
					tooltip_info_text = if t85 ~= nil and t85.tooltip_info_text ~= nil then t85.tooltip_info_text else nil
				}, t84))
			end
			function t84.encode(p64) -- line: 8427
				-- upvalues: proto (copy)
				local buf = buffer.create(0)
				local n41 = 0

				if p64.tooltip_title ~= nil then
					local v743 = p64.tooltip_title:encode()
					local v744, v745 = proto.writeTag(buf, n41, 1, proto.wireTypes.lengthDelimited)

					buf, n41 = proto.writeBuffer(v744, v745, v743, buffer.len(v743))
				end

				if p64.tooltip_info_text ~= nil then
					local v746 = p64.tooltip_info_text:encode()
					local v747, v748 = proto.writeTag(buf, n41, 2, proto.wireTypes.lengthDelimited)

					buf, n41 = proto.writeBuffer(v747, v748, v746, buffer.len(v746))
				end

				local buf23 = buffer.create(n41)

				buffer.copy(buf23, 0, buf, 0, n41)

				return buf23
			end
			function t84.decode(p65: buffer) -- line: 8448
				-- upvalues: t84 (copy), proto (copy), prop_types (copy)
				local v751 = t84.new()
				local n42 = 0

				while n42 < buffer.len(p65) do
					local v753, v754

					v753, v754, n42 = proto.readTag(p65, n42)

					if v754 == proto.wireTypes.varint then
						local v755

						v755, n42 = proto.readVarInt(p65, n42)
					elseif v754 == proto.wireTypes.lengthDelimited then
						if v753 == 1 then
							local v756

							v756, n42 = proto.readBuffer(p65, n42)
							v751.tooltip_title = prop_types.StringProp.decode(v756)
						elseif v753 == 2 then
							local v757

							v757, n42 = proto.readBuffer(p65, n42)
							v751.tooltip_info_text = prop_types.StringProp.decode(v757)
						else
							local v758, v759 = proto.readVarInt(p65, n42)

							n42 = v759 + v758
						end
					elseif v754 == proto.wireTypes.i32 then
						local v760

						v760, n42 = proto.readFixed32(p65, n42)
					elseif v754 == proto.wireTypes.i64 then
						local v761

						v761, n42 = proto.readFixed64(p65, n42)
					else
						error("Unsupported wire type: " .. v754)
					end
				end

				return v751
			end
			function t84.jsonEncode(p66) -- line: 8496
				local t86 = {}

				if p66.tooltip_title ~= nil then
					t86.tooltipTitle = p66.tooltip_title:jsonEncode()
				end

				if p66.tooltip_info_text ~= nil then
					t86.tooltipInfoText = p66.tooltip_info_text:jsonEncode()
				end

				return t86
			end
			function t84.jsonDecode(t87: {[any]: any}) -- line: 8510
				-- upvalues: t84 (copy), prop_types (copy)
				local v765 = t84.new()

				if t87.tooltip_title ~= nil then
					v765.tooltip_title = prop_types.StringProp.jsonDecode(t87.tooltip_title)
				end

				if t87.tooltipTitle ~= nil then
					v765.tooltip_title = prop_types.StringProp.jsonDecode(t87.tooltipTitle)
				end

				if t87.tooltip_info_text ~= nil then
					v765.tooltip_info_text = prop_types.StringProp.jsonDecode(t87.tooltip_info_text)
				end

				if t87.tooltipInfoText ~= nil then
					v765.tooltip_info_text = prop_types.StringProp.jsonDecode(t87.tooltipInfoText)
				end

				return v765
			end

			t84.descriptor = {
				name = "OpenTooltipAction_Params",
				fullName = "roblox.apppageplatform.shared.v1beta1.Params"
			}
			t1.OpenTooltipAction_Params = t84
		end

		typeRegistry.default:register(t1.OpenTooltipAction_Params)

		do
			local t88 = {}

			t88.__index = t88

			function t88.new(t89: {[any]: any}?) -- line: 8550
				-- upvalues: t1 (copy), t88 (copy)
				return (setmetatable({
					action_type = if t89 ~= nil and t89.action_type ~= nil then t89.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t89 ~= nil and t89.action_params ~= nil then t89.action_params else nil
				}, t88))
			end
			function t88.encode(p67) -- line: 8559
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n43 = 0

				if p67.action_type ~= nil and (p67.action_type ~= nil and p67.action_type ~= 0 or p67.action_type ~= t1.ActionType.fromNumber(0)) then
					local v770, v771 = proto.writeTag(buf, n43, 1, proto.wireTypes.varint)

					buf, n43 = proto.writeVarInt(v770, v771, t1.ActionType.toNumber(p67.action_type))
				end

				if p67.action_params ~= nil then
					local v772 = p67.action_params:encode()
					local v773, v774 = proto.writeTag(buf, n43, 2, proto.wireTypes.lengthDelimited)

					buf, n43 = proto.writeBuffer(v773, v774, v772, buffer.len(v772))
				end

				local buf24 = buffer.create(n43)

				buffer.copy(buf24, 0, buf, 0, n43)

				return buf24
			end
			function t88.decode(p68: buffer) -- line: 8585
				-- upvalues: t88 (copy), proto (copy), t1 (copy)
				local v777 = t88.new()
				local n44 = 0

				while n44 < buffer.len(p68) do
					local v779, v780

					v779, v780, n44 = proto.readTag(p68, n44)

					if v780 == proto.wireTypes.varint then
						if v779 == 1 then
							local v781

							v781, n44 = proto.readVarIntI32(p68, n44)
							v777.action_type = t1.ActionType.fromNumber(v781) or v781
						else
							local v782

							v782, n44 = proto.readVarInt(p68, n44)
						end
					elseif v780 == proto.wireTypes.lengthDelimited then
						if v779 == 2 then
							local v783

							v783, n44 = proto.readBuffer(p68, n44)
							v777.action_params = t1.OpenBadgeDetailsAction_Params.decode(v783)
						else
							local v784, v785 = proto.readVarInt(p68, n44)

							n44 = v785 + v784
						end
					elseif v780 == proto.wireTypes.i32 then
						local v786

						v786, n44 = proto.readFixed32(p68, n44)
					elseif v780 == proto.wireTypes.i64 then
						local v787

						v787, n44 = proto.readFixed64(p68, n44)
					else
						error("Unsupported wire type: " .. v780)
					end
				end

				return v777
			end
			function t88.jsonEncode(p69) -- line: 8633
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
			function t88.jsonDecode(t91: {[any]: any}) -- line: 8655
				-- upvalues: t88 (copy), t1 (copy)
				local v791 = t88.new()

				if t91.action_type ~= nil then
					v791.action_type = if typeof(t91.action_type) ~= "number" then t1.ActionType.fromName(t91.action_type) or t91.action_type else t1.ActionType.fromNumber(t91.action_type) or t91.action_type
				end

				if t91.actionType ~= nil then
					v791.action_type = if typeof(t91.actionType) ~= "number" then t1.ActionType.fromName(t91.actionType) or t91.actionType else t1.ActionType.fromNumber(t91.actionType) or t91.actionType
				end

				if t91.action_params ~= nil then
					v791.action_params = t1.OpenBadgeDetailsAction_Params.jsonDecode(t91.action_params)
				end

				if t91.actionParams ~= nil then
					v791.action_params = t1.OpenBadgeDetailsAction_Params.jsonDecode(t91.actionParams)
				end

				return v791
			end

			t88.descriptor = {
				name = "OpenBadgeDetailsAction",
				fullName = "roblox.apppageplatform.shared.v1beta1.OpenBadgeDetailsAction"
			}
			t1.OpenBadgeDetailsAction = t88
		end

		typeRegistry.default:register(t1.OpenBadgeDetailsAction)

		do
			local t92 = {}

			t92.__index = t92

			function t92.new(t93: {[any]: any}?) -- line: 8695
				-- upvalues: t92 (copy)
				return (setmetatable({
					badge_id = if t93 ~= nil and t93.badge_id ~= nil then t93.badge_id else nil,
					title_text = if t93 ~= nil and t93.title_text ~= nil then t93.title_text else nil
				}, t92))
			end
			function t92.encode(p70) -- line: 8704
				-- upvalues: proto (copy)
				local buf = buffer.create(0)
				local n45 = 0

				if p70.badge_id ~= nil then
					local v796 = p70.badge_id:encode()
					local v797, v798 = proto.writeTag(buf, n45, 1, proto.wireTypes.lengthDelimited)

					buf, n45 = proto.writeBuffer(v797, v798, v796, buffer.len(v796))
				end

				if p70.title_text ~= nil then
					local v799 = p70.title_text:encode()
					local v800, v801 = proto.writeTag(buf, n45, 2, proto.wireTypes.lengthDelimited)

					buf, n45 = proto.writeBuffer(v800, v801, v799, buffer.len(v799))
				end

				local buf25 = buffer.create(n45)

				buffer.copy(buf25, 0, buf, 0, n45)

				return buf25
			end
			function t92.decode(p71: buffer) -- line: 8725
				-- upvalues: t92 (copy), proto (copy), prop_types (copy)
				local v804 = t92.new()
				local n46 = 0

				while n46 < buffer.len(p71) do
					local v806, v807

					v806, v807, n46 = proto.readTag(p71, n46)

					if v807 == proto.wireTypes.varint then
						local v808

						v808, n46 = proto.readVarInt(p71, n46)
					elseif v807 == proto.wireTypes.lengthDelimited then
						if v806 == 1 then
							local v809

							v809, n46 = proto.readBuffer(p71, n46)
							v804.badge_id = prop_types.StringProp.decode(v809)
						elseif v806 == 2 then
							local v810

							v810, n46 = proto.readBuffer(p71, n46)
							v804.title_text = prop_types.StringProp.decode(v810)
						else
							local v811, v812 = proto.readVarInt(p71, n46)

							n46 = v812 + v811
						end
					elseif v807 == proto.wireTypes.i32 then
						local v813

						v813, n46 = proto.readFixed32(p71, n46)
					elseif v807 == proto.wireTypes.i64 then
						local v814

						v814, n46 = proto.readFixed64(p71, n46)
					else
						error("Unsupported wire type: " .. v807)
					end
				end

				return v804
			end
			function t92.jsonEncode(p72) -- line: 8773
				local t94 = {}

				if p72.badge_id ~= nil then
					t94.badgeId = p72.badge_id:jsonEncode()
				end

				if p72.title_text ~= nil then
					t94.titleText = p72.title_text:jsonEncode()
				end

				return t94
			end
			function t92.jsonDecode(t95: {[any]: any}) -- line: 8787
				-- upvalues: t92 (copy), prop_types (copy)
				local v818 = t92.new()

				if t95.badge_id ~= nil then
					v818.badge_id = prop_types.StringProp.jsonDecode(t95.badge_id)
				end

				if t95.badgeId ~= nil then
					v818.badge_id = prop_types.StringProp.jsonDecode(t95.badgeId)
				end

				if t95.title_text ~= nil then
					v818.title_text = prop_types.StringProp.jsonDecode(t95.title_text)
				end

				if t95.titleText ~= nil then
					v818.title_text = prop_types.StringProp.jsonDecode(t95.titleText)
				end

				return v818
			end

			t92.descriptor = {
				name = "OpenBadgeDetailsAction_Params",
				fullName = "roblox.apppageplatform.shared.v1beta1.Params"
			}
			t1.OpenBadgeDetailsAction_Params = t92
		end

		typeRegistry.default:register(t1.OpenBadgeDetailsAction_Params)

		do
			local t96 = {}

			t96.__index = t96

			function t96.new(t97: {[any]: any}?) -- line: 8823
				-- upvalues: t1 (copy), t96 (copy)
				return (setmetatable({
					action_type = if t97 ~= nil and t97.action_type ~= nil then t97.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t97 ~= nil and t97.action_params ~= nil then t97.action_params else nil
				}, t96))
			end
			function t96.encode(p73) -- line: 8832
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n47 = 0

				if p73.action_type ~= nil and (p73.action_type ~= nil and p73.action_type ~= 0 or p73.action_type ~= t1.ActionType.fromNumber(0)) then
					local v823, v824 = proto.writeTag(buf, n47, 1, proto.wireTypes.varint)

					buf, n47 = proto.writeVarInt(v823, v824, t1.ActionType.toNumber(p73.action_type))
				end

				if p73.action_params ~= nil then
					local v825 = p73.action_params:encode()
					local v826, v827 = proto.writeTag(buf, n47, 2, proto.wireTypes.lengthDelimited)

					buf, n47 = proto.writeBuffer(v826, v827, v825, buffer.len(v825))
				end

				local buf26 = buffer.create(n47)

				buffer.copy(buf26, 0, buf, 0, n47)

				return buf26
			end
			function t96.decode(p74: buffer) -- line: 8858
				-- upvalues: t96 (copy), proto (copy), t1 (copy)
				local v830 = t96.new()
				local n48 = 0

				while n48 < buffer.len(p74) do
					local v832, v833

					v832, v833, n48 = proto.readTag(p74, n48)

					if v833 == proto.wireTypes.varint then
						if v832 == 1 then
							local v834

							v834, n48 = proto.readVarIntI32(p74, n48)
							v830.action_type = t1.ActionType.fromNumber(v834) or v834
						else
							local v835

							v835, n48 = proto.readVarInt(p74, n48)
						end
					elseif v833 == proto.wireTypes.lengthDelimited then
						if v832 == 2 then
							local v836

							v836, n48 = proto.readBuffer(p74, n48)
							v830.action_params = t1.LoadMoreFromApiAction_Params.decode(v836)
						else
							local v837, v838 = proto.readVarInt(p74, n48)

							n48 = v838 + v837
						end
					elseif v833 == proto.wireTypes.i32 then
						local v839

						v839, n48 = proto.readFixed32(p74, n48)
					elseif v833 == proto.wireTypes.i64 then
						local v840

						v840, n48 = proto.readFixed64(p74, n48)
					else
						error("Unsupported wire type: " .. v833)
					end
				end

				return v830
			end
			function t96.jsonEncode(p75) -- line: 8906
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
			function t96.jsonDecode(t99: {[any]: any}) -- line: 8928
				-- upvalues: t96 (copy), t1 (copy)
				local v844 = t96.new()

				if t99.action_type ~= nil then
					v844.action_type = if typeof(t99.action_type) ~= "number" then t1.ActionType.fromName(t99.action_type) or t99.action_type else t1.ActionType.fromNumber(t99.action_type) or t99.action_type
				end

				if t99.actionType ~= nil then
					v844.action_type = if typeof(t99.actionType) ~= "number" then t1.ActionType.fromName(t99.actionType) or t99.actionType else t1.ActionType.fromNumber(t99.actionType) or t99.actionType
				end

				if t99.action_params ~= nil then
					v844.action_params = t1.LoadMoreFromApiAction_Params.jsonDecode(t99.action_params)
				end

				if t99.actionParams ~= nil then
					v844.action_params = t1.LoadMoreFromApiAction_Params.jsonDecode(t99.actionParams)
				end

				return v844
			end

			t96.descriptor = {
				name = "LoadMoreFromApiAction",
				fullName = "roblox.apppageplatform.shared.v1beta1.LoadMoreFromApiAction"
			}
			t1.LoadMoreFromApiAction = t96
		end

		typeRegistry.default:register(t1.LoadMoreFromApiAction)

		do
			local t100 = {}

			t100.__index = t100

			function t100.new(t101: {[any]: any}?) -- line: 8968
				-- upvalues: t100 (copy)
				return (setmetatable({
					surface_key = if t101 ~= nil and t101.surface_key ~= nil then t101.surface_key else nil,
					config_key = if t101 ~= nil and t101.config_key ~= nil then t101.config_key else nil
				}, t100))
			end
			function t100.encode(p76) -- line: 8977
				-- upvalues: proto (copy)
				local buf = buffer.create(0)
				local n49 = 0

				if p76.surface_key ~= nil then
					local v849 = p76.surface_key:encode()
					local v850, v851 = proto.writeTag(buf, n49, 1, proto.wireTypes.lengthDelimited)

					buf, n49 = proto.writeBuffer(v850, v851, v849, buffer.len(v849))
				end

				if p76.config_key ~= nil then
					local v852 = p76.config_key:encode()
					local v853, v854 = proto.writeTag(buf, n49, 2, proto.wireTypes.lengthDelimited)

					buf, n49 = proto.writeBuffer(v853, v854, v852, buffer.len(v852))
				end

				local buf27 = buffer.create(n49)

				buffer.copy(buf27, 0, buf, 0, n49)

				return buf27
			end
			function t100.decode(p77: buffer) -- line: 8998
				-- upvalues: t100 (copy), proto (copy), prop_types (copy)
				local v857 = t100.new()
				local n50 = 0

				while n50 < buffer.len(p77) do
					local v859, v860

					v859, v860, n50 = proto.readTag(p77, n50)

					if v860 == proto.wireTypes.varint then
						local v861

						v861, n50 = proto.readVarInt(p77, n50)
					elseif v860 == proto.wireTypes.lengthDelimited then
						if v859 == 1 then
							local v862

							v862, n50 = proto.readBuffer(p77, n50)
							v857.surface_key = prop_types.StringProp.decode(v862)
						elseif v859 == 2 then
							local v863

							v863, n50 = proto.readBuffer(p77, n50)
							v857.config_key = prop_types.StringProp.decode(v863)
						else
							local v864, v865 = proto.readVarInt(p77, n50)

							n50 = v865 + v864
						end
					elseif v860 == proto.wireTypes.i32 then
						local v866

						v866, n50 = proto.readFixed32(p77, n50)
					elseif v860 == proto.wireTypes.i64 then
						local v867

						v867, n50 = proto.readFixed64(p77, n50)
					else
						error("Unsupported wire type: " .. v860)
					end
				end

				return v857
			end
			function t100.jsonEncode(p78) -- line: 9046
				local t102 = {}

				if p78.surface_key ~= nil then
					t102.surfaceKey = p78.surface_key:jsonEncode()
				end

				if p78.config_key ~= nil then
					t102.configKey = p78.config_key:jsonEncode()
				end

				return t102
			end
			function t100.jsonDecode(t103: {[any]: any}) -- line: 9060
				-- upvalues: t100 (copy), prop_types (copy)
				local v871 = t100.new()

				if t103.surface_key ~= nil then
					v871.surface_key = prop_types.StringProp.jsonDecode(t103.surface_key)
				end

				if t103.surfaceKey ~= nil then
					v871.surface_key = prop_types.StringProp.jsonDecode(t103.surfaceKey)
				end

				if t103.config_key ~= nil then
					v871.config_key = prop_types.StringProp.jsonDecode(t103.config_key)
				end

				if t103.configKey ~= nil then
					v871.config_key = prop_types.StringProp.jsonDecode(t103.configKey)
				end

				return v871
			end

			t100.descriptor = {
				name = "LoadMoreFromApiAction_Params",
				fullName = "roblox.apppageplatform.shared.v1beta1.Params"
			}
			t1.LoadMoreFromApiAction_Params = t100
		end

		typeRegistry.default:register(t1.LoadMoreFromApiAction_Params)

		do
			local t104 = {}

			t104.__index = t104

			function t104.new(t105: {[any]: any}?) -- line: 9097
				-- upvalues: t1 (copy), t104 (copy)
				return (setmetatable({
					action_type = if t105 ~= nil and t105.action_type ~= nil then t105.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t105 ~= nil and t105.action_params ~= nil then t105.action_params else nil
				}, t104))
			end
			function t104.encode(p79) -- line: 9106
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n51 = 0

				if p79.action_type ~= nil and (p79.action_type ~= nil and p79.action_type ~= 0 or p79.action_type ~= t1.ActionType.fromNumber(0)) then
					local v876, v877 = proto.writeTag(buf, n51, 1, proto.wireTypes.varint)

					buf, n51 = proto.writeVarInt(v876, v877, t1.ActionType.toNumber(p79.action_type))
				end

				if p79.action_params ~= nil then
					local v878 = p79.action_params:encode()
					local v879, v880 = proto.writeTag(buf, n51, 2, proto.wireTypes.lengthDelimited)

					buf, n51 = proto.writeBuffer(v879, v880, v878, buffer.len(v878))
				end

				local buf28 = buffer.create(n51)

				buffer.copy(buf28, 0, buf, 0, n51)

				return buf28
			end
			function t104.decode(p80: buffer) -- line: 9132
				-- upvalues: t104 (copy), proto (copy), t1 (copy)
				local v883 = t104.new()
				local n52 = 0

				while n52 < buffer.len(p80) do
					local v885, v886

					v885, v886, n52 = proto.readTag(p80, n52)

					if v886 == proto.wireTypes.varint then
						if v885 == 1 then
							local v887

							v887, n52 = proto.readVarIntI32(p80, n52)
							v883.action_type = t1.ActionType.fromNumber(v887) or v887
						else
							local v888

							v888, n52 = proto.readVarInt(p80, n52)
						end
					elseif v886 == proto.wireTypes.lengthDelimited then
						if v885 == 2 then
							local v889

							v889, n52 = proto.readBuffer(p80, n52)
							v883.action_params = t1.ShareAction_Params.decode(v889)
						else
							local v890, v891 = proto.readVarInt(p80, n52)

							n52 = v891 + v890
						end
					elseif v886 == proto.wireTypes.i32 then
						local v892

						v892, n52 = proto.readFixed32(p80, n52)
					elseif v886 == proto.wireTypes.i64 then
						local v893

						v893, n52 = proto.readFixed64(p80, n52)
					else
						error("Unsupported wire type: " .. v886)
					end
				end

				return v883
			end
			function t104.jsonEncode(p81) -- line: 9180
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
			function t104.jsonDecode(t107: {[any]: any}) -- line: 9202
				-- upvalues: t104 (copy), t1 (copy)
				local v897 = t104.new()

				if t107.action_type ~= nil then
					v897.action_type = if typeof(t107.action_type) ~= "number" then t1.ActionType.fromName(t107.action_type) or t107.action_type else t1.ActionType.fromNumber(t107.action_type) or t107.action_type
				end

				if t107.actionType ~= nil then
					v897.action_type = if typeof(t107.actionType) ~= "number" then t1.ActionType.fromName(t107.actionType) or t107.actionType else t1.ActionType.fromNumber(t107.actionType) or t107.actionType
				end

				if t107.action_params ~= nil then
					v897.action_params = t1.ShareAction_Params.jsonDecode(t107.action_params)
				end

				if t107.actionParams ~= nil then
					v897.action_params = t1.ShareAction_Params.jsonDecode(t107.actionParams)
				end

				return v897
			end

			t104.descriptor = {
				name = "ShareAction",
				fullName = "roblox.apppageplatform.shared.v1beta1.ShareAction"
			}
			t1.ShareAction = t104
		end

		typeRegistry.default:register(t1.ShareAction)

		local t108 = {}

		t108.__index = t108

		function t108.new(t109: {[any]: any}?) -- line: 9242
			-- upvalues: t108 (copy)
			return (setmetatable({
				oneof_prop = if t109 ~= nil and t109.oneof_prop ~= nil then t109.oneof_prop else nil
			}, t108))
		end
		function t108.encode(p82) -- line: 9250
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n53 = 0

			if p82.oneof_prop ~= nil then
				if p82.oneof_prop.type == "generic_share_link_data" then
					local v902 = p82.oneof_prop.value:encode()
					local v903, v904 = proto.writeTag(buf, n53, 1, proto.wireTypes.lengthDelimited)

					buf, n53 = proto.writeBuffer(v903, v904, v902, buffer.len(v902))
				elseif p82.oneof_prop.type == "share_link_fetch_data" then
					local v905 = p82.oneof_prop.value:encode()
					local v906, v907 = proto.writeTag(buf, n53, 2, proto.wireTypes.lengthDelimited)

					buf, n53 = proto.writeBuffer(v906, v907, v905, buffer.len(v905))
				end
			end

			local buf29 = buffer.create(n53)

			buffer.copy(buf29, 0, buf, 0, n53)

			return buf29
		end
		function t108.decode(p83: buffer) -- line: 9271
			-- upvalues: t108 (copy), proto (copy), share_link_data (copy)
			local v910 = t108.new()
			local n54 = 0

			while n54 < buffer.len(p83) do
				local v912, v913

				v912, v913, n54 = proto.readTag(p83, n54)

				if v913 == proto.wireTypes.varint then
					local v914

					v914, n54 = proto.readVarInt(p83, n54)
				elseif v913 == proto.wireTypes.lengthDelimited then
					if v912 == 1 then
						local v915

						v915, n54 = proto.readBuffer(p83, n54)
						v910.oneof_prop = {
							type = "generic_share_link_data",
							value = share_link_data.GenericShareLinkData.decode(v915)
						}
					elseif v912 == 2 then
						local v916

						v916, n54 = proto.readBuffer(p83, n54)
						v910.oneof_prop = {
							type = "share_link_fetch_data",
							value = share_link_data.ShareLinkFetchData.decode(v916)
						}
					else
						local v917, v918 = proto.readVarInt(p83, n54)

						n54 = v918 + v917
					end
				elseif v913 == proto.wireTypes.i32 then
					local v919

					v919, n54 = proto.readFixed32(p83, n54)
				elseif v913 == proto.wireTypes.i64 then
					local v920

					v920, n54 = proto.readFixed64(p83, n54)
				else
					error("Unsupported wire type: " .. v913)
				end
			end

			return v910
		end
		function t108.jsonEncode(p84) -- line: 9327
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
		function t108.jsonDecode(t111: {[any]: any}) -- line: 9341
			-- upvalues: t108 (copy), share_link_data (copy)
			local v924 = t108.new()

			if t111.generic_share_link_data ~= nil then
				v924.oneof_prop = {
					type = "generic_share_link_data",
					value = share_link_data.GenericShareLinkData.jsonDecode(t111.generic_share_link_data)
				}
			end

			if t111.genericShareLinkData ~= nil then
				v924.oneof_prop = {
					type = "generic_share_link_data",
					value = share_link_data.GenericShareLinkData.jsonDecode(t111.genericShareLinkData)
				}
			end

			if t111.share_link_fetch_data ~= nil then
				v924.oneof_prop = {
					type = "share_link_fetch_data",
					value = share_link_data.ShareLinkFetchData.jsonDecode(t111.share_link_fetch_data)
				}
			end

			if t111.shareLinkFetchData ~= nil then
				v924.oneof_prop = {
					type = "share_link_fetch_data",
					value = share_link_data.ShareLinkFetchData.jsonDecode(t111.shareLinkFetchData)
				}
			end

			return v924
		end

		t108.descriptor = {
			name = "ShareAction_ShareLinkData",
			fullName = "roblox.apppageplatform.shared.v1beta1.ShareLinkData"
		}
		t1.ShareAction_ShareLinkData = t108
	end

	typeRegistry.default:register(t1.ShareAction_ShareLinkData)

	do
		local t112 = {}

		t112.__index = t112

		function t112.new(t113: {[any]: any}?) -- line: 9397
			-- upvalues: t112 (copy)
			return (setmetatable({
				share_link_type = if t113 ~= nil and t113.share_link_type ~= nil then t113.share_link_type else nil,
				share_link_data = if t113 ~= nil and t113.share_link_data ~= nil then t113.share_link_data else nil,
				entry_point_key = if t113 ~= nil and t113.entry_point_key ~= nil then t113.entry_point_key else nil
			}, t112))
		end
		function t112.encode(p85) -- line: 9405
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n55 = 0

			if p85.share_link_type ~= nil then
				local v929 = p85.share_link_type:encode()
				local v930, v931 = proto.writeTag(buf, n55, 1, proto.wireTypes.lengthDelimited)

				buf, n55 = proto.writeBuffer(v930, v931, v929, buffer.len(v929))
			end

			if p85.share_link_data ~= nil then
				local v932 = p85.share_link_data:encode()
				local v933, v934 = proto.writeTag(buf, n55, 2, proto.wireTypes.lengthDelimited)

				buf, n55 = proto.writeBuffer(v933, v934, v932, buffer.len(v932))
			end

			if p85.entry_point_key ~= nil then
				local v935 = p85.entry_point_key:encode()
				local v936, v937 = proto.writeTag(buf, n55, 3, proto.wireTypes.lengthDelimited)

				buf, n55 = proto.writeBuffer(v936, v937, v935, buffer.len(v935))
			end

			local buf30 = buffer.create(n55)

			buffer.copy(buf30, 0, buf, 0, n55)

			return buf30
		end
		function t112.decode(p86: buffer) -- line: 9432
			-- upvalues: t112 (copy), proto (copy), prop_types (copy), t1 (copy)
			local v940 = t112.new()
			local n56 = 0

			while n56 < buffer.len(p86) do
				local v942, v943

				v942, v943, n56 = proto.readTag(p86, n56)

				if v943 == proto.wireTypes.varint then
					local v944

					v944, n56 = proto.readVarInt(p86, n56)
				elseif v943 == proto.wireTypes.lengthDelimited then
					if v942 == 1 then
						local v945

						v945, n56 = proto.readBuffer(p86, n56)
						v940.share_link_type = prop_types.StringProp.decode(v945)
					elseif v942 == 2 then
						local v946

						v946, n56 = proto.readBuffer(p86, n56)
						v940.share_link_data = t1.ShareAction_ShareLinkData.decode(v946)
					elseif v942 == 3 then
						local v947

						v947, n56 = proto.readBuffer(p86, n56)
						v940.entry_point_key = prop_types.StringProp.decode(v947)
					else
						local v948, v949 = proto.readVarInt(p86, n56)

						n56 = v949 + v948
					end
				elseif v943 == proto.wireTypes.i32 then
					local v950

					v950, n56 = proto.readFixed32(p86, n56)
				elseif v943 == proto.wireTypes.i64 then
					local v951

					v951, n56 = proto.readFixed64(p86, n56)
				else
					error("Unsupported wire type: " .. v943)
				end
			end

			return v940
		end
		function t112.jsonEncode(p87) -- line: 9485
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
		function t112.jsonDecode(t115: {[any]: any}) -- line: 9503
			-- upvalues: t112 (copy), prop_types (copy), t1 (copy)
			local v955 = t112.new()

			if t115.share_link_type ~= nil then
				v955.share_link_type = prop_types.StringProp.jsonDecode(t115.share_link_type)
			end

			if t115.shareLinkType ~= nil then
				v955.share_link_type = prop_types.StringProp.jsonDecode(t115.shareLinkType)
			end

			if t115.share_link_data ~= nil then
				v955.share_link_data = t1.ShareAction_ShareLinkData.jsonDecode(t115.share_link_data)
			end

			if t115.shareLinkData ~= nil then
				v955.share_link_data = t1.ShareAction_ShareLinkData.jsonDecode(t115.shareLinkData)
			end

			if t115.entry_point_key ~= nil then
				v955.entry_point_key = prop_types.StringProp.jsonDecode(t115.entry_point_key)
			end

			if t115.entryPointKey ~= nil then
				v955.entry_point_key = prop_types.StringProp.jsonDecode(t115.entryPointKey)
			end

			return v955
		end

		t112.descriptor = {
			name = "ShareAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.ShareAction_Params = t112
		typeRegistry.default:register(t1.ShareAction_Params)

		local t116 = {}

		t116.__index = t116

		function t116.new(t117: {[any]: any}?) -- line: 9551
			-- upvalues: t1 (copy), t116 (copy)
			return (setmetatable({
				action_type = if t117 ~= nil and t117.action_type ~= nil then t117.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t117 ~= nil and t117.action_params ~= nil then t117.action_params else nil
			}, t116))
		end
		function t116.encode(p88) -- line: 9560
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n57 = 0

			if p88.action_type ~= nil and (p88.action_type ~= nil and p88.action_type ~= 0 or p88.action_type ~= t1.ActionType.fromNumber(0)) then
				local v960, v961 = proto.writeTag(buf, n57, 1, proto.wireTypes.varint)

				buf, n57 = proto.writeVarInt(v960, v961, t1.ActionType.toNumber(p88.action_type))
			end

			if p88.action_params ~= nil then
				local v962 = p88.action_params:encode()
				local v963, v964 = proto.writeTag(buf, n57, 2, proto.wireTypes.lengthDelimited)

				buf, n57 = proto.writeBuffer(v963, v964, v962, buffer.len(v962))
			end

			local buf31 = buffer.create(n57)

			buffer.copy(buf31, 0, buf, 0, n57)

			return buf31
		end
		function t116.decode(p89: buffer) -- line: 9586
			-- upvalues: t116 (copy), proto (copy), t1 (copy)
			local v967 = t116.new()
			local n58 = 0

			while n58 < buffer.len(p89) do
				local v969, v970

				v969, v970, n58 = proto.readTag(p89, n58)

				if v970 == proto.wireTypes.varint then
					if v969 == 1 then
						local v971

						v971, n58 = proto.readVarIntI32(p89, n58)
						v967.action_type = t1.ActionType.fromNumber(v971) or v971
					else
						local v972

						v972, n58 = proto.readVarInt(p89, n58)
					end
				elseif v970 == proto.wireTypes.lengthDelimited then
					if v969 == 2 then
						local v973

						v973, n58 = proto.readBuffer(p89, n58)
						v967.action_params = t1.OpenAbuseReportAction_Params.decode(v973)
					else
						local v974, v975 = proto.readVarInt(p89, n58)

						n58 = v975 + v974
					end
				elseif v970 == proto.wireTypes.i32 then
					local v976

					v976, n58 = proto.readFixed32(p89, n58)
				elseif v970 == proto.wireTypes.i64 then
					local v977

					v977, n58 = proto.readFixed64(p89, n58)
				else
					error("Unsupported wire type: " .. v970)
				end
			end

			return v967
		end
		function t116.jsonEncode(p90) -- line: 9634
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
		function t116.jsonDecode(t119: {[any]: any}) -- line: 9656
			-- upvalues: t116 (copy), t1 (copy)
			local v981 = t116.new()

			if t119.action_type ~= nil then
				v981.action_type = if typeof(t119.action_type) ~= "number" then t1.ActionType.fromName(t119.action_type) or t119.action_type else t1.ActionType.fromNumber(t119.action_type) or t119.action_type
			end

			if t119.actionType ~= nil then
				v981.action_type = if typeof(t119.actionType) ~= "number" then t1.ActionType.fromName(t119.actionType) or t119.actionType else t1.ActionType.fromNumber(t119.actionType) or t119.actionType
			end

			if t119.action_params ~= nil then
				v981.action_params = t1.OpenAbuseReportAction_Params.jsonDecode(t119.action_params)
			end

			if t119.actionParams ~= nil then
				v981.action_params = t1.OpenAbuseReportAction_Params.jsonDecode(t119.actionParams)
			end

			return v981
		end

		t116.descriptor = {
			name = "OpenAbuseReportAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenAbuseReportAction"
		}
		t1.OpenAbuseReportAction = t116
	end

	typeRegistry.default:register(t1.OpenAbuseReportAction)

	do
		local t120 = {}

		t120.__index = t120

		function t120.new(t121: {[any]: any}?) -- line: 9696
			-- upvalues: t120 (copy)
			return (setmetatable({
				target_id = if t121 ~= nil and t121.target_id ~= nil then t121.target_id else nil,
				abuse_vector = if t121 ~= nil and t121.abuse_vector ~= nil then t121.abuse_vector else nil,
				asset_type_name = if t121 ~= nil and t121.asset_type_name ~= nil then t121.asset_type_name else nil,
				universe_id = if t121 ~= nil and t121.universe_id ~= nil then t121.universe_id else nil
			}, t120))
		end
		function t120.encode(p91) -- line: 9707
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n59 = 0

			if p91.target_id ~= nil then
				local v986 = p91.target_id:encode()
				local v987, v988 = proto.writeTag(buf, n59, 1, proto.wireTypes.lengthDelimited)

				buf, n59 = proto.writeBuffer(v987, v988, v986, buffer.len(v986))
			end

			if p91.abuse_vector ~= nil then
				local v989 = p91.abuse_vector:encode()
				local v990, v991 = proto.writeTag(buf, n59, 2, proto.wireTypes.lengthDelimited)

				buf, n59 = proto.writeBuffer(v990, v991, v989, buffer.len(v989))
			end

			if p91.asset_type_name ~= nil then
				local v992 = p91.asset_type_name:encode()
				local v993, v994 = proto.writeTag(buf, n59, 3, proto.wireTypes.lengthDelimited)

				buf, n59 = proto.writeBuffer(v993, v994, v992, buffer.len(v992))
			end

			if p91.universe_id ~= nil then
				local v995 = p91.universe_id:encode()
				local v996, v997 = proto.writeTag(buf, n59, 4, proto.wireTypes.lengthDelimited)

				buf, n59 = proto.writeBuffer(v996, v997, v995, buffer.len(v995))
			end

			local buf32 = buffer.create(n59)

			buffer.copy(buf32, 0, buf, 0, n59)

			return buf32
		end
		function t120.decode(p92: buffer) -- line: 9740
			-- upvalues: t120 (copy), proto (copy), prop_types (copy)
			local v1000 = t120.new()
			local n60 = 0

			while n60 < buffer.len(p92) do
				local v1002, v1003

				v1002, v1003, n60 = proto.readTag(p92, n60)

				if v1003 == proto.wireTypes.varint then
					local v1004

					v1004, n60 = proto.readVarInt(p92, n60)
				elseif v1003 == proto.wireTypes.lengthDelimited then
					if v1002 == 1 then
						local v1005

						v1005, n60 = proto.readBuffer(p92, n60)
						v1000.target_id = prop_types.StringProp.decode(v1005)
					elseif v1002 == 2 then
						local v1006

						v1006, n60 = proto.readBuffer(p92, n60)
						v1000.abuse_vector = prop_types.StringProp.decode(v1006)
					elseif v1002 == 3 then
						local v1007

						v1007, n60 = proto.readBuffer(p92, n60)
						v1000.asset_type_name = prop_types.StringProp.decode(v1007)
					elseif v1002 == 4 then
						local v1008

						v1008, n60 = proto.readBuffer(p92, n60)
						v1000.universe_id = prop_types.StringProp.decode(v1008)
					else
						local v1009, v1010 = proto.readVarInt(p92, n60)

						n60 = v1010 + v1009
					end
				elseif v1003 == proto.wireTypes.i32 then
					local v1011

					v1011, n60 = proto.readFixed32(p92, n60)
				elseif v1003 == proto.wireTypes.i64 then
					local v1012

					v1012, n60 = proto.readFixed64(p92, n60)
				else
					error("Unsupported wire type: " .. v1003)
				end
			end

			return v1000
		end
		function t120.jsonEncode(p93) -- line: 9798
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
		function t120.jsonDecode(t123: {[any]: any}) -- line: 9820
			-- upvalues: t120 (copy), prop_types (copy)
			local v1016 = t120.new()

			if t123.target_id ~= nil then
				v1016.target_id = prop_types.StringProp.jsonDecode(t123.target_id)
			end

			if t123.targetId ~= nil then
				v1016.target_id = prop_types.StringProp.jsonDecode(t123.targetId)
			end

			if t123.abuse_vector ~= nil then
				v1016.abuse_vector = prop_types.StringProp.jsonDecode(t123.abuse_vector)
			end

			if t123.abuseVector ~= nil then
				v1016.abuse_vector = prop_types.StringProp.jsonDecode(t123.abuseVector)
			end

			if t123.asset_type_name ~= nil then
				v1016.asset_type_name = prop_types.StringProp.jsonDecode(t123.asset_type_name)
			end

			if t123.assetTypeName ~= nil then
				v1016.asset_type_name = prop_types.StringProp.jsonDecode(t123.assetTypeName)
			end

			if t123.universe_id ~= nil then
				v1016.universe_id = prop_types.StringProp.jsonDecode(t123.universe_id)
			end

			if t123.universeId ~= nil then
				v1016.universe_id = prop_types.StringProp.jsonDecode(t123.universeId)
			end

			return v1016
		end

		t120.descriptor = {
			name = "OpenAbuseReportAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenAbuseReportAction_Params = t120
		typeRegistry.default:register(t1.OpenAbuseReportAction_Params)

		local t124 = {}

		t124.__index = t124

		function t124.new(t125: {[any]: any}?) -- line: 9877
			-- upvalues: t1 (copy), t124 (copy)
			return (setmetatable({
				action_type = if t125 ~= nil and t125.action_type ~= nil then t125.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t125 ~= nil and t125.action_params ~= nil then t125.action_params else nil
			}, t124))
		end
		function t124.encode(p94) -- line: 9888
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n61 = 0

			if p94.action_type ~= nil and (p94.action_type ~= nil and p94.action_type ~= 0 or p94.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1021, v1022 = proto.writeTag(buf, n61, 1, proto.wireTypes.varint)

				buf, n61 = proto.writeVarInt(v1021, v1022, t1.ActionType.toNumber(p94.action_type))
			end

			if p94.action_params ~= nil then
				local v1023 = p94.action_params:encode()
				local v1024, v1025 = proto.writeTag(buf, n61, 2, proto.wireTypes.lengthDelimited)

				buf, n61 = proto.writeBuffer(v1024, v1025, v1023, buffer.len(v1023))
			end

			local buf33 = buffer.create(n61)

			buffer.copy(buf33, 0, buf, 0, n61)

			return buf33
		end
		function t124.decode(p95: buffer) -- line: 9914
			-- upvalues: t124 (copy), proto (copy), t1 (copy)
			local v1028 = t124.new()
			local n62 = 0

			while n62 < buffer.len(p95) do
				local v1030, v1031

				v1030, v1031, n62 = proto.readTag(p95, n62)

				if v1031 == proto.wireTypes.varint then
					if v1030 == 1 then
						local v1032

						v1032, n62 = proto.readVarIntI32(p95, n62)
						v1028.action_type = t1.ActionType.fromNumber(v1032) or v1032
					else
						local v1033

						v1033, n62 = proto.readVarInt(p95, n62)
					end
				elseif v1031 == proto.wireTypes.lengthDelimited then
					if v1030 == 2 then
						local v1034

						v1034, n62 = proto.readBuffer(p95, n62)
						v1028.action_params = t1.RemoveBadgeFromInventoryAction_Params.decode(v1034)
					else
						local v1035, v1036 = proto.readVarInt(p95, n62)

						n62 = v1036 + v1035
					end
				elseif v1031 == proto.wireTypes.i32 then
					local v1037

					v1037, n62 = proto.readFixed32(p95, n62)
				elseif v1031 == proto.wireTypes.i64 then
					local v1038

					v1038, n62 = proto.readFixed64(p95, n62)
				else
					error("Unsupported wire type: " .. v1031)
				end
			end

			return v1028
		end
		function t124.jsonEncode(p96) -- line: 9962
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
		function t124.jsonDecode(t127: {[any]: any}) -- line: 9984
			-- upvalues: t124 (copy), t1 (copy)
			local v1042 = t124.new()

			if t127.action_type ~= nil then
				v1042.action_type = if typeof(t127.action_type) ~= "number" then t1.ActionType.fromName(t127.action_type) or t127.action_type else t1.ActionType.fromNumber(t127.action_type) or t127.action_type
			end

			if t127.actionType ~= nil then
				v1042.action_type = if typeof(t127.actionType) ~= "number" then t1.ActionType.fromName(t127.actionType) or t127.actionType else t1.ActionType.fromNumber(t127.actionType) or t127.actionType
			end

			if t127.action_params ~= nil then
				v1042.action_params = t1.RemoveBadgeFromInventoryAction_Params.jsonDecode(t127.action_params)
			end

			if t127.actionParams ~= nil then
				v1042.action_params = t1.RemoveBadgeFromInventoryAction_Params.jsonDecode(t127.actionParams)
			end

			return v1042
		end

		t124.descriptor = {
			name = "RemoveBadgeFromInventoryAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.RemoveBadgeFromInventoryAction"
		}
		t1.RemoveBadgeFromInventoryAction = t124
	end

	typeRegistry.default:register(t1.RemoveBadgeFromInventoryAction)

	do
		local t128 = {}

		t128.__index = t128

		function t128.new(t129: {[any]: any}?) -- line: 10024
			-- upvalues: t128 (copy)
			return (setmetatable({
				asset_id = if t129 ~= nil and t129.asset_id ~= nil then t129.asset_id else nil
			}, t128))
		end
		function t128.encode(p97) -- line: 10032
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n63 = 0

			if p97.asset_id ~= nil then
				local v1047 = p97.asset_id:encode()
				local v1048, v1049 = proto.writeTag(buf, n63, 1, proto.wireTypes.lengthDelimited)

				buf, n63 = proto.writeBuffer(v1048, v1049, v1047, buffer.len(v1047))
			end

			local buf34 = buffer.create(n63)

			buffer.copy(buf34, 0, buf, 0, n63)

			return buf34
		end
		function t128.decode(p98: buffer) -- line: 10047
			-- upvalues: t128 (copy), proto (copy), prop_types (copy)
			local v1052 = t128.new()
			local n64 = 0

			while n64 < buffer.len(p98) do
				local v1054, v1055

				v1054, v1055, n64 = proto.readTag(p98, n64)

				if v1055 == proto.wireTypes.varint then
					local v1056

					v1056, n64 = proto.readVarInt(p98, n64)
				elseif v1055 == proto.wireTypes.lengthDelimited then
					if v1054 == 1 then
						local v1057

						v1057, n64 = proto.readBuffer(p98, n64)
						v1052.asset_id = prop_types.StringProp.decode(v1057)
					else
						local v1058, v1059 = proto.readVarInt(p98, n64)

						n64 = v1059 + v1058
					end
				elseif v1055 == proto.wireTypes.i32 then
					local v1060

					v1060, n64 = proto.readFixed32(p98, n64)
				elseif v1055 == proto.wireTypes.i64 then
					local v1061

					v1061, n64 = proto.readFixed64(p98, n64)
				else
					error("Unsupported wire type: " .. v1055)
				end
			end

			return v1052
		end
		function t128.jsonEncode(p99) -- line: 10090
			local t130 = {}

			if p99.asset_id ~= nil then
				t130.assetId = p99.asset_id:jsonEncode()
			end

			return t130
		end
		function t128.jsonDecode(t131: {[any]: any}) -- line: 10100
			-- upvalues: t128 (copy), prop_types (copy)
			local v1065 = t128.new()

			if t131.asset_id ~= nil then
				v1065.asset_id = prop_types.StringProp.jsonDecode(t131.asset_id)
			end

			if t131.assetId ~= nil then
				v1065.asset_id = prop_types.StringProp.jsonDecode(t131.assetId)
			end

			return v1065
		end

		t128.descriptor = {
			name = "RemoveBadgeFromInventoryAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.RemoveBadgeFromInventoryAction_Params = t128
		typeRegistry.default:register(t1.RemoveBadgeFromInventoryAction_Params)

		local t132 = {}

		t132.__index = t132

		function t132.new(t133: {[any]: any}?) -- line: 10130
			-- upvalues: t1 (copy), t132 (copy)
			return (setmetatable({
				action_type = if t133 ~= nil and t133.action_type ~= nil then t133.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t133 ~= nil and t133.action_params ~= nil then t133.action_params else nil
			}, t132))
		end
		function t132.encode(p100) -- line: 10139
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n65 = 0

			if p100.action_type ~= nil and (p100.action_type ~= nil and p100.action_type ~= 0 or p100.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1070, v1071 = proto.writeTag(buf, n65, 1, proto.wireTypes.varint)

				buf, n65 = proto.writeVarInt(v1070, v1071, t1.ActionType.toNumber(p100.action_type))
			end

			if p100.action_params ~= nil then
				local v1072 = p100.action_params:encode()
				local v1073, v1074 = proto.writeTag(buf, n65, 2, proto.wireTypes.lengthDelimited)

				buf, n65 = proto.writeBuffer(v1073, v1074, v1072, buffer.len(v1072))
			end

			local buf35 = buffer.create(n65)

			buffer.copy(buf35, 0, buf, 0, n65)

			return buf35
		end
		function t132.decode(p101: buffer) -- line: 10165
			-- upvalues: t132 (copy), proto (copy), t1 (copy)
			local v1077 = t132.new()
			local n66 = 0

			while n66 < buffer.len(p101) do
				local v1079, v1080

				v1079, v1080, n66 = proto.readTag(p101, n66)

				if v1080 == proto.wireTypes.varint then
					if v1079 == 1 then
						local v1081

						v1081, n66 = proto.readVarIntI32(p101, n66)
						v1077.action_type = t1.ActionType.fromNumber(v1081) or v1081
					else
						local v1082

						v1082, n66 = proto.readVarInt(p101, n66)
					end
				elseif v1080 == proto.wireTypes.lengthDelimited then
					if v1079 == 2 then
						local v1083

						v1083, n66 = proto.readBuffer(p101, n66)
						v1077.action_params = t1.OpenProfileAction_Params.decode(v1083)
					else
						local v1084, v1085 = proto.readVarInt(p101, n66)

						n66 = v1085 + v1084
					end
				elseif v1080 == proto.wireTypes.i32 then
					local v1086

					v1086, n66 = proto.readFixed32(p101, n66)
				elseif v1080 == proto.wireTypes.i64 then
					local v1087

					v1087, n66 = proto.readFixed64(p101, n66)
				else
					error("Unsupported wire type: " .. v1080)
				end
			end

			return v1077
		end
		function t132.jsonEncode(p102) -- line: 10213
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
		function t132.jsonDecode(t135: {[any]: any}) -- line: 10235
			-- upvalues: t132 (copy), t1 (copy)
			local v1091 = t132.new()

			if t135.action_type ~= nil then
				v1091.action_type = if typeof(t135.action_type) ~= "number" then t1.ActionType.fromName(t135.action_type) or t135.action_type else t1.ActionType.fromNumber(t135.action_type) or t135.action_type
			end

			if t135.actionType ~= nil then
				v1091.action_type = if typeof(t135.actionType) ~= "number" then t1.ActionType.fromName(t135.actionType) or t135.actionType else t1.ActionType.fromNumber(t135.actionType) or t135.actionType
			end

			if t135.action_params ~= nil then
				v1091.action_params = t1.OpenProfileAction_Params.jsonDecode(t135.action_params)
			end

			if t135.actionParams ~= nil then
				v1091.action_params = t1.OpenProfileAction_Params.jsonDecode(t135.actionParams)
			end

			return v1091
		end

		t132.descriptor = {
			name = "OpenProfileAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenProfileAction"
		}
		t1.OpenProfileAction = t132
	end

	typeRegistry.default:register(t1.OpenProfileAction)

	do
		local t136 = {}

		t136.__index = t136

		function t136.new(t137: {[any]: any}?) -- line: 10275
			-- upvalues: t136 (copy)
			return (setmetatable({
				profile_id = if t137 ~= nil and t137.profile_id ~= nil then t137.profile_id else nil,
				profile_type = if t137 ~= nil and t137.profile_type ~= nil then t137.profile_type else nil,
				source = if t137 ~= nil and t137.source ~= nil then t137.source else nil
			}, t136))
		end
		function t136.encode(p103) -- line: 10283
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n67 = 0

			if p103.profile_id ~= nil then
				local v1096 = p103.profile_id:encode()
				local v1097, v1098 = proto.writeTag(buf, n67, 1, proto.wireTypes.lengthDelimited)

				buf, n67 = proto.writeBuffer(v1097, v1098, v1096, buffer.len(v1096))
			end

			if p103.profile_type ~= nil then
				local v1099 = p103.profile_type:encode()
				local v1100, v1101 = proto.writeTag(buf, n67, 2, proto.wireTypes.lengthDelimited)

				buf, n67 = proto.writeBuffer(v1100, v1101, v1099, buffer.len(v1099))
			end

			if p103.source ~= nil then
				local v1102 = p103.source:encode()
				local v1103, v1104 = proto.writeTag(buf, n67, 3, proto.wireTypes.lengthDelimited)

				buf, n67 = proto.writeBuffer(v1103, v1104, v1102, buffer.len(v1102))
			end

			local buf36 = buffer.create(n67)

			buffer.copy(buf36, 0, buf, 0, n67)

			return buf36
		end
		function t136.decode(p104: buffer) -- line: 10310
			-- upvalues: t136 (copy), proto (copy), prop_types (copy)
			local v1107 = t136.new()
			local n68 = 0

			while n68 < buffer.len(p104) do
				local v1109, v1110

				v1109, v1110, n68 = proto.readTag(p104, n68)

				if v1110 == proto.wireTypes.varint then
					local v1111

					v1111, n68 = proto.readVarInt(p104, n68)
				elseif v1110 == proto.wireTypes.lengthDelimited then
					if v1109 == 1 then
						local v1112

						v1112, n68 = proto.readBuffer(p104, n68)
						v1107.profile_id = prop_types.StringProp.decode(v1112)
					elseif v1109 == 2 then
						local v1113

						v1113, n68 = proto.readBuffer(p104, n68)
						v1107.profile_type = prop_types.StringProp.decode(v1113)
					elseif v1109 == 3 then
						local v1114

						v1114, n68 = proto.readBuffer(p104, n68)
						v1107.source = prop_types.StringProp.decode(v1114)
					else
						local v1115, v1116 = proto.readVarInt(p104, n68)

						n68 = v1116 + v1115
					end
				elseif v1110 == proto.wireTypes.i32 then
					local v1117

					v1117, n68 = proto.readFixed32(p104, n68)
				elseif v1110 == proto.wireTypes.i64 then
					local v1118

					v1118, n68 = proto.readFixed64(p104, n68)
				else
					error("Unsupported wire type: " .. v1110)
				end
			end

			return v1107
		end
		function t136.jsonEncode(p105) -- line: 10363
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
		function t136.jsonDecode(t139: {[any]: any}) -- line: 10381
			-- upvalues: t136 (copy), prop_types (copy)
			local v1122 = t136.new()

			if t139.profile_id ~= nil then
				v1122.profile_id = prop_types.StringProp.jsonDecode(t139.profile_id)
			end

			if t139.profileId ~= nil then
				v1122.profile_id = prop_types.StringProp.jsonDecode(t139.profileId)
			end

			if t139.profile_type ~= nil then
				v1122.profile_type = prop_types.StringProp.jsonDecode(t139.profile_type)
			end

			if t139.profileType ~= nil then
				v1122.profile_type = prop_types.StringProp.jsonDecode(t139.profileType)
			end

			if t139.source ~= nil then
				v1122.source = prop_types.StringProp.jsonDecode(t139.source)
			end

			return v1122
		end

		t136.descriptor = {
			name = "OpenProfileAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenProfileAction_Params = t136
		typeRegistry.default:register(t1.OpenProfileAction_Params)

		local t140 = {}

		t140.__index = t140

		function t140.new(t141: {[any]: any}?) -- line: 10423
			-- upvalues: t1 (copy), t140 (copy)
			return (setmetatable({
				action_type = if t141 ~= nil and t141.action_type ~= nil then t141.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t141 ~= nil and t141.action_params ~= nil then t141.action_params else nil
			}, t140))
		end
		function t140.encode(p106) -- line: 10434
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n69 = 0

			if p106.action_type ~= nil and (p106.action_type ~= nil and p106.action_type ~= 0 or p106.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1127, v1128 = proto.writeTag(buf, n69, 1, proto.wireTypes.varint)

				buf, n69 = proto.writeVarInt(v1127, v1128, t1.ActionType.toNumber(p106.action_type))
			end

			if p106.action_params ~= nil then
				local v1129 = p106.action_params:encode()
				local v1130, v1131 = proto.writeTag(buf, n69, 2, proto.wireTypes.lengthDelimited)

				buf, n69 = proto.writeBuffer(v1130, v1131, v1129, buffer.len(v1129))
			end

			local buf37 = buffer.create(n69)

			buffer.copy(buf37, 0, buf, 0, n69)

			return buf37
		end
		function t140.decode(p107: buffer) -- line: 10460
			-- upvalues: t140 (copy), proto (copy), t1 (copy)
			local v1134 = t140.new()
			local n70 = 0

			while n70 < buffer.len(p107) do
				local v1136, v1137

				v1136, v1137, n70 = proto.readTag(p107, n70)

				if v1137 == proto.wireTypes.varint then
					if v1136 == 1 then
						local v1138

						v1138, n70 = proto.readVarIntI32(p107, n70)
						v1134.action_type = t1.ActionType.fromNumber(v1138) or v1138
					else
						local v1139

						v1139, n70 = proto.readVarInt(p107, n70)
					end
				elseif v1137 == proto.wireTypes.lengthDelimited then
					if v1136 == 2 then
						local v1140

						v1140, n70 = proto.readBuffer(p107, n70)
						v1134.action_params = t1.OpenFacialAgeEstimationAction_Params.decode(v1140)
					else
						local v1141, v1142 = proto.readVarInt(p107, n70)

						n70 = v1142 + v1141
					end
				elseif v1137 == proto.wireTypes.i32 then
					local v1143

					v1143, n70 = proto.readFixed32(p107, n70)
				elseif v1137 == proto.wireTypes.i64 then
					local v1144

					v1144, n70 = proto.readFixed64(p107, n70)
				else
					error("Unsupported wire type: " .. v1137)
				end
			end

			return v1134
		end
		function t140.jsonEncode(p108) -- line: 10508
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
		function t140.jsonDecode(t143: {[any]: any}) -- line: 10530
			-- upvalues: t140 (copy), t1 (copy)
			local v1148 = t140.new()

			if t143.action_type ~= nil then
				v1148.action_type = if typeof(t143.action_type) ~= "number" then t1.ActionType.fromName(t143.action_type) or t143.action_type else t1.ActionType.fromNumber(t143.action_type) or t143.action_type
			end

			if t143.actionType ~= nil then
				v1148.action_type = if typeof(t143.actionType) ~= "number" then t1.ActionType.fromName(t143.actionType) or t143.actionType else t1.ActionType.fromNumber(t143.actionType) or t143.actionType
			end

			if t143.action_params ~= nil then
				v1148.action_params = t1.OpenFacialAgeEstimationAction_Params.jsonDecode(t143.action_params)
			end

			if t143.actionParams ~= nil then
				v1148.action_params = t1.OpenFacialAgeEstimationAction_Params.jsonDecode(t143.actionParams)
			end

			return v1148
		end

		t140.descriptor = {
			name = "OpenFacialAgeEstimationAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenFacialAgeEstimationAction"
		}
		t1.OpenFacialAgeEstimationAction = t140
	end

	typeRegistry.default:register(t1.OpenFacialAgeEstimationAction)

	do
		local t144 = {}

		t144.__index = t144

		function t144.new(t145: {[any]: any}?) -- line: 10570
			-- upvalues: t144 (copy)
			return (setmetatable({
				user_id = if t145 ~= nil and t145.user_id ~= nil then t145.user_id else nil,
				source = if t145 ~= nil and t145.source ~= nil then t145.source else nil,
				context = if t145 ~= nil and t145.context ~= nil then t145.context else nil,
				is_in_experience = if t145 ~= nil and t145.is_in_experience ~= nil then t145.is_in_experience else nil,
				on_success = if t145 ~= nil and t145.on_success ~= nil then t145.on_success else nil,
				on_failure = if t145 ~= nil and t145.on_failure ~= nil then t145.on_failure else nil,
				should_include_vpc = if t145 ~= nil and t145.should_include_vpc ~= nil then t145.should_include_vpc else nil
			}, t144))
		end
		function t144.encode(p109) -- line: 10584
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n71 = 0

			if p109.user_id ~= nil then
				local v1153 = p109.user_id:encode()
				local v1154, v1155 = proto.writeTag(buf, n71, 1, proto.wireTypes.lengthDelimited)

				buf, n71 = proto.writeBuffer(v1154, v1155, v1153, buffer.len(v1153))
			end

			if p109.source ~= nil then
				local v1156 = p109.source:encode()
				local v1157, v1158 = proto.writeTag(buf, n71, 2, proto.wireTypes.lengthDelimited)

				buf, n71 = proto.writeBuffer(v1157, v1158, v1156, buffer.len(v1156))
			end

			if p109.context ~= nil then
				local v1159 = p109.context:encode()
				local v1160, v1161 = proto.writeTag(buf, n71, 3, proto.wireTypes.lengthDelimited)

				buf, n71 = proto.writeBuffer(v1160, v1161, v1159, buffer.len(v1159))
			end

			if p109.is_in_experience ~= nil then
				local v1162 = p109.is_in_experience:encode()
				local v1163, v1164 = proto.writeTag(buf, n71, 4, proto.wireTypes.lengthDelimited)

				buf, n71 = proto.writeBuffer(v1163, v1164, v1162, buffer.len(v1162))
			end

			if p109.on_success ~= nil then
				local v1165 = p109.on_success:encode()
				local v1166, v1167 = proto.writeTag(buf, n71, 5, proto.wireTypes.lengthDelimited)

				buf, n71 = proto.writeBuffer(v1166, v1167, v1165, buffer.len(v1165))
			end

			if p109.on_failure ~= nil then
				local v1168 = p109.on_failure:encode()
				local v1169, v1170 = proto.writeTag(buf, n71, 6, proto.wireTypes.lengthDelimited)

				buf, n71 = proto.writeBuffer(v1169, v1170, v1168, buffer.len(v1168))
			end

			if p109.should_include_vpc ~= nil then
				local v1171 = p109.should_include_vpc:encode()
				local v1172, v1173 = proto.writeTag(buf, n71, 7, proto.wireTypes.lengthDelimited)

				buf, n71 = proto.writeBuffer(v1172, v1173, v1171, buffer.len(v1171))
			end

			local buf38 = buffer.create(n71)

			buffer.copy(buf38, 0, buf, 0, n71)

			return buf38
		end
		function t144.decode(p110: buffer) -- line: 10635
			-- upvalues: t144 (copy), proto (copy), prop_types (copy), t1 (copy)
			local v1176 = t144.new()
			local n72 = 0

			while n72 < buffer.len(p110) do
				local v1178, v1179

				v1178, v1179, n72 = proto.readTag(p110, n72)

				if v1179 == proto.wireTypes.varint then
					local v1180

					v1180, n72 = proto.readVarInt(p110, n72)
				elseif v1179 == proto.wireTypes.lengthDelimited then
					if v1178 == 1 then
						local v1181

						v1181, n72 = proto.readBuffer(p110, n72)
						v1176.user_id = prop_types.StringProp.decode(v1181)
					elseif v1178 == 2 then
						local v1182

						v1182, n72 = proto.readBuffer(p110, n72)
						v1176.source = prop_types.StringProp.decode(v1182)
					elseif v1178 == 3 then
						local v1183

						v1183, n72 = proto.readBuffer(p110, n72)
						v1176.context = prop_types.StringProp.decode(v1183)
					elseif v1178 == 4 then
						local v1184

						v1184, n72 = proto.readBuffer(p110, n72)
						v1176.is_in_experience = prop_types.BoolProp.decode(v1184)
					elseif v1178 == 5 then
						local v1185

						v1185, n72 = proto.readBuffer(p110, n72)
						v1176.on_success = t1.ActionProp.decode(v1185)
					elseif v1178 == 6 then
						local v1186

						v1186, n72 = proto.readBuffer(p110, n72)
						v1176.on_failure = t1.ActionProp.decode(v1186)
					elseif v1178 == 7 then
						local v1187

						v1187, n72 = proto.readBuffer(p110, n72)
						v1176.should_include_vpc = prop_types.BoolProp.decode(v1187)
					else
						local v1188, v1189 = proto.readVarInt(p110, n72)

						n72 = v1189 + v1188
					end
				elseif v1179 == proto.wireTypes.i32 then
					local v1190

					v1190, n72 = proto.readFixed32(p110, n72)
				elseif v1179 == proto.wireTypes.i64 then
					local v1191

					v1191, n72 = proto.readFixed64(p110, n72)
				else
					error("Unsupported wire type: " .. v1179)
				end
			end

			return v1176
		end
		function t144.jsonEncode(p111) -- line: 10708
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

			if p111.should_include_vpc ~= nil then
				t146.shouldIncludeVpc = p111.should_include_vpc:jsonEncode()
			end

			return t146
		end
		function t144.jsonDecode(t147: {[any]: any}) -- line: 10742
			-- upvalues: t144 (copy), prop_types (copy), t1 (copy)
			local v1195 = t144.new()

			if t147.user_id ~= nil then
				v1195.user_id = prop_types.StringProp.jsonDecode(t147.user_id)
			end

			if t147.userId ~= nil then
				v1195.user_id = prop_types.StringProp.jsonDecode(t147.userId)
			end

			if t147.source ~= nil then
				v1195.source = prop_types.StringProp.jsonDecode(t147.source)
			end

			if t147.context ~= nil then
				v1195.context = prop_types.StringProp.jsonDecode(t147.context)
			end

			if t147.is_in_experience ~= nil then
				v1195.is_in_experience = prop_types.BoolProp.jsonDecode(t147.is_in_experience)
			end

			if t147.isInExperience ~= nil then
				v1195.is_in_experience = prop_types.BoolProp.jsonDecode(t147.isInExperience)
			end

			if t147.on_success ~= nil then
				v1195.on_success = t1.ActionProp.jsonDecode(t147.on_success)
			end

			if t147.onSuccess ~= nil then
				v1195.on_success = t1.ActionProp.jsonDecode(t147.onSuccess)
			end

			if t147.on_failure ~= nil then
				v1195.on_failure = t1.ActionProp.jsonDecode(t147.on_failure)
			end

			if t147.onFailure ~= nil then
				v1195.on_failure = t1.ActionProp.jsonDecode(t147.onFailure)
			end

			if t147.should_include_vpc ~= nil then
				v1195.should_include_vpc = prop_types.BoolProp.jsonDecode(t147.should_include_vpc)
			end

			if t147.shouldIncludeVpc ~= nil then
				v1195.should_include_vpc = prop_types.BoolProp.jsonDecode(t147.shouldIncludeVpc)
			end

			return v1195
		end

		t144.descriptor = {
			name = "OpenFacialAgeEstimationAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenFacialAgeEstimationAction_Params = t144
		typeRegistry.default:register(t1.OpenFacialAgeEstimationAction_Params)

		local t148 = {}

		t148.__index = t148

		function t148.new(t149: {[any]: any}?) -- line: 10816
			-- upvalues: t1 (copy), t148 (copy)
			return (setmetatable({
				action_type = if t149 ~= nil and t149.action_type ~= nil then t149.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t149 ~= nil and t149.action_params ~= nil then t149.action_params else nil
			}, t148))
		end
		function t148.encode(p112) -- line: 10825
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n73 = 0

			if p112.action_type ~= nil and (p112.action_type ~= nil and p112.action_type ~= 0 or p112.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1200, v1201 = proto.writeTag(buf, n73, 1, proto.wireTypes.varint)

				buf, n73 = proto.writeVarInt(v1200, v1201, t1.ActionType.toNumber(p112.action_type))
			end

			if p112.action_params ~= nil then
				local v1202 = p112.action_params:encode()
				local v1203, v1204 = proto.writeTag(buf, n73, 2, proto.wireTypes.lengthDelimited)

				buf, n73 = proto.writeBuffer(v1203, v1204, v1202, buffer.len(v1202))
			end

			local buf39 = buffer.create(n73)

			buffer.copy(buf39, 0, buf, 0, n73)

			return buf39
		end
		function t148.decode(p113: buffer) -- line: 10851
			-- upvalues: t148 (copy), proto (copy), t1 (copy)
			local v1207 = t148.new()
			local n74 = 0

			while n74 < buffer.len(p113) do
				local v1209, v1210

				v1209, v1210, n74 = proto.readTag(p113, n74)

				if v1210 == proto.wireTypes.varint then
					if v1209 == 1 then
						local v1211

						v1211, n74 = proto.readVarIntI32(p113, n74)
						v1207.action_type = t1.ActionType.fromNumber(v1211) or v1211
					else
						local v1212

						v1212, n74 = proto.readVarInt(p113, n74)
					end
				elseif v1210 == proto.wireTypes.lengthDelimited then
					if v1209 == 2 then
						local v1213

						v1213, n74 = proto.readBuffer(p113, n74)
						v1207.action_params = t1.ShowToastAction_Params.decode(v1213)
					else
						local v1214, v1215 = proto.readVarInt(p113, n74)

						n74 = v1215 + v1214
					end
				elseif v1210 == proto.wireTypes.i32 then
					local v1216

					v1216, n74 = proto.readFixed32(p113, n74)
				elseif v1210 == proto.wireTypes.i64 then
					local v1217

					v1217, n74 = proto.readFixed64(p113, n74)
				else
					error("Unsupported wire type: " .. v1210)
				end
			end

			return v1207
		end
		function t148.jsonEncode(p114) -- line: 10899
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
		function t148.jsonDecode(t151: {[any]: any}) -- line: 10921
			-- upvalues: t148 (copy), t1 (copy)
			local v1221 = t148.new()

			if t151.action_type ~= nil then
				v1221.action_type = if typeof(t151.action_type) ~= "number" then t1.ActionType.fromName(t151.action_type) or t151.action_type else t1.ActionType.fromNumber(t151.action_type) or t151.action_type
			end

			if t151.actionType ~= nil then
				v1221.action_type = if typeof(t151.actionType) ~= "number" then t1.ActionType.fromName(t151.actionType) or t151.actionType else t1.ActionType.fromNumber(t151.actionType) or t151.actionType
			end

			if t151.action_params ~= nil then
				v1221.action_params = t1.ShowToastAction_Params.jsonDecode(t151.action_params)
			end

			if t151.actionParams ~= nil then
				v1221.action_params = t1.ShowToastAction_Params.jsonDecode(t151.actionParams)
			end

			return v1221
		end

		t148.descriptor = {
			name = "ShowToastAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.ShowToastAction"
		}
		t1.ShowToastAction = t148
	end

	typeRegistry.default:register(t1.ShowToastAction)

	do
		local t152 = {}

		t152.__index = t152

		function t152.new(t153: {[any]: any}?) -- line: 10961
			-- upvalues: t152 (copy)
			return (setmetatable({
				toast_message = if t153 ~= nil and t153.toast_message ~= nil then t153.toast_message else nil,
				toast_type = if t153 ~= nil and t153.toast_type ~= nil then t153.toast_type else nil,
				dismiss_prompt = if t153 ~= nil and t153.dismiss_prompt ~= nil then t153.dismiss_prompt else nil,
				prompt_type = if t153 ~= nil and t153.prompt_type ~= nil then t153.prompt_type else nil,
				prompt_id = if t153 ~= nil and t153.prompt_id ~= nil then t153.prompt_id else nil
			}, t152))
		end
		function t152.encode(p115) -- line: 10971
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n75 = 0

			if p115.toast_message ~= nil then
				local v1226 = p115.toast_message:encode()
				local v1227, v1228 = proto.writeTag(buf, n75, 1, proto.wireTypes.lengthDelimited)

				buf, n75 = proto.writeBuffer(v1227, v1228, v1226, buffer.len(v1226))
			end

			if p115.toast_type ~= nil then
				local v1229 = p115.toast_type:encode()
				local v1230, v1231 = proto.writeTag(buf, n75, 2, proto.wireTypes.lengthDelimited)

				buf, n75 = proto.writeBuffer(v1230, v1231, v1229, buffer.len(v1229))
			end

			if p115.dismiss_prompt ~= nil then
				local v1232 = p115.dismiss_prompt:encode()
				local v1233, v1234 = proto.writeTag(buf, n75, 3, proto.wireTypes.lengthDelimited)

				buf, n75 = proto.writeBuffer(v1233, v1234, v1232, buffer.len(v1232))
			end

			if p115.prompt_type ~= nil then
				local v1235 = p115.prompt_type:encode()
				local v1236, v1237 = proto.writeTag(buf, n75, 4, proto.wireTypes.lengthDelimited)

				buf, n75 = proto.writeBuffer(v1236, v1237, v1235, buffer.len(v1235))
			end

			if p115.prompt_id ~= nil then
				local v1238 = p115.prompt_id:encode()
				local v1239, v1240 = proto.writeTag(buf, n75, 5, proto.wireTypes.lengthDelimited)

				buf, n75 = proto.writeBuffer(v1239, v1240, v1238, buffer.len(v1238))
			end

			local buf40 = buffer.create(n75)

			buffer.copy(buf40, 0, buf, 0, n75)

			return buf40
		end
		function t152.decode(p116: buffer) -- line: 11010
			-- upvalues: t152 (copy), proto (copy), prop_types (copy)
			local v1243 = t152.new()
			local n76 = 0

			while n76 < buffer.len(p116) do
				local v1245, v1246

				v1245, v1246, n76 = proto.readTag(p116, n76)

				if v1246 == proto.wireTypes.varint then
					local v1247

					v1247, n76 = proto.readVarInt(p116, n76)
				elseif v1246 == proto.wireTypes.lengthDelimited then
					if v1245 == 1 then
						local v1248

						v1248, n76 = proto.readBuffer(p116, n76)
						v1243.toast_message = prop_types.StringProp.decode(v1248)
					elseif v1245 == 2 then
						local v1249

						v1249, n76 = proto.readBuffer(p116, n76)
						v1243.toast_type = prop_types.StringProp.decode(v1249)
					elseif v1245 == 3 then
						local v1250

						v1250, n76 = proto.readBuffer(p116, n76)
						v1243.dismiss_prompt = prop_types.BoolProp.decode(v1250)
					elseif v1245 == 4 then
						local v1251

						v1251, n76 = proto.readBuffer(p116, n76)
						v1243.prompt_type = prop_types.StringProp.decode(v1251)
					elseif v1245 == 5 then
						local v1252

						v1252, n76 = proto.readBuffer(p116, n76)
						v1243.prompt_id = prop_types.StringProp.decode(v1252)
					else
						local v1253, v1254 = proto.readVarInt(p116, n76)

						n76 = v1254 + v1253
					end
				elseif v1246 == proto.wireTypes.i32 then
					local v1255

					v1255, n76 = proto.readFixed32(p116, n76)
				elseif v1246 == proto.wireTypes.i64 then
					local v1256

					v1256, n76 = proto.readFixed64(p116, n76)
				else
					error("Unsupported wire type: " .. v1246)
				end
			end

			return v1243
		end
		function t152.jsonEncode(p117) -- line: 11073
			local t154 = {}

			if p117.toast_message ~= nil then
				t154.toastMessage = p117.toast_message:jsonEncode()
			end

			if p117.toast_type ~= nil then
				t154.toastType = p117.toast_type:jsonEncode()
			end

			if p117.dismiss_prompt ~= nil then
				t154.dismissPrompt = p117.dismiss_prompt:jsonEncode()
			end

			if p117.prompt_type ~= nil then
				t154.promptType = p117.prompt_type:jsonEncode()
			end

			if p117.prompt_id ~= nil then
				t154.promptId = p117.prompt_id:jsonEncode()
			end

			return t154
		end
		function t152.jsonDecode(t155: {[any]: any}) -- line: 11099
			-- upvalues: t152 (copy), prop_types (copy)
			local v1260 = t152.new()

			if t155.toast_message ~= nil then
				v1260.toast_message = prop_types.StringProp.jsonDecode(t155.toast_message)
			end

			if t155.toastMessage ~= nil then
				v1260.toast_message = prop_types.StringProp.jsonDecode(t155.toastMessage)
			end

			if t155.toast_type ~= nil then
				v1260.toast_type = prop_types.StringProp.jsonDecode(t155.toast_type)
			end

			if t155.toastType ~= nil then
				v1260.toast_type = prop_types.StringProp.jsonDecode(t155.toastType)
			end

			if t155.dismiss_prompt ~= nil then
				v1260.dismiss_prompt = prop_types.BoolProp.jsonDecode(t155.dismiss_prompt)
			end

			if t155.dismissPrompt ~= nil then
				v1260.dismiss_prompt = prop_types.BoolProp.jsonDecode(t155.dismissPrompt)
			end

			if t155.prompt_type ~= nil then
				v1260.prompt_type = prop_types.StringProp.jsonDecode(t155.prompt_type)
			end

			if t155.promptType ~= nil then
				v1260.prompt_type = prop_types.StringProp.jsonDecode(t155.promptType)
			end

			if t155.prompt_id ~= nil then
				v1260.prompt_id = prop_types.StringProp.jsonDecode(t155.prompt_id)
			end

			if t155.promptId ~= nil then
				v1260.prompt_id = prop_types.StringProp.jsonDecode(t155.promptId)
			end

			return v1260
		end

		t152.descriptor = {
			name = "ShowToastAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.ShowToastAction_Params = t152
		typeRegistry.default:register(t1.ShowToastAction_Params)

		local t156 = {}

		t156.__index = t156

		function t156.new(t157: {[any]: any}?) -- line: 11164
			-- upvalues: t1 (copy), t156 (copy)
			return (setmetatable({
				action_type = if t157 ~= nil and t157.action_type ~= nil then t157.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t157 ~= nil and t157.action_params ~= nil then t157.action_params else nil
			}, t156))
		end
		function t156.encode(p118) -- line: 11175
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n77 = 0

			if p118.action_type ~= nil and (p118.action_type ~= nil and p118.action_type ~= 0 or p118.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1265, v1266 = proto.writeTag(buf, n77, 1, proto.wireTypes.varint)

				buf, n77 = proto.writeVarInt(v1265, v1266, t1.ActionType.toNumber(p118.action_type))
			end

			if p118.action_params ~= nil then
				local v1267 = p118.action_params:encode()
				local v1268, v1269 = proto.writeTag(buf, n77, 2, proto.wireTypes.lengthDelimited)

				buf, n77 = proto.writeBuffer(v1268, v1269, v1267, buffer.len(v1267))
			end

			local buf41 = buffer.create(n77)

			buffer.copy(buf41, 0, buf, 0, n77)

			return buf41
		end
		function t156.decode(p119: buffer) -- line: 11201
			-- upvalues: t156 (copy), proto (copy), t1 (copy)
			local v1272 = t156.new()
			local n78 = 0

			while n78 < buffer.len(p119) do
				local v1274, v1275

				v1274, v1275, n78 = proto.readTag(p119, n78)

				if v1275 == proto.wireTypes.varint then
					if v1274 == 1 then
						local v1276

						v1276, n78 = proto.readVarIntI32(p119, n78)
						v1272.action_type = t1.ActionType.fromNumber(v1276) or v1276
					else
						local v1277

						v1277, n78 = proto.readVarInt(p119, n78)
					end
				elseif v1275 == proto.wireTypes.lengthDelimited then
					if v1274 == 2 then
						local v1278

						v1278, n78 = proto.readBuffer(p119, n78)
						v1272.action_params = t1.OpenPhoneUpsellModalAction_Params.decode(v1278)
					else
						local v1279, v1280 = proto.readVarInt(p119, n78)

						n78 = v1280 + v1279
					end
				elseif v1275 == proto.wireTypes.i32 then
					local v1281

					v1281, n78 = proto.readFixed32(p119, n78)
				elseif v1275 == proto.wireTypes.i64 then
					local v1282

					v1282, n78 = proto.readFixed64(p119, n78)
				else
					error("Unsupported wire type: " .. v1275)
				end
			end

			return v1272
		end
		function t156.jsonEncode(p120) -- line: 11249
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
		function t156.jsonDecode(t159: {[any]: any}) -- line: 11271
			-- upvalues: t156 (copy), t1 (copy)
			local v1286 = t156.new()

			if t159.action_type ~= nil then
				v1286.action_type = if typeof(t159.action_type) ~= "number" then t1.ActionType.fromName(t159.action_type) or t159.action_type else t1.ActionType.fromNumber(t159.action_type) or t159.action_type
			end

			if t159.actionType ~= nil then
				v1286.action_type = if typeof(t159.actionType) ~= "number" then t1.ActionType.fromName(t159.actionType) or t159.actionType else t1.ActionType.fromNumber(t159.actionType) or t159.actionType
			end

			if t159.action_params ~= nil then
				v1286.action_params = t1.OpenPhoneUpsellModalAction_Params.jsonDecode(t159.action_params)
			end

			if t159.actionParams ~= nil then
				v1286.action_params = t1.OpenPhoneUpsellModalAction_Params.jsonDecode(t159.actionParams)
			end

			return v1286
		end

		t156.descriptor = {
			name = "OpenPhoneUpsellModalAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenPhoneUpsellModalAction"
		}
		t1.OpenPhoneUpsellModalAction = t156
	end

	typeRegistry.default:register(t1.OpenPhoneUpsellModalAction)

	do
		local t160 = {}

		t160.__index = t160

		function t160.new(t161: {[any]: any}?) -- line: 11311
			-- upvalues: t160 (copy)
			return (setmetatable({
				voice_opt_in = if t161 ~= nil and t161.voice_opt_in ~= nil then t161.voice_opt_in else nil,
				event_context = if t161 ~= nil and t161.event_context ~= nil then t161.event_context else nil,
				origin = if t161 ~= nil and t161.origin ~= nil then t161.origin else nil,
				should_autofill_android_phone_number_at_launch = if t161 ~= nil and t161.should_autofill_android_phone_number_at_launch ~= nil then t161.should_autofill_android_phone_number_at_launch else nil,
				add_phone_description_key = if t161 ~= nil and t161.add_phone_description_key ~= nil then t161.add_phone_description_key else nil,
				on_success = if t161 ~= nil and t161.on_success ~= nil then t161.on_success else nil,
				on_failure = if t161 ~= nil and t161.on_failure ~= nil then t161.on_failure else nil,
				on_cancelled = if t161 ~= nil and t161.on_cancelled ~= nil then t161.on_cancelled else nil
			}, t160))
		end
		function t160.encode(p121) -- line: 11331
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n79 = 0

			if p121.voice_opt_in ~= nil then
				local v1291 = p121.voice_opt_in:encode()
				local v1292, v1293 = proto.writeTag(buf, n79, 1, proto.wireTypes.lengthDelimited)

				buf, n79 = proto.writeBuffer(v1292, v1293, v1291, buffer.len(v1291))
			end

			if p121.event_context ~= nil then
				local v1294 = p121.event_context:encode()
				local v1295, v1296 = proto.writeTag(buf, n79, 2, proto.wireTypes.lengthDelimited)

				buf, n79 = proto.writeBuffer(v1295, v1296, v1294, buffer.len(v1294))
			end

			if p121.origin ~= nil then
				local v1297 = p121.origin:encode()
				local v1298, v1299 = proto.writeTag(buf, n79, 3, proto.wireTypes.lengthDelimited)

				buf, n79 = proto.writeBuffer(v1298, v1299, v1297, buffer.len(v1297))
			end

			if p121.should_autofill_android_phone_number_at_launch ~= nil then
				local v1300 = p121.should_autofill_android_phone_number_at_launch:encode()
				local v1301, v1302 = proto.writeTag(buf, n79, 4, proto.wireTypes.lengthDelimited)

				buf, n79 = proto.writeBuffer(v1301, v1302, v1300, buffer.len(v1300))
			end

			if p121.add_phone_description_key ~= nil then
				local v1303 = p121.add_phone_description_key:encode()
				local v1304, v1305 = proto.writeTag(buf, n79, 5, proto.wireTypes.lengthDelimited)

				buf, n79 = proto.writeBuffer(v1304, v1305, v1303, buffer.len(v1303))
			end

			if p121.on_success ~= nil then
				local v1306 = p121.on_success:encode()
				local v1307, v1308 = proto.writeTag(buf, n79, 6, proto.wireTypes.lengthDelimited)

				buf, n79 = proto.writeBuffer(v1307, v1308, v1306, buffer.len(v1306))
			end

			if p121.on_failure ~= nil then
				local v1309 = p121.on_failure:encode()
				local v1310, v1311 = proto.writeTag(buf, n79, 7, proto.wireTypes.lengthDelimited)

				buf, n79 = proto.writeBuffer(v1310, v1311, v1309, buffer.len(v1309))
			end

			if p121.on_cancelled ~= nil then
				local v1312 = p121.on_cancelled:encode()
				local v1313, v1314 = proto.writeTag(buf, n79, 8, proto.wireTypes.lengthDelimited)

				buf, n79 = proto.writeBuffer(v1313, v1314, v1312, buffer.len(v1312))
			end

			local buf42 = buffer.create(n79)

			buffer.copy(buf42, 0, buf, 0, n79)

			return buf42
		end
		function t160.decode(p122: buffer) -- line: 11388
			-- upvalues: t160 (copy), proto (copy), prop_types (copy), t1 (copy)
			local v1317 = t160.new()
			local n80 = 0

			while n80 < buffer.len(p122) do
				local v1319, v1320

				v1319, v1320, n80 = proto.readTag(p122, n80)

				if v1320 == proto.wireTypes.varint then
					local v1321

					v1321, n80 = proto.readVarInt(p122, n80)
				elseif v1320 == proto.wireTypes.lengthDelimited then
					if v1319 == 1 then
						local v1322

						v1322, n80 = proto.readBuffer(p122, n80)
						v1317.voice_opt_in = prop_types.BoolProp.decode(v1322)
					elseif v1319 == 2 then
						local v1323

						v1323, n80 = proto.readBuffer(p122, n80)
						v1317.event_context = prop_types.StringProp.decode(v1323)
					elseif v1319 == 3 then
						local v1324

						v1324, n80 = proto.readBuffer(p122, n80)
						v1317.origin = prop_types.StringProp.decode(v1324)
					elseif v1319 == 4 then
						local v1325

						v1325, n80 = proto.readBuffer(p122, n80)
						v1317.should_autofill_android_phone_number_at_launch = prop_types.BoolProp.decode(v1325)
					elseif v1319 == 5 then
						local v1326

						v1326, n80 = proto.readBuffer(p122, n80)
						v1317.add_phone_description_key = prop_types.StringProp.decode(v1326)
					elseif v1319 == 6 then
						local v1327

						v1327, n80 = proto.readBuffer(p122, n80)
						v1317.on_success = t1.ActionProp.decode(v1327)
					elseif v1319 == 7 then
						local v1328

						v1328, n80 = proto.readBuffer(p122, n80)
						v1317.on_failure = t1.ActionProp.decode(v1328)
					elseif v1319 == 8 then
						local v1329

						v1329, n80 = proto.readBuffer(p122, n80)
						v1317.on_cancelled = t1.ActionProp.decode(v1329)
					else
						local v1330, v1331 = proto.readVarInt(p122, n80)

						n80 = v1331 + v1330
					end
				elseif v1320 == proto.wireTypes.i32 then
					local v1332

					v1332, n80 = proto.readFixed32(p122, n80)
				elseif v1320 == proto.wireTypes.i64 then
					local v1333

					v1333, n80 = proto.readFixed64(p122, n80)
				else
					error("Unsupported wire type: " .. v1320)
				end
			end

			return v1317
		end
		function t160.jsonEncode(p123) -- line: 11468
			local t162 = {}

			if p123.voice_opt_in ~= nil then
				t162.voiceOptIn = p123.voice_opt_in:jsonEncode()
			end

			if p123.event_context ~= nil then
				t162.eventContext = p123.event_context:jsonEncode()
			end

			if p123.origin ~= nil then
				t162.origin = p123.origin:jsonEncode()
			end

			if p123.should_autofill_android_phone_number_at_launch ~= nil then
				t162.shouldAutofillAndroidPhoneNumberAtLaunch = p123.should_autofill_android_phone_number_at_launch:jsonEncode()
			end

			if p123.add_phone_description_key ~= nil then
				t162.addPhoneDescriptionKey = p123.add_phone_description_key:jsonEncode()
			end

			if p123.on_success ~= nil then
				t162.onSuccess = p123.on_success:jsonEncode()
			end

			if p123.on_failure ~= nil then
				t162.onFailure = p123.on_failure:jsonEncode()
			end

			if p123.on_cancelled ~= nil then
				t162.onCancelled = p123.on_cancelled:jsonEncode()
			end

			return t162
		end
		function t160.jsonDecode(t163: {[any]: any}) -- line: 11507
			-- upvalues: t160 (copy), prop_types (copy), t1 (copy)
			local v1337 = t160.new()

			if t163.voice_opt_in ~= nil then
				v1337.voice_opt_in = prop_types.BoolProp.jsonDecode(t163.voice_opt_in)
			end

			if t163.voiceOptIn ~= nil then
				v1337.voice_opt_in = prop_types.BoolProp.jsonDecode(t163.voiceOptIn)
			end

			if t163.event_context ~= nil then
				v1337.event_context = prop_types.StringProp.jsonDecode(t163.event_context)
			end

			if t163.eventContext ~= nil then
				v1337.event_context = prop_types.StringProp.jsonDecode(t163.eventContext)
			end

			if t163.origin ~= nil then
				v1337.origin = prop_types.StringProp.jsonDecode(t163.origin)
			end

			if t163.should_autofill_android_phone_number_at_launch ~= nil then
				v1337.should_autofill_android_phone_number_at_launch = prop_types.BoolProp.jsonDecode(t163.should_autofill_android_phone_number_at_launch)
			end

			if t163.shouldAutofillAndroidPhoneNumberAtLaunch ~= nil then
				v1337.should_autofill_android_phone_number_at_launch = prop_types.BoolProp.jsonDecode(t163.shouldAutofillAndroidPhoneNumberAtLaunch)
			end

			if t163.add_phone_description_key ~= nil then
				v1337.add_phone_description_key = prop_types.StringProp.jsonDecode(t163.add_phone_description_key)
			end

			if t163.addPhoneDescriptionKey ~= nil then
				v1337.add_phone_description_key = prop_types.StringProp.jsonDecode(t163.addPhoneDescriptionKey)
			end

			if t163.on_success ~= nil then
				v1337.on_success = t1.ActionProp.jsonDecode(t163.on_success)
			end

			if t163.onSuccess ~= nil then
				v1337.on_success = t1.ActionProp.jsonDecode(t163.onSuccess)
			end

			if t163.on_failure ~= nil then
				v1337.on_failure = t1.ActionProp.jsonDecode(t163.on_failure)
			end

			if t163.onFailure ~= nil then
				v1337.on_failure = t1.ActionProp.jsonDecode(t163.onFailure)
			end

			if t163.on_cancelled ~= nil then
				v1337.on_cancelled = t1.ActionProp.jsonDecode(t163.on_cancelled)
			end

			if t163.onCancelled ~= nil then
				v1337.on_cancelled = t1.ActionProp.jsonDecode(t163.onCancelled)
			end

			return v1337
		end

		t160.descriptor = {
			name = "OpenPhoneUpsellModalAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenPhoneUpsellModalAction_Params = t160
		typeRegistry.default:register(t1.OpenPhoneUpsellModalAction_Params)

		local t164 = {}

		t164.__index = t164

		function t164.new(t165: {[any]: any}?) -- line: 11600
			-- upvalues: t1 (copy), t164 (copy)
			return (setmetatable({
				action_type = if t165 ~= nil and t165.action_type ~= nil then t165.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t165 ~= nil and t165.action_params ~= nil then t165.action_params else nil
			}, t164))
		end
		function t164.encode(p124) -- line: 11611
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n81 = 0

			if p124.action_type ~= nil and (p124.action_type ~= nil and p124.action_type ~= 0 or p124.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1342, v1343 = proto.writeTag(buf, n81, 1, proto.wireTypes.varint)

				buf, n81 = proto.writeVarInt(v1342, v1343, t1.ActionType.toNumber(p124.action_type))
			end

			if p124.action_params ~= nil then
				local v1344 = p124.action_params:encode()
				local v1345, v1346 = proto.writeTag(buf, n81, 2, proto.wireTypes.lengthDelimited)

				buf, n81 = proto.writeBuffer(v1345, v1346, v1344, buffer.len(v1344))
			end

			local buf43 = buffer.create(n81)

			buffer.copy(buf43, 0, buf, 0, n81)

			return buf43
		end
		function t164.decode(p125: buffer) -- line: 11637
			-- upvalues: t164 (copy), proto (copy), t1 (copy)
			local v1349 = t164.new()
			local n82 = 0

			while n82 < buffer.len(p125) do
				local v1351, v1352

				v1351, v1352, n82 = proto.readTag(p125, n82)

				if v1352 == proto.wireTypes.varint then
					if v1351 == 1 then
						local v1353

						v1353, n82 = proto.readVarIntI32(p125, n82)
						v1349.action_type = t1.ActionType.fromNumber(v1353) or v1353
					else
						local v1354

						v1354, n82 = proto.readVarInt(p125, n82)
					end
				elseif v1352 == proto.wireTypes.lengthDelimited then
					if v1351 == 2 then
						local v1355

						v1355, n82 = proto.readBuffer(p125, n82)
						v1349.action_params = t1.OpenEmailUpsellModalAction_Params.decode(v1355)
					else
						local v1356, v1357 = proto.readVarInt(p125, n82)

						n82 = v1357 + v1356
					end
				elseif v1352 == proto.wireTypes.i32 then
					local v1358

					v1358, n82 = proto.readFixed32(p125, n82)
				elseif v1352 == proto.wireTypes.i64 then
					local v1359

					v1359, n82 = proto.readFixed64(p125, n82)
				else
					error("Unsupported wire type: " .. v1352)
				end
			end

			return v1349
		end
		function t164.jsonEncode(p126) -- line: 11685
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
		function t164.jsonDecode(t167: {[any]: any}) -- line: 11707
			-- upvalues: t164 (copy), t1 (copy)
			local v1363 = t164.new()

			if t167.action_type ~= nil then
				v1363.action_type = if typeof(t167.action_type) ~= "number" then t1.ActionType.fromName(t167.action_type) or t167.action_type else t1.ActionType.fromNumber(t167.action_type) or t167.action_type
			end

			if t167.actionType ~= nil then
				v1363.action_type = if typeof(t167.actionType) ~= "number" then t1.ActionType.fromName(t167.actionType) or t167.actionType else t1.ActionType.fromNumber(t167.actionType) or t167.actionType
			end

			if t167.action_params ~= nil then
				v1363.action_params = t1.OpenEmailUpsellModalAction_Params.jsonDecode(t167.action_params)
			end

			if t167.actionParams ~= nil then
				v1363.action_params = t1.OpenEmailUpsellModalAction_Params.jsonDecode(t167.actionParams)
			end

			return v1363
		end

		t164.descriptor = {
			name = "OpenEmailUpsellModalAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenEmailUpsellModalAction"
		}
		t1.OpenEmailUpsellModalAction = t164
	end

	typeRegistry.default:register(t1.OpenEmailUpsellModalAction)

	do
		local t168 = {}

		t168.__index = t168

		function t168.new(t169: {[any]: any}?) -- line: 11747
			-- upvalues: t168 (copy)
			return (setmetatable({
				add_email_over13_text_key = if t169 ~= nil and t169.add_email_over13_text_key ~= nil then t169.add_email_over13_text_key else nil,
				add_email_title_key = if t169 ~= nil and t169.add_email_title_key ~= nil then t169.add_email_title_key else nil,
				is_email_modal_called_from_home_page = if t169 ~= nil and t169.is_email_modal_called_from_home_page ~= nil then t169.is_email_modal_called_from_home_page else nil,
				event_context = if t169 ~= nil and t169.event_context ~= nil then t169.event_context else nil,
				origin = if t169 ~= nil and t169.origin ~= nil then t169.origin else nil,
				section = if t169 ~= nil and t169.section ~= nil then t169.section else nil,
				on_success = if t169 ~= nil and t169.on_success ~= nil then t169.on_success else nil,
				on_failure = if t169 ~= nil and t169.on_failure ~= nil then t169.on_failure else nil
			}, t168))
		end
		function t168.encode(p127) -- line: 11769
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n83 = 0

			if p127.add_email_over13_text_key ~= nil then
				local v1368 = p127.add_email_over13_text_key:encode()
				local v1369, v1370 = proto.writeTag(buf, n83, 1, proto.wireTypes.lengthDelimited)

				buf, n83 = proto.writeBuffer(v1369, v1370, v1368, buffer.len(v1368))
			end

			if p127.add_email_title_key ~= nil then
				local v1371 = p127.add_email_title_key:encode()
				local v1372, v1373 = proto.writeTag(buf, n83, 2, proto.wireTypes.lengthDelimited)

				buf, n83 = proto.writeBuffer(v1372, v1373, v1371, buffer.len(v1371))
			end

			if p127.is_email_modal_called_from_home_page ~= nil then
				local v1374 = p127.is_email_modal_called_from_home_page:encode()
				local v1375, v1376 = proto.writeTag(buf, n83, 3, proto.wireTypes.lengthDelimited)

				buf, n83 = proto.writeBuffer(v1375, v1376, v1374, buffer.len(v1374))
			end

			if p127.event_context ~= nil then
				local v1377 = p127.event_context:encode()
				local v1378, v1379 = proto.writeTag(buf, n83, 4, proto.wireTypes.lengthDelimited)

				buf, n83 = proto.writeBuffer(v1378, v1379, v1377, buffer.len(v1377))
			end

			if p127.origin ~= nil then
				local v1380 = p127.origin:encode()
				local v1381, v1382 = proto.writeTag(buf, n83, 5, proto.wireTypes.lengthDelimited)

				buf, n83 = proto.writeBuffer(v1381, v1382, v1380, buffer.len(v1380))
			end

			if p127.section ~= nil then
				local v1383 = p127.section:encode()
				local v1384, v1385 = proto.writeTag(buf, n83, 6, proto.wireTypes.lengthDelimited)

				buf, n83 = proto.writeBuffer(v1384, v1385, v1383, buffer.len(v1383))
			end

			if p127.on_success ~= nil then
				local v1386 = p127.on_success:encode()
				local v1387, v1388 = proto.writeTag(buf, n83, 7, proto.wireTypes.lengthDelimited)

				buf, n83 = proto.writeBuffer(v1387, v1388, v1386, buffer.len(v1386))
			end

			if p127.on_failure ~= nil then
				local v1389 = p127.on_failure:encode()
				local v1390, v1391 = proto.writeTag(buf, n83, 8, proto.wireTypes.lengthDelimited)

				buf, n83 = proto.writeBuffer(v1390, v1391, v1389, buffer.len(v1389))
			end

			local buf44 = buffer.create(n83)

			buffer.copy(buf44, 0, buf, 0, n83)

			return buf44
		end
		function t168.decode(p128: buffer) -- line: 11826
			-- upvalues: t168 (copy), proto (copy), prop_types (copy), t1 (copy)
			local v1394 = t168.new()
			local n84 = 0

			while n84 < buffer.len(p128) do
				local v1396, v1397

				v1396, v1397, n84 = proto.readTag(p128, n84)

				if v1397 == proto.wireTypes.varint then
					local v1398

					v1398, n84 = proto.readVarInt(p128, n84)
				elseif v1397 == proto.wireTypes.lengthDelimited then
					if v1396 == 1 then
						local v1399

						v1399, n84 = proto.readBuffer(p128, n84)
						v1394.add_email_over13_text_key = prop_types.StringProp.decode(v1399)
					elseif v1396 == 2 then
						local v1400

						v1400, n84 = proto.readBuffer(p128, n84)
						v1394.add_email_title_key = prop_types.StringProp.decode(v1400)
					elseif v1396 == 3 then
						local v1401

						v1401, n84 = proto.readBuffer(p128, n84)
						v1394.is_email_modal_called_from_home_page = prop_types.BoolProp.decode(v1401)
					elseif v1396 == 4 then
						local v1402

						v1402, n84 = proto.readBuffer(p128, n84)
						v1394.event_context = prop_types.StringProp.decode(v1402)
					elseif v1396 == 5 then
						local v1403

						v1403, n84 = proto.readBuffer(p128, n84)
						v1394.origin = prop_types.StringProp.decode(v1403)
					elseif v1396 == 6 then
						local v1404

						v1404, n84 = proto.readBuffer(p128, n84)
						v1394.section = prop_types.StringProp.decode(v1404)
					elseif v1396 == 7 then
						local v1405

						v1405, n84 = proto.readBuffer(p128, n84)
						v1394.on_success = t1.ActionProp.decode(v1405)
					elseif v1396 == 8 then
						local v1406

						v1406, n84 = proto.readBuffer(p128, n84)
						v1394.on_failure = t1.ActionProp.decode(v1406)
					else
						local v1407, v1408 = proto.readVarInt(p128, n84)

						n84 = v1408 + v1407
					end
				elseif v1397 == proto.wireTypes.i32 then
					local v1409

					v1409, n84 = proto.readFixed32(p128, n84)
				elseif v1397 == proto.wireTypes.i64 then
					local v1410

					v1410, n84 = proto.readFixed64(p128, n84)
				else
					error("Unsupported wire type: " .. v1397)
				end
			end

			return v1394
		end
		function t168.jsonEncode(p129) -- line: 11907
			local t170 = {}

			if p129.add_email_over13_text_key ~= nil then
				t170.addEmailOver13TextKey = p129.add_email_over13_text_key:jsonEncode()
			end

			if p129.add_email_title_key ~= nil then
				t170.addEmailTitleKey = p129.add_email_title_key:jsonEncode()
			end

			if p129.is_email_modal_called_from_home_page ~= nil then
				t170.isEmailModalCalledFromHomePage = p129.is_email_modal_called_from_home_page:jsonEncode()
			end

			if p129.event_context ~= nil then
				t170.eventContext = p129.event_context:jsonEncode()
			end

			if p129.origin ~= nil then
				t170.origin = p129.origin:jsonEncode()
			end

			if p129.section ~= nil then
				t170.section = p129.section:jsonEncode()
			end

			if p129.on_success ~= nil then
				t170.onSuccess = p129.on_success:jsonEncode()
			end

			if p129.on_failure ~= nil then
				t170.onFailure = p129.on_failure:jsonEncode()
			end

			return t170
		end
		function t168.jsonDecode(t171: {[any]: any}) -- line: 11945
			-- upvalues: t168 (copy), prop_types (copy), t1 (copy)
			local v1414 = t168.new()

			if t171.add_email_over13_text_key ~= nil then
				v1414.add_email_over13_text_key = prop_types.StringProp.jsonDecode(t171.add_email_over13_text_key)
			end

			if t171.addEmailOver13TextKey ~= nil then
				v1414.add_email_over13_text_key = prop_types.StringProp.jsonDecode(t171.addEmailOver13TextKey)
			end

			if t171.add_email_title_key ~= nil then
				v1414.add_email_title_key = prop_types.StringProp.jsonDecode(t171.add_email_title_key)
			end

			if t171.addEmailTitleKey ~= nil then
				v1414.add_email_title_key = prop_types.StringProp.jsonDecode(t171.addEmailTitleKey)
			end

			if t171.is_email_modal_called_from_home_page ~= nil then
				v1414.is_email_modal_called_from_home_page = prop_types.BoolProp.jsonDecode(t171.is_email_modal_called_from_home_page)
			end

			if t171.isEmailModalCalledFromHomePage ~= nil then
				v1414.is_email_modal_called_from_home_page = prop_types.BoolProp.jsonDecode(t171.isEmailModalCalledFromHomePage)
			end

			if t171.event_context ~= nil then
				v1414.event_context = prop_types.StringProp.jsonDecode(t171.event_context)
			end

			if t171.eventContext ~= nil then
				v1414.event_context = prop_types.StringProp.jsonDecode(t171.eventContext)
			end

			if t171.origin ~= nil then
				v1414.origin = prop_types.StringProp.jsonDecode(t171.origin)
			end

			if t171.section ~= nil then
				v1414.section = prop_types.StringProp.jsonDecode(t171.section)
			end

			if t171.on_success ~= nil then
				v1414.on_success = t1.ActionProp.jsonDecode(t171.on_success)
			end

			if t171.onSuccess ~= nil then
				v1414.on_success = t1.ActionProp.jsonDecode(t171.onSuccess)
			end

			if t171.on_failure ~= nil then
				v1414.on_failure = t1.ActionProp.jsonDecode(t171.on_failure)
			end

			if t171.onFailure ~= nil then
				v1414.on_failure = t1.ActionProp.jsonDecode(t171.onFailure)
			end

			return v1414
		end

		t168.descriptor = {
			name = "OpenEmailUpsellModalAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenEmailUpsellModalAction_Params = t168
		typeRegistry.default:register(t1.OpenEmailUpsellModalAction_Params)

		local t172 = {}

		t172.__index = t172

		function t172.new(t173: {[any]: any}?) -- line: 12035
			-- upvalues: t1 (copy), t172 (copy)
			return (setmetatable({
				action_type = if t173 ~= nil and t173.action_type ~= nil then t173.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t173 ~= nil and t173.action_params ~= nil then t173.action_params else nil
			}, t172))
		end
		function t172.encode(p130) -- line: 12046
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n85 = 0

			if p130.action_type ~= nil and (p130.action_type ~= nil and p130.action_type ~= 0 or p130.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1419, v1420 = proto.writeTag(buf, n85, 1, proto.wireTypes.varint)

				buf, n85 = proto.writeVarInt(v1419, v1420, t1.ActionType.toNumber(p130.action_type))
			end

			if p130.action_params ~= nil then
				local v1421 = p130.action_params:encode()
				local v1422, v1423 = proto.writeTag(buf, n85, 2, proto.wireTypes.lengthDelimited)

				buf, n85 = proto.writeBuffer(v1422, v1423, v1421, buffer.len(v1421))
			end

			local buf45 = buffer.create(n85)

			buffer.copy(buf45, 0, buf, 0, n85)

			return buf45
		end
		function t172.decode(p131: buffer) -- line: 12072
			-- upvalues: t172 (copy), proto (copy), t1 (copy)
			local v1426 = t172.new()
			local n86 = 0

			while n86 < buffer.len(p131) do
				local v1428, v1429

				v1428, v1429, n86 = proto.readTag(p131, n86)

				if v1429 == proto.wireTypes.varint then
					if v1428 == 1 then
						local v1430

						v1430, n86 = proto.readVarIntI32(p131, n86)
						v1426.action_type = t1.ActionType.fromNumber(v1430) or v1430
					else
						local v1431

						v1431, n86 = proto.readVarInt(p131, n86)
					end
				elseif v1429 == proto.wireTypes.lengthDelimited then
					if v1428 == 2 then
						local v1432

						v1432, n86 = proto.readBuffer(p131, n86)
						v1426.action_params = t1.OpenAddConnectionsPageAction_Params.decode(v1432)
					else
						local v1433, v1434 = proto.readVarInt(p131, n86)

						n86 = v1434 + v1433
					end
				elseif v1429 == proto.wireTypes.i32 then
					local v1435

					v1435, n86 = proto.readFixed32(p131, n86)
				elseif v1429 == proto.wireTypes.i64 then
					local v1436

					v1436, n86 = proto.readFixed64(p131, n86)
				else
					error("Unsupported wire type: " .. v1429)
				end
			end

			return v1426
		end
		function t172.jsonEncode(p132) -- line: 12120
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
		function t172.jsonDecode(t175: {[any]: any}) -- line: 12142
			-- upvalues: t172 (copy), t1 (copy)
			local v1440 = t172.new()

			if t175.action_type ~= nil then
				v1440.action_type = if typeof(t175.action_type) ~= "number" then t1.ActionType.fromName(t175.action_type) or t175.action_type else t1.ActionType.fromNumber(t175.action_type) or t175.action_type
			end

			if t175.actionType ~= nil then
				v1440.action_type = if typeof(t175.actionType) ~= "number" then t1.ActionType.fromName(t175.actionType) or t175.actionType else t1.ActionType.fromNumber(t175.actionType) or t175.actionType
			end

			if t175.action_params ~= nil then
				v1440.action_params = t1.OpenAddConnectionsPageAction_Params.jsonDecode(t175.action_params)
			end

			if t175.actionParams ~= nil then
				v1440.action_params = t1.OpenAddConnectionsPageAction_Params.jsonDecode(t175.actionParams)
			end

			return v1440
		end

		t172.descriptor = {
			name = "OpenAddConnectionsPageAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenAddConnectionsPageAction"
		}
		t1.OpenAddConnectionsPageAction = t172
	end

	typeRegistry.default:register(t1.OpenAddConnectionsPageAction)

	do
		local t176 = {}

		t176.__index = t176

		function t176.new(t177: {[any]: any}?) -- line: 12182
			-- upvalues: t176 (copy)
			return (setmetatable({
				user_id = if t177 ~= nil and t177.user_id ~= nil then t177.user_id else nil,
				source = if t177 ~= nil and t177.source ~= nil then t177.source else nil
			}, t176))
		end
		function t176.encode(p133) -- line: 12191
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n87 = 0

			if p133.user_id ~= nil then
				local v1445 = p133.user_id:encode()
				local v1446, v1447 = proto.writeTag(buf, n87, 1, proto.wireTypes.lengthDelimited)

				buf, n87 = proto.writeBuffer(v1446, v1447, v1445, buffer.len(v1445))
			end

			if p133.source ~= nil then
				local v1448 = p133.source:encode()
				local v1449, v1450 = proto.writeTag(buf, n87, 2, proto.wireTypes.lengthDelimited)

				buf, n87 = proto.writeBuffer(v1449, v1450, v1448, buffer.len(v1448))
			end

			local buf46 = buffer.create(n87)

			buffer.copy(buf46, 0, buf, 0, n87)

			return buf46
		end
		function t176.decode(p134: buffer) -- line: 12212
			-- upvalues: t176 (copy), proto (copy), prop_types (copy)
			local v1453 = t176.new()
			local n88 = 0

			while n88 < buffer.len(p134) do
				local v1455, v1456

				v1455, v1456, n88 = proto.readTag(p134, n88)

				if v1456 == proto.wireTypes.varint then
					local v1457

					v1457, n88 = proto.readVarInt(p134, n88)
				elseif v1456 == proto.wireTypes.lengthDelimited then
					if v1455 == 1 then
						local v1458

						v1458, n88 = proto.readBuffer(p134, n88)
						v1453.user_id = prop_types.StringProp.decode(v1458)
					elseif v1455 == 2 then
						local v1459

						v1459, n88 = proto.readBuffer(p134, n88)
						v1453.source = prop_types.StringProp.decode(v1459)
					else
						local v1460, v1461 = proto.readVarInt(p134, n88)

						n88 = v1461 + v1460
					end
				elseif v1456 == proto.wireTypes.i32 then
					local v1462

					v1462, n88 = proto.readFixed32(p134, n88)
				elseif v1456 == proto.wireTypes.i64 then
					local v1463

					v1463, n88 = proto.readFixed64(p134, n88)
				else
					error("Unsupported wire type: " .. v1456)
				end
			end

			return v1453
		end
		function t176.jsonEncode(p135) -- line: 12260
			local t178 = {}

			if p135.user_id ~= nil then
				t178.userId = p135.user_id:jsonEncode()
			end

			if p135.source ~= nil then
				t178.source = p135.source:jsonEncode()
			end

			return t178
		end
		function t176.jsonDecode(t179: {[any]: any}) -- line: 12274
			-- upvalues: t176 (copy), prop_types (copy)
			local v1467 = t176.new()

			if t179.user_id ~= nil then
				v1467.user_id = prop_types.StringProp.jsonDecode(t179.user_id)
			end

			if t179.userId ~= nil then
				v1467.user_id = prop_types.StringProp.jsonDecode(t179.userId)
			end

			if t179.source ~= nil then
				v1467.source = prop_types.StringProp.jsonDecode(t179.source)
			end

			return v1467
		end

		t176.descriptor = {
			name = "OpenAddConnectionsPageAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenAddConnectionsPageAction_Params = t176
		typeRegistry.default:register(t1.OpenAddConnectionsPageAction_Params)

		local t180 = {}

		t180.__index = t180

		function t180.new(t181: {[any]: any}?) -- line: 12308
			-- upvalues: t1 (copy), t180 (copy)
			return (setmetatable({
				action_type = if t181 ~= nil and t181.action_type ~= nil then t181.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t181 ~= nil and t181.action_params ~= nil then t181.action_params else nil
			}, t180))
		end
		function t180.encode(p136) -- line: 12317
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n89 = 0

			if p136.action_type ~= nil and (p136.action_type ~= nil and p136.action_type ~= 0 or p136.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1472, v1473 = proto.writeTag(buf, n89, 1, proto.wireTypes.varint)

				buf, n89 = proto.writeVarInt(v1472, v1473, t1.ActionType.toNumber(p136.action_type))
			end

			if p136.action_params ~= nil then
				local v1474 = p136.action_params:encode()
				local v1475, v1476 = proto.writeTag(buf, n89, 2, proto.wireTypes.lengthDelimited)

				buf, n89 = proto.writeBuffer(v1475, v1476, v1474, buffer.len(v1474))
			end

			local buf47 = buffer.create(n89)

			buffer.copy(buf47, 0, buf, 0, n89)

			return buf47
		end
		function t180.decode(p137: buffer) -- line: 12343
			-- upvalues: t180 (copy), proto (copy), t1 (copy)
			local v1479 = t180.new()
			local n90 = 0

			while n90 < buffer.len(p137) do
				local v1481, v1482

				v1481, v1482, n90 = proto.readTag(p137, n90)

				if v1482 == proto.wireTypes.varint then
					if v1481 == 1 then
						local v1483

						v1483, n90 = proto.readVarIntI32(p137, n90)
						v1479.action_type = t1.ActionType.fromNumber(v1483) or v1483
					else
						local v1484

						v1484, n90 = proto.readVarInt(p137, n90)
					end
				elseif v1482 == proto.wireTypes.lengthDelimited then
					if v1481 == 2 then
						local v1485

						v1485, n90 = proto.readBuffer(p137, n90)
						v1479.action_params = t1.OpenMarketplaceAction_Params.decode(v1485)
					else
						local v1486, v1487 = proto.readVarInt(p137, n90)

						n90 = v1487 + v1486
					end
				elseif v1482 == proto.wireTypes.i32 then
					local v1488

					v1488, n90 = proto.readFixed32(p137, n90)
				elseif v1482 == proto.wireTypes.i64 then
					local v1489

					v1489, n90 = proto.readFixed64(p137, n90)
				else
					error("Unsupported wire type: " .. v1482)
				end
			end

			return v1479
		end
		function t180.jsonEncode(p138) -- line: 12391
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
		function t180.jsonDecode(t183: {[any]: any}) -- line: 12413
			-- upvalues: t180 (copy), t1 (copy)
			local v1493 = t180.new()

			if t183.action_type ~= nil then
				v1493.action_type = if typeof(t183.action_type) ~= "number" then t1.ActionType.fromName(t183.action_type) or t183.action_type else t1.ActionType.fromNumber(t183.action_type) or t183.action_type
			end

			if t183.actionType ~= nil then
				v1493.action_type = if typeof(t183.actionType) ~= "number" then t1.ActionType.fromName(t183.actionType) or t183.actionType else t1.ActionType.fromNumber(t183.actionType) or t183.actionType
			end

			if t183.action_params ~= nil then
				v1493.action_params = t1.OpenMarketplaceAction_Params.jsonDecode(t183.action_params)
			end

			if t183.actionParams ~= nil then
				v1493.action_params = t1.OpenMarketplaceAction_Params.jsonDecode(t183.actionParams)
			end

			return v1493
		end

		t180.descriptor = {
			name = "OpenMarketplaceAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenMarketplaceAction"
		}
		t1.OpenMarketplaceAction = t180
	end

	typeRegistry.default:register(t1.OpenMarketplaceAction)

	do
		local t184 = {}

		t184.__index = t184

		function t184.new(t185: {[any]: any}?) -- line: 12453
			-- upvalues: t184 (copy)
			return (setmetatable({
				user_id = if t185 ~= nil and t185.user_id ~= nil then t185.user_id else nil,
				source = if t185 ~= nil and t185.source ~= nil then t185.source else nil
			}, t184))
		end
		function t184.encode(p139) -- line: 12462
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n91 = 0

			if p139.user_id ~= nil then
				local v1498 = p139.user_id:encode()
				local v1499, v1500 = proto.writeTag(buf, n91, 1, proto.wireTypes.lengthDelimited)

				buf, n91 = proto.writeBuffer(v1499, v1500, v1498, buffer.len(v1498))
			end

			if p139.source ~= nil then
				local v1501 = p139.source:encode()
				local v1502, v1503 = proto.writeTag(buf, n91, 2, proto.wireTypes.lengthDelimited)

				buf, n91 = proto.writeBuffer(v1502, v1503, v1501, buffer.len(v1501))
			end

			local buf48 = buffer.create(n91)

			buffer.copy(buf48, 0, buf, 0, n91)

			return buf48
		end
		function t184.decode(p140: buffer) -- line: 12483
			-- upvalues: t184 (copy), proto (copy), prop_types (copy)
			local v1506 = t184.new()
			local n92 = 0

			while n92 < buffer.len(p140) do
				local v1508, v1509

				v1508, v1509, n92 = proto.readTag(p140, n92)

				if v1509 == proto.wireTypes.varint then
					local v1510

					v1510, n92 = proto.readVarInt(p140, n92)
				elseif v1509 == proto.wireTypes.lengthDelimited then
					if v1508 == 1 then
						local v1511

						v1511, n92 = proto.readBuffer(p140, n92)
						v1506.user_id = prop_types.StringProp.decode(v1511)
					elseif v1508 == 2 then
						local v1512

						v1512, n92 = proto.readBuffer(p140, n92)
						v1506.source = prop_types.StringProp.decode(v1512)
					else
						local v1513, v1514 = proto.readVarInt(p140, n92)

						n92 = v1514 + v1513
					end
				elseif v1509 == proto.wireTypes.i32 then
					local v1515

					v1515, n92 = proto.readFixed32(p140, n92)
				elseif v1509 == proto.wireTypes.i64 then
					local v1516

					v1516, n92 = proto.readFixed64(p140, n92)
				else
					error("Unsupported wire type: " .. v1509)
				end
			end

			return v1506
		end
		function t184.jsonEncode(p141) -- line: 12531
			local t186 = {}

			if p141.user_id ~= nil then
				t186.userId = p141.user_id:jsonEncode()
			end

			if p141.source ~= nil then
				t186.source = p141.source:jsonEncode()
			end

			return t186
		end
		function t184.jsonDecode(t187: {[any]: any}) -- line: 12545
			-- upvalues: t184 (copy), prop_types (copy)
			local v1520 = t184.new()

			if t187.user_id ~= nil then
				v1520.user_id = prop_types.StringProp.jsonDecode(t187.user_id)
			end

			if t187.userId ~= nil then
				v1520.user_id = prop_types.StringProp.jsonDecode(t187.userId)
			end

			if t187.source ~= nil then
				v1520.source = prop_types.StringProp.jsonDecode(t187.source)
			end

			return v1520
		end

		t184.descriptor = {
			name = "OpenMarketplaceAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenMarketplaceAction_Params = t184
		typeRegistry.default:register(t1.OpenMarketplaceAction_Params)

		local t188 = {}

		t188.__index = t188

		function t188.new(t189: {[any]: any}?) -- line: 12577
			-- upvalues: t1 (copy), t188 (copy)
			return (setmetatable({
				action_type = if t189 ~= nil and t189.action_type ~= nil then t189.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t189 ~= nil and t189.action_params ~= nil then t189.action_params else nil
			}, t188))
		end
		function t188.encode(p142) -- line: 12588
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n93 = 0

			if p142.action_type ~= nil and (p142.action_type ~= nil and p142.action_type ~= 0 or p142.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1525, v1526 = proto.writeTag(buf, n93, 1, proto.wireTypes.varint)

				buf, n93 = proto.writeVarInt(v1525, v1526, t1.ActionType.toNumber(p142.action_type))
			end

			if p142.action_params ~= nil then
				local v1527 = p142.action_params:encode()
				local v1528, v1529 = proto.writeTag(buf, n93, 2, proto.wireTypes.lengthDelimited)

				buf, n93 = proto.writeBuffer(v1528, v1529, v1527, buffer.len(v1527))
			end

			local buf49 = buffer.create(n93)

			buffer.copy(buf49, 0, buf, 0, n93)

			return buf49
		end
		function t188.decode(p143: buffer) -- line: 12614
			-- upvalues: t188 (copy), proto (copy), t1 (copy)
			local v1532 = t188.new()
			local n94 = 0

			while n94 < buffer.len(p143) do
				local v1534, v1535

				v1534, v1535, n94 = proto.readTag(p143, n94)

				if v1535 == proto.wireTypes.varint then
					if v1534 == 1 then
						local v1536

						v1536, n94 = proto.readVarIntI32(p143, n94)
						v1532.action_type = t1.ActionType.fromNumber(v1536) or v1536
					else
						local v1537

						v1537, n94 = proto.readVarInt(p143, n94)
					end
				elseif v1535 == proto.wireTypes.lengthDelimited then
					if v1534 == 2 then
						local v1538

						v1538, n94 = proto.readBuffer(p143, n94)
						v1532.action_params = t1.HideProfileCompletionAction_Params.decode(v1538)
					else
						local v1539, v1540 = proto.readVarInt(p143, n94)

						n94 = v1540 + v1539
					end
				elseif v1535 == proto.wireTypes.i32 then
					local v1541

					v1541, n94 = proto.readFixed32(p143, n94)
				elseif v1535 == proto.wireTypes.i64 then
					local v1542

					v1542, n94 = proto.readFixed64(p143, n94)
				else
					error("Unsupported wire type: " .. v1535)
				end
			end

			return v1532
		end
		function t188.jsonEncode(p144) -- line: 12662
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
		function t188.jsonDecode(t191: {[any]: any}) -- line: 12684
			-- upvalues: t188 (copy), t1 (copy)
			local v1546 = t188.new()

			if t191.action_type ~= nil then
				v1546.action_type = if typeof(t191.action_type) ~= "number" then t1.ActionType.fromName(t191.action_type) or t191.action_type else t1.ActionType.fromNumber(t191.action_type) or t191.action_type
			end

			if t191.actionType ~= nil then
				v1546.action_type = if typeof(t191.actionType) ~= "number" then t1.ActionType.fromName(t191.actionType) or t191.actionType else t1.ActionType.fromNumber(t191.actionType) or t191.actionType
			end

			if t191.action_params ~= nil then
				v1546.action_params = t1.HideProfileCompletionAction_Params.jsonDecode(t191.action_params)
			end

			if t191.actionParams ~= nil then
				v1546.action_params = t1.HideProfileCompletionAction_Params.jsonDecode(t191.actionParams)
			end

			return v1546
		end

		t188.descriptor = {
			name = "HideProfileCompletionAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.HideProfileCompletionAction"
		}
		t1.HideProfileCompletionAction = t188
	end

	typeRegistry.default:register(t1.HideProfileCompletionAction)

	do
		local t192 = {}

		t192.__index = t192

		function t192.new(t193: {[any]: any}?) -- line: 12724
			-- upvalues: t192 (copy)
			return (setmetatable({
				user_id = if t193 ~= nil and t193.user_id ~= nil then t193.user_id else nil,
				prompt_id = if t193 ~= nil and t193.prompt_id ~= nil then t193.prompt_id else nil,
				source = if t193 ~= nil and t193.source ~= nil then t193.source else nil,
				prompt_type = if t193 ~= nil and t193.prompt_type ~= nil then t193.prompt_type else nil
			}, t192))
		end
		function t192.encode(p145) -- line: 12735
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n95 = 0

			if p145.user_id ~= nil then
				local v1551 = p145.user_id:encode()
				local v1552, v1553 = proto.writeTag(buf, n95, 1, proto.wireTypes.lengthDelimited)

				buf, n95 = proto.writeBuffer(v1552, v1553, v1551, buffer.len(v1551))
			end

			if p145.prompt_id ~= nil then
				local v1554 = p145.prompt_id:encode()
				local v1555, v1556 = proto.writeTag(buf, n95, 2, proto.wireTypes.lengthDelimited)

				buf, n95 = proto.writeBuffer(v1555, v1556, v1554, buffer.len(v1554))
			end

			if p145.source ~= nil then
				local v1557 = p145.source:encode()
				local v1558, v1559 = proto.writeTag(buf, n95, 3, proto.wireTypes.lengthDelimited)

				buf, n95 = proto.writeBuffer(v1558, v1559, v1557, buffer.len(v1557))
			end

			if p145.prompt_type ~= nil then
				local v1560 = p145.prompt_type:encode()
				local v1561, v1562 = proto.writeTag(buf, n95, 4, proto.wireTypes.lengthDelimited)

				buf, n95 = proto.writeBuffer(v1561, v1562, v1560, buffer.len(v1560))
			end

			local buf50 = buffer.create(n95)

			buffer.copy(buf50, 0, buf, 0, n95)

			return buf50
		end
		function t192.decode(p146: buffer) -- line: 12768
			-- upvalues: t192 (copy), proto (copy), prop_types (copy)
			local v1565 = t192.new()
			local n96 = 0

			while n96 < buffer.len(p146) do
				local v1567, v1568

				v1567, v1568, n96 = proto.readTag(p146, n96)

				if v1568 == proto.wireTypes.varint then
					local v1569

					v1569, n96 = proto.readVarInt(p146, n96)
				elseif v1568 == proto.wireTypes.lengthDelimited then
					if v1567 == 1 then
						local v1570

						v1570, n96 = proto.readBuffer(p146, n96)
						v1565.user_id = prop_types.StringProp.decode(v1570)
					elseif v1567 == 2 then
						local v1571

						v1571, n96 = proto.readBuffer(p146, n96)
						v1565.prompt_id = prop_types.StringProp.decode(v1571)
					elseif v1567 == 3 then
						local v1572

						v1572, n96 = proto.readBuffer(p146, n96)
						v1565.source = prop_types.StringProp.decode(v1572)
					elseif v1567 == 4 then
						local v1573

						v1573, n96 = proto.readBuffer(p146, n96)
						v1565.prompt_type = prop_types.StringProp.decode(v1573)
					else
						local v1574, v1575 = proto.readVarInt(p146, n96)

						n96 = v1575 + v1574
					end
				elseif v1568 == proto.wireTypes.i32 then
					local v1576

					v1576, n96 = proto.readFixed32(p146, n96)
				elseif v1568 == proto.wireTypes.i64 then
					local v1577

					v1577, n96 = proto.readFixed64(p146, n96)
				else
					error("Unsupported wire type: " .. v1568)
				end
			end

			return v1565
		end
		function t192.jsonEncode(p147) -- line: 12826
			local t194 = {}

			if p147.user_id ~= nil then
				t194.userId = p147.user_id:jsonEncode()
			end

			if p147.prompt_id ~= nil then
				t194.promptId = p147.prompt_id:jsonEncode()
			end

			if p147.source ~= nil then
				t194.source = p147.source:jsonEncode()
			end

			if p147.prompt_type ~= nil then
				t194.promptType = p147.prompt_type:jsonEncode()
			end

			return t194
		end
		function t192.jsonDecode(t195: {[any]: any}) -- line: 12848
			-- upvalues: t192 (copy), prop_types (copy)
			local v1581 = t192.new()

			if t195.user_id ~= nil then
				v1581.user_id = prop_types.StringProp.jsonDecode(t195.user_id)
			end

			if t195.userId ~= nil then
				v1581.user_id = prop_types.StringProp.jsonDecode(t195.userId)
			end

			if t195.prompt_id ~= nil then
				v1581.prompt_id = prop_types.StringProp.jsonDecode(t195.prompt_id)
			end

			if t195.promptId ~= nil then
				v1581.prompt_id = prop_types.StringProp.jsonDecode(t195.promptId)
			end

			if t195.source ~= nil then
				v1581.source = prop_types.StringProp.jsonDecode(t195.source)
			end

			if t195.prompt_type ~= nil then
				v1581.prompt_type = prop_types.StringProp.jsonDecode(t195.prompt_type)
			end

			if t195.promptType ~= nil then
				v1581.prompt_type = prop_types.StringProp.jsonDecode(t195.promptType)
			end

			return v1581
		end

		t192.descriptor = {
			name = "HideProfileCompletionAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.HideProfileCompletionAction_Params = t192
		typeRegistry.default:register(t1.HideProfileCompletionAction_Params)

		local t196 = {}

		t196.__index = t196

		function t196.new(t197: {[any]: any}?) -- line: 12899
			-- upvalues: t1 (copy), t196 (copy)
			return (setmetatable({
				action_type = if t197 ~= nil and t197.action_type ~= nil then t197.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t197 ~= nil and t197.action_params ~= nil then t197.action_params else nil
			}, t196))
		end
		function t196.encode(p148) -- line: 12910
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n97 = 0

			if p148.action_type ~= nil and (p148.action_type ~= nil and p148.action_type ~= 0 or p148.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1586, v1587 = proto.writeTag(buf, n97, 1, proto.wireTypes.varint)

				buf, n97 = proto.writeVarInt(v1586, v1587, t1.ActionType.toNumber(p148.action_type))
			end

			if p148.action_params ~= nil then
				local v1588 = p148.action_params:encode()
				local v1589, v1590 = proto.writeTag(buf, n97, 2, proto.wireTypes.lengthDelimited)

				buf, n97 = proto.writeBuffer(v1589, v1590, v1588, buffer.len(v1588))
			end

			local buf51 = buffer.create(n97)

			buffer.copy(buf51, 0, buf, 0, n97)

			return buf51
		end
		function t196.decode(p149: buffer) -- line: 12936
			-- upvalues: t196 (copy), proto (copy), t1 (copy)
			local v1593 = t196.new()
			local n98 = 0

			while n98 < buffer.len(p149) do
				local v1595, v1596

				v1595, v1596, n98 = proto.readTag(p149, n98)

				if v1596 == proto.wireTypes.varint then
					if v1595 == 1 then
						local v1597

						v1597, n98 = proto.readVarIntI32(p149, n98)
						v1593.action_type = t1.ActionType.fromNumber(v1597) or v1597
					else
						local v1598

						v1598, n98 = proto.readVarInt(p149, n98)
					end
				elseif v1596 == proto.wireTypes.lengthDelimited then
					if v1595 == 2 then
						local v1599

						v1599, n98 = proto.readBuffer(p149, n98)
						v1593.action_params = t1.SelectMarketplaceCatalogCategory_Params.decode(v1599)
					else
						local v1600, v1601 = proto.readVarInt(p149, n98)

						n98 = v1601 + v1600
					end
				elseif v1596 == proto.wireTypes.i32 then
					local v1602

					v1602, n98 = proto.readFixed32(p149, n98)
				elseif v1596 == proto.wireTypes.i64 then
					local v1603

					v1603, n98 = proto.readFixed64(p149, n98)
				else
					error("Unsupported wire type: " .. v1596)
				end
			end

			return v1593
		end
		function t196.jsonEncode(p150) -- line: 12984
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
		function t196.jsonDecode(t199: {[any]: any}) -- line: 13006
			-- upvalues: t196 (copy), t1 (copy)
			local v1607 = t196.new()

			if t199.action_type ~= nil then
				v1607.action_type = if typeof(t199.action_type) ~= "number" then t1.ActionType.fromName(t199.action_type) or t199.action_type else t1.ActionType.fromNumber(t199.action_type) or t199.action_type
			end

			if t199.actionType ~= nil then
				v1607.action_type = if typeof(t199.actionType) ~= "number" then t1.ActionType.fromName(t199.actionType) or t199.actionType else t1.ActionType.fromNumber(t199.actionType) or t199.actionType
			end

			if t199.action_params ~= nil then
				v1607.action_params = t1.SelectMarketplaceCatalogCategory_Params.jsonDecode(t199.action_params)
			end

			if t199.actionParams ~= nil then
				v1607.action_params = t1.SelectMarketplaceCatalogCategory_Params.jsonDecode(t199.actionParams)
			end

			return v1607
		end

		t196.descriptor = {
			name = "SelectMarketplaceCatalogCategory",
			fullName = "roblox.apppageplatform.shared.v1beta1.SelectMarketplaceCatalogCategory"
		}
		t1.SelectMarketplaceCatalogCategory = t196
	end

	typeRegistry.default:register(t1.SelectMarketplaceCatalogCategory)

	do
		local t200 = {}

		t200.__index = t200

		function t200.new(t201: {[any]: any}?) -- line: 13048
			-- upvalues: t200 (copy)
			return (setmetatable({
				category_id = if t201 ~= nil and t201.category_id ~= nil then t201.category_id else nil
			}, t200))
		end
		function t200.encode(p151) -- line: 13056
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n99 = 0

			if p151.category_id ~= nil then
				local v1612 = p151.category_id:encode()
				local v1613, v1614 = proto.writeTag(buf, n99, 1, proto.wireTypes.lengthDelimited)

				buf, n99 = proto.writeBuffer(v1613, v1614, v1612, buffer.len(v1612))
			end

			local buf52 = buffer.create(n99)

			buffer.copy(buf52, 0, buf, 0, n99)

			return buf52
		end
		function t200.decode(p152: buffer) -- line: 13071
			-- upvalues: t200 (copy), proto (copy), prop_types (copy)
			local v1617 = t200.new()
			local n100 = 0

			while n100 < buffer.len(p152) do
				local v1619, v1620

				v1619, v1620, n100 = proto.readTag(p152, n100)

				if v1620 == proto.wireTypes.varint then
					local v1621

					v1621, n100 = proto.readVarInt(p152, n100)
				elseif v1620 == proto.wireTypes.lengthDelimited then
					if v1619 == 1 then
						local v1622

						v1622, n100 = proto.readBuffer(p152, n100)
						v1617.category_id = prop_types.StringProp.decode(v1622)
					else
						local v1623, v1624 = proto.readVarInt(p152, n100)

						n100 = v1624 + v1623
					end
				elseif v1620 == proto.wireTypes.i32 then
					local v1625

					v1625, n100 = proto.readFixed32(p152, n100)
				elseif v1620 == proto.wireTypes.i64 then
					local v1626

					v1626, n100 = proto.readFixed64(p152, n100)
				else
					error("Unsupported wire type: " .. v1620)
				end
			end

			return v1617
		end
		function t200.jsonEncode(p153) -- line: 13114
			local t202 = {}

			if p153.category_id ~= nil then
				t202.categoryId = p153.category_id:jsonEncode()
			end

			return t202
		end
		function t200.jsonDecode(t203: {[any]: any}) -- line: 13124
			-- upvalues: t200 (copy), prop_types (copy)
			local v1630 = t200.new()

			if t203.category_id ~= nil then
				v1630.category_id = prop_types.StringProp.jsonDecode(t203.category_id)
			end

			if t203.categoryId ~= nil then
				v1630.category_id = prop_types.StringProp.jsonDecode(t203.categoryId)
			end

			return v1630
		end

		t200.descriptor = {
			name = "SelectMarketplaceCatalogCategory_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.SelectMarketplaceCatalogCategory_Params = t200
		typeRegistry.default:register(t1.SelectMarketplaceCatalogCategory_Params)

		local t204 = {}

		t204.__index = t204

		function t204.new(t205: {[any]: any}?) -- line: 13155
			-- upvalues: t1 (copy), t204 (copy)
			return (setmetatable({
				action_type = if t205 ~= nil and t205.action_type ~= nil then t205.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t205 ~= nil and t205.action_params ~= nil then t205.action_params else nil
			}, t204))
		end
		function t204.encode(p154) -- line: 13166
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n101 = 0

			if p154.action_type ~= nil and (p154.action_type ~= nil and p154.action_type ~= 0 or p154.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1635, v1636 = proto.writeTag(buf, n101, 1, proto.wireTypes.varint)

				buf, n101 = proto.writeVarInt(v1635, v1636, t1.ActionType.toNumber(p154.action_type))
			end

			if p154.action_params ~= nil then
				local v1637 = p154.action_params:encode()
				local v1638, v1639 = proto.writeTag(buf, n101, 2, proto.wireTypes.lengthDelimited)

				buf, n101 = proto.writeBuffer(v1638, v1639, v1637, buffer.len(v1637))
			end

			local buf53 = buffer.create(n101)

			buffer.copy(buf53, 0, buf, 0, n101)

			return buf53
		end
		function t204.decode(p155: buffer) -- line: 13192
			-- upvalues: t204 (copy), proto (copy), t1 (copy)
			local v1642 = t204.new()
			local n102 = 0

			while n102 < buffer.len(p155) do
				local v1644, v1645

				v1644, v1645, n102 = proto.readTag(p155, n102)

				if v1645 == proto.wireTypes.varint then
					if v1644 == 1 then
						local v1646

						v1646, n102 = proto.readVarIntI32(p155, n102)
						v1642.action_type = t1.ActionType.fromNumber(v1646) or v1646
					else
						local v1647

						v1647, n102 = proto.readVarInt(p155, n102)
					end
				elseif v1645 == proto.wireTypes.lengthDelimited then
					if v1644 == 2 then
						local v1648

						v1648, n102 = proto.readBuffer(p155, n102)
						v1642.action_params = t1.SelectMarketplaceCatalogSubcategory_Params.decode(v1648)
					else
						local v1649, v1650 = proto.readVarInt(p155, n102)

						n102 = v1650 + v1649
					end
				elseif v1645 == proto.wireTypes.i32 then
					local v1651

					v1651, n102 = proto.readFixed32(p155, n102)
				elseif v1645 == proto.wireTypes.i64 then
					local v1652

					v1652, n102 = proto.readFixed64(p155, n102)
				else
					error("Unsupported wire type: " .. v1645)
				end
			end

			return v1642
		end
		function t204.jsonEncode(p156) -- line: 13240
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
		function t204.jsonDecode(t207: {[any]: any}) -- line: 13262
			-- upvalues: t204 (copy), t1 (copy)
			local v1656 = t204.new()

			if t207.action_type ~= nil then
				v1656.action_type = if typeof(t207.action_type) ~= "number" then t1.ActionType.fromName(t207.action_type) or t207.action_type else t1.ActionType.fromNumber(t207.action_type) or t207.action_type
			end

			if t207.actionType ~= nil then
				v1656.action_type = if typeof(t207.actionType) ~= "number" then t1.ActionType.fromName(t207.actionType) or t207.actionType else t1.ActionType.fromNumber(t207.actionType) or t207.actionType
			end

			if t207.action_params ~= nil then
				v1656.action_params = t1.SelectMarketplaceCatalogSubcategory_Params.jsonDecode(t207.action_params)
			end

			if t207.actionParams ~= nil then
				v1656.action_params = t1.SelectMarketplaceCatalogSubcategory_Params.jsonDecode(t207.actionParams)
			end

			return v1656
		end

		t204.descriptor = {
			name = "SelectMarketplaceCatalogSubcategory",
			fullName = "roblox.apppageplatform.shared.v1beta1.SelectMarketplaceCatalogSubcategory"
		}
		t1.SelectMarketplaceCatalogSubcategory = t204
	end

	typeRegistry.default:register(t1.SelectMarketplaceCatalogSubcategory)

	do
		local t208 = {}

		t208.__index = t208

		function t208.new(t209: {[any]: any}?) -- line: 13304
			-- upvalues: t208 (copy)
			return (setmetatable({
				subcategory_id = if t209 ~= nil and t209.subcategory_id ~= nil then t209.subcategory_id else nil
			}, t208))
		end
		function t208.encode(p157) -- line: 13312
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n103 = 0

			if p157.subcategory_id ~= nil then
				local v1661 = p157.subcategory_id:encode()
				local v1662, v1663 = proto.writeTag(buf, n103, 1, proto.wireTypes.lengthDelimited)

				buf, n103 = proto.writeBuffer(v1662, v1663, v1661, buffer.len(v1661))
			end

			local buf54 = buffer.create(n103)

			buffer.copy(buf54, 0, buf, 0, n103)

			return buf54
		end
		function t208.decode(p158: buffer) -- line: 13329
			-- upvalues: t208 (copy), proto (copy), prop_types (copy)
			local v1666 = t208.new()
			local n104 = 0

			while n104 < buffer.len(p158) do
				local v1668, v1669

				v1668, v1669, n104 = proto.readTag(p158, n104)

				if v1669 == proto.wireTypes.varint then
					local v1670

					v1670, n104 = proto.readVarInt(p158, n104)
				elseif v1669 == proto.wireTypes.lengthDelimited then
					if v1668 == 1 then
						local v1671

						v1671, n104 = proto.readBuffer(p158, n104)
						v1666.subcategory_id = prop_types.StringProp.decode(v1671)
					else
						local v1672, v1673 = proto.readVarInt(p158, n104)

						n104 = v1673 + v1672
					end
				elseif v1669 == proto.wireTypes.i32 then
					local v1674

					v1674, n104 = proto.readFixed32(p158, n104)
				elseif v1669 == proto.wireTypes.i64 then
					local v1675

					v1675, n104 = proto.readFixed64(p158, n104)
				else
					error("Unsupported wire type: " .. v1669)
				end
			end

			return v1666
		end
		function t208.jsonEncode(p159) -- line: 13374
			local t210 = {}

			if p159.subcategory_id ~= nil then
				t210.subcategoryId = p159.subcategory_id:jsonEncode()
			end

			return t210
		end
		function t208.jsonDecode(t211: {[any]: any}) -- line: 13386
			-- upvalues: t208 (copy), prop_types (copy)
			local v1679 = t208.new()

			if t211.subcategory_id ~= nil then
				v1679.subcategory_id = prop_types.StringProp.jsonDecode(t211.subcategory_id)
			end

			if t211.subcategoryId ~= nil then
				v1679.subcategory_id = prop_types.StringProp.jsonDecode(t211.subcategoryId)
			end

			return v1679
		end

		t208.descriptor = {
			name = "SelectMarketplaceCatalogSubcategory_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.SelectMarketplaceCatalogSubcategory_Params = t208
		typeRegistry.default:register(t1.SelectMarketplaceCatalogSubcategory_Params)

		local t212 = {}

		t212.__index = t212

		function t212.new(t213: {[any]: any}?) -- line: 13418
			-- upvalues: t1 (copy), t212 (copy)
			return (setmetatable({
				action_type = if t213 ~= nil and t213.action_type ~= nil then t213.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t213 ~= nil and t213.action_params ~= nil then t213.action_params else nil
			}, t212))
		end
		function t212.encode(p160) -- line: 13429
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n105 = 0

			if p160.action_type ~= nil and (p160.action_type ~= nil and p160.action_type ~= 0 or p160.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1684, v1685 = proto.writeTag(buf, n105, 1, proto.wireTypes.varint)

				buf, n105 = proto.writeVarInt(v1684, v1685, t1.ActionType.toNumber(p160.action_type))
			end

			if p160.action_params ~= nil then
				local v1686 = p160.action_params:encode()
				local v1687, v1688 = proto.writeTag(buf, n105, 2, proto.wireTypes.lengthDelimited)

				buf, n105 = proto.writeBuffer(v1687, v1688, v1686, buffer.len(v1686))
			end

			local buf55 = buffer.create(n105)

			buffer.copy(buf55, 0, buf, 0, n105)

			return buf55
		end
		function t212.decode(p161: buffer) -- line: 13455
			-- upvalues: t212 (copy), proto (copy), t1 (copy)
			local v1691 = t212.new()
			local n106 = 0

			while n106 < buffer.len(p161) do
				local v1693, v1694

				v1693, v1694, n106 = proto.readTag(p161, n106)

				if v1694 == proto.wireTypes.varint then
					if v1693 == 1 then
						local v1695

						v1695, n106 = proto.readVarIntI32(p161, n106)
						v1691.action_type = t1.ActionType.fromNumber(v1695) or v1695
					else
						local v1696

						v1696, n106 = proto.readVarInt(p161, n106)
					end
				elseif v1694 == proto.wireTypes.lengthDelimited then
					if v1693 == 2 then
						local v1697

						v1697, n106 = proto.readBuffer(p161, n106)
						v1691.action_params = t1.OpenMarketplaceCatalogSeeAll_Params.decode(v1697)
					else
						local v1698, v1699 = proto.readVarInt(p161, n106)

						n106 = v1699 + v1698
					end
				elseif v1694 == proto.wireTypes.i32 then
					local v1700

					v1700, n106 = proto.readFixed32(p161, n106)
				elseif v1694 == proto.wireTypes.i64 then
					local v1701

					v1701, n106 = proto.readFixed64(p161, n106)
				else
					error("Unsupported wire type: " .. v1694)
				end
			end

			return v1691
		end
		function t212.jsonEncode(p162) -- line: 13503
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
		function t212.jsonDecode(t215: {[any]: any}) -- line: 13525
			-- upvalues: t212 (copy), t1 (copy)
			local v1705 = t212.new()

			if t215.action_type ~= nil then
				v1705.action_type = if typeof(t215.action_type) ~= "number" then t1.ActionType.fromName(t215.action_type) or t215.action_type else t1.ActionType.fromNumber(t215.action_type) or t215.action_type
			end

			if t215.actionType ~= nil then
				v1705.action_type = if typeof(t215.actionType) ~= "number" then t1.ActionType.fromName(t215.actionType) or t215.actionType else t1.ActionType.fromNumber(t215.actionType) or t215.actionType
			end

			if t215.action_params ~= nil then
				v1705.action_params = t1.OpenMarketplaceCatalogSeeAll_Params.jsonDecode(t215.action_params)
			end

			if t215.actionParams ~= nil then
				v1705.action_params = t1.OpenMarketplaceCatalogSeeAll_Params.jsonDecode(t215.actionParams)
			end

			return v1705
		end

		t212.descriptor = {
			name = "OpenMarketplaceCatalogSeeAll",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenMarketplaceCatalogSeeAll"
		}
		t1.OpenMarketplaceCatalogSeeAll = t212
	end

	typeRegistry.default:register(t1.OpenMarketplaceCatalogSeeAll)

	do
		local t216 = {}

		t216.__index = t216

		function t216.new(t217: {[any]: any}?) -- line: 13565
			-- upvalues: t216 (copy)
			return (setmetatable({
				sort_id = if t217 ~= nil and t217.sort_id ~= nil then t217.sort_id else nil,
				title = if t217 ~= nil and t217.title ~= nil then t217.title else nil,
				description = if t217 ~= nil and t217.description ~= nil then t217.description else nil,
				tooltip_text = if t217 ~= nil and t217.tooltip_text ~= nil then t217.tooltip_text else nil
			}, t216))
		end
		function t216.encode(p163) -- line: 13576
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n107 = 0

			if p163.sort_id ~= nil then
				local v1710 = p163.sort_id:encode()
				local v1711, v1712 = proto.writeTag(buf, n107, 1, proto.wireTypes.lengthDelimited)

				buf, n107 = proto.writeBuffer(v1711, v1712, v1710, buffer.len(v1710))
			end

			if p163.title ~= nil then
				local v1713 = p163.title:encode()
				local v1714, v1715 = proto.writeTag(buf, n107, 2, proto.wireTypes.lengthDelimited)

				buf, n107 = proto.writeBuffer(v1714, v1715, v1713, buffer.len(v1713))
			end

			if p163.description ~= nil then
				local v1716 = p163.description:encode()
				local v1717, v1718 = proto.writeTag(buf, n107, 3, proto.wireTypes.lengthDelimited)

				buf, n107 = proto.writeBuffer(v1717, v1718, v1716, buffer.len(v1716))
			end

			if p163.tooltip_text ~= nil then
				local v1719 = p163.tooltip_text:encode()
				local v1720, v1721 = proto.writeTag(buf, n107, 4, proto.wireTypes.lengthDelimited)

				buf, n107 = proto.writeBuffer(v1720, v1721, v1719, buffer.len(v1719))
			end

			local buf56 = buffer.create(n107)

			buffer.copy(buf56, 0, buf, 0, n107)

			return buf56
		end
		function t216.decode(p164: buffer) -- line: 13609
			-- upvalues: t216 (copy), proto (copy), prop_types (copy)
			local v1724 = t216.new()
			local n108 = 0

			while n108 < buffer.len(p164) do
				local v1726, v1727

				v1726, v1727, n108 = proto.readTag(p164, n108)

				if v1727 == proto.wireTypes.varint then
					local v1728

					v1728, n108 = proto.readVarInt(p164, n108)
				elseif v1727 == proto.wireTypes.lengthDelimited then
					if v1726 == 1 then
						local v1729

						v1729, n108 = proto.readBuffer(p164, n108)
						v1724.sort_id = prop_types.StringProp.decode(v1729)
					elseif v1726 == 2 then
						local v1730

						v1730, n108 = proto.readBuffer(p164, n108)
						v1724.title = prop_types.StringProp.decode(v1730)
					elseif v1726 == 3 then
						local v1731

						v1731, n108 = proto.readBuffer(p164, n108)
						v1724.description = prop_types.StringProp.decode(v1731)
					elseif v1726 == 4 then
						local v1732

						v1732, n108 = proto.readBuffer(p164, n108)
						v1724.tooltip_text = prop_types.StringProp.decode(v1732)
					else
						local v1733, v1734 = proto.readVarInt(p164, n108)

						n108 = v1734 + v1733
					end
				elseif v1727 == proto.wireTypes.i32 then
					local v1735

					v1735, n108 = proto.readFixed32(p164, n108)
				elseif v1727 == proto.wireTypes.i64 then
					local v1736

					v1736, n108 = proto.readFixed64(p164, n108)
				else
					error("Unsupported wire type: " .. v1727)
				end
			end

			return v1724
		end
		function t216.jsonEncode(p165) -- line: 13667
			local t218 = {}

			if p165.sort_id ~= nil then
				t218.sortId = p165.sort_id:jsonEncode()
			end

			if p165.title ~= nil then
				t218.title = p165.title:jsonEncode()
			end

			if p165.description ~= nil then
				t218.description = p165.description:jsonEncode()
			end

			if p165.tooltip_text ~= nil then
				t218.tooltipText = p165.tooltip_text:jsonEncode()
			end

			return t218
		end
		function t216.jsonDecode(t219: {[any]: any}) -- line: 13689
			-- upvalues: t216 (copy), prop_types (copy)
			local v1740 = t216.new()

			if t219.sort_id ~= nil then
				v1740.sort_id = prop_types.StringProp.jsonDecode(t219.sort_id)
			end

			if t219.sortId ~= nil then
				v1740.sort_id = prop_types.StringProp.jsonDecode(t219.sortId)
			end

			if t219.title ~= nil then
				v1740.title = prop_types.StringProp.jsonDecode(t219.title)
			end

			if t219.description ~= nil then
				v1740.description = prop_types.StringProp.jsonDecode(t219.description)
			end

			if t219.tooltip_text ~= nil then
				v1740.tooltip_text = prop_types.StringProp.jsonDecode(t219.tooltip_text)
			end

			if t219.tooltipText ~= nil then
				v1740.tooltip_text = prop_types.StringProp.jsonDecode(t219.tooltipText)
			end

			return v1740
		end

		t216.descriptor = {
			name = "OpenMarketplaceCatalogSeeAll_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenMarketplaceCatalogSeeAll_Params = t216
		typeRegistry.default:register(t1.OpenMarketplaceCatalogSeeAll_Params)

		local t220 = {}

		t220.__index = t220

		function t220.new(t221: {[any]: any}?) -- line: 13738
			-- upvalues: t1 (copy), t220 (copy)
			return (setmetatable({
				action_type = if t221 ~= nil and t221.action_type ~= nil then t221.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t221 ~= nil and t221.action_params ~= nil then t221.action_params else nil
			}, t220))
		end
		function t220.encode(p166) -- line: 13749
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n109 = 0

			if p166.action_type ~= nil and (p166.action_type ~= nil and p166.action_type ~= 0 or p166.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1745, v1746 = proto.writeTag(buf, n109, 1, proto.wireTypes.varint)

				buf, n109 = proto.writeVarInt(v1745, v1746, t1.ActionType.toNumber(p166.action_type))
			end

			if p166.action_params ~= nil then
				local v1747 = p166.action_params:encode()
				local v1748, v1749 = proto.writeTag(buf, n109, 2, proto.wireTypes.lengthDelimited)

				buf, n109 = proto.writeBuffer(v1748, v1749, v1747, buffer.len(v1747))
			end

			local buf57 = buffer.create(n109)

			buffer.copy(buf57, 0, buf, 0, n109)

			return buf57
		end
		function t220.decode(p167: buffer) -- line: 13775
			-- upvalues: t220 (copy), proto (copy), t1 (copy)
			local v1752 = t220.new()
			local n110 = 0

			while n110 < buffer.len(p167) do
				local v1754, v1755

				v1754, v1755, n110 = proto.readTag(p167, n110)

				if v1755 == proto.wireTypes.varint then
					if v1754 == 1 then
						local v1756

						v1756, n110 = proto.readVarIntI32(p167, n110)
						v1752.action_type = t1.ActionType.fromNumber(v1756) or v1756
					else
						local v1757

						v1757, n110 = proto.readVarInt(p167, n110)
					end
				elseif v1755 == proto.wireTypes.lengthDelimited then
					if v1754 == 2 then
						local v1758

						v1758, n110 = proto.readBuffer(p167, n110)
						v1752.action_params = t1.CloseMarketplaceCategoryTooltip_Params.decode(v1758)
					else
						local v1759, v1760 = proto.readVarInt(p167, n110)

						n110 = v1760 + v1759
					end
				elseif v1755 == proto.wireTypes.i32 then
					local v1761

					v1761, n110 = proto.readFixed32(p167, n110)
				elseif v1755 == proto.wireTypes.i64 then
					local v1762

					v1762, n110 = proto.readFixed64(p167, n110)
				else
					error("Unsupported wire type: " .. v1755)
				end
			end

			return v1752
		end
		function t220.jsonEncode(p168) -- line: 13823
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
		function t220.jsonDecode(t223: {[any]: any}) -- line: 13845
			-- upvalues: t220 (copy), t1 (copy)
			local v1766 = t220.new()

			if t223.action_type ~= nil then
				v1766.action_type = if typeof(t223.action_type) ~= "number" then t1.ActionType.fromName(t223.action_type) or t223.action_type else t1.ActionType.fromNumber(t223.action_type) or t223.action_type
			end

			if t223.actionType ~= nil then
				v1766.action_type = if typeof(t223.actionType) ~= "number" then t1.ActionType.fromName(t223.actionType) or t223.actionType else t1.ActionType.fromNumber(t223.actionType) or t223.actionType
			end

			if t223.action_params ~= nil then
				v1766.action_params = t1.CloseMarketplaceCategoryTooltip_Params.jsonDecode(t223.action_params)
			end

			if t223.actionParams ~= nil then
				v1766.action_params = t1.CloseMarketplaceCategoryTooltip_Params.jsonDecode(t223.actionParams)
			end

			return v1766
		end

		t220.descriptor = {
			name = "CloseMarketplaceCategoryTooltip",
			fullName = "roblox.apppageplatform.shared.v1beta1.CloseMarketplaceCategoryTooltip"
		}
		t1.CloseMarketplaceCategoryTooltip = t220
	end

	typeRegistry.default:register(t1.CloseMarketplaceCategoryTooltip)

	do
		local t224 = {}

		t224.__index = t224

		function t224.new(t225: {[any]: any}?) -- line: 13885
			-- upvalues: t224 (copy)
			return (setmetatable({
				tooltip_id = if t225 ~= nil and t225.tooltip_id ~= nil then t225.tooltip_id else nil
			}, t224))
		end
		function t224.encode(p169) -- line: 13893
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n111 = 0

			if p169.tooltip_id ~= nil then
				local v1771 = p169.tooltip_id:encode()
				local v1772, v1773 = proto.writeTag(buf, n111, 1, proto.wireTypes.lengthDelimited)

				buf, n111 = proto.writeBuffer(v1772, v1773, v1771, buffer.len(v1771))
			end

			local buf58 = buffer.create(n111)

			buffer.copy(buf58, 0, buf, 0, n111)

			return buf58
		end
		function t224.decode(p170: buffer) -- line: 13908
			-- upvalues: t224 (copy), proto (copy), prop_types (copy)
			local v1776 = t224.new()
			local n112 = 0

			while n112 < buffer.len(p170) do
				local v1778, v1779

				v1778, v1779, n112 = proto.readTag(p170, n112)

				if v1779 == proto.wireTypes.varint then
					local v1780

					v1780, n112 = proto.readVarInt(p170, n112)
				elseif v1779 == proto.wireTypes.lengthDelimited then
					if v1778 == 1 then
						local v1781

						v1781, n112 = proto.readBuffer(p170, n112)
						v1776.tooltip_id = prop_types.StringProp.decode(v1781)
					else
						local v1782, v1783 = proto.readVarInt(p170, n112)

						n112 = v1783 + v1782
					end
				elseif v1779 == proto.wireTypes.i32 then
					local v1784

					v1784, n112 = proto.readFixed32(p170, n112)
				elseif v1779 == proto.wireTypes.i64 then
					local v1785

					v1785, n112 = proto.readFixed64(p170, n112)
				else
					error("Unsupported wire type: " .. v1779)
				end
			end

			return v1776
		end
		function t224.jsonEncode(p171) -- line: 13951
			local t226 = {}

			if p171.tooltip_id ~= nil then
				t226.tooltipId = p171.tooltip_id:jsonEncode()
			end

			return t226
		end
		function t224.jsonDecode(t227: {[any]: any}) -- line: 13961
			-- upvalues: t224 (copy), prop_types (copy)
			local v1789 = t224.new()

			if t227.tooltip_id ~= nil then
				v1789.tooltip_id = prop_types.StringProp.jsonDecode(t227.tooltip_id)
			end

			if t227.tooltipId ~= nil then
				v1789.tooltip_id = prop_types.StringProp.jsonDecode(t227.tooltipId)
			end

			return v1789
		end

		t224.descriptor = {
			name = "CloseMarketplaceCategoryTooltip_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.CloseMarketplaceCategoryTooltip_Params = t224
		typeRegistry.default:register(t1.CloseMarketplaceCategoryTooltip_Params)

		local t228 = {}

		t228.__index = t228

		function t228.new(t229: {[any]: any}?) -- line: 13991
			-- upvalues: t1 (copy), t228 (copy)
			return (setmetatable({
				action_type = if t229 ~= nil and t229.action_type ~= nil then t229.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t229 ~= nil and t229.action_params ~= nil then t229.action_params else nil
			}, t228))
		end
		function t228.encode(p172) -- line: 14000
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n113 = 0

			if p172.action_type ~= nil and (p172.action_type ~= nil and p172.action_type ~= 0 or p172.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1794, v1795 = proto.writeTag(buf, n113, 1, proto.wireTypes.varint)

				buf, n113 = proto.writeVarInt(v1794, v1795, t1.ActionType.toNumber(p172.action_type))
			end

			if p172.action_params ~= nil then
				local v1796 = p172.action_params:encode()
				local v1797, v1798 = proto.writeTag(buf, n113, 2, proto.wireTypes.lengthDelimited)

				buf, n113 = proto.writeBuffer(v1797, v1798, v1796, buffer.len(v1796))
			end

			local buf59 = buffer.create(n113)

			buffer.copy(buf59, 0, buf, 0, n113)

			return buf59
		end
		function t228.decode(p173: buffer) -- line: 14026
			-- upvalues: t228 (copy), proto (copy), t1 (copy)
			local v1801 = t228.new()
			local n114 = 0

			while n114 < buffer.len(p173) do
				local v1803, v1804

				v1803, v1804, n114 = proto.readTag(p173, n114)

				if v1804 == proto.wireTypes.varint then
					if v1803 == 1 then
						local v1805

						v1805, n114 = proto.readVarIntI32(p173, n114)
						v1801.action_type = t1.ActionType.fromNumber(v1805) or v1805
					else
						local v1806

						v1806, n114 = proto.readVarInt(p173, n114)
					end
				elseif v1804 == proto.wireTypes.lengthDelimited then
					if v1803 == 2 then
						local v1807

						v1807, n114 = proto.readBuffer(p173, n114)
						v1801.action_params = t1.ResizeMarketplaceCatalog_Params.decode(v1807)
					else
						local v1808, v1809 = proto.readVarInt(p173, n114)

						n114 = v1809 + v1808
					end
				elseif v1804 == proto.wireTypes.i32 then
					local v1810

					v1810, n114 = proto.readFixed32(p173, n114)
				elseif v1804 == proto.wireTypes.i64 then
					local v1811

					v1811, n114 = proto.readFixed64(p173, n114)
				else
					error("Unsupported wire type: " .. v1804)
				end
			end

			return v1801
		end
		function t228.jsonEncode(p174) -- line: 14074
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
		function t228.jsonDecode(t231: {[any]: any}) -- line: 14096
			-- upvalues: t228 (copy), t1 (copy)
			local v1815 = t228.new()

			if t231.action_type ~= nil then
				v1815.action_type = if typeof(t231.action_type) ~= "number" then t1.ActionType.fromName(t231.action_type) or t231.action_type else t1.ActionType.fromNumber(t231.action_type) or t231.action_type
			end

			if t231.actionType ~= nil then
				v1815.action_type = if typeof(t231.actionType) ~= "number" then t1.ActionType.fromName(t231.actionType) or t231.actionType else t1.ActionType.fromNumber(t231.actionType) or t231.actionType
			end

			if t231.action_params ~= nil then
				v1815.action_params = t1.ResizeMarketplaceCatalog_Params.jsonDecode(t231.action_params)
			end

			if t231.actionParams ~= nil then
				v1815.action_params = t1.ResizeMarketplaceCatalog_Params.jsonDecode(t231.actionParams)
			end

			return v1815
		end

		t228.descriptor = {
			name = "ResizeMarketplaceCatalog",
			fullName = "roblox.apppageplatform.shared.v1beta1.ResizeMarketplaceCatalog"
		}
		t1.ResizeMarketplaceCatalog = t228
	end

	typeRegistry.default:register(t1.ResizeMarketplaceCatalog)

	do
		local t232 = {}

		t232.__index = t232

		function t232.new(t233: {[any]: any}?) -- line: 14136
			-- upvalues: t232 (copy)
			return (setmetatable({
				category_id = if t233 ~= nil and t233.category_id ~= nil then t233.category_id else nil,
				subcategory_id = if t233 ~= nil and t233.subcategory_id ~= nil then t233.subcategory_id else nil,
				screen_size = if t233 ~= nil and t233.screen_size ~= nil then t233.screen_size else nil
			}, t232))
		end
		function t232.encode(p175) -- line: 14146
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n115 = 0

			if p175.category_id ~= nil then
				local v1820 = p175.category_id:encode()
				local v1821, v1822 = proto.writeTag(buf, n115, 1, proto.wireTypes.lengthDelimited)

				buf, n115 = proto.writeBuffer(v1821, v1822, v1820, buffer.len(v1820))
			end

			if p175.subcategory_id ~= nil then
				local v1823 = p175.subcategory_id:encode()
				local v1824, v1825 = proto.writeTag(buf, n115, 2, proto.wireTypes.lengthDelimited)

				buf, n115 = proto.writeBuffer(v1824, v1825, v1823, buffer.len(v1823))
			end

			if p175.screen_size ~= nil then
				local v1826 = p175.screen_size:encode()
				local v1827, v1828 = proto.writeTag(buf, n115, 3, proto.wireTypes.lengthDelimited)

				buf, n115 = proto.writeBuffer(v1827, v1828, v1826, buffer.len(v1826))
			end

			local buf60 = buffer.create(n115)

			buffer.copy(buf60, 0, buf, 0, n115)

			return buf60
		end
		function t232.decode(p176: buffer) -- line: 14173
			-- upvalues: t232 (copy), proto (copy), prop_types (copy)
			local v1831 = t232.new()
			local n116 = 0

			while n116 < buffer.len(p176) do
				local v1833, v1834

				v1833, v1834, n116 = proto.readTag(p176, n116)

				if v1834 == proto.wireTypes.varint then
					local v1835

					v1835, n116 = proto.readVarInt(p176, n116)
				elseif v1834 == proto.wireTypes.lengthDelimited then
					if v1833 == 1 then
						local v1836

						v1836, n116 = proto.readBuffer(p176, n116)
						v1831.category_id = prop_types.StringProp.decode(v1836)
					elseif v1833 == 2 then
						local v1837

						v1837, n116 = proto.readBuffer(p176, n116)
						v1831.subcategory_id = prop_types.StringProp.decode(v1837)
					elseif v1833 == 3 then
						local v1838

						v1838, n116 = proto.readBuffer(p176, n116)
						v1831.screen_size = prop_types.StringProp.decode(v1838)
					else
						local v1839, v1840 = proto.readVarInt(p176, n116)

						n116 = v1840 + v1839
					end
				elseif v1834 == proto.wireTypes.i32 then
					local v1841

					v1841, n116 = proto.readFixed32(p176, n116)
				elseif v1834 == proto.wireTypes.i64 then
					local v1842

					v1842, n116 = proto.readFixed64(p176, n116)
				else
					error("Unsupported wire type: " .. v1834)
				end
			end

			return v1831
		end
		function t232.jsonEncode(p177) -- line: 14226
			local t234 = {}

			if p177.category_id ~= nil then
				t234.categoryId = p177.category_id:jsonEncode()
			end

			if p177.subcategory_id ~= nil then
				t234.subcategoryId = p177.subcategory_id:jsonEncode()
			end

			if p177.screen_size ~= nil then
				t234.screenSize = p177.screen_size:jsonEncode()
			end

			return t234
		end
		function t232.jsonDecode(t235: {[any]: any}) -- line: 14244
			-- upvalues: t232 (copy), prop_types (copy)
			local v1846 = t232.new()

			if t235.category_id ~= nil then
				v1846.category_id = prop_types.StringProp.jsonDecode(t235.category_id)
			end

			if t235.categoryId ~= nil then
				v1846.category_id = prop_types.StringProp.jsonDecode(t235.categoryId)
			end

			if t235.subcategory_id ~= nil then
				v1846.subcategory_id = prop_types.StringProp.jsonDecode(t235.subcategory_id)
			end

			if t235.subcategoryId ~= nil then
				v1846.subcategory_id = prop_types.StringProp.jsonDecode(t235.subcategoryId)
			end

			if t235.screen_size ~= nil then
				v1846.screen_size = prop_types.StringProp.jsonDecode(t235.screen_size)
			end

			if t235.screenSize ~= nil then
				v1846.screen_size = prop_types.StringProp.jsonDecode(t235.screenSize)
			end

			return v1846
		end

		t232.descriptor = {
			name = "ResizeMarketplaceCatalog_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.ResizeMarketplaceCatalog_Params = t232
		typeRegistry.default:register(t1.ResizeMarketplaceCatalog_Params)

		local t236 = {}

		t236.__index = t236

		function t236.new(t237: {[any]: any}?) -- line: 14292
			-- upvalues: t1 (copy), t236 (copy)
			return (setmetatable({
				action_type = if t237 ~= nil and t237.action_type ~= nil then t237.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t237 ~= nil and t237.action_params ~= nil then t237.action_params else nil
			}, t236))
		end
		function t236.encode(p178) -- line: 14303
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n117 = 0

			if p178.action_type ~= nil and (p178.action_type ~= nil and p178.action_type ~= 0 or p178.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1851, v1852 = proto.writeTag(buf, n117, 1, proto.wireTypes.varint)

				buf, n117 = proto.writeVarInt(v1851, v1852, t1.ActionType.toNumber(p178.action_type))
			end

			if p178.action_params ~= nil then
				local v1853 = p178.action_params:encode()
				local v1854, v1855 = proto.writeTag(buf, n117, 2, proto.wireTypes.lengthDelimited)

				buf, n117 = proto.writeBuffer(v1854, v1855, v1853, buffer.len(v1853))
			end

			local buf61 = buffer.create(n117)

			buffer.copy(buf61, 0, buf, 0, n117)

			return buf61
		end
		function t236.decode(p179: buffer) -- line: 14329
			-- upvalues: t236 (copy), proto (copy), t1 (copy)
			local v1858 = t236.new()
			local n118 = 0

			while n118 < buffer.len(p179) do
				local v1860, v1861

				v1860, v1861, n118 = proto.readTag(p179, n118)

				if v1861 == proto.wireTypes.varint then
					if v1860 == 1 then
						local v1862

						v1862, n118 = proto.readVarIntI32(p179, n118)
						v1858.action_type = t1.ActionType.fromNumber(v1862) or v1862
					else
						local v1863

						v1863, n118 = proto.readVarInt(p179, n118)
					end
				elseif v1861 == proto.wireTypes.lengthDelimited then
					if v1860 == 2 then
						local v1864

						v1864, n118 = proto.readBuffer(p179, n118)
						v1858.action_params = t1.OpenChartsSortDetailAction_Params.decode(v1864)
					else
						local v1865, v1866 = proto.readVarInt(p179, n118)

						n118 = v1866 + v1865
					end
				elseif v1861 == proto.wireTypes.i32 then
					local v1867

					v1867, n118 = proto.readFixed32(p179, n118)
				elseif v1861 == proto.wireTypes.i64 then
					local v1868

					v1868, n118 = proto.readFixed64(p179, n118)
				else
					error("Unsupported wire type: " .. v1861)
				end
			end

			return v1858
		end
		function t236.jsonEncode(p180) -- line: 14377
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
		function t236.jsonDecode(t239: {[any]: any}) -- line: 14399
			-- upvalues: t236 (copy), t1 (copy)
			local v1872 = t236.new()

			if t239.action_type ~= nil then
				v1872.action_type = if typeof(t239.action_type) ~= "number" then t1.ActionType.fromName(t239.action_type) or t239.action_type else t1.ActionType.fromNumber(t239.action_type) or t239.action_type
			end

			if t239.actionType ~= nil then
				v1872.action_type = if typeof(t239.actionType) ~= "number" then t1.ActionType.fromName(t239.actionType) or t239.actionType else t1.ActionType.fromNumber(t239.actionType) or t239.actionType
			end

			if t239.action_params ~= nil then
				v1872.action_params = t1.OpenChartsSortDetailAction_Params.jsonDecode(t239.action_params)
			end

			if t239.actionParams ~= nil then
				v1872.action_params = t1.OpenChartsSortDetailAction_Params.jsonDecode(t239.actionParams)
			end

			return v1872
		end

		t236.descriptor = {
			name = "OpenChartsSortDetailAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenChartsSortDetailAction"
		}
		t1.OpenChartsSortDetailAction = t236
	end

	typeRegistry.default:register(t1.OpenChartsSortDetailAction)

	do
		local t240 = {}

		t240.__index = t240

		function t240.new(t241: {[any]: any}?) -- line: 14439
			-- upvalues: t240 (copy)
			return (setmetatable({
				sort_id = if t241 ~= nil and t241.sort_id ~= nil then t241.sort_id else nil,
				secondary_sort_id = if t241 ~= nil and t241.secondary_sort_id ~= nil then t241.secondary_sort_id else nil
			}, t240))
		end
		function t240.encode(p181) -- line: 14448
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n119 = 0

			if p181.sort_id ~= nil then
				local v1877 = p181.sort_id:encode()
				local v1878, v1879 = proto.writeTag(buf, n119, 1, proto.wireTypes.lengthDelimited)

				buf, n119 = proto.writeBuffer(v1878, v1879, v1877, buffer.len(v1877))
			end

			if p181.secondary_sort_id ~= nil then
				local v1880 = p181.secondary_sort_id:encode()
				local v1881, v1882 = proto.writeTag(buf, n119, 2, proto.wireTypes.lengthDelimited)

				buf, n119 = proto.writeBuffer(v1881, v1882, v1880, buffer.len(v1880))
			end

			local buf62 = buffer.create(n119)

			buffer.copy(buf62, 0, buf, 0, n119)

			return buf62
		end
		function t240.decode(p182: buffer) -- line: 14469
			-- upvalues: t240 (copy), proto (copy), prop_types (copy)
			local v1885 = t240.new()
			local n120 = 0

			while n120 < buffer.len(p182) do
				local v1887, v1888

				v1887, v1888, n120 = proto.readTag(p182, n120)

				if v1888 == proto.wireTypes.varint then
					local v1889

					v1889, n120 = proto.readVarInt(p182, n120)
				elseif v1888 == proto.wireTypes.lengthDelimited then
					if v1887 == 1 then
						local v1890

						v1890, n120 = proto.readBuffer(p182, n120)
						v1885.sort_id = prop_types.StringProp.decode(v1890)
					elseif v1887 == 2 then
						local v1891

						v1891, n120 = proto.readBuffer(p182, n120)
						v1885.secondary_sort_id = prop_types.Int32Prop.decode(v1891)
					else
						local v1892, v1893 = proto.readVarInt(p182, n120)

						n120 = v1893 + v1892
					end
				elseif v1888 == proto.wireTypes.i32 then
					local v1894

					v1894, n120 = proto.readFixed32(p182, n120)
				elseif v1888 == proto.wireTypes.i64 then
					local v1895

					v1895, n120 = proto.readFixed64(p182, n120)
				else
					error("Unsupported wire type: " .. v1888)
				end
			end

			return v1885
		end
		function t240.jsonEncode(p183) -- line: 14517
			local t242 = {}

			if p183.sort_id ~= nil then
				t242.sortId = p183.sort_id:jsonEncode()
			end

			if p183.secondary_sort_id ~= nil then
				t242.secondarySortId = p183.secondary_sort_id:jsonEncode()
			end

			return t242
		end
		function t240.jsonDecode(t243: {[any]: any}) -- line: 14531
			-- upvalues: t240 (copy), prop_types (copy)
			local v1899 = t240.new()

			if t243.sort_id ~= nil then
				v1899.sort_id = prop_types.StringProp.jsonDecode(t243.sort_id)
			end

			if t243.sortId ~= nil then
				v1899.sort_id = prop_types.StringProp.jsonDecode(t243.sortId)
			end

			if t243.secondary_sort_id ~= nil then
				v1899.secondary_sort_id = prop_types.Int32Prop.jsonDecode(t243.secondary_sort_id)
			end

			if t243.secondarySortId ~= nil then
				v1899.secondary_sort_id = prop_types.Int32Prop.jsonDecode(t243.secondarySortId)
			end

			return v1899
		end

		t240.descriptor = {
			name = "OpenChartsSortDetailAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenChartsSortDetailAction_Params = t240
		typeRegistry.default:register(t1.OpenChartsSortDetailAction_Params)

		local t244 = {}

		t244.__index = t244

		function t244.new(t245: {[any]: any}?) -- line: 14571
			-- upvalues: t1 (copy), t244 (copy)
			return (setmetatable({
				action_type = if t245 ~= nil and t245.action_type ~= nil then t245.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t245 ~= nil and t245.action_params ~= nil then t245.action_params else nil
			}, t244))
		end
		function t244.encode(p184) -- line: 14580
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n121 = 0

			if p184.action_type ~= nil and (p184.action_type ~= nil and p184.action_type ~= 0 or p184.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1904, v1905 = proto.writeTag(buf, n121, 1, proto.wireTypes.varint)

				buf, n121 = proto.writeVarInt(v1904, v1905, t1.ActionType.toNumber(p184.action_type))
			end

			if p184.action_params ~= nil then
				local v1906 = p184.action_params:encode()
				local v1907, v1908 = proto.writeTag(buf, n121, 2, proto.wireTypes.lengthDelimited)

				buf, n121 = proto.writeBuffer(v1907, v1908, v1906, buffer.len(v1906))
			end

			local buf63 = buffer.create(n121)

			buffer.copy(buf63, 0, buf, 0, n121)

			return buf63
		end
		function t244.decode(p185: buffer) -- line: 14606
			-- upvalues: t244 (copy), proto (copy), t1 (copy)
			local v1911 = t244.new()
			local n122 = 0

			while n122 < buffer.len(p185) do
				local v1913, v1914

				v1913, v1914, n122 = proto.readTag(p185, n122)

				if v1914 == proto.wireTypes.varint then
					if v1913 == 1 then
						local v1915

						v1915, n122 = proto.readVarIntI32(p185, n122)
						v1911.action_type = t1.ActionType.fromNumber(v1915) or v1915
					else
						local v1916

						v1916, n122 = proto.readVarInt(p185, n122)
					end
				elseif v1914 == proto.wireTypes.lengthDelimited then
					if v1913 == 2 then
						local v1917

						v1917, n122 = proto.readBuffer(p185, n122)
						v1911.action_params = t1.OpenSongDetailAction_Params.decode(v1917)
					else
						local v1918, v1919 = proto.readVarInt(p185, n122)

						n122 = v1919 + v1918
					end
				elseif v1914 == proto.wireTypes.i32 then
					local v1920

					v1920, n122 = proto.readFixed32(p185, n122)
				elseif v1914 == proto.wireTypes.i64 then
					local v1921

					v1921, n122 = proto.readFixed64(p185, n122)
				else
					error("Unsupported wire type: " .. v1914)
				end
			end

			return v1911
		end
		function t244.jsonEncode(p186) -- line: 14654
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
		function t244.jsonDecode(t247: {[any]: any}) -- line: 14676
			-- upvalues: t244 (copy), t1 (copy)
			local v1925 = t244.new()

			if t247.action_type ~= nil then
				v1925.action_type = if typeof(t247.action_type) ~= "number" then t1.ActionType.fromName(t247.action_type) or t247.action_type else t1.ActionType.fromNumber(t247.action_type) or t247.action_type
			end

			if t247.actionType ~= nil then
				v1925.action_type = if typeof(t247.actionType) ~= "number" then t1.ActionType.fromName(t247.actionType) or t247.actionType else t1.ActionType.fromNumber(t247.actionType) or t247.actionType
			end

			if t247.action_params ~= nil then
				v1925.action_params = t1.OpenSongDetailAction_Params.jsonDecode(t247.action_params)
			end

			if t247.actionParams ~= nil then
				v1925.action_params = t1.OpenSongDetailAction_Params.jsonDecode(t247.actionParams)
			end

			return v1925
		end

		t244.descriptor = {
			name = "OpenSongDetailAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenSongDetailAction"
		}
		t1.OpenSongDetailAction = t244
	end

	typeRegistry.default:register(t1.OpenSongDetailAction)

	do
		local t248 = {}

		t248.__index = t248

		function t248.new(t249: {[any]: any}?) -- line: 14716
			-- upvalues: t248 (copy)
			return (setmetatable({
				song_id = if t249 ~= nil and t249.song_id ~= nil then t249.song_id else nil
			}, t248))
		end
		function t248.encode(p187) -- line: 14724
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n123 = 0

			if p187.song_id ~= nil then
				local v1930 = p187.song_id:encode()
				local v1931, v1932 = proto.writeTag(buf, n123, 1, proto.wireTypes.lengthDelimited)

				buf, n123 = proto.writeBuffer(v1931, v1932, v1930, buffer.len(v1930))
			end

			local buf64 = buffer.create(n123)

			buffer.copy(buf64, 0, buf, 0, n123)

			return buf64
		end
		function t248.decode(p188: buffer) -- line: 14739
			-- upvalues: t248 (copy), proto (copy), prop_types (copy)
			local v1935 = t248.new()
			local n124 = 0

			while n124 < buffer.len(p188) do
				local v1937, v1938

				v1937, v1938, n124 = proto.readTag(p188, n124)

				if v1938 == proto.wireTypes.varint then
					local v1939

					v1939, n124 = proto.readVarInt(p188, n124)
				elseif v1938 == proto.wireTypes.lengthDelimited then
					if v1937 == 1 then
						local v1940

						v1940, n124 = proto.readBuffer(p188, n124)
						v1935.song_id = prop_types.StringProp.decode(v1940)
					else
						local v1941, v1942 = proto.readVarInt(p188, n124)

						n124 = v1942 + v1941
					end
				elseif v1938 == proto.wireTypes.i32 then
					local v1943

					v1943, n124 = proto.readFixed32(p188, n124)
				elseif v1938 == proto.wireTypes.i64 then
					local v1944

					v1944, n124 = proto.readFixed64(p188, n124)
				else
					error("Unsupported wire type: " .. v1938)
				end
			end

			return v1935
		end
		function t248.jsonEncode(p189) -- line: 14782
			local t250 = {}

			if p189.song_id ~= nil then
				t250.songId = p189.song_id:jsonEncode()
			end

			return t250
		end
		function t248.jsonDecode(t251: {[any]: any}) -- line: 14792
			-- upvalues: t248 (copy), prop_types (copy)
			local v1948 = t248.new()

			if t251.song_id ~= nil then
				v1948.song_id = prop_types.StringProp.jsonDecode(t251.song_id)
			end

			if t251.songId ~= nil then
				v1948.song_id = prop_types.StringProp.jsonDecode(t251.songId)
			end

			return v1948
		end

		t248.descriptor = {
			name = "OpenSongDetailAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenSongDetailAction_Params = t248
		typeRegistry.default:register(t1.OpenSongDetailAction_Params)

		local t252 = {}

		t252.__index = t252

		function t252.new(t253: {[any]: any}?) -- line: 14820
			-- upvalues: t1 (copy), t252 (copy)
			return (setmetatable({
				action_type = if t253 ~= nil and t253.action_type ~= nil then t253.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t253 ~= nil and t253.action_params ~= nil then t253.action_params else nil
			}, t252))
		end
		function t252.encode(p190) -- line: 14831
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n125 = 0

			if p190.action_type ~= nil and (p190.action_type ~= nil and p190.action_type ~= 0 or p190.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1953, v1954 = proto.writeTag(buf, n125, 1, proto.wireTypes.varint)

				buf, n125 = proto.writeVarInt(v1953, v1954, t1.ActionType.toNumber(p190.action_type))
			end

			if p190.action_params ~= nil then
				local v1955 = p190.action_params:encode()
				local v1956, v1957 = proto.writeTag(buf, n125, 2, proto.wireTypes.lengthDelimited)

				buf, n125 = proto.writeBuffer(v1956, v1957, v1955, buffer.len(v1955))
			end

			local buf65 = buffer.create(n125)

			buffer.copy(buf65, 0, buf, 0, n125)

			return buf65
		end
		function t252.decode(p191: buffer) -- line: 14857
			-- upvalues: t252 (copy), proto (copy), t1 (copy)
			local v1960 = t252.new()
			local n126 = 0

			while n126 < buffer.len(p191) do
				local v1962, v1963

				v1962, v1963, n126 = proto.readTag(p191, n126)

				if v1963 == proto.wireTypes.varint then
					if v1962 == 1 then
						local v1964

						v1964, n126 = proto.readVarIntI32(p191, n126)
						v1960.action_type = t1.ActionType.fromNumber(v1964) or v1964
					else
						local v1965

						v1965, n126 = proto.readVarInt(p191, n126)
					end
				elseif v1963 == proto.wireTypes.lengthDelimited then
					if v1962 == 2 then
						local v1966

						v1966, n126 = proto.readBuffer(p191, n126)
						v1960.action_params = t1.OpenMarketplaceCatalogFilters_Params.decode(v1966)
					else
						local v1967, v1968 = proto.readVarInt(p191, n126)

						n126 = v1968 + v1967
					end
				elseif v1963 == proto.wireTypes.i32 then
					local v1969

					v1969, n126 = proto.readFixed32(p191, n126)
				elseif v1963 == proto.wireTypes.i64 then
					local v1970

					v1970, n126 = proto.readFixed64(p191, n126)
				else
					error("Unsupported wire type: " .. v1963)
				end
			end

			return v1960
		end
		function t252.jsonEncode(p192) -- line: 14905
			-- upvalues: t1 (copy)
			local t254 = {}

			if p192.action_type ~= nil and (p192.action_type ~= nil and p192.action_type ~= 0 or p192.action_type ~= t1.ActionType.fromNumber(0)) then
				t254.actionType = if typeof(p192.action_type) ~= "number" then t1.ActionType.toNumber(p192.action_type) else p192.action_type
			end

			if p192.action_params ~= nil then
				t254.actionParams = p192.action_params:jsonEncode()
			end

			return t254
		end
		function t252.jsonDecode(t255: {[any]: any}) -- line: 14927
			-- upvalues: t252 (copy), t1 (copy)
			local v1974 = t252.new()

			if t255.action_type ~= nil then
				v1974.action_type = if typeof(t255.action_type) ~= "number" then t1.ActionType.fromName(t255.action_type) or t255.action_type else t1.ActionType.fromNumber(t255.action_type) or t255.action_type
			end

			if t255.actionType ~= nil then
				v1974.action_type = if typeof(t255.actionType) ~= "number" then t1.ActionType.fromName(t255.actionType) or t255.actionType else t1.ActionType.fromNumber(t255.actionType) or t255.actionType
			end

			if t255.action_params ~= nil then
				v1974.action_params = t1.OpenMarketplaceCatalogFilters_Params.jsonDecode(t255.action_params)
			end

			if t255.actionParams ~= nil then
				v1974.action_params = t1.OpenMarketplaceCatalogFilters_Params.jsonDecode(t255.actionParams)
			end

			return v1974
		end

		t252.descriptor = {
			name = "OpenMarketplaceCatalogFilters",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenMarketplaceCatalogFilters"
		}
		t1.OpenMarketplaceCatalogFilters = t252
	end

	typeRegistry.default:register(t1.OpenMarketplaceCatalogFilters)

	do
		local t256 = {}

		t256.__index = t256

		function t256.new(_: {[any]: any}?) -- line: 14967
			-- upvalues: t256 (copy)
			return (setmetatable({}, t256))
		end
		function t256.encode(_) -- line: 14973
			local buf = buffer.create(0)
			local buf66 = buffer.create(0)

			buffer.copy(buf66, 0, buf, 0, 0)

			return buf66
		end
		function t256.decode(p194: buffer) -- line: 14982
			-- upvalues: t256 (copy), proto (copy)
			local v1980 = t256.new()
			local n127 = 0

			while n127 < buffer.len(p194) do
				local v1982, v1983

				v1982, v1983, n127 = proto.readTag(p194, n127)

				if v1983 == proto.wireTypes.varint then
					local v1984

					v1984, n127 = proto.readVarInt(p194, n127)
				elseif v1983 == proto.wireTypes.lengthDelimited then
					local v1985, v1986 = proto.readVarInt(p194, n127)

					n127 = v1986 + v1985
				elseif v1983 == proto.wireTypes.i32 then
					local v1987

					v1987, n127 = proto.readFixed32(p194, n127)
				elseif v1983 == proto.wireTypes.i64 then
					local v1988

					v1988, n127 = proto.readFixed64(p194, n127)
				else
					error("Unsupported wire type: " .. v1983)
				end
			end

			return v1980
		end
		function t256.jsonEncode(_) -- line: 15020
			return {}
		end
		function t256.jsonDecode(_: {[any]: any}) -- line: 15026
			-- upvalues: t256 (copy)
			return (t256.new())
		end

		t256.descriptor = {
			name = "OpenMarketplaceCatalogFilters_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenMarketplaceCatalogFilters_Params = t256
		typeRegistry.default:register(t1.OpenMarketplaceCatalogFilters_Params)

		local t259 = {}

		t259.__index = t259

		function t259.new(t260: {[any]: any}?) -- line: 15048
			-- upvalues: t1 (copy), t259 (copy)
			return (setmetatable({
				action_type = if t260 ~= nil and t260.action_type ~= nil then t260.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t260 ~= nil and t260.action_params ~= nil then t260.action_params else nil
			}, t259))
		end
		function t259.encode(p196) -- line: 15057
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n128 = 0

			if p196.action_type ~= nil and (p196.action_type ~= nil and p196.action_type ~= 0 or p196.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1995, v1996 = proto.writeTag(buf, n128, 1, proto.wireTypes.varint)

				buf, n128 = proto.writeVarInt(v1995, v1996, t1.ActionType.toNumber(p196.action_type))
			end

			if p196.action_params ~= nil then
				local v1997 = p196.action_params:encode()
				local v1998, v1999 = proto.writeTag(buf, n128, 2, proto.wireTypes.lengthDelimited)

				buf, n128 = proto.writeBuffer(v1998, v1999, v1997, buffer.len(v1997))
			end

			local buf67 = buffer.create(n128)

			buffer.copy(buf67, 0, buf, 0, n128)

			return buf67
		end
		function t259.decode(p197: buffer) -- line: 15083
			-- upvalues: t259 (copy), proto (copy), t1 (copy)
			local v2002 = t259.new()
			local n129 = 0

			while n129 < buffer.len(p197) do
				local v2004, v2005

				v2004, v2005, n129 = proto.readTag(p197, n129)

				if v2005 == proto.wireTypes.varint then
					if v2004 == 1 then
						local v2006

						v2006, n129 = proto.readVarIntI32(p197, n129)
						v2002.action_type = t1.ActionType.fromNumber(v2006) or v2006
					else
						local v2007

						v2007, n129 = proto.readVarInt(p197, n129)
					end
				elseif v2005 == proto.wireTypes.lengthDelimited then
					if v2004 == 2 then
						local v2008

						v2008, n129 = proto.readBuffer(p197, n129)
						v2002.action_params = t1.RefreshFromApiAction_Params.decode(v2008)
					else
						local v2009, v2010 = proto.readVarInt(p197, n129)

						n129 = v2010 + v2009
					end
				elseif v2005 == proto.wireTypes.i32 then
					local v2011

					v2011, n129 = proto.readFixed32(p197, n129)
				elseif v2005 == proto.wireTypes.i64 then
					local v2012

					v2012, n129 = proto.readFixed64(p197, n129)
				else
					error("Unsupported wire type: " .. v2005)
				end
			end

			return v2002
		end
		function t259.jsonEncode(p198) -- line: 15131
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
		function t259.jsonDecode(t262: {[any]: any}) -- line: 15153
			-- upvalues: t259 (copy), t1 (copy)
			local v2016 = t259.new()

			if t262.action_type ~= nil then
				v2016.action_type = if typeof(t262.action_type) ~= "number" then t1.ActionType.fromName(t262.action_type) or t262.action_type else t1.ActionType.fromNumber(t262.action_type) or t262.action_type
			end

			if t262.actionType ~= nil then
				v2016.action_type = if typeof(t262.actionType) ~= "number" then t1.ActionType.fromName(t262.actionType) or t262.actionType else t1.ActionType.fromNumber(t262.actionType) or t262.actionType
			end

			if t262.action_params ~= nil then
				v2016.action_params = t1.RefreshFromApiAction_Params.jsonDecode(t262.action_params)
			end

			if t262.actionParams ~= nil then
				v2016.action_params = t1.RefreshFromApiAction_Params.jsonDecode(t262.actionParams)
			end

			return v2016
		end

		t259.descriptor = {
			name = "RefreshFromApiAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.RefreshFromApiAction"
		}
		t1.RefreshFromApiAction = t259
	end

	typeRegistry.default:register(t1.RefreshFromApiAction)

	do
		local t263 = {}

		t263.__index = t263

		function t263.new(t264: {[any]: any}?) -- line: 15193
			-- upvalues: t263 (copy)
			return (setmetatable({
				surface_key = if t264 ~= nil and t264.surface_key ~= nil then t264.surface_key else nil,
				config_key = if t264 ~= nil and t264.config_key ~= nil then t264.config_key else nil
			}, t263))
		end
		function t263.encode(p199) -- line: 15202
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n130 = 0

			if p199.surface_key ~= nil then
				local v2021 = p199.surface_key:encode()
				local v2022, v2023 = proto.writeTag(buf, n130, 1, proto.wireTypes.lengthDelimited)

				buf, n130 = proto.writeBuffer(v2022, v2023, v2021, buffer.len(v2021))
			end

			if p199.config_key ~= nil then
				local v2024 = p199.config_key:encode()
				local v2025, v2026 = proto.writeTag(buf, n130, 2, proto.wireTypes.lengthDelimited)

				buf, n130 = proto.writeBuffer(v2025, v2026, v2024, buffer.len(v2024))
			end

			local buf68 = buffer.create(n130)

			buffer.copy(buf68, 0, buf, 0, n130)

			return buf68
		end
		function t263.decode(p200: buffer) -- line: 15223
			-- upvalues: t263 (copy), proto (copy), prop_types (copy)
			local v2029 = t263.new()
			local n131 = 0

			while n131 < buffer.len(p200) do
				local v2031, v2032

				v2031, v2032, n131 = proto.readTag(p200, n131)

				if v2032 == proto.wireTypes.varint then
					local v2033

					v2033, n131 = proto.readVarInt(p200, n131)
				elseif v2032 == proto.wireTypes.lengthDelimited then
					if v2031 == 1 then
						local v2034

						v2034, n131 = proto.readBuffer(p200, n131)
						v2029.surface_key = prop_types.StringProp.decode(v2034)
					elseif v2031 == 2 then
						local v2035

						v2035, n131 = proto.readBuffer(p200, n131)
						v2029.config_key = prop_types.StringProp.decode(v2035)
					else
						local v2036, v2037 = proto.readVarInt(p200, n131)

						n131 = v2037 + v2036
					end
				elseif v2032 == proto.wireTypes.i32 then
					local v2038

					v2038, n131 = proto.readFixed32(p200, n131)
				elseif v2032 == proto.wireTypes.i64 then
					local v2039

					v2039, n131 = proto.readFixed64(p200, n131)
				else
					error("Unsupported wire type: " .. v2032)
				end
			end

			return v2029
		end
		function t263.jsonEncode(p201) -- line: 15271
			local t265 = {}

			if p201.surface_key ~= nil then
				t265.surfaceKey = p201.surface_key:jsonEncode()
			end

			if p201.config_key ~= nil then
				t265.configKey = p201.config_key:jsonEncode()
			end

			return t265
		end
		function t263.jsonDecode(t266: {[any]: any}) -- line: 15285
			-- upvalues: t263 (copy), prop_types (copy)
			local v2043 = t263.new()

			if t266.surface_key ~= nil then
				v2043.surface_key = prop_types.StringProp.jsonDecode(t266.surface_key)
			end

			if t266.surfaceKey ~= nil then
				v2043.surface_key = prop_types.StringProp.jsonDecode(t266.surfaceKey)
			end

			if t266.config_key ~= nil then
				v2043.config_key = prop_types.StringProp.jsonDecode(t266.config_key)
			end

			if t266.configKey ~= nil then
				v2043.config_key = prop_types.StringProp.jsonDecode(t266.configKey)
			end

			return v2043
		end

		t263.descriptor = {
			name = "RefreshFromApiAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.RefreshFromApiAction_Params = t263
		typeRegistry.default:register(t1.RefreshFromApiAction_Params)

		local t267 = {}

		t267.__index = t267

		function t267.new(t268: {[any]: any}?) -- line: 15322
			-- upvalues: t1 (copy), t267 (copy)
			return (setmetatable({
				action_type = if t268 ~= nil and t268.action_type ~= nil then t268.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t268 ~= nil and t268.action_params ~= nil then t268.action_params else nil
			}, t267))
		end
		function t267.encode(p202) -- line: 15333
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n132 = 0

			if p202.action_type ~= nil and (p202.action_type ~= nil and p202.action_type ~= 0 or p202.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2048, v2049 = proto.writeTag(buf, n132, 1, proto.wireTypes.varint)

				buf, n132 = proto.writeVarInt(v2048, v2049, t1.ActionType.toNumber(p202.action_type))
			end

			if p202.action_params ~= nil then
				local v2050 = p202.action_params:encode()
				local v2051, v2052 = proto.writeTag(buf, n132, 2, proto.wireTypes.lengthDelimited)

				buf, n132 = proto.writeBuffer(v2051, v2052, v2050, buffer.len(v2050))
			end

			local buf69 = buffer.create(n132)

			buffer.copy(buf69, 0, buf, 0, n132)

			return buf69
		end
		function t267.decode(p203: buffer) -- line: 15359
			-- upvalues: t267 (copy), proto (copy), t1 (copy)
			local v2055 = t267.new()
			local n133 = 0

			while n133 < buffer.len(p203) do
				local v2057, v2058

				v2057, v2058, n133 = proto.readTag(p203, n133)

				if v2058 == proto.wireTypes.varint then
					if v2057 == 1 then
						local v2059

						v2059, n133 = proto.readVarIntI32(p203, n133)
						v2055.action_type = t1.ActionType.fromNumber(v2059) or v2059
					else
						local v2060

						v2060, n133 = proto.readVarInt(p203, n133)
					end
				elseif v2058 == proto.wireTypes.lengthDelimited then
					if v2057 == 2 then
						local v2061

						v2061, n133 = proto.readBuffer(p203, n133)
						v2055.action_params = t1.RefreshOmniRecommendationFeedItemAction_Params.decode(v2061)
					else
						local v2062, v2063 = proto.readVarInt(p203, n133)

						n133 = v2063 + v2062
					end
				elseif v2058 == proto.wireTypes.i32 then
					local v2064

					v2064, n133 = proto.readFixed32(p203, n133)
				elseif v2058 == proto.wireTypes.i64 then
					local v2065

					v2065, n133 = proto.readFixed64(p203, n133)
				else
					error("Unsupported wire type: " .. v2058)
				end
			end

			return v2055
		end
		function t267.jsonEncode(p204) -- line: 15407
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
		function t267.jsonDecode(t270: {[any]: any}) -- line: 15429
			-- upvalues: t267 (copy), t1 (copy)
			local v2069 = t267.new()

			if t270.action_type ~= nil then
				v2069.action_type = if typeof(t270.action_type) ~= "number" then t1.ActionType.fromName(t270.action_type) or t270.action_type else t1.ActionType.fromNumber(t270.action_type) or t270.action_type
			end

			if t270.actionType ~= nil then
				v2069.action_type = if typeof(t270.actionType) ~= "number" then t1.ActionType.fromName(t270.actionType) or t270.actionType else t1.ActionType.fromNumber(t270.actionType) or t270.actionType
			end

			if t270.action_params ~= nil then
				v2069.action_params = t1.RefreshOmniRecommendationFeedItemAction_Params.jsonDecode(t270.action_params)
			end

			if t270.actionParams ~= nil then
				v2069.action_params = t1.RefreshOmniRecommendationFeedItemAction_Params.jsonDecode(t270.actionParams)
			end

			return v2069
		end

		t267.descriptor = {
			name = "RefreshOmniRecommendationFeedItemAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.RefreshOmniRecommendationFeedItemAction"
		}
		t1.RefreshOmniRecommendationFeedItemAction = t267
	end

	typeRegistry.default:register(t1.RefreshOmniRecommendationFeedItemAction)

	do
		local t271 = {}

		t271.__index = t271

		function t271.new(t272: {[any]: any}?) -- line: 15471
			-- upvalues: t271 (copy)
			return (setmetatable({
				topic_id = if t272 ~= nil and t272.topic_id ~= nil then t272.topic_id else nil,
				selected_option = if t272 ~= nil and t272.selected_option ~= nil then t272.selected_option else nil,
				request_intent = if t272 ~= nil and t272.request_intent ~= nil then t272.request_intent else nil,
				feed_item_key = if t272 ~= nil and t272.feed_item_key ~= nil then t272.feed_item_key else nil
			}, t271))
		end
		function t271.encode(p205) -- line: 15482
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n134 = 0

			if p205.topic_id ~= nil then
				local v2074 = p205.topic_id:encode()
				local v2075, v2076 = proto.writeTag(buf, n134, 1, proto.wireTypes.lengthDelimited)

				buf, n134 = proto.writeBuffer(v2075, v2076, v2074, buffer.len(v2074))
			end

			if p205.selected_option ~= nil then
				local v2077 = p205.selected_option:encode()
				local v2078, v2079 = proto.writeTag(buf, n134, 2, proto.wireTypes.lengthDelimited)

				buf, n134 = proto.writeBuffer(v2078, v2079, v2077, buffer.len(v2077))
			end

			if p205.request_intent ~= nil then
				local v2080 = p205.request_intent:encode()
				local v2081, v2082 = proto.writeTag(buf, n134, 3, proto.wireTypes.lengthDelimited)

				buf, n134 = proto.writeBuffer(v2081, v2082, v2080, buffer.len(v2080))
			end

			if p205.feed_item_key ~= nil then
				local v2083 = p205.feed_item_key:encode()
				local v2084, v2085 = proto.writeTag(buf, n134, 4, proto.wireTypes.lengthDelimited)

				buf, n134 = proto.writeBuffer(v2084, v2085, v2083, buffer.len(v2083))
			end

			local buf70 = buffer.create(n134)

			buffer.copy(buf70, 0, buf, 0, n134)

			return buf70
		end
		function t271.decode(p206: buffer) -- line: 15517
			-- upvalues: t271 (copy), proto (copy), prop_types (copy)
			local v2088 = t271.new()
			local n135 = 0

			while n135 < buffer.len(p206) do
				local v2090, v2091

				v2090, v2091, n135 = proto.readTag(p206, n135)

				if v2091 == proto.wireTypes.varint then
					local v2092

					v2092, n135 = proto.readVarInt(p206, n135)
				elseif v2091 == proto.wireTypes.lengthDelimited then
					if v2090 == 1 then
						local v2093

						v2093, n135 = proto.readBuffer(p206, n135)
						v2088.topic_id = prop_types.StringProp.decode(v2093)
					elseif v2090 == 2 then
						local v2094

						v2094, n135 = proto.readBuffer(p206, n135)
						v2088.selected_option = prop_types.StringProp.decode(v2094)
					elseif v2090 == 3 then
						local v2095

						v2095, n135 = proto.readBuffer(p206, n135)
						v2088.request_intent = prop_types.StringProp.decode(v2095)
					elseif v2090 == 4 then
						local v2096

						v2096, n135 = proto.readBuffer(p206, n135)
						v2088.feed_item_key = prop_types.StringProp.decode(v2096)
					else
						local v2097, v2098 = proto.readVarInt(p206, n135)

						n135 = v2098 + v2097
					end
				elseif v2091 == proto.wireTypes.i32 then
					local v2099

					v2099, n135 = proto.readFixed32(p206, n135)
				elseif v2091 == proto.wireTypes.i64 then
					local v2100

					v2100, n135 = proto.readFixed64(p206, n135)
				else
					error("Unsupported wire type: " .. v2091)
				end
			end

			return v2088
		end
		function t271.jsonEncode(p207) -- line: 15577
			local t273 = {}

			if p207.topic_id ~= nil then
				t273.topicId = p207.topic_id:jsonEncode()
			end

			if p207.selected_option ~= nil then
				t273.selectedOption = p207.selected_option:jsonEncode()
			end

			if p207.request_intent ~= nil then
				t273.requestIntent = p207.request_intent:jsonEncode()
			end

			if p207.feed_item_key ~= nil then
				t273.feedItemKey = p207.feed_item_key:jsonEncode()
			end

			return t273
		end
		function t271.jsonDecode(t274: {[any]: any}) -- line: 15601
			-- upvalues: t271 (copy), prop_types (copy)
			local v2104 = t271.new()

			if t274.topic_id ~= nil then
				v2104.topic_id = prop_types.StringProp.jsonDecode(t274.topic_id)
			end

			if t274.topicId ~= nil then
				v2104.topic_id = prop_types.StringProp.jsonDecode(t274.topicId)
			end

			if t274.selected_option ~= nil then
				v2104.selected_option = prop_types.StringProp.jsonDecode(t274.selected_option)
			end

			if t274.selectedOption ~= nil then
				v2104.selected_option = prop_types.StringProp.jsonDecode(t274.selectedOption)
			end

			if t274.request_intent ~= nil then
				v2104.request_intent = prop_types.StringProp.jsonDecode(t274.request_intent)
			end

			if t274.requestIntent ~= nil then
				v2104.request_intent = prop_types.StringProp.jsonDecode(t274.requestIntent)
			end

			if t274.feed_item_key ~= nil then
				v2104.feed_item_key = prop_types.StringProp.jsonDecode(t274.feed_item_key)
			end

			if t274.feedItemKey ~= nil then
				v2104.feed_item_key = prop_types.StringProp.jsonDecode(t274.feedItemKey)
			end

			return v2104
		end

		t271.descriptor = {
			name = "RefreshOmniRecommendationFeedItemAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.RefreshOmniRecommendationFeedItemAction_Params = t271
		typeRegistry.default:register(t1.RefreshOmniRecommendationFeedItemAction_Params)

		local t275 = {}

		t275.__index = t275

		function t275.new(t276: {[any]: any}?) -- line: 15661
			-- upvalues: t1 (copy), t275 (copy)
			return (setmetatable({
				action_type = if t276 ~= nil and t276.action_type ~= nil then t276.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t276 ~= nil and t276.action_params ~= nil then t276.action_params else nil
			}, t275))
		end
		function t275.encode(p208) -- line: 15670
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n136 = 0

			if p208.action_type ~= nil and (p208.action_type ~= nil and p208.action_type ~= 0 or p208.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2109, v2110 = proto.writeTag(buf, n136, 1, proto.wireTypes.varint)

				buf, n136 = proto.writeVarInt(v2109, v2110, t1.ActionType.toNumber(p208.action_type))
			end

			if p208.action_params ~= nil then
				local v2111 = p208.action_params:encode()
				local v2112, v2113 = proto.writeTag(buf, n136, 2, proto.wireTypes.lengthDelimited)

				buf, n136 = proto.writeBuffer(v2112, v2113, v2111, buffer.len(v2111))
			end

			local buf71 = buffer.create(n136)

			buffer.copy(buf71, 0, buf, 0, n136)

			return buf71
		end
		function t275.decode(p209: buffer) -- line: 15696
			-- upvalues: t275 (copy), proto (copy), t1 (copy)
			local v2116 = t275.new()
			local n137 = 0

			while n137 < buffer.len(p209) do
				local v2118, v2119

				v2118, v2119, n137 = proto.readTag(p209, n137)

				if v2119 == proto.wireTypes.varint then
					if v2118 == 1 then
						local v2120

						v2120, n137 = proto.readVarIntI32(p209, n137)
						v2116.action_type = t1.ActionType.fromNumber(v2120) or v2120
					else
						local v2121

						v2121, n137 = proto.readVarInt(p209, n137)
					end
				elseif v2119 == proto.wireTypes.lengthDelimited then
					if v2118 == 2 then
						local v2122

						v2122, n137 = proto.readBuffer(p209, n137)
						v2116.action_params = t1.RsvpToEventAction_Params.decode(v2122)
					else
						local v2123, v2124 = proto.readVarInt(p209, n137)

						n137 = v2124 + v2123
					end
				elseif v2119 == proto.wireTypes.i32 then
					local v2125

					v2125, n137 = proto.readFixed32(p209, n137)
				elseif v2119 == proto.wireTypes.i64 then
					local v2126

					v2126, n137 = proto.readFixed64(p209, n137)
				else
					error("Unsupported wire type: " .. v2119)
				end
			end

			return v2116
		end
		function t275.jsonEncode(p210) -- line: 15744
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
		function t275.jsonDecode(t278: {[any]: any}) -- line: 15766
			-- upvalues: t275 (copy), t1 (copy)
			local v2130 = t275.new()

			if t278.action_type ~= nil then
				v2130.action_type = if typeof(t278.action_type) ~= "number" then t1.ActionType.fromName(t278.action_type) or t278.action_type else t1.ActionType.fromNumber(t278.action_type) or t278.action_type
			end

			if t278.actionType ~= nil then
				v2130.action_type = if typeof(t278.actionType) ~= "number" then t1.ActionType.fromName(t278.actionType) or t278.actionType else t1.ActionType.fromNumber(t278.actionType) or t278.actionType
			end

			if t278.action_params ~= nil then
				v2130.action_params = t1.RsvpToEventAction_Params.jsonDecode(t278.action_params)
			end

			if t278.actionParams ~= nil then
				v2130.action_params = t1.RsvpToEventAction_Params.jsonDecode(t278.actionParams)
			end

			return v2130
		end

		t275.descriptor = {
			name = "RsvpToEventAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.RsvpToEventAction"
		}
		t1.RsvpToEventAction = t275
	end

	typeRegistry.default:register(t1.RsvpToEventAction)

	do
		local t279 = {}

		t279.__index = t279

		function t279.new(t280: {[any]: any}?) -- line: 15806
			-- upvalues: t279 (copy)
			return (setmetatable({
				event_id = if t280 ~= nil and t280.event_id ~= nil then t280.event_id else nil,
				user_rsvp = if t280 ~= nil and t280.user_rsvp ~= nil then t280.user_rsvp else nil,
				notifications_modal_identifier = if t280 ~= nil and t280.notifications_modal_identifier ~= nil then t280.notifications_modal_identifier else nil
			}, t279))
		end
		function t279.encode(p211) -- line: 15816
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n138 = 0

			if p211.event_id ~= nil then
				local v2135 = p211.event_id:encode()
				local v2136, v2137 = proto.writeTag(buf, n138, 1, proto.wireTypes.lengthDelimited)

				buf, n138 = proto.writeBuffer(v2136, v2137, v2135, buffer.len(v2135))
			end

			if p211.user_rsvp ~= nil then
				local v2138 = p211.user_rsvp:encode()
				local v2139, v2140 = proto.writeTag(buf, n138, 2, proto.wireTypes.lengthDelimited)

				buf, n138 = proto.writeBuffer(v2139, v2140, v2138, buffer.len(v2138))
			end

			if p211.notifications_modal_identifier ~= nil then
				local v2141 = p211.notifications_modal_identifier:encode()
				local v2142, v2143 = proto.writeTag(buf, n138, 3, proto.wireTypes.lengthDelimited)

				buf, n138 = proto.writeBuffer(v2142, v2143, v2141, buffer.len(v2141))
			end

			local buf72 = buffer.create(n138)

			buffer.copy(buf72, 0, buf, 0, n138)

			return buf72
		end
		function t279.decode(p212: buffer) -- line: 15843
			-- upvalues: t279 (copy), proto (copy), prop_types (copy)
			local v2146 = t279.new()
			local n139 = 0

			while n139 < buffer.len(p212) do
				local v2148, v2149

				v2148, v2149, n139 = proto.readTag(p212, n139)

				if v2149 == proto.wireTypes.varint then
					local v2150

					v2150, n139 = proto.readVarInt(p212, n139)
				elseif v2149 == proto.wireTypes.lengthDelimited then
					if v2148 == 1 then
						local v2151

						v2151, n139 = proto.readBuffer(p212, n139)
						v2146.event_id = prop_types.StringProp.decode(v2151)
					elseif v2148 == 2 then
						local v2152

						v2152, n139 = proto.readBuffer(p212, n139)
						v2146.user_rsvp = prop_types.BoolProp.decode(v2152)
					elseif v2148 == 3 then
						local v2153

						v2153, n139 = proto.readBuffer(p212, n139)
						v2146.notifications_modal_identifier = prop_types.StringProp.decode(v2153)
					else
						local v2154, v2155 = proto.readVarInt(p212, n139)

						n139 = v2155 + v2154
					end
				elseif v2149 == proto.wireTypes.i32 then
					local v2156

					v2156, n139 = proto.readFixed32(p212, n139)
				elseif v2149 == proto.wireTypes.i64 then
					local v2157

					v2157, n139 = proto.readFixed64(p212, n139)
				else
					error("Unsupported wire type: " .. v2149)
				end
			end

			return v2146
		end
		function t279.jsonEncode(p213) -- line: 15897
			local t281 = {}

			if p213.event_id ~= nil then
				t281.eventId = p213.event_id:jsonEncode()
			end

			if p213.user_rsvp ~= nil then
				t281.userRsvp = p213.user_rsvp:jsonEncode()
			end

			if p213.notifications_modal_identifier ~= nil then
				t281.notificationsModalIdentifier = p213.notifications_modal_identifier:jsonEncode()
			end

			return t281
		end
		function t279.jsonDecode(t282: {[any]: any}) -- line: 15915
			-- upvalues: t279 (copy), prop_types (copy)
			local v2161 = t279.new()

			if t282.event_id ~= nil then
				v2161.event_id = prop_types.StringProp.jsonDecode(t282.event_id)
			end

			if t282.eventId ~= nil then
				v2161.event_id = prop_types.StringProp.jsonDecode(t282.eventId)
			end

			if t282.user_rsvp ~= nil then
				v2161.user_rsvp = prop_types.BoolProp.jsonDecode(t282.user_rsvp)
			end

			if t282.userRsvp ~= nil then
				v2161.user_rsvp = prop_types.BoolProp.jsonDecode(t282.userRsvp)
			end

			if t282.notifications_modal_identifier ~= nil then
				v2161.notifications_modal_identifier = prop_types.StringProp.jsonDecode(t282.notifications_modal_identifier)
			end

			if t282.notificationsModalIdentifier ~= nil then
				v2161.notifications_modal_identifier = prop_types.StringProp.jsonDecode(t282.notificationsModalIdentifier)
			end

			return v2161
		end

		t279.descriptor = {
			name = "RsvpToEventAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.RsvpToEventAction_Params = t279
		typeRegistry.default:register(t1.RsvpToEventAction_Params)

		local t283 = {}

		t283.__index = t283

		function t283.new(t284: {[any]: any}?) -- line: 15965
			-- upvalues: t1 (copy), t283 (copy)
			return (setmetatable({
				action_type = if t284 ~= nil and t284.action_type ~= nil then t284.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t284 ~= nil and t284.action_params ~= nil then t284.action_params else nil
			}, t283))
		end
		function t283.encode(p214) -- line: 15974
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n140 = 0

			if p214.action_type ~= nil and (p214.action_type ~= nil and p214.action_type ~= 0 or p214.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2166, v2167 = proto.writeTag(buf, n140, 1, proto.wireTypes.varint)

				buf, n140 = proto.writeVarInt(v2166, v2167, t1.ActionType.toNumber(p214.action_type))
			end

			if p214.action_params ~= nil then
				local v2168 = p214.action_params:encode()
				local v2169, v2170 = proto.writeTag(buf, n140, 2, proto.wireTypes.lengthDelimited)

				buf, n140 = proto.writeBuffer(v2169, v2170, v2168, buffer.len(v2168))
			end

			local buf73 = buffer.create(n140)

			buffer.copy(buf73, 0, buf, 0, n140)

			return buf73
		end
		function t283.decode(p215: buffer) -- line: 16000
			-- upvalues: t283 (copy), proto (copy), t1 (copy)
			local v2173 = t283.new()
			local n141 = 0

			while n141 < buffer.len(p215) do
				local v2175, v2176

				v2175, v2176, n141 = proto.readTag(p215, n141)

				if v2176 == proto.wireTypes.varint then
					if v2175 == 1 then
						local v2177

						v2177, n141 = proto.readVarIntI32(p215, n141)
						v2173.action_type = t1.ActionType.fromNumber(v2177) or v2177
					else
						local v2178

						v2178, n141 = proto.readVarInt(p215, n141)
					end
				elseif v2176 == proto.wireTypes.lengthDelimited then
					if v2175 == 2 then
						local v2179

						v2179, n141 = proto.readBuffer(p215, n141)
						v2173.action_params = t1.OpenEventDetailsAction_Params.decode(v2179)
					else
						local v2180, v2181 = proto.readVarInt(p215, n141)

						n141 = v2181 + v2180
					end
				elseif v2176 == proto.wireTypes.i32 then
					local v2182

					v2182, n141 = proto.readFixed32(p215, n141)
				elseif v2176 == proto.wireTypes.i64 then
					local v2183

					v2183, n141 = proto.readFixed64(p215, n141)
				else
					error("Unsupported wire type: " .. v2176)
				end
			end

			return v2173
		end
		function t283.jsonEncode(p216) -- line: 16048
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
		function t283.jsonDecode(t286: {[any]: any}) -- line: 16070
			-- upvalues: t283 (copy), t1 (copy)
			local v2187 = t283.new()

			if t286.action_type ~= nil then
				v2187.action_type = if typeof(t286.action_type) ~= "number" then t1.ActionType.fromName(t286.action_type) or t286.action_type else t1.ActionType.fromNumber(t286.action_type) or t286.action_type
			end

			if t286.actionType ~= nil then
				v2187.action_type = if typeof(t286.actionType) ~= "number" then t1.ActionType.fromName(t286.actionType) or t286.actionType else t1.ActionType.fromNumber(t286.actionType) or t286.actionType
			end

			if t286.action_params ~= nil then
				v2187.action_params = t1.OpenEventDetailsAction_Params.jsonDecode(t286.action_params)
			end

			if t286.actionParams ~= nil then
				v2187.action_params = t1.OpenEventDetailsAction_Params.jsonDecode(t286.actionParams)
			end

			return v2187
		end

		t283.descriptor = {
			name = "OpenEventDetailsAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenEventDetailsAction"
		}
		t1.OpenEventDetailsAction = t283
	end

	typeRegistry.default:register(t1.OpenEventDetailsAction)

	do
		local t287 = {}

		t287.__index = t287

		function t287.new(t288: {[any]: any}?) -- line: 16110
			-- upvalues: t287 (copy)
			return (setmetatable({
				event_id = if t288 ~= nil and t288.event_id ~= nil then t288.event_id else nil
			}, t287))
		end
		function t287.encode(p217) -- line: 16118
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n142 = 0

			if p217.event_id ~= nil then
				local v2192 = p217.event_id:encode()
				local v2193, v2194 = proto.writeTag(buf, n142, 1, proto.wireTypes.lengthDelimited)

				buf, n142 = proto.writeBuffer(v2193, v2194, v2192, buffer.len(v2192))
			end

			local buf74 = buffer.create(n142)

			buffer.copy(buf74, 0, buf, 0, n142)

			return buf74
		end
		function t287.decode(p218: buffer) -- line: 16133
			-- upvalues: t287 (copy), proto (copy), prop_types (copy)
			local v2197 = t287.new()
			local n143 = 0

			while n143 < buffer.len(p218) do
				local v2199, v2200

				v2199, v2200, n143 = proto.readTag(p218, n143)

				if v2200 == proto.wireTypes.varint then
					local v2201

					v2201, n143 = proto.readVarInt(p218, n143)
				elseif v2200 == proto.wireTypes.lengthDelimited then
					if v2199 == 1 then
						local v2202

						v2202, n143 = proto.readBuffer(p218, n143)
						v2197.event_id = prop_types.StringProp.decode(v2202)
					else
						local v2203, v2204 = proto.readVarInt(p218, n143)

						n143 = v2204 + v2203
					end
				elseif v2200 == proto.wireTypes.i32 then
					local v2205

					v2205, n143 = proto.readFixed32(p218, n143)
				elseif v2200 == proto.wireTypes.i64 then
					local v2206

					v2206, n143 = proto.readFixed64(p218, n143)
				else
					error("Unsupported wire type: " .. v2200)
				end
			end

			return v2197
		end
		function t287.jsonEncode(p219) -- line: 16176
			local t289 = {}

			if p219.event_id ~= nil then
				t289.eventId = p219.event_id:jsonEncode()
			end

			return t289
		end
		function t287.jsonDecode(t290: {[any]: any}) -- line: 16186
			-- upvalues: t287 (copy), prop_types (copy)
			local v2210 = t287.new()

			if t290.event_id ~= nil then
				v2210.event_id = prop_types.StringProp.jsonDecode(t290.event_id)
			end

			if t290.eventId ~= nil then
				v2210.event_id = prop_types.StringProp.jsonDecode(t290.eventId)
			end

			return v2210
		end

		t287.descriptor = {
			name = "OpenEventDetailsAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenEventDetailsAction_Params = t287
		typeRegistry.default:register(t1.OpenEventDetailsAction_Params)

		local t291 = {}

		t291.__index = t291

		function t291.new(t292: {[any]: any}?) -- line: 16214
			-- upvalues: t1 (copy), t291 (copy)
			return (setmetatable({
				action_type = if t292 ~= nil and t292.action_type ~= nil then t292.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t292 ~= nil and t292.action_params ~= nil then t292.action_params else nil
			}, t291))
		end
		function t291.encode(p220) -- line: 16223
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n144 = 0

			if p220.action_type ~= nil and (p220.action_type ~= nil and p220.action_type ~= 0 or p220.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2215, v2216 = proto.writeTag(buf, n144, 1, proto.wireTypes.varint)

				buf, n144 = proto.writeVarInt(v2215, v2216, t1.ActionType.toNumber(p220.action_type))
			end

			if p220.action_params ~= nil then
				local v2217 = p220.action_params:encode()
				local v2218, v2219 = proto.writeTag(buf, n144, 2, proto.wireTypes.lengthDelimited)

				buf, n144 = proto.writeBuffer(v2218, v2219, v2217, buffer.len(v2217))
			end

			local buf75 = buffer.create(n144)

			buffer.copy(buf75, 0, buf, 0, n144)

			return buf75
		end
		function t291.decode(p221: buffer) -- line: 16249
			-- upvalues: t291 (copy), proto (copy), t1 (copy)
			local v2222 = t291.new()
			local n145 = 0

			while n145 < buffer.len(p221) do
				local v2224, v2225

				v2224, v2225, n145 = proto.readTag(p221, n145)

				if v2225 == proto.wireTypes.varint then
					if v2224 == 1 then
						local v2226

						v2226, n145 = proto.readVarIntI32(p221, n145)
						v2222.action_type = t1.ActionType.fromNumber(v2226) or v2226
					else
						local v2227

						v2227, n145 = proto.readVarInt(p221, n145)
					end
				elseif v2225 == proto.wireTypes.lengthDelimited then
					if v2224 == 2 then
						local v2228

						v2228, n145 = proto.readBuffer(p221, n145)
						v2222.action_params = t1.OpenBadgesSeeAllAction_Params.decode(v2228)
					else
						local v2229, v2230 = proto.readVarInt(p221, n145)

						n145 = v2230 + v2229
					end
				elseif v2225 == proto.wireTypes.i32 then
					local v2231

					v2231, n145 = proto.readFixed32(p221, n145)
				elseif v2225 == proto.wireTypes.i64 then
					local v2232

					v2232, n145 = proto.readFixed64(p221, n145)
				else
					error("Unsupported wire type: " .. v2225)
				end
			end

			return v2222
		end
		function t291.jsonEncode(p222) -- line: 16297
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
		function t291.jsonDecode(t294: {[any]: any}) -- line: 16319
			-- upvalues: t291 (copy), t1 (copy)
			local v2236 = t291.new()

			if t294.action_type ~= nil then
				v2236.action_type = if typeof(t294.action_type) ~= "number" then t1.ActionType.fromName(t294.action_type) or t294.action_type else t1.ActionType.fromNumber(t294.action_type) or t294.action_type
			end

			if t294.actionType ~= nil then
				v2236.action_type = if typeof(t294.actionType) ~= "number" then t1.ActionType.fromName(t294.actionType) or t294.actionType else t1.ActionType.fromNumber(t294.actionType) or t294.actionType
			end

			if t294.action_params ~= nil then
				v2236.action_params = t1.OpenBadgesSeeAllAction_Params.jsonDecode(t294.action_params)
			end

			if t294.actionParams ~= nil then
				v2236.action_params = t1.OpenBadgesSeeAllAction_Params.jsonDecode(t294.actionParams)
			end

			return v2236
		end

		t291.descriptor = {
			name = "OpenBadgesSeeAllAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenBadgesSeeAllAction"
		}
		t1.OpenBadgesSeeAllAction = t291
	end

	typeRegistry.default:register(t1.OpenBadgesSeeAllAction)

	do
		local t295 = {}

		t295.__index = t295

		function t295.new(t296: {[any]: any}?) -- line: 16359
			-- upvalues: t295 (copy)
			return (setmetatable({
				universe_id = if t296 ~= nil and t296.universe_id ~= nil then t296.universe_id else nil
			}, t295))
		end
		function t295.encode(p223) -- line: 16367
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n146 = 0

			if p223.universe_id ~= nil then
				local v2241 = p223.universe_id:encode()
				local v2242, v2243 = proto.writeTag(buf, n146, 1, proto.wireTypes.lengthDelimited)

				buf, n146 = proto.writeBuffer(v2242, v2243, v2241, buffer.len(v2241))
			end

			local buf76 = buffer.create(n146)

			buffer.copy(buf76, 0, buf, 0, n146)

			return buf76
		end
		function t295.decode(p224: buffer) -- line: 16382
			-- upvalues: t295 (copy), proto (copy), prop_types (copy)
			local v2246 = t295.new()
			local n147 = 0

			while n147 < buffer.len(p224) do
				local v2248, v2249

				v2248, v2249, n147 = proto.readTag(p224, n147)

				if v2249 == proto.wireTypes.varint then
					local v2250

					v2250, n147 = proto.readVarInt(p224, n147)
				elseif v2249 == proto.wireTypes.lengthDelimited then
					if v2248 == 1 then
						local v2251

						v2251, n147 = proto.readBuffer(p224, n147)
						v2246.universe_id = prop_types.StringProp.decode(v2251)
					else
						local v2252, v2253 = proto.readVarInt(p224, n147)

						n147 = v2253 + v2252
					end
				elseif v2249 == proto.wireTypes.i32 then
					local v2254

					v2254, n147 = proto.readFixed32(p224, n147)
				elseif v2249 == proto.wireTypes.i64 then
					local v2255

					v2255, n147 = proto.readFixed64(p224, n147)
				else
					error("Unsupported wire type: " .. v2249)
				end
			end

			return v2246
		end
		function t295.jsonEncode(p225) -- line: 16425
			local t297 = {}

			if p225.universe_id ~= nil then
				t297.universeId = p225.universe_id:jsonEncode()
			end

			return t297
		end
		function t295.jsonDecode(t298: {[any]: any}) -- line: 16435
			-- upvalues: t295 (copy), prop_types (copy)
			local v2259 = t295.new()

			if t298.universe_id ~= nil then
				v2259.universe_id = prop_types.StringProp.jsonDecode(t298.universe_id)
			end

			if t298.universeId ~= nil then
				v2259.universe_id = prop_types.StringProp.jsonDecode(t298.universeId)
			end

			return v2259
		end

		t295.descriptor = {
			name = "OpenBadgesSeeAllAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenBadgesSeeAllAction_Params = t295
		typeRegistry.default:register(t1.OpenBadgesSeeAllAction_Params)

		local t299 = {}

		t299.__index = t299

		function t299.new(t300: {[any]: any}?) -- line: 16464
			-- upvalues: t1 (copy), t299 (copy)
			return (setmetatable({
				action_type = if t300 ~= nil and t300.action_type ~= nil then t300.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t300 ~= nil and t300.action_params ~= nil then t300.action_params else nil
			}, t299))
		end
		function t299.encode(p226) -- line: 16475
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n148 = 0

			if p226.action_type ~= nil and (p226.action_type ~= nil and p226.action_type ~= 0 or p226.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2264, v2265 = proto.writeTag(buf, n148, 1, proto.wireTypes.varint)

				buf, n148 = proto.writeVarInt(v2264, v2265, t1.ActionType.toNumber(p226.action_type))
			end

			if p226.action_params ~= nil then
				local v2266 = p226.action_params:encode()
				local v2267, v2268 = proto.writeTag(buf, n148, 2, proto.wireTypes.lengthDelimited)

				buf, n148 = proto.writeBuffer(v2267, v2268, v2266, buffer.len(v2266))
			end

			local buf77 = buffer.create(n148)

			buffer.copy(buf77, 0, buf, 0, n148)

			return buf77
		end
		function t299.decode(p227: buffer) -- line: 16501
			-- upvalues: t299 (copy), proto (copy), t1 (copy)
			local v2271 = t299.new()
			local n149 = 0

			while n149 < buffer.len(p227) do
				local v2273, v2274

				v2273, v2274, n149 = proto.readTag(p227, n149)

				if v2274 == proto.wireTypes.varint then
					if v2273 == 1 then
						local v2275

						v2275, n149 = proto.readVarIntI32(p227, n149)
						v2271.action_type = t1.ActionType.fromNumber(v2275) or v2275
					else
						local v2276

						v2276, n149 = proto.readVarInt(p227, n149)
					end
				elseif v2274 == proto.wireTypes.lengthDelimited then
					if v2273 == 2 then
						local v2277

						v2277, n149 = proto.readBuffer(p227, n149)
						v2271.action_params = t1.OpenExperienceStoreSeeAllAction_Params.decode(v2277)
					else
						local v2278, v2279 = proto.readVarInt(p227, n149)

						n149 = v2279 + v2278
					end
				elseif v2274 == proto.wireTypes.i32 then
					local v2280

					v2280, n149 = proto.readFixed32(p227, n149)
				elseif v2274 == proto.wireTypes.i64 then
					local v2281

					v2281, n149 = proto.readFixed64(p227, n149)
				else
					error("Unsupported wire type: " .. v2274)
				end
			end

			return v2271
		end
		function t299.jsonEncode(p228) -- line: 16549
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
		function t299.jsonDecode(t302: {[any]: any}) -- line: 16571
			-- upvalues: t299 (copy), t1 (copy)
			local v2285 = t299.new()

			if t302.action_type ~= nil then
				v2285.action_type = if typeof(t302.action_type) ~= "number" then t1.ActionType.fromName(t302.action_type) or t302.action_type else t1.ActionType.fromNumber(t302.action_type) or t302.action_type
			end

			if t302.actionType ~= nil then
				v2285.action_type = if typeof(t302.actionType) ~= "number" then t1.ActionType.fromName(t302.actionType) or t302.actionType else t1.ActionType.fromNumber(t302.actionType) or t302.actionType
			end

			if t302.action_params ~= nil then
				v2285.action_params = t1.OpenExperienceStoreSeeAllAction_Params.jsonDecode(t302.action_params)
			end

			if t302.actionParams ~= nil then
				v2285.action_params = t1.OpenExperienceStoreSeeAllAction_Params.jsonDecode(t302.actionParams)
			end

			return v2285
		end

		t299.descriptor = {
			name = "OpenExperienceStoreSeeAllAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenExperienceStoreSeeAllAction"
		}
		t1.OpenExperienceStoreSeeAllAction = t299
	end

	typeRegistry.default:register(t1.OpenExperienceStoreSeeAllAction)

	do
		local t303 = {}

		t303.__index = t303

		function t303.new(t304: {[any]: any}?) -- line: 16611
			-- upvalues: t303 (copy)
			return (setmetatable({
				universe_id = if t304 ~= nil and t304.universe_id ~= nil then t304.universe_id else nil
			}, t303))
		end
		function t303.encode(p229) -- line: 16619
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n150 = 0

			if p229.universe_id ~= nil then
				local v2290 = p229.universe_id:encode()
				local v2291, v2292 = proto.writeTag(buf, n150, 1, proto.wireTypes.lengthDelimited)

				buf, n150 = proto.writeBuffer(v2291, v2292, v2290, buffer.len(v2290))
			end

			local buf78 = buffer.create(n150)

			buffer.copy(buf78, 0, buf, 0, n150)

			return buf78
		end
		function t303.decode(p230: buffer) -- line: 16634
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
						v2295.universe_id = prop_types.StringProp.decode(v2300)
					else
						local v2301, v2302 = proto.readVarInt(p230, n151)

						n151 = v2302 + v2301
					end
				elseif v2298 == proto.wireTypes.i32 then
					local v2303

					v2303, n151 = proto.readFixed32(p230, n151)
				elseif v2298 == proto.wireTypes.i64 then
					local v2304

					v2304, n151 = proto.readFixed64(p230, n151)
				else
					error("Unsupported wire type: " .. v2298)
				end
			end

			return v2295
		end
		function t303.jsonEncode(p231) -- line: 16677
			local t305 = {}

			if p231.universe_id ~= nil then
				t305.universeId = p231.universe_id:jsonEncode()
			end

			return t305
		end
		function t303.jsonDecode(t306: {[any]: any}) -- line: 16687
			-- upvalues: t303 (copy), prop_types (copy)
			local v2308 = t303.new()

			if t306.universe_id ~= nil then
				v2308.universe_id = prop_types.StringProp.jsonDecode(t306.universe_id)
			end

			if t306.universeId ~= nil then
				v2308.universe_id = prop_types.StringProp.jsonDecode(t306.universeId)
			end

			return v2308
		end

		t303.descriptor = {
			name = "OpenExperienceStoreSeeAllAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenExperienceStoreSeeAllAction_Params = t303
		typeRegistry.default:register(t1.OpenExperienceStoreSeeAllAction_Params)

		local t307 = {}

		t307.__index = t307

		function t307.new(t308: {[any]: any}?) -- line: 16718
			-- upvalues: t1 (copy), t307 (copy)
			return (setmetatable({
				action_type = if t308 ~= nil and t308.action_type ~= nil then t308.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t308 ~= nil and t308.action_params ~= nil then t308.action_params else nil
			}, t307))
		end
		function t307.encode(p232) -- line: 16729
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n152 = 0

			if p232.action_type ~= nil and (p232.action_type ~= nil and p232.action_type ~= 0 or p232.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2313, v2314 = proto.writeTag(buf, n152, 1, proto.wireTypes.varint)

				buf, n152 = proto.writeVarInt(v2313, v2314, t1.ActionType.toNumber(p232.action_type))
			end

			if p232.action_params ~= nil then
				local v2315 = p232.action_params:encode()
				local v2316, v2317 = proto.writeTag(buf, n152, 2, proto.wireTypes.lengthDelimited)

				buf, n152 = proto.writeBuffer(v2316, v2317, v2315, buffer.len(v2315))
			end

			local buf79 = buffer.create(n152)

			buffer.copy(buf79, 0, buf, 0, n152)

			return buf79
		end
		function t307.decode(p233: buffer) -- line: 16755
			-- upvalues: t307 (copy), proto (copy), t1 (copy)
			local v2320 = t307.new()
			local n153 = 0

			while n153 < buffer.len(p233) do
				local v2322, v2323

				v2322, v2323, n153 = proto.readTag(p233, n153)

				if v2323 == proto.wireTypes.varint then
					if v2322 == 1 then
						local v2324

						v2324, n153 = proto.readVarIntI32(p233, n153)
						v2320.action_type = t1.ActionType.fromNumber(v2324) or v2324
					else
						local v2325

						v2325, n153 = proto.readVarInt(p233, n153)
					end
				elseif v2323 == proto.wireTypes.lengthDelimited then
					if v2322 == 2 then
						local v2326

						v2326, n153 = proto.readBuffer(p233, n153)
						v2320.action_params = t1.OpenSubscriptionPurchasePageAction_Params.decode(v2326)
					else
						local v2327, v2328 = proto.readVarInt(p233, n153)

						n153 = v2328 + v2327
					end
				elseif v2323 == proto.wireTypes.i32 then
					local v2329

					v2329, n153 = proto.readFixed32(p233, n153)
				elseif v2323 == proto.wireTypes.i64 then
					local v2330

					v2330, n153 = proto.readFixed64(p233, n153)
				else
					error("Unsupported wire type: " .. v2323)
				end
			end

			return v2320
		end
		function t307.jsonEncode(p234) -- line: 16803
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
		function t307.jsonDecode(t310: {[any]: any}) -- line: 16825
			-- upvalues: t307 (copy), t1 (copy)
			local v2334 = t307.new()

			if t310.action_type ~= nil then
				v2334.action_type = if typeof(t310.action_type) ~= "number" then t1.ActionType.fromName(t310.action_type) or t310.action_type else t1.ActionType.fromNumber(t310.action_type) or t310.action_type
			end

			if t310.actionType ~= nil then
				v2334.action_type = if typeof(t310.actionType) ~= "number" then t1.ActionType.fromName(t310.actionType) or t310.actionType else t1.ActionType.fromNumber(t310.actionType) or t310.actionType
			end

			if t310.action_params ~= nil then
				v2334.action_params = t1.OpenSubscriptionPurchasePageAction_Params.jsonDecode(t310.action_params)
			end

			if t310.actionParams ~= nil then
				v2334.action_params = t1.OpenSubscriptionPurchasePageAction_Params.jsonDecode(t310.actionParams)
			end

			return v2334
		end

		t307.descriptor = {
			name = "OpenSubscriptionPurchasePageAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenSubscriptionPurchasePageAction"
		}
		t1.OpenSubscriptionPurchasePageAction = t307
	end

	typeRegistry.default:register(t1.OpenSubscriptionPurchasePageAction)

	do
		local t311 = {}

		t311.__index = t311

		function t311.new(t312: {[any]: any}?) -- line: 16867
			-- upvalues: t311 (copy)
			return (setmetatable({
				subscription_id = if t312 ~= nil and t312.subscription_id ~= nil then t312.subscription_id else nil,
				universe_id = if t312 ~= nil and t312.universe_id ~= nil then t312.universe_id else nil,
				creator_name = if t312 ~= nil and t312.creator_name ~= nil then t312.creator_name else nil,
				creator_verified = if t312 ~= nil and t312.creator_verified ~= nil then t312.creator_verified else nil,
				name = if t312 ~= nil and t312.name ~= nil then t312.name else nil,
				description = if t312 ~= nil and t312.description ~= nil then t312.description else nil,
				image_asset_id = if t312 ~= nil and t312.image_asset_id ~= nil then t312.image_asset_id else nil,
				period_type = if t312 ~= nil and t312.period_type ~= nil then t312.period_type else nil,
				is_subscribed = if t312 ~= nil and t312.is_subscribed ~= nil then t312.is_subscribed else nil,
				price_display = if t312 ~= nil and t312.price_display ~= nil then t312.price_display else nil,
				price_in_robux = if t312 ~= nil and t312.price_in_robux ~= nil then t312.price_in_robux else nil,
				price_tier = if t312 ~= nil and t312.price_tier ~= nil then t312.price_tier else nil,
				thumbnail_string = if t312 ~= nil and t312.thumbnail_string ~= nil then t312.thumbnail_string else nil
			}, t311))
		end
		function t311.encode(p235) -- line: 16887
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n154 = 0

			if p235.subscription_id ~= nil then
				local v2339 = p235.subscription_id:encode()
				local v2340, v2341 = proto.writeTag(buf, n154, 1, proto.wireTypes.lengthDelimited)

				buf, n154 = proto.writeBuffer(v2340, v2341, v2339, buffer.len(v2339))
			end

			if p235.universe_id ~= nil then
				local v2342 = p235.universe_id:encode()
				local v2343, v2344 = proto.writeTag(buf, n154, 2, proto.wireTypes.lengthDelimited)

				buf, n154 = proto.writeBuffer(v2343, v2344, v2342, buffer.len(v2342))
			end

			if p235.creator_name ~= nil then
				local v2345 = p235.creator_name:encode()
				local v2346, v2347 = proto.writeTag(buf, n154, 3, proto.wireTypes.lengthDelimited)

				buf, n154 = proto.writeBuffer(v2346, v2347, v2345, buffer.len(v2345))
			end

			if p235.creator_verified ~= nil then
				local v2348 = p235.creator_verified:encode()
				local v2349, v2350 = proto.writeTag(buf, n154, 4, proto.wireTypes.lengthDelimited)

				buf, n154 = proto.writeBuffer(v2349, v2350, v2348, buffer.len(v2348))
			end

			if p235.name ~= nil then
				local v2351 = p235.name:encode()
				local v2352, v2353 = proto.writeTag(buf, n154, 5, proto.wireTypes.lengthDelimited)

				buf, n154 = proto.writeBuffer(v2352, v2353, v2351, buffer.len(v2351))
			end

			if p235.description ~= nil then
				local v2354 = p235.description:encode()
				local v2355, v2356 = proto.writeTag(buf, n154, 6, proto.wireTypes.lengthDelimited)

				buf, n154 = proto.writeBuffer(v2355, v2356, v2354, buffer.len(v2354))
			end

			if p235.image_asset_id ~= nil then
				local v2357 = p235.image_asset_id:encode()
				local v2358, v2359 = proto.writeTag(buf, n154, 7, proto.wireTypes.lengthDelimited)

				buf, n154 = proto.writeBuffer(v2358, v2359, v2357, buffer.len(v2357))
			end

			if p235.period_type ~= nil then
				local v2360 = p235.period_type:encode()
				local v2361, v2362 = proto.writeTag(buf, n154, 8, proto.wireTypes.lengthDelimited)

				buf, n154 = proto.writeBuffer(v2361, v2362, v2360, buffer.len(v2360))
			end

			if p235.is_subscribed ~= nil then
				local v2363 = p235.is_subscribed:encode()
				local v2364, v2365 = proto.writeTag(buf, n154, 9, proto.wireTypes.lengthDelimited)

				buf, n154 = proto.writeBuffer(v2364, v2365, v2363, buffer.len(v2363))
			end

			if p235.price_display ~= nil then
				local v2366 = p235.price_display:encode()
				local v2367, v2368 = proto.writeTag(buf, n154, 10, proto.wireTypes.lengthDelimited)

				buf, n154 = proto.writeBuffer(v2367, v2368, v2366, buffer.len(v2366))
			end

			if p235.price_in_robux ~= nil then
				local v2369 = p235.price_in_robux:encode()
				local v2370, v2371 = proto.writeTag(buf, n154, 11, proto.wireTypes.lengthDelimited)

				buf, n154 = proto.writeBuffer(v2370, v2371, v2369, buffer.len(v2369))
			end

			if p235.price_tier ~= nil then
				local v2372 = p235.price_tier:encode()
				local v2373, v2374 = proto.writeTag(buf, n154, 12, proto.wireTypes.lengthDelimited)

				buf, n154 = proto.writeBuffer(v2373, v2374, v2372, buffer.len(v2372))
			end

			if p235.thumbnail_string ~= nil then
				local v2375 = p235.thumbnail_string:encode()
				local v2376, v2377 = proto.writeTag(buf, n154, 13, proto.wireTypes.lengthDelimited)

				buf, n154 = proto.writeBuffer(v2376, v2377, v2375, buffer.len(v2375))
			end

			local buf80 = buffer.create(n154)

			buffer.copy(buf80, 0, buf, 0, n154)

			return buf80
		end
		function t311.decode(p236: buffer) -- line: 16976
			-- upvalues: t311 (copy), proto (copy), prop_types (copy)
			local v2380 = t311.new()
			local n155 = 0

			while n155 < buffer.len(p236) do
				local v2382, v2383

				v2382, v2383, n155 = proto.readTag(p236, n155)

				if v2383 == proto.wireTypes.varint then
					local v2384

					v2384, n155 = proto.readVarInt(p236, n155)
				elseif v2383 == proto.wireTypes.lengthDelimited then
					if v2382 == 1 then
						local v2385

						v2385, n155 = proto.readBuffer(p236, n155)
						v2380.subscription_id = prop_types.StringProp.decode(v2385)
					elseif v2382 == 2 then
						local v2386

						v2386, n155 = proto.readBuffer(p236, n155)
						v2380.universe_id = prop_types.StringProp.decode(v2386)
					elseif v2382 == 3 then
						local v2387

						v2387, n155 = proto.readBuffer(p236, n155)
						v2380.creator_name = prop_types.StringProp.decode(v2387)
					elseif v2382 == 4 then
						local v2388

						v2388, n155 = proto.readBuffer(p236, n155)
						v2380.creator_verified = prop_types.BoolProp.decode(v2388)
					elseif v2382 == 5 then
						local v2389

						v2389, n155 = proto.readBuffer(p236, n155)
						v2380.name = prop_types.StringProp.decode(v2389)
					elseif v2382 == 6 then
						local v2390

						v2390, n155 = proto.readBuffer(p236, n155)
						v2380.description = prop_types.StringProp.decode(v2390)
					elseif v2382 == 7 then
						local v2391

						v2391, n155 = proto.readBuffer(p236, n155)
						v2380.image_asset_id = prop_types.Int64Prop.decode(v2391)
					elseif v2382 == 8 then
						local v2392

						v2392, n155 = proto.readBuffer(p236, n155)
						v2380.period_type = prop_types.StringProp.decode(v2392)
					elseif v2382 == 9 then
						local v2393

						v2393, n155 = proto.readBuffer(p236, n155)
						v2380.is_subscribed = prop_types.BoolProp.decode(v2393)
					elseif v2382 == 10 then
						local v2394

						v2394, n155 = proto.readBuffer(p236, n155)
						v2380.price_display = prop_types.StringProp.decode(v2394)
					elseif v2382 == 11 then
						local v2395

						v2395, n155 = proto.readBuffer(p236, n155)
						v2380.price_in_robux = prop_types.Int64Prop.decode(v2395)
					elseif v2382 == 12 then
						local v2396

						v2396, n155 = proto.readBuffer(p236, n155)
						v2380.price_tier = prop_types.Int64Prop.decode(v2396)
					elseif v2382 == 13 then
						local v2397

						v2397, n155 = proto.readBuffer(p236, n155)
						v2380.thumbnail_string = prop_types.StringProp.decode(v2397)
					else
						local v2398, v2399 = proto.readVarInt(p236, n155)

						n155 = v2399 + v2398
					end
				elseif v2383 == proto.wireTypes.i32 then
					local v2400

					v2400, n155 = proto.readFixed32(p236, n155)
				elseif v2383 == proto.wireTypes.i64 then
					local v2401

					v2401, n155 = proto.readFixed64(p236, n155)
				else
					error("Unsupported wire type: " .. v2383)
				end
			end

			return v2380
		end
		function t311.jsonEncode(p237) -- line: 17081
			local t313 = {}

			if p237.subscription_id ~= nil then
				t313.subscriptionId = p237.subscription_id:jsonEncode()
			end

			if p237.universe_id ~= nil then
				t313.universeId = p237.universe_id:jsonEncode()
			end

			if p237.creator_name ~= nil then
				t313.creatorName = p237.creator_name:jsonEncode()
			end

			if p237.creator_verified ~= nil then
				t313.creatorVerified = p237.creator_verified:jsonEncode()
			end

			if p237.name ~= nil then
				t313.name = p237.name:jsonEncode()
			end

			if p237.description ~= nil then
				t313.description = p237.description:jsonEncode()
			end

			if p237.image_asset_id ~= nil then
				t313.imageAssetId = p237.image_asset_id:jsonEncode()
			end

			if p237.period_type ~= nil then
				t313.periodType = p237.period_type:jsonEncode()
			end

			if p237.is_subscribed ~= nil then
				t313.isSubscribed = p237.is_subscribed:jsonEncode()
			end

			if p237.price_display ~= nil then
				t313.priceDisplay = p237.price_display:jsonEncode()
			end

			if p237.price_in_robux ~= nil then
				t313.priceInRobux = p237.price_in_robux:jsonEncode()
			end

			if p237.price_tier ~= nil then
				t313.priceTier = p237.price_tier:jsonEncode()
			end

			if p237.thumbnail_string ~= nil then
				t313.thumbnailString = p237.thumbnail_string:jsonEncode()
			end

			return t313
		end
		function t311.jsonDecode(t314: {[any]: any}) -- line: 17141
			-- upvalues: t311 (copy), prop_types (copy)
			local v2405 = t311.new()

			if t314.subscription_id ~= nil then
				v2405.subscription_id = prop_types.StringProp.jsonDecode(t314.subscription_id)
			end

			if t314.subscriptionId ~= nil then
				v2405.subscription_id = prop_types.StringProp.jsonDecode(t314.subscriptionId)
			end

			if t314.universe_id ~= nil then
				v2405.universe_id = prop_types.StringProp.jsonDecode(t314.universe_id)
			end

			if t314.universeId ~= nil then
				v2405.universe_id = prop_types.StringProp.jsonDecode(t314.universeId)
			end

			if t314.creator_name ~= nil then
				v2405.creator_name = prop_types.StringProp.jsonDecode(t314.creator_name)
			end

			if t314.creatorName ~= nil then
				v2405.creator_name = prop_types.StringProp.jsonDecode(t314.creatorName)
			end

			if t314.creator_verified ~= nil then
				v2405.creator_verified = prop_types.BoolProp.jsonDecode(t314.creator_verified)
			end

			if t314.creatorVerified ~= nil then
				v2405.creator_verified = prop_types.BoolProp.jsonDecode(t314.creatorVerified)
			end

			if t314.name ~= nil then
				v2405.name = prop_types.StringProp.jsonDecode(t314.name)
			end

			if t314.description ~= nil then
				v2405.description = prop_types.StringProp.jsonDecode(t314.description)
			end

			if t314.image_asset_id ~= nil then
				v2405.image_asset_id = prop_types.Int64Prop.jsonDecode(t314.image_asset_id)
			end

			if t314.imageAssetId ~= nil then
				v2405.image_asset_id = prop_types.Int64Prop.jsonDecode(t314.imageAssetId)
			end

			if t314.period_type ~= nil then
				v2405.period_type = prop_types.StringProp.jsonDecode(t314.period_type)
			end

			if t314.periodType ~= nil then
				v2405.period_type = prop_types.StringProp.jsonDecode(t314.periodType)
			end

			if t314.is_subscribed ~= nil then
				v2405.is_subscribed = prop_types.BoolProp.jsonDecode(t314.is_subscribed)
			end

			if t314.isSubscribed ~= nil then
				v2405.is_subscribed = prop_types.BoolProp.jsonDecode(t314.isSubscribed)
			end

			if t314.price_display ~= nil then
				v2405.price_display = prop_types.StringProp.jsonDecode(t314.price_display)
			end

			if t314.priceDisplay ~= nil then
				v2405.price_display = prop_types.StringProp.jsonDecode(t314.priceDisplay)
			end

			if t314.price_in_robux ~= nil then
				v2405.price_in_robux = prop_types.Int64Prop.jsonDecode(t314.price_in_robux)
			end

			if t314.priceInRobux ~= nil then
				v2405.price_in_robux = prop_types.Int64Prop.jsonDecode(t314.priceInRobux)
			end

			if t314.price_tier ~= nil then
				v2405.price_tier = prop_types.Int64Prop.jsonDecode(t314.price_tier)
			end

			if t314.priceTier ~= nil then
				v2405.price_tier = prop_types.Int64Prop.jsonDecode(t314.priceTier)
			end

			if t314.thumbnail_string ~= nil then
				v2405.thumbnail_string = prop_types.StringProp.jsonDecode(t314.thumbnail_string)
			end

			if t314.thumbnailString ~= nil then
				v2405.thumbnail_string = prop_types.StringProp.jsonDecode(t314.thumbnailString)
			end

			return v2405
		end

		t311.descriptor = {
			name = "OpenSubscriptionPurchasePageAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenSubscriptionPurchasePageAction_Params = t311
		typeRegistry.default:register(t1.OpenSubscriptionPurchasePageAction_Params)

		local t315 = {}

		t315.__index = t315

		function t315.new(t316: {[any]: any}?) -- line: 17278
			-- upvalues: t1 (copy), t315 (copy)
			return (setmetatable({
				action_type = if t316 ~= nil and t316.action_type ~= nil then t316.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t316 ~= nil and t316.action_params ~= nil then t316.action_params else nil
			}, t315))
		end
		function t315.encode(p238) -- line: 17287
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n156 = 0

			if p238.action_type ~= nil and (p238.action_type ~= nil and p238.action_type ~= 0 or p238.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2410, v2411 = proto.writeTag(buf, n156, 1, proto.wireTypes.varint)

				buf, n156 = proto.writeVarInt(v2410, v2411, t1.ActionType.toNumber(p238.action_type))
			end

			if p238.action_params ~= nil then
				local v2412 = p238.action_params:encode()
				local v2413, v2414 = proto.writeTag(buf, n156, 2, proto.wireTypes.lengthDelimited)

				buf, n156 = proto.writeBuffer(v2413, v2414, v2412, buffer.len(v2412))
			end

			local buf81 = buffer.create(n156)

			buffer.copy(buf81, 0, buf, 0, n156)

			return buf81
		end
		function t315.decode(p239: buffer) -- line: 17313
			-- upvalues: t315 (copy), proto (copy), t1 (copy)
			local v2417 = t315.new()
			local n157 = 0

			while n157 < buffer.len(p239) do
				local v2419, v2420

				v2419, v2420, n157 = proto.readTag(p239, n157)

				if v2420 == proto.wireTypes.varint then
					if v2419 == 1 then
						local v2421

						v2421, n157 = proto.readVarIntI32(p239, n157)
						v2417.action_type = t1.ActionType.fromNumber(v2421) or v2421
					else
						local v2422

						v2422, n157 = proto.readVarInt(p239, n157)
					end
				elseif v2420 == proto.wireTypes.lengthDelimited then
					if v2419 == 2 then
						local v2423

						v2423, n157 = proto.readBuffer(p239, n157)
						v2417.action_params = t1.RefreshGamePassesAction_Params.decode(v2423)
					else
						local v2424, v2425 = proto.readVarInt(p239, n157)

						n157 = v2425 + v2424
					end
				elseif v2420 == proto.wireTypes.i32 then
					local v2426

					v2426, n157 = proto.readFixed32(p239, n157)
				elseif v2420 == proto.wireTypes.i64 then
					local v2427

					v2427, n157 = proto.readFixed64(p239, n157)
				else
					error("Unsupported wire type: " .. v2420)
				end
			end

			return v2417
		end
		function t315.jsonEncode(p240) -- line: 17361
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
		function t315.jsonDecode(t318: {[any]: any}) -- line: 17383
			-- upvalues: t315 (copy), t1 (copy)
			local v2431 = t315.new()

			if t318.action_type ~= nil then
				v2431.action_type = if typeof(t318.action_type) ~= "number" then t1.ActionType.fromName(t318.action_type) or t318.action_type else t1.ActionType.fromNumber(t318.action_type) or t318.action_type
			end

			if t318.actionType ~= nil then
				v2431.action_type = if typeof(t318.actionType) ~= "number" then t1.ActionType.fromName(t318.actionType) or t318.actionType else t1.ActionType.fromNumber(t318.actionType) or t318.actionType
			end

			if t318.action_params ~= nil then
				v2431.action_params = t1.RefreshGamePassesAction_Params.jsonDecode(t318.action_params)
			end

			if t318.actionParams ~= nil then
				v2431.action_params = t1.RefreshGamePassesAction_Params.jsonDecode(t318.actionParams)
			end

			return v2431
		end

		t315.descriptor = {
			name = "RefreshGamePassesAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.RefreshGamePassesAction"
		}
		t1.RefreshGamePassesAction = t315
	end

	typeRegistry.default:register(t1.RefreshGamePassesAction)

	do
		local t319 = {}

		t319.__index = t319

		function t319.new(t320: {[any]: any}?) -- line: 17423
			-- upvalues: t319 (copy)
			return (setmetatable({
				universe_id = if t320 ~= nil and t320.universe_id ~= nil then t320.universe_id else nil
			}, t319))
		end
		function t319.encode(p241) -- line: 17431
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n158 = 0

			if p241.universe_id ~= nil then
				local v2436 = p241.universe_id:encode()
				local v2437, v2438 = proto.writeTag(buf, n158, 1, proto.wireTypes.lengthDelimited)

				buf, n158 = proto.writeBuffer(v2437, v2438, v2436, buffer.len(v2436))
			end

			local buf82 = buffer.create(n158)

			buffer.copy(buf82, 0, buf, 0, n158)

			return buf82
		end
		function t319.decode(p242: buffer) -- line: 17446
			-- upvalues: t319 (copy), proto (copy), prop_types (copy)
			local v2441 = t319.new()
			local n159 = 0

			while n159 < buffer.len(p242) do
				local v2443, v2444

				v2443, v2444, n159 = proto.readTag(p242, n159)

				if v2444 == proto.wireTypes.varint then
					local v2445

					v2445, n159 = proto.readVarInt(p242, n159)
				elseif v2444 == proto.wireTypes.lengthDelimited then
					if v2443 == 1 then
						local v2446

						v2446, n159 = proto.readBuffer(p242, n159)
						v2441.universe_id = prop_types.StringProp.decode(v2446)
					else
						local v2447, v2448 = proto.readVarInt(p242, n159)

						n159 = v2448 + v2447
					end
				elseif v2444 == proto.wireTypes.i32 then
					local v2449

					v2449, n159 = proto.readFixed32(p242, n159)
				elseif v2444 == proto.wireTypes.i64 then
					local v2450

					v2450, n159 = proto.readFixed64(p242, n159)
				else
					error("Unsupported wire type: " .. v2444)
				end
			end

			return v2441
		end
		function t319.jsonEncode(p243) -- line: 17489
			local t321 = {}

			if p243.universe_id ~= nil then
				t321.universeId = p243.universe_id:jsonEncode()
			end

			return t321
		end
		function t319.jsonDecode(t322: {[any]: any}) -- line: 17499
			-- upvalues: t319 (copy), prop_types (copy)
			local v2454 = t319.new()

			if t322.universe_id ~= nil then
				v2454.universe_id = prop_types.StringProp.jsonDecode(t322.universe_id)
			end

			if t322.universeId ~= nil then
				v2454.universe_id = prop_types.StringProp.jsonDecode(t322.universeId)
			end

			return v2454
		end

		t319.descriptor = {
			name = "RefreshGamePassesAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.RefreshGamePassesAction_Params = t319
		typeRegistry.default:register(t1.RefreshGamePassesAction_Params)

		local t323 = {}

		t323.__index = t323

		function t323.new(t324: {[any]: any}?) -- line: 17528
			-- upvalues: t1 (copy), t323 (copy)
			return (setmetatable({
				action_type = if t324 ~= nil and t324.action_type ~= nil then t324.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t324 ~= nil and t324.action_params ~= nil then t324.action_params else nil
			}, t323))
		end
		function t323.encode(p244) -- line: 17537
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n160 = 0

			if p244.action_type ~= nil and (p244.action_type ~= nil and p244.action_type ~= 0 or p244.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2459, v2460 = proto.writeTag(buf, n160, 1, proto.wireTypes.varint)

				buf, n160 = proto.writeVarInt(v2459, v2460, t1.ActionType.toNumber(p244.action_type))
			end

			if p244.action_params ~= nil then
				local v2461 = p244.action_params:encode()
				local v2462, v2463 = proto.writeTag(buf, n160, 2, proto.wireTypes.lengthDelimited)

				buf, n160 = proto.writeBuffer(v2462, v2463, v2461, buffer.len(v2461))
			end

			local buf83 = buffer.create(n160)

			buffer.copy(buf83, 0, buf, 0, n160)

			return buf83
		end
		function t323.decode(p245: buffer) -- line: 17563
			-- upvalues: t323 (copy), proto (copy), t1 (copy)
			local v2466 = t323.new()
			local n161 = 0

			while n161 < buffer.len(p245) do
				local v2468, v2469

				v2468, v2469, n161 = proto.readTag(p245, n161)

				if v2469 == proto.wireTypes.varint then
					if v2468 == 1 then
						local v2470

						v2470, n161 = proto.readVarIntI32(p245, n161)
						v2466.action_type = t1.ActionType.fromNumber(v2470) or v2470
					else
						local v2471

						v2471, n161 = proto.readVarInt(p245, n161)
					end
				elseif v2469 == proto.wireTypes.lengthDelimited then
					if v2468 == 2 then
						local v2472

						v2472, n161 = proto.readBuffer(p245, n161)
						v2466.action_params = t1.RefreshPlayabilityAction_Params.decode(v2472)
					else
						local v2473, v2474 = proto.readVarInt(p245, n161)

						n161 = v2474 + v2473
					end
				elseif v2469 == proto.wireTypes.i32 then
					local v2475

					v2475, n161 = proto.readFixed32(p245, n161)
				elseif v2469 == proto.wireTypes.i64 then
					local v2476

					v2476, n161 = proto.readFixed64(p245, n161)
				else
					error("Unsupported wire type: " .. v2469)
				end
			end

			return v2466
		end
		function t323.jsonEncode(p246) -- line: 17611
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
		function t323.jsonDecode(t326: {[any]: any}) -- line: 17633
			-- upvalues: t323 (copy), t1 (copy)
			local v2480 = t323.new()

			if t326.action_type ~= nil then
				v2480.action_type = if typeof(t326.action_type) ~= "number" then t1.ActionType.fromName(t326.action_type) or t326.action_type else t1.ActionType.fromNumber(t326.action_type) or t326.action_type
			end

			if t326.actionType ~= nil then
				v2480.action_type = if typeof(t326.actionType) ~= "number" then t1.ActionType.fromName(t326.actionType) or t326.actionType else t1.ActionType.fromNumber(t326.actionType) or t326.actionType
			end

			if t326.action_params ~= nil then
				v2480.action_params = t1.RefreshPlayabilityAction_Params.jsonDecode(t326.action_params)
			end

			if t326.actionParams ~= nil then
				v2480.action_params = t1.RefreshPlayabilityAction_Params.jsonDecode(t326.actionParams)
			end

			return v2480
		end

		t323.descriptor = {
			name = "RefreshPlayabilityAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.RefreshPlayabilityAction"
		}
		t1.RefreshPlayabilityAction = t323
	end

	typeRegistry.default:register(t1.RefreshPlayabilityAction)

	do
		local t327 = {}

		t327.__index = t327

		function t327.new(t328: {[any]: any}?) -- line: 17673
			-- upvalues: t327 (copy)
			return (setmetatable({
				universe_id = if t328 ~= nil and t328.universe_id ~= nil then t328.universe_id else nil
			}, t327))
		end
		function t327.encode(p247) -- line: 17681
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n162 = 0

			if p247.universe_id ~= nil then
				local v2485 = p247.universe_id:encode()
				local v2486, v2487 = proto.writeTag(buf, n162, 1, proto.wireTypes.lengthDelimited)

				buf, n162 = proto.writeBuffer(v2486, v2487, v2485, buffer.len(v2485))
			end

			local buf84 = buffer.create(n162)

			buffer.copy(buf84, 0, buf, 0, n162)

			return buf84
		end
		function t327.decode(p248: buffer) -- line: 17696
			-- upvalues: t327 (copy), proto (copy), prop_types (copy)
			local v2490 = t327.new()
			local n163 = 0

			while n163 < buffer.len(p248) do
				local v2492, v2493

				v2492, v2493, n163 = proto.readTag(p248, n163)

				if v2493 == proto.wireTypes.varint then
					local v2494

					v2494, n163 = proto.readVarInt(p248, n163)
				elseif v2493 == proto.wireTypes.lengthDelimited then
					if v2492 == 1 then
						local v2495

						v2495, n163 = proto.readBuffer(p248, n163)
						v2490.universe_id = prop_types.StringProp.decode(v2495)
					else
						local v2496, v2497 = proto.readVarInt(p248, n163)

						n163 = v2497 + v2496
					end
				elseif v2493 == proto.wireTypes.i32 then
					local v2498

					v2498, n163 = proto.readFixed32(p248, n163)
				elseif v2493 == proto.wireTypes.i64 then
					local v2499

					v2499, n163 = proto.readFixed64(p248, n163)
				else
					error("Unsupported wire type: " .. v2493)
				end
			end

			return v2490
		end
		function t327.jsonEncode(p249) -- line: 17739
			local t329 = {}

			if p249.universe_id ~= nil then
				t329.universeId = p249.universe_id:jsonEncode()
			end

			return t329
		end
		function t327.jsonDecode(t330: {[any]: any}) -- line: 17749
			-- upvalues: t327 (copy), prop_types (copy)
			local v2503 = t327.new()

			if t330.universe_id ~= nil then
				v2503.universe_id = prop_types.StringProp.jsonDecode(t330.universe_id)
			end

			if t330.universeId ~= nil then
				v2503.universe_id = prop_types.StringProp.jsonDecode(t330.universeId)
			end

			return v2503
		end

		t327.descriptor = {
			name = "RefreshPlayabilityAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.RefreshPlayabilityAction_Params = t327
		typeRegistry.default:register(t1.RefreshPlayabilityAction_Params)

		local t331 = {}

		t331.__index = t331

		function t331.new(t332: {[any]: any}?) -- line: 17778
			-- upvalues: t1 (copy), t331 (copy)
			return (setmetatable({
				action_type = if t332 ~= nil and t332.action_type ~= nil then t332.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t332 ~= nil and t332.action_params ~= nil then t332.action_params else nil
			}, t331))
		end
		function t331.encode(p250) -- line: 17789
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n164 = 0

			if p250.action_type ~= nil and (p250.action_type ~= nil and p250.action_type ~= 0 or p250.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2508, v2509 = proto.writeTag(buf, n164, 1, proto.wireTypes.varint)

				buf, n164 = proto.writeVarInt(v2508, v2509, t1.ActionType.toNumber(p250.action_type))
			end

			if p250.action_params ~= nil then
				local v2510 = p250.action_params:encode()
				local v2511, v2512 = proto.writeTag(buf, n164, 2, proto.wireTypes.lengthDelimited)

				buf, n164 = proto.writeBuffer(v2511, v2512, v2510, buffer.len(v2510))
			end

			local buf85 = buffer.create(n164)

			buffer.copy(buf85, 0, buf, 0, n164)

			return buf85
		end
		function t331.decode(p251: buffer) -- line: 17815
			-- upvalues: t331 (copy), proto (copy), t1 (copy)
			local v2515 = t331.new()
			local n165 = 0

			while n165 < buffer.len(p251) do
				local v2517, v2518

				v2517, v2518, n165 = proto.readTag(p251, n165)

				if v2518 == proto.wireTypes.varint then
					if v2517 == 1 then
						local v2519

						v2519, n165 = proto.readVarIntI32(p251, n165)
						v2515.action_type = t1.ActionType.fromNumber(v2519) or v2519
					else
						local v2520

						v2520, n165 = proto.readVarInt(p251, n165)
					end
				elseif v2518 == proto.wireTypes.lengthDelimited then
					if v2517 == 2 then
						local v2521

						v2521, n165 = proto.readBuffer(p251, n165)
						v2515.action_params = t1.RefreshDeveloperProductsAction_Params.decode(v2521)
					else
						local v2522, v2523 = proto.readVarInt(p251, n165)

						n165 = v2523 + v2522
					end
				elseif v2518 == proto.wireTypes.i32 then
					local v2524

					v2524, n165 = proto.readFixed32(p251, n165)
				elseif v2518 == proto.wireTypes.i64 then
					local v2525

					v2525, n165 = proto.readFixed64(p251, n165)
				else
					error("Unsupported wire type: " .. v2518)
				end
			end

			return v2515
		end
		function t331.jsonEncode(p252) -- line: 17863
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
		function t331.jsonDecode(t334: {[any]: any}) -- line: 17885
			-- upvalues: t331 (copy), t1 (copy)
			local v2529 = t331.new()

			if t334.action_type ~= nil then
				v2529.action_type = if typeof(t334.action_type) ~= "number" then t1.ActionType.fromName(t334.action_type) or t334.action_type else t1.ActionType.fromNumber(t334.action_type) or t334.action_type
			end

			if t334.actionType ~= nil then
				v2529.action_type = if typeof(t334.actionType) ~= "number" then t1.ActionType.fromName(t334.actionType) or t334.actionType else t1.ActionType.fromNumber(t334.actionType) or t334.actionType
			end

			if t334.action_params ~= nil then
				v2529.action_params = t1.RefreshDeveloperProductsAction_Params.jsonDecode(t334.action_params)
			end

			if t334.actionParams ~= nil then
				v2529.action_params = t1.RefreshDeveloperProductsAction_Params.jsonDecode(t334.actionParams)
			end

			return v2529
		end

		t331.descriptor = {
			name = "RefreshDeveloperProductsAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.RefreshDeveloperProductsAction"
		}
		t1.RefreshDeveloperProductsAction = t331
	end

	typeRegistry.default:register(t1.RefreshDeveloperProductsAction)

	do
		local t335 = {}

		t335.__index = t335

		function t335.new(t336: {[any]: any}?) -- line: 17925
			-- upvalues: t335 (copy)
			return (setmetatable({
				place_id = if t336 ~= nil and t336.place_id ~= nil then t336.place_id else nil
			}, t335))
		end
		function t335.encode(p253) -- line: 17933
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n166 = 0

			if p253.place_id ~= nil then
				local v2534 = p253.place_id:encode()
				local v2535, v2536 = proto.writeTag(buf, n166, 1, proto.wireTypes.lengthDelimited)

				buf, n166 = proto.writeBuffer(v2535, v2536, v2534, buffer.len(v2534))
			end

			local buf86 = buffer.create(n166)

			buffer.copy(buf86, 0, buf, 0, n166)

			return buf86
		end
		function t335.decode(p254: buffer) -- line: 17948
			-- upvalues: t335 (copy), proto (copy), prop_types (copy)
			local v2539 = t335.new()
			local n167 = 0

			while n167 < buffer.len(p254) do
				local v2541, v2542

				v2541, v2542, n167 = proto.readTag(p254, n167)

				if v2542 == proto.wireTypes.varint then
					local v2543

					v2543, n167 = proto.readVarInt(p254, n167)
				elseif v2542 == proto.wireTypes.lengthDelimited then
					if v2541 == 1 then
						local v2544

						v2544, n167 = proto.readBuffer(p254, n167)
						v2539.place_id = prop_types.StringProp.decode(v2544)
					else
						local v2545, v2546 = proto.readVarInt(p254, n167)

						n167 = v2546 + v2545
					end
				elseif v2542 == proto.wireTypes.i32 then
					local v2547

					v2547, n167 = proto.readFixed32(p254, n167)
				elseif v2542 == proto.wireTypes.i64 then
					local v2548

					v2548, n167 = proto.readFixed64(p254, n167)
				else
					error("Unsupported wire type: " .. v2542)
				end
			end

			return v2539
		end
		function t335.jsonEncode(p255) -- line: 17991
			local t337 = {}

			if p255.place_id ~= nil then
				t337.placeId = p255.place_id:jsonEncode()
			end

			return t337
		end
		function t335.jsonDecode(t338: {[any]: any}) -- line: 18001
			-- upvalues: t335 (copy), prop_types (copy)
			local v2552 = t335.new()

			if t338.place_id ~= nil then
				v2552.place_id = prop_types.StringProp.jsonDecode(t338.place_id)
			end

			if t338.placeId ~= nil then
				v2552.place_id = prop_types.StringProp.jsonDecode(t338.placeId)
			end

			return v2552
		end

		t335.descriptor = {
			name = "RefreshDeveloperProductsAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.RefreshDeveloperProductsAction_Params = t335
		typeRegistry.default:register(t1.RefreshDeveloperProductsAction_Params)

		local t339 = {}

		t339.__index = t339

		function t339.new(t340: {[any]: any}?) -- line: 18031
			-- upvalues: t1 (copy), t339 (copy)
			return (setmetatable({
				action_type = if t340 ~= nil and t340.action_type ~= nil then t340.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t340 ~= nil and t340.action_params ~= nil then t340.action_params else nil
			}, t339))
		end
		function t339.encode(p256) -- line: 18040
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n168 = 0

			if p256.action_type ~= nil and (p256.action_type ~= nil and p256.action_type ~= 0 or p256.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2557, v2558 = proto.writeTag(buf, n168, 1, proto.wireTypes.varint)

				buf, n168 = proto.writeVarInt(v2557, v2558, t1.ActionType.toNumber(p256.action_type))
			end

			if p256.action_params ~= nil then
				local v2559 = p256.action_params:encode()
				local v2560, v2561 = proto.writeTag(buf, n168, 2, proto.wireTypes.lengthDelimited)

				buf, n168 = proto.writeBuffer(v2560, v2561, v2559, buffer.len(v2559))
			end

			local buf87 = buffer.create(n168)

			buffer.copy(buf87, 0, buf, 0, n168)

			return buf87
		end
		function t339.decode(p257: buffer) -- line: 18066
			-- upvalues: t339 (copy), proto (copy), t1 (copy)
			local v2564 = t339.new()
			local n169 = 0

			while n169 < buffer.len(p257) do
				local v2566, v2567

				v2566, v2567, n169 = proto.readTag(p257, n169)

				if v2567 == proto.wireTypes.varint then
					if v2566 == 1 then
						local v2568

						v2568, n169 = proto.readVarIntI32(p257, n169)
						v2564.action_type = t1.ActionType.fromNumber(v2568) or v2568
					else
						local v2569

						v2569, n169 = proto.readVarInt(p257, n169)
					end
				elseif v2567 == proto.wireTypes.lengthDelimited then
					if v2566 == 2 then
						local v2570

						v2570, n169 = proto.readBuffer(p257, n169)
						v2564.action_params = t1.OpenFaeTrialUpsellAction_Params.decode(v2570)
					else
						local v2571, v2572 = proto.readVarInt(p257, n169)

						n169 = v2572 + v2571
					end
				elseif v2567 == proto.wireTypes.i32 then
					local v2573

					v2573, n169 = proto.readFixed32(p257, n169)
				elseif v2567 == proto.wireTypes.i64 then
					local v2574

					v2574, n169 = proto.readFixed64(p257, n169)
				else
					error("Unsupported wire type: " .. v2567)
				end
			end

			return v2564
		end
		function t339.jsonEncode(p258) -- line: 18114
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
		function t339.jsonDecode(t342: {[any]: any}) -- line: 18136
			-- upvalues: t339 (copy), t1 (copy)
			local v2578 = t339.new()

			if t342.action_type ~= nil then
				v2578.action_type = if typeof(t342.action_type) ~= "number" then t1.ActionType.fromName(t342.action_type) or t342.action_type else t1.ActionType.fromNumber(t342.action_type) or t342.action_type
			end

			if t342.actionType ~= nil then
				v2578.action_type = if typeof(t342.actionType) ~= "number" then t1.ActionType.fromName(t342.actionType) or t342.actionType else t1.ActionType.fromNumber(t342.actionType) or t342.actionType
			end

			if t342.action_params ~= nil then
				v2578.action_params = t1.OpenFaeTrialUpsellAction_Params.jsonDecode(t342.action_params)
			end

			if t342.actionParams ~= nil then
				v2578.action_params = t1.OpenFaeTrialUpsellAction_Params.jsonDecode(t342.actionParams)
			end

			return v2578
		end

		t339.descriptor = {
			name = "OpenFaeTrialUpsellAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenFaeTrialUpsellAction"
		}
		t1.OpenFaeTrialUpsellAction = t339
	end

	typeRegistry.default:register(t1.OpenFaeTrialUpsellAction)

	do
		local t343 = {}

		t343.__index = t343

		function t343.new(t344: {[any]: any}?) -- line: 18176
			-- upvalues: t343 (copy)
			return (setmetatable({
				source = if t344 ~= nil and t344.source ~= nil then t344.source else nil,
				config_key = if t344 ~= nil and t344.config_key ~= nil then t344.config_key else nil,
				surface_key = if t344 ~= nil and t344.surface_key ~= nil then t344.surface_key else nil,
				prompt_type = if t344 ~= nil and t344.prompt_type ~= nil then t344.prompt_type else nil
			}, t343))
		end
		function t343.encode(p259) -- line: 18187
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n170 = 0

			if p259.source ~= nil then
				local v2583 = p259.source:encode()
				local v2584, v2585 = proto.writeTag(buf, n170, 1, proto.wireTypes.lengthDelimited)

				buf, n170 = proto.writeBuffer(v2584, v2585, v2583, buffer.len(v2583))
			end

			if p259.config_key ~= nil then
				local v2586 = p259.config_key:encode()
				local v2587, v2588 = proto.writeTag(buf, n170, 2, proto.wireTypes.lengthDelimited)

				buf, n170 = proto.writeBuffer(v2587, v2588, v2586, buffer.len(v2586))
			end

			if p259.surface_key ~= nil then
				local v2589 = p259.surface_key:encode()
				local v2590, v2591 = proto.writeTag(buf, n170, 3, proto.wireTypes.lengthDelimited)

				buf, n170 = proto.writeBuffer(v2590, v2591, v2589, buffer.len(v2589))
			end

			if p259.prompt_type ~= nil then
				local v2592 = p259.prompt_type:encode()
				local v2593, v2594 = proto.writeTag(buf, n170, 4, proto.wireTypes.lengthDelimited)

				buf, n170 = proto.writeBuffer(v2593, v2594, v2592, buffer.len(v2592))
			end

			local buf88 = buffer.create(n170)

			buffer.copy(buf88, 0, buf, 0, n170)

			return buf88
		end
		function t343.decode(p260: buffer) -- line: 18220
			-- upvalues: t343 (copy), proto (copy), prop_types (copy)
			local v2597 = t343.new()
			local n171 = 0

			while n171 < buffer.len(p260) do
				local v2599, v2600

				v2599, v2600, n171 = proto.readTag(p260, n171)

				if v2600 == proto.wireTypes.varint then
					local v2601

					v2601, n171 = proto.readVarInt(p260, n171)
				elseif v2600 == proto.wireTypes.lengthDelimited then
					if v2599 == 1 then
						local v2602

						v2602, n171 = proto.readBuffer(p260, n171)
						v2597.source = prop_types.StringProp.decode(v2602)
					elseif v2599 == 2 then
						local v2603

						v2603, n171 = proto.readBuffer(p260, n171)
						v2597.config_key = prop_types.StringProp.decode(v2603)
					elseif v2599 == 3 then
						local v2604

						v2604, n171 = proto.readBuffer(p260, n171)
						v2597.surface_key = prop_types.StringProp.decode(v2604)
					elseif v2599 == 4 then
						local v2605

						v2605, n171 = proto.readBuffer(p260, n171)
						v2597.prompt_type = prop_types.StringProp.decode(v2605)
					else
						local v2606, v2607 = proto.readVarInt(p260, n171)

						n171 = v2607 + v2606
					end
				elseif v2600 == proto.wireTypes.i32 then
					local v2608

					v2608, n171 = proto.readFixed32(p260, n171)
				elseif v2600 == proto.wireTypes.i64 then
					local v2609

					v2609, n171 = proto.readFixed64(p260, n171)
				else
					error("Unsupported wire type: " .. v2600)
				end
			end

			return v2597
		end
		function t343.jsonEncode(p261) -- line: 18278
			local t345 = {}

			if p261.source ~= nil then
				t345.source = p261.source:jsonEncode()
			end

			if p261.config_key ~= nil then
				t345.configKey = p261.config_key:jsonEncode()
			end

			if p261.surface_key ~= nil then
				t345.surfaceKey = p261.surface_key:jsonEncode()
			end

			if p261.prompt_type ~= nil then
				t345.promptType = p261.prompt_type:jsonEncode()
			end

			return t345
		end
		function t343.jsonDecode(t346: {[any]: any}) -- line: 18300
			-- upvalues: t343 (copy), prop_types (copy)
			local v2613 = t343.new()

			if t346.source ~= nil then
				v2613.source = prop_types.StringProp.jsonDecode(t346.source)
			end

			if t346.config_key ~= nil then
				v2613.config_key = prop_types.StringProp.jsonDecode(t346.config_key)
			end

			if t346.configKey ~= nil then
				v2613.config_key = prop_types.StringProp.jsonDecode(t346.configKey)
			end

			if t346.surface_key ~= nil then
				v2613.surface_key = prop_types.StringProp.jsonDecode(t346.surface_key)
			end

			if t346.surfaceKey ~= nil then
				v2613.surface_key = prop_types.StringProp.jsonDecode(t346.surfaceKey)
			end

			if t346.prompt_type ~= nil then
				v2613.prompt_type = prop_types.StringProp.jsonDecode(t346.prompt_type)
			end

			if t346.promptType ~= nil then
				v2613.prompt_type = prop_types.StringProp.jsonDecode(t346.promptType)
			end

			return v2613
		end

		t343.descriptor = {
			name = "OpenFaeTrialUpsellAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenFaeTrialUpsellAction_Params = t343
		typeRegistry.default:register(t1.OpenFaeTrialUpsellAction_Params)

		local t347 = {}

		t347.__index = t347

		function t347.new(t348: {[any]: any}?) -- line: 18350
			-- upvalues: t1 (copy), t347 (copy)
			return (setmetatable({
				action_type = if t348 ~= nil and t348.action_type ~= nil then t348.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t348 ~= nil and t348.action_params ~= nil then t348.action_params else nil
			}, t347))
		end
		function t347.encode(p262) -- line: 18361
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n172 = 0

			if p262.action_type ~= nil and (p262.action_type ~= nil and p262.action_type ~= 0 or p262.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2618, v2619 = proto.writeTag(buf, n172, 1, proto.wireTypes.varint)

				buf, n172 = proto.writeVarInt(v2618, v2619, t1.ActionType.toNumber(p262.action_type))
			end

			if p262.action_params ~= nil then
				local v2620 = p262.action_params:encode()
				local v2621, v2622 = proto.writeTag(buf, n172, 2, proto.wireTypes.lengthDelimited)

				buf, n172 = proto.writeBuffer(v2621, v2622, v2620, buffer.len(v2620))
			end

			local buf89 = buffer.create(n172)

			buffer.copy(buf89, 0, buf, 0, n172)

			return buf89
		end
		function t347.decode(p263: buffer) -- line: 18387
			-- upvalues: t347 (copy), proto (copy), t1 (copy)
			local v2625 = t347.new()
			local n173 = 0

			while n173 < buffer.len(p263) do
				local v2627, v2628

				v2627, v2628, n173 = proto.readTag(p263, n173)

				if v2628 == proto.wireTypes.varint then
					if v2627 == 1 then
						local v2629

						v2629, n173 = proto.readVarIntI32(p263, n173)
						v2625.action_type = t1.ActionType.fromNumber(v2629) or v2629
					else
						local v2630

						v2630, n173 = proto.readVarInt(p263, n173)
					end
				elseif v2628 == proto.wireTypes.lengthDelimited then
					if v2627 == 2 then
						local v2631

						v2631, n173 = proto.readBuffer(p263, n173)
						v2625.action_params = t1.OpenIncomingTransferUpsellAction_Params.decode(v2631)
					else
						local v2632, v2633 = proto.readVarInt(p263, n173)

						n173 = v2633 + v2632
					end
				elseif v2628 == proto.wireTypes.i32 then
					local v2634

					v2634, n173 = proto.readFixed32(p263, n173)
				elseif v2628 == proto.wireTypes.i64 then
					local v2635

					v2635, n173 = proto.readFixed64(p263, n173)
				else
					error("Unsupported wire type: " .. v2628)
				end
			end

			return v2625
		end
		function t347.jsonEncode(p264) -- line: 18435
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
		function t347.jsonDecode(t350: {[any]: any}) -- line: 18457
			-- upvalues: t347 (copy), t1 (copy)
			local v2639 = t347.new()

			if t350.action_type ~= nil then
				v2639.action_type = if typeof(t350.action_type) ~= "number" then t1.ActionType.fromName(t350.action_type) or t350.action_type else t1.ActionType.fromNumber(t350.action_type) or t350.action_type
			end

			if t350.actionType ~= nil then
				v2639.action_type = if typeof(t350.actionType) ~= "number" then t1.ActionType.fromName(t350.actionType) or t350.actionType else t1.ActionType.fromNumber(t350.actionType) or t350.actionType
			end

			if t350.action_params ~= nil then
				v2639.action_params = t1.OpenIncomingTransferUpsellAction_Params.jsonDecode(t350.action_params)
			end

			if t350.actionParams ~= nil then
				v2639.action_params = t1.OpenIncomingTransferUpsellAction_Params.jsonDecode(t350.actionParams)
			end

			return v2639
		end

		t347.descriptor = {
			name = "OpenIncomingTransferUpsellAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenIncomingTransferUpsellAction"
		}
		t1.OpenIncomingTransferUpsellAction = t347
	end

	typeRegistry.default:register(t1.OpenIncomingTransferUpsellAction)

	do
		local t351 = {}

		t351.__index = t351

		function t351.new(t352: {[any]: any}?) -- line: 18499
			-- upvalues: t351 (copy)
			return (setmetatable({
				url = if t352 ~= nil and t352.url ~= nil then t352.url else nil,
				prompt_type = if t352 ~= nil and t352.prompt_type ~= nil then t352.prompt_type else nil,
				prompt_id = if t352 ~= nil and t352.prompt_id ~= nil then t352.prompt_id else nil
			}, t351))
		end
		function t351.encode(p265) -- line: 18509
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n174 = 0

			if p265.url ~= nil then
				local v2644 = p265.url:encode()
				local v2645, v2646 = proto.writeTag(buf, n174, 1, proto.wireTypes.lengthDelimited)

				buf, n174 = proto.writeBuffer(v2645, v2646, v2644, buffer.len(v2644))
			end

			if p265.prompt_type ~= nil then
				local v2647 = p265.prompt_type:encode()
				local v2648, v2649 = proto.writeTag(buf, n174, 2, proto.wireTypes.lengthDelimited)

				buf, n174 = proto.writeBuffer(v2648, v2649, v2647, buffer.len(v2647))
			end

			if p265.prompt_id ~= nil then
				local v2650 = p265.prompt_id:encode()
				local v2651, v2652 = proto.writeTag(buf, n174, 3, proto.wireTypes.lengthDelimited)

				buf, n174 = proto.writeBuffer(v2651, v2652, v2650, buffer.len(v2650))
			end

			local buf90 = buffer.create(n174)

			buffer.copy(buf90, 0, buf, 0, n174)

			return buf90
		end
		function t351.decode(p266: buffer) -- line: 18536
			-- upvalues: t351 (copy), proto (copy), prop_types (copy)
			local v2655 = t351.new()
			local n175 = 0

			while n175 < buffer.len(p266) do
				local v2657, v2658

				v2657, v2658, n175 = proto.readTag(p266, n175)

				if v2658 == proto.wireTypes.varint then
					local v2659

					v2659, n175 = proto.readVarInt(p266, n175)
				elseif v2658 == proto.wireTypes.lengthDelimited then
					if v2657 == 1 then
						local v2660

						v2660, n175 = proto.readBuffer(p266, n175)
						v2655.url = prop_types.StringProp.decode(v2660)
					elseif v2657 == 2 then
						local v2661

						v2661, n175 = proto.readBuffer(p266, n175)
						v2655.prompt_type = prop_types.StringProp.decode(v2661)
					elseif v2657 == 3 then
						local v2662

						v2662, n175 = proto.readBuffer(p266, n175)
						v2655.prompt_id = prop_types.StringProp.decode(v2662)
					else
						local v2663, v2664 = proto.readVarInt(p266, n175)

						n175 = v2664 + v2663
					end
				elseif v2658 == proto.wireTypes.i32 then
					local v2665

					v2665, n175 = proto.readFixed32(p266, n175)
				elseif v2658 == proto.wireTypes.i64 then
					local v2666

					v2666, n175 = proto.readFixed64(p266, n175)
				else
					error("Unsupported wire type: " .. v2658)
				end
			end

			return v2655
		end
		function t351.jsonEncode(p267) -- line: 18589
			local t353 = {}

			if p267.url ~= nil then
				t353.url = p267.url:jsonEncode()
			end

			if p267.prompt_type ~= nil then
				t353.promptType = p267.prompt_type:jsonEncode()
			end

			if p267.prompt_id ~= nil then
				t353.promptId = p267.prompt_id:jsonEncode()
			end

			return t353
		end
		function t351.jsonDecode(t354: {[any]: any}) -- line: 18607
			-- upvalues: t351 (copy), prop_types (copy)
			local v2670 = t351.new()

			if t354.url ~= nil then
				v2670.url = prop_types.StringProp.jsonDecode(t354.url)
			end

			if t354.prompt_type ~= nil then
				v2670.prompt_type = prop_types.StringProp.jsonDecode(t354.prompt_type)
			end

			if t354.promptType ~= nil then
				v2670.prompt_type = prop_types.StringProp.jsonDecode(t354.promptType)
			end

			if t354.prompt_id ~= nil then
				v2670.prompt_id = prop_types.StringProp.jsonDecode(t354.prompt_id)
			end

			if t354.promptId ~= nil then
				v2670.prompt_id = prop_types.StringProp.jsonDecode(t354.promptId)
			end

			return v2670
		end

		t351.descriptor = {
			name = "OpenIncomingTransferUpsellAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenIncomingTransferUpsellAction_Params = t351
		typeRegistry.default:register(t1.OpenIncomingTransferUpsellAction_Params)

		local t355 = {}

		t355.__index = t355

		function t355.new(t356: {[any]: any}?) -- line: 18650
			-- upvalues: t1 (copy), t355 (copy)
			return (setmetatable({
				action_type = if t356 ~= nil and t356.action_type ~= nil then t356.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t356 ~= nil and t356.action_params ~= nil then t356.action_params else nil
			}, t355))
		end
		function t355.encode(p268) -- line: 18659
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n176 = 0

			if p268.action_type ~= nil and (p268.action_type ~= nil and p268.action_type ~= 0 or p268.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2675, v2676 = proto.writeTag(buf, n176, 1, proto.wireTypes.varint)

				buf, n176 = proto.writeVarInt(v2675, v2676, t1.ActionType.toNumber(p268.action_type))
			end

			if p268.action_params ~= nil then
				local v2677 = p268.action_params:encode()
				local v2678, v2679 = proto.writeTag(buf, n176, 2, proto.wireTypes.lengthDelimited)

				buf, n176 = proto.writeBuffer(v2678, v2679, v2677, buffer.len(v2677))
			end

			local buf91 = buffer.create(n176)

			buffer.copy(buf91, 0, buf, 0, n176)

			return buf91
		end
		function t355.decode(p269: buffer) -- line: 18685
			-- upvalues: t355 (copy), proto (copy), t1 (copy)
			local v2682 = t355.new()
			local n177 = 0

			while n177 < buffer.len(p269) do
				local v2684, v2685

				v2684, v2685, n177 = proto.readTag(p269, n177)

				if v2685 == proto.wireTypes.varint then
					if v2684 == 1 then
						local v2686

						v2686, n177 = proto.readVarIntI32(p269, n177)
						v2682.action_type = t1.ActionType.fromNumber(v2686) or v2686
					else
						local v2687

						v2687, n177 = proto.readVarInt(p269, n177)
					end
				elseif v2685 == proto.wireTypes.lengthDelimited then
					if v2684 == 2 then
						local v2688

						v2688, n177 = proto.readBuffer(p269, n177)
						v2682.action_params = t1.OpenSduiOverlayAction_Params.decode(v2688)
					else
						local v2689, v2690 = proto.readVarInt(p269, n177)

						n177 = v2690 + v2689
					end
				elseif v2685 == proto.wireTypes.i32 then
					local v2691

					v2691, n177 = proto.readFixed32(p269, n177)
				elseif v2685 == proto.wireTypes.i64 then
					local v2692

					v2692, n177 = proto.readFixed64(p269, n177)
				else
					error("Unsupported wire type: " .. v2685)
				end
			end

			return v2682
		end
		function t355.jsonEncode(p270) -- line: 18733
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
		function t355.jsonDecode(t358: {[any]: any}) -- line: 18755
			-- upvalues: t355 (copy), t1 (copy)
			local v2696 = t355.new()

			if t358.action_type ~= nil then
				v2696.action_type = if typeof(t358.action_type) ~= "number" then t1.ActionType.fromName(t358.action_type) or t358.action_type else t1.ActionType.fromNumber(t358.action_type) or t358.action_type
			end

			if t358.actionType ~= nil then
				v2696.action_type = if typeof(t358.actionType) ~= "number" then t1.ActionType.fromName(t358.actionType) or t358.actionType else t1.ActionType.fromNumber(t358.actionType) or t358.actionType
			end

			if t358.action_params ~= nil then
				v2696.action_params = t1.OpenSduiOverlayAction_Params.jsonDecode(t358.action_params)
			end

			if t358.actionParams ~= nil then
				v2696.action_params = t1.OpenSduiOverlayAction_Params.jsonDecode(t358.actionParams)
			end

			return v2696
		end

		t355.descriptor = {
			name = "OpenSduiOverlayAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenSduiOverlayAction"
		}
		t1.OpenSduiOverlayAction = t355
	end

	typeRegistry.default:register(t1.OpenSduiOverlayAction)

	do
		local t359 = {}

		t359.__index = t359

		function t359.new(t360: {[any]: any}?) -- line: 18795
			-- upvalues: t359 (copy)
			return (setmetatable({
				config_key = if t360 ~= nil and t360.config_key ~= nil then t360.config_key else nil,
				identifier = if t360 ~= nil and t360.identifier ~= nil then t360.identifier else nil
			}, t359))
		end
		function t359.encode(p271) -- line: 18804
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n178 = 0

			if p271.config_key ~= nil then
				local v2701 = p271.config_key:encode()
				local v2702, v2703 = proto.writeTag(buf, n178, 1, proto.wireTypes.lengthDelimited)

				buf, n178 = proto.writeBuffer(v2702, v2703, v2701, buffer.len(v2701))
			end

			if p271.identifier ~= nil then
				local v2704 = p271.identifier:encode()
				local v2705, v2706 = proto.writeTag(buf, n178, 2, proto.wireTypes.lengthDelimited)

				buf, n178 = proto.writeBuffer(v2705, v2706, v2704, buffer.len(v2704))
			end

			local buf92 = buffer.create(n178)

			buffer.copy(buf92, 0, buf, 0, n178)

			return buf92
		end
		function t359.decode(p272: buffer) -- line: 18825
			-- upvalues: t359 (copy), proto (copy), prop_types (copy)
			local v2709 = t359.new()
			local n179 = 0

			while n179 < buffer.len(p272) do
				local v2711, v2712

				v2711, v2712, n179 = proto.readTag(p272, n179)

				if v2712 == proto.wireTypes.varint then
					local v2713

					v2713, n179 = proto.readVarInt(p272, n179)
				elseif v2712 == proto.wireTypes.lengthDelimited then
					if v2711 == 1 then
						local v2714

						v2714, n179 = proto.readBuffer(p272, n179)
						v2709.config_key = prop_types.StringProp.decode(v2714)
					elseif v2711 == 2 then
						local v2715

						v2715, n179 = proto.readBuffer(p272, n179)
						v2709.identifier = prop_types.StringProp.decode(v2715)
					else
						local v2716, v2717 = proto.readVarInt(p272, n179)

						n179 = v2717 + v2716
					end
				elseif v2712 == proto.wireTypes.i32 then
					local v2718

					v2718, n179 = proto.readFixed32(p272, n179)
				elseif v2712 == proto.wireTypes.i64 then
					local v2719

					v2719, n179 = proto.readFixed64(p272, n179)
				else
					error("Unsupported wire type: " .. v2712)
				end
			end

			return v2709
		end
		function t359.jsonEncode(p273) -- line: 18873
			local t361 = {}

			if p273.config_key ~= nil then
				t361.configKey = p273.config_key:jsonEncode()
			end

			if p273.identifier ~= nil then
				t361.identifier = p273.identifier:jsonEncode()
			end

			return t361
		end
		function t359.jsonDecode(t362: {[any]: any}) -- line: 18887
			-- upvalues: t359 (copy), prop_types (copy)
			local v2723 = t359.new()

			if t362.config_key ~= nil then
				v2723.config_key = prop_types.StringProp.jsonDecode(t362.config_key)
			end

			if t362.configKey ~= nil then
				v2723.config_key = prop_types.StringProp.jsonDecode(t362.configKey)
			end

			if t362.identifier ~= nil then
				v2723.identifier = prop_types.StringProp.jsonDecode(t362.identifier)
			end

			return v2723
		end

		t359.descriptor = {
			name = "OpenSduiOverlayAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenSduiOverlayAction_Params = t359
		typeRegistry.default:register(t1.OpenSduiOverlayAction_Params)

		local t363 = {}

		t363.__index = t363

		function t363.new(t364: {[any]: any}?) -- line: 18919
			-- upvalues: t1 (copy), t363 (copy)
			return (setmetatable({
				action_type = if t364 ~= nil and t364.action_type ~= nil then t364.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t364 ~= nil and t364.action_params ~= nil then t364.action_params else nil
			}, t363))
		end
		function t363.encode(p274) -- line: 18928
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n180 = 0

			if p274.action_type ~= nil and (p274.action_type ~= nil and p274.action_type ~= 0 or p274.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2728, v2729 = proto.writeTag(buf, n180, 1, proto.wireTypes.varint)

				buf, n180 = proto.writeVarInt(v2728, v2729, t1.ActionType.toNumber(p274.action_type))
			end

			if p274.action_params ~= nil then
				local v2730 = p274.action_params:encode()
				local v2731, v2732 = proto.writeTag(buf, n180, 2, proto.wireTypes.lengthDelimited)

				buf, n180 = proto.writeBuffer(v2731, v2732, v2730, buffer.len(v2730))
			end

			local buf93 = buffer.create(n180)

			buffer.copy(buf93, 0, buf, 0, n180)

			return buf93
		end
		function t363.decode(p275: buffer) -- line: 18954
			-- upvalues: t363 (copy), proto (copy), t1 (copy)
			local v2735 = t363.new()
			local n181 = 0

			while n181 < buffer.len(p275) do
				local v2737, v2738

				v2737, v2738, n181 = proto.readTag(p275, n181)

				if v2738 == proto.wireTypes.varint then
					if v2737 == 1 then
						local v2739

						v2739, n181 = proto.readVarIntI32(p275, n181)
						v2735.action_type = t1.ActionType.fromNumber(v2739) or v2739
					else
						local v2740

						v2740, n181 = proto.readVarInt(p275, n181)
					end
				elseif v2738 == proto.wireTypes.lengthDelimited then
					if v2737 == 2 then
						local v2741

						v2741, n181 = proto.readBuffer(p275, n181)
						v2735.action_params = t1.ApplyChartsFilterAction_Params.decode(v2741)
					else
						local v2742, v2743 = proto.readVarInt(p275, n181)

						n181 = v2743 + v2742
					end
				elseif v2738 == proto.wireTypes.i32 then
					local v2744

					v2744, n181 = proto.readFixed32(p275, n181)
				elseif v2738 == proto.wireTypes.i64 then
					local v2745

					v2745, n181 = proto.readFixed64(p275, n181)
				else
					error("Unsupported wire type: " .. v2738)
				end
			end

			return v2735
		end
		function t363.jsonEncode(p276) -- line: 19002
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
		function t363.jsonDecode(t366: {[any]: any}) -- line: 19024
			-- upvalues: t363 (copy), t1 (copy)
			local v2749 = t363.new()

			if t366.action_type ~= nil then
				v2749.action_type = if typeof(t366.action_type) ~= "number" then t1.ActionType.fromName(t366.action_type) or t366.action_type else t1.ActionType.fromNumber(t366.action_type) or t366.action_type
			end

			if t366.actionType ~= nil then
				v2749.action_type = if typeof(t366.actionType) ~= "number" then t1.ActionType.fromName(t366.actionType) or t366.actionType else t1.ActionType.fromNumber(t366.actionType) or t366.actionType
			end

			if t366.action_params ~= nil then
				v2749.action_params = t1.ApplyChartsFilterAction_Params.jsonDecode(t366.action_params)
			end

			if t366.actionParams ~= nil then
				v2749.action_params = t1.ApplyChartsFilterAction_Params.jsonDecode(t366.actionParams)
			end

			return v2749
		end

		t363.descriptor = {
			name = "ApplyChartsFilterAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.ApplyChartsFilterAction"
		}
		t1.ApplyChartsFilterAction = t363
	end

	typeRegistry.default:register(t1.ApplyChartsFilterAction)

	do
		local t367 = {}

		t367.__index = t367

		function t367.new(t368: {[any]: any}?) -- line: 19064
			-- upvalues: t367 (copy)
			return (setmetatable({
				session_id = if t368 ~= nil and t368.session_id ~= nil then t368.session_id else nil
			}, t367))
		end
		function t367.encode(p277) -- line: 19072
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n182 = 0

			if p277.session_id ~= nil then
				local v2754 = p277.session_id:encode()
				local v2755, v2756 = proto.writeTag(buf, n182, 1, proto.wireTypes.lengthDelimited)

				buf, n182 = proto.writeBuffer(v2755, v2756, v2754, buffer.len(v2754))
			end

			local buf94 = buffer.create(n182)

			buffer.copy(buf94, 0, buf, 0, n182)

			return buf94
		end
		function t367.decode(p278: buffer) -- line: 19087
			-- upvalues: t367 (copy), proto (copy), prop_types (copy)
			local v2759 = t367.new()
			local n183 = 0

			while n183 < buffer.len(p278) do
				local v2761, v2762

				v2761, v2762, n183 = proto.readTag(p278, n183)

				if v2762 == proto.wireTypes.varint then
					local v2763

					v2763, n183 = proto.readVarInt(p278, n183)
				elseif v2762 == proto.wireTypes.lengthDelimited then
					if v2761 == 1 then
						local v2764

						v2764, n183 = proto.readBuffer(p278, n183)
						v2759.session_id = prop_types.StringProp.decode(v2764)
					else
						local v2765, v2766 = proto.readVarInt(p278, n183)

						n183 = v2766 + v2765
					end
				elseif v2762 == proto.wireTypes.i32 then
					local v2767

					v2767, n183 = proto.readFixed32(p278, n183)
				elseif v2762 == proto.wireTypes.i64 then
					local v2768

					v2768, n183 = proto.readFixed64(p278, n183)
				else
					error("Unsupported wire type: " .. v2762)
				end
			end

			return v2759
		end
		function t367.jsonEncode(p279) -- line: 19130
			local t369 = {}

			if p279.session_id ~= nil then
				t369.sessionId = p279.session_id:jsonEncode()
			end

			return t369
		end
		function t367.jsonDecode(t370: {[any]: any}) -- line: 19140
			-- upvalues: t367 (copy), prop_types (copy)
			local v2772 = t367.new()

			if t370.session_id ~= nil then
				v2772.session_id = prop_types.StringProp.jsonDecode(t370.session_id)
			end

			if t370.sessionId ~= nil then
				v2772.session_id = prop_types.StringProp.jsonDecode(t370.sessionId)
			end

			return v2772
		end

		t367.descriptor = {
			name = "ApplyChartsFilterAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.ApplyChartsFilterAction_Params = t367
		typeRegistry.default:register(t1.ApplyChartsFilterAction_Params)

		local t371 = {}

		t371.__index = t371

		function t371.new(t372: {[any]: any}?) -- line: 19168
			-- upvalues: t1 (copy), t371 (copy)
			return (setmetatable({
				action_type = if t372 ~= nil and t372.action_type ~= nil then t372.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t372 ~= nil and t372.action_params ~= nil then t372.action_params else nil
			}, t371))
		end
		function t371.encode(p280) -- line: 19179
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n184 = 0

			if p280.action_type ~= nil and (p280.action_type ~= nil and p280.action_type ~= 0 or p280.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2777, v2778 = proto.writeTag(buf, n184, 1, proto.wireTypes.varint)

				buf, n184 = proto.writeVarInt(v2777, v2778, t1.ActionType.toNumber(p280.action_type))
			end

			if p280.action_params ~= nil then
				local v2779 = p280.action_params:encode()
				local v2780, v2781 = proto.writeTag(buf, n184, 2, proto.wireTypes.lengthDelimited)

				buf, n184 = proto.writeBuffer(v2780, v2781, v2779, buffer.len(v2779))
			end

			local buf95 = buffer.create(n184)

			buffer.copy(buf95, 0, buf, 0, n184)

			return buf95
		end
		function t371.decode(p281: buffer) -- line: 19205
			-- upvalues: t371 (copy), proto (copy), t1 (copy)
			local v2784 = t371.new()
			local n185 = 0

			while n185 < buffer.len(p281) do
				local v2786, v2787

				v2786, v2787, n185 = proto.readTag(p281, n185)

				if v2787 == proto.wireTypes.varint then
					if v2786 == 1 then
						local v2788

						v2788, n185 = proto.readVarIntI32(p281, n185)
						v2784.action_type = t1.ActionType.fromNumber(v2788) or v2788
					else
						local v2789

						v2789, n185 = proto.readVarInt(p281, n185)
					end
				elseif v2787 == proto.wireTypes.lengthDelimited then
					if v2786 == 2 then
						local v2790

						v2790, n185 = proto.readBuffer(p281, n185)
						v2784.action_params = t1.RefreshChartsSortDetailAction_Params.decode(v2790)
					else
						local v2791, v2792 = proto.readVarInt(p281, n185)

						n185 = v2792 + v2791
					end
				elseif v2787 == proto.wireTypes.i32 then
					local v2793

					v2793, n185 = proto.readFixed32(p281, n185)
				elseif v2787 == proto.wireTypes.i64 then
					local v2794

					v2794, n185 = proto.readFixed64(p281, n185)
				else
					error("Unsupported wire type: " .. v2787)
				end
			end

			return v2784
		end
		function t371.jsonEncode(p282) -- line: 19253
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
		function t371.jsonDecode(t374: {[any]: any}) -- line: 19275
			-- upvalues: t371 (copy), t1 (copy)
			local v2798 = t371.new()

			if t374.action_type ~= nil then
				v2798.action_type = if typeof(t374.action_type) ~= "number" then t1.ActionType.fromName(t374.action_type) or t374.action_type else t1.ActionType.fromNumber(t374.action_type) or t374.action_type
			end

			if t374.actionType ~= nil then
				v2798.action_type = if typeof(t374.actionType) ~= "number" then t1.ActionType.fromName(t374.actionType) or t374.actionType else t1.ActionType.fromNumber(t374.actionType) or t374.actionType
			end

			if t374.action_params ~= nil then
				v2798.action_params = t1.RefreshChartsSortDetailAction_Params.jsonDecode(t374.action_params)
			end

			if t374.actionParams ~= nil then
				v2798.action_params = t1.RefreshChartsSortDetailAction_Params.jsonDecode(t374.actionParams)
			end

			return v2798
		end

		t371.descriptor = {
			name = "RefreshChartsSortDetailAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.RefreshChartsSortDetailAction"
		}
		t1.RefreshChartsSortDetailAction = t371
	end

	typeRegistry.default:register(t1.RefreshChartsSortDetailAction)

	do
		local t375 = {}

		t375.__index = t375

		function t375.new(t376: {[any]: any}?) -- line: 19315
			-- upvalues: t375 (copy)
			return (setmetatable({
				config_key = if t376 ~= nil and t376.config_key ~= nil then t376.config_key else nil,
				selected_option = if t376 ~= nil and t376.selected_option ~= nil then t376.selected_option else nil,
				surface_key = if t376 ~= nil and t376.surface_key ~= nil then t376.surface_key else nil,
				sort_id = if t376 ~= nil and t376.sort_id ~= nil then t376.sort_id else nil
			}, t375))
		end
		function t375.encode(p283) -- line: 19326
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n186 = 0

			if p283.config_key ~= nil then
				local v2803 = p283.config_key:encode()
				local v2804, v2805 = proto.writeTag(buf, n186, 1, proto.wireTypes.lengthDelimited)

				buf, n186 = proto.writeBuffer(v2804, v2805, v2803, buffer.len(v2803))
			end

			if p283.selected_option ~= nil then
				local v2806 = p283.selected_option:encode()
				local v2807, v2808 = proto.writeTag(buf, n186, 2, proto.wireTypes.lengthDelimited)

				buf, n186 = proto.writeBuffer(v2807, v2808, v2806, buffer.len(v2806))
			end

			if p283.surface_key ~= nil then
				local v2809 = p283.surface_key:encode()
				local v2810, v2811 = proto.writeTag(buf, n186, 3, proto.wireTypes.lengthDelimited)

				buf, n186 = proto.writeBuffer(v2810, v2811, v2809, buffer.len(v2809))
			end

			if p283.sort_id ~= nil then
				local v2812 = p283.sort_id:encode()
				local v2813, v2814 = proto.writeTag(buf, n186, 4, proto.wireTypes.lengthDelimited)

				buf, n186 = proto.writeBuffer(v2813, v2814, v2812, buffer.len(v2812))
			end

			local buf96 = buffer.create(n186)

			buffer.copy(buf96, 0, buf, 0, n186)

			return buf96
		end
		function t375.decode(p284: buffer) -- line: 19359
			-- upvalues: t375 (copy), proto (copy), prop_types (copy)
			local v2817 = t375.new()
			local n187 = 0

			while n187 < buffer.len(p284) do
				local v2819, v2820

				v2819, v2820, n187 = proto.readTag(p284, n187)

				if v2820 == proto.wireTypes.varint then
					local v2821

					v2821, n187 = proto.readVarInt(p284, n187)
				elseif v2820 == proto.wireTypes.lengthDelimited then
					if v2819 == 1 then
						local v2822

						v2822, n187 = proto.readBuffer(p284, n187)
						v2817.config_key = prop_types.StringProp.decode(v2822)
					elseif v2819 == 2 then
						local v2823

						v2823, n187 = proto.readBuffer(p284, n187)
						v2817.selected_option = prop_types.StringProp.decode(v2823)
					elseif v2819 == 3 then
						local v2824

						v2824, n187 = proto.readBuffer(p284, n187)
						v2817.surface_key = prop_types.StringProp.decode(v2824)
					elseif v2819 == 4 then
						local v2825

						v2825, n187 = proto.readBuffer(p284, n187)
						v2817.sort_id = prop_types.StringProp.decode(v2825)
					else
						local v2826, v2827 = proto.readVarInt(p284, n187)

						n187 = v2827 + v2826
					end
				elseif v2820 == proto.wireTypes.i32 then
					local v2828

					v2828, n187 = proto.readFixed32(p284, n187)
				elseif v2820 == proto.wireTypes.i64 then
					local v2829

					v2829, n187 = proto.readFixed64(p284, n187)
				else
					error("Unsupported wire type: " .. v2820)
				end
			end

			return v2817
		end
		function t375.jsonEncode(p285) -- line: 19417
			local t377 = {}

			if p285.config_key ~= nil then
				t377.configKey = p285.config_key:jsonEncode()
			end

			if p285.selected_option ~= nil then
				t377.selectedOption = p285.selected_option:jsonEncode()
			end

			if p285.surface_key ~= nil then
				t377.surfaceKey = p285.surface_key:jsonEncode()
			end

			if p285.sort_id ~= nil then
				t377.sortId = p285.sort_id:jsonEncode()
			end

			return t377
		end
		function t375.jsonDecode(t378: {[any]: any}) -- line: 19439
			-- upvalues: t375 (copy), prop_types (copy)
			local v2833 = t375.new()

			if t378.config_key ~= nil then
				v2833.config_key = prop_types.StringProp.jsonDecode(t378.config_key)
			end

			if t378.configKey ~= nil then
				v2833.config_key = prop_types.StringProp.jsonDecode(t378.configKey)
			end

			if t378.selected_option ~= nil then
				v2833.selected_option = prop_types.StringProp.jsonDecode(t378.selected_option)
			end

			if t378.selectedOption ~= nil then
				v2833.selected_option = prop_types.StringProp.jsonDecode(t378.selectedOption)
			end

			if t378.surface_key ~= nil then
				v2833.surface_key = prop_types.StringProp.jsonDecode(t378.surface_key)
			end

			if t378.surfaceKey ~= nil then
				v2833.surface_key = prop_types.StringProp.jsonDecode(t378.surfaceKey)
			end

			if t378.sort_id ~= nil then
				v2833.sort_id = prop_types.StringProp.jsonDecode(t378.sort_id)
			end

			if t378.sortId ~= nil then
				v2833.sort_id = prop_types.StringProp.jsonDecode(t378.sortId)
			end

			return v2833
		end

		t375.descriptor = {
			name = "RefreshChartsSortDetailAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.RefreshChartsSortDetailAction_Params = t375
		typeRegistry.default:register(t1.RefreshChartsSortDetailAction_Params)

		local t379 = {}

		t379.__index = t379

		function t379.new(t380: {[any]: any}?) -- line: 19496
			-- upvalues: t1 (copy), t379 (copy)
			return (setmetatable({
				action_type = if t380 ~= nil and t380.action_type ~= nil then t380.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t380 ~= nil and t380.action_params ~= nil then t380.action_params else nil
			}, t379))
		end
		function t379.encode(p286) -- line: 19505
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n188 = 0

			if p286.action_type ~= nil and (p286.action_type ~= nil and p286.action_type ~= 0 or p286.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2838, v2839 = proto.writeTag(buf, n188, 1, proto.wireTypes.varint)

				buf, n188 = proto.writeVarInt(v2838, v2839, t1.ActionType.toNumber(p286.action_type))
			end

			if p286.action_params ~= nil then
				local v2840 = p286.action_params:encode()
				local v2841, v2842 = proto.writeTag(buf, n188, 2, proto.wireTypes.lengthDelimited)

				buf, n188 = proto.writeBuffer(v2841, v2842, v2840, buffer.len(v2840))
			end

			local buf97 = buffer.create(n188)

			buffer.copy(buf97, 0, buf, 0, n188)

			return buf97
		end
		function t379.decode(p287: buffer) -- line: 19531
			-- upvalues: t379 (copy), proto (copy), t1 (copy)
			local v2845 = t379.new()
			local n189 = 0

			while n189 < buffer.len(p287) do
				local v2847, v2848

				v2847, v2848, n189 = proto.readTag(p287, n189)

				if v2848 == proto.wireTypes.varint then
					if v2847 == 1 then
						local v2849

						v2849, n189 = proto.readVarIntI32(p287, n189)
						v2845.action_type = t1.ActionType.fromNumber(v2849) or v2849
					else
						local v2850

						v2850, n189 = proto.readVarInt(p287, n189)
					end
				elseif v2848 == proto.wireTypes.lengthDelimited then
					if v2847 == 2 then
						local v2851

						v2851, n189 = proto.readBuffer(p287, n189)
						v2845.action_params = t1.JoinCommunityAction_Params.decode(v2851)
					else
						local v2852, v2853 = proto.readVarInt(p287, n189)

						n189 = v2853 + v2852
					end
				elseif v2848 == proto.wireTypes.i32 then
					local v2854

					v2854, n189 = proto.readFixed32(p287, n189)
				elseif v2848 == proto.wireTypes.i64 then
					local v2855

					v2855, n189 = proto.readFixed64(p287, n189)
				else
					error("Unsupported wire type: " .. v2848)
				end
			end

			return v2845
		end
		function t379.jsonEncode(p288) -- line: 19579
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
		function t379.jsonDecode(t382: {[any]: any}) -- line: 19601
			-- upvalues: t379 (copy), t1 (copy)
			local v2859 = t379.new()

			if t382.action_type ~= nil then
				v2859.action_type = if typeof(t382.action_type) ~= "number" then t1.ActionType.fromName(t382.action_type) or t382.action_type else t1.ActionType.fromNumber(t382.action_type) or t382.action_type
			end

			if t382.actionType ~= nil then
				v2859.action_type = if typeof(t382.actionType) ~= "number" then t1.ActionType.fromName(t382.actionType) or t382.actionType else t1.ActionType.fromNumber(t382.actionType) or t382.actionType
			end

			if t382.action_params ~= nil then
				v2859.action_params = t1.JoinCommunityAction_Params.jsonDecode(t382.action_params)
			end

			if t382.actionParams ~= nil then
				v2859.action_params = t1.JoinCommunityAction_Params.jsonDecode(t382.actionParams)
			end

			return v2859
		end

		t379.descriptor = {
			name = "JoinCommunityAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.JoinCommunityAction"
		}
		t1.JoinCommunityAction = t379
	end

	typeRegistry.default:register(t1.JoinCommunityAction)

	do
		local t383 = {}

		t383.__index = t383

		function t383.new(t384: {[any]: any}?) -- line: 19641
			-- upvalues: t383 (copy)
			return (setmetatable({
				community_id = if t384 ~= nil and t384.community_id ~= nil then t384.community_id else nil
			}, t383))
		end
		function t383.encode(p289) -- line: 19649
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n190 = 0

			if p289.community_id ~= nil then
				local v2864 = p289.community_id:encode()
				local v2865, v2866 = proto.writeTag(buf, n190, 1, proto.wireTypes.lengthDelimited)

				buf, n190 = proto.writeBuffer(v2865, v2866, v2864, buffer.len(v2864))
			end

			local buf98 = buffer.create(n190)

			buffer.copy(buf98, 0, buf, 0, n190)

			return buf98
		end
		function t383.decode(p290: buffer) -- line: 19664
			-- upvalues: t383 (copy), proto (copy), prop_types (copy)
			local v2869 = t383.new()
			local n191 = 0

			while n191 < buffer.len(p290) do
				local v2871, v2872

				v2871, v2872, n191 = proto.readTag(p290, n191)

				if v2872 == proto.wireTypes.varint then
					local v2873

					v2873, n191 = proto.readVarInt(p290, n191)
				elseif v2872 == proto.wireTypes.lengthDelimited then
					if v2871 == 1 then
						local v2874

						v2874, n191 = proto.readBuffer(p290, n191)
						v2869.community_id = prop_types.StringProp.decode(v2874)
					else
						local v2875, v2876 = proto.readVarInt(p290, n191)

						n191 = v2876 + v2875
					end
				elseif v2872 == proto.wireTypes.i32 then
					local v2877

					v2877, n191 = proto.readFixed32(p290, n191)
				elseif v2872 == proto.wireTypes.i64 then
					local v2878

					v2878, n191 = proto.readFixed64(p290, n191)
				else
					error("Unsupported wire type: " .. v2872)
				end
			end

			return v2869
		end
		function t383.jsonEncode(p291) -- line: 19707
			local t385 = {}

			if p291.community_id ~= nil then
				t385.communityId = p291.community_id:jsonEncode()
			end

			return t385
		end
		function t383.jsonDecode(t386: {[any]: any}) -- line: 19717
			-- upvalues: t383 (copy), prop_types (copy)
			local v2882 = t383.new()

			if t386.community_id ~= nil then
				v2882.community_id = prop_types.StringProp.jsonDecode(t386.community_id)
			end

			if t386.communityId ~= nil then
				v2882.community_id = prop_types.StringProp.jsonDecode(t386.communityId)
			end

			return v2882
		end

		t383.descriptor = {
			name = "JoinCommunityAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.JoinCommunityAction_Params = t383
		typeRegistry.default:register(t1.JoinCommunityAction_Params)

		local t387 = {}

		t387.__index = t387

		function t387.new(t388: {[any]: any}?) -- line: 19747
			-- upvalues: t1 (copy), t387 (copy)
			return (setmetatable({
				action_type = if t388 ~= nil and t388.action_type ~= nil then t388.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t388 ~= nil and t388.action_params ~= nil then t388.action_params else nil
			}, t387))
		end
		function t387.encode(p292) -- line: 19756
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n192 = 0

			if p292.action_type ~= nil and (p292.action_type ~= nil and p292.action_type ~= 0 or p292.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2887, v2888 = proto.writeTag(buf, n192, 1, proto.wireTypes.varint)

				buf, n192 = proto.writeVarInt(v2887, v2888, t1.ActionType.toNumber(p292.action_type))
			end

			if p292.action_params ~= nil then
				local v2889 = p292.action_params:encode()
				local v2890, v2891 = proto.writeTag(buf, n192, 2, proto.wireTypes.lengthDelimited)

				buf, n192 = proto.writeBuffer(v2890, v2891, v2889, buffer.len(v2889))
			end

			local buf99 = buffer.create(n192)

			buffer.copy(buf99, 0, buf, 0, n192)

			return buf99
		end
		function t387.decode(p293: buffer) -- line: 19782
			-- upvalues: t387 (copy), proto (copy), t1 (copy)
			local v2894 = t387.new()
			local n193 = 0

			while n193 < buffer.len(p293) do
				local v2896, v2897

				v2896, v2897, n193 = proto.readTag(p293, n193)

				if v2897 == proto.wireTypes.varint then
					if v2896 == 1 then
						local v2898

						v2898, n193 = proto.readVarIntI32(p293, n193)
						v2894.action_type = t1.ActionType.fromNumber(v2898) or v2898
					else
						local v2899

						v2899, n193 = proto.readVarInt(p293, n193)
					end
				elseif v2897 == proto.wireTypes.lengthDelimited then
					if v2896 == 2 then
						local v2900

						v2900, n193 = proto.readBuffer(p293, n193)
						v2894.action_params = t1.ViewCommunityAction_Params.decode(v2900)
					else
						local v2901, v2902 = proto.readVarInt(p293, n193)

						n193 = v2902 + v2901
					end
				elseif v2897 == proto.wireTypes.i32 then
					local v2903

					v2903, n193 = proto.readFixed32(p293, n193)
				elseif v2897 == proto.wireTypes.i64 then
					local v2904

					v2904, n193 = proto.readFixed64(p293, n193)
				else
					error("Unsupported wire type: " .. v2897)
				end
			end

			return v2894
		end
		function t387.jsonEncode(p294) -- line: 19830
			-- upvalues: t1 (copy)
			local t389 = {}

			if p294.action_type ~= nil and (p294.action_type ~= nil and p294.action_type ~= 0 or p294.action_type ~= t1.ActionType.fromNumber(0)) then
				t389.actionType = if typeof(p294.action_type) ~= "number" then t1.ActionType.toNumber(p294.action_type) else p294.action_type
			end

			if p294.action_params ~= nil then
				t389.actionParams = p294.action_params:jsonEncode()
			end

			return t389
		end
		function t387.jsonDecode(t390: {[any]: any}) -- line: 19852
			-- upvalues: t387 (copy), t1 (copy)
			local v2908 = t387.new()

			if t390.action_type ~= nil then
				v2908.action_type = if typeof(t390.action_type) ~= "number" then t1.ActionType.fromName(t390.action_type) or t390.action_type else t1.ActionType.fromNumber(t390.action_type) or t390.action_type
			end

			if t390.actionType ~= nil then
				v2908.action_type = if typeof(t390.actionType) ~= "number" then t1.ActionType.fromName(t390.actionType) or t390.actionType else t1.ActionType.fromNumber(t390.actionType) or t390.actionType
			end

			if t390.action_params ~= nil then
				v2908.action_params = t1.ViewCommunityAction_Params.jsonDecode(t390.action_params)
			end

			if t390.actionParams ~= nil then
				v2908.action_params = t1.ViewCommunityAction_Params.jsonDecode(t390.actionParams)
			end

			return v2908
		end

		t387.descriptor = {
			name = "ViewCommunityAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.ViewCommunityAction"
		}
		t1.ViewCommunityAction = t387
	end

	typeRegistry.default:register(t1.ViewCommunityAction)

	do
		local t391 = {}

		t391.__index = t391

		function t391.new(t392: {[any]: any}?) -- line: 19892
			-- upvalues: t391 (copy)
			return (setmetatable({
				community_id = if t392 ~= nil and t392.community_id ~= nil then t392.community_id else nil
			}, t391))
		end
		function t391.encode(p295) -- line: 19900
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n194 = 0

			if p295.community_id ~= nil then
				local v2913 = p295.community_id:encode()
				local v2914, v2915 = proto.writeTag(buf, n194, 1, proto.wireTypes.lengthDelimited)

				buf, n194 = proto.writeBuffer(v2914, v2915, v2913, buffer.len(v2913))
			end

			local buf100 = buffer.create(n194)

			buffer.copy(buf100, 0, buf, 0, n194)

			return buf100
		end
		function t391.decode(p296: buffer) -- line: 19915
			-- upvalues: t391 (copy), proto (copy), prop_types (copy)
			local v2918 = t391.new()
			local n195 = 0

			while n195 < buffer.len(p296) do
				local v2920, v2921

				v2920, v2921, n195 = proto.readTag(p296, n195)

				if v2921 == proto.wireTypes.varint then
					local v2922

					v2922, n195 = proto.readVarInt(p296, n195)
				elseif v2921 == proto.wireTypes.lengthDelimited then
					if v2920 == 1 then
						local v2923

						v2923, n195 = proto.readBuffer(p296, n195)
						v2918.community_id = prop_types.StringProp.decode(v2923)
					else
						local v2924, v2925 = proto.readVarInt(p296, n195)

						n195 = v2925 + v2924
					end
				elseif v2921 == proto.wireTypes.i32 then
					local v2926

					v2926, n195 = proto.readFixed32(p296, n195)
				elseif v2921 == proto.wireTypes.i64 then
					local v2927

					v2927, n195 = proto.readFixed64(p296, n195)
				else
					error("Unsupported wire type: " .. v2921)
				end
			end

			return v2918
		end
		function t391.jsonEncode(p297) -- line: 19958
			local t393 = {}

			if p297.community_id ~= nil then
				t393.communityId = p297.community_id:jsonEncode()
			end

			return t393
		end
		function t391.jsonDecode(t394: {[any]: any}) -- line: 19968
			-- upvalues: t391 (copy), prop_types (copy)
			local v2931 = t391.new()

			if t394.community_id ~= nil then
				v2931.community_id = prop_types.StringProp.jsonDecode(t394.community_id)
			end

			if t394.communityId ~= nil then
				v2931.community_id = prop_types.StringProp.jsonDecode(t394.communityId)
			end

			return v2931
		end

		t391.descriptor = {
			name = "ViewCommunityAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.ViewCommunityAction_Params = t391
		typeRegistry.default:register(t1.ViewCommunityAction_Params)

		local t395 = {}

		t395.__index = t395

		function t395.new(t396: {[any]: any}?) -- line: 19998
			-- upvalues: t1 (copy), t395 (copy)
			return (setmetatable({
				action_type = if t396 ~= nil and t396.action_type ~= nil then t396.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t396 ~= nil and t396.action_params ~= nil then t396.action_params else nil
			}, t395))
		end
		function t395.encode(p298) -- line: 20007
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n196 = 0

			if p298.action_type ~= nil and (p298.action_type ~= nil and p298.action_type ~= 0 or p298.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2936, v2937 = proto.writeTag(buf, n196, 1, proto.wireTypes.varint)

				buf, n196 = proto.writeVarInt(v2936, v2937, t1.ActionType.toNumber(p298.action_type))
			end

			if p298.action_params ~= nil then
				local v2938 = p298.action_params:encode()
				local v2939, v2940 = proto.writeTag(buf, n196, 2, proto.wireTypes.lengthDelimited)

				buf, n196 = proto.writeBuffer(v2939, v2940, v2938, buffer.len(v2938))
			end

			local buf101 = buffer.create(n196)

			buffer.copy(buf101, 0, buf, 0, n196)

			return buf101
		end
		function t395.decode(p299: buffer) -- line: 20033
			-- upvalues: t395 (copy), proto (copy), t1 (copy)
			local v2943 = t395.new()
			local n197 = 0

			while n197 < buffer.len(p299) do
				local v2945, v2946

				v2945, v2946, n197 = proto.readTag(p299, n197)

				if v2946 == proto.wireTypes.varint then
					if v2945 == 1 then
						local v2947

						v2947, n197 = proto.readVarIntI32(p299, n197)
						v2943.action_type = t1.ActionType.fromNumber(v2947) or v2947
					else
						local v2948

						v2948, n197 = proto.readVarInt(p299, n197)
					end
				elseif v2946 == proto.wireTypes.lengthDelimited then
					if v2945 == 2 then
						local v2949

						v2949, n197 = proto.readBuffer(p299, n197)
						v2943.action_params = t1.AnalyticsEventAction_Params.decode(v2949)
					else
						local v2950, v2951 = proto.readVarInt(p299, n197)

						n197 = v2951 + v2950
					end
				elseif v2946 == proto.wireTypes.i32 then
					local v2952

					v2952, n197 = proto.readFixed32(p299, n197)
				elseif v2946 == proto.wireTypes.i64 then
					local v2953

					v2953, n197 = proto.readFixed64(p299, n197)
				else
					error("Unsupported wire type: " .. v2946)
				end
			end

			return v2943
		end
		function t395.jsonEncode(p300) -- line: 20081
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
		function t395.jsonDecode(t398: {[any]: any}) -- line: 20103
			-- upvalues: t395 (copy), t1 (copy)
			local v2957 = t395.new()

			if t398.action_type ~= nil then
				v2957.action_type = if typeof(t398.action_type) ~= "number" then t1.ActionType.fromName(t398.action_type) or t398.action_type else t1.ActionType.fromNumber(t398.action_type) or t398.action_type
			end

			if t398.actionType ~= nil then
				v2957.action_type = if typeof(t398.actionType) ~= "number" then t1.ActionType.fromName(t398.actionType) or t398.actionType else t1.ActionType.fromNumber(t398.actionType) or t398.actionType
			end

			if t398.action_params ~= nil then
				v2957.action_params = t1.AnalyticsEventAction_Params.jsonDecode(t398.action_params)
			end

			if t398.actionParams ~= nil then
				v2957.action_params = t1.AnalyticsEventAction_Params.jsonDecode(t398.actionParams)
			end

			return v2957
		end

		t395.descriptor = {
			name = "AnalyticsEventAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.AnalyticsEventAction"
		}
		t1.AnalyticsEventAction = t395
	end

	typeRegistry.default:register(t1.AnalyticsEventAction)

	do
		local t399 = {}

		t399.__index = t399

		function t399.new(t400: {[any]: any}?) -- line: 20143
			-- upvalues: t399 (copy)
			return (setmetatable({
				event_name = if t400 ~= nil and t400.event_name ~= nil then t400.event_name else nil,
				event_fields = if t400 ~= nil and t400.event_fields ~= nil then t400.event_fields else nil
			}, t399))
		end
		function t399.encode(p301) -- line: 20152
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n198 = 0

			if p301.event_name ~= nil then
				local v2962 = p301.event_name:encode()
				local v2963, v2964 = proto.writeTag(buf, n198, 1, proto.wireTypes.lengthDelimited)

				buf, n198 = proto.writeBuffer(v2963, v2964, v2962, buffer.len(v2962))
			end

			if p301.event_fields ~= nil then
				local v2965 = p301.event_fields:encode()
				local v2966, v2967 = proto.writeTag(buf, n198, 2, proto.wireTypes.lengthDelimited)

				buf, n198 = proto.writeBuffer(v2966, v2967, v2965, buffer.len(v2965))
			end

			local buf102 = buffer.create(n198)

			buffer.copy(buf102, 0, buf, 0, n198)

			return buf102
		end
		function t399.decode(p302: buffer) -- line: 20173
			-- upvalues: t399 (copy), proto (copy), prop_types (copy)
			local v2970 = t399.new()
			local n199 = 0

			while n199 < buffer.len(p302) do
				local v2972, v2973

				v2972, v2973, n199 = proto.readTag(p302, n199)

				if v2973 == proto.wireTypes.varint then
					local v2974

					v2974, n199 = proto.readVarInt(p302, n199)
				elseif v2973 == proto.wireTypes.lengthDelimited then
					if v2972 == 1 then
						local v2975

						v2975, n199 = proto.readBuffer(p302, n199)
						v2970.event_name = prop_types.StringProp.decode(v2975)
					elseif v2972 == 2 then
						local v2976

						v2976, n199 = proto.readBuffer(p302, n199)
						v2970.event_fields = prop_types.StructProp.decode(v2976)
					else
						local v2977, v2978 = proto.readVarInt(p302, n199)

						n199 = v2978 + v2977
					end
				elseif v2973 == proto.wireTypes.i32 then
					local v2979

					v2979, n199 = proto.readFixed32(p302, n199)
				elseif v2973 == proto.wireTypes.i64 then
					local v2980

					v2980, n199 = proto.readFixed64(p302, n199)
				else
					error("Unsupported wire type: " .. v2973)
				end
			end

			return v2970
		end
		function t399.jsonEncode(p303) -- line: 20221
			local t401 = {}

			if p303.event_name ~= nil then
				t401.eventName = p303.event_name:jsonEncode()
			end

			if p303.event_fields ~= nil then
				t401.eventFields = p303.event_fields:jsonEncode()
			end

			return t401
		end
		function t399.jsonDecode(t402: {[any]: any}) -- line: 20235
			-- upvalues: t399 (copy), prop_types (copy)
			local v2984 = t399.new()

			if t402.event_name ~= nil then
				v2984.event_name = prop_types.StringProp.jsonDecode(t402.event_name)
			end

			if t402.eventName ~= nil then
				v2984.event_name = prop_types.StringProp.jsonDecode(t402.eventName)
			end

			if t402.event_fields ~= nil then
				v2984.event_fields = prop_types.StructProp.jsonDecode(t402.event_fields)
			end

			if t402.eventFields ~= nil then
				v2984.event_fields = prop_types.StructProp.jsonDecode(t402.eventFields)
			end

			return v2984
		end

		t399.descriptor = {
			name = "AnalyticsEventAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.AnalyticsEventAction_Params = t399
		typeRegistry.default:register(t1.AnalyticsEventAction_Params)

		local t403 = {}

		t403.__index = t403

		function t403.new(t404: {[any]: any}?) -- line: 20273
			-- upvalues: t1 (copy), t403 (copy)
			return (setmetatable({
				action_type = if t404 ~= nil and t404.action_type ~= nil then t404.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t404 ~= nil and t404.action_params ~= nil then t404.action_params else nil
			}, t403))
		end
		function t403.encode(p304) -- line: 20284
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n200 = 0

			if p304.action_type ~= nil and (p304.action_type ~= nil and p304.action_type ~= 0 or p304.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2989, v2990 = proto.writeTag(buf, n200, 1, proto.wireTypes.varint)

				buf, n200 = proto.writeVarInt(v2989, v2990, t1.ActionType.toNumber(p304.action_type))
			end

			if p304.action_params ~= nil then
				local v2991 = p304.action_params:encode()
				local v2992, v2993 = proto.writeTag(buf, n200, 2, proto.wireTypes.lengthDelimited)

				buf, n200 = proto.writeBuffer(v2992, v2993, v2991, buffer.len(v2991))
			end

			local buf103 = buffer.create(n200)

			buffer.copy(buf103, 0, buf, 0, n200)

			return buf103
		end
		function t403.decode(p305: buffer) -- line: 20310
			-- upvalues: t403 (copy), proto (copy), t1 (copy)
			local v2996 = t403.new()
			local n201 = 0

			while n201 < buffer.len(p305) do
				local v2998, v2999

				v2998, v2999, n201 = proto.readTag(p305, n201)

				if v2999 == proto.wireTypes.varint then
					if v2998 == 1 then
						local v3000

						v3000, n201 = proto.readVarIntI32(p305, n201)
						v2996.action_type = t1.ActionType.fromNumber(v3000) or v3000
					else
						local v3001

						v3001, n201 = proto.readVarInt(p305, n201)
					end
				elseif v2999 == proto.wireTypes.lengthDelimited then
					if v2998 == 2 then
						local v3002

						v3002, n201 = proto.readBuffer(p305, n201)
						v2996.action_params = t1.CustomAnalyticsEventAction_Params.decode(v3002)
					else
						local v3003, v3004 = proto.readVarInt(p305, n201)

						n201 = v3004 + v3003
					end
				elseif v2999 == proto.wireTypes.i32 then
					local v3005

					v3005, n201 = proto.readFixed32(p305, n201)
				elseif v2999 == proto.wireTypes.i64 then
					local v3006

					v3006, n201 = proto.readFixed64(p305, n201)
				else
					error("Unsupported wire type: " .. v2999)
				end
			end

			return v2996
		end
		function t403.jsonEncode(p306) -- line: 20358
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
		function t403.jsonDecode(t406: {[any]: any}) -- line: 20380
			-- upvalues: t403 (copy), t1 (copy)
			local v3010 = t403.new()

			if t406.action_type ~= nil then
				v3010.action_type = if typeof(t406.action_type) ~= "number" then t1.ActionType.fromName(t406.action_type) or t406.action_type else t1.ActionType.fromNumber(t406.action_type) or t406.action_type
			end

			if t406.actionType ~= nil then
				v3010.action_type = if typeof(t406.actionType) ~= "number" then t1.ActionType.fromName(t406.actionType) or t406.actionType else t1.ActionType.fromNumber(t406.actionType) or t406.actionType
			end

			if t406.action_params ~= nil then
				v3010.action_params = t1.CustomAnalyticsEventAction_Params.jsonDecode(t406.action_params)
			end

			if t406.actionParams ~= nil then
				v3010.action_params = t1.CustomAnalyticsEventAction_Params.jsonDecode(t406.actionParams)
			end

			return v3010
		end

		t403.descriptor = {
			name = "CustomAnalyticsEventAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.CustomAnalyticsEventAction"
		}
		t1.CustomAnalyticsEventAction = t403
	end

	typeRegistry.default:register(t1.CustomAnalyticsEventAction)

	do
		local t407 = {}

		t407.__index = t407

		function t407.new(t408: {[any]: any}?) -- line: 20420
			-- upvalues: t407 (copy)
			return (setmetatable({
				event_name = if t408 ~= nil and t408.event_name ~= nil then t408.event_name else nil,
				event_fields = if t408 ~= nil and t408.event_fields ~= nil then t408.event_fields else nil
			}, t407))
		end
		function t407.encode(p307) -- line: 20429
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n202 = 0

			if p307.event_name ~= nil then
				local v3015 = p307.event_name:encode()
				local v3016, v3017 = proto.writeTag(buf, n202, 1, proto.wireTypes.lengthDelimited)

				buf, n202 = proto.writeBuffer(v3016, v3017, v3015, buffer.len(v3015))
			end

			if p307.event_fields ~= nil then
				local v3018 = p307.event_fields:encode()
				local v3019, v3020 = proto.writeTag(buf, n202, 2, proto.wireTypes.lengthDelimited)

				buf, n202 = proto.writeBuffer(v3019, v3020, v3018, buffer.len(v3018))
			end

			local buf104 = buffer.create(n202)

			buffer.copy(buf104, 0, buf, 0, n202)

			return buf104
		end
		function t407.decode(p308: buffer) -- line: 20450
			-- upvalues: t407 (copy), proto (copy), prop_types (copy)
			local v3023 = t407.new()
			local n203 = 0

			while n203 < buffer.len(p308) do
				local v3025, v3026

				v3025, v3026, n203 = proto.readTag(p308, n203)

				if v3026 == proto.wireTypes.varint then
					local v3027

					v3027, n203 = proto.readVarInt(p308, n203)
				elseif v3026 == proto.wireTypes.lengthDelimited then
					if v3025 == 1 then
						local v3028

						v3028, n203 = proto.readBuffer(p308, n203)
						v3023.event_name = prop_types.StringProp.decode(v3028)
					elseif v3025 == 2 then
						local v3029

						v3029, n203 = proto.readBuffer(p308, n203)
						v3023.event_fields = prop_types.StructProp.decode(v3029)
					else
						local v3030, v3031 = proto.readVarInt(p308, n203)

						n203 = v3031 + v3030
					end
				elseif v3026 == proto.wireTypes.i32 then
					local v3032

					v3032, n203 = proto.readFixed32(p308, n203)
				elseif v3026 == proto.wireTypes.i64 then
					local v3033

					v3033, n203 = proto.readFixed64(p308, n203)
				else
					error("Unsupported wire type: " .. v3026)
				end
			end

			return v3023
		end
		function t407.jsonEncode(p309) -- line: 20498
			local t409 = {}

			if p309.event_name ~= nil then
				t409.eventName = p309.event_name:jsonEncode()
			end

			if p309.event_fields ~= nil then
				t409.eventFields = p309.event_fields:jsonEncode()
			end

			return t409
		end
		function t407.jsonDecode(t410: {[any]: any}) -- line: 20512
			-- upvalues: t407 (copy), prop_types (copy)
			local v3037 = t407.new()

			if t410.event_name ~= nil then
				v3037.event_name = prop_types.StringProp.jsonDecode(t410.event_name)
			end

			if t410.eventName ~= nil then
				v3037.event_name = prop_types.StringProp.jsonDecode(t410.eventName)
			end

			if t410.event_fields ~= nil then
				v3037.event_fields = prop_types.StructProp.jsonDecode(t410.event_fields)
			end

			if t410.eventFields ~= nil then
				v3037.event_fields = prop_types.StructProp.jsonDecode(t410.eventFields)
			end

			return v3037
		end

		t407.descriptor = {
			name = "CustomAnalyticsEventAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.CustomAnalyticsEventAction_Params = t407
		typeRegistry.default:register(t1.CustomAnalyticsEventAction_Params)

		local t411 = {}

		t411.__index = t411

		function t411.new(t412: {[any]: any}?) -- line: 20552
			-- upvalues: t1 (copy), t411 (copy)
			return (setmetatable({
				action_type = if t412 ~= nil and t412.action_type ~= nil then t412.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t412 ~= nil and t412.action_params ~= nil then t412.action_params else nil
			}, t411))
		end
		function t411.encode(p310) -- line: 20561
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n204 = 0

			if p310.action_type ~= nil and (p310.action_type ~= nil and p310.action_type ~= 0 or p310.action_type ~= t1.ActionType.fromNumber(0)) then
				local v3042, v3043 = proto.writeTag(buf, n204, 1, proto.wireTypes.varint)

				buf, n204 = proto.writeVarInt(v3042, v3043, t1.ActionType.toNumber(p310.action_type))
			end

			if p310.action_params ~= nil then
				local v3044 = p310.action_params:encode()
				local v3045, v3046 = proto.writeTag(buf, n204, 2, proto.wireTypes.lengthDelimited)

				buf, n204 = proto.writeBuffer(v3045, v3046, v3044, buffer.len(v3044))
			end

			local buf105 = buffer.create(n204)

			buffer.copy(buf105, 0, buf, 0, n204)

			return buf105
		end
		function t411.decode(p311: buffer) -- line: 20587
			-- upvalues: t411 (copy), proto (copy), t1 (copy)
			local v3049 = t411.new()
			local n205 = 0

			while n205 < buffer.len(p311) do
				local v3051, v3052

				v3051, v3052, n205 = proto.readTag(p311, n205)

				if v3052 == proto.wireTypes.varint then
					if v3051 == 1 then
						local v3053

						v3053, n205 = proto.readVarIntI32(p311, n205)
						v3049.action_type = t1.ActionType.fromNumber(v3053) or v3053
					else
						local v3054

						v3054, n205 = proto.readVarInt(p311, n205)
					end
				elseif v3052 == proto.wireTypes.lengthDelimited then
					if v3051 == 2 then
						local v3055

						v3055, n205 = proto.readBuffer(p311, n205)
						v3049.action_params = t1.OpenGameInviteAction_Params.decode(v3055)
					else
						local v3056, v3057 = proto.readVarInt(p311, n205)

						n205 = v3057 + v3056
					end
				elseif v3052 == proto.wireTypes.i32 then
					local v3058

					v3058, n205 = proto.readFixed32(p311, n205)
				elseif v3052 == proto.wireTypes.i64 then
					local v3059

					v3059, n205 = proto.readFixed64(p311, n205)
				else
					error("Unsupported wire type: " .. v3052)
				end
			end

			return v3049
		end
		function t411.jsonEncode(p312) -- line: 20635
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
		function t411.jsonDecode(t414: {[any]: any}) -- line: 20657
			-- upvalues: t411 (copy), t1 (copy)
			local v3063 = t411.new()

			if t414.action_type ~= nil then
				v3063.action_type = if typeof(t414.action_type) ~= "number" then t1.ActionType.fromName(t414.action_type) or t414.action_type else t1.ActionType.fromNumber(t414.action_type) or t414.action_type
			end

			if t414.actionType ~= nil then
				v3063.action_type = if typeof(t414.actionType) ~= "number" then t1.ActionType.fromName(t414.actionType) or t414.actionType else t1.ActionType.fromNumber(t414.actionType) or t414.actionType
			end

			if t414.action_params ~= nil then
				v3063.action_params = t1.OpenGameInviteAction_Params.jsonDecode(t414.action_params)
			end

			if t414.actionParams ~= nil then
				v3063.action_params = t1.OpenGameInviteAction_Params.jsonDecode(t414.actionParams)
			end

			return v3063
		end

		t411.descriptor = {
			name = "OpenGameInviteAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenGameInviteAction"
		}
		t1.OpenGameInviteAction = t411
	end

	typeRegistry.default:register(t1.OpenGameInviteAction)

	do
		local t415 = {}

		t415.__index = t415

		function t415.new(t416: {[any]: any}?) -- line: 20697
			-- upvalues: t415 (copy)
			return (setmetatable({
				universe_id = if t416 ~= nil and t416.universe_id ~= nil then t416.universe_id else nil,
				root_place_id = if t416 ~= nil and t416.root_place_id ~= nil then t416.root_place_id else nil,
				trigger = if t416 ~= nil and t416.trigger ~= nil then t416.trigger else nil,
				button_name = if t416 ~= nil and t416.button_name ~= nil then t416.button_name else nil
			}, t415))
		end
		function t415.encode(p313) -- line: 20708
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n206 = 0

			if p313.universe_id ~= nil then
				local v3068 = p313.universe_id:encode()
				local v3069, v3070 = proto.writeTag(buf, n206, 1, proto.wireTypes.lengthDelimited)

				buf, n206 = proto.writeBuffer(v3069, v3070, v3068, buffer.len(v3068))
			end

			if p313.root_place_id ~= nil then
				local v3071 = p313.root_place_id:encode()
				local v3072, v3073 = proto.writeTag(buf, n206, 2, proto.wireTypes.lengthDelimited)

				buf, n206 = proto.writeBuffer(v3072, v3073, v3071, buffer.len(v3071))
			end

			if p313.trigger ~= nil then
				local v3074 = p313.trigger:encode()
				local v3075, v3076 = proto.writeTag(buf, n206, 3, proto.wireTypes.lengthDelimited)

				buf, n206 = proto.writeBuffer(v3075, v3076, v3074, buffer.len(v3074))
			end

			if p313.button_name ~= nil then
				local v3077 = p313.button_name:encode()
				local v3078, v3079 = proto.writeTag(buf, n206, 4, proto.wireTypes.lengthDelimited)

				buf, n206 = proto.writeBuffer(v3078, v3079, v3077, buffer.len(v3077))
			end

			local buf106 = buffer.create(n206)

			buffer.copy(buf106, 0, buf, 0, n206)

			return buf106
		end
		function t415.decode(p314: buffer) -- line: 20741
			-- upvalues: t415 (copy), proto (copy), prop_types (copy)
			local v3082 = t415.new()
			local n207 = 0

			while n207 < buffer.len(p314) do
				local v3084, v3085

				v3084, v3085, n207 = proto.readTag(p314, n207)

				if v3085 == proto.wireTypes.varint then
					local v3086

					v3086, n207 = proto.readVarInt(p314, n207)
				elseif v3085 == proto.wireTypes.lengthDelimited then
					if v3084 == 1 then
						local v3087

						v3087, n207 = proto.readBuffer(p314, n207)
						v3082.universe_id = prop_types.StringProp.decode(v3087)
					elseif v3084 == 2 then
						local v3088

						v3088, n207 = proto.readBuffer(p314, n207)
						v3082.root_place_id = prop_types.StringProp.decode(v3088)
					elseif v3084 == 3 then
						local v3089

						v3089, n207 = proto.readBuffer(p314, n207)
						v3082.trigger = prop_types.StringProp.decode(v3089)
					elseif v3084 == 4 then
						local v3090

						v3090, n207 = proto.readBuffer(p314, n207)
						v3082.button_name = prop_types.StringProp.decode(v3090)
					else
						local v3091, v3092 = proto.readVarInt(p314, n207)

						n207 = v3092 + v3091
					end
				elseif v3085 == proto.wireTypes.i32 then
					local v3093

					v3093, n207 = proto.readFixed32(p314, n207)
				elseif v3085 == proto.wireTypes.i64 then
					local v3094

					v3094, n207 = proto.readFixed64(p314, n207)
				else
					error("Unsupported wire type: " .. v3085)
				end
			end

			return v3082
		end
		function t415.jsonEncode(p315) -- line: 20799
			local t417 = {}

			if p315.universe_id ~= nil then
				t417.universeId = p315.universe_id:jsonEncode()
			end

			if p315.root_place_id ~= nil then
				t417.rootPlaceId = p315.root_place_id:jsonEncode()
			end

			if p315.trigger ~= nil then
				t417.trigger = p315.trigger:jsonEncode()
			end

			if p315.button_name ~= nil then
				t417.buttonName = p315.button_name:jsonEncode()
			end

			return t417
		end
		function t415.jsonDecode(t418: {[any]: any}) -- line: 20821
			-- upvalues: t415 (copy), prop_types (copy)
			local v3098 = t415.new()

			if t418.universe_id ~= nil then
				v3098.universe_id = prop_types.StringProp.jsonDecode(t418.universe_id)
			end

			if t418.universeId ~= nil then
				v3098.universe_id = prop_types.StringProp.jsonDecode(t418.universeId)
			end

			if t418.root_place_id ~= nil then
				v3098.root_place_id = prop_types.StringProp.jsonDecode(t418.root_place_id)
			end

			if t418.rootPlaceId ~= nil then
				v3098.root_place_id = prop_types.StringProp.jsonDecode(t418.rootPlaceId)
			end

			if t418.trigger ~= nil then
				v3098.trigger = prop_types.StringProp.jsonDecode(t418.trigger)
			end

			if t418.button_name ~= nil then
				v3098.button_name = prop_types.StringProp.jsonDecode(t418.button_name)
			end

			if t418.buttonName ~= nil then
				v3098.button_name = prop_types.StringProp.jsonDecode(t418.buttonName)
			end

			return v3098
		end

		t415.descriptor = {
			name = "OpenGameInviteAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenGameInviteAction_Params = t415
		typeRegistry.default:register(t1.OpenGameInviteAction_Params)

		local t419 = {}

		t419.__index = t419

		function t419.new(t420: {[any]: any}?) -- line: 20873
			-- upvalues: t1 (copy), t419 (copy)
			return (setmetatable({
				action_type = if t420 ~= nil and t420.action_type ~= nil then t420.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t420 ~= nil and t420.action_params ~= nil then t420.action_params else nil
			}, t419))
		end
		function t419.encode(p316) -- line: 20882
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n208 = 0

			if p316.action_type ~= nil and (p316.action_type ~= nil and p316.action_type ~= 0 or p316.action_type ~= t1.ActionType.fromNumber(0)) then
				local v3103, v3104 = proto.writeTag(buf, n208, 1, proto.wireTypes.varint)

				buf, n208 = proto.writeVarInt(v3103, v3104, t1.ActionType.toNumber(p316.action_type))
			end

			if p316.action_params ~= nil then
				local v3105 = p316.action_params:encode()
				local v3106, v3107 = proto.writeTag(buf, n208, 2, proto.wireTypes.lengthDelimited)

				buf, n208 = proto.writeBuffer(v3106, v3107, v3105, buffer.len(v3105))
			end

			local buf107 = buffer.create(n208)

			buffer.copy(buf107, 0, buf, 0, n208)

			return buf107
		end
		function t419.decode(p317: buffer) -- line: 20908
			-- upvalues: t419 (copy), proto (copy), t1 (copy)
			local v3110 = t419.new()
			local n209 = 0

			while n209 < buffer.len(p317) do
				local v3112, v3113

				v3112, v3113, n209 = proto.readTag(p317, n209)

				if v3113 == proto.wireTypes.varint then
					if v3112 == 1 then
						local v3114

						v3114, n209 = proto.readVarIntI32(p317, n209)
						v3110.action_type = t1.ActionType.fromNumber(v3114) or v3114
					else
						local v3115

						v3115, n209 = proto.readVarInt(p317, n209)
					end
				elseif v3113 == proto.wireTypes.lengthDelimited then
					if v3112 == 2 then
						local v3116

						v3116, n209 = proto.readBuffer(p317, n209)
						v3110.action_params = t1.LaunchExperienceAction_Params.decode(v3116)
					else
						local v3117, v3118 = proto.readVarInt(p317, n209)

						n209 = v3118 + v3117
					end
				elseif v3113 == proto.wireTypes.i32 then
					local v3119

					v3119, n209 = proto.readFixed32(p317, n209)
				elseif v3113 == proto.wireTypes.i64 then
					local v3120

					v3120, n209 = proto.readFixed64(p317, n209)
				else
					error("Unsupported wire type: " .. v3113)
				end
			end

			return v3110
		end
		function t419.jsonEncode(p318) -- line: 20956
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
		function t419.jsonDecode(t422: {[any]: any}) -- line: 20978
			-- upvalues: t419 (copy), t1 (copy)
			local v3124 = t419.new()

			if t422.action_type ~= nil then
				v3124.action_type = if typeof(t422.action_type) ~= "number" then t1.ActionType.fromName(t422.action_type) or t422.action_type else t1.ActionType.fromNumber(t422.action_type) or t422.action_type
			end

			if t422.actionType ~= nil then
				v3124.action_type = if typeof(t422.actionType) ~= "number" then t1.ActionType.fromName(t422.actionType) or t422.actionType else t1.ActionType.fromNumber(t422.actionType) or t422.actionType
			end

			if t422.action_params ~= nil then
				v3124.action_params = t1.LaunchExperienceAction_Params.jsonDecode(t422.action_params)
			end

			if t422.actionParams ~= nil then
				v3124.action_params = t1.LaunchExperienceAction_Params.jsonDecode(t422.actionParams)
			end

			return v3124
		end

		t419.descriptor = {
			name = "LaunchExperienceAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.LaunchExperienceAction"
		}
		t1.LaunchExperienceAction = t419
	end

	typeRegistry.default:register(t1.LaunchExperienceAction)

	do
		local t423 = {}

		t423.__index = t423

		function t423.new(t424: {[any]: any}?) -- line: 21018
			-- upvalues: t423 (copy)
			return (setmetatable({
				kind = if t424 ~= nil and t424.kind ~= nil then t424.kind else nil
			}, t423))
		end
		function t423.encode(p319) -- line: 21026
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n210 = 0

			if p319.kind ~= nil then
				if p319.kind.type == "literal" then
					local v3129 = p319.kind.value:encode()
					local v3130, v3131 = proto.writeTag(buf, n210, 1, proto.wireTypes.lengthDelimited)

					buf, n210 = proto.writeBuffer(v3130, v3131, v3129, buffer.len(v3129))
				elseif p319.kind.type == "binding_path" then
					local v3132, v3133 = proto.writeTag(buf, n210, 2, proto.wireTypes.lengthDelimited)

					buf, n210 = proto.writeString(v3132, v3133, p319.kind.value)
				end
			end

			local buf108 = buffer.create(n210)

			buffer.copy(buf108, 0, buf, 0, n210)

			return buf108
		end
		function t423.decode(p320: buffer) -- line: 21048
			-- upvalues: t423 (copy), proto (copy), t1 (copy)
			local v3136 = t423.new()
			local n211 = 0

			while n211 < buffer.len(p320) do
				local v3138, v3139

				v3138, v3139, n211 = proto.readTag(p320, n211)

				if v3139 == proto.wireTypes.varint then
					local v3140

					v3140, n211 = proto.readVarInt(p320, n211)
				elseif v3139 == proto.wireTypes.lengthDelimited then
					if v3138 == 1 then
						local v3141

						v3141, n211 = proto.readBuffer(p320, n211)
						v3136.kind = {
							type = "literal",
							value = t1.LaunchExperienceAction_ExperienceJoinData_ExperienceJoinDataLiteral.decode(v3141)
						}
					elseif v3138 == 2 then
						local v3142

						v3142, n211 = proto.readBuffer(p320, n211)
						v3136.kind = {
							type = "binding_path",
							value = buffer.tostring(v3142)
						}
					else
						local v3143, v3144 = proto.readVarInt(p320, n211)

						n211 = v3144 + v3143
					end
				elseif v3139 == proto.wireTypes.i32 then
					local v3145

					v3145, n211 = proto.readFixed32(p320, n211)
				elseif v3139 == proto.wireTypes.i64 then
					local v3146

					v3146, n211 = proto.readFixed64(p320, n211)
				else
					error("Unsupported wire type: " .. v3139)
				end
			end

			return v3136
		end
		function t423.jsonEncode(p321) -- line: 21103
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
		function t423.jsonDecode(t426: {[any]: any}) -- line: 21119
			-- upvalues: t423 (copy), t1 (copy)
			local v3150 = t423.new()

			if t426.literal ~= nil then
				v3150.kind = {
					type = "literal",
					value = t1.LaunchExperienceAction_ExperienceJoinData_ExperienceJoinDataLiteral.jsonDecode(t426.literal)
				}
			end

			if t426.binding_path ~= nil then
				v3150.kind = {
					type = "binding_path",
					value = t426.binding_path
				}
			end

			if t426.bindingPath ~= nil then
				v3150.kind = {
					type = "binding_path",
					value = t426.bindingPath
				}
			end

			return v3150
		end

		t423.descriptor = {
			name = "LaunchExperienceAction_ExperienceJoinData",
			fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceJoinData"
		}
		t1.LaunchExperienceAction_ExperienceJoinData = t423
		typeRegistry.default:register(t1.LaunchExperienceAction_ExperienceJoinData)

		local t427 = {}

		t427.__index = t427

		function t427.new(t428: {[any]: any}?) -- line: 21159
			-- upvalues: t427 (copy)
			return (setmetatable({
				launch_data = if t428 ~= nil and t428.launch_data ~= nil then t428.launch_data else nil,
				event_id = if t428 ~= nil and t428.event_id ~= nil then t428.event_id else nil
			}, t427))
		end
		function t427.encode(p322) -- line: 21171
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n212 = 0

			if p322.launch_data ~= nil then
				local v3155 = p322.launch_data:encode()
				local v3156, v3157 = proto.writeTag(buf, n212, 1, proto.wireTypes.lengthDelimited)

				buf, n212 = proto.writeBuffer(v3156, v3157, v3155, buffer.len(v3155))
			end

			if p322.event_id ~= nil then
				local v3158 = p322.event_id:encode()
				local v3159, v3160 = proto.writeTag(buf, n212, 2, proto.wireTypes.lengthDelimited)

				buf, n212 = proto.writeBuffer(v3159, v3160, v3158, buffer.len(v3158))
			end

			local buf109 = buffer.create(n212)

			buffer.copy(buf109, 0, buf, 0, n212)

			return buf109
		end
		function t427.decode(p323: buffer) -- line: 21194
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
						v3163.launch_data = prop_types.StringProp.decode(v3168)
					elseif v3165 == 2 then
						local v3169

						v3169, n213 = proto.readBuffer(p323, n213)
						v3163.event_id = prop_types.StringProp.decode(v3169)
					else
						local v3170, v3171 = proto.readVarInt(p323, n213)

						n213 = v3171 + v3170
					end
				elseif v3166 == proto.wireTypes.i32 then
					local v3172

					v3172, n213 = proto.readFixed32(p323, n213)
				elseif v3166 == proto.wireTypes.i64 then
					local v3173

					v3173, n213 = proto.readFixed64(p323, n213)
				else
					error("Unsupported wire type: " .. v3166)
				end
			end

			return v3163
		end
		function t427.jsonEncode(p324) -- line: 21244
			local t429 = {}

			if p324.launch_data ~= nil then
				t429.launchData = p324.launch_data:jsonEncode()
			end

			if p324.event_id ~= nil then
				t429.eventId = p324.event_id:jsonEncode()
			end

			return t429
		end
		function t427.jsonDecode(t430: {[any]: any}) -- line: 21260
			-- upvalues: t427 (copy), prop_types (copy)
			local v3177 = t427.new()

			if t430.launch_data ~= nil then
				v3177.launch_data = prop_types.StringProp.jsonDecode(t430.launch_data)
			end

			if t430.launchData ~= nil then
				v3177.launch_data = prop_types.StringProp.jsonDecode(t430.launchData)
			end

			if t430.event_id ~= nil then
				v3177.event_id = prop_types.StringProp.jsonDecode(t430.event_id)
			end

			if t430.eventId ~= nil then
				v3177.event_id = prop_types.StringProp.jsonDecode(t430.eventId)
			end

			return v3177
		end

		t427.descriptor = {
			name = "LaunchExperienceAction_ExperienceJoinData_ExperienceJoinDataLiteral",
			fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceJoinDataLiteral"
		}
		t1.LaunchExperienceAction_ExperienceJoinData_ExperienceJoinDataLiteral = t427
	end

	typeRegistry.default:register(t1.LaunchExperienceAction_ExperienceJoinData_ExperienceJoinDataLiteral)

	do
		local t431 = {}

		t431.__index = t431

		function t431.new(t432: {[any]: any}?) -- line: 21300
			-- upvalues: t431 (copy)
			return (setmetatable({
				place_id = if t432 ~= nil and t432.place_id ~= nil then t432.place_id else nil,
				universe_id = if t432 ~= nil and t432.universe_id ~= nil then t432.universe_id else nil,
				launch_source = if t432 ~= nil and t432.launch_source ~= nil then t432.launch_source else nil,
				experience_join_data = if t432 ~= nil and t432.experience_join_data ~= nil then t432.experience_join_data else nil
			}, t431))
		end
		function t431.encode(p325) -- line: 21313
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n214 = 0

			if p325.place_id ~= nil then
				local v3182 = p325.place_id:encode()
				local v3183, v3184 = proto.writeTag(buf, n214, 1, proto.wireTypes.lengthDelimited)

				buf, n214 = proto.writeBuffer(v3183, v3184, v3182, buffer.len(v3182))
			end

			if p325.universe_id ~= nil then
				local v3185 = p325.universe_id:encode()
				local v3186, v3187 = proto.writeTag(buf, n214, 2, proto.wireTypes.lengthDelimited)

				buf, n214 = proto.writeBuffer(v3186, v3187, v3185, buffer.len(v3185))
			end

			if p325.launch_source ~= nil then
				local v3188 = p325.launch_source:encode()
				local v3189, v3190 = proto.writeTag(buf, n214, 3, proto.wireTypes.lengthDelimited)

				buf, n214 = proto.writeBuffer(v3189, v3190, v3188, buffer.len(v3188))
			end

			if p325.experience_join_data ~= nil then
				local v3191 = p325.experience_join_data:encode()
				local v3192, v3193 = proto.writeTag(buf, n214, 4, proto.wireTypes.lengthDelimited)

				buf, n214 = proto.writeBuffer(v3192, v3193, v3191, buffer.len(v3191))
			end

			local buf110 = buffer.create(n214)

			buffer.copy(buf110, 0, buf, 0, n214)

			return buf110
		end
		function t431.decode(p326: buffer) -- line: 21346
			-- upvalues: t431 (copy), proto (copy), prop_types (copy), t1 (copy)
			local v3196 = t431.new()
			local n215 = 0

			while n215 < buffer.len(p326) do
				local v3198, v3199

				v3198, v3199, n215 = proto.readTag(p326, n215)

				if v3199 == proto.wireTypes.varint then
					local v3200

					v3200, n215 = proto.readVarInt(p326, n215)
				elseif v3199 == proto.wireTypes.lengthDelimited then
					if v3198 == 1 then
						local v3201

						v3201, n215 = proto.readBuffer(p326, n215)
						v3196.place_id = prop_types.StringProp.decode(v3201)
					elseif v3198 == 2 then
						local v3202

						v3202, n215 = proto.readBuffer(p326, n215)
						v3196.universe_id = prop_types.StringProp.decode(v3202)
					elseif v3198 == 3 then
						local v3203

						v3203, n215 = proto.readBuffer(p326, n215)
						v3196.launch_source = prop_types.StringProp.decode(v3203)
					elseif v3198 == 4 then
						local v3204

						v3204, n215 = proto.readBuffer(p326, n215)
						v3196.experience_join_data = t1.LaunchExperienceAction_ExperienceJoinData.decode(v3204)
					else
						local v3205, v3206 = proto.readVarInt(p326, n215)

						n215 = v3206 + v3205
					end
				elseif v3199 == proto.wireTypes.i32 then
					local v3207

					v3207, n215 = proto.readFixed32(p326, n215)
				elseif v3199 == proto.wireTypes.i64 then
					local v3208

					v3208, n215 = proto.readFixed64(p326, n215)
				else
					error("Unsupported wire type: " .. v3199)
				end
			end

			return v3196
		end
		function t431.jsonEncode(p327) -- line: 21404
			local t433 = {}

			if p327.place_id ~= nil then
				t433.placeId = p327.place_id:jsonEncode()
			end

			if p327.universe_id ~= nil then
				t433.universeId = p327.universe_id:jsonEncode()
			end

			if p327.launch_source ~= nil then
				t433.launchSource = p327.launch_source:jsonEncode()
			end

			if p327.experience_join_data ~= nil then
				t433.experienceJoinData = p327.experience_join_data:jsonEncode()
			end

			return t433
		end
		function t431.jsonDecode(t434: {[any]: any}) -- line: 21426
			-- upvalues: t431 (copy), prop_types (copy), t1 (copy)
			local v3212 = t431.new()

			if t434.place_id ~= nil then
				v3212.place_id = prop_types.StringProp.jsonDecode(t434.place_id)
			end

			if t434.placeId ~= nil then
				v3212.place_id = prop_types.StringProp.jsonDecode(t434.placeId)
			end

			if t434.universe_id ~= nil then
				v3212.universe_id = prop_types.StringProp.jsonDecode(t434.universe_id)
			end

			if t434.universeId ~= nil then
				v3212.universe_id = prop_types.StringProp.jsonDecode(t434.universeId)
			end

			if t434.launch_source ~= nil then
				v3212.launch_source = prop_types.StringProp.jsonDecode(t434.launch_source)
			end

			if t434.launchSource ~= nil then
				v3212.launch_source = prop_types.StringProp.jsonDecode(t434.launchSource)
			end

			if t434.experience_join_data ~= nil then
				v3212.experience_join_data = t1.LaunchExperienceAction_ExperienceJoinData.jsonDecode(t434.experience_join_data)
			end

			if t434.experienceJoinData ~= nil then
				v3212.experience_join_data = t1.LaunchExperienceAction_ExperienceJoinData.jsonDecode(t434.experienceJoinData)
			end

			return v3212
		end

		t431.descriptor = {
			name = "LaunchExperienceAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.LaunchExperienceAction_Params = t431
		typeRegistry.default:register(t1.LaunchExperienceAction_Params)

		local t435 = {}

		t435.__index = t435

		function t435.new(t436: {[any]: any}?) -- line: 21483
			-- upvalues: t1 (copy), t435 (copy)
			return (setmetatable({
				action_type = if t436 ~= nil and t436.action_type ~= nil then t436.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t436 ~= nil and t436.action_params ~= nil then t436.action_params else nil
			}, t435))
		end
		function t435.encode(p328) -- line: 21494
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n216 = 0

			if p328.action_type ~= nil and (p328.action_type ~= nil and p328.action_type ~= 0 or p328.action_type ~= t1.ActionType.fromNumber(0)) then
				local v3217, v3218 = proto.writeTag(buf, n216, 1, proto.wireTypes.varint)

				buf, n216 = proto.writeVarInt(v3217, v3218, t1.ActionType.toNumber(p328.action_type))
			end

			if p328.action_params ~= nil then
				local v3219 = p328.action_params:encode()
				local v3220, v3221 = proto.writeTag(buf, n216, 2, proto.wireTypes.lengthDelimited)

				buf, n216 = proto.writeBuffer(v3220, v3221, v3219, buffer.len(v3219))
			end

			local buf111 = buffer.create(n216)

			buffer.copy(buf111, 0, buf, 0, n216)

			return buf111
		end
		function t435.decode(p329: buffer) -- line: 21520
			-- upvalues: t435 (copy), proto (copy), t1 (copy)
			local v3224 = t435.new()
			local n217 = 0

			while n217 < buffer.len(p329) do
				local v3226, v3227

				v3226, v3227, n217 = proto.readTag(p329, n217)

				if v3227 == proto.wireTypes.varint then
					if v3226 == 1 then
						local v3228

						v3228, n217 = proto.readVarIntI32(p329, n217)
						v3224.action_type = t1.ActionType.fromNumber(v3228) or v3228
					else
						local v3229

						v3229, n217 = proto.readVarInt(p329, n217)
					end
				elseif v3227 == proto.wireTypes.lengthDelimited then
					if v3226 == 2 then
						local v3230

						v3230, n217 = proto.readBuffer(p329, n217)
						v3224.action_params = t1.ToggleExperienceFavoriteAction_Params.decode(v3230)
					else
						local v3231, v3232 = proto.readVarInt(p329, n217)

						n217 = v3232 + v3231
					end
				elseif v3227 == proto.wireTypes.i32 then
					local v3233

					v3233, n217 = proto.readFixed32(p329, n217)
				elseif v3227 == proto.wireTypes.i64 then
					local v3234

					v3234, n217 = proto.readFixed64(p329, n217)
				else
					error("Unsupported wire type: " .. v3227)
				end
			end

			return v3224
		end
		function t435.jsonEncode(p330) -- line: 21568
			-- upvalues: t1 (copy)
			local t437 = {}

			if p330.action_type ~= nil and (p330.action_type ~= nil and p330.action_type ~= 0 or p330.action_type ~= t1.ActionType.fromNumber(0)) then
				t437.actionType = if typeof(p330.action_type) ~= "number" then t1.ActionType.toNumber(p330.action_type) else p330.action_type
			end

			if p330.action_params ~= nil then
				t437.actionParams = p330.action_params:jsonEncode()
			end

			return t437
		end
		function t435.jsonDecode(t438: {[any]: any}) -- line: 21590
			-- upvalues: t435 (copy), t1 (copy)
			local v3238 = t435.new()

			if t438.action_type ~= nil then
				v3238.action_type = if typeof(t438.action_type) ~= "number" then t1.ActionType.fromName(t438.action_type) or t438.action_type else t1.ActionType.fromNumber(t438.action_type) or t438.action_type
			end

			if t438.actionType ~= nil then
				v3238.action_type = if typeof(t438.actionType) ~= "number" then t1.ActionType.fromName(t438.actionType) or t438.actionType else t1.ActionType.fromNumber(t438.actionType) or t438.actionType
			end

			if t438.action_params ~= nil then
				v3238.action_params = t1.ToggleExperienceFavoriteAction_Params.jsonDecode(t438.action_params)
			end

			if t438.actionParams ~= nil then
				v3238.action_params = t1.ToggleExperienceFavoriteAction_Params.jsonDecode(t438.actionParams)
			end

			return v3238
		end

		t435.descriptor = {
			name = "ToggleExperienceFavoriteAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.ToggleExperienceFavoriteAction"
		}
		t1.ToggleExperienceFavoriteAction = t435
	end

	typeRegistry.default:register(t1.ToggleExperienceFavoriteAction)

	do
		local t439 = {}

		t439.__index = t439

		function t439.new(t440: {[any]: any}?) -- line: 21630
			-- upvalues: t439 (copy)
			return (setmetatable({
				universe_id = if t440 ~= nil and t440.universe_id ~= nil then t440.universe_id else nil,
				place_id = if t440 ~= nil and t440.place_id ~= nil then t440.place_id else nil,
				ctx = if t440 ~= nil and t440.ctx ~= nil then t440.ctx else nil
			}, t439))
		end
		function t439.encode(p331) -- line: 21640
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n218 = 0

			if p331.universe_id ~= nil then
				local v3243 = p331.universe_id:encode()
				local v3244, v3245 = proto.writeTag(buf, n218, 1, proto.wireTypes.lengthDelimited)

				buf, n218 = proto.writeBuffer(v3244, v3245, v3243, buffer.len(v3243))
			end

			if p331.place_id ~= nil then
				local v3246 = p331.place_id:encode()
				local v3247, v3248 = proto.writeTag(buf, n218, 2, proto.wireTypes.lengthDelimited)

				buf, n218 = proto.writeBuffer(v3247, v3248, v3246, buffer.len(v3246))
			end

			if p331.ctx ~= nil then
				local v3249 = p331.ctx:encode()
				local v3250, v3251 = proto.writeTag(buf, n218, 3, proto.wireTypes.lengthDelimited)

				buf, n218 = proto.writeBuffer(v3250, v3251, v3249, buffer.len(v3249))
			end

			local buf112 = buffer.create(n218)

			buffer.copy(buf112, 0, buf, 0, n218)

			return buf112
		end
		function t439.decode(p332: buffer) -- line: 21667
			-- upvalues: t439 (copy), proto (copy), prop_types (copy)
			local v3254 = t439.new()
			local n219 = 0

			while n219 < buffer.len(p332) do
				local v3256, v3257

				v3256, v3257, n219 = proto.readTag(p332, n219)

				if v3257 == proto.wireTypes.varint then
					local v3258

					v3258, n219 = proto.readVarInt(p332, n219)
				elseif v3257 == proto.wireTypes.lengthDelimited then
					if v3256 == 1 then
						local v3259

						v3259, n219 = proto.readBuffer(p332, n219)
						v3254.universe_id = prop_types.StringProp.decode(v3259)
					elseif v3256 == 2 then
						local v3260

						v3260, n219 = proto.readBuffer(p332, n219)
						v3254.place_id = prop_types.StringProp.decode(v3260)
					elseif v3256 == 3 then
						local v3261

						v3261, n219 = proto.readBuffer(p332, n219)
						v3254.ctx = prop_types.StringProp.decode(v3261)
					else
						local v3262, v3263 = proto.readVarInt(p332, n219)

						n219 = v3263 + v3262
					end
				elseif v3257 == proto.wireTypes.i32 then
					local v3264

					v3264, n219 = proto.readFixed32(p332, n219)
				elseif v3257 == proto.wireTypes.i64 then
					local v3265

					v3265, n219 = proto.readFixed64(p332, n219)
				else
					error("Unsupported wire type: " .. v3257)
				end
			end

			return v3254
		end
		function t439.jsonEncode(p333) -- line: 21720
			local t441 = {}

			if p333.universe_id ~= nil then
				t441.universeId = p333.universe_id:jsonEncode()
			end

			if p333.place_id ~= nil then
				t441.placeId = p333.place_id:jsonEncode()
			end

			if p333.ctx ~= nil then
				t441.ctx = p333.ctx:jsonEncode()
			end

			return t441
		end
		function t439.jsonDecode(t442: {[any]: any}) -- line: 21738
			-- upvalues: t439 (copy), prop_types (copy)
			local v3269 = t439.new()

			if t442.universe_id ~= nil then
				v3269.universe_id = prop_types.StringProp.jsonDecode(t442.universe_id)
			end

			if t442.universeId ~= nil then
				v3269.universe_id = prop_types.StringProp.jsonDecode(t442.universeId)
			end

			if t442.place_id ~= nil then
				v3269.place_id = prop_types.StringProp.jsonDecode(t442.place_id)
			end

			if t442.placeId ~= nil then
				v3269.place_id = prop_types.StringProp.jsonDecode(t442.placeId)
			end

			if t442.ctx ~= nil then
				v3269.ctx = prop_types.StringProp.jsonDecode(t442.ctx)
			end

			return v3269
		end

		t439.descriptor = {
			name = "ToggleExperienceFavoriteAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.ToggleExperienceFavoriteAction_Params = t439
		typeRegistry.default:register(t1.ToggleExperienceFavoriteAction_Params)

		local t443 = {}

		t443.__index = t443

		function t443.new(t444: {[any]: any}?) -- line: 21781
			-- upvalues: t1 (copy), t443 (copy)
			return (setmetatable({
				action_type = if t444 ~= nil and t444.action_type ~= nil then t444.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t444 ~= nil and t444.action_params ~= nil then t444.action_params else nil
			}, t443))
		end
		function t443.encode(p334) -- line: 21792
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n220 = 0

			if p334.action_type ~= nil and (p334.action_type ~= nil and p334.action_type ~= 0 or p334.action_type ~= t1.ActionType.fromNumber(0)) then
				local v3274, v3275 = proto.writeTag(buf, n220, 1, proto.wireTypes.varint)

				buf, n220 = proto.writeVarInt(v3274, v3275, t1.ActionType.toNumber(p334.action_type))
			end

			if p334.action_params ~= nil then
				local v3276 = p334.action_params:encode()
				local v3277, v3278 = proto.writeTag(buf, n220, 2, proto.wireTypes.lengthDelimited)

				buf, n220 = proto.writeBuffer(v3277, v3278, v3276, buffer.len(v3276))
			end

			local buf113 = buffer.create(n220)

			buffer.copy(buf113, 0, buf, 0, n220)

			return buf113
		end
		function t443.decode(p335: buffer) -- line: 21818
			-- upvalues: t443 (copy), proto (copy), t1 (copy)
			local v3281 = t443.new()
			local n221 = 0

			while n221 < buffer.len(p335) do
				local v3283, v3284

				v3283, v3284, n221 = proto.readTag(p335, n221)

				if v3284 == proto.wireTypes.varint then
					if v3283 == 1 then
						local v3285

						v3285, n221 = proto.readVarIntI32(p335, n221)
						v3281.action_type = t1.ActionType.fromNumber(v3285) or v3285
					else
						local v3286

						v3286, n221 = proto.readVarInt(p335, n221)
					end
				elseif v3284 == proto.wireTypes.lengthDelimited then
					if v3283 == 2 then
						local v3287

						v3287, n221 = proto.readBuffer(p335, n221)
						v3281.action_params = t1.ToggleExperienceFollowAction_Params.decode(v3287)
					else
						local v3288, v3289 = proto.readVarInt(p335, n221)

						n221 = v3289 + v3288
					end
				elseif v3284 == proto.wireTypes.i32 then
					local v3290

					v3290, n221 = proto.readFixed32(p335, n221)
				elseif v3284 == proto.wireTypes.i64 then
					local v3291

					v3291, n221 = proto.readFixed64(p335, n221)
				else
					error("Unsupported wire type: " .. v3284)
				end
			end

			return v3281
		end
		function t443.jsonEncode(p336) -- line: 21866
			-- upvalues: t1 (copy)
			local t445 = {}

			if p336.action_type ~= nil and (p336.action_type ~= nil and p336.action_type ~= 0 or p336.action_type ~= t1.ActionType.fromNumber(0)) then
				t445.actionType = if typeof(p336.action_type) ~= "number" then t1.ActionType.toNumber(p336.action_type) else p336.action_type
			end

			if p336.action_params ~= nil then
				t445.actionParams = p336.action_params:jsonEncode()
			end

			return t445
		end
		function t443.jsonDecode(t446: {[any]: any}) -- line: 21888
			-- upvalues: t443 (copy), t1 (copy)
			local v3295 = t443.new()

			if t446.action_type ~= nil then
				v3295.action_type = if typeof(t446.action_type) ~= "number" then t1.ActionType.fromName(t446.action_type) or t446.action_type else t1.ActionType.fromNumber(t446.action_type) or t446.action_type
			end

			if t446.actionType ~= nil then
				v3295.action_type = if typeof(t446.actionType) ~= "number" then t1.ActionType.fromName(t446.actionType) or t446.actionType else t1.ActionType.fromNumber(t446.actionType) or t446.actionType
			end

			if t446.action_params ~= nil then
				v3295.action_params = t1.ToggleExperienceFollowAction_Params.jsonDecode(t446.action_params)
			end

			if t446.actionParams ~= nil then
				v3295.action_params = t1.ToggleExperienceFollowAction_Params.jsonDecode(t446.actionParams)
			end

			return v3295
		end

		t443.descriptor = {
			name = "ToggleExperienceFollowAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.ToggleExperienceFollowAction"
		}
		t1.ToggleExperienceFollowAction = t443
	end

	typeRegistry.default:register(t1.ToggleExperienceFollowAction)

	do
		local t447 = {}

		t447.__index = t447

		function t447.new(t448: {[any]: any}?) -- line: 21928
			-- upvalues: t447 (copy)
			return (setmetatable({
				universe_id = if t448 ~= nil and t448.universe_id ~= nil then t448.universe_id else nil,
				game_name = if t448 ~= nil and t448.game_name ~= nil then t448.game_name else nil,
				ctx = if t448 ~= nil and t448.ctx ~= nil then t448.ctx else nil
			}, t447))
		end
		function t447.encode(p337) -- line: 21938
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n222 = 0

			if p337.universe_id ~= nil then
				local v3300 = p337.universe_id:encode()
				local v3301, v3302 = proto.writeTag(buf, n222, 1, proto.wireTypes.lengthDelimited)

				buf, n222 = proto.writeBuffer(v3301, v3302, v3300, buffer.len(v3300))
			end

			if p337.game_name ~= nil then
				local v3303 = p337.game_name:encode()
				local v3304, v3305 = proto.writeTag(buf, n222, 2, proto.wireTypes.lengthDelimited)

				buf, n222 = proto.writeBuffer(v3304, v3305, v3303, buffer.len(v3303))
			end

			if p337.ctx ~= nil then
				local v3306 = p337.ctx:encode()
				local v3307, v3308 = proto.writeTag(buf, n222, 3, proto.wireTypes.lengthDelimited)

				buf, n222 = proto.writeBuffer(v3307, v3308, v3306, buffer.len(v3306))
			end

			local buf114 = buffer.create(n222)

			buffer.copy(buf114, 0, buf, 0, n222)

			return buf114
		end
		function t447.decode(p338: buffer) -- line: 21965
			-- upvalues: t447 (copy), proto (copy), prop_types (copy)
			local v3311 = t447.new()
			local n223 = 0

			while n223 < buffer.len(p338) do
				local v3313, v3314

				v3313, v3314, n223 = proto.readTag(p338, n223)

				if v3314 == proto.wireTypes.varint then
					local v3315

					v3315, n223 = proto.readVarInt(p338, n223)
				elseif v3314 == proto.wireTypes.lengthDelimited then
					if v3313 == 1 then
						local v3316

						v3316, n223 = proto.readBuffer(p338, n223)
						v3311.universe_id = prop_types.StringProp.decode(v3316)
					elseif v3313 == 2 then
						local v3317

						v3317, n223 = proto.readBuffer(p338, n223)
						v3311.game_name = prop_types.StringProp.decode(v3317)
					elseif v3313 == 3 then
						local v3318

						v3318, n223 = proto.readBuffer(p338, n223)
						v3311.ctx = prop_types.StringProp.decode(v3318)
					else
						local v3319, v3320 = proto.readVarInt(p338, n223)

						n223 = v3320 + v3319
					end
				elseif v3314 == proto.wireTypes.i32 then
					local v3321

					v3321, n223 = proto.readFixed32(p338, n223)
				elseif v3314 == proto.wireTypes.i64 then
					local v3322

					v3322, n223 = proto.readFixed64(p338, n223)
				else
					error("Unsupported wire type: " .. v3314)
				end
			end

			return v3311
		end
		function t447.jsonEncode(p339) -- line: 22018
			local t449 = {}

			if p339.universe_id ~= nil then
				t449.universeId = p339.universe_id:jsonEncode()
			end

			if p339.game_name ~= nil then
				t449.gameName = p339.game_name:jsonEncode()
			end

			if p339.ctx ~= nil then
				t449.ctx = p339.ctx:jsonEncode()
			end

			return t449
		end
		function t447.jsonDecode(t450: {[any]: any}) -- line: 22036
			-- upvalues: t447 (copy), prop_types (copy)
			local v3326 = t447.new()

			if t450.universe_id ~= nil then
				v3326.universe_id = prop_types.StringProp.jsonDecode(t450.universe_id)
			end

			if t450.universeId ~= nil then
				v3326.universe_id = prop_types.StringProp.jsonDecode(t450.universeId)
			end

			if t450.game_name ~= nil then
				v3326.game_name = prop_types.StringProp.jsonDecode(t450.game_name)
			end

			if t450.gameName ~= nil then
				v3326.game_name = prop_types.StringProp.jsonDecode(t450.gameName)
			end

			if t450.ctx ~= nil then
				v3326.ctx = prop_types.StringProp.jsonDecode(t450.ctx)
			end

			return v3326
		end

		t447.descriptor = {
			name = "ToggleExperienceFollowAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.ToggleExperienceFollowAction_Params = t447
		typeRegistry.default:register(t1.ToggleExperienceFollowAction_Params)

		local t451 = {}

		t451.__index = t451

		function t451.new(t452: {[any]: any}?) -- line: 22079
			-- upvalues: t1 (copy), t451 (copy)
			return (setmetatable({
				action_type = if t452 ~= nil and t452.action_type ~= nil then t452.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t452 ~= nil and t452.action_params ~= nil then t452.action_params else nil
			}, t451))
		end
		function t451.encode(p340) -- line: 22090
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n224 = 0

			if p340.action_type ~= nil and (p340.action_type ~= nil and p340.action_type ~= 0 or p340.action_type ~= t1.ActionType.fromNumber(0)) then
				local v3331, v3332 = proto.writeTag(buf, n224, 1, proto.wireTypes.varint)

				buf, n224 = proto.writeVarInt(v3331, v3332, t1.ActionType.toNumber(p340.action_type))
			end

			if p340.action_params ~= nil then
				local v3333 = p340.action_params:encode()
				local v3334, v3335 = proto.writeTag(buf, n224, 2, proto.wireTypes.lengthDelimited)

				buf, n224 = proto.writeBuffer(v3334, v3335, v3333, buffer.len(v3333))
			end

			local buf115 = buffer.create(n224)

			buffer.copy(buf115, 0, buf, 0, n224)

			return buf115
		end
		function t451.decode(p341: buffer) -- line: 22116
			-- upvalues: t451 (copy), proto (copy), t1 (copy)
			local v3338 = t451.new()
			local n225 = 0

			while n225 < buffer.len(p341) do
				local v3340, v3341

				v3340, v3341, n225 = proto.readTag(p341, n225)

				if v3341 == proto.wireTypes.varint then
					if v3340 == 1 then
						local v3342

						v3342, n225 = proto.readVarIntI32(p341, n225)
						v3338.action_type = t1.ActionType.fromNumber(v3342) or v3342
					else
						local v3343

						v3343, n225 = proto.readVarInt(p341, n225)
					end
				elseif v3341 == proto.wireTypes.lengthDelimited then
					if v3340 == 2 then
						local v3344

						v3344, n225 = proto.readBuffer(p341, n225)
						v3338.action_params = t1.ToggleExperienceVoteAction_Params.decode(v3344)
					else
						local v3345, v3346 = proto.readVarInt(p341, n225)

						n225 = v3346 + v3345
					end
				elseif v3341 == proto.wireTypes.i32 then
					local v3347

					v3347, n225 = proto.readFixed32(p341, n225)
				elseif v3341 == proto.wireTypes.i64 then
					local v3348

					v3348, n225 = proto.readFixed64(p341, n225)
				else
					error("Unsupported wire type: " .. v3341)
				end
			end

			return v3338
		end
		function t451.jsonEncode(p342) -- line: 22164
			-- upvalues: t1 (copy)
			local t453 = {}

			if p342.action_type ~= nil and (p342.action_type ~= nil and p342.action_type ~= 0 or p342.action_type ~= t1.ActionType.fromNumber(0)) then
				t453.actionType = if typeof(p342.action_type) ~= "number" then t1.ActionType.toNumber(p342.action_type) else p342.action_type
			end

			if p342.action_params ~= nil then
				t453.actionParams = p342.action_params:jsonEncode()
			end

			return t453
		end
		function t451.jsonDecode(t454: {[any]: any}) -- line: 22186
			-- upvalues: t451 (copy), t1 (copy)
			local v3352 = t451.new()

			if t454.action_type ~= nil then
				v3352.action_type = if typeof(t454.action_type) ~= "number" then t1.ActionType.fromName(t454.action_type) or t454.action_type else t1.ActionType.fromNumber(t454.action_type) or t454.action_type
			end

			if t454.actionType ~= nil then
				v3352.action_type = if typeof(t454.actionType) ~= "number" then t1.ActionType.fromName(t454.actionType) or t454.actionType else t1.ActionType.fromNumber(t454.actionType) or t454.actionType
			end

			if t454.action_params ~= nil then
				v3352.action_params = t1.ToggleExperienceVoteAction_Params.jsonDecode(t454.action_params)
			end

			if t454.actionParams ~= nil then
				v3352.action_params = t1.ToggleExperienceVoteAction_Params.jsonDecode(t454.actionParams)
			end

			return v3352
		end

		t451.descriptor = {
			name = "ToggleExperienceVoteAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.ToggleExperienceVoteAction"
		}
		t1.ToggleExperienceVoteAction = t451
	end

	typeRegistry.default:register(t1.ToggleExperienceVoteAction)

	do
		local t455 = {}

		t455.__index = t455

		function t455.new(t456: {[any]: any}?) -- line: 22226
			-- upvalues: t455 (copy)
			return (setmetatable({
				universe_id = if t456 ~= nil and t456.universe_id ~= nil then t456.universe_id else nil,
				vote_direction = if t456 ~= nil and t456.vote_direction ~= nil then t456.vote_direction else nil,
				place_id = if t456 ~= nil and t456.place_id ~= nil then t456.place_id else nil,
				ctx = if t456 ~= nil and t456.ctx ~= nil then t456.ctx else nil
			}, t455))
		end
		function t455.encode(p343) -- line: 22237
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n226 = 0

			if p343.universe_id ~= nil then
				local v3357 = p343.universe_id:encode()
				local v3358, v3359 = proto.writeTag(buf, n226, 1, proto.wireTypes.lengthDelimited)

				buf, n226 = proto.writeBuffer(v3358, v3359, v3357, buffer.len(v3357))
			end

			if p343.vote_direction ~= nil then
				local v3360 = p343.vote_direction:encode()
				local v3361, v3362 = proto.writeTag(buf, n226, 2, proto.wireTypes.lengthDelimited)

				buf, n226 = proto.writeBuffer(v3361, v3362, v3360, buffer.len(v3360))
			end

			if p343.place_id ~= nil then
				local v3363 = p343.place_id:encode()
				local v3364, v3365 = proto.writeTag(buf, n226, 3, proto.wireTypes.lengthDelimited)

				buf, n226 = proto.writeBuffer(v3364, v3365, v3363, buffer.len(v3363))
			end

			if p343.ctx ~= nil then
				local v3366 = p343.ctx:encode()
				local v3367, v3368 = proto.writeTag(buf, n226, 4, proto.wireTypes.lengthDelimited)

				buf, n226 = proto.writeBuffer(v3367, v3368, v3366, buffer.len(v3366))
			end

			local buf116 = buffer.create(n226)

			buffer.copy(buf116, 0, buf, 0, n226)

			return buf116
		end
		function t455.decode(p344: buffer) -- line: 22270
			-- upvalues: t455 (copy), proto (copy), prop_types (copy)
			local v3371 = t455.new()
			local n227 = 0

			while n227 < buffer.len(p344) do
				local v3373, v3374

				v3373, v3374, n227 = proto.readTag(p344, n227)

				if v3374 == proto.wireTypes.varint then
					local v3375

					v3375, n227 = proto.readVarInt(p344, n227)
				elseif v3374 == proto.wireTypes.lengthDelimited then
					if v3373 == 1 then
						local v3376

						v3376, n227 = proto.readBuffer(p344, n227)
						v3371.universe_id = prop_types.StringProp.decode(v3376)
					elseif v3373 == 2 then
						local v3377

						v3377, n227 = proto.readBuffer(p344, n227)
						v3371.vote_direction = prop_types.BoolProp.decode(v3377)
					elseif v3373 == 3 then
						local v3378

						v3378, n227 = proto.readBuffer(p344, n227)
						v3371.place_id = prop_types.StringProp.decode(v3378)
					elseif v3373 == 4 then
						local v3379

						v3379, n227 = proto.readBuffer(p344, n227)
						v3371.ctx = prop_types.StringProp.decode(v3379)
					else
						local v3380, v3381 = proto.readVarInt(p344, n227)

						n227 = v3381 + v3380
					end
				elseif v3374 == proto.wireTypes.i32 then
					local v3382

					v3382, n227 = proto.readFixed32(p344, n227)
				elseif v3374 == proto.wireTypes.i64 then
					local v3383

					v3383, n227 = proto.readFixed64(p344, n227)
				else
					error("Unsupported wire type: " .. v3374)
				end
			end

			return v3371
		end
		function t455.jsonEncode(p345) -- line: 22328
			local t457 = {}

			if p345.universe_id ~= nil then
				t457.universeId = p345.universe_id:jsonEncode()
			end

			if p345.vote_direction ~= nil then
				t457.voteDirection = p345.vote_direction:jsonEncode()
			end

			if p345.place_id ~= nil then
				t457.placeId = p345.place_id:jsonEncode()
			end

			if p345.ctx ~= nil then
				t457.ctx = p345.ctx:jsonEncode()
			end

			return t457
		end
		function t455.jsonDecode(t458: {[any]: any}) -- line: 22350
			-- upvalues: t455 (copy), prop_types (copy)
			local v3387 = t455.new()

			if t458.universe_id ~= nil then
				v3387.universe_id = prop_types.StringProp.jsonDecode(t458.universe_id)
			end

			if t458.universeId ~= nil then
				v3387.universe_id = prop_types.StringProp.jsonDecode(t458.universeId)
			end

			if t458.vote_direction ~= nil then
				v3387.vote_direction = prop_types.BoolProp.jsonDecode(t458.vote_direction)
			end

			if t458.voteDirection ~= nil then
				v3387.vote_direction = prop_types.BoolProp.jsonDecode(t458.voteDirection)
			end

			if t458.place_id ~= nil then
				v3387.place_id = prop_types.StringProp.jsonDecode(t458.place_id)
			end

			if t458.placeId ~= nil then
				v3387.place_id = prop_types.StringProp.jsonDecode(t458.placeId)
			end

			if t458.ctx ~= nil then
				v3387.ctx = prop_types.StringProp.jsonDecode(t458.ctx)
			end

			return v3387
		end

		t455.descriptor = {
			name = "ToggleExperienceVoteAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.ToggleExperienceVoteAction_Params = t455
		typeRegistry.default:register(t1.ToggleExperienceVoteAction_Params)

		local t459 = {}

		t459.__index = t459

		function t459.new(t460: {[any]: any}?) -- line: 22403
			-- upvalues: t1 (copy), t459 (copy)
			return (setmetatable({
				action_type = if t460 ~= nil and t460.action_type ~= nil then t460.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t460 ~= nil and t460.action_params ~= nil then t460.action_params else nil
			}, t459))
		end
		function t459.encode(p346) -- line: 22412
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n228 = 0

			if p346.action_type ~= nil and (p346.action_type ~= nil and p346.action_type ~= 0 or p346.action_type ~= t1.ActionType.fromNumber(0)) then
				local v3392, v3393 = proto.writeTag(buf, n228, 1, proto.wireTypes.varint)

				buf, n228 = proto.writeVarInt(v3392, v3393, t1.ActionType.toNumber(p346.action_type))
			end

			if p346.action_params ~= nil then
				local v3394 = p346.action_params:encode()
				local v3395, v3396 = proto.writeTag(buf, n228, 2, proto.wireTypes.lengthDelimited)

				buf, n228 = proto.writeBuffer(v3395, v3396, v3394, buffer.len(v3394))
			end

			local buf117 = buffer.create(n228)

			buffer.copy(buf117, 0, buf, 0, n228)

			return buf117
		end
		function t459.decode(p347: buffer) -- line: 22438
			-- upvalues: t459 (copy), proto (copy), t1 (copy)
			local v3399 = t459.new()
			local n229 = 0

			while n229 < buffer.len(p347) do
				local v3401, v3402

				v3401, v3402, n229 = proto.readTag(p347, n229)

				if v3402 == proto.wireTypes.varint then
					if v3401 == 1 then
						local v3403

						v3403, n229 = proto.readVarIntI32(p347, n229)
						v3399.action_type = t1.ActionType.fromNumber(v3403) or v3403
					else
						local v3404

						v3404, n229 = proto.readVarInt(p347, n229)
					end
				elseif v3402 == proto.wireTypes.lengthDelimited then
					if v3401 == 2 then
						local v3405

						v3405, n229 = proto.readBuffer(p347, n229)
						v3399.action_params = t1.OpenPurchasePromptAction_Params.decode(v3405)
					else
						local v3406, v3407 = proto.readVarInt(p347, n229)

						n229 = v3407 + v3406
					end
				elseif v3402 == proto.wireTypes.i32 then
					local v3408

					v3408, n229 = proto.readFixed32(p347, n229)
				elseif v3402 == proto.wireTypes.i64 then
					local v3409

					v3409, n229 = proto.readFixed64(p347, n229)
				else
					error("Unsupported wire type: " .. v3402)
				end
			end

			return v3399
		end
		function t459.jsonEncode(p348) -- line: 22486
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
		function t459.jsonDecode(t462: {[any]: any}) -- line: 22508
			-- upvalues: t459 (copy), t1 (copy)
			local v3413 = t459.new()

			if t462.action_type ~= nil then
				v3413.action_type = if typeof(t462.action_type) ~= "number" then t1.ActionType.fromName(t462.action_type) or t462.action_type else t1.ActionType.fromNumber(t462.action_type) or t462.action_type
			end

			if t462.actionType ~= nil then
				v3413.action_type = if typeof(t462.actionType) ~= "number" then t1.ActionType.fromName(t462.actionType) or t462.actionType else t1.ActionType.fromNumber(t462.actionType) or t462.actionType
			end

			if t462.action_params ~= nil then
				v3413.action_params = t1.OpenPurchasePromptAction_Params.jsonDecode(t462.action_params)
			end

			if t462.actionParams ~= nil then
				v3413.action_params = t1.OpenPurchasePromptAction_Params.jsonDecode(t462.actionParams)
			end

			return v3413
		end

		t459.descriptor = {
			name = "OpenPurchasePromptAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenPurchasePromptAction"
		}
		t1.OpenPurchasePromptAction = t459
	end

	typeRegistry.default:register(t1.OpenPurchasePromptAction)

	do
		local t463 = {}

		t463.__index = t463

		function t463.new(t464: {[any]: any}?) -- line: 22548
			-- upvalues: t463 (copy)
			return (setmetatable({
				kind = if t464 ~= nil and t464.kind ~= nil then t464.kind else nil
			}, t463))
		end
		function t463.encode(p349) -- line: 22556
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n230 = 0

			if p349.kind ~= nil then
				if p349.kind.type == "literal" then
					local v3418 = p349.kind.value:encode()
					local v3419, v3420 = proto.writeTag(buf, n230, 1, proto.wireTypes.lengthDelimited)

					buf, n230 = proto.writeBuffer(v3419, v3420, v3418, buffer.len(v3418))
				elseif p349.kind.type == "binding_path" then
					local v3421, v3422 = proto.writeTag(buf, n230, 2, proto.wireTypes.lengthDelimited)

					buf, n230 = proto.writeString(v3421, v3422, p349.kind.value)
				end
			end

			local buf118 = buffer.create(n230)

			buffer.copy(buf118, 0, buf, 0, n230)

			return buf118
		end
		function t463.decode(p350: buffer) -- line: 22576
			-- upvalues: t463 (copy), proto (copy), t1 (copy)
			local v3425 = t463.new()
			local n231 = 0

			while n231 < buffer.len(p350) do
				local v3427, v3428

				v3427, v3428, n231 = proto.readTag(p350, n231)

				if v3428 == proto.wireTypes.varint then
					local v3429

					v3429, n231 = proto.readVarInt(p350, n231)
				elseif v3428 == proto.wireTypes.lengthDelimited then
					if v3427 == 1 then
						local v3430

						v3430, n231 = proto.readBuffer(p350, n231)
						v3425.kind = {
							type = "literal",
							value = t1.OpenPurchasePromptAction_ProductPayload_ProductPayloadLiteral.decode(v3430)
						}
					elseif v3427 == 2 then
						local v3431

						v3431, n231 = proto.readBuffer(p350, n231)
						v3425.kind = {
							type = "binding_path",
							value = buffer.tostring(v3431)
						}
					else
						local v3432, v3433 = proto.readVarInt(p350, n231)

						n231 = v3433 + v3432
					end
				elseif v3428 == proto.wireTypes.i32 then
					local v3434

					v3434, n231 = proto.readFixed32(p350, n231)
				elseif v3428 == proto.wireTypes.i64 then
					local v3435

					v3435, n231 = proto.readFixed64(p350, n231)
				else
					error("Unsupported wire type: " .. v3428)
				end
			end

			return v3425
		end
		function t463.jsonEncode(p351) -- line: 22627
			local t465 = {}

			if p351.kind ~= nil then
				if p351.kind.type == "literal" then
					t465.literal = p351.kind.value:jsonEncode()

					return t465
				end

				if p351.kind.type == "binding_path" then
					t465.bindingPath = p351.kind.value
				end
			end

			return t465
		end
		function t463.jsonDecode(t466: {[any]: any}) -- line: 22641
			-- upvalues: t463 (copy), t1 (copy)
			local v3439 = t463.new()

			if t466.literal ~= nil then
				v3439.kind = {
					type = "literal",
					value = t1.OpenPurchasePromptAction_ProductPayload_ProductPayloadLiteral.jsonDecode(t466.literal)
				}
			end

			if t466.binding_path ~= nil then
				v3439.kind = {
					type = "binding_path",
					value = t466.binding_path
				}
			end

			if t466.bindingPath ~= nil then
				v3439.kind = {
					type = "binding_path",
					value = t466.bindingPath
				}
			end

			return v3439
		end

		t463.descriptor = {
			name = "OpenPurchasePromptAction_ProductPayload",
			fullName = "roblox.apppageplatform.shared.v1beta1.ProductPayload"
		}
		t1.OpenPurchasePromptAction_ProductPayload = t463
		typeRegistry.default:register(t1.OpenPurchasePromptAction_ProductPayload)

		local t467 = {}

		t467.__index = t467

		function t467.new(t468: {[any]: any}?) -- line: 22681
			-- upvalues: t467 (copy)
			return (setmetatable({
				kind = if t468 ~= nil and t468.kind ~= nil then t468.kind else nil,
				id = if t468 ~= nil and t468.id ~= nil then t468.id else nil,
				subscription_id = if t468 ~= nil and t468.subscription_id ~= nil then t468.subscription_id else nil,
				universe_id = if t468 ~= nil and t468.universe_id ~= nil then t468.universe_id else nil,
				equip_if_purchased = if t468 ~= nil and t468.equip_if_purchased ~= nil then t468.equip_if_purchased else nil,
				name = if t468 ~= nil and t468.name ~= nil then t468.name else nil,
				expected_price = if t468 ~= nil and t468.expected_price ~= nil then t468.expected_price else nil,
				icon_image_asset_id = if t468 ~= nil and t468.icon_image_asset_id ~= nil then t468.icon_image_asset_id else nil,
				is_subscription_in_robux = if t468 ~= nil and t468.is_subscription_in_robux ~= nil then t468.is_subscription_in_robux else nil,
				display_price = if t468 ~= nil and t468.display_price ~= nil then t468.display_price else nil
			}, t467))
		end
		function t467.encode(p352) -- line: 22707
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n232 = 0

			if p352.kind ~= nil then
				local v3444 = p352.kind:encode()
				local v3445, v3446 = proto.writeTag(buf, n232, 1, proto.wireTypes.lengthDelimited)

				buf, n232 = proto.writeBuffer(v3445, v3446, v3444, buffer.len(v3444))
			end

			if p352.id ~= nil then
				local v3447 = p352.id:encode()
				local v3448, v3449 = proto.writeTag(buf, n232, 2, proto.wireTypes.lengthDelimited)

				buf, n232 = proto.writeBuffer(v3448, v3449, v3447, buffer.len(v3447))
			end

			if p352.subscription_id ~= nil then
				local v3450 = p352.subscription_id:encode()
				local v3451, v3452 = proto.writeTag(buf, n232, 3, proto.wireTypes.lengthDelimited)

				buf, n232 = proto.writeBuffer(v3451, v3452, v3450, buffer.len(v3450))
			end

			if p352.universe_id ~= nil then
				local v3453 = p352.universe_id:encode()
				local v3454, v3455 = proto.writeTag(buf, n232, 4, proto.wireTypes.lengthDelimited)

				buf, n232 = proto.writeBuffer(v3454, v3455, v3453, buffer.len(v3453))
			end

			if p352.equip_if_purchased ~= nil then
				local v3456 = p352.equip_if_purchased:encode()
				local v3457, v3458 = proto.writeTag(buf, n232, 5, proto.wireTypes.lengthDelimited)

				buf, n232 = proto.writeBuffer(v3457, v3458, v3456, buffer.len(v3456))
			end

			if p352.name ~= nil then
				local v3459 = p352.name:encode()
				local v3460, v3461 = proto.writeTag(buf, n232, 6, proto.wireTypes.lengthDelimited)

				buf, n232 = proto.writeBuffer(v3460, v3461, v3459, buffer.len(v3459))
			end

			if p352.expected_price ~= nil then
				local v3462 = p352.expected_price:encode()
				local v3463, v3464 = proto.writeTag(buf, n232, 7, proto.wireTypes.lengthDelimited)

				buf, n232 = proto.writeBuffer(v3463, v3464, v3462, buffer.len(v3462))
			end

			if p352.icon_image_asset_id ~= nil then
				local v3465 = p352.icon_image_asset_id:encode()
				local v3466, v3467 = proto.writeTag(buf, n232, 8, proto.wireTypes.lengthDelimited)

				buf, n232 = proto.writeBuffer(v3466, v3467, v3465, buffer.len(v3465))
			end

			if p352.is_subscription_in_robux ~= nil then
				local v3468 = p352.is_subscription_in_robux:encode()
				local v3469, v3470 = proto.writeTag(buf, n232, 9, proto.wireTypes.lengthDelimited)

				buf, n232 = proto.writeBuffer(v3469, v3470, v3468, buffer.len(v3468))
			end

			if p352.display_price ~= nil then
				local v3471 = p352.display_price:encode()
				local v3472, v3473 = proto.writeTag(buf, n232, 10, proto.wireTypes.lengthDelimited)

				buf, n232 = proto.writeBuffer(v3472, v3473, v3471, buffer.len(v3471))
			end

			local buf119 = buffer.create(n232)

			buffer.copy(buf119, 0, buf, 0, n232)

			return buf119
		end
		function t467.decode(p353: buffer) -- line: 22778
			-- upvalues: t467 (copy), proto (copy), prop_types (copy)
			local v3476 = t467.new()
			local n233 = 0

			while n233 < buffer.len(p353) do
				local v3478, v3479

				v3478, v3479, n233 = proto.readTag(p353, n233)

				if v3479 == proto.wireTypes.varint then
					local v3480

					v3480, n233 = proto.readVarInt(p353, n233)
				elseif v3479 == proto.wireTypes.lengthDelimited then
					if v3478 == 1 then
						local v3481

						v3481, n233 = proto.readBuffer(p353, n233)
						v3476.kind = prop_types.StringProp.decode(v3481)
					elseif v3478 == 2 then
						local v3482

						v3482, n233 = proto.readBuffer(p353, n233)
						v3476.id = prop_types.StringProp.decode(v3482)
					elseif v3478 == 3 then
						local v3483

						v3483, n233 = proto.readBuffer(p353, n233)
						v3476.subscription_id = prop_types.StringProp.decode(v3483)
					elseif v3478 == 4 then
						local v3484

						v3484, n233 = proto.readBuffer(p353, n233)
						v3476.universe_id = prop_types.StringProp.decode(v3484)
					elseif v3478 == 5 then
						local v3485

						v3485, n233 = proto.readBuffer(p353, n233)
						v3476.equip_if_purchased = prop_types.BoolProp.decode(v3485)
					elseif v3478 == 6 then
						local v3486

						v3486, n233 = proto.readBuffer(p353, n233)
						v3476.name = prop_types.StringProp.decode(v3486)
					elseif v3478 == 7 then
						local v3487

						v3487, n233 = proto.readBuffer(p353, n233)
						v3476.expected_price = prop_types.Int64Prop.decode(v3487)
					elseif v3478 == 8 then
						local v3488

						v3488, n233 = proto.readBuffer(p353, n233)
						v3476.icon_image_asset_id = prop_types.Int64Prop.decode(v3488)
					elseif v3478 == 9 then
						local v3489

						v3489, n233 = proto.readBuffer(p353, n233)
						v3476.is_subscription_in_robux = prop_types.BoolProp.decode(v3489)
					elseif v3478 == 10 then
						local v3490

						v3490, n233 = proto.readBuffer(p353, n233)
						v3476.display_price = prop_types.StringProp.decode(v3490)
					else
						local v3491, v3492 = proto.readVarInt(p353, n233)

						n233 = v3492 + v3491
					end
				elseif v3479 == proto.wireTypes.i32 then
					local v3493

					v3493, n233 = proto.readFixed32(p353, n233)
				elseif v3479 == proto.wireTypes.i64 then
					local v3494

					v3494, n233 = proto.readFixed64(p353, n233)
				else
					error("Unsupported wire type: " .. v3479)
				end
			end

			return v3476
		end
		function t467.jsonEncode(p354) -- line: 22869
			local t469 = {}

			if p354.kind ~= nil then
				t469.kind = p354.kind:jsonEncode()
			end

			if p354.id ~= nil then
				t469.id = p354.id:jsonEncode()
			end

			if p354.subscription_id ~= nil then
				t469.subscriptionId = p354.subscription_id:jsonEncode()
			end

			if p354.universe_id ~= nil then
				t469.universeId = p354.universe_id:jsonEncode()
			end

			if p354.equip_if_purchased ~= nil then
				t469.equipIfPurchased = p354.equip_if_purchased:jsonEncode()
			end

			if p354.name ~= nil then
				t469.name = p354.name:jsonEncode()
			end

			if p354.expected_price ~= nil then
				t469.expectedPrice = p354.expected_price:jsonEncode()
			end

			if p354.icon_image_asset_id ~= nil then
				t469.iconImageAssetId = p354.icon_image_asset_id:jsonEncode()
			end

			if p354.is_subscription_in_robux ~= nil then
				t469.isSubscriptionInRobux = p354.is_subscription_in_robux:jsonEncode()
			end

			if p354.display_price ~= nil then
				t469.displayPrice = p354.display_price:jsonEncode()
			end

			return t469
		end
		function t467.jsonDecode(t470: {[any]: any}) -- line: 22917
			-- upvalues: t467 (copy), prop_types (copy)
			local v3498 = t467.new()

			if t470.kind ~= nil then
				v3498.kind = prop_types.StringProp.jsonDecode(t470.kind)
			end

			if t470.id ~= nil then
				v3498.id = prop_types.StringProp.jsonDecode(t470.id)
			end

			if t470.subscription_id ~= nil then
				v3498.subscription_id = prop_types.StringProp.jsonDecode(t470.subscription_id)
			end

			if t470.subscriptionId ~= nil then
				v3498.subscription_id = prop_types.StringProp.jsonDecode(t470.subscriptionId)
			end

			if t470.universe_id ~= nil then
				v3498.universe_id = prop_types.StringProp.jsonDecode(t470.universe_id)
			end

			if t470.universeId ~= nil then
				v3498.universe_id = prop_types.StringProp.jsonDecode(t470.universeId)
			end

			if t470.equip_if_purchased ~= nil then
				v3498.equip_if_purchased = prop_types.BoolProp.jsonDecode(t470.equip_if_purchased)
			end

			if t470.equipIfPurchased ~= nil then
				v3498.equip_if_purchased = prop_types.BoolProp.jsonDecode(t470.equipIfPurchased)
			end

			if t470.name ~= nil then
				v3498.name = prop_types.StringProp.jsonDecode(t470.name)
			end

			if t470.expected_price ~= nil then
				v3498.expected_price = prop_types.Int64Prop.jsonDecode(t470.expected_price)
			end

			if t470.expectedPrice ~= nil then
				v3498.expected_price = prop_types.Int64Prop.jsonDecode(t470.expectedPrice)
			end

			if t470.icon_image_asset_id ~= nil then
				v3498.icon_image_asset_id = prop_types.Int64Prop.jsonDecode(t470.icon_image_asset_id)
			end

			if t470.iconImageAssetId ~= nil then
				v3498.icon_image_asset_id = prop_types.Int64Prop.jsonDecode(t470.iconImageAssetId)
			end

			if t470.is_subscription_in_robux ~= nil then
				v3498.is_subscription_in_robux = prop_types.BoolProp.jsonDecode(t470.is_subscription_in_robux)
			end

			if t470.isSubscriptionInRobux ~= nil then
				v3498.is_subscription_in_robux = prop_types.BoolProp.jsonDecode(t470.isSubscriptionInRobux)
			end

			if t470.display_price ~= nil then
				v3498.display_price = prop_types.StringProp.jsonDecode(t470.display_price)
			end

			if t470.displayPrice ~= nil then
				v3498.display_price = prop_types.StringProp.jsonDecode(t470.displayPrice)
			end

			return v3498
		end

		t467.descriptor = {
			name = "OpenPurchasePromptAction_ProductPayload_ProductPayloadLiteral",
			fullName = "roblox.apppageplatform.shared.v1beta1.ProductPayloadLiteral"
		}
		t1.OpenPurchasePromptAction_ProductPayload_ProductPayloadLiteral = t467
	end

	typeRegistry.default:register(t1.OpenPurchasePromptAction_ProductPayload_ProductPayloadLiteral)

	do
		local t471 = {}

		t471.__index = t471

		function t471.new(t472: {[any]: any}?) -- line: 23021
			-- upvalues: t471 (copy)
			return (setmetatable({
				kind = if t472 ~= nil and t472.kind ~= nil then t472.kind else nil
			}, t471))
		end
		function t471.encode(p355) -- line: 23029
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n234 = 0

			if p355.kind ~= nil then
				if p355.kind.type == "literal" then
					local v3503 = p355.kind.value:encode()
					local v3504, v3505 = proto.writeTag(buf, n234, 1, proto.wireTypes.lengthDelimited)

					buf, n234 = proto.writeBuffer(v3504, v3505, v3503, buffer.len(v3503))
				elseif p355.kind.type == "binding_path" then
					local v3506, v3507 = proto.writeTag(buf, n234, 2, proto.wireTypes.lengthDelimited)

					buf, n234 = proto.writeString(v3506, v3507, p355.kind.value)
				end
			end

			local buf120 = buffer.create(n234)

			buffer.copy(buf120, 0, buf, 0, n234)

			return buf120
		end
		function t471.decode(p356: buffer) -- line: 23049
			-- upvalues: t471 (copy), proto (copy), t1 (copy)
			local v3510 = t471.new()
			local n235 = 0

			while n235 < buffer.len(p356) do
				local v3512, v3513

				v3512, v3513, n235 = proto.readTag(p356, n235)

				if v3513 == proto.wireTypes.varint then
					local v3514

					v3514, n235 = proto.readVarInt(p356, n235)
				elseif v3513 == proto.wireTypes.lengthDelimited then
					if v3512 == 1 then
						local v3515

						v3515, n235 = proto.readBuffer(p356, n235)
						v3510.kind = {
							type = "literal",
							value = t1.OpenPurchasePromptAction_DisplayInfo_DisplayInfoLiteral.decode(v3515)
						}
					elseif v3512 == 2 then
						local v3516

						v3516, n235 = proto.readBuffer(p356, n235)
						v3510.kind = {
							type = "binding_path",
							value = buffer.tostring(v3516)
						}
					else
						local v3517, v3518 = proto.readVarInt(p356, n235)

						n235 = v3518 + v3517
					end
				elseif v3513 == proto.wireTypes.i32 then
					local v3519

					v3519, n235 = proto.readFixed32(p356, n235)
				elseif v3513 == proto.wireTypes.i64 then
					local v3520

					v3520, n235 = proto.readFixed64(p356, n235)
				else
					error("Unsupported wire type: " .. v3513)
				end
			end

			return v3510
		end
		function t471.jsonEncode(p357) -- line: 23100
			local t473 = {}

			if p357.kind ~= nil then
				if p357.kind.type == "literal" then
					t473.literal = p357.kind.value:jsonEncode()

					return t473
				end

				if p357.kind.type == "binding_path" then
					t473.bindingPath = p357.kind.value
				end
			end

			return t473
		end
		function t471.jsonDecode(t474: {[any]: any}) -- line: 23114
			-- upvalues: t471 (copy), t1 (copy)
			local v3524 = t471.new()

			if t474.literal ~= nil then
				v3524.kind = {
					type = "literal",
					value = t1.OpenPurchasePromptAction_DisplayInfo_DisplayInfoLiteral.jsonDecode(t474.literal)
				}
			end

			if t474.binding_path ~= nil then
				v3524.kind = {
					type = "binding_path",
					value = t474.binding_path
				}
			end

			if t474.bindingPath ~= nil then
				v3524.kind = {
					type = "binding_path",
					value = t474.bindingPath
				}
			end

			return v3524
		end

		t471.descriptor = {
			name = "OpenPurchasePromptAction_DisplayInfo",
			fullName = "roblox.apppageplatform.shared.v1beta1.DisplayInfo"
		}
		t1.OpenPurchasePromptAction_DisplayInfo = t471
		typeRegistry.default:register(t1.OpenPurchasePromptAction_DisplayInfo)

		local t475 = {}

		t475.__index = t475

		function t475.new(t476: {[any]: any}?) -- line: 23152
			-- upvalues: t475 (copy)
			return (setmetatable({
				product_name = if t476 ~= nil and t476.product_name ~= nil then t476.product_name else nil,
				description = if t476 ~= nil and t476.description ~= nil then t476.description else nil,
				image_url = if t476 ~= nil and t476.image_url ~= nil then t476.image_url else nil,
				price_in_robux = if t476 ~= nil and t476.price_in_robux ~= nil then t476.price_in_robux else nil,
				display_price = if t476 ~= nil and t476.display_price ~= nil then t476.display_price else nil,
				icon_image_asset_id = if t476 ~= nil and t476.icon_image_asset_id ~= nil then t476.icon_image_asset_id else nil,
				product_id = if t476 ~= nil and t476.product_id ~= nil then t476.product_id else nil,
				target_id = if t476 ~= nil and t476.target_id ~= nil then t476.target_id else nil,
				is_for_sale = if t476 ~= nil and t476.is_for_sale ~= nil then t476.is_for_sale else nil,
				product_type = if t476 ~= nil and t476.product_type ~= nil then t476.product_type else nil,
				base_price_in_robux = if t476 ~= nil and t476.base_price_in_robux ~= nil then t476.base_price_in_robux else nil,
				price_discount_details = if t476 ~= nil and t476.price_discount_details ~= nil then t476.price_discount_details else nil
			}, t475))
		end
		function t475.encode(p358) -- line: 23180
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n236 = 0

			if p358.product_name ~= nil then
				local v3529 = p358.product_name:encode()
				local v3530, v3531 = proto.writeTag(buf, n236, 1, proto.wireTypes.lengthDelimited)

				buf, n236 = proto.writeBuffer(v3530, v3531, v3529, buffer.len(v3529))
			end

			if p358.description ~= nil then
				local v3532 = p358.description:encode()
				local v3533, v3534 = proto.writeTag(buf, n236, 2, proto.wireTypes.lengthDelimited)

				buf, n236 = proto.writeBuffer(v3533, v3534, v3532, buffer.len(v3532))
			end

			if p358.image_url ~= nil then
				local v3535 = p358.image_url:encode()
				local v3536, v3537 = proto.writeTag(buf, n236, 3, proto.wireTypes.lengthDelimited)

				buf, n236 = proto.writeBuffer(v3536, v3537, v3535, buffer.len(v3535))
			end

			if p358.price_in_robux ~= nil then
				local v3538 = p358.price_in_robux:encode()
				local v3539, v3540 = proto.writeTag(buf, n236, 4, proto.wireTypes.lengthDelimited)

				buf, n236 = proto.writeBuffer(v3539, v3540, v3538, buffer.len(v3538))
			end

			if p358.display_price ~= nil then
				local v3541 = p358.display_price:encode()
				local v3542, v3543 = proto.writeTag(buf, n236, 5, proto.wireTypes.lengthDelimited)

				buf, n236 = proto.writeBuffer(v3542, v3543, v3541, buffer.len(v3541))
			end

			if p358.icon_image_asset_id ~= nil then
				local v3544 = p358.icon_image_asset_id:encode()
				local v3545, v3546 = proto.writeTag(buf, n236, 6, proto.wireTypes.lengthDelimited)

				buf, n236 = proto.writeBuffer(v3545, v3546, v3544, buffer.len(v3544))
			end

			if p358.product_id ~= nil then
				local v3547 = p358.product_id:encode()
				local v3548, v3549 = proto.writeTag(buf, n236, 7, proto.wireTypes.lengthDelimited)

				buf, n236 = proto.writeBuffer(v3548, v3549, v3547, buffer.len(v3547))
			end

			if p358.target_id ~= nil then
				local v3550 = p358.target_id:encode()
				local v3551, v3552 = proto.writeTag(buf, n236, 8, proto.wireTypes.lengthDelimited)

				buf, n236 = proto.writeBuffer(v3551, v3552, v3550, buffer.len(v3550))
			end

			if p358.is_for_sale ~= nil then
				local v3553 = p358.is_for_sale:encode()
				local v3554, v3555 = proto.writeTag(buf, n236, 9, proto.wireTypes.lengthDelimited)

				buf, n236 = proto.writeBuffer(v3554, v3555, v3553, buffer.len(v3553))
			end

			if p358.product_type ~= nil then
				local v3556 = p358.product_type:encode()
				local v3557, v3558 = proto.writeTag(buf, n236, 10, proto.wireTypes.lengthDelimited)

				buf, n236 = proto.writeBuffer(v3557, v3558, v3556, buffer.len(v3556))
			end

			if p358.base_price_in_robux ~= nil then
				local v3559 = p358.base_price_in_robux:encode()
				local v3560, v3561 = proto.writeTag(buf, n236, 11, proto.wireTypes.lengthDelimited)

				buf, n236 = proto.writeBuffer(v3560, v3561, v3559, buffer.len(v3559))
			end

			if p358.price_discount_details ~= nil then
				local v3562 = p358.price_discount_details:encode()
				local v3563, v3564 = proto.writeTag(buf, n236, 12, proto.wireTypes.lengthDelimited)

				buf, n236 = proto.writeBuffer(v3563, v3564, v3562, buffer.len(v3562))
			end

			local buf121 = buffer.create(n236)

			buffer.copy(buf121, 0, buf, 0, n236)

			return buf121
		end
		function t475.decode(p359: buffer) -- line: 23263
			-- upvalues: t475 (copy), proto (copy), prop_types (copy)
			local v3567 = t475.new()
			local n237 = 0

			while n237 < buffer.len(p359) do
				local v3569, v3570

				v3569, v3570, n237 = proto.readTag(p359, n237)

				if v3570 == proto.wireTypes.varint then
					local v3571

					v3571, n237 = proto.readVarInt(p359, n237)
				elseif v3570 == proto.wireTypes.lengthDelimited then
					if v3569 == 1 then
						local v3572

						v3572, n237 = proto.readBuffer(p359, n237)
						v3567.product_name = prop_types.StringProp.decode(v3572)
					elseif v3569 == 2 then
						local v3573

						v3573, n237 = proto.readBuffer(p359, n237)
						v3567.description = prop_types.StringProp.decode(v3573)
					elseif v3569 == 3 then
						local v3574

						v3574, n237 = proto.readBuffer(p359, n237)
						v3567.image_url = prop_types.StringProp.decode(v3574)
					elseif v3569 == 4 then
						local v3575

						v3575, n237 = proto.readBuffer(p359, n237)
						v3567.price_in_robux = prop_types.Int64Prop.decode(v3575)
					elseif v3569 == 5 then
						local v3576

						v3576, n237 = proto.readBuffer(p359, n237)
						v3567.display_price = prop_types.StringProp.decode(v3576)
					elseif v3569 == 6 then
						local v3577

						v3577, n237 = proto.readBuffer(p359, n237)
						v3567.icon_image_asset_id = prop_types.Int64Prop.decode(v3577)
					elseif v3569 == 7 then
						local v3578

						v3578, n237 = proto.readBuffer(p359, n237)
						v3567.product_id = prop_types.Int64Prop.decode(v3578)
					elseif v3569 == 8 then
						local v3579

						v3579, n237 = proto.readBuffer(p359, n237)
						v3567.target_id = prop_types.StringProp.decode(v3579)
					elseif v3569 == 9 then
						local v3580

						v3580, n237 = proto.readBuffer(p359, n237)
						v3567.is_for_sale = prop_types.BoolProp.decode(v3580)
					elseif v3569 == 10 then
						local v3581

						v3581, n237 = proto.readBuffer(p359, n237)
						v3567.product_type = prop_types.StringProp.decode(v3581)
					elseif v3569 == 11 then
						local v3582

						v3582, n237 = proto.readBuffer(p359, n237)
						v3567.base_price_in_robux = prop_types.Int64Prop.decode(v3582)
					elseif v3569 == 12 then
						local v3583

						v3583, n237 = proto.readBuffer(p359, n237)
						v3567.price_discount_details = prop_types.ArrayOfStructProp.decode(v3583)
					else
						local v3584, v3585 = proto.readVarInt(p359, n237)

						n237 = v3585 + v3584
					end
				elseif v3570 == proto.wireTypes.i32 then
					local v3586

					v3586, n237 = proto.readFixed32(p359, n237)
				elseif v3570 == proto.wireTypes.i64 then
					local v3587

					v3587, n237 = proto.readFixed64(p359, n237)
				else
					error("Unsupported wire type: " .. v3570)
				end
			end

			return v3567
		end
		function t475.jsonEncode(p360) -- line: 23364
			local t477 = {}

			if p360.product_name ~= nil then
				t477.productName = p360.product_name:jsonEncode()
			end

			if p360.description ~= nil then
				t477.description = p360.description:jsonEncode()
			end

			if p360.image_url ~= nil then
				t477.imageUrl = p360.image_url:jsonEncode()
			end

			if p360.price_in_robux ~= nil then
				t477.priceInRobux = p360.price_in_robux:jsonEncode()
			end

			if p360.display_price ~= nil then
				t477.displayPrice = p360.display_price:jsonEncode()
			end

			if p360.icon_image_asset_id ~= nil then
				t477.iconImageAssetId = p360.icon_image_asset_id:jsonEncode()
			end

			if p360.product_id ~= nil then
				t477.productId = p360.product_id:jsonEncode()
			end

			if p360.target_id ~= nil then
				t477.targetId = p360.target_id:jsonEncode()
			end

			if p360.is_for_sale ~= nil then
				t477.isForSale = p360.is_for_sale:jsonEncode()
			end

			if p360.product_type ~= nil then
				t477.productType = p360.product_type:jsonEncode()
			end

			if p360.base_price_in_robux ~= nil then
				t477.basePriceInRobux = p360.base_price_in_robux:jsonEncode()
			end

			if p360.price_discount_details ~= nil then
				t477.priceDiscountDetails = p360.price_discount_details:jsonEncode()
			end

			return t477
		end
		function t475.jsonDecode(t478: {[any]: any}) -- line: 23420
			-- upvalues: t475 (copy), prop_types (copy)
			local v3591 = t475.new()

			if t478.product_name ~= nil then
				v3591.product_name = prop_types.StringProp.jsonDecode(t478.product_name)
			end

			if t478.productName ~= nil then
				v3591.product_name = prop_types.StringProp.jsonDecode(t478.productName)
			end

			if t478.description ~= nil then
				v3591.description = prop_types.StringProp.jsonDecode(t478.description)
			end

			if t478.image_url ~= nil then
				v3591.image_url = prop_types.StringProp.jsonDecode(t478.image_url)
			end

			if t478.imageUrl ~= nil then
				v3591.image_url = prop_types.StringProp.jsonDecode(t478.imageUrl)
			end

			if t478.price_in_robux ~= nil then
				v3591.price_in_robux = prop_types.Int64Prop.jsonDecode(t478.price_in_robux)
			end

			if t478.priceInRobux ~= nil then
				v3591.price_in_robux = prop_types.Int64Prop.jsonDecode(t478.priceInRobux)
			end

			if t478.display_price ~= nil then
				v3591.display_price = prop_types.StringProp.jsonDecode(t478.display_price)
			end

			if t478.displayPrice ~= nil then
				v3591.display_price = prop_types.StringProp.jsonDecode(t478.displayPrice)
			end

			if t478.icon_image_asset_id ~= nil then
				v3591.icon_image_asset_id = prop_types.Int64Prop.jsonDecode(t478.icon_image_asset_id)
			end

			if t478.iconImageAssetId ~= nil then
				v3591.icon_image_asset_id = prop_types.Int64Prop.jsonDecode(t478.iconImageAssetId)
			end

			if t478.product_id ~= nil then
				v3591.product_id = prop_types.Int64Prop.jsonDecode(t478.product_id)
			end

			if t478.productId ~= nil then
				v3591.product_id = prop_types.Int64Prop.jsonDecode(t478.productId)
			end

			if t478.target_id ~= nil then
				v3591.target_id = prop_types.StringProp.jsonDecode(t478.target_id)
			end

			if t478.targetId ~= nil then
				v3591.target_id = prop_types.StringProp.jsonDecode(t478.targetId)
			end

			if t478.is_for_sale ~= nil then
				v3591.is_for_sale = prop_types.BoolProp.jsonDecode(t478.is_for_sale)
			end

			if t478.isForSale ~= nil then
				v3591.is_for_sale = prop_types.BoolProp.jsonDecode(t478.isForSale)
			end

			if t478.product_type ~= nil then
				v3591.product_type = prop_types.StringProp.jsonDecode(t478.product_type)
			end

			if t478.productType ~= nil then
				v3591.product_type = prop_types.StringProp.jsonDecode(t478.productType)
			end

			if t478.base_price_in_robux ~= nil then
				v3591.base_price_in_robux = prop_types.Int64Prop.jsonDecode(t478.base_price_in_robux)
			end

			if t478.basePriceInRobux ~= nil then
				v3591.base_price_in_robux = prop_types.Int64Prop.jsonDecode(t478.basePriceInRobux)
			end

			if t478.price_discount_details ~= nil then
				v3591.price_discount_details = prop_types.ArrayOfStructProp.jsonDecode(t478.price_discount_details)
			end

			if t478.priceDiscountDetails ~= nil then
				v3591.price_discount_details = prop_types.ArrayOfStructProp.jsonDecode(t478.priceDiscountDetails)
			end

			return v3591
		end

		t475.descriptor = {
			name = "OpenPurchasePromptAction_DisplayInfo_DisplayInfoLiteral",
			fullName = "roblox.apppageplatform.shared.v1beta1.DisplayInfoLiteral"
		}
		t1.OpenPurchasePromptAction_DisplayInfo_DisplayInfoLiteral = t475
	end

	typeRegistry.default:register(t1.OpenPurchasePromptAction_DisplayInfo_DisplayInfoLiteral)

	do
		local t479 = {}

		t479.__index = t479

		function t479.new(t480: {[any]: any}?) -- line: 23554
			-- upvalues: t479 (copy)
			return (setmetatable({
				kind = if t480 ~= nil and t480.kind ~= nil then t480.kind else nil
			}, t479))
		end
		function t479.encode(p361) -- line: 23562
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n238 = 0

			if p361.kind ~= nil then
				if p361.kind.type == "literal" then
					local v3596 = p361.kind.value:encode()
					local v3597, v3598 = proto.writeTag(buf, n238, 1, proto.wireTypes.lengthDelimited)

					buf, n238 = proto.writeBuffer(v3597, v3598, v3596, buffer.len(v3596))
				elseif p361.kind.type == "binding_path" then
					local v3599, v3600 = proto.writeTag(buf, n238, 2, proto.wireTypes.lengthDelimited)

					buf, n238 = proto.writeString(v3599, v3600, p361.kind.value)
				end
			end

			local buf122 = buffer.create(n238)

			buffer.copy(buf122, 0, buf, 0, n238)

			return buf122
		end
		function t479.decode(p362: buffer) -- line: 23584
			-- upvalues: t479 (copy), proto (copy), t1 (copy)
			local v3603 = t479.new()
			local n239 = 0

			while n239 < buffer.len(p362) do
				local v3605, v3606

				v3605, v3606, n239 = proto.readTag(p362, n239)

				if v3606 == proto.wireTypes.varint then
					local v3607

					v3607, n239 = proto.readVarInt(p362, n239)
				elseif v3606 == proto.wireTypes.lengthDelimited then
					if v3605 == 1 then
						local v3608

						v3608, n239 = proto.readBuffer(p362, n239)
						v3603.kind = {
							type = "literal",
							value = t1.OpenPurchasePromptAction_PurchaseOptions_PurchaseOptionsLiteral.decode(v3608)
						}
					elseif v3605 == 2 then
						local v3609

						v3609, n239 = proto.readBuffer(p362, n239)
						v3603.kind = {
							type = "binding_path",
							value = buffer.tostring(v3609)
						}
					else
						local v3610, v3611 = proto.readVarInt(p362, n239)

						n239 = v3611 + v3610
					end
				elseif v3606 == proto.wireTypes.i32 then
					local v3612

					v3612, n239 = proto.readFixed32(p362, n239)
				elseif v3606 == proto.wireTypes.i64 then
					local v3613

					v3613, n239 = proto.readFixed64(p362, n239)
				else
					error("Unsupported wire type: " .. v3606)
				end
			end

			return v3603
		end
		function t479.jsonEncode(p363) -- line: 23637
			local t481 = {}

			if p363.kind ~= nil then
				if p363.kind.type == "literal" then
					t481.literal = p363.kind.value:jsonEncode()

					return t481
				end

				if p363.kind.type == "binding_path" then
					t481.bindingPath = p363.kind.value
				end
			end

			return t481
		end
		function t479.jsonDecode(t482: {[any]: any}) -- line: 23653
			-- upvalues: t479 (copy), t1 (copy)
			local v3617 = t479.new()

			if t482.literal ~= nil then
				v3617.kind = {
					type = "literal",
					value = t1.OpenPurchasePromptAction_PurchaseOptions_PurchaseOptionsLiteral.jsonDecode(t482.literal)
				}
			end

			if t482.binding_path ~= nil then
				v3617.kind = {
					type = "binding_path",
					value = t482.binding_path
				}
			end

			if t482.bindingPath ~= nil then
				v3617.kind = {
					type = "binding_path",
					value = t482.bindingPath
				}
			end

			return v3617
		end

		t479.descriptor = {
			name = "OpenPurchasePromptAction_PurchaseOptions",
			fullName = "roblox.apppageplatform.shared.v1beta1.PurchaseOptions"
		}
		t1.OpenPurchasePromptAction_PurchaseOptions = t479
		typeRegistry.default:register(t1.OpenPurchasePromptAction_PurchaseOptions)

		local t483 = {}

		t483.__index = t483

		function t483.new(t484: {[any]: any}?) -- line: 23693
			-- upvalues: t483 (copy)
			return (setmetatable({
				should_skip_ownership_check = if t484 ~= nil and t484.should_skip_ownership_check ~= nil then t484.should_skip_ownership_check else nil,
				enable_preloaded_purchase_ui = if t484 ~= nil and t484.enable_preloaded_purchase_ui ~= nil then t484.enable_preloaded_purchase_ui else nil,
				completion_message = if t484 ~= nil and t484.completion_message ~= nil then t484.completion_message else nil,
				completion_button_text = if t484 ~= nil and t484.completion_button_text ~= nil then t484.completion_button_text else nil,
				prevent_double_confirm = if t484 ~= nil and t484.prevent_double_confirm ~= nil then t484.prevent_double_confirm else nil,
				provided_robux_balance = if t484 ~= nil and t484.provided_robux_balance ~= nil then t484.provided_robux_balance else nil
			}, t483))
		end
		function t483.encode(p364) -- line: 23721
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n240 = 0

			if p364.should_skip_ownership_check ~= nil then
				local v3622 = p364.should_skip_ownership_check:encode()
				local v3623, v3624 = proto.writeTag(buf, n240, 1, proto.wireTypes.lengthDelimited)

				buf, n240 = proto.writeBuffer(v3623, v3624, v3622, buffer.len(v3622))
			end

			if p364.enable_preloaded_purchase_ui ~= nil then
				local v3625 = p364.enable_preloaded_purchase_ui:encode()
				local v3626, v3627 = proto.writeTag(buf, n240, 2, proto.wireTypes.lengthDelimited)

				buf, n240 = proto.writeBuffer(v3626, v3627, v3625, buffer.len(v3625))
			end

			if p364.completion_message ~= nil then
				local v3628 = p364.completion_message:encode()
				local v3629, v3630 = proto.writeTag(buf, n240, 3, proto.wireTypes.lengthDelimited)

				buf, n240 = proto.writeBuffer(v3629, v3630, v3628, buffer.len(v3628))
			end

			if p364.completion_button_text ~= nil then
				local v3631 = p364.completion_button_text:encode()
				local v3632, v3633 = proto.writeTag(buf, n240, 4, proto.wireTypes.lengthDelimited)

				buf, n240 = proto.writeBuffer(v3632, v3633, v3631, buffer.len(v3631))
			end

			if p364.prevent_double_confirm ~= nil then
				local v3634 = p364.prevent_double_confirm:encode()
				local v3635, v3636 = proto.writeTag(buf, n240, 5, proto.wireTypes.lengthDelimited)

				buf, n240 = proto.writeBuffer(v3635, v3636, v3634, buffer.len(v3634))
			end

			if p364.provided_robux_balance ~= nil then
				local v3637 = p364.provided_robux_balance:encode()
				local v3638, v3639 = proto.writeTag(buf, n240, 6, proto.wireTypes.lengthDelimited)

				buf, n240 = proto.writeBuffer(v3638, v3639, v3637, buffer.len(v3637))
			end

			local buf123 = buffer.create(n240)

			buffer.copy(buf123, 0, buf, 0, n240)

			return buf123
		end
		function t483.decode(p365: buffer) -- line: 23768
			-- upvalues: t483 (copy), proto (copy), prop_types (copy)
			local v3642 = t483.new()
			local n241 = 0

			while n241 < buffer.len(p365) do
				local v3644, v3645

				v3644, v3645, n241 = proto.readTag(p365, n241)

				if v3645 == proto.wireTypes.varint then
					local v3646

					v3646, n241 = proto.readVarInt(p365, n241)
				elseif v3645 == proto.wireTypes.lengthDelimited then
					if v3644 == 1 then
						local v3647

						v3647, n241 = proto.readBuffer(p365, n241)
						v3642.should_skip_ownership_check = prop_types.BoolProp.decode(v3647)
					elseif v3644 == 2 then
						local v3648

						v3648, n241 = proto.readBuffer(p365, n241)
						v3642.enable_preloaded_purchase_ui = prop_types.BoolProp.decode(v3648)
					elseif v3644 == 3 then
						local v3649

						v3649, n241 = proto.readBuffer(p365, n241)
						v3642.completion_message = prop_types.StringProp.decode(v3649)
					elseif v3644 == 4 then
						local v3650

						v3650, n241 = proto.readBuffer(p365, n241)
						v3642.completion_button_text = prop_types.StringProp.decode(v3650)
					elseif v3644 == 5 then
						local v3651

						v3651, n241 = proto.readBuffer(p365, n241)
						v3642.prevent_double_confirm = prop_types.BoolProp.decode(v3651)
					elseif v3644 == 6 then
						local v3652

						v3652, n241 = proto.readBuffer(p365, n241)
						v3642.provided_robux_balance = prop_types.Int64Prop.decode(v3652)
					else
						local v3653, v3654 = proto.readVarInt(p365, n241)

						n241 = v3654 + v3653
					end
				elseif v3645 == proto.wireTypes.i32 then
					local v3655

					v3655, n241 = proto.readFixed32(p365, n241)
				elseif v3645 == proto.wireTypes.i64 then
					local v3656

					v3656, n241 = proto.readFixed64(p365, n241)
				else
					error("Unsupported wire type: " .. v3645)
				end
			end

			return v3642
		end
		function t483.jsonEncode(p366) -- line: 23843
			local t485 = {}

			if p366.should_skip_ownership_check ~= nil then
				t485.shouldSkipOwnershipCheck = p366.should_skip_ownership_check:jsonEncode()
			end

			if p366.enable_preloaded_purchase_ui ~= nil then
				t485.enablePreloadedPurchaseUi = p366.enable_preloaded_purchase_ui:jsonEncode()
			end

			if p366.completion_message ~= nil then
				t485.completionMessage = p366.completion_message:jsonEncode()
			end

			if p366.completion_button_text ~= nil then
				t485.completionButtonText = p366.completion_button_text:jsonEncode()
			end

			if p366.prevent_double_confirm ~= nil then
				t485.preventDoubleConfirm = p366.prevent_double_confirm:jsonEncode()
			end

			if p366.provided_robux_balance ~= nil then
				t485.providedRobuxBalance = p366.provided_robux_balance:jsonEncode()
			end

			return t485
		end
		function t483.jsonDecode(t486: {[any]: any}) -- line: 23875
			-- upvalues: t483 (copy), prop_types (copy)
			local v3660 = t483.new()

			if t486.should_skip_ownership_check ~= nil then
				v3660.should_skip_ownership_check = prop_types.BoolProp.jsonDecode(t486.should_skip_ownership_check)
			end

			if t486.shouldSkipOwnershipCheck ~= nil then
				v3660.should_skip_ownership_check = prop_types.BoolProp.jsonDecode(t486.shouldSkipOwnershipCheck)
			end

			if t486.enable_preloaded_purchase_ui ~= nil then
				v3660.enable_preloaded_purchase_ui = prop_types.BoolProp.jsonDecode(t486.enable_preloaded_purchase_ui)
			end

			if t486.enablePreloadedPurchaseUi ~= nil then
				v3660.enable_preloaded_purchase_ui = prop_types.BoolProp.jsonDecode(t486.enablePreloadedPurchaseUi)
			end

			if t486.completion_message ~= nil then
				v3660.completion_message = prop_types.StringProp.jsonDecode(t486.completion_message)
			end

			if t486.completionMessage ~= nil then
				v3660.completion_message = prop_types.StringProp.jsonDecode(t486.completionMessage)
			end

			if t486.completion_button_text ~= nil then
				v3660.completion_button_text = prop_types.StringProp.jsonDecode(t486.completion_button_text)
			end

			if t486.completionButtonText ~= nil then
				v3660.completion_button_text = prop_types.StringProp.jsonDecode(t486.completionButtonText)
			end

			if t486.prevent_double_confirm ~= nil then
				v3660.prevent_double_confirm = prop_types.BoolProp.jsonDecode(t486.prevent_double_confirm)
			end

			if t486.preventDoubleConfirm ~= nil then
				v3660.prevent_double_confirm = prop_types.BoolProp.jsonDecode(t486.preventDoubleConfirm)
			end

			if t486.provided_robux_balance ~= nil then
				v3660.provided_robux_balance = prop_types.Int64Prop.jsonDecode(t486.provided_robux_balance)
			end

			if t486.providedRobuxBalance ~= nil then
				v3660.provided_robux_balance = prop_types.Int64Prop.jsonDecode(t486.providedRobuxBalance)
			end

			return v3660
		end

		t483.descriptor = {
			name = "OpenPurchasePromptAction_PurchaseOptions_PurchaseOptionsLiteral",
			fullName = "roblox.apppageplatform.shared.v1beta1.PurchaseOptionsLiteral"
		}
		t1.OpenPurchasePromptAction_PurchaseOptions_PurchaseOptionsLiteral = t483
	end

	typeRegistry.default:register(t1.OpenPurchasePromptAction_PurchaseOptions_PurchaseOptionsLiteral)

	do
		local t487 = {}

		t487.__index = t487

		function t487.new(t488: {[any]: any}?) -- line: 23960
			-- upvalues: t487 (copy)
			return (setmetatable({
				kind = if t488 ~= nil and t488.kind ~= nil then t488.kind else nil
			}, t487))
		end
		function t487.encode(p367) -- line: 23971
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n242 = 0

			if p367.kind ~= nil then
				if p367.kind.type == "literal" then
					local v3665 = p367.kind.value:encode()
					local v3666, v3667 = proto.writeTag(buf, n242, 1, proto.wireTypes.lengthDelimited)

					buf, n242 = proto.writeBuffer(v3666, v3667, v3665, buffer.len(v3665))
				elseif p367.kind.type == "binding_path" then
					local v3668, v3669 = proto.writeTag(buf, n242, 2, proto.wireTypes.lengthDelimited)

					buf, n242 = proto.writeString(v3668, v3669, p367.kind.value)
				end
			end

			local buf124 = buffer.create(n242)

			buffer.copy(buf124, 0, buf, 0, n242)

			return buf124
		end
		function t487.decode(p368: buffer) -- line: 23993
			-- upvalues: t487 (copy), proto (copy), t1 (copy)
			local v3672 = t487.new()
			local n243 = 0

			while n243 < buffer.len(p368) do
				local v3674, v3675

				v3674, v3675, n243 = proto.readTag(p368, n243)

				if v3675 == proto.wireTypes.varint then
					local v3676

					v3676, n243 = proto.readVarInt(p368, n243)
				elseif v3675 == proto.wireTypes.lengthDelimited then
					if v3674 == 1 then
						local v3677

						v3677, n243 = proto.readBuffer(p368, n243)
						v3672.kind = {
							type = "literal",
							value = t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata_PurchaseAnalyticsMetadataLiteral.decode(v3677)
						}
					elseif v3674 == 2 then
						local v3678

						v3678, n243 = proto.readBuffer(p368, n243)
						v3672.kind = {
							type = "binding_path",
							value = buffer.tostring(v3678)
						}
					else
						local v3679, v3680 = proto.readVarInt(p368, n243)

						n243 = v3680 + v3679
					end
				elseif v3675 == proto.wireTypes.i32 then
					local v3681

					v3681, n243 = proto.readFixed32(p368, n243)
				elseif v3675 == proto.wireTypes.i64 then
					local v3682

					v3682, n243 = proto.readFixed64(p368, n243)
				else
					error("Unsupported wire type: " .. v3675)
				end
			end

			return v3672
		end
		function t487.jsonEncode(p369) -- line: 24048
			local t489 = {}

			if p369.kind ~= nil then
				if p369.kind.type == "literal" then
					t489.literal = p369.kind.value:jsonEncode()

					return t489
				end

				if p369.kind.type == "binding_path" then
					t489.bindingPath = p369.kind.value
				end
			end

			return t489
		end
		function t487.jsonDecode(t490: {[any]: any}) -- line: 24064
			-- upvalues: t487 (copy), t1 (copy)
			local v3686 = t487.new()

			if t490.literal ~= nil then
				v3686.kind = {
					type = "literal",
					value = t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata_PurchaseAnalyticsMetadataLiteral.jsonDecode(t490.literal)
				}
			end

			if t490.binding_path ~= nil then
				v3686.kind = {
					type = "binding_path",
					value = t490.binding_path
				}
			end

			if t490.bindingPath ~= nil then
				v3686.kind = {
					type = "binding_path",
					value = t490.bindingPath
				}
			end

			return v3686
		end

		t487.descriptor = {
			name = "OpenPurchasePromptAction_PurchaseAnalyticsMetadata",
			fullName = "roblox.apppageplatform.shared.v1beta1.PurchaseAnalyticsMetadata"
		}
		t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata = t487
		typeRegistry.default:register(t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata)

		local t491 = {}

		t491.__index = t491

		function t491.new(t492: {[any]: any}?) -- line: 24105
			-- upvalues: t491 (copy)
			return (setmetatable({
				surface = if t492 ~= nil and t492.surface ~= nil then t492.surface else nil,
				product_universe_id = if t492 ~= nil and t492.product_universe_id ~= nil then t492.product_universe_id else nil
			}, t491))
		end
		function t491.encode(p370) -- line: 24119
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n244 = 0

			if p370.surface ~= nil then
				local v3691 = p370.surface:encode()
				local v3692, v3693 = proto.writeTag(buf, n244, 1, proto.wireTypes.lengthDelimited)

				buf, n244 = proto.writeBuffer(v3692, v3693, v3691, buffer.len(v3691))
			end

			if p370.product_universe_id ~= nil then
				local v3694 = p370.product_universe_id:encode()
				local v3695, v3696 = proto.writeTag(buf, n244, 2, proto.wireTypes.lengthDelimited)

				buf, n244 = proto.writeBuffer(v3695, v3696, v3694, buffer.len(v3694))
			end

			local buf125 = buffer.create(n244)

			buffer.copy(buf125, 0, buf, 0, n244)

			return buf125
		end
		function t491.decode(p371: buffer) -- line: 24142
			-- upvalues: t491 (copy), proto (copy), prop_types (copy)
			local v3699 = t491.new()
			local n245 = 0

			while n245 < buffer.len(p371) do
				local v3701, v3702

				v3701, v3702, n245 = proto.readTag(p371, n245)

				if v3702 == proto.wireTypes.varint then
					local v3703

					v3703, n245 = proto.readVarInt(p371, n245)
				elseif v3702 == proto.wireTypes.lengthDelimited then
					if v3701 == 1 then
						local v3704

						v3704, n245 = proto.readBuffer(p371, n245)
						v3699.surface = prop_types.StringProp.decode(v3704)
					elseif v3701 == 2 then
						local v3705

						v3705, n245 = proto.readBuffer(p371, n245)
						v3699.product_universe_id = prop_types.StringProp.decode(v3705)
					else
						local v3706, v3707 = proto.readVarInt(p371, n245)

						n245 = v3707 + v3706
					end
				elseif v3702 == proto.wireTypes.i32 then
					local v3708

					v3708, n245 = proto.readFixed32(p371, n245)
				elseif v3702 == proto.wireTypes.i64 then
					local v3709

					v3709, n245 = proto.readFixed64(p371, n245)
				else
					error("Unsupported wire type: " .. v3702)
				end
			end

			return v3699
		end
		function t491.jsonEncode(p372) -- line: 24193
			local t493 = {}

			if p372.surface ~= nil then
				t493.surface = p372.surface:jsonEncode()
			end

			if p372.product_universe_id ~= nil then
				t493.productUniverseId = p372.product_universe_id:jsonEncode()
			end

			return t493
		end
		function t491.jsonDecode(t494: {[any]: any}) -- line: 24209
			-- upvalues: t491 (copy), prop_types (copy)
			local v3713 = t491.new()

			if t494.surface ~= nil then
				v3713.surface = prop_types.StringProp.jsonDecode(t494.surface)
			end

			if t494.product_universe_id ~= nil then
				v3713.product_universe_id = prop_types.StringProp.jsonDecode(t494.product_universe_id)
			end

			if t494.productUniverseId ~= nil then
				v3713.product_universe_id = prop_types.StringProp.jsonDecode(t494.productUniverseId)
			end

			return v3713
		end

		t491.descriptor = {
			name = "OpenPurchasePromptAction_PurchaseAnalyticsMetadata_PurchaseAnalyticsMetadataLiteral",
			fullName = "roblox.apppageplatform.shared.v1beta1.PurchaseAnalyticsMetadataLiteral"
		}
		t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata_PurchaseAnalyticsMetadataLiteral = t491
	end

	typeRegistry.default:register(t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata_PurchaseAnalyticsMetadataLiteral)

	do
		local t495 = {}

		t495.__index = t495

		function t495.new(t496: {[any]: any}?) -- line: 24250
			-- upvalues: t495 (copy)
			return (setmetatable({
				product_payload = if t496 ~= nil and t496.product_payload ~= nil then t496.product_payload else nil,
				display_info = if t496 ~= nil and t496.display_info ~= nil then t496.display_info else nil,
				purchase_options = if t496 ~= nil and t496.purchase_options ~= nil then t496.purchase_options else nil,
				purchase_analytics_metadata = if t496 ~= nil and t496.purchase_analytics_metadata ~= nil then t496.purchase_analytics_metadata else nil,
				root_place_id = if t496 ~= nil and t496.root_place_id ~= nil then t496.root_place_id else nil
			}, t495))
		end
		function t495.encode(p373) -- line: 24264
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n246 = 0

			if p373.product_payload ~= nil then
				local v3718 = p373.product_payload:encode()
				local v3719, v3720 = proto.writeTag(buf, n246, 1, proto.wireTypes.lengthDelimited)

				buf, n246 = proto.writeBuffer(v3719, v3720, v3718, buffer.len(v3718))
			end

			if p373.display_info ~= nil then
				local v3721 = p373.display_info:encode()
				local v3722, v3723 = proto.writeTag(buf, n246, 2, proto.wireTypes.lengthDelimited)

				buf, n246 = proto.writeBuffer(v3722, v3723, v3721, buffer.len(v3721))
			end

			if p373.purchase_options ~= nil then
				local v3724 = p373.purchase_options:encode()
				local v3725, v3726 = proto.writeTag(buf, n246, 3, proto.wireTypes.lengthDelimited)

				buf, n246 = proto.writeBuffer(v3725, v3726, v3724, buffer.len(v3724))
			end

			if p373.purchase_analytics_metadata ~= nil then
				local v3727 = p373.purchase_analytics_metadata:encode()
				local v3728, v3729 = proto.writeTag(buf, n246, 4, proto.wireTypes.lengthDelimited)

				buf, n246 = proto.writeBuffer(v3728, v3729, v3727, buffer.len(v3727))
			end

			if p373.root_place_id ~= nil then
				local v3730 = p373.root_place_id:encode()
				local v3731, v3732 = proto.writeTag(buf, n246, 5, proto.wireTypes.lengthDelimited)

				buf, n246 = proto.writeBuffer(v3731, v3732, v3730, buffer.len(v3730))
			end

			local buf126 = buffer.create(n246)

			buffer.copy(buf126, 0, buf, 0, n246)

			return buf126
		end
		function t495.decode(p374: buffer) -- line: 24303
			-- upvalues: t495 (copy), proto (copy), t1 (copy), prop_types (copy)
			local v3735 = t495.new()
			local n247 = 0

			while n247 < buffer.len(p374) do
				local v3737, v3738

				v3737, v3738, n247 = proto.readTag(p374, n247)

				if v3738 == proto.wireTypes.varint then
					local v3739

					v3739, n247 = proto.readVarInt(p374, n247)
				elseif v3738 == proto.wireTypes.lengthDelimited then
					if v3737 == 1 then
						local v3740

						v3740, n247 = proto.readBuffer(p374, n247)
						v3735.product_payload = t1.OpenPurchasePromptAction_ProductPayload.decode(v3740)
					elseif v3737 == 2 then
						local v3741

						v3741, n247 = proto.readBuffer(p374, n247)
						v3735.display_info = t1.OpenPurchasePromptAction_DisplayInfo.decode(v3741)
					elseif v3737 == 3 then
						local v3742

						v3742, n247 = proto.readBuffer(p374, n247)
						v3735.purchase_options = t1.OpenPurchasePromptAction_PurchaseOptions.decode(v3742)
					elseif v3737 == 4 then
						local v3743

						v3743, n247 = proto.readBuffer(p374, n247)
						v3735.purchase_analytics_metadata = t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata.decode(v3743)
					elseif v3737 == 5 then
						local v3744

						v3744, n247 = proto.readBuffer(p374, n247)
						v3735.root_place_id = prop_types.StringProp.decode(v3744)
					else
						local v3745, v3746 = proto.readVarInt(p374, n247)

						n247 = v3746 + v3745
					end
				elseif v3738 == proto.wireTypes.i32 then
					local v3747

					v3747, n247 = proto.readFixed32(p374, n247)
				elseif v3738 == proto.wireTypes.i64 then
					local v3748

					v3748, n247 = proto.readFixed64(p374, n247)
				else
					error("Unsupported wire type: " .. v3738)
				end
			end

			return v3735
		end
		function t495.jsonEncode(p375) -- line: 24367
			local t497 = {}

			if p375.product_payload ~= nil then
				t497.productPayload = p375.product_payload:jsonEncode()
			end

			if p375.display_info ~= nil then
				t497.displayInfo = p375.display_info:jsonEncode()
			end

			if p375.purchase_options ~= nil then
				t497.purchaseOptions = p375.purchase_options:jsonEncode()
			end

			if p375.purchase_analytics_metadata ~= nil then
				t497.purchaseAnalyticsMetadata = p375.purchase_analytics_metadata:jsonEncode()
			end

			if p375.root_place_id ~= nil then
				t497.rootPlaceId = p375.root_place_id:jsonEncode()
			end

			return t497
		end
		function t495.jsonDecode(t498: {[any]: any}) -- line: 24393
			-- upvalues: t495 (copy), t1 (copy), prop_types (copy)
			local v3752 = t495.new()

			if t498.product_payload ~= nil then
				v3752.product_payload = t1.OpenPurchasePromptAction_ProductPayload.jsonDecode(t498.product_payload)
			end

			if t498.productPayload ~= nil then
				v3752.product_payload = t1.OpenPurchasePromptAction_ProductPayload.jsonDecode(t498.productPayload)
			end

			if t498.display_info ~= nil then
				v3752.display_info = t1.OpenPurchasePromptAction_DisplayInfo.jsonDecode(t498.display_info)
			end

			if t498.displayInfo ~= nil then
				v3752.display_info = t1.OpenPurchasePromptAction_DisplayInfo.jsonDecode(t498.displayInfo)
			end

			if t498.purchase_options ~= nil then
				v3752.purchase_options = t1.OpenPurchasePromptAction_PurchaseOptions.jsonDecode(t498.purchase_options)
			end

			if t498.purchaseOptions ~= nil then
				v3752.purchase_options = t1.OpenPurchasePromptAction_PurchaseOptions.jsonDecode(t498.purchaseOptions)
			end

			if t498.purchase_analytics_metadata ~= nil then
				v3752.purchase_analytics_metadata = t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata.jsonDecode(t498.purchase_analytics_metadata)
			end

			if t498.purchaseAnalyticsMetadata ~= nil then
				v3752.purchase_analytics_metadata = t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata.jsonDecode(t498.purchaseAnalyticsMetadata)
			end

			if t498.root_place_id ~= nil then
				v3752.root_place_id = prop_types.StringProp.jsonDecode(t498.root_place_id)
			end

			if t498.rootPlaceId ~= nil then
				v3752.root_place_id = prop_types.StringProp.jsonDecode(t498.rootPlaceId)
			end

			return v3752
		end

		t495.descriptor = {
			name = "OpenPurchasePromptAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenPurchasePromptAction_Params = t495
		typeRegistry.default:register(t1.OpenPurchasePromptAction_Params)

		local t499 = {}

		t499.__index = t499

		function t499.new(t500: {[any]: any}?) -- line: 24458
			-- upvalues: t1 (copy), t499 (copy)
			return (setmetatable({
				action_type = if t500 ~= nil and t500.action_type ~= nil then t500.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t500 ~= nil and t500.action_params ~= nil then t500.action_params else nil
			}, t499))
		end
		function t499.encode(p376) -- line: 24469
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n248 = 0

			if p376.action_type ~= nil and (p376.action_type ~= nil and p376.action_type ~= 0 or p376.action_type ~= t1.ActionType.fromNumber(0)) then
				local v3757, v3758 = proto.writeTag(buf, n248, 1, proto.wireTypes.varint)

				buf, n248 = proto.writeVarInt(v3757, v3758, t1.ActionType.toNumber(p376.action_type))
			end

			if p376.action_params ~= nil then
				local v3759 = p376.action_params:encode()
				local v3760, v3761 = proto.writeTag(buf, n248, 2, proto.wireTypes.lengthDelimited)

				buf, n248 = proto.writeBuffer(v3760, v3761, v3759, buffer.len(v3759))
			end

			local buf127 = buffer.create(n248)

			buffer.copy(buf127, 0, buf, 0, n248)

			return buf127
		end
		function t499.decode(p377: buffer) -- line: 24495
			-- upvalues: t499 (copy), proto (copy), t1 (copy)
			local v3764 = t499.new()
			local n249 = 0

			while n249 < buffer.len(p377) do
				local v3766, v3767

				v3766, v3767, n249 = proto.readTag(p377, n249)

				if v3767 == proto.wireTypes.varint then
					if v3766 == 1 then
						local v3768

						v3768, n249 = proto.readVarIntI32(p377, n249)
						v3764.action_type = t1.ActionType.fromNumber(v3768) or v3768
					else
						local v3769

						v3769, n249 = proto.readVarInt(p377, n249)
					end
				elseif v3767 == proto.wireTypes.lengthDelimited then
					if v3766 == 2 then
						local v3770

						v3770, n249 = proto.readBuffer(p377, n249)
						v3764.action_params = t1.ReportSurfaceLoadTimeMilestoneAction_Params.decode(v3770)
					else
						local v3771, v3772 = proto.readVarInt(p377, n249)

						n249 = v3772 + v3771
					end
				elseif v3767 == proto.wireTypes.i32 then
					local v3773

					v3773, n249 = proto.readFixed32(p377, n249)
				elseif v3767 == proto.wireTypes.i64 then
					local v3774

					v3774, n249 = proto.readFixed64(p377, n249)
				else
					error("Unsupported wire type: " .. v3767)
				end
			end

			return v3764
		end
		function t499.jsonEncode(p378) -- line: 24543
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
		function t499.jsonDecode(t502: {[any]: any}) -- line: 24565
			-- upvalues: t499 (copy), t1 (copy)
			local v3778 = t499.new()

			if t502.action_type ~= nil then
				v3778.action_type = if typeof(t502.action_type) ~= "number" then t1.ActionType.fromName(t502.action_type) or t502.action_type else t1.ActionType.fromNumber(t502.action_type) or t502.action_type
			end

			if t502.actionType ~= nil then
				v3778.action_type = if typeof(t502.actionType) ~= "number" then t1.ActionType.fromName(t502.actionType) or t502.actionType else t1.ActionType.fromNumber(t502.actionType) or t502.actionType
			end

			if t502.action_params ~= nil then
				v3778.action_params = t1.ReportSurfaceLoadTimeMilestoneAction_Params.jsonDecode(t502.action_params)
			end

			if t502.actionParams ~= nil then
				v3778.action_params = t1.ReportSurfaceLoadTimeMilestoneAction_Params.jsonDecode(t502.actionParams)
			end

			return v3778
		end

		t499.descriptor = {
			name = "ReportSurfaceLoadTimeMilestoneAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.ReportSurfaceLoadTimeMilestoneAction"
		}
		t1.ReportSurfaceLoadTimeMilestoneAction = t499
	end

	typeRegistry.default:register(t1.ReportSurfaceLoadTimeMilestoneAction)

	do
		local t503 = {}

		t503.__index = t503

		function t503.new(t504: {[any]: any}?) -- line: 24607
			-- upvalues: t503 (copy)
			return (setmetatable({
				milestone = if t504 ~= nil and t504.milestone ~= nil then t504.milestone else nil,
				metadata = if t504 ~= nil and t504.metadata ~= nil then t504.metadata else nil
			}, t503))
		end
		function t503.encode(p379) -- line: 24616
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n250 = 0

			if p379.milestone ~= nil then
				local v3783 = p379.milestone:encode()
				local v3784, v3785 = proto.writeTag(buf, n250, 1, proto.wireTypes.lengthDelimited)

				buf, n250 = proto.writeBuffer(v3784, v3785, v3783, buffer.len(v3783))
			end

			if p379.metadata ~= nil then
				local v3786 = p379.metadata:encode()
				local v3787, v3788 = proto.writeTag(buf, n250, 3, proto.wireTypes.lengthDelimited)

				buf, n250 = proto.writeBuffer(v3787, v3788, v3786, buffer.len(v3786))
			end

			local buf128 = buffer.create(n250)

			buffer.copy(buf128, 0, buf, 0, n250)

			return buf128
		end
		function t503.decode(p380: buffer) -- line: 24639
			-- upvalues: t503 (copy), proto (copy), prop_types (copy)
			local v3791 = t503.new()
			local n251 = 0

			while n251 < buffer.len(p380) do
				local v3793, v3794

				v3793, v3794, n251 = proto.readTag(p380, n251)

				if v3794 == proto.wireTypes.varint then
					local v3795

					v3795, n251 = proto.readVarInt(p380, n251)
				elseif v3794 == proto.wireTypes.lengthDelimited then
					if v3793 == 1 then
						local v3796

						v3796, n251 = proto.readBuffer(p380, n251)
						v3791.milestone = prop_types.StringProp.decode(v3796)
					elseif v3793 == 3 then
						local v3797

						v3797, n251 = proto.readBuffer(p380, n251)
						v3791.metadata = prop_types.StructProp.decode(v3797)
					else
						local v3798, v3799 = proto.readVarInt(p380, n251)

						n251 = v3799 + v3798
					end
				elseif v3794 == proto.wireTypes.i32 then
					local v3800

					v3800, n251 = proto.readFixed32(p380, n251)
				elseif v3794 == proto.wireTypes.i64 then
					local v3801

					v3801, n251 = proto.readFixed64(p380, n251)
				else
					error("Unsupported wire type: " .. v3794)
				end
			end

			return v3791
		end
		function t503.jsonEncode(p381) -- line: 24689
			local t505 = {}

			if p381.milestone ~= nil then
				t505.milestone = p381.milestone:jsonEncode()
			end

			if p381.metadata ~= nil then
				t505.metadata = p381.metadata:jsonEncode()
			end

			return t505
		end
		function t503.jsonDecode(t506: {[any]: any}) -- line: 24705
			-- upvalues: t503 (copy), prop_types (copy)
			local v3805 = t503.new()

			if t506.milestone ~= nil then
				v3805.milestone = prop_types.StringProp.jsonDecode(t506.milestone)
			end

			if t506.metadata ~= nil then
				v3805.metadata = prop_types.StructProp.jsonDecode(t506.metadata)
			end

			return v3805
		end

		t503.descriptor = {
			name = "ReportSurfaceLoadTimeMilestoneAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.ReportSurfaceLoadTimeMilestoneAction_Params = t503
		typeRegistry.default:register(t1.ReportSurfaceLoadTimeMilestoneAction_Params)

		local t507 = {}

		t507.__index = t507

		function t507.new(t508: {[any]: any}?) -- line: 24735
			-- upvalues: t1 (copy), t507 (copy)
			return (setmetatable({
				action_type = if t508 ~= nil and t508.action_type ~= nil then t508.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t508 ~= nil and t508.action_params ~= nil then t508.action_params else nil
			}, t507))
		end
		function t507.encode(p382) -- line: 24746
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n252 = 0

			if p382.action_type ~= nil and (p382.action_type ~= nil and p382.action_type ~= 0 or p382.action_type ~= t1.ActionType.fromNumber(0)) then
				local v3810, v3811 = proto.writeTag(buf, n252, 1, proto.wireTypes.varint)

				buf, n252 = proto.writeVarInt(v3810, v3811, t1.ActionType.toNumber(p382.action_type))
			end

			if p382.action_params ~= nil then
				local v3812 = p382.action_params:encode()
				local v3813, v3814 = proto.writeTag(buf, n252, 2, proto.wireTypes.lengthDelimited)

				buf, n252 = proto.writeBuffer(v3813, v3814, v3812, buffer.len(v3812))
			end

			local buf129 = buffer.create(n252)

			buffer.copy(buf129, 0, buf, 0, n252)

			return buf129
		end
		function t507.decode(p383: buffer) -- line: 24772
			-- upvalues: t507 (copy), proto (copy), t1 (copy)
			local v3817 = t507.new()
			local n253 = 0

			while n253 < buffer.len(p383) do
				local v3819, v3820

				v3819, v3820, n253 = proto.readTag(p383, n253)

				if v3820 == proto.wireTypes.varint then
					if v3819 == 1 then
						local v3821

						v3821, n253 = proto.readVarIntI32(p383, n253)
						v3817.action_type = t1.ActionType.fromNumber(v3821) or v3821
					else
						local v3822

						v3822, n253 = proto.readVarInt(p383, n253)
					end
				elseif v3820 == proto.wireTypes.lengthDelimited then
					if v3819 == 2 then
						local v3823

						v3823, n253 = proto.readBuffer(p383, n253)
						v3817.action_params = t1.DismissGameFeedbackAction_Params.decode(v3823)
					else
						local v3824, v3825 = proto.readVarInt(p383, n253)

						n253 = v3825 + v3824
					end
				elseif v3820 == proto.wireTypes.i32 then
					local v3826

					v3826, n253 = proto.readFixed32(p383, n253)
				elseif v3820 == proto.wireTypes.i64 then
					local v3827

					v3827, n253 = proto.readFixed64(p383, n253)
				else
					error("Unsupported wire type: " .. v3820)
				end
			end

			return v3817
		end
		function t507.jsonEncode(p384) -- line: 24820
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
		function t507.jsonDecode(t510: {[any]: any}) -- line: 24842
			-- upvalues: t507 (copy), t1 (copy)
			local v3831 = t507.new()

			if t510.action_type ~= nil then
				v3831.action_type = if typeof(t510.action_type) ~= "number" then t1.ActionType.fromName(t510.action_type) or t510.action_type else t1.ActionType.fromNumber(t510.action_type) or t510.action_type
			end

			if t510.actionType ~= nil then
				v3831.action_type = if typeof(t510.actionType) ~= "number" then t1.ActionType.fromName(t510.actionType) or t510.actionType else t1.ActionType.fromNumber(t510.actionType) or t510.actionType
			end

			if t510.action_params ~= nil then
				v3831.action_params = t1.DismissGameFeedbackAction_Params.jsonDecode(t510.action_params)
			end

			if t510.actionParams ~= nil then
				v3831.action_params = t1.DismissGameFeedbackAction_Params.jsonDecode(t510.actionParams)
			end

			return v3831
		end

		t507.descriptor = {
			name = "DismissGameFeedbackAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.DismissGameFeedbackAction"
		}
		t1.DismissGameFeedbackAction = t507
	end

	typeRegistry.default:register(t1.DismissGameFeedbackAction)

	do
		local t511 = {}

		t511.__index = t511

		function t511.new(t512: {[any]: any}?) -- line: 24882
			-- upvalues: t511 (copy)
			return (setmetatable({
				root_place_id = if t512 ~= nil and t512.root_place_id ~= nil then t512.root_place_id else nil
			}, t511))
		end
		function t511.encode(p385) -- line: 24890
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n254 = 0

			if p385.root_place_id ~= nil then
				local v3836 = p385.root_place_id:encode()
				local v3837, v3838 = proto.writeTag(buf, n254, 1, proto.wireTypes.lengthDelimited)

				buf, n254 = proto.writeBuffer(v3837, v3838, v3836, buffer.len(v3836))
			end

			local buf130 = buffer.create(n254)

			buffer.copy(buf130, 0, buf, 0, n254)

			return buf130
		end
		function t511.decode(p386: buffer) -- line: 24905
			-- upvalues: t511 (copy), proto (copy), prop_types (copy)
			local v3841 = t511.new()
			local n255 = 0

			while n255 < buffer.len(p386) do
				local v3843, v3844

				v3843, v3844, n255 = proto.readTag(p386, n255)

				if v3844 == proto.wireTypes.varint then
					local v3845

					v3845, n255 = proto.readVarInt(p386, n255)
				elseif v3844 == proto.wireTypes.lengthDelimited then
					if v3843 == 1 then
						local v3846

						v3846, n255 = proto.readBuffer(p386, n255)
						v3841.root_place_id = prop_types.StringProp.decode(v3846)
					else
						local v3847, v3848 = proto.readVarInt(p386, n255)

						n255 = v3848 + v3847
					end
				elseif v3844 == proto.wireTypes.i32 then
					local v3849

					v3849, n255 = proto.readFixed32(p386, n255)
				elseif v3844 == proto.wireTypes.i64 then
					local v3850

					v3850, n255 = proto.readFixed64(p386, n255)
				else
					error("Unsupported wire type: " .. v3844)
				end
			end

			return v3841
		end
		function t511.jsonEncode(p387) -- line: 24948
			local t513 = {}

			if p387.root_place_id ~= nil then
				t513.rootPlaceId = p387.root_place_id:jsonEncode()
			end

			return t513
		end
		function t511.jsonDecode(t514: {[any]: any}) -- line: 24958
			-- upvalues: t511 (copy), prop_types (copy)
			local v3854 = t511.new()

			if t514.root_place_id ~= nil then
				v3854.root_place_id = prop_types.StringProp.jsonDecode(t514.root_place_id)
			end

			if t514.rootPlaceId ~= nil then
				v3854.root_place_id = prop_types.StringProp.jsonDecode(t514.rootPlaceId)
			end

			return v3854
		end

		t511.descriptor = {
			name = "DismissGameFeedbackAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.DismissGameFeedbackAction_Params = t511
		typeRegistry.default:register(t1.DismissGameFeedbackAction_Params)

		local t515 = {}

		t515.__index = t515

		function t515.new(t516: {[any]: any}?) -- line: 24990
			-- upvalues: t1 (copy), t515 (copy)
			return (setmetatable({
				action_type = if t516 ~= nil and t516.action_type ~= nil then t516.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t516 ~= nil and t516.action_params ~= nil then t516.action_params else nil
			}, t515))
		end
		function t515.encode(p388) -- line: 25001
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n256 = 0

			if p388.action_type ~= nil and (p388.action_type ~= nil and p388.action_type ~= 0 or p388.action_type ~= t1.ActionType.fromNumber(0)) then
				local v3859, v3860 = proto.writeTag(buf, n256, 1, proto.wireTypes.varint)

				buf, n256 = proto.writeVarInt(v3859, v3860, t1.ActionType.toNumber(p388.action_type))
			end

			if p388.action_params ~= nil then
				local v3861 = p388.action_params:encode()
				local v3862, v3863 = proto.writeTag(buf, n256, 2, proto.wireTypes.lengthDelimited)

				buf, n256 = proto.writeBuffer(v3862, v3863, v3861, buffer.len(v3861))
			end

			local buf131 = buffer.create(n256)

			buffer.copy(buf131, 0, buf, 0, n256)

			return buf131
		end
		function t515.decode(p389: buffer) -- line: 25027
			-- upvalues: t515 (copy), proto (copy), t1 (copy)
			local v3866 = t515.new()
			local n257 = 0

			while n257 < buffer.len(p389) do
				local v3868, v3869

				v3868, v3869, n257 = proto.readTag(p389, n257)

				if v3869 == proto.wireTypes.varint then
					if v3868 == 1 then
						local v3870

						v3870, n257 = proto.readVarIntI32(p389, n257)
						v3866.action_type = t1.ActionType.fromNumber(v3870) or v3870
					else
						local v3871

						v3871, n257 = proto.readVarInt(p389, n257)
					end
				elseif v3869 == proto.wireTypes.lengthDelimited then
					if v3868 == 2 then
						local v3872

						v3872, n257 = proto.readBuffer(p389, n257)
						v3866.action_params = t1.OpenGameFeedbackFormAction_Params.decode(v3872)
					else
						local v3873, v3874 = proto.readVarInt(p389, n257)

						n257 = v3874 + v3873
					end
				elseif v3869 == proto.wireTypes.i32 then
					local v3875

					v3875, n257 = proto.readFixed32(p389, n257)
				elseif v3869 == proto.wireTypes.i64 then
					local v3876

					v3876, n257 = proto.readFixed64(p389, n257)
				else
					error("Unsupported wire type: " .. v3869)
				end
			end

			return v3866
		end
		function t515.jsonEncode(p390) -- line: 25075
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
		function t515.jsonDecode(t518: {[any]: any}) -- line: 25097
			-- upvalues: t515 (copy), t1 (copy)
			local v3880 = t515.new()

			if t518.action_type ~= nil then
				v3880.action_type = if typeof(t518.action_type) ~= "number" then t1.ActionType.fromName(t518.action_type) or t518.action_type else t1.ActionType.fromNumber(t518.action_type) or t518.action_type
			end

			if t518.actionType ~= nil then
				v3880.action_type = if typeof(t518.actionType) ~= "number" then t1.ActionType.fromName(t518.actionType) or t518.actionType else t1.ActionType.fromNumber(t518.actionType) or t518.actionType
			end

			if t518.action_params ~= nil then
				v3880.action_params = t1.OpenGameFeedbackFormAction_Params.jsonDecode(t518.action_params)
			end

			if t518.actionParams ~= nil then
				v3880.action_params = t1.OpenGameFeedbackFormAction_Params.jsonDecode(t518.actionParams)
			end

			return v3880
		end

		t515.descriptor = {
			name = "OpenGameFeedbackFormAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenGameFeedbackFormAction"
		}
		t1.OpenGameFeedbackFormAction = t515
	end

	typeRegistry.default:register(t1.OpenGameFeedbackFormAction)

	do
		local t519 = {}

		t519.__index = t519

		function t519.new(t520: {[any]: any}?) -- line: 25137
			-- upvalues: t519 (copy)
			return (setmetatable({
				universe_id = if t520 ~= nil and t520.universe_id ~= nil then t520.universe_id else nil,
				root_place_id = if t520 ~= nil and t520.root_place_id ~= nil then t520.root_place_id else nil
			}, t519))
		end
		function t519.encode(p391) -- line: 25146
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n258 = 0

			if p391.universe_id ~= nil then
				local v3885 = p391.universe_id:encode()
				local v3886, v3887 = proto.writeTag(buf, n258, 1, proto.wireTypes.lengthDelimited)

				buf, n258 = proto.writeBuffer(v3886, v3887, v3885, buffer.len(v3885))
			end

			if p391.root_place_id ~= nil then
				local v3888 = p391.root_place_id:encode()
				local v3889, v3890 = proto.writeTag(buf, n258, 2, proto.wireTypes.lengthDelimited)

				buf, n258 = proto.writeBuffer(v3889, v3890, v3888, buffer.len(v3888))
			end

			local buf132 = buffer.create(n258)

			buffer.copy(buf132, 0, buf, 0, n258)

			return buf132
		end
		function t519.decode(p392: buffer) -- line: 25167
			-- upvalues: t519 (copy), proto (copy), prop_types (copy)
			local v3893 = t519.new()
			local n259 = 0

			while n259 < buffer.len(p392) do
				local v3895, v3896

				v3895, v3896, n259 = proto.readTag(p392, n259)

				if v3896 == proto.wireTypes.varint then
					local v3897

					v3897, n259 = proto.readVarInt(p392, n259)
				elseif v3896 == proto.wireTypes.lengthDelimited then
					if v3895 == 1 then
						local v3898

						v3898, n259 = proto.readBuffer(p392, n259)
						v3893.universe_id = prop_types.StringProp.decode(v3898)
					elseif v3895 == 2 then
						local v3899

						v3899, n259 = proto.readBuffer(p392, n259)
						v3893.root_place_id = prop_types.StringProp.decode(v3899)
					else
						local v3900, v3901 = proto.readVarInt(p392, n259)

						n259 = v3901 + v3900
					end
				elseif v3896 == proto.wireTypes.i32 then
					local v3902

					v3902, n259 = proto.readFixed32(p392, n259)
				elseif v3896 == proto.wireTypes.i64 then
					local v3903

					v3903, n259 = proto.readFixed64(p392, n259)
				else
					error("Unsupported wire type: " .. v3896)
				end
			end

			return v3893
		end
		function t519.jsonEncode(p393) -- line: 25215
			local t521 = {}

			if p393.universe_id ~= nil then
				t521.universeId = p393.universe_id:jsonEncode()
			end

			if p393.root_place_id ~= nil then
				t521.rootPlaceId = p393.root_place_id:jsonEncode()
			end

			return t521
		end
		function t519.jsonDecode(t522: {[any]: any}) -- line: 25229
			-- upvalues: t519 (copy), prop_types (copy)
			local v3907 = t519.new()

			if t522.universe_id ~= nil then
				v3907.universe_id = prop_types.StringProp.jsonDecode(t522.universe_id)
			end

			if t522.universeId ~= nil then
				v3907.universe_id = prop_types.StringProp.jsonDecode(t522.universeId)
			end

			if t522.root_place_id ~= nil then
				v3907.root_place_id = prop_types.StringProp.jsonDecode(t522.root_place_id)
			end

			if t522.rootPlaceId ~= nil then
				v3907.root_place_id = prop_types.StringProp.jsonDecode(t522.rootPlaceId)
			end

			return v3907
		end

		t519.descriptor = {
			name = "OpenGameFeedbackFormAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenGameFeedbackFormAction_Params = t519
		typeRegistry.default:register(t1.OpenGameFeedbackFormAction_Params)

		local t523 = {}

		t523.__index = t523

		function t523.new(t524: {[any]: any}?) -- line: 25270
			-- upvalues: t1 (copy), t523 (copy)
			return (setmetatable({
				action_type = if t524 ~= nil and t524.action_type ~= nil then t524.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t524 ~= nil and t524.action_params ~= nil then t524.action_params else nil
			}, t523))
		end
		function t523.encode(p394) -- line: 25279
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n260 = 0

			if p394.action_type ~= nil and (p394.action_type ~= nil and p394.action_type ~= 0 or p394.action_type ~= t1.ActionType.fromNumber(0)) then
				local v3912, v3913 = proto.writeTag(buf, n260, 1, proto.wireTypes.varint)

				buf, n260 = proto.writeVarInt(v3912, v3913, t1.ActionType.toNumber(p394.action_type))
			end

			if p394.action_params ~= nil then
				local v3914 = p394.action_params:encode()
				local v3915, v3916 = proto.writeTag(buf, n260, 2, proto.wireTypes.lengthDelimited)

				buf, n260 = proto.writeBuffer(v3915, v3916, v3914, buffer.len(v3914))
			end

			local buf133 = buffer.create(n260)

			buffer.copy(buf133, 0, buf, 0, n260)

			return buf133
		end
		function t523.decode(p395: buffer) -- line: 25305
			-- upvalues: t523 (copy), proto (copy), t1 (copy)
			local v3919 = t523.new()
			local n261 = 0

			while n261 < buffer.len(p395) do
				local v3921, v3922

				v3921, v3922, n261 = proto.readTag(p395, n261)

				if v3922 == proto.wireTypes.varint then
					if v3921 == 1 then
						local v3923

						v3923, n261 = proto.readVarIntI32(p395, n261)
						v3919.action_type = t1.ActionType.fromNumber(v3923) or v3923
					else
						local v3924

						v3924, n261 = proto.readVarInt(p395, n261)
					end
				elseif v3922 == proto.wireTypes.lengthDelimited then
					if v3921 == 2 then
						local v3925

						v3925, n261 = proto.readBuffer(p395, n261)
						v3919.action_params = t1.AiOverviewFeedbackAction_Params.decode(v3925)
					else
						local v3926, v3927 = proto.readVarInt(p395, n261)

						n261 = v3927 + v3926
					end
				elseif v3922 == proto.wireTypes.i32 then
					local v3928

					v3928, n261 = proto.readFixed32(p395, n261)
				elseif v3922 == proto.wireTypes.i64 then
					local v3929

					v3929, n261 = proto.readFixed64(p395, n261)
				else
					error("Unsupported wire type: " .. v3922)
				end
			end

			return v3919
		end
		function t523.jsonEncode(p396) -- line: 25353
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
		function t523.jsonDecode(t526: {[any]: any}) -- line: 25375
			-- upvalues: t523 (copy), t1 (copy)
			local v3933 = t523.new()

			if t526.action_type ~= nil then
				v3933.action_type = if typeof(t526.action_type) ~= "number" then t1.ActionType.fromName(t526.action_type) or t526.action_type else t1.ActionType.fromNumber(t526.action_type) or t526.action_type
			end

			if t526.actionType ~= nil then
				v3933.action_type = if typeof(t526.actionType) ~= "number" then t1.ActionType.fromName(t526.actionType) or t526.actionType else t1.ActionType.fromNumber(t526.actionType) or t526.actionType
			end

			if t526.action_params ~= nil then
				v3933.action_params = t1.AiOverviewFeedbackAction_Params.jsonDecode(t526.action_params)
			end

			if t526.actionParams ~= nil then
				v3933.action_params = t1.AiOverviewFeedbackAction_Params.jsonDecode(t526.actionParams)
			end

			return v3933
		end

		t523.descriptor = {
			name = "AiOverviewFeedbackAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.AiOverviewFeedbackAction"
		}
		t1.AiOverviewFeedbackAction = t523
	end

	typeRegistry.default:register(t1.AiOverviewFeedbackAction)

	do
		local t527 = {}

		t527.__index = t527

		function t527.new(t528: {[any]: any}?) -- line: 25415
			-- upvalues: t527 (copy)
			return (setmetatable({
				sentiment = if t528 ~= nil and t528.sentiment ~= nil then t528.sentiment else nil,
				dialog_title = if t528 ~= nil and t528.dialog_title ~= nil then t528.dialog_title else nil,
				dialog_text = if t528 ~= nil and t528.dialog_text ~= nil then t528.dialog_text else nil,
				placeholder_text = if t528 ~= nil and t528.placeholder_text ~= nil then t528.placeholder_text else nil
			}, t527))
		end
		function t527.encode(p397) -- line: 25426
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n262 = 0

			if p397.sentiment ~= nil then
				local v3938 = p397.sentiment:encode()
				local v3939, v3940 = proto.writeTag(buf, n262, 1, proto.wireTypes.lengthDelimited)

				buf, n262 = proto.writeBuffer(v3939, v3940, v3938, buffer.len(v3938))
			end

			if p397.dialog_title ~= nil then
				local v3941 = p397.dialog_title:encode()
				local v3942, v3943 = proto.writeTag(buf, n262, 2, proto.wireTypes.lengthDelimited)

				buf, n262 = proto.writeBuffer(v3942, v3943, v3941, buffer.len(v3941))
			end

			if p397.dialog_text ~= nil then
				local v3944 = p397.dialog_text:encode()
				local v3945, v3946 = proto.writeTag(buf, n262, 3, proto.wireTypes.lengthDelimited)

				buf, n262 = proto.writeBuffer(v3945, v3946, v3944, buffer.len(v3944))
			end

			if p397.placeholder_text ~= nil then
				local v3947 = p397.placeholder_text:encode()
				local v3948, v3949 = proto.writeTag(buf, n262, 4, proto.wireTypes.lengthDelimited)

				buf, n262 = proto.writeBuffer(v3948, v3949, v3947, buffer.len(v3947))
			end

			local buf134 = buffer.create(n262)

			buffer.copy(buf134, 0, buf, 0, n262)

			return buf134
		end
		function t527.decode(p398: buffer) -- line: 25459
			-- upvalues: t527 (copy), proto (copy), prop_types (copy)
			local v3952 = t527.new()
			local n263 = 0

			while n263 < buffer.len(p398) do
				local v3954, v3955

				v3954, v3955, n263 = proto.readTag(p398, n263)

				if v3955 == proto.wireTypes.varint then
					local v3956

					v3956, n263 = proto.readVarInt(p398, n263)
				elseif v3955 == proto.wireTypes.lengthDelimited then
					if v3954 == 1 then
						local v3957

						v3957, n263 = proto.readBuffer(p398, n263)
						v3952.sentiment = prop_types.StringProp.decode(v3957)
					elseif v3954 == 2 then
						local v3958

						v3958, n263 = proto.readBuffer(p398, n263)
						v3952.dialog_title = prop_types.StringProp.decode(v3958)
					elseif v3954 == 3 then
						local v3959

						v3959, n263 = proto.readBuffer(p398, n263)
						v3952.dialog_text = prop_types.StringProp.decode(v3959)
					elseif v3954 == 4 then
						local v3960

						v3960, n263 = proto.readBuffer(p398, n263)
						v3952.placeholder_text = prop_types.StringProp.decode(v3960)
					else
						local v3961, v3962 = proto.readVarInt(p398, n263)

						n263 = v3962 + v3961
					end
				elseif v3955 == proto.wireTypes.i32 then
					local v3963

					v3963, n263 = proto.readFixed32(p398, n263)
				elseif v3955 == proto.wireTypes.i64 then
					local v3964

					v3964, n263 = proto.readFixed64(p398, n263)
				else
					error("Unsupported wire type: " .. v3955)
				end
			end

			return v3952
		end
		function t527.jsonEncode(p399) -- line: 25517
			local t529 = {}

			if p399.sentiment ~= nil then
				t529.sentiment = p399.sentiment:jsonEncode()
			end

			if p399.dialog_title ~= nil then
				t529.dialogTitle = p399.dialog_title:jsonEncode()
			end

			if p399.dialog_text ~= nil then
				t529.dialogText = p399.dialog_text:jsonEncode()
			end

			if p399.placeholder_text ~= nil then
				t529.placeholderText = p399.placeholder_text:jsonEncode()
			end

			return t529
		end
		function t527.jsonDecode(t530: {[any]: any}) -- line: 25539
			-- upvalues: t527 (copy), prop_types (copy)
			local v3968 = t527.new()

			if t530.sentiment ~= nil then
				v3968.sentiment = prop_types.StringProp.jsonDecode(t530.sentiment)
			end

			if t530.dialog_title ~= nil then
				v3968.dialog_title = prop_types.StringProp.jsonDecode(t530.dialog_title)
			end

			if t530.dialogTitle ~= nil then
				v3968.dialog_title = prop_types.StringProp.jsonDecode(t530.dialogTitle)
			end

			if t530.dialog_text ~= nil then
				v3968.dialog_text = prop_types.StringProp.jsonDecode(t530.dialog_text)
			end

			if t530.dialogText ~= nil then
				v3968.dialog_text = prop_types.StringProp.jsonDecode(t530.dialogText)
			end

			if t530.placeholder_text ~= nil then
				v3968.placeholder_text = prop_types.StringProp.jsonDecode(t530.placeholder_text)
			end

			if t530.placeholderText ~= nil then
				v3968.placeholder_text = prop_types.StringProp.jsonDecode(t530.placeholderText)
			end

			return v3968
		end

		t527.descriptor = {
			name = "AiOverviewFeedbackAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.AiOverviewFeedbackAction_Params = t527
		typeRegistry.default:register(t1.AiOverviewFeedbackAction_Params)

		local t531 = {}

		t531.__index = t531

		function t531.new(t532: {[any]: any}?) -- line: 25592
			-- upvalues: t1 (copy), t531 (copy)
			return (setmetatable({
				action_type = if t532 ~= nil and t532.action_type ~= nil then t532.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t532 ~= nil and t532.action_params ~= nil then t532.action_params else nil
			}, t531))
		end
		function t531.encode(p400) -- line: 25603
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n264 = 0

			if p400.action_type ~= nil and (p400.action_type ~= nil and p400.action_type ~= 0 or p400.action_type ~= t1.ActionType.fromNumber(0)) then
				local v3973, v3974 = proto.writeTag(buf, n264, 1, proto.wireTypes.varint)

				buf, n264 = proto.writeVarInt(v3973, v3974, t1.ActionType.toNumber(p400.action_type))
			end

			if p400.action_params ~= nil then
				local v3975 = p400.action_params:encode()
				local v3976, v3977 = proto.writeTag(buf, n264, 2, proto.wireTypes.lengthDelimited)

				buf, n264 = proto.writeBuffer(v3976, v3977, v3975, buffer.len(v3975))
			end

			local buf135 = buffer.create(n264)

			buffer.copy(buf135, 0, buf, 0, n264)

			return buf135
		end
		function t531.decode(p401: buffer) -- line: 25629
			-- upvalues: t531 (copy), proto (copy), t1 (copy)
			local v3980 = t531.new()
			local n265 = 0

			while n265 < buffer.len(p401) do
				local v3982, v3983

				v3982, v3983, n265 = proto.readTag(p401, n265)

				if v3983 == proto.wireTypes.varint then
					if v3982 == 1 then
						local v3984

						v3984, n265 = proto.readVarIntI32(p401, n265)
						v3980.action_type = t1.ActionType.fromNumber(v3984) or v3984
					else
						local v3985

						v3985, n265 = proto.readVarInt(p401, n265)
					end
				elseif v3983 == proto.wireTypes.lengthDelimited then
					if v3982 == 2 then
						local v3986

						v3986, n265 = proto.readBuffer(p401, n265)
						v3980.action_params = t1.EnableEventNotificationsAction_Params.decode(v3986)
					else
						local v3987, v3988 = proto.readVarInt(p401, n265)

						n265 = v3988 + v3987
					end
				elseif v3983 == proto.wireTypes.i32 then
					local v3989

					v3989, n265 = proto.readFixed32(p401, n265)
				elseif v3983 == proto.wireTypes.i64 then
					local v3990

					v3990, n265 = proto.readFixed64(p401, n265)
				else
					error("Unsupported wire type: " .. v3983)
				end
			end

			return v3980
		end
		function t531.jsonEncode(p402) -- line: 25677
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
		function t531.jsonDecode(t534: {[any]: any}) -- line: 25699
			-- upvalues: t531 (copy), t1 (copy)
			local v3994 = t531.new()

			if t534.action_type ~= nil then
				v3994.action_type = if typeof(t534.action_type) ~= "number" then t1.ActionType.fromName(t534.action_type) or t534.action_type else t1.ActionType.fromNumber(t534.action_type) or t534.action_type
			end

			if t534.actionType ~= nil then
				v3994.action_type = if typeof(t534.actionType) ~= "number" then t1.ActionType.fromName(t534.actionType) or t534.actionType else t1.ActionType.fromNumber(t534.actionType) or t534.actionType
			end

			if t534.action_params ~= nil then
				v3994.action_params = t1.EnableEventNotificationsAction_Params.jsonDecode(t534.action_params)
			end

			if t534.actionParams ~= nil then
				v3994.action_params = t1.EnableEventNotificationsAction_Params.jsonDecode(t534.actionParams)
			end

			return v3994
		end

		t531.descriptor = {
			name = "EnableEventNotificationsAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.EnableEventNotificationsAction"
		}
		t1.EnableEventNotificationsAction = t531
	end

	typeRegistry.default:register(t1.EnableEventNotificationsAction)

	do
		local t535 = {}

		t535.__index = t535

		function t535.new(t536: {[any]: any}?) -- line: 25739
			-- upvalues: t535 (copy)
			return (setmetatable({
				event_id = if t536 ~= nil and t536.event_id ~= nil then t536.event_id else nil,
				universe_id = if t536 ~= nil and t536.universe_id ~= nil then t536.universe_id else nil,
				channel = if t536 ~= nil and t536.channel ~= nil then t536.channel else nil
			}, t535))
		end
		function t535.encode(p403) -- line: 25749
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n266 = 0

			if p403.event_id ~= nil then
				local v3999 = p403.event_id:encode()
				local v4000, v4001 = proto.writeTag(buf, n266, 1, proto.wireTypes.lengthDelimited)

				buf, n266 = proto.writeBuffer(v4000, v4001, v3999, buffer.len(v3999))
			end

			if p403.universe_id ~= nil then
				local v4002 = p403.universe_id:encode()
				local v4003, v4004 = proto.writeTag(buf, n266, 2, proto.wireTypes.lengthDelimited)

				buf, n266 = proto.writeBuffer(v4003, v4004, v4002, buffer.len(v4002))
			end

			if p403.channel ~= nil then
				local v4005 = p403.channel:encode()
				local v4006, v4007 = proto.writeTag(buf, n266, 3, proto.wireTypes.lengthDelimited)

				buf, n266 = proto.writeBuffer(v4006, v4007, v4005, buffer.len(v4005))
			end

			local buf136 = buffer.create(n266)

			buffer.copy(buf136, 0, buf, 0, n266)

			return buf136
		end
		function t535.decode(p404: buffer) -- line: 25776
			-- upvalues: t535 (copy), proto (copy), prop_types (copy)
			local v4010 = t535.new()
			local n267 = 0

			while n267 < buffer.len(p404) do
				local v4012, v4013

				v4012, v4013, n267 = proto.readTag(p404, n267)

				if v4013 == proto.wireTypes.varint then
					local v4014

					v4014, n267 = proto.readVarInt(p404, n267)
				elseif v4013 == proto.wireTypes.lengthDelimited then
					if v4012 == 1 then
						local v4015

						v4015, n267 = proto.readBuffer(p404, n267)
						v4010.event_id = prop_types.StringProp.decode(v4015)
					elseif v4012 == 2 then
						local v4016

						v4016, n267 = proto.readBuffer(p404, n267)
						v4010.universe_id = prop_types.StringProp.decode(v4016)
					elseif v4012 == 3 then
						local v4017

						v4017, n267 = proto.readBuffer(p404, n267)
						v4010.channel = prop_types.StringProp.decode(v4017)
					else
						local v4018, v4019 = proto.readVarInt(p404, n267)

						n267 = v4019 + v4018
					end
				elseif v4013 == proto.wireTypes.i32 then
					local v4020

					v4020, n267 = proto.readFixed32(p404, n267)
				elseif v4013 == proto.wireTypes.i64 then
					local v4021

					v4021, n267 = proto.readFixed64(p404, n267)
				else
					error("Unsupported wire type: " .. v4013)
				end
			end

			return v4010
		end
		function t535.jsonEncode(p405) -- line: 25829
			local t537 = {}

			if p405.event_id ~= nil then
				t537.eventId = p405.event_id:jsonEncode()
			end

			if p405.universe_id ~= nil then
				t537.universeId = p405.universe_id:jsonEncode()
			end

			if p405.channel ~= nil then
				t537.channel = p405.channel:jsonEncode()
			end

			return t537
		end
		function t535.jsonDecode(t538: {[any]: any}) -- line: 25847
			-- upvalues: t535 (copy), prop_types (copy)
			local v4025 = t535.new()

			if t538.event_id ~= nil then
				v4025.event_id = prop_types.StringProp.jsonDecode(t538.event_id)
			end

			if t538.eventId ~= nil then
				v4025.event_id = prop_types.StringProp.jsonDecode(t538.eventId)
			end

			if t538.universe_id ~= nil then
				v4025.universe_id = prop_types.StringProp.jsonDecode(t538.universe_id)
			end

			if t538.universeId ~= nil then
				v4025.universe_id = prop_types.StringProp.jsonDecode(t538.universeId)
			end

			if t538.channel ~= nil then
				v4025.channel = prop_types.StringProp.jsonDecode(t538.channel)
			end

			return v4025
		end

		t535.descriptor = {
			name = "EnableEventNotificationsAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.EnableEventNotificationsAction_Params = t535
		typeRegistry.default:register(t1.EnableEventNotificationsAction_Params)

		local t539 = {}

		t539.__index = t539

		function t539.new(t540: {[any]: any}?) -- line: 25890
			-- upvalues: t1 (copy), t539 (copy)
			return (setmetatable({
				action_type = if t540 ~= nil and t540.action_type ~= nil then t540.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t540 ~= nil and t540.action_params ~= nil then t540.action_params else nil
			}, t539))
		end
		function t539.encode(p406) -- line: 25901
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n268 = 0

			if p406.action_type ~= nil and (p406.action_type ~= nil and p406.action_type ~= 0 or p406.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4030, v4031 = proto.writeTag(buf, n268, 1, proto.wireTypes.varint)

				buf, n268 = proto.writeVarInt(v4030, v4031, t1.ActionType.toNumber(p406.action_type))
			end

			if p406.action_params ~= nil then
				local v4032 = p406.action_params:encode()
				local v4033, v4034 = proto.writeTag(buf, n268, 2, proto.wireTypes.lengthDelimited)

				buf, n268 = proto.writeBuffer(v4033, v4034, v4032, buffer.len(v4032))
			end

			local buf137 = buffer.create(n268)

			buffer.copy(buf137, 0, buf, 0, n268)

			return buf137
		end
		function t539.decode(p407: buffer) -- line: 25927
			-- upvalues: t539 (copy), proto (copy), t1 (copy)
			local v4037 = t539.new()
			local n269 = 0

			while n269 < buffer.len(p407) do
				local v4039, v4040

				v4039, v4040, n269 = proto.readTag(p407, n269)

				if v4040 == proto.wireTypes.varint then
					if v4039 == 1 then
						local v4041

						v4041, n269 = proto.readVarIntI32(p407, n269)
						v4037.action_type = t1.ActionType.fromNumber(v4041) or v4041
					else
						local v4042

						v4042, n269 = proto.readVarInt(p407, n269)
					end
				elseif v4040 == proto.wireTypes.lengthDelimited then
					if v4039 == 2 then
						local v4043

						v4043, n269 = proto.readBuffer(p407, n269)
						v4037.action_params = t1.DismissEventNotificationsModalAction_Params.decode(v4043)
					else
						local v4044, v4045 = proto.readVarInt(p407, n269)

						n269 = v4045 + v4044
					end
				elseif v4040 == proto.wireTypes.i32 then
					local v4046

					v4046, n269 = proto.readFixed32(p407, n269)
				elseif v4040 == proto.wireTypes.i64 then
					local v4047

					v4047, n269 = proto.readFixed64(p407, n269)
				else
					error("Unsupported wire type: " .. v4040)
				end
			end

			return v4037
		end
		function t539.jsonEncode(p408) -- line: 25975
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
		function t539.jsonDecode(t542: {[any]: any}) -- line: 25997
			-- upvalues: t539 (copy), t1 (copy)
			local v4051 = t539.new()

			if t542.action_type ~= nil then
				v4051.action_type = if typeof(t542.action_type) ~= "number" then t1.ActionType.fromName(t542.action_type) or t542.action_type else t1.ActionType.fromNumber(t542.action_type) or t542.action_type
			end

			if t542.actionType ~= nil then
				v4051.action_type = if typeof(t542.actionType) ~= "number" then t1.ActionType.fromName(t542.actionType) or t542.actionType else t1.ActionType.fromNumber(t542.actionType) or t542.actionType
			end

			if t542.action_params ~= nil then
				v4051.action_params = t1.DismissEventNotificationsModalAction_Params.jsonDecode(t542.action_params)
			end

			if t542.actionParams ~= nil then
				v4051.action_params = t1.DismissEventNotificationsModalAction_Params.jsonDecode(t542.actionParams)
			end

			return v4051
		end

		t539.descriptor = {
			name = "DismissEventNotificationsModalAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.DismissEventNotificationsModalAction"
		}
		t1.DismissEventNotificationsModalAction = t539
	end

	typeRegistry.default:register(t1.DismissEventNotificationsModalAction)

	do
		local t543 = {}

		t543.__index = t543

		function t543.new(t544: {[any]: any}?) -- line: 26039
			-- upvalues: t543 (copy)
			return (setmetatable({
				event_id = if t544 ~= nil and t544.event_id ~= nil then t544.event_id else nil
			}, t543))
		end
		function t543.encode(p409) -- line: 26047
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n270 = 0

			if p409.event_id ~= nil then
				local v4056 = p409.event_id:encode()
				local v4057, v4058 = proto.writeTag(buf, n270, 1, proto.wireTypes.lengthDelimited)

				buf, n270 = proto.writeBuffer(v4057, v4058, v4056, buffer.len(v4056))
			end

			local buf138 = buffer.create(n270)

			buffer.copy(buf138, 0, buf, 0, n270)

			return buf138
		end
		function t543.decode(p410: buffer) -- line: 26064
			-- upvalues: t543 (copy), proto (copy), prop_types (copy)
			local v4061 = t543.new()
			local n271 = 0

			while n271 < buffer.len(p410) do
				local v4063, v4064

				v4063, v4064, n271 = proto.readTag(p410, n271)

				if v4064 == proto.wireTypes.varint then
					local v4065

					v4065, n271 = proto.readVarInt(p410, n271)
				elseif v4064 == proto.wireTypes.lengthDelimited then
					if v4063 == 1 then
						local v4066

						v4066, n271 = proto.readBuffer(p410, n271)
						v4061.event_id = prop_types.StringProp.decode(v4066)
					else
						local v4067, v4068 = proto.readVarInt(p410, n271)

						n271 = v4068 + v4067
					end
				elseif v4064 == proto.wireTypes.i32 then
					local v4069

					v4069, n271 = proto.readFixed32(p410, n271)
				elseif v4064 == proto.wireTypes.i64 then
					local v4070

					v4070, n271 = proto.readFixed64(p410, n271)
				else
					error("Unsupported wire type: " .. v4064)
				end
			end

			return v4061
		end
		function t543.jsonEncode(p411) -- line: 26109
			local t545 = {}

			if p411.event_id ~= nil then
				t545.eventId = p411.event_id:jsonEncode()
			end

			return t545
		end
		function t543.jsonDecode(t546: {[any]: any}) -- line: 26121
			-- upvalues: t543 (copy), prop_types (copy)
			local v4074 = t543.new()

			if t546.event_id ~= nil then
				v4074.event_id = prop_types.StringProp.jsonDecode(t546.event_id)
			end

			if t546.eventId ~= nil then
				v4074.event_id = prop_types.StringProp.jsonDecode(t546.eventId)
			end

			return v4074
		end

		t543.descriptor = {
			name = "DismissEventNotificationsModalAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.DismissEventNotificationsModalAction_Params = t543
		typeRegistry.default:register(t1.DismissEventNotificationsModalAction_Params)

		local t547 = {}

		t547.__index = t547

		function t547.new(t548: {[any]: any}?) -- line: 26151
			-- upvalues: t1 (copy), t547 (copy)
			return (setmetatable({
				action_type = if t548 ~= nil and t548.action_type ~= nil then t548.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t548 ~= nil and t548.action_params ~= nil then t548.action_params else nil
			}, t547))
		end
		function t547.encode(p412) -- line: 26160
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n272 = 0

			if p412.action_type ~= nil and (p412.action_type ~= nil and p412.action_type ~= 0 or p412.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4079, v4080 = proto.writeTag(buf, n272, 1, proto.wireTypes.varint)

				buf, n272 = proto.writeVarInt(v4079, v4080, t1.ActionType.toNumber(p412.action_type))
			end

			if p412.action_params ~= nil then
				local v4081 = p412.action_params:encode()
				local v4082, v4083 = proto.writeTag(buf, n272, 2, proto.wireTypes.lengthDelimited)

				buf, n272 = proto.writeBuffer(v4082, v4083, v4081, buffer.len(v4081))
			end

			local buf139 = buffer.create(n272)

			buffer.copy(buf139, 0, buf, 0, n272)

			return buf139
		end
		function t547.decode(p413: buffer) -- line: 26186
			-- upvalues: t547 (copy), proto (copy), t1 (copy)
			local v4086 = t547.new()
			local n273 = 0

			while n273 < buffer.len(p413) do
				local v4088, v4089

				v4088, v4089, n273 = proto.readTag(p413, n273)

				if v4089 == proto.wireTypes.varint then
					if v4088 == 1 then
						local v4090

						v4090, n273 = proto.readVarIntI32(p413, n273)
						v4086.action_type = t1.ActionType.fromNumber(v4090) or v4090
					else
						local v4091

						v4091, n273 = proto.readVarInt(p413, n273)
					end
				elseif v4089 == proto.wireTypes.lengthDelimited then
					if v4088 == 2 then
						local v4092

						v4092, n273 = proto.readBuffer(p413, n273)
						v4086.action_params = t1.OpenAmpWizardAction_Params.decode(v4092)
					else
						local v4093, v4094 = proto.readVarInt(p413, n273)

						n273 = v4094 + v4093
					end
				elseif v4089 == proto.wireTypes.i32 then
					local v4095

					v4095, n273 = proto.readFixed32(p413, n273)
				elseif v4089 == proto.wireTypes.i64 then
					local v4096

					v4096, n273 = proto.readFixed64(p413, n273)
				else
					error("Unsupported wire type: " .. v4089)
				end
			end

			return v4086
		end
		function t547.jsonEncode(p414) -- line: 26234
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
		function t547.jsonDecode(t550: {[any]: any}) -- line: 26256
			-- upvalues: t547 (copy), t1 (copy)
			local v4100 = t547.new()

			if t550.action_type ~= nil then
				v4100.action_type = if typeof(t550.action_type) ~= "number" then t1.ActionType.fromName(t550.action_type) or t550.action_type else t1.ActionType.fromNumber(t550.action_type) or t550.action_type
			end

			if t550.actionType ~= nil then
				v4100.action_type = if typeof(t550.actionType) ~= "number" then t1.ActionType.fromName(t550.actionType) or t550.actionType else t1.ActionType.fromNumber(t550.actionType) or t550.actionType
			end

			if t550.action_params ~= nil then
				v4100.action_params = t1.OpenAmpWizardAction_Params.jsonDecode(t550.action_params)
			end

			if t550.actionParams ~= nil then
				v4100.action_params = t1.OpenAmpWizardAction_Params.jsonDecode(t550.actionParams)
			end

			return v4100
		end

		t547.descriptor = {
			name = "OpenAmpWizardAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenAmpWizardAction"
		}
		t1.OpenAmpWizardAction = t547
	end

	typeRegistry.default:register(t1.OpenAmpWizardAction)

	do
		local t551 = {}

		t551.__index = t551

		function t551.new(t552: {[any]: any}?) -- line: 26296
			-- upvalues: t551 (copy)
			return (setmetatable({
				feature_name = if t552 ~= nil and t552.feature_name ~= nil then t552.feature_name else nil,
				name_space = if t552 ~= nil and t552.name_space ~= nil then t552.name_space else nil,
				entry_point_event_ctx = if t552 ~= nil and t552.entry_point_event_ctx ~= nil then t552.entry_point_event_ctx else nil,
				skip_facial_age_estimation_web_link_modal = if t552 ~= nil and t552.skip_facial_age_estimation_web_link_modal ~= nil then t552.skip_facial_age_estimation_web_link_modal else nil
			}, t551))
		end
		function t551.encode(p415) -- line: 26312
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n274 = 0

			if p415.feature_name ~= nil then
				local v4105 = p415.feature_name:encode()
				local v4106, v4107 = proto.writeTag(buf, n274, 1, proto.wireTypes.lengthDelimited)

				buf, n274 = proto.writeBuffer(v4106, v4107, v4105, buffer.len(v4105))
			end

			if p415.name_space ~= nil then
				local v4108 = p415.name_space:encode()
				local v4109, v4110 = proto.writeTag(buf, n274, 2, proto.wireTypes.lengthDelimited)

				buf, n274 = proto.writeBuffer(v4109, v4110, v4108, buffer.len(v4108))
			end

			if p415.entry_point_event_ctx ~= nil then
				local v4111 = p415.entry_point_event_ctx:encode()
				local v4112, v4113 = proto.writeTag(buf, n274, 3, proto.wireTypes.lengthDelimited)

				buf, n274 = proto.writeBuffer(v4112, v4113, v4111, buffer.len(v4111))
			end

			if p415.skip_facial_age_estimation_web_link_modal ~= nil then
				local v4114 = p415.skip_facial_age_estimation_web_link_modal:encode()
				local v4115, v4116 = proto.writeTag(buf, n274, 4, proto.wireTypes.lengthDelimited)

				buf, n274 = proto.writeBuffer(v4115, v4116, v4114, buffer.len(v4114))
			end

			local buf140 = buffer.create(n274)

			buffer.copy(buf140, 0, buf, 0, n274)

			return buf140
		end
		function t551.decode(p416: buffer) -- line: 26345
			-- upvalues: t551 (copy), proto (copy), prop_types (copy)
			local v4119 = t551.new()
			local n275 = 0

			while n275 < buffer.len(p416) do
				local v4121, v4122

				v4121, v4122, n275 = proto.readTag(p416, n275)

				if v4122 == proto.wireTypes.varint then
					local v4123

					v4123, n275 = proto.readVarInt(p416, n275)
				elseif v4122 == proto.wireTypes.lengthDelimited then
					if v4121 == 1 then
						local v4124

						v4124, n275 = proto.readBuffer(p416, n275)
						v4119.feature_name = prop_types.StringProp.decode(v4124)
					elseif v4121 == 2 then
						local v4125

						v4125, n275 = proto.readBuffer(p416, n275)
						v4119.name_space = prop_types.StringProp.decode(v4125)
					elseif v4121 == 3 then
						local v4126

						v4126, n275 = proto.readBuffer(p416, n275)
						v4119.entry_point_event_ctx = prop_types.StringProp.decode(v4126)
					elseif v4121 == 4 then
						local v4127

						v4127, n275 = proto.readBuffer(p416, n275)
						v4119.skip_facial_age_estimation_web_link_modal = prop_types.BoolProp.decode(v4127)
					else
						local v4128, v4129 = proto.readVarInt(p416, n275)

						n275 = v4129 + v4128
					end
				elseif v4122 == proto.wireTypes.i32 then
					local v4130

					v4130, n275 = proto.readFixed32(p416, n275)
				elseif v4122 == proto.wireTypes.i64 then
					local v4131

					v4131, n275 = proto.readFixed64(p416, n275)
				else
					error("Unsupported wire type: " .. v4122)
				end
			end

			return v4119
		end
		function t551.jsonEncode(p417) -- line: 26405
			local t553 = {}

			if p417.feature_name ~= nil then
				t553.featureName = p417.feature_name:jsonEncode()
			end

			if p417.name_space ~= nil then
				t553.nameSpace = p417.name_space:jsonEncode()
			end

			if p417.entry_point_event_ctx ~= nil then
				t553.entryPointEventCtx = p417.entry_point_event_ctx:jsonEncode()
			end

			if p417.skip_facial_age_estimation_web_link_modal ~= nil then
				t553.skipFacialAgeEstimationWebLinkModal = p417.skip_facial_age_estimation_web_link_modal:jsonEncode()
			end

			return t553
		end
		function t551.jsonDecode(t554: {[any]: any}) -- line: 26427
			-- upvalues: t551 (copy), prop_types (copy)
			local v4135 = t551.new()

			if t554.feature_name ~= nil then
				v4135.feature_name = prop_types.StringProp.jsonDecode(t554.feature_name)
			end

			if t554.featureName ~= nil then
				v4135.feature_name = prop_types.StringProp.jsonDecode(t554.featureName)
			end

			if t554.name_space ~= nil then
				v4135.name_space = prop_types.StringProp.jsonDecode(t554.name_space)
			end

			if t554.nameSpace ~= nil then
				v4135.name_space = prop_types.StringProp.jsonDecode(t554.nameSpace)
			end

			if t554.entry_point_event_ctx ~= nil then
				v4135.entry_point_event_ctx = prop_types.StringProp.jsonDecode(t554.entry_point_event_ctx)
			end

			if t554.entryPointEventCtx ~= nil then
				v4135.entry_point_event_ctx = prop_types.StringProp.jsonDecode(t554.entryPointEventCtx)
			end

			if t554.skip_facial_age_estimation_web_link_modal ~= nil then
				v4135.skip_facial_age_estimation_web_link_modal = prop_types.BoolProp.jsonDecode(t554.skip_facial_age_estimation_web_link_modal)
			end

			if t554.skipFacialAgeEstimationWebLinkModal ~= nil then
				v4135.skip_facial_age_estimation_web_link_modal = prop_types.BoolProp.jsonDecode(t554.skipFacialAgeEstimationWebLinkModal)
			end

			return v4135
		end

		t551.descriptor = {
			name = "OpenAmpWizardAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenAmpWizardAction_Params = t551
		typeRegistry.default:register(t1.OpenAmpWizardAction_Params)

		local t555 = {}

		t555.__index = t555

		function t555.new(t556: {[any]: any}?) -- line: 26489
			-- upvalues: t1 (copy), t555 (copy)
			return (setmetatable({
				action_type = if t556 ~= nil and t556.action_type ~= nil then t556.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t556 ~= nil and t556.action_params ~= nil then t556.action_params else nil
			}, t555))
		end
		function t555.encode(p418) -- line: 26500
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n276 = 0

			if p418.action_type ~= nil and (p418.action_type ~= nil and p418.action_type ~= 0 or p418.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4140, v4141 = proto.writeTag(buf, n276, 1, proto.wireTypes.varint)

				buf, n276 = proto.writeVarInt(v4140, v4141, t1.ActionType.toNumber(p418.action_type))
			end

			if p418.action_params ~= nil then
				local v4142 = p418.action_params:encode()
				local v4143, v4144 = proto.writeTag(buf, n276, 2, proto.wireTypes.lengthDelimited)

				buf, n276 = proto.writeBuffer(v4143, v4144, v4142, buffer.len(v4142))
			end

			local buf141 = buffer.create(n276)

			buffer.copy(buf141, 0, buf, 0, n276)

			return buf141
		end
		function t555.decode(p419: buffer) -- line: 26526
			-- upvalues: t555 (copy), proto (copy), t1 (copy)
			local v4147 = t555.new()
			local n277 = 0

			while n277 < buffer.len(p419) do
				local v4149, v4150

				v4149, v4150, n277 = proto.readTag(p419, n277)

				if v4150 == proto.wireTypes.varint then
					if v4149 == 1 then
						local v4151

						v4151, n277 = proto.readVarIntI32(p419, n277)
						v4147.action_type = t1.ActionType.fromNumber(v4151) or v4151
					else
						local v4152

						v4152, n277 = proto.readVarInt(p419, n277)
					end
				elseif v4150 == proto.wireTypes.lengthDelimited then
					if v4149 == 2 then
						local v4153

						v4153, n277 = proto.readBuffer(p419, n277)
						v4147.action_params = t1.OpenSocialProofUserListSheetAction_Params.decode(v4153)
					else
						local v4154, v4155 = proto.readVarInt(p419, n277)

						n277 = v4155 + v4154
					end
				elseif v4150 == proto.wireTypes.i32 then
					local v4156

					v4156, n277 = proto.readFixed32(p419, n277)
				elseif v4150 == proto.wireTypes.i64 then
					local v4157

					v4157, n277 = proto.readFixed64(p419, n277)
				else
					error("Unsupported wire type: " .. v4150)
				end
			end

			return v4147
		end
		function t555.jsonEncode(p420) -- line: 26574
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
		function t555.jsonDecode(t558: {[any]: any}) -- line: 26596
			-- upvalues: t555 (copy), t1 (copy)
			local v4161 = t555.new()

			if t558.action_type ~= nil then
				v4161.action_type = if typeof(t558.action_type) ~= "number" then t1.ActionType.fromName(t558.action_type) or t558.action_type else t1.ActionType.fromNumber(t558.action_type) or t558.action_type
			end

			if t558.actionType ~= nil then
				v4161.action_type = if typeof(t558.actionType) ~= "number" then t1.ActionType.fromName(t558.actionType) or t558.actionType else t1.ActionType.fromNumber(t558.actionType) or t558.actionType
			end

			if t558.action_params ~= nil then
				v4161.action_params = t1.OpenSocialProofUserListSheetAction_Params.jsonDecode(t558.action_params)
			end

			if t558.actionParams ~= nil then
				v4161.action_params = t1.OpenSocialProofUserListSheetAction_Params.jsonDecode(t558.actionParams)
			end

			return v4161
		end

		t555.descriptor = {
			name = "OpenSocialProofUserListSheetAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenSocialProofUserListSheetAction"
		}
		t1.OpenSocialProofUserListSheetAction = t555
	end

	typeRegistry.default:register(t1.OpenSocialProofUserListSheetAction)

	do
		local t559 = {}

		t559.__index = t559

		function t559.new(t560: {[any]: any}?) -- line: 26638
			-- upvalues: t559 (copy)
			return (setmetatable({
				universe_id = if t560 ~= nil and t560.universe_id ~= nil then t560.universe_id else nil,
				place_id = if t560 ~= nil and t560.place_id ~= nil then t560.place_id else nil,
				total_connections = if t560 ~= nil and t560.total_connections ~= nil then t560.total_connections else nil,
				user_ids = if t560 ~= nil and t560.user_ids ~= nil then t560.user_ids else nil,
				sheet_title = if t560 ~= nil and t560.sheet_title ~= nil then t560.sheet_title else nil
			}, t559))
		end
		function t559.encode(p421) -- line: 26650
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n278 = 0

			if p421.universe_id ~= nil then
				local v4166 = p421.universe_id:encode()
				local v4167, v4168 = proto.writeTag(buf, n278, 1, proto.wireTypes.lengthDelimited)

				buf, n278 = proto.writeBuffer(v4167, v4168, v4166, buffer.len(v4166))
			end

			if p421.place_id ~= nil then
				local v4169 = p421.place_id:encode()
				local v4170, v4171 = proto.writeTag(buf, n278, 2, proto.wireTypes.lengthDelimited)

				buf, n278 = proto.writeBuffer(v4170, v4171, v4169, buffer.len(v4169))
			end

			if p421.total_connections ~= nil then
				local v4172 = p421.total_connections:encode()
				local v4173, v4174 = proto.writeTag(buf, n278, 3, proto.wireTypes.lengthDelimited)

				buf, n278 = proto.writeBuffer(v4173, v4174, v4172, buffer.len(v4172))
			end

			if p421.user_ids ~= nil then
				local v4175 = p421.user_ids:encode()
				local v4176, v4177 = proto.writeTag(buf, n278, 4, proto.wireTypes.lengthDelimited)

				buf, n278 = proto.writeBuffer(v4176, v4177, v4175, buffer.len(v4175))
			end

			if p421.sheet_title ~= nil then
				local v4178 = p421.sheet_title:encode()
				local v4179, v4180 = proto.writeTag(buf, n278, 5, proto.wireTypes.lengthDelimited)

				buf, n278 = proto.writeBuffer(v4179, v4180, v4178, buffer.len(v4178))
			end

			local buf142 = buffer.create(n278)

			buffer.copy(buf142, 0, buf, 0, n278)

			return buf142
		end
		function t559.decode(p422: buffer) -- line: 26691
			-- upvalues: t559 (copy), proto (copy), prop_types (copy)
			local v4183 = t559.new()
			local n279 = 0

			while n279 < buffer.len(p422) do
				local v4185, v4186

				v4185, v4186, n279 = proto.readTag(p422, n279)

				if v4186 == proto.wireTypes.varint then
					local v4187

					v4187, n279 = proto.readVarInt(p422, n279)
				elseif v4186 == proto.wireTypes.lengthDelimited then
					if v4185 == 1 then
						local v4188

						v4188, n279 = proto.readBuffer(p422, n279)
						v4183.universe_id = prop_types.StringProp.decode(v4188)
					elseif v4185 == 2 then
						local v4189

						v4189, n279 = proto.readBuffer(p422, n279)
						v4183.place_id = prop_types.StringProp.decode(v4189)
					elseif v4185 == 3 then
						local v4190

						v4190, n279 = proto.readBuffer(p422, n279)
						v4183.total_connections = prop_types.Int32Prop.decode(v4190)
					elseif v4185 == 4 then
						local v4191

						v4191, n279 = proto.readBuffer(p422, n279)
						v4183.user_ids = prop_types.ArrayOfAvatarProp.decode(v4191)
					elseif v4185 == 5 then
						local v4192

						v4192, n279 = proto.readBuffer(p422, n279)
						v4183.sheet_title = prop_types.StringProp.decode(v4192)
					else
						local v4193, v4194 = proto.readVarInt(p422, n279)

						n279 = v4194 + v4193
					end
				elseif v4186 == proto.wireTypes.i32 then
					local v4195

					v4195, n279 = proto.readFixed32(p422, n279)
				elseif v4186 == proto.wireTypes.i64 then
					local v4196

					v4196, n279 = proto.readFixed64(p422, n279)
				else
					error("Unsupported wire type: " .. v4186)
				end
			end

			return v4183
		end
		function t559.jsonEncode(p423) -- line: 26756
			local t561 = {}

			if p423.universe_id ~= nil then
				t561.universeId = p423.universe_id:jsonEncode()
			end

			if p423.place_id ~= nil then
				t561.placeId = p423.place_id:jsonEncode()
			end

			if p423.total_connections ~= nil then
				t561.totalConnections = p423.total_connections:jsonEncode()
			end

			if p423.user_ids ~= nil then
				t561.userIds = p423.user_ids:jsonEncode()
			end

			if p423.sheet_title ~= nil then
				t561.sheetTitle = p423.sheet_title:jsonEncode()
			end

			return t561
		end
		function t559.jsonDecode(t562: {[any]: any}) -- line: 26784
			-- upvalues: t559 (copy), prop_types (copy)
			local v4200 = t559.new()

			if t562.universe_id ~= nil then
				v4200.universe_id = prop_types.StringProp.jsonDecode(t562.universe_id)
			end

			if t562.universeId ~= nil then
				v4200.universe_id = prop_types.StringProp.jsonDecode(t562.universeId)
			end

			if t562.place_id ~= nil then
				v4200.place_id = prop_types.StringProp.jsonDecode(t562.place_id)
			end

			if t562.placeId ~= nil then
				v4200.place_id = prop_types.StringProp.jsonDecode(t562.placeId)
			end

			if t562.total_connections ~= nil then
				v4200.total_connections = prop_types.Int32Prop.jsonDecode(t562.total_connections)
			end

			if t562.totalConnections ~= nil then
				v4200.total_connections = prop_types.Int32Prop.jsonDecode(t562.totalConnections)
			end

			if t562.user_ids ~= nil then
				v4200.user_ids = prop_types.ArrayOfAvatarProp.jsonDecode(t562.user_ids)
			end

			if t562.userIds ~= nil then
				v4200.user_ids = prop_types.ArrayOfAvatarProp.jsonDecode(t562.userIds)
			end

			if t562.sheet_title ~= nil then
				v4200.sheet_title = prop_types.StringProp.jsonDecode(t562.sheet_title)
			end

			if t562.sheetTitle ~= nil then
				v4200.sheet_title = prop_types.StringProp.jsonDecode(t562.sheetTitle)
			end

			return v4200
		end

		t559.descriptor = {
			name = "OpenSocialProofUserListSheetAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenSocialProofUserListSheetAction_Params = t559
		typeRegistry.default:register(t1.OpenSocialProofUserListSheetAction_Params)

		local t563 = {}

		t563.__index = t563

		function t563.new(t564: {[any]: any}?) -- line: 26852
			-- upvalues: t1 (copy), t563 (copy)
			return (setmetatable({
				action_type = if t564 ~= nil and t564.action_type ~= nil then t564.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t564 ~= nil and t564.action_params ~= nil then t564.action_params else nil
			}, t563))
		end
		function t563.encode(p424) -- line: 26863
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n280 = 0

			if p424.action_type ~= nil and (p424.action_type ~= nil and p424.action_type ~= 0 or p424.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4205, v4206 = proto.writeTag(buf, n280, 1, proto.wireTypes.varint)

				buf, n280 = proto.writeVarInt(v4205, v4206, t1.ActionType.toNumber(p424.action_type))
			end

			if p424.action_params ~= nil then
				local v4207 = p424.action_params:encode()
				local v4208, v4209 = proto.writeTag(buf, n280, 2, proto.wireTypes.lengthDelimited)

				buf, n280 = proto.writeBuffer(v4208, v4209, v4207, buffer.len(v4207))
			end

			local buf143 = buffer.create(n280)

			buffer.copy(buf143, 0, buf, 0, n280)

			return buf143
		end
		function t563.decode(p425: buffer) -- line: 26889
			-- upvalues: t563 (copy), proto (copy), t1 (copy)
			local v4212 = t563.new()
			local n281 = 0

			while n281 < buffer.len(p425) do
				local v4214, v4215

				v4214, v4215, n281 = proto.readTag(p425, n281)

				if v4215 == proto.wireTypes.varint then
					if v4214 == 1 then
						local v4216

						v4216, n281 = proto.readVarIntI32(p425, n281)
						v4212.action_type = t1.ActionType.fromNumber(v4216) or v4216
					else
						local v4217

						v4217, n281 = proto.readVarInt(p425, n281)
					end
				elseif v4215 == proto.wireTypes.lengthDelimited then
					if v4214 == 2 then
						local v4218

						v4218, n281 = proto.readBuffer(p425, n281)
						v4212.action_params = t1.OpenSearchResultsTabAction_Params.decode(v4218)
					else
						local v4219, v4220 = proto.readVarInt(p425, n281)

						n281 = v4220 + v4219
					end
				elseif v4215 == proto.wireTypes.i32 then
					local v4221

					v4221, n281 = proto.readFixed32(p425, n281)
				elseif v4215 == proto.wireTypes.i64 then
					local v4222

					v4222, n281 = proto.readFixed64(p425, n281)
				else
					error("Unsupported wire type: " .. v4215)
				end
			end

			return v4212
		end
		function t563.jsonEncode(p426) -- line: 26937
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
		function t563.jsonDecode(t566: {[any]: any}) -- line: 26959
			-- upvalues: t563 (copy), t1 (copy)
			local v4226 = t563.new()

			if t566.action_type ~= nil then
				v4226.action_type = if typeof(t566.action_type) ~= "number" then t1.ActionType.fromName(t566.action_type) or t566.action_type else t1.ActionType.fromNumber(t566.action_type) or t566.action_type
			end

			if t566.actionType ~= nil then
				v4226.action_type = if typeof(t566.actionType) ~= "number" then t1.ActionType.fromName(t566.actionType) or t566.actionType else t1.ActionType.fromNumber(t566.actionType) or t566.actionType
			end

			if t566.action_params ~= nil then
				v4226.action_params = t1.OpenSearchResultsTabAction_Params.jsonDecode(t566.action_params)
			end

			if t566.actionParams ~= nil then
				v4226.action_params = t1.OpenSearchResultsTabAction_Params.jsonDecode(t566.actionParams)
			end

			return v4226
		end

		t563.descriptor = {
			name = "OpenSearchResultsTabAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenSearchResultsTabAction"
		}
		t1.OpenSearchResultsTabAction = t563
	end

	typeRegistry.default:register(t1.OpenSearchResultsTabAction)

	do
		local t567 = {}

		t567.__index = t567

		function t567.new(t568: {[any]: any}?) -- line: 26999
			-- upvalues: t567 (copy)
			return (setmetatable({
				search_type = if t568 ~= nil and t568.search_type ~= nil then t568.search_type else nil
			}, t567))
		end
		function t567.encode(p427) -- line: 27007
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n282 = 0

			if p427.search_type ~= nil then
				local v4231 = p427.search_type:encode()
				local v4232, v4233 = proto.writeTag(buf, n282, 1, proto.wireTypes.lengthDelimited)

				buf, n282 = proto.writeBuffer(v4232, v4233, v4231, buffer.len(v4231))
			end

			local buf144 = buffer.create(n282)

			buffer.copy(buf144, 0, buf, 0, n282)

			return buf144
		end
		function t567.decode(p428: buffer) -- line: 27022
			-- upvalues: t567 (copy), proto (copy), prop_types (copy)
			local v4236 = t567.new()
			local n283 = 0

			while n283 < buffer.len(p428) do
				local v4238, v4239

				v4238, v4239, n283 = proto.readTag(p428, n283)

				if v4239 == proto.wireTypes.varint then
					local v4240

					v4240, n283 = proto.readVarInt(p428, n283)
				elseif v4239 == proto.wireTypes.lengthDelimited then
					if v4238 == 1 then
						local v4241

						v4241, n283 = proto.readBuffer(p428, n283)
						v4236.search_type = prop_types.StringProp.decode(v4241)
					else
						local v4242, v4243 = proto.readVarInt(p428, n283)

						n283 = v4243 + v4242
					end
				elseif v4239 == proto.wireTypes.i32 then
					local v4244

					v4244, n283 = proto.readFixed32(p428, n283)
				elseif v4239 == proto.wireTypes.i64 then
					local v4245

					v4245, n283 = proto.readFixed64(p428, n283)
				else
					error("Unsupported wire type: " .. v4239)
				end
			end

			return v4236
		end
		function t567.jsonEncode(p429) -- line: 27065
			local t569 = {}

			if p429.search_type ~= nil then
				t569.searchType = p429.search_type:jsonEncode()
			end

			return t569
		end
		function t567.jsonDecode(t570: {[any]: any}) -- line: 27075
			-- upvalues: t567 (copy), prop_types (copy)
			local v4249 = t567.new()

			if t570.search_type ~= nil then
				v4249.search_type = prop_types.StringProp.jsonDecode(t570.search_type)
			end

			if t570.searchType ~= nil then
				v4249.search_type = prop_types.StringProp.jsonDecode(t570.searchType)
			end

			return v4249
		end

		t567.descriptor = {
			name = "OpenSearchResultsTabAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenSearchResultsTabAction_Params = t567
		typeRegistry.default:register(t1.OpenSearchResultsTabAction_Params)

		local t571 = {}

		t571.__index = t571

		function t571.new(t572: {[any]: any}?) -- line: 27106
			-- upvalues: t1 (copy), t571 (copy)
			return (setmetatable({
				action_type = if t572 ~= nil and t572.action_type ~= nil then t572.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t572 ~= nil and t572.action_params ~= nil then t572.action_params else nil
			}, t571))
		end
		function t571.encode(p430) -- line: 27115
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n284 = 0

			if p430.action_type ~= nil and (p430.action_type ~= nil and p430.action_type ~= 0 or p430.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4254, v4255 = proto.writeTag(buf, n284, 1, proto.wireTypes.varint)

				buf, n284 = proto.writeVarInt(v4254, v4255, t1.ActionType.toNumber(p430.action_type))
			end

			if p430.action_params ~= nil then
				local v4256 = p430.action_params:encode()
				local v4257, v4258 = proto.writeTag(buf, n284, 2, proto.wireTypes.lengthDelimited)

				buf, n284 = proto.writeBuffer(v4257, v4258, v4256, buffer.len(v4256))
			end

			local buf145 = buffer.create(n284)

			buffer.copy(buf145, 0, buf, 0, n284)

			return buf145
		end
		function t571.decode(p431: buffer) -- line: 27141
			-- upvalues: t571 (copy), proto (copy), t1 (copy)
			local v4261 = t571.new()
			local n285 = 0

			while n285 < buffer.len(p431) do
				local v4263, v4264

				v4263, v4264, n285 = proto.readTag(p431, n285)

				if v4264 == proto.wireTypes.varint then
					if v4263 == 1 then
						local v4265

						v4265, n285 = proto.readVarIntI32(p431, n285)
						v4261.action_type = t1.ActionType.fromNumber(v4265) or v4265
					else
						local v4266

						v4266, n285 = proto.readVarInt(p431, n285)
					end
				elseif v4264 == proto.wireTypes.lengthDelimited then
					if v4263 == 2 then
						local v4267

						v4267, n285 = proto.readBuffer(p431, n285)
						v4261.action_params = t1.DismissPromptAction_Params.decode(v4267)
					else
						local v4268, v4269 = proto.readVarInt(p431, n285)

						n285 = v4269 + v4268
					end
				elseif v4264 == proto.wireTypes.i32 then
					local v4270

					v4270, n285 = proto.readFixed32(p431, n285)
				elseif v4264 == proto.wireTypes.i64 then
					local v4271

					v4271, n285 = proto.readFixed64(p431, n285)
				else
					error("Unsupported wire type: " .. v4264)
				end
			end

			return v4261
		end
		function t571.jsonEncode(p432) -- line: 27189
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
		function t571.jsonDecode(t574: {[any]: any}) -- line: 27211
			-- upvalues: t571 (copy), t1 (copy)
			local v4275 = t571.new()

			if t574.action_type ~= nil then
				v4275.action_type = if typeof(t574.action_type) ~= "number" then t1.ActionType.fromName(t574.action_type) or t574.action_type else t1.ActionType.fromNumber(t574.action_type) or t574.action_type
			end

			if t574.actionType ~= nil then
				v4275.action_type = if typeof(t574.actionType) ~= "number" then t1.ActionType.fromName(t574.actionType) or t574.actionType else t1.ActionType.fromNumber(t574.actionType) or t574.actionType
			end

			if t574.action_params ~= nil then
				v4275.action_params = t1.DismissPromptAction_Params.jsonDecode(t574.action_params)
			end

			if t574.actionParams ~= nil then
				v4275.action_params = t1.DismissPromptAction_Params.jsonDecode(t574.actionParams)
			end

			return v4275
		end

		t571.descriptor = {
			name = "DismissPromptAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.DismissPromptAction"
		}
		t1.DismissPromptAction = t571
	end

	typeRegistry.default:register(t1.DismissPromptAction)

	do
		local t575 = {}

		t575.__index = t575

		function t575.new(t576: {[any]: any}?) -- line: 27251
			-- upvalues: t575 (copy)
			return (setmetatable({
				prompt_type = if t576 ~= nil and t576.prompt_type ~= nil then t576.prompt_type else nil,
				prompt_id = if t576 ~= nil and t576.prompt_id ~= nil then t576.prompt_id else nil,
				entity_type = if t576 ~= nil and t576.entity_type ~= nil then t576.entity_type else nil,
				entity_id = if t576 ~= nil and t576.entity_id ~= nil then t576.entity_id else nil
			}, t575))
		end
		function t575.encode(p433) -- line: 27262
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n286 = 0

			if p433.prompt_type ~= nil then
				local v4280 = p433.prompt_type:encode()
				local v4281, v4282 = proto.writeTag(buf, n286, 1, proto.wireTypes.lengthDelimited)

				buf, n286 = proto.writeBuffer(v4281, v4282, v4280, buffer.len(v4280))
			end

			if p433.prompt_id ~= nil then
				local v4283 = p433.prompt_id:encode()
				local v4284, v4285 = proto.writeTag(buf, n286, 2, proto.wireTypes.lengthDelimited)

				buf, n286 = proto.writeBuffer(v4284, v4285, v4283, buffer.len(v4283))
			end

			if p433.entity_type ~= nil then
				local v4286 = p433.entity_type:encode()
				local v4287, v4288 = proto.writeTag(buf, n286, 3, proto.wireTypes.lengthDelimited)

				buf, n286 = proto.writeBuffer(v4287, v4288, v4286, buffer.len(v4286))
			end

			if p433.entity_id ~= nil then
				local v4289 = p433.entity_id:encode()
				local v4290, v4291 = proto.writeTag(buf, n286, 4, proto.wireTypes.lengthDelimited)

				buf, n286 = proto.writeBuffer(v4290, v4291, v4289, buffer.len(v4289))
			end

			local buf146 = buffer.create(n286)

			buffer.copy(buf146, 0, buf, 0, n286)

			return buf146
		end
		function t575.decode(p434: buffer) -- line: 27295
			-- upvalues: t575 (copy), proto (copy), prop_types (copy)
			local v4294 = t575.new()
			local n287 = 0

			while n287 < buffer.len(p434) do
				local v4296, v4297

				v4296, v4297, n287 = proto.readTag(p434, n287)

				if v4297 == proto.wireTypes.varint then
					local v4298

					v4298, n287 = proto.readVarInt(p434, n287)
				elseif v4297 == proto.wireTypes.lengthDelimited then
					if v4296 == 1 then
						local v4299

						v4299, n287 = proto.readBuffer(p434, n287)
						v4294.prompt_type = prop_types.StringProp.decode(v4299)
					elseif v4296 == 2 then
						local v4300

						v4300, n287 = proto.readBuffer(p434, n287)
						v4294.prompt_id = prop_types.StringProp.decode(v4300)
					elseif v4296 == 3 then
						local v4301

						v4301, n287 = proto.readBuffer(p434, n287)
						v4294.entity_type = prop_types.StringProp.decode(v4301)
					elseif v4296 == 4 then
						local v4302

						v4302, n287 = proto.readBuffer(p434, n287)
						v4294.entity_id = prop_types.StringProp.decode(v4302)
					else
						local v4303, v4304 = proto.readVarInt(p434, n287)

						n287 = v4304 + v4303
					end
				elseif v4297 == proto.wireTypes.i32 then
					local v4305

					v4305, n287 = proto.readFixed32(p434, n287)
				elseif v4297 == proto.wireTypes.i64 then
					local v4306

					v4306, n287 = proto.readFixed64(p434, n287)
				else
					error("Unsupported wire type: " .. v4297)
				end
			end

			return v4294
		end
		function t575.jsonEncode(p435) -- line: 27353
			local t577 = {}

			if p435.prompt_type ~= nil then
				t577.promptType = p435.prompt_type:jsonEncode()
			end

			if p435.prompt_id ~= nil then
				t577.promptId = p435.prompt_id:jsonEncode()
			end

			if p435.entity_type ~= nil then
				t577.entityType = p435.entity_type:jsonEncode()
			end

			if p435.entity_id ~= nil then
				t577.entityId = p435.entity_id:jsonEncode()
			end

			return t577
		end
		function t575.jsonDecode(t578: {[any]: any}) -- line: 27375
			-- upvalues: t575 (copy), prop_types (copy)
			local v4310 = t575.new()

			if t578.prompt_type ~= nil then
				v4310.prompt_type = prop_types.StringProp.jsonDecode(t578.prompt_type)
			end

			if t578.promptType ~= nil then
				v4310.prompt_type = prop_types.StringProp.jsonDecode(t578.promptType)
			end

			if t578.prompt_id ~= nil then
				v4310.prompt_id = prop_types.StringProp.jsonDecode(t578.prompt_id)
			end

			if t578.promptId ~= nil then
				v4310.prompt_id = prop_types.StringProp.jsonDecode(t578.promptId)
			end

			if t578.entity_type ~= nil then
				v4310.entity_type = prop_types.StringProp.jsonDecode(t578.entity_type)
			end

			if t578.entityType ~= nil then
				v4310.entity_type = prop_types.StringProp.jsonDecode(t578.entityType)
			end

			if t578.entity_id ~= nil then
				v4310.entity_id = prop_types.StringProp.jsonDecode(t578.entity_id)
			end

			if t578.entityId ~= nil then
				v4310.entity_id = prop_types.StringProp.jsonDecode(t578.entityId)
			end

			return v4310
		end

		t575.descriptor = {
			name = "DismissPromptAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.DismissPromptAction_Params = t575
		typeRegistry.default:register(t1.DismissPromptAction_Params)

		local t579 = {}

		t579.__index = t579

		function t579.new(t580: {[any]: any}?) -- line: 27430
			-- upvalues: t1 (copy), t579 (copy)
			return (setmetatable({
				action_type = if t580 ~= nil and t580.action_type ~= nil then t580.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t580 ~= nil and t580.action_params ~= nil then t580.action_params else nil
			}, t579))
		end
		function t579.encode(p436) -- line: 27444
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n288 = 0

			if p436.action_type ~= nil and (p436.action_type ~= nil and p436.action_type ~= 0 or p436.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4315, v4316 = proto.writeTag(buf, n288, 1, proto.wireTypes.varint)

				buf, n288 = proto.writeVarInt(v4315, v4316, t1.ActionType.toNumber(p436.action_type))
			end

			if p436.action_params ~= nil then
				local v4317 = p436.action_params:encode()
				local v4318, v4319 = proto.writeTag(buf, n288, 2, proto.wireTypes.lengthDelimited)

				buf, n288 = proto.writeBuffer(v4318, v4319, v4317, buffer.len(v4317))
			end

			local buf147 = buffer.create(n288)

			buffer.copy(buf147, 0, buf, 0, n288)

			return buf147
		end
		function t579.decode(p437: buffer) -- line: 27472
			-- upvalues: t579 (copy), proto (copy), t1 (copy)
			local v4322 = t579.new()
			local n289 = 0

			while n289 < buffer.len(p437) do
				local v4324, v4325

				v4324, v4325, n289 = proto.readTag(p437, n289)

				if v4325 == proto.wireTypes.varint then
					if v4324 == 1 then
						local v4326

						v4326, n289 = proto.readVarIntI32(p437, n289)
						v4322.action_type = t1.ActionType.fromNumber(v4326) or v4326
					else
						local v4327

						v4327, n289 = proto.readVarInt(p437, n289)
					end
				elseif v4325 == proto.wireTypes.lengthDelimited then
					if v4324 == 2 then
						local v4328

						v4328, n289 = proto.readBuffer(p437, n289)
						v4322.action_params = t1.RecordPartyChatConversationUpsellAcknowledgementAction_Params.decode(v4328)
					else
						local v4329, v4330 = proto.readVarInt(p437, n289)

						n289 = v4330 + v4329
					end
				elseif v4325 == proto.wireTypes.i32 then
					local v4331

					v4331, n289 = proto.readFixed32(p437, n289)
				elseif v4325 == proto.wireTypes.i64 then
					local v4332

					v4332, n289 = proto.readFixed64(p437, n289)
				else
					error("Unsupported wire type: " .. v4325)
				end
			end

			return v4322
		end
		function t579.jsonEncode(p438) -- line: 27523
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
		function t579.jsonDecode(t582: {[any]: any}) -- line: 27547
			-- upvalues: t579 (copy), t1 (copy)
			local v4336 = t579.new()

			if t582.action_type ~= nil then
				v4336.action_type = if typeof(t582.action_type) ~= "number" then t1.ActionType.fromName(t582.action_type) or t582.action_type else t1.ActionType.fromNumber(t582.action_type) or t582.action_type
			end

			if t582.actionType ~= nil then
				v4336.action_type = if typeof(t582.actionType) ~= "number" then t1.ActionType.fromName(t582.actionType) or t582.actionType else t1.ActionType.fromNumber(t582.actionType) or t582.actionType
			end

			if t582.action_params ~= nil then
				v4336.action_params = t1.RecordPartyChatConversationUpsellAcknowledgementAction_Params.jsonDecode(t582.action_params)
			end

			if t582.actionParams ~= nil then
				v4336.action_params = t1.RecordPartyChatConversationUpsellAcknowledgementAction_Params.jsonDecode(t582.actionParams)
			end

			return v4336
		end

		t579.descriptor = {
			name = "RecordPartyChatConversationUpsellAcknowledgementAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.RecordPartyChatConversationUpsellAcknowledgementAction"
		}
		t1.RecordPartyChatConversationUpsellAcknowledgementAction = t579
	end

	typeRegistry.default:register(t1.RecordPartyChatConversationUpsellAcknowledgementAction)

	do
		local t583 = {}

		t583.__index = t583

		function t583.new(t584: {[any]: any}?) -- line: 27593
			-- upvalues: t583 (copy)
			return (setmetatable({
				modal_action = if t584 ~= nil and t584.modal_action ~= nil then t584.modal_action else nil,
				modal_variant = if t584 ~= nil and t584.modal_variant ~= nil then t584.modal_variant else nil,
				modal_sequence = if t584 ~= nil and t584.modal_sequence ~= nil then t584.modal_sequence else nil,
				conversation_id = if t584 ~= nil and t584.conversation_id ~= nil then t584.conversation_id else nil,
				friend_id = if t584 ~= nil and t584.friend_id ~= nil then t584.friend_id else nil
			}, t583))
		end
		function t583.encode(p439) -- line: 27608
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n290 = 0

			if p439.modal_action ~= nil then
				local v4341 = p439.modal_action:encode()
				local v4342, v4343 = proto.writeTag(buf, n290, 1, proto.wireTypes.lengthDelimited)

				buf, n290 = proto.writeBuffer(v4342, v4343, v4341, buffer.len(v4341))
			end

			if p439.modal_variant ~= nil then
				local v4344 = p439.modal_variant:encode()
				local v4345, v4346 = proto.writeTag(buf, n290, 2, proto.wireTypes.lengthDelimited)

				buf, n290 = proto.writeBuffer(v4345, v4346, v4344, buffer.len(v4344))
			end

			if p439.modal_sequence ~= nil then
				local v4347 = p439.modal_sequence:encode()
				local v4348, v4349 = proto.writeTag(buf, n290, 3, proto.wireTypes.lengthDelimited)

				buf, n290 = proto.writeBuffer(v4348, v4349, v4347, buffer.len(v4347))
			end

			if p439.conversation_id ~= nil then
				local v4350 = p439.conversation_id:encode()
				local v4351, v4352 = proto.writeTag(buf, n290, 4, proto.wireTypes.lengthDelimited)

				buf, n290 = proto.writeBuffer(v4351, v4352, v4350, buffer.len(v4350))
			end

			if p439.friend_id ~= nil then
				local v4353 = p439.friend_id:encode()
				local v4354, v4355 = proto.writeTag(buf, n290, 5, proto.wireTypes.lengthDelimited)

				buf, n290 = proto.writeBuffer(v4354, v4355, v4353, buffer.len(v4353))
			end

			local buf148 = buffer.create(n290)

			buffer.copy(buf148, 0, buf, 0, n290)

			return buf148
		end
		function t583.decode(p440: buffer) -- line: 27649
			-- upvalues: t583 (copy), proto (copy), prop_types (copy)
			local v4358 = t583.new()
			local n291 = 0

			while n291 < buffer.len(p440) do
				local v4360, v4361

				v4360, v4361, n291 = proto.readTag(p440, n291)

				if v4361 == proto.wireTypes.varint then
					local v4362

					v4362, n291 = proto.readVarInt(p440, n291)
				elseif v4361 == proto.wireTypes.lengthDelimited then
					if v4360 == 1 then
						local v4363

						v4363, n291 = proto.readBuffer(p440, n291)
						v4358.modal_action = prop_types.StringProp.decode(v4363)
					elseif v4360 == 2 then
						local v4364

						v4364, n291 = proto.readBuffer(p440, n291)
						v4358.modal_variant = prop_types.StringProp.decode(v4364)
					elseif v4360 == 3 then
						local v4365

						v4365, n291 = proto.readBuffer(p440, n291)
						v4358.modal_sequence = prop_types.StringProp.decode(v4365)
					elseif v4360 == 4 then
						local v4366

						v4366, n291 = proto.readBuffer(p440, n291)
						v4358.conversation_id = prop_types.StringProp.decode(v4366)
					elseif v4360 == 5 then
						local v4367

						v4367, n291 = proto.readBuffer(p440, n291)
						v4358.friend_id = prop_types.StringProp.decode(v4367)
					else
						local v4368, v4369 = proto.readVarInt(p440, n291)

						n291 = v4369 + v4368
					end
				elseif v4361 == proto.wireTypes.i32 then
					local v4370

					v4370, n291 = proto.readFixed32(p440, n291)
				elseif v4361 == proto.wireTypes.i64 then
					local v4371

					v4371, n291 = proto.readFixed64(p440, n291)
				else
					error("Unsupported wire type: " .. v4361)
				end
			end

			return v4358
		end
		function t583.jsonEncode(p441) -- line: 27714
			local t585 = {}

			if p441.modal_action ~= nil then
				t585.modalAction = p441.modal_action:jsonEncode()
			end

			if p441.modal_variant ~= nil then
				t585.modalVariant = p441.modal_variant:jsonEncode()
			end

			if p441.modal_sequence ~= nil then
				t585.modalSequence = p441.modal_sequence:jsonEncode()
			end

			if p441.conversation_id ~= nil then
				t585.conversationId = p441.conversation_id:jsonEncode()
			end

			if p441.friend_id ~= nil then
				t585.friendId = p441.friend_id:jsonEncode()
			end

			return t585
		end
		function t583.jsonDecode(t586: {[any]: any}) -- line: 27742
			-- upvalues: t583 (copy), prop_types (copy)
			local v4375 = t583.new()

			if t586.modal_action ~= nil then
				v4375.modal_action = prop_types.StringProp.jsonDecode(t586.modal_action)
			end

			if t586.modalAction ~= nil then
				v4375.modal_action = prop_types.StringProp.jsonDecode(t586.modalAction)
			end

			if t586.modal_variant ~= nil then
				v4375.modal_variant = prop_types.StringProp.jsonDecode(t586.modal_variant)
			end

			if t586.modalVariant ~= nil then
				v4375.modal_variant = prop_types.StringProp.jsonDecode(t586.modalVariant)
			end

			if t586.modal_sequence ~= nil then
				v4375.modal_sequence = prop_types.StringProp.jsonDecode(t586.modal_sequence)
			end

			if t586.modalSequence ~= nil then
				v4375.modal_sequence = prop_types.StringProp.jsonDecode(t586.modalSequence)
			end

			if t586.conversation_id ~= nil then
				v4375.conversation_id = prop_types.StringProp.jsonDecode(t586.conversation_id)
			end

			if t586.conversationId ~= nil then
				v4375.conversation_id = prop_types.StringProp.jsonDecode(t586.conversationId)
			end

			if t586.friend_id ~= nil then
				v4375.friend_id = prop_types.StringProp.jsonDecode(t586.friend_id)
			end

			if t586.friendId ~= nil then
				v4375.friend_id = prop_types.StringProp.jsonDecode(t586.friendId)
			end

			return v4375
		end

		t583.descriptor = {
			name = "RecordPartyChatConversationUpsellAcknowledgementAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.RecordPartyChatConversationUpsellAcknowledgementAction_Params = t583
		typeRegistry.default:register(t1.RecordPartyChatConversationUpsellAcknowledgementAction_Params)

		local t587 = {}

		t587.__index = t587

		function t587.new(t588: {[any]: any}?) -- line: 27813
			-- upvalues: t1 (copy), t587 (copy)
			return (setmetatable({
				action_type = if t588 ~= nil and t588.action_type ~= nil then t588.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t588 ~= nil and t588.action_params ~= nil then t588.action_params else nil
			}, t587))
		end
		function t587.encode(p442) -- line: 27822
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n292 = 0

			if p442.action_type ~= nil and (p442.action_type ~= nil and p442.action_type ~= 0 or p442.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4380, v4381 = proto.writeTag(buf, n292, 1, proto.wireTypes.varint)

				buf, n292 = proto.writeVarInt(v4380, v4381, t1.ActionType.toNumber(p442.action_type))
			end

			if p442.action_params ~= nil then
				local v4382 = p442.action_params:encode()
				local v4383, v4384 = proto.writeTag(buf, n292, 2, proto.wireTypes.lengthDelimited)

				buf, n292 = proto.writeBuffer(v4383, v4384, v4382, buffer.len(v4382))
			end

			local buf149 = buffer.create(n292)

			buffer.copy(buf149, 0, buf, 0, n292)

			return buf149
		end
		function t587.decode(p443: buffer) -- line: 27848
			-- upvalues: t587 (copy), proto (copy), t1 (copy)
			local v4387 = t587.new()
			local n293 = 0

			while n293 < buffer.len(p443) do
				local v4389, v4390

				v4389, v4390, n293 = proto.readTag(p443, n293)

				if v4390 == proto.wireTypes.varint then
					if v4389 == 1 then
						local v4391

						v4391, n293 = proto.readVarIntI32(p443, n293)
						v4387.action_type = t1.ActionType.fromNumber(v4391) or v4391
					else
						local v4392

						v4392, n293 = proto.readVarInt(p443, n293)
					end
				elseif v4390 == proto.wireTypes.lengthDelimited then
					if v4389 == 2 then
						local v4393

						v4393, n293 = proto.readBuffer(p443, n293)
						v4387.action_params = t1.RequestFriendshipAction_Params.decode(v4393)
					else
						local v4394, v4395 = proto.readVarInt(p443, n293)

						n293 = v4395 + v4394
					end
				elseif v4390 == proto.wireTypes.i32 then
					local v4396

					v4396, n293 = proto.readFixed32(p443, n293)
				elseif v4390 == proto.wireTypes.i64 then
					local v4397

					v4397, n293 = proto.readFixed64(p443, n293)
				else
					error("Unsupported wire type: " .. v4390)
				end
			end

			return v4387
		end
		function t587.jsonEncode(p444) -- line: 27896
			-- upvalues: t1 (copy)
			local t589 = {}

			if p444.action_type ~= nil and (p444.action_type ~= nil and p444.action_type ~= 0 or p444.action_type ~= t1.ActionType.fromNumber(0)) then
				t589.actionType = if typeof(p444.action_type) ~= "number" then t1.ActionType.toNumber(p444.action_type) else p444.action_type
			end

			if p444.action_params ~= nil then
				t589.actionParams = p444.action_params:jsonEncode()
			end

			return t589
		end
		function t587.jsonDecode(t590: {[any]: any}) -- line: 27918
			-- upvalues: t587 (copy), t1 (copy)
			local v4401 = t587.new()

			if t590.action_type ~= nil then
				v4401.action_type = if typeof(t590.action_type) ~= "number" then t1.ActionType.fromName(t590.action_type) or t590.action_type else t1.ActionType.fromNumber(t590.action_type) or t590.action_type
			end

			if t590.actionType ~= nil then
				v4401.action_type = if typeof(t590.actionType) ~= "number" then t1.ActionType.fromName(t590.actionType) or t590.actionType else t1.ActionType.fromNumber(t590.actionType) or t590.actionType
			end

			if t590.action_params ~= nil then
				v4401.action_params = t1.RequestFriendshipAction_Params.jsonDecode(t590.action_params)
			end

			if t590.actionParams ~= nil then
				v4401.action_params = t1.RequestFriendshipAction_Params.jsonDecode(t590.actionParams)
			end

			return v4401
		end

		t587.descriptor = {
			name = "RequestFriendshipAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.RequestFriendshipAction"
		}
		t1.RequestFriendshipAction = t587
	end

	typeRegistry.default:register(t1.RequestFriendshipAction)

	do
		local t591 = {}

		t591.__index = t591

		function t591.new(t592: {[any]: any}?) -- line: 27958
			-- upvalues: t591 (copy)
			return (setmetatable({
				target_user_id = if t592 ~= nil and t592.target_user_id ~= nil then t592.target_user_id else nil,
				source = if t592 ~= nil and t592.source ~= nil then t592.source else nil
			}, t591))
		end
		function t591.encode(p445) -- line: 27967
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n294 = 0

			if p445.target_user_id ~= nil then
				local v4406 = p445.target_user_id:encode()
				local v4407, v4408 = proto.writeTag(buf, n294, 1, proto.wireTypes.lengthDelimited)

				buf, n294 = proto.writeBuffer(v4407, v4408, v4406, buffer.len(v4406))
			end

			if p445.source ~= nil then
				local v4409 = p445.source:encode()
				local v4410, v4411 = proto.writeTag(buf, n294, 2, proto.wireTypes.lengthDelimited)

				buf, n294 = proto.writeBuffer(v4410, v4411, v4409, buffer.len(v4409))
			end

			local buf150 = buffer.create(n294)

			buffer.copy(buf150, 0, buf, 0, n294)

			return buf150
		end
		function t591.decode(p446: buffer) -- line: 27988
			-- upvalues: t591 (copy), proto (copy), prop_types (copy)
			local v4414 = t591.new()
			local n295 = 0

			while n295 < buffer.len(p446) do
				local v4416, v4417

				v4416, v4417, n295 = proto.readTag(p446, n295)

				if v4417 == proto.wireTypes.varint then
					local v4418

					v4418, n295 = proto.readVarInt(p446, n295)
				elseif v4417 == proto.wireTypes.lengthDelimited then
					if v4416 == 1 then
						local v4419

						v4419, n295 = proto.readBuffer(p446, n295)
						v4414.target_user_id = prop_types.StringProp.decode(v4419)
					elseif v4416 == 2 then
						local v4420

						v4420, n295 = proto.readBuffer(p446, n295)
						v4414.source = prop_types.StringProp.decode(v4420)
					else
						local v4421, v4422 = proto.readVarInt(p446, n295)

						n295 = v4422 + v4421
					end
				elseif v4417 == proto.wireTypes.i32 then
					local v4423

					v4423, n295 = proto.readFixed32(p446, n295)
				elseif v4417 == proto.wireTypes.i64 then
					local v4424

					v4424, n295 = proto.readFixed64(p446, n295)
				else
					error("Unsupported wire type: " .. v4417)
				end
			end

			return v4414
		end
		function t591.jsonEncode(p447) -- line: 28036
			local t593 = {}

			if p447.target_user_id ~= nil then
				t593.targetUserId = p447.target_user_id:jsonEncode()
			end

			if p447.source ~= nil then
				t593.source = p447.source:jsonEncode()
			end

			return t593
		end
		function t591.jsonDecode(t594: {[any]: any}) -- line: 28050
			-- upvalues: t591 (copy), prop_types (copy)
			local v4428 = t591.new()

			if t594.target_user_id ~= nil then
				v4428.target_user_id = prop_types.StringProp.jsonDecode(t594.target_user_id)
			end

			if t594.targetUserId ~= nil then
				v4428.target_user_id = prop_types.StringProp.jsonDecode(t594.targetUserId)
			end

			if t594.source ~= nil then
				v4428.source = prop_types.StringProp.jsonDecode(t594.source)
			end

			return v4428
		end

		t591.descriptor = {
			name = "RequestFriendshipAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.RequestFriendshipAction_Params = t591
		typeRegistry.default:register(t1.RequestFriendshipAction_Params)

		local t595 = {}

		t595.__index = t595

		function t595.new(t596: {[any]: any}?) -- line: 28084
			-- upvalues: t1 (copy), t595 (copy)
			return (setmetatable({
				action_type = if t596 ~= nil and t596.action_type ~= nil then t596.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t596 ~= nil and t596.action_params ~= nil then t596.action_params else nil
			}, t595))
		end
		function t595.encode(p448) -- line: 28095
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n296 = 0

			if p448.action_type ~= nil and (p448.action_type ~= nil and p448.action_type ~= 0 or p448.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4433, v4434 = proto.writeTag(buf, n296, 1, proto.wireTypes.varint)

				buf, n296 = proto.writeVarInt(v4433, v4434, t1.ActionType.toNumber(p448.action_type))
			end

			if p448.action_params ~= nil then
				local v4435 = p448.action_params:encode()
				local v4436, v4437 = proto.writeTag(buf, n296, 2, proto.wireTypes.lengthDelimited)

				buf, n296 = proto.writeBuffer(v4436, v4437, v4435, buffer.len(v4435))
			end

			local buf151 = buffer.create(n296)

			buffer.copy(buf151, 0, buf, 0, n296)

			return buf151
		end
		function t595.decode(p449: buffer) -- line: 28121
			-- upvalues: t595 (copy), proto (copy), t1 (copy)
			local v4440 = t595.new()
			local n297 = 0

			while n297 < buffer.len(p449) do
				local v4442, v4443

				v4442, v4443, n297 = proto.readTag(p449, n297)

				if v4443 == proto.wireTypes.varint then
					if v4442 == 1 then
						local v4444

						v4444, n297 = proto.readVarIntI32(p449, n297)
						v4440.action_type = t1.ActionType.fromNumber(v4444) or v4444
					else
						local v4445

						v4445, n297 = proto.readVarInt(p449, n297)
					end
				elseif v4443 == proto.wireTypes.lengthDelimited then
					if v4442 == 2 then
						local v4446

						v4446, n297 = proto.readBuffer(p449, n297)
						v4440.action_params = t1.OpenTrustedFriendsUpsellModalAction_Params.decode(v4446)
					else
						local v4447, v4448 = proto.readVarInt(p449, n297)

						n297 = v4448 + v4447
					end
				elseif v4443 == proto.wireTypes.i32 then
					local v4449

					v4449, n297 = proto.readFixed32(p449, n297)
				elseif v4443 == proto.wireTypes.i64 then
					local v4450

					v4450, n297 = proto.readFixed64(p449, n297)
				else
					error("Unsupported wire type: " .. v4443)
				end
			end

			return v4440
		end
		function t595.jsonEncode(p450) -- line: 28169
			-- upvalues: t1 (copy)
			local t597 = {}

			if p450.action_type ~= nil and (p450.action_type ~= nil and p450.action_type ~= 0 or p450.action_type ~= t1.ActionType.fromNumber(0)) then
				t597.actionType = if typeof(p450.action_type) ~= "number" then t1.ActionType.toNumber(p450.action_type) else p450.action_type
			end

			if p450.action_params ~= nil then
				t597.actionParams = p450.action_params:jsonEncode()
			end

			return t597
		end
		function t595.jsonDecode(t598: {[any]: any}) -- line: 28191
			-- upvalues: t595 (copy), t1 (copy)
			local v4454 = t595.new()

			if t598.action_type ~= nil then
				v4454.action_type = if typeof(t598.action_type) ~= "number" then t1.ActionType.fromName(t598.action_type) or t598.action_type else t1.ActionType.fromNumber(t598.action_type) or t598.action_type
			end

			if t598.actionType ~= nil then
				v4454.action_type = if typeof(t598.actionType) ~= "number" then t1.ActionType.fromName(t598.actionType) or t598.actionType else t1.ActionType.fromNumber(t598.actionType) or t598.actionType
			end

			if t598.action_params ~= nil then
				v4454.action_params = t1.OpenTrustedFriendsUpsellModalAction_Params.jsonDecode(t598.action_params)
			end

			if t598.actionParams ~= nil then
				v4454.action_params = t1.OpenTrustedFriendsUpsellModalAction_Params.jsonDecode(t598.actionParams)
			end

			return v4454
		end

		t595.descriptor = {
			name = "OpenTrustedFriendsUpsellModalAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenTrustedFriendsUpsellModalAction"
		}
		t1.OpenTrustedFriendsUpsellModalAction = t595
	end

	typeRegistry.default:register(t1.OpenTrustedFriendsUpsellModalAction)

	do
		local t599 = {}

		t599.__index = t599

		function t599.new(t600: {[any]: any}?) -- line: 28233
			-- upvalues: t599 (copy)
			return (setmetatable({
				target_user_id = if t600 ~= nil and t600.target_user_id ~= nil then t600.target_user_id else nil
			}, t599))
		end
		function t599.encode(p451) -- line: 28241
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n298 = 0

			if p451.target_user_id ~= nil then
				local v4459 = p451.target_user_id:encode()
				local v4460, v4461 = proto.writeTag(buf, n298, 1, proto.wireTypes.lengthDelimited)

				buf, n298 = proto.writeBuffer(v4460, v4461, v4459, buffer.len(v4459))
			end

			local buf152 = buffer.create(n298)

			buffer.copy(buf152, 0, buf, 0, n298)

			return buf152
		end
		function t599.decode(p452: buffer) -- line: 28258
			-- upvalues: t599 (copy), proto (copy), prop_types (copy)
			local v4464 = t599.new()
			local n299 = 0

			while n299 < buffer.len(p452) do
				local v4466, v4467

				v4466, v4467, n299 = proto.readTag(p452, n299)

				if v4467 == proto.wireTypes.varint then
					local v4468

					v4468, n299 = proto.readVarInt(p452, n299)
				elseif v4467 == proto.wireTypes.lengthDelimited then
					if v4466 == 1 then
						local v4469

						v4469, n299 = proto.readBuffer(p452, n299)
						v4464.target_user_id = prop_types.StringProp.decode(v4469)
					else
						local v4470, v4471 = proto.readVarInt(p452, n299)

						n299 = v4471 + v4470
					end
				elseif v4467 == proto.wireTypes.i32 then
					local v4472

					v4472, n299 = proto.readFixed32(p452, n299)
				elseif v4467 == proto.wireTypes.i64 then
					local v4473

					v4473, n299 = proto.readFixed64(p452, n299)
				else
					error("Unsupported wire type: " .. v4467)
				end
			end

			return v4464
		end
		function t599.jsonEncode(p453) -- line: 28303
			local t601 = {}

			if p453.target_user_id ~= nil then
				t601.targetUserId = p453.target_user_id:jsonEncode()
			end

			return t601
		end
		function t599.jsonDecode(t602: {[any]: any}) -- line: 28315
			-- upvalues: t599 (copy), prop_types (copy)
			local v4477 = t599.new()

			if t602.target_user_id ~= nil then
				v4477.target_user_id = prop_types.StringProp.jsonDecode(t602.target_user_id)
			end

			if t602.targetUserId ~= nil then
				v4477.target_user_id = prop_types.StringProp.jsonDecode(t602.targetUserId)
			end

			return v4477
		end

		t599.descriptor = {
			name = "OpenTrustedFriendsUpsellModalAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenTrustedFriendsUpsellModalAction_Params = t599
		typeRegistry.default:register(t1.OpenTrustedFriendsUpsellModalAction_Params)

		local t603 = {}

		t603.__index = t603

		function t603.new(t604: {[any]: any}?) -- line: 28347
			-- upvalues: t1 (copy), t603 (copy)
			return (setmetatable({
				action_type = if t604 ~= nil and t604.action_type ~= nil then t604.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t604 ~= nil and t604.action_params ~= nil then t604.action_params else nil
			}, t603))
		end
		function t603.encode(p454) -- line: 28358
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n300 = 0

			if p454.action_type ~= nil and (p454.action_type ~= nil and p454.action_type ~= 0 or p454.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4482, v4483 = proto.writeTag(buf, n300, 1, proto.wireTypes.varint)

				buf, n300 = proto.writeVarInt(v4482, v4483, t1.ActionType.toNumber(p454.action_type))
			end

			if p454.action_params ~= nil then
				local v4484 = p454.action_params:encode()
				local v4485, v4486 = proto.writeTag(buf, n300, 2, proto.wireTypes.lengthDelimited)

				buf, n300 = proto.writeBuffer(v4485, v4486, v4484, buffer.len(v4484))
			end

			local buf153 = buffer.create(n300)

			buffer.copy(buf153, 0, buf, 0, n300)

			return buf153
		end
		function t603.decode(p455: buffer) -- line: 28384
			-- upvalues: t603 (copy), proto (copy), t1 (copy)
			local v4489 = t603.new()
			local n301 = 0

			while n301 < buffer.len(p455) do
				local v4491, v4492

				v4491, v4492, n301 = proto.readTag(p455, n301)

				if v4492 == proto.wireTypes.varint then
					if v4491 == 1 then
						local v4493

						v4493, n301 = proto.readVarIntI32(p455, n301)
						v4489.action_type = t1.ActionType.fromNumber(v4493) or v4493
					else
						local v4494

						v4494, n301 = proto.readVarInt(p455, n301)
					end
				elseif v4492 == proto.wireTypes.lengthDelimited then
					if v4491 == 2 then
						local v4495

						v4495, n301 = proto.readBuffer(p455, n301)
						v4489.action_params = t1.OpenSearchResultsWithQueryAction_Params.decode(v4495)
					else
						local v4496, v4497 = proto.readVarInt(p455, n301)

						n301 = v4497 + v4496
					end
				elseif v4492 == proto.wireTypes.i32 then
					local v4498

					v4498, n301 = proto.readFixed32(p455, n301)
				elseif v4492 == proto.wireTypes.i64 then
					local v4499

					v4499, n301 = proto.readFixed64(p455, n301)
				else
					error("Unsupported wire type: " .. v4492)
				end
			end

			return v4489
		end
		function t603.jsonEncode(p456) -- line: 28432
			-- upvalues: t1 (copy)
			local t605 = {}

			if p456.action_type ~= nil and (p456.action_type ~= nil and p456.action_type ~= 0 or p456.action_type ~= t1.ActionType.fromNumber(0)) then
				t605.actionType = if typeof(p456.action_type) ~= "number" then t1.ActionType.toNumber(p456.action_type) else p456.action_type
			end

			if p456.action_params ~= nil then
				t605.actionParams = p456.action_params:jsonEncode()
			end

			return t605
		end
		function t603.jsonDecode(t606: {[any]: any}) -- line: 28454
			-- upvalues: t603 (copy), t1 (copy)
			local v4503 = t603.new()

			if t606.action_type ~= nil then
				v4503.action_type = if typeof(t606.action_type) ~= "number" then t1.ActionType.fromName(t606.action_type) or t606.action_type else t1.ActionType.fromNumber(t606.action_type) or t606.action_type
			end

			if t606.actionType ~= nil then
				v4503.action_type = if typeof(t606.actionType) ~= "number" then t1.ActionType.fromName(t606.actionType) or t606.actionType else t1.ActionType.fromNumber(t606.actionType) or t606.actionType
			end

			if t606.action_params ~= nil then
				v4503.action_params = t1.OpenSearchResultsWithQueryAction_Params.jsonDecode(t606.action_params)
			end

			if t606.actionParams ~= nil then
				v4503.action_params = t1.OpenSearchResultsWithQueryAction_Params.jsonDecode(t606.actionParams)
			end

			return v4503
		end

		t603.descriptor = {
			name = "OpenSearchResultsWithQueryAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenSearchResultsWithQueryAction"
		}
		t1.OpenSearchResultsWithQueryAction = t603
	end

	typeRegistry.default:register(t1.OpenSearchResultsWithQueryAction)

	do
		local t607 = {}

		t607.__index = t607

		function t607.new(t608: {[any]: any}?) -- line: 28496
			-- upvalues: t607 (copy)
			return (setmetatable({
				search_query = if t608 ~= nil and t608.search_query ~= nil then t608.search_query else nil,
				search_type = if t608 ~= nil and t608.search_type ~= nil then t608.search_type else nil
			}, t607))
		end
		function t607.encode(p457) -- line: 28505
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n302 = 0

			if p457.search_query ~= nil then
				local v4508 = p457.search_query:encode()
				local v4509, v4510 = proto.writeTag(buf, n302, 1, proto.wireTypes.lengthDelimited)

				buf, n302 = proto.writeBuffer(v4509, v4510, v4508, buffer.len(v4508))
			end

			if p457.search_type ~= nil then
				local v4511 = p457.search_type:encode()
				local v4512, v4513 = proto.writeTag(buf, n302, 2, proto.wireTypes.lengthDelimited)

				buf, n302 = proto.writeBuffer(v4512, v4513, v4511, buffer.len(v4511))
			end

			local buf154 = buffer.create(n302)

			buffer.copy(buf154, 0, buf, 0, n302)

			return buf154
		end
		function t607.decode(p458: buffer) -- line: 28526
			-- upvalues: t607 (copy), proto (copy), prop_types (copy)
			local v4516 = t607.new()
			local n303 = 0

			while n303 < buffer.len(p458) do
				local v4518, v4519

				v4518, v4519, n303 = proto.readTag(p458, n303)

				if v4519 == proto.wireTypes.varint then
					local v4520

					v4520, n303 = proto.readVarInt(p458, n303)
				elseif v4519 == proto.wireTypes.lengthDelimited then
					if v4518 == 1 then
						local v4521

						v4521, n303 = proto.readBuffer(p458, n303)
						v4516.search_query = prop_types.StringProp.decode(v4521)
					elseif v4518 == 2 then
						local v4522

						v4522, n303 = proto.readBuffer(p458, n303)
						v4516.search_type = prop_types.StringProp.decode(v4522)
					else
						local v4523, v4524 = proto.readVarInt(p458, n303)

						n303 = v4524 + v4523
					end
				elseif v4519 == proto.wireTypes.i32 then
					local v4525

					v4525, n303 = proto.readFixed32(p458, n303)
				elseif v4519 == proto.wireTypes.i64 then
					local v4526

					v4526, n303 = proto.readFixed64(p458, n303)
				else
					error("Unsupported wire type: " .. v4519)
				end
			end

			return v4516
		end
		function t607.jsonEncode(p459) -- line: 28574
			local t609 = {}

			if p459.search_query ~= nil then
				t609.searchQuery = p459.search_query:jsonEncode()
			end

			if p459.search_type ~= nil then
				t609.searchType = p459.search_type:jsonEncode()
			end

			return t609
		end
		function t607.jsonDecode(t610: {[any]: any}) -- line: 28588
			-- upvalues: t607 (copy), prop_types (copy)
			local v4530 = t607.new()

			if t610.search_query ~= nil then
				v4530.search_query = prop_types.StringProp.jsonDecode(t610.search_query)
			end

			if t610.searchQuery ~= nil then
				v4530.search_query = prop_types.StringProp.jsonDecode(t610.searchQuery)
			end

			if t610.search_type ~= nil then
				v4530.search_type = prop_types.StringProp.jsonDecode(t610.search_type)
			end

			if t610.searchType ~= nil then
				v4530.search_type = prop_types.StringProp.jsonDecode(t610.searchType)
			end

			return v4530
		end

		t607.descriptor = {
			name = "OpenSearchResultsWithQueryAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenSearchResultsWithQueryAction_Params = t607
		typeRegistry.default:register(t1.OpenSearchResultsWithQueryAction_Params)

		local t611 = {}

		t611.__index = t611

		function t611.new(t612: {[any]: any}?) -- line: 28629
			-- upvalues: t1 (copy), t611 (copy)
			return (setmetatable({
				action_type = if t612 ~= nil and t612.action_type ~= nil then t612.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t612 ~= nil and t612.action_params ~= nil then t612.action_params else nil
			}, t611))
		end
		function t611.encode(p460) -- line: 28640
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n304 = 0

			if p460.action_type ~= nil and (p460.action_type ~= nil and p460.action_type ~= 0 or p460.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4535, v4536 = proto.writeTag(buf, n304, 1, proto.wireTypes.varint)

				buf, n304 = proto.writeVarInt(v4535, v4536, t1.ActionType.toNumber(p460.action_type))
			end

			if p460.action_params ~= nil then
				local v4537 = p460.action_params:encode()
				local v4538, v4539 = proto.writeTag(buf, n304, 2, proto.wireTypes.lengthDelimited)

				buf, n304 = proto.writeBuffer(v4538, v4539, v4537, buffer.len(v4537))
			end

			local buf155 = buffer.create(n304)

			buffer.copy(buf155, 0, buf, 0, n304)

			return buf155
		end
		function t611.decode(p461: buffer) -- line: 28666
			-- upvalues: t611 (copy), proto (copy), t1 (copy)
			local v4542 = t611.new()
			local n305 = 0

			while n305 < buffer.len(p461) do
				local v4544, v4545

				v4544, v4545, n305 = proto.readTag(p461, n305)

				if v4545 == proto.wireTypes.varint then
					if v4544 == 1 then
						local v4546

						v4546, n305 = proto.readVarIntI32(p461, n305)
						v4542.action_type = t1.ActionType.fromNumber(v4546) or v4546
					else
						local v4547

						v4547, n305 = proto.readVarInt(p461, n305)
					end
				elseif v4545 == proto.wireTypes.lengthDelimited then
					if v4544 == 2 then
						local v4548

						v4548, n305 = proto.readBuffer(p461, n305)
						v4542.action_params = t1.SelectMarketplaceFavoritesCategory_Params.decode(v4548)
					else
						local v4549, v4550 = proto.readVarInt(p461, n305)

						n305 = v4550 + v4549
					end
				elseif v4545 == proto.wireTypes.i32 then
					local v4551

					v4551, n305 = proto.readFixed32(p461, n305)
				elseif v4545 == proto.wireTypes.i64 then
					local v4552

					v4552, n305 = proto.readFixed64(p461, n305)
				else
					error("Unsupported wire type: " .. v4545)
				end
			end

			return v4542
		end
		function t611.jsonEncode(p462) -- line: 28714
			-- upvalues: t1 (copy)
			local t613 = {}

			if p462.action_type ~= nil and (p462.action_type ~= nil and p462.action_type ~= 0 or p462.action_type ~= t1.ActionType.fromNumber(0)) then
				t613.actionType = if typeof(p462.action_type) ~= "number" then t1.ActionType.toNumber(p462.action_type) else p462.action_type
			end

			if p462.action_params ~= nil then
				t613.actionParams = p462.action_params:jsonEncode()
			end

			return t613
		end
		function t611.jsonDecode(t614: {[any]: any}) -- line: 28736
			-- upvalues: t611 (copy), t1 (copy)
			local v4556 = t611.new()

			if t614.action_type ~= nil then
				v4556.action_type = if typeof(t614.action_type) ~= "number" then t1.ActionType.fromName(t614.action_type) or t614.action_type else t1.ActionType.fromNumber(t614.action_type) or t614.action_type
			end

			if t614.actionType ~= nil then
				v4556.action_type = if typeof(t614.actionType) ~= "number" then t1.ActionType.fromName(t614.actionType) or t614.actionType else t1.ActionType.fromNumber(t614.actionType) or t614.actionType
			end

			if t614.action_params ~= nil then
				v4556.action_params = t1.SelectMarketplaceFavoritesCategory_Params.jsonDecode(t614.action_params)
			end

			if t614.actionParams ~= nil then
				v4556.action_params = t1.SelectMarketplaceFavoritesCategory_Params.jsonDecode(t614.actionParams)
			end

			return v4556
		end

		t611.descriptor = {
			name = "SelectMarketplaceFavoritesCategory",
			fullName = "roblox.apppageplatform.shared.v1beta1.SelectMarketplaceFavoritesCategory"
		}
		t1.SelectMarketplaceFavoritesCategory = t611
	end

	typeRegistry.default:register(t1.SelectMarketplaceFavoritesCategory)

	do
		local t615 = {}

		t615.__index = t615

		function t615.new(t616: {[any]: any}?) -- line: 28778
			-- upvalues: t615 (copy)
			return (setmetatable({
				category_id = if t616 ~= nil and t616.category_id ~= nil then t616.category_id else nil
			}, t615))
		end
		function t615.encode(p463) -- line: 28786
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n306 = 0

			if p463.category_id ~= nil then
				local v4561 = p463.category_id:encode()
				local v4562, v4563 = proto.writeTag(buf, n306, 1, proto.wireTypes.lengthDelimited)

				buf, n306 = proto.writeBuffer(v4562, v4563, v4561, buffer.len(v4561))
			end

			local buf156 = buffer.create(n306)

			buffer.copy(buf156, 0, buf, 0, n306)

			return buf156
		end
		function t615.decode(p464: buffer) -- line: 28803
			-- upvalues: t615 (copy), proto (copy), prop_types (copy)
			local v4566 = t615.new()
			local n307 = 0

			while n307 < buffer.len(p464) do
				local v4568, v4569

				v4568, v4569, n307 = proto.readTag(p464, n307)

				if v4569 == proto.wireTypes.varint then
					local v4570

					v4570, n307 = proto.readVarInt(p464, n307)
				elseif v4569 == proto.wireTypes.lengthDelimited then
					if v4568 == 1 then
						local v4571

						v4571, n307 = proto.readBuffer(p464, n307)
						v4566.category_id = prop_types.StringProp.decode(v4571)
					else
						local v4572, v4573 = proto.readVarInt(p464, n307)

						n307 = v4573 + v4572
					end
				elseif v4569 == proto.wireTypes.i32 then
					local v4574

					v4574, n307 = proto.readFixed32(p464, n307)
				elseif v4569 == proto.wireTypes.i64 then
					local v4575

					v4575, n307 = proto.readFixed64(p464, n307)
				else
					error("Unsupported wire type: " .. v4569)
				end
			end

			return v4566
		end
		function t615.jsonEncode(p465) -- line: 28848
			local t617 = {}

			if p465.category_id ~= nil then
				t617.categoryId = p465.category_id:jsonEncode()
			end

			return t617
		end
		function t615.jsonDecode(t618: {[any]: any}) -- line: 28860
			-- upvalues: t615 (copy), prop_types (copy)
			local v4579 = t615.new()

			if t618.category_id ~= nil then
				v4579.category_id = prop_types.StringProp.jsonDecode(t618.category_id)
			end

			if t618.categoryId ~= nil then
				v4579.category_id = prop_types.StringProp.jsonDecode(t618.categoryId)
			end

			return v4579
		end

		t615.descriptor = {
			name = "SelectMarketplaceFavoritesCategory_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.SelectMarketplaceFavoritesCategory_Params = t615
		typeRegistry.default:register(t1.SelectMarketplaceFavoritesCategory_Params)

		local t619 = {}

		t619.__index = t619

		function t619.new(t620: {[any]: any}?) -- line: 28891
			-- upvalues: t1 (copy), t619 (copy)
			return (setmetatable({
				action_type = if t620 ~= nil and t620.action_type ~= nil then t620.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t620 ~= nil and t620.action_params ~= nil then t620.action_params else nil
			}, t619))
		end
		function t619.encode(p466) -- line: 28902
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n308 = 0

			if p466.action_type ~= nil and (p466.action_type ~= nil and p466.action_type ~= 0 or p466.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4584, v4585 = proto.writeTag(buf, n308, 1, proto.wireTypes.varint)

				buf, n308 = proto.writeVarInt(v4584, v4585, t1.ActionType.toNumber(p466.action_type))
			end

			if p466.action_params ~= nil then
				local v4586 = p466.action_params:encode()
				local v4587, v4588 = proto.writeTag(buf, n308, 2, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4587, v4588, v4586, buffer.len(v4586))
			end

			local buf157 = buffer.create(n308)

			buffer.copy(buf157, 0, buf, 0, n308)

			return buf157
		end
		function t619.decode(p467: buffer) -- line: 28928
			-- upvalues: t619 (copy), proto (copy), t1 (copy)
			local v4591 = t619.new()
			local n309 = 0

			while n309 < buffer.len(p467) do
				local v4593, v4594

				v4593, v4594, n309 = proto.readTag(p467, n309)

				if v4594 == proto.wireTypes.varint then
					if v4593 == 1 then
						local v4595

						v4595, n309 = proto.readVarIntI32(p467, n309)
						v4591.action_type = t1.ActionType.fromNumber(v4595) or v4595
					else
						local v4596

						v4596, n309 = proto.readVarInt(p467, n309)
					end
				elseif v4594 == proto.wireTypes.lengthDelimited then
					if v4593 == 2 then
						local v4597

						v4597, n309 = proto.readBuffer(p467, n309)
						v4591.action_params = t1.SelectMarketplaceFavoritesSubcategory_Params.decode(v4597)
					else
						local v4598, v4599 = proto.readVarInt(p467, n309)

						n309 = v4599 + v4598
					end
				elseif v4594 == proto.wireTypes.i32 then
					local v4600

					v4600, n309 = proto.readFixed32(p467, n309)
				elseif v4594 == proto.wireTypes.i64 then
					local v4601

					v4601, n309 = proto.readFixed64(p467, n309)
				else
					error("Unsupported wire type: " .. v4594)
				end
			end

			return v4591
		end
		function t619.jsonEncode(p468) -- line: 28976
			-- upvalues: t1 (copy)
			local t621 = {}

			if p468.action_type ~= nil and (p468.action_type ~= nil and p468.action_type ~= 0 or p468.action_type ~= t1.ActionType.fromNumber(0)) then
				t621.actionType = if typeof(p468.action_type) ~= "number" then t1.ActionType.toNumber(p468.action_type) else p468.action_type
			end

			if p468.action_params ~= nil then
				t621.actionParams = p468.action_params:jsonEncode()
			end

			return t621
		end
		function t619.jsonDecode(t622: {[any]: any}) -- line: 28998
			-- upvalues: t619 (copy), t1 (copy)
			local v4605 = t619.new()

			if t622.action_type ~= nil then
				v4605.action_type = if typeof(t622.action_type) ~= "number" then t1.ActionType.fromName(t622.action_type) or t622.action_type else t1.ActionType.fromNumber(t622.action_type) or t622.action_type
			end

			if t622.actionType ~= nil then
				v4605.action_type = if typeof(t622.actionType) ~= "number" then t1.ActionType.fromName(t622.actionType) or t622.actionType else t1.ActionType.fromNumber(t622.actionType) or t622.actionType
			end

			if t622.action_params ~= nil then
				v4605.action_params = t1.SelectMarketplaceFavoritesSubcategory_Params.jsonDecode(t622.action_params)
			end

			if t622.actionParams ~= nil then
				v4605.action_params = t1.SelectMarketplaceFavoritesSubcategory_Params.jsonDecode(t622.actionParams)
			end

			return v4605
		end

		t619.descriptor = {
			name = "SelectMarketplaceFavoritesSubcategory",
			fullName = "roblox.apppageplatform.shared.v1beta1.SelectMarketplaceFavoritesSubcategory"
		}
		t1.SelectMarketplaceFavoritesSubcategory = t619
	end

	typeRegistry.default:register(t1.SelectMarketplaceFavoritesSubcategory)

	do
		local t623 = {}

		t623.__index = t623

		function t623.new(t624: {[any]: any}?) -- line: 29040
			-- upvalues: t623 (copy)
			return (setmetatable({
				subcategory_id = if t624 ~= nil and t624.subcategory_id ~= nil then t624.subcategory_id else nil
			}, t623))
		end
		function t623.encode(p469) -- line: 29048
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n310 = 0

			if p469.subcategory_id ~= nil then
				local v4610 = p469.subcategory_id:encode()
				local v4611, v4612 = proto.writeTag(buf, n310, 1, proto.wireTypes.lengthDelimited)

				buf, n310 = proto.writeBuffer(v4611, v4612, v4610, buffer.len(v4610))
			end

			local buf158 = buffer.create(n310)

			buffer.copy(buf158, 0, buf, 0, n310)

			return buf158
		end
		function t623.decode(p470: buffer) -- line: 29065
			-- upvalues: t623 (copy), proto (copy), prop_types (copy)
			local v4615 = t623.new()
			local n311 = 0

			while n311 < buffer.len(p470) do
				local v4617, v4618

				v4617, v4618, n311 = proto.readTag(p470, n311)

				if v4618 == proto.wireTypes.varint then
					local v4619

					v4619, n311 = proto.readVarInt(p470, n311)
				elseif v4618 == proto.wireTypes.lengthDelimited then
					if v4617 == 1 then
						local v4620

						v4620, n311 = proto.readBuffer(p470, n311)
						v4615.subcategory_id = prop_types.StringProp.decode(v4620)
					else
						local v4621, v4622 = proto.readVarInt(p470, n311)

						n311 = v4622 + v4621
					end
				elseif v4618 == proto.wireTypes.i32 then
					local v4623

					v4623, n311 = proto.readFixed32(p470, n311)
				elseif v4618 == proto.wireTypes.i64 then
					local v4624

					v4624, n311 = proto.readFixed64(p470, n311)
				else
					error("Unsupported wire type: " .. v4618)
				end
			end

			return v4615
		end
		function t623.jsonEncode(p471) -- line: 29110
			local t625 = {}

			if p471.subcategory_id ~= nil then
				t625.subcategoryId = p471.subcategory_id:jsonEncode()
			end

			return t625
		end
		function t623.jsonDecode(t626: {[any]: any}) -- line: 29122
			-- upvalues: t623 (copy), prop_types (copy)
			local v4628 = t623.new()

			if t626.subcategory_id ~= nil then
				v4628.subcategory_id = prop_types.StringProp.jsonDecode(t626.subcategory_id)
			end

			if t626.subcategoryId ~= nil then
				v4628.subcategory_id = prop_types.StringProp.jsonDecode(t626.subcategoryId)
			end

			return v4628
		end

		t623.descriptor = {
			name = "SelectMarketplaceFavoritesSubcategory_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.SelectMarketplaceFavoritesSubcategory_Params = t623
		typeRegistry.default:register(t1.SelectMarketplaceFavoritesSubcategory_Params)

		local t627 = {}

		t627.__index = t627

		function t627.new(t628: {[any]: any}?) -- line: 29154
			-- upvalues: t1 (copy), t627 (copy)
			return (setmetatable({
				action_type = if t628 ~= nil and t628.action_type ~= nil then t628.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t628 ~= nil and t628.action_params ~= nil then t628.action_params else nil
			}, t627))
		end
		function t627.encode(p472) -- line: 29165
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n312 = 0

			if p472.action_type ~= nil and (p472.action_type ~= nil and p472.action_type ~= 0 or p472.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4633, v4634 = proto.writeTag(buf, n312, 1, proto.wireTypes.varint)

				buf, n312 = proto.writeVarInt(v4633, v4634, t1.ActionType.toNumber(p472.action_type))
			end

			if p472.action_params ~= nil then
				local v4635 = p472.action_params:encode()
				local v4636, v4637 = proto.writeTag(buf, n312, 2, proto.wireTypes.lengthDelimited)

				buf, n312 = proto.writeBuffer(v4636, v4637, v4635, buffer.len(v4635))
			end

			local buf159 = buffer.create(n312)

			buffer.copy(buf159, 0, buf, 0, n312)

			return buf159
		end
		function t627.decode(p473: buffer) -- line: 29191
			-- upvalues: t627 (copy), proto (copy), t1 (copy)
			local v4640 = t627.new()
			local n313 = 0

			while n313 < buffer.len(p473) do
				local v4642, v4643

				v4642, v4643, n313 = proto.readTag(p473, n313)

				if v4643 == proto.wireTypes.varint then
					if v4642 == 1 then
						local v4644

						v4644, n313 = proto.readVarIntI32(p473, n313)
						v4640.action_type = t1.ActionType.fromNumber(v4644) or v4644
					else
						local v4645

						v4645, n313 = proto.readVarInt(p473, n313)
					end
				elseif v4643 == proto.wireTypes.lengthDelimited then
					if v4642 == 2 then
						local v4646

						v4646, n313 = proto.readBuffer(p473, n313)
						v4640.action_params = t1.PinExperienceShortcutAction_Params.decode(v4646)
					else
						local v4647, v4648 = proto.readVarInt(p473, n313)

						n313 = v4648 + v4647
					end
				elseif v4643 == proto.wireTypes.i32 then
					local v4649

					v4649, n313 = proto.readFixed32(p473, n313)
				elseif v4643 == proto.wireTypes.i64 then
					local v4650

					v4650, n313 = proto.readFixed64(p473, n313)
				else
					error("Unsupported wire type: " .. v4643)
				end
			end

			return v4640
		end
		function t627.jsonEncode(p474) -- line: 29239
			-- upvalues: t1 (copy)
			local t629 = {}

			if p474.action_type ~= nil and (p474.action_type ~= nil and p474.action_type ~= 0 or p474.action_type ~= t1.ActionType.fromNumber(0)) then
				t629.actionType = if typeof(p474.action_type) ~= "number" then t1.ActionType.toNumber(p474.action_type) else p474.action_type
			end

			if p474.action_params ~= nil then
				t629.actionParams = p474.action_params:jsonEncode()
			end

			return t629
		end
		function t627.jsonDecode(t630: {[any]: any}) -- line: 29261
			-- upvalues: t627 (copy), t1 (copy)
			local v4654 = t627.new()

			if t630.action_type ~= nil then
				v4654.action_type = if typeof(t630.action_type) ~= "number" then t1.ActionType.fromName(t630.action_type) or t630.action_type else t1.ActionType.fromNumber(t630.action_type) or t630.action_type
			end

			if t630.actionType ~= nil then
				v4654.action_type = if typeof(t630.actionType) ~= "number" then t1.ActionType.fromName(t630.actionType) or t630.actionType else t1.ActionType.fromNumber(t630.actionType) or t630.actionType
			end

			if t630.action_params ~= nil then
				v4654.action_params = t1.PinExperienceShortcutAction_Params.jsonDecode(t630.action_params)
			end

			if t630.actionParams ~= nil then
				v4654.action_params = t1.PinExperienceShortcutAction_Params.jsonDecode(t630.actionParams)
			end

			return v4654
		end

		t627.descriptor = {
			name = "PinExperienceShortcutAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.PinExperienceShortcutAction"
		}
		t1.PinExperienceShortcutAction = t627
	end

	typeRegistry.default:register(t1.PinExperienceShortcutAction)

	do
		local t631 = {}

		t631.__index = t631

		function t631.new(t632: {[any]: any}?) -- line: 29301
			-- upvalues: t631 (copy)
			return (setmetatable({
				place_id = if t632 ~= nil and t632.place_id ~= nil then t632.place_id else nil,
				universe_id = if t632 ~= nil and t632.universe_id ~= nil then t632.universe_id else nil,
				game_name = if t632 ~= nil and t632.game_name ~= nil then t632.game_name else nil
			}, t631))
		end
		function t631.encode(p475) -- line: 29311
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n314 = 0

			if p475.place_id ~= nil then
				local v4659 = p475.place_id:encode()
				local v4660, v4661 = proto.writeTag(buf, n314, 1, proto.wireTypes.lengthDelimited)

				buf, n314 = proto.writeBuffer(v4660, v4661, v4659, buffer.len(v4659))
			end

			if p475.universe_id ~= nil then
				local v4662 = p475.universe_id:encode()
				local v4663, v4664 = proto.writeTag(buf, n314, 2, proto.wireTypes.lengthDelimited)

				buf, n314 = proto.writeBuffer(v4663, v4664, v4662, buffer.len(v4662))
			end

			if p475.game_name ~= nil then
				local v4665 = p475.game_name:encode()
				local v4666, v4667 = proto.writeTag(buf, n314, 3, proto.wireTypes.lengthDelimited)

				buf, n314 = proto.writeBuffer(v4666, v4667, v4665, buffer.len(v4665))
			end

			local buf160 = buffer.create(n314)

			buffer.copy(buf160, 0, buf, 0, n314)

			return buf160
		end
		function t631.decode(p476: buffer) -- line: 29338
			-- upvalues: t631 (copy), proto (copy), prop_types (copy)
			local v4670 = t631.new()
			local n315 = 0

			while n315 < buffer.len(p476) do
				local v4672, v4673

				v4672, v4673, n315 = proto.readTag(p476, n315)

				if v4673 == proto.wireTypes.varint then
					local v4674

					v4674, n315 = proto.readVarInt(p476, n315)
				elseif v4673 == proto.wireTypes.lengthDelimited then
					if v4672 == 1 then
						local v4675

						v4675, n315 = proto.readBuffer(p476, n315)
						v4670.place_id = prop_types.StringProp.decode(v4675)
					elseif v4672 == 2 then
						local v4676

						v4676, n315 = proto.readBuffer(p476, n315)
						v4670.universe_id = prop_types.StringProp.decode(v4676)
					elseif v4672 == 3 then
						local v4677

						v4677, n315 = proto.readBuffer(p476, n315)
						v4670.game_name = prop_types.StringProp.decode(v4677)
					else
						local v4678, v4679 = proto.readVarInt(p476, n315)

						n315 = v4679 + v4678
					end
				elseif v4673 == proto.wireTypes.i32 then
					local v4680

					v4680, n315 = proto.readFixed32(p476, n315)
				elseif v4673 == proto.wireTypes.i64 then
					local v4681

					v4681, n315 = proto.readFixed64(p476, n315)
				else
					error("Unsupported wire type: " .. v4673)
				end
			end

			return v4670
		end
		function t631.jsonEncode(p477) -- line: 29391
			local t633 = {}

			if p477.place_id ~= nil then
				t633.placeId = p477.place_id:jsonEncode()
			end

			if p477.universe_id ~= nil then
				t633.universeId = p477.universe_id:jsonEncode()
			end

			if p477.game_name ~= nil then
				t633.gameName = p477.game_name:jsonEncode()
			end

			return t633
		end
		function t631.jsonDecode(t634: {[any]: any}) -- line: 29409
			-- upvalues: t631 (copy), prop_types (copy)
			local v4685 = t631.new()

			if t634.place_id ~= nil then
				v4685.place_id = prop_types.StringProp.jsonDecode(t634.place_id)
			end

			if t634.placeId ~= nil then
				v4685.place_id = prop_types.StringProp.jsonDecode(t634.placeId)
			end

			if t634.universe_id ~= nil then
				v4685.universe_id = prop_types.StringProp.jsonDecode(t634.universe_id)
			end

			if t634.universeId ~= nil then
				v4685.universe_id = prop_types.StringProp.jsonDecode(t634.universeId)
			end

			if t634.game_name ~= nil then
				v4685.game_name = prop_types.StringProp.jsonDecode(t634.game_name)
			end

			if t634.gameName ~= nil then
				v4685.game_name = prop_types.StringProp.jsonDecode(t634.gameName)
			end

			return v4685
		end

		t631.descriptor = {
			name = "PinExperienceShortcutAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.PinExperienceShortcutAction_Params = t631
		typeRegistry.default:register(t1.PinExperienceShortcutAction_Params)

		local t635 = {}

		t635.__index = t635

		function t635.new(t636: {[any]: any}?) -- line: 29456
			-- upvalues: t1 (copy), t635 (copy)
			return (setmetatable({
				action_type = if t636 ~= nil and t636.action_type ~= nil then t636.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t636 ~= nil and t636.action_params ~= nil then t636.action_params else nil
			}, t635))
		end
		function t635.encode(p478) -- line: 29465
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n316 = 0

			if p478.action_type ~= nil and (p478.action_type ~= nil and p478.action_type ~= 0 or p478.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4690, v4691 = proto.writeTag(buf, n316, 1, proto.wireTypes.varint)

				buf, n316 = proto.writeVarInt(v4690, v4691, t1.ActionType.toNumber(p478.action_type))
			end

			if p478.action_params ~= nil then
				local v4692 = p478.action_params:encode()
				local v4693, v4694 = proto.writeTag(buf, n316, 2, proto.wireTypes.lengthDelimited)

				buf, n316 = proto.writeBuffer(v4693, v4694, v4692, buffer.len(v4692))
			end

			local buf161 = buffer.create(n316)

			buffer.copy(buf161, 0, buf, 0, n316)

			return buf161
		end
		function t635.decode(p479: buffer) -- line: 29491
			-- upvalues: t635 (copy), proto (copy), t1 (copy)
			local v4697 = t635.new()
			local n317 = 0

			while n317 < buffer.len(p479) do
				local v4699, v4700

				v4699, v4700, n317 = proto.readTag(p479, n317)

				if v4700 == proto.wireTypes.varint then
					if v4699 == 1 then
						local v4701

						v4701, n317 = proto.readVarIntI32(p479, n317)
						v4697.action_type = t1.ActionType.fromNumber(v4701) or v4701
					else
						local v4702

						v4702, n317 = proto.readVarInt(p479, n317)
					end
				elseif v4700 == proto.wireTypes.lengthDelimited then
					if v4699 == 2 then
						local v4703

						v4703, n317 = proto.readBuffer(p479, n317)
						v4697.action_params = t1.DownloadAppAction_Params.decode(v4703)
					else
						local v4704, v4705 = proto.readVarInt(p479, n317)

						n317 = v4705 + v4704
					end
				elseif v4700 == proto.wireTypes.i32 then
					local v4706

					v4706, n317 = proto.readFixed32(p479, n317)
				elseif v4700 == proto.wireTypes.i64 then
					local v4707

					v4707, n317 = proto.readFixed64(p479, n317)
				else
					error("Unsupported wire type: " .. v4700)
				end
			end

			return v4697
		end
		function t635.jsonEncode(p480) -- line: 29539
			-- upvalues: t1 (copy)
			local t637 = {}

			if p480.action_type ~= nil and (p480.action_type ~= nil and p480.action_type ~= 0 or p480.action_type ~= t1.ActionType.fromNumber(0)) then
				t637.actionType = if typeof(p480.action_type) ~= "number" then t1.ActionType.toNumber(p480.action_type) else p480.action_type
			end

			if p480.action_params ~= nil then
				t637.actionParams = p480.action_params:jsonEncode()
			end

			return t637
		end
		function t635.jsonDecode(t638: {[any]: any}) -- line: 29561
			-- upvalues: t635 (copy), t1 (copy)
			local v4711 = t635.new()

			if t638.action_type ~= nil then
				v4711.action_type = if typeof(t638.action_type) ~= "number" then t1.ActionType.fromName(t638.action_type) or t638.action_type else t1.ActionType.fromNumber(t638.action_type) or t638.action_type
			end

			if t638.actionType ~= nil then
				v4711.action_type = if typeof(t638.actionType) ~= "number" then t1.ActionType.fromName(t638.actionType) or t638.actionType else t1.ActionType.fromNumber(t638.actionType) or t638.actionType
			end

			if t638.action_params ~= nil then
				v4711.action_params = t1.DownloadAppAction_Params.jsonDecode(t638.action_params)
			end

			if t638.actionParams ~= nil then
				v4711.action_params = t1.DownloadAppAction_Params.jsonDecode(t638.actionParams)
			end

			return v4711
		end

		t635.descriptor = {
			name = "DownloadAppAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.DownloadAppAction"
		}
		t1.DownloadAppAction = t635
	end

	typeRegistry.default:register(t1.DownloadAppAction)

	do
		local t639 = {}

		t639.__index = t639

		function t639.new(t640: {[any]: any}?) -- line: 29601
			-- upvalues: t639 (copy)
			return (setmetatable({
				source = if t640 ~= nil and t640.source ~= nil then t640.source else nil,
				download_type = if t640 ~= nil and t640.download_type ~= nil then t640.download_type else nil
			}, t639))
		end
		function t639.encode(p481) -- line: 29608
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n318 = 0

			if p481.source ~= nil then
				local v4716 = p481.source:encode()
				local v4717, v4718 = proto.writeTag(buf, n318, 1, proto.wireTypes.lengthDelimited)

				buf, n318 = proto.writeBuffer(v4717, v4718, v4716, buffer.len(v4716))
			end

			if p481.download_type ~= nil then
				local v4719 = p481.download_type:encode()
				local v4720, v4721 = proto.writeTag(buf, n318, 2, proto.wireTypes.lengthDelimited)

				buf, n318 = proto.writeBuffer(v4720, v4721, v4719, buffer.len(v4719))
			end

			local buf162 = buffer.create(n318)

			buffer.copy(buf162, 0, buf, 0, n318)

			return buf162
		end
		function t639.decode(p482: buffer) -- line: 29629
			-- upvalues: t639 (copy), proto (copy), prop_types (copy)
			local v4724 = t639.new()
			local n319 = 0

			while n319 < buffer.len(p482) do
				local v4726, v4727

				v4726, v4727, n319 = proto.readTag(p482, n319)

				if v4727 == proto.wireTypes.varint then
					local v4728

					v4728, n319 = proto.readVarInt(p482, n319)
				elseif v4727 == proto.wireTypes.lengthDelimited then
					if v4726 == 1 then
						local v4729

						v4729, n319 = proto.readBuffer(p482, n319)
						v4724.source = prop_types.StringProp.decode(v4729)
					elseif v4726 == 2 then
						local v4730

						v4730, n319 = proto.readBuffer(p482, n319)
						v4724.download_type = prop_types.StringProp.decode(v4730)
					else
						local v4731, v4732 = proto.readVarInt(p482, n319)

						n319 = v4732 + v4731
					end
				elseif v4727 == proto.wireTypes.i32 then
					local v4733

					v4733, n319 = proto.readFixed32(p482, n319)
				elseif v4727 == proto.wireTypes.i64 then
					local v4734

					v4734, n319 = proto.readFixed64(p482, n319)
				else
					error("Unsupported wire type: " .. v4727)
				end
			end

			return v4724
		end
		function t639.jsonEncode(p483) -- line: 29677
			local t641 = {}

			if p483.source ~= nil then
				t641.source = p483.source:jsonEncode()
			end

			if p483.download_type ~= nil then
				t641.downloadType = p483.download_type:jsonEncode()
			end

			return t641
		end
		function t639.jsonDecode(t642: {[any]: any}) -- line: 29691
			-- upvalues: t639 (copy), prop_types (copy)
			local v4738 = t639.new()

			if t642.source ~= nil then
				v4738.source = prop_types.StringProp.jsonDecode(t642.source)
			end

			if t642.download_type ~= nil then
				v4738.download_type = prop_types.StringProp.jsonDecode(t642.download_type)
			end

			if t642.downloadType ~= nil then
				v4738.download_type = prop_types.StringProp.jsonDecode(t642.downloadType)
			end

			return v4738
		end

		t639.descriptor = {
			name = "DownloadAppAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.DownloadAppAction_Params = t639
		typeRegistry.default:register(t1.DownloadAppAction_Params)

		local t643 = {}

		t643.__index = t643

		function t643.new(t644: {[any]: any}?) -- line: 29725
			-- upvalues: t1 (copy), t643 (copy)
			return (setmetatable({
				action_type = if t644 ~= nil and t644.action_type ~= nil then t644.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t644 ~= nil and t644.action_params ~= nil then t644.action_params else nil
			}, t643))
		end
		function t643.encode(p484) -- line: 29734
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n320 = 0

			if p484.action_type ~= nil and (p484.action_type ~= nil and p484.action_type ~= 0 or p484.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4743, v4744 = proto.writeTag(buf, n320, 1, proto.wireTypes.varint)

				buf, n320 = proto.writeVarInt(v4743, v4744, t1.ActionType.toNumber(p484.action_type))
			end

			if p484.action_params ~= nil then
				local v4745 = p484.action_params:encode()
				local v4746, v4747 = proto.writeTag(buf, n320, 2, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4746, v4747, v4745, buffer.len(v4745))
			end

			local buf163 = buffer.create(n320)

			buffer.copy(buf163, 0, buf, 0, n320)

			return buf163
		end
		function t643.decode(p485: buffer) -- line: 29760
			-- upvalues: t643 (copy), proto (copy), t1 (copy)
			local v4750 = t643.new()
			local n321 = 0

			while n321 < buffer.len(p485) do
				local v4752, v4753

				v4752, v4753, n321 = proto.readTag(p485, n321)

				if v4753 == proto.wireTypes.varint then
					if v4752 == 1 then
						local v4754

						v4754, n321 = proto.readVarIntI32(p485, n321)
						v4750.action_type = t1.ActionType.fromNumber(v4754) or v4754
					else
						local v4755

						v4755, n321 = proto.readVarInt(p485, n321)
					end
				elseif v4753 == proto.wireTypes.lengthDelimited then
					if v4752 == 2 then
						local v4756

						v4756, n321 = proto.readBuffer(p485, n321)
						v4750.action_params = t1.ActionSequenceAction_Params.decode(v4756)
					else
						local v4757, v4758 = proto.readVarInt(p485, n321)

						n321 = v4758 + v4757
					end
				elseif v4753 == proto.wireTypes.i32 then
					local v4759

					v4759, n321 = proto.readFixed32(p485, n321)
				elseif v4753 == proto.wireTypes.i64 then
					local v4760

					v4760, n321 = proto.readFixed64(p485, n321)
				else
					error("Unsupported wire type: " .. v4753)
				end
			end

			return v4750
		end
		function t643.jsonEncode(p486) -- line: 29808
			-- upvalues: t1 (copy)
			local t645 = {}

			if p486.action_type ~= nil and (p486.action_type ~= nil and p486.action_type ~= 0 or p486.action_type ~= t1.ActionType.fromNumber(0)) then
				t645.actionType = if typeof(p486.action_type) ~= "number" then t1.ActionType.toNumber(p486.action_type) else p486.action_type
			end

			if p486.action_params ~= nil then
				t645.actionParams = p486.action_params:jsonEncode()
			end

			return t645
		end
		function t643.jsonDecode(t646: {[any]: any}) -- line: 29830
			-- upvalues: t643 (copy), t1 (copy)
			local v4764 = t643.new()

			if t646.action_type ~= nil then
				v4764.action_type = if typeof(t646.action_type) ~= "number" then t1.ActionType.fromName(t646.action_type) or t646.action_type else t1.ActionType.fromNumber(t646.action_type) or t646.action_type
			end

			if t646.actionType ~= nil then
				v4764.action_type = if typeof(t646.actionType) ~= "number" then t1.ActionType.fromName(t646.actionType) or t646.actionType else t1.ActionType.fromNumber(t646.actionType) or t646.actionType
			end

			if t646.action_params ~= nil then
				v4764.action_params = t1.ActionSequenceAction_Params.jsonDecode(t646.action_params)
			end

			if t646.actionParams ~= nil then
				v4764.action_params = t1.ActionSequenceAction_Params.jsonDecode(t646.actionParams)
			end

			return v4764
		end

		t643.descriptor = {
			name = "ActionSequenceAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.ActionSequenceAction"
		}
		t1.ActionSequenceAction = t643
	end

	typeRegistry.default:register(t1.ActionSequenceAction)

	local t647 = {}

	t647.__index = t647

	function t647.new(t648: {[any]: any}?) -- line: 29870
		-- upvalues: t647 (copy)
		return (setmetatable({
			actions = if t648 ~= nil and t648.actions ~= nil then t648.actions else {}
		}, t647))
	end
	function t647.encode(p487) -- line: 29878
		-- upvalues: proto (copy)
		local buf = buffer.create(0)
		local n322 = 0

		if p487.actions ~= nil and #p487.actions > 0 then
			for _, v4770 in p487.actions do
				local v4771 = v4770:encode()
				local v4772, v4773 = proto.writeTag(buf, n322, 1, proto.wireTypes.lengthDelimited)

				buf, n322 = proto.writeBuffer(v4772, v4773, v4771, buffer.len(v4771))
			end
		end

		local buf164 = buffer.create(n322)

		buffer.copy(buf164, 0, buf, 0, n322)

		return buf164
	end
	function t647.decode(p488: buffer) -- line: 29895
		-- upvalues: t647 (copy), proto (copy), t1 (copy)
		local v4776 = t647.new()
		local n323 = 0

		while n323 < buffer.len(p488) do
			local v4778, v4779

			v4778, v4779, n323 = proto.readTag(p488, n323)

			if v4779 == proto.wireTypes.varint then
				local v4780

				v4780, n323 = proto.readVarInt(p488, n323)
			elseif v4779 == proto.wireTypes.lengthDelimited then
				if v4778 == 1 then
					local v4781

					v4781, n323 = proto.readBuffer(p488, n323)
					table.insert(v4776.actions, t1.ActionProp.decode(v4781))
				else
					local v4782, v4783 = proto.readVarInt(p488, n323)

					n323 = v4783 + v4782
				end
			elseif v4779 == proto.wireTypes.i32 then
				local v4784

				v4784, n323 = proto.readFixed32(p488, n323)
			elseif v4779 == proto.wireTypes.i64 then
				local v4785

				v4785, n323 = proto.readFixed64(p488, n323)
			else
				error("Unsupported wire type: " .. v4779)
			end
		end

		return v4776
	end
	function t647.jsonEncode(p489) -- line: 29938
		local t649 = {}

		if p489.actions ~= nil and #p489.actions > 0 then
			local t650 = {}

			for _, v4790 in p489.actions do
				table.insert(t650, v4790:jsonEncode())
			end

			t649.actions = t650
		end

		return t649
	end
	function t647.jsonDecode(t651: {[any]: any}) -- line: 29952
		-- upvalues: t647 (copy), t1 (copy)
		local v4792 = t647.new()

		if t651.actions ~= nil then
			local t652 = {}

			for _, v4795 in t651.actions do
				table.insert(t652, t1.ActionProp.jsonDecode(v4795))
			end

			v4792.actions = t652
		end

		return v4792
	end

	t647.descriptor = {
		name = "ActionSequenceAction_Params",
		fullName = "roblox.apppageplatform.shared.v1beta1.Params"
	}
	t1.ActionSequenceAction_Params = t647
	typeRegistry.default:register(t1.ActionSequenceAction_Params)

	local t653 = {}

	t653.__index = t653

	function t653.new(t654: {[any]: any}?) -- line: 29981
		-- upvalues: t653 (copy)
		return (setmetatable({
			kind = if t654 ~= nil and t654.kind ~= nil then t654.kind else nil,
			telemetry_handler = if t654 ~= nil and t654.telemetry_handler ~= nil then t654.telemetry_handler else nil,
			accessibility_label = if t654 ~= nil and t654.accessibility_label ~= nil then t654.accessibility_label else nil,
			skip_unified_logging = if t654 ~= nil and t654.skip_unified_logging ~= nil then t654.skip_unified_logging else nil
		}, t653))
	end
	function t653.encode(p490) -- line: 29994
		-- upvalues: proto (copy)
		local buf = buffer.create(0)
		local n324 = 0

		if p490.kind ~= nil then
			if p490.kind.type == "dismiss_dialog_action" then
				local v4800 = p490.kind.value:encode()
				local v4801, v4802 = proto.writeTag(buf, n324, 1, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4801, v4802, v4800, buffer.len(v4800))
			elseif p490.kind.type == "link_action" then
				local v4803 = p490.kind.value:encode()
				local v4804, v4805 = proto.writeTag(buf, n324, 2, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4804, v4805, v4803, buffer.len(v4803))
			elseif p490.kind.type == "open_game_details_action" then
				local v4806 = p490.kind.value:encode()
				local v4807, v4808 = proto.writeTag(buf, n324, 3, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4807, v4808, v4806, buffer.len(v4806))
			elseif p490.kind.type == "open_join_friends_action" then
				local v4809 = p490.kind.value:encode()
				local v4810, v4811 = proto.writeTag(buf, n324, 4, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4810, v4811, v4809, buffer.len(v4809))
			elseif p490.kind.type == "open_marketplace_try_on_action" then
				local v4812 = p490.kind.value:encode()
				local v4813, v4814 = proto.writeTag(buf, n324, 5, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4813, v4814, v4812, buffer.len(v4812))
			elseif p490.kind.type == "open_see_all_action" then
				local v4815 = p490.kind.value:encode()
				local v4816, v4817 = proto.writeTag(buf, n324, 6, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4816, v4817, v4815, buffer.len(v4815))
			elseif p490.kind.type == "open_sponsored_tooltip_action" then
				local v4818 = p490.kind.value:encode()
				local v4819, v4820 = proto.writeTag(buf, n324, 7, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4819, v4820, v4818, buffer.len(v4818))
			elseif p490.kind.type == "play_button_click_action" then
				local v4821 = p490.kind.value:encode()
				local v4822, v4823 = proto.writeTag(buf, n324, 8, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4822, v4823, v4821, buffer.len(v4821))
			elseif p490.kind.type == "update_user_settings_action" then
				local v4824 = p490.kind.value:encode()
				local v4825, v4826 = proto.writeTag(buf, n324, 9, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4825, v4826, v4824, buffer.len(v4824))
			elseif p490.kind.type == "open_tooltip_action" then
				local v4827 = p490.kind.value:encode()
				local v4828, v4829 = proto.writeTag(buf, n324, 10, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4828, v4829, v4827, buffer.len(v4827))
			elseif p490.kind.type == "open_badge_details_action" then
				local v4830 = p490.kind.value:encode()
				local v4831, v4832 = proto.writeTag(buf, n324, 11, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4831, v4832, v4830, buffer.len(v4830))
			elseif p490.kind.type == "load_more_from_api_action" then
				local v4833 = p490.kind.value:encode()
				local v4834, v4835 = proto.writeTag(buf, n324, 12, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4834, v4835, v4833, buffer.len(v4833))
			elseif p490.kind.type == "share_action" then
				local v4836 = p490.kind.value:encode()
				local v4837, v4838 = proto.writeTag(buf, n324, 13, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4837, v4838, v4836, buffer.len(v4836))
			elseif p490.kind.type == "open_abuse_report_action" then
				local v4839 = p490.kind.value:encode()
				local v4840, v4841 = proto.writeTag(buf, n324, 14, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4840, v4841, v4839, buffer.len(v4839))
			elseif p490.kind.type == "remove_badge_from_inventory_action" then
				local v4842 = p490.kind.value:encode()
				local v4843, v4844 = proto.writeTag(buf, n324, 15, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4843, v4844, v4842, buffer.len(v4842))
			elseif p490.kind.type == "open_profile_action" then
				local v4845 = p490.kind.value:encode()
				local v4846, v4847 = proto.writeTag(buf, n324, 16, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4846, v4847, v4845, buffer.len(v4845))
			elseif p490.kind.type == "open_facial_age_estimation_action" then
				local v4848 = p490.kind.value:encode()
				local v4849, v4850 = proto.writeTag(buf, n324, 17, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4849, v4850, v4848, buffer.len(v4848))
			elseif p490.kind.type == "open_add_connections_page_action" then
				local v4851 = p490.kind.value:encode()
				local v4852, v4853 = proto.writeTag(buf, n324, 18, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4852, v4853, v4851, buffer.len(v4851))
			elseif p490.kind.type == "open_marketplace_action" then
				local v4854 = p490.kind.value:encode()
				local v4855, v4856 = proto.writeTag(buf, n324, 19, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4855, v4856, v4854, buffer.len(v4854))
			elseif p490.kind.type == "hide_profile_completion_action" then
				local v4857 = p490.kind.value:encode()
				local v4858, v4859 = proto.writeTag(buf, n324, 20, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4858, v4859, v4857, buffer.len(v4857))
			elseif p490.kind.type == "select_marketplace_catalog_category" then
				local v4860 = p490.kind.value:encode()
				local v4861, v4862 = proto.writeTag(buf, n324, 21, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4861, v4862, v4860, buffer.len(v4860))
			elseif p490.kind.type == "select_marketplace_catalog_subcategory" then
				local v4863 = p490.kind.value:encode()
				local v4864, v4865 = proto.writeTag(buf, n324, 22, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4864, v4865, v4863, buffer.len(v4863))
			elseif p490.kind.type == "open_marketplace_catalog_see_all" then
				local v4866 = p490.kind.value:encode()
				local v4867, v4868 = proto.writeTag(buf, n324, 23, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4867, v4868, v4866, buffer.len(v4866))
			elseif p490.kind.type == "close_marketplace_category_tooltip" then
				local v4869 = p490.kind.value:encode()
				local v4870, v4871 = proto.writeTag(buf, n324, 24, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4870, v4871, v4869, buffer.len(v4869))
			elseif p490.kind.type == "resize_marketplace_catalog" then
				local v4872 = p490.kind.value:encode()
				local v4873, v4874 = proto.writeTag(buf, n324, 25, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4873, v4874, v4872, buffer.len(v4872))
			elseif p490.kind.type == "open_marketplace_catalog_filters" then
				local v4875 = p490.kind.value:encode()
				local v4876, v4877 = proto.writeTag(buf, n324, 26, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4876, v4877, v4875, buffer.len(v4875))
			elseif p490.kind.type == "open_social_link_action" then
				local v4878 = p490.kind.value:encode()
				local v4879, v4880 = proto.writeTag(buf, n324, 27, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4879, v4880, v4878, buffer.len(v4878))
			elseif p490.kind.type == "open_charts_sort_detail_action" then
				local v4881 = p490.kind.value:encode()
				local v4882, v4883 = proto.writeTag(buf, n324, 28, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4882, v4883, v4881, buffer.len(v4881))
			elseif p490.kind.type == "open_song_detail_action" then
				local v4884 = p490.kind.value:encode()
				local v4885, v4886 = proto.writeTag(buf, n324, 29, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4885, v4886, v4884, buffer.len(v4884))
			elseif p490.kind.type == "refresh_from_api_action" then
				local v4887 = p490.kind.value:encode()
				local v4888, v4889 = proto.writeTag(buf, n324, 30, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4888, v4889, v4887, buffer.len(v4887))
			elseif p490.kind.type == "rsvp_to_event_action" then
				local v4890 = p490.kind.value:encode()
				local v4891, v4892 = proto.writeTag(buf, n324, 31, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4891, v4892, v4890, buffer.len(v4890))
			elseif p490.kind.type == "apply_charts_filter_action" then
				local v4893 = p490.kind.value:encode()
				local v4894, v4895 = proto.writeTag(buf, n324, 32, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4894, v4895, v4893, buffer.len(v4893))
			elseif p490.kind.type == "analytics_event_action" then
				local v4896 = p490.kind.value:encode()
				local v4897, v4898 = proto.writeTag(buf, n324, 33, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4897, v4898, v4896, buffer.len(v4896))
			elseif p490.kind.type == "custom_analytics_event_action" then
				local v4899 = p490.kind.value:encode()
				local v4900, v4901 = proto.writeTag(buf, n324, 34, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4900, v4901, v4899, buffer.len(v4899))
			elseif p490.kind.type == "open_game_invite_action" then
				local v4902 = p490.kind.value:encode()
				local v4903, v4904 = proto.writeTag(buf, n324, 35, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4903, v4904, v4902, buffer.len(v4902))
			elseif p490.kind.type == "open_event_details_action" then
				local v4905 = p490.kind.value:encode()
				local v4906, v4907 = proto.writeTag(buf, n324, 36, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4906, v4907, v4905, buffer.len(v4905))
			elseif p490.kind.type == "launch_experience_action" then
				local v4908 = p490.kind.value:encode()
				local v4909, v4910 = proto.writeTag(buf, n324, 37, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4909, v4910, v4908, buffer.len(v4908))
			elseif p490.kind.type == "toggle_experience_favorite_action" then
				local v4911 = p490.kind.value:encode()
				local v4912, v4913 = proto.writeTag(buf, n324, 38, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4912, v4913, v4911, buffer.len(v4911))
			elseif p490.kind.type == "toggle_experience_follow_action" then
				local v4914 = p490.kind.value:encode()
				local v4915, v4916 = proto.writeTag(buf, n324, 39, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4915, v4916, v4914, buffer.len(v4914))
			elseif p490.kind.type == "toggle_experience_vote_action" then
				local v4917 = p490.kind.value:encode()
				local v4918, v4919 = proto.writeTag(buf, n324, 40, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4918, v4919, v4917, buffer.len(v4917))
			elseif p490.kind.type == "open_purchase_prompt_action" then
				local v4920 = p490.kind.value:encode()
				local v4921, v4922 = proto.writeTag(buf, n324, 41, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4921, v4922, v4920, buffer.len(v4920))
			elseif p490.kind.type == "open_sdui_overlay_action" then
				local v4923 = p490.kind.value:encode()
				local v4924, v4925 = proto.writeTag(buf, n324, 42, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4924, v4925, v4923, buffer.len(v4923))
			elseif p490.kind.type == "open_badges_see_all_action" then
				local v4926 = p490.kind.value:encode()
				local v4927, v4928 = proto.writeTag(buf, n324, 43, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4927, v4928, v4926, buffer.len(v4926))
			elseif p490.kind.type == "open_experience_store_see_all_action" then
				local v4929 = p490.kind.value:encode()
				local v4930, v4931 = proto.writeTag(buf, n324, 44, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4930, v4931, v4929, buffer.len(v4929))
			elseif p490.kind.type == "dismiss_game_feedback_action" then
				local v4932 = p490.kind.value:encode()
				local v4933, v4934 = proto.writeTag(buf, n324, 45, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4933, v4934, v4932, buffer.len(v4932))
			elseif p490.kind.type == "open_game_feedback_form_action" then
				local v4935 = p490.kind.value:encode()
				local v4936, v4937 = proto.writeTag(buf, n324, 46, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4936, v4937, v4935, buffer.len(v4935))
			elseif p490.kind.type == "enable_event_notifications_action" then
				local v4938 = p490.kind.value:encode()
				local v4939, v4940 = proto.writeTag(buf, n324, 47, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4939, v4940, v4938, buffer.len(v4938))
			elseif p490.kind.type == "dismiss_event_notifications_modal_action" then
				local v4941 = p490.kind.value:encode()
				local v4942, v4943 = proto.writeTag(buf, n324, 48, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4942, v4943, v4941, buffer.len(v4941))
			elseif p490.kind.type == "open_amp_wizard_action" then
				local v4944 = p490.kind.value:encode()
				local v4945, v4946 = proto.writeTag(buf, n324, 49, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4945, v4946, v4944, buffer.len(v4944))
			elseif p490.kind.type == "open_subscription_purchase_page_action" then
				local v4947 = p490.kind.value:encode()
				local v4948, v4949 = proto.writeTag(buf, n324, 50, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4948, v4949, v4947, buffer.len(v4947))
			elseif p490.kind.type == "refresh_game_passes_action" then
				local v4950 = p490.kind.value:encode()
				local v4951, v4952 = proto.writeTag(buf, n324, 51, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4951, v4952, v4950, buffer.len(v4950))
			elseif p490.kind.type == "refresh_playability_action" then
				local v4953 = p490.kind.value:encode()
				local v4954, v4955 = proto.writeTag(buf, n324, 52, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4954, v4955, v4953, buffer.len(v4953))
			elseif p490.kind.type == "open_social_proof_user_list_sheet_action" then
				local v4956 = p490.kind.value:encode()
				local v4957, v4958 = proto.writeTag(buf, n324, 53, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4957, v4958, v4956, buffer.len(v4956))
			elseif p490.kind.type == "report_surface_load_time_milestone_action" then
				local v4959 = p490.kind.value:encode()
				local v4960, v4961 = proto.writeTag(buf, n324, 54, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4960, v4961, v4959, buffer.len(v4959))
			elseif p490.kind.type == "open_search_results_tab_action" then
				local v4962 = p490.kind.value:encode()
				local v4963, v4964 = proto.writeTag(buf, n324, 55, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4963, v4964, v4962, buffer.len(v4962))
			elseif p490.kind.type == "open_phone_upsell_modal_action" then
				local v4965 = p490.kind.value:encode()
				local v4966, v4967 = proto.writeTag(buf, n324, 56, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4966, v4967, v4965, buffer.len(v4965))
			elseif p490.kind.type == "open_email_upsell_modal_action" then
				local v4968 = p490.kind.value:encode()
				local v4969, v4970 = proto.writeTag(buf, n324, 57, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4969, v4970, v4968, buffer.len(v4968))
			elseif p490.kind.type == "dismiss_prompt_action" then
				local v4971 = p490.kind.value:encode()
				local v4972, v4973 = proto.writeTag(buf, n324, 58, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4972, v4973, v4971, buffer.len(v4971))
			elseif p490.kind.type == "request_friendship_action" then
				local v4974 = p490.kind.value:encode()
				local v4975, v4976 = proto.writeTag(buf, n324, 59, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4975, v4976, v4974, buffer.len(v4974))
			elseif p490.kind.type == "refresh_developer_products_action" then
				local v4977 = p490.kind.value:encode()
				local v4978, v4979 = proto.writeTag(buf, n324, 60, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4978, v4979, v4977, buffer.len(v4977))
			elseif p490.kind.type == "open_fae_trial_upsell_action" then
				local v4980 = p490.kind.value:encode()
				local v4981, v4982 = proto.writeTag(buf, n324, 61, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4981, v4982, v4980, buffer.len(v4980))
			elseif p490.kind.type == "refresh_omni_recommendation_feed_item_action" then
				local v4983 = p490.kind.value:encode()
				local v4984, v4985 = proto.writeTag(buf, n324, 62, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4984, v4985, v4983, buffer.len(v4983))
			elseif p490.kind.type == "ai_overview_feedback_action" then
				local v4986 = p490.kind.value:encode()
				local v4987, v4988 = proto.writeTag(buf, n324, 63, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4987, v4988, v4986, buffer.len(v4986))
			elseif p490.kind.type == "open_trusted_friends_upsell_modal_action" then
				local v4989 = p490.kind.value:encode()
				local v4990, v4991 = proto.writeTag(buf, n324, 64, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4990, v4991, v4989, buffer.len(v4989))
			elseif p490.kind.type == "record_party_chat_conversation_upsell_acknowledgement_action" then
				local v4992 = p490.kind.value:encode()
				local v4993, v4994 = proto.writeTag(buf, n324, 65, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4993, v4994, v4992, buffer.len(v4992))
			elseif p490.kind.type == "open_search_results_with_query_action" then
				local v4995 = p490.kind.value:encode()
				local v4996, v4997 = proto.writeTag(buf, n324, 66, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4996, v4997, v4995, buffer.len(v4995))
			elseif p490.kind.type == "select_marketplace_favorites_category" then
				local v4998 = p490.kind.value:encode()
				local v4999, v5000 = proto.writeTag(buf, n324, 67, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v4999, v5000, v4998, buffer.len(v4998))
			elseif p490.kind.type == "download_app_action" then
				local v5001 = p490.kind.value:encode()
				local v5002, v5003 = proto.writeTag(buf, n324, 68, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v5002, v5003, v5001, buffer.len(v5001))
			elseif p490.kind.type == "refresh_charts_sort_detail_action" then
				local v5004 = p490.kind.value:encode()
				local v5005, v5006 = proto.writeTag(buf, n324, 69, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v5005, v5006, v5004, buffer.len(v5004))
			elseif p490.kind.type == "join_community_action" then
				local v5007 = p490.kind.value:encode()
				local v5008, v5009 = proto.writeTag(buf, n324, 70, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v5008, v5009, v5007, buffer.len(v5007))
			elseif p490.kind.type == "view_community_action" then
				local v5010 = p490.kind.value:encode()
				local v5011, v5012 = proto.writeTag(buf, n324, 71, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v5011, v5012, v5010, buffer.len(v5010))
			elseif p490.kind.type == "pin_experience_shortcut_action" then
				local v5013 = p490.kind.value:encode()
				local v5014, v5015 = proto.writeTag(buf, n324, 72, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v5014, v5015, v5013, buffer.len(v5013))
			elseif p490.kind.type == "select_marketplace_favorites_subcategory" then
				local v5016 = p490.kind.value:encode()
				local v5017, v5018 = proto.writeTag(buf, n324, 73, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v5017, v5018, v5016, buffer.len(v5016))
			elseif p490.kind.type == "show_toast_action" then
				local v5019 = p490.kind.value:encode()
				local v5020, v5021 = proto.writeTag(buf, n324, 74, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v5020, v5021, v5019, buffer.len(v5019))
			elseif p490.kind.type == "open_incoming_transfer_upsell_action" then
				local v5022 = p490.kind.value:encode()
				local v5023, v5024 = proto.writeTag(buf, n324, 75, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v5023, v5024, v5022, buffer.len(v5022))
			elseif p490.kind.type == "action_sequence_action" then
				local v5025 = p490.kind.value:encode()
				local v5026, v5027 = proto.writeTag(buf, n324, 76, proto.wireTypes.lengthDelimited)

				buf, n324 = proto.writeBuffer(v5026, v5027, v5025, buffer.len(v5025))
			end
		end

		if p490.telemetry_handler ~= nil then
			local v5028 = p490.telemetry_handler:encode()
			local v5029, v5030 = proto.writeTag(buf, n324, 1000, proto.wireTypes.lengthDelimited)

			buf, n324 = proto.writeBuffer(v5029, v5030, v5028, buffer.len(v5028))
		end

		if p490.accessibility_label ~= nil then
			local v5031 = p490.accessibility_label:encode()
			local v5032, v5033 = proto.writeTag(buf, n324, 1001, proto.wireTypes.lengthDelimited)

			buf, n324 = proto.writeBuffer(v5032, v5033, v5031, buffer.len(v5031))
		end

		if p490.skip_unified_logging ~= nil then
			local v5034 = p490.skip_unified_logging:encode()
			local v5035, v5036 = proto.writeTag(buf, n324, 1002, proto.wireTypes.lengthDelimited)

			buf, n324 = proto.writeBuffer(v5035, v5036, v5034, buffer.len(v5034))
		end

		local buf165 = buffer.create(n324)

		buffer.copy(buf165, 0, buf, 0, n324)

		return buf165
	end
	function t653.decode(p491: buffer) -- line: 30329
		-- upvalues: t653 (copy), proto (copy), t1 (copy), prop_types (copy)
		local v5039 = t653.new()
		local n325 = 0

		while n325 < buffer.len(p491) do
			local v5041, v5042

			v5041, v5042, n325 = proto.readTag(p491, n325)

			if v5042 == proto.wireTypes.varint then
				local v5043

				v5043, n325 = proto.readVarInt(p491, n325)
			elseif v5042 == proto.wireTypes.lengthDelimited then
				if v5041 == 1 then
					local v5044

					v5044, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "dismiss_dialog_action",
						value = t1.DismissDialogAction.decode(v5044)
					}
				elseif v5041 == 2 then
					local v5045

					v5045, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "link_action",
						value = t1.LinkAction.decode(v5045)
					}
				elseif v5041 == 3 then
					local v5046

					v5046, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "open_game_details_action",
						value = t1.OpenGameDetailsAction.decode(v5046)
					}
				elseif v5041 == 4 then
					local v5047

					v5047, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "open_join_friends_action",
						value = t1.OpenJoinFriendsAction.decode(v5047)
					}
				elseif v5041 == 5 then
					local v5048

					v5048, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "open_marketplace_try_on_action",
						value = t1.OpenMarketplaceTryOnAction.decode(v5048)
					}
				elseif v5041 == 6 then
					local v5049

					v5049, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "open_see_all_action",
						value = t1.OpenSeeAllAction.decode(v5049)
					}
				elseif v5041 == 7 then
					local v5050

					v5050, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "open_sponsored_tooltip_action",
						value = t1.OpenSponsoredTooltipAction.decode(v5050)
					}
				elseif v5041 == 8 then
					local v5051

					v5051, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "play_button_click_action",
						value = t1.PlayButtonClickAction.decode(v5051)
					}
				elseif v5041 == 9 then
					local v5052

					v5052, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "update_user_settings_action",
						value = t1.UpdateUserSettingsAction.decode(v5052)
					}
				elseif v5041 == 10 then
					local v5053

					v5053, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "open_tooltip_action",
						value = t1.OpenTooltipAction.decode(v5053)
					}
				elseif v5041 == 11 then
					local v5054

					v5054, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "open_badge_details_action",
						value = t1.OpenBadgeDetailsAction.decode(v5054)
					}
				elseif v5041 == 12 then
					local v5055

					v5055, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "load_more_from_api_action",
						value = t1.LoadMoreFromApiAction.decode(v5055)
					}
				elseif v5041 == 13 then
					local v5056

					v5056, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "share_action",
						value = t1.ShareAction.decode(v5056)
					}
				elseif v5041 == 14 then
					local v5057

					v5057, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "open_abuse_report_action",
						value = t1.OpenAbuseReportAction.decode(v5057)
					}
				elseif v5041 == 15 then
					local v5058

					v5058, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "remove_badge_from_inventory_action",
						value = t1.RemoveBadgeFromInventoryAction.decode(v5058)
					}
				elseif v5041 == 16 then
					local v5059

					v5059, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "open_profile_action",
						value = t1.OpenProfileAction.decode(v5059)
					}
				elseif v5041 == 17 then
					local v5060

					v5060, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "open_facial_age_estimation_action",
						value = t1.OpenFacialAgeEstimationAction.decode(v5060)
					}
				elseif v5041 == 18 then
					local v5061

					v5061, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "open_add_connections_page_action",
						value = t1.OpenAddConnectionsPageAction.decode(v5061)
					}
				elseif v5041 == 19 then
					local v5062

					v5062, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "open_marketplace_action",
						value = t1.OpenMarketplaceAction.decode(v5062)
					}
				elseif v5041 == 20 then
					local v5063

					v5063, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "hide_profile_completion_action",
						value = t1.HideProfileCompletionAction.decode(v5063)
					}
				elseif v5041 == 21 then
					local v5064

					v5064, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "select_marketplace_catalog_category",
						value = t1.SelectMarketplaceCatalogCategory.decode(v5064)
					}
				elseif v5041 == 22 then
					local v5065

					v5065, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "select_marketplace_catalog_subcategory",
						value = t1.SelectMarketplaceCatalogSubcategory.decode(v5065)
					}
				elseif v5041 == 23 then
					local v5066

					v5066, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "open_marketplace_catalog_see_all",
						value = t1.OpenMarketplaceCatalogSeeAll.decode(v5066)
					}
				elseif v5041 == 24 then
					local v5067

					v5067, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "close_marketplace_category_tooltip",
						value = t1.CloseMarketplaceCategoryTooltip.decode(v5067)
					}
				elseif v5041 == 25 then
					local v5068

					v5068, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "resize_marketplace_catalog",
						value = t1.ResizeMarketplaceCatalog.decode(v5068)
					}
				elseif v5041 == 26 then
					local v5069

					v5069, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "open_marketplace_catalog_filters",
						value = t1.OpenMarketplaceCatalogFilters.decode(v5069)
					}
				elseif v5041 == 27 then
					local v5070

					v5070, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "open_social_link_action",
						value = t1.OpenSocialLinkAction.decode(v5070)
					}
				elseif v5041 == 28 then
					local v5071

					v5071, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "open_charts_sort_detail_action",
						value = t1.OpenChartsSortDetailAction.decode(v5071)
					}
				elseif v5041 == 29 then
					local v5072

					v5072, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "open_song_detail_action",
						value = t1.OpenSongDetailAction.decode(v5072)
					}
				elseif v5041 == 30 then
					local v5073

					v5073, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "refresh_from_api_action",
						value = t1.RefreshFromApiAction.decode(v5073)
					}
				elseif v5041 == 31 then
					local v5074

					v5074, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "rsvp_to_event_action",
						value = t1.RsvpToEventAction.decode(v5074)
					}
				elseif v5041 == 32 then
					local v5075

					v5075, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "apply_charts_filter_action",
						value = t1.ApplyChartsFilterAction.decode(v5075)
					}
				elseif v5041 == 33 then
					local v5076

					v5076, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "analytics_event_action",
						value = t1.AnalyticsEventAction.decode(v5076)
					}
				elseif v5041 == 34 then
					local v5077

					v5077, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "custom_analytics_event_action",
						value = t1.CustomAnalyticsEventAction.decode(v5077)
					}
				elseif v5041 == 35 then
					local v5078

					v5078, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "open_game_invite_action",
						value = t1.OpenGameInviteAction.decode(v5078)
					}
				elseif v5041 == 36 then
					local v5079

					v5079, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "open_event_details_action",
						value = t1.OpenEventDetailsAction.decode(v5079)
					}
				elseif v5041 == 37 then
					local v5080

					v5080, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "launch_experience_action",
						value = t1.LaunchExperienceAction.decode(v5080)
					}
				elseif v5041 == 38 then
					local v5081

					v5081, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "toggle_experience_favorite_action",
						value = t1.ToggleExperienceFavoriteAction.decode(v5081)
					}
				elseif v5041 == 39 then
					local v5082

					v5082, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "toggle_experience_follow_action",
						value = t1.ToggleExperienceFollowAction.decode(v5082)
					}
				elseif v5041 == 40 then
					local v5083

					v5083, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "toggle_experience_vote_action",
						value = t1.ToggleExperienceVoteAction.decode(v5083)
					}
				elseif v5041 == 41 then
					local v5084

					v5084, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "open_purchase_prompt_action",
						value = t1.OpenPurchasePromptAction.decode(v5084)
					}
				elseif v5041 == 42 then
					local v5085

					v5085, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "open_sdui_overlay_action",
						value = t1.OpenSduiOverlayAction.decode(v5085)
					}
				elseif v5041 == 43 then
					local v5086

					v5086, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "open_badges_see_all_action",
						value = t1.OpenBadgesSeeAllAction.decode(v5086)
					}
				elseif v5041 == 44 then
					local v5087

					v5087, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "open_experience_store_see_all_action",
						value = t1.OpenExperienceStoreSeeAllAction.decode(v5087)
					}
				elseif v5041 == 45 then
					local v5088

					v5088, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "dismiss_game_feedback_action",
						value = t1.DismissGameFeedbackAction.decode(v5088)
					}
				elseif v5041 == 46 then
					local v5089

					v5089, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "open_game_feedback_form_action",
						value = t1.OpenGameFeedbackFormAction.decode(v5089)
					}
				elseif v5041 == 47 then
					local v5090

					v5090, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "enable_event_notifications_action",
						value = t1.EnableEventNotificationsAction.decode(v5090)
					}
				elseif v5041 == 48 then
					local v5091

					v5091, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "dismiss_event_notifications_modal_action",
						value = t1.DismissEventNotificationsModalAction.decode(v5091)
					}
				elseif v5041 == 49 then
					local v5092

					v5092, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "open_amp_wizard_action",
						value = t1.OpenAmpWizardAction.decode(v5092)
					}
				elseif v5041 == 50 then
					local v5093

					v5093, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "open_subscription_purchase_page_action",
						value = t1.OpenSubscriptionPurchasePageAction.decode(v5093)
					}
				elseif v5041 == 51 then
					local v5094

					v5094, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "refresh_game_passes_action",
						value = t1.RefreshGamePassesAction.decode(v5094)
					}
				elseif v5041 == 52 then
					local v5095

					v5095, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "refresh_playability_action",
						value = t1.RefreshPlayabilityAction.decode(v5095)
					}
				elseif v5041 == 53 then
					local v5096

					v5096, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "open_social_proof_user_list_sheet_action",
						value = t1.OpenSocialProofUserListSheetAction.decode(v5096)
					}
				elseif v5041 == 54 then
					local v5097

					v5097, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "report_surface_load_time_milestone_action",
						value = t1.ReportSurfaceLoadTimeMilestoneAction.decode(v5097)
					}
				elseif v5041 == 55 then
					local v5098

					v5098, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "open_search_results_tab_action",
						value = t1.OpenSearchResultsTabAction.decode(v5098)
					}
				elseif v5041 == 56 then
					local v5099

					v5099, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "open_phone_upsell_modal_action",
						value = t1.OpenPhoneUpsellModalAction.decode(v5099)
					}
				elseif v5041 == 57 then
					local v5100

					v5100, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "open_email_upsell_modal_action",
						value = t1.OpenEmailUpsellModalAction.decode(v5100)
					}
				elseif v5041 == 58 then
					local v5101

					v5101, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "dismiss_prompt_action",
						value = t1.DismissPromptAction.decode(v5101)
					}
				elseif v5041 == 59 then
					local v5102

					v5102, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "request_friendship_action",
						value = t1.RequestFriendshipAction.decode(v5102)
					}
				elseif v5041 == 60 then
					local v5103

					v5103, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "refresh_developer_products_action",
						value = t1.RefreshDeveloperProductsAction.decode(v5103)
					}
				elseif v5041 == 61 then
					local v5104

					v5104, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "open_fae_trial_upsell_action",
						value = t1.OpenFaeTrialUpsellAction.decode(v5104)
					}
				elseif v5041 == 62 then
					local v5105

					v5105, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "refresh_omni_recommendation_feed_item_action",
						value = t1.RefreshOmniRecommendationFeedItemAction.decode(v5105)
					}
				elseif v5041 == 63 then
					local v5106

					v5106, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "ai_overview_feedback_action",
						value = t1.AiOverviewFeedbackAction.decode(v5106)
					}
				elseif v5041 == 64 then
					local v5107

					v5107, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "open_trusted_friends_upsell_modal_action",
						value = t1.OpenTrustedFriendsUpsellModalAction.decode(v5107)
					}
				elseif v5041 == 65 then
					local v5108

					v5108, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "record_party_chat_conversation_upsell_acknowledgement_action",
						value = t1.RecordPartyChatConversationUpsellAcknowledgementAction.decode(v5108)
					}
				elseif v5041 == 66 then
					local v5109

					v5109, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "open_search_results_with_query_action",
						value = t1.OpenSearchResultsWithQueryAction.decode(v5109)
					}
				elseif v5041 == 67 then
					local v5110

					v5110, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "select_marketplace_favorites_category",
						value = t1.SelectMarketplaceFavoritesCategory.decode(v5110)
					}
				elseif v5041 == 68 then
					local v5111

					v5111, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "download_app_action",
						value = t1.DownloadAppAction.decode(v5111)
					}
				elseif v5041 == 69 then
					local v5112

					v5112, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "refresh_charts_sort_detail_action",
						value = t1.RefreshChartsSortDetailAction.decode(v5112)
					}
				elseif v5041 == 70 then
					local v5113

					v5113, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "join_community_action",
						value = t1.JoinCommunityAction.decode(v5113)
					}
				elseif v5041 == 71 then
					local v5114

					v5114, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "view_community_action",
						value = t1.ViewCommunityAction.decode(v5114)
					}
				elseif v5041 == 72 then
					local v5115

					v5115, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "pin_experience_shortcut_action",
						value = t1.PinExperienceShortcutAction.decode(v5115)
					}
				elseif v5041 == 73 then
					local v5116

					v5116, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "select_marketplace_favorites_subcategory",
						value = t1.SelectMarketplaceFavoritesSubcategory.decode(v5116)
					}
				elseif v5041 == 74 then
					local v5117

					v5117, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "show_toast_action",
						value = t1.ShowToastAction.decode(v5117)
					}
				elseif v5041 == 75 then
					local v5118

					v5118, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "open_incoming_transfer_upsell_action",
						value = t1.OpenIncomingTransferUpsellAction.decode(v5118)
					}
				elseif v5041 == 76 then
					local v5119

					v5119, n325 = proto.readBuffer(p491, n325)
					v5039.kind = {
						type = "action_sequence_action",
						value = t1.ActionSequenceAction.decode(v5119)
					}
				elseif v5041 == 1000 then
					local v5120

					v5120, n325 = proto.readBuffer(p491, n325)
					v5039.telemetry_handler = prop_types.StringProp.decode(v5120)
				elseif v5041 == 1001 then
					local v5121

					v5121, n325 = proto.readBuffer(p491, n325)
					v5039.accessibility_label = prop_types.StringFormat.decode(v5121)
				elseif v5041 == 1002 then
					local v5122

					v5122, n325 = proto.readBuffer(p491, n325)
					v5039.skip_unified_logging = prop_types.BoolProp.decode(v5122)
				else
					local v5123, v5124 = proto.readVarInt(p491, n325)

					n325 = v5124 + v5123
				end
			elseif v5042 == proto.wireTypes.i32 then
				local v5125

				v5125, n325 = proto.readFixed32(p491, n325)
			elseif v5042 == proto.wireTypes.i64 then
				local v5126

				v5126, n325 = proto.readFixed64(p491, n325)
			else
				error("Unsupported wire type: " .. v5042)
			end
		end

		return v5039
	end
	function t653.jsonEncode(p492) -- line: 30906
		local t655 = {}

		if p492.kind ~= nil then
			if p492.kind.type == "dismiss_dialog_action" then
				t655.dismissDialogAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "link_action" then
				t655.linkAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "open_game_details_action" then
				t655.openGameDetailsAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "open_join_friends_action" then
				t655.openJoinFriendsAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "open_marketplace_try_on_action" then
				t655.openMarketplaceTryOnAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "open_see_all_action" then
				t655.openSeeAllAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "open_sponsored_tooltip_action" then
				t655.openSponsoredTooltipAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "play_button_click_action" then
				t655.playButtonClickAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "update_user_settings_action" then
				t655.updateUserSettingsAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "open_tooltip_action" then
				t655.openTooltipAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "open_badge_details_action" then
				t655.openBadgeDetailsAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "load_more_from_api_action" then
				t655.loadMoreFromApiAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "share_action" then
				t655.shareAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "open_abuse_report_action" then
				t655.openAbuseReportAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "remove_badge_from_inventory_action" then
				t655.removeBadgeFromInventoryAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "open_profile_action" then
				t655.openProfileAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "open_facial_age_estimation_action" then
				t655.openFacialAgeEstimationAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "open_add_connections_page_action" then
				t655.openAddConnectionsPageAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "open_marketplace_action" then
				t655.openMarketplaceAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "hide_profile_completion_action" then
				t655.hideProfileCompletionAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "select_marketplace_catalog_category" then
				t655.selectMarketplaceCatalogCategory = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "select_marketplace_catalog_subcategory" then
				t655.selectMarketplaceCatalogSubcategory = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "open_marketplace_catalog_see_all" then
				t655.openMarketplaceCatalogSeeAll = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "close_marketplace_category_tooltip" then
				t655.closeMarketplaceCategoryTooltip = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "resize_marketplace_catalog" then
				t655.resizeMarketplaceCatalog = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "open_marketplace_catalog_filters" then
				t655.openMarketplaceCatalogFilters = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "open_social_link_action" then
				t655.openSocialLinkAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "open_charts_sort_detail_action" then
				t655.openChartsSortDetailAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "open_song_detail_action" then
				t655.openSongDetailAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "refresh_from_api_action" then
				t655.refreshFromApiAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "rsvp_to_event_action" then
				t655.rsvpToEventAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "apply_charts_filter_action" then
				t655.applyChartsFilterAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "analytics_event_action" then
				t655.analyticsEventAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "custom_analytics_event_action" then
				t655.customAnalyticsEventAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "open_game_invite_action" then
				t655.openGameInviteAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "open_event_details_action" then
				t655.openEventDetailsAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "launch_experience_action" then
				t655.launchExperienceAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "toggle_experience_favorite_action" then
				t655.toggleExperienceFavoriteAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "toggle_experience_follow_action" then
				t655.toggleExperienceFollowAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "toggle_experience_vote_action" then
				t655.toggleExperienceVoteAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "open_purchase_prompt_action" then
				t655.openPurchasePromptAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "open_sdui_overlay_action" then
				t655.openSduiOverlayAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "open_badges_see_all_action" then
				t655.openBadgesSeeAllAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "open_experience_store_see_all_action" then
				t655.openExperienceStoreSeeAllAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "dismiss_game_feedback_action" then
				t655.dismissGameFeedbackAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "open_game_feedback_form_action" then
				t655.openGameFeedbackFormAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "enable_event_notifications_action" then
				t655.enableEventNotificationsAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "dismiss_event_notifications_modal_action" then
				t655.dismissEventNotificationsModalAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "open_amp_wizard_action" then
				t655.openAmpWizardAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "open_subscription_purchase_page_action" then
				t655.openSubscriptionPurchasePageAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "refresh_game_passes_action" then
				t655.refreshGamePassesAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "refresh_playability_action" then
				t655.refreshPlayabilityAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "open_social_proof_user_list_sheet_action" then
				t655.openSocialProofUserListSheetAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "report_surface_load_time_milestone_action" then
				t655.reportSurfaceLoadTimeMilestoneAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "open_search_results_tab_action" then
				t655.openSearchResultsTabAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "open_phone_upsell_modal_action" then
				t655.openPhoneUpsellModalAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "open_email_upsell_modal_action" then
				t655.openEmailUpsellModalAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "dismiss_prompt_action" then
				t655.dismissPromptAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "request_friendship_action" then
				t655.requestFriendshipAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "refresh_developer_products_action" then
				t655.refreshDeveloperProductsAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "open_fae_trial_upsell_action" then
				t655.openFaeTrialUpsellAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "refresh_omni_recommendation_feed_item_action" then
				t655.refreshOmniRecommendationFeedItemAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "ai_overview_feedback_action" then
				t655.aiOverviewFeedbackAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "open_trusted_friends_upsell_modal_action" then
				t655.openTrustedFriendsUpsellModalAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "record_party_chat_conversation_upsell_acknowledgement_action" then
				t655.recordPartyChatConversationUpsellAcknowledgementAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "open_search_results_with_query_action" then
				t655.openSearchResultsWithQueryAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "select_marketplace_favorites_category" then
				t655.selectMarketplaceFavoritesCategory = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "download_app_action" then
				t655.downloadAppAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "refresh_charts_sort_detail_action" then
				t655.refreshChartsSortDetailAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "join_community_action" then
				t655.joinCommunityAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "view_community_action" then
				t655.viewCommunityAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "pin_experience_shortcut_action" then
				t655.pinExperienceShortcutAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "select_marketplace_favorites_subcategory" then
				t655.selectMarketplaceFavoritesSubcategory = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "show_toast_action" then
				t655.showToastAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "open_incoming_transfer_upsell_action" then
				t655.openIncomingTransferUpsellAction = p492.kind.value:jsonEncode()
			elseif p492.kind.type == "action_sequence_action" then
				t655.actionSequenceAction = p492.kind.value:jsonEncode()
			end
		end

		if p492.telemetry_handler ~= nil then
			t655.telemetryHandler = p492.telemetry_handler:jsonEncode()
		end

		if p492.accessibility_label ~= nil then
			t655.accessibilityLabel = p492.accessibility_label:jsonEncode()
		end

		if p492.skip_unified_logging ~= nil then
			t655.skipUnifiedLogging = p492.skip_unified_logging:jsonEncode()
		end

		return t655
	end
	function t653.jsonDecode(t656: {[any]: any}) -- line: 31080
		-- upvalues: t653 (copy), t1 (copy), prop_types (copy)
		local v5130 = t653.new()

		if t656.dismiss_dialog_action ~= nil then
			v5130.kind = {
				type = "dismiss_dialog_action",
				value = t1.DismissDialogAction.jsonDecode(t656.dismiss_dialog_action)
			}
		end

		if t656.dismissDialogAction ~= nil then
			v5130.kind = {
				type = "dismiss_dialog_action",
				value = t1.DismissDialogAction.jsonDecode(t656.dismissDialogAction)
			}
		end

		if t656.link_action ~= nil then
			v5130.kind = {
				type = "link_action",
				value = t1.LinkAction.jsonDecode(t656.link_action)
			}
		end

		if t656.linkAction ~= nil then
			v5130.kind = {
				type = "link_action",
				value = t1.LinkAction.jsonDecode(t656.linkAction)
			}
		end

		if t656.open_game_details_action ~= nil then
			v5130.kind = {
				type = "open_game_details_action",
				value = t1.OpenGameDetailsAction.jsonDecode(t656.open_game_details_action)
			}
		end

		if t656.openGameDetailsAction ~= nil then
			v5130.kind = {
				type = "open_game_details_action",
				value = t1.OpenGameDetailsAction.jsonDecode(t656.openGameDetailsAction)
			}
		end

		if t656.open_join_friends_action ~= nil then
			v5130.kind = {
				type = "open_join_friends_action",
				value = t1.OpenJoinFriendsAction.jsonDecode(t656.open_join_friends_action)
			}
		end

		if t656.openJoinFriendsAction ~= nil then
			v5130.kind = {
				type = "open_join_friends_action",
				value = t1.OpenJoinFriendsAction.jsonDecode(t656.openJoinFriendsAction)
			}
		end

		if t656.open_marketplace_try_on_action ~= nil then
			v5130.kind = {
				type = "open_marketplace_try_on_action",
				value = t1.OpenMarketplaceTryOnAction.jsonDecode(t656.open_marketplace_try_on_action)
			}
		end

		if t656.openMarketplaceTryOnAction ~= nil then
			v5130.kind = {
				type = "open_marketplace_try_on_action",
				value = t1.OpenMarketplaceTryOnAction.jsonDecode(t656.openMarketplaceTryOnAction)
			}
		end

		if t656.open_see_all_action ~= nil then
			v5130.kind = {
				type = "open_see_all_action",
				value = t1.OpenSeeAllAction.jsonDecode(t656.open_see_all_action)
			}
		end

		if t656.openSeeAllAction ~= nil then
			v5130.kind = {
				type = "open_see_all_action",
				value = t1.OpenSeeAllAction.jsonDecode(t656.openSeeAllAction)
			}
		end

		if t656.open_sponsored_tooltip_action ~= nil then
			v5130.kind = {
				type = "open_sponsored_tooltip_action",
				value = t1.OpenSponsoredTooltipAction.jsonDecode(t656.open_sponsored_tooltip_action)
			}
		end

		if t656.openSponsoredTooltipAction ~= nil then
			v5130.kind = {
				type = "open_sponsored_tooltip_action",
				value = t1.OpenSponsoredTooltipAction.jsonDecode(t656.openSponsoredTooltipAction)
			}
		end

		if t656.play_button_click_action ~= nil then
			v5130.kind = {
				type = "play_button_click_action",
				value = t1.PlayButtonClickAction.jsonDecode(t656.play_button_click_action)
			}
		end

		if t656.playButtonClickAction ~= nil then
			v5130.kind = {
				type = "play_button_click_action",
				value = t1.PlayButtonClickAction.jsonDecode(t656.playButtonClickAction)
			}
		end

		if t656.update_user_settings_action ~= nil then
			v5130.kind = {
				type = "update_user_settings_action",
				value = t1.UpdateUserSettingsAction.jsonDecode(t656.update_user_settings_action)
			}
		end

		if t656.updateUserSettingsAction ~= nil then
			v5130.kind = {
				type = "update_user_settings_action",
				value = t1.UpdateUserSettingsAction.jsonDecode(t656.updateUserSettingsAction)
			}
		end

		if t656.open_tooltip_action ~= nil then
			v5130.kind = {
				type = "open_tooltip_action",
				value = t1.OpenTooltipAction.jsonDecode(t656.open_tooltip_action)
			}
		end

		if t656.openTooltipAction ~= nil then
			v5130.kind = {
				type = "open_tooltip_action",
				value = t1.OpenTooltipAction.jsonDecode(t656.openTooltipAction)
			}
		end

		if t656.open_badge_details_action ~= nil then
			v5130.kind = {
				type = "open_badge_details_action",
				value = t1.OpenBadgeDetailsAction.jsonDecode(t656.open_badge_details_action)
			}
		end

		if t656.openBadgeDetailsAction ~= nil then
			v5130.kind = {
				type = "open_badge_details_action",
				value = t1.OpenBadgeDetailsAction.jsonDecode(t656.openBadgeDetailsAction)
			}
		end

		if t656.load_more_from_api_action ~= nil then
			v5130.kind = {
				type = "load_more_from_api_action",
				value = t1.LoadMoreFromApiAction.jsonDecode(t656.load_more_from_api_action)
			}
		end

		if t656.loadMoreFromApiAction ~= nil then
			v5130.kind = {
				type = "load_more_from_api_action",
				value = t1.LoadMoreFromApiAction.jsonDecode(t656.loadMoreFromApiAction)
			}
		end

		if t656.share_action ~= nil then
			v5130.kind = {
				type = "share_action",
				value = t1.ShareAction.jsonDecode(t656.share_action)
			}
		end

		if t656.shareAction ~= nil then
			v5130.kind = {
				type = "share_action",
				value = t1.ShareAction.jsonDecode(t656.shareAction)
			}
		end

		if t656.open_abuse_report_action ~= nil then
			v5130.kind = {
				type = "open_abuse_report_action",
				value = t1.OpenAbuseReportAction.jsonDecode(t656.open_abuse_report_action)
			}
		end

		if t656.openAbuseReportAction ~= nil then
			v5130.kind = {
				type = "open_abuse_report_action",
				value = t1.OpenAbuseReportAction.jsonDecode(t656.openAbuseReportAction)
			}
		end

		if t656.remove_badge_from_inventory_action ~= nil then
			v5130.kind = {
				type = "remove_badge_from_inventory_action",
				value = t1.RemoveBadgeFromInventoryAction.jsonDecode(t656.remove_badge_from_inventory_action)
			}
		end

		if t656.removeBadgeFromInventoryAction ~= nil then
			v5130.kind = {
				type = "remove_badge_from_inventory_action",
				value = t1.RemoveBadgeFromInventoryAction.jsonDecode(t656.removeBadgeFromInventoryAction)
			}
		end

		if t656.open_profile_action ~= nil then
			v5130.kind = {
				type = "open_profile_action",
				value = t1.OpenProfileAction.jsonDecode(t656.open_profile_action)
			}
		end

		if t656.openProfileAction ~= nil then
			v5130.kind = {
				type = "open_profile_action",
				value = t1.OpenProfileAction.jsonDecode(t656.openProfileAction)
			}
		end

		if t656.open_facial_age_estimation_action ~= nil then
			v5130.kind = {
				type = "open_facial_age_estimation_action",
				value = t1.OpenFacialAgeEstimationAction.jsonDecode(t656.open_facial_age_estimation_action)
			}
		end

		if t656.openFacialAgeEstimationAction ~= nil then
			v5130.kind = {
				type = "open_facial_age_estimation_action",
				value = t1.OpenFacialAgeEstimationAction.jsonDecode(t656.openFacialAgeEstimationAction)
			}
		end

		if t656.open_add_connections_page_action ~= nil then
			v5130.kind = {
				type = "open_add_connections_page_action",
				value = t1.OpenAddConnectionsPageAction.jsonDecode(t656.open_add_connections_page_action)
			}
		end

		if t656.openAddConnectionsPageAction ~= nil then
			v5130.kind = {
				type = "open_add_connections_page_action",
				value = t1.OpenAddConnectionsPageAction.jsonDecode(t656.openAddConnectionsPageAction)
			}
		end

		if t656.open_marketplace_action ~= nil then
			v5130.kind = {
				type = "open_marketplace_action",
				value = t1.OpenMarketplaceAction.jsonDecode(t656.open_marketplace_action)
			}
		end

		if t656.openMarketplaceAction ~= nil then
			v5130.kind = {
				type = "open_marketplace_action",
				value = t1.OpenMarketplaceAction.jsonDecode(t656.openMarketplaceAction)
			}
		end

		if t656.hide_profile_completion_action ~= nil then
			v5130.kind = {
				type = "hide_profile_completion_action",
				value = t1.HideProfileCompletionAction.jsonDecode(t656.hide_profile_completion_action)
			}
		end

		if t656.hideProfileCompletionAction ~= nil then
			v5130.kind = {
				type = "hide_profile_completion_action",
				value = t1.HideProfileCompletionAction.jsonDecode(t656.hideProfileCompletionAction)
			}
		end

		if t656.select_marketplace_catalog_category ~= nil then
			v5130.kind = {
				type = "select_marketplace_catalog_category",
				value = t1.SelectMarketplaceCatalogCategory.jsonDecode(t656.select_marketplace_catalog_category)
			}
		end

		if t656.selectMarketplaceCatalogCategory ~= nil then
			v5130.kind = {
				type = "select_marketplace_catalog_category",
				value = t1.SelectMarketplaceCatalogCategory.jsonDecode(t656.selectMarketplaceCatalogCategory)
			}
		end

		if t656.select_marketplace_catalog_subcategory ~= nil then
			v5130.kind = {
				type = "select_marketplace_catalog_subcategory",
				value = t1.SelectMarketplaceCatalogSubcategory.jsonDecode(t656.select_marketplace_catalog_subcategory)
			}
		end

		if t656.selectMarketplaceCatalogSubcategory ~= nil then
			v5130.kind = {
				type = "select_marketplace_catalog_subcategory",
				value = t1.SelectMarketplaceCatalogSubcategory.jsonDecode(t656.selectMarketplaceCatalogSubcategory)
			}
		end

		if t656.open_marketplace_catalog_see_all ~= nil then
			v5130.kind = {
				type = "open_marketplace_catalog_see_all",
				value = t1.OpenMarketplaceCatalogSeeAll.jsonDecode(t656.open_marketplace_catalog_see_all)
			}
		end

		if t656.openMarketplaceCatalogSeeAll ~= nil then
			v5130.kind = {
				type = "open_marketplace_catalog_see_all",
				value = t1.OpenMarketplaceCatalogSeeAll.jsonDecode(t656.openMarketplaceCatalogSeeAll)
			}
		end

		if t656.close_marketplace_category_tooltip ~= nil then
			v5130.kind = {
				type = "close_marketplace_category_tooltip",
				value = t1.CloseMarketplaceCategoryTooltip.jsonDecode(t656.close_marketplace_category_tooltip)
			}
		end

		if t656.closeMarketplaceCategoryTooltip ~= nil then
			v5130.kind = {
				type = "close_marketplace_category_tooltip",
				value = t1.CloseMarketplaceCategoryTooltip.jsonDecode(t656.closeMarketplaceCategoryTooltip)
			}
		end

		if t656.resize_marketplace_catalog ~= nil then
			v5130.kind = {
				type = "resize_marketplace_catalog",
				value = t1.ResizeMarketplaceCatalog.jsonDecode(t656.resize_marketplace_catalog)
			}
		end

		if t656.resizeMarketplaceCatalog ~= nil then
			v5130.kind = {
				type = "resize_marketplace_catalog",
				value = t1.ResizeMarketplaceCatalog.jsonDecode(t656.resizeMarketplaceCatalog)
			}
		end

		if t656.open_marketplace_catalog_filters ~= nil then
			v5130.kind = {
				type = "open_marketplace_catalog_filters",
				value = t1.OpenMarketplaceCatalogFilters.jsonDecode(t656.open_marketplace_catalog_filters)
			}
		end

		if t656.openMarketplaceCatalogFilters ~= nil then
			v5130.kind = {
				type = "open_marketplace_catalog_filters",
				value = t1.OpenMarketplaceCatalogFilters.jsonDecode(t656.openMarketplaceCatalogFilters)
			}
		end

		if t656.open_social_link_action ~= nil then
			v5130.kind = {
				type = "open_social_link_action",
				value = t1.OpenSocialLinkAction.jsonDecode(t656.open_social_link_action)
			}
		end

		if t656.openSocialLinkAction ~= nil then
			v5130.kind = {
				type = "open_social_link_action",
				value = t1.OpenSocialLinkAction.jsonDecode(t656.openSocialLinkAction)
			}
		end

		if t656.open_charts_sort_detail_action ~= nil then
			v5130.kind = {
				type = "open_charts_sort_detail_action",
				value = t1.OpenChartsSortDetailAction.jsonDecode(t656.open_charts_sort_detail_action)
			}
		end

		if t656.openChartsSortDetailAction ~= nil then
			v5130.kind = {
				type = "open_charts_sort_detail_action",
				value = t1.OpenChartsSortDetailAction.jsonDecode(t656.openChartsSortDetailAction)
			}
		end

		if t656.open_song_detail_action ~= nil then
			v5130.kind = {
				type = "open_song_detail_action",
				value = t1.OpenSongDetailAction.jsonDecode(t656.open_song_detail_action)
			}
		end

		if t656.openSongDetailAction ~= nil then
			v5130.kind = {
				type = "open_song_detail_action",
				value = t1.OpenSongDetailAction.jsonDecode(t656.openSongDetailAction)
			}
		end

		if t656.refresh_from_api_action ~= nil then
			v5130.kind = {
				type = "refresh_from_api_action",
				value = t1.RefreshFromApiAction.jsonDecode(t656.refresh_from_api_action)
			}
		end

		if t656.refreshFromApiAction ~= nil then
			v5130.kind = {
				type = "refresh_from_api_action",
				value = t1.RefreshFromApiAction.jsonDecode(t656.refreshFromApiAction)
			}
		end

		if t656.rsvp_to_event_action ~= nil then
			v5130.kind = {
				type = "rsvp_to_event_action",
				value = t1.RsvpToEventAction.jsonDecode(t656.rsvp_to_event_action)
			}
		end

		if t656.rsvpToEventAction ~= nil then
			v5130.kind = {
				type = "rsvp_to_event_action",
				value = t1.RsvpToEventAction.jsonDecode(t656.rsvpToEventAction)
			}
		end

		if t656.apply_charts_filter_action ~= nil then
			v5130.kind = {
				type = "apply_charts_filter_action",
				value = t1.ApplyChartsFilterAction.jsonDecode(t656.apply_charts_filter_action)
			}
		end

		if t656.applyChartsFilterAction ~= nil then
			v5130.kind = {
				type = "apply_charts_filter_action",
				value = t1.ApplyChartsFilterAction.jsonDecode(t656.applyChartsFilterAction)
			}
		end

		if t656.analytics_event_action ~= nil then
			v5130.kind = {
				type = "analytics_event_action",
				value = t1.AnalyticsEventAction.jsonDecode(t656.analytics_event_action)
			}
		end

		if t656.analyticsEventAction ~= nil then
			v5130.kind = {
				type = "analytics_event_action",
				value = t1.AnalyticsEventAction.jsonDecode(t656.analyticsEventAction)
			}
		end

		if t656.custom_analytics_event_action ~= nil then
			v5130.kind = {
				type = "custom_analytics_event_action",
				value = t1.CustomAnalyticsEventAction.jsonDecode(t656.custom_analytics_event_action)
			}
		end

		if t656.customAnalyticsEventAction ~= nil then
			v5130.kind = {
				type = "custom_analytics_event_action",
				value = t1.CustomAnalyticsEventAction.jsonDecode(t656.customAnalyticsEventAction)
			}
		end

		if t656.open_game_invite_action ~= nil then
			v5130.kind = {
				type = "open_game_invite_action",
				value = t1.OpenGameInviteAction.jsonDecode(t656.open_game_invite_action)
			}
		end

		if t656.openGameInviteAction ~= nil then
			v5130.kind = {
				type = "open_game_invite_action",
				value = t1.OpenGameInviteAction.jsonDecode(t656.openGameInviteAction)
			}
		end

		if t656.open_event_details_action ~= nil then
			v5130.kind = {
				type = "open_event_details_action",
				value = t1.OpenEventDetailsAction.jsonDecode(t656.open_event_details_action)
			}
		end

		if t656.openEventDetailsAction ~= nil then
			v5130.kind = {
				type = "open_event_details_action",
				value = t1.OpenEventDetailsAction.jsonDecode(t656.openEventDetailsAction)
			}
		end

		if t656.launch_experience_action ~= nil then
			v5130.kind = {
				type = "launch_experience_action",
				value = t1.LaunchExperienceAction.jsonDecode(t656.launch_experience_action)
			}
		end

		if t656.launchExperienceAction ~= nil then
			v5130.kind = {
				type = "launch_experience_action",
				value = t1.LaunchExperienceAction.jsonDecode(t656.launchExperienceAction)
			}
		end

		if t656.toggle_experience_favorite_action ~= nil then
			v5130.kind = {
				type = "toggle_experience_favorite_action",
				value = t1.ToggleExperienceFavoriteAction.jsonDecode(t656.toggle_experience_favorite_action)
			}
		end

		if t656.toggleExperienceFavoriteAction ~= nil then
			v5130.kind = {
				type = "toggle_experience_favorite_action",
				value = t1.ToggleExperienceFavoriteAction.jsonDecode(t656.toggleExperienceFavoriteAction)
			}
		end

		if t656.toggle_experience_follow_action ~= nil then
			v5130.kind = {
				type = "toggle_experience_follow_action",
				value = t1.ToggleExperienceFollowAction.jsonDecode(t656.toggle_experience_follow_action)
			}
		end

		if t656.toggleExperienceFollowAction ~= nil then
			v5130.kind = {
				type = "toggle_experience_follow_action",
				value = t1.ToggleExperienceFollowAction.jsonDecode(t656.toggleExperienceFollowAction)
			}
		end

		if t656.toggle_experience_vote_action ~= nil then
			v5130.kind = {
				type = "toggle_experience_vote_action",
				value = t1.ToggleExperienceVoteAction.jsonDecode(t656.toggle_experience_vote_action)
			}
		end

		if t656.toggleExperienceVoteAction ~= nil then
			v5130.kind = {
				type = "toggle_experience_vote_action",
				value = t1.ToggleExperienceVoteAction.jsonDecode(t656.toggleExperienceVoteAction)
			}
		end

		if t656.open_purchase_prompt_action ~= nil then
			v5130.kind = {
				type = "open_purchase_prompt_action",
				value = t1.OpenPurchasePromptAction.jsonDecode(t656.open_purchase_prompt_action)
			}
		end

		if t656.openPurchasePromptAction ~= nil then
			v5130.kind = {
				type = "open_purchase_prompt_action",
				value = t1.OpenPurchasePromptAction.jsonDecode(t656.openPurchasePromptAction)
			}
		end

		if t656.open_sdui_overlay_action ~= nil then
			v5130.kind = {
				type = "open_sdui_overlay_action",
				value = t1.OpenSduiOverlayAction.jsonDecode(t656.open_sdui_overlay_action)
			}
		end

		if t656.openSduiOverlayAction ~= nil then
			v5130.kind = {
				type = "open_sdui_overlay_action",
				value = t1.OpenSduiOverlayAction.jsonDecode(t656.openSduiOverlayAction)
			}
		end

		if t656.open_badges_see_all_action ~= nil then
			v5130.kind = {
				type = "open_badges_see_all_action",
				value = t1.OpenBadgesSeeAllAction.jsonDecode(t656.open_badges_see_all_action)
			}
		end

		if t656.openBadgesSeeAllAction ~= nil then
			v5130.kind = {
				type = "open_badges_see_all_action",
				value = t1.OpenBadgesSeeAllAction.jsonDecode(t656.openBadgesSeeAllAction)
			}
		end

		if t656.open_experience_store_see_all_action ~= nil then
			v5130.kind = {
				type = "open_experience_store_see_all_action",
				value = t1.OpenExperienceStoreSeeAllAction.jsonDecode(t656.open_experience_store_see_all_action)
			}
		end

		if t656.openExperienceStoreSeeAllAction ~= nil then
			v5130.kind = {
				type = "open_experience_store_see_all_action",
				value = t1.OpenExperienceStoreSeeAllAction.jsonDecode(t656.openExperienceStoreSeeAllAction)
			}
		end

		if t656.dismiss_game_feedback_action ~= nil then
			v5130.kind = {
				type = "dismiss_game_feedback_action",
				value = t1.DismissGameFeedbackAction.jsonDecode(t656.dismiss_game_feedback_action)
			}
		end

		if t656.dismissGameFeedbackAction ~= nil then
			v5130.kind = {
				type = "dismiss_game_feedback_action",
				value = t1.DismissGameFeedbackAction.jsonDecode(t656.dismissGameFeedbackAction)
			}
		end

		if t656.open_game_feedback_form_action ~= nil then
			v5130.kind = {
				type = "open_game_feedback_form_action",
				value = t1.OpenGameFeedbackFormAction.jsonDecode(t656.open_game_feedback_form_action)
			}
		end

		if t656.openGameFeedbackFormAction ~= nil then
			v5130.kind = {
				type = "open_game_feedback_form_action",
				value = t1.OpenGameFeedbackFormAction.jsonDecode(t656.openGameFeedbackFormAction)
			}
		end

		if t656.enable_event_notifications_action ~= nil then
			v5130.kind = {
				type = "enable_event_notifications_action",
				value = t1.EnableEventNotificationsAction.jsonDecode(t656.enable_event_notifications_action)
			}
		end

		if t656.enableEventNotificationsAction ~= nil then
			v5130.kind = {
				type = "enable_event_notifications_action",
				value = t1.EnableEventNotificationsAction.jsonDecode(t656.enableEventNotificationsAction)
			}
		end

		if t656.dismiss_event_notifications_modal_action ~= nil then
			v5130.kind = {
				type = "dismiss_event_notifications_modal_action",
				value = t1.DismissEventNotificationsModalAction.jsonDecode(t656.dismiss_event_notifications_modal_action)
			}
		end

		if t656.dismissEventNotificationsModalAction ~= nil then
			v5130.kind = {
				type = "dismiss_event_notifications_modal_action",
				value = t1.DismissEventNotificationsModalAction.jsonDecode(t656.dismissEventNotificationsModalAction)
			}
		end

		if t656.open_amp_wizard_action ~= nil then
			v5130.kind = {
				type = "open_amp_wizard_action",
				value = t1.OpenAmpWizardAction.jsonDecode(t656.open_amp_wizard_action)
			}
		end

		if t656.openAmpWizardAction ~= nil then
			v5130.kind = {
				type = "open_amp_wizard_action",
				value = t1.OpenAmpWizardAction.jsonDecode(t656.openAmpWizardAction)
			}
		end

		if t656.open_subscription_purchase_page_action ~= nil then
			v5130.kind = {
				type = "open_subscription_purchase_page_action",
				value = t1.OpenSubscriptionPurchasePageAction.jsonDecode(t656.open_subscription_purchase_page_action)
			}
		end

		if t656.openSubscriptionPurchasePageAction ~= nil then
			v5130.kind = {
				type = "open_subscription_purchase_page_action",
				value = t1.OpenSubscriptionPurchasePageAction.jsonDecode(t656.openSubscriptionPurchasePageAction)
			}
		end

		if t656.refresh_game_passes_action ~= nil then
			v5130.kind = {
				type = "refresh_game_passes_action",
				value = t1.RefreshGamePassesAction.jsonDecode(t656.refresh_game_passes_action)
			}
		end

		if t656.refreshGamePassesAction ~= nil then
			v5130.kind = {
				type = "refresh_game_passes_action",
				value = t1.RefreshGamePassesAction.jsonDecode(t656.refreshGamePassesAction)
			}
		end

		if t656.refresh_playability_action ~= nil then
			v5130.kind = {
				type = "refresh_playability_action",
				value = t1.RefreshPlayabilityAction.jsonDecode(t656.refresh_playability_action)
			}
		end

		if t656.refreshPlayabilityAction ~= nil then
			v5130.kind = {
				type = "refresh_playability_action",
				value = t1.RefreshPlayabilityAction.jsonDecode(t656.refreshPlayabilityAction)
			}
		end

		if t656.open_social_proof_user_list_sheet_action ~= nil then
			v5130.kind = {
				type = "open_social_proof_user_list_sheet_action",
				value = t1.OpenSocialProofUserListSheetAction.jsonDecode(t656.open_social_proof_user_list_sheet_action)
			}
		end

		if t656.openSocialProofUserListSheetAction ~= nil then
			v5130.kind = {
				type = "open_social_proof_user_list_sheet_action",
				value = t1.OpenSocialProofUserListSheetAction.jsonDecode(t656.openSocialProofUserListSheetAction)
			}
		end

		if t656.report_surface_load_time_milestone_action ~= nil then
			v5130.kind = {
				type = "report_surface_load_time_milestone_action",
				value = t1.ReportSurfaceLoadTimeMilestoneAction.jsonDecode(t656.report_surface_load_time_milestone_action)
			}
		end

		if t656.reportSurfaceLoadTimeMilestoneAction ~= nil then
			v5130.kind = {
				type = "report_surface_load_time_milestone_action",
				value = t1.ReportSurfaceLoadTimeMilestoneAction.jsonDecode(t656.reportSurfaceLoadTimeMilestoneAction)
			}
		end

		if t656.open_search_results_tab_action ~= nil then
			v5130.kind = {
				type = "open_search_results_tab_action",
				value = t1.OpenSearchResultsTabAction.jsonDecode(t656.open_search_results_tab_action)
			}
		end

		if t656.openSearchResultsTabAction ~= nil then
			v5130.kind = {
				type = "open_search_results_tab_action",
				value = t1.OpenSearchResultsTabAction.jsonDecode(t656.openSearchResultsTabAction)
			}
		end

		if t656.open_phone_upsell_modal_action ~= nil then
			v5130.kind = {
				type = "open_phone_upsell_modal_action",
				value = t1.OpenPhoneUpsellModalAction.jsonDecode(t656.open_phone_upsell_modal_action)
			}
		end

		if t656.openPhoneUpsellModalAction ~= nil then
			v5130.kind = {
				type = "open_phone_upsell_modal_action",
				value = t1.OpenPhoneUpsellModalAction.jsonDecode(t656.openPhoneUpsellModalAction)
			}
		end

		if t656.open_email_upsell_modal_action ~= nil then
			v5130.kind = {
				type = "open_email_upsell_modal_action",
				value = t1.OpenEmailUpsellModalAction.jsonDecode(t656.open_email_upsell_modal_action)
			}
		end

		if t656.openEmailUpsellModalAction ~= nil then
			v5130.kind = {
				type = "open_email_upsell_modal_action",
				value = t1.OpenEmailUpsellModalAction.jsonDecode(t656.openEmailUpsellModalAction)
			}
		end

		if t656.dismiss_prompt_action ~= nil then
			v5130.kind = {
				type = "dismiss_prompt_action",
				value = t1.DismissPromptAction.jsonDecode(t656.dismiss_prompt_action)
			}
		end

		if t656.dismissPromptAction ~= nil then
			v5130.kind = {
				type = "dismiss_prompt_action",
				value = t1.DismissPromptAction.jsonDecode(t656.dismissPromptAction)
			}
		end

		if t656.request_friendship_action ~= nil then
			v5130.kind = {
				type = "request_friendship_action",
				value = t1.RequestFriendshipAction.jsonDecode(t656.request_friendship_action)
			}
		end

		if t656.requestFriendshipAction ~= nil then
			v5130.kind = {
				type = "request_friendship_action",
				value = t1.RequestFriendshipAction.jsonDecode(t656.requestFriendshipAction)
			}
		end

		if t656.refresh_developer_products_action ~= nil then
			v5130.kind = {
				type = "refresh_developer_products_action",
				value = t1.RefreshDeveloperProductsAction.jsonDecode(t656.refresh_developer_products_action)
			}
		end

		if t656.refreshDeveloperProductsAction ~= nil then
			v5130.kind = {
				type = "refresh_developer_products_action",
				value = t1.RefreshDeveloperProductsAction.jsonDecode(t656.refreshDeveloperProductsAction)
			}
		end

		if t656.open_fae_trial_upsell_action ~= nil then
			v5130.kind = {
				type = "open_fae_trial_upsell_action",
				value = t1.OpenFaeTrialUpsellAction.jsonDecode(t656.open_fae_trial_upsell_action)
			}
		end

		if t656.openFaeTrialUpsellAction ~= nil then
			v5130.kind = {
				type = "open_fae_trial_upsell_action",
				value = t1.OpenFaeTrialUpsellAction.jsonDecode(t656.openFaeTrialUpsellAction)
			}
		end

		if t656.refresh_omni_recommendation_feed_item_action ~= nil then
			v5130.kind = {
				type = "refresh_omni_recommendation_feed_item_action",
				value = t1.RefreshOmniRecommendationFeedItemAction.jsonDecode(t656.refresh_omni_recommendation_feed_item_action)
			}
		end

		if t656.refreshOmniRecommendationFeedItemAction ~= nil then
			v5130.kind = {
				type = "refresh_omni_recommendation_feed_item_action",
				value = t1.RefreshOmniRecommendationFeedItemAction.jsonDecode(t656.refreshOmniRecommendationFeedItemAction)
			}
		end

		if t656.ai_overview_feedback_action ~= nil then
			v5130.kind = {
				type = "ai_overview_feedback_action",
				value = t1.AiOverviewFeedbackAction.jsonDecode(t656.ai_overview_feedback_action)
			}
		end

		if t656.aiOverviewFeedbackAction ~= nil then
			v5130.kind = {
				type = "ai_overview_feedback_action",
				value = t1.AiOverviewFeedbackAction.jsonDecode(t656.aiOverviewFeedbackAction)
			}
		end

		if t656.open_trusted_friends_upsell_modal_action ~= nil then
			v5130.kind = {
				type = "open_trusted_friends_upsell_modal_action",
				value = t1.OpenTrustedFriendsUpsellModalAction.jsonDecode(t656.open_trusted_friends_upsell_modal_action)
			}
		end

		if t656.openTrustedFriendsUpsellModalAction ~= nil then
			v5130.kind = {
				type = "open_trusted_friends_upsell_modal_action",
				value = t1.OpenTrustedFriendsUpsellModalAction.jsonDecode(t656.openTrustedFriendsUpsellModalAction)
			}
		end

		if t656.record_party_chat_conversation_upsell_acknowledgement_action ~= nil then
			v5130.kind = {
				type = "record_party_chat_conversation_upsell_acknowledgement_action",
				value = t1.RecordPartyChatConversationUpsellAcknowledgementAction.jsonDecode(t656.record_party_chat_conversation_upsell_acknowledgement_action)
			}
		end

		if t656.recordPartyChatConversationUpsellAcknowledgementAction ~= nil then
			v5130.kind = {
				type = "record_party_chat_conversation_upsell_acknowledgement_action",
				value = t1.RecordPartyChatConversationUpsellAcknowledgementAction.jsonDecode(t656.recordPartyChatConversationUpsellAcknowledgementAction)
			}
		end

		if t656.open_search_results_with_query_action ~= nil then
			v5130.kind = {
				type = "open_search_results_with_query_action",
				value = t1.OpenSearchResultsWithQueryAction.jsonDecode(t656.open_search_results_with_query_action)
			}
		end

		if t656.openSearchResultsWithQueryAction ~= nil then
			v5130.kind = {
				type = "open_search_results_with_query_action",
				value = t1.OpenSearchResultsWithQueryAction.jsonDecode(t656.openSearchResultsWithQueryAction)
			}
		end

		if t656.select_marketplace_favorites_category ~= nil then
			v5130.kind = {
				type = "select_marketplace_favorites_category",
				value = t1.SelectMarketplaceFavoritesCategory.jsonDecode(t656.select_marketplace_favorites_category)
			}
		end

		if t656.selectMarketplaceFavoritesCategory ~= nil then
			v5130.kind = {
				type = "select_marketplace_favorites_category",
				value = t1.SelectMarketplaceFavoritesCategory.jsonDecode(t656.selectMarketplaceFavoritesCategory)
			}
		end

		if t656.download_app_action ~= nil then
			v5130.kind = {
				type = "download_app_action",
				value = t1.DownloadAppAction.jsonDecode(t656.download_app_action)
			}
		end

		if t656.downloadAppAction ~= nil then
			v5130.kind = {
				type = "download_app_action",
				value = t1.DownloadAppAction.jsonDecode(t656.downloadAppAction)
			}
		end

		if t656.refresh_charts_sort_detail_action ~= nil then
			v5130.kind = {
				type = "refresh_charts_sort_detail_action",
				value = t1.RefreshChartsSortDetailAction.jsonDecode(t656.refresh_charts_sort_detail_action)
			}
		end

		if t656.refreshChartsSortDetailAction ~= nil then
			v5130.kind = {
				type = "refresh_charts_sort_detail_action",
				value = t1.RefreshChartsSortDetailAction.jsonDecode(t656.refreshChartsSortDetailAction)
			}
		end

		if t656.join_community_action ~= nil then
			v5130.kind = {
				type = "join_community_action",
				value = t1.JoinCommunityAction.jsonDecode(t656.join_community_action)
			}
		end

		if t656.joinCommunityAction ~= nil then
			v5130.kind = {
				type = "join_community_action",
				value = t1.JoinCommunityAction.jsonDecode(t656.joinCommunityAction)
			}
		end

		if t656.view_community_action ~= nil then
			v5130.kind = {
				type = "view_community_action",
				value = t1.ViewCommunityAction.jsonDecode(t656.view_community_action)
			}
		end

		if t656.viewCommunityAction ~= nil then
			v5130.kind = {
				type = "view_community_action",
				value = t1.ViewCommunityAction.jsonDecode(t656.viewCommunityAction)
			}
		end

		if t656.pin_experience_shortcut_action ~= nil then
			v5130.kind = {
				type = "pin_experience_shortcut_action",
				value = t1.PinExperienceShortcutAction.jsonDecode(t656.pin_experience_shortcut_action)
			}
		end

		if t656.pinExperienceShortcutAction ~= nil then
			v5130.kind = {
				type = "pin_experience_shortcut_action",
				value = t1.PinExperienceShortcutAction.jsonDecode(t656.pinExperienceShortcutAction)
			}
		end

		if t656.select_marketplace_favorites_subcategory ~= nil then
			v5130.kind = {
				type = "select_marketplace_favorites_subcategory",
				value = t1.SelectMarketplaceFavoritesSubcategory.jsonDecode(t656.select_marketplace_favorites_subcategory)
			}
		end

		if t656.selectMarketplaceFavoritesSubcategory ~= nil then
			v5130.kind = {
				type = "select_marketplace_favorites_subcategory",
				value = t1.SelectMarketplaceFavoritesSubcategory.jsonDecode(t656.selectMarketplaceFavoritesSubcategory)
			}
		end

		if t656.show_toast_action ~= nil then
			v5130.kind = {
				type = "show_toast_action",
				value = t1.ShowToastAction.jsonDecode(t656.show_toast_action)
			}
		end

		if t656.showToastAction ~= nil then
			v5130.kind = {
				type = "show_toast_action",
				value = t1.ShowToastAction.jsonDecode(t656.showToastAction)
			}
		end

		if t656.open_incoming_transfer_upsell_action ~= nil then
			v5130.kind = {
				type = "open_incoming_transfer_upsell_action",
				value = t1.OpenIncomingTransferUpsellAction.jsonDecode(t656.open_incoming_transfer_upsell_action)
			}
		end

		if t656.openIncomingTransferUpsellAction ~= nil then
			v5130.kind = {
				type = "open_incoming_transfer_upsell_action",
				value = t1.OpenIncomingTransferUpsellAction.jsonDecode(t656.openIncomingTransferUpsellAction)
			}
		end

		if t656.action_sequence_action ~= nil then
			v5130.kind = {
				type = "action_sequence_action",
				value = t1.ActionSequenceAction.jsonDecode(t656.action_sequence_action)
			}
		end

		if t656.actionSequenceAction ~= nil then
			v5130.kind = {
				type = "action_sequence_action",
				value = t1.ActionSequenceAction.jsonDecode(t656.actionSequenceAction)
			}
		end

		if t656.telemetry_handler ~= nil then
			v5130.telemetry_handler = prop_types.StringProp.jsonDecode(t656.telemetry_handler)
		end

		if t656.telemetryHandler ~= nil then
			v5130.telemetry_handler = prop_types.StringProp.jsonDecode(t656.telemetryHandler)
		end

		if t656.accessibility_label ~= nil then
			v5130.accessibility_label = prop_types.StringFormat.jsonDecode(t656.accessibility_label)
		end

		if t656.accessibilityLabel ~= nil then
			v5130.accessibility_label = prop_types.StringFormat.jsonDecode(t656.accessibilityLabel)
		end

		if t656.skip_unified_logging ~= nil then
			v5130.skip_unified_logging = prop_types.BoolProp.jsonDecode(t656.skip_unified_logging)
		end

		if t656.skipUnifiedLogging ~= nil then
			v5130.skip_unified_logging = prop_types.BoolProp.jsonDecode(t656.skipUnifiedLogging)
		end

		return v5130
	end

	t653.descriptor = {
		name = "Action",
		fullName = "roblox.apppageplatform.shared.v1beta1.Action"
	}
	t1.Action = t653
end

typeRegistry.default:register(t1.Action)

do
	local t657 = {}

	t657.__index = t657

	function t657.new(t658: {[any]: any}?) -- line: 32214
		-- upvalues: t657 (copy)
		return (setmetatable({
			kind = if t658 ~= nil and t658.kind ~= nil then t658.kind else nil
		}, t657))
	end
	function t657.encode(p493) -- line: 32220
		-- upvalues: proto (copy)
		local buf = buffer.create(0)
		local n326 = 0

		if p493.kind ~= nil then
			if p493.kind.type == "value" then
				local v5135 = p493.kind.value:encode()
				local v5136, v5137 = proto.writeTag(buf, n326, 1, proto.wireTypes.lengthDelimited)

				buf, n326 = proto.writeBuffer(v5136, v5137, v5135, buffer.len(v5135))
			elseif p493.kind.type == "conditional" then
				local v5138 = p493.kind.value:encode()
				local v5139, v5140 = proto.writeTag(buf, n326, 2, proto.wireTypes.lengthDelimited)

				buf, n326 = proto.writeBuffer(v5139, v5140, v5138, buffer.len(v5138))
			end
		end

		local buf166 = buffer.create(n326)

		buffer.copy(buf166, 0, buf, 0, n326)

		return buf166
	end
	function t657.decode(p494: buffer) -- line: 32241
		-- upvalues: t657 (copy), proto (copy), t1 (copy)
		local v5143 = t657.new()
		local n327 = 0

		while n327 < buffer.len(p494) do
			local v5145, v5146

			v5145, v5146, n327 = proto.readTag(p494, n327)

			if v5146 == proto.wireTypes.varint then
				local v5147

				v5147, n327 = proto.readVarInt(p494, n327)
			elseif v5146 == proto.wireTypes.lengthDelimited then
				if v5145 == 1 then
					local v5148

					v5148, n327 = proto.readBuffer(p494, n327)
					v5143.kind = {
						type = "value",
						value = t1.Action.decode(v5148)
					}
				elseif v5145 == 2 then
					local v5149

					v5149, n327 = proto.readBuffer(p494, n327)
					v5143.kind = {
						type = "conditional",
						value = t1.ActionProp_ConditionalOptions.decode(v5149)
					}
				else
					local v5150, v5151 = proto.readVarInt(p494, n327)

					n327 = v5151 + v5150
				end
			elseif v5146 == proto.wireTypes.i32 then
				local v5152

				v5152, n327 = proto.readFixed32(p494, n327)
			elseif v5146 == proto.wireTypes.i64 then
				local v5153

				v5153, n327 = proto.readFixed64(p494, n327)
			else
				error("Unsupported wire type: " .. v5146)
			end
		end

		return v5143
	end
	function t657.jsonEncode(p495) -- line: 32289
		local t659 = {}

		if p495.kind ~= nil then
			if p495.kind.type == "value" then
				t659.value = p495.kind.value:jsonEncode()

				return t659
			end

			if p495.kind.type == "conditional" then
				t659.conditional = p495.kind.value:jsonEncode()
			end
		end

		return t659
	end
	function t657.jsonDecode(t660: {[any]: any}) -- line: 32303
		-- upvalues: t657 (copy), t1 (copy)
		local v5157 = t657.new()

		if t660.value ~= nil then
			v5157.kind = {
				type = "value",
				value = t1.Action.jsonDecode(t660.value)
			}
		end

		if t660.conditional ~= nil then
			v5157.kind = {
				type = "conditional",
				value = t1.ActionProp_ConditionalOptions.jsonDecode(t660.conditional)
			}
		end

		return v5157
	end

	t657.descriptor = {
		name = "ActionProp",
		fullName = "roblox.apppageplatform.shared.v1beta1.ActionProp"
	}
	t1.ActionProp = t657
	typeRegistry.default:register(t1.ActionProp)

	local t661 = {}

	t661.__index = t661

	function t661.new(t662: {[any]: any}?) -- line: 32332
		-- upvalues: t661 (copy)
		return (setmetatable({
			condition = if t662 ~= nil and t662.condition ~= nil then t662.condition else nil,
			kind = if t662 ~= nil and t662.kind ~= nil then t662.kind else nil
		}, t661))
	end
	function t661.encode(p496) -- line: 32341
		-- upvalues: proto (copy)
		local buf = buffer.create(0)
		local n328 = 0

		if p496.condition ~= nil then
			local v5162 = p496.condition:encode()
			local v5163, v5164 = proto.writeTag(buf, n328, 1, proto.wireTypes.lengthDelimited)

			buf, n328 = proto.writeBuffer(v5163, v5164, v5162, buffer.len(v5162))
		end

		if p496.kind ~= nil and p496.kind.type == "value" then
			local v5165 = p496.kind.value:encode()
			local v5166, v5167 = proto.writeTag(buf, n328, 3, proto.wireTypes.lengthDelimited)

			buf, n328 = proto.writeBuffer(v5166, v5167, v5165, buffer.len(v5165))
		end

		local buf167 = buffer.create(n328)

		buffer.copy(buf167, 0, buf, 0, n328)

		return buf167
	end
	function t661.decode(p497: buffer) -- line: 32364
		-- upvalues: t661 (copy), proto (copy), prop_condition (copy), t1 (copy)
		local v5170 = t661.new()
		local n329 = 0

		while n329 < buffer.len(p497) do
			local v5172, v5173

			v5172, v5173, n329 = proto.readTag(p497, n329)

			if v5173 == proto.wireTypes.varint then
				local v5174

				v5174, n329 = proto.readVarInt(p497, n329)
			elseif v5173 == proto.wireTypes.lengthDelimited then
				if v5172 == 1 then
					local v5175

					v5175, n329 = proto.readBuffer(p497, n329)
					v5170.condition = prop_condition.PropCondition.decode(v5175)
				elseif v5172 == 3 then
					local v5176

					v5176, n329 = proto.readBuffer(p497, n329)
					v5170.kind = {
						type = "value",
						value = t1.Action.decode(v5176)
					}
				else
					local v5177, v5178 = proto.readVarInt(p497, n329)

					n329 = v5178 + v5177
				end
			elseif v5173 == proto.wireTypes.i32 then
				local v5179

				v5179, n329 = proto.readFixed32(p497, n329)
			elseif v5173 == proto.wireTypes.i64 then
				local v5180

				v5180, n329 = proto.readFixed64(p497, n329)
			else
				error("Unsupported wire type: " .. v5173)
			end
		end

		return v5170
	end
	function t661.jsonEncode(p498) -- line: 32412
		local t663 = {}

		if p498.condition ~= nil then
			t663.condition = p498.condition:jsonEncode()
		end

		if p498.kind ~= nil and p498.kind.type == "value" then
			t663.value = p498.kind.value:jsonEncode()
		end

		return t663
	end
	function t661.jsonDecode(t664: {[any]: any}) -- line: 32428
		-- upvalues: t661 (copy), prop_condition (copy), t1 (copy)
		local v5184 = t661.new()

		if t664.condition ~= nil then
			v5184.condition = prop_condition.PropCondition.jsonDecode(t664.condition)
		end

		if t664.value ~= nil then
			v5184.kind = {
				type = "value",
				value = t1.Action.jsonDecode(t664.value)
			}
		end

		return v5184
	end

	t661.descriptor = {
		name = "ActionProp_ConditionalOption",
		fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
	}
	t1.ActionProp_ConditionalOption = t661
	typeRegistry.default:register(t1.ActionProp_ConditionalOption)

	local t665 = {}

	t665.__index = t665

	function t665.new(t666: {[any]: any}?) -- line: 32457
		-- upvalues: t665 (copy)
		return (setmetatable({
			options = if t666 ~= nil and t666.options ~= nil then t666.options else {}
		}, t665))
	end
	function t665.encode(p499) -- line: 32465
		-- upvalues: proto (copy)
		local buf = buffer.create(0)
		local n330 = 0

		if p499.options ~= nil and #p499.options > 0 then
			for _, v5190 in p499.options do
				local v5191 = v5190:encode()
				local v5192, v5193 = proto.writeTag(buf, n330, 1, proto.wireTypes.lengthDelimited)

				buf, n330 = proto.writeBuffer(v5192, v5193, v5191, buffer.len(v5191))
			end
		end

		local buf168 = buffer.create(n330)

		buffer.copy(buf168, 0, buf, 0, n330)

		return buf168
	end
	function t665.decode(p500: buffer) -- line: 32482
		-- upvalues: t665 (copy), proto (copy), t1 (copy)
		local v5196 = t665.new()
		local n331 = 0

		while n331 < buffer.len(p500) do
			local v5198, v5199

			v5198, v5199, n331 = proto.readTag(p500, n331)

			if v5199 == proto.wireTypes.varint then
				local v5200

				v5200, n331 = proto.readVarInt(p500, n331)
			elseif v5199 == proto.wireTypes.lengthDelimited then
				if v5198 == 1 then
					local v5201

					v5201, n331 = proto.readBuffer(p500, n331)
					table.insert(v5196.options, t1.ActionProp_ConditionalOption.decode(v5201))
				else
					local v5202, v5203 = proto.readVarInt(p500, n331)

					n331 = v5203 + v5202
				end
			elseif v5199 == proto.wireTypes.i32 then
				local v5204

				v5204, n331 = proto.readFixed32(p500, n331)
			elseif v5199 == proto.wireTypes.i64 then
				local v5205

				v5205, n331 = proto.readFixed64(p500, n331)
			else
				error("Unsupported wire type: " .. v5199)
			end
		end

		return v5196
	end
	function t665.jsonEncode(p501) -- line: 32525
		local t667 = {}

		if p501.options ~= nil and #p501.options > 0 then
			local t668 = {}

			for _, v5210 in p501.options do
				table.insert(t668, v5210:jsonEncode())
			end

			t667.options = t668
		end

		return t667
	end
	function t665.jsonDecode(t669: {[any]: any}) -- line: 32539
		-- upvalues: t665 (copy), t1 (copy)
		local v5212 = t665.new()

		if t669.options ~= nil then
			local t670 = {}

			for _, v5215 in t669.options do
				table.insert(t670, t1.ActionProp_ConditionalOption.jsonDecode(v5215))
			end

			v5212.options = t670
		end

		return v5212
	end

	t665.descriptor = {
		name = "ActionProp_ConditionalOptions",
		fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
	}
	t1.ActionProp_ConditionalOptions = t665
	typeRegistry.default:register(t1.ActionProp_ConditionalOptions)

	local t671 = {}

	t671.__index = t671

	function t671.new(t672: {[any]: any}?) -- line: 32568
		-- upvalues: t671 (copy)
		return (setmetatable({
			kind = if t672 ~= nil and t672.kind ~= nil then t672.kind else nil
		}, t671))
	end
	function t671.encode(p502) -- line: 32574
		-- upvalues: proto (copy)
		local buf = buffer.create(0)
		local n332 = 0

		if p502.kind ~= nil then
			if p502.kind.type == "literal" then
				local v5220 = p502.kind.value:encode()
				local v5221, v5222 = proto.writeTag(buf, n332, 1, proto.wireTypes.lengthDelimited)

				buf, n332 = proto.writeBuffer(v5221, v5222, v5220, buffer.len(v5220))
			elseif p502.kind.type == "conditional" then
				local v5223 = p502.kind.value:encode()
				local v5224, v5225 = proto.writeTag(buf, n332, 2, proto.wireTypes.lengthDelimited)

				buf, n332 = proto.writeBuffer(v5224, v5225, v5223, buffer.len(v5223))
			elseif p502.kind.type == "binding_path" then
				local v5226, v5227 = proto.writeTag(buf, n332, 3, proto.wireTypes.lengthDelimited)

				buf, n332 = proto.writeString(v5226, v5227, p502.kind.value)
			end
		end

		local buf169 = buffer.create(n332)

		buffer.copy(buf169, 0, buf, 0, n332)

		return buf169
	end
	function t671.decode(p503: buffer) -- line: 32598
		-- upvalues: t671 (copy), proto (copy), t1 (copy)
		local v5230 = t671.new()
		local n333 = 0

		while n333 < buffer.len(p503) do
			local v5232, v5233

			v5232, v5233, n333 = proto.readTag(p503, n333)

			if v5233 == proto.wireTypes.varint then
				local v5234

				v5234, n333 = proto.readVarInt(p503, n333)
			elseif v5233 == proto.wireTypes.lengthDelimited then
				if v5232 == 1 then
					local v5235

					v5235, n333 = proto.readBuffer(p503, n333)
					v5230.kind = {
						type = "literal",
						value = t1.FocusNavActionsProp_FocusNavData.decode(v5235)
					}
				elseif v5232 == 2 then
					local v5236

					v5236, n333 = proto.readBuffer(p503, n333)
					v5230.kind = {
						type = "conditional",
						value = t1.FocusNavActionsProp_ConditionalOptions.decode(v5236)
					}
				elseif v5232 == 3 then
					local v5237

					v5237, n333 = proto.readBuffer(p503, n333)
					v5230.kind = {
						type = "binding_path",
						value = buffer.tostring(v5237)
					}
				else
					local v5238, v5239 = proto.readVarInt(p503, n333)

					n333 = v5239 + v5238
				end
			elseif v5233 == proto.wireTypes.i32 then
				local v5240

				v5240, n333 = proto.readFixed32(p503, n333)
			elseif v5233 == proto.wireTypes.i64 then
				local v5241

				v5241, n333 = proto.readFixed64(p503, n333)
			else
				error("Unsupported wire type: " .. v5233)
			end
		end

		return v5230
	end
	function t671.jsonEncode(p504) -- line: 32652
		local t673 = {}

		if p504.kind ~= nil then
			if p504.kind.type == "literal" then
				t673.literal = p504.kind.value:jsonEncode()

				return t673
			end

			if p504.kind.type == "conditional" then
				t673.conditional = p504.kind.value:jsonEncode()

				return t673
			end

			if p504.kind.type == "binding_path" then
				t673.bindingPath = p504.kind.value
			end
		end

		return t673
	end
	function t671.jsonDecode(t674: {[any]: any}) -- line: 32668
		-- upvalues: t671 (copy), t1 (copy)
		local v5245 = t671.new()

		if t674.literal ~= nil then
			v5245.kind = {
				type = "literal",
				value = t1.FocusNavActionsProp_FocusNavData.jsonDecode(t674.literal)
			}
		end

		if t674.conditional ~= nil then
			v5245.kind = {
				type = "conditional",
				value = t1.FocusNavActionsProp_ConditionalOptions.jsonDecode(t674.conditional)
			}
		end

		if t674.binding_path ~= nil then
			v5245.kind = {
				type = "binding_path",
				value = t674.binding_path
			}
		end

		if t674.bindingPath ~= nil then
			v5245.kind = {
				type = "binding_path",
				value = t674.bindingPath
			}
		end

		return v5245
	end

	t671.descriptor = {
		name = "FocusNavActionsProp",
		fullName = "roblox.apppageplatform.shared.v1beta1.FocusNavActionsProp"
	}
	t1.FocusNavActionsProp = t671
end

typeRegistry.default:register(t1.FocusNavActionsProp)

local t675 = {}

t675.__index = t675

function t675.new(t676: {[any]: any}?) -- line: 32708
	-- upvalues: t675 (copy)
	return (setmetatable({
		condition = if t676 ~= nil and t676.condition ~= nil then t676.condition else nil,
		kind = if t676 ~= nil and t676.kind ~= nil then t676.kind else nil
	}, t675))
end
function t675.encode(p505) -- line: 32717
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n334 = 0

	if p505.condition ~= nil then
		local v5250 = p505.condition:encode()
		local v5251, v5252 = proto.writeTag(buf, n334, 1, proto.wireTypes.lengthDelimited)

		buf, n334 = proto.writeBuffer(v5251, v5252, v5250, buffer.len(v5250))
	end

	if p505.kind ~= nil then
		if p505.kind.type == "literal" then
			local v5253 = p505.kind.value:encode()
			local v5254, v5255 = proto.writeTag(buf, n334, 3, proto.wireTypes.lengthDelimited)

			buf, n334 = proto.writeBuffer(v5254, v5255, v5253, buffer.len(v5253))
		elseif p505.kind.type == "binding_path" then
			local v5256, v5257 = proto.writeTag(buf, n334, 4, proto.wireTypes.lengthDelimited)

			buf, n334 = proto.writeString(v5256, v5257, p505.kind.value)
		end
	end

	local buf170 = buffer.create(n334)

	buffer.copy(buf170, 0, buf, 0, n334)

	return buf170
end
function t675.decode(p506: buffer) -- line: 32743
	-- upvalues: t675 (copy), proto (copy), prop_condition (copy), t1 (copy)
	local v5260 = t675.new()
	local n335 = 0

	while n335 < buffer.len(p506) do
		local v5262, v5263

		v5262, v5263, n335 = proto.readTag(p506, n335)

		if v5263 == proto.wireTypes.varint then
			local v5264

			v5264, n335 = proto.readVarInt(p506, n335)
		elseif v5263 == proto.wireTypes.lengthDelimited then
			if v5262 == 1 then
				local v5265

				v5265, n335 = proto.readBuffer(p506, n335)
				v5260.condition = prop_condition.PropCondition.decode(v5265)
			elseif v5262 == 3 then
				local v5266

				v5266, n335 = proto.readBuffer(p506, n335)
				v5260.kind = {
					type = "literal",
					value = t1.FocusNavActionsProp_FocusNavData.decode(v5266)
				}
			elseif v5262 == 4 then
				local v5267

				v5267, n335 = proto.readBuffer(p506, n335)
				v5260.kind = {
					type = "binding_path",
					value = buffer.tostring(v5267)
				}
			else
				local v5268, v5269 = proto.readVarInt(p506, n335)

				n335 = v5269 + v5268
			end
		elseif v5263 == proto.wireTypes.i32 then
			local v5270

			v5270, n335 = proto.readFixed32(p506, n335)
		elseif v5263 == proto.wireTypes.i64 then
			local v5271

			v5271, n335 = proto.readFixed64(p506, n335)
		else
			error("Unsupported wire type: " .. v5263)
		end
	end

	return v5260
end
function t675.jsonEncode(p507) -- line: 32796
	local t677 = {}

	if p507.condition ~= nil then
		t677.condition = p507.condition:jsonEncode()
	end

	if p507.kind ~= nil then
		if p507.kind.type == "literal" then
			t677.literal = p507.kind.value:jsonEncode()

			return t677
		end

		if p507.kind.type == "binding_path" then
			t677.bindingPath = p507.kind.value
		end
	end

	return t677
end
function t675.jsonDecode(t678: {[any]: any}) -- line: 32814
	-- upvalues: t675 (copy), prop_condition (copy), t1 (copy)
	local v5275 = t675.new()

	if t678.condition ~= nil then
		v5275.condition = prop_condition.PropCondition.jsonDecode(t678.condition)
	end

	if t678.literal ~= nil then
		v5275.kind = {
			type = "literal",
			value = t1.FocusNavActionsProp_FocusNavData.jsonDecode(t678.literal)
		}
	end

	if t678.binding_path ~= nil then
		v5275.kind = {
			type = "binding_path",
			value = t678.binding_path
		}
	end

	if t678.bindingPath ~= nil then
		v5275.kind = {
			type = "binding_path",
			value = t678.bindingPath
		}
	end

	return v5275
end

t675.descriptor = {
	name = "FocusNavActionsProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.FocusNavActionsProp_ConditionalOption = t675
typeRegistry.default:register(t1.FocusNavActionsProp_ConditionalOption)

local t679 = {}

t679.__index = t679

function t679.new(t680: {[any]: any}?) -- line: 32854
	-- upvalues: t679 (copy)
	return (setmetatable({
		options = if t680 ~= nil and t680.options ~= nil then t680.options else {}
	}, t679))
end
function t679.encode(p508) -- line: 32862
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n336 = 0

	if p508.options ~= nil and #p508.options > 0 then
		for _, v5281 in p508.options do
			local v5282 = v5281:encode()
			local v5283, v5284 = proto.writeTag(buf, n336, 1, proto.wireTypes.lengthDelimited)

			buf, n336 = proto.writeBuffer(v5283, v5284, v5282, buffer.len(v5282))
		end
	end

	local buf171 = buffer.create(n336)

	buffer.copy(buf171, 0, buf, 0, n336)

	return buf171
end
function t679.decode(p509: buffer) -- line: 32879
	-- upvalues: t679 (copy), proto (copy), t1 (copy)
	local v5287 = t679.new()
	local n337 = 0

	while n337 < buffer.len(p509) do
		local v5289, v5290

		v5289, v5290, n337 = proto.readTag(p509, n337)

		if v5290 == proto.wireTypes.varint then
			local v5291

			v5291, n337 = proto.readVarInt(p509, n337)
		elseif v5290 == proto.wireTypes.lengthDelimited then
			if v5289 == 1 then
				local v5292

				v5292, n337 = proto.readBuffer(p509, n337)
				table.insert(v5287.options, t1.FocusNavActionsProp_ConditionalOption.decode(v5292))
			else
				local v5293, v5294 = proto.readVarInt(p509, n337)

				n337 = v5294 + v5293
			end
		elseif v5290 == proto.wireTypes.i32 then
			local v5295

			v5295, n337 = proto.readFixed32(p509, n337)
		elseif v5290 == proto.wireTypes.i64 then
			local v5296

			v5296, n337 = proto.readFixed64(p509, n337)
		else
			error("Unsupported wire type: " .. v5290)
		end
	end

	return v5287
end
function t679.jsonEncode(p510) -- line: 32922
	local t681 = {}

	if p510.options ~= nil and #p510.options > 0 then
		local t682 = {}

		for _, v5301 in p510.options do
			table.insert(t682, v5301:jsonEncode())
		end

		t681.options = t682
	end

	return t681
end
function t679.jsonDecode(t683: {[any]: any}) -- line: 32936
	-- upvalues: t679 (copy), t1 (copy)
	local v5303 = t679.new()

	if t683.options ~= nil then
		local t684 = {}

		for _, v5306 in t683.options do
			table.insert(t684, t1.FocusNavActionsProp_ConditionalOption.jsonDecode(v5306))
		end

		v5303.options = t684
	end

	return v5303
end

t679.descriptor = {
	name = "FocusNavActionsProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.FocusNavActionsProp_ConditionalOptions = t679
typeRegistry.default:register(t1.FocusNavActionsProp_ConditionalOptions)

local t685 = {}

t685.__index = t685

function t685.new(t686: {[any]: any}?) -- line: 32967
	-- upvalues: t685 (copy)
	return (setmetatable({
		keys = if t686 ~= nil and t686.keys ~= nil then t686.keys else {},
		events = if t686 ~= nil and t686.events ~= nil then t686.events else {}
	}, t685))
end
function t685.encode(p511) -- line: 32976
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n338 = 0

	if p511.keys ~= nil and next(p511.keys) ~= nil then
		for v5311, v5312 in p511.keys do
			local buf172 = buffer.create(0)
			local v5314, v5315 = proto.writeTag(buf172, 0, 1, proto.wireTypes.lengthDelimited)
			local v5316, v5317 = proto.writeString(v5314, v5315, v5311)
			local v5318 = v5312:encode()
			local v5319, v5320 = proto.writeTag(v5316, v5317, 2, proto.wireTypes.lengthDelimited)
			local v5321, v5322 = proto.writeBuffer(v5319, v5320, v5318, buffer.len(v5318))
			local v5323, v5324 = proto.writeTag(buf, n338, 3, proto.wireTypes.lengthDelimited)

			buf, n338 = proto.writeBuffer(v5323, v5324, v5321, v5322)
		end
	end

	if p511.events ~= nil and next(p511.events) ~= nil then
		for v5325, v5326 in p511.events do
			local buf173 = buffer.create(0)
			local v5328, v5329 = proto.writeTag(buf173, 0, 1, proto.wireTypes.lengthDelimited)
			local v5330, v5331 = proto.writeString(v5328, v5329, v5325)
			local v5332 = v5326:encode()
			local v5333, v5334 = proto.writeTag(v5330, v5331, 2, proto.wireTypes.lengthDelimited)
			local v5335, v5336 = proto.writeBuffer(v5333, v5334, v5332, buffer.len(v5332))
			local v5337, v5338 = proto.writeTag(buf, n338, 4, proto.wireTypes.lengthDelimited)

			buf, n338 = proto.writeBuffer(v5337, v5338, v5335, v5336)
		end
	end

	local buf174 = buffer.create(n338)

	buffer.copy(buf174, 0, buf, 0, n338)

	return buf174
end
function t685.decode(p512: buffer) -- line: 33013
	-- upvalues: t685 (copy), proto (copy), t1 (copy), prop_types_engine (copy)
	local v5341 = t685.new()
	local n339 = 0

	while n339 < buffer.len(p512) do
		local v5343, v5344

		v5343, v5344, n339 = proto.readTag(p512, n339)

		if v5344 == proto.wireTypes.varint then
			local v5345

			v5345, n339 = proto.readVarInt(p512, n339)
		elseif v5344 == proto.wireTypes.lengthDelimited then
			if v5343 == 3 then
				local v5346

				v5346, n339 = proto.readBuffer(p512, n339)

				local v5347 = t1.FocusNavActionsProp_FocusNavData_KeysEntry.decode(v5346)
				local v5348 = prop_types_engine.KeyCodeProp.new()

				v5341.keys[v5347.key or ""] = v5347.value or v5348
			elseif v5343 == 4 then
				local v5349

				v5349, n339 = proto.readBuffer(p512, n339)

				local v5350 = t1.FocusNavActionsProp_FocusNavData_EventsEntry.decode(v5349)
				local v5351 = t1.ActionProp.new()

				v5341.events[v5350.key or ""] = v5350.value or v5351
			else
				local v5352, v5353 = proto.readVarInt(p512, n339)

				n339 = v5353 + v5352
			end
		elseif v5344 == proto.wireTypes.i32 then
			local v5354

			v5354, n339 = proto.readFixed32(p512, n339)
		elseif v5344 == proto.wireTypes.i64 then
			local v5355

			v5355, n339 = proto.readFixed64(p512, n339)
		else
			error("Unsupported wire type: " .. v5344)
		end
	end

	return v5341
end
function t685.jsonEncode(p513) -- line: 33075
	local t687 = {}

	if p513.keys ~= nil and next(p513.keys) ~= nil then
		local t688 = {}

		for v5359, v5360 in p513.keys do
			t688[v5359] = v5360:jsonEncode()
		end

		t687.keys = t688
	end

	if p513.events ~= nil and next(p513.events) ~= nil then
		local t689 = {}

		for v5362, v5363 in p513.events do
			t689[v5362] = v5363:jsonEncode()
		end

		t687.events = t689
	end

	return t687
end
function t685.jsonDecode(t690: {[any]: any}) -- line: 33097
	-- upvalues: t685 (copy), prop_types_engine (copy), t1 (copy)
	local v5365 = t685.new()

	if t690.keys ~= nil then
		local t691 = {}

		for v5367, v5368 in t690.keys do
			t691[v5367] = prop_types_engine.KeyCodeProp.jsonDecode(v5368)
		end

		v5365.keys = t691
	end

	if t690.events ~= nil then
		local t692 = {}

		for v5370, v5371 in t690.events do
			t692[v5370] = t1.ActionProp.jsonDecode(v5371)
		end

		v5365.events = t692
	end

	return v5365
end

t685.descriptor = {
	name = "FocusNavActionsProp_FocusNavData",
	fullName = "roblox.apppageplatform.shared.v1beta1.FocusNavData"
}
t1.FocusNavActionsProp_FocusNavData = t685
typeRegistry.default:register(t1.FocusNavActionsProp_FocusNavData)

local t693 = {}

t693.__index = t693

function t693.new(t694: {[any]: any}?) -- line: 33137
	-- upvalues: t693 (copy)
	return (setmetatable({
		key = if t694 ~= nil and t694.key ~= nil then t694.key else "",
		value = if t694 ~= nil and t694.value ~= nil then t694.value else nil
	}, t693))
end
function t693.encode(p514) -- line: 33146
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n340 = 0

	if p514.key ~= nil and p514.key ~= "" then
		local v5376, v5377 = proto.writeTag(buf, n340, 1, proto.wireTypes.lengthDelimited)

		buf, n340 = proto.writeString(v5376, v5377, p514.key)
	end

	if p514.value ~= nil then
		local v5378 = p514.value:encode()
		local v5379, v5380 = proto.writeTag(buf, n340, 2, proto.wireTypes.lengthDelimited)

		buf, n340 = proto.writeBuffer(v5379, v5380, v5378, buffer.len(v5378))
	end

	local buf175 = buffer.create(n340)

	buffer.copy(buf175, 0, buf, 0, n340)

	return buf175
end
function t693.decode(p515: buffer) -- line: 33168
	-- upvalues: t693 (copy), proto (copy), prop_types_engine (copy)
	local v5383 = t693.new()
	local n341 = 0

	while n341 < buffer.len(p515) do
		local v5385, v5386

		v5385, v5386, n341 = proto.readTag(p515, n341)

		if v5386 == proto.wireTypes.varint then
			local v5387

			v5387, n341 = proto.readVarInt(p515, n341)
		elseif v5386 == proto.wireTypes.lengthDelimited then
			if v5385 == 1 then
				local v5388

				v5388, n341 = proto.readBuffer(p515, n341)
				v5383.key = buffer.tostring(v5388)
			elseif v5385 == 2 then
				local v5389

				v5389, n341 = proto.readBuffer(p515, n341)
				v5383.value = prop_types_engine.KeyCodeProp.decode(v5389)
			else
				local v5390, v5391 = proto.readVarInt(p515, n341)

				n341 = v5391 + v5390
			end
		elseif v5386 == proto.wireTypes.i32 then
			local v5392

			v5392, n341 = proto.readFixed32(p515, n341)
		elseif v5386 == proto.wireTypes.i64 then
			local v5393

			v5393, n341 = proto.readFixed64(p515, n341)
		else
			error("Unsupported wire type: " .. v5386)
		end
	end

	return v5383
end
function t693.jsonEncode(p516) -- line: 33218
	local t695 = {}

	if p516.key ~= nil and p516.key ~= "" then
		t695.key = p516.key
	end

	if p516.value ~= nil then
		t695.value = p516.value:jsonEncode()
	end

	return t695
end
function t693.jsonDecode(t696: {[any]: any}) -- line: 33234
	-- upvalues: t693 (copy), prop_types_engine (copy)
	local v5397 = t693.new()

	if t696.key ~= nil then
		v5397.key = t696.key
	end

	if t696.value ~= nil then
		v5397.value = prop_types_engine.KeyCodeProp.jsonDecode(t696.value)
	end

	return v5397
end

t693.descriptor = {
	name = "FocusNavActionsProp_FocusNavData_KeysEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.KeysEntry"
}
t1.FocusNavActionsProp_FocusNavData_KeysEntry = t693
typeRegistry.default:register(t1.FocusNavActionsProp_FocusNavData_KeysEntry)

local t697 = {}

t697.__index = t697

function t697.new(t698: {[any]: any}?) -- line: 33264
	-- upvalues: t697 (copy)
	return (setmetatable({
		key = if t698 ~= nil and t698.key ~= nil then t698.key else "",
		value = if t698 ~= nil and t698.value ~= nil then t698.value else nil
	}, t697))
end
function t697.encode(p517) -- line: 33273
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n342 = 0

	if p517.key ~= nil and p517.key ~= "" then
		local v5402, v5403 = proto.writeTag(buf, n342, 1, proto.wireTypes.lengthDelimited)

		buf, n342 = proto.writeString(v5402, v5403, p517.key)
	end

	if p517.value ~= nil then
		local v5404 = p517.value:encode()
		local v5405, v5406 = proto.writeTag(buf, n342, 2, proto.wireTypes.lengthDelimited)

		buf, n342 = proto.writeBuffer(v5405, v5406, v5404, buffer.len(v5404))
	end

	local buf176 = buffer.create(n342)

	buffer.copy(buf176, 0, buf, 0, n342)

	return buf176
end
function t697.decode(p518: buffer) -- line: 33295
	-- upvalues: t697 (copy), proto (copy), t1 (copy)
	local v5409 = t697.new()
	local n343 = 0

	while n343 < buffer.len(p518) do
		local v5411, v5412

		v5411, v5412, n343 = proto.readTag(p518, n343)

		if v5412 == proto.wireTypes.varint then
			local v5413

			v5413, n343 = proto.readVarInt(p518, n343)
		elseif v5412 == proto.wireTypes.lengthDelimited then
			if v5411 == 1 then
				local v5414

				v5414, n343 = proto.readBuffer(p518, n343)
				v5409.key = buffer.tostring(v5414)
			elseif v5411 == 2 then
				local v5415

				v5415, n343 = proto.readBuffer(p518, n343)
				v5409.value = t1.ActionProp.decode(v5415)
			else
				local v5416, v5417 = proto.readVarInt(p518, n343)

				n343 = v5417 + v5416
			end
		elseif v5412 == proto.wireTypes.i32 then
			local v5418

			v5418, n343 = proto.readFixed32(p518, n343)
		elseif v5412 == proto.wireTypes.i64 then
			local v5419

			v5419, n343 = proto.readFixed64(p518, n343)
		else
			error("Unsupported wire type: " .. v5412)
		end
	end

	return v5409
end
function t697.jsonEncode(p519) -- line: 33345
	local t699 = {}

	if p519.key ~= nil and p519.key ~= "" then
		t699.key = p519.key
	end

	if p519.value ~= nil then
		t699.value = p519.value:jsonEncode()
	end

	return t699
end
function t697.jsonDecode(t700: {[any]: any}) -- line: 33361
	-- upvalues: t697 (copy), t1 (copy)
	local v5423 = t697.new()

	if t700.key ~= nil then
		v5423.key = t700.key
	end

	if t700.value ~= nil then
		v5423.value = t1.ActionProp.jsonDecode(t700.value)
	end

	return v5423
end

t697.descriptor = {
	name = "FocusNavActionsProp_FocusNavData_EventsEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventsEntry"
}
t1.FocusNavActionsProp_FocusNavData_EventsEntry = t697
typeRegistry.default:register(t1.FocusNavActionsProp_FocusNavData_EventsEntry)
t1.ActionType = {
	fromNumber = function(n344: number) -- line: 33388
		if n344 == 0 then
			return "ACTION_TYPE_INVALID"
		end

		if n344 == 1 then
			return "ACTION_TYPE_DISMISS_DIALOG"
		end

		if n344 == 2 then
			return "ACTION_TYPE_LINK"
		end

		if n344 == 3 then
			return "ACTION_TYPE_OPEN_GAME_DETAILS"
		end

		if n344 == 4 then
			return "ACTION_TYPE_OPEN_JOIN_FRIENDS"
		end

		if n344 == 5 then
			return "ACTION_TYPE_OPEN_MARKETPLACE_TRY_ON"
		end

		if n344 == 6 then
			return "ACTION_TYPE_OPEN_SEE_ALL"
		end

		if n344 == 7 then
			return "ACTION_TYPE_OPEN_SPONSORED_TOOLTIP"
		end

		if n344 == 8 then
			return "ACTION_TYPE_PLAY_BUTTON_CLICK"
		end

		if n344 == 9 then
			return "ACTION_TYPE_UPDATE_USER_SETTINGS"
		end

		if n344 == 10 then
			return "ACTION_TYPE_OPEN_TOOLTIP"
		end

		if n344 == 11 then
			return "ACTION_TYPE_OPEN_BADGE_DETAILS"
		end

		if n344 == 12 then
			return "ACTION_TYPE_LOAD_MORE_FROM_API"
		end

		if n344 == 13 then
			return "ACTION_TYPE_SHARE"
		end

		if n344 == 14 then
			return "ACTION_TYPE_OPEN_ABUSE_REPORT"
		end

		if n344 == 15 then
			return "ACTION_TYPE_REMOVE_BADGE_FROM_INVENTORY"
		end

		if n344 == 16 then
			return "ACTION_TYPE_OPEN_PROFILE"
		end

		if n344 == 17 then
			return "ACTION_TYPE_OPEN_FACIAL_AGE_ESTIMATION"
		end

		if n344 == 18 then
			return "ACTION_TYPE_OPEN_ADD_CONNECTIONS_PAGE"
		end

		if n344 == 19 then
			return "ACTION_TYPE_OPEN_MARKETPLACE"
		end

		if n344 == 20 then
			return "ACTION_TYPE_HIDE_PROFILE_COMPLETION"
		end

		if n344 == 21 then
			return "ACTION_TYPE_SELECT_MARKETPLACE_CATALOG_CATEGORY"
		end

		if n344 == 22 then
			return "ACTION_TYPE_SELECT_MARKETPLACE_CATALOG_SUBCATEGORY"
		end

		if n344 == 23 then
			return "ACTION_TYPE_OPEN_MARKETPLACE_CATALOG_SEE_ALL"
		end

		if n344 == 24 then
			return "ACTION_TYPE_CLOSE_MARKETPLACE_CATEGORY_TOOLTIP"
		end

		if n344 == 25 then
			return "ACTION_TYPE_RESIZE_MARKETPLACE_CATALOG"
		end

		if n344 == 26 then
			return "ACTION_TYPE_OPEN_MARKETPLACE_CATALOG_FILTERS"
		end

		if n344 == 27 then
			return "ACTION_TYPE_OPEN_SOCIAL_LINK"
		end

		if n344 == 28 then
			return "ACTION_TYPE_OPEN_CHARTS_SORT_DETAIL"
		end

		if n344 == 29 then
			return "ACTION_TYPE_OPEN_SONG_DETAIL"
		end

		if n344 == 30 then
			return "ACTION_TYPE_REFRESH_FROM_API"
		end

		if n344 == 31 then
			return "ACTION_TYPE_RSVP_TO_EVENT"
		end

		if n344 == 32 then
			return "ACTION_TYPE_APPLY_CHARTS_FILTER"
		end

		if n344 == 33 then
			return "ACTION_TYPE_ANALYTICS_EVENT"
		end

		if n344 == 34 then
			return "ACTION_TYPE_CUSTOM_ANALYTICS_EVENT"
		end

		if n344 == 35 then
			return "ACTION_TYPE_OPEN_GAME_INVITE"
		end

		if n344 == 36 then
			return "ACTION_TYPE_OPEN_EVENT_DETAILS"
		end

		if n344 == 37 then
			return "ACTION_TYPE_LAUNCH_EXPERIENCE"
		end

		if n344 == 38 then
			return "ACTION_TYPE_TOGGLE_EXPERIENCE_FAVORITE"
		end

		if n344 == 39 then
			return "ACTION_TYPE_TOGGLE_EXPERIENCE_FOLLOW"
		end

		if n344 == 40 then
			return "ACTION_TYPE_TOGGLE_EXPERIENCE_VOTE"
		end

		if n344 == 41 then
			return "ACTION_TYPE_OPEN_PURCHASE_PROMPT"
		end

		if n344 == 42 then
			return "ACTION_TYPE_OPEN_SDUI_OVERLAY"
		end

		if n344 == 43 then
			return "ACTION_TYPE_OPEN_BADGES_SEE_ALL"
		end

		if n344 == 44 then
			return "ACTION_TYPE_OPEN_EXPERIENCE_STORE_SEE_ALL"
		end

		if n344 == 45 then
			return "ACTION_TYPE_DISMISS_GAME_FEEDBACK"
		end

		if n344 == 46 then
			return "ACTION_TYPE_OPEN_GAME_FEEDBACK_FORM"
		end

		if n344 == 47 then
			return "ACTION_TYPE_ENABLE_EVENT_NOTIFICATIONS"
		end

		if n344 == 48 then
			return "ACTION_TYPE_DISMISS_EVENT_NOTIFICATIONS_MODAL"
		end

		if n344 == 49 then
			return "ACTION_TYPE_OPEN_AMP_WIZARD"
		end

		if n344 == 50 then
			return "ACTION_TYPE_OPEN_SUBSCRIPTION_PURCHASE_PAGE"
		end

		if n344 == 51 then
			return "ACTION_TYPE_REFRESH_GAME_PASSES"
		end

		if n344 == 52 then
			return "ACTION_TYPE_REFRESH_PLAYABILITY"
		end

		if n344 == 53 then
			return "ACTION_TYPE_OPEN_SOCIAL_PROOF_USER_LIST_SHEET"
		end

		if n344 == 54 then
			return "ACTION_TYPE_REPORT_SURFACE_LOAD_TIME_MILESTONE"
		end

		if n344 == 55 then
			return "ACTION_TYPE_OPEN_SEARCH_RESULTS_TAB"
		end

		if n344 == 56 then
			return "ACTION_TYPE_OPEN_PHONE_UPSELL_MODAL"
		end

		if n344 == 57 then
			return "ACTION_TYPE_OPEN_EMAIL_UPSELL_MODAL"
		end

		if n344 == 58 then
			return "ACTION_TYPE_DISMISS_PROMPT"
		end

		if n344 == 59 then
			return "ACTION_TYPE_REQUEST_FRIENDSHIP"
		end

		if n344 == 60 then
			return "ACTION_TYPE_REFRESH_DEVELOPER_PRODUCTS"
		end

		if n344 == 61 then
			return "ACTION_TYPE_OPEN_FAE_TRIAL_UPSELL"
		end

		if n344 == 62 then
			return "ACTION_TYPE_REFRESH_OMNI_RECOMMENDATION_FEED_ITEM"
		end

		if n344 == 63 then
			return "ACTION_TYPE_AI_OVERVIEW_FEEDBACK"
		end

		if n344 == 64 then
			return "ACTION_TYPE_OPEN_TRUSTED_FRIENDS_UPSELL_MODAL"
		end

		if n344 == 65 then
			return "ACTION_TYPE_RECORD_PARTY_CHAT_CONVERSATION_UPSELL_ACKNOWLEDGEMENT"
		end

		if n344 == 66 then
			return "ACTION_TYPE_OPEN_SEARCH_RESULTS_WITH_QUERY"
		end

		if n344 == 67 then
			return "ACTION_TYPE_SELECT_MARKETPLACE_FAVORITES_CATEGORY"
		end

		if n344 == 68 then
			return "ACTION_TYPE_DOWNLOAD_APP"
		end

		if n344 == 69 then
			return "ACTION_TYPE_REFRESH_CHARTS_SORT_DETAIL"
		end

		if n344 == 70 then
			return "ACTION_TYPE_JOIN_COMMUNITY"
		end

		if n344 == 71 then
			return "ACTION_TYPE_VIEW_COMMUNITY"
		end

		if n344 == 72 then
			return "ACTION_TYPE_PIN_EXPERIENCE_SHORTCUT"
		end

		if n344 == 73 then
			return "ACTION_TYPE_SELECT_MARKETPLACE_FAVORITES_SUBCATEGORY"
		end

		if n344 == 74 then
			return "ACTION_TYPE_SHOW_TOAST"
		end

		if n344 == 75 then
			return "ACTION_TYPE_OPEN_INCOMING_TRANSFER_UPSELL"
		end

		if n344 == 76 then
			return "ACTION_TYPE_ACTION_SEQUENCE"
		end

		return nil
	end,
	toNumber = function(p520) -- line: 33548
		if p520 == "ACTION_TYPE_INVALID" then
			return 0
		end

		if p520 == "ACTION_TYPE_DISMISS_DIALOG" then
			return 1
		end

		if p520 == "ACTION_TYPE_LINK" then
			return 2
		end

		if p520 == "ACTION_TYPE_OPEN_GAME_DETAILS" then
			return 3
		end

		if p520 == "ACTION_TYPE_OPEN_JOIN_FRIENDS" then
			return 4
		end

		if p520 == "ACTION_TYPE_OPEN_MARKETPLACE_TRY_ON" then
			return 5
		end

		if p520 == "ACTION_TYPE_OPEN_SEE_ALL" then
			return 6
		end

		if p520 == "ACTION_TYPE_OPEN_SPONSORED_TOOLTIP" then
			return 7
		end

		if p520 == "ACTION_TYPE_PLAY_BUTTON_CLICK" then
			return 8
		end

		if p520 == "ACTION_TYPE_UPDATE_USER_SETTINGS" then
			return 9
		end

		if p520 == "ACTION_TYPE_OPEN_TOOLTIP" then
			return 10
		end

		if p520 == "ACTION_TYPE_OPEN_BADGE_DETAILS" then
			return 11
		end

		if p520 == "ACTION_TYPE_LOAD_MORE_FROM_API" then
			return 12
		end

		if p520 == "ACTION_TYPE_SHARE" then
			return 13
		end

		if p520 == "ACTION_TYPE_OPEN_ABUSE_REPORT" then
			return 14
		end

		if p520 == "ACTION_TYPE_REMOVE_BADGE_FROM_INVENTORY" then
			return 15
		end

		if p520 == "ACTION_TYPE_OPEN_PROFILE" then
			return 16
		end

		if p520 == "ACTION_TYPE_OPEN_FACIAL_AGE_ESTIMATION" then
			return 17
		end

		if p520 == "ACTION_TYPE_OPEN_ADD_CONNECTIONS_PAGE" then
			return 18
		end

		if p520 == "ACTION_TYPE_OPEN_MARKETPLACE" then
			return 19
		end

		if p520 == "ACTION_TYPE_HIDE_PROFILE_COMPLETION" then
			return 20
		end

		if p520 == "ACTION_TYPE_SELECT_MARKETPLACE_CATALOG_CATEGORY" then
			return 21
		end

		if p520 == "ACTION_TYPE_SELECT_MARKETPLACE_CATALOG_SUBCATEGORY" then
			return 22
		end

		if p520 == "ACTION_TYPE_OPEN_MARKETPLACE_CATALOG_SEE_ALL" then
			return 23
		end

		if p520 == "ACTION_TYPE_CLOSE_MARKETPLACE_CATEGORY_TOOLTIP" then
			return 24
		end

		if p520 == "ACTION_TYPE_RESIZE_MARKETPLACE_CATALOG" then
			return 25
		end

		if p520 == "ACTION_TYPE_OPEN_MARKETPLACE_CATALOG_FILTERS" then
			return 26
		end

		if p520 == "ACTION_TYPE_OPEN_SOCIAL_LINK" then
			return 27
		end

		if p520 == "ACTION_TYPE_OPEN_CHARTS_SORT_DETAIL" then
			return 28
		end

		if p520 == "ACTION_TYPE_OPEN_SONG_DETAIL" then
			return 29
		end

		if p520 == "ACTION_TYPE_REFRESH_FROM_API" then
			return 30
		end

		if p520 == "ACTION_TYPE_RSVP_TO_EVENT" then
			return 31
		end

		if p520 == "ACTION_TYPE_APPLY_CHARTS_FILTER" then
			return 32
		end

		if p520 == "ACTION_TYPE_ANALYTICS_EVENT" then
			return 33
		end

		if p520 == "ACTION_TYPE_CUSTOM_ANALYTICS_EVENT" then
			return 34
		end

		if p520 == "ACTION_TYPE_OPEN_GAME_INVITE" then
			return 35
		end

		if p520 == "ACTION_TYPE_OPEN_EVENT_DETAILS" then
			return 36
		end

		if p520 == "ACTION_TYPE_LAUNCH_EXPERIENCE" then
			return 37
		end

		if p520 == "ACTION_TYPE_TOGGLE_EXPERIENCE_FAVORITE" then
			return 38
		end

		if p520 == "ACTION_TYPE_TOGGLE_EXPERIENCE_FOLLOW" then
			return 39
		end

		if p520 == "ACTION_TYPE_TOGGLE_EXPERIENCE_VOTE" then
			return 40
		end

		if p520 == "ACTION_TYPE_OPEN_PURCHASE_PROMPT" then
			return 41
		end

		if p520 == "ACTION_TYPE_OPEN_SDUI_OVERLAY" then
			return 42
		end

		if p520 == "ACTION_TYPE_OPEN_BADGES_SEE_ALL" then
			return 43
		end

		if p520 == "ACTION_TYPE_OPEN_EXPERIENCE_STORE_SEE_ALL" then
			return 44
		end

		if p520 == "ACTION_TYPE_DISMISS_GAME_FEEDBACK" then
			return 45
		end

		if p520 == "ACTION_TYPE_OPEN_GAME_FEEDBACK_FORM" then
			return 46
		end

		if p520 == "ACTION_TYPE_ENABLE_EVENT_NOTIFICATIONS" then
			return 47
		end

		if p520 == "ACTION_TYPE_DISMISS_EVENT_NOTIFICATIONS_MODAL" then
			return 48
		end

		if p520 == "ACTION_TYPE_OPEN_AMP_WIZARD" then
			return 49
		end

		if p520 == "ACTION_TYPE_OPEN_SUBSCRIPTION_PURCHASE_PAGE" then
			return 50
		end

		if p520 == "ACTION_TYPE_REFRESH_GAME_PASSES" then
			return 51
		end

		if p520 == "ACTION_TYPE_REFRESH_PLAYABILITY" then
			return 52
		end

		if p520 == "ACTION_TYPE_OPEN_SOCIAL_PROOF_USER_LIST_SHEET" then
			return 53
		end

		if p520 == "ACTION_TYPE_REPORT_SURFACE_LOAD_TIME_MILESTONE" then
			return 54
		end

		if p520 == "ACTION_TYPE_OPEN_SEARCH_RESULTS_TAB" then
			return 55
		end

		if p520 == "ACTION_TYPE_OPEN_PHONE_UPSELL_MODAL" then
			return 56
		end

		if p520 == "ACTION_TYPE_OPEN_EMAIL_UPSELL_MODAL" then
			return 57
		end

		if p520 == "ACTION_TYPE_DISMISS_PROMPT" then
			return 58
		end

		if p520 == "ACTION_TYPE_REQUEST_FRIENDSHIP" then
			return 59
		end

		if p520 == "ACTION_TYPE_REFRESH_DEVELOPER_PRODUCTS" then
			return 60
		end

		if p520 == "ACTION_TYPE_OPEN_FAE_TRIAL_UPSELL" then
			return 61
		end

		if p520 == "ACTION_TYPE_REFRESH_OMNI_RECOMMENDATION_FEED_ITEM" then
			return 62
		end

		if p520 == "ACTION_TYPE_AI_OVERVIEW_FEEDBACK" then
			return 63
		end

		if p520 == "ACTION_TYPE_OPEN_TRUSTED_FRIENDS_UPSELL_MODAL" then
			return 64
		end

		if p520 == "ACTION_TYPE_RECORD_PARTY_CHAT_CONVERSATION_UPSELL_ACKNOWLEDGEMENT" then
			return 65
		end

		if p520 == "ACTION_TYPE_OPEN_SEARCH_RESULTS_WITH_QUERY" then
			return 66
		end

		if p520 == "ACTION_TYPE_SELECT_MARKETPLACE_FAVORITES_CATEGORY" then
			return 67
		end

		if p520 == "ACTION_TYPE_DOWNLOAD_APP" then
			return 68
		end

		if p520 == "ACTION_TYPE_REFRESH_CHARTS_SORT_DETAIL" then
			return 69
		end

		if p520 == "ACTION_TYPE_JOIN_COMMUNITY" then
			return 70
		end

		if p520 == "ACTION_TYPE_VIEW_COMMUNITY" then
			return 71
		end

		if p520 == "ACTION_TYPE_PIN_EXPERIENCE_SHORTCUT" then
			return 72
		end

		if p520 == "ACTION_TYPE_SELECT_MARKETPLACE_FAVORITES_SUBCATEGORY" then
			return 73
		end

		if p520 == "ACTION_TYPE_SHOW_TOAST" then
			return 74
		end

		if p520 == "ACTION_TYPE_OPEN_INCOMING_TRANSFER_UPSELL" then
			return 75
		end

		if p520 == "ACTION_TYPE_ACTION_SEQUENCE" then
			return 76
		end

		return p520
	end,
	fromName = function(s1: string) -- line: 33708
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

		if s1 == "ACTION_TYPE_REFRESH_CHARTS_SORT_DETAIL" then
			return "ACTION_TYPE_REFRESH_CHARTS_SORT_DETAIL"
		end

		if s1 == "ACTION_TYPE_JOIN_COMMUNITY" then
			return "ACTION_TYPE_JOIN_COMMUNITY"
		end

		if s1 == "ACTION_TYPE_VIEW_COMMUNITY" then
			return "ACTION_TYPE_VIEW_COMMUNITY"
		end

		if s1 == "ACTION_TYPE_PIN_EXPERIENCE_SHORTCUT" then
			return "ACTION_TYPE_PIN_EXPERIENCE_SHORTCUT"
		end

		if s1 == "ACTION_TYPE_SELECT_MARKETPLACE_FAVORITES_SUBCATEGORY" then
			return "ACTION_TYPE_SELECT_MARKETPLACE_FAVORITES_SUBCATEGORY"
		end

		if s1 == "ACTION_TYPE_SHOW_TOAST" then
			return "ACTION_TYPE_SHOW_TOAST"
		end

		if s1 == "ACTION_TYPE_OPEN_INCOMING_TRANSFER_UPSELL" then
			return "ACTION_TYPE_OPEN_INCOMING_TRANSFER_UPSELL"
		end

		if s1 == "ACTION_TYPE_ACTION_SEQUENCE" then
			return "ACTION_TYPE_ACTION_SEQUENCE"
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
	ShowToastAction = t1.ShowToastAction,
	ShowToastAction_Params = t1.ShowToastAction_Params,
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
	OpenIncomingTransferUpsellAction = t1.OpenIncomingTransferUpsellAction,
	OpenIncomingTransferUpsellAction_Params = t1.OpenIncomingTransferUpsellAction_Params,
	OpenSduiOverlayAction = t1.OpenSduiOverlayAction,
	OpenSduiOverlayAction_Params = t1.OpenSduiOverlayAction_Params,
	ApplyChartsFilterAction = t1.ApplyChartsFilterAction,
	ApplyChartsFilterAction_Params = t1.ApplyChartsFilterAction_Params,
	RefreshChartsSortDetailAction = t1.RefreshChartsSortDetailAction,
	RefreshChartsSortDetailAction_Params = t1.RefreshChartsSortDetailAction_Params,
	JoinCommunityAction = t1.JoinCommunityAction,
	JoinCommunityAction_Params = t1.JoinCommunityAction_Params,
	ViewCommunityAction = t1.ViewCommunityAction,
	ViewCommunityAction_Params = t1.ViewCommunityAction_Params,
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
	SelectMarketplaceFavoritesSubcategory = t1.SelectMarketplaceFavoritesSubcategory,
	SelectMarketplaceFavoritesSubcategory_Params = t1.SelectMarketplaceFavoritesSubcategory_Params,
	PinExperienceShortcutAction = t1.PinExperienceShortcutAction,
	PinExperienceShortcutAction_Params = t1.PinExperienceShortcutAction_Params,
	DownloadAppAction = t1.DownloadAppAction,
	DownloadAppAction_Params = t1.DownloadAppAction_Params,
	ActionSequenceAction = t1.ActionSequenceAction,
	ActionSequenceAction_Params = t1.ActionSequenceAction_Params,
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
