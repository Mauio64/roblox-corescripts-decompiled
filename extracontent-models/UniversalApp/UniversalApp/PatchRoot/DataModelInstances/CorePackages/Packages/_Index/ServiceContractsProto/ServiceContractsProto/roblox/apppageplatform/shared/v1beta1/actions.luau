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

			function t2.new(t3: {[any]: any}?) -- line: 5399
				-- upvalues: t1 (copy), t2 (copy)
				return (setmetatable({
					action_type = if t3 ~= nil and t3.action_type ~= nil then t3.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t3 ~= nil and t3.action_params ~= nil then t3.action_params else nil
				}, t2))
			end
			function t2.encode(p1) -- line: 5408
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n1 = 0

				if p1.action_type ~= nil and (p1.action_type ~= nil and p1.action_type ~= 0 or p1.action_type ~= t1.ActionType.fromNumber(0)) then
					local v183, v184 = proto.writeTag(buf, n1, 1, proto.wireTypes.varint)

					buf, n1 = proto.writeVarInt(v183, v184, t1.ActionType.toNumber(p1.action_type))
				end

				if p1.action_params ~= nil then
					local v185 = p1.action_params:encode()
					local v186, v187 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

					buf, n1 = proto.writeBuffer(v186, v187, v185, buffer.len(v185))
				end

				local buf2 = buffer.create(n1)

				buffer.copy(buf2, 0, buf, 0, n1)

				return buf2
			end
			function t2.decode(p2: buffer) -- line: 5434
				-- upvalues: t2 (copy), proto (copy), t1 (copy)
				local v190 = t2.new()
				local n2 = 0

				while n2 < buffer.len(p2) do
					local v192, v193

					v192, v193, n2 = proto.readTag(p2, n2)

					if v193 == proto.wireTypes.varint then
						if v192 == 1 then
							local v194

							v194, n2 = proto.readVarIntI32(p2, n2)
							v190.action_type = t1.ActionType.fromNumber(v194) or v194
						else
							local v195

							v195, n2 = proto.readVarInt(p2, n2)
						end
					elseif v193 == proto.wireTypes.lengthDelimited then
						if v192 == 2 then
							local v196

							v196, n2 = proto.readBuffer(p2, n2)
							v190.action_params = t1.DismissDialogAction_Params.decode(v196)
						else
							local v197, v198 = proto.readVarInt(p2, n2)

							n2 = v198 + v197
						end
					elseif v193 == proto.wireTypes.i32 then
						local v199

						v199, n2 = proto.readFixed32(p2, n2)
					elseif v193 == proto.wireTypes.i64 then
						local v200

						v200, n2 = proto.readFixed64(p2, n2)
					else
						error("Unsupported wire type: " .. v193)
					end
				end

				return v190
			end
			function t2.jsonEncode(p3) -- line: 5482
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
			function t2.jsonDecode(t5: {[any]: any}) -- line: 5504
				-- upvalues: t2 (copy), t1 (copy)
				local v204 = t2.new()

				if t5.action_type ~= nil then
					v204.action_type = if typeof(t5.action_type) ~= "number" then t1.ActionType.fromName(t5.action_type) or t5.action_type else t1.ActionType.fromNumber(t5.action_type) or t5.action_type
				end

				if t5.actionType ~= nil then
					v204.action_type = if typeof(t5.actionType) ~= "number" then t1.ActionType.fromName(t5.actionType) or t5.actionType else t1.ActionType.fromNumber(t5.actionType) or t5.actionType
				end

				if t5.action_params ~= nil then
					v204.action_params = t1.DismissDialogAction_Params.jsonDecode(t5.action_params)
				end

				if t5.actionParams ~= nil then
					v204.action_params = t1.DismissDialogAction_Params.jsonDecode(t5.actionParams)
				end

				return v204
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

			function t6.new(t7: {[any]: any}?) -- line: 5544
				-- upvalues: t6 (copy)
				return (setmetatable({
					dialog_type = if t7 ~= nil and t7.dialog_type ~= nil then t7.dialog_type else nil
				}, t6))
			end
			function t6.encode(p4) -- line: 5552
				-- upvalues: proto (copy)
				local buf = buffer.create(0)
				local n3 = 0

				if p4.dialog_type ~= nil then
					local v209 = p4.dialog_type:encode()
					local v210, v211 = proto.writeTag(buf, n3, 1, proto.wireTypes.lengthDelimited)

					buf, n3 = proto.writeBuffer(v210, v211, v209, buffer.len(v209))
				end

				local buf3 = buffer.create(n3)

				buffer.copy(buf3, 0, buf, 0, n3)

				return buf3
			end
			function t6.decode(p5: buffer) -- line: 5567
				-- upvalues: t6 (copy), proto (copy), prop_types (copy)
				local v214 = t6.new()
				local n4 = 0

				while n4 < buffer.len(p5) do
					local v216, v217

					v216, v217, n4 = proto.readTag(p5, n4)

					if v217 == proto.wireTypes.varint then
						local v218

						v218, n4 = proto.readVarInt(p5, n4)
					elseif v217 == proto.wireTypes.lengthDelimited then
						if v216 == 1 then
							local v219

							v219, n4 = proto.readBuffer(p5, n4)
							v214.dialog_type = prop_types.StringProp.decode(v219)
						else
							local v220, v221 = proto.readVarInt(p5, n4)

							n4 = v221 + v220
						end
					elseif v217 == proto.wireTypes.i32 then
						local v222

						v222, n4 = proto.readFixed32(p5, n4)
					elseif v217 == proto.wireTypes.i64 then
						local v223

						v223, n4 = proto.readFixed64(p5, n4)
					else
						error("Unsupported wire type: " .. v217)
					end
				end

				return v214
			end
			function t6.jsonEncode(p6) -- line: 5610
				local t8 = {}

				if p6.dialog_type ~= nil then
					t8.dialogType = p6.dialog_type:jsonEncode()
				end

				return t8
			end
			function t6.jsonDecode(t9: {[any]: any}) -- line: 5620
				-- upvalues: t6 (copy), prop_types (copy)
				local v227 = t6.new()

				if t9.dialog_type ~= nil then
					v227.dialog_type = prop_types.StringProp.jsonDecode(t9.dialog_type)
				end

				if t9.dialogType ~= nil then
					v227.dialog_type = prop_types.StringProp.jsonDecode(t9.dialogType)
				end

				return v227
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

			function t10.new(t11: {[any]: any}?) -- line: 5649
				-- upvalues: t1 (copy), t10 (copy)
				return (setmetatable({
					action_type = if t11 ~= nil and t11.action_type ~= nil then t11.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t11 ~= nil and t11.action_params ~= nil then t11.action_params else nil
				}, t10))
			end
			function t10.encode(p7) -- line: 5658
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n5 = 0

				if p7.action_type ~= nil and (p7.action_type ~= nil and p7.action_type ~= 0 or p7.action_type ~= t1.ActionType.fromNumber(0)) then
					local v232, v233 = proto.writeTag(buf, n5, 1, proto.wireTypes.varint)

					buf, n5 = proto.writeVarInt(v232, v233, t1.ActionType.toNumber(p7.action_type))
				end

				if p7.action_params ~= nil then
					local v234 = p7.action_params:encode()
					local v235, v236 = proto.writeTag(buf, n5, 2, proto.wireTypes.lengthDelimited)

					buf, n5 = proto.writeBuffer(v235, v236, v234, buffer.len(v234))
				end

				local buf4 = buffer.create(n5)

				buffer.copy(buf4, 0, buf, 0, n5)

				return buf4
			end
			function t10.decode(p8: buffer) -- line: 5684
				-- upvalues: t10 (copy), proto (copy), t1 (copy)
				local v239 = t10.new()
				local n6 = 0

				while n6 < buffer.len(p8) do
					local v241, v242

					v241, v242, n6 = proto.readTag(p8, n6)

					if v242 == proto.wireTypes.varint then
						if v241 == 1 then
							local v243

							v243, n6 = proto.readVarIntI32(p8, n6)
							v239.action_type = t1.ActionType.fromNumber(v243) or v243
						else
							local v244

							v244, n6 = proto.readVarInt(p8, n6)
						end
					elseif v242 == proto.wireTypes.lengthDelimited then
						if v241 == 2 then
							local v245

							v245, n6 = proto.readBuffer(p8, n6)
							v239.action_params = t1.LinkAction_Params.decode(v245)
						else
							local v246, v247 = proto.readVarInt(p8, n6)

							n6 = v247 + v246
						end
					elseif v242 == proto.wireTypes.i32 then
						local v248

						v248, n6 = proto.readFixed32(p8, n6)
					elseif v242 == proto.wireTypes.i64 then
						local v249

						v249, n6 = proto.readFixed64(p8, n6)
					else
						error("Unsupported wire type: " .. v242)
					end
				end

				return v239
			end
			function t10.jsonEncode(p9) -- line: 5732
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
			function t10.jsonDecode(t13: {[any]: any}) -- line: 5754
				-- upvalues: t10 (copy), t1 (copy)
				local v253 = t10.new()

				if t13.action_type ~= nil then
					v253.action_type = if typeof(t13.action_type) ~= "number" then t1.ActionType.fromName(t13.action_type) or t13.action_type else t1.ActionType.fromNumber(t13.action_type) or t13.action_type
				end

				if t13.actionType ~= nil then
					v253.action_type = if typeof(t13.actionType) ~= "number" then t1.ActionType.fromName(t13.actionType) or t13.actionType else t1.ActionType.fromNumber(t13.actionType) or t13.actionType
				end

				if t13.action_params ~= nil then
					v253.action_params = t1.LinkAction_Params.jsonDecode(t13.action_params)
				end

				if t13.actionParams ~= nil then
					v253.action_params = t1.LinkAction_Params.jsonDecode(t13.actionParams)
				end

				return v253
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

			function t14.new(t15: {[any]: any}?) -- line: 5794
				-- upvalues: t14 (copy)
				return (setmetatable({
					url = if t15 ~= nil and t15.url ~= nil then t15.url else nil,
					title_key = if t15 ~= nil and t15.title_key ~= nil then t15.title_key else nil,
					on_webview_close = if t15 ~= nil and t15.on_webview_close ~= nil then t15.on_webview_close else nil
				}, t14))
			end
			function t14.encode(p10) -- line: 5802
				-- upvalues: proto (copy)
				local buf = buffer.create(0)
				local n7 = 0

				if p10.url ~= nil then
					local v258 = p10.url:encode()
					local v259, v260 = proto.writeTag(buf, n7, 1, proto.wireTypes.lengthDelimited)

					buf, n7 = proto.writeBuffer(v259, v260, v258, buffer.len(v258))
				end

				if p10.title_key ~= nil then
					local v261 = p10.title_key:encode()
					local v262, v263 = proto.writeTag(buf, n7, 2, proto.wireTypes.lengthDelimited)

					buf, n7 = proto.writeBuffer(v262, v263, v261, buffer.len(v261))
				end

				if p10.on_webview_close ~= nil then
					local v264 = p10.on_webview_close:encode()
					local v265, v266 = proto.writeTag(buf, n7, 4, proto.wireTypes.lengthDelimited)

					buf, n7 = proto.writeBuffer(v265, v266, v264, buffer.len(v264))
				end

				local buf5 = buffer.create(n7)

				buffer.copy(buf5, 0, buf, 0, n7)

				return buf5
			end
			function t14.decode(p11: buffer) -- line: 5829
				-- upvalues: t14 (copy), proto (copy), prop_types (copy), t1 (copy)
				local v269 = t14.new()
				local n8 = 0

				while n8 < buffer.len(p11) do
					local v271, v272

					v271, v272, n8 = proto.readTag(p11, n8)

					if v272 == proto.wireTypes.varint then
						local v273

						v273, n8 = proto.readVarInt(p11, n8)
					elseif v272 == proto.wireTypes.lengthDelimited then
						if v271 == 1 then
							local v274

							v274, n8 = proto.readBuffer(p11, n8)
							v269.url = prop_types.StringProp.decode(v274)
						elseif v271 == 2 then
							local v275

							v275, n8 = proto.readBuffer(p11, n8)
							v269.title_key = prop_types.StringProp.decode(v275)
						elseif v271 == 4 then
							local v276

							v276, n8 = proto.readBuffer(p11, n8)
							v269.on_webview_close = t1.ActionProp.decode(v276)
						else
							local v277, v278 = proto.readVarInt(p11, n8)

							n8 = v278 + v277
						end
					elseif v272 == proto.wireTypes.i32 then
						local v279

						v279, n8 = proto.readFixed32(p11, n8)
					elseif v272 == proto.wireTypes.i64 then
						local v280

						v280, n8 = proto.readFixed64(p11, n8)
					else
						error("Unsupported wire type: " .. v272)
					end
				end

				return v269
			end
			function t14.jsonEncode(p12) -- line: 5882
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
			function t14.jsonDecode(t17: {[any]: any}) -- line: 5900
				-- upvalues: t14 (copy), prop_types (copy), t1 (copy)
				local v284 = t14.new()

				if t17.url ~= nil then
					v284.url = prop_types.StringProp.jsonDecode(t17.url)
				end

				if t17.title_key ~= nil then
					v284.title_key = prop_types.StringProp.jsonDecode(t17.title_key)
				end

				if t17.titleKey ~= nil then
					v284.title_key = prop_types.StringProp.jsonDecode(t17.titleKey)
				end

				if t17.on_webview_close ~= nil then
					v284.on_webview_close = t1.ActionProp.jsonDecode(t17.on_webview_close)
				end

				if t17.onWebviewClose ~= nil then
					v284.on_webview_close = t1.ActionProp.jsonDecode(t17.onWebviewClose)
				end

				return v284
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

			function t18.new(t19: {[any]: any}?) -- line: 5940
				-- upvalues: t1 (copy), t18 (copy)
				return (setmetatable({
					action_type = if t19 ~= nil and t19.action_type ~= nil then t19.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t19 ~= nil and t19.action_params ~= nil then t19.action_params else nil
				}, t18))
			end
			function t18.encode(p13) -- line: 5949
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n9 = 0

				if p13.action_type ~= nil and (p13.action_type ~= nil and p13.action_type ~= 0 or p13.action_type ~= t1.ActionType.fromNumber(0)) then
					local v289, v290 = proto.writeTag(buf, n9, 1, proto.wireTypes.varint)

					buf, n9 = proto.writeVarInt(v289, v290, t1.ActionType.toNumber(p13.action_type))
				end

				if p13.action_params ~= nil then
					local v291 = p13.action_params:encode()
					local v292, v293 = proto.writeTag(buf, n9, 2, proto.wireTypes.lengthDelimited)

					buf, n9 = proto.writeBuffer(v292, v293, v291, buffer.len(v291))
				end

				local buf6 = buffer.create(n9)

				buffer.copy(buf6, 0, buf, 0, n9)

				return buf6
			end
			function t18.decode(p14: buffer) -- line: 5975
				-- upvalues: t18 (copy), proto (copy), t1 (copy)
				local v296 = t18.new()
				local n10 = 0

				while n10 < buffer.len(p14) do
					local v298, v299

					v298, v299, n10 = proto.readTag(p14, n10)

					if v299 == proto.wireTypes.varint then
						if v298 == 1 then
							local v300

							v300, n10 = proto.readVarIntI32(p14, n10)
							v296.action_type = t1.ActionType.fromNumber(v300) or v300
						else
							local v301

							v301, n10 = proto.readVarInt(p14, n10)
						end
					elseif v299 == proto.wireTypes.lengthDelimited then
						if v298 == 2 then
							local v302

							v302, n10 = proto.readBuffer(p14, n10)
							v296.action_params = t1.OpenSocialLinkAction_Params.decode(v302)
						else
							local v303, v304 = proto.readVarInt(p14, n10)

							n10 = v304 + v303
						end
					elseif v299 == proto.wireTypes.i32 then
						local v305

						v305, n10 = proto.readFixed32(p14, n10)
					elseif v299 == proto.wireTypes.i64 then
						local v306

						v306, n10 = proto.readFixed64(p14, n10)
					else
						error("Unsupported wire type: " .. v299)
					end
				end

				return v296
			end
			function t18.jsonEncode(p15) -- line: 6023
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
			function t18.jsonDecode(t21: {[any]: any}) -- line: 6045
				-- upvalues: t18 (copy), t1 (copy)
				local v310 = t18.new()

				if t21.action_type ~= nil then
					v310.action_type = if typeof(t21.action_type) ~= "number" then t1.ActionType.fromName(t21.action_type) or t21.action_type else t1.ActionType.fromNumber(t21.action_type) or t21.action_type
				end

				if t21.actionType ~= nil then
					v310.action_type = if typeof(t21.actionType) ~= "number" then t1.ActionType.fromName(t21.actionType) or t21.actionType else t1.ActionType.fromNumber(t21.actionType) or t21.actionType
				end

				if t21.action_params ~= nil then
					v310.action_params = t1.OpenSocialLinkAction_Params.jsonDecode(t21.action_params)
				end

				if t21.actionParams ~= nil then
					v310.action_params = t1.OpenSocialLinkAction_Params.jsonDecode(t21.actionParams)
				end

				return v310
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

			function t22.new(t23: {[any]: any}?) -- line: 6085
				-- upvalues: t22 (copy)
				return (setmetatable({
					assignment_id = if t23 ~= nil and t23.assignment_id ~= nil then t23.assignment_id else nil,
					assignment_type = if t23 ~= nil and t23.assignment_type ~= nil then t23.assignment_type else nil,
					social_link_type = if t23 ~= nil and t23.social_link_type ~= nil then t23.social_link_type else nil,
					social_link_url = if t23 ~= nil and t23.social_link_url ~= nil then t23.social_link_url else nil,
					social_link_display_type = if t23 ~= nil and t23.social_link_display_type ~= nil then t23.social_link_display_type else nil
				}, t22))
			end
			function t22.encode(p16) -- line: 6099
				-- upvalues: proto (copy)
				local buf = buffer.create(0)
				local n11 = 0

				if p16.assignment_id ~= nil then
					local v315 = p16.assignment_id:encode()
					local v316, v317 = proto.writeTag(buf, n11, 1, proto.wireTypes.lengthDelimited)

					buf, n11 = proto.writeBuffer(v316, v317, v315, buffer.len(v315))
				end

				if p16.assignment_type ~= nil then
					local v318 = p16.assignment_type:encode()
					local v319, v320 = proto.writeTag(buf, n11, 2, proto.wireTypes.lengthDelimited)

					buf, n11 = proto.writeBuffer(v319, v320, v318, buffer.len(v318))
				end

				if p16.social_link_type ~= nil then
					local v321 = p16.social_link_type:encode()
					local v322, v323 = proto.writeTag(buf, n11, 3, proto.wireTypes.lengthDelimited)

					buf, n11 = proto.writeBuffer(v322, v323, v321, buffer.len(v321))
				end

				if p16.social_link_url ~= nil then
					local v324 = p16.social_link_url:encode()
					local v325, v326 = proto.writeTag(buf, n11, 4, proto.wireTypes.lengthDelimited)

					buf, n11 = proto.writeBuffer(v325, v326, v324, buffer.len(v324))
				end

				if p16.social_link_display_type ~= nil then
					local v327 = p16.social_link_display_type:encode()
					local v328, v329 = proto.writeTag(buf, n11, 5, proto.wireTypes.lengthDelimited)

					buf, n11 = proto.writeBuffer(v328, v329, v327, buffer.len(v327))
				end

				local buf7 = buffer.create(n11)

				buffer.copy(buf7, 0, buf, 0, n11)

				return buf7
			end
			function t22.decode(p17: buffer) -- line: 6138
				-- upvalues: t22 (copy), proto (copy), prop_types (copy)
				local v332 = t22.new()
				local n12 = 0

				while n12 < buffer.len(p17) do
					local v334, v335

					v334, v335, n12 = proto.readTag(p17, n12)

					if v335 == proto.wireTypes.varint then
						local v336

						v336, n12 = proto.readVarInt(p17, n12)
					elseif v335 == proto.wireTypes.lengthDelimited then
						if v334 == 1 then
							local v337

							v337, n12 = proto.readBuffer(p17, n12)
							v332.assignment_id = prop_types.StringProp.decode(v337)
						elseif v334 == 2 then
							local v338

							v338, n12 = proto.readBuffer(p17, n12)
							v332.assignment_type = prop_types.StringProp.decode(v338)
						elseif v334 == 3 then
							local v339

							v339, n12 = proto.readBuffer(p17, n12)
							v332.social_link_type = prop_types.StringProp.decode(v339)
						elseif v334 == 4 then
							local v340

							v340, n12 = proto.readBuffer(p17, n12)
							v332.social_link_url = prop_types.StringProp.decode(v340)
						elseif v334 == 5 then
							local v341

							v341, n12 = proto.readBuffer(p17, n12)
							v332.social_link_display_type = prop_types.StringProp.decode(v341)
						else
							local v342, v343 = proto.readVarInt(p17, n12)

							n12 = v343 + v342
						end
					elseif v335 == proto.wireTypes.i32 then
						local v344

						v344, n12 = proto.readFixed32(p17, n12)
					elseif v335 == proto.wireTypes.i64 then
						local v345

						v345, n12 = proto.readFixed64(p17, n12)
					else
						error("Unsupported wire type: " .. v335)
					end
				end

				return v332
			end
			function t22.jsonEncode(p18) -- line: 6202
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
			function t22.jsonDecode(t25: {[any]: any}) -- line: 6228
				-- upvalues: t22 (copy), prop_types (copy)
				local v349 = t22.new()

				if t25.assignment_id ~= nil then
					v349.assignment_id = prop_types.StringProp.jsonDecode(t25.assignment_id)
				end

				if t25.assignmentId ~= nil then
					v349.assignment_id = prop_types.StringProp.jsonDecode(t25.assignmentId)
				end

				if t25.assignment_type ~= nil then
					v349.assignment_type = prop_types.StringProp.jsonDecode(t25.assignment_type)
				end

				if t25.assignmentType ~= nil then
					v349.assignment_type = prop_types.StringProp.jsonDecode(t25.assignmentType)
				end

				if t25.social_link_type ~= nil then
					v349.social_link_type = prop_types.StringProp.jsonDecode(t25.social_link_type)
				end

				if t25.socialLinkType ~= nil then
					v349.social_link_type = prop_types.StringProp.jsonDecode(t25.socialLinkType)
				end

				if t25.social_link_url ~= nil then
					v349.social_link_url = prop_types.StringProp.jsonDecode(t25.social_link_url)
				end

				if t25.socialLinkUrl ~= nil then
					v349.social_link_url = prop_types.StringProp.jsonDecode(t25.socialLinkUrl)
				end

				if t25.social_link_display_type ~= nil then
					v349.social_link_display_type = prop_types.StringProp.jsonDecode(t25.social_link_display_type)
				end

				if t25.socialLinkDisplayType ~= nil then
					v349.social_link_display_type = prop_types.StringProp.jsonDecode(t25.socialLinkDisplayType)
				end

				return v349
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

			function t26.new(t27: {[any]: any}?) -- line: 6298
				-- upvalues: t1 (copy), t26 (copy)
				return (setmetatable({
					action_type = if t27 ~= nil and t27.action_type ~= nil then t27.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t27 ~= nil and t27.action_params ~= nil then t27.action_params else nil
				}, t26))
			end
			function t26.encode(p19) -- line: 6307
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n13 = 0

				if p19.action_type ~= nil and (p19.action_type ~= nil and p19.action_type ~= 0 or p19.action_type ~= t1.ActionType.fromNumber(0)) then
					local v354, v355 = proto.writeTag(buf, n13, 1, proto.wireTypes.varint)

					buf, n13 = proto.writeVarInt(v354, v355, t1.ActionType.toNumber(p19.action_type))
				end

				if p19.action_params ~= nil then
					local v356 = p19.action_params:encode()
					local v357, v358 = proto.writeTag(buf, n13, 2, proto.wireTypes.lengthDelimited)

					buf, n13 = proto.writeBuffer(v357, v358, v356, buffer.len(v356))
				end

				local buf8 = buffer.create(n13)

				buffer.copy(buf8, 0, buf, 0, n13)

				return buf8
			end
			function t26.decode(p20: buffer) -- line: 6333
				-- upvalues: t26 (copy), proto (copy), t1 (copy)
				local v361 = t26.new()
				local n14 = 0

				while n14 < buffer.len(p20) do
					local v363, v364

					v363, v364, n14 = proto.readTag(p20, n14)

					if v364 == proto.wireTypes.varint then
						if v363 == 1 then
							local v365

							v365, n14 = proto.readVarIntI32(p20, n14)
							v361.action_type = t1.ActionType.fromNumber(v365) or v365
						else
							local v366

							v366, n14 = proto.readVarInt(p20, n14)
						end
					elseif v364 == proto.wireTypes.lengthDelimited then
						if v363 == 2 then
							local v367

							v367, n14 = proto.readBuffer(p20, n14)
							v361.action_params = t1.OpenGameDetailsAction_Params.decode(v367)
						else
							local v368, v369 = proto.readVarInt(p20, n14)

							n14 = v369 + v368
						end
					elseif v364 == proto.wireTypes.i32 then
						local v370

						v370, n14 = proto.readFixed32(p20, n14)
					elseif v364 == proto.wireTypes.i64 then
						local v371

						v371, n14 = proto.readFixed64(p20, n14)
					else
						error("Unsupported wire type: " .. v364)
					end
				end

				return v361
			end
			function t26.jsonEncode(p21) -- line: 6381
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
			function t26.jsonDecode(t29: {[any]: any}) -- line: 6403
				-- upvalues: t26 (copy), t1 (copy)
				local v375 = t26.new()

				if t29.action_type ~= nil then
					v375.action_type = if typeof(t29.action_type) ~= "number" then t1.ActionType.fromName(t29.action_type) or t29.action_type else t1.ActionType.fromNumber(t29.action_type) or t29.action_type
				end

				if t29.actionType ~= nil then
					v375.action_type = if typeof(t29.actionType) ~= "number" then t1.ActionType.fromName(t29.actionType) or t29.actionType else t1.ActionType.fromNumber(t29.actionType) or t29.actionType
				end

				if t29.action_params ~= nil then
					v375.action_params = t1.OpenGameDetailsAction_Params.jsonDecode(t29.action_params)
				end

				if t29.actionParams ~= nil then
					v375.action_params = t1.OpenGameDetailsAction_Params.jsonDecode(t29.actionParams)
				end

				return v375
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

			function t30.new(t31: {[any]: any}?) -- line: 6443
				-- upvalues: t30 (copy)
				return (setmetatable({
					place_id = if t31 ~= nil and t31.place_id ~= nil then t31.place_id else nil,
					universe_id = if t31 ~= nil and t31.universe_id ~= nil then t31.universe_id else nil,
					inherit_referral_session = if t31 ~= nil and t31.inherit_referral_session ~= nil then t31.inherit_referral_session else nil
				}, t30))
			end
			function t30.encode(p22) -- line: 6455
				-- upvalues: proto (copy)
				local buf = buffer.create(0)
				local n15 = 0

				if p22.place_id ~= nil then
					local v380 = p22.place_id:encode()
					local v381, v382 = proto.writeTag(buf, n15, 1, proto.wireTypes.lengthDelimited)

					buf, n15 = proto.writeBuffer(v381, v382, v380, buffer.len(v380))
				end

				if p22.universe_id ~= nil then
					local v383 = p22.universe_id:encode()
					local v384, v385 = proto.writeTag(buf, n15, 2, proto.wireTypes.lengthDelimited)

					buf, n15 = proto.writeBuffer(v384, v385, v383, buffer.len(v383))
				end

				if p22.inherit_referral_session ~= nil then
					local v386 = p22.inherit_referral_session:encode()
					local v387, v388 = proto.writeTag(buf, n15, 3, proto.wireTypes.lengthDelimited)

					buf, n15 = proto.writeBuffer(v387, v388, v386, buffer.len(v386))
				end

				local buf9 = buffer.create(n15)

				buffer.copy(buf9, 0, buf, 0, n15)

				return buf9
			end
			function t30.decode(p23: buffer) -- line: 6482
				-- upvalues: t30 (copy), proto (copy), prop_types (copy)
				local v391 = t30.new()
				local n16 = 0

				while n16 < buffer.len(p23) do
					local v393, v394

					v393, v394, n16 = proto.readTag(p23, n16)

					if v394 == proto.wireTypes.varint then
						local v395

						v395, n16 = proto.readVarInt(p23, n16)
					elseif v394 == proto.wireTypes.lengthDelimited then
						if v393 == 1 then
							local v396

							v396, n16 = proto.readBuffer(p23, n16)
							v391.place_id = prop_types.StringProp.decode(v396)
						elseif v393 == 2 then
							local v397

							v397, n16 = proto.readBuffer(p23, n16)
							v391.universe_id = prop_types.StringProp.decode(v397)
						elseif v393 == 3 then
							local v398

							v398, n16 = proto.readBuffer(p23, n16)
							v391.inherit_referral_session = prop_types.BoolProp.decode(v398)
						else
							local v399, v400 = proto.readVarInt(p23, n16)

							n16 = v400 + v399
						end
					elseif v394 == proto.wireTypes.i32 then
						local v401

						v401, n16 = proto.readFixed32(p23, n16)
					elseif v394 == proto.wireTypes.i64 then
						local v402

						v402, n16 = proto.readFixed64(p23, n16)
					else
						error("Unsupported wire type: " .. v394)
					end
				end

				return v391
			end
			function t30.jsonEncode(p24) -- line: 6536
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
			function t30.jsonDecode(t33: {[any]: any}) -- line: 6554
				-- upvalues: t30 (copy), prop_types (copy)
				local v406 = t30.new()

				if t33.place_id ~= nil then
					v406.place_id = prop_types.StringProp.jsonDecode(t33.place_id)
				end

				if t33.placeId ~= nil then
					v406.place_id = prop_types.StringProp.jsonDecode(t33.placeId)
				end

				if t33.universe_id ~= nil then
					v406.universe_id = prop_types.StringProp.jsonDecode(t33.universe_id)
				end

				if t33.universeId ~= nil then
					v406.universe_id = prop_types.StringProp.jsonDecode(t33.universeId)
				end

				if t33.inherit_referral_session ~= nil then
					v406.inherit_referral_session = prop_types.BoolProp.jsonDecode(t33.inherit_referral_session)
				end

				if t33.inheritReferralSession ~= nil then
					v406.inherit_referral_session = prop_types.BoolProp.jsonDecode(t33.inheritReferralSession)
				end

				return v406
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

			function t34.new(t35: {[any]: any}?) -- line: 6601
				-- upvalues: t1 (copy), t34 (copy)
				return (setmetatable({
					action_type = if t35 ~= nil and t35.action_type ~= nil then t35.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t35 ~= nil and t35.action_params ~= nil then t35.action_params else nil
				}, t34))
			end
			function t34.encode(p25) -- line: 6610
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n17 = 0

				if p25.action_type ~= nil and (p25.action_type ~= nil and p25.action_type ~= 0 or p25.action_type ~= t1.ActionType.fromNumber(0)) then
					local v411, v412 = proto.writeTag(buf, n17, 1, proto.wireTypes.varint)

					buf, n17 = proto.writeVarInt(v411, v412, t1.ActionType.toNumber(p25.action_type))
				end

				if p25.action_params ~= nil then
					local v413 = p25.action_params:encode()
					local v414, v415 = proto.writeTag(buf, n17, 2, proto.wireTypes.lengthDelimited)

					buf, n17 = proto.writeBuffer(v414, v415, v413, buffer.len(v413))
				end

				local buf10 = buffer.create(n17)

				buffer.copy(buf10, 0, buf, 0, n17)

				return buf10
			end
			function t34.decode(p26: buffer) -- line: 6636
				-- upvalues: t34 (copy), proto (copy), t1 (copy)
				local v418 = t34.new()
				local n18 = 0

				while n18 < buffer.len(p26) do
					local v420, v421

					v420, v421, n18 = proto.readTag(p26, n18)

					if v421 == proto.wireTypes.varint then
						if v420 == 1 then
							local v422

							v422, n18 = proto.readVarIntI32(p26, n18)
							v418.action_type = t1.ActionType.fromNumber(v422) or v422
						else
							local v423

							v423, n18 = proto.readVarInt(p26, n18)
						end
					elseif v421 == proto.wireTypes.lengthDelimited then
						if v420 == 2 then
							local v424

							v424, n18 = proto.readBuffer(p26, n18)
							v418.action_params = t1.OpenJoinFriendsAction_Params.decode(v424)
						else
							local v425, v426 = proto.readVarInt(p26, n18)

							n18 = v426 + v425
						end
					elseif v421 == proto.wireTypes.i32 then
						local v427

						v427, n18 = proto.readFixed32(p26, n18)
					elseif v421 == proto.wireTypes.i64 then
						local v428

						v428, n18 = proto.readFixed64(p26, n18)
					else
						error("Unsupported wire type: " .. v421)
					end
				end

				return v418
			end
			function t34.jsonEncode(p27) -- line: 6684
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
			function t34.jsonDecode(t37: {[any]: any}) -- line: 6706
				-- upvalues: t34 (copy), t1 (copy)
				local v432 = t34.new()

				if t37.action_type ~= nil then
					v432.action_type = if typeof(t37.action_type) ~= "number" then t1.ActionType.fromName(t37.action_type) or t37.action_type else t1.ActionType.fromNumber(t37.action_type) or t37.action_type
				end

				if t37.actionType ~= nil then
					v432.action_type = if typeof(t37.actionType) ~= "number" then t1.ActionType.fromName(t37.actionType) or t37.actionType else t1.ActionType.fromNumber(t37.actionType) or t37.actionType
				end

				if t37.action_params ~= nil then
					v432.action_params = t1.OpenJoinFriendsAction_Params.jsonDecode(t37.action_params)
				end

				if t37.actionParams ~= nil then
					v432.action_params = t1.OpenJoinFriendsAction_Params.jsonDecode(t37.actionParams)
				end

				return v432
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

			function t38.new(t39: {[any]: any}?) -- line: 6746
				-- upvalues: t38 (copy)
				return (setmetatable({
					place_id = if t39 ~= nil and t39.place_id ~= nil then t39.place_id else nil,
					universe_id = if t39 ~= nil and t39.universe_id ~= nil then t39.universe_id else nil
				}, t38))
			end
			function t38.encode(p28) -- line: 6755
				-- upvalues: proto (copy)
				local buf = buffer.create(0)
				local n19 = 0

				if p28.place_id ~= nil then
					local v437 = p28.place_id:encode()
					local v438, v439 = proto.writeTag(buf, n19, 1, proto.wireTypes.lengthDelimited)

					buf, n19 = proto.writeBuffer(v438, v439, v437, buffer.len(v437))
				end

				if p28.universe_id ~= nil then
					local v440 = p28.universe_id:encode()
					local v441, v442 = proto.writeTag(buf, n19, 2, proto.wireTypes.lengthDelimited)

					buf, n19 = proto.writeBuffer(v441, v442, v440, buffer.len(v440))
				end

				local buf11 = buffer.create(n19)

				buffer.copy(buf11, 0, buf, 0, n19)

				return buf11
			end
			function t38.decode(p29: buffer) -- line: 6776
				-- upvalues: t38 (copy), proto (copy), prop_types (copy)
				local v445 = t38.new()
				local n20 = 0

				while n20 < buffer.len(p29) do
					local v447, v448

					v447, v448, n20 = proto.readTag(p29, n20)

					if v448 == proto.wireTypes.varint then
						local v449

						v449, n20 = proto.readVarInt(p29, n20)
					elseif v448 == proto.wireTypes.lengthDelimited then
						if v447 == 1 then
							local v450

							v450, n20 = proto.readBuffer(p29, n20)
							v445.place_id = prop_types.StringProp.decode(v450)
						elseif v447 == 2 then
							local v451

							v451, n20 = proto.readBuffer(p29, n20)
							v445.universe_id = prop_types.StringProp.decode(v451)
						else
							local v452, v453 = proto.readVarInt(p29, n20)

							n20 = v453 + v452
						end
					elseif v448 == proto.wireTypes.i32 then
						local v454

						v454, n20 = proto.readFixed32(p29, n20)
					elseif v448 == proto.wireTypes.i64 then
						local v455

						v455, n20 = proto.readFixed64(p29, n20)
					else
						error("Unsupported wire type: " .. v448)
					end
				end

				return v445
			end
			function t38.jsonEncode(p30) -- line: 6824
				local t40 = {}

				if p30.place_id ~= nil then
					t40.placeId = p30.place_id:jsonEncode()
				end

				if p30.universe_id ~= nil then
					t40.universeId = p30.universe_id:jsonEncode()
				end

				return t40
			end
			function t38.jsonDecode(t41: {[any]: any}) -- line: 6838
				-- upvalues: t38 (copy), prop_types (copy)
				local v459 = t38.new()

				if t41.place_id ~= nil then
					v459.place_id = prop_types.StringProp.jsonDecode(t41.place_id)
				end

				if t41.placeId ~= nil then
					v459.place_id = prop_types.StringProp.jsonDecode(t41.placeId)
				end

				if t41.universe_id ~= nil then
					v459.universe_id = prop_types.StringProp.jsonDecode(t41.universe_id)
				end

				if t41.universeId ~= nil then
					v459.universe_id = prop_types.StringProp.jsonDecode(t41.universeId)
				end

				return v459
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

			function t42.new(t43: {[any]: any}?) -- line: 6875
				-- upvalues: t1 (copy), t42 (copy)
				return (setmetatable({
					action_type = if t43 ~= nil and t43.action_type ~= nil then t43.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t43 ~= nil and t43.action_params ~= nil then t43.action_params else nil
				}, t42))
			end
			function t42.encode(p31) -- line: 6886
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n21 = 0

				if p31.action_type ~= nil and (p31.action_type ~= nil and p31.action_type ~= 0 or p31.action_type ~= t1.ActionType.fromNumber(0)) then
					local v464, v465 = proto.writeTag(buf, n21, 1, proto.wireTypes.varint)

					buf, n21 = proto.writeVarInt(v464, v465, t1.ActionType.toNumber(p31.action_type))
				end

				if p31.action_params ~= nil then
					local v466 = p31.action_params:encode()
					local v467, v468 = proto.writeTag(buf, n21, 2, proto.wireTypes.lengthDelimited)

					buf, n21 = proto.writeBuffer(v467, v468, v466, buffer.len(v466))
				end

				local buf12 = buffer.create(n21)

				buffer.copy(buf12, 0, buf, 0, n21)

				return buf12
			end
			function t42.decode(p32: buffer) -- line: 6912
				-- upvalues: t42 (copy), proto (copy), t1 (copy)
				local v471 = t42.new()
				local n22 = 0

				while n22 < buffer.len(p32) do
					local v473, v474

					v473, v474, n22 = proto.readTag(p32, n22)

					if v474 == proto.wireTypes.varint then
						if v473 == 1 then
							local v475

							v475, n22 = proto.readVarIntI32(p32, n22)
							v471.action_type = t1.ActionType.fromNumber(v475) or v475
						else
							local v476

							v476, n22 = proto.readVarInt(p32, n22)
						end
					elseif v474 == proto.wireTypes.lengthDelimited then
						if v473 == 2 then
							local v477

							v477, n22 = proto.readBuffer(p32, n22)
							v471.action_params = t1.OpenMarketplaceTryOnAction_Params.decode(v477)
						else
							local v478, v479 = proto.readVarInt(p32, n22)

							n22 = v479 + v478
						end
					elseif v474 == proto.wireTypes.i32 then
						local v480

						v480, n22 = proto.readFixed32(p32, n22)
					elseif v474 == proto.wireTypes.i64 then
						local v481

						v481, n22 = proto.readFixed64(p32, n22)
					else
						error("Unsupported wire type: " .. v474)
					end
				end

				return v471
			end
			function t42.jsonEncode(p33) -- line: 6960
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
			function t42.jsonDecode(t45: {[any]: any}) -- line: 6982
				-- upvalues: t42 (copy), t1 (copy)
				local v485 = t42.new()

				if t45.action_type ~= nil then
					v485.action_type = if typeof(t45.action_type) ~= "number" then t1.ActionType.fromName(t45.action_type) or t45.action_type else t1.ActionType.fromNumber(t45.action_type) or t45.action_type
				end

				if t45.actionType ~= nil then
					v485.action_type = if typeof(t45.actionType) ~= "number" then t1.ActionType.fromName(t45.actionType) or t45.actionType else t1.ActionType.fromNumber(t45.actionType) or t45.actionType
				end

				if t45.action_params ~= nil then
					v485.action_params = t1.OpenMarketplaceTryOnAction_Params.jsonDecode(t45.action_params)
				end

				if t45.actionParams ~= nil then
					v485.action_params = t1.OpenMarketplaceTryOnAction_Params.jsonDecode(t45.actionParams)
				end

				return v485
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

			function t46.new(t47: {[any]: any}?) -- line: 7022
				-- upvalues: t46 (copy)
				return (setmetatable({
					item_id = if t47 ~= nil and t47.item_id ~= nil then t47.item_id else nil,
					item_type = if t47 ~= nil and t47.item_type ~= nil then t47.item_type else nil,
					item_sub_type_name = if t47 ~= nil and t47.item_sub_type_name ~= nil then t47.item_sub_type_name else nil
				}, t46))
			end
			function t46.encode(p34) -- line: 7032
				-- upvalues: proto (copy)
				local buf = buffer.create(0)
				local n23 = 0

				if p34.item_id ~= nil then
					local v490 = p34.item_id:encode()
					local v491, v492 = proto.writeTag(buf, n23, 1, proto.wireTypes.lengthDelimited)

					buf, n23 = proto.writeBuffer(v491, v492, v490, buffer.len(v490))
				end

				if p34.item_type ~= nil then
					local v493 = p34.item_type:encode()
					local v494, v495 = proto.writeTag(buf, n23, 2, proto.wireTypes.lengthDelimited)

					buf, n23 = proto.writeBuffer(v494, v495, v493, buffer.len(v493))
				end

				if p34.item_sub_type_name ~= nil then
					local v496 = p34.item_sub_type_name:encode()
					local v497, v498 = proto.writeTag(buf, n23, 3, proto.wireTypes.lengthDelimited)

					buf, n23 = proto.writeBuffer(v497, v498, v496, buffer.len(v496))
				end

				local buf13 = buffer.create(n23)

				buffer.copy(buf13, 0, buf, 0, n23)

				return buf13
			end
			function t46.decode(p35: buffer) -- line: 7059
				-- upvalues: t46 (copy), proto (copy), prop_types (copy)
				local v501 = t46.new()
				local n24 = 0

				while n24 < buffer.len(p35) do
					local v503, v504

					v503, v504, n24 = proto.readTag(p35, n24)

					if v504 == proto.wireTypes.varint then
						local v505

						v505, n24 = proto.readVarInt(p35, n24)
					elseif v504 == proto.wireTypes.lengthDelimited then
						if v503 == 1 then
							local v506

							v506, n24 = proto.readBuffer(p35, n24)
							v501.item_id = prop_types.StringProp.decode(v506)
						elseif v503 == 2 then
							local v507

							v507, n24 = proto.readBuffer(p35, n24)
							v501.item_type = prop_types.StringProp.decode(v507)
						elseif v503 == 3 then
							local v508

							v508, n24 = proto.readBuffer(p35, n24)
							v501.item_sub_type_name = prop_types.StringProp.decode(v508)
						else
							local v509, v510 = proto.readVarInt(p35, n24)

							n24 = v510 + v509
						end
					elseif v504 == proto.wireTypes.i32 then
						local v511

						v511, n24 = proto.readFixed32(p35, n24)
					elseif v504 == proto.wireTypes.i64 then
						local v512

						v512, n24 = proto.readFixed64(p35, n24)
					else
						error("Unsupported wire type: " .. v504)
					end
				end

				return v501
			end
			function t46.jsonEncode(p36) -- line: 7112
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
			function t46.jsonDecode(t49: {[any]: any}) -- line: 7130
				-- upvalues: t46 (copy), prop_types (copy)
				local v516 = t46.new()

				if t49.item_id ~= nil then
					v516.item_id = prop_types.StringProp.jsonDecode(t49.item_id)
				end

				if t49.itemId ~= nil then
					v516.item_id = prop_types.StringProp.jsonDecode(t49.itemId)
				end

				if t49.item_type ~= nil then
					v516.item_type = prop_types.StringProp.jsonDecode(t49.item_type)
				end

				if t49.itemType ~= nil then
					v516.item_type = prop_types.StringProp.jsonDecode(t49.itemType)
				end

				if t49.item_sub_type_name ~= nil then
					v516.item_sub_type_name = prop_types.StringProp.jsonDecode(t49.item_sub_type_name)
				end

				if t49.itemSubTypeName ~= nil then
					v516.item_sub_type_name = prop_types.StringProp.jsonDecode(t49.itemSubTypeName)
				end

				return v516
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

			function t50.new(t51: {[any]: any}?) -- line: 7178
				-- upvalues: t1 (copy), t50 (copy)
				return (setmetatable({
					action_type = if t51 ~= nil and t51.action_type ~= nil then t51.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t51 ~= nil and t51.action_params ~= nil then t51.action_params else nil
				}, t50))
			end
			function t50.encode(p37) -- line: 7187
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n25 = 0

				if p37.action_type ~= nil and (p37.action_type ~= nil and p37.action_type ~= 0 or p37.action_type ~= t1.ActionType.fromNumber(0)) then
					local v521, v522 = proto.writeTag(buf, n25, 1, proto.wireTypes.varint)

					buf, n25 = proto.writeVarInt(v521, v522, t1.ActionType.toNumber(p37.action_type))
				end

				if p37.action_params ~= nil then
					local v523 = p37.action_params:encode()
					local v524, v525 = proto.writeTag(buf, n25, 2, proto.wireTypes.lengthDelimited)

					buf, n25 = proto.writeBuffer(v524, v525, v523, buffer.len(v523))
				end

				local buf14 = buffer.create(n25)

				buffer.copy(buf14, 0, buf, 0, n25)

				return buf14
			end
			function t50.decode(p38: buffer) -- line: 7213
				-- upvalues: t50 (copy), proto (copy), t1 (copy)
				local v528 = t50.new()
				local n26 = 0

				while n26 < buffer.len(p38) do
					local v530, v531

					v530, v531, n26 = proto.readTag(p38, n26)

					if v531 == proto.wireTypes.varint then
						if v530 == 1 then
							local v532

							v532, n26 = proto.readVarIntI32(p38, n26)
							v528.action_type = t1.ActionType.fromNumber(v532) or v532
						else
							local v533

							v533, n26 = proto.readVarInt(p38, n26)
						end
					elseif v531 == proto.wireTypes.lengthDelimited then
						if v530 == 2 then
							local v534

							v534, n26 = proto.readBuffer(p38, n26)
							v528.action_params = t1.OpenSeeAllAction_Params.decode(v534)
						else
							local v535, v536 = proto.readVarInt(p38, n26)

							n26 = v536 + v535
						end
					elseif v531 == proto.wireTypes.i32 then
						local v537

						v537, n26 = proto.readFixed32(p38, n26)
					elseif v531 == proto.wireTypes.i64 then
						local v538

						v538, n26 = proto.readFixed64(p38, n26)
					else
						error("Unsupported wire type: " .. v531)
					end
				end

				return v528
			end
			function t50.jsonEncode(p39) -- line: 7261
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
			function t50.jsonDecode(t53: {[any]: any}) -- line: 7283
				-- upvalues: t50 (copy), t1 (copy)
				local v542 = t50.new()

				if t53.action_type ~= nil then
					v542.action_type = if typeof(t53.action_type) ~= "number" then t1.ActionType.fromName(t53.action_type) or t53.action_type else t1.ActionType.fromNumber(t53.action_type) or t53.action_type
				end

				if t53.actionType ~= nil then
					v542.action_type = if typeof(t53.actionType) ~= "number" then t1.ActionType.fromName(t53.actionType) or t53.actionType else t1.ActionType.fromNumber(t53.actionType) or t53.actionType
				end

				if t53.action_params ~= nil then
					v542.action_params = t1.OpenSeeAllAction_Params.jsonDecode(t53.action_params)
				end

				if t53.actionParams ~= nil then
					v542.action_params = t1.OpenSeeAllAction_Params.jsonDecode(t53.actionParams)
				end

				return v542
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

			function t54.new(t55: {[any]: any}?) -- line: 7323
				-- upvalues: t54 (copy)
				return (setmetatable({
					collection_id = if t55 ~= nil and t55.collection_id ~= nil then t55.collection_id else nil,
					game_set_target_id = if t55 ~= nil and t55.game_set_target_id ~= nil then t55.game_set_target_id else nil,
					collection_position = if t55 ~= nil and t55.collection_position ~= nil then t55.collection_position else nil
				}, t54))
			end
			function t54.encode(p40) -- line: 7333
				-- upvalues: proto (copy)
				local buf = buffer.create(0)
				local n27 = 0

				if p40.collection_id ~= nil then
					local v547 = p40.collection_id:encode()
					local v548, v549 = proto.writeTag(buf, n27, 1, proto.wireTypes.lengthDelimited)

					buf, n27 = proto.writeBuffer(v548, v549, v547, buffer.len(v547))
				end

				if p40.game_set_target_id ~= nil then
					local v550 = p40.game_set_target_id:encode()
					local v551, v552 = proto.writeTag(buf, n27, 2, proto.wireTypes.lengthDelimited)

					buf, n27 = proto.writeBuffer(v551, v552, v550, buffer.len(v550))
				end

				if p40.collection_position ~= nil then
					local v553 = p40.collection_position:encode()
					local v554, v555 = proto.writeTag(buf, n27, 3, proto.wireTypes.lengthDelimited)

					buf, n27 = proto.writeBuffer(v554, v555, v553, buffer.len(v553))
				end

				local buf15 = buffer.create(n27)

				buffer.copy(buf15, 0, buf, 0, n27)

				return buf15
			end
			function t54.decode(p41: buffer) -- line: 7360
				-- upvalues: t54 (copy), proto (copy), prop_types (copy)
				local v558 = t54.new()
				local n28 = 0

				while n28 < buffer.len(p41) do
					local v560, v561

					v560, v561, n28 = proto.readTag(p41, n28)

					if v561 == proto.wireTypes.varint then
						local v562

						v562, n28 = proto.readVarInt(p41, n28)
					elseif v561 == proto.wireTypes.lengthDelimited then
						if v560 == 1 then
							local v563

							v563, n28 = proto.readBuffer(p41, n28)
							v558.collection_id = prop_types.StringProp.decode(v563)
						elseif v560 == 2 then
							local v564

							v564, n28 = proto.readBuffer(p41, n28)
							v558.game_set_target_id = prop_types.StringProp.decode(v564)
						elseif v560 == 3 then
							local v565

							v565, n28 = proto.readBuffer(p41, n28)
							v558.collection_position = prop_types.StringProp.decode(v565)
						else
							local v566, v567 = proto.readVarInt(p41, n28)

							n28 = v567 + v566
						end
					elseif v561 == proto.wireTypes.i32 then
						local v568

						v568, n28 = proto.readFixed32(p41, n28)
					elseif v561 == proto.wireTypes.i64 then
						local v569

						v569, n28 = proto.readFixed64(p41, n28)
					else
						error("Unsupported wire type: " .. v561)
					end
				end

				return v558
			end
			function t54.jsonEncode(p42) -- line: 7414
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
			function t54.jsonDecode(t57: {[any]: any}) -- line: 7432
				-- upvalues: t54 (copy), prop_types (copy)
				local v573 = t54.new()

				if t57.collection_id ~= nil then
					v573.collection_id = prop_types.StringProp.jsonDecode(t57.collection_id)
				end

				if t57.collectionId ~= nil then
					v573.collection_id = prop_types.StringProp.jsonDecode(t57.collectionId)
				end

				if t57.game_set_target_id ~= nil then
					v573.game_set_target_id = prop_types.StringProp.jsonDecode(t57.game_set_target_id)
				end

				if t57.gameSetTargetId ~= nil then
					v573.game_set_target_id = prop_types.StringProp.jsonDecode(t57.gameSetTargetId)
				end

				if t57.collection_position ~= nil then
					v573.collection_position = prop_types.StringProp.jsonDecode(t57.collection_position)
				end

				if t57.collectionPosition ~= nil then
					v573.collection_position = prop_types.StringProp.jsonDecode(t57.collectionPosition)
				end

				return v573
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

			function t58.new(t59: {[any]: any}?) -- line: 7482
				-- upvalues: t1 (copy), t58 (copy)
				return (setmetatable({
					action_type = if t59 ~= nil and t59.action_type ~= nil then t59.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t59 ~= nil and t59.action_params ~= nil then t59.action_params else nil
				}, t58))
			end
			function t58.encode(p43) -- line: 7493
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n29 = 0

				if p43.action_type ~= nil and (p43.action_type ~= nil and p43.action_type ~= 0 or p43.action_type ~= t1.ActionType.fromNumber(0)) then
					local v578, v579 = proto.writeTag(buf, n29, 1, proto.wireTypes.varint)

					buf, n29 = proto.writeVarInt(v578, v579, t1.ActionType.toNumber(p43.action_type))
				end

				if p43.action_params ~= nil then
					local v580 = p43.action_params:encode()
					local v581, v582 = proto.writeTag(buf, n29, 2, proto.wireTypes.lengthDelimited)

					buf, n29 = proto.writeBuffer(v581, v582, v580, buffer.len(v580))
				end

				local buf16 = buffer.create(n29)

				buffer.copy(buf16, 0, buf, 0, n29)

				return buf16
			end
			function t58.decode(p44: buffer) -- line: 7519
				-- upvalues: t58 (copy), proto (copy), t1 (copy)
				local v585 = t58.new()
				local n30 = 0

				while n30 < buffer.len(p44) do
					local v587, v588

					v587, v588, n30 = proto.readTag(p44, n30)

					if v588 == proto.wireTypes.varint then
						if v587 == 1 then
							local v589

							v589, n30 = proto.readVarIntI32(p44, n30)
							v585.action_type = t1.ActionType.fromNumber(v589) or v589
						else
							local v590

							v590, n30 = proto.readVarInt(p44, n30)
						end
					elseif v588 == proto.wireTypes.lengthDelimited then
						if v587 == 2 then
							local v591

							v591, n30 = proto.readBuffer(p44, n30)
							v585.action_params = t1.OpenSponsoredTooltipAction_Params.decode(v591)
						else
							local v592, v593 = proto.readVarInt(p44, n30)

							n30 = v593 + v592
						end
					elseif v588 == proto.wireTypes.i32 then
						local v594

						v594, n30 = proto.readFixed32(p44, n30)
					elseif v588 == proto.wireTypes.i64 then
						local v595

						v595, n30 = proto.readFixed64(p44, n30)
					else
						error("Unsupported wire type: " .. v588)
					end
				end

				return v585
			end
			function t58.jsonEncode(p45) -- line: 7567
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
			function t58.jsonDecode(t61: {[any]: any}) -- line: 7589
				-- upvalues: t58 (copy), t1 (copy)
				local v599 = t58.new()

				if t61.action_type ~= nil then
					v599.action_type = if typeof(t61.action_type) ~= "number" then t1.ActionType.fromName(t61.action_type) or t61.action_type else t1.ActionType.fromNumber(t61.action_type) or t61.action_type
				end

				if t61.actionType ~= nil then
					v599.action_type = if typeof(t61.actionType) ~= "number" then t1.ActionType.fromName(t61.actionType) or t61.actionType else t1.ActionType.fromNumber(t61.actionType) or t61.actionType
				end

				if t61.action_params ~= nil then
					v599.action_params = t1.OpenSponsoredTooltipAction_Params.jsonDecode(t61.action_params)
				end

				if t61.actionParams ~= nil then
					v599.action_params = t1.OpenSponsoredTooltipAction_Params.jsonDecode(t61.actionParams)
				end

				return v599
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

			function t62.new(_: {[any]: any}?) -- line: 7629
				-- upvalues: t62 (copy)
				return (setmetatable({}, t62))
			end
			function t62.encode(_) -- line: 7635
				local buf = buffer.create(0)
				local buf17 = buffer.create(0)

				buffer.copy(buf17, 0, buf, 0, 0)

				return buf17
			end
			function t62.decode(p47: buffer) -- line: 7644
				-- upvalues: t62 (copy), proto (copy)
				local v605 = t62.new()
				local n31 = 0

				while n31 < buffer.len(p47) do
					local v607, v608

					v607, v608, n31 = proto.readTag(p47, n31)

					if v608 == proto.wireTypes.varint then
						local v609

						v609, n31 = proto.readVarInt(p47, n31)
					elseif v608 == proto.wireTypes.lengthDelimited then
						local v610, v611 = proto.readVarInt(p47, n31)

						n31 = v611 + v610
					elseif v608 == proto.wireTypes.i32 then
						local v612

						v612, n31 = proto.readFixed32(p47, n31)
					elseif v608 == proto.wireTypes.i64 then
						local v613

						v613, n31 = proto.readFixed64(p47, n31)
					else
						error("Unsupported wire type: " .. v608)
					end
				end

				return v605
			end
			function t62.jsonEncode(_) -- line: 7682
				return {}
			end
			function t62.jsonDecode(_: {[any]: any}) -- line: 7688
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

			function t65.new(t66: {[any]: any}?) -- line: 7710
				-- upvalues: t1 (copy), t65 (copy)
				return (setmetatable({
					action_type = if t66 ~= nil and t66.action_type ~= nil then t66.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t66 ~= nil and t66.action_params ~= nil then t66.action_params else nil
				}, t65))
			end
			function t65.encode(p49) -- line: 7719
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n32 = 0

				if p49.action_type ~= nil and (p49.action_type ~= nil and p49.action_type ~= 0 or p49.action_type ~= t1.ActionType.fromNumber(0)) then
					local v620, v621 = proto.writeTag(buf, n32, 1, proto.wireTypes.varint)

					buf, n32 = proto.writeVarInt(v620, v621, t1.ActionType.toNumber(p49.action_type))
				end

				if p49.action_params ~= nil then
					local v622 = p49.action_params:encode()
					local v623, v624 = proto.writeTag(buf, n32, 2, proto.wireTypes.lengthDelimited)

					buf, n32 = proto.writeBuffer(v623, v624, v622, buffer.len(v622))
				end

				local buf18 = buffer.create(n32)

				buffer.copy(buf18, 0, buf, 0, n32)

				return buf18
			end
			function t65.decode(p50: buffer) -- line: 7745
				-- upvalues: t65 (copy), proto (copy), t1 (copy)
				local v627 = t65.new()
				local n33 = 0

				while n33 < buffer.len(p50) do
					local v629, v630

					v629, v630, n33 = proto.readTag(p50, n33)

					if v630 == proto.wireTypes.varint then
						if v629 == 1 then
							local v631

							v631, n33 = proto.readVarIntI32(p50, n33)
							v627.action_type = t1.ActionType.fromNumber(v631) or v631
						else
							local v632

							v632, n33 = proto.readVarInt(p50, n33)
						end
					elseif v630 == proto.wireTypes.lengthDelimited then
						if v629 == 2 then
							local v633

							v633, n33 = proto.readBuffer(p50, n33)
							v627.action_params = t1.PlayButtonClickAction_Params.decode(v633)
						else
							local v634, v635 = proto.readVarInt(p50, n33)

							n33 = v635 + v634
						end
					elseif v630 == proto.wireTypes.i32 then
						local v636

						v636, n33 = proto.readFixed32(p50, n33)
					elseif v630 == proto.wireTypes.i64 then
						local v637

						v637, n33 = proto.readFixed64(p50, n33)
					else
						error("Unsupported wire type: " .. v630)
					end
				end

				return v627
			end
			function t65.jsonEncode(p51) -- line: 7793
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
			function t65.jsonDecode(t68: {[any]: any}) -- line: 7815
				-- upvalues: t65 (copy), t1 (copy)
				local v641 = t65.new()

				if t68.action_type ~= nil then
					v641.action_type = if typeof(t68.action_type) ~= "number" then t1.ActionType.fromName(t68.action_type) or t68.action_type else t1.ActionType.fromNumber(t68.action_type) or t68.action_type
				end

				if t68.actionType ~= nil then
					v641.action_type = if typeof(t68.actionType) ~= "number" then t1.ActionType.fromName(t68.actionType) or t68.actionType else t1.ActionType.fromNumber(t68.actionType) or t68.actionType
				end

				if t68.action_params ~= nil then
					v641.action_params = t1.PlayButtonClickAction_Params.jsonDecode(t68.action_params)
				end

				if t68.actionParams ~= nil then
					v641.action_params = t1.PlayButtonClickAction_Params.jsonDecode(t68.actionParams)
				end

				return v641
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

			function t69.new(_: {[any]: any}?) -- line: 7855
				-- upvalues: t69 (copy)
				return (setmetatable({}, t69))
			end
			function t69.encode(_) -- line: 7861
				local buf = buffer.create(0)
				local buf19 = buffer.create(0)

				buffer.copy(buf19, 0, buf, 0, 0)

				return buf19
			end
			function t69.decode(p53: buffer) -- line: 7870
				-- upvalues: t69 (copy), proto (copy)
				local v647 = t69.new()
				local n34 = 0

				while n34 < buffer.len(p53) do
					local v649, v650

					v649, v650, n34 = proto.readTag(p53, n34)

					if v650 == proto.wireTypes.varint then
						local v651

						v651, n34 = proto.readVarInt(p53, n34)
					elseif v650 == proto.wireTypes.lengthDelimited then
						local v652, v653 = proto.readVarInt(p53, n34)

						n34 = v653 + v652
					elseif v650 == proto.wireTypes.i32 then
						local v654

						v654, n34 = proto.readFixed32(p53, n34)
					elseif v650 == proto.wireTypes.i64 then
						local v655

						v655, n34 = proto.readFixed64(p53, n34)
					else
						error("Unsupported wire type: " .. v650)
					end
				end

				return v647
			end
			function t69.jsonEncode(_) -- line: 7908
				return {}
			end
			function t69.jsonDecode(_: {[any]: any}) -- line: 7914
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

			function t72.new(t73: {[any]: any}?) -- line: 7934
				-- upvalues: t1 (copy), t72 (copy)
				return (setmetatable({
					action_type = if t73 ~= nil and t73.action_type ~= nil then t73.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t73 ~= nil and t73.action_params ~= nil then t73.action_params else nil
				}, t72))
			end
			function t72.encode(p55) -- line: 7943
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n35 = 0

				if p55.action_type ~= nil and (p55.action_type ~= nil and p55.action_type ~= 0 or p55.action_type ~= t1.ActionType.fromNumber(0)) then
					local v662, v663 = proto.writeTag(buf, n35, 1, proto.wireTypes.varint)

					buf, n35 = proto.writeVarInt(v662, v663, t1.ActionType.toNumber(p55.action_type))
				end

				if p55.action_params ~= nil then
					local v664 = p55.action_params:encode()
					local v665, v666 = proto.writeTag(buf, n35, 2, proto.wireTypes.lengthDelimited)

					buf, n35 = proto.writeBuffer(v665, v666, v664, buffer.len(v664))
				end

				local buf20 = buffer.create(n35)

				buffer.copy(buf20, 0, buf, 0, n35)

				return buf20
			end
			function t72.decode(p56: buffer) -- line: 7969
				-- upvalues: t72 (copy), proto (copy), t1 (copy)
				local v669 = t72.new()
				local n36 = 0

				while n36 < buffer.len(p56) do
					local v671, v672

					v671, v672, n36 = proto.readTag(p56, n36)

					if v672 == proto.wireTypes.varint then
						if v671 == 1 then
							local v673

							v673, n36 = proto.readVarIntI32(p56, n36)
							v669.action_type = t1.ActionType.fromNumber(v673) or v673
						else
							local v674

							v674, n36 = proto.readVarInt(p56, n36)
						end
					elseif v672 == proto.wireTypes.lengthDelimited then
						if v671 == 2 then
							local v675

							v675, n36 = proto.readBuffer(p56, n36)
							v669.action_params = t1.UpdateUserSettingsAction_Params.decode(v675)
						else
							local v676, v677 = proto.readVarInt(p56, n36)

							n36 = v677 + v676
						end
					elseif v672 == proto.wireTypes.i32 then
						local v678

						v678, n36 = proto.readFixed32(p56, n36)
					elseif v672 == proto.wireTypes.i64 then
						local v679

						v679, n36 = proto.readFixed64(p56, n36)
					else
						error("Unsupported wire type: " .. v672)
					end
				end

				return v669
			end
			function t72.jsonEncode(p57) -- line: 8017
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
			function t72.jsonDecode(t75: {[any]: any}) -- line: 8039
				-- upvalues: t72 (copy), t1 (copy)
				local v683 = t72.new()

				if t75.action_type ~= nil then
					v683.action_type = if typeof(t75.action_type) ~= "number" then t1.ActionType.fromName(t75.action_type) or t75.action_type else t1.ActionType.fromNumber(t75.action_type) or t75.action_type
				end

				if t75.actionType ~= nil then
					v683.action_type = if typeof(t75.actionType) ~= "number" then t1.ActionType.fromName(t75.actionType) or t75.actionType else t1.ActionType.fromNumber(t75.actionType) or t75.actionType
				end

				if t75.action_params ~= nil then
					v683.action_params = t1.UpdateUserSettingsAction_Params.jsonDecode(t75.action_params)
				end

				if t75.actionParams ~= nil then
					v683.action_params = t1.UpdateUserSettingsAction_Params.jsonDecode(t75.actionParams)
				end

				return v683
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

			function t76.new(t77: {[any]: any}?) -- line: 8079
				-- upvalues: t76 (copy)
				return (setmetatable({
					settings = if t77 ~= nil and t77.settings ~= nil then t77.settings else nil,
					audit_data = if t77 ~= nil and t77.audit_data ~= nil then t77.audit_data else nil
				}, t76))
			end
			function t76.encode(p58) -- line: 8088
				-- upvalues: proto (copy)
				local buf = buffer.create(0)
				local n37 = 0

				if p58.settings ~= nil then
					local v688 = p58.settings:encode()
					local v689, v690 = proto.writeTag(buf, n37, 1, proto.wireTypes.lengthDelimited)

					buf, n37 = proto.writeBuffer(v689, v690, v688, buffer.len(v688))
				end

				if p58.audit_data ~= nil then
					local v691 = p58.audit_data:encode()
					local v692, v693 = proto.writeTag(buf, n37, 2, proto.wireTypes.lengthDelimited)

					buf, n37 = proto.writeBuffer(v692, v693, v691, buffer.len(v691))
				end

				local buf21 = buffer.create(n37)

				buffer.copy(buf21, 0, buf, 0, n37)

				return buf21
			end
			function t76.decode(p59: buffer) -- line: 8109
				-- upvalues: t76 (copy), proto (copy), prop_types (copy)
				local v696 = t76.new()
				local n38 = 0

				while n38 < buffer.len(p59) do
					local v698, v699

					v698, v699, n38 = proto.readTag(p59, n38)

					if v699 == proto.wireTypes.varint then
						local v700

						v700, n38 = proto.readVarInt(p59, n38)
					elseif v699 == proto.wireTypes.lengthDelimited then
						if v698 == 1 then
							local v701

							v701, n38 = proto.readBuffer(p59, n38)
							v696.settings = prop_types.StructProp.decode(v701)
						elseif v698 == 2 then
							local v702

							v702, n38 = proto.readBuffer(p59, n38)
							v696.audit_data = prop_types.StringProp.decode(v702)
						else
							local v703, v704 = proto.readVarInt(p59, n38)

							n38 = v704 + v703
						end
					elseif v699 == proto.wireTypes.i32 then
						local v705

						v705, n38 = proto.readFixed32(p59, n38)
					elseif v699 == proto.wireTypes.i64 then
						local v706

						v706, n38 = proto.readFixed64(p59, n38)
					else
						error("Unsupported wire type: " .. v699)
					end
				end

				return v696
			end
			function t76.jsonEncode(p60) -- line: 8157
				local t78 = {}

				if p60.settings ~= nil then
					t78.settings = p60.settings:jsonEncode()
				end

				if p60.audit_data ~= nil then
					t78.auditData = p60.audit_data:jsonEncode()
				end

				return t78
			end
			function t76.jsonDecode(t79: {[any]: any}) -- line: 8171
				-- upvalues: t76 (copy), prop_types (copy)
				local v710 = t76.new()

				if t79.settings ~= nil then
					v710.settings = prop_types.StructProp.jsonDecode(t79.settings)
				end

				if t79.audit_data ~= nil then
					v710.audit_data = prop_types.StringProp.jsonDecode(t79.audit_data)
				end

				if t79.auditData ~= nil then
					v710.audit_data = prop_types.StringProp.jsonDecode(t79.auditData)
				end

				return v710
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

			function t80.new(t81: {[any]: any}?) -- line: 8203
				-- upvalues: t1 (copy), t80 (copy)
				return (setmetatable({
					action_type = if t81 ~= nil and t81.action_type ~= nil then t81.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t81 ~= nil and t81.action_params ~= nil then t81.action_params else nil
				}, t80))
			end
			function t80.encode(p61) -- line: 8212
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n39 = 0

				if p61.action_type ~= nil and (p61.action_type ~= nil and p61.action_type ~= 0 or p61.action_type ~= t1.ActionType.fromNumber(0)) then
					local v715, v716 = proto.writeTag(buf, n39, 1, proto.wireTypes.varint)

					buf, n39 = proto.writeVarInt(v715, v716, t1.ActionType.toNumber(p61.action_type))
				end

				if p61.action_params ~= nil then
					local v717 = p61.action_params:encode()
					local v718, v719 = proto.writeTag(buf, n39, 2, proto.wireTypes.lengthDelimited)

					buf, n39 = proto.writeBuffer(v718, v719, v717, buffer.len(v717))
				end

				local buf22 = buffer.create(n39)

				buffer.copy(buf22, 0, buf, 0, n39)

				return buf22
			end
			function t80.decode(p62: buffer) -- line: 8238
				-- upvalues: t80 (copy), proto (copy), t1 (copy)
				local v722 = t80.new()
				local n40 = 0

				while n40 < buffer.len(p62) do
					local v724, v725

					v724, v725, n40 = proto.readTag(p62, n40)

					if v725 == proto.wireTypes.varint then
						if v724 == 1 then
							local v726

							v726, n40 = proto.readVarIntI32(p62, n40)
							v722.action_type = t1.ActionType.fromNumber(v726) or v726
						else
							local v727

							v727, n40 = proto.readVarInt(p62, n40)
						end
					elseif v725 == proto.wireTypes.lengthDelimited then
						if v724 == 2 then
							local v728

							v728, n40 = proto.readBuffer(p62, n40)
							v722.action_params = t1.OpenTooltipAction_Params.decode(v728)
						else
							local v729, v730 = proto.readVarInt(p62, n40)

							n40 = v730 + v729
						end
					elseif v725 == proto.wireTypes.i32 then
						local v731

						v731, n40 = proto.readFixed32(p62, n40)
					elseif v725 == proto.wireTypes.i64 then
						local v732

						v732, n40 = proto.readFixed64(p62, n40)
					else
						error("Unsupported wire type: " .. v725)
					end
				end

				return v722
			end
			function t80.jsonEncode(p63) -- line: 8286
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
			function t80.jsonDecode(t83: {[any]: any}) -- line: 8308
				-- upvalues: t80 (copy), t1 (copy)
				local v736 = t80.new()

				if t83.action_type ~= nil then
					v736.action_type = if typeof(t83.action_type) ~= "number" then t1.ActionType.fromName(t83.action_type) or t83.action_type else t1.ActionType.fromNumber(t83.action_type) or t83.action_type
				end

				if t83.actionType ~= nil then
					v736.action_type = if typeof(t83.actionType) ~= "number" then t1.ActionType.fromName(t83.actionType) or t83.actionType else t1.ActionType.fromNumber(t83.actionType) or t83.actionType
				end

				if t83.action_params ~= nil then
					v736.action_params = t1.OpenTooltipAction_Params.jsonDecode(t83.action_params)
				end

				if t83.actionParams ~= nil then
					v736.action_params = t1.OpenTooltipAction_Params.jsonDecode(t83.actionParams)
				end

				return v736
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

			function t84.new(t85: {[any]: any}?) -- line: 8348
				-- upvalues: t84 (copy)
				return (setmetatable({
					tooltip_title = if t85 ~= nil and t85.tooltip_title ~= nil then t85.tooltip_title else nil,
					tooltip_info_text = if t85 ~= nil and t85.tooltip_info_text ~= nil then t85.tooltip_info_text else nil
				}, t84))
			end
			function t84.encode(p64) -- line: 8355
				-- upvalues: proto (copy)
				local buf = buffer.create(0)
				local n41 = 0

				if p64.tooltip_title ~= nil then
					local v741 = p64.tooltip_title:encode()
					local v742, v743 = proto.writeTag(buf, n41, 1, proto.wireTypes.lengthDelimited)

					buf, n41 = proto.writeBuffer(v742, v743, v741, buffer.len(v741))
				end

				if p64.tooltip_info_text ~= nil then
					local v744 = p64.tooltip_info_text:encode()
					local v745, v746 = proto.writeTag(buf, n41, 2, proto.wireTypes.lengthDelimited)

					buf, n41 = proto.writeBuffer(v745, v746, v744, buffer.len(v744))
				end

				local buf23 = buffer.create(n41)

				buffer.copy(buf23, 0, buf, 0, n41)

				return buf23
			end
			function t84.decode(p65: buffer) -- line: 8376
				-- upvalues: t84 (copy), proto (copy), prop_types (copy)
				local v749 = t84.new()
				local n42 = 0

				while n42 < buffer.len(p65) do
					local v751, v752

					v751, v752, n42 = proto.readTag(p65, n42)

					if v752 == proto.wireTypes.varint then
						local v753

						v753, n42 = proto.readVarInt(p65, n42)
					elseif v752 == proto.wireTypes.lengthDelimited then
						if v751 == 1 then
							local v754

							v754, n42 = proto.readBuffer(p65, n42)
							v749.tooltip_title = prop_types.StringProp.decode(v754)
						elseif v751 == 2 then
							local v755

							v755, n42 = proto.readBuffer(p65, n42)
							v749.tooltip_info_text = prop_types.StringProp.decode(v755)
						else
							local v756, v757 = proto.readVarInt(p65, n42)

							n42 = v757 + v756
						end
					elseif v752 == proto.wireTypes.i32 then
						local v758

						v758, n42 = proto.readFixed32(p65, n42)
					elseif v752 == proto.wireTypes.i64 then
						local v759

						v759, n42 = proto.readFixed64(p65, n42)
					else
						error("Unsupported wire type: " .. v752)
					end
				end

				return v749
			end
			function t84.jsonEncode(p66) -- line: 8424
				local t86 = {}

				if p66.tooltip_title ~= nil then
					t86.tooltipTitle = p66.tooltip_title:jsonEncode()
				end

				if p66.tooltip_info_text ~= nil then
					t86.tooltipInfoText = p66.tooltip_info_text:jsonEncode()
				end

				return t86
			end
			function t84.jsonDecode(t87: {[any]: any}) -- line: 8438
				-- upvalues: t84 (copy), prop_types (copy)
				local v763 = t84.new()

				if t87.tooltip_title ~= nil then
					v763.tooltip_title = prop_types.StringProp.jsonDecode(t87.tooltip_title)
				end

				if t87.tooltipTitle ~= nil then
					v763.tooltip_title = prop_types.StringProp.jsonDecode(t87.tooltipTitle)
				end

				if t87.tooltip_info_text ~= nil then
					v763.tooltip_info_text = prop_types.StringProp.jsonDecode(t87.tooltip_info_text)
				end

				if t87.tooltipInfoText ~= nil then
					v763.tooltip_info_text = prop_types.StringProp.jsonDecode(t87.tooltipInfoText)
				end

				return v763
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

			function t88.new(t89: {[any]: any}?) -- line: 8478
				-- upvalues: t1 (copy), t88 (copy)
				return (setmetatable({
					action_type = if t89 ~= nil and t89.action_type ~= nil then t89.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t89 ~= nil and t89.action_params ~= nil then t89.action_params else nil
				}, t88))
			end
			function t88.encode(p67) -- line: 8487
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n43 = 0

				if p67.action_type ~= nil and (p67.action_type ~= nil and p67.action_type ~= 0 or p67.action_type ~= t1.ActionType.fromNumber(0)) then
					local v768, v769 = proto.writeTag(buf, n43, 1, proto.wireTypes.varint)

					buf, n43 = proto.writeVarInt(v768, v769, t1.ActionType.toNumber(p67.action_type))
				end

				if p67.action_params ~= nil then
					local v770 = p67.action_params:encode()
					local v771, v772 = proto.writeTag(buf, n43, 2, proto.wireTypes.lengthDelimited)

					buf, n43 = proto.writeBuffer(v771, v772, v770, buffer.len(v770))
				end

				local buf24 = buffer.create(n43)

				buffer.copy(buf24, 0, buf, 0, n43)

				return buf24
			end
			function t88.decode(p68: buffer) -- line: 8513
				-- upvalues: t88 (copy), proto (copy), t1 (copy)
				local v775 = t88.new()
				local n44 = 0

				while n44 < buffer.len(p68) do
					local v777, v778

					v777, v778, n44 = proto.readTag(p68, n44)

					if v778 == proto.wireTypes.varint then
						if v777 == 1 then
							local v779

							v779, n44 = proto.readVarIntI32(p68, n44)
							v775.action_type = t1.ActionType.fromNumber(v779) or v779
						else
							local v780

							v780, n44 = proto.readVarInt(p68, n44)
						end
					elseif v778 == proto.wireTypes.lengthDelimited then
						if v777 == 2 then
							local v781

							v781, n44 = proto.readBuffer(p68, n44)
							v775.action_params = t1.OpenBadgeDetailsAction_Params.decode(v781)
						else
							local v782, v783 = proto.readVarInt(p68, n44)

							n44 = v783 + v782
						end
					elseif v778 == proto.wireTypes.i32 then
						local v784

						v784, n44 = proto.readFixed32(p68, n44)
					elseif v778 == proto.wireTypes.i64 then
						local v785

						v785, n44 = proto.readFixed64(p68, n44)
					else
						error("Unsupported wire type: " .. v778)
					end
				end

				return v775
			end
			function t88.jsonEncode(p69) -- line: 8561
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
			function t88.jsonDecode(t91: {[any]: any}) -- line: 8583
				-- upvalues: t88 (copy), t1 (copy)
				local v789 = t88.new()

				if t91.action_type ~= nil then
					v789.action_type = if typeof(t91.action_type) ~= "number" then t1.ActionType.fromName(t91.action_type) or t91.action_type else t1.ActionType.fromNumber(t91.action_type) or t91.action_type
				end

				if t91.actionType ~= nil then
					v789.action_type = if typeof(t91.actionType) ~= "number" then t1.ActionType.fromName(t91.actionType) or t91.actionType else t1.ActionType.fromNumber(t91.actionType) or t91.actionType
				end

				if t91.action_params ~= nil then
					v789.action_params = t1.OpenBadgeDetailsAction_Params.jsonDecode(t91.action_params)
				end

				if t91.actionParams ~= nil then
					v789.action_params = t1.OpenBadgeDetailsAction_Params.jsonDecode(t91.actionParams)
				end

				return v789
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

			function t92.new(t93: {[any]: any}?) -- line: 8623
				-- upvalues: t92 (copy)
				return (setmetatable({
					badge_id = if t93 ~= nil and t93.badge_id ~= nil then t93.badge_id else nil,
					title_text = if t93 ~= nil and t93.title_text ~= nil then t93.title_text else nil
				}, t92))
			end
			function t92.encode(p70) -- line: 8632
				-- upvalues: proto (copy)
				local buf = buffer.create(0)
				local n45 = 0

				if p70.badge_id ~= nil then
					local v794 = p70.badge_id:encode()
					local v795, v796 = proto.writeTag(buf, n45, 1, proto.wireTypes.lengthDelimited)

					buf, n45 = proto.writeBuffer(v795, v796, v794, buffer.len(v794))
				end

				if p70.title_text ~= nil then
					local v797 = p70.title_text:encode()
					local v798, v799 = proto.writeTag(buf, n45, 2, proto.wireTypes.lengthDelimited)

					buf, n45 = proto.writeBuffer(v798, v799, v797, buffer.len(v797))
				end

				local buf25 = buffer.create(n45)

				buffer.copy(buf25, 0, buf, 0, n45)

				return buf25
			end
			function t92.decode(p71: buffer) -- line: 8653
				-- upvalues: t92 (copy), proto (copy), prop_types (copy)
				local v802 = t92.new()
				local n46 = 0

				while n46 < buffer.len(p71) do
					local v804, v805

					v804, v805, n46 = proto.readTag(p71, n46)

					if v805 == proto.wireTypes.varint then
						local v806

						v806, n46 = proto.readVarInt(p71, n46)
					elseif v805 == proto.wireTypes.lengthDelimited then
						if v804 == 1 then
							local v807

							v807, n46 = proto.readBuffer(p71, n46)
							v802.badge_id = prop_types.StringProp.decode(v807)
						elseif v804 == 2 then
							local v808

							v808, n46 = proto.readBuffer(p71, n46)
							v802.title_text = prop_types.StringProp.decode(v808)
						else
							local v809, v810 = proto.readVarInt(p71, n46)

							n46 = v810 + v809
						end
					elseif v805 == proto.wireTypes.i32 then
						local v811

						v811, n46 = proto.readFixed32(p71, n46)
					elseif v805 == proto.wireTypes.i64 then
						local v812

						v812, n46 = proto.readFixed64(p71, n46)
					else
						error("Unsupported wire type: " .. v805)
					end
				end

				return v802
			end
			function t92.jsonEncode(p72) -- line: 8701
				local t94 = {}

				if p72.badge_id ~= nil then
					t94.badgeId = p72.badge_id:jsonEncode()
				end

				if p72.title_text ~= nil then
					t94.titleText = p72.title_text:jsonEncode()
				end

				return t94
			end
			function t92.jsonDecode(t95: {[any]: any}) -- line: 8715
				-- upvalues: t92 (copy), prop_types (copy)
				local v816 = t92.new()

				if t95.badge_id ~= nil then
					v816.badge_id = prop_types.StringProp.jsonDecode(t95.badge_id)
				end

				if t95.badgeId ~= nil then
					v816.badge_id = prop_types.StringProp.jsonDecode(t95.badgeId)
				end

				if t95.title_text ~= nil then
					v816.title_text = prop_types.StringProp.jsonDecode(t95.title_text)
				end

				if t95.titleText ~= nil then
					v816.title_text = prop_types.StringProp.jsonDecode(t95.titleText)
				end

				return v816
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

			function t96.new(t97: {[any]: any}?) -- line: 8751
				-- upvalues: t1 (copy), t96 (copy)
				return (setmetatable({
					action_type = if t97 ~= nil and t97.action_type ~= nil then t97.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t97 ~= nil and t97.action_params ~= nil then t97.action_params else nil
				}, t96))
			end
			function t96.encode(p73) -- line: 8760
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n47 = 0

				if p73.action_type ~= nil and (p73.action_type ~= nil and p73.action_type ~= 0 or p73.action_type ~= t1.ActionType.fromNumber(0)) then
					local v821, v822 = proto.writeTag(buf, n47, 1, proto.wireTypes.varint)

					buf, n47 = proto.writeVarInt(v821, v822, t1.ActionType.toNumber(p73.action_type))
				end

				if p73.action_params ~= nil then
					local v823 = p73.action_params:encode()
					local v824, v825 = proto.writeTag(buf, n47, 2, proto.wireTypes.lengthDelimited)

					buf, n47 = proto.writeBuffer(v824, v825, v823, buffer.len(v823))
				end

				local buf26 = buffer.create(n47)

				buffer.copy(buf26, 0, buf, 0, n47)

				return buf26
			end
			function t96.decode(p74: buffer) -- line: 8786
				-- upvalues: t96 (copy), proto (copy), t1 (copy)
				local v828 = t96.new()
				local n48 = 0

				while n48 < buffer.len(p74) do
					local v830, v831

					v830, v831, n48 = proto.readTag(p74, n48)

					if v831 == proto.wireTypes.varint then
						if v830 == 1 then
							local v832

							v832, n48 = proto.readVarIntI32(p74, n48)
							v828.action_type = t1.ActionType.fromNumber(v832) or v832
						else
							local v833

							v833, n48 = proto.readVarInt(p74, n48)
						end
					elseif v831 == proto.wireTypes.lengthDelimited then
						if v830 == 2 then
							local v834

							v834, n48 = proto.readBuffer(p74, n48)
							v828.action_params = t1.LoadMoreFromApiAction_Params.decode(v834)
						else
							local v835, v836 = proto.readVarInt(p74, n48)

							n48 = v836 + v835
						end
					elseif v831 == proto.wireTypes.i32 then
						local v837

						v837, n48 = proto.readFixed32(p74, n48)
					elseif v831 == proto.wireTypes.i64 then
						local v838

						v838, n48 = proto.readFixed64(p74, n48)
					else
						error("Unsupported wire type: " .. v831)
					end
				end

				return v828
			end
			function t96.jsonEncode(p75) -- line: 8834
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
			function t96.jsonDecode(t99: {[any]: any}) -- line: 8856
				-- upvalues: t96 (copy), t1 (copy)
				local v842 = t96.new()

				if t99.action_type ~= nil then
					v842.action_type = if typeof(t99.action_type) ~= "number" then t1.ActionType.fromName(t99.action_type) or t99.action_type else t1.ActionType.fromNumber(t99.action_type) or t99.action_type
				end

				if t99.actionType ~= nil then
					v842.action_type = if typeof(t99.actionType) ~= "number" then t1.ActionType.fromName(t99.actionType) or t99.actionType else t1.ActionType.fromNumber(t99.actionType) or t99.actionType
				end

				if t99.action_params ~= nil then
					v842.action_params = t1.LoadMoreFromApiAction_Params.jsonDecode(t99.action_params)
				end

				if t99.actionParams ~= nil then
					v842.action_params = t1.LoadMoreFromApiAction_Params.jsonDecode(t99.actionParams)
				end

				return v842
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

			function t100.new(t101: {[any]: any}?) -- line: 8896
				-- upvalues: t100 (copy)
				return (setmetatable({
					surface_key = if t101 ~= nil and t101.surface_key ~= nil then t101.surface_key else nil,
					config_key = if t101 ~= nil and t101.config_key ~= nil then t101.config_key else nil
				}, t100))
			end
			function t100.encode(p76) -- line: 8905
				-- upvalues: proto (copy)
				local buf = buffer.create(0)
				local n49 = 0

				if p76.surface_key ~= nil then
					local v847 = p76.surface_key:encode()
					local v848, v849 = proto.writeTag(buf, n49, 1, proto.wireTypes.lengthDelimited)

					buf, n49 = proto.writeBuffer(v848, v849, v847, buffer.len(v847))
				end

				if p76.config_key ~= nil then
					local v850 = p76.config_key:encode()
					local v851, v852 = proto.writeTag(buf, n49, 2, proto.wireTypes.lengthDelimited)

					buf, n49 = proto.writeBuffer(v851, v852, v850, buffer.len(v850))
				end

				local buf27 = buffer.create(n49)

				buffer.copy(buf27, 0, buf, 0, n49)

				return buf27
			end
			function t100.decode(p77: buffer) -- line: 8926
				-- upvalues: t100 (copy), proto (copy), prop_types (copy)
				local v855 = t100.new()
				local n50 = 0

				while n50 < buffer.len(p77) do
					local v857, v858

					v857, v858, n50 = proto.readTag(p77, n50)

					if v858 == proto.wireTypes.varint then
						local v859

						v859, n50 = proto.readVarInt(p77, n50)
					elseif v858 == proto.wireTypes.lengthDelimited then
						if v857 == 1 then
							local v860

							v860, n50 = proto.readBuffer(p77, n50)
							v855.surface_key = prop_types.StringProp.decode(v860)
						elseif v857 == 2 then
							local v861

							v861, n50 = proto.readBuffer(p77, n50)
							v855.config_key = prop_types.StringProp.decode(v861)
						else
							local v862, v863 = proto.readVarInt(p77, n50)

							n50 = v863 + v862
						end
					elseif v858 == proto.wireTypes.i32 then
						local v864

						v864, n50 = proto.readFixed32(p77, n50)
					elseif v858 == proto.wireTypes.i64 then
						local v865

						v865, n50 = proto.readFixed64(p77, n50)
					else
						error("Unsupported wire type: " .. v858)
					end
				end

				return v855
			end
			function t100.jsonEncode(p78) -- line: 8974
				local t102 = {}

				if p78.surface_key ~= nil then
					t102.surfaceKey = p78.surface_key:jsonEncode()
				end

				if p78.config_key ~= nil then
					t102.configKey = p78.config_key:jsonEncode()
				end

				return t102
			end
			function t100.jsonDecode(t103: {[any]: any}) -- line: 8988
				-- upvalues: t100 (copy), prop_types (copy)
				local v869 = t100.new()

				if t103.surface_key ~= nil then
					v869.surface_key = prop_types.StringProp.jsonDecode(t103.surface_key)
				end

				if t103.surfaceKey ~= nil then
					v869.surface_key = prop_types.StringProp.jsonDecode(t103.surfaceKey)
				end

				if t103.config_key ~= nil then
					v869.config_key = prop_types.StringProp.jsonDecode(t103.config_key)
				end

				if t103.configKey ~= nil then
					v869.config_key = prop_types.StringProp.jsonDecode(t103.configKey)
				end

				return v869
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

			function t104.new(t105: {[any]: any}?) -- line: 9025
				-- upvalues: t1 (copy), t104 (copy)
				return (setmetatable({
					action_type = if t105 ~= nil and t105.action_type ~= nil then t105.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t105 ~= nil and t105.action_params ~= nil then t105.action_params else nil
				}, t104))
			end
			function t104.encode(p79) -- line: 9034
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n51 = 0

				if p79.action_type ~= nil and (p79.action_type ~= nil and p79.action_type ~= 0 or p79.action_type ~= t1.ActionType.fromNumber(0)) then
					local v874, v875 = proto.writeTag(buf, n51, 1, proto.wireTypes.varint)

					buf, n51 = proto.writeVarInt(v874, v875, t1.ActionType.toNumber(p79.action_type))
				end

				if p79.action_params ~= nil then
					local v876 = p79.action_params:encode()
					local v877, v878 = proto.writeTag(buf, n51, 2, proto.wireTypes.lengthDelimited)

					buf, n51 = proto.writeBuffer(v877, v878, v876, buffer.len(v876))
				end

				local buf28 = buffer.create(n51)

				buffer.copy(buf28, 0, buf, 0, n51)

				return buf28
			end
			function t104.decode(p80: buffer) -- line: 9060
				-- upvalues: t104 (copy), proto (copy), t1 (copy)
				local v881 = t104.new()
				local n52 = 0

				while n52 < buffer.len(p80) do
					local v883, v884

					v883, v884, n52 = proto.readTag(p80, n52)

					if v884 == proto.wireTypes.varint then
						if v883 == 1 then
							local v885

							v885, n52 = proto.readVarIntI32(p80, n52)
							v881.action_type = t1.ActionType.fromNumber(v885) or v885
						else
							local v886

							v886, n52 = proto.readVarInt(p80, n52)
						end
					elseif v884 == proto.wireTypes.lengthDelimited then
						if v883 == 2 then
							local v887

							v887, n52 = proto.readBuffer(p80, n52)
							v881.action_params = t1.ShareAction_Params.decode(v887)
						else
							local v888, v889 = proto.readVarInt(p80, n52)

							n52 = v889 + v888
						end
					elseif v884 == proto.wireTypes.i32 then
						local v890

						v890, n52 = proto.readFixed32(p80, n52)
					elseif v884 == proto.wireTypes.i64 then
						local v891

						v891, n52 = proto.readFixed64(p80, n52)
					else
						error("Unsupported wire type: " .. v884)
					end
				end

				return v881
			end
			function t104.jsonEncode(p81) -- line: 9108
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
			function t104.jsonDecode(t107: {[any]: any}) -- line: 9130
				-- upvalues: t104 (copy), t1 (copy)
				local v895 = t104.new()

				if t107.action_type ~= nil then
					v895.action_type = if typeof(t107.action_type) ~= "number" then t1.ActionType.fromName(t107.action_type) or t107.action_type else t1.ActionType.fromNumber(t107.action_type) or t107.action_type
				end

				if t107.actionType ~= nil then
					v895.action_type = if typeof(t107.actionType) ~= "number" then t1.ActionType.fromName(t107.actionType) or t107.actionType else t1.ActionType.fromNumber(t107.actionType) or t107.actionType
				end

				if t107.action_params ~= nil then
					v895.action_params = t1.ShareAction_Params.jsonDecode(t107.action_params)
				end

				if t107.actionParams ~= nil then
					v895.action_params = t1.ShareAction_Params.jsonDecode(t107.actionParams)
				end

				return v895
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

		function t108.new(t109: {[any]: any}?) -- line: 9170
			-- upvalues: t108 (copy)
			return (setmetatable({
				oneof_prop = if t109 ~= nil and t109.oneof_prop ~= nil then t109.oneof_prop else nil
			}, t108))
		end
		function t108.encode(p82) -- line: 9178
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n53 = 0

			if p82.oneof_prop ~= nil then
				if p82.oneof_prop.type == "generic_share_link_data" then
					local v900 = p82.oneof_prop.value:encode()
					local v901, v902 = proto.writeTag(buf, n53, 1, proto.wireTypes.lengthDelimited)

					buf, n53 = proto.writeBuffer(v901, v902, v900, buffer.len(v900))
				elseif p82.oneof_prop.type == "share_link_fetch_data" then
					local v903 = p82.oneof_prop.value:encode()
					local v904, v905 = proto.writeTag(buf, n53, 2, proto.wireTypes.lengthDelimited)

					buf, n53 = proto.writeBuffer(v904, v905, v903, buffer.len(v903))
				end
			end

			local buf29 = buffer.create(n53)

			buffer.copy(buf29, 0, buf, 0, n53)

			return buf29
		end
		function t108.decode(p83: buffer) -- line: 9199
			-- upvalues: t108 (copy), proto (copy), share_link_data (copy)
			local v908 = t108.new()
			local n54 = 0

			while n54 < buffer.len(p83) do
				local v910, v911

				v910, v911, n54 = proto.readTag(p83, n54)

				if v911 == proto.wireTypes.varint then
					local v912

					v912, n54 = proto.readVarInt(p83, n54)
				elseif v911 == proto.wireTypes.lengthDelimited then
					if v910 == 1 then
						local v913

						v913, n54 = proto.readBuffer(p83, n54)
						v908.oneof_prop = {
							type = "generic_share_link_data",
							value = share_link_data.GenericShareLinkData.decode(v913)
						}
					elseif v910 == 2 then
						local v914

						v914, n54 = proto.readBuffer(p83, n54)
						v908.oneof_prop = {
							type = "share_link_fetch_data",
							value = share_link_data.ShareLinkFetchData.decode(v914)
						}
					else
						local v915, v916 = proto.readVarInt(p83, n54)

						n54 = v916 + v915
					end
				elseif v911 == proto.wireTypes.i32 then
					local v917

					v917, n54 = proto.readFixed32(p83, n54)
				elseif v911 == proto.wireTypes.i64 then
					local v918

					v918, n54 = proto.readFixed64(p83, n54)
				else
					error("Unsupported wire type: " .. v911)
				end
			end

			return v908
		end
		function t108.jsonEncode(p84) -- line: 9255
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
		function t108.jsonDecode(t111: {[any]: any}) -- line: 9269
			-- upvalues: t108 (copy), share_link_data (copy)
			local v922 = t108.new()

			if t111.generic_share_link_data ~= nil then
				v922.oneof_prop = {
					type = "generic_share_link_data",
					value = share_link_data.GenericShareLinkData.jsonDecode(t111.generic_share_link_data)
				}
			end

			if t111.genericShareLinkData ~= nil then
				v922.oneof_prop = {
					type = "generic_share_link_data",
					value = share_link_data.GenericShareLinkData.jsonDecode(t111.genericShareLinkData)
				}
			end

			if t111.share_link_fetch_data ~= nil then
				v922.oneof_prop = {
					type = "share_link_fetch_data",
					value = share_link_data.ShareLinkFetchData.jsonDecode(t111.share_link_fetch_data)
				}
			end

			if t111.shareLinkFetchData ~= nil then
				v922.oneof_prop = {
					type = "share_link_fetch_data",
					value = share_link_data.ShareLinkFetchData.jsonDecode(t111.shareLinkFetchData)
				}
			end

			return v922
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

		function t112.new(t113: {[any]: any}?) -- line: 9325
			-- upvalues: t112 (copy)
			return (setmetatable({
				share_link_type = if t113 ~= nil and t113.share_link_type ~= nil then t113.share_link_type else nil,
				share_link_data = if t113 ~= nil and t113.share_link_data ~= nil then t113.share_link_data else nil,
				entry_point_key = if t113 ~= nil and t113.entry_point_key ~= nil then t113.entry_point_key else nil
			}, t112))
		end
		function t112.encode(p85) -- line: 9333
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n55 = 0

			if p85.share_link_type ~= nil then
				local v927 = p85.share_link_type:encode()
				local v928, v929 = proto.writeTag(buf, n55, 1, proto.wireTypes.lengthDelimited)

				buf, n55 = proto.writeBuffer(v928, v929, v927, buffer.len(v927))
			end

			if p85.share_link_data ~= nil then
				local v930 = p85.share_link_data:encode()
				local v931, v932 = proto.writeTag(buf, n55, 2, proto.wireTypes.lengthDelimited)

				buf, n55 = proto.writeBuffer(v931, v932, v930, buffer.len(v930))
			end

			if p85.entry_point_key ~= nil then
				local v933 = p85.entry_point_key:encode()
				local v934, v935 = proto.writeTag(buf, n55, 3, proto.wireTypes.lengthDelimited)

				buf, n55 = proto.writeBuffer(v934, v935, v933, buffer.len(v933))
			end

			local buf30 = buffer.create(n55)

			buffer.copy(buf30, 0, buf, 0, n55)

			return buf30
		end
		function t112.decode(p86: buffer) -- line: 9360
			-- upvalues: t112 (copy), proto (copy), prop_types (copy), t1 (copy)
			local v938 = t112.new()
			local n56 = 0

			while n56 < buffer.len(p86) do
				local v940, v941

				v940, v941, n56 = proto.readTag(p86, n56)

				if v941 == proto.wireTypes.varint then
					local v942

					v942, n56 = proto.readVarInt(p86, n56)
				elseif v941 == proto.wireTypes.lengthDelimited then
					if v940 == 1 then
						local v943

						v943, n56 = proto.readBuffer(p86, n56)
						v938.share_link_type = prop_types.StringProp.decode(v943)
					elseif v940 == 2 then
						local v944

						v944, n56 = proto.readBuffer(p86, n56)
						v938.share_link_data = t1.ShareAction_ShareLinkData.decode(v944)
					elseif v940 == 3 then
						local v945

						v945, n56 = proto.readBuffer(p86, n56)
						v938.entry_point_key = prop_types.StringProp.decode(v945)
					else
						local v946, v947 = proto.readVarInt(p86, n56)

						n56 = v947 + v946
					end
				elseif v941 == proto.wireTypes.i32 then
					local v948

					v948, n56 = proto.readFixed32(p86, n56)
				elseif v941 == proto.wireTypes.i64 then
					local v949

					v949, n56 = proto.readFixed64(p86, n56)
				else
					error("Unsupported wire type: " .. v941)
				end
			end

			return v938
		end
		function t112.jsonEncode(p87) -- line: 9413
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
		function t112.jsonDecode(t115: {[any]: any}) -- line: 9431
			-- upvalues: t112 (copy), prop_types (copy), t1 (copy)
			local v953 = t112.new()

			if t115.share_link_type ~= nil then
				v953.share_link_type = prop_types.StringProp.jsonDecode(t115.share_link_type)
			end

			if t115.shareLinkType ~= nil then
				v953.share_link_type = prop_types.StringProp.jsonDecode(t115.shareLinkType)
			end

			if t115.share_link_data ~= nil then
				v953.share_link_data = t1.ShareAction_ShareLinkData.jsonDecode(t115.share_link_data)
			end

			if t115.shareLinkData ~= nil then
				v953.share_link_data = t1.ShareAction_ShareLinkData.jsonDecode(t115.shareLinkData)
			end

			if t115.entry_point_key ~= nil then
				v953.entry_point_key = prop_types.StringProp.jsonDecode(t115.entry_point_key)
			end

			if t115.entryPointKey ~= nil then
				v953.entry_point_key = prop_types.StringProp.jsonDecode(t115.entryPointKey)
			end

			return v953
		end

		t112.descriptor = {
			name = "ShareAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.ShareAction_Params = t112
		typeRegistry.default:register(t1.ShareAction_Params)

		local t116 = {}

		t116.__index = t116

		function t116.new(t117: {[any]: any}?) -- line: 9479
			-- upvalues: t1 (copy), t116 (copy)
			return (setmetatable({
				action_type = if t117 ~= nil and t117.action_type ~= nil then t117.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t117 ~= nil and t117.action_params ~= nil then t117.action_params else nil
			}, t116))
		end
		function t116.encode(p88) -- line: 9488
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n57 = 0

			if p88.action_type ~= nil and (p88.action_type ~= nil and p88.action_type ~= 0 or p88.action_type ~= t1.ActionType.fromNumber(0)) then
				local v958, v959 = proto.writeTag(buf, n57, 1, proto.wireTypes.varint)

				buf, n57 = proto.writeVarInt(v958, v959, t1.ActionType.toNumber(p88.action_type))
			end

			if p88.action_params ~= nil then
				local v960 = p88.action_params:encode()
				local v961, v962 = proto.writeTag(buf, n57, 2, proto.wireTypes.lengthDelimited)

				buf, n57 = proto.writeBuffer(v961, v962, v960, buffer.len(v960))
			end

			local buf31 = buffer.create(n57)

			buffer.copy(buf31, 0, buf, 0, n57)

			return buf31
		end
		function t116.decode(p89: buffer) -- line: 9514
			-- upvalues: t116 (copy), proto (copy), t1 (copy)
			local v965 = t116.new()
			local n58 = 0

			while n58 < buffer.len(p89) do
				local v967, v968

				v967, v968, n58 = proto.readTag(p89, n58)

				if v968 == proto.wireTypes.varint then
					if v967 == 1 then
						local v969

						v969, n58 = proto.readVarIntI32(p89, n58)
						v965.action_type = t1.ActionType.fromNumber(v969) or v969
					else
						local v970

						v970, n58 = proto.readVarInt(p89, n58)
					end
				elseif v968 == proto.wireTypes.lengthDelimited then
					if v967 == 2 then
						local v971

						v971, n58 = proto.readBuffer(p89, n58)
						v965.action_params = t1.OpenAbuseReportAction_Params.decode(v971)
					else
						local v972, v973 = proto.readVarInt(p89, n58)

						n58 = v973 + v972
					end
				elseif v968 == proto.wireTypes.i32 then
					local v974

					v974, n58 = proto.readFixed32(p89, n58)
				elseif v968 == proto.wireTypes.i64 then
					local v975

					v975, n58 = proto.readFixed64(p89, n58)
				else
					error("Unsupported wire type: " .. v968)
				end
			end

			return v965
		end
		function t116.jsonEncode(p90) -- line: 9562
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
		function t116.jsonDecode(t119: {[any]: any}) -- line: 9584
			-- upvalues: t116 (copy), t1 (copy)
			local v979 = t116.new()

			if t119.action_type ~= nil then
				v979.action_type = if typeof(t119.action_type) ~= "number" then t1.ActionType.fromName(t119.action_type) or t119.action_type else t1.ActionType.fromNumber(t119.action_type) or t119.action_type
			end

			if t119.actionType ~= nil then
				v979.action_type = if typeof(t119.actionType) ~= "number" then t1.ActionType.fromName(t119.actionType) or t119.actionType else t1.ActionType.fromNumber(t119.actionType) or t119.actionType
			end

			if t119.action_params ~= nil then
				v979.action_params = t1.OpenAbuseReportAction_Params.jsonDecode(t119.action_params)
			end

			if t119.actionParams ~= nil then
				v979.action_params = t1.OpenAbuseReportAction_Params.jsonDecode(t119.actionParams)
			end

			return v979
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

		function t120.new(t121: {[any]: any}?) -- line: 9624
			-- upvalues: t120 (copy)
			return (setmetatable({
				target_id = if t121 ~= nil and t121.target_id ~= nil then t121.target_id else nil,
				abuse_vector = if t121 ~= nil and t121.abuse_vector ~= nil then t121.abuse_vector else nil,
				asset_type_name = if t121 ~= nil and t121.asset_type_name ~= nil then t121.asset_type_name else nil,
				universe_id = if t121 ~= nil and t121.universe_id ~= nil then t121.universe_id else nil
			}, t120))
		end
		function t120.encode(p91) -- line: 9635
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n59 = 0

			if p91.target_id ~= nil then
				local v984 = p91.target_id:encode()
				local v985, v986 = proto.writeTag(buf, n59, 1, proto.wireTypes.lengthDelimited)

				buf, n59 = proto.writeBuffer(v985, v986, v984, buffer.len(v984))
			end

			if p91.abuse_vector ~= nil then
				local v987 = p91.abuse_vector:encode()
				local v988, v989 = proto.writeTag(buf, n59, 2, proto.wireTypes.lengthDelimited)

				buf, n59 = proto.writeBuffer(v988, v989, v987, buffer.len(v987))
			end

			if p91.asset_type_name ~= nil then
				local v990 = p91.asset_type_name:encode()
				local v991, v992 = proto.writeTag(buf, n59, 3, proto.wireTypes.lengthDelimited)

				buf, n59 = proto.writeBuffer(v991, v992, v990, buffer.len(v990))
			end

			if p91.universe_id ~= nil then
				local v993 = p91.universe_id:encode()
				local v994, v995 = proto.writeTag(buf, n59, 4, proto.wireTypes.lengthDelimited)

				buf, n59 = proto.writeBuffer(v994, v995, v993, buffer.len(v993))
			end

			local buf32 = buffer.create(n59)

			buffer.copy(buf32, 0, buf, 0, n59)

			return buf32
		end
		function t120.decode(p92: buffer) -- line: 9668
			-- upvalues: t120 (copy), proto (copy), prop_types (copy)
			local v998 = t120.new()
			local n60 = 0

			while n60 < buffer.len(p92) do
				local v1000, v1001

				v1000, v1001, n60 = proto.readTag(p92, n60)

				if v1001 == proto.wireTypes.varint then
					local v1002

					v1002, n60 = proto.readVarInt(p92, n60)
				elseif v1001 == proto.wireTypes.lengthDelimited then
					if v1000 == 1 then
						local v1003

						v1003, n60 = proto.readBuffer(p92, n60)
						v998.target_id = prop_types.StringProp.decode(v1003)
					elseif v1000 == 2 then
						local v1004

						v1004, n60 = proto.readBuffer(p92, n60)
						v998.abuse_vector = prop_types.StringProp.decode(v1004)
					elseif v1000 == 3 then
						local v1005

						v1005, n60 = proto.readBuffer(p92, n60)
						v998.asset_type_name = prop_types.StringProp.decode(v1005)
					elseif v1000 == 4 then
						local v1006

						v1006, n60 = proto.readBuffer(p92, n60)
						v998.universe_id = prop_types.StringProp.decode(v1006)
					else
						local v1007, v1008 = proto.readVarInt(p92, n60)

						n60 = v1008 + v1007
					end
				elseif v1001 == proto.wireTypes.i32 then
					local v1009

					v1009, n60 = proto.readFixed32(p92, n60)
				elseif v1001 == proto.wireTypes.i64 then
					local v1010

					v1010, n60 = proto.readFixed64(p92, n60)
				else
					error("Unsupported wire type: " .. v1001)
				end
			end

			return v998
		end
		function t120.jsonEncode(p93) -- line: 9726
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
		function t120.jsonDecode(t123: {[any]: any}) -- line: 9748
			-- upvalues: t120 (copy), prop_types (copy)
			local v1014 = t120.new()

			if t123.target_id ~= nil then
				v1014.target_id = prop_types.StringProp.jsonDecode(t123.target_id)
			end

			if t123.targetId ~= nil then
				v1014.target_id = prop_types.StringProp.jsonDecode(t123.targetId)
			end

			if t123.abuse_vector ~= nil then
				v1014.abuse_vector = prop_types.StringProp.jsonDecode(t123.abuse_vector)
			end

			if t123.abuseVector ~= nil then
				v1014.abuse_vector = prop_types.StringProp.jsonDecode(t123.abuseVector)
			end

			if t123.asset_type_name ~= nil then
				v1014.asset_type_name = prop_types.StringProp.jsonDecode(t123.asset_type_name)
			end

			if t123.assetTypeName ~= nil then
				v1014.asset_type_name = prop_types.StringProp.jsonDecode(t123.assetTypeName)
			end

			if t123.universe_id ~= nil then
				v1014.universe_id = prop_types.StringProp.jsonDecode(t123.universe_id)
			end

			if t123.universeId ~= nil then
				v1014.universe_id = prop_types.StringProp.jsonDecode(t123.universeId)
			end

			return v1014
		end

		t120.descriptor = {
			name = "OpenAbuseReportAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenAbuseReportAction_Params = t120
		typeRegistry.default:register(t1.OpenAbuseReportAction_Params)

		local t124 = {}

		t124.__index = t124

		function t124.new(t125: {[any]: any}?) -- line: 9805
			-- upvalues: t1 (copy), t124 (copy)
			return (setmetatable({
				action_type = if t125 ~= nil and t125.action_type ~= nil then t125.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t125 ~= nil and t125.action_params ~= nil then t125.action_params else nil
			}, t124))
		end
		function t124.encode(p94) -- line: 9816
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n61 = 0

			if p94.action_type ~= nil and (p94.action_type ~= nil and p94.action_type ~= 0 or p94.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1019, v1020 = proto.writeTag(buf, n61, 1, proto.wireTypes.varint)

				buf, n61 = proto.writeVarInt(v1019, v1020, t1.ActionType.toNumber(p94.action_type))
			end

			if p94.action_params ~= nil then
				local v1021 = p94.action_params:encode()
				local v1022, v1023 = proto.writeTag(buf, n61, 2, proto.wireTypes.lengthDelimited)

				buf, n61 = proto.writeBuffer(v1022, v1023, v1021, buffer.len(v1021))
			end

			local buf33 = buffer.create(n61)

			buffer.copy(buf33, 0, buf, 0, n61)

			return buf33
		end
		function t124.decode(p95: buffer) -- line: 9842
			-- upvalues: t124 (copy), proto (copy), t1 (copy)
			local v1026 = t124.new()
			local n62 = 0

			while n62 < buffer.len(p95) do
				local v1028, v1029

				v1028, v1029, n62 = proto.readTag(p95, n62)

				if v1029 == proto.wireTypes.varint then
					if v1028 == 1 then
						local v1030

						v1030, n62 = proto.readVarIntI32(p95, n62)
						v1026.action_type = t1.ActionType.fromNumber(v1030) or v1030
					else
						local v1031

						v1031, n62 = proto.readVarInt(p95, n62)
					end
				elseif v1029 == proto.wireTypes.lengthDelimited then
					if v1028 == 2 then
						local v1032

						v1032, n62 = proto.readBuffer(p95, n62)
						v1026.action_params = t1.RemoveBadgeFromInventoryAction_Params.decode(v1032)
					else
						local v1033, v1034 = proto.readVarInt(p95, n62)

						n62 = v1034 + v1033
					end
				elseif v1029 == proto.wireTypes.i32 then
					local v1035

					v1035, n62 = proto.readFixed32(p95, n62)
				elseif v1029 == proto.wireTypes.i64 then
					local v1036

					v1036, n62 = proto.readFixed64(p95, n62)
				else
					error("Unsupported wire type: " .. v1029)
				end
			end

			return v1026
		end
		function t124.jsonEncode(p96) -- line: 9890
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
		function t124.jsonDecode(t127: {[any]: any}) -- line: 9912
			-- upvalues: t124 (copy), t1 (copy)
			local v1040 = t124.new()

			if t127.action_type ~= nil then
				v1040.action_type = if typeof(t127.action_type) ~= "number" then t1.ActionType.fromName(t127.action_type) or t127.action_type else t1.ActionType.fromNumber(t127.action_type) or t127.action_type
			end

			if t127.actionType ~= nil then
				v1040.action_type = if typeof(t127.actionType) ~= "number" then t1.ActionType.fromName(t127.actionType) or t127.actionType else t1.ActionType.fromNumber(t127.actionType) or t127.actionType
			end

			if t127.action_params ~= nil then
				v1040.action_params = t1.RemoveBadgeFromInventoryAction_Params.jsonDecode(t127.action_params)
			end

			if t127.actionParams ~= nil then
				v1040.action_params = t1.RemoveBadgeFromInventoryAction_Params.jsonDecode(t127.actionParams)
			end

			return v1040
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

		function t128.new(t129: {[any]: any}?) -- line: 9952
			-- upvalues: t128 (copy)
			return (setmetatable({
				asset_id = if t129 ~= nil and t129.asset_id ~= nil then t129.asset_id else nil
			}, t128))
		end
		function t128.encode(p97) -- line: 9960
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n63 = 0

			if p97.asset_id ~= nil then
				local v1045 = p97.asset_id:encode()
				local v1046, v1047 = proto.writeTag(buf, n63, 1, proto.wireTypes.lengthDelimited)

				buf, n63 = proto.writeBuffer(v1046, v1047, v1045, buffer.len(v1045))
			end

			local buf34 = buffer.create(n63)

			buffer.copy(buf34, 0, buf, 0, n63)

			return buf34
		end
		function t128.decode(p98: buffer) -- line: 9975
			-- upvalues: t128 (copy), proto (copy), prop_types (copy)
			local v1050 = t128.new()
			local n64 = 0

			while n64 < buffer.len(p98) do
				local v1052, v1053

				v1052, v1053, n64 = proto.readTag(p98, n64)

				if v1053 == proto.wireTypes.varint then
					local v1054

					v1054, n64 = proto.readVarInt(p98, n64)
				elseif v1053 == proto.wireTypes.lengthDelimited then
					if v1052 == 1 then
						local v1055

						v1055, n64 = proto.readBuffer(p98, n64)
						v1050.asset_id = prop_types.StringProp.decode(v1055)
					else
						local v1056, v1057 = proto.readVarInt(p98, n64)

						n64 = v1057 + v1056
					end
				elseif v1053 == proto.wireTypes.i32 then
					local v1058

					v1058, n64 = proto.readFixed32(p98, n64)
				elseif v1053 == proto.wireTypes.i64 then
					local v1059

					v1059, n64 = proto.readFixed64(p98, n64)
				else
					error("Unsupported wire type: " .. v1053)
				end
			end

			return v1050
		end
		function t128.jsonEncode(p99) -- line: 10018
			local t130 = {}

			if p99.asset_id ~= nil then
				t130.assetId = p99.asset_id:jsonEncode()
			end

			return t130
		end
		function t128.jsonDecode(t131: {[any]: any}) -- line: 10028
			-- upvalues: t128 (copy), prop_types (copy)
			local v1063 = t128.new()

			if t131.asset_id ~= nil then
				v1063.asset_id = prop_types.StringProp.jsonDecode(t131.asset_id)
			end

			if t131.assetId ~= nil then
				v1063.asset_id = prop_types.StringProp.jsonDecode(t131.assetId)
			end

			return v1063
		end

		t128.descriptor = {
			name = "RemoveBadgeFromInventoryAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.RemoveBadgeFromInventoryAction_Params = t128
		typeRegistry.default:register(t1.RemoveBadgeFromInventoryAction_Params)

		local t132 = {}

		t132.__index = t132

		function t132.new(t133: {[any]: any}?) -- line: 10058
			-- upvalues: t1 (copy), t132 (copy)
			return (setmetatable({
				action_type = if t133 ~= nil and t133.action_type ~= nil then t133.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t133 ~= nil and t133.action_params ~= nil then t133.action_params else nil
			}, t132))
		end
		function t132.encode(p100) -- line: 10067
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n65 = 0

			if p100.action_type ~= nil and (p100.action_type ~= nil and p100.action_type ~= 0 or p100.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1068, v1069 = proto.writeTag(buf, n65, 1, proto.wireTypes.varint)

				buf, n65 = proto.writeVarInt(v1068, v1069, t1.ActionType.toNumber(p100.action_type))
			end

			if p100.action_params ~= nil then
				local v1070 = p100.action_params:encode()
				local v1071, v1072 = proto.writeTag(buf, n65, 2, proto.wireTypes.lengthDelimited)

				buf, n65 = proto.writeBuffer(v1071, v1072, v1070, buffer.len(v1070))
			end

			local buf35 = buffer.create(n65)

			buffer.copy(buf35, 0, buf, 0, n65)

			return buf35
		end
		function t132.decode(p101: buffer) -- line: 10093
			-- upvalues: t132 (copy), proto (copy), t1 (copy)
			local v1075 = t132.new()
			local n66 = 0

			while n66 < buffer.len(p101) do
				local v1077, v1078

				v1077, v1078, n66 = proto.readTag(p101, n66)

				if v1078 == proto.wireTypes.varint then
					if v1077 == 1 then
						local v1079

						v1079, n66 = proto.readVarIntI32(p101, n66)
						v1075.action_type = t1.ActionType.fromNumber(v1079) or v1079
					else
						local v1080

						v1080, n66 = proto.readVarInt(p101, n66)
					end
				elseif v1078 == proto.wireTypes.lengthDelimited then
					if v1077 == 2 then
						local v1081

						v1081, n66 = proto.readBuffer(p101, n66)
						v1075.action_params = t1.OpenProfileAction_Params.decode(v1081)
					else
						local v1082, v1083 = proto.readVarInt(p101, n66)

						n66 = v1083 + v1082
					end
				elseif v1078 == proto.wireTypes.i32 then
					local v1084

					v1084, n66 = proto.readFixed32(p101, n66)
				elseif v1078 == proto.wireTypes.i64 then
					local v1085

					v1085, n66 = proto.readFixed64(p101, n66)
				else
					error("Unsupported wire type: " .. v1078)
				end
			end

			return v1075
		end
		function t132.jsonEncode(p102) -- line: 10141
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
		function t132.jsonDecode(t135: {[any]: any}) -- line: 10163
			-- upvalues: t132 (copy), t1 (copy)
			local v1089 = t132.new()

			if t135.action_type ~= nil then
				v1089.action_type = if typeof(t135.action_type) ~= "number" then t1.ActionType.fromName(t135.action_type) or t135.action_type else t1.ActionType.fromNumber(t135.action_type) or t135.action_type
			end

			if t135.actionType ~= nil then
				v1089.action_type = if typeof(t135.actionType) ~= "number" then t1.ActionType.fromName(t135.actionType) or t135.actionType else t1.ActionType.fromNumber(t135.actionType) or t135.actionType
			end

			if t135.action_params ~= nil then
				v1089.action_params = t1.OpenProfileAction_Params.jsonDecode(t135.action_params)
			end

			if t135.actionParams ~= nil then
				v1089.action_params = t1.OpenProfileAction_Params.jsonDecode(t135.actionParams)
			end

			return v1089
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

		function t136.new(t137: {[any]: any}?) -- line: 10203
			-- upvalues: t136 (copy)
			return (setmetatable({
				profile_id = if t137 ~= nil and t137.profile_id ~= nil then t137.profile_id else nil,
				profile_type = if t137 ~= nil and t137.profile_type ~= nil then t137.profile_type else nil,
				source = if t137 ~= nil and t137.source ~= nil then t137.source else nil
			}, t136))
		end
		function t136.encode(p103) -- line: 10211
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n67 = 0

			if p103.profile_id ~= nil then
				local v1094 = p103.profile_id:encode()
				local v1095, v1096 = proto.writeTag(buf, n67, 1, proto.wireTypes.lengthDelimited)

				buf, n67 = proto.writeBuffer(v1095, v1096, v1094, buffer.len(v1094))
			end

			if p103.profile_type ~= nil then
				local v1097 = p103.profile_type:encode()
				local v1098, v1099 = proto.writeTag(buf, n67, 2, proto.wireTypes.lengthDelimited)

				buf, n67 = proto.writeBuffer(v1098, v1099, v1097, buffer.len(v1097))
			end

			if p103.source ~= nil then
				local v1100 = p103.source:encode()
				local v1101, v1102 = proto.writeTag(buf, n67, 3, proto.wireTypes.lengthDelimited)

				buf, n67 = proto.writeBuffer(v1101, v1102, v1100, buffer.len(v1100))
			end

			local buf36 = buffer.create(n67)

			buffer.copy(buf36, 0, buf, 0, n67)

			return buf36
		end
		function t136.decode(p104: buffer) -- line: 10238
			-- upvalues: t136 (copy), proto (copy), prop_types (copy)
			local v1105 = t136.new()
			local n68 = 0

			while n68 < buffer.len(p104) do
				local v1107, v1108

				v1107, v1108, n68 = proto.readTag(p104, n68)

				if v1108 == proto.wireTypes.varint then
					local v1109

					v1109, n68 = proto.readVarInt(p104, n68)
				elseif v1108 == proto.wireTypes.lengthDelimited then
					if v1107 == 1 then
						local v1110

						v1110, n68 = proto.readBuffer(p104, n68)
						v1105.profile_id = prop_types.StringProp.decode(v1110)
					elseif v1107 == 2 then
						local v1111

						v1111, n68 = proto.readBuffer(p104, n68)
						v1105.profile_type = prop_types.StringProp.decode(v1111)
					elseif v1107 == 3 then
						local v1112

						v1112, n68 = proto.readBuffer(p104, n68)
						v1105.source = prop_types.StringProp.decode(v1112)
					else
						local v1113, v1114 = proto.readVarInt(p104, n68)

						n68 = v1114 + v1113
					end
				elseif v1108 == proto.wireTypes.i32 then
					local v1115

					v1115, n68 = proto.readFixed32(p104, n68)
				elseif v1108 == proto.wireTypes.i64 then
					local v1116

					v1116, n68 = proto.readFixed64(p104, n68)
				else
					error("Unsupported wire type: " .. v1108)
				end
			end

			return v1105
		end
		function t136.jsonEncode(p105) -- line: 10291
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
		function t136.jsonDecode(t139: {[any]: any}) -- line: 10309
			-- upvalues: t136 (copy), prop_types (copy)
			local v1120 = t136.new()

			if t139.profile_id ~= nil then
				v1120.profile_id = prop_types.StringProp.jsonDecode(t139.profile_id)
			end

			if t139.profileId ~= nil then
				v1120.profile_id = prop_types.StringProp.jsonDecode(t139.profileId)
			end

			if t139.profile_type ~= nil then
				v1120.profile_type = prop_types.StringProp.jsonDecode(t139.profile_type)
			end

			if t139.profileType ~= nil then
				v1120.profile_type = prop_types.StringProp.jsonDecode(t139.profileType)
			end

			if t139.source ~= nil then
				v1120.source = prop_types.StringProp.jsonDecode(t139.source)
			end

			return v1120
		end

		t136.descriptor = {
			name = "OpenProfileAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenProfileAction_Params = t136
		typeRegistry.default:register(t1.OpenProfileAction_Params)

		local t140 = {}

		t140.__index = t140

		function t140.new(t141: {[any]: any}?) -- line: 10351
			-- upvalues: t1 (copy), t140 (copy)
			return (setmetatable({
				action_type = if t141 ~= nil and t141.action_type ~= nil then t141.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t141 ~= nil and t141.action_params ~= nil then t141.action_params else nil
			}, t140))
		end
		function t140.encode(p106) -- line: 10362
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n69 = 0

			if p106.action_type ~= nil and (p106.action_type ~= nil and p106.action_type ~= 0 or p106.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1125, v1126 = proto.writeTag(buf, n69, 1, proto.wireTypes.varint)

				buf, n69 = proto.writeVarInt(v1125, v1126, t1.ActionType.toNumber(p106.action_type))
			end

			if p106.action_params ~= nil then
				local v1127 = p106.action_params:encode()
				local v1128, v1129 = proto.writeTag(buf, n69, 2, proto.wireTypes.lengthDelimited)

				buf, n69 = proto.writeBuffer(v1128, v1129, v1127, buffer.len(v1127))
			end

			local buf37 = buffer.create(n69)

			buffer.copy(buf37, 0, buf, 0, n69)

			return buf37
		end
		function t140.decode(p107: buffer) -- line: 10388
			-- upvalues: t140 (copy), proto (copy), t1 (copy)
			local v1132 = t140.new()
			local n70 = 0

			while n70 < buffer.len(p107) do
				local v1134, v1135

				v1134, v1135, n70 = proto.readTag(p107, n70)

				if v1135 == proto.wireTypes.varint then
					if v1134 == 1 then
						local v1136

						v1136, n70 = proto.readVarIntI32(p107, n70)
						v1132.action_type = t1.ActionType.fromNumber(v1136) or v1136
					else
						local v1137

						v1137, n70 = proto.readVarInt(p107, n70)
					end
				elseif v1135 == proto.wireTypes.lengthDelimited then
					if v1134 == 2 then
						local v1138

						v1138, n70 = proto.readBuffer(p107, n70)
						v1132.action_params = t1.OpenFacialAgeEstimationAction_Params.decode(v1138)
					else
						local v1139, v1140 = proto.readVarInt(p107, n70)

						n70 = v1140 + v1139
					end
				elseif v1135 == proto.wireTypes.i32 then
					local v1141

					v1141, n70 = proto.readFixed32(p107, n70)
				elseif v1135 == proto.wireTypes.i64 then
					local v1142

					v1142, n70 = proto.readFixed64(p107, n70)
				else
					error("Unsupported wire type: " .. v1135)
				end
			end

			return v1132
		end
		function t140.jsonEncode(p108) -- line: 10436
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
		function t140.jsonDecode(t143: {[any]: any}) -- line: 10458
			-- upvalues: t140 (copy), t1 (copy)
			local v1146 = t140.new()

			if t143.action_type ~= nil then
				v1146.action_type = if typeof(t143.action_type) ~= "number" then t1.ActionType.fromName(t143.action_type) or t143.action_type else t1.ActionType.fromNumber(t143.action_type) or t143.action_type
			end

			if t143.actionType ~= nil then
				v1146.action_type = if typeof(t143.actionType) ~= "number" then t1.ActionType.fromName(t143.actionType) or t143.actionType else t1.ActionType.fromNumber(t143.actionType) or t143.actionType
			end

			if t143.action_params ~= nil then
				v1146.action_params = t1.OpenFacialAgeEstimationAction_Params.jsonDecode(t143.action_params)
			end

			if t143.actionParams ~= nil then
				v1146.action_params = t1.OpenFacialAgeEstimationAction_Params.jsonDecode(t143.actionParams)
			end

			return v1146
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

		function t144.new(t145: {[any]: any}?) -- line: 10498
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
		function t144.encode(p109) -- line: 10511
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n71 = 0

			if p109.user_id ~= nil then
				local v1151 = p109.user_id:encode()
				local v1152, v1153 = proto.writeTag(buf, n71, 1, proto.wireTypes.lengthDelimited)

				buf, n71 = proto.writeBuffer(v1152, v1153, v1151, buffer.len(v1151))
			end

			if p109.source ~= nil then
				local v1154 = p109.source:encode()
				local v1155, v1156 = proto.writeTag(buf, n71, 2, proto.wireTypes.lengthDelimited)

				buf, n71 = proto.writeBuffer(v1155, v1156, v1154, buffer.len(v1154))
			end

			if p109.context ~= nil then
				local v1157 = p109.context:encode()
				local v1158, v1159 = proto.writeTag(buf, n71, 3, proto.wireTypes.lengthDelimited)

				buf, n71 = proto.writeBuffer(v1158, v1159, v1157, buffer.len(v1157))
			end

			if p109.is_in_experience ~= nil then
				local v1160 = p109.is_in_experience:encode()
				local v1161, v1162 = proto.writeTag(buf, n71, 4, proto.wireTypes.lengthDelimited)

				buf, n71 = proto.writeBuffer(v1161, v1162, v1160, buffer.len(v1160))
			end

			if p109.on_success ~= nil then
				local v1163 = p109.on_success:encode()
				local v1164, v1165 = proto.writeTag(buf, n71, 5, proto.wireTypes.lengthDelimited)

				buf, n71 = proto.writeBuffer(v1164, v1165, v1163, buffer.len(v1163))
			end

			if p109.on_failure ~= nil then
				local v1166 = p109.on_failure:encode()
				local v1167, v1168 = proto.writeTag(buf, n71, 6, proto.wireTypes.lengthDelimited)

				buf, n71 = proto.writeBuffer(v1167, v1168, v1166, buffer.len(v1166))
			end

			local buf38 = buffer.create(n71)

			buffer.copy(buf38, 0, buf, 0, n71)

			return buf38
		end
		function t144.decode(p110: buffer) -- line: 10556
			-- upvalues: t144 (copy), proto (copy), prop_types (copy), t1 (copy)
			local v1171 = t144.new()
			local n72 = 0

			while n72 < buffer.len(p110) do
				local v1173, v1174

				v1173, v1174, n72 = proto.readTag(p110, n72)

				if v1174 == proto.wireTypes.varint then
					local v1175

					v1175, n72 = proto.readVarInt(p110, n72)
				elseif v1174 == proto.wireTypes.lengthDelimited then
					if v1173 == 1 then
						local v1176

						v1176, n72 = proto.readBuffer(p110, n72)
						v1171.user_id = prop_types.StringProp.decode(v1176)
					elseif v1173 == 2 then
						local v1177

						v1177, n72 = proto.readBuffer(p110, n72)
						v1171.source = prop_types.StringProp.decode(v1177)
					elseif v1173 == 3 then
						local v1178

						v1178, n72 = proto.readBuffer(p110, n72)
						v1171.context = prop_types.StringProp.decode(v1178)
					elseif v1173 == 4 then
						local v1179

						v1179, n72 = proto.readBuffer(p110, n72)
						v1171.is_in_experience = prop_types.BoolProp.decode(v1179)
					elseif v1173 == 5 then
						local v1180

						v1180, n72 = proto.readBuffer(p110, n72)
						v1171.on_success = t1.ActionProp.decode(v1180)
					elseif v1173 == 6 then
						local v1181

						v1181, n72 = proto.readBuffer(p110, n72)
						v1171.on_failure = t1.ActionProp.decode(v1181)
					else
						local v1182, v1183 = proto.readVarInt(p110, n72)

						n72 = v1183 + v1182
					end
				elseif v1174 == proto.wireTypes.i32 then
					local v1184

					v1184, n72 = proto.readFixed32(p110, n72)
				elseif v1174 == proto.wireTypes.i64 then
					local v1185

					v1185, n72 = proto.readFixed64(p110, n72)
				else
					error("Unsupported wire type: " .. v1174)
				end
			end

			return v1171
		end
		function t144.jsonEncode(p111) -- line: 10624
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
		function t144.jsonDecode(t147: {[any]: any}) -- line: 10654
			-- upvalues: t144 (copy), prop_types (copy), t1 (copy)
			local v1189 = t144.new()

			if t147.user_id ~= nil then
				v1189.user_id = prop_types.StringProp.jsonDecode(t147.user_id)
			end

			if t147.userId ~= nil then
				v1189.user_id = prop_types.StringProp.jsonDecode(t147.userId)
			end

			if t147.source ~= nil then
				v1189.source = prop_types.StringProp.jsonDecode(t147.source)
			end

			if t147.context ~= nil then
				v1189.context = prop_types.StringProp.jsonDecode(t147.context)
			end

			if t147.is_in_experience ~= nil then
				v1189.is_in_experience = prop_types.BoolProp.jsonDecode(t147.is_in_experience)
			end

			if t147.isInExperience ~= nil then
				v1189.is_in_experience = prop_types.BoolProp.jsonDecode(t147.isInExperience)
			end

			if t147.on_success ~= nil then
				v1189.on_success = t1.ActionProp.jsonDecode(t147.on_success)
			end

			if t147.onSuccess ~= nil then
				v1189.on_success = t1.ActionProp.jsonDecode(t147.onSuccess)
			end

			if t147.on_failure ~= nil then
				v1189.on_failure = t1.ActionProp.jsonDecode(t147.on_failure)
			end

			if t147.onFailure ~= nil then
				v1189.on_failure = t1.ActionProp.jsonDecode(t147.onFailure)
			end

			return v1189
		end

		t144.descriptor = {
			name = "OpenFacialAgeEstimationAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenFacialAgeEstimationAction_Params = t144
		typeRegistry.default:register(t1.OpenFacialAgeEstimationAction_Params)

		local t148 = {}

		t148.__index = t148

		function t148.new(t149: {[any]: any}?) -- line: 10718
			-- upvalues: t1 (copy), t148 (copy)
			return (setmetatable({
				action_type = if t149 ~= nil and t149.action_type ~= nil then t149.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t149 ~= nil and t149.action_params ~= nil then t149.action_params else nil
			}, t148))
		end
		function t148.encode(p112) -- line: 10727
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n73 = 0

			if p112.action_type ~= nil and (p112.action_type ~= nil and p112.action_type ~= 0 or p112.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1194, v1195 = proto.writeTag(buf, n73, 1, proto.wireTypes.varint)

				buf, n73 = proto.writeVarInt(v1194, v1195, t1.ActionType.toNumber(p112.action_type))
			end

			if p112.action_params ~= nil then
				local v1196 = p112.action_params:encode()
				local v1197, v1198 = proto.writeTag(buf, n73, 2, proto.wireTypes.lengthDelimited)

				buf, n73 = proto.writeBuffer(v1197, v1198, v1196, buffer.len(v1196))
			end

			local buf39 = buffer.create(n73)

			buffer.copy(buf39, 0, buf, 0, n73)

			return buf39
		end
		function t148.decode(p113: buffer) -- line: 10753
			-- upvalues: t148 (copy), proto (copy), t1 (copy)
			local v1201 = t148.new()
			local n74 = 0

			while n74 < buffer.len(p113) do
				local v1203, v1204

				v1203, v1204, n74 = proto.readTag(p113, n74)

				if v1204 == proto.wireTypes.varint then
					if v1203 == 1 then
						local v1205

						v1205, n74 = proto.readVarIntI32(p113, n74)
						v1201.action_type = t1.ActionType.fromNumber(v1205) or v1205
					else
						local v1206

						v1206, n74 = proto.readVarInt(p113, n74)
					end
				elseif v1204 == proto.wireTypes.lengthDelimited then
					if v1203 == 2 then
						local v1207

						v1207, n74 = proto.readBuffer(p113, n74)
						v1201.action_params = t1.ShowToastAction_Params.decode(v1207)
					else
						local v1208, v1209 = proto.readVarInt(p113, n74)

						n74 = v1209 + v1208
					end
				elseif v1204 == proto.wireTypes.i32 then
					local v1210

					v1210, n74 = proto.readFixed32(p113, n74)
				elseif v1204 == proto.wireTypes.i64 then
					local v1211

					v1211, n74 = proto.readFixed64(p113, n74)
				else
					error("Unsupported wire type: " .. v1204)
				end
			end

			return v1201
		end
		function t148.jsonEncode(p114) -- line: 10801
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
		function t148.jsonDecode(t151: {[any]: any}) -- line: 10823
			-- upvalues: t148 (copy), t1 (copy)
			local v1215 = t148.new()

			if t151.action_type ~= nil then
				v1215.action_type = if typeof(t151.action_type) ~= "number" then t1.ActionType.fromName(t151.action_type) or t151.action_type else t1.ActionType.fromNumber(t151.action_type) or t151.action_type
			end

			if t151.actionType ~= nil then
				v1215.action_type = if typeof(t151.actionType) ~= "number" then t1.ActionType.fromName(t151.actionType) or t151.actionType else t1.ActionType.fromNumber(t151.actionType) or t151.actionType
			end

			if t151.action_params ~= nil then
				v1215.action_params = t1.ShowToastAction_Params.jsonDecode(t151.action_params)
			end

			if t151.actionParams ~= nil then
				v1215.action_params = t1.ShowToastAction_Params.jsonDecode(t151.actionParams)
			end

			return v1215
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

		function t152.new(t153: {[any]: any}?) -- line: 10863
			-- upvalues: t152 (copy)
			return (setmetatable({
				message_key = if t153 ~= nil and t153.message_key ~= nil then t153.message_key else nil,
				toast_type = if t153 ~= nil and t153.toast_type ~= nil then t153.toast_type else nil
			}, t152))
		end
		function t152.encode(p115) -- line: 10870
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n75 = 0

			if p115.message_key ~= nil then
				local v1220 = p115.message_key:encode()
				local v1221, v1222 = proto.writeTag(buf, n75, 1, proto.wireTypes.lengthDelimited)

				buf, n75 = proto.writeBuffer(v1221, v1222, v1220, buffer.len(v1220))
			end

			if p115.toast_type ~= nil then
				local v1223 = p115.toast_type:encode()
				local v1224, v1225 = proto.writeTag(buf, n75, 2, proto.wireTypes.lengthDelimited)

				buf, n75 = proto.writeBuffer(v1224, v1225, v1223, buffer.len(v1223))
			end

			local buf40 = buffer.create(n75)

			buffer.copy(buf40, 0, buf, 0, n75)

			return buf40
		end
		function t152.decode(p116: buffer) -- line: 10891
			-- upvalues: t152 (copy), proto (copy), prop_types (copy)
			local v1228 = t152.new()
			local n76 = 0

			while n76 < buffer.len(p116) do
				local v1230, v1231

				v1230, v1231, n76 = proto.readTag(p116, n76)

				if v1231 == proto.wireTypes.varint then
					local v1232

					v1232, n76 = proto.readVarInt(p116, n76)
				elseif v1231 == proto.wireTypes.lengthDelimited then
					if v1230 == 1 then
						local v1233

						v1233, n76 = proto.readBuffer(p116, n76)
						v1228.message_key = prop_types.StringProp.decode(v1233)
					elseif v1230 == 2 then
						local v1234

						v1234, n76 = proto.readBuffer(p116, n76)
						v1228.toast_type = prop_types.StringProp.decode(v1234)
					else
						local v1235, v1236 = proto.readVarInt(p116, n76)

						n76 = v1236 + v1235
					end
				elseif v1231 == proto.wireTypes.i32 then
					local v1237

					v1237, n76 = proto.readFixed32(p116, n76)
				elseif v1231 == proto.wireTypes.i64 then
					local v1238

					v1238, n76 = proto.readFixed64(p116, n76)
				else
					error("Unsupported wire type: " .. v1231)
				end
			end

			return v1228
		end
		function t152.jsonEncode(p117) -- line: 10939
			local t154 = {}

			if p117.message_key ~= nil then
				t154.messageKey = p117.message_key:jsonEncode()
			end

			if p117.toast_type ~= nil then
				t154.toastType = p117.toast_type:jsonEncode()
			end

			return t154
		end
		function t152.jsonDecode(t155: {[any]: any}) -- line: 10953
			-- upvalues: t152 (copy), prop_types (copy)
			local v1242 = t152.new()

			if t155.message_key ~= nil then
				v1242.message_key = prop_types.StringProp.jsonDecode(t155.message_key)
			end

			if t155.messageKey ~= nil then
				v1242.message_key = prop_types.StringProp.jsonDecode(t155.messageKey)
			end

			if t155.toast_type ~= nil then
				v1242.toast_type = prop_types.StringProp.jsonDecode(t155.toast_type)
			end

			if t155.toastType ~= nil then
				v1242.toast_type = prop_types.StringProp.jsonDecode(t155.toastType)
			end

			return v1242
		end

		t152.descriptor = {
			name = "ShowToastAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.ShowToastAction_Params = t152
		typeRegistry.default:register(t1.ShowToastAction_Params)

		local t156 = {}

		t156.__index = t156

		function t156.new(t157: {[any]: any}?) -- line: 10990
			-- upvalues: t1 (copy), t156 (copy)
			return (setmetatable({
				action_type = if t157 ~= nil and t157.action_type ~= nil then t157.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t157 ~= nil and t157.action_params ~= nil then t157.action_params else nil
			}, t156))
		end
		function t156.encode(p118) -- line: 11001
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n77 = 0

			if p118.action_type ~= nil and (p118.action_type ~= nil and p118.action_type ~= 0 or p118.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1247, v1248 = proto.writeTag(buf, n77, 1, proto.wireTypes.varint)

				buf, n77 = proto.writeVarInt(v1247, v1248, t1.ActionType.toNumber(p118.action_type))
			end

			if p118.action_params ~= nil then
				local v1249 = p118.action_params:encode()
				local v1250, v1251 = proto.writeTag(buf, n77, 2, proto.wireTypes.lengthDelimited)

				buf, n77 = proto.writeBuffer(v1250, v1251, v1249, buffer.len(v1249))
			end

			local buf41 = buffer.create(n77)

			buffer.copy(buf41, 0, buf, 0, n77)

			return buf41
		end
		function t156.decode(p119: buffer) -- line: 11027
			-- upvalues: t156 (copy), proto (copy), t1 (copy)
			local v1254 = t156.new()
			local n78 = 0

			while n78 < buffer.len(p119) do
				local v1256, v1257

				v1256, v1257, n78 = proto.readTag(p119, n78)

				if v1257 == proto.wireTypes.varint then
					if v1256 == 1 then
						local v1258

						v1258, n78 = proto.readVarIntI32(p119, n78)
						v1254.action_type = t1.ActionType.fromNumber(v1258) or v1258
					else
						local v1259

						v1259, n78 = proto.readVarInt(p119, n78)
					end
				elseif v1257 == proto.wireTypes.lengthDelimited then
					if v1256 == 2 then
						local v1260

						v1260, n78 = proto.readBuffer(p119, n78)
						v1254.action_params = t1.OpenPhoneUpsellModalAction_Params.decode(v1260)
					else
						local v1261, v1262 = proto.readVarInt(p119, n78)

						n78 = v1262 + v1261
					end
				elseif v1257 == proto.wireTypes.i32 then
					local v1263

					v1263, n78 = proto.readFixed32(p119, n78)
				elseif v1257 == proto.wireTypes.i64 then
					local v1264

					v1264, n78 = proto.readFixed64(p119, n78)
				else
					error("Unsupported wire type: " .. v1257)
				end
			end

			return v1254
		end
		function t156.jsonEncode(p120) -- line: 11075
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
		function t156.jsonDecode(t159: {[any]: any}) -- line: 11097
			-- upvalues: t156 (copy), t1 (copy)
			local v1268 = t156.new()

			if t159.action_type ~= nil then
				v1268.action_type = if typeof(t159.action_type) ~= "number" then t1.ActionType.fromName(t159.action_type) or t159.action_type else t1.ActionType.fromNumber(t159.action_type) or t159.action_type
			end

			if t159.actionType ~= nil then
				v1268.action_type = if typeof(t159.actionType) ~= "number" then t1.ActionType.fromName(t159.actionType) or t159.actionType else t1.ActionType.fromNumber(t159.actionType) or t159.actionType
			end

			if t159.action_params ~= nil then
				v1268.action_params = t1.OpenPhoneUpsellModalAction_Params.jsonDecode(t159.action_params)
			end

			if t159.actionParams ~= nil then
				v1268.action_params = t1.OpenPhoneUpsellModalAction_Params.jsonDecode(t159.actionParams)
			end

			return v1268
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

		function t160.new(t161: {[any]: any}?) -- line: 11137
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
		function t160.encode(p121) -- line: 11157
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n79 = 0

			if p121.voice_opt_in ~= nil then
				local v1273 = p121.voice_opt_in:encode()
				local v1274, v1275 = proto.writeTag(buf, n79, 1, proto.wireTypes.lengthDelimited)

				buf, n79 = proto.writeBuffer(v1274, v1275, v1273, buffer.len(v1273))
			end

			if p121.event_context ~= nil then
				local v1276 = p121.event_context:encode()
				local v1277, v1278 = proto.writeTag(buf, n79, 2, proto.wireTypes.lengthDelimited)

				buf, n79 = proto.writeBuffer(v1277, v1278, v1276, buffer.len(v1276))
			end

			if p121.origin ~= nil then
				local v1279 = p121.origin:encode()
				local v1280, v1281 = proto.writeTag(buf, n79, 3, proto.wireTypes.lengthDelimited)

				buf, n79 = proto.writeBuffer(v1280, v1281, v1279, buffer.len(v1279))
			end

			if p121.should_autofill_android_phone_number_at_launch ~= nil then
				local v1282 = p121.should_autofill_android_phone_number_at_launch:encode()
				local v1283, v1284 = proto.writeTag(buf, n79, 4, proto.wireTypes.lengthDelimited)

				buf, n79 = proto.writeBuffer(v1283, v1284, v1282, buffer.len(v1282))
			end

			if p121.add_phone_description_key ~= nil then
				local v1285 = p121.add_phone_description_key:encode()
				local v1286, v1287 = proto.writeTag(buf, n79, 5, proto.wireTypes.lengthDelimited)

				buf, n79 = proto.writeBuffer(v1286, v1287, v1285, buffer.len(v1285))
			end

			if p121.on_success ~= nil then
				local v1288 = p121.on_success:encode()
				local v1289, v1290 = proto.writeTag(buf, n79, 6, proto.wireTypes.lengthDelimited)

				buf, n79 = proto.writeBuffer(v1289, v1290, v1288, buffer.len(v1288))
			end

			if p121.on_failure ~= nil then
				local v1291 = p121.on_failure:encode()
				local v1292, v1293 = proto.writeTag(buf, n79, 7, proto.wireTypes.lengthDelimited)

				buf, n79 = proto.writeBuffer(v1292, v1293, v1291, buffer.len(v1291))
			end

			if p121.on_cancelled ~= nil then
				local v1294 = p121.on_cancelled:encode()
				local v1295, v1296 = proto.writeTag(buf, n79, 8, proto.wireTypes.lengthDelimited)

				buf, n79 = proto.writeBuffer(v1295, v1296, v1294, buffer.len(v1294))
			end

			local buf42 = buffer.create(n79)

			buffer.copy(buf42, 0, buf, 0, n79)

			return buf42
		end
		function t160.decode(p122: buffer) -- line: 11214
			-- upvalues: t160 (copy), proto (copy), prop_types (copy), t1 (copy)
			local v1299 = t160.new()
			local n80 = 0

			while n80 < buffer.len(p122) do
				local v1301, v1302

				v1301, v1302, n80 = proto.readTag(p122, n80)

				if v1302 == proto.wireTypes.varint then
					local v1303

					v1303, n80 = proto.readVarInt(p122, n80)
				elseif v1302 == proto.wireTypes.lengthDelimited then
					if v1301 == 1 then
						local v1304

						v1304, n80 = proto.readBuffer(p122, n80)
						v1299.voice_opt_in = prop_types.BoolProp.decode(v1304)
					elseif v1301 == 2 then
						local v1305

						v1305, n80 = proto.readBuffer(p122, n80)
						v1299.event_context = prop_types.StringProp.decode(v1305)
					elseif v1301 == 3 then
						local v1306

						v1306, n80 = proto.readBuffer(p122, n80)
						v1299.origin = prop_types.StringProp.decode(v1306)
					elseif v1301 == 4 then
						local v1307

						v1307, n80 = proto.readBuffer(p122, n80)
						v1299.should_autofill_android_phone_number_at_launch = prop_types.BoolProp.decode(v1307)
					elseif v1301 == 5 then
						local v1308

						v1308, n80 = proto.readBuffer(p122, n80)
						v1299.add_phone_description_key = prop_types.StringProp.decode(v1308)
					elseif v1301 == 6 then
						local v1309

						v1309, n80 = proto.readBuffer(p122, n80)
						v1299.on_success = t1.ActionProp.decode(v1309)
					elseif v1301 == 7 then
						local v1310

						v1310, n80 = proto.readBuffer(p122, n80)
						v1299.on_failure = t1.ActionProp.decode(v1310)
					elseif v1301 == 8 then
						local v1311

						v1311, n80 = proto.readBuffer(p122, n80)
						v1299.on_cancelled = t1.ActionProp.decode(v1311)
					else
						local v1312, v1313 = proto.readVarInt(p122, n80)

						n80 = v1313 + v1312
					end
				elseif v1302 == proto.wireTypes.i32 then
					local v1314

					v1314, n80 = proto.readFixed32(p122, n80)
				elseif v1302 == proto.wireTypes.i64 then
					local v1315

					v1315, n80 = proto.readFixed64(p122, n80)
				else
					error("Unsupported wire type: " .. v1302)
				end
			end

			return v1299
		end
		function t160.jsonEncode(p123) -- line: 11294
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
		function t160.jsonDecode(t163: {[any]: any}) -- line: 11333
			-- upvalues: t160 (copy), prop_types (copy), t1 (copy)
			local v1319 = t160.new()

			if t163.voice_opt_in ~= nil then
				v1319.voice_opt_in = prop_types.BoolProp.jsonDecode(t163.voice_opt_in)
			end

			if t163.voiceOptIn ~= nil then
				v1319.voice_opt_in = prop_types.BoolProp.jsonDecode(t163.voiceOptIn)
			end

			if t163.event_context ~= nil then
				v1319.event_context = prop_types.StringProp.jsonDecode(t163.event_context)
			end

			if t163.eventContext ~= nil then
				v1319.event_context = prop_types.StringProp.jsonDecode(t163.eventContext)
			end

			if t163.origin ~= nil then
				v1319.origin = prop_types.StringProp.jsonDecode(t163.origin)
			end

			if t163.should_autofill_android_phone_number_at_launch ~= nil then
				v1319.should_autofill_android_phone_number_at_launch = prop_types.BoolProp.jsonDecode(t163.should_autofill_android_phone_number_at_launch)
			end

			if t163.shouldAutofillAndroidPhoneNumberAtLaunch ~= nil then
				v1319.should_autofill_android_phone_number_at_launch = prop_types.BoolProp.jsonDecode(t163.shouldAutofillAndroidPhoneNumberAtLaunch)
			end

			if t163.add_phone_description_key ~= nil then
				v1319.add_phone_description_key = prop_types.StringProp.jsonDecode(t163.add_phone_description_key)
			end

			if t163.addPhoneDescriptionKey ~= nil then
				v1319.add_phone_description_key = prop_types.StringProp.jsonDecode(t163.addPhoneDescriptionKey)
			end

			if t163.on_success ~= nil then
				v1319.on_success = t1.ActionProp.jsonDecode(t163.on_success)
			end

			if t163.onSuccess ~= nil then
				v1319.on_success = t1.ActionProp.jsonDecode(t163.onSuccess)
			end

			if t163.on_failure ~= nil then
				v1319.on_failure = t1.ActionProp.jsonDecode(t163.on_failure)
			end

			if t163.onFailure ~= nil then
				v1319.on_failure = t1.ActionProp.jsonDecode(t163.onFailure)
			end

			if t163.on_cancelled ~= nil then
				v1319.on_cancelled = t1.ActionProp.jsonDecode(t163.on_cancelled)
			end

			if t163.onCancelled ~= nil then
				v1319.on_cancelled = t1.ActionProp.jsonDecode(t163.onCancelled)
			end

			return v1319
		end

		t160.descriptor = {
			name = "OpenPhoneUpsellModalAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenPhoneUpsellModalAction_Params = t160
		typeRegistry.default:register(t1.OpenPhoneUpsellModalAction_Params)

		local t164 = {}

		t164.__index = t164

		function t164.new(t165: {[any]: any}?) -- line: 11426
			-- upvalues: t1 (copy), t164 (copy)
			return (setmetatable({
				action_type = if t165 ~= nil and t165.action_type ~= nil then t165.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t165 ~= nil and t165.action_params ~= nil then t165.action_params else nil
			}, t164))
		end
		function t164.encode(p124) -- line: 11437
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n81 = 0

			if p124.action_type ~= nil and (p124.action_type ~= nil and p124.action_type ~= 0 or p124.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1324, v1325 = proto.writeTag(buf, n81, 1, proto.wireTypes.varint)

				buf, n81 = proto.writeVarInt(v1324, v1325, t1.ActionType.toNumber(p124.action_type))
			end

			if p124.action_params ~= nil then
				local v1326 = p124.action_params:encode()
				local v1327, v1328 = proto.writeTag(buf, n81, 2, proto.wireTypes.lengthDelimited)

				buf, n81 = proto.writeBuffer(v1327, v1328, v1326, buffer.len(v1326))
			end

			local buf43 = buffer.create(n81)

			buffer.copy(buf43, 0, buf, 0, n81)

			return buf43
		end
		function t164.decode(p125: buffer) -- line: 11463
			-- upvalues: t164 (copy), proto (copy), t1 (copy)
			local v1331 = t164.new()
			local n82 = 0

			while n82 < buffer.len(p125) do
				local v1333, v1334

				v1333, v1334, n82 = proto.readTag(p125, n82)

				if v1334 == proto.wireTypes.varint then
					if v1333 == 1 then
						local v1335

						v1335, n82 = proto.readVarIntI32(p125, n82)
						v1331.action_type = t1.ActionType.fromNumber(v1335) or v1335
					else
						local v1336

						v1336, n82 = proto.readVarInt(p125, n82)
					end
				elseif v1334 == proto.wireTypes.lengthDelimited then
					if v1333 == 2 then
						local v1337

						v1337, n82 = proto.readBuffer(p125, n82)
						v1331.action_params = t1.OpenEmailUpsellModalAction_Params.decode(v1337)
					else
						local v1338, v1339 = proto.readVarInt(p125, n82)

						n82 = v1339 + v1338
					end
				elseif v1334 == proto.wireTypes.i32 then
					local v1340

					v1340, n82 = proto.readFixed32(p125, n82)
				elseif v1334 == proto.wireTypes.i64 then
					local v1341

					v1341, n82 = proto.readFixed64(p125, n82)
				else
					error("Unsupported wire type: " .. v1334)
				end
			end

			return v1331
		end
		function t164.jsonEncode(p126) -- line: 11511
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
		function t164.jsonDecode(t167: {[any]: any}) -- line: 11533
			-- upvalues: t164 (copy), t1 (copy)
			local v1345 = t164.new()

			if t167.action_type ~= nil then
				v1345.action_type = if typeof(t167.action_type) ~= "number" then t1.ActionType.fromName(t167.action_type) or t167.action_type else t1.ActionType.fromNumber(t167.action_type) or t167.action_type
			end

			if t167.actionType ~= nil then
				v1345.action_type = if typeof(t167.actionType) ~= "number" then t1.ActionType.fromName(t167.actionType) or t167.actionType else t1.ActionType.fromNumber(t167.actionType) or t167.actionType
			end

			if t167.action_params ~= nil then
				v1345.action_params = t1.OpenEmailUpsellModalAction_Params.jsonDecode(t167.action_params)
			end

			if t167.actionParams ~= nil then
				v1345.action_params = t1.OpenEmailUpsellModalAction_Params.jsonDecode(t167.actionParams)
			end

			return v1345
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

		function t168.new(t169: {[any]: any}?) -- line: 11573
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
		function t168.encode(p127) -- line: 11595
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n83 = 0

			if p127.add_email_over13_text_key ~= nil then
				local v1350 = p127.add_email_over13_text_key:encode()
				local v1351, v1352 = proto.writeTag(buf, n83, 1, proto.wireTypes.lengthDelimited)

				buf, n83 = proto.writeBuffer(v1351, v1352, v1350, buffer.len(v1350))
			end

			if p127.add_email_title_key ~= nil then
				local v1353 = p127.add_email_title_key:encode()
				local v1354, v1355 = proto.writeTag(buf, n83, 2, proto.wireTypes.lengthDelimited)

				buf, n83 = proto.writeBuffer(v1354, v1355, v1353, buffer.len(v1353))
			end

			if p127.is_email_modal_called_from_home_page ~= nil then
				local v1356 = p127.is_email_modal_called_from_home_page:encode()
				local v1357, v1358 = proto.writeTag(buf, n83, 3, proto.wireTypes.lengthDelimited)

				buf, n83 = proto.writeBuffer(v1357, v1358, v1356, buffer.len(v1356))
			end

			if p127.event_context ~= nil then
				local v1359 = p127.event_context:encode()
				local v1360, v1361 = proto.writeTag(buf, n83, 4, proto.wireTypes.lengthDelimited)

				buf, n83 = proto.writeBuffer(v1360, v1361, v1359, buffer.len(v1359))
			end

			if p127.origin ~= nil then
				local v1362 = p127.origin:encode()
				local v1363, v1364 = proto.writeTag(buf, n83, 5, proto.wireTypes.lengthDelimited)

				buf, n83 = proto.writeBuffer(v1363, v1364, v1362, buffer.len(v1362))
			end

			if p127.section ~= nil then
				local v1365 = p127.section:encode()
				local v1366, v1367 = proto.writeTag(buf, n83, 6, proto.wireTypes.lengthDelimited)

				buf, n83 = proto.writeBuffer(v1366, v1367, v1365, buffer.len(v1365))
			end

			if p127.on_success ~= nil then
				local v1368 = p127.on_success:encode()
				local v1369, v1370 = proto.writeTag(buf, n83, 7, proto.wireTypes.lengthDelimited)

				buf, n83 = proto.writeBuffer(v1369, v1370, v1368, buffer.len(v1368))
			end

			if p127.on_failure ~= nil then
				local v1371 = p127.on_failure:encode()
				local v1372, v1373 = proto.writeTag(buf, n83, 8, proto.wireTypes.lengthDelimited)

				buf, n83 = proto.writeBuffer(v1372, v1373, v1371, buffer.len(v1371))
			end

			local buf44 = buffer.create(n83)

			buffer.copy(buf44, 0, buf, 0, n83)

			return buf44
		end
		function t168.decode(p128: buffer) -- line: 11652
			-- upvalues: t168 (copy), proto (copy), prop_types (copy), t1 (copy)
			local v1376 = t168.new()
			local n84 = 0

			while n84 < buffer.len(p128) do
				local v1378, v1379

				v1378, v1379, n84 = proto.readTag(p128, n84)

				if v1379 == proto.wireTypes.varint then
					local v1380

					v1380, n84 = proto.readVarInt(p128, n84)
				elseif v1379 == proto.wireTypes.lengthDelimited then
					if v1378 == 1 then
						local v1381

						v1381, n84 = proto.readBuffer(p128, n84)
						v1376.add_email_over13_text_key = prop_types.StringProp.decode(v1381)
					elseif v1378 == 2 then
						local v1382

						v1382, n84 = proto.readBuffer(p128, n84)
						v1376.add_email_title_key = prop_types.StringProp.decode(v1382)
					elseif v1378 == 3 then
						local v1383

						v1383, n84 = proto.readBuffer(p128, n84)
						v1376.is_email_modal_called_from_home_page = prop_types.BoolProp.decode(v1383)
					elseif v1378 == 4 then
						local v1384

						v1384, n84 = proto.readBuffer(p128, n84)
						v1376.event_context = prop_types.StringProp.decode(v1384)
					elseif v1378 == 5 then
						local v1385

						v1385, n84 = proto.readBuffer(p128, n84)
						v1376.origin = prop_types.StringProp.decode(v1385)
					elseif v1378 == 6 then
						local v1386

						v1386, n84 = proto.readBuffer(p128, n84)
						v1376.section = prop_types.StringProp.decode(v1386)
					elseif v1378 == 7 then
						local v1387

						v1387, n84 = proto.readBuffer(p128, n84)
						v1376.on_success = t1.ActionProp.decode(v1387)
					elseif v1378 == 8 then
						local v1388

						v1388, n84 = proto.readBuffer(p128, n84)
						v1376.on_failure = t1.ActionProp.decode(v1388)
					else
						local v1389, v1390 = proto.readVarInt(p128, n84)

						n84 = v1390 + v1389
					end
				elseif v1379 == proto.wireTypes.i32 then
					local v1391

					v1391, n84 = proto.readFixed32(p128, n84)
				elseif v1379 == proto.wireTypes.i64 then
					local v1392

					v1392, n84 = proto.readFixed64(p128, n84)
				else
					error("Unsupported wire type: " .. v1379)
				end
			end

			return v1376
		end
		function t168.jsonEncode(p129) -- line: 11733
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
		function t168.jsonDecode(t171: {[any]: any}) -- line: 11771
			-- upvalues: t168 (copy), prop_types (copy), t1 (copy)
			local v1396 = t168.new()

			if t171.add_email_over13_text_key ~= nil then
				v1396.add_email_over13_text_key = prop_types.StringProp.jsonDecode(t171.add_email_over13_text_key)
			end

			if t171.addEmailOver13TextKey ~= nil then
				v1396.add_email_over13_text_key = prop_types.StringProp.jsonDecode(t171.addEmailOver13TextKey)
			end

			if t171.add_email_title_key ~= nil then
				v1396.add_email_title_key = prop_types.StringProp.jsonDecode(t171.add_email_title_key)
			end

			if t171.addEmailTitleKey ~= nil then
				v1396.add_email_title_key = prop_types.StringProp.jsonDecode(t171.addEmailTitleKey)
			end

			if t171.is_email_modal_called_from_home_page ~= nil then
				v1396.is_email_modal_called_from_home_page = prop_types.BoolProp.jsonDecode(t171.is_email_modal_called_from_home_page)
			end

			if t171.isEmailModalCalledFromHomePage ~= nil then
				v1396.is_email_modal_called_from_home_page = prop_types.BoolProp.jsonDecode(t171.isEmailModalCalledFromHomePage)
			end

			if t171.event_context ~= nil then
				v1396.event_context = prop_types.StringProp.jsonDecode(t171.event_context)
			end

			if t171.eventContext ~= nil then
				v1396.event_context = prop_types.StringProp.jsonDecode(t171.eventContext)
			end

			if t171.origin ~= nil then
				v1396.origin = prop_types.StringProp.jsonDecode(t171.origin)
			end

			if t171.section ~= nil then
				v1396.section = prop_types.StringProp.jsonDecode(t171.section)
			end

			if t171.on_success ~= nil then
				v1396.on_success = t1.ActionProp.jsonDecode(t171.on_success)
			end

			if t171.onSuccess ~= nil then
				v1396.on_success = t1.ActionProp.jsonDecode(t171.onSuccess)
			end

			if t171.on_failure ~= nil then
				v1396.on_failure = t1.ActionProp.jsonDecode(t171.on_failure)
			end

			if t171.onFailure ~= nil then
				v1396.on_failure = t1.ActionProp.jsonDecode(t171.onFailure)
			end

			return v1396
		end

		t168.descriptor = {
			name = "OpenEmailUpsellModalAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenEmailUpsellModalAction_Params = t168
		typeRegistry.default:register(t1.OpenEmailUpsellModalAction_Params)

		local t172 = {}

		t172.__index = t172

		function t172.new(t173: {[any]: any}?) -- line: 11861
			-- upvalues: t1 (copy), t172 (copy)
			return (setmetatable({
				action_type = if t173 ~= nil and t173.action_type ~= nil then t173.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t173 ~= nil and t173.action_params ~= nil then t173.action_params else nil
			}, t172))
		end
		function t172.encode(p130) -- line: 11872
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n85 = 0

			if p130.action_type ~= nil and (p130.action_type ~= nil and p130.action_type ~= 0 or p130.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1401, v1402 = proto.writeTag(buf, n85, 1, proto.wireTypes.varint)

				buf, n85 = proto.writeVarInt(v1401, v1402, t1.ActionType.toNumber(p130.action_type))
			end

			if p130.action_params ~= nil then
				local v1403 = p130.action_params:encode()
				local v1404, v1405 = proto.writeTag(buf, n85, 2, proto.wireTypes.lengthDelimited)

				buf, n85 = proto.writeBuffer(v1404, v1405, v1403, buffer.len(v1403))
			end

			local buf45 = buffer.create(n85)

			buffer.copy(buf45, 0, buf, 0, n85)

			return buf45
		end
		function t172.decode(p131: buffer) -- line: 11898
			-- upvalues: t172 (copy), proto (copy), t1 (copy)
			local v1408 = t172.new()
			local n86 = 0

			while n86 < buffer.len(p131) do
				local v1410, v1411

				v1410, v1411, n86 = proto.readTag(p131, n86)

				if v1411 == proto.wireTypes.varint then
					if v1410 == 1 then
						local v1412

						v1412, n86 = proto.readVarIntI32(p131, n86)
						v1408.action_type = t1.ActionType.fromNumber(v1412) or v1412
					else
						local v1413

						v1413, n86 = proto.readVarInt(p131, n86)
					end
				elseif v1411 == proto.wireTypes.lengthDelimited then
					if v1410 == 2 then
						local v1414

						v1414, n86 = proto.readBuffer(p131, n86)
						v1408.action_params = t1.OpenAddConnectionsPageAction_Params.decode(v1414)
					else
						local v1415, v1416 = proto.readVarInt(p131, n86)

						n86 = v1416 + v1415
					end
				elseif v1411 == proto.wireTypes.i32 then
					local v1417

					v1417, n86 = proto.readFixed32(p131, n86)
				elseif v1411 == proto.wireTypes.i64 then
					local v1418

					v1418, n86 = proto.readFixed64(p131, n86)
				else
					error("Unsupported wire type: " .. v1411)
				end
			end

			return v1408
		end
		function t172.jsonEncode(p132) -- line: 11946
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
		function t172.jsonDecode(t175: {[any]: any}) -- line: 11968
			-- upvalues: t172 (copy), t1 (copy)
			local v1422 = t172.new()

			if t175.action_type ~= nil then
				v1422.action_type = if typeof(t175.action_type) ~= "number" then t1.ActionType.fromName(t175.action_type) or t175.action_type else t1.ActionType.fromNumber(t175.action_type) or t175.action_type
			end

			if t175.actionType ~= nil then
				v1422.action_type = if typeof(t175.actionType) ~= "number" then t1.ActionType.fromName(t175.actionType) or t175.actionType else t1.ActionType.fromNumber(t175.actionType) or t175.actionType
			end

			if t175.action_params ~= nil then
				v1422.action_params = t1.OpenAddConnectionsPageAction_Params.jsonDecode(t175.action_params)
			end

			if t175.actionParams ~= nil then
				v1422.action_params = t1.OpenAddConnectionsPageAction_Params.jsonDecode(t175.actionParams)
			end

			return v1422
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

		function t176.new(t177: {[any]: any}?) -- line: 12008
			-- upvalues: t176 (copy)
			return (setmetatable({
				user_id = if t177 ~= nil and t177.user_id ~= nil then t177.user_id else nil,
				source = if t177 ~= nil and t177.source ~= nil then t177.source else nil
			}, t176))
		end
		function t176.encode(p133) -- line: 12017
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n87 = 0

			if p133.user_id ~= nil then
				local v1427 = p133.user_id:encode()
				local v1428, v1429 = proto.writeTag(buf, n87, 1, proto.wireTypes.lengthDelimited)

				buf, n87 = proto.writeBuffer(v1428, v1429, v1427, buffer.len(v1427))
			end

			if p133.source ~= nil then
				local v1430 = p133.source:encode()
				local v1431, v1432 = proto.writeTag(buf, n87, 2, proto.wireTypes.lengthDelimited)

				buf, n87 = proto.writeBuffer(v1431, v1432, v1430, buffer.len(v1430))
			end

			local buf46 = buffer.create(n87)

			buffer.copy(buf46, 0, buf, 0, n87)

			return buf46
		end
		function t176.decode(p134: buffer) -- line: 12038
			-- upvalues: t176 (copy), proto (copy), prop_types (copy)
			local v1435 = t176.new()
			local n88 = 0

			while n88 < buffer.len(p134) do
				local v1437, v1438

				v1437, v1438, n88 = proto.readTag(p134, n88)

				if v1438 == proto.wireTypes.varint then
					local v1439

					v1439, n88 = proto.readVarInt(p134, n88)
				elseif v1438 == proto.wireTypes.lengthDelimited then
					if v1437 == 1 then
						local v1440

						v1440, n88 = proto.readBuffer(p134, n88)
						v1435.user_id = prop_types.StringProp.decode(v1440)
					elseif v1437 == 2 then
						local v1441

						v1441, n88 = proto.readBuffer(p134, n88)
						v1435.source = prop_types.StringProp.decode(v1441)
					else
						local v1442, v1443 = proto.readVarInt(p134, n88)

						n88 = v1443 + v1442
					end
				elseif v1438 == proto.wireTypes.i32 then
					local v1444

					v1444, n88 = proto.readFixed32(p134, n88)
				elseif v1438 == proto.wireTypes.i64 then
					local v1445

					v1445, n88 = proto.readFixed64(p134, n88)
				else
					error("Unsupported wire type: " .. v1438)
				end
			end

			return v1435
		end
		function t176.jsonEncode(p135) -- line: 12086
			local t178 = {}

			if p135.user_id ~= nil then
				t178.userId = p135.user_id:jsonEncode()
			end

			if p135.source ~= nil then
				t178.source = p135.source:jsonEncode()
			end

			return t178
		end
		function t176.jsonDecode(t179: {[any]: any}) -- line: 12100
			-- upvalues: t176 (copy), prop_types (copy)
			local v1449 = t176.new()

			if t179.user_id ~= nil then
				v1449.user_id = prop_types.StringProp.jsonDecode(t179.user_id)
			end

			if t179.userId ~= nil then
				v1449.user_id = prop_types.StringProp.jsonDecode(t179.userId)
			end

			if t179.source ~= nil then
				v1449.source = prop_types.StringProp.jsonDecode(t179.source)
			end

			return v1449
		end

		t176.descriptor = {
			name = "OpenAddConnectionsPageAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenAddConnectionsPageAction_Params = t176
		typeRegistry.default:register(t1.OpenAddConnectionsPageAction_Params)

		local t180 = {}

		t180.__index = t180

		function t180.new(t181: {[any]: any}?) -- line: 12134
			-- upvalues: t1 (copy), t180 (copy)
			return (setmetatable({
				action_type = if t181 ~= nil and t181.action_type ~= nil then t181.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t181 ~= nil and t181.action_params ~= nil then t181.action_params else nil
			}, t180))
		end
		function t180.encode(p136) -- line: 12143
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n89 = 0

			if p136.action_type ~= nil and (p136.action_type ~= nil and p136.action_type ~= 0 or p136.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1454, v1455 = proto.writeTag(buf, n89, 1, proto.wireTypes.varint)

				buf, n89 = proto.writeVarInt(v1454, v1455, t1.ActionType.toNumber(p136.action_type))
			end

			if p136.action_params ~= nil then
				local v1456 = p136.action_params:encode()
				local v1457, v1458 = proto.writeTag(buf, n89, 2, proto.wireTypes.lengthDelimited)

				buf, n89 = proto.writeBuffer(v1457, v1458, v1456, buffer.len(v1456))
			end

			local buf47 = buffer.create(n89)

			buffer.copy(buf47, 0, buf, 0, n89)

			return buf47
		end
		function t180.decode(p137: buffer) -- line: 12169
			-- upvalues: t180 (copy), proto (copy), t1 (copy)
			local v1461 = t180.new()
			local n90 = 0

			while n90 < buffer.len(p137) do
				local v1463, v1464

				v1463, v1464, n90 = proto.readTag(p137, n90)

				if v1464 == proto.wireTypes.varint then
					if v1463 == 1 then
						local v1465

						v1465, n90 = proto.readVarIntI32(p137, n90)
						v1461.action_type = t1.ActionType.fromNumber(v1465) or v1465
					else
						local v1466

						v1466, n90 = proto.readVarInt(p137, n90)
					end
				elseif v1464 == proto.wireTypes.lengthDelimited then
					if v1463 == 2 then
						local v1467

						v1467, n90 = proto.readBuffer(p137, n90)
						v1461.action_params = t1.OpenMarketplaceAction_Params.decode(v1467)
					else
						local v1468, v1469 = proto.readVarInt(p137, n90)

						n90 = v1469 + v1468
					end
				elseif v1464 == proto.wireTypes.i32 then
					local v1470

					v1470, n90 = proto.readFixed32(p137, n90)
				elseif v1464 == proto.wireTypes.i64 then
					local v1471

					v1471, n90 = proto.readFixed64(p137, n90)
				else
					error("Unsupported wire type: " .. v1464)
				end
			end

			return v1461
		end
		function t180.jsonEncode(p138) -- line: 12217
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
		function t180.jsonDecode(t183: {[any]: any}) -- line: 12239
			-- upvalues: t180 (copy), t1 (copy)
			local v1475 = t180.new()

			if t183.action_type ~= nil then
				v1475.action_type = if typeof(t183.action_type) ~= "number" then t1.ActionType.fromName(t183.action_type) or t183.action_type else t1.ActionType.fromNumber(t183.action_type) or t183.action_type
			end

			if t183.actionType ~= nil then
				v1475.action_type = if typeof(t183.actionType) ~= "number" then t1.ActionType.fromName(t183.actionType) or t183.actionType else t1.ActionType.fromNumber(t183.actionType) or t183.actionType
			end

			if t183.action_params ~= nil then
				v1475.action_params = t1.OpenMarketplaceAction_Params.jsonDecode(t183.action_params)
			end

			if t183.actionParams ~= nil then
				v1475.action_params = t1.OpenMarketplaceAction_Params.jsonDecode(t183.actionParams)
			end

			return v1475
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

		function t184.new(t185: {[any]: any}?) -- line: 12279
			-- upvalues: t184 (copy)
			return (setmetatable({
				user_id = if t185 ~= nil and t185.user_id ~= nil then t185.user_id else nil,
				source = if t185 ~= nil and t185.source ~= nil then t185.source else nil
			}, t184))
		end
		function t184.encode(p139) -- line: 12288
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n91 = 0

			if p139.user_id ~= nil then
				local v1480 = p139.user_id:encode()
				local v1481, v1482 = proto.writeTag(buf, n91, 1, proto.wireTypes.lengthDelimited)

				buf, n91 = proto.writeBuffer(v1481, v1482, v1480, buffer.len(v1480))
			end

			if p139.source ~= nil then
				local v1483 = p139.source:encode()
				local v1484, v1485 = proto.writeTag(buf, n91, 2, proto.wireTypes.lengthDelimited)

				buf, n91 = proto.writeBuffer(v1484, v1485, v1483, buffer.len(v1483))
			end

			local buf48 = buffer.create(n91)

			buffer.copy(buf48, 0, buf, 0, n91)

			return buf48
		end
		function t184.decode(p140: buffer) -- line: 12309
			-- upvalues: t184 (copy), proto (copy), prop_types (copy)
			local v1488 = t184.new()
			local n92 = 0

			while n92 < buffer.len(p140) do
				local v1490, v1491

				v1490, v1491, n92 = proto.readTag(p140, n92)

				if v1491 == proto.wireTypes.varint then
					local v1492

					v1492, n92 = proto.readVarInt(p140, n92)
				elseif v1491 == proto.wireTypes.lengthDelimited then
					if v1490 == 1 then
						local v1493

						v1493, n92 = proto.readBuffer(p140, n92)
						v1488.user_id = prop_types.StringProp.decode(v1493)
					elseif v1490 == 2 then
						local v1494

						v1494, n92 = proto.readBuffer(p140, n92)
						v1488.source = prop_types.StringProp.decode(v1494)
					else
						local v1495, v1496 = proto.readVarInt(p140, n92)

						n92 = v1496 + v1495
					end
				elseif v1491 == proto.wireTypes.i32 then
					local v1497

					v1497, n92 = proto.readFixed32(p140, n92)
				elseif v1491 == proto.wireTypes.i64 then
					local v1498

					v1498, n92 = proto.readFixed64(p140, n92)
				else
					error("Unsupported wire type: " .. v1491)
				end
			end

			return v1488
		end
		function t184.jsonEncode(p141) -- line: 12357
			local t186 = {}

			if p141.user_id ~= nil then
				t186.userId = p141.user_id:jsonEncode()
			end

			if p141.source ~= nil then
				t186.source = p141.source:jsonEncode()
			end

			return t186
		end
		function t184.jsonDecode(t187: {[any]: any}) -- line: 12371
			-- upvalues: t184 (copy), prop_types (copy)
			local v1502 = t184.new()

			if t187.user_id ~= nil then
				v1502.user_id = prop_types.StringProp.jsonDecode(t187.user_id)
			end

			if t187.userId ~= nil then
				v1502.user_id = prop_types.StringProp.jsonDecode(t187.userId)
			end

			if t187.source ~= nil then
				v1502.source = prop_types.StringProp.jsonDecode(t187.source)
			end

			return v1502
		end

		t184.descriptor = {
			name = "OpenMarketplaceAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenMarketplaceAction_Params = t184
		typeRegistry.default:register(t1.OpenMarketplaceAction_Params)

		local t188 = {}

		t188.__index = t188

		function t188.new(t189: {[any]: any}?) -- line: 12403
			-- upvalues: t1 (copy), t188 (copy)
			return (setmetatable({
				action_type = if t189 ~= nil and t189.action_type ~= nil then t189.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t189 ~= nil and t189.action_params ~= nil then t189.action_params else nil
			}, t188))
		end
		function t188.encode(p142) -- line: 12414
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n93 = 0

			if p142.action_type ~= nil and (p142.action_type ~= nil and p142.action_type ~= 0 or p142.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1507, v1508 = proto.writeTag(buf, n93, 1, proto.wireTypes.varint)

				buf, n93 = proto.writeVarInt(v1507, v1508, t1.ActionType.toNumber(p142.action_type))
			end

			if p142.action_params ~= nil then
				local v1509 = p142.action_params:encode()
				local v1510, v1511 = proto.writeTag(buf, n93, 2, proto.wireTypes.lengthDelimited)

				buf, n93 = proto.writeBuffer(v1510, v1511, v1509, buffer.len(v1509))
			end

			local buf49 = buffer.create(n93)

			buffer.copy(buf49, 0, buf, 0, n93)

			return buf49
		end
		function t188.decode(p143: buffer) -- line: 12440
			-- upvalues: t188 (copy), proto (copy), t1 (copy)
			local v1514 = t188.new()
			local n94 = 0

			while n94 < buffer.len(p143) do
				local v1516, v1517

				v1516, v1517, n94 = proto.readTag(p143, n94)

				if v1517 == proto.wireTypes.varint then
					if v1516 == 1 then
						local v1518

						v1518, n94 = proto.readVarIntI32(p143, n94)
						v1514.action_type = t1.ActionType.fromNumber(v1518) or v1518
					else
						local v1519

						v1519, n94 = proto.readVarInt(p143, n94)
					end
				elseif v1517 == proto.wireTypes.lengthDelimited then
					if v1516 == 2 then
						local v1520

						v1520, n94 = proto.readBuffer(p143, n94)
						v1514.action_params = t1.HideProfileCompletionAction_Params.decode(v1520)
					else
						local v1521, v1522 = proto.readVarInt(p143, n94)

						n94 = v1522 + v1521
					end
				elseif v1517 == proto.wireTypes.i32 then
					local v1523

					v1523, n94 = proto.readFixed32(p143, n94)
				elseif v1517 == proto.wireTypes.i64 then
					local v1524

					v1524, n94 = proto.readFixed64(p143, n94)
				else
					error("Unsupported wire type: " .. v1517)
				end
			end

			return v1514
		end
		function t188.jsonEncode(p144) -- line: 12488
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
		function t188.jsonDecode(t191: {[any]: any}) -- line: 12510
			-- upvalues: t188 (copy), t1 (copy)
			local v1528 = t188.new()

			if t191.action_type ~= nil then
				v1528.action_type = if typeof(t191.action_type) ~= "number" then t1.ActionType.fromName(t191.action_type) or t191.action_type else t1.ActionType.fromNumber(t191.action_type) or t191.action_type
			end

			if t191.actionType ~= nil then
				v1528.action_type = if typeof(t191.actionType) ~= "number" then t1.ActionType.fromName(t191.actionType) or t191.actionType else t1.ActionType.fromNumber(t191.actionType) or t191.actionType
			end

			if t191.action_params ~= nil then
				v1528.action_params = t1.HideProfileCompletionAction_Params.jsonDecode(t191.action_params)
			end

			if t191.actionParams ~= nil then
				v1528.action_params = t1.HideProfileCompletionAction_Params.jsonDecode(t191.actionParams)
			end

			return v1528
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

		function t192.new(t193: {[any]: any}?) -- line: 12550
			-- upvalues: t192 (copy)
			return (setmetatable({
				user_id = if t193 ~= nil and t193.user_id ~= nil then t193.user_id else nil,
				prompt_id = if t193 ~= nil and t193.prompt_id ~= nil then t193.prompt_id else nil,
				source = if t193 ~= nil and t193.source ~= nil then t193.source else nil,
				prompt_type = if t193 ~= nil and t193.prompt_type ~= nil then t193.prompt_type else nil
			}, t192))
		end
		function t192.encode(p145) -- line: 12561
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n95 = 0

			if p145.user_id ~= nil then
				local v1533 = p145.user_id:encode()
				local v1534, v1535 = proto.writeTag(buf, n95, 1, proto.wireTypes.lengthDelimited)

				buf, n95 = proto.writeBuffer(v1534, v1535, v1533, buffer.len(v1533))
			end

			if p145.prompt_id ~= nil then
				local v1536 = p145.prompt_id:encode()
				local v1537, v1538 = proto.writeTag(buf, n95, 2, proto.wireTypes.lengthDelimited)

				buf, n95 = proto.writeBuffer(v1537, v1538, v1536, buffer.len(v1536))
			end

			if p145.source ~= nil then
				local v1539 = p145.source:encode()
				local v1540, v1541 = proto.writeTag(buf, n95, 3, proto.wireTypes.lengthDelimited)

				buf, n95 = proto.writeBuffer(v1540, v1541, v1539, buffer.len(v1539))
			end

			if p145.prompt_type ~= nil then
				local v1542 = p145.prompt_type:encode()
				local v1543, v1544 = proto.writeTag(buf, n95, 4, proto.wireTypes.lengthDelimited)

				buf, n95 = proto.writeBuffer(v1543, v1544, v1542, buffer.len(v1542))
			end

			local buf50 = buffer.create(n95)

			buffer.copy(buf50, 0, buf, 0, n95)

			return buf50
		end
		function t192.decode(p146: buffer) -- line: 12594
			-- upvalues: t192 (copy), proto (copy), prop_types (copy)
			local v1547 = t192.new()
			local n96 = 0

			while n96 < buffer.len(p146) do
				local v1549, v1550

				v1549, v1550, n96 = proto.readTag(p146, n96)

				if v1550 == proto.wireTypes.varint then
					local v1551

					v1551, n96 = proto.readVarInt(p146, n96)
				elseif v1550 == proto.wireTypes.lengthDelimited then
					if v1549 == 1 then
						local v1552

						v1552, n96 = proto.readBuffer(p146, n96)
						v1547.user_id = prop_types.StringProp.decode(v1552)
					elseif v1549 == 2 then
						local v1553

						v1553, n96 = proto.readBuffer(p146, n96)
						v1547.prompt_id = prop_types.StringProp.decode(v1553)
					elseif v1549 == 3 then
						local v1554

						v1554, n96 = proto.readBuffer(p146, n96)
						v1547.source = prop_types.StringProp.decode(v1554)
					elseif v1549 == 4 then
						local v1555

						v1555, n96 = proto.readBuffer(p146, n96)
						v1547.prompt_type = prop_types.StringProp.decode(v1555)
					else
						local v1556, v1557 = proto.readVarInt(p146, n96)

						n96 = v1557 + v1556
					end
				elseif v1550 == proto.wireTypes.i32 then
					local v1558

					v1558, n96 = proto.readFixed32(p146, n96)
				elseif v1550 == proto.wireTypes.i64 then
					local v1559

					v1559, n96 = proto.readFixed64(p146, n96)
				else
					error("Unsupported wire type: " .. v1550)
				end
			end

			return v1547
		end
		function t192.jsonEncode(p147) -- line: 12652
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
		function t192.jsonDecode(t195: {[any]: any}) -- line: 12674
			-- upvalues: t192 (copy), prop_types (copy)
			local v1563 = t192.new()

			if t195.user_id ~= nil then
				v1563.user_id = prop_types.StringProp.jsonDecode(t195.user_id)
			end

			if t195.userId ~= nil then
				v1563.user_id = prop_types.StringProp.jsonDecode(t195.userId)
			end

			if t195.prompt_id ~= nil then
				v1563.prompt_id = prop_types.StringProp.jsonDecode(t195.prompt_id)
			end

			if t195.promptId ~= nil then
				v1563.prompt_id = prop_types.StringProp.jsonDecode(t195.promptId)
			end

			if t195.source ~= nil then
				v1563.source = prop_types.StringProp.jsonDecode(t195.source)
			end

			if t195.prompt_type ~= nil then
				v1563.prompt_type = prop_types.StringProp.jsonDecode(t195.prompt_type)
			end

			if t195.promptType ~= nil then
				v1563.prompt_type = prop_types.StringProp.jsonDecode(t195.promptType)
			end

			return v1563
		end

		t192.descriptor = {
			name = "HideProfileCompletionAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.HideProfileCompletionAction_Params = t192
		typeRegistry.default:register(t1.HideProfileCompletionAction_Params)

		local t196 = {}

		t196.__index = t196

		function t196.new(t197: {[any]: any}?) -- line: 12725
			-- upvalues: t1 (copy), t196 (copy)
			return (setmetatable({
				action_type = if t197 ~= nil and t197.action_type ~= nil then t197.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t197 ~= nil and t197.action_params ~= nil then t197.action_params else nil
			}, t196))
		end
		function t196.encode(p148) -- line: 12736
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n97 = 0

			if p148.action_type ~= nil and (p148.action_type ~= nil and p148.action_type ~= 0 or p148.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1568, v1569 = proto.writeTag(buf, n97, 1, proto.wireTypes.varint)

				buf, n97 = proto.writeVarInt(v1568, v1569, t1.ActionType.toNumber(p148.action_type))
			end

			if p148.action_params ~= nil then
				local v1570 = p148.action_params:encode()
				local v1571, v1572 = proto.writeTag(buf, n97, 2, proto.wireTypes.lengthDelimited)

				buf, n97 = proto.writeBuffer(v1571, v1572, v1570, buffer.len(v1570))
			end

			local buf51 = buffer.create(n97)

			buffer.copy(buf51, 0, buf, 0, n97)

			return buf51
		end
		function t196.decode(p149: buffer) -- line: 12762
			-- upvalues: t196 (copy), proto (copy), t1 (copy)
			local v1575 = t196.new()
			local n98 = 0

			while n98 < buffer.len(p149) do
				local v1577, v1578

				v1577, v1578, n98 = proto.readTag(p149, n98)

				if v1578 == proto.wireTypes.varint then
					if v1577 == 1 then
						local v1579

						v1579, n98 = proto.readVarIntI32(p149, n98)
						v1575.action_type = t1.ActionType.fromNumber(v1579) or v1579
					else
						local v1580

						v1580, n98 = proto.readVarInt(p149, n98)
					end
				elseif v1578 == proto.wireTypes.lengthDelimited then
					if v1577 == 2 then
						local v1581

						v1581, n98 = proto.readBuffer(p149, n98)
						v1575.action_params = t1.SelectMarketplaceCatalogCategory_Params.decode(v1581)
					else
						local v1582, v1583 = proto.readVarInt(p149, n98)

						n98 = v1583 + v1582
					end
				elseif v1578 == proto.wireTypes.i32 then
					local v1584

					v1584, n98 = proto.readFixed32(p149, n98)
				elseif v1578 == proto.wireTypes.i64 then
					local v1585

					v1585, n98 = proto.readFixed64(p149, n98)
				else
					error("Unsupported wire type: " .. v1578)
				end
			end

			return v1575
		end
		function t196.jsonEncode(p150) -- line: 12810
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
		function t196.jsonDecode(t199: {[any]: any}) -- line: 12832
			-- upvalues: t196 (copy), t1 (copy)
			local v1589 = t196.new()

			if t199.action_type ~= nil then
				v1589.action_type = if typeof(t199.action_type) ~= "number" then t1.ActionType.fromName(t199.action_type) or t199.action_type else t1.ActionType.fromNumber(t199.action_type) or t199.action_type
			end

			if t199.actionType ~= nil then
				v1589.action_type = if typeof(t199.actionType) ~= "number" then t1.ActionType.fromName(t199.actionType) or t199.actionType else t1.ActionType.fromNumber(t199.actionType) or t199.actionType
			end

			if t199.action_params ~= nil then
				v1589.action_params = t1.SelectMarketplaceCatalogCategory_Params.jsonDecode(t199.action_params)
			end

			if t199.actionParams ~= nil then
				v1589.action_params = t1.SelectMarketplaceCatalogCategory_Params.jsonDecode(t199.actionParams)
			end

			return v1589
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

		function t200.new(t201: {[any]: any}?) -- line: 12874
			-- upvalues: t200 (copy)
			return (setmetatable({
				category_id = if t201 ~= nil and t201.category_id ~= nil then t201.category_id else nil
			}, t200))
		end
		function t200.encode(p151) -- line: 12882
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n99 = 0

			if p151.category_id ~= nil then
				local v1594 = p151.category_id:encode()
				local v1595, v1596 = proto.writeTag(buf, n99, 1, proto.wireTypes.lengthDelimited)

				buf, n99 = proto.writeBuffer(v1595, v1596, v1594, buffer.len(v1594))
			end

			local buf52 = buffer.create(n99)

			buffer.copy(buf52, 0, buf, 0, n99)

			return buf52
		end
		function t200.decode(p152: buffer) -- line: 12897
			-- upvalues: t200 (copy), proto (copy), prop_types (copy)
			local v1599 = t200.new()
			local n100 = 0

			while n100 < buffer.len(p152) do
				local v1601, v1602

				v1601, v1602, n100 = proto.readTag(p152, n100)

				if v1602 == proto.wireTypes.varint then
					local v1603

					v1603, n100 = proto.readVarInt(p152, n100)
				elseif v1602 == proto.wireTypes.lengthDelimited then
					if v1601 == 1 then
						local v1604

						v1604, n100 = proto.readBuffer(p152, n100)
						v1599.category_id = prop_types.StringProp.decode(v1604)
					else
						local v1605, v1606 = proto.readVarInt(p152, n100)

						n100 = v1606 + v1605
					end
				elseif v1602 == proto.wireTypes.i32 then
					local v1607

					v1607, n100 = proto.readFixed32(p152, n100)
				elseif v1602 == proto.wireTypes.i64 then
					local v1608

					v1608, n100 = proto.readFixed64(p152, n100)
				else
					error("Unsupported wire type: " .. v1602)
				end
			end

			return v1599
		end
		function t200.jsonEncode(p153) -- line: 12940
			local t202 = {}

			if p153.category_id ~= nil then
				t202.categoryId = p153.category_id:jsonEncode()
			end

			return t202
		end
		function t200.jsonDecode(t203: {[any]: any}) -- line: 12950
			-- upvalues: t200 (copy), prop_types (copy)
			local v1612 = t200.new()

			if t203.category_id ~= nil then
				v1612.category_id = prop_types.StringProp.jsonDecode(t203.category_id)
			end

			if t203.categoryId ~= nil then
				v1612.category_id = prop_types.StringProp.jsonDecode(t203.categoryId)
			end

			return v1612
		end

		t200.descriptor = {
			name = "SelectMarketplaceCatalogCategory_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.SelectMarketplaceCatalogCategory_Params = t200
		typeRegistry.default:register(t1.SelectMarketplaceCatalogCategory_Params)

		local t204 = {}

		t204.__index = t204

		function t204.new(t205: {[any]: any}?) -- line: 12981
			-- upvalues: t1 (copy), t204 (copy)
			return (setmetatable({
				action_type = if t205 ~= nil and t205.action_type ~= nil then t205.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t205 ~= nil and t205.action_params ~= nil then t205.action_params else nil
			}, t204))
		end
		function t204.encode(p154) -- line: 12992
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n101 = 0

			if p154.action_type ~= nil and (p154.action_type ~= nil and p154.action_type ~= 0 or p154.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1617, v1618 = proto.writeTag(buf, n101, 1, proto.wireTypes.varint)

				buf, n101 = proto.writeVarInt(v1617, v1618, t1.ActionType.toNumber(p154.action_type))
			end

			if p154.action_params ~= nil then
				local v1619 = p154.action_params:encode()
				local v1620, v1621 = proto.writeTag(buf, n101, 2, proto.wireTypes.lengthDelimited)

				buf, n101 = proto.writeBuffer(v1620, v1621, v1619, buffer.len(v1619))
			end

			local buf53 = buffer.create(n101)

			buffer.copy(buf53, 0, buf, 0, n101)

			return buf53
		end
		function t204.decode(p155: buffer) -- line: 13018
			-- upvalues: t204 (copy), proto (copy), t1 (copy)
			local v1624 = t204.new()
			local n102 = 0

			while n102 < buffer.len(p155) do
				local v1626, v1627

				v1626, v1627, n102 = proto.readTag(p155, n102)

				if v1627 == proto.wireTypes.varint then
					if v1626 == 1 then
						local v1628

						v1628, n102 = proto.readVarIntI32(p155, n102)
						v1624.action_type = t1.ActionType.fromNumber(v1628) or v1628
					else
						local v1629

						v1629, n102 = proto.readVarInt(p155, n102)
					end
				elseif v1627 == proto.wireTypes.lengthDelimited then
					if v1626 == 2 then
						local v1630

						v1630, n102 = proto.readBuffer(p155, n102)
						v1624.action_params = t1.SelectMarketplaceCatalogSubcategory_Params.decode(v1630)
					else
						local v1631, v1632 = proto.readVarInt(p155, n102)

						n102 = v1632 + v1631
					end
				elseif v1627 == proto.wireTypes.i32 then
					local v1633

					v1633, n102 = proto.readFixed32(p155, n102)
				elseif v1627 == proto.wireTypes.i64 then
					local v1634

					v1634, n102 = proto.readFixed64(p155, n102)
				else
					error("Unsupported wire type: " .. v1627)
				end
			end

			return v1624
		end
		function t204.jsonEncode(p156) -- line: 13066
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
		function t204.jsonDecode(t207: {[any]: any}) -- line: 13088
			-- upvalues: t204 (copy), t1 (copy)
			local v1638 = t204.new()

			if t207.action_type ~= nil then
				v1638.action_type = if typeof(t207.action_type) ~= "number" then t1.ActionType.fromName(t207.action_type) or t207.action_type else t1.ActionType.fromNumber(t207.action_type) or t207.action_type
			end

			if t207.actionType ~= nil then
				v1638.action_type = if typeof(t207.actionType) ~= "number" then t1.ActionType.fromName(t207.actionType) or t207.actionType else t1.ActionType.fromNumber(t207.actionType) or t207.actionType
			end

			if t207.action_params ~= nil then
				v1638.action_params = t1.SelectMarketplaceCatalogSubcategory_Params.jsonDecode(t207.action_params)
			end

			if t207.actionParams ~= nil then
				v1638.action_params = t1.SelectMarketplaceCatalogSubcategory_Params.jsonDecode(t207.actionParams)
			end

			return v1638
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

		function t208.new(t209: {[any]: any}?) -- line: 13130
			-- upvalues: t208 (copy)
			return (setmetatable({
				subcategory_id = if t209 ~= nil and t209.subcategory_id ~= nil then t209.subcategory_id else nil
			}, t208))
		end
		function t208.encode(p157) -- line: 13138
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n103 = 0

			if p157.subcategory_id ~= nil then
				local v1643 = p157.subcategory_id:encode()
				local v1644, v1645 = proto.writeTag(buf, n103, 1, proto.wireTypes.lengthDelimited)

				buf, n103 = proto.writeBuffer(v1644, v1645, v1643, buffer.len(v1643))
			end

			local buf54 = buffer.create(n103)

			buffer.copy(buf54, 0, buf, 0, n103)

			return buf54
		end
		function t208.decode(p158: buffer) -- line: 13155
			-- upvalues: t208 (copy), proto (copy), prop_types (copy)
			local v1648 = t208.new()
			local n104 = 0

			while n104 < buffer.len(p158) do
				local v1650, v1651

				v1650, v1651, n104 = proto.readTag(p158, n104)

				if v1651 == proto.wireTypes.varint then
					local v1652

					v1652, n104 = proto.readVarInt(p158, n104)
				elseif v1651 == proto.wireTypes.lengthDelimited then
					if v1650 == 1 then
						local v1653

						v1653, n104 = proto.readBuffer(p158, n104)
						v1648.subcategory_id = prop_types.StringProp.decode(v1653)
					else
						local v1654, v1655 = proto.readVarInt(p158, n104)

						n104 = v1655 + v1654
					end
				elseif v1651 == proto.wireTypes.i32 then
					local v1656

					v1656, n104 = proto.readFixed32(p158, n104)
				elseif v1651 == proto.wireTypes.i64 then
					local v1657

					v1657, n104 = proto.readFixed64(p158, n104)
				else
					error("Unsupported wire type: " .. v1651)
				end
			end

			return v1648
		end
		function t208.jsonEncode(p159) -- line: 13200
			local t210 = {}

			if p159.subcategory_id ~= nil then
				t210.subcategoryId = p159.subcategory_id:jsonEncode()
			end

			return t210
		end
		function t208.jsonDecode(t211: {[any]: any}) -- line: 13212
			-- upvalues: t208 (copy), prop_types (copy)
			local v1661 = t208.new()

			if t211.subcategory_id ~= nil then
				v1661.subcategory_id = prop_types.StringProp.jsonDecode(t211.subcategory_id)
			end

			if t211.subcategoryId ~= nil then
				v1661.subcategory_id = prop_types.StringProp.jsonDecode(t211.subcategoryId)
			end

			return v1661
		end

		t208.descriptor = {
			name = "SelectMarketplaceCatalogSubcategory_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.SelectMarketplaceCatalogSubcategory_Params = t208
		typeRegistry.default:register(t1.SelectMarketplaceCatalogSubcategory_Params)

		local t212 = {}

		t212.__index = t212

		function t212.new(t213: {[any]: any}?) -- line: 13244
			-- upvalues: t1 (copy), t212 (copy)
			return (setmetatable({
				action_type = if t213 ~= nil and t213.action_type ~= nil then t213.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t213 ~= nil and t213.action_params ~= nil then t213.action_params else nil
			}, t212))
		end
		function t212.encode(p160) -- line: 13255
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n105 = 0

			if p160.action_type ~= nil and (p160.action_type ~= nil and p160.action_type ~= 0 or p160.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1666, v1667 = proto.writeTag(buf, n105, 1, proto.wireTypes.varint)

				buf, n105 = proto.writeVarInt(v1666, v1667, t1.ActionType.toNumber(p160.action_type))
			end

			if p160.action_params ~= nil then
				local v1668 = p160.action_params:encode()
				local v1669, v1670 = proto.writeTag(buf, n105, 2, proto.wireTypes.lengthDelimited)

				buf, n105 = proto.writeBuffer(v1669, v1670, v1668, buffer.len(v1668))
			end

			local buf55 = buffer.create(n105)

			buffer.copy(buf55, 0, buf, 0, n105)

			return buf55
		end
		function t212.decode(p161: buffer) -- line: 13281
			-- upvalues: t212 (copy), proto (copy), t1 (copy)
			local v1673 = t212.new()
			local n106 = 0

			while n106 < buffer.len(p161) do
				local v1675, v1676

				v1675, v1676, n106 = proto.readTag(p161, n106)

				if v1676 == proto.wireTypes.varint then
					if v1675 == 1 then
						local v1677

						v1677, n106 = proto.readVarIntI32(p161, n106)
						v1673.action_type = t1.ActionType.fromNumber(v1677) or v1677
					else
						local v1678

						v1678, n106 = proto.readVarInt(p161, n106)
					end
				elseif v1676 == proto.wireTypes.lengthDelimited then
					if v1675 == 2 then
						local v1679

						v1679, n106 = proto.readBuffer(p161, n106)
						v1673.action_params = t1.OpenMarketplaceCatalogSeeAll_Params.decode(v1679)
					else
						local v1680, v1681 = proto.readVarInt(p161, n106)

						n106 = v1681 + v1680
					end
				elseif v1676 == proto.wireTypes.i32 then
					local v1682

					v1682, n106 = proto.readFixed32(p161, n106)
				elseif v1676 == proto.wireTypes.i64 then
					local v1683

					v1683, n106 = proto.readFixed64(p161, n106)
				else
					error("Unsupported wire type: " .. v1676)
				end
			end

			return v1673
		end
		function t212.jsonEncode(p162) -- line: 13329
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
		function t212.jsonDecode(t215: {[any]: any}) -- line: 13351
			-- upvalues: t212 (copy), t1 (copy)
			local v1687 = t212.new()

			if t215.action_type ~= nil then
				v1687.action_type = if typeof(t215.action_type) ~= "number" then t1.ActionType.fromName(t215.action_type) or t215.action_type else t1.ActionType.fromNumber(t215.action_type) or t215.action_type
			end

			if t215.actionType ~= nil then
				v1687.action_type = if typeof(t215.actionType) ~= "number" then t1.ActionType.fromName(t215.actionType) or t215.actionType else t1.ActionType.fromNumber(t215.actionType) or t215.actionType
			end

			if t215.action_params ~= nil then
				v1687.action_params = t1.OpenMarketplaceCatalogSeeAll_Params.jsonDecode(t215.action_params)
			end

			if t215.actionParams ~= nil then
				v1687.action_params = t1.OpenMarketplaceCatalogSeeAll_Params.jsonDecode(t215.actionParams)
			end

			return v1687
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

		function t216.new(t217: {[any]: any}?) -- line: 13391
			-- upvalues: t216 (copy)
			return (setmetatable({
				sort_id = if t217 ~= nil and t217.sort_id ~= nil then t217.sort_id else nil,
				title = if t217 ~= nil and t217.title ~= nil then t217.title else nil,
				description = if t217 ~= nil and t217.description ~= nil then t217.description else nil,
				tooltip_text = if t217 ~= nil and t217.tooltip_text ~= nil then t217.tooltip_text else nil
			}, t216))
		end
		function t216.encode(p163) -- line: 13402
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n107 = 0

			if p163.sort_id ~= nil then
				local v1692 = p163.sort_id:encode()
				local v1693, v1694 = proto.writeTag(buf, n107, 1, proto.wireTypes.lengthDelimited)

				buf, n107 = proto.writeBuffer(v1693, v1694, v1692, buffer.len(v1692))
			end

			if p163.title ~= nil then
				local v1695 = p163.title:encode()
				local v1696, v1697 = proto.writeTag(buf, n107, 2, proto.wireTypes.lengthDelimited)

				buf, n107 = proto.writeBuffer(v1696, v1697, v1695, buffer.len(v1695))
			end

			if p163.description ~= nil then
				local v1698 = p163.description:encode()
				local v1699, v1700 = proto.writeTag(buf, n107, 3, proto.wireTypes.lengthDelimited)

				buf, n107 = proto.writeBuffer(v1699, v1700, v1698, buffer.len(v1698))
			end

			if p163.tooltip_text ~= nil then
				local v1701 = p163.tooltip_text:encode()
				local v1702, v1703 = proto.writeTag(buf, n107, 4, proto.wireTypes.lengthDelimited)

				buf, n107 = proto.writeBuffer(v1702, v1703, v1701, buffer.len(v1701))
			end

			local buf56 = buffer.create(n107)

			buffer.copy(buf56, 0, buf, 0, n107)

			return buf56
		end
		function t216.decode(p164: buffer) -- line: 13435
			-- upvalues: t216 (copy), proto (copy), prop_types (copy)
			local v1706 = t216.new()
			local n108 = 0

			while n108 < buffer.len(p164) do
				local v1708, v1709

				v1708, v1709, n108 = proto.readTag(p164, n108)

				if v1709 == proto.wireTypes.varint then
					local v1710

					v1710, n108 = proto.readVarInt(p164, n108)
				elseif v1709 == proto.wireTypes.lengthDelimited then
					if v1708 == 1 then
						local v1711

						v1711, n108 = proto.readBuffer(p164, n108)
						v1706.sort_id = prop_types.StringProp.decode(v1711)
					elseif v1708 == 2 then
						local v1712

						v1712, n108 = proto.readBuffer(p164, n108)
						v1706.title = prop_types.StringProp.decode(v1712)
					elseif v1708 == 3 then
						local v1713

						v1713, n108 = proto.readBuffer(p164, n108)
						v1706.description = prop_types.StringProp.decode(v1713)
					elseif v1708 == 4 then
						local v1714

						v1714, n108 = proto.readBuffer(p164, n108)
						v1706.tooltip_text = prop_types.StringProp.decode(v1714)
					else
						local v1715, v1716 = proto.readVarInt(p164, n108)

						n108 = v1716 + v1715
					end
				elseif v1709 == proto.wireTypes.i32 then
					local v1717

					v1717, n108 = proto.readFixed32(p164, n108)
				elseif v1709 == proto.wireTypes.i64 then
					local v1718

					v1718, n108 = proto.readFixed64(p164, n108)
				else
					error("Unsupported wire type: " .. v1709)
				end
			end

			return v1706
		end
		function t216.jsonEncode(p165) -- line: 13493
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
		function t216.jsonDecode(t219: {[any]: any}) -- line: 13515
			-- upvalues: t216 (copy), prop_types (copy)
			local v1722 = t216.new()

			if t219.sort_id ~= nil then
				v1722.sort_id = prop_types.StringProp.jsonDecode(t219.sort_id)
			end

			if t219.sortId ~= nil then
				v1722.sort_id = prop_types.StringProp.jsonDecode(t219.sortId)
			end

			if t219.title ~= nil then
				v1722.title = prop_types.StringProp.jsonDecode(t219.title)
			end

			if t219.description ~= nil then
				v1722.description = prop_types.StringProp.jsonDecode(t219.description)
			end

			if t219.tooltip_text ~= nil then
				v1722.tooltip_text = prop_types.StringProp.jsonDecode(t219.tooltip_text)
			end

			if t219.tooltipText ~= nil then
				v1722.tooltip_text = prop_types.StringProp.jsonDecode(t219.tooltipText)
			end

			return v1722
		end

		t216.descriptor = {
			name = "OpenMarketplaceCatalogSeeAll_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenMarketplaceCatalogSeeAll_Params = t216
		typeRegistry.default:register(t1.OpenMarketplaceCatalogSeeAll_Params)

		local t220 = {}

		t220.__index = t220

		function t220.new(t221: {[any]: any}?) -- line: 13564
			-- upvalues: t1 (copy), t220 (copy)
			return (setmetatable({
				action_type = if t221 ~= nil and t221.action_type ~= nil then t221.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t221 ~= nil and t221.action_params ~= nil then t221.action_params else nil
			}, t220))
		end
		function t220.encode(p166) -- line: 13575
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n109 = 0

			if p166.action_type ~= nil and (p166.action_type ~= nil and p166.action_type ~= 0 or p166.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1727, v1728 = proto.writeTag(buf, n109, 1, proto.wireTypes.varint)

				buf, n109 = proto.writeVarInt(v1727, v1728, t1.ActionType.toNumber(p166.action_type))
			end

			if p166.action_params ~= nil then
				local v1729 = p166.action_params:encode()
				local v1730, v1731 = proto.writeTag(buf, n109, 2, proto.wireTypes.lengthDelimited)

				buf, n109 = proto.writeBuffer(v1730, v1731, v1729, buffer.len(v1729))
			end

			local buf57 = buffer.create(n109)

			buffer.copy(buf57, 0, buf, 0, n109)

			return buf57
		end
		function t220.decode(p167: buffer) -- line: 13601
			-- upvalues: t220 (copy), proto (copy), t1 (copy)
			local v1734 = t220.new()
			local n110 = 0

			while n110 < buffer.len(p167) do
				local v1736, v1737

				v1736, v1737, n110 = proto.readTag(p167, n110)

				if v1737 == proto.wireTypes.varint then
					if v1736 == 1 then
						local v1738

						v1738, n110 = proto.readVarIntI32(p167, n110)
						v1734.action_type = t1.ActionType.fromNumber(v1738) or v1738
					else
						local v1739

						v1739, n110 = proto.readVarInt(p167, n110)
					end
				elseif v1737 == proto.wireTypes.lengthDelimited then
					if v1736 == 2 then
						local v1740

						v1740, n110 = proto.readBuffer(p167, n110)
						v1734.action_params = t1.CloseMarketplaceCategoryTooltip_Params.decode(v1740)
					else
						local v1741, v1742 = proto.readVarInt(p167, n110)

						n110 = v1742 + v1741
					end
				elseif v1737 == proto.wireTypes.i32 then
					local v1743

					v1743, n110 = proto.readFixed32(p167, n110)
				elseif v1737 == proto.wireTypes.i64 then
					local v1744

					v1744, n110 = proto.readFixed64(p167, n110)
				else
					error("Unsupported wire type: " .. v1737)
				end
			end

			return v1734
		end
		function t220.jsonEncode(p168) -- line: 13649
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
		function t220.jsonDecode(t223: {[any]: any}) -- line: 13671
			-- upvalues: t220 (copy), t1 (copy)
			local v1748 = t220.new()

			if t223.action_type ~= nil then
				v1748.action_type = if typeof(t223.action_type) ~= "number" then t1.ActionType.fromName(t223.action_type) or t223.action_type else t1.ActionType.fromNumber(t223.action_type) or t223.action_type
			end

			if t223.actionType ~= nil then
				v1748.action_type = if typeof(t223.actionType) ~= "number" then t1.ActionType.fromName(t223.actionType) or t223.actionType else t1.ActionType.fromNumber(t223.actionType) or t223.actionType
			end

			if t223.action_params ~= nil then
				v1748.action_params = t1.CloseMarketplaceCategoryTooltip_Params.jsonDecode(t223.action_params)
			end

			if t223.actionParams ~= nil then
				v1748.action_params = t1.CloseMarketplaceCategoryTooltip_Params.jsonDecode(t223.actionParams)
			end

			return v1748
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

		function t224.new(t225: {[any]: any}?) -- line: 13711
			-- upvalues: t224 (copy)
			return (setmetatable({
				tooltip_id = if t225 ~= nil and t225.tooltip_id ~= nil then t225.tooltip_id else nil
			}, t224))
		end
		function t224.encode(p169) -- line: 13719
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n111 = 0

			if p169.tooltip_id ~= nil then
				local v1753 = p169.tooltip_id:encode()
				local v1754, v1755 = proto.writeTag(buf, n111, 1, proto.wireTypes.lengthDelimited)

				buf, n111 = proto.writeBuffer(v1754, v1755, v1753, buffer.len(v1753))
			end

			local buf58 = buffer.create(n111)

			buffer.copy(buf58, 0, buf, 0, n111)

			return buf58
		end
		function t224.decode(p170: buffer) -- line: 13734
			-- upvalues: t224 (copy), proto (copy), prop_types (copy)
			local v1758 = t224.new()
			local n112 = 0

			while n112 < buffer.len(p170) do
				local v1760, v1761

				v1760, v1761, n112 = proto.readTag(p170, n112)

				if v1761 == proto.wireTypes.varint then
					local v1762

					v1762, n112 = proto.readVarInt(p170, n112)
				elseif v1761 == proto.wireTypes.lengthDelimited then
					if v1760 == 1 then
						local v1763

						v1763, n112 = proto.readBuffer(p170, n112)
						v1758.tooltip_id = prop_types.StringProp.decode(v1763)
					else
						local v1764, v1765 = proto.readVarInt(p170, n112)

						n112 = v1765 + v1764
					end
				elseif v1761 == proto.wireTypes.i32 then
					local v1766

					v1766, n112 = proto.readFixed32(p170, n112)
				elseif v1761 == proto.wireTypes.i64 then
					local v1767

					v1767, n112 = proto.readFixed64(p170, n112)
				else
					error("Unsupported wire type: " .. v1761)
				end
			end

			return v1758
		end
		function t224.jsonEncode(p171) -- line: 13777
			local t226 = {}

			if p171.tooltip_id ~= nil then
				t226.tooltipId = p171.tooltip_id:jsonEncode()
			end

			return t226
		end
		function t224.jsonDecode(t227: {[any]: any}) -- line: 13787
			-- upvalues: t224 (copy), prop_types (copy)
			local v1771 = t224.new()

			if t227.tooltip_id ~= nil then
				v1771.tooltip_id = prop_types.StringProp.jsonDecode(t227.tooltip_id)
			end

			if t227.tooltipId ~= nil then
				v1771.tooltip_id = prop_types.StringProp.jsonDecode(t227.tooltipId)
			end

			return v1771
		end

		t224.descriptor = {
			name = "CloseMarketplaceCategoryTooltip_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.CloseMarketplaceCategoryTooltip_Params = t224
		typeRegistry.default:register(t1.CloseMarketplaceCategoryTooltip_Params)

		local t228 = {}

		t228.__index = t228

		function t228.new(t229: {[any]: any}?) -- line: 13817
			-- upvalues: t1 (copy), t228 (copy)
			return (setmetatable({
				action_type = if t229 ~= nil and t229.action_type ~= nil then t229.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t229 ~= nil and t229.action_params ~= nil then t229.action_params else nil
			}, t228))
		end
		function t228.encode(p172) -- line: 13826
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n113 = 0

			if p172.action_type ~= nil and (p172.action_type ~= nil and p172.action_type ~= 0 or p172.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1776, v1777 = proto.writeTag(buf, n113, 1, proto.wireTypes.varint)

				buf, n113 = proto.writeVarInt(v1776, v1777, t1.ActionType.toNumber(p172.action_type))
			end

			if p172.action_params ~= nil then
				local v1778 = p172.action_params:encode()
				local v1779, v1780 = proto.writeTag(buf, n113, 2, proto.wireTypes.lengthDelimited)

				buf, n113 = proto.writeBuffer(v1779, v1780, v1778, buffer.len(v1778))
			end

			local buf59 = buffer.create(n113)

			buffer.copy(buf59, 0, buf, 0, n113)

			return buf59
		end
		function t228.decode(p173: buffer) -- line: 13852
			-- upvalues: t228 (copy), proto (copy), t1 (copy)
			local v1783 = t228.new()
			local n114 = 0

			while n114 < buffer.len(p173) do
				local v1785, v1786

				v1785, v1786, n114 = proto.readTag(p173, n114)

				if v1786 == proto.wireTypes.varint then
					if v1785 == 1 then
						local v1787

						v1787, n114 = proto.readVarIntI32(p173, n114)
						v1783.action_type = t1.ActionType.fromNumber(v1787) or v1787
					else
						local v1788

						v1788, n114 = proto.readVarInt(p173, n114)
					end
				elseif v1786 == proto.wireTypes.lengthDelimited then
					if v1785 == 2 then
						local v1789

						v1789, n114 = proto.readBuffer(p173, n114)
						v1783.action_params = t1.ResizeMarketplaceCatalog_Params.decode(v1789)
					else
						local v1790, v1791 = proto.readVarInt(p173, n114)

						n114 = v1791 + v1790
					end
				elseif v1786 == proto.wireTypes.i32 then
					local v1792

					v1792, n114 = proto.readFixed32(p173, n114)
				elseif v1786 == proto.wireTypes.i64 then
					local v1793

					v1793, n114 = proto.readFixed64(p173, n114)
				else
					error("Unsupported wire type: " .. v1786)
				end
			end

			return v1783
		end
		function t228.jsonEncode(p174) -- line: 13900
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
		function t228.jsonDecode(t231: {[any]: any}) -- line: 13922
			-- upvalues: t228 (copy), t1 (copy)
			local v1797 = t228.new()

			if t231.action_type ~= nil then
				v1797.action_type = if typeof(t231.action_type) ~= "number" then t1.ActionType.fromName(t231.action_type) or t231.action_type else t1.ActionType.fromNumber(t231.action_type) or t231.action_type
			end

			if t231.actionType ~= nil then
				v1797.action_type = if typeof(t231.actionType) ~= "number" then t1.ActionType.fromName(t231.actionType) or t231.actionType else t1.ActionType.fromNumber(t231.actionType) or t231.actionType
			end

			if t231.action_params ~= nil then
				v1797.action_params = t1.ResizeMarketplaceCatalog_Params.jsonDecode(t231.action_params)
			end

			if t231.actionParams ~= nil then
				v1797.action_params = t1.ResizeMarketplaceCatalog_Params.jsonDecode(t231.actionParams)
			end

			return v1797
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

		function t232.new(t233: {[any]: any}?) -- line: 13962
			-- upvalues: t232 (copy)
			return (setmetatable({
				category_id = if t233 ~= nil and t233.category_id ~= nil then t233.category_id else nil,
				subcategory_id = if t233 ~= nil and t233.subcategory_id ~= nil then t233.subcategory_id else nil,
				screen_size = if t233 ~= nil and t233.screen_size ~= nil then t233.screen_size else nil
			}, t232))
		end
		function t232.encode(p175) -- line: 13972
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n115 = 0

			if p175.category_id ~= nil then
				local v1802 = p175.category_id:encode()
				local v1803, v1804 = proto.writeTag(buf, n115, 1, proto.wireTypes.lengthDelimited)

				buf, n115 = proto.writeBuffer(v1803, v1804, v1802, buffer.len(v1802))
			end

			if p175.subcategory_id ~= nil then
				local v1805 = p175.subcategory_id:encode()
				local v1806, v1807 = proto.writeTag(buf, n115, 2, proto.wireTypes.lengthDelimited)

				buf, n115 = proto.writeBuffer(v1806, v1807, v1805, buffer.len(v1805))
			end

			if p175.screen_size ~= nil then
				local v1808 = p175.screen_size:encode()
				local v1809, v1810 = proto.writeTag(buf, n115, 3, proto.wireTypes.lengthDelimited)

				buf, n115 = proto.writeBuffer(v1809, v1810, v1808, buffer.len(v1808))
			end

			local buf60 = buffer.create(n115)

			buffer.copy(buf60, 0, buf, 0, n115)

			return buf60
		end
		function t232.decode(p176: buffer) -- line: 13999
			-- upvalues: t232 (copy), proto (copy), prop_types (copy)
			local v1813 = t232.new()
			local n116 = 0

			while n116 < buffer.len(p176) do
				local v1815, v1816

				v1815, v1816, n116 = proto.readTag(p176, n116)

				if v1816 == proto.wireTypes.varint then
					local v1817

					v1817, n116 = proto.readVarInt(p176, n116)
				elseif v1816 == proto.wireTypes.lengthDelimited then
					if v1815 == 1 then
						local v1818

						v1818, n116 = proto.readBuffer(p176, n116)
						v1813.category_id = prop_types.StringProp.decode(v1818)
					elseif v1815 == 2 then
						local v1819

						v1819, n116 = proto.readBuffer(p176, n116)
						v1813.subcategory_id = prop_types.StringProp.decode(v1819)
					elseif v1815 == 3 then
						local v1820

						v1820, n116 = proto.readBuffer(p176, n116)
						v1813.screen_size = prop_types.StringProp.decode(v1820)
					else
						local v1821, v1822 = proto.readVarInt(p176, n116)

						n116 = v1822 + v1821
					end
				elseif v1816 == proto.wireTypes.i32 then
					local v1823

					v1823, n116 = proto.readFixed32(p176, n116)
				elseif v1816 == proto.wireTypes.i64 then
					local v1824

					v1824, n116 = proto.readFixed64(p176, n116)
				else
					error("Unsupported wire type: " .. v1816)
				end
			end

			return v1813
		end
		function t232.jsonEncode(p177) -- line: 14052
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
		function t232.jsonDecode(t235: {[any]: any}) -- line: 14070
			-- upvalues: t232 (copy), prop_types (copy)
			local v1828 = t232.new()

			if t235.category_id ~= nil then
				v1828.category_id = prop_types.StringProp.jsonDecode(t235.category_id)
			end

			if t235.categoryId ~= nil then
				v1828.category_id = prop_types.StringProp.jsonDecode(t235.categoryId)
			end

			if t235.subcategory_id ~= nil then
				v1828.subcategory_id = prop_types.StringProp.jsonDecode(t235.subcategory_id)
			end

			if t235.subcategoryId ~= nil then
				v1828.subcategory_id = prop_types.StringProp.jsonDecode(t235.subcategoryId)
			end

			if t235.screen_size ~= nil then
				v1828.screen_size = prop_types.StringProp.jsonDecode(t235.screen_size)
			end

			if t235.screenSize ~= nil then
				v1828.screen_size = prop_types.StringProp.jsonDecode(t235.screenSize)
			end

			return v1828
		end

		t232.descriptor = {
			name = "ResizeMarketplaceCatalog_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.ResizeMarketplaceCatalog_Params = t232
		typeRegistry.default:register(t1.ResizeMarketplaceCatalog_Params)

		local t236 = {}

		t236.__index = t236

		function t236.new(t237: {[any]: any}?) -- line: 14118
			-- upvalues: t1 (copy), t236 (copy)
			return (setmetatable({
				action_type = if t237 ~= nil and t237.action_type ~= nil then t237.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t237 ~= nil and t237.action_params ~= nil then t237.action_params else nil
			}, t236))
		end
		function t236.encode(p178) -- line: 14129
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n117 = 0

			if p178.action_type ~= nil and (p178.action_type ~= nil and p178.action_type ~= 0 or p178.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1833, v1834 = proto.writeTag(buf, n117, 1, proto.wireTypes.varint)

				buf, n117 = proto.writeVarInt(v1833, v1834, t1.ActionType.toNumber(p178.action_type))
			end

			if p178.action_params ~= nil then
				local v1835 = p178.action_params:encode()
				local v1836, v1837 = proto.writeTag(buf, n117, 2, proto.wireTypes.lengthDelimited)

				buf, n117 = proto.writeBuffer(v1836, v1837, v1835, buffer.len(v1835))
			end

			local buf61 = buffer.create(n117)

			buffer.copy(buf61, 0, buf, 0, n117)

			return buf61
		end
		function t236.decode(p179: buffer) -- line: 14155
			-- upvalues: t236 (copy), proto (copy), t1 (copy)
			local v1840 = t236.new()
			local n118 = 0

			while n118 < buffer.len(p179) do
				local v1842, v1843

				v1842, v1843, n118 = proto.readTag(p179, n118)

				if v1843 == proto.wireTypes.varint then
					if v1842 == 1 then
						local v1844

						v1844, n118 = proto.readVarIntI32(p179, n118)
						v1840.action_type = t1.ActionType.fromNumber(v1844) or v1844
					else
						local v1845

						v1845, n118 = proto.readVarInt(p179, n118)
					end
				elseif v1843 == proto.wireTypes.lengthDelimited then
					if v1842 == 2 then
						local v1846

						v1846, n118 = proto.readBuffer(p179, n118)
						v1840.action_params = t1.OpenChartsSortDetailAction_Params.decode(v1846)
					else
						local v1847, v1848 = proto.readVarInt(p179, n118)

						n118 = v1848 + v1847
					end
				elseif v1843 == proto.wireTypes.i32 then
					local v1849

					v1849, n118 = proto.readFixed32(p179, n118)
				elseif v1843 == proto.wireTypes.i64 then
					local v1850

					v1850, n118 = proto.readFixed64(p179, n118)
				else
					error("Unsupported wire type: " .. v1843)
				end
			end

			return v1840
		end
		function t236.jsonEncode(p180) -- line: 14203
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
		function t236.jsonDecode(t239: {[any]: any}) -- line: 14225
			-- upvalues: t236 (copy), t1 (copy)
			local v1854 = t236.new()

			if t239.action_type ~= nil then
				v1854.action_type = if typeof(t239.action_type) ~= "number" then t1.ActionType.fromName(t239.action_type) or t239.action_type else t1.ActionType.fromNumber(t239.action_type) or t239.action_type
			end

			if t239.actionType ~= nil then
				v1854.action_type = if typeof(t239.actionType) ~= "number" then t1.ActionType.fromName(t239.actionType) or t239.actionType else t1.ActionType.fromNumber(t239.actionType) or t239.actionType
			end

			if t239.action_params ~= nil then
				v1854.action_params = t1.OpenChartsSortDetailAction_Params.jsonDecode(t239.action_params)
			end

			if t239.actionParams ~= nil then
				v1854.action_params = t1.OpenChartsSortDetailAction_Params.jsonDecode(t239.actionParams)
			end

			return v1854
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

		function t240.new(t241: {[any]: any}?) -- line: 14265
			-- upvalues: t240 (copy)
			return (setmetatable({
				sort_id = if t241 ~= nil and t241.sort_id ~= nil then t241.sort_id else nil,
				secondary_sort_id = if t241 ~= nil and t241.secondary_sort_id ~= nil then t241.secondary_sort_id else nil
			}, t240))
		end
		function t240.encode(p181) -- line: 14274
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n119 = 0

			if p181.sort_id ~= nil then
				local v1859 = p181.sort_id:encode()
				local v1860, v1861 = proto.writeTag(buf, n119, 1, proto.wireTypes.lengthDelimited)

				buf, n119 = proto.writeBuffer(v1860, v1861, v1859, buffer.len(v1859))
			end

			if p181.secondary_sort_id ~= nil then
				local v1862 = p181.secondary_sort_id:encode()
				local v1863, v1864 = proto.writeTag(buf, n119, 2, proto.wireTypes.lengthDelimited)

				buf, n119 = proto.writeBuffer(v1863, v1864, v1862, buffer.len(v1862))
			end

			local buf62 = buffer.create(n119)

			buffer.copy(buf62, 0, buf, 0, n119)

			return buf62
		end
		function t240.decode(p182: buffer) -- line: 14295
			-- upvalues: t240 (copy), proto (copy), prop_types (copy)
			local v1867 = t240.new()
			local n120 = 0

			while n120 < buffer.len(p182) do
				local v1869, v1870

				v1869, v1870, n120 = proto.readTag(p182, n120)

				if v1870 == proto.wireTypes.varint then
					local v1871

					v1871, n120 = proto.readVarInt(p182, n120)
				elseif v1870 == proto.wireTypes.lengthDelimited then
					if v1869 == 1 then
						local v1872

						v1872, n120 = proto.readBuffer(p182, n120)
						v1867.sort_id = prop_types.StringProp.decode(v1872)
					elseif v1869 == 2 then
						local v1873

						v1873, n120 = proto.readBuffer(p182, n120)
						v1867.secondary_sort_id = prop_types.Int32Prop.decode(v1873)
					else
						local v1874, v1875 = proto.readVarInt(p182, n120)

						n120 = v1875 + v1874
					end
				elseif v1870 == proto.wireTypes.i32 then
					local v1876

					v1876, n120 = proto.readFixed32(p182, n120)
				elseif v1870 == proto.wireTypes.i64 then
					local v1877

					v1877, n120 = proto.readFixed64(p182, n120)
				else
					error("Unsupported wire type: " .. v1870)
				end
			end

			return v1867
		end
		function t240.jsonEncode(p183) -- line: 14343
			local t242 = {}

			if p183.sort_id ~= nil then
				t242.sortId = p183.sort_id:jsonEncode()
			end

			if p183.secondary_sort_id ~= nil then
				t242.secondarySortId = p183.secondary_sort_id:jsonEncode()
			end

			return t242
		end
		function t240.jsonDecode(t243: {[any]: any}) -- line: 14357
			-- upvalues: t240 (copy), prop_types (copy)
			local v1881 = t240.new()

			if t243.sort_id ~= nil then
				v1881.sort_id = prop_types.StringProp.jsonDecode(t243.sort_id)
			end

			if t243.sortId ~= nil then
				v1881.sort_id = prop_types.StringProp.jsonDecode(t243.sortId)
			end

			if t243.secondary_sort_id ~= nil then
				v1881.secondary_sort_id = prop_types.Int32Prop.jsonDecode(t243.secondary_sort_id)
			end

			if t243.secondarySortId ~= nil then
				v1881.secondary_sort_id = prop_types.Int32Prop.jsonDecode(t243.secondarySortId)
			end

			return v1881
		end

		t240.descriptor = {
			name = "OpenChartsSortDetailAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenChartsSortDetailAction_Params = t240
		typeRegistry.default:register(t1.OpenChartsSortDetailAction_Params)

		local t244 = {}

		t244.__index = t244

		function t244.new(t245: {[any]: any}?) -- line: 14397
			-- upvalues: t1 (copy), t244 (copy)
			return (setmetatable({
				action_type = if t245 ~= nil and t245.action_type ~= nil then t245.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t245 ~= nil and t245.action_params ~= nil then t245.action_params else nil
			}, t244))
		end
		function t244.encode(p184) -- line: 14406
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n121 = 0

			if p184.action_type ~= nil and (p184.action_type ~= nil and p184.action_type ~= 0 or p184.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1886, v1887 = proto.writeTag(buf, n121, 1, proto.wireTypes.varint)

				buf, n121 = proto.writeVarInt(v1886, v1887, t1.ActionType.toNumber(p184.action_type))
			end

			if p184.action_params ~= nil then
				local v1888 = p184.action_params:encode()
				local v1889, v1890 = proto.writeTag(buf, n121, 2, proto.wireTypes.lengthDelimited)

				buf, n121 = proto.writeBuffer(v1889, v1890, v1888, buffer.len(v1888))
			end

			local buf63 = buffer.create(n121)

			buffer.copy(buf63, 0, buf, 0, n121)

			return buf63
		end
		function t244.decode(p185: buffer) -- line: 14432
			-- upvalues: t244 (copy), proto (copy), t1 (copy)
			local v1893 = t244.new()
			local n122 = 0

			while n122 < buffer.len(p185) do
				local v1895, v1896

				v1895, v1896, n122 = proto.readTag(p185, n122)

				if v1896 == proto.wireTypes.varint then
					if v1895 == 1 then
						local v1897

						v1897, n122 = proto.readVarIntI32(p185, n122)
						v1893.action_type = t1.ActionType.fromNumber(v1897) or v1897
					else
						local v1898

						v1898, n122 = proto.readVarInt(p185, n122)
					end
				elseif v1896 == proto.wireTypes.lengthDelimited then
					if v1895 == 2 then
						local v1899

						v1899, n122 = proto.readBuffer(p185, n122)
						v1893.action_params = t1.OpenSongDetailAction_Params.decode(v1899)
					else
						local v1900, v1901 = proto.readVarInt(p185, n122)

						n122 = v1901 + v1900
					end
				elseif v1896 == proto.wireTypes.i32 then
					local v1902

					v1902, n122 = proto.readFixed32(p185, n122)
				elseif v1896 == proto.wireTypes.i64 then
					local v1903

					v1903, n122 = proto.readFixed64(p185, n122)
				else
					error("Unsupported wire type: " .. v1896)
				end
			end

			return v1893
		end
		function t244.jsonEncode(p186) -- line: 14480
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
		function t244.jsonDecode(t247: {[any]: any}) -- line: 14502
			-- upvalues: t244 (copy), t1 (copy)
			local v1907 = t244.new()

			if t247.action_type ~= nil then
				v1907.action_type = if typeof(t247.action_type) ~= "number" then t1.ActionType.fromName(t247.action_type) or t247.action_type else t1.ActionType.fromNumber(t247.action_type) or t247.action_type
			end

			if t247.actionType ~= nil then
				v1907.action_type = if typeof(t247.actionType) ~= "number" then t1.ActionType.fromName(t247.actionType) or t247.actionType else t1.ActionType.fromNumber(t247.actionType) or t247.actionType
			end

			if t247.action_params ~= nil then
				v1907.action_params = t1.OpenSongDetailAction_Params.jsonDecode(t247.action_params)
			end

			if t247.actionParams ~= nil then
				v1907.action_params = t1.OpenSongDetailAction_Params.jsonDecode(t247.actionParams)
			end

			return v1907
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

		function t248.new(t249: {[any]: any}?) -- line: 14542
			-- upvalues: t248 (copy)
			return (setmetatable({
				song_id = if t249 ~= nil and t249.song_id ~= nil then t249.song_id else nil
			}, t248))
		end
		function t248.encode(p187) -- line: 14550
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n123 = 0

			if p187.song_id ~= nil then
				local v1912 = p187.song_id:encode()
				local v1913, v1914 = proto.writeTag(buf, n123, 1, proto.wireTypes.lengthDelimited)

				buf, n123 = proto.writeBuffer(v1913, v1914, v1912, buffer.len(v1912))
			end

			local buf64 = buffer.create(n123)

			buffer.copy(buf64, 0, buf, 0, n123)

			return buf64
		end
		function t248.decode(p188: buffer) -- line: 14565
			-- upvalues: t248 (copy), proto (copy), prop_types (copy)
			local v1917 = t248.new()
			local n124 = 0

			while n124 < buffer.len(p188) do
				local v1919, v1920

				v1919, v1920, n124 = proto.readTag(p188, n124)

				if v1920 == proto.wireTypes.varint then
					local v1921

					v1921, n124 = proto.readVarInt(p188, n124)
				elseif v1920 == proto.wireTypes.lengthDelimited then
					if v1919 == 1 then
						local v1922

						v1922, n124 = proto.readBuffer(p188, n124)
						v1917.song_id = prop_types.StringProp.decode(v1922)
					else
						local v1923, v1924 = proto.readVarInt(p188, n124)

						n124 = v1924 + v1923
					end
				elseif v1920 == proto.wireTypes.i32 then
					local v1925

					v1925, n124 = proto.readFixed32(p188, n124)
				elseif v1920 == proto.wireTypes.i64 then
					local v1926

					v1926, n124 = proto.readFixed64(p188, n124)
				else
					error("Unsupported wire type: " .. v1920)
				end
			end

			return v1917
		end
		function t248.jsonEncode(p189) -- line: 14608
			local t250 = {}

			if p189.song_id ~= nil then
				t250.songId = p189.song_id:jsonEncode()
			end

			return t250
		end
		function t248.jsonDecode(t251: {[any]: any}) -- line: 14618
			-- upvalues: t248 (copy), prop_types (copy)
			local v1930 = t248.new()

			if t251.song_id ~= nil then
				v1930.song_id = prop_types.StringProp.jsonDecode(t251.song_id)
			end

			if t251.songId ~= nil then
				v1930.song_id = prop_types.StringProp.jsonDecode(t251.songId)
			end

			return v1930
		end

		t248.descriptor = {
			name = "OpenSongDetailAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenSongDetailAction_Params = t248
		typeRegistry.default:register(t1.OpenSongDetailAction_Params)

		local t252 = {}

		t252.__index = t252

		function t252.new(t253: {[any]: any}?) -- line: 14646
			-- upvalues: t1 (copy), t252 (copy)
			return (setmetatable({
				action_type = if t253 ~= nil and t253.action_type ~= nil then t253.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t253 ~= nil and t253.action_params ~= nil then t253.action_params else nil
			}, t252))
		end
		function t252.encode(p190) -- line: 14657
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n125 = 0

			if p190.action_type ~= nil and (p190.action_type ~= nil and p190.action_type ~= 0 or p190.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1935, v1936 = proto.writeTag(buf, n125, 1, proto.wireTypes.varint)

				buf, n125 = proto.writeVarInt(v1935, v1936, t1.ActionType.toNumber(p190.action_type))
			end

			if p190.action_params ~= nil then
				local v1937 = p190.action_params:encode()
				local v1938, v1939 = proto.writeTag(buf, n125, 2, proto.wireTypes.lengthDelimited)

				buf, n125 = proto.writeBuffer(v1938, v1939, v1937, buffer.len(v1937))
			end

			local buf65 = buffer.create(n125)

			buffer.copy(buf65, 0, buf, 0, n125)

			return buf65
		end
		function t252.decode(p191: buffer) -- line: 14683
			-- upvalues: t252 (copy), proto (copy), t1 (copy)
			local v1942 = t252.new()
			local n126 = 0

			while n126 < buffer.len(p191) do
				local v1944, v1945

				v1944, v1945, n126 = proto.readTag(p191, n126)

				if v1945 == proto.wireTypes.varint then
					if v1944 == 1 then
						local v1946

						v1946, n126 = proto.readVarIntI32(p191, n126)
						v1942.action_type = t1.ActionType.fromNumber(v1946) or v1946
					else
						local v1947

						v1947, n126 = proto.readVarInt(p191, n126)
					end
				elseif v1945 == proto.wireTypes.lengthDelimited then
					if v1944 == 2 then
						local v1948

						v1948, n126 = proto.readBuffer(p191, n126)
						v1942.action_params = t1.OpenMarketplaceCatalogFilters_Params.decode(v1948)
					else
						local v1949, v1950 = proto.readVarInt(p191, n126)

						n126 = v1950 + v1949
					end
				elseif v1945 == proto.wireTypes.i32 then
					local v1951

					v1951, n126 = proto.readFixed32(p191, n126)
				elseif v1945 == proto.wireTypes.i64 then
					local v1952

					v1952, n126 = proto.readFixed64(p191, n126)
				else
					error("Unsupported wire type: " .. v1945)
				end
			end

			return v1942
		end
		function t252.jsonEncode(p192) -- line: 14731
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
		function t252.jsonDecode(t255: {[any]: any}) -- line: 14753
			-- upvalues: t252 (copy), t1 (copy)
			local v1956 = t252.new()

			if t255.action_type ~= nil then
				v1956.action_type = if typeof(t255.action_type) ~= "number" then t1.ActionType.fromName(t255.action_type) or t255.action_type else t1.ActionType.fromNumber(t255.action_type) or t255.action_type
			end

			if t255.actionType ~= nil then
				v1956.action_type = if typeof(t255.actionType) ~= "number" then t1.ActionType.fromName(t255.actionType) or t255.actionType else t1.ActionType.fromNumber(t255.actionType) or t255.actionType
			end

			if t255.action_params ~= nil then
				v1956.action_params = t1.OpenMarketplaceCatalogFilters_Params.jsonDecode(t255.action_params)
			end

			if t255.actionParams ~= nil then
				v1956.action_params = t1.OpenMarketplaceCatalogFilters_Params.jsonDecode(t255.actionParams)
			end

			return v1956
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

		function t256.new(_: {[any]: any}?) -- line: 14793
			-- upvalues: t256 (copy)
			return (setmetatable({}, t256))
		end
		function t256.encode(_) -- line: 14799
			local buf = buffer.create(0)
			local buf66 = buffer.create(0)

			buffer.copy(buf66, 0, buf, 0, 0)

			return buf66
		end
		function t256.decode(p194: buffer) -- line: 14808
			-- upvalues: t256 (copy), proto (copy)
			local v1962 = t256.new()
			local n127 = 0

			while n127 < buffer.len(p194) do
				local v1964, v1965

				v1964, v1965, n127 = proto.readTag(p194, n127)

				if v1965 == proto.wireTypes.varint then
					local v1966

					v1966, n127 = proto.readVarInt(p194, n127)
				elseif v1965 == proto.wireTypes.lengthDelimited then
					local v1967, v1968 = proto.readVarInt(p194, n127)

					n127 = v1968 + v1967
				elseif v1965 == proto.wireTypes.i32 then
					local v1969

					v1969, n127 = proto.readFixed32(p194, n127)
				elseif v1965 == proto.wireTypes.i64 then
					local v1970

					v1970, n127 = proto.readFixed64(p194, n127)
				else
					error("Unsupported wire type: " .. v1965)
				end
			end

			return v1962
		end
		function t256.jsonEncode(_) -- line: 14846
			return {}
		end
		function t256.jsonDecode(_: {[any]: any}) -- line: 14852
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

		function t259.new(t260: {[any]: any}?) -- line: 14874
			-- upvalues: t1 (copy), t259 (copy)
			return (setmetatable({
				action_type = if t260 ~= nil and t260.action_type ~= nil then t260.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t260 ~= nil and t260.action_params ~= nil then t260.action_params else nil
			}, t259))
		end
		function t259.encode(p196) -- line: 14883
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n128 = 0

			if p196.action_type ~= nil and (p196.action_type ~= nil and p196.action_type ~= 0 or p196.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1977, v1978 = proto.writeTag(buf, n128, 1, proto.wireTypes.varint)

				buf, n128 = proto.writeVarInt(v1977, v1978, t1.ActionType.toNumber(p196.action_type))
			end

			if p196.action_params ~= nil then
				local v1979 = p196.action_params:encode()
				local v1980, v1981 = proto.writeTag(buf, n128, 2, proto.wireTypes.lengthDelimited)

				buf, n128 = proto.writeBuffer(v1980, v1981, v1979, buffer.len(v1979))
			end

			local buf67 = buffer.create(n128)

			buffer.copy(buf67, 0, buf, 0, n128)

			return buf67
		end
		function t259.decode(p197: buffer) -- line: 14909
			-- upvalues: t259 (copy), proto (copy), t1 (copy)
			local v1984 = t259.new()
			local n129 = 0

			while n129 < buffer.len(p197) do
				local v1986, v1987

				v1986, v1987, n129 = proto.readTag(p197, n129)

				if v1987 == proto.wireTypes.varint then
					if v1986 == 1 then
						local v1988

						v1988, n129 = proto.readVarIntI32(p197, n129)
						v1984.action_type = t1.ActionType.fromNumber(v1988) or v1988
					else
						local v1989

						v1989, n129 = proto.readVarInt(p197, n129)
					end
				elseif v1987 == proto.wireTypes.lengthDelimited then
					if v1986 == 2 then
						local v1990

						v1990, n129 = proto.readBuffer(p197, n129)
						v1984.action_params = t1.RefreshFromApiAction_Params.decode(v1990)
					else
						local v1991, v1992 = proto.readVarInt(p197, n129)

						n129 = v1992 + v1991
					end
				elseif v1987 == proto.wireTypes.i32 then
					local v1993

					v1993, n129 = proto.readFixed32(p197, n129)
				elseif v1987 == proto.wireTypes.i64 then
					local v1994

					v1994, n129 = proto.readFixed64(p197, n129)
				else
					error("Unsupported wire type: " .. v1987)
				end
			end

			return v1984
		end
		function t259.jsonEncode(p198) -- line: 14957
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
		function t259.jsonDecode(t262: {[any]: any}) -- line: 14979
			-- upvalues: t259 (copy), t1 (copy)
			local v1998 = t259.new()

			if t262.action_type ~= nil then
				v1998.action_type = if typeof(t262.action_type) ~= "number" then t1.ActionType.fromName(t262.action_type) or t262.action_type else t1.ActionType.fromNumber(t262.action_type) or t262.action_type
			end

			if t262.actionType ~= nil then
				v1998.action_type = if typeof(t262.actionType) ~= "number" then t1.ActionType.fromName(t262.actionType) or t262.actionType else t1.ActionType.fromNumber(t262.actionType) or t262.actionType
			end

			if t262.action_params ~= nil then
				v1998.action_params = t1.RefreshFromApiAction_Params.jsonDecode(t262.action_params)
			end

			if t262.actionParams ~= nil then
				v1998.action_params = t1.RefreshFromApiAction_Params.jsonDecode(t262.actionParams)
			end

			return v1998
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

		function t263.new(t264: {[any]: any}?) -- line: 15019
			-- upvalues: t263 (copy)
			return (setmetatable({
				surface_key = if t264 ~= nil and t264.surface_key ~= nil then t264.surface_key else nil,
				config_key = if t264 ~= nil and t264.config_key ~= nil then t264.config_key else nil
			}, t263))
		end
		function t263.encode(p199) -- line: 15028
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n130 = 0

			if p199.surface_key ~= nil then
				local v2003 = p199.surface_key:encode()
				local v2004, v2005 = proto.writeTag(buf, n130, 1, proto.wireTypes.lengthDelimited)

				buf, n130 = proto.writeBuffer(v2004, v2005, v2003, buffer.len(v2003))
			end

			if p199.config_key ~= nil then
				local v2006 = p199.config_key:encode()
				local v2007, v2008 = proto.writeTag(buf, n130, 2, proto.wireTypes.lengthDelimited)

				buf, n130 = proto.writeBuffer(v2007, v2008, v2006, buffer.len(v2006))
			end

			local buf68 = buffer.create(n130)

			buffer.copy(buf68, 0, buf, 0, n130)

			return buf68
		end
		function t263.decode(p200: buffer) -- line: 15049
			-- upvalues: t263 (copy), proto (copy), prop_types (copy)
			local v2011 = t263.new()
			local n131 = 0

			while n131 < buffer.len(p200) do
				local v2013, v2014

				v2013, v2014, n131 = proto.readTag(p200, n131)

				if v2014 == proto.wireTypes.varint then
					local v2015

					v2015, n131 = proto.readVarInt(p200, n131)
				elseif v2014 == proto.wireTypes.lengthDelimited then
					if v2013 == 1 then
						local v2016

						v2016, n131 = proto.readBuffer(p200, n131)
						v2011.surface_key = prop_types.StringProp.decode(v2016)
					elseif v2013 == 2 then
						local v2017

						v2017, n131 = proto.readBuffer(p200, n131)
						v2011.config_key = prop_types.StringProp.decode(v2017)
					else
						local v2018, v2019 = proto.readVarInt(p200, n131)

						n131 = v2019 + v2018
					end
				elseif v2014 == proto.wireTypes.i32 then
					local v2020

					v2020, n131 = proto.readFixed32(p200, n131)
				elseif v2014 == proto.wireTypes.i64 then
					local v2021

					v2021, n131 = proto.readFixed64(p200, n131)
				else
					error("Unsupported wire type: " .. v2014)
				end
			end

			return v2011
		end
		function t263.jsonEncode(p201) -- line: 15097
			local t265 = {}

			if p201.surface_key ~= nil then
				t265.surfaceKey = p201.surface_key:jsonEncode()
			end

			if p201.config_key ~= nil then
				t265.configKey = p201.config_key:jsonEncode()
			end

			return t265
		end
		function t263.jsonDecode(t266: {[any]: any}) -- line: 15111
			-- upvalues: t263 (copy), prop_types (copy)
			local v2025 = t263.new()

			if t266.surface_key ~= nil then
				v2025.surface_key = prop_types.StringProp.jsonDecode(t266.surface_key)
			end

			if t266.surfaceKey ~= nil then
				v2025.surface_key = prop_types.StringProp.jsonDecode(t266.surfaceKey)
			end

			if t266.config_key ~= nil then
				v2025.config_key = prop_types.StringProp.jsonDecode(t266.config_key)
			end

			if t266.configKey ~= nil then
				v2025.config_key = prop_types.StringProp.jsonDecode(t266.configKey)
			end

			return v2025
		end

		t263.descriptor = {
			name = "RefreshFromApiAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.RefreshFromApiAction_Params = t263
		typeRegistry.default:register(t1.RefreshFromApiAction_Params)

		local t267 = {}

		t267.__index = t267

		function t267.new(t268: {[any]: any}?) -- line: 15148
			-- upvalues: t1 (copy), t267 (copy)
			return (setmetatable({
				action_type = if t268 ~= nil and t268.action_type ~= nil then t268.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t268 ~= nil and t268.action_params ~= nil then t268.action_params else nil
			}, t267))
		end
		function t267.encode(p202) -- line: 15159
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n132 = 0

			if p202.action_type ~= nil and (p202.action_type ~= nil and p202.action_type ~= 0 or p202.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2030, v2031 = proto.writeTag(buf, n132, 1, proto.wireTypes.varint)

				buf, n132 = proto.writeVarInt(v2030, v2031, t1.ActionType.toNumber(p202.action_type))
			end

			if p202.action_params ~= nil then
				local v2032 = p202.action_params:encode()
				local v2033, v2034 = proto.writeTag(buf, n132, 2, proto.wireTypes.lengthDelimited)

				buf, n132 = proto.writeBuffer(v2033, v2034, v2032, buffer.len(v2032))
			end

			local buf69 = buffer.create(n132)

			buffer.copy(buf69, 0, buf, 0, n132)

			return buf69
		end
		function t267.decode(p203: buffer) -- line: 15185
			-- upvalues: t267 (copy), proto (copy), t1 (copy)
			local v2037 = t267.new()
			local n133 = 0

			while n133 < buffer.len(p203) do
				local v2039, v2040

				v2039, v2040, n133 = proto.readTag(p203, n133)

				if v2040 == proto.wireTypes.varint then
					if v2039 == 1 then
						local v2041

						v2041, n133 = proto.readVarIntI32(p203, n133)
						v2037.action_type = t1.ActionType.fromNumber(v2041) or v2041
					else
						local v2042

						v2042, n133 = proto.readVarInt(p203, n133)
					end
				elseif v2040 == proto.wireTypes.lengthDelimited then
					if v2039 == 2 then
						local v2043

						v2043, n133 = proto.readBuffer(p203, n133)
						v2037.action_params = t1.RefreshOmniRecommendationFeedItemAction_Params.decode(v2043)
					else
						local v2044, v2045 = proto.readVarInt(p203, n133)

						n133 = v2045 + v2044
					end
				elseif v2040 == proto.wireTypes.i32 then
					local v2046

					v2046, n133 = proto.readFixed32(p203, n133)
				elseif v2040 == proto.wireTypes.i64 then
					local v2047

					v2047, n133 = proto.readFixed64(p203, n133)
				else
					error("Unsupported wire type: " .. v2040)
				end
			end

			return v2037
		end
		function t267.jsonEncode(p204) -- line: 15233
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
		function t267.jsonDecode(t270: {[any]: any}) -- line: 15255
			-- upvalues: t267 (copy), t1 (copy)
			local v2051 = t267.new()

			if t270.action_type ~= nil then
				v2051.action_type = if typeof(t270.action_type) ~= "number" then t1.ActionType.fromName(t270.action_type) or t270.action_type else t1.ActionType.fromNumber(t270.action_type) or t270.action_type
			end

			if t270.actionType ~= nil then
				v2051.action_type = if typeof(t270.actionType) ~= "number" then t1.ActionType.fromName(t270.actionType) or t270.actionType else t1.ActionType.fromNumber(t270.actionType) or t270.actionType
			end

			if t270.action_params ~= nil then
				v2051.action_params = t1.RefreshOmniRecommendationFeedItemAction_Params.jsonDecode(t270.action_params)
			end

			if t270.actionParams ~= nil then
				v2051.action_params = t1.RefreshOmniRecommendationFeedItemAction_Params.jsonDecode(t270.actionParams)
			end

			return v2051
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

		function t271.new(t272: {[any]: any}?) -- line: 15297
			-- upvalues: t271 (copy)
			return (setmetatable({
				topic_id = if t272 ~= nil and t272.topic_id ~= nil then t272.topic_id else nil,
				selected_option = if t272 ~= nil and t272.selected_option ~= nil then t272.selected_option else nil,
				request_intent = if t272 ~= nil and t272.request_intent ~= nil then t272.request_intent else nil,
				feed_item_key = if t272 ~= nil and t272.feed_item_key ~= nil then t272.feed_item_key else nil
			}, t271))
		end
		function t271.encode(p205) -- line: 15308
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n134 = 0

			if p205.topic_id ~= nil then
				local v2056 = p205.topic_id:encode()
				local v2057, v2058 = proto.writeTag(buf, n134, 1, proto.wireTypes.lengthDelimited)

				buf, n134 = proto.writeBuffer(v2057, v2058, v2056, buffer.len(v2056))
			end

			if p205.selected_option ~= nil then
				local v2059 = p205.selected_option:encode()
				local v2060, v2061 = proto.writeTag(buf, n134, 2, proto.wireTypes.lengthDelimited)

				buf, n134 = proto.writeBuffer(v2060, v2061, v2059, buffer.len(v2059))
			end

			if p205.request_intent ~= nil then
				local v2062 = p205.request_intent:encode()
				local v2063, v2064 = proto.writeTag(buf, n134, 3, proto.wireTypes.lengthDelimited)

				buf, n134 = proto.writeBuffer(v2063, v2064, v2062, buffer.len(v2062))
			end

			if p205.feed_item_key ~= nil then
				local v2065 = p205.feed_item_key:encode()
				local v2066, v2067 = proto.writeTag(buf, n134, 4, proto.wireTypes.lengthDelimited)

				buf, n134 = proto.writeBuffer(v2066, v2067, v2065, buffer.len(v2065))
			end

			local buf70 = buffer.create(n134)

			buffer.copy(buf70, 0, buf, 0, n134)

			return buf70
		end
		function t271.decode(p206: buffer) -- line: 15343
			-- upvalues: t271 (copy), proto (copy), prop_types (copy)
			local v2070 = t271.new()
			local n135 = 0

			while n135 < buffer.len(p206) do
				local v2072, v2073

				v2072, v2073, n135 = proto.readTag(p206, n135)

				if v2073 == proto.wireTypes.varint then
					local v2074

					v2074, n135 = proto.readVarInt(p206, n135)
				elseif v2073 == proto.wireTypes.lengthDelimited then
					if v2072 == 1 then
						local v2075

						v2075, n135 = proto.readBuffer(p206, n135)
						v2070.topic_id = prop_types.StringProp.decode(v2075)
					elseif v2072 == 2 then
						local v2076

						v2076, n135 = proto.readBuffer(p206, n135)
						v2070.selected_option = prop_types.StringProp.decode(v2076)
					elseif v2072 == 3 then
						local v2077

						v2077, n135 = proto.readBuffer(p206, n135)
						v2070.request_intent = prop_types.StringProp.decode(v2077)
					elseif v2072 == 4 then
						local v2078

						v2078, n135 = proto.readBuffer(p206, n135)
						v2070.feed_item_key = prop_types.StringProp.decode(v2078)
					else
						local v2079, v2080 = proto.readVarInt(p206, n135)

						n135 = v2080 + v2079
					end
				elseif v2073 == proto.wireTypes.i32 then
					local v2081

					v2081, n135 = proto.readFixed32(p206, n135)
				elseif v2073 == proto.wireTypes.i64 then
					local v2082

					v2082, n135 = proto.readFixed64(p206, n135)
				else
					error("Unsupported wire type: " .. v2073)
				end
			end

			return v2070
		end
		function t271.jsonEncode(p207) -- line: 15403
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
		function t271.jsonDecode(t274: {[any]: any}) -- line: 15427
			-- upvalues: t271 (copy), prop_types (copy)
			local v2086 = t271.new()

			if t274.topic_id ~= nil then
				v2086.topic_id = prop_types.StringProp.jsonDecode(t274.topic_id)
			end

			if t274.topicId ~= nil then
				v2086.topic_id = prop_types.StringProp.jsonDecode(t274.topicId)
			end

			if t274.selected_option ~= nil then
				v2086.selected_option = prop_types.StringProp.jsonDecode(t274.selected_option)
			end

			if t274.selectedOption ~= nil then
				v2086.selected_option = prop_types.StringProp.jsonDecode(t274.selectedOption)
			end

			if t274.request_intent ~= nil then
				v2086.request_intent = prop_types.StringProp.jsonDecode(t274.request_intent)
			end

			if t274.requestIntent ~= nil then
				v2086.request_intent = prop_types.StringProp.jsonDecode(t274.requestIntent)
			end

			if t274.feed_item_key ~= nil then
				v2086.feed_item_key = prop_types.StringProp.jsonDecode(t274.feed_item_key)
			end

			if t274.feedItemKey ~= nil then
				v2086.feed_item_key = prop_types.StringProp.jsonDecode(t274.feedItemKey)
			end

			return v2086
		end

		t271.descriptor = {
			name = "RefreshOmniRecommendationFeedItemAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.RefreshOmniRecommendationFeedItemAction_Params = t271
		typeRegistry.default:register(t1.RefreshOmniRecommendationFeedItemAction_Params)

		local t275 = {}

		t275.__index = t275

		function t275.new(t276: {[any]: any}?) -- line: 15487
			-- upvalues: t1 (copy), t275 (copy)
			return (setmetatable({
				action_type = if t276 ~= nil and t276.action_type ~= nil then t276.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t276 ~= nil and t276.action_params ~= nil then t276.action_params else nil
			}, t275))
		end
		function t275.encode(p208) -- line: 15496
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n136 = 0

			if p208.action_type ~= nil and (p208.action_type ~= nil and p208.action_type ~= 0 or p208.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2091, v2092 = proto.writeTag(buf, n136, 1, proto.wireTypes.varint)

				buf, n136 = proto.writeVarInt(v2091, v2092, t1.ActionType.toNumber(p208.action_type))
			end

			if p208.action_params ~= nil then
				local v2093 = p208.action_params:encode()
				local v2094, v2095 = proto.writeTag(buf, n136, 2, proto.wireTypes.lengthDelimited)

				buf, n136 = proto.writeBuffer(v2094, v2095, v2093, buffer.len(v2093))
			end

			local buf71 = buffer.create(n136)

			buffer.copy(buf71, 0, buf, 0, n136)

			return buf71
		end
		function t275.decode(p209: buffer) -- line: 15522
			-- upvalues: t275 (copy), proto (copy), t1 (copy)
			local v2098 = t275.new()
			local n137 = 0

			while n137 < buffer.len(p209) do
				local v2100, v2101

				v2100, v2101, n137 = proto.readTag(p209, n137)

				if v2101 == proto.wireTypes.varint then
					if v2100 == 1 then
						local v2102

						v2102, n137 = proto.readVarIntI32(p209, n137)
						v2098.action_type = t1.ActionType.fromNumber(v2102) or v2102
					else
						local v2103

						v2103, n137 = proto.readVarInt(p209, n137)
					end
				elseif v2101 == proto.wireTypes.lengthDelimited then
					if v2100 == 2 then
						local v2104

						v2104, n137 = proto.readBuffer(p209, n137)
						v2098.action_params = t1.RsvpToEventAction_Params.decode(v2104)
					else
						local v2105, v2106 = proto.readVarInt(p209, n137)

						n137 = v2106 + v2105
					end
				elseif v2101 == proto.wireTypes.i32 then
					local v2107

					v2107, n137 = proto.readFixed32(p209, n137)
				elseif v2101 == proto.wireTypes.i64 then
					local v2108

					v2108, n137 = proto.readFixed64(p209, n137)
				else
					error("Unsupported wire type: " .. v2101)
				end
			end

			return v2098
		end
		function t275.jsonEncode(p210) -- line: 15570
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
		function t275.jsonDecode(t278: {[any]: any}) -- line: 15592
			-- upvalues: t275 (copy), t1 (copy)
			local v2112 = t275.new()

			if t278.action_type ~= nil then
				v2112.action_type = if typeof(t278.action_type) ~= "number" then t1.ActionType.fromName(t278.action_type) or t278.action_type else t1.ActionType.fromNumber(t278.action_type) or t278.action_type
			end

			if t278.actionType ~= nil then
				v2112.action_type = if typeof(t278.actionType) ~= "number" then t1.ActionType.fromName(t278.actionType) or t278.actionType else t1.ActionType.fromNumber(t278.actionType) or t278.actionType
			end

			if t278.action_params ~= nil then
				v2112.action_params = t1.RsvpToEventAction_Params.jsonDecode(t278.action_params)
			end

			if t278.actionParams ~= nil then
				v2112.action_params = t1.RsvpToEventAction_Params.jsonDecode(t278.actionParams)
			end

			return v2112
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

		function t279.new(t280: {[any]: any}?) -- line: 15632
			-- upvalues: t279 (copy)
			return (setmetatable({
				event_id = if t280 ~= nil and t280.event_id ~= nil then t280.event_id else nil,
				user_rsvp = if t280 ~= nil and t280.user_rsvp ~= nil then t280.user_rsvp else nil,
				notifications_modal_identifier = if t280 ~= nil and t280.notifications_modal_identifier ~= nil then t280.notifications_modal_identifier else nil
			}, t279))
		end
		function t279.encode(p211) -- line: 15642
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n138 = 0

			if p211.event_id ~= nil then
				local v2117 = p211.event_id:encode()
				local v2118, v2119 = proto.writeTag(buf, n138, 1, proto.wireTypes.lengthDelimited)

				buf, n138 = proto.writeBuffer(v2118, v2119, v2117, buffer.len(v2117))
			end

			if p211.user_rsvp ~= nil then
				local v2120 = p211.user_rsvp:encode()
				local v2121, v2122 = proto.writeTag(buf, n138, 2, proto.wireTypes.lengthDelimited)

				buf, n138 = proto.writeBuffer(v2121, v2122, v2120, buffer.len(v2120))
			end

			if p211.notifications_modal_identifier ~= nil then
				local v2123 = p211.notifications_modal_identifier:encode()
				local v2124, v2125 = proto.writeTag(buf, n138, 3, proto.wireTypes.lengthDelimited)

				buf, n138 = proto.writeBuffer(v2124, v2125, v2123, buffer.len(v2123))
			end

			local buf72 = buffer.create(n138)

			buffer.copy(buf72, 0, buf, 0, n138)

			return buf72
		end
		function t279.decode(p212: buffer) -- line: 15669
			-- upvalues: t279 (copy), proto (copy), prop_types (copy)
			local v2128 = t279.new()
			local n139 = 0

			while n139 < buffer.len(p212) do
				local v2130, v2131

				v2130, v2131, n139 = proto.readTag(p212, n139)

				if v2131 == proto.wireTypes.varint then
					local v2132

					v2132, n139 = proto.readVarInt(p212, n139)
				elseif v2131 == proto.wireTypes.lengthDelimited then
					if v2130 == 1 then
						local v2133

						v2133, n139 = proto.readBuffer(p212, n139)
						v2128.event_id = prop_types.StringProp.decode(v2133)
					elseif v2130 == 2 then
						local v2134

						v2134, n139 = proto.readBuffer(p212, n139)
						v2128.user_rsvp = prop_types.BoolProp.decode(v2134)
					elseif v2130 == 3 then
						local v2135

						v2135, n139 = proto.readBuffer(p212, n139)
						v2128.notifications_modal_identifier = prop_types.StringProp.decode(v2135)
					else
						local v2136, v2137 = proto.readVarInt(p212, n139)

						n139 = v2137 + v2136
					end
				elseif v2131 == proto.wireTypes.i32 then
					local v2138

					v2138, n139 = proto.readFixed32(p212, n139)
				elseif v2131 == proto.wireTypes.i64 then
					local v2139

					v2139, n139 = proto.readFixed64(p212, n139)
				else
					error("Unsupported wire type: " .. v2131)
				end
			end

			return v2128
		end
		function t279.jsonEncode(p213) -- line: 15723
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
		function t279.jsonDecode(t282: {[any]: any}) -- line: 15741
			-- upvalues: t279 (copy), prop_types (copy)
			local v2143 = t279.new()

			if t282.event_id ~= nil then
				v2143.event_id = prop_types.StringProp.jsonDecode(t282.event_id)
			end

			if t282.eventId ~= nil then
				v2143.event_id = prop_types.StringProp.jsonDecode(t282.eventId)
			end

			if t282.user_rsvp ~= nil then
				v2143.user_rsvp = prop_types.BoolProp.jsonDecode(t282.user_rsvp)
			end

			if t282.userRsvp ~= nil then
				v2143.user_rsvp = prop_types.BoolProp.jsonDecode(t282.userRsvp)
			end

			if t282.notifications_modal_identifier ~= nil then
				v2143.notifications_modal_identifier = prop_types.StringProp.jsonDecode(t282.notifications_modal_identifier)
			end

			if t282.notificationsModalIdentifier ~= nil then
				v2143.notifications_modal_identifier = prop_types.StringProp.jsonDecode(t282.notificationsModalIdentifier)
			end

			return v2143
		end

		t279.descriptor = {
			name = "RsvpToEventAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.RsvpToEventAction_Params = t279
		typeRegistry.default:register(t1.RsvpToEventAction_Params)

		local t283 = {}

		t283.__index = t283

		function t283.new(t284: {[any]: any}?) -- line: 15791
			-- upvalues: t1 (copy), t283 (copy)
			return (setmetatable({
				action_type = if t284 ~= nil and t284.action_type ~= nil then t284.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t284 ~= nil and t284.action_params ~= nil then t284.action_params else nil
			}, t283))
		end
		function t283.encode(p214) -- line: 15800
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n140 = 0

			if p214.action_type ~= nil and (p214.action_type ~= nil and p214.action_type ~= 0 or p214.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2148, v2149 = proto.writeTag(buf, n140, 1, proto.wireTypes.varint)

				buf, n140 = proto.writeVarInt(v2148, v2149, t1.ActionType.toNumber(p214.action_type))
			end

			if p214.action_params ~= nil then
				local v2150 = p214.action_params:encode()
				local v2151, v2152 = proto.writeTag(buf, n140, 2, proto.wireTypes.lengthDelimited)

				buf, n140 = proto.writeBuffer(v2151, v2152, v2150, buffer.len(v2150))
			end

			local buf73 = buffer.create(n140)

			buffer.copy(buf73, 0, buf, 0, n140)

			return buf73
		end
		function t283.decode(p215: buffer) -- line: 15826
			-- upvalues: t283 (copy), proto (copy), t1 (copy)
			local v2155 = t283.new()
			local n141 = 0

			while n141 < buffer.len(p215) do
				local v2157, v2158

				v2157, v2158, n141 = proto.readTag(p215, n141)

				if v2158 == proto.wireTypes.varint then
					if v2157 == 1 then
						local v2159

						v2159, n141 = proto.readVarIntI32(p215, n141)
						v2155.action_type = t1.ActionType.fromNumber(v2159) or v2159
					else
						local v2160

						v2160, n141 = proto.readVarInt(p215, n141)
					end
				elseif v2158 == proto.wireTypes.lengthDelimited then
					if v2157 == 2 then
						local v2161

						v2161, n141 = proto.readBuffer(p215, n141)
						v2155.action_params = t1.OpenEventDetailsAction_Params.decode(v2161)
					else
						local v2162, v2163 = proto.readVarInt(p215, n141)

						n141 = v2163 + v2162
					end
				elseif v2158 == proto.wireTypes.i32 then
					local v2164

					v2164, n141 = proto.readFixed32(p215, n141)
				elseif v2158 == proto.wireTypes.i64 then
					local v2165

					v2165, n141 = proto.readFixed64(p215, n141)
				else
					error("Unsupported wire type: " .. v2158)
				end
			end

			return v2155
		end
		function t283.jsonEncode(p216) -- line: 15874
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
		function t283.jsonDecode(t286: {[any]: any}) -- line: 15896
			-- upvalues: t283 (copy), t1 (copy)
			local v2169 = t283.new()

			if t286.action_type ~= nil then
				v2169.action_type = if typeof(t286.action_type) ~= "number" then t1.ActionType.fromName(t286.action_type) or t286.action_type else t1.ActionType.fromNumber(t286.action_type) or t286.action_type
			end

			if t286.actionType ~= nil then
				v2169.action_type = if typeof(t286.actionType) ~= "number" then t1.ActionType.fromName(t286.actionType) or t286.actionType else t1.ActionType.fromNumber(t286.actionType) or t286.actionType
			end

			if t286.action_params ~= nil then
				v2169.action_params = t1.OpenEventDetailsAction_Params.jsonDecode(t286.action_params)
			end

			if t286.actionParams ~= nil then
				v2169.action_params = t1.OpenEventDetailsAction_Params.jsonDecode(t286.actionParams)
			end

			return v2169
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

		function t287.new(t288: {[any]: any}?) -- line: 15936
			-- upvalues: t287 (copy)
			return (setmetatable({
				event_id = if t288 ~= nil and t288.event_id ~= nil then t288.event_id else nil
			}, t287))
		end
		function t287.encode(p217) -- line: 15944
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n142 = 0

			if p217.event_id ~= nil then
				local v2174 = p217.event_id:encode()
				local v2175, v2176 = proto.writeTag(buf, n142, 1, proto.wireTypes.lengthDelimited)

				buf, n142 = proto.writeBuffer(v2175, v2176, v2174, buffer.len(v2174))
			end

			local buf74 = buffer.create(n142)

			buffer.copy(buf74, 0, buf, 0, n142)

			return buf74
		end
		function t287.decode(p218: buffer) -- line: 15959
			-- upvalues: t287 (copy), proto (copy), prop_types (copy)
			local v2179 = t287.new()
			local n143 = 0

			while n143 < buffer.len(p218) do
				local v2181, v2182

				v2181, v2182, n143 = proto.readTag(p218, n143)

				if v2182 == proto.wireTypes.varint then
					local v2183

					v2183, n143 = proto.readVarInt(p218, n143)
				elseif v2182 == proto.wireTypes.lengthDelimited then
					if v2181 == 1 then
						local v2184

						v2184, n143 = proto.readBuffer(p218, n143)
						v2179.event_id = prop_types.StringProp.decode(v2184)
					else
						local v2185, v2186 = proto.readVarInt(p218, n143)

						n143 = v2186 + v2185
					end
				elseif v2182 == proto.wireTypes.i32 then
					local v2187

					v2187, n143 = proto.readFixed32(p218, n143)
				elseif v2182 == proto.wireTypes.i64 then
					local v2188

					v2188, n143 = proto.readFixed64(p218, n143)
				else
					error("Unsupported wire type: " .. v2182)
				end
			end

			return v2179
		end
		function t287.jsonEncode(p219) -- line: 16002
			local t289 = {}

			if p219.event_id ~= nil then
				t289.eventId = p219.event_id:jsonEncode()
			end

			return t289
		end
		function t287.jsonDecode(t290: {[any]: any}) -- line: 16012
			-- upvalues: t287 (copy), prop_types (copy)
			local v2192 = t287.new()

			if t290.event_id ~= nil then
				v2192.event_id = prop_types.StringProp.jsonDecode(t290.event_id)
			end

			if t290.eventId ~= nil then
				v2192.event_id = prop_types.StringProp.jsonDecode(t290.eventId)
			end

			return v2192
		end

		t287.descriptor = {
			name = "OpenEventDetailsAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenEventDetailsAction_Params = t287
		typeRegistry.default:register(t1.OpenEventDetailsAction_Params)

		local t291 = {}

		t291.__index = t291

		function t291.new(t292: {[any]: any}?) -- line: 16040
			-- upvalues: t1 (copy), t291 (copy)
			return (setmetatable({
				action_type = if t292 ~= nil and t292.action_type ~= nil then t292.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t292 ~= nil and t292.action_params ~= nil then t292.action_params else nil
			}, t291))
		end
		function t291.encode(p220) -- line: 16049
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n144 = 0

			if p220.action_type ~= nil and (p220.action_type ~= nil and p220.action_type ~= 0 or p220.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2197, v2198 = proto.writeTag(buf, n144, 1, proto.wireTypes.varint)

				buf, n144 = proto.writeVarInt(v2197, v2198, t1.ActionType.toNumber(p220.action_type))
			end

			if p220.action_params ~= nil then
				local v2199 = p220.action_params:encode()
				local v2200, v2201 = proto.writeTag(buf, n144, 2, proto.wireTypes.lengthDelimited)

				buf, n144 = proto.writeBuffer(v2200, v2201, v2199, buffer.len(v2199))
			end

			local buf75 = buffer.create(n144)

			buffer.copy(buf75, 0, buf, 0, n144)

			return buf75
		end
		function t291.decode(p221: buffer) -- line: 16075
			-- upvalues: t291 (copy), proto (copy), t1 (copy)
			local v2204 = t291.new()
			local n145 = 0

			while n145 < buffer.len(p221) do
				local v2206, v2207

				v2206, v2207, n145 = proto.readTag(p221, n145)

				if v2207 == proto.wireTypes.varint then
					if v2206 == 1 then
						local v2208

						v2208, n145 = proto.readVarIntI32(p221, n145)
						v2204.action_type = t1.ActionType.fromNumber(v2208) or v2208
					else
						local v2209

						v2209, n145 = proto.readVarInt(p221, n145)
					end
				elseif v2207 == proto.wireTypes.lengthDelimited then
					if v2206 == 2 then
						local v2210

						v2210, n145 = proto.readBuffer(p221, n145)
						v2204.action_params = t1.OpenBadgesSeeAllAction_Params.decode(v2210)
					else
						local v2211, v2212 = proto.readVarInt(p221, n145)

						n145 = v2212 + v2211
					end
				elseif v2207 == proto.wireTypes.i32 then
					local v2213

					v2213, n145 = proto.readFixed32(p221, n145)
				elseif v2207 == proto.wireTypes.i64 then
					local v2214

					v2214, n145 = proto.readFixed64(p221, n145)
				else
					error("Unsupported wire type: " .. v2207)
				end
			end

			return v2204
		end
		function t291.jsonEncode(p222) -- line: 16123
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
		function t291.jsonDecode(t294: {[any]: any}) -- line: 16145
			-- upvalues: t291 (copy), t1 (copy)
			local v2218 = t291.new()

			if t294.action_type ~= nil then
				v2218.action_type = if typeof(t294.action_type) ~= "number" then t1.ActionType.fromName(t294.action_type) or t294.action_type else t1.ActionType.fromNumber(t294.action_type) or t294.action_type
			end

			if t294.actionType ~= nil then
				v2218.action_type = if typeof(t294.actionType) ~= "number" then t1.ActionType.fromName(t294.actionType) or t294.actionType else t1.ActionType.fromNumber(t294.actionType) or t294.actionType
			end

			if t294.action_params ~= nil then
				v2218.action_params = t1.OpenBadgesSeeAllAction_Params.jsonDecode(t294.action_params)
			end

			if t294.actionParams ~= nil then
				v2218.action_params = t1.OpenBadgesSeeAllAction_Params.jsonDecode(t294.actionParams)
			end

			return v2218
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

		function t295.new(t296: {[any]: any}?) -- line: 16185
			-- upvalues: t295 (copy)
			return (setmetatable({
				universe_id = if t296 ~= nil and t296.universe_id ~= nil then t296.universe_id else nil
			}, t295))
		end
		function t295.encode(p223) -- line: 16193
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n146 = 0

			if p223.universe_id ~= nil then
				local v2223 = p223.universe_id:encode()
				local v2224, v2225 = proto.writeTag(buf, n146, 1, proto.wireTypes.lengthDelimited)

				buf, n146 = proto.writeBuffer(v2224, v2225, v2223, buffer.len(v2223))
			end

			local buf76 = buffer.create(n146)

			buffer.copy(buf76, 0, buf, 0, n146)

			return buf76
		end
		function t295.decode(p224: buffer) -- line: 16208
			-- upvalues: t295 (copy), proto (copy), prop_types (copy)
			local v2228 = t295.new()
			local n147 = 0

			while n147 < buffer.len(p224) do
				local v2230, v2231

				v2230, v2231, n147 = proto.readTag(p224, n147)

				if v2231 == proto.wireTypes.varint then
					local v2232

					v2232, n147 = proto.readVarInt(p224, n147)
				elseif v2231 == proto.wireTypes.lengthDelimited then
					if v2230 == 1 then
						local v2233

						v2233, n147 = proto.readBuffer(p224, n147)
						v2228.universe_id = prop_types.StringProp.decode(v2233)
					else
						local v2234, v2235 = proto.readVarInt(p224, n147)

						n147 = v2235 + v2234
					end
				elseif v2231 == proto.wireTypes.i32 then
					local v2236

					v2236, n147 = proto.readFixed32(p224, n147)
				elseif v2231 == proto.wireTypes.i64 then
					local v2237

					v2237, n147 = proto.readFixed64(p224, n147)
				else
					error("Unsupported wire type: " .. v2231)
				end
			end

			return v2228
		end
		function t295.jsonEncode(p225) -- line: 16251
			local t297 = {}

			if p225.universe_id ~= nil then
				t297.universeId = p225.universe_id:jsonEncode()
			end

			return t297
		end
		function t295.jsonDecode(t298: {[any]: any}) -- line: 16261
			-- upvalues: t295 (copy), prop_types (copy)
			local v2241 = t295.new()

			if t298.universe_id ~= nil then
				v2241.universe_id = prop_types.StringProp.jsonDecode(t298.universe_id)
			end

			if t298.universeId ~= nil then
				v2241.universe_id = prop_types.StringProp.jsonDecode(t298.universeId)
			end

			return v2241
		end

		t295.descriptor = {
			name = "OpenBadgesSeeAllAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenBadgesSeeAllAction_Params = t295
		typeRegistry.default:register(t1.OpenBadgesSeeAllAction_Params)

		local t299 = {}

		t299.__index = t299

		function t299.new(t300: {[any]: any}?) -- line: 16290
			-- upvalues: t1 (copy), t299 (copy)
			return (setmetatable({
				action_type = if t300 ~= nil and t300.action_type ~= nil then t300.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t300 ~= nil and t300.action_params ~= nil then t300.action_params else nil
			}, t299))
		end
		function t299.encode(p226) -- line: 16301
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n148 = 0

			if p226.action_type ~= nil and (p226.action_type ~= nil and p226.action_type ~= 0 or p226.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2246, v2247 = proto.writeTag(buf, n148, 1, proto.wireTypes.varint)

				buf, n148 = proto.writeVarInt(v2246, v2247, t1.ActionType.toNumber(p226.action_type))
			end

			if p226.action_params ~= nil then
				local v2248 = p226.action_params:encode()
				local v2249, v2250 = proto.writeTag(buf, n148, 2, proto.wireTypes.lengthDelimited)

				buf, n148 = proto.writeBuffer(v2249, v2250, v2248, buffer.len(v2248))
			end

			local buf77 = buffer.create(n148)

			buffer.copy(buf77, 0, buf, 0, n148)

			return buf77
		end
		function t299.decode(p227: buffer) -- line: 16327
			-- upvalues: t299 (copy), proto (copy), t1 (copy)
			local v2253 = t299.new()
			local n149 = 0

			while n149 < buffer.len(p227) do
				local v2255, v2256

				v2255, v2256, n149 = proto.readTag(p227, n149)

				if v2256 == proto.wireTypes.varint then
					if v2255 == 1 then
						local v2257

						v2257, n149 = proto.readVarIntI32(p227, n149)
						v2253.action_type = t1.ActionType.fromNumber(v2257) or v2257
					else
						local v2258

						v2258, n149 = proto.readVarInt(p227, n149)
					end
				elseif v2256 == proto.wireTypes.lengthDelimited then
					if v2255 == 2 then
						local v2259

						v2259, n149 = proto.readBuffer(p227, n149)
						v2253.action_params = t1.OpenExperienceStoreSeeAllAction_Params.decode(v2259)
					else
						local v2260, v2261 = proto.readVarInt(p227, n149)

						n149 = v2261 + v2260
					end
				elseif v2256 == proto.wireTypes.i32 then
					local v2262

					v2262, n149 = proto.readFixed32(p227, n149)
				elseif v2256 == proto.wireTypes.i64 then
					local v2263

					v2263, n149 = proto.readFixed64(p227, n149)
				else
					error("Unsupported wire type: " .. v2256)
				end
			end

			return v2253
		end
		function t299.jsonEncode(p228) -- line: 16375
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
		function t299.jsonDecode(t302: {[any]: any}) -- line: 16397
			-- upvalues: t299 (copy), t1 (copy)
			local v2267 = t299.new()

			if t302.action_type ~= nil then
				v2267.action_type = if typeof(t302.action_type) ~= "number" then t1.ActionType.fromName(t302.action_type) or t302.action_type else t1.ActionType.fromNumber(t302.action_type) or t302.action_type
			end

			if t302.actionType ~= nil then
				v2267.action_type = if typeof(t302.actionType) ~= "number" then t1.ActionType.fromName(t302.actionType) or t302.actionType else t1.ActionType.fromNumber(t302.actionType) or t302.actionType
			end

			if t302.action_params ~= nil then
				v2267.action_params = t1.OpenExperienceStoreSeeAllAction_Params.jsonDecode(t302.action_params)
			end

			if t302.actionParams ~= nil then
				v2267.action_params = t1.OpenExperienceStoreSeeAllAction_Params.jsonDecode(t302.actionParams)
			end

			return v2267
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

		function t303.new(t304: {[any]: any}?) -- line: 16437
			-- upvalues: t303 (copy)
			return (setmetatable({
				universe_id = if t304 ~= nil and t304.universe_id ~= nil then t304.universe_id else nil
			}, t303))
		end
		function t303.encode(p229) -- line: 16445
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n150 = 0

			if p229.universe_id ~= nil then
				local v2272 = p229.universe_id:encode()
				local v2273, v2274 = proto.writeTag(buf, n150, 1, proto.wireTypes.lengthDelimited)

				buf, n150 = proto.writeBuffer(v2273, v2274, v2272, buffer.len(v2272))
			end

			local buf78 = buffer.create(n150)

			buffer.copy(buf78, 0, buf, 0, n150)

			return buf78
		end
		function t303.decode(p230: buffer) -- line: 16460
			-- upvalues: t303 (copy), proto (copy), prop_types (copy)
			local v2277 = t303.new()
			local n151 = 0

			while n151 < buffer.len(p230) do
				local v2279, v2280

				v2279, v2280, n151 = proto.readTag(p230, n151)

				if v2280 == proto.wireTypes.varint then
					local v2281

					v2281, n151 = proto.readVarInt(p230, n151)
				elseif v2280 == proto.wireTypes.lengthDelimited then
					if v2279 == 1 then
						local v2282

						v2282, n151 = proto.readBuffer(p230, n151)
						v2277.universe_id = prop_types.StringProp.decode(v2282)
					else
						local v2283, v2284 = proto.readVarInt(p230, n151)

						n151 = v2284 + v2283
					end
				elseif v2280 == proto.wireTypes.i32 then
					local v2285

					v2285, n151 = proto.readFixed32(p230, n151)
				elseif v2280 == proto.wireTypes.i64 then
					local v2286

					v2286, n151 = proto.readFixed64(p230, n151)
				else
					error("Unsupported wire type: " .. v2280)
				end
			end

			return v2277
		end
		function t303.jsonEncode(p231) -- line: 16503
			local t305 = {}

			if p231.universe_id ~= nil then
				t305.universeId = p231.universe_id:jsonEncode()
			end

			return t305
		end
		function t303.jsonDecode(t306: {[any]: any}) -- line: 16513
			-- upvalues: t303 (copy), prop_types (copy)
			local v2290 = t303.new()

			if t306.universe_id ~= nil then
				v2290.universe_id = prop_types.StringProp.jsonDecode(t306.universe_id)
			end

			if t306.universeId ~= nil then
				v2290.universe_id = prop_types.StringProp.jsonDecode(t306.universeId)
			end

			return v2290
		end

		t303.descriptor = {
			name = "OpenExperienceStoreSeeAllAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenExperienceStoreSeeAllAction_Params = t303
		typeRegistry.default:register(t1.OpenExperienceStoreSeeAllAction_Params)

		local t307 = {}

		t307.__index = t307

		function t307.new(t308: {[any]: any}?) -- line: 16544
			-- upvalues: t1 (copy), t307 (copy)
			return (setmetatable({
				action_type = if t308 ~= nil and t308.action_type ~= nil then t308.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t308 ~= nil and t308.action_params ~= nil then t308.action_params else nil
			}, t307))
		end
		function t307.encode(p232) -- line: 16555
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n152 = 0

			if p232.action_type ~= nil and (p232.action_type ~= nil and p232.action_type ~= 0 or p232.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2295, v2296 = proto.writeTag(buf, n152, 1, proto.wireTypes.varint)

				buf, n152 = proto.writeVarInt(v2295, v2296, t1.ActionType.toNumber(p232.action_type))
			end

			if p232.action_params ~= nil then
				local v2297 = p232.action_params:encode()
				local v2298, v2299 = proto.writeTag(buf, n152, 2, proto.wireTypes.lengthDelimited)

				buf, n152 = proto.writeBuffer(v2298, v2299, v2297, buffer.len(v2297))
			end

			local buf79 = buffer.create(n152)

			buffer.copy(buf79, 0, buf, 0, n152)

			return buf79
		end
		function t307.decode(p233: buffer) -- line: 16581
			-- upvalues: t307 (copy), proto (copy), t1 (copy)
			local v2302 = t307.new()
			local n153 = 0

			while n153 < buffer.len(p233) do
				local v2304, v2305

				v2304, v2305, n153 = proto.readTag(p233, n153)

				if v2305 == proto.wireTypes.varint then
					if v2304 == 1 then
						local v2306

						v2306, n153 = proto.readVarIntI32(p233, n153)
						v2302.action_type = t1.ActionType.fromNumber(v2306) or v2306
					else
						local v2307

						v2307, n153 = proto.readVarInt(p233, n153)
					end
				elseif v2305 == proto.wireTypes.lengthDelimited then
					if v2304 == 2 then
						local v2308

						v2308, n153 = proto.readBuffer(p233, n153)
						v2302.action_params = t1.OpenSubscriptionPurchasePageAction_Params.decode(v2308)
					else
						local v2309, v2310 = proto.readVarInt(p233, n153)

						n153 = v2310 + v2309
					end
				elseif v2305 == proto.wireTypes.i32 then
					local v2311

					v2311, n153 = proto.readFixed32(p233, n153)
				elseif v2305 == proto.wireTypes.i64 then
					local v2312

					v2312, n153 = proto.readFixed64(p233, n153)
				else
					error("Unsupported wire type: " .. v2305)
				end
			end

			return v2302
		end
		function t307.jsonEncode(p234) -- line: 16629
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
		function t307.jsonDecode(t310: {[any]: any}) -- line: 16651
			-- upvalues: t307 (copy), t1 (copy)
			local v2316 = t307.new()

			if t310.action_type ~= nil then
				v2316.action_type = if typeof(t310.action_type) ~= "number" then t1.ActionType.fromName(t310.action_type) or t310.action_type else t1.ActionType.fromNumber(t310.action_type) or t310.action_type
			end

			if t310.actionType ~= nil then
				v2316.action_type = if typeof(t310.actionType) ~= "number" then t1.ActionType.fromName(t310.actionType) or t310.actionType else t1.ActionType.fromNumber(t310.actionType) or t310.actionType
			end

			if t310.action_params ~= nil then
				v2316.action_params = t1.OpenSubscriptionPurchasePageAction_Params.jsonDecode(t310.action_params)
			end

			if t310.actionParams ~= nil then
				v2316.action_params = t1.OpenSubscriptionPurchasePageAction_Params.jsonDecode(t310.actionParams)
			end

			return v2316
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

		function t311.new(t312: {[any]: any}?) -- line: 16693
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
		function t311.encode(p235) -- line: 16713
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n154 = 0

			if p235.subscription_id ~= nil then
				local v2321 = p235.subscription_id:encode()
				local v2322, v2323 = proto.writeTag(buf, n154, 1, proto.wireTypes.lengthDelimited)

				buf, n154 = proto.writeBuffer(v2322, v2323, v2321, buffer.len(v2321))
			end

			if p235.universe_id ~= nil then
				local v2324 = p235.universe_id:encode()
				local v2325, v2326 = proto.writeTag(buf, n154, 2, proto.wireTypes.lengthDelimited)

				buf, n154 = proto.writeBuffer(v2325, v2326, v2324, buffer.len(v2324))
			end

			if p235.creator_name ~= nil then
				local v2327 = p235.creator_name:encode()
				local v2328, v2329 = proto.writeTag(buf, n154, 3, proto.wireTypes.lengthDelimited)

				buf, n154 = proto.writeBuffer(v2328, v2329, v2327, buffer.len(v2327))
			end

			if p235.creator_verified ~= nil then
				local v2330 = p235.creator_verified:encode()
				local v2331, v2332 = proto.writeTag(buf, n154, 4, proto.wireTypes.lengthDelimited)

				buf, n154 = proto.writeBuffer(v2331, v2332, v2330, buffer.len(v2330))
			end

			if p235.name ~= nil then
				local v2333 = p235.name:encode()
				local v2334, v2335 = proto.writeTag(buf, n154, 5, proto.wireTypes.lengthDelimited)

				buf, n154 = proto.writeBuffer(v2334, v2335, v2333, buffer.len(v2333))
			end

			if p235.description ~= nil then
				local v2336 = p235.description:encode()
				local v2337, v2338 = proto.writeTag(buf, n154, 6, proto.wireTypes.lengthDelimited)

				buf, n154 = proto.writeBuffer(v2337, v2338, v2336, buffer.len(v2336))
			end

			if p235.image_asset_id ~= nil then
				local v2339 = p235.image_asset_id:encode()
				local v2340, v2341 = proto.writeTag(buf, n154, 7, proto.wireTypes.lengthDelimited)

				buf, n154 = proto.writeBuffer(v2340, v2341, v2339, buffer.len(v2339))
			end

			if p235.period_type ~= nil then
				local v2342 = p235.period_type:encode()
				local v2343, v2344 = proto.writeTag(buf, n154, 8, proto.wireTypes.lengthDelimited)

				buf, n154 = proto.writeBuffer(v2343, v2344, v2342, buffer.len(v2342))
			end

			if p235.is_subscribed ~= nil then
				local v2345 = p235.is_subscribed:encode()
				local v2346, v2347 = proto.writeTag(buf, n154, 9, proto.wireTypes.lengthDelimited)

				buf, n154 = proto.writeBuffer(v2346, v2347, v2345, buffer.len(v2345))
			end

			if p235.price_display ~= nil then
				local v2348 = p235.price_display:encode()
				local v2349, v2350 = proto.writeTag(buf, n154, 10, proto.wireTypes.lengthDelimited)

				buf, n154 = proto.writeBuffer(v2349, v2350, v2348, buffer.len(v2348))
			end

			if p235.price_in_robux ~= nil then
				local v2351 = p235.price_in_robux:encode()
				local v2352, v2353 = proto.writeTag(buf, n154, 11, proto.wireTypes.lengthDelimited)

				buf, n154 = proto.writeBuffer(v2352, v2353, v2351, buffer.len(v2351))
			end

			if p235.price_tier ~= nil then
				local v2354 = p235.price_tier:encode()
				local v2355, v2356 = proto.writeTag(buf, n154, 12, proto.wireTypes.lengthDelimited)

				buf, n154 = proto.writeBuffer(v2355, v2356, v2354, buffer.len(v2354))
			end

			if p235.thumbnail_string ~= nil then
				local v2357 = p235.thumbnail_string:encode()
				local v2358, v2359 = proto.writeTag(buf, n154, 13, proto.wireTypes.lengthDelimited)

				buf, n154 = proto.writeBuffer(v2358, v2359, v2357, buffer.len(v2357))
			end

			local buf80 = buffer.create(n154)

			buffer.copy(buf80, 0, buf, 0, n154)

			return buf80
		end
		function t311.decode(p236: buffer) -- line: 16802
			-- upvalues: t311 (copy), proto (copy), prop_types (copy)
			local v2362 = t311.new()
			local n155 = 0

			while n155 < buffer.len(p236) do
				local v2364, v2365

				v2364, v2365, n155 = proto.readTag(p236, n155)

				if v2365 == proto.wireTypes.varint then
					local v2366

					v2366, n155 = proto.readVarInt(p236, n155)
				elseif v2365 == proto.wireTypes.lengthDelimited then
					if v2364 == 1 then
						local v2367

						v2367, n155 = proto.readBuffer(p236, n155)
						v2362.subscription_id = prop_types.StringProp.decode(v2367)
					elseif v2364 == 2 then
						local v2368

						v2368, n155 = proto.readBuffer(p236, n155)
						v2362.universe_id = prop_types.StringProp.decode(v2368)
					elseif v2364 == 3 then
						local v2369

						v2369, n155 = proto.readBuffer(p236, n155)
						v2362.creator_name = prop_types.StringProp.decode(v2369)
					elseif v2364 == 4 then
						local v2370

						v2370, n155 = proto.readBuffer(p236, n155)
						v2362.creator_verified = prop_types.BoolProp.decode(v2370)
					elseif v2364 == 5 then
						local v2371

						v2371, n155 = proto.readBuffer(p236, n155)
						v2362.name = prop_types.StringProp.decode(v2371)
					elseif v2364 == 6 then
						local v2372

						v2372, n155 = proto.readBuffer(p236, n155)
						v2362.description = prop_types.StringProp.decode(v2372)
					elseif v2364 == 7 then
						local v2373

						v2373, n155 = proto.readBuffer(p236, n155)
						v2362.image_asset_id = prop_types.Int64Prop.decode(v2373)
					elseif v2364 == 8 then
						local v2374

						v2374, n155 = proto.readBuffer(p236, n155)
						v2362.period_type = prop_types.StringProp.decode(v2374)
					elseif v2364 == 9 then
						local v2375

						v2375, n155 = proto.readBuffer(p236, n155)
						v2362.is_subscribed = prop_types.BoolProp.decode(v2375)
					elseif v2364 == 10 then
						local v2376

						v2376, n155 = proto.readBuffer(p236, n155)
						v2362.price_display = prop_types.StringProp.decode(v2376)
					elseif v2364 == 11 then
						local v2377

						v2377, n155 = proto.readBuffer(p236, n155)
						v2362.price_in_robux = prop_types.Int64Prop.decode(v2377)
					elseif v2364 == 12 then
						local v2378

						v2378, n155 = proto.readBuffer(p236, n155)
						v2362.price_tier = prop_types.Int64Prop.decode(v2378)
					elseif v2364 == 13 then
						local v2379

						v2379, n155 = proto.readBuffer(p236, n155)
						v2362.thumbnail_string = prop_types.StringProp.decode(v2379)
					else
						local v2380, v2381 = proto.readVarInt(p236, n155)

						n155 = v2381 + v2380
					end
				elseif v2365 == proto.wireTypes.i32 then
					local v2382

					v2382, n155 = proto.readFixed32(p236, n155)
				elseif v2365 == proto.wireTypes.i64 then
					local v2383

					v2383, n155 = proto.readFixed64(p236, n155)
				else
					error("Unsupported wire type: " .. v2365)
				end
			end

			return v2362
		end
		function t311.jsonEncode(p237) -- line: 16907
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
		function t311.jsonDecode(t314: {[any]: any}) -- line: 16967
			-- upvalues: t311 (copy), prop_types (copy)
			local v2387 = t311.new()

			if t314.subscription_id ~= nil then
				v2387.subscription_id = prop_types.StringProp.jsonDecode(t314.subscription_id)
			end

			if t314.subscriptionId ~= nil then
				v2387.subscription_id = prop_types.StringProp.jsonDecode(t314.subscriptionId)
			end

			if t314.universe_id ~= nil then
				v2387.universe_id = prop_types.StringProp.jsonDecode(t314.universe_id)
			end

			if t314.universeId ~= nil then
				v2387.universe_id = prop_types.StringProp.jsonDecode(t314.universeId)
			end

			if t314.creator_name ~= nil then
				v2387.creator_name = prop_types.StringProp.jsonDecode(t314.creator_name)
			end

			if t314.creatorName ~= nil then
				v2387.creator_name = prop_types.StringProp.jsonDecode(t314.creatorName)
			end

			if t314.creator_verified ~= nil then
				v2387.creator_verified = prop_types.BoolProp.jsonDecode(t314.creator_verified)
			end

			if t314.creatorVerified ~= nil then
				v2387.creator_verified = prop_types.BoolProp.jsonDecode(t314.creatorVerified)
			end

			if t314.name ~= nil then
				v2387.name = prop_types.StringProp.jsonDecode(t314.name)
			end

			if t314.description ~= nil then
				v2387.description = prop_types.StringProp.jsonDecode(t314.description)
			end

			if t314.image_asset_id ~= nil then
				v2387.image_asset_id = prop_types.Int64Prop.jsonDecode(t314.image_asset_id)
			end

			if t314.imageAssetId ~= nil then
				v2387.image_asset_id = prop_types.Int64Prop.jsonDecode(t314.imageAssetId)
			end

			if t314.period_type ~= nil then
				v2387.period_type = prop_types.StringProp.jsonDecode(t314.period_type)
			end

			if t314.periodType ~= nil then
				v2387.period_type = prop_types.StringProp.jsonDecode(t314.periodType)
			end

			if t314.is_subscribed ~= nil then
				v2387.is_subscribed = prop_types.BoolProp.jsonDecode(t314.is_subscribed)
			end

			if t314.isSubscribed ~= nil then
				v2387.is_subscribed = prop_types.BoolProp.jsonDecode(t314.isSubscribed)
			end

			if t314.price_display ~= nil then
				v2387.price_display = prop_types.StringProp.jsonDecode(t314.price_display)
			end

			if t314.priceDisplay ~= nil then
				v2387.price_display = prop_types.StringProp.jsonDecode(t314.priceDisplay)
			end

			if t314.price_in_robux ~= nil then
				v2387.price_in_robux = prop_types.Int64Prop.jsonDecode(t314.price_in_robux)
			end

			if t314.priceInRobux ~= nil then
				v2387.price_in_robux = prop_types.Int64Prop.jsonDecode(t314.priceInRobux)
			end

			if t314.price_tier ~= nil then
				v2387.price_tier = prop_types.Int64Prop.jsonDecode(t314.price_tier)
			end

			if t314.priceTier ~= nil then
				v2387.price_tier = prop_types.Int64Prop.jsonDecode(t314.priceTier)
			end

			if t314.thumbnail_string ~= nil then
				v2387.thumbnail_string = prop_types.StringProp.jsonDecode(t314.thumbnail_string)
			end

			if t314.thumbnailString ~= nil then
				v2387.thumbnail_string = prop_types.StringProp.jsonDecode(t314.thumbnailString)
			end

			return v2387
		end

		t311.descriptor = {
			name = "OpenSubscriptionPurchasePageAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenSubscriptionPurchasePageAction_Params = t311
		typeRegistry.default:register(t1.OpenSubscriptionPurchasePageAction_Params)

		local t315 = {}

		t315.__index = t315

		function t315.new(t316: {[any]: any}?) -- line: 17104
			-- upvalues: t1 (copy), t315 (copy)
			return (setmetatable({
				action_type = if t316 ~= nil and t316.action_type ~= nil then t316.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t316 ~= nil and t316.action_params ~= nil then t316.action_params else nil
			}, t315))
		end
		function t315.encode(p238) -- line: 17113
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n156 = 0

			if p238.action_type ~= nil and (p238.action_type ~= nil and p238.action_type ~= 0 or p238.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2392, v2393 = proto.writeTag(buf, n156, 1, proto.wireTypes.varint)

				buf, n156 = proto.writeVarInt(v2392, v2393, t1.ActionType.toNumber(p238.action_type))
			end

			if p238.action_params ~= nil then
				local v2394 = p238.action_params:encode()
				local v2395, v2396 = proto.writeTag(buf, n156, 2, proto.wireTypes.lengthDelimited)

				buf, n156 = proto.writeBuffer(v2395, v2396, v2394, buffer.len(v2394))
			end

			local buf81 = buffer.create(n156)

			buffer.copy(buf81, 0, buf, 0, n156)

			return buf81
		end
		function t315.decode(p239: buffer) -- line: 17139
			-- upvalues: t315 (copy), proto (copy), t1 (copy)
			local v2399 = t315.new()
			local n157 = 0

			while n157 < buffer.len(p239) do
				local v2401, v2402

				v2401, v2402, n157 = proto.readTag(p239, n157)

				if v2402 == proto.wireTypes.varint then
					if v2401 == 1 then
						local v2403

						v2403, n157 = proto.readVarIntI32(p239, n157)
						v2399.action_type = t1.ActionType.fromNumber(v2403) or v2403
					else
						local v2404

						v2404, n157 = proto.readVarInt(p239, n157)
					end
				elseif v2402 == proto.wireTypes.lengthDelimited then
					if v2401 == 2 then
						local v2405

						v2405, n157 = proto.readBuffer(p239, n157)
						v2399.action_params = t1.RefreshGamePassesAction_Params.decode(v2405)
					else
						local v2406, v2407 = proto.readVarInt(p239, n157)

						n157 = v2407 + v2406
					end
				elseif v2402 == proto.wireTypes.i32 then
					local v2408

					v2408, n157 = proto.readFixed32(p239, n157)
				elseif v2402 == proto.wireTypes.i64 then
					local v2409

					v2409, n157 = proto.readFixed64(p239, n157)
				else
					error("Unsupported wire type: " .. v2402)
				end
			end

			return v2399
		end
		function t315.jsonEncode(p240) -- line: 17187
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
		function t315.jsonDecode(t318: {[any]: any}) -- line: 17209
			-- upvalues: t315 (copy), t1 (copy)
			local v2413 = t315.new()

			if t318.action_type ~= nil then
				v2413.action_type = if typeof(t318.action_type) ~= "number" then t1.ActionType.fromName(t318.action_type) or t318.action_type else t1.ActionType.fromNumber(t318.action_type) or t318.action_type
			end

			if t318.actionType ~= nil then
				v2413.action_type = if typeof(t318.actionType) ~= "number" then t1.ActionType.fromName(t318.actionType) or t318.actionType else t1.ActionType.fromNumber(t318.actionType) or t318.actionType
			end

			if t318.action_params ~= nil then
				v2413.action_params = t1.RefreshGamePassesAction_Params.jsonDecode(t318.action_params)
			end

			if t318.actionParams ~= nil then
				v2413.action_params = t1.RefreshGamePassesAction_Params.jsonDecode(t318.actionParams)
			end

			return v2413
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

		function t319.new(t320: {[any]: any}?) -- line: 17249
			-- upvalues: t319 (copy)
			return (setmetatable({
				universe_id = if t320 ~= nil and t320.universe_id ~= nil then t320.universe_id else nil
			}, t319))
		end
		function t319.encode(p241) -- line: 17257
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n158 = 0

			if p241.universe_id ~= nil then
				local v2418 = p241.universe_id:encode()
				local v2419, v2420 = proto.writeTag(buf, n158, 1, proto.wireTypes.lengthDelimited)

				buf, n158 = proto.writeBuffer(v2419, v2420, v2418, buffer.len(v2418))
			end

			local buf82 = buffer.create(n158)

			buffer.copy(buf82, 0, buf, 0, n158)

			return buf82
		end
		function t319.decode(p242: buffer) -- line: 17272
			-- upvalues: t319 (copy), proto (copy), prop_types (copy)
			local v2423 = t319.new()
			local n159 = 0

			while n159 < buffer.len(p242) do
				local v2425, v2426

				v2425, v2426, n159 = proto.readTag(p242, n159)

				if v2426 == proto.wireTypes.varint then
					local v2427

					v2427, n159 = proto.readVarInt(p242, n159)
				elseif v2426 == proto.wireTypes.lengthDelimited then
					if v2425 == 1 then
						local v2428

						v2428, n159 = proto.readBuffer(p242, n159)
						v2423.universe_id = prop_types.StringProp.decode(v2428)
					else
						local v2429, v2430 = proto.readVarInt(p242, n159)

						n159 = v2430 + v2429
					end
				elseif v2426 == proto.wireTypes.i32 then
					local v2431

					v2431, n159 = proto.readFixed32(p242, n159)
				elseif v2426 == proto.wireTypes.i64 then
					local v2432

					v2432, n159 = proto.readFixed64(p242, n159)
				else
					error("Unsupported wire type: " .. v2426)
				end
			end

			return v2423
		end
		function t319.jsonEncode(p243) -- line: 17315
			local t321 = {}

			if p243.universe_id ~= nil then
				t321.universeId = p243.universe_id:jsonEncode()
			end

			return t321
		end
		function t319.jsonDecode(t322: {[any]: any}) -- line: 17325
			-- upvalues: t319 (copy), prop_types (copy)
			local v2436 = t319.new()

			if t322.universe_id ~= nil then
				v2436.universe_id = prop_types.StringProp.jsonDecode(t322.universe_id)
			end

			if t322.universeId ~= nil then
				v2436.universe_id = prop_types.StringProp.jsonDecode(t322.universeId)
			end

			return v2436
		end

		t319.descriptor = {
			name = "RefreshGamePassesAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.RefreshGamePassesAction_Params = t319
		typeRegistry.default:register(t1.RefreshGamePassesAction_Params)

		local t323 = {}

		t323.__index = t323

		function t323.new(t324: {[any]: any}?) -- line: 17354
			-- upvalues: t1 (copy), t323 (copy)
			return (setmetatable({
				action_type = if t324 ~= nil and t324.action_type ~= nil then t324.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t324 ~= nil and t324.action_params ~= nil then t324.action_params else nil
			}, t323))
		end
		function t323.encode(p244) -- line: 17363
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n160 = 0

			if p244.action_type ~= nil and (p244.action_type ~= nil and p244.action_type ~= 0 or p244.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2441, v2442 = proto.writeTag(buf, n160, 1, proto.wireTypes.varint)

				buf, n160 = proto.writeVarInt(v2441, v2442, t1.ActionType.toNumber(p244.action_type))
			end

			if p244.action_params ~= nil then
				local v2443 = p244.action_params:encode()
				local v2444, v2445 = proto.writeTag(buf, n160, 2, proto.wireTypes.lengthDelimited)

				buf, n160 = proto.writeBuffer(v2444, v2445, v2443, buffer.len(v2443))
			end

			local buf83 = buffer.create(n160)

			buffer.copy(buf83, 0, buf, 0, n160)

			return buf83
		end
		function t323.decode(p245: buffer) -- line: 17389
			-- upvalues: t323 (copy), proto (copy), t1 (copy)
			local v2448 = t323.new()
			local n161 = 0

			while n161 < buffer.len(p245) do
				local v2450, v2451

				v2450, v2451, n161 = proto.readTag(p245, n161)

				if v2451 == proto.wireTypes.varint then
					if v2450 == 1 then
						local v2452

						v2452, n161 = proto.readVarIntI32(p245, n161)
						v2448.action_type = t1.ActionType.fromNumber(v2452) or v2452
					else
						local v2453

						v2453, n161 = proto.readVarInt(p245, n161)
					end
				elseif v2451 == proto.wireTypes.lengthDelimited then
					if v2450 == 2 then
						local v2454

						v2454, n161 = proto.readBuffer(p245, n161)
						v2448.action_params = t1.RefreshPlayabilityAction_Params.decode(v2454)
					else
						local v2455, v2456 = proto.readVarInt(p245, n161)

						n161 = v2456 + v2455
					end
				elseif v2451 == proto.wireTypes.i32 then
					local v2457

					v2457, n161 = proto.readFixed32(p245, n161)
				elseif v2451 == proto.wireTypes.i64 then
					local v2458

					v2458, n161 = proto.readFixed64(p245, n161)
				else
					error("Unsupported wire type: " .. v2451)
				end
			end

			return v2448
		end
		function t323.jsonEncode(p246) -- line: 17437
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
		function t323.jsonDecode(t326: {[any]: any}) -- line: 17459
			-- upvalues: t323 (copy), t1 (copy)
			local v2462 = t323.new()

			if t326.action_type ~= nil then
				v2462.action_type = if typeof(t326.action_type) ~= "number" then t1.ActionType.fromName(t326.action_type) or t326.action_type else t1.ActionType.fromNumber(t326.action_type) or t326.action_type
			end

			if t326.actionType ~= nil then
				v2462.action_type = if typeof(t326.actionType) ~= "number" then t1.ActionType.fromName(t326.actionType) or t326.actionType else t1.ActionType.fromNumber(t326.actionType) or t326.actionType
			end

			if t326.action_params ~= nil then
				v2462.action_params = t1.RefreshPlayabilityAction_Params.jsonDecode(t326.action_params)
			end

			if t326.actionParams ~= nil then
				v2462.action_params = t1.RefreshPlayabilityAction_Params.jsonDecode(t326.actionParams)
			end

			return v2462
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

		function t327.new(t328: {[any]: any}?) -- line: 17499
			-- upvalues: t327 (copy)
			return (setmetatable({
				universe_id = if t328 ~= nil and t328.universe_id ~= nil then t328.universe_id else nil
			}, t327))
		end
		function t327.encode(p247) -- line: 17507
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n162 = 0

			if p247.universe_id ~= nil then
				local v2467 = p247.universe_id:encode()
				local v2468, v2469 = proto.writeTag(buf, n162, 1, proto.wireTypes.lengthDelimited)

				buf, n162 = proto.writeBuffer(v2468, v2469, v2467, buffer.len(v2467))
			end

			local buf84 = buffer.create(n162)

			buffer.copy(buf84, 0, buf, 0, n162)

			return buf84
		end
		function t327.decode(p248: buffer) -- line: 17522
			-- upvalues: t327 (copy), proto (copy), prop_types (copy)
			local v2472 = t327.new()
			local n163 = 0

			while n163 < buffer.len(p248) do
				local v2474, v2475

				v2474, v2475, n163 = proto.readTag(p248, n163)

				if v2475 == proto.wireTypes.varint then
					local v2476

					v2476, n163 = proto.readVarInt(p248, n163)
				elseif v2475 == proto.wireTypes.lengthDelimited then
					if v2474 == 1 then
						local v2477

						v2477, n163 = proto.readBuffer(p248, n163)
						v2472.universe_id = prop_types.StringProp.decode(v2477)
					else
						local v2478, v2479 = proto.readVarInt(p248, n163)

						n163 = v2479 + v2478
					end
				elseif v2475 == proto.wireTypes.i32 then
					local v2480

					v2480, n163 = proto.readFixed32(p248, n163)
				elseif v2475 == proto.wireTypes.i64 then
					local v2481

					v2481, n163 = proto.readFixed64(p248, n163)
				else
					error("Unsupported wire type: " .. v2475)
				end
			end

			return v2472
		end
		function t327.jsonEncode(p249) -- line: 17565
			local t329 = {}

			if p249.universe_id ~= nil then
				t329.universeId = p249.universe_id:jsonEncode()
			end

			return t329
		end
		function t327.jsonDecode(t330: {[any]: any}) -- line: 17575
			-- upvalues: t327 (copy), prop_types (copy)
			local v2485 = t327.new()

			if t330.universe_id ~= nil then
				v2485.universe_id = prop_types.StringProp.jsonDecode(t330.universe_id)
			end

			if t330.universeId ~= nil then
				v2485.universe_id = prop_types.StringProp.jsonDecode(t330.universeId)
			end

			return v2485
		end

		t327.descriptor = {
			name = "RefreshPlayabilityAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.RefreshPlayabilityAction_Params = t327
		typeRegistry.default:register(t1.RefreshPlayabilityAction_Params)

		local t331 = {}

		t331.__index = t331

		function t331.new(t332: {[any]: any}?) -- line: 17604
			-- upvalues: t1 (copy), t331 (copy)
			return (setmetatable({
				action_type = if t332 ~= nil and t332.action_type ~= nil then t332.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t332 ~= nil and t332.action_params ~= nil then t332.action_params else nil
			}, t331))
		end
		function t331.encode(p250) -- line: 17615
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n164 = 0

			if p250.action_type ~= nil and (p250.action_type ~= nil and p250.action_type ~= 0 or p250.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2490, v2491 = proto.writeTag(buf, n164, 1, proto.wireTypes.varint)

				buf, n164 = proto.writeVarInt(v2490, v2491, t1.ActionType.toNumber(p250.action_type))
			end

			if p250.action_params ~= nil then
				local v2492 = p250.action_params:encode()
				local v2493, v2494 = proto.writeTag(buf, n164, 2, proto.wireTypes.lengthDelimited)

				buf, n164 = proto.writeBuffer(v2493, v2494, v2492, buffer.len(v2492))
			end

			local buf85 = buffer.create(n164)

			buffer.copy(buf85, 0, buf, 0, n164)

			return buf85
		end
		function t331.decode(p251: buffer) -- line: 17641
			-- upvalues: t331 (copy), proto (copy), t1 (copy)
			local v2497 = t331.new()
			local n165 = 0

			while n165 < buffer.len(p251) do
				local v2499, v2500

				v2499, v2500, n165 = proto.readTag(p251, n165)

				if v2500 == proto.wireTypes.varint then
					if v2499 == 1 then
						local v2501

						v2501, n165 = proto.readVarIntI32(p251, n165)
						v2497.action_type = t1.ActionType.fromNumber(v2501) or v2501
					else
						local v2502

						v2502, n165 = proto.readVarInt(p251, n165)
					end
				elseif v2500 == proto.wireTypes.lengthDelimited then
					if v2499 == 2 then
						local v2503

						v2503, n165 = proto.readBuffer(p251, n165)
						v2497.action_params = t1.RefreshDeveloperProductsAction_Params.decode(v2503)
					else
						local v2504, v2505 = proto.readVarInt(p251, n165)

						n165 = v2505 + v2504
					end
				elseif v2500 == proto.wireTypes.i32 then
					local v2506

					v2506, n165 = proto.readFixed32(p251, n165)
				elseif v2500 == proto.wireTypes.i64 then
					local v2507

					v2507, n165 = proto.readFixed64(p251, n165)
				else
					error("Unsupported wire type: " .. v2500)
				end
			end

			return v2497
		end
		function t331.jsonEncode(p252) -- line: 17689
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
		function t331.jsonDecode(t334: {[any]: any}) -- line: 17711
			-- upvalues: t331 (copy), t1 (copy)
			local v2511 = t331.new()

			if t334.action_type ~= nil then
				v2511.action_type = if typeof(t334.action_type) ~= "number" then t1.ActionType.fromName(t334.action_type) or t334.action_type else t1.ActionType.fromNumber(t334.action_type) or t334.action_type
			end

			if t334.actionType ~= nil then
				v2511.action_type = if typeof(t334.actionType) ~= "number" then t1.ActionType.fromName(t334.actionType) or t334.actionType else t1.ActionType.fromNumber(t334.actionType) or t334.actionType
			end

			if t334.action_params ~= nil then
				v2511.action_params = t1.RefreshDeveloperProductsAction_Params.jsonDecode(t334.action_params)
			end

			if t334.actionParams ~= nil then
				v2511.action_params = t1.RefreshDeveloperProductsAction_Params.jsonDecode(t334.actionParams)
			end

			return v2511
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

		function t335.new(t336: {[any]: any}?) -- line: 17751
			-- upvalues: t335 (copy)
			return (setmetatable({
				place_id = if t336 ~= nil and t336.place_id ~= nil then t336.place_id else nil
			}, t335))
		end
		function t335.encode(p253) -- line: 17759
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n166 = 0

			if p253.place_id ~= nil then
				local v2516 = p253.place_id:encode()
				local v2517, v2518 = proto.writeTag(buf, n166, 1, proto.wireTypes.lengthDelimited)

				buf, n166 = proto.writeBuffer(v2517, v2518, v2516, buffer.len(v2516))
			end

			local buf86 = buffer.create(n166)

			buffer.copy(buf86, 0, buf, 0, n166)

			return buf86
		end
		function t335.decode(p254: buffer) -- line: 17774
			-- upvalues: t335 (copy), proto (copy), prop_types (copy)
			local v2521 = t335.new()
			local n167 = 0

			while n167 < buffer.len(p254) do
				local v2523, v2524

				v2523, v2524, n167 = proto.readTag(p254, n167)

				if v2524 == proto.wireTypes.varint then
					local v2525

					v2525, n167 = proto.readVarInt(p254, n167)
				elseif v2524 == proto.wireTypes.lengthDelimited then
					if v2523 == 1 then
						local v2526

						v2526, n167 = proto.readBuffer(p254, n167)
						v2521.place_id = prop_types.StringProp.decode(v2526)
					else
						local v2527, v2528 = proto.readVarInt(p254, n167)

						n167 = v2528 + v2527
					end
				elseif v2524 == proto.wireTypes.i32 then
					local v2529

					v2529, n167 = proto.readFixed32(p254, n167)
				elseif v2524 == proto.wireTypes.i64 then
					local v2530

					v2530, n167 = proto.readFixed64(p254, n167)
				else
					error("Unsupported wire type: " .. v2524)
				end
			end

			return v2521
		end
		function t335.jsonEncode(p255) -- line: 17817
			local t337 = {}

			if p255.place_id ~= nil then
				t337.placeId = p255.place_id:jsonEncode()
			end

			return t337
		end
		function t335.jsonDecode(t338: {[any]: any}) -- line: 17827
			-- upvalues: t335 (copy), prop_types (copy)
			local v2534 = t335.new()

			if t338.place_id ~= nil then
				v2534.place_id = prop_types.StringProp.jsonDecode(t338.place_id)
			end

			if t338.placeId ~= nil then
				v2534.place_id = prop_types.StringProp.jsonDecode(t338.placeId)
			end

			return v2534
		end

		t335.descriptor = {
			name = "RefreshDeveloperProductsAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.RefreshDeveloperProductsAction_Params = t335
		typeRegistry.default:register(t1.RefreshDeveloperProductsAction_Params)

		local t339 = {}

		t339.__index = t339

		function t339.new(t340: {[any]: any}?) -- line: 17857
			-- upvalues: t1 (copy), t339 (copy)
			return (setmetatable({
				action_type = if t340 ~= nil and t340.action_type ~= nil then t340.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t340 ~= nil and t340.action_params ~= nil then t340.action_params else nil
			}, t339))
		end
		function t339.encode(p256) -- line: 17866
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n168 = 0

			if p256.action_type ~= nil and (p256.action_type ~= nil and p256.action_type ~= 0 or p256.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2539, v2540 = proto.writeTag(buf, n168, 1, proto.wireTypes.varint)

				buf, n168 = proto.writeVarInt(v2539, v2540, t1.ActionType.toNumber(p256.action_type))
			end

			if p256.action_params ~= nil then
				local v2541 = p256.action_params:encode()
				local v2542, v2543 = proto.writeTag(buf, n168, 2, proto.wireTypes.lengthDelimited)

				buf, n168 = proto.writeBuffer(v2542, v2543, v2541, buffer.len(v2541))
			end

			local buf87 = buffer.create(n168)

			buffer.copy(buf87, 0, buf, 0, n168)

			return buf87
		end
		function t339.decode(p257: buffer) -- line: 17892
			-- upvalues: t339 (copy), proto (copy), t1 (copy)
			local v2546 = t339.new()
			local n169 = 0

			while n169 < buffer.len(p257) do
				local v2548, v2549

				v2548, v2549, n169 = proto.readTag(p257, n169)

				if v2549 == proto.wireTypes.varint then
					if v2548 == 1 then
						local v2550

						v2550, n169 = proto.readVarIntI32(p257, n169)
						v2546.action_type = t1.ActionType.fromNumber(v2550) or v2550
					else
						local v2551

						v2551, n169 = proto.readVarInt(p257, n169)
					end
				elseif v2549 == proto.wireTypes.lengthDelimited then
					if v2548 == 2 then
						local v2552

						v2552, n169 = proto.readBuffer(p257, n169)
						v2546.action_params = t1.OpenFaeTrialUpsellAction_Params.decode(v2552)
					else
						local v2553, v2554 = proto.readVarInt(p257, n169)

						n169 = v2554 + v2553
					end
				elseif v2549 == proto.wireTypes.i32 then
					local v2555

					v2555, n169 = proto.readFixed32(p257, n169)
				elseif v2549 == proto.wireTypes.i64 then
					local v2556

					v2556, n169 = proto.readFixed64(p257, n169)
				else
					error("Unsupported wire type: " .. v2549)
				end
			end

			return v2546
		end
		function t339.jsonEncode(p258) -- line: 17940
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
		function t339.jsonDecode(t342: {[any]: any}) -- line: 17962
			-- upvalues: t339 (copy), t1 (copy)
			local v2560 = t339.new()

			if t342.action_type ~= nil then
				v2560.action_type = if typeof(t342.action_type) ~= "number" then t1.ActionType.fromName(t342.action_type) or t342.action_type else t1.ActionType.fromNumber(t342.action_type) or t342.action_type
			end

			if t342.actionType ~= nil then
				v2560.action_type = if typeof(t342.actionType) ~= "number" then t1.ActionType.fromName(t342.actionType) or t342.actionType else t1.ActionType.fromNumber(t342.actionType) or t342.actionType
			end

			if t342.action_params ~= nil then
				v2560.action_params = t1.OpenFaeTrialUpsellAction_Params.jsonDecode(t342.action_params)
			end

			if t342.actionParams ~= nil then
				v2560.action_params = t1.OpenFaeTrialUpsellAction_Params.jsonDecode(t342.actionParams)
			end

			return v2560
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

		function t343.new(t344: {[any]: any}?) -- line: 18002
			-- upvalues: t343 (copy)
			return (setmetatable({
				source = if t344 ~= nil and t344.source ~= nil then t344.source else nil,
				config_key = if t344 ~= nil and t344.config_key ~= nil then t344.config_key else nil,
				surface_key = if t344 ~= nil and t344.surface_key ~= nil then t344.surface_key else nil,
				prompt_type = if t344 ~= nil and t344.prompt_type ~= nil then t344.prompt_type else nil
			}, t343))
		end
		function t343.encode(p259) -- line: 18013
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n170 = 0

			if p259.source ~= nil then
				local v2565 = p259.source:encode()
				local v2566, v2567 = proto.writeTag(buf, n170, 1, proto.wireTypes.lengthDelimited)

				buf, n170 = proto.writeBuffer(v2566, v2567, v2565, buffer.len(v2565))
			end

			if p259.config_key ~= nil then
				local v2568 = p259.config_key:encode()
				local v2569, v2570 = proto.writeTag(buf, n170, 2, proto.wireTypes.lengthDelimited)

				buf, n170 = proto.writeBuffer(v2569, v2570, v2568, buffer.len(v2568))
			end

			if p259.surface_key ~= nil then
				local v2571 = p259.surface_key:encode()
				local v2572, v2573 = proto.writeTag(buf, n170, 3, proto.wireTypes.lengthDelimited)

				buf, n170 = proto.writeBuffer(v2572, v2573, v2571, buffer.len(v2571))
			end

			if p259.prompt_type ~= nil then
				local v2574 = p259.prompt_type:encode()
				local v2575, v2576 = proto.writeTag(buf, n170, 4, proto.wireTypes.lengthDelimited)

				buf, n170 = proto.writeBuffer(v2575, v2576, v2574, buffer.len(v2574))
			end

			local buf88 = buffer.create(n170)

			buffer.copy(buf88, 0, buf, 0, n170)

			return buf88
		end
		function t343.decode(p260: buffer) -- line: 18046
			-- upvalues: t343 (copy), proto (copy), prop_types (copy)
			local v2579 = t343.new()
			local n171 = 0

			while n171 < buffer.len(p260) do
				local v2581, v2582

				v2581, v2582, n171 = proto.readTag(p260, n171)

				if v2582 == proto.wireTypes.varint then
					local v2583

					v2583, n171 = proto.readVarInt(p260, n171)
				elseif v2582 == proto.wireTypes.lengthDelimited then
					if v2581 == 1 then
						local v2584

						v2584, n171 = proto.readBuffer(p260, n171)
						v2579.source = prop_types.StringProp.decode(v2584)
					elseif v2581 == 2 then
						local v2585

						v2585, n171 = proto.readBuffer(p260, n171)
						v2579.config_key = prop_types.StringProp.decode(v2585)
					elseif v2581 == 3 then
						local v2586

						v2586, n171 = proto.readBuffer(p260, n171)
						v2579.surface_key = prop_types.StringProp.decode(v2586)
					elseif v2581 == 4 then
						local v2587

						v2587, n171 = proto.readBuffer(p260, n171)
						v2579.prompt_type = prop_types.StringProp.decode(v2587)
					else
						local v2588, v2589 = proto.readVarInt(p260, n171)

						n171 = v2589 + v2588
					end
				elseif v2582 == proto.wireTypes.i32 then
					local v2590

					v2590, n171 = proto.readFixed32(p260, n171)
				elseif v2582 == proto.wireTypes.i64 then
					local v2591

					v2591, n171 = proto.readFixed64(p260, n171)
				else
					error("Unsupported wire type: " .. v2582)
				end
			end

			return v2579
		end
		function t343.jsonEncode(p261) -- line: 18104
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
		function t343.jsonDecode(t346: {[any]: any}) -- line: 18126
			-- upvalues: t343 (copy), prop_types (copy)
			local v2595 = t343.new()

			if t346.source ~= nil then
				v2595.source = prop_types.StringProp.jsonDecode(t346.source)
			end

			if t346.config_key ~= nil then
				v2595.config_key = prop_types.StringProp.jsonDecode(t346.config_key)
			end

			if t346.configKey ~= nil then
				v2595.config_key = prop_types.StringProp.jsonDecode(t346.configKey)
			end

			if t346.surface_key ~= nil then
				v2595.surface_key = prop_types.StringProp.jsonDecode(t346.surface_key)
			end

			if t346.surfaceKey ~= nil then
				v2595.surface_key = prop_types.StringProp.jsonDecode(t346.surfaceKey)
			end

			if t346.prompt_type ~= nil then
				v2595.prompt_type = prop_types.StringProp.jsonDecode(t346.prompt_type)
			end

			if t346.promptType ~= nil then
				v2595.prompt_type = prop_types.StringProp.jsonDecode(t346.promptType)
			end

			return v2595
		end

		t343.descriptor = {
			name = "OpenFaeTrialUpsellAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenFaeTrialUpsellAction_Params = t343
		typeRegistry.default:register(t1.OpenFaeTrialUpsellAction_Params)

		local t347 = {}

		t347.__index = t347

		function t347.new(t348: {[any]: any}?) -- line: 18176
			-- upvalues: t1 (copy), t347 (copy)
			return (setmetatable({
				action_type = if t348 ~= nil and t348.action_type ~= nil then t348.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t348 ~= nil and t348.action_params ~= nil then t348.action_params else nil
			}, t347))
		end
		function t347.encode(p262) -- line: 18187
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n172 = 0

			if p262.action_type ~= nil and (p262.action_type ~= nil and p262.action_type ~= 0 or p262.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2600, v2601 = proto.writeTag(buf, n172, 1, proto.wireTypes.varint)

				buf, n172 = proto.writeVarInt(v2600, v2601, t1.ActionType.toNumber(p262.action_type))
			end

			if p262.action_params ~= nil then
				local v2602 = p262.action_params:encode()
				local v2603, v2604 = proto.writeTag(buf, n172, 2, proto.wireTypes.lengthDelimited)

				buf, n172 = proto.writeBuffer(v2603, v2604, v2602, buffer.len(v2602))
			end

			local buf89 = buffer.create(n172)

			buffer.copy(buf89, 0, buf, 0, n172)

			return buf89
		end
		function t347.decode(p263: buffer) -- line: 18213
			-- upvalues: t347 (copy), proto (copy), t1 (copy)
			local v2607 = t347.new()
			local n173 = 0

			while n173 < buffer.len(p263) do
				local v2609, v2610

				v2609, v2610, n173 = proto.readTag(p263, n173)

				if v2610 == proto.wireTypes.varint then
					if v2609 == 1 then
						local v2611

						v2611, n173 = proto.readVarIntI32(p263, n173)
						v2607.action_type = t1.ActionType.fromNumber(v2611) or v2611
					else
						local v2612

						v2612, n173 = proto.readVarInt(p263, n173)
					end
				elseif v2610 == proto.wireTypes.lengthDelimited then
					if v2609 == 2 then
						local v2613

						v2613, n173 = proto.readBuffer(p263, n173)
						v2607.action_params = t1.OpenIncomingTransferUpsellAction_Params.decode(v2613)
					else
						local v2614, v2615 = proto.readVarInt(p263, n173)

						n173 = v2615 + v2614
					end
				elseif v2610 == proto.wireTypes.i32 then
					local v2616

					v2616, n173 = proto.readFixed32(p263, n173)
				elseif v2610 == proto.wireTypes.i64 then
					local v2617

					v2617, n173 = proto.readFixed64(p263, n173)
				else
					error("Unsupported wire type: " .. v2610)
				end
			end

			return v2607
		end
		function t347.jsonEncode(p264) -- line: 18261
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
		function t347.jsonDecode(t350: {[any]: any}) -- line: 18283
			-- upvalues: t347 (copy), t1 (copy)
			local v2621 = t347.new()

			if t350.action_type ~= nil then
				v2621.action_type = if typeof(t350.action_type) ~= "number" then t1.ActionType.fromName(t350.action_type) or t350.action_type else t1.ActionType.fromNumber(t350.action_type) or t350.action_type
			end

			if t350.actionType ~= nil then
				v2621.action_type = if typeof(t350.actionType) ~= "number" then t1.ActionType.fromName(t350.actionType) or t350.actionType else t1.ActionType.fromNumber(t350.actionType) or t350.actionType
			end

			if t350.action_params ~= nil then
				v2621.action_params = t1.OpenIncomingTransferUpsellAction_Params.jsonDecode(t350.action_params)
			end

			if t350.actionParams ~= nil then
				v2621.action_params = t1.OpenIncomingTransferUpsellAction_Params.jsonDecode(t350.actionParams)
			end

			return v2621
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

		function t351.new(t352: {[any]: any}?) -- line: 18325
			-- upvalues: t351 (copy)
			return (setmetatable({
				url = if t352 ~= nil and t352.url ~= nil then t352.url else nil,
				prompt_type = if t352 ~= nil and t352.prompt_type ~= nil then t352.prompt_type else nil,
				prompt_id = if t352 ~= nil and t352.prompt_id ~= nil then t352.prompt_id else nil
			}, t351))
		end
		function t351.encode(p265) -- line: 18335
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n174 = 0

			if p265.url ~= nil then
				local v2626 = p265.url:encode()
				local v2627, v2628 = proto.writeTag(buf, n174, 1, proto.wireTypes.lengthDelimited)

				buf, n174 = proto.writeBuffer(v2627, v2628, v2626, buffer.len(v2626))
			end

			if p265.prompt_type ~= nil then
				local v2629 = p265.prompt_type:encode()
				local v2630, v2631 = proto.writeTag(buf, n174, 2, proto.wireTypes.lengthDelimited)

				buf, n174 = proto.writeBuffer(v2630, v2631, v2629, buffer.len(v2629))
			end

			if p265.prompt_id ~= nil then
				local v2632 = p265.prompt_id:encode()
				local v2633, v2634 = proto.writeTag(buf, n174, 3, proto.wireTypes.lengthDelimited)

				buf, n174 = proto.writeBuffer(v2633, v2634, v2632, buffer.len(v2632))
			end

			local buf90 = buffer.create(n174)

			buffer.copy(buf90, 0, buf, 0, n174)

			return buf90
		end
		function t351.decode(p266: buffer) -- line: 18362
			-- upvalues: t351 (copy), proto (copy), prop_types (copy)
			local v2637 = t351.new()
			local n175 = 0

			while n175 < buffer.len(p266) do
				local v2639, v2640

				v2639, v2640, n175 = proto.readTag(p266, n175)

				if v2640 == proto.wireTypes.varint then
					local v2641

					v2641, n175 = proto.readVarInt(p266, n175)
				elseif v2640 == proto.wireTypes.lengthDelimited then
					if v2639 == 1 then
						local v2642

						v2642, n175 = proto.readBuffer(p266, n175)
						v2637.url = prop_types.StringProp.decode(v2642)
					elseif v2639 == 2 then
						local v2643

						v2643, n175 = proto.readBuffer(p266, n175)
						v2637.prompt_type = prop_types.StringProp.decode(v2643)
					elseif v2639 == 3 then
						local v2644

						v2644, n175 = proto.readBuffer(p266, n175)
						v2637.prompt_id = prop_types.StringProp.decode(v2644)
					else
						local v2645, v2646 = proto.readVarInt(p266, n175)

						n175 = v2646 + v2645
					end
				elseif v2640 == proto.wireTypes.i32 then
					local v2647

					v2647, n175 = proto.readFixed32(p266, n175)
				elseif v2640 == proto.wireTypes.i64 then
					local v2648

					v2648, n175 = proto.readFixed64(p266, n175)
				else
					error("Unsupported wire type: " .. v2640)
				end
			end

			return v2637
		end
		function t351.jsonEncode(p267) -- line: 18415
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
		function t351.jsonDecode(t354: {[any]: any}) -- line: 18433
			-- upvalues: t351 (copy), prop_types (copy)
			local v2652 = t351.new()

			if t354.url ~= nil then
				v2652.url = prop_types.StringProp.jsonDecode(t354.url)
			end

			if t354.prompt_type ~= nil then
				v2652.prompt_type = prop_types.StringProp.jsonDecode(t354.prompt_type)
			end

			if t354.promptType ~= nil then
				v2652.prompt_type = prop_types.StringProp.jsonDecode(t354.promptType)
			end

			if t354.prompt_id ~= nil then
				v2652.prompt_id = prop_types.StringProp.jsonDecode(t354.prompt_id)
			end

			if t354.promptId ~= nil then
				v2652.prompt_id = prop_types.StringProp.jsonDecode(t354.promptId)
			end

			return v2652
		end

		t351.descriptor = {
			name = "OpenIncomingTransferUpsellAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenIncomingTransferUpsellAction_Params = t351
		typeRegistry.default:register(t1.OpenIncomingTransferUpsellAction_Params)

		local t355 = {}

		t355.__index = t355

		function t355.new(t356: {[any]: any}?) -- line: 18476
			-- upvalues: t1 (copy), t355 (copy)
			return (setmetatable({
				action_type = if t356 ~= nil and t356.action_type ~= nil then t356.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t356 ~= nil and t356.action_params ~= nil then t356.action_params else nil
			}, t355))
		end
		function t355.encode(p268) -- line: 18485
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n176 = 0

			if p268.action_type ~= nil and (p268.action_type ~= nil and p268.action_type ~= 0 or p268.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2657, v2658 = proto.writeTag(buf, n176, 1, proto.wireTypes.varint)

				buf, n176 = proto.writeVarInt(v2657, v2658, t1.ActionType.toNumber(p268.action_type))
			end

			if p268.action_params ~= nil then
				local v2659 = p268.action_params:encode()
				local v2660, v2661 = proto.writeTag(buf, n176, 2, proto.wireTypes.lengthDelimited)

				buf, n176 = proto.writeBuffer(v2660, v2661, v2659, buffer.len(v2659))
			end

			local buf91 = buffer.create(n176)

			buffer.copy(buf91, 0, buf, 0, n176)

			return buf91
		end
		function t355.decode(p269: buffer) -- line: 18511
			-- upvalues: t355 (copy), proto (copy), t1 (copy)
			local v2664 = t355.new()
			local n177 = 0

			while n177 < buffer.len(p269) do
				local v2666, v2667

				v2666, v2667, n177 = proto.readTag(p269, n177)

				if v2667 == proto.wireTypes.varint then
					if v2666 == 1 then
						local v2668

						v2668, n177 = proto.readVarIntI32(p269, n177)
						v2664.action_type = t1.ActionType.fromNumber(v2668) or v2668
					else
						local v2669

						v2669, n177 = proto.readVarInt(p269, n177)
					end
				elseif v2667 == proto.wireTypes.lengthDelimited then
					if v2666 == 2 then
						local v2670

						v2670, n177 = proto.readBuffer(p269, n177)
						v2664.action_params = t1.OpenSduiOverlayAction_Params.decode(v2670)
					else
						local v2671, v2672 = proto.readVarInt(p269, n177)

						n177 = v2672 + v2671
					end
				elseif v2667 == proto.wireTypes.i32 then
					local v2673

					v2673, n177 = proto.readFixed32(p269, n177)
				elseif v2667 == proto.wireTypes.i64 then
					local v2674

					v2674, n177 = proto.readFixed64(p269, n177)
				else
					error("Unsupported wire type: " .. v2667)
				end
			end

			return v2664
		end
		function t355.jsonEncode(p270) -- line: 18559
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
		function t355.jsonDecode(t358: {[any]: any}) -- line: 18581
			-- upvalues: t355 (copy), t1 (copy)
			local v2678 = t355.new()

			if t358.action_type ~= nil then
				v2678.action_type = if typeof(t358.action_type) ~= "number" then t1.ActionType.fromName(t358.action_type) or t358.action_type else t1.ActionType.fromNumber(t358.action_type) or t358.action_type
			end

			if t358.actionType ~= nil then
				v2678.action_type = if typeof(t358.actionType) ~= "number" then t1.ActionType.fromName(t358.actionType) or t358.actionType else t1.ActionType.fromNumber(t358.actionType) or t358.actionType
			end

			if t358.action_params ~= nil then
				v2678.action_params = t1.OpenSduiOverlayAction_Params.jsonDecode(t358.action_params)
			end

			if t358.actionParams ~= nil then
				v2678.action_params = t1.OpenSduiOverlayAction_Params.jsonDecode(t358.actionParams)
			end

			return v2678
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

		function t359.new(t360: {[any]: any}?) -- line: 18621
			-- upvalues: t359 (copy)
			return (setmetatable({
				config_key = if t360 ~= nil and t360.config_key ~= nil then t360.config_key else nil,
				identifier = if t360 ~= nil and t360.identifier ~= nil then t360.identifier else nil
			}, t359))
		end
		function t359.encode(p271) -- line: 18630
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n178 = 0

			if p271.config_key ~= nil then
				local v2683 = p271.config_key:encode()
				local v2684, v2685 = proto.writeTag(buf, n178, 1, proto.wireTypes.lengthDelimited)

				buf, n178 = proto.writeBuffer(v2684, v2685, v2683, buffer.len(v2683))
			end

			if p271.identifier ~= nil then
				local v2686 = p271.identifier:encode()
				local v2687, v2688 = proto.writeTag(buf, n178, 2, proto.wireTypes.lengthDelimited)

				buf, n178 = proto.writeBuffer(v2687, v2688, v2686, buffer.len(v2686))
			end

			local buf92 = buffer.create(n178)

			buffer.copy(buf92, 0, buf, 0, n178)

			return buf92
		end
		function t359.decode(p272: buffer) -- line: 18651
			-- upvalues: t359 (copy), proto (copy), prop_types (copy)
			local v2691 = t359.new()
			local n179 = 0

			while n179 < buffer.len(p272) do
				local v2693, v2694

				v2693, v2694, n179 = proto.readTag(p272, n179)

				if v2694 == proto.wireTypes.varint then
					local v2695

					v2695, n179 = proto.readVarInt(p272, n179)
				elseif v2694 == proto.wireTypes.lengthDelimited then
					if v2693 == 1 then
						local v2696

						v2696, n179 = proto.readBuffer(p272, n179)
						v2691.config_key = prop_types.StringProp.decode(v2696)
					elseif v2693 == 2 then
						local v2697

						v2697, n179 = proto.readBuffer(p272, n179)
						v2691.identifier = prop_types.StringProp.decode(v2697)
					else
						local v2698, v2699 = proto.readVarInt(p272, n179)

						n179 = v2699 + v2698
					end
				elseif v2694 == proto.wireTypes.i32 then
					local v2700

					v2700, n179 = proto.readFixed32(p272, n179)
				elseif v2694 == proto.wireTypes.i64 then
					local v2701

					v2701, n179 = proto.readFixed64(p272, n179)
				else
					error("Unsupported wire type: " .. v2694)
				end
			end

			return v2691
		end
		function t359.jsonEncode(p273) -- line: 18699
			local t361 = {}

			if p273.config_key ~= nil then
				t361.configKey = p273.config_key:jsonEncode()
			end

			if p273.identifier ~= nil then
				t361.identifier = p273.identifier:jsonEncode()
			end

			return t361
		end
		function t359.jsonDecode(t362: {[any]: any}) -- line: 18713
			-- upvalues: t359 (copy), prop_types (copy)
			local v2705 = t359.new()

			if t362.config_key ~= nil then
				v2705.config_key = prop_types.StringProp.jsonDecode(t362.config_key)
			end

			if t362.configKey ~= nil then
				v2705.config_key = prop_types.StringProp.jsonDecode(t362.configKey)
			end

			if t362.identifier ~= nil then
				v2705.identifier = prop_types.StringProp.jsonDecode(t362.identifier)
			end

			return v2705
		end

		t359.descriptor = {
			name = "OpenSduiOverlayAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenSduiOverlayAction_Params = t359
		typeRegistry.default:register(t1.OpenSduiOverlayAction_Params)

		local t363 = {}

		t363.__index = t363

		function t363.new(t364: {[any]: any}?) -- line: 18745
			-- upvalues: t1 (copy), t363 (copy)
			return (setmetatable({
				action_type = if t364 ~= nil and t364.action_type ~= nil then t364.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t364 ~= nil and t364.action_params ~= nil then t364.action_params else nil
			}, t363))
		end
		function t363.encode(p274) -- line: 18754
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n180 = 0

			if p274.action_type ~= nil and (p274.action_type ~= nil and p274.action_type ~= 0 or p274.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2710, v2711 = proto.writeTag(buf, n180, 1, proto.wireTypes.varint)

				buf, n180 = proto.writeVarInt(v2710, v2711, t1.ActionType.toNumber(p274.action_type))
			end

			if p274.action_params ~= nil then
				local v2712 = p274.action_params:encode()
				local v2713, v2714 = proto.writeTag(buf, n180, 2, proto.wireTypes.lengthDelimited)

				buf, n180 = proto.writeBuffer(v2713, v2714, v2712, buffer.len(v2712))
			end

			local buf93 = buffer.create(n180)

			buffer.copy(buf93, 0, buf, 0, n180)

			return buf93
		end
		function t363.decode(p275: buffer) -- line: 18780
			-- upvalues: t363 (copy), proto (copy), t1 (copy)
			local v2717 = t363.new()
			local n181 = 0

			while n181 < buffer.len(p275) do
				local v2719, v2720

				v2719, v2720, n181 = proto.readTag(p275, n181)

				if v2720 == proto.wireTypes.varint then
					if v2719 == 1 then
						local v2721

						v2721, n181 = proto.readVarIntI32(p275, n181)
						v2717.action_type = t1.ActionType.fromNumber(v2721) or v2721
					else
						local v2722

						v2722, n181 = proto.readVarInt(p275, n181)
					end
				elseif v2720 == proto.wireTypes.lengthDelimited then
					if v2719 == 2 then
						local v2723

						v2723, n181 = proto.readBuffer(p275, n181)
						v2717.action_params = t1.ApplyChartsFilterAction_Params.decode(v2723)
					else
						local v2724, v2725 = proto.readVarInt(p275, n181)

						n181 = v2725 + v2724
					end
				elseif v2720 == proto.wireTypes.i32 then
					local v2726

					v2726, n181 = proto.readFixed32(p275, n181)
				elseif v2720 == proto.wireTypes.i64 then
					local v2727

					v2727, n181 = proto.readFixed64(p275, n181)
				else
					error("Unsupported wire type: " .. v2720)
				end
			end

			return v2717
		end
		function t363.jsonEncode(p276) -- line: 18828
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
		function t363.jsonDecode(t366: {[any]: any}) -- line: 18850
			-- upvalues: t363 (copy), t1 (copy)
			local v2731 = t363.new()

			if t366.action_type ~= nil then
				v2731.action_type = if typeof(t366.action_type) ~= "number" then t1.ActionType.fromName(t366.action_type) or t366.action_type else t1.ActionType.fromNumber(t366.action_type) or t366.action_type
			end

			if t366.actionType ~= nil then
				v2731.action_type = if typeof(t366.actionType) ~= "number" then t1.ActionType.fromName(t366.actionType) or t366.actionType else t1.ActionType.fromNumber(t366.actionType) or t366.actionType
			end

			if t366.action_params ~= nil then
				v2731.action_params = t1.ApplyChartsFilterAction_Params.jsonDecode(t366.action_params)
			end

			if t366.actionParams ~= nil then
				v2731.action_params = t1.ApplyChartsFilterAction_Params.jsonDecode(t366.actionParams)
			end

			return v2731
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

		function t367.new(t368: {[any]: any}?) -- line: 18890
			-- upvalues: t367 (copy)
			return (setmetatable({
				session_id = if t368 ~= nil and t368.session_id ~= nil then t368.session_id else nil
			}, t367))
		end
		function t367.encode(p277) -- line: 18898
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n182 = 0

			if p277.session_id ~= nil then
				local v2736 = p277.session_id:encode()
				local v2737, v2738 = proto.writeTag(buf, n182, 1, proto.wireTypes.lengthDelimited)

				buf, n182 = proto.writeBuffer(v2737, v2738, v2736, buffer.len(v2736))
			end

			local buf94 = buffer.create(n182)

			buffer.copy(buf94, 0, buf, 0, n182)

			return buf94
		end
		function t367.decode(p278: buffer) -- line: 18913
			-- upvalues: t367 (copy), proto (copy), prop_types (copy)
			local v2741 = t367.new()
			local n183 = 0

			while n183 < buffer.len(p278) do
				local v2743, v2744

				v2743, v2744, n183 = proto.readTag(p278, n183)

				if v2744 == proto.wireTypes.varint then
					local v2745

					v2745, n183 = proto.readVarInt(p278, n183)
				elseif v2744 == proto.wireTypes.lengthDelimited then
					if v2743 == 1 then
						local v2746

						v2746, n183 = proto.readBuffer(p278, n183)
						v2741.session_id = prop_types.StringProp.decode(v2746)
					else
						local v2747, v2748 = proto.readVarInt(p278, n183)

						n183 = v2748 + v2747
					end
				elseif v2744 == proto.wireTypes.i32 then
					local v2749

					v2749, n183 = proto.readFixed32(p278, n183)
				elseif v2744 == proto.wireTypes.i64 then
					local v2750

					v2750, n183 = proto.readFixed64(p278, n183)
				else
					error("Unsupported wire type: " .. v2744)
				end
			end

			return v2741
		end
		function t367.jsonEncode(p279) -- line: 18956
			local t369 = {}

			if p279.session_id ~= nil then
				t369.sessionId = p279.session_id:jsonEncode()
			end

			return t369
		end
		function t367.jsonDecode(t370: {[any]: any}) -- line: 18966
			-- upvalues: t367 (copy), prop_types (copy)
			local v2754 = t367.new()

			if t370.session_id ~= nil then
				v2754.session_id = prop_types.StringProp.jsonDecode(t370.session_id)
			end

			if t370.sessionId ~= nil then
				v2754.session_id = prop_types.StringProp.jsonDecode(t370.sessionId)
			end

			return v2754
		end

		t367.descriptor = {
			name = "ApplyChartsFilterAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.ApplyChartsFilterAction_Params = t367
		typeRegistry.default:register(t1.ApplyChartsFilterAction_Params)

		local t371 = {}

		t371.__index = t371

		function t371.new(t372: {[any]: any}?) -- line: 18994
			-- upvalues: t1 (copy), t371 (copy)
			return (setmetatable({
				action_type = if t372 ~= nil and t372.action_type ~= nil then t372.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t372 ~= nil and t372.action_params ~= nil then t372.action_params else nil
			}, t371))
		end
		function t371.encode(p280) -- line: 19005
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n184 = 0

			if p280.action_type ~= nil and (p280.action_type ~= nil and p280.action_type ~= 0 or p280.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2759, v2760 = proto.writeTag(buf, n184, 1, proto.wireTypes.varint)

				buf, n184 = proto.writeVarInt(v2759, v2760, t1.ActionType.toNumber(p280.action_type))
			end

			if p280.action_params ~= nil then
				local v2761 = p280.action_params:encode()
				local v2762, v2763 = proto.writeTag(buf, n184, 2, proto.wireTypes.lengthDelimited)

				buf, n184 = proto.writeBuffer(v2762, v2763, v2761, buffer.len(v2761))
			end

			local buf95 = buffer.create(n184)

			buffer.copy(buf95, 0, buf, 0, n184)

			return buf95
		end
		function t371.decode(p281: buffer) -- line: 19031
			-- upvalues: t371 (copy), proto (copy), t1 (copy)
			local v2766 = t371.new()
			local n185 = 0

			while n185 < buffer.len(p281) do
				local v2768, v2769

				v2768, v2769, n185 = proto.readTag(p281, n185)

				if v2769 == proto.wireTypes.varint then
					if v2768 == 1 then
						local v2770

						v2770, n185 = proto.readVarIntI32(p281, n185)
						v2766.action_type = t1.ActionType.fromNumber(v2770) or v2770
					else
						local v2771

						v2771, n185 = proto.readVarInt(p281, n185)
					end
				elseif v2769 == proto.wireTypes.lengthDelimited then
					if v2768 == 2 then
						local v2772

						v2772, n185 = proto.readBuffer(p281, n185)
						v2766.action_params = t1.RefreshChartsSortDetailAction_Params.decode(v2772)
					else
						local v2773, v2774 = proto.readVarInt(p281, n185)

						n185 = v2774 + v2773
					end
				elseif v2769 == proto.wireTypes.i32 then
					local v2775

					v2775, n185 = proto.readFixed32(p281, n185)
				elseif v2769 == proto.wireTypes.i64 then
					local v2776

					v2776, n185 = proto.readFixed64(p281, n185)
				else
					error("Unsupported wire type: " .. v2769)
				end
			end

			return v2766
		end
		function t371.jsonEncode(p282) -- line: 19079
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
		function t371.jsonDecode(t374: {[any]: any}) -- line: 19101
			-- upvalues: t371 (copy), t1 (copy)
			local v2780 = t371.new()

			if t374.action_type ~= nil then
				v2780.action_type = if typeof(t374.action_type) ~= "number" then t1.ActionType.fromName(t374.action_type) or t374.action_type else t1.ActionType.fromNumber(t374.action_type) or t374.action_type
			end

			if t374.actionType ~= nil then
				v2780.action_type = if typeof(t374.actionType) ~= "number" then t1.ActionType.fromName(t374.actionType) or t374.actionType else t1.ActionType.fromNumber(t374.actionType) or t374.actionType
			end

			if t374.action_params ~= nil then
				v2780.action_params = t1.RefreshChartsSortDetailAction_Params.jsonDecode(t374.action_params)
			end

			if t374.actionParams ~= nil then
				v2780.action_params = t1.RefreshChartsSortDetailAction_Params.jsonDecode(t374.actionParams)
			end

			return v2780
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

		function t375.new(t376: {[any]: any}?) -- line: 19141
			-- upvalues: t375 (copy)
			return (setmetatable({
				config_key = if t376 ~= nil and t376.config_key ~= nil then t376.config_key else nil,
				selected_option = if t376 ~= nil and t376.selected_option ~= nil then t376.selected_option else nil,
				surface_key = if t376 ~= nil and t376.surface_key ~= nil then t376.surface_key else nil,
				sort_id = if t376 ~= nil and t376.sort_id ~= nil then t376.sort_id else nil
			}, t375))
		end
		function t375.encode(p283) -- line: 19152
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n186 = 0

			if p283.config_key ~= nil then
				local v2785 = p283.config_key:encode()
				local v2786, v2787 = proto.writeTag(buf, n186, 1, proto.wireTypes.lengthDelimited)

				buf, n186 = proto.writeBuffer(v2786, v2787, v2785, buffer.len(v2785))
			end

			if p283.selected_option ~= nil then
				local v2788 = p283.selected_option:encode()
				local v2789, v2790 = proto.writeTag(buf, n186, 2, proto.wireTypes.lengthDelimited)

				buf, n186 = proto.writeBuffer(v2789, v2790, v2788, buffer.len(v2788))
			end

			if p283.surface_key ~= nil then
				local v2791 = p283.surface_key:encode()
				local v2792, v2793 = proto.writeTag(buf, n186, 3, proto.wireTypes.lengthDelimited)

				buf, n186 = proto.writeBuffer(v2792, v2793, v2791, buffer.len(v2791))
			end

			if p283.sort_id ~= nil then
				local v2794 = p283.sort_id:encode()
				local v2795, v2796 = proto.writeTag(buf, n186, 4, proto.wireTypes.lengthDelimited)

				buf, n186 = proto.writeBuffer(v2795, v2796, v2794, buffer.len(v2794))
			end

			local buf96 = buffer.create(n186)

			buffer.copy(buf96, 0, buf, 0, n186)

			return buf96
		end
		function t375.decode(p284: buffer) -- line: 19185
			-- upvalues: t375 (copy), proto (copy), prop_types (copy)
			local v2799 = t375.new()
			local n187 = 0

			while n187 < buffer.len(p284) do
				local v2801, v2802

				v2801, v2802, n187 = proto.readTag(p284, n187)

				if v2802 == proto.wireTypes.varint then
					local v2803

					v2803, n187 = proto.readVarInt(p284, n187)
				elseif v2802 == proto.wireTypes.lengthDelimited then
					if v2801 == 1 then
						local v2804

						v2804, n187 = proto.readBuffer(p284, n187)
						v2799.config_key = prop_types.StringProp.decode(v2804)
					elseif v2801 == 2 then
						local v2805

						v2805, n187 = proto.readBuffer(p284, n187)
						v2799.selected_option = prop_types.StringProp.decode(v2805)
					elseif v2801 == 3 then
						local v2806

						v2806, n187 = proto.readBuffer(p284, n187)
						v2799.surface_key = prop_types.StringProp.decode(v2806)
					elseif v2801 == 4 then
						local v2807

						v2807, n187 = proto.readBuffer(p284, n187)
						v2799.sort_id = prop_types.StringProp.decode(v2807)
					else
						local v2808, v2809 = proto.readVarInt(p284, n187)

						n187 = v2809 + v2808
					end
				elseif v2802 == proto.wireTypes.i32 then
					local v2810

					v2810, n187 = proto.readFixed32(p284, n187)
				elseif v2802 == proto.wireTypes.i64 then
					local v2811

					v2811, n187 = proto.readFixed64(p284, n187)
				else
					error("Unsupported wire type: " .. v2802)
				end
			end

			return v2799
		end
		function t375.jsonEncode(p285) -- line: 19243
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
		function t375.jsonDecode(t378: {[any]: any}) -- line: 19265
			-- upvalues: t375 (copy), prop_types (copy)
			local v2815 = t375.new()

			if t378.config_key ~= nil then
				v2815.config_key = prop_types.StringProp.jsonDecode(t378.config_key)
			end

			if t378.configKey ~= nil then
				v2815.config_key = prop_types.StringProp.jsonDecode(t378.configKey)
			end

			if t378.selected_option ~= nil then
				v2815.selected_option = prop_types.StringProp.jsonDecode(t378.selected_option)
			end

			if t378.selectedOption ~= nil then
				v2815.selected_option = prop_types.StringProp.jsonDecode(t378.selectedOption)
			end

			if t378.surface_key ~= nil then
				v2815.surface_key = prop_types.StringProp.jsonDecode(t378.surface_key)
			end

			if t378.surfaceKey ~= nil then
				v2815.surface_key = prop_types.StringProp.jsonDecode(t378.surfaceKey)
			end

			if t378.sort_id ~= nil then
				v2815.sort_id = prop_types.StringProp.jsonDecode(t378.sort_id)
			end

			if t378.sortId ~= nil then
				v2815.sort_id = prop_types.StringProp.jsonDecode(t378.sortId)
			end

			return v2815
		end

		t375.descriptor = {
			name = "RefreshChartsSortDetailAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.RefreshChartsSortDetailAction_Params = t375
		typeRegistry.default:register(t1.RefreshChartsSortDetailAction_Params)

		local t379 = {}

		t379.__index = t379

		function t379.new(t380: {[any]: any}?) -- line: 19322
			-- upvalues: t1 (copy), t379 (copy)
			return (setmetatable({
				action_type = if t380 ~= nil and t380.action_type ~= nil then t380.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t380 ~= nil and t380.action_params ~= nil then t380.action_params else nil
			}, t379))
		end
		function t379.encode(p286) -- line: 19331
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n188 = 0

			if p286.action_type ~= nil and (p286.action_type ~= nil and p286.action_type ~= 0 or p286.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2820, v2821 = proto.writeTag(buf, n188, 1, proto.wireTypes.varint)

				buf, n188 = proto.writeVarInt(v2820, v2821, t1.ActionType.toNumber(p286.action_type))
			end

			if p286.action_params ~= nil then
				local v2822 = p286.action_params:encode()
				local v2823, v2824 = proto.writeTag(buf, n188, 2, proto.wireTypes.lengthDelimited)

				buf, n188 = proto.writeBuffer(v2823, v2824, v2822, buffer.len(v2822))
			end

			local buf97 = buffer.create(n188)

			buffer.copy(buf97, 0, buf, 0, n188)

			return buf97
		end
		function t379.decode(p287: buffer) -- line: 19357
			-- upvalues: t379 (copy), proto (copy), t1 (copy)
			local v2827 = t379.new()
			local n189 = 0

			while n189 < buffer.len(p287) do
				local v2829, v2830

				v2829, v2830, n189 = proto.readTag(p287, n189)

				if v2830 == proto.wireTypes.varint then
					if v2829 == 1 then
						local v2831

						v2831, n189 = proto.readVarIntI32(p287, n189)
						v2827.action_type = t1.ActionType.fromNumber(v2831) or v2831
					else
						local v2832

						v2832, n189 = proto.readVarInt(p287, n189)
					end
				elseif v2830 == proto.wireTypes.lengthDelimited then
					if v2829 == 2 then
						local v2833

						v2833, n189 = proto.readBuffer(p287, n189)
						v2827.action_params = t1.JoinCommunityAction_Params.decode(v2833)
					else
						local v2834, v2835 = proto.readVarInt(p287, n189)

						n189 = v2835 + v2834
					end
				elseif v2830 == proto.wireTypes.i32 then
					local v2836

					v2836, n189 = proto.readFixed32(p287, n189)
				elseif v2830 == proto.wireTypes.i64 then
					local v2837

					v2837, n189 = proto.readFixed64(p287, n189)
				else
					error("Unsupported wire type: " .. v2830)
				end
			end

			return v2827
		end
		function t379.jsonEncode(p288) -- line: 19405
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
		function t379.jsonDecode(t382: {[any]: any}) -- line: 19427
			-- upvalues: t379 (copy), t1 (copy)
			local v2841 = t379.new()

			if t382.action_type ~= nil then
				v2841.action_type = if typeof(t382.action_type) ~= "number" then t1.ActionType.fromName(t382.action_type) or t382.action_type else t1.ActionType.fromNumber(t382.action_type) or t382.action_type
			end

			if t382.actionType ~= nil then
				v2841.action_type = if typeof(t382.actionType) ~= "number" then t1.ActionType.fromName(t382.actionType) or t382.actionType else t1.ActionType.fromNumber(t382.actionType) or t382.actionType
			end

			if t382.action_params ~= nil then
				v2841.action_params = t1.JoinCommunityAction_Params.jsonDecode(t382.action_params)
			end

			if t382.actionParams ~= nil then
				v2841.action_params = t1.JoinCommunityAction_Params.jsonDecode(t382.actionParams)
			end

			return v2841
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

		function t383.new(t384: {[any]: any}?) -- line: 19467
			-- upvalues: t383 (copy)
			return (setmetatable({
				community_id = if t384 ~= nil and t384.community_id ~= nil then t384.community_id else nil
			}, t383))
		end
		function t383.encode(p289) -- line: 19475
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n190 = 0

			if p289.community_id ~= nil then
				local v2846 = p289.community_id:encode()
				local v2847, v2848 = proto.writeTag(buf, n190, 1, proto.wireTypes.lengthDelimited)

				buf, n190 = proto.writeBuffer(v2847, v2848, v2846, buffer.len(v2846))
			end

			local buf98 = buffer.create(n190)

			buffer.copy(buf98, 0, buf, 0, n190)

			return buf98
		end
		function t383.decode(p290: buffer) -- line: 19490
			-- upvalues: t383 (copy), proto (copy), prop_types (copy)
			local v2851 = t383.new()
			local n191 = 0

			while n191 < buffer.len(p290) do
				local v2853, v2854

				v2853, v2854, n191 = proto.readTag(p290, n191)

				if v2854 == proto.wireTypes.varint then
					local v2855

					v2855, n191 = proto.readVarInt(p290, n191)
				elseif v2854 == proto.wireTypes.lengthDelimited then
					if v2853 == 1 then
						local v2856

						v2856, n191 = proto.readBuffer(p290, n191)
						v2851.community_id = prop_types.StringProp.decode(v2856)
					else
						local v2857, v2858 = proto.readVarInt(p290, n191)

						n191 = v2858 + v2857
					end
				elseif v2854 == proto.wireTypes.i32 then
					local v2859

					v2859, n191 = proto.readFixed32(p290, n191)
				elseif v2854 == proto.wireTypes.i64 then
					local v2860

					v2860, n191 = proto.readFixed64(p290, n191)
				else
					error("Unsupported wire type: " .. v2854)
				end
			end

			return v2851
		end
		function t383.jsonEncode(p291) -- line: 19533
			local t385 = {}

			if p291.community_id ~= nil then
				t385.communityId = p291.community_id:jsonEncode()
			end

			return t385
		end
		function t383.jsonDecode(t386: {[any]: any}) -- line: 19543
			-- upvalues: t383 (copy), prop_types (copy)
			local v2864 = t383.new()

			if t386.community_id ~= nil then
				v2864.community_id = prop_types.StringProp.jsonDecode(t386.community_id)
			end

			if t386.communityId ~= nil then
				v2864.community_id = prop_types.StringProp.jsonDecode(t386.communityId)
			end

			return v2864
		end

		t383.descriptor = {
			name = "JoinCommunityAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.JoinCommunityAction_Params = t383
		typeRegistry.default:register(t1.JoinCommunityAction_Params)

		local t387 = {}

		t387.__index = t387

		function t387.new(t388: {[any]: any}?) -- line: 19573
			-- upvalues: t1 (copy), t387 (copy)
			return (setmetatable({
				action_type = if t388 ~= nil and t388.action_type ~= nil then t388.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t388 ~= nil and t388.action_params ~= nil then t388.action_params else nil
			}, t387))
		end
		function t387.encode(p292) -- line: 19582
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n192 = 0

			if p292.action_type ~= nil and (p292.action_type ~= nil and p292.action_type ~= 0 or p292.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2869, v2870 = proto.writeTag(buf, n192, 1, proto.wireTypes.varint)

				buf, n192 = proto.writeVarInt(v2869, v2870, t1.ActionType.toNumber(p292.action_type))
			end

			if p292.action_params ~= nil then
				local v2871 = p292.action_params:encode()
				local v2872, v2873 = proto.writeTag(buf, n192, 2, proto.wireTypes.lengthDelimited)

				buf, n192 = proto.writeBuffer(v2872, v2873, v2871, buffer.len(v2871))
			end

			local buf99 = buffer.create(n192)

			buffer.copy(buf99, 0, buf, 0, n192)

			return buf99
		end
		function t387.decode(p293: buffer) -- line: 19608
			-- upvalues: t387 (copy), proto (copy), t1 (copy)
			local v2876 = t387.new()
			local n193 = 0

			while n193 < buffer.len(p293) do
				local v2878, v2879

				v2878, v2879, n193 = proto.readTag(p293, n193)

				if v2879 == proto.wireTypes.varint then
					if v2878 == 1 then
						local v2880

						v2880, n193 = proto.readVarIntI32(p293, n193)
						v2876.action_type = t1.ActionType.fromNumber(v2880) or v2880
					else
						local v2881

						v2881, n193 = proto.readVarInt(p293, n193)
					end
				elseif v2879 == proto.wireTypes.lengthDelimited then
					if v2878 == 2 then
						local v2882

						v2882, n193 = proto.readBuffer(p293, n193)
						v2876.action_params = t1.ViewCommunityAction_Params.decode(v2882)
					else
						local v2883, v2884 = proto.readVarInt(p293, n193)

						n193 = v2884 + v2883
					end
				elseif v2879 == proto.wireTypes.i32 then
					local v2885

					v2885, n193 = proto.readFixed32(p293, n193)
				elseif v2879 == proto.wireTypes.i64 then
					local v2886

					v2886, n193 = proto.readFixed64(p293, n193)
				else
					error("Unsupported wire type: " .. v2879)
				end
			end

			return v2876
		end
		function t387.jsonEncode(p294) -- line: 19656
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
		function t387.jsonDecode(t390: {[any]: any}) -- line: 19678
			-- upvalues: t387 (copy), t1 (copy)
			local v2890 = t387.new()

			if t390.action_type ~= nil then
				v2890.action_type = if typeof(t390.action_type) ~= "number" then t1.ActionType.fromName(t390.action_type) or t390.action_type else t1.ActionType.fromNumber(t390.action_type) or t390.action_type
			end

			if t390.actionType ~= nil then
				v2890.action_type = if typeof(t390.actionType) ~= "number" then t1.ActionType.fromName(t390.actionType) or t390.actionType else t1.ActionType.fromNumber(t390.actionType) or t390.actionType
			end

			if t390.action_params ~= nil then
				v2890.action_params = t1.ViewCommunityAction_Params.jsonDecode(t390.action_params)
			end

			if t390.actionParams ~= nil then
				v2890.action_params = t1.ViewCommunityAction_Params.jsonDecode(t390.actionParams)
			end

			return v2890
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

		function t391.new(t392: {[any]: any}?) -- line: 19718
			-- upvalues: t391 (copy)
			return (setmetatable({
				community_id = if t392 ~= nil and t392.community_id ~= nil then t392.community_id else nil
			}, t391))
		end
		function t391.encode(p295) -- line: 19726
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n194 = 0

			if p295.community_id ~= nil then
				local v2895 = p295.community_id:encode()
				local v2896, v2897 = proto.writeTag(buf, n194, 1, proto.wireTypes.lengthDelimited)

				buf, n194 = proto.writeBuffer(v2896, v2897, v2895, buffer.len(v2895))
			end

			local buf100 = buffer.create(n194)

			buffer.copy(buf100, 0, buf, 0, n194)

			return buf100
		end
		function t391.decode(p296: buffer) -- line: 19741
			-- upvalues: t391 (copy), proto (copy), prop_types (copy)
			local v2900 = t391.new()
			local n195 = 0

			while n195 < buffer.len(p296) do
				local v2902, v2903

				v2902, v2903, n195 = proto.readTag(p296, n195)

				if v2903 == proto.wireTypes.varint then
					local v2904

					v2904, n195 = proto.readVarInt(p296, n195)
				elseif v2903 == proto.wireTypes.lengthDelimited then
					if v2902 == 1 then
						local v2905

						v2905, n195 = proto.readBuffer(p296, n195)
						v2900.community_id = prop_types.StringProp.decode(v2905)
					else
						local v2906, v2907 = proto.readVarInt(p296, n195)

						n195 = v2907 + v2906
					end
				elseif v2903 == proto.wireTypes.i32 then
					local v2908

					v2908, n195 = proto.readFixed32(p296, n195)
				elseif v2903 == proto.wireTypes.i64 then
					local v2909

					v2909, n195 = proto.readFixed64(p296, n195)
				else
					error("Unsupported wire type: " .. v2903)
				end
			end

			return v2900
		end
		function t391.jsonEncode(p297) -- line: 19784
			local t393 = {}

			if p297.community_id ~= nil then
				t393.communityId = p297.community_id:jsonEncode()
			end

			return t393
		end
		function t391.jsonDecode(t394: {[any]: any}) -- line: 19794
			-- upvalues: t391 (copy), prop_types (copy)
			local v2913 = t391.new()

			if t394.community_id ~= nil then
				v2913.community_id = prop_types.StringProp.jsonDecode(t394.community_id)
			end

			if t394.communityId ~= nil then
				v2913.community_id = prop_types.StringProp.jsonDecode(t394.communityId)
			end

			return v2913
		end

		t391.descriptor = {
			name = "ViewCommunityAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.ViewCommunityAction_Params = t391
		typeRegistry.default:register(t1.ViewCommunityAction_Params)

		local t395 = {}

		t395.__index = t395

		function t395.new(t396: {[any]: any}?) -- line: 19824
			-- upvalues: t1 (copy), t395 (copy)
			return (setmetatable({
				action_type = if t396 ~= nil and t396.action_type ~= nil then t396.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t396 ~= nil and t396.action_params ~= nil then t396.action_params else nil
			}, t395))
		end
		function t395.encode(p298) -- line: 19833
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n196 = 0

			if p298.action_type ~= nil and (p298.action_type ~= nil and p298.action_type ~= 0 or p298.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2918, v2919 = proto.writeTag(buf, n196, 1, proto.wireTypes.varint)

				buf, n196 = proto.writeVarInt(v2918, v2919, t1.ActionType.toNumber(p298.action_type))
			end

			if p298.action_params ~= nil then
				local v2920 = p298.action_params:encode()
				local v2921, v2922 = proto.writeTag(buf, n196, 2, proto.wireTypes.lengthDelimited)

				buf, n196 = proto.writeBuffer(v2921, v2922, v2920, buffer.len(v2920))
			end

			local buf101 = buffer.create(n196)

			buffer.copy(buf101, 0, buf, 0, n196)

			return buf101
		end
		function t395.decode(p299: buffer) -- line: 19859
			-- upvalues: t395 (copy), proto (copy), t1 (copy)
			local v2925 = t395.new()
			local n197 = 0

			while n197 < buffer.len(p299) do
				local v2927, v2928

				v2927, v2928, n197 = proto.readTag(p299, n197)

				if v2928 == proto.wireTypes.varint then
					if v2927 == 1 then
						local v2929

						v2929, n197 = proto.readVarIntI32(p299, n197)
						v2925.action_type = t1.ActionType.fromNumber(v2929) or v2929
					else
						local v2930

						v2930, n197 = proto.readVarInt(p299, n197)
					end
				elseif v2928 == proto.wireTypes.lengthDelimited then
					if v2927 == 2 then
						local v2931

						v2931, n197 = proto.readBuffer(p299, n197)
						v2925.action_params = t1.AnalyticsEventAction_Params.decode(v2931)
					else
						local v2932, v2933 = proto.readVarInt(p299, n197)

						n197 = v2933 + v2932
					end
				elseif v2928 == proto.wireTypes.i32 then
					local v2934

					v2934, n197 = proto.readFixed32(p299, n197)
				elseif v2928 == proto.wireTypes.i64 then
					local v2935

					v2935, n197 = proto.readFixed64(p299, n197)
				else
					error("Unsupported wire type: " .. v2928)
				end
			end

			return v2925
		end
		function t395.jsonEncode(p300) -- line: 19907
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
		function t395.jsonDecode(t398: {[any]: any}) -- line: 19929
			-- upvalues: t395 (copy), t1 (copy)
			local v2939 = t395.new()

			if t398.action_type ~= nil then
				v2939.action_type = if typeof(t398.action_type) ~= "number" then t1.ActionType.fromName(t398.action_type) or t398.action_type else t1.ActionType.fromNumber(t398.action_type) or t398.action_type
			end

			if t398.actionType ~= nil then
				v2939.action_type = if typeof(t398.actionType) ~= "number" then t1.ActionType.fromName(t398.actionType) or t398.actionType else t1.ActionType.fromNumber(t398.actionType) or t398.actionType
			end

			if t398.action_params ~= nil then
				v2939.action_params = t1.AnalyticsEventAction_Params.jsonDecode(t398.action_params)
			end

			if t398.actionParams ~= nil then
				v2939.action_params = t1.AnalyticsEventAction_Params.jsonDecode(t398.actionParams)
			end

			return v2939
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

		function t399.new(t400: {[any]: any}?) -- line: 19969
			-- upvalues: t399 (copy)
			return (setmetatable({
				event_name = if t400 ~= nil and t400.event_name ~= nil then t400.event_name else nil,
				event_fields = if t400 ~= nil and t400.event_fields ~= nil then t400.event_fields else nil
			}, t399))
		end
		function t399.encode(p301) -- line: 19978
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n198 = 0

			if p301.event_name ~= nil then
				local v2944 = p301.event_name:encode()
				local v2945, v2946 = proto.writeTag(buf, n198, 1, proto.wireTypes.lengthDelimited)

				buf, n198 = proto.writeBuffer(v2945, v2946, v2944, buffer.len(v2944))
			end

			if p301.event_fields ~= nil then
				local v2947 = p301.event_fields:encode()
				local v2948, v2949 = proto.writeTag(buf, n198, 2, proto.wireTypes.lengthDelimited)

				buf, n198 = proto.writeBuffer(v2948, v2949, v2947, buffer.len(v2947))
			end

			local buf102 = buffer.create(n198)

			buffer.copy(buf102, 0, buf, 0, n198)

			return buf102
		end
		function t399.decode(p302: buffer) -- line: 19999
			-- upvalues: t399 (copy), proto (copy), prop_types (copy)
			local v2952 = t399.new()
			local n199 = 0

			while n199 < buffer.len(p302) do
				local v2954, v2955

				v2954, v2955, n199 = proto.readTag(p302, n199)

				if v2955 == proto.wireTypes.varint then
					local v2956

					v2956, n199 = proto.readVarInt(p302, n199)
				elseif v2955 == proto.wireTypes.lengthDelimited then
					if v2954 == 1 then
						local v2957

						v2957, n199 = proto.readBuffer(p302, n199)
						v2952.event_name = prop_types.StringProp.decode(v2957)
					elseif v2954 == 2 then
						local v2958

						v2958, n199 = proto.readBuffer(p302, n199)
						v2952.event_fields = prop_types.StructProp.decode(v2958)
					else
						local v2959, v2960 = proto.readVarInt(p302, n199)

						n199 = v2960 + v2959
					end
				elseif v2955 == proto.wireTypes.i32 then
					local v2961

					v2961, n199 = proto.readFixed32(p302, n199)
				elseif v2955 == proto.wireTypes.i64 then
					local v2962

					v2962, n199 = proto.readFixed64(p302, n199)
				else
					error("Unsupported wire type: " .. v2955)
				end
			end

			return v2952
		end
		function t399.jsonEncode(p303) -- line: 20047
			local t401 = {}

			if p303.event_name ~= nil then
				t401.eventName = p303.event_name:jsonEncode()
			end

			if p303.event_fields ~= nil then
				t401.eventFields = p303.event_fields:jsonEncode()
			end

			return t401
		end
		function t399.jsonDecode(t402: {[any]: any}) -- line: 20061
			-- upvalues: t399 (copy), prop_types (copy)
			local v2966 = t399.new()

			if t402.event_name ~= nil then
				v2966.event_name = prop_types.StringProp.jsonDecode(t402.event_name)
			end

			if t402.eventName ~= nil then
				v2966.event_name = prop_types.StringProp.jsonDecode(t402.eventName)
			end

			if t402.event_fields ~= nil then
				v2966.event_fields = prop_types.StructProp.jsonDecode(t402.event_fields)
			end

			if t402.eventFields ~= nil then
				v2966.event_fields = prop_types.StructProp.jsonDecode(t402.eventFields)
			end

			return v2966
		end

		t399.descriptor = {
			name = "AnalyticsEventAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.AnalyticsEventAction_Params = t399
		typeRegistry.default:register(t1.AnalyticsEventAction_Params)

		local t403 = {}

		t403.__index = t403

		function t403.new(t404: {[any]: any}?) -- line: 20099
			-- upvalues: t1 (copy), t403 (copy)
			return (setmetatable({
				action_type = if t404 ~= nil and t404.action_type ~= nil then t404.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t404 ~= nil and t404.action_params ~= nil then t404.action_params else nil
			}, t403))
		end
		function t403.encode(p304) -- line: 20110
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n200 = 0

			if p304.action_type ~= nil and (p304.action_type ~= nil and p304.action_type ~= 0 or p304.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2971, v2972 = proto.writeTag(buf, n200, 1, proto.wireTypes.varint)

				buf, n200 = proto.writeVarInt(v2971, v2972, t1.ActionType.toNumber(p304.action_type))
			end

			if p304.action_params ~= nil then
				local v2973 = p304.action_params:encode()
				local v2974, v2975 = proto.writeTag(buf, n200, 2, proto.wireTypes.lengthDelimited)

				buf, n200 = proto.writeBuffer(v2974, v2975, v2973, buffer.len(v2973))
			end

			local buf103 = buffer.create(n200)

			buffer.copy(buf103, 0, buf, 0, n200)

			return buf103
		end
		function t403.decode(p305: buffer) -- line: 20136
			-- upvalues: t403 (copy), proto (copy), t1 (copy)
			local v2978 = t403.new()
			local n201 = 0

			while n201 < buffer.len(p305) do
				local v2980, v2981

				v2980, v2981, n201 = proto.readTag(p305, n201)

				if v2981 == proto.wireTypes.varint then
					if v2980 == 1 then
						local v2982

						v2982, n201 = proto.readVarIntI32(p305, n201)
						v2978.action_type = t1.ActionType.fromNumber(v2982) or v2982
					else
						local v2983

						v2983, n201 = proto.readVarInt(p305, n201)
					end
				elseif v2981 == proto.wireTypes.lengthDelimited then
					if v2980 == 2 then
						local v2984

						v2984, n201 = proto.readBuffer(p305, n201)
						v2978.action_params = t1.CustomAnalyticsEventAction_Params.decode(v2984)
					else
						local v2985, v2986 = proto.readVarInt(p305, n201)

						n201 = v2986 + v2985
					end
				elseif v2981 == proto.wireTypes.i32 then
					local v2987

					v2987, n201 = proto.readFixed32(p305, n201)
				elseif v2981 == proto.wireTypes.i64 then
					local v2988

					v2988, n201 = proto.readFixed64(p305, n201)
				else
					error("Unsupported wire type: " .. v2981)
				end
			end

			return v2978
		end
		function t403.jsonEncode(p306) -- line: 20184
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
		function t403.jsonDecode(t406: {[any]: any}) -- line: 20206
			-- upvalues: t403 (copy), t1 (copy)
			local v2992 = t403.new()

			if t406.action_type ~= nil then
				v2992.action_type = if typeof(t406.action_type) ~= "number" then t1.ActionType.fromName(t406.action_type) or t406.action_type else t1.ActionType.fromNumber(t406.action_type) or t406.action_type
			end

			if t406.actionType ~= nil then
				v2992.action_type = if typeof(t406.actionType) ~= "number" then t1.ActionType.fromName(t406.actionType) or t406.actionType else t1.ActionType.fromNumber(t406.actionType) or t406.actionType
			end

			if t406.action_params ~= nil then
				v2992.action_params = t1.CustomAnalyticsEventAction_Params.jsonDecode(t406.action_params)
			end

			if t406.actionParams ~= nil then
				v2992.action_params = t1.CustomAnalyticsEventAction_Params.jsonDecode(t406.actionParams)
			end

			return v2992
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

		function t407.new(t408: {[any]: any}?) -- line: 20246
			-- upvalues: t407 (copy)
			return (setmetatable({
				event_name = if t408 ~= nil and t408.event_name ~= nil then t408.event_name else nil,
				event_fields = if t408 ~= nil and t408.event_fields ~= nil then t408.event_fields else nil
			}, t407))
		end
		function t407.encode(p307) -- line: 20255
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n202 = 0

			if p307.event_name ~= nil then
				local v2997 = p307.event_name:encode()
				local v2998, v2999 = proto.writeTag(buf, n202, 1, proto.wireTypes.lengthDelimited)

				buf, n202 = proto.writeBuffer(v2998, v2999, v2997, buffer.len(v2997))
			end

			if p307.event_fields ~= nil then
				local v3000 = p307.event_fields:encode()
				local v3001, v3002 = proto.writeTag(buf, n202, 2, proto.wireTypes.lengthDelimited)

				buf, n202 = proto.writeBuffer(v3001, v3002, v3000, buffer.len(v3000))
			end

			local buf104 = buffer.create(n202)

			buffer.copy(buf104, 0, buf, 0, n202)

			return buf104
		end
		function t407.decode(p308: buffer) -- line: 20276
			-- upvalues: t407 (copy), proto (copy), prop_types (copy)
			local v3005 = t407.new()
			local n203 = 0

			while n203 < buffer.len(p308) do
				local v3007, v3008

				v3007, v3008, n203 = proto.readTag(p308, n203)

				if v3008 == proto.wireTypes.varint then
					local v3009

					v3009, n203 = proto.readVarInt(p308, n203)
				elseif v3008 == proto.wireTypes.lengthDelimited then
					if v3007 == 1 then
						local v3010

						v3010, n203 = proto.readBuffer(p308, n203)
						v3005.event_name = prop_types.StringProp.decode(v3010)
					elseif v3007 == 2 then
						local v3011

						v3011, n203 = proto.readBuffer(p308, n203)
						v3005.event_fields = prop_types.StructProp.decode(v3011)
					else
						local v3012, v3013 = proto.readVarInt(p308, n203)

						n203 = v3013 + v3012
					end
				elseif v3008 == proto.wireTypes.i32 then
					local v3014

					v3014, n203 = proto.readFixed32(p308, n203)
				elseif v3008 == proto.wireTypes.i64 then
					local v3015

					v3015, n203 = proto.readFixed64(p308, n203)
				else
					error("Unsupported wire type: " .. v3008)
				end
			end

			return v3005
		end
		function t407.jsonEncode(p309) -- line: 20324
			local t409 = {}

			if p309.event_name ~= nil then
				t409.eventName = p309.event_name:jsonEncode()
			end

			if p309.event_fields ~= nil then
				t409.eventFields = p309.event_fields:jsonEncode()
			end

			return t409
		end
		function t407.jsonDecode(t410: {[any]: any}) -- line: 20338
			-- upvalues: t407 (copy), prop_types (copy)
			local v3019 = t407.new()

			if t410.event_name ~= nil then
				v3019.event_name = prop_types.StringProp.jsonDecode(t410.event_name)
			end

			if t410.eventName ~= nil then
				v3019.event_name = prop_types.StringProp.jsonDecode(t410.eventName)
			end

			if t410.event_fields ~= nil then
				v3019.event_fields = prop_types.StructProp.jsonDecode(t410.event_fields)
			end

			if t410.eventFields ~= nil then
				v3019.event_fields = prop_types.StructProp.jsonDecode(t410.eventFields)
			end

			return v3019
		end

		t407.descriptor = {
			name = "CustomAnalyticsEventAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.CustomAnalyticsEventAction_Params = t407
		typeRegistry.default:register(t1.CustomAnalyticsEventAction_Params)

		local t411 = {}

		t411.__index = t411

		function t411.new(t412: {[any]: any}?) -- line: 20378
			-- upvalues: t1 (copy), t411 (copy)
			return (setmetatable({
				action_type = if t412 ~= nil and t412.action_type ~= nil then t412.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t412 ~= nil and t412.action_params ~= nil then t412.action_params else nil
			}, t411))
		end
		function t411.encode(p310) -- line: 20387
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n204 = 0

			if p310.action_type ~= nil and (p310.action_type ~= nil and p310.action_type ~= 0 or p310.action_type ~= t1.ActionType.fromNumber(0)) then
				local v3024, v3025 = proto.writeTag(buf, n204, 1, proto.wireTypes.varint)

				buf, n204 = proto.writeVarInt(v3024, v3025, t1.ActionType.toNumber(p310.action_type))
			end

			if p310.action_params ~= nil then
				local v3026 = p310.action_params:encode()
				local v3027, v3028 = proto.writeTag(buf, n204, 2, proto.wireTypes.lengthDelimited)

				buf, n204 = proto.writeBuffer(v3027, v3028, v3026, buffer.len(v3026))
			end

			local buf105 = buffer.create(n204)

			buffer.copy(buf105, 0, buf, 0, n204)

			return buf105
		end
		function t411.decode(p311: buffer) -- line: 20413
			-- upvalues: t411 (copy), proto (copy), t1 (copy)
			local v3031 = t411.new()
			local n205 = 0

			while n205 < buffer.len(p311) do
				local v3033, v3034

				v3033, v3034, n205 = proto.readTag(p311, n205)

				if v3034 == proto.wireTypes.varint then
					if v3033 == 1 then
						local v3035

						v3035, n205 = proto.readVarIntI32(p311, n205)
						v3031.action_type = t1.ActionType.fromNumber(v3035) or v3035
					else
						local v3036

						v3036, n205 = proto.readVarInt(p311, n205)
					end
				elseif v3034 == proto.wireTypes.lengthDelimited then
					if v3033 == 2 then
						local v3037

						v3037, n205 = proto.readBuffer(p311, n205)
						v3031.action_params = t1.OpenGameInviteAction_Params.decode(v3037)
					else
						local v3038, v3039 = proto.readVarInt(p311, n205)

						n205 = v3039 + v3038
					end
				elseif v3034 == proto.wireTypes.i32 then
					local v3040

					v3040, n205 = proto.readFixed32(p311, n205)
				elseif v3034 == proto.wireTypes.i64 then
					local v3041

					v3041, n205 = proto.readFixed64(p311, n205)
				else
					error("Unsupported wire type: " .. v3034)
				end
			end

			return v3031
		end
		function t411.jsonEncode(p312) -- line: 20461
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
		function t411.jsonDecode(t414: {[any]: any}) -- line: 20483
			-- upvalues: t411 (copy), t1 (copy)
			local v3045 = t411.new()

			if t414.action_type ~= nil then
				v3045.action_type = if typeof(t414.action_type) ~= "number" then t1.ActionType.fromName(t414.action_type) or t414.action_type else t1.ActionType.fromNumber(t414.action_type) or t414.action_type
			end

			if t414.actionType ~= nil then
				v3045.action_type = if typeof(t414.actionType) ~= "number" then t1.ActionType.fromName(t414.actionType) or t414.actionType else t1.ActionType.fromNumber(t414.actionType) or t414.actionType
			end

			if t414.action_params ~= nil then
				v3045.action_params = t1.OpenGameInviteAction_Params.jsonDecode(t414.action_params)
			end

			if t414.actionParams ~= nil then
				v3045.action_params = t1.OpenGameInviteAction_Params.jsonDecode(t414.actionParams)
			end

			return v3045
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

		function t415.new(t416: {[any]: any}?) -- line: 20523
			-- upvalues: t415 (copy)
			return (setmetatable({
				universe_id = if t416 ~= nil and t416.universe_id ~= nil then t416.universe_id else nil,
				root_place_id = if t416 ~= nil and t416.root_place_id ~= nil then t416.root_place_id else nil,
				trigger = if t416 ~= nil and t416.trigger ~= nil then t416.trigger else nil,
				button_name = if t416 ~= nil and t416.button_name ~= nil then t416.button_name else nil
			}, t415))
		end
		function t415.encode(p313) -- line: 20534
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n206 = 0

			if p313.universe_id ~= nil then
				local v3050 = p313.universe_id:encode()
				local v3051, v3052 = proto.writeTag(buf, n206, 1, proto.wireTypes.lengthDelimited)

				buf, n206 = proto.writeBuffer(v3051, v3052, v3050, buffer.len(v3050))
			end

			if p313.root_place_id ~= nil then
				local v3053 = p313.root_place_id:encode()
				local v3054, v3055 = proto.writeTag(buf, n206, 2, proto.wireTypes.lengthDelimited)

				buf, n206 = proto.writeBuffer(v3054, v3055, v3053, buffer.len(v3053))
			end

			if p313.trigger ~= nil then
				local v3056 = p313.trigger:encode()
				local v3057, v3058 = proto.writeTag(buf, n206, 3, proto.wireTypes.lengthDelimited)

				buf, n206 = proto.writeBuffer(v3057, v3058, v3056, buffer.len(v3056))
			end

			if p313.button_name ~= nil then
				local v3059 = p313.button_name:encode()
				local v3060, v3061 = proto.writeTag(buf, n206, 4, proto.wireTypes.lengthDelimited)

				buf, n206 = proto.writeBuffer(v3060, v3061, v3059, buffer.len(v3059))
			end

			local buf106 = buffer.create(n206)

			buffer.copy(buf106, 0, buf, 0, n206)

			return buf106
		end
		function t415.decode(p314: buffer) -- line: 20567
			-- upvalues: t415 (copy), proto (copy), prop_types (copy)
			local v3064 = t415.new()
			local n207 = 0

			while n207 < buffer.len(p314) do
				local v3066, v3067

				v3066, v3067, n207 = proto.readTag(p314, n207)

				if v3067 == proto.wireTypes.varint then
					local v3068

					v3068, n207 = proto.readVarInt(p314, n207)
				elseif v3067 == proto.wireTypes.lengthDelimited then
					if v3066 == 1 then
						local v3069

						v3069, n207 = proto.readBuffer(p314, n207)
						v3064.universe_id = prop_types.StringProp.decode(v3069)
					elseif v3066 == 2 then
						local v3070

						v3070, n207 = proto.readBuffer(p314, n207)
						v3064.root_place_id = prop_types.StringProp.decode(v3070)
					elseif v3066 == 3 then
						local v3071

						v3071, n207 = proto.readBuffer(p314, n207)
						v3064.trigger = prop_types.StringProp.decode(v3071)
					elseif v3066 == 4 then
						local v3072

						v3072, n207 = proto.readBuffer(p314, n207)
						v3064.button_name = prop_types.StringProp.decode(v3072)
					else
						local v3073, v3074 = proto.readVarInt(p314, n207)

						n207 = v3074 + v3073
					end
				elseif v3067 == proto.wireTypes.i32 then
					local v3075

					v3075, n207 = proto.readFixed32(p314, n207)
				elseif v3067 == proto.wireTypes.i64 then
					local v3076

					v3076, n207 = proto.readFixed64(p314, n207)
				else
					error("Unsupported wire type: " .. v3067)
				end
			end

			return v3064
		end
		function t415.jsonEncode(p315) -- line: 20625
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
		function t415.jsonDecode(t418: {[any]: any}) -- line: 20647
			-- upvalues: t415 (copy), prop_types (copy)
			local v3080 = t415.new()

			if t418.universe_id ~= nil then
				v3080.universe_id = prop_types.StringProp.jsonDecode(t418.universe_id)
			end

			if t418.universeId ~= nil then
				v3080.universe_id = prop_types.StringProp.jsonDecode(t418.universeId)
			end

			if t418.root_place_id ~= nil then
				v3080.root_place_id = prop_types.StringProp.jsonDecode(t418.root_place_id)
			end

			if t418.rootPlaceId ~= nil then
				v3080.root_place_id = prop_types.StringProp.jsonDecode(t418.rootPlaceId)
			end

			if t418.trigger ~= nil then
				v3080.trigger = prop_types.StringProp.jsonDecode(t418.trigger)
			end

			if t418.button_name ~= nil then
				v3080.button_name = prop_types.StringProp.jsonDecode(t418.button_name)
			end

			if t418.buttonName ~= nil then
				v3080.button_name = prop_types.StringProp.jsonDecode(t418.buttonName)
			end

			return v3080
		end

		t415.descriptor = {
			name = "OpenGameInviteAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenGameInviteAction_Params = t415
		typeRegistry.default:register(t1.OpenGameInviteAction_Params)

		local t419 = {}

		t419.__index = t419

		function t419.new(t420: {[any]: any}?) -- line: 20699
			-- upvalues: t1 (copy), t419 (copy)
			return (setmetatable({
				action_type = if t420 ~= nil and t420.action_type ~= nil then t420.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t420 ~= nil and t420.action_params ~= nil then t420.action_params else nil
			}, t419))
		end
		function t419.encode(p316) -- line: 20708
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n208 = 0

			if p316.action_type ~= nil and (p316.action_type ~= nil and p316.action_type ~= 0 or p316.action_type ~= t1.ActionType.fromNumber(0)) then
				local v3085, v3086 = proto.writeTag(buf, n208, 1, proto.wireTypes.varint)

				buf, n208 = proto.writeVarInt(v3085, v3086, t1.ActionType.toNumber(p316.action_type))
			end

			if p316.action_params ~= nil then
				local v3087 = p316.action_params:encode()
				local v3088, v3089 = proto.writeTag(buf, n208, 2, proto.wireTypes.lengthDelimited)

				buf, n208 = proto.writeBuffer(v3088, v3089, v3087, buffer.len(v3087))
			end

			local buf107 = buffer.create(n208)

			buffer.copy(buf107, 0, buf, 0, n208)

			return buf107
		end
		function t419.decode(p317: buffer) -- line: 20734
			-- upvalues: t419 (copy), proto (copy), t1 (copy)
			local v3092 = t419.new()
			local n209 = 0

			while n209 < buffer.len(p317) do
				local v3094, v3095

				v3094, v3095, n209 = proto.readTag(p317, n209)

				if v3095 == proto.wireTypes.varint then
					if v3094 == 1 then
						local v3096

						v3096, n209 = proto.readVarIntI32(p317, n209)
						v3092.action_type = t1.ActionType.fromNumber(v3096) or v3096
					else
						local v3097

						v3097, n209 = proto.readVarInt(p317, n209)
					end
				elseif v3095 == proto.wireTypes.lengthDelimited then
					if v3094 == 2 then
						local v3098

						v3098, n209 = proto.readBuffer(p317, n209)
						v3092.action_params = t1.LaunchExperienceAction_Params.decode(v3098)
					else
						local v3099, v3100 = proto.readVarInt(p317, n209)

						n209 = v3100 + v3099
					end
				elseif v3095 == proto.wireTypes.i32 then
					local v3101

					v3101, n209 = proto.readFixed32(p317, n209)
				elseif v3095 == proto.wireTypes.i64 then
					local v3102

					v3102, n209 = proto.readFixed64(p317, n209)
				else
					error("Unsupported wire type: " .. v3095)
				end
			end

			return v3092
		end
		function t419.jsonEncode(p318) -- line: 20782
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
		function t419.jsonDecode(t422: {[any]: any}) -- line: 20804
			-- upvalues: t419 (copy), t1 (copy)
			local v3106 = t419.new()

			if t422.action_type ~= nil then
				v3106.action_type = if typeof(t422.action_type) ~= "number" then t1.ActionType.fromName(t422.action_type) or t422.action_type else t1.ActionType.fromNumber(t422.action_type) or t422.action_type
			end

			if t422.actionType ~= nil then
				v3106.action_type = if typeof(t422.actionType) ~= "number" then t1.ActionType.fromName(t422.actionType) or t422.actionType else t1.ActionType.fromNumber(t422.actionType) or t422.actionType
			end

			if t422.action_params ~= nil then
				v3106.action_params = t1.LaunchExperienceAction_Params.jsonDecode(t422.action_params)
			end

			if t422.actionParams ~= nil then
				v3106.action_params = t1.LaunchExperienceAction_Params.jsonDecode(t422.actionParams)
			end

			return v3106
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

		function t423.new(t424: {[any]: any}?) -- line: 20844
			-- upvalues: t423 (copy)
			return (setmetatable({
				kind = if t424 ~= nil and t424.kind ~= nil then t424.kind else nil
			}, t423))
		end
		function t423.encode(p319) -- line: 20852
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n210 = 0

			if p319.kind ~= nil then
				if p319.kind.type == "literal" then
					local v3111 = p319.kind.value:encode()
					local v3112, v3113 = proto.writeTag(buf, n210, 1, proto.wireTypes.lengthDelimited)

					buf, n210 = proto.writeBuffer(v3112, v3113, v3111, buffer.len(v3111))
				elseif p319.kind.type == "binding_path" then
					local v3114, v3115 = proto.writeTag(buf, n210, 2, proto.wireTypes.lengthDelimited)

					buf, n210 = proto.writeString(v3114, v3115, p319.kind.value)
				end
			end

			local buf108 = buffer.create(n210)

			buffer.copy(buf108, 0, buf, 0, n210)

			return buf108
		end
		function t423.decode(p320: buffer) -- line: 20874
			-- upvalues: t423 (copy), proto (copy), t1 (copy)
			local v3118 = t423.new()
			local n211 = 0

			while n211 < buffer.len(p320) do
				local v3120, v3121

				v3120, v3121, n211 = proto.readTag(p320, n211)

				if v3121 == proto.wireTypes.varint then
					local v3122

					v3122, n211 = proto.readVarInt(p320, n211)
				elseif v3121 == proto.wireTypes.lengthDelimited then
					if v3120 == 1 then
						local v3123

						v3123, n211 = proto.readBuffer(p320, n211)
						v3118.kind = {
							type = "literal",
							value = t1.LaunchExperienceAction_ExperienceJoinData_ExperienceJoinDataLiteral.decode(v3123)
						}
					elseif v3120 == 2 then
						local v3124

						v3124, n211 = proto.readBuffer(p320, n211)
						v3118.kind = {
							type = "binding_path",
							value = buffer.tostring(v3124)
						}
					else
						local v3125, v3126 = proto.readVarInt(p320, n211)

						n211 = v3126 + v3125
					end
				elseif v3121 == proto.wireTypes.i32 then
					local v3127

					v3127, n211 = proto.readFixed32(p320, n211)
				elseif v3121 == proto.wireTypes.i64 then
					local v3128

					v3128, n211 = proto.readFixed64(p320, n211)
				else
					error("Unsupported wire type: " .. v3121)
				end
			end

			return v3118
		end
		function t423.jsonEncode(p321) -- line: 20929
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
		function t423.jsonDecode(t426: {[any]: any}) -- line: 20945
			-- upvalues: t423 (copy), t1 (copy)
			local v3132 = t423.new()

			if t426.literal ~= nil then
				v3132.kind = {
					type = "literal",
					value = t1.LaunchExperienceAction_ExperienceJoinData_ExperienceJoinDataLiteral.jsonDecode(t426.literal)
				}
			end

			if t426.binding_path ~= nil then
				v3132.kind = {
					type = "binding_path",
					value = t426.binding_path
				}
			end

			if t426.bindingPath ~= nil then
				v3132.kind = {
					type = "binding_path",
					value = t426.bindingPath
				}
			end

			return v3132
		end

		t423.descriptor = {
			name = "LaunchExperienceAction_ExperienceJoinData",
			fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceJoinData"
		}
		t1.LaunchExperienceAction_ExperienceJoinData = t423
		typeRegistry.default:register(t1.LaunchExperienceAction_ExperienceJoinData)

		local t427 = {}

		t427.__index = t427

		function t427.new(t428: {[any]: any}?) -- line: 20985
			-- upvalues: t427 (copy)
			return (setmetatable({
				launch_data = if t428 ~= nil and t428.launch_data ~= nil then t428.launch_data else nil,
				event_id = if t428 ~= nil and t428.event_id ~= nil then t428.event_id else nil
			}, t427))
		end
		function t427.encode(p322) -- line: 20997
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n212 = 0

			if p322.launch_data ~= nil then
				local v3137 = p322.launch_data:encode()
				local v3138, v3139 = proto.writeTag(buf, n212, 1, proto.wireTypes.lengthDelimited)

				buf, n212 = proto.writeBuffer(v3138, v3139, v3137, buffer.len(v3137))
			end

			if p322.event_id ~= nil then
				local v3140 = p322.event_id:encode()
				local v3141, v3142 = proto.writeTag(buf, n212, 2, proto.wireTypes.lengthDelimited)

				buf, n212 = proto.writeBuffer(v3141, v3142, v3140, buffer.len(v3140))
			end

			local buf109 = buffer.create(n212)

			buffer.copy(buf109, 0, buf, 0, n212)

			return buf109
		end
		function t427.decode(p323: buffer) -- line: 21020
			-- upvalues: t427 (copy), proto (copy), prop_types (copy)
			local v3145 = t427.new()
			local n213 = 0

			while n213 < buffer.len(p323) do
				local v3147, v3148

				v3147, v3148, n213 = proto.readTag(p323, n213)

				if v3148 == proto.wireTypes.varint then
					local v3149

					v3149, n213 = proto.readVarInt(p323, n213)
				elseif v3148 == proto.wireTypes.lengthDelimited then
					if v3147 == 1 then
						local v3150

						v3150, n213 = proto.readBuffer(p323, n213)
						v3145.launch_data = prop_types.StringProp.decode(v3150)
					elseif v3147 == 2 then
						local v3151

						v3151, n213 = proto.readBuffer(p323, n213)
						v3145.event_id = prop_types.StringProp.decode(v3151)
					else
						local v3152, v3153 = proto.readVarInt(p323, n213)

						n213 = v3153 + v3152
					end
				elseif v3148 == proto.wireTypes.i32 then
					local v3154

					v3154, n213 = proto.readFixed32(p323, n213)
				elseif v3148 == proto.wireTypes.i64 then
					local v3155

					v3155, n213 = proto.readFixed64(p323, n213)
				else
					error("Unsupported wire type: " .. v3148)
				end
			end

			return v3145
		end
		function t427.jsonEncode(p324) -- line: 21070
			local t429 = {}

			if p324.launch_data ~= nil then
				t429.launchData = p324.launch_data:jsonEncode()
			end

			if p324.event_id ~= nil then
				t429.eventId = p324.event_id:jsonEncode()
			end

			return t429
		end
		function t427.jsonDecode(t430: {[any]: any}) -- line: 21086
			-- upvalues: t427 (copy), prop_types (copy)
			local v3159 = t427.new()

			if t430.launch_data ~= nil then
				v3159.launch_data = prop_types.StringProp.jsonDecode(t430.launch_data)
			end

			if t430.launchData ~= nil then
				v3159.launch_data = prop_types.StringProp.jsonDecode(t430.launchData)
			end

			if t430.event_id ~= nil then
				v3159.event_id = prop_types.StringProp.jsonDecode(t430.event_id)
			end

			if t430.eventId ~= nil then
				v3159.event_id = prop_types.StringProp.jsonDecode(t430.eventId)
			end

			return v3159
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

		function t431.new(t432: {[any]: any}?) -- line: 21126
			-- upvalues: t431 (copy)
			return (setmetatable({
				place_id = if t432 ~= nil and t432.place_id ~= nil then t432.place_id else nil,
				universe_id = if t432 ~= nil and t432.universe_id ~= nil then t432.universe_id else nil,
				launch_source = if t432 ~= nil and t432.launch_source ~= nil then t432.launch_source else nil,
				experience_join_data = if t432 ~= nil and t432.experience_join_data ~= nil then t432.experience_join_data else nil
			}, t431))
		end
		function t431.encode(p325) -- line: 21139
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n214 = 0

			if p325.place_id ~= nil then
				local v3164 = p325.place_id:encode()
				local v3165, v3166 = proto.writeTag(buf, n214, 1, proto.wireTypes.lengthDelimited)

				buf, n214 = proto.writeBuffer(v3165, v3166, v3164, buffer.len(v3164))
			end

			if p325.universe_id ~= nil then
				local v3167 = p325.universe_id:encode()
				local v3168, v3169 = proto.writeTag(buf, n214, 2, proto.wireTypes.lengthDelimited)

				buf, n214 = proto.writeBuffer(v3168, v3169, v3167, buffer.len(v3167))
			end

			if p325.launch_source ~= nil then
				local v3170 = p325.launch_source:encode()
				local v3171, v3172 = proto.writeTag(buf, n214, 3, proto.wireTypes.lengthDelimited)

				buf, n214 = proto.writeBuffer(v3171, v3172, v3170, buffer.len(v3170))
			end

			if p325.experience_join_data ~= nil then
				local v3173 = p325.experience_join_data:encode()
				local v3174, v3175 = proto.writeTag(buf, n214, 4, proto.wireTypes.lengthDelimited)

				buf, n214 = proto.writeBuffer(v3174, v3175, v3173, buffer.len(v3173))
			end

			local buf110 = buffer.create(n214)

			buffer.copy(buf110, 0, buf, 0, n214)

			return buf110
		end
		function t431.decode(p326: buffer) -- line: 21172
			-- upvalues: t431 (copy), proto (copy), prop_types (copy), t1 (copy)
			local v3178 = t431.new()
			local n215 = 0

			while n215 < buffer.len(p326) do
				local v3180, v3181

				v3180, v3181, n215 = proto.readTag(p326, n215)

				if v3181 == proto.wireTypes.varint then
					local v3182

					v3182, n215 = proto.readVarInt(p326, n215)
				elseif v3181 == proto.wireTypes.lengthDelimited then
					if v3180 == 1 then
						local v3183

						v3183, n215 = proto.readBuffer(p326, n215)
						v3178.place_id = prop_types.StringProp.decode(v3183)
					elseif v3180 == 2 then
						local v3184

						v3184, n215 = proto.readBuffer(p326, n215)
						v3178.universe_id = prop_types.StringProp.decode(v3184)
					elseif v3180 == 3 then
						local v3185

						v3185, n215 = proto.readBuffer(p326, n215)
						v3178.launch_source = prop_types.StringProp.decode(v3185)
					elseif v3180 == 4 then
						local v3186

						v3186, n215 = proto.readBuffer(p326, n215)
						v3178.experience_join_data = t1.LaunchExperienceAction_ExperienceJoinData.decode(v3186)
					else
						local v3187, v3188 = proto.readVarInt(p326, n215)

						n215 = v3188 + v3187
					end
				elseif v3181 == proto.wireTypes.i32 then
					local v3189

					v3189, n215 = proto.readFixed32(p326, n215)
				elseif v3181 == proto.wireTypes.i64 then
					local v3190

					v3190, n215 = proto.readFixed64(p326, n215)
				else
					error("Unsupported wire type: " .. v3181)
				end
			end

			return v3178
		end
		function t431.jsonEncode(p327) -- line: 21230
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
		function t431.jsonDecode(t434: {[any]: any}) -- line: 21252
			-- upvalues: t431 (copy), prop_types (copy), t1 (copy)
			local v3194 = t431.new()

			if t434.place_id ~= nil then
				v3194.place_id = prop_types.StringProp.jsonDecode(t434.place_id)
			end

			if t434.placeId ~= nil then
				v3194.place_id = prop_types.StringProp.jsonDecode(t434.placeId)
			end

			if t434.universe_id ~= nil then
				v3194.universe_id = prop_types.StringProp.jsonDecode(t434.universe_id)
			end

			if t434.universeId ~= nil then
				v3194.universe_id = prop_types.StringProp.jsonDecode(t434.universeId)
			end

			if t434.launch_source ~= nil then
				v3194.launch_source = prop_types.StringProp.jsonDecode(t434.launch_source)
			end

			if t434.launchSource ~= nil then
				v3194.launch_source = prop_types.StringProp.jsonDecode(t434.launchSource)
			end

			if t434.experience_join_data ~= nil then
				v3194.experience_join_data = t1.LaunchExperienceAction_ExperienceJoinData.jsonDecode(t434.experience_join_data)
			end

			if t434.experienceJoinData ~= nil then
				v3194.experience_join_data = t1.LaunchExperienceAction_ExperienceJoinData.jsonDecode(t434.experienceJoinData)
			end

			return v3194
		end

		t431.descriptor = {
			name = "LaunchExperienceAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.LaunchExperienceAction_Params = t431
		typeRegistry.default:register(t1.LaunchExperienceAction_Params)

		local t435 = {}

		t435.__index = t435

		function t435.new(t436: {[any]: any}?) -- line: 21309
			-- upvalues: t1 (copy), t435 (copy)
			return (setmetatable({
				action_type = if t436 ~= nil and t436.action_type ~= nil then t436.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t436 ~= nil and t436.action_params ~= nil then t436.action_params else nil
			}, t435))
		end
		function t435.encode(p328) -- line: 21320
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n216 = 0

			if p328.action_type ~= nil and (p328.action_type ~= nil and p328.action_type ~= 0 or p328.action_type ~= t1.ActionType.fromNumber(0)) then
				local v3199, v3200 = proto.writeTag(buf, n216, 1, proto.wireTypes.varint)

				buf, n216 = proto.writeVarInt(v3199, v3200, t1.ActionType.toNumber(p328.action_type))
			end

			if p328.action_params ~= nil then
				local v3201 = p328.action_params:encode()
				local v3202, v3203 = proto.writeTag(buf, n216, 2, proto.wireTypes.lengthDelimited)

				buf, n216 = proto.writeBuffer(v3202, v3203, v3201, buffer.len(v3201))
			end

			local buf111 = buffer.create(n216)

			buffer.copy(buf111, 0, buf, 0, n216)

			return buf111
		end
		function t435.decode(p329: buffer) -- line: 21346
			-- upvalues: t435 (copy), proto (copy), t1 (copy)
			local v3206 = t435.new()
			local n217 = 0

			while n217 < buffer.len(p329) do
				local v3208, v3209

				v3208, v3209, n217 = proto.readTag(p329, n217)

				if v3209 == proto.wireTypes.varint then
					if v3208 == 1 then
						local v3210

						v3210, n217 = proto.readVarIntI32(p329, n217)
						v3206.action_type = t1.ActionType.fromNumber(v3210) or v3210
					else
						local v3211

						v3211, n217 = proto.readVarInt(p329, n217)
					end
				elseif v3209 == proto.wireTypes.lengthDelimited then
					if v3208 == 2 then
						local v3212

						v3212, n217 = proto.readBuffer(p329, n217)
						v3206.action_params = t1.ToggleExperienceFavoriteAction_Params.decode(v3212)
					else
						local v3213, v3214 = proto.readVarInt(p329, n217)

						n217 = v3214 + v3213
					end
				elseif v3209 == proto.wireTypes.i32 then
					local v3215

					v3215, n217 = proto.readFixed32(p329, n217)
				elseif v3209 == proto.wireTypes.i64 then
					local v3216

					v3216, n217 = proto.readFixed64(p329, n217)
				else
					error("Unsupported wire type: " .. v3209)
				end
			end

			return v3206
		end
		function t435.jsonEncode(p330) -- line: 21394
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
		function t435.jsonDecode(t438: {[any]: any}) -- line: 21416
			-- upvalues: t435 (copy), t1 (copy)
			local v3220 = t435.new()

			if t438.action_type ~= nil then
				v3220.action_type = if typeof(t438.action_type) ~= "number" then t1.ActionType.fromName(t438.action_type) or t438.action_type else t1.ActionType.fromNumber(t438.action_type) or t438.action_type
			end

			if t438.actionType ~= nil then
				v3220.action_type = if typeof(t438.actionType) ~= "number" then t1.ActionType.fromName(t438.actionType) or t438.actionType else t1.ActionType.fromNumber(t438.actionType) or t438.actionType
			end

			if t438.action_params ~= nil then
				v3220.action_params = t1.ToggleExperienceFavoriteAction_Params.jsonDecode(t438.action_params)
			end

			if t438.actionParams ~= nil then
				v3220.action_params = t1.ToggleExperienceFavoriteAction_Params.jsonDecode(t438.actionParams)
			end

			return v3220
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

		function t439.new(t440: {[any]: any}?) -- line: 21456
			-- upvalues: t439 (copy)
			return (setmetatable({
				universe_id = if t440 ~= nil and t440.universe_id ~= nil then t440.universe_id else nil,
				place_id = if t440 ~= nil and t440.place_id ~= nil then t440.place_id else nil,
				ctx = if t440 ~= nil and t440.ctx ~= nil then t440.ctx else nil
			}, t439))
		end
		function t439.encode(p331) -- line: 21466
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n218 = 0

			if p331.universe_id ~= nil then
				local v3225 = p331.universe_id:encode()
				local v3226, v3227 = proto.writeTag(buf, n218, 1, proto.wireTypes.lengthDelimited)

				buf, n218 = proto.writeBuffer(v3226, v3227, v3225, buffer.len(v3225))
			end

			if p331.place_id ~= nil then
				local v3228 = p331.place_id:encode()
				local v3229, v3230 = proto.writeTag(buf, n218, 2, proto.wireTypes.lengthDelimited)

				buf, n218 = proto.writeBuffer(v3229, v3230, v3228, buffer.len(v3228))
			end

			if p331.ctx ~= nil then
				local v3231 = p331.ctx:encode()
				local v3232, v3233 = proto.writeTag(buf, n218, 3, proto.wireTypes.lengthDelimited)

				buf, n218 = proto.writeBuffer(v3232, v3233, v3231, buffer.len(v3231))
			end

			local buf112 = buffer.create(n218)

			buffer.copy(buf112, 0, buf, 0, n218)

			return buf112
		end
		function t439.decode(p332: buffer) -- line: 21493
			-- upvalues: t439 (copy), proto (copy), prop_types (copy)
			local v3236 = t439.new()
			local n219 = 0

			while n219 < buffer.len(p332) do
				local v3238, v3239

				v3238, v3239, n219 = proto.readTag(p332, n219)

				if v3239 == proto.wireTypes.varint then
					local v3240

					v3240, n219 = proto.readVarInt(p332, n219)
				elseif v3239 == proto.wireTypes.lengthDelimited then
					if v3238 == 1 then
						local v3241

						v3241, n219 = proto.readBuffer(p332, n219)
						v3236.universe_id = prop_types.StringProp.decode(v3241)
					elseif v3238 == 2 then
						local v3242

						v3242, n219 = proto.readBuffer(p332, n219)
						v3236.place_id = prop_types.StringProp.decode(v3242)
					elseif v3238 == 3 then
						local v3243

						v3243, n219 = proto.readBuffer(p332, n219)
						v3236.ctx = prop_types.StringProp.decode(v3243)
					else
						local v3244, v3245 = proto.readVarInt(p332, n219)

						n219 = v3245 + v3244
					end
				elseif v3239 == proto.wireTypes.i32 then
					local v3246

					v3246, n219 = proto.readFixed32(p332, n219)
				elseif v3239 == proto.wireTypes.i64 then
					local v3247

					v3247, n219 = proto.readFixed64(p332, n219)
				else
					error("Unsupported wire type: " .. v3239)
				end
			end

			return v3236
		end
		function t439.jsonEncode(p333) -- line: 21546
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
		function t439.jsonDecode(t442: {[any]: any}) -- line: 21564
			-- upvalues: t439 (copy), prop_types (copy)
			local v3251 = t439.new()

			if t442.universe_id ~= nil then
				v3251.universe_id = prop_types.StringProp.jsonDecode(t442.universe_id)
			end

			if t442.universeId ~= nil then
				v3251.universe_id = prop_types.StringProp.jsonDecode(t442.universeId)
			end

			if t442.place_id ~= nil then
				v3251.place_id = prop_types.StringProp.jsonDecode(t442.place_id)
			end

			if t442.placeId ~= nil then
				v3251.place_id = prop_types.StringProp.jsonDecode(t442.placeId)
			end

			if t442.ctx ~= nil then
				v3251.ctx = prop_types.StringProp.jsonDecode(t442.ctx)
			end

			return v3251
		end

		t439.descriptor = {
			name = "ToggleExperienceFavoriteAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.ToggleExperienceFavoriteAction_Params = t439
		typeRegistry.default:register(t1.ToggleExperienceFavoriteAction_Params)

		local t443 = {}

		t443.__index = t443

		function t443.new(t444: {[any]: any}?) -- line: 21607
			-- upvalues: t1 (copy), t443 (copy)
			return (setmetatable({
				action_type = if t444 ~= nil and t444.action_type ~= nil then t444.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t444 ~= nil and t444.action_params ~= nil then t444.action_params else nil
			}, t443))
		end
		function t443.encode(p334) -- line: 21618
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n220 = 0

			if p334.action_type ~= nil and (p334.action_type ~= nil and p334.action_type ~= 0 or p334.action_type ~= t1.ActionType.fromNumber(0)) then
				local v3256, v3257 = proto.writeTag(buf, n220, 1, proto.wireTypes.varint)

				buf, n220 = proto.writeVarInt(v3256, v3257, t1.ActionType.toNumber(p334.action_type))
			end

			if p334.action_params ~= nil then
				local v3258 = p334.action_params:encode()
				local v3259, v3260 = proto.writeTag(buf, n220, 2, proto.wireTypes.lengthDelimited)

				buf, n220 = proto.writeBuffer(v3259, v3260, v3258, buffer.len(v3258))
			end

			local buf113 = buffer.create(n220)

			buffer.copy(buf113, 0, buf, 0, n220)

			return buf113
		end
		function t443.decode(p335: buffer) -- line: 21644
			-- upvalues: t443 (copy), proto (copy), t1 (copy)
			local v3263 = t443.new()
			local n221 = 0

			while n221 < buffer.len(p335) do
				local v3265, v3266

				v3265, v3266, n221 = proto.readTag(p335, n221)

				if v3266 == proto.wireTypes.varint then
					if v3265 == 1 then
						local v3267

						v3267, n221 = proto.readVarIntI32(p335, n221)
						v3263.action_type = t1.ActionType.fromNumber(v3267) or v3267
					else
						local v3268

						v3268, n221 = proto.readVarInt(p335, n221)
					end
				elseif v3266 == proto.wireTypes.lengthDelimited then
					if v3265 == 2 then
						local v3269

						v3269, n221 = proto.readBuffer(p335, n221)
						v3263.action_params = t1.ToggleExperienceFollowAction_Params.decode(v3269)
					else
						local v3270, v3271 = proto.readVarInt(p335, n221)

						n221 = v3271 + v3270
					end
				elseif v3266 == proto.wireTypes.i32 then
					local v3272

					v3272, n221 = proto.readFixed32(p335, n221)
				elseif v3266 == proto.wireTypes.i64 then
					local v3273

					v3273, n221 = proto.readFixed64(p335, n221)
				else
					error("Unsupported wire type: " .. v3266)
				end
			end

			return v3263
		end
		function t443.jsonEncode(p336) -- line: 21692
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
		function t443.jsonDecode(t446: {[any]: any}) -- line: 21714
			-- upvalues: t443 (copy), t1 (copy)
			local v3277 = t443.new()

			if t446.action_type ~= nil then
				v3277.action_type = if typeof(t446.action_type) ~= "number" then t1.ActionType.fromName(t446.action_type) or t446.action_type else t1.ActionType.fromNumber(t446.action_type) or t446.action_type
			end

			if t446.actionType ~= nil then
				v3277.action_type = if typeof(t446.actionType) ~= "number" then t1.ActionType.fromName(t446.actionType) or t446.actionType else t1.ActionType.fromNumber(t446.actionType) or t446.actionType
			end

			if t446.action_params ~= nil then
				v3277.action_params = t1.ToggleExperienceFollowAction_Params.jsonDecode(t446.action_params)
			end

			if t446.actionParams ~= nil then
				v3277.action_params = t1.ToggleExperienceFollowAction_Params.jsonDecode(t446.actionParams)
			end

			return v3277
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

		function t447.new(t448: {[any]: any}?) -- line: 21754
			-- upvalues: t447 (copy)
			return (setmetatable({
				universe_id = if t448 ~= nil and t448.universe_id ~= nil then t448.universe_id else nil,
				game_name = if t448 ~= nil and t448.game_name ~= nil then t448.game_name else nil,
				ctx = if t448 ~= nil and t448.ctx ~= nil then t448.ctx else nil
			}, t447))
		end
		function t447.encode(p337) -- line: 21764
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n222 = 0

			if p337.universe_id ~= nil then
				local v3282 = p337.universe_id:encode()
				local v3283, v3284 = proto.writeTag(buf, n222, 1, proto.wireTypes.lengthDelimited)

				buf, n222 = proto.writeBuffer(v3283, v3284, v3282, buffer.len(v3282))
			end

			if p337.game_name ~= nil then
				local v3285 = p337.game_name:encode()
				local v3286, v3287 = proto.writeTag(buf, n222, 2, proto.wireTypes.lengthDelimited)

				buf, n222 = proto.writeBuffer(v3286, v3287, v3285, buffer.len(v3285))
			end

			if p337.ctx ~= nil then
				local v3288 = p337.ctx:encode()
				local v3289, v3290 = proto.writeTag(buf, n222, 3, proto.wireTypes.lengthDelimited)

				buf, n222 = proto.writeBuffer(v3289, v3290, v3288, buffer.len(v3288))
			end

			local buf114 = buffer.create(n222)

			buffer.copy(buf114, 0, buf, 0, n222)

			return buf114
		end
		function t447.decode(p338: buffer) -- line: 21791
			-- upvalues: t447 (copy), proto (copy), prop_types (copy)
			local v3293 = t447.new()
			local n223 = 0

			while n223 < buffer.len(p338) do
				local v3295, v3296

				v3295, v3296, n223 = proto.readTag(p338, n223)

				if v3296 == proto.wireTypes.varint then
					local v3297

					v3297, n223 = proto.readVarInt(p338, n223)
				elseif v3296 == proto.wireTypes.lengthDelimited then
					if v3295 == 1 then
						local v3298

						v3298, n223 = proto.readBuffer(p338, n223)
						v3293.universe_id = prop_types.StringProp.decode(v3298)
					elseif v3295 == 2 then
						local v3299

						v3299, n223 = proto.readBuffer(p338, n223)
						v3293.game_name = prop_types.StringProp.decode(v3299)
					elseif v3295 == 3 then
						local v3300

						v3300, n223 = proto.readBuffer(p338, n223)
						v3293.ctx = prop_types.StringProp.decode(v3300)
					else
						local v3301, v3302 = proto.readVarInt(p338, n223)

						n223 = v3302 + v3301
					end
				elseif v3296 == proto.wireTypes.i32 then
					local v3303

					v3303, n223 = proto.readFixed32(p338, n223)
				elseif v3296 == proto.wireTypes.i64 then
					local v3304

					v3304, n223 = proto.readFixed64(p338, n223)
				else
					error("Unsupported wire type: " .. v3296)
				end
			end

			return v3293
		end
		function t447.jsonEncode(p339) -- line: 21844
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
		function t447.jsonDecode(t450: {[any]: any}) -- line: 21862
			-- upvalues: t447 (copy), prop_types (copy)
			local v3308 = t447.new()

			if t450.universe_id ~= nil then
				v3308.universe_id = prop_types.StringProp.jsonDecode(t450.universe_id)
			end

			if t450.universeId ~= nil then
				v3308.universe_id = prop_types.StringProp.jsonDecode(t450.universeId)
			end

			if t450.game_name ~= nil then
				v3308.game_name = prop_types.StringProp.jsonDecode(t450.game_name)
			end

			if t450.gameName ~= nil then
				v3308.game_name = prop_types.StringProp.jsonDecode(t450.gameName)
			end

			if t450.ctx ~= nil then
				v3308.ctx = prop_types.StringProp.jsonDecode(t450.ctx)
			end

			return v3308
		end

		t447.descriptor = {
			name = "ToggleExperienceFollowAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.ToggleExperienceFollowAction_Params = t447
		typeRegistry.default:register(t1.ToggleExperienceFollowAction_Params)

		local t451 = {}

		t451.__index = t451

		function t451.new(t452: {[any]: any}?) -- line: 21905
			-- upvalues: t1 (copy), t451 (copy)
			return (setmetatable({
				action_type = if t452 ~= nil and t452.action_type ~= nil then t452.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t452 ~= nil and t452.action_params ~= nil then t452.action_params else nil
			}, t451))
		end
		function t451.encode(p340) -- line: 21916
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n224 = 0

			if p340.action_type ~= nil and (p340.action_type ~= nil and p340.action_type ~= 0 or p340.action_type ~= t1.ActionType.fromNumber(0)) then
				local v3313, v3314 = proto.writeTag(buf, n224, 1, proto.wireTypes.varint)

				buf, n224 = proto.writeVarInt(v3313, v3314, t1.ActionType.toNumber(p340.action_type))
			end

			if p340.action_params ~= nil then
				local v3315 = p340.action_params:encode()
				local v3316, v3317 = proto.writeTag(buf, n224, 2, proto.wireTypes.lengthDelimited)

				buf, n224 = proto.writeBuffer(v3316, v3317, v3315, buffer.len(v3315))
			end

			local buf115 = buffer.create(n224)

			buffer.copy(buf115, 0, buf, 0, n224)

			return buf115
		end
		function t451.decode(p341: buffer) -- line: 21942
			-- upvalues: t451 (copy), proto (copy), t1 (copy)
			local v3320 = t451.new()
			local n225 = 0

			while n225 < buffer.len(p341) do
				local v3322, v3323

				v3322, v3323, n225 = proto.readTag(p341, n225)

				if v3323 == proto.wireTypes.varint then
					if v3322 == 1 then
						local v3324

						v3324, n225 = proto.readVarIntI32(p341, n225)
						v3320.action_type = t1.ActionType.fromNumber(v3324) or v3324
					else
						local v3325

						v3325, n225 = proto.readVarInt(p341, n225)
					end
				elseif v3323 == proto.wireTypes.lengthDelimited then
					if v3322 == 2 then
						local v3326

						v3326, n225 = proto.readBuffer(p341, n225)
						v3320.action_params = t1.ToggleExperienceVoteAction_Params.decode(v3326)
					else
						local v3327, v3328 = proto.readVarInt(p341, n225)

						n225 = v3328 + v3327
					end
				elseif v3323 == proto.wireTypes.i32 then
					local v3329

					v3329, n225 = proto.readFixed32(p341, n225)
				elseif v3323 == proto.wireTypes.i64 then
					local v3330

					v3330, n225 = proto.readFixed64(p341, n225)
				else
					error("Unsupported wire type: " .. v3323)
				end
			end

			return v3320
		end
		function t451.jsonEncode(p342) -- line: 21990
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
		function t451.jsonDecode(t454: {[any]: any}) -- line: 22012
			-- upvalues: t451 (copy), t1 (copy)
			local v3334 = t451.new()

			if t454.action_type ~= nil then
				v3334.action_type = if typeof(t454.action_type) ~= "number" then t1.ActionType.fromName(t454.action_type) or t454.action_type else t1.ActionType.fromNumber(t454.action_type) or t454.action_type
			end

			if t454.actionType ~= nil then
				v3334.action_type = if typeof(t454.actionType) ~= "number" then t1.ActionType.fromName(t454.actionType) or t454.actionType else t1.ActionType.fromNumber(t454.actionType) or t454.actionType
			end

			if t454.action_params ~= nil then
				v3334.action_params = t1.ToggleExperienceVoteAction_Params.jsonDecode(t454.action_params)
			end

			if t454.actionParams ~= nil then
				v3334.action_params = t1.ToggleExperienceVoteAction_Params.jsonDecode(t454.actionParams)
			end

			return v3334
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

		function t455.new(t456: {[any]: any}?) -- line: 22052
			-- upvalues: t455 (copy)
			return (setmetatable({
				universe_id = if t456 ~= nil and t456.universe_id ~= nil then t456.universe_id else nil,
				vote_direction = if t456 ~= nil and t456.vote_direction ~= nil then t456.vote_direction else nil,
				place_id = if t456 ~= nil and t456.place_id ~= nil then t456.place_id else nil,
				ctx = if t456 ~= nil and t456.ctx ~= nil then t456.ctx else nil
			}, t455))
		end
		function t455.encode(p343) -- line: 22063
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n226 = 0

			if p343.universe_id ~= nil then
				local v3339 = p343.universe_id:encode()
				local v3340, v3341 = proto.writeTag(buf, n226, 1, proto.wireTypes.lengthDelimited)

				buf, n226 = proto.writeBuffer(v3340, v3341, v3339, buffer.len(v3339))
			end

			if p343.vote_direction ~= nil then
				local v3342 = p343.vote_direction:encode()
				local v3343, v3344 = proto.writeTag(buf, n226, 2, proto.wireTypes.lengthDelimited)

				buf, n226 = proto.writeBuffer(v3343, v3344, v3342, buffer.len(v3342))
			end

			if p343.place_id ~= nil then
				local v3345 = p343.place_id:encode()
				local v3346, v3347 = proto.writeTag(buf, n226, 3, proto.wireTypes.lengthDelimited)

				buf, n226 = proto.writeBuffer(v3346, v3347, v3345, buffer.len(v3345))
			end

			if p343.ctx ~= nil then
				local v3348 = p343.ctx:encode()
				local v3349, v3350 = proto.writeTag(buf, n226, 4, proto.wireTypes.lengthDelimited)

				buf, n226 = proto.writeBuffer(v3349, v3350, v3348, buffer.len(v3348))
			end

			local buf116 = buffer.create(n226)

			buffer.copy(buf116, 0, buf, 0, n226)

			return buf116
		end
		function t455.decode(p344: buffer) -- line: 22096
			-- upvalues: t455 (copy), proto (copy), prop_types (copy)
			local v3353 = t455.new()
			local n227 = 0

			while n227 < buffer.len(p344) do
				local v3355, v3356

				v3355, v3356, n227 = proto.readTag(p344, n227)

				if v3356 == proto.wireTypes.varint then
					local v3357

					v3357, n227 = proto.readVarInt(p344, n227)
				elseif v3356 == proto.wireTypes.lengthDelimited then
					if v3355 == 1 then
						local v3358

						v3358, n227 = proto.readBuffer(p344, n227)
						v3353.universe_id = prop_types.StringProp.decode(v3358)
					elseif v3355 == 2 then
						local v3359

						v3359, n227 = proto.readBuffer(p344, n227)
						v3353.vote_direction = prop_types.BoolProp.decode(v3359)
					elseif v3355 == 3 then
						local v3360

						v3360, n227 = proto.readBuffer(p344, n227)
						v3353.place_id = prop_types.StringProp.decode(v3360)
					elseif v3355 == 4 then
						local v3361

						v3361, n227 = proto.readBuffer(p344, n227)
						v3353.ctx = prop_types.StringProp.decode(v3361)
					else
						local v3362, v3363 = proto.readVarInt(p344, n227)

						n227 = v3363 + v3362
					end
				elseif v3356 == proto.wireTypes.i32 then
					local v3364

					v3364, n227 = proto.readFixed32(p344, n227)
				elseif v3356 == proto.wireTypes.i64 then
					local v3365

					v3365, n227 = proto.readFixed64(p344, n227)
				else
					error("Unsupported wire type: " .. v3356)
				end
			end

			return v3353
		end
		function t455.jsonEncode(p345) -- line: 22154
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
		function t455.jsonDecode(t458: {[any]: any}) -- line: 22176
			-- upvalues: t455 (copy), prop_types (copy)
			local v3369 = t455.new()

			if t458.universe_id ~= nil then
				v3369.universe_id = prop_types.StringProp.jsonDecode(t458.universe_id)
			end

			if t458.universeId ~= nil then
				v3369.universe_id = prop_types.StringProp.jsonDecode(t458.universeId)
			end

			if t458.vote_direction ~= nil then
				v3369.vote_direction = prop_types.BoolProp.jsonDecode(t458.vote_direction)
			end

			if t458.voteDirection ~= nil then
				v3369.vote_direction = prop_types.BoolProp.jsonDecode(t458.voteDirection)
			end

			if t458.place_id ~= nil then
				v3369.place_id = prop_types.StringProp.jsonDecode(t458.place_id)
			end

			if t458.placeId ~= nil then
				v3369.place_id = prop_types.StringProp.jsonDecode(t458.placeId)
			end

			if t458.ctx ~= nil then
				v3369.ctx = prop_types.StringProp.jsonDecode(t458.ctx)
			end

			return v3369
		end

		t455.descriptor = {
			name = "ToggleExperienceVoteAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.ToggleExperienceVoteAction_Params = t455
		typeRegistry.default:register(t1.ToggleExperienceVoteAction_Params)

		local t459 = {}

		t459.__index = t459

		function t459.new(t460: {[any]: any}?) -- line: 22229
			-- upvalues: t1 (copy), t459 (copy)
			return (setmetatable({
				action_type = if t460 ~= nil and t460.action_type ~= nil then t460.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t460 ~= nil and t460.action_params ~= nil then t460.action_params else nil
			}, t459))
		end
		function t459.encode(p346) -- line: 22238
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n228 = 0

			if p346.action_type ~= nil and (p346.action_type ~= nil and p346.action_type ~= 0 or p346.action_type ~= t1.ActionType.fromNumber(0)) then
				local v3374, v3375 = proto.writeTag(buf, n228, 1, proto.wireTypes.varint)

				buf, n228 = proto.writeVarInt(v3374, v3375, t1.ActionType.toNumber(p346.action_type))
			end

			if p346.action_params ~= nil then
				local v3376 = p346.action_params:encode()
				local v3377, v3378 = proto.writeTag(buf, n228, 2, proto.wireTypes.lengthDelimited)

				buf, n228 = proto.writeBuffer(v3377, v3378, v3376, buffer.len(v3376))
			end

			local buf117 = buffer.create(n228)

			buffer.copy(buf117, 0, buf, 0, n228)

			return buf117
		end
		function t459.decode(p347: buffer) -- line: 22264
			-- upvalues: t459 (copy), proto (copy), t1 (copy)
			local v3381 = t459.new()
			local n229 = 0

			while n229 < buffer.len(p347) do
				local v3383, v3384

				v3383, v3384, n229 = proto.readTag(p347, n229)

				if v3384 == proto.wireTypes.varint then
					if v3383 == 1 then
						local v3385

						v3385, n229 = proto.readVarIntI32(p347, n229)
						v3381.action_type = t1.ActionType.fromNumber(v3385) or v3385
					else
						local v3386

						v3386, n229 = proto.readVarInt(p347, n229)
					end
				elseif v3384 == proto.wireTypes.lengthDelimited then
					if v3383 == 2 then
						local v3387

						v3387, n229 = proto.readBuffer(p347, n229)
						v3381.action_params = t1.OpenPurchasePromptAction_Params.decode(v3387)
					else
						local v3388, v3389 = proto.readVarInt(p347, n229)

						n229 = v3389 + v3388
					end
				elseif v3384 == proto.wireTypes.i32 then
					local v3390

					v3390, n229 = proto.readFixed32(p347, n229)
				elseif v3384 == proto.wireTypes.i64 then
					local v3391

					v3391, n229 = proto.readFixed64(p347, n229)
				else
					error("Unsupported wire type: " .. v3384)
				end
			end

			return v3381
		end
		function t459.jsonEncode(p348) -- line: 22312
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
		function t459.jsonDecode(t462: {[any]: any}) -- line: 22334
			-- upvalues: t459 (copy), t1 (copy)
			local v3395 = t459.new()

			if t462.action_type ~= nil then
				v3395.action_type = if typeof(t462.action_type) ~= "number" then t1.ActionType.fromName(t462.action_type) or t462.action_type else t1.ActionType.fromNumber(t462.action_type) or t462.action_type
			end

			if t462.actionType ~= nil then
				v3395.action_type = if typeof(t462.actionType) ~= "number" then t1.ActionType.fromName(t462.actionType) or t462.actionType else t1.ActionType.fromNumber(t462.actionType) or t462.actionType
			end

			if t462.action_params ~= nil then
				v3395.action_params = t1.OpenPurchasePromptAction_Params.jsonDecode(t462.action_params)
			end

			if t462.actionParams ~= nil then
				v3395.action_params = t1.OpenPurchasePromptAction_Params.jsonDecode(t462.actionParams)
			end

			return v3395
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

		function t463.new(t464: {[any]: any}?) -- line: 22374
			-- upvalues: t463 (copy)
			return (setmetatable({
				kind = if t464 ~= nil and t464.kind ~= nil then t464.kind else nil
			}, t463))
		end
		function t463.encode(p349) -- line: 22382
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n230 = 0

			if p349.kind ~= nil then
				if p349.kind.type == "literal" then
					local v3400 = p349.kind.value:encode()
					local v3401, v3402 = proto.writeTag(buf, n230, 1, proto.wireTypes.lengthDelimited)

					buf, n230 = proto.writeBuffer(v3401, v3402, v3400, buffer.len(v3400))
				elseif p349.kind.type == "binding_path" then
					local v3403, v3404 = proto.writeTag(buf, n230, 2, proto.wireTypes.lengthDelimited)

					buf, n230 = proto.writeString(v3403, v3404, p349.kind.value)
				end
			end

			local buf118 = buffer.create(n230)

			buffer.copy(buf118, 0, buf, 0, n230)

			return buf118
		end
		function t463.decode(p350: buffer) -- line: 22402
			-- upvalues: t463 (copy), proto (copy), t1 (copy)
			local v3407 = t463.new()
			local n231 = 0

			while n231 < buffer.len(p350) do
				local v3409, v3410

				v3409, v3410, n231 = proto.readTag(p350, n231)

				if v3410 == proto.wireTypes.varint then
					local v3411

					v3411, n231 = proto.readVarInt(p350, n231)
				elseif v3410 == proto.wireTypes.lengthDelimited then
					if v3409 == 1 then
						local v3412

						v3412, n231 = proto.readBuffer(p350, n231)
						v3407.kind = {
							type = "literal",
							value = t1.OpenPurchasePromptAction_ProductPayload_ProductPayloadLiteral.decode(v3412)
						}
					elseif v3409 == 2 then
						local v3413

						v3413, n231 = proto.readBuffer(p350, n231)
						v3407.kind = {
							type = "binding_path",
							value = buffer.tostring(v3413)
						}
					else
						local v3414, v3415 = proto.readVarInt(p350, n231)

						n231 = v3415 + v3414
					end
				elseif v3410 == proto.wireTypes.i32 then
					local v3416

					v3416, n231 = proto.readFixed32(p350, n231)
				elseif v3410 == proto.wireTypes.i64 then
					local v3417

					v3417, n231 = proto.readFixed64(p350, n231)
				else
					error("Unsupported wire type: " .. v3410)
				end
			end

			return v3407
		end
		function t463.jsonEncode(p351) -- line: 22453
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
		function t463.jsonDecode(t466: {[any]: any}) -- line: 22467
			-- upvalues: t463 (copy), t1 (copy)
			local v3421 = t463.new()

			if t466.literal ~= nil then
				v3421.kind = {
					type = "literal",
					value = t1.OpenPurchasePromptAction_ProductPayload_ProductPayloadLiteral.jsonDecode(t466.literal)
				}
			end

			if t466.binding_path ~= nil then
				v3421.kind = {
					type = "binding_path",
					value = t466.binding_path
				}
			end

			if t466.bindingPath ~= nil then
				v3421.kind = {
					type = "binding_path",
					value = t466.bindingPath
				}
			end

			return v3421
		end

		t463.descriptor = {
			name = "OpenPurchasePromptAction_ProductPayload",
			fullName = "roblox.apppageplatform.shared.v1beta1.ProductPayload"
		}
		t1.OpenPurchasePromptAction_ProductPayload = t463
		typeRegistry.default:register(t1.OpenPurchasePromptAction_ProductPayload)

		local t467 = {}

		t467.__index = t467

		function t467.new(t468: {[any]: any}?) -- line: 22507
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
		function t467.encode(p352) -- line: 22533
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n232 = 0

			if p352.kind ~= nil then
				local v3426 = p352.kind:encode()
				local v3427, v3428 = proto.writeTag(buf, n232, 1, proto.wireTypes.lengthDelimited)

				buf, n232 = proto.writeBuffer(v3427, v3428, v3426, buffer.len(v3426))
			end

			if p352.id ~= nil then
				local v3429 = p352.id:encode()
				local v3430, v3431 = proto.writeTag(buf, n232, 2, proto.wireTypes.lengthDelimited)

				buf, n232 = proto.writeBuffer(v3430, v3431, v3429, buffer.len(v3429))
			end

			if p352.subscription_id ~= nil then
				local v3432 = p352.subscription_id:encode()
				local v3433, v3434 = proto.writeTag(buf, n232, 3, proto.wireTypes.lengthDelimited)

				buf, n232 = proto.writeBuffer(v3433, v3434, v3432, buffer.len(v3432))
			end

			if p352.universe_id ~= nil then
				local v3435 = p352.universe_id:encode()
				local v3436, v3437 = proto.writeTag(buf, n232, 4, proto.wireTypes.lengthDelimited)

				buf, n232 = proto.writeBuffer(v3436, v3437, v3435, buffer.len(v3435))
			end

			if p352.equip_if_purchased ~= nil then
				local v3438 = p352.equip_if_purchased:encode()
				local v3439, v3440 = proto.writeTag(buf, n232, 5, proto.wireTypes.lengthDelimited)

				buf, n232 = proto.writeBuffer(v3439, v3440, v3438, buffer.len(v3438))
			end

			if p352.name ~= nil then
				local v3441 = p352.name:encode()
				local v3442, v3443 = proto.writeTag(buf, n232, 6, proto.wireTypes.lengthDelimited)

				buf, n232 = proto.writeBuffer(v3442, v3443, v3441, buffer.len(v3441))
			end

			if p352.expected_price ~= nil then
				local v3444 = p352.expected_price:encode()
				local v3445, v3446 = proto.writeTag(buf, n232, 7, proto.wireTypes.lengthDelimited)

				buf, n232 = proto.writeBuffer(v3445, v3446, v3444, buffer.len(v3444))
			end

			if p352.icon_image_asset_id ~= nil then
				local v3447 = p352.icon_image_asset_id:encode()
				local v3448, v3449 = proto.writeTag(buf, n232, 8, proto.wireTypes.lengthDelimited)

				buf, n232 = proto.writeBuffer(v3448, v3449, v3447, buffer.len(v3447))
			end

			if p352.is_subscription_in_robux ~= nil then
				local v3450 = p352.is_subscription_in_robux:encode()
				local v3451, v3452 = proto.writeTag(buf, n232, 9, proto.wireTypes.lengthDelimited)

				buf, n232 = proto.writeBuffer(v3451, v3452, v3450, buffer.len(v3450))
			end

			if p352.display_price ~= nil then
				local v3453 = p352.display_price:encode()
				local v3454, v3455 = proto.writeTag(buf, n232, 10, proto.wireTypes.lengthDelimited)

				buf, n232 = proto.writeBuffer(v3454, v3455, v3453, buffer.len(v3453))
			end

			local buf119 = buffer.create(n232)

			buffer.copy(buf119, 0, buf, 0, n232)

			return buf119
		end
		function t467.decode(p353: buffer) -- line: 22604
			-- upvalues: t467 (copy), proto (copy), prop_types (copy)
			local v3458 = t467.new()
			local n233 = 0

			while n233 < buffer.len(p353) do
				local v3460, v3461

				v3460, v3461, n233 = proto.readTag(p353, n233)

				if v3461 == proto.wireTypes.varint then
					local v3462

					v3462, n233 = proto.readVarInt(p353, n233)
				elseif v3461 == proto.wireTypes.lengthDelimited then
					if v3460 == 1 then
						local v3463

						v3463, n233 = proto.readBuffer(p353, n233)
						v3458.kind = prop_types.StringProp.decode(v3463)
					elseif v3460 == 2 then
						local v3464

						v3464, n233 = proto.readBuffer(p353, n233)
						v3458.id = prop_types.StringProp.decode(v3464)
					elseif v3460 == 3 then
						local v3465

						v3465, n233 = proto.readBuffer(p353, n233)
						v3458.subscription_id = prop_types.StringProp.decode(v3465)
					elseif v3460 == 4 then
						local v3466

						v3466, n233 = proto.readBuffer(p353, n233)
						v3458.universe_id = prop_types.StringProp.decode(v3466)
					elseif v3460 == 5 then
						local v3467

						v3467, n233 = proto.readBuffer(p353, n233)
						v3458.equip_if_purchased = prop_types.BoolProp.decode(v3467)
					elseif v3460 == 6 then
						local v3468

						v3468, n233 = proto.readBuffer(p353, n233)
						v3458.name = prop_types.StringProp.decode(v3468)
					elseif v3460 == 7 then
						local v3469

						v3469, n233 = proto.readBuffer(p353, n233)
						v3458.expected_price = prop_types.Int64Prop.decode(v3469)
					elseif v3460 == 8 then
						local v3470

						v3470, n233 = proto.readBuffer(p353, n233)
						v3458.icon_image_asset_id = prop_types.Int64Prop.decode(v3470)
					elseif v3460 == 9 then
						local v3471

						v3471, n233 = proto.readBuffer(p353, n233)
						v3458.is_subscription_in_robux = prop_types.BoolProp.decode(v3471)
					elseif v3460 == 10 then
						local v3472

						v3472, n233 = proto.readBuffer(p353, n233)
						v3458.display_price = prop_types.StringProp.decode(v3472)
					else
						local v3473, v3474 = proto.readVarInt(p353, n233)

						n233 = v3474 + v3473
					end
				elseif v3461 == proto.wireTypes.i32 then
					local v3475

					v3475, n233 = proto.readFixed32(p353, n233)
				elseif v3461 == proto.wireTypes.i64 then
					local v3476

					v3476, n233 = proto.readFixed64(p353, n233)
				else
					error("Unsupported wire type: " .. v3461)
				end
			end

			return v3458
		end
		function t467.jsonEncode(p354) -- line: 22695
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
		function t467.jsonDecode(t470: {[any]: any}) -- line: 22743
			-- upvalues: t467 (copy), prop_types (copy)
			local v3480 = t467.new()

			if t470.kind ~= nil then
				v3480.kind = prop_types.StringProp.jsonDecode(t470.kind)
			end

			if t470.id ~= nil then
				v3480.id = prop_types.StringProp.jsonDecode(t470.id)
			end

			if t470.subscription_id ~= nil then
				v3480.subscription_id = prop_types.StringProp.jsonDecode(t470.subscription_id)
			end

			if t470.subscriptionId ~= nil then
				v3480.subscription_id = prop_types.StringProp.jsonDecode(t470.subscriptionId)
			end

			if t470.universe_id ~= nil then
				v3480.universe_id = prop_types.StringProp.jsonDecode(t470.universe_id)
			end

			if t470.universeId ~= nil then
				v3480.universe_id = prop_types.StringProp.jsonDecode(t470.universeId)
			end

			if t470.equip_if_purchased ~= nil then
				v3480.equip_if_purchased = prop_types.BoolProp.jsonDecode(t470.equip_if_purchased)
			end

			if t470.equipIfPurchased ~= nil then
				v3480.equip_if_purchased = prop_types.BoolProp.jsonDecode(t470.equipIfPurchased)
			end

			if t470.name ~= nil then
				v3480.name = prop_types.StringProp.jsonDecode(t470.name)
			end

			if t470.expected_price ~= nil then
				v3480.expected_price = prop_types.Int64Prop.jsonDecode(t470.expected_price)
			end

			if t470.expectedPrice ~= nil then
				v3480.expected_price = prop_types.Int64Prop.jsonDecode(t470.expectedPrice)
			end

			if t470.icon_image_asset_id ~= nil then
				v3480.icon_image_asset_id = prop_types.Int64Prop.jsonDecode(t470.icon_image_asset_id)
			end

			if t470.iconImageAssetId ~= nil then
				v3480.icon_image_asset_id = prop_types.Int64Prop.jsonDecode(t470.iconImageAssetId)
			end

			if t470.is_subscription_in_robux ~= nil then
				v3480.is_subscription_in_robux = prop_types.BoolProp.jsonDecode(t470.is_subscription_in_robux)
			end

			if t470.isSubscriptionInRobux ~= nil then
				v3480.is_subscription_in_robux = prop_types.BoolProp.jsonDecode(t470.isSubscriptionInRobux)
			end

			if t470.display_price ~= nil then
				v3480.display_price = prop_types.StringProp.jsonDecode(t470.display_price)
			end

			if t470.displayPrice ~= nil then
				v3480.display_price = prop_types.StringProp.jsonDecode(t470.displayPrice)
			end

			return v3480
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

		function t471.new(t472: {[any]: any}?) -- line: 22847
			-- upvalues: t471 (copy)
			return (setmetatable({
				kind = if t472 ~= nil and t472.kind ~= nil then t472.kind else nil
			}, t471))
		end
		function t471.encode(p355) -- line: 22855
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n234 = 0

			if p355.kind ~= nil then
				if p355.kind.type == "literal" then
					local v3485 = p355.kind.value:encode()
					local v3486, v3487 = proto.writeTag(buf, n234, 1, proto.wireTypes.lengthDelimited)

					buf, n234 = proto.writeBuffer(v3486, v3487, v3485, buffer.len(v3485))
				elseif p355.kind.type == "binding_path" then
					local v3488, v3489 = proto.writeTag(buf, n234, 2, proto.wireTypes.lengthDelimited)

					buf, n234 = proto.writeString(v3488, v3489, p355.kind.value)
				end
			end

			local buf120 = buffer.create(n234)

			buffer.copy(buf120, 0, buf, 0, n234)

			return buf120
		end
		function t471.decode(p356: buffer) -- line: 22875
			-- upvalues: t471 (copy), proto (copy), t1 (copy)
			local v3492 = t471.new()
			local n235 = 0

			while n235 < buffer.len(p356) do
				local v3494, v3495

				v3494, v3495, n235 = proto.readTag(p356, n235)

				if v3495 == proto.wireTypes.varint then
					local v3496

					v3496, n235 = proto.readVarInt(p356, n235)
				elseif v3495 == proto.wireTypes.lengthDelimited then
					if v3494 == 1 then
						local v3497

						v3497, n235 = proto.readBuffer(p356, n235)
						v3492.kind = {
							type = "literal",
							value = t1.OpenPurchasePromptAction_DisplayInfo_DisplayInfoLiteral.decode(v3497)
						}
					elseif v3494 == 2 then
						local v3498

						v3498, n235 = proto.readBuffer(p356, n235)
						v3492.kind = {
							type = "binding_path",
							value = buffer.tostring(v3498)
						}
					else
						local v3499, v3500 = proto.readVarInt(p356, n235)

						n235 = v3500 + v3499
					end
				elseif v3495 == proto.wireTypes.i32 then
					local v3501

					v3501, n235 = proto.readFixed32(p356, n235)
				elseif v3495 == proto.wireTypes.i64 then
					local v3502

					v3502, n235 = proto.readFixed64(p356, n235)
				else
					error("Unsupported wire type: " .. v3495)
				end
			end

			return v3492
		end
		function t471.jsonEncode(p357) -- line: 22926
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
		function t471.jsonDecode(t474: {[any]: any}) -- line: 22940
			-- upvalues: t471 (copy), t1 (copy)
			local v3506 = t471.new()

			if t474.literal ~= nil then
				v3506.kind = {
					type = "literal",
					value = t1.OpenPurchasePromptAction_DisplayInfo_DisplayInfoLiteral.jsonDecode(t474.literal)
				}
			end

			if t474.binding_path ~= nil then
				v3506.kind = {
					type = "binding_path",
					value = t474.binding_path
				}
			end

			if t474.bindingPath ~= nil then
				v3506.kind = {
					type = "binding_path",
					value = t474.bindingPath
				}
			end

			return v3506
		end

		t471.descriptor = {
			name = "OpenPurchasePromptAction_DisplayInfo",
			fullName = "roblox.apppageplatform.shared.v1beta1.DisplayInfo"
		}
		t1.OpenPurchasePromptAction_DisplayInfo = t471
		typeRegistry.default:register(t1.OpenPurchasePromptAction_DisplayInfo)

		local t475 = {}

		t475.__index = t475

		function t475.new(t476: {[any]: any}?) -- line: 22978
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
		function t475.encode(p358) -- line: 23006
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n236 = 0

			if p358.product_name ~= nil then
				local v3511 = p358.product_name:encode()
				local v3512, v3513 = proto.writeTag(buf, n236, 1, proto.wireTypes.lengthDelimited)

				buf, n236 = proto.writeBuffer(v3512, v3513, v3511, buffer.len(v3511))
			end

			if p358.description ~= nil then
				local v3514 = p358.description:encode()
				local v3515, v3516 = proto.writeTag(buf, n236, 2, proto.wireTypes.lengthDelimited)

				buf, n236 = proto.writeBuffer(v3515, v3516, v3514, buffer.len(v3514))
			end

			if p358.image_url ~= nil then
				local v3517 = p358.image_url:encode()
				local v3518, v3519 = proto.writeTag(buf, n236, 3, proto.wireTypes.lengthDelimited)

				buf, n236 = proto.writeBuffer(v3518, v3519, v3517, buffer.len(v3517))
			end

			if p358.price_in_robux ~= nil then
				local v3520 = p358.price_in_robux:encode()
				local v3521, v3522 = proto.writeTag(buf, n236, 4, proto.wireTypes.lengthDelimited)

				buf, n236 = proto.writeBuffer(v3521, v3522, v3520, buffer.len(v3520))
			end

			if p358.display_price ~= nil then
				local v3523 = p358.display_price:encode()
				local v3524, v3525 = proto.writeTag(buf, n236, 5, proto.wireTypes.lengthDelimited)

				buf, n236 = proto.writeBuffer(v3524, v3525, v3523, buffer.len(v3523))
			end

			if p358.icon_image_asset_id ~= nil then
				local v3526 = p358.icon_image_asset_id:encode()
				local v3527, v3528 = proto.writeTag(buf, n236, 6, proto.wireTypes.lengthDelimited)

				buf, n236 = proto.writeBuffer(v3527, v3528, v3526, buffer.len(v3526))
			end

			if p358.product_id ~= nil then
				local v3529 = p358.product_id:encode()
				local v3530, v3531 = proto.writeTag(buf, n236, 7, proto.wireTypes.lengthDelimited)

				buf, n236 = proto.writeBuffer(v3530, v3531, v3529, buffer.len(v3529))
			end

			if p358.target_id ~= nil then
				local v3532 = p358.target_id:encode()
				local v3533, v3534 = proto.writeTag(buf, n236, 8, proto.wireTypes.lengthDelimited)

				buf, n236 = proto.writeBuffer(v3533, v3534, v3532, buffer.len(v3532))
			end

			if p358.is_for_sale ~= nil then
				local v3535 = p358.is_for_sale:encode()
				local v3536, v3537 = proto.writeTag(buf, n236, 9, proto.wireTypes.lengthDelimited)

				buf, n236 = proto.writeBuffer(v3536, v3537, v3535, buffer.len(v3535))
			end

			if p358.product_type ~= nil then
				local v3538 = p358.product_type:encode()
				local v3539, v3540 = proto.writeTag(buf, n236, 10, proto.wireTypes.lengthDelimited)

				buf, n236 = proto.writeBuffer(v3539, v3540, v3538, buffer.len(v3538))
			end

			if p358.base_price_in_robux ~= nil then
				local v3541 = p358.base_price_in_robux:encode()
				local v3542, v3543 = proto.writeTag(buf, n236, 11, proto.wireTypes.lengthDelimited)

				buf, n236 = proto.writeBuffer(v3542, v3543, v3541, buffer.len(v3541))
			end

			if p358.price_discount_details ~= nil then
				local v3544 = p358.price_discount_details:encode()
				local v3545, v3546 = proto.writeTag(buf, n236, 12, proto.wireTypes.lengthDelimited)

				buf, n236 = proto.writeBuffer(v3545, v3546, v3544, buffer.len(v3544))
			end

			local buf121 = buffer.create(n236)

			buffer.copy(buf121, 0, buf, 0, n236)

			return buf121
		end
		function t475.decode(p359: buffer) -- line: 23089
			-- upvalues: t475 (copy), proto (copy), prop_types (copy)
			local v3549 = t475.new()
			local n237 = 0

			while n237 < buffer.len(p359) do
				local v3551, v3552

				v3551, v3552, n237 = proto.readTag(p359, n237)

				if v3552 == proto.wireTypes.varint then
					local v3553

					v3553, n237 = proto.readVarInt(p359, n237)
				elseif v3552 == proto.wireTypes.lengthDelimited then
					if v3551 == 1 then
						local v3554

						v3554, n237 = proto.readBuffer(p359, n237)
						v3549.product_name = prop_types.StringProp.decode(v3554)
					elseif v3551 == 2 then
						local v3555

						v3555, n237 = proto.readBuffer(p359, n237)
						v3549.description = prop_types.StringProp.decode(v3555)
					elseif v3551 == 3 then
						local v3556

						v3556, n237 = proto.readBuffer(p359, n237)
						v3549.image_url = prop_types.StringProp.decode(v3556)
					elseif v3551 == 4 then
						local v3557

						v3557, n237 = proto.readBuffer(p359, n237)
						v3549.price_in_robux = prop_types.Int64Prop.decode(v3557)
					elseif v3551 == 5 then
						local v3558

						v3558, n237 = proto.readBuffer(p359, n237)
						v3549.display_price = prop_types.StringProp.decode(v3558)
					elseif v3551 == 6 then
						local v3559

						v3559, n237 = proto.readBuffer(p359, n237)
						v3549.icon_image_asset_id = prop_types.Int64Prop.decode(v3559)
					elseif v3551 == 7 then
						local v3560

						v3560, n237 = proto.readBuffer(p359, n237)
						v3549.product_id = prop_types.Int64Prop.decode(v3560)
					elseif v3551 == 8 then
						local v3561

						v3561, n237 = proto.readBuffer(p359, n237)
						v3549.target_id = prop_types.StringProp.decode(v3561)
					elseif v3551 == 9 then
						local v3562

						v3562, n237 = proto.readBuffer(p359, n237)
						v3549.is_for_sale = prop_types.BoolProp.decode(v3562)
					elseif v3551 == 10 then
						local v3563

						v3563, n237 = proto.readBuffer(p359, n237)
						v3549.product_type = prop_types.StringProp.decode(v3563)
					elseif v3551 == 11 then
						local v3564

						v3564, n237 = proto.readBuffer(p359, n237)
						v3549.base_price_in_robux = prop_types.Int64Prop.decode(v3564)
					elseif v3551 == 12 then
						local v3565

						v3565, n237 = proto.readBuffer(p359, n237)
						v3549.price_discount_details = prop_types.ArrayOfStructProp.decode(v3565)
					else
						local v3566, v3567 = proto.readVarInt(p359, n237)

						n237 = v3567 + v3566
					end
				elseif v3552 == proto.wireTypes.i32 then
					local v3568

					v3568, n237 = proto.readFixed32(p359, n237)
				elseif v3552 == proto.wireTypes.i64 then
					local v3569

					v3569, n237 = proto.readFixed64(p359, n237)
				else
					error("Unsupported wire type: " .. v3552)
				end
			end

			return v3549
		end
		function t475.jsonEncode(p360) -- line: 23190
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
		function t475.jsonDecode(t478: {[any]: any}) -- line: 23246
			-- upvalues: t475 (copy), prop_types (copy)
			local v3573 = t475.new()

			if t478.product_name ~= nil then
				v3573.product_name = prop_types.StringProp.jsonDecode(t478.product_name)
			end

			if t478.productName ~= nil then
				v3573.product_name = prop_types.StringProp.jsonDecode(t478.productName)
			end

			if t478.description ~= nil then
				v3573.description = prop_types.StringProp.jsonDecode(t478.description)
			end

			if t478.image_url ~= nil then
				v3573.image_url = prop_types.StringProp.jsonDecode(t478.image_url)
			end

			if t478.imageUrl ~= nil then
				v3573.image_url = prop_types.StringProp.jsonDecode(t478.imageUrl)
			end

			if t478.price_in_robux ~= nil then
				v3573.price_in_robux = prop_types.Int64Prop.jsonDecode(t478.price_in_robux)
			end

			if t478.priceInRobux ~= nil then
				v3573.price_in_robux = prop_types.Int64Prop.jsonDecode(t478.priceInRobux)
			end

			if t478.display_price ~= nil then
				v3573.display_price = prop_types.StringProp.jsonDecode(t478.display_price)
			end

			if t478.displayPrice ~= nil then
				v3573.display_price = prop_types.StringProp.jsonDecode(t478.displayPrice)
			end

			if t478.icon_image_asset_id ~= nil then
				v3573.icon_image_asset_id = prop_types.Int64Prop.jsonDecode(t478.icon_image_asset_id)
			end

			if t478.iconImageAssetId ~= nil then
				v3573.icon_image_asset_id = prop_types.Int64Prop.jsonDecode(t478.iconImageAssetId)
			end

			if t478.product_id ~= nil then
				v3573.product_id = prop_types.Int64Prop.jsonDecode(t478.product_id)
			end

			if t478.productId ~= nil then
				v3573.product_id = prop_types.Int64Prop.jsonDecode(t478.productId)
			end

			if t478.target_id ~= nil then
				v3573.target_id = prop_types.StringProp.jsonDecode(t478.target_id)
			end

			if t478.targetId ~= nil then
				v3573.target_id = prop_types.StringProp.jsonDecode(t478.targetId)
			end

			if t478.is_for_sale ~= nil then
				v3573.is_for_sale = prop_types.BoolProp.jsonDecode(t478.is_for_sale)
			end

			if t478.isForSale ~= nil then
				v3573.is_for_sale = prop_types.BoolProp.jsonDecode(t478.isForSale)
			end

			if t478.product_type ~= nil then
				v3573.product_type = prop_types.StringProp.jsonDecode(t478.product_type)
			end

			if t478.productType ~= nil then
				v3573.product_type = prop_types.StringProp.jsonDecode(t478.productType)
			end

			if t478.base_price_in_robux ~= nil then
				v3573.base_price_in_robux = prop_types.Int64Prop.jsonDecode(t478.base_price_in_robux)
			end

			if t478.basePriceInRobux ~= nil then
				v3573.base_price_in_robux = prop_types.Int64Prop.jsonDecode(t478.basePriceInRobux)
			end

			if t478.price_discount_details ~= nil then
				v3573.price_discount_details = prop_types.ArrayOfStructProp.jsonDecode(t478.price_discount_details)
			end

			if t478.priceDiscountDetails ~= nil then
				v3573.price_discount_details = prop_types.ArrayOfStructProp.jsonDecode(t478.priceDiscountDetails)
			end

			return v3573
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

		function t479.new(t480: {[any]: any}?) -- line: 23380
			-- upvalues: t479 (copy)
			return (setmetatable({
				kind = if t480 ~= nil and t480.kind ~= nil then t480.kind else nil
			}, t479))
		end
		function t479.encode(p361) -- line: 23388
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n238 = 0

			if p361.kind ~= nil then
				if p361.kind.type == "literal" then
					local v3578 = p361.kind.value:encode()
					local v3579, v3580 = proto.writeTag(buf, n238, 1, proto.wireTypes.lengthDelimited)

					buf, n238 = proto.writeBuffer(v3579, v3580, v3578, buffer.len(v3578))
				elseif p361.kind.type == "binding_path" then
					local v3581, v3582 = proto.writeTag(buf, n238, 2, proto.wireTypes.lengthDelimited)

					buf, n238 = proto.writeString(v3581, v3582, p361.kind.value)
				end
			end

			local buf122 = buffer.create(n238)

			buffer.copy(buf122, 0, buf, 0, n238)

			return buf122
		end
		function t479.decode(p362: buffer) -- line: 23410
			-- upvalues: t479 (copy), proto (copy), t1 (copy)
			local v3585 = t479.new()
			local n239 = 0

			while n239 < buffer.len(p362) do
				local v3587, v3588

				v3587, v3588, n239 = proto.readTag(p362, n239)

				if v3588 == proto.wireTypes.varint then
					local v3589

					v3589, n239 = proto.readVarInt(p362, n239)
				elseif v3588 == proto.wireTypes.lengthDelimited then
					if v3587 == 1 then
						local v3590

						v3590, n239 = proto.readBuffer(p362, n239)
						v3585.kind = {
							type = "literal",
							value = t1.OpenPurchasePromptAction_PurchaseOptions_PurchaseOptionsLiteral.decode(v3590)
						}
					elseif v3587 == 2 then
						local v3591

						v3591, n239 = proto.readBuffer(p362, n239)
						v3585.kind = {
							type = "binding_path",
							value = buffer.tostring(v3591)
						}
					else
						local v3592, v3593 = proto.readVarInt(p362, n239)

						n239 = v3593 + v3592
					end
				elseif v3588 == proto.wireTypes.i32 then
					local v3594

					v3594, n239 = proto.readFixed32(p362, n239)
				elseif v3588 == proto.wireTypes.i64 then
					local v3595

					v3595, n239 = proto.readFixed64(p362, n239)
				else
					error("Unsupported wire type: " .. v3588)
				end
			end

			return v3585
		end
		function t479.jsonEncode(p363) -- line: 23463
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
		function t479.jsonDecode(t482: {[any]: any}) -- line: 23479
			-- upvalues: t479 (copy), t1 (copy)
			local v3599 = t479.new()

			if t482.literal ~= nil then
				v3599.kind = {
					type = "literal",
					value = t1.OpenPurchasePromptAction_PurchaseOptions_PurchaseOptionsLiteral.jsonDecode(t482.literal)
				}
			end

			if t482.binding_path ~= nil then
				v3599.kind = {
					type = "binding_path",
					value = t482.binding_path
				}
			end

			if t482.bindingPath ~= nil then
				v3599.kind = {
					type = "binding_path",
					value = t482.bindingPath
				}
			end

			return v3599
		end

		t479.descriptor = {
			name = "OpenPurchasePromptAction_PurchaseOptions",
			fullName = "roblox.apppageplatform.shared.v1beta1.PurchaseOptions"
		}
		t1.OpenPurchasePromptAction_PurchaseOptions = t479
		typeRegistry.default:register(t1.OpenPurchasePromptAction_PurchaseOptions)

		local t483 = {}

		t483.__index = t483

		function t483.new(t484: {[any]: any}?) -- line: 23519
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
		function t483.encode(p364) -- line: 23547
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n240 = 0

			if p364.should_skip_ownership_check ~= nil then
				local v3604 = p364.should_skip_ownership_check:encode()
				local v3605, v3606 = proto.writeTag(buf, n240, 1, proto.wireTypes.lengthDelimited)

				buf, n240 = proto.writeBuffer(v3605, v3606, v3604, buffer.len(v3604))
			end

			if p364.enable_preloaded_purchase_ui ~= nil then
				local v3607 = p364.enable_preloaded_purchase_ui:encode()
				local v3608, v3609 = proto.writeTag(buf, n240, 2, proto.wireTypes.lengthDelimited)

				buf, n240 = proto.writeBuffer(v3608, v3609, v3607, buffer.len(v3607))
			end

			if p364.completion_message ~= nil then
				local v3610 = p364.completion_message:encode()
				local v3611, v3612 = proto.writeTag(buf, n240, 3, proto.wireTypes.lengthDelimited)

				buf, n240 = proto.writeBuffer(v3611, v3612, v3610, buffer.len(v3610))
			end

			if p364.completion_button_text ~= nil then
				local v3613 = p364.completion_button_text:encode()
				local v3614, v3615 = proto.writeTag(buf, n240, 4, proto.wireTypes.lengthDelimited)

				buf, n240 = proto.writeBuffer(v3614, v3615, v3613, buffer.len(v3613))
			end

			if p364.prevent_double_confirm ~= nil then
				local v3616 = p364.prevent_double_confirm:encode()
				local v3617, v3618 = proto.writeTag(buf, n240, 5, proto.wireTypes.lengthDelimited)

				buf, n240 = proto.writeBuffer(v3617, v3618, v3616, buffer.len(v3616))
			end

			if p364.provided_robux_balance ~= nil then
				local v3619 = p364.provided_robux_balance:encode()
				local v3620, v3621 = proto.writeTag(buf, n240, 6, proto.wireTypes.lengthDelimited)

				buf, n240 = proto.writeBuffer(v3620, v3621, v3619, buffer.len(v3619))
			end

			local buf123 = buffer.create(n240)

			buffer.copy(buf123, 0, buf, 0, n240)

			return buf123
		end
		function t483.decode(p365: buffer) -- line: 23594
			-- upvalues: t483 (copy), proto (copy), prop_types (copy)
			local v3624 = t483.new()
			local n241 = 0

			while n241 < buffer.len(p365) do
				local v3626, v3627

				v3626, v3627, n241 = proto.readTag(p365, n241)

				if v3627 == proto.wireTypes.varint then
					local v3628

					v3628, n241 = proto.readVarInt(p365, n241)
				elseif v3627 == proto.wireTypes.lengthDelimited then
					if v3626 == 1 then
						local v3629

						v3629, n241 = proto.readBuffer(p365, n241)
						v3624.should_skip_ownership_check = prop_types.BoolProp.decode(v3629)
					elseif v3626 == 2 then
						local v3630

						v3630, n241 = proto.readBuffer(p365, n241)
						v3624.enable_preloaded_purchase_ui = prop_types.BoolProp.decode(v3630)
					elseif v3626 == 3 then
						local v3631

						v3631, n241 = proto.readBuffer(p365, n241)
						v3624.completion_message = prop_types.StringProp.decode(v3631)
					elseif v3626 == 4 then
						local v3632

						v3632, n241 = proto.readBuffer(p365, n241)
						v3624.completion_button_text = prop_types.StringProp.decode(v3632)
					elseif v3626 == 5 then
						local v3633

						v3633, n241 = proto.readBuffer(p365, n241)
						v3624.prevent_double_confirm = prop_types.BoolProp.decode(v3633)
					elseif v3626 == 6 then
						local v3634

						v3634, n241 = proto.readBuffer(p365, n241)
						v3624.provided_robux_balance = prop_types.Int64Prop.decode(v3634)
					else
						local v3635, v3636 = proto.readVarInt(p365, n241)

						n241 = v3636 + v3635
					end
				elseif v3627 == proto.wireTypes.i32 then
					local v3637

					v3637, n241 = proto.readFixed32(p365, n241)
				elseif v3627 == proto.wireTypes.i64 then
					local v3638

					v3638, n241 = proto.readFixed64(p365, n241)
				else
					error("Unsupported wire type: " .. v3627)
				end
			end

			return v3624
		end
		function t483.jsonEncode(p366) -- line: 23669
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
		function t483.jsonDecode(t486: {[any]: any}) -- line: 23701
			-- upvalues: t483 (copy), prop_types (copy)
			local v3642 = t483.new()

			if t486.should_skip_ownership_check ~= nil then
				v3642.should_skip_ownership_check = prop_types.BoolProp.jsonDecode(t486.should_skip_ownership_check)
			end

			if t486.shouldSkipOwnershipCheck ~= nil then
				v3642.should_skip_ownership_check = prop_types.BoolProp.jsonDecode(t486.shouldSkipOwnershipCheck)
			end

			if t486.enable_preloaded_purchase_ui ~= nil then
				v3642.enable_preloaded_purchase_ui = prop_types.BoolProp.jsonDecode(t486.enable_preloaded_purchase_ui)
			end

			if t486.enablePreloadedPurchaseUi ~= nil then
				v3642.enable_preloaded_purchase_ui = prop_types.BoolProp.jsonDecode(t486.enablePreloadedPurchaseUi)
			end

			if t486.completion_message ~= nil then
				v3642.completion_message = prop_types.StringProp.jsonDecode(t486.completion_message)
			end

			if t486.completionMessage ~= nil then
				v3642.completion_message = prop_types.StringProp.jsonDecode(t486.completionMessage)
			end

			if t486.completion_button_text ~= nil then
				v3642.completion_button_text = prop_types.StringProp.jsonDecode(t486.completion_button_text)
			end

			if t486.completionButtonText ~= nil then
				v3642.completion_button_text = prop_types.StringProp.jsonDecode(t486.completionButtonText)
			end

			if t486.prevent_double_confirm ~= nil then
				v3642.prevent_double_confirm = prop_types.BoolProp.jsonDecode(t486.prevent_double_confirm)
			end

			if t486.preventDoubleConfirm ~= nil then
				v3642.prevent_double_confirm = prop_types.BoolProp.jsonDecode(t486.preventDoubleConfirm)
			end

			if t486.provided_robux_balance ~= nil then
				v3642.provided_robux_balance = prop_types.Int64Prop.jsonDecode(t486.provided_robux_balance)
			end

			if t486.providedRobuxBalance ~= nil then
				v3642.provided_robux_balance = prop_types.Int64Prop.jsonDecode(t486.providedRobuxBalance)
			end

			return v3642
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

		function t487.new(t488: {[any]: any}?) -- line: 23786
			-- upvalues: t487 (copy)
			return (setmetatable({
				kind = if t488 ~= nil and t488.kind ~= nil then t488.kind else nil
			}, t487))
		end
		function t487.encode(p367) -- line: 23797
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n242 = 0

			if p367.kind ~= nil then
				if p367.kind.type == "literal" then
					local v3647 = p367.kind.value:encode()
					local v3648, v3649 = proto.writeTag(buf, n242, 1, proto.wireTypes.lengthDelimited)

					buf, n242 = proto.writeBuffer(v3648, v3649, v3647, buffer.len(v3647))
				elseif p367.kind.type == "binding_path" then
					local v3650, v3651 = proto.writeTag(buf, n242, 2, proto.wireTypes.lengthDelimited)

					buf, n242 = proto.writeString(v3650, v3651, p367.kind.value)
				end
			end

			local buf124 = buffer.create(n242)

			buffer.copy(buf124, 0, buf, 0, n242)

			return buf124
		end
		function t487.decode(p368: buffer) -- line: 23819
			-- upvalues: t487 (copy), proto (copy), t1 (copy)
			local v3654 = t487.new()
			local n243 = 0

			while n243 < buffer.len(p368) do
				local v3656, v3657

				v3656, v3657, n243 = proto.readTag(p368, n243)

				if v3657 == proto.wireTypes.varint then
					local v3658

					v3658, n243 = proto.readVarInt(p368, n243)
				elseif v3657 == proto.wireTypes.lengthDelimited then
					if v3656 == 1 then
						local v3659

						v3659, n243 = proto.readBuffer(p368, n243)
						v3654.kind = {
							type = "literal",
							value = t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata_PurchaseAnalyticsMetadataLiteral.decode(v3659)
						}
					elseif v3656 == 2 then
						local v3660

						v3660, n243 = proto.readBuffer(p368, n243)
						v3654.kind = {
							type = "binding_path",
							value = buffer.tostring(v3660)
						}
					else
						local v3661, v3662 = proto.readVarInt(p368, n243)

						n243 = v3662 + v3661
					end
				elseif v3657 == proto.wireTypes.i32 then
					local v3663

					v3663, n243 = proto.readFixed32(p368, n243)
				elseif v3657 == proto.wireTypes.i64 then
					local v3664

					v3664, n243 = proto.readFixed64(p368, n243)
				else
					error("Unsupported wire type: " .. v3657)
				end
			end

			return v3654
		end
		function t487.jsonEncode(p369) -- line: 23874
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
		function t487.jsonDecode(t490: {[any]: any}) -- line: 23890
			-- upvalues: t487 (copy), t1 (copy)
			local v3668 = t487.new()

			if t490.literal ~= nil then
				v3668.kind = {
					type = "literal",
					value = t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata_PurchaseAnalyticsMetadataLiteral.jsonDecode(t490.literal)
				}
			end

			if t490.binding_path ~= nil then
				v3668.kind = {
					type = "binding_path",
					value = t490.binding_path
				}
			end

			if t490.bindingPath ~= nil then
				v3668.kind = {
					type = "binding_path",
					value = t490.bindingPath
				}
			end

			return v3668
		end

		t487.descriptor = {
			name = "OpenPurchasePromptAction_PurchaseAnalyticsMetadata",
			fullName = "roblox.apppageplatform.shared.v1beta1.PurchaseAnalyticsMetadata"
		}
		t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata = t487
		typeRegistry.default:register(t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata)

		local t491 = {}

		t491.__index = t491

		function t491.new(t492: {[any]: any}?) -- line: 23931
			-- upvalues: t491 (copy)
			return (setmetatable({
				surface = if t492 ~= nil and t492.surface ~= nil then t492.surface else nil,
				product_universe_id = if t492 ~= nil and t492.product_universe_id ~= nil then t492.product_universe_id else nil
			}, t491))
		end
		function t491.encode(p370) -- line: 23945
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n244 = 0

			if p370.surface ~= nil then
				local v3673 = p370.surface:encode()
				local v3674, v3675 = proto.writeTag(buf, n244, 1, proto.wireTypes.lengthDelimited)

				buf, n244 = proto.writeBuffer(v3674, v3675, v3673, buffer.len(v3673))
			end

			if p370.product_universe_id ~= nil then
				local v3676 = p370.product_universe_id:encode()
				local v3677, v3678 = proto.writeTag(buf, n244, 2, proto.wireTypes.lengthDelimited)

				buf, n244 = proto.writeBuffer(v3677, v3678, v3676, buffer.len(v3676))
			end

			local buf125 = buffer.create(n244)

			buffer.copy(buf125, 0, buf, 0, n244)

			return buf125
		end
		function t491.decode(p371: buffer) -- line: 23968
			-- upvalues: t491 (copy), proto (copy), prop_types (copy)
			local v3681 = t491.new()
			local n245 = 0

			while n245 < buffer.len(p371) do
				local v3683, v3684

				v3683, v3684, n245 = proto.readTag(p371, n245)

				if v3684 == proto.wireTypes.varint then
					local v3685

					v3685, n245 = proto.readVarInt(p371, n245)
				elseif v3684 == proto.wireTypes.lengthDelimited then
					if v3683 == 1 then
						local v3686

						v3686, n245 = proto.readBuffer(p371, n245)
						v3681.surface = prop_types.StringProp.decode(v3686)
					elseif v3683 == 2 then
						local v3687

						v3687, n245 = proto.readBuffer(p371, n245)
						v3681.product_universe_id = prop_types.StringProp.decode(v3687)
					else
						local v3688, v3689 = proto.readVarInt(p371, n245)

						n245 = v3689 + v3688
					end
				elseif v3684 == proto.wireTypes.i32 then
					local v3690

					v3690, n245 = proto.readFixed32(p371, n245)
				elseif v3684 == proto.wireTypes.i64 then
					local v3691

					v3691, n245 = proto.readFixed64(p371, n245)
				else
					error("Unsupported wire type: " .. v3684)
				end
			end

			return v3681
		end
		function t491.jsonEncode(p372) -- line: 24019
			local t493 = {}

			if p372.surface ~= nil then
				t493.surface = p372.surface:jsonEncode()
			end

			if p372.product_universe_id ~= nil then
				t493.productUniverseId = p372.product_universe_id:jsonEncode()
			end

			return t493
		end
		function t491.jsonDecode(t494: {[any]: any}) -- line: 24035
			-- upvalues: t491 (copy), prop_types (copy)
			local v3695 = t491.new()

			if t494.surface ~= nil then
				v3695.surface = prop_types.StringProp.jsonDecode(t494.surface)
			end

			if t494.product_universe_id ~= nil then
				v3695.product_universe_id = prop_types.StringProp.jsonDecode(t494.product_universe_id)
			end

			if t494.productUniverseId ~= nil then
				v3695.product_universe_id = prop_types.StringProp.jsonDecode(t494.productUniverseId)
			end

			return v3695
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

		function t495.new(t496: {[any]: any}?) -- line: 24076
			-- upvalues: t495 (copy)
			return (setmetatable({
				product_payload = if t496 ~= nil and t496.product_payload ~= nil then t496.product_payload else nil,
				display_info = if t496 ~= nil and t496.display_info ~= nil then t496.display_info else nil,
				purchase_options = if t496 ~= nil and t496.purchase_options ~= nil then t496.purchase_options else nil,
				purchase_analytics_metadata = if t496 ~= nil and t496.purchase_analytics_metadata ~= nil then t496.purchase_analytics_metadata else nil,
				root_place_id = if t496 ~= nil and t496.root_place_id ~= nil then t496.root_place_id else nil
			}, t495))
		end
		function t495.encode(p373) -- line: 24090
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n246 = 0

			if p373.product_payload ~= nil then
				local v3700 = p373.product_payload:encode()
				local v3701, v3702 = proto.writeTag(buf, n246, 1, proto.wireTypes.lengthDelimited)

				buf, n246 = proto.writeBuffer(v3701, v3702, v3700, buffer.len(v3700))
			end

			if p373.display_info ~= nil then
				local v3703 = p373.display_info:encode()
				local v3704, v3705 = proto.writeTag(buf, n246, 2, proto.wireTypes.lengthDelimited)

				buf, n246 = proto.writeBuffer(v3704, v3705, v3703, buffer.len(v3703))
			end

			if p373.purchase_options ~= nil then
				local v3706 = p373.purchase_options:encode()
				local v3707, v3708 = proto.writeTag(buf, n246, 3, proto.wireTypes.lengthDelimited)

				buf, n246 = proto.writeBuffer(v3707, v3708, v3706, buffer.len(v3706))
			end

			if p373.purchase_analytics_metadata ~= nil then
				local v3709 = p373.purchase_analytics_metadata:encode()
				local v3710, v3711 = proto.writeTag(buf, n246, 4, proto.wireTypes.lengthDelimited)

				buf, n246 = proto.writeBuffer(v3710, v3711, v3709, buffer.len(v3709))
			end

			if p373.root_place_id ~= nil then
				local v3712 = p373.root_place_id:encode()
				local v3713, v3714 = proto.writeTag(buf, n246, 5, proto.wireTypes.lengthDelimited)

				buf, n246 = proto.writeBuffer(v3713, v3714, v3712, buffer.len(v3712))
			end

			local buf126 = buffer.create(n246)

			buffer.copy(buf126, 0, buf, 0, n246)

			return buf126
		end
		function t495.decode(p374: buffer) -- line: 24129
			-- upvalues: t495 (copy), proto (copy), t1 (copy), prop_types (copy)
			local v3717 = t495.new()
			local n247 = 0

			while n247 < buffer.len(p374) do
				local v3719, v3720

				v3719, v3720, n247 = proto.readTag(p374, n247)

				if v3720 == proto.wireTypes.varint then
					local v3721

					v3721, n247 = proto.readVarInt(p374, n247)
				elseif v3720 == proto.wireTypes.lengthDelimited then
					if v3719 == 1 then
						local v3722

						v3722, n247 = proto.readBuffer(p374, n247)
						v3717.product_payload = t1.OpenPurchasePromptAction_ProductPayload.decode(v3722)
					elseif v3719 == 2 then
						local v3723

						v3723, n247 = proto.readBuffer(p374, n247)
						v3717.display_info = t1.OpenPurchasePromptAction_DisplayInfo.decode(v3723)
					elseif v3719 == 3 then
						local v3724

						v3724, n247 = proto.readBuffer(p374, n247)
						v3717.purchase_options = t1.OpenPurchasePromptAction_PurchaseOptions.decode(v3724)
					elseif v3719 == 4 then
						local v3725

						v3725, n247 = proto.readBuffer(p374, n247)
						v3717.purchase_analytics_metadata = t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata.decode(v3725)
					elseif v3719 == 5 then
						local v3726

						v3726, n247 = proto.readBuffer(p374, n247)
						v3717.root_place_id = prop_types.StringProp.decode(v3726)
					else
						local v3727, v3728 = proto.readVarInt(p374, n247)

						n247 = v3728 + v3727
					end
				elseif v3720 == proto.wireTypes.i32 then
					local v3729

					v3729, n247 = proto.readFixed32(p374, n247)
				elseif v3720 == proto.wireTypes.i64 then
					local v3730

					v3730, n247 = proto.readFixed64(p374, n247)
				else
					error("Unsupported wire type: " .. v3720)
				end
			end

			return v3717
		end
		function t495.jsonEncode(p375) -- line: 24193
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
		function t495.jsonDecode(t498: {[any]: any}) -- line: 24219
			-- upvalues: t495 (copy), t1 (copy), prop_types (copy)
			local v3734 = t495.new()

			if t498.product_payload ~= nil then
				v3734.product_payload = t1.OpenPurchasePromptAction_ProductPayload.jsonDecode(t498.product_payload)
			end

			if t498.productPayload ~= nil then
				v3734.product_payload = t1.OpenPurchasePromptAction_ProductPayload.jsonDecode(t498.productPayload)
			end

			if t498.display_info ~= nil then
				v3734.display_info = t1.OpenPurchasePromptAction_DisplayInfo.jsonDecode(t498.display_info)
			end

			if t498.displayInfo ~= nil then
				v3734.display_info = t1.OpenPurchasePromptAction_DisplayInfo.jsonDecode(t498.displayInfo)
			end

			if t498.purchase_options ~= nil then
				v3734.purchase_options = t1.OpenPurchasePromptAction_PurchaseOptions.jsonDecode(t498.purchase_options)
			end

			if t498.purchaseOptions ~= nil then
				v3734.purchase_options = t1.OpenPurchasePromptAction_PurchaseOptions.jsonDecode(t498.purchaseOptions)
			end

			if t498.purchase_analytics_metadata ~= nil then
				v3734.purchase_analytics_metadata = t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata.jsonDecode(t498.purchase_analytics_metadata)
			end

			if t498.purchaseAnalyticsMetadata ~= nil then
				v3734.purchase_analytics_metadata = t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata.jsonDecode(t498.purchaseAnalyticsMetadata)
			end

			if t498.root_place_id ~= nil then
				v3734.root_place_id = prop_types.StringProp.jsonDecode(t498.root_place_id)
			end

			if t498.rootPlaceId ~= nil then
				v3734.root_place_id = prop_types.StringProp.jsonDecode(t498.rootPlaceId)
			end

			return v3734
		end

		t495.descriptor = {
			name = "OpenPurchasePromptAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenPurchasePromptAction_Params = t495
		typeRegistry.default:register(t1.OpenPurchasePromptAction_Params)

		local t499 = {}

		t499.__index = t499

		function t499.new(t500: {[any]: any}?) -- line: 24284
			-- upvalues: t1 (copy), t499 (copy)
			return (setmetatable({
				action_type = if t500 ~= nil and t500.action_type ~= nil then t500.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t500 ~= nil and t500.action_params ~= nil then t500.action_params else nil
			}, t499))
		end
		function t499.encode(p376) -- line: 24295
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n248 = 0

			if p376.action_type ~= nil and (p376.action_type ~= nil and p376.action_type ~= 0 or p376.action_type ~= t1.ActionType.fromNumber(0)) then
				local v3739, v3740 = proto.writeTag(buf, n248, 1, proto.wireTypes.varint)

				buf, n248 = proto.writeVarInt(v3739, v3740, t1.ActionType.toNumber(p376.action_type))
			end

			if p376.action_params ~= nil then
				local v3741 = p376.action_params:encode()
				local v3742, v3743 = proto.writeTag(buf, n248, 2, proto.wireTypes.lengthDelimited)

				buf, n248 = proto.writeBuffer(v3742, v3743, v3741, buffer.len(v3741))
			end

			local buf127 = buffer.create(n248)

			buffer.copy(buf127, 0, buf, 0, n248)

			return buf127
		end
		function t499.decode(p377: buffer) -- line: 24321
			-- upvalues: t499 (copy), proto (copy), t1 (copy)
			local v3746 = t499.new()
			local n249 = 0

			while n249 < buffer.len(p377) do
				local v3748, v3749

				v3748, v3749, n249 = proto.readTag(p377, n249)

				if v3749 == proto.wireTypes.varint then
					if v3748 == 1 then
						local v3750

						v3750, n249 = proto.readVarIntI32(p377, n249)
						v3746.action_type = t1.ActionType.fromNumber(v3750) or v3750
					else
						local v3751

						v3751, n249 = proto.readVarInt(p377, n249)
					end
				elseif v3749 == proto.wireTypes.lengthDelimited then
					if v3748 == 2 then
						local v3752

						v3752, n249 = proto.readBuffer(p377, n249)
						v3746.action_params = t1.ReportSurfaceLoadTimeMilestoneAction_Params.decode(v3752)
					else
						local v3753, v3754 = proto.readVarInt(p377, n249)

						n249 = v3754 + v3753
					end
				elseif v3749 == proto.wireTypes.i32 then
					local v3755

					v3755, n249 = proto.readFixed32(p377, n249)
				elseif v3749 == proto.wireTypes.i64 then
					local v3756

					v3756, n249 = proto.readFixed64(p377, n249)
				else
					error("Unsupported wire type: " .. v3749)
				end
			end

			return v3746
		end
		function t499.jsonEncode(p378) -- line: 24369
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
		function t499.jsonDecode(t502: {[any]: any}) -- line: 24391
			-- upvalues: t499 (copy), t1 (copy)
			local v3760 = t499.new()

			if t502.action_type ~= nil then
				v3760.action_type = if typeof(t502.action_type) ~= "number" then t1.ActionType.fromName(t502.action_type) or t502.action_type else t1.ActionType.fromNumber(t502.action_type) or t502.action_type
			end

			if t502.actionType ~= nil then
				v3760.action_type = if typeof(t502.actionType) ~= "number" then t1.ActionType.fromName(t502.actionType) or t502.actionType else t1.ActionType.fromNumber(t502.actionType) or t502.actionType
			end

			if t502.action_params ~= nil then
				v3760.action_params = t1.ReportSurfaceLoadTimeMilestoneAction_Params.jsonDecode(t502.action_params)
			end

			if t502.actionParams ~= nil then
				v3760.action_params = t1.ReportSurfaceLoadTimeMilestoneAction_Params.jsonDecode(t502.actionParams)
			end

			return v3760
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

		function t503.new(t504: {[any]: any}?) -- line: 24433
			-- upvalues: t503 (copy)
			return (setmetatable({
				milestone = if t504 ~= nil and t504.milestone ~= nil then t504.milestone else nil,
				metadata = if t504 ~= nil and t504.metadata ~= nil then t504.metadata else nil
			}, t503))
		end
		function t503.encode(p379) -- line: 24442
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n250 = 0

			if p379.milestone ~= nil then
				local v3765 = p379.milestone:encode()
				local v3766, v3767 = proto.writeTag(buf, n250, 1, proto.wireTypes.lengthDelimited)

				buf, n250 = proto.writeBuffer(v3766, v3767, v3765, buffer.len(v3765))
			end

			if p379.metadata ~= nil then
				local v3768 = p379.metadata:encode()
				local v3769, v3770 = proto.writeTag(buf, n250, 3, proto.wireTypes.lengthDelimited)

				buf, n250 = proto.writeBuffer(v3769, v3770, v3768, buffer.len(v3768))
			end

			local buf128 = buffer.create(n250)

			buffer.copy(buf128, 0, buf, 0, n250)

			return buf128
		end
		function t503.decode(p380: buffer) -- line: 24465
			-- upvalues: t503 (copy), proto (copy), prop_types (copy)
			local v3773 = t503.new()
			local n251 = 0

			while n251 < buffer.len(p380) do
				local v3775, v3776

				v3775, v3776, n251 = proto.readTag(p380, n251)

				if v3776 == proto.wireTypes.varint then
					local v3777

					v3777, n251 = proto.readVarInt(p380, n251)
				elseif v3776 == proto.wireTypes.lengthDelimited then
					if v3775 == 1 then
						local v3778

						v3778, n251 = proto.readBuffer(p380, n251)
						v3773.milestone = prop_types.StringProp.decode(v3778)
					elseif v3775 == 3 then
						local v3779

						v3779, n251 = proto.readBuffer(p380, n251)
						v3773.metadata = prop_types.StructProp.decode(v3779)
					else
						local v3780, v3781 = proto.readVarInt(p380, n251)

						n251 = v3781 + v3780
					end
				elseif v3776 == proto.wireTypes.i32 then
					local v3782

					v3782, n251 = proto.readFixed32(p380, n251)
				elseif v3776 == proto.wireTypes.i64 then
					local v3783

					v3783, n251 = proto.readFixed64(p380, n251)
				else
					error("Unsupported wire type: " .. v3776)
				end
			end

			return v3773
		end
		function t503.jsonEncode(p381) -- line: 24515
			local t505 = {}

			if p381.milestone ~= nil then
				t505.milestone = p381.milestone:jsonEncode()
			end

			if p381.metadata ~= nil then
				t505.metadata = p381.metadata:jsonEncode()
			end

			return t505
		end
		function t503.jsonDecode(t506: {[any]: any}) -- line: 24531
			-- upvalues: t503 (copy), prop_types (copy)
			local v3787 = t503.new()

			if t506.milestone ~= nil then
				v3787.milestone = prop_types.StringProp.jsonDecode(t506.milestone)
			end

			if t506.metadata ~= nil then
				v3787.metadata = prop_types.StructProp.jsonDecode(t506.metadata)
			end

			return v3787
		end

		t503.descriptor = {
			name = "ReportSurfaceLoadTimeMilestoneAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.ReportSurfaceLoadTimeMilestoneAction_Params = t503
		typeRegistry.default:register(t1.ReportSurfaceLoadTimeMilestoneAction_Params)

		local t507 = {}

		t507.__index = t507

		function t507.new(t508: {[any]: any}?) -- line: 24561
			-- upvalues: t1 (copy), t507 (copy)
			return (setmetatable({
				action_type = if t508 ~= nil and t508.action_type ~= nil then t508.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t508 ~= nil and t508.action_params ~= nil then t508.action_params else nil
			}, t507))
		end
		function t507.encode(p382) -- line: 24572
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n252 = 0

			if p382.action_type ~= nil and (p382.action_type ~= nil and p382.action_type ~= 0 or p382.action_type ~= t1.ActionType.fromNumber(0)) then
				local v3792, v3793 = proto.writeTag(buf, n252, 1, proto.wireTypes.varint)

				buf, n252 = proto.writeVarInt(v3792, v3793, t1.ActionType.toNumber(p382.action_type))
			end

			if p382.action_params ~= nil then
				local v3794 = p382.action_params:encode()
				local v3795, v3796 = proto.writeTag(buf, n252, 2, proto.wireTypes.lengthDelimited)

				buf, n252 = proto.writeBuffer(v3795, v3796, v3794, buffer.len(v3794))
			end

			local buf129 = buffer.create(n252)

			buffer.copy(buf129, 0, buf, 0, n252)

			return buf129
		end
		function t507.decode(p383: buffer) -- line: 24598
			-- upvalues: t507 (copy), proto (copy), t1 (copy)
			local v3799 = t507.new()
			local n253 = 0

			while n253 < buffer.len(p383) do
				local v3801, v3802

				v3801, v3802, n253 = proto.readTag(p383, n253)

				if v3802 == proto.wireTypes.varint then
					if v3801 == 1 then
						local v3803

						v3803, n253 = proto.readVarIntI32(p383, n253)
						v3799.action_type = t1.ActionType.fromNumber(v3803) or v3803
					else
						local v3804

						v3804, n253 = proto.readVarInt(p383, n253)
					end
				elseif v3802 == proto.wireTypes.lengthDelimited then
					if v3801 == 2 then
						local v3805

						v3805, n253 = proto.readBuffer(p383, n253)
						v3799.action_params = t1.DismissGameFeedbackAction_Params.decode(v3805)
					else
						local v3806, v3807 = proto.readVarInt(p383, n253)

						n253 = v3807 + v3806
					end
				elseif v3802 == proto.wireTypes.i32 then
					local v3808

					v3808, n253 = proto.readFixed32(p383, n253)
				elseif v3802 == proto.wireTypes.i64 then
					local v3809

					v3809, n253 = proto.readFixed64(p383, n253)
				else
					error("Unsupported wire type: " .. v3802)
				end
			end

			return v3799
		end
		function t507.jsonEncode(p384) -- line: 24646
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
		function t507.jsonDecode(t510: {[any]: any}) -- line: 24668
			-- upvalues: t507 (copy), t1 (copy)
			local v3813 = t507.new()

			if t510.action_type ~= nil then
				v3813.action_type = if typeof(t510.action_type) ~= "number" then t1.ActionType.fromName(t510.action_type) or t510.action_type else t1.ActionType.fromNumber(t510.action_type) or t510.action_type
			end

			if t510.actionType ~= nil then
				v3813.action_type = if typeof(t510.actionType) ~= "number" then t1.ActionType.fromName(t510.actionType) or t510.actionType else t1.ActionType.fromNumber(t510.actionType) or t510.actionType
			end

			if t510.action_params ~= nil then
				v3813.action_params = t1.DismissGameFeedbackAction_Params.jsonDecode(t510.action_params)
			end

			if t510.actionParams ~= nil then
				v3813.action_params = t1.DismissGameFeedbackAction_Params.jsonDecode(t510.actionParams)
			end

			return v3813
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

		function t511.new(t512: {[any]: any}?) -- line: 24708
			-- upvalues: t511 (copy)
			return (setmetatable({
				root_place_id = if t512 ~= nil and t512.root_place_id ~= nil then t512.root_place_id else nil
			}, t511))
		end
		function t511.encode(p385) -- line: 24716
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n254 = 0

			if p385.root_place_id ~= nil then
				local v3818 = p385.root_place_id:encode()
				local v3819, v3820 = proto.writeTag(buf, n254, 1, proto.wireTypes.lengthDelimited)

				buf, n254 = proto.writeBuffer(v3819, v3820, v3818, buffer.len(v3818))
			end

			local buf130 = buffer.create(n254)

			buffer.copy(buf130, 0, buf, 0, n254)

			return buf130
		end
		function t511.decode(p386: buffer) -- line: 24731
			-- upvalues: t511 (copy), proto (copy), prop_types (copy)
			local v3823 = t511.new()
			local n255 = 0

			while n255 < buffer.len(p386) do
				local v3825, v3826

				v3825, v3826, n255 = proto.readTag(p386, n255)

				if v3826 == proto.wireTypes.varint then
					local v3827

					v3827, n255 = proto.readVarInt(p386, n255)
				elseif v3826 == proto.wireTypes.lengthDelimited then
					if v3825 == 1 then
						local v3828

						v3828, n255 = proto.readBuffer(p386, n255)
						v3823.root_place_id = prop_types.StringProp.decode(v3828)
					else
						local v3829, v3830 = proto.readVarInt(p386, n255)

						n255 = v3830 + v3829
					end
				elseif v3826 == proto.wireTypes.i32 then
					local v3831

					v3831, n255 = proto.readFixed32(p386, n255)
				elseif v3826 == proto.wireTypes.i64 then
					local v3832

					v3832, n255 = proto.readFixed64(p386, n255)
				else
					error("Unsupported wire type: " .. v3826)
				end
			end

			return v3823
		end
		function t511.jsonEncode(p387) -- line: 24774
			local t513 = {}

			if p387.root_place_id ~= nil then
				t513.rootPlaceId = p387.root_place_id:jsonEncode()
			end

			return t513
		end
		function t511.jsonDecode(t514: {[any]: any}) -- line: 24784
			-- upvalues: t511 (copy), prop_types (copy)
			local v3836 = t511.new()

			if t514.root_place_id ~= nil then
				v3836.root_place_id = prop_types.StringProp.jsonDecode(t514.root_place_id)
			end

			if t514.rootPlaceId ~= nil then
				v3836.root_place_id = prop_types.StringProp.jsonDecode(t514.rootPlaceId)
			end

			return v3836
		end

		t511.descriptor = {
			name = "DismissGameFeedbackAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.DismissGameFeedbackAction_Params = t511
		typeRegistry.default:register(t1.DismissGameFeedbackAction_Params)

		local t515 = {}

		t515.__index = t515

		function t515.new(t516: {[any]: any}?) -- line: 24816
			-- upvalues: t1 (copy), t515 (copy)
			return (setmetatable({
				action_type = if t516 ~= nil and t516.action_type ~= nil then t516.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t516 ~= nil and t516.action_params ~= nil then t516.action_params else nil
			}, t515))
		end
		function t515.encode(p388) -- line: 24827
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n256 = 0

			if p388.action_type ~= nil and (p388.action_type ~= nil and p388.action_type ~= 0 or p388.action_type ~= t1.ActionType.fromNumber(0)) then
				local v3841, v3842 = proto.writeTag(buf, n256, 1, proto.wireTypes.varint)

				buf, n256 = proto.writeVarInt(v3841, v3842, t1.ActionType.toNumber(p388.action_type))
			end

			if p388.action_params ~= nil then
				local v3843 = p388.action_params:encode()
				local v3844, v3845 = proto.writeTag(buf, n256, 2, proto.wireTypes.lengthDelimited)

				buf, n256 = proto.writeBuffer(v3844, v3845, v3843, buffer.len(v3843))
			end

			local buf131 = buffer.create(n256)

			buffer.copy(buf131, 0, buf, 0, n256)

			return buf131
		end
		function t515.decode(p389: buffer) -- line: 24853
			-- upvalues: t515 (copy), proto (copy), t1 (copy)
			local v3848 = t515.new()
			local n257 = 0

			while n257 < buffer.len(p389) do
				local v3850, v3851

				v3850, v3851, n257 = proto.readTag(p389, n257)

				if v3851 == proto.wireTypes.varint then
					if v3850 == 1 then
						local v3852

						v3852, n257 = proto.readVarIntI32(p389, n257)
						v3848.action_type = t1.ActionType.fromNumber(v3852) or v3852
					else
						local v3853

						v3853, n257 = proto.readVarInt(p389, n257)
					end
				elseif v3851 == proto.wireTypes.lengthDelimited then
					if v3850 == 2 then
						local v3854

						v3854, n257 = proto.readBuffer(p389, n257)
						v3848.action_params = t1.OpenGameFeedbackFormAction_Params.decode(v3854)
					else
						local v3855, v3856 = proto.readVarInt(p389, n257)

						n257 = v3856 + v3855
					end
				elseif v3851 == proto.wireTypes.i32 then
					local v3857

					v3857, n257 = proto.readFixed32(p389, n257)
				elseif v3851 == proto.wireTypes.i64 then
					local v3858

					v3858, n257 = proto.readFixed64(p389, n257)
				else
					error("Unsupported wire type: " .. v3851)
				end
			end

			return v3848
		end
		function t515.jsonEncode(p390) -- line: 24901
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
		function t515.jsonDecode(t518: {[any]: any}) -- line: 24923
			-- upvalues: t515 (copy), t1 (copy)
			local v3862 = t515.new()

			if t518.action_type ~= nil then
				v3862.action_type = if typeof(t518.action_type) ~= "number" then t1.ActionType.fromName(t518.action_type) or t518.action_type else t1.ActionType.fromNumber(t518.action_type) or t518.action_type
			end

			if t518.actionType ~= nil then
				v3862.action_type = if typeof(t518.actionType) ~= "number" then t1.ActionType.fromName(t518.actionType) or t518.actionType else t1.ActionType.fromNumber(t518.actionType) or t518.actionType
			end

			if t518.action_params ~= nil then
				v3862.action_params = t1.OpenGameFeedbackFormAction_Params.jsonDecode(t518.action_params)
			end

			if t518.actionParams ~= nil then
				v3862.action_params = t1.OpenGameFeedbackFormAction_Params.jsonDecode(t518.actionParams)
			end

			return v3862
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

		function t519.new(t520: {[any]: any}?) -- line: 24963
			-- upvalues: t519 (copy)
			return (setmetatable({
				universe_id = if t520 ~= nil and t520.universe_id ~= nil then t520.universe_id else nil,
				root_place_id = if t520 ~= nil and t520.root_place_id ~= nil then t520.root_place_id else nil
			}, t519))
		end
		function t519.encode(p391) -- line: 24972
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n258 = 0

			if p391.universe_id ~= nil then
				local v3867 = p391.universe_id:encode()
				local v3868, v3869 = proto.writeTag(buf, n258, 1, proto.wireTypes.lengthDelimited)

				buf, n258 = proto.writeBuffer(v3868, v3869, v3867, buffer.len(v3867))
			end

			if p391.root_place_id ~= nil then
				local v3870 = p391.root_place_id:encode()
				local v3871, v3872 = proto.writeTag(buf, n258, 2, proto.wireTypes.lengthDelimited)

				buf, n258 = proto.writeBuffer(v3871, v3872, v3870, buffer.len(v3870))
			end

			local buf132 = buffer.create(n258)

			buffer.copy(buf132, 0, buf, 0, n258)

			return buf132
		end
		function t519.decode(p392: buffer) -- line: 24993
			-- upvalues: t519 (copy), proto (copy), prop_types (copy)
			local v3875 = t519.new()
			local n259 = 0

			while n259 < buffer.len(p392) do
				local v3877, v3878

				v3877, v3878, n259 = proto.readTag(p392, n259)

				if v3878 == proto.wireTypes.varint then
					local v3879

					v3879, n259 = proto.readVarInt(p392, n259)
				elseif v3878 == proto.wireTypes.lengthDelimited then
					if v3877 == 1 then
						local v3880

						v3880, n259 = proto.readBuffer(p392, n259)
						v3875.universe_id = prop_types.StringProp.decode(v3880)
					elseif v3877 == 2 then
						local v3881

						v3881, n259 = proto.readBuffer(p392, n259)
						v3875.root_place_id = prop_types.StringProp.decode(v3881)
					else
						local v3882, v3883 = proto.readVarInt(p392, n259)

						n259 = v3883 + v3882
					end
				elseif v3878 == proto.wireTypes.i32 then
					local v3884

					v3884, n259 = proto.readFixed32(p392, n259)
				elseif v3878 == proto.wireTypes.i64 then
					local v3885

					v3885, n259 = proto.readFixed64(p392, n259)
				else
					error("Unsupported wire type: " .. v3878)
				end
			end

			return v3875
		end
		function t519.jsonEncode(p393) -- line: 25041
			local t521 = {}

			if p393.universe_id ~= nil then
				t521.universeId = p393.universe_id:jsonEncode()
			end

			if p393.root_place_id ~= nil then
				t521.rootPlaceId = p393.root_place_id:jsonEncode()
			end

			return t521
		end
		function t519.jsonDecode(t522: {[any]: any}) -- line: 25055
			-- upvalues: t519 (copy), prop_types (copy)
			local v3889 = t519.new()

			if t522.universe_id ~= nil then
				v3889.universe_id = prop_types.StringProp.jsonDecode(t522.universe_id)
			end

			if t522.universeId ~= nil then
				v3889.universe_id = prop_types.StringProp.jsonDecode(t522.universeId)
			end

			if t522.root_place_id ~= nil then
				v3889.root_place_id = prop_types.StringProp.jsonDecode(t522.root_place_id)
			end

			if t522.rootPlaceId ~= nil then
				v3889.root_place_id = prop_types.StringProp.jsonDecode(t522.rootPlaceId)
			end

			return v3889
		end

		t519.descriptor = {
			name = "OpenGameFeedbackFormAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenGameFeedbackFormAction_Params = t519
		typeRegistry.default:register(t1.OpenGameFeedbackFormAction_Params)

		local t523 = {}

		t523.__index = t523

		function t523.new(t524: {[any]: any}?) -- line: 25096
			-- upvalues: t1 (copy), t523 (copy)
			return (setmetatable({
				action_type = if t524 ~= nil and t524.action_type ~= nil then t524.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t524 ~= nil and t524.action_params ~= nil then t524.action_params else nil
			}, t523))
		end
		function t523.encode(p394) -- line: 25105
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n260 = 0

			if p394.action_type ~= nil and (p394.action_type ~= nil and p394.action_type ~= 0 or p394.action_type ~= t1.ActionType.fromNumber(0)) then
				local v3894, v3895 = proto.writeTag(buf, n260, 1, proto.wireTypes.varint)

				buf, n260 = proto.writeVarInt(v3894, v3895, t1.ActionType.toNumber(p394.action_type))
			end

			if p394.action_params ~= nil then
				local v3896 = p394.action_params:encode()
				local v3897, v3898 = proto.writeTag(buf, n260, 2, proto.wireTypes.lengthDelimited)

				buf, n260 = proto.writeBuffer(v3897, v3898, v3896, buffer.len(v3896))
			end

			local buf133 = buffer.create(n260)

			buffer.copy(buf133, 0, buf, 0, n260)

			return buf133
		end
		function t523.decode(p395: buffer) -- line: 25131
			-- upvalues: t523 (copy), proto (copy), t1 (copy)
			local v3901 = t523.new()
			local n261 = 0

			while n261 < buffer.len(p395) do
				local v3903, v3904

				v3903, v3904, n261 = proto.readTag(p395, n261)

				if v3904 == proto.wireTypes.varint then
					if v3903 == 1 then
						local v3905

						v3905, n261 = proto.readVarIntI32(p395, n261)
						v3901.action_type = t1.ActionType.fromNumber(v3905) or v3905
					else
						local v3906

						v3906, n261 = proto.readVarInt(p395, n261)
					end
				elseif v3904 == proto.wireTypes.lengthDelimited then
					if v3903 == 2 then
						local v3907

						v3907, n261 = proto.readBuffer(p395, n261)
						v3901.action_params = t1.AiOverviewFeedbackAction_Params.decode(v3907)
					else
						local v3908, v3909 = proto.readVarInt(p395, n261)

						n261 = v3909 + v3908
					end
				elseif v3904 == proto.wireTypes.i32 then
					local v3910

					v3910, n261 = proto.readFixed32(p395, n261)
				elseif v3904 == proto.wireTypes.i64 then
					local v3911

					v3911, n261 = proto.readFixed64(p395, n261)
				else
					error("Unsupported wire type: " .. v3904)
				end
			end

			return v3901
		end
		function t523.jsonEncode(p396) -- line: 25179
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
		function t523.jsonDecode(t526: {[any]: any}) -- line: 25201
			-- upvalues: t523 (copy), t1 (copy)
			local v3915 = t523.new()

			if t526.action_type ~= nil then
				v3915.action_type = if typeof(t526.action_type) ~= "number" then t1.ActionType.fromName(t526.action_type) or t526.action_type else t1.ActionType.fromNumber(t526.action_type) or t526.action_type
			end

			if t526.actionType ~= nil then
				v3915.action_type = if typeof(t526.actionType) ~= "number" then t1.ActionType.fromName(t526.actionType) or t526.actionType else t1.ActionType.fromNumber(t526.actionType) or t526.actionType
			end

			if t526.action_params ~= nil then
				v3915.action_params = t1.AiOverviewFeedbackAction_Params.jsonDecode(t526.action_params)
			end

			if t526.actionParams ~= nil then
				v3915.action_params = t1.AiOverviewFeedbackAction_Params.jsonDecode(t526.actionParams)
			end

			return v3915
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

		function t527.new(t528: {[any]: any}?) -- line: 25241
			-- upvalues: t527 (copy)
			return (setmetatable({
				sentiment = if t528 ~= nil and t528.sentiment ~= nil then t528.sentiment else nil,
				dialog_title = if t528 ~= nil and t528.dialog_title ~= nil then t528.dialog_title else nil,
				dialog_text = if t528 ~= nil and t528.dialog_text ~= nil then t528.dialog_text else nil,
				placeholder_text = if t528 ~= nil and t528.placeholder_text ~= nil then t528.placeholder_text else nil
			}, t527))
		end
		function t527.encode(p397) -- line: 25252
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n262 = 0

			if p397.sentiment ~= nil then
				local v3920 = p397.sentiment:encode()
				local v3921, v3922 = proto.writeTag(buf, n262, 1, proto.wireTypes.lengthDelimited)

				buf, n262 = proto.writeBuffer(v3921, v3922, v3920, buffer.len(v3920))
			end

			if p397.dialog_title ~= nil then
				local v3923 = p397.dialog_title:encode()
				local v3924, v3925 = proto.writeTag(buf, n262, 2, proto.wireTypes.lengthDelimited)

				buf, n262 = proto.writeBuffer(v3924, v3925, v3923, buffer.len(v3923))
			end

			if p397.dialog_text ~= nil then
				local v3926 = p397.dialog_text:encode()
				local v3927, v3928 = proto.writeTag(buf, n262, 3, proto.wireTypes.lengthDelimited)

				buf, n262 = proto.writeBuffer(v3927, v3928, v3926, buffer.len(v3926))
			end

			if p397.placeholder_text ~= nil then
				local v3929 = p397.placeholder_text:encode()
				local v3930, v3931 = proto.writeTag(buf, n262, 4, proto.wireTypes.lengthDelimited)

				buf, n262 = proto.writeBuffer(v3930, v3931, v3929, buffer.len(v3929))
			end

			local buf134 = buffer.create(n262)

			buffer.copy(buf134, 0, buf, 0, n262)

			return buf134
		end
		function t527.decode(p398: buffer) -- line: 25285
			-- upvalues: t527 (copy), proto (copy), prop_types (copy)
			local v3934 = t527.new()
			local n263 = 0

			while n263 < buffer.len(p398) do
				local v3936, v3937

				v3936, v3937, n263 = proto.readTag(p398, n263)

				if v3937 == proto.wireTypes.varint then
					local v3938

					v3938, n263 = proto.readVarInt(p398, n263)
				elseif v3937 == proto.wireTypes.lengthDelimited then
					if v3936 == 1 then
						local v3939

						v3939, n263 = proto.readBuffer(p398, n263)
						v3934.sentiment = prop_types.StringProp.decode(v3939)
					elseif v3936 == 2 then
						local v3940

						v3940, n263 = proto.readBuffer(p398, n263)
						v3934.dialog_title = prop_types.StringProp.decode(v3940)
					elseif v3936 == 3 then
						local v3941

						v3941, n263 = proto.readBuffer(p398, n263)
						v3934.dialog_text = prop_types.StringProp.decode(v3941)
					elseif v3936 == 4 then
						local v3942

						v3942, n263 = proto.readBuffer(p398, n263)
						v3934.placeholder_text = prop_types.StringProp.decode(v3942)
					else
						local v3943, v3944 = proto.readVarInt(p398, n263)

						n263 = v3944 + v3943
					end
				elseif v3937 == proto.wireTypes.i32 then
					local v3945

					v3945, n263 = proto.readFixed32(p398, n263)
				elseif v3937 == proto.wireTypes.i64 then
					local v3946

					v3946, n263 = proto.readFixed64(p398, n263)
				else
					error("Unsupported wire type: " .. v3937)
				end
			end

			return v3934
		end
		function t527.jsonEncode(p399) -- line: 25343
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
		function t527.jsonDecode(t530: {[any]: any}) -- line: 25365
			-- upvalues: t527 (copy), prop_types (copy)
			local v3950 = t527.new()

			if t530.sentiment ~= nil then
				v3950.sentiment = prop_types.StringProp.jsonDecode(t530.sentiment)
			end

			if t530.dialog_title ~= nil then
				v3950.dialog_title = prop_types.StringProp.jsonDecode(t530.dialog_title)
			end

			if t530.dialogTitle ~= nil then
				v3950.dialog_title = prop_types.StringProp.jsonDecode(t530.dialogTitle)
			end

			if t530.dialog_text ~= nil then
				v3950.dialog_text = prop_types.StringProp.jsonDecode(t530.dialog_text)
			end

			if t530.dialogText ~= nil then
				v3950.dialog_text = prop_types.StringProp.jsonDecode(t530.dialogText)
			end

			if t530.placeholder_text ~= nil then
				v3950.placeholder_text = prop_types.StringProp.jsonDecode(t530.placeholder_text)
			end

			if t530.placeholderText ~= nil then
				v3950.placeholder_text = prop_types.StringProp.jsonDecode(t530.placeholderText)
			end

			return v3950
		end

		t527.descriptor = {
			name = "AiOverviewFeedbackAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.AiOverviewFeedbackAction_Params = t527
		typeRegistry.default:register(t1.AiOverviewFeedbackAction_Params)

		local t531 = {}

		t531.__index = t531

		function t531.new(t532: {[any]: any}?) -- line: 25418
			-- upvalues: t1 (copy), t531 (copy)
			return (setmetatable({
				action_type = if t532 ~= nil and t532.action_type ~= nil then t532.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t532 ~= nil and t532.action_params ~= nil then t532.action_params else nil
			}, t531))
		end
		function t531.encode(p400) -- line: 25429
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n264 = 0

			if p400.action_type ~= nil and (p400.action_type ~= nil and p400.action_type ~= 0 or p400.action_type ~= t1.ActionType.fromNumber(0)) then
				local v3955, v3956 = proto.writeTag(buf, n264, 1, proto.wireTypes.varint)

				buf, n264 = proto.writeVarInt(v3955, v3956, t1.ActionType.toNumber(p400.action_type))
			end

			if p400.action_params ~= nil then
				local v3957 = p400.action_params:encode()
				local v3958, v3959 = proto.writeTag(buf, n264, 2, proto.wireTypes.lengthDelimited)

				buf, n264 = proto.writeBuffer(v3958, v3959, v3957, buffer.len(v3957))
			end

			local buf135 = buffer.create(n264)

			buffer.copy(buf135, 0, buf, 0, n264)

			return buf135
		end
		function t531.decode(p401: buffer) -- line: 25455
			-- upvalues: t531 (copy), proto (copy), t1 (copy)
			local v3962 = t531.new()
			local n265 = 0

			while n265 < buffer.len(p401) do
				local v3964, v3965

				v3964, v3965, n265 = proto.readTag(p401, n265)

				if v3965 == proto.wireTypes.varint then
					if v3964 == 1 then
						local v3966

						v3966, n265 = proto.readVarIntI32(p401, n265)
						v3962.action_type = t1.ActionType.fromNumber(v3966) or v3966
					else
						local v3967

						v3967, n265 = proto.readVarInt(p401, n265)
					end
				elseif v3965 == proto.wireTypes.lengthDelimited then
					if v3964 == 2 then
						local v3968

						v3968, n265 = proto.readBuffer(p401, n265)
						v3962.action_params = t1.EnableEventNotificationsAction_Params.decode(v3968)
					else
						local v3969, v3970 = proto.readVarInt(p401, n265)

						n265 = v3970 + v3969
					end
				elseif v3965 == proto.wireTypes.i32 then
					local v3971

					v3971, n265 = proto.readFixed32(p401, n265)
				elseif v3965 == proto.wireTypes.i64 then
					local v3972

					v3972, n265 = proto.readFixed64(p401, n265)
				else
					error("Unsupported wire type: " .. v3965)
				end
			end

			return v3962
		end
		function t531.jsonEncode(p402) -- line: 25503
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
		function t531.jsonDecode(t534: {[any]: any}) -- line: 25525
			-- upvalues: t531 (copy), t1 (copy)
			local v3976 = t531.new()

			if t534.action_type ~= nil then
				v3976.action_type = if typeof(t534.action_type) ~= "number" then t1.ActionType.fromName(t534.action_type) or t534.action_type else t1.ActionType.fromNumber(t534.action_type) or t534.action_type
			end

			if t534.actionType ~= nil then
				v3976.action_type = if typeof(t534.actionType) ~= "number" then t1.ActionType.fromName(t534.actionType) or t534.actionType else t1.ActionType.fromNumber(t534.actionType) or t534.actionType
			end

			if t534.action_params ~= nil then
				v3976.action_params = t1.EnableEventNotificationsAction_Params.jsonDecode(t534.action_params)
			end

			if t534.actionParams ~= nil then
				v3976.action_params = t1.EnableEventNotificationsAction_Params.jsonDecode(t534.actionParams)
			end

			return v3976
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

		function t535.new(t536: {[any]: any}?) -- line: 25565
			-- upvalues: t535 (copy)
			return (setmetatable({
				event_id = if t536 ~= nil and t536.event_id ~= nil then t536.event_id else nil,
				universe_id = if t536 ~= nil and t536.universe_id ~= nil then t536.universe_id else nil,
				channel = if t536 ~= nil and t536.channel ~= nil then t536.channel else nil
			}, t535))
		end
		function t535.encode(p403) -- line: 25575
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n266 = 0

			if p403.event_id ~= nil then
				local v3981 = p403.event_id:encode()
				local v3982, v3983 = proto.writeTag(buf, n266, 1, proto.wireTypes.lengthDelimited)

				buf, n266 = proto.writeBuffer(v3982, v3983, v3981, buffer.len(v3981))
			end

			if p403.universe_id ~= nil then
				local v3984 = p403.universe_id:encode()
				local v3985, v3986 = proto.writeTag(buf, n266, 2, proto.wireTypes.lengthDelimited)

				buf, n266 = proto.writeBuffer(v3985, v3986, v3984, buffer.len(v3984))
			end

			if p403.channel ~= nil then
				local v3987 = p403.channel:encode()
				local v3988, v3989 = proto.writeTag(buf, n266, 3, proto.wireTypes.lengthDelimited)

				buf, n266 = proto.writeBuffer(v3988, v3989, v3987, buffer.len(v3987))
			end

			local buf136 = buffer.create(n266)

			buffer.copy(buf136, 0, buf, 0, n266)

			return buf136
		end
		function t535.decode(p404: buffer) -- line: 25602
			-- upvalues: t535 (copy), proto (copy), prop_types (copy)
			local v3992 = t535.new()
			local n267 = 0

			while n267 < buffer.len(p404) do
				local v3994, v3995

				v3994, v3995, n267 = proto.readTag(p404, n267)

				if v3995 == proto.wireTypes.varint then
					local v3996

					v3996, n267 = proto.readVarInt(p404, n267)
				elseif v3995 == proto.wireTypes.lengthDelimited then
					if v3994 == 1 then
						local v3997

						v3997, n267 = proto.readBuffer(p404, n267)
						v3992.event_id = prop_types.StringProp.decode(v3997)
					elseif v3994 == 2 then
						local v3998

						v3998, n267 = proto.readBuffer(p404, n267)
						v3992.universe_id = prop_types.StringProp.decode(v3998)
					elseif v3994 == 3 then
						local v3999

						v3999, n267 = proto.readBuffer(p404, n267)
						v3992.channel = prop_types.StringProp.decode(v3999)
					else
						local v4000, v4001 = proto.readVarInt(p404, n267)

						n267 = v4001 + v4000
					end
				elseif v3995 == proto.wireTypes.i32 then
					local v4002

					v4002, n267 = proto.readFixed32(p404, n267)
				elseif v3995 == proto.wireTypes.i64 then
					local v4003

					v4003, n267 = proto.readFixed64(p404, n267)
				else
					error("Unsupported wire type: " .. v3995)
				end
			end

			return v3992
		end
		function t535.jsonEncode(p405) -- line: 25655
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
		function t535.jsonDecode(t538: {[any]: any}) -- line: 25673
			-- upvalues: t535 (copy), prop_types (copy)
			local v4007 = t535.new()

			if t538.event_id ~= nil then
				v4007.event_id = prop_types.StringProp.jsonDecode(t538.event_id)
			end

			if t538.eventId ~= nil then
				v4007.event_id = prop_types.StringProp.jsonDecode(t538.eventId)
			end

			if t538.universe_id ~= nil then
				v4007.universe_id = prop_types.StringProp.jsonDecode(t538.universe_id)
			end

			if t538.universeId ~= nil then
				v4007.universe_id = prop_types.StringProp.jsonDecode(t538.universeId)
			end

			if t538.channel ~= nil then
				v4007.channel = prop_types.StringProp.jsonDecode(t538.channel)
			end

			return v4007
		end

		t535.descriptor = {
			name = "EnableEventNotificationsAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.EnableEventNotificationsAction_Params = t535
		typeRegistry.default:register(t1.EnableEventNotificationsAction_Params)

		local t539 = {}

		t539.__index = t539

		function t539.new(t540: {[any]: any}?) -- line: 25716
			-- upvalues: t1 (copy), t539 (copy)
			return (setmetatable({
				action_type = if t540 ~= nil and t540.action_type ~= nil then t540.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t540 ~= nil and t540.action_params ~= nil then t540.action_params else nil
			}, t539))
		end
		function t539.encode(p406) -- line: 25727
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n268 = 0

			if p406.action_type ~= nil and (p406.action_type ~= nil and p406.action_type ~= 0 or p406.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4012, v4013 = proto.writeTag(buf, n268, 1, proto.wireTypes.varint)

				buf, n268 = proto.writeVarInt(v4012, v4013, t1.ActionType.toNumber(p406.action_type))
			end

			if p406.action_params ~= nil then
				local v4014 = p406.action_params:encode()
				local v4015, v4016 = proto.writeTag(buf, n268, 2, proto.wireTypes.lengthDelimited)

				buf, n268 = proto.writeBuffer(v4015, v4016, v4014, buffer.len(v4014))
			end

			local buf137 = buffer.create(n268)

			buffer.copy(buf137, 0, buf, 0, n268)

			return buf137
		end
		function t539.decode(p407: buffer) -- line: 25753
			-- upvalues: t539 (copy), proto (copy), t1 (copy)
			local v4019 = t539.new()
			local n269 = 0

			while n269 < buffer.len(p407) do
				local v4021, v4022

				v4021, v4022, n269 = proto.readTag(p407, n269)

				if v4022 == proto.wireTypes.varint then
					if v4021 == 1 then
						local v4023

						v4023, n269 = proto.readVarIntI32(p407, n269)
						v4019.action_type = t1.ActionType.fromNumber(v4023) or v4023
					else
						local v4024

						v4024, n269 = proto.readVarInt(p407, n269)
					end
				elseif v4022 == proto.wireTypes.lengthDelimited then
					if v4021 == 2 then
						local v4025

						v4025, n269 = proto.readBuffer(p407, n269)
						v4019.action_params = t1.DismissEventNotificationsModalAction_Params.decode(v4025)
					else
						local v4026, v4027 = proto.readVarInt(p407, n269)

						n269 = v4027 + v4026
					end
				elseif v4022 == proto.wireTypes.i32 then
					local v4028

					v4028, n269 = proto.readFixed32(p407, n269)
				elseif v4022 == proto.wireTypes.i64 then
					local v4029

					v4029, n269 = proto.readFixed64(p407, n269)
				else
					error("Unsupported wire type: " .. v4022)
				end
			end

			return v4019
		end
		function t539.jsonEncode(p408) -- line: 25801
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
		function t539.jsonDecode(t542: {[any]: any}) -- line: 25823
			-- upvalues: t539 (copy), t1 (copy)
			local v4033 = t539.new()

			if t542.action_type ~= nil then
				v4033.action_type = if typeof(t542.action_type) ~= "number" then t1.ActionType.fromName(t542.action_type) or t542.action_type else t1.ActionType.fromNumber(t542.action_type) or t542.action_type
			end

			if t542.actionType ~= nil then
				v4033.action_type = if typeof(t542.actionType) ~= "number" then t1.ActionType.fromName(t542.actionType) or t542.actionType else t1.ActionType.fromNumber(t542.actionType) or t542.actionType
			end

			if t542.action_params ~= nil then
				v4033.action_params = t1.DismissEventNotificationsModalAction_Params.jsonDecode(t542.action_params)
			end

			if t542.actionParams ~= nil then
				v4033.action_params = t1.DismissEventNotificationsModalAction_Params.jsonDecode(t542.actionParams)
			end

			return v4033
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

		function t543.new(t544: {[any]: any}?) -- line: 25865
			-- upvalues: t543 (copy)
			return (setmetatable({
				event_id = if t544 ~= nil and t544.event_id ~= nil then t544.event_id else nil
			}, t543))
		end
		function t543.encode(p409) -- line: 25873
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n270 = 0

			if p409.event_id ~= nil then
				local v4038 = p409.event_id:encode()
				local v4039, v4040 = proto.writeTag(buf, n270, 1, proto.wireTypes.lengthDelimited)

				buf, n270 = proto.writeBuffer(v4039, v4040, v4038, buffer.len(v4038))
			end

			local buf138 = buffer.create(n270)

			buffer.copy(buf138, 0, buf, 0, n270)

			return buf138
		end
		function t543.decode(p410: buffer) -- line: 25890
			-- upvalues: t543 (copy), proto (copy), prop_types (copy)
			local v4043 = t543.new()
			local n271 = 0

			while n271 < buffer.len(p410) do
				local v4045, v4046

				v4045, v4046, n271 = proto.readTag(p410, n271)

				if v4046 == proto.wireTypes.varint then
					local v4047

					v4047, n271 = proto.readVarInt(p410, n271)
				elseif v4046 == proto.wireTypes.lengthDelimited then
					if v4045 == 1 then
						local v4048

						v4048, n271 = proto.readBuffer(p410, n271)
						v4043.event_id = prop_types.StringProp.decode(v4048)
					else
						local v4049, v4050 = proto.readVarInt(p410, n271)

						n271 = v4050 + v4049
					end
				elseif v4046 == proto.wireTypes.i32 then
					local v4051

					v4051, n271 = proto.readFixed32(p410, n271)
				elseif v4046 == proto.wireTypes.i64 then
					local v4052

					v4052, n271 = proto.readFixed64(p410, n271)
				else
					error("Unsupported wire type: " .. v4046)
				end
			end

			return v4043
		end
		function t543.jsonEncode(p411) -- line: 25935
			local t545 = {}

			if p411.event_id ~= nil then
				t545.eventId = p411.event_id:jsonEncode()
			end

			return t545
		end
		function t543.jsonDecode(t546: {[any]: any}) -- line: 25947
			-- upvalues: t543 (copy), prop_types (copy)
			local v4056 = t543.new()

			if t546.event_id ~= nil then
				v4056.event_id = prop_types.StringProp.jsonDecode(t546.event_id)
			end

			if t546.eventId ~= nil then
				v4056.event_id = prop_types.StringProp.jsonDecode(t546.eventId)
			end

			return v4056
		end

		t543.descriptor = {
			name = "DismissEventNotificationsModalAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.DismissEventNotificationsModalAction_Params = t543
		typeRegistry.default:register(t1.DismissEventNotificationsModalAction_Params)

		local t547 = {}

		t547.__index = t547

		function t547.new(t548: {[any]: any}?) -- line: 25977
			-- upvalues: t1 (copy), t547 (copy)
			return (setmetatable({
				action_type = if t548 ~= nil and t548.action_type ~= nil then t548.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t548 ~= nil and t548.action_params ~= nil then t548.action_params else nil
			}, t547))
		end
		function t547.encode(p412) -- line: 25986
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n272 = 0

			if p412.action_type ~= nil and (p412.action_type ~= nil and p412.action_type ~= 0 or p412.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4061, v4062 = proto.writeTag(buf, n272, 1, proto.wireTypes.varint)

				buf, n272 = proto.writeVarInt(v4061, v4062, t1.ActionType.toNumber(p412.action_type))
			end

			if p412.action_params ~= nil then
				local v4063 = p412.action_params:encode()
				local v4064, v4065 = proto.writeTag(buf, n272, 2, proto.wireTypes.lengthDelimited)

				buf, n272 = proto.writeBuffer(v4064, v4065, v4063, buffer.len(v4063))
			end

			local buf139 = buffer.create(n272)

			buffer.copy(buf139, 0, buf, 0, n272)

			return buf139
		end
		function t547.decode(p413: buffer) -- line: 26012
			-- upvalues: t547 (copy), proto (copy), t1 (copy)
			local v4068 = t547.new()
			local n273 = 0

			while n273 < buffer.len(p413) do
				local v4070, v4071

				v4070, v4071, n273 = proto.readTag(p413, n273)

				if v4071 == proto.wireTypes.varint then
					if v4070 == 1 then
						local v4072

						v4072, n273 = proto.readVarIntI32(p413, n273)
						v4068.action_type = t1.ActionType.fromNumber(v4072) or v4072
					else
						local v4073

						v4073, n273 = proto.readVarInt(p413, n273)
					end
				elseif v4071 == proto.wireTypes.lengthDelimited then
					if v4070 == 2 then
						local v4074

						v4074, n273 = proto.readBuffer(p413, n273)
						v4068.action_params = t1.OpenAmpWizardAction_Params.decode(v4074)
					else
						local v4075, v4076 = proto.readVarInt(p413, n273)

						n273 = v4076 + v4075
					end
				elseif v4071 == proto.wireTypes.i32 then
					local v4077

					v4077, n273 = proto.readFixed32(p413, n273)
				elseif v4071 == proto.wireTypes.i64 then
					local v4078

					v4078, n273 = proto.readFixed64(p413, n273)
				else
					error("Unsupported wire type: " .. v4071)
				end
			end

			return v4068
		end
		function t547.jsonEncode(p414) -- line: 26060
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
		function t547.jsonDecode(t550: {[any]: any}) -- line: 26082
			-- upvalues: t547 (copy), t1 (copy)
			local v4082 = t547.new()

			if t550.action_type ~= nil then
				v4082.action_type = if typeof(t550.action_type) ~= "number" then t1.ActionType.fromName(t550.action_type) or t550.action_type else t1.ActionType.fromNumber(t550.action_type) or t550.action_type
			end

			if t550.actionType ~= nil then
				v4082.action_type = if typeof(t550.actionType) ~= "number" then t1.ActionType.fromName(t550.actionType) or t550.actionType else t1.ActionType.fromNumber(t550.actionType) or t550.actionType
			end

			if t550.action_params ~= nil then
				v4082.action_params = t1.OpenAmpWizardAction_Params.jsonDecode(t550.action_params)
			end

			if t550.actionParams ~= nil then
				v4082.action_params = t1.OpenAmpWizardAction_Params.jsonDecode(t550.actionParams)
			end

			return v4082
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

		function t551.new(t552: {[any]: any}?) -- line: 26122
			-- upvalues: t551 (copy)
			return (setmetatable({
				feature_name = if t552 ~= nil and t552.feature_name ~= nil then t552.feature_name else nil,
				name_space = if t552 ~= nil and t552.name_space ~= nil then t552.name_space else nil,
				entry_point_event_ctx = if t552 ~= nil and t552.entry_point_event_ctx ~= nil then t552.entry_point_event_ctx else nil,
				skip_facial_age_estimation_web_link_modal = if t552 ~= nil and t552.skip_facial_age_estimation_web_link_modal ~= nil then t552.skip_facial_age_estimation_web_link_modal else nil
			}, t551))
		end
		function t551.encode(p415) -- line: 26138
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n274 = 0

			if p415.feature_name ~= nil then
				local v4087 = p415.feature_name:encode()
				local v4088, v4089 = proto.writeTag(buf, n274, 1, proto.wireTypes.lengthDelimited)

				buf, n274 = proto.writeBuffer(v4088, v4089, v4087, buffer.len(v4087))
			end

			if p415.name_space ~= nil then
				local v4090 = p415.name_space:encode()
				local v4091, v4092 = proto.writeTag(buf, n274, 2, proto.wireTypes.lengthDelimited)

				buf, n274 = proto.writeBuffer(v4091, v4092, v4090, buffer.len(v4090))
			end

			if p415.entry_point_event_ctx ~= nil then
				local v4093 = p415.entry_point_event_ctx:encode()
				local v4094, v4095 = proto.writeTag(buf, n274, 3, proto.wireTypes.lengthDelimited)

				buf, n274 = proto.writeBuffer(v4094, v4095, v4093, buffer.len(v4093))
			end

			if p415.skip_facial_age_estimation_web_link_modal ~= nil then
				local v4096 = p415.skip_facial_age_estimation_web_link_modal:encode()
				local v4097, v4098 = proto.writeTag(buf, n274, 4, proto.wireTypes.lengthDelimited)

				buf, n274 = proto.writeBuffer(v4097, v4098, v4096, buffer.len(v4096))
			end

			local buf140 = buffer.create(n274)

			buffer.copy(buf140, 0, buf, 0, n274)

			return buf140
		end
		function t551.decode(p416: buffer) -- line: 26171
			-- upvalues: t551 (copy), proto (copy), prop_types (copy)
			local v4101 = t551.new()
			local n275 = 0

			while n275 < buffer.len(p416) do
				local v4103, v4104

				v4103, v4104, n275 = proto.readTag(p416, n275)

				if v4104 == proto.wireTypes.varint then
					local v4105

					v4105, n275 = proto.readVarInt(p416, n275)
				elseif v4104 == proto.wireTypes.lengthDelimited then
					if v4103 == 1 then
						local v4106

						v4106, n275 = proto.readBuffer(p416, n275)
						v4101.feature_name = prop_types.StringProp.decode(v4106)
					elseif v4103 == 2 then
						local v4107

						v4107, n275 = proto.readBuffer(p416, n275)
						v4101.name_space = prop_types.StringProp.decode(v4107)
					elseif v4103 == 3 then
						local v4108

						v4108, n275 = proto.readBuffer(p416, n275)
						v4101.entry_point_event_ctx = prop_types.StringProp.decode(v4108)
					elseif v4103 == 4 then
						local v4109

						v4109, n275 = proto.readBuffer(p416, n275)
						v4101.skip_facial_age_estimation_web_link_modal = prop_types.BoolProp.decode(v4109)
					else
						local v4110, v4111 = proto.readVarInt(p416, n275)

						n275 = v4111 + v4110
					end
				elseif v4104 == proto.wireTypes.i32 then
					local v4112

					v4112, n275 = proto.readFixed32(p416, n275)
				elseif v4104 == proto.wireTypes.i64 then
					local v4113

					v4113, n275 = proto.readFixed64(p416, n275)
				else
					error("Unsupported wire type: " .. v4104)
				end
			end

			return v4101
		end
		function t551.jsonEncode(p417) -- line: 26231
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
		function t551.jsonDecode(t554: {[any]: any}) -- line: 26253
			-- upvalues: t551 (copy), prop_types (copy)
			local v4117 = t551.new()

			if t554.feature_name ~= nil then
				v4117.feature_name = prop_types.StringProp.jsonDecode(t554.feature_name)
			end

			if t554.featureName ~= nil then
				v4117.feature_name = prop_types.StringProp.jsonDecode(t554.featureName)
			end

			if t554.name_space ~= nil then
				v4117.name_space = prop_types.StringProp.jsonDecode(t554.name_space)
			end

			if t554.nameSpace ~= nil then
				v4117.name_space = prop_types.StringProp.jsonDecode(t554.nameSpace)
			end

			if t554.entry_point_event_ctx ~= nil then
				v4117.entry_point_event_ctx = prop_types.StringProp.jsonDecode(t554.entry_point_event_ctx)
			end

			if t554.entryPointEventCtx ~= nil then
				v4117.entry_point_event_ctx = prop_types.StringProp.jsonDecode(t554.entryPointEventCtx)
			end

			if t554.skip_facial_age_estimation_web_link_modal ~= nil then
				v4117.skip_facial_age_estimation_web_link_modal = prop_types.BoolProp.jsonDecode(t554.skip_facial_age_estimation_web_link_modal)
			end

			if t554.skipFacialAgeEstimationWebLinkModal ~= nil then
				v4117.skip_facial_age_estimation_web_link_modal = prop_types.BoolProp.jsonDecode(t554.skipFacialAgeEstimationWebLinkModal)
			end

			return v4117
		end

		t551.descriptor = {
			name = "OpenAmpWizardAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenAmpWizardAction_Params = t551
		typeRegistry.default:register(t1.OpenAmpWizardAction_Params)

		local t555 = {}

		t555.__index = t555

		function t555.new(t556: {[any]: any}?) -- line: 26315
			-- upvalues: t1 (copy), t555 (copy)
			return (setmetatable({
				action_type = if t556 ~= nil and t556.action_type ~= nil then t556.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t556 ~= nil and t556.action_params ~= nil then t556.action_params else nil
			}, t555))
		end
		function t555.encode(p418) -- line: 26326
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n276 = 0

			if p418.action_type ~= nil and (p418.action_type ~= nil and p418.action_type ~= 0 or p418.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4122, v4123 = proto.writeTag(buf, n276, 1, proto.wireTypes.varint)

				buf, n276 = proto.writeVarInt(v4122, v4123, t1.ActionType.toNumber(p418.action_type))
			end

			if p418.action_params ~= nil then
				local v4124 = p418.action_params:encode()
				local v4125, v4126 = proto.writeTag(buf, n276, 2, proto.wireTypes.lengthDelimited)

				buf, n276 = proto.writeBuffer(v4125, v4126, v4124, buffer.len(v4124))
			end

			local buf141 = buffer.create(n276)

			buffer.copy(buf141, 0, buf, 0, n276)

			return buf141
		end
		function t555.decode(p419: buffer) -- line: 26352
			-- upvalues: t555 (copy), proto (copy), t1 (copy)
			local v4129 = t555.new()
			local n277 = 0

			while n277 < buffer.len(p419) do
				local v4131, v4132

				v4131, v4132, n277 = proto.readTag(p419, n277)

				if v4132 == proto.wireTypes.varint then
					if v4131 == 1 then
						local v4133

						v4133, n277 = proto.readVarIntI32(p419, n277)
						v4129.action_type = t1.ActionType.fromNumber(v4133) or v4133
					else
						local v4134

						v4134, n277 = proto.readVarInt(p419, n277)
					end
				elseif v4132 == proto.wireTypes.lengthDelimited then
					if v4131 == 2 then
						local v4135

						v4135, n277 = proto.readBuffer(p419, n277)
						v4129.action_params = t1.OpenSocialProofUserListSheetAction_Params.decode(v4135)
					else
						local v4136, v4137 = proto.readVarInt(p419, n277)

						n277 = v4137 + v4136
					end
				elseif v4132 == proto.wireTypes.i32 then
					local v4138

					v4138, n277 = proto.readFixed32(p419, n277)
				elseif v4132 == proto.wireTypes.i64 then
					local v4139

					v4139, n277 = proto.readFixed64(p419, n277)
				else
					error("Unsupported wire type: " .. v4132)
				end
			end

			return v4129
		end
		function t555.jsonEncode(p420) -- line: 26400
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
		function t555.jsonDecode(t558: {[any]: any}) -- line: 26422
			-- upvalues: t555 (copy), t1 (copy)
			local v4143 = t555.new()

			if t558.action_type ~= nil then
				v4143.action_type = if typeof(t558.action_type) ~= "number" then t1.ActionType.fromName(t558.action_type) or t558.action_type else t1.ActionType.fromNumber(t558.action_type) or t558.action_type
			end

			if t558.actionType ~= nil then
				v4143.action_type = if typeof(t558.actionType) ~= "number" then t1.ActionType.fromName(t558.actionType) or t558.actionType else t1.ActionType.fromNumber(t558.actionType) or t558.actionType
			end

			if t558.action_params ~= nil then
				v4143.action_params = t1.OpenSocialProofUserListSheetAction_Params.jsonDecode(t558.action_params)
			end

			if t558.actionParams ~= nil then
				v4143.action_params = t1.OpenSocialProofUserListSheetAction_Params.jsonDecode(t558.actionParams)
			end

			return v4143
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

		function t559.new(t560: {[any]: any}?) -- line: 26464
			-- upvalues: t559 (copy)
			return (setmetatable({
				universe_id = if t560 ~= nil and t560.universe_id ~= nil then t560.universe_id else nil,
				place_id = if t560 ~= nil and t560.place_id ~= nil then t560.place_id else nil,
				total_connections = if t560 ~= nil and t560.total_connections ~= nil then t560.total_connections else nil,
				user_ids = if t560 ~= nil and t560.user_ids ~= nil then t560.user_ids else nil,
				sheet_title = if t560 ~= nil and t560.sheet_title ~= nil then t560.sheet_title else nil
			}, t559))
		end
		function t559.encode(p421) -- line: 26476
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n278 = 0

			if p421.universe_id ~= nil then
				local v4148 = p421.universe_id:encode()
				local v4149, v4150 = proto.writeTag(buf, n278, 1, proto.wireTypes.lengthDelimited)

				buf, n278 = proto.writeBuffer(v4149, v4150, v4148, buffer.len(v4148))
			end

			if p421.place_id ~= nil then
				local v4151 = p421.place_id:encode()
				local v4152, v4153 = proto.writeTag(buf, n278, 2, proto.wireTypes.lengthDelimited)

				buf, n278 = proto.writeBuffer(v4152, v4153, v4151, buffer.len(v4151))
			end

			if p421.total_connections ~= nil then
				local v4154 = p421.total_connections:encode()
				local v4155, v4156 = proto.writeTag(buf, n278, 3, proto.wireTypes.lengthDelimited)

				buf, n278 = proto.writeBuffer(v4155, v4156, v4154, buffer.len(v4154))
			end

			if p421.user_ids ~= nil then
				local v4157 = p421.user_ids:encode()
				local v4158, v4159 = proto.writeTag(buf, n278, 4, proto.wireTypes.lengthDelimited)

				buf, n278 = proto.writeBuffer(v4158, v4159, v4157, buffer.len(v4157))
			end

			if p421.sheet_title ~= nil then
				local v4160 = p421.sheet_title:encode()
				local v4161, v4162 = proto.writeTag(buf, n278, 5, proto.wireTypes.lengthDelimited)

				buf, n278 = proto.writeBuffer(v4161, v4162, v4160, buffer.len(v4160))
			end

			local buf142 = buffer.create(n278)

			buffer.copy(buf142, 0, buf, 0, n278)

			return buf142
		end
		function t559.decode(p422: buffer) -- line: 26517
			-- upvalues: t559 (copy), proto (copy), prop_types (copy)
			local v4165 = t559.new()
			local n279 = 0

			while n279 < buffer.len(p422) do
				local v4167, v4168

				v4167, v4168, n279 = proto.readTag(p422, n279)

				if v4168 == proto.wireTypes.varint then
					local v4169

					v4169, n279 = proto.readVarInt(p422, n279)
				elseif v4168 == proto.wireTypes.lengthDelimited then
					if v4167 == 1 then
						local v4170

						v4170, n279 = proto.readBuffer(p422, n279)
						v4165.universe_id = prop_types.StringProp.decode(v4170)
					elseif v4167 == 2 then
						local v4171

						v4171, n279 = proto.readBuffer(p422, n279)
						v4165.place_id = prop_types.StringProp.decode(v4171)
					elseif v4167 == 3 then
						local v4172

						v4172, n279 = proto.readBuffer(p422, n279)
						v4165.total_connections = prop_types.Int32Prop.decode(v4172)
					elseif v4167 == 4 then
						local v4173

						v4173, n279 = proto.readBuffer(p422, n279)
						v4165.user_ids = prop_types.ArrayOfAvatarProp.decode(v4173)
					elseif v4167 == 5 then
						local v4174

						v4174, n279 = proto.readBuffer(p422, n279)
						v4165.sheet_title = prop_types.StringProp.decode(v4174)
					else
						local v4175, v4176 = proto.readVarInt(p422, n279)

						n279 = v4176 + v4175
					end
				elseif v4168 == proto.wireTypes.i32 then
					local v4177

					v4177, n279 = proto.readFixed32(p422, n279)
				elseif v4168 == proto.wireTypes.i64 then
					local v4178

					v4178, n279 = proto.readFixed64(p422, n279)
				else
					error("Unsupported wire type: " .. v4168)
				end
			end

			return v4165
		end
		function t559.jsonEncode(p423) -- line: 26582
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
		function t559.jsonDecode(t562: {[any]: any}) -- line: 26610
			-- upvalues: t559 (copy), prop_types (copy)
			local v4182 = t559.new()

			if t562.universe_id ~= nil then
				v4182.universe_id = prop_types.StringProp.jsonDecode(t562.universe_id)
			end

			if t562.universeId ~= nil then
				v4182.universe_id = prop_types.StringProp.jsonDecode(t562.universeId)
			end

			if t562.place_id ~= nil then
				v4182.place_id = prop_types.StringProp.jsonDecode(t562.place_id)
			end

			if t562.placeId ~= nil then
				v4182.place_id = prop_types.StringProp.jsonDecode(t562.placeId)
			end

			if t562.total_connections ~= nil then
				v4182.total_connections = prop_types.Int32Prop.jsonDecode(t562.total_connections)
			end

			if t562.totalConnections ~= nil then
				v4182.total_connections = prop_types.Int32Prop.jsonDecode(t562.totalConnections)
			end

			if t562.user_ids ~= nil then
				v4182.user_ids = prop_types.ArrayOfAvatarProp.jsonDecode(t562.user_ids)
			end

			if t562.userIds ~= nil then
				v4182.user_ids = prop_types.ArrayOfAvatarProp.jsonDecode(t562.userIds)
			end

			if t562.sheet_title ~= nil then
				v4182.sheet_title = prop_types.StringProp.jsonDecode(t562.sheet_title)
			end

			if t562.sheetTitle ~= nil then
				v4182.sheet_title = prop_types.StringProp.jsonDecode(t562.sheetTitle)
			end

			return v4182
		end

		t559.descriptor = {
			name = "OpenSocialProofUserListSheetAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenSocialProofUserListSheetAction_Params = t559
		typeRegistry.default:register(t1.OpenSocialProofUserListSheetAction_Params)

		local t563 = {}

		t563.__index = t563

		function t563.new(t564: {[any]: any}?) -- line: 26678
			-- upvalues: t1 (copy), t563 (copy)
			return (setmetatable({
				action_type = if t564 ~= nil and t564.action_type ~= nil then t564.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t564 ~= nil and t564.action_params ~= nil then t564.action_params else nil
			}, t563))
		end
		function t563.encode(p424) -- line: 26689
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n280 = 0

			if p424.action_type ~= nil and (p424.action_type ~= nil and p424.action_type ~= 0 or p424.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4187, v4188 = proto.writeTag(buf, n280, 1, proto.wireTypes.varint)

				buf, n280 = proto.writeVarInt(v4187, v4188, t1.ActionType.toNumber(p424.action_type))
			end

			if p424.action_params ~= nil then
				local v4189 = p424.action_params:encode()
				local v4190, v4191 = proto.writeTag(buf, n280, 2, proto.wireTypes.lengthDelimited)

				buf, n280 = proto.writeBuffer(v4190, v4191, v4189, buffer.len(v4189))
			end

			local buf143 = buffer.create(n280)

			buffer.copy(buf143, 0, buf, 0, n280)

			return buf143
		end
		function t563.decode(p425: buffer) -- line: 26715
			-- upvalues: t563 (copy), proto (copy), t1 (copy)
			local v4194 = t563.new()
			local n281 = 0

			while n281 < buffer.len(p425) do
				local v4196, v4197

				v4196, v4197, n281 = proto.readTag(p425, n281)

				if v4197 == proto.wireTypes.varint then
					if v4196 == 1 then
						local v4198

						v4198, n281 = proto.readVarIntI32(p425, n281)
						v4194.action_type = t1.ActionType.fromNumber(v4198) or v4198
					else
						local v4199

						v4199, n281 = proto.readVarInt(p425, n281)
					end
				elseif v4197 == proto.wireTypes.lengthDelimited then
					if v4196 == 2 then
						local v4200

						v4200, n281 = proto.readBuffer(p425, n281)
						v4194.action_params = t1.OpenSearchResultsTabAction_Params.decode(v4200)
					else
						local v4201, v4202 = proto.readVarInt(p425, n281)

						n281 = v4202 + v4201
					end
				elseif v4197 == proto.wireTypes.i32 then
					local v4203

					v4203, n281 = proto.readFixed32(p425, n281)
				elseif v4197 == proto.wireTypes.i64 then
					local v4204

					v4204, n281 = proto.readFixed64(p425, n281)
				else
					error("Unsupported wire type: " .. v4197)
				end
			end

			return v4194
		end
		function t563.jsonEncode(p426) -- line: 26763
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
		function t563.jsonDecode(t566: {[any]: any}) -- line: 26785
			-- upvalues: t563 (copy), t1 (copy)
			local v4208 = t563.new()

			if t566.action_type ~= nil then
				v4208.action_type = if typeof(t566.action_type) ~= "number" then t1.ActionType.fromName(t566.action_type) or t566.action_type else t1.ActionType.fromNumber(t566.action_type) or t566.action_type
			end

			if t566.actionType ~= nil then
				v4208.action_type = if typeof(t566.actionType) ~= "number" then t1.ActionType.fromName(t566.actionType) or t566.actionType else t1.ActionType.fromNumber(t566.actionType) or t566.actionType
			end

			if t566.action_params ~= nil then
				v4208.action_params = t1.OpenSearchResultsTabAction_Params.jsonDecode(t566.action_params)
			end

			if t566.actionParams ~= nil then
				v4208.action_params = t1.OpenSearchResultsTabAction_Params.jsonDecode(t566.actionParams)
			end

			return v4208
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

		function t567.new(t568: {[any]: any}?) -- line: 26825
			-- upvalues: t567 (copy)
			return (setmetatable({
				search_type = if t568 ~= nil and t568.search_type ~= nil then t568.search_type else nil
			}, t567))
		end
		function t567.encode(p427) -- line: 26833
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n282 = 0

			if p427.search_type ~= nil then
				local v4213 = p427.search_type:encode()
				local v4214, v4215 = proto.writeTag(buf, n282, 1, proto.wireTypes.lengthDelimited)

				buf, n282 = proto.writeBuffer(v4214, v4215, v4213, buffer.len(v4213))
			end

			local buf144 = buffer.create(n282)

			buffer.copy(buf144, 0, buf, 0, n282)

			return buf144
		end
		function t567.decode(p428: buffer) -- line: 26848
			-- upvalues: t567 (copy), proto (copy), prop_types (copy)
			local v4218 = t567.new()
			local n283 = 0

			while n283 < buffer.len(p428) do
				local v4220, v4221

				v4220, v4221, n283 = proto.readTag(p428, n283)

				if v4221 == proto.wireTypes.varint then
					local v4222

					v4222, n283 = proto.readVarInt(p428, n283)
				elseif v4221 == proto.wireTypes.lengthDelimited then
					if v4220 == 1 then
						local v4223

						v4223, n283 = proto.readBuffer(p428, n283)
						v4218.search_type = prop_types.StringProp.decode(v4223)
					else
						local v4224, v4225 = proto.readVarInt(p428, n283)

						n283 = v4225 + v4224
					end
				elseif v4221 == proto.wireTypes.i32 then
					local v4226

					v4226, n283 = proto.readFixed32(p428, n283)
				elseif v4221 == proto.wireTypes.i64 then
					local v4227

					v4227, n283 = proto.readFixed64(p428, n283)
				else
					error("Unsupported wire type: " .. v4221)
				end
			end

			return v4218
		end
		function t567.jsonEncode(p429) -- line: 26891
			local t569 = {}

			if p429.search_type ~= nil then
				t569.searchType = p429.search_type:jsonEncode()
			end

			return t569
		end
		function t567.jsonDecode(t570: {[any]: any}) -- line: 26901
			-- upvalues: t567 (copy), prop_types (copy)
			local v4231 = t567.new()

			if t570.search_type ~= nil then
				v4231.search_type = prop_types.StringProp.jsonDecode(t570.search_type)
			end

			if t570.searchType ~= nil then
				v4231.search_type = prop_types.StringProp.jsonDecode(t570.searchType)
			end

			return v4231
		end

		t567.descriptor = {
			name = "OpenSearchResultsTabAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenSearchResultsTabAction_Params = t567
		typeRegistry.default:register(t1.OpenSearchResultsTabAction_Params)

		local t571 = {}

		t571.__index = t571

		function t571.new(t572: {[any]: any}?) -- line: 26932
			-- upvalues: t1 (copy), t571 (copy)
			return (setmetatable({
				action_type = if t572 ~= nil and t572.action_type ~= nil then t572.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t572 ~= nil and t572.action_params ~= nil then t572.action_params else nil
			}, t571))
		end
		function t571.encode(p430) -- line: 26941
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n284 = 0

			if p430.action_type ~= nil and (p430.action_type ~= nil and p430.action_type ~= 0 or p430.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4236, v4237 = proto.writeTag(buf, n284, 1, proto.wireTypes.varint)

				buf, n284 = proto.writeVarInt(v4236, v4237, t1.ActionType.toNumber(p430.action_type))
			end

			if p430.action_params ~= nil then
				local v4238 = p430.action_params:encode()
				local v4239, v4240 = proto.writeTag(buf, n284, 2, proto.wireTypes.lengthDelimited)

				buf, n284 = proto.writeBuffer(v4239, v4240, v4238, buffer.len(v4238))
			end

			local buf145 = buffer.create(n284)

			buffer.copy(buf145, 0, buf, 0, n284)

			return buf145
		end
		function t571.decode(p431: buffer) -- line: 26967
			-- upvalues: t571 (copy), proto (copy), t1 (copy)
			local v4243 = t571.new()
			local n285 = 0

			while n285 < buffer.len(p431) do
				local v4245, v4246

				v4245, v4246, n285 = proto.readTag(p431, n285)

				if v4246 == proto.wireTypes.varint then
					if v4245 == 1 then
						local v4247

						v4247, n285 = proto.readVarIntI32(p431, n285)
						v4243.action_type = t1.ActionType.fromNumber(v4247) or v4247
					else
						local v4248

						v4248, n285 = proto.readVarInt(p431, n285)
					end
				elseif v4246 == proto.wireTypes.lengthDelimited then
					if v4245 == 2 then
						local v4249

						v4249, n285 = proto.readBuffer(p431, n285)
						v4243.action_params = t1.DismissPromptAction_Params.decode(v4249)
					else
						local v4250, v4251 = proto.readVarInt(p431, n285)

						n285 = v4251 + v4250
					end
				elseif v4246 == proto.wireTypes.i32 then
					local v4252

					v4252, n285 = proto.readFixed32(p431, n285)
				elseif v4246 == proto.wireTypes.i64 then
					local v4253

					v4253, n285 = proto.readFixed64(p431, n285)
				else
					error("Unsupported wire type: " .. v4246)
				end
			end

			return v4243
		end
		function t571.jsonEncode(p432) -- line: 27015
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
		function t571.jsonDecode(t574: {[any]: any}) -- line: 27037
			-- upvalues: t571 (copy), t1 (copy)
			local v4257 = t571.new()

			if t574.action_type ~= nil then
				v4257.action_type = if typeof(t574.action_type) ~= "number" then t1.ActionType.fromName(t574.action_type) or t574.action_type else t1.ActionType.fromNumber(t574.action_type) or t574.action_type
			end

			if t574.actionType ~= nil then
				v4257.action_type = if typeof(t574.actionType) ~= "number" then t1.ActionType.fromName(t574.actionType) or t574.actionType else t1.ActionType.fromNumber(t574.actionType) or t574.actionType
			end

			if t574.action_params ~= nil then
				v4257.action_params = t1.DismissPromptAction_Params.jsonDecode(t574.action_params)
			end

			if t574.actionParams ~= nil then
				v4257.action_params = t1.DismissPromptAction_Params.jsonDecode(t574.actionParams)
			end

			return v4257
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

		function t575.new(t576: {[any]: any}?) -- line: 27077
			-- upvalues: t575 (copy)
			return (setmetatable({
				prompt_type = if t576 ~= nil and t576.prompt_type ~= nil then t576.prompt_type else nil,
				prompt_id = if t576 ~= nil and t576.prompt_id ~= nil then t576.prompt_id else nil
			}, t575))
		end
		function t575.encode(p433) -- line: 27086
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n286 = 0

			if p433.prompt_type ~= nil then
				local v4262 = p433.prompt_type:encode()
				local v4263, v4264 = proto.writeTag(buf, n286, 1, proto.wireTypes.lengthDelimited)

				buf, n286 = proto.writeBuffer(v4263, v4264, v4262, buffer.len(v4262))
			end

			if p433.prompt_id ~= nil then
				local v4265 = p433.prompt_id:encode()
				local v4266, v4267 = proto.writeTag(buf, n286, 2, proto.wireTypes.lengthDelimited)

				buf, n286 = proto.writeBuffer(v4266, v4267, v4265, buffer.len(v4265))
			end

			local buf146 = buffer.create(n286)

			buffer.copy(buf146, 0, buf, 0, n286)

			return buf146
		end
		function t575.decode(p434: buffer) -- line: 27107
			-- upvalues: t575 (copy), proto (copy), prop_types (copy)
			local v4270 = t575.new()
			local n287 = 0

			while n287 < buffer.len(p434) do
				local v4272, v4273

				v4272, v4273, n287 = proto.readTag(p434, n287)

				if v4273 == proto.wireTypes.varint then
					local v4274

					v4274, n287 = proto.readVarInt(p434, n287)
				elseif v4273 == proto.wireTypes.lengthDelimited then
					if v4272 == 1 then
						local v4275

						v4275, n287 = proto.readBuffer(p434, n287)
						v4270.prompt_type = prop_types.StringProp.decode(v4275)
					elseif v4272 == 2 then
						local v4276

						v4276, n287 = proto.readBuffer(p434, n287)
						v4270.prompt_id = prop_types.StringProp.decode(v4276)
					else
						local v4277, v4278 = proto.readVarInt(p434, n287)

						n287 = v4278 + v4277
					end
				elseif v4273 == proto.wireTypes.i32 then
					local v4279

					v4279, n287 = proto.readFixed32(p434, n287)
				elseif v4273 == proto.wireTypes.i64 then
					local v4280

					v4280, n287 = proto.readFixed64(p434, n287)
				else
					error("Unsupported wire type: " .. v4273)
				end
			end

			return v4270
		end
		function t575.jsonEncode(p435) -- line: 27155
			local t577 = {}

			if p435.prompt_type ~= nil then
				t577.promptType = p435.prompt_type:jsonEncode()
			end

			if p435.prompt_id ~= nil then
				t577.promptId = p435.prompt_id:jsonEncode()
			end

			return t577
		end
		function t575.jsonDecode(t578: {[any]: any}) -- line: 27169
			-- upvalues: t575 (copy), prop_types (copy)
			local v4284 = t575.new()

			if t578.prompt_type ~= nil then
				v4284.prompt_type = prop_types.StringProp.jsonDecode(t578.prompt_type)
			end

			if t578.promptType ~= nil then
				v4284.prompt_type = prop_types.StringProp.jsonDecode(t578.promptType)
			end

			if t578.prompt_id ~= nil then
				v4284.prompt_id = prop_types.StringProp.jsonDecode(t578.prompt_id)
			end

			if t578.promptId ~= nil then
				v4284.prompt_id = prop_types.StringProp.jsonDecode(t578.promptId)
			end

			return v4284
		end

		t575.descriptor = {
			name = "DismissPromptAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.DismissPromptAction_Params = t575
		typeRegistry.default:register(t1.DismissPromptAction_Params)

		local t579 = {}

		t579.__index = t579

		function t579.new(t580: {[any]: any}?) -- line: 27207
			-- upvalues: t1 (copy), t579 (copy)
			return (setmetatable({
				action_type = if t580 ~= nil and t580.action_type ~= nil then t580.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t580 ~= nil and t580.action_params ~= nil then t580.action_params else nil
			}, t579))
		end
		function t579.encode(p436) -- line: 27221
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n288 = 0

			if p436.action_type ~= nil and (p436.action_type ~= nil and p436.action_type ~= 0 or p436.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4289, v4290 = proto.writeTag(buf, n288, 1, proto.wireTypes.varint)

				buf, n288 = proto.writeVarInt(v4289, v4290, t1.ActionType.toNumber(p436.action_type))
			end

			if p436.action_params ~= nil then
				local v4291 = p436.action_params:encode()
				local v4292, v4293 = proto.writeTag(buf, n288, 2, proto.wireTypes.lengthDelimited)

				buf, n288 = proto.writeBuffer(v4292, v4293, v4291, buffer.len(v4291))
			end

			local buf147 = buffer.create(n288)

			buffer.copy(buf147, 0, buf, 0, n288)

			return buf147
		end
		function t579.decode(p437: buffer) -- line: 27249
			-- upvalues: t579 (copy), proto (copy), t1 (copy)
			local v4296 = t579.new()
			local n289 = 0

			while n289 < buffer.len(p437) do
				local v4298, v4299

				v4298, v4299, n289 = proto.readTag(p437, n289)

				if v4299 == proto.wireTypes.varint then
					if v4298 == 1 then
						local v4300

						v4300, n289 = proto.readVarIntI32(p437, n289)
						v4296.action_type = t1.ActionType.fromNumber(v4300) or v4300
					else
						local v4301

						v4301, n289 = proto.readVarInt(p437, n289)
					end
				elseif v4299 == proto.wireTypes.lengthDelimited then
					if v4298 == 2 then
						local v4302

						v4302, n289 = proto.readBuffer(p437, n289)
						v4296.action_params = t1.RecordPartyChatConversationUpsellAcknowledgementAction_Params.decode(v4302)
					else
						local v4303, v4304 = proto.readVarInt(p437, n289)

						n289 = v4304 + v4303
					end
				elseif v4299 == proto.wireTypes.i32 then
					local v4305

					v4305, n289 = proto.readFixed32(p437, n289)
				elseif v4299 == proto.wireTypes.i64 then
					local v4306

					v4306, n289 = proto.readFixed64(p437, n289)
				else
					error("Unsupported wire type: " .. v4299)
				end
			end

			return v4296
		end
		function t579.jsonEncode(p438) -- line: 27300
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
		function t579.jsonDecode(t582: {[any]: any}) -- line: 27324
			-- upvalues: t579 (copy), t1 (copy)
			local v4310 = t579.new()

			if t582.action_type ~= nil then
				v4310.action_type = if typeof(t582.action_type) ~= "number" then t1.ActionType.fromName(t582.action_type) or t582.action_type else t1.ActionType.fromNumber(t582.action_type) or t582.action_type
			end

			if t582.actionType ~= nil then
				v4310.action_type = if typeof(t582.actionType) ~= "number" then t1.ActionType.fromName(t582.actionType) or t582.actionType else t1.ActionType.fromNumber(t582.actionType) or t582.actionType
			end

			if t582.action_params ~= nil then
				v4310.action_params = t1.RecordPartyChatConversationUpsellAcknowledgementAction_Params.jsonDecode(t582.action_params)
			end

			if t582.actionParams ~= nil then
				v4310.action_params = t1.RecordPartyChatConversationUpsellAcknowledgementAction_Params.jsonDecode(t582.actionParams)
			end

			return v4310
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

		function t583.new(t584: {[any]: any}?) -- line: 27370
			-- upvalues: t583 (copy)
			return (setmetatable({
				modal_action = if t584 ~= nil and t584.modal_action ~= nil then t584.modal_action else nil,
				modal_variant = if t584 ~= nil and t584.modal_variant ~= nil then t584.modal_variant else nil,
				modal_sequence = if t584 ~= nil and t584.modal_sequence ~= nil then t584.modal_sequence else nil,
				conversation_id = if t584 ~= nil and t584.conversation_id ~= nil then t584.conversation_id else nil,
				friend_id = if t584 ~= nil and t584.friend_id ~= nil then t584.friend_id else nil
			}, t583))
		end
		function t583.encode(p439) -- line: 27385
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n290 = 0

			if p439.modal_action ~= nil then
				local v4315 = p439.modal_action:encode()
				local v4316, v4317 = proto.writeTag(buf, n290, 1, proto.wireTypes.lengthDelimited)

				buf, n290 = proto.writeBuffer(v4316, v4317, v4315, buffer.len(v4315))
			end

			if p439.modal_variant ~= nil then
				local v4318 = p439.modal_variant:encode()
				local v4319, v4320 = proto.writeTag(buf, n290, 2, proto.wireTypes.lengthDelimited)

				buf, n290 = proto.writeBuffer(v4319, v4320, v4318, buffer.len(v4318))
			end

			if p439.modal_sequence ~= nil then
				local v4321 = p439.modal_sequence:encode()
				local v4322, v4323 = proto.writeTag(buf, n290, 3, proto.wireTypes.lengthDelimited)

				buf, n290 = proto.writeBuffer(v4322, v4323, v4321, buffer.len(v4321))
			end

			if p439.conversation_id ~= nil then
				local v4324 = p439.conversation_id:encode()
				local v4325, v4326 = proto.writeTag(buf, n290, 4, proto.wireTypes.lengthDelimited)

				buf, n290 = proto.writeBuffer(v4325, v4326, v4324, buffer.len(v4324))
			end

			if p439.friend_id ~= nil then
				local v4327 = p439.friend_id:encode()
				local v4328, v4329 = proto.writeTag(buf, n290, 5, proto.wireTypes.lengthDelimited)

				buf, n290 = proto.writeBuffer(v4328, v4329, v4327, buffer.len(v4327))
			end

			local buf148 = buffer.create(n290)

			buffer.copy(buf148, 0, buf, 0, n290)

			return buf148
		end
		function t583.decode(p440: buffer) -- line: 27426
			-- upvalues: t583 (copy), proto (copy), prop_types (copy)
			local v4332 = t583.new()
			local n291 = 0

			while n291 < buffer.len(p440) do
				local v4334, v4335

				v4334, v4335, n291 = proto.readTag(p440, n291)

				if v4335 == proto.wireTypes.varint then
					local v4336

					v4336, n291 = proto.readVarInt(p440, n291)
				elseif v4335 == proto.wireTypes.lengthDelimited then
					if v4334 == 1 then
						local v4337

						v4337, n291 = proto.readBuffer(p440, n291)
						v4332.modal_action = prop_types.StringProp.decode(v4337)
					elseif v4334 == 2 then
						local v4338

						v4338, n291 = proto.readBuffer(p440, n291)
						v4332.modal_variant = prop_types.StringProp.decode(v4338)
					elseif v4334 == 3 then
						local v4339

						v4339, n291 = proto.readBuffer(p440, n291)
						v4332.modal_sequence = prop_types.StringProp.decode(v4339)
					elseif v4334 == 4 then
						local v4340

						v4340, n291 = proto.readBuffer(p440, n291)
						v4332.conversation_id = prop_types.StringProp.decode(v4340)
					elseif v4334 == 5 then
						local v4341

						v4341, n291 = proto.readBuffer(p440, n291)
						v4332.friend_id = prop_types.StringProp.decode(v4341)
					else
						local v4342, v4343 = proto.readVarInt(p440, n291)

						n291 = v4343 + v4342
					end
				elseif v4335 == proto.wireTypes.i32 then
					local v4344

					v4344, n291 = proto.readFixed32(p440, n291)
				elseif v4335 == proto.wireTypes.i64 then
					local v4345

					v4345, n291 = proto.readFixed64(p440, n291)
				else
					error("Unsupported wire type: " .. v4335)
				end
			end

			return v4332
		end
		function t583.jsonEncode(p441) -- line: 27491
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
		function t583.jsonDecode(t586: {[any]: any}) -- line: 27519
			-- upvalues: t583 (copy), prop_types (copy)
			local v4349 = t583.new()

			if t586.modal_action ~= nil then
				v4349.modal_action = prop_types.StringProp.jsonDecode(t586.modal_action)
			end

			if t586.modalAction ~= nil then
				v4349.modal_action = prop_types.StringProp.jsonDecode(t586.modalAction)
			end

			if t586.modal_variant ~= nil then
				v4349.modal_variant = prop_types.StringProp.jsonDecode(t586.modal_variant)
			end

			if t586.modalVariant ~= nil then
				v4349.modal_variant = prop_types.StringProp.jsonDecode(t586.modalVariant)
			end

			if t586.modal_sequence ~= nil then
				v4349.modal_sequence = prop_types.StringProp.jsonDecode(t586.modal_sequence)
			end

			if t586.modalSequence ~= nil then
				v4349.modal_sequence = prop_types.StringProp.jsonDecode(t586.modalSequence)
			end

			if t586.conversation_id ~= nil then
				v4349.conversation_id = prop_types.StringProp.jsonDecode(t586.conversation_id)
			end

			if t586.conversationId ~= nil then
				v4349.conversation_id = prop_types.StringProp.jsonDecode(t586.conversationId)
			end

			if t586.friend_id ~= nil then
				v4349.friend_id = prop_types.StringProp.jsonDecode(t586.friend_id)
			end

			if t586.friendId ~= nil then
				v4349.friend_id = prop_types.StringProp.jsonDecode(t586.friendId)
			end

			return v4349
		end

		t583.descriptor = {
			name = "RecordPartyChatConversationUpsellAcknowledgementAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.RecordPartyChatConversationUpsellAcknowledgementAction_Params = t583
		typeRegistry.default:register(t1.RecordPartyChatConversationUpsellAcknowledgementAction_Params)

		local t587 = {}

		t587.__index = t587

		function t587.new(t588: {[any]: any}?) -- line: 27590
			-- upvalues: t1 (copy), t587 (copy)
			return (setmetatable({
				action_type = if t588 ~= nil and t588.action_type ~= nil then t588.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t588 ~= nil and t588.action_params ~= nil then t588.action_params else nil
			}, t587))
		end
		function t587.encode(p442) -- line: 27599
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n292 = 0

			if p442.action_type ~= nil and (p442.action_type ~= nil and p442.action_type ~= 0 or p442.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4354, v4355 = proto.writeTag(buf, n292, 1, proto.wireTypes.varint)

				buf, n292 = proto.writeVarInt(v4354, v4355, t1.ActionType.toNumber(p442.action_type))
			end

			if p442.action_params ~= nil then
				local v4356 = p442.action_params:encode()
				local v4357, v4358 = proto.writeTag(buf, n292, 2, proto.wireTypes.lengthDelimited)

				buf, n292 = proto.writeBuffer(v4357, v4358, v4356, buffer.len(v4356))
			end

			local buf149 = buffer.create(n292)

			buffer.copy(buf149, 0, buf, 0, n292)

			return buf149
		end
		function t587.decode(p443: buffer) -- line: 27625
			-- upvalues: t587 (copy), proto (copy), t1 (copy)
			local v4361 = t587.new()
			local n293 = 0

			while n293 < buffer.len(p443) do
				local v4363, v4364

				v4363, v4364, n293 = proto.readTag(p443, n293)

				if v4364 == proto.wireTypes.varint then
					if v4363 == 1 then
						local v4365

						v4365, n293 = proto.readVarIntI32(p443, n293)
						v4361.action_type = t1.ActionType.fromNumber(v4365) or v4365
					else
						local v4366

						v4366, n293 = proto.readVarInt(p443, n293)
					end
				elseif v4364 == proto.wireTypes.lengthDelimited then
					if v4363 == 2 then
						local v4367

						v4367, n293 = proto.readBuffer(p443, n293)
						v4361.action_params = t1.RequestFriendshipAction_Params.decode(v4367)
					else
						local v4368, v4369 = proto.readVarInt(p443, n293)

						n293 = v4369 + v4368
					end
				elseif v4364 == proto.wireTypes.i32 then
					local v4370

					v4370, n293 = proto.readFixed32(p443, n293)
				elseif v4364 == proto.wireTypes.i64 then
					local v4371

					v4371, n293 = proto.readFixed64(p443, n293)
				else
					error("Unsupported wire type: " .. v4364)
				end
			end

			return v4361
		end
		function t587.jsonEncode(p444) -- line: 27673
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
		function t587.jsonDecode(t590: {[any]: any}) -- line: 27695
			-- upvalues: t587 (copy), t1 (copy)
			local v4375 = t587.new()

			if t590.action_type ~= nil then
				v4375.action_type = if typeof(t590.action_type) ~= "number" then t1.ActionType.fromName(t590.action_type) or t590.action_type else t1.ActionType.fromNumber(t590.action_type) or t590.action_type
			end

			if t590.actionType ~= nil then
				v4375.action_type = if typeof(t590.actionType) ~= "number" then t1.ActionType.fromName(t590.actionType) or t590.actionType else t1.ActionType.fromNumber(t590.actionType) or t590.actionType
			end

			if t590.action_params ~= nil then
				v4375.action_params = t1.RequestFriendshipAction_Params.jsonDecode(t590.action_params)
			end

			if t590.actionParams ~= nil then
				v4375.action_params = t1.RequestFriendshipAction_Params.jsonDecode(t590.actionParams)
			end

			return v4375
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

		function t591.new(t592: {[any]: any}?) -- line: 27735
			-- upvalues: t591 (copy)
			return (setmetatable({
				target_user_id = if t592 ~= nil and t592.target_user_id ~= nil then t592.target_user_id else nil,
				source = if t592 ~= nil and t592.source ~= nil then t592.source else nil
			}, t591))
		end
		function t591.encode(p445) -- line: 27744
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n294 = 0

			if p445.target_user_id ~= nil then
				local v4380 = p445.target_user_id:encode()
				local v4381, v4382 = proto.writeTag(buf, n294, 1, proto.wireTypes.lengthDelimited)

				buf, n294 = proto.writeBuffer(v4381, v4382, v4380, buffer.len(v4380))
			end

			if p445.source ~= nil then
				local v4383 = p445.source:encode()
				local v4384, v4385 = proto.writeTag(buf, n294, 2, proto.wireTypes.lengthDelimited)

				buf, n294 = proto.writeBuffer(v4384, v4385, v4383, buffer.len(v4383))
			end

			local buf150 = buffer.create(n294)

			buffer.copy(buf150, 0, buf, 0, n294)

			return buf150
		end
		function t591.decode(p446: buffer) -- line: 27765
			-- upvalues: t591 (copy), proto (copy), prop_types (copy)
			local v4388 = t591.new()
			local n295 = 0

			while n295 < buffer.len(p446) do
				local v4390, v4391

				v4390, v4391, n295 = proto.readTag(p446, n295)

				if v4391 == proto.wireTypes.varint then
					local v4392

					v4392, n295 = proto.readVarInt(p446, n295)
				elseif v4391 == proto.wireTypes.lengthDelimited then
					if v4390 == 1 then
						local v4393

						v4393, n295 = proto.readBuffer(p446, n295)
						v4388.target_user_id = prop_types.StringProp.decode(v4393)
					elseif v4390 == 2 then
						local v4394

						v4394, n295 = proto.readBuffer(p446, n295)
						v4388.source = prop_types.StringProp.decode(v4394)
					else
						local v4395, v4396 = proto.readVarInt(p446, n295)

						n295 = v4396 + v4395
					end
				elseif v4391 == proto.wireTypes.i32 then
					local v4397

					v4397, n295 = proto.readFixed32(p446, n295)
				elseif v4391 == proto.wireTypes.i64 then
					local v4398

					v4398, n295 = proto.readFixed64(p446, n295)
				else
					error("Unsupported wire type: " .. v4391)
				end
			end

			return v4388
		end
		function t591.jsonEncode(p447) -- line: 27813
			local t593 = {}

			if p447.target_user_id ~= nil then
				t593.targetUserId = p447.target_user_id:jsonEncode()
			end

			if p447.source ~= nil then
				t593.source = p447.source:jsonEncode()
			end

			return t593
		end
		function t591.jsonDecode(t594: {[any]: any}) -- line: 27827
			-- upvalues: t591 (copy), prop_types (copy)
			local v4402 = t591.new()

			if t594.target_user_id ~= nil then
				v4402.target_user_id = prop_types.StringProp.jsonDecode(t594.target_user_id)
			end

			if t594.targetUserId ~= nil then
				v4402.target_user_id = prop_types.StringProp.jsonDecode(t594.targetUserId)
			end

			if t594.source ~= nil then
				v4402.source = prop_types.StringProp.jsonDecode(t594.source)
			end

			return v4402
		end

		t591.descriptor = {
			name = "RequestFriendshipAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.RequestFriendshipAction_Params = t591
		typeRegistry.default:register(t1.RequestFriendshipAction_Params)

		local t595 = {}

		t595.__index = t595

		function t595.new(t596: {[any]: any}?) -- line: 27861
			-- upvalues: t1 (copy), t595 (copy)
			return (setmetatable({
				action_type = if t596 ~= nil and t596.action_type ~= nil then t596.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t596 ~= nil and t596.action_params ~= nil then t596.action_params else nil
			}, t595))
		end
		function t595.encode(p448) -- line: 27872
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n296 = 0

			if p448.action_type ~= nil and (p448.action_type ~= nil and p448.action_type ~= 0 or p448.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4407, v4408 = proto.writeTag(buf, n296, 1, proto.wireTypes.varint)

				buf, n296 = proto.writeVarInt(v4407, v4408, t1.ActionType.toNumber(p448.action_type))
			end

			if p448.action_params ~= nil then
				local v4409 = p448.action_params:encode()
				local v4410, v4411 = proto.writeTag(buf, n296, 2, proto.wireTypes.lengthDelimited)

				buf, n296 = proto.writeBuffer(v4410, v4411, v4409, buffer.len(v4409))
			end

			local buf151 = buffer.create(n296)

			buffer.copy(buf151, 0, buf, 0, n296)

			return buf151
		end
		function t595.decode(p449: buffer) -- line: 27898
			-- upvalues: t595 (copy), proto (copy), t1 (copy)
			local v4414 = t595.new()
			local n297 = 0

			while n297 < buffer.len(p449) do
				local v4416, v4417

				v4416, v4417, n297 = proto.readTag(p449, n297)

				if v4417 == proto.wireTypes.varint then
					if v4416 == 1 then
						local v4418

						v4418, n297 = proto.readVarIntI32(p449, n297)
						v4414.action_type = t1.ActionType.fromNumber(v4418) or v4418
					else
						local v4419

						v4419, n297 = proto.readVarInt(p449, n297)
					end
				elseif v4417 == proto.wireTypes.lengthDelimited then
					if v4416 == 2 then
						local v4420

						v4420, n297 = proto.readBuffer(p449, n297)
						v4414.action_params = t1.OpenTrustedFriendsUpsellModalAction_Params.decode(v4420)
					else
						local v4421, v4422 = proto.readVarInt(p449, n297)

						n297 = v4422 + v4421
					end
				elseif v4417 == proto.wireTypes.i32 then
					local v4423

					v4423, n297 = proto.readFixed32(p449, n297)
				elseif v4417 == proto.wireTypes.i64 then
					local v4424

					v4424, n297 = proto.readFixed64(p449, n297)
				else
					error("Unsupported wire type: " .. v4417)
				end
			end

			return v4414
		end
		function t595.jsonEncode(p450) -- line: 27946
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
		function t595.jsonDecode(t598: {[any]: any}) -- line: 27968
			-- upvalues: t595 (copy), t1 (copy)
			local v4428 = t595.new()

			if t598.action_type ~= nil then
				v4428.action_type = if typeof(t598.action_type) ~= "number" then t1.ActionType.fromName(t598.action_type) or t598.action_type else t1.ActionType.fromNumber(t598.action_type) or t598.action_type
			end

			if t598.actionType ~= nil then
				v4428.action_type = if typeof(t598.actionType) ~= "number" then t1.ActionType.fromName(t598.actionType) or t598.actionType else t1.ActionType.fromNumber(t598.actionType) or t598.actionType
			end

			if t598.action_params ~= nil then
				v4428.action_params = t1.OpenTrustedFriendsUpsellModalAction_Params.jsonDecode(t598.action_params)
			end

			if t598.actionParams ~= nil then
				v4428.action_params = t1.OpenTrustedFriendsUpsellModalAction_Params.jsonDecode(t598.actionParams)
			end

			return v4428
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

		function t599.new(t600: {[any]: any}?) -- line: 28010
			-- upvalues: t599 (copy)
			return (setmetatable({
				target_user_id = if t600 ~= nil and t600.target_user_id ~= nil then t600.target_user_id else nil
			}, t599))
		end
		function t599.encode(p451) -- line: 28018
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n298 = 0

			if p451.target_user_id ~= nil then
				local v4433 = p451.target_user_id:encode()
				local v4434, v4435 = proto.writeTag(buf, n298, 1, proto.wireTypes.lengthDelimited)

				buf, n298 = proto.writeBuffer(v4434, v4435, v4433, buffer.len(v4433))
			end

			local buf152 = buffer.create(n298)

			buffer.copy(buf152, 0, buf, 0, n298)

			return buf152
		end
		function t599.decode(p452: buffer) -- line: 28035
			-- upvalues: t599 (copy), proto (copy), prop_types (copy)
			local v4438 = t599.new()
			local n299 = 0

			while n299 < buffer.len(p452) do
				local v4440, v4441

				v4440, v4441, n299 = proto.readTag(p452, n299)

				if v4441 == proto.wireTypes.varint then
					local v4442

					v4442, n299 = proto.readVarInt(p452, n299)
				elseif v4441 == proto.wireTypes.lengthDelimited then
					if v4440 == 1 then
						local v4443

						v4443, n299 = proto.readBuffer(p452, n299)
						v4438.target_user_id = prop_types.StringProp.decode(v4443)
					else
						local v4444, v4445 = proto.readVarInt(p452, n299)

						n299 = v4445 + v4444
					end
				elseif v4441 == proto.wireTypes.i32 then
					local v4446

					v4446, n299 = proto.readFixed32(p452, n299)
				elseif v4441 == proto.wireTypes.i64 then
					local v4447

					v4447, n299 = proto.readFixed64(p452, n299)
				else
					error("Unsupported wire type: " .. v4441)
				end
			end

			return v4438
		end
		function t599.jsonEncode(p453) -- line: 28080
			local t601 = {}

			if p453.target_user_id ~= nil then
				t601.targetUserId = p453.target_user_id:jsonEncode()
			end

			return t601
		end
		function t599.jsonDecode(t602: {[any]: any}) -- line: 28092
			-- upvalues: t599 (copy), prop_types (copy)
			local v4451 = t599.new()

			if t602.target_user_id ~= nil then
				v4451.target_user_id = prop_types.StringProp.jsonDecode(t602.target_user_id)
			end

			if t602.targetUserId ~= nil then
				v4451.target_user_id = prop_types.StringProp.jsonDecode(t602.targetUserId)
			end

			return v4451
		end

		t599.descriptor = {
			name = "OpenTrustedFriendsUpsellModalAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenTrustedFriendsUpsellModalAction_Params = t599
		typeRegistry.default:register(t1.OpenTrustedFriendsUpsellModalAction_Params)

		local t603 = {}

		t603.__index = t603

		function t603.new(t604: {[any]: any}?) -- line: 28124
			-- upvalues: t1 (copy), t603 (copy)
			return (setmetatable({
				action_type = if t604 ~= nil and t604.action_type ~= nil then t604.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t604 ~= nil and t604.action_params ~= nil then t604.action_params else nil
			}, t603))
		end
		function t603.encode(p454) -- line: 28135
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n300 = 0

			if p454.action_type ~= nil and (p454.action_type ~= nil and p454.action_type ~= 0 or p454.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4456, v4457 = proto.writeTag(buf, n300, 1, proto.wireTypes.varint)

				buf, n300 = proto.writeVarInt(v4456, v4457, t1.ActionType.toNumber(p454.action_type))
			end

			if p454.action_params ~= nil then
				local v4458 = p454.action_params:encode()
				local v4459, v4460 = proto.writeTag(buf, n300, 2, proto.wireTypes.lengthDelimited)

				buf, n300 = proto.writeBuffer(v4459, v4460, v4458, buffer.len(v4458))
			end

			local buf153 = buffer.create(n300)

			buffer.copy(buf153, 0, buf, 0, n300)

			return buf153
		end
		function t603.decode(p455: buffer) -- line: 28161
			-- upvalues: t603 (copy), proto (copy), t1 (copy)
			local v4463 = t603.new()
			local n301 = 0

			while n301 < buffer.len(p455) do
				local v4465, v4466

				v4465, v4466, n301 = proto.readTag(p455, n301)

				if v4466 == proto.wireTypes.varint then
					if v4465 == 1 then
						local v4467

						v4467, n301 = proto.readVarIntI32(p455, n301)
						v4463.action_type = t1.ActionType.fromNumber(v4467) or v4467
					else
						local v4468

						v4468, n301 = proto.readVarInt(p455, n301)
					end
				elseif v4466 == proto.wireTypes.lengthDelimited then
					if v4465 == 2 then
						local v4469

						v4469, n301 = proto.readBuffer(p455, n301)
						v4463.action_params = t1.OpenSearchResultsWithQueryAction_Params.decode(v4469)
					else
						local v4470, v4471 = proto.readVarInt(p455, n301)

						n301 = v4471 + v4470
					end
				elseif v4466 == proto.wireTypes.i32 then
					local v4472

					v4472, n301 = proto.readFixed32(p455, n301)
				elseif v4466 == proto.wireTypes.i64 then
					local v4473

					v4473, n301 = proto.readFixed64(p455, n301)
				else
					error("Unsupported wire type: " .. v4466)
				end
			end

			return v4463
		end
		function t603.jsonEncode(p456) -- line: 28209
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
		function t603.jsonDecode(t606: {[any]: any}) -- line: 28231
			-- upvalues: t603 (copy), t1 (copy)
			local v4477 = t603.new()

			if t606.action_type ~= nil then
				v4477.action_type = if typeof(t606.action_type) ~= "number" then t1.ActionType.fromName(t606.action_type) or t606.action_type else t1.ActionType.fromNumber(t606.action_type) or t606.action_type
			end

			if t606.actionType ~= nil then
				v4477.action_type = if typeof(t606.actionType) ~= "number" then t1.ActionType.fromName(t606.actionType) or t606.actionType else t1.ActionType.fromNumber(t606.actionType) or t606.actionType
			end

			if t606.action_params ~= nil then
				v4477.action_params = t1.OpenSearchResultsWithQueryAction_Params.jsonDecode(t606.action_params)
			end

			if t606.actionParams ~= nil then
				v4477.action_params = t1.OpenSearchResultsWithQueryAction_Params.jsonDecode(t606.actionParams)
			end

			return v4477
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

		function t607.new(t608: {[any]: any}?) -- line: 28273
			-- upvalues: t607 (copy)
			return (setmetatable({
				search_query = if t608 ~= nil and t608.search_query ~= nil then t608.search_query else nil,
				search_type = if t608 ~= nil and t608.search_type ~= nil then t608.search_type else nil
			}, t607))
		end
		function t607.encode(p457) -- line: 28282
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n302 = 0

			if p457.search_query ~= nil then
				local v4482 = p457.search_query:encode()
				local v4483, v4484 = proto.writeTag(buf, n302, 1, proto.wireTypes.lengthDelimited)

				buf, n302 = proto.writeBuffer(v4483, v4484, v4482, buffer.len(v4482))
			end

			if p457.search_type ~= nil then
				local v4485 = p457.search_type:encode()
				local v4486, v4487 = proto.writeTag(buf, n302, 2, proto.wireTypes.lengthDelimited)

				buf, n302 = proto.writeBuffer(v4486, v4487, v4485, buffer.len(v4485))
			end

			local buf154 = buffer.create(n302)

			buffer.copy(buf154, 0, buf, 0, n302)

			return buf154
		end
		function t607.decode(p458: buffer) -- line: 28303
			-- upvalues: t607 (copy), proto (copy), prop_types (copy)
			local v4490 = t607.new()
			local n303 = 0

			while n303 < buffer.len(p458) do
				local v4492, v4493

				v4492, v4493, n303 = proto.readTag(p458, n303)

				if v4493 == proto.wireTypes.varint then
					local v4494

					v4494, n303 = proto.readVarInt(p458, n303)
				elseif v4493 == proto.wireTypes.lengthDelimited then
					if v4492 == 1 then
						local v4495

						v4495, n303 = proto.readBuffer(p458, n303)
						v4490.search_query = prop_types.StringProp.decode(v4495)
					elseif v4492 == 2 then
						local v4496

						v4496, n303 = proto.readBuffer(p458, n303)
						v4490.search_type = prop_types.StringProp.decode(v4496)
					else
						local v4497, v4498 = proto.readVarInt(p458, n303)

						n303 = v4498 + v4497
					end
				elseif v4493 == proto.wireTypes.i32 then
					local v4499

					v4499, n303 = proto.readFixed32(p458, n303)
				elseif v4493 == proto.wireTypes.i64 then
					local v4500

					v4500, n303 = proto.readFixed64(p458, n303)
				else
					error("Unsupported wire type: " .. v4493)
				end
			end

			return v4490
		end
		function t607.jsonEncode(p459) -- line: 28351
			local t609 = {}

			if p459.search_query ~= nil then
				t609.searchQuery = p459.search_query:jsonEncode()
			end

			if p459.search_type ~= nil then
				t609.searchType = p459.search_type:jsonEncode()
			end

			return t609
		end
		function t607.jsonDecode(t610: {[any]: any}) -- line: 28365
			-- upvalues: t607 (copy), prop_types (copy)
			local v4504 = t607.new()

			if t610.search_query ~= nil then
				v4504.search_query = prop_types.StringProp.jsonDecode(t610.search_query)
			end

			if t610.searchQuery ~= nil then
				v4504.search_query = prop_types.StringProp.jsonDecode(t610.searchQuery)
			end

			if t610.search_type ~= nil then
				v4504.search_type = prop_types.StringProp.jsonDecode(t610.search_type)
			end

			if t610.searchType ~= nil then
				v4504.search_type = prop_types.StringProp.jsonDecode(t610.searchType)
			end

			return v4504
		end

		t607.descriptor = {
			name = "OpenSearchResultsWithQueryAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenSearchResultsWithQueryAction_Params = t607
		typeRegistry.default:register(t1.OpenSearchResultsWithQueryAction_Params)

		local t611 = {}

		t611.__index = t611

		function t611.new(t612: {[any]: any}?) -- line: 28406
			-- upvalues: t1 (copy), t611 (copy)
			return (setmetatable({
				action_type = if t612 ~= nil and t612.action_type ~= nil then t612.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t612 ~= nil and t612.action_params ~= nil then t612.action_params else nil
			}, t611))
		end
		function t611.encode(p460) -- line: 28417
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n304 = 0

			if p460.action_type ~= nil and (p460.action_type ~= nil and p460.action_type ~= 0 or p460.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4509, v4510 = proto.writeTag(buf, n304, 1, proto.wireTypes.varint)

				buf, n304 = proto.writeVarInt(v4509, v4510, t1.ActionType.toNumber(p460.action_type))
			end

			if p460.action_params ~= nil then
				local v4511 = p460.action_params:encode()
				local v4512, v4513 = proto.writeTag(buf, n304, 2, proto.wireTypes.lengthDelimited)

				buf, n304 = proto.writeBuffer(v4512, v4513, v4511, buffer.len(v4511))
			end

			local buf155 = buffer.create(n304)

			buffer.copy(buf155, 0, buf, 0, n304)

			return buf155
		end
		function t611.decode(p461: buffer) -- line: 28443
			-- upvalues: t611 (copy), proto (copy), t1 (copy)
			local v4516 = t611.new()
			local n305 = 0

			while n305 < buffer.len(p461) do
				local v4518, v4519

				v4518, v4519, n305 = proto.readTag(p461, n305)

				if v4519 == proto.wireTypes.varint then
					if v4518 == 1 then
						local v4520

						v4520, n305 = proto.readVarIntI32(p461, n305)
						v4516.action_type = t1.ActionType.fromNumber(v4520) or v4520
					else
						local v4521

						v4521, n305 = proto.readVarInt(p461, n305)
					end
				elseif v4519 == proto.wireTypes.lengthDelimited then
					if v4518 == 2 then
						local v4522

						v4522, n305 = proto.readBuffer(p461, n305)
						v4516.action_params = t1.SelectMarketplaceFavoritesCategory_Params.decode(v4522)
					else
						local v4523, v4524 = proto.readVarInt(p461, n305)

						n305 = v4524 + v4523
					end
				elseif v4519 == proto.wireTypes.i32 then
					local v4525

					v4525, n305 = proto.readFixed32(p461, n305)
				elseif v4519 == proto.wireTypes.i64 then
					local v4526

					v4526, n305 = proto.readFixed64(p461, n305)
				else
					error("Unsupported wire type: " .. v4519)
				end
			end

			return v4516
		end
		function t611.jsonEncode(p462) -- line: 28491
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
		function t611.jsonDecode(t614: {[any]: any}) -- line: 28513
			-- upvalues: t611 (copy), t1 (copy)
			local v4530 = t611.new()

			if t614.action_type ~= nil then
				v4530.action_type = if typeof(t614.action_type) ~= "number" then t1.ActionType.fromName(t614.action_type) or t614.action_type else t1.ActionType.fromNumber(t614.action_type) or t614.action_type
			end

			if t614.actionType ~= nil then
				v4530.action_type = if typeof(t614.actionType) ~= "number" then t1.ActionType.fromName(t614.actionType) or t614.actionType else t1.ActionType.fromNumber(t614.actionType) or t614.actionType
			end

			if t614.action_params ~= nil then
				v4530.action_params = t1.SelectMarketplaceFavoritesCategory_Params.jsonDecode(t614.action_params)
			end

			if t614.actionParams ~= nil then
				v4530.action_params = t1.SelectMarketplaceFavoritesCategory_Params.jsonDecode(t614.actionParams)
			end

			return v4530
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

		function t615.new(t616: {[any]: any}?) -- line: 28555
			-- upvalues: t615 (copy)
			return (setmetatable({
				category_id = if t616 ~= nil and t616.category_id ~= nil then t616.category_id else nil
			}, t615))
		end
		function t615.encode(p463) -- line: 28563
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n306 = 0

			if p463.category_id ~= nil then
				local v4535 = p463.category_id:encode()
				local v4536, v4537 = proto.writeTag(buf, n306, 1, proto.wireTypes.lengthDelimited)

				buf, n306 = proto.writeBuffer(v4536, v4537, v4535, buffer.len(v4535))
			end

			local buf156 = buffer.create(n306)

			buffer.copy(buf156, 0, buf, 0, n306)

			return buf156
		end
		function t615.decode(p464: buffer) -- line: 28580
			-- upvalues: t615 (copy), proto (copy), prop_types (copy)
			local v4540 = t615.new()
			local n307 = 0

			while n307 < buffer.len(p464) do
				local v4542, v4543

				v4542, v4543, n307 = proto.readTag(p464, n307)

				if v4543 == proto.wireTypes.varint then
					local v4544

					v4544, n307 = proto.readVarInt(p464, n307)
				elseif v4543 == proto.wireTypes.lengthDelimited then
					if v4542 == 1 then
						local v4545

						v4545, n307 = proto.readBuffer(p464, n307)
						v4540.category_id = prop_types.StringProp.decode(v4545)
					else
						local v4546, v4547 = proto.readVarInt(p464, n307)

						n307 = v4547 + v4546
					end
				elseif v4543 == proto.wireTypes.i32 then
					local v4548

					v4548, n307 = proto.readFixed32(p464, n307)
				elseif v4543 == proto.wireTypes.i64 then
					local v4549

					v4549, n307 = proto.readFixed64(p464, n307)
				else
					error("Unsupported wire type: " .. v4543)
				end
			end

			return v4540
		end
		function t615.jsonEncode(p465) -- line: 28625
			local t617 = {}

			if p465.category_id ~= nil then
				t617.categoryId = p465.category_id:jsonEncode()
			end

			return t617
		end
		function t615.jsonDecode(t618: {[any]: any}) -- line: 28637
			-- upvalues: t615 (copy), prop_types (copy)
			local v4553 = t615.new()

			if t618.category_id ~= nil then
				v4553.category_id = prop_types.StringProp.jsonDecode(t618.category_id)
			end

			if t618.categoryId ~= nil then
				v4553.category_id = prop_types.StringProp.jsonDecode(t618.categoryId)
			end

			return v4553
		end

		t615.descriptor = {
			name = "SelectMarketplaceFavoritesCategory_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.SelectMarketplaceFavoritesCategory_Params = t615
		typeRegistry.default:register(t1.SelectMarketplaceFavoritesCategory_Params)

		local t619 = {}

		t619.__index = t619

		function t619.new(t620: {[any]: any}?) -- line: 28668
			-- upvalues: t1 (copy), t619 (copy)
			return (setmetatable({
				action_type = if t620 ~= nil and t620.action_type ~= nil then t620.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t620 ~= nil and t620.action_params ~= nil then t620.action_params else nil
			}, t619))
		end
		function t619.encode(p466) -- line: 28679
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n308 = 0

			if p466.action_type ~= nil and (p466.action_type ~= nil and p466.action_type ~= 0 or p466.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4558, v4559 = proto.writeTag(buf, n308, 1, proto.wireTypes.varint)

				buf, n308 = proto.writeVarInt(v4558, v4559, t1.ActionType.toNumber(p466.action_type))
			end

			if p466.action_params ~= nil then
				local v4560 = p466.action_params:encode()
				local v4561, v4562 = proto.writeTag(buf, n308, 2, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4561, v4562, v4560, buffer.len(v4560))
			end

			local buf157 = buffer.create(n308)

			buffer.copy(buf157, 0, buf, 0, n308)

			return buf157
		end
		function t619.decode(p467: buffer) -- line: 28705
			-- upvalues: t619 (copy), proto (copy), t1 (copy)
			local v4565 = t619.new()
			local n309 = 0

			while n309 < buffer.len(p467) do
				local v4567, v4568

				v4567, v4568, n309 = proto.readTag(p467, n309)

				if v4568 == proto.wireTypes.varint then
					if v4567 == 1 then
						local v4569

						v4569, n309 = proto.readVarIntI32(p467, n309)
						v4565.action_type = t1.ActionType.fromNumber(v4569) or v4569
					else
						local v4570

						v4570, n309 = proto.readVarInt(p467, n309)
					end
				elseif v4568 == proto.wireTypes.lengthDelimited then
					if v4567 == 2 then
						local v4571

						v4571, n309 = proto.readBuffer(p467, n309)
						v4565.action_params = t1.SelectMarketplaceFavoritesSubcategory_Params.decode(v4571)
					else
						local v4572, v4573 = proto.readVarInt(p467, n309)

						n309 = v4573 + v4572
					end
				elseif v4568 == proto.wireTypes.i32 then
					local v4574

					v4574, n309 = proto.readFixed32(p467, n309)
				elseif v4568 == proto.wireTypes.i64 then
					local v4575

					v4575, n309 = proto.readFixed64(p467, n309)
				else
					error("Unsupported wire type: " .. v4568)
				end
			end

			return v4565
		end
		function t619.jsonEncode(p468) -- line: 28753
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
		function t619.jsonDecode(t622: {[any]: any}) -- line: 28775
			-- upvalues: t619 (copy), t1 (copy)
			local v4579 = t619.new()

			if t622.action_type ~= nil then
				v4579.action_type = if typeof(t622.action_type) ~= "number" then t1.ActionType.fromName(t622.action_type) or t622.action_type else t1.ActionType.fromNumber(t622.action_type) or t622.action_type
			end

			if t622.actionType ~= nil then
				v4579.action_type = if typeof(t622.actionType) ~= "number" then t1.ActionType.fromName(t622.actionType) or t622.actionType else t1.ActionType.fromNumber(t622.actionType) or t622.actionType
			end

			if t622.action_params ~= nil then
				v4579.action_params = t1.SelectMarketplaceFavoritesSubcategory_Params.jsonDecode(t622.action_params)
			end

			if t622.actionParams ~= nil then
				v4579.action_params = t1.SelectMarketplaceFavoritesSubcategory_Params.jsonDecode(t622.actionParams)
			end

			return v4579
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

		function t623.new(t624: {[any]: any}?) -- line: 28817
			-- upvalues: t623 (copy)
			return (setmetatable({
				subcategory_id = if t624 ~= nil and t624.subcategory_id ~= nil then t624.subcategory_id else nil
			}, t623))
		end
		function t623.encode(p469) -- line: 28825
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n310 = 0

			if p469.subcategory_id ~= nil then
				local v4584 = p469.subcategory_id:encode()
				local v4585, v4586 = proto.writeTag(buf, n310, 1, proto.wireTypes.lengthDelimited)

				buf, n310 = proto.writeBuffer(v4585, v4586, v4584, buffer.len(v4584))
			end

			local buf158 = buffer.create(n310)

			buffer.copy(buf158, 0, buf, 0, n310)

			return buf158
		end
		function t623.decode(p470: buffer) -- line: 28842
			-- upvalues: t623 (copy), proto (copy), prop_types (copy)
			local v4589 = t623.new()
			local n311 = 0

			while n311 < buffer.len(p470) do
				local v4591, v4592

				v4591, v4592, n311 = proto.readTag(p470, n311)

				if v4592 == proto.wireTypes.varint then
					local v4593

					v4593, n311 = proto.readVarInt(p470, n311)
				elseif v4592 == proto.wireTypes.lengthDelimited then
					if v4591 == 1 then
						local v4594

						v4594, n311 = proto.readBuffer(p470, n311)
						v4589.subcategory_id = prop_types.StringProp.decode(v4594)
					else
						local v4595, v4596 = proto.readVarInt(p470, n311)

						n311 = v4596 + v4595
					end
				elseif v4592 == proto.wireTypes.i32 then
					local v4597

					v4597, n311 = proto.readFixed32(p470, n311)
				elseif v4592 == proto.wireTypes.i64 then
					local v4598

					v4598, n311 = proto.readFixed64(p470, n311)
				else
					error("Unsupported wire type: " .. v4592)
				end
			end

			return v4589
		end
		function t623.jsonEncode(p471) -- line: 28887
			local t625 = {}

			if p471.subcategory_id ~= nil then
				t625.subcategoryId = p471.subcategory_id:jsonEncode()
			end

			return t625
		end
		function t623.jsonDecode(t626: {[any]: any}) -- line: 28899
			-- upvalues: t623 (copy), prop_types (copy)
			local v4602 = t623.new()

			if t626.subcategory_id ~= nil then
				v4602.subcategory_id = prop_types.StringProp.jsonDecode(t626.subcategory_id)
			end

			if t626.subcategoryId ~= nil then
				v4602.subcategory_id = prop_types.StringProp.jsonDecode(t626.subcategoryId)
			end

			return v4602
		end

		t623.descriptor = {
			name = "SelectMarketplaceFavoritesSubcategory_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.SelectMarketplaceFavoritesSubcategory_Params = t623
		typeRegistry.default:register(t1.SelectMarketplaceFavoritesSubcategory_Params)

		local t627 = {}

		t627.__index = t627

		function t627.new(t628: {[any]: any}?) -- line: 28931
			-- upvalues: t1 (copy), t627 (copy)
			return (setmetatable({
				action_type = if t628 ~= nil and t628.action_type ~= nil then t628.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t628 ~= nil and t628.action_params ~= nil then t628.action_params else nil
			}, t627))
		end
		function t627.encode(p472) -- line: 28942
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n312 = 0

			if p472.action_type ~= nil and (p472.action_type ~= nil and p472.action_type ~= 0 or p472.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4607, v4608 = proto.writeTag(buf, n312, 1, proto.wireTypes.varint)

				buf, n312 = proto.writeVarInt(v4607, v4608, t1.ActionType.toNumber(p472.action_type))
			end

			if p472.action_params ~= nil then
				local v4609 = p472.action_params:encode()
				local v4610, v4611 = proto.writeTag(buf, n312, 2, proto.wireTypes.lengthDelimited)

				buf, n312 = proto.writeBuffer(v4610, v4611, v4609, buffer.len(v4609))
			end

			local buf159 = buffer.create(n312)

			buffer.copy(buf159, 0, buf, 0, n312)

			return buf159
		end
		function t627.decode(p473: buffer) -- line: 28968
			-- upvalues: t627 (copy), proto (copy), t1 (copy)
			local v4614 = t627.new()
			local n313 = 0

			while n313 < buffer.len(p473) do
				local v4616, v4617

				v4616, v4617, n313 = proto.readTag(p473, n313)

				if v4617 == proto.wireTypes.varint then
					if v4616 == 1 then
						local v4618

						v4618, n313 = proto.readVarIntI32(p473, n313)
						v4614.action_type = t1.ActionType.fromNumber(v4618) or v4618
					else
						local v4619

						v4619, n313 = proto.readVarInt(p473, n313)
					end
				elseif v4617 == proto.wireTypes.lengthDelimited then
					if v4616 == 2 then
						local v4620

						v4620, n313 = proto.readBuffer(p473, n313)
						v4614.action_params = t1.PinExperienceShortcutAction_Params.decode(v4620)
					else
						local v4621, v4622 = proto.readVarInt(p473, n313)

						n313 = v4622 + v4621
					end
				elseif v4617 == proto.wireTypes.i32 then
					local v4623

					v4623, n313 = proto.readFixed32(p473, n313)
				elseif v4617 == proto.wireTypes.i64 then
					local v4624

					v4624, n313 = proto.readFixed64(p473, n313)
				else
					error("Unsupported wire type: " .. v4617)
				end
			end

			return v4614
		end
		function t627.jsonEncode(p474) -- line: 29016
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
		function t627.jsonDecode(t630: {[any]: any}) -- line: 29038
			-- upvalues: t627 (copy), t1 (copy)
			local v4628 = t627.new()

			if t630.action_type ~= nil then
				v4628.action_type = if typeof(t630.action_type) ~= "number" then t1.ActionType.fromName(t630.action_type) or t630.action_type else t1.ActionType.fromNumber(t630.action_type) or t630.action_type
			end

			if t630.actionType ~= nil then
				v4628.action_type = if typeof(t630.actionType) ~= "number" then t1.ActionType.fromName(t630.actionType) or t630.actionType else t1.ActionType.fromNumber(t630.actionType) or t630.actionType
			end

			if t630.action_params ~= nil then
				v4628.action_params = t1.PinExperienceShortcutAction_Params.jsonDecode(t630.action_params)
			end

			if t630.actionParams ~= nil then
				v4628.action_params = t1.PinExperienceShortcutAction_Params.jsonDecode(t630.actionParams)
			end

			return v4628
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

		function t631.new(t632: {[any]: any}?) -- line: 29078
			-- upvalues: t631 (copy)
			return (setmetatable({
				place_id = if t632 ~= nil and t632.place_id ~= nil then t632.place_id else nil,
				universe_id = if t632 ~= nil and t632.universe_id ~= nil then t632.universe_id else nil,
				game_name = if t632 ~= nil and t632.game_name ~= nil then t632.game_name else nil
			}, t631))
		end
		function t631.encode(p475) -- line: 29088
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n314 = 0

			if p475.place_id ~= nil then
				local v4633 = p475.place_id:encode()
				local v4634, v4635 = proto.writeTag(buf, n314, 1, proto.wireTypes.lengthDelimited)

				buf, n314 = proto.writeBuffer(v4634, v4635, v4633, buffer.len(v4633))
			end

			if p475.universe_id ~= nil then
				local v4636 = p475.universe_id:encode()
				local v4637, v4638 = proto.writeTag(buf, n314, 2, proto.wireTypes.lengthDelimited)

				buf, n314 = proto.writeBuffer(v4637, v4638, v4636, buffer.len(v4636))
			end

			if p475.game_name ~= nil then
				local v4639 = p475.game_name:encode()
				local v4640, v4641 = proto.writeTag(buf, n314, 3, proto.wireTypes.lengthDelimited)

				buf, n314 = proto.writeBuffer(v4640, v4641, v4639, buffer.len(v4639))
			end

			local buf160 = buffer.create(n314)

			buffer.copy(buf160, 0, buf, 0, n314)

			return buf160
		end
		function t631.decode(p476: buffer) -- line: 29115
			-- upvalues: t631 (copy), proto (copy), prop_types (copy)
			local v4644 = t631.new()
			local n315 = 0

			while n315 < buffer.len(p476) do
				local v4646, v4647

				v4646, v4647, n315 = proto.readTag(p476, n315)

				if v4647 == proto.wireTypes.varint then
					local v4648

					v4648, n315 = proto.readVarInt(p476, n315)
				elseif v4647 == proto.wireTypes.lengthDelimited then
					if v4646 == 1 then
						local v4649

						v4649, n315 = proto.readBuffer(p476, n315)
						v4644.place_id = prop_types.StringProp.decode(v4649)
					elseif v4646 == 2 then
						local v4650

						v4650, n315 = proto.readBuffer(p476, n315)
						v4644.universe_id = prop_types.StringProp.decode(v4650)
					elseif v4646 == 3 then
						local v4651

						v4651, n315 = proto.readBuffer(p476, n315)
						v4644.game_name = prop_types.StringProp.decode(v4651)
					else
						local v4652, v4653 = proto.readVarInt(p476, n315)

						n315 = v4653 + v4652
					end
				elseif v4647 == proto.wireTypes.i32 then
					local v4654

					v4654, n315 = proto.readFixed32(p476, n315)
				elseif v4647 == proto.wireTypes.i64 then
					local v4655

					v4655, n315 = proto.readFixed64(p476, n315)
				else
					error("Unsupported wire type: " .. v4647)
				end
			end

			return v4644
		end
		function t631.jsonEncode(p477) -- line: 29168
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
		function t631.jsonDecode(t634: {[any]: any}) -- line: 29186
			-- upvalues: t631 (copy), prop_types (copy)
			local v4659 = t631.new()

			if t634.place_id ~= nil then
				v4659.place_id = prop_types.StringProp.jsonDecode(t634.place_id)
			end

			if t634.placeId ~= nil then
				v4659.place_id = prop_types.StringProp.jsonDecode(t634.placeId)
			end

			if t634.universe_id ~= nil then
				v4659.universe_id = prop_types.StringProp.jsonDecode(t634.universe_id)
			end

			if t634.universeId ~= nil then
				v4659.universe_id = prop_types.StringProp.jsonDecode(t634.universeId)
			end

			if t634.game_name ~= nil then
				v4659.game_name = prop_types.StringProp.jsonDecode(t634.game_name)
			end

			if t634.gameName ~= nil then
				v4659.game_name = prop_types.StringProp.jsonDecode(t634.gameName)
			end

			return v4659
		end

		t631.descriptor = {
			name = "PinExperienceShortcutAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.PinExperienceShortcutAction_Params = t631
		typeRegistry.default:register(t1.PinExperienceShortcutAction_Params)

		local t635 = {}

		t635.__index = t635

		function t635.new(t636: {[any]: any}?) -- line: 29233
			-- upvalues: t1 (copy), t635 (copy)
			return (setmetatable({
				action_type = if t636 ~= nil and t636.action_type ~= nil then t636.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t636 ~= nil and t636.action_params ~= nil then t636.action_params else nil
			}, t635))
		end
		function t635.encode(p478) -- line: 29242
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n316 = 0

			if p478.action_type ~= nil and (p478.action_type ~= nil and p478.action_type ~= 0 or p478.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4664, v4665 = proto.writeTag(buf, n316, 1, proto.wireTypes.varint)

				buf, n316 = proto.writeVarInt(v4664, v4665, t1.ActionType.toNumber(p478.action_type))
			end

			if p478.action_params ~= nil then
				local v4666 = p478.action_params:encode()
				local v4667, v4668 = proto.writeTag(buf, n316, 2, proto.wireTypes.lengthDelimited)

				buf, n316 = proto.writeBuffer(v4667, v4668, v4666, buffer.len(v4666))
			end

			local buf161 = buffer.create(n316)

			buffer.copy(buf161, 0, buf, 0, n316)

			return buf161
		end
		function t635.decode(p479: buffer) -- line: 29268
			-- upvalues: t635 (copy), proto (copy), t1 (copy)
			local v4671 = t635.new()
			local n317 = 0

			while n317 < buffer.len(p479) do
				local v4673, v4674

				v4673, v4674, n317 = proto.readTag(p479, n317)

				if v4674 == proto.wireTypes.varint then
					if v4673 == 1 then
						local v4675

						v4675, n317 = proto.readVarIntI32(p479, n317)
						v4671.action_type = t1.ActionType.fromNumber(v4675) or v4675
					else
						local v4676

						v4676, n317 = proto.readVarInt(p479, n317)
					end
				elseif v4674 == proto.wireTypes.lengthDelimited then
					if v4673 == 2 then
						local v4677

						v4677, n317 = proto.readBuffer(p479, n317)
						v4671.action_params = t1.DownloadAppAction_Params.decode(v4677)
					else
						local v4678, v4679 = proto.readVarInt(p479, n317)

						n317 = v4679 + v4678
					end
				elseif v4674 == proto.wireTypes.i32 then
					local v4680

					v4680, n317 = proto.readFixed32(p479, n317)
				elseif v4674 == proto.wireTypes.i64 then
					local v4681

					v4681, n317 = proto.readFixed64(p479, n317)
				else
					error("Unsupported wire type: " .. v4674)
				end
			end

			return v4671
		end
		function t635.jsonEncode(p480) -- line: 29316
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
		function t635.jsonDecode(t638: {[any]: any}) -- line: 29338
			-- upvalues: t635 (copy), t1 (copy)
			local v4685 = t635.new()

			if t638.action_type ~= nil then
				v4685.action_type = if typeof(t638.action_type) ~= "number" then t1.ActionType.fromName(t638.action_type) or t638.action_type else t1.ActionType.fromNumber(t638.action_type) or t638.action_type
			end

			if t638.actionType ~= nil then
				v4685.action_type = if typeof(t638.actionType) ~= "number" then t1.ActionType.fromName(t638.actionType) or t638.actionType else t1.ActionType.fromNumber(t638.actionType) or t638.actionType
			end

			if t638.action_params ~= nil then
				v4685.action_params = t1.DownloadAppAction_Params.jsonDecode(t638.action_params)
			end

			if t638.actionParams ~= nil then
				v4685.action_params = t1.DownloadAppAction_Params.jsonDecode(t638.actionParams)
			end

			return v4685
		end

		t635.descriptor = {
			name = "DownloadAppAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.DownloadAppAction"
		}
		t1.DownloadAppAction = t635
	end

	typeRegistry.default:register(t1.DownloadAppAction)

	local t639 = {}

	t639.__index = t639

	function t639.new(t640: {[any]: any}?) -- line: 29378
		-- upvalues: t639 (copy)
		return (setmetatable({
			source = if t640 ~= nil and t640.source ~= nil then t640.source else nil,
			download_type = if t640 ~= nil and t640.download_type ~= nil then t640.download_type else nil
		}, t639))
	end
	function t639.encode(p481) -- line: 29385
		-- upvalues: proto (copy)
		local buf = buffer.create(0)
		local n318 = 0

		if p481.source ~= nil then
			local v4690 = p481.source:encode()
			local v4691, v4692 = proto.writeTag(buf, n318, 1, proto.wireTypes.lengthDelimited)

			buf, n318 = proto.writeBuffer(v4691, v4692, v4690, buffer.len(v4690))
		end

		if p481.download_type ~= nil then
			local v4693 = p481.download_type:encode()
			local v4694, v4695 = proto.writeTag(buf, n318, 2, proto.wireTypes.lengthDelimited)

			buf, n318 = proto.writeBuffer(v4694, v4695, v4693, buffer.len(v4693))
		end

		local buf162 = buffer.create(n318)

		buffer.copy(buf162, 0, buf, 0, n318)

		return buf162
	end
	function t639.decode(p482: buffer) -- line: 29406
		-- upvalues: t639 (copy), proto (copy), prop_types (copy)
		local v4698 = t639.new()
		local n319 = 0

		while n319 < buffer.len(p482) do
			local v4700, v4701

			v4700, v4701, n319 = proto.readTag(p482, n319)

			if v4701 == proto.wireTypes.varint then
				local v4702

				v4702, n319 = proto.readVarInt(p482, n319)
			elseif v4701 == proto.wireTypes.lengthDelimited then
				if v4700 == 1 then
					local v4703

					v4703, n319 = proto.readBuffer(p482, n319)
					v4698.source = prop_types.StringProp.decode(v4703)
				elseif v4700 == 2 then
					local v4704

					v4704, n319 = proto.readBuffer(p482, n319)
					v4698.download_type = prop_types.StringProp.decode(v4704)
				else
					local v4705, v4706 = proto.readVarInt(p482, n319)

					n319 = v4706 + v4705
				end
			elseif v4701 == proto.wireTypes.i32 then
				local v4707

				v4707, n319 = proto.readFixed32(p482, n319)
			elseif v4701 == proto.wireTypes.i64 then
				local v4708

				v4708, n319 = proto.readFixed64(p482, n319)
			else
				error("Unsupported wire type: " .. v4701)
			end
		end

		return v4698
	end
	function t639.jsonEncode(p483) -- line: 29454
		local t641 = {}

		if p483.source ~= nil then
			t641.source = p483.source:jsonEncode()
		end

		if p483.download_type ~= nil then
			t641.downloadType = p483.download_type:jsonEncode()
		end

		return t641
	end
	function t639.jsonDecode(t642: {[any]: any}) -- line: 29468
		-- upvalues: t639 (copy), prop_types (copy)
		local v4712 = t639.new()

		if t642.source ~= nil then
			v4712.source = prop_types.StringProp.jsonDecode(t642.source)
		end

		if t642.download_type ~= nil then
			v4712.download_type = prop_types.StringProp.jsonDecode(t642.download_type)
		end

		if t642.downloadType ~= nil then
			v4712.download_type = prop_types.StringProp.jsonDecode(t642.downloadType)
		end

		return v4712
	end

	t639.descriptor = {
		name = "DownloadAppAction_Params",
		fullName = "roblox.apppageplatform.shared.v1beta1.Params"
	}
	t1.DownloadAppAction_Params = t639
	typeRegistry.default:register(t1.DownloadAppAction_Params)

	local t643 = {}

	t643.__index = t643

	function t643.new(t644: {[any]: any}?) -- line: 29502
		-- upvalues: t643 (copy)
		return (setmetatable({
			kind = if t644 ~= nil and t644.kind ~= nil then t644.kind else nil,
			telemetry_handler = if t644 ~= nil and t644.telemetry_handler ~= nil then t644.telemetry_handler else nil,
			accessibility_label = if t644 ~= nil and t644.accessibility_label ~= nil then t644.accessibility_label else nil
		}, t643))
	end
	function t643.encode(p484) -- line: 29512
		-- upvalues: proto (copy)
		local buf = buffer.create(0)
		local n320 = 0

		if p484.kind ~= nil then
			if p484.kind.type == "dismiss_dialog_action" then
				local v4717 = p484.kind.value:encode()
				local v4718, v4719 = proto.writeTag(buf, n320, 1, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4718, v4719, v4717, buffer.len(v4717))
			elseif p484.kind.type == "link_action" then
				local v4720 = p484.kind.value:encode()
				local v4721, v4722 = proto.writeTag(buf, n320, 2, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4721, v4722, v4720, buffer.len(v4720))
			elseif p484.kind.type == "open_game_details_action" then
				local v4723 = p484.kind.value:encode()
				local v4724, v4725 = proto.writeTag(buf, n320, 3, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4724, v4725, v4723, buffer.len(v4723))
			elseif p484.kind.type == "open_join_friends_action" then
				local v4726 = p484.kind.value:encode()
				local v4727, v4728 = proto.writeTag(buf, n320, 4, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4727, v4728, v4726, buffer.len(v4726))
			elseif p484.kind.type == "open_marketplace_try_on_action" then
				local v4729 = p484.kind.value:encode()
				local v4730, v4731 = proto.writeTag(buf, n320, 5, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4730, v4731, v4729, buffer.len(v4729))
			elseif p484.kind.type == "open_see_all_action" then
				local v4732 = p484.kind.value:encode()
				local v4733, v4734 = proto.writeTag(buf, n320, 6, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4733, v4734, v4732, buffer.len(v4732))
			elseif p484.kind.type == "open_sponsored_tooltip_action" then
				local v4735 = p484.kind.value:encode()
				local v4736, v4737 = proto.writeTag(buf, n320, 7, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4736, v4737, v4735, buffer.len(v4735))
			elseif p484.kind.type == "play_button_click_action" then
				local v4738 = p484.kind.value:encode()
				local v4739, v4740 = proto.writeTag(buf, n320, 8, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4739, v4740, v4738, buffer.len(v4738))
			elseif p484.kind.type == "update_user_settings_action" then
				local v4741 = p484.kind.value:encode()
				local v4742, v4743 = proto.writeTag(buf, n320, 9, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4742, v4743, v4741, buffer.len(v4741))
			elseif p484.kind.type == "open_tooltip_action" then
				local v4744 = p484.kind.value:encode()
				local v4745, v4746 = proto.writeTag(buf, n320, 10, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4745, v4746, v4744, buffer.len(v4744))
			elseif p484.kind.type == "open_badge_details_action" then
				local v4747 = p484.kind.value:encode()
				local v4748, v4749 = proto.writeTag(buf, n320, 11, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4748, v4749, v4747, buffer.len(v4747))
			elseif p484.kind.type == "load_more_from_api_action" then
				local v4750 = p484.kind.value:encode()
				local v4751, v4752 = proto.writeTag(buf, n320, 12, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4751, v4752, v4750, buffer.len(v4750))
			elseif p484.kind.type == "share_action" then
				local v4753 = p484.kind.value:encode()
				local v4754, v4755 = proto.writeTag(buf, n320, 13, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4754, v4755, v4753, buffer.len(v4753))
			elseif p484.kind.type == "open_abuse_report_action" then
				local v4756 = p484.kind.value:encode()
				local v4757, v4758 = proto.writeTag(buf, n320, 14, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4757, v4758, v4756, buffer.len(v4756))
			elseif p484.kind.type == "remove_badge_from_inventory_action" then
				local v4759 = p484.kind.value:encode()
				local v4760, v4761 = proto.writeTag(buf, n320, 15, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4760, v4761, v4759, buffer.len(v4759))
			elseif p484.kind.type == "open_profile_action" then
				local v4762 = p484.kind.value:encode()
				local v4763, v4764 = proto.writeTag(buf, n320, 16, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4763, v4764, v4762, buffer.len(v4762))
			elseif p484.kind.type == "open_facial_age_estimation_action" then
				local v4765 = p484.kind.value:encode()
				local v4766, v4767 = proto.writeTag(buf, n320, 17, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4766, v4767, v4765, buffer.len(v4765))
			elseif p484.kind.type == "open_add_connections_page_action" then
				local v4768 = p484.kind.value:encode()
				local v4769, v4770 = proto.writeTag(buf, n320, 18, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4769, v4770, v4768, buffer.len(v4768))
			elseif p484.kind.type == "open_marketplace_action" then
				local v4771 = p484.kind.value:encode()
				local v4772, v4773 = proto.writeTag(buf, n320, 19, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4772, v4773, v4771, buffer.len(v4771))
			elseif p484.kind.type == "hide_profile_completion_action" then
				local v4774 = p484.kind.value:encode()
				local v4775, v4776 = proto.writeTag(buf, n320, 20, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4775, v4776, v4774, buffer.len(v4774))
			elseif p484.kind.type == "select_marketplace_catalog_category" then
				local v4777 = p484.kind.value:encode()
				local v4778, v4779 = proto.writeTag(buf, n320, 21, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4778, v4779, v4777, buffer.len(v4777))
			elseif p484.kind.type == "select_marketplace_catalog_subcategory" then
				local v4780 = p484.kind.value:encode()
				local v4781, v4782 = proto.writeTag(buf, n320, 22, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4781, v4782, v4780, buffer.len(v4780))
			elseif p484.kind.type == "open_marketplace_catalog_see_all" then
				local v4783 = p484.kind.value:encode()
				local v4784, v4785 = proto.writeTag(buf, n320, 23, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4784, v4785, v4783, buffer.len(v4783))
			elseif p484.kind.type == "close_marketplace_category_tooltip" then
				local v4786 = p484.kind.value:encode()
				local v4787, v4788 = proto.writeTag(buf, n320, 24, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4787, v4788, v4786, buffer.len(v4786))
			elseif p484.kind.type == "resize_marketplace_catalog" then
				local v4789 = p484.kind.value:encode()
				local v4790, v4791 = proto.writeTag(buf, n320, 25, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4790, v4791, v4789, buffer.len(v4789))
			elseif p484.kind.type == "open_marketplace_catalog_filters" then
				local v4792 = p484.kind.value:encode()
				local v4793, v4794 = proto.writeTag(buf, n320, 26, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4793, v4794, v4792, buffer.len(v4792))
			elseif p484.kind.type == "open_social_link_action" then
				local v4795 = p484.kind.value:encode()
				local v4796, v4797 = proto.writeTag(buf, n320, 27, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4796, v4797, v4795, buffer.len(v4795))
			elseif p484.kind.type == "open_charts_sort_detail_action" then
				local v4798 = p484.kind.value:encode()
				local v4799, v4800 = proto.writeTag(buf, n320, 28, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4799, v4800, v4798, buffer.len(v4798))
			elseif p484.kind.type == "open_song_detail_action" then
				local v4801 = p484.kind.value:encode()
				local v4802, v4803 = proto.writeTag(buf, n320, 29, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4802, v4803, v4801, buffer.len(v4801))
			elseif p484.kind.type == "refresh_from_api_action" then
				local v4804 = p484.kind.value:encode()
				local v4805, v4806 = proto.writeTag(buf, n320, 30, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4805, v4806, v4804, buffer.len(v4804))
			elseif p484.kind.type == "rsvp_to_event_action" then
				local v4807 = p484.kind.value:encode()
				local v4808, v4809 = proto.writeTag(buf, n320, 31, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4808, v4809, v4807, buffer.len(v4807))
			elseif p484.kind.type == "apply_charts_filter_action" then
				local v4810 = p484.kind.value:encode()
				local v4811, v4812 = proto.writeTag(buf, n320, 32, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4811, v4812, v4810, buffer.len(v4810))
			elseif p484.kind.type == "analytics_event_action" then
				local v4813 = p484.kind.value:encode()
				local v4814, v4815 = proto.writeTag(buf, n320, 33, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4814, v4815, v4813, buffer.len(v4813))
			elseif p484.kind.type == "custom_analytics_event_action" then
				local v4816 = p484.kind.value:encode()
				local v4817, v4818 = proto.writeTag(buf, n320, 34, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4817, v4818, v4816, buffer.len(v4816))
			elseif p484.kind.type == "open_game_invite_action" then
				local v4819 = p484.kind.value:encode()
				local v4820, v4821 = proto.writeTag(buf, n320, 35, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4820, v4821, v4819, buffer.len(v4819))
			elseif p484.kind.type == "open_event_details_action" then
				local v4822 = p484.kind.value:encode()
				local v4823, v4824 = proto.writeTag(buf, n320, 36, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4823, v4824, v4822, buffer.len(v4822))
			elseif p484.kind.type == "launch_experience_action" then
				local v4825 = p484.kind.value:encode()
				local v4826, v4827 = proto.writeTag(buf, n320, 37, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4826, v4827, v4825, buffer.len(v4825))
			elseif p484.kind.type == "toggle_experience_favorite_action" then
				local v4828 = p484.kind.value:encode()
				local v4829, v4830 = proto.writeTag(buf, n320, 38, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4829, v4830, v4828, buffer.len(v4828))
			elseif p484.kind.type == "toggle_experience_follow_action" then
				local v4831 = p484.kind.value:encode()
				local v4832, v4833 = proto.writeTag(buf, n320, 39, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4832, v4833, v4831, buffer.len(v4831))
			elseif p484.kind.type == "toggle_experience_vote_action" then
				local v4834 = p484.kind.value:encode()
				local v4835, v4836 = proto.writeTag(buf, n320, 40, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4835, v4836, v4834, buffer.len(v4834))
			elseif p484.kind.type == "open_purchase_prompt_action" then
				local v4837 = p484.kind.value:encode()
				local v4838, v4839 = proto.writeTag(buf, n320, 41, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4838, v4839, v4837, buffer.len(v4837))
			elseif p484.kind.type == "open_sdui_overlay_action" then
				local v4840 = p484.kind.value:encode()
				local v4841, v4842 = proto.writeTag(buf, n320, 42, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4841, v4842, v4840, buffer.len(v4840))
			elseif p484.kind.type == "open_badges_see_all_action" then
				local v4843 = p484.kind.value:encode()
				local v4844, v4845 = proto.writeTag(buf, n320, 43, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4844, v4845, v4843, buffer.len(v4843))
			elseif p484.kind.type == "open_experience_store_see_all_action" then
				local v4846 = p484.kind.value:encode()
				local v4847, v4848 = proto.writeTag(buf, n320, 44, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4847, v4848, v4846, buffer.len(v4846))
			elseif p484.kind.type == "dismiss_game_feedback_action" then
				local v4849 = p484.kind.value:encode()
				local v4850, v4851 = proto.writeTag(buf, n320, 45, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4850, v4851, v4849, buffer.len(v4849))
			elseif p484.kind.type == "open_game_feedback_form_action" then
				local v4852 = p484.kind.value:encode()
				local v4853, v4854 = proto.writeTag(buf, n320, 46, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4853, v4854, v4852, buffer.len(v4852))
			elseif p484.kind.type == "enable_event_notifications_action" then
				local v4855 = p484.kind.value:encode()
				local v4856, v4857 = proto.writeTag(buf, n320, 47, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4856, v4857, v4855, buffer.len(v4855))
			elseif p484.kind.type == "dismiss_event_notifications_modal_action" then
				local v4858 = p484.kind.value:encode()
				local v4859, v4860 = proto.writeTag(buf, n320, 48, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4859, v4860, v4858, buffer.len(v4858))
			elseif p484.kind.type == "open_amp_wizard_action" then
				local v4861 = p484.kind.value:encode()
				local v4862, v4863 = proto.writeTag(buf, n320, 49, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4862, v4863, v4861, buffer.len(v4861))
			elseif p484.kind.type == "open_subscription_purchase_page_action" then
				local v4864 = p484.kind.value:encode()
				local v4865, v4866 = proto.writeTag(buf, n320, 50, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4865, v4866, v4864, buffer.len(v4864))
			elseif p484.kind.type == "refresh_game_passes_action" then
				local v4867 = p484.kind.value:encode()
				local v4868, v4869 = proto.writeTag(buf, n320, 51, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4868, v4869, v4867, buffer.len(v4867))
			elseif p484.kind.type == "refresh_playability_action" then
				local v4870 = p484.kind.value:encode()
				local v4871, v4872 = proto.writeTag(buf, n320, 52, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4871, v4872, v4870, buffer.len(v4870))
			elseif p484.kind.type == "open_social_proof_user_list_sheet_action" then
				local v4873 = p484.kind.value:encode()
				local v4874, v4875 = proto.writeTag(buf, n320, 53, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4874, v4875, v4873, buffer.len(v4873))
			elseif p484.kind.type == "report_surface_load_time_milestone_action" then
				local v4876 = p484.kind.value:encode()
				local v4877, v4878 = proto.writeTag(buf, n320, 54, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4877, v4878, v4876, buffer.len(v4876))
			elseif p484.kind.type == "open_search_results_tab_action" then
				local v4879 = p484.kind.value:encode()
				local v4880, v4881 = proto.writeTag(buf, n320, 55, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4880, v4881, v4879, buffer.len(v4879))
			elseif p484.kind.type == "open_phone_upsell_modal_action" then
				local v4882 = p484.kind.value:encode()
				local v4883, v4884 = proto.writeTag(buf, n320, 56, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4883, v4884, v4882, buffer.len(v4882))
			elseif p484.kind.type == "open_email_upsell_modal_action" then
				local v4885 = p484.kind.value:encode()
				local v4886, v4887 = proto.writeTag(buf, n320, 57, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4886, v4887, v4885, buffer.len(v4885))
			elseif p484.kind.type == "dismiss_prompt_action" then
				local v4888 = p484.kind.value:encode()
				local v4889, v4890 = proto.writeTag(buf, n320, 58, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4889, v4890, v4888, buffer.len(v4888))
			elseif p484.kind.type == "request_friendship_action" then
				local v4891 = p484.kind.value:encode()
				local v4892, v4893 = proto.writeTag(buf, n320, 59, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4892, v4893, v4891, buffer.len(v4891))
			elseif p484.kind.type == "refresh_developer_products_action" then
				local v4894 = p484.kind.value:encode()
				local v4895, v4896 = proto.writeTag(buf, n320, 60, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4895, v4896, v4894, buffer.len(v4894))
			elseif p484.kind.type == "open_fae_trial_upsell_action" then
				local v4897 = p484.kind.value:encode()
				local v4898, v4899 = proto.writeTag(buf, n320, 61, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4898, v4899, v4897, buffer.len(v4897))
			elseif p484.kind.type == "refresh_omni_recommendation_feed_item_action" then
				local v4900 = p484.kind.value:encode()
				local v4901, v4902 = proto.writeTag(buf, n320, 62, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4901, v4902, v4900, buffer.len(v4900))
			elseif p484.kind.type == "ai_overview_feedback_action" then
				local v4903 = p484.kind.value:encode()
				local v4904, v4905 = proto.writeTag(buf, n320, 63, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4904, v4905, v4903, buffer.len(v4903))
			elseif p484.kind.type == "open_trusted_friends_upsell_modal_action" then
				local v4906 = p484.kind.value:encode()
				local v4907, v4908 = proto.writeTag(buf, n320, 64, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4907, v4908, v4906, buffer.len(v4906))
			elseif p484.kind.type == "record_party_chat_conversation_upsell_acknowledgement_action" then
				local v4909 = p484.kind.value:encode()
				local v4910, v4911 = proto.writeTag(buf, n320, 65, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4910, v4911, v4909, buffer.len(v4909))
			elseif p484.kind.type == "open_search_results_with_query_action" then
				local v4912 = p484.kind.value:encode()
				local v4913, v4914 = proto.writeTag(buf, n320, 66, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4913, v4914, v4912, buffer.len(v4912))
			elseif p484.kind.type == "select_marketplace_favorites_category" then
				local v4915 = p484.kind.value:encode()
				local v4916, v4917 = proto.writeTag(buf, n320, 67, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4916, v4917, v4915, buffer.len(v4915))
			elseif p484.kind.type == "download_app_action" then
				local v4918 = p484.kind.value:encode()
				local v4919, v4920 = proto.writeTag(buf, n320, 68, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4919, v4920, v4918, buffer.len(v4918))
			elseif p484.kind.type == "refresh_charts_sort_detail_action" then
				local v4921 = p484.kind.value:encode()
				local v4922, v4923 = proto.writeTag(buf, n320, 69, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4922, v4923, v4921, buffer.len(v4921))
			elseif p484.kind.type == "join_community_action" then
				local v4924 = p484.kind.value:encode()
				local v4925, v4926 = proto.writeTag(buf, n320, 70, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4925, v4926, v4924, buffer.len(v4924))
			elseif p484.kind.type == "view_community_action" then
				local v4927 = p484.kind.value:encode()
				local v4928, v4929 = proto.writeTag(buf, n320, 71, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4928, v4929, v4927, buffer.len(v4927))
			elseif p484.kind.type == "pin_experience_shortcut_action" then
				local v4930 = p484.kind.value:encode()
				local v4931, v4932 = proto.writeTag(buf, n320, 72, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4931, v4932, v4930, buffer.len(v4930))
			elseif p484.kind.type == "select_marketplace_favorites_subcategory" then
				local v4933 = p484.kind.value:encode()
				local v4934, v4935 = proto.writeTag(buf, n320, 73, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4934, v4935, v4933, buffer.len(v4933))
			elseif p484.kind.type == "show_toast_action" then
				local v4936 = p484.kind.value:encode()
				local v4937, v4938 = proto.writeTag(buf, n320, 74, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4937, v4938, v4936, buffer.len(v4936))
			elseif p484.kind.type == "open_incoming_transfer_upsell_action" then
				local v4939 = p484.kind.value:encode()
				local v4940, v4941 = proto.writeTag(buf, n320, 75, proto.wireTypes.lengthDelimited)

				buf, n320 = proto.writeBuffer(v4940, v4941, v4939, buffer.len(v4939))
			end
		end

		if p484.telemetry_handler ~= nil then
			local v4942 = p484.telemetry_handler:encode()
			local v4943, v4944 = proto.writeTag(buf, n320, 1000, proto.wireTypes.lengthDelimited)

			buf, n320 = proto.writeBuffer(v4943, v4944, v4942, buffer.len(v4942))
		end

		if p484.accessibility_label ~= nil then
			local v4945 = p484.accessibility_label:encode()
			local v4946, v4947 = proto.writeTag(buf, n320, 1001, proto.wireTypes.lengthDelimited)

			buf, n320 = proto.writeBuffer(v4946, v4947, v4945, buffer.len(v4945))
		end

		local buf163 = buffer.create(n320)

		buffer.copy(buf163, 0, buf, 0, n320)

		return buf163
	end
	function t643.decode(p485: buffer) -- line: 29837
		-- upvalues: t643 (copy), proto (copy), t1 (copy), prop_types (copy)
		local v4950 = t643.new()
		local n321 = 0

		while n321 < buffer.len(p485) do
			local v4952, v4953

			v4952, v4953, n321 = proto.readTag(p485, n321)

			if v4953 == proto.wireTypes.varint then
				local v4954

				v4954, n321 = proto.readVarInt(p485, n321)
			elseif v4953 == proto.wireTypes.lengthDelimited then
				if v4952 == 1 then
					local v4955

					v4955, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "dismiss_dialog_action",
						value = t1.DismissDialogAction.decode(v4955)
					}
				elseif v4952 == 2 then
					local v4956

					v4956, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "link_action",
						value = t1.LinkAction.decode(v4956)
					}
				elseif v4952 == 3 then
					local v4957

					v4957, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "open_game_details_action",
						value = t1.OpenGameDetailsAction.decode(v4957)
					}
				elseif v4952 == 4 then
					local v4958

					v4958, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "open_join_friends_action",
						value = t1.OpenJoinFriendsAction.decode(v4958)
					}
				elseif v4952 == 5 then
					local v4959

					v4959, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "open_marketplace_try_on_action",
						value = t1.OpenMarketplaceTryOnAction.decode(v4959)
					}
				elseif v4952 == 6 then
					local v4960

					v4960, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "open_see_all_action",
						value = t1.OpenSeeAllAction.decode(v4960)
					}
				elseif v4952 == 7 then
					local v4961

					v4961, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "open_sponsored_tooltip_action",
						value = t1.OpenSponsoredTooltipAction.decode(v4961)
					}
				elseif v4952 == 8 then
					local v4962

					v4962, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "play_button_click_action",
						value = t1.PlayButtonClickAction.decode(v4962)
					}
				elseif v4952 == 9 then
					local v4963

					v4963, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "update_user_settings_action",
						value = t1.UpdateUserSettingsAction.decode(v4963)
					}
				elseif v4952 == 10 then
					local v4964

					v4964, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "open_tooltip_action",
						value = t1.OpenTooltipAction.decode(v4964)
					}
				elseif v4952 == 11 then
					local v4965

					v4965, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "open_badge_details_action",
						value = t1.OpenBadgeDetailsAction.decode(v4965)
					}
				elseif v4952 == 12 then
					local v4966

					v4966, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "load_more_from_api_action",
						value = t1.LoadMoreFromApiAction.decode(v4966)
					}
				elseif v4952 == 13 then
					local v4967

					v4967, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "share_action",
						value = t1.ShareAction.decode(v4967)
					}
				elseif v4952 == 14 then
					local v4968

					v4968, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "open_abuse_report_action",
						value = t1.OpenAbuseReportAction.decode(v4968)
					}
				elseif v4952 == 15 then
					local v4969

					v4969, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "remove_badge_from_inventory_action",
						value = t1.RemoveBadgeFromInventoryAction.decode(v4969)
					}
				elseif v4952 == 16 then
					local v4970

					v4970, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "open_profile_action",
						value = t1.OpenProfileAction.decode(v4970)
					}
				elseif v4952 == 17 then
					local v4971

					v4971, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "open_facial_age_estimation_action",
						value = t1.OpenFacialAgeEstimationAction.decode(v4971)
					}
				elseif v4952 == 18 then
					local v4972

					v4972, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "open_add_connections_page_action",
						value = t1.OpenAddConnectionsPageAction.decode(v4972)
					}
				elseif v4952 == 19 then
					local v4973

					v4973, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "open_marketplace_action",
						value = t1.OpenMarketplaceAction.decode(v4973)
					}
				elseif v4952 == 20 then
					local v4974

					v4974, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "hide_profile_completion_action",
						value = t1.HideProfileCompletionAction.decode(v4974)
					}
				elseif v4952 == 21 then
					local v4975

					v4975, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "select_marketplace_catalog_category",
						value = t1.SelectMarketplaceCatalogCategory.decode(v4975)
					}
				elseif v4952 == 22 then
					local v4976

					v4976, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "select_marketplace_catalog_subcategory",
						value = t1.SelectMarketplaceCatalogSubcategory.decode(v4976)
					}
				elseif v4952 == 23 then
					local v4977

					v4977, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "open_marketplace_catalog_see_all",
						value = t1.OpenMarketplaceCatalogSeeAll.decode(v4977)
					}
				elseif v4952 == 24 then
					local v4978

					v4978, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "close_marketplace_category_tooltip",
						value = t1.CloseMarketplaceCategoryTooltip.decode(v4978)
					}
				elseif v4952 == 25 then
					local v4979

					v4979, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "resize_marketplace_catalog",
						value = t1.ResizeMarketplaceCatalog.decode(v4979)
					}
				elseif v4952 == 26 then
					local v4980

					v4980, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "open_marketplace_catalog_filters",
						value = t1.OpenMarketplaceCatalogFilters.decode(v4980)
					}
				elseif v4952 == 27 then
					local v4981

					v4981, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "open_social_link_action",
						value = t1.OpenSocialLinkAction.decode(v4981)
					}
				elseif v4952 == 28 then
					local v4982

					v4982, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "open_charts_sort_detail_action",
						value = t1.OpenChartsSortDetailAction.decode(v4982)
					}
				elseif v4952 == 29 then
					local v4983

					v4983, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "open_song_detail_action",
						value = t1.OpenSongDetailAction.decode(v4983)
					}
				elseif v4952 == 30 then
					local v4984

					v4984, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "refresh_from_api_action",
						value = t1.RefreshFromApiAction.decode(v4984)
					}
				elseif v4952 == 31 then
					local v4985

					v4985, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "rsvp_to_event_action",
						value = t1.RsvpToEventAction.decode(v4985)
					}
				elseif v4952 == 32 then
					local v4986

					v4986, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "apply_charts_filter_action",
						value = t1.ApplyChartsFilterAction.decode(v4986)
					}
				elseif v4952 == 33 then
					local v4987

					v4987, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "analytics_event_action",
						value = t1.AnalyticsEventAction.decode(v4987)
					}
				elseif v4952 == 34 then
					local v4988

					v4988, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "custom_analytics_event_action",
						value = t1.CustomAnalyticsEventAction.decode(v4988)
					}
				elseif v4952 == 35 then
					local v4989

					v4989, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "open_game_invite_action",
						value = t1.OpenGameInviteAction.decode(v4989)
					}
				elseif v4952 == 36 then
					local v4990

					v4990, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "open_event_details_action",
						value = t1.OpenEventDetailsAction.decode(v4990)
					}
				elseif v4952 == 37 then
					local v4991

					v4991, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "launch_experience_action",
						value = t1.LaunchExperienceAction.decode(v4991)
					}
				elseif v4952 == 38 then
					local v4992

					v4992, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "toggle_experience_favorite_action",
						value = t1.ToggleExperienceFavoriteAction.decode(v4992)
					}
				elseif v4952 == 39 then
					local v4993

					v4993, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "toggle_experience_follow_action",
						value = t1.ToggleExperienceFollowAction.decode(v4993)
					}
				elseif v4952 == 40 then
					local v4994

					v4994, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "toggle_experience_vote_action",
						value = t1.ToggleExperienceVoteAction.decode(v4994)
					}
				elseif v4952 == 41 then
					local v4995

					v4995, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "open_purchase_prompt_action",
						value = t1.OpenPurchasePromptAction.decode(v4995)
					}
				elseif v4952 == 42 then
					local v4996

					v4996, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "open_sdui_overlay_action",
						value = t1.OpenSduiOverlayAction.decode(v4996)
					}
				elseif v4952 == 43 then
					local v4997

					v4997, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "open_badges_see_all_action",
						value = t1.OpenBadgesSeeAllAction.decode(v4997)
					}
				elseif v4952 == 44 then
					local v4998

					v4998, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "open_experience_store_see_all_action",
						value = t1.OpenExperienceStoreSeeAllAction.decode(v4998)
					}
				elseif v4952 == 45 then
					local v4999

					v4999, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "dismiss_game_feedback_action",
						value = t1.DismissGameFeedbackAction.decode(v4999)
					}
				elseif v4952 == 46 then
					local v5000

					v5000, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "open_game_feedback_form_action",
						value = t1.OpenGameFeedbackFormAction.decode(v5000)
					}
				elseif v4952 == 47 then
					local v5001

					v5001, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "enable_event_notifications_action",
						value = t1.EnableEventNotificationsAction.decode(v5001)
					}
				elseif v4952 == 48 then
					local v5002

					v5002, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "dismiss_event_notifications_modal_action",
						value = t1.DismissEventNotificationsModalAction.decode(v5002)
					}
				elseif v4952 == 49 then
					local v5003

					v5003, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "open_amp_wizard_action",
						value = t1.OpenAmpWizardAction.decode(v5003)
					}
				elseif v4952 == 50 then
					local v5004

					v5004, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "open_subscription_purchase_page_action",
						value = t1.OpenSubscriptionPurchasePageAction.decode(v5004)
					}
				elseif v4952 == 51 then
					local v5005

					v5005, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "refresh_game_passes_action",
						value = t1.RefreshGamePassesAction.decode(v5005)
					}
				elseif v4952 == 52 then
					local v5006

					v5006, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "refresh_playability_action",
						value = t1.RefreshPlayabilityAction.decode(v5006)
					}
				elseif v4952 == 53 then
					local v5007

					v5007, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "open_social_proof_user_list_sheet_action",
						value = t1.OpenSocialProofUserListSheetAction.decode(v5007)
					}
				elseif v4952 == 54 then
					local v5008

					v5008, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "report_surface_load_time_milestone_action",
						value = t1.ReportSurfaceLoadTimeMilestoneAction.decode(v5008)
					}
				elseif v4952 == 55 then
					local v5009

					v5009, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "open_search_results_tab_action",
						value = t1.OpenSearchResultsTabAction.decode(v5009)
					}
				elseif v4952 == 56 then
					local v5010

					v5010, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "open_phone_upsell_modal_action",
						value = t1.OpenPhoneUpsellModalAction.decode(v5010)
					}
				elseif v4952 == 57 then
					local v5011

					v5011, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "open_email_upsell_modal_action",
						value = t1.OpenEmailUpsellModalAction.decode(v5011)
					}
				elseif v4952 == 58 then
					local v5012

					v5012, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "dismiss_prompt_action",
						value = t1.DismissPromptAction.decode(v5012)
					}
				elseif v4952 == 59 then
					local v5013

					v5013, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "request_friendship_action",
						value = t1.RequestFriendshipAction.decode(v5013)
					}
				elseif v4952 == 60 then
					local v5014

					v5014, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "refresh_developer_products_action",
						value = t1.RefreshDeveloperProductsAction.decode(v5014)
					}
				elseif v4952 == 61 then
					local v5015

					v5015, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "open_fae_trial_upsell_action",
						value = t1.OpenFaeTrialUpsellAction.decode(v5015)
					}
				elseif v4952 == 62 then
					local v5016

					v5016, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "refresh_omni_recommendation_feed_item_action",
						value = t1.RefreshOmniRecommendationFeedItemAction.decode(v5016)
					}
				elseif v4952 == 63 then
					local v5017

					v5017, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "ai_overview_feedback_action",
						value = t1.AiOverviewFeedbackAction.decode(v5017)
					}
				elseif v4952 == 64 then
					local v5018

					v5018, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "open_trusted_friends_upsell_modal_action",
						value = t1.OpenTrustedFriendsUpsellModalAction.decode(v5018)
					}
				elseif v4952 == 65 then
					local v5019

					v5019, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "record_party_chat_conversation_upsell_acknowledgement_action",
						value = t1.RecordPartyChatConversationUpsellAcknowledgementAction.decode(v5019)
					}
				elseif v4952 == 66 then
					local v5020

					v5020, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "open_search_results_with_query_action",
						value = t1.OpenSearchResultsWithQueryAction.decode(v5020)
					}
				elseif v4952 == 67 then
					local v5021

					v5021, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "select_marketplace_favorites_category",
						value = t1.SelectMarketplaceFavoritesCategory.decode(v5021)
					}
				elseif v4952 == 68 then
					local v5022

					v5022, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "download_app_action",
						value = t1.DownloadAppAction.decode(v5022)
					}
				elseif v4952 == 69 then
					local v5023

					v5023, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "refresh_charts_sort_detail_action",
						value = t1.RefreshChartsSortDetailAction.decode(v5023)
					}
				elseif v4952 == 70 then
					local v5024

					v5024, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "join_community_action",
						value = t1.JoinCommunityAction.decode(v5024)
					}
				elseif v4952 == 71 then
					local v5025

					v5025, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "view_community_action",
						value = t1.ViewCommunityAction.decode(v5025)
					}
				elseif v4952 == 72 then
					local v5026

					v5026, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "pin_experience_shortcut_action",
						value = t1.PinExperienceShortcutAction.decode(v5026)
					}
				elseif v4952 == 73 then
					local v5027

					v5027, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "select_marketplace_favorites_subcategory",
						value = t1.SelectMarketplaceFavoritesSubcategory.decode(v5027)
					}
				elseif v4952 == 74 then
					local v5028

					v5028, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "show_toast_action",
						value = t1.ShowToastAction.decode(v5028)
					}
				elseif v4952 == 75 then
					local v5029

					v5029, n321 = proto.readBuffer(p485, n321)
					v4950.kind = {
						type = "open_incoming_transfer_upsell_action",
						value = t1.OpenIncomingTransferUpsellAction.decode(v5029)
					}
				elseif v4952 == 1000 then
					local v5030

					v5030, n321 = proto.readBuffer(p485, n321)
					v4950.telemetry_handler = prop_types.StringProp.decode(v5030)
				elseif v4952 == 1001 then
					local v5031

					v5031, n321 = proto.readBuffer(p485, n321)
					v4950.accessibility_label = prop_types.StringFormat.decode(v5031)
				else
					local v5032, v5033 = proto.readVarInt(p485, n321)

					n321 = v5033 + v5032
				end
			elseif v4953 == proto.wireTypes.i32 then
				local v5034

				v5034, n321 = proto.readFixed32(p485, n321)
			elseif v4953 == proto.wireTypes.i64 then
				local v5035

				v5035, n321 = proto.readFixed64(p485, n321)
			else
				error("Unsupported wire type: " .. v4953)
			end
		end

		return v4950
	end
	function t643.jsonEncode(p486) -- line: 30404
		local t645 = {}

		if p486.kind ~= nil then
			if p486.kind.type == "dismiss_dialog_action" then
				t645.dismissDialogAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "link_action" then
				t645.linkAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "open_game_details_action" then
				t645.openGameDetailsAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "open_join_friends_action" then
				t645.openJoinFriendsAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "open_marketplace_try_on_action" then
				t645.openMarketplaceTryOnAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "open_see_all_action" then
				t645.openSeeAllAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "open_sponsored_tooltip_action" then
				t645.openSponsoredTooltipAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "play_button_click_action" then
				t645.playButtonClickAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "update_user_settings_action" then
				t645.updateUserSettingsAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "open_tooltip_action" then
				t645.openTooltipAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "open_badge_details_action" then
				t645.openBadgeDetailsAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "load_more_from_api_action" then
				t645.loadMoreFromApiAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "share_action" then
				t645.shareAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "open_abuse_report_action" then
				t645.openAbuseReportAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "remove_badge_from_inventory_action" then
				t645.removeBadgeFromInventoryAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "open_profile_action" then
				t645.openProfileAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "open_facial_age_estimation_action" then
				t645.openFacialAgeEstimationAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "open_add_connections_page_action" then
				t645.openAddConnectionsPageAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "open_marketplace_action" then
				t645.openMarketplaceAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "hide_profile_completion_action" then
				t645.hideProfileCompletionAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "select_marketplace_catalog_category" then
				t645.selectMarketplaceCatalogCategory = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "select_marketplace_catalog_subcategory" then
				t645.selectMarketplaceCatalogSubcategory = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "open_marketplace_catalog_see_all" then
				t645.openMarketplaceCatalogSeeAll = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "close_marketplace_category_tooltip" then
				t645.closeMarketplaceCategoryTooltip = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "resize_marketplace_catalog" then
				t645.resizeMarketplaceCatalog = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "open_marketplace_catalog_filters" then
				t645.openMarketplaceCatalogFilters = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "open_social_link_action" then
				t645.openSocialLinkAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "open_charts_sort_detail_action" then
				t645.openChartsSortDetailAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "open_song_detail_action" then
				t645.openSongDetailAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "refresh_from_api_action" then
				t645.refreshFromApiAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "rsvp_to_event_action" then
				t645.rsvpToEventAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "apply_charts_filter_action" then
				t645.applyChartsFilterAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "analytics_event_action" then
				t645.analyticsEventAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "custom_analytics_event_action" then
				t645.customAnalyticsEventAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "open_game_invite_action" then
				t645.openGameInviteAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "open_event_details_action" then
				t645.openEventDetailsAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "launch_experience_action" then
				t645.launchExperienceAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "toggle_experience_favorite_action" then
				t645.toggleExperienceFavoriteAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "toggle_experience_follow_action" then
				t645.toggleExperienceFollowAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "toggle_experience_vote_action" then
				t645.toggleExperienceVoteAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "open_purchase_prompt_action" then
				t645.openPurchasePromptAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "open_sdui_overlay_action" then
				t645.openSduiOverlayAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "open_badges_see_all_action" then
				t645.openBadgesSeeAllAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "open_experience_store_see_all_action" then
				t645.openExperienceStoreSeeAllAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "dismiss_game_feedback_action" then
				t645.dismissGameFeedbackAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "open_game_feedback_form_action" then
				t645.openGameFeedbackFormAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "enable_event_notifications_action" then
				t645.enableEventNotificationsAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "dismiss_event_notifications_modal_action" then
				t645.dismissEventNotificationsModalAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "open_amp_wizard_action" then
				t645.openAmpWizardAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "open_subscription_purchase_page_action" then
				t645.openSubscriptionPurchasePageAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "refresh_game_passes_action" then
				t645.refreshGamePassesAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "refresh_playability_action" then
				t645.refreshPlayabilityAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "open_social_proof_user_list_sheet_action" then
				t645.openSocialProofUserListSheetAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "report_surface_load_time_milestone_action" then
				t645.reportSurfaceLoadTimeMilestoneAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "open_search_results_tab_action" then
				t645.openSearchResultsTabAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "open_phone_upsell_modal_action" then
				t645.openPhoneUpsellModalAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "open_email_upsell_modal_action" then
				t645.openEmailUpsellModalAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "dismiss_prompt_action" then
				t645.dismissPromptAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "request_friendship_action" then
				t645.requestFriendshipAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "refresh_developer_products_action" then
				t645.refreshDeveloperProductsAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "open_fae_trial_upsell_action" then
				t645.openFaeTrialUpsellAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "refresh_omni_recommendation_feed_item_action" then
				t645.refreshOmniRecommendationFeedItemAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "ai_overview_feedback_action" then
				t645.aiOverviewFeedbackAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "open_trusted_friends_upsell_modal_action" then
				t645.openTrustedFriendsUpsellModalAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "record_party_chat_conversation_upsell_acknowledgement_action" then
				t645.recordPartyChatConversationUpsellAcknowledgementAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "open_search_results_with_query_action" then
				t645.openSearchResultsWithQueryAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "select_marketplace_favorites_category" then
				t645.selectMarketplaceFavoritesCategory = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "download_app_action" then
				t645.downloadAppAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "refresh_charts_sort_detail_action" then
				t645.refreshChartsSortDetailAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "join_community_action" then
				t645.joinCommunityAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "view_community_action" then
				t645.viewCommunityAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "pin_experience_shortcut_action" then
				t645.pinExperienceShortcutAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "select_marketplace_favorites_subcategory" then
				t645.selectMarketplaceFavoritesSubcategory = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "show_toast_action" then
				t645.showToastAction = p486.kind.value:jsonEncode()
			elseif p486.kind.type == "open_incoming_transfer_upsell_action" then
				t645.openIncomingTransferUpsellAction = p486.kind.value:jsonEncode()
			end
		end

		if p486.telemetry_handler ~= nil then
			t645.telemetryHandler = p486.telemetry_handler:jsonEncode()
		end

		if p486.accessibility_label ~= nil then
			t645.accessibilityLabel = p486.accessibility_label:jsonEncode()
		end

		return t645
	end
	function t643.jsonDecode(t646: {[any]: any}) -- line: 30572
		-- upvalues: t643 (copy), t1 (copy), prop_types (copy)
		local v5039 = t643.new()

		if t646.dismiss_dialog_action ~= nil then
			v5039.kind = {
				type = "dismiss_dialog_action",
				value = t1.DismissDialogAction.jsonDecode(t646.dismiss_dialog_action)
			}
		end

		if t646.dismissDialogAction ~= nil then
			v5039.kind = {
				type = "dismiss_dialog_action",
				value = t1.DismissDialogAction.jsonDecode(t646.dismissDialogAction)
			}
		end

		if t646.link_action ~= nil then
			v5039.kind = {
				type = "link_action",
				value = t1.LinkAction.jsonDecode(t646.link_action)
			}
		end

		if t646.linkAction ~= nil then
			v5039.kind = {
				type = "link_action",
				value = t1.LinkAction.jsonDecode(t646.linkAction)
			}
		end

		if t646.open_game_details_action ~= nil then
			v5039.kind = {
				type = "open_game_details_action",
				value = t1.OpenGameDetailsAction.jsonDecode(t646.open_game_details_action)
			}
		end

		if t646.openGameDetailsAction ~= nil then
			v5039.kind = {
				type = "open_game_details_action",
				value = t1.OpenGameDetailsAction.jsonDecode(t646.openGameDetailsAction)
			}
		end

		if t646.open_join_friends_action ~= nil then
			v5039.kind = {
				type = "open_join_friends_action",
				value = t1.OpenJoinFriendsAction.jsonDecode(t646.open_join_friends_action)
			}
		end

		if t646.openJoinFriendsAction ~= nil then
			v5039.kind = {
				type = "open_join_friends_action",
				value = t1.OpenJoinFriendsAction.jsonDecode(t646.openJoinFriendsAction)
			}
		end

		if t646.open_marketplace_try_on_action ~= nil then
			v5039.kind = {
				type = "open_marketplace_try_on_action",
				value = t1.OpenMarketplaceTryOnAction.jsonDecode(t646.open_marketplace_try_on_action)
			}
		end

		if t646.openMarketplaceTryOnAction ~= nil then
			v5039.kind = {
				type = "open_marketplace_try_on_action",
				value = t1.OpenMarketplaceTryOnAction.jsonDecode(t646.openMarketplaceTryOnAction)
			}
		end

		if t646.open_see_all_action ~= nil then
			v5039.kind = {
				type = "open_see_all_action",
				value = t1.OpenSeeAllAction.jsonDecode(t646.open_see_all_action)
			}
		end

		if t646.openSeeAllAction ~= nil then
			v5039.kind = {
				type = "open_see_all_action",
				value = t1.OpenSeeAllAction.jsonDecode(t646.openSeeAllAction)
			}
		end

		if t646.open_sponsored_tooltip_action ~= nil then
			v5039.kind = {
				type = "open_sponsored_tooltip_action",
				value = t1.OpenSponsoredTooltipAction.jsonDecode(t646.open_sponsored_tooltip_action)
			}
		end

		if t646.openSponsoredTooltipAction ~= nil then
			v5039.kind = {
				type = "open_sponsored_tooltip_action",
				value = t1.OpenSponsoredTooltipAction.jsonDecode(t646.openSponsoredTooltipAction)
			}
		end

		if t646.play_button_click_action ~= nil then
			v5039.kind = {
				type = "play_button_click_action",
				value = t1.PlayButtonClickAction.jsonDecode(t646.play_button_click_action)
			}
		end

		if t646.playButtonClickAction ~= nil then
			v5039.kind = {
				type = "play_button_click_action",
				value = t1.PlayButtonClickAction.jsonDecode(t646.playButtonClickAction)
			}
		end

		if t646.update_user_settings_action ~= nil then
			v5039.kind = {
				type = "update_user_settings_action",
				value = t1.UpdateUserSettingsAction.jsonDecode(t646.update_user_settings_action)
			}
		end

		if t646.updateUserSettingsAction ~= nil then
			v5039.kind = {
				type = "update_user_settings_action",
				value = t1.UpdateUserSettingsAction.jsonDecode(t646.updateUserSettingsAction)
			}
		end

		if t646.open_tooltip_action ~= nil then
			v5039.kind = {
				type = "open_tooltip_action",
				value = t1.OpenTooltipAction.jsonDecode(t646.open_tooltip_action)
			}
		end

		if t646.openTooltipAction ~= nil then
			v5039.kind = {
				type = "open_tooltip_action",
				value = t1.OpenTooltipAction.jsonDecode(t646.openTooltipAction)
			}
		end

		if t646.open_badge_details_action ~= nil then
			v5039.kind = {
				type = "open_badge_details_action",
				value = t1.OpenBadgeDetailsAction.jsonDecode(t646.open_badge_details_action)
			}
		end

		if t646.openBadgeDetailsAction ~= nil then
			v5039.kind = {
				type = "open_badge_details_action",
				value = t1.OpenBadgeDetailsAction.jsonDecode(t646.openBadgeDetailsAction)
			}
		end

		if t646.load_more_from_api_action ~= nil then
			v5039.kind = {
				type = "load_more_from_api_action",
				value = t1.LoadMoreFromApiAction.jsonDecode(t646.load_more_from_api_action)
			}
		end

		if t646.loadMoreFromApiAction ~= nil then
			v5039.kind = {
				type = "load_more_from_api_action",
				value = t1.LoadMoreFromApiAction.jsonDecode(t646.loadMoreFromApiAction)
			}
		end

		if t646.share_action ~= nil then
			v5039.kind = {
				type = "share_action",
				value = t1.ShareAction.jsonDecode(t646.share_action)
			}
		end

		if t646.shareAction ~= nil then
			v5039.kind = {
				type = "share_action",
				value = t1.ShareAction.jsonDecode(t646.shareAction)
			}
		end

		if t646.open_abuse_report_action ~= nil then
			v5039.kind = {
				type = "open_abuse_report_action",
				value = t1.OpenAbuseReportAction.jsonDecode(t646.open_abuse_report_action)
			}
		end

		if t646.openAbuseReportAction ~= nil then
			v5039.kind = {
				type = "open_abuse_report_action",
				value = t1.OpenAbuseReportAction.jsonDecode(t646.openAbuseReportAction)
			}
		end

		if t646.remove_badge_from_inventory_action ~= nil then
			v5039.kind = {
				type = "remove_badge_from_inventory_action",
				value = t1.RemoveBadgeFromInventoryAction.jsonDecode(t646.remove_badge_from_inventory_action)
			}
		end

		if t646.removeBadgeFromInventoryAction ~= nil then
			v5039.kind = {
				type = "remove_badge_from_inventory_action",
				value = t1.RemoveBadgeFromInventoryAction.jsonDecode(t646.removeBadgeFromInventoryAction)
			}
		end

		if t646.open_profile_action ~= nil then
			v5039.kind = {
				type = "open_profile_action",
				value = t1.OpenProfileAction.jsonDecode(t646.open_profile_action)
			}
		end

		if t646.openProfileAction ~= nil then
			v5039.kind = {
				type = "open_profile_action",
				value = t1.OpenProfileAction.jsonDecode(t646.openProfileAction)
			}
		end

		if t646.open_facial_age_estimation_action ~= nil then
			v5039.kind = {
				type = "open_facial_age_estimation_action",
				value = t1.OpenFacialAgeEstimationAction.jsonDecode(t646.open_facial_age_estimation_action)
			}
		end

		if t646.openFacialAgeEstimationAction ~= nil then
			v5039.kind = {
				type = "open_facial_age_estimation_action",
				value = t1.OpenFacialAgeEstimationAction.jsonDecode(t646.openFacialAgeEstimationAction)
			}
		end

		if t646.open_add_connections_page_action ~= nil then
			v5039.kind = {
				type = "open_add_connections_page_action",
				value = t1.OpenAddConnectionsPageAction.jsonDecode(t646.open_add_connections_page_action)
			}
		end

		if t646.openAddConnectionsPageAction ~= nil then
			v5039.kind = {
				type = "open_add_connections_page_action",
				value = t1.OpenAddConnectionsPageAction.jsonDecode(t646.openAddConnectionsPageAction)
			}
		end

		if t646.open_marketplace_action ~= nil then
			v5039.kind = {
				type = "open_marketplace_action",
				value = t1.OpenMarketplaceAction.jsonDecode(t646.open_marketplace_action)
			}
		end

		if t646.openMarketplaceAction ~= nil then
			v5039.kind = {
				type = "open_marketplace_action",
				value = t1.OpenMarketplaceAction.jsonDecode(t646.openMarketplaceAction)
			}
		end

		if t646.hide_profile_completion_action ~= nil then
			v5039.kind = {
				type = "hide_profile_completion_action",
				value = t1.HideProfileCompletionAction.jsonDecode(t646.hide_profile_completion_action)
			}
		end

		if t646.hideProfileCompletionAction ~= nil then
			v5039.kind = {
				type = "hide_profile_completion_action",
				value = t1.HideProfileCompletionAction.jsonDecode(t646.hideProfileCompletionAction)
			}
		end

		if t646.select_marketplace_catalog_category ~= nil then
			v5039.kind = {
				type = "select_marketplace_catalog_category",
				value = t1.SelectMarketplaceCatalogCategory.jsonDecode(t646.select_marketplace_catalog_category)
			}
		end

		if t646.selectMarketplaceCatalogCategory ~= nil then
			v5039.kind = {
				type = "select_marketplace_catalog_category",
				value = t1.SelectMarketplaceCatalogCategory.jsonDecode(t646.selectMarketplaceCatalogCategory)
			}
		end

		if t646.select_marketplace_catalog_subcategory ~= nil then
			v5039.kind = {
				type = "select_marketplace_catalog_subcategory",
				value = t1.SelectMarketplaceCatalogSubcategory.jsonDecode(t646.select_marketplace_catalog_subcategory)
			}
		end

		if t646.selectMarketplaceCatalogSubcategory ~= nil then
			v5039.kind = {
				type = "select_marketplace_catalog_subcategory",
				value = t1.SelectMarketplaceCatalogSubcategory.jsonDecode(t646.selectMarketplaceCatalogSubcategory)
			}
		end

		if t646.open_marketplace_catalog_see_all ~= nil then
			v5039.kind = {
				type = "open_marketplace_catalog_see_all",
				value = t1.OpenMarketplaceCatalogSeeAll.jsonDecode(t646.open_marketplace_catalog_see_all)
			}
		end

		if t646.openMarketplaceCatalogSeeAll ~= nil then
			v5039.kind = {
				type = "open_marketplace_catalog_see_all",
				value = t1.OpenMarketplaceCatalogSeeAll.jsonDecode(t646.openMarketplaceCatalogSeeAll)
			}
		end

		if t646.close_marketplace_category_tooltip ~= nil then
			v5039.kind = {
				type = "close_marketplace_category_tooltip",
				value = t1.CloseMarketplaceCategoryTooltip.jsonDecode(t646.close_marketplace_category_tooltip)
			}
		end

		if t646.closeMarketplaceCategoryTooltip ~= nil then
			v5039.kind = {
				type = "close_marketplace_category_tooltip",
				value = t1.CloseMarketplaceCategoryTooltip.jsonDecode(t646.closeMarketplaceCategoryTooltip)
			}
		end

		if t646.resize_marketplace_catalog ~= nil then
			v5039.kind = {
				type = "resize_marketplace_catalog",
				value = t1.ResizeMarketplaceCatalog.jsonDecode(t646.resize_marketplace_catalog)
			}
		end

		if t646.resizeMarketplaceCatalog ~= nil then
			v5039.kind = {
				type = "resize_marketplace_catalog",
				value = t1.ResizeMarketplaceCatalog.jsonDecode(t646.resizeMarketplaceCatalog)
			}
		end

		if t646.open_marketplace_catalog_filters ~= nil then
			v5039.kind = {
				type = "open_marketplace_catalog_filters",
				value = t1.OpenMarketplaceCatalogFilters.jsonDecode(t646.open_marketplace_catalog_filters)
			}
		end

		if t646.openMarketplaceCatalogFilters ~= nil then
			v5039.kind = {
				type = "open_marketplace_catalog_filters",
				value = t1.OpenMarketplaceCatalogFilters.jsonDecode(t646.openMarketplaceCatalogFilters)
			}
		end

		if t646.open_social_link_action ~= nil then
			v5039.kind = {
				type = "open_social_link_action",
				value = t1.OpenSocialLinkAction.jsonDecode(t646.open_social_link_action)
			}
		end

		if t646.openSocialLinkAction ~= nil then
			v5039.kind = {
				type = "open_social_link_action",
				value = t1.OpenSocialLinkAction.jsonDecode(t646.openSocialLinkAction)
			}
		end

		if t646.open_charts_sort_detail_action ~= nil then
			v5039.kind = {
				type = "open_charts_sort_detail_action",
				value = t1.OpenChartsSortDetailAction.jsonDecode(t646.open_charts_sort_detail_action)
			}
		end

		if t646.openChartsSortDetailAction ~= nil then
			v5039.kind = {
				type = "open_charts_sort_detail_action",
				value = t1.OpenChartsSortDetailAction.jsonDecode(t646.openChartsSortDetailAction)
			}
		end

		if t646.open_song_detail_action ~= nil then
			v5039.kind = {
				type = "open_song_detail_action",
				value = t1.OpenSongDetailAction.jsonDecode(t646.open_song_detail_action)
			}
		end

		if t646.openSongDetailAction ~= nil then
			v5039.kind = {
				type = "open_song_detail_action",
				value = t1.OpenSongDetailAction.jsonDecode(t646.openSongDetailAction)
			}
		end

		if t646.refresh_from_api_action ~= nil then
			v5039.kind = {
				type = "refresh_from_api_action",
				value = t1.RefreshFromApiAction.jsonDecode(t646.refresh_from_api_action)
			}
		end

		if t646.refreshFromApiAction ~= nil then
			v5039.kind = {
				type = "refresh_from_api_action",
				value = t1.RefreshFromApiAction.jsonDecode(t646.refreshFromApiAction)
			}
		end

		if t646.rsvp_to_event_action ~= nil then
			v5039.kind = {
				type = "rsvp_to_event_action",
				value = t1.RsvpToEventAction.jsonDecode(t646.rsvp_to_event_action)
			}
		end

		if t646.rsvpToEventAction ~= nil then
			v5039.kind = {
				type = "rsvp_to_event_action",
				value = t1.RsvpToEventAction.jsonDecode(t646.rsvpToEventAction)
			}
		end

		if t646.apply_charts_filter_action ~= nil then
			v5039.kind = {
				type = "apply_charts_filter_action",
				value = t1.ApplyChartsFilterAction.jsonDecode(t646.apply_charts_filter_action)
			}
		end

		if t646.applyChartsFilterAction ~= nil then
			v5039.kind = {
				type = "apply_charts_filter_action",
				value = t1.ApplyChartsFilterAction.jsonDecode(t646.applyChartsFilterAction)
			}
		end

		if t646.analytics_event_action ~= nil then
			v5039.kind = {
				type = "analytics_event_action",
				value = t1.AnalyticsEventAction.jsonDecode(t646.analytics_event_action)
			}
		end

		if t646.analyticsEventAction ~= nil then
			v5039.kind = {
				type = "analytics_event_action",
				value = t1.AnalyticsEventAction.jsonDecode(t646.analyticsEventAction)
			}
		end

		if t646.custom_analytics_event_action ~= nil then
			v5039.kind = {
				type = "custom_analytics_event_action",
				value = t1.CustomAnalyticsEventAction.jsonDecode(t646.custom_analytics_event_action)
			}
		end

		if t646.customAnalyticsEventAction ~= nil then
			v5039.kind = {
				type = "custom_analytics_event_action",
				value = t1.CustomAnalyticsEventAction.jsonDecode(t646.customAnalyticsEventAction)
			}
		end

		if t646.open_game_invite_action ~= nil then
			v5039.kind = {
				type = "open_game_invite_action",
				value = t1.OpenGameInviteAction.jsonDecode(t646.open_game_invite_action)
			}
		end

		if t646.openGameInviteAction ~= nil then
			v5039.kind = {
				type = "open_game_invite_action",
				value = t1.OpenGameInviteAction.jsonDecode(t646.openGameInviteAction)
			}
		end

		if t646.open_event_details_action ~= nil then
			v5039.kind = {
				type = "open_event_details_action",
				value = t1.OpenEventDetailsAction.jsonDecode(t646.open_event_details_action)
			}
		end

		if t646.openEventDetailsAction ~= nil then
			v5039.kind = {
				type = "open_event_details_action",
				value = t1.OpenEventDetailsAction.jsonDecode(t646.openEventDetailsAction)
			}
		end

		if t646.launch_experience_action ~= nil then
			v5039.kind = {
				type = "launch_experience_action",
				value = t1.LaunchExperienceAction.jsonDecode(t646.launch_experience_action)
			}
		end

		if t646.launchExperienceAction ~= nil then
			v5039.kind = {
				type = "launch_experience_action",
				value = t1.LaunchExperienceAction.jsonDecode(t646.launchExperienceAction)
			}
		end

		if t646.toggle_experience_favorite_action ~= nil then
			v5039.kind = {
				type = "toggle_experience_favorite_action",
				value = t1.ToggleExperienceFavoriteAction.jsonDecode(t646.toggle_experience_favorite_action)
			}
		end

		if t646.toggleExperienceFavoriteAction ~= nil then
			v5039.kind = {
				type = "toggle_experience_favorite_action",
				value = t1.ToggleExperienceFavoriteAction.jsonDecode(t646.toggleExperienceFavoriteAction)
			}
		end

		if t646.toggle_experience_follow_action ~= nil then
			v5039.kind = {
				type = "toggle_experience_follow_action",
				value = t1.ToggleExperienceFollowAction.jsonDecode(t646.toggle_experience_follow_action)
			}
		end

		if t646.toggleExperienceFollowAction ~= nil then
			v5039.kind = {
				type = "toggle_experience_follow_action",
				value = t1.ToggleExperienceFollowAction.jsonDecode(t646.toggleExperienceFollowAction)
			}
		end

		if t646.toggle_experience_vote_action ~= nil then
			v5039.kind = {
				type = "toggle_experience_vote_action",
				value = t1.ToggleExperienceVoteAction.jsonDecode(t646.toggle_experience_vote_action)
			}
		end

		if t646.toggleExperienceVoteAction ~= nil then
			v5039.kind = {
				type = "toggle_experience_vote_action",
				value = t1.ToggleExperienceVoteAction.jsonDecode(t646.toggleExperienceVoteAction)
			}
		end

		if t646.open_purchase_prompt_action ~= nil then
			v5039.kind = {
				type = "open_purchase_prompt_action",
				value = t1.OpenPurchasePromptAction.jsonDecode(t646.open_purchase_prompt_action)
			}
		end

		if t646.openPurchasePromptAction ~= nil then
			v5039.kind = {
				type = "open_purchase_prompt_action",
				value = t1.OpenPurchasePromptAction.jsonDecode(t646.openPurchasePromptAction)
			}
		end

		if t646.open_sdui_overlay_action ~= nil then
			v5039.kind = {
				type = "open_sdui_overlay_action",
				value = t1.OpenSduiOverlayAction.jsonDecode(t646.open_sdui_overlay_action)
			}
		end

		if t646.openSduiOverlayAction ~= nil then
			v5039.kind = {
				type = "open_sdui_overlay_action",
				value = t1.OpenSduiOverlayAction.jsonDecode(t646.openSduiOverlayAction)
			}
		end

		if t646.open_badges_see_all_action ~= nil then
			v5039.kind = {
				type = "open_badges_see_all_action",
				value = t1.OpenBadgesSeeAllAction.jsonDecode(t646.open_badges_see_all_action)
			}
		end

		if t646.openBadgesSeeAllAction ~= nil then
			v5039.kind = {
				type = "open_badges_see_all_action",
				value = t1.OpenBadgesSeeAllAction.jsonDecode(t646.openBadgesSeeAllAction)
			}
		end

		if t646.open_experience_store_see_all_action ~= nil then
			v5039.kind = {
				type = "open_experience_store_see_all_action",
				value = t1.OpenExperienceStoreSeeAllAction.jsonDecode(t646.open_experience_store_see_all_action)
			}
		end

		if t646.openExperienceStoreSeeAllAction ~= nil then
			v5039.kind = {
				type = "open_experience_store_see_all_action",
				value = t1.OpenExperienceStoreSeeAllAction.jsonDecode(t646.openExperienceStoreSeeAllAction)
			}
		end

		if t646.dismiss_game_feedback_action ~= nil then
			v5039.kind = {
				type = "dismiss_game_feedback_action",
				value = t1.DismissGameFeedbackAction.jsonDecode(t646.dismiss_game_feedback_action)
			}
		end

		if t646.dismissGameFeedbackAction ~= nil then
			v5039.kind = {
				type = "dismiss_game_feedback_action",
				value = t1.DismissGameFeedbackAction.jsonDecode(t646.dismissGameFeedbackAction)
			}
		end

		if t646.open_game_feedback_form_action ~= nil then
			v5039.kind = {
				type = "open_game_feedback_form_action",
				value = t1.OpenGameFeedbackFormAction.jsonDecode(t646.open_game_feedback_form_action)
			}
		end

		if t646.openGameFeedbackFormAction ~= nil then
			v5039.kind = {
				type = "open_game_feedback_form_action",
				value = t1.OpenGameFeedbackFormAction.jsonDecode(t646.openGameFeedbackFormAction)
			}
		end

		if t646.enable_event_notifications_action ~= nil then
			v5039.kind = {
				type = "enable_event_notifications_action",
				value = t1.EnableEventNotificationsAction.jsonDecode(t646.enable_event_notifications_action)
			}
		end

		if t646.enableEventNotificationsAction ~= nil then
			v5039.kind = {
				type = "enable_event_notifications_action",
				value = t1.EnableEventNotificationsAction.jsonDecode(t646.enableEventNotificationsAction)
			}
		end

		if t646.dismiss_event_notifications_modal_action ~= nil then
			v5039.kind = {
				type = "dismiss_event_notifications_modal_action",
				value = t1.DismissEventNotificationsModalAction.jsonDecode(t646.dismiss_event_notifications_modal_action)
			}
		end

		if t646.dismissEventNotificationsModalAction ~= nil then
			v5039.kind = {
				type = "dismiss_event_notifications_modal_action",
				value = t1.DismissEventNotificationsModalAction.jsonDecode(t646.dismissEventNotificationsModalAction)
			}
		end

		if t646.open_amp_wizard_action ~= nil then
			v5039.kind = {
				type = "open_amp_wizard_action",
				value = t1.OpenAmpWizardAction.jsonDecode(t646.open_amp_wizard_action)
			}
		end

		if t646.openAmpWizardAction ~= nil then
			v5039.kind = {
				type = "open_amp_wizard_action",
				value = t1.OpenAmpWizardAction.jsonDecode(t646.openAmpWizardAction)
			}
		end

		if t646.open_subscription_purchase_page_action ~= nil then
			v5039.kind = {
				type = "open_subscription_purchase_page_action",
				value = t1.OpenSubscriptionPurchasePageAction.jsonDecode(t646.open_subscription_purchase_page_action)
			}
		end

		if t646.openSubscriptionPurchasePageAction ~= nil then
			v5039.kind = {
				type = "open_subscription_purchase_page_action",
				value = t1.OpenSubscriptionPurchasePageAction.jsonDecode(t646.openSubscriptionPurchasePageAction)
			}
		end

		if t646.refresh_game_passes_action ~= nil then
			v5039.kind = {
				type = "refresh_game_passes_action",
				value = t1.RefreshGamePassesAction.jsonDecode(t646.refresh_game_passes_action)
			}
		end

		if t646.refreshGamePassesAction ~= nil then
			v5039.kind = {
				type = "refresh_game_passes_action",
				value = t1.RefreshGamePassesAction.jsonDecode(t646.refreshGamePassesAction)
			}
		end

		if t646.refresh_playability_action ~= nil then
			v5039.kind = {
				type = "refresh_playability_action",
				value = t1.RefreshPlayabilityAction.jsonDecode(t646.refresh_playability_action)
			}
		end

		if t646.refreshPlayabilityAction ~= nil then
			v5039.kind = {
				type = "refresh_playability_action",
				value = t1.RefreshPlayabilityAction.jsonDecode(t646.refreshPlayabilityAction)
			}
		end

		if t646.open_social_proof_user_list_sheet_action ~= nil then
			v5039.kind = {
				type = "open_social_proof_user_list_sheet_action",
				value = t1.OpenSocialProofUserListSheetAction.jsonDecode(t646.open_social_proof_user_list_sheet_action)
			}
		end

		if t646.openSocialProofUserListSheetAction ~= nil then
			v5039.kind = {
				type = "open_social_proof_user_list_sheet_action",
				value = t1.OpenSocialProofUserListSheetAction.jsonDecode(t646.openSocialProofUserListSheetAction)
			}
		end

		if t646.report_surface_load_time_milestone_action ~= nil then
			v5039.kind = {
				type = "report_surface_load_time_milestone_action",
				value = t1.ReportSurfaceLoadTimeMilestoneAction.jsonDecode(t646.report_surface_load_time_milestone_action)
			}
		end

		if t646.reportSurfaceLoadTimeMilestoneAction ~= nil then
			v5039.kind = {
				type = "report_surface_load_time_milestone_action",
				value = t1.ReportSurfaceLoadTimeMilestoneAction.jsonDecode(t646.reportSurfaceLoadTimeMilestoneAction)
			}
		end

		if t646.open_search_results_tab_action ~= nil then
			v5039.kind = {
				type = "open_search_results_tab_action",
				value = t1.OpenSearchResultsTabAction.jsonDecode(t646.open_search_results_tab_action)
			}
		end

		if t646.openSearchResultsTabAction ~= nil then
			v5039.kind = {
				type = "open_search_results_tab_action",
				value = t1.OpenSearchResultsTabAction.jsonDecode(t646.openSearchResultsTabAction)
			}
		end

		if t646.open_phone_upsell_modal_action ~= nil then
			v5039.kind = {
				type = "open_phone_upsell_modal_action",
				value = t1.OpenPhoneUpsellModalAction.jsonDecode(t646.open_phone_upsell_modal_action)
			}
		end

		if t646.openPhoneUpsellModalAction ~= nil then
			v5039.kind = {
				type = "open_phone_upsell_modal_action",
				value = t1.OpenPhoneUpsellModalAction.jsonDecode(t646.openPhoneUpsellModalAction)
			}
		end

		if t646.open_email_upsell_modal_action ~= nil then
			v5039.kind = {
				type = "open_email_upsell_modal_action",
				value = t1.OpenEmailUpsellModalAction.jsonDecode(t646.open_email_upsell_modal_action)
			}
		end

		if t646.openEmailUpsellModalAction ~= nil then
			v5039.kind = {
				type = "open_email_upsell_modal_action",
				value = t1.OpenEmailUpsellModalAction.jsonDecode(t646.openEmailUpsellModalAction)
			}
		end

		if t646.dismiss_prompt_action ~= nil then
			v5039.kind = {
				type = "dismiss_prompt_action",
				value = t1.DismissPromptAction.jsonDecode(t646.dismiss_prompt_action)
			}
		end

		if t646.dismissPromptAction ~= nil then
			v5039.kind = {
				type = "dismiss_prompt_action",
				value = t1.DismissPromptAction.jsonDecode(t646.dismissPromptAction)
			}
		end

		if t646.request_friendship_action ~= nil then
			v5039.kind = {
				type = "request_friendship_action",
				value = t1.RequestFriendshipAction.jsonDecode(t646.request_friendship_action)
			}
		end

		if t646.requestFriendshipAction ~= nil then
			v5039.kind = {
				type = "request_friendship_action",
				value = t1.RequestFriendshipAction.jsonDecode(t646.requestFriendshipAction)
			}
		end

		if t646.refresh_developer_products_action ~= nil then
			v5039.kind = {
				type = "refresh_developer_products_action",
				value = t1.RefreshDeveloperProductsAction.jsonDecode(t646.refresh_developer_products_action)
			}
		end

		if t646.refreshDeveloperProductsAction ~= nil then
			v5039.kind = {
				type = "refresh_developer_products_action",
				value = t1.RefreshDeveloperProductsAction.jsonDecode(t646.refreshDeveloperProductsAction)
			}
		end

		if t646.open_fae_trial_upsell_action ~= nil then
			v5039.kind = {
				type = "open_fae_trial_upsell_action",
				value = t1.OpenFaeTrialUpsellAction.jsonDecode(t646.open_fae_trial_upsell_action)
			}
		end

		if t646.openFaeTrialUpsellAction ~= nil then
			v5039.kind = {
				type = "open_fae_trial_upsell_action",
				value = t1.OpenFaeTrialUpsellAction.jsonDecode(t646.openFaeTrialUpsellAction)
			}
		end

		if t646.refresh_omni_recommendation_feed_item_action ~= nil then
			v5039.kind = {
				type = "refresh_omni_recommendation_feed_item_action",
				value = t1.RefreshOmniRecommendationFeedItemAction.jsonDecode(t646.refresh_omni_recommendation_feed_item_action)
			}
		end

		if t646.refreshOmniRecommendationFeedItemAction ~= nil then
			v5039.kind = {
				type = "refresh_omni_recommendation_feed_item_action",
				value = t1.RefreshOmniRecommendationFeedItemAction.jsonDecode(t646.refreshOmniRecommendationFeedItemAction)
			}
		end

		if t646.ai_overview_feedback_action ~= nil then
			v5039.kind = {
				type = "ai_overview_feedback_action",
				value = t1.AiOverviewFeedbackAction.jsonDecode(t646.ai_overview_feedback_action)
			}
		end

		if t646.aiOverviewFeedbackAction ~= nil then
			v5039.kind = {
				type = "ai_overview_feedback_action",
				value = t1.AiOverviewFeedbackAction.jsonDecode(t646.aiOverviewFeedbackAction)
			}
		end

		if t646.open_trusted_friends_upsell_modal_action ~= nil then
			v5039.kind = {
				type = "open_trusted_friends_upsell_modal_action",
				value = t1.OpenTrustedFriendsUpsellModalAction.jsonDecode(t646.open_trusted_friends_upsell_modal_action)
			}
		end

		if t646.openTrustedFriendsUpsellModalAction ~= nil then
			v5039.kind = {
				type = "open_trusted_friends_upsell_modal_action",
				value = t1.OpenTrustedFriendsUpsellModalAction.jsonDecode(t646.openTrustedFriendsUpsellModalAction)
			}
		end

		if t646.record_party_chat_conversation_upsell_acknowledgement_action ~= nil then
			v5039.kind = {
				type = "record_party_chat_conversation_upsell_acknowledgement_action",
				value = t1.RecordPartyChatConversationUpsellAcknowledgementAction.jsonDecode(t646.record_party_chat_conversation_upsell_acknowledgement_action)
			}
		end

		if t646.recordPartyChatConversationUpsellAcknowledgementAction ~= nil then
			v5039.kind = {
				type = "record_party_chat_conversation_upsell_acknowledgement_action",
				value = t1.RecordPartyChatConversationUpsellAcknowledgementAction.jsonDecode(t646.recordPartyChatConversationUpsellAcknowledgementAction)
			}
		end

		if t646.open_search_results_with_query_action ~= nil then
			v5039.kind = {
				type = "open_search_results_with_query_action",
				value = t1.OpenSearchResultsWithQueryAction.jsonDecode(t646.open_search_results_with_query_action)
			}
		end

		if t646.openSearchResultsWithQueryAction ~= nil then
			v5039.kind = {
				type = "open_search_results_with_query_action",
				value = t1.OpenSearchResultsWithQueryAction.jsonDecode(t646.openSearchResultsWithQueryAction)
			}
		end

		if t646.select_marketplace_favorites_category ~= nil then
			v5039.kind = {
				type = "select_marketplace_favorites_category",
				value = t1.SelectMarketplaceFavoritesCategory.jsonDecode(t646.select_marketplace_favorites_category)
			}
		end

		if t646.selectMarketplaceFavoritesCategory ~= nil then
			v5039.kind = {
				type = "select_marketplace_favorites_category",
				value = t1.SelectMarketplaceFavoritesCategory.jsonDecode(t646.selectMarketplaceFavoritesCategory)
			}
		end

		if t646.download_app_action ~= nil then
			v5039.kind = {
				type = "download_app_action",
				value = t1.DownloadAppAction.jsonDecode(t646.download_app_action)
			}
		end

		if t646.downloadAppAction ~= nil then
			v5039.kind = {
				type = "download_app_action",
				value = t1.DownloadAppAction.jsonDecode(t646.downloadAppAction)
			}
		end

		if t646.refresh_charts_sort_detail_action ~= nil then
			v5039.kind = {
				type = "refresh_charts_sort_detail_action",
				value = t1.RefreshChartsSortDetailAction.jsonDecode(t646.refresh_charts_sort_detail_action)
			}
		end

		if t646.refreshChartsSortDetailAction ~= nil then
			v5039.kind = {
				type = "refresh_charts_sort_detail_action",
				value = t1.RefreshChartsSortDetailAction.jsonDecode(t646.refreshChartsSortDetailAction)
			}
		end

		if t646.join_community_action ~= nil then
			v5039.kind = {
				type = "join_community_action",
				value = t1.JoinCommunityAction.jsonDecode(t646.join_community_action)
			}
		end

		if t646.joinCommunityAction ~= nil then
			v5039.kind = {
				type = "join_community_action",
				value = t1.JoinCommunityAction.jsonDecode(t646.joinCommunityAction)
			}
		end

		if t646.view_community_action ~= nil then
			v5039.kind = {
				type = "view_community_action",
				value = t1.ViewCommunityAction.jsonDecode(t646.view_community_action)
			}
		end

		if t646.viewCommunityAction ~= nil then
			v5039.kind = {
				type = "view_community_action",
				value = t1.ViewCommunityAction.jsonDecode(t646.viewCommunityAction)
			}
		end

		if t646.pin_experience_shortcut_action ~= nil then
			v5039.kind = {
				type = "pin_experience_shortcut_action",
				value = t1.PinExperienceShortcutAction.jsonDecode(t646.pin_experience_shortcut_action)
			}
		end

		if t646.pinExperienceShortcutAction ~= nil then
			v5039.kind = {
				type = "pin_experience_shortcut_action",
				value = t1.PinExperienceShortcutAction.jsonDecode(t646.pinExperienceShortcutAction)
			}
		end

		if t646.select_marketplace_favorites_subcategory ~= nil then
			v5039.kind = {
				type = "select_marketplace_favorites_subcategory",
				value = t1.SelectMarketplaceFavoritesSubcategory.jsonDecode(t646.select_marketplace_favorites_subcategory)
			}
		end

		if t646.selectMarketplaceFavoritesSubcategory ~= nil then
			v5039.kind = {
				type = "select_marketplace_favorites_subcategory",
				value = t1.SelectMarketplaceFavoritesSubcategory.jsonDecode(t646.selectMarketplaceFavoritesSubcategory)
			}
		end

		if t646.show_toast_action ~= nil then
			v5039.kind = {
				type = "show_toast_action",
				value = t1.ShowToastAction.jsonDecode(t646.show_toast_action)
			}
		end

		if t646.showToastAction ~= nil then
			v5039.kind = {
				type = "show_toast_action",
				value = t1.ShowToastAction.jsonDecode(t646.showToastAction)
			}
		end

		if t646.open_incoming_transfer_upsell_action ~= nil then
			v5039.kind = {
				type = "open_incoming_transfer_upsell_action",
				value = t1.OpenIncomingTransferUpsellAction.jsonDecode(t646.open_incoming_transfer_upsell_action)
			}
		end

		if t646.openIncomingTransferUpsellAction ~= nil then
			v5039.kind = {
				type = "open_incoming_transfer_upsell_action",
				value = t1.OpenIncomingTransferUpsellAction.jsonDecode(t646.openIncomingTransferUpsellAction)
			}
		end

		if t646.telemetry_handler ~= nil then
			v5039.telemetry_handler = prop_types.StringProp.jsonDecode(t646.telemetry_handler)
		end

		if t646.telemetryHandler ~= nil then
			v5039.telemetry_handler = prop_types.StringProp.jsonDecode(t646.telemetryHandler)
		end

		if t646.accessibility_label ~= nil then
			v5039.accessibility_label = prop_types.StringFormat.jsonDecode(t646.accessibility_label)
		end

		if t646.accessibilityLabel ~= nil then
			v5039.accessibility_label = prop_types.StringFormat.jsonDecode(t646.accessibilityLabel)
		end

		return v5039
	end

	t643.descriptor = {
		name = "Action",
		fullName = "roblox.apppageplatform.shared.v1beta1.Action"
	}
	t1.Action = t643
end

typeRegistry.default:register(t1.Action)

do
	local t647 = {}

	t647.__index = t647

	function t647.new(t648: {[any]: any}?) -- line: 31682
		-- upvalues: t647 (copy)
		return (setmetatable({
			kind = if t648 ~= nil and t648.kind ~= nil then t648.kind else nil
		}, t647))
	end
	function t647.encode(p487) -- line: 31688
		-- upvalues: proto (copy)
		local buf = buffer.create(0)
		local n322 = 0

		if p487.kind ~= nil then
			if p487.kind.type == "value" then
				local v5044 = p487.kind.value:encode()
				local v5045, v5046 = proto.writeTag(buf, n322, 1, proto.wireTypes.lengthDelimited)

				buf, n322 = proto.writeBuffer(v5045, v5046, v5044, buffer.len(v5044))
			elseif p487.kind.type == "conditional" then
				local v5047 = p487.kind.value:encode()
				local v5048, v5049 = proto.writeTag(buf, n322, 2, proto.wireTypes.lengthDelimited)

				buf, n322 = proto.writeBuffer(v5048, v5049, v5047, buffer.len(v5047))
			end
		end

		local buf164 = buffer.create(n322)

		buffer.copy(buf164, 0, buf, 0, n322)

		return buf164
	end
	function t647.decode(p488: buffer) -- line: 31709
		-- upvalues: t647 (copy), proto (copy), t1 (copy)
		local v5052 = t647.new()
		local n323 = 0

		while n323 < buffer.len(p488) do
			local v5054, v5055

			v5054, v5055, n323 = proto.readTag(p488, n323)

			if v5055 == proto.wireTypes.varint then
				local v5056

				v5056, n323 = proto.readVarInt(p488, n323)
			elseif v5055 == proto.wireTypes.lengthDelimited then
				if v5054 == 1 then
					local v5057

					v5057, n323 = proto.readBuffer(p488, n323)
					v5052.kind = {
						type = "value",
						value = t1.Action.decode(v5057)
					}
				elseif v5054 == 2 then
					local v5058

					v5058, n323 = proto.readBuffer(p488, n323)
					v5052.kind = {
						type = "conditional",
						value = t1.ActionProp_ConditionalOptions.decode(v5058)
					}
				else
					local v5059, v5060 = proto.readVarInt(p488, n323)

					n323 = v5060 + v5059
				end
			elseif v5055 == proto.wireTypes.i32 then
				local v5061

				v5061, n323 = proto.readFixed32(p488, n323)
			elseif v5055 == proto.wireTypes.i64 then
				local v5062

				v5062, n323 = proto.readFixed64(p488, n323)
			else
				error("Unsupported wire type: " .. v5055)
			end
		end

		return v5052
	end
	function t647.jsonEncode(p489) -- line: 31757
		local t649 = {}

		if p489.kind ~= nil then
			if p489.kind.type == "value" then
				t649.value = p489.kind.value:jsonEncode()

				return t649
			end

			if p489.kind.type == "conditional" then
				t649.conditional = p489.kind.value:jsonEncode()
			end
		end

		return t649
	end
	function t647.jsonDecode(t650: {[any]: any}) -- line: 31771
		-- upvalues: t647 (copy), t1 (copy)
		local v5066 = t647.new()

		if t650.value ~= nil then
			v5066.kind = {
				type = "value",
				value = t1.Action.jsonDecode(t650.value)
			}
		end

		if t650.conditional ~= nil then
			v5066.kind = {
				type = "conditional",
				value = t1.ActionProp_ConditionalOptions.jsonDecode(t650.conditional)
			}
		end

		return v5066
	end

	t647.descriptor = {
		name = "ActionProp",
		fullName = "roblox.apppageplatform.shared.v1beta1.ActionProp"
	}
	t1.ActionProp = t647
	typeRegistry.default:register(t1.ActionProp)

	local t651 = {}

	t651.__index = t651

	function t651.new(t652: {[any]: any}?) -- line: 31800
		-- upvalues: t651 (copy)
		return (setmetatable({
			condition = if t652 ~= nil and t652.condition ~= nil then t652.condition else nil,
			kind = if t652 ~= nil and t652.kind ~= nil then t652.kind else nil
		}, t651))
	end
	function t651.encode(p490) -- line: 31809
		-- upvalues: proto (copy)
		local buf = buffer.create(0)
		local n324 = 0

		if p490.condition ~= nil then
			local v5071 = p490.condition:encode()
			local v5072, v5073 = proto.writeTag(buf, n324, 1, proto.wireTypes.lengthDelimited)

			buf, n324 = proto.writeBuffer(v5072, v5073, v5071, buffer.len(v5071))
		end

		if p490.kind ~= nil and p490.kind.type == "value" then
			local v5074 = p490.kind.value:encode()
			local v5075, v5076 = proto.writeTag(buf, n324, 3, proto.wireTypes.lengthDelimited)

			buf, n324 = proto.writeBuffer(v5075, v5076, v5074, buffer.len(v5074))
		end

		local buf165 = buffer.create(n324)

		buffer.copy(buf165, 0, buf, 0, n324)

		return buf165
	end
	function t651.decode(p491: buffer) -- line: 31832
		-- upvalues: t651 (copy), proto (copy), prop_condition (copy), t1 (copy)
		local v5079 = t651.new()
		local n325 = 0

		while n325 < buffer.len(p491) do
			local v5081, v5082

			v5081, v5082, n325 = proto.readTag(p491, n325)

			if v5082 == proto.wireTypes.varint then
				local v5083

				v5083, n325 = proto.readVarInt(p491, n325)
			elseif v5082 == proto.wireTypes.lengthDelimited then
				if v5081 == 1 then
					local v5084

					v5084, n325 = proto.readBuffer(p491, n325)
					v5079.condition = prop_condition.PropCondition.decode(v5084)
				elseif v5081 == 3 then
					local v5085

					v5085, n325 = proto.readBuffer(p491, n325)
					v5079.kind = {
						type = "value",
						value = t1.Action.decode(v5085)
					}
				else
					local v5086, v5087 = proto.readVarInt(p491, n325)

					n325 = v5087 + v5086
				end
			elseif v5082 == proto.wireTypes.i32 then
				local v5088

				v5088, n325 = proto.readFixed32(p491, n325)
			elseif v5082 == proto.wireTypes.i64 then
				local v5089

				v5089, n325 = proto.readFixed64(p491, n325)
			else
				error("Unsupported wire type: " .. v5082)
			end
		end

		return v5079
	end
	function t651.jsonEncode(p492) -- line: 31880
		local t653 = {}

		if p492.condition ~= nil then
			t653.condition = p492.condition:jsonEncode()
		end

		if p492.kind ~= nil and p492.kind.type == "value" then
			t653.value = p492.kind.value:jsonEncode()
		end

		return t653
	end
	function t651.jsonDecode(t654: {[any]: any}) -- line: 31896
		-- upvalues: t651 (copy), prop_condition (copy), t1 (copy)
		local v5093 = t651.new()

		if t654.condition ~= nil then
			v5093.condition = prop_condition.PropCondition.jsonDecode(t654.condition)
		end

		if t654.value ~= nil then
			v5093.kind = {
				type = "value",
				value = t1.Action.jsonDecode(t654.value)
			}
		end

		return v5093
	end

	t651.descriptor = {
		name = "ActionProp_ConditionalOption",
		fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
	}
	t1.ActionProp_ConditionalOption = t651
	typeRegistry.default:register(t1.ActionProp_ConditionalOption)

	local t655 = {}

	t655.__index = t655

	function t655.new(t656: {[any]: any}?) -- line: 31925
		-- upvalues: t655 (copy)
		return (setmetatable({
			options = if t656 ~= nil and t656.options ~= nil then t656.options else {}
		}, t655))
	end
	function t655.encode(p493) -- line: 31933
		-- upvalues: proto (copy)
		local buf = buffer.create(0)
		local n326 = 0

		if p493.options ~= nil and #p493.options > 0 then
			for _, v5099 in p493.options do
				local v5100 = v5099:encode()
				local v5101, v5102 = proto.writeTag(buf, n326, 1, proto.wireTypes.lengthDelimited)

				buf, n326 = proto.writeBuffer(v5101, v5102, v5100, buffer.len(v5100))
			end
		end

		local buf166 = buffer.create(n326)

		buffer.copy(buf166, 0, buf, 0, n326)

		return buf166
	end
	function t655.decode(p494: buffer) -- line: 31950
		-- upvalues: t655 (copy), proto (copy), t1 (copy)
		local v5105 = t655.new()
		local n327 = 0

		while n327 < buffer.len(p494) do
			local v5107, v5108

			v5107, v5108, n327 = proto.readTag(p494, n327)

			if v5108 == proto.wireTypes.varint then
				local v5109

				v5109, n327 = proto.readVarInt(p494, n327)
			elseif v5108 == proto.wireTypes.lengthDelimited then
				if v5107 == 1 then
					local v5110

					v5110, n327 = proto.readBuffer(p494, n327)
					table.insert(v5105.options, t1.ActionProp_ConditionalOption.decode(v5110))
				else
					local v5111, v5112 = proto.readVarInt(p494, n327)

					n327 = v5112 + v5111
				end
			elseif v5108 == proto.wireTypes.i32 then
				local v5113

				v5113, n327 = proto.readFixed32(p494, n327)
			elseif v5108 == proto.wireTypes.i64 then
				local v5114

				v5114, n327 = proto.readFixed64(p494, n327)
			else
				error("Unsupported wire type: " .. v5108)
			end
		end

		return v5105
	end
	function t655.jsonEncode(p495) -- line: 31993
		local t657 = {}

		if p495.options ~= nil and #p495.options > 0 then
			local t658 = {}

			for _, v5119 in p495.options do
				table.insert(t658, v5119:jsonEncode())
			end

			t657.options = t658
		end

		return t657
	end
	function t655.jsonDecode(t659: {[any]: any}) -- line: 32007
		-- upvalues: t655 (copy), t1 (copy)
		local v5121 = t655.new()

		if t659.options ~= nil then
			local t660 = {}

			for _, v5124 in t659.options do
				table.insert(t660, t1.ActionProp_ConditionalOption.jsonDecode(v5124))
			end

			v5121.options = t660
		end

		return v5121
	end

	t655.descriptor = {
		name = "ActionProp_ConditionalOptions",
		fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
	}
	t1.ActionProp_ConditionalOptions = t655
	typeRegistry.default:register(t1.ActionProp_ConditionalOptions)

	local t661 = {}

	t661.__index = t661

	function t661.new(t662: {[any]: any}?) -- line: 32036
		-- upvalues: t661 (copy)
		return (setmetatable({
			kind = if t662 ~= nil and t662.kind ~= nil then t662.kind else nil
		}, t661))
	end
	function t661.encode(p496) -- line: 32042
		-- upvalues: proto (copy)
		local buf = buffer.create(0)
		local n328 = 0

		if p496.kind ~= nil then
			if p496.kind.type == "literal" then
				local v5129 = p496.kind.value:encode()
				local v5130, v5131 = proto.writeTag(buf, n328, 1, proto.wireTypes.lengthDelimited)

				buf, n328 = proto.writeBuffer(v5130, v5131, v5129, buffer.len(v5129))
			elseif p496.kind.type == "conditional" then
				local v5132 = p496.kind.value:encode()
				local v5133, v5134 = proto.writeTag(buf, n328, 2, proto.wireTypes.lengthDelimited)

				buf, n328 = proto.writeBuffer(v5133, v5134, v5132, buffer.len(v5132))
			elseif p496.kind.type == "binding_path" then
				local v5135, v5136 = proto.writeTag(buf, n328, 3, proto.wireTypes.lengthDelimited)

				buf, n328 = proto.writeString(v5135, v5136, p496.kind.value)
			end
		end

		local buf167 = buffer.create(n328)

		buffer.copy(buf167, 0, buf, 0, n328)

		return buf167
	end
	function t661.decode(p497: buffer) -- line: 32066
		-- upvalues: t661 (copy), proto (copy), t1 (copy)
		local v5139 = t661.new()
		local n329 = 0

		while n329 < buffer.len(p497) do
			local v5141, v5142

			v5141, v5142, n329 = proto.readTag(p497, n329)

			if v5142 == proto.wireTypes.varint then
				local v5143

				v5143, n329 = proto.readVarInt(p497, n329)
			elseif v5142 == proto.wireTypes.lengthDelimited then
				if v5141 == 1 then
					local v5144

					v5144, n329 = proto.readBuffer(p497, n329)
					v5139.kind = {
						type = "literal",
						value = t1.FocusNavActionsProp_FocusNavData.decode(v5144)
					}
				elseif v5141 == 2 then
					local v5145

					v5145, n329 = proto.readBuffer(p497, n329)
					v5139.kind = {
						type = "conditional",
						value = t1.FocusNavActionsProp_ConditionalOptions.decode(v5145)
					}
				elseif v5141 == 3 then
					local v5146

					v5146, n329 = proto.readBuffer(p497, n329)
					v5139.kind = {
						type = "binding_path",
						value = buffer.tostring(v5146)
					}
				else
					local v5147, v5148 = proto.readVarInt(p497, n329)

					n329 = v5148 + v5147
				end
			elseif v5142 == proto.wireTypes.i32 then
				local v5149

				v5149, n329 = proto.readFixed32(p497, n329)
			elseif v5142 == proto.wireTypes.i64 then
				local v5150

				v5150, n329 = proto.readFixed64(p497, n329)
			else
				error("Unsupported wire type: " .. v5142)
			end
		end

		return v5139
	end
	function t661.jsonEncode(p498) -- line: 32120
		local t663 = {}

		if p498.kind ~= nil then
			if p498.kind.type == "literal" then
				t663.literal = p498.kind.value:jsonEncode()

				return t663
			end

			if p498.kind.type == "conditional" then
				t663.conditional = p498.kind.value:jsonEncode()

				return t663
			end

			if p498.kind.type == "binding_path" then
				t663.bindingPath = p498.kind.value
			end
		end

		return t663
	end
	function t661.jsonDecode(t664: {[any]: any}) -- line: 32136
		-- upvalues: t661 (copy), t1 (copy)
		local v5154 = t661.new()

		if t664.literal ~= nil then
			v5154.kind = {
				type = "literal",
				value = t1.FocusNavActionsProp_FocusNavData.jsonDecode(t664.literal)
			}
		end

		if t664.conditional ~= nil then
			v5154.kind = {
				type = "conditional",
				value = t1.FocusNavActionsProp_ConditionalOptions.jsonDecode(t664.conditional)
			}
		end

		if t664.binding_path ~= nil then
			v5154.kind = {
				type = "binding_path",
				value = t664.binding_path
			}
		end

		if t664.bindingPath ~= nil then
			v5154.kind = {
				type = "binding_path",
				value = t664.bindingPath
			}
		end

		return v5154
	end

	t661.descriptor = {
		name = "FocusNavActionsProp",
		fullName = "roblox.apppageplatform.shared.v1beta1.FocusNavActionsProp"
	}
	t1.FocusNavActionsProp = t661
end

typeRegistry.default:register(t1.FocusNavActionsProp)

local t665 = {}

t665.__index = t665

function t665.new(t666: {[any]: any}?) -- line: 32176
	-- upvalues: t665 (copy)
	return (setmetatable({
		condition = if t666 ~= nil and t666.condition ~= nil then t666.condition else nil,
		kind = if t666 ~= nil and t666.kind ~= nil then t666.kind else nil
	}, t665))
end
function t665.encode(p499) -- line: 32185
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n330 = 0

	if p499.condition ~= nil then
		local v5159 = p499.condition:encode()
		local v5160, v5161 = proto.writeTag(buf, n330, 1, proto.wireTypes.lengthDelimited)

		buf, n330 = proto.writeBuffer(v5160, v5161, v5159, buffer.len(v5159))
	end

	if p499.kind ~= nil then
		if p499.kind.type == "literal" then
			local v5162 = p499.kind.value:encode()
			local v5163, v5164 = proto.writeTag(buf, n330, 3, proto.wireTypes.lengthDelimited)

			buf, n330 = proto.writeBuffer(v5163, v5164, v5162, buffer.len(v5162))
		elseif p499.kind.type == "binding_path" then
			local v5165, v5166 = proto.writeTag(buf, n330, 4, proto.wireTypes.lengthDelimited)

			buf, n330 = proto.writeString(v5165, v5166, p499.kind.value)
		end
	end

	local buf168 = buffer.create(n330)

	buffer.copy(buf168, 0, buf, 0, n330)

	return buf168
end
function t665.decode(p500: buffer) -- line: 32211
	-- upvalues: t665 (copy), proto (copy), prop_condition (copy), t1 (copy)
	local v5169 = t665.new()
	local n331 = 0

	while n331 < buffer.len(p500) do
		local v5171, v5172

		v5171, v5172, n331 = proto.readTag(p500, n331)

		if v5172 == proto.wireTypes.varint then
			local v5173

			v5173, n331 = proto.readVarInt(p500, n331)
		elseif v5172 == proto.wireTypes.lengthDelimited then
			if v5171 == 1 then
				local v5174

				v5174, n331 = proto.readBuffer(p500, n331)
				v5169.condition = prop_condition.PropCondition.decode(v5174)
			elseif v5171 == 3 then
				local v5175

				v5175, n331 = proto.readBuffer(p500, n331)
				v5169.kind = {
					type = "literal",
					value = t1.FocusNavActionsProp_FocusNavData.decode(v5175)
				}
			elseif v5171 == 4 then
				local v5176

				v5176, n331 = proto.readBuffer(p500, n331)
				v5169.kind = {
					type = "binding_path",
					value = buffer.tostring(v5176)
				}
			else
				local v5177, v5178 = proto.readVarInt(p500, n331)

				n331 = v5178 + v5177
			end
		elseif v5172 == proto.wireTypes.i32 then
			local v5179

			v5179, n331 = proto.readFixed32(p500, n331)
		elseif v5172 == proto.wireTypes.i64 then
			local v5180

			v5180, n331 = proto.readFixed64(p500, n331)
		else
			error("Unsupported wire type: " .. v5172)
		end
	end

	return v5169
end
function t665.jsonEncode(p501) -- line: 32264
	local t667 = {}

	if p501.condition ~= nil then
		t667.condition = p501.condition:jsonEncode()
	end

	if p501.kind ~= nil then
		if p501.kind.type == "literal" then
			t667.literal = p501.kind.value:jsonEncode()

			return t667
		end

		if p501.kind.type == "binding_path" then
			t667.bindingPath = p501.kind.value
		end
	end

	return t667
end
function t665.jsonDecode(t668: {[any]: any}) -- line: 32282
	-- upvalues: t665 (copy), prop_condition (copy), t1 (copy)
	local v5184 = t665.new()

	if t668.condition ~= nil then
		v5184.condition = prop_condition.PropCondition.jsonDecode(t668.condition)
	end

	if t668.literal ~= nil then
		v5184.kind = {
			type = "literal",
			value = t1.FocusNavActionsProp_FocusNavData.jsonDecode(t668.literal)
		}
	end

	if t668.binding_path ~= nil then
		v5184.kind = {
			type = "binding_path",
			value = t668.binding_path
		}
	end

	if t668.bindingPath ~= nil then
		v5184.kind = {
			type = "binding_path",
			value = t668.bindingPath
		}
	end

	return v5184
end

t665.descriptor = {
	name = "FocusNavActionsProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.FocusNavActionsProp_ConditionalOption = t665
typeRegistry.default:register(t1.FocusNavActionsProp_ConditionalOption)

local t669 = {}

t669.__index = t669

function t669.new(t670: {[any]: any}?) -- line: 32322
	-- upvalues: t669 (copy)
	return (setmetatable({
		options = if t670 ~= nil and t670.options ~= nil then t670.options else {}
	}, t669))
end
function t669.encode(p502) -- line: 32330
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n332 = 0

	if p502.options ~= nil and #p502.options > 0 then
		for _, v5190 in p502.options do
			local v5191 = v5190:encode()
			local v5192, v5193 = proto.writeTag(buf, n332, 1, proto.wireTypes.lengthDelimited)

			buf, n332 = proto.writeBuffer(v5192, v5193, v5191, buffer.len(v5191))
		end
	end

	local buf169 = buffer.create(n332)

	buffer.copy(buf169, 0, buf, 0, n332)

	return buf169
end
function t669.decode(p503: buffer) -- line: 32347
	-- upvalues: t669 (copy), proto (copy), t1 (copy)
	local v5196 = t669.new()
	local n333 = 0

	while n333 < buffer.len(p503) do
		local v5198, v5199

		v5198, v5199, n333 = proto.readTag(p503, n333)

		if v5199 == proto.wireTypes.varint then
			local v5200

			v5200, n333 = proto.readVarInt(p503, n333)
		elseif v5199 == proto.wireTypes.lengthDelimited then
			if v5198 == 1 then
				local v5201

				v5201, n333 = proto.readBuffer(p503, n333)
				table.insert(v5196.options, t1.FocusNavActionsProp_ConditionalOption.decode(v5201))
			else
				local v5202, v5203 = proto.readVarInt(p503, n333)

				n333 = v5203 + v5202
			end
		elseif v5199 == proto.wireTypes.i32 then
			local v5204

			v5204, n333 = proto.readFixed32(p503, n333)
		elseif v5199 == proto.wireTypes.i64 then
			local v5205

			v5205, n333 = proto.readFixed64(p503, n333)
		else
			error("Unsupported wire type: " .. v5199)
		end
	end

	return v5196
end
function t669.jsonEncode(p504) -- line: 32390
	local t671 = {}

	if p504.options ~= nil and #p504.options > 0 then
		local t672 = {}

		for _, v5210 in p504.options do
			table.insert(t672, v5210:jsonEncode())
		end

		t671.options = t672
	end

	return t671
end
function t669.jsonDecode(t673: {[any]: any}) -- line: 32404
	-- upvalues: t669 (copy), t1 (copy)
	local v5212 = t669.new()

	if t673.options ~= nil then
		local t674 = {}

		for _, v5215 in t673.options do
			table.insert(t674, t1.FocusNavActionsProp_ConditionalOption.jsonDecode(v5215))
		end

		v5212.options = t674
	end

	return v5212
end

t669.descriptor = {
	name = "FocusNavActionsProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.FocusNavActionsProp_ConditionalOptions = t669
typeRegistry.default:register(t1.FocusNavActionsProp_ConditionalOptions)

local t675 = {}

t675.__index = t675

function t675.new(t676: {[any]: any}?) -- line: 32435
	-- upvalues: t675 (copy)
	return (setmetatable({
		keys = if t676 ~= nil and t676.keys ~= nil then t676.keys else {},
		events = if t676 ~= nil and t676.events ~= nil then t676.events else {}
	}, t675))
end
function t675.encode(p505) -- line: 32444
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n334 = 0

	if p505.keys ~= nil and next(p505.keys) ~= nil then
		for v5220, v5221 in p505.keys do
			local buf170 = buffer.create(0)
			local v5223, v5224 = proto.writeTag(buf170, 0, 1, proto.wireTypes.lengthDelimited)
			local v5225, v5226 = proto.writeString(v5223, v5224, v5220)
			local v5227 = v5221:encode()
			local v5228, v5229 = proto.writeTag(v5225, v5226, 2, proto.wireTypes.lengthDelimited)
			local v5230, v5231 = proto.writeBuffer(v5228, v5229, v5227, buffer.len(v5227))
			local v5232, v5233 = proto.writeTag(buf, n334, 3, proto.wireTypes.lengthDelimited)

			buf, n334 = proto.writeBuffer(v5232, v5233, v5230, v5231)
		end
	end

	if p505.events ~= nil and next(p505.events) ~= nil then
		for v5234, v5235 in p505.events do
			local buf171 = buffer.create(0)
			local v5237, v5238 = proto.writeTag(buf171, 0, 1, proto.wireTypes.lengthDelimited)
			local v5239, v5240 = proto.writeString(v5237, v5238, v5234)
			local v5241 = v5235:encode()
			local v5242, v5243 = proto.writeTag(v5239, v5240, 2, proto.wireTypes.lengthDelimited)
			local v5244, v5245 = proto.writeBuffer(v5242, v5243, v5241, buffer.len(v5241))
			local v5246, v5247 = proto.writeTag(buf, n334, 4, proto.wireTypes.lengthDelimited)

			buf, n334 = proto.writeBuffer(v5246, v5247, v5244, v5245)
		end
	end

	local buf172 = buffer.create(n334)

	buffer.copy(buf172, 0, buf, 0, n334)

	return buf172
end
function t675.decode(p506: buffer) -- line: 32481
	-- upvalues: t675 (copy), proto (copy), t1 (copy), prop_types_engine (copy)
	local v5250 = t675.new()
	local n335 = 0

	while n335 < buffer.len(p506) do
		local v5252, v5253

		v5252, v5253, n335 = proto.readTag(p506, n335)

		if v5253 == proto.wireTypes.varint then
			local v5254

			v5254, n335 = proto.readVarInt(p506, n335)
		elseif v5253 == proto.wireTypes.lengthDelimited then
			if v5252 == 3 then
				local v5255

				v5255, n335 = proto.readBuffer(p506, n335)

				local v5256 = t1.FocusNavActionsProp_FocusNavData_KeysEntry.decode(v5255)
				local v5257 = prop_types_engine.KeyCodeProp.new()

				v5250.keys[v5256.key or ""] = v5256.value or v5257
			elseif v5252 == 4 then
				local v5258

				v5258, n335 = proto.readBuffer(p506, n335)

				local v5259 = t1.FocusNavActionsProp_FocusNavData_EventsEntry.decode(v5258)
				local v5260 = t1.ActionProp.new()

				v5250.events[v5259.key or ""] = v5259.value or v5260
			else
				local v5261, v5262 = proto.readVarInt(p506, n335)

				n335 = v5262 + v5261
			end
		elseif v5253 == proto.wireTypes.i32 then
			local v5263

			v5263, n335 = proto.readFixed32(p506, n335)
		elseif v5253 == proto.wireTypes.i64 then
			local v5264

			v5264, n335 = proto.readFixed64(p506, n335)
		else
			error("Unsupported wire type: " .. v5253)
		end
	end

	return v5250
end
function t675.jsonEncode(p507) -- line: 32543
	local t677 = {}

	if p507.keys ~= nil and next(p507.keys) ~= nil then
		local t678 = {}

		for v5268, v5269 in p507.keys do
			t678[v5268] = v5269:jsonEncode()
		end

		t677.keys = t678
	end

	if p507.events ~= nil and next(p507.events) ~= nil then
		local t679 = {}

		for v5271, v5272 in p507.events do
			t679[v5271] = v5272:jsonEncode()
		end

		t677.events = t679
	end

	return t677
end
function t675.jsonDecode(t680: {[any]: any}) -- line: 32565
	-- upvalues: t675 (copy), prop_types_engine (copy), t1 (copy)
	local v5274 = t675.new()

	if t680.keys ~= nil then
		local t681 = {}

		for v5276, v5277 in t680.keys do
			t681[v5276] = prop_types_engine.KeyCodeProp.jsonDecode(v5277)
		end

		v5274.keys = t681
	end

	if t680.events ~= nil then
		local t682 = {}

		for v5279, v5280 in t680.events do
			t682[v5279] = t1.ActionProp.jsonDecode(v5280)
		end

		v5274.events = t682
	end

	return v5274
end

t675.descriptor = {
	name = "FocusNavActionsProp_FocusNavData",
	fullName = "roblox.apppageplatform.shared.v1beta1.FocusNavData"
}
t1.FocusNavActionsProp_FocusNavData = t675
typeRegistry.default:register(t1.FocusNavActionsProp_FocusNavData)

local t683 = {}

t683.__index = t683

function t683.new(t684: {[any]: any}?) -- line: 32605
	-- upvalues: t683 (copy)
	return (setmetatable({
		key = if t684 ~= nil and t684.key ~= nil then t684.key else "",
		value = if t684 ~= nil and t684.value ~= nil then t684.value else nil
	}, t683))
end
function t683.encode(p508) -- line: 32614
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n336 = 0

	if p508.key ~= nil and p508.key ~= "" then
		local v5285, v5286 = proto.writeTag(buf, n336, 1, proto.wireTypes.lengthDelimited)

		buf, n336 = proto.writeString(v5285, v5286, p508.key)
	end

	if p508.value ~= nil then
		local v5287 = p508.value:encode()
		local v5288, v5289 = proto.writeTag(buf, n336, 2, proto.wireTypes.lengthDelimited)

		buf, n336 = proto.writeBuffer(v5288, v5289, v5287, buffer.len(v5287))
	end

	local buf173 = buffer.create(n336)

	buffer.copy(buf173, 0, buf, 0, n336)

	return buf173
end
function t683.decode(p509: buffer) -- line: 32636
	-- upvalues: t683 (copy), proto (copy), prop_types_engine (copy)
	local v5292 = t683.new()
	local n337 = 0

	while n337 < buffer.len(p509) do
		local v5294, v5295

		v5294, v5295, n337 = proto.readTag(p509, n337)

		if v5295 == proto.wireTypes.varint then
			local v5296

			v5296, n337 = proto.readVarInt(p509, n337)
		elseif v5295 == proto.wireTypes.lengthDelimited then
			if v5294 == 1 then
				local v5297

				v5297, n337 = proto.readBuffer(p509, n337)
				v5292.key = buffer.tostring(v5297)
			elseif v5294 == 2 then
				local v5298

				v5298, n337 = proto.readBuffer(p509, n337)
				v5292.value = prop_types_engine.KeyCodeProp.decode(v5298)
			else
				local v5299, v5300 = proto.readVarInt(p509, n337)

				n337 = v5300 + v5299
			end
		elseif v5295 == proto.wireTypes.i32 then
			local v5301

			v5301, n337 = proto.readFixed32(p509, n337)
		elseif v5295 == proto.wireTypes.i64 then
			local v5302

			v5302, n337 = proto.readFixed64(p509, n337)
		else
			error("Unsupported wire type: " .. v5295)
		end
	end

	return v5292
end
function t683.jsonEncode(p510) -- line: 32686
	local t685 = {}

	if p510.key ~= nil and p510.key ~= "" then
		t685.key = p510.key
	end

	if p510.value ~= nil then
		t685.value = p510.value:jsonEncode()
	end

	return t685
end
function t683.jsonDecode(t686: {[any]: any}) -- line: 32702
	-- upvalues: t683 (copy), prop_types_engine (copy)
	local v5306 = t683.new()

	if t686.key ~= nil then
		v5306.key = t686.key
	end

	if t686.value ~= nil then
		v5306.value = prop_types_engine.KeyCodeProp.jsonDecode(t686.value)
	end

	return v5306
end

t683.descriptor = {
	name = "FocusNavActionsProp_FocusNavData_KeysEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.KeysEntry"
}
t1.FocusNavActionsProp_FocusNavData_KeysEntry = t683
typeRegistry.default:register(t1.FocusNavActionsProp_FocusNavData_KeysEntry)

local t687 = {}

t687.__index = t687

function t687.new(t688: {[any]: any}?) -- line: 32732
	-- upvalues: t687 (copy)
	return (setmetatable({
		key = if t688 ~= nil and t688.key ~= nil then t688.key else "",
		value = if t688 ~= nil and t688.value ~= nil then t688.value else nil
	}, t687))
end
function t687.encode(p511) -- line: 32741
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n338 = 0

	if p511.key ~= nil and p511.key ~= "" then
		local v5311, v5312 = proto.writeTag(buf, n338, 1, proto.wireTypes.lengthDelimited)

		buf, n338 = proto.writeString(v5311, v5312, p511.key)
	end

	if p511.value ~= nil then
		local v5313 = p511.value:encode()
		local v5314, v5315 = proto.writeTag(buf, n338, 2, proto.wireTypes.lengthDelimited)

		buf, n338 = proto.writeBuffer(v5314, v5315, v5313, buffer.len(v5313))
	end

	local buf174 = buffer.create(n338)

	buffer.copy(buf174, 0, buf, 0, n338)

	return buf174
end
function t687.decode(p512: buffer) -- line: 32763
	-- upvalues: t687 (copy), proto (copy), t1 (copy)
	local v5318 = t687.new()
	local n339 = 0

	while n339 < buffer.len(p512) do
		local v5320, v5321

		v5320, v5321, n339 = proto.readTag(p512, n339)

		if v5321 == proto.wireTypes.varint then
			local v5322

			v5322, n339 = proto.readVarInt(p512, n339)
		elseif v5321 == proto.wireTypes.lengthDelimited then
			if v5320 == 1 then
				local v5323

				v5323, n339 = proto.readBuffer(p512, n339)
				v5318.key = buffer.tostring(v5323)
			elseif v5320 == 2 then
				local v5324

				v5324, n339 = proto.readBuffer(p512, n339)
				v5318.value = t1.ActionProp.decode(v5324)
			else
				local v5325, v5326 = proto.readVarInt(p512, n339)

				n339 = v5326 + v5325
			end
		elseif v5321 == proto.wireTypes.i32 then
			local v5327

			v5327, n339 = proto.readFixed32(p512, n339)
		elseif v5321 == proto.wireTypes.i64 then
			local v5328

			v5328, n339 = proto.readFixed64(p512, n339)
		else
			error("Unsupported wire type: " .. v5321)
		end
	end

	return v5318
end
function t687.jsonEncode(p513) -- line: 32813
	local t689 = {}

	if p513.key ~= nil and p513.key ~= "" then
		t689.key = p513.key
	end

	if p513.value ~= nil then
		t689.value = p513.value:jsonEncode()
	end

	return t689
end
function t687.jsonDecode(t690: {[any]: any}) -- line: 32829
	-- upvalues: t687 (copy), t1 (copy)
	local v5332 = t687.new()

	if t690.key ~= nil then
		v5332.key = t690.key
	end

	if t690.value ~= nil then
		v5332.value = t1.ActionProp.jsonDecode(t690.value)
	end

	return v5332
end

t687.descriptor = {
	name = "FocusNavActionsProp_FocusNavData_EventsEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventsEntry"
}
t1.FocusNavActionsProp_FocusNavData_EventsEntry = t687
typeRegistry.default:register(t1.FocusNavActionsProp_FocusNavData_EventsEntry)
t1.ActionType = {
	fromNumber = function(n340: number) -- line: 32856
		if n340 == 0 then
			return "ACTION_TYPE_INVALID"
		end

		if n340 == 1 then
			return "ACTION_TYPE_DISMISS_DIALOG"
		end

		if n340 == 2 then
			return "ACTION_TYPE_LINK"
		end

		if n340 == 3 then
			return "ACTION_TYPE_OPEN_GAME_DETAILS"
		end

		if n340 == 4 then
			return "ACTION_TYPE_OPEN_JOIN_FRIENDS"
		end

		if n340 == 5 then
			return "ACTION_TYPE_OPEN_MARKETPLACE_TRY_ON"
		end

		if n340 == 6 then
			return "ACTION_TYPE_OPEN_SEE_ALL"
		end

		if n340 == 7 then
			return "ACTION_TYPE_OPEN_SPONSORED_TOOLTIP"
		end

		if n340 == 8 then
			return "ACTION_TYPE_PLAY_BUTTON_CLICK"
		end

		if n340 == 9 then
			return "ACTION_TYPE_UPDATE_USER_SETTINGS"
		end

		if n340 == 10 then
			return "ACTION_TYPE_OPEN_TOOLTIP"
		end

		if n340 == 11 then
			return "ACTION_TYPE_OPEN_BADGE_DETAILS"
		end

		if n340 == 12 then
			return "ACTION_TYPE_LOAD_MORE_FROM_API"
		end

		if n340 == 13 then
			return "ACTION_TYPE_SHARE"
		end

		if n340 == 14 then
			return "ACTION_TYPE_OPEN_ABUSE_REPORT"
		end

		if n340 == 15 then
			return "ACTION_TYPE_REMOVE_BADGE_FROM_INVENTORY"
		end

		if n340 == 16 then
			return "ACTION_TYPE_OPEN_PROFILE"
		end

		if n340 == 17 then
			return "ACTION_TYPE_OPEN_FACIAL_AGE_ESTIMATION"
		end

		if n340 == 18 then
			return "ACTION_TYPE_OPEN_ADD_CONNECTIONS_PAGE"
		end

		if n340 == 19 then
			return "ACTION_TYPE_OPEN_MARKETPLACE"
		end

		if n340 == 20 then
			return "ACTION_TYPE_HIDE_PROFILE_COMPLETION"
		end

		if n340 == 21 then
			return "ACTION_TYPE_SELECT_MARKETPLACE_CATALOG_CATEGORY"
		end

		if n340 == 22 then
			return "ACTION_TYPE_SELECT_MARKETPLACE_CATALOG_SUBCATEGORY"
		end

		if n340 == 23 then
			return "ACTION_TYPE_OPEN_MARKETPLACE_CATALOG_SEE_ALL"
		end

		if n340 == 24 then
			return "ACTION_TYPE_CLOSE_MARKETPLACE_CATEGORY_TOOLTIP"
		end

		if n340 == 25 then
			return "ACTION_TYPE_RESIZE_MARKETPLACE_CATALOG"
		end

		if n340 == 26 then
			return "ACTION_TYPE_OPEN_MARKETPLACE_CATALOG_FILTERS"
		end

		if n340 == 27 then
			return "ACTION_TYPE_OPEN_SOCIAL_LINK"
		end

		if n340 == 28 then
			return "ACTION_TYPE_OPEN_CHARTS_SORT_DETAIL"
		end

		if n340 == 29 then
			return "ACTION_TYPE_OPEN_SONG_DETAIL"
		end

		if n340 == 30 then
			return "ACTION_TYPE_REFRESH_FROM_API"
		end

		if n340 == 31 then
			return "ACTION_TYPE_RSVP_TO_EVENT"
		end

		if n340 == 32 then
			return "ACTION_TYPE_APPLY_CHARTS_FILTER"
		end

		if n340 == 33 then
			return "ACTION_TYPE_ANALYTICS_EVENT"
		end

		if n340 == 34 then
			return "ACTION_TYPE_CUSTOM_ANALYTICS_EVENT"
		end

		if n340 == 35 then
			return "ACTION_TYPE_OPEN_GAME_INVITE"
		end

		if n340 == 36 then
			return "ACTION_TYPE_OPEN_EVENT_DETAILS"
		end

		if n340 == 37 then
			return "ACTION_TYPE_LAUNCH_EXPERIENCE"
		end

		if n340 == 38 then
			return "ACTION_TYPE_TOGGLE_EXPERIENCE_FAVORITE"
		end

		if n340 == 39 then
			return "ACTION_TYPE_TOGGLE_EXPERIENCE_FOLLOW"
		end

		if n340 == 40 then
			return "ACTION_TYPE_TOGGLE_EXPERIENCE_VOTE"
		end

		if n340 == 41 then
			return "ACTION_TYPE_OPEN_PURCHASE_PROMPT"
		end

		if n340 == 42 then
			return "ACTION_TYPE_OPEN_SDUI_OVERLAY"
		end

		if n340 == 43 then
			return "ACTION_TYPE_OPEN_BADGES_SEE_ALL"
		end

		if n340 == 44 then
			return "ACTION_TYPE_OPEN_EXPERIENCE_STORE_SEE_ALL"
		end

		if n340 == 45 then
			return "ACTION_TYPE_DISMISS_GAME_FEEDBACK"
		end

		if n340 == 46 then
			return "ACTION_TYPE_OPEN_GAME_FEEDBACK_FORM"
		end

		if n340 == 47 then
			return "ACTION_TYPE_ENABLE_EVENT_NOTIFICATIONS"
		end

		if n340 == 48 then
			return "ACTION_TYPE_DISMISS_EVENT_NOTIFICATIONS_MODAL"
		end

		if n340 == 49 then
			return "ACTION_TYPE_OPEN_AMP_WIZARD"
		end

		if n340 == 50 then
			return "ACTION_TYPE_OPEN_SUBSCRIPTION_PURCHASE_PAGE"
		end

		if n340 == 51 then
			return "ACTION_TYPE_REFRESH_GAME_PASSES"
		end

		if n340 == 52 then
			return "ACTION_TYPE_REFRESH_PLAYABILITY"
		end

		if n340 == 53 then
			return "ACTION_TYPE_OPEN_SOCIAL_PROOF_USER_LIST_SHEET"
		end

		if n340 == 54 then
			return "ACTION_TYPE_REPORT_SURFACE_LOAD_TIME_MILESTONE"
		end

		if n340 == 55 then
			return "ACTION_TYPE_OPEN_SEARCH_RESULTS_TAB"
		end

		if n340 == 56 then
			return "ACTION_TYPE_OPEN_PHONE_UPSELL_MODAL"
		end

		if n340 == 57 then
			return "ACTION_TYPE_OPEN_EMAIL_UPSELL_MODAL"
		end

		if n340 == 58 then
			return "ACTION_TYPE_DISMISS_PROMPT"
		end

		if n340 == 59 then
			return "ACTION_TYPE_REQUEST_FRIENDSHIP"
		end

		if n340 == 60 then
			return "ACTION_TYPE_REFRESH_DEVELOPER_PRODUCTS"
		end

		if n340 == 61 then
			return "ACTION_TYPE_OPEN_FAE_TRIAL_UPSELL"
		end

		if n340 == 62 then
			return "ACTION_TYPE_REFRESH_OMNI_RECOMMENDATION_FEED_ITEM"
		end

		if n340 == 63 then
			return "ACTION_TYPE_AI_OVERVIEW_FEEDBACK"
		end

		if n340 == 64 then
			return "ACTION_TYPE_OPEN_TRUSTED_FRIENDS_UPSELL_MODAL"
		end

		if n340 == 65 then
			return "ACTION_TYPE_RECORD_PARTY_CHAT_CONVERSATION_UPSELL_ACKNOWLEDGEMENT"
		end

		if n340 == 66 then
			return "ACTION_TYPE_OPEN_SEARCH_RESULTS_WITH_QUERY"
		end

		if n340 == 67 then
			return "ACTION_TYPE_SELECT_MARKETPLACE_FAVORITES_CATEGORY"
		end

		if n340 == 68 then
			return "ACTION_TYPE_DOWNLOAD_APP"
		end

		if n340 == 69 then
			return "ACTION_TYPE_REFRESH_CHARTS_SORT_DETAIL"
		end

		if n340 == 70 then
			return "ACTION_TYPE_JOIN_COMMUNITY"
		end

		if n340 == 71 then
			return "ACTION_TYPE_VIEW_COMMUNITY"
		end

		if n340 == 72 then
			return "ACTION_TYPE_PIN_EXPERIENCE_SHORTCUT"
		end

		if n340 == 73 then
			return "ACTION_TYPE_SELECT_MARKETPLACE_FAVORITES_SUBCATEGORY"
		end

		if n340 == 74 then
			return "ACTION_TYPE_SHOW_TOAST"
		end

		if n340 == 75 then
			return "ACTION_TYPE_OPEN_INCOMING_TRANSFER_UPSELL"
		end

		return nil
	end,
	toNumber = function(p514) -- line: 33014
		if p514 == "ACTION_TYPE_INVALID" then
			return 0
		end

		if p514 == "ACTION_TYPE_DISMISS_DIALOG" then
			return 1
		end

		if p514 == "ACTION_TYPE_LINK" then
			return 2
		end

		if p514 == "ACTION_TYPE_OPEN_GAME_DETAILS" then
			return 3
		end

		if p514 == "ACTION_TYPE_OPEN_JOIN_FRIENDS" then
			return 4
		end

		if p514 == "ACTION_TYPE_OPEN_MARKETPLACE_TRY_ON" then
			return 5
		end

		if p514 == "ACTION_TYPE_OPEN_SEE_ALL" then
			return 6
		end

		if p514 == "ACTION_TYPE_OPEN_SPONSORED_TOOLTIP" then
			return 7
		end

		if p514 == "ACTION_TYPE_PLAY_BUTTON_CLICK" then
			return 8
		end

		if p514 == "ACTION_TYPE_UPDATE_USER_SETTINGS" then
			return 9
		end

		if p514 == "ACTION_TYPE_OPEN_TOOLTIP" then
			return 10
		end

		if p514 == "ACTION_TYPE_OPEN_BADGE_DETAILS" then
			return 11
		end

		if p514 == "ACTION_TYPE_LOAD_MORE_FROM_API" then
			return 12
		end

		if p514 == "ACTION_TYPE_SHARE" then
			return 13
		end

		if p514 == "ACTION_TYPE_OPEN_ABUSE_REPORT" then
			return 14
		end

		if p514 == "ACTION_TYPE_REMOVE_BADGE_FROM_INVENTORY" then
			return 15
		end

		if p514 == "ACTION_TYPE_OPEN_PROFILE" then
			return 16
		end

		if p514 == "ACTION_TYPE_OPEN_FACIAL_AGE_ESTIMATION" then
			return 17
		end

		if p514 == "ACTION_TYPE_OPEN_ADD_CONNECTIONS_PAGE" then
			return 18
		end

		if p514 == "ACTION_TYPE_OPEN_MARKETPLACE" then
			return 19
		end

		if p514 == "ACTION_TYPE_HIDE_PROFILE_COMPLETION" then
			return 20
		end

		if p514 == "ACTION_TYPE_SELECT_MARKETPLACE_CATALOG_CATEGORY" then
			return 21
		end

		if p514 == "ACTION_TYPE_SELECT_MARKETPLACE_CATALOG_SUBCATEGORY" then
			return 22
		end

		if p514 == "ACTION_TYPE_OPEN_MARKETPLACE_CATALOG_SEE_ALL" then
			return 23
		end

		if p514 == "ACTION_TYPE_CLOSE_MARKETPLACE_CATEGORY_TOOLTIP" then
			return 24
		end

		if p514 == "ACTION_TYPE_RESIZE_MARKETPLACE_CATALOG" then
			return 25
		end

		if p514 == "ACTION_TYPE_OPEN_MARKETPLACE_CATALOG_FILTERS" then
			return 26
		end

		if p514 == "ACTION_TYPE_OPEN_SOCIAL_LINK" then
			return 27
		end

		if p514 == "ACTION_TYPE_OPEN_CHARTS_SORT_DETAIL" then
			return 28
		end

		if p514 == "ACTION_TYPE_OPEN_SONG_DETAIL" then
			return 29
		end

		if p514 == "ACTION_TYPE_REFRESH_FROM_API" then
			return 30
		end

		if p514 == "ACTION_TYPE_RSVP_TO_EVENT" then
			return 31
		end

		if p514 == "ACTION_TYPE_APPLY_CHARTS_FILTER" then
			return 32
		end

		if p514 == "ACTION_TYPE_ANALYTICS_EVENT" then
			return 33
		end

		if p514 == "ACTION_TYPE_CUSTOM_ANALYTICS_EVENT" then
			return 34
		end

		if p514 == "ACTION_TYPE_OPEN_GAME_INVITE" then
			return 35
		end

		if p514 == "ACTION_TYPE_OPEN_EVENT_DETAILS" then
			return 36
		end

		if p514 == "ACTION_TYPE_LAUNCH_EXPERIENCE" then
			return 37
		end

		if p514 == "ACTION_TYPE_TOGGLE_EXPERIENCE_FAVORITE" then
			return 38
		end

		if p514 == "ACTION_TYPE_TOGGLE_EXPERIENCE_FOLLOW" then
			return 39
		end

		if p514 == "ACTION_TYPE_TOGGLE_EXPERIENCE_VOTE" then
			return 40
		end

		if p514 == "ACTION_TYPE_OPEN_PURCHASE_PROMPT" then
			return 41
		end

		if p514 == "ACTION_TYPE_OPEN_SDUI_OVERLAY" then
			return 42
		end

		if p514 == "ACTION_TYPE_OPEN_BADGES_SEE_ALL" then
			return 43
		end

		if p514 == "ACTION_TYPE_OPEN_EXPERIENCE_STORE_SEE_ALL" then
			return 44
		end

		if p514 == "ACTION_TYPE_DISMISS_GAME_FEEDBACK" then
			return 45
		end

		if p514 == "ACTION_TYPE_OPEN_GAME_FEEDBACK_FORM" then
			return 46
		end

		if p514 == "ACTION_TYPE_ENABLE_EVENT_NOTIFICATIONS" then
			return 47
		end

		if p514 == "ACTION_TYPE_DISMISS_EVENT_NOTIFICATIONS_MODAL" then
			return 48
		end

		if p514 == "ACTION_TYPE_OPEN_AMP_WIZARD" then
			return 49
		end

		if p514 == "ACTION_TYPE_OPEN_SUBSCRIPTION_PURCHASE_PAGE" then
			return 50
		end

		if p514 == "ACTION_TYPE_REFRESH_GAME_PASSES" then
			return 51
		end

		if p514 == "ACTION_TYPE_REFRESH_PLAYABILITY" then
			return 52
		end

		if p514 == "ACTION_TYPE_OPEN_SOCIAL_PROOF_USER_LIST_SHEET" then
			return 53
		end

		if p514 == "ACTION_TYPE_REPORT_SURFACE_LOAD_TIME_MILESTONE" then
			return 54
		end

		if p514 == "ACTION_TYPE_OPEN_SEARCH_RESULTS_TAB" then
			return 55
		end

		if p514 == "ACTION_TYPE_OPEN_PHONE_UPSELL_MODAL" then
			return 56
		end

		if p514 == "ACTION_TYPE_OPEN_EMAIL_UPSELL_MODAL" then
			return 57
		end

		if p514 == "ACTION_TYPE_DISMISS_PROMPT" then
			return 58
		end

		if p514 == "ACTION_TYPE_REQUEST_FRIENDSHIP" then
			return 59
		end

		if p514 == "ACTION_TYPE_REFRESH_DEVELOPER_PRODUCTS" then
			return 60
		end

		if p514 == "ACTION_TYPE_OPEN_FAE_TRIAL_UPSELL" then
			return 61
		end

		if p514 == "ACTION_TYPE_REFRESH_OMNI_RECOMMENDATION_FEED_ITEM" then
			return 62
		end

		if p514 == "ACTION_TYPE_AI_OVERVIEW_FEEDBACK" then
			return 63
		end

		if p514 == "ACTION_TYPE_OPEN_TRUSTED_FRIENDS_UPSELL_MODAL" then
			return 64
		end

		if p514 == "ACTION_TYPE_RECORD_PARTY_CHAT_CONVERSATION_UPSELL_ACKNOWLEDGEMENT" then
			return 65
		end

		if p514 == "ACTION_TYPE_OPEN_SEARCH_RESULTS_WITH_QUERY" then
			return 66
		end

		if p514 == "ACTION_TYPE_SELECT_MARKETPLACE_FAVORITES_CATEGORY" then
			return 67
		end

		if p514 == "ACTION_TYPE_DOWNLOAD_APP" then
			return 68
		end

		if p514 == "ACTION_TYPE_REFRESH_CHARTS_SORT_DETAIL" then
			return 69
		end

		if p514 == "ACTION_TYPE_JOIN_COMMUNITY" then
			return 70
		end

		if p514 == "ACTION_TYPE_VIEW_COMMUNITY" then
			return 71
		end

		if p514 == "ACTION_TYPE_PIN_EXPERIENCE_SHORTCUT" then
			return 72
		end

		if p514 == "ACTION_TYPE_SELECT_MARKETPLACE_FAVORITES_SUBCATEGORY" then
			return 73
		end

		if p514 == "ACTION_TYPE_SHOW_TOAST" then
			return 74
		end

		if p514 == "ACTION_TYPE_OPEN_INCOMING_TRANSFER_UPSELL" then
			return 75
		end

		return p514
	end,
	fromName = function(s1: string) -- line: 33172
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
